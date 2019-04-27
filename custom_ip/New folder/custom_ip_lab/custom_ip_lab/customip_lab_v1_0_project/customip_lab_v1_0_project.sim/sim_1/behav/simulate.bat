@echo off
set xv_path=C:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xsim axi_tb_behav -key {Behavioral:sim_1:Functional:axi_tb} -tclbatch axi_tb.tcl -view C:/Users/X4/Documents/GitHub/valjean-nnet/custom_ip/New folder/custom_ip_lab/custom_ip_lab/customip_lab_v1_0_project/axi_tb_behav3.wcfg -view C:/Users/X4/Documents/GitHub/valjean-nnet/axi_tb_behav4.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
