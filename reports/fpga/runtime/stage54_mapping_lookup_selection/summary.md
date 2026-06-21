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

Keep online `mapping.mode=fpga_obs` disabled until mapping XDMA replay passes.
