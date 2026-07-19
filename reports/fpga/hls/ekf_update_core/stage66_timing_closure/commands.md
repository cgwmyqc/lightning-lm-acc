# Stage66B EKF Update Timing Closure Commands

Windows commands run on 2026-07-18:

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_ekf_update_core\run_gpp_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_ekf_update_core\run_vivado_hls_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_ekf_update_core\run_vivado_hls_csynth.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_ekf_update_core\run_vivado_hls_export_ip.ps1
```

The Vivado HLS Tcl now uses `target_clock_ns=8` by default. The PowerShell
scripts expose `-ClockNs`, defaulting to `8`.
