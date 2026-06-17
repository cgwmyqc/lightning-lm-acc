// SPDX-License-Identifier: MIT

`timescale 1ns / 1ps

module tb_slam_accel_wrapper_sim;

localparam [11:0] REG_VERSION              = 12'h000;
localparam [11:0] REG_CONTROL              = 12'h004;
localparam [11:0] REG_STATUS               = 12'h008;
localparam [11:0] REG_KERNEL_SEL           = 12'h00c;
localparam [11:0] REG_ERROR                = 12'h014;
localparam [11:0] REG_RUN_COUNT            = 12'h01c;
localparam [11:0] REG_SCAN_ADDR_LO         = 12'h020;
localparam [11:0] REG_SCAN_ADDR_HI         = 12'h024;
localparam [11:0] REG_SCAN_COUNT           = 12'h028;
localparam [11:0] REG_POSE_ADDR_LO         = 12'h02c;
localparam [11:0] REG_MAP_HEADER_ADDR_LO   = 12'h034;
localparam [11:0] REG_ACTIVE_BLOCKS_ADDR_LO = 12'h03c;
localparam [11:0] REG_OBS_CELLS_ADDR_LO    = 12'h044;
localparam [11:0] REG_OUT_ADDR_LO          = 12'h04c;

localparam [31:0] VERSION_EXPECTED = 32'h0002_0002;
localparam [31:0] OUT_BASE = 32'h5000_0000;

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
wire        debug_hls_ap_start;
wire        debug_hls_ap_done;
wire        debug_hls_ap_idle;
wire        debug_hls_ap_ready;
wire [31:0] debug_hls_activity_sink;

reg [31:0] read_data;

slam_accel_wrapper_sim_top dut (
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
    .debug_hls_ap_start(debug_hls_ap_start),
    .debug_hls_ap_done(debug_hls_ap_done),
    .debug_hls_ap_idle(debug_hls_ap_idle),
    .debug_hls_ap_ready(debug_hls_ap_ready),
    .debug_hls_activity_sink(debug_hls_activity_sink)
);

always #5 aclk = ~aclk;

task fail;
    input [8*128-1:0] message;
    begin
        $display("[tb_slam_accel_wrapper_sim] FAIL: %0s", message);
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

task clear_done_error;
    begin
        axi_write(REG_CONTROL, 32'h0000_0002);
        repeat (2) @(posedge aclk);
    end
endtask

task wait_status_bit;
    input integer bit_index;
    integer i;
    begin
        for (i = 0; i < 64; i = i + 1) begin
            axi_read(REG_STATUS, read_data);
            if (read_data[bit_index]) begin
                i = 64;
            end else begin
                repeat (2) @(posedge aclk);
            end
        end
        if (!read_data[bit_index]) fail("Timed out waiting for status bit");
    end
endtask

initial begin
    repeat (8) @(posedge aclk);
    aresetn <= 1'b1;
    repeat (4) @(posedge aclk);

    axi_read(REG_VERSION, read_data);
    if (read_data != VERSION_EXPECTED) fail("VERSION mismatch");

    axi_write(REG_KERNEL_SEL, 32'd4);
    axi_write(REG_SCAN_ADDR_LO, 32'h1000_0000);
    axi_write(REG_SCAN_ADDR_HI, 32'd0);
    axi_write(REG_SCAN_COUNT, 32'd6963);
    axi_write(REG_POSE_ADDR_LO, 32'h2000_0000);
    axi_write(REG_MAP_HEADER_ADDR_LO, 32'h3000_0000);
    axi_write(REG_ACTIVE_BLOCKS_ADDR_LO, 32'h4000_0000);
    axi_write(REG_OBS_CELLS_ADDR_LO, 32'h4100_0000);
    axi_write(REG_OUT_ADDR_LO, OUT_BASE);

    if (dut.unified_obs_num_points != 32'd6963) fail("num_points direct port mismatch");
    if (dut.unified_obs_scan_points_addr != 32'h1000_0000) fail("scan direct port mismatch");
    if (dut.unified_obs_pose_addr != 32'h2000_0000) fail("pose direct port mismatch");
    if (dut.unified_obs_map_header_addr != 32'h3000_0000) fail("map_header direct port mismatch");
    if (dut.unified_obs_active_blocks_addr != 32'h4000_0000) fail("active_blocks direct port mismatch");
    if (dut.unified_obs_obs_cells_addr != 32'h4100_0000) fail("obs_cells direct port mismatch");
    if (dut.unified_obs_output_h_upper_addr != OUT_BASE + 32'd0) fail("output_h_upper address mismatch");
    if (dut.unified_obs_output_b_addr != OUT_BASE + 32'd168) fail("output_b address mismatch");
    if (dut.unified_obs_output_valid_count_addr != OUT_BASE + 32'd216) fail("output_valid_count address mismatch");
    if (dut.unified_obs_output_reject_count_addr != OUT_BASE + 32'd220) fail("output_reject_count address mismatch");
    if (dut.unified_obs_output_miss_count_addr != OUT_BASE + 32'd224) fail("output_miss_count address mismatch");
    if (dut.unified_obs_output_flags_addr != OUT_BASE + 32'd228) fail("output_flags address mismatch");
    if (dut.unified_obs_output_residual_sum_addr != OUT_BASE + 32'd232) fail("output_residual_sum address mismatch");
    if (dut.unified_obs_output_residual_abs_sum_addr != OUT_BASE + 32'd240) fail("output_residual_abs_sum address mismatch");
    if (dut.unified_obs_output_residual_max_abs_addr != OUT_BASE + 32'd248) fail("output_residual_max_abs address mismatch");
    if (dut.unified_obs_output_reserved_addr != OUT_BASE + 32'd256) fail("output_reserved address mismatch");

    axi_write(REG_CONTROL, 32'h0000_0001);
    wait (debug_hls_ap_start);
    wait_status_bit(2);
    axi_read(REG_ERROR, read_data);
    if (read_data != 32'd0) fail("ERROR was nonzero after successful run");
    axi_read(REG_RUN_COUNT, read_data);
    if (read_data != 32'd1) fail("RUN_COUNT mismatch after successful run");

    clear_done_error();
    axi_write(REG_KERNEL_SEL, 32'd5);
    axi_write(REG_CONTROL, 32'h0000_0001);
    wait_status_bit(3);
    axi_read(REG_ERROR, read_data);
    if (read_data != 32'h0000_0001) fail("unsupported kernel error mismatch");

    clear_done_error();
    axi_write(REG_KERNEL_SEL, 32'd4);
    axi_write(REG_SCAN_ADDR_HI, 32'd1);
    axi_write(REG_CONTROL, 32'h0000_0001);
    wait_status_bit(3);
    axi_read(REG_ERROR, read_data);
    if (read_data != 32'h0000_0003) fail("address high word error mismatch");

    $display("[tb_slam_accel_wrapper_sim] PASS");
    $finish;
end

endmodule
