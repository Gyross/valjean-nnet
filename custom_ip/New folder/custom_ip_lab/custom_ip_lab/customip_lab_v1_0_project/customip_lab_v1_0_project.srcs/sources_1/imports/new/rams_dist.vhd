-- Block RAM with Resettable Data Output
-- File: rams_sp_rf_rst.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity weight_RAM is
    generic(
    weight_ram_size : integer := 1652;
    weight_addr_size : integer := 11;
    bit_width : integer := 16);
    port(
    clk : in std_logic;
    en : in std_logic;
    we : in std_logic;
    rst : in std_logic;
    addr : in std_logic_vector(weight_addr_size-1 downto 0);
    di : in std_logic_vector(bit_width-1 downto 0);
    do : out std_logic_vector(bit_width-1 downto 0)
    );
end weight_RAM;


architecture syn of weight_RAM is
     type ram_type is array (weight_ram_size-1 downto 0) of std_logic_vector(bit_width-1 downto 0);
     signal ram : ram_type;
begin
     process(clk)
         begin
         if clk'event and clk = '1' then
             if en = '1' then -- optional enable
             if we = '1' then -- write enable
             ram(conv_integer(addr)) <= di;
         end if;
         
         if rst = '1' then -- optional reset
             do <= (others => '0');
         else
             do <= ram(conv_integer(addr));
         end if;
         end if;
         end if;
     end process;
    end syn;