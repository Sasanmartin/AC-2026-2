# Cheatsheet 3 — I/O (P3)

> **Lo que se pregunta:** comparar memory-mapped vs port-mapped, explicar el address decoder,
> polling vs interrupciones vs DMA, y **describir por estados/comandos** un código RISC-V que
> maneja un dispositivo.

## 1. Memory-mapped vs port-mapped

| | **Memory-mapped I/O** | **Port-mapped / isolated I/O** |
|---|---|---|
| Espacio de direcciones | El mismo que la RAM. | Espacio **separado** de I/O. |
| Instrucciones | Las normales: `lw`, `sw`, `lb`, `sb`. | Especiales: `IN`, `OUT` (x86). |
| Decodificación | Address decoder distingue RAM vs dispositivo por la dirección. | La CPU distingue por un **pin** o bus de I/O separado. |
| ISA | No hay que cambiar la ISA. | Hay que agregar instrucciones o un modo de I/O. |
| Ventaja | Simple, flexible, funciona con cualquier instrucción de load/store. | No consume espacio de memoria; puede ser más rápido para device registers. |
| Desventaja | Ocupa direcciones de memoria; puede chocar con RAM. | Menos flexible; requiere hardware/ISA especial. |
| Uso típico | **RISC-V**, ARM, la mayoría de sistemas embebidos. | **x86** (histórico). |

> En RISC-V **no existen `IN`/`OUT`**: todo I/O es **memory-mapped**. Por eso el código de la P3
> usa `lw`/`sw` con una dirección base y offsets.

### ¿Por qué memory-mapped simplifica el hardware?

Porque el CPU sigue haciendo exactamente lo mismo: pone una dirección en el bus, activa lectura o
escritura y mueve datos. El **address decoder** decide si esa dirección pertenece a RAM o a un
dispositivo. No hay que agregar instrucciones ni un bus separado.

## 2. Address decoder

El decoder está entre el bus de direcciones/control y la RAM + dispositivos.

**Entradas:**
- Dirección (`Address`).
- Señal de escritura/lectura (`W`, `Read`).
- A veces `Request`/`Valid`.

**Salidas:**
- `Chip Select` de la RAM.
- `Chip Select` de cada dispositivo.
- Selección del registro interno del dispositivo (status, data, control).

**Funcionamiento:**
1. Compara la dirección con el rango asignado a cada dispositivo.
2. Activa solo el `Chip Select` correspondiente.
3. Si es escritura, habilita la escritura del registro; si es lectura, pone el dato en el bus.

**¿Por qué va solo ahí?** Porque es el único punto donde se decide **a quién va dirigida** la
operación. El resto del CPU no necesita saber si habla con RAM o con un dispositivo: sigue
ejecutando `lw`/`sw` normalmente. Si el decoder estuviera en otro lado, habría que duplicar lógica
de selección en el datapath.

## 3. Polling (consulta repetida)

La CPU **pregunta en un loop** si el dispositivo está listo:

```text
loop:
    leer status
    si no está listo → volver a loop
    leer/escribir dato
```

- **Ventaja:** no requiere hardware de interrupciones; simple.
- **Desventaja:** la CPU **desperdicia ciclos** esperando; no puede hacer otra cosa.
- **Cuándo conviene:** dispositivos simples, lentos o de baja frecuencia; sistemas donde el CPU
  no tiene otra tarea. **USB usa polling** del host sobre el bus.
- **Cuándo no conviene:** disco, red, teclado en un sistema multiusuario; ahí se usan interrupciones
  o DMA.

## 4. Interrupciones

### Idea

El dispositivo **avisa** a la CPU cuando necesita atención. La CPU termina la instrucción actual,
guarda su estado y salta a una **rutina de servicio de interrupción (ISR)**. Al terminar, vuelve
exactamente a donde estaba.

### Pasos (sin controlador dedicado)

1. El dispositivo activa `IRQ`.
2. La CPU termina la instrucción actual y **guarda las condition codes**.
3. Revisa `IF` (Interrupt Flag):
   - `IF = 0` → la interrupción queda pendiente o se ignora.
   - `IF = 1` → continúa.
4. `IF = 0` para evitar interrupciones anidadas (si no se permiten).
5. Guarda el estado (PC, registros) y salta a la ISR.
6. La ISR guarda los registros que va a usar.
7. Ejecuta el servicio (leer dato, escribir comando, limpiar flag).
8. Restaura registros.
9. `IRET`/`RET` vuelve a la instrucción siguiente.
10. `IF = 1` y se restauran las condition codes.

### Pasos (con controlador de interrupciones)

1. Dispositivo activa `IRQ`.
2. El controlador revisa **máscara** y **prioridad**.
3. Si corresponde, activa `INT` hacia la CPU y marca el pedido como **in-service**.
4. La CPU termina la instrucción, guarda estado y activa `INTA` (Interrupt Acknowledge).
5. El controlador entrega el **ID** del dispositivo de mayor prioridad.
6. La CPU usa el ID para indexar la **tabla de vectores** y saltar a la ISR.
7. La ISR atiende y escribe **EOI** (End Of Interrupt) al controlador.
8. El controlador limpia el bit in-service y puede atender el siguiente.

### Señales y conceptos

| Concepto | Qué hace |
|---|---|
| `IRQ` | Pedido del dispositivo. |
| `INT` | Pedido del controlador hacia la CPU. |
| `INTA` | La CPU acepta y pide el ID. |
| `ID` | Número/vector del dispositivo. |
| **Máscara** | Permite/bloquea interrupciones por dispositivo. |
| **Prioridad** | Decide cuál se atiende primero si hay varias. |
| **In-service** | Marca que una interrupción está siendo atendida. |
| **EOI** | La ISR avisa que terminó. |
| **IF** | Flag global que habilita/deshabilita interrupciones. |
| **Vector table** | Arreglo de direcciones de ISR indexado por ID. |

### Tipos

- **Externa / hardware:** la genera un dispositivo (teclado, disco, timer).
- **Interna / software:** `ecall`, `INT n`, traps.
- **Excepción:** síncrona, causada por la instrucción actual (división por cero, acceso inválido,
  desbordamiento, instrucción ilegal).

### Ventajas y desventajas

- **Ventaja:** la CPU no espera; atiende solo cuando hace falta.
- **Desventaja:** más hardware (controlador, vectores), más complejidad, latencia e impredecibilidad.
- **Latencia de interrupción:** tiempo desde `IRQ` hasta la primera instrucción de la ISR. Aumenta si
  `IF=0`, si hay una instrucción larga o si hay varias interrupciones de mayor prioridad.

## 5. DMA (Direct Memory Access)

El **controlador DMA** mueve datos entre memoria y dispositivo **sin que la CPU copie byte por byte**.

### Funcionamiento

1. La CPU programa el DMA:
   - dirección de origen,
   - dirección de destino,
   - cantidad de words/bytes,
   - dirección (lectura/escritura),
   - modo (burst o cycle stealing).
2. La CPU le dice “parte” y sigue ejecutando.
3. El DMA pide el bus de memoria (o lo toma por ciclos).
4. Transfiere los datos.
5. Al terminar, genera una **interrupción** para avisar.

### Modos

- **Burst:** el DMA toma el bus y transfiere un bloque completo; la CPU queda bloqueada.
- **Cycle stealing:** el DMA “roba” ciclos de memoria entre accesos de la CPU; más lento pero no
  bloquea.

### Ventajas / desventajas

- **Ventaja:** libera a la CPU de copiar datos; ideal para discos, red, audio, video.
- **Desventaja:** hardware extra; compite por el bus; puede complicar la coherencia de caché.

> En este curso, DMA se usa con **I/O mapeada en memoria**, porque el controlador necesita
> direcciones de memoria para leer/escribir.

## 6. Programmed I/O vs DMA

| | **Programmed I/O (PIO)** | **DMA** |
|---|---|---|
| Quién mueve los datos | La CPU, con `lw`/`sw`. | El controlador DMA. |
| Uso de CPU | Alto (loop de polling o ISR). | Bajo (solo programa y atiende el final). |
| Velocidad | Limitada por la CPU. | Alta. |
| Complejidad | Baja. | Alta. |
| Uso típico | Dispositivos lentos/simples. | Discos, red, audio, video. |

## 7. I/O en RISC-V

### Direcciones y offsets

- Los registros de un dispositivo suelen ser de **32 bits** → cada uno ocupa **4 bytes**.
- Si la base es `0x00FF10AD`, los registros están en `base+0`, `base+4`, `base+8`, ...
- En RISC-V no se puede hacer `lw t0, t1`: el load/store usa **offset(base)**:
  `lw t0, 0(t1)`, `sw t2, 4(t1)`.

### Patrón de polling

```asm
# t0 = dirección base del dispositivo
loop:
    lw   t1, 0(t0)       # lee status
    andi t1, t1, 1       # bit 0 = "listo"
    beq  t1, zero, loop  # si no está listo, espera
    lw   t2, 4(t0)       # lee dato
    sw   t2, 8(t0)       # escribe comando / dato
    j    loop
```

### Patrón con interrupción (conceptual)

```asm
# La ISR:
    lw   t1, 0(t0)       # status
    lw   t2, 4(t0)       # dato
    sw   t2, 8(t0)       # respuesta
    sw   zero, 12(t0)    # limpiar flag / EOI
    mret                 # o ret, según el sistema
```

### Cómo describir el código (lo que pide la P3)

No traduzcas línea por línea. Describe **estados y comandos**:

1. **Estado inicial:** “El programa configura la base del dispositivo y entra en espera.”
2. **Estado de espera:** “Lee el registro de status y repite mientras el bit de ‘listo’ sea 0.”
3. **Estado de lectura:** “Cuando está listo, lee el dato desde `base+4`.”
4. **Estado de comando:** “Escribe una orden en `base+8` para mover el robot / imprimir.”
5. **Estado de repetición:** “Vuelve a esperar el siguiente dato.”
6. Si hay varios `step_*`, nómbralos: `step_wait`, `step_read`, `step_write`, `step_error`.

**Ejemplo de frase:** “`step_wait` consulta el bit 0 de status; cuando vale 1, `step_read` lee el
byte de dato y `step_cmd` escribe el comando en el registro de control. Luego vuelve a `step_wait`.”

## 8. Preguntas cortas que suelen caer

| Pregunta | Respuesta |
|---|---|
| ¿Por qué RISC-V usa memory-mapped? | Porque no tiene instrucciones `IN`/`OUT`; usa `lw`/`sw` normales. |
| ¿Qué hace el address decoder? | Selecciona RAM o dispositivo según la dirección y el tipo de acceso. |
| ¿Dónde va el decoder? | Entre el bus y la memoria/dispositivos; es el único punto de selección. |
| ¿Polling vs interrupción? | Polling espera activamente; interrupción avisa y libera a la CPU. |
| ¿Qué es una ISR? | Rutina que atiende la interrupción. |
| ¿Qué pasa si `IF=0`? | La interrupción no se atiende (queda pendiente o se pierde). |
| ¿Qué hace el controlador? | Arbitra prioridades, enmascara, entrega el ID y maneja EOI. |
| ¿DMA para qué sirve? | Mover bloques sin que la CPU copie dato por dato. |
| ¿DMA burst vs cycle stealing? | Burst toma el bus; cycle stealing intercala ciclos. |
| ¿Se puede hacer DMA con port-mapped? | En este curso no: se usa con memory-mapped. |

## 9. Errores típicos

- Decir que memory-mapped “no ocupa memoria”: sí ocupa direcciones.
- Confundir port-mapped con memory-mapped.
- Creer que el address decoder está dentro de la ALU o del CPU: está en el bus.
- Decir que polling es “más rápido” que interrupciones: puede ser más simple, pero desperdicia CPU.
- Olvidar que la ISR debe **limpiar el flag** o hacer **EOI**; si no, la interrupción se repite.
- No guardar/restaurar registros en la ISR.
- Usar `lw t0, t1` en RISC-V: falta `offset(base)`.
- Usar offsets de 1 byte cuando los registros son de 4 bytes.
- Describir el código RISC-V línea por línea en vez de por estados/comandos.
- Ignorar el bit de status y leer el dato antes de que esté listo.
