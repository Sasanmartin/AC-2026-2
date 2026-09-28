# Cheatsheet 1 — Representación de números (P1)

## 1. Sistema posicional
Un número en base `b`: cada símbolo vale `símbolo × b^k` (k = posición desde la derecha, partiendo en 0).

```
1234 (base 4) = 1·4² + 2·4¹ + 3·4⁰  →  no existe, el 4 no es dígito válido en base 4
0xCAFE = C·16³ + A·16² + F·16¹ + E·16⁰ = 12·4096 + 10·256 + 15·16 + 14 = 51966
```

## 2. Conversión rápida (bases potencia de 2)
- **bin → hex**: agrupar de a 4 bits (desde la derecha); cada grupo = 1 dígito hex. `1100 1010 1111 1110 = C A F E`
- **bin → oct**: agrupar de a 3 bits. `110 010 101 111 110 = 6 2 5 7 6`
- **dec → bin**: divisiones sucesivas por 2, los restos al revés. `13 → 1101`
- **bin → dec**: sumar potencias de 2 según posición de los 1s.
- **base 8 → base 4** (tipo I1 2025-2): cada dígito oct → 3 bits, agrupar de a 2 bits (agregar 0 a la izquierda si falta), cada grupo → dígito base 4.
  - `712₈ = 111 001 010b → 01 11 00 10 10b = 1,3,0,2,2 → 13022₄`

## 3. Números negativos
| Representación | Cómo | Cero |
|---|---|---|
| Signo y magnitud | bit MSB = signo | 0000 y 1000 (dos ceros) |
| Complemento 1 (C1) | negar todos los bits | 0000 y 1111 (dos ceros) |
| **Complemento 2 (C2)** | **C1 + 1** | único: `0000` |

- C2 resuelve los 3 problemas de signo y magnitud (sin bit de signo propio, suma directa sin paso extra, un solo cero).
- **Desbalanceado**: con n bits rango `[-2^(n-1), +2^(n-1) − 1]` (8 bits: −128..127). Siempre hay un negativo sin su positivo.

## 4. Cálculo de C2 (de un hex a decimal)
```
0x8F = 1000 1111b   (MSB = 1 → negativo)
magnitud = C2(10001111) = negar (01110000) + 1 = 01110001 = 113
resultado = −113
```

## 5. Overflow y carry
- **Carry (C)**: bit que sale del bit más significativo en suma/resta (o bit descartado en shift).
- **Overflow (O)**: resultado fuera del rango de la representación **con signo**. Depende de los signos:
  - A ≥ 0, B ≥ 0 → O=1 si A+B < 0
  - A < 0, B < 0 → O=1 si A+B ≥ 0
  - A ≥ 0, B < 0 → O=1 si A−B < 0
  - A < 0, B ≥ 0 → O=1 si A−B ≥ 0
- **Carry ≠ overflow**: `−1 + −2 = (1)1101` en 4 bits → hay carry, no overflow. El carry solo indica overflow en representación **sin signo**.

## 6. Extensión de bits (8 → 16)
- Positivo: rellenar con 0s a la izquierda. Negativo: rellenar con 1s. Mantiene el valor.

## 7. Número mínimo de bits
`x=0 → 1 bit; x>0 → ⌊log2(x)⌋ + 1`.

## 8. Endianness
- Big endian: bytes MSB primero en memoria. Little endian: bytes LSB primero.
- 2 bytes big `0x0104` = 260 → little = `0x0401` = 1025.

## 9. Justificar por qué funciona una conversión directa (tipo I1 2026-1)
Piden justificar con la fórmula `Σ sₖ·bₖ` por qué hex→bin directo funciona:
- **Idea clave**: 16 es potencia de 2 (16 = 2⁴), ambas bases son potencia del mismo número.
- Cada dígito hex `sₖ · 16ᵏ = sₖ · 2^(4k)` → equivale a 4 bits (los dígitos hex 0-F usan 4 bits).
- Ejemplo: `0x12 = 2·16⁰ + 1·16¹ = 2·2⁰ + 1·2⁴ = 0001 0010b`. Los "huecos" son los bits 0 que se rellenan.
- Responder: expansión con la fórmula + mostrar que el dígito se descompone en 4 bits → justifica la agrupación.

## Ejemplo tipo prueba (I1 2024-1 / clase 01)
> `0xCAFE` en C2 → −13570. Pasos: binario `1100101011111110`, MSB=1 → negativo, C2 = `0011010100000010` = 13570 → **−13570**.
