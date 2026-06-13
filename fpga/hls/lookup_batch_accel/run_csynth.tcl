set script_dir [file dirname [file normalize [info script]]]
cd $script_dir

open_project -reset lookup_batch_accel_prj
set_top lookup_batch_accel
add_files [file join $script_dir lookup_batch_accel.cpp] -cflags "-std=c++11"
add_files -tb [file join $script_dir testbench.cpp] -cflags "-std=c++11"

open_solution -reset solution1
set_part {xc7z015clg485-2}
create_clock -period 10 -name default

csynth_design

exit
