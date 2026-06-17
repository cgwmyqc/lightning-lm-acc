set script_dir [file dirname [file normalize [info script]]]
set repo_root [file normalize [file join $script_dir ".." ".." ".."]]
set project_dir [file normalize [file join $script_dir ".." ".build" "lmem_golden_sim"]]
set target_part "xc7z100ffg900-2"
set hls_impl_dir [file normalize [file join $::env(TEMP) "lightning_hls_unified_obs" "solution1" "impl"]]
set image_dir [file normalize [file join $script_dir ".." ".build" "golden_frame_000001"]]
set run_numeric 0

set user_args $argv
if {[llength $user_args] >= 1 && [string length [lindex $user_args 0]] > 0} {
    set project_dir [file normalize [lindex $user_args 0]]
}
if {[llength $user_args] >= 2 && [string length [lindex $user_args 1]] > 0} {
    set target_part [lindex $user_args 1]
}
if {[llength $user_args] >= 3 && [string length [lindex $user_args 2]] > 0} {
    set hls_impl_dir [file normalize [lindex $user_args 2]]
}
if {[llength $user_args] >= 4 && [string length [lindex $user_args 3]] > 0} {
    set image_dir [file normalize [lindex $user_args 3]]
}
if {[llength $user_args] >= 5 && [string length [lindex $user_args 4]] > 0} {
    set run_numeric [lindex $user_args 4]
}

set hls_verilog_dir [file join $hls_impl_dir "verilog"]
if {![file exists [file join $hls_verilog_dir "unified_surfel_observation_core.v"]]} {
    error "Missing HLS generated RTL under $hls_verilog_dir"
}
if {![file exists [file join $image_dir "golden_frame_000001_params.vh"]]} {
    error "Missing generated golden params under $image_dir"
}

file mkdir $project_dir
cd $project_dir

create_project -force lmem_golden $project_dir -part $target_part

foreach ip_tcl [glob -nocomplain [file join $hls_verilog_dir "*_ip.tcl"]] {
    source $ip_tcl
}

add_files -norecurse [glob -nocomplain [file join $hls_verilog_dir "*.v"]]
add_files -fileset sim_1 -norecurse [glob -nocomplain [file join $hls_verilog_dir "*.dat"]]
add_files -norecurse [file join $repo_root "fpga" "rtl" "slam_accel_ctrl" "slam_accel_ctrl.v"]
add_files -fileset sim_1 -norecurse [list \
    [file join $script_dir "axi_memory_model.sv"] \
    [file join $script_dir "tb_lmem_golden.sv"] \
]
set_property include_dirs [list $image_dir] [get_filesets sim_1]
set_property top tb_lmem_golden [get_filesets sim_1]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

set gmem0 [file normalize [file join $image_dir "gmem0_scan.bin"]]
set gmem1 [file normalize [file join $image_dir "gmem1_pose_map_header.bin"]]
set gmem2 [file normalize [file join $image_dir "gmem2_active_blocks.bin"]]
set gmem3 [file normalize [file join $image_dir "gmem3_obs_cells.bin"]]
set gmem4 [file normalize [file join $image_dir "gmem4_output.bin"]]
set plusargs "-testplusarg GMEM0_BIN=$gmem0 -testplusarg GMEM1_BIN=$gmem1 -testplusarg GMEM2_BIN=$gmem2 -testplusarg GMEM3_BIN=$gmem3 -testplusarg GMEM4_BIN=$gmem4"
set_property -dict [list xsim.simulate.xsim.more_options $plusargs] [get_filesets sim_1]

launch_simulation
if {$run_numeric} {
    run all
} else {
    puts "GOLDEN_SIM_ELABORATE_PRELOAD_ONLY"
}
close_sim

puts "GOLDEN_SIM_DONE"
exit
