# Stage 61 ABI V2 Candidate Observation

## Scope

Stage 61 adds an ABI V2 observation path where Orin precomputes the final
candidate surfel for each scan point. The FPGA keeps the Stage 58 V1 lookup path
as fallback, but when `SLAM_ACCEL_OBS_FLAG_CANDIDATE_ABI_V2` is set it no longer
does active-block lookup or random full-map `obs_cells` reads.

Unchanged:

- BAR shim and `slam_accel_ctrl@0x1000`
- XDMA/MIG/AXI-Lite register map
- PL DDR base layout
- normal equation output ABI in `output_words[0..31]`
- localization and mapping math semantics

## ABI V2 Behavior

- `SlamAccelObservationParams.flags` bit `SLAM_ACCEL_OBS_FLAG_CANDIDATE_ABI_V2`
  selects the V2 path.
- `OBS_CELLS_BASE` is reused as a per-point candidate-cell buffer.
- V2 `obs_cells[i]` is the final `ObsCellFloat64` candidate for scan point `i`.
- Orin writes `flags=0` for lookup miss candidates.
- FPGA sequentially reads `scan_points[i]` and `candidate_cells[i]`, then runs
  residual, Jacobian, and H/b accumulation.
- `output_words[32..39]` carry Stage 61 debug counters with magic `0x53543631`
  (`ST61`).

## Results

```text
g++ CSim:                 PASS
Vivado HLS CSim:          PASS
Vivado HLS C Synthesis:   PASS
Vivado HLS IP export:     PASS
Vivado BD validate:       PASS
Vivado project synthesis: PASS
Vivado implementation:    PASS
Bitstream generation:     PASS
Windows JTAG program:     PASS
```

Correctness:

```text
V1 localization frame_000001: 6050/911/2 PASS
V1 mapping frame_000001:      611/0/171 PASS
V2 localization frame_000001: 6050/911/2 PASS
V2 mapping frame_000001:      611/0/171 PASS
reject_probe:                 PASS
mapping_lookup_probe:         PASS
```

V2 debug counters from CSim:

```text
localization V2:
  debug_magic=0x53543631
  point_count=6963
  exact_hit=6961
  lookup_miss=2
  neighbor_probe=0
  block_lookup=0
  block_search_steps=0
  obs_cell_read=0
  valid_candidate=6961
  invalid_candidate=2
  debug_flags=0x1

mapping V2:
  point_count=782
  exact_hit=653
  lookup_miss=129
  neighbor_probe=0
  block_lookup=0
  block_search_steps=0
  obs_cell_read=0
  valid_candidate=653
  invalid_candidate=129
  debug_flags=0x1
```

## HLS C Synthesis

```text
target clock:    10.00 ns
estimated clock: 9.307 ns
BRAM_18K:        184 / 1510 = 12%
DSP48E:          348 / 2020 = 17%
FF:              66007 / 554800 = 11%
LUT:             105315 / 277400 = 37%
```

## Implementation

```text
bitstream:
  fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit
post-route WNS: 0.071 ns
post-route WHS: 0.009 ns
timing errors:  0
DRC errors:     0
critical warnings: 0
Slice LUTs:     76854 / 277400 = 27.71%
Slice Registers:89411 / 554800 = 16.12%
Block RAM Tile: 85.5 / 755 = 11.32%
DSPs:           348 / 2020 = 17.23%
```

DRC warning/advisory classes remain non-fatal and include DSP pipeline warnings,
RAMB async-control warnings, one clock placer warning, one clock output buffering
warning, one no-routable-load warning, and one PL-only PS7-required warning.

JTAG:

```text
JTAG_PROGRAM_PASS
FPGA_STATE=FPGA is configured
DONE PIN: 1
```

## Next Orin Gate

Program the new bitstream, reboot Orin while the FPGA remains configured, then
run V2 golden replay:

```bash
./install/lightning/lib/lightning/run_surfel_loc_xdma_golden \
  --golden_dir fpga/golden/localization/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120 \
  --abi_v2_candidates

./install/lightning/lib/lightning/run_surfel_mapping_xdma_golden \
  --golden_dir fpga/golden/mapping/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120 \
  --abi_v2_candidates
```

Acceptance:

- localization V2 PASS, counts `6050/911/2`
- mapping V2 PASS, counts `611/0/171`
- Stage 61 debug magic `0x53543631`
- V2 counters show `block_lookup=0` and `obs_cell_read=0`
- localization full-frame `hls_wait <= 0.307s`
- no XDMA config BAR failure, `CmpltTO`, or AER fatal
