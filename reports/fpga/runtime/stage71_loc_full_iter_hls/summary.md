# Stage71 Localization Full Iterative HLS Summary

Status: COMPLETE for Windows standalone HLS synthetic gate.

Implemented HLS IP:

```text
fpga/hls/slam_loc_iterative_core/
```

Scope:

- Standalone Vivado HLS IP, not integrated into board BD yet.
- Candidate ABI V2 only for the first version.
- No FPGA-side active map lookup in Stage71.
- No XDMA/MIG/BAR shim/register map change.
- No `azmig_wrapper.bit` generation in Stage71.

Validation results:

```text
LOC_ITER_GPP_CSIM_PASS
LOC_ITER_HLS_CSIM_PASS
LOC_ITER_CSYNTH_PASS
LOC_ITER_EXPORT_IP_PASS
```

Synthetic CSim markers:

```text
LOC_ITER_FINAL_POSE_MATCH tx=1 ty=-2 tz=0
LOC_ITER_ITERATIONS_MATCH iterations=3
LOC_ITER_COUNTS_MATCH counts=2/0/0
```

Vivado HLS 2018.3 C Synthesis summary:

```text
target part: xc7z100ffg900-2
target clock: 8.00 ns
estimated clock: 7.519 ns
BRAM_18K: 156 / 1510 (10%)
DSP48E: 574 / 2020 (28%)
FF: 85804 / 554800 (15%)
LUT: 94725 / 277400 (34%)
```

IP export note:

Vivado HLS 2018.3 generated an overflowing timestamp-style `core_revision`. The local export script now detects missing `component.xml`, rewrites the generated `run_ippack.tcl` revision to `1`, reruns Vivado IP packager, and then reports `LOC_ITER_EXPORT_IP_PASS`.

Limitations:

- Real `fpga/golden/localization_iterative/frame_000001` is not present yet.
- Current correctness gate is synthetic and validates the full iteration mechanics, not real localization trajectory equivalence.
- Board integration is deferred to Stage72 or a dedicated Stage72B/73 BD integration stage.

Next steps:

1. Orin side generates real localization iterative golden: input, expected final pose, iteration count, counts, residuals, and status.
2. Windows reruns Stage71 against the real golden.
3. If real golden passes, add controller/BD integration with a new localization full iterative kernel selector.

