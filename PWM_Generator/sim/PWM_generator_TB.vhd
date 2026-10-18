----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/12/2026 02:27:20 PM
-- Design Name: 
-- Module Name: PWM_generator_TB - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PWM_generator_TB is
end PWM_generator_TB;

architecture Behavioral of PWM_generator_TB is

    signal   CLK        :std_logic  :='0';
    signal   reset      :std_logic  :='0';
    signal   pwm_out    :std_logic;
    constant CLK_period :time       :=10 ns;
    constant PWM_period :time       :=1 ms;
    constant DUTY_cycle :integer    :=25;
    constant HIGH_time  :time       := PWM_period * Duty_cycle / 100;

begin

    CLK_process: process
    begin
        CLK <= '0';
        wait for CLK_period / 2;
        CLK <= '1';
        wait for CLK_period / 2;  
    end process CLK_process;
    
    reset_process: process
    begin
        reset <= '1';
        wait for 500 ns;
        reset <= '0';
    
        wait;
    end process reset_process;
    
    PWM_check_process: process
        variable t_start    :time;
    begin
        wait until (rising_edge(pwm_out));
        t_start := now;
        wait until (falling_edge(pwm_out));
        assert (now - t_start = HIGH_time)
            report "PWM High Time  is incorrect!"
            severity error;  
        wait; 
    end process PWM_check_process;
    
    PWM_period_check: process
        variable t_start    : time;
    begin
        wait until (rising_edge(pwm_out));  --start time of a period
        t_start := now;
        wait until (rising_edge(pwm_out));  --wait for the nesxt rising edge
        assert (now - t_start = PWM_period)
            report "PWM period is incorrect!"
            severity  error;
        wait;    
    end process PWM_period_check;
    
    reset_check_process: process
    begin
        wait until (reset = '1');
        wait until (rising_edge(CLK));
        wait for 0 ns;
        assert (pwm_out = '0')
            report "PWM output is not LOW during  reset!"
            severity error;
        wait;
    end process reset_check_process;

    PWM_generator_inst: entity work.PWM_generator
       port map (
          -- Input Ports - Single Bit
          CLK     => CLK,   
          reset   => reset, 
          -- Input Ports - Busses
          -- Output Ports - Single Bit
          pwm_out => pwm_out
          -- Output Ports - Busses
          -- InOut Ports - Single Bit
          -- InOut Ports - Busses
       );


end Behavioral;
