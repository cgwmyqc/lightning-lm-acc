# Stage62 Orin Commands

## XDMA Gate

```bash
mkdir -p reports/fpga/runtime/stage62_solve6x6_orin/loc_solve6x6
lspci -nnk -s 0005:01:00.0 | tee reports/fpga/runtime/stage62_solve6x6_orin/xdma_gate.log
lspci -vv -s 0005:01:00.0 | grep -Ei 'LnkCap|LnkSta' | tee -a reports/fpga/runtime/stage62_solve6x6_orin/xdma_gate.log
ls -l /dev/xdma0_user /dev/xdma0_h2c_0 /dev/xdma0_c2h_0 | tee -a reports/fpga/runtime/stage62_solve6x6_orin/xdma_gate.log
cat /sys/bus/pci/devices/0005:01:00.0/enable | tee -a reports/fpga/runtime/stage62_solve6x6_orin/xdma_gate.log
journalctl -k --no-pager | grep -Ei 'xdma|10ee|7024|0005:01:00|CmpltTO|BAR|probe|AER|link|offline|reset|recovery|frozen' | tail -n 120 | tee reports/fpga/runtime/stage62_solve6x6_orin/journal_before.log
```

## Build And Runtime Lock

```bash
colcon build --packages-select lightning
source install/setup.bash
rm -f /tmp/lightning_xdma_observation.lock
sudo -n bash -lc 'touch /tmp/lightning_xdma_observation.lock && chmod 666 /tmp/lightning_xdma_observation.lock'
```

## Smoke

```bash
sudo -n env LD_LIBRARY_PATH="$LD_LIBRARY_PATH" AMENT_PREFIX_PATH="$AMENT_PREFIX_PATH" PATH="$PATH" \
  ./install/lightning/lib/lightning/run_surfel_loc_xdma_golden \
  --golden_dir fpga/golden/localization/frame_000001 \
  --ctrl_base 0x1000 \
  --shim_smoke \
  --reg_smoke \
  --ddr_smoke
```

Markers:

```text
XDMA_CPP_SHIM_SMOKE_PASS
XDMA_CPP_REG_SMOKE_PASS
XDMA_CPP_DDR_SMOKE_PASS
```

## Localization V2 Regression

```bash
sudo -n env LD_LIBRARY_PATH="$LD_LIBRARY_PATH" AMENT_PREFIX_PATH="$AMENT_PREFIX_PATH" PATH="$PATH" \
  ./install/lightning/lib/lightning/run_surfel_loc_xdma_golden \
  --golden_dir fpga/golden/localization/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120 \
  --repeat 1 \
  --abi_v2_candidates
```

Markers:

```text
XDMA_CPP_GOLDEN_NUMERIC_PASS
COUNTS=6050/911/2
```

## Localization V2 + FPGA Solve6x6

```bash
sudo -n env LD_LIBRARY_PATH="$LD_LIBRARY_PATH" AMENT_PREFIX_PATH="$AMENT_PREFIX_PATH" PATH="$PATH" \
  ./install/lightning/lib/lightning/run_surfel_loc_xdma_golden \
  --golden_dir fpga/golden/localization/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120 \
  --repeat 3 \
  --abi_v2_candidates \
  --fpga_solve6x6 \
  --output_dir reports/fpga/runtime/stage62_solve6x6_orin/loc_solve6x6
```

Markers:

```text
LOC_XDMA_SOLVE6X6_PASS
FPGA_SOLVE6X6_STATUS=1
XDMA_CPP_GOLDEN_REPEAT_PASS ITERATIONS=3 ABI_V2_CANDIDATES=1
COUNTS=6050/911/2
```

## Mapping V2 Regression

```bash
sudo -n env LD_LIBRARY_PATH="$LD_LIBRARY_PATH" AMENT_PREFIX_PATH="$AMENT_PREFIX_PATH" PATH="$PATH" \
  ./install/lightning/lib/lightning/run_surfel_mapping_xdma_golden \
  --golden_dir fpga/golden/mapping/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120 \
  --abi_v2_candidates
```

Markers:

```text
MAPPING_XDMA_REPLAY_PASS
counts actual=611/0/171 expected=611/0/171
```

