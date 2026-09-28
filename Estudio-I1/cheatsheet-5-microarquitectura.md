# Cheatsheet 5 — Microarquitectura / señales de control (P3, bonus)

> Solo si sobra tiempo (es lo más difícil y de menor retorno en 1-2 días).

## 1. Idea
Cada instrucción = una combinación de **señales de control** que la Unidad de Control activa en un ciclo. Las preguntas típicas piden: **agregar una instrucción** → modificar el diagrama + entregar la **tabla de señales**.

## 2. Señales típicas (diagrama del computador básico)
| Señal | Función |
|---|---|
| LA / LB / LPC | Cargar registro A / B / Program Counter (1 = activo) |
| W | Escribir en memoria de datos |
| IncSP / DecSP | Incrementar / decrementar puntero de stack |
| SA (SA0,SA1), SB | Selección de entrada de los mux A y B (A, B, LIT, ZERO, DOUT...) |
| SOP | Operación ALU (ADD, SUB, AND, XOR, NOT...) |
| SAdd | Selección de dirección de memoria (LIT, B, SP...) |
| SDin | Selección del dato a escribir en memoria |
| SPC | Selección del mux del PC (siguiente, LIT, DOUT...) |
| Condición | En saltos: la carga de PC depende de una flag (ej. `Z=1`) |

Convención de respuestas: en cargas/escrituras poner `1`/`0`; en selecciones poner el **nombre** de la entrada (o `-` si no afecta).

## 3. Patrón para agregar una instrucción
1. **Identifica qué señal falta** (ej. cargar un registro nuevo, seleccionar una entrada nueva en un mux).
2. **Modificación típica**:
   - Nuevo registro `R` → nueva señal de carga `LR`.
   - Nueva entrada a un mux → ampliar selector (ej. `SPC` de 1 a 2 bits, `SB` agregando `SB2`).
   - Conectar salida ALU / memoria / SP al mux correspondiente.
3. **Completa la fila de señales**: para instrucciones simples = 1 ciclo (La/Lb/Lpc = 0, salvo que cargue algo; W = 0 salvo que escriba memoria).
4. A veces la instrucción **se puede hacer sin modificar hardware** con 2 ciclos (ej. `MOV B,((Dir))` = `MOV B,(Dir)` + `MOV B,(B)`; o `NEG A` = `NOT` + `ADD A,1`). ¡Indícalo si aplica!

## 4. Ejemplo resuelto (patrón)
Instrucción **`JMP B`** (I1 2022-1):
- **Modificación**: conectar salida del registro B a una entrada del Mux PC (o conectar salida de la ALU al Mux PC). Si el mux ya no tiene entradas → ampliar SPC.
- **Señales**: `LA=0 LB=0 LPC=1 W=0 IncSP=0 DecSP=0 SA=ZERO SB=B SOP=ADD SAdd=- SDin=- SPC=B`.

Instrucción **`DEC B`** (I1 2022-1), sin modificar hardware, 1 ciclo:
- Seleccionar B en el mux A, `ADD` con LIT `-1`, cargar B: `LA=0 LB=1 SA=B SB=LIT SOP=ADD`.

## 4b. Ejemplos de la I1 real de 2026-1
- **`SUB B,B,A`** (B ← B − A): requiere conectar B al Mux A y A al Mux B (ampliar SA y SB, y la salida de la Control Unit). Señales: `LA=0 LB=1 LPC=0 W=0 SA=B SB=A SOP=SUB SAdd=-`.
- **`ADD (B),Lit`** (Mem[B] ← Mem[B] + Lit): conectar la salida de Data Memory (DOUT) al Mux A (ampliar SA). Señales: `LA=0 LB=0 LPC=0 W=1 SA=DOUT SB=LIT SOP=ADD SAdd=B`.
- **`RESTART`** (PC ← 0): **sin modificar hardware**; usar `LPC=1` con literal 0 (`SPC=LIT`, LIT=0), o agregar señal `RPC` al reset del PC.
- Observación: si el mux no tiene entradas libres, se amplía su selector (SA/SB/SPC a más bits) y la salida de la Control Unit crece en esa cantidad de bits.

## 5. Errores comunes a evitar
- Dejar `Lpc=1` por defecto en instrucciones que no saltan (debe ser 0).
- No activar `W` cuando se escribe memoria (y al revés).
- Olvidar indicar la condición en saltos condicionales (`LPC` depende de `Z`/`N`, no es 1 fijo).
- Modificar hardware cuando no hace falta (indicar los 2 ciclos con señales existentes).
