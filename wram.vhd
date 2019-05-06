library ieee;
use ieee.std_logic_1164.all;
use work.data_types.all;

entity wram is
    port(
        clk : in  std_logic;
        we  : in  std_logic;
        ai  : in  natural;
        ao  : in  w_addr_array;
        di  : in  word;
        do  : out data_array
    );
end wram;


architecture syn of wram is

     type ram_type is array (0 to weight_ram_size-1) of word;
     signal ram : ram_type := (OTHERS => (OTHERS => '0'));

begin

    process(clk)
    begin
        if clk'event and clk = '1' then
            if we = '1' then -- write enable
                ram(ai) <= di;
            end if;
        end if;
    end process;

    process (ram, ao)
    begin
        for i in 0 to num_units-1 loop
            do(i) <= ram(ao(i));
        end loop;
    end process;
     
end syn;
