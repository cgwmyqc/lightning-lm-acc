# XDMA Restore Chain Summary

## Current Status

- The X4 XDMA-only diagnostic bitstream has created `/dev/xdma0_*` on Orin.
- The full `azmig_wrapper.bit` still enumerates as `10ee:7024`, but the XDMA
  Linux driver fails probe with `Failed to detect XDMA config BAR` and
  `CmpltTO`.
- The current leading suspects are no longer pinout, PERST#, lane reversal, or
  driver installation. The suspects are the added full-design variables:
  `slam_accel_ctrl`, `128_bit + 125 MHz` XDMA AXI, MIG/interconnect, HLS, or
  timing.
- BD validate has passed for Stage A, Stage B, and Stage C on Windows/Vivado
  2018.3.
- The first Stage A BD attempt exposed a real wrapper metadata issue: the
  previous shared AXI-Lite wrapper fixed `FREQ_HZ=125000000`, which conflicts
  with Stage A's 250 MHz XDMA AXI clock. The restore chain now uses a local
  wrapper without fixed `FREQ_HZ`.
- Stage A synthesis passed.
- Stage A implementation and bitstream generation passed.
- Stage A bitstream:
  `fpga/vivado/.build/xdma_restore_stage_a_impl/xdma_restore_stage_a.runs/impl_1/xdma_restore_stage_a_wrapper.bit`
- Stage A bitstream size: 3,494,870 bytes.
- Stage A post-implementation timing is met: WNS 0.281 ns, WHS 0.045 ns.

## Added Windows Flow

- `fpga/vivado/xdma_restore_chain` now provides a staged restore flow.
- Stage A: `64_bit + 250 MHz`, `slam_accel_ctrl`, BRAM, no MIG/HLS.
- Stage B: `128_bit + 125 MHz`, `slam_accel_ctrl`, BRAM, no MIG/HLS.
- Stage C: `128_bit + 125 MHz`, `slam_accel_ctrl`, MIG-backed PL DDR3, no HLS.
- Each stage has BD validate, synthesis, implementation/bitstream, and JTAG
  programming scripts.

## Course Parameters Used

- PL DDR3/MIG clock: 200 MHz differential on `F9/E8`.
- DDR3 device: `MT41K256M16XX-125`.
- Physical DDR data width: 32-bit.
- MIG AXI data width: 256-bit.
- XDMA memory address offset: `0x00000000`.

## Next Gate

JTAG-program the Stage A bitstream first. Only move to Stage B after Orin
reports:

- `Kernel driver in use: xdma`
- `/dev/xdma0_user`
- `/dev/xdma0_h2c_0`
- `/dev/xdma0_c2h_0`
- no `Failed to detect XDMA config BAR`
- no new `CmpltTO`
