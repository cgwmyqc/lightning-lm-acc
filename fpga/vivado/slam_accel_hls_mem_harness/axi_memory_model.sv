// SPDX-License-Identifier: MIT

`timescale 1ns / 1ps

module axi_memory_model #(
    parameter integer DATA_WIDTH = 32,
    parameter integer MEM_BYTES = 4096,
    parameter INIT_PLUSARG = "AXI_MEM_BIN=%s"
) (
    input  wire                         aclk,
    input  wire                         aresetn,

    input  wire                         s_axi_awvalid,
    output wire                         s_axi_awready,
    input  wire [31:0]                  s_axi_awaddr,
    input  wire [0:0]                   s_axi_awid,
    input  wire [7:0]                   s_axi_awlen,
    input  wire [2:0]                   s_axi_awsize,
    input  wire [1:0]                   s_axi_awburst,
    input  wire [1:0]                   s_axi_awlock,
    input  wire [3:0]                   s_axi_awcache,
    input  wire [2:0]                   s_axi_awprot,
    input  wire [3:0]                   s_axi_awqos,
    input  wire [3:0]                   s_axi_awregion,
    input  wire [0:0]                   s_axi_awuser,

    input  wire                         s_axi_wvalid,
    output wire                         s_axi_wready,
    input  wire [DATA_WIDTH-1:0]        s_axi_wdata,
    input  wire [(DATA_WIDTH/8)-1:0]    s_axi_wstrb,
    input  wire                         s_axi_wlast,
    input  wire [0:0]                   s_axi_wid,
    input  wire [0:0]                   s_axi_wuser,

    output reg                          s_axi_bvalid,
    input  wire                         s_axi_bready,
    output wire [1:0]                   s_axi_bresp,
    output reg  [0:0]                   s_axi_bid,
    output wire [0:0]                   s_axi_buser,

    input  wire                         s_axi_arvalid,
    output wire                         s_axi_arready,
    input  wire [31:0]                  s_axi_araddr,
    input  wire [0:0]                   s_axi_arid,
    input  wire [7:0]                   s_axi_arlen,
    input  wire [2:0]                   s_axi_arsize,
    input  wire [1:0]                   s_axi_arburst,
    input  wire [1:0]                   s_axi_arlock,
    input  wire [3:0]                   s_axi_arcache,
    input  wire [2:0]                   s_axi_arprot,
    input  wire [3:0]                   s_axi_arqos,
    input  wire [3:0]                   s_axi_arregion,
    input  wire [0:0]                   s_axi_aruser,

    output reg                          s_axi_rvalid,
    input  wire                         s_axi_rready,
    output reg  [DATA_WIDTH-1:0]        s_axi_rdata,
    output reg                          s_axi_rlast,
    output reg  [0:0]                   s_axi_rid,
    output wire [0:0]                   s_axi_ruser,
    output wire [1:0]                   s_axi_rresp
);

localparam integer DATA_BYTES = DATA_WIDTH / 8;

byte unsigned mem [0:MEM_BYTES-1];

reg        read_active;
reg [31:0] read_addr;
reg [7:0]  read_remaining;
reg [2:0]  read_size;
reg [0:0]  read_id;

reg        write_active;
reg [31:0] write_addr;
reg [7:0]  write_remaining;
reg [2:0]  write_size;
reg [0:0]  write_id;

assign s_axi_awready = aresetn && !write_active;
assign s_axi_wready = aresetn && write_active && !s_axi_bvalid;
assign s_axi_bresp = 2'b00;
assign s_axi_buser = 1'b0;
assign s_axi_arready = aresetn && !read_active && !s_axi_rvalid;
assign s_axi_rresp = 2'b00;
assign s_axi_ruser = 1'b0;

initial begin
    string image_path;
    integer fd;
    integer loaded;
    for (int i = 0; i < MEM_BYTES; i++) begin
        mem[i] = 8'h00;
    end
    if ($value$plusargs(INIT_PLUSARG, image_path)) begin
        fd = $fopen(image_path, "rb");
        if (fd == 0) begin
            $display("[axi_memory_model] FAIL: could not open %0s", image_path);
            $finish;
        end
        loaded = $fread(mem, fd);
        $fclose(fd);
        $display("[axi_memory_model] loaded %0d bytes from %0s", loaded, image_path);
    end
end

function automatic [7:0] read_byte(input [31:0] addr);
    begin
        if (addr < MEM_BYTES) begin
            read_byte = mem[addr];
        end else begin
            read_byte = 8'h00;
        end
    end
endfunction

function automatic [31:0] peek_u32(input [31:0] addr);
    begin
        peek_u32 = {read_byte(addr + 3), read_byte(addr + 2), read_byte(addr + 1), read_byte(addr)};
    end
endfunction

function automatic [63:0] peek_u64(input [31:0] addr);
    begin
        peek_u64 = {read_byte(addr + 7), read_byte(addr + 6), read_byte(addr + 5), read_byte(addr + 4),
                    read_byte(addr + 3), read_byte(addr + 2), read_byte(addr + 1), read_byte(addr)};
    end
endfunction

task automatic load_read_data(input [31:0] addr);
    begin
        for (int i = 0; i < DATA_BYTES; i++) begin
            s_axi_rdata[i * 8 +: 8] <= read_byte(addr + i);
        end
    end
endtask

task automatic store_write_data(input [31:0] addr);
    begin
        for (int i = 0; i < DATA_BYTES; i++) begin
            if (s_axi_wstrb[i] && ((addr + i) < MEM_BYTES)) begin
                mem[addr + i] <= s_axi_wdata[i * 8 +: 8];
            end
        end
    end
endtask

always_ff @(posedge aclk) begin
    if (!aresetn) begin
        read_active <= 1'b0;
        read_addr <= 32'd0;
        read_remaining <= 8'd0;
        read_size <= 3'd0;
        read_id <= 1'b0;
        s_axi_rvalid <= 1'b0;
        s_axi_rdata <= '0;
        s_axi_rlast <= 1'b0;
        s_axi_rid <= 1'b0;

        write_active <= 1'b0;
        write_addr <= 32'd0;
        write_remaining <= 8'd0;
        write_size <= 3'd0;
        write_id <= 1'b0;
        s_axi_bvalid <= 1'b0;
        s_axi_bid <= 1'b0;
    end else begin
        if (s_axi_bvalid && s_axi_bready) begin
            s_axi_bvalid <= 1'b0;
        end

        if (s_axi_awvalid && s_axi_awready) begin
            write_active <= 1'b1;
            write_addr <= s_axi_awaddr;
            write_remaining <= s_axi_awlen;
            write_size <= s_axi_awsize;
            write_id <= s_axi_awid;
        end

        if (s_axi_wvalid && s_axi_wready) begin
            store_write_data(write_addr);
            write_addr <= write_addr + (32'd1 << write_size);
            if (write_remaining == 8'd0 || s_axi_wlast) begin
                write_active <= 1'b0;
                s_axi_bvalid <= 1'b1;
                s_axi_bid <= write_id;
            end else begin
                write_remaining <= write_remaining - 8'd1;
            end
        end

        if (s_axi_rvalid && s_axi_rready) begin
            s_axi_rvalid <= 1'b0;
            if (s_axi_rlast) begin
                read_active <= 1'b0;
            end
        end

        if (s_axi_arvalid && s_axi_arready) begin
            read_active <= 1'b1;
            read_addr <= s_axi_araddr;
            read_remaining <= s_axi_arlen;
            read_size <= s_axi_arsize;
            read_id <= s_axi_arid;
        end

        if (read_active && !s_axi_rvalid) begin
            load_read_data(read_addr);
            s_axi_rvalid <= 1'b1;
            s_axi_rlast <= (read_remaining == 8'd0);
            s_axi_rid <= read_id;
            read_addr <= read_addr + (32'd1 << read_size);
            if (read_remaining != 8'd0) begin
                read_remaining <= read_remaining - 8'd1;
            end
        end
    end
end

endmodule
