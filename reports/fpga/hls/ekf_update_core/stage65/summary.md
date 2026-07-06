# Stage65A Mapping EKF Update HLS Summary

Date: 2026-07-06

Status: PASS.

Scope:

- Added standalone `slam_ekf_update_core` HLS IP source under `fpga/hls/`.
- Kept observation HLS, Vivado BD, XDMA/MIG, BAR shim, and bitstream unchanged.
- Implemented current mapping update dimensions: 12D `NavState` error state
  and 6D lidar/surfel pose observation.

Commands:

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_ekf_update_core\run_gpp_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_ekf_update_core\run_vivado_hls_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_ekf_update_core\run_vivado_hls_csynth.ps1
```

CSim:

```text
MAPPING_EKF_UPDATE_HLS_CSIM_PASS
flags_ok=1
dx_max_abs=2.1792463667e-17
cov_max_abs=1.08504920543e-18
state_max_abs=2.08166817117e-17
actual_nullity=0
expected_nullity=0
status=0x9
```

C Synthesis:

```text
target clock:    10.00 ns
estimated clock: 9.544 ns
latency:         19632..202755 cycles
BRAM_18K:        94 / 1510 = 6%
DSP48E:          399 / 2020 = 19%
FF:              63645 / 554800 = 11%
LUT:             78126 / 277400 = 28%
```

Notes:

- The CSim executable is named `ekf_tb.exe` to avoid Windows UAC installer
  detection on executable names containing `update`.
- Stage65A is standalone HLS only. Board integration and Orin runtime are
  Stage65B/C.

Next:

- Define EKF update DDR layout and `slam_accel_ctrl` command/port contract.
- Integrate the separate HLS IP only after preserving Stage61/62/63 regression
  gates.
