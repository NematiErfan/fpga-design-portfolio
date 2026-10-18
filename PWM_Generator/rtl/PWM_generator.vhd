----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/12/2026 12:49:50 PM
-- Design Name: 
-- Module Name: PWM_generator - Behavioral
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


entity PWM_generator is
  Port (
            reset       :in     std_logic       :='0';
            pwm_out     :out    std_logic;
            CLK         :in     std_logic);
end PWM_generator;

architecture Behavioral of PWM_generator is

    signal      counter        :unsigned(15 downto 0)    :=(others=>'0');
    constant    PWM_PERIOD     :integer                  :=50000;
    constant    DUTY_CYCLE     :integer                  :=25;
    constant    threshold      :integer                  :=(PWM_PERIOD * DUTY_CYCLE) / 100;
    signal      CLK_50MHz      :std_logic;

    component MMCM_50MHz
        port
         (
              clk_out1          : out    std_logic;
              clk_in1           : in     std_logic
         );
        end component;

begin



    CLK_instance : MMCM_50MHz
       port map (  
                   clk_out1 => CLK_50MHz,
                   clk_in1 => CLK
                 );
                 
     process(CLK_50MHz)
     begin
        
        if (rising_edge(CLK_50MHz)) then
        
            if (reset = '1') then
                counter <= (others=>'0');
                pwm_out <= '0';
                
            else
            
            -- PWM period counter
                if (counter < to_unsigned(PWM_PERIOD-1,16)) then
                    counter <= counter + 1; 
                else
                    counter <= (others=>'0');
                end if;
                
                -- PWM output
                if (counter < to_unsigned(threshold,16)) then
                    pwm_out <= '1';
                else
                    pwm_out <= '0';
                end if;
                
             end if;
            
        end if;
        
     end process;

end Behavioral;
