library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.data_types.ALL;

entity control is
    port ( 
        clk        : in  std_logic;
        reset      : in  std_logic;
        ctrl_state : in  AXI_state;
        wram_ao    : out natural;
        bb_ai      : out natural; -- done
        oreg_we    : out std_logic; -- done
        oreg_ai    : out natural; -- done
        bioram_we  : out std_logic; -- done
        bioram_ai  : out natural; -- done
        bioram_ao  : out natural; -- done
        acc_reset  : out std_logic; -- done
        acc_en     : out std_logic; -- done
        oreg_done  : out std_logic; -- done
        bioram_load_we : in std_logic -- in
    );
end control;

architecture Behavioral of control is

    type r_t is record
        bioram_ai : natural;
        bioram_ao : natural;
        step      : natural;
        layer     : natural;
        bb_ai     : natural;
        bb_ai_reg : natural;
        oreg_ai   : natural;
        oreg_done : std_logic;
    end record;

    constant r0 : r_t := (bioram_ai => 0,
                          bioram_ao => 0,
                          step => 0,
                          layer => 0,
                          bb_ai => 0,
                          bb_ai_reg => 0,
                          oreg_ai => 0,
                          oreg_done => '0');

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
        oreg_we    <= '0';
        bioram_we  <= '0';
        acc_reset  <= '0';
        acc_en     <= '0';
        bioram_ai <= 0;
        bioram_ao <= r.bioram_ao;
        oreg_done <= r.oreg_done;
        oreg_ai <= r.oreg_ai;
        bb_ai <= r.bb_ai_reg;
        wram_ao <= r.step;

        qv.bb_ai_reg := r.bb_ai;

        if (ctrl_state = NOP or ctrl_state = READ) then

            qv := r0;

        elsif (ctrl_state = BIO) then

            bioram_we <= bioram_load_we;
            bioram_ai <= r.bioram_ai;

            if bioram_load_we = '1' then
                qv.bioram_ai := r.bioram_ai + 1;
            end if;

        elsif (ctrl_state = CALC) then
        
            acc_en <= '1';
            acc_reset <= '0';
            bioram_ai <= r.bioram_ai;
            qv.step := r.step + 1;
            
            -- calculate next outputs from IORAM and weights:
            if r.bioram_ao = LAYER_LAST_IDX(r.layer) then
                -- we've either just finished an output, or
                -- we've finished an entire layer
                if r.step =  WEIGHT_LAST_IDX(r.layer) then
                    qv.layer := r.layer+1;
                    if r.layer+1 < num_layers-1 then
                        qv.bioram_ao := LAYER_FIRST_IDX(r.layer + 1);
                    end if;
                else
                    qv.bioram_ao := LAYER_FIRST_IDX(r.layer);
                end if;
            else
                qv.bioram_ao := r.bioram_ao + 1;
            end if;
            
            -- calculate the buffer and input to IO ram, and output:
            -- NOTE: buffer is one clock cycle behind.
            if r.bioram_ao = LAYER_FIRST_IDX(r.layer) and r.step > 0 then
                acc_reset <= '1';
                if r.bb_ai < buffer_size - num_units then
                    qv.bb_ai := r.bb_ai + num_units;
                else
                    qv.bb_ai := 0;
                    qv.bioram_ai := r.bioram_ai + 1;
                    bioram_we <= '1';
                end if;
                if r.layer = num_layers-2 then
                    oreg_we <= '1';
                    qv.oreg_ai := qv.bb_ai;
                end if;
            end if;
            
            if qv.layer = num_layers-1 then
                qv.oreg_done := '1';
            end if;
                
            
        end if;
        
        q <= qv;
    end process;
    
    
end Behavioral;
