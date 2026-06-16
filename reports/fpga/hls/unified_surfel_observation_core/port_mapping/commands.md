# unified_surfel_observation_core generated RTL port mapping commands

Date: 2026-06-16

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_gpp_csim.ps1 `
  -GoldenDir .\fpga\golden\localization\frame_000001

powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_csim.ps1 `
  -GoldenDir .\fpga\golden\localization\frame_000001

powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_csynth.ps1

Select-String -Path "$env:TEMP\lightning_hls_unified_obs\solution1\syn\verilog\unified_surfel_observation_core.v" `
  -Pattern "^input\s+\[31:0\]|^input\s+ap_start|^output\s+ap_done|^output\s+ap_idle|^output\s+ap_ready|s_axi"
```

Generated RTL:

```text
%TEMP%\lightning_hls_unified_obs\solution1\syn\verilog\unified_surfel_observation_core.v
```

