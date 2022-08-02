----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.04.2022 19:17:28
-- Design Name: 
-- Module Name: time_counter - Behavioral
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

entity time_counter is
 Port (      clk            : in  std_logic;
             clkEnable      : in  std_logic;
             reset          : in  std_logic;
             run            : in  std_logic;
             setLsecInc     : in std_logic;
             setLsecDec     : in std_logic;
             setHsecInc     : in std_logic;
             setHsecDec     : in std_logic;
             setLminInc     : in std_logic;
             setLminDec     : in std_logic;
             setHminInc     : in std_logic;
             setHminDec     : in std_logic;
             minLCntVal     : out std_logic_vector(3 downto 0);
             minHCntVal     : out std_logic_vector(3 downto 0);
             secLCntVal     : out std_logic_vector(3 downto 0);
             secHCntVal     : out std_logic_vector(3 downto 0);
             zero           : out std_logic -- quando chega a 00.00 
);
end time_counter;

architecture Behavioral of time_counter is
    signal s_SEC_L_FINISHED, s_SEC_H_FINISHED,  s_MIN_H_FINISHED, s_MIN_L_FINISHED : std_logic;
    signal s_SEC_H_cntEnable, s_MIN_L_cntEnable, s_MIN_H_cntEnable : std_logic; 
    
begin  
      
      s_SEC_H_cntEnable  <= run and s_SEC_L_FINISHED;--activate high seconds once low seconds finish
      s_MIN_L_cntEnable <= s_SEC_H_cntEnable and s_SEC_H_FINISHED;--activate low minutes once high seconds finish
      s_MIN_H_cntEnable <= s_MIN_L_cntEnable and s_MIN_L_FINISHED;--activate high minutes once low minutes finish
      
      -- Counters
      SEC_L_COUNTER : entity work.counter_4bits(Behavioral)
                        generic map(MAX_VAL => 9)
                        port map(reset      => reset,
                                 clk        => clk,
                                 clkEnable  => clkEnable,
                                 cntEnable  => run,
                                 increment  => setLsecInc,
                                 decrement  => setLsecDec,
                                 valOut     => secLCntVal,    
                                 termCnt    => s_SEC_L_FINISHED);
                                 
      SEC_H_COUNTER : entity work.counter_4bits(Behavioral)
                        generic map(MAX_VAL => 5)
                        port map(reset      => reset,
                                 clk        => clk,
                                 clkEnable  => clkEnable,
                                 cntEnable  => s_SEC_H_cntEnable,
                                 increment  => setHsecInc,
                                 decrement  => setHsecDec,
                                 valOut     => secHCntVal,    
                                 termCnt    => s_SEC_H_FINISHED);
      
      MIN_L_COUNTER : entity work.counter_4bits(Behavioral)
                        generic map(MAX_VAL => 9)
                        port map(reset      => reset,
                                 clk        => clk,
                                 clkEnable  => clkEnable,
                                 cntEnable  => s_MIN_L_cntEnable,
                                 increment  => setLMinInc,
                                 decrement  => setLMinDec,
                                 valOut     => minLCntVal,    
                                 termCnt    => s_MIN_L_FINISHED);
                                 
      MIN_H_COUNTER : entity work.counter_4bits(Behavioral)
                        generic map(MAX_VAL => 5)
                        port map(reset      => reset,
                                 clk        => clk,
                                 clkEnable  => clkEnable,
                                 cntEnable  => s_MIN_H_cntEnable,
                                 increment  => setHMinInc,
                                 decrement  => setHMinDec,
                                 valOut     => minHCntVal,    
                                 termCnt    => s_MIN_H_FINISHED);

     zero <= s_SEC_L_FINISHED AND s_SEC_H_FINISHED AND s_MIN_L_FINISHED AND s_MIN_H_FINISHED;
end Behavioral;