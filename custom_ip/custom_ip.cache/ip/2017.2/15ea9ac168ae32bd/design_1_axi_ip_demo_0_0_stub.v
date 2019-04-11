// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
// Date        : Thu Mar 28 13:57:07 2019
// Host        : LAPTOP-HT53QSC4 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ design_1_axi_ip_demo_0_0_stub.v
// Design      : design_1_axi_ip_demo_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "axi_ip_demo_v1_0,Vivado 2017.2" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(axi_ip_demo_awaddr, axi_ip_demo_awprot, 
  axi_ip_demo_awvalid, axi_ip_demo_awready, axi_ip_demo_wdata, axi_ip_demo_wstrb, 
  axi_ip_demo_wvalid, axi_ip_demo_wready, axi_ip_demo_bresp, axi_ip_demo_bvalid, 
  axi_ip_demo_bready, axi_ip_demo_araddr, axi_ip_demo_arprot, axi_ip_demo_arvalid, 
  axi_ip_demo_arready, axi_ip_demo_rdata, axi_ip_demo_rresp, axi_ip_demo_rvalid, 
  axi_ip_demo_rready, axi_ip_demo_aclk, axi_ip_demo_aresetn)
/* synthesis syn_black_box black_box_pad_pin="axi_ip_demo_awaddr[3:0],axi_ip_demo_awprot[2:0],axi_ip_demo_awvalid,axi_ip_demo_awready,axi_ip_demo_wdata[31:0],axi_ip_demo_wstrb[3:0],axi_ip_demo_wvalid,axi_ip_demo_wready,axi_ip_demo_bresp[1:0],axi_ip_demo_bvalid,axi_ip_demo_bready,axi_ip_demo_araddr[3:0],axi_ip_demo_arprot[2:0],axi_ip_demo_arvalid,axi_ip_demo_arready,axi_ip_demo_rdata[31:0],axi_ip_demo_rresp[1:0],axi_ip_demo_rvalid,axi_ip_demo_rready,axi_ip_demo_aclk,axi_ip_demo_aresetn" */;
  input [3:0]axi_ip_demo_awaddr;
  input [2:0]axi_ip_demo_awprot;
  input axi_ip_demo_awvalid;
  output axi_ip_demo_awready;
  input [31:0]axi_ip_demo_wdata;
  input [3:0]axi_ip_demo_wstrb;
  input axi_ip_demo_wvalid;
  output axi_ip_demo_wready;
  output [1:0]axi_ip_demo_bresp;
  output axi_ip_demo_bvalid;
  input axi_ip_demo_bready;
  input [3:0]axi_ip_demo_araddr;
  input [2:0]axi_ip_demo_arprot;
  input axi_ip_demo_arvalid;
  output axi_ip_demo_arready;
  output [31:0]axi_ip_demo_rdata;
  output [1:0]axi_ip_demo_rresp;
  output axi_ip_demo_rvalid;
  input axi_ip_demo_rready;
  input axi_ip_demo_aclk;
  input axi_ip_demo_aresetn;
endmodule
