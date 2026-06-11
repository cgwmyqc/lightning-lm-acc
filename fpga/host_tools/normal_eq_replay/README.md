# Normal Equation Golden Replay

This standalone host tool replays golden normal-equation input through the XDMA-connected FPGA accelerator.

It does not depend on ROS and does not run SLAM. Use it before enabling `fpga.mode: fpga` in `run_slam_online`.

## Build

```bash
cmake -S fpga/host_tools/normal_eq_replay -B build/normal_eq_replay
cmake --build build/normal_eq_replay -j
```

## Device Check

```bash
lspci | grep -Ei "xilinx|10ee|fpga"
lspci -vv -s <bus-id> | grep Control
ls -l /dev/xdma0*
sudo chmod 666 /dev/xdma0_h2c_0 /dev/xdma0_c2h_0 /dev/xdma0_user
```

If `lspci -vv` shows `BusMaster-`, enable PCIe bus mastering before replay:

```bash
sudo setpci -s <bus-id> COMMAND=0006
```

Without bus mastering, H2C writes can fail with an XDMA driver error such as `Unknown error 512`.

## Run

Single frame:

```bash
build/normal_eq_replay/normal_eq_replay \
  --golden fpga/golden_small/frame_000100.bin \
  --h2c /dev/xdma0_h2c_0 \
  --c2h /dev/xdma0_c2h_0 \
  --user /dev/xdma0_user \
  --ctrl 0x1000 \
  --input 0x02000000 \
  --output 0x02100000 \
  --timeout_ms 1000 \
  --abs_tol 1e-3 \
  --rel_tol 1e-5
```

If `--golden` is omitted, the tool runs:

- `fpga/golden_small/frame_000100.bin`
- `fpga/golden_small/frame_000200.bin`
- `fpga/golden_small/frame_000300.bin`

## Register Map

- control base: `0x1000`
- `0x10`: `input_r`
- `0x18`: `output_r`
- `0x20`: `num_points`
- `0x00`: AP control, write `1` to start, poll bit1 `ap_done`

## DDR Buffers

- input buffer: `0x02000000`
- output buffer: `0x02100000`

Input layout:

- byte `0`: `FpgaStateInput`, 128 bytes
- byte `128`: `FpgaCorrInput[num_points]`, 32 bytes each

Output layout:

- byte `0`: `FpgaNormalEqOutput`, 192 bytes

The checker accepts a value when either absolute error is within `--abs_tol` or relative error is within
`--rel_tol`. This keeps small terms strict while allowing large accumulated `H` terms to differ slightly because of
floating-point accumulation order.
