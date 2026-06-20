// SPDX-License-Identifier: MIT
//
// XDMA BAR-compatible AXI-Lite shim for the restore chain.
//
// The Orin XDMA driver probe path is sensitive to the first words visible at
// BAR0. Keep the diagnostic identity/scratch page at 0x0000 and expose
// slam_accel_ctrl under a separate 4 KB sub-window at 0x1000.

`timescale 1ns / 1ps

module xdma_restore_bar_shim_ctrl_wrapper (
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk CLK" *)
    (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF S_AXI, ASSOCIATED_RESET aresetn" *)
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

localparam [31:0] SHIM_MAGIC   = 32'h58444d41; // "XDMA"
localparam [31:0] SHIM_VERSION = 32'h00010000;
localparam [3:0]  CTRL_WINDOW  = 4'h1;

localparam [1:0] WR_IDLE      = 2'd0;
localparam [1:0] WR_CTRL_SEND = 2'd1;
localparam [1:0] WR_CTRL_RESP = 2'd2;

localparam [1:0] RD_IDLE      = 2'd0;
localparam [1:0] RD_CTRL_SEND = 2'd1;
localparam [1:0] RD_CTRL_RESP = 2'd2;

reg [1:0]  wr_state = WR_IDLE;
reg [1:0]  rd_state = RD_IDLE;
reg [31:0] awaddr_q = 32'h0;
reg [31:0] wdata_q = 32'h0;
reg [3:0]  wstrb_q = 4'h0;
reg        aw_seen = 1'b0;
reg        w_seen = 1'b0;
reg [1:0]  bresp_q = 2'b00;
reg        bvalid_q = 1'b0;
reg [31:0] rdata_q = 32'h0;
reg [1:0]  rresp_q = 2'b00;
reg        rvalid_q = 1'b0;
reg [31:0] scratch0 = 32'h0;
reg [31:0] scratch1 = 32'h0;
reg [31:0] araddr_q = 32'h0;

wire write_collect = (wr_state == WR_IDLE) && !bvalid_q;
assign s_axi_awready = write_collect && !aw_seen;
assign s_axi_wready  = write_collect && !w_seen;
assign s_axi_bresp   = bresp_q;
assign s_axi_bvalid  = bvalid_q;

assign s_axi_arready = (rd_state == RD_IDLE) && !rvalid_q;
assign s_axi_rdata   = rdata_q;
assign s_axi_rresp   = rresp_q;
assign s_axi_rvalid  = rvalid_q;

wire aw_fire = s_axi_awvalid && s_axi_awready;
wire w_fire  = s_axi_wvalid && s_axi_wready;
wire ar_fire = s_axi_arvalid && s_axi_arready;

wire [31:0] pending_awaddr = aw_seen ? awaddr_q : s_axi_awaddr;
wire [31:0] pending_wdata  = w_seen  ? wdata_q  : s_axi_wdata;
wire [3:0]  pending_wstrb  = w_seen  ? wstrb_q  : s_axi_wstrb;
wire        have_aw_next   = aw_seen || aw_fire;
wire        have_w_next    = w_seen || w_fire;
wire        pending_ctrl_write = (pending_awaddr[15:12] == CTRL_WINDOW);
wire        pending_ctrl_read  = (s_axi_araddr[15:12] == CTRL_WINDOW);

reg         ctrl_awvalid = 1'b0;
reg         ctrl_wvalid = 1'b0;
wire        ctrl_awready;
wire        ctrl_wready;
wire [1:0]  ctrl_bresp;
wire        ctrl_bvalid;
reg         ctrl_bready = 1'b0;
reg         ctrl_arvalid = 1'b0;
wire        ctrl_arready;
wire [31:0] ctrl_rdata;
wire [1:0]  ctrl_rresp;
wire        ctrl_rvalid;
reg         ctrl_rready = 1'b0;

wire [11:0] ctrl_awaddr = awaddr_q[11:0];
wire [11:0] ctrl_araddr = araddr_q[11:0];

integer byte_idx;

function [31:0] local_read_data;
    input [31:0] addr;
    begin
        case (addr[11:2])
            10'h000: local_read_data = SHIM_MAGIC;
            10'h001: local_read_data = SHIM_VERSION;
            10'h002: local_read_data = scratch0;
            10'h003: local_read_data = scratch1;
            default: local_read_data = 32'h0;
        endcase
    end
endfunction

task apply_local_write;
    input [31:0] addr;
    input [31:0] data;
    input [3:0]  strb;
    begin
        case (addr[11:2])
            10'h002: begin
                for (byte_idx = 0; byte_idx < 4; byte_idx = byte_idx + 1) begin
                    if (strb[byte_idx]) begin
                        scratch0[byte_idx*8 +: 8] <= data[byte_idx*8 +: 8];
                    end
                end
            end
            10'h003: begin
                for (byte_idx = 0; byte_idx < 4; byte_idx = byte_idx + 1) begin
                    if (strb[byte_idx]) begin
                        scratch1[byte_idx*8 +: 8] <= data[byte_idx*8 +: 8];
                    end
                end
            end
            default: begin
            end
        endcase
    end
endtask

always @(posedge aclk) begin
    if (!aresetn) begin
        wr_state <= WR_IDLE;
        rd_state <= RD_IDLE;
        awaddr_q <= 32'h0;
        wdata_q <= 32'h0;
        wstrb_q <= 4'h0;
        aw_seen <= 1'b0;
        w_seen <= 1'b0;
        bresp_q <= 2'b00;
        bvalid_q <= 1'b0;
        rdata_q <= 32'h0;
        rresp_q <= 2'b00;
        rvalid_q <= 1'b0;
        scratch0 <= 32'h0;
        scratch1 <= 32'h0;
        araddr_q <= 32'h0;
        ctrl_awvalid <= 1'b0;
        ctrl_wvalid <= 1'b0;
        ctrl_bready <= 1'b0;
        ctrl_arvalid <= 1'b0;
        ctrl_rready <= 1'b0;
    end else begin
        ctrl_bready <= 1'b0;
        ctrl_rready <= 1'b0;

        if (bvalid_q && s_axi_bready) begin
            bvalid_q <= 1'b0;
        end
        if (rvalid_q && s_axi_rready) begin
            rvalid_q <= 1'b0;
        end

        if (aw_fire) begin
            awaddr_q <= s_axi_awaddr;
            aw_seen <= 1'b1;
        end
        if (w_fire) begin
            wdata_q <= s_axi_wdata;
            wstrb_q <= s_axi_wstrb;
            w_seen <= 1'b1;
        end

        case (wr_state)
            WR_IDLE: begin
                if (!bvalid_q && have_aw_next && have_w_next) begin
                    awaddr_q <= pending_awaddr;
                    wdata_q <= pending_wdata;
                    wstrb_q <= pending_wstrb;
                    if (pending_ctrl_write) begin
                        ctrl_awvalid <= 1'b1;
                        ctrl_wvalid <= 1'b1;
                        wr_state <= WR_CTRL_SEND;
                    end else begin
                        apply_local_write(pending_awaddr, pending_wdata, pending_wstrb);
                        aw_seen <= 1'b0;
                        w_seen <= 1'b0;
                        bresp_q <= 2'b00;
                        bvalid_q <= 1'b1;
                    end
                end
            end
            WR_CTRL_SEND: begin
                if (ctrl_awvalid && ctrl_awready) begin
                    ctrl_awvalid <= 1'b0;
                end
                if (ctrl_wvalid && ctrl_wready) begin
                    ctrl_wvalid <= 1'b0;
                end
                if ((!ctrl_awvalid || ctrl_awready) && (!ctrl_wvalid || ctrl_wready)) begin
                    wr_state <= WR_CTRL_RESP;
                end
            end
            WR_CTRL_RESP: begin
                ctrl_bready <= !bvalid_q;
                if (ctrl_bvalid && !bvalid_q) begin
                    aw_seen <= 1'b0;
                    w_seen <= 1'b0;
                    bresp_q <= ctrl_bresp;
                    bvalid_q <= 1'b1;
                    wr_state <= WR_IDLE;
                end
            end
            default: begin
                wr_state <= WR_IDLE;
            end
        endcase

        case (rd_state)
            RD_IDLE: begin
                if (ar_fire) begin
                    araddr_q <= s_axi_araddr;
                    if (pending_ctrl_read) begin
                        ctrl_arvalid <= 1'b1;
                        rd_state <= RD_CTRL_SEND;
                    end else begin
                        rdata_q <= local_read_data(s_axi_araddr);
                        rresp_q <= 2'b00;
                        rvalid_q <= 1'b1;
                    end
                end
            end
            RD_CTRL_SEND: begin
                if (ctrl_arvalid && ctrl_arready) begin
                    ctrl_arvalid <= 1'b0;
                    rd_state <= RD_CTRL_RESP;
                end
            end
            RD_CTRL_RESP: begin
                ctrl_rready <= !rvalid_q;
                if (ctrl_rvalid && !rvalid_q) begin
                    rdata_q <= ctrl_rdata;
                    rresp_q <= ctrl_rresp;
                    rvalid_q <= 1'b1;
                    rd_state <= RD_IDLE;
                end
            end
            default: begin
                rd_state <= RD_IDLE;
            end
        endcase
    end
end

slam_accel_ctrl u_ctrl (
    .aclk(aclk),
    .aresetn(aresetn),
    .s_axi_awaddr(ctrl_awaddr),
    .s_axi_awvalid(ctrl_awvalid),
    .s_axi_awready(ctrl_awready),
    .s_axi_wdata(wdata_q),
    .s_axi_wstrb(wstrb_q),
    .s_axi_wvalid(ctrl_wvalid),
    .s_axi_wready(ctrl_wready),
    .s_axi_bresp(ctrl_bresp),
    .s_axi_bvalid(ctrl_bvalid),
    .s_axi_bready(ctrl_bready),
    .s_axi_araddr(ctrl_araddr),
    .s_axi_arvalid(ctrl_arvalid),
    .s_axi_arready(ctrl_arready),
    .s_axi_rdata(ctrl_rdata),
    .s_axi_rresp(ctrl_rresp),
    .s_axi_rvalid(ctrl_rvalid),
    .s_axi_rready(ctrl_rready),
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
