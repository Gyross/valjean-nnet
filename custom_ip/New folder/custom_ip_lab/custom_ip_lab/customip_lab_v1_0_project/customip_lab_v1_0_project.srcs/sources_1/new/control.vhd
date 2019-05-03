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
use work.data_types.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control is

    port ( 
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        wram_en : in STD_LOGIC;
        bioram_en : in STD_LOGIC;
        ctrl_state : in AXI_state;
        weight_RAM_enable : out STD_LOGIC;
        weight_RAM_w_enable : out STD_LOGIC;
        weight_RAM_rst : out STD_LOGIC;
        weight_RAM_addr : out w_addr_array;
        bb_addr : out STD_LOGIC_VECTOR(buffer_addr_size-1 downto 0);
        output_RAM_enable : out STD_LOGIC;
        output_RAM_w_enable : out STD_LOGIC;
        output_RAM_rst : out STD_LOGIC;
        output_RAM_addr : out STD_LOGIC_VECTOR(output_addr_size-1 downto 0);
        IO_RAM_enable : out STD_LOGIC;
        IO_RAM_w_enable : out STD_LOGIC;
        IO_RAM_rst : out STD_LOGIC;
        IO_RAM_addr_in : out STD_LOGIC_VECTOR(io_addr_size-1 downto 0);
        IO_RAM_addr_out : out STD_LOGIC_VECTOR(io_addr_size-1 downto 0);
        load_input_en : out STD_LOGIC;
        acc_reset : out STD_LOGIC;
        acc_en : out STD_LOGIC;
        forward_output : out STD_LOGIC;
        OREG_done : out STD_LOGIC);
end control;

architecture Behavioral of control is

signal w_count_enable : STD_LOGIC := '0';
signal w_count_reset : STD_LOGIC := '0';
signal w_addr : natural range 0 to weight_ram_size+1 := 0;
signal w_count_in : natural range 0 to weight_ram_size-1 := 0;

signal i_count_enable : STD_LOGIC := '0';
signal i_count_reset : STD_LOGIC := '0';
signal i_addr : natural range 0 to io_ram_size-1 := 0;
signal i_count_in : natural range 0 to io_ram_size := 0;

signal o_count_enable : STD_LOGIC := '0';
signal o_count_reset : STD_LOGIC := '0';
signal o_addr : natural range 0 to io_ram_size-1 := 0;
signal o_count_in : natural range 0 to io_ram_size-1 := 0;

signal nbo_count_enable : STD_LOGIC := '0';
signal nbo_count_reset : STD_LOGIC := '0';
signal nbo_addr : natural range 0 to output_ram_size-1 := 0;
signal nbo_count_in : natural range 0 to output_ram_size-1 := 0;

signal b_count_enable : STD_LOGIC := '0';
signal b_count_reset : STD_LOGIC := '0';
signal b_addr : natural range 0 to buffer_size-1 := 0;
signal b_count_in : natural range 0 to buffer_size-1 := 0;
signal forward_output_delay : STD_LOGIC := '0';

signal layer : natural range 0 to 2 := 0;
signal w_incr : natural range 1 to weight_ram_size := 1;
signal nbo_incr : natural range 1 to output_ram_size := 1;

component counter is
    Generic (count_limit : natural range 0 to 2000);
    Port (  clk    : in STD_LOGIC;
            restart  : in STD_LOGIC;
            enable : in STD_LOGIC;
            input  : in natural range 0 to count_limit;
            output : out natural range 0 to count_limit;
            increment : in natural range 1 to weight_ram_size := 1);
end component;
	
begin

    process(clk, reset)
    begin
        if (reset = '1') then 
            forward_output <= '0';
        elsif (rising_edge(clk)) then
            if forward_output_delay = '1' then
                forward_output <= '1';
            else
                forward_output <= '0';
            end if;
        end if; 
    end process;
    
    input_counter : counter
        generic map ( count_limit => io_ram_size-1 )
        port map ( clk => clk,
                   restart => i_count_reset,
                   enable => i_count_enable,
                   input => i_count_in,
                   output => i_addr );
    
    weight_counter : counter
        generic map ( count_limit => weight_ram_size+1 )
        port map (clk => clk,
                  restart => w_count_reset,
                  enable => w_count_enable,
                  input => w_count_in,
                  output => w_addr,
                  increment => w_incr );
                  
    output_counter : counter
      generic map ( count_limit => io_ram_size-1 )
      port map ( clk => clk,
                 restart => o_count_reset,
                 enable => o_count_enable,
                 input => o_count_in,
                 output => o_addr );
    
    non_binarised_output_counter : counter
       generic map ( count_limit => output_ram_size-1 )
       port map ( clk => clk,
                  restart => nbo_count_reset,
                  enable => nbo_count_enable,
                  input => nbo_count_in,
                  output => nbo_addr,
                  increment => nbo_incr );
                 
    bb_counter : counter
     generic map ( count_limit => buffer_size-1 )
     port map ( clk => clk,
                restart => b_count_reset,
                enable => b_count_enable,
                input => b_count_in,
                output => b_addr,
                increment => num_units );
    
    bb_addr <= std_logic_vector(to_unsigned(b_addr, buffer_addr_size));
    weight_RAM_w_enable <= wram_en;
    weight_RAM_rst <= '0';
    weight_RAM_enable <= '1';
    IO_RAM_rst <= '0';
    IO_RAM_enable <= '1';
    output_RAM_rst <= '0';
    output_RAM_enable <= '1';
    nbo_incr <= num_units;
    
    process(ctrl_state, i_addr, w_addr, b_addr, o_addr, nbo_addr, layer, bioram_en)
    begin
        
        IO_RAM_w_enable <= '0';
        output_RAM_w_enable <= '0';
        load_input_en <= '0';
        
        w_count_enable <= '0';
        w_count_reset <= '0';
        w_count_in <= 0;
                
        i_count_enable <= '0';
        i_count_reset <= '0';
        i_count_in <= 0;
                
        o_count_enable <= '0';
        o_count_reset <= '0';
        o_count_in <= 0;
                
        nbo_count_enable <= '0';
        nbo_count_reset <= '0';
        nbo_count_in <= 0;
                                
        b_count_enable <= '0';
        b_count_reset <= '0';
        b_count_in <= 0;
        
        acc_en <= '0';
        acc_reset <= '1';
        
        forward_output_delay <= '0';
        w_incr <= 1;
        OREG_done <= '0';
        
        if (ctrl_state = NOP) then
            w_count_reset <= '1';
            i_count_reset <= '1';
            o_count_reset <= '1';
            nbo_count_reset <= '1';
            b_count_reset <= '1';
        elsif (ctrl_state = BIO) then
            IO_RAM_w_enable <= bioram_en;
            o_count_enable <= bioram_en;
            load_input_en <= '1';
            if o_addr = LAYER_LAST_IDX(0) then
                o_count_in <= LAYER_FIRST_IDX(1);
                o_count_reset <= '1';
            end if;
        elsif (ctrl_state = Calc) then
            acc_en <= '1';
            acc_reset <= '0';
            w_count_enable <= '1';
            i_count_enable <= '1';
            
            if w_addr < WEIGHT_LAST_IDX(0)- num_units * LAYER_HWS(0) then
                i_count_in <= LAYER_FIRST_IDX(0);
            elsif w_addr < WEIGHT_LAST_IDX(1)- num_units * LAYER_HWS(1) then
                i_count_in <= LAYER_FIRST_IDX(1);
            else
                i_count_in <= LAYER_FIRST_IDX(2);
            end if;
            
            if ( i_addr = LAYER_LAST_IDX(layer)) then
                i_count_reset <= '1';
                w_incr <= (num_units-1) * LAYER_HWS(layer)+1;
            end if;
            if i_addr = LAYER_FIRST_IDX(layer)+1  then
                if w_addr > WEIGHT_FIRST_IDX(0)+1 then
                    b_count_enable <= '1';
                end if;
                acc_reset <= '1';
                -- increment bb addr and reset acc and don't enable it
                if b_addr = buffer_size - num_units then
                    IO_RAM_w_enable <= '1';
                    o_count_enable <= '1';
                    b_count_reset <= '1';
                    if i_addr = o_addr then
                        forward_output_delay <= '1';
                    end if;
                end if;
                if layer = 2 and w_addr > WEIGHT_FIRST_IDX(layer)+1 then
                    output_RAM_w_enable <= '1';
                    nbo_count_enable <= '1';
                end if;
            end if;
            if (layer = 2 and nbo_addr >= output_ram_size) then
                nbo_count_reset <= '1';
                OREG_done <= '1';
            end if;
        else -- state = Read
            w_count_reset <= '1';
            i_count_reset <= '1';
            o_count_reset <= '1';
            nbo_count_reset <= '1';
            b_count_reset <= '1';
        end if;
        
        for i in 0 to num_units-1 loop
            if w_addr+i*LAYER_HWS(layer) <=  WEIGHT_LAST_IDX(layer) then
                weight_RAM_addr(i) <= std_logic_vector(to_unsigned(w_addr+i*LAYER_HWS(layer), weight_addr_size));
            else
                weight_RAM_addr(i) <= std_logic_vector(to_unsigned(0, weight_addr_size));
            end if;
        end loop;
    end process;
    
    layer <= 0 when w_addr <= WEIGHT_LAST_IDX(0) else
             1 when w_addr <= WEIGHT_LAST_IDX(1)  else
             2;
    
    IO_RAM_addr_in <= std_logic_vector(to_unsigned(o_addr, io_addr_size));
    IO_RAM_addr_out <= std_logic_vector(to_unsigned(i_addr, io_addr_size));
    output_RAM_addr <= std_logic_vector(to_unsigned(nbo_addr, output_addr_size)) when nbo_addr < output_ram_size else
                       std_logic_vector(to_unsigned(0, output_addr_size));        

end Behavioral;
