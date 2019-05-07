----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/17/2019 01:10:11 PM
-- Design Name: 
-- Module Name: xnor_sum - Behavioral
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

entity xnor_sum is
    Generic ( bit_width : integer := 32
    );
    Port ( input : in STD_LOGIC_VECTOR(bit_width-1 DOWNTO 0);
           weight : in STD_LOGIC_VECTOR(bit_width-1 DOWNTO 0);
           bits : in STD_LOGIC_VECTOR(bit_width-1 DOWNTO 0);
           output : out integer
    );
end xnor_sum;

architecture Behavioral of xnor_sum is

signal xnor_output : STD_LOGIC_VECTOR(bit_width-1 DOWNTO 0) := (OTHERS => '0');

begin
xnor_output <= input xnor weight;

process(xnor_output, bits)
variable count : integer := 0;
begin
    count := 0;
    for i in 0 to bit_width-1 loop
        if (bits(i) = '1' and xnor_output(i) = '1') then
            count := count + 1;
        end if;
        if (bits(i) = '1' and xnor_output(i) = '0') then
            count := count - 1;
        end if;
    end loop;
    output <= count;
end process;

end Behavioral;
