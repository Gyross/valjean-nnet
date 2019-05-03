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
    
begin
    -- Instantiate our AXI peripheral
    axi0: component customip_lab_v1_0
        generic map (
            -- Parameters of Axi Slave Bus Interface S00_AXI
            C_S00_AXI_DATA_WIDTH => AXI_DATA_WIDTH,
            C_S00_AXI_ADDR_WIDTH => AXI_ADDR_WIDTH
        )

        port map (
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
            s00_axi_awaddr   <= a;
            s00_axi_awvalid  <= '1';
            --while (s00_axi_awready = '0' or s00_axi_wready = '0') loop
                axi_clock(1);
            --end loop;
            ASSERT(s00_axi_awready = '1')  REPORT "AXI protocol error awready not 1" SEVERITY error;
            ASSERT(s00_axi_wready = '1')   REPORT "AXI protocol error wready not 1" SEVERITY error;
--            s00_axi_awvalid  <= '0';
--            s00_axi_wvalid   <= '0';
--            s00_axi_awaddr   <= X"deadbeef";
--            axi_clock(1);
        end procedure;
        
        -- Read from the AXI bus at address 'a' and return the result
        procedure axi_readl(constant a : in  std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
                            variable d : out std_logic_vector(AXI_DATA_WIDTH-1 downto 0)) is
        begin            
            s00_axi_araddr   <= a;
            s00_axi_arvalid  <= '1';
            while s00_axi_arready = '0' loop
                axi_clock(1);                         -- CLK 1
            end loop;
            ASSERT(s00_axi_arready = '1') REPORT "AXI protocol error arready should be set" SEVERITY error;
            s00_axi_araddr   <= X"deadbeef";            
            s00_axi_arvalid  <= '0';
            axi_clock(1);                         -- CLK 3
            ASSERT(s00_axi_arready = '0') REPORT "AXI protocol error arready should be clear" SEVERITY error;
            while (s00_axi_rvalid = '0') loop
                axi_clock(1);
            end loop;      
            ASSERT(s00_axi_rvalid = '1') REPORT "AXI protocol error rvalid should be set"   SEVERITY error;   
            d := s00_axi_rdata;
            axi_clock(1);                         -- CLK 3
            ASSERT(s00_axi_rvalid = '0')  REPORT "AXI protocol error rvalid should be clear" SEVERITY error;

        end procedure;
        
        -- Read from the AXI bus at address 'a' and return the result
        procedure axi_readlnonblock(constant a : in  std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
                            variable d : out std_logic_vector(AXI_DATA_WIDTH-1 downto 0)) is
        begin            
            s00_axi_araddr   <= a;
            s00_axi_arvalid  <= '1';
            while s00_axi_arready = '0' loop
                axi_clock(1);                         -- CLK 1
            end loop;
            ASSERT(s00_axi_arready = '1') REPORT "AXI protocol error arready should be set" SEVERITY error;
            s00_axi_araddr   <= X"deadbeef";            
            s00_axi_arvalid  <= '0';
            axi_clock(1);                         -- CLK 3
            ASSERT(s00_axi_arready = '0') REPORT "AXI protocol error arready should be clear" SEVERITY error;
            --while (s00_axi_rvalid = '0') loop
            --    axi_clock(1);
            --end loop;      
            ASSERT(s00_axi_rvalid = '1') REPORT "AXI protocol error rvalid should be set"   SEVERITY error;   
            d := s00_axi_rdata;
            axi_clock(1);                         -- CLK 3
            ASSERT(s00_axi_rvalid = '0')  REPORT "AXI protocol error rvalid should be clear" SEVERITY error;

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
        
        -- Read from address 'a' over the AXI bus and assert that the data read is 'd' non-blocking
        procedure axi_readld(constant a : in std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
                             constant d : in std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
                             constant s : string) is
            variable real_data : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
        begin
            axi_readlnonblock(a, real_data);
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
            axi_writel(X"00000000", X"deadbeef");
            axi_readlc(X"00000000", X"deadbeef", "Ignore this error; it is a demonstration of failure");
        end procedure;
        
        procedure test_run is
        begin
        axi_clock(1);
            for i in 0 to 299 loop
                axi_writel(X"00000000", X"abcddcba");
            end loop;
            for i in 300 to 599 loop
                axi_writel(X"00000000", X"abcd0131");
            end loop;
            for i in 600 to 999 loop
                axi_writel(X"00000000", X"abcd9999");
            end loop;
            for i in 1000 to 1249 loop
                axi_writel(X"00000000", X"abcdffff");
            end loop;
            for i in 1250 to 1651 loop
                axi_writel(X"00000000", X"39571398");
            end loop;
            for i in 0 to 23 loop
                axi_writel(X"00000001", X"a462c040");
            end loop;
            axi_writel(X"00000001", X"00009352");
            axi_writel(X"00000001", X"0000b412");
            axi_writel(X"00000001", X"0000058c");
            for i in 27 to 48 loop
                axi_writel(X"00000001", X"0000aaff");
            end loop;
            axi_readld(X"00000002", X"00000000", "ignore error");
            axi_clock(200);
            axi_readlc(X"00000002", X"00000000", "ignore error");
            axi_readlc(X"00000002", X"00000000", "ignore error");
            axi_readlc(X"00000002", X"00000000", "ignore error");
            axi_readlc(X"00000002", X"00000000", "ignore error");
            axi_readlc(X"00000002", X"00000000", "ignore error");
            axi_readlc(X"00000002", X"00000000", "ignore error");
            axi_readlc(X"00000002", X"00000000", "ignore error");
            axi_readlc(X"00000002", X"00000000", "ignore error");
            axi_readlc(X"00000002", X"00000000", "ignore error");
            axi_readlc(X"00000002", X"00000000", "ignore error");
        end procedure;
        
        
    begin
        axi_init;
        REPORT "############# AXI test started ##############";
        
        -- Start tests
        --test_memory;
        --test_failure;
        test_run;

        -- All tests complete
        REPORT "############# AXI test complete ##############";
        axi_deinit;
        wait;
    end process TEST;

end Behavioral;