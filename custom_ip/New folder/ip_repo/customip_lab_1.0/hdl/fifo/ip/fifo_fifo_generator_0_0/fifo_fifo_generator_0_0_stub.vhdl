-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
-- Date        : Thu Mar  7 13:50:24 2019
-- Host        : cse-Win7 running 64-bit Service Pack 1  (build 7601)
-- Command     : write_vhdl -force -mode synth_stub
--               c:/Users/cse/cs4601/ip_repo/customip_lab_1.0/hdl/fifo/ip/fifo_fifo_generator_0_0/fifo_fifo_generator_0_0_stub.vhdl
-- Design      : fifo_fifo_generator_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fifo_fifo_generator_0_0 is
  Port ( 
    clk : in STD_LOGIC;
    srst : in STD_LOGIC;
    din : in STD_LOGIC_VECTOR ( 17 downto 0 );
    wr_en : in STD_LOGIC;
    rd_en : in STD_LOGIC;
    dout : out STD_LOGIC_VECTOR ( 17 downto 0 );
    full : out STD_LOGIC;
    empty : out STD_LOGIC
  );

end fifo_fifo_generator_0_0;

architecture stub of fifo_fifo_generator_0_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,srst,din[17:0],wr_en,rd_en,dout[17:0],full,empty";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "fifo_generator_v13_1_4,Vivado 2017.2";
begin
end;
