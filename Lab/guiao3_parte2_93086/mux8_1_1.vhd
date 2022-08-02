----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.03.2022 11:32:22
-- Design Name: 
-- Module Name: mux8_1 - Behavioral
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

entity mux8_1_1 is
  Port (sel: in std_logic_vector(2 downto 0);
        input0: in std_logic;
        input1: in std_logic;
        input2: in std_logic;
        input3: in std_logic;
        input4: in std_logic;
        input5: in std_logic;
        input6: in std_logic;
        input7: in std_logic;
        output: out std_logic);
end mux8_1_1;

architecture Behavioral of mux8_1_1 is
begin
    process(sel, input0, input1, input2,input3,input4,input5,input6,input7)
    begin
        case sel is
            when "000" => output <= input0;
            when "001" => output <= input1;
            when "010" => output <= input2;
            when "011" => output <= input3;
            when "100" => output <= input4;
            when "101" => output <= input5;
            when "110" => output <= input6;
            when "111" => output <= input7;
         end case;
     end process;
end Behavioral;
