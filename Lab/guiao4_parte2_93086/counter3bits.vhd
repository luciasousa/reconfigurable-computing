----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.03.2022 11:27:41
-- Design Name: 
-- Module Name: counter3bits - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter3bits is
  port(   clk       :      in std_logic;
          reset     :      in std_logic;
          enable    :      in std_logic;
          valCount  :      out std_logic_vector(2 downto 0));
end counter3bits;

architecture Behavioral of counter3bits is
    signal s_count : unsigned(valCount'range);
    signal flag : std_logic:='0';

begin
    process(clk,reset,enable)
    begin
    if(rising_edge(clk)) then
        if (reset = '1' or s_count > "111") then
            s_count <= (others => '0');
        elsif (enable = '1') then
            s_count <= s_count + 1;
		 end if;
	   end if;
	end process;
	valCount <= std_logic_vector(s_count);

end Behavioral;

