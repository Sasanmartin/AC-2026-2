library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity Reg is
    Port ( clock    : in  std_logic;                        -- Se�al del clock (reducido).
           load     : in  std_logic;                        -- Se�al de carga.
           datain   : in  std_logic_vector (7 downto 0);   -- Se�ales de entrada de datos.
           dataout  : out std_logic_vector (7 downto 0));  -- Se�ales de salida de datos.
end Reg;

architecture Behavioral of Reg is

component FFD
    Port (
        clk : in std_logic;
        d   : in std_logic;
        q   : in std_logic
    );
end component;



begin

inst_FFD0: FFD port map(clk => clock, d => datain(0), q => dataout(0));
inst_FFD1: FFD port map(clk => clock, d => datain(1), q => dataout(1));
inst_FFD2: FFD port map(clk => clock, d => datain(2), q => dataout(2));
inst_FFD3: FFD port map(clk => clock, d => datain(3), q => dataout(3));
inst_FFD4: FFD port map(clk => clock, d => datain(4), q => dataout(4));
inst_FFD5: FFD port map(clk => clock, d => datain(5), q => dataout(5));
inst_FFD6: FFD port map(clk => clock, d => datain(6), q => dataout(6));
inst_FFD7: FFD port map(clk => clock, d => datain(7), q => dataout(7));







            
end Behavioral;
