library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- ALU de 8 bits.
--   a, b : operandos
--   sop : selector de operacion (3 bits, 8 operaciones)
--   c     : flag de carry
--   z     : flag de zero
--   n     : flag de negative
entity ALU is
    Port (
         a      : in std_logic_vector (7 downto 0);
         b      : in std_logic_vector (7 downto 0);
         sop    : in std_logic_vector (2 downto 0);
         c      : out std_logic;
         z      : out std_logic;
         n      : out std_logic;
         result : out std_logic_vector (7 downto 0)
    );
end ALU;

architecture Behavioral of ALU is

    component Adder8
        Port (
            a  : in  std_logic_vector (7 downto 0);
            b  : in  std_logic_vector (7 downto 0);
            ci : in  std_logic;
            s  : out std_logic_vector (7 downto 0);
            co : out std_logic
        );
    end component;

    signal suma       : std_logic_vector (7 downto 0);
    signal cout_adder : std_logic;
    signal b_adder    : std_logic_vector (7 downto 0);
    signal ci_adder   : std_logic;
    signal op_and     : std_logic_vector (7 downto 0);
    signal op_or      : std_logic_vector (7 downto 0);
    signal op_xor     : std_logic_vector (7 downto 0);
    signal op_not     : std_logic_vector (7 downto 0);
    signal op_shl     : std_logic_vector (7 downto 0);
    signal op_shr     : std_logic_vector (7 downto 0);
    signal result_i   : std_logic_vector (7 downto 0);

begin

    -- Sumador unico: suma y resta comparten el Adder8, solo cambian sus entradas.
    with sop select
        b_adder <= b      when "000",
                   not b  when "001",
                   b      when others;

    with sop select
        ci_adder <= '0'   when "000",
                    '1'   when "001",
                    '0'   when others;

    inst_Adder8: Adder8 port map(
        a  => a,
        b  => b_adder,
        ci => ci_adder,
        s  => suma,
        co => cout_adder
    );

    -- Operaciones logicas y desplazamientos (todas en paralelo).
    op_and <= a and b;
    op_or  <= a or  b;
    op_xor <= a xor b;
    op_not <= not a;
    op_shl <= a(6 downto 0) & '0';
    op_shr <= '0' & a(7 downto 1);

    -- Seleccion del resultado segun sop.
    with sop select
        result_i <= suma    when "000",
                    suma    when "001",
                    op_and  when "010",
                    op_or   when "011",
                    op_xor  when "100",
                    op_not  when "101",
                    op_shl  when "110",
                    op_shr  when others;

    result <= result_i;

    -- Flags.
    with sop select
        c <= cout_adder when "000",
             cout_adder when "001",
             '0'        when "010",
             '0'        when "011",
             '0'        when "100",
             '0'        when "101",
             a(7)       when "110",
             a(0)       when others;

    z <= '1' when result_i = "00000000" else '0';

    n <= result_i(7);

end Behavioral;
