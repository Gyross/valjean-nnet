library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package data_types is

    constant bit_width        : integer := 16;
    constant output_width     : integer := 16;
    constant io_ram_size      : integer := 55;
    constant weight_ram_size  : integer := 1652;
    constant output_ram_size  : integer := 10;
    constant io_addr_size     : integer := 6;
    constant output_addr_size : integer := 4;
    constant buffer_addr_size : integer := 4;
    constant weight_addr_size : integer := 11;
    constant buffer_size      : integer := 16; -- must equal bit_width
    constant num_units        : integer := 8; -- must be a multiple of buffer_size
    
    subtype word is std_logic_vector(bit_width-1 downto 0);
    subtype out_word is std_logic_vector(output_width-1 downto 0);
    subtype bin_bundle is std_logic_vector(num_units-1 downto 0);

    type data_array is array   (0 to num_units-1) of word;
    type output_array is array (0 to num_units-1) of out_word;
    type w_addr_array is array (0 to num_units-1) of natural;
    
    type out_regs is array (0 to 15) of out_word;
    
    TYPE LAYER_INFO is array (0 to 3) of integer range 0 to 1700;

    constant LAYER_SIZES      : LAYER_INFO := ( 784,   32,   32, 10);
    constant LAYER_HWS        : LAYER_INFO := (  49,    2,    2,  1);
    constant LAYER_LAST_IDX   : LAYER_INFO := (  48,   50,   52, 54);
    constant LAYER_FIRST_IDX  : LAYER_INFO := (   0,   49,   51, 53);
    constant WEIGHT_LAST_IDX  : LAYER_INFO := (1567, 1631, 1651,  0);
    constant WEIGHT_FIRST_IDX : LAYER_INFO := (   0, 1568, 1632,  0);
    
    type AXI_state is (NOP, BIO, CALC, READ);
    
end data_types;
