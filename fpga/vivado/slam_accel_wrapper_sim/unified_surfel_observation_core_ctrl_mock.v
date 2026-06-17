// SPDX-License-Identifier: MIT
//
// Control-plane mock for the generated HLS observation IP. This module models
// only ap_ctrl_hs and direct scalar address ports for wrapper-level simulation.

`timescale 1ns / 1ps

module unified_surfel_observation_core_ctrl_mock #(
    parameter integer DONE_DELAY_CYCLES = 4
) (
    input  wire        ap_clk,
    input  wire        ap_rst_n,
    input  wire        ap_start,
    output reg         ap_done,
    output wire        ap_idle,
    output wire        ap_ready,

    input  wire [31:0] num_points,
    input  wire [31:0] scan_points,
    input  wire [31:0] pose,
    input  wire [31:0] map_header,
    input  wire [31:0] active_blocks,
    input  wire [31:0] obs_cells,
    input  wire [31:0] output_h_upper,
    input  wire [31:0] output_b,
    input  wire [31:0] output_valid_count,
    input  wire [31:0] output_reject_count,
    input  wire [31:0] output_miss_count,
    input  wire [31:0] output_flags,
    input  wire [31:0] output_residual_sum,
    input  wire [31:0] output_residual_abs_sum,
    input  wire [31:0] output_residual_max_abs,
    input  wire [31:0] output_reserved,
    output wire [31:0] activity_sink
);

reg busy;
reg [7:0] countdown;

reg [31:0] captured_num_points;
reg [31:0] captured_scan_points;
reg [31:0] captured_pose;
reg [31:0] captured_map_header;
reg [31:0] captured_active_blocks;
reg [31:0] captured_obs_cells;
reg [31:0] captured_output_h_upper;
reg [31:0] captured_output_b;
reg [31:0] captured_output_valid_count;
reg [31:0] captured_output_reject_count;
reg [31:0] captured_output_miss_count;
reg [31:0] captured_output_flags;
reg [31:0] captured_output_residual_sum;
reg [31:0] captured_output_residual_abs_sum;
reg [31:0] captured_output_residual_max_abs;
reg [31:0] captured_output_reserved;

assign ap_idle = !busy;
assign ap_ready = !busy;
assign activity_sink = captured_num_points ^
                       captured_scan_points ^
                       captured_pose ^
                       captured_map_header ^
                       captured_active_blocks ^
                       captured_obs_cells ^
                       captured_output_h_upper ^
                       captured_output_b ^
                       captured_output_valid_count ^
                       captured_output_reject_count ^
                       captured_output_miss_count ^
                       captured_output_flags ^
                       captured_output_residual_sum ^
                       captured_output_residual_abs_sum ^
                       captured_output_residual_max_abs ^
                       captured_output_reserved;

always @(posedge ap_clk) begin
    if (!ap_rst_n) begin
        busy <= 1'b0;
        countdown <= 8'd0;
        ap_done <= 1'b0;
        captured_num_points <= 32'd0;
        captured_scan_points <= 32'd0;
        captured_pose <= 32'd0;
        captured_map_header <= 32'd0;
        captured_active_blocks <= 32'd0;
        captured_obs_cells <= 32'd0;
        captured_output_h_upper <= 32'd0;
        captured_output_b <= 32'd0;
        captured_output_valid_count <= 32'd0;
        captured_output_reject_count <= 32'd0;
        captured_output_miss_count <= 32'd0;
        captured_output_flags <= 32'd0;
        captured_output_residual_sum <= 32'd0;
        captured_output_residual_abs_sum <= 32'd0;
        captured_output_residual_max_abs <= 32'd0;
        captured_output_reserved <= 32'd0;
    end else begin
        ap_done <= 1'b0;
        if (!busy && ap_start) begin
            busy <= 1'b1;
            countdown <= DONE_DELAY_CYCLES[7:0];
            captured_num_points <= num_points;
            captured_scan_points <= scan_points;
            captured_pose <= pose;
            captured_map_header <= map_header;
            captured_active_blocks <= active_blocks;
            captured_obs_cells <= obs_cells;
            captured_output_h_upper <= output_h_upper;
            captured_output_b <= output_b;
            captured_output_valid_count <= output_valid_count;
            captured_output_reject_count <= output_reject_count;
            captured_output_miss_count <= output_miss_count;
            captured_output_flags <= output_flags;
            captured_output_residual_sum <= output_residual_sum;
            captured_output_residual_abs_sum <= output_residual_abs_sum;
            captured_output_residual_max_abs <= output_residual_max_abs;
            captured_output_reserved <= output_reserved;
        end else if (busy) begin
            if (countdown <= 8'd1) begin
                busy <= 1'b0;
                countdown <= 8'd0;
                ap_done <= 1'b1;
            end else begin
                countdown <= countdown - 8'd1;
            end
        end
    end
end

endmodule
