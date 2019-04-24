library IEEE;
   2 use IEEE.STD_LOGIC_1164.ALL;
   3 USE ieee.numeric_std.ALL;
   4 
   5 entity axi_tb is
   6 end axi_tb;
   7 
   8 architecture Behavioral of axi_tb is
   9     constant CLOCK_PERIOD   : Time := 10 ns; -- 100MHz
  10 
  11     constant AXI_DATA_WIDTH : integer := 32;
  12     constant AXI_ADDR_WIDTH : integer := 4;
  13 
  14     component lab0_ip_v1_0 is
  15         generic (
  16             -- Parameters of Axi Slave Bus Interface S00_AXI
  17             C_S00_AXI_DATA_WIDTH : integer    := 32;
  18             C_S00_AXI_ADDR_WIDTH : integer    := 4
  19         );
  20         port (
  21             -- Ports of Axi Slave Bus Interface S00_AXI
  22             s00_axi_aclk    : in  std_logic;
  23             s00_axi_aresetn : in  std_logic;
  24             s00_axi_awaddr  : in  std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
  25             s00_axi_awprot  : in  std_logic_vector(2 downto 0);
  26             s00_axi_awvalid : in  std_logic;
  27             s00_axi_awready : out std_logic;
  28             s00_axi_wdata   : in  std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
  29             s00_axi_wstrb   : in  std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
  30             s00_axi_wvalid  : in  std_logic;
  31             s00_axi_wready  : out std_logic;
  32             s00_axi_bresp   : out std_logic_vector(1 downto 0);
  33             s00_axi_bvalid  : out std_logic;
  34             s00_axi_bready  : in  std_logic;
  35             s00_axi_araddr  : in  std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
  36             s00_axi_arprot  : in  std_logic_vector(2 downto 0);
  37             s00_axi_arvalid : in  std_logic;
  38             s00_axi_arready : out std_logic;
  39             s00_axi_rdata   : out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
  40             s00_axi_rresp   : out std_logic_vector(1 downto 0);
  41             s00_axi_rvalid  : out std_logic;
  42             s00_axi_rready  : in  std_logic
  43         );
  44     end component lab0_ip_v1_0;
  45 
  46     signal s00_axi_aclk    : std_logic;
  47     signal s00_axi_aresetn : std_logic;
  48     signal s00_axi_awaddr  : std_logic_vector(31 downto 0);
  49     signal s00_axi_awvalid : std_logic;
  50     signal s00_axi_awready : std_logic;
  51     signal s00_axi_wdata   : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
  52     signal s00_axi_wvalid  : std_logic;
  53     signal s00_axi_wready  : std_logic;
  54     signal s00_axi_bresp   : std_logic_vector(1 downto 0);
  55     signal s00_axi_bvalid  : std_logic;
  56     signal s00_axi_bready  : std_logic;
  57     signal s00_axi_araddr  : std_logic_vector(31 downto 0);
  58     signal s00_axi_arvalid : std_logic;
  59     signal s00_axi_arready : std_logic;
  60     signal s00_axi_rdata   : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
  61     signal s00_axi_rresp   : std_logic_vector(1 downto 0);
  62     signal s00_axi_rvalid  : std_logic;
  63     signal s00_axi_rready  : std_logic;
  64 
  65 begin
  66     -- Instantiate our AXI peripheral
  67     axi0: component lab0_ip_v1_0
  68         generic map (
  69             -- Parameters of Axi Slave Bus Interface S00_AXI
  70             C_S00_AXI_DATA_WIDTH => AXI_DATA_WIDTH,
  71             C_S00_AXI_ADDR_WIDTH => AXI_ADDR_WIDTH
  72         ),
  73 
  74         port map (
  75             s00_axi_aclk    => s00_axi_aclk,
  76             s00_axi_aresetn => s00_axi_aresetn,
  77             s00_axi_awaddr  => s00_axi_awaddr(AXI_ADDR_WIDTH-1 downto 0),
  78             s00_axi_awprot  => "001",
  79             s00_axi_awvalid => s00_axi_awvalid ,
  80             s00_axi_awready => s00_axi_awready,
  81             s00_axi_wdata   => s00_axi_wdata,
  82             s00_axi_wstrb   => "1111",
  83             s00_axi_wvalid  => s00_axi_wvalid,
  84             s00_axi_wready  => s00_axi_wready,
  85             s00_axi_bresp   => s00_axi_bresp,
  86             s00_axi_bvalid  => s00_axi_bvalid,
  87             s00_axi_bready  => s00_axi_bready,
  88             s00_axi_araddr  => s00_axi_araddr(AXI_ADDR_WIDTH-1 downto 0),
  89             s00_axi_arprot  => "001",
  90             s00_axi_arvalid => s00_axi_arvalid,
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
 199             variable real_data : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
 200         begin
 201             axi_readl(a, real_data);
 202             ASSERT(real_data = d)  REPORT "AXI data error: " & s SEVERITY error;
 203         end procedure;
 204 
 205         -- Tests that we can read the values that we write
 206         procedure test_memory is
 207         begin
 208             -- Write phase
 209             -- axi_writel(<address>, <data>);
 210             axi_writel(X"00000000", X"11111111");
 211             axi_writel(X"00000004", X"22222222");
 212             axi_writel(X"00000008", X"33333333");
 213             axi_writel(X"0000000C", X"44444444");
 214             -- Read phase
 215             -- axi_readlc(<address>, <expected data>, <error message>);
 216             axi_readlc(X"00000000", X"11111111", "Reading register 0");
 217             axi_readlc(X"00000004", X"22222222", "Reading register 1");
 218             axi_readlc(X"00000008", X"33333333", "Reading register 2");
 219             axi_readlc(X"0000000C", X"44444444", "Reading register 3");
 220         end procedure;
 221         
 222         -- Demonstrates a failing test 
 223         procedure test_failure is
 224         begin
 225             -- axi_writel(X"00000000", X"deadbeef");
 226             axi_readlc(X"00000000", X"deadbeef", "Ignore this error; it is a demonstration of failure");
 227         end procedure;
 228         
 229         
 230     begin
 231         axi_init;
 232         REPORT "############# AXI test started ##############";
 233         
 234         -- Start tests
 235         test_memory;
 236         test_failure;
 237 
 238         -- All tests complete
 239         REPORT "############# AXI test complete ##############";
 240         axi_deinit;
 241         wait;
 242     end process TEST;
 243 
 244 end Behavioral;