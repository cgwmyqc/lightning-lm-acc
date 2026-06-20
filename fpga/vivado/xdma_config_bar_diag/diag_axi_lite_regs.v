`timescale 1ns / 1ps

module diag_axi_lite_regs #(
    parameter integer C_S_AXI_ADDR_WIDTH = 12,
    parameter integer C_S_AXI_DATA_WIDTH = 32
) (
    input  wire                             s_axi_aclk,
    input  wire                             s_axi_aresetn,
    input  wire [C_S_AXI_ADDR_WIDTH-1:0]    s_axi_awaddr,
    input  wire [2:0]                       s_axi_awprot,
    input  wire                             s_axi_awvalid,
    output wire                             s_axi_awready,
    input  wire [C_S_AXI_DATA_WIDTH-1:0]    s_axi_wdata,
    input  wire [(C_S_AXI_DATA_WIDTH/8)-1:0] s_axi_wstrb,
    input  wire                             s_axi_wvalid,
    output wire                             s_axi_wready,
    output wire [1:0]                       s_axi_bresp,
    output wire                             s_axi_bvalid,
    input  wire                             s_axi_bready,
    input  wire [C_S_AXI_ADDR_WIDTH-1:0]    s_axi_araddr,
    input  wire [2:0]                       s_axi_arprot,
    input  wire                             s_axi_arvalid,
    output wire                             s_axi_arready,
    output wire [C_S_AXI_DATA_WIDTH-1:0]    s_axi_rdata,
    output wire [1:0]                       s_axi_rresp,
    output wire                             s_axi_rvalid,
    input  wire                             s_axi_rready
);

    localparam [31:0] REG_MAGIC   = 32'h58444d41; // "XDMA"
    localparam [31:0] REG_VERSION = 32'h00010000;

    reg [31:0] scratch0 = 32'h0;
    reg [31:0] scratch1 = 32'h0;
    reg [31:0] read_data = 32'h0;
    reg bvalid = 1'b0;
    reg rvalid = 1'b0;

    assign s_axi_awready = s_axi_awvalid && s_axi_wvalid && !bvalid;
    assign s_axi_wready  = s_axi_awvalid && s_axi_wvalid && !bvalid;
    assign s_axi_bresp   = 2'b00;
    assign s_axi_bvalid  = bvalid;

    assign s_axi_arready = s_axi_arvalid && !rvalid;
    assign s_axi_rdata   = read_data;
    assign s_axi_rresp   = 2'b00;
    assign s_axi_rvalid  = rvalid;

    wire write_fire = s_axi_awready && s_axi_wready;
    wire read_fire  = s_axi_arready;

    integer byte_idx;
    always @(posedge s_axi_aclk) begin
        if (!s_axi_aresetn) begin
            scratch0 <= 32'h0;
            scratch1 <= 32'h0;
            bvalid <= 1'b0;
            rvalid <= 1'b0;
            read_data <= 32'h0;
        end else begin
            if (write_fire) begin
                case (s_axi_awaddr[5:2])
                    4'h2: begin
                        for (byte_idx = 0; byte_idx < 4; byte_idx = byte_idx + 1) begin
                            if (s_axi_wstrb[byte_idx]) begin
                                scratch0[byte_idx*8 +: 8] <= s_axi_wdata[byte_idx*8 +: 8];
                            end
                        end
                    end
                    4'h3: begin
                        for (byte_idx = 0; byte_idx < 4; byte_idx = byte_idx + 1) begin
                            if (s_axi_wstrb[byte_idx]) begin
                                scratch1[byte_idx*8 +: 8] <= s_axi_wdata[byte_idx*8 +: 8];
                            end
                        end
                    end
                    default: begin
                    end
                endcase
                bvalid <= 1'b1;
            end else if (bvalid && s_axi_bready) begin
                bvalid <= 1'b0;
            end

            if (read_fire) begin
                case (s_axi_araddr[5:2])
                    4'h0: read_data <= REG_MAGIC;
                    4'h1: read_data <= REG_VERSION;
                    4'h2: read_data <= scratch0;
                    4'h3: read_data <= scratch1;
                    default: read_data <= 32'h0;
                endcase
                rvalid <= 1'b1;
            end else if (rvalid && s_axi_rready) begin
                rvalid <= 1'b0;
            end
        end
    end

    wire unused_inputs = &{1'b0, s_axi_awprot, s_axi_arprot};

endmodule
