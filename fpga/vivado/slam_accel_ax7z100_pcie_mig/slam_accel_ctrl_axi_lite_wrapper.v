// SPDX-License-Identifier: MIT
//
// AXI-Lite interface wrapper for Vivado BD module-reference integration.

`timescale 1ns / 1ps

module slam_accel_ctrl_axi_lite_wrapper (
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk CLK" *)
    (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF S_AXI, ASSOCIATED_RESET aresetn, FREQ_HZ 125000000" *)
    input  wire        aclk,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 aresetn RST" *)
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *)
    input  wire        aresetn,

    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWADDR" *)
    input  wire [31:0] s_axi_awaddr,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWVALID" *)
    input  wire        s_axi_awvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWREADY" *)
    output wire        s_axi_awready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WDATA" *)
    input  wire [31:0] s_axi_wdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WSTRB" *)
    input  wire [3:0]  s_axi_wstrb,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WVALID" *)
    input  wire        s_axi_wvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WREADY" *)
    output wire        s_axi_wready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BRESP" *)
    output wire [1:0]  s_axi_bresp,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BVALID" *)
    output wire        s_axi_bvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BREADY" *)
    input  wire        s_axi_bready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARADDR" *)
    input  wire [31:0] s_axi_araddr,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARVALID" *)
    input  wire        s_axi_arvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARREADY" *)
    output wire        s_axi_arready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RDATA" *)
    output wire [31:0] s_axi_rdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RRESP" *)
    output wire [1:0]  s_axi_rresp,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RVALID" *)
    output wire        s_axi_rvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RREADY" *)
    input  wire        s_axi_rready,

    output wire        unified_obs_ap_start,
    input  wire        unified_obs_ap_idle,
    input  wire        unified_obs_ap_ready,
    input  wire        unified_obs_ap_done,
    input  wire [31:0] unified_obs_error,

    output wire [31:0] unified_obs_num_points,
    output wire [31:0] unified_obs_scan_points_addr,
    output wire [31:0] unified_obs_pose_addr,
    output wire [31:0] unified_obs_map_header_addr,
    output wire [31:0] unified_obs_active_blocks_addr,
    output wire [31:0] unified_obs_obs_cells_addr,
    output wire [31:0] unified_obs_output_addr,
    output wire [31:0] unified_obs_output_h_upper_addr,
    output wire [31:0] unified_obs_output_b_addr,
    output wire [31:0] unified_obs_output_valid_count_addr,
    output wire [31:0] unified_obs_output_reject_count_addr,
    output wire [31:0] unified_obs_output_miss_count_addr,
    output wire [31:0] unified_obs_output_flags_addr,
    output wire [31:0] unified_obs_output_residual_sum_addr,
    output wire [31:0] unified_obs_output_residual_abs_sum_addr,
    output wire [31:0] unified_obs_output_residual_max_abs_addr,
    output wire [31:0] unified_obs_output_reserved_addr,

    output wire [31:0] kernel_sel,
    output wire [31:0] mode
);

slam_accel_ctrl u_ctrl (
    .aclk(aclk),
    .aresetn(aresetn),
    .s_axi_awaddr(s_axi_awaddr[11:0]),
    .s_axi_awvalid(s_axi_awvalid),
    .s_axi_awready(s_axi_awready),
    .s_axi_wdata(s_axi_wdata),
    .s_axi_wstrb(s_axi_wstrb),
    .s_axi_wvalid(s_axi_wvalid),
    .s_axi_wready(s_axi_wready),
    .s_axi_bresp(s_axi_bresp),
    .s_axi_bvalid(s_axi_bvalid),
    .s_axi_bready(s_axi_bready),
    .s_axi_araddr(s_axi_araddr[11:0]),
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
    .unified_obs_error(unified_obs_error),
    .unified_obs_num_points(unified_obs_num_points),
    .unified_obs_scan_points_addr(unified_obs_scan_points_addr),
    .unified_obs_pose_addr(unified_obs_pose_addr),
    .unified_obs_map_header_addr(unified_obs_map_header_addr),
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

endmodule

