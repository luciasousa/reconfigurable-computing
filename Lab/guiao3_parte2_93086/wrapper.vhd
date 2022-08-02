----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.03.2022 15:37:51
-- Design Name: 
-- Module Name: wrapper - Behavioral
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

entity wrapper is
    Port ( clk : in STD_LOGIC;
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           btnC : in STD_LOGIC;
           an : out STD_LOGIC_VECTOR (7 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           dp : out STD_LOGIC);
end wrapper;

architecture Behavioral of wrapper is
   signal s_clk_en : std_logic;
   signal s_reset : std_logic;
   
begin
process(clk)
begin
    if rising_edge (clk) then
        s_reset <= btnC;
    end if;
end process;

pulsegenerator: entity work.pulseGenerator(Behavioral)
    generic map(N => 125000)
    port map(clk => clk,
             pulse => s_clk_en);         

driver: entity work.Nexys4DispDriver(Behavioral)
    port map ( clk   => clk,
               clk_enable => s_clk_en,
               digit_enable => sw(7 downto 0),
               dot_enable => sw(15 downto 8), 
               d0 => "0000",
               d1 => "0001",
               d2 => "0010",
               d3 => "0011",
               d4 => "0100",
               d5 => "0101",
               d6 => "0110",
               d7 => "0111",
               an  => an,
               seg => seg,
               dp  => dp);

end Behavioral;
