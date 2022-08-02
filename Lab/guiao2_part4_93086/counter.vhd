----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.03.2022 10:42:55
-- Design Name: 
-- Module Name: counter - Behavioral
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

entity counter is
  port(   clk       :      in std_logic;
          reset     :      in std_logic;
          enable    :      in std_logic;
          ajust     :      in std_logic;
          increment :      in std_logic;
          decrement :      in std_logic;
          sig_ajust:            out std_logic;
          valCount  :      out std_logic_vector(3 downto 0);
          valCountSeg :      out std_logic_vector(3 downto 0));
end counter;

architecture Behavioral of counter is
    signal s_count : unsigned(valCount'range);
    signal flag : std_logic:='0';
    signal s_countHex : unsigned(valCountSeg'range);

begin
    process(clk,reset,enable,ajust,increment,decrement)
    begin
    if(rising_edge(clk)) then
        if (reset = '1') then
            s_countHex <= (others => '0');
        elsif (enable = '1') then
            if ajust = '1' and flag = '0' then
                flag <= '1';
            end if;
            if ajust = '1' and flag = '1' then
                flag <= '0';
            end if;  
            if ajust = '0' and flag = '0' then
                s_countHex <= s_countHex + 1;
            end if;  
            if ajust = '0' and flag = '1' then
                s_countHex <= s_countHex;
                if (increment = '1') then
                    s_countHex <= s_countHex + 1;
                elsif (decrement = '1') then
                    s_countHex <= s_countHex - 1;
                end if;
            end if; 
		 end if;
	   end if;
	end process;
	sig_ajust <= flag;
	valCount <= std_logic_vector(s_countHex);
	valCountSeg <= std_logic_vector(s_countHex);

end Behavioral;
