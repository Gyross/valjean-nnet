library ieee;
use ieee.std_logic_1164.all;
use work.data_types.all;

entity wram is
    port(
        clk : in  std_logic;
        we  : in  std_logic;
        ai  : in  natural;
        ao  : in  natural;
        di  : in  word;
        do  : out data_array
    );
end wram;


architecture syn of wram is

    constant ram_width : natural := weight_ram_size/num_units;

    type ram_unit is array (0 to ram_width-1) of word;
    type ram_t is array (0 to num_units-1) of ram_unit;

    signal ram : ram_t := (others => (others => (others => '0')));

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if we = '1' then -- write enable
                for i in 0 to num_units-1 loop
                    if i = ai/ram_width then
                        ram(i)(ai mod ram_width) <= di;
                    end if;
                end loop;
            end if;
        end if;
    end process;

    process (ram, ao)
    begin
        for i in 0 to num_units-1 loop
            do(i) <= ram(i)(ao);
        end loop;
    end process;
     
end syn;
