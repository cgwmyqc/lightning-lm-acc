# Stage58 Orin Optimization Summary

Date: 2026-06-22

## Result

Stage58 Orin correctness gate passed for both localization and mapping golden replay.

Performance improved substantially, but localization full-frame replay did not reach the 5x target:

```text
Stage57 localization baseline hls_wait: 1.536 s
Stage58 localization elapsed mean:      0.350090 s
Speedup:                               4.39x
5x target threshold:                    <= 0.307 s
20x ideal threshold:                    <= 0.077 s
```

Conclusion:

```text
Correctness PASS.
Stage58 active-block cache optimization is effective.
Performance is still below the 5x gate, so continue to ABI v2 / candidate-index precompute before joint online testing.
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

The link remains Gen2 x1. This is still a performance risk, but Stage58 localization is dominated by kernel elapsed time, so x1 is not the only remaining issue.

No new `Failed to detect XDMA config BAR`, `CmpltTO`, or AER fatal marker was observed in the final journal tail.

## Smoke

```text
XDMA_CPP_SHIM_SMOKE_PASS
XDMA_CPP_REG_SMOKE_PASS
XDMA_CPP_DDR_SMOKE_PASS
```

## Localization Golden Replay

```text
scan_count=6963
active_blocks=3719
active_cells=952064
expected_counts=6050/911/2
```

Iterations:

```text
iter 1: STATUS=0x00000204 ERROR=0x00000000 RUN_COUNT=0->1 elapsed=0.350222 s counts=6050/911/2
iter 2: STATUS=0x00000204 ERROR=0x00000000 RUN_COUNT=1->2 elapsed=0.350393 s counts=6050/911/2
iter 3: STATUS=0x00000204 ERROR=0x00000000 RUN_COUNT=2->3 elapsed=0.349656 s counts=6050/911/2
```

Numeric comparison:

```text
XDMA_CPP_GOLDEN_NUMERIC_PASS
XDMA_CPP_GOLDEN_REPEAT_PASS ITERATIONS=3
max_abs=0.0078906
max_rel=4.41926e-05
worst_field=b(4)
```

Stage58 debug output words, last iteration:

```text
word32 = 0x0000000153543538
word33 = 0x00000df500001b33
word34 = 0x0000000200000d3c
word35 = 0x00002ccb0001584c
word36 = 0x0001726b00021706
word37 = 0x00010197000071e8
word38 = 0x00000e870000001b
word39 = 0x0000000000000000
```

Decoded according to the Stage58 counter contract:

```text
magic/version:             0x53544538 / 1
point_count:               6963
exact_hit:                 3573
neighbor_hit:              3388
lookup_miss:               2
neighbor_probe_count:      88140
block_lookup_count:        11467
block_search_steps:        136966
obs_cell_read_count:       94827
valid_candidate_count:     29160
invalid_candidate_count:   65943
max_probe_per_point:       27
active_block_cache_count:  3719
```

## Mapping Golden Replay

Three mapping full-frame golden replays passed:

```text
iter 1: MAPPING_XDMA_REPLAY_PASS, counts actual=611/0/171 expected=611/0/171, wall real=0.17 s
iter 2: MAPPING_XDMA_REPLAY_PASS, counts actual=611/0/171 expected=611/0/171, wall real=0.16 s
iter 3: MAPPING_XDMA_REPLAY_PASS, counts actual=611/0/171 expected=611/0/171, wall real=0.17 s
```

Mapping replay remains a correctness and rough wall-time gate. Precise mapping `hls_wait` should be measured with mapping-only online CSV profiling after the next optimization round.

## Notes

- The first localization replay attempt failed before HLS start because `/tmp/lightning_xdma_observation.lock` was a stale user-owned file that sudo could not write on this system. It was removed and recreated by root. This is host-state hygiene, not an FPGA/HLS failure.
- Because localization speedup is `4.39x`, Stage58 is an improvement but not enough for the agreed `5x` gate.
- Do not resume joint mapping + localization online testing yet. The next Windows/HLS step should be ABI v2: Orin precomputes candidate block/cell indices and FPGA performs residual/Jacobian/H/b accumulation.
