# Hoja de apuntes I2 — 2 caras

> Copiar a mano una vez. Si algo no sale sin mirar, eso es lo que hay que repasar.
> Todo cabe en 2 caras si escribes chico; las tablas son la parte más importante.

---

## CARA 1 — Subrutinas + Floats

### Subrutinas: stack

```text
SP = 255 al inicio; SP apunta al próximo libre; tope = SP+1
PUSH: Mem[SP] ← val; SP--
POP:  SP++; val ← Mem[SP]
CALL: Mem[SP] ← PC+1; SP--; PC ← label
RET:  SP++; PC ← Mem[SP]
```

### Señales

| Instr | Ciclos | Señales |
|---|---|---|
| `CALL` | 1 | `W=1, DecSP=1, SAdd=SP, SDIn=PC+1, SPC=LIT, LPC=1, SAdder=PC` |
| `RET` | 2 | 1: `IncSP=1`; 2: `SAdd=SP, SPC=DOUT, LPC=1` |
| `PUSH A` | 1 | `W=1, DecSP=1, SAdd=SP, SDIn=ALU, SA=A, SB=ZERO, SOP=ADD` |
| `POP A` | 2 | 1: `IncSP=1`; 2: `SAdd=SP, LA=1, SA=ZERO, SB=DOUT, SOP=ADD` |
| `RET1` | 1 | `LPC=1, IncSP=1, SAdd=ADDER, SAdder=SP, SPC=DOUT` |
| `PUSHRW A` | 1 | `W=1, SAdd=ADDER, SAdder=SP, SDIn=ALU, SA=A, SB=ZERO, SOP=ADD` |
| `POPRD A` | 1 | `LA=1, SAdd=ADDER, SAdder=SP, SA=ZERO, SB=DOUT` |
| `POP1 A` | 1 | `LA=1, IncSP=1, SAdd=ADDER, SAdder=SP, SA=ZERO, SB=DOUT` |
| `MOV A,SP` | 1 | `LA=1, SA=SP, SB=ZERO, SOP=ADD` |
| `CMP B,SP` | 1 | `SA=B, SB=SP, SOP=SUB`; loads en 0 |

**Truco `SP+1`:** `SAdder=SP` → Adder calcula `SP+1`; `SAdd=ADDER` → se usa como dirección.
Permite `RET1`, `PUSHRW`, `POPRD` y `POP1` en 1 ciclo.

**Hardware:** Mux DataIn (`ALU` vs `PC+1`), Mux PC (`LIT` vs `DOUT`), Mux Address
(`LIT/B/SP/ADDER`), Mux Adder (`PC` vs `SP`), SP con `IncSP/DecSP`, RA opcional (`LRA/SRA`).

**Simulación:** usa direcciones del enunciado. `CALL`/`PUSH` 1 celda; `POP`/`RET` 2.
`CALL` guarda `PC+1`. `RET` puede saltar a otra parte si se pisó `Mem[SP+1]`.
`MOV (B),A` puede pisar el retorno. Flags: los usa la última operación que los modifica.

### Floats IEEE754 (32 bits)

```text
S 1 | E 8 (sesgo 127) | M 23
valor = (-1)^S × 1.M × 2^(E-127)
precisión = 24 bits; exponentes = 254
```

| E | M | Significado |
|---|---|---|
| 0 | 0 | ±0 |
| 0 | ≠0 | subnormal |
| 1..254 | cualquiera | normal |
| 255 | 0 | ±∞ |
| 255 | ≠0 | NaN |

**Guardar:** binario → normalizar `1.xxx × 2^e` → `E=e+127` → `S|E|M`.
**Leer:** hex → binario → separar → `e=E−127` → `1.M × 2^e`.

**Suma:** igualar exponentes (shift right al menor) → sumar significandos → normalizar → redondear.
**Multiplicación:** `e=eA+eB` (o `E=EA+EB−127`) → multiplicar significandos → normalizar →
redondear → `S=SA xor SB`.

**Precisión:** si el resultado exacto necesita >24 bits, se pierde. `2^50+1` → se pierde el 1.
`2^70` exacto. `0.1` no exacto. `εmach float = 2^-23`; `double = 2^-52`.
**Punto fijo:** simple/rápido, poco rango. **Flotante:** más rango, menos precisión.

---

## CARA 2 — I/O + RISC-V

### I/O

| | Memory-mapped | Port-mapped |
|---|---|---|
| Espacio | mismo que RAM | separado |
| Instrucciones | `lw/sw` | `IN/OUT` |
| ISA | no cambia | cambia |
| Uso | RISC-V | x86 |

**Address decoder:** entre bus y RAM/dispositivos; compara dirección, activa `Chip Select`,
elige registro. Único punto de selección; el CPU no cambia.

**Polling:** CPU lee status en loop; simple, desperdicia ciclos. USB usa polling.
**Interrupción:** dispositivo `IRQ` → controlador (`máscara`, `prioridad`, `in-service`) → `INT` →
CPU termina instrucción, guarda estado, `IF=0` → `INTA` → ID → vector → ISR → `EOI` → `IF=1`.
**Tipos:** hardware, software (`ecall`), excepción (división por 0, acceso inválido).
**DMA:** CPU programa origen/destino/cantidad; DMA mueve; interrumpe al final.
Burst = toma el bus; cycle stealing = intercala ciclos. Libera CPU; compite por bus.

### RISC-V

**Registros:** `zero, ra, sp, gp, tp, t0-6, s0-11, a0-7`.
**ABI:** `t/a/ra` caller-saved; `s/sp` callee-saved; args `a0-a7`; retorno `a0`.
**No hay flags:** branches comparan registros (`beq`, `bne`, `blt`, `bge`, `bltu`, `bgeu`).
**Load/store:** `lw rd, off(rs1)`, `sw rs2, off(rs1)`; no `lw rd, rs1`.
**Saltos:** `jal rd, label` (call), `jalr zero, 0(ra)` (ret), `j label`.
**Pseudo:** `li`, `la`, `mv`, `not`, `neg`, `beqz`, `bnez`, `bgt`, `ble`, `ret`, `call`, `nop`.
**Inmediatos:** `addi` 12 bits con signo; shifts 5 bits; `lui` carga bits 31:12.
**Stack frame:**
```asm
addi sp, sp, -16
sw ra, 12(sp)
sw s0, 8(sp)
# ...
lw s0, 8(sp)
lw ra, 12(sp)
addi sp, sp, 16
ret
```
**RV32F:** `flw/fsw`, `fadd.s`, `fsub.s`, `fmul.s`, `fdiv.s`, `fcvt.s.w`, `fcvt.w.s`;
dirección en entero, dato en `f`; args `fa0-7`.

**Leer código:** prólogo → args → loop/branch → array (`slli`+`add`+`lw`) → llamada (`jal ra`) →
epílogo. **I/O RISC-V:** base + offsets de 4 bytes (`0,4,8,...`); status loop; `lw`/`sw`.

**Errores:** no guardar `ra`; usar `t` después de llamada; no restaurar `sp`; `lw` sin offset;
`addi` fuera de rango; confundir `lb` (signo) con `lbu`; creer que hay flags.
