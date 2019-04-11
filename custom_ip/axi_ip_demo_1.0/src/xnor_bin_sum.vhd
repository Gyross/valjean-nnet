library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity xnor_bin_sum is
    Port( i   : in std_logic_vector(31 downto 0);
          w   : in std_logic_vector(31 downto 0);
          clear : in std_logic;
          clk : in std_logic;
          ret : out std_logic_vector(31 downto 0);
          ready : out std_logic);
end xnor_bin_sum;

architecture Behavioral of xnor_bin_sum is
  component pop_count is
    
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
            clear : in std_logic;
            clk   : in std_logic;
            --ready : out std_logic;
           ones : out  STD_LOGIC_VECTOR (5 downto 0));
end component pop_count;

--Primary signals for the pop_count instance
signal x_nor : std_logic_vector(31 downto 0);
signal num_ones : std_logic_vector(5 downto 0);
signal p_count_clr : std_logic := '0';
--signal p_count_rdy : std_logic;

signal xnored : std_logic := '0';


--Included to mimic C code. Could just set packed size to this instead
signal p_size_halved : unsigned(31 downto 0);

--PACKED SIZE constant in C code is sizeof(uint32/BNNI) * 8 = 256 = 0x100
signal PACKED_SIZE : unsigned(31 downto 0) := x"00000100";


begin

  
  p_size_halved <= shift_right(PACKED_SIZE, 1);
  
  p_count : pop_count
    port map(
              A => x_nor,
              clear => clear,
              clk => clk,
              ones => num_ones
            );
            
  --When p_count signals it is ready we capture the output, operate as required
  --then send output back to the higher level and signal ready          
  --process(p_count_rdy)
    --begin
      --if rising_edge(p_count_rdy) then
      --if p_count_rdy = '1' then
        ret <= std_logic_vector(unsigned(num_ones) - p_size_halved);
        --ready <= '1';               
        
      --end if;     
  --end process;
  
  --When clear is sent, capture the input data and set !Ready
  process(clear, clk)
      begin
        if rising_edge(clk) and clear = '1' then
          
            --Confirm that this is correct? xnor /= xor
            x_nor <= i xor w;
            ready <= '0';
            
            --p_count_clr will not be set until the xor operation has completed
            --p_count_clr <= '1';
                        
        end if;
        
        
        --See above about xor vs clk speed
        --if rising_edge(clk) and p_count_clr = '1' then
         -- p_count_clr <= '0';
        --end if;
        
    end process;
  
end Behavioral;