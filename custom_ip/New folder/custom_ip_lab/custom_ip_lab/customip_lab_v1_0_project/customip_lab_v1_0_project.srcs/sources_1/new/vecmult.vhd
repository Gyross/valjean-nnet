----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/17/2019 01:42:14 PM
-- Design Name: 
-- Module Name: vecmult - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vecmult is
    Port ( input : in STD_LOGIC_VECTOR (bit_width-1 downto 0) := (OTHERS => '0');
           weight : in STD_LOGIC_VECTOR (bit_width-1 downto 0) := (OTHERS => '0');
           bits : in STD_LOGIC_VECTOR (bit_width-1 downto 0) := (OTHERS => '0');
           bias : in integer := 0;
           enable : in STD_LOGIC := '0';
           reset : in STD_LOGIC := '0';
           clk : in STD_LOGIC := '0';
           output : out STD_LOGIC_VECTOR (output_width-1 downto 0) := (OTHERS => '0'));
end vecmult;

architecture Behavioral of vecmult is

signal xnor_output : integer := 0;
signal acc_output : integer := 0;

component xnor_sum
    Generic ( bit_width : integer := 16
    );
    Port ( input : in STD_LOGIC_VECTOR(bit_width-1 DOWNTO 0);
           weight : in STD_LOGIC_VECTOR(bit_width-1 DOWNTO 0);
           bits : in STD_LOGIC_VECTOR(bit_width-1 DOWNTO 0);
           output : out integer
    );
end component;

component accumulator
    Port ( input : in integer;
           enable : in STD_LOGIC;
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           output : out integer);
end component;

begin

xnor_sum_inst: xnor_sum
    generic map (bit_width => bit_width )
    port map( input => input, weight => weight, bits => bits, output => xnor_output );

acc_inst: accumulator
    port map ( input => xnor_output, enable => enable, clk => clk, reset => reset, output => acc_output );

output <= std_logic_vector(to_signed(acc_output + bias, output_width));

end Behavioral;
