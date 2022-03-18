----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/04/2022 04:08:35 PM
-- Design Name: 
-- Module Name: picoblaze_uart - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity picoblaze_uart is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
            TX : out STD_LOGIC;
            RX : in STD_LOGIC);
end picoblaze_uart;

architecture Behavioral of picoblaze_uart is
--declaración de componentes
component modulo_uart is
    Port ( 
                     CLK : in STD_LOGIC;
                     RST : in STD_LOGIC;
                     --pines de comunicación con PicoBlaze
                 PORT_ID : in STD_LOGIC_VECTOR (7 downto 0);
              INPUT_PORT : in STD_LOGIC_VECTOR (7 downto 0);
             OUTPUT_PORT : out STD_LOGIC_VECTOR (7 downto 0);
            WRITE_STROBE : in STD_LOGIC;
                      --pines de comunicación serial
                      TX : out STD_LOGIC;
                      RX : in STD_LOGIC
                      );
end component;

component registro_puerto_entrada is
	 generic(
				n : integer := 8			--ancho del registro
	 );
    Port ( 
			  CLK  : in  STD_LOGIC;
           RST  : in  STD_LOGIC;
           D    : in  STD_LOGIC_VECTOR(n-1 downto 0);
           Q    : out STD_LOGIC_VECTOR(n-1 downto 0));
end component;

component embedded_kcpsm6 is
  port (                   
                             in_port : in std_logic_vector(7 downto 0);
                            out_port : out std_logic_vector(7 downto 0);
                             port_id : out std_logic_vector(7 downto 0);
                        write_strobe : out std_logic;
                      k_write_strobe : out std_logic;
                         read_strobe : out std_logic;
                           interrupt : in std_logic;
                       interrupt_ack : out std_logic;
                           --    sleep : in std_logic;
                                 clk : in std_logic;
                                 rst : in std_logic);
end component;

--declaración de señales
signal in_port_s, out_port_s, port_id_s : std_logic_vector(7 downto 0);
--signal write_strobe_s, read_strobe_s : std_logic;
signal write_strobe_s : std_logic;
signal interrupt_s, interrupt_ack_s : std_logic;
signal registro_entrada : std_logic_vector(7 downto 0);

begin
        uart :  modulo_uart
                port map (
                             CLK => CLK,
                             RST => RST,
                         PORT_ID => port_id_s,
                      INPUT_PORT => out_port_s,
                     OUTPUT_PORT => registro_entrada,
                    WRITE_STROBE => write_strobe_s,
                              TX => TX,
                              RX => RX
                );
                
        reg_entrada : registro_puerto_entrada
                      port map (
                                CLK => CLK,
                                RST => RST,
                                D => registro_entrada,
                                Q => in_port_s                     
                                );
                
        uprocesador : embedded_kcpsm6
                      port map(
                                in_port => in_port_s,
                               out_port => out_port_s,
                                port_id => port_id_s,
                           write_strobe => write_strobe_s,
                         k_write_strobe => open,
                            read_strobe => open,
                              interrupt => interrupt_s,
                          interrupt_ack => interrupt_ack_s,
                                    clk => CLK,
                                    rst => RST
                      );


end Behavioral;