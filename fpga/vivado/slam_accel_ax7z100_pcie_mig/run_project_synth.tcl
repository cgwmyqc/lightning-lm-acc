set script_dir [file dirname [file normalize [info script]]]
set project_dir [file normalize [file join $script_dir ".." ".build" "azmig_syn"]]
set target_part "xc7z100ffg900-2"
set hls_ip_dir [file normalize [file join $::env(TEMP) "lightning_hls_unified_obs" "solution1" "impl" "ip"]]
set ekf_hls_ip_dir [file normalize [file join $::env(TEMP) "lightning_hls_ekf_update" "solution1" "impl" "ip"]]
set loc_iter_hls_ip_dir [file normalize [file join $::env(TEMP) "lightning_hls_loc_iterative" "solution1" "impl" "ip"]]
set reference_root [file normalize [file join $script_dir ".." ".." ".." ".."]]
set jobs 18

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
    set loc_iter_hls_ip_dir [file normalize [lindex $user_args 4]]
}
if {[llength $user_args] >= 6 && [string length [lindex $user_args 5]] > 0} {
    set reference_root [file normalize [lindex $user_args 5]]
}
if {[llength $user_args] >= 7 && [string length [lindex $user_args 6]] > 0} {
    set jobs [lindex $user_args 6]
}
if {![string is integer -strict $jobs] || $jobs < 1} {
    error "Invalid jobs value: $jobs"
}

source [file join $script_dir "create_bd.tcl"]

puts "VIVADO_RUN_JOBS=$jobs"
launch_runs synth_1 -jobs $jobs
wait_on_run synth_1
set run_status [get_property STATUS [get_runs synth_1]]
puts "SYNTH_1_STATUS=$run_status"
if {[string first "synth_design Complete" $run_status] < 0} {
    error "synth_1 did not complete: $run_status"
}

open_run synth_1
report_utilization -file [file join $project_dir "ax7z100_pcie_mig_util.rpt"]
report_timing_summary -file [file join $project_dir "ax7z100_pcie_mig_timing.rpt"]

puts "PROJECT_SYNTH_PASS"
exit
