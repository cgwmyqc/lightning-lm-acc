# normal_eq_accel

Vivado HLS 2018.3 project for the Lightning-LM phase-1 FPGA normal equation accumulator.

## Scope

This accelerator only handles surfel-hit normal-equation accumulation:

- input DDR buffer: `FpgaStateInput` followed by `FpgaCorrInput[]`
- output DDR buffer: `FpgaNormalEqOutput`
- math: residual, Jacobian, `H_upper[21]`, `b[6]`, residual sums

It does not implement surfel lookup, KNN, iVox fallback, ESKF solve, or map update.

## Interface

The HLS top uses raw DDR word buffers:

```cpp
void normal_eq_accel(const uint32_t* input, uint32_t* output, int num_points);
```

The data structures mirror the Orin-side interface in `src/fpga/fpga_types.h`, but this HLS project does not include Orin-side headers.

Input DDR layout:

```text
byte offset 0:
  FpgaStateInput              # 128 bytes, 32 uint32 words

byte offset 128:
  FpgaCorrInput[num_points]   # 32 bytes each, 8 uint32 words each
```

Output DDR layout:

```text
byte offset 0:
  FpgaNormalEqOutput          # 192 bytes, 48 uint32 words
```

Vivado HLS 2018.3 AXI-Lite control register summary after synthesis:

```text
0x00  control
0x04  GIE
0x08  IER
0x0c  ISR
0x10  input_r      # DDR input buffer pointer
0x18  output_r     # DDR output buffer pointer
0x20  num_points
```

Vivado HLS renames `input` and `output` to `input_r` and `output_r` in the generated register map because they are HDL keywords.

Golden files are still read by the C simulation testbench as:

```text
GoldenHeader        # 256 bytes
FpgaCorrInput[N]    # 32 bytes each
```

The testbench repacks `GoldenHeader.R/t` and the correspondence array into the DDR input layout before calling the HLS top, then unpacks the DDR output layout for comparison.

The Jacobian and accumulation follow `fpga/docs/INTERFACE_SPEC.md`:

```text
p_world = R_wi * p_imu + t_wi
r = n^T * p_world + d
C = R_wi^T * n
A = skew(p_imu) * C
J = [nx, ny, nz, A.x, A.y, A.z]
H += weight * J^T * J
b += weight * J^T * (-r)
```

## C Simulation

From the repository root:

```powershell
vivado_hls.bat -f fpga\hls\normal_eq_accel\run_csim.tcl
```

Or from this directory:

```powershell
vivado_hls.bat -f run_csim.tcl
```

The testbench runs the three small Orin-generated golden files in `fpga/golden_small` and prints `PASS` or `FAIL` for each file.

Current checked result:

```text
frame_000100.bin PASS
frame_000200.bin PASS
frame_000300.bin PASS
```

## C Synthesis

```powershell
vivado_hls.bat -f fpga\hls\normal_eq_accel\run_csynth.tcl
```

Current checked Vivado HLS 2018.3 result:

```text
Timing target: 10 ns, matching the 100 MHz ap_clk used in Vivado BD
Estimated clock: 9.151 ns
Main accumulation loop: II=8, depth=60
Resources: BRAM_18K 2, DSP48E 36, FF 10219, LUT 9415
```

The generated interface has one `m_axi_gmem` DDR master and AXI-Lite control registers for `input_r`, `output_r`, and `num_points`. It no longer expands state, correspondence, or output struct fields into AXI-Lite registers.

## Export IP

```powershell
vivado_hls.bat -f fpga\hls\normal_eq_accel\export_ip.tcl
```

The IP export target is:

```text
fpga/vivado/ip_repo/normal_eq_accel
```

Vivado HLS 2018.3 does not support `export_design -output`. The export script uses the default HLS IP export directory and then copies the generated IP into the repository path above.

Vivado HLS 2018.3 can also generate an oversized date-based `core_revision` value on current dates. The export script patches the generated `run_ippack.tcl` revision to a safe value and reruns IP packaging if that old-tool issue appears.

After a successful export, this file should exist:

```text
fpga/vivado/ip_repo/normal_eq_accel/component.xml
```

Do not commit generated HLS project directories such as `normal_eq_accel_prj/solution1`.
