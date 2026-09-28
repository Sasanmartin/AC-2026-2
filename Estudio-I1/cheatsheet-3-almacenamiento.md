# Cheatsheet 3 — Almacenamiento de datos (P2)

## 1. Latches y Flip-Flops
| Elemento | Comportamiento |
|---|---|
| Latch RS | S=1 → Q=1; R=1 → Q=0; S=R=1 → mantiene Q(t); S=R=0 → indefinido |
| Latch D | D=1 y C=1 → Q=1; D=0 y C=1 → Q=0; C=0 → mantiene |
| **Flip-Flop D** | Solo cambia en el **flanco de subida** (↑) del clock: `Q(t+1) = D`. El resto del tiempo mantiene el valor |

- El latch es sensible a nivel; el flip-flop es sensible al **flanco** (eso resuelve el problema de activarse en un instante preciso).

## 2. Reloj y registros
- Reloj = tren de pulsos con ancho e intervalo precisos. Todos los registros de un computador usan el mismo reloj.
- **Registro** = conjunto de N flip-flops D (N = bits de la palabra). Tiene control de carga (L) y reset (R):
  - `↑, L=1 → Q = entrada`; `↑, L=0 → mantiene`.
- **Registro contador**: registro + señal Up (suma 1) / Down (resta 1) en cada flanco.

## 3. Memorias
- **RAM**: acceso por dirección (direccionamiento). Palabras de 8 bits típicamente. Permite leer y escribir (`WE`).
- 256 celdas = direcciones `00000000` a `11111111` (2^8).
- RAM de **doble puerto** (tipo I1 2023-2): dos direcciones de lectura/escritura simultáneas → dos mux para DataOut, dos demux para WE/DataIn, OR por registro.

## 4. Variables y arreglos
- **Variable**: valor temporal con un único tipo, guardado en registros o RAM.
- **Arreglo**: variable con 4 atributos → **tipo de dato, endianness, largo y dirección de inicio**. Se indexa para acceder a cada elemento.

## 5. Endianness (¡saber calcular!)
- Dato multibyte almacenado en direcciones consecutivas:
  - **Big endian**: byte más significativo primero (en la dirección más baja).
  - **Little endian**: byte menos significativo primero.
- Ejemplo: `int 0x0FA71D23` de 4 bytes:
  - Big: `mem[0]=0x0F, mem[1]=0xA7, mem[2]=0x1D, mem[3]=0x23`
  - Little: `mem[0]=0x23, mem[1]=0x1D, mem[2]=0xA7, mem[3]=0x0F`

## Ejemplo tipo prueba (I1 2022-1: "La Memoria, Mi Dato...")
> Disponible en `Interrogaciones/2022-1/IIC2343-2022-1-S2-Memoria-Palindromo.pdf`.
> Arreglo de 3 enteros sin signo de 16 bits desde la dirección 1, little-endian, palabras de 8 bits:
> juntar de a 2 bytes al revés (`byte1|byte0`), luego convertir el entero (a octal si lo piden).
