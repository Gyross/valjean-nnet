library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity accumulator is
    Port ( input : in integer;
           enable : in STD_LOGIC;
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           output : out integer);
end accumulator;

architecture Behavioral of accumulator is

    signal count, count_next : integer := 0;

begin

    process(clk)
    begin
        if rising_edge(clk) then
            count <= count_next;
        end if;
    end process;

    process (input, enable, reset, count)
    begin
        count_next <= count;
        
        if enable = '1' then
            if reset = '0' then
                count_next <= count + input;
            else
                count_next <= input;
            end if;
        end if;
    end process;

    output <= count;

end Behavioral;
