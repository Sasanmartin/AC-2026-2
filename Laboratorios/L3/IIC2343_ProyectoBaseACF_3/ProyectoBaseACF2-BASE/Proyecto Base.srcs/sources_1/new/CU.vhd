library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CU is
    Port (
            op_code         : in   std_logic_vector (19 downto 0);
            sel_a           : out  std_logic_vector (1 downto 0);
            sel_b           : out  std_logic_vector (1 downto 0);
            load_a          : out  std_logic;
            load_b          : out  std_logic;
            ram_write       : out  std_logic;
            sel_op          : out  std_logic_vector (2 downto 0)
          );
end CU;

-- ===========================================================================
-- [ACF] Se completo la logica interna de la unidad de control.
-- La entidad NO se modifica (respeta el comentario -- No Tocar del base):
-- solo se implemento su architecture, que venia vacia.
-- Codificacion: la Tabla 1 del enunciado del ACF3 (la que usa el ensamblador).
-- ===========================================================================
-- [ACE / DocPrep] La variante CON SALTOS esta COMENTADA mas abajo, bajo el
-- banner "ACE (DocPrep)". El ensamblador de esta actividad NO usa saltos.
-- ===========================================================================

architecture Behavioral of CU is

begin

    -- Codificacion entregada por el ensamblador (Tabla 1 del enunciado):
    -- 1:0   Mux A    0:3   Mux B    6:4   ALU
    -- 7     load A   8     load B   9     write RAM
    sel_a     <= op_code(1 downto 0);
    sel_b     <= op_code(3 downto 2);
    sel_op    <= op_code(6 downto 4);
    load_a    <= op_code(7);
    load_b    <= op_code(8);
    ram_write <= op_code(9);

    -- =======================================================================
    -- ============  ACE (DocPrep): VARIANTE CON SALTOS (COMENTADO)  =========
    -- El ensamblador de esta actividad NO genera saltos (los bits 10..19 del
    -- opcode valen siempre 0), por eso la logica de arriba es suficiente.
    -- Para la variante con saltos hay que:
    --   1) ampliar la ENTIDAD de CU con:
    --          c_in, z_in, n_in : in  std_logic;
    --          load_pc          : out std_logic;
    --          load_status      : out std_logic;
    --   2) declarar las senales de salto,
    --   3) descomentar el bloque siguiente.
    -- Condiciones (DocPrep): JEQ->Z=1, JNE->Z=0, JLT->N=1, JLE->Z=1 o N=1,
    -- JGT->Z=0 y N=0, JGE->N=0, JMP->incondicional. El orden de bits 12..19
    -- es un supuesto y debe confirmarse con el ensamblador de esa variante.
    -- =======================================================================
    -- signal jmp, jeq, jne, jlt, jle, jgt, jge, jre : std_logic;
    --
    -- jmp <= op_code(12);  jeq <= op_code(13);  jne <= op_code(14);
    -- jlt <= op_code(15);  jle <= op_code(16);  jgt <= op_code(17);
    -- jge <= op_code(18);  jre <= op_code(19);   -- jre: reserva
    --
    -- load_pc <= '1' when (jmp = '1')
    --                 or (jeq = '1' and z_in = '1')
    --                 or (jne = '1' and z_in = '0')
    --                 or (jlt = '1' and n_in = '1')
    --                 or (jle = '1' and (z_in = '1' or n_in = '1'))
    --                 or (jgt = '1' and z_in = '0' and n_in = '0')
    --                 or (jge = '1' and n_in = '0')
    --            else '0';
    --
    -- load_status <= '1' when op_code(19 downto 12) = "00000000" else '0';
    -- =======================================================================

end Behavioral;
