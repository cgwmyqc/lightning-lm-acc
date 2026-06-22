# Stage 58 HLS Performance Baseline And First Optimization

## Scope

Stage 58 optimizes unified observation lookup performance only. It does not
change math semantics, BAR shim, XDMA/MIG topology, register map, PL DDR layout,
or the host-visible normal-equation ABI in `output_words[0..31]`.

## Implemented Change

- Copy `active_blocks[0..num_blocks)` into local BRAM once per kernel launch.
- Use the BRAM active-block cache for all block binary searches.
- Reuse per-point block-index lookup results across the 27 center/neighbor probes.
- Keep `obs_cells` in PL DDR.
- Use `output_words[32..39]` for Stage 58 debug counters.

## Commands

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_gpp_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_stage58_perf_baseline.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_csynth.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_export_ip.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_bd_validate.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_project_synth.ps1 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_impl_bitstream.ps1 -Jobs 18
```

## Results

```text
g++ CSim:                 PASS
synthetic sweep:          PASS
Vivado HLS CSim:          PASS
Vivado HLS C Synthesis:   PASS
Vivado HLS IP export:     PASS
Vivado BD validate:       PASS
Vivado project synthesis: PASS
Vivado implementation:    PASS
Bitstream generation:     PASS
```

Correctness:

```text
localization frame_000001: 6050/911/2 PASS
mapping frame_000001:      611/0/171 PASS
reject_probe:              PASS
mapping_lookup_probe:      PASS
```

## Debug Counters

```text
localization:
  point_count=6963
  exact_hit=3573
  neighbor_hit=3388
  lookup_miss=2
  neighbor_probe=88140
  block_lookup=11467
  block_search_steps=136966
  obs_cell_read=94827
  valid_candidate=29160
  invalid_candidate=65943
  max_probe_per_point=27
  active_block_cache_count=3719

mapping:
  point_count=782
  exact_hit=384
  neighbor_hit=269
  lookup_miss=129
  neighbor_probe=10348
  block_lookup=1338
  block_search_steps=8339
  obs_cell_read=10735
  valid_candidate=1100
  invalid_candidate=10030
  max_probe_per_point=27
  active_block_cache_count=73
```

## HLS C Synthesis

```text
target clock:    10.00 ns
estimated clock: 9.307 ns
BRAM_18K:        184 / 1510 = 12%
DSP48E:          348 / 2020 = 17%
FF:              64051 / 554800 = 11%
LUT:             102449 / 277400 = 36%
```

## Implementation

```text
bitstream:
  fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit
post-route WNS: 0.090 ns
post-route WHS: 0.028 ns
timing errors:  0
DRC errors:     0
critical warnings: 0
Slice LUTs:     75597 / 277400 = 27.25%
Slice Registers:88385 / 554800 = 15.93%
Block RAM Tile: 85.5 / 755 = 11.32%
DSPs:           348 / 2020 = 17.23%
Bonded IOB:     74 / 362 = 20.44%
```

Non-fatal warnings to keep tracking:

- RAMB asynchronous-control warnings in generated HLS/XDMA FIFOs.
- MIG clock placement warning using the existing `CLOCK_DEDICATED_ROUTE` exception.
- HLS floating-point DSP input-pipeline advisories.

## Next Orin Gate

Program the new bitstream, then run:

```bash
./install/lightning/lib/lightning/run_surfel_loc_xdma_golden \
  --golden_dir fpga/golden/localization/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120

./install/lightning/lib/lightning/run_surfel_mapping_xdma_golden \
  --golden_dir fpga/golden/mapping/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120
```

After correctness remains PASS, compare Orin `hls_wait` with Stage 57/54. If
localization full-frame `hls_wait` does not improve by at least 5x, proceed to
ABI v2 candidate precompute.
