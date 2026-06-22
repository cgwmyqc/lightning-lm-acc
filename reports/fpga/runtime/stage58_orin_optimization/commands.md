# Stage58 Orin Optimization Commands

Date: 2026-06-22

## XDMA Gate

```bash
lspci -nnk -s 0005:01:00.0
lspci -vv -s 0005:01:00.0 | grep -Ei 'LnkCap|LnkSta'
ls -l /dev/xdma0_user /dev/xdma0_h2c_0 /dev/xdma0_c2h_0
cat /sys/bus/pci/devices/0005:01:00.0/enable
journalctl -k --no-pager | grep -Ei 'xdma|10ee|7024|0005:01:00|CmpltTO|BAR|probe|AER|link|offline|reset|recovery|frozen' | tail -n 120
```

Observed:

```text
0005:01:00.0 Serial controller [0700]: Xilinx Corporation Device [10ee:7024]
Kernel driver in use: xdma
/dev/xdma0_user, /dev/xdma0_h2c_0, /dev/xdma0_c2h_0 present
enable=1
LnkCap: Speed 5GT/s, Width x4
LnkSta: Speed 5GT/s, Width x1 (downgraded)
```

## Build

```bash
colcon build --packages-select lightning
```

Observed:

```text
Summary: 1 package finished
```

Only the existing setuptools invalid-version warning appeared.

## Smoke

```bash
source install/setup.bash
sudo -n env LD_LIBRARY_PATH="$LD_LIBRARY_PATH" AMENT_PREFIX_PATH="$AMENT_PREFIX_PATH" PATH="$PATH" \
  ./install/lightning/lib/lightning/run_surfel_loc_xdma_golden \
  --golden_dir fpga/golden/localization/frame_000001 \
  --ctrl_base 0x1000 \
  --shim_smoke \
  --reg_smoke \
  --ddr_smoke \
  2>&1 | tee reports/fpga/runtime/stage58_orin_optimization/smoke.log
```

Observed:

```text
XDMA_CPP_SHIM_SMOKE_PASS
XDMA_CPP_REG_SMOKE_PASS
CTRL_BASE=0x00001000
XDMA_CPP_DDR_SMOKE_PASS
```

## Localization Full Golden Replay

Before replay, the stale user-owned `/tmp/lightning_xdma_observation.lock` caused `Permission denied` under sudo. It was removed and recreated by root as a temporary host-state fix:

```bash
rm -f /tmp/lightning_xdma_observation.lock
sudo -n bash -lc 'touch /tmp/lightning_xdma_observation.lock && chmod 666 /tmp/lightning_xdma_observation.lock'
```

Replay command:

```bash
source install/setup.bash
sudo -n env LD_LIBRARY_PATH="$LD_LIBRARY_PATH" AMENT_PREFIX_PATH="$AMENT_PREFIX_PATH" PATH="$PATH" \
  ./install/lightning/lib/lightning/run_surfel_loc_xdma_golden \
  --golden_dir fpga/golden/localization/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120 \
  --repeat 3 \
  --output_dir reports/fpga/runtime/stage58_orin_optimization/loc_cpp \
  2>&1 | tee reports/fpga/runtime/stage58_orin_optimization/loc_cpp.log
```

Observed:

```text
XDMA_CPP_GOLDEN_LOAD_PASS
scan_count=6963
active_blocks=3719
active_cells=952064
expected_counts=6050/911/2
ITER=1/3 STATUS=0x00000204 ERROR=0x00000000 RUN_COUNT=0->1 ELAPSED_SEC=0.350222
COUNTS=6050/911/2
XDMA_CPP_GOLDEN_NUMERIC_PASS
ITER=2/3 STATUS=0x00000204 ERROR=0x00000000 RUN_COUNT=1->2 ELAPSED_SEC=0.350393
COUNTS=6050/911/2
XDMA_CPP_GOLDEN_NUMERIC_PASS
ITER=3/3 STATUS=0x00000204 ERROR=0x00000000 RUN_COUNT=2->3 ELAPSED_SEC=0.349656
COUNTS=6050/911/2
XDMA_CPP_GOLDEN_NUMERIC_PASS
XDMA_CPP_GOLDEN_REPEAT_PASS ITERATIONS=3 MAX_ELAPSED_SEC=0.350393
```

## Mapping Full Golden Replay

The host does not provide `/usr/bin/time`, so shell `time -p` was used.

```bash
source install/setup.bash
for i in 1 2 3; do
  echo "MAPPING_ITER=$i"
  { time -p sudo -n env LD_LIBRARY_PATH="$LD_LIBRARY_PATH" AMENT_PREFIX_PATH="$AMENT_PREFIX_PATH" PATH="$PATH" \
    ./install/lightning/lib/lightning/run_surfel_mapping_xdma_golden \
    --golden_dir fpga/golden/mapping/frame_000001 \
    --ctrl_base 0x1000 \
    --timeout_sec 120; } 2>&1 | sed 's/^/  /'
done 2>&1 | tee reports/fpga/runtime/stage58_orin_optimization/mapping_cpp.log
```

Observed:

```text
MAPPING_ITER=1
MAPPING_XDMA_REPLAY_PASS
counts actual=611/0/171 expected=611/0/171
real 0.17
MAPPING_ITER=2
MAPPING_XDMA_REPLAY_PASS
counts actual=611/0/171 expected=611/0/171
real 0.16
MAPPING_ITER=3
MAPPING_XDMA_REPLAY_PASS
counts actual=611/0/171 expected=611/0/171
real 0.17
```

## Parse Localization Effect

```bash
python3 - <<'PY'
import json, pathlib, statistics
base = pathlib.Path("reports/fpga/runtime/stage58_orin_optimization/loc_cpp")
vals = []
words = []
for p in sorted(base.glob("cpp_full_frame_output_iter_*.json")):
    j = json.loads(p.read_text())
    vals.append(float(j["elapsed_sec"]))
    words.append(j["raw_output_words"][32:40])
print("LOC_ELAPSED_SEC_LIST=", vals)
print("LOC_ELAPSED_SEC_MEAN=", statistics.mean(vals))
print("LOC_SPEEDUP_VS_STAGE57_1536MS=", 1.536 / statistics.mean(vals))
print("LOC_STAGE58_DEBUG_WORDS_32_39_LAST=", words[-1] if words else [])
PY
```

Observed:

```text
LOC_ELAPSED_SEC_LIST= [0.350221653, 0.350393214, 0.349655503]
LOC_ELAPSED_SEC_MEAN= 0.35009012333333334
LOC_SPEEDUP_VS_STAGE57_1536MS= 4.387441683230576
LOC_STAGE58_DEBUG_WORDS_32_39_LAST= [
  '0x0000000153543538',
  '0x00000df500001b33',
  '0x0000000200000d3c',
  '0x00002ccb0001584c',
  '0x0001726b00021706',
  '0x00010197000071e8',
  '0x00000e870000001b',
  '0x0000000000000000'
]
```
