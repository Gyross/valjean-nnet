----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/24/2019 08:32:01 PM
-- Design Name: 
-- Module Name: control - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control is
    port (  clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            AXI_valid : in STD_LOGIC;
            AXI_ready : out STD_LOGIC;
            weight_RAM_enable : out STD_LOGIC;
            weight_RAM_w_enable : out STD_LOGIC;
            weight_RAM_rst : out STD_LOGIC;
            weight_RAM_addr : out STD_LOGIC_VECTOR(10 downto 0);
            bb_addr : out STD_LOGIC_VECTOR(3 downto 0);
            output_RAM_enable : out STD_LOGIC;
            output_RAM_w_enable : out STD_LOGIC;
            output_RAM_rst : out STD_LOGIC;
            output_RAM_addr : out STD_LOGIC_VECTOR(10 downto 0);
            IO_RAM_enable : out STD_LOGIC;
            IO_RAM_w_enable : out STD_LOGIC;
            IO_RAM_rst : out STD_LOGIC;
            IO_RAM_addr_in : out STD_LOGIC_VECTOR(10 downto 0);
            IO_RAM_addr_out : out STD_LOGIC_VECTOR(10 downto 0);
            load_input_en : out STD_LOGIC;
            acc_reset : out STD_LOGIC;
            acc_en : out STD_LOGIC);
end control;

architecture Behavioral of control is

TYPE State_type IS (Idle, Load_weights, Load_input, Calculate);  -- Define the states
	SIGNAL state, state_next : State_Type;

signal w_count_enable : STD_LOGIC := '0';
signal i_count_enable : STD_LOGIC := '0';
signal w_count_reset : STD_LOGIC := '0';
signal i_count_reset : STD_LOGIC := '0';

signal w_addr : natural range 0 to 1652 := 0;
signal i_addr : natural range 0 to 55 := 0;

signal o_addr : natural range 0 to 55 := 0;
signal o_count_enable : STD_LOGIC := '0';
signal o_count_reset : STD_LOGIC := '0';

signal b_addr : natural range 0 to 16 := 0;
signal b_count_enable : STD_LOGIC := '0';
signal b_count_reset : STD_LOGIC := '0';

signal w_count_in : natural range 0 to 1652 := 0;
signal i_count_in : natural range 0 to 55 := 0;
signal o_count_in : natural range 0 to 55 := 49;
signal b_count_in : natural range 0 to 16 := 0;

signal layer : natural range 0 to 2 := 0;

component counter is
    Generic (count_limit : natural range 0 to 2000 := 1652);
    Port (  clk    : in STD_LOGIC;
            restart  : in STD_LOGIC;
            enable : in STD_LOGIC;
            input  : in natural range 0 to count_limit;
            output : out natural range 0 to count_limit);
end component;
	
begin

    process(clk, reset)
    begin
        if (reset = '1') then -- go to state zero if reset
            state <= Idle;
        elsif (rising_edge(clk)) then -- otherwise update the states
            state <= state_next;
        end if; 
    end process;
    
    input_counter : counter
        generic map ( count_limit => 55 )
        port map ( clk => clk,
                   restart => i_count_reset,
                   enable => i_count_enable,
                   input => i_count_in,
                   output => i_addr );
    
    weight_counter : counter
        generic map ( count_limit => 1652 )
        port map (clk => clk,
                  restart => w_count_reset,
                  enable => w_count_enable,
                  input => w_count_in,
                  output => w_addr );
                  
    output_counter : counter
      generic map ( count_limit => 55 )
      port map ( clk => clk,
                 restart => o_count_reset,
                 enable => o_count_enable,
                 input => o_count_in,
                 output => o_addr );
                 
    bb_counter : counter
     generic map ( count_limit => 16 )
     port map ( clk => clk,
                restart => b_count_reset,
                enable => b_count_enable,
                input => b_count_in,
                output => b_addr );
    
    bb_addr <= std_logic_vector(to_unsigned(b_addr, 4));
    
    process(state, i_addr, w_addr, b_addr, o_addr, AXI_valid, layer)
    begin
        state_next <= state;
        IO_RAM_rst <= '0';
        weight_RAM_rst <= '0';
        output_RAM_rst <= '0';
        IO_RAM_enable <= '0';
        IO_RAM_w_enable <= '0';
        load_input_en <= '0';
        weight_RAM_enable <= '0';
        weight_RAM_w_enable <= '0';
        w_count_enable <= '0';
        w_count_reset <= '0';
        i_count_reset <= '0';
        i_count_enable <= '0';
        b_count_enable <= '0';
        o_count_enable <= '0';
        o_count_reset <= '0';
        b_count_reset <= '0';
        i_count_in <= 0;
        w_count_in <= 0;
        b_count_in <= 0;
        o_count_in <= 49;
        acc_en <= '0';
        acc_reset <= '1';
        output_RAM_w_enable <= '0';
        output_RAM_enable <= '0';
        AXI_ready <= '0';
        IO_RAM_addr_in <= std_logic_vector(to_unsigned(55, 11));
        if (state = Idle) then
            weight_RAM_rst <= '1';
            IO_RAM_rst <= '1';
            AXI_ready <= '1';
            if AXI_valid = '1' then
                state_next <= Load_weights;
            end if;
        elsif (state = Load_weights) then
            AXI_ready <= '1';
            weight_RAM_enable <= '1';
            weight_RAM_w_enable <= '1';
            w_count_enable <= '1';
            if w_addr = 1651 then
                state_next <= Load_input;
                w_count_reset <= '1';
            end if;
        elsif (state = Load_input) then
            AXI_ready <= '1';
            IO_RAM_enable <= '1';
            IO_RAM_w_enable <= '1';
            i_count_enable <= '1';
            load_input_en <= '1';
            if i_addr = 54 then
                state_next <= Calculate;
                i_count_reset <= '1';
            end if;
        else -- state = Calculate
            weight_RAM_enable <= '1';
            IO_RAM_enable <= '1';
            acc_en <= '1';
            acc_reset <= '0';
            w_count_enable <= '1';
            i_count_enable <= '1';
            IO_RAM_enable <= '1';
            if (layer = 0 and i_addr = 48) or (layer = 1 and i_addr = 50)
            or (layer = 2 and i_addr = 52) then
                b_count_enable <= '1';
                acc_reset <= '1';
                i_count_reset <= '1';
                -- increment bb addr and reset acc and don't enable it
            end if;
            if b_addr = 16 then
                IO_RAM_w_enable <= '1';
                IO_RAM_addr_in <= std_logic_vector(to_unsigned(o_addr, 11));
                o_count_enable <= '1';
                b_count_reset <= '1';
            end if;
            if (layer = 0 and w_addr = 1567) then
                i_count_in <= 49;
            end if;
            if (layer = 1 and w_addr = 1631) then
                i_count_in <= 51;
            end if;
            
            output_RAM_w_enable <= '1';
            output_RAM_enable <= '1';
            
        end if;
        IO_RAM_addr_out <= std_logic_vector(to_unsigned(i_addr, 11));
        weight_RAM_addr <= std_logic_vector(to_unsigned(w_addr, 11));
        output_RAM_addr <= std_logic_vector(to_unsigned(0, 11));
        
    end process;
    
    layer <= 0 when w_addr < 1568 else
             1 when 1568 <= w_addr and w_addr < 1632  else
             2;
            

end Behavioral;
