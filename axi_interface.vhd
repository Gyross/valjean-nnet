library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work. data_types.all;

entity axi_interface is
    generic (
        -- Width of S_AXI data bus
        C_S_AXI_DATA_WIDTH : integer := 32;
        -- Width of S_AXI address bus
        C_S_AXI_ADDR_WIDTH : integer := 4
    );
    port (
        -- Global Clock Signal
        S_AXI_ACLK    : in std_logic;
        -- Global Reset Signal. This Signal is Active LOW
        S_AXI_ARESETN : in std_logic;
        -- Write address (issued by master, acceped by Slave)
        S_AXI_AWADDR  : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        -- Write channel Protection type. This signal indicates the
        -- privilege and security level of the transaction, and whether
        -- the transaction is a data access or an instruction access.
        S_AXI_AWPROT  : in std_logic_vector(2 downto 0);
        -- Write address valid. This signal indicates that the master signaling
        -- valid write address and control information.
        S_AXI_AWVALID : in std_logic;
        -- Write address ready. This signal indicates that the slave is ready
        -- to accept an address and associated control signals.
        S_AXI_AWREADY : out std_logic;
        -- Write data (issued by master, acceped by Slave) 
        S_AXI_WDATA   : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        -- Write strobes. This signal indicates which byte lanes hold
        -- valid data. There is one write strobe bit for each eight
        -- bits of the write data bus.    
        S_AXI_WSTRB   : in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
        -- Write valid. This signal indicates that valid write
        -- data and strobes are available.
        S_AXI_WVALID  : in std_logic;
        -- Write ready. This signal indicates that the slave
        -- can accept the write data.
        S_AXI_WREADY  : out std_logic;
        -- Write response. This signal indicates the status
        -- of the write transaction.
        S_AXI_BRESP   : out std_logic_vector(1 downto 0);
        -- Write response valid. This signal indicates that the channel
        -- is signaling a valid write response.
        S_AXI_BVALID  : out std_logic;
        -- Response ready. This signal indicates that the master
        -- can accept a write response.
        S_AXI_BREADY  : in std_logic;
        -- Read address (issued by master, acceped by Slave)
        S_AXI_ARADDR  : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        -- Protection type. This signal indicates the privilege
        -- and security level of the transaction, and whether the
        -- transaction is a data access or an instruction access.
        S_AXI_ARPROT  : in std_logic_vector(2 downto 0);
        -- Read address valid. This signal indicates that the channel
        -- is signaling valid read address and control information.
        S_AXI_ARVALID : in std_logic;
        -- Read address ready. This signal indicates that the slave is
        -- ready to accept an address and associated control signals.
        S_AXI_ARREADY : out std_logic;
        -- Read data (issued by slave)
        S_AXI_RDATA   : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        -- Read response. This signal indicates the status of the
        -- read transfer.
        S_AXI_RRESP   : out std_logic_vector(1 downto 0);
        -- Read valid. This signal indicates that the channel is
        -- signaling the required read data.
        S_AXI_RVALID  : out std_logic;
        -- Read ready. This signal indicates that the master can
        -- accept the read data and response information.
        S_AXI_RREADY  : in std_logic;
        
        -- WRAM ports
        wram_addr : out natural;
        wram_ram  : out natural;
        wram_data : out word;
        wram_en   : out std_logic;
        
        -- OREG ports
        oreg_addr : out natural;
        oreg_data : in  out_word;
        
        -- CTRL unit ports
        oreg_done   : in std_logic; -- alias ctrl_OV
        ctrl_state  : out AXI_state;
        bioram_data : out word;
        bioram_en   : out std_logic
    );
end axi_interface;

architecture arch_imp of axi_interface is

    -- AXI4LITE signals
    -- outputs
    signal axi_awready : std_logic;
    signal axi_wready  : std_logic;
    signal axi_bresp   : std_logic_vector(1 downto 0);
    signal axi_bvalid  : std_logic;
    signal axi_arready : std_logic;
    signal axi_rdata   : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal axi_rresp   : std_logic_vector(1 downto 0);
    signal axi_rvalid  : std_logic;

    -- inputs
    signal axi_awaddr : natural;
    signal axi_araddr : natural;

    -- Example-specific design signals
    -- local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
    -- ADDR_LSB is used for addressing 32/64 bit registers/memories
    -- ADDR_LSB = 2 for 32 bits (n downto 2)
    -- ADDR_LSB = 3 for 64 bits (n downto 3)
    constant ADDR_LSB  : integer := (C_S_AXI_DATA_WIDTH/32)+ 1;
    constant OPT_MEM_ADDR_BITS : integer := 1;

    ------------------------------------------------
    ---- Signals for user logic register space example
    --------------------------------------------------
    signal state, state_next : AXI_state;
    signal oreg_count        : natural := 0;
    signal wram_count        : natural := 0;
    signal wram_ram_count    : natural := 0;

    signal axi_write_valid : std_logic;

begin

    -- I/O Connections assignments
    S_AXI_AWREADY <= axi_awready;
    S_AXI_WREADY  <= axi_wready;
    S_AXI_BRESP   <= axi_bresp;
    S_AXI_BVALID  <= axi_bvalid;
    S_AXI_ARREADY <= axi_arready;
    S_AXI_RDATA   <= axi_rdata;
    S_AXI_RRESP   <= axi_rresp;
    S_AXI_RVALID  <= axi_rvalid;

    axi_awaddr <= to_integer(unsigned(S_AXI_AWADDR));
    axi_araddr <= to_integer(unsigned(S_AXI_ARADDR));

    axi_write_valid <= '1' when S_AXI_AWVALID = '1' and S_AXI_WVALID = '1';

    wram_ram <= wram_ram_count;

    -- Implement axi_awready generation
    -- axi_awready is asserted for one S_AXI_ACLK clock cycle when both
    -- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
    -- de-asserted when reset is low.
    process (S_AXI_ACLK)
    begin
        if rising_edge(S_AXI_ACLK) then 
            if S_AXI_ARESETN = '0' then
                axi_awready <= '0';
            else
                if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1') then
                    -- slave is ready to accept write address when
                    -- there is a valid write address and write data
                    -- on the write address and data bus. This design 
                    -- expects no outstanding transactions. 
                    axi_awready <= '1';
                elsif (S_AXI_BREADY = '1' and axi_bvalid = '1') then
                    axi_awready <= '0';
                else
                    axi_awready <= '0';
                end if;
            end if;
        end if;
    end process;

    -- Implement axi_wready generation
    -- axi_wready is asserted for one S_AXI_ACLK clock cycle when both
    -- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
    -- de-asserted when reset is low. 
    process (S_AXI_ACLK)
    begin
        if rising_edge(S_AXI_ACLK) then 
            if S_AXI_ARESETN = '0' then
                axi_wready <= '0';
            else
                if (axi_wready = '0' and S_AXI_WVALID = '1' and S_AXI_AWVALID = '1') then
                    -- slave is ready to accept write data when 
                    -- there is a valid write address and write data
                    -- on the write address and data bus. This design 
                    -- expects no outstanding transactions.           
                    axi_wready <= '1';
                else
                    axi_wready <= '0';
                end if;
            end if;
        end if;
    end process; 


    -- Implement write response logic generation
    -- The write response and response valid signals are asserted by the slave 
    -- when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
    -- This marks the acceptance of address and indicates the status of 
    -- write transaction.
    process (S_AXI_ACLK)
    begin
        if rising_edge(S_AXI_ACLK) then 
            if S_AXI_ARESETN = '0' then
                axi_bvalid  <= '0';
                axi_bresp   <= "00"; --need to work more on the responses
            else
                if (axi_awready = '1' and S_AXI_AWVALID = '1' and axi_wready = '1' and S_AXI_WVALID = '1' and axi_bvalid = '0'  ) then
                    axi_bvalid <= '1';
                    axi_bresp  <= "00"; 
                elsif (S_AXI_BREADY = '1' and axi_bvalid = '1') then   --check if bready is asserted while bvalid is high)
                    axi_bvalid <= '0';                                 -- (there is a possibility that bready is always asserted high)
                end if;
            end if;
        end if;                   
    end process; 

    -- Implement axi_arready generation
    -- axi_arready is asserted for one S_AXI_ACLK clock cycle when
    -- S_AXI_ARVALID is asserted. axi_awready is 
    -- de-asserted when reset (active low) is asserted. 
    -- The read address is also latched when S_AXI_ARVALID is 
    -- asserted. axi_araddr is reset to zero on reset assertion.
    process (S_AXI_ACLK)
    begin
        if rising_edge(S_AXI_ACLK) then 
            if S_AXI_ARESETN = '0' then
                axi_arready <= '0';
            else
                if (axi_arready = '0' and S_AXI_ARVALID = '1' and state = READ) then
                    -- indicates that the slave has acceped the valid read address
                    axi_arready <= '1';
                else
                    axi_arready <= '0';
                end if;
            end if;
        end if;                   
    end process; 

    -- Implement axi_rvalid generation
    -- axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
    -- S_AXI_ARVALID and axi_arready are asserted. The slave registers 
    -- data are available on the axi_rdata bus at this instance. The 
    -- assertion of axi_rvalid marks the validity of read data on the 
    -- bus and axi_rresp indicates the status of read transaction.axi_rvalid 
    -- is deasserted on reset (active low). axi_rresp and axi_rdata are 
    -- cleared to zero on reset (active low).  
    process (S_AXI_ACLK)
    begin
        if rising_edge(S_AXI_ACLK) then
            if S_AXI_ARESETN = '0' then
                axi_rvalid <= '0';
                axi_rresp  <= "00";
            else
                if (S_AXI_RREADY = '1' and state = READ and axi_arready = '1') then
                    -- Valid read data is available at the read data bus
                    axi_rvalid <= '1';
                    axi_rresp  <= "00"; -- 'OKAY' response
                elsif (axi_rvalid = '1' and S_AXI_RREADY = '1') then
                    -- Read data is accepted by the master
                    axi_rvalid <= '0';
                end if;            
            end if;
        end if;
    end process;

    -- state
    process (S_AXI_ACLK) is 
    begin
       if rising_edge(S_AXI_ACLK) then
           if S_AXI_ARESETN = '0' then
               state <= NOP;
           else
               state <= state_next;
           end if;
       end if;
    end process;
    process(state, axi_awaddr, S_AXI_AWVALID, axi_araddr, S_AXI_ARVALID, oreg_done)
    begin
        state_next <= state;
        case state is
        when NOP =>
            if axi_awaddr = 4 and S_AXI_AWVALID = '1' then
                state_next <= BIO;
            end if;
        when BIO =>
            if axi_araddr = 8 and S_AXI_ARVALID = '1' then
                state_next <= CALC;
            end if;
        when CALC =>
            if oreg_done = '1' then
                state_next <= READ;
            end if;
        when READ =>
            if  axi_awaddr = 0 and S_AXI_AWVALID = '1' then
                state_next <= NOP;
            elsif axi_awaddr = 4 and S_AXI_AWVALID = '1' then
                state_next <= BIO;
            end if;
        end case;
    end process;
    ctrl_state <= state_next;
    
    -- wram
    wram_addr_counter : process (S_AXI_ACLK)
    begin
       if rising_edge(S_AXI_ACLK) then
           if S_AXI_ARESETN = '0' or state /= NOP then
               wram_count <= 0;
               wram_ram_count <= 0;
           elsif axi_wready = '1' and axi_awaddr = 0 then
               if wram_count = ram_width -1 then
                   wram_count <= 0;
                   wram_ram_count <= wram_ram_count + 1;
               else
                   wram_count <= wram_count + 1;
               end if;
           end if;
       end if;
    end process;
    wram_addr <= wram_count;
    wram_en   <= '1' when axi_wready = '1' and axi_awaddr = 0 else '0';
    wram_data <= S_AXI_WDATA(bit_width-1 downto 0);
    
    -- bioram
    bioram_en   <= '1' when axi_wready = '1' and axi_awaddr = 4 else '0';
    bioram_data <= S_AXI_WDATA(bit_width-1 downto 0);

    -- oreg
    oreg_counter : process (S_AXI_ACLK)
    begin
        if rising_edge(S_AXI_ACLK) then
            if S_AXI_ARESETN = '0' or oreg_done = '1' then
                oreg_count <= 0;
            elsif axi_arready = '1' and state = READ then
                oreg_count <= oreg_count + 1;
            end if;
        end if;
    end process;
    oreg_addr <= oreg_count;
    axi_rdata(C_S_AXI_DATA_WIDTH-1 downto output_width) <= (others => '0');
    axi_rdata(output_width-1 downto 0)                  <= oreg_data;

end arch_imp;
