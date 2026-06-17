# AX7Z100 Board Profile

## Sources

- AX7Z100 docx in repo root: board/chip, PCIe, PL DDR3, clock, and pin tables.
- ALINX `12_ddr3_pl/mig_a.prj`: PL DDR3 target and pinout.
- ALINX `33_PCIe_test`: PCIe/XDMA x4 structure and AXI MIG example.
- Previous `ch06_xdma_test`: XDMA AXI-Lite host-access pattern only.

## Fixed Facts

- FPGA: `XC7Z100-2FFG900`
- Vivado part: `xc7z100ffg900-2`
- PL DDR3: 2 x 512 MB on PL side, 32-bit MIG interface in the ALINX example.
- PL DDR3 device: `DDR3_SDRAM/Components/MT41K256M16XX-125`
- MIG input clock: differential 200 MHz, `SYS_CLK_P/N = F9/E8`
- MIG DDR timing: `TimePeriod=1250`, `InputClkFreq=200`
- PCIe reference clock: 100 MHz, `PCIE_CLK_P/N = N8/N7`
- PCIe reset: `PCIE_PERST = AB22`, active low
- First PCIe width: x4
- XDMA: Gen2 `5.0_GT/s`, `axi_data_width=128_bit`, `axisten_freq=125`

## Clock Correction

The Orin-provided 100 MHz is still used in this design, but only as the PCIe
endpoint reference clock into XDMA. It is not the PL DDR3/MIG system clock. The
MIG system clock comes from the AX7Z100 board 200 MHz differential source on
`F9/E8`.

## Skeleton Memory Map

The first board-level skeleton gives all HLS `m_axi_gmem0..4` masters and XDMA
`M_AXI` access to the same PL DDR3 address space:

- DDR base: `0x0000_0000`
- DDR range: `0x4000_0000` (1 GB)
- `slam_accel_ctrl` AXI-Lite BAR offset: `0x0000_0000`, range `0x0001_0000`

The controller still enforces the current 32-bit HLS address contract:
all host-written `*_ADDR_HI` registers must be zero.

