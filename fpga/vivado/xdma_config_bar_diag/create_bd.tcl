set script_dir [file dirname [file normalize [info script]]]
set repo_root [file normalize [file join $script_dir ".." ".." ".."]]
set project_dir [file normalize [file join $script_dir ".." ".build" "xdma_diag_bd"]]
set target_part "xc7z100ffg900-2"
set design_name "xdma_diag"

set user_args $argv
if {[llength $user_args] >= 1 && [string length [lindex $user_args 0]] > 0} {
    set project_dir [file normalize [lindex $user_args 0]]
}
if {[llength $user_args] >= 2 && [string length [lindex $user_args 1]] > 0} {
    set target_part [lindex $user_args 1]
}

proc first_addr_seg {pattern} {
    set segs [get_bd_addr_segs -quiet $pattern]
    if {[llength $segs] == 0} {
        error "No address segment matches: $pattern"
    }
    return [lindex $segs 0]
}

proc first_addr_space {pattern} {
    set spaces [get_bd_addr_spaces -quiet $pattern]
    if {[llength $spaces] == 0} {
        error "No address space matches: $pattern"
    }
    return [lindex $spaces 0]
}

file mkdir $project_dir
cd $project_dir

create_project -force xdma_diag $project_dir -part $target_part

add_files -norecurse [file join $script_dir "diag_axi_lite_regs.v"]
add_files -fileset constrs_1 -norecurse [file join $script_dir "xdma_config_bar_diag.xdc"]
update_compile_order -fileset sources_1

create_bd_design $design_name

set pcie_mgt [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie_mgt]
set pcie_ref [create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 pcie_ref]
set_property CONFIG.FREQ_HZ {100000000} $pcie_ref

set pcie_rst_n [create_bd_port -dir I -type rst pcie_rst_n]
set_property CONFIG.POLARITY {ACTIVE_LOW} $pcie_rst_n

set util_ds_buf_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_0]
set_property CONFIG.C_BUF_TYPE {IBUFDSGTE} $util_ds_buf_0

set xdma_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:xdma:4.1 xdma_0]
set_property -dict [list \
    CONFIG.axi_data_width {64_bit} \
    CONFIG.axilite_master_en {true} \
    CONFIG.axilite_master_scale {Kilobytes} \
    CONFIG.axilite_master_size {64} \
    CONFIG.axisten_freq {250} \
    CONFIG.enable_lane_reversal {true} \
    CONFIG.mode_selection {Basic} \
    CONFIG.pcie_id_if {false} \
    CONFIG.pf0_device_id {7024} \
    CONFIG.pl_link_cap_max_link_speed {5.0_GT/s} \
    CONFIG.pl_link_cap_max_link_width {X4} \
    CONFIG.plltype {QPLL1} \
] $xdma_0

set diag_regs_0 [create_bd_cell -type module -reference diag_axi_lite_regs diag_regs_0]

set axi_bram_ctrl_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0]
set_property -dict [list CONFIG.DATA_WIDTH {64} CONFIG.SINGLE_PORT_BRAM {1}] $axi_bram_ctrl_0
set axi_bram_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 axi_bram_0]

connect_bd_intf_net [get_bd_intf_ports pcie_ref] [get_bd_intf_pins util_ds_buf_0/CLK_IN_D]
connect_bd_net [get_bd_pins util_ds_buf_0/IBUF_OUT] [get_bd_pins xdma_0/sys_clk]
connect_bd_net [get_bd_ports pcie_rst_n] [get_bd_pins xdma_0/sys_rst_n]
connect_bd_intf_net [get_bd_intf_ports pcie_mgt] [get_bd_intf_pins xdma_0/pcie_mgt]

connect_bd_net [get_bd_pins xdma_0/axi_aclk] \
    [get_bd_pins diag_regs_0/s_axi_aclk] \
    [get_bd_pins axi_bram_ctrl_0/s_axi_aclk]
connect_bd_net [get_bd_pins xdma_0/axi_aresetn] \
    [get_bd_pins diag_regs_0/s_axi_aresetn] \
    [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn]

connect_bd_intf_net [get_bd_intf_pins xdma_0/M_AXI_LITE] [get_bd_intf_pins diag_regs_0/S_AXI]
connect_bd_intf_net [get_bd_intf_pins xdma_0/M_AXI] [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins axi_bram_0/BRAM_PORTA]

set reg_seg [first_addr_seg "diag_regs_0/S_AXI/*"]
create_bd_addr_seg -range 0x00010000 -offset 0x00000000 [first_addr_space "xdma_0/M_AXI_LITE"] $reg_seg SEG_diag_regs_0_Reg

set bram_seg [first_addr_seg "axi_bram_ctrl_0/S_AXI/*"]
create_bd_addr_seg -range 0x00010000 -offset 0x00000000 [first_addr_space "xdma_0/M_AXI"] $bram_seg SEG_axi_bram_ctrl_0_Mem

validate_bd_design
save_bd_design

set bd_file [get_files -of_objects [get_filesets sources_1] *${design_name}.bd]
generate_target all $bd_file
make_wrapper -files $bd_file -top -import

set wrapper_file [get_files *${design_name}_wrapper.v]
set_property top ${design_name}_wrapper [current_fileset]
update_compile_order -fileset sources_1

report_ip_status -file [file join $project_dir "xdma_config_bar_diag_ip_status.rpt"]
report_property -file [file join $project_dir "xdma_config_bar_diag_xdma_bd_properties.rpt"] $xdma_0

set xdma_ips [get_ips -quiet *xdma*]
if {[llength $xdma_ips] > 0} {
    report_property -file [file join $project_dir "xdma_config_bar_diag_xdma_ip_properties.rpt"] [lindex $xdma_ips 0]
}

puts "XDMA_CONFIG_BAR_DIAG_BD_VALIDATE_PASS"
puts "Project: $project_dir"
puts "Wrapper: $wrapper_file"
puts "XDMA diag: Gen2 X4, 64-bit AXI, 250 MHz AXI target, AXI-Lite master enabled, lane reversal enabled, no manual MSI-X BIR override"
