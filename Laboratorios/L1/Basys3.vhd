library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Basys3 is
    Port (
        sw  : in std_logic_vector (15 downto 0);
        led : out std_logic_vector (15 downto 0)
    );
end Basys3;

architecture Behavioral of Basys3 is

    component ADDER4
        Port (
            a  : in std_logic_vector (3 downto 0);
            b  : in std_logic_vector (3 downto 0);
            ci : in std_logic;
            s  : out std_logic_vector (3 downto 0);
            c  : out std_logic
        );
    end component;

    signal a_i   : std_logic_vector (3 downto 0);
    signal b_i   : std_logic_vector (3 downto 0);
    signal cin_i : std_logic;
    signal s_i   : std_logic_vector (3 downto 0);
    signal cout_i: std_logic;

begin

    a_i   <= sw(3 downto 0);
    b_i   <= sw(7 downto 4);
    cin_i <= sw(8);

    inst_ADDER4: ADDER4 port map(
        a  => a_i,
        b  => b_i,
        ci => cin_i,
        s  => s_i,
        c  => cout_i
    );

    led(3 downto 0) <= s_i;
    led(4) <= cout_i;
    led(15 downto 5) <= (others => '0');

end Behavioral;