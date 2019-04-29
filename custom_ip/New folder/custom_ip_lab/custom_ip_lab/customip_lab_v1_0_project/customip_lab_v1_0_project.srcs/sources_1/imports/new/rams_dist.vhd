
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.data_types.all;
use ieee.numeric_std.all;


entity weight_RAM is
    port(
    clk : in std_logic;
    en : in std_logic;
    we : in std_logic;
    rst : in std_logic;
    addri : in integer;
    addro : in w_addr_array;
    di : in std_logic_vector(bit_width-1 downto 0);
    do : out data_array
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
                    ram(addri) <= di;
                end if;
                for i in 0 to num_units-1 loop
                    if rst = '1' then -- optional reset
                        do(i) <= (others => '0');
                    else
                        do(i) <= ram(conv_integer(addro(i)));
                    end if;
                end loop;
            end if;
         end if;
     end process;
    end syn;