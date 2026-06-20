# AX7Z100 PCIe Lane Reversal Review

Date: 2026-06-19

## Hardware Clues

- Carrier schematic: `hardware/01_SCH/AX7Z035B_AX7Z100B_SCH.pdf`
  - Page 13: PCIe x8 slot exposes `PCIE_RX[0..3]`, `PCIE_TX[0..3]`,
    `PCIE_CLK_P/N`, and `PCIE_PERST`.
  - Page 2: those PCIe nets route through the core-board connectors.
- Core-board schematic: `hardware/01_SCH/AC7Z100B_SCH.pdf`
  - Page 8: Bank112 contains `MGTREFCLK0P/N_112 = N8/N7`.
  - Page 15: connector-side Bank112 lane nets line up with the carrier PCIe
    slot nets.

## Conclusion

- PCIe reference clock is still Bank112 `CLK0`, so `N8/N7` remains correct.
- PCIe PERST# is still `PCIE_PERST` to `AB22`; no push-button reset path was
  found in the current schematic review.
- The x4 lane order appears reversed between the slot and FPGA Bank112 lanes:
  slot lane 3..0 maps toward FPGA Bank112 lane 0..3.
- The previous generated XDMA IP had `enable_lane_reversal=false`, which is a
  strong candidate for link training failure and therefore no `lspci` endpoint.

## Implementation Decision

Enable lane reversal in XDMA:

```tcl
CONFIG.enable_lane_reversal {true}
```

Keep unchanged:

```text
PCIe width: Gen2 x4
XDMA quad: GTH_Quad_128
Refclk: N8/N7
PERST#: AB22
MIG sysclk: F9/E8
```

## Verification Gate

After regenerating the Vivado project, the generated XDMA XCI must contain:

```text
PARAM_VALUE.enable_lane_reversal = true
```

## Verification Result

Observed on 2026-06-19:

```text
BD_VALIDATE_PASS
PROJECT_SYNTH_PASS
IMPLEMENTATION_BITSTREAM_PASS
JTAG_PROGRAM_PASS
```

The generated BD and implementation XDMA XCI both contain:

```text
PARAM_VALUE.enable_lane_reversal = true
```

The downloaded bitstream is:

```text
fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit
BITSTREAM_SIZE_BYTES=7638099
```

JTAG status:

```text
FPGA_STATE=FPGA is configured
DONE PIN=1
```

Post-implementation timing is still not closed:

```text
WNS=-0.234 ns
TNS=-3.143 ns
Setup failing endpoints=193
```

This bitstream is suitable for PCIe enumeration experiments only.

If Orin still cannot enumerate `10ee:7024`, the next step is a minimal
XDMA-only link diagnostic bitstream plus direct measurement of 100 MHz refclk,
PERST# release, and lane/adapter orientation.
