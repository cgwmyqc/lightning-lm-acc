# slam_accel_ctrl Interface Convergence OOC Synthesis Commands

Date: 2026-06-16

Command:

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\rtl\slam_accel_ctrl\run_vivado_ooc_synth.ps1
```

Temporary Vivado project/report directory:

```text
%TEMP%\lightning_slam_accel_ctrl_ooc
```

Effective Vivado TCL flow:

```tcl
read_verilog {fpga/rtl/slam_accel_ctrl/slam_accel_ctrl.v}
synth_design -top slam_accel_ctrl -part xc7z100ffg900-2 -mode out_of_context
report_utilization
report_timing_summary
exit
```
