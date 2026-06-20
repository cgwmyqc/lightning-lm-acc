set script_dir [file dirname [file normalize [info script]]]
set repo_root [file normalize [file join $script_dir ".." ".." ".."]]
set reference_root [file normalize [file join $repo_root ".."]]
set project_dir [file normalize [file join $script_dir ".." ".build" "xdma_restore_stage_a2_bd"]]
set target_part "xc7z100ffg900-2"
set stage "A2"

set user_args $argv
if {[llength $user_args] >= 1 && [string length [lindex $user_args 0]] > 0} {
    set project_dir [file normalize [lindex $user_args 0]]
}
if {[llength $user_args] >= 2 && [string length [lindex $user_args 1]] > 0} {
    set target_part [lindex $user_args 1]
}
if {[llength $user_args] >= 3 && [string length [lindex $user_args 2]] > 0} {
    set stage [string toupper [lindex $user_args 2]]
}
if {[llength $user_args] >= 4 && [string length [lindex $user_args 3]] > 0} {
    set reference_root [file normalize [lindex $user_args 3]]
}

if {$stage ni {"A" "A2" "B" "B2" "C" "C2"}} {
    error "Invalid stage '$stage'. Expected A, A2, B, B2, C, or C2."
}

set use_mig 0
set axi_width_cfg "64_bit"
set bram_width 64
set axisten_freq 250
set stage_desc "Stage A: X4 lane reversal, 64-bit/250 MHz XDMA, slam_accel_ctrl, BRAM, no MIG/HLS"
set ctrl_module "xdma_restore_slam_accel_ctrl_axi_lite_wrapper"
if {$stage eq "A2"} {
    set stage_desc "Stage A2: X4 lane reversal, 64-bit/250 MHz XDMA, BAR shim at 0x0000, slam_accel_ctrl at 0x1000, BRAM, no MIG/HLS"
    set ctrl_module "xdma_restore_bar_shim_ctrl_wrapper"
}
if {$stage eq "B"} {
    set axi_width_cfg "128_bit"
    set bram_width 128
    set axisten_freq 125
    set stage_desc "Stage B: X4 lane reversal, 128-bit/125 MHz XDMA, slam_accel_ctrl, BRAM, no MIG/HLS"
}
if {$stage eq "B2"} {
    set axi_width_cfg "128_bit"
    set bram_width 128
    set axisten_freq 125
    set stage_desc "Stage B2: X4 lane reversal, 128-bit/125 MHz XDMA, BAR shim at 0x0000, slam_accel_ctrl at 0x1000, BRAM, no MIG/HLS"
    set ctrl_module "xdma_restore_bar_shim_ctrl_wrapper"
}
if {$stage eq "C"} {
    set use_mig 1
    set axi_width_cfg "128_bit"
    set bram_width 128
    set axisten_freq 125
    set stage_desc "Stage C: X4 lane reversal, 128-bit/125 MHz XDMA, slam_accel_ctrl, MIG-backed PL DDR3, no HLS"
}
if {$stage eq "C2"} {
    set use_mig 1
    set axi_width_cfg "128_bit"
    set bram_width 128
    set axisten_freq 125
    set stage_desc "Stage C2: X4 lane reversal, 128-bit/125 MHz XDMA, BAR shim at 0x0000, slam_accel_ctrl at 0x1000, MIG-backed PL DDR3, no HLS"
    set ctrl_module "xdma_restore_bar_shim_ctrl_wrapper"
}

set stage_lc [string tolower $stage]
set design_name "xdma_restore_stage_${stage_lc}"
set project_name $design_name

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

file mkdir $project_dir
cd $project_dir

create_project -force $project_name $project_dir -part $target_part

add_files -norecurse [list \
    [file join $repo_root "fpga" "rtl" "slam_accel_ctrl" "slam_accel_ctrl.v"] \
    [file join $script_dir "xdma_restore_slam_accel_ctrl_axi_lite_wrapper.v"] \
    [file join $script_dir "xdma_restore_bar_shim_ctrl_wrapper.v"] \
]
if {$use_mig} {
    add_files -fileset constrs_1 -norecurse [file join $script_dir "restore_pcie_mig.xdc"]
} else {
    add_files -fileset constrs_1 -norecurse [file join $script_dir "restore_pcie.xdc"]
}
update_compile_order -fileset sources_1

create_bd_design $design_name

set pcie_mgt [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie_mgt]
set pcie_ref [create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 pcie_ref]
set_property CONFIG.FREQ_HZ {100000000} $pcie_ref
set pcie_rst_n [create_bd_port -dir I -type rst pcie_rst_n]
set_property CONFIG.POLARITY {ACTIVE_LOW} $pcie_rst_n

if {$use_mig} {
    set sys_clk [create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sys]
    set_property CONFIG.FREQ_HZ {200000000} $sys_clk
    set ddr3 [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 ddr3]
}

set util_ds_buf_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_0]
set_property CONFIG.C_BUF_TYPE {IBUFDSGTE} $util_ds_buf_0

set xdma_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:xdma:4.1 xdma_0]
set_property -dict [list \
    CONFIG.axi_data_width $axi_width_cfg \
    CONFIG.axilite_master_en {true} \
    CONFIG.axilite_master_scale {Kilobytes} \
    CONFIG.axilite_master_size {64} \
    CONFIG.axisten_freq $axisten_freq \
    CONFIG.enable_lane_reversal {true} \
    CONFIG.mode_selection {Basic} \
    CONFIG.pcie_id_if {false} \
    CONFIG.pf0_device_id {7024} \
    CONFIG.pl_link_cap_max_link_speed {5.0_GT/s} \
    CONFIG.pl_link_cap_max_link_width {X4} \
    CONFIG.plltype {QPLL1} \
] $xdma_0

set ctrl [create_bd_cell -type module -reference $ctrl_module ctrl_0]
set const_zero_32 [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_zero_32]
set_property -dict [list CONFIG.CONST_WIDTH {32} CONFIG.CONST_VAL {0}] $const_zero_32
set const_one_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_one_1]
set_property -dict [list CONFIG.CONST_WIDTH {1} CONFIG.CONST_VAL {1}] $const_one_1

connect_bd_intf_net [get_bd_intf_ports pcie_ref] [get_bd_intf_pins util_ds_buf_0/CLK_IN_D]
connect_bd_net [get_bd_pins util_ds_buf_0/IBUF_OUT] [get_bd_pins xdma_0/sys_clk]
connect_bd_net [get_bd_ports pcie_rst_n] [get_bd_pins xdma_0/sys_rst_n]
connect_bd_intf_net [get_bd_intf_ports pcie_mgt] [get_bd_intf_pins xdma_0/pcie_mgt]

connect_bd_net [get_bd_pins xdma_0/axi_aclk] [get_bd_pins ctrl_0/aclk]
connect_bd_net [get_bd_pins xdma_0/axi_aresetn] [get_bd_pins ctrl_0/aresetn]
connect_bd_net [get_bd_pins const_zero_32/dout] [get_bd_pins ctrl_0/unified_obs_error]
connect_bd_net [get_bd_pins const_one_1/dout] \
    [get_bd_pins ctrl_0/unified_obs_ap_idle] \
    [get_bd_pins ctrl_0/unified_obs_ap_ready] \
    [get_bd_pins ctrl_0/unified_obs_ap_done]
connect_bd_intf_net [get_bd_intf_pins xdma_0/M_AXI_LITE] [get_bd_intf_pins ctrl_0/S_AXI]

set ctrl_seg [first_addr_seg "ctrl_0/S_AXI/*"]
create_bd_addr_seg -range 0x00010000 -offset 0x00000000 [first_addr_space "xdma_0/M_AXI_LITE"] $ctrl_seg SEG_ctrl_0_Reg

if {$use_mig} {
    set mig_source_prj [file join $reference_root "12_ddr3_pl" "mig_a.prj"]
    set mig_axi_source_tcl [file join $reference_root "33_PCIe_test" "Vivado" "auto_create_project" "pl_config.tcl"]
    if {![file exists $mig_source_prj]} {
        error "Missing AX7Z100 MIG reference project file: $mig_source_prj"
    }
    if {![file exists $mig_axi_source_tcl]} {
        error "Missing AX7Z100 AXI MIG reference Tcl: $mig_axi_source_tcl"
    }

    set mig_rst_hi [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 mig_rst_hi]
    set_property -dict [list CONFIG.CONST_WIDTH {1} CONFIG.CONST_VAL {1}] $mig_rst_hi
    set mig_7series_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series:4.2 mig_7series_0]
    set mig_ip_dir [get_property IP_DIR [get_ips [get_property CONFIG.Component_Name $mig_7series_0]]]
    set mig_prj_name "mig_ax7z100_pl_ddr3_axi.prj"
    set mig_prj_path [file join $mig_ip_dir $mig_prj_name]
    derive_axi_mig_prj $mig_source_prj $mig_axi_source_tcl $mig_prj_path "xdma_restore_stage_${stage_lc}_mig_0"
    set_property -dict [list \
        CONFIG.BOARD_MIG_PARAM {Custom} \
        CONFIG.RESET_BOARD_INTERFACE {Custom} \
        CONFIG.XML_INPUT_FILE $mig_prj_name \
    ] $mig_7series_0

    set mem_ic [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 mem_axi_ic]
    set_property -dict [list CONFIG.NUM_SI {1} CONFIG.NUM_MI {1}] $mem_ic
    set rst_mig_ui [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_mig_ui]

    connect_bd_intf_net [get_bd_intf_ports sys] [get_bd_intf_pins mig_7series_0/SYS_CLK]
    connect_bd_intf_net [get_bd_intf_ports ddr3] [get_bd_intf_pins mig_7series_0/DDR3]
    connect_bd_net [get_bd_pins mig_rst_hi/dout] [get_bd_pins mig_7series_0/sys_rst]
    connect_bd_net [get_bd_pins mig_7series_0/ui_clk] [get_bd_pins rst_mig_ui/slowest_sync_clk]
    connect_bd_net [get_bd_pins mig_7series_0/mmcm_locked] [get_bd_pins rst_mig_ui/dcm_locked]
    connect_bd_net [get_bd_pins mig_7series_0/ui_clk_sync_rst] [get_bd_pins rst_mig_ui/ext_reset_in]

    connect_bd_intf_net [get_bd_intf_pins xdma_0/M_AXI] [get_bd_intf_pins mem_axi_ic/S00_AXI]
    connect_bd_intf_net [get_bd_intf_pins mem_axi_ic/M00_AXI] [get_bd_intf_pins mig_7series_0/S_AXI]
    connect_bd_net [get_bd_pins xdma_0/axi_aclk] [get_bd_pins mem_axi_ic/ACLK] [get_bd_pins mem_axi_ic/S00_ACLK]
    connect_bd_net [get_bd_pins xdma_0/axi_aresetn] [get_bd_pins mem_axi_ic/ARESETN] [get_bd_pins mem_axi_ic/S00_ARESETN]
    connect_bd_net [get_bd_pins mig_7series_0/ui_clk] [get_bd_pins mem_axi_ic/M00_ACLK]
    connect_bd_net [get_bd_pins rst_mig_ui/peripheral_aresetn] [get_bd_pins mem_axi_ic/M00_ARESETN] [get_bd_pins mig_7series_0/aresetn]

    set mig_mem [first_addr_seg "mig_7series_0/memmap/memaddr"]
    create_bd_addr_seg -range 0x40000000 -offset 0x00000000 [first_addr_space "xdma_0/M_AXI"] $mig_mem SEG_xdma_0_M_AXI_PL_DDR3
} else {
    set axi_bram_ctrl_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0]
    set_property -dict [list CONFIG.DATA_WIDTH $bram_width CONFIG.SINGLE_PORT_BRAM {1}] $axi_bram_ctrl_0
    set axi_bram_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 axi_bram_0]
    connect_bd_net [get_bd_pins xdma_0/axi_aclk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk]
    connect_bd_net [get_bd_pins xdma_0/axi_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn]
    connect_bd_intf_net [get_bd_intf_pins xdma_0/M_AXI] [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
    connect_bd_intf_net [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins axi_bram_0/BRAM_PORTA]
    set bram_seg [first_addr_seg "axi_bram_ctrl_0/S_AXI/*"]
    create_bd_addr_seg -range 0x00010000 -offset 0x00000000 [first_addr_space "xdma_0/M_AXI"] $bram_seg SEG_axi_bram_ctrl_0_Mem
}

validate_bd_design
save_bd_design

set bd_file [get_files -of_objects [get_filesets sources_1] *${design_name}.bd]
generate_target all $bd_file
make_wrapper -files $bd_file -top -import

set wrapper_file [get_files *${design_name}_wrapper.v]
set_property top ${design_name}_wrapper [current_fileset]
update_compile_order -fileset sources_1

report_ip_status -file [file join $project_dir "xdma_restore_stage_${stage_lc}_ip_status.rpt"]
report_property -file [file join $project_dir "xdma_restore_stage_${stage_lc}_xdma_bd_properties.rpt"] $xdma_0
set xdma_ips [get_ips -quiet *xdma*]
if {[llength $xdma_ips] > 0} {
    report_property -file [file join $project_dir "xdma_restore_stage_${stage_lc}_xdma_ip_properties.rpt"] [lindex $xdma_ips 0]
}

puts "XDMA_RESTORE_STAGE_${stage}_BD_VALIDATE_PASS"
puts "Project: $project_dir"
puts "Wrapper: $wrapper_file"
puts "Stage: $stage_desc"
