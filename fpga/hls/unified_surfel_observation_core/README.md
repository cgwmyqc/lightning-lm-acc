# unified_surfel_observation_core V1

This directory contains the portable C++/Vivado HLS CSim source for the shared mapping/localization surfel observation kernel.

## Scope

Implemented in V1:

- read body-frame scan points
- read pose guess
- read active `ObsCellFloat64` map buffer
- lookup exact/nearby surfel cell
- accumulate point-to-plane residual/Jacobian into `H_upper[21]` and `b[6]`
- output valid/reject/miss/residual statistics

Not implemented in V1:

- BatchUpdate
- DirtyRefit
- solve6x6
- AXI-Lite controller inside the HLS IP
- XDMA host runtime
- online guarded enable

## Files

- `../../abi/slam_accel_abi.h`: shared ABI used by Orin and HLS.
- `unified_surfel_observation_core.h/.cpp`: HLS top-level C++.
- `obs_tb.cpp`: CSim testbench that reads Orin-generated golden replay.

## Generate Golden On Orin/Linux

Build the ROS package first:

```bash
colcon build --packages-select lightning
```

Generate a localization replay frame:

```bash
./bin/build_surfel_loc_golden \
  --map_pcd ./data/example_active_map.pcd \
  --scan_pcd ./data/example_scan_body.pcd \
  --output_dir ./fpga/golden/localization/frame_000001 \
  --tx 0 --ty 0 --tz 0 --qx 0 --qy 0 --qz 0 --qw 1
```

Check the same replay with the Orin CPU implementation:

```bash
./bin/run_surfel_loc_golden_replay \
  --golden_dir ./fpga/golden/localization/frame_000001
```

## Run CSim On Windows

Quick g++ smoke test:

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_gpp_csim.ps1 `
  -GoldenDir .\fpga\golden\localization\frame_000001
```

Vivado HLS 2018.3 CSim:

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_csim.ps1 `
  -GoldenDir .\fpga\golden\localization\frame_000001
```

The Vivado HLS script creates a fresh project under the ignored `build/` directory and sets top function:

```text
unified_surfel_observation_core
```

Manual CSim still uses the golden directory as argv:

```text
obs_tb.exe <repo>/fpga/golden/localization/frame_000001
```

Expected result:

```text
[obs_tb] PASS <golden_dir>
```

The first acceptance target is:

```text
H/b: abs <= 1e-4 or rel <= 1e-3
stats: valid_count/reject_count/miss_count exact match
```

## Run C Synthesis On Windows

Vivado HLS 2018.3 C Synthesis:

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_csynth.ps1
```

By default, the script creates the HLS project under:

```text
%TEMP%\lightning_hls_unified_obs
```

This short path avoids Windows path length failures in Vivado HLS generated RTL file names.

Current 7Z100 synthesis checkpoint:

```text
Part: xc7z100ffg900-2
Target clock: 10.00 ns
Estimated clock: 9.307 ns
Resources: BRAM_18K 36, DSP48E 256, FF 27475, LUT 41633
```

## Run Cosim / IP Export On Windows

Vivado HLS 2018.3 Cosim:

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_cosim.ps1 `
  -GoldenDir .\fpga\golden\localization\frame_000001
```

Current status: blocked by the generated Vivado HLS 2018.3 cosim wrapper compile step before RTL simulation:

```text
g++.exe: error: release: No such file or directory
ERROR: [COSIM 212-317] C++ compile error.
```

CSim and C Synthesis still pass. The next simulation target is wrapper-level RTL simulation after `slam_accel_ctrl` and the HLS IP are instantiated together.

Vivado HLS 2018.3 IP export:

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_export_ip.ps1
```

The export script writes the generated project under:

```text
%TEMP%\lightning_hls_unified_obs
```

Vivado HLS 2018.3 generates a timestamp-like IP `core_revision` value. On dates such as 2026-06-16 that value exceeds the Vivado 2018.3 IP packager integer range. `run_vivado_hls_export_ip.ps1` checks the generated IP output; if HLS fails to produce `component.xml`/zip and the generated `run_ippack.tcl` revision is over range, it rewrites that local generated revision to `1` and reruns Vivado packager.

Current IP export checkpoint:

```text
component.xml: %TEMP%\lightning_hls_unified_obs\solution1\impl\ip\component.xml
ip_zip:        %TEMP%\lightning_hls_unified_obs\solution1\impl\ip\xilinx_com_hls_unified_surfel_observation_core_1_0.zip
coreRevision: 1
status:       PASS
```

## Interface Contract

`unified_surfel_observation_core` is an HLS compute IP, not a system control endpoint.

The generated HLS IP must not expose an independent AXI-Lite slave. The only external AXI-Lite control point in the 7Z100 design is `slam_accel_ctrl`.

Current HLS interface policy:

```text
control: ap_ctrl_hs
scan_points:   m_axi offset=direct, DATA_PACK, direct scalar base address
pose:          m_axi offset=direct, DATA_PACK, direct scalar base address
map_header:    m_axi offset=direct, DATA_PACK, direct scalar base address
params:        m_axi offset=direct, 16x64-bit words containing `SlamAccelObservationParams`
active_blocks: m_axi offset=direct, DATA_PACK, direct scalar base address
obs_cells:     m_axi offset=direct, DATA_PACK, direct scalar base address
output_words:  m_axi offset=direct, single 64-bit word buffer
num_points:    direct scalar input
```

`slam_accel_ctrl` owns the register bank, validates address high words, drives `ap_start`, and supplies the direct base-address inputs and `num_points`. HLS C++ behavior and the ABI structures stay unchanged.

Stage 44 changes the output path to a single 64-bit word buffer. Earlier HLS
exports exposed separate direct field ports for `SlamNormalEquation`, but
Vivado HLS generated those direct offsets on a 64-bit AXI word boundary. That
made adjacent 32-bit counters such as `valid_count` and `reject_count` alias on
the board. The external ABI remains the same 320-byte `SlamNormalEquation`; only
the HLS port contract changed.

Stage 53 adds the independent 128-byte `SlamAccelObservationParams` input.
FPGA does not read YAML/config files directly; Orin runtime must write this ABI
block to PL DDR before start. Localization keeps the existing residual reject
rule. Mapping uses `plane_icp_weight`, `extrinsic_R`, `extrinsic_T`, and the
mapping gate rule from the CPU surfel-map observation path instead of
localization's `abs(residual) > 0.3` reject rule.

Stage 54 makes neighbor candidate selection mode-specific. Localization keeps
the historical centroid-distance-first lookup. Mapping now matches
`mapping_golden::BetterMappingCell()`: compare absolute plane residual first
with `1e-4` tolerance, then centroid squared distance with `1e-4` tolerance,
then lower `quality`. This prevents mapping from choosing a geometrically closer
cell that later fails the mapping gate when a lower-residual neighbor exists.

Current output word layout:

```text
output_words[0..20]:  H_upper[21] as IEEE-754 double bit patterns
output_words[21..26]: b[6] as IEEE-754 double bit patterns
output_words[27]:     low32=valid_count, high32=reject_count
output_words[28]:     low32=miss_count, high32=flags
output_words[29]:     residual_sum as IEEE-754 double bit pattern
output_words[30]:     residual_abs_sum as IEEE-754 double bit pattern
output_words[31]:     residual_max_abs as IEEE-754 double bit pattern
output_words[32]:     low32=0x53543538 ("ST58"), high32=debug_version
output_words[33]:     low32=point_count, high32=exact_hit
output_words[34]:     low32=neighbor_hit, high32=lookup_miss
output_words[35]:     low32=neighbor_probe_count, high32=block_lookup_count
output_words[36]:     low32=block_search_step_count, high32=obs_cell_read_count
output_words[37]:     low32=valid_candidate_count, high32=invalid_candidate_count
output_words[38]:     low32=max_probe_per_point, high32=active_block_cache_count
output_words[39]:     low32=debug_flags, high32=0
```

Stage 58 reuses the reserved output words as performance diagnostics. The
formal normal-equation ABI in words `0..31` is unchanged, so existing host
parsers keep reading the same `SlamNormalEquation` fields.

Stage 58 also changes lookup implementation without changing lookup semantics:
`active_blocks[0..num_blocks)` is copied once at kernel start into local BRAM,
and each point reuses block-index lookups across its 27 center/neighbor probes.
`obs_cells` still remains in PL DDR because the full localization map can be
about 60 MB and is too large for first-round BRAM caching.

Stage 61 adds an opt-in Candidate ABI V2 path for performance. When
`SlamAccelObservationParams.flags` contains
`SLAM_ACCEL_OBS_FLAG_CANDIDATE_ABI_V2`, the HLS kernel treats `obs_cells` as a
per-point candidate buffer instead of the full active-map cell array.

V2 behavior:

- `OBS_CELLS_BASE` is reused as `candidate_cells[scan_count]`.
- Orin precomputes the final candidate surfel using the CPU/golden lookup
  policy for localization or mapping.
- Missing candidates are encoded as `ObsCellFloat64.flags = 0`.
- FPGA reads `scan_points[i]` and `candidate_cells[i]` sequentially, then runs
  residual/Jacobian/H/b accumulation.
- V1 lookup remains available when the flag is not set.
- The normal-equation ABI in `output_words[0..31]` is unchanged.
- `output_words[32..39]` use Stage 61 debug magic `0x53543631` (`ST61`) and
  report V2 counters; expected V2 `block_lookup` and `obs_cell_read` are zero.

Current Stage 61 Windows checkpoint:

```text
g++ CSim:               PASS
Vivado HLS CSim:        PASS
Vivado HLS C Synthesis: PASS
Vivado HLS IP export:   PASS
V2 localization:        6050/911/2 PASS
V2 mapping:             611/0/171 PASS
```

Stage 61 HLS C Synthesis summary:

```text
target clock:    10.00 ns
estimated clock: 9.307 ns
BRAM_18K:        184 / 1510 = 12%
DSP48E:          348 / 2020 = 17%
FF:              66007 / 554800 = 11%
LUT:             105315 / 277400 = 37%
```

Generated RTL direct mapping:

```text
ap_start <- unified_obs_ap_start
ap_done -> unified_obs_ap_done
ap_idle -> unified_obs_ap_idle
ap_ready -> unified_obs_ap_ready
num_points <- unified_obs_num_points
scan_points <- unified_obs_scan_points_addr
pose <- unified_obs_pose_addr
map_header <- unified_obs_map_header_addr
params <- unified_obs_params_addr
active_blocks <- unified_obs_active_blocks_addr
obs_cells <- unified_obs_obs_cells_addr
output_words <- unified_obs_output_addr
```

The current HLS core has no error output. Until a real error/status channel is added, wrapper/BD integration must tie `unified_obs_error` to `32'd0`.
