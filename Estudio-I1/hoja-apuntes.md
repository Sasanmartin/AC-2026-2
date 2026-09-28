# Hoja de Apuntes I1 — guía para copiar a mano (2 caras)

> Copia esto a mano en tu hoja permitida (ambas caras). Priorizado: primero lo que no
> puedes memorizar. Deja espacio en blanco para anotar errores del simulacro.

---

## CARA 1

### 1. Tabla de saltos (CMP A,B → a − b)
```
JEQ   Z = 1        a == b
JNE   Z = 0        a != b
JGT   Z = 0 y N = 0  a > b
JLT   N = 1        a < b
JGE   N = 0        a >= b
JLE   Z = 1 o N = 1  a <= b
JCR   C = 1        (carry / bit descartado)
JOV   V = 1        (overflow)
```

### 2. Compuertas lógicas (salida = 1 cuando…)
```
NOT A      → A = 0
A AND B    → ambas = 1
A OR B     → al menos una = 1
A XOR B    → son distintas
NAND       → NO(AND): 0 solo si ambas = 1
NOR        → NO(OR): 1 solo si ambas = 0
```

### 3. Flags de la ALU + overflow
```
Z = resultado es 0
N = resultado es negativo (MSB)
C = carry de salida (o bit descartado en shift)
O/V = overflow (fuera de rango con signo)

Overflow (con signo), 4 casos:
  A≥0, B≥0 → O=1 si A+B < 0
  A<0, B<0 → O=1 si A+B ≥ 0
  A≥0, B<0 → O=1 si A−B < 0
  A<0, B≥0 → O=1 si A−B ≥ 0
```
Rangos: n bits sin signo `[0, 2^n −1]`; con signo C2 `[−2^(n−1), +2^(n−1) −1]` → 8 bits: −128..127.

### 4. Potencias de 2 (referencia rápida)
```
2^0  1      2^6   64     2^12  4096
2^1  2      2^7  128     2^13  8192
2^2  4      2^8  256     2^14 16384
2^3  8      2^9  512     2^15 32768
2^4 16     2^10 1024     2^16 65536
2^5 32     2^11 2048
```

---

### 5. Recetas de conversión
```
C2        : negar todos los bits + 1
bin→hex   : agrupar de a 4 bits (desde la derecha)
bin→oct   : agrupar de a 3 bits
dec→bin   : divisiones por 2, restos al revés
base 8→4  : cada dígito oct → 3 bits; agrupar de a 2 bits
            (agregar 0 a la izquierda si falta); cada par → dígito base 4
extender bits (8→16): positivo → 0s; negativo → 1s
```

### 6. Minterm / Maxterm (de tabla a circuito)
```
Minterm: fila con 1 → AND de variables (NOT las que valen 0); OR todo
Maxterm: fila con 0 → OR de variables (NOT las que valen 1); AND todo
```

### 7. Sumador / Restador
```
Half Adder : S = A XOR B ; Cout = A AND B
Full Adder : S = A XOR B XOR Cin ; Cout = c1 OR c2
Sumador-Restador: Cin=0 → A+B ; Cin=1 → A−B (negar B + 1)
```

---

## CARA 2

### 8. Contadores con flip-flops D
```
Incrementa (Q' = siguiente estado):
  Q0' = NOT Q0
  Q1' = Q0 XOR Q1
  Q2' = (Q0 AND Q1) XOR Q2

Decrementa:
  Q0' = NOT Q0
  Q1' = Q0 XNOR Q1

Con condición A (inc solo si A=1): Q' = (A AND inc) OR (NOT A AND Q)
  → equivale a un MUX con A como selector.
```

### 9. Almacenamiento
```
Latch RS : S=1→Q=1 ; R=1→Q=0 ; S=R=1→mantiene ; S=R=0→indef.
Latch D  : D=C=1→1 ; D=0,C=1→0 ; C=0→mantiene
Flip-Flop D: cambia SOLO en flanco de subida (↑): Q(t+1)=D
Registro : N flip-flops D (N bits) + carga (L) + reset (R)
Contador : registro + señal Up/Down (+1 / −1 por flanco)

Endianness (int multibyte en memoria):
  Big   : byte MSB primero (dir. más baja)
  Little: byte LSB primero
  Ej. 0x0FA71D23: little → 23 1D A7 0F
```

### 10. ISA del computador básico
```
Segmentos: DATA (variables) luego CODE (instrucciones)

MOV A, Lit | MOV B, Lit          cargar literal
MOV A, (var) / MOV (var), A      memoria, direccionamiento DIRECTO
MOV A, (B)  / MOV (B), A         memoria, dirección en registro B (INDIRECTO)
ADD/SUB A, B | A, Lit | A, (var) operaciones ALU (resultado en A)
INC / DEC / NOT A,A / SHL/SHR A,A / AND / XOR / CMP
PUSH A / POP B                   stack
CALL sub / RET                   subrutinas
JMP label                        salto incondicional
Parentesis (B) = usar contenido de B como dirección
```

### 11. Señales de control (microarquitectura)
```
LA / LB / LPC   : cargar registro A / B / PC (1 activo)
W               : escribir en memoria de datos
IncSP / DecSP   : +1 / −1 al puntero de stack
SA (SA0,SA1)    : selección Mux A (A, B, ZERO, LIT…)
SB (SB0,SB1,SB2): selección Mux B (B, DOUT, LIT…)
SOP             : operación ALU (ADD, SUB, AND, XOR, NOT…)
SAdd            : dirección de memoria (LIT, B, SP, B+offset…)
SDin            : dato a escribir en memoria
SPC             : selección Mux PC (next, LIT, DOUT, RA…)
Condición       : saltos → LPC depende de flag (Z/N), no fijo 1

Instrucciones básicas (referencia):
  MOV A, Lit : LA=1, SA=ZERO, SB=LIT, SOP=ADD
  ADD A, B   : LA=1, SA=A, SB=B, SOP=ADD
  JMP        : LPC=1, SPC=LIT
  JEQ        : LPC=1 solo si Z=1, SPC=LIT
```

### 12. Mini-ejemplos resueltos (recordatorio)
```
0xCAFE en C2 → 1100 1010 1111 1110b, MSB=1 → neg. → C2 = 0011 0101 0000 0010 = 13570 → −13570

712₈ → 111 001 010 → 01 11 00 10 10 → 13022₄

Trazado de simulación (P3): tabla por instrucción
  # | Instr | A | B | mem | flags | PC  → valores finales de A y B
  OJO: saltos usan flags de la operación ANTERIOR
  OJO: RET carga en PC el tope del stack (revisar si el código lo pisa)
```

---

## Tips para copiarla
- Escribe **pequeño y en columnas** (estilo índice) para que quepa en 2 caras.
- Usa colores/recuadros solo para las **tablas** (saltos, señales, potencias).
- Deja 1/4 de hoja en blanco para errores del simulacro del día 2.
- Practica escribiéndola una vez de memoria: lo que ya sabes, no lo copies.
