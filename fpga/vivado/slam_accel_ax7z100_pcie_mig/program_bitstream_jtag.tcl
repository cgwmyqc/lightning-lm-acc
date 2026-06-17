set bit_path ""
set hw_target ""

set user_args $argv
if {[llength $user_args] >= 1 && [string length [lindex $user_args 0]] > 0} {
    set bit_path [file normalize [lindex $user_args 0]]
}
if {[llength $user_args] >= 2 && [string length [lindex $user_args 1]] > 0} {
    set hw_target [lindex $user_args 1]
}

if {[string length $bit_path] == 0} {
    error "Missing bitstream path argument"
}
if {![file exists $bit_path]} {
    error "Bitstream does not exist: $bit_path"
}

open_hw_manager
connect_hw_server
if {[string length $hw_target] > 0} {
    open_hw_target $hw_target
} else {
    open_hw_target
}

set devices [get_hw_devices]
if {[llength $devices] == 0} {
    error "No hardware devices found"
}

set target_device ""
foreach dev $devices {
    set part_name [string tolower [get_property PART $dev]]
    if {[string first "xc7z100" $part_name] >= 0} {
        set target_device $dev
        break
    }
}
if {[string length $target_device] == 0} {
    set target_device [lindex $devices 0]
    puts "WARN: no xc7z100 device was matched; using first device: $target_device"
}

current_hw_device $target_device
refresh_hw_device -update_hw_probes false $target_device
set_property PROGRAM.FILE $bit_path $target_device
program_hw_devices $target_device
refresh_hw_device $target_device

puts "JTAG_PROGRAM_PASS"
puts "PROGRAMMED_DEVICE=$target_device"
puts "BITSTREAM_PATH=$bit_path"
