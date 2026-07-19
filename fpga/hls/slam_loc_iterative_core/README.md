# slam_loc_iterative_core

Standalone Vivado HLS core for Stage70/71 localization full iterative FPGA.

Scope:

- Separate HLS IP from `unified_surfel_observation_core` and `slam_ekf_update_core`.
- First ABI uses Candidate V2 semantics: `candidate_cells[i]` is the final surfel candidate for `scan_points[i]`.
- FPGA performs repeated localization registration inside one transaction:
  - observation / `H,b` accumulation
  - `solve6x6`
  - left-multiplied SE3 pose update
  - convergence check
- CPU remains responsible for quality gate, fallback policy, UI, and online integration.

Not in Stage71:

- Vivado block design integration.
- XDMA/MIG/BAR shim changes.
- `run_loc_online` integration.
- FPGA-side active-map lookup.

Windows commands:

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_loc_iterative_core\run_gpp_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_loc_iterative_core\run_vivado_hls_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_loc_iterative_core\run_vivado_hls_csynth.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_loc_iterative_core\run_vivado_hls_export_ip.ps1
```

Expected markers:

```text
LOC_ITER_GPP_CSIM_PASS
LOC_ITER_HLS_CSIM_PASS
LOC_ITER_CSYNTH_PASS
LOC_ITER_FINAL_POSE_MATCH
LOC_ITER_ITERATIONS_MATCH
LOC_ITER_COUNTS_MATCH
LOC_ITER_EXPORT_IP_PASS
```

Stage71 status:

- Windows synthetic g++ CSim: PASS.
- Vivado HLS 2018.3 CSim: PASS.
- Vivado HLS 2018.3 C Synthesis: PASS at 8ns target, estimated clock 7.519ns.
- Vivado HLS IP export: PASS after local Vivado 2018.3 `core_revision` overflow workaround.
- Real `fpga/golden/localization_iterative/frame_000001` is not present yet; Stage72 must generate it on Orin before board/runtime integration.
