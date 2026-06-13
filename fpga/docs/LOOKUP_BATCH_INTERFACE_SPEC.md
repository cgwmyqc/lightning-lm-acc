# FPGA LookupBatch Interface Spec

## Version

- Interface version: 1
- C++ namespace: `lightning::fpga`
- Header: `src/fpga/fpga_lookup_types.h`
- Endian: little-endian
- Scalar type: `float32`

## Purpose

P1-A freezes the Orin-side surfel lookup batch interface before implementing the Windows/HLS kernel.

The batch lookup receives world-frame query points plus a flattened snapshot of `BlockSurfelMap`, and returns one result per point. The CPU_SIM backend must match the current `BlockSurfelMap::LookupSurfel()` behavior.

## Data Structures

`FpgaLookupPointInput` is 16 bytes:

```text
float x, y, z        # query point in world frame
float intensity      # currently diagnostic only
```

`FpgaLookupParams` is 32 bytes:

```text
uint32 magic         # 0x4C464750
uint32 version       # 1
uint32 num_points
uint32 num_blocks
float cell_resolution
float inv_cell_resolution
uint32 min_support
uint32 lookup_nearby_type
```

`FpgaLookupCell` is 48 bytes:

```text
uint32 count
uint32 flags
float sum[3]
float nx, ny, nz, d
float quality
```

`FpgaLookupBlock` stores one block key and all 256 cells:

```text
int32 bx, by, bz
uint32 valid_cell_count
FpgaLookupCell cells[256]
```

`FpgaLookupResult` is 64 bytes:

```text
uint32 valid
uint32 fallback
uint32 hit_neighbor
uint32 neighbor_level
uint32 miss_reason
uint32 count
float quality
float reserved0
float plane[4]
float centroid[3]
float reserved1
```

## HLS DDR Buffer Interface

The Windows Vivado HLS P1 top function uses raw DDR word buffers:

```cpp
void lookup_batch_accel(const uint32_t* input, uint32_t* output, int num_points, int num_blocks);
```

Input DDR layout:

```text
byte offset 0:
  FpgaLookupParams                  # 32 bytes

byte offset 32:
  FpgaLookupPointInput[num_points]  # 16 bytes each

next byte offset:
  FpgaLookupBlock[num_blocks]       # 12304 bytes each
```

Output DDR layout:

```text
byte offset 0:
  FpgaLookupResult[num_points]      # 64 bytes each
```

Vivado HLS 2018.3 AXI-Lite register map from IP export:

```text
0x00  control
0x04  GIE
0x08  IER
0x0c  ISR
0x10  input_r
0x18  output_r
0x20  num_points
0x28  num_blocks
```

Vivado HLS renames `input` and `output` to `input_r` and `output_r` in the generated register map because they are HDL keywords.

## Lookup Rules

The CPU_SIM backend follows the current CPU implementation:

- Grid encoding: `floor(point_world / cell_resolution)`.
- Block geometry: `BX=8`, `BY=8`, `BZ=4`, `CELLS_PER_BLOCK=256`.
- Exact cell is checked first.
- If exact lookup misses and `lookup_nearby_type` is nonzero, neighboring cells in a 3x3x3 window are checked.
- `lookup_nearby_type` limits neighbors to 6, 18, or 26 connectivity.
- Candidate selection uses smaller absolute point-to-plane residual, then smaller squared centroid distance, then smaller surfel quality.
- Miss reason priority follows current code: `QUALITY_BAD > SUPPORT_LOW > EMPTY_CELL > NO_BLOCK`.

## Orin Configuration

Default behavior keeps lookup on the legacy CPU path:

```yaml
fpga:
  lookup_enable: false
  lookup_mode: cpu
  lookup_golden_dump_enable: false
  lookup_golden_dump_dir: /tmp/lightning_fpga_lookup_golden
  lookup_golden_dump_every_n_frames: 100
  lookup_golden_dump_max_files: 50
  lookup_compare_with_cpu: true
```

For P1-A validation:

```yaml
fpga:
  lookup_enable: true
  lookup_mode: cpu_sim
  lookup_golden_dump_enable: true
  lookup_compare_with_cpu: true
```

`lookup_mode: cpu_sim` uses the flattened snapshot backend and compares against direct `BlockSurfelMap::LookupSurfel()` when `lookup_compare_with_cpu` is enabled.

