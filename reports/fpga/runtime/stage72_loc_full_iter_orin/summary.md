# Stage72A Orin Summary

Result: PASS

Stage72A generated the real localization full iterative golden and verified the
CPU parser/reference replay.

## Generated Golden

```text
fpga/golden/localization_iterative/frame_000001/
  loc_iter_scan.bin
  loc_iter_candidates.bin
  loc_iter_input.bin
  loc_iter_expected.bin
  loc_iter_meta.yaml
```

## Source

```text
fpga/golden/localization/frame_000001
```

## Key Results

```text
LOC_ITER_GOLDEN_BUILD_PASS
LOC_ITER_CPU_REPLAY_PASS
scan_count=6963
candidate_count=6963
candidate_valid=6961
candidate_miss=2
iterations_used=4
status=1
flags=0x1
counts=6124/837/2
score=2.25349
dx_norm=0.00349622
parser_roundtrip max_abs=0 max_rel=0
```

## Semantics

The expected output uses a fixed Candidate ABI V2 list generated from the
initial pose. Candidate lookup is not repeated after each pose update. This is
intentional and matches the Stage71 `slam_loc_iterative_core` HLS semantics.

## Boundary

Stage72A did not run XDMA board replay. The executable
`run_surfel_loc_iterative_xdma_golden` remains a Stage72D target after
Windows/HLS real-golden CSim/Cosim and BD/XDMA integration.

## Next Step

Stage72B on Windows/HLS should replay:

```text
fpga/golden/localization_iterative/frame_000001
```

against `fpga/hls/slam_loc_iterative_core/`.
