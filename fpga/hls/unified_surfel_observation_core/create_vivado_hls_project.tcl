set script_dir [file dirname [file normalize [info script]]]
set repo_root [file normalize [file join $script_dir ".." ".." ".."]]

set golden_dir [file normalize [file join $repo_root "fpga" "golden" "localization" "frame_000001"]]
set project_dir [file normalize [file join $script_dir "build" "vivado_hls_unified_obs"]]
set target_part "xc7z100ffg900-2"
set flow "csim"

set user_args $argv
if {[llength $user_args] >= 2 && [lindex $user_args 0] == "-f"} {
    set user_args [lrange $user_args 2 end]
}
if {[llength $user_args] >= 1 && [lindex $user_args 0] == "-tclargs"} {
    set user_args [lrange $user_args 1 end]
}

if {[llength $user_args] >= 1 && [string length [lindex $user_args 0]] > 0} {
    set golden_dir [file normalize [lindex $user_args 0]]
}
if {[llength $user_args] >= 2 && [string length [lindex $user_args 1]] > 0} {
    set project_dir [file normalize [lindex $user_args 1]]
}
if {[llength $user_args] >= 3 && [string length [lindex $user_args 2]] > 0} {
    set target_part [lindex $user_args 2]
}
if {[llength $user_args] >= 4 && [string length [lindex $user_args 3]] > 0} {
    set flow [lindex $user_args 3]
}

puts "INFO: golden_dir=$golden_dir"
puts "INFO: project_dir=$project_dir"
puts "INFO: target_part=$target_part"
puts "INFO: flow=$flow"

file mkdir [file dirname $project_dir]

cd [file dirname $project_dir]
open_project -reset [file tail $project_dir]
set_top "unified_surfel_observation_core"
add_files [file join $script_dir "unified_surfel_observation_core.cpp"] -cflags "-std=c++11 -I$repo_root"
add_files -tb [file join $script_dir "obs_tb.cpp"] -cflags "-std=c++11 -I$repo_root"
open_solution -reset "solution1"
set_part $target_part
create_clock -period 10 -name default
config_export -format ip_catalog -rtl verilog -version "1.0" -description "Lightning-LM unified surfel observation HLS IP"

if {$flow == "csim"} {
    csim_design -argv $golden_dir
} elseif {$flow == "csynth"} {
    csynth_design
} elseif {$flow == "csim_csynth"} {
    csim_design -argv $golden_dir
    csynth_design
} elseif {$flow == "cosim"} {
    csynth_design
    cosim_design -rtl verilog -argv $golden_dir
} elseif {$flow == "csynth_cosim"} {
    csynth_design
    cosim_design -rtl verilog -argv $golden_dir
} elseif {$flow == "export_ip"} {
    csynth_design
    export_design -rtl verilog -format ip_catalog
} elseif {$flow == "csynth_export_ip"} {
    csynth_design
    export_design -rtl verilog -format ip_catalog
} else {
    error "unsupported flow: $flow"
}

exit
