library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

entity axi_tb is
end axi_tb;

architecture Behavioral of axi_tb is
    constant CLOCK_PERIOD   : Time := 10 ns; -- 100MHz
    constant AXI_DATA_WIDTH : integer := 32;
    constant AXI_ADDR_WIDTH : integer := 4; 
    component lab0_ip_v1_0 is
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
    end component lab0_ip_v1_0;

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
    axi0: component lab0_ip_v1_0
        generic map (
            -- Parameters of Axi Slave Bus Interface S00_AXI
            C_S00_AXI_DATA_WIDTH => AXI_DATA_WIDTH,
            C_S00_AXI_ADDR_WIDTH => AXI_ADDR_WIDTH
        ),

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
  91             s00_axi_arready => s00_axi_arready,
  92             s00_axi_rdata   => s00_axi_rdata,
  93             s00_axi_rresp   => s00_axi_rresp,
  94             s00_axi_rvalid  => s00_axi_rvalid,
  95             s00_axi_rready  => s00_axi_rready
  96         );
  97 
  98     -- Create a process for the clock signal
  99     AXI_CLK: process
 100     begin
 101         s00_axi_aclk <= '0';
 102         wait for CLOCK_PERIOD / 2;
 103         s00_axi_aclk <= '1';
 104         wait for CLOCK_PERIOD / 2;
 105     end process AXI_CLK;
 106 
 107 
 108     TEST: process
 109         -- Waits for 'cycles' number of clock cycles
 110         procedure axi_clock(constant cycles: natural) is
 111         begin
 112             for i in 1 to cycles loop
 113                 wait until s00_axi_aclk = '0';
 114                 wait until s00_axi_aclk = '1';        
 115             end loop;
 116         end procedure;
 117 
 118         -- Initialise the AXI slave bus
 119         procedure axi_init is
 120         begin
 121             -- Hold in reset state
 122             s00_axi_aresetn <= '0';
 123             axi_clock(1); -- Reset is synchronous
 124             -- Initial key AXI signals
 125             s00_axi_awaddr  <= X"deadbeef";
 126             s00_axi_araddr  <= X"deadbeef";
 127             s00_axi_wdata   <= X"deadbeef";
 128             s00_axi_wvalid  <= '0';
 129             s00_axi_awvalid <= '0';
 130             s00_axi_arvalid <= '0';
 131             s00_axi_bready  <= '1';
 132             s00_axi_rready  <= '1';
 133             -- Release the reset
 134             s00_axi_aresetn <= '1';
 135             axi_clock(1); -- Reset is synchronous
 136         end procedure;
 137 
 138         -- Deinitialise the AXI slave bus
 139         procedure axi_deinit is
 140         begin
 141             -- Hold in reset state
 142             s00_axi_aresetn <= '0';
 143             axi_clock(1); -- Reset is synchronous
 144         end procedure;
 145 
 146         -- Write 'd' to the axi bus at address 'a'
 147         procedure axi_writel(constant a : in std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
 148                              constant d : in std_logic_vector(AXI_DATA_WIDTH-1 downto 0)) is
 149         begin
 150             s00_axi_wdata    <= d;
 151             s00_axi_wvalid   <= '1';
 152             axi_clock(1);                       -- CLK 1
 153             axi_clock(1);                       -- CLK 2
 154             s00_axi_awaddr   <= a;
 155             s00_axi_awvalid  <= '1';
 156             axi_clock(1);                       -- CLK 3
 157             axi_clock(1);                       -- CLK 4
 158             ASSERT(s00_axi_awready = '1')  REPORT "AXI protocol error awready not 1" SEVERITY error;
 159             ASSERT(s00_axi_wready = '1')   REPORT "AXI protocol error wready not 1" SEVERITY error;
 160             s00_axi_awvalid  <= '0';
 161             s00_axi_wvalid   <= '0';
 162             s00_axi_awaddr   <= X"deadbeef";
 163             axi_clock(1);                       -- CLK 5
 164             ASSERT(s00_axi_awready = '0')  REPORT "AXI protocol error awready not 0" SEVERITY error;
 165             ASSERT(s00_axi_wready = '0')   REPORT "AXI protocol error wready not 0" SEVERITY error;
 166             ASSERT(s00_axi_bvalid = '1')   REPORT "AXI protocol error bvalid not 1" SEVERITY error;
 167             s00_axi_bready   <= '0';
 168             axi_clock(1);                       -- CLK 6
 169             ASSERT(s00_axi_bvalid = '0')   REPORT "AXI protocol error bvalid not 0" SEVERITY error;
 170             s00_axi_bready   <= '1';
 171             axi_clock(11);                      -- Relax
 172         end procedure;
 173         
 174         -- Read from the AXI bus at address 'a' and return the result
 175         procedure axi_readl(constant a : in  std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
 176                             variable d : out std_logic_vector(AXI_DATA_WIDTH-1 downto 0)) is
 177         begin            
 178             s00_axi_araddr   <= a;
 179             s00_axi_arvalid  <= '1';
 180             axi_clock(1);                         -- CLK 1
 181             axi_clock(1);                         -- CLK 2
 182             ASSERT(s00_axi_arready = '1') REPORT "AXI protocol error arready should be set" SEVERITY error;
 183             s00_axi_araddr   <= X"deadbeef";            
 184             s00_axi_arvalid  <= '0';
 185             axi_clock(1);                         -- CLK 3
 186             ASSERT(s00_axi_arready = '0') REPORT "AXI protocol error arready should be clear" SEVERITY error;
 187             ASSERT(s00_axi_rvalid = '1')  REPORT "AXI protocol error rvalid should be set" SEVERITY error;
 188             d := s00_axi_rdata;
 189             axi_clock(1);                         -- CLK 3
 190             ASSERT(s00_axi_rvalid = '0')  REPORT "AXI protocol error rvalid should be clear" SEVERITY error;
 191             -- At some point we should have got the read value back...
 192             axi_clock(10);                        -- Relax
 193         end procedure;
 194 
 195         -- Read from address 'a' over the AXI bus and assert that the data read is 'd'
 196         procedure axi_readlc(constant a : in std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
 197                              constant d : in std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
 198                              constant s : string) is
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
        
        
    begin
        axi_init;
        REPORT "############# AXI test started ##############";
        
        -- Start tests
        test_memory;
        test_failure;

        -- All tests complete
        REPORT "############# AXI test complete ##############";
        axi_deinit;
        wait;
    end process TEST;

end Behavioral;