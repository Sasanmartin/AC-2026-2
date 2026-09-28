# Cheatsheet 4 — Assembly del computador básico y saltos (P3)

## 1. Estructura de un programa
```
DATA:
  a  5        ; variables (datos) primero
  b  3
CODE:
  MOV A, (a)  ; instrucciones después
  ...
```

## 2. ISA básica
- **MOV A, Lit / MOV B, Lit**: cargar literal. `MOV A, (var)`: cargar desde memoria (direccionamiento directo).
- **MOV (var), A**: guardar en memoria. `MOV (B), A`: guardar en la dirección que dice B (indirecto).
- **ADD/SUB A, B | A, Lit | A, (var)**: operaciones ALU. `INC/INC (var)`, `DEC`, `NOT A, A`, `SHL/SHR A, A`, `AND`, `XOR`, `CMP`.
- **PUSH A / POP B**: stack. **CALL sub / RET**: subrutinas (post-I1 probablemente, revisar clase 04).
- **JMP label**: salto incondicional. Etiquetas = dirección de la línea.
- Paréntesis `(B)` = usar el contenido de B como **dirección de memoria**.

## 3. Saltos condicionales — CMP + flags
`CMP A, B` restaura `A − B` **sin modificar A ni B**, y actualiza las flags Z y N.

| Salto | Condición (flags) | Equivalente |
|---|---|---|
| JEQ | Z = 1 | a == b |
| JNE | Z = 0 | a != b |
| JGT | Z = 0 y N = 0 | a > b |
| JLT | N = 1 | a < b |
| JGE | N = 0 | a >= b |
| JLE | Z = 1 o N = 1 | a <= b |
| JCR / JOV | C = 1 / O(V) = 1 | por excepción |

- **OJO (error clásico)**: el salto usa las flags **de la operación anterior**. Si entre `CMP` y el salto condicional hay otra instrucción que cambie flags (como `JEQ end`), el `JNE loop` evaluará flags equivocadas.

## 4. Registro Status
Guarda Z, N, C, O. Los saltos leen de ahí. Se conecta a la Unidad de Control.

## 5. Simulación paso a paso (cómo responder "valores finales")
Para "indique los valores de A y B al finalizar":
1. Haz una **tabla de trazado** por instrucción: `# | Instr | A | B | mem afectada | flags | PC destino`.
2. Asigna direcciones de memoria a cada instrucción (primera línea de CODE = dirección 0, `RET`/saltos de 2 celdas si se indica).
3. Presta atención a: direccionamiento indirecto `MOV A,(B)` (lee la celda cuya dirección es B), `MOV (B), Lit`, shifts (bit descartado → flag C), y qué instrucción queda al vuelo tras un `RET`.
4. El stack: `PUSH` decrece SP y guarda; `RET` carga en PC el tope del stack (¡puede saltar a un valor inesperado si el stack fue modificado!).

## Ejemplo de error frecuente (I1 2024-1)
> En una subrutina, `MOV (B), 14` escribió sobre la celda que contenía la **dirección de retorno** del `RET`. Resultado: el programa no volvió a `MOV B, (res)` sino a otra instrucción, dejando B con el valor calculado adentro. → Verificar siempre si el código pisa el stack/retorno.
