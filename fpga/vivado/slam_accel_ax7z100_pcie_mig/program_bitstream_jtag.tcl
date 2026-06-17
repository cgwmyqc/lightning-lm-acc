set bit_path ""
set hw_host "localhost"
set hw_port "3121"
set target_filter ""

set user_args $argv
if {[llength $user_args] >= 1 && [string length [lindex $user_args 0]] > 0} {
    set bit_path [file normalize [lindex $user_args 0]]
}
if {[llength $user_args] >= 2 && [string length [lindex $user_args 1]] > 0} {
    set hw_host [lindex $user_args 1]
}
if {[llength $user_args] >= 3 && [string length [lindex $user_args 2]] > 0} {
    set hw_port [lindex $user_args 2]
}
if {[llength $user_args] >= 4 && [string length [lindex $user_args 3]] > 0} {
    set target_filter [lindex $user_args 3]
}

if {[string length $bit_path] == 0} {
    error "Missing bitstream path argument"
}
if {![file exists $bit_path]} {
    error "Bitstream does not exist: $bit_path"
}
if {[llength [info commands connect]] == 0 || [llength [info commands fpga]] == 0} {
    error "XSDB hardware commands are unavailable. Run this script through xsdb, not Vivado batch Tcl."
}

puts "XSDB_CONNECT=$hw_host:$hw_port"
connect -host $hw_host -port $hw_port

puts "JTAG_TARGETS_BEGIN"
targets
puts "JTAG_TARGETS_END"

if {[string length $target_filter] > 0} {
    if {[catch {targets -set -filter $target_filter} target_err]} {
        puts "WARN: target filter did not select a device: $target_filter"
        puts "WARN: $target_err"
    }
}

puts "BITSTREAM_PATH=$bit_path"
fpga -file $bit_path

if {![catch {fpga -state} fpga_state]} {
    puts "FPGA_STATE=$fpga_state"
}
if {![catch {fpga -config-status} config_status]} {
    puts "FPGA_CONFIG_STATUS=$config_status"
}

puts "JTAG_PROGRAM_PASS"
