----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.03.2022 10:45:46
-- Design Name: 
-- Module Name: pulse_gen1Hz - Behavioral
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

entity pulse_gen1Hz is
  Port (clk: in std_logic;  -- 100MHz
        reset: in std_logic;
        pulse: out std_logic);
end pulse_gen1Hz;

-- 100MHz / 10^8
-- 10ns a 1
-- 1s a 0

--1s/10ns=10^8

architecture Behavioral of pulse_gen1Hz is
    constant MAX: natural := 100_000_000;
    signal s_cnt: natural range 0 to MAX-1;
begin
    process(clk)
    begin
        if(rising_edge(clk)) then
            pulse <= '0';
            if(reset='1') then
                s_cnt <= 0;
            else
                s_cnt <= s_cnt + 1;
                if(s_cnt = MAX-1) then
                    s_cnt <= 0;
                    pulse <= '1'; -- ativa 1 vez por segundo
                end if;
            end if;
        end if;
    end process;

end Behavioral;
