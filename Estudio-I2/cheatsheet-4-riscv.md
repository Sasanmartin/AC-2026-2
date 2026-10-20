# Cheatsheet 4 — RISC-V (P3)

> **Lo que se pregunta:** leer/escribir código RISC-V, entender la convención de llamada,
> identificar qué hace una función y manejar registros/stack. En I2 suele venir junto con I/O.

## 1. Modelo mental

- **ISA load/store:** solo `lw`/`sw` (y variantes) acceden a memoria. Las operaciones aritméticas
  son registro-registro o registro-inmediato.
- **32 registros** de 32 bits (`x0`–`x31`). `x0` siempre vale 0.
- **PC** separado; no hay registro de flags. Los branches comparan **dos registros** directamente:
  `beq rs1, rs2, label`.
- **Little-endian**.
- **Instrucciones de 32 bits**, alineadas a 4 bytes.
- No hay `IN`/`OUT`: el I/O es **memory-mapped** (`lw`/`sw` a direcciones de dispositivo).

## 2. Registros y ABI

| Registro | Nombre ABI | Uso | ¿Se preserva en llamada? |
|---|---|---|---|
| `x0` | `zero` | Constante 0. | — |
| `x1` | `ra` | Return address. | **Caller-saved** |
| `x2` | `sp` | Stack pointer. | **Callee-saved** |
| `x3` | `gp` | Global pointer. | Reservado |
| `x4` | `tp` | Thread pointer. | Reservado |
| `x5–x7` | `t0–t2` | Temporales. | **Caller-saved** |
| `x8` | `s0/fp` | Saved / frame pointer. | **Callee-saved** |
| `x9` | `s1` | Saved. | **Callee-saved** |
| `x10–x17` | `a0–a7` | Argumentos / retorno. | **Caller-saved** |
| `x18–x27` | `s2–s11` | Saved. | **Callee-saved** |
| `x28–x31` | `t3–t6` | Temporales. | **Caller-saved** |

**Regla mnemotécnica:**
- `t` = temporary → si llamas a otra función, **puede cambiar**; guárdalo si lo necesitas después.
- `s` = saved → la función llamada **debe restaurarlo** si lo usa.
- `a` = argument/return → parámetros y resultado.
- `ra` = dirección de retorno → si tu función llama a otra, **guárdalo** en el stack.

## 3. Formatos de instrucción

| Tipo | Para qué | Campos (aprox.) |
|---|---|---|
| **R** | Aritmética registro-registro | `funct7, rs2, rs1, funct3, rd, opcode` |
| **I** | Inmediatos, loads, `jalr` | `imm[11:0], rs1, funct3, rd, opcode` |
| **S** | Stores | `imm[11:5], rs2, rs1, funct3, imm[4:0], opcode` |
| **B** | Branches | `imm, rs2, rs1, funct3, imm, opcode` |
| **U** | `lui`, `auipc` | `imm[31:12], rd, opcode` |
| **J** | `jal` | `imm, rd, opcode` |

No hace falta memorizar los bits exactos para I2, pero sí saber que **el inmediato de `addi` es de
12 bits con signo** (`−2048..2047`) y que los branches tienen alcance limitado.

## 4. Instrucciones esenciales

### Aritmética y lógica

| Instrucción | Efecto |
|---|---|
| `add rd, rs1, rs2` | `rd = rs1 + rs2` |
| `sub rd, rs1, rs2` | `rd = rs1 − rs2` |
| `and rd, rs1, rs2` | `rd = rs1 & rs2` |
| `or rd, rs1, rs2` | `rd = rs1 \| rs2` |
| `xor rd, rs1, rs2` | `rd = rs1 ^ rs2` |
| `sll rd, rs1, rs2` | Shift left lógico por `rs2[4:0]` |
| `srl rd, rs1, rs2` | Shift right lógico |
| `sra rd, rs1, rs2` | Shift right aritmético (preserva signo) |
| `slt rd, rs1, rs2` | `rd = (rs1 < rs2) ? 1 : 0` (con signo) |
| `sltu rd, rs1, rs2` | Igual, pero **sin signo** |
| `addi rd, rs1, imm` | `rd = rs1 + imm` (imm 12 bits con signo) |
| `andi`, `ori`, `xori` | Igual con inmediato |
| `slli`, `srli`, `srai` | Shift con `shamt` de 5 bits |
| `slti`, `sltiu` | Comparación con inmediato |
| `lui rd, imm20` | `rd = imm20 << 12` |
| `auipc rd, imm20` | `rd = PC + (imm20 << 12)` |

### Memoria

| Instrucción | Efecto |
|---|---|
| `lb rd, off(rs1)` | Carga byte con **signo**. |
| `lbu rd, off(rs1)` | Carga byte **sin signo**. |
| `lh`, `lhu` | Halfword (16 bits), con/sin signo. |
| `lw rd, off(rs1)` | Carga word (32 bits). |
| `sb rs2, off(rs1)` | Guarda byte. |
| `sh rs2, off(rs1)` | Guarda halfword. |
| `sw rs2, off(rs1)` | Guarda word. |

**Sintaxis:** `lw t0, 0(t1)` → dirección = `t1 + 0`. **No** existe `lw t0, t1`.

### Saltos y branches

| Instrucción | Efecto |
|---|---|
| `beq rs1, rs2, label` | Salta si `rs1 == rs2`. |
| `bne rs1, rs2, label` | Salta si `rs1 != rs2`. |
| `blt rs1, rs2, label` | Salta si `rs1 < rs2` (con signo). |
| `bge rs1, rs2, label` | Salta si `rs1 >= rs2` (con signo). |
| `bltu`, `bgeu` | Igual, sin signo. |
| `jal rd, label` | `rd = PC+4; PC = label`. `jal label` usa `ra`. |
| `jalr rd, off(rs1)` | `rd = PC+4; PC = rs1 + off`. |
| `jalr zero, 0(ra)` | **Return** (`ret`). |

### Pseudoinstrucciones útiles

| Pseudo | Se expande a |
|---|---|
| `li rd, imm` | `lui` + `addi` (o `addi` si cabe). |
| `la rd, label` | `auipc` + `addi`. |
| `mv rd, rs` | `addi rd, rs, 0`. |
| `not rd, rs` | `xori rd, rs, -1`. |
| `neg rd, rs` | `sub rd, zero, rs`. |
| `j label` | `jal zero, label`. |
| `ret` | `jalr zero, 0(ra)`. |
| `call label` | `jal ra, label` (+ `auipc` si está lejos). |
| `nop` | `addi zero, zero, 0`. |
| `beqz rs, label` | `beq rs, zero, label`. |
| `bnez rs, label` | `bne rs, zero, label`. |
| `bgt rs1, rs2, label` | `blt rs2, rs1, label`. |
| `ble rs1, rs2, label` | `bge rs2, rs1, label`. |

## 5. Convención de llamada

### Argumentos y retorno

- Primeros **8 argumentos**: `a0–a7`.
- Argumentos adicionales: **en el stack**, en orden.
- Retorno: `a0` (y `a1` si es de 64 bits).
- `ra` guarda la dirección de retorno.

### Stack frame típico

```asm
func:
    addi sp, sp, -16       # reserva 16 bytes (múltiplo de 16)
    sw   ra, 12(sp)        # guarda return address
    sw   s0, 8(sp)         # guarda registros callee-saved que uses
    sw   s1, 4(sp)
    # ... cuerpo de la función ...

    lw   s1, 4(sp)         # restaura en orden inverso
    lw   s0, 8(sp)
    lw   ra, 12(sp)
    addi sp, sp, 16
    ret                    # jalr zero, 0(ra)
```

**Checklist:**
1. ¿Mi función llama a otra? → guarda `ra`.
2. ¿Uso `s0–s11`? → guárdalos y restáuralos.
3. ¿Uso `t0–t6` o `a0–a7` después de una llamada? → guárdalos **antes** de llamar.
4. ¿El stack queda alineado a 16 bytes? → sí, usa múltiplos de 16.
5. ¿Restauro `sp` exactamente como estaba? → sí.

## 6. `ecall` (RARS)

| `a7` | Servicio | Argumento | Resultado |
|---|---|---|---|
| 1 | Print int | `a0` | — |
| 4 | Print string | `a0` = dirección | — |
| 5 | Read int | — | `a0` |
| 10 | Exit | — | — |
| 11 | Print char | `a0` | — |
| 12 | Read char | — | `a0` |

## 7. RV32F (floats)

- 32 registros `f0–f31`: `ft0–ft11` (temporales), `fs0–fs11` (saved), `fa0–fa7` (args).
- `flw rd, off(rs1)` / `fsw rs2, off(rs1)` → carga/guarda float; la **dirección** va en un registro
  entero (`rs1`), el **dato** en un registro float.
- Operaciones: `fadd.s`, `fsub.s`, `fmul.s`, `fdiv.s`, `fsqrt.s`, `fmin.s`, `fmax.s`.
- Conversión: `fcvt.s.w rd, rs1` (int → float), `fcvt.w.s rd, rs1` (float → int, trunca).
- Movimiento: `fmv.s.x rd, rs1`, `fmv.x.s rd, fs1`, `fmv.s rd, fs1`.
- Comparación: `feq.s`, `flt.s`, `fle.s` → resultado en registro entero (`0/1`).
- `fcsr` contiene flags de excepción y modo de redondeo (`frm`).

## 8. Leer código: qué buscar

1. **Prólogo:** `addi sp, sp, -N`, `sw ra, ...`, `sw s0, ...` → función con stack frame.
2. **Argumentos:** usa `a0`, `a1`, ... al inicio.
3. **Loop:** un label, un branch hacia atrás y un contador (`addi t0, t0, 1`).
4. **Array:** `slli t0, i, 2` + `add t1, base, t0` + `lw t2, 0(t1)`.
5. **Llamada:** `jal ra, func` o `call func`; después usa `a0` como resultado.
6. **Epílogo:** restaura `ra`, `s*`, `sp`, luego `ret`.
7. **Recursión:** busca que se guarde `ra` y los argumentos en el stack antes de la llamada recursiva.

### Ejemplo: suma de un arreglo

```asm
# a0 = base, a1 = n; retorna suma en a0
sum:
    li   t0, 0          # i = 0
    li   t1, 0          # suma = 0
loop:
    bge  t0, a1, done   # si i >= n, termina
    slli t2, t0, 2      # t2 = i * 4
    add  t2, a0, t2     # t2 = base + i*4
    lw   t3, 0(t2)      # t3 = A[i]
    add  t1, t1, t3     # suma += A[i]
    addi t0, t0, 1      # i++
    j    loop
done:
    mv   a0, t1         # retorno
    ret
```

## 9. Errores típicos

- `lw t0, t1` → falta `offset(base)`; debe ser `lw t0, 0(t1)`.
- Usar `addi` con un inmediato fuera de `−2048..2047`; usa `li` o `lui`+`addi`.
- Olvidar guardar `ra` antes de una llamada anidada.
- Usar `t` registers después de una llamada sin guardarlos.
- No restaurar `sp` al final.
- Confundir `jalr zero, 0(ra)` (return) con `jalr ra, 0(ra)`.
- En branches, comparar con `zero` cuando se necesita otra constante: usa `li` en un registro.
- Olvidar que `lb` sign-extiende y `lbu` no.
- En RV32F, usar un registro entero para el dato float (debe ser `f`).
- Creer que RISC-V tiene flags: **no**; los branches comparan registros.
