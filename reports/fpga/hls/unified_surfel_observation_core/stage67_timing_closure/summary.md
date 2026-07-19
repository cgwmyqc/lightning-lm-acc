# Stage67 Observation HLS Timing Closure Summary

Date: 2026-07-18

## Result

- g++ CSim: PASS
- Vivado HLS CSim: PASS
- Vivado HLS C Synthesis: PASS
- Vivado HLS IP export: PASS

## Change

The observation HLS flow previously generated `unified_surfel_observation_core` with a fixed 10 ns clock while the board-level XDMA user clock is 8 ns. Stage67 changes the HLS project Tcl and PowerShell wrappers so observation HLS runs at `target_clock_ns=8` by default.

This targets the Stage66B failing path in `unified_obs_0`, where the post-route worst path was a double multiply DSP chain generated from the observation kernel.

## HLS C Synthesis

- Target clock: 8.00 ns
- Estimated clock: 7.436 ns
- BRAM_18K: 194
- DSP48E: 365
- FF: 85420
- LUT: 118553

Report:

```text
fpga/vivado/.build/hls_unified_obs_csynth/solution1/syn/report/unified_surfel_observation_core_csynth.rpt
```

## Notes

Vivado HLS 2018.3 still triggers the known IP packager `core_revision` overflow when the date-derived revision is too large. The export wrapper rewrote the local `run_ippack.tcl` revision to `1` and reran IP packaging successfully.

