----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.04.2019 13:03:19
-- Design Name: 
-- Module Name: binarised_buffer - Behavioral
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
use work.data_types.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity binarised_buffer is
    Port ( clk : in STD_LOGIC;
       addr : in std_logic_vector(buffer_addr_size-1 downto 0);
       sign : in std_logic_vector(num_units-1 downto 0);
       dataout : out STD_LOGIC_vector(buffer_size-1 downto 0));
end binarised_buffer;

architecture Behavioral of binarised_buffer is

begin

    process(clk)
    begin
        if rising_edge(clk) then
            for i in 0 to num_units-1 loop
                dataout(to_integer(unsigned(addr))+i) <= not sign(i);
            end loop;
        end if; 
    end process;

end Behavioral;
