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
