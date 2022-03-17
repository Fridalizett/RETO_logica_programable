
library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;

entity TOP_LEVEL_RETO is
  Port ( CLOCK: in std_logic;
        RESET : in std_logic;
        MISO : in STD_LOGIC;
        MOSI : out STD_LOGIC;
        SCLK : buffer STD_LOGIC;
        SS_N : buffer STD_LOGIC_VECTOR(0 DOWNTO 0);
        Tx : out STD_LOGIC;
        Rx : in STD_LOGIC);
end TOP_LEVEL_RETO;

architecture Behavioral of TOP_LEVEL_RETO is

 --signal tmp: std_logic:='0';
  SIGNAL sel : STD_LOGIC_VECTOR(7 downto 0);
  SIGNAL puerto : STD_LOGIC_VECTOR(7 downto 0);
  SIGNAL registro : STD_LOGIC_VECTOR (7 downto 0); 
  SIGNAL write : STD_LOGIC; 
  SIGNAL port_q : STD_LOGIC_VECTOR(7 downto 0);
  SIGNAL port_d : STD_LOGIC_VECTOR(7 downto 0);
  SIGNAL mux : STD_LOGIC_VECTOR(7 downto 0);

begin

port_d <= registro when (puerto(6) = '1') else
              mux when (puerto(4) = '1') else
              (others => '0');

PICOBLAZE : entity work.embedded_kcpsm6 port map(

                                                    in_port => port_q, 
                                                    out_port => sel, 
                                                    port_id => puerto,
                                                    write_strobe => write, 
                                                    clk => clock,
                                                    rst => reset 
                );
SPI : entity work.modulo_spi port map(
                                                    CLK => clock,
                                                    RST => reset, 
                                                    PORT_ID => puerto, 
                                                    OUTPUT_PORT => registro, 
                                                    MISO => miso,
                                                    SCLK => SCLK,
                                                    SS_N => SS_N, 
                                                    MOSI => mosi 
                
    );

UART : entity work.modulo_uart port map(
                                                    CLK => clock,
                                                    RST => reset, 
                                                    PORT_ID => puerto,
                                                    INPUT_PORT => sel,
                                                    OUTPUT_PORT => mux, 
                                                    WRITE_STROBE => write,
                                                    Tx => Tx,
                                                    Rx => Rx
                                                    );

REGIS : entity work.registro_puerto_entrada port map(

                                                    CLK => clock,
                                                    RST => reset, 
                                                    D => port_d, 
                                                    Q => port_q 
    
    );


end Behavioral;
