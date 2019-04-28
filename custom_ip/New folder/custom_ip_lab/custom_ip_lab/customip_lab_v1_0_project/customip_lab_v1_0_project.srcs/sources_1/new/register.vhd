----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/28/2019 05:22:49 PM
-- Design Name: 
-- Module Name: register - Behavioral
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
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity out_registers is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC := '0';
           load : in STD_LOGIC := '0';
           addr : in STD_LOGIC_VECTOR(output_addr_size-1 downto 0);
           di : in output_array;
           do : out STD_LOGIC_VECTOR (output_width-1 downto 0));
end out_registers;

architecture Behavioral of out_registers is

    signal registers_out : out_regs;

begin

    REG_FILE: for i in 0 to output_ram_size-1 generate
        REGX: process (clk)
        variable Q : std_logic_vector(output_width-1 downto 0) := (OTHERS => '0');
        begin
            if rising_edge(clk) then
                if reset = '1' then
                    Q := (OTHERS => '0');
                elsif load = '1' then
                    for j in 0 to num_units-1 loop
                        if (conv_integer(addr)+j = i) then 
                            Q := di(j);
                        end if;
                    end loop;
                end if;
            end if;
        registers_out(i) <= Q;
        end process;
    end generate REG_FILE;
    
    do <= registers_out(conv_integer(addr));
end Behavioral;
