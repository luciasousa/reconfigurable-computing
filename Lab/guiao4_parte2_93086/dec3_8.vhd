----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.03.2022 23:09:41
-- Design Name: 
-- Module Name: dec3_8 - Behavioral
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

entity dec3_8 is
  Port (count : in std_logic_vector(2 downto 0);
        output : out std_logic_vector(7 downto 0));
end dec3_8;

architecture Behavioral of dec3_8 is

begin

process(count)
    begin
        case count is
            when "000" => output <= "11111110";
            when "001" => output <= "11111101";
            when "010" => output <= "11111011";
            when "011" => output <= "11110111";
            when "100" => output <= "11101111";
            when "101" => output <= "11011111";
            when "110" => output <= "10111111";
            when "111" => output <= "01111111";
        end case;
    end process;    

end Behavioral;
