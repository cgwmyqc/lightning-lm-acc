# Stage72C Localization Iterative BD Summary

Result: PASS on Windows hardware integration.

Stage72C connected the standalone `slam_loc_iterative_core` HLS IP to
`slam_accel_ctrl` and the formal AX7Z100 PCIe/XDMA + MIG-backed PL DDR board
design.

## Interface

```text
KERNEL_SEL=4: unified observation
KERNEL_SEL=5: mapping EKF update
KERNEL_SEL=6: localization full iterative core

SCAN_ADDR: reused for loc_iter_scan.bin
OBS_CELLS_ADDR: reused for loc_iter_candidates.bin
LOC_ITER_INPUT_ADDR_LO/HI: 0x06c / 0x070
LOC_ITER_OUTPUT_ADDR_LO/HI: 0x074 / 0x078

LOC_ITER_INPUT_BASE: 0x30030000
LOC_ITER_OUTPUT_BASE: 0x30040000
```

## Results

```text
LOC_ITER_GPP_CSIM_PASS
LOC_ITER_HLS_CSIM_PASS
LOC_ITER_CSYNTH_PASS
LOC_ITER_EXPORT_IP_PASS
slam_accel_ctrl OOC synthesis PASS
BD_VALIDATE_PASS
PROJECT_SYNTH_PASS
IMPLEMENTATION_BITSTREAM_PASS
```

## Bitstream

```text
fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit
BITSTREAM_SIZE_BYTES=12920775
```

## Timing

```text
All user specified timing constraints are met.
WNS=0.086 ns
TNS=0.000 ns
WHS=0.016 ns
THS=0.000 ns
route_errors=0
DRC errors=0
critical warnings=0
```

## Utilization

```text
Slice LUTs:      216599 / 277400 = 78.08%
Slice Registers: 246370 / 554800 = 44.41%
BRAM Tile:          146 /    755 = 19.34%
DSP:               1386 /   2020 = 68.61%
Bonded IOB:          74 /    362 = 20.44%
```

## Next Gate

Stage72D is Orin XDMA golden replay. It must download the new bitstream, run
shim/register/DDR smoke, trigger `KERNEL_SEL=6`, and compare the HLS output
against `fpga/golden/localization_iterative/frame_000001/loc_iter_expected.bin`.

Expected markers:

```text
LOC_ITER_XDMA_START_PASS
LOC_ITER_XDMA_DONE_PASS
LOC_ITER_XDMA_NUMERIC_PASS
LOC_ITER_XDMA_PASS
```

Expected numeric result:

```text
iterations=4
counts=6124/837/2
status=1
flags=1
```
