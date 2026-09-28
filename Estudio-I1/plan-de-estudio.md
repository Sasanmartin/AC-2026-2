# Plan de estudio — I1 en 2 días (formato exprés)

> Objetivo: maximizar puntos en **P1 (representación)** y **P2 (circuitos)** que son fijas,
> y cubrir la **P3 (computador básico con saltos)**: microarquitectura (señales de control)
> + simulación de assembly. Basado en la I1 real de 2026-1 (el precedente más reciente).

## Recursos
- Cheatsheets en `Estudio-I1/` (1 página c/u).
- **Ayudantías 2026-2** (formato I1, con pauta): `Estudio-I1/Ayudantias/` (`AY1-Representaciones numéricas.pdf`, `AY2-Lógica digital.pdf` + sus pautas).
- **Ayudantías 2026-1** (con pauta, muy alineadas a la I1 real): `Estudio-I1/Ayudantias-2026-1/` (`Ayudantía 1-6`).
- **Interrogaciones históricas** a usar: `Estudio-I1/Interrogaciones/<año>/...`
- **Guías de ejercicios** (relevantes para I1) en `Syllabus-2026-2/Material Extra/`:
  - `IIC2343_2025_2_Guia_Representacion _de números.pdf`
  - `IIC2343_2026_1_Guía_de_Lógica_Digital.pdf`
  - `IIC2343_2026_1_Guía_de_Almacenamiento.pdf`
  - `IIC2343_2025_2_Guia_Assembly_y_Saltos.pdf`
- Clase de repaso: `Syllabus-2026-2/Clases/S1/IIC2343-S1-Clase-05-V00.pdf` (ejercicios de simulación).

## Formato confirmado por la I1 real de 2026-1
- **3 preguntas**, contestar todas (6 pts c/u).
- P1: representación (overflow, suma hex en C2, **justificar conversiones**).
- P2: circuito combinacional (minterms) + **contador secuencial con flip-flops D**.
- P3: **microarquitectura (señales de control, 3 ítems)** + simulación de 2 programas.

---

## DÍA 1 (~6-7 h) — Fundamentos (P1 + P2)

**Mañana — P1 Representación (~3 h)**
- [ ] Lee `cheatsheet-1-representacion.md`.
- [ ] Resuelve la **Ayudantía 1** (`Estudio-I1/Ayudantias/AY1-Representaciones numéricas.pdf` + `AY1-pauta.pdf`). Corrige.
- [ ] Resuelve **I1 2026-1 → Pregunta 1** (`Interrogaciones/2026-1/`): overflow vidas, `0xBABA+0x4542` en C2, **justificar hex→bin**. Corrige con la pauta.
- [ ] Extra si quedan dudas: **I1 2025-2 → P1** o la **Ayudantía 6-2026-1** (representaciones, `0xF0CA+0x0F30`).

**Tarde — P2 Circuitos (~3 h)**
- [ ] Lee `cheatsheet-2-circuitos.md` + `cheatsheet-3-almacenamiento.md`.
- [ ] Resuelve **I1 2026-1 → Pregunta 2** (circuito combinacional + contador con Boom). Corrige con la pauta.
- [ ] Resuelve la **Ayudantía 2** (`Estudio-I1/Ayudantias/AY2-Lógica digital.pdf` + `AY2-Pauta.pdf`). Corrige.
- [ ] Resuelve la **Ayudantía 3-2026-1** (flip-flops, latches y contador secuencial). Corrige.
- [ ] Extra si quedan dudas: **I1 2025-1 → P2** (alarma 3 sensores) o la **Ayudantía 2-2026-1** (Nonogram).

**Noche — Simulación de assembly (~1 h)**
- [ ] Lee `cheatsheet-4-assembly-saltos.md`.
- [ ] Haz los **ejercicios de simulación de la Clase 05 (S1)** (programas (1) y (2), valores finales de A y B).

---

## DÍA 2 (~6 h) — Simulacro + P3

**Mañana — Simulacro completo (~2.5 h)**
- [ ] Resuelve **I1 2026-1 completa** (formato real de 3 preguntas) **cronometrada ~2 h**, con desarrollo escrito.
- [ ] Corrige con la pauta pregunta por pregunta y anota los errores.
- [ ] Si ya la hiciste: alterna con **I1 2025-1 completa**.

**Tarde — Reforzar P3 (~2.5 h)**
- [ ] Repasa los errores del simulacro con los cheatsheets.
- [ ] Lee `cheatsheet-5-microarquitectura.md` (ahora es parte regular de la P3).
- [ ] Resuelve **I1 2025-2 → Pregunta 3** (SWAP/JGTCMP + fragmentos) y corrige.
- [ ] Resuelve **I1 2024-1 → Pregunta 4** (MOV B,SP, JMP B, JMP (B)) para practicar el patrón de señales. Corrige.
- [ ] Extra si quedan dudas: **I1 2024-1 → Pregunta 3** (simulación con errores) o la **Ayudantía 4-2026-1** (computador básico / señales).

**Noche — Repaso final (~1 h)**
- [ ] Relee los cheatsheets 1-5 a alta velocidad.
- [ ] Repite de memoria: tabla de saltos (JEQ/JNE/JGT/JLT/JGE/JLE + flags), tabla de C2, patrón de contador con FF-D, método de simulación y patrón de señales de control.

---

## Orden de preguntas históricas por tema (referencia rápida)

| Tema | Pruebas a usar |
|---|---|
| Representación | AY1 (2026-2), AY6 (2026-1), **2026-1 P1**, 2025-2 P1, 2024-1 P1 |
| Circuitos combinacionales | AY2 (2026-1 Nonogram), AY2 (2026-2), **2026-1 P2a**, 2025-1 P2 |
| Circuitos secuenciales / contadores | AY3 (2026-1), **2026-1 P2b**, 2025-1 P2b, 2024-2 P2b, 2025-2 P2b |
| Almacenamiento / endianness | 2022-1 "La Memoria, Mi Dato" (`IIC2343-2022-1-S2-Memoria-Palindromo.pdf`), 2023-2 P3, `Guía_de_Almacenamiento` |
| Microarquitectura (señales) | **2026-1 P3(a-c)**, AY4 (2026-1), 2024-1 P4, 2022-1-S2 P4 (`I12022-1-S2.pdf`), 2022-2 P4 |
| Simulación de assembly | **2026-1 P3d**, 2024-1 P3, 2024-2 P3, 2025-2 P3c, `Guia_Assembly_y_Saltos` |

## Tips finales
- **La pauta exige desarrollo**: nunca respondas solo el resultado final.
- En simulación, una tabla de trazado clara vale puntos parciales aunque el resultado esté mal.
- **Microarquitectura vale puntos en P3** (en la I1 2026-1 eran 3 de 4 ítems): domina el patrón (registro nuevo → mux → señal de carga → tabla de señales).
- Si no sabes un ítem, deja el procedimiento escrito (dan puntaje parcial).
- Al corregir con las pautas, **anota el puntaje que "obtendrías" por ítem** (las pautas lo detallan) para priorizar los temas débiles.
- **Practica copiar `hoja-apuntes.md` una vez de memoria** (sin mirar): detecta qué no retienes y refuerza solo eso.
- Duerme bien: P1 y P2 son mecánicas, el cansancio se nota en la P3.
