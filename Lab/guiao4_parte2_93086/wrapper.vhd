----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.04.2022 19:34:01
-- Design Name: 
-- Module Name: wrapper - Behavioral
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

entity wrapper is
port(    clk         : in  std_logic;
         btnCpuReset : in  std_logic;
         btnC        : in  std_logic;
         btnU        : in  std_logic;
         btnR        : in  std_logic;
         btnD        : in  std_logic;
         an          : out std_logic_vector(7 downto 0);
         seg         : out std_logic_vector(6 downto 0);
         dp          : out std_logic;
         led         : out std_logic_vector(0 downto 0));
end wrapper;

architecture Behavioral of wrapper is
    signal s_reset                      : std_logic;
    
    signal s_pulse1HZ,s_pulse2HZ, s_pulse800HZ,s_pulse4Hz       : std_logic;
    signal s_blink_dot, s_blink1Hz,s_p1hz       : std_logic;
    
    signal s_btnStart, s_btnAdjust      : std_logic;
    signal s_btnUp, s_btnDown           : std_logic;
    signal s_btnR, s_btnC               : std_logic;
    
    signal s_zero, s_run                : std_logic;
    signal s_setDisplay                 : std_logic_vector(3 downto 0);
       
    signal s_usInc, s_usDec : std_logic;
    signal s_dsInc, s_dsDec : std_logic;
    
    signal s_umInc, s_umDec : std_logic;
    signal s_dmInc, s_dmDec : std_logic;
    
    signal s_us, s_ds : std_logic_vector(3 downto 0);
    signal s_um, s_dm : std_logic_vector(3 downto 0);
    
    signal s_displayEn, s_pointEn       : std_logic_vector(7 downto 0);
    signal s_dot, s_display : std_logic;
    
    signal s_setup : std_logic_vector(3 downto 0);
  
       
begin

 process(clk)
    begin
        if (rising_edge(clk)) then
            --sync btn
            s_btnUp <= btnU;
            s_btnDown <= btnD;
        end if;
    end process;
    
    -- debouncer só para o BtnR e BtnC
    
    but_R_debouncer   : entity work.DebounceUnit(Behavioral) --btnR responsable for getting into the adjust mode
                        generic map(kHzClkFreq      => 100000,
                                    mSecMinInWidth  => 100,
                                    inPolarity      => '1',
                                    outPolarity     => '1')
                        port map(refClk     => clk,
                                 dirtyIn    => btnR,
                                 pulsedOut  => s_btnAdjust);
                                 
    but_C_debouncer : entity work.DebounceUnit(Behavioral) --btnC start and stop the count
                        generic map(kHzClkFreq      => 100000,
                                    mSecMinInWidth  => 100,
                                    inPolarity      => '1',
                                    outPolarity     => '1')
                        port map(refClk     => clk,
                                 dirtyIn    => btnC,
                                 pulsedOut  => s_btnStart);
    
   
   pulse_generator : entity work.pulse_gen_1Hz(Behavioral)
            port map(clk => clk,
                     reset => s_reset,
                     pulse => s_pulse1HZ);
                     
    pulse_generator_point : entity work.pulse_gen_2Hz(Behavioral)
            port map(clk => clk,
                     reset => s_reset,
                     pulse => s_pulse2HZ);
    
    pulse_gen_blink_displays : entity work.pulse_gen_4Hz(Behavioral)
            port map(clk => clk,
                     reset => s_reset,
                     pulse => s_pulse4Hz);
                     
    pulse_gen_displays : entity work.pulse_gen_800Hz(Behavioral)
            port map(clk => clk,
                     reset => s_reset,
                     pulse => s_pulse800Hz);
   
    control : entity work.control_unit(Behavioral)
             
                    port map( reset      => s_reset,
                            clk        => clk,
                            btnUp      => btnU,
                            btnDown    => btnD,
                            btnStart   => s_btnStart,
                            btnAdjust  => s_btnAdjust,
                            upDownEn   => '1', 
                            zero       => s_zero, 
                            run        => s_run,
                            setDisplay => s_setDisplay,
                            usInc => s_usInc, 
                            usDec => s_usDec, 
                            dsInc => s_dsInc,
                            dsDec => s_dsDec,
                            umInc => s_umInc,
                            umDec => s_umDec,
                            dmInc => s_dmInc, 
                            dmDec => s_dmDec);                           

    datapath: entity work.time_counter(Behavioral) 
    
                    port map(reset          => s_reset,
                             clk            => clk,
                             clkEnable      => s_pulse1HZ,
                             run            => s_run,
                             setLsecInc     =>s_usInc,
                             setLsecDec     =>s_usDec,
                             setHsecInc     =>s_dsInc,
                             setHsecDec     =>s_dsDec,
                             setLminInc     =>s_umInc,
                             setLminDec     =>s_umDec,
                             setHminInc     =>s_dmInc,
                             setHminDec     =>s_dmDec,
                             minLCntVal     =>s_um,
                             minHCntVal     =>s_dm,
                             secLCntVal     =>s_us,
                             secHCntVal     =>s_ds,
                             zero           => s_zero);
              
    blink_point: process(s_pulse2Hz)
        begin
            if(rising_edge(s_pulse2Hz)) then
                s_dot <= not s_dot;
            end if;
        end process;
    
    s_pointEn <= "111" & s_dot & "1111";
    
    blink_displays: process(s_pulse4Hz)
    begin
        if(rising_edge(s_pulse4Hz)) then
            s_display <= not s_display;
        end if;
    end process;
    
    blink_display_2hz: process(s_setDisplay, s_display)
            begin
                case s_setDisplay is
                    when "1000" => s_displayEn <= "00" & s_display & "11100";
                    when "0100" => s_displayEn <= "001" & s_display & "1100";
                    when "0010" => s_displayEn <= "0011" & s_display & "100";
                    when "0001" => s_displayEn <= "00111" & s_display & "00";
                    when others => s_displayEn <= "00111100";
                end case;
            end process;
    
    --s_displayEn <= "00" & not(s_setDisplay(3) and s_pulse2Hz) & not(s_setDisplay(2) and s_pulse2Hz) & not(s_setDisplay(1) and s_pulse2Hz) & not(s_setDisplay(0) and s_pulse2Hz) & "00";
    
    driver: entity work.Nexys4DispDriver(Behavioral)
        port map ( clk   => clk,
                   clk_enable => s_pulse800HZ,
                   digit_enable => s_displayEn,
                   dot_enable => s_pointEn,
                   d0 => "1111",
                   d1 => "1111",
                   d2 => s_us,
                   d3 => s_ds,
                   d4 => s_um,
                   d5 => s_dm,
                   d6 => "1111",
                   d7 => "1111",
                   an  => an,
                   seg => seg,
                   dp  => dp);
                                   
    led(0) <=  s_zero;
    
end Behavioral;
