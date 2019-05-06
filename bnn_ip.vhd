library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.data_types.all;

entity bnn_ip is
    generic (
        -- Parameters of Axi Slave Bus Interface S00_AXI
        C_S00_AXI_DATA_WIDTH : integer := 32;
        C_S00_AXI_ADDR_WIDTH : integer := 4
    );
    port (
        -- Ports of Axi Slave Bus Interface S00_AXI
        s00_axi_aclk    : in  std_logic;
        s00_axi_aresetn : in  std_logic;
        s00_axi_awaddr  : in  std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
        s00_axi_awprot  : in  std_logic_vector(2 downto 0);
        s00_axi_awvalid : in  std_logic;
        s00_axi_awready : out std_logic;
        s00_axi_wdata   : in  std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
        s00_axi_wstrb   : in  std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
        s00_axi_wvalid  : in  std_logic;
        s00_axi_wready  : out std_logic;
        s00_axi_bresp   : out std_logic_vector(1 downto 0);
        s00_axi_bvalid  : out std_logic;
        s00_axi_bready  : in  std_logic;
        s00_axi_araddr  : in  std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
        s00_axi_arprot  : in  std_logic_vector(2 downto 0);
        s00_axi_arvalid : in  std_logic;
        s00_axi_arready : out std_logic;
        s00_axi_rdata   : out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
        s00_axi_rresp   : out std_logic_vector(1 downto 0);
        s00_axi_rvalid  : out std_logic;
        s00_axi_rready  : in  std_logic
    );
end bnn_ip;

architecture arch_imp of bnn_ip is

    --binarised io ram signals
    signal bioram_we : std_logic;
    signal bioram_ai : natural;
    signal bioram_ao : natural;
    signal bioram_di : word;
    signal bioram_do : word;

    --binarised io ram  mux signals
    signal bioram_load_di : word;
    signal bioram_load_we : std_logic;
    
    --Weight Ram Signals
    signal wram_we : std_logic; 
    signal wram_ai : natural;
    signal wram_ao : w_addr_array;
    signal wram_di : word;
    signal wram_do : data_array;
    
    --output register signals
    signal oreg_we : std_logic;
    signal oreg_ai : natural;
    signal oreg_ao : natural;
    signal oreg_do : out_word;
    signal oreg_di : output_array;
    
    --Vecmult unit signals
    signal vm_do     : output_array;
    signal vm_input  : word;
    signal vm_weight : word;
    signal acc_en, acc_reset : std_logic;
    
    --Binarised buffer signals
    signal bb_ai : natural;
    signal bb_di : bin_bundle;
    signal bb_do : word;
    
    -- CTRL unit ports
    signal oreg_done   : std_logic; -- alias ctrl_OV
    signal ctrl_state  : AXI_state;
    
    signal reset : std_logic := '0';

begin           
    
    reset <= not s00_axi_aresetn;
                        
    GEN_VM_UNIT: for i in 0 to num_units-1 generate
        vecmult_inst : entity work.vecmult
        port map (
            clk    => s00_axi_aclk,
            reset  => acc_reset,
            enable => acc_en,
            input  => vm_input,
            weight => vm_weight,
            bits   => (OTHERS => '1'),
            bias   => 0,
            output => vm_do(i)
        );
        -- input map
        vm_weight <= wram_do(i);
        vm_input  <= bioram_do;
        -- output map
        bb_di(i) <= vm_do(i)(15);
        oreg_di  <= vm_do;
    end generate GEN_VM_UNIT;
     
    --Multiplexer for the data input of the IO RAM
    bioram_di <= bioram_load_di when bioram_load_we = '1' else bb_do;
                     
    bioram_inst : entity work.bioram
    port map (
        clk => s00_axi_aclk,
        we  => bioram_we,
        ia  => bioram_ai,
        oa  => bioram_ao,
        di  => bioram_di,
        do  => bioram_do
    );

    oreg_inst : entity work.oreg
    port map (
        clk => s00_axi_aclk,
        we  => oreg_we,
        ai  => oreg_ai,
        ao  => oreg_ao,
        di  => oreg_di,
        do  => oreg_do
    );

    wram_inst : entity work.wram
    port map(
        clk => s00_axi_aclk,
        we  => wram_we,
        ai  => wram_ai,
        ao  => wram_ao,
        di  => wram_di,
        do  => wram_do
    );

    binarised_buffer_inst : entity work.binarised_buffer
    port map(
        clk => s00_axi_aclk,
        ai  => bb_ai,
        di  => bb_di,
        do  => bb_do
    );

    -- Instantiation of Axi Bus Interface S00_AXI
    axi_interface_inst : entity work.axi_interface
    generic map (
        C_S_AXI_DATA_WIDTH => C_S00_AXI_DATA_WIDTH,
        C_S_AXI_ADDR_WIDTH => C_S00_AXI_ADDR_WIDTH
    )
    port map (
        S_AXI_ACLK    => s00_axi_aclk,
        S_AXI_ARESETN => s00_axi_aresetn,
        S_AXI_AWADDR  => s00_axi_awaddr,
        S_AXI_AWPROT  => s00_axi_awprot,
        S_AXI_AWVALID => s00_axi_awvalid,
        S_AXI_AWREADY => s00_axi_awready,
        S_AXI_WDATA   => s00_axi_wdata,
        S_AXI_WSTRB   => s00_axi_wstrb,
        S_AXI_WVALID  => s00_axi_wvalid,
        S_AXI_WREADY  => s00_axi_wready,
        S_AXI_BRESP   => s00_axi_bresp,
        S_AXI_BVALID  => s00_axi_bvalid,
        S_AXI_BREADY  => s00_axi_bready,
        S_AXI_ARADDR  => s00_axi_araddr,
        S_AXI_ARPROT  => s00_axi_arprot,
        S_AXI_ARVALID => s00_axi_arvalid,
        S_AXI_ARREADY => s00_axi_arready,
        S_AXI_RDATA   => s00_axi_rdata,
        S_AXI_RRESP   => s00_axi_rresp,
        S_AXI_RVALID  => s00_axi_rvalid,
        S_AXI_RREADY  => s00_axi_rready,
        wram_addr     => wram_ai,
        wram_data     => wram_di,
        wram_en       => wram_we,
        oreg_addr     => oreg_ao,
        oreg_data     => oreg_do,
        oreg_done     => oreg_done,
        ctrl_state    => ctrl_state,
        bioram_data   => bioram_load_di,
        bioram_en     => bioram_load_we
    );

    control_module : entity work.control
    port map(
        clk        => s00_axi_aclk,
        reset      => reset,
        ctrl_state => ctrl_state,
        wram_ao    => wram_ao,
        bb_ai      => bb_ai,
        oreg_we    => oreg_we,
        oreg_ai    => oreg_ai,
        bioram_we  => bioram_we,
        bioram_ai  => bioram_ai,
        bioram_ao  => bioram_ao,
        acc_reset  => acc_reset, 
        acc_en     => acc_en,
        oreg_done  => oreg_done,
        bioram_load_we => bioram_load_we
    );

end arch_imp;
