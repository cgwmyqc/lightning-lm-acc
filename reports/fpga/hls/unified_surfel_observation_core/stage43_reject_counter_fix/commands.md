# Stage 43 Reject Counter Fix

## Change

- HLS core no longer increments `output->valid_count/reject_count/miss_count` inside the point loop.
- Counts and residual summaries are accumulated in local variables and written to `SlamNormalEquation` once after the loop.
- `obs_tb.cpp` now includes a single-point residual reject probe. Expected counts are `0/1/0`, and `H/b/residual` must remain zero.

## Windows validation

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_gpp_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_csynth.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_export_ip.ps1
```

## Script note

- `run_vivado_hls_csynth.ps1` now uses `fpga/vivado/.build/hls_unified_obs_csynth` and the existing Vivado short-path helper.
- Reason: the prior `%TEMP%` default resolved to a malformed Windows path in Vivado HLS 2018.3 and prevented C synthesis project creation.

## Windows results

- g++ CSim: PASS. Golden counts `6050/911/2`; reject probe counts `0/1/0`.
- Vivado HLS CSim: PASS, `CSim done with 0 errors`; reject probe counts `0/1/0`.
- Vivado HLS C Synthesis: PASS. Target clock `10.00 ns`, estimated clock `9.307 ns`; utilization estimate `BRAM_18K=36`, `DSP48E=256`, `FF=26493`, `LUT=41601`.
- Vivado HLS IP export: PASS. Vivado HLS 2018.3 generated an overflowing `core_revision`; the script rewrote the local `run_ippack.tcl` revision to `1` and packed the IP successfully.
- HLS IP path: `fpga/vivado/.build/hls_unified_obs/solution1/impl/ip/component.xml`.

## Board build results

- Board profile validation: PASS.
- BD validate: PASS; formal `azmig` uses the new HLS IP and keeps HLS AXI masters inside the MIG-backed memory fabric.
- Project synthesis: PASS with `-Jobs 18`.
- Implementation/bitstream: PASS with `-Jobs 18`.
- Post-implementation timing: PASS. `WNS=0.145 ns`, `TNS=0.000 ns`, `WHS=0.025 ns`, `THS=0.000 ns`; all user timing constraints are met.
- DRC summary from bitstream run: `0 Errors`, `0 Critical Warnings`, warnings/advisories are primarily HLS DSP pipelining and known board/IP advisories.
- Bitstream path: `fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit`.
- Windows JTAG download: PASS, marker `JTAG_PROGRAM_PASS`; FPGA state reports configured.

## JTAG command

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\program_bitstream_jtag.ps1 -Bitstream .\fpga\vivado\.build\azmig_impl\azmig.runs\impl_1\azmig_wrapper.bit
```

## Board rebuild after HLS export

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\validate_board_profile.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_bd_validate.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_project_synth.ps1 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_impl_bitstream.ps1 -Jobs 18
```

## Orin gate after JTAG

- Stage 42 residual probes: all must print `HLS_MANIFEST_NUMERIC_PASS`.
- Stage 41 multi-cell: expected counts `1/1/1`.
- Stage 40 n64 golden: expected counts `14/33/17`.
