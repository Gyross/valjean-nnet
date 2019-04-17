----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.03.2019 13:38:43
-- Design Name: 
-- Module Name: timer_sim - Behavioral
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

entity timer_sim is
end timer_sim;

architecture Behavioral of timer_sim is
    constant CLOCK_PERIOD       : Time := 10 ns;
    
    component timer is
        port (
                clk : in STD_LOGIC;
                enable : in STD_LOGIC;
                reset : in STD_LOGIC;
                count : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component timer;

begin

    timer_init: component timer
        port map (clk => clk, enable => enable, reset => reset, count => count);
    
    clock: process
    begin
        wait for CLOCK_PERIOD / 2;
        clk <= not clk;
    end process clock;
    
    TEST: process
        procedure next_clock(constant cycles: natural) is
        begin
            for i in 1 to cycles loop
                wait until clk = '0';
                wait until clk = '1';
            end loop;
        end procedure;
        
        procedure timer_init is
        begin
            reset <= '1';
            enable <= '0';
            next_clock(1);
            reset <= '0';
        end procedure;
    
    begin
        timer_init;
        REPORT "#### Timer test started ####";
        
        next_clock(4);
        ASSERT(count = X"00000000") REPORT "Timer counted while disabled";
        enable <= '1';
        next_clock(4);
        ASSERT(count /= X"00000000") REPORT "Timer did not count while enabled";
        
        REPORT "#### Test complete ####";
        wait;
    end process TEST;

end Behavioral;
