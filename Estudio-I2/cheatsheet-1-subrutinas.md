# Cheatsheet 1 — Subrutinas en el computador básico (P1)

> **Lo que se pregunta:** implementar 1–3 instrucciones nuevas (hardware + tabla de señales),
> y simular 2 fragmentos de código con `CALL`, `RET`, `PUSH`, `POP` y stack.

## 1. Idea y requisitos

Una subrutina necesita:

1. **Parámetros de entrada** → en este curso se guardan en **memoria/stack** (los registros A y B no alcanzan).
2. **Valor de retorno** → también en memoria/stack.
3. **Llamada y retorno** → hay que guardar la **dirección de retorno** (`PC+1`) para poder volver.

El stack permite llamadas anidadas y recursión sin que las variables choquen.

## 2. Layout de memoria y stack

```text
Direcciones bajas
┌─────────────────────────────┐
│ DATA / variables            │
├─────────────────────────────┤
│ ...                         │
│ stack (crece hacia abajo)   │
│ SP+1 = tope del stack       │
│ SP   = próximo espacio libre│
└─────────────────────────────┘
Dirección 255 = primera celda del stack
```

- `SP` parte en **255**.
- `PUSH`: `Mem[SP] ← valor; SP ← SP−1`.
- `POP`: `SP ← SP+1; valor ← Mem[SP]`.
- `CALL`: `Mem[SP] ← PC+1; SP ← SP−1; PC ← label`.
- `RET`: `SP ← SP+1; PC ← Mem[SP]`.
- Por eso `SP` apunta al **siguiente espacio libre**, y el tope real es `SP+1`.
- Si el stack crece demasiado y choca con las variables → **stack overflow**.

## 3. Modificaciones de hardware típicas

| Componente | Para qué sirve |
|---|---|
| **Mux DataIn** (`SDIn`) | Elegir qué se escribe en memoria: resultado de la ALU o `PC+1` (para `CALL`). |
| **Mux PC** (`SPC`) | Elegir qué se carga en PC: literal/label (`LIT`) o dato de memoria (`DOUT`, para `RET`). |
| **Mux Address** (`SAdd`) | Elegir la dirección de memoria: `LIT`, `B`, `SP` o `ADDER`. Necesita 2 bits si hay 3–4 entradas. |
| **Mux Adder** (`SAdder`) | Elegir la entrada del Adder: `PC` o `SP`. Permite calcular `PC+1` o `SP+1`. |
| **SP + `IncSP` / `DecSP`** | Incrementar/decrementar el stack pointer. |
| **Registro RA** (opcional, 2024-2) | Guardar la dirección de retorno en un registro (`LRA`, `SRA`) en vez del stack. |

### El truco del `SP+1`

`SP` apunta al próximo espacio libre, pero el tope del stack es `SP+1`.
Para leer o escribir el tope **sin mover SP** se usa:

- `SAdder = SP` → el Adder calcula `SP+1`.
- `SAdd = ADDER` → se usa `SP+1` como dirección de memoria.

Esto es lo que permite `RET1`, `PUSHRW`, `POPRD` y `POP1` en **un solo ciclo**.

## 4. Semántica y señales de las instrucciones

Convención: en cargas/escrituras `1` = activo, `0` = inactivo; en selecciones, el **nombre**
de la entrada (`LIT`, `SP`, `DOUT`, `ALU`, `ADDER`, `ZERO`, `B`, etc.) o `-` si no importa.

| Instrucción | Operación | Ciclos | Señales principales |
|---|---|---|---|
| `CALL label` | `Mem[SP] ← PC+1; SP−−; PC ← label` | 1 | `W=1, DecSP=1, SAdd=SP, SDIn=PC+1, SPC=LIT, LPC=1, SAdder=PC` |
| `RET` | `SP++; PC ← Mem[SP]` | 2 | Ciclo 1: `IncSP=1` · Ciclo 2: `SAdd=SP, SPC=DOUT, LPC=1` |
| `PUSH A` | `Mem[SP] ← A; SP−−` | 1 | `W=1, DecSP=1, SAdd=SP, SDIn=ALU, SA=A, SB=ZERO, SOP=ADD` |
| `PUSH B` | `Mem[SP] ← B; SP−−` | 1 | igual, con `SB=B` (o `SA=B`) según el mux |
| `POP A` | `SP++; A ← Mem[SP]` | 2 | Ciclo 1: `IncSP=1` · Ciclo 2: `SAdd=SP, LA=1, SA=ZERO, SB=DOUT, SOP=ADD` |
| `POP B` | `SP++; B ← Mem[SP]` | 2 | igual, con `LB=1` |
| `RET1` | `PC ← Mem[SP+1]; SP++` en 1 ciclo | 1 | `LPC=1, IncSP=1, SAdd=ADDER, SAdder=SP, SPC=DOUT` |
| `PUSHRW A` | `Mem[SP+1] ← A` sin mover SP | 1 | `W=1, SAdd=ADDER, SAdder=SP, SDIn=ALU, SA=A, SB=ZERO, SOP=ADD` |
| `POPRD A` | `A ← Mem[SP+1]` sin mover SP | 1 | `LA=1, SAdd=ADDER, SAdder=SP, SA=ZERO, SB=DOUT, SOP=ADD` |
| `POP1 A` | `SP++; A ← Mem[SP]` en 1 ciclo | 1 | `LA=1, IncSP=1, SAdd=ADDER, SAdder=SP, SA=ZERO, SB=DOUT, SOP=ADD` |
| `MOV A,SP` | `A ← SP` | 1 | `LA=1, SA=SP, SB=ZERO, SOP=ADD` |
| `CMP B,SP` | `B − SP`, solo flags | 1 | `SA=B, SB=SP, SOP=SUB` (todos los loads en 0) |

> **Ojo:** los nombres exactos de las entradas de los mux dependen del diagrama que entregue
> el enunciado. La pauta acepta la combinación coherente; lo importante es que la operación
> se ejecute en **un ciclo** y que la tabla sea completa.

## 5. Patrón para implementar una instrucción nueva

1. **¿Qué falta?** ¿Un dato que no llega a la ALU? ¿Una dirección que el Mux Address no puede elegir?
   ¿Un registro nuevo? ¿Un valor que hay que escribir en memoria?
2. **Modificación mínima:**
   - Nuevo registro `R` → señal `LR`.
   - Nueva entrada a un mux → agregar entrada y ampliar el selector (`SA`, `SB`, `SPC`, `SAdd`).
   - Nuevo dato a memoria → conectar al `Mux DataIn` y usar `SDIn`.
   - Necesitas `SP+1` → usar `Mux Adder` + `SAdder=SP`.
3. **Completa la fila:** `LA, LB, LPC, IncSP, DecSP, W, SA, SB, SOP, SAdd, SDIn, SPC, SAdder`.
4. **¿Se puede sin hardware?** Si sí, dilo explícitamente y usa las señales existentes.
   Si no, indica **una sola** modificación que habilite todas las instrucciones del enunciado.
5. **Verifica los ciclos:** el enunciado suele exigir **1 ciclo**. Si tu solución necesita 2,
   probablemente haya que agregar el Mux Adder o conectar una salida a un mux.

### Ejemplo de razonamiento: `RET1` en 1 ciclo

`RET` normal necesita 2 ciclos porque primero hay que hacer `SP++` y después leer `Mem[SP]`.
Para hacerlo en 1 ciclo:

- El Adder calcula `SP+1` (con `SAdder=SP`).
- El Mux Address elige `ADDER` (`SAdd=ADDER`).
- El Mux PC elige `DOUT` (`SPC=DOUT`).
- `IncSP=1` actualiza SP al mismo tiempo.

Así se lee `Mem[SP+1]` y se carga en PC en el mismo ciclo. **Esa es la idea que más se repite.**

## 6. Método de simulación (para “indique A y B al final”)

1. Copia las **direcciones** que da el enunciado. No inventes direcciones.
2. Haz una tabla por instrucción:

   `# | Instr | A | B | Mem afectada | SP | PC | flags`

3. Respeta el tamaño de cada instrucción en el listado:

   | Instrucción | Celdas típicas |
   |---|---|
   | `MOV`, `ADD`, `SUB`, `CMP`, `JMP`, saltos condicionales | 1 |
   | `CALL`, `PUSH` | 1 |
   | `POP`, `RET` | 2 |

   > Usa siempre las direcciones del enunciado; la tabla anterior es solo una referencia.

4. `CALL` guarda **PC+1** (la dirección de la instrucción siguiente). Si `CALL` está en `0x04`,
   guarda `0x05`, no `0x04`.
5. `RET` hace `SP++` y salta a `Mem[SP]`. Si alguien sobrescribió esa celda, salta a otra parte.
6. Las flags las actualiza la **última** operación que las modifique. Un `CMP` seguido de otra
   instrucción que cambie flags puede arruinar el salto condicional.
7. `MOV (B),A` escribe en `Mem[B]`. Si `B` apunta al stack, puedes pisar la dirección de retorno.
8. `JMP (B)` salta a `Mem[B]`; `JMP B` salta a `B` (si la instrucción existe).
9. Al final, revisa **A, B, SP y la memoria relevante**; el enunciado suele pedir solo A y B,
   pero el desarrollo debe justificar cómo llegaste.

## 7. Ejemplo resuelto — pisar la dirección de retorno (I2 2026-1)

```asm
MOV A,2
MOV B,5
PUSH A          ; Mem[255]=2, SP=254
PUSH B          ; Mem[254]=5, SP=253
CALL mystery    ; Mem[253]=0x05, SP=252
POP B           ; no se ejecuta
POP A           ; no se ejecuta
JMP end
mystery:
MOV A,0
NOT A,A         ; A=255
SUB A,2         ; A=253
MOV B,A         ; B=253
MOV A,(B)       ; A=Mem[253]=0x05=5
ADD A,4         ; A=9
MOV (B),A       ; Mem[253]=9
RET             ; SP=253, PC=Mem[253]=9 → JMP end
end:
```

Resultado: **A = 9, B = 253**. La subrutina no vuelve a `POP B`, sino que salta a `JMP end`
porque sobrescribió su propia dirección de retorno. Este patrón aparece mucho.

## 8. Errores que más castigan

- Poner `LPC=1` por defecto en instrucciones que no saltan.
- Olvidar `W=1` cuando se escribe memoria.
- Confundir `PUSH` (escribe y luego decrementa) con `POP` (incrementa y luego lee).
- Decir que `RET` es de 1 ciclo sin agregar el Mux Adder.
- No conectar `SP` al Mux A o al Mux B y aun así usar `MOV A,SP` o `CMP B,SP`.
- No indicar la condición en saltos condicionales (`LPC` depende de `Z/N`, no es 1 fijo).
- Olvidar que `CALL` guarda `PC+1`, no `PC`.
- No revisar si el código pisa el stack con `MOV (B),A` o `PUSH`.
- En la simulación, saltarse instrucciones que no se ejecutan: **marca explícitamente “no se ejecuta”**.
