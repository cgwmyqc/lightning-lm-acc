set script_dir [file dirname [file normalize [info script]]]
set project_dir [file normalize [file join $script_dir ".." ".build" "lmem_sim"]]
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

add_files -fileset sim_1 -norecurse [file join $script_dir "tb_lmem_bd_smoke.v"]
set_property top tb_lmem_bd_smoke [get_filesets sim_1]
update_compile_order -fileset sim_1

launch_simulation
run all
close_sim

puts "SIM_DONE"
exit
