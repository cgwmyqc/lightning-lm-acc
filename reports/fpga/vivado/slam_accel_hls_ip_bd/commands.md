# slam_accel_hls_ip_bd Commands

Date: 2026-06-17

## BD Validate

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_ip_bd\run_vivado_bd_validate.ps1
```

Expected marker:

```text
BD_VALIDATE_PASS
```

## Non-Project OOC Synthesis Attempt

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_ip_bd\run_vivado_ooc_synth.ps1
```

Result: blocked. Vivado HLS 2018.3 exported floating-point subcore XCI files
with `generate_synth_checkpoint` read-only/off, so the non-project OOC path
cannot cleanly resolve the HLS floating-point subcores.

## Project-Managed Synthesis

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_ip_bd\run_vivado_project_synth.ps1
```

Expected markers:

```text
SYNTH_1_STATUS=synth_design Complete!
PROJECT_SYNTH_PASS
```

## Generated Local Paths

```text
%TEMP%\lightning_slam_accel_hls_ip_bd
%TEMP%\lightning_slam_accel_hls_ip_bd_ooc
%TEMP%\lightning_slam_accel_hls_ip_bd_project_synth
%TEMP%\lightning_hls_unified_obs\solution1\impl\ip
```
