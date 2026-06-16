# unified_surfel_observation_core localization frame_000001

Date: 2026-06-16
Host: Windows, Vivado HLS 2018.3

## g++ CSim

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_gpp_csim.ps1 `
  -GoldenDir .\fpga\golden\localization\frame_000001
```

## Vivado HLS CSim

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_csim.ps1 `
  -GoldenDir .\fpga\golden\localization\frame_000001
```

Generated HLS project:

```text
fpga/hls/unified_surfel_observation_core/build/vivado_hls_unified_obs/
```

The generated project is ignored by git.
