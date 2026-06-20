set script_dir [file dirname [file normalize [info script]]]
set project_dir [file normalize [file join $script_dir ".." ".build" "azmig_impl"]]
set target_part "xc7z100ffg900-2"
set hls_ip_dir [file normalize [file join $::env(TEMP) "lightning_hls_unified_obs" "solution1" "impl" "ip"]]
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
    set reference_root [file normalize [lindex $user_args 3]]
}
if {[llength $user_args] >= 5 && [string length [lindex $user_args 4]] > 0} {
    set jobs [lindex $user_args 4]
}
if {![string is integer -strict $jobs] || $jobs < 1} {
    error "Invalid jobs value: $jobs"
}

source [file join $script_dir "create_bd.tcl"]

proc write_report_if_possible {report_name report_cmd} {
    if {[catch {uplevel 1 $report_cmd} err]} {
        puts "WARN: failed to write $report_name: $err"
    }
}

puts "VIVADO_RUN_JOBS=$jobs"
launch_runs synth_1 -jobs $jobs
wait_on_run synth_1
set synth_status [get_property STATUS [get_runs synth_1]]
puts "SYNTH_1_STATUS=$synth_status"
if {[string first "synth_design Complete" $synth_status] < 0} {
    error "synth_1 did not complete: $synth_status"
}

launch_runs impl_1 -to_step write_bitstream -jobs $jobs
wait_on_run impl_1
set impl_status [get_property STATUS [get_runs impl_1]]
puts "IMPL_1_STATUS=$impl_status"

set impl_opened 0
if {![catch {open_run impl_1} open_err]} {
    set impl_opened 1
    write_report_if_possible "post-implementation utilization" \
        [list report_utilization -file [file join $project_dir "ax7z100_pcie_mig_impl_util.rpt"]]
    write_report_if_possible "post-implementation timing" \
        [list report_timing_summary -file [file join $project_dir "ax7z100_pcie_mig_impl_timing.rpt"]]
    write_report_if_possible "post-implementation DRC" \
        [list report_drc -file [file join $project_dir "ax7z100_pcie_mig_impl_drc.rpt"]]
    write_report_if_possible "post-implementation route status" \
        [list report_route_status -file [file join $project_dir "ax7z100_pcie_mig_impl_route_status.rpt"]]
} else {
    puts "WARN: failed to open impl_1 for reports: $open_err"
}

set bit_files [glob -nocomplain -directory [file join $project_dir "azmig.runs" "impl_1"] "*.bit"]
set bit_path ""
if {[llength $bit_files] > 0} {
    set bit_path [file normalize [lindex $bit_files 0]]
}

set bit_info [open [file join $project_dir "ax7z100_pcie_mig_bitstream_path.txt"] w]
if {[string length $bit_path] > 0} {
    puts $bit_info "BITSTREAM_PATH=$bit_path"
} else {
    puts $bit_info "BITSTREAM_PATH="
}
puts $bit_info "IMPL_1_STATUS=$impl_status"
close $bit_info

if {[string first "write_bitstream Complete" $impl_status] < 0} {
    error "impl_1 did not complete bitstream generation: $impl_status"
}
if {[string length $bit_path] == 0} {
    error "Bitstream generation completed but no .bit file was found"
}

puts "BITSTREAM_PATH=$bit_path"
puts "IMPLEMENTATION_BITSTREAM_PASS"
exit
