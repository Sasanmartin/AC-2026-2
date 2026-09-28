entity ADDER4 is
    Port ( a  : in std_logic_vector (3 downto 0);
           b  : in std_logic_vector (3 downto 0);
           ci : in std_logic;
           s  : out std_logic_vector (3 downto 0);
           c  : out std_logic);
end ADDER4;

architecture Behavioral of ADDER4 is

    component FA
        Port (
            a  : in std_logic;
            b  : in std_logic;
            ci : in std_logic;
            s  : out std_logic;
            c  : out std_logic
        );
    end component;

    signal c_int : std_logic_vector (2 downto 0);

begin

    inst_FA0: FA port map(a => a(0), b => b(0), ci => ci, s => s(0), c => c_int(0));
    inst_FA1: FA port map(a => a(1), b => b(1), ci => c_int(0), s => s(1), c => c_int(1));
    inst_FA2: FA port map(a => a(2), b => b(2), ci => c_int(1), s => s(2), c => c_int(2));
    inst_FA3: FA port map(a => a(3), b => b(3), ci => c_int(2), s => s(3), c => c);

end Behavioral;