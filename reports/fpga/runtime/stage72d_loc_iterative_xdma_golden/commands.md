# Stage72D Orin Commands

Date: 2026-07-19

## Build

```bash
colcon build --packages-select lightning
source install/setup.bash
```

## XDMA Gate

```bash
lspci -nnk -s 0005:01:00.0
ls -l /dev/xdma0_user /dev/xdma0_h2c_0 /dev/xdma0_c2h_0
cat /sys/bus/pci/devices/0005:01:00.0/enable
journalctl -k --no-pager | grep -Ei 'xdma|10ee|7024|0005:01:00|CmpltTO|BAR|probe|AER|offline|frozen' | tail -n 120
```

Result:

```text
Kernel driver in use: xdma
/dev/xdma0_user present
/dev/xdma0_h2c_0 present
/dev/xdma0_c2h_0 present
enable=1
```

## Smoke

```bash
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --ddr-smoke
```

Markers:

```text
SHIM_SMOKE_PASS
REG_SMOKE_PASS
DDR_SMOKE_PASS
```

## CPU Replay

```bash
ros2 run lightning run_surfel_loc_iterative_golden_replay \
  --golden_dir fpga/golden/localization_iterative/frame_000001
```

Markers:

```text
LOC_ITER_CPU_REPLAY_PASS
loc_iter_expected.bin parser roundtrip PASS
```

## XDMA Golden Replay

```bash
sudo -n env LD_LIBRARY_PATH="$LD_LIBRARY_PATH" AMENT_PREFIX_PATH="$AMENT_PREFIX_PATH" PATH="$PATH" \
  ./install/lightning/lib/lightning/run_surfel_loc_iterative_xdma_golden \
  --golden_dir fpga/golden/localization_iterative/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120 \
  --repeat 3 \
  --verify_readback \
  --output_dir reports/fpga/runtime/stage72d_loc_iterative_xdma_golden
```

Markers:

```text
LOC_ITER_XDMA_START_PASS
LOC_ITER_XDMA_DONE_PASS
LOC_ITER_XDMA_NUMERIC_PASS
LOC_ITER_XDMA_PASS
```
