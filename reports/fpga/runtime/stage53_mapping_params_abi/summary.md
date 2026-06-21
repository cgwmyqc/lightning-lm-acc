# Stage 53 Mapping Params ABI Summary

## Status

Implemented on Windows side. HLS export, Vivado BD validation, project
synthesis, implementation, and bitstream generation are complete.

## Root Cause

Stage 52 XDMA mapping replay failed after a healthy start/done transaction because
the HLS core still used localization observation semantics for mapping mode.
FPGA cannot read YAML directly, so mapping parameters must be passed through an
explicit ABI block.

## Changes

- Added `SlamAccelObservationParams` 128-byte ABI.
- Added PL DDR `PARAMS_BASE = 0x01002000`.
- Added controller registers `PARAMS_ADDR_LO/HI = 0x054/0x058`.
- Added `unified_obs_params_addr` direct controller port.
- Added HLS `params` direct `m_axi` input.
- Updated Orin XDMA runtime to write localization/mapping params.
- Updated mapping XDMA golden runner to pass `plane_icp_weight`,
  `extrinsic_R[9]`, and `extrinsic_T[3]`.
- Mapping HLS branch now uses CPU mapping semantics:
  - no localization residual threshold reject
  - mapping gate maps to `miss_count`
  - `res = -residual`
  - weighted `H/b` accumulation

## Verified

```text
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_gpp_csim.ps1
PASS
localization counts actual=6050/911/2 expected=6050/911/2
reject_probe counts=0/1/0
```

```text
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_csim.ps1
PASS
CSim done with 0 errors
localization counts actual=6050/911/2 expected=6050/911/2
reject_probe counts=0/1/0
```

```text
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_csynth.ps1
PASS
target clock: 10.00 ns
estimated clock: 9.307 ns
BRAM_18K=36 DSP48E=256 FF=27475 LUT=41633
```

```text
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_export_ip.ps1
PASS
component.xml: %TEMP%\lightning_hls_unified_obs\solution1\impl\ip\component.xml
generated RTL: single direct `params` port confirmed
```

Note: an intermediate attempt with `#pragma HLS DATA_PACK variable=params`
packed the 128-byte params struct into a 1024-bit object and crashed Vivado HLS
2018.3 during C Synthesis. The final implementation keeps the external 128-byte
ABI but exposes HLS `params` as a 16x64-bit word buffer and decodes it locally.

## Vivado Board-Level Verification

```text
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_bd_validate.ps1
PASS
BD_VALIDATE_PASS
```

```text
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_project_synth.ps1 -Jobs 18
PASS
PROJECT_SYNTH_PASS
```

```text
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_impl_bitstream.ps1 -Jobs 18
PASS
IMPLEMENTATION_BITSTREAM_PASS
IMPL_1_STATUS=write_bitstream Complete!
bitstream: fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit
```

Post-implementation timing:

```text
WNS=0.046 ns
TNS=0.000 ns
WHS=0.045 ns
THS=0.000 ns
All user specified timing constraints are met.
```

Post-implementation utilization:

```text
Slice LUTs:      65329 / 277400 = 23.55%
Slice Registers: 71135 / 554800 = 12.82%
Block RAM Tile: 53.5 / 755 = 7.09%
DSPs:           373 / 2020 = 18.47%
Bonded IOB:     74 / 362 = 20.44%
```

DRC summary:

```text
0 errors
0 critical warnings
748 warnings
456 advisories
```

## Next Orin Acceptance

After JTAG download of the new bitstream:

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\program_bitstream_jtag.ps1 -Bitstream .\fpga\vivado\.build\azmig_impl\azmig.runs\impl_1\azmig_wrapper.bit
```

Then run Orin acceptance:

```text
Localization XDMA golden PASS: 6050/911/2
Mapping XDMA golden PASS: 611/0/171
```

## Orin Acceptance, 2026-06-21

XDMA gate:

```text
PASS
0005:01:00.0 [10ee:7024]
Kernel driver in use: xdma
/dev/xdma0_user, /dev/xdma0_h2c_0, /dev/xdma0_c2h_0 present
enable=1
no new Failed to detect XDMA config BAR / CmpltTO / AER fatal
```

Build:

```text
colcon build --packages-select lightning
PASS
```

C++ runtime smoke:

```text
XDMA_CPP_SHIM_SMOKE_PASS
XDMA_CPP_REG_SMOKE_PASS
XDMA_CPP_DDR_SMOKE_PASS
```

Mapping CPU replay:

```text
MAPPING_CPU_REPLAY_PASS
counts actual=611/0/171 expected=611/0/171
max_abs=0.0337705
max_rel=2.21971e-05
worst_field=b(3)
```

Mapping XDMA replay:

```text
MAPPING_XDMA_REPLAY_FAIL
STATUS=0x204
ERROR=0x0
RUN_COUNT=0->1, retry 1->2
SCAN_COUNT_READBACK=782
counts actual=600/0/182 expected=611/0/171
max_abs=270562
max_rel=6.38949
worst_field=H(3,3)
```

## Interpretation

Stage 53 partially fixed the Stage 52 failure:

```text
Stage 52 actual: 585/68/129
Stage 53 actual: 600/0/182
Expected:        611/0/171
```

The residual reject semantics are now fixed for mapping mode because `reject_count`
is zero as expected. The remaining mismatch is 11 points: hardware classifies
them as `miss` while CPU mapping replay classifies them as `valid`. This points
away from XDMA, BAR, DDR, and output counter writeback, and toward HLS
mapping-mode lookup or mapping gate details.

Do not enable online `mapping.mode=fpga_obs` yet. Next Windows/HLS step should
debug the 11 valid-to-miss differences using the same
`fpga/golden/mapping/frame_000001` fixture, preferably by adding per-point or
selected-cell debug output for mapping mode before attempting online mapping.
