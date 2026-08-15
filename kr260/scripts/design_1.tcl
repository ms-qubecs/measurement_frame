proc create_root_design { parentCell } {
    
    create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.5 zynq_ultra_ps_e_0
    
    apply_bd_automation \
	-rule xilinx.com:bd_rule:zynq_ultra_ps_e \
	-config {apply_board_preset "1" }  \
	[get_bd_cells zynq_ultra_ps_e_0]
    
    connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_fpd_aclk]
    connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk1] [get_bd_pins zynq_ultra_ps_e_0/maxihpm1_fpd_aclk]

    set_property -dict [list \
			    CONFIG.PSU__DP__LANE_SEL {Single Lower} \
			    CONFIG.PSU__I2C1__PERIPHERAL__ENABLE {1} \
			    CONFIG.PSU__I2C1__PERIPHERAL__IO {MIO 24 .. 25} \
			    CONFIG.PSU__UART1__PERIPHERAL__ENABLE {1} \
			    CONFIG.PSU__UART1__PERIPHERAL__IO {MIO 36 .. 37} \
			    CONFIG.PSU__USB0__PERIPHERAL__ENABLE {1} \
			    CONFIG.PSU__USB0__RESET__ENABLE {1} \
			    CONFIG.PSU__USB0__RESET__IO {MIO 76} \
			    CONFIG.PSU__USB1__PERIPHERAL__ENABLE {1} \
			    CONFIG.PSU__USB1__RESET__ENABLE {1} \
			    CONFIG.PSU__USB1__RESET__IO {MIO 77} \
			    CONFIG.PSU__USB3_0__PERIPHERAL__ENABLE {1} \
			    CONFIG.PSU__USB3_0__PERIPHERAL__IO {GT Lane2} \
			    CONFIG.PSU__USB3_1__PERIPHERAL__ENABLE {1} \
			    CONFIG.PSU__USB__RESET__MODE {Separate MIO Pin} \
			   ] [get_bd_cells zynq_ultra_ps_e_0]
    

    validate_bd_design
    regenerate_bd_layout
    
    save_bd_design
    
    close_bd_design [get_bd_designs design_1]
}
