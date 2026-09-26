# Stage A2 Lane-Normal Diagnostic

Date: 2026-09-26
Purpose: isolate the PCIe lane-reversal hypothesis from MIG and HLS logic.

## Configuration

- Gen2 x4 capability
- `enable_lane_reversal=false`
- 64-bit, 250 MHz XDMA AXI
- BAR identity shim and control registers
- BRAM data target
- no MIG and no HLS cores

The generated BD property report confirms:

```text
CONFIG.enable_lane_reversal string false false
```

## Implementation

- BD validation: PASS
- Synthesis: PASS
- Implementation and bitstream: PASS
- WNS: 0.301 ns
- WHS: 0.011 ns
- Failed/unrouted nets: 0
- Bitstream size: 3,315,031 bytes
- SHA-256:
  `1b6d9a2d31829f09e449299cd6ab80a175d30fb0439cf8a4f43176aebea778af`

## Board Result

- JTAG programming and FPGA configuration: PASS
- Existing-BDF remove/rescan: endpoint missing
- Orin cold boot: endpoint missing

The default Stage A2 image with lane reversal enabled enumerates and binds the
XDMA driver at Gen2 x1. Therefore lane reversal must remain enabled. The x4
failure is now assigned to the lanes 1-3 physical/platform path rather than the
lane-reversal property.
