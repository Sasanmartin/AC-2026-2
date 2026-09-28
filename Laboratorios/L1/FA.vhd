entity FA is
    Port ( a  : in std_logic;
           b  : in std_logic;
           ci : in std_logic;
           s  : out std_logic;
           c  : out std_logic);
end FA;

architecture Behavioral of FA is

    component HA
        Port (
            a : in std_logic;
            b : in std_logic;
            s : out std_logic;
            c : out std_logic
        );
    end component;

    signal s_parcial  : std_logic;
    signal c_parcial1 : std_logic;
    signal c_parcial2 : std_logic;

begin

    inst_HA1: HA port map(a => a, b => b, s => s_parcial, c => c_parcial1);
    inst_HA2: HA port map(a => s_parcial, b => ci, s => s, c => c_parcial2);

    c <= c_parcial1 or c_parcial2;

end Behavioral;