# Stage 62 Board Build Summary

Date: 2026-07-06

Scope:

- Rebuilt the formal AX7Z100 PCIe/XDMA + PL DDR3/MIG `azmig` bitstream with the Stage62 HLS IP.
- No BAR shim, XDMA/MIG, register map, PL DDR layout, or BD topology changes.
- HLS `output_words` still uses the same direct address port, with depth increased from 40 to 56 words.

Commands:

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_bd_validate.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_project_synth.ps1 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_impl_bitstream.ps1 -Jobs 18
```

Results:

- Board profile static validation: PASS
- BD validate: PASS
- Project synthesis: PASS
- Implementation + bitstream: PASS
- `launch_runs` used `-jobs 18`

Bitstream:

```text
fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit
```

Post-implementation timing:

```text
WNS: 0.090 ns
WHS: 0.030 ns
Timing: all user specified timing constraints are met
```

Post-implementation utilization:

```text
Slice LUTs:      86589 / 277400 = 31.21%
Slice Registers: 99787 / 554800 = 17.99%
Block RAM Tile:  90.5 / 755 = 11.99%
DSPs:            365 / 2020 = 18.07%
```

DRC:

```text
0 errors
0 critical warnings
1190 total warnings/advisories
```

Main ordinary warnings/advisories:

- Floating-point DSP pipeline advisories/warnings from HLS double operators.
- Existing MIG/PS7-related board-level warnings.

Next Orin gate:

```bash
./install/lightning/lib/lightning/run_surfel_loc_xdma_golden \
  --golden_dir fpga/golden/localization/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120 \
  --abi_v2_candidates \
  --fpga_solve6x6

./install/lightning/lib/lightning/run_surfel_mapping_xdma_golden \
  --golden_dir fpga/golden/mapping/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120 \
  --abi_v2_candidates
```

Acceptance:

- Localization observation remains `6050/911/2`.
- `LOC_XDMA_SOLVE6X6_PASS`.
- FPGA `dx[6]` matches CPU reference solve within `abs <= 1e-7` or `rel <= 1e-5`.
- Mapping observation V2 remains `611/0/171`.
