library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

entity axi_tb is
end axi_tb;

architecture Behavioral of axi_tb is
    constant CLOCK_PERIOD   : Time := 10 ns; -- 100MHz
    constant AXI_DATA_WIDTH : integer := 32;
    constant AXI_ADDR_WIDTH : integer := 4; 
    component customip_lab_v1_0 is
        generic (
            -- Parameters of Axi Slave Bus Interface S00_AXI
            C_S00_AXI_DATA_WIDTH : integer    := 32;
            C_S00_AXI_ADDR_WIDTH : integer    := 4
        );
        port (
            vecmult_input : out std_logic_vector(15 downto 0);
            vecmult_weight : out std_logic_vector(15 downto 0);
            vecmult_output : out std_logic_vector(15 downto 0);
            input_addr : out std_logic_vector(10 downto 0);
            weight_addr : out std_logic_vector(10 downto 0);
            buffer_out : out std_logic_vector(15 downto 0);
            buffer_addr : out std_logic_vector(3 downto 0);
            output_addr : out std_logic_vector(10 downto 0);
            output_written : out std_logic_vector(15 downto 0);
            load_input_en_port : out std_logic := '0';
            weight_RAM_datain_port : out std_logic_vector(15 downto 0) := (OTHERS => '0');
            acc_en_port : out std_logic := '0';
            acc_reset_port : out std_logic := '0';
            AXI_ready_port : out std_logic := '0';
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
    end component;

    signal s00_axi_aclk    : std_logic;
    signal s00_axi_aresetn : std_logic;
    signal s00_axi_awaddr  : std_logic_vector(31 downto 0);
    signal s00_axi_awvalid : std_logic;
    signal s00_axi_awready : std_logic;
    signal s00_axi_wdata   : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
    signal s00_axi_wvalid  : std_logic;
    signal s00_axi_wready  : std_logic;
    signal s00_axi_bresp   : std_logic_vector(1 downto 0);
    signal s00_axi_bvalid  : std_logic;
    signal s00_axi_bready  : std_logic;
    signal s00_axi_araddr  : std_logic_vector(31 downto 0);
    signal s00_axi_arvalid : std_logic;
    signal s00_axi_arready : std_logic;
    signal s00_axi_rdata   : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
    signal s00_axi_rresp   : std_logic_vector(1 downto 0);
    signal s00_axi_rvalid  : std_logic;
    signal s00_axi_rready  : std_logic;
    
    signal vecmult_input : std_logic_vector(15 downto 0) := (OTHERS => '0');
    signal vecmult_weight : std_logic_vector(15 downto 0) := (OTHERS => '0');
    signal vecmult_output :  std_logic_vector(15 downto 0) := (OTHERS => '0');
    signal input_addr :  std_logic_vector(10 downto 0) := (OTHERS => '0');
    signal weight_addr :  std_logic_vector(10 downto 0) := (OTHERS => '0');
    signal buffer_out :  std_logic_vector(15 downto 0) := (OTHERS => '0');
    signal buffer_addr :  std_logic_vector(3 downto 0) := (OTHERS => '0');
    signal output_addr : std_logic_vector(10 downto 0) := (OTHERS => '0');
    signal output_written :  std_logic_vector(15 downto 0) := (OTHERS => '0');
    signal load_input_en_port :  std_logic := '0';
    signal weight_RAM_datain_port :  std_logic_vector(15 downto 0) := (OTHERS => '0');
    signal acc_en_port :  std_logic := '0';
    signal acc_reset_port :  std_logic := '0';
    signal AXI_ready_port :  std_logic := '0';

begin
    -- Instantiate our AXI peripheral
    axi0: component customip_lab_v1_0
        generic map (
            -- Parameters of Axi Slave Bus Interface S00_AXI
            C_S00_AXI_DATA_WIDTH => AXI_DATA_WIDTH,
            C_S00_AXI_ADDR_WIDTH => AXI_ADDR_WIDTH
        )

        port map (
            vecmult_input => vecmult_input,
            vecmult_weight => vecmult_weight,
            vecmult_output => vecmult_output ,
            input_addr => input_addr,
            weight_addr => weight_addr,
            buffer_out => buffer_out ,
            buffer_addr => buffer_addr ,
            output_addr => output_addr ,
            output_written => output_written,
            load_input_en_port => load_input_en_port,
            weight_RAM_datain_port => weight_RAM_datain_port,
            acc_en_port => acc_en_port,
            acc_reset_port => acc_reset_port ,
            AXI_ready_port => AXI_ready_port,
            s00_axi_aclk    => s00_axi_aclk,
            s00_axi_aresetn => s00_axi_aresetn,
            s00_axi_awaddr  => s00_axi_awaddr(AXI_ADDR_WIDTH-1 downto 0),
            s00_axi_awprot  => "001",
            s00_axi_awvalid => s00_axi_awvalid ,
            s00_axi_awready => s00_axi_awready,
            s00_axi_wdata   => s00_axi_wdata,
            s00_axi_wstrb   => "1111",
            s00_axi_wvalid  => s00_axi_wvalid,
            s00_axi_wready  => s00_axi_wready,
            s00_axi_bresp   => s00_axi_bresp,
            s00_axi_bvalid  => s00_axi_bvalid,
            s00_axi_bready  => s00_axi_bready,
            s00_axi_araddr  => s00_axi_araddr(AXI_ADDR_WIDTH-1 downto 0),
            s00_axi_arprot  => "001",
            s00_axi_arvalid => s00_axi_arvalid,
            s00_axi_arready => s00_axi_arready,
            s00_axi_rdata   => s00_axi_rdata,
            s00_axi_rresp   => s00_axi_rresp,
            s00_axi_rvalid  => s00_axi_rvalid,
            s00_axi_rready  => s00_axi_rready
        );

    -- Create a process for the clock signal
    AXI_CLK: process
    begin
        s00_axi_aclk <= '0';
        wait for CLOCK_PERIOD / 2;
        s00_axi_aclk <= '1';
        wait for CLOCK_PERIOD / 2;
    end process AXI_CLK;


    TEST: process
        -- Waits for 'cycles' number of clock cycles
        procedure axi_clock(constant cycles: natural) is
        begin
            for i in 1 to cycles loop
                wait until s00_axi_aclk = '0';
                wait until s00_axi_aclk = '1';        
            end loop;
        end procedure;

        -- Initialise the AXI slave bus
        procedure axi_init is
        begin
            -- Hold in reset state
            s00_axi_aresetn <= '0';
            axi_clock(1); -- Reset is synchronous
            -- Initial key AXI signals
            s00_axi_awaddr  <= X"deadbeef";
            s00_axi_araddr  <= X"deadbeef";
            s00_axi_wdata   <= X"deadbeef";
            s00_axi_wvalid  <= '0';
            s00_axi_awvalid <= '0';
            s00_axi_arvalid <= '0';
            s00_axi_bready  <= '1';
            s00_axi_rready  <= '1';
            -- Release the reset
            s00_axi_aresetn <= '1';
            axi_clock(1); -- Reset is synchronous
        end procedure;

        -- Deinitialise the AXI slave bus
        procedure axi_deinit is
        begin
            -- Hold in reset state
            s00_axi_aresetn <= '0';
            axi_clock(1); -- Reset is synchronous
        end procedure;

        -- Write 'd' to the axi bus at address 'a'
        procedure axi_writel(constant a : in std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
                             constant d : in std_logic_vector(AXI_DATA_WIDTH-1 downto 0)) is
        begin
            s00_axi_wdata    <= d;
            s00_axi_wvalid   <= '1';
            axi_clock(1);                       -- CLK 1
            axi_clock(1);                       -- CLK 2
            s00_axi_awaddr   <= a;
            s00_axi_awvalid  <= '1';
            axi_clock(1);                       -- CLK 3
            axi_clock(1);                       -- CLK 4
            ASSERT(s00_axi_awready = '1')  REPORT "AXI protocol error awready not 1" SEVERITY error;
            ASSERT(s00_axi_wready = '1')   REPORT "AXI protocol error wready not 1" SEVERITY error;
            s00_axi_awvalid  <= '0';
            s00_axi_wvalid   <= '0';
            s00_axi_awaddr   <= X"deadbeef";
            axi_clock(1);                       -- CLK 5
            ASSERT(s00_axi_awready = '0')  REPORT "AXI protocol error awready not 0" SEVERITY error;
            ASSERT(s00_axi_wready = '0')   REPORT "AXI protocol error wready not 0" SEVERITY error;            ASSERT(s00_axi_bvalid = '1')   REPORT "AXI protocol error bvalid not 1" SEVERITY error;
            s00_axi_bready   <= '0';
            axi_clock(1);                       -- CLK 6
            ASSERT(s00_axi_bvalid = '0')   REPORT "AXI protocol error bvalid not 0" SEVERITY error;
            s00_axi_bready   <= '1';
            axi_clock(11);                      -- Relax
        end procedure;
        
        -- Read from the AXI bus at address 'a' and return the result
        procedure axi_readl(constant a : in  std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
                            variable d : out std_logic_vector(AXI_DATA_WIDTH-1 downto 0)) is
        begin            
            s00_axi_araddr   <= a;
            s00_axi_arvalid  <= '1';
            axi_clock(1);                         -- CLK 1
            axi_clock(1);                         -- CLK 2
            ASSERT(s00_axi_arready = '1') REPORT "AXI protocol error arready should be set" SEVERITY error;
            s00_axi_araddr   <= X"deadbeef";            
            s00_axi_arvalid  <= '0';
            axi_clock(1);                         -- CLK 3
            ASSERT(s00_axi_arready = '0') REPORT "AXI protocol error arready should be clear" SEVERITY error;
            ASSERT(s00_axi_rvalid = '1')  REPORT "AXI protocol error rvalid should be set" SEVERITY error;
            d := s00_axi_rdata;
            axi_clock(1);                         -- CLK 3
            ASSERT(s00_axi_rvalid = '0')  REPORT "AXI protocol error rvalid should be clear" SEVERITY error;
            -- At some point we should have got the read value back...
            axi_clock(10);                        -- Relax
        end procedure;

        -- Read from address 'a' over the AXI bus and assert that the data read is 'd'
        procedure axi_readlc(constant a : in std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
                             constant d : in std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
                             constant s : string) is
            variable real_data : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
        begin
            axi_readl(a, real_data);
            ASSERT(real_data = d)  REPORT "AXI data error: " & s SEVERITY error;
        end procedure;

        -- Tests that we can read the values that we write
        procedure test_memory is
        begin
            -- Write phase
            -- axi_writel(<address>, <data>);
            axi_writel(X"00000000", X"11111111");
            axi_writel(X"00000004", X"22222222");
            axi_writel(X"00000008", X"33333333");
            axi_writel(X"0000000C", X"44444444");
            -- Read phase
            -- axi_readlc(<address>, <expected data>, <error message>);
            axi_readlc(X"00000000", X"11111111", "Reading register 0");
            axi_readlc(X"00000004", X"22222222", "Reading register 1");
            axi_readlc(X"00000008", X"33333333", "Reading register 2");
            axi_readlc(X"0000000C", X"44444444", "Reading register 3");
        end procedure;
        
        -- Demonstrates a failing test 
        procedure test_failure is
        begin
            -- axi_writel(X"00000000", X"deadbeef");
            axi_readlc(X"00000000", X"deadbeef", "Ignore this error; it is a demonstration of failure");
        end procedure;
        
        procedure test_run is
        begin
            axi_writel(X"00000000", X"abcddcba");
            axi_clock(1);
            axi_clock(1);
            axi_clock(1);
            axi_clock(1);
            axi_clock(1);
            axi_clock(1);
            axi_clock(1);
            axi_clock(1);
            axi_clock(1);
            axi_clock(1);
            axi_clock(1);
            axi_clock(1);
            axi_clock(1);
            axi_clock(1);
        end procedure;
        
        
    begin
        axi_init;
        REPORT "############# AXI test started ##############";
        
        -- Start tests
        test_memory;
        test_failure;
        test_run;

        -- All tests complete
        REPORT "############# AXI test complete ##############";
        axi_deinit;
        wait;
    end process TEST;

end Behavioral;