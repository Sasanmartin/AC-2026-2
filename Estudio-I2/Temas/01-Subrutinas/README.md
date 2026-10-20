# Tema 01 — Subrutinas

**Pregunta típica:** P1 (6 pts). Implementar instrucciones nuevas sobre el computador básico
(hardware + tabla de señales) y simular un fragmento con `CALL`, `RET`, `PUSH`, `POP`.

## Orden de estudio

1. `../../cheatsheet-1-subrutinas.md`
2. `Guia-Subrutinas-2026-1.pdf`
3. `AY7-Subrutinas-Enunciado.pdf` → `AY7-Subrutinas-Pauta.pdf`
4. `IIC2343-2026-1-I2-P1-S1-sol.pdf` → `IIC2343-2026-1-I2-P1-S2-sol.pdf`
5. `IIC2343-2025-2-I2-sol.pdf` (P2)
6. `IIC2343-2024-2-I2-sol.pdf` (P2)
7. `IIC2343-2024-1-I2-sol.pdf` (P3, computador básico + I/O)

## Archivos

| Archivo | Qué es |
|---|---|
| `Guia-Subrutinas-2026-1.pdf` | Guía oficial 2026-1. |
| `Guia-Subrutinas-2025-2.pdf` | Guía 2025-2; ejercicios extra. |
| `AY7-Subrutinas-Enunciado.pdf` | Ayudantía 7. |
| `AY7-Subrutinas-Pauta.pdf` | Pauta AY7. |
| `IIC2343-2026-1-I2-P1-S1-sol.pdf` | I2 2026-1 P1 S1 (formato actual). |
| `IIC2343-2026-1-I2-P1-S2-sol.pdf` | I2 2026-1 P1 S2 (variante). |
| `IIC2343-2025-2-I2-sol.pdf` | I2 2025-2 (P2 subrutinas). |
| `IIC2343-2024-2-I2-sol.pdf` | I2 2024-2 (P2 subrutinas). |
| `IIC2343-2024-1-I2-sol.pdf` | I2 2024-1 (P3 computador básico + I/O). |
| `tema-compilado.pdf` | Todos los PDFs anteriores en un solo archivo (generado por `_merge_temas.py`). |

## Qué debes dominar

- [ ] `SP` parte en 255; `PUSH` escribe y decrementa; `POP` incrementa y lee.
- [ ] `CALL` guarda `PC+1`; `RET` hace `SP++` y salta a `Mem[SP]`.
- [ ] Tabla de señales de `CALL`, `RET`, `PUSH`, `POP`.
- [ ] `RET1` en 1 ciclo usando `SAdder=SP`, `SAdd=ADDER`, `SPC=DOUT`.
- [ ] `PUSHRW`/`POPRD` sin mover `SP`.
- [ ] Simular un código que pisa la dirección de retorno.
- [ ] Identificar si una instrucción necesita hardware nuevo y proponer la modificación mínima.

## Trampa clásica

Si un `MOV (B),A` escribe en `Mem[SP+1]`, el `RET` saltará a la dirección que dejaste escrita,
no a la instrucción siguiente al `CALL`. Sigue el trace y no asumas que vuelve.
