# lookup_batch_accel

Vivado HLS 2018.3 project for the Lightning-LM P1 surfel LookupBatch replay kernel.

## Scope

This accelerator handles flattened surfel lookup only:

- input DDR buffer: `FpgaLookupParams`, `FpgaLookupPointInput[]`, `FpgaLookupBlock[]`
- output DDR buffer: `FpgaLookupResult[]`
- lookup rules: exact cell first, then 6/18/26-neighbor search according to `lookup_nearby_type`

It does not implement map update, surfel fitting, iVox fallback, normal-equation accumulation, or ESKF solve.

## Interface

The HLS top uses raw DDR word buffers:

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

Expected AXI-Lite control registers after synthesis:

```text
0x00  control
0x10  input_r
0x18  output_r
0x20  num_points
0x28  num_blocks
```

Vivado HLS renames `input` and `output` to `input_r` and `output_r` because they are HDL keywords.

## C Simulation

From the repository root:

```powershell
vivado_hls.bat -f fpga\hls\lookup_batch_accel\run_csim.tcl
```

The testbench runs:

```text
fpga/golden_small/lookup_frame_000100.bin
fpga/golden_small/lookup_frame_000200.bin
fpga/golden_small/lookup_frame_000300.bin
fpga/golden_small/lookup_frame_000400.bin
fpga/golden_small/lookup_frame_000500.bin
```

It validates `LookupGoldenHeader`, repacks the golden payload into the DDR input layout, runs the HLS top, and compares every output `FpgaLookupResult`.

Current checked result:

```text
lookup_frame_000100.bin PASS
lookup_frame_000200.bin PASS
lookup_frame_000300.bin PASS
lookup_frame_000400.bin PASS
lookup_frame_000500.bin PASS
```

## C Synthesis

```powershell
vivado_hls.bat -f fpga\hls\lookup_batch_accel\run_csynth.tcl
```

The phase-1 implementation is intentionally conservative: block lookup is a linear scan over `num_blocks`, single lane, float32. Optimize only after C simulation is stable.

Current checked Vivado HLS 2018.3 result:

```text
Timing target: 10 ns
Estimated clock: 9.164 ns
Top latency: up to 356450316 cycles for the configured tripcount estimates
Resources: BRAM_18K 2, DSP48E 35, FF 11420, LUT 16382
```

## Export IP

```powershell
vivado_hls.bat -f fpga\hls\lookup_batch_accel\export_ip.tcl
```

The IP export target is:

```text
fpga/vivado/ip_repo/lookup_batch_accel
```

The export script includes the same Vivado HLS 2018.3 compatibility workarounds used by `normal_eq_accel`.
