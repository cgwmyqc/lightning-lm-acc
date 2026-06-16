# Lightning-LM NDT vs SURFEL_CPU_SIM Short Bag Compare

- Bag: `/home/hit/Cheng/FPGA_ACC/mid360_20260313_outdoor_30deg_up_quan_03_0.db3`
- Map: `/home/hit/Cheng/FPGA_ACC/lightning-lm-acc/data/new_map/`
- Method: both runs start from bag beginning, are SIGKILL-truncated at 45s wall time, then PGO poses are matched by bag timestamp.

## Backend
- NDT run: mapping=['CPU'] localization=['NDT_OMP']
- CPU_SIM run: mapping=['CPU_SIM'] localization=['SURFEL_CPU_SIM']

## Frame / Failure Counts
- NDT PGO frames: 168; NDT confidence frames: 168; failures: 0
- CPU_SIM PGO frames: 168; surfel frames: 168; failures: 0; fallback lines: 0
- Matched frames for trajectory comparison: 168 over 110.097s bag time

## CPU_SIM Observation Quality
- valid count: mean=6137.4, median=6123.0, min=2613, max=7129
- mean_abs_residual: mean=0.052104, median=0.052046, p95=0.068069, max=0.069470
- score: mean=2.344405, median=2.320415, p95=2.646572, max=2.720240

## Trajectory Difference: CPU_SIM - NDT
- translation norm error (m): mean=0.078699, median=0.058966, p95=0.175041, max=0.184180
- dx (m): mean=-0.001902, median=-0.001925, min=-0.074082, max=0.041684
- dy (m): mean=-0.059664, median=-0.032852, min=-0.173387, max=0.003449
- dz (m): mean=0.013071, median=0.006296, min=-0.057534, max=0.063196

## Notes
- This is a short-run smoke/baseline comparison, not a full-bag acceptance test.
- Logs were filtered during capture to keep only backend, pose, success, residual, fallback, and error lines.
- No full single-frame FPGA golden was emitted in this step because the current golden builder needs a scan PCD input; bag-to-scan-PCD export should be added or run separately.
