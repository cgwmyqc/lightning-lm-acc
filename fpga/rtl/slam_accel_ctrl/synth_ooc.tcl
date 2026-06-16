set script_dir [file dirname [file normalize [info script]]]
set repo_root [file normalize [file join $script_dir ".." ".." ".."]]
set project_dir [file normalize [file join $::env(TEMP) "lightning_slam_accel_ctrl_ooc"]]
set target_part "xc7z100ffg900-2"

set user_args $argv
if {[llength $user_args] >= 1 && [string length [lindex $user_args 0]] > 0} {
    set project_dir [file normalize [lindex $user_args 0]]
}
if {[llength $user_args] >= 2 && [string length [lindex $user_args 1]] > 0} {
    set target_part [lindex $user_args 1]
}

file mkdir $project_dir
cd $project_dir

read_verilog [file join $script_dir "slam_accel_ctrl.v"]
synth_design -top slam_accel_ctrl -part $target_part -mode out_of_context
report_utilization -file [file join $project_dir "slam_accel_ctrl_utilization.rpt"]
report_timing_summary -file [file join $project_dir "slam_accel_ctrl_timing_summary.rpt"]
exit
