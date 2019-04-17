--Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
--Date        : Thu Mar  7 13:48:56 2019
--Host        : cse-Win7 running 64-bit Service Pack 1  (build 7601)
--Command     : generate_target fifo_wrapper.bd
--Design      : fifo_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity fifo_wrapper is
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
end fifo_wrapper;

architecture STRUCTURE of fifo_wrapper is
  component fifo is
  port (
    clk : in STD_LOGIC;
    srst : in STD_LOGIC;
    FIFO_READ_empty : out STD_LOGIC;
    FIFO_READ_rd_data : out STD_LOGIC_VECTOR ( 17 downto 0 );
    FIFO_READ_rd_en : in STD_LOGIC;
    FIFO_WRITE_full : out STD_LOGIC;
    FIFO_WRITE_wr_data : in STD_LOGIC_VECTOR ( 17 downto 0 );
    FIFO_WRITE_wr_en : in STD_LOGIC
  );
  end component fifo;
begin
fifo_i: component fifo
     port map (
      FIFO_READ_empty => FIFO_READ_empty,
      FIFO_READ_rd_data(17 downto 0) => FIFO_READ_rd_data(17 downto 0),
      FIFO_READ_rd_en => FIFO_READ_rd_en,
      FIFO_WRITE_full => FIFO_WRITE_full,
      FIFO_WRITE_wr_data(17 downto 0) => FIFO_WRITE_wr_data(17 downto 0),
      FIFO_WRITE_wr_en => FIFO_WRITE_wr_en,
      clk => clk,
      srst => srst
    );
end STRUCTURE;
