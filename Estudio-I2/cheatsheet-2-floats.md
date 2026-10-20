# Cheatsheet 2 — Floats IEEE754 (P2)

> **Lo que se pregunta:** interpretar números en hex, sumar/multiplicar, indicar el resultado
> en binario normalizado y decidir si se pierde precisión al guardarlo como `float`.
> También caen preguntas cortas de teoría (bits de precisión, exponentes, punto fijo vs flotante).

## 1. Punto fijo vs punto flotante

| Representación | Ventaja | Desventaja |
|---|---|---|
| **Punto fijo** | Simple, rápido, predecible. | Rango muy pequeño; poca precisión relativa. |
| **Punto flotante** | Rango mucho más amplio (exponente). | Menos precisión; errores de redondeo. |

En punto fijo los bits se reparten en signo, parte entera y parte fraccionaria **fija**.
En punto flotante se representa como `significante × base^exponente`, así que el punto “flota”.

## 2. Formato IEEE754 de 32 bits (`float`)

```text
 1 bit      8 bits              23 bits
┌──────┬────────────────┬──────────────────────────┐
│  S   │  E (sesgo 127) │  M (significando)        │
└──────┴────────────────┴──────────────────────────┘
  31      30 ... 23         22 ... 0
```

- **Signo `S`:** 0 = positivo, 1 = negativo.
- **Exponente `E`:** 8 bits, **sesgado en 127**. Exponente real `e = E − 127`.
- **Significando `M`:** 23 bits, pero se asume un **1 implícito** a la izquierda:
  `1.M`.
- **Precisión total: 24 bits** (23 explícitos + 1 implícito).
- Valor:
  `X = (−1)^S × 1.M × 2^(E−127)`.

### Rango y casos especiales

| Exponente `E` | Significando `M` | Significado |
|---|---|---|
| `00000000` | `000...0` | `±0` (`+0 = 0x00000000`, `−0 = 0x80000000`) |
| `00000000` | `≠ 0` | Número **subnormal** (no normalizado) |
| `00000001` a `11111110` | cualquiera | Número normal, `e ∈ [−126, 127]` |
| `11111111` | `000...0` | `±∞` (`+∞ = 0x7F800000`, `−∞ = 0xFF800000`) |
| `11111111` | `≠ 0` | **NaN** (Not a Number) |

- Exponentes distintos representables: **254** (`256 − 2` reservados: `0` y `255`).
- Precisión: **24 bits**.
- `double` (64 bits): 1 signo + 11 exponente (sesgo 1023) + 52 significando → **53 bits** de precisión.
- `εmach` de `float` ≈ `2^-23`; de `double` ≈ `2^-52`.

## 3. Conversión decimal → float

1. Pasa la parte entera y fraccionaria a binario.
2. Normaliza: `1.xxxx × 2^e`.
3. Calcula `E = e + 127` en binario (8 bits).
4. Escribe `S | E | M` (M son los bits después del punto, sin el 1 implícito).
5. Agrupa de a 4 bits para obtener el hex.

**Ejemplo:** `0.15625`

- `0.15625 = 0.00101₂ = 1.01₂ × 2^-3`.
- `e = −3` → `E = 124 = 01111100₂`.
- `S = 0`, `M = 010000...`.
- Resultado: `0 01111100 01000000000000000000000` = **`0x3E200000`**.

**Ejemplo:** `−1.6875`

- `1.6875 = 1.1011₂`.
- `e = 0` → `E = 127 = 01111111₂`.
- `S = 1`, `M = 101100...`.
- Resultado: `1 01111111 10110000000000000000000` = **`0xBFD80000`**.

## 4. Conversión float → decimal

1. Pasa el hex a binario (4 bits por dígito).
2. Separa `S | E | M`.
3. Calcula `e = E − 127`.
4. Escribe `1.M × 2^e` y pasa a decimal.
5. Si `E = 255`, revisa si es `±∞` o `NaN`; si `E = 0`, revisa cero/subnormal.

**Ejemplo:** `0xBF800000`

- `1 01111111 00000000000000000000000`.
- `S=1`, `E=127 → e=0`, `M=0 → 1.0`.
- Valor: `−(1.0 × 2^0) = −1`.

## 5. Suma de floats

Algoritmo:

1. **Comparar exponentes.** Si son distintos, toma el de menor exponente y hazle
   **shift right** al significando, aumentando su exponente de a 1 hasta igualar al mayor.
2. **Sumar los significandos** (manteniendo el exponente).
3. **Normalizar:** si queda `1x.xxx`, shift right y `e+1`; si queda `0.xxx`, shift left y `e−1`.
4. **Redondear** a 23 bits (o 24 con el implícito). Si al redondear se desnormaliza, repetir.
5. **Verificar** el resultado en decimal.

**Ejemplo:** `A = 1.11₂ × 2^3 = 14`, `C = 1.11₂ × 2^1 = 3.5`

```text
C = 1.11 × 2^1
  = 0.111 × 2^2
  = 0.0111 × 2^3        (shift right 2 veces)

A + C = 1.11 × 2^3 + 0.0111 × 2^3
      = 10.0011 × 2^3
      = 1.00011 × 2^4    (normalizo: shift right, e+1)
      = 10001.1₂ = 17.5
```

> Si los dos números tienen el mismo exponente, sáltate el paso 1.

## 6. Multiplicación de floats

Algoritmo:

1. **Sumar exponentes.** Si están sesgados:
   `E_resultado = E_A + E_B − 127`.
   Si no están sesgados: `e_resultado = e_A + e_B`.
2. **Multiplicar significandos** (ignora el punto; luego ubícalo contando posiciones).
3. **Normalizar** el producto (shift right/left y ajustar exponente).
4. **Redondear** a 23 bits.
5. **Signo:** `S_resultado = S_A XOR S_B`.

**Ejemplo:** `A = 1.11₂ × 2^3 = 14`, `B = 1.1₂ × 2^3 = 12`

```text
Exponente: 3 + 3 = 6
Significandos:
      1.110
   ×  1.100
   ---------
     10.101  (producto binario)

Normalizo: 1.0101 × 2^7  →  10101000₂ = 168
```

**Con sesgo:** `E_A = 3+127 = 130`, `E_B = 130` → `E_resultado = 130+130−127 = 133`
→ `e = 133−127 = 6`. Correcto.

## 7. Pérdida de precisión

- Un `float` solo guarda **24 bits** de significando. Si el resultado exacto necesita más,
  se pierden los bits menos significativos.
- **¿Se pierde precisión?** Compara el resultado exacto con el que queda almacenado.
  Si son distintos → sí. Indica **cuántos bits** se pierden y su peso (ej. `2^-5 = 0.03125`).
- **¿Es exactamente representable?** Un número lo es si puede escribirse como
  `m × 2^e` con `m` entero de a lo más 24 bits (en el rango normal).
  - `2^70` → sí (potencia de 2).
  - `2^50 + 1` → no: necesita 51 bits; el `1` se pierde.
  - `2^24 + 1` → no: necesita 25 bits; el `1` se pierde.
  - `2^26 + 2` → no: necesita 26 bits; el `2` se pierde.
  - `0.1` → no: en binario es infinito periódico.
- **Redondeo:** truncado, hacia arriba/abajo o al par más cercano. El curso suele aceptar
  truncado si lo indicas.
- **`εmach`:** distancia entre 1 y el siguiente float; mide el error relativo máximo.
  Para `float` es `2^-23`; para `double`, `2^-52`.

## 8. Frases de teoría que conviene tener listas

| Pregunta | Respuesta corta |
|---|---|
| ¿Cuántos bits de precisión tiene un `float`? | **24**: 23 del significando + 1 implícito. |
| ¿Cuántos exponentes distintos? | **254**: 256 combinaciones menos `0` y `255`. |
| ¿Por qué se usa sesgo 127? | Para representar exponentes negativos sin bit de signo ni complemento a 2. |
| ¿Punto fijo vs flotante? | Fijo: más simple/rápido, poco rango. Flotante: más rango, menos precisión. |
| ¿Se pierde precisión al guardar? | Sí si el resultado exacto necesita más de 24 bits de significando. |
| ¿Qué es NaN? | Exponente `255` y significando `≠ 0`; resultado de operaciones inválidas (`0/0`, `∞−∞`). |
| ¿Qué es `±∞`? | Exponente `255` y significando `0`; se obtiene al desbordar o dividir por 0. |

## 9. Errores típicos

- Aplicar el sesgo al revés: al **guardar** se **suma** 127; al **leer** se **resta** 127.
- Olvidar el **1 implícito** al interpretar el significando.
- Sumar exponentes sin restar el sesgo en la multiplicación.
- Normalizar mal: `10.xxx × 2^e = 1.0xxx × 2^(e+1)`, no `2^(e−1)`.
- Decir “no se pierde precisión” cuando el resultado exacto tiene más de 24 bits.
- Confundir `NaN` con `∞`: `∞` tiene significando 0; `NaN` tiene significando distinto de 0.
- En la suma, olvidar hacer shift right al número de **menor** exponente (no al mayor).
- No indicar el resultado en **binario normalizado** cuando el enunciado lo exige.
