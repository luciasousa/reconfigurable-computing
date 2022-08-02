----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.03.2022 10:40:54
-- Design Name: 
-- Module Name: counter_1Hz - Behavioral
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

entity counter_1Hz is
  Port (clk: in std_logic; 
        btnC : in std_logic;
        btnU : in std_logic;
        btnD : in std_logic;
        btnR : in std_logic;
        seg: out std_logic_vector(6 downto 0);
        led: out std_logic_vector(3 downto 0);
        an:  out std_logic_vector(7 downto 0));
end counter_1Hz;

architecture Behavioral of counter_1Hz is

Signal s_en, s_reset, s_ajust: std_logic;
signal s_enable : std_logic := '0';
signal s_segOut : std_logic;
signal s_an : STD_LOGIC_VECTOR(7 downto 0);
signal s_OutU, s_OutD, s_OutR, s_btnU, s_btnD, s_btnR : std_logic;
signal  s_hex : std_logic_vector(3 downto 0);

begin

process(clk)
begin
    if (rising_edge(clk)) then
        s_reset <= btnC;
        s_btnU <= btnU;
        s_btnD <= btnD;
        s_btnR <= btnR;
    end if;
end process;

DebounceU: entity work.Debounce(Behavioral)
    port map ( refClk  => clk,
               dirtyIn => s_btnU,
               pulsedOut =>  s_OutU);     
               
DebounceD: entity work.Debounce(Behavioral)
    port map ( refClk  => clk,
               dirtyIn => s_btnD,
               pulsedOut => s_OutD);

DebounceR: entity work.Debounce(Behavioral)
    port map ( refClk  => clk,
               dirtyIn => s_btnR,
               pulsedOut => s_OutR);

pulse: entity work.pulse_gen1Hz(Behavioral)
    port map(   clk => clk, 
                reset => btnC, 
                pulse => s_en);
 
cont: entity work.counter(Behavioral)
    port map(  clk => clk,
               reset => s_reset,
               enable => s_en,
               valcount => led,
               valCountSeg => s_hex,
               sig_ajust => s_ajust,
               increment   => s_btnU,
               decrement  => s_btnD,
               ajust => s_btnR);
               
hex2seg:      entity work.hex2seg(Behavioral)
    port map ( hex => s_hex, 
               en_L => s_en,
               --an_L => an,
               seg_L => seg);
                
dispEnable: process(s_en)
begin
    if(rising_edge(s_en)) then
        if(s_ajust='1') then
            an(0) <= s_enable;
            s_enable <= not s_enable;
        else
            an <= x"FE";
        end if;
    end if;
end process;
         
end Behavioral;
