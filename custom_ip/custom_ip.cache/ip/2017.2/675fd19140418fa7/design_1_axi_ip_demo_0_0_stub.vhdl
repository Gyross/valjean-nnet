-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
-- Date        : Thu Mar  7 11:27:32 2019
-- Host        : LAPTOP-HT53QSC4 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
--               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ design_1_axi_ip_demo_0_0_stub.vhdl
-- Design      : design_1_axi_ip_demo_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  Port ( 
    axi_ip_demo_awaddr : in STD_LOGIC_VECTOR ( 3 downto 0 );
    axi_ip_demo_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    axi_ip_demo_awvalid : in STD_LOGIC;
    axi_ip_demo_awready : out STD_LOGIC;
    axi_ip_demo_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    axi_ip_demo_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    axi_ip_demo_wvalid : in STD_LOGIC;
    axi_ip_demo_wready : out STD_LOGIC;
    axi_ip_demo_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    axi_ip_demo_bvalid : out STD_LOGIC;
    axi_ip_demo_bready : in STD_LOGIC;
    axi_ip_demo_araddr : in STD_LOGIC_VECTOR ( 3 downto 0 );
    axi_ip_demo_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    axi_ip_demo_arvalid : in STD_LOGIC;
    axi_ip_demo_arready : out STD_LOGIC;
    axi_ip_demo_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    axi_ip_demo_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    axi_ip_demo_rvalid : out STD_LOGIC;
    axi_ip_demo_rready : in STD_LOGIC;
    axi_ip_demo_aclk : in STD_LOGIC;
    axi_ip_demo_aresetn : in STD_LOGIC
  );

end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix;

architecture stub of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "axi_ip_demo_awaddr[3:0],axi_ip_demo_awprot[2:0],axi_ip_demo_awvalid,axi_ip_demo_awready,axi_ip_demo_wdata[31:0],axi_ip_demo_wstrb[3:0],axi_ip_demo_wvalid,axi_ip_demo_wready,axi_ip_demo_bresp[1:0],axi_ip_demo_bvalid,axi_ip_demo_bready,axi_ip_demo_araddr[3:0],axi_ip_demo_arprot[2:0],axi_ip_demo_arvalid,axi_ip_demo_arready,axi_ip_demo_rdata[31:0],axi_ip_demo_rresp[1:0],axi_ip_demo_rvalid,axi_ip_demo_rready,axi_ip_demo_aclk,axi_ip_demo_aresetn";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "axi_ip_demo_v1_0,Vivado 2017.2";
begin
end;
