# Estudio I2 — Arquitectura de Computadores (2026-2)

Material de estudio para la **Interrogación 2** del jueves **22 de octubre de 2026, 17:30**.
Basado en la **Clase 16 — Repaso I2** (S1, Felipe Valenzuela), las clases S2 de subrutinas,
floats, RISC-V e I/O, las guías 2026-1 y las I2 históricas.

## Los 4 temas que entran

| Tema | Cheatsheet | Pregunta típica |
|---|---|---|
| Subrutinas en el computador básico | `cheatsheet-1-subrutinas.md` | Modificar hardware + tabla de señales + simular código |
| Floats IEEE754 | `cheatsheet-2-floats.md` | Interpretar hex, sumar/multiplicar, pérdida de precisión |
| I/O | `cheatsheet-3-io.md` | Memory/port mapped, polling/interrupciones/DMA, describir código |
| RISC-V | `cheatsheet-4-riscv.md` | ISA, convención de llamada y lectura/escritura de código |

> **Formato más probable (I2 2026-1):** 3 preguntas de 6 pts.
> **P1** subrutinas, **P2** floats, **P3** I/O con 3 pts de código RISC-V.
> Es decir, los 4 temas se evalúan en 3 preguntas.

## Contenido de la carpeta

- `cheatsheet-*.md` — resumen compacto por tema (tablas y patrones).
- `hoja-apuntes.md` — versión ultra-condensada para copiar a mano (2 caras).
- `plan-de-estudio.md` — plan martes 20 / miércoles 21 / jueves 22, con checklist.
- `tareas-vision.md` — prompts para extraer los diagramas de los PDFs con un modelo de visión.
- `Estudio-I2-imprimible.html` — cheatsheets, hoja y plan en un solo archivo (Ctrl+P → PDF).
- `Clases/` — copia de la Clase 16 (repaso) y las clases 5, 7, 8 y 9.
- `Ayudantias/` — AY7 (Subrutinas), AY8 (Floats), AY9/AY10 (RISC-V), AY11 (I/O), con pauta.
- `Interrogaciones/` — I2 2024-1 a 2026-1 completas + I2 antiguas seleccionadas.
- `Temas/` — ejercicios agrupados por tema, con `README.md` y `tema-compilado.pdf`.
- `_render_imprimible.py` — regenera el HTML imprimible.
- `_merge_temas.py` — regenera los PDFs compilados de `Temas/`.

## Cómo usarlo en 2 días

1. Lee `plan-de-estudio.md`.
2. Para cada tema: lee el cheatsheet → resuelve la ayudantía → corrige con la pauta → resuelve la I2 histórica asignada.
3. El miércoles haz **P1 S1 + P2 S1 de la I2 2026-1** cronometradas (2 h) y corrige con las pautas.
4. Copia `hoja-apuntes.md` a mano una vez **sin mirar**; lo que no te salga es lo que debes repasar.
5. El jueves en la mañana solo repasa cheatsheets, hoja y errores. No aprendas cosas nuevas.

## Recursos principales

- **Clase 16 — Repaso I2:** `Clases/Clase-16-Repaso-I2.pdf` (38 p.; cubre los 4 temas).
- **Subrutinas:** `Clases/Clase-05-Saltos-y-Subrutinas.pdf`.
- **Floats:** `Clases/Clase-07-Floats.pdf`.
- **RISC-V:** `Clases/Clase-08-RISC-V.pdf`.
- **I/O:** `Clases/Clase-09-IO.pdf`.
- **Guías:** `Syllabus-2026-2/Material Extra/` (Subrutinas, Floats, IO_RISCV, RISCV, RISCV_II).
- **Ayudantías 2026-1:** AY7–AY11 en `Ayudantias/`.
- **I2 históricas:** `Interrogaciones/`.

## Prioridad si el tiempo apremia

1. **P1 Subrutinas** (6 pts): hardware + señales + simulación. Es la más mecánica y la que más se repite.
2. **P2 Floats** (6 pts): formato, suma, multiplicación y pérdida de precisión.
3. **P3 I/O** (3 pts conceptuales): memory/port mapped, polling, interrupciones, DMA.
4. **P3 RISC-V** (3 pts): leer el código de I/O y describirlo por estados/comandos.

> En `Interrogaciones/anteriores/` hay pruebas con temas que **no** entran este semestre
> (caché, memoria virtual, ILP, coherencia, arquitecturas RISC/CISC). Están incluidas por
> pedido, pero el plan solo usa las preguntas de los 4 temas. Revisa `Interrogaciones/README.md`.

## Nota sobre el HTML

`_render_imprimible.py` es autocontenido: no requiere `pip install markdown`.
Genera el HTML desde los `.md` y usa la misma hoja de estilo de `Estudio-I1`.
