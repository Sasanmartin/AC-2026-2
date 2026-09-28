# Tareas de visión — mejorar cheatsheets con DeepSeek V4 Flash Vision Exp

> Objetivo: extraer de los **diagramas** (circuitos y computador básico) los detalles que el texto
> no capturó, para mejorar `cheatsheet-2-circuitos.md` y `cheatsheet-5-microarquitectura.md`.

## Cómo usar esta guía
1. Abre una **nueva sesión** de opencode.
2. `/models` → selecciona **DeepSeek V4 Flash Vision Exp**.
3. Adjunta cada página indicada (arrástrala a la sesión o usa la referencia de archivo) y pega el prompt correspondiente.
4. Pega aquí (o en un `.md`) las respuestas tal cual, para integrarlas a los cheatsheets.

**Consejo**: adjunta 1 página por mensaje y usa los prompts exactos. Si la respuesta viene vacía, pide "respóndeme solo con la descripción final, sin razonamiento".

---

## SECCIÓN A — Circuitos y contadores (cheatsheet-2)

### A1. Half Adder y Full Adder
Adjuntar: `Syllabus-2026-2/Clases/S1/IIC2343-S1-Clase-02.pdf` → páginas **26 (Half Adder)**, **27-28 (Full Adder)**.

> Describe el diagrama del Half Adder: qué compuertas usa (XOR/AND) y sus entradas/salidas.
> Luego el Full Adder: cómo se conectan los dos Half Adders y la compuerta OR para el carry.
> Indica la notación exacta usada (nombres de señales s, c, cin, cout).

### A2. Sumador y Restador
Adjuntar: `IIC2343-S1-Clase-02.pdf` → páginas **29 (Sumador)**, **30 (Restador)**.

> Describe el diagrama del sumador de n bits (cadena de Full Adders) y del sumador-restador.
> ¿Cómo se implementa la resta (negación de B + Cin=1)? ¿Qué señal controla suma vs resta?

### A3. Enabler, Multiplexor y Demux
Adjuntar: `Syllabus-2026-2/Clases/S1/IIC2343-S1-Clase-03-V00.pdf` → páginas **16-18 (Enabler)**, **19-21 (Multiplexor)**, **22 (Demux)**.

> Describe cada diagrama: compuertas usadas, señal de control/selector y su tabla.
> Para el Mux: ¿cuántas entradas tiene y cuántos bits de selector en cada versión (2 a 1, 4 bits, 4x4)?

### A4. Flip-Flop D y Registro Contador
Adjuntar: `IIC2343-S1-Clase-03-V00.pdf` → páginas **47 (Flip-Flop D)**, **53-54 (Registro Contador)**.

> Describe el símbolo del flip-flop D (triángulo = clock, entradas D/C, salida Q) y el registro
> contador: cómo se implementa la suma/resta 1 y las señales Up/Down.

### A5. Contador con condición (I1 2026-1, Bowser Boom)
Adjuntar: `Estudio-I1/Interrogaciones/2026-1/IIC2343-2026-1-I1-sol.pdf` → páginas **5-6** (P2b).

> Describe el circuito del contador de 2 bits que decrementa: expresión de Q0' y Q1'
> (flip-flops D + XOR/XNOR) y cómo se conectan los multiplexores con la señal Boom
> (qué valor selecciona cada rama: decrementado vs constante 1).

### A6. Contador inc/dec con mux (I1 2025-2, docente estados de ánimo)
Adjuntar: `Estudio-I1/Interrogaciones/2025-2/IIC2343-2025-2-I1-sol.pdf` → páginas **4-6** (P2b).

> Describe el contador de 2 bits que incrementa/decrementa: expresiones de Q0' y Q1'
> (NOT Q0, Q0 XOR Q1 / XNOR) y cómo los multiplexores seleccionan entre incrementar,
> decrementar o mantener según las señales A y B.

---

## SECCIÓN B — Microarquitectura (cheatsheet-5)

### B1. Diagrama completo del computador básico (I1 2026-1)
Adjuntar: `Estudio-I1/Interrogaciones/2026-1/IIC2343-2026-1-I1-sol.pdf` → páginas **7-8** (P3).

> Describe el diagrama del computador básico de la pauta:
> - Entradas de los multiplexores **Mux A** (SA) y **Mux B** (SB): qué señales se seleccionan y cuántos bits tiene cada selector.
> - El **Mux Address** (SAdd) y el **Mux PC** (SPC).
> - Las conexiones agregadas para **SUB B,B,A**, **ADD (B),Lit** y **RESTART** (qué salida se conecta a qué mux).
> - Cómo crece la salida de la Control Unit al ampliar SA/SB.

### B2. SWAP y JGTCMP (I1 2025-2)
Adjuntar: `Estudio-I1/Interrogaciones/2025-2/IIC2343-2025-2-I1-sol.pdf` → página **5** (P3).

> Describe el diagrama con el **Mux A In** (SAIn): para qué se usa, qué selecciona en SWAP A,B,
> y por qué JGTCMP no requiere modificaciones. Indica la tabla de señales resultante.

### B3. MOV B,SP / JMP B (I1 2024-1)
Adjuntar: `Estudio-I1/Interrogaciones/2024-1/IIC2343-2024-1-I1-sol.pdf` → páginas **11-12** (P4).

> Describe los diagramas modificados para **MOV B,SP** (conexión de SP al Mux A) y **JMP B**
> (conexión de la ALU al Mux PC / ampliación de SPC). Indica las señales de cada instrucción.

---

## Formato de respuesta que necesito
Para cada ítem, pégame:
- La descripción textual que te dio el modelo.
- La **tabla de señales** (si la dio) copiada tal cual.
- Cualquier notación de conexiones (ej. "salida de B → Mux A", "SPC pasa a 2 bits").

Con eso actualizo los cheatsheets y regenero el HTML imprimible.
