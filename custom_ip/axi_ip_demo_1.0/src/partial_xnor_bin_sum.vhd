library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity partial_xnor_bin_sum is
    Port( i   : in std_logic_vector(31 downto 0);
          w   : in std_logic_vector(31 downto 0);
	  bits : in unsigned(31 downto 0);
          clear : in std_logic;
          clk : in std_logic;
          ret : out std_logic_vector(31 downto 0);
          ready : out std_logic);
end partial_xnor_bin_sum;

architecture Behavioral of partial_xnor_bin_sum is
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
signal mask : signed(31 downto 0);
signal initmask : signed(31 downto 0);
signal shifts : unsigned(31 downto 0);
signal maskxnor : std_logic_vector(31 downto 0);
signal sig_clear : std_logic := '0';
--signal sig_num_ones : std_logic_vector(31 downto 0) := (others => '0');
--Unlike full xnor bin sum and pop count this will take more than one clock cycle as you must shift
--a variable

begin

  
  p_count : pop_count
    port map(
              A => maskxnor,
              clear => sig_clear,
              clk => clk,
              ones => num_ones
            );
            
  --When clear is sent, capture the input data and set !Ready
  process(clear, clk)
      begin
        if rising_edge(clk) and clear = '1' then
          
            --Confirm that this is correct? xnor /= xor
            x_nor <= i xor w;

	    initmask <= (0 => '1', others => '0'); -- load 1 
	    shifts <= (others => '0');

	    
	    ready <= '0';
	    sig_clear <= '0';
	    
	elsif rising_edge(clk) and shifts /= bits then
	    shifts <= shifts +1;
	    initmask <= shift_left(initmask, 1);

	--Initialise values and send pulse to pop_count. Pop_count is actually combinational so
	--it will complete in this clock
	elsif rising_edge(clk) and shifts = bits then
	    mask <= initmask - 1;
	    maskxnor <= std_logic_vector(mask) and std_logic_vector(x_nor);

	    sig_clear <= '1';
            --sig_num_ones(5 downto 0) <= num_ones;
	    ret <= std_logic_vector(2* unsigned(num_ones) - bits);
	    ready <= '1';
	    
	             
        end if;
        
    end process;
  
end Behavioral;
