----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.03.2019 12:11:51
-- Design Name: 
-- Module Name: timer - Behavioral
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
use IEEE.NUMERI.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity timer is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable : in STD_LOGIC;
           count : out STD_LOGIC_VECTOR (31 downto 0));
end timer;

architecture Behavioral of timer is

signal temp : unsigned := (others => '0');

begin

    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '0' then
                temp <= (others => '0');
            elsif enable = '1' then
                temp <= temp + 1;
            end if;
        end if;
    end process;
    
    count <= temp;

end Behavioral;
