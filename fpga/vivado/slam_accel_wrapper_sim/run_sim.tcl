set script_dir [file dirname [file normalize [info script]]]
set repo_root [file normalize [file join $script_dir ".." ".." ".."]]
set project_dir [file normalize [file join $::env(TEMP) "lightning_slam_accel_wrapper_sim"]]
set target_part "xc7z100ffg900-2"

set user_args $argv
if {[llength $user_args] >= 1 && [string length [lindex $user_args 0]] > 0} {
    set project_dir [file normalize [lindex $user_args 0]]
}
if {[llength $user_args] >= 2 && [string length [lindex $user_args 1]] > 0} {
    set target_part [lindex $user_args 1]
}

file mkdir [file dirname $project_dir]
create_project -force slam_accel_wrapper_sim $project_dir -part $target_part
add_files -fileset sources_1 [file join $repo_root "fpga" "rtl" "slam_accel_ctrl" "slam_accel_ctrl.v"]
add_files -fileset sources_1 [file join $script_dir "slam_accel_wrapper_sim_top.v"]
add_files -fileset sources_1 [file join $script_dir "unified_surfel_observation_core_ctrl_mock.v"]
add_files -fileset sim_1 [file join $script_dir "tb_slam_accel_wrapper_sim.v"]
set_property top tb_slam_accel_wrapper_sim [get_filesets sim_1]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
launch_simulation -simset sim_1 -mode behavioral
run all
close_sim
exit

