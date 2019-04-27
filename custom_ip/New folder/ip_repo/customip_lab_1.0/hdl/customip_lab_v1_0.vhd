library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity customip_lab_v1_0 is
	generic (
		-- Users to add parameters here
        bit_width : integer := 16;
        output_width : integer := 16;
        io_ram_size : integer := 55;
        weight_ram_size : integer := 1652;
        output_ram_size : integer := 10;
        io_addr_size : integer := 6;
        output_addr_size : integer := 4;
        buffer_addr_size : integer := 4;
        weight_addr_size : integer := 11;
        buffer_size : integer := 16;
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
        Generic ( bit_width : integer := 16;
                  output_width : integer := 16);
        Port ( input : in STD_LOGIC_VECTOR (bit_width-1 downto 0);
               weight : in STD_LOGIC_VECTOR (bit_width-1 downto 0);
               bits : in STD_LOGIC_VECTOR (bit_width-1 downto 0);
               bias : in integer;
               enable : in STD_LOGIC;
               reset : in STD_LOGIC;
               clk : in STD_LOGIC;
               output : out STD_LOGIC_VECTOR(output_width-1 DOWNTO 0));
    end component;
    
    component weight_RAM is
        generic(
            weight_ram_size : integer := 1652;
            weight_addr_size : integer := 11;
            bit_width : integer := 16);
        port(
            clk : in std_logic;
            en : in std_logic;
            we : in std_logic;
            rst : in std_logic;
            addr : in std_logic_vector(weight_addr_size-1 downto 0);
            di : in std_logic_vector(bit_width-1 downto 0);
            do : out std_logic_vector(bit_width-1 downto 0)
        );
    end component;
    
    component IO_RAM is
        generic(
            io_ram_size : integer := 55;
            io_addr_size : integer := 6;
            bit_width : integer := 16);
        port(
            clk : in std_logic;
            en : in std_logic;
            we : in std_logic;
            rst : in std_logic;
            i_addr : in std_logic_vector(io_addr_size-1 downto 0);
            o_addr : in std_logic_vector(io_addr_size-1 downto 0);
            di : in std_logic_vector(bit_width-1 downto 0);
            do : out std_logic_vector(bit_width-1 downto 0)
        );
    end component;
    
    component output_RAM is
            generic(
                output_ram_size : integer := 10;
                output_addr_size : integer := 4;
                output_width : integer := 16);
            port(
                clk : in std_logic;
                en : in std_logic;
                we : in std_logic;
                rst : in std_logic;
                addr : in std_logic_vector(output_addr_size-1 downto 0);
                di : in std_logic_vector(output_width-1 downto 0);
                do : out std_logic_vector(output_width-1 downto 0)
            );
        end component;
        
    component binarised_buffer is
            generic(
                buffer_size : integer := 16;
                buffer_addr_size : integer := 4);
            Port ( clk : in STD_LOGIC;
               addr : in std_logic_vector(buffer_addr_size-1 downto 0);
               sign : in std_logic;
               dataout : out STD_LOGIC_vector(buffer_size-1 downto 0));
            end component;
    
    component control is
            generic (
                bit_width : integer := 16;
                output_width : integer := 16;
                io_ram_size : integer := 55;
                weight_ram_size : integer := 1652;
                output_ram_size : integer := 10;
                io_addr_size : integer := 6;
                output_addr_size : integer := 4;
                buffer_addr_size : integer := 4;
                weight_addr_size : integer := 11;
                buffer_size : integer := 16);
            port ( 
                clk : in STD_LOGIC;
                reset : in STD_LOGIC;
                AXI_valid : in STD_LOGIC;
                AXI_ready : out STD_LOGIC;
                weight_RAM_enable : out STD_LOGIC;
                weight_RAM_w_enable : out STD_LOGIC;
                weight_RAM_rst : out STD_LOGIC;
                weight_RAM_addr : out STD_LOGIC_VECTOR(weight_addr_size-1 downto 0);
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
                forward_output : out STD_LOGIC);
            end component;

	
    signal datain0, datain1, datain2, datain3       : std_logic_vector(31 downto 0) := (OTHERS => '0');
    signal dataout0, dataout1, dataout2, dataout3   : std_logic_vector(31 downto 0) := (OTHERS => '0');
    
    --Signals for data input multiplexer for IO_RAM
    signal bb_dataout : std_logic_vector(bit_width-1 downto 0) := (OTHERS => '0');
    signal IO_RAM_datain : std_logic_vector(bit_width-1 downto 0) := (OTHERS => '0');
    signal load_input_en : std_logic := '0';
    
    --IO_RAM signals
    signal IO_RAM_addr_in : std_logic_vector(io_addr_size-1 downto 0) := (OTHERS => '0');
    signal IO_RAM_addr_out : std_logic_vector(io_addr_size-1 downto 0) := (OTHERS => '0');
    signal IO_RAM_dataout : std_logic_vector(bit_width-1 downto 0) := (OTHERS => '0');
    signal IO_RAM_enable, IO_RAM_w_enable, IO_RAM_rst :std_logic := '0';
    
    --Weight Ram Signals
    signal weight_RAM_addr : std_logic_vector(weight_addr_size-1 downto 0) := (OTHERS => '0');
    signal weight_RAM_datain : std_logic_vector(bit_width-1 downto 0) := (OTHERS => '0');
    signal weight_RAM_dataout : std_logic_vector(bit_width-1 downto 0) := (OTHERS => '0');
    signal weight_RAM_enable, weight_RAM_w_enable, weight_RAM_rst :std_logic := '0';
    
    --Output Ram Signals
    signal output_RAM_addr : std_logic_vector(output_addr_size-1 downto 0) := (OTHERS => '0');
    signal output_RAM_dataout : std_logic_vector(output_width-1 downto 0) := (OTHERS => '0');
    signal output_RAM_enable, output_RAM_w_enable, output_RAM_rst :std_logic := '0';
    
    --Vecmult unit signals
    signal vecmult_datain : std_logic_vector(bit_width-1 downto 0) := (OTHERS => '0');
    signal vecmult_dataout : std_logic_vector(output_width-1 downto 0) := (OTHERS => '0');
    signal acc_en : std_logic := '0';
    signal acc_reset : std_logic := '0';
    
    --Binarised buffer signals
    signal bb_addr : std_logic_vector(buffer_addr_size-1 downto 0) := (OTHERS => '0');
    
    --Data Load signals
    signal b_input_init : std_logic_vector(buffer_size-1 downto 0) := (OTHERS => '0');
    
    signal AXI_ready : STD_LOGIC := '0';
    
    signal forward_output : STD_LOGIC := '0';
    

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

vecmult_datain <= bb_dataout when forward_output = '1' else
                  IO_RAM_dataout;

vecmult_inst : vecmult
    generic map (
        bit_width => bit_width,
        output_width => output_width
    )
    port map (
        input => vecmult_datain,
        weight => weight_RAM_dataout,
        bits => (OTHERS => '1'),
        bias => 0,
        clk => s00_axi_aclk,
        reset =>  acc_reset,
        enable =>  acc_en,
        output => vecmult_dataout
    );
     
b_input_init <= (OTHERS => '1');

--Multiplexer for the data input of the IO RAM
IO_RAM_datain <= b_input_init when load_input_en = '1' else
                bb_dataout when load_input_en = '0';
                     
 io_ram_inst : IO_RAM
    generic map (
        io_ram_size => io_ram_size,
        io_addr_size => io_addr_size,
        bit_width => bit_width
    )
    port map (
        clk => s00_axi_aclk,
        en => IO_RAM_enable,
        we => IO_RAM_w_enable,
        rst => IO_RAM_rst,
        i_addr => IO_RAM_addr_in,
        o_addr => IO_RAM_addr_out,
        di => IO_RAM_datain,
        do => IO_RAM_dataout
    );
    
output_ram_inst : output_RAM
    generic map (
        output_ram_size => output_ram_size,
        output_addr_size => output_addr_size,
        output_width => output_width
    )
    port map (
        clk => s00_axi_aclk,
        en => output_RAM_enable,
        we => output_RAM_w_enable,
        rst => output_RAM_rst,
        addr => output_RAM_addr,
        di => vecmult_dataout,
        do => output_RAM_dataout
    );
    
weight_RAM_datain <= (OTHERS => '0') when weight_RAM_addr = std_logic_vector(to_unsigned(25, weight_addr_size)) else
                     (OTHERS => '1');

weight_ram_inst : weight_RAM
    generic map (
        weight_ram_size => weight_ram_size,
        weight_addr_size => weight_addr_size,
        bit_width => bit_width
    )
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
    generic map (
        buffer_size => buffer_size,
        buffer_addr_size => buffer_addr_size
    )
    port map(
        clk => s00_axi_aclk,
        addr => bb_addr,
        sign => vecmult_dataout(15),
        dataout => bb_dataout
    );
    
  control_module : control
    generic map (
        bit_width => bit_width,
        output_width => output_width,
        io_ram_size => io_ram_size,
        weight_ram_size => weight_ram_size,
        output_ram_size => output_ram_size,
        io_addr_size => io_addr_size,
        output_addr_size => output_addr_size,
        buffer_addr_size => buffer_addr_size,
        weight_addr_size => weight_addr_size,
        buffer_size => buffer_size
    )
    port map(
        clk => s00_axi_aclk,
        reset => '0',
        AXI_valid => '1',
        AXI_ready => AXI_ready,
        weight_RAM_enable => weight_RAM_enable,
        weight_RAM_w_enable => weight_RAM_w_enable,
        weight_RAM_rst => weight_RAM_rst,
        weight_RAM_addr => weight_RAM_addr,
        bb_addr => bb_addr,
        output_RAM_enable => output_RAM_enable,
        output_RAM_w_enable => output_RAM_w_enable,
        output_RAM_rst => output_RAM_rst,
        output_RAM_addr => output_RAM_addr,
        IO_RAM_enable => IO_RAM_enable,
        IO_RAM_w_enable => IO_RAM_w_enable,
        IO_RAM_rst => IO_RAM_rst,
        IO_RAM_addr_in => IO_RAM_addr_in,
        IO_RAM_addr_out => IO_RAM_addr_out,
        load_input_en => load_input_en,
        acc_reset => acc_reset,
        acc_en => acc_en,
        forward_output => forward_output
    );

    
    datain0 <= X"deadbeef";
    datain1 <= X"deadbead";
    datain2 <= X"beefdead";
    datain3 <= X"deafbeef";

end arch_imp;
