# unified_surfel_observation_core HLS cosim commands

Date: 2026-06-16

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_cosim.ps1 `
  -GoldenDir .\fpga\golden\localization\frame_000001 `
  -ProjectDir "$env:TEMP\lightning_hls_unified_obs_cosim"
```

Generated project:

```text
%TEMP%\lightning_hls_unified_obs_cosim
```

Archived log:

```text
reports/fpga/hls/unified_surfel_observation_core/cosim/vivado_hls_cosim.log
```

