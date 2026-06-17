# XDMA Host Smoke for AX7Z100

This directory contains host-side bring-up helpers for the AX7Z100 PCIe/XDMA +
PL DDR3/MIG board path. The tools target the Orin/Linux root-complex side.

This stage prepares host access only. It does not run implementation, generate a
bitstream, go on board, or validate full online SLAM.

## Device Defaults

- AXI-Lite BAR: `/dev/xdma0_user`
- Host to card: `/dev/xdma0_h2c_0`
- Card to host: `/dev/xdma0_c2h_0`

All paths can be overridden on the command line.

## PL DDR3 Layout

The HLS direct address contract is still 32-bit, so all high address registers
must stay zero.

| Region | Base |
| --- | ---: |
| scan points | `0x00000000` |
| pose | `0x01000000` |
| map header | `0x01001000` |
| active blocks | `0x02000000` |
| obs cells | `0x10000000` |
| output | `0x30000000` |

The whole layout stays inside the 1 GB PL DDR3 window `0x00000000..0x3fffffff`.

## Local Checks

```bash
python3 fpga/host/xdma_smoke/validate_address_map.py
python3 fpga/host/xdma_smoke/xdma_smoke.py --help
python3 fpga/host/xdma_smoke/make_tiny_synthetic_host_image.py --out-dir fpga/vivado/.build/host_synthetic_tiny --report-dir reports/fpga/host/xdma_smoke/tiny_synthetic
```

## On-Orin Smoke

After a bitstream is loaded and XDMA device nodes exist:

```bash
python3 xdma_smoke.py --reg-smoke --ddr-smoke
```

Optional start-only check:

```bash
python3 xdma_smoke.py --reg-smoke --start-zero
```

