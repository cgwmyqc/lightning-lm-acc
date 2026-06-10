set script_dir [file dirname [file normalize [info script]]]
set golden_dir [file normalize [file join $script_dir .. .. golden_small]]
cd $script_dir

open_project -reset normal_eq_accel_prj
set_top normal_eq_accel
add_files [file join $script_dir normal_eq_accel.cpp] -cflags "-std=c++11"
add_files -tb [file join $script_dir testbench.cpp] -cflags "-std=c++11"

open_solution -reset solution1
set_part {xc7z015clg485-2}
create_clock -period 10 -name default

set golden_100 [file join $golden_dir frame_000100.bin]
set golden_200 [file join $golden_dir frame_000200.bin]
set golden_300 [file join $golden_dir frame_000300.bin]
csim_design -argv "$golden_100 $golden_200 $golden_300"

exit
