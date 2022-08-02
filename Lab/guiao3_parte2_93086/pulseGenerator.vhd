----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.03.2022 15:35:16
-- Design Name: 
-- Module Name: pulseGenerator - Behavioral
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

entity pulseGenerator is
    generic( N  :   natural);
    Port (clk     :   in std_logic;
          pulse   :   out std_logic);
end pulseGenerator;

architecture Behavioral of pulseGenerator is
    signal s_counter    :   natural := 0;
begin

    process(clk)
    begin
        if(rising_edge(clk)) then
            if (s_counter = N-1) then
                s_counter <= 0;
                pulse <= '1';
            else
                s_counter <= s_counter + 1;
                pulse <= '0';
            end if;
        end if;
    
    end process;

end Behavioral;