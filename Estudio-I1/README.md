# Estudio I1 — Arquitectura de Computadores (2026-2)

Material de estudio para la Interrogación 1. Basado en las clases de la Sección 1
(Syllabus-2026-2/Clases/S1) y en las I1 históricas (guardadas en `Estudio-I1/Interrogaciones/`).

## Contenido de la carpeta

- `cheatsheet-*.md` — resúmenes de 1 página por tema.
- `hoja-apuntes.md` — guía para copiar a mano tu hoja permitida.
- `plan-de-estudio.md` — plan día a día (con checklist de progreso).
- `tareas-vision.md` — prompts y páginas para extraer los diagramas con el modelo DeepSeek V4 Flash Vision Exp.
- `Estudio-I1-imprimible.html` — todo el material en un solo archivo para leer/imprimir (Ctrl+P → PDF).
- `Ayudantias/` — ayudantías 2026-2 con pauta (AY1 representación, AY2 lógica digital).
- `Ayudantias-2026-1/` — ayudantías 2026-1 (AY1-AY6) con pauta, muy alineadas a la I1 real.
- `Interrogaciones/<año>/` — I1 históricas (las que usa el plan), incluida la **I1 real de 2026-1**.
- `_render_imprimible.py` — script que regenera el HTML imprimible tras editar los `.md`.

## Formato esperado de la I1 (3 preguntas)

| Pregunta | Tema | Cheatsheet |
|---|---|---|
| P1 | Representación de números | `cheatsheet-1-representacion.md` |
| P2 | Circuitos digitales y almacenamiento | `cheatsheet-2-circuitos.md` + `cheatsheet-3-almacenamiento.md` |
| P3 | Computador básico con saltos (microarquitectura + simulación) | `cheatsheet-4-assembly-saltos.md` + `cheatsheet-5-microarquitectura.md` |

## Cómo usar con 1-2 días

1. Lee el `plan-de-estudio.md` primero.
2. Cada cheatsheet es de 1 página: reglas + patrón + ejemplo resuelto. Léelos de arriba a abajo y luego **resuelve las preguntas históricas asignadas en el plan**.
3. Las pautas de las interrogaciones están en `Estudio-I1/Interrogaciones/<año>/` (el PDF incluye la solución). Corrige siempre con desarrollo escrito (la pauta exige justificación).
4. Simula condiciones reales: una prueba completa en ~2 h cronometradas.

## Recursos adicionales del curso (integrados al plan)

- **Ayudantías** (formato I1, con pauta): `Estudio-I1/Ayudantias/` (2026-2: AY1 representación, AY2 lógica digital) y `Estudio-I1/Ayudantias-2026-1/` (AY1-AY6).
- **Guías de ejercicios** relevantes para la I1 en `Syllabus-2026-2/Material Extra/`: Representación de números, Lógica Digital, Almacenamiento y Assembly y Saltos.
  - Las demás guías (caché, I/O, jerarquía, RISC-V, floats, ILP, coherencia) son de I2/I3: **ignorar para la I1**.

## Prioridad (si el tiempo apremia)

1. P1 representación + P2 circuitos (fijas y con mayor puntaje garantizable).
2. P3: microarquitectura (señales de control) — vale 3 ítems en la I1 real de 2026-1.
3. P3: simulación de assembly con saltos (lo que más cae en la última pregunta).
