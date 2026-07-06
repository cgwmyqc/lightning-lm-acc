# slam_ekf_update_core

Standalone Vivado HLS core for Stage65A mapping ESKF update.

Scope:

- Separate HLS IP from `unified_surfel_observation_core`.
- Fixed 12D `NavState` error state and 6D lidar/surfel pose observation.
- Reads a fixed 64-bit word input ABI and writes a fixed 64-bit word output ABI.
- Matches Stage64 `mapping_update::RunUpdateStep()` golden replay.

Not in Stage65A:

- Vivado block design integration.
- XDMA/MIG/BAR shim changes.
- Online mapping runtime enable.

Windows commands:

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_ekf_update_core\run_gpp_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_ekf_update_core\run_vivado_hls_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_ekf_update_core\run_vivado_hls_csynth.ps1
```

Expected CSim marker:

```text
MAPPING_EKF_UPDATE_HLS_CSIM_PASS
```

