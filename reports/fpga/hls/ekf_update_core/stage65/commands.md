# Stage65A Commands

Standalone g++ CSim:

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_ekf_update_core\run_gpp_csim.ps1
```

Expected marker:

```text
MAPPING_EKF_UPDATE_HLS_CSIM_PASS
```

Vivado HLS CSim:

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_ekf_update_core\run_vivado_hls_csim.ps1
```

Expected marker:

```text
INFO: [SIM 211-1] CSim done with 0 errors.
MAPPING_EKF_UPDATE_HLS_CSIM_PASS
```

Vivado HLS C Synthesis:

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_ekf_update_core\run_vivado_hls_csynth.ps1
```

Expected marker:

```text
HLS_EKF_UPDATE_CSYNTH_PASS
```

Generated C synthesis report:

```text
fpga/vivado/.build/hls_slam_ekf_update_csynth/solution1/syn/report/slam_ekf_update_core_csynth.rpt
```
