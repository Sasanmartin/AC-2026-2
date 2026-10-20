# Tema 03 — I/O

**Pregunta típica:** P3 (6 pts). 3 pts conceptuales (memory/port mapped, decoder, polling,
interrupciones, DMA) y 3 pts de código RISC-V que maneja un dispositivo.

## Orden de estudio

1. `../../cheatsheet-3-io.md`
2. `Guia-IO-RISCV-2026-1.pdf`
3. `AY11-IO-Enunciado.pdf` → `AY11-IO-Pauta.pdf`
4. `IIC2343-2026-1-I2-P2-S1-sol.pdf` (P3)
5. `IIC2343-2025-2-I2-sol.pdf` (P3)
6. `IIC2343-2025-1-I2-sol.pdf` (P2 y P3; ignora P1)
7. `IIC2343-2024-2-I2-sol.pdf` (P3)
8. `IIC2343-2024-1-I2-sol.pdf` (P2 y P3)

## Archivos

| Archivo | Qué es |
|---|---|
| `Guia-IO-RISCV-2026-1.pdf` | Guía oficial 2026-1 (I/O + RISC-V). |
| `Guia-IO-2025-2.pdf` | Guía 2025-2. |
| `AY11-IO-Enunciado.pdf` | Ayudantía 11. |
| `AY11-IO-Pauta.pdf` | Pauta AY11. |
| `IIC2343-2026-1-I2-P2-S1-sol.pdf` | I2 2026-1 P3 (printer + robot). |
| `IIC2343-2026-1-I2-P2-S2-sol.pdf` | Variante P3. |
| `IIC2343-2025-2-I2-sol.pdf` | I2 2025-2 P3. |
| `IIC2343-2025-1-I2-sol.pdf` | I2 2025-1 P2/P3. |
| `IIC2343-2024-2-I2-sol.pdf` | I2 2024-2 P3. |
| `IIC2343-2024-1-I2-sol.pdf` | I2 2024-1 P2/P3. |
| `tema-compilado.pdf` | Todos los PDFs anteriores en un solo archivo (generado por `_merge_temas.py`). |

## Qué debes dominar

- [ ] Memory-mapped vs port-mapped: espacio, instrucciones, ISA, uso.
- [ ] Address decoder: entradas, salidas, por qué va entre bus y dispositivos.
- [ ] Polling: cómo funciona, ventaja, desventaja, ejemplo (USB).
- [ ] Interrupciones: `IRQ`, `IF`, `INT`, `INTA`, ID, vector, ISR, EOI.
- [ ] Diferencia entre excepción, trap/software e interrupción de hardware.
- [ ] DMA: programación, burst vs cycle stealing, interrupción al final.
- [ ] RISC-V: `lw`/`sw` con `offset(base)`, offsets de 4 bytes, status loop.
- [ ] Describir un código por estados/comandos, no línea por línea.

## Trampa clásica

La ISR debe **limpiar el flag** o hacer **EOI**. Si no, el controlador vuelve a interrumpir
inmediatamente y el programa entra en un loop. También debe guardar/restaurar los registros que usa.
