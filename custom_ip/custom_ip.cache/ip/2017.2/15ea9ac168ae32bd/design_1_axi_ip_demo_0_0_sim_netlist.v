// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
// Date        : Thu Mar 28 13:57:07 2019
// Host        : LAPTOP-HT53QSC4 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ design_1_axi_ip_demo_0_0_sim_netlist.v
// Design      : design_1_axi_ip_demo_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_axi_ip_demo_v1_0
   (axi_ip_demo_awready,
    axi_ip_demo_wready,
    axi_ip_demo_arready,
    axi_ip_demo_rvalid,
    axi_ip_demo_rdata,
    axi_ip_demo_bvalid,
    axi_ip_demo_awvalid,
    axi_ip_demo_wvalid,
    axi_ip_demo_arvalid,
    axi_ip_demo_aclk,
    axi_ip_demo_araddr,
    axi_ip_demo_awaddr,
    axi_ip_demo_wdata,
    axi_ip_demo_wstrb,
    axi_ip_demo_aresetn,
    axi_ip_demo_bready,
    axi_ip_demo_rready);
  output axi_ip_demo_awready;
  output axi_ip_demo_wready;
  output axi_ip_demo_arready;
  output axi_ip_demo_rvalid;
  output [31:0]axi_ip_demo_rdata;
  output axi_ip_demo_bvalid;
  input axi_ip_demo_awvalid;
  input axi_ip_demo_wvalid;
  input axi_ip_demo_arvalid;
  input axi_ip_demo_aclk;
  input [1:0]axi_ip_demo_araddr;
  input [1:0]axi_ip_demo_awaddr;
  input [31:0]axi_ip_demo_wdata;
  input [3:0]axi_ip_demo_wstrb;
  input axi_ip_demo_aresetn;
  input axi_ip_demo_bready;
  input axi_ip_demo_rready;

  wire axi_ip_demo_aclk;
  wire [1:0]axi_ip_demo_araddr;
  wire axi_ip_demo_aresetn;
  wire axi_ip_demo_arready;
  wire axi_ip_demo_arvalid;
  wire [1:0]axi_ip_demo_awaddr;
  wire axi_ip_demo_awready;
  wire axi_ip_demo_awvalid;
  wire axi_ip_demo_bready;
  wire axi_ip_demo_bvalid;
  wire [31:0]axi_ip_demo_rdata;
  wire axi_ip_demo_rready;
  wire axi_ip_demo_rvalid;
  wire [31:0]axi_ip_demo_wdata;
  wire axi_ip_demo_wready;
  wire [3:0]axi_ip_demo_wstrb;
  wire axi_ip_demo_wvalid;

  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_axi_ip_demo_v1_0_axi_ip_demo axi_ip_demo_v1_0_axi_ip_demo_inst
       (.S_AXI_ARREADY(axi_ip_demo_arready),
        .S_AXI_AWREADY(axi_ip_demo_awready),
        .S_AXI_WREADY(axi_ip_demo_wready),
        .axi_ip_demo_aclk(axi_ip_demo_aclk),
        .axi_ip_demo_araddr(axi_ip_demo_araddr),
        .axi_ip_demo_aresetn(axi_ip_demo_aresetn),
        .axi_ip_demo_arvalid(axi_ip_demo_arvalid),
        .axi_ip_demo_awaddr(axi_ip_demo_awaddr),
        .axi_ip_demo_awvalid(axi_ip_demo_awvalid),
        .axi_ip_demo_bready(axi_ip_demo_bready),
        .axi_ip_demo_bvalid(axi_ip_demo_bvalid),
        .axi_ip_demo_rdata(axi_ip_demo_rdata),
        .axi_ip_demo_rready(axi_ip_demo_rready),
        .axi_ip_demo_rvalid(axi_ip_demo_rvalid),
        .axi_ip_demo_wdata(axi_ip_demo_wdata),
        .axi_ip_demo_wstrb(axi_ip_demo_wstrb),
        .axi_ip_demo_wvalid(axi_ip_demo_wvalid));
endmodule

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_axi_ip_demo_v1_0_axi_ip_demo
   (S_AXI_AWREADY,
    S_AXI_WREADY,
    S_AXI_ARREADY,
    axi_ip_demo_rvalid,
    axi_ip_demo_rdata,
    axi_ip_demo_bvalid,
    axi_ip_demo_awvalid,
    axi_ip_demo_wvalid,
    axi_ip_demo_arvalid,
    axi_ip_demo_aclk,
    axi_ip_demo_araddr,
    axi_ip_demo_awaddr,
    axi_ip_demo_wdata,
    axi_ip_demo_wstrb,
    axi_ip_demo_aresetn,
    axi_ip_demo_bready,
    axi_ip_demo_rready);
  output S_AXI_AWREADY;
  output S_AXI_WREADY;
  output S_AXI_ARREADY;
  output axi_ip_demo_rvalid;
  output [31:0]axi_ip_demo_rdata;
  output axi_ip_demo_bvalid;
  input axi_ip_demo_awvalid;
  input axi_ip_demo_wvalid;
  input axi_ip_demo_arvalid;
  input axi_ip_demo_aclk;
  input [1:0]axi_ip_demo_araddr;
  input [1:0]axi_ip_demo_awaddr;
  input [31:0]axi_ip_demo_wdata;
  input [3:0]axi_ip_demo_wstrb;
  input axi_ip_demo_aresetn;
  input axi_ip_demo_bready;
  input axi_ip_demo_rready;

  wire S_AXI_ARREADY;
  wire S_AXI_AWREADY;
  wire S_AXI_WREADY;
  wire [3:2]axi_araddr;
  wire \axi_araddr[2]_i_1_n_0 ;
  wire \axi_araddr[3]_i_1_n_0 ;
  wire axi_arready_i_1_n_0;
  wire \axi_awaddr[2]_i_1_n_0 ;
  wire \axi_awaddr[3]_i_1_n_0 ;
  wire axi_awready_i_1_n_0;
  wire axi_awready_i_2_n_0;
  wire axi_bvalid_i_1_n_0;
  wire axi_ip_demo_aclk;
  wire [1:0]axi_ip_demo_araddr;
  wire axi_ip_demo_aresetn;
  wire axi_ip_demo_arvalid;
  wire [1:0]axi_ip_demo_awaddr;
  wire axi_ip_demo_awvalid;
  wire axi_ip_demo_bready;
  wire axi_ip_demo_bvalid;
  wire [31:0]axi_ip_demo_rdata;
  wire axi_ip_demo_rready;
  wire axi_ip_demo_rvalid;
  wire [31:0]axi_ip_demo_wdata;
  wire [3:0]axi_ip_demo_wstrb;
  wire axi_ip_demo_wvalid;
  wire \axi_rdata[31]_i_1_n_0 ;
  wire axi_rvalid_i_1_n_0;
  wire axi_wready_i_1_n_0;
  wire [1:0]p_0_in;
  wire [31:7]p_1_in;
  wire [31:0]reg_data_out;
  wire [31:0]slv_reg0;
  wire [31:0]slv_reg1;
  wire \slv_reg1[15]_i_1_n_0 ;
  wire \slv_reg1[23]_i_1_n_0 ;
  wire \slv_reg1[31]_i_1_n_0 ;
  wire \slv_reg1[7]_i_1_n_0 ;
  wire [31:0]slv_reg2;
  wire \slv_reg2[15]_i_1_n_0 ;
  wire \slv_reg2[23]_i_1_n_0 ;
  wire \slv_reg2[31]_i_1_n_0 ;
  wire \slv_reg2[7]_i_1_n_0 ;
  wire [31:0]slv_reg3;
  wire \slv_reg3[15]_i_1_n_0 ;
  wire \slv_reg3[23]_i_1_n_0 ;
  wire \slv_reg3[31]_i_1_n_0 ;
  wire \slv_reg3[7]_i_1_n_0 ;
  wire slv_reg_wren__2;

  LUT4 #(
    .INIT(16'hFB08)) 
    \axi_araddr[2]_i_1 
       (.I0(axi_ip_demo_araddr[0]),
        .I1(axi_ip_demo_arvalid),
        .I2(S_AXI_ARREADY),
        .I3(axi_araddr[2]),
        .O(\axi_araddr[2]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \axi_araddr[3]_i_1 
       (.I0(axi_ip_demo_araddr[1]),
        .I1(axi_ip_demo_arvalid),
        .I2(S_AXI_ARREADY),
        .I3(axi_araddr[3]),
        .O(\axi_araddr[3]_i_1_n_0 ));
  FDSE \axi_araddr_reg[2] 
       (.C(axi_ip_demo_aclk),
        .CE(1'b1),
        .D(\axi_araddr[2]_i_1_n_0 ),
        .Q(axi_araddr[2]),
        .S(axi_awready_i_1_n_0));
  FDSE \axi_araddr_reg[3] 
       (.C(axi_ip_demo_aclk),
        .CE(1'b1),
        .D(\axi_araddr[3]_i_1_n_0 ),
        .Q(axi_araddr[3]),
        .S(axi_awready_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h2)) 
    axi_arready_i_1
       (.I0(axi_ip_demo_arvalid),
        .I1(S_AXI_ARREADY),
        .O(axi_arready_i_1_n_0));
  FDRE axi_arready_reg
       (.C(axi_ip_demo_aclk),
        .CE(1'b1),
        .D(axi_arready_i_1_n_0),
        .Q(S_AXI_ARREADY),
        .R(axi_awready_i_1_n_0));
  LUT5 #(
    .INIT(32'hFFBF0080)) 
    \axi_awaddr[2]_i_1 
       (.I0(axi_ip_demo_awaddr[0]),
        .I1(axi_ip_demo_awvalid),
        .I2(axi_ip_demo_wvalid),
        .I3(S_AXI_AWREADY),
        .I4(p_0_in[0]),
        .O(\axi_awaddr[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hFFBF0080)) 
    \axi_awaddr[3]_i_1 
       (.I0(axi_ip_demo_awaddr[1]),
        .I1(axi_ip_demo_awvalid),
        .I2(axi_ip_demo_wvalid),
        .I3(S_AXI_AWREADY),
        .I4(p_0_in[1]),
        .O(\axi_awaddr[3]_i_1_n_0 ));
  FDRE \axi_awaddr_reg[2] 
       (.C(axi_ip_demo_aclk),
        .CE(1'b1),
        .D(\axi_awaddr[2]_i_1_n_0 ),
        .Q(p_0_in[0]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_awaddr_reg[3] 
       (.C(axi_ip_demo_aclk),
        .CE(1'b1),
        .D(\axi_awaddr[3]_i_1_n_0 ),
        .Q(p_0_in[1]),
        .R(axi_awready_i_1_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    axi_awready_i_1
       (.I0(axi_ip_demo_aresetn),
        .O(axi_awready_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'h08)) 
    axi_awready_i_2
       (.I0(axi_ip_demo_awvalid),
        .I1(axi_ip_demo_wvalid),
        .I2(S_AXI_AWREADY),
        .O(axi_awready_i_2_n_0));
  FDRE axi_awready_reg
       (.C(axi_ip_demo_aclk),
        .CE(1'b1),
        .D(axi_awready_i_2_n_0),
        .Q(S_AXI_AWREADY),
        .R(axi_awready_i_1_n_0));
  LUT6 #(
    .INIT(64'h0000FFFF80008000)) 
    axi_bvalid_i_1
       (.I0(S_AXI_WREADY),
        .I1(axi_ip_demo_wvalid),
        .I2(S_AXI_AWREADY),
        .I3(axi_ip_demo_awvalid),
        .I4(axi_ip_demo_bready),
        .I5(axi_ip_demo_bvalid),
        .O(axi_bvalid_i_1_n_0));
  FDRE axi_bvalid_reg
       (.C(axi_ip_demo_aclk),
        .CE(1'b1),
        .D(axi_bvalid_i_1_n_0),
        .Q(axi_ip_demo_bvalid),
        .R(axi_awready_i_1_n_0));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[0]_i_1 
       (.I0(slv_reg1[0]),
        .I1(slv_reg0[0]),
        .I2(slv_reg3[0]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[0]),
        .O(reg_data_out[0]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[10]_i_1 
       (.I0(slv_reg1[10]),
        .I1(slv_reg0[10]),
        .I2(slv_reg3[10]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[10]),
        .O(reg_data_out[10]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[11]_i_1 
       (.I0(slv_reg1[11]),
        .I1(slv_reg0[11]),
        .I2(slv_reg3[11]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[11]),
        .O(reg_data_out[11]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[12]_i_1 
       (.I0(slv_reg1[12]),
        .I1(slv_reg0[12]),
        .I2(slv_reg3[12]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[12]),
        .O(reg_data_out[12]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[13]_i_1 
       (.I0(slv_reg1[13]),
        .I1(slv_reg0[13]),
        .I2(slv_reg3[13]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[13]),
        .O(reg_data_out[13]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[14]_i_1 
       (.I0(slv_reg1[14]),
        .I1(slv_reg0[14]),
        .I2(slv_reg3[14]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[14]),
        .O(reg_data_out[14]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[15]_i_1 
       (.I0(slv_reg1[15]),
        .I1(slv_reg0[15]),
        .I2(slv_reg3[15]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[15]),
        .O(reg_data_out[15]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[16]_i_1 
       (.I0(slv_reg1[16]),
        .I1(slv_reg0[16]),
        .I2(slv_reg3[16]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[16]),
        .O(reg_data_out[16]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[17]_i_1 
       (.I0(slv_reg1[17]),
        .I1(slv_reg0[17]),
        .I2(slv_reg3[17]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[17]),
        .O(reg_data_out[17]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[18]_i_1 
       (.I0(slv_reg1[18]),
        .I1(slv_reg0[18]),
        .I2(slv_reg3[18]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[18]),
        .O(reg_data_out[18]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[19]_i_1 
       (.I0(slv_reg1[19]),
        .I1(slv_reg0[19]),
        .I2(slv_reg3[19]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[19]),
        .O(reg_data_out[19]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[1]_i_1 
       (.I0(slv_reg1[1]),
        .I1(slv_reg0[1]),
        .I2(slv_reg3[1]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[1]),
        .O(reg_data_out[1]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[20]_i_1 
       (.I0(slv_reg1[20]),
        .I1(slv_reg0[20]),
        .I2(slv_reg3[20]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[20]),
        .O(reg_data_out[20]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[21]_i_1 
       (.I0(slv_reg1[21]),
        .I1(slv_reg0[21]),
        .I2(slv_reg3[21]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[21]),
        .O(reg_data_out[21]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[22]_i_1 
       (.I0(slv_reg1[22]),
        .I1(slv_reg0[22]),
        .I2(slv_reg3[22]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[22]),
        .O(reg_data_out[22]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[23]_i_1 
       (.I0(slv_reg1[23]),
        .I1(slv_reg0[23]),
        .I2(slv_reg3[23]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[23]),
        .O(reg_data_out[23]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[24]_i_1 
       (.I0(slv_reg1[24]),
        .I1(slv_reg0[24]),
        .I2(slv_reg3[24]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[24]),
        .O(reg_data_out[24]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[25]_i_1 
       (.I0(slv_reg1[25]),
        .I1(slv_reg0[25]),
        .I2(slv_reg3[25]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[25]),
        .O(reg_data_out[25]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[26]_i_1 
       (.I0(slv_reg1[26]),
        .I1(slv_reg0[26]),
        .I2(slv_reg3[26]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[26]),
        .O(reg_data_out[26]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[27]_i_1 
       (.I0(slv_reg1[27]),
        .I1(slv_reg0[27]),
        .I2(slv_reg3[27]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[27]),
        .O(reg_data_out[27]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[28]_i_1 
       (.I0(slv_reg1[28]),
        .I1(slv_reg0[28]),
        .I2(slv_reg3[28]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[28]),
        .O(reg_data_out[28]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[29]_i_1 
       (.I0(slv_reg1[29]),
        .I1(slv_reg0[29]),
        .I2(slv_reg3[29]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[29]),
        .O(reg_data_out[29]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[2]_i_1 
       (.I0(slv_reg1[2]),
        .I1(slv_reg0[2]),
        .I2(slv_reg3[2]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[2]),
        .O(reg_data_out[2]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[30]_i_1 
       (.I0(slv_reg1[30]),
        .I1(slv_reg0[30]),
        .I2(slv_reg3[30]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[30]),
        .O(reg_data_out[30]));
  LUT3 #(
    .INIT(8'h08)) 
    \axi_rdata[31]_i_1 
       (.I0(S_AXI_ARREADY),
        .I1(axi_ip_demo_arvalid),
        .I2(axi_ip_demo_rvalid),
        .O(\axi_rdata[31]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[31]_i_2 
       (.I0(slv_reg1[31]),
        .I1(slv_reg0[31]),
        .I2(slv_reg3[31]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[31]),
        .O(reg_data_out[31]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[3]_i_1 
       (.I0(slv_reg1[3]),
        .I1(slv_reg0[3]),
        .I2(slv_reg3[3]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[3]),
        .O(reg_data_out[3]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[4]_i_1 
       (.I0(slv_reg1[4]),
        .I1(slv_reg0[4]),
        .I2(slv_reg3[4]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[4]),
        .O(reg_data_out[4]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[5]_i_1 
       (.I0(slv_reg1[5]),
        .I1(slv_reg0[5]),
        .I2(slv_reg3[5]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[5]),
        .O(reg_data_out[5]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[6]_i_1 
       (.I0(slv_reg1[6]),
        .I1(slv_reg0[6]),
        .I2(slv_reg3[6]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[6]),
        .O(reg_data_out[6]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[7]_i_1 
       (.I0(slv_reg1[7]),
        .I1(slv_reg0[7]),
        .I2(slv_reg3[7]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[7]),
        .O(reg_data_out[7]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[8]_i_1 
       (.I0(slv_reg1[8]),
        .I1(slv_reg0[8]),
        .I2(slv_reg3[8]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[8]),
        .O(reg_data_out[8]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[9]_i_1 
       (.I0(slv_reg1[9]),
        .I1(slv_reg0[9]),
        .I2(slv_reg3[9]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[9]),
        .O(reg_data_out[9]));
  FDRE \axi_rdata_reg[0] 
       (.C(axi_ip_demo_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[0]),
        .Q(axi_ip_demo_rdata[0]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[10] 
       (.C(axi_ip_demo_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[10]),
        .Q(axi_ip_demo_rdata[10]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[11] 
       (.C(axi_ip_demo_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[11]),
        .Q(axi_ip_demo_rdata[11]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[12] 
       (.C(axi_ip_demo_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[12]),
        .Q(axi_ip_demo_rdata[12]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[13] 
       (.C(axi_ip_demo_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[13]),
        .Q(axi_ip_demo_rdata[13]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[14] 
       (.C(axi_ip_demo_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[14]),
        .Q(axi_ip_demo_rdata[14]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[15] 
       (.C(axi_ip_demo_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[15]),
        .Q(axi_ip_demo_rdata[15]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[16] 
       (.C(axi_ip_demo_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[16]),
        .Q(axi_ip_demo_rdata[16]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[17] 
       (.C(axi_ip_demo_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[17]),
        .Q(axi_ip_demo_rdata[17]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[18] 
       (.C(axi_ip_demo_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[18]),
        .Q(axi_ip_demo_rdata[18]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[19] 
       (.C(axi_ip_demo_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[19]),
        .Q(axi_ip_demo_rdata[19]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[1] 
       (.C(axi_ip_demo_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[1]),
        .Q(axi_ip_demo_rdata[1]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[20] 
       (.C(axi_ip_demo_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[20]),
        .Q(axi_ip_demo_rdata[20]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[21] 
       (.C(axi_ip_demo_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[21]),
        .Q(axi_ip_demo_rdata[21]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[22] 
       (.C(axi_ip_demo_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[22]),
        .Q(axi_ip_demo_rdata[22]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[23] 
       (.C(axi_ip_demo_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[23]),
        .Q(axi_ip_demo_rdata[23]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[24] 
       (.C(axi_ip_demo_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[24]),
        .Q(axi_ip_demo_rdata[24]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[25] 
       (.C(axi_ip_demo_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[25]),
        .Q(axi_ip_demo_rdata[25]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[26] 
       (.C(axi_ip_demo_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[26]),
        .Q(axi_ip_demo_rdata[26]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[27] 
       (.C(axi_ip_demo_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[27]),
        .Q(axi_ip_demo_rdata[27]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[28] 
       (.C(axi_ip_demo_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[28]),
        .Q(axi_ip_demo_rdata[28]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[29] 
       (.C(axi_ip_demo_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[29]),
        .Q(axi_ip_demo_rdata[29]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[2] 
       (.C(axi_ip_demo_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[2]),
        .Q(axi_ip_demo_rdata[2]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[30] 
       (.C(axi_ip_demo_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[30]),
        .Q(axi_ip_demo_rdata[30]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[31] 
       (.C(axi_ip_demo_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[31]),
        .Q(axi_ip_demo_rdata[31]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[3] 
       (.C(axi_ip_demo_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[3]),
        .Q(axi_ip_demo_rdata[3]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[4] 
       (.C(axi_ip_demo_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[4]),
        .Q(axi_ip_demo_rdata[4]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[5] 
       (.C(axi_ip_demo_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[5]),
        .Q(axi_ip_demo_rdata[5]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[6] 
       (.C(axi_ip_demo_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[6]),
        .Q(axi_ip_demo_rdata[6]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[7] 
       (.C(axi_ip_demo_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[7]),
        .Q(axi_ip_demo_rdata[7]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[8] 
       (.C(axi_ip_demo_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[8]),
        .Q(axi_ip_demo_rdata[8]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[9] 
       (.C(axi_ip_demo_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[9]),
        .Q(axi_ip_demo_rdata[9]),
        .R(axi_awready_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'h08F8)) 
    axi_rvalid_i_1
       (.I0(axi_ip_demo_arvalid),
        .I1(S_AXI_ARREADY),
        .I2(axi_ip_demo_rvalid),
        .I3(axi_ip_demo_rready),
        .O(axi_rvalid_i_1_n_0));
  FDRE axi_rvalid_reg
       (.C(axi_ip_demo_aclk),
        .CE(1'b1),
        .D(axi_rvalid_i_1_n_0),
        .Q(axi_ip_demo_rvalid),
        .R(axi_awready_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'h08)) 
    axi_wready_i_1
       (.I0(axi_ip_demo_awvalid),
        .I1(axi_ip_demo_wvalid),
        .I2(S_AXI_WREADY),
        .O(axi_wready_i_1_n_0));
  FDRE axi_wready_reg
       (.C(axi_ip_demo_aclk),
        .CE(1'b1),
        .D(axi_wready_i_1_n_0),
        .Q(S_AXI_WREADY),
        .R(axi_awready_i_1_n_0));
  LUT4 #(
    .INIT(16'h0200)) 
    \slv_reg0[15]_i_1 
       (.I0(slv_reg_wren__2),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .I3(axi_ip_demo_wstrb[1]),
        .O(p_1_in[15]));
  LUT4 #(
    .INIT(16'h0200)) 
    \slv_reg0[23]_i_1 
       (.I0(slv_reg_wren__2),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .I3(axi_ip_demo_wstrb[2]),
        .O(p_1_in[23]));
  LUT4 #(
    .INIT(16'h0200)) 
    \slv_reg0[31]_i_1 
       (.I0(slv_reg_wren__2),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .I3(axi_ip_demo_wstrb[3]),
        .O(p_1_in[31]));
  LUT4 #(
    .INIT(16'h0200)) 
    \slv_reg0[7]_i_1 
       (.I0(slv_reg_wren__2),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .I3(axi_ip_demo_wstrb[0]),
        .O(p_1_in[7]));
  FDRE \slv_reg0_reg[0] 
       (.C(axi_ip_demo_aclk),
        .CE(p_1_in[7]),
        .D(axi_ip_demo_wdata[0]),
        .Q(slv_reg0[0]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[10] 
       (.C(axi_ip_demo_aclk),
        .CE(p_1_in[15]),
        .D(axi_ip_demo_wdata[10]),
        .Q(slv_reg0[10]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[11] 
       (.C(axi_ip_demo_aclk),
        .CE(p_1_in[15]),
        .D(axi_ip_demo_wdata[11]),
        .Q(slv_reg0[11]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[12] 
       (.C(axi_ip_demo_aclk),
        .CE(p_1_in[15]),
        .D(axi_ip_demo_wdata[12]),
        .Q(slv_reg0[12]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[13] 
       (.C(axi_ip_demo_aclk),
        .CE(p_1_in[15]),
        .D(axi_ip_demo_wdata[13]),
        .Q(slv_reg0[13]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[14] 
       (.C(axi_ip_demo_aclk),
        .CE(p_1_in[15]),
        .D(axi_ip_demo_wdata[14]),
        .Q(slv_reg0[14]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[15] 
       (.C(axi_ip_demo_aclk),
        .CE(p_1_in[15]),
        .D(axi_ip_demo_wdata[15]),
        .Q(slv_reg0[15]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[16] 
       (.C(axi_ip_demo_aclk),
        .CE(p_1_in[23]),
        .D(axi_ip_demo_wdata[16]),
        .Q(slv_reg0[16]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[17] 
       (.C(axi_ip_demo_aclk),
        .CE(p_1_in[23]),
        .D(axi_ip_demo_wdata[17]),
        .Q(slv_reg0[17]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[18] 
       (.C(axi_ip_demo_aclk),
        .CE(p_1_in[23]),
        .D(axi_ip_demo_wdata[18]),
        .Q(slv_reg0[18]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[19] 
       (.C(axi_ip_demo_aclk),
        .CE(p_1_in[23]),
        .D(axi_ip_demo_wdata[19]),
        .Q(slv_reg0[19]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[1] 
       (.C(axi_ip_demo_aclk),
        .CE(p_1_in[7]),
        .D(axi_ip_demo_wdata[1]),
        .Q(slv_reg0[1]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[20] 
       (.C(axi_ip_demo_aclk),
        .CE(p_1_in[23]),
        .D(axi_ip_demo_wdata[20]),
        .Q(slv_reg0[20]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[21] 
       (.C(axi_ip_demo_aclk),
        .CE(p_1_in[23]),
        .D(axi_ip_demo_wdata[21]),
        .Q(slv_reg0[21]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[22] 
       (.C(axi_ip_demo_aclk),
        .CE(p_1_in[23]),
        .D(axi_ip_demo_wdata[22]),
        .Q(slv_reg0[22]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[23] 
       (.C(axi_ip_demo_aclk),
        .CE(p_1_in[23]),
        .D(axi_ip_demo_wdata[23]),
        .Q(slv_reg0[23]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[24] 
       (.C(axi_ip_demo_aclk),
        .CE(p_1_in[31]),
        .D(axi_ip_demo_wdata[24]),
        .Q(slv_reg0[24]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[25] 
       (.C(axi_ip_demo_aclk),
        .CE(p_1_in[31]),
        .D(axi_ip_demo_wdata[25]),
        .Q(slv_reg0[25]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[26] 
       (.C(axi_ip_demo_aclk),
        .CE(p_1_in[31]),
        .D(axi_ip_demo_wdata[26]),
        .Q(slv_reg0[26]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[27] 
       (.C(axi_ip_demo_aclk),
        .CE(p_1_in[31]),
        .D(axi_ip_demo_wdata[27]),
        .Q(slv_reg0[27]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[28] 
       (.C(axi_ip_demo_aclk),
        .CE(p_1_in[31]),
        .D(axi_ip_demo_wdata[28]),
        .Q(slv_reg0[28]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[29] 
       (.C(axi_ip_demo_aclk),
        .CE(p_1_in[31]),
        .D(axi_ip_demo_wdata[29]),
        .Q(slv_reg0[29]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[2] 
       (.C(axi_ip_demo_aclk),
        .CE(p_1_in[7]),
        .D(axi_ip_demo_wdata[2]),
        .Q(slv_reg0[2]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[30] 
       (.C(axi_ip_demo_aclk),
        .CE(p_1_in[31]),
        .D(axi_ip_demo_wdata[30]),
        .Q(slv_reg0[30]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[31] 
       (.C(axi_ip_demo_aclk),
        .CE(p_1_in[31]),
        .D(axi_ip_demo_wdata[31]),
        .Q(slv_reg0[31]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[3] 
       (.C(axi_ip_demo_aclk),
        .CE(p_1_in[7]),
        .D(axi_ip_demo_wdata[3]),
        .Q(slv_reg0[3]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[4] 
       (.C(axi_ip_demo_aclk),
        .CE(p_1_in[7]),
        .D(axi_ip_demo_wdata[4]),
        .Q(slv_reg0[4]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[5] 
       (.C(axi_ip_demo_aclk),
        .CE(p_1_in[7]),
        .D(axi_ip_demo_wdata[5]),
        .Q(slv_reg0[5]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[6] 
       (.C(axi_ip_demo_aclk),
        .CE(p_1_in[7]),
        .D(axi_ip_demo_wdata[6]),
        .Q(slv_reg0[6]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[7] 
       (.C(axi_ip_demo_aclk),
        .CE(p_1_in[7]),
        .D(axi_ip_demo_wdata[7]),
        .Q(slv_reg0[7]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[8] 
       (.C(axi_ip_demo_aclk),
        .CE(p_1_in[15]),
        .D(axi_ip_demo_wdata[8]),
        .Q(slv_reg0[8]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[9] 
       (.C(axi_ip_demo_aclk),
        .CE(p_1_in[15]),
        .D(axi_ip_demo_wdata[9]),
        .Q(slv_reg0[9]),
        .R(axi_awready_i_1_n_0));
  LUT4 #(
    .INIT(16'h2000)) 
    \slv_reg1[15]_i_1 
       (.I0(slv_reg_wren__2),
        .I1(p_0_in[1]),
        .I2(axi_ip_demo_wstrb[1]),
        .I3(p_0_in[0]),
        .O(\slv_reg1[15]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h2000)) 
    \slv_reg1[23]_i_1 
       (.I0(slv_reg_wren__2),
        .I1(p_0_in[1]),
        .I2(axi_ip_demo_wstrb[2]),
        .I3(p_0_in[0]),
        .O(\slv_reg1[23]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h2000)) 
    \slv_reg1[31]_i_1 
       (.I0(slv_reg_wren__2),
        .I1(p_0_in[1]),
        .I2(axi_ip_demo_wstrb[3]),
        .I3(p_0_in[0]),
        .O(\slv_reg1[31]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h2000)) 
    \slv_reg1[7]_i_1 
       (.I0(slv_reg_wren__2),
        .I1(p_0_in[1]),
        .I2(axi_ip_demo_wstrb[0]),
        .I3(p_0_in[0]),
        .O(\slv_reg1[7]_i_1_n_0 ));
  FDRE \slv_reg1_reg[0] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg1[7]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[0]),
        .Q(slv_reg1[0]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[10] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg1[15]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[10]),
        .Q(slv_reg1[10]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[11] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg1[15]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[11]),
        .Q(slv_reg1[11]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[12] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg1[15]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[12]),
        .Q(slv_reg1[12]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[13] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg1[15]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[13]),
        .Q(slv_reg1[13]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[14] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg1[15]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[14]),
        .Q(slv_reg1[14]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[15] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg1[15]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[15]),
        .Q(slv_reg1[15]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[16] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg1[23]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[16]),
        .Q(slv_reg1[16]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[17] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg1[23]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[17]),
        .Q(slv_reg1[17]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[18] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg1[23]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[18]),
        .Q(slv_reg1[18]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[19] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg1[23]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[19]),
        .Q(slv_reg1[19]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[1] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg1[7]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[1]),
        .Q(slv_reg1[1]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[20] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg1[23]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[20]),
        .Q(slv_reg1[20]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[21] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg1[23]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[21]),
        .Q(slv_reg1[21]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[22] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg1[23]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[22]),
        .Q(slv_reg1[22]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[23] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg1[23]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[23]),
        .Q(slv_reg1[23]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[24] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg1[31]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[24]),
        .Q(slv_reg1[24]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[25] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg1[31]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[25]),
        .Q(slv_reg1[25]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[26] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg1[31]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[26]),
        .Q(slv_reg1[26]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[27] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg1[31]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[27]),
        .Q(slv_reg1[27]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[28] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg1[31]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[28]),
        .Q(slv_reg1[28]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[29] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg1[31]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[29]),
        .Q(slv_reg1[29]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[2] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg1[7]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[2]),
        .Q(slv_reg1[2]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[30] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg1[31]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[30]),
        .Q(slv_reg1[30]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[31] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg1[31]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[31]),
        .Q(slv_reg1[31]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[3] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg1[7]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[3]),
        .Q(slv_reg1[3]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[4] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg1[7]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[4]),
        .Q(slv_reg1[4]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[5] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg1[7]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[5]),
        .Q(slv_reg1[5]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[6] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg1[7]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[6]),
        .Q(slv_reg1[6]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[7] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg1[7]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[7]),
        .Q(slv_reg1[7]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[8] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg1[15]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[8]),
        .Q(slv_reg1[8]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[9] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg1[15]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[9]),
        .Q(slv_reg1[9]),
        .R(axi_awready_i_1_n_0));
  LUT4 #(
    .INIT(16'h0080)) 
    \slv_reg2[15]_i_1 
       (.I0(slv_reg_wren__2),
        .I1(p_0_in[1]),
        .I2(axi_ip_demo_wstrb[1]),
        .I3(p_0_in[0]),
        .O(\slv_reg2[15]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h0080)) 
    \slv_reg2[23]_i_1 
       (.I0(slv_reg_wren__2),
        .I1(p_0_in[1]),
        .I2(axi_ip_demo_wstrb[2]),
        .I3(p_0_in[0]),
        .O(\slv_reg2[23]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h0080)) 
    \slv_reg2[31]_i_1 
       (.I0(slv_reg_wren__2),
        .I1(p_0_in[1]),
        .I2(axi_ip_demo_wstrb[3]),
        .I3(p_0_in[0]),
        .O(\slv_reg2[31]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h0080)) 
    \slv_reg2[7]_i_1 
       (.I0(slv_reg_wren__2),
        .I1(p_0_in[1]),
        .I2(axi_ip_demo_wstrb[0]),
        .I3(p_0_in[0]),
        .O(\slv_reg2[7]_i_1_n_0 ));
  FDRE \slv_reg2_reg[0] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg2[7]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[0]),
        .Q(slv_reg2[0]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[10] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg2[15]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[10]),
        .Q(slv_reg2[10]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[11] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg2[15]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[11]),
        .Q(slv_reg2[11]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[12] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg2[15]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[12]),
        .Q(slv_reg2[12]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[13] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg2[15]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[13]),
        .Q(slv_reg2[13]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[14] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg2[15]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[14]),
        .Q(slv_reg2[14]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[15] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg2[15]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[15]),
        .Q(slv_reg2[15]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[16] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg2[23]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[16]),
        .Q(slv_reg2[16]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[17] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg2[23]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[17]),
        .Q(slv_reg2[17]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[18] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg2[23]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[18]),
        .Q(slv_reg2[18]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[19] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg2[23]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[19]),
        .Q(slv_reg2[19]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[1] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg2[7]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[1]),
        .Q(slv_reg2[1]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[20] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg2[23]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[20]),
        .Q(slv_reg2[20]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[21] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg2[23]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[21]),
        .Q(slv_reg2[21]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[22] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg2[23]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[22]),
        .Q(slv_reg2[22]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[23] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg2[23]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[23]),
        .Q(slv_reg2[23]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[24] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg2[31]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[24]),
        .Q(slv_reg2[24]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[25] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg2[31]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[25]),
        .Q(slv_reg2[25]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[26] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg2[31]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[26]),
        .Q(slv_reg2[26]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[27] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg2[31]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[27]),
        .Q(slv_reg2[27]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[28] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg2[31]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[28]),
        .Q(slv_reg2[28]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[29] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg2[31]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[29]),
        .Q(slv_reg2[29]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[2] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg2[7]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[2]),
        .Q(slv_reg2[2]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[30] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg2[31]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[30]),
        .Q(slv_reg2[30]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[31] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg2[31]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[31]),
        .Q(slv_reg2[31]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[3] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg2[7]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[3]),
        .Q(slv_reg2[3]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[4] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg2[7]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[4]),
        .Q(slv_reg2[4]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[5] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg2[7]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[5]),
        .Q(slv_reg2[5]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[6] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg2[7]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[6]),
        .Q(slv_reg2[6]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[7] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg2[7]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[7]),
        .Q(slv_reg2[7]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[8] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg2[15]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[8]),
        .Q(slv_reg2[8]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[9] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg2[15]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[9]),
        .Q(slv_reg2[9]),
        .R(axi_awready_i_1_n_0));
  LUT4 #(
    .INIT(16'h8000)) 
    \slv_reg3[15]_i_1 
       (.I0(slv_reg_wren__2),
        .I1(axi_ip_demo_wstrb[1]),
        .I2(p_0_in[0]),
        .I3(p_0_in[1]),
        .O(\slv_reg3[15]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h8000)) 
    \slv_reg3[23]_i_1 
       (.I0(slv_reg_wren__2),
        .I1(axi_ip_demo_wstrb[2]),
        .I2(p_0_in[0]),
        .I3(p_0_in[1]),
        .O(\slv_reg3[23]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h8000)) 
    \slv_reg3[31]_i_1 
       (.I0(slv_reg_wren__2),
        .I1(axi_ip_demo_wstrb[3]),
        .I2(p_0_in[0]),
        .I3(p_0_in[1]),
        .O(\slv_reg3[31]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'h8000)) 
    \slv_reg3[31]_i_2 
       (.I0(S_AXI_WREADY),
        .I1(axi_ip_demo_wvalid),
        .I2(S_AXI_AWREADY),
        .I3(axi_ip_demo_awvalid),
        .O(slv_reg_wren__2));
  LUT4 #(
    .INIT(16'h8000)) 
    \slv_reg3[7]_i_1 
       (.I0(slv_reg_wren__2),
        .I1(axi_ip_demo_wstrb[0]),
        .I2(p_0_in[0]),
        .I3(p_0_in[1]),
        .O(\slv_reg3[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[0] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[0]),
        .Q(slv_reg3[0]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[10] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[10]),
        .Q(slv_reg3[10]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[11] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[11]),
        .Q(slv_reg3[11]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[12] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[12]),
        .Q(slv_reg3[12]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[13] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[13]),
        .Q(slv_reg3[13]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[14] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[14]),
        .Q(slv_reg3[14]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[15] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[15]),
        .Q(slv_reg3[15]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[16] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[16]),
        .Q(slv_reg3[16]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[17] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[17]),
        .Q(slv_reg3[17]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[18] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[18]),
        .Q(slv_reg3[18]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[19] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[19]),
        .Q(slv_reg3[19]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[1] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[1]),
        .Q(slv_reg3[1]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[20] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[20]),
        .Q(slv_reg3[20]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[21] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[21]),
        .Q(slv_reg3[21]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[22] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[22]),
        .Q(slv_reg3[22]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[23] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[23]),
        .Q(slv_reg3[23]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[24] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[24]),
        .Q(slv_reg3[24]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[25] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[25]),
        .Q(slv_reg3[25]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[26] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[26]),
        .Q(slv_reg3[26]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[27] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[27]),
        .Q(slv_reg3[27]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[28] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[28]),
        .Q(slv_reg3[28]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[29] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[29]),
        .Q(slv_reg3[29]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[2] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[2]),
        .Q(slv_reg3[2]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[30] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[30]),
        .Q(slv_reg3[30]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[31] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[31]),
        .Q(slv_reg3[31]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[3] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[3]),
        .Q(slv_reg3[3]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[4] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[4]),
        .Q(slv_reg3[4]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[5] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[5]),
        .Q(slv_reg3[5]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[6] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[6]),
        .Q(slv_reg3[6]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[7] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[7]),
        .Q(slv_reg3[7]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[8] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[8]),
        .Q(slv_reg3[8]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[9] 
       (.C(axi_ip_demo_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(axi_ip_demo_wdata[9]),
        .Q(slv_reg3[9]),
        .R(axi_awready_i_1_n_0));
endmodule

(* CHECK_LICENSE_TYPE = "design_1_axi_ip_demo_0_0,axi_ip_demo_v1_0,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "axi_ip_demo_v1_0,Vivado 2017.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (axi_ip_demo_awaddr,
    axi_ip_demo_awprot,
    axi_ip_demo_awvalid,
    axi_ip_demo_awready,
    axi_ip_demo_wdata,
    axi_ip_demo_wstrb,
    axi_ip_demo_wvalid,
    axi_ip_demo_wready,
    axi_ip_demo_bresp,
    axi_ip_demo_bvalid,
    axi_ip_demo_bready,
    axi_ip_demo_araddr,
    axi_ip_demo_arprot,
    axi_ip_demo_arvalid,
    axi_ip_demo_arready,
    axi_ip_demo_rdata,
    axi_ip_demo_rresp,
    axi_ip_demo_rvalid,
    axi_ip_demo_rready,
    axi_ip_demo_aclk,
    axi_ip_demo_aresetn);
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 axi_ip_demo AWADDR" *) input [3:0]axi_ip_demo_awaddr;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 axi_ip_demo AWPROT" *) input [2:0]axi_ip_demo_awprot;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 axi_ip_demo AWVALID" *) input axi_ip_demo_awvalid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 axi_ip_demo AWREADY" *) output axi_ip_demo_awready;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 axi_ip_demo WDATA" *) input [31:0]axi_ip_demo_wdata;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 axi_ip_demo WSTRB" *) input [3:0]axi_ip_demo_wstrb;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 axi_ip_demo WVALID" *) input axi_ip_demo_wvalid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 axi_ip_demo WREADY" *) output axi_ip_demo_wready;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 axi_ip_demo BRESP" *) output [1:0]axi_ip_demo_bresp;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 axi_ip_demo BVALID" *) output axi_ip_demo_bvalid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 axi_ip_demo BREADY" *) input axi_ip_demo_bready;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 axi_ip_demo ARADDR" *) input [3:0]axi_ip_demo_araddr;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 axi_ip_demo ARPROT" *) input [2:0]axi_ip_demo_arprot;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 axi_ip_demo ARVALID" *) input axi_ip_demo_arvalid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 axi_ip_demo ARREADY" *) output axi_ip_demo_arready;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 axi_ip_demo RDATA" *) output [31:0]axi_ip_demo_rdata;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 axi_ip_demo RRESP" *) output [1:0]axi_ip_demo_rresp;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 axi_ip_demo RVALID" *) output axi_ip_demo_rvalid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 axi_ip_demo RREADY" *) input axi_ip_demo_rready;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 axi_ip_demo_CLK CLK" *) input axi_ip_demo_aclk;
  (* x_interface_info = "xilinx.com:signal:reset:1.0 axi_ip_demo_RST RST" *) input axi_ip_demo_aresetn;

  wire \<const0> ;
  wire axi_ip_demo_aclk;
  wire [3:0]axi_ip_demo_araddr;
  wire axi_ip_demo_aresetn;
  wire axi_ip_demo_arready;
  wire axi_ip_demo_arvalid;
  wire [3:0]axi_ip_demo_awaddr;
  wire axi_ip_demo_awready;
  wire axi_ip_demo_awvalid;
  wire axi_ip_demo_bready;
  wire axi_ip_demo_bvalid;
  wire [31:0]axi_ip_demo_rdata;
  wire axi_ip_demo_rready;
  wire axi_ip_demo_rvalid;
  wire [31:0]axi_ip_demo_wdata;
  wire axi_ip_demo_wready;
  wire [3:0]axi_ip_demo_wstrb;
  wire axi_ip_demo_wvalid;

  assign axi_ip_demo_bresp[1] = \<const0> ;
  assign axi_ip_demo_bresp[0] = \<const0> ;
  assign axi_ip_demo_rresp[1] = \<const0> ;
  assign axi_ip_demo_rresp[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_axi_ip_demo_v1_0 U0
       (.axi_ip_demo_aclk(axi_ip_demo_aclk),
        .axi_ip_demo_araddr(axi_ip_demo_araddr[3:2]),
        .axi_ip_demo_aresetn(axi_ip_demo_aresetn),
        .axi_ip_demo_arready(axi_ip_demo_arready),
        .axi_ip_demo_arvalid(axi_ip_demo_arvalid),
        .axi_ip_demo_awaddr(axi_ip_demo_awaddr[3:2]),
        .axi_ip_demo_awready(axi_ip_demo_awready),
        .axi_ip_demo_awvalid(axi_ip_demo_awvalid),
        .axi_ip_demo_bready(axi_ip_demo_bready),
        .axi_ip_demo_bvalid(axi_ip_demo_bvalid),
        .axi_ip_demo_rdata(axi_ip_demo_rdata),
        .axi_ip_demo_rready(axi_ip_demo_rready),
        .axi_ip_demo_rvalid(axi_ip_demo_rvalid),
        .axi_ip_demo_wdata(axi_ip_demo_wdata),
        .axi_ip_demo_wready(axi_ip_demo_wready),
        .axi_ip_demo_wstrb(axi_ip_demo_wstrb),
        .axi_ip_demo_wvalid(axi_ip_demo_wvalid));
endmodule

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_pop_count
   (A,
    ones);
  input [31:0]A;
  output [5:0]ones;


endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
