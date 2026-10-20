# Tareas de visión — extraer diagramas y tablas de los PDFs

Objetivo: convertir los diagramas importantes de las clases y pautas en imágenes o descripciones
reutilizables, para no depender de abrir el PDF en el examen.

## Convención

- Guarda las imágenes en `Estudio-I2/figuras/` con nombre `tema-pagina-descripcion.png`.
- Si el modelo no puede recortar, pídele una **descripción estructurada** (componentes, conexiones,
  señales) y guárdala en `figuras/descripciones.md`.
- Revisa siempre que el recorte incluya los rótulos de las señales; sin ellos el diagrama no sirve.

## Prompt general

```text
Eres un asistente experto en arquitectura de computadores. Te adjunto la página N de [PDF].
Necesito extraer el diagrama [nombre] sin texto de relleno.
1. Recorta solo el diagrama, incluyendo todos los rótulos y señales.
2. Si hay una tabla, transcríbela en Markdown conservando filas y columnas.
3. Describe las conexiones: qué sale de cada bloque, qué entra a cada mux y qué selecciona cada señal.
4. No inventes componentes que no estén en la imagen. Si algo no se lee, escribe [ilegible].
5. Devuelve: (a) la imagen recortada, (b) la tabla, (c) una descripción de 5–10 líneas.
```

## Clase 16 — Repaso I2

Archivo: `Clases/Clase-16-Repaso-I2.pdf` (38 p.). Es la **clase de repaso**.
La clase `Syllabus-2026-1/Clases/S1/IIC2343-S1-Clase-16.pdf` (46 p.) es la clase de **I/O**;
sirve para ampliar las páginas 21–37 del repaso.

| Página(s) | Qué extraer | Para qué |
|---|---|---|
| 2–10 | Subrutinas: requisitos, implementación, assembly y ejercicios 2012/2024-2. | P1. |
| 11–18 | Floats: IEEE754, suma y multiplicación. | P2. |
| 19–20 | RISC-V: resumen de instrucciones y convención de llamada. | P3. |
| 21–37 | I/O: memory/port mapped, polling, interrupciones, DMA y ejercicios 2011/2018. | P3. |

**Prompt específico para la página 5–6:**

```text
Extrae el datapath del computador básico con soporte de subrutinas.
Quiero ver: PC, Instruction Memory, Data Memory, ALU, registros A/B, SP, los mux
(DataIn, PC, Address, Adder) y todas las señales de control.
Transcribe la tabla de señales si aparece. Describe en una lista qué entrada elige cada mux
y en qué instrucción se usa.
```

## Clase 5 — Saltos y Subrutinas (2026-2)

Archivo: `Clases/Clase-05-Saltos-y-Subrutinas.pdf`.

| Página(s) | Qué extraer |
|---|---|
| 30–39 | Implementación de `CALL`, `RET`, `PUSH`, `POP`; stack y mux. |
| 40–45 | Listado de instrucciones y tamaños en memoria. |
| 50–54 | Errores comunes y ejemplos de código. |

```text
De la página N, extrae el diagrama que muestra cómo se conecta el stack pointer (SP)
con los mux y la memoria. Marca con flechas: CALL, RET, PUSH, POP.
Luego transcribe la tabla de señales de control para cada instrucción.
```

## Clase 7 — Representaciones Numéricas II

Archivo: `Clases/Clase-07-Floats.pdf`.

| Página(s) | Qué extraer |
|---|---|
| 19–28 | Formato IEEE754, sesgo, casos especiales. |
| 29–38 | Algoritmos de suma y multiplicación con ejemplos. |
| 43–48 | Pérdida de precisión y errores típicos. |

```text
Extrae el ejemplo de suma de floats de la página N: los dos números, el alineamiento,
la suma de significandos y la normalización. Transcribe cada paso en binario.
Haz lo mismo con el ejemplo de multiplicación.
```

## Clase 8 — Arquitectura RISC-V

Archivo: `Clases/Clase-08-RISC-V.pdf`.

| Página(s) | Qué extraer |
|---|---|
| 5–16 | Datapath RISC-V, formatos de instrucción, registros. |
| 17–26 | Tablas de instrucciones (R, I, S, B, U, J). |
| 32–40 | Convención de llamada, stack frame, caller/callee-saved. |
| 62–64 | RV32F: registros float e instrucciones. |

```text
Extrae la tabla de registros RISC-V con nombre ABI y uso.
Extrae el stack frame de ejemplo y marca qué guarda el caller y qué guarda el callee.
Transcribe la tabla de instrucciones de la página N sin omitir pseudoinstrucciones.
```

## Clase 9 — CPU, Memoria e I/O

Archivo: `Clases/Clase-09-IO.pdf`.

| Página(s) | Qué extraer |
|---|---|
| 15–25 | Memory-mapped vs port-mapped; address decoder. |
| 26–38 | Polling, interrupciones, controlador, vectores. |
| 39–46 | DMA, burst vs cycle stealing. |

```text
Extrae el diagrama del address decoder: entradas (dirección, W), salidas (Chip Select RAM,
Chip Select dispositivo) y el bus de datos. Explica qué pasa en una lectura y en una escritura.
Luego extrae el diagrama de interrupciones con IRQ, INT, INTA, ID y EOI.
```

## Pautas I2

### I2 2026-1 P1 (subrutinas)

Archivo: `Interrogaciones/2026-1/IIC2343-2026-1-I2-P1-S1-sol.pdf`.

| Página | Qué extraer |
|---|---|
| 2 | Diagrama del datapath con las modificaciones y tabla de señales. |
| 3–4 | Traza de simulación y resultado final. |

```text
Extrae el diagrama de la página 2 con las modificaciones de hardware.
Transcribe la tabla de señales completa, incluyendo las columnas de cada instrucción.
No omitas las señales que quedan en 0.
```

### I2 2026-1 P2 (floats + I/O)

Archivo: `Interrogaciones/2026-1/IIC2343-2026-1-I2-P2-S1-sol.pdf`.

| Página | Qué extraer |
|---|---|
| 2–3 | Ejercicio de floats y desarrollo. |
| 3–5 | Tabla de registros del dispositivo y código RISC-V. |

```text
Extrae la tabla de registros del dispositivo (dirección, nombre, tipo, descripción).
Transcribe el código RISC-V tal como aparece, con sus comentarios.
Describe qué hace cada label en una frase.
```

### I2 2025-2 P3 (I/O + RISC-V)

Archivo: `Interrogaciones/2025-2/IIC2343-2025-2-I2-sol.pdf`.

| Página | Qué extraer |
|---|---|
| 8–9 | Diagrama del dispositivo y código. |

```text
Extrae el diagrama de estados del dispositivo y el código RISC-V.
Haz una tabla: label → estado → condición → acción → siguiente estado.
```

## Cómo revisar una extracción

- [ ] ¿Están todos los rótulos de señales?
- [ ] ¿Se entiende qué entrada elige cada mux?
- [ ] ¿La tabla tiene todas las columnas?
- [ ] ¿El texto ilegible está marcado como `[ilegible]` y no inventado?
- [ ] ¿La imagen se puede leer en blanco y negro al imprimir?
