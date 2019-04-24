library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity customip_lab_v1_0 is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 4
	);
	port (
		-- Users to add ports here

		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: out std_logic;
		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: out std_logic;
		s00_axi_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_bvalid	: out std_logic;
		s00_axi_bready	: in std_logic;
		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: out std_logic;
		s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_rvalid	: out std_logic;
		s00_axi_rready	: in std_logic
	);
end customip_lab_v1_0;

architecture arch_imp of customip_lab_v1_0 is

	-- component declaration
	component customip_lab_v1_0_S00_AXI is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 4
		);
		port (
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic;
		datain0   :   in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        datain1   :   in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        datain2   :   in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        datain3   :   in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        dataout0   :   out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        dataout1   :   out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        dataout2   :   out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        dataout3   :   out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0)
		);
	end component customip_lab_v1_0_S00_AXI;
	
	component vecmult is
        Generic ( bit_width : integer := 32 );
        Port ( input : in STD_LOGIC_VECTOR (bit_width-1 downto 0);
               weight : in STD_LOGIC_VECTOR (bit_width-1 downto 0);
               bits : in STD_LOGIC_VECTOR (bit_width-1 downto 0);
               bias : in integer;
               enable : in STD_LOGIC;
               reset : in STD_LOGIC;
               clk : in STD_LOGIC;
               output : out STD_LOGIC_VECTOR(31 DOWNTO 0));
    end component;
    
    component weight_RAM is
        port(
        clk : in std_logic;
        en : in std_logic;
        we : in std_logic;
        rst : in std_logic;
        addr : in std_logic_vector(10 downto 0);
        di : in std_logic_vector(15 downto 0);
        do : out std_logic_vector(15 downto 0)
        );
    end component;
    
    component IO_RAM is
        port(
        clk : in std_logic;
        en : in std_logic;
        we : in std_logic;
        rst : in std_logic;
        addr : in std_logic_vector(10 downto 0);
        di : in std_logic_vector(15 downto 0);
        do : out std_logic_vector(15 downto 0)
        );
    end component;
    
    component output_RAM is
            port(
            clk : in std_logic;
            en : in std_logic;
            we : in std_logic;
            rst : in std_logic;
            addr : in std_logic_vector(10 downto 0);
            di : in std_logic_vector(15 downto 0);
            do : out std_logic_vector(15 downto 0)
            );
        end component;
        
    component binarised_buffer is
            Port ( clk : in STD_LOGIC;
                    enable : in STD_LOGIC;
                   addr : in std_logic_vector(3 downto 0);
                   sign : in std_logic;
                   dataout : out STD_LOGIC_vector(15 downto 0));
            end component;
    
    
--    component fifo_wrapper is
--        port (
--            FIFO_READ_empty : out STD_LOGIC;
--            FIFO_READ_rd_data : out STD_LOGIC_VECTOR ( 17 downto 0 );
--            FIFO_READ_rd_en : in STD_LOGIC;
--            FIFO_WRITE_full : out STD_LOGIC;
--            FIFO_WRITE_wr_data : in STD_LOGIC_VECTOR ( 17 downto 0 );
--            FIFO_WRITE_wr_en : in STD_LOGIC;
--            clk : in STD_LOGIC;
--            srst : in STD_LOGIC);
--    end component;
	
    signal datain0, datain1, datain2, datain3       : std_logic_vector(31 downto 0);
    signal dataout0, dataout1, dataout2, dataout3   : std_logic_vector(31 downto 0);
    
    --Signals for data input multiplexer for IO_RAM
    signal vecmult_dataout : std_logic_vector(15 downto 0);
    signal bb_dataout : std_logic_vector(15 downto 0);
    signal IO_RAM_datain : std_logic_vector(15 downto 0);
    signal IO_RAM_datain_ctrl : std_logic := '0';
    
    --IO_RAM signals
    signal IO_RAM_addr : std_logic_vector(10 downto 0);
    signal IO_RAM_dataout : std_logic_vector(15 downto 0);
    signal IO_RAM_enable, IO_RAM_w_enable, IO_RAM_rst :std_logic;
    
    --Weight Ram Signals
    signal weight_RAM_addr : std_logic_vector(10 downto 0);
    signal weight_RAM_datain : std_logic_vector(15 downto 0);
    signal weight_RAM_dataout : std_logic_vector(15 downto 0);
    signal weight_RAM_enable, weight_RAM_w_enable, weight_RAM_rst :std_logic;
    
    --Weight Ram Signals
    signal output_RAM_addr : std_logic_vector(10 downto 0);
    signal output_RAM_datain : std_logic_vector(15 downto 0);
    signal output_RAM_dataout : std_logic_vector(15 downto 0);
    signal output_RAM_enable, output_RAM_w_enable, output_RAM_rst :std_logic;
    
    

begin                   
                    
-- Instantiation of Axi Bus Interface S00_AXI
customip_lab_v1_0_S00_AXI_inst : customip_lab_v1_0_S00_AXI
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
		S_AXI_ACLK	=> s00_axi_aclk,
		S_AXI_ARESETN	=> s00_axi_aresetn,
		S_AXI_AWADDR	=> s00_axi_awaddr,
		S_AXI_AWPROT	=> s00_axi_awprot,
		S_AXI_AWVALID	=> s00_axi_awvalid,
		S_AXI_AWREADY	=> s00_axi_awready,
		S_AXI_WDATA	=> s00_axi_wdata,
		S_AXI_WSTRB	=> s00_axi_wstrb,
		S_AXI_WVALID	=> s00_axi_wvalid,
		S_AXI_WREADY	=> s00_axi_wready,
		S_AXI_BRESP	=> s00_axi_bresp,
		S_AXI_BVALID	=> s00_axi_bvalid,
		S_AXI_BREADY	=> s00_axi_bready,
		S_AXI_ARADDR	=> s00_axi_araddr,
		S_AXI_ARPROT	=> s00_axi_arprot,
		S_AXI_ARVALID	=> s00_axi_arvalid,
		S_AXI_ARREADY	=> s00_axi_arready,
		S_AXI_RDATA	=> s00_axi_rdata,
		S_AXI_RRESP	=> s00_axi_rresp,
		S_AXI_RVALID	=> s00_axi_rvalid,
		S_AXI_RREADY	=> s00_axi_rready,
		datain0       => datain0,
		datain1       => datain1,
		datain2       => datain2,
		datain3       => datain3,
		
		dataout0      => dataout0,
		dataout1      => dataout1,
		dataout2      => dataout2,
		dataout3      => dataout3
	);
	
vecmult_inst : vecmult
    port map (
        input => IO_RAM_dataout,
        weight => weight_RAM_dataout,
        bits => X"ffffffff",
        bias => 1,
        clk => s00_axi_aclk,
        reset =>  datain2(1),
        enable =>  datain2(0),
        output => dataout0
    );
     
         
--Multiplexer for the data input of the IO RAM
IO_RAM_datain <= vecmult_dataout when IO_RAM_datain_ctrl = '0' else
                bb_dataout when IO_RAM_datain_ctrl = '1';
                     
 io_ram_inst : IO_RAM
    port map (
        clk => s00_axi_aclk,
        en => IO_RAM_enable,
        we => IO_RAM_w_enable,
        rst => IO_RAM_rst,
        addr => IO_RAM_addr,
        di => IO_RAM_datain,
        do => IO_RAM_dataout
    );
    
output_ram_inst : IO_RAM
    port map (
        clk => s00_axi_aclk,
        en => output_RAM_enable,
        we => output_RAM_w_enable,
        rst => output_RAM_rst,
        addr => output_RAM_addr,
        di => output_RAM_datain,
        do => output_RAM_dataout
    );
    
weight_ram_inst : weight_RAM
 port map(
       clk => s00_axi_aclk,
       en => weight_RAM_enable,
       we => weight_RAM_w_enable,
       rst => weight_RAM_rst,
       addr => weight_RAM_addr,
       di => weight_RAM_datain,
       do => weight_RAM_dataout
  );
  
  binarised_buffer_inst : binarised_buffer
    port map(
        clk => s00_axi_aclk,
        enable => bb_enable
        addr => bb_addr,
        sign dataout0(15),
        dataout => bb_dataout
    );

end arch_imp;
