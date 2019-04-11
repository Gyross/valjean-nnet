library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity axi_ip_demo_v1_0 is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface axi_ip_demo
		C_axi_ip_demo_DATA_WIDTH	: integer	:= 32;
		C_axi_ip_demo_ADDR_WIDTH	: integer	:= 4
	);
	port (
		-- Users to add ports here

		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface axi_ip_demo
		axi_ip_demo_aclk	: in std_logic;
		axi_ip_demo_aresetn	: in std_logic;
		axi_ip_demo_awaddr	: in std_logic_vector(C_axi_ip_demo_ADDR_WIDTH-1 downto 0);
		axi_ip_demo_awprot	: in std_logic_vector(2 downto 0);
		axi_ip_demo_awvalid	: in std_logic;
		axi_ip_demo_awready	: out std_logic;
		axi_ip_demo_wdata	: in std_logic_vector(C_axi_ip_demo_DATA_WIDTH-1 downto 0);
		axi_ip_demo_wstrb	: in std_logic_vector((C_axi_ip_demo_DATA_WIDTH/8)-1 downto 0);
		axi_ip_demo_wvalid	: in std_logic;
		axi_ip_demo_wready	: out std_logic;
		axi_ip_demo_bresp	: out std_logic_vector(1 downto 0);
		axi_ip_demo_bvalid	: out std_logic;
		axi_ip_demo_bready	: in std_logic;
		axi_ip_demo_araddr	: in std_logic_vector(C_axi_ip_demo_ADDR_WIDTH-1 downto 0);
		axi_ip_demo_arprot	: in std_logic_vector(2 downto 0);
		axi_ip_demo_arvalid	: in std_logic;
		axi_ip_demo_arready	: out std_logic;
		axi_ip_demo_rdata	: out std_logic_vector(C_axi_ip_demo_DATA_WIDTH-1 downto 0);
		axi_ip_demo_rresp	: out std_logic_vector(1 downto 0);
		axi_ip_demo_rvalid	: out std_logic;
		axi_ip_demo_rready	: in std_logic
	);
end axi_ip_demo_v1_0;

architecture arch_imp of axi_ip_demo_v1_0 is
    signal datain0, datain1, datain2, datain3, dataout0, dataout1, dataout2, dataout3 : std_logic_vector(31 downto 0);
    signal popc_in : std_logic_vector(31 downto 0);
    signal popc_out : std_logic_vector(31 downto 0);
    signal popc_ready, popc_enable, popc_clr : std_logic;
	-- component declaration
	component pop_count is
	   Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
	           clear : in std_logic;
	           clk : in std_logic;
               --ready : out std_logic;
               ones : out  STD_LOGIC_VECTOR (31 downto 0));
       end component pop_count;
	
	component axi_ip_demo_v1_0_axi_ip_demo is
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
		
		datain0, datain1, datain2, datain3 : in std_logic_vector(31 downto 0);
		--lraddr, lwaddr : out std_logic_vector(31 downto 0);
        dataout0, dataout1, dataout2, dataout3 : out std_logic_vector(31 downto 0)
		);
	end component axi_ip_demo_v1_0_axi_ip_demo;
    
begin
    --popc_in <= 
    popc_clr <= datain0(0);
    --popc_enable <= datain1(0);
    popc_in <= datain1;
    
    dataout0 <= popc_out;
    
    
    p_count : pop_count 
        port map(
            A => popc_in,
            clear => popc_clr,
            --ready => popc_ready,
            clk => axi_ip_demo_aclk,            
            ones => popc_out
        );
-- Instantiation of Axi Bus Interface axi_ip_demo
axi_ip_demo_v1_0_axi_ip_demo_inst : axi_ip_demo_v1_0_axi_ip_demo
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_axi_ip_demo_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_axi_ip_demo_ADDR_WIDTH
	)
	port map (
		S_AXI_ACLK	=> axi_ip_demo_aclk,
		S_AXI_ARESETN	=> axi_ip_demo_aresetn,
		S_AXI_AWADDR	=> axi_ip_demo_awaddr,
		S_AXI_AWPROT	=> axi_ip_demo_awprot,
		S_AXI_AWVALID	=> axi_ip_demo_awvalid,
		S_AXI_AWREADY	=> axi_ip_demo_awready,
		S_AXI_WDATA	=> axi_ip_demo_wdata,
		S_AXI_WSTRB	=> axi_ip_demo_wstrb,
		S_AXI_WVALID	=> axi_ip_demo_wvalid,
		S_AXI_WREADY	=> axi_ip_demo_wready,
		S_AXI_BRESP	=> axi_ip_demo_bresp,
		S_AXI_BVALID	=> axi_ip_demo_bvalid,
		S_AXI_BREADY	=> axi_ip_demo_bready,
		S_AXI_ARADDR	=> axi_ip_demo_araddr,
		S_AXI_ARPROT	=> axi_ip_demo_arprot,
		S_AXI_ARVALID	=> axi_ip_demo_arvalid,
		S_AXI_ARREADY	=> axi_ip_demo_arready,
		S_AXI_RDATA	=> axi_ip_demo_rdata,
		S_AXI_RRESP	=> axi_ip_demo_rresp,
		S_AXI_RVALID	=> axi_ip_demo_rvalid,
		S_AXI_RREADY	=> axi_ip_demo_rready,
		
		datain0 => datain0,
		datain1 => datain1,
		datain2 => datain2,
		datain3 => datain3,
        
        dataout0 => dataout0,
        dataout1 => dataout1,
        dataout2 => dataout2,
        dataout3 => dataout3
	);

        datain0 <= dataout0;
        datain1 <= dataout1;
        datain2 <= dataout2;
        datain3 <= dataout3;
        
	-- Add user logic here

	-- User logic ends

end arch_imp;
