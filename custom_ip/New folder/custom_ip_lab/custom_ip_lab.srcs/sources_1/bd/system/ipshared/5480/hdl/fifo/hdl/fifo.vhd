--Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
--Date        : Thu Mar  7 13:48:56 2019
--Host        : cse-Win7 running 64-bit Service Pack 1  (build 7601)
--Command     : generate_target fifo.bd
--Design      : fifo
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity fifo is
  port (
    FIFO_READ_empty : out STD_LOGIC;
    FIFO_READ_rd_data : out STD_LOGIC_VECTOR ( 17 downto 0 );
    FIFO_READ_rd_en : in STD_LOGIC;
    FIFO_WRITE_full : out STD_LOGIC;
    FIFO_WRITE_wr_data : in STD_LOGIC_VECTOR ( 17 downto 0 );
    FIFO_WRITE_wr_en : in STD_LOGIC;
    clk : in STD_LOGIC;
    srst : in STD_LOGIC
  );
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of fifo : entity is "fifo,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=fifo,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of fifo : entity is "fifo.hwdef";
end fifo;

architecture STRUCTURE of fifo is
  component fifo_fifo_generator_0_0 is
  port (
    clk : in STD_LOGIC;
    srst : in STD_LOGIC;
    din : in STD_LOGIC_VECTOR ( 17 downto 0 );
    wr_en : in STD_LOGIC;
    rd_en : in STD_LOGIC;
    dout : out STD_LOGIC_VECTOR ( 17 downto 0 );
    full : out STD_LOGIC;
    empty : out STD_LOGIC
  );
  end component fifo_fifo_generator_0_0;
  signal FIFO_READ_1_EMPTY : STD_LOGIC;
  signal FIFO_READ_1_RD_DATA : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal FIFO_READ_1_RD_EN : STD_LOGIC;
  signal FIFO_WRITE_1_FULL : STD_LOGIC;
  signal FIFO_WRITE_1_WR_DATA : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal FIFO_WRITE_1_WR_EN : STD_LOGIC;
  signal clk_1 : STD_LOGIC;
  signal srst_1 : STD_LOGIC;
begin
  FIFO_READ_1_RD_EN <= FIFO_READ_rd_en;
  FIFO_READ_empty <= FIFO_READ_1_EMPTY;
  FIFO_READ_rd_data(17 downto 0) <= FIFO_READ_1_RD_DATA(17 downto 0);
  FIFO_WRITE_1_WR_DATA(17 downto 0) <= FIFO_WRITE_wr_data(17 downto 0);
  FIFO_WRITE_1_WR_EN <= FIFO_WRITE_wr_en;
  FIFO_WRITE_full <= FIFO_WRITE_1_FULL;
  clk_1 <= clk;
  srst_1 <= srst;
fifo_generator_0: component fifo_fifo_generator_0_0
     port map (
      clk => clk_1,
      din(17 downto 0) => FIFO_WRITE_1_WR_DATA(17 downto 0),
      dout(17 downto 0) => FIFO_READ_1_RD_DATA(17 downto 0),
      empty => FIFO_READ_1_EMPTY,
      full => FIFO_WRITE_1_FULL,
      rd_en => FIFO_READ_1_RD_EN,
      srst => srst_1,
      wr_en => FIFO_WRITE_1_WR_EN
    );
end STRUCTURE;
