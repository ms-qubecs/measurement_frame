set_property PACKAGE_PIN T2 [get_ports {gt_rxp_in}]; # GTH_DP2_C2M_P - SOM240_2 B1 - T2
set_property PACKAGE_PIN T1 [get_ports {gt_rxn_in}]; # GTH_DP2_C2M_N - SOM240_2 B2 - T1
set_property PACKAGE_PIN R4 [get_ports {gt_txp_out}]; # GTH_DP2_M2C_P - SOM240_2 B5 - R4
set_property PACKAGE_PIN R3 [get_ports {gt_txn_out}]; # GTH_DP2_M2C_N - SOM240_2 B6 - R3

set_property -dict {PACKAGE_PIN Y10 IOSTANDARD LVCMOS33} [get_ports SFP0_TX_DISABLE_B]; # HDB19 - SOM240_2 A47

set_property PACKAGE_PIN Y6 [get_ports gt_refclk_p]; # GTH_REFCLK0_C2M_P - SOM240_2 C3 - Y6
set_property PACKAGE_PIN Y5 [get_ports gt_refclk_n]; # GTH_REFCLK0_C2M_N - SOM240_2 C4 - Y5
# create_clock -period 6.206  -name gtrefclk0 [get_ports "gt_refclk_p"]

set_property -dict {PACKAGE_PIN C3 IOSTANDARD LVCMOS18} [get_ports SYSCLK]; # HPA_CLK0P_CLK - SOM240_1 A6 - C3
# create_clock -period 40.000 -name sysclk3 [get_ports "SYSCLK"]

set_false_path -from [get_clocks -of_objects [get_pins clk_wiz_0_i/inst/mmcme4_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins xxv_ethernet_0_i/inst/i_core_gtwiz_userclk_rx_inst_0/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk2_inst/O]]
set_false_path -from [get_clocks -of_objects [get_pins clk_wiz_0_i/inst/mmcme4_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins xxv_ethernet_0_i/inst/i_core_gtwiz_userclk_tx_inst_0/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk2_inst/O]]
set_false_path -from [get_clocks -of_objects [get_pins xxv_ethernet_0_i/inst/i_core_gtwiz_userclk_rx_inst_0/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk2_inst/O]] -to [get_clocks -of_objects [get_pins clk_wiz_0_i/inst/mmcme4_adv_inst/CLKOUT0]]
set_false_path -from [get_clocks -of_objects [get_pins xxv_ethernet_0_i/inst/i_core_gtwiz_userclk_rx_inst_0/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk2_inst/O]] -to [get_clocks -of_objects [get_pins xxv_ethernet_0_i/inst/i_core_gtwiz_userclk_tx_inst_0/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk2_inst/O]]
set_false_path -from [get_clocks -of_objects [get_pins xxv_ethernet_0_i/inst/i_core_gtwiz_userclk_tx_inst_0/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk2_inst/O]] -to [get_clocks -of_objects [get_pins clk_wiz_0_i/inst/mmcme4_adv_inst/CLKOUT0]]
set_false_path -from [get_clocks -of_objects [get_pins xxv_ethernet_0_i/inst/i_core_gtwiz_userclk_tx_inst_0/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk2_inst/O]] -to [get_clocks -of_objects [get_pins xxv_ethernet_0_i/inst/i_core_gtwiz_userclk_rx_inst_0/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk2_inst/O]]

set_property -dict {PACKAGE_PIN Y10 IOSTANDARD LVCMOS33} [get_ports SFP0_TX_DISABLE_B]; # HDB19 - SOM240_2 A47

set_property -dict {PACKAGE_PIN H12 IOSTANDARD LVCMOS33} [get_ports "pmod_a[0]"]
set_property -dict {PACKAGE_PIN E10 IOSTANDARD LVCMOS33} [get_ports "pmod_a[1]"]
set_property -dict {PACKAGE_PIN D10 IOSTANDARD LVCMOS33} [get_ports "pmod_a[2]"]
set_property -dict {PACKAGE_PIN C11 IOSTANDARD LVCMOS33} [get_ports "pmod_a[3]"]
set_property -dict {PACKAGE_PIN B10 IOSTANDARD LVCMOS33} [get_ports "pmod_a[4]"]
set_property -dict {PACKAGE_PIN E12 IOSTANDARD LVCMOS33} [get_ports "pmod_a[5]"]
set_property -dict {PACKAGE_PIN D11 IOSTANDARD LVCMOS33} [get_ports "pmod_a[6]"]
set_property -dict {PACKAGE_PIN B11 IOSTANDARD LVCMOS33} [get_ports "pmod_a[7]"]

set_property -dict {PACKAGE_PIN F8 IOSTANDARD LVCMOS18} [get_ports "USER_LED[0]"]; # HPA14P; som240_1_d13
set_property -dict {PACKAGE_PIN E8 IOSTANDARD LVCMOS18} [get_ports "USER_LED[1]"]; # HPA14N; som240_1_d14
