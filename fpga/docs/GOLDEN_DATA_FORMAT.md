# FPGA Golden Data Format

## File Name

Golden files are written as:

```text
frame_XXXXXX.bin
```

The default directory is:

```text
/tmp/lightning_fpga_golden
```

## Layout

Each file is a raw little-endian binary blob:

```text
GoldenHeader
FpgaCorrInput[num_points]
```

`GoldenHeader` is defined in `src/fpga/fpga_types.h` and contains:

```text
uint32 magic              # 0x4C474F4C
uint32 version            # 1
uint32 frame_id
uint32 num_points
float R[9]                # row-major R_wi
float t[3]                # t_wi
float H_upper_cpu[21]     # CPU_SIM reference, unweighted by plane_icp_weight
float b_cpu[6]            # CPU_SIM reference, unweighted by plane_icp_weight
float residual_sum_cpu
float residual_abs_sum_cpu
uint32 reserved[16]
```

## Orin Generation

Enable CPU_SIM and golden dumping in YAML:

```yaml
fpga:
  enable: true
  mode: cpu_sim
  golden_dump_enable: true
  golden_dump_dir: /tmp/lightning_fpga_golden
  golden_dump_every_n_frames: 100
  golden_dump_max_files: 50
```

The Orin side writes only surfel-hit effective points. Fallback points are intentionally absent from golden files.

## HLS/Testbench Reading

The Windows HLS testbench should:

1. Read `GoldenHeader`.
2. Verify `magic` and `version`.
3. Read exactly `num_points` `FpgaCorrInput` records.
4. Run the HLS normal equation kernel with the header state and corr array.
5. Compare output against `H_upper_cpu` and `b_cpu`.

Suggested phase-1 tolerance:

```text
max_abs_error <= 1.0e-4 for C simulation
```
