// SPDX-License-Identifier: MIT
//
// Single AXI-Lite control point for Lightning-LM FPGA accelerators.
// Interface convergence version: register bank + command decoder +
// dispatch FSM with direct ap_ctrl_hs wiring for the unified observation HLS IP.

`timescale 1ns / 1ps

module slam_accel_ctrl #(
    parameter integer AXI_ADDR_WIDTH = 12,
    parameter integer AXI_DATA_WIDTH = 32
) (
    input  wire                          aclk,
    input  wire                          aresetn,

    input  wire [AXI_ADDR_WIDTH-1:0]     s_axi_awaddr,
    input  wire                          s_axi_awvalid,
    output reg                           s_axi_awready,
    input  wire [AXI_DATA_WIDTH-1:0]     s_axi_wdata,
    input  wire [(AXI_DATA_WIDTH/8)-1:0] s_axi_wstrb,
    input  wire                          s_axi_wvalid,
    output reg                           s_axi_wready,
    output reg  [1:0]                    s_axi_bresp,
    output reg                           s_axi_bvalid,
    input  wire                          s_axi_bready,

    input  wire [AXI_ADDR_WIDTH-1:0]     s_axi_araddr,
    input  wire                          s_axi_arvalid,
    output reg                           s_axi_arready,
    output reg  [AXI_DATA_WIDTH-1:0]     s_axi_rdata,
    output reg  [1:0]                    s_axi_rresp,
    output reg                           s_axi_rvalid,
    input  wire                          s_axi_rready,

    output reg                           unified_obs_ap_start,
    input  wire                          unified_obs_ap_idle,
    input  wire                          unified_obs_ap_ready,
    input  wire                          unified_obs_ap_done,
    input  wire [31:0]                   unified_obs_error,

    output wire [31:0]                   unified_obs_num_points,
    output wire [31:0]                   unified_obs_scan_points_addr,
    output wire [31:0]                   unified_obs_pose_addr,
    output wire [31:0]                   unified_obs_map_header_addr,
    output wire [31:0]                   unified_obs_params_addr,
    output wire [31:0]                   unified_obs_active_blocks_addr,
    output wire [31:0]                   unified_obs_obs_cells_addr,
    output wire [31:0]                   unified_obs_output_addr,
    output wire [31:0]                   unified_obs_output_h_upper_addr,
    output wire [31:0]                   unified_obs_output_b_addr,
    output wire [31:0]                   unified_obs_output_valid_count_addr,
    output wire [31:0]                   unified_obs_output_reject_count_addr,
    output wire [31:0]                   unified_obs_output_miss_count_addr,
    output wire [31:0]                   unified_obs_output_flags_addr,
    output wire [31:0]                   unified_obs_output_residual_sum_addr,
    output wire [31:0]                   unified_obs_output_residual_abs_sum_addr,
    output wire [31:0]                   unified_obs_output_residual_max_abs_addr,
    output wire [31:0]                   unified_obs_output_reserved_addr,

    output wire [31:0]                   kernel_sel,
    output wire [31:0]                   mode
);

localparam [31:0] VERSION_VALUE = 32'h0002_0002;

localparam [11:0] REG_VERSION           = 12'h000;
localparam [11:0] REG_CONTROL           = 12'h004;
localparam [11:0] REG_STATUS            = 12'h008;
localparam [11:0] REG_KERNEL_SEL        = 12'h00c;
localparam [11:0] REG_MODE              = 12'h010;
localparam [11:0] REG_ERROR             = 12'h014;
localparam [11:0] REG_CYCLE_COUNT       = 12'h018;
localparam [11:0] REG_RUN_COUNT         = 12'h01c;
localparam [11:0] REG_SCAN_ADDR_LO      = 12'h020;
localparam [11:0] REG_SCAN_ADDR_HI      = 12'h024;
localparam [11:0] REG_SCAN_COUNT        = 12'h028;
localparam [11:0] REG_POSE_ADDR_LO      = 12'h02c;
localparam [11:0] REG_POSE_ADDR_HI      = 12'h030;
localparam [11:0] REG_MAP_HEADER_ADDR_LO = 12'h034;
localparam [11:0] REG_MAP_HEADER_ADDR_HI = 12'h038;
localparam [11:0] REG_ACTIVE_BLOCKS_ADDR_LO = 12'h03c;
localparam [11:0] REG_ACTIVE_BLOCKS_ADDR_HI = 12'h040;
localparam [11:0] REG_OBS_CELLS_ADDR_LO = 12'h044;
localparam [11:0] REG_OBS_CELLS_ADDR_HI = 12'h048;
localparam [11:0] REG_OUT_ADDR_LO       = 12'h04c;
localparam [11:0] REG_OUT_ADDR_HI       = 12'h050;
localparam [11:0] REG_PARAMS_ADDR_LO    = 12'h054;
localparam [11:0] REG_PARAMS_ADDR_HI    = 12'h058;

localparam [31:0] KERNEL_UNIFIED_OBSERVATION = 32'd4;

localparam [31:0] ERR_UNSUPPORTED_KERNEL = 32'h0000_0001;
localparam [31:0] ERR_ADDR_HI_NONZERO    = 32'h0000_0003;

localparam [2:0] FSM_IDLE     = 3'd0;
localparam [2:0] FSM_DISPATCH = 3'd1;
localparam [2:0] FSM_WAIT     = 3'd2;
localparam [2:0] FSM_DONE     = 3'd3;
localparam [2:0] FSM_ERROR    = 3'd4;

reg [2:0]  state;
reg [31:0] kernel_sel_reg;
reg [31:0] mode_reg;
reg [31:0] error_reg;
reg [31:0] cycle_count_reg;
reg [31:0] run_count_reg;
reg [31:0] scan_addr_lo_reg;
reg [31:0] scan_addr_hi_reg;
reg [31:0] scan_count_reg;
reg [31:0] pose_addr_lo_reg;
reg [31:0] pose_addr_hi_reg;
reg [31:0] map_header_addr_lo_reg;
reg [31:0] map_header_addr_hi_reg;
reg [31:0] active_blocks_addr_lo_reg;
reg [31:0] active_blocks_addr_hi_reg;
reg [31:0] obs_cells_addr_lo_reg;
reg [31:0] obs_cells_addr_hi_reg;
reg [31:0] out_addr_lo_reg;
reg [31:0] out_addr_hi_reg;
reg [31:0] params_addr_lo_reg;
reg [31:0] params_addr_hi_reg;

reg cmd_start;

assign kernel_sel = kernel_sel_reg;
assign mode = mode_reg;
assign unified_obs_num_points = scan_count_reg;
assign unified_obs_scan_points_addr = scan_addr_lo_reg;
assign unified_obs_pose_addr = pose_addr_lo_reg;
assign unified_obs_map_header_addr = map_header_addr_lo_reg;
assign unified_obs_params_addr = params_addr_lo_reg;
assign unified_obs_active_blocks_addr = active_blocks_addr_lo_reg;
assign unified_obs_obs_cells_addr = obs_cells_addr_lo_reg;
assign unified_obs_output_addr = out_addr_lo_reg;
assign unified_obs_output_h_upper_addr = out_addr_lo_reg;
assign unified_obs_output_b_addr = out_addr_lo_reg + 32'd168;
assign unified_obs_output_valid_count_addr = out_addr_lo_reg + 32'd216;
assign unified_obs_output_reject_count_addr = out_addr_lo_reg + 32'd220;
assign unified_obs_output_miss_count_addr = out_addr_lo_reg + 32'd224;
assign unified_obs_output_flags_addr = out_addr_lo_reg + 32'd228;
assign unified_obs_output_residual_sum_addr = out_addr_lo_reg + 32'd232;
assign unified_obs_output_residual_abs_sum_addr = out_addr_lo_reg + 32'd240;
assign unified_obs_output_residual_max_abs_addr = out_addr_lo_reg + 32'd248;
assign unified_obs_output_reserved_addr = out_addr_lo_reg + 32'd256;

function [31:0] apply_wstrb;
    input [31:0] old_value;
    input [31:0] new_value;
    input [3:0]  wstrb;
    begin
        apply_wstrb = old_value;
        if (wstrb[0]) apply_wstrb[7:0]   = new_value[7:0];
        if (wstrb[1]) apply_wstrb[15:8]  = new_value[15:8];
        if (wstrb[2]) apply_wstrb[23:16] = new_value[23:16];
        if (wstrb[3]) apply_wstrb[31:24] = new_value[31:24];
    end
endfunction

wire write_fire = s_axi_awvalid && s_axi_wvalid && !s_axi_bvalid;
wire read_fire = s_axi_arvalid && !s_axi_rvalid;
wire [11:0] write_addr = {s_axi_awaddr[11:2], 2'b00};
wire [11:0] read_addr = {s_axi_araddr[11:2], 2'b00};

wire status_idle = (state == FSM_IDLE);
wire status_busy = (state == FSM_DISPATCH) || (state == FSM_WAIT);
wire status_done = (state == FSM_DONE);
wire status_error = (state == FSM_ERROR);

wire any_addr_hi_nonzero = (scan_addr_hi_reg != 32'd0) ||
                           (pose_addr_hi_reg != 32'd0) ||
                           (map_header_addr_hi_reg != 32'd0) ||
                           (active_blocks_addr_hi_reg != 32'd0) ||
                           (obs_cells_addr_hi_reg != 32'd0) ||
                           (out_addr_hi_reg != 32'd0) ||
                           (params_addr_hi_reg != 32'd0);

always @(posedge aclk) begin
    if (!aresetn) begin
        s_axi_awready <= 1'b0;
        s_axi_wready <= 1'b0;
        s_axi_bresp <= 2'b00;
        s_axi_bvalid <= 1'b0;
        s_axi_arready <= 1'b0;
        s_axi_rdata <= 32'd0;
        s_axi_rresp <= 2'b00;
        s_axi_rvalid <= 1'b0;

        unified_obs_ap_start <= 1'b0;
        state <= FSM_IDLE;
        kernel_sel_reg <= KERNEL_UNIFIED_OBSERVATION;
        mode_reg <= 32'd1;
        error_reg <= 32'd0;
        cycle_count_reg <= 32'd0;
        run_count_reg <= 32'd0;
        scan_addr_lo_reg <= 32'd0;
        scan_addr_hi_reg <= 32'd0;
        scan_count_reg <= 32'd0;
        pose_addr_lo_reg <= 32'd0;
        pose_addr_hi_reg <= 32'd0;
        map_header_addr_lo_reg <= 32'd0;
        map_header_addr_hi_reg <= 32'd0;
        active_blocks_addr_lo_reg <= 32'd0;
        active_blocks_addr_hi_reg <= 32'd0;
        obs_cells_addr_lo_reg <= 32'd0;
        obs_cells_addr_hi_reg <= 32'd0;
        out_addr_lo_reg <= 32'd0;
        out_addr_hi_reg <= 32'd0;
        params_addr_lo_reg <= 32'd0;
        params_addr_hi_reg <= 32'd0;
        cmd_start <= 1'b0;
    end else begin
        s_axi_awready <= write_fire;
        s_axi_wready <= write_fire;
        s_axi_arready <= read_fire;
        unified_obs_ap_start <= 1'b0;

        if (s_axi_bvalid && s_axi_bready) begin
            s_axi_bvalid <= 1'b0;
        end
        if (s_axi_rvalid && s_axi_rready) begin
            s_axi_rvalid <= 1'b0;
        end

        if (write_fire) begin
            s_axi_bresp <= 2'b00;
            s_axi_bvalid <= 1'b1;
            case (write_addr)
                REG_CONTROL: begin
                    if (s_axi_wdata[0]) begin
                        cmd_start <= 1'b1;
                    end
                    if (s_axi_wdata[1]) begin
                        error_reg <= 32'd0;
                        if (state == FSM_DONE || state == FSM_ERROR) begin
                            state <= FSM_IDLE;
                        end
                    end
                end
                REG_KERNEL_SEL: kernel_sel_reg <= apply_wstrb(kernel_sel_reg, s_axi_wdata, s_axi_wstrb);
                REG_MODE: mode_reg <= apply_wstrb(mode_reg, s_axi_wdata, s_axi_wstrb);
                REG_CYCLE_COUNT: cycle_count_reg <= apply_wstrb(cycle_count_reg, s_axi_wdata, s_axi_wstrb);
                REG_RUN_COUNT: run_count_reg <= apply_wstrb(run_count_reg, s_axi_wdata, s_axi_wstrb);
                REG_SCAN_ADDR_LO: scan_addr_lo_reg <= apply_wstrb(scan_addr_lo_reg, s_axi_wdata, s_axi_wstrb);
                REG_SCAN_ADDR_HI: scan_addr_hi_reg <= apply_wstrb(scan_addr_hi_reg, s_axi_wdata, s_axi_wstrb);
                REG_SCAN_COUNT: scan_count_reg <= apply_wstrb(scan_count_reg, s_axi_wdata, s_axi_wstrb);
                REG_POSE_ADDR_LO: pose_addr_lo_reg <= apply_wstrb(pose_addr_lo_reg, s_axi_wdata, s_axi_wstrb);
                REG_POSE_ADDR_HI: pose_addr_hi_reg <= apply_wstrb(pose_addr_hi_reg, s_axi_wdata, s_axi_wstrb);
                REG_MAP_HEADER_ADDR_LO:
                    map_header_addr_lo_reg <= apply_wstrb(map_header_addr_lo_reg, s_axi_wdata, s_axi_wstrb);
                REG_MAP_HEADER_ADDR_HI:
                    map_header_addr_hi_reg <= apply_wstrb(map_header_addr_hi_reg, s_axi_wdata, s_axi_wstrb);
                REG_ACTIVE_BLOCKS_ADDR_LO:
                    active_blocks_addr_lo_reg <= apply_wstrb(active_blocks_addr_lo_reg, s_axi_wdata, s_axi_wstrb);
                REG_ACTIVE_BLOCKS_ADDR_HI:
                    active_blocks_addr_hi_reg <= apply_wstrb(active_blocks_addr_hi_reg, s_axi_wdata, s_axi_wstrb);
                REG_OBS_CELLS_ADDR_LO:
                    obs_cells_addr_lo_reg <= apply_wstrb(obs_cells_addr_lo_reg, s_axi_wdata, s_axi_wstrb);
                REG_OBS_CELLS_ADDR_HI:
                    obs_cells_addr_hi_reg <= apply_wstrb(obs_cells_addr_hi_reg, s_axi_wdata, s_axi_wstrb);
                REG_OUT_ADDR_LO: out_addr_lo_reg <= apply_wstrb(out_addr_lo_reg, s_axi_wdata, s_axi_wstrb);
                REG_OUT_ADDR_HI: out_addr_hi_reg <= apply_wstrb(out_addr_hi_reg, s_axi_wdata, s_axi_wstrb);
                REG_PARAMS_ADDR_LO: params_addr_lo_reg <= apply_wstrb(params_addr_lo_reg, s_axi_wdata, s_axi_wstrb);
                REG_PARAMS_ADDR_HI: params_addr_hi_reg <= apply_wstrb(params_addr_hi_reg, s_axi_wdata, s_axi_wstrb);
                default: begin
                    s_axi_bresp <= 2'b10;
                end
            endcase
        end

        if (read_fire) begin
            s_axi_rresp <= 2'b00;
            s_axi_rvalid <= 1'b1;
            case (read_addr)
                REG_VERSION: s_axi_rdata <= VERSION_VALUE;
                REG_CONTROL: s_axi_rdata <= 32'd0;
                REG_STATUS: s_axi_rdata <= {21'd0, unified_obs_ap_ready, unified_obs_ap_idle, unified_obs_ap_done,
                                            4'd0, status_error, status_done, status_busy, status_idle};
                REG_KERNEL_SEL: s_axi_rdata <= kernel_sel_reg;
                REG_MODE: s_axi_rdata <= mode_reg;
                REG_ERROR: s_axi_rdata <= error_reg;
                REG_CYCLE_COUNT: s_axi_rdata <= cycle_count_reg;
                REG_RUN_COUNT: s_axi_rdata <= run_count_reg;
                REG_SCAN_ADDR_LO: s_axi_rdata <= scan_addr_lo_reg;
                REG_SCAN_ADDR_HI: s_axi_rdata <= scan_addr_hi_reg;
                REG_SCAN_COUNT: s_axi_rdata <= scan_count_reg;
                REG_POSE_ADDR_LO: s_axi_rdata <= pose_addr_lo_reg;
                REG_POSE_ADDR_HI: s_axi_rdata <= pose_addr_hi_reg;
                REG_MAP_HEADER_ADDR_LO: s_axi_rdata <= map_header_addr_lo_reg;
                REG_MAP_HEADER_ADDR_HI: s_axi_rdata <= map_header_addr_hi_reg;
                REG_ACTIVE_BLOCKS_ADDR_LO: s_axi_rdata <= active_blocks_addr_lo_reg;
                REG_ACTIVE_BLOCKS_ADDR_HI: s_axi_rdata <= active_blocks_addr_hi_reg;
                REG_OBS_CELLS_ADDR_LO: s_axi_rdata <= obs_cells_addr_lo_reg;
                REG_OBS_CELLS_ADDR_HI: s_axi_rdata <= obs_cells_addr_hi_reg;
                REG_OUT_ADDR_LO: s_axi_rdata <= out_addr_lo_reg;
                REG_OUT_ADDR_HI: s_axi_rdata <= out_addr_hi_reg;
                REG_PARAMS_ADDR_LO: s_axi_rdata <= params_addr_lo_reg;
                REG_PARAMS_ADDR_HI: s_axi_rdata <= params_addr_hi_reg;
                default: begin
                    s_axi_rdata <= 32'd0;
                    s_axi_rresp <= 2'b10;
                end
            endcase
        end

        if (state == FSM_DISPATCH || state == FSM_WAIT) begin
            cycle_count_reg <= cycle_count_reg + 32'd1;
        end

        case (state)
            FSM_IDLE: begin
                if (cmd_start) begin
                    cmd_start <= 1'b0;
                    error_reg <= 32'd0;
                    if (kernel_sel_reg != KERNEL_UNIFIED_OBSERVATION) begin
                        error_reg <= ERR_UNSUPPORTED_KERNEL;
                        state <= FSM_ERROR;
                    end else if (any_addr_hi_nonzero) begin
                        error_reg <= ERR_ADDR_HI_NONZERO;
                        state <= FSM_ERROR;
                    end else begin
                        state <= FSM_DISPATCH;
                    end
                end
            end
            FSM_DISPATCH: begin
                unified_obs_ap_start <= 1'b1;
                if (unified_obs_ap_ready) begin
                    run_count_reg <= run_count_reg + 32'd1;
                    state <= FSM_WAIT;
                end
            end
            FSM_WAIT: begin
                if (unified_obs_error != 32'd0) begin
                    error_reg <= unified_obs_error;
                    state <= FSM_ERROR;
                end else if (unified_obs_ap_done) begin
                    state <= FSM_DONE;
                end
            end
            FSM_DONE: begin
                if (cmd_start) begin
                    cmd_start <= 1'b0;
                    if (kernel_sel_reg != KERNEL_UNIFIED_OBSERVATION) begin
                        error_reg <= ERR_UNSUPPORTED_KERNEL;
                        state <= FSM_ERROR;
                    end else if (any_addr_hi_nonzero) begin
                        error_reg <= ERR_ADDR_HI_NONZERO;
                        state <= FSM_ERROR;
                    end else begin
                        state <= FSM_DISPATCH;
                    end
                end
            end
            FSM_ERROR: begin
                if (cmd_start) begin
                    cmd_start <= 1'b0;
                end
            end
            default: begin
                state <= FSM_ERROR;
                error_reg <= 32'hffff_ffff;
            end
        endcase
    end
end

endmodule
