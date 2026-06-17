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
