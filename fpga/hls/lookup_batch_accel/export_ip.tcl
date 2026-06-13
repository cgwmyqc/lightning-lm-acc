set script_dir [file dirname [file normalize [info script]]]
set ip_repo_dir [file normalize [file join $script_dir .. .. vivado ip_repo lookup_batch_accel]]
set hls_ip_dir [file normalize [file join $script_dir lookup_batch_accel_prj solution1 impl ip]]
set run_ippack_tcl [file join $hls_ip_dir run_ippack.tcl]
cd $script_dir

open_project -reset lookup_batch_accel_prj
set_top lookup_batch_accel
add_files [file join $script_dir lookup_batch_accel.cpp] -cflags "-std=c++11"
add_files -tb [file join $script_dir testbench.cpp] -cflags "-std=c++11"

open_solution -reset solution1
set_part {xc7z015clg485-2}
create_clock -period 10 -name default

csynth_design

set export_result [catch {
    export_design -format ip_catalog \
        -description "Lightning-LM surfel lookup batch accelerator" \
        -display_name "lookup_batch_accel" \
        -vendor "lightning-lm-acc" \
        -library "hls" \
        -version "1.0" \
        -ipname "lookup_batch_accel"
} export_message]

if {$export_result != 0} {
    if {![file exists $run_ippack_tcl]} {
        error $export_message
    }

    puts "Initial IP packaging failed. Applying Vivado HLS 2018.3 core_revision workaround."

    set fp [open $run_ippack_tcl r]
    set run_ippack_text [read $fp]
    close $fp

    regsub {set Revision[ \t]+"[0-9]+"} $run_ippack_text {set Revision    "1"} run_ippack_text

    set fp [open $run_ippack_tcl w]
    puts -nonewline $fp $run_ippack_text
    close $fp

    set old_pwd [pwd]
    cd $hls_ip_dir
    set repack_result [catch {exec cmd /c pack.bat} repack_message]
    cd $old_pwd

    if {$repack_result != 0} {
        error $repack_message
    }
}

if {![file exists [file join $hls_ip_dir component.xml]]} {
    error "HLS IP export did not create [file join $hls_ip_dir component.xml]"
}

file delete -force $ip_repo_dir
file mkdir [file dirname $ip_repo_dir]
file copy -force $hls_ip_dir $ip_repo_dir

foreach transient_name {.Xil tmp.cache tmp.hw tmp.ip_user_files tmp.srcs autoimpl.log tmp.xpr vivado.jou vivado.log} {
    file delete -force [file join $ip_repo_dir $transient_name]
}
foreach transient_file [glob -nocomplain [file join $ip_repo_dir vivado_*.backup.jou] [file join $ip_repo_dir vivado_*.backup.log]] {
    file delete -force $transient_file
}

exit
