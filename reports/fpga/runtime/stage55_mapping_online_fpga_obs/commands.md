# Stage55 Mapping Online FPGA_OBS Commands

## Build

```bash
colcon build --packages-select lightning
```

Observed:

```text
Summary: 1 package finished
```

## Serial Golden Regression

```bash
source install/setup.bash
sudo -E env LD_LIBRARY_PATH="$LD_LIBRARY_PATH" AMENT_PREFIX_PATH="$AMENT_PREFIX_PATH" \
  ./install/lightning/lib/lightning/run_surfel_mapping_xdma_golden \
    --golden_dir fpga/golden/mapping/frame_000001 \
    --ctrl_base 0x1000 \
    --timeout_sec 120
```

Observed:

```text
STATUS=0x204
ERROR=0x0
RUN_COUNT=680->681
SCAN_COUNT_READBACK=782
counts actual=611/0/171 expected=611/0/171
MAPPING_XDMA_REPLAY_PASS
```

## Concurrent XDMA Lock Regression

Run localization and mapping golden replay at the same time:

```bash
source install/setup.bash
sudo -E env LD_LIBRARY_PATH="$LD_LIBRARY_PATH" AMENT_PREFIX_PATH="$AMENT_PREFIX_PATH" \
  ./install/lightning/lib/lightning/run_surfel_loc_xdma_golden \
    --golden_dir fpga/golden/localization/frame_000001 \
    --ctrl_base 0x1000 \
    --timeout_sec 120 \
    --repeat 1

source install/setup.bash
sudo -E env LD_LIBRARY_PATH="$LD_LIBRARY_PATH" AMENT_PREFIX_PATH="$AMENT_PREFIX_PATH" \
  ./install/lightning/lib/lightning/run_surfel_mapping_xdma_golden \
    --golden_dir fpga/golden/mapping/frame_000001 \
    --ctrl_base 0x1000 \
    --timeout_sec 120
```

Observed:

```text
XDMA_CPP_GOLDEN_NUMERIC_PASS
COUNTS=6050/911/2
RUN_COUNT=681->682

MAPPING_XDMA_REPLAY_PASS
counts actual=611/0/171 expected=611/0/171
RUN_COUNT=682->683
```

