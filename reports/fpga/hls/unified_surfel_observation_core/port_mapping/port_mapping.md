# unified_surfel_observation_core generated RTL port mapping

Date: 2026-06-16

## Result

PASS. Generated RTL has the expected `ap_ctrl_hs` control pins and 32-bit direct scalar address inputs. No `s_axi_control` or other `s_axi` system-control entry was found.

Stage 44 update: this 2026-06-16 mapping is historical for the old per-field
output direct-port IP. The current formal HLS IP uses a single
`output_words <- unified_obs_output_addr` direct port. Do not use the old
`output_valid_count/output_reject_count/...` mapping for new board images.

## Controller to HLS top mapping

```text
ap_start <- unified_obs_ap_start
ap_done -> unified_obs_ap_done
ap_idle -> unified_obs_ap_idle
ap_ready -> unified_obs_ap_ready
num_points <- unified_obs_num_points
scan_points <- unified_obs_scan_points_addr
pose <- unified_obs_pose_addr
map_header <- unified_obs_map_header_addr
active_blocks <- unified_obs_active_blocks_addr
obs_cells <- unified_obs_obs_cells_addr
output_h_upper <- unified_obs_output_h_upper_addr
output_b <- unified_obs_output_b_addr
output_valid_count <- unified_obs_output_valid_count_addr
output_reject_count <- unified_obs_output_reject_count_addr
output_miss_count <- unified_obs_output_miss_count_addr
output_flags <- unified_obs_output_flags_addr
output_residual_sum <- unified_obs_output_residual_sum_addr
output_residual_abs_sum <- unified_obs_output_residual_abs_sum_addr
output_residual_max_abs <- unified_obs_output_residual_max_abs_addr
output_reserved <- unified_obs_output_reserved_addr
```

Current HLS core has no `error` output. Until a real HLS error/status channel is added, wrapper/BD integration must tie `unified_obs_error` to `32'd0`.

## Generated RTL direct ports

```text
input   ap_start;
output  ap_done;
output  ap_idle;
output  ap_ready;
input  [31:0] scan_points;
input  [31:0] num_points;
input  [31:0] pose;
input  [31:0] map_header;
input  [31:0] active_blocks;
input  [31:0] obs_cells;
input  [31:0] output_h_upper;
input  [31:0] output_b;
input  [31:0] output_valid_count;
input  [31:0] output_reject_count;
input  [31:0] output_miss_count;
input  [31:0] output_flags;
input  [31:0] output_residual_sum;
input  [31:0] output_residual_abs_sum;
input  [31:0] output_residual_max_abs;
input  [31:0] output_reserved;
```

The generated direct ports are single scalar ports, not AXI-Lite register ports. The memory interfaces remain `m_axi_gmem0..m_axi_gmem4`.
