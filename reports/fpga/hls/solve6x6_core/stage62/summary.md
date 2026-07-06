# Stage 62 Solve6x6 HLS Summary

Date: 2026-07-06

Scope:

- Added optional localization `SOLVE6X6` flag to the existing unified observation HLS kernel.
- Preserved the first 320 bytes of `SlamNormalEquation`.
- Appended 128 bytes of `SlamSolve6x6Result` at `OUTPUT_BASE + 0x140`.
- Kept BAR shim, XDMA/MIG, AXI-Lite register map, PL DDR layout, and Candidate ABI V2 unchanged.

ABI:

- `SLAM_ACCEL_OBS_FLAG_SOLVE6X6 = 1 << 1`
- `SlamSolve6x6Result` size: 128 bytes
- Output word range:
  - words `0..39`: existing normal equation/debug counters
  - words `40..55`: solve6x6 result

Windows HLS commands:

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_gpp_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_csynth.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_export_ip.ps1
```

Results:

- g++ CSim: PASS
- Vivado HLS CSim: PASS, `CSim done with 0 errors`
- Localization V1: PASS, counts `6050/911/2`
- Localization V2: PASS, counts `6050/911/2`
- Localization V2 solve6x6: PASS, solve status `1`, dx matched the testbench LDLT reference
- Mapping V1: PASS, counts `611/0/171`
- Mapping V2: PASS, counts `611/0/171`
- C Synthesis: PASS
- IP export: PASS after the existing Vivado 2018.3 `core_revision` overflow workaround reran IP packager with revision `1`

HLS C Synthesis summary:

```text
target clock:    10.00 ns
estimated clock: 9.307 ns
BRAM_18K:        194 / 1510 = 12%
DSP48E:          365 / 2020 = 18%
FF:              78040 / 554800 = 14%
LUT:             118656 / 277400 = 42%
```

Notes:

- The solve6x6 path adds double divide/sqrt resources and increases LUT/DSP use versus Stage61.
- Stage62 only adds localization solve output. Mapping ESKF update is deliberately kept for Stage64/65.
