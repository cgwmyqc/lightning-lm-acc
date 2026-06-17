// SPDX-License-Identifier: MIT

`timescale 1ns / 1ps

module tb_lmem_bd_smoke;

localparam [11:0] REG_VERSION               = 12'h000;
localparam [11:0] REG_CONTROL               = 12'h004;
localparam [11:0] REG_STATUS                = 12'h008;
localparam [11:0] REG_KERNEL_SEL            = 12'h00c;
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
wire [31:0] kernel_sel;
wire [31:0] mode;
wire [31:0] unified_obs_output_addr;

reg [31:0] read_data;
integer done_seen;

lmem_bd_wrapper dut (
    .aclk(aclk),
    .aresetn(aresetn),
    .kernel_sel_0(kernel_sel),
    .mode_0(mode),
    .s_axi_araddr_0(s_axi_araddr),
    .s_axi_arready_0(s_axi_arready),
    .s_axi_arvalid_0(s_axi_arvalid),
    .s_axi_awaddr_0(s_axi_awaddr),
    .s_axi_awready_0(s_axi_awready),
    .s_axi_awvalid_0(s_axi_awvalid),
    .s_axi_bready_0(s_axi_bready),
    .s_axi_bresp_0(s_axi_bresp),
    .s_axi_bvalid_0(s_axi_bvalid),
    .s_axi_rdata_0(s_axi_rdata),
    .s_axi_rready_0(s_axi_rready),
    .s_axi_rresp_0(s_axi_rresp),
    .s_axi_rvalid_0(s_axi_rvalid),
    .s_axi_wdata_0(s_axi_wdata),
    .s_axi_wready_0(s_axi_wready),
    .s_axi_wstrb_0(s_axi_wstrb),
    .s_axi_wvalid_0(s_axi_wvalid),
    .unified_obs_output_addr_0(unified_obs_output_addr)
);

always #5 aclk = ~aclk;

task fail;
    input [8*160-1:0] message;
    begin
        $display("[tb_lmem_bd_smoke] FAIL: %0s", message);
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
        for (i = 0; i < 20000; i = i + 1) begin
            axi_read(REG_STATUS, read_data);
            if (read_data[2]) begin
                done_seen = 1;
                i = 20000;
            end else if (read_data[3]) begin
                fail("controller entered ERROR while waiting for DONE");
            end else begin
                repeat (5) @(posedge aclk);
            end
        end
        if (!done_seen) fail("timed out waiting for controller DONE");
    end
endtask

initial begin
    repeat (8) @(posedge aclk);
    aresetn <= 1'b1;
    repeat (8) @(posedge aclk);

    axi_read(REG_VERSION, read_data);
    if (read_data != VERSION_EXPECTED) fail("VERSION mismatch");

    axi_write(REG_KERNEL_SEL, 32'd4);
    axi_write(REG_SCAN_ADDR_LO, 32'd0);
    axi_write(REG_SCAN_ADDR_HI, 32'd0);
    axi_write(REG_SCAN_COUNT, 32'd0);
    axi_write(REG_POSE_ADDR_LO, 32'd0);
    axi_write(REG_POSE_ADDR_HI, 32'd0);
    axi_write(REG_MAP_HEADER_ADDR_LO, 32'd0);
    axi_write(REG_MAP_HEADER_ADDR_HI, 32'd0);
    axi_write(REG_ACTIVE_BLOCKS_ADDR_LO, 32'd0);
    axi_write(REG_ACTIVE_BLOCKS_ADDR_HI, 32'd0);
    axi_write(REG_OBS_CELLS_ADDR_LO, 32'd0);
    axi_write(REG_OBS_CELLS_ADDR_HI, 32'd0);
    axi_write(REG_OUT_ADDR_LO, 32'd0);
    axi_write(REG_OUT_ADDR_HI, 32'd0);

    if (kernel_sel != 32'd4) fail("kernel_sel external port mismatch");
    if (unified_obs_output_addr != 32'd0) fail("output base external port mismatch");

    axi_write(REG_CONTROL, 32'h0000_0001);
    wait_controller_done();

    axi_read(REG_ERROR, read_data);
    if (read_data != 32'd0) fail("ERROR was nonzero after data-plane smoke run");
    axi_read(REG_RUN_COUNT, read_data);
    if (read_data != 32'd1) fail("RUN_COUNT mismatch after data-plane smoke run");

    $display("[tb_lmem_bd_smoke] PASS");
    $finish;
end

endmodule
