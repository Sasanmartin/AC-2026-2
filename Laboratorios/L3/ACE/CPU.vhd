-- ===========================================================================
-- IIC2343 - Actividad Formativa 3 - CPU (VERSION ACE / DocPrep, con saltos)
-- ===========================================================================
-- Esta es la version "con saltos" descrita en el DocPrep (ACE):
--   * la unidad de control traduce "un bit por entrada" a selectores de 2 bits,
--   * existe un registro Status (flags C, Z, N),
--   * el PC puede saltar (loadPC) ademas de avanzar.
--
-- OJO: esta version NO es la que usan los programas de prueba de la ACF.
-- El ensamblador de la actividad usa la codificacion de la Tabla 1 (sin saltos),
-- implementada en la version ACF (archivo del proyecto). Esta version es para
-- estudiarla / practicarla con el DocPrep.
--
-- Entidades usadas (Reg, ALU, CU): no se modifican salvo que la CU de esta
-- variante necesita puertos extra (c_in/z_in/n_in, load_pc, load_status),
-- por lo que aqui la declaracion del componente CU SI los incluye.
-- ===========================================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;


entity CPU is
    Port (
           clock : in STD_LOGIC;
           clear : in STD_LOGIC;
           ram_address : out STD_LOGIC_VECTOR (11 downto 0);
           ram_datain : out STD_LOGIC_VECTOR (15 downto 0);
           ram_dataout : in STD_LOGIC_VECTOR (15 downto 0);
           ram_write : out STD_LOGIC;
           rom_address : out STD_LOGIC_VECTOR (11 downto 0);
           rom_dataout : in STD_LOGIC_VECTOR (35 downto 0);
           dis : out STD_LOGIC_VECTOR (15 downto 0));
end CPU;

architecture Behavioral of CPU is

component Reg -- No Tocar
    Port (
        clock       : in    std_logic;
        clear       : in    std_logic;
        load        : in    std_logic;
        up          : in    std_logic;
        down        : in    std_logic;
        datain      : in    std_logic_vector (15 downto 0);
        dataout     : out   std_logic_vector (15 downto 0)
          );
    end component;

component ALU -- No Tocar
    Port (
        a           : in    std_logic_vector (15 downto 0);
        b           : in    std_logic_vector (15 downto 0);
        sop         : in    std_logic_vector (2 downto 0);
        c           : out   std_logic;
        z           : out   std_logic;
        n           : out   std_logic;
        result      : out   std_logic_vector (15 downto 0)
          );
    end component;

component CU -- (esta variante SI necesita los puertos extra)
    Port (
        op_code     : in   std_logic_vector (19 downto 0);
        c_in        : in   std_logic;
        z_in        : in   std_logic;
        n_in        : in   std_logic;
        sel_a       : out  std_logic_vector (1 downto 0);
        sel_b       : out  std_logic_vector (1 downto 0);
        load_a      : out  std_logic;
        load_b      : out  std_logic;
        ram_write   : out  std_logic;
        sel_op      : out  std_logic_vector (2 downto 0);
        load_pc     : out  std_logic;
        load_status : out  std_logic
          );
    end component;

signal pc_out       : std_logic_vector(15 downto 0);
signal reg_a_out    : std_logic_vector(15 downto 0);
signal reg_b_out    : std_logic_vector(15 downto 0);
signal status_out   : std_logic_vector(15 downto 0);
signal status_in    : std_logic_vector(15 downto 0);

signal alu_result   : std_logic_vector(15 downto 0);
signal mux_a_out    : std_logic_vector(15 downto 0);
signal mux_b_out    : std_logic_vector(15 downto 0);

signal lit_field    : std_logic_vector(15 downto 0);
signal dir          : std_logic_vector(11 downto 0);
signal jump_target  : std_logic_vector(15 downto 0);

signal sel_a        : std_logic_vector(1 downto 0);
signal sel_b        : std_logic_vector(1 downto 0);
signal sel_op       : std_logic_vector(2 downto 0);
signal load_a       : std_logic;
signal load_b       : std_logic;
signal w_ram        : std_logic;
signal load_pc      : std_logic;
signal load_status  : std_logic;

signal c_flag       : std_logic;
signal z_flag       : std_logic;
signal n_flag       : std_logic;

begin

    lit_field   <= rom_dataout(35 downto 20);   -- campo literal
    dir         <= rom_dataout(31 downto 20);   -- direccion (12 bits)
    jump_target <= "0000" & dir;                -- destino de salto

    -- Program Counter: salta (load) o avanza (up)
    inst_PC: Reg port map(
        clock   => clock,
        clear   => clear,
        load    => load_pc,
        up      => not load_pc,
        down    => '0',
        datain  => jump_target,
        dataout => pc_out
        );

    -- Registro A
    inst_A: Reg port map(
        clock   => clock,
        clear   => clear,
        load    => load_a,
        up      => '0',
        down    => '0',
        datain  => alu_result,
        dataout => reg_a_out
        );

    -- Registro B
    inst_B: Reg port map(
        clock   => clock,
        clear   => clear,
        load    => load_b,
        up      => '0',
        down    => '0',
        datain  => alu_result,
        dataout => reg_b_out
        );

    -- Registro Status: bit0 = C, bit1 = Z, bit2 = N
    status_in <= "0000000000000" & n_flag & z_flag & c_flag;
    inst_Status: Reg port map(
        clock   => clock,
        clear   => clear,
        load    => load_status,
        up      => '0',
        down    => '0',
        datain  => status_in,
        dataout => status_out
        );

    -- Mux A: 00 Reg A | 01 Uno | 10 Cero
    with sel_a select
        mux_a_out <= reg_a_out          when "00",
                     "0000000000000001" when "01",
                     "0000000000000000" when "10",
                     "0000000000000000" when others;

    -- Mux B: 00 Reg B | 01 Literal | 10 RAM | 11 Cero
    with sel_b select
        mux_b_out <= reg_b_out   when "00",
                     lit_field   when "01",
                     ram_dataout when "10",
                     "0000000000000000" when others;

    -- ALU
    inst_ALU: ALU port map(
        a      => mux_a_out,
        b      => mux_b_out,
        sop    => sel_op,
        c      => c_flag,
        z      => z_flag,
        n      => n_flag,
        result => alu_result
        );

    -- Unidad de Control (variante ACE)
    inst_CU: CU port map(
        op_code     => rom_dataout(19 downto 0),
        c_in        => status_out(0),
        z_in        => status_out(1),
        n_in        => status_out(2),
        sel_a       => sel_a,
        sel_b       => sel_b,
        load_a      => load_a,
        load_b      => load_b,
        ram_write   => w_ram,
        sel_op      => sel_op,
        load_pc     => load_pc,
        load_status => load_status
        );

    rom_address      <= pc_out(11 downto 0);
    ram_address      <= dir;
    ram_datain       <= alu_result;
    ram_write        <= w_ram;
    dis(15 downto 8) <= reg_a_out(7 downto 0);
    dis(7 downto 0)  <= reg_b_out(7 downto 0);

end Behavioral;
