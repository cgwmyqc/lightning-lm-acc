# Stage 51 Unified Observation Runtime v1 Localization Commands

## Build

```bash
colcon build --packages-select lightning
```

Result:

```text
PASS
```

## Stage 50 C++ Golden Regression

```bash
bash -lc 'source install/setup.bash && sudo -n env LD_LIBRARY_PATH="$LD_LIBRARY_PATH" AMENT_PREFIX_PATH="$AMENT_PREFIX_PATH" PATH="$PATH" ./install/lightning/lib/lightning/run_surfel_loc_xdma_golden \
  --golden_dir fpga/golden/localization/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120 \
  --repeat 1'
```

Observed marker:

```text
XDMA_CPP_GOLDEN_NUMERIC_PASS
scan_count=6963
COUNTS=6050/911/2
STATUS=0x00000204
ERROR=0x00000000
RUN_COUNT=27->28
```

## Default Config Backend Check

```bash
timeout --signal=SIGINT 12s bash -lc 'source install/setup.bash && ./install/lightning/lib/lightning/run_loc_offline \
  --input_bag /home/hit/Cheng/FPGA_ACC/mid360_20260313_outdoor_30deg_up_quan_03_0.db3 \
  --config config/default_livox.yaml \
  --map_path /home/hit/Cheng/FPGA_ACC/lightning-lm-acc/data/new_map/ 2>&1' | tee /tmp/lightning_stage51_default_ndt.log
```

Observed marker:

```text
[LidarLoc] backend=NDT_OMP fpga_global_enable=0 fpga_localization_enable=0
```

Note: `run_loc_offline` printed `done`, then hit an existing GLX/EGL assertion during process teardown in this headless shell. No tracked map files were modified.

## FPGA_OBS Online Smoke Config

Temporary config used for this smoke test:

```text
/tmp/lightning_stage51_fpga_obs.yaml
```

Changed keys:

```yaml
fpga:
  enable: true
  localization:
    enable: true
    mode: fpga_obs
    fallback: ndt_omp
```

## FPGA_OBS Online Smoke

```bash
timeout --signal=SIGKILL 60s bash -lc 'source install/setup.bash && sudo -n env LD_LIBRARY_PATH="$LD_LIBRARY_PATH" AMENT_PREFIX_PATH="$AMENT_PREFIX_PATH" PATH="$PATH" ./install/lightning/lib/lightning/run_loc_offline \
  --input_bag /home/hit/Cheng/FPGA_ACC/mid360_20260313_outdoor_30deg_up_quan_03_0.db3 \
  --config /tmp/lightning_stage51_fpga_obs.yaml \
  --map_path /home/hit/Cheng/FPGA_ACC/lightning-lm-acc/data/new_map/ 2>&1' | tee /tmp/lightning_stage51_fpga_obs.log
```

The process was manually interrupted after sufficient smoke coverage because the outer timeout did not terminate the sudo child process cleanly.

Key markers:

```text
[LidarLoc] backend=SURFEL_FPGA_OBS
[LidarLoc] surfel FPGA_OBS success=1
```

Log checks:

```bash
rg -c "surfel FPGA_OBS success=1" /tmp/lightning_stage51_fpga_obs.log
rg -c "surfel FPGA_OBS success=0|SURFEL_FPGA_OBS failed|ComputeObservation failed|fallback to SURFEL_CPU_SIM|fallback to NDT" /tmp/lightning_stage51_fpga_obs.log
```

Observed:

```text
surfel FPGA_OBS success=1: 35
localization FPGA_OBS failure/fallback markers: 0
```

Representative first and last FPGA_OBS frames:

```text
valid=2613 reject=259 miss=2 mean_abs_residual=0.0689565 xdma_elapsed_sum=2.36148 xdma_elapsed_max=0.594914
valid=6199 reject=755 miss=1 mean_abs_residual=0.0560587 xdma_elapsed_sum=4.1079 xdma_elapsed_max=1.37255
```
