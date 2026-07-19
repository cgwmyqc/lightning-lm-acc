# Stage72B Real Localization Iterative Golden Summary

Status: PASS on Windows HLS.

Testbench changes:

- Synthetic 2-point smoke remains enabled.
- Real golden replay is enabled when `loc_iter_meta.yaml` exists in the command-line golden directory.
- Binary files are read through the 64B `GoldenFileHeader` and validated by record type, record size, and record count before being passed to HLS.

Validation markers:

```text
LOC_ITER_SYNTHETIC_CSIM_PASS
LOC_ITER_REAL_GOLDEN_LOAD_PASS scan_count=6963 candidate_count=6963
LOC_ITER_REAL_GOLDEN_NUMERIC_PASS
LOC_ITER_GPP_CSIM_PASS
LOC_ITER_HLS_CSIM_PASS
LOC_ITER_CSYNTH_PASS
LOC_ITER_EXPORT_IP_PASS
```

Real golden result:

```text
status=1
flags=1
iterations=4
counts=6124/837/2
max_abs=2.91323e-13
max_rel=6.73397e-15
worst_field=residual_sum
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

Vivado HLS 2018.3 generated an overflowing timestamp-style `core_revision`.
The local export script rewrote the generated packager revision to `1` and
successfully produced `component.xml`.

Boundary:

- No Vivado BD integration was done in Stage72B.
- No `azmig_wrapper.bit` was regenerated.
- `SURFEL_FPGA_FULL_ITERATIVE` is still not an online runtime mode until Stage72D/E gates pass.

Next step:

Stage72C should connect `slam_loc_iterative_core` to `slam_accel_ctrl` and the
MIG-backed PL DDR fabric, while preserving existing observation/EKF paths.

