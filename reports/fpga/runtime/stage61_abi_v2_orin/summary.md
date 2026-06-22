# Stage61 Orin ABI V2 Candidate Summary

Date: 2026-06-22

## Result

Stage61 Orin-side ABI V2 candidate golden replay passed.

```text
V1 localization regression: PASS
V2 localization golden:     PASS
V2 mapping golden:          PASS
Performance gate:           PASS
```

The V2 candidate path is confirmed on board:

```text
debug_magic=0x53543631 ("ST61")
block_lookup_count=0
block_search_steps=0
obs_cell_read_count=0
debug_flags=0x00000001
```

## XDMA / PCIe Gate

```text
0005:01:00.0 [10ee:7024]
Kernel driver in use: xdma
/dev/xdma0_user present
/dev/xdma0_h2c_0 present
/dev/xdma0_c2h_0 present
enable=1
```

PCIe link:

```text
LnkCap: Speed 5GT/s, Width x4
LnkSta: Speed 5GT/s, Width x1 (downgraded)
```

The link remains Gen2 x1. It is still a later performance item, but Stage61 V2 meets the full-frame golden gate even at x1.

No new `Failed to detect XDMA config BAR`, `CmpltTO`, or AER fatal marker was observed in the final journal tail.

## Build / Smoke

```text
colcon build --packages-select lightning: PASS
XDMA_CPP_SHIM_SMOKE_PASS
XDMA_CPP_REG_SMOKE_PASS
XDMA_CPP_DDR_SMOKE_PASS
```

Only existing build warnings appeared.

## V1 Regression

```text
abi_v2_candidates=0
scan_count=6963
active_blocks=3719
active_cells=952064
expected_counts=6050/911/2
elapsed=0.373969 s
counts=6050/911/2
XDMA_CPP_GOLDEN_NUMERIC_PASS
```

Stage61 did not break the Stage58/V1 lookup path.

## V2 Localization Golden Replay

```text
scan_count=6963
candidate_count=6963
candidate_valid=6961
candidate_miss=2
candidate_bytes=445632
expected_counts=6050/911/2
```

Iterations:

```text
iter 1: STATUS=0x204 ERROR=0x0 RUN_COUNT=1->2 elapsed=0.120245 s counts=6050/911/2
iter 2: STATUS=0x204 ERROR=0x0 RUN_COUNT=2->3 elapsed=0.120295 s counts=6050/911/2
iter 3: STATUS=0x204 ERROR=0x0 RUN_COUNT=3->4 elapsed=0.120330 s counts=6050/911/2
```

Performance:

```text
Stage57 baseline:        1.536000 s
Stage58 mean:            0.350090 s
Stage61 V2 mean:         0.120290 s
Speedup vs Stage57:      12.77x
Speedup vs Stage58:      2.91x
5x gate threshold:       <= 0.307 s
Stage61 gate result:     PASS
```

Numeric comparison:

```text
XDMA_CPP_GOLDEN_NUMERIC_PASS
XDMA_CPP_GOLDEN_REPEAT_PASS ITERATIONS=3 ABI_V2_CANDIDATES=1
max_abs=0.0078906
max_rel=4.41926e-05
worst_field=b(4)
```

Debug counters, last iteration:

```text
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

## V2 Mapping Golden Replay

Three mapping V2 golden replays passed:

```text
iter 1: MAPPING_XDMA_REPLAY_PASS, counts actual=611/0/171 expected=611/0/171, hls_wait_sec=0.0150208
iter 2: MAPPING_XDMA_REPLAY_PASS, counts actual=611/0/171 expected=611/0/171, hls_wait_sec=0.0149113
iter 3: MAPPING_XDMA_REPLAY_PASS, counts actual=611/0/171 expected=611/0/171, hls_wait_sec=0.0149318
```

Candidate stats:

```text
candidate_count=782
candidate_valid=653
candidate_miss=129
candidate_bytes=50048
```

## Conclusion

Stage61 is the first Orin-side hardware result that clears the agreed localization full-frame performance gate:

```text
Stage61 V2 full-frame localization elapsed ~= 120 ms
Stage58 full-frame localization elapsed ~= 350 ms
Stage57 full-frame localization elapsed ~= 1536 ms
```

The next stage may move from golden replay to controlled online smoke, but not directly to joint mapping + localization:

```text
Stage62: enable fpga.runtime.candidate_abi_v2=true for mapping-only and localization-only online smoke.
Keep max_iterations=1 for the first smoke.
Do not run joint mapping + localization until both single-path online tests are stable.
```
