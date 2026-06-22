# Stage61 Orin ABI V2 Candidate Commands

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

Only existing warnings appeared.

## Runtime Lock

```bash
rm -f /tmp/lightning_xdma_observation.lock
sudo -n bash -lc 'touch /tmp/lightning_xdma_observation.lock && chmod 666 /tmp/lightning_xdma_observation.lock'
```

## Smoke

```bash
set -o pipefail
source install/setup.bash
sudo -n env LD_LIBRARY_PATH="$LD_LIBRARY_PATH" AMENT_PREFIX_PATH="$AMENT_PREFIX_PATH" PATH="$PATH" \
  ./install/lightning/lib/lightning/run_surfel_loc_xdma_golden \
  --golden_dir fpga/golden/localization/frame_000001 \
  --ctrl_base 0x1000 \
  --shim_smoke \
  --reg_smoke \
  --ddr_smoke \
  2>&1 | tee reports/fpga/runtime/stage61_abi_v2_orin/smoke.log
```

Observed:

```text
XDMA_CPP_SHIM_SMOKE_PASS
XDMA_CPP_REG_SMOKE_PASS
CTRL_BASE=0x00001000
XDMA_CPP_DDR_SMOKE_PASS
```

## V1 Regression

```bash
set -o pipefail
source install/setup.bash
sudo -n env LD_LIBRARY_PATH="$LD_LIBRARY_PATH" AMENT_PREFIX_PATH="$AMENT_PREFIX_PATH" PATH="$PATH" \
  ./install/lightning/lib/lightning/run_surfel_loc_xdma_golden \
  --golden_dir fpga/golden/localization/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120 \
  --repeat 1 \
  2>&1 | tee reports/fpga/runtime/stage61_abi_v2_orin/loc_v1_regression.log
```

Observed:

```text
abi_v2_candidates=0
ITER=1/1 STATUS=0x00000204 ERROR=0x00000000 RUN_COUNT=0->1 ELAPSED_SEC=0.373969
COUNTS=6050/911/2
XDMA_CPP_GOLDEN_NUMERIC_PASS
```

## V2 Localization Golden Replay

```bash
set -o pipefail
source install/setup.bash
sudo -n env LD_LIBRARY_PATH="$LD_LIBRARY_PATH" AMENT_PREFIX_PATH="$AMENT_PREFIX_PATH" PATH="$PATH" \
  ./install/lightning/lib/lightning/run_surfel_loc_xdma_golden \
  --golden_dir fpga/golden/localization/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120 \
  --repeat 3 \
  --abi_v2_candidates \
  --output_dir reports/fpga/runtime/stage61_abi_v2_orin/loc_v2 \
  2>&1 | tee reports/fpga/runtime/stage61_abi_v2_orin/loc_v2.log
```

Observed:

```text
abi_v2_candidates=1
scan_count=6963
expected_counts=6050/911/2
iter 1: STATUS=0x204 ERROR=0x0 RUN_COUNT=1->2 elapsed=0.120245 counts=6050/911/2
iter 2: STATUS=0x204 ERROR=0x0 RUN_COUNT=2->3 elapsed=0.120295 counts=6050/911/2
iter 3: STATUS=0x204 ERROR=0x0 RUN_COUNT=3->4 elapsed=0.120330 counts=6050/911/2
candidate_count=6963
candidate_valid=6961
candidate_miss=2
candidate_bytes=445632
XDMA_CPP_GOLDEN_REPEAT_PASS ITERATIONS=3 ABI_V2_CANDIDATES=1
```

## V2 Mapping Golden Replay

```bash
set -o pipefail
source install/setup.bash
for i in 1 2 3; do
  echo "MAPPING_V2_ITER=$i"
  { time -p sudo -n env LD_LIBRARY_PATH="$LD_LIBRARY_PATH" AMENT_PREFIX_PATH="$AMENT_PREFIX_PATH" PATH="$PATH" \
    ./install/lightning/lib/lightning/run_surfel_mapping_xdma_golden \
    --golden_dir fpga/golden/mapping/frame_000001 \
    --ctrl_base 0x1000 \
    --timeout_sec 120 \
    --abi_v2_candidates; } 2>&1 | sed 's/^/  /'
done 2>&1 | tee reports/fpga/runtime/stage61_abi_v2_orin/mapping_v2.log
```

Observed:

```text
iter 1: MAPPING_XDMA_REPLAY_PASS, counts actual=611/0/171 expected=611/0/171, hls_wait_sec=0.0150208
iter 2: MAPPING_XDMA_REPLAY_PASS, counts actual=611/0/171 expected=611/0/171, hls_wait_sec=0.0149113
iter 3: MAPPING_XDMA_REPLAY_PASS, counts actual=611/0/171 expected=611/0/171, hls_wait_sec=0.0149318
candidate_count=782
candidate_valid=653
candidate_miss=129
candidate_bytes=50048
```

## V2 Localization Analysis

```bash
python3 - <<'PY' | tee reports/fpga/runtime/stage61_abi_v2_orin/loc_v2_analysis.txt
# See saved command in shell history; output recorded below.
PY
```

Observed:

```text
LOC_V2_ELAPSED_SEC_LIST= [0.120244502, 0.120294525, 0.120329677]
LOC_V2_ELAPSED_SEC_MEAN= 0.120289568
LOC_V2_SPEEDUP_VS_STAGE57_1536MS= 12.769187100247962
LOC_V2_SPEEDUP_VS_STAGE58_350090MS= 2.9103947179636838
LOC_V2_CANDIDATES= [(6963, 6961, 2, 445632), (6963, 6961, 2, 445632), (6963, 6961, 2, 445632)]
debug_magic=0x53543631
debug_version=1
point_count=6963
exact_hit=6961
neighbor_hit=0
lookup_miss=2
neighbor_probe_count=0
block_lookup_count=0
block_search_steps=0
obs_cell_read_count=0
valid_candidate_count=6961
invalid_candidate_count=2
max_probe_per_point=0
active_block_cache_count=3719
debug_flags=0x00000001
```
