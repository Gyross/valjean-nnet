library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.data_types.all;

entity binarised_buffer is
    Port ( 
        clk : in  std_logic;
        ai  : in  natural;
        di  : in  bin_bundle;
        do  : out word
    );
end binarised_buffer;

architecture Behavioral of binarised_buffer is
    
    signal buf_out, buf_prev : std_logic_vector(buffer_size-1 downto 0) := (others => '0');
    
begin

    process (clk)
    begin
        if rising_edge(clk) then
            buf_prev <= buf_out;
        end if;
    end process;

    process (buf_prev, ai, di)
        variable buf_comp: std_logic_vector(buffer_size-1 downto 0);
    begin
        buf_comp := buf_prev;
        buf_comp(ai+num_units-1 downto ai) := di;
        buf_out <= buf_comp;
    end process;
    
    do <= buf_out;

end Behavioral;
