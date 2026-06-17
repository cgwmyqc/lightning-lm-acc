# XDMA Host Smoke Preparation Summary

## Scope

- Fixed the 1 GB PL DDR3 host/HLS buffer layout.
- Added Orin/Linux XDMA register and memory smoke tooling.
- Added tiny synthetic host image generation for later PL DDR3 preload.
- Re-ran the current AX7Z100 PCIe/MIG board skeleton BD validate and project synthesis.
- No implementation, bitstream, or on-board access was run in this stage.

## PL DDR3 Layout

| Buffer | Base | High Register |
| --- | ---: | ---: |
| `SCAN_POINTS_BASE` | `0x00000000` | `0x00000000` |
| `POSE_BASE` | `0x01000000` | `0x00000000` |
| `MAP_HEADER_BASE` | `0x01001000` | `0x00000000` |
| `ACTIVE_BLOCKS_BASE` | `0x02000000` | `0x00000000` |
| `OBS_CELLS_BASE` | `0x10000000` | `0x00000000` |
| `OUTPUT_BASE` | `0x30000000` | `0x00000000` |

## Results

- Address map validation: `ADDRESS_MAP_PASS`.
- Host tool help: PASS.
- Tiny synthetic host image generation: `HOST_SYNTHETIC_IMAGE_PASS`.
- Python compile check: PASS.
- Board skeleton BD validate: `BD_VALIDATE_PASS`.
- Board skeleton project synthesis: `PROJECT_SYNTH_PASS`.
- Synthesis status: `synth_design Complete!`, `0 errors`, `0 critical warnings`, `14 warnings`.
- Current synth/open timing snapshot remains negative and is recorded as an implementation-stage risk: WNS `-0.366 ns`, WHS `-0.643 ns`.

## Generated Artifacts

- Tiny synthetic host image manifest:
  `fpga/vivado/.build/host_synthetic_tiny/manifest.json`
- Address map report:
  `reports/fpga/host/xdma_smoke/address_map_validation.md`
- Tiny synthetic report:
  `reports/fpga/host/xdma_smoke/tiny_synthetic/tiny_synthetic_host_image.md`

## Next Step

Proceed to implementation/bitstream preparation only after accepting the current timing risk and confirming board-level XDC/PCIe reset/refclk assumptions. The first on-board gate should be XDMA device-node detection, `VERSION` read, AXI-Lite register write/read, and PL DDR3 4 KB pattern write/read.

## Orin PCIe Enumeration Troubleshooting

If JTAG programming reports `JTAG_PROGRAM_PASS` but Orin `lspci` does not show
the XDMA endpoint, first search by PCIe ID rather than display name:

```bash
lspci -nn | grep -Ei '10ee|7024|xilinx|memory|serial'
```

Then rescan without power-cycling AX7Z100:

```bash
sudo sh -c 'echo 1 > /sys/bus/pci/rescan'
lspci -nn | grep -Ei '10ee|7024|xilinx|memory|serial'
```

If still absent, reboot Orin while keeping AX7Z100 powered and configured:

```bash
sudo reboot
```

Collect:

```bash
lspci -nn
dmesg | grep -Ei 'pcie|pci|aer|link|xdma|xilinx|10ee'
```

Most likely causes to check, in order:

- Orin enumerated PCIe before FPGA was JTAG-configured.
- AX7Z100 lost temporary JTAG configuration after power cycling.
- Orin 100 MHz PCIe reference clock is not reaching AX7Z100.
- PERST#/PCIe reset to AX7Z100 `AB22` is not released.
- PCIe cable/adapter/lane orientation is wrong.
- Orin PCIe root port is disabled or configured for an incompatible mode.
- XDMA driver is missing; this affects `/dev/xdma0_*`, but `lspci -nn` should
  still show `10ee:7024`.
