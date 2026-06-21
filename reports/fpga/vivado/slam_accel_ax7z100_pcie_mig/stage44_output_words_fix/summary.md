# Stage 44 Board Image Summary

## Change

The formal `slam_accel_ax7z100_pcie_mig` BD now connects:

```text
ctrl_0/unified_obs_output_addr -> unified_obs_0/output_words
```

It no longer connects per-field HLS output direct ports. The BAR shim,
`slam_accel_ctrl@0x1000`, PL DDR3 layout, MIG, XDMA, lane reversal, and host ABI
remain unchanged.

## Windows Commands

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\validate_board_profile.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_bd_validate.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_project_synth.ps1 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_impl_bitstream.ps1 -Jobs 18
```

## Results

- BD validate: PASS.
- Project synthesis: PASS.
- Implementation/bitstream: PASS.
- Bitstream:
  `fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit`
- Bitstream size: `7237579` bytes.
- Route status: 0 routing errors.
- Post-implementation timing: WNS `-0.132 ns`, WHS `0.045 ns`.
- DRC: 0 errors; warnings/advisories remain, including the known clock-route
  override and HLS DSP pipeline advisories.

## Board Test Status

This bitstream has been generated for Stage 44 Orin validation. It is a
function-validation image because WNS is still slightly negative. Do not treat
it as a final reliable performance bitstream.

Required Orin gates after JTAG programming:

```bash
sudo reboot
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --ddr-smoke
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_residual_probe/valid_only/manifest.json --ctrl-base 0x1000 --dump-normal-equation
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_residual_probe/reject_z_only/manifest.json --ctrl-base 0x1000 --dump-normal-equation
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_residual_probe/reject_x_only/manifest.json --ctrl-base 0x1000 --dump-normal-equation
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_residual_probe/miss_only/manifest.json --ctrl-base 0x1000 --dump-normal-equation
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_residual_probe/invalid_flag_only/manifest.json --ctrl-base 0x1000 --dump-normal-equation
```

If all residual probes pass, continue to Stage 41 multi-cell and Stage 40 n64
golden using the existing host commands.

Stage 44 JTAG result 2026-06-21:

```text
JTAG_PROGRAM_PASS
FPGA_STATE=FPGA is configured
```

The programmed image is `fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit`. Next action is Orin reboot and the Stage 44 residual probe gate.
