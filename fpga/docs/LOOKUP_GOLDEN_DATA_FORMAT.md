# FPGA Lookup Golden Data Format

## File Name

Lookup golden files are written as:

```text
lookup_frame_XXXXXX.bin
```

Default directory:

```text
/tmp/lightning_fpga_lookup_golden
```

## Binary Layout

All fields are little-endian.

```text
LookupGoldenHeader
FpgaLookupPointInput[num_points]
FpgaLookupBlock[num_blocks]
FpgaLookupResult[num_points]
```

The result array is the CPU_SIM reference output for the same query points and map snapshot.

## Header

`LookupGoldenHeader` contains:

- magic/version/frame_id
- num_points/num_blocks
- cell and block element sizes
- surfel lookup parameters
- hit/miss summary counters

The header magic is:

```text
0x4C474C4B  # "LGLK"
```

## Usage

Generate lookup golden data with:

```yaml
fpga:
  lookup_enable: true
  lookup_mode: cpu_sim
  lookup_golden_dump_enable: true
  lookup_golden_dump_dir: /tmp/lightning_fpga_lookup_golden
  lookup_golden_dump_every_n_frames: 100
  lookup_golden_dump_max_files: 50
```

Expected runtime log:

```text
[fpga] surfel lookup backend: LOOKUP_CPU_SIM
[fpga lookup] compare_with_cpu PASS ...
Wrote FPGA lookup golden file: /tmp/lightning_fpga_lookup_golden/lookup_frame_XXXXXX.bin
```

The lookup golden files are intended for the next Windows/HLS step. They should not be committed if generated from long bag runs.

