library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AdderSub8 is
    Port ( a        : in  std_logic_vector (7 downto 0);   -- Primer operando.
           b        : in  std_logic_vector (7 downto 0);   -- Segundo operando.
           sel      : in  std_logic;   
           c        : out std_logic;                       -- Señal de 'carry'.
           result   : out std_logic_vector (7 downto 0));  -- Resultado de la operación.
end AdderSub8;

architecture Behavioral of AdderSub8 is

signal sum_result   : std_logic_vector(7 downto 0);
signal adder_result   : std_logic_vector(7 downto 0);
signal cout_adder : std_logic;
signal b_signal   : std_logic_vector(7 downto 0);
signal cin_adder : std_logic;


component Adder8 is
    Port ( a  : in  std_logic_vector (7 downto 0);
           b  : in  std_logic_vector (7 downto 0);
           ci : in  std_logic;
           s  : out std_logic_vector (7 downto 0);
           co : out std_logic);
end component;

begin

-- Sumador/Restaror
                  
result  <= adder_result;

with sel select
    b_signal <= b when '0',
                not b when '1';

cin_adder <= sel;

inst_sum: Adder8 port map(
        a      => a,
        b      => b_signal,
        ci     => cin_adder,
        s      => adder_result,
        co     => cout_adder
);
             
    
end Behavioral;

