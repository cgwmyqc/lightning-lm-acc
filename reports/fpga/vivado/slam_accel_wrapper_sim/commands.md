# slam_accel_wrapper_sim commands

Date: 2026-06-17

Behavioral simulation:

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_wrapper_sim\run_vivado_sim.ps1
```

OOC synthesis:

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_wrapper_sim\run_vivado_ooc_synth.ps1
```

Generated project directories:

```text
%TEMP%\lightning_slam_accel_wrapper_sim
%TEMP%\lightning_slam_accel_wrapper_ooc
```

Archived generated reports:

```text
reports/fpga/vivado/slam_accel_wrapper_sim/vivado_sim.log
reports/fpga/vivado/slam_accel_wrapper_sim/vivado_sim_log.txt
reports/fpga/vivado/slam_accel_wrapper_sim/vivado_ooc_synth.log
reports/fpga/vivado/slam_accel_wrapper_sim/vivado_ooc_synth_log.txt
reports/fpga/vivado/slam_accel_wrapper_sim/utilization.rpt
reports/fpga/vivado/slam_accel_wrapper_sim/timing_summary.rpt
```

The `.log` files are local ignored artifacts because the repository ignores `*.log`; the `.txt` copies are the git-trackable archived logs.
