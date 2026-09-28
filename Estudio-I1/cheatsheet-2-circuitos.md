# Cheatsheet 2 — Circuitos digitales (P2)

## 1. Compuertas lógicas básicas
| Compuerta | Salida = 1 si... |
|---|---|
| NOT | entrada = 0 |
| AND | ambas = 1 |
| OR | al menos una = 1 |
| XOR | ambas distintas |
| NAND | NO(AND) = 0 solo si ambas = 1 |
| NOR | NO(OR) = 1 solo si ambas = 0 |

## 2. Tabla de verdad → circuito (minterms y maxterms)
Procedimiento fijo para "diseñe el circuito":
1. Hacer la tabla de verdad.
2. **Minterms** (fila = 1): `NOT` las variables en 0, `AND` las de cada fila, `OR` todas.
3. **Maxterms** (fila = 0): `NOT` las variables en 1, `OR` las de cada fila, `AND` todas.
4. Simplificar con álgebra booleana si piden circuito reducido.

```
A B C | Out
0 0 1 |  1      Out = (NOT A AND NOT B AND C)
1 0 1 |  1            OR (A AND NOT B AND C)
1 1 1 |  1            OR (A AND B AND C)
```

## 3. Sumador y restador
- **Half Adder (HA)**: `S = A XOR B`, `Cout = A AND B`.
- **Full Adder (FA)**: dos HA + OR: `S = A XOR B XOR Cin`, `Cout = c1 OR c2`.
- **Sumador de n bits**: n FA encadenados por Cin.
- **Sumador-Restador**: con XOR y `Cin` como control. `Cin=0 → A+B`, `Cin=1 → A−B` (B se niega y se suma 1).
- **Restador**: sumar el complemento a 2 del sustraendo.

## 4. Circuitos de control
- **Enabler**: AND con señal E → pasa el dato si E=1, saca 0 si E=0.
- **Multiplexor (Mux)**: S selecciona entre entradas. `2 a 1`: `M = (NOT S AND A) OR (S AND B)`. 4 a 1 usa S1,S0.
- **Demux**: S dirige la entrada a una de varias salidas.

## 5. Flags de la ALU
Z (resultado = 0), N (resultado negativo), C (carry/bit descartado), O (overflow). Se guardan en el registro Status para los saltos.

## 6. Circuitos secuenciales — Contador con flip-flops D (¡muy frecuente!)
Patrón para contadores de 2 o 3 bits (I1 2024-2, 2025-1, 2025-2):
1. Definir la tabla de verdad del siguiente estado `Q(t+1)` según el estado `Q(t)`.
2. Derivar la expresión de cada bit (ej. contador que incrementa):
   - `Q0(t+1) = NOT Q0`
   - `Q1(t+1) = Q0 XOR Q1`
   - `Q2(t+1) = (Q0 AND Q1) XOR Q2`
3. Conectar cada salida a su flip-flop D y las compuertas a los `D`.

**Con condición** (ej. "incrementa solo si A=1"):
- `Q(t+1) = (A AND incrementado) OR (NOT A AND Q(t))` → equivale a un **multiplexor** con A como selector entre "incrementado" y "actual".
- Para decrementar, `Q1(t+1) = Q0 XNOR Q1`.

## Ejemplo tipo prueba (patrón que cae: contador con condición)
> Contador de 2 bits que **decrementa** y que resetea a `11` si botón B=1:
> `Q0(t+1) = B OR (NOT Q0)`, `Q1(t+1) = B OR (Q0 XNOR Q1)`.
> Diseñar = flip-flops D + XOR/XNOR + mux/OR para la condición.
