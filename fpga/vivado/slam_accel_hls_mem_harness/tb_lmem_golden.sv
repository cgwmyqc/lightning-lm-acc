// SPDX-License-Identifier: MIT

`timescale 1ns / 1ps

`include "golden_frame_000001_params.vh"

`define AXI_WIRES(P, DW) \
wire P``_AWVALID; \
wire P``_AWREADY; \
wire [31:0] P``_AWADDR; \
wire [0:0] P``_AWID; \
wire [7:0] P``_AWLEN; \
wire [2:0] P``_AWSIZE; \
wire [1:0] P``_AWBURST; \
wire [1:0] P``_AWLOCK; \
wire [3:0] P``_AWCACHE; \
wire [2:0] P``_AWPROT; \
wire [3:0] P``_AWQOS; \
wire [3:0] P``_AWREGION; \
wire [0:0] P``_AWUSER; \
wire P``_WVALID; \
wire P``_WREADY; \
wire [(DW)-1:0] P``_WDATA; \
wire [((DW)/8)-1:0] P``_WSTRB; \
wire P``_WLAST; \
wire [0:0] P``_WID; \
wire [0:0] P``_WUSER; \
wire P``_ARVALID; \
wire P``_ARREADY; \
wire [31:0] P``_ARADDR; \
wire [0:0] P``_ARID; \
wire [7:0] P``_ARLEN; \
wire [2:0] P``_ARSIZE; \
wire [1:0] P``_ARBURST; \
wire [1:0] P``_ARLOCK; \
wire [3:0] P``_ARCACHE; \
wire [2:0] P``_ARPROT; \
wire [3:0] P``_ARQOS; \
wire [3:0] P``_ARREGION; \
wire [0:0] P``_ARUSER; \
wire P``_RVALID; \
wire P``_RREADY; \
wire [(DW)-1:0] P``_RDATA; \
wire P``_RLAST; \
wire [0:0] P``_RID; \
wire [0:0] P``_RUSER; \
wire [1:0] P``_RRESP; \
wire P``_BVALID; \
wire P``_BREADY; \
wire [1:0] P``_BRESP; \
wire [0:0] P``_BID; \
wire [0:0] P``_BUSER

`define AXI_MEM(P, DW, BYTES, ARG) \
axi_memory_model #(.DATA_WIDTH(DW), .MEM_BYTES(BYTES), .INIT_PLUSARG(ARG)) P``_mem ( \
    .aclk(aclk), .aresetn(aresetn), \
    .s_axi_awvalid(P``_AWVALID), .s_axi_awready(P``_AWREADY), .s_axi_awaddr(P``_AWADDR), \
    .s_axi_awid(P``_AWID), .s_axi_awlen(P``_AWLEN), .s_axi_awsize(P``_AWSIZE), \
    .s_axi_awburst(P``_AWBURST), .s_axi_awlock(P``_AWLOCK), .s_axi_awcache(P``_AWCACHE), \
    .s_axi_awprot(P``_AWPROT), .s_axi_awqos(P``_AWQOS), .s_axi_awregion(P``_AWREGION), \
    .s_axi_awuser(P``_AWUSER), .s_axi_wvalid(P``_WVALID), .s_axi_wready(P``_WREADY), \
    .s_axi_wdata(P``_WDATA), .s_axi_wstrb(P``_WSTRB), .s_axi_wlast(P``_WLAST), \
    .s_axi_wid(P``_WID), .s_axi_wuser(P``_WUSER), .s_axi_bvalid(P``_BVALID), \
    .s_axi_bready(P``_BREADY), .s_axi_bresp(P``_BRESP), .s_axi_bid(P``_BID), \
    .s_axi_buser(P``_BUSER), .s_axi_arvalid(P``_ARVALID), .s_axi_arready(P``_ARREADY), \
    .s_axi_araddr(P``_ARADDR), .s_axi_arid(P``_ARID), .s_axi_arlen(P``_ARLEN), \
    .s_axi_arsize(P``_ARSIZE), .s_axi_arburst(P``_ARBURST), .s_axi_arlock(P``_ARLOCK), \
    .s_axi_arcache(P``_ARCACHE), .s_axi_arprot(P``_ARPROT), .s_axi_arqos(P``_ARQOS), \
    .s_axi_arregion(P``_ARREGION), .s_axi_aruser(P``_ARUSER), .s_axi_rvalid(P``_RVALID), \
    .s_axi_rready(P``_RREADY), .s_axi_rdata(P``_RDATA), .s_axi_rlast(P``_RLAST), \
    .s_axi_rid(P``_RID), .s_axi_ruser(P``_RUSER), .s_axi_rresp(P``_RRESP))

`define HLS_AXI_CONN(N, P) \
    .m_axi_``N``_AWVALID(P``_AWVALID), .m_axi_``N``_AWREADY(P``_AWREADY), \
    .m_axi_``N``_AWADDR(P``_AWADDR), .m_axi_``N``_AWID(P``_AWID), \
    .m_axi_``N``_AWLEN(P``_AWLEN), .m_axi_``N``_AWSIZE(P``_AWSIZE), \
    .m_axi_``N``_AWBURST(P``_AWBURST), .m_axi_``N``_AWLOCK(P``_AWLOCK), \
    .m_axi_``N``_AWCACHE(P``_AWCACHE), .m_axi_``N``_AWPROT(P``_AWPROT), \
    .m_axi_``N``_AWQOS(P``_AWQOS), .m_axi_``N``_AWREGION(P``_AWREGION), \
    .m_axi_``N``_AWUSER(P``_AWUSER), .m_axi_``N``_WVALID(P``_WVALID), \
    .m_axi_``N``_WREADY(P``_WREADY), .m_axi_``N``_WDATA(P``_WDATA), \
    .m_axi_``N``_WSTRB(P``_WSTRB), .m_axi_``N``_WLAST(P``_WLAST), \
    .m_axi_``N``_WID(P``_WID), .m_axi_``N``_WUSER(P``_WUSER), \
    .m_axi_``N``_ARVALID(P``_ARVALID), .m_axi_``N``_ARREADY(P``_ARREADY), \
    .m_axi_``N``_ARADDR(P``_ARADDR), .m_axi_``N``_ARID(P``_ARID), \
    .m_axi_``N``_ARLEN(P``_ARLEN), .m_axi_``N``_ARSIZE(P``_ARSIZE), \
    .m_axi_``N``_ARBURST(P``_ARBURST), .m_axi_``N``_ARLOCK(P``_ARLOCK), \
    .m_axi_``N``_ARCACHE(P``_ARCACHE), .m_axi_``N``_ARPROT(P``_ARPROT), \
    .m_axi_``N``_ARQOS(P``_ARQOS), .m_axi_``N``_ARREGION(P``_ARREGION), \
    .m_axi_``N``_ARUSER(P``_ARUSER), .m_axi_``N``_RVALID(P``_RVALID), \
    .m_axi_``N``_RREADY(P``_RREADY), .m_axi_``N``_RDATA(P``_RDATA), \
    .m_axi_``N``_RLAST(P``_RLAST), .m_axi_``N``_RID(P``_RID), \
    .m_axi_``N``_RUSER(P``_RUSER), .m_axi_``N``_RRESP(P``_RRESP), \
    .m_axi_``N``_BVALID(P``_BVALID), .m_axi_``N``_BREADY(P``_BREADY), \
    .m_axi_``N``_BRESP(P``_BRESP), .m_axi_``N``_BID(P``_BID), \
    .m_axi_``N``_BUSER(P``_BUSER)

module tb_lmem_golden;

localparam [11:0] REG_VERSION               = 12'h000;
localparam [11:0] REG_CONTROL               = 12'h004;
localparam [11:0] REG_STATUS                = 12'h008;
localparam [11:0] REG_KERNEL_SEL            = 12'h00c;
localparam [11:0] REG_MODE                  = 12'h010;
localparam [11:0] REG_ERROR                 = 12'h014;
localparam [11:0] REG_RUN_COUNT             = 12'h01c;
localparam [11:0] REG_SCAN_ADDR_LO          = 12'h020;
localparam [11:0] REG_SCAN_ADDR_HI          = 12'h024;
localparam [11:0] REG_SCAN_COUNT            = 12'h028;
localparam [11:0] REG_POSE_ADDR_LO          = 12'h02c;
localparam [11:0] REG_POSE_ADDR_HI          = 12'h030;
localparam [11:0] REG_MAP_HEADER_ADDR_LO    = 12'h034;
localparam [11:0] REG_MAP_HEADER_ADDR_HI    = 12'h038;
localparam [11:0] REG_ACTIVE_BLOCKS_ADDR_LO = 12'h03c;
localparam [11:0] REG_ACTIVE_BLOCKS_ADDR_HI = 12'h040;
localparam [11:0] REG_OBS_CELLS_ADDR_LO     = 12'h044;
localparam [11:0] REG_OBS_CELLS_ADDR_HI     = 12'h048;
localparam [11:0] REG_OUT_ADDR_LO           = 12'h04c;
localparam [11:0] REG_OUT_ADDR_HI           = 12'h050;

localparam [31:0] VERSION_EXPECTED = 32'h0002_0002;
localparam real ABS_TOL = 1.0e-4;
localparam real REL_TOL = 1.0e-3;

reg         aclk = 1'b0;
reg         aresetn = 1'b0;
reg [11:0]  s_axi_awaddr = 12'd0;
reg         s_axi_awvalid = 1'b0;
wire        s_axi_awready;
reg [31:0]  s_axi_wdata = 32'd0;
reg [3:0]   s_axi_wstrb = 4'hf;
reg         s_axi_wvalid = 1'b0;
wire        s_axi_wready;
wire [1:0]  s_axi_bresp;
wire        s_axi_bvalid;
reg         s_axi_bready = 1'b0;
reg [11:0]  s_axi_araddr = 12'd0;
reg         s_axi_arvalid = 1'b0;
wire        s_axi_arready;
wire [31:0] s_axi_rdata;
wire [1:0]  s_axi_rresp;
wire        s_axi_rvalid;
reg         s_axi_rready = 1'b0;

wire unified_obs_ap_start;
wire unified_obs_ap_idle;
wire unified_obs_ap_ready;
wire unified_obs_ap_done;
wire [31:0] unified_obs_num_points;
wire [31:0] unified_obs_scan_points_addr;
wire [31:0] unified_obs_pose_addr;
wire [31:0] unified_obs_map_header_addr;
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

reg [31:0] read_data;
integer done_seen;
integer compare_failures;
real max_abs;
real max_rel;

`AXI_WIRES(gmem0, 128);
`AXI_WIRES(gmem1, 512);
`AXI_WIRES(gmem2, 256);
`AXI_WIRES(gmem3, 512);
`AXI_WIRES(gmem4, 64);

always #5 aclk = ~aclk;

slam_accel_ctrl ctrl (
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

unified_surfel_observation_core unified_obs (
    .ap_clk(aclk),
    .ap_rst_n(aresetn),
    .ap_start(unified_obs_ap_start),
    .ap_done(unified_obs_ap_done),
    .ap_idle(unified_obs_ap_idle),
    .ap_ready(unified_obs_ap_ready),
    `HLS_AXI_CONN(gmem0, gmem0),
    `HLS_AXI_CONN(gmem1, gmem1),
    `HLS_AXI_CONN(gmem2, gmem2),
    `HLS_AXI_CONN(gmem3, gmem3),
    `HLS_AXI_CONN(gmem4, gmem4),
    .scan_points(unified_obs_scan_points_addr),
    .num_points(unified_obs_num_points),
    .pose(unified_obs_pose_addr),
    .map_header(unified_obs_map_header_addr),
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
    .output_reserved(unified_obs_output_reserved_addr)
);

`AXI_MEM(gmem0, 128, 131072, "GMEM0_BIN=%s");
`AXI_MEM(gmem1, 512, 4096, "GMEM1_BIN=%s");
`AXI_MEM(gmem2, 256, 131072, "GMEM2_BIN=%s");
`AXI_MEM(gmem3, 512, 67108864, "GMEM3_BIN=%s");
`AXI_MEM(gmem4, 64, 4096, "GMEM4_BIN=%s");

task fail;
    input [8*192-1:0] message;
    begin
        $display("[tb_lmem_golden] FAIL: %0s", message);
        $finish;
    end
endtask

task axi_write;
    input [11:0] addr;
    input [31:0] data;
    begin
        @(posedge aclk);
        s_axi_awaddr <= addr;
        s_axi_wdata <= data;
        s_axi_wstrb <= 4'hf;
        s_axi_awvalid <= 1'b1;
        s_axi_wvalid <= 1'b1;
        s_axi_bready <= 1'b1;
        wait (s_axi_awready && s_axi_wready);
        @(posedge aclk);
        s_axi_awvalid <= 1'b0;
        s_axi_wvalid <= 1'b0;
        wait (s_axi_bvalid);
        if (s_axi_bresp != 2'b00) fail("AXI write response was not OKAY");
        @(posedge aclk);
        s_axi_bready <= 1'b0;
    end
endtask

task axi_read;
    input [11:0] addr;
    output [31:0] data;
    begin
        @(posedge aclk);
        s_axi_araddr <= addr;
        s_axi_arvalid <= 1'b1;
        s_axi_rready <= 1'b1;
        wait (s_axi_arready);
        @(posedge aclk);
        s_axi_arvalid <= 1'b0;
        wait (s_axi_rvalid);
        data = s_axi_rdata;
        if (s_axi_rresp != 2'b00) fail("AXI read response was not OKAY");
        @(posedge aclk);
        s_axi_rready <= 1'b0;
    end
endtask

task wait_controller_done;
    integer i;
    begin
        done_seen = 0;
        for (i = 0; i < 2000000; i = i + 1) begin
            axi_read(REG_STATUS, read_data);
            if (read_data[2]) begin
                done_seen = 1;
                i = 2000000;
            end else if (read_data[3]) begin
                fail("controller entered ERROR while waiting for DONE");
            end else begin
                repeat (20) @(posedge aclk);
            end
        end
        if (!done_seen) fail("timed out waiting for controller DONE");
    end
endtask

function real abs_real(input real value);
    begin
        abs_real = value < 0.0 ? -value : value;
    end
endfunction

function real max_real(input real lhs, input real rhs);
    begin
        max_real = lhs > rhs ? lhs : rhs;
    end
endfunction

task compare_double_bits;
    input [8*32-1:0] name;
    input [63:0] actual_bits;
    input [63:0] expected_bits;
    real actual;
    real expected;
    real abs_err;
    real rel_err;
    begin
        actual = $bitstoreal(actual_bits);
        expected = $bitstoreal(expected_bits);
        abs_err = abs_real(actual - expected);
        rel_err = abs_err / max_real(1.0, abs_real(expected));
        if (abs_err > max_abs) begin
            max_abs = abs_err;
        end
        if (rel_err > max_rel) begin
            max_rel = rel_err;
        end
        if (abs_err > ABS_TOL && rel_err > REL_TOL) begin
            compare_failures = compare_failures + 1;
            $display("[tb_lmem_golden] value mismatch %0s actual=%0.17g expected=%0.17g abs=%0.17g rel=%0.17g",
                     name, actual, expected, abs_err, rel_err);
        end
    end
endtask

task compare_output;
    reg [31:0] actual_valid;
    reg [31:0] actual_reject;
    reg [31:0] actual_miss;
    begin
        compare_failures = 0;
        max_abs = 0.0;
        max_rel = 0.0;

        actual_valid = gmem4_mem.peek_u32(32'd216);
        actual_reject = gmem4_mem.peek_u32(32'd220);
        actual_miss = gmem4_mem.peek_u32(32'd224);
        if (actual_valid != GOLDEN_VALID_COUNT || actual_reject != GOLDEN_REJECT_COUNT ||
            actual_miss != GOLDEN_MISS_COUNT) begin
            $display("[tb_lmem_golden] count mismatch actual=%0d/%0d/%0d expected=%0d/%0d/%0d",
                     actual_valid, actual_reject, actual_miss,
                     GOLDEN_VALID_COUNT, GOLDEN_REJECT_COUNT, GOLDEN_MISS_COUNT);
            compare_failures = compare_failures + 1;
        end

        compare_double_bits("h00", gmem4_mem.peek_u64(32'd0), GOLDEN_H_00);
        compare_double_bits("h01", gmem4_mem.peek_u64(32'd8), GOLDEN_H_01);
        compare_double_bits("h02", gmem4_mem.peek_u64(32'd16), GOLDEN_H_02);
        compare_double_bits("h03", gmem4_mem.peek_u64(32'd24), GOLDEN_H_03);
        compare_double_bits("h04", gmem4_mem.peek_u64(32'd32), GOLDEN_H_04);
        compare_double_bits("h05", gmem4_mem.peek_u64(32'd40), GOLDEN_H_05);
        compare_double_bits("h06", gmem4_mem.peek_u64(32'd48), GOLDEN_H_06);
        compare_double_bits("h07", gmem4_mem.peek_u64(32'd56), GOLDEN_H_07);
        compare_double_bits("h08", gmem4_mem.peek_u64(32'd64), GOLDEN_H_08);
        compare_double_bits("h09", gmem4_mem.peek_u64(32'd72), GOLDEN_H_09);
        compare_double_bits("h10", gmem4_mem.peek_u64(32'd80), GOLDEN_H_10);
        compare_double_bits("h11", gmem4_mem.peek_u64(32'd88), GOLDEN_H_11);
        compare_double_bits("h12", gmem4_mem.peek_u64(32'd96), GOLDEN_H_12);
        compare_double_bits("h13", gmem4_mem.peek_u64(32'd104), GOLDEN_H_13);
        compare_double_bits("h14", gmem4_mem.peek_u64(32'd112), GOLDEN_H_14);
        compare_double_bits("h15", gmem4_mem.peek_u64(32'd120), GOLDEN_H_15);
        compare_double_bits("h16", gmem4_mem.peek_u64(32'd128), GOLDEN_H_16);
        compare_double_bits("h17", gmem4_mem.peek_u64(32'd136), GOLDEN_H_17);
        compare_double_bits("h18", gmem4_mem.peek_u64(32'd144), GOLDEN_H_18);
        compare_double_bits("h19", gmem4_mem.peek_u64(32'd152), GOLDEN_H_19);
        compare_double_bits("h20", gmem4_mem.peek_u64(32'd160), GOLDEN_H_20);

        compare_double_bits("b0", gmem4_mem.peek_u64(32'd168), GOLDEN_B_00);
        compare_double_bits("b1", gmem4_mem.peek_u64(32'd176), GOLDEN_B_01);
        compare_double_bits("b2", gmem4_mem.peek_u64(32'd184), GOLDEN_B_02);
        compare_double_bits("b3", gmem4_mem.peek_u64(32'd192), GOLDEN_B_03);
        compare_double_bits("b4", gmem4_mem.peek_u64(32'd200), GOLDEN_B_04);
        compare_double_bits("b5", gmem4_mem.peek_u64(32'd208), GOLDEN_B_05);

        compare_double_bits("residual_sum", gmem4_mem.peek_u64(32'd232), GOLDEN_RESIDUAL_SUM);
        compare_double_bits("residual_abs_sum", gmem4_mem.peek_u64(32'd240), GOLDEN_RESIDUAL_ABS_SUM);
        compare_double_bits("residual_max_abs", gmem4_mem.peek_u64(32'd248), GOLDEN_RESIDUAL_MAX_ABS);

        $display("[tb_lmem_golden] compare counts=%0d/%0d/%0d max_abs=%0.17g max_rel=%0.17g failures=%0d",
                 actual_valid, actual_reject, actual_miss, max_abs, max_rel, compare_failures);
        if (compare_failures != 0) begin
            fail("golden output comparison failed");
        end
    end
endtask

initial begin
    repeat (8) @(posedge aclk);
    aresetn <= 1'b1;
    repeat (8) @(posedge aclk);

    axi_read(REG_VERSION, read_data);
    if (read_data != VERSION_EXPECTED) fail("VERSION mismatch");

    axi_write(REG_KERNEL_SEL, 32'd4);
    axi_write(REG_MODE, 32'd1);
    axi_write(REG_SCAN_ADDR_LO, GOLDEN_SCAN_ADDR);
    axi_write(REG_SCAN_ADDR_HI, 32'd0);
    axi_write(REG_SCAN_COUNT, GOLDEN_NUM_POINTS);
    axi_write(REG_POSE_ADDR_LO, GOLDEN_POSE_ADDR);
    axi_write(REG_POSE_ADDR_HI, 32'd0);
    axi_write(REG_MAP_HEADER_ADDR_LO, GOLDEN_MAP_HEADER_ADDR);
    axi_write(REG_MAP_HEADER_ADDR_HI, 32'd0);
    axi_write(REG_ACTIVE_BLOCKS_ADDR_LO, GOLDEN_ACTIVE_BLOCKS_ADDR);
    axi_write(REG_ACTIVE_BLOCKS_ADDR_HI, 32'd0);
    axi_write(REG_OBS_CELLS_ADDR_LO, GOLDEN_OBS_CELLS_ADDR);
    axi_write(REG_OBS_CELLS_ADDR_HI, 32'd0);
    axi_write(REG_OUT_ADDR_LO, GOLDEN_OUT_ADDR);
    axi_write(REG_OUT_ADDR_HI, 32'd0);

    axi_write(REG_CONTROL, 32'h0000_0001);
    wait_controller_done();

    axi_read(REG_ERROR, read_data);
    if (read_data != 32'd0) fail("ERROR was nonzero after golden run");
    axi_read(REG_RUN_COUNT, read_data);
    if (read_data != 32'd1) fail("RUN_COUNT mismatch after golden run");

    compare_output();
    $display("[tb_lmem_golden] PASS");
    $finish;
end

endmodule

`undef AXI_WIRES
`undef AXI_MEM
`undef HLS_AXI_CONN
