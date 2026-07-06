# Stage63 Online FPGA_OBS_SOLVE Commands

## Configuration

Temporary `config/default_livox.yaml` settings used for this smoke test:

```yaml
fpga:
  enable: true
  runtime:
    candidate_abi_v2: true
  mapping:
    enable: false
  localization:
    enable: true
    mode: fpga_obs_solve
    fallback: ndt_omp

lidar_loc:
  surfel_max_iterations: 1
```

## Golden Sanity

```bash
source install/setup.bash
sudo -n env LD_LIBRARY_PATH="$LD_LIBRARY_PATH" AMENT_PREFIX_PATH="$AMENT_PREFIX_PATH" PATH="$PATH" \
  ./install/lightning/lib/lightning/run_surfel_loc_xdma_golden \
  --golden_dir fpga/golden/localization/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120 \
  --abi_v2_candidates \
  --fpga_solve6x6
```

Observed markers:

```text
LOC_XDMA_SOLVE6X6_PASS
FPGA_SOLVE6X6_STATUS=1
COUNTS=6050/911/2
```

## Online Smoke

Terminal 1:

```bash
source install/setup.bash
ros2 run lightning run_loc_online --config ./config/default_livox.yaml \
  2>&1 | tee reports/fpga/runtime/stage63_online_fpga_obs_solve/loc_online.log
```

Terminal 2:

```bash
source install/setup.bash
timeout 35s ros2 bag play /home/hit/Cheng/FPGA_ACC/mid360_20260313_outdoor_30deg_up_quan_03_0.db3
```

Observed markers:

```text
[LaserMapping] mapping_backend=CPU
[LidarLoc] backend=SURFEL_FPGA_OBS_SOLVE
[LidarLoc] surfel SURFEL_FPGA_OBS_SOLVE ... fpga_solve_status=1 ... dx_norm=...
[loc_profile] ... backend=SURFEL_FPGA_OBS_SOLVE ... fallback_cpu_sim=0 fallback_ndt=0
```
