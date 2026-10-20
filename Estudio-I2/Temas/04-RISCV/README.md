# Tema 04 — RISC-V

**Pregunta típica:** parte de P3 (3 pts). Leer una función, identificar qué hace, escribir una
función con convención de llamada o describir un código de I/O.

## Orden de estudio

1. `../../cheatsheet-4-riscv.md`
2. `Guia-RISCV-2026-1.pdf`
3. `Guia-RISCV-II-2026-1.pdf`
4. `AY9-RISCV-Enunciado.pdf` → `AY9-RISCV-Pauta.pdf`
5. `AY10-RISCV-Enunciado.pdf` → `AY10-RISCV-Pauta.pdf`
6. `IIC2343-2026-1-I2-P2-S1-sol.pdf` (P3)
7. `IIC2343-2025-2-I2-sol.pdf` (P3)
8. `IIC2343-2025-1-I2-sol.pdf` (P3)
9. `IIC2343-2024-1-I2-P4-sol.pdf` (actividad RISC-V, 8 pts) + `IIC2343-2024-1-I2-P4.asm` + `2024-1-P4-tests/`

## Archivos

| Archivo | Qué es |
|---|---|
| `Guia-RISCV-2026-1.pdf` | Guía oficial 2026-1. |
| `Guia-RISCV-II-2026-1.pdf` | Segunda guía 2026-1. |
| `Guia-RISCV-2025-2.pdf` | Guía 2025-2; ejercicios extra. |
| `AY9-RISCV-Enunciado.pdf` | Ayudantía 9. |
| `AY9-RISCV-Pauta.pdf` | Pauta AY9. |
| `AY10-RISCV-Enunciado.pdf` | Ayudantía 10. |
| `AY10-RISCV-Pauta.pdf` | Pauta AY10. |
| `IIC2343-2026-1-I2-P2-S1-sol.pdf` | I2 2026-1 P3. |
| `IIC2343-2026-1-I2-P2-S2-sol.pdf` | Variante P3. |
| `IIC2343-2025-2-I2-sol.pdf` | I2 2025-2 P3. |
| `IIC2343-2025-1-I2-sol.pdf` | I2 2025-1 P3. |
| `IIC2343-2024-1-I2-P4-sol.pdf` | Actividad RISC-V 2024-1 (8 pts). |
| `IIC2343-2024-1-I2-P4.asm` | Código base de la actividad. |
| `2024-1-P4-tests/` | Tests de la actividad (`.asm`). |
| `tema-compilado.pdf` | Todos los PDFs anteriores en un solo archivo (generado por `_merge_temas.py`). |

## Qué debes dominar

- [ ] Registros y ABI: `ra`, `sp`, `a0–a7`, `t0–t6`, `s0–s11`.
- [ ] Caller-saved vs callee-saved.
- [ ] `lw`/`sw` con `offset(base)`; no existe `lw rd, rs`.
- [ ] Branches comparan registros; **no hay flags**.
- [ ] `jal`/`jalr`/`ret`; `ra` y `PC+4`.
- [ ] Stack frame: reservar, guardar `ra` y `s*`, restaurar en orden inverso.
- [ ] `ecall` básico (print int, print string, exit).
- [ ] RV32F: `flw`/`fsw`, `fadd.s`, `fmul.s`, `fcvt`.
- [ ] Leer un loop con arreglo: `slli`, `add`, `lw`, `addi`, branch.
- [ ] I/O: base + offsets de 4 bytes; status loop.

## Trampa clásica

Si tu función llama a otra, **debes guardar `ra`** antes de la llamada. Si no, la llamada
sobrescribe `ra` y el `ret` de tu función vuelve a cualquier parte.
