set script_dir [file dirname [file normalize [info script]]]
set project_dir [file normalize [file join $::env(TEMP) "lightning_slam_accel_hls_ip_bd"]]
set target_part "xc7z100ffg900-2"
set hls_ip_dir [file normalize [file join $::env(TEMP) "lightning_hls_unified_obs" "solution1" "impl" "ip"]]

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

source [file join $script_dir "create_bd.tcl"]

set hls_subcore_xcis [glob -nocomplain [file join $hls_ip_dir "tmp.srcs" "sources_1" "ip" "*" "*.xci"]]
if {[llength $hls_subcore_xcis] > 0} {
    read_ip $hls_subcore_xcis
    set_property generate_synth_checkpoint true [get_files $hls_subcore_xcis]
    synth_ip [get_ips unified_surfel_observation_core_ap_*]
}

set bd_root [file join $project_dir "slam_accel_hls_ip_bd.srcs" "sources_1" "bd" "slam_accel_hls_ip_bd"]
set wrapper_file [file join $project_dir "slam_accel_hls_ip_bd.srcs" "sources_1" "imports" "hdl" "slam_accel_hls_ip_bd_wrapper.v"]
set bd_synth_file [file join $bd_root "synth" "slam_accel_hls_ip_bd.v"]
set repo_root [file normalize [file join $script_dir ".." ".." ".."]]

close_project

foreach dcp [glob -nocomplain [file join $project_dir "slam_accel_hls_ip_bd.runs" "*_synth_1" "*.dcp"]] {
    read_checkpoint $dcp
}
read_verilog [file join $repo_root "fpga" "rtl" "slam_accel_ctrl" "slam_accel_ctrl.v"]
read_verilog [glob -nocomplain [file join $hls_ip_dir "hdl" "verilog" "*.v"]]
read_verilog [glob -nocomplain [file join $bd_root "ipshared" "*" "hdl" "*.v"]]
read_verilog [glob -nocomplain [file join $bd_root "ip" "*" "synth" "*.v"]]
read_verilog $bd_synth_file
read_verilog $wrapper_file

synth_design -top slam_accel_hls_ip_bd_wrapper -part $target_part -mode out_of_context
report_utilization -file [file join $project_dir "slam_accel_hls_ip_bd_utilization.rpt"]
report_timing_summary -file [file join $project_dir "slam_accel_hls_ip_bd_timing_summary.rpt"]

puts "OOC_SYNTH_PASS"
exit
