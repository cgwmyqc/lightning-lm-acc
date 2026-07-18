set script_dir [file dirname [file normalize [info script]]]
set repo_root [file normalize [file join $script_dir ".." ".." ".."]]
set reference_root [file normalize [file join $repo_root ".."]]
set project_dir [file normalize [file join $script_dir ".." ".build" "azmig_bd"]]
set target_part "xc7z100ffg900-2"
set hls_ip_dir [file normalize [file join $repo_root "fpga" "vivado" ".build" "hls_unified_obs" "solution1" "impl" "ip"]]
set ekf_hls_ip_dir [file normalize [file join $repo_root "fpga" "vivado" ".build" "hls_slam_ekf_update_export" "solution1" "impl" "ip"]]
set design_name "azmig"

set user_args $argv
if {[llength $user_args] >= 1 && [string length [lindex $user_args 0]] > 0} {
    set project_dir [file normalize [lindex $user_args 0]]
}
if {[llength $user_args] >= 2 && [string length [lindex $user_args 1]] > 0} {
    set target_part [lindex $user_args 1]
}
if {[llength $user_args] >= 3 && [string length [lindex $user_args 2]] > 0} {
    set hls_ip_dir [file normalize [lindex $user_args 2]]
}
if {[llength $user_args] >= 4 && [string length [lindex $user_args 3]] > 0} {
    set ekf_hls_ip_dir [file normalize [lindex $user_args 3]]
}
if {[llength $user_args] >= 5 && [string length [lindex $user_args 4]] > 0} {
    set reference_root [file normalize [lindex $user_args 4]]
}

set component_xml [file join $hls_ip_dir "component.xml"]
if {![file exists $component_xml]} {
    error "Missing HLS IP component.xml: $component_xml"
}
set ekf_component_xml [file join $ekf_hls_ip_dir "component.xml"]
if {![file exists $ekf_component_xml]} {
    error "Missing EKF HLS IP component.xml: $ekf_component_xml"
}

set mig_source_prj [file join $reference_root "12_ddr3_pl" "mig_a.prj"]
if {![file exists $mig_source_prj]} {
    error "Missing AX7Z100 MIG reference project file: $mig_source_prj"
}
set mig_axi_source_tcl [file join $reference_root "33_PCIe_test" "Vivado" "auto_create_project" "pl_config.tcl"]
if {![file exists $mig_axi_source_tcl]} {
    error "Missing AX7Z100 AXI MIG reference Tcl: $mig_axi_source_tcl"
}

proc derive_axi_mig_prj {native_source_path axi_source_tcl dest_path module_name} {
    set fh [open $native_source_path r]
    set native_text [read $fh]
    close $fh

    foreach required {
        "<TargetFPGA>xc7z100-ffg900/-2</TargetFPGA>"
        "<InputClkFreq>200</InputClkFreq>"
        "<DataWidth>32</DataWidth>"
        "<TimePeriod>1250</TimePeriod>"
    } {
        if {[string first $required $native_text] < 0} {
            error "MIG native source check failed: $required"
        }
    }

    # Vivado 2018.3 MIG can crash if a NATIVE .prj is modified into AXI form
    # too late. Extract ALINX's known-good AXI MIG XML payload from 33_PCIe_test
    # while keeping the 12_ddr3_pl native .prj as the static board-parameter
    # reference above.
    set fh [open $axi_source_tcl r]
    set tcl_text [read $fh]
    close $fh

    set text ""
    foreach line [split $tcl_text "\n"] {
        if {[regexp {puts \$mig_prj_file \{(.*)\}} $line -> payload]} {
            append text $payload "\n"
        }
    }
    if {[string length $text] == 0} {
        error "Failed to extract AXI MIG XML from $axi_source_tcl"
    }

    foreach required {
        "<TargetFPGA>xc7z100-ffg900/-2</TargetFPGA>"
        "<InputClkFreq>200</InputClkFreq>"
        "<DataWidth>32</DataWidth>"
        "<TimePeriod>1250</TimePeriod>"
        "<PortInterface>AXI</PortInterface>"
        "<C0_S_AXI_DATA_WIDTH>256</C0_S_AXI_DATA_WIDTH>"
    } {
        if {[string first $required $text] < 0} {
            error "AXI MIG source check failed: $required"
        }
    }

    regsub {<ModuleName>[^<]+</ModuleName>} $text "<ModuleName>${module_name}</ModuleName>" text

    file mkdir [file dirname $dest_path]
    set out [open $dest_path w]
    puts $out $text
    close $out
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

create_project -force azmig $project_dir -part $target_part
set_property ip_repo_paths [list $hls_ip_dir $ekf_hls_ip_dir] [current_project]
update_ip_catalog

add_files -norecurse [list \
    [file join $repo_root "fpga" "rtl" "slam_accel_ctrl" "slam_accel_ctrl.v"] \
    [file join $script_dir "slam_accel_ctrl_axi_lite_wrapper.v"] \
    [file join $repo_root "fpga" "vivado" "xdma_restore_chain" "xdma_restore_bar_shim_ctrl_wrapper.v"] \
]
add_files -fileset constrs_1 -norecurse [file join $script_dir "slam_accel_ax7z100_pcie_mig.xdc"]
update_compile_order -fileset sources_1

create_bd_design $design_name

set pcie_mgt [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie_mgt]
set pcie_ref [create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 pcie_ref]
set_property CONFIG.FREQ_HZ {100000000} $pcie_ref
set sys_clk [create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sys]
set_property CONFIG.FREQ_HZ {200000000} $sys_clk
set ddr3 [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 ddr3]

set pcie_rst_n [create_bd_port -dir I -type rst pcie_rst_n]
set_property CONFIG.POLARITY {ACTIVE_LOW} $pcie_rst_n

set ctrl [create_bd_cell -type module -reference xdma_restore_bar_shim_ctrl_wrapper ctrl_0]
set hls [create_bd_cell -type ip -vlnv xilinx.com:hls:unified_surfel_observation_core:1.0 unified_obs_0]
set ekf_hls [create_bd_cell -type ip -vlnv xilinx.com:hls:slam_ekf_update_core:1.0 ekf_update_0]
set zero32 [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_zero_32]
set_property -dict [list CONFIG.CONST_WIDTH {32} CONFIG.CONST_VAL {0}] $zero32
set mig_rst_hi [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 mig_rst_hi]
set_property -dict [list CONFIG.CONST_WIDTH {1} CONFIG.CONST_VAL {1}] $mig_rst_hi

set util_ds_buf_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_0]
set_property CONFIG.C_BUF_TYPE {IBUFDSGTE} $util_ds_buf_0

set mig_7series_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series:4.2 mig_7series_0]
set mig_ip_dir [get_property IP_DIR [get_ips [get_property CONFIG.Component_Name $mig_7series_0]]]
set mig_prj_name "mig_ax7z100_pl_ddr3_axi.prj"
set mig_prj_path [file join $mig_ip_dir $mig_prj_name]
derive_axi_mig_prj $mig_source_prj $mig_axi_source_tcl $mig_prj_path "azmig_mig_0"
set_property -dict [list \
    CONFIG.BOARD_MIG_PARAM {Custom} \
    CONFIG.RESET_BOARD_INTERFACE {Custom} \
    CONFIG.XML_INPUT_FILE $mig_prj_name \
] $mig_7series_0

set xdma_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:xdma:4.1 xdma_0]
set_property -dict [list \
    CONFIG.axi_data_width {128_bit} \
    CONFIG.axilite_master_en {true} \
    CONFIG.axilite_master_scale {Kilobytes} \
    CONFIG.axilite_master_size {64} \
    CONFIG.axisten_freq {125} \
    CONFIG.enable_lane_reversal {true} \
    CONFIG.mode_selection {Basic} \
    CONFIG.pcie_id_if {false} \
    CONFIG.pf0_device_id {7024} \
    CONFIG.pl_link_cap_max_link_speed {5.0_GT/s} \
    CONFIG.pl_link_cap_max_link_width {X4} \
    CONFIG.plltype {QPLL1} \
] $xdma_0

set mem_ic [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 mem_axi_ic]
set_property -dict [list CONFIG.NUM_SI {8} CONFIG.NUM_MI {1}] $mem_ic

set rst_mig_ui [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_mig_ui]

connect_bd_intf_net [get_bd_intf_ports pcie_ref] [get_bd_intf_pins util_ds_buf_0/CLK_IN_D]
connect_bd_net [get_bd_pins util_ds_buf_0/IBUF_OUT] [get_bd_pins xdma_0/sys_clk]
connect_bd_net [get_bd_ports pcie_rst_n] [get_bd_pins xdma_0/sys_rst_n]
connect_bd_net [get_bd_pins mig_rst_hi/dout] [get_bd_pins mig_7series_0/sys_rst]
connect_bd_intf_net [get_bd_intf_ports pcie_mgt] [get_bd_intf_pins xdma_0/pcie_mgt]

connect_bd_intf_net [get_bd_intf_ports sys] [get_bd_intf_pins mig_7series_0/SYS_CLK]
connect_bd_intf_net [get_bd_intf_ports ddr3] [get_bd_intf_pins mig_7series_0/DDR3]
connect_bd_net [get_bd_pins mig_7series_0/ui_clk] [get_bd_pins rst_mig_ui/slowest_sync_clk]
connect_bd_net [get_bd_pins mig_7series_0/mmcm_locked] [get_bd_pins rst_mig_ui/dcm_locked]
connect_bd_net [get_bd_pins mig_7series_0/ui_clk_sync_rst] [get_bd_pins rst_mig_ui/ext_reset_in]

connect_bd_net [get_bd_pins xdma_0/axi_aclk] [get_bd_pins ctrl_0/aclk] [get_bd_pins unified_obs_0/ap_clk] [get_bd_pins ekf_update_0/ap_clk]
connect_bd_net [get_bd_pins xdma_0/axi_aresetn] [get_bd_pins ctrl_0/aresetn] [get_bd_pins unified_obs_0/ap_rst_n] [get_bd_pins ekf_update_0/ap_rst_n]
connect_bd_net [get_bd_pins const_zero_32/dout] [get_bd_pins ctrl_0/unified_obs_error] [get_bd_pins ctrl_0/ekf_error]

connect_bd_net [get_bd_pins ctrl_0/unified_obs_ap_start] [get_bd_pins unified_obs_0/ap_start]
connect_bd_net [get_bd_pins unified_obs_0/ap_done] [get_bd_pins ctrl_0/unified_obs_ap_done]
connect_bd_net [get_bd_pins unified_obs_0/ap_idle] [get_bd_pins ctrl_0/unified_obs_ap_idle]
connect_bd_net [get_bd_pins unified_obs_0/ap_ready] [get_bd_pins ctrl_0/unified_obs_ap_ready]

connect_bd_net [get_bd_pins ctrl_0/unified_obs_num_points] [get_bd_pins unified_obs_0/num_points]
connect_bd_net [get_bd_pins ctrl_0/unified_obs_scan_points_addr] [get_bd_pins unified_obs_0/scan_points]
connect_bd_net [get_bd_pins ctrl_0/unified_obs_pose_addr] [get_bd_pins unified_obs_0/pose]
connect_bd_net [get_bd_pins ctrl_0/unified_obs_map_header_addr] [get_bd_pins unified_obs_0/map_header]
connect_bd_net [get_bd_pins ctrl_0/unified_obs_params_addr] [get_bd_pins unified_obs_0/params]
connect_bd_net [get_bd_pins ctrl_0/unified_obs_active_blocks_addr] [get_bd_pins unified_obs_0/active_blocks]
connect_bd_net [get_bd_pins ctrl_0/unified_obs_obs_cells_addr] [get_bd_pins unified_obs_0/obs_cells]
connect_bd_net [get_bd_pins ctrl_0/unified_obs_output_addr] [get_bd_pins unified_obs_0/output_words]

connect_bd_net [get_bd_pins ctrl_0/ekf_ap_start] [get_bd_pins ekf_update_0/ap_start]
connect_bd_net [get_bd_pins ekf_update_0/ap_done] [get_bd_pins ctrl_0/ekf_ap_done]
connect_bd_net [get_bd_pins ekf_update_0/ap_idle] [get_bd_pins ctrl_0/ekf_ap_idle]
connect_bd_net [get_bd_pins ekf_update_0/ap_ready] [get_bd_pins ctrl_0/ekf_ap_ready]
connect_bd_net [get_bd_pins ctrl_0/ekf_input_addr] [get_bd_pins ekf_update_0/input_words]
connect_bd_net [get_bd_pins ctrl_0/ekf_output_addr] [get_bd_pins ekf_update_0/output_words]

connect_bd_intf_net [get_bd_intf_pins xdma_0/M_AXI_LITE] [get_bd_intf_pins ctrl_0/S_AXI]

connect_bd_intf_net [get_bd_intf_pins xdma_0/M_AXI] [get_bd_intf_pins mem_axi_ic/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins unified_obs_0/m_axi_gmem0] [get_bd_intf_pins mem_axi_ic/S01_AXI]
connect_bd_intf_net [get_bd_intf_pins unified_obs_0/m_axi_gmem1] [get_bd_intf_pins mem_axi_ic/S02_AXI]
connect_bd_intf_net [get_bd_intf_pins unified_obs_0/m_axi_gmem2] [get_bd_intf_pins mem_axi_ic/S03_AXI]
connect_bd_intf_net [get_bd_intf_pins unified_obs_0/m_axi_gmem3] [get_bd_intf_pins mem_axi_ic/S04_AXI]
connect_bd_intf_net [get_bd_intf_pins unified_obs_0/m_axi_gmem4] [get_bd_intf_pins mem_axi_ic/S05_AXI]
connect_bd_intf_net [get_bd_intf_pins ekf_update_0/m_axi_gmem0] [get_bd_intf_pins mem_axi_ic/S06_AXI]
connect_bd_intf_net [get_bd_intf_pins ekf_update_0/m_axi_gmem1] [get_bd_intf_pins mem_axi_ic/S07_AXI]
connect_bd_intf_net [get_bd_intf_pins mem_axi_ic/M00_AXI] [get_bd_intf_pins mig_7series_0/S_AXI]

connect_bd_net [get_bd_pins xdma_0/axi_aclk] \
    [get_bd_pins mem_axi_ic/ACLK] \
    [get_bd_pins mem_axi_ic/S00_ACLK] \
    [get_bd_pins mem_axi_ic/S01_ACLK] \
    [get_bd_pins mem_axi_ic/S02_ACLK] \
    [get_bd_pins mem_axi_ic/S03_ACLK] \
    [get_bd_pins mem_axi_ic/S04_ACLK] \
    [get_bd_pins mem_axi_ic/S05_ACLK] \
    [get_bd_pins mem_axi_ic/S06_ACLK] \
    [get_bd_pins mem_axi_ic/S07_ACLK]
connect_bd_net [get_bd_pins xdma_0/axi_aresetn] \
    [get_bd_pins mem_axi_ic/ARESETN] \
    [get_bd_pins mem_axi_ic/S00_ARESETN] \
    [get_bd_pins mem_axi_ic/S01_ARESETN] \
    [get_bd_pins mem_axi_ic/S02_ARESETN] \
    [get_bd_pins mem_axi_ic/S03_ARESETN] \
    [get_bd_pins mem_axi_ic/S04_ARESETN] \
    [get_bd_pins mem_axi_ic/S05_ARESETN] \
    [get_bd_pins mem_axi_ic/S06_ARESETN] \
    [get_bd_pins mem_axi_ic/S07_ARESETN]
connect_bd_net [get_bd_pins mig_7series_0/ui_clk] [get_bd_pins mem_axi_ic/M00_ACLK]
connect_bd_net [get_bd_pins rst_mig_ui/peripheral_aresetn] [get_bd_pins mem_axi_ic/M00_ARESETN] [get_bd_pins mig_7series_0/aresetn]

set mig_mem [first_addr_seg "mig_7series_0/memmap/memaddr"]
create_bd_addr_seg -range 0x40000000 -offset 0x00000000 [first_addr_space "xdma_0/M_AXI"] $mig_mem SEG_xdma_0_M_AXI_PL_DDR3
foreach idx {0 1 2 3 4} {
    set space [first_addr_space "unified_obs_0/Data_m_axi_gmem${idx}"]
    create_bd_addr_seg -range 0x40000000 -offset 0x00000000 $space $mig_mem SEG_unified_obs_gmem${idx}_PL_DDR3
}
foreach idx {0 1} {
    set space [first_addr_space "ekf_update_0/Data_m_axi_gmem${idx}"]
    create_bd_addr_seg -range 0x40000000 -offset 0x00000000 $space $mig_mem SEG_ekf_update_gmem${idx}_PL_DDR3
}

set ctrl_seg [first_addr_seg "ctrl_0/S_AXI/*"]
create_bd_addr_seg -range 0x00010000 -offset 0x00000000 [first_addr_space "xdma_0/M_AXI_LITE"] $ctrl_seg SEG_ctrl_0_Reg

validate_bd_design
save_bd_design

set bd_file [get_files -of_objects [get_filesets sources_1] *${design_name}.bd]
generate_target all $bd_file
make_wrapper -files $bd_file -top -import

set wrapper_file [get_files *${design_name}_wrapper.v]
set_property top ${design_name}_wrapper [current_fileset]
update_compile_order -fileset sources_1

report_ip_status -file [file join $project_dir "ax7z100_pcie_mig_ip_status.rpt"]
report_property -file [file join $project_dir "ax7z100_pcie_mig_xdma_bd_properties.rpt"] $xdma_0

set xdma_ips [get_ips -quiet *xdma*]
if {[llength $xdma_ips] > 0} {
    report_property -file [file join $project_dir "ax7z100_pcie_mig_xdma_ip_properties.rpt"] [lindex $xdma_ips 0]
}

set external_hls_axi [get_bd_intf_ports -quiet *m_axi_gmem*]
if {[llength $external_hls_axi] != 0} {
    error "Unexpected external HLS AXI memory interfaces: $external_hls_axi"
}

puts "BD_VALIDATE_PASS"
puts "Project: $project_dir"
puts "HLS IP: $hls_ip_dir"
puts "EKF HLS IP: $ekf_hls_ip_dir"
puts "MIG source: $mig_source_prj"
puts "MIG derived AXI prj: $mig_prj_path"
puts "Wrapper: $wrapper_file"
