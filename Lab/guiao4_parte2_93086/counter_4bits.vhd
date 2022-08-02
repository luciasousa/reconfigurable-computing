----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.04.2022 19:14:38
-- Design Name: 
-- Module Name: counter_4bits - Behavioral
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

entity counter_4bits is
generic(MAX_VAL : natural);
	port(reset      : in  std_logic;
		 clk        : in  std_logic;
		 clkEnable  : in  std_logic;
		 cntEnable  : in  std_logic;
		 increment  : in  std_logic;
		 decrement  : in  std_logic;
		 valOut     : out std_logic_vector(3 downto 0);
		 termCnt    : out std_logic); 
end counter_4bits;

architecture Behavioral of counter_4bits is
    subtype TCount is natural range 0 to MAX_VAL;
	signal s_value : TCount := MAX_VAL;
begin
    
	process(clk)
	begin	
		if (rising_edge(clk)) then
            if (cntEnable = '0' and clkEnable = '1') then	
					-- decrement
					if (decrement = '1') then
						
						if (s_value = 0) then
							s_value <= MAX_VAL;
						else
							s_value <= s_value - 1;
						end if;

					
					-- increment
					elsif (increment = '1') then
						--  wrap value
						if (s_value = MAX_VAL) then
							s_value <= 0;
						else
							s_value <= s_value + 1;
						end if;
                    end if;
                    
            -- Counting
            elsif (clkEnable = '1' and cntEnable = '1') then
               
                if (s_value = 0) then
                    s_value <= MAX_VAL;
                else
                    s_value <= s_value - 1;
                end if;
            end if;
        end if;
	end process;

	valOut  <= std_logic_vector(to_unsigned(s_value, 4));

	termCnt <= '1' when (s_value = 0) else '0';

end Behavioral;

