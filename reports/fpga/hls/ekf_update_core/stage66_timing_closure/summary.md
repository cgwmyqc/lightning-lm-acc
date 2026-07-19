# Stage66B EKF Update HLS Timing Summary

Status: HLS 8ns gate PASS.

Results:

- g++ CSim: PASS, `MAPPING_EKF_UPDATE_HLS_CSIM_PASS`.
- Vivado HLS CSim: PASS, `CSim done with 0 errors`.
- Vivado HLS C Synthesis: PASS.
- Vivado HLS IP export: PASS after the existing Vivado 2018.3 `core_revision`
  overflow workaround rewrote `run_ippack.tcl` revision to `1`.

HLS C Synthesis summary:

```text
Clock target: 8.00 ns
Estimated clock: 7.673 ns
Latency: 22608..246682 cycles
BRAM_18K: 94 / 1510 (6%)
DSP48E: 407 / 2020 (20%)
FF: 75279 / 554800 (13%)
LUT: 79138 / 277400 (28%)
```

Conclusion:

- The standalone EKF HLS core itself meets the 8ns HLS estimate.
- The remaining post-route timing issue is currently in `unified_obs_0`, not
  `ekf_update_0`.
