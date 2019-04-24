----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/24/2019 08:32:01 PM
-- Design Name: 
-- Module Name: control - Behavioral
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

entity control is
    port (  clk : in STD_LOGIC;
        weight_RAM_enable : out STD_LOGIC;
        weight_RAM_w_enable : out STD_LOGIC;
        weight_RAM_rst : out STD_LOGIC;
        weight_RAM_addr : out STD_LOGIC_VECTOR(10 downto 0);
        weight_RAM_datain : out STD_LOGIC_VECTOR(15 downto 0);
        bb_addr : out STD_LOGIC_VECTOR(3 downto 0);
        output_RAM_enable : out STD_LOGIC;
        output_RAM_w_enable : out STD_LOGIC;
        output_RAM_rst : out STD_LOGIC;
        output_RAM_addr : out STD_LOGIC_VECTOR(10 downto 0);
        IO_RAM_enable : out STD_LOGIC;
        IO_RAM_w_enable : out STD_LOGIC;
        IO_RAM_rst : out STD_LOGIC;
        IO_RAM_addr : out STD_LOGIC_VECTOR(10 downto 0);
        b_input_init : out STD_LOGIC_VECTOR(15 downto 0);
        load_input_en : out STD_LOGIC;
        acc_reset : out STD_LOGIC;
        acc_en : out STD_LOGIC);
end control;

architecture Behavioral of control is

begin


end Behavioral;
