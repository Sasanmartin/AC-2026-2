library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Basys3 is
    Port (
        sw          : in   std_logic_vector (15 downto 0); -- No Tocar - Se�ales de entrada de los interruptores -- Arriba   = '1'   -- Los 16 swiches.
        btn         : in   std_logic_vector (4 downto 0);  -- No Tocar - Se�ales de entrada de los botones       -- Apretado = '1'   -- 0 central, 1 arriba, 2 izquierda, 3 derecha y 4 abajo.
        led         : out  std_logic_vector (15 downto 0); -- No Tocar - Se�ales de salida  a  los leds          -- Prendido = '1'   -- Los 16 leds.
        clk         : in   std_logic;                      -- No Tocar - Se�al de entrada del clock              -- Frecuencia = 100Mhz.
        seg         : out  std_logic_vector (7 downto 0);  -- No Tocar - Salida de las se�ales de segmentos.
        an          : out  std_logic_vector (3 downto 0)   -- No Tocar - Salida del selector de diplay.
          );
end Basys3;

architecture Behavioral of Basys3 is

-- Inicio de la declaraci�n de los componentes.
    
component Debouncer -- No Tocar
    Port (
        clk         : in    std_logic;
        signal_in   : in    std_logic;
        signal_out  : out   std_logic
          );
    end component;
    
component Display_Controller -- No Tocar
    Port (  
        dis_a       : in    std_logic_vector (3 downto 0);
        dis_b       : in    std_logic_vector (3 downto 0);
        dis_c       : in    std_logic_vector (3 downto 0);
        dis_d       : in    std_logic_vector (3 downto 0);
        clk         : in    std_logic;
        seg         : out   std_logic_vector (7 downto 0);
        an          : out   std_logic_vector (3 downto 0)
          );
    end component;
    
component Reg -- No Tocar
    Port (
        clock       : in    std_logic;
        load        : in    std_logic;
        datain      : in    std_logic_vector (7 downto 0);
        dataout     : out   std_logic_vector (7 downto 0)
          );
    end component;

component AdderSub8 -- No Tocar
    Port ( 
        a           : in    std_logic_vector (7 downto 0);
        b           : in    std_logic_vector (7 downto 0);
        sel         : in    std_logic;
        c           : out   std_logic;
        result      : out   std_logic_vector (7 downto 0)
          );
    end component;

-- Fin de la declaraci�n de los componentes.

-- Inicio de la declaraci�n de se�ales.

signal d_btn            : std_logic_vector(4 downto 0);  -- Se�ales de botones con anti-rebote.
            
signal dis_a            : std_logic_vector(3 downto 0);  -- Se�ales de salida al display A.    
signal dis_b            : std_logic_vector(3 downto 0);  -- Se�ales de salida al display B.     
signal dis_c            : std_logic_vector(3 downto 0);  -- Se�ales de salida al display C.    
signal dis_d            : std_logic_vector(3 downto 0);  -- Se�ales de salida al display D.
     
signal a                : std_logic_vector(7 downto 0);  -- Se�ales del primer operador.    
signal b                : std_logic_vector(7 downto 0);  -- Se�ales del segundo operador.  

signal result           : std_logic_vector(7 downto 0);  -- Se�ales del resultado.

signal datain           : std_logic_vector(7 downto 0);  -- Se�ales de datos de entrada a los registros.


-- Fin de la declaraci�n de se�ales.

begin

-- Inicio de declaraci�n de comportamientos.

-- Muxer Regs
with sw(12) select
    datain <= result            when '0',
              sw(7 downto 0)    when others;

-- Muxers del Display
with btn(0) select
    dis_a <= a(7 downto 4)      when '0',
             "0000"             when others;
                     
with btn(0) select
    dis_b <= a(3 downto 0)      when '0',
             "0000"             when others;

with btn(0) select
    dis_c <= b(7 downto 4)      when '0',
             result(7 downto 4) when others;
                
with btn(0) select
    dis_d <= b(3 downto 0)      when '0',
             result(3 downto 0) when others;


-- Inicio de declaraci�n de instancias.

inst_REG_A: Reg port map( -- Rep�rame!
    clock       => d_btn(2),
    load        => '1',
    datain      => datain,
    dataout     => a
    );
    
inst_REG_B: Reg port map( -- Rep�rame!
    clock       => d_btn(3),
    load        => '1',
    datain      => datain,
    dataout     => b
    );
 
 inst_Add: AdderSub8 port map(
    a           => a,
    b           => b,
    sel         => sw(15),
    c           => led(15),
    result      => result
    );

-- Intancia de Display_Controller.        
inst_Display_Controller: Display_Controller port map(
    dis_a => dis_a, 
    dis_b => dis_b, 
    dis_c => dis_c, 
    dis_d => dis_d,     
    clk => clk ,        -- No Tocar - Entrada del clock completo (100Mhz).
    seg => seg,         -- No Tocar - Salida de las se�ales de segmentos. 
    an => an            -- No Tocar - Salida del selector de diplay.
    );

-- No Tocar - Intancias de Debouncers.    
inst_Debouncer0: Debouncer port map( clk => clk, signal_in => btn(0), signal_out => d_btn(0) );
inst_Debouncer1: Debouncer port map( clk => clk, signal_in => btn(1), signal_out => d_btn(1) );
inst_Debouncer2: Debouncer port map( clk => clk, signal_in => btn(2), signal_out => d_btn(2) );
inst_Debouncer3: Debouncer port map( clk => clk, signal_in => btn(3), signal_out => d_btn(3) );
inst_Debouncer4: Debouncer port map( clk => clk, signal_in => btn(4), signal_out => d_btn(4) );
    
-- Fin de declaraci�n de instancias.

-- Fin de declaraci�n de comportamientos.
  
end Behavioral;