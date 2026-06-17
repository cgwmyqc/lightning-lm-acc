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

## If `lspci` Does Not Show XDMA

JTAG programming only configures the FPGA fabric. It does not force the Orin
PCIe root complex to rediscover an endpoint that appeared after boot.

First avoid matching only the display name `Xilinx`; the PCIe ID may show only
as `10ee:7024`:

```bash
lspci -nn | grep -Ei '10ee|7024|xilinx|memory|serial'
```

If nothing is found, keep the AX7Z100 powered so the JTAG configuration is not
lost, then try a PCIe rescan:

```bash
sudo sh -c 'echo 1 > /sys/bus/pci/rescan'
lspci -nn | grep -Ei '10ee|7024|xilinx|memory|serial'
```

If rescan still does not find the device, reboot the Orin without powering off
the AX7Z100:

```bash
sudo reboot
```

After reboot:

```bash
lspci -nn | grep -Ei '10ee|7024|xilinx|memory|serial'
dmesg | grep -Ei 'pcie|pci|aer|link|xdma|xilinx|10ee'
```

Current suspect order if the endpoint is still absent:

1. The FPGA was JTAG-programmed after Orin PCIe enumeration, and Orin did not
   rescan the endpoint.
2. AX7Z100 lost JTAG configuration because board power was cycled.
3. PCIe reference clock from Orin to AX7Z100 is missing or unstable.
4. PCIe reset/PERST# did not release correctly to AX7Z100 `AB22`.
5. PCIe cable/adapter/lane orientation or board slot wiring is wrong.
6. Orin kernel/device-tree/root-port configuration does not enable this PCIe
   port or link width.
7. The XDMA endpoint came up but the driver/device-node layer is missing; in
   that case `lspci -nn` should still show `10ee:7024`, but `/dev/xdma0_*`
   nodes will be absent.
