library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.data_types.all;

entity oreg is
    Port (
        clk : in  STD_LOGIC;
        we  : in  STD_LOGIC;
        ai  : in  natural;
        ao  : in  natural;
        di  : in  output_array;
        do  : out word
    );
end oreg;

architecture Behavioral of oreg is

    signal reg : out_regs := (others => (others => '0'));

begin

    process (clk)
    begin
        if rising_edge(clk) then
            if we = '1' then
                for I in 0 to num_units-1 loop
                    reg(ai+I) <= di(I);
                end loop;
            end if;
        end if;
    end process;

    do <= reg(ao);
    
end Behavioral;
