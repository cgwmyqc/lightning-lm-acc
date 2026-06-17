set script_dir [file dirname [file normalize [info script]]]
set project_dir [file normalize [file join $script_dir ".." ".build" "lmem_syn"]]
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

launch_runs synth_1 -jobs 2
wait_on_run synth_1
set run_status [get_property STATUS [get_runs synth_1]]
puts "SYNTH_1_STATUS=$run_status"
if {[string first "synth_design Complete" $run_status] < 0} {
    error "synth_1 did not complete: $run_status"
}

open_run synth_1
report_utilization -file [file join $project_dir "lmem_util.rpt"]
report_timing_summary -file [file join $project_dir "lmem_timing.rpt"]

puts "PROJECT_SYNTH_PASS"
exit
