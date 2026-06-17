set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

# PCIe reset, active low.
set_property PACKAGE_PIN AB22 [get_ports pcie_rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports pcie_rst_n]

# PCIe endpoint reference clock from Orin/root complex, 100 MHz.
set_property PACKAGE_PIN N8 [get_ports {pcie_ref_clk_p[0]}]
set_property PACKAGE_PIN N7 [get_ports {pcie_ref_clk_n[0]}]

# AX7Z100 PL DDR3/MIG system clock, board differential 200 MHz.
set_property PACKAGE_PIN F9 [get_ports {sys_clk_p}]
set_property PACKAGE_PIN E8 [get_ports {sys_clk_n}]

