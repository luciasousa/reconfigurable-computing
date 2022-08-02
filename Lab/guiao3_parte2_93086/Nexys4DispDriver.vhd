----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.03.2022 10:16:02
-- Design Name: 
-- Module Name: Nexys4DispDriver - Behavioral
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
library UNISIM;
use UNISIM.VComponents.all;

entity Nexys4DispDriver is
  Port (clk : in std_logic;
        clk_enable: in std_logic;
        digit_enable : in std_logic_vector(7 downto 0);
        dot_enable : in std_logic_vector(7 downto 0);
        d0: in std_logic_vector(3 downto 0);
        d1: in std_logic_vector(3 downto 0);
        d2: in std_logic_vector(3 downto 0);
        d3: in std_logic_vector(3 downto 0);
        d4: in std_logic_vector(3 downto 0);
        d5: in std_logic_vector(3 downto 0);
        d6: in std_logic_vector(3 downto 0);
        d7: in std_logic_vector(3 downto 0);
        an: out std_logic_vector(7 downto 0);
        seg: out std_logic_vector(6 downto 0);
        dp: out std_logic);
end Nexys4DispDriver;

architecture Behavioral of Nexys4DispDriver is
    signal s_counter : std_logic_vector(2 downto 0) := "000";
    signal s_d: std_logic_vector(3 downto 0);
    signal s_digit_en: std_logic;
    signal s_seg : std_logic_vector(6 downto 0);

begin

counter: entity work.counter3bits(Behavioral)
    port map(clk => clk,
             reset=> '0',
             enable => clk_enable,
             valCount => s_counter);
             
dec38: entity work.dec3_8(Behavioral)
    port map(count => s_counter,
             output => an);
             
mux81d: entity work.mux8_1(Behavioral)
    generic map (N => 4)
    port map(   sel => s_counter,
                input0 => d0,
                input1 => d1,
                input2 => d2,
                input3 => d3,
                input4 => d4,
                input5 => d5,
                input6 => d6,
                input7 => d7,
                output => s_d);
                
mux81a: entity work.mux8_1_1(Behavioral)
    port map(   sel => s_counter,
                input0 => digit_enable(0),
                input1 => digit_enable(1),
                input2 => digit_enable(2),
                input3 => digit_enable(3),
                input4 => digit_enable(4),
                input5 => digit_enable(5),
                input6 => digit_enable(6),
                input7 => digit_enable(7),
                output => s_digit_en);   
    
mux81p: entity work.mux8_1_1(Behavioral)
    port map(   sel => s_counter,
                input0 => dot_enable(0),
                input1 => dot_enable(1),
                input2 => dot_enable(2),
                input3 => dot_enable(3),
                input4 => dot_enable(4),
                input5 => dot_enable(5),
                input6 => dot_enable(6),
                input7 => dot_enable(7),
                output => dp);  
                
h2s: entity work.hex2seg(Behavioral)
    port map ( hex => s_d,
               en_L => '1',
               seg_L => s_seg);
    

sgMux: process(s_seg, s_digit_en)
       begin
            if (s_digit_en = '1') then
                seg <= s_seg;
            else
                seg <= "1111111";
            end if;
       end process;
    
end Behavioral;
