# Stage68 Mapping FPGA_FULL Online Smoke Summary

Result: PASS for Stage68 online-path smoke.

## Hardware Gate

- XDMA driver: bound to `0005:01:00.0`
- Device nodes: `/dev/xdma0_user`, `/dev/xdma0_h2c_0`, `/dev/xdma0_c2h_0` present
- PCIe enable: `1`
- PCIe link: kernel reports Gen2 x1, still downgraded from x4
- Smoke: `SHIM_SMOKE_PASS`, `REG_SMOKE_PASS`, `DDR_SMOKE_PASS`
- Kernel errors: no new XDMA config BAR failure, `CmpltTO`, AER fatal, offline, or frozen errors

## Golden Regression

- Mapping observation V2: `MAPPING_XDMA_REPLAY_PASS`
- Mapping counts: `611/0/171`
- Mapping observation HLS wait: `17.015 ms`
- Mapping EKF update repeat: `MAPPING_EKF_UPDATE_REPEAT_PASS repeat=50`
- EKF update HLS wait: about `4.28 ms` per transaction
- EKF numeric error: `dx_max_abs=4.96565e-17`, `cov_max_abs=1.53144e-18`, `state_max_abs=4.94396e-17`

## Online-Path Smoke

Input was the fixed short bag:

```text
/home/hit/Cheng/FPGA_ACC/mid360_20260313_outdoor_30deg_up_quan_03_0.db3
```

Temporary config:

```text
mapping.mode=fpga_full
localization.enable=false
fasterlio.max_iteration=1
fasterlio.enable_icp_part=false
fasterlio.use_aa=false
```

Observed markers:

```text
mapping_backend=FPGA_FULL
mapping FPGA_FULL observation success=1
ekf_update success=1
kernel_sel_obs=4
kernel_sel_ekf=5
fallback=0
```

Statistics from the 75 s controlled smoke:

```text
FPGA_FULL success frames: 2048
old obs_call= pattern: 0
old mapping FPGA_OBS success markers: 0
fallback markers: 0
abnormal dt count: 0
```

Timing:

```text
frame_total_ms mean=32.750, p95=39.402, max=61.295
FPGA_FULL full_total_ms mean=28.822, p95=34.727, max=53.357
observation hls_wait_ms mean=19.301, p95=25.547, max=42.628
EKF update hls_wait_ms mean=4.280, p95=4.328, max=7.583
scan_points mean=793.9, max=1720
active_blocks mean=461.9, max=911
active_cells mean=118235, max=233216
```

Conclusion:

Stage68A/B are functionally complete. Online mapping `FPGA_FULL` no longer
routes through the old per-iteration `ObsModelFpgaObservation()` path, and it
does call both observation V2 and EKF update hardware once per lidar frame.

Remaining notes:

- CPU map incremental update is still used after the FPGA observation + FPGA EKF update.
- `run_slam_offline` was used as a controlled rosbag driver for the same `LaserMapping` path; a live `run_slam_online` UI run is still useful for Stage69 mapping quality comparison.
- The PCIe link remains Gen2 x1, but this Stage68 smoke was not blocked by it.

