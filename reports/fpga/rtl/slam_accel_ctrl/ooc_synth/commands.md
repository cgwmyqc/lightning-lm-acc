# slam_accel_ctrl OOC synthesis check

Date: 2026-06-16
Tool: Vivado 2018.3
Part: `xc7z100ffg900-2`

Command shape:

```tcl
read_verilog {fpga/rtl/slam_accel_ctrl/slam_accel_ctrl.v}
synth_design -top slam_accel_ctrl -part xc7z100ffg900-2 -mode out_of_context
report_utilization
exit
```

The check was run from a temporary directory so Vivado-generated files were not added to the repository.
