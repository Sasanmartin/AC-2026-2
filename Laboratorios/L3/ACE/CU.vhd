-- ===========================================================================
-- IIC2343 - Actividad Formativa 3 - Unidad de Control
-- VERSION ACE / DocPrep (con saltos)
-- ===========================================================================
-- Reparticion de la palabra de control segun el DocPrep:
--   bits 2:0   operacion de la ALU (sel_op)
--   bits 5:3   cargas:  3=load_a  4=load_b  5=ram_write
--   bits 11:6  seleccion de muxes ("un bit por entrada"):
--                6 = Mux A Reg A | 7 = Mux A Uno | 8 = Mux A Cero
--                9 = Mux B Reg B | 10 = Mux B Literal | 11 = Mux B RAM
--   bits 19:12 bits de salto:
--                12=JMP 13=JEQ 14=JNE 15=JLT 16=JLE 17=JGT 18=JGE 19=reserva
--
-- La CU debe TRADUCIR los bits de mux (uno por entrada) a un selector de 2 bits,
-- y producir load_pc a partir del tipo de salto y las flags guardadas.
-- ===========================================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CU is
    Port (
            op_code     : in   std_logic_vector (19 downto 0);
            c_in        : in   std_logic;                  -- flag C guardada
            z_in        : in   std_logic;                  -- flag Z guardada
            n_in        : in   std_logic;                  -- flag N guardada
            sel_a       : out  std_logic_vector (1 downto 0);
            sel_b       : out  std_logic_vector (1 downto 0);
            load_a      : out  std_logic;
            load_b      : out  std_logic;
            ram_write   : out  std_logic;
            sel_op      : out  std_logic_vector (2 downto 0);
            load_pc     : out  std_logic;
            load_status : out  std_logic
          );
end CU;

architecture Behavioral of CU is

begin

    -- Familia "operacion de la ALU": viaja directa (bits 2:0)
    sel_op    <= op_code(2 downto 0);

    -- Familia "cargas": un bit cada una (bits 3,4,5)
    load_a    <= op_code(3);
    load_b    <= op_code(4);
    ram_write <= op_code(5);

    -- Mux A: bits 6,7,8 -> selector de 2 bits
    sel_a <= "00" when op_code(6) = '1' else   -- Reg A
             "01" when op_code(7) = '1' else   -- Uno
             "10" when op_code(8) = '1' else   -- Cero
             "10";                             -- sin bit activo: arbitrario (Cero)

    -- Mux B: bits 9,10,11 -> selector de 2 bits
    sel_b <= "00" when op_code(9)  = '1' else  -- Reg B
             "01" when op_code(10) = '1' else  -- Literal
             "10" when op_code(11) = '1' else  -- RAM
             "00";                             -- sin bit activo: arbitrario (Reg B)

    -- Familia "saltos": bits 12..19 condicionados por las flags guardadas
    load_pc <= '1' when (op_code(12) = '1')                                -- JMP
                    or (op_code(13) = '1' and z_in = '1')                  -- JEQ
                    or (op_code(14) = '1' and z_in = '0')                  -- JNE
                    or (op_code(15) = '1' and n_in = '1')                  -- JLT
                    or (op_code(16) = '1' and (z_in = '1' or n_in = '1'))  -- JLE
                    or (op_code(17) = '1' and z_in = '0' and n_in = '0')   -- JGT
                    or (op_code(18) = '1' and n_in = '0')                  -- JGE
               else '0';

    -- El Status se carga en las instrucciones que NO son salto
    load_status <= '1' when op_code(19 downto 12) = "00000000" else '0';

end Behavioral;
