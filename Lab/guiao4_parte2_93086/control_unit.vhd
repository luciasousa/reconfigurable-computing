----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.04.2022 19:29:04
-- Design Name: 
-- Module Name: control_unit - Behavioral
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
use IEEE.STD_LOGIC_1164.all;

entity control_unit is

    port (  reset      : in  std_logic;
            clk        : in  std_logic;
            btnUp      : in  std_logic;
            btnDown    : in  std_logic;
            btnStart   : in  std_logic;
            btnAdjust  : in  std_logic;
            upDownEn   : in  std_logic; -- control bit responsable for blinking
            zero       : in  std_logic;
            run        : out std_logic; -- '1' if running
            setDisplay : out std_logic_vector(3 downto 0);
            usInc : out std_logic;
            usDec : out std_logic;
            dsInc : out std_logic;
            dsDec : out std_logic;
            umInc : out std_logic;
            umDec : out std_logic;
            dmInc : out std_logic;
            dmDec : out std_logic
        );
end control_unit; 

architecture Behavioral of control_unit is

    type TState is (STOPPED, RUNNING , CHANGE_MIN_H, CHANGE_MIN_L, CHANGE_SEC_H, CHANGE_SEC_L );
    signal s_currentState, s_nextState : TState;
    signal s_setDisplay : std_logic_vector(3 downto 0);
    
begin
    
    sync_proc:  process(clk)
    begin
        if (rising_edge(clk)) then
                s_currentState <= s_nextState;
            end if;
    end process;
    
    
      comb_proc: process(s_currentState, btnAdjust, btnStart, zero)
       begin 
       s_nextState <= s_currentState;
       
        case (s_currentState) is 
        when STOPPED =>
            run        <= '0';
            s_setDisplay <= "0000"; 

            if (btnStart = '1' and zero = '0') then
                s_nextState <= RUNNING;
            elsif (btnAdjust = '1') then
                s_nextState <= CHANGE_MIN_H;
                s_SetDisplay <= "1000"; 

            end if;
        
        
        -- RUNNING
        when RUNNING =>
            run        <= '1';
            s_setDisplay <= "0000"; 
            
            if (btnStart = '1' or zero = '1') then
                s_nextState <= STOPPED;
            elsif (btnAdjust = '1') then
                s_nextState <= CHANGE_MIN_H;
                s_SetDisplay <= "1000";

            end if;
            
       
        when CHANGE_SEC_L =>
            run        <= '0';
            s_setDisplay <= "0001";      

            if (btnAdjust = '1') then
                s_nextState <= RUNNING;
                run         <= '1';
            end if;
         

         when CHANGE_SEC_H =>
            run        <= '0';
            s_setDisplay <= "0010";       
               
            if (btnAdjust = '1') then
                s_nextState <= CHANGE_SEC_L;
            end if;
          
      
          when CHANGE_MIN_L =>
            run        <= '0';
            s_setDisplay <= "0100";       
    
            if (btnAdjust = '1') then
                s_nextState <= CHANGE_SEC_H;
            end if;
          
        
          when CHANGE_MIN_H =>
            run        <= '0';
            s_setDisplay <= "1000"; 
            

            if (btnAdjust = '1') then
                s_nextState <= CHANGE_MIN_L;

            end if;
       
         when others =>
         
            s_setDisplay <= "0000"; 
            s_nextState <= STOPPED;
         end case;
                
    end process;

    
    setDisplay <= s_setDisplay;
    
  
    usInc <= s_setDisplay(0) and upDownEn  and btnUp ; --and with set display, blinking and if up or down
    usDec <= s_setDisplay(0) and upDownEn  and btnDown;

    dsInc <= s_setDisplay(1) and upDownEn  and btnUp ;
    dsDec <= s_setDisplay(1) and upDownEn  and btnDown;

    umInc <= s_setDisplay(2) and upDownEn  and btnUp ;
    umDec <= s_setDisplay(2) and upDownEn  and btnDown;

    dmInc <= s_setDisplay(3) and upDownEn  and btnUp ;
    dmDec <= s_setDisplay(3) and upDownEn  and btnDown; 

end Behavioral;