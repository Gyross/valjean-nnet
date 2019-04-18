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

entity vecmult_sim is
end vecmult_sim;

architecture Behavioral of vecmult_sim is
    constant CLOCK_PERIOD       : Time := 10 ns;
    
    component vecmult is
        Generic ( bit_width : integer := 32 );
        Port ( input : in STD_LOGIC_VECTOR (bit_width-1 downto 0);
               weight : in STD_LOGIC_VECTOR (bit_width-1 downto 0);
               bits : in STD_LOGIC_VECTOR (bit_width-1 downto 0);
               bias : in integer;
               enable : in STD_LOGIC;
               reset : in STD_LOGIC;
               clk : in STD_LOGIC;
               output : out STD_LOGIC_VECTOR (31 downto 0);
               xnor_output_i : out integer;
               acc_output_i : out integer
        );
    end component vecmult;

    signal input : STD_LOGIC_VECTOR (31 downto 0);
    signal weight : STD_LOGIC_VECTOR (31 downto 0);
    signal bits : STD_LOGIC_VECTOR (31 downto 0);
    signal bias : integer;
    signal enable : STD_LOGIC;
    signal reset : STD_LOGIC;
    signal clk : STD_LOGIC := '0';
    signal output : STD_LOGIC_VECTOR (31 downto 0);
    signal xnor_out : integer;
    signal acc_out : integer;

begin

    vecmult_init : component vecmult
        port map (input => input, weight => weight, bits => bits, bias => bias, 
        clk => clk, enable => enable, reset => reset, output => output, xnor_output_i => xnor_out, acc_output_i => acc_out);
    
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
        
        procedure vecmult_init is
        begin
            reset <= '1';
            next_clock(1);
            
            reset <= '0';
            enable <= '0';
            bits <= X"ffffffff";
            input <= X"fffffffe";
            weight <= X"ffffffff";
            bias <= 1;
            
            enable <= '1';
            
            next_clock(2);
            reset <= '1';
            
            next_clock(2);
            reset <= '0';
            
            enable <= '0';
            
            next_clock(2);
            input <= X"ffffffee";
            weight <= X"ffffffff";
            
            enable <= '1';
            
        end procedure;
    
    begin
        vecmult_init;
        REPORT "#### Timer test started ####";
        
        -- next_clock(4);
        -- ASSERT(count = X"00000000") REPORT "Timer counted while disabled";
        -- enable <= '1';
        -- next_clock(4);
        -- ASSERT(count /= X"00000000") REPORT "Timer did not count while enabled";
        
        REPORT "#### Test complete ####";
        wait;
    end process TEST;

end Behavioral;
