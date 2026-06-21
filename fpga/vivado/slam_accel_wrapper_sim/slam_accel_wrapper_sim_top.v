// SPDX-License-Identifier: MIT
//
// Minimal wrapper used to validate the AXI-Lite controller to HLS direct
// control/address contract before block design integration.

`timescale 1ns / 1ps

module slam_accel_wrapper_sim_top #(
    parameter integer AXI_ADDR_WIDTH = 12,
    parameter integer AXI_DATA_WIDTH = 32
) (
    input  wire                          aclk,
    input  wire                          aresetn,

    input  wire [AXI_ADDR_WIDTH-1:0]     s_axi_awaddr,
    input  wire                          s_axi_awvalid,
    output wire                          s_axi_awready,
    input  wire [AXI_DATA_WIDTH-1:0]     s_axi_wdata,
    input  wire [(AXI_DATA_WIDTH/8)-1:0] s_axi_wstrb,
    input  wire                          s_axi_wvalid,
    output wire                          s_axi_wready,
    output wire [1:0]                    s_axi_bresp,
    output wire                          s_axi_bvalid,
    input  wire                          s_axi_bready,

    input  wire [AXI_ADDR_WIDTH-1:0]     s_axi_araddr,
    input  wire                          s_axi_arvalid,
    output wire                          s_axi_arready,
    output wire [AXI_DATA_WIDTH-1:0]     s_axi_rdata,
    output wire [1:0]                    s_axi_rresp,
    output wire                          s_axi_rvalid,
    input  wire                          s_axi_rready,

    output wire                          debug_hls_ap_start,
    output wire                          debug_hls_ap_done,
    output wire                          debug_hls_ap_idle,
    output wire                          debug_hls_ap_ready,
    output wire [31:0]                   debug_hls_activity_sink
);

wire        unified_obs_ap_start;
wire        unified_obs_ap_idle;
wire        unified_obs_ap_ready;
wire        unified_obs_ap_done;
wire [31:0] unified_obs_num_points;
wire [31:0] unified_obs_scan_points_addr;
wire [31:0] unified_obs_pose_addr;
wire [31:0] unified_obs_map_header_addr;
wire [31:0] unified_obs_params_addr;
wire [31:0] unified_obs_active_blocks_addr;
wire [31:0] unified_obs_obs_cells_addr;
wire [31:0] unified_obs_output_addr;
wire [31:0] unified_obs_output_h_upper_addr;
wire [31:0] unified_obs_output_b_addr;
wire [31:0] unified_obs_output_valid_count_addr;
wire [31:0] unified_obs_output_reject_count_addr;
wire [31:0] unified_obs_output_miss_count_addr;
wire [31:0] unified_obs_output_flags_addr;
wire [31:0] unified_obs_output_residual_sum_addr;
wire [31:0] unified_obs_output_residual_abs_sum_addr;
wire [31:0] unified_obs_output_residual_max_abs_addr;
wire [31:0] unified_obs_output_reserved_addr;
wire [31:0] kernel_sel;
wire [31:0] mode;

assign debug_hls_ap_start = unified_obs_ap_start;
assign debug_hls_ap_done = unified_obs_ap_done;
assign debug_hls_ap_idle = unified_obs_ap_idle;
assign debug_hls_ap_ready = unified_obs_ap_ready;

slam_accel_ctrl #(
    .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
    .AXI_DATA_WIDTH(AXI_DATA_WIDTH)
) ctrl_i (
    .aclk(aclk),
    .aresetn(aresetn),
    .s_axi_awaddr(s_axi_awaddr),
    .s_axi_awvalid(s_axi_awvalid),
    .s_axi_awready(s_axi_awready),
    .s_axi_wdata(s_axi_wdata),
    .s_axi_wstrb(s_axi_wstrb),
    .s_axi_wvalid(s_axi_wvalid),
    .s_axi_wready(s_axi_wready),
    .s_axi_bresp(s_axi_bresp),
    .s_axi_bvalid(s_axi_bvalid),
    .s_axi_bready(s_axi_bready),
    .s_axi_araddr(s_axi_araddr),
    .s_axi_arvalid(s_axi_arvalid),
    .s_axi_arready(s_axi_arready),
    .s_axi_rdata(s_axi_rdata),
    .s_axi_rresp(s_axi_rresp),
    .s_axi_rvalid(s_axi_rvalid),
    .s_axi_rready(s_axi_rready),
    .unified_obs_ap_start(unified_obs_ap_start),
    .unified_obs_ap_idle(unified_obs_ap_idle),
    .unified_obs_ap_ready(unified_obs_ap_ready),
    .unified_obs_ap_done(unified_obs_ap_done),
    .unified_obs_error(32'd0),
    .unified_obs_num_points(unified_obs_num_points),
    .unified_obs_scan_points_addr(unified_obs_scan_points_addr),
    .unified_obs_pose_addr(unified_obs_pose_addr),
    .unified_obs_map_header_addr(unified_obs_map_header_addr),
    .unified_obs_params_addr(unified_obs_params_addr),
    .unified_obs_active_blocks_addr(unified_obs_active_blocks_addr),
    .unified_obs_obs_cells_addr(unified_obs_obs_cells_addr),
    .unified_obs_output_addr(unified_obs_output_addr),
    .unified_obs_output_h_upper_addr(unified_obs_output_h_upper_addr),
    .unified_obs_output_b_addr(unified_obs_output_b_addr),
    .unified_obs_output_valid_count_addr(unified_obs_output_valid_count_addr),
    .unified_obs_output_reject_count_addr(unified_obs_output_reject_count_addr),
    .unified_obs_output_miss_count_addr(unified_obs_output_miss_count_addr),
    .unified_obs_output_flags_addr(unified_obs_output_flags_addr),
    .unified_obs_output_residual_sum_addr(unified_obs_output_residual_sum_addr),
    .unified_obs_output_residual_abs_sum_addr(unified_obs_output_residual_abs_sum_addr),
    .unified_obs_output_residual_max_abs_addr(unified_obs_output_residual_max_abs_addr),
    .unified_obs_output_reserved_addr(unified_obs_output_reserved_addr),
    .kernel_sel(kernel_sel),
    .mode(mode)
);

unified_surfel_observation_core_ctrl_mock hls_ctrl_mock_i (
    .ap_clk(aclk),
    .ap_rst_n(aresetn),
    .ap_start(unified_obs_ap_start),
    .ap_done(unified_obs_ap_done),
    .ap_idle(unified_obs_ap_idle),
    .ap_ready(unified_obs_ap_ready),
    .num_points(unified_obs_num_points),
    .scan_points(unified_obs_scan_points_addr),
    .pose(unified_obs_pose_addr),
    .map_header(unified_obs_map_header_addr),
    .params(unified_obs_params_addr),
    .active_blocks(unified_obs_active_blocks_addr),
    .obs_cells(unified_obs_obs_cells_addr),
    .output_h_upper(unified_obs_output_h_upper_addr),
    .output_b(unified_obs_output_b_addr),
    .output_valid_count(unified_obs_output_valid_count_addr),
    .output_reject_count(unified_obs_output_reject_count_addr),
    .output_miss_count(unified_obs_output_miss_count_addr),
    .output_flags(unified_obs_output_flags_addr),
    .output_residual_sum(unified_obs_output_residual_sum_addr),
    .output_residual_abs_sum(unified_obs_output_residual_abs_sum_addr),
    .output_residual_max_abs(unified_obs_output_residual_max_abs_addr),
    .output_reserved(unified_obs_output_reserved_addr),
    .activity_sink(debug_hls_activity_sink)
);

endmodule
