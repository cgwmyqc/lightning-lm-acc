# Stage67 Observation HLS Timing Closure Commands

Date: 2026-07-18

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_gpp_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_csynth.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_export_ip.ps1
```

The HLS Tcl entry now accepts a fifth `target_clock_ns` argument. The PowerShell wrappers default to `-ClockNs 8`, matching the 125 MHz XDMA `userclk2` board clock.

