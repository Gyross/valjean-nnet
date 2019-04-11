

proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "axi_ip_demo" "NUM_INSTANCES" "DEVICE_ID"  "C_axi_ip_demo_BASEADDR" "C_axi_ip_demo_HIGHADDR"
}
