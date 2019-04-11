library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pop_count is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
            clear : in std_logic;
            enable : in std_logic;
            ready : out std_logic;
           ones : out  STD_LOGIC_VECTOR (5 downto 0));
end pop_count;

architecture Behavioral of pop_count is

signal A_capture : std_logic_vector(31 downto 0);

begin
    process(clear)
        if rising_edge(clear)
            ready <= '0';
        end if;
    end process;
    
    process(enable)
        if enable = '1' then
            A_capture <= A;
            ready <= '0';
        end if;
    end process;
    
    process(A_capture)
    variable count : unsigned(5 downto 0) := "000000";
    begin
    
        
        
        count := "000000";   --initialize count variable.
        for i in 0 to 31 loop   --check for all the bits.
            if(A_capture(i) = '1') then --check if the bit is '1'
                count := count + 1; --if its one, increment the count.
            end if;
        end loop;
        ones <= std_logic_vector(count);    --assign the count to output.
        ready <= '1';
    end process;
    

end Behavioral;