# Stage72A/B Localization Full Iterative Summary

Result: PASS through Windows standalone HLS.

Stage72A generated the real localization full iterative golden and verified the
CPU parser/reference replay. Stage72B replayed the same golden through
`slam_loc_iterative_core` g++ CSim and Vivado HLS CSim.

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

## Stage72A Key Results

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

## Stage72B Windows HLS Results

```text
LOC_ITER_SYNTHETIC_CSIM_PASS
LOC_ITER_REAL_GOLDEN_LOAD_PASS scan_count=6963 candidate_count=6963
LOC_ITER_REAL_GOLDEN_NUMERIC_PASS
LOC_ITER_GPP_CSIM_PASS
LOC_ITER_HLS_CSIM_PASS
LOC_ITER_CSYNTH_PASS
LOC_ITER_EXPORT_IP_PASS
```

Real golden numeric summary:

```text
status=1
flags=1
iterations=4
counts=6124/837/2
max_abs=2.91323e-13
max_rel=6.73397e-15
worst_field=residual_sum
```

## HLS Summary

```text
target clock: 8.00 ns
estimated clock: 7.519 ns
BRAM_18K: 156
DSP48E: 574
FF: 85804
LUT: 94725
```

## Semantics

The expected output uses a fixed Candidate ABI V2 list generated from the
initial pose. Candidate lookup is not repeated after each pose update. This is
intentional and matches the Stage71/72B `slam_loc_iterative_core` HLS semantics.

## Boundary

Stage72B did not run XDMA board replay. The executable
`run_surfel_loc_iterative_xdma_golden` remains a Stage72D target after
BD/XDMA integration.

## Stage72C Windows BD Integration

Result: PASS.

Stage72C integrated `slam_loc_iterative_core` into the formal AX7Z100
`azmig_wrapper.bit` design.

```text
KERNEL_SEL=6
LOC_ITER_INPUT_BASE=0x30030000
LOC_ITER_OUTPUT_BASE=0x30040000
LOC_ITER_INPUT_ADDR_LO/HI=0x06c/0x070
LOC_ITER_OUTPUT_ADDR_LO/HI=0x074/0x078
```

Windows result:

```text
LOC_ITER_GPP_CSIM_PASS
LOC_ITER_HLS_CSIM_PASS
LOC_ITER_CSYNTH_PASS
LOC_ITER_EXPORT_IP_PASS
slam_accel_ctrl OOC synthesis PASS
BD_VALIDATE_PASS
PROJECT_SYNTH_PASS
IMPLEMENTATION_BITSTREAM_PASS
```

Bitstream and implementation summary:

```text
bitstream=fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit
size=12920775 bytes
WNS=0.086 ns
WHS=0.016 ns
all user timing constraints met
DRC errors=0
critical warnings=0
DSP utilization=68.61%
LUT utilization=78.08%
```

## Next Step: Stage72D

Stage72D should JTAG download the new bitstream and run the Orin XDMA golden
transaction for `KERNEL_SEL=6`. It should not enable online ROS localization
until the offline golden replay outputs `LOC_ITER_XDMA_PASS`.
