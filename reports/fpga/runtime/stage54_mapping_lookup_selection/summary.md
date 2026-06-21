# Stage 54 Mapping Lookup Selection Summary

## Root Cause

Stage 53 proved that mapping params ABI and mapping residual semantics were active: `reject_count` changed from `68` to `0`. The remaining mismatch was:

```text
mapping expected: 611/0/171
mapping actual:   600/0/182
```

The likely remaining cause was lookup candidate selection. CPU mapping golden uses residual-first selection in `mapping_golden::BetterMappingCell()`, while the HLS lookup still used localization's centroid-distance-first policy for both modes. A closer cell can fail the mapping gate even when a lower-residual neighbor would be accepted.

## Code Change

- Localization lookup remains centroid-distance-first.
- Mapping lookup now compares candidates in this order:
  - smaller `abs(normal dot point_world + plane_d)` if the difference is greater than `1e-4`
  - smaller centroid squared distance if residuals are within `1e-4` and distance differs by more than `1e-4`
  - lower `quality` if both residual and distance are effectively tied
- HLS mapping residual, gate, `plane_icp_weight`, extrinsic ABI, BAR shim, DDR layout, and register map are unchanged.
- Added a CSim mapping lookup probe where residual-first selection must choose the farther low-residual cell and return `valid_count=1`.

## Verification

Windows HLS:

```text
g++ CSim: PASS
Vivado HLS CSim: PASS, CSim done with 0 errors
Vivado HLS C Synthesis: PASS
Vivado HLS IP export: PASS
```

Observed CSim markers:

```text
localization golden counts: 6050/911/2
reject_probe counts: 0/1/0
mapping_lookup_probe counts: 1/0/0
[obs_tb] PASS
```

Windows Vivado:

```text
BD validate: PASS
project synthesis: PASS
implementation/bitstream: PASS
```

Implementation summary:

```text
WNS=0.084 ns
TNS=0.000 ns
WHS=0.033 ns
THS=0.000 ns
All user specified timing constraints are met.
Bitgen Completed Successfully.
0 Critical Warnings and 0 Errors.
```

Utilization:

```text
LUT: 65640 / 277400 = 23.66%
FF: 71963 / 554800 = 12.97%
BRAM Tile: 53.5 / 755 = 7.09%
DSP: 381 / 2020 = 18.86%
```

Bitstream:

```text
fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit
size: 8386543 bytes
```

Note: the outer PowerShell invocation for implementation exceeded the automation timeout, but the Vivado run completed successfully and synchronized the bitstream and reports back into `fpga/vivado/.build/` and `reports/fpga/vivado/`.

## Orin Gate

After JTAG downloading the new bitstream, the required gate is:

```text
localization XDMA replay PASS, counts 6050/911/2
mapping XDMA replay PASS, counts 611/0/171
no Failed to detect XDMA config BAR / CmpltTO / AER fatal
```

## Orin Result

Stage 54 Orin validation passed on the current board image.

XDMA gate:

```text
0005:01:00.0 [10ee:7024]
Kernel driver in use: xdma
/dev/xdma0_user present
/dev/xdma0_h2c_0 present
/dev/xdma0_c2h_0 present
enable=1
config bar 1, user 0
no new Failed to detect XDMA config BAR / CmpltTO / AER fatal
```

C++ runtime smoke:

```text
XDMA_CPP_SHIM_SMOKE_PASS
XDMA_CPP_REG_SMOKE_PASS
XDMA_CPP_DDR_SMOKE_PASS
```

Localization XDMA replay remained aligned:

```text
scan_count=6963
expected_counts=6050/911/2
STATUS=0x00000204
ERROR=0x00000000
RUN_COUNT=0->1
SCAN_COUNT_READBACK=6963
COUNTS=6050/911/2
XDMA_CPP_GOLDEN_NUMERIC_PASS
```

Mapping CPU replay remained aligned:

```text
counts actual=611/0/171 expected=611/0/171
MAPPING_CPU_REPLAY_PASS
```

Mapping XDMA replay now passes with the Stage 54 lookup selection fix:

```text
STATUS=0x204
ERROR=0x0
RUN_COUNT=1->2
SCAN_COUNT_READBACK=782
counts actual=611/0/171 expected=611/0/171
values_ok=1
max_abs=0.268571
max_rel=1.99295e-05
worst_field=H(3,3)
MAPPING_XDMA_REPLAY_PASS
```

Stage 54 hardware replay is PASS. Online `mapping.mode=fpga_obs` is still not
enabled here because `LaserMapping::ObsModelFpgaObservation()` currently falls
back to CPU; the online mapping integration remains the next separate stage.
