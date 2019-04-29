----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.04.2019 12:48:31
-- Design Name: 
-- Module Name: AXI_CTRL - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.data_types.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity AXI_CTRL is

  Port (
        clk         : in std_logic;
        reset       : in std_logic;
  
        --wram Ports
        wram_addr : out integer;
        wram_data : out std_logic_vector(output_width-1 downto 0);
        wram_en   : out std_logic;
        
        --OReg Ports
        OREG_addr : out integer;
        OREG_data : in std_logic_vector(output_width-1 downto 0);
        
        --CTRL_Unit Ports
        ctrl_OV          : in std_logic;
        ctrl_State       : out AXI_state;
        ctrl_R           : in std_logic;
        ctrl_V           : out std_logic;
        ctrl_data        : out std_logic_vector(output_width-1 downto 0);
        
        --AXI ports
        WDATA            : in std_logic_vector(input_width-1 downto 0);
        WVALID           : in std_logic;
        AWADDR           : in integer;
        ARADDR           : in integer;
        AWVALID          : in std_logic;
        ARVALID          : in std_logic;
        RDATA            : out std_logic_vector(input_width-1 downto 0);
        RVALID           : out std_logic;
        WREADY           : out std_logic;
        AWREADY          : out std_logic;
        RREADY           : in std_logic;
        ARREADY          : out std_logic;
        BVALID           : out std_logic
        --TODO
        );
end AXI_CTRL;

architecture Behavioral of AXI_CTRL is
        
        signal sig_RDATA            : std_logic_vector(input_width-1 downto 0);
        signal sig_RVALID           : std_logic;
        signal sig_WREADY           : std_logic;
        signal sig_AWREADY          : std_logic;
        signal sig_ARREADY          : std_logic;
        signal sig_BVALID           : std_logic;

        signal sig_wram_en : std_logic;
        signal sig_ctrl_V : std_logic;

        signal oreg_count : integer := 0;
        signal wram_count : integer := 0;
        
        SIGNAL state, state_next : AXI_state;
begin
    
    process(clk, reset)
    begin
        if (rising_edge(clk) and reset = '1') then -- go to state NOP if reset. 
            state <= NOP;            
        elsif (rising_edge(clk)) then -- otherwise update the states
            state <= state_next;
        end if; 
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            RDATA  <= sig_RDATA  ;
            RVALID <= sig_RVALID ;
            WREADY <= sig_WREADY ;
            AWREADY<= sig_AWREADY;
            ARREADY<= sig_ARREADY;
            BVALID <= sig_BVALID ;
        end if;
    end process;
    
    process(state, AWVALID, AWADDR, WVALID, ARADDR, ARVALID)
    begin
        case state is
        when NOP =>
            if AWADDR = 1 and AWVALID = '1' then
                state_next <= BIO;
            end if;
            if ARVALID = '1' and ARADDR = 2 then
                state_next <= CALC;
            end if;
        when BIO =>            
            if ARADDR = 2 and ARVALID = '1' then
                state_next <= CALC;
            elsif AWADDR = 0 AND AWVALID = '1' then
                state_next <= NOP;
            end if;
        when CALC =>
            if ctrl_ov = '1' then
                state_next <= READ;
            end if;
        when READ =>
            if AWADDR = 0 and AWVALID = '1' then
                state_next <= NOP;
            elsif AWADDR = 1 AND AWVALID = '1' then
                state_next <= BIO;
            end if;
        end case;
    end process;
    
    wram_addr_counter : process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' or state /= NOP then
                wram_count <= 0;
            elsif sig_wram_en = '1' then
                wram_count <= wram_count + 1;
            end if;
        end if;
    end process;

    wram_addr <= wram_count;
    wram_data <= WDATA;
    sig_wram_en   <= '1' when (AWADDR = 0) and (AWVALID = '1') and (WVALID = '1') else '0';
    wram_en <= sig_wram_en;
    
    sig_ctrl_V     <= '1' when AWADDR = 1 and AWVALID = '1' and WVALID = '1' else '0';
    ctrl_V <= sig_ctrl_V;
    ctrl_data  <= WDATA;
    ctrl_state <= state;

    sig_RDATA  <= OREG_data;
    sig_RVALID <= '1' when state = READ else '0'; 
    sig_WREADY <= '1' when (state = NOP and sig_wram_en = '1') or (state = BIO and sig_ctrl_V = '1') else '0';
    sig_AWREADY<= sig_WREADY;
    sig_ARREADY<= '1' when (state = READ and ARVALID = '1') else '0';

    bready_proc : process (clk)
        variable reg_wready, reg_wvalid : std_logic := '0';
    begin
        if reg_wready = '1' and reg_wvalid = '1' then
            sig_BVALID <= '1';
        else
            sig_BVALID <= '0';
        end if;

        if rising_edge(clk) then
            reg_wready := sig_WREADY;
            reg_wvalid := WVALID;
        end if;
    end process;

    oreg_counter : process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' or ctrl_ov = '1' then
                oreg_count <= 0;
            elsif RREADY = '1' then
                oreg_count <= oreg_count + 1;
            end if;
        end if;
    end process;
    OREG_addr <= oreg_count;

end Behavioral;
