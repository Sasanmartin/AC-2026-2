# Tema 02 — Floats

**Pregunta típica:** P2 (6 pts). Interpretar hex, sumar/multiplicar, indicar resultado normalizado
y explicar pérdida de precisión. También preguntas cortas de teoría.

## Orden de estudio

1. `../../cheatsheet-2-floats.md`
2. `Guia-Floats-2026-1.pdf`
3. `AY8-Floats-Enunciado.pdf` → `AY8-Floats-Pauta.pdf`
4. `IIC2343-2026-1-I2-P2-S1-sol.pdf` (solo P2)
5. `IIC2343-2026-1-I2-P2-S2-sol.pdf` (variante)
6. `IIC2343-2025-2-I2-sol.pdf` (P1)
7. `IIC2343-2024-2-I2-sol.pdf` (P1)
8. `IIC2343-2024-1-I2-sol.pdf` (P1)

## Archivos

| Archivo | Qué es |
|---|---|
| `Guia-Floats-2026-1.pdf` | Guía oficial 2026-1. |
| `AY8-Floats-Enunciado.pdf` | Ayudantía 8. |
| `AY8-Floats-Pauta.pdf` | Pauta AY8. |
| `IIC2343-2026-1-I2-P2-S1-sol.pdf` | I2 2026-1 P2 S1 (floats + I/O). |
| `IIC2343-2026-1-I2-P2-S2-sol.pdf` | I2 2026-1 P2 S2 (variante). |
| `IIC2343-2025-2-I2-sol.pdf` | I2 2025-2 (P1 floats). |
| `IIC2343-2024-2-I2-sol.pdf` | I2 2024-2 (P1 floats). |
| `IIC2343-2024-1-I2-sol.pdf` | I2 2024-1 (P1 floats). |
| `tema-compilado.pdf` | Todos los PDFs anteriores en un solo archivo (generado por `_merge_temas.py`). |

## Qué debes dominar

- [ ] Formato `S | E | M`, sesgo 127, 1 implícito, 24 bits de precisión.
- [ ] Convertir decimal → binario → float hex y viceversa.
- [ ] Identificar `±0`, subnormales, `±∞`, `NaN`.
- [ ] Sumar: alinear exponentes, sumar, normalizar, redondear.
- [ ] Multiplicar: sumar exponentes, multiplicar significandos, normalizar, signo.
- [ ] Explicar por qué `2^50 + 1` se queda en `2^50`.
- [ ] Saber que hay 254 exponentes distintos y por qué.
- [ ] Comparar punto fijo vs flotante en rango y precisión.

## Trampa clásica

En la multiplicación con exponentes sesgados hay que restar 127:
`E_resultado = E_A + E_B − 127`. Si no lo haces, el exponente queda 127 unidades arriba.
