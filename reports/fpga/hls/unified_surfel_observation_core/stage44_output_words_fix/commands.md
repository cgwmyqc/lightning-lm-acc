# Stage 44 Output Words Fix

## Change

The HLS output port was changed from per-field direct ports for
`SlamNormalEquation` to a single `uint64_t* output_words` direct port.

The host-visible ABI is unchanged:

- `SlamNormalEquation` remains 320 bytes.
- `valid/reject/miss/flags` remain at byte offsets `216/220/224/228`.
- Host tools still parse the same normal-equation buffer.

The HLS writeback now writes 64-bit words:

- `0..20`: `H_upper[21]`
- `21..26`: `b[6]`
- `27`: low32 `valid_count`, high32 `reject_count`
- `28`: low32 `miss_count`, high32 `flags`
- `29..31`: residual summary
- `32..39`: zero reserved/padding

## Windows Commands

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_gpp_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_csynth.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_export_ip.ps1
```

## Results

- g++ CSim: PASS, `[obs_tb] PASS`.
- Vivado HLS CSim: PASS, `CSim done with 0 errors`.
- Vivado HLS C Synthesis: PASS.
- Vivado HLS IP export: PASS after the existing script's Vivado 2018.3
  `core_revision` workaround.
- Generated RTL/IP check: `output_words` exists; old
  `output_valid_count/output_reject_count/output_miss_count` ports are absent.

## Route Guardrail

This stage only fixes localization observation output writeback. It does not
enter mapping update, solve6x6, online SLAM integration, or PCIe performance
optimization.
