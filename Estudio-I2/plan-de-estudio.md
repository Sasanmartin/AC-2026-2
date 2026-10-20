# Plan de estudio I2 — 2 días

**Examen:** jueves **22 de octubre de 2026, 17:30**.
**Formato probable:** 3 preguntas de 6 pts (P1 subrutinas, P2 floats, P3 I/O + RISC-V).
**Meta:** llegar al examen con los 4 temas resueltos al menos una vez y una I2 completa cronometrada.

## Mapa de recursos

| Tema | Cheatsheet | Ayudantía | I2 para practicar |
|---|---|---|---|
| Subrutinas | `cheatsheet-1-subrutinas.md` | AY7 | 2026-1 P1 (S1 y S2), 2025-2 P2, 2024-2 P2 |
| Floats | `cheatsheet-2-floats.md` | AY8 | 2026-1 P2 (S1 y S2), 2025-2 P1, 2024-2 P1, 2024-1 P1 |
| I/O | `cheatsheet-3-io.md` | AY11 | 2026-1 P3, 2025-2 P3, 2025-1 P2/P3, 2024-2 P3 |
| RISC-V | `cheatsheet-4-riscv.md` | AY9 y AY10 | 2026-1 P3, 2025-2 P3, 2025-1 P3 |

> Las I2 están en `Interrogaciones/`. Las pautas de 2026-1 tienen dos versiones (S1 y S2);
> usa una como ensayo y la otra como banco extra.

---

## Martes 20 — Subrutinas + Floats

### 15:00–15:20 · Preparación
- Lee `README.md` y hojea `hoja-apuntes.md`.
- Ten abiertos: cheatsheet 1, AY7, I2 2026-1 P1 S1.

### 15:20–17:00 · Subrutinas: teoría y hardware
- Lee `cheatsheet-1-subrutinas.md` completo.
- Cierra el cheatsheet y explica en voz alta:
  1. Por qué `SP` apunta al próximo libre.
  2. Diferencia entre `RET` y `RET1`.
  3. Para qué sirve cada mux (`SDIn`, `SPC`, `SAdd`, `SAdder`).
  4. Cómo se implementa `PUSHRW` sin mover `SP`.
- Si algo no sale, vuelve al cheatsheet y anótalo en el **log de errores**.

### 17:00–18:30 · AY7 + I2 2026-1 P1
- Resuelve **AY7 completa** sin mirar la pauta.
- Corrige con la pauta. Marca:
  - señales mal puestas,
  - ciclos mal contados,
  - simulación con direcciones equivocadas.
- Luego resuelve **I2 2026-1 P1 S1** cronometrada (35 min).
- Corrige y compara con **P1 S2** (misma habilidad, otra variante).

### 18:30–19:00 · Break

### 19:00–20:30 · Floats: teoría
- Lee `cheatsheet-2-floats.md`.
- Practica sin mirar:
  1. `0x3E200000` → decimal.
  2. `−1.6875` → hex float.
  3. `0x58800000 + 0x3F800000` → resultado y precisión.
  4. `0xBF800000 × 0x7F800000` → resultado.
  5. ¿Cuántos bits de precisión y cuántos exponentes?
- Verifica cada uno con el cheatsheet.

### 20:30–22:00 · AY8 + I2 floats
- Resuelve **AY8**.
- Corrige con pauta.
- Resuelve **I2 2026-1 P2** (floats + I/O; haz solo floats por ahora).
- Si queda tiempo: **2025-2 P1** (floats).

### Checklist del martes
- [ ] Explico `CALL`/`RET`/`PUSH`/`POP` con señales.
- [ ] Implemento `RET1` en 1 ciclo y justifico el Mux Adder.
- [ ] Simulo un código con `CALL` y retorno pisado.
- [ ] Convierto decimal ↔ float hex.
- [ ] Sumo y multiplico floats normalizando.
- [ ] Explico pérdida de precisión con un ejemplo.

---

## Miércoles 21 — I/O + RISC-V + ensayo

### 09:00–10:30 · I/O
- Lee `cheatsheet-3-io.md`.
- Haz una tabla comparativa de memory-mapped vs port-mapped **de memoria**.
- Explica en voz alta:
  1. Qué hace el address decoder y por qué va ahí.
  2. Polling vs interrupción.
  3. Pasos de una interrupción con controlador.
  4. DMA burst vs cycle stealing.
- Resuelve **AY11**.

### 10:30–12:00 · RISC-V
- Lee `cheatsheet-4-riscv.md`.
- Repasa registros/ABI y stack frame.
- Resuelve **AY9** y **AY10**.
- Corrige con pautas. En cada error, anota si fue:
  - registro mal elegido,
  - `ra` no guardado,
  - load/store mal escrito,
  - branch mal interpretado.

### 12:00–13:00 · Break

### 13:00–14:30 · I/O + RISC-V en exámenes
- Resuelve **I2 2025-2 P3** (I/O + RISC-V).
- Corrige.
- Lee **I2 2026-1 P3** y **2025-1 P3**; identifica el patrón de respuesta por estados/comandos.
- Practica describir un código en 4–6 frases, sin línea por línea.

### 14:30–15:00 · Descanso corto

### 15:00–17:00 · Ensayo I2 completa
- Resuelve **P1 S1 + P2 S1 de I2 2026-1** en 2 horas, sin apuntes.
- Orden sugerido: P1 (35 min) → P2 (40 min) → P3 (35 min) → revisión (10 min).
- Si te trabas en una pregunta, marca y sigue. No dejes preguntas en blanco.

### 17:00–18:30 · Corrección del ensayo
- Corrige con las pautas P1/P2 S1.
- Anota cada error en el log con: tema, causa, regla correcta.
- Calcula tu puntaje por pregunta. Identifica el tema más débil.

### 18:30–20:00 · Repaso dirigido
- Vuelve al cheatsheet del tema más débil.
- Rehaz **solo** los ejercicios que fallaste.
- Si el error fue de tiempo, practica el mismo tipo en 15 min.

### Checklist del miércoles
- [ ] Distingo memory-mapped vs port-mapped.
- [ ] Sé dibujar el flujo de una interrupción.
- [ ] Explico DMA sin confundirlo con polling.
- [ ] Leo un código RISC-V y digo qué hace.
- [ ] Escribo una función con stack frame correcto.
- [ ] Hice una I2 completa cronometrada.

---

## Jueves 22 — Repaso y examen

### 09:00–10:30 · Hoja de apuntes
- Copia `hoja-apuntes.md` a mano **sin mirar**.
- Compara con el original y marca lo que faltó.
- Repasa solo esas partes.

### 10:30–11:30 · Log de errores
- Lee tu log de errores del martes y miércoles.
- Para cada error, di en voz alta la regla correcta.
- No resuelvas ejercicios nuevos.

### 11:30–12:30 · Repaso rápido
- 15 min subrutinas: tabla de señales.
- 15 min floats: suma/multiplicación.
- 15 min I/O: interrupciones/DMA.
- 15 min RISC-V: ABI/stack frame.

### 12:30–14:30 · Almuerzo y descanso
- No estudies. Duerme si puedes.

### 14:30–15:30 · Última pasada
- Solo cheatsheets y hoja.
- Revisa las 5 cosas que más se te olvidan.
- Prepara lápiz, calculadora si se permite, y tu hoja.

### 15:30–16:30 · Traslado
- Llega con margen. No repases en el camino si te pone nervioso.

### 17:30 · Examen

---

## Ruta exprés (si solo tienes 1 día)

1. **2 h Subrutinas:** cheatsheet 1 + AY7 + P1 2026-1.
2. **2 h Floats:** cheatsheet 2 + AY8 + P2 2026-1 (solo floats).
3. **1.5 h I/O:** cheatsheet 3 + AY11 + P3 2026-1.
4. **1.5 h RISC-V:** cheatsheet 4 + AY9 + leer P3 2025-2.
5. **2 h ensayo:** P1 + P2 + P3 de 2026-1.
6. **1 h hoja:** copiar `hoja-apuntes.md` a mano.

## Estrategia en el examen

- **P1 (6 pts):** primero la tabla de señales; después la simulación. La simulación tiene puntos parciales: deja el trace aunque no termines.
- **P2 (6 pts):** muestra el binario normalizado y el hex; si no alcanzas a terminar, deja planteadas las operaciones.
- **P3 (6 pts):** 3 pts conceptuales + 3 pts RISC-V. Responde primero lo conceptual; es rápido.
- Si una pregunta tiene 3 partes, no te quedes 20 min en la primera.
- Revisa unidades, sesgo, `PC+1`, y si el resultado quedó en `a0`.

## Log de errores (plantilla)

| Fecha | Tema | Ejercicio | Qué hice mal | Regla correcta |
|---|---|---|---|---|
| | | | | |
| | | | | |
| | | | | |

## Qué NO entra (aunque aparezca en I2 antiguas)

- Caché, memoria virtual, TLB.
- Pipelining, hazards, ILP, coherencia.
- Arquitecturas RISC vs CISC, Harvard vs Von Neumann (teoría).
- Multiprocesadores, consistencia, sincronización.

Están en `Interrogaciones/anteriores/` solo como material histórico. **No los estudies para este I2.**
