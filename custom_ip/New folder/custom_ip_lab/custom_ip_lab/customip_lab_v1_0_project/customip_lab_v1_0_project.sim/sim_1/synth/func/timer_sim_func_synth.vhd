-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
-- Date        : Thu Apr 25 17:03:09 2019
-- Host        : DESKTOP-LSTE79J running 64-bit major release  (build 9200)
-- Command     : write_vhdl -mode funcsim -nolib -force -file {C:/Users/X4/Documents/GitHub/valjean-nnet/custom_ip/New
--               folder/custom_ip_lab/custom_ip_lab/customip_lab_v1_0_project/customip_lab_v1_0_project.sim/sim_1/synth/func/timer_sim_func_synth.vhd}
-- Design      : customip_lab_v1_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z020clg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity customip_lab_v1_0_S00_AXI is
  port (
    S_AXI_AWREADY : out STD_LOGIC;
    S_AXI_WREADY : out STD_LOGIC;
    S_AXI_ARREADY : out STD_LOGIC;
    s00_axi_bvalid_OBUF : out STD_LOGIC;
    s00_axi_rvalid_OBUF : out STD_LOGIC;
    s00_axi_awvalid_IBUF : in STD_LOGIC;
    s00_axi_wvalid_IBUF : in STD_LOGIC;
    s00_axi_arvalid_IBUF : in STD_LOGIC;
    s00_axi_aclk_IBUF_BUFG : in STD_LOGIC;
    s00_axi_aresetn_IBUF : in STD_LOGIC;
    s00_axi_bready_IBUF : in STD_LOGIC;
    s00_axi_rready_IBUF : in STD_LOGIC
  );
end customip_lab_v1_0_S00_AXI;

architecture STRUCTURE of customip_lab_v1_0_S00_AXI is
  signal \^s_axi_arready\ : STD_LOGIC;
  signal \^s_axi_awready\ : STD_LOGIC;
  signal \^s_axi_wready\ : STD_LOGIC;
  signal axi_arready_i_1_n_0 : STD_LOGIC;
  signal axi_awready_i_1_n_0 : STD_LOGIC;
  signal axi_bvalid_i_1_n_0 : STD_LOGIC;
  signal axi_rvalid_i_1_n_0 : STD_LOGIC;
  signal axi_wready_i_1_n_0 : STD_LOGIC;
  signal axi_wready_i_2_n_0 : STD_LOGIC;
  signal \^s00_axi_bvalid_obuf\ : STD_LOGIC;
  signal \^s00_axi_rvalid_obuf\ : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of axi_arready_i_1 : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of axi_awready_i_1 : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of axi_rvalid_i_1 : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of axi_wready_i_2 : label is "soft_lutpair1";
begin
  S_AXI_ARREADY <= \^s_axi_arready\;
  S_AXI_AWREADY <= \^s_axi_awready\;
  S_AXI_WREADY <= \^s_axi_wready\;
  s00_axi_bvalid_OBUF <= \^s00_axi_bvalid_obuf\;
  s00_axi_rvalid_OBUF <= \^s00_axi_rvalid_obuf\;
axi_arready_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => s00_axi_arvalid_IBUF,
      I1 => \^s_axi_arready\,
      O => axi_arready_i_1_n_0
    );
axi_arready_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s00_axi_aclk_IBUF_BUFG,
      CE => '1',
      D => axi_arready_i_1_n_0,
      Q => \^s_axi_arready\,
      R => axi_wready_i_1_n_0
    );
axi_awready_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => s00_axi_awvalid_IBUF,
      I1 => s00_axi_wvalid_IBUF,
      I2 => \^s_axi_awready\,
      O => axi_awready_i_1_n_0
    );
axi_awready_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s00_axi_aclk_IBUF_BUFG,
      CE => '1',
      D => axi_awready_i_1_n_0,
      Q => \^s_axi_awready\,
      R => axi_wready_i_1_n_0
    );
axi_bvalid_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000FFFF80008000"
    )
        port map (
      I0 => \^s_axi_wready\,
      I1 => s00_axi_wvalid_IBUF,
      I2 => \^s_axi_awready\,
      I3 => s00_axi_awvalid_IBUF,
      I4 => s00_axi_bready_IBUF,
      I5 => \^s00_axi_bvalid_obuf\,
      O => axi_bvalid_i_1_n_0
    );
axi_bvalid_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s00_axi_aclk_IBUF_BUFG,
      CE => '1',
      D => axi_bvalid_i_1_n_0,
      Q => \^s00_axi_bvalid_obuf\,
      R => axi_wready_i_1_n_0
    );
axi_rvalid_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"08F8"
    )
        port map (
      I0 => s00_axi_arvalid_IBUF,
      I1 => \^s_axi_arready\,
      I2 => \^s00_axi_rvalid_obuf\,
      I3 => s00_axi_rready_IBUF,
      O => axi_rvalid_i_1_n_0
    );
axi_rvalid_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s00_axi_aclk_IBUF_BUFG,
      CE => '1',
      D => axi_rvalid_i_1_n_0,
      Q => \^s00_axi_rvalid_obuf\,
      R => axi_wready_i_1_n_0
    );
axi_wready_i_1: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => s00_axi_aresetn_IBUF,
      O => axi_wready_i_1_n_0
    );
axi_wready_i_2: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => s00_axi_awvalid_IBUF,
      I1 => s00_axi_wvalid_IBUF,
      I2 => \^s_axi_wready\,
      O => axi_wready_i_2_n_0
    );
axi_wready_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s00_axi_aclk_IBUF_BUFG,
      CE => '1',
      D => axi_wready_i_2_n_0,
      Q => \^s_axi_wready\,
      R => axi_wready_i_1_n_0
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity customip_lab_v1_0 is
  port (
    s00_axi_aclk : in STD_LOGIC;
    s00_axi_aresetn : in STD_LOGIC;
    s00_axi_awaddr : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_awvalid : in STD_LOGIC;
    s00_axi_awready : out STD_LOGIC;
    s00_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_wvalid : in STD_LOGIC;
    s00_axi_wready : out STD_LOGIC;
    s00_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_bvalid : out STD_LOGIC;
    s00_axi_bready : in STD_LOGIC;
    s00_axi_araddr : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_arvalid : in STD_LOGIC;
    s00_axi_arready : out STD_LOGIC;
    s00_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_rvalid : out STD_LOGIC;
    s00_axi_rready : in STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of customip_lab_v1_0 : entity is true;
  attribute C_S00_AXI_ADDR_WIDTH : integer;
  attribute C_S00_AXI_ADDR_WIDTH of customip_lab_v1_0 : entity is 4;
  attribute C_S00_AXI_DATA_WIDTH : integer;
  attribute C_S00_AXI_DATA_WIDTH of customip_lab_v1_0 : entity is 32;
end customip_lab_v1_0;

architecture STRUCTURE of customip_lab_v1_0 is
  signal s00_axi_aclk_IBUF : STD_LOGIC;
  signal s00_axi_aclk_IBUF_BUFG : STD_LOGIC;
  signal s00_axi_aresetn_IBUF : STD_LOGIC;
  signal s00_axi_arready_OBUF : STD_LOGIC;
  signal s00_axi_arvalid_IBUF : STD_LOGIC;
  signal s00_axi_awready_OBUF : STD_LOGIC;
  signal s00_axi_awvalid_IBUF : STD_LOGIC;
  signal s00_axi_bready_IBUF : STD_LOGIC;
  signal s00_axi_bvalid_OBUF : STD_LOGIC;
  signal s00_axi_rready_IBUF : STD_LOGIC;
  signal s00_axi_rvalid_OBUF : STD_LOGIC;
  signal s00_axi_wready_OBUF : STD_LOGIC;
  signal s00_axi_wvalid_IBUF : STD_LOGIC;
begin
customip_lab_v1_0_S00_AXI_inst: entity work.customip_lab_v1_0_S00_AXI
     port map (
      S_AXI_ARREADY => s00_axi_arready_OBUF,
      S_AXI_AWREADY => s00_axi_awready_OBUF,
      S_AXI_WREADY => s00_axi_wready_OBUF,
      s00_axi_aclk_IBUF_BUFG => s00_axi_aclk_IBUF_BUFG,
      s00_axi_aresetn_IBUF => s00_axi_aresetn_IBUF,
      s00_axi_arvalid_IBUF => s00_axi_arvalid_IBUF,
      s00_axi_awvalid_IBUF => s00_axi_awvalid_IBUF,
      s00_axi_bready_IBUF => s00_axi_bready_IBUF,
      s00_axi_bvalid_OBUF => s00_axi_bvalid_OBUF,
      s00_axi_rready_IBUF => s00_axi_rready_IBUF,
      s00_axi_rvalid_OBUF => s00_axi_rvalid_OBUF,
      s00_axi_wvalid_IBUF => s00_axi_wvalid_IBUF
    );
s00_axi_aclk_IBUF_BUFG_inst: unisim.vcomponents.BUFG
     port map (
      I => s00_axi_aclk_IBUF,
      O => s00_axi_aclk_IBUF_BUFG
    );
s00_axi_aclk_IBUF_inst: unisim.vcomponents.IBUF
     port map (
      I => s00_axi_aclk,
      O => s00_axi_aclk_IBUF
    );
s00_axi_aresetn_IBUF_inst: unisim.vcomponents.IBUF
     port map (
      I => s00_axi_aresetn,
      O => s00_axi_aresetn_IBUF
    );
s00_axi_arready_OBUF_inst: unisim.vcomponents.OBUF
     port map (
      I => s00_axi_arready_OBUF,
      O => s00_axi_arready
    );
s00_axi_arvalid_IBUF_inst: unisim.vcomponents.IBUF
     port map (
      I => s00_axi_arvalid,
      O => s00_axi_arvalid_IBUF
    );
s00_axi_awready_OBUF_inst: unisim.vcomponents.OBUF
     port map (
      I => s00_axi_awready_OBUF,
      O => s00_axi_awready
    );
s00_axi_awvalid_IBUF_inst: unisim.vcomponents.IBUF
     port map (
      I => s00_axi_awvalid,
      O => s00_axi_awvalid_IBUF
    );
s00_axi_bready_IBUF_inst: unisim.vcomponents.IBUF
     port map (
      I => s00_axi_bready,
      O => s00_axi_bready_IBUF
    );
\s00_axi_bresp_OBUF[0]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_bresp(0)
    );
\s00_axi_bresp_OBUF[1]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_bresp(1)
    );
s00_axi_bvalid_OBUF_inst: unisim.vcomponents.OBUF
     port map (
      I => s00_axi_bvalid_OBUF,
      O => s00_axi_bvalid
    );
\s00_axi_rdata_OBUF[0]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_rdata(0)
    );
\s00_axi_rdata_OBUF[10]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_rdata(10)
    );
\s00_axi_rdata_OBUF[11]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_rdata(11)
    );
\s00_axi_rdata_OBUF[12]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_rdata(12)
    );
\s00_axi_rdata_OBUF[13]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_rdata(13)
    );
\s00_axi_rdata_OBUF[14]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_rdata(14)
    );
\s00_axi_rdata_OBUF[15]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_rdata(15)
    );
\s00_axi_rdata_OBUF[16]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_rdata(16)
    );
\s00_axi_rdata_OBUF[17]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_rdata(17)
    );
\s00_axi_rdata_OBUF[18]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_rdata(18)
    );
\s00_axi_rdata_OBUF[19]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_rdata(19)
    );
\s00_axi_rdata_OBUF[1]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_rdata(1)
    );
\s00_axi_rdata_OBUF[20]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_rdata(20)
    );
\s00_axi_rdata_OBUF[21]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_rdata(21)
    );
\s00_axi_rdata_OBUF[22]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_rdata(22)
    );
\s00_axi_rdata_OBUF[23]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_rdata(23)
    );
\s00_axi_rdata_OBUF[24]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_rdata(24)
    );
\s00_axi_rdata_OBUF[25]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_rdata(25)
    );
\s00_axi_rdata_OBUF[26]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_rdata(26)
    );
\s00_axi_rdata_OBUF[27]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_rdata(27)
    );
\s00_axi_rdata_OBUF[28]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_rdata(28)
    );
\s00_axi_rdata_OBUF[29]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_rdata(29)
    );
\s00_axi_rdata_OBUF[2]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_rdata(2)
    );
\s00_axi_rdata_OBUF[30]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_rdata(30)
    );
\s00_axi_rdata_OBUF[31]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_rdata(31)
    );
\s00_axi_rdata_OBUF[3]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_rdata(3)
    );
\s00_axi_rdata_OBUF[4]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_rdata(4)
    );
\s00_axi_rdata_OBUF[5]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_rdata(5)
    );
\s00_axi_rdata_OBUF[6]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_rdata(6)
    );
\s00_axi_rdata_OBUF[7]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_rdata(7)
    );
\s00_axi_rdata_OBUF[8]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_rdata(8)
    );
\s00_axi_rdata_OBUF[9]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_rdata(9)
    );
s00_axi_rready_IBUF_inst: unisim.vcomponents.IBUF
     port map (
      I => s00_axi_rready,
      O => s00_axi_rready_IBUF
    );
\s00_axi_rresp_OBUF[0]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_rresp(0)
    );
\s00_axi_rresp_OBUF[1]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => s00_axi_rresp(1)
    );
s00_axi_rvalid_OBUF_inst: unisim.vcomponents.OBUF
     port map (
      I => s00_axi_rvalid_OBUF,
      O => s00_axi_rvalid
    );
s00_axi_wready_OBUF_inst: unisim.vcomponents.OBUF
     port map (
      I => s00_axi_wready_OBUF,
      O => s00_axi_wready
    );
s00_axi_wvalid_IBUF_inst: unisim.vcomponents.IBUF
     port map (
      I => s00_axi_wvalid,
      O => s00_axi_wvalid_IBUF
    );
end STRUCTURE;
