library ieee;
use ieee.std_logic_1164.all;
use work.data_types.all;

entity bioram is
    port(
        clk : in  std_logic;
        we  : in  std_logic;
        ia  : in  natural;
        oa  : in  natural;
        di  : in  word;
        do  : out word
    );
end bioram;


architecture syn of bioram is

    type ram_type is array (io_ram_size-1 downto 0) of word;
    signal ram : ram_type  := (OTHERS => (OTHERS => '0'));

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if we = '1' then
                ram(ia) <= di;
            end if;
        end if;
    end process;

    do <= ram(oa);

end syn;
