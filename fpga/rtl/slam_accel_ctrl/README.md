# slam_accel_ctrl P2 Interface Convergence

`slam_accel_ctrl` is the single AXI-Lite control point exposed by the 7Z100 FPGA subsystem.

This version contains:

- AXI-Lite slave register bank
- command decoder
- dispatch FSM
- `kernel_sel` and `mode` registers
- status, error, cycle, and run counters
- direct `ap_ctrl_hs` wiring for `unified_surfel_observation_core`
- direct 32-bit base-address outputs for the HLS `m_axi offset=direct` ports
- a direct output base address for the HLS `output_words` port

It does not instantiate XDMA, block design, DDR interconnect, or the HLS IP. Those are later integration tasks after the register and HLS IP contracts are stable.

## Register Map

| Offset | Name | Access | Description |
| --- | --- | --- | --- |
| `0x000` | `VERSION` | RO | Interface convergence version, currently `0x0002_0002` |
| `0x004` | `CONTROL` | WO | bit0 `start`, bit1 `clear_done_error` |
| `0x008` | `STATUS` | RO | bit0 idle, bit1 busy, bit2 done, bit3 error, bit8 HLS done, bit9 HLS idle, bit10 HLS ready |
| `0x00c` | `KERNEL_SEL` | RW | `4` = unified observation |
| `0x010` | `MODE` | RW | `0` mapping observation, `1` localization observation |
| `0x014` | `ERROR` | RO | `0` ok, `1` unsupported kernel, `3` non-zero high address word |
| `0x018` | `CYCLE_COUNT` | RW | increments while dispatch/wait are active |
| `0x01c` | `RUN_COUNT` | RW | increments when the HLS IP accepts `ap_start` |
| `0x020` | `SCAN_ADDR_LO` | RW | low 32 bits of scan point buffer base |
| `0x024` | `SCAN_ADDR_HI` | RW | must be zero in this 32-bit address phase |
| `0x028` | `SCAN_COUNT` | RW | `num_points` passed to HLS |
| `0x02c` | `POSE_ADDR_LO` | RW | low 32 bits of pose buffer base |
| `0x030` | `POSE_ADDR_HI` | RW | must be zero in this 32-bit address phase |
| `0x034` | `MAP_HEADER_ADDR_LO` | RW | low 32 bits of map header buffer base |
| `0x038` | `MAP_HEADER_ADDR_HI` | RW | must be zero in this 32-bit address phase |
| `0x03c` | `ACTIVE_BLOCKS_ADDR_LO` | RW | low 32 bits of active block buffer base |
| `0x040` | `ACTIVE_BLOCKS_ADDR_HI` | RW | must be zero in this 32-bit address phase |
| `0x044` | `OBS_CELLS_ADDR_LO` | RW | low 32 bits of observation cell buffer base |
| `0x048` | `OBS_CELLS_ADDR_HI` | RW | must be zero in this 32-bit address phase |
| `0x04c` | `OUT_ADDR_LO` | RW | low 32 bits of output normal-equation buffer base |
| `0x050` | `OUT_ADDR_HI` | RW | must be zero in this 32-bit address phase |

## HLS Direct Ports

Outputs to `unified_surfel_observation_core`:

```text
unified_obs_ap_start
unified_obs_num_points[31:0]
unified_obs_scan_points_addr[31:0]
unified_obs_pose_addr[31:0]
unified_obs_map_header_addr[31:0]
unified_obs_active_blocks_addr[31:0]
unified_obs_obs_cells_addr[31:0]
unified_obs_output_addr[31:0]
```

Stage 44 HLS uses `unified_obs_output_addr` as the single base address for a
64-bit `output_words` buffer. The host-visible `SlamNormalEquation` ABI remains
unchanged: 320 bytes with counters at offsets `216/220/224/228`.

The following legacy derived output-field ports remain in `slam_accel_ctrl` for
source compatibility with older wrapper experiments, but the formal Stage 44
HLS IP and board BD do not connect them:

```text
unified_obs_output_h_upper_addr[31:0]
unified_obs_output_b_addr[31:0]
unified_obs_output_valid_count_addr[31:0]
unified_obs_output_reject_count_addr[31:0]
unified_obs_output_miss_count_addr[31:0]
unified_obs_output_flags_addr[31:0]
unified_obs_output_residual_sum_addr[31:0]
unified_obs_output_residual_abs_sum_addr[31:0]
unified_obs_output_residual_max_abs_addr[31:0]
unified_obs_output_reserved_addr[31:0]
```

Legacy derived output-field layout:

```text
output_h_upper:          OUT_ADDR + 0
output_b:                OUT_ADDR + 168
output_valid_count:      OUT_ADDR + 216
output_reject_count:     OUT_ADDR + 220
output_miss_count:       OUT_ADDR + 224
output_flags:            OUT_ADDR + 228
output_residual_sum:     OUT_ADDR + 232
output_residual_abs_sum: OUT_ADDR + 240
output_residual_max_abs: OUT_ADDR + 248
output_reserved:         OUT_ADDR + 256
```

Inputs from `unified_surfel_observation_core`:

```text
unified_obs_ap_idle
unified_obs_ap_ready
unified_obs_ap_done
unified_obs_error[31:0]
```

## FSM

```text
IDLE -> DISPATCH -> WAIT -> DONE
                  \-> ERROR
```

`DISPATCH` holds `unified_obs_ap_start` high until `unified_obs_ap_ready` is observed. `WAIT` completes on `unified_obs_ap_done` or enters `ERROR` when `unified_obs_error` is non-zero.

Only `KERNEL_SEL=4` dispatches in this version. Other kernel selectors are reserved for later `map_update_pipeline` and `solve6x6_core` work.

## OOC Synthesis

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\rtl\slam_accel_ctrl\run_vivado_ooc_synth.ps1
```

The default project directory is:

```text
%TEMP%\lightning_slam_accel_ctrl_ooc
```
