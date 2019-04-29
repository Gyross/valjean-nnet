@echo off
set xv_path=C:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xelab  -wto f0e208fec59240c3bfacd3b1eddcfe83 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot axi_tb_behav xil_defaultlib.axi_tb -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
