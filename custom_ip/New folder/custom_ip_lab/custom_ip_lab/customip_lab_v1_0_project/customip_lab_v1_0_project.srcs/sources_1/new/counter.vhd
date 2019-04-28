----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/25/2019 11:27:58 AM
-- Design Name: 
-- Module Name: counter - Behavioral
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
use work.data_types.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter is
    Generic (count_limit : natural range 0 to 2000 := 1652);
    Port (  clk    : in STD_LOGIC;
            restart  : in STD_LOGIC;
            enable : in STD_LOGIC;
            input  : in natural range 0 to count_limit;
            output : out natural range 0 to count_limit;
            increment : in natural range 1 to weight_ram_size := 1);
end counter;

architecture Behavioral of counter is

begin

process(clk)
variable count : natural range 0 to count_limit := 0;
begin
    if rising_edge(clk) then
        if restart = '1' then
            count := input;
        elsif enable = '1' then
            count := count + increment;
        else
            count := count;
        end if;
    end if;
    
    output <= count;
end process;

end Behavioral;
