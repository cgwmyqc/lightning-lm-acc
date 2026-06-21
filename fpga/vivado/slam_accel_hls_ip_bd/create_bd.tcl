set script_dir [file dirname [file normalize [info script]]]
set repo_root [file normalize [file join $script_dir ".." ".." ".."]]
set project_dir [file normalize [file join $::env(TEMP) "lightning_slam_accel_hls_ip_bd"]]
set target_part "xc7z100ffg900-2"
set hls_ip_dir [file normalize [file join $repo_root "fpga" "vivado" ".build" "hls_unified_obs" "solution1" "impl" "ip"]]

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

set component_xml [file join $hls_ip_dir "component.xml"]
if {![file exists $component_xml]} {
    error "Missing HLS IP component.xml: $component_xml"
}

file mkdir $project_dir
cd $project_dir

create_project -force slam_accel_hls_ip_bd $project_dir -part $target_part
set_property ip_repo_paths [list $hls_ip_dir] [current_project]
update_ip_catalog

add_files -norecurse [file join $repo_root "fpga" "rtl" "slam_accel_ctrl" "slam_accel_ctrl.v"]
add_files -fileset constrs_1 -norecurse [file join $script_dir "slam_accel_hls_ip_bd.xdc"]
update_compile_order -fileset sources_1

create_bd_design "slam_accel_hls_ip_bd"

create_bd_port -dir I -type clk aclk
create_bd_port -dir I -type rst aresetn
set_property CONFIG.POLARITY ACTIVE_LOW [get_bd_ports aresetn]

set ctrl [create_bd_cell -type module -reference slam_accel_ctrl ctrl_0]
set hls [create_bd_cell -type ip -vlnv xilinx.com:hls:unified_surfel_observation_core:1.0 unified_obs_0]
set zero32 [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_zero_32]
set_property -dict [list CONFIG.CONST_WIDTH {32} CONFIG.CONST_VAL {0}] $zero32

connect_bd_net [get_bd_ports aclk] [get_bd_pins ctrl_0/aclk] [get_bd_pins unified_obs_0/ap_clk]
connect_bd_net [get_bd_ports aresetn] [get_bd_pins ctrl_0/aresetn] [get_bd_pins unified_obs_0/ap_rst_n]
connect_bd_net [get_bd_pins const_zero_32/dout] [get_bd_pins ctrl_0/unified_obs_error]

connect_bd_net [get_bd_pins ctrl_0/unified_obs_ap_start] [get_bd_pins unified_obs_0/ap_start]
connect_bd_net [get_bd_pins unified_obs_0/ap_done] [get_bd_pins ctrl_0/unified_obs_ap_done]
connect_bd_net [get_bd_pins unified_obs_0/ap_idle] [get_bd_pins ctrl_0/unified_obs_ap_idle]
connect_bd_net [get_bd_pins unified_obs_0/ap_ready] [get_bd_pins ctrl_0/unified_obs_ap_ready]

connect_bd_net [get_bd_pins ctrl_0/unified_obs_num_points] [get_bd_pins unified_obs_0/num_points]
connect_bd_net [get_bd_pins ctrl_0/unified_obs_scan_points_addr] [get_bd_pins unified_obs_0/scan_points]
connect_bd_net [get_bd_pins ctrl_0/unified_obs_pose_addr] [get_bd_pins unified_obs_0/pose]
connect_bd_net [get_bd_pins ctrl_0/unified_obs_map_header_addr] [get_bd_pins unified_obs_0/map_header]
connect_bd_net [get_bd_pins ctrl_0/unified_obs_active_blocks_addr] [get_bd_pins unified_obs_0/active_blocks]
connect_bd_net [get_bd_pins ctrl_0/unified_obs_obs_cells_addr] [get_bd_pins unified_obs_0/obs_cells]
connect_bd_net [get_bd_pins ctrl_0/unified_obs_output_addr] [get_bd_pins unified_obs_0/output_words]

foreach pin {
    s_axi_awaddr s_axi_awvalid s_axi_awready s_axi_wdata s_axi_wstrb s_axi_wvalid
    s_axi_wready s_axi_bresp s_axi_bvalid s_axi_bready s_axi_araddr s_axi_arvalid
    s_axi_arready s_axi_rdata s_axi_rresp s_axi_rvalid s_axi_rready
} {
    make_bd_pins_external [get_bd_pins ctrl_0/$pin]
}

foreach pin {
    unified_obs_output_addr kernel_sel mode
} {
    make_bd_pins_external [get_bd_pins ctrl_0/$pin]
}

foreach intf {m_axi_gmem0 m_axi_gmem1 m_axi_gmem2 m_axi_gmem3 m_axi_gmem4} {
    make_bd_intf_pins_external [get_bd_intf_pins unified_obs_0/$intf]
}

foreach intf {m_axi_gmem0 m_axi_gmem1 m_axi_gmem2 m_axi_gmem3 m_axi_gmem4} {
    assign_bd_address [get_bd_addr_segs ${intf}_0/Reg]
}

validate_bd_design
save_bd_design

set bd_file [get_files -of_objects [get_filesets sources_1] *slam_accel_hls_ip_bd.bd]
generate_target all $bd_file
make_wrapper -files $bd_file -top -import

set wrapper_file [get_files *slam_accel_hls_ip_bd_wrapper.v]
set_property top slam_accel_hls_ip_bd_wrapper [current_fileset]
update_compile_order -fileset sources_1

report_ip_status -file [file join $project_dir "slam_accel_hls_ip_bd_ip_status.rpt"]

puts "BD_VALIDATE_PASS"
puts "Project: $project_dir"
puts "HLS IP: $hls_ip_dir"
puts "Wrapper: $wrapper_file"
