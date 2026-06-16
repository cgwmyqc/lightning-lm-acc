# unified_surfel_observation_core Interface Convergence Commands

Date: 2026-06-16

Commands:

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_gpp_csim.ps1 `
  -GoldenDir .\fpga\golden\localization\frame_000001

powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_csim.ps1 `
  -GoldenDir .\fpga\golden\localization\frame_000001

powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_csynth.ps1
```

Temporary HLS project:

```text
%TEMP%\lightning_hls_unified_obs
```

Interface checks:

```powershell
Select-String -Path "$env:TEMP\lightning_hls_unified_obs\solution1\syn\report\unified_surfel_observation_core_csynth.rpt" `
  -Pattern "s_axi"
```

Expected interface result:

- No `s_axi_control` or other HLS AXI-Lite slave.
- `ap_ctrl_hs` control ports: `ap_start`, `ap_done`, `ap_idle`, `ap_ready`.
- `m_axi` bundles: `gmem0` through `gmem4`.
- Direct scalar base-address ports for packed inputs: `scan_points`, `pose`, `map_header`, `active_blocks`, `obs_cells`.
- Direct scalar field-address ports for unpacked output: `output_h_upper`, `output_b`, `output_valid_count`, `output_reject_count`, `output_miss_count`, `output_flags`, `output_residual_sum`, `output_residual_abs_sum`, `output_residual_max_abs`, `output_reserved`.
