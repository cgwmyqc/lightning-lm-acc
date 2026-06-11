# FPGA Normal Equation Interface Spec

## Version

- Interface version: 1
- C++ namespace: `lightning::fpga`
- Header: `src/fpga/fpga_types.h`
- Endian: little-endian
- Scalar type: `float32`

## Data Structures

`FpgaCorrInput` is 32 bytes and 32-byte aligned:

```text
float px, py, pz   # point in IMU/body frame
float nx, ny, nz   # plane normal in world frame
float d            # plane offset in world frame
float weight       # phase-1 default: 1.0
```

`FpgaStateInput` is 64-byte aligned:

```text
uint32 magic       # 0x4C464750
uint32 version     # 1
uint32 num_points
uint32 reserved0
float R[9]         # row-major R_wi, IMU/body to world
float t[3]         # t_wi
uint32 reserved1[8]
```

`FpgaNormalEqOutput` is 64-byte aligned:

```text
uint32 magic
uint32 version
uint32 valid_count
uint32 reserved0
float H_upper[21]
float b[6]
float residual_sum
float residual_abs_sum
float reserved1[7]
```

## HLS DDR Buffer Interface

The Windows Vivado HLS phase-1 top function uses raw DDR word buffers:

```cpp
void normal_eq_accel(const uint32_t* input, uint32_t* output, int num_points);
```

This interface shape is intentional. It keeps bulk data in DDR and prevents Vivado HLS 2018.3 from expanding `FpgaStateInput`, `FpgaCorrInput`, or `FpgaNormalEqOutput` fields into many AXI-Lite registers.

Input DDR layout:

```text
byte offset 0:
  FpgaStateInput              # 128 bytes

byte offset 128:
  FpgaCorrInput[num_points]   # 32 bytes each
```

Input word offsets:

```text
0   magic
1   version
2   num_points
3   reserved0
4   R[0]
...
12  R[8]
13  t[0]
14  t[1]
15  t[2]
32  FpgaCorrInput[0].px
33  FpgaCorrInput[0].py
...
39  FpgaCorrInput[0].weight
40  FpgaCorrInput[1].px
```

Output DDR layout:

```text
byte offset 0:
  FpgaNormalEqOutput          # 192 bytes
```

Output word offsets:

```text
0   magic
1   version
2   valid_count
3   reserved0
4   H_upper[0]
...
24  H_upper[20]
25  b[0]
...
30  b[5]
31  residual_sum
32  residual_abs_sum
33  reserved1[0]
...
39  reserved1[6]
```

Vivado HLS 2018.3 AXI-Lite register map from C synthesis:

```text
0x00  control
0x04  GIE
0x08  IER
0x0c  ISR
0x10  input_r      # DDR input buffer pointer
0x18  output_r     # DDR output buffer pointer
0x20  num_points
```

Vivado HLS renames `input` and `output` to `input_r` and `output_r` in the generated register map because they are HDL keywords. Use the generated `xnormal_eq_accel_hw.h` after IP export as the final source of truth for host-side offsets.

## H_upper Order

`H_upper[21]` stores the upper triangle of the 6x6 matrix in row-major triangular order:

```text
(0,0), (0,1), (0,2), (0,3), (0,4), (0,5),
       (1,1), (1,2), (1,3), (1,4), (1,5),
              (2,2), (2,3), (2,4), (2,5),
                     (3,3), (3,4), (3,5),
                            (4,4), (4,5),
                                   (5,5)
```

## Phase-1 Math

Phase 1 follows the current Orin CPU implementation in `LaserMapping::ObsModel`.

- Input point: `p_imu = offset_R_lidar_fixed * p_lidar + offset_t_lidar_fixed`
- World point: `p_world = R_wi * p_imu + t_wi`
- Residual: `r = n_world^T * p_world + d`
- Jacobian state order: `[tx, ty, tz, rx, ry, rz]`
- Jacobian:

```text
C = R_wi^T * n_world
A = skew(p_imu) * C
J = [nx, ny, nz, A.x, A.y, A.z]
```

- Accumulation:

```text
H += weight * J^T * J
b += weight * J^T * (-r)
```

The SLAM code applies `plane_icp_weight` after backend accumulation.

## Scope

Only surfel-hit effective points are sent to the backend. iVox fallback, surfel lookup, KNN, ESKF solve, and map update remain on CPU.

For surfel-only experiments, set:

```yaml
fasterlio:
  surfel_fallback_mode: none
  min_pts_when_no_ivox_fallback: 20
```

This disables the CPU iVox KNN fallback in `ObsModel`. Surfel miss points remain visible in fallback statistics but are not used for CPU fallback normal-equation accumulation.

## Orin Online FPGA Backend

The Orin-side online backend uses the same DDR layout and AXI-Lite register map as `normal_eq_replay`.

Default XDMA/device configuration:

```yaml
fpga:
  enable: true
  mode: fpga
  golden_dump_enable: false
  xdma_h2c: /dev/xdma0_h2c_0
  xdma_c2h: /dev/xdma0_c2h_0
  xdma_user: /dev/xdma0_user
  normal_eq_ctrl_addr: 0x1000
  input_addr: 0x02000000
  output_addr: 0x02100000
  timeout_ms: 1000
  compare_with_cpu: true
  compare_abs_tol: 1.0e-3
  compare_rel_tol: 1.0e-5
  fallback_to_cpu_on_error: true
```

Runtime sequence per frame:

1. Pack `FpgaStateInput` and `FpgaCorrInput[num_points]` into the DDR input buffer.
2. Write input through `/dev/xdma0_h2c_0` at `input_addr`.
3. Clear the output buffer through `/dev/xdma0_h2c_0` at `output_addr`.
4. Write AXI-Lite registers through `/dev/xdma0_user`: `input_r`, `output_r`, `num_points`, then `ap_start`.
5. Poll AP control until `ap_done` or `timeout_ms`.
6. Read `FpgaNormalEqOutput` through `/dev/xdma0_c2h_0`.
7. Validate `magic`, `version`, and `valid_count`, then convert `H_upper[21]` back to the symmetric 6x6 matrix.

Before online testing, confirm the PCIe device has `BusMaster+`:

```bash
lspci -vv -s <bus-id> | grep Control
```

If it shows `BusMaster-`, enable bus mastering manually:

```bash
sudo setpci -s <bus-id> COMMAND=0006
```
