library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.data_types.ALL;

entity control is
    port ( 
        clk        : in  std_logic;
        reset      : in  std_logic;
        ctrl_state : in  AXI_state;
        wram_ao    : out w_addr_array;
        bb_ai      : out natural;
        oreg_we    : out std_logic;
        oreg_ai    : out natural;
        bioram_we  : out std_logic;
        bioram_ai  : out natural
        bioram_ao  : out natural;
        acc_reset  : out std_logic;
        acc_en     : out std_logic;
        oreg_done  : out std_logic;
        bioram_load_we : in std_logic
    );
end control;

architecture Behavioral of control is

    type r_t is record
        bioram_ai : natural;
    end record;

    constant r0 : r_t := (bioram_addr => 0);

    signal r, q : r_t;

begin

    process (clk, reset)
    begin
        if reset = '1' then
            r <= r0;
        elsif rising_edge(clk) then
            r <= q;
        end if;
    end process;

    process (r, ctrl_state, bioram_load_we)
        variable qv : r_t;
    begin
        qv := r;

        wram_ao    <= (others => 0);
        bb_ai      <=  0 ;
        oreg_we    <= '0';
        oreg_ai    <=  0 ;
        bioram_we  <= '0';
        bioram_ai  <=  0 ;
        bioram_ao  <=  0 ;
        acc_reset  <= '0';
        acc_en     <= '0';
        oreg_done  <= '0';

        if (crtl_state = NOP or ctrl_state = READ) then

            qv := r0;

        elsif (ctrl_state = BIO) then

            bioram_we <= bioram_load_we;
            bioram_ai <= r.bioram_ai;

            if bioram_load_we = '1' then
                qv.bioram_ai := r.bioram_ai + 1;
            end if;

        elsif (ctrl_state = CALC) then

        end if;
        
        q <= qv;
    end process;






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
