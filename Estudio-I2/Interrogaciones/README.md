# Interrogaciones históricas — mapa de uso

Las I2 están ordenadas por año. **No todas las preguntas entran en el I2 2026-2**: el foco es
RISC-V, Subrutinas, I/O y Float. Las preguntas fuera de alcance se incluyen solo como material
histórico; están marcadas para que no pierdas tiempo.

## I2 recientes (formato actual)

| Año | Archivo | P1 | P2 | P3 | Uso |
|---|---|---|---|---|---|
| **2026-1** | `2026-1/IIC2343-2026-1-I2-P1-S1-sol.pdf` | Subrutinas (6) | — | — | **Ensayo principal P1** |
| **2026-1** | `2026-1/IIC2343-2026-1-I2-P1-S2-sol.pdf` | Subrutinas (6) | — | — | Variante P1 |
| **2026-1** | `2026-1/IIC2343-2026-1-I2-P2-S1-sol.pdf` | — | Floats (6) | I/O + RISC-V (6) | **Ensayo principal P2/P3** |
| **2026-1** | `2026-1/IIC2343-2026-1-I2-P2-S2-sol.pdf` | — | Floats (6) | I/O + RISC-V (6) | Variante P2/P3 |
| **2025-2** | `2025-2/IIC2343-2025-2-I2-sol.pdf` | Floats (6) | Subrutinas (6) | I/O + RISC-V (6) | **Ensayo alternativo** |
| **2024-2** | `2024-2/IIC2343-2024-2-I2-sol.pdf` | Floats (6) | Subrutinas (6) | I/O + RISC-V (6) | Práctica por tema |
| **2024-1** | `2024-1/IIC2343-2024-1-I2-sol.pdf` | Floats (6) | I/O (6) | Computador básico + I/O (6) | Práctica floats/I/O |
| **2024-1 (P4)** | `2024-1/IIC2343-2024-1-I2-P4-sol.pdf` | RISC-V (8) | — | — | Práctica RISC-V; incluye `.asm` y tests. |

> **2026-1:** la I2 se partió en dos archivos (P1 y P2). El P1 tiene subrutinas; el P2 tiene
> floats **y** la P3 de I/O + RISC-V. Es el mejor modelo del formato actual.

## I2 con temas parcialmente fuera de alcance

| Año | Archivo | Preguntas | En alcance | Fuera de alcance |
|---|---|---|---|---|
| **2025-1** | `2025-1/IIC2343-2025-1-I2-sol.pdf` | P1 Arquitecturas (6) | — | RISC vs CISC, Harvard vs Von Neumann |
| | | P2 I/O — Parte 1 (6) | **Sí** | — |
| | | P3 I/O — Parte 2 (6) | **Sí** (incluye RISC-V) | — |
| **2023-2** | `anteriores/2023-2/IIC2343-2023-2-I2-sol.pdf` | P1 Conceptual (8) | Parcial: I/O | Caché, virtual, ILP |
| | | P2 I/O (8) | **Sí** | — |
| | | P3 Caché/virtual (8) | — | Caché, memoria virtual |
| | | P4 ILP (8) | — | Pipelining, ILP |
| **2022-2** | `anteriores/2022-2/IIC2343_2022_2_I2_Solucion.pdf` | P1 Caché (20) | — | Caché |
| | | P2 Memoria virtual (20) | — | Memoria virtual |
| | | P3 ILP (20) | — | ILP |
| | | P4 I/O y RISC-V (20) | **Sí** | — |
| **2022-1** | `anteriores/2022-1/I2-S2.pdf` | P1 Popurrí (18) | Parcial: floats, calling convention | — |
| | | P2 Más popurrí (18) | **Sí**: I/O, multiprogramación | — |
| | | P3 Caché (24) | — | Caché |
| **2022-1** | `anteriores/2022-1/I2-S1.pdf` | — | — | Escaneada; temas de caché/ILP, fuera de alcance |
| **2021-2** | `anteriores/2021-2/I2-S2.pdf` | P1 Misceláneo (12) | Parcial: DMA | Harvard/von Neumann |
| | | P2 Caso teórico (22) | — | Caché, MESI |
| | | P3 Caso real (26) | **Sí**: I/O, RISC-V, ISR | — |
| **2021-2** | `anteriores/2021-2/I2-S1.pdf` | — | — | Caché; fuera de alcance |
| **2021-1** | `anteriores/2021-1/i2.pdf` | P1 Virtual (—) | — | Memoria virtual |
| | | P2 Pipelining (—) | — | Pipelining |
| | | P3 Paralelismo (—) | — | MESI, multiprocesadores |
| | | P4 I/O (—) | **Sí** | — |
| | | P5 ISA (—) | **Parcial**: formato de instrucciones | ISA genérica, no RISC-V |
| **2020-1** | `anteriores/2020-1/i2.pdf` | Floats | **Sí** | — |
| | | Circuitos secuenciales | — | Circuitos |
| | | Computador básico | **Sí** | — |
| | | Ruta de acceso a memoria | Parcial | RAM interna |
| **2019-2** | `anteriores/2019-2/I2.pdf` | Caché / memoria virtual | — | Fuera de alcance |

## Cómo usar cada archivo

1. **2026-1** → ensayo cronometrado. Es el formato más probable.
2. **2025-2** → segundo ensayo; cambia el orden de las preguntas (floats P1, subrutinas P2).
3. **2024-2** → práctica por tema, muy similar a 2025-2.
4. **2024-1** → floats y I/O; la P3 mezcla computador básico con I/O.
5. **2025-1** → solo P2/P3. Ignora P1.
6. **2023-2 / 2022-2 / 2022-1 S2 / 2021-2 S2 / 2021-1** → banco de preguntas de I/O y RISC-V.
7. **2020-1** → floats y computador básico; ignora circuitos secuenciales.
8. **2019-2 / 2022-1 S1 / 2021-2 S1** → no aportan a este I2; están solo por completitud.

## Preguntas que más se repiten

- Subrutinas: implementar `CALL`, `RET`, `PUSH`, `POP`, `RET1`, `PUSHRW`, `POPRD`, `MOV A,SP`,
  `CMP B,SP`; modificar el datapath; simular un código con retorno pisado.
- Floats: convertir hex ↔ decimal, sumar/multiplicar, bits de precisión, exponentes, casos especiales.
- I/O: memory-mapped vs port-mapped, address decoder, polling vs interrupciones, DMA.
- RISC-V: leer una función, convención de llamada, stack frame, I/O con `lw`/`sw`, describir estados.

## Advertencia

Las pautas son **una** solución posible. Si tu hardware o tu traza llega al mismo resultado con
señales coherentes, probablemente está bien. En subrutinas, revisa que la operación se complete en
los ciclos que pide el enunciado; en floats, revisa la normalización y el redondeo.
