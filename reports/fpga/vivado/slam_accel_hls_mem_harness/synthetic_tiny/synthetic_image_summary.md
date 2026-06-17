# synthetic_tiny memory image summary

- generated_dir: `F:\Project_HITZRI\26-06-06_Lightninglm_fpga_acc\lightning-lm-acc\fpga\vivado\.build\synthetic_tiny`
- scan_points: 1
- active_blocks: 1
- obs_cells: 256
- valid_cells: 1
- gmem0_scan.bin: 16 bytes
- gmem1_pose_map_header.bin: 128 bytes
- gmem2_active_blocks.bin: 32 bytes
- gmem3_obs_cells.bin: 16384 bytes
- gmem4_output.bin: 320 bytes
- expected_counts: 1/0/0
- expected_residual_sum: 0.049999999999999989

This fixture is intentionally tiny so Vivado 2018.3 XSim can run the generated
HLS floating-point RTL to completion. It validates the real HLS RTL, controller
direct-control ports, and behavioral AXI memory model numeric path.
