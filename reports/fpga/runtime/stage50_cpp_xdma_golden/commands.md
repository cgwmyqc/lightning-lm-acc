# Stage 50 C++ XDMA Golden Replay

## Build

```bash
colcon build --packages-select lightning
```

## Orin Gate

```bash
lspci -nnk -s 0005:01:00.0
ls -l /dev/xdma0_user /dev/xdma0_h2c_0 /dev/xdma0_c2h_0
cat /sys/bus/pci/devices/0005:01:00.0/enable
```

## C++ Runtime Smoke

```bash
ros2 run lightning run_surfel_loc_xdma_golden \
  --golden_dir fpga/golden/localization/frame_000001 \
  --ctrl_base 0x1000 \
  --shim_smoke \
  --reg_smoke \
  --ddr_smoke
```

Expected markers:

```text
XDMA_CPP_SHIM_SMOKE_PASS
XDMA_CPP_REG_SMOKE_PASS
XDMA_CPP_DDR_SMOKE_PASS
```

## C++ Full-Frame Replay

```bash
ros2 run lightning run_surfel_loc_xdma_golden \
  --golden_dir fpga/golden/localization/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120 \
  --verify_readback \
  --repeat 3 \
  --output_dir reports/fpga/runtime/stage50_cpp_xdma_golden
```

Expected markers:

```text
XDMA_CPP_GOLDEN_LOAD_PASS
XDMA_CPP_GOLDEN_NUMERIC_PASS
XDMA_CPP_GOLDEN_REPEAT_PASS
```

## Orin Result 2026-06-21

The installed binary was run with `sudo -E` because `/dev/xdma0_*` is owned by root.

Actual smoke command:

```bash
bash -lc 'source install/setup.bash && sudo -n env LD_LIBRARY_PATH="$LD_LIBRARY_PATH" AMENT_PREFIX_PATH="$AMENT_PREFIX_PATH" PATH="$PATH" ./install/lightning/lib/lightning/run_surfel_loc_xdma_golden \
  --golden_dir fpga/golden/localization/frame_000001 \
  --ctrl_base 0x1000 \
  --shim_smoke \
  --reg_smoke \
  --ddr_smoke'
```

Actual replay command:

```bash
bash -lc 'source install/setup.bash && sudo -n env LD_LIBRARY_PATH="$LD_LIBRARY_PATH" AMENT_PREFIX_PATH="$AMENT_PREFIX_PATH" PATH="$PATH" ./install/lightning/lib/lightning/run_surfel_loc_xdma_golden \
  --golden_dir fpga/golden/localization/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120 \
  --verify_readback \
  --repeat 3 \
  --output_dir reports/fpga/runtime/stage50_cpp_xdma_golden'
```

Build:

```text
colcon build --packages-select lightning
PASS
```

Gate:

```text
Kernel driver in use: xdma
/dev/xdma0_user /dev/xdma0_h2c_0 /dev/xdma0_c2h_0 present
enable=1
```

Smoke:

```text
XDMA_CPP_SHIM_SMOKE_PASS
XDMA_CPP_REG_SMOKE_PASS
CTRL_BASE=0x00001000
XDMA_CPP_DDR_SMOKE_PASS
```

Replay:

```text
XDMA_CPP_GOLDEN_LOAD_PASS
scan_count=6963
active_blocks=3719
active_cells=952064
expected_counts=6050/911/2
ITER=1/3 STATUS=0x00000204 ERROR=0x00000000 RUN_COUNT=24->25 SCAN_COUNT_READBACK=6963 COUNTS=6050/911/2
ITER=2/3 STATUS=0x00000204 ERROR=0x00000000 RUN_COUNT=25->26 SCAN_COUNT_READBACK=6963 COUNTS=6050/911/2
ITER=3/3 STATUS=0x00000204 ERROR=0x00000000 RUN_COUNT=26->27 SCAN_COUNT_READBACK=6963 COUNTS=6050/911/2
OUTPUT_WORD[27]=0x0000038f000017a2
OUTPUT_WORD[28]=0x0000000000000002
XDMA_CPP_COMPARE counts_ok=1 values_ok=1 max_abs=0.0078906 max_rel=4.41926e-05 worst_field=b(4)
XDMA_CPP_GOLDEN_REPEAT_PASS ITERATIONS=3 MAX_ELAPSED_SEC=1.52723
```

Kernel log check found no new `Failed to detect XDMA config BAR`, `CmpltTO`, AER fatal, or XDMA offline entry.
