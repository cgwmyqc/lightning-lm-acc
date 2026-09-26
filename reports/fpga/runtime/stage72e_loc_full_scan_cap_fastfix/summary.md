# Stage72E Loc Full Scan Cap Fastfix Summary

Date: 2026-08-31

Result: Orin software fastfix implemented; build and golden sanity PASS.

Implemented:

```text
lidar_loc.surfel_fpga_full_max_scan_points: 7600
LocalizeSurfelFpgaFullIterative() now uniformly caps the cloud before KERNEL_SEL=6.
Logs/profile/UI expose raw_scan_points, scan_points_used, cap_enabled, cap_target.
```

Validation:

```text
colcon build --packages-select lightning: PASS
git diff --check: PASS
LOC_ITER_XDMA_PASS
counts=6124/837/2
iterations=4
STATUS=0x204
ERROR=0x0
RUN_COUNT=16683->16684
hls_wait_sec=0.236790
```

Real-lidar acceptance still to run:

```text
backend=SURFEL_FPGA_FULL_ITERATIVE
kernel_sel=6
raw_scan_points=8xxx
scan_points_used=7600
cap_enabled=1
cap_target=7600
loc_iter_status=1
fallback_cpu_sim=0
```
