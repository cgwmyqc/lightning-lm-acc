# Stage65B EKF Update BD Integration Summary

Date: 2026-07-06

Status: PASS with timing risk.

Completed:

- Exported `slam_ekf_update_core` HLS IP.
- Added `KERNEL_SEL=5` and EKF input/output address registers to
  `slam_accel_ctrl`.
- Integrated `slam_ekf_update_core` into the AX7Z100 PCIe/MIG BD.
- Connected EKF `m_axi_gmem0..1` to the MIG-backed PL DDR fabric.
- Generated a new `azmig_wrapper.bit`.

Interface:

```text
KERNEL_SEL=4: unified observation
KERNEL_SEL=5: mapping EKF update
EKF_UPDATE_INPUT_BASE  = 0x30010000
EKF_UPDATE_OUTPUT_BASE = 0x30020000
EKF_INPUT_ADDR_LO/HI   = 0x05c / 0x060
EKF_OUTPUT_ADDR_LO/HI  = 0x064 / 0x068
```

Validation:

```text
EKF g++ CSim: PASS
EKF HLS IP export: PASS
slam_accel_ctrl OOC synthesis: PASS
BD validate: PASS
project synthesis: PASS
implementation/bitstream: PASS
```

Bitstream:

```text
fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit
size: 12309627 bytes
```

Post-implementation utilization:

```text
Slice LUTs:      147499 / 277400 = 53.17%
Slice Registers: 156432 / 554800 = 28.20%
Block RAM Tile:  127.5 / 755     = 16.89%
DSPs:            792 / 2020      = 39.21%
```

Timing:

```text
Timing constraints are not met.
WNS = -0.579 ns
TNS = -2451.445 ns
WHS = 0.029 ns
```

DRC / route:

```text
Route errors: 0
DRC errors: 0
DRC warnings/advisories remain, mainly HLS floating-point DSP pipelining and
existing board/IP warnings.
```

Risk:

- The Stage65B bitstream is usable for functional bring-up only.
- It is not timing closed. Stage65C Orin golden replay should remain a smoke
  gate, and online `FPGA_FULL` must stay disabled until correctness and timing
  risk are addressed.

Next:

- Stage65C: Orin EKF update golden transaction using Stage64
  `mapping_update/frame_000001`.
- Write `update_input.bin` to `EKF_UPDATE_INPUT_BASE`, trigger
  `KERNEL_SEL=5`, read `EKF_UPDATE_OUTPUT_BASE`, and compare against
  `update_expected.bin`.
