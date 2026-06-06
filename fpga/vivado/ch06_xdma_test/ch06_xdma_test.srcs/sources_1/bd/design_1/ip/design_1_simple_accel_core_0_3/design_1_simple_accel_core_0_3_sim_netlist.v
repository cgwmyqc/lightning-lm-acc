// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Fri May 22 16:44:09 2026
// Host        : DESKTOP-QEQDV5I running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top design_1_simple_accel_core_0_3 -prefix
//               design_1_simple_accel_core_0_3_ design_1_simple_accel_core_0_3_sim_netlist.v
// Design      : design_1_simple_accel_core_0_3
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z015clg485-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "design_1_simple_accel_core_0_3,simple_accel_core,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* IP_DEFINITION_SOURCE = "HLS" *) 
(* X_CORE_INFO = "simple_accel_core,Vivado 2018.3" *) (* hls_module = "yes" *) 
(* NotValidForBitStream *)
module design_1_simple_accel_core_0_3
   (s_axi_control_AWADDR,
    s_axi_control_AWVALID,
    s_axi_control_AWREADY,
    s_axi_control_WDATA,
    s_axi_control_WSTRB,
    s_axi_control_WVALID,
    s_axi_control_WREADY,
    s_axi_control_BRESP,
    s_axi_control_BVALID,
    s_axi_control_BREADY,
    s_axi_control_ARADDR,
    s_axi_control_ARVALID,
    s_axi_control_ARREADY,
    s_axi_control_RDATA,
    s_axi_control_RRESP,
    s_axi_control_RVALID,
    s_axi_control_RREADY,
    ap_clk,
    ap_rst_n,
    interrupt,
    m_axi_gmem_AWADDR,
    m_axi_gmem_AWLEN,
    m_axi_gmem_AWSIZE,
    m_axi_gmem_AWBURST,
    m_axi_gmem_AWLOCK,
    m_axi_gmem_AWREGION,
    m_axi_gmem_AWCACHE,
    m_axi_gmem_AWPROT,
    m_axi_gmem_AWQOS,
    m_axi_gmem_AWVALID,
    m_axi_gmem_AWREADY,
    m_axi_gmem_WDATA,
    m_axi_gmem_WSTRB,
    m_axi_gmem_WLAST,
    m_axi_gmem_WVALID,
    m_axi_gmem_WREADY,
    m_axi_gmem_BRESP,
    m_axi_gmem_BVALID,
    m_axi_gmem_BREADY,
    m_axi_gmem_ARADDR,
    m_axi_gmem_ARLEN,
    m_axi_gmem_ARSIZE,
    m_axi_gmem_ARBURST,
    m_axi_gmem_ARLOCK,
    m_axi_gmem_ARREGION,
    m_axi_gmem_ARCACHE,
    m_axi_gmem_ARPROT,
    m_axi_gmem_ARQOS,
    m_axi_gmem_ARVALID,
    m_axi_gmem_ARREADY,
    m_axi_gmem_RDATA,
    m_axi_gmem_RRESP,
    m_axi_gmem_RLAST,
    m_axi_gmem_RVALID,
    m_axi_gmem_RREADY);
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control AWADDR" *) input [5:0]s_axi_control_AWADDR;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control AWVALID" *) input s_axi_control_AWVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control AWREADY" *) output s_axi_control_AWREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control WDATA" *) input [31:0]s_axi_control_WDATA;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control WSTRB" *) input [3:0]s_axi_control_WSTRB;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control WVALID" *) input s_axi_control_WVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control WREADY" *) output s_axi_control_WREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control BRESP" *) output [1:0]s_axi_control_BRESP;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control BVALID" *) output s_axi_control_BVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control BREADY" *) input s_axi_control_BREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control ARADDR" *) input [5:0]s_axi_control_ARADDR;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control ARVALID" *) input s_axi_control_ARVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control ARREADY" *) output s_axi_control_ARREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control RDATA" *) output [31:0]s_axi_control_RDATA;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control RRESP" *) output [1:0]s_axi_control_RRESP;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control RVALID" *) output s_axi_control_RVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_control RREADY" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axi_control, ADDR_WIDTH 6, DATA_WIDTH 32, PROTOCOL AXI4LITE, READ_WRITE_MODE READ_WRITE, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {CLK {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 1} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}}}, FREQ_HZ 62500000, ID_WIDTH 0, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.000, CLK_DOMAIN design_1_xdma_0_0_axi_aclk, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *) input s_axi_control_RREADY;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 ap_clk CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME ap_clk, ASSOCIATED_BUSIF s_axi_control:m_axi_gmem, ASSOCIATED_RESET ap_rst_n, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {CLK {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 1} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}}}, FREQ_HZ 62500000, PHASE 0.000, CLK_DOMAIN design_1_xdma_0_0_axi_aclk, INSERT_VIP 0" *) input ap_clk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 ap_rst_n RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME ap_rst_n, POLARITY ACTIVE_LOW, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {RST {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 1} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}}}, INSERT_VIP 0" *) input ap_rst_n;
  (* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 interrupt INTERRUPT" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME interrupt, SENSITIVITY LEVEL_HIGH, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {INTERRUPT {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 1} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}}}, PortWidth 1" *) output interrupt;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_gmem AWADDR" *) output [31:0]m_axi_gmem_AWADDR;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_gmem AWLEN" *) output [7:0]m_axi_gmem_AWLEN;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_gmem AWSIZE" *) output [2:0]m_axi_gmem_AWSIZE;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_gmem AWBURST" *) output [1:0]m_axi_gmem_AWBURST;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_gmem AWLOCK" *) output [1:0]m_axi_gmem_AWLOCK;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_gmem AWREGION" *) output [3:0]m_axi_gmem_AWREGION;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_gmem AWCACHE" *) output [3:0]m_axi_gmem_AWCACHE;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_gmem AWPROT" *) output [2:0]m_axi_gmem_AWPROT;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_gmem AWQOS" *) output [3:0]m_axi_gmem_AWQOS;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_gmem AWVALID" *) output m_axi_gmem_AWVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_gmem AWREADY" *) input m_axi_gmem_AWREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_gmem WDATA" *) output [31:0]m_axi_gmem_WDATA;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_gmem WSTRB" *) output [3:0]m_axi_gmem_WSTRB;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_gmem WLAST" *) output m_axi_gmem_WLAST;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_gmem WVALID" *) output m_axi_gmem_WVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_gmem WREADY" *) input m_axi_gmem_WREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_gmem BRESP" *) input [1:0]m_axi_gmem_BRESP;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_gmem BVALID" *) input m_axi_gmem_BVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_gmem BREADY" *) output m_axi_gmem_BREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_gmem ARADDR" *) output [31:0]m_axi_gmem_ARADDR;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_gmem ARLEN" *) output [7:0]m_axi_gmem_ARLEN;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_gmem ARSIZE" *) output [2:0]m_axi_gmem_ARSIZE;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_gmem ARBURST" *) output [1:0]m_axi_gmem_ARBURST;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_gmem ARLOCK" *) output [1:0]m_axi_gmem_ARLOCK;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_gmem ARREGION" *) output [3:0]m_axi_gmem_ARREGION;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_gmem ARCACHE" *) output [3:0]m_axi_gmem_ARCACHE;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_gmem ARPROT" *) output [2:0]m_axi_gmem_ARPROT;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_gmem ARQOS" *) output [3:0]m_axi_gmem_ARQOS;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_gmem ARVALID" *) output m_axi_gmem_ARVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_gmem ARREADY" *) input m_axi_gmem_ARREADY;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_gmem RDATA" *) input [31:0]m_axi_gmem_RDATA;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_gmem RRESP" *) input [1:0]m_axi_gmem_RRESP;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_gmem RLAST" *) input m_axi_gmem_RLAST;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_gmem RVALID" *) input m_axi_gmem_RVALID;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_gmem RREADY" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME m_axi_gmem, ADDR_WIDTH 32, MAX_BURST_LENGTH 256, NUM_READ_OUTSTANDING 16, NUM_WRITE_OUTSTANDING 16, MAX_READ_BURST_LENGTH 16, MAX_WRITE_BURST_LENGTH 16, PROTOCOL AXI4, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, SUPPORTS_NARROW_BURST 0, DATA_WIDTH 32, FREQ_HZ 62500000, ID_WIDTH 0, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, HAS_LOCK 1, HAS_PROT 1, HAS_CACHE 1, HAS_QOS 1, HAS_REGION 1, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, PHASE 0.000, CLK_DOMAIN design_1_xdma_0_0_axi_aclk, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *) output m_axi_gmem_RREADY;

  wire ap_clk;
  wire ap_rst_n;
  wire interrupt;
  wire [31:0]m_axi_gmem_ARADDR;
  wire [1:0]m_axi_gmem_ARBURST;
  wire [3:0]m_axi_gmem_ARCACHE;
  wire [7:0]m_axi_gmem_ARLEN;
  wire [1:0]m_axi_gmem_ARLOCK;
  wire [2:0]m_axi_gmem_ARPROT;
  wire [3:0]m_axi_gmem_ARQOS;
  wire m_axi_gmem_ARREADY;
  wire [3:0]m_axi_gmem_ARREGION;
  wire [2:0]m_axi_gmem_ARSIZE;
  wire m_axi_gmem_ARVALID;
  wire [31:0]m_axi_gmem_AWADDR;
  wire [1:0]m_axi_gmem_AWBURST;
  wire [3:0]m_axi_gmem_AWCACHE;
  wire [7:0]m_axi_gmem_AWLEN;
  wire [1:0]m_axi_gmem_AWLOCK;
  wire [2:0]m_axi_gmem_AWPROT;
  wire [3:0]m_axi_gmem_AWQOS;
  wire m_axi_gmem_AWREADY;
  wire [3:0]m_axi_gmem_AWREGION;
  wire [2:0]m_axi_gmem_AWSIZE;
  wire m_axi_gmem_AWVALID;
  wire m_axi_gmem_BREADY;
  wire [1:0]m_axi_gmem_BRESP;
  wire m_axi_gmem_BVALID;
  wire [31:0]m_axi_gmem_RDATA;
  wire m_axi_gmem_RLAST;
  wire m_axi_gmem_RREADY;
  wire [1:0]m_axi_gmem_RRESP;
  wire m_axi_gmem_RVALID;
  wire [31:0]m_axi_gmem_WDATA;
  wire m_axi_gmem_WLAST;
  wire m_axi_gmem_WREADY;
  wire [3:0]m_axi_gmem_WSTRB;
  wire m_axi_gmem_WVALID;
  wire [5:0]s_axi_control_ARADDR;
  wire s_axi_control_ARREADY;
  wire s_axi_control_ARVALID;
  wire [5:0]s_axi_control_AWADDR;
  wire s_axi_control_AWREADY;
  wire s_axi_control_AWVALID;
  wire s_axi_control_BREADY;
  wire [1:0]s_axi_control_BRESP;
  wire s_axi_control_BVALID;
  wire [31:0]s_axi_control_RDATA;
  wire s_axi_control_RREADY;
  wire [1:0]s_axi_control_RRESP;
  wire s_axi_control_RVALID;
  wire [31:0]s_axi_control_WDATA;
  wire s_axi_control_WREADY;
  wire [3:0]s_axi_control_WSTRB;
  wire s_axi_control_WVALID;
  wire [0:0]NLW_inst_m_axi_gmem_ARID_UNCONNECTED;
  wire [0:0]NLW_inst_m_axi_gmem_ARUSER_UNCONNECTED;
  wire [0:0]NLW_inst_m_axi_gmem_AWID_UNCONNECTED;
  wire [0:0]NLW_inst_m_axi_gmem_AWUSER_UNCONNECTED;
  wire [0:0]NLW_inst_m_axi_gmem_WID_UNCONNECTED;
  wire [0:0]NLW_inst_m_axi_gmem_WUSER_UNCONNECTED;

  (* C_M_AXI_DATA_WIDTH = "32" *) 
  (* C_M_AXI_GMEM_ADDR_WIDTH = "32" *) 
  (* C_M_AXI_GMEM_ARUSER_WIDTH = "1" *) 
  (* C_M_AXI_GMEM_AWUSER_WIDTH = "1" *) 
  (* C_M_AXI_GMEM_BUSER_WIDTH = "1" *) 
  (* C_M_AXI_GMEM_CACHE_VALUE = "3" *) 
  (* C_M_AXI_GMEM_DATA_WIDTH = "32" *) 
  (* C_M_AXI_GMEM_ID_WIDTH = "1" *) 
  (* C_M_AXI_GMEM_PROT_VALUE = "0" *) 
  (* C_M_AXI_GMEM_RUSER_WIDTH = "1" *) 
  (* C_M_AXI_GMEM_USER_VALUE = "0" *) 
  (* C_M_AXI_GMEM_WSTRB_WIDTH = "4" *) 
  (* C_M_AXI_GMEM_WUSER_WIDTH = "1" *) 
  (* C_M_AXI_WSTRB_WIDTH = "4" *) 
  (* C_S_AXI_CONTROL_ADDR_WIDTH = "6" *) 
  (* C_S_AXI_CONTROL_DATA_WIDTH = "32" *) 
  (* C_S_AXI_CONTROL_WSTRB_WIDTH = "4" *) 
  (* C_S_AXI_DATA_WIDTH = "32" *) 
  (* C_S_AXI_WSTRB_WIDTH = "4" *) 
  (* ap_ST_fsm_pp0_stage0 = "17'b00000000100000000" *) 
  (* ap_ST_fsm_state1 = "17'b00000000000000001" *) 
  (* ap_ST_fsm_state12 = "17'b00000001000000000" *) 
  (* ap_ST_fsm_state13 = "17'b00000010000000000" *) 
  (* ap_ST_fsm_state14 = "17'b00000100000000000" *) 
  (* ap_ST_fsm_state15 = "17'b00001000000000000" *) 
  (* ap_ST_fsm_state16 = "17'b00010000000000000" *) 
  (* ap_ST_fsm_state17 = "17'b00100000000000000" *) 
  (* ap_ST_fsm_state18 = "17'b01000000000000000" *) 
  (* ap_ST_fsm_state19 = "17'b10000000000000000" *) 
  (* ap_ST_fsm_state2 = "17'b00000000000000010" *) 
  (* ap_ST_fsm_state3 = "17'b00000000000000100" *) 
  (* ap_ST_fsm_state4 = "17'b00000000000001000" *) 
  (* ap_ST_fsm_state5 = "17'b00000000000010000" *) 
  (* ap_ST_fsm_state6 = "17'b00000000000100000" *) 
  (* ap_ST_fsm_state7 = "17'b00000000001000000" *) 
  (* ap_ST_fsm_state8 = "17'b00000000010000000" *) 
  design_1_simple_accel_core_0_3_simple_accel_core inst
       (.ap_clk(ap_clk),
        .ap_rst_n(ap_rst_n),
        .interrupt(interrupt),
        .m_axi_gmem_ARADDR(m_axi_gmem_ARADDR),
        .m_axi_gmem_ARBURST(m_axi_gmem_ARBURST),
        .m_axi_gmem_ARCACHE(m_axi_gmem_ARCACHE),
        .m_axi_gmem_ARID(NLW_inst_m_axi_gmem_ARID_UNCONNECTED[0]),
        .m_axi_gmem_ARLEN(m_axi_gmem_ARLEN),
        .m_axi_gmem_ARLOCK(m_axi_gmem_ARLOCK),
        .m_axi_gmem_ARPROT(m_axi_gmem_ARPROT),
        .m_axi_gmem_ARQOS(m_axi_gmem_ARQOS),
        .m_axi_gmem_ARREADY(m_axi_gmem_ARREADY),
        .m_axi_gmem_ARREGION(m_axi_gmem_ARREGION),
        .m_axi_gmem_ARSIZE(m_axi_gmem_ARSIZE),
        .m_axi_gmem_ARUSER(NLW_inst_m_axi_gmem_ARUSER_UNCONNECTED[0]),
        .m_axi_gmem_ARVALID(m_axi_gmem_ARVALID),
        .m_axi_gmem_AWADDR(m_axi_gmem_AWADDR),
        .m_axi_gmem_AWBURST(m_axi_gmem_AWBURST),
        .m_axi_gmem_AWCACHE(m_axi_gmem_AWCACHE),
        .m_axi_gmem_AWID(NLW_inst_m_axi_gmem_AWID_UNCONNECTED[0]),
        .m_axi_gmem_AWLEN(m_axi_gmem_AWLEN),
        .m_axi_gmem_AWLOCK(m_axi_gmem_AWLOCK),
        .m_axi_gmem_AWPROT(m_axi_gmem_AWPROT),
        .m_axi_gmem_AWQOS(m_axi_gmem_AWQOS),
        .m_axi_gmem_AWREADY(m_axi_gmem_AWREADY),
        .m_axi_gmem_AWREGION(m_axi_gmem_AWREGION),
        .m_axi_gmem_AWSIZE(m_axi_gmem_AWSIZE),
        .m_axi_gmem_AWUSER(NLW_inst_m_axi_gmem_AWUSER_UNCONNECTED[0]),
        .m_axi_gmem_AWVALID(m_axi_gmem_AWVALID),
        .m_axi_gmem_BID(1'b0),
        .m_axi_gmem_BREADY(m_axi_gmem_BREADY),
        .m_axi_gmem_BRESP(m_axi_gmem_BRESP),
        .m_axi_gmem_BUSER(1'b0),
        .m_axi_gmem_BVALID(m_axi_gmem_BVALID),
        .m_axi_gmem_RDATA(m_axi_gmem_RDATA),
        .m_axi_gmem_RID(1'b0),
        .m_axi_gmem_RLAST(m_axi_gmem_RLAST),
        .m_axi_gmem_RREADY(m_axi_gmem_RREADY),
        .m_axi_gmem_RRESP(m_axi_gmem_RRESP),
        .m_axi_gmem_RUSER(1'b0),
        .m_axi_gmem_RVALID(m_axi_gmem_RVALID),
        .m_axi_gmem_WDATA(m_axi_gmem_WDATA),
        .m_axi_gmem_WID(NLW_inst_m_axi_gmem_WID_UNCONNECTED[0]),
        .m_axi_gmem_WLAST(m_axi_gmem_WLAST),
        .m_axi_gmem_WREADY(m_axi_gmem_WREADY),
        .m_axi_gmem_WSTRB(m_axi_gmem_WSTRB),
        .m_axi_gmem_WUSER(NLW_inst_m_axi_gmem_WUSER_UNCONNECTED[0]),
        .m_axi_gmem_WVALID(m_axi_gmem_WVALID),
        .s_axi_control_ARADDR(s_axi_control_ARADDR),
        .s_axi_control_ARREADY(s_axi_control_ARREADY),
        .s_axi_control_ARVALID(s_axi_control_ARVALID),
        .s_axi_control_AWADDR(s_axi_control_AWADDR),
        .s_axi_control_AWREADY(s_axi_control_AWREADY),
        .s_axi_control_AWVALID(s_axi_control_AWVALID),
        .s_axi_control_BREADY(s_axi_control_BREADY),
        .s_axi_control_BRESP(s_axi_control_BRESP),
        .s_axi_control_BVALID(s_axi_control_BVALID),
        .s_axi_control_RDATA(s_axi_control_RDATA),
        .s_axi_control_RREADY(s_axi_control_RREADY),
        .s_axi_control_RRESP(s_axi_control_RRESP),
        .s_axi_control_RVALID(s_axi_control_RVALID),
        .s_axi_control_WDATA(s_axi_control_WDATA),
        .s_axi_control_WREADY(s_axi_control_WREADY),
        .s_axi_control_WSTRB(s_axi_control_WSTRB),
        .s_axi_control_WVALID(s_axi_control_WVALID));
endmodule

(* C_M_AXI_DATA_WIDTH = "32" *) (* C_M_AXI_GMEM_ADDR_WIDTH = "32" *) (* C_M_AXI_GMEM_ARUSER_WIDTH = "1" *) 
(* C_M_AXI_GMEM_AWUSER_WIDTH = "1" *) (* C_M_AXI_GMEM_BUSER_WIDTH = "1" *) (* C_M_AXI_GMEM_CACHE_VALUE = "3" *) 
(* C_M_AXI_GMEM_DATA_WIDTH = "32" *) (* C_M_AXI_GMEM_ID_WIDTH = "1" *) (* C_M_AXI_GMEM_PROT_VALUE = "0" *) 
(* C_M_AXI_GMEM_RUSER_WIDTH = "1" *) (* C_M_AXI_GMEM_USER_VALUE = "0" *) (* C_M_AXI_GMEM_WSTRB_WIDTH = "4" *) 
(* C_M_AXI_GMEM_WUSER_WIDTH = "1" *) (* C_M_AXI_WSTRB_WIDTH = "4" *) (* C_S_AXI_CONTROL_ADDR_WIDTH = "6" *) 
(* C_S_AXI_CONTROL_DATA_WIDTH = "32" *) (* C_S_AXI_CONTROL_WSTRB_WIDTH = "4" *) (* C_S_AXI_DATA_WIDTH = "32" *) 
(* C_S_AXI_WSTRB_WIDTH = "4" *) (* ap_ST_fsm_pp0_stage0 = "17'b00000000100000000" *) (* ap_ST_fsm_state1 = "17'b00000000000000001" *) 
(* ap_ST_fsm_state12 = "17'b00000001000000000" *) (* ap_ST_fsm_state13 = "17'b00000010000000000" *) (* ap_ST_fsm_state14 = "17'b00000100000000000" *) 
(* ap_ST_fsm_state15 = "17'b00001000000000000" *) (* ap_ST_fsm_state16 = "17'b00010000000000000" *) (* ap_ST_fsm_state17 = "17'b00100000000000000" *) 
(* ap_ST_fsm_state18 = "17'b01000000000000000" *) (* ap_ST_fsm_state19 = "17'b10000000000000000" *) (* ap_ST_fsm_state2 = "17'b00000000000000010" *) 
(* ap_ST_fsm_state3 = "17'b00000000000000100" *) (* ap_ST_fsm_state4 = "17'b00000000000001000" *) (* ap_ST_fsm_state5 = "17'b00000000000010000" *) 
(* ap_ST_fsm_state6 = "17'b00000000000100000" *) (* ap_ST_fsm_state7 = "17'b00000000001000000" *) (* ap_ST_fsm_state8 = "17'b00000000010000000" *) 
(* hls_module = "yes" *) 
module design_1_simple_accel_core_0_3_simple_accel_core
   (ap_clk,
    ap_rst_n,
    m_axi_gmem_AWVALID,
    m_axi_gmem_AWREADY,
    m_axi_gmem_AWADDR,
    m_axi_gmem_AWID,
    m_axi_gmem_AWLEN,
    m_axi_gmem_AWSIZE,
    m_axi_gmem_AWBURST,
    m_axi_gmem_AWLOCK,
    m_axi_gmem_AWCACHE,
    m_axi_gmem_AWPROT,
    m_axi_gmem_AWQOS,
    m_axi_gmem_AWREGION,
    m_axi_gmem_AWUSER,
    m_axi_gmem_WVALID,
    m_axi_gmem_WREADY,
    m_axi_gmem_WDATA,
    m_axi_gmem_WSTRB,
    m_axi_gmem_WLAST,
    m_axi_gmem_WID,
    m_axi_gmem_WUSER,
    m_axi_gmem_ARVALID,
    m_axi_gmem_ARREADY,
    m_axi_gmem_ARADDR,
    m_axi_gmem_ARID,
    m_axi_gmem_ARLEN,
    m_axi_gmem_ARSIZE,
    m_axi_gmem_ARBURST,
    m_axi_gmem_ARLOCK,
    m_axi_gmem_ARCACHE,
    m_axi_gmem_ARPROT,
    m_axi_gmem_ARQOS,
    m_axi_gmem_ARREGION,
    m_axi_gmem_ARUSER,
    m_axi_gmem_RVALID,
    m_axi_gmem_RREADY,
    m_axi_gmem_RDATA,
    m_axi_gmem_RLAST,
    m_axi_gmem_RID,
    m_axi_gmem_RUSER,
    m_axi_gmem_RRESP,
    m_axi_gmem_BVALID,
    m_axi_gmem_BREADY,
    m_axi_gmem_BRESP,
    m_axi_gmem_BID,
    m_axi_gmem_BUSER,
    s_axi_control_AWVALID,
    s_axi_control_AWREADY,
    s_axi_control_AWADDR,
    s_axi_control_WVALID,
    s_axi_control_WREADY,
    s_axi_control_WDATA,
    s_axi_control_WSTRB,
    s_axi_control_ARVALID,
    s_axi_control_ARREADY,
    s_axi_control_ARADDR,
    s_axi_control_RVALID,
    s_axi_control_RREADY,
    s_axi_control_RDATA,
    s_axi_control_RRESP,
    s_axi_control_BVALID,
    s_axi_control_BREADY,
    s_axi_control_BRESP,
    interrupt);
  input ap_clk;
  input ap_rst_n;
  output m_axi_gmem_AWVALID;
  input m_axi_gmem_AWREADY;
  output [31:0]m_axi_gmem_AWADDR;
  output [0:0]m_axi_gmem_AWID;
  output [7:0]m_axi_gmem_AWLEN;
  output [2:0]m_axi_gmem_AWSIZE;
  output [1:0]m_axi_gmem_AWBURST;
  output [1:0]m_axi_gmem_AWLOCK;
  output [3:0]m_axi_gmem_AWCACHE;
  output [2:0]m_axi_gmem_AWPROT;
  output [3:0]m_axi_gmem_AWQOS;
  output [3:0]m_axi_gmem_AWREGION;
  output [0:0]m_axi_gmem_AWUSER;
  output m_axi_gmem_WVALID;
  input m_axi_gmem_WREADY;
  output [31:0]m_axi_gmem_WDATA;
  output [3:0]m_axi_gmem_WSTRB;
  output m_axi_gmem_WLAST;
  output [0:0]m_axi_gmem_WID;
  output [0:0]m_axi_gmem_WUSER;
  output m_axi_gmem_ARVALID;
  input m_axi_gmem_ARREADY;
  output [31:0]m_axi_gmem_ARADDR;
  output [0:0]m_axi_gmem_ARID;
  output [7:0]m_axi_gmem_ARLEN;
  output [2:0]m_axi_gmem_ARSIZE;
  output [1:0]m_axi_gmem_ARBURST;
  output [1:0]m_axi_gmem_ARLOCK;
  output [3:0]m_axi_gmem_ARCACHE;
  output [2:0]m_axi_gmem_ARPROT;
  output [3:0]m_axi_gmem_ARQOS;
  output [3:0]m_axi_gmem_ARREGION;
  output [0:0]m_axi_gmem_ARUSER;
  input m_axi_gmem_RVALID;
  output m_axi_gmem_RREADY;
  input [31:0]m_axi_gmem_RDATA;
  input m_axi_gmem_RLAST;
  input [0:0]m_axi_gmem_RID;
  input [0:0]m_axi_gmem_RUSER;
  input [1:0]m_axi_gmem_RRESP;
  input m_axi_gmem_BVALID;
  output m_axi_gmem_BREADY;
  input [1:0]m_axi_gmem_BRESP;
  input [0:0]m_axi_gmem_BID;
  input [0:0]m_axi_gmem_BUSER;
  input s_axi_control_AWVALID;
  output s_axi_control_AWREADY;
  input [5:0]s_axi_control_AWADDR;
  input s_axi_control_WVALID;
  output s_axi_control_WREADY;
  input [31:0]s_axi_control_WDATA;
  input [3:0]s_axi_control_WSTRB;
  input s_axi_control_ARVALID;
  output s_axi_control_ARREADY;
  input [5:0]s_axi_control_ARADDR;
  output s_axi_control_RVALID;
  input s_axi_control_RREADY;
  output [31:0]s_axi_control_RDATA;
  output [1:0]s_axi_control_RRESP;
  output s_axi_control_BVALID;
  input s_axi_control_BREADY;
  output [1:0]s_axi_control_BRESP;
  output interrupt;

  wire \<const0> ;
  wire \<const1> ;
  wire \ap_CS_fsm[1]_i_2_n_2 ;
  wire \ap_CS_fsm[1]_i_3_n_2 ;
  wire \ap_CS_fsm[1]_i_4_n_2 ;
  wire \ap_CS_fsm[1]_i_5_n_2 ;
  wire \ap_CS_fsm[9]_i_2_n_2 ;
  wire ap_CS_fsm_pp0_stage0;
  wire \ap_CS_fsm_reg_n_2_[0] ;
  wire \ap_CS_fsm_reg_n_2_[12] ;
  wire \ap_CS_fsm_reg_n_2_[13] ;
  wire \ap_CS_fsm_reg_n_2_[14] ;
  wire \ap_CS_fsm_reg_n_2_[15] ;
  wire \ap_CS_fsm_reg_n_2_[2] ;
  wire \ap_CS_fsm_reg_n_2_[3] ;
  wire \ap_CS_fsm_reg_n_2_[4] ;
  wire \ap_CS_fsm_reg_n_2_[5] ;
  wire \ap_CS_fsm_reg_n_2_[6] ;
  wire ap_CS_fsm_state12;
  wire ap_CS_fsm_state13;
  wire ap_CS_fsm_state14;
  wire ap_CS_fsm_state19;
  wire ap_CS_fsm_state2;
  wire ap_CS_fsm_state8;
  wire [16:0]ap_NS_fsm;
  wire ap_NS_fsm112_out;
  wire ap_NS_fsm120_out;
  wire ap_clk;
  wire ap_condition_pp0_exit_iter0_state9;
  wire ap_done;
  wire ap_enable_reg_pp0_iter0;
  wire ap_enable_reg_pp0_iter1_reg_n_2;
  wire ap_enable_reg_pp0_iter2_reg_n_2;
  wire ap_reg_ioackin_gmem_WREADY;
  wire ap_reg_ioackin_gmem_WREADY_i_1_n_2;
  wire ap_rst_n;
  wire ap_rst_n_inv;
  wire ap_start;
  wire \bus_read/rs_rreq/load_p2 ;
  wire exitcond_reg_251_pp0_iter1_reg;
  wire \exitcond_reg_251_reg_n_2_[0] ;
  wire gmem_BVALID;
  wire [31:0]gmem_RDATA;
  wire [31:0]gmem_addr_1_read_reg_260;
  wire gmem_addr_1_read_reg_2600;
  wire [29:0]gmem_addr_reg_244;
  wire i_reg_137;
  wire i_reg_1370;
  wire \i_reg_137[0]_i_11_n_2 ;
  wire \i_reg_137[0]_i_12_n_2 ;
  wire \i_reg_137[0]_i_13_n_2 ;
  wire \i_reg_137[0]_i_14_n_2 ;
  wire \i_reg_137[0]_i_15_n_2 ;
  wire \i_reg_137[0]_i_16_n_2 ;
  wire \i_reg_137[0]_i_17_n_2 ;
  wire \i_reg_137[0]_i_18_n_2 ;
  wire \i_reg_137[0]_i_5_n_2 ;
  wire \i_reg_137[0]_i_7_n_2 ;
  wire \i_reg_137[0]_i_8_n_2 ;
  wire \i_reg_137[0]_i_9_n_2 ;
  wire [31:0]i_reg_137_reg;
  wire \i_reg_137_reg[0]_i_10_n_2 ;
  wire \i_reg_137_reg[0]_i_10_n_3 ;
  wire \i_reg_137_reg[0]_i_10_n_4 ;
  wire \i_reg_137_reg[0]_i_10_n_5 ;
  wire \i_reg_137_reg[0]_i_3_n_2 ;
  wire \i_reg_137_reg[0]_i_3_n_3 ;
  wire \i_reg_137_reg[0]_i_3_n_4 ;
  wire \i_reg_137_reg[0]_i_3_n_5 ;
  wire \i_reg_137_reg[0]_i_3_n_6 ;
  wire \i_reg_137_reg[0]_i_3_n_7 ;
  wire \i_reg_137_reg[0]_i_3_n_8 ;
  wire \i_reg_137_reg[0]_i_3_n_9 ;
  wire \i_reg_137_reg[0]_i_4_n_4 ;
  wire \i_reg_137_reg[0]_i_4_n_5 ;
  wire \i_reg_137_reg[0]_i_6_n_2 ;
  wire \i_reg_137_reg[0]_i_6_n_3 ;
  wire \i_reg_137_reg[0]_i_6_n_4 ;
  wire \i_reg_137_reg[0]_i_6_n_5 ;
  wire \i_reg_137_reg[12]_i_1_n_2 ;
  wire \i_reg_137_reg[12]_i_1_n_3 ;
  wire \i_reg_137_reg[12]_i_1_n_4 ;
  wire \i_reg_137_reg[12]_i_1_n_5 ;
  wire \i_reg_137_reg[12]_i_1_n_6 ;
  wire \i_reg_137_reg[12]_i_1_n_7 ;
  wire \i_reg_137_reg[12]_i_1_n_8 ;
  wire \i_reg_137_reg[12]_i_1_n_9 ;
  wire \i_reg_137_reg[16]_i_1_n_2 ;
  wire \i_reg_137_reg[16]_i_1_n_3 ;
  wire \i_reg_137_reg[16]_i_1_n_4 ;
  wire \i_reg_137_reg[16]_i_1_n_5 ;
  wire \i_reg_137_reg[16]_i_1_n_6 ;
  wire \i_reg_137_reg[16]_i_1_n_7 ;
  wire \i_reg_137_reg[16]_i_1_n_8 ;
  wire \i_reg_137_reg[16]_i_1_n_9 ;
  wire \i_reg_137_reg[20]_i_1_n_2 ;
  wire \i_reg_137_reg[20]_i_1_n_3 ;
  wire \i_reg_137_reg[20]_i_1_n_4 ;
  wire \i_reg_137_reg[20]_i_1_n_5 ;
  wire \i_reg_137_reg[20]_i_1_n_6 ;
  wire \i_reg_137_reg[20]_i_1_n_7 ;
  wire \i_reg_137_reg[20]_i_1_n_8 ;
  wire \i_reg_137_reg[20]_i_1_n_9 ;
  wire \i_reg_137_reg[24]_i_1_n_2 ;
  wire \i_reg_137_reg[24]_i_1_n_3 ;
  wire \i_reg_137_reg[24]_i_1_n_4 ;
  wire \i_reg_137_reg[24]_i_1_n_5 ;
  wire \i_reg_137_reg[24]_i_1_n_6 ;
  wire \i_reg_137_reg[24]_i_1_n_7 ;
  wire \i_reg_137_reg[24]_i_1_n_8 ;
  wire \i_reg_137_reg[24]_i_1_n_9 ;
  wire \i_reg_137_reg[28]_i_1_n_3 ;
  wire \i_reg_137_reg[28]_i_1_n_4 ;
  wire \i_reg_137_reg[28]_i_1_n_5 ;
  wire \i_reg_137_reg[28]_i_1_n_6 ;
  wire \i_reg_137_reg[28]_i_1_n_7 ;
  wire \i_reg_137_reg[28]_i_1_n_8 ;
  wire \i_reg_137_reg[28]_i_1_n_9 ;
  wire \i_reg_137_reg[4]_i_1_n_2 ;
  wire \i_reg_137_reg[4]_i_1_n_3 ;
  wire \i_reg_137_reg[4]_i_1_n_4 ;
  wire \i_reg_137_reg[4]_i_1_n_5 ;
  wire \i_reg_137_reg[4]_i_1_n_6 ;
  wire \i_reg_137_reg[4]_i_1_n_7 ;
  wire \i_reg_137_reg[4]_i_1_n_8 ;
  wire \i_reg_137_reg[4]_i_1_n_9 ;
  wire \i_reg_137_reg[8]_i_1_n_2 ;
  wire \i_reg_137_reg[8]_i_1_n_3 ;
  wire \i_reg_137_reg[8]_i_1_n_4 ;
  wire \i_reg_137_reg[8]_i_1_n_5 ;
  wire \i_reg_137_reg[8]_i_1_n_6 ;
  wire \i_reg_137_reg[8]_i_1_n_7 ;
  wire \i_reg_137_reg[8]_i_1_n_8 ;
  wire \i_reg_137_reg[8]_i_1_n_9 ;
  wire [31:2]in_buf;
  wire [29:0]in_buf1_reg_233;
  wire interrupt;
  wire [31:2]\^m_axi_gmem_ARADDR ;
  wire [3:0]\^m_axi_gmem_ARLEN ;
  wire m_axi_gmem_ARREADY;
  wire m_axi_gmem_ARVALID;
  wire [31:2]\^m_axi_gmem_AWADDR ;
  wire [3:0]\^m_axi_gmem_AWLEN ;
  wire m_axi_gmem_AWREADY;
  wire m_axi_gmem_AWVALID;
  wire m_axi_gmem_BREADY;
  wire m_axi_gmem_BVALID;
  wire [31:0]m_axi_gmem_RDATA;
  wire m_axi_gmem_RLAST;
  wire m_axi_gmem_RREADY;
  wire [1:0]m_axi_gmem_RRESP;
  wire m_axi_gmem_RVALID;
  wire [31:0]m_axi_gmem_WDATA;
  wire m_axi_gmem_WLAST;
  wire m_axi_gmem_WREADY;
  wire [3:0]m_axi_gmem_WSTRB;
  wire m_axi_gmem_WVALID;
  wire [31:0]num_items;
  wire [31:0]num_items_read_reg_222;
  wire [31:2]out_buf;
  wire [29:0]out_buf3_reg_228;
  wire [5:0]s_axi_control_ARADDR;
  wire s_axi_control_ARREADY;
  wire s_axi_control_ARVALID;
  wire [5:0]s_axi_control_AWADDR;
  wire s_axi_control_AWREADY;
  wire s_axi_control_AWVALID;
  wire s_axi_control_BREADY;
  wire s_axi_control_BVALID;
  wire [31:0]s_axi_control_RDATA;
  wire s_axi_control_RREADY;
  wire s_axi_control_RVALID;
  wire [31:0]s_axi_control_WDATA;
  wire s_axi_control_WREADY;
  wire [3:0]s_axi_control_WSTRB;
  wire s_axi_control_WVALID;
  wire simple_accel_core_gmem_m_axi_U_n_10;
  wire simple_accel_core_gmem_m_axi_U_n_29;
  wire simple_accel_core_gmem_m_axi_U_n_9;
  wire simple_accel_core_gmem_m_axi_U_n_91;
  wire simple_accel_core_gmem_m_axi_U_n_92;
  wire sum_reg_125;
  wire sum_reg_1250;
  wire \sum_reg_125[0]_i_4_n_2 ;
  wire \sum_reg_125[0]_i_5_n_2 ;
  wire \sum_reg_125[0]_i_6_n_2 ;
  wire \sum_reg_125[0]_i_7_n_2 ;
  wire \sum_reg_125[12]_i_2_n_2 ;
  wire \sum_reg_125[12]_i_3_n_2 ;
  wire \sum_reg_125[12]_i_4_n_2 ;
  wire \sum_reg_125[12]_i_5_n_2 ;
  wire \sum_reg_125[16]_i_2_n_2 ;
  wire \sum_reg_125[16]_i_3_n_2 ;
  wire \sum_reg_125[16]_i_4_n_2 ;
  wire \sum_reg_125[16]_i_5_n_2 ;
  wire \sum_reg_125[20]_i_2_n_2 ;
  wire \sum_reg_125[20]_i_3_n_2 ;
  wire \sum_reg_125[20]_i_4_n_2 ;
  wire \sum_reg_125[20]_i_5_n_2 ;
  wire \sum_reg_125[24]_i_2_n_2 ;
  wire \sum_reg_125[24]_i_3_n_2 ;
  wire \sum_reg_125[24]_i_4_n_2 ;
  wire \sum_reg_125[24]_i_5_n_2 ;
  wire \sum_reg_125[28]_i_2_n_2 ;
  wire \sum_reg_125[28]_i_3_n_2 ;
  wire \sum_reg_125[28]_i_4_n_2 ;
  wire \sum_reg_125[28]_i_5_n_2 ;
  wire \sum_reg_125[4]_i_2_n_2 ;
  wire \sum_reg_125[4]_i_3_n_2 ;
  wire \sum_reg_125[4]_i_4_n_2 ;
  wire \sum_reg_125[4]_i_5_n_2 ;
  wire \sum_reg_125[8]_i_2_n_2 ;
  wire \sum_reg_125[8]_i_3_n_2 ;
  wire \sum_reg_125[8]_i_4_n_2 ;
  wire \sum_reg_125[8]_i_5_n_2 ;
  wire [63:32]sum_reg_125_reg;
  wire \sum_reg_125_reg[0]_i_3_n_2 ;
  wire \sum_reg_125_reg[0]_i_3_n_3 ;
  wire \sum_reg_125_reg[0]_i_3_n_4 ;
  wire \sum_reg_125_reg[0]_i_3_n_5 ;
  wire \sum_reg_125_reg[0]_i_3_n_6 ;
  wire \sum_reg_125_reg[0]_i_3_n_7 ;
  wire \sum_reg_125_reg[0]_i_3_n_8 ;
  wire \sum_reg_125_reg[0]_i_3_n_9 ;
  wire \sum_reg_125_reg[12]_i_1_n_2 ;
  wire \sum_reg_125_reg[12]_i_1_n_3 ;
  wire \sum_reg_125_reg[12]_i_1_n_4 ;
  wire \sum_reg_125_reg[12]_i_1_n_5 ;
  wire \sum_reg_125_reg[12]_i_1_n_6 ;
  wire \sum_reg_125_reg[12]_i_1_n_7 ;
  wire \sum_reg_125_reg[12]_i_1_n_8 ;
  wire \sum_reg_125_reg[12]_i_1_n_9 ;
  wire \sum_reg_125_reg[16]_i_1_n_2 ;
  wire \sum_reg_125_reg[16]_i_1_n_3 ;
  wire \sum_reg_125_reg[16]_i_1_n_4 ;
  wire \sum_reg_125_reg[16]_i_1_n_5 ;
  wire \sum_reg_125_reg[16]_i_1_n_6 ;
  wire \sum_reg_125_reg[16]_i_1_n_7 ;
  wire \sum_reg_125_reg[16]_i_1_n_8 ;
  wire \sum_reg_125_reg[16]_i_1_n_9 ;
  wire \sum_reg_125_reg[20]_i_1_n_2 ;
  wire \sum_reg_125_reg[20]_i_1_n_3 ;
  wire \sum_reg_125_reg[20]_i_1_n_4 ;
  wire \sum_reg_125_reg[20]_i_1_n_5 ;
  wire \sum_reg_125_reg[20]_i_1_n_6 ;
  wire \sum_reg_125_reg[20]_i_1_n_7 ;
  wire \sum_reg_125_reg[20]_i_1_n_8 ;
  wire \sum_reg_125_reg[20]_i_1_n_9 ;
  wire \sum_reg_125_reg[24]_i_1_n_2 ;
  wire \sum_reg_125_reg[24]_i_1_n_3 ;
  wire \sum_reg_125_reg[24]_i_1_n_4 ;
  wire \sum_reg_125_reg[24]_i_1_n_5 ;
  wire \sum_reg_125_reg[24]_i_1_n_6 ;
  wire \sum_reg_125_reg[24]_i_1_n_7 ;
  wire \sum_reg_125_reg[24]_i_1_n_8 ;
  wire \sum_reg_125_reg[24]_i_1_n_9 ;
  wire \sum_reg_125_reg[28]_i_1_n_2 ;
  wire \sum_reg_125_reg[28]_i_1_n_3 ;
  wire \sum_reg_125_reg[28]_i_1_n_4 ;
  wire \sum_reg_125_reg[28]_i_1_n_5 ;
  wire \sum_reg_125_reg[28]_i_1_n_6 ;
  wire \sum_reg_125_reg[28]_i_1_n_7 ;
  wire \sum_reg_125_reg[28]_i_1_n_8 ;
  wire \sum_reg_125_reg[28]_i_1_n_9 ;
  wire \sum_reg_125_reg[32]_i_1_n_2 ;
  wire \sum_reg_125_reg[32]_i_1_n_3 ;
  wire \sum_reg_125_reg[32]_i_1_n_4 ;
  wire \sum_reg_125_reg[32]_i_1_n_5 ;
  wire \sum_reg_125_reg[32]_i_1_n_6 ;
  wire \sum_reg_125_reg[32]_i_1_n_7 ;
  wire \sum_reg_125_reg[32]_i_1_n_8 ;
  wire \sum_reg_125_reg[32]_i_1_n_9 ;
  wire \sum_reg_125_reg[36]_i_1_n_2 ;
  wire \sum_reg_125_reg[36]_i_1_n_3 ;
  wire \sum_reg_125_reg[36]_i_1_n_4 ;
  wire \sum_reg_125_reg[36]_i_1_n_5 ;
  wire \sum_reg_125_reg[36]_i_1_n_6 ;
  wire \sum_reg_125_reg[36]_i_1_n_7 ;
  wire \sum_reg_125_reg[36]_i_1_n_8 ;
  wire \sum_reg_125_reg[36]_i_1_n_9 ;
  wire \sum_reg_125_reg[40]_i_1_n_2 ;
  wire \sum_reg_125_reg[40]_i_1_n_3 ;
  wire \sum_reg_125_reg[40]_i_1_n_4 ;
  wire \sum_reg_125_reg[40]_i_1_n_5 ;
  wire \sum_reg_125_reg[40]_i_1_n_6 ;
  wire \sum_reg_125_reg[40]_i_1_n_7 ;
  wire \sum_reg_125_reg[40]_i_1_n_8 ;
  wire \sum_reg_125_reg[40]_i_1_n_9 ;
  wire \sum_reg_125_reg[44]_i_1_n_2 ;
  wire \sum_reg_125_reg[44]_i_1_n_3 ;
  wire \sum_reg_125_reg[44]_i_1_n_4 ;
  wire \sum_reg_125_reg[44]_i_1_n_5 ;
  wire \sum_reg_125_reg[44]_i_1_n_6 ;
  wire \sum_reg_125_reg[44]_i_1_n_7 ;
  wire \sum_reg_125_reg[44]_i_1_n_8 ;
  wire \sum_reg_125_reg[44]_i_1_n_9 ;
  wire \sum_reg_125_reg[48]_i_1_n_2 ;
  wire \sum_reg_125_reg[48]_i_1_n_3 ;
  wire \sum_reg_125_reg[48]_i_1_n_4 ;
  wire \sum_reg_125_reg[48]_i_1_n_5 ;
  wire \sum_reg_125_reg[48]_i_1_n_6 ;
  wire \sum_reg_125_reg[48]_i_1_n_7 ;
  wire \sum_reg_125_reg[48]_i_1_n_8 ;
  wire \sum_reg_125_reg[48]_i_1_n_9 ;
  wire \sum_reg_125_reg[4]_i_1_n_2 ;
  wire \sum_reg_125_reg[4]_i_1_n_3 ;
  wire \sum_reg_125_reg[4]_i_1_n_4 ;
  wire \sum_reg_125_reg[4]_i_1_n_5 ;
  wire \sum_reg_125_reg[4]_i_1_n_6 ;
  wire \sum_reg_125_reg[4]_i_1_n_7 ;
  wire \sum_reg_125_reg[4]_i_1_n_8 ;
  wire \sum_reg_125_reg[4]_i_1_n_9 ;
  wire \sum_reg_125_reg[52]_i_1_n_2 ;
  wire \sum_reg_125_reg[52]_i_1_n_3 ;
  wire \sum_reg_125_reg[52]_i_1_n_4 ;
  wire \sum_reg_125_reg[52]_i_1_n_5 ;
  wire \sum_reg_125_reg[52]_i_1_n_6 ;
  wire \sum_reg_125_reg[52]_i_1_n_7 ;
  wire \sum_reg_125_reg[52]_i_1_n_8 ;
  wire \sum_reg_125_reg[52]_i_1_n_9 ;
  wire \sum_reg_125_reg[56]_i_1_n_2 ;
  wire \sum_reg_125_reg[56]_i_1_n_3 ;
  wire \sum_reg_125_reg[56]_i_1_n_4 ;
  wire \sum_reg_125_reg[56]_i_1_n_5 ;
  wire \sum_reg_125_reg[56]_i_1_n_6 ;
  wire \sum_reg_125_reg[56]_i_1_n_7 ;
  wire \sum_reg_125_reg[56]_i_1_n_8 ;
  wire \sum_reg_125_reg[56]_i_1_n_9 ;
  wire \sum_reg_125_reg[60]_i_1_n_3 ;
  wire \sum_reg_125_reg[60]_i_1_n_4 ;
  wire \sum_reg_125_reg[60]_i_1_n_5 ;
  wire \sum_reg_125_reg[60]_i_1_n_6 ;
  wire \sum_reg_125_reg[60]_i_1_n_7 ;
  wire \sum_reg_125_reg[60]_i_1_n_8 ;
  wire \sum_reg_125_reg[60]_i_1_n_9 ;
  wire \sum_reg_125_reg[8]_i_1_n_2 ;
  wire \sum_reg_125_reg[8]_i_1_n_3 ;
  wire \sum_reg_125_reg[8]_i_1_n_4 ;
  wire \sum_reg_125_reg[8]_i_1_n_5 ;
  wire \sum_reg_125_reg[8]_i_1_n_6 ;
  wire \sum_reg_125_reg[8]_i_1_n_7 ;
  wire \sum_reg_125_reg[8]_i_1_n_8 ;
  wire \sum_reg_125_reg[8]_i_1_n_9 ;
  wire [31:0]sum_reg_125_reg__0;
  wire [31:0]tmp_2_reg_270;
  wire [3:0]\NLW_i_reg_137_reg[0]_i_10_O_UNCONNECTED ;
  wire [3:3]\NLW_i_reg_137_reg[0]_i_4_CO_UNCONNECTED ;
  wire [3:0]\NLW_i_reg_137_reg[0]_i_4_O_UNCONNECTED ;
  wire [3:0]\NLW_i_reg_137_reg[0]_i_6_O_UNCONNECTED ;
  wire [3:3]\NLW_i_reg_137_reg[28]_i_1_CO_UNCONNECTED ;
  wire [3:3]\NLW_sum_reg_125_reg[60]_i_1_CO_UNCONNECTED ;

  assign m_axi_gmem_ARADDR[31:2] = \^m_axi_gmem_ARADDR [31:2];
  assign m_axi_gmem_ARADDR[1] = \<const0> ;
  assign m_axi_gmem_ARADDR[0] = \<const0> ;
  assign m_axi_gmem_ARBURST[1] = \<const0> ;
  assign m_axi_gmem_ARBURST[0] = \<const1> ;
  assign m_axi_gmem_ARCACHE[3] = \<const0> ;
  assign m_axi_gmem_ARCACHE[2] = \<const0> ;
  assign m_axi_gmem_ARCACHE[1] = \<const1> ;
  assign m_axi_gmem_ARCACHE[0] = \<const1> ;
  assign m_axi_gmem_ARID[0] = \<const0> ;
  assign m_axi_gmem_ARLEN[7] = \<const0> ;
  assign m_axi_gmem_ARLEN[6] = \<const0> ;
  assign m_axi_gmem_ARLEN[5] = \<const0> ;
  assign m_axi_gmem_ARLEN[4] = \<const0> ;
  assign m_axi_gmem_ARLEN[3:0] = \^m_axi_gmem_ARLEN [3:0];
  assign m_axi_gmem_ARLOCK[1] = \<const0> ;
  assign m_axi_gmem_ARLOCK[0] = \<const0> ;
  assign m_axi_gmem_ARPROT[2] = \<const0> ;
  assign m_axi_gmem_ARPROT[1] = \<const0> ;
  assign m_axi_gmem_ARPROT[0] = \<const0> ;
  assign m_axi_gmem_ARQOS[3] = \<const0> ;
  assign m_axi_gmem_ARQOS[2] = \<const0> ;
  assign m_axi_gmem_ARQOS[1] = \<const0> ;
  assign m_axi_gmem_ARQOS[0] = \<const0> ;
  assign m_axi_gmem_ARREGION[3] = \<const0> ;
  assign m_axi_gmem_ARREGION[2] = \<const0> ;
  assign m_axi_gmem_ARREGION[1] = \<const0> ;
  assign m_axi_gmem_ARREGION[0] = \<const0> ;
  assign m_axi_gmem_ARSIZE[2] = \<const0> ;
  assign m_axi_gmem_ARSIZE[1] = \<const1> ;
  assign m_axi_gmem_ARSIZE[0] = \<const0> ;
  assign m_axi_gmem_ARUSER[0] = \<const0> ;
  assign m_axi_gmem_AWADDR[31:2] = \^m_axi_gmem_AWADDR [31:2];
  assign m_axi_gmem_AWADDR[1] = \<const0> ;
  assign m_axi_gmem_AWADDR[0] = \<const0> ;
  assign m_axi_gmem_AWBURST[1] = \<const0> ;
  assign m_axi_gmem_AWBURST[0] = \<const1> ;
  assign m_axi_gmem_AWCACHE[3] = \<const0> ;
  assign m_axi_gmem_AWCACHE[2] = \<const0> ;
  assign m_axi_gmem_AWCACHE[1] = \<const1> ;
  assign m_axi_gmem_AWCACHE[0] = \<const1> ;
  assign m_axi_gmem_AWID[0] = \<const0> ;
  assign m_axi_gmem_AWLEN[7] = \<const0> ;
  assign m_axi_gmem_AWLEN[6] = \<const0> ;
  assign m_axi_gmem_AWLEN[5] = \<const0> ;
  assign m_axi_gmem_AWLEN[4] = \<const0> ;
  assign m_axi_gmem_AWLEN[3:0] = \^m_axi_gmem_AWLEN [3:0];
  assign m_axi_gmem_AWLOCK[1] = \<const0> ;
  assign m_axi_gmem_AWLOCK[0] = \<const0> ;
  assign m_axi_gmem_AWPROT[2] = \<const0> ;
  assign m_axi_gmem_AWPROT[1] = \<const0> ;
  assign m_axi_gmem_AWPROT[0] = \<const0> ;
  assign m_axi_gmem_AWQOS[3] = \<const0> ;
  assign m_axi_gmem_AWQOS[2] = \<const0> ;
  assign m_axi_gmem_AWQOS[1] = \<const0> ;
  assign m_axi_gmem_AWQOS[0] = \<const0> ;
  assign m_axi_gmem_AWREGION[3] = \<const0> ;
  assign m_axi_gmem_AWREGION[2] = \<const0> ;
  assign m_axi_gmem_AWREGION[1] = \<const0> ;
  assign m_axi_gmem_AWREGION[0] = \<const0> ;
  assign m_axi_gmem_AWSIZE[2] = \<const0> ;
  assign m_axi_gmem_AWSIZE[1] = \<const1> ;
  assign m_axi_gmem_AWSIZE[0] = \<const0> ;
  assign m_axi_gmem_AWUSER[0] = \<const0> ;
  assign m_axi_gmem_WID[0] = \<const0> ;
  assign m_axi_gmem_WUSER[0] = \<const0> ;
  assign s_axi_control_BRESP[1] = \<const0> ;
  assign s_axi_control_BRESP[0] = \<const0> ;
  assign s_axi_control_RRESP[1] = \<const0> ;
  assign s_axi_control_RRESP[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \ap_CS_fsm[1]_i_2 
       (.I0(ap_CS_fsm_pp0_stage0),
        .I1(\ap_CS_fsm_reg_n_2_[15] ),
        .I2(\ap_CS_fsm_reg_n_2_[0] ),
        .I3(\ap_CS_fsm_reg_n_2_[3] ),
        .I4(\ap_CS_fsm[1]_i_4_n_2 ),
        .I5(\ap_CS_fsm[1]_i_5_n_2 ),
        .O(\ap_CS_fsm[1]_i_2_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair210" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \ap_CS_fsm[1]_i_3 
       (.I0(ap_CS_fsm_state13),
        .I1(ap_CS_fsm_state14),
        .O(\ap_CS_fsm[1]_i_3_n_2 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \ap_CS_fsm[1]_i_4 
       (.I0(\ap_CS_fsm_reg_n_2_[12] ),
        .I1(\ap_CS_fsm_reg_n_2_[5] ),
        .I2(\ap_CS_fsm_reg_n_2_[14] ),
        .I3(ap_CS_fsm_state19),
        .O(\ap_CS_fsm[1]_i_4_n_2 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \ap_CS_fsm[1]_i_5 
       (.I0(\ap_CS_fsm_reg_n_2_[4] ),
        .I1(ap_CS_fsm_state12),
        .I2(\ap_CS_fsm_reg_n_2_[13] ),
        .I3(ap_CS_fsm_state8),
        .O(\ap_CS_fsm[1]_i_5_n_2 ));
  LUT3 #(
    .INIT(8'hBA)) 
    \ap_CS_fsm[8]_i_1 
       (.I0(ap_CS_fsm_state8),
        .I1(\ap_CS_fsm[9]_i_2_n_2 ),
        .I2(ap_CS_fsm_pp0_stage0),
        .O(ap_NS_fsm[8]));
  LUT4 #(
    .INIT(16'h00EA)) 
    \ap_CS_fsm[9]_i_2 
       (.I0(ap_enable_reg_pp0_iter2_reg_n_2),
        .I1(ap_enable_reg_pp0_iter0),
        .I2(ap_condition_pp0_exit_iter0_state9),
        .I3(ap_enable_reg_pp0_iter1_reg_n_2),
        .O(\ap_CS_fsm[9]_i_2_n_2 ));
  (* FSM_ENCODING = "none" *) 
  FDSE #(
    .INIT(1'b1)) 
    \ap_CS_fsm_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(ap_NS_fsm[0]),
        .Q(\ap_CS_fsm_reg_n_2_[0] ),
        .S(ap_rst_n_inv));
  (* FSM_ENCODING = "none" *) 
  FDRE #(
    .INIT(1'b0)) 
    \ap_CS_fsm_reg[10] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(ap_NS_fsm[10]),
        .Q(ap_CS_fsm_state13),
        .R(ap_rst_n_inv));
  (* FSM_ENCODING = "none" *) 
  FDRE #(
    .INIT(1'b0)) 
    \ap_CS_fsm_reg[11] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(ap_NS_fsm[11]),
        .Q(ap_CS_fsm_state14),
        .R(ap_rst_n_inv));
  (* FSM_ENCODING = "none" *) 
  FDRE #(
    .INIT(1'b0)) 
    \ap_CS_fsm_reg[12] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(ap_NS_fsm[12]),
        .Q(\ap_CS_fsm_reg_n_2_[12] ),
        .R(ap_rst_n_inv));
  (* FSM_ENCODING = "none" *) 
  FDRE #(
    .INIT(1'b0)) 
    \ap_CS_fsm_reg[13] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\ap_CS_fsm_reg_n_2_[12] ),
        .Q(\ap_CS_fsm_reg_n_2_[13] ),
        .R(ap_rst_n_inv));
  (* FSM_ENCODING = "none" *) 
  FDRE #(
    .INIT(1'b0)) 
    \ap_CS_fsm_reg[14] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\ap_CS_fsm_reg_n_2_[13] ),
        .Q(\ap_CS_fsm_reg_n_2_[14] ),
        .R(ap_rst_n_inv));
  (* FSM_ENCODING = "none" *) 
  FDRE #(
    .INIT(1'b0)) 
    \ap_CS_fsm_reg[15] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\ap_CS_fsm_reg_n_2_[14] ),
        .Q(\ap_CS_fsm_reg_n_2_[15] ),
        .R(ap_rst_n_inv));
  (* FSM_ENCODING = "none" *) 
  FDRE #(
    .INIT(1'b0)) 
    \ap_CS_fsm_reg[16] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(ap_NS_fsm[16]),
        .Q(ap_CS_fsm_state19),
        .R(ap_rst_n_inv));
  (* FSM_ENCODING = "none" *) 
  FDRE #(
    .INIT(1'b0)) 
    \ap_CS_fsm_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(ap_NS_fsm[1]),
        .Q(ap_CS_fsm_state2),
        .R(ap_rst_n_inv));
  (* FSM_ENCODING = "none" *) 
  FDRE #(
    .INIT(1'b0)) 
    \ap_CS_fsm_reg[2] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\bus_read/rs_rreq/load_p2 ),
        .Q(\ap_CS_fsm_reg_n_2_[2] ),
        .R(ap_rst_n_inv));
  (* FSM_ENCODING = "none" *) 
  FDRE #(
    .INIT(1'b0)) 
    \ap_CS_fsm_reg[3] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\ap_CS_fsm_reg_n_2_[2] ),
        .Q(\ap_CS_fsm_reg_n_2_[3] ),
        .R(ap_rst_n_inv));
  (* FSM_ENCODING = "none" *) 
  FDRE #(
    .INIT(1'b0)) 
    \ap_CS_fsm_reg[4] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\ap_CS_fsm_reg_n_2_[3] ),
        .Q(\ap_CS_fsm_reg_n_2_[4] ),
        .R(ap_rst_n_inv));
  (* FSM_ENCODING = "none" *) 
  FDRE #(
    .INIT(1'b0)) 
    \ap_CS_fsm_reg[5] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\ap_CS_fsm_reg_n_2_[4] ),
        .Q(\ap_CS_fsm_reg_n_2_[5] ),
        .R(ap_rst_n_inv));
  (* FSM_ENCODING = "none" *) 
  FDRE #(
    .INIT(1'b0)) 
    \ap_CS_fsm_reg[6] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\ap_CS_fsm_reg_n_2_[5] ),
        .Q(\ap_CS_fsm_reg_n_2_[6] ),
        .R(ap_rst_n_inv));
  (* FSM_ENCODING = "none" *) 
  FDRE #(
    .INIT(1'b0)) 
    \ap_CS_fsm_reg[7] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\ap_CS_fsm_reg_n_2_[6] ),
        .Q(ap_CS_fsm_state8),
        .R(ap_rst_n_inv));
  (* FSM_ENCODING = "none" *) 
  FDRE #(
    .INIT(1'b0)) 
    \ap_CS_fsm_reg[8] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(ap_NS_fsm[8]),
        .Q(ap_CS_fsm_pp0_stage0),
        .R(ap_rst_n_inv));
  (* FSM_ENCODING = "none" *) 
  FDRE #(
    .INIT(1'b0)) 
    \ap_CS_fsm_reg[9] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(ap_NS_fsm[9]),
        .Q(ap_CS_fsm_state12),
        .R(ap_rst_n_inv));
  FDRE #(
    .INIT(1'b0)) 
    ap_enable_reg_pp0_iter0_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(simple_accel_core_gmem_m_axi_U_n_29),
        .Q(ap_enable_reg_pp0_iter0),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    ap_enable_reg_pp0_iter1_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(simple_accel_core_gmem_m_axi_U_n_9),
        .Q(ap_enable_reg_pp0_iter1_reg_n_2),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    ap_enable_reg_pp0_iter2_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(simple_accel_core_gmem_m_axi_U_n_10),
        .Q(ap_enable_reg_pp0_iter2_reg_n_2),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair210" *) 
  LUT4 #(
    .INIT(16'h0020)) 
    ap_reg_ioackin_gmem_WREADY_i_1
       (.I0(ap_rst_n),
        .I1(ap_CS_fsm_state14),
        .I2(ap_reg_ioackin_gmem_WREADY),
        .I3(ap_CS_fsm_state13),
        .O(ap_reg_ioackin_gmem_WREADY_i_1_n_2));
  FDRE #(
    .INIT(1'b0)) 
    ap_reg_ioackin_gmem_WREADY_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(ap_reg_ioackin_gmem_WREADY_i_1_n_2),
        .Q(ap_reg_ioackin_gmem_WREADY),
        .R(1'b0));
  FDRE \exitcond_reg_251_pp0_iter1_reg_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(simple_accel_core_gmem_m_axi_U_n_91),
        .Q(exitcond_reg_251_pp0_iter1_reg),
        .R(1'b0));
  FDRE \exitcond_reg_251_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(simple_accel_core_gmem_m_axi_U_n_92),
        .Q(\exitcond_reg_251_reg_n_2_[0] ),
        .R(1'b0));
  FDRE \gmem_addr_1_read_reg_260_reg[0] 
       (.C(ap_clk),
        .CE(gmem_addr_1_read_reg_2600),
        .D(gmem_RDATA[0]),
        .Q(gmem_addr_1_read_reg_260[0]),
        .R(1'b0));
  FDRE \gmem_addr_1_read_reg_260_reg[10] 
       (.C(ap_clk),
        .CE(gmem_addr_1_read_reg_2600),
        .D(gmem_RDATA[10]),
        .Q(gmem_addr_1_read_reg_260[10]),
        .R(1'b0));
  FDRE \gmem_addr_1_read_reg_260_reg[11] 
       (.C(ap_clk),
        .CE(gmem_addr_1_read_reg_2600),
        .D(gmem_RDATA[11]),
        .Q(gmem_addr_1_read_reg_260[11]),
        .R(1'b0));
  FDRE \gmem_addr_1_read_reg_260_reg[12] 
       (.C(ap_clk),
        .CE(gmem_addr_1_read_reg_2600),
        .D(gmem_RDATA[12]),
        .Q(gmem_addr_1_read_reg_260[12]),
        .R(1'b0));
  FDRE \gmem_addr_1_read_reg_260_reg[13] 
       (.C(ap_clk),
        .CE(gmem_addr_1_read_reg_2600),
        .D(gmem_RDATA[13]),
        .Q(gmem_addr_1_read_reg_260[13]),
        .R(1'b0));
  FDRE \gmem_addr_1_read_reg_260_reg[14] 
       (.C(ap_clk),
        .CE(gmem_addr_1_read_reg_2600),
        .D(gmem_RDATA[14]),
        .Q(gmem_addr_1_read_reg_260[14]),
        .R(1'b0));
  FDRE \gmem_addr_1_read_reg_260_reg[15] 
       (.C(ap_clk),
        .CE(gmem_addr_1_read_reg_2600),
        .D(gmem_RDATA[15]),
        .Q(gmem_addr_1_read_reg_260[15]),
        .R(1'b0));
  FDRE \gmem_addr_1_read_reg_260_reg[16] 
       (.C(ap_clk),
        .CE(gmem_addr_1_read_reg_2600),
        .D(gmem_RDATA[16]),
        .Q(gmem_addr_1_read_reg_260[16]),
        .R(1'b0));
  FDRE \gmem_addr_1_read_reg_260_reg[17] 
       (.C(ap_clk),
        .CE(gmem_addr_1_read_reg_2600),
        .D(gmem_RDATA[17]),
        .Q(gmem_addr_1_read_reg_260[17]),
        .R(1'b0));
  FDRE \gmem_addr_1_read_reg_260_reg[18] 
       (.C(ap_clk),
        .CE(gmem_addr_1_read_reg_2600),
        .D(gmem_RDATA[18]),
        .Q(gmem_addr_1_read_reg_260[18]),
        .R(1'b0));
  FDRE \gmem_addr_1_read_reg_260_reg[19] 
       (.C(ap_clk),
        .CE(gmem_addr_1_read_reg_2600),
        .D(gmem_RDATA[19]),
        .Q(gmem_addr_1_read_reg_260[19]),
        .R(1'b0));
  FDRE \gmem_addr_1_read_reg_260_reg[1] 
       (.C(ap_clk),
        .CE(gmem_addr_1_read_reg_2600),
        .D(gmem_RDATA[1]),
        .Q(gmem_addr_1_read_reg_260[1]),
        .R(1'b0));
  FDRE \gmem_addr_1_read_reg_260_reg[20] 
       (.C(ap_clk),
        .CE(gmem_addr_1_read_reg_2600),
        .D(gmem_RDATA[20]),
        .Q(gmem_addr_1_read_reg_260[20]),
        .R(1'b0));
  FDRE \gmem_addr_1_read_reg_260_reg[21] 
       (.C(ap_clk),
        .CE(gmem_addr_1_read_reg_2600),
        .D(gmem_RDATA[21]),
        .Q(gmem_addr_1_read_reg_260[21]),
        .R(1'b0));
  FDRE \gmem_addr_1_read_reg_260_reg[22] 
       (.C(ap_clk),
        .CE(gmem_addr_1_read_reg_2600),
        .D(gmem_RDATA[22]),
        .Q(gmem_addr_1_read_reg_260[22]),
        .R(1'b0));
  FDRE \gmem_addr_1_read_reg_260_reg[23] 
       (.C(ap_clk),
        .CE(gmem_addr_1_read_reg_2600),
        .D(gmem_RDATA[23]),
        .Q(gmem_addr_1_read_reg_260[23]),
        .R(1'b0));
  FDRE \gmem_addr_1_read_reg_260_reg[24] 
       (.C(ap_clk),
        .CE(gmem_addr_1_read_reg_2600),
        .D(gmem_RDATA[24]),
        .Q(gmem_addr_1_read_reg_260[24]),
        .R(1'b0));
  FDRE \gmem_addr_1_read_reg_260_reg[25] 
       (.C(ap_clk),
        .CE(gmem_addr_1_read_reg_2600),
        .D(gmem_RDATA[25]),
        .Q(gmem_addr_1_read_reg_260[25]),
        .R(1'b0));
  FDRE \gmem_addr_1_read_reg_260_reg[26] 
       (.C(ap_clk),
        .CE(gmem_addr_1_read_reg_2600),
        .D(gmem_RDATA[26]),
        .Q(gmem_addr_1_read_reg_260[26]),
        .R(1'b0));
  FDRE \gmem_addr_1_read_reg_260_reg[27] 
       (.C(ap_clk),
        .CE(gmem_addr_1_read_reg_2600),
        .D(gmem_RDATA[27]),
        .Q(gmem_addr_1_read_reg_260[27]),
        .R(1'b0));
  FDRE \gmem_addr_1_read_reg_260_reg[28] 
       (.C(ap_clk),
        .CE(gmem_addr_1_read_reg_2600),
        .D(gmem_RDATA[28]),
        .Q(gmem_addr_1_read_reg_260[28]),
        .R(1'b0));
  FDRE \gmem_addr_1_read_reg_260_reg[29] 
       (.C(ap_clk),
        .CE(gmem_addr_1_read_reg_2600),
        .D(gmem_RDATA[29]),
        .Q(gmem_addr_1_read_reg_260[29]),
        .R(1'b0));
  FDRE \gmem_addr_1_read_reg_260_reg[2] 
       (.C(ap_clk),
        .CE(gmem_addr_1_read_reg_2600),
        .D(gmem_RDATA[2]),
        .Q(gmem_addr_1_read_reg_260[2]),
        .R(1'b0));
  FDRE \gmem_addr_1_read_reg_260_reg[30] 
       (.C(ap_clk),
        .CE(gmem_addr_1_read_reg_2600),
        .D(gmem_RDATA[30]),
        .Q(gmem_addr_1_read_reg_260[30]),
        .R(1'b0));
  FDRE \gmem_addr_1_read_reg_260_reg[31] 
       (.C(ap_clk),
        .CE(gmem_addr_1_read_reg_2600),
        .D(gmem_RDATA[31]),
        .Q(gmem_addr_1_read_reg_260[31]),
        .R(1'b0));
  FDRE \gmem_addr_1_read_reg_260_reg[3] 
       (.C(ap_clk),
        .CE(gmem_addr_1_read_reg_2600),
        .D(gmem_RDATA[3]),
        .Q(gmem_addr_1_read_reg_260[3]),
        .R(1'b0));
  FDRE \gmem_addr_1_read_reg_260_reg[4] 
       (.C(ap_clk),
        .CE(gmem_addr_1_read_reg_2600),
        .D(gmem_RDATA[4]),
        .Q(gmem_addr_1_read_reg_260[4]),
        .R(1'b0));
  FDRE \gmem_addr_1_read_reg_260_reg[5] 
       (.C(ap_clk),
        .CE(gmem_addr_1_read_reg_2600),
        .D(gmem_RDATA[5]),
        .Q(gmem_addr_1_read_reg_260[5]),
        .R(1'b0));
  FDRE \gmem_addr_1_read_reg_260_reg[6] 
       (.C(ap_clk),
        .CE(gmem_addr_1_read_reg_2600),
        .D(gmem_RDATA[6]),
        .Q(gmem_addr_1_read_reg_260[6]),
        .R(1'b0));
  FDRE \gmem_addr_1_read_reg_260_reg[7] 
       (.C(ap_clk),
        .CE(gmem_addr_1_read_reg_2600),
        .D(gmem_RDATA[7]),
        .Q(gmem_addr_1_read_reg_260[7]),
        .R(1'b0));
  FDRE \gmem_addr_1_read_reg_260_reg[8] 
       (.C(ap_clk),
        .CE(gmem_addr_1_read_reg_2600),
        .D(gmem_RDATA[8]),
        .Q(gmem_addr_1_read_reg_260[8]),
        .R(1'b0));
  FDRE \gmem_addr_1_read_reg_260_reg[9] 
       (.C(ap_clk),
        .CE(gmem_addr_1_read_reg_2600),
        .D(gmem_RDATA[9]),
        .Q(gmem_addr_1_read_reg_260[9]),
        .R(1'b0));
  FDRE \gmem_addr_reg_244_reg[0] 
       (.C(ap_clk),
        .CE(ap_CS_fsm_state8),
        .D(out_buf3_reg_228[0]),
        .Q(gmem_addr_reg_244[0]),
        .R(1'b0));
  FDRE \gmem_addr_reg_244_reg[10] 
       (.C(ap_clk),
        .CE(ap_CS_fsm_state8),
        .D(out_buf3_reg_228[10]),
        .Q(gmem_addr_reg_244[10]),
        .R(1'b0));
  FDRE \gmem_addr_reg_244_reg[11] 
       (.C(ap_clk),
        .CE(ap_CS_fsm_state8),
        .D(out_buf3_reg_228[11]),
        .Q(gmem_addr_reg_244[11]),
        .R(1'b0));
  FDRE \gmem_addr_reg_244_reg[12] 
       (.C(ap_clk),
        .CE(ap_CS_fsm_state8),
        .D(out_buf3_reg_228[12]),
        .Q(gmem_addr_reg_244[12]),
        .R(1'b0));
  FDRE \gmem_addr_reg_244_reg[13] 
       (.C(ap_clk),
        .CE(ap_CS_fsm_state8),
        .D(out_buf3_reg_228[13]),
        .Q(gmem_addr_reg_244[13]),
        .R(1'b0));
  FDRE \gmem_addr_reg_244_reg[14] 
       (.C(ap_clk),
        .CE(ap_CS_fsm_state8),
        .D(out_buf3_reg_228[14]),
        .Q(gmem_addr_reg_244[14]),
        .R(1'b0));
  FDRE \gmem_addr_reg_244_reg[15] 
       (.C(ap_clk),
        .CE(ap_CS_fsm_state8),
        .D(out_buf3_reg_228[15]),
        .Q(gmem_addr_reg_244[15]),
        .R(1'b0));
  FDRE \gmem_addr_reg_244_reg[16] 
       (.C(ap_clk),
        .CE(ap_CS_fsm_state8),
        .D(out_buf3_reg_228[16]),
        .Q(gmem_addr_reg_244[16]),
        .R(1'b0));
  FDRE \gmem_addr_reg_244_reg[17] 
       (.C(ap_clk),
        .CE(ap_CS_fsm_state8),
        .D(out_buf3_reg_228[17]),
        .Q(gmem_addr_reg_244[17]),
        .R(1'b0));
  FDRE \gmem_addr_reg_244_reg[18] 
       (.C(ap_clk),
        .CE(ap_CS_fsm_state8),
        .D(out_buf3_reg_228[18]),
        .Q(gmem_addr_reg_244[18]),
        .R(1'b0));
  FDRE \gmem_addr_reg_244_reg[19] 
       (.C(ap_clk),
        .CE(ap_CS_fsm_state8),
        .D(out_buf3_reg_228[19]),
        .Q(gmem_addr_reg_244[19]),
        .R(1'b0));
  FDRE \gmem_addr_reg_244_reg[1] 
       (.C(ap_clk),
        .CE(ap_CS_fsm_state8),
        .D(out_buf3_reg_228[1]),
        .Q(gmem_addr_reg_244[1]),
        .R(1'b0));
  FDRE \gmem_addr_reg_244_reg[20] 
       (.C(ap_clk),
        .CE(ap_CS_fsm_state8),
        .D(out_buf3_reg_228[20]),
        .Q(gmem_addr_reg_244[20]),
        .R(1'b0));
  FDRE \gmem_addr_reg_244_reg[21] 
       (.C(ap_clk),
        .CE(ap_CS_fsm_state8),
        .D(out_buf3_reg_228[21]),
        .Q(gmem_addr_reg_244[21]),
        .R(1'b0));
  FDRE \gmem_addr_reg_244_reg[22] 
       (.C(ap_clk),
        .CE(ap_CS_fsm_state8),
        .D(out_buf3_reg_228[22]),
        .Q(gmem_addr_reg_244[22]),
        .R(1'b0));
  FDRE \gmem_addr_reg_244_reg[23] 
       (.C(ap_clk),
        .CE(ap_CS_fsm_state8),
        .D(out_buf3_reg_228[23]),
        .Q(gmem_addr_reg_244[23]),
        .R(1'b0));
  FDRE \gmem_addr_reg_244_reg[24] 
       (.C(ap_clk),
        .CE(ap_CS_fsm_state8),
        .D(out_buf3_reg_228[24]),
        .Q(gmem_addr_reg_244[24]),
        .R(1'b0));
  FDRE \gmem_addr_reg_244_reg[25] 
       (.C(ap_clk),
        .CE(ap_CS_fsm_state8),
        .D(out_buf3_reg_228[25]),
        .Q(gmem_addr_reg_244[25]),
        .R(1'b0));
  FDRE \gmem_addr_reg_244_reg[26] 
       (.C(ap_clk),
        .CE(ap_CS_fsm_state8),
        .D(out_buf3_reg_228[26]),
        .Q(gmem_addr_reg_244[26]),
        .R(1'b0));
  FDRE \gmem_addr_reg_244_reg[27] 
       (.C(ap_clk),
        .CE(ap_CS_fsm_state8),
        .D(out_buf3_reg_228[27]),
        .Q(gmem_addr_reg_244[27]),
        .R(1'b0));
  FDRE \gmem_addr_reg_244_reg[28] 
       (.C(ap_clk),
        .CE(ap_CS_fsm_state8),
        .D(out_buf3_reg_228[28]),
        .Q(gmem_addr_reg_244[28]),
        .R(1'b0));
  FDRE \gmem_addr_reg_244_reg[29] 
       (.C(ap_clk),
        .CE(ap_CS_fsm_state8),
        .D(out_buf3_reg_228[29]),
        .Q(gmem_addr_reg_244[29]),
        .R(1'b0));
  FDRE \gmem_addr_reg_244_reg[2] 
       (.C(ap_clk),
        .CE(ap_CS_fsm_state8),
        .D(out_buf3_reg_228[2]),
        .Q(gmem_addr_reg_244[2]),
        .R(1'b0));
  FDRE \gmem_addr_reg_244_reg[3] 
       (.C(ap_clk),
        .CE(ap_CS_fsm_state8),
        .D(out_buf3_reg_228[3]),
        .Q(gmem_addr_reg_244[3]),
        .R(1'b0));
  FDRE \gmem_addr_reg_244_reg[4] 
       (.C(ap_clk),
        .CE(ap_CS_fsm_state8),
        .D(out_buf3_reg_228[4]),
        .Q(gmem_addr_reg_244[4]),
        .R(1'b0));
  FDRE \gmem_addr_reg_244_reg[5] 
       (.C(ap_clk),
        .CE(ap_CS_fsm_state8),
        .D(out_buf3_reg_228[5]),
        .Q(gmem_addr_reg_244[5]),
        .R(1'b0));
  FDRE \gmem_addr_reg_244_reg[6] 
       (.C(ap_clk),
        .CE(ap_CS_fsm_state8),
        .D(out_buf3_reg_228[6]),
        .Q(gmem_addr_reg_244[6]),
        .R(1'b0));
  FDRE \gmem_addr_reg_244_reg[7] 
       (.C(ap_clk),
        .CE(ap_CS_fsm_state8),
        .D(out_buf3_reg_228[7]),
        .Q(gmem_addr_reg_244[7]),
        .R(1'b0));
  FDRE \gmem_addr_reg_244_reg[8] 
       (.C(ap_clk),
        .CE(ap_CS_fsm_state8),
        .D(out_buf3_reg_228[8]),
        .Q(gmem_addr_reg_244[8]),
        .R(1'b0));
  FDRE \gmem_addr_reg_244_reg[9] 
       (.C(ap_clk),
        .CE(ap_CS_fsm_state8),
        .D(out_buf3_reg_228[9]),
        .Q(gmem_addr_reg_244[9]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    \i_reg_137[0]_i_11 
       (.I0(num_items_read_reg_222[22]),
        .I1(i_reg_137_reg[22]),
        .I2(num_items_read_reg_222[23]),
        .I3(i_reg_137_reg[23]),
        .I4(i_reg_137_reg[21]),
        .I5(num_items_read_reg_222[21]),
        .O(\i_reg_137[0]_i_11_n_2 ));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    \i_reg_137[0]_i_12 
       (.I0(num_items_read_reg_222[18]),
        .I1(i_reg_137_reg[18]),
        .I2(num_items_read_reg_222[20]),
        .I3(i_reg_137_reg[20]),
        .I4(i_reg_137_reg[19]),
        .I5(num_items_read_reg_222[19]),
        .O(\i_reg_137[0]_i_12_n_2 ));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    \i_reg_137[0]_i_13 
       (.I0(num_items_read_reg_222[15]),
        .I1(i_reg_137_reg[15]),
        .I2(num_items_read_reg_222[16]),
        .I3(i_reg_137_reg[16]),
        .I4(i_reg_137_reg[17]),
        .I5(num_items_read_reg_222[17]),
        .O(\i_reg_137[0]_i_13_n_2 ));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    \i_reg_137[0]_i_14 
       (.I0(num_items_read_reg_222[13]),
        .I1(i_reg_137_reg[13]),
        .I2(num_items_read_reg_222[14]),
        .I3(i_reg_137_reg[14]),
        .I4(i_reg_137_reg[12]),
        .I5(num_items_read_reg_222[12]),
        .O(\i_reg_137[0]_i_14_n_2 ));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    \i_reg_137[0]_i_15 
       (.I0(num_items_read_reg_222[10]),
        .I1(i_reg_137_reg[10]),
        .I2(num_items_read_reg_222[11]),
        .I3(i_reg_137_reg[11]),
        .I4(i_reg_137_reg[9]),
        .I5(num_items_read_reg_222[9]),
        .O(\i_reg_137[0]_i_15_n_2 ));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    \i_reg_137[0]_i_16 
       (.I0(num_items_read_reg_222[7]),
        .I1(i_reg_137_reg[7]),
        .I2(num_items_read_reg_222[8]),
        .I3(i_reg_137_reg[8]),
        .I4(i_reg_137_reg[6]),
        .I5(num_items_read_reg_222[6]),
        .O(\i_reg_137[0]_i_16_n_2 ));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    \i_reg_137[0]_i_17 
       (.I0(num_items_read_reg_222[3]),
        .I1(i_reg_137_reg[3]),
        .I2(num_items_read_reg_222[5]),
        .I3(i_reg_137_reg[5]),
        .I4(i_reg_137_reg[4]),
        .I5(num_items_read_reg_222[4]),
        .O(\i_reg_137[0]_i_17_n_2 ));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    \i_reg_137[0]_i_18 
       (.I0(i_reg_137_reg[0]),
        .I1(num_items_read_reg_222[0]),
        .I2(num_items_read_reg_222[2]),
        .I3(i_reg_137_reg[2]),
        .I4(i_reg_137_reg[1]),
        .I5(num_items_read_reg_222[1]),
        .O(\i_reg_137[0]_i_18_n_2 ));
  LUT1 #(
    .INIT(2'h1)) 
    \i_reg_137[0]_i_5 
       (.I0(i_reg_137_reg[0]),
        .O(\i_reg_137[0]_i_5_n_2 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \i_reg_137[0]_i_7 
       (.I0(i_reg_137_reg[31]),
        .I1(num_items_read_reg_222[31]),
        .I2(i_reg_137_reg[30]),
        .I3(num_items_read_reg_222[30]),
        .O(\i_reg_137[0]_i_7_n_2 ));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    \i_reg_137[0]_i_8 
       (.I0(num_items_read_reg_222[28]),
        .I1(i_reg_137_reg[28]),
        .I2(num_items_read_reg_222[29]),
        .I3(i_reg_137_reg[29]),
        .I4(i_reg_137_reg[27]),
        .I5(num_items_read_reg_222[27]),
        .O(\i_reg_137[0]_i_8_n_2 ));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    \i_reg_137[0]_i_9 
       (.I0(num_items_read_reg_222[25]),
        .I1(i_reg_137_reg[25]),
        .I2(num_items_read_reg_222[26]),
        .I3(i_reg_137_reg[26]),
        .I4(i_reg_137_reg[24]),
        .I5(num_items_read_reg_222[24]),
        .O(\i_reg_137[0]_i_9_n_2 ));
  FDRE \i_reg_137_reg[0] 
       (.C(ap_clk),
        .CE(i_reg_1370),
        .D(\i_reg_137_reg[0]_i_3_n_9 ),
        .Q(i_reg_137_reg[0]),
        .R(i_reg_137));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \i_reg_137_reg[0]_i_10 
       (.CI(1'b0),
        .CO({\i_reg_137_reg[0]_i_10_n_2 ,\i_reg_137_reg[0]_i_10_n_3 ,\i_reg_137_reg[0]_i_10_n_4 ,\i_reg_137_reg[0]_i_10_n_5 }),
        .CYINIT(1'b1),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(\NLW_i_reg_137_reg[0]_i_10_O_UNCONNECTED [3:0]),
        .S({\i_reg_137[0]_i_15_n_2 ,\i_reg_137[0]_i_16_n_2 ,\i_reg_137[0]_i_17_n_2 ,\i_reg_137[0]_i_18_n_2 }));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \i_reg_137_reg[0]_i_3 
       (.CI(1'b0),
        .CO({\i_reg_137_reg[0]_i_3_n_2 ,\i_reg_137_reg[0]_i_3_n_3 ,\i_reg_137_reg[0]_i_3_n_4 ,\i_reg_137_reg[0]_i_3_n_5 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b1}),
        .O({\i_reg_137_reg[0]_i_3_n_6 ,\i_reg_137_reg[0]_i_3_n_7 ,\i_reg_137_reg[0]_i_3_n_8 ,\i_reg_137_reg[0]_i_3_n_9 }),
        .S({i_reg_137_reg[3:1],\i_reg_137[0]_i_5_n_2 }));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \i_reg_137_reg[0]_i_4 
       (.CI(\i_reg_137_reg[0]_i_6_n_2 ),
        .CO({\NLW_i_reg_137_reg[0]_i_4_CO_UNCONNECTED [3],ap_condition_pp0_exit_iter0_state9,\i_reg_137_reg[0]_i_4_n_4 ,\i_reg_137_reg[0]_i_4_n_5 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(\NLW_i_reg_137_reg[0]_i_4_O_UNCONNECTED [3:0]),
        .S({1'b0,\i_reg_137[0]_i_7_n_2 ,\i_reg_137[0]_i_8_n_2 ,\i_reg_137[0]_i_9_n_2 }));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \i_reg_137_reg[0]_i_6 
       (.CI(\i_reg_137_reg[0]_i_10_n_2 ),
        .CO({\i_reg_137_reg[0]_i_6_n_2 ,\i_reg_137_reg[0]_i_6_n_3 ,\i_reg_137_reg[0]_i_6_n_4 ,\i_reg_137_reg[0]_i_6_n_5 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(\NLW_i_reg_137_reg[0]_i_6_O_UNCONNECTED [3:0]),
        .S({\i_reg_137[0]_i_11_n_2 ,\i_reg_137[0]_i_12_n_2 ,\i_reg_137[0]_i_13_n_2 ,\i_reg_137[0]_i_14_n_2 }));
  FDRE \i_reg_137_reg[10] 
       (.C(ap_clk),
        .CE(i_reg_1370),
        .D(\i_reg_137_reg[8]_i_1_n_7 ),
        .Q(i_reg_137_reg[10]),
        .R(i_reg_137));
  FDRE \i_reg_137_reg[11] 
       (.C(ap_clk),
        .CE(i_reg_1370),
        .D(\i_reg_137_reg[8]_i_1_n_6 ),
        .Q(i_reg_137_reg[11]),
        .R(i_reg_137));
  FDRE \i_reg_137_reg[12] 
       (.C(ap_clk),
        .CE(i_reg_1370),
        .D(\i_reg_137_reg[12]_i_1_n_9 ),
        .Q(i_reg_137_reg[12]),
        .R(i_reg_137));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \i_reg_137_reg[12]_i_1 
       (.CI(\i_reg_137_reg[8]_i_1_n_2 ),
        .CO({\i_reg_137_reg[12]_i_1_n_2 ,\i_reg_137_reg[12]_i_1_n_3 ,\i_reg_137_reg[12]_i_1_n_4 ,\i_reg_137_reg[12]_i_1_n_5 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\i_reg_137_reg[12]_i_1_n_6 ,\i_reg_137_reg[12]_i_1_n_7 ,\i_reg_137_reg[12]_i_1_n_8 ,\i_reg_137_reg[12]_i_1_n_9 }),
        .S(i_reg_137_reg[15:12]));
  FDRE \i_reg_137_reg[13] 
       (.C(ap_clk),
        .CE(i_reg_1370),
        .D(\i_reg_137_reg[12]_i_1_n_8 ),
        .Q(i_reg_137_reg[13]),
        .R(i_reg_137));
  FDRE \i_reg_137_reg[14] 
       (.C(ap_clk),
        .CE(i_reg_1370),
        .D(\i_reg_137_reg[12]_i_1_n_7 ),
        .Q(i_reg_137_reg[14]),
        .R(i_reg_137));
  FDRE \i_reg_137_reg[15] 
       (.C(ap_clk),
        .CE(i_reg_1370),
        .D(\i_reg_137_reg[12]_i_1_n_6 ),
        .Q(i_reg_137_reg[15]),
        .R(i_reg_137));
  FDRE \i_reg_137_reg[16] 
       (.C(ap_clk),
        .CE(i_reg_1370),
        .D(\i_reg_137_reg[16]_i_1_n_9 ),
        .Q(i_reg_137_reg[16]),
        .R(i_reg_137));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \i_reg_137_reg[16]_i_1 
       (.CI(\i_reg_137_reg[12]_i_1_n_2 ),
        .CO({\i_reg_137_reg[16]_i_1_n_2 ,\i_reg_137_reg[16]_i_1_n_3 ,\i_reg_137_reg[16]_i_1_n_4 ,\i_reg_137_reg[16]_i_1_n_5 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\i_reg_137_reg[16]_i_1_n_6 ,\i_reg_137_reg[16]_i_1_n_7 ,\i_reg_137_reg[16]_i_1_n_8 ,\i_reg_137_reg[16]_i_1_n_9 }),
        .S(i_reg_137_reg[19:16]));
  FDRE \i_reg_137_reg[17] 
       (.C(ap_clk),
        .CE(i_reg_1370),
        .D(\i_reg_137_reg[16]_i_1_n_8 ),
        .Q(i_reg_137_reg[17]),
        .R(i_reg_137));
  FDRE \i_reg_137_reg[18] 
       (.C(ap_clk),
        .CE(i_reg_1370),
        .D(\i_reg_137_reg[16]_i_1_n_7 ),
        .Q(i_reg_137_reg[18]),
        .R(i_reg_137));
  FDRE \i_reg_137_reg[19] 
       (.C(ap_clk),
        .CE(i_reg_1370),
        .D(\i_reg_137_reg[16]_i_1_n_6 ),
        .Q(i_reg_137_reg[19]),
        .R(i_reg_137));
  FDRE \i_reg_137_reg[1] 
       (.C(ap_clk),
        .CE(i_reg_1370),
        .D(\i_reg_137_reg[0]_i_3_n_8 ),
        .Q(i_reg_137_reg[1]),
        .R(i_reg_137));
  FDRE \i_reg_137_reg[20] 
       (.C(ap_clk),
        .CE(i_reg_1370),
        .D(\i_reg_137_reg[20]_i_1_n_9 ),
        .Q(i_reg_137_reg[20]),
        .R(i_reg_137));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \i_reg_137_reg[20]_i_1 
       (.CI(\i_reg_137_reg[16]_i_1_n_2 ),
        .CO({\i_reg_137_reg[20]_i_1_n_2 ,\i_reg_137_reg[20]_i_1_n_3 ,\i_reg_137_reg[20]_i_1_n_4 ,\i_reg_137_reg[20]_i_1_n_5 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\i_reg_137_reg[20]_i_1_n_6 ,\i_reg_137_reg[20]_i_1_n_7 ,\i_reg_137_reg[20]_i_1_n_8 ,\i_reg_137_reg[20]_i_1_n_9 }),
        .S(i_reg_137_reg[23:20]));
  FDRE \i_reg_137_reg[21] 
       (.C(ap_clk),
        .CE(i_reg_1370),
        .D(\i_reg_137_reg[20]_i_1_n_8 ),
        .Q(i_reg_137_reg[21]),
        .R(i_reg_137));
  FDRE \i_reg_137_reg[22] 
       (.C(ap_clk),
        .CE(i_reg_1370),
        .D(\i_reg_137_reg[20]_i_1_n_7 ),
        .Q(i_reg_137_reg[22]),
        .R(i_reg_137));
  FDRE \i_reg_137_reg[23] 
       (.C(ap_clk),
        .CE(i_reg_1370),
        .D(\i_reg_137_reg[20]_i_1_n_6 ),
        .Q(i_reg_137_reg[23]),
        .R(i_reg_137));
  FDRE \i_reg_137_reg[24] 
       (.C(ap_clk),
        .CE(i_reg_1370),
        .D(\i_reg_137_reg[24]_i_1_n_9 ),
        .Q(i_reg_137_reg[24]),
        .R(i_reg_137));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \i_reg_137_reg[24]_i_1 
       (.CI(\i_reg_137_reg[20]_i_1_n_2 ),
        .CO({\i_reg_137_reg[24]_i_1_n_2 ,\i_reg_137_reg[24]_i_1_n_3 ,\i_reg_137_reg[24]_i_1_n_4 ,\i_reg_137_reg[24]_i_1_n_5 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\i_reg_137_reg[24]_i_1_n_6 ,\i_reg_137_reg[24]_i_1_n_7 ,\i_reg_137_reg[24]_i_1_n_8 ,\i_reg_137_reg[24]_i_1_n_9 }),
        .S(i_reg_137_reg[27:24]));
  FDRE \i_reg_137_reg[25] 
       (.C(ap_clk),
        .CE(i_reg_1370),
        .D(\i_reg_137_reg[24]_i_1_n_8 ),
        .Q(i_reg_137_reg[25]),
        .R(i_reg_137));
  FDRE \i_reg_137_reg[26] 
       (.C(ap_clk),
        .CE(i_reg_1370),
        .D(\i_reg_137_reg[24]_i_1_n_7 ),
        .Q(i_reg_137_reg[26]),
        .R(i_reg_137));
  FDRE \i_reg_137_reg[27] 
       (.C(ap_clk),
        .CE(i_reg_1370),
        .D(\i_reg_137_reg[24]_i_1_n_6 ),
        .Q(i_reg_137_reg[27]),
        .R(i_reg_137));
  FDRE \i_reg_137_reg[28] 
       (.C(ap_clk),
        .CE(i_reg_1370),
        .D(\i_reg_137_reg[28]_i_1_n_9 ),
        .Q(i_reg_137_reg[28]),
        .R(i_reg_137));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \i_reg_137_reg[28]_i_1 
       (.CI(\i_reg_137_reg[24]_i_1_n_2 ),
        .CO({\NLW_i_reg_137_reg[28]_i_1_CO_UNCONNECTED [3],\i_reg_137_reg[28]_i_1_n_3 ,\i_reg_137_reg[28]_i_1_n_4 ,\i_reg_137_reg[28]_i_1_n_5 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\i_reg_137_reg[28]_i_1_n_6 ,\i_reg_137_reg[28]_i_1_n_7 ,\i_reg_137_reg[28]_i_1_n_8 ,\i_reg_137_reg[28]_i_1_n_9 }),
        .S(i_reg_137_reg[31:28]));
  FDRE \i_reg_137_reg[29] 
       (.C(ap_clk),
        .CE(i_reg_1370),
        .D(\i_reg_137_reg[28]_i_1_n_8 ),
        .Q(i_reg_137_reg[29]),
        .R(i_reg_137));
  FDRE \i_reg_137_reg[2] 
       (.C(ap_clk),
        .CE(i_reg_1370),
        .D(\i_reg_137_reg[0]_i_3_n_7 ),
        .Q(i_reg_137_reg[2]),
        .R(i_reg_137));
  FDRE \i_reg_137_reg[30] 
       (.C(ap_clk),
        .CE(i_reg_1370),
        .D(\i_reg_137_reg[28]_i_1_n_7 ),
        .Q(i_reg_137_reg[30]),
        .R(i_reg_137));
  FDRE \i_reg_137_reg[31] 
       (.C(ap_clk),
        .CE(i_reg_1370),
        .D(\i_reg_137_reg[28]_i_1_n_6 ),
        .Q(i_reg_137_reg[31]),
        .R(i_reg_137));
  FDRE \i_reg_137_reg[3] 
       (.C(ap_clk),
        .CE(i_reg_1370),
        .D(\i_reg_137_reg[0]_i_3_n_6 ),
        .Q(i_reg_137_reg[3]),
        .R(i_reg_137));
  FDRE \i_reg_137_reg[4] 
       (.C(ap_clk),
        .CE(i_reg_1370),
        .D(\i_reg_137_reg[4]_i_1_n_9 ),
        .Q(i_reg_137_reg[4]),
        .R(i_reg_137));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \i_reg_137_reg[4]_i_1 
       (.CI(\i_reg_137_reg[0]_i_3_n_2 ),
        .CO({\i_reg_137_reg[4]_i_1_n_2 ,\i_reg_137_reg[4]_i_1_n_3 ,\i_reg_137_reg[4]_i_1_n_4 ,\i_reg_137_reg[4]_i_1_n_5 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\i_reg_137_reg[4]_i_1_n_6 ,\i_reg_137_reg[4]_i_1_n_7 ,\i_reg_137_reg[4]_i_1_n_8 ,\i_reg_137_reg[4]_i_1_n_9 }),
        .S(i_reg_137_reg[7:4]));
  FDRE \i_reg_137_reg[5] 
       (.C(ap_clk),
        .CE(i_reg_1370),
        .D(\i_reg_137_reg[4]_i_1_n_8 ),
        .Q(i_reg_137_reg[5]),
        .R(i_reg_137));
  FDRE \i_reg_137_reg[6] 
       (.C(ap_clk),
        .CE(i_reg_1370),
        .D(\i_reg_137_reg[4]_i_1_n_7 ),
        .Q(i_reg_137_reg[6]),
        .R(i_reg_137));
  FDRE \i_reg_137_reg[7] 
       (.C(ap_clk),
        .CE(i_reg_1370),
        .D(\i_reg_137_reg[4]_i_1_n_6 ),
        .Q(i_reg_137_reg[7]),
        .R(i_reg_137));
  FDRE \i_reg_137_reg[8] 
       (.C(ap_clk),
        .CE(i_reg_1370),
        .D(\i_reg_137_reg[8]_i_1_n_9 ),
        .Q(i_reg_137_reg[8]),
        .R(i_reg_137));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \i_reg_137_reg[8]_i_1 
       (.CI(\i_reg_137_reg[4]_i_1_n_2 ),
        .CO({\i_reg_137_reg[8]_i_1_n_2 ,\i_reg_137_reg[8]_i_1_n_3 ,\i_reg_137_reg[8]_i_1_n_4 ,\i_reg_137_reg[8]_i_1_n_5 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\i_reg_137_reg[8]_i_1_n_6 ,\i_reg_137_reg[8]_i_1_n_7 ,\i_reg_137_reg[8]_i_1_n_8 ,\i_reg_137_reg[8]_i_1_n_9 }),
        .S(i_reg_137_reg[11:8]));
  FDRE \i_reg_137_reg[9] 
       (.C(ap_clk),
        .CE(i_reg_1370),
        .D(\i_reg_137_reg[8]_i_1_n_8 ),
        .Q(i_reg_137_reg[9]),
        .R(i_reg_137));
  FDRE \in_buf1_reg_233_reg[0] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(in_buf[2]),
        .Q(in_buf1_reg_233[0]),
        .R(1'b0));
  FDRE \in_buf1_reg_233_reg[10] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(in_buf[12]),
        .Q(in_buf1_reg_233[10]),
        .R(1'b0));
  FDRE \in_buf1_reg_233_reg[11] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(in_buf[13]),
        .Q(in_buf1_reg_233[11]),
        .R(1'b0));
  FDRE \in_buf1_reg_233_reg[12] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(in_buf[14]),
        .Q(in_buf1_reg_233[12]),
        .R(1'b0));
  FDRE \in_buf1_reg_233_reg[13] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(in_buf[15]),
        .Q(in_buf1_reg_233[13]),
        .R(1'b0));
  FDRE \in_buf1_reg_233_reg[14] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(in_buf[16]),
        .Q(in_buf1_reg_233[14]),
        .R(1'b0));
  FDRE \in_buf1_reg_233_reg[15] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(in_buf[17]),
        .Q(in_buf1_reg_233[15]),
        .R(1'b0));
  FDRE \in_buf1_reg_233_reg[16] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(in_buf[18]),
        .Q(in_buf1_reg_233[16]),
        .R(1'b0));
  FDRE \in_buf1_reg_233_reg[17] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(in_buf[19]),
        .Q(in_buf1_reg_233[17]),
        .R(1'b0));
  FDRE \in_buf1_reg_233_reg[18] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(in_buf[20]),
        .Q(in_buf1_reg_233[18]),
        .R(1'b0));
  FDRE \in_buf1_reg_233_reg[19] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(in_buf[21]),
        .Q(in_buf1_reg_233[19]),
        .R(1'b0));
  FDRE \in_buf1_reg_233_reg[1] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(in_buf[3]),
        .Q(in_buf1_reg_233[1]),
        .R(1'b0));
  FDRE \in_buf1_reg_233_reg[20] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(in_buf[22]),
        .Q(in_buf1_reg_233[20]),
        .R(1'b0));
  FDRE \in_buf1_reg_233_reg[21] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(in_buf[23]),
        .Q(in_buf1_reg_233[21]),
        .R(1'b0));
  FDRE \in_buf1_reg_233_reg[22] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(in_buf[24]),
        .Q(in_buf1_reg_233[22]),
        .R(1'b0));
  FDRE \in_buf1_reg_233_reg[23] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(in_buf[25]),
        .Q(in_buf1_reg_233[23]),
        .R(1'b0));
  FDRE \in_buf1_reg_233_reg[24] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(in_buf[26]),
        .Q(in_buf1_reg_233[24]),
        .R(1'b0));
  FDRE \in_buf1_reg_233_reg[25] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(in_buf[27]),
        .Q(in_buf1_reg_233[25]),
        .R(1'b0));
  FDRE \in_buf1_reg_233_reg[26] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(in_buf[28]),
        .Q(in_buf1_reg_233[26]),
        .R(1'b0));
  FDRE \in_buf1_reg_233_reg[27] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(in_buf[29]),
        .Q(in_buf1_reg_233[27]),
        .R(1'b0));
  FDRE \in_buf1_reg_233_reg[28] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(in_buf[30]),
        .Q(in_buf1_reg_233[28]),
        .R(1'b0));
  FDRE \in_buf1_reg_233_reg[29] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(in_buf[31]),
        .Q(in_buf1_reg_233[29]),
        .R(1'b0));
  FDRE \in_buf1_reg_233_reg[2] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(in_buf[4]),
        .Q(in_buf1_reg_233[2]),
        .R(1'b0));
  FDRE \in_buf1_reg_233_reg[3] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(in_buf[5]),
        .Q(in_buf1_reg_233[3]),
        .R(1'b0));
  FDRE \in_buf1_reg_233_reg[4] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(in_buf[6]),
        .Q(in_buf1_reg_233[4]),
        .R(1'b0));
  FDRE \in_buf1_reg_233_reg[5] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(in_buf[7]),
        .Q(in_buf1_reg_233[5]),
        .R(1'b0));
  FDRE \in_buf1_reg_233_reg[6] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(in_buf[8]),
        .Q(in_buf1_reg_233[6]),
        .R(1'b0));
  FDRE \in_buf1_reg_233_reg[7] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(in_buf[9]),
        .Q(in_buf1_reg_233[7]),
        .R(1'b0));
  FDRE \in_buf1_reg_233_reg[8] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(in_buf[10]),
        .Q(in_buf1_reg_233[8]),
        .R(1'b0));
  FDRE \in_buf1_reg_233_reg[9] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(in_buf[11]),
        .Q(in_buf1_reg_233[9]),
        .R(1'b0));
  FDRE \num_items_read_reg_222_reg[0] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(num_items[0]),
        .Q(num_items_read_reg_222[0]),
        .R(1'b0));
  FDRE \num_items_read_reg_222_reg[10] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(num_items[10]),
        .Q(num_items_read_reg_222[10]),
        .R(1'b0));
  FDRE \num_items_read_reg_222_reg[11] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(num_items[11]),
        .Q(num_items_read_reg_222[11]),
        .R(1'b0));
  FDRE \num_items_read_reg_222_reg[12] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(num_items[12]),
        .Q(num_items_read_reg_222[12]),
        .R(1'b0));
  FDRE \num_items_read_reg_222_reg[13] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(num_items[13]),
        .Q(num_items_read_reg_222[13]),
        .R(1'b0));
  FDRE \num_items_read_reg_222_reg[14] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(num_items[14]),
        .Q(num_items_read_reg_222[14]),
        .R(1'b0));
  FDRE \num_items_read_reg_222_reg[15] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(num_items[15]),
        .Q(num_items_read_reg_222[15]),
        .R(1'b0));
  FDRE \num_items_read_reg_222_reg[16] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(num_items[16]),
        .Q(num_items_read_reg_222[16]),
        .R(1'b0));
  FDRE \num_items_read_reg_222_reg[17] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(num_items[17]),
        .Q(num_items_read_reg_222[17]),
        .R(1'b0));
  FDRE \num_items_read_reg_222_reg[18] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(num_items[18]),
        .Q(num_items_read_reg_222[18]),
        .R(1'b0));
  FDRE \num_items_read_reg_222_reg[19] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(num_items[19]),
        .Q(num_items_read_reg_222[19]),
        .R(1'b0));
  FDRE \num_items_read_reg_222_reg[1] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(num_items[1]),
        .Q(num_items_read_reg_222[1]),
        .R(1'b0));
  FDRE \num_items_read_reg_222_reg[20] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(num_items[20]),
        .Q(num_items_read_reg_222[20]),
        .R(1'b0));
  FDRE \num_items_read_reg_222_reg[21] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(num_items[21]),
        .Q(num_items_read_reg_222[21]),
        .R(1'b0));
  FDRE \num_items_read_reg_222_reg[22] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(num_items[22]),
        .Q(num_items_read_reg_222[22]),
        .R(1'b0));
  FDRE \num_items_read_reg_222_reg[23] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(num_items[23]),
        .Q(num_items_read_reg_222[23]),
        .R(1'b0));
  FDRE \num_items_read_reg_222_reg[24] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(num_items[24]),
        .Q(num_items_read_reg_222[24]),
        .R(1'b0));
  FDRE \num_items_read_reg_222_reg[25] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(num_items[25]),
        .Q(num_items_read_reg_222[25]),
        .R(1'b0));
  FDRE \num_items_read_reg_222_reg[26] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(num_items[26]),
        .Q(num_items_read_reg_222[26]),
        .R(1'b0));
  FDRE \num_items_read_reg_222_reg[27] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(num_items[27]),
        .Q(num_items_read_reg_222[27]),
        .R(1'b0));
  FDRE \num_items_read_reg_222_reg[28] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(num_items[28]),
        .Q(num_items_read_reg_222[28]),
        .R(1'b0));
  FDRE \num_items_read_reg_222_reg[29] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(num_items[29]),
        .Q(num_items_read_reg_222[29]),
        .R(1'b0));
  FDRE \num_items_read_reg_222_reg[2] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(num_items[2]),
        .Q(num_items_read_reg_222[2]),
        .R(1'b0));
  FDRE \num_items_read_reg_222_reg[30] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(num_items[30]),
        .Q(num_items_read_reg_222[30]),
        .R(1'b0));
  FDRE \num_items_read_reg_222_reg[31] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(num_items[31]),
        .Q(num_items_read_reg_222[31]),
        .R(1'b0));
  FDRE \num_items_read_reg_222_reg[3] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(num_items[3]),
        .Q(num_items_read_reg_222[3]),
        .R(1'b0));
  FDRE \num_items_read_reg_222_reg[4] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(num_items[4]),
        .Q(num_items_read_reg_222[4]),
        .R(1'b0));
  FDRE \num_items_read_reg_222_reg[5] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(num_items[5]),
        .Q(num_items_read_reg_222[5]),
        .R(1'b0));
  FDRE \num_items_read_reg_222_reg[6] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(num_items[6]),
        .Q(num_items_read_reg_222[6]),
        .R(1'b0));
  FDRE \num_items_read_reg_222_reg[7] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(num_items[7]),
        .Q(num_items_read_reg_222[7]),
        .R(1'b0));
  FDRE \num_items_read_reg_222_reg[8] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(num_items[8]),
        .Q(num_items_read_reg_222[8]),
        .R(1'b0));
  FDRE \num_items_read_reg_222_reg[9] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(num_items[9]),
        .Q(num_items_read_reg_222[9]),
        .R(1'b0));
  FDRE \out_buf3_reg_228_reg[0] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(out_buf[2]),
        .Q(out_buf3_reg_228[0]),
        .R(1'b0));
  FDRE \out_buf3_reg_228_reg[10] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(out_buf[12]),
        .Q(out_buf3_reg_228[10]),
        .R(1'b0));
  FDRE \out_buf3_reg_228_reg[11] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(out_buf[13]),
        .Q(out_buf3_reg_228[11]),
        .R(1'b0));
  FDRE \out_buf3_reg_228_reg[12] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(out_buf[14]),
        .Q(out_buf3_reg_228[12]),
        .R(1'b0));
  FDRE \out_buf3_reg_228_reg[13] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(out_buf[15]),
        .Q(out_buf3_reg_228[13]),
        .R(1'b0));
  FDRE \out_buf3_reg_228_reg[14] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(out_buf[16]),
        .Q(out_buf3_reg_228[14]),
        .R(1'b0));
  FDRE \out_buf3_reg_228_reg[15] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(out_buf[17]),
        .Q(out_buf3_reg_228[15]),
        .R(1'b0));
  FDRE \out_buf3_reg_228_reg[16] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(out_buf[18]),
        .Q(out_buf3_reg_228[16]),
        .R(1'b0));
  FDRE \out_buf3_reg_228_reg[17] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(out_buf[19]),
        .Q(out_buf3_reg_228[17]),
        .R(1'b0));
  FDRE \out_buf3_reg_228_reg[18] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(out_buf[20]),
        .Q(out_buf3_reg_228[18]),
        .R(1'b0));
  FDRE \out_buf3_reg_228_reg[19] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(out_buf[21]),
        .Q(out_buf3_reg_228[19]),
        .R(1'b0));
  FDRE \out_buf3_reg_228_reg[1] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(out_buf[3]),
        .Q(out_buf3_reg_228[1]),
        .R(1'b0));
  FDRE \out_buf3_reg_228_reg[20] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(out_buf[22]),
        .Q(out_buf3_reg_228[20]),
        .R(1'b0));
  FDRE \out_buf3_reg_228_reg[21] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(out_buf[23]),
        .Q(out_buf3_reg_228[21]),
        .R(1'b0));
  FDRE \out_buf3_reg_228_reg[22] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(out_buf[24]),
        .Q(out_buf3_reg_228[22]),
        .R(1'b0));
  FDRE \out_buf3_reg_228_reg[23] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(out_buf[25]),
        .Q(out_buf3_reg_228[23]),
        .R(1'b0));
  FDRE \out_buf3_reg_228_reg[24] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(out_buf[26]),
        .Q(out_buf3_reg_228[24]),
        .R(1'b0));
  FDRE \out_buf3_reg_228_reg[25] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(out_buf[27]),
        .Q(out_buf3_reg_228[25]),
        .R(1'b0));
  FDRE \out_buf3_reg_228_reg[26] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(out_buf[28]),
        .Q(out_buf3_reg_228[26]),
        .R(1'b0));
  FDRE \out_buf3_reg_228_reg[27] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(out_buf[29]),
        .Q(out_buf3_reg_228[27]),
        .R(1'b0));
  FDRE \out_buf3_reg_228_reg[28] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(out_buf[30]),
        .Q(out_buf3_reg_228[28]),
        .R(1'b0));
  FDRE \out_buf3_reg_228_reg[29] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(out_buf[31]),
        .Q(out_buf3_reg_228[29]),
        .R(1'b0));
  FDRE \out_buf3_reg_228_reg[2] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(out_buf[4]),
        .Q(out_buf3_reg_228[2]),
        .R(1'b0));
  FDRE \out_buf3_reg_228_reg[3] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(out_buf[5]),
        .Q(out_buf3_reg_228[3]),
        .R(1'b0));
  FDRE \out_buf3_reg_228_reg[4] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(out_buf[6]),
        .Q(out_buf3_reg_228[4]),
        .R(1'b0));
  FDRE \out_buf3_reg_228_reg[5] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(out_buf[7]),
        .Q(out_buf3_reg_228[5]),
        .R(1'b0));
  FDRE \out_buf3_reg_228_reg[6] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(out_buf[8]),
        .Q(out_buf3_reg_228[6]),
        .R(1'b0));
  FDRE \out_buf3_reg_228_reg[7] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(out_buf[9]),
        .Q(out_buf3_reg_228[7]),
        .R(1'b0));
  FDRE \out_buf3_reg_228_reg[8] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(out_buf[10]),
        .Q(out_buf3_reg_228[8]),
        .R(1'b0));
  FDRE \out_buf3_reg_228_reg[9] 
       (.C(ap_clk),
        .CE(ap_NS_fsm120_out),
        .D(out_buf[11]),
        .Q(out_buf3_reg_228[9]),
        .R(1'b0));
  design_1_simple_accel_core_0_3_simple_accel_core_control_s_axi simple_accel_core_control_s_axi_U
       (.D(ap_NS_fsm[1]),
        .E(ap_NS_fsm120_out),
        .\FSM_onehot_rstate_reg[1]_0 (s_axi_control_ARREADY),
        .\FSM_onehot_wstate_reg[1]_0 (s_axi_control_AWREADY),
        .\FSM_onehot_wstate_reg[2]_0 (s_axi_control_WREADY),
        .Q(num_items),
        .SR(ap_rst_n_inv),
        .\ap_CS_fsm_reg[1] (\ap_CS_fsm[1]_i_2_n_2 ),
        .\ap_CS_fsm_reg[1]_0 (\ap_CS_fsm[1]_i_3_n_2 ),
        .\ap_CS_fsm_reg[1]_1 (\bus_read/rs_rreq/load_p2 ),
        .ap_clk(ap_clk),
        .ap_done(ap_done),
        .ap_start(ap_start),
        .gmem_BVALID(gmem_BVALID),
        .int_ap_start_reg_0({ap_CS_fsm_state19,\ap_CS_fsm_reg_n_2_[6] ,\ap_CS_fsm_reg_n_2_[2] ,\ap_CS_fsm_reg_n_2_[0] }),
        .\int_in_buf_reg[31]_0 (in_buf),
        .\int_out_buf_reg[31]_0 (out_buf),
        .interrupt(interrupt),
        .s_axi_control_ARADDR(s_axi_control_ARADDR),
        .s_axi_control_ARVALID(s_axi_control_ARVALID),
        .s_axi_control_AWADDR(s_axi_control_AWADDR),
        .s_axi_control_AWVALID(s_axi_control_AWVALID),
        .s_axi_control_BREADY(s_axi_control_BREADY),
        .s_axi_control_BVALID(s_axi_control_BVALID),
        .s_axi_control_RDATA(s_axi_control_RDATA),
        .s_axi_control_RREADY(s_axi_control_RREADY),
        .s_axi_control_RVALID(s_axi_control_RVALID),
        .s_axi_control_WDATA(s_axi_control_WDATA),
        .s_axi_control_WSTRB(s_axi_control_WSTRB),
        .s_axi_control_WVALID(s_axi_control_WVALID));
  design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi simple_accel_core_gmem_m_axi_U
       (.CO(ap_condition_pp0_exit_iter0_state9),
        .D({m_axi_gmem_RLAST,m_axi_gmem_RDATA}),
        .E(gmem_addr_1_read_reg_2600),
        .Q({ap_CS_fsm_state19,\ap_CS_fsm_reg_n_2_[15] ,ap_CS_fsm_state14,ap_CS_fsm_state13,ap_CS_fsm_state12,ap_CS_fsm_pp0_stage0,ap_CS_fsm_state8,ap_CS_fsm_state2,\ap_CS_fsm_reg_n_2_[0] }),
        .SR(ap_rst_n_inv),
        .\ap_CS_fsm_reg[10] (ap_NS_fsm112_out),
        .\ap_CS_fsm_reg[15] ({ap_NS_fsm[16],ap_NS_fsm[12:9],\bus_read/rs_rreq/load_p2 ,ap_NS_fsm[0]}),
        .\ap_CS_fsm_reg[7] (simple_accel_core_gmem_m_axi_U_n_10),
        .\ap_CS_fsm_reg[8] (simple_accel_core_gmem_m_axi_U_n_29),
        .\ap_CS_fsm_reg[8]_0 (simple_accel_core_gmem_m_axi_U_n_91),
        .\ap_CS_fsm_reg[8]_1 (simple_accel_core_gmem_m_axi_U_n_92),
        .\ap_CS_fsm_reg[9] (\ap_CS_fsm[9]_i_2_n_2 ),
        .ap_clk(ap_clk),
        .ap_done(ap_done),
        .ap_enable_reg_pp0_iter0(ap_enable_reg_pp0_iter0),
        .ap_enable_reg_pp0_iter1_reg(ap_enable_reg_pp0_iter1_reg_n_2),
        .ap_enable_reg_pp0_iter1_reg_0(\exitcond_reg_251_reg_n_2_[0] ),
        .ap_enable_reg_pp0_iter2_reg(ap_enable_reg_pp0_iter2_reg_n_2),
        .ap_reg_ioackin_gmem_WREADY(ap_reg_ioackin_gmem_WREADY),
        .ap_rst_n(ap_rst_n),
        .ap_start(ap_start),
        .\bus_equal_gen.WVALID_Dummy_reg (m_axi_gmem_WVALID),
        .\could_multi_bursts.ARVALID_Dummy_reg (m_axi_gmem_ARVALID),
        .\could_multi_bursts.arlen_buf_reg[3] (\^m_axi_gmem_ARLEN ),
        .\could_multi_bursts.awlen_buf_reg[3] (\^m_axi_gmem_AWLEN ),
        .\data_p1_reg[31] (gmem_RDATA),
        .\data_p2_reg[29] (gmem_addr_reg_244),
        .\data_p2_reg[63] ({num_items_read_reg_222,in_buf1_reg_233}),
        .exitcond_reg_251_pp0_iter1_reg(exitcond_reg_251_pp0_iter1_reg),
        .full_n_reg(m_axi_gmem_RREADY),
        .full_n_reg_0(m_axi_gmem_BREADY),
        .gmem_BVALID(gmem_BVALID),
        .i_reg_137(i_reg_137),
        .i_reg_1370(i_reg_1370),
        .m_axi_gmem_ARADDR(\^m_axi_gmem_ARADDR ),
        .m_axi_gmem_ARREADY(m_axi_gmem_ARREADY),
        .m_axi_gmem_AWADDR(\^m_axi_gmem_AWADDR ),
        .m_axi_gmem_AWREADY(m_axi_gmem_AWREADY),
        .m_axi_gmem_AWVALID(m_axi_gmem_AWVALID),
        .m_axi_gmem_BVALID(m_axi_gmem_BVALID),
        .m_axi_gmem_RRESP(m_axi_gmem_RRESP),
        .m_axi_gmem_RVALID(m_axi_gmem_RVALID),
        .m_axi_gmem_WDATA(m_axi_gmem_WDATA),
        .m_axi_gmem_WLAST(m_axi_gmem_WLAST),
        .m_axi_gmem_WREADY(m_axi_gmem_WREADY),
        .m_axi_gmem_WSTRB(m_axi_gmem_WSTRB),
        .mem_reg(tmp_2_reg_270),
        .out(sum_reg_125_reg__0),
        .\state_reg[0] (simple_accel_core_gmem_m_axi_U_n_9),
        .sum_reg_125(sum_reg_125),
        .sum_reg_1250(sum_reg_1250));
  LUT2 #(
    .INIT(4'h6)) 
    \sum_reg_125[0]_i_4 
       (.I0(gmem_addr_1_read_reg_260[3]),
        .I1(sum_reg_125_reg__0[3]),
        .O(\sum_reg_125[0]_i_4_n_2 ));
  LUT2 #(
    .INIT(4'h6)) 
    \sum_reg_125[0]_i_5 
       (.I0(gmem_addr_1_read_reg_260[2]),
        .I1(sum_reg_125_reg__0[2]),
        .O(\sum_reg_125[0]_i_5_n_2 ));
  LUT2 #(
    .INIT(4'h6)) 
    \sum_reg_125[0]_i_6 
       (.I0(gmem_addr_1_read_reg_260[1]),
        .I1(sum_reg_125_reg__0[1]),
        .O(\sum_reg_125[0]_i_6_n_2 ));
  LUT2 #(
    .INIT(4'h6)) 
    \sum_reg_125[0]_i_7 
       (.I0(gmem_addr_1_read_reg_260[0]),
        .I1(sum_reg_125_reg__0[0]),
        .O(\sum_reg_125[0]_i_7_n_2 ));
  LUT2 #(
    .INIT(4'h6)) 
    \sum_reg_125[12]_i_2 
       (.I0(gmem_addr_1_read_reg_260[15]),
        .I1(sum_reg_125_reg__0[15]),
        .O(\sum_reg_125[12]_i_2_n_2 ));
  LUT2 #(
    .INIT(4'h6)) 
    \sum_reg_125[12]_i_3 
       (.I0(gmem_addr_1_read_reg_260[14]),
        .I1(sum_reg_125_reg__0[14]),
        .O(\sum_reg_125[12]_i_3_n_2 ));
  LUT2 #(
    .INIT(4'h6)) 
    \sum_reg_125[12]_i_4 
       (.I0(gmem_addr_1_read_reg_260[13]),
        .I1(sum_reg_125_reg__0[13]),
        .O(\sum_reg_125[12]_i_4_n_2 ));
  LUT2 #(
    .INIT(4'h6)) 
    \sum_reg_125[12]_i_5 
       (.I0(gmem_addr_1_read_reg_260[12]),
        .I1(sum_reg_125_reg__0[12]),
        .O(\sum_reg_125[12]_i_5_n_2 ));
  LUT2 #(
    .INIT(4'h6)) 
    \sum_reg_125[16]_i_2 
       (.I0(gmem_addr_1_read_reg_260[19]),
        .I1(sum_reg_125_reg__0[19]),
        .O(\sum_reg_125[16]_i_2_n_2 ));
  LUT2 #(
    .INIT(4'h6)) 
    \sum_reg_125[16]_i_3 
       (.I0(gmem_addr_1_read_reg_260[18]),
        .I1(sum_reg_125_reg__0[18]),
        .O(\sum_reg_125[16]_i_3_n_2 ));
  LUT2 #(
    .INIT(4'h6)) 
    \sum_reg_125[16]_i_4 
       (.I0(gmem_addr_1_read_reg_260[17]),
        .I1(sum_reg_125_reg__0[17]),
        .O(\sum_reg_125[16]_i_4_n_2 ));
  LUT2 #(
    .INIT(4'h6)) 
    \sum_reg_125[16]_i_5 
       (.I0(gmem_addr_1_read_reg_260[16]),
        .I1(sum_reg_125_reg__0[16]),
        .O(\sum_reg_125[16]_i_5_n_2 ));
  LUT2 #(
    .INIT(4'h6)) 
    \sum_reg_125[20]_i_2 
       (.I0(gmem_addr_1_read_reg_260[23]),
        .I1(sum_reg_125_reg__0[23]),
        .O(\sum_reg_125[20]_i_2_n_2 ));
  LUT2 #(
    .INIT(4'h6)) 
    \sum_reg_125[20]_i_3 
       (.I0(gmem_addr_1_read_reg_260[22]),
        .I1(sum_reg_125_reg__0[22]),
        .O(\sum_reg_125[20]_i_3_n_2 ));
  LUT2 #(
    .INIT(4'h6)) 
    \sum_reg_125[20]_i_4 
       (.I0(gmem_addr_1_read_reg_260[21]),
        .I1(sum_reg_125_reg__0[21]),
        .O(\sum_reg_125[20]_i_4_n_2 ));
  LUT2 #(
    .INIT(4'h6)) 
    \sum_reg_125[20]_i_5 
       (.I0(gmem_addr_1_read_reg_260[20]),
        .I1(sum_reg_125_reg__0[20]),
        .O(\sum_reg_125[20]_i_5_n_2 ));
  LUT2 #(
    .INIT(4'h6)) 
    \sum_reg_125[24]_i_2 
       (.I0(gmem_addr_1_read_reg_260[27]),
        .I1(sum_reg_125_reg__0[27]),
        .O(\sum_reg_125[24]_i_2_n_2 ));
  LUT2 #(
    .INIT(4'h6)) 
    \sum_reg_125[24]_i_3 
       (.I0(gmem_addr_1_read_reg_260[26]),
        .I1(sum_reg_125_reg__0[26]),
        .O(\sum_reg_125[24]_i_3_n_2 ));
  LUT2 #(
    .INIT(4'h6)) 
    \sum_reg_125[24]_i_4 
       (.I0(gmem_addr_1_read_reg_260[25]),
        .I1(sum_reg_125_reg__0[25]),
        .O(\sum_reg_125[24]_i_4_n_2 ));
  LUT2 #(
    .INIT(4'h6)) 
    \sum_reg_125[24]_i_5 
       (.I0(gmem_addr_1_read_reg_260[24]),
        .I1(sum_reg_125_reg__0[24]),
        .O(\sum_reg_125[24]_i_5_n_2 ));
  LUT2 #(
    .INIT(4'h6)) 
    \sum_reg_125[28]_i_2 
       (.I0(gmem_addr_1_read_reg_260[31]),
        .I1(sum_reg_125_reg__0[31]),
        .O(\sum_reg_125[28]_i_2_n_2 ));
  LUT2 #(
    .INIT(4'h6)) 
    \sum_reg_125[28]_i_3 
       (.I0(gmem_addr_1_read_reg_260[30]),
        .I1(sum_reg_125_reg__0[30]),
        .O(\sum_reg_125[28]_i_3_n_2 ));
  LUT2 #(
    .INIT(4'h6)) 
    \sum_reg_125[28]_i_4 
       (.I0(gmem_addr_1_read_reg_260[29]),
        .I1(sum_reg_125_reg__0[29]),
        .O(\sum_reg_125[28]_i_4_n_2 ));
  LUT2 #(
    .INIT(4'h6)) 
    \sum_reg_125[28]_i_5 
       (.I0(gmem_addr_1_read_reg_260[28]),
        .I1(sum_reg_125_reg__0[28]),
        .O(\sum_reg_125[28]_i_5_n_2 ));
  LUT2 #(
    .INIT(4'h6)) 
    \sum_reg_125[4]_i_2 
       (.I0(gmem_addr_1_read_reg_260[7]),
        .I1(sum_reg_125_reg__0[7]),
        .O(\sum_reg_125[4]_i_2_n_2 ));
  LUT2 #(
    .INIT(4'h6)) 
    \sum_reg_125[4]_i_3 
       (.I0(gmem_addr_1_read_reg_260[6]),
        .I1(sum_reg_125_reg__0[6]),
        .O(\sum_reg_125[4]_i_3_n_2 ));
  LUT2 #(
    .INIT(4'h6)) 
    \sum_reg_125[4]_i_4 
       (.I0(gmem_addr_1_read_reg_260[5]),
        .I1(sum_reg_125_reg__0[5]),
        .O(\sum_reg_125[4]_i_4_n_2 ));
  LUT2 #(
    .INIT(4'h6)) 
    \sum_reg_125[4]_i_5 
       (.I0(gmem_addr_1_read_reg_260[4]),
        .I1(sum_reg_125_reg__0[4]),
        .O(\sum_reg_125[4]_i_5_n_2 ));
  LUT2 #(
    .INIT(4'h6)) 
    \sum_reg_125[8]_i_2 
       (.I0(gmem_addr_1_read_reg_260[11]),
        .I1(sum_reg_125_reg__0[11]),
        .O(\sum_reg_125[8]_i_2_n_2 ));
  LUT2 #(
    .INIT(4'h6)) 
    \sum_reg_125[8]_i_3 
       (.I0(gmem_addr_1_read_reg_260[10]),
        .I1(sum_reg_125_reg__0[10]),
        .O(\sum_reg_125[8]_i_3_n_2 ));
  LUT2 #(
    .INIT(4'h6)) 
    \sum_reg_125[8]_i_4 
       (.I0(gmem_addr_1_read_reg_260[9]),
        .I1(sum_reg_125_reg__0[9]),
        .O(\sum_reg_125[8]_i_4_n_2 ));
  LUT2 #(
    .INIT(4'h6)) 
    \sum_reg_125[8]_i_5 
       (.I0(gmem_addr_1_read_reg_260[8]),
        .I1(sum_reg_125_reg__0[8]),
        .O(\sum_reg_125[8]_i_5_n_2 ));
  FDRE \sum_reg_125_reg[0] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[0]_i_3_n_9 ),
        .Q(sum_reg_125_reg__0[0]),
        .R(sum_reg_125));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \sum_reg_125_reg[0]_i_3 
       (.CI(1'b0),
        .CO({\sum_reg_125_reg[0]_i_3_n_2 ,\sum_reg_125_reg[0]_i_3_n_3 ,\sum_reg_125_reg[0]_i_3_n_4 ,\sum_reg_125_reg[0]_i_3_n_5 }),
        .CYINIT(1'b0),
        .DI(gmem_addr_1_read_reg_260[3:0]),
        .O({\sum_reg_125_reg[0]_i_3_n_6 ,\sum_reg_125_reg[0]_i_3_n_7 ,\sum_reg_125_reg[0]_i_3_n_8 ,\sum_reg_125_reg[0]_i_3_n_9 }),
        .S({\sum_reg_125[0]_i_4_n_2 ,\sum_reg_125[0]_i_5_n_2 ,\sum_reg_125[0]_i_6_n_2 ,\sum_reg_125[0]_i_7_n_2 }));
  FDRE \sum_reg_125_reg[10] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[8]_i_1_n_7 ),
        .Q(sum_reg_125_reg__0[10]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[11] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[8]_i_1_n_6 ),
        .Q(sum_reg_125_reg__0[11]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[12] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[12]_i_1_n_9 ),
        .Q(sum_reg_125_reg__0[12]),
        .R(sum_reg_125));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \sum_reg_125_reg[12]_i_1 
       (.CI(\sum_reg_125_reg[8]_i_1_n_2 ),
        .CO({\sum_reg_125_reg[12]_i_1_n_2 ,\sum_reg_125_reg[12]_i_1_n_3 ,\sum_reg_125_reg[12]_i_1_n_4 ,\sum_reg_125_reg[12]_i_1_n_5 }),
        .CYINIT(1'b0),
        .DI(gmem_addr_1_read_reg_260[15:12]),
        .O({\sum_reg_125_reg[12]_i_1_n_6 ,\sum_reg_125_reg[12]_i_1_n_7 ,\sum_reg_125_reg[12]_i_1_n_8 ,\sum_reg_125_reg[12]_i_1_n_9 }),
        .S({\sum_reg_125[12]_i_2_n_2 ,\sum_reg_125[12]_i_3_n_2 ,\sum_reg_125[12]_i_4_n_2 ,\sum_reg_125[12]_i_5_n_2 }));
  FDRE \sum_reg_125_reg[13] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[12]_i_1_n_8 ),
        .Q(sum_reg_125_reg__0[13]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[14] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[12]_i_1_n_7 ),
        .Q(sum_reg_125_reg__0[14]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[15] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[12]_i_1_n_6 ),
        .Q(sum_reg_125_reg__0[15]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[16] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[16]_i_1_n_9 ),
        .Q(sum_reg_125_reg__0[16]),
        .R(sum_reg_125));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \sum_reg_125_reg[16]_i_1 
       (.CI(\sum_reg_125_reg[12]_i_1_n_2 ),
        .CO({\sum_reg_125_reg[16]_i_1_n_2 ,\sum_reg_125_reg[16]_i_1_n_3 ,\sum_reg_125_reg[16]_i_1_n_4 ,\sum_reg_125_reg[16]_i_1_n_5 }),
        .CYINIT(1'b0),
        .DI(gmem_addr_1_read_reg_260[19:16]),
        .O({\sum_reg_125_reg[16]_i_1_n_6 ,\sum_reg_125_reg[16]_i_1_n_7 ,\sum_reg_125_reg[16]_i_1_n_8 ,\sum_reg_125_reg[16]_i_1_n_9 }),
        .S({\sum_reg_125[16]_i_2_n_2 ,\sum_reg_125[16]_i_3_n_2 ,\sum_reg_125[16]_i_4_n_2 ,\sum_reg_125[16]_i_5_n_2 }));
  FDRE \sum_reg_125_reg[17] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[16]_i_1_n_8 ),
        .Q(sum_reg_125_reg__0[17]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[18] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[16]_i_1_n_7 ),
        .Q(sum_reg_125_reg__0[18]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[19] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[16]_i_1_n_6 ),
        .Q(sum_reg_125_reg__0[19]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[1] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[0]_i_3_n_8 ),
        .Q(sum_reg_125_reg__0[1]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[20] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[20]_i_1_n_9 ),
        .Q(sum_reg_125_reg__0[20]),
        .R(sum_reg_125));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \sum_reg_125_reg[20]_i_1 
       (.CI(\sum_reg_125_reg[16]_i_1_n_2 ),
        .CO({\sum_reg_125_reg[20]_i_1_n_2 ,\sum_reg_125_reg[20]_i_1_n_3 ,\sum_reg_125_reg[20]_i_1_n_4 ,\sum_reg_125_reg[20]_i_1_n_5 }),
        .CYINIT(1'b0),
        .DI(gmem_addr_1_read_reg_260[23:20]),
        .O({\sum_reg_125_reg[20]_i_1_n_6 ,\sum_reg_125_reg[20]_i_1_n_7 ,\sum_reg_125_reg[20]_i_1_n_8 ,\sum_reg_125_reg[20]_i_1_n_9 }),
        .S({\sum_reg_125[20]_i_2_n_2 ,\sum_reg_125[20]_i_3_n_2 ,\sum_reg_125[20]_i_4_n_2 ,\sum_reg_125[20]_i_5_n_2 }));
  FDRE \sum_reg_125_reg[21] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[20]_i_1_n_8 ),
        .Q(sum_reg_125_reg__0[21]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[22] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[20]_i_1_n_7 ),
        .Q(sum_reg_125_reg__0[22]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[23] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[20]_i_1_n_6 ),
        .Q(sum_reg_125_reg__0[23]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[24] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[24]_i_1_n_9 ),
        .Q(sum_reg_125_reg__0[24]),
        .R(sum_reg_125));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \sum_reg_125_reg[24]_i_1 
       (.CI(\sum_reg_125_reg[20]_i_1_n_2 ),
        .CO({\sum_reg_125_reg[24]_i_1_n_2 ,\sum_reg_125_reg[24]_i_1_n_3 ,\sum_reg_125_reg[24]_i_1_n_4 ,\sum_reg_125_reg[24]_i_1_n_5 }),
        .CYINIT(1'b0),
        .DI(gmem_addr_1_read_reg_260[27:24]),
        .O({\sum_reg_125_reg[24]_i_1_n_6 ,\sum_reg_125_reg[24]_i_1_n_7 ,\sum_reg_125_reg[24]_i_1_n_8 ,\sum_reg_125_reg[24]_i_1_n_9 }),
        .S({\sum_reg_125[24]_i_2_n_2 ,\sum_reg_125[24]_i_3_n_2 ,\sum_reg_125[24]_i_4_n_2 ,\sum_reg_125[24]_i_5_n_2 }));
  FDRE \sum_reg_125_reg[25] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[24]_i_1_n_8 ),
        .Q(sum_reg_125_reg__0[25]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[26] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[24]_i_1_n_7 ),
        .Q(sum_reg_125_reg__0[26]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[27] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[24]_i_1_n_6 ),
        .Q(sum_reg_125_reg__0[27]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[28] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[28]_i_1_n_9 ),
        .Q(sum_reg_125_reg__0[28]),
        .R(sum_reg_125));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \sum_reg_125_reg[28]_i_1 
       (.CI(\sum_reg_125_reg[24]_i_1_n_2 ),
        .CO({\sum_reg_125_reg[28]_i_1_n_2 ,\sum_reg_125_reg[28]_i_1_n_3 ,\sum_reg_125_reg[28]_i_1_n_4 ,\sum_reg_125_reg[28]_i_1_n_5 }),
        .CYINIT(1'b0),
        .DI(gmem_addr_1_read_reg_260[31:28]),
        .O({\sum_reg_125_reg[28]_i_1_n_6 ,\sum_reg_125_reg[28]_i_1_n_7 ,\sum_reg_125_reg[28]_i_1_n_8 ,\sum_reg_125_reg[28]_i_1_n_9 }),
        .S({\sum_reg_125[28]_i_2_n_2 ,\sum_reg_125[28]_i_3_n_2 ,\sum_reg_125[28]_i_4_n_2 ,\sum_reg_125[28]_i_5_n_2 }));
  FDRE \sum_reg_125_reg[29] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[28]_i_1_n_8 ),
        .Q(sum_reg_125_reg__0[29]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[2] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[0]_i_3_n_7 ),
        .Q(sum_reg_125_reg__0[2]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[30] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[28]_i_1_n_7 ),
        .Q(sum_reg_125_reg__0[30]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[31] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[28]_i_1_n_6 ),
        .Q(sum_reg_125_reg__0[31]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[32] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[32]_i_1_n_9 ),
        .Q(sum_reg_125_reg[32]),
        .R(sum_reg_125));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \sum_reg_125_reg[32]_i_1 
       (.CI(\sum_reg_125_reg[28]_i_1_n_2 ),
        .CO({\sum_reg_125_reg[32]_i_1_n_2 ,\sum_reg_125_reg[32]_i_1_n_3 ,\sum_reg_125_reg[32]_i_1_n_4 ,\sum_reg_125_reg[32]_i_1_n_5 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\sum_reg_125_reg[32]_i_1_n_6 ,\sum_reg_125_reg[32]_i_1_n_7 ,\sum_reg_125_reg[32]_i_1_n_8 ,\sum_reg_125_reg[32]_i_1_n_9 }),
        .S(sum_reg_125_reg[35:32]));
  FDRE \sum_reg_125_reg[33] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[32]_i_1_n_8 ),
        .Q(sum_reg_125_reg[33]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[34] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[32]_i_1_n_7 ),
        .Q(sum_reg_125_reg[34]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[35] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[32]_i_1_n_6 ),
        .Q(sum_reg_125_reg[35]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[36] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[36]_i_1_n_9 ),
        .Q(sum_reg_125_reg[36]),
        .R(sum_reg_125));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \sum_reg_125_reg[36]_i_1 
       (.CI(\sum_reg_125_reg[32]_i_1_n_2 ),
        .CO({\sum_reg_125_reg[36]_i_1_n_2 ,\sum_reg_125_reg[36]_i_1_n_3 ,\sum_reg_125_reg[36]_i_1_n_4 ,\sum_reg_125_reg[36]_i_1_n_5 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\sum_reg_125_reg[36]_i_1_n_6 ,\sum_reg_125_reg[36]_i_1_n_7 ,\sum_reg_125_reg[36]_i_1_n_8 ,\sum_reg_125_reg[36]_i_1_n_9 }),
        .S(sum_reg_125_reg[39:36]));
  FDRE \sum_reg_125_reg[37] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[36]_i_1_n_8 ),
        .Q(sum_reg_125_reg[37]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[38] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[36]_i_1_n_7 ),
        .Q(sum_reg_125_reg[38]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[39] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[36]_i_1_n_6 ),
        .Q(sum_reg_125_reg[39]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[3] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[0]_i_3_n_6 ),
        .Q(sum_reg_125_reg__0[3]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[40] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[40]_i_1_n_9 ),
        .Q(sum_reg_125_reg[40]),
        .R(sum_reg_125));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \sum_reg_125_reg[40]_i_1 
       (.CI(\sum_reg_125_reg[36]_i_1_n_2 ),
        .CO({\sum_reg_125_reg[40]_i_1_n_2 ,\sum_reg_125_reg[40]_i_1_n_3 ,\sum_reg_125_reg[40]_i_1_n_4 ,\sum_reg_125_reg[40]_i_1_n_5 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\sum_reg_125_reg[40]_i_1_n_6 ,\sum_reg_125_reg[40]_i_1_n_7 ,\sum_reg_125_reg[40]_i_1_n_8 ,\sum_reg_125_reg[40]_i_1_n_9 }),
        .S(sum_reg_125_reg[43:40]));
  FDRE \sum_reg_125_reg[41] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[40]_i_1_n_8 ),
        .Q(sum_reg_125_reg[41]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[42] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[40]_i_1_n_7 ),
        .Q(sum_reg_125_reg[42]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[43] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[40]_i_1_n_6 ),
        .Q(sum_reg_125_reg[43]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[44] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[44]_i_1_n_9 ),
        .Q(sum_reg_125_reg[44]),
        .R(sum_reg_125));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \sum_reg_125_reg[44]_i_1 
       (.CI(\sum_reg_125_reg[40]_i_1_n_2 ),
        .CO({\sum_reg_125_reg[44]_i_1_n_2 ,\sum_reg_125_reg[44]_i_1_n_3 ,\sum_reg_125_reg[44]_i_1_n_4 ,\sum_reg_125_reg[44]_i_1_n_5 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\sum_reg_125_reg[44]_i_1_n_6 ,\sum_reg_125_reg[44]_i_1_n_7 ,\sum_reg_125_reg[44]_i_1_n_8 ,\sum_reg_125_reg[44]_i_1_n_9 }),
        .S(sum_reg_125_reg[47:44]));
  FDRE \sum_reg_125_reg[45] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[44]_i_1_n_8 ),
        .Q(sum_reg_125_reg[45]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[46] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[44]_i_1_n_7 ),
        .Q(sum_reg_125_reg[46]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[47] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[44]_i_1_n_6 ),
        .Q(sum_reg_125_reg[47]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[48] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[48]_i_1_n_9 ),
        .Q(sum_reg_125_reg[48]),
        .R(sum_reg_125));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \sum_reg_125_reg[48]_i_1 
       (.CI(\sum_reg_125_reg[44]_i_1_n_2 ),
        .CO({\sum_reg_125_reg[48]_i_1_n_2 ,\sum_reg_125_reg[48]_i_1_n_3 ,\sum_reg_125_reg[48]_i_1_n_4 ,\sum_reg_125_reg[48]_i_1_n_5 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\sum_reg_125_reg[48]_i_1_n_6 ,\sum_reg_125_reg[48]_i_1_n_7 ,\sum_reg_125_reg[48]_i_1_n_8 ,\sum_reg_125_reg[48]_i_1_n_9 }),
        .S(sum_reg_125_reg[51:48]));
  FDRE \sum_reg_125_reg[49] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[48]_i_1_n_8 ),
        .Q(sum_reg_125_reg[49]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[4] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[4]_i_1_n_9 ),
        .Q(sum_reg_125_reg__0[4]),
        .R(sum_reg_125));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \sum_reg_125_reg[4]_i_1 
       (.CI(\sum_reg_125_reg[0]_i_3_n_2 ),
        .CO({\sum_reg_125_reg[4]_i_1_n_2 ,\sum_reg_125_reg[4]_i_1_n_3 ,\sum_reg_125_reg[4]_i_1_n_4 ,\sum_reg_125_reg[4]_i_1_n_5 }),
        .CYINIT(1'b0),
        .DI(gmem_addr_1_read_reg_260[7:4]),
        .O({\sum_reg_125_reg[4]_i_1_n_6 ,\sum_reg_125_reg[4]_i_1_n_7 ,\sum_reg_125_reg[4]_i_1_n_8 ,\sum_reg_125_reg[4]_i_1_n_9 }),
        .S({\sum_reg_125[4]_i_2_n_2 ,\sum_reg_125[4]_i_3_n_2 ,\sum_reg_125[4]_i_4_n_2 ,\sum_reg_125[4]_i_5_n_2 }));
  FDRE \sum_reg_125_reg[50] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[48]_i_1_n_7 ),
        .Q(sum_reg_125_reg[50]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[51] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[48]_i_1_n_6 ),
        .Q(sum_reg_125_reg[51]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[52] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[52]_i_1_n_9 ),
        .Q(sum_reg_125_reg[52]),
        .R(sum_reg_125));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \sum_reg_125_reg[52]_i_1 
       (.CI(\sum_reg_125_reg[48]_i_1_n_2 ),
        .CO({\sum_reg_125_reg[52]_i_1_n_2 ,\sum_reg_125_reg[52]_i_1_n_3 ,\sum_reg_125_reg[52]_i_1_n_4 ,\sum_reg_125_reg[52]_i_1_n_5 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\sum_reg_125_reg[52]_i_1_n_6 ,\sum_reg_125_reg[52]_i_1_n_7 ,\sum_reg_125_reg[52]_i_1_n_8 ,\sum_reg_125_reg[52]_i_1_n_9 }),
        .S(sum_reg_125_reg[55:52]));
  FDRE \sum_reg_125_reg[53] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[52]_i_1_n_8 ),
        .Q(sum_reg_125_reg[53]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[54] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[52]_i_1_n_7 ),
        .Q(sum_reg_125_reg[54]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[55] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[52]_i_1_n_6 ),
        .Q(sum_reg_125_reg[55]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[56] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[56]_i_1_n_9 ),
        .Q(sum_reg_125_reg[56]),
        .R(sum_reg_125));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \sum_reg_125_reg[56]_i_1 
       (.CI(\sum_reg_125_reg[52]_i_1_n_2 ),
        .CO({\sum_reg_125_reg[56]_i_1_n_2 ,\sum_reg_125_reg[56]_i_1_n_3 ,\sum_reg_125_reg[56]_i_1_n_4 ,\sum_reg_125_reg[56]_i_1_n_5 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\sum_reg_125_reg[56]_i_1_n_6 ,\sum_reg_125_reg[56]_i_1_n_7 ,\sum_reg_125_reg[56]_i_1_n_8 ,\sum_reg_125_reg[56]_i_1_n_9 }),
        .S(sum_reg_125_reg[59:56]));
  FDRE \sum_reg_125_reg[57] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[56]_i_1_n_8 ),
        .Q(sum_reg_125_reg[57]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[58] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[56]_i_1_n_7 ),
        .Q(sum_reg_125_reg[58]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[59] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[56]_i_1_n_6 ),
        .Q(sum_reg_125_reg[59]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[5] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[4]_i_1_n_8 ),
        .Q(sum_reg_125_reg__0[5]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[60] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[60]_i_1_n_9 ),
        .Q(sum_reg_125_reg[60]),
        .R(sum_reg_125));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \sum_reg_125_reg[60]_i_1 
       (.CI(\sum_reg_125_reg[56]_i_1_n_2 ),
        .CO({\NLW_sum_reg_125_reg[60]_i_1_CO_UNCONNECTED [3],\sum_reg_125_reg[60]_i_1_n_3 ,\sum_reg_125_reg[60]_i_1_n_4 ,\sum_reg_125_reg[60]_i_1_n_5 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\sum_reg_125_reg[60]_i_1_n_6 ,\sum_reg_125_reg[60]_i_1_n_7 ,\sum_reg_125_reg[60]_i_1_n_8 ,\sum_reg_125_reg[60]_i_1_n_9 }),
        .S(sum_reg_125_reg[63:60]));
  FDRE \sum_reg_125_reg[61] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[60]_i_1_n_8 ),
        .Q(sum_reg_125_reg[61]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[62] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[60]_i_1_n_7 ),
        .Q(sum_reg_125_reg[62]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[63] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[60]_i_1_n_6 ),
        .Q(sum_reg_125_reg[63]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[6] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[4]_i_1_n_7 ),
        .Q(sum_reg_125_reg__0[6]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[7] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[4]_i_1_n_6 ),
        .Q(sum_reg_125_reg__0[7]),
        .R(sum_reg_125));
  FDRE \sum_reg_125_reg[8] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[8]_i_1_n_9 ),
        .Q(sum_reg_125_reg__0[8]),
        .R(sum_reg_125));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \sum_reg_125_reg[8]_i_1 
       (.CI(\sum_reg_125_reg[4]_i_1_n_2 ),
        .CO({\sum_reg_125_reg[8]_i_1_n_2 ,\sum_reg_125_reg[8]_i_1_n_3 ,\sum_reg_125_reg[8]_i_1_n_4 ,\sum_reg_125_reg[8]_i_1_n_5 }),
        .CYINIT(1'b0),
        .DI(gmem_addr_1_read_reg_260[11:8]),
        .O({\sum_reg_125_reg[8]_i_1_n_6 ,\sum_reg_125_reg[8]_i_1_n_7 ,\sum_reg_125_reg[8]_i_1_n_8 ,\sum_reg_125_reg[8]_i_1_n_9 }),
        .S({\sum_reg_125[8]_i_2_n_2 ,\sum_reg_125[8]_i_3_n_2 ,\sum_reg_125[8]_i_4_n_2 ,\sum_reg_125[8]_i_5_n_2 }));
  FDRE \sum_reg_125_reg[9] 
       (.C(ap_clk),
        .CE(sum_reg_1250),
        .D(\sum_reg_125_reg[8]_i_1_n_8 ),
        .Q(sum_reg_125_reg__0[9]),
        .R(sum_reg_125));
  FDRE \tmp_2_reg_270_reg[0] 
       (.C(ap_clk),
        .CE(ap_NS_fsm112_out),
        .D(sum_reg_125_reg[32]),
        .Q(tmp_2_reg_270[0]),
        .R(1'b0));
  FDRE \tmp_2_reg_270_reg[10] 
       (.C(ap_clk),
        .CE(ap_NS_fsm112_out),
        .D(sum_reg_125_reg[42]),
        .Q(tmp_2_reg_270[10]),
        .R(1'b0));
  FDRE \tmp_2_reg_270_reg[11] 
       (.C(ap_clk),
        .CE(ap_NS_fsm112_out),
        .D(sum_reg_125_reg[43]),
        .Q(tmp_2_reg_270[11]),
        .R(1'b0));
  FDRE \tmp_2_reg_270_reg[12] 
       (.C(ap_clk),
        .CE(ap_NS_fsm112_out),
        .D(sum_reg_125_reg[44]),
        .Q(tmp_2_reg_270[12]),
        .R(1'b0));
  FDRE \tmp_2_reg_270_reg[13] 
       (.C(ap_clk),
        .CE(ap_NS_fsm112_out),
        .D(sum_reg_125_reg[45]),
        .Q(tmp_2_reg_270[13]),
        .R(1'b0));
  FDRE \tmp_2_reg_270_reg[14] 
       (.C(ap_clk),
        .CE(ap_NS_fsm112_out),
        .D(sum_reg_125_reg[46]),
        .Q(tmp_2_reg_270[14]),
        .R(1'b0));
  FDRE \tmp_2_reg_270_reg[15] 
       (.C(ap_clk),
        .CE(ap_NS_fsm112_out),
        .D(sum_reg_125_reg[47]),
        .Q(tmp_2_reg_270[15]),
        .R(1'b0));
  FDRE \tmp_2_reg_270_reg[16] 
       (.C(ap_clk),
        .CE(ap_NS_fsm112_out),
        .D(sum_reg_125_reg[48]),
        .Q(tmp_2_reg_270[16]),
        .R(1'b0));
  FDRE \tmp_2_reg_270_reg[17] 
       (.C(ap_clk),
        .CE(ap_NS_fsm112_out),
        .D(sum_reg_125_reg[49]),
        .Q(tmp_2_reg_270[17]),
        .R(1'b0));
  FDRE \tmp_2_reg_270_reg[18] 
       (.C(ap_clk),
        .CE(ap_NS_fsm112_out),
        .D(sum_reg_125_reg[50]),
        .Q(tmp_2_reg_270[18]),
        .R(1'b0));
  FDRE \tmp_2_reg_270_reg[19] 
       (.C(ap_clk),
        .CE(ap_NS_fsm112_out),
        .D(sum_reg_125_reg[51]),
        .Q(tmp_2_reg_270[19]),
        .R(1'b0));
  FDRE \tmp_2_reg_270_reg[1] 
       (.C(ap_clk),
        .CE(ap_NS_fsm112_out),
        .D(sum_reg_125_reg[33]),
        .Q(tmp_2_reg_270[1]),
        .R(1'b0));
  FDRE \tmp_2_reg_270_reg[20] 
       (.C(ap_clk),
        .CE(ap_NS_fsm112_out),
        .D(sum_reg_125_reg[52]),
        .Q(tmp_2_reg_270[20]),
        .R(1'b0));
  FDRE \tmp_2_reg_270_reg[21] 
       (.C(ap_clk),
        .CE(ap_NS_fsm112_out),
        .D(sum_reg_125_reg[53]),
        .Q(tmp_2_reg_270[21]),
        .R(1'b0));
  FDRE \tmp_2_reg_270_reg[22] 
       (.C(ap_clk),
        .CE(ap_NS_fsm112_out),
        .D(sum_reg_125_reg[54]),
        .Q(tmp_2_reg_270[22]),
        .R(1'b0));
  FDRE \tmp_2_reg_270_reg[23] 
       (.C(ap_clk),
        .CE(ap_NS_fsm112_out),
        .D(sum_reg_125_reg[55]),
        .Q(tmp_2_reg_270[23]),
        .R(1'b0));
  FDRE \tmp_2_reg_270_reg[24] 
       (.C(ap_clk),
        .CE(ap_NS_fsm112_out),
        .D(sum_reg_125_reg[56]),
        .Q(tmp_2_reg_270[24]),
        .R(1'b0));
  FDRE \tmp_2_reg_270_reg[25] 
       (.C(ap_clk),
        .CE(ap_NS_fsm112_out),
        .D(sum_reg_125_reg[57]),
        .Q(tmp_2_reg_270[25]),
        .R(1'b0));
  FDRE \tmp_2_reg_270_reg[26] 
       (.C(ap_clk),
        .CE(ap_NS_fsm112_out),
        .D(sum_reg_125_reg[58]),
        .Q(tmp_2_reg_270[26]),
        .R(1'b0));
  FDRE \tmp_2_reg_270_reg[27] 
       (.C(ap_clk),
        .CE(ap_NS_fsm112_out),
        .D(sum_reg_125_reg[59]),
        .Q(tmp_2_reg_270[27]),
        .R(1'b0));
  FDRE \tmp_2_reg_270_reg[28] 
       (.C(ap_clk),
        .CE(ap_NS_fsm112_out),
        .D(sum_reg_125_reg[60]),
        .Q(tmp_2_reg_270[28]),
        .R(1'b0));
  FDRE \tmp_2_reg_270_reg[29] 
       (.C(ap_clk),
        .CE(ap_NS_fsm112_out),
        .D(sum_reg_125_reg[61]),
        .Q(tmp_2_reg_270[29]),
        .R(1'b0));
  FDRE \tmp_2_reg_270_reg[2] 
       (.C(ap_clk),
        .CE(ap_NS_fsm112_out),
        .D(sum_reg_125_reg[34]),
        .Q(tmp_2_reg_270[2]),
        .R(1'b0));
  FDRE \tmp_2_reg_270_reg[30] 
       (.C(ap_clk),
        .CE(ap_NS_fsm112_out),
        .D(sum_reg_125_reg[62]),
        .Q(tmp_2_reg_270[30]),
        .R(1'b0));
  FDRE \tmp_2_reg_270_reg[31] 
       (.C(ap_clk),
        .CE(ap_NS_fsm112_out),
        .D(sum_reg_125_reg[63]),
        .Q(tmp_2_reg_270[31]),
        .R(1'b0));
  FDRE \tmp_2_reg_270_reg[3] 
       (.C(ap_clk),
        .CE(ap_NS_fsm112_out),
        .D(sum_reg_125_reg[35]),
        .Q(tmp_2_reg_270[3]),
        .R(1'b0));
  FDRE \tmp_2_reg_270_reg[4] 
       (.C(ap_clk),
        .CE(ap_NS_fsm112_out),
        .D(sum_reg_125_reg[36]),
        .Q(tmp_2_reg_270[4]),
        .R(1'b0));
  FDRE \tmp_2_reg_270_reg[5] 
       (.C(ap_clk),
        .CE(ap_NS_fsm112_out),
        .D(sum_reg_125_reg[37]),
        .Q(tmp_2_reg_270[5]),
        .R(1'b0));
  FDRE \tmp_2_reg_270_reg[6] 
       (.C(ap_clk),
        .CE(ap_NS_fsm112_out),
        .D(sum_reg_125_reg[38]),
        .Q(tmp_2_reg_270[6]),
        .R(1'b0));
  FDRE \tmp_2_reg_270_reg[7] 
       (.C(ap_clk),
        .CE(ap_NS_fsm112_out),
        .D(sum_reg_125_reg[39]),
        .Q(tmp_2_reg_270[7]),
        .R(1'b0));
  FDRE \tmp_2_reg_270_reg[8] 
       (.C(ap_clk),
        .CE(ap_NS_fsm112_out),
        .D(sum_reg_125_reg[40]),
        .Q(tmp_2_reg_270[8]),
        .R(1'b0));
  FDRE \tmp_2_reg_270_reg[9] 
       (.C(ap_clk),
        .CE(ap_NS_fsm112_out),
        .D(sum_reg_125_reg[41]),
        .Q(tmp_2_reg_270[9]),
        .R(1'b0));
endmodule

module design_1_simple_accel_core_0_3_simple_accel_core_control_s_axi
   (\FSM_onehot_wstate_reg[1]_0 ,
    \FSM_onehot_wstate_reg[2]_0 ,
    s_axi_control_BVALID,
    \FSM_onehot_rstate_reg[1]_0 ,
    s_axi_control_RVALID,
    ap_start,
    Q,
    \int_in_buf_reg[31]_0 ,
    \int_out_buf_reg[31]_0 ,
    interrupt,
    D,
    E,
    s_axi_control_RDATA,
    SR,
    ap_clk,
    ap_done,
    s_axi_control_AWVALID,
    s_axi_control_WVALID,
    s_axi_control_BREADY,
    s_axi_control_WDATA,
    s_axi_control_WSTRB,
    s_axi_control_ARVALID,
    s_axi_control_RREADY,
    s_axi_control_ARADDR,
    \ap_CS_fsm_reg[1] ,
    \ap_CS_fsm_reg[1]_0 ,
    int_ap_start_reg_0,
    \ap_CS_fsm_reg[1]_1 ,
    s_axi_control_AWADDR,
    gmem_BVALID);
  output \FSM_onehot_wstate_reg[1]_0 ;
  output \FSM_onehot_wstate_reg[2]_0 ;
  output s_axi_control_BVALID;
  output \FSM_onehot_rstate_reg[1]_0 ;
  output s_axi_control_RVALID;
  output ap_start;
  output [31:0]Q;
  output [29:0]\int_in_buf_reg[31]_0 ;
  output [29:0]\int_out_buf_reg[31]_0 ;
  output interrupt;
  output [0:0]D;
  output [0:0]E;
  output [31:0]s_axi_control_RDATA;
  input [0:0]SR;
  input ap_clk;
  input ap_done;
  input s_axi_control_AWVALID;
  input s_axi_control_WVALID;
  input s_axi_control_BREADY;
  input [31:0]s_axi_control_WDATA;
  input [3:0]s_axi_control_WSTRB;
  input s_axi_control_ARVALID;
  input s_axi_control_RREADY;
  input [5:0]s_axi_control_ARADDR;
  input \ap_CS_fsm_reg[1] ;
  input \ap_CS_fsm_reg[1]_0 ;
  input [3:0]int_ap_start_reg_0;
  input [0:0]\ap_CS_fsm_reg[1]_1 ;
  input [5:0]s_axi_control_AWADDR;
  input gmem_BVALID;

  wire [0:0]D;
  wire [0:0]E;
  wire \FSM_onehot_rstate[1]_i_1_n_2 ;
  wire \FSM_onehot_rstate[2]_i_1_n_2 ;
  wire \FSM_onehot_rstate_reg[1]_0 ;
  wire \FSM_onehot_wstate[1]_i_1_n_2 ;
  wire \FSM_onehot_wstate[2]_i_1_n_2 ;
  wire \FSM_onehot_wstate[3]_i_1_n_2 ;
  wire \FSM_onehot_wstate_reg[1]_0 ;
  wire \FSM_onehot_wstate_reg[2]_0 ;
  wire [31:0]Q;
  wire [0:0]SR;
  wire \ap_CS_fsm_reg[1] ;
  wire \ap_CS_fsm_reg[1]_0 ;
  wire [0:0]\ap_CS_fsm_reg[1]_1 ;
  wire ap_clk;
  wire ap_done;
  wire ap_idle;
  wire ap_start;
  wire ar_hs;
  wire [7:1]data0;
  wire gmem_BVALID;
  wire int_ap_done_i_1_n_2;
  wire int_ap_start3_out;
  wire int_ap_start_i_1_n_2;
  wire [3:0]int_ap_start_reg_0;
  wire int_auto_restart_i_1_n_2;
  wire int_gie_i_1_n_2;
  wire int_gie_reg_n_2;
  wire \int_ier[0]_i_1_n_2 ;
  wire \int_ier[1]_i_1_n_2 ;
  wire \int_ier[1]_i_2_n_2 ;
  wire \int_ier_reg_n_2_[0] ;
  wire [31:0]int_in_buf0;
  wire \int_in_buf[31]_i_1_n_2 ;
  wire \int_in_buf[31]_i_3_n_2 ;
  wire [29:0]\int_in_buf_reg[31]_0 ;
  wire \int_in_buf_reg_n_2_[0] ;
  wire \int_in_buf_reg_n_2_[1] ;
  wire int_isr6_out;
  wire \int_isr[0]_i_1_n_2 ;
  wire \int_isr[1]_i_1_n_2 ;
  wire \int_isr_reg_n_2_[0] ;
  wire [31:0]int_num_items0;
  wire \int_num_items[31]_i_1_n_2 ;
  wire \int_num_items[31]_i_3_n_2 ;
  wire [31:0]int_out_buf0;
  wire \int_out_buf[31]_i_1_n_2 ;
  wire [29:0]\int_out_buf_reg[31]_0 ;
  wire \int_out_buf_reg_n_2_[0] ;
  wire \int_out_buf_reg_n_2_[1] ;
  wire interrupt;
  wire p_0_in;
  wire p_1_in;
  wire [31:0]rdata;
  wire \rdata[0]_i_2_n_2 ;
  wire \rdata[0]_i_3_n_2 ;
  wire \rdata[1]_i_2_n_2 ;
  wire \rdata[1]_i_3_n_2 ;
  wire \rdata[2]_i_2_n_2 ;
  wire \rdata[31]_i_3_n_2 ;
  wire \rdata[31]_i_4_n_2 ;
  wire \rdata[31]_i_5_n_2 ;
  wire \rdata[3]_i_2_n_2 ;
  wire \rdata[7]_i_2_n_2 ;
  wire [5:0]s_axi_control_ARADDR;
  wire s_axi_control_ARVALID;
  wire [5:0]s_axi_control_AWADDR;
  wire s_axi_control_AWVALID;
  wire s_axi_control_BREADY;
  wire s_axi_control_BVALID;
  wire [31:0]s_axi_control_RDATA;
  wire s_axi_control_RREADY;
  wire s_axi_control_RVALID;
  wire [31:0]s_axi_control_WDATA;
  wire [3:0]s_axi_control_WSTRB;
  wire s_axi_control_WVALID;
  wire waddr;
  wire \waddr_reg_n_2_[0] ;
  wire \waddr_reg_n_2_[1] ;
  wire \waddr_reg_n_2_[2] ;
  wire \waddr_reg_n_2_[3] ;
  wire \waddr_reg_n_2_[4] ;
  wire \waddr_reg_n_2_[5] ;

  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'h8BFB)) 
    \FSM_onehot_rstate[1]_i_1 
       (.I0(s_axi_control_RREADY),
        .I1(s_axi_control_RVALID),
        .I2(\FSM_onehot_rstate_reg[1]_0 ),
        .I3(s_axi_control_ARVALID),
        .O(\FSM_onehot_rstate[1]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'h8F88)) 
    \FSM_onehot_rstate[2]_i_1 
       (.I0(s_axi_control_ARVALID),
        .I1(\FSM_onehot_rstate_reg[1]_0 ),
        .I2(s_axi_control_RREADY),
        .I3(s_axi_control_RVALID),
        .O(\FSM_onehot_rstate[2]_i_1_n_2 ));
  (* FSM_ENCODED_STATES = "RDIDLE:010,RDDATA:100,iSTATE:001" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_rstate_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\FSM_onehot_rstate[1]_i_1_n_2 ),
        .Q(\FSM_onehot_rstate_reg[1]_0 ),
        .R(SR));
  (* FSM_ENCODED_STATES = "RDIDLE:010,RDDATA:100,iSTATE:001" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_rstate_reg[2] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\FSM_onehot_rstate[2]_i_1_n_2 ),
        .Q(s_axi_control_RVALID),
        .R(SR));
  LUT5 #(
    .INIT(32'hFF474447)) 
    \FSM_onehot_wstate[1]_i_1 
       (.I0(s_axi_control_AWVALID),
        .I1(\FSM_onehot_wstate_reg[1]_0 ),
        .I2(\FSM_onehot_wstate_reg[2]_0 ),
        .I3(s_axi_control_BVALID),
        .I4(s_axi_control_BREADY),
        .O(\FSM_onehot_wstate[1]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'h8F88)) 
    \FSM_onehot_wstate[2]_i_1 
       (.I0(\FSM_onehot_wstate_reg[1]_0 ),
        .I1(s_axi_control_AWVALID),
        .I2(s_axi_control_WVALID),
        .I3(\FSM_onehot_wstate_reg[2]_0 ),
        .O(\FSM_onehot_wstate[2]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'h8F88)) 
    \FSM_onehot_wstate[3]_i_1 
       (.I0(s_axi_control_WVALID),
        .I1(\FSM_onehot_wstate_reg[2]_0 ),
        .I2(s_axi_control_BREADY),
        .I3(s_axi_control_BVALID),
        .O(\FSM_onehot_wstate[3]_i_1_n_2 ));
  (* FSM_ENCODED_STATES = "WRDATA:0100,WRRESP:1000,WRIDLE:0010,iSTATE:0001" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_wstate_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\FSM_onehot_wstate[1]_i_1_n_2 ),
        .Q(\FSM_onehot_wstate_reg[1]_0 ),
        .R(SR));
  (* FSM_ENCODED_STATES = "WRDATA:0100,WRRESP:1000,WRIDLE:0010,iSTATE:0001" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_wstate_reg[2] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\FSM_onehot_wstate[2]_i_1_n_2 ),
        .Q(\FSM_onehot_wstate_reg[2]_0 ),
        .R(SR));
  (* FSM_ENCODED_STATES = "WRDATA:0100,WRRESP:1000,WRIDLE:0010,iSTATE:0001" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_wstate_reg[3] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\FSM_onehot_wstate[3]_i_1_n_2 ),
        .Q(s_axi_control_BVALID),
        .R(SR));
  LUT6 #(
    .INIT(64'hAAAAAAAAAAAAAABA)) 
    \ap_CS_fsm[1]_i_1 
       (.I0(E),
        .I1(\ap_CS_fsm_reg[1] ),
        .I2(\ap_CS_fsm_reg[1]_0 ),
        .I3(int_ap_start_reg_0[1]),
        .I4(int_ap_start_reg_0[2]),
        .I5(\ap_CS_fsm_reg[1]_1 ),
        .O(D));
  LUT6 #(
    .INIT(64'hFFFBFFFFAAAAAAAA)) 
    int_ap_done_i_1
       (.I0(ap_done),
        .I1(ar_hs),
        .I2(s_axi_control_ARADDR[2]),
        .I3(s_axi_control_ARADDR[3]),
        .I4(\rdata[31]_i_5_n_2 ),
        .I5(data0[1]),
        .O(int_ap_done_i_1_n_2));
  FDRE #(
    .INIT(1'b0)) 
    int_ap_done_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(int_ap_done_i_1_n_2),
        .Q(data0[1]),
        .R(SR));
  (* SOFT_HLUTNM = "soft_lutpair51" *) 
  LUT2 #(
    .INIT(4'h2)) 
    int_ap_idle_i_1
       (.I0(int_ap_start_reg_0[0]),
        .I1(ap_start),
        .O(ap_idle));
  FDRE int_ap_idle_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(ap_idle),
        .Q(data0[2]),
        .R(SR));
  FDRE int_ap_ready_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(ap_done),
        .Q(data0[3]),
        .R(SR));
  LUT5 #(
    .INIT(32'hFFBFFF80)) 
    int_ap_start_i_1
       (.I0(data0[7]),
        .I1(gmem_BVALID),
        .I2(int_ap_start_reg_0[3]),
        .I3(int_ap_start3_out),
        .I4(ap_start),
        .O(int_ap_start_i_1_n_2));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h00000200)) 
    int_ap_start_i_2
       (.I0(s_axi_control_WDATA[0]),
        .I1(\waddr_reg_n_2_[3] ),
        .I2(\int_ier[1]_i_2_n_2 ),
        .I3(s_axi_control_WSTRB[0]),
        .I4(\waddr_reg_n_2_[2] ),
        .O(int_ap_start3_out));
  FDRE #(
    .INIT(1'b0)) 
    int_ap_start_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(int_ap_start_i_1_n_2),
        .Q(ap_start),
        .R(SR));
  LUT6 #(
    .INIT(64'hFFFFFFEF00000020)) 
    int_auto_restart_i_1
       (.I0(s_axi_control_WDATA[7]),
        .I1(\waddr_reg_n_2_[2] ),
        .I2(s_axi_control_WSTRB[0]),
        .I3(\int_ier[1]_i_2_n_2 ),
        .I4(\waddr_reg_n_2_[3] ),
        .I5(data0[7]),
        .O(int_auto_restart_i_1_n_2));
  FDRE #(
    .INIT(1'b0)) 
    int_auto_restart_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(int_auto_restart_i_1_n_2),
        .Q(data0[7]),
        .R(SR));
  LUT6 #(
    .INIT(64'hFEFFFFFF02000000)) 
    int_gie_i_1
       (.I0(s_axi_control_WDATA[0]),
        .I1(\int_ier[1]_i_2_n_2 ),
        .I2(\waddr_reg_n_2_[3] ),
        .I3(s_axi_control_WSTRB[0]),
        .I4(\waddr_reg_n_2_[2] ),
        .I5(int_gie_reg_n_2),
        .O(int_gie_i_1_n_2));
  FDRE #(
    .INIT(1'b0)) 
    int_gie_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(int_gie_i_1_n_2),
        .Q(int_gie_reg_n_2),
        .R(SR));
  LUT6 #(
    .INIT(64'hFFFFEFFF00002000)) 
    \int_ier[0]_i_1 
       (.I0(s_axi_control_WDATA[0]),
        .I1(\waddr_reg_n_2_[2] ),
        .I2(s_axi_control_WSTRB[0]),
        .I3(\waddr_reg_n_2_[3] ),
        .I4(\int_ier[1]_i_2_n_2 ),
        .I5(\int_ier_reg_n_2_[0] ),
        .O(\int_ier[0]_i_1_n_2 ));
  LUT6 #(
    .INIT(64'hFFFFEFFF00002000)) 
    \int_ier[1]_i_1 
       (.I0(s_axi_control_WDATA[1]),
        .I1(\waddr_reg_n_2_[2] ),
        .I2(s_axi_control_WSTRB[0]),
        .I3(\waddr_reg_n_2_[3] ),
        .I4(\int_ier[1]_i_2_n_2 ),
        .I5(p_0_in),
        .O(\int_ier[1]_i_1_n_2 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFEFFFFFF)) 
    \int_ier[1]_i_2 
       (.I0(\waddr_reg_n_2_[5] ),
        .I1(\waddr_reg_n_2_[0] ),
        .I2(\waddr_reg_n_2_[1] ),
        .I3(s_axi_control_WVALID),
        .I4(\FSM_onehot_wstate_reg[2]_0 ),
        .I5(\waddr_reg_n_2_[4] ),
        .O(\int_ier[1]_i_2_n_2 ));
  FDRE #(
    .INIT(1'b0)) 
    \int_ier_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\int_ier[0]_i_1_n_2 ),
        .Q(\int_ier_reg_n_2_[0] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_ier_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\int_ier[1]_i_1_n_2 ),
        .Q(p_0_in),
        .R(SR));
  LUT3 #(
    .INIT(8'hB8)) 
    \int_in_buf[0]_i_1 
       (.I0(s_axi_control_WDATA[0]),
        .I1(s_axi_control_WSTRB[0]),
        .I2(\int_in_buf_reg_n_2_[0] ),
        .O(int_in_buf0[0]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_in_buf[10]_i_1 
       (.I0(s_axi_control_WDATA[10]),
        .I1(s_axi_control_WSTRB[1]),
        .I2(\int_in_buf_reg[31]_0 [8]),
        .O(int_in_buf0[10]));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_in_buf[11]_i_1 
       (.I0(s_axi_control_WDATA[11]),
        .I1(s_axi_control_WSTRB[1]),
        .I2(\int_in_buf_reg[31]_0 [9]),
        .O(int_in_buf0[11]));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_in_buf[12]_i_1 
       (.I0(s_axi_control_WDATA[12]),
        .I1(s_axi_control_WSTRB[1]),
        .I2(\int_in_buf_reg[31]_0 [10]),
        .O(int_in_buf0[12]));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_in_buf[13]_i_1 
       (.I0(s_axi_control_WDATA[13]),
        .I1(s_axi_control_WSTRB[1]),
        .I2(\int_in_buf_reg[31]_0 [11]),
        .O(int_in_buf0[13]));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_in_buf[14]_i_1 
       (.I0(s_axi_control_WDATA[14]),
        .I1(s_axi_control_WSTRB[1]),
        .I2(\int_in_buf_reg[31]_0 [12]),
        .O(int_in_buf0[14]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_in_buf[15]_i_1 
       (.I0(s_axi_control_WDATA[15]),
        .I1(s_axi_control_WSTRB[1]),
        .I2(\int_in_buf_reg[31]_0 [13]),
        .O(int_in_buf0[15]));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_in_buf[16]_i_1 
       (.I0(s_axi_control_WDATA[16]),
        .I1(s_axi_control_WSTRB[2]),
        .I2(\int_in_buf_reg[31]_0 [14]),
        .O(int_in_buf0[16]));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_in_buf[17]_i_1 
       (.I0(s_axi_control_WDATA[17]),
        .I1(s_axi_control_WSTRB[2]),
        .I2(\int_in_buf_reg[31]_0 [15]),
        .O(int_in_buf0[17]));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_in_buf[18]_i_1 
       (.I0(s_axi_control_WDATA[18]),
        .I1(s_axi_control_WSTRB[2]),
        .I2(\int_in_buf_reg[31]_0 [16]),
        .O(int_in_buf0[18]));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_in_buf[19]_i_1 
       (.I0(s_axi_control_WDATA[19]),
        .I1(s_axi_control_WSTRB[2]),
        .I2(\int_in_buf_reg[31]_0 [17]),
        .O(int_in_buf0[19]));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_in_buf[1]_i_1 
       (.I0(s_axi_control_WDATA[1]),
        .I1(s_axi_control_WSTRB[0]),
        .I2(\int_in_buf_reg_n_2_[1] ),
        .O(int_in_buf0[1]));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_in_buf[20]_i_1 
       (.I0(s_axi_control_WDATA[20]),
        .I1(s_axi_control_WSTRB[2]),
        .I2(\int_in_buf_reg[31]_0 [18]),
        .O(int_in_buf0[20]));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_in_buf[21]_i_1 
       (.I0(s_axi_control_WDATA[21]),
        .I1(s_axi_control_WSTRB[2]),
        .I2(\int_in_buf_reg[31]_0 [19]),
        .O(int_in_buf0[21]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_in_buf[22]_i_1 
       (.I0(s_axi_control_WDATA[22]),
        .I1(s_axi_control_WSTRB[2]),
        .I2(\int_in_buf_reg[31]_0 [20]),
        .O(int_in_buf0[22]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_in_buf[23]_i_1 
       (.I0(s_axi_control_WDATA[23]),
        .I1(s_axi_control_WSTRB[2]),
        .I2(\int_in_buf_reg[31]_0 [21]),
        .O(int_in_buf0[23]));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_in_buf[24]_i_1 
       (.I0(s_axi_control_WDATA[24]),
        .I1(s_axi_control_WSTRB[3]),
        .I2(\int_in_buf_reg[31]_0 [22]),
        .O(int_in_buf0[24]));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_in_buf[25]_i_1 
       (.I0(s_axi_control_WDATA[25]),
        .I1(s_axi_control_WSTRB[3]),
        .I2(\int_in_buf_reg[31]_0 [23]),
        .O(int_in_buf0[25]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_in_buf[26]_i_1 
       (.I0(s_axi_control_WDATA[26]),
        .I1(s_axi_control_WSTRB[3]),
        .I2(\int_in_buf_reg[31]_0 [24]),
        .O(int_in_buf0[26]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_in_buf[27]_i_1 
       (.I0(s_axi_control_WDATA[27]),
        .I1(s_axi_control_WSTRB[3]),
        .I2(\int_in_buf_reg[31]_0 [25]),
        .O(int_in_buf0[27]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_in_buf[28]_i_1 
       (.I0(s_axi_control_WDATA[28]),
        .I1(s_axi_control_WSTRB[3]),
        .I2(\int_in_buf_reg[31]_0 [26]),
        .O(int_in_buf0[28]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_in_buf[29]_i_1 
       (.I0(s_axi_control_WDATA[29]),
        .I1(s_axi_control_WSTRB[3]),
        .I2(\int_in_buf_reg[31]_0 [27]),
        .O(int_in_buf0[29]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_in_buf[2]_i_1 
       (.I0(s_axi_control_WDATA[2]),
        .I1(s_axi_control_WSTRB[0]),
        .I2(\int_in_buf_reg[31]_0 [0]),
        .O(int_in_buf0[2]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_in_buf[30]_i_1 
       (.I0(s_axi_control_WDATA[30]),
        .I1(s_axi_control_WSTRB[3]),
        .I2(\int_in_buf_reg[31]_0 [28]),
        .O(int_in_buf0[30]));
  LUT3 #(
    .INIT(8'h10)) 
    \int_in_buf[31]_i_1 
       (.I0(\waddr_reg_n_2_[3] ),
        .I1(\waddr_reg_n_2_[2] ),
        .I2(\int_in_buf[31]_i_3_n_2 ),
        .O(\int_in_buf[31]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_in_buf[31]_i_2 
       (.I0(s_axi_control_WDATA[31]),
        .I1(s_axi_control_WSTRB[3]),
        .I2(\int_in_buf_reg[31]_0 [29]),
        .O(int_in_buf0[31]));
  LUT6 #(
    .INIT(64'h0000000000080000)) 
    \int_in_buf[31]_i_3 
       (.I0(\FSM_onehot_wstate_reg[2]_0 ),
        .I1(s_axi_control_WVALID),
        .I2(\waddr_reg_n_2_[1] ),
        .I3(\waddr_reg_n_2_[0] ),
        .I4(\waddr_reg_n_2_[4] ),
        .I5(\waddr_reg_n_2_[5] ),
        .O(\int_in_buf[31]_i_3_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_in_buf[3]_i_1 
       (.I0(s_axi_control_WDATA[3]),
        .I1(s_axi_control_WSTRB[0]),
        .I2(\int_in_buf_reg[31]_0 [1]),
        .O(int_in_buf0[3]));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_in_buf[4]_i_1 
       (.I0(s_axi_control_WDATA[4]),
        .I1(s_axi_control_WSTRB[0]),
        .I2(\int_in_buf_reg[31]_0 [2]),
        .O(int_in_buf0[4]));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_in_buf[5]_i_1 
       (.I0(s_axi_control_WDATA[5]),
        .I1(s_axi_control_WSTRB[0]),
        .I2(\int_in_buf_reg[31]_0 [3]),
        .O(int_in_buf0[5]));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_in_buf[6]_i_1 
       (.I0(s_axi_control_WDATA[6]),
        .I1(s_axi_control_WSTRB[0]),
        .I2(\int_in_buf_reg[31]_0 [4]),
        .O(int_in_buf0[6]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_in_buf[7]_i_1 
       (.I0(s_axi_control_WDATA[7]),
        .I1(s_axi_control_WSTRB[0]),
        .I2(\int_in_buf_reg[31]_0 [5]),
        .O(int_in_buf0[7]));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_in_buf[8]_i_1 
       (.I0(s_axi_control_WDATA[8]),
        .I1(s_axi_control_WSTRB[1]),
        .I2(\int_in_buf_reg[31]_0 [6]),
        .O(int_in_buf0[8]));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_in_buf[9]_i_1 
       (.I0(s_axi_control_WDATA[9]),
        .I1(s_axi_control_WSTRB[1]),
        .I2(\int_in_buf_reg[31]_0 [7]),
        .O(int_in_buf0[9]));
  FDRE #(
    .INIT(1'b0)) 
    \int_in_buf_reg[0] 
       (.C(ap_clk),
        .CE(\int_in_buf[31]_i_1_n_2 ),
        .D(int_in_buf0[0]),
        .Q(\int_in_buf_reg_n_2_[0] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_in_buf_reg[10] 
       (.C(ap_clk),
        .CE(\int_in_buf[31]_i_1_n_2 ),
        .D(int_in_buf0[10]),
        .Q(\int_in_buf_reg[31]_0 [8]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_in_buf_reg[11] 
       (.C(ap_clk),
        .CE(\int_in_buf[31]_i_1_n_2 ),
        .D(int_in_buf0[11]),
        .Q(\int_in_buf_reg[31]_0 [9]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_in_buf_reg[12] 
       (.C(ap_clk),
        .CE(\int_in_buf[31]_i_1_n_2 ),
        .D(int_in_buf0[12]),
        .Q(\int_in_buf_reg[31]_0 [10]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_in_buf_reg[13] 
       (.C(ap_clk),
        .CE(\int_in_buf[31]_i_1_n_2 ),
        .D(int_in_buf0[13]),
        .Q(\int_in_buf_reg[31]_0 [11]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_in_buf_reg[14] 
       (.C(ap_clk),
        .CE(\int_in_buf[31]_i_1_n_2 ),
        .D(int_in_buf0[14]),
        .Q(\int_in_buf_reg[31]_0 [12]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_in_buf_reg[15] 
       (.C(ap_clk),
        .CE(\int_in_buf[31]_i_1_n_2 ),
        .D(int_in_buf0[15]),
        .Q(\int_in_buf_reg[31]_0 [13]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_in_buf_reg[16] 
       (.C(ap_clk),
        .CE(\int_in_buf[31]_i_1_n_2 ),
        .D(int_in_buf0[16]),
        .Q(\int_in_buf_reg[31]_0 [14]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_in_buf_reg[17] 
       (.C(ap_clk),
        .CE(\int_in_buf[31]_i_1_n_2 ),
        .D(int_in_buf0[17]),
        .Q(\int_in_buf_reg[31]_0 [15]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_in_buf_reg[18] 
       (.C(ap_clk),
        .CE(\int_in_buf[31]_i_1_n_2 ),
        .D(int_in_buf0[18]),
        .Q(\int_in_buf_reg[31]_0 [16]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_in_buf_reg[19] 
       (.C(ap_clk),
        .CE(\int_in_buf[31]_i_1_n_2 ),
        .D(int_in_buf0[19]),
        .Q(\int_in_buf_reg[31]_0 [17]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_in_buf_reg[1] 
       (.C(ap_clk),
        .CE(\int_in_buf[31]_i_1_n_2 ),
        .D(int_in_buf0[1]),
        .Q(\int_in_buf_reg_n_2_[1] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_in_buf_reg[20] 
       (.C(ap_clk),
        .CE(\int_in_buf[31]_i_1_n_2 ),
        .D(int_in_buf0[20]),
        .Q(\int_in_buf_reg[31]_0 [18]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_in_buf_reg[21] 
       (.C(ap_clk),
        .CE(\int_in_buf[31]_i_1_n_2 ),
        .D(int_in_buf0[21]),
        .Q(\int_in_buf_reg[31]_0 [19]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_in_buf_reg[22] 
       (.C(ap_clk),
        .CE(\int_in_buf[31]_i_1_n_2 ),
        .D(int_in_buf0[22]),
        .Q(\int_in_buf_reg[31]_0 [20]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_in_buf_reg[23] 
       (.C(ap_clk),
        .CE(\int_in_buf[31]_i_1_n_2 ),
        .D(int_in_buf0[23]),
        .Q(\int_in_buf_reg[31]_0 [21]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_in_buf_reg[24] 
       (.C(ap_clk),
        .CE(\int_in_buf[31]_i_1_n_2 ),
        .D(int_in_buf0[24]),
        .Q(\int_in_buf_reg[31]_0 [22]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_in_buf_reg[25] 
       (.C(ap_clk),
        .CE(\int_in_buf[31]_i_1_n_2 ),
        .D(int_in_buf0[25]),
        .Q(\int_in_buf_reg[31]_0 [23]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_in_buf_reg[26] 
       (.C(ap_clk),
        .CE(\int_in_buf[31]_i_1_n_2 ),
        .D(int_in_buf0[26]),
        .Q(\int_in_buf_reg[31]_0 [24]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_in_buf_reg[27] 
       (.C(ap_clk),
        .CE(\int_in_buf[31]_i_1_n_2 ),
        .D(int_in_buf0[27]),
        .Q(\int_in_buf_reg[31]_0 [25]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_in_buf_reg[28] 
       (.C(ap_clk),
        .CE(\int_in_buf[31]_i_1_n_2 ),
        .D(int_in_buf0[28]),
        .Q(\int_in_buf_reg[31]_0 [26]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_in_buf_reg[29] 
       (.C(ap_clk),
        .CE(\int_in_buf[31]_i_1_n_2 ),
        .D(int_in_buf0[29]),
        .Q(\int_in_buf_reg[31]_0 [27]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_in_buf_reg[2] 
       (.C(ap_clk),
        .CE(\int_in_buf[31]_i_1_n_2 ),
        .D(int_in_buf0[2]),
        .Q(\int_in_buf_reg[31]_0 [0]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_in_buf_reg[30] 
       (.C(ap_clk),
        .CE(\int_in_buf[31]_i_1_n_2 ),
        .D(int_in_buf0[30]),
        .Q(\int_in_buf_reg[31]_0 [28]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_in_buf_reg[31] 
       (.C(ap_clk),
        .CE(\int_in_buf[31]_i_1_n_2 ),
        .D(int_in_buf0[31]),
        .Q(\int_in_buf_reg[31]_0 [29]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_in_buf_reg[3] 
       (.C(ap_clk),
        .CE(\int_in_buf[31]_i_1_n_2 ),
        .D(int_in_buf0[3]),
        .Q(\int_in_buf_reg[31]_0 [1]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_in_buf_reg[4] 
       (.C(ap_clk),
        .CE(\int_in_buf[31]_i_1_n_2 ),
        .D(int_in_buf0[4]),
        .Q(\int_in_buf_reg[31]_0 [2]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_in_buf_reg[5] 
       (.C(ap_clk),
        .CE(\int_in_buf[31]_i_1_n_2 ),
        .D(int_in_buf0[5]),
        .Q(\int_in_buf_reg[31]_0 [3]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_in_buf_reg[6] 
       (.C(ap_clk),
        .CE(\int_in_buf[31]_i_1_n_2 ),
        .D(int_in_buf0[6]),
        .Q(\int_in_buf_reg[31]_0 [4]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_in_buf_reg[7] 
       (.C(ap_clk),
        .CE(\int_in_buf[31]_i_1_n_2 ),
        .D(int_in_buf0[7]),
        .Q(\int_in_buf_reg[31]_0 [5]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_in_buf_reg[8] 
       (.C(ap_clk),
        .CE(\int_in_buf[31]_i_1_n_2 ),
        .D(int_in_buf0[8]),
        .Q(\int_in_buf_reg[31]_0 [6]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_in_buf_reg[9] 
       (.C(ap_clk),
        .CE(\int_in_buf[31]_i_1_n_2 ),
        .D(int_in_buf0[9]),
        .Q(\int_in_buf_reg[31]_0 [7]),
        .R(SR));
  LUT6 #(
    .INIT(64'hF7777777F8888888)) 
    \int_isr[0]_i_1 
       (.I0(s_axi_control_WDATA[0]),
        .I1(int_isr6_out),
        .I2(int_ap_start_reg_0[3]),
        .I3(gmem_BVALID),
        .I4(\int_ier_reg_n_2_[0] ),
        .I5(\int_isr_reg_n_2_[0] ),
        .O(\int_isr[0]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h0080)) 
    \int_isr[0]_i_2 
       (.I0(s_axi_control_WSTRB[0]),
        .I1(\waddr_reg_n_2_[2] ),
        .I2(\waddr_reg_n_2_[3] ),
        .I3(\int_ier[1]_i_2_n_2 ),
        .O(int_isr6_out));
  LUT6 #(
    .INIT(64'hF7777777F8888888)) 
    \int_isr[1]_i_1 
       (.I0(s_axi_control_WDATA[1]),
        .I1(int_isr6_out),
        .I2(int_ap_start_reg_0[3]),
        .I3(gmem_BVALID),
        .I4(p_0_in),
        .I5(p_1_in),
        .O(\int_isr[1]_i_1_n_2 ));
  FDRE #(
    .INIT(1'b0)) 
    \int_isr_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\int_isr[0]_i_1_n_2 ),
        .Q(\int_isr_reg_n_2_[0] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_isr_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\int_isr[1]_i_1_n_2 ),
        .Q(p_1_in),
        .R(SR));
  (* SOFT_HLUTNM = "soft_lutpair50" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_num_items[0]_i_1 
       (.I0(s_axi_control_WDATA[0]),
        .I1(s_axi_control_WSTRB[0]),
        .I2(Q[0]),
        .O(int_num_items0[0]));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_num_items[10]_i_1 
       (.I0(s_axi_control_WDATA[10]),
        .I1(s_axi_control_WSTRB[1]),
        .I2(Q[10]),
        .O(int_num_items0[10]));
  (* SOFT_HLUTNM = "soft_lutpair46" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_num_items[11]_i_1 
       (.I0(s_axi_control_WDATA[11]),
        .I1(s_axi_control_WSTRB[1]),
        .I2(Q[11]),
        .O(int_num_items0[11]));
  (* SOFT_HLUTNM = "soft_lutpair45" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_num_items[12]_i_1 
       (.I0(s_axi_control_WDATA[12]),
        .I1(s_axi_control_WSTRB[1]),
        .I2(Q[12]),
        .O(int_num_items0[12]));
  (* SOFT_HLUTNM = "soft_lutpair45" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_num_items[13]_i_1 
       (.I0(s_axi_control_WDATA[13]),
        .I1(s_axi_control_WSTRB[1]),
        .I2(Q[13]),
        .O(int_num_items0[13]));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_num_items[14]_i_1 
       (.I0(s_axi_control_WDATA[14]),
        .I1(s_axi_control_WSTRB[1]),
        .I2(Q[14]),
        .O(int_num_items0[14]));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_num_items[15]_i_1 
       (.I0(s_axi_control_WDATA[15]),
        .I1(s_axi_control_WSTRB[1]),
        .I2(Q[15]),
        .O(int_num_items0[15]));
  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_num_items[16]_i_1 
       (.I0(s_axi_control_WDATA[16]),
        .I1(s_axi_control_WSTRB[2]),
        .I2(Q[16]),
        .O(int_num_items0[16]));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_num_items[17]_i_1 
       (.I0(s_axi_control_WDATA[17]),
        .I1(s_axi_control_WSTRB[2]),
        .I2(Q[17]),
        .O(int_num_items0[17]));
  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_num_items[18]_i_1 
       (.I0(s_axi_control_WDATA[18]),
        .I1(s_axi_control_WSTRB[2]),
        .I2(Q[18]),
        .O(int_num_items0[18]));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_num_items[19]_i_1 
       (.I0(s_axi_control_WDATA[19]),
        .I1(s_axi_control_WSTRB[2]),
        .I2(Q[19]),
        .O(int_num_items0[19]));
  (* SOFT_HLUTNM = "soft_lutpair50" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_num_items[1]_i_1 
       (.I0(s_axi_control_WDATA[1]),
        .I1(s_axi_control_WSTRB[0]),
        .I2(Q[1]),
        .O(int_num_items0[1]));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_num_items[20]_i_1 
       (.I0(s_axi_control_WDATA[20]),
        .I1(s_axi_control_WSTRB[2]),
        .I2(Q[20]),
        .O(int_num_items0[20]));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_num_items[21]_i_1 
       (.I0(s_axi_control_WDATA[21]),
        .I1(s_axi_control_WSTRB[2]),
        .I2(Q[21]),
        .O(int_num_items0[21]));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_num_items[22]_i_1 
       (.I0(s_axi_control_WDATA[22]),
        .I1(s_axi_control_WSTRB[2]),
        .I2(Q[22]),
        .O(int_num_items0[22]));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_num_items[23]_i_1 
       (.I0(s_axi_control_WDATA[23]),
        .I1(s_axi_control_WSTRB[2]),
        .I2(Q[23]),
        .O(int_num_items0[23]));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_num_items[24]_i_1 
       (.I0(s_axi_control_WDATA[24]),
        .I1(s_axi_control_WSTRB[3]),
        .I2(Q[24]),
        .O(int_num_items0[24]));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_num_items[25]_i_1 
       (.I0(s_axi_control_WDATA[25]),
        .I1(s_axi_control_WSTRB[3]),
        .I2(Q[25]),
        .O(int_num_items0[25]));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_num_items[26]_i_1 
       (.I0(s_axi_control_WDATA[26]),
        .I1(s_axi_control_WSTRB[3]),
        .I2(Q[26]),
        .O(int_num_items0[26]));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_num_items[27]_i_1 
       (.I0(s_axi_control_WDATA[27]),
        .I1(s_axi_control_WSTRB[3]),
        .I2(Q[27]),
        .O(int_num_items0[27]));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_num_items[28]_i_1 
       (.I0(s_axi_control_WDATA[28]),
        .I1(s_axi_control_WSTRB[3]),
        .I2(Q[28]),
        .O(int_num_items0[28]));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_num_items[29]_i_1 
       (.I0(s_axi_control_WDATA[29]),
        .I1(s_axi_control_WSTRB[3]),
        .I2(Q[29]),
        .O(int_num_items0[29]));
  (* SOFT_HLUTNM = "soft_lutpair49" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_num_items[2]_i_1 
       (.I0(s_axi_control_WDATA[2]),
        .I1(s_axi_control_WSTRB[0]),
        .I2(Q[2]),
        .O(int_num_items0[2]));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_num_items[30]_i_1 
       (.I0(s_axi_control_WDATA[30]),
        .I1(s_axi_control_WSTRB[3]),
        .I2(Q[30]),
        .O(int_num_items0[30]));
  LUT4 #(
    .INIT(16'h0200)) 
    \int_num_items[31]_i_1 
       (.I0(\int_num_items[31]_i_3_n_2 ),
        .I1(\waddr_reg_n_2_[2] ),
        .I2(\waddr_reg_n_2_[3] ),
        .I3(\waddr_reg_n_2_[5] ),
        .O(\int_num_items[31]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_num_items[31]_i_2 
       (.I0(s_axi_control_WDATA[31]),
        .I1(s_axi_control_WSTRB[3]),
        .I2(Q[31]),
        .O(int_num_items0[31]));
  LUT5 #(
    .INIT(32'h00000040)) 
    \int_num_items[31]_i_3 
       (.I0(\waddr_reg_n_2_[4] ),
        .I1(\FSM_onehot_wstate_reg[2]_0 ),
        .I2(s_axi_control_WVALID),
        .I3(\waddr_reg_n_2_[1] ),
        .I4(\waddr_reg_n_2_[0] ),
        .O(\int_num_items[31]_i_3_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair49" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_num_items[3]_i_1 
       (.I0(s_axi_control_WDATA[3]),
        .I1(s_axi_control_WSTRB[0]),
        .I2(Q[3]),
        .O(int_num_items0[3]));
  (* SOFT_HLUTNM = "soft_lutpair48" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_num_items[4]_i_1 
       (.I0(s_axi_control_WDATA[4]),
        .I1(s_axi_control_WSTRB[0]),
        .I2(Q[4]),
        .O(int_num_items0[4]));
  (* SOFT_HLUTNM = "soft_lutpair48" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_num_items[5]_i_1 
       (.I0(s_axi_control_WDATA[5]),
        .I1(s_axi_control_WSTRB[0]),
        .I2(Q[5]),
        .O(int_num_items0[5]));
  (* SOFT_HLUTNM = "soft_lutpair47" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_num_items[6]_i_1 
       (.I0(s_axi_control_WDATA[6]),
        .I1(s_axi_control_WSTRB[0]),
        .I2(Q[6]),
        .O(int_num_items0[6]));
  (* SOFT_HLUTNM = "soft_lutpair47" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_num_items[7]_i_1 
       (.I0(s_axi_control_WDATA[7]),
        .I1(s_axi_control_WSTRB[0]),
        .I2(Q[7]),
        .O(int_num_items0[7]));
  (* SOFT_HLUTNM = "soft_lutpair46" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_num_items[8]_i_1 
       (.I0(s_axi_control_WDATA[8]),
        .I1(s_axi_control_WSTRB[1]),
        .I2(Q[8]),
        .O(int_num_items0[8]));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_num_items[9]_i_1 
       (.I0(s_axi_control_WDATA[9]),
        .I1(s_axi_control_WSTRB[1]),
        .I2(Q[9]),
        .O(int_num_items0[9]));
  FDRE #(
    .INIT(1'b0)) 
    \int_num_items_reg[0] 
       (.C(ap_clk),
        .CE(\int_num_items[31]_i_1_n_2 ),
        .D(int_num_items0[0]),
        .Q(Q[0]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_num_items_reg[10] 
       (.C(ap_clk),
        .CE(\int_num_items[31]_i_1_n_2 ),
        .D(int_num_items0[10]),
        .Q(Q[10]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_num_items_reg[11] 
       (.C(ap_clk),
        .CE(\int_num_items[31]_i_1_n_2 ),
        .D(int_num_items0[11]),
        .Q(Q[11]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_num_items_reg[12] 
       (.C(ap_clk),
        .CE(\int_num_items[31]_i_1_n_2 ),
        .D(int_num_items0[12]),
        .Q(Q[12]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_num_items_reg[13] 
       (.C(ap_clk),
        .CE(\int_num_items[31]_i_1_n_2 ),
        .D(int_num_items0[13]),
        .Q(Q[13]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_num_items_reg[14] 
       (.C(ap_clk),
        .CE(\int_num_items[31]_i_1_n_2 ),
        .D(int_num_items0[14]),
        .Q(Q[14]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_num_items_reg[15] 
       (.C(ap_clk),
        .CE(\int_num_items[31]_i_1_n_2 ),
        .D(int_num_items0[15]),
        .Q(Q[15]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_num_items_reg[16] 
       (.C(ap_clk),
        .CE(\int_num_items[31]_i_1_n_2 ),
        .D(int_num_items0[16]),
        .Q(Q[16]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_num_items_reg[17] 
       (.C(ap_clk),
        .CE(\int_num_items[31]_i_1_n_2 ),
        .D(int_num_items0[17]),
        .Q(Q[17]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_num_items_reg[18] 
       (.C(ap_clk),
        .CE(\int_num_items[31]_i_1_n_2 ),
        .D(int_num_items0[18]),
        .Q(Q[18]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_num_items_reg[19] 
       (.C(ap_clk),
        .CE(\int_num_items[31]_i_1_n_2 ),
        .D(int_num_items0[19]),
        .Q(Q[19]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_num_items_reg[1] 
       (.C(ap_clk),
        .CE(\int_num_items[31]_i_1_n_2 ),
        .D(int_num_items0[1]),
        .Q(Q[1]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_num_items_reg[20] 
       (.C(ap_clk),
        .CE(\int_num_items[31]_i_1_n_2 ),
        .D(int_num_items0[20]),
        .Q(Q[20]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_num_items_reg[21] 
       (.C(ap_clk),
        .CE(\int_num_items[31]_i_1_n_2 ),
        .D(int_num_items0[21]),
        .Q(Q[21]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_num_items_reg[22] 
       (.C(ap_clk),
        .CE(\int_num_items[31]_i_1_n_2 ),
        .D(int_num_items0[22]),
        .Q(Q[22]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_num_items_reg[23] 
       (.C(ap_clk),
        .CE(\int_num_items[31]_i_1_n_2 ),
        .D(int_num_items0[23]),
        .Q(Q[23]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_num_items_reg[24] 
       (.C(ap_clk),
        .CE(\int_num_items[31]_i_1_n_2 ),
        .D(int_num_items0[24]),
        .Q(Q[24]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_num_items_reg[25] 
       (.C(ap_clk),
        .CE(\int_num_items[31]_i_1_n_2 ),
        .D(int_num_items0[25]),
        .Q(Q[25]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_num_items_reg[26] 
       (.C(ap_clk),
        .CE(\int_num_items[31]_i_1_n_2 ),
        .D(int_num_items0[26]),
        .Q(Q[26]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_num_items_reg[27] 
       (.C(ap_clk),
        .CE(\int_num_items[31]_i_1_n_2 ),
        .D(int_num_items0[27]),
        .Q(Q[27]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_num_items_reg[28] 
       (.C(ap_clk),
        .CE(\int_num_items[31]_i_1_n_2 ),
        .D(int_num_items0[28]),
        .Q(Q[28]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_num_items_reg[29] 
       (.C(ap_clk),
        .CE(\int_num_items[31]_i_1_n_2 ),
        .D(int_num_items0[29]),
        .Q(Q[29]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_num_items_reg[2] 
       (.C(ap_clk),
        .CE(\int_num_items[31]_i_1_n_2 ),
        .D(int_num_items0[2]),
        .Q(Q[2]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_num_items_reg[30] 
       (.C(ap_clk),
        .CE(\int_num_items[31]_i_1_n_2 ),
        .D(int_num_items0[30]),
        .Q(Q[30]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_num_items_reg[31] 
       (.C(ap_clk),
        .CE(\int_num_items[31]_i_1_n_2 ),
        .D(int_num_items0[31]),
        .Q(Q[31]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_num_items_reg[3] 
       (.C(ap_clk),
        .CE(\int_num_items[31]_i_1_n_2 ),
        .D(int_num_items0[3]),
        .Q(Q[3]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_num_items_reg[4] 
       (.C(ap_clk),
        .CE(\int_num_items[31]_i_1_n_2 ),
        .D(int_num_items0[4]),
        .Q(Q[4]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_num_items_reg[5] 
       (.C(ap_clk),
        .CE(\int_num_items[31]_i_1_n_2 ),
        .D(int_num_items0[5]),
        .Q(Q[5]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_num_items_reg[6] 
       (.C(ap_clk),
        .CE(\int_num_items[31]_i_1_n_2 ),
        .D(int_num_items0[6]),
        .Q(Q[6]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_num_items_reg[7] 
       (.C(ap_clk),
        .CE(\int_num_items[31]_i_1_n_2 ),
        .D(int_num_items0[7]),
        .Q(Q[7]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_num_items_reg[8] 
       (.C(ap_clk),
        .CE(\int_num_items[31]_i_1_n_2 ),
        .D(int_num_items0[8]),
        .Q(Q[8]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_num_items_reg[9] 
       (.C(ap_clk),
        .CE(\int_num_items[31]_i_1_n_2 ),
        .D(int_num_items0[9]),
        .Q(Q[9]),
        .R(SR));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_out_buf[0]_i_1 
       (.I0(s_axi_control_WDATA[0]),
        .I1(s_axi_control_WSTRB[0]),
        .I2(\int_out_buf_reg_n_2_[0] ),
        .O(int_out_buf0[0]));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_out_buf[10]_i_1 
       (.I0(s_axi_control_WDATA[10]),
        .I1(s_axi_control_WSTRB[1]),
        .I2(\int_out_buf_reg[31]_0 [8]),
        .O(int_out_buf0[10]));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_out_buf[11]_i_1 
       (.I0(s_axi_control_WDATA[11]),
        .I1(s_axi_control_WSTRB[1]),
        .I2(\int_out_buf_reg[31]_0 [9]),
        .O(int_out_buf0[11]));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_out_buf[12]_i_1 
       (.I0(s_axi_control_WDATA[12]),
        .I1(s_axi_control_WSTRB[1]),
        .I2(\int_out_buf_reg[31]_0 [10]),
        .O(int_out_buf0[12]));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_out_buf[13]_i_1 
       (.I0(s_axi_control_WDATA[13]),
        .I1(s_axi_control_WSTRB[1]),
        .I2(\int_out_buf_reg[31]_0 [11]),
        .O(int_out_buf0[13]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_out_buf[14]_i_1 
       (.I0(s_axi_control_WDATA[14]),
        .I1(s_axi_control_WSTRB[1]),
        .I2(\int_out_buf_reg[31]_0 [12]),
        .O(int_out_buf0[14]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_out_buf[15]_i_1 
       (.I0(s_axi_control_WDATA[15]),
        .I1(s_axi_control_WSTRB[1]),
        .I2(\int_out_buf_reg[31]_0 [13]),
        .O(int_out_buf0[15]));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_out_buf[16]_i_1 
       (.I0(s_axi_control_WDATA[16]),
        .I1(s_axi_control_WSTRB[2]),
        .I2(\int_out_buf_reg[31]_0 [14]),
        .O(int_out_buf0[16]));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_out_buf[17]_i_1 
       (.I0(s_axi_control_WDATA[17]),
        .I1(s_axi_control_WSTRB[2]),
        .I2(\int_out_buf_reg[31]_0 [15]),
        .O(int_out_buf0[17]));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_out_buf[18]_i_1 
       (.I0(s_axi_control_WDATA[18]),
        .I1(s_axi_control_WSTRB[2]),
        .I2(\int_out_buf_reg[31]_0 [16]),
        .O(int_out_buf0[18]));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_out_buf[19]_i_1 
       (.I0(s_axi_control_WDATA[19]),
        .I1(s_axi_control_WSTRB[2]),
        .I2(\int_out_buf_reg[31]_0 [17]),
        .O(int_out_buf0[19]));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_out_buf[1]_i_1 
       (.I0(s_axi_control_WDATA[1]),
        .I1(s_axi_control_WSTRB[0]),
        .I2(\int_out_buf_reg_n_2_[1] ),
        .O(int_out_buf0[1]));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_out_buf[20]_i_1 
       (.I0(s_axi_control_WDATA[20]),
        .I1(s_axi_control_WSTRB[2]),
        .I2(\int_out_buf_reg[31]_0 [18]),
        .O(int_out_buf0[20]));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_out_buf[21]_i_1 
       (.I0(s_axi_control_WDATA[21]),
        .I1(s_axi_control_WSTRB[2]),
        .I2(\int_out_buf_reg[31]_0 [19]),
        .O(int_out_buf0[21]));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_out_buf[22]_i_1 
       (.I0(s_axi_control_WDATA[22]),
        .I1(s_axi_control_WSTRB[2]),
        .I2(\int_out_buf_reg[31]_0 [20]),
        .O(int_out_buf0[22]));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_out_buf[23]_i_1 
       (.I0(s_axi_control_WDATA[23]),
        .I1(s_axi_control_WSTRB[2]),
        .I2(\int_out_buf_reg[31]_0 [21]),
        .O(int_out_buf0[23]));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_out_buf[24]_i_1 
       (.I0(s_axi_control_WDATA[24]),
        .I1(s_axi_control_WSTRB[3]),
        .I2(\int_out_buf_reg[31]_0 [22]),
        .O(int_out_buf0[24]));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_out_buf[25]_i_1 
       (.I0(s_axi_control_WDATA[25]),
        .I1(s_axi_control_WSTRB[3]),
        .I2(\int_out_buf_reg[31]_0 [23]),
        .O(int_out_buf0[25]));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_out_buf[26]_i_1 
       (.I0(s_axi_control_WDATA[26]),
        .I1(s_axi_control_WSTRB[3]),
        .I2(\int_out_buf_reg[31]_0 [24]),
        .O(int_out_buf0[26]));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_out_buf[27]_i_1 
       (.I0(s_axi_control_WDATA[27]),
        .I1(s_axi_control_WSTRB[3]),
        .I2(\int_out_buf_reg[31]_0 [25]),
        .O(int_out_buf0[27]));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_out_buf[28]_i_1 
       (.I0(s_axi_control_WDATA[28]),
        .I1(s_axi_control_WSTRB[3]),
        .I2(\int_out_buf_reg[31]_0 [26]),
        .O(int_out_buf0[28]));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_out_buf[29]_i_1 
       (.I0(s_axi_control_WDATA[29]),
        .I1(s_axi_control_WSTRB[3]),
        .I2(\int_out_buf_reg[31]_0 [27]),
        .O(int_out_buf0[29]));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_out_buf[2]_i_1 
       (.I0(s_axi_control_WDATA[2]),
        .I1(s_axi_control_WSTRB[0]),
        .I2(\int_out_buf_reg[31]_0 [0]),
        .O(int_out_buf0[2]));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_out_buf[30]_i_1 
       (.I0(s_axi_control_WDATA[30]),
        .I1(s_axi_control_WSTRB[3]),
        .I2(\int_out_buf_reg[31]_0 [28]),
        .O(int_out_buf0[30]));
  LUT3 #(
    .INIT(8'h08)) 
    \int_out_buf[31]_i_1 
       (.I0(\int_in_buf[31]_i_3_n_2 ),
        .I1(\waddr_reg_n_2_[3] ),
        .I2(\waddr_reg_n_2_[2] ),
        .O(\int_out_buf[31]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_out_buf[31]_i_2 
       (.I0(s_axi_control_WDATA[31]),
        .I1(s_axi_control_WSTRB[3]),
        .I2(\int_out_buf_reg[31]_0 [29]),
        .O(int_out_buf0[31]));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_out_buf[3]_i_1 
       (.I0(s_axi_control_WDATA[3]),
        .I1(s_axi_control_WSTRB[0]),
        .I2(\int_out_buf_reg[31]_0 [1]),
        .O(int_out_buf0[3]));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_out_buf[4]_i_1 
       (.I0(s_axi_control_WDATA[4]),
        .I1(s_axi_control_WSTRB[0]),
        .I2(\int_out_buf_reg[31]_0 [2]),
        .O(int_out_buf0[4]));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_out_buf[5]_i_1 
       (.I0(s_axi_control_WDATA[5]),
        .I1(s_axi_control_WSTRB[0]),
        .I2(\int_out_buf_reg[31]_0 [3]),
        .O(int_out_buf0[5]));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_out_buf[6]_i_1 
       (.I0(s_axi_control_WDATA[6]),
        .I1(s_axi_control_WSTRB[0]),
        .I2(\int_out_buf_reg[31]_0 [4]),
        .O(int_out_buf0[6]));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_out_buf[7]_i_1 
       (.I0(s_axi_control_WDATA[7]),
        .I1(s_axi_control_WSTRB[0]),
        .I2(\int_out_buf_reg[31]_0 [5]),
        .O(int_out_buf0[7]));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_out_buf[8]_i_1 
       (.I0(s_axi_control_WDATA[8]),
        .I1(s_axi_control_WSTRB[1]),
        .I2(\int_out_buf_reg[31]_0 [6]),
        .O(int_out_buf0[8]));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \int_out_buf[9]_i_1 
       (.I0(s_axi_control_WDATA[9]),
        .I1(s_axi_control_WSTRB[1]),
        .I2(\int_out_buf_reg[31]_0 [7]),
        .O(int_out_buf0[9]));
  FDRE #(
    .INIT(1'b0)) 
    \int_out_buf_reg[0] 
       (.C(ap_clk),
        .CE(\int_out_buf[31]_i_1_n_2 ),
        .D(int_out_buf0[0]),
        .Q(\int_out_buf_reg_n_2_[0] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_out_buf_reg[10] 
       (.C(ap_clk),
        .CE(\int_out_buf[31]_i_1_n_2 ),
        .D(int_out_buf0[10]),
        .Q(\int_out_buf_reg[31]_0 [8]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_out_buf_reg[11] 
       (.C(ap_clk),
        .CE(\int_out_buf[31]_i_1_n_2 ),
        .D(int_out_buf0[11]),
        .Q(\int_out_buf_reg[31]_0 [9]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_out_buf_reg[12] 
       (.C(ap_clk),
        .CE(\int_out_buf[31]_i_1_n_2 ),
        .D(int_out_buf0[12]),
        .Q(\int_out_buf_reg[31]_0 [10]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_out_buf_reg[13] 
       (.C(ap_clk),
        .CE(\int_out_buf[31]_i_1_n_2 ),
        .D(int_out_buf0[13]),
        .Q(\int_out_buf_reg[31]_0 [11]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_out_buf_reg[14] 
       (.C(ap_clk),
        .CE(\int_out_buf[31]_i_1_n_2 ),
        .D(int_out_buf0[14]),
        .Q(\int_out_buf_reg[31]_0 [12]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_out_buf_reg[15] 
       (.C(ap_clk),
        .CE(\int_out_buf[31]_i_1_n_2 ),
        .D(int_out_buf0[15]),
        .Q(\int_out_buf_reg[31]_0 [13]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_out_buf_reg[16] 
       (.C(ap_clk),
        .CE(\int_out_buf[31]_i_1_n_2 ),
        .D(int_out_buf0[16]),
        .Q(\int_out_buf_reg[31]_0 [14]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_out_buf_reg[17] 
       (.C(ap_clk),
        .CE(\int_out_buf[31]_i_1_n_2 ),
        .D(int_out_buf0[17]),
        .Q(\int_out_buf_reg[31]_0 [15]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_out_buf_reg[18] 
       (.C(ap_clk),
        .CE(\int_out_buf[31]_i_1_n_2 ),
        .D(int_out_buf0[18]),
        .Q(\int_out_buf_reg[31]_0 [16]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_out_buf_reg[19] 
       (.C(ap_clk),
        .CE(\int_out_buf[31]_i_1_n_2 ),
        .D(int_out_buf0[19]),
        .Q(\int_out_buf_reg[31]_0 [17]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_out_buf_reg[1] 
       (.C(ap_clk),
        .CE(\int_out_buf[31]_i_1_n_2 ),
        .D(int_out_buf0[1]),
        .Q(\int_out_buf_reg_n_2_[1] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_out_buf_reg[20] 
       (.C(ap_clk),
        .CE(\int_out_buf[31]_i_1_n_2 ),
        .D(int_out_buf0[20]),
        .Q(\int_out_buf_reg[31]_0 [18]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_out_buf_reg[21] 
       (.C(ap_clk),
        .CE(\int_out_buf[31]_i_1_n_2 ),
        .D(int_out_buf0[21]),
        .Q(\int_out_buf_reg[31]_0 [19]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_out_buf_reg[22] 
       (.C(ap_clk),
        .CE(\int_out_buf[31]_i_1_n_2 ),
        .D(int_out_buf0[22]),
        .Q(\int_out_buf_reg[31]_0 [20]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_out_buf_reg[23] 
       (.C(ap_clk),
        .CE(\int_out_buf[31]_i_1_n_2 ),
        .D(int_out_buf0[23]),
        .Q(\int_out_buf_reg[31]_0 [21]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_out_buf_reg[24] 
       (.C(ap_clk),
        .CE(\int_out_buf[31]_i_1_n_2 ),
        .D(int_out_buf0[24]),
        .Q(\int_out_buf_reg[31]_0 [22]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_out_buf_reg[25] 
       (.C(ap_clk),
        .CE(\int_out_buf[31]_i_1_n_2 ),
        .D(int_out_buf0[25]),
        .Q(\int_out_buf_reg[31]_0 [23]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_out_buf_reg[26] 
       (.C(ap_clk),
        .CE(\int_out_buf[31]_i_1_n_2 ),
        .D(int_out_buf0[26]),
        .Q(\int_out_buf_reg[31]_0 [24]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_out_buf_reg[27] 
       (.C(ap_clk),
        .CE(\int_out_buf[31]_i_1_n_2 ),
        .D(int_out_buf0[27]),
        .Q(\int_out_buf_reg[31]_0 [25]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_out_buf_reg[28] 
       (.C(ap_clk),
        .CE(\int_out_buf[31]_i_1_n_2 ),
        .D(int_out_buf0[28]),
        .Q(\int_out_buf_reg[31]_0 [26]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_out_buf_reg[29] 
       (.C(ap_clk),
        .CE(\int_out_buf[31]_i_1_n_2 ),
        .D(int_out_buf0[29]),
        .Q(\int_out_buf_reg[31]_0 [27]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_out_buf_reg[2] 
       (.C(ap_clk),
        .CE(\int_out_buf[31]_i_1_n_2 ),
        .D(int_out_buf0[2]),
        .Q(\int_out_buf_reg[31]_0 [0]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_out_buf_reg[30] 
       (.C(ap_clk),
        .CE(\int_out_buf[31]_i_1_n_2 ),
        .D(int_out_buf0[30]),
        .Q(\int_out_buf_reg[31]_0 [28]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_out_buf_reg[31] 
       (.C(ap_clk),
        .CE(\int_out_buf[31]_i_1_n_2 ),
        .D(int_out_buf0[31]),
        .Q(\int_out_buf_reg[31]_0 [29]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_out_buf_reg[3] 
       (.C(ap_clk),
        .CE(\int_out_buf[31]_i_1_n_2 ),
        .D(int_out_buf0[3]),
        .Q(\int_out_buf_reg[31]_0 [1]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_out_buf_reg[4] 
       (.C(ap_clk),
        .CE(\int_out_buf[31]_i_1_n_2 ),
        .D(int_out_buf0[4]),
        .Q(\int_out_buf_reg[31]_0 [2]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_out_buf_reg[5] 
       (.C(ap_clk),
        .CE(\int_out_buf[31]_i_1_n_2 ),
        .D(int_out_buf0[5]),
        .Q(\int_out_buf_reg[31]_0 [3]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_out_buf_reg[6] 
       (.C(ap_clk),
        .CE(\int_out_buf[31]_i_1_n_2 ),
        .D(int_out_buf0[6]),
        .Q(\int_out_buf_reg[31]_0 [4]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_out_buf_reg[7] 
       (.C(ap_clk),
        .CE(\int_out_buf[31]_i_1_n_2 ),
        .D(int_out_buf0[7]),
        .Q(\int_out_buf_reg[31]_0 [5]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_out_buf_reg[8] 
       (.C(ap_clk),
        .CE(\int_out_buf[31]_i_1_n_2 ),
        .D(int_out_buf0[8]),
        .Q(\int_out_buf_reg[31]_0 [6]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \int_out_buf_reg[9] 
       (.C(ap_clk),
        .CE(\int_out_buf[31]_i_1_n_2 ),
        .D(int_out_buf0[9]),
        .Q(\int_out_buf_reg[31]_0 [7]),
        .R(SR));
  LUT3 #(
    .INIT(8'hA8)) 
    interrupt_INST_0
       (.I0(int_gie_reg_n_2),
        .I1(p_1_in),
        .I2(\int_isr_reg_n_2_[0] ),
        .O(interrupt));
  (* SOFT_HLUTNM = "soft_lutpair51" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \num_items_read_reg_222[31]_i_1 
       (.I0(ap_start),
        .I1(int_ap_start_reg_0[0]),
        .O(E));
  LUT5 #(
    .INIT(32'hAFA0C0C0)) 
    \rdata[0]_i_2 
       (.I0(\int_in_buf_reg_n_2_[0] ),
        .I1(\int_out_buf_reg_n_2_[0] ),
        .I2(\rdata[31]_i_3_n_2 ),
        .I3(Q[0]),
        .I4(\rdata[31]_i_4_n_2 ),
        .O(\rdata[0]_i_2_n_2 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rdata[0]_i_3 
       (.I0(ap_start),
        .I1(int_gie_reg_n_2),
        .I2(\rdata[31]_i_3_n_2 ),
        .I3(\int_ier_reg_n_2_[0] ),
        .I4(\rdata[31]_i_4_n_2 ),
        .I5(\int_isr_reg_n_2_[0] ),
        .O(\rdata[0]_i_3_n_2 ));
  LUT6 #(
    .INIT(64'h00000000AFC0A0C0)) 
    \rdata[10]_i_1 
       (.I0(\int_in_buf_reg[31]_0 [8]),
        .I1(\int_out_buf_reg[31]_0 [8]),
        .I2(\rdata[31]_i_3_n_2 ),
        .I3(\rdata[31]_i_4_n_2 ),
        .I4(Q[10]),
        .I5(\rdata[31]_i_5_n_2 ),
        .O(rdata[10]));
  LUT6 #(
    .INIT(64'h00000000AFC0A0C0)) 
    \rdata[11]_i_1 
       (.I0(\int_in_buf_reg[31]_0 [9]),
        .I1(\int_out_buf_reg[31]_0 [9]),
        .I2(\rdata[31]_i_3_n_2 ),
        .I3(\rdata[31]_i_4_n_2 ),
        .I4(Q[11]),
        .I5(\rdata[31]_i_5_n_2 ),
        .O(rdata[11]));
  LUT6 #(
    .INIT(64'h00000000AFC0A0C0)) 
    \rdata[12]_i_1 
       (.I0(\int_in_buf_reg[31]_0 [10]),
        .I1(\int_out_buf_reg[31]_0 [10]),
        .I2(\rdata[31]_i_3_n_2 ),
        .I3(\rdata[31]_i_4_n_2 ),
        .I4(Q[12]),
        .I5(\rdata[31]_i_5_n_2 ),
        .O(rdata[12]));
  LUT6 #(
    .INIT(64'h00000000AFC0A0C0)) 
    \rdata[13]_i_1 
       (.I0(\int_in_buf_reg[31]_0 [11]),
        .I1(\int_out_buf_reg[31]_0 [11]),
        .I2(\rdata[31]_i_3_n_2 ),
        .I3(\rdata[31]_i_4_n_2 ),
        .I4(Q[13]),
        .I5(\rdata[31]_i_5_n_2 ),
        .O(rdata[13]));
  LUT6 #(
    .INIT(64'h00000000AFC0A0C0)) 
    \rdata[14]_i_1 
       (.I0(\int_in_buf_reg[31]_0 [12]),
        .I1(\int_out_buf_reg[31]_0 [12]),
        .I2(\rdata[31]_i_3_n_2 ),
        .I3(\rdata[31]_i_4_n_2 ),
        .I4(Q[14]),
        .I5(\rdata[31]_i_5_n_2 ),
        .O(rdata[14]));
  LUT6 #(
    .INIT(64'h00000000AFC0A0C0)) 
    \rdata[15]_i_1 
       (.I0(\int_in_buf_reg[31]_0 [13]),
        .I1(\int_out_buf_reg[31]_0 [13]),
        .I2(\rdata[31]_i_3_n_2 ),
        .I3(\rdata[31]_i_4_n_2 ),
        .I4(Q[15]),
        .I5(\rdata[31]_i_5_n_2 ),
        .O(rdata[15]));
  LUT6 #(
    .INIT(64'h00000000AFC0A0C0)) 
    \rdata[16]_i_1 
       (.I0(\int_in_buf_reg[31]_0 [14]),
        .I1(\int_out_buf_reg[31]_0 [14]),
        .I2(\rdata[31]_i_3_n_2 ),
        .I3(\rdata[31]_i_4_n_2 ),
        .I4(Q[16]),
        .I5(\rdata[31]_i_5_n_2 ),
        .O(rdata[16]));
  LUT6 #(
    .INIT(64'h00000000AFC0A0C0)) 
    \rdata[17]_i_1 
       (.I0(\int_in_buf_reg[31]_0 [15]),
        .I1(\int_out_buf_reg[31]_0 [15]),
        .I2(\rdata[31]_i_3_n_2 ),
        .I3(\rdata[31]_i_4_n_2 ),
        .I4(Q[17]),
        .I5(\rdata[31]_i_5_n_2 ),
        .O(rdata[17]));
  LUT6 #(
    .INIT(64'h00000000AFC0A0C0)) 
    \rdata[18]_i_1 
       (.I0(\int_in_buf_reg[31]_0 [16]),
        .I1(\int_out_buf_reg[31]_0 [16]),
        .I2(\rdata[31]_i_3_n_2 ),
        .I3(\rdata[31]_i_4_n_2 ),
        .I4(Q[18]),
        .I5(\rdata[31]_i_5_n_2 ),
        .O(rdata[18]));
  LUT6 #(
    .INIT(64'h00000000AFC0A0C0)) 
    \rdata[19]_i_1 
       (.I0(\int_in_buf_reg[31]_0 [17]),
        .I1(\int_out_buf_reg[31]_0 [17]),
        .I2(\rdata[31]_i_3_n_2 ),
        .I3(\rdata[31]_i_4_n_2 ),
        .I4(Q[19]),
        .I5(\rdata[31]_i_5_n_2 ),
        .O(rdata[19]));
  LUT5 #(
    .INIT(32'hAFA0C0C0)) 
    \rdata[1]_i_2 
       (.I0(\int_in_buf_reg_n_2_[1] ),
        .I1(\int_out_buf_reg_n_2_[1] ),
        .I2(\rdata[31]_i_3_n_2 ),
        .I3(Q[1]),
        .I4(\rdata[31]_i_4_n_2 ),
        .O(\rdata[1]_i_2_n_2 ));
  LUT5 #(
    .INIT(32'hB833B800)) 
    \rdata[1]_i_3 
       (.I0(data0[1]),
        .I1(\rdata[31]_i_3_n_2 ),
        .I2(p_0_in),
        .I3(\rdata[31]_i_4_n_2 ),
        .I4(p_1_in),
        .O(\rdata[1]_i_3_n_2 ));
  LUT6 #(
    .INIT(64'h00000000AFC0A0C0)) 
    \rdata[20]_i_1 
       (.I0(\int_in_buf_reg[31]_0 [18]),
        .I1(\int_out_buf_reg[31]_0 [18]),
        .I2(\rdata[31]_i_3_n_2 ),
        .I3(\rdata[31]_i_4_n_2 ),
        .I4(Q[20]),
        .I5(\rdata[31]_i_5_n_2 ),
        .O(rdata[20]));
  LUT6 #(
    .INIT(64'h00000000AFC0A0C0)) 
    \rdata[21]_i_1 
       (.I0(\int_in_buf_reg[31]_0 [19]),
        .I1(\int_out_buf_reg[31]_0 [19]),
        .I2(\rdata[31]_i_3_n_2 ),
        .I3(\rdata[31]_i_4_n_2 ),
        .I4(Q[21]),
        .I5(\rdata[31]_i_5_n_2 ),
        .O(rdata[21]));
  LUT6 #(
    .INIT(64'h00000000AFC0A0C0)) 
    \rdata[22]_i_1 
       (.I0(\int_in_buf_reg[31]_0 [20]),
        .I1(\int_out_buf_reg[31]_0 [20]),
        .I2(\rdata[31]_i_3_n_2 ),
        .I3(\rdata[31]_i_4_n_2 ),
        .I4(Q[22]),
        .I5(\rdata[31]_i_5_n_2 ),
        .O(rdata[22]));
  LUT6 #(
    .INIT(64'h00000000AFC0A0C0)) 
    \rdata[23]_i_1 
       (.I0(\int_in_buf_reg[31]_0 [21]),
        .I1(\int_out_buf_reg[31]_0 [21]),
        .I2(\rdata[31]_i_3_n_2 ),
        .I3(\rdata[31]_i_4_n_2 ),
        .I4(Q[23]),
        .I5(\rdata[31]_i_5_n_2 ),
        .O(rdata[23]));
  LUT6 #(
    .INIT(64'h00000000AFC0A0C0)) 
    \rdata[24]_i_1 
       (.I0(\int_in_buf_reg[31]_0 [22]),
        .I1(\int_out_buf_reg[31]_0 [22]),
        .I2(\rdata[31]_i_3_n_2 ),
        .I3(\rdata[31]_i_4_n_2 ),
        .I4(Q[24]),
        .I5(\rdata[31]_i_5_n_2 ),
        .O(rdata[24]));
  LUT6 #(
    .INIT(64'h00000000AFC0A0C0)) 
    \rdata[25]_i_1 
       (.I0(\int_in_buf_reg[31]_0 [23]),
        .I1(\int_out_buf_reg[31]_0 [23]),
        .I2(\rdata[31]_i_3_n_2 ),
        .I3(\rdata[31]_i_4_n_2 ),
        .I4(Q[25]),
        .I5(\rdata[31]_i_5_n_2 ),
        .O(rdata[25]));
  LUT6 #(
    .INIT(64'h00000000AFC0A0C0)) 
    \rdata[26]_i_1 
       (.I0(\int_in_buf_reg[31]_0 [24]),
        .I1(\int_out_buf_reg[31]_0 [24]),
        .I2(\rdata[31]_i_3_n_2 ),
        .I3(\rdata[31]_i_4_n_2 ),
        .I4(Q[26]),
        .I5(\rdata[31]_i_5_n_2 ),
        .O(rdata[26]));
  LUT6 #(
    .INIT(64'h00000000AFC0A0C0)) 
    \rdata[27]_i_1 
       (.I0(\int_in_buf_reg[31]_0 [25]),
        .I1(\int_out_buf_reg[31]_0 [25]),
        .I2(\rdata[31]_i_3_n_2 ),
        .I3(\rdata[31]_i_4_n_2 ),
        .I4(Q[27]),
        .I5(\rdata[31]_i_5_n_2 ),
        .O(rdata[27]));
  LUT6 #(
    .INIT(64'h00000000AFC0A0C0)) 
    \rdata[28]_i_1 
       (.I0(\int_in_buf_reg[31]_0 [26]),
        .I1(\int_out_buf_reg[31]_0 [26]),
        .I2(\rdata[31]_i_3_n_2 ),
        .I3(\rdata[31]_i_4_n_2 ),
        .I4(Q[28]),
        .I5(\rdata[31]_i_5_n_2 ),
        .O(rdata[28]));
  LUT6 #(
    .INIT(64'h00000000AFC0A0C0)) 
    \rdata[29]_i_1 
       (.I0(\int_in_buf_reg[31]_0 [27]),
        .I1(\int_out_buf_reg[31]_0 [27]),
        .I2(\rdata[31]_i_3_n_2 ),
        .I3(\rdata[31]_i_4_n_2 ),
        .I4(Q[29]),
        .I5(\rdata[31]_i_5_n_2 ),
        .O(rdata[29]));
  LUT6 #(
    .INIT(64'hB833B80030003000)) 
    \rdata[2]_i_1 
       (.I0(data0[2]),
        .I1(\rdata[31]_i_5_n_2 ),
        .I2(\rdata[2]_i_2_n_2 ),
        .I3(\rdata[31]_i_3_n_2 ),
        .I4(Q[2]),
        .I5(\rdata[31]_i_4_n_2 ),
        .O(rdata[2]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \rdata[2]_i_2 
       (.I0(\int_in_buf_reg[31]_0 [0]),
        .I1(\rdata[31]_i_4_n_2 ),
        .I2(\int_out_buf_reg[31]_0 [0]),
        .O(\rdata[2]_i_2_n_2 ));
  LUT6 #(
    .INIT(64'h00000000AFC0A0C0)) 
    \rdata[30]_i_1 
       (.I0(\int_in_buf_reg[31]_0 [28]),
        .I1(\int_out_buf_reg[31]_0 [28]),
        .I2(\rdata[31]_i_3_n_2 ),
        .I3(\rdata[31]_i_4_n_2 ),
        .I4(Q[30]),
        .I5(\rdata[31]_i_5_n_2 ),
        .O(rdata[30]));
  LUT2 #(
    .INIT(4'h8)) 
    \rdata[31]_i_1 
       (.I0(\FSM_onehot_rstate_reg[1]_0 ),
        .I1(s_axi_control_ARVALID),
        .O(ar_hs));
  LUT6 #(
    .INIT(64'h00000000AFC0A0C0)) 
    \rdata[31]_i_2 
       (.I0(\int_in_buf_reg[31]_0 [29]),
        .I1(\int_out_buf_reg[31]_0 [29]),
        .I2(\rdata[31]_i_3_n_2 ),
        .I3(\rdata[31]_i_4_n_2 ),
        .I4(Q[31]),
        .I5(\rdata[31]_i_5_n_2 ),
        .O(rdata[31]));
  LUT6 #(
    .INIT(64'h0000000101010001)) 
    \rdata[31]_i_3 
       (.I0(s_axi_control_ARADDR[1]),
        .I1(s_axi_control_ARADDR[0]),
        .I2(s_axi_control_ARADDR[5]),
        .I3(s_axi_control_ARADDR[3]),
        .I4(s_axi_control_ARADDR[4]),
        .I5(s_axi_control_ARADDR[2]),
        .O(\rdata[31]_i_3_n_2 ));
  LUT6 #(
    .INIT(64'h0000000000000113)) 
    \rdata[31]_i_4 
       (.I0(s_axi_control_ARADDR[5]),
        .I1(s_axi_control_ARADDR[2]),
        .I2(s_axi_control_ARADDR[4]),
        .I3(s_axi_control_ARADDR[3]),
        .I4(s_axi_control_ARADDR[1]),
        .I5(s_axi_control_ARADDR[0]),
        .O(\rdata[31]_i_4_n_2 ));
  LUT4 #(
    .INIT(16'h0001)) 
    \rdata[31]_i_5 
       (.I0(s_axi_control_ARADDR[1]),
        .I1(s_axi_control_ARADDR[0]),
        .I2(s_axi_control_ARADDR[5]),
        .I3(s_axi_control_ARADDR[4]),
        .O(\rdata[31]_i_5_n_2 ));
  LUT6 #(
    .INIT(64'hB833B80030003000)) 
    \rdata[3]_i_1 
       (.I0(data0[3]),
        .I1(\rdata[31]_i_5_n_2 ),
        .I2(\rdata[3]_i_2_n_2 ),
        .I3(\rdata[31]_i_3_n_2 ),
        .I4(Q[3]),
        .I5(\rdata[31]_i_4_n_2 ),
        .O(rdata[3]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \rdata[3]_i_2 
       (.I0(\int_in_buf_reg[31]_0 [1]),
        .I1(\rdata[31]_i_4_n_2 ),
        .I2(\int_out_buf_reg[31]_0 [1]),
        .O(\rdata[3]_i_2_n_2 ));
  LUT6 #(
    .INIT(64'h00000000AFC0A0C0)) 
    \rdata[4]_i_1 
       (.I0(\int_in_buf_reg[31]_0 [2]),
        .I1(\int_out_buf_reg[31]_0 [2]),
        .I2(\rdata[31]_i_3_n_2 ),
        .I3(\rdata[31]_i_4_n_2 ),
        .I4(Q[4]),
        .I5(\rdata[31]_i_5_n_2 ),
        .O(rdata[4]));
  LUT6 #(
    .INIT(64'h00000000AFC0A0C0)) 
    \rdata[5]_i_1 
       (.I0(\int_in_buf_reg[31]_0 [3]),
        .I1(\int_out_buf_reg[31]_0 [3]),
        .I2(\rdata[31]_i_3_n_2 ),
        .I3(\rdata[31]_i_4_n_2 ),
        .I4(Q[5]),
        .I5(\rdata[31]_i_5_n_2 ),
        .O(rdata[5]));
  LUT6 #(
    .INIT(64'h00000000AFC0A0C0)) 
    \rdata[6]_i_1 
       (.I0(\int_in_buf_reg[31]_0 [4]),
        .I1(\int_out_buf_reg[31]_0 [4]),
        .I2(\rdata[31]_i_3_n_2 ),
        .I3(\rdata[31]_i_4_n_2 ),
        .I4(Q[6]),
        .I5(\rdata[31]_i_5_n_2 ),
        .O(rdata[6]));
  LUT6 #(
    .INIT(64'hB833B80030003000)) 
    \rdata[7]_i_1 
       (.I0(data0[7]),
        .I1(\rdata[31]_i_5_n_2 ),
        .I2(\rdata[7]_i_2_n_2 ),
        .I3(\rdata[31]_i_3_n_2 ),
        .I4(Q[7]),
        .I5(\rdata[31]_i_4_n_2 ),
        .O(rdata[7]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \rdata[7]_i_2 
       (.I0(\int_in_buf_reg[31]_0 [5]),
        .I1(\rdata[31]_i_4_n_2 ),
        .I2(\int_out_buf_reg[31]_0 [5]),
        .O(\rdata[7]_i_2_n_2 ));
  LUT6 #(
    .INIT(64'h00000000AFC0A0C0)) 
    \rdata[8]_i_1 
       (.I0(\int_in_buf_reg[31]_0 [6]),
        .I1(\int_out_buf_reg[31]_0 [6]),
        .I2(\rdata[31]_i_3_n_2 ),
        .I3(\rdata[31]_i_4_n_2 ),
        .I4(Q[8]),
        .I5(\rdata[31]_i_5_n_2 ),
        .O(rdata[8]));
  LUT6 #(
    .INIT(64'h00000000AFC0A0C0)) 
    \rdata[9]_i_1 
       (.I0(\int_in_buf_reg[31]_0 [7]),
        .I1(\int_out_buf_reg[31]_0 [7]),
        .I2(\rdata[31]_i_3_n_2 ),
        .I3(\rdata[31]_i_4_n_2 ),
        .I4(Q[9]),
        .I5(\rdata[31]_i_5_n_2 ),
        .O(rdata[9]));
  FDRE \rdata_reg[0] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[0]),
        .Q(s_axi_control_RDATA[0]),
        .R(1'b0));
  MUXF7 \rdata_reg[0]_i_1 
       (.I0(\rdata[0]_i_2_n_2 ),
        .I1(\rdata[0]_i_3_n_2 ),
        .O(rdata[0]),
        .S(\rdata[31]_i_5_n_2 ));
  FDRE \rdata_reg[10] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[10]),
        .Q(s_axi_control_RDATA[10]),
        .R(1'b0));
  FDRE \rdata_reg[11] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[11]),
        .Q(s_axi_control_RDATA[11]),
        .R(1'b0));
  FDRE \rdata_reg[12] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[12]),
        .Q(s_axi_control_RDATA[12]),
        .R(1'b0));
  FDRE \rdata_reg[13] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[13]),
        .Q(s_axi_control_RDATA[13]),
        .R(1'b0));
  FDRE \rdata_reg[14] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[14]),
        .Q(s_axi_control_RDATA[14]),
        .R(1'b0));
  FDRE \rdata_reg[15] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[15]),
        .Q(s_axi_control_RDATA[15]),
        .R(1'b0));
  FDRE \rdata_reg[16] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[16]),
        .Q(s_axi_control_RDATA[16]),
        .R(1'b0));
  FDRE \rdata_reg[17] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[17]),
        .Q(s_axi_control_RDATA[17]),
        .R(1'b0));
  FDRE \rdata_reg[18] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[18]),
        .Q(s_axi_control_RDATA[18]),
        .R(1'b0));
  FDRE \rdata_reg[19] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[19]),
        .Q(s_axi_control_RDATA[19]),
        .R(1'b0));
  FDRE \rdata_reg[1] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[1]),
        .Q(s_axi_control_RDATA[1]),
        .R(1'b0));
  MUXF7 \rdata_reg[1]_i_1 
       (.I0(\rdata[1]_i_2_n_2 ),
        .I1(\rdata[1]_i_3_n_2 ),
        .O(rdata[1]),
        .S(\rdata[31]_i_5_n_2 ));
  FDRE \rdata_reg[20] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[20]),
        .Q(s_axi_control_RDATA[20]),
        .R(1'b0));
  FDRE \rdata_reg[21] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[21]),
        .Q(s_axi_control_RDATA[21]),
        .R(1'b0));
  FDRE \rdata_reg[22] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[22]),
        .Q(s_axi_control_RDATA[22]),
        .R(1'b0));
  FDRE \rdata_reg[23] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[23]),
        .Q(s_axi_control_RDATA[23]),
        .R(1'b0));
  FDRE \rdata_reg[24] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[24]),
        .Q(s_axi_control_RDATA[24]),
        .R(1'b0));
  FDRE \rdata_reg[25] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[25]),
        .Q(s_axi_control_RDATA[25]),
        .R(1'b0));
  FDRE \rdata_reg[26] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[26]),
        .Q(s_axi_control_RDATA[26]),
        .R(1'b0));
  FDRE \rdata_reg[27] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[27]),
        .Q(s_axi_control_RDATA[27]),
        .R(1'b0));
  FDRE \rdata_reg[28] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[28]),
        .Q(s_axi_control_RDATA[28]),
        .R(1'b0));
  FDRE \rdata_reg[29] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[29]),
        .Q(s_axi_control_RDATA[29]),
        .R(1'b0));
  FDRE \rdata_reg[2] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[2]),
        .Q(s_axi_control_RDATA[2]),
        .R(1'b0));
  FDRE \rdata_reg[30] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[30]),
        .Q(s_axi_control_RDATA[30]),
        .R(1'b0));
  FDRE \rdata_reg[31] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[31]),
        .Q(s_axi_control_RDATA[31]),
        .R(1'b0));
  FDRE \rdata_reg[3] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[3]),
        .Q(s_axi_control_RDATA[3]),
        .R(1'b0));
  FDRE \rdata_reg[4] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[4]),
        .Q(s_axi_control_RDATA[4]),
        .R(1'b0));
  FDRE \rdata_reg[5] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[5]),
        .Q(s_axi_control_RDATA[5]),
        .R(1'b0));
  FDRE \rdata_reg[6] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[6]),
        .Q(s_axi_control_RDATA[6]),
        .R(1'b0));
  FDRE \rdata_reg[7] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[7]),
        .Q(s_axi_control_RDATA[7]),
        .R(1'b0));
  FDRE \rdata_reg[8] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[8]),
        .Q(s_axi_control_RDATA[8]),
        .R(1'b0));
  FDRE \rdata_reg[9] 
       (.C(ap_clk),
        .CE(ar_hs),
        .D(rdata[9]),
        .Q(s_axi_control_RDATA[9]),
        .R(1'b0));
  LUT2 #(
    .INIT(4'h8)) 
    \waddr[5]_i_1 
       (.I0(s_axi_control_AWVALID),
        .I1(\FSM_onehot_wstate_reg[1]_0 ),
        .O(waddr));
  FDRE \waddr_reg[0] 
       (.C(ap_clk),
        .CE(waddr),
        .D(s_axi_control_AWADDR[0]),
        .Q(\waddr_reg_n_2_[0] ),
        .R(1'b0));
  FDRE \waddr_reg[1] 
       (.C(ap_clk),
        .CE(waddr),
        .D(s_axi_control_AWADDR[1]),
        .Q(\waddr_reg_n_2_[1] ),
        .R(1'b0));
  FDRE \waddr_reg[2] 
       (.C(ap_clk),
        .CE(waddr),
        .D(s_axi_control_AWADDR[2]),
        .Q(\waddr_reg_n_2_[2] ),
        .R(1'b0));
  FDRE \waddr_reg[3] 
       (.C(ap_clk),
        .CE(waddr),
        .D(s_axi_control_AWADDR[3]),
        .Q(\waddr_reg_n_2_[3] ),
        .R(1'b0));
  FDRE \waddr_reg[4] 
       (.C(ap_clk),
        .CE(waddr),
        .D(s_axi_control_AWADDR[4]),
        .Q(\waddr_reg_n_2_[4] ),
        .R(1'b0));
  FDRE \waddr_reg[5] 
       (.C(ap_clk),
        .CE(waddr),
        .D(s_axi_control_AWADDR[5]),
        .Q(\waddr_reg_n_2_[5] ),
        .R(1'b0));
endmodule

module design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi
   (full_n_reg,
    SR,
    full_n_reg_0,
    gmem_BVALID,
    \bus_equal_gen.WVALID_Dummy_reg ,
    m_axi_gmem_WLAST,
    \could_multi_bursts.ARVALID_Dummy_reg ,
    \state_reg[0] ,
    \ap_CS_fsm_reg[7] ,
    \ap_CS_fsm_reg[15] ,
    ap_done,
    m_axi_gmem_AWVALID,
    \could_multi_bursts.awlen_buf_reg[3] ,
    i_reg_137,
    i_reg_1370,
    E,
    sum_reg_125,
    sum_reg_1250,
    \ap_CS_fsm_reg[8] ,
    \ap_CS_fsm_reg[10] ,
    m_axi_gmem_AWADDR,
    m_axi_gmem_ARADDR,
    \ap_CS_fsm_reg[8]_0 ,
    \ap_CS_fsm_reg[8]_1 ,
    \could_multi_bursts.arlen_buf_reg[3] ,
    m_axi_gmem_WDATA,
    m_axi_gmem_WSTRB,
    \data_p1_reg[31] ,
    ap_clk,
    D,
    m_axi_gmem_RRESP,
    m_axi_gmem_RVALID,
    ap_rst_n,
    m_axi_gmem_ARREADY,
    CO,
    ap_enable_reg_pp0_iter1_reg,
    ap_enable_reg_pp0_iter1_reg_0,
    ap_enable_reg_pp0_iter0,
    Q,
    ap_enable_reg_pp0_iter2_reg,
    ap_start,
    m_axi_gmem_WREADY,
    m_axi_gmem_AWREADY,
    ap_reg_ioackin_gmem_WREADY,
    m_axi_gmem_BVALID,
    \ap_CS_fsm_reg[9] ,
    exitcond_reg_251_pp0_iter1_reg,
    \data_p2_reg[29] ,
    \data_p2_reg[63] ,
    mem_reg,
    out);
  output full_n_reg;
  output [0:0]SR;
  output full_n_reg_0;
  output gmem_BVALID;
  output \bus_equal_gen.WVALID_Dummy_reg ;
  output m_axi_gmem_WLAST;
  output \could_multi_bursts.ARVALID_Dummy_reg ;
  output \state_reg[0] ;
  output \ap_CS_fsm_reg[7] ;
  output [6:0]\ap_CS_fsm_reg[15] ;
  output ap_done;
  output m_axi_gmem_AWVALID;
  output [3:0]\could_multi_bursts.awlen_buf_reg[3] ;
  output i_reg_137;
  output i_reg_1370;
  output [0:0]E;
  output sum_reg_125;
  output sum_reg_1250;
  output \ap_CS_fsm_reg[8] ;
  output [0:0]\ap_CS_fsm_reg[10] ;
  output [29:0]m_axi_gmem_AWADDR;
  output [29:0]m_axi_gmem_ARADDR;
  output \ap_CS_fsm_reg[8]_0 ;
  output \ap_CS_fsm_reg[8]_1 ;
  output [3:0]\could_multi_bursts.arlen_buf_reg[3] ;
  output [31:0]m_axi_gmem_WDATA;
  output [3:0]m_axi_gmem_WSTRB;
  output [31:0]\data_p1_reg[31] ;
  input ap_clk;
  input [32:0]D;
  input [1:0]m_axi_gmem_RRESP;
  input m_axi_gmem_RVALID;
  input ap_rst_n;
  input m_axi_gmem_ARREADY;
  input [0:0]CO;
  input ap_enable_reg_pp0_iter1_reg;
  input ap_enable_reg_pp0_iter1_reg_0;
  input ap_enable_reg_pp0_iter0;
  input [8:0]Q;
  input ap_enable_reg_pp0_iter2_reg;
  input ap_start;
  input m_axi_gmem_WREADY;
  input m_axi_gmem_AWREADY;
  input ap_reg_ioackin_gmem_WREADY;
  input m_axi_gmem_BVALID;
  input \ap_CS_fsm_reg[9] ;
  input exitcond_reg_251_pp0_iter1_reg;
  input [29:0]\data_p2_reg[29] ;
  input [61:0]\data_p2_reg[63] ;
  input [31:0]mem_reg;
  input [31:0]out;

  wire AWVALID_Dummy;
  wire [0:0]CO;
  wire [32:0]D;
  wire [0:0]E;
  wire [8:0]Q;
  wire [0:0]SR;
  wire [0:0]\ap_CS_fsm_reg[10] ;
  wire [6:0]\ap_CS_fsm_reg[15] ;
  wire \ap_CS_fsm_reg[7] ;
  wire \ap_CS_fsm_reg[8] ;
  wire \ap_CS_fsm_reg[8]_0 ;
  wire \ap_CS_fsm_reg[8]_1 ;
  wire \ap_CS_fsm_reg[9] ;
  wire ap_clk;
  wire ap_done;
  wire ap_enable_reg_pp0_iter0;
  wire ap_enable_reg_pp0_iter1_reg;
  wire ap_enable_reg_pp0_iter1_reg_0;
  wire ap_enable_reg_pp0_iter2_reg;
  wire ap_reg_ioackin_gmem_WREADY;
  wire ap_rst_n;
  wire ap_start;
  wire [5:0]\buff_rdata/usedw_reg ;
  wire [5:0]\buff_wdata/usedw_reg ;
  wire \bus_equal_gen.WVALID_Dummy_reg ;
  wire bus_read_n_20;
  wire bus_read_n_51;
  wire bus_read_n_52;
  wire bus_read_n_53;
  wire bus_read_n_54;
  wire bus_read_n_57;
  wire bus_read_n_58;
  wire bus_read_n_59;
  wire bus_write_n_14;
  wire bus_write_n_15;
  wire bus_write_n_28;
  wire bus_write_n_59;
  wire bus_write_n_60;
  wire bus_write_n_61;
  wire bus_write_n_62;
  wire bus_write_n_63;
  wire bus_write_n_64;
  wire bus_write_n_65;
  wire \could_multi_bursts.ARVALID_Dummy_reg ;
  wire [3:0]\could_multi_bursts.arlen_buf_reg[3] ;
  wire [3:0]\could_multi_bursts.awlen_buf_reg[3] ;
  wire [31:0]\data_p1_reg[31] ;
  wire [29:0]\data_p2_reg[29] ;
  wire [61:0]\data_p2_reg[63] ;
  wire exitcond_reg_251_pp0_iter1_reg;
  wire full_n_reg;
  wire full_n_reg_0;
  wire gmem_BVALID;
  wire i_reg_137;
  wire i_reg_1370;
  wire [29:0]m_axi_gmem_ARADDR;
  wire m_axi_gmem_ARREADY;
  wire [29:0]m_axi_gmem_AWADDR;
  wire m_axi_gmem_AWREADY;
  wire m_axi_gmem_AWVALID;
  wire m_axi_gmem_BVALID;
  wire [1:0]m_axi_gmem_RRESP;
  wire m_axi_gmem_RVALID;
  wire [31:0]m_axi_gmem_WDATA;
  wire m_axi_gmem_WLAST;
  wire m_axi_gmem_WREADY;
  wire [3:0]m_axi_gmem_WSTRB;
  wire [31:0]mem_reg;
  wire [31:0]out;
  wire [0:0]p_0_in;
  wire p_0_out__18_carry__0_n_4;
  wire p_0_out__18_carry__0_n_5;
  wire p_0_out__18_carry__0_n_7;
  wire p_0_out__18_carry__0_n_8;
  wire p_0_out__18_carry__0_n_9;
  wire p_0_out__18_carry_n_2;
  wire p_0_out__18_carry_n_3;
  wire p_0_out__18_carry_n_4;
  wire p_0_out__18_carry_n_5;
  wire p_0_out__18_carry_n_6;
  wire p_0_out__18_carry_n_7;
  wire p_0_out__18_carry_n_8;
  wire p_0_out__18_carry_n_9;
  wire p_0_out_carry__0_n_4;
  wire p_0_out_carry__0_n_5;
  wire p_0_out_carry__0_n_7;
  wire p_0_out_carry__0_n_8;
  wire p_0_out_carry__0_n_9;
  wire p_0_out_carry_n_2;
  wire p_0_out_carry_n_3;
  wire p_0_out_carry_n_4;
  wire p_0_out_carry_n_5;
  wire p_0_out_carry_n_6;
  wire p_0_out_carry_n_7;
  wire p_0_out_carry_n_8;
  wire p_0_out_carry_n_9;
  wire \state_reg[0] ;
  wire sum_reg_125;
  wire sum_reg_1250;
  wire [0:0]throttl_cnt_reg;
  wire wreq_throttl_n_4;
  wire wreq_throttl_n_5;
  wire wreq_throttl_n_6;
  wire wreq_throttl_n_7;
  wire [3:2]NLW_p_0_out__18_carry__0_CO_UNCONNECTED;
  wire [3:3]NLW_p_0_out__18_carry__0_O_UNCONNECTED;
  wire [3:2]NLW_p_0_out_carry__0_CO_UNCONNECTED;
  wire [3:3]NLW_p_0_out_carry__0_O_UNCONNECTED;

  design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_read bus_read
       (.CO(CO),
        .D(D),
        .DI(bus_read_n_20),
        .E(\ap_CS_fsm_reg[15] [1]),
        .Q(Q[3:1]),
        .S({bus_read_n_51,bus_read_n_52,bus_read_n_53,bus_read_n_54}),
        .SR(SR),
        .\ap_CS_fsm_reg[7] (\ap_CS_fsm_reg[7] ),
        .\ap_CS_fsm_reg[8] (\ap_CS_fsm_reg[8] ),
        .\ap_CS_fsm_reg[8]_0 (\ap_CS_fsm_reg[8]_0 ),
        .\ap_CS_fsm_reg[8]_1 (\ap_CS_fsm_reg[8]_1 ),
        .ap_clk(ap_clk),
        .ap_enable_reg_pp0_iter0(ap_enable_reg_pp0_iter0),
        .ap_enable_reg_pp0_iter1_reg(ap_enable_reg_pp0_iter1_reg),
        .ap_enable_reg_pp0_iter1_reg_0(ap_enable_reg_pp0_iter1_reg_0),
        .ap_enable_reg_pp0_iter2_reg(ap_enable_reg_pp0_iter2_reg),
        .ap_rst_n(ap_rst_n),
        .\could_multi_bursts.ARVALID_Dummy_reg_0 (\could_multi_bursts.ARVALID_Dummy_reg ),
        .\could_multi_bursts.arlen_buf_reg[3]_0 (\could_multi_bursts.arlen_buf_reg[3] ),
        .\data_p1_reg[31] (\data_p1_reg[31] ),
        .\data_p2_reg[63] (\data_p2_reg[63] ),
        .exitcond_reg_251_pp0_iter1_reg(exitcond_reg_251_pp0_iter1_reg),
        .full_n_reg(full_n_reg),
        .i_reg_137(i_reg_137),
        .i_reg_1370(i_reg_1370),
        .m_axi_gmem_ARADDR(m_axi_gmem_ARADDR),
        .m_axi_gmem_ARREADY(m_axi_gmem_ARREADY),
        .m_axi_gmem_RRESP(m_axi_gmem_RRESP),
        .m_axi_gmem_RVALID(m_axi_gmem_RVALID),
        .\state_reg[0] (\state_reg[0] ),
        .\state_reg[0]_0 (E),
        .sum_reg_125(sum_reg_125),
        .sum_reg_1250(sum_reg_1250),
        .\usedw_reg[5] (\buff_rdata/usedw_reg ),
        .\usedw_reg[6] ({bus_read_n_57,bus_read_n_58,bus_read_n_59}),
        .\usedw_reg[7] ({p_0_out__18_carry__0_n_7,p_0_out__18_carry__0_n_8,p_0_out__18_carry__0_n_9,p_0_out__18_carry_n_6,p_0_out__18_carry_n_7,p_0_out__18_carry_n_8,p_0_out__18_carry_n_9}));
  design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_write bus_write
       (.AWVALID_Dummy(AWVALID_Dummy),
        .D(p_0_in),
        .DI(bus_write_n_28),
        .E(bus_write_n_14),
        .Q({Q[8:3],Q[0]}),
        .S({bus_write_n_59,bus_write_n_60,bus_write_n_61,bus_write_n_62}),
        .SR(SR),
        .\ap_CS_fsm_reg[10] (\ap_CS_fsm_reg[10] ),
        .\ap_CS_fsm_reg[15] ({\ap_CS_fsm_reg[15] [6:2],\ap_CS_fsm_reg[15] [0]}),
        .\ap_CS_fsm_reg[9] (\ap_CS_fsm_reg[9] ),
        .ap_clk(ap_clk),
        .ap_done(ap_done),
        .ap_reg_ioackin_gmem_WREADY(ap_reg_ioackin_gmem_WREADY),
        .ap_rst_n(ap_rst_n),
        .ap_start(ap_start),
        .\bus_equal_gen.WVALID_Dummy_reg_0 (\bus_equal_gen.WVALID_Dummy_reg ),
        .\could_multi_bursts.AWVALID_Dummy_reg_0 (bus_write_n_15),
        .\could_multi_bursts.AWVALID_Dummy_reg_1 (wreq_throttl_n_5),
        .\could_multi_bursts.awaddr_buf_reg[2]_0 (wreq_throttl_n_7),
        .\could_multi_bursts.awaddr_buf_reg[2]_1 (wreq_throttl_n_4),
        .\could_multi_bursts.awlen_buf_reg[3]_0 (\could_multi_bursts.awlen_buf_reg[3] ),
        .\data_p2_reg[29] (\data_p2_reg[29] ),
        .empty_n_reg(gmem_BVALID),
        .full_n_reg(full_n_reg_0),
        .m_axi_gmem_AWADDR(m_axi_gmem_AWADDR),
        .m_axi_gmem_AWREADY(m_axi_gmem_AWREADY),
        .m_axi_gmem_BVALID(m_axi_gmem_BVALID),
        .m_axi_gmem_WDATA(m_axi_gmem_WDATA),
        .m_axi_gmem_WLAST(m_axi_gmem_WLAST),
        .m_axi_gmem_WREADY(m_axi_gmem_WREADY),
        .m_axi_gmem_WSTRB(m_axi_gmem_WSTRB),
        .mem_reg(mem_reg),
        .out(out),
        .\throttl_cnt_reg[0] (wreq_throttl_n_6),
        .\throttl_cnt_reg[0]_0 (throttl_cnt_reg),
        .\usedw_reg[5] (\buff_wdata/usedw_reg ),
        .\usedw_reg[6] ({bus_write_n_63,bus_write_n_64,bus_write_n_65}),
        .\usedw_reg[7] ({p_0_out_carry__0_n_7,p_0_out_carry__0_n_8,p_0_out_carry__0_n_9,p_0_out_carry_n_6,p_0_out_carry_n_7,p_0_out_carry_n_8,p_0_out_carry_n_9}));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 p_0_out__18_carry
       (.CI(1'b0),
        .CO({p_0_out__18_carry_n_2,p_0_out__18_carry_n_3,p_0_out__18_carry_n_4,p_0_out__18_carry_n_5}),
        .CYINIT(\buff_rdata/usedw_reg [0]),
        .DI({\buff_rdata/usedw_reg [3:1],bus_read_n_20}),
        .O({p_0_out__18_carry_n_6,p_0_out__18_carry_n_7,p_0_out__18_carry_n_8,p_0_out__18_carry_n_9}),
        .S({bus_read_n_51,bus_read_n_52,bus_read_n_53,bus_read_n_54}));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 p_0_out__18_carry__0
       (.CI(p_0_out__18_carry_n_2),
        .CO({NLW_p_0_out__18_carry__0_CO_UNCONNECTED[3:2],p_0_out__18_carry__0_n_4,p_0_out__18_carry__0_n_5}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,\buff_rdata/usedw_reg [5:4]}),
        .O({NLW_p_0_out__18_carry__0_O_UNCONNECTED[3],p_0_out__18_carry__0_n_7,p_0_out__18_carry__0_n_8,p_0_out__18_carry__0_n_9}),
        .S({1'b0,bus_read_n_57,bus_read_n_58,bus_read_n_59}));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 p_0_out_carry
       (.CI(1'b0),
        .CO({p_0_out_carry_n_2,p_0_out_carry_n_3,p_0_out_carry_n_4,p_0_out_carry_n_5}),
        .CYINIT(\buff_wdata/usedw_reg [0]),
        .DI({\buff_wdata/usedw_reg [3:1],bus_write_n_28}),
        .O({p_0_out_carry_n_6,p_0_out_carry_n_7,p_0_out_carry_n_8,p_0_out_carry_n_9}),
        .S({bus_write_n_59,bus_write_n_60,bus_write_n_61,bus_write_n_62}));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 p_0_out_carry__0
       (.CI(p_0_out_carry_n_2),
        .CO({NLW_p_0_out_carry__0_CO_UNCONNECTED[3:2],p_0_out_carry__0_n_4,p_0_out_carry__0_n_5}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,\buff_wdata/usedw_reg [5:4]}),
        .O({NLW_p_0_out_carry__0_O_UNCONNECTED[3],p_0_out_carry__0_n_7,p_0_out_carry__0_n_8,p_0_out_carry__0_n_9}),
        .S({1'b0,bus_write_n_63,bus_write_n_64,bus_write_n_65}));
  design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_throttl wreq_throttl
       (.AWVALID_Dummy(AWVALID_Dummy),
        .D(p_0_in),
        .E(bus_write_n_14),
        .Q(throttl_cnt_reg),
        .SR(SR),
        .ap_clk(ap_clk),
        .m_axi_gmem_AWREADY(m_axi_gmem_AWREADY),
        .m_axi_gmem_AWREADY_0(wreq_throttl_n_5),
        .m_axi_gmem_AWVALID(m_axi_gmem_AWVALID),
        .\throttl_cnt_reg[0]_0 (wreq_throttl_n_4),
        .\throttl_cnt_reg[2]_0 (bus_write_n_15),
        .\throttl_cnt_reg[3]_0 (\could_multi_bursts.awlen_buf_reg[3] [3:1]),
        .\throttl_cnt_reg[5]_0 (wreq_throttl_n_6),
        .\throttl_cnt_reg[7]_0 (wreq_throttl_n_7));
endmodule

module design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_buffer
   (gmem_WREADY,
    Q,
    E,
    \ap_CS_fsm_reg[11] ,
    \ap_CS_fsm_reg[10] ,
    DI,
    \bus_equal_gen.WVALID_Dummy_reg ,
    S,
    \usedw_reg[6]_0 ,
    \dout_buf_reg[35]_0 ,
    ap_clk,
    SR,
    ap_rst_n,
    dout_valid_reg_0,
    m_axi_gmem_WREADY,
    burst_valid,
    \q_tmp_reg[0]_0 ,
    ap_reg_ioackin_gmem_WREADY,
    mem_reg_0,
    out,
    \usedw_reg[7]_0 );
  output gmem_WREADY;
  output [5:0]Q;
  output [0:0]E;
  output [1:0]\ap_CS_fsm_reg[11] ;
  output [0:0]\ap_CS_fsm_reg[10] ;
  output [0:0]DI;
  output \bus_equal_gen.WVALID_Dummy_reg ;
  output [3:0]S;
  output [2:0]\usedw_reg[6]_0 ;
  output [35:0]\dout_buf_reg[35]_0 ;
  input ap_clk;
  input [0:0]SR;
  input ap_rst_n;
  input dout_valid_reg_0;
  input m_axi_gmem_WREADY;
  input burst_valid;
  input [1:0]\q_tmp_reg[0]_0 ;
  input ap_reg_ioackin_gmem_WREADY;
  input [31:0]mem_reg_0;
  input [31:0]out;
  input [6:0]\usedw_reg[7]_0 ;

  wire [0:0]DI;
  wire [0:0]E;
  wire [5:0]Q;
  wire [3:0]S;
  wire [0:0]SR;
  wire [0:0]\ap_CS_fsm_reg[10] ;
  wire [1:0]\ap_CS_fsm_reg[11] ;
  wire ap_clk;
  wire ap_reg_ioackin_gmem_WREADY;
  wire ap_rst_n;
  wire burst_valid;
  wire \bus_equal_gen.WVALID_Dummy_reg ;
  wire data_valid;
  wire \dout_buf[0]_i_1_n_2 ;
  wire \dout_buf[10]_i_1_n_2 ;
  wire \dout_buf[11]_i_1_n_2 ;
  wire \dout_buf[12]_i_1_n_2 ;
  wire \dout_buf[13]_i_1_n_2 ;
  wire \dout_buf[14]_i_1_n_2 ;
  wire \dout_buf[15]_i_1_n_2 ;
  wire \dout_buf[16]_i_1_n_2 ;
  wire \dout_buf[17]_i_1_n_2 ;
  wire \dout_buf[18]_i_1_n_2 ;
  wire \dout_buf[19]_i_1_n_2 ;
  wire \dout_buf[1]_i_1_n_2 ;
  wire \dout_buf[20]_i_1_n_2 ;
  wire \dout_buf[21]_i_1_n_2 ;
  wire \dout_buf[22]_i_1_n_2 ;
  wire \dout_buf[23]_i_1_n_2 ;
  wire \dout_buf[24]_i_1_n_2 ;
  wire \dout_buf[25]_i_1_n_2 ;
  wire \dout_buf[26]_i_1_n_2 ;
  wire \dout_buf[27]_i_1_n_2 ;
  wire \dout_buf[28]_i_1_n_2 ;
  wire \dout_buf[29]_i_1_n_2 ;
  wire \dout_buf[2]_i_1_n_2 ;
  wire \dout_buf[30]_i_1_n_2 ;
  wire \dout_buf[31]_i_1_n_2 ;
  wire \dout_buf[32]_i_1_n_2 ;
  wire \dout_buf[33]_i_1_n_2 ;
  wire \dout_buf[34]_i_1_n_2 ;
  wire \dout_buf[35]_i_2_n_2 ;
  wire \dout_buf[3]_i_1_n_2 ;
  wire \dout_buf[4]_i_1_n_2 ;
  wire \dout_buf[5]_i_1_n_2 ;
  wire \dout_buf[6]_i_1_n_2 ;
  wire \dout_buf[7]_i_1_n_2 ;
  wire \dout_buf[8]_i_1_n_2 ;
  wire \dout_buf[9]_i_1_n_2 ;
  wire [35:0]\dout_buf_reg[35]_0 ;
  wire dout_valid_i_1_n_2;
  wire dout_valid_reg_0;
  wire empty_n_i_1_n_2;
  wire empty_n_i_2_n_2;
  wire empty_n_i_3_n_2;
  wire empty_n_reg_n_2;
  wire full_n_i_1_n_2;
  wire full_n_i_2__4_n_2;
  wire full_n_i_3__2_n_2;
  wire gmem_WREADY;
  wire gmem_WVALID;
  wire m_axi_gmem_WREADY;
  wire [31:0]mem_reg_0;
  wire mem_reg_i_10__0_n_2;
  wire mem_reg_i_11_n_2;
  wire mem_reg_i_12_n_2;
  wire mem_reg_i_13_n_2;
  wire mem_reg_i_14_n_2;
  wire mem_reg_i_15_n_2;
  wire mem_reg_i_16_n_2;
  wire mem_reg_i_17_n_2;
  wire mem_reg_i_18_n_2;
  wire mem_reg_i_19_n_2;
  wire mem_reg_i_20_n_2;
  wire mem_reg_i_21_n_2;
  wire mem_reg_i_22_n_2;
  wire mem_reg_i_23_n_2;
  wire mem_reg_i_24_n_2;
  wire mem_reg_i_25_n_2;
  wire mem_reg_i_26_n_2;
  wire mem_reg_i_27_n_2;
  wire mem_reg_i_28_n_2;
  wire mem_reg_i_29_n_2;
  wire mem_reg_i_30_n_2;
  wire mem_reg_i_31_n_2;
  wire mem_reg_i_32_n_2;
  wire mem_reg_i_33_n_2;
  wire mem_reg_i_34_n_2;
  wire mem_reg_i_35_n_2;
  wire mem_reg_i_36_n_2;
  wire mem_reg_i_37_n_2;
  wire mem_reg_i_38_n_2;
  wire mem_reg_i_39_n_2;
  wire mem_reg_i_40_n_2;
  wire mem_reg_i_42_n_2;
  wire mem_reg_i_43_n_2;
  wire mem_reg_i_8__0_n_2;
  wire mem_reg_i_9__0_n_2;
  wire [31:0]out;
  wire pop;
  wire push;
  wire [35:0]q_buf;
  wire [35:0]q_tmp;
  wire [1:0]\q_tmp_reg[0]_0 ;
  wire [7:0]raddr;
  wire [7:1]rnext;
  wire show_ahead;
  wire show_ahead0;
  wire \usedw[0]_i_1_n_2 ;
  wire \usedw[7]_i_1__0_n_2 ;
  wire [2:0]\usedw_reg[6]_0 ;
  wire [6:0]\usedw_reg[7]_0 ;
  wire [7:6]usedw_reg__0;
  wire [7:0]waddr;
  wire \waddr[0]_i_1_n_2 ;
  wire \waddr[1]_i_1_n_2 ;
  wire \waddr[2]_i_1_n_2 ;
  wire \waddr[3]_i_1_n_2 ;
  wire \waddr[4]_i_1_n_2 ;
  wire \waddr[5]_i_1__0_n_2 ;
  wire \waddr[6]_i_1_n_2 ;
  wire \waddr[6]_i_2_n_2 ;
  wire \waddr[7]_i_2_n_2 ;
  wire \waddr[7]_i_3_n_2 ;
  wire \waddr[7]_i_4_n_2 ;

  (* SOFT_HLUTNM = "soft_lutpair124" *) 
  LUT4 #(
    .INIT(16'hFC02)) 
    \ap_CS_fsm[11]_i_1 
       (.I0(\q_tmp_reg[0]_0 [1]),
        .I1(gmem_WREADY),
        .I2(ap_reg_ioackin_gmem_WREADY),
        .I3(\q_tmp_reg[0]_0 [0]),
        .O(\ap_CS_fsm_reg[11] [0]));
  (* SOFT_HLUTNM = "soft_lutpair124" *) 
  LUT3 #(
    .INIT(8'hA8)) 
    \ap_CS_fsm[12]_i_1 
       (.I0(\q_tmp_reg[0]_0 [1]),
        .I1(ap_reg_ioackin_gmem_WREADY),
        .I2(gmem_WREADY),
        .O(\ap_CS_fsm_reg[11] [1]));
  (* SOFT_HLUTNM = "soft_lutpair123" *) 
  LUT4 #(
    .INIT(16'hF222)) 
    \bus_equal_gen.WVALID_Dummy_i_1 
       (.I0(dout_valid_reg_0),
        .I1(m_axi_gmem_WREADY),
        .I2(data_valid),
        .I3(burst_valid),
        .O(\bus_equal_gen.WVALID_Dummy_reg ));
  (* SOFT_HLUTNM = "soft_lutpair123" *) 
  LUT4 #(
    .INIT(16'hA200)) 
    \bus_equal_gen.data_buf[31]_i_1 
       (.I0(data_valid),
        .I1(dout_valid_reg_0),
        .I2(m_axi_gmem_WREADY),
        .I3(burst_valid),
        .O(E));
  (* SOFT_HLUTNM = "soft_lutpair126" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[0]_i_1 
       (.I0(q_tmp[0]),
        .I1(q_buf[0]),
        .I2(show_ahead),
        .O(\dout_buf[0]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair136" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[10]_i_1 
       (.I0(q_tmp[10]),
        .I1(q_buf[10]),
        .I2(show_ahead),
        .O(\dout_buf[10]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair137" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[11]_i_1 
       (.I0(q_tmp[11]),
        .I1(q_buf[11]),
        .I2(show_ahead),
        .O(\dout_buf[11]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair138" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[12]_i_1 
       (.I0(q_tmp[12]),
        .I1(q_buf[12]),
        .I2(show_ahead),
        .O(\dout_buf[12]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair139" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[13]_i_1 
       (.I0(q_tmp[13]),
        .I1(q_buf[13]),
        .I2(show_ahead),
        .O(\dout_buf[13]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair138" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[14]_i_1 
       (.I0(q_tmp[14]),
        .I1(q_buf[14]),
        .I2(show_ahead),
        .O(\dout_buf[14]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair137" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[15]_i_1 
       (.I0(q_tmp[15]),
        .I1(q_buf[15]),
        .I2(show_ahead),
        .O(\dout_buf[15]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair134" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[16]_i_1 
       (.I0(q_tmp[16]),
        .I1(q_buf[16]),
        .I2(show_ahead),
        .O(\dout_buf[16]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair133" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[17]_i_1 
       (.I0(q_tmp[17]),
        .I1(q_buf[17]),
        .I2(show_ahead),
        .O(\dout_buf[17]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair127" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[18]_i_1 
       (.I0(q_tmp[18]),
        .I1(q_buf[18]),
        .I2(show_ahead),
        .O(\dout_buf[18]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair126" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[19]_i_1 
       (.I0(q_tmp[19]),
        .I1(q_buf[19]),
        .I2(show_ahead),
        .O(\dout_buf[19]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair127" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[1]_i_1 
       (.I0(q_tmp[1]),
        .I1(q_buf[1]),
        .I2(show_ahead),
        .O(\dout_buf[1]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair128" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[20]_i_1 
       (.I0(q_tmp[20]),
        .I1(q_buf[20]),
        .I2(show_ahead),
        .O(\dout_buf[20]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair129" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[21]_i_1 
       (.I0(q_tmp[21]),
        .I1(q_buf[21]),
        .I2(show_ahead),
        .O(\dout_buf[21]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair131" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[22]_i_1 
       (.I0(q_tmp[22]),
        .I1(q_buf[22]),
        .I2(show_ahead),
        .O(\dout_buf[22]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair135" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[23]_i_1 
       (.I0(q_tmp[23]),
        .I1(q_buf[23]),
        .I2(show_ahead),
        .O(\dout_buf[23]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair130" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[24]_i_1 
       (.I0(q_tmp[24]),
        .I1(q_buf[24]),
        .I2(show_ahead),
        .O(\dout_buf[24]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair139" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[25]_i_1 
       (.I0(q_tmp[25]),
        .I1(q_buf[25]),
        .I2(show_ahead),
        .O(\dout_buf[25]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair132" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[26]_i_1 
       (.I0(q_tmp[26]),
        .I1(q_buf[26]),
        .I2(show_ahead),
        .O(\dout_buf[26]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair142" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[27]_i_1 
       (.I0(q_tmp[27]),
        .I1(q_buf[27]),
        .I2(show_ahead),
        .O(\dout_buf[27]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair142" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[28]_i_1 
       (.I0(q_tmp[28]),
        .I1(q_buf[28]),
        .I2(show_ahead),
        .O(\dout_buf[28]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair143" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[29]_i_1 
       (.I0(q_tmp[29]),
        .I1(q_buf[29]),
        .I2(show_ahead),
        .O(\dout_buf[29]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair128" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[2]_i_1 
       (.I0(q_tmp[2]),
        .I1(q_buf[2]),
        .I2(show_ahead),
        .O(\dout_buf[2]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair136" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[30]_i_1 
       (.I0(q_tmp[30]),
        .I1(q_buf[30]),
        .I2(show_ahead),
        .O(\dout_buf[30]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair143" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[31]_i_1 
       (.I0(q_tmp[31]),
        .I1(q_buf[31]),
        .I2(show_ahead),
        .O(\dout_buf[31]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair140" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[32]_i_1 
       (.I0(q_tmp[35]),
        .I1(q_buf[32]),
        .I2(show_ahead),
        .O(\dout_buf[32]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair141" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[33]_i_1 
       (.I0(q_tmp[35]),
        .I1(q_buf[33]),
        .I2(show_ahead),
        .O(\dout_buf[33]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair140" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[34]_i_1 
       (.I0(q_tmp[35]),
        .I1(q_buf[34]),
        .I2(show_ahead),
        .O(\dout_buf[34]_i_1_n_2 ));
  LUT5 #(
    .INIT(32'hAA2A2222)) 
    \dout_buf[35]_i_1 
       (.I0(empty_n_reg_n_2),
        .I1(data_valid),
        .I2(dout_valid_reg_0),
        .I3(m_axi_gmem_WREADY),
        .I4(burst_valid),
        .O(pop));
  (* SOFT_HLUTNM = "soft_lutpair141" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[35]_i_2 
       (.I0(q_tmp[35]),
        .I1(q_buf[35]),
        .I2(show_ahead),
        .O(\dout_buf[35]_i_2_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair129" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[3]_i_1 
       (.I0(q_tmp[3]),
        .I1(q_buf[3]),
        .I2(show_ahead),
        .O(\dout_buf[3]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair130" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[4]_i_1 
       (.I0(q_tmp[4]),
        .I1(q_buf[4]),
        .I2(show_ahead),
        .O(\dout_buf[4]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair131" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[5]_i_1 
       (.I0(q_tmp[5]),
        .I1(q_buf[5]),
        .I2(show_ahead),
        .O(\dout_buf[5]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair132" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[6]_i_1 
       (.I0(q_tmp[6]),
        .I1(q_buf[6]),
        .I2(show_ahead),
        .O(\dout_buf[6]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair133" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[7]_i_1 
       (.I0(q_tmp[7]),
        .I1(q_buf[7]),
        .I2(show_ahead),
        .O(\dout_buf[7]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair134" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[8]_i_1 
       (.I0(q_tmp[8]),
        .I1(q_buf[8]),
        .I2(show_ahead),
        .O(\dout_buf[8]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair135" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[9]_i_1 
       (.I0(q_tmp[9]),
        .I1(q_buf[9]),
        .I2(show_ahead),
        .O(\dout_buf[9]_i_1_n_2 ));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[0] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[0]_i_1_n_2 ),
        .Q(\dout_buf_reg[35]_0 [0]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[10] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[10]_i_1_n_2 ),
        .Q(\dout_buf_reg[35]_0 [10]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[11] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[11]_i_1_n_2 ),
        .Q(\dout_buf_reg[35]_0 [11]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[12] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[12]_i_1_n_2 ),
        .Q(\dout_buf_reg[35]_0 [12]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[13] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[13]_i_1_n_2 ),
        .Q(\dout_buf_reg[35]_0 [13]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[14] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[14]_i_1_n_2 ),
        .Q(\dout_buf_reg[35]_0 [14]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[15] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[15]_i_1_n_2 ),
        .Q(\dout_buf_reg[35]_0 [15]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[16] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[16]_i_1_n_2 ),
        .Q(\dout_buf_reg[35]_0 [16]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[17] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[17]_i_1_n_2 ),
        .Q(\dout_buf_reg[35]_0 [17]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[18] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[18]_i_1_n_2 ),
        .Q(\dout_buf_reg[35]_0 [18]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[19] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[19]_i_1_n_2 ),
        .Q(\dout_buf_reg[35]_0 [19]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[1] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[1]_i_1_n_2 ),
        .Q(\dout_buf_reg[35]_0 [1]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[20] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[20]_i_1_n_2 ),
        .Q(\dout_buf_reg[35]_0 [20]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[21] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[21]_i_1_n_2 ),
        .Q(\dout_buf_reg[35]_0 [21]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[22] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[22]_i_1_n_2 ),
        .Q(\dout_buf_reg[35]_0 [22]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[23] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[23]_i_1_n_2 ),
        .Q(\dout_buf_reg[35]_0 [23]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[24] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[24]_i_1_n_2 ),
        .Q(\dout_buf_reg[35]_0 [24]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[25] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[25]_i_1_n_2 ),
        .Q(\dout_buf_reg[35]_0 [25]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[26] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[26]_i_1_n_2 ),
        .Q(\dout_buf_reg[35]_0 [26]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[27] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[27]_i_1_n_2 ),
        .Q(\dout_buf_reg[35]_0 [27]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[28] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[28]_i_1_n_2 ),
        .Q(\dout_buf_reg[35]_0 [28]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[29] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[29]_i_1_n_2 ),
        .Q(\dout_buf_reg[35]_0 [29]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[2] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[2]_i_1_n_2 ),
        .Q(\dout_buf_reg[35]_0 [2]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[30] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[30]_i_1_n_2 ),
        .Q(\dout_buf_reg[35]_0 [30]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[31] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[31]_i_1_n_2 ),
        .Q(\dout_buf_reg[35]_0 [31]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[32] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[32]_i_1_n_2 ),
        .Q(\dout_buf_reg[35]_0 [32]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[33] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[33]_i_1_n_2 ),
        .Q(\dout_buf_reg[35]_0 [33]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[34] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[34]_i_1_n_2 ),
        .Q(\dout_buf_reg[35]_0 [34]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[35] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[35]_i_2_n_2 ),
        .Q(\dout_buf_reg[35]_0 [35]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[3] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[3]_i_1_n_2 ),
        .Q(\dout_buf_reg[35]_0 [3]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[4] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[4]_i_1_n_2 ),
        .Q(\dout_buf_reg[35]_0 [4]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[5] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[5]_i_1_n_2 ),
        .Q(\dout_buf_reg[35]_0 [5]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[6] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[6]_i_1_n_2 ),
        .Q(\dout_buf_reg[35]_0 [6]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[7] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[7]_i_1_n_2 ),
        .Q(\dout_buf_reg[35]_0 [7]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[8] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[8]_i_1_n_2 ),
        .Q(\dout_buf_reg[35]_0 [8]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[9] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[9]_i_1_n_2 ),
        .Q(\dout_buf_reg[35]_0 [9]),
        .R(SR));
  (* SOFT_HLUTNM = "soft_lutpair122" *) 
  LUT5 #(
    .INIT(32'hAAEAEEEE)) 
    dout_valid_i_1
       (.I0(empty_n_reg_n_2),
        .I1(data_valid),
        .I2(dout_valid_reg_0),
        .I3(m_axi_gmem_WREADY),
        .I4(burst_valid),
        .O(dout_valid_i_1_n_2));
  FDRE #(
    .INIT(1'b0)) 
    dout_valid_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(dout_valid_i_1_n_2),
        .Q(data_valid),
        .R(SR));
  (* SOFT_HLUTNM = "soft_lutpair121" *) 
  LUT5 #(
    .INIT(32'hFFFDF00D)) 
    empty_n_i_1
       (.I0(Q[0]),
        .I1(empty_n_i_2_n_2),
        .I2(push),
        .I3(mem_reg_i_43_n_2),
        .I4(empty_n_reg_n_2),
        .O(empty_n_i_1_n_2));
  LUT4 #(
    .INIT(16'hFFFE)) 
    empty_n_i_2
       (.I0(usedw_reg__0[6]),
        .I1(Q[5]),
        .I2(Q[3]),
        .I3(empty_n_i_3_n_2),
        .O(empty_n_i_2_n_2));
  LUT4 #(
    .INIT(16'hFFFE)) 
    empty_n_i_3
       (.I0(usedw_reg__0[7]),
        .I1(Q[1]),
        .I2(Q[2]),
        .I3(Q[4]),
        .O(empty_n_i_3_n_2));
  FDRE #(
    .INIT(1'b0)) 
    empty_n_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(empty_n_i_1_n_2),
        .Q(empty_n_reg_n_2),
        .R(SR));
  LUT6 #(
    .INIT(64'hFDFFFFFFFD5555FF)) 
    full_n_i_1
       (.I0(ap_rst_n),
        .I1(full_n_i_2__4_n_2),
        .I2(full_n_i_3__2_n_2),
        .I3(mem_reg_i_43_n_2),
        .I4(push),
        .I5(gmem_WREADY),
        .O(full_n_i_1_n_2));
  (* SOFT_HLUTNM = "soft_lutpair125" *) 
  LUT4 #(
    .INIT(16'h7FFF)) 
    full_n_i_2__4
       (.I0(usedw_reg__0[6]),
        .I1(usedw_reg__0[7]),
        .I2(Q[0]),
        .I3(Q[1]),
        .O(full_n_i_2__4_n_2));
  LUT4 #(
    .INIT(16'h7FFF)) 
    full_n_i_3__2
       (.I0(Q[5]),
        .I1(Q[4]),
        .I2(Q[2]),
        .I3(Q[3]),
        .O(full_n_i_3__2_n_2));
  FDRE #(
    .INIT(1'b1)) 
    full_n_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(full_n_i_1_n_2),
        .Q(gmem_WREADY),
        .R(1'b0));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p4_d32" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p4_d32" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "9216" *) 
  (* RTL_RAM_NAME = "mem" *) 
  (* bram_addr_begin = "0" *) 
  (* bram_addr_end = "511" *) 
  (* bram_slice_begin = "0" *) 
  (* bram_slice_end = "35" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "511" *) 
  (* ram_slice_begin = "0" *) 
  (* ram_slice_end = "35" *) 
  RAMB18E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .INIT_A(18'h00000),
    .INIT_B(18'h00000),
    .RAM_MODE("SDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(36),
    .READ_WIDTH_B(0),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(18'h00000),
    .SRVAL_B(18'h00000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("READ_FIRST"),
    .WRITE_WIDTH_A(0),
    .WRITE_WIDTH_B(36)) 
    mem_reg
       (.ADDRARDADDR({1'b1,rnext,mem_reg_i_8__0_n_2,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b1,waddr,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CLKARDCLK(ap_clk),
        .CLKBWRCLK(ap_clk),
        .DIADI({mem_reg_i_9__0_n_2,mem_reg_i_10__0_n_2,mem_reg_i_11_n_2,mem_reg_i_12_n_2,mem_reg_i_13_n_2,mem_reg_i_14_n_2,mem_reg_i_15_n_2,mem_reg_i_16_n_2,mem_reg_i_17_n_2,mem_reg_i_18_n_2,mem_reg_i_19_n_2,mem_reg_i_20_n_2,mem_reg_i_21_n_2,mem_reg_i_22_n_2,mem_reg_i_23_n_2,mem_reg_i_24_n_2}),
        .DIBDI({mem_reg_i_25_n_2,mem_reg_i_26_n_2,mem_reg_i_27_n_2,mem_reg_i_28_n_2,mem_reg_i_29_n_2,mem_reg_i_30_n_2,mem_reg_i_31_n_2,mem_reg_i_32_n_2,mem_reg_i_33_n_2,mem_reg_i_34_n_2,mem_reg_i_35_n_2,mem_reg_i_36_n_2,mem_reg_i_37_n_2,mem_reg_i_38_n_2,mem_reg_i_39_n_2,mem_reg_i_40_n_2}),
        .DIPADIP({1'b1,1'b1}),
        .DIPBDIP({1'b1,1'b1}),
        .DOADO(q_buf[15:0]),
        .DOBDO(q_buf[31:16]),
        .DOPADOP(q_buf[33:32]),
        .DOPBDOP(q_buf[35:34]),
        .ENARDEN(1'b1),
        .ENBWREN(gmem_WREADY),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .WEA({1'b0,1'b0}),
        .WEBWE({gmem_WVALID,gmem_WVALID,gmem_WVALID,gmem_WVALID}));
  LUT4 #(
    .INIT(16'hA6AA)) 
    mem_reg_i_1
       (.I0(raddr[7]),
        .I1(raddr[5]),
        .I2(mem_reg_i_42_n_2),
        .I3(raddr[6]),
        .O(rnext[7]));
  LUT3 #(
    .INIT(8'hB8)) 
    mem_reg_i_10__0
       (.I0(mem_reg_0[14]),
        .I1(\q_tmp_reg[0]_0 [1]),
        .I2(out[14]),
        .O(mem_reg_i_10__0_n_2));
  LUT3 #(
    .INIT(8'hB8)) 
    mem_reg_i_11
       (.I0(mem_reg_0[13]),
        .I1(\q_tmp_reg[0]_0 [1]),
        .I2(out[13]),
        .O(mem_reg_i_11_n_2));
  LUT3 #(
    .INIT(8'hB8)) 
    mem_reg_i_12
       (.I0(mem_reg_0[12]),
        .I1(\q_tmp_reg[0]_0 [1]),
        .I2(out[12]),
        .O(mem_reg_i_12_n_2));
  LUT3 #(
    .INIT(8'hB8)) 
    mem_reg_i_13
       (.I0(mem_reg_0[11]),
        .I1(\q_tmp_reg[0]_0 [1]),
        .I2(out[11]),
        .O(mem_reg_i_13_n_2));
  LUT3 #(
    .INIT(8'hB8)) 
    mem_reg_i_14
       (.I0(mem_reg_0[10]),
        .I1(\q_tmp_reg[0]_0 [1]),
        .I2(out[10]),
        .O(mem_reg_i_14_n_2));
  LUT3 #(
    .INIT(8'hB8)) 
    mem_reg_i_15
       (.I0(mem_reg_0[9]),
        .I1(\q_tmp_reg[0]_0 [1]),
        .I2(out[9]),
        .O(mem_reg_i_15_n_2));
  LUT3 #(
    .INIT(8'hB8)) 
    mem_reg_i_16
       (.I0(mem_reg_0[8]),
        .I1(\q_tmp_reg[0]_0 [1]),
        .I2(out[8]),
        .O(mem_reg_i_16_n_2));
  LUT3 #(
    .INIT(8'hB8)) 
    mem_reg_i_17
       (.I0(mem_reg_0[7]),
        .I1(\q_tmp_reg[0]_0 [1]),
        .I2(out[7]),
        .O(mem_reg_i_17_n_2));
  LUT3 #(
    .INIT(8'hB8)) 
    mem_reg_i_18
       (.I0(mem_reg_0[6]),
        .I1(\q_tmp_reg[0]_0 [1]),
        .I2(out[6]),
        .O(mem_reg_i_18_n_2));
  LUT3 #(
    .INIT(8'hB8)) 
    mem_reg_i_19
       (.I0(mem_reg_0[5]),
        .I1(\q_tmp_reg[0]_0 [1]),
        .I2(out[5]),
        .O(mem_reg_i_19_n_2));
  LUT3 #(
    .INIT(8'h9A)) 
    mem_reg_i_2
       (.I0(raddr[6]),
        .I1(mem_reg_i_42_n_2),
        .I2(raddr[5]),
        .O(rnext[6]));
  LUT3 #(
    .INIT(8'hB8)) 
    mem_reg_i_20
       (.I0(mem_reg_0[4]),
        .I1(\q_tmp_reg[0]_0 [1]),
        .I2(out[4]),
        .O(mem_reg_i_20_n_2));
  LUT3 #(
    .INIT(8'hB8)) 
    mem_reg_i_21
       (.I0(mem_reg_0[3]),
        .I1(\q_tmp_reg[0]_0 [1]),
        .I2(out[3]),
        .O(mem_reg_i_21_n_2));
  LUT3 #(
    .INIT(8'hB8)) 
    mem_reg_i_22
       (.I0(mem_reg_0[2]),
        .I1(\q_tmp_reg[0]_0 [1]),
        .I2(out[2]),
        .O(mem_reg_i_22_n_2));
  LUT3 #(
    .INIT(8'hB8)) 
    mem_reg_i_23
       (.I0(mem_reg_0[1]),
        .I1(\q_tmp_reg[0]_0 [1]),
        .I2(out[1]),
        .O(mem_reg_i_23_n_2));
  LUT3 #(
    .INIT(8'hB8)) 
    mem_reg_i_24
       (.I0(mem_reg_0[0]),
        .I1(\q_tmp_reg[0]_0 [1]),
        .I2(out[0]),
        .O(mem_reg_i_24_n_2));
  LUT3 #(
    .INIT(8'hB8)) 
    mem_reg_i_25
       (.I0(mem_reg_0[31]),
        .I1(\q_tmp_reg[0]_0 [1]),
        .I2(out[31]),
        .O(mem_reg_i_25_n_2));
  LUT3 #(
    .INIT(8'hB8)) 
    mem_reg_i_26
       (.I0(mem_reg_0[30]),
        .I1(\q_tmp_reg[0]_0 [1]),
        .I2(out[30]),
        .O(mem_reg_i_26_n_2));
  LUT3 #(
    .INIT(8'hB8)) 
    mem_reg_i_27
       (.I0(mem_reg_0[29]),
        .I1(\q_tmp_reg[0]_0 [1]),
        .I2(out[29]),
        .O(mem_reg_i_27_n_2));
  LUT3 #(
    .INIT(8'hB8)) 
    mem_reg_i_28
       (.I0(mem_reg_0[28]),
        .I1(\q_tmp_reg[0]_0 [1]),
        .I2(out[28]),
        .O(mem_reg_i_28_n_2));
  LUT3 #(
    .INIT(8'hB8)) 
    mem_reg_i_29
       (.I0(mem_reg_0[27]),
        .I1(\q_tmp_reg[0]_0 [1]),
        .I2(out[27]),
        .O(mem_reg_i_29_n_2));
  LUT2 #(
    .INIT(4'h9)) 
    mem_reg_i_3
       (.I0(mem_reg_i_42_n_2),
        .I1(raddr[5]),
        .O(rnext[5]));
  LUT3 #(
    .INIT(8'hB8)) 
    mem_reg_i_30
       (.I0(mem_reg_0[26]),
        .I1(\q_tmp_reg[0]_0 [1]),
        .I2(out[26]),
        .O(mem_reg_i_30_n_2));
  LUT3 #(
    .INIT(8'hB8)) 
    mem_reg_i_31
       (.I0(mem_reg_0[25]),
        .I1(\q_tmp_reg[0]_0 [1]),
        .I2(out[25]),
        .O(mem_reg_i_31_n_2));
  LUT3 #(
    .INIT(8'hB8)) 
    mem_reg_i_32
       (.I0(mem_reg_0[24]),
        .I1(\q_tmp_reg[0]_0 [1]),
        .I2(out[24]),
        .O(mem_reg_i_32_n_2));
  LUT3 #(
    .INIT(8'hB8)) 
    mem_reg_i_33
       (.I0(mem_reg_0[23]),
        .I1(\q_tmp_reg[0]_0 [1]),
        .I2(out[23]),
        .O(mem_reg_i_33_n_2));
  LUT3 #(
    .INIT(8'hB8)) 
    mem_reg_i_34
       (.I0(mem_reg_0[22]),
        .I1(\q_tmp_reg[0]_0 [1]),
        .I2(out[22]),
        .O(mem_reg_i_34_n_2));
  LUT3 #(
    .INIT(8'hB8)) 
    mem_reg_i_35
       (.I0(mem_reg_0[21]),
        .I1(\q_tmp_reg[0]_0 [1]),
        .I2(out[21]),
        .O(mem_reg_i_35_n_2));
  LUT3 #(
    .INIT(8'hB8)) 
    mem_reg_i_36
       (.I0(mem_reg_0[20]),
        .I1(\q_tmp_reg[0]_0 [1]),
        .I2(out[20]),
        .O(mem_reg_i_36_n_2));
  LUT3 #(
    .INIT(8'hB8)) 
    mem_reg_i_37
       (.I0(mem_reg_0[19]),
        .I1(\q_tmp_reg[0]_0 [1]),
        .I2(out[19]),
        .O(mem_reg_i_37_n_2));
  LUT3 #(
    .INIT(8'hB8)) 
    mem_reg_i_38
       (.I0(mem_reg_0[18]),
        .I1(\q_tmp_reg[0]_0 [1]),
        .I2(out[18]),
        .O(mem_reg_i_38_n_2));
  LUT3 #(
    .INIT(8'hB8)) 
    mem_reg_i_39
       (.I0(mem_reg_0[17]),
        .I1(\q_tmp_reg[0]_0 [1]),
        .I2(out[17]),
        .O(mem_reg_i_39_n_2));
  LUT6 #(
    .INIT(64'hAA6AAAAAAAAAAAAA)) 
    mem_reg_i_4
       (.I0(raddr[4]),
        .I1(raddr[2]),
        .I2(raddr[0]),
        .I3(mem_reg_i_43_n_2),
        .I4(raddr[1]),
        .I5(raddr[3]),
        .O(rnext[4]));
  LUT3 #(
    .INIT(8'hB8)) 
    mem_reg_i_40
       (.I0(mem_reg_0[16]),
        .I1(\q_tmp_reg[0]_0 [1]),
        .I2(out[16]),
        .O(mem_reg_i_40_n_2));
  LUT3 #(
    .INIT(8'h54)) 
    mem_reg_i_41
       (.I0(ap_reg_ioackin_gmem_WREADY),
        .I1(\q_tmp_reg[0]_0 [1]),
        .I2(\q_tmp_reg[0]_0 [0]),
        .O(gmem_WVALID));
  LUT6 #(
    .INIT(64'hF7FFFFFFFFFFFFFF)) 
    mem_reg_i_42
       (.I0(raddr[3]),
        .I1(raddr[1]),
        .I2(mem_reg_i_43_n_2),
        .I3(raddr[0]),
        .I4(raddr[2]),
        .I5(raddr[4]),
        .O(mem_reg_i_42_n_2));
  (* SOFT_HLUTNM = "soft_lutpair122" *) 
  LUT5 #(
    .INIT(32'h7500FFFF)) 
    mem_reg_i_43
       (.I0(burst_valid),
        .I1(m_axi_gmem_WREADY),
        .I2(dout_valid_reg_0),
        .I3(data_valid),
        .I4(empty_n_reg_n_2),
        .O(mem_reg_i_43_n_2));
  LUT5 #(
    .INIT(32'hA6AAAAAA)) 
    mem_reg_i_5
       (.I0(raddr[3]),
        .I1(raddr[1]),
        .I2(mem_reg_i_43_n_2),
        .I3(raddr[0]),
        .I4(raddr[2]),
        .O(rnext[3]));
  LUT4 #(
    .INIT(16'hA6AA)) 
    mem_reg_i_6
       (.I0(raddr[2]),
        .I1(raddr[0]),
        .I2(mem_reg_i_43_n_2),
        .I3(raddr[1]),
        .O(rnext[2]));
  LUT3 #(
    .INIT(8'h9A)) 
    mem_reg_i_7
       (.I0(raddr[1]),
        .I1(mem_reg_i_43_n_2),
        .I2(raddr[0]),
        .O(rnext[1]));
  LUT6 #(
    .INIT(64'h6666A666A6A6A6A6)) 
    mem_reg_i_8__0
       (.I0(raddr[0]),
        .I1(empty_n_reg_n_2),
        .I2(data_valid),
        .I3(dout_valid_reg_0),
        .I4(m_axi_gmem_WREADY),
        .I5(burst_valid),
        .O(mem_reg_i_8__0_n_2));
  LUT3 #(
    .INIT(8'hB8)) 
    mem_reg_i_9__0
       (.I0(mem_reg_0[15]),
        .I1(\q_tmp_reg[0]_0 [1]),
        .I2(out[15]),
        .O(mem_reg_i_9__0_n_2));
  LUT2 #(
    .INIT(4'h9)) 
    p_0_out_carry__0_i_1
       (.I0(usedw_reg__0[6]),
        .I1(usedw_reg__0[7]),
        .O(\usedw_reg[6]_0 [2]));
  LUT2 #(
    .INIT(4'h9)) 
    p_0_out_carry__0_i_2
       (.I0(Q[5]),
        .I1(usedw_reg__0[6]),
        .O(\usedw_reg[6]_0 [1]));
  LUT2 #(
    .INIT(4'h9)) 
    p_0_out_carry__0_i_3
       (.I0(Q[4]),
        .I1(Q[5]),
        .O(\usedw_reg[6]_0 [0]));
  LUT1 #(
    .INIT(2'h1)) 
    p_0_out_carry_i_1
       (.I0(Q[1]),
        .O(DI));
  LUT2 #(
    .INIT(4'h9)) 
    p_0_out_carry_i_2
       (.I0(Q[3]),
        .I1(Q[4]),
        .O(S[3]));
  LUT2 #(
    .INIT(4'h9)) 
    p_0_out_carry_i_3
       (.I0(Q[2]),
        .I1(Q[3]),
        .O(S[2]));
  LUT2 #(
    .INIT(4'h9)) 
    p_0_out_carry_i_4
       (.I0(Q[1]),
        .I1(Q[2]),
        .O(S[1]));
  LUT6 #(
    .INIT(64'h5555999555555555)) 
    p_0_out_carry_i_5
       (.I0(Q[1]),
        .I1(gmem_WREADY),
        .I2(\q_tmp_reg[0]_0 [0]),
        .I3(\q_tmp_reg[0]_0 [1]),
        .I4(ap_reg_ioackin_gmem_WREADY),
        .I5(mem_reg_i_43_n_2),
        .O(S[0]));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[0] 
       (.C(ap_clk),
        .CE(push),
        .D(mem_reg_i_24_n_2),
        .Q(q_tmp[0]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[10] 
       (.C(ap_clk),
        .CE(push),
        .D(mem_reg_i_14_n_2),
        .Q(q_tmp[10]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[11] 
       (.C(ap_clk),
        .CE(push),
        .D(mem_reg_i_13_n_2),
        .Q(q_tmp[11]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[12] 
       (.C(ap_clk),
        .CE(push),
        .D(mem_reg_i_12_n_2),
        .Q(q_tmp[12]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[13] 
       (.C(ap_clk),
        .CE(push),
        .D(mem_reg_i_11_n_2),
        .Q(q_tmp[13]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[14] 
       (.C(ap_clk),
        .CE(push),
        .D(mem_reg_i_10__0_n_2),
        .Q(q_tmp[14]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[15] 
       (.C(ap_clk),
        .CE(push),
        .D(mem_reg_i_9__0_n_2),
        .Q(q_tmp[15]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[16] 
       (.C(ap_clk),
        .CE(push),
        .D(mem_reg_i_40_n_2),
        .Q(q_tmp[16]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[17] 
       (.C(ap_clk),
        .CE(push),
        .D(mem_reg_i_39_n_2),
        .Q(q_tmp[17]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[18] 
       (.C(ap_clk),
        .CE(push),
        .D(mem_reg_i_38_n_2),
        .Q(q_tmp[18]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[19] 
       (.C(ap_clk),
        .CE(push),
        .D(mem_reg_i_37_n_2),
        .Q(q_tmp[19]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[1] 
       (.C(ap_clk),
        .CE(push),
        .D(mem_reg_i_23_n_2),
        .Q(q_tmp[1]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[20] 
       (.C(ap_clk),
        .CE(push),
        .D(mem_reg_i_36_n_2),
        .Q(q_tmp[20]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[21] 
       (.C(ap_clk),
        .CE(push),
        .D(mem_reg_i_35_n_2),
        .Q(q_tmp[21]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[22] 
       (.C(ap_clk),
        .CE(push),
        .D(mem_reg_i_34_n_2),
        .Q(q_tmp[22]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[23] 
       (.C(ap_clk),
        .CE(push),
        .D(mem_reg_i_33_n_2),
        .Q(q_tmp[23]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[24] 
       (.C(ap_clk),
        .CE(push),
        .D(mem_reg_i_32_n_2),
        .Q(q_tmp[24]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[25] 
       (.C(ap_clk),
        .CE(push),
        .D(mem_reg_i_31_n_2),
        .Q(q_tmp[25]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[26] 
       (.C(ap_clk),
        .CE(push),
        .D(mem_reg_i_30_n_2),
        .Q(q_tmp[26]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[27] 
       (.C(ap_clk),
        .CE(push),
        .D(mem_reg_i_29_n_2),
        .Q(q_tmp[27]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[28] 
       (.C(ap_clk),
        .CE(push),
        .D(mem_reg_i_28_n_2),
        .Q(q_tmp[28]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[29] 
       (.C(ap_clk),
        .CE(push),
        .D(mem_reg_i_27_n_2),
        .Q(q_tmp[29]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[2] 
       (.C(ap_clk),
        .CE(push),
        .D(mem_reg_i_22_n_2),
        .Q(q_tmp[2]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[30] 
       (.C(ap_clk),
        .CE(push),
        .D(mem_reg_i_26_n_2),
        .Q(q_tmp[30]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[31] 
       (.C(ap_clk),
        .CE(push),
        .D(mem_reg_i_25_n_2),
        .Q(q_tmp[31]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[35] 
       (.C(ap_clk),
        .CE(push),
        .D(1'b1),
        .Q(q_tmp[35]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[3] 
       (.C(ap_clk),
        .CE(push),
        .D(mem_reg_i_21_n_2),
        .Q(q_tmp[3]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[4] 
       (.C(ap_clk),
        .CE(push),
        .D(mem_reg_i_20_n_2),
        .Q(q_tmp[4]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[5] 
       (.C(ap_clk),
        .CE(push),
        .D(mem_reg_i_19_n_2),
        .Q(q_tmp[5]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[6] 
       (.C(ap_clk),
        .CE(push),
        .D(mem_reg_i_18_n_2),
        .Q(q_tmp[6]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[7] 
       (.C(ap_clk),
        .CE(push),
        .D(mem_reg_i_17_n_2),
        .Q(q_tmp[7]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[8] 
       (.C(ap_clk),
        .CE(push),
        .D(mem_reg_i_16_n_2),
        .Q(q_tmp[8]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[9] 
       (.C(ap_clk),
        .CE(push),
        .D(mem_reg_i_15_n_2),
        .Q(q_tmp[9]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \raddr_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(mem_reg_i_8__0_n_2),
        .Q(raddr[0]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \raddr_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(rnext[1]),
        .Q(raddr[1]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \raddr_reg[2] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(rnext[2]),
        .Q(raddr[2]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \raddr_reg[3] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(rnext[3]),
        .Q(raddr[3]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \raddr_reg[4] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(rnext[4]),
        .Q(raddr[4]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \raddr_reg[5] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(rnext[5]),
        .Q(raddr[5]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \raddr_reg[6] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(rnext[6]),
        .Q(raddr[6]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \raddr_reg[7] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(rnext[7]),
        .Q(raddr[7]),
        .R(SR));
  (* SOFT_HLUTNM = "soft_lutpair121" *) 
  LUT4 #(
    .INIT(16'h0440)) 
    show_ahead_i_1
       (.I0(empty_n_i_2_n_2),
        .I1(push),
        .I2(mem_reg_i_43_n_2),
        .I3(Q[0]),
        .O(show_ahead0));
  FDRE #(
    .INIT(1'b0)) 
    show_ahead_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(show_ahead0),
        .Q(show_ahead),
        .R(SR));
  LUT3 #(
    .INIT(8'hA8)) 
    \tmp_2_reg_270[31]_i_1 
       (.I0(\q_tmp_reg[0]_0 [0]),
        .I1(ap_reg_ioackin_gmem_WREADY),
        .I2(gmem_WREADY),
        .O(\ap_CS_fsm_reg[10] ));
  (* SOFT_HLUTNM = "soft_lutpair125" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \usedw[0]_i_1 
       (.I0(Q[0]),
        .O(\usedw[0]_i_1_n_2 ));
  LUT6 #(
    .INIT(64'h55D5DDDDAA2A2222)) 
    \usedw[7]_i_1__0 
       (.I0(empty_n_reg_n_2),
        .I1(data_valid),
        .I2(dout_valid_reg_0),
        .I3(m_axi_gmem_WREADY),
        .I4(burst_valid),
        .I5(push),
        .O(\usedw[7]_i_1__0_n_2 ));
  FDRE #(
    .INIT(1'b0)) 
    \usedw_reg[0] 
       (.C(ap_clk),
        .CE(\usedw[7]_i_1__0_n_2 ),
        .D(\usedw[0]_i_1_n_2 ),
        .Q(Q[0]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \usedw_reg[1] 
       (.C(ap_clk),
        .CE(\usedw[7]_i_1__0_n_2 ),
        .D(\usedw_reg[7]_0 [0]),
        .Q(Q[1]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \usedw_reg[2] 
       (.C(ap_clk),
        .CE(\usedw[7]_i_1__0_n_2 ),
        .D(\usedw_reg[7]_0 [1]),
        .Q(Q[2]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \usedw_reg[3] 
       (.C(ap_clk),
        .CE(\usedw[7]_i_1__0_n_2 ),
        .D(\usedw_reg[7]_0 [2]),
        .Q(Q[3]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \usedw_reg[4] 
       (.C(ap_clk),
        .CE(\usedw[7]_i_1__0_n_2 ),
        .D(\usedw_reg[7]_0 [3]),
        .Q(Q[4]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \usedw_reg[5] 
       (.C(ap_clk),
        .CE(\usedw[7]_i_1__0_n_2 ),
        .D(\usedw_reg[7]_0 [4]),
        .Q(Q[5]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \usedw_reg[6] 
       (.C(ap_clk),
        .CE(\usedw[7]_i_1__0_n_2 ),
        .D(\usedw_reg[7]_0 [5]),
        .Q(usedw_reg__0[6]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \usedw_reg[7] 
       (.C(ap_clk),
        .CE(\usedw[7]_i_1__0_n_2 ),
        .D(\usedw_reg[7]_0 [6]),
        .Q(usedw_reg__0[7]),
        .R(SR));
  (* SOFT_HLUTNM = "soft_lutpair145" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \waddr[0]_i_1 
       (.I0(waddr[0]),
        .O(\waddr[0]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair145" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \waddr[1]_i_1 
       (.I0(waddr[0]),
        .I1(waddr[1]),
        .O(\waddr[1]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair144" *) 
  LUT3 #(
    .INIT(8'h6A)) 
    \waddr[2]_i_1 
       (.I0(waddr[2]),
        .I1(waddr[0]),
        .I2(waddr[1]),
        .O(\waddr[2]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair120" *) 
  LUT4 #(
    .INIT(16'h6AAA)) 
    \waddr[3]_i_1 
       (.I0(waddr[3]),
        .I1(waddr[0]),
        .I2(waddr[1]),
        .I3(waddr[2]),
        .O(\waddr[3]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair120" *) 
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    \waddr[4]_i_1 
       (.I0(waddr[4]),
        .I1(waddr[2]),
        .I2(waddr[1]),
        .I3(waddr[0]),
        .I4(waddr[3]),
        .O(\waddr[4]_i_1_n_2 ));
  LUT6 #(
    .INIT(64'h6AAAAAAAAAAAAAAA)) 
    \waddr[5]_i_1__0 
       (.I0(waddr[5]),
        .I1(waddr[3]),
        .I2(waddr[0]),
        .I3(waddr[1]),
        .I4(waddr[2]),
        .I5(waddr[4]),
        .O(\waddr[5]_i_1__0_n_2 ));
  LUT6 #(
    .INIT(64'h6AAAAAAAAAAAAAAA)) 
    \waddr[6]_i_1 
       (.I0(waddr[6]),
        .I1(waddr[4]),
        .I2(waddr[2]),
        .I3(\waddr[6]_i_2_n_2 ),
        .I4(waddr[3]),
        .I5(waddr[5]),
        .O(\waddr[6]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair144" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \waddr[6]_i_2 
       (.I0(waddr[1]),
        .I1(waddr[0]),
        .O(\waddr[6]_i_2_n_2 ));
  LUT4 #(
    .INIT(16'h00A8)) 
    \waddr[7]_i_1 
       (.I0(gmem_WREADY),
        .I1(\q_tmp_reg[0]_0 [0]),
        .I2(\q_tmp_reg[0]_0 [1]),
        .I3(ap_reg_ioackin_gmem_WREADY),
        .O(push));
  LUT4 #(
    .INIT(16'hB8CC)) 
    \waddr[7]_i_2 
       (.I0(\waddr[7]_i_3_n_2 ),
        .I1(waddr[7]),
        .I2(\waddr[7]_i_4_n_2 ),
        .I3(waddr[6]),
        .O(\waddr[7]_i_2_n_2 ));
  LUT6 #(
    .INIT(64'h7FFFFFFFFFFFFFFF)) 
    \waddr[7]_i_3 
       (.I0(waddr[4]),
        .I1(waddr[2]),
        .I2(waddr[0]),
        .I3(waddr[1]),
        .I4(waddr[3]),
        .I5(waddr[5]),
        .O(\waddr[7]_i_3_n_2 ));
  LUT6 #(
    .INIT(64'h8000000000000000)) 
    \waddr[7]_i_4 
       (.I0(waddr[4]),
        .I1(waddr[2]),
        .I2(waddr[1]),
        .I3(waddr[0]),
        .I4(waddr[3]),
        .I5(waddr[5]),
        .O(\waddr[7]_i_4_n_2 ));
  FDRE #(
    .INIT(1'b0)) 
    \waddr_reg[0] 
       (.C(ap_clk),
        .CE(push),
        .D(\waddr[0]_i_1_n_2 ),
        .Q(waddr[0]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \waddr_reg[1] 
       (.C(ap_clk),
        .CE(push),
        .D(\waddr[1]_i_1_n_2 ),
        .Q(waddr[1]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \waddr_reg[2] 
       (.C(ap_clk),
        .CE(push),
        .D(\waddr[2]_i_1_n_2 ),
        .Q(waddr[2]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \waddr_reg[3] 
       (.C(ap_clk),
        .CE(push),
        .D(\waddr[3]_i_1_n_2 ),
        .Q(waddr[3]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \waddr_reg[4] 
       (.C(ap_clk),
        .CE(push),
        .D(\waddr[4]_i_1_n_2 ),
        .Q(waddr[4]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \waddr_reg[5] 
       (.C(ap_clk),
        .CE(push),
        .D(\waddr[5]_i_1__0_n_2 ),
        .Q(waddr[5]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \waddr_reg[6] 
       (.C(ap_clk),
        .CE(push),
        .D(\waddr[6]_i_1_n_2 ),
        .Q(waddr[6]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \waddr_reg[7] 
       (.C(ap_clk),
        .CE(push),
        .D(\waddr[7]_i_2_n_2 ),
        .Q(waddr[7]),
        .R(SR));
endmodule

(* ORIG_REF_NAME = "simple_accel_core_gmem_m_axi_buffer" *) 
module design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_buffer__parameterized0
   (full_n_reg_0,
    beat_valid,
    SR,
    next_beat,
    Q,
    DI,
    dout_valid_reg_0,
    S,
    \usedw_reg[6]_0 ,
    \dout_buf_reg[34]_0 ,
    ap_clk,
    D,
    m_axi_gmem_RRESP,
    m_axi_gmem_RVALID,
    ap_rst_n,
    dout_valid_reg_1,
    rdata_ack_t,
    \usedw_reg[7]_0 );
  output full_n_reg_0;
  output beat_valid;
  output [0:0]SR;
  output next_beat;
  output [5:0]Q;
  output [0:0]DI;
  output dout_valid_reg_0;
  output [3:0]S;
  output [2:0]\usedw_reg[6]_0 ;
  output [32:0]\dout_buf_reg[34]_0 ;
  input ap_clk;
  input [32:0]D;
  input [1:0]m_axi_gmem_RRESP;
  input m_axi_gmem_RVALID;
  input ap_rst_n;
  input dout_valid_reg_1;
  input rdata_ack_t;
  input [6:0]\usedw_reg[7]_0 ;

  wire [32:0]D;
  wire [0:0]DI;
  wire [5:0]Q;
  wire [3:0]S;
  wire [0:0]SR;
  wire ap_clk;
  wire ap_rst_n;
  wire beat_valid;
  wire \dout_buf[0]_i_1_n_2 ;
  wire \dout_buf[10]_i_1_n_2 ;
  wire \dout_buf[11]_i_1_n_2 ;
  wire \dout_buf[12]_i_1_n_2 ;
  wire \dout_buf[13]_i_1_n_2 ;
  wire \dout_buf[14]_i_1_n_2 ;
  wire \dout_buf[15]_i_1_n_2 ;
  wire \dout_buf[16]_i_1_n_2 ;
  wire \dout_buf[17]_i_1_n_2 ;
  wire \dout_buf[18]_i_1_n_2 ;
  wire \dout_buf[19]_i_1_n_2 ;
  wire \dout_buf[1]_i_1_n_2 ;
  wire \dout_buf[20]_i_1_n_2 ;
  wire \dout_buf[21]_i_1_n_2 ;
  wire \dout_buf[22]_i_1_n_2 ;
  wire \dout_buf[23]_i_1_n_2 ;
  wire \dout_buf[24]_i_1_n_2 ;
  wire \dout_buf[25]_i_1_n_2 ;
  wire \dout_buf[26]_i_1_n_2 ;
  wire \dout_buf[27]_i_1_n_2 ;
  wire \dout_buf[28]_i_1_n_2 ;
  wire \dout_buf[29]_i_1_n_2 ;
  wire \dout_buf[2]_i_1_n_2 ;
  wire \dout_buf[30]_i_1_n_2 ;
  wire \dout_buf[31]_i_1_n_2 ;
  wire \dout_buf[34]_i_2_n_2 ;
  wire \dout_buf[3]_i_1_n_2 ;
  wire \dout_buf[4]_i_1_n_2 ;
  wire \dout_buf[5]_i_1_n_2 ;
  wire \dout_buf[6]_i_1_n_2 ;
  wire \dout_buf[7]_i_1_n_2 ;
  wire \dout_buf[8]_i_1_n_2 ;
  wire \dout_buf[9]_i_1_n_2 ;
  wire [32:0]\dout_buf_reg[34]_0 ;
  wire dout_valid_i_1__0_n_2;
  wire dout_valid_reg_0;
  wire dout_valid_reg_1;
  wire empty_n_i_1_n_2;
  wire empty_n_i_2__0_n_2;
  wire empty_n_i_3__0_n_2;
  wire empty_n_reg_n_2;
  wire full_n_i_1__0_n_2;
  wire full_n_i_2__5_n_2;
  wire full_n_i_3__3_n_2;
  wire full_n_reg_0;
  wire [1:0]m_axi_gmem_RRESP;
  wire m_axi_gmem_RVALID;
  wire mem_reg_i_10_n_2;
  wire mem_reg_i_9_n_2;
  wire mem_reg_n_34;
  wire mem_reg_n_35;
  wire next_beat;
  wire pop;
  wire push;
  wire [34:0]q_buf;
  wire \q_tmp_reg_n_2_[0] ;
  wire \q_tmp_reg_n_2_[10] ;
  wire \q_tmp_reg_n_2_[11] ;
  wire \q_tmp_reg_n_2_[12] ;
  wire \q_tmp_reg_n_2_[13] ;
  wire \q_tmp_reg_n_2_[14] ;
  wire \q_tmp_reg_n_2_[15] ;
  wire \q_tmp_reg_n_2_[16] ;
  wire \q_tmp_reg_n_2_[17] ;
  wire \q_tmp_reg_n_2_[18] ;
  wire \q_tmp_reg_n_2_[19] ;
  wire \q_tmp_reg_n_2_[1] ;
  wire \q_tmp_reg_n_2_[20] ;
  wire \q_tmp_reg_n_2_[21] ;
  wire \q_tmp_reg_n_2_[22] ;
  wire \q_tmp_reg_n_2_[23] ;
  wire \q_tmp_reg_n_2_[24] ;
  wire \q_tmp_reg_n_2_[25] ;
  wire \q_tmp_reg_n_2_[26] ;
  wire \q_tmp_reg_n_2_[27] ;
  wire \q_tmp_reg_n_2_[28] ;
  wire \q_tmp_reg_n_2_[29] ;
  wire \q_tmp_reg_n_2_[2] ;
  wire \q_tmp_reg_n_2_[30] ;
  wire \q_tmp_reg_n_2_[31] ;
  wire \q_tmp_reg_n_2_[34] ;
  wire \q_tmp_reg_n_2_[3] ;
  wire \q_tmp_reg_n_2_[4] ;
  wire \q_tmp_reg_n_2_[5] ;
  wire \q_tmp_reg_n_2_[6] ;
  wire \q_tmp_reg_n_2_[7] ;
  wire \q_tmp_reg_n_2_[8] ;
  wire \q_tmp_reg_n_2_[9] ;
  wire \raddr_reg_n_2_[0] ;
  wire \raddr_reg_n_2_[1] ;
  wire \raddr_reg_n_2_[2] ;
  wire \raddr_reg_n_2_[3] ;
  wire \raddr_reg_n_2_[4] ;
  wire \raddr_reg_n_2_[5] ;
  wire \raddr_reg_n_2_[6] ;
  wire \raddr_reg_n_2_[7] ;
  wire rdata_ack_t;
  wire [7:0]rnext;
  wire show_ahead0;
  wire show_ahead_reg_n_2;
  wire \usedw[0]_i_1__0_n_2 ;
  wire \usedw[7]_i_1_n_2 ;
  wire [2:0]\usedw_reg[6]_0 ;
  wire [6:0]\usedw_reg[7]_0 ;
  wire [7:6]usedw_reg__0;
  wire [7:0]waddr;
  wire \waddr[0]_i_1__0_n_2 ;
  wire \waddr[1]_i_1__0_n_2 ;
  wire \waddr[2]_i_1__0_n_2 ;
  wire \waddr[3]_i_1__0_n_2 ;
  wire \waddr[4]_i_1__0_n_2 ;
  wire \waddr[5]_i_1__1_n_2 ;
  wire \waddr[6]_i_1__0_n_2 ;
  wire \waddr[6]_i_2__0_n_2 ;
  wire \waddr[7]_i_2__0_n_2 ;
  wire \waddr[7]_i_3__0_n_2 ;
  wire \waddr[7]_i_4__0_n_2 ;
  wire [1:1]NLW_mem_reg_DOPBDOP_UNCONNECTED;

  (* SOFT_HLUTNM = "soft_lutpair53" *) 
  LUT3 #(
    .INIT(8'hA2)) 
    \bus_equal_gen.data_buf[31]_i_1__0 
       (.I0(beat_valid),
        .I1(dout_valid_reg_1),
        .I2(rdata_ack_t),
        .O(next_beat));
  LUT3 #(
    .INIT(8'hBA)) 
    \bus_equal_gen.rdata_valid_t_i_1 
       (.I0(beat_valid),
        .I1(rdata_ack_t),
        .I2(dout_valid_reg_1),
        .O(dout_valid_reg_0));
  LUT1 #(
    .INIT(2'h1)) 
    \could_multi_bursts.awaddr_buf[31]_i_1 
       (.I0(ap_rst_n),
        .O(SR));
  (* SOFT_HLUTNM = "soft_lutpair55" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[0]_i_1 
       (.I0(\q_tmp_reg_n_2_[0] ),
        .I1(q_buf[0]),
        .I2(show_ahead_reg_n_2),
        .O(\dout_buf[0]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair62" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[10]_i_1 
       (.I0(\q_tmp_reg_n_2_[10] ),
        .I1(q_buf[10]),
        .I2(show_ahead_reg_n_2),
        .O(\dout_buf[10]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair65" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[11]_i_1 
       (.I0(\q_tmp_reg_n_2_[11] ),
        .I1(q_buf[11]),
        .I2(show_ahead_reg_n_2),
        .O(\dout_buf[11]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair66" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[12]_i_1 
       (.I0(\q_tmp_reg_n_2_[12] ),
        .I1(q_buf[12]),
        .I2(show_ahead_reg_n_2),
        .O(\dout_buf[12]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair67" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[13]_i_1 
       (.I0(\q_tmp_reg_n_2_[13] ),
        .I1(q_buf[13]),
        .I2(show_ahead_reg_n_2),
        .O(\dout_buf[13]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair64" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[14]_i_1 
       (.I0(\q_tmp_reg_n_2_[14] ),
        .I1(q_buf[14]),
        .I2(show_ahead_reg_n_2),
        .O(\dout_buf[14]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair63" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[15]_i_1 
       (.I0(\q_tmp_reg_n_2_[15] ),
        .I1(q_buf[15]),
        .I2(show_ahead_reg_n_2),
        .O(\dout_buf[15]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair56" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[16]_i_1 
       (.I0(\q_tmp_reg_n_2_[16] ),
        .I1(q_buf[16]),
        .I2(show_ahead_reg_n_2),
        .O(\dout_buf[16]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair55" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[17]_i_1 
       (.I0(\q_tmp_reg_n_2_[17] ),
        .I1(q_buf[17]),
        .I2(show_ahead_reg_n_2),
        .O(\dout_buf[17]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair58" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[18]_i_1 
       (.I0(\q_tmp_reg_n_2_[18] ),
        .I1(q_buf[18]),
        .I2(show_ahead_reg_n_2),
        .O(\dout_buf[18]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair57" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[19]_i_1 
       (.I0(\q_tmp_reg_n_2_[19] ),
        .I1(q_buf[19]),
        .I2(show_ahead_reg_n_2),
        .O(\dout_buf[19]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair56" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[1]_i_1 
       (.I0(\q_tmp_reg_n_2_[1] ),
        .I1(q_buf[1]),
        .I2(show_ahead_reg_n_2),
        .O(\dout_buf[1]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair59" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[20]_i_1 
       (.I0(\q_tmp_reg_n_2_[20] ),
        .I1(q_buf[20]),
        .I2(show_ahead_reg_n_2),
        .O(\dout_buf[20]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair65" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[21]_i_1 
       (.I0(\q_tmp_reg_n_2_[21] ),
        .I1(q_buf[21]),
        .I2(show_ahead_reg_n_2),
        .O(\dout_buf[21]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair60" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[22]_i_1 
       (.I0(\q_tmp_reg_n_2_[22] ),
        .I1(q_buf[22]),
        .I2(show_ahead_reg_n_2),
        .O(\dout_buf[22]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair61" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[23]_i_1 
       (.I0(\q_tmp_reg_n_2_[23] ),
        .I1(q_buf[23]),
        .I2(show_ahead_reg_n_2),
        .O(\dout_buf[23]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair68" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[24]_i_1 
       (.I0(\q_tmp_reg_n_2_[24] ),
        .I1(q_buf[24]),
        .I2(show_ahead_reg_n_2),
        .O(\dout_buf[24]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair69" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[25]_i_1 
       (.I0(\q_tmp_reg_n_2_[25] ),
        .I1(q_buf[25]),
        .I2(show_ahead_reg_n_2),
        .O(\dout_buf[25]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair66" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[26]_i_1 
       (.I0(\q_tmp_reg_n_2_[26] ),
        .I1(q_buf[26]),
        .I2(show_ahead_reg_n_2),
        .O(\dout_buf[26]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair70" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[27]_i_1 
       (.I0(\q_tmp_reg_n_2_[27] ),
        .I1(q_buf[27]),
        .I2(show_ahead_reg_n_2),
        .O(\dout_buf[27]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair70" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[28]_i_1 
       (.I0(\q_tmp_reg_n_2_[28] ),
        .I1(q_buf[28]),
        .I2(show_ahead_reg_n_2),
        .O(\dout_buf[28]_i_1_n_2 ));
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[29]_i_1 
       (.I0(\q_tmp_reg_n_2_[29] ),
        .I1(q_buf[29]),
        .I2(show_ahead_reg_n_2),
        .O(\dout_buf[29]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair57" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[2]_i_1 
       (.I0(\q_tmp_reg_n_2_[2] ),
        .I1(q_buf[2]),
        .I2(show_ahead_reg_n_2),
        .O(\dout_buf[2]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair67" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[30]_i_1 
       (.I0(\q_tmp_reg_n_2_[30] ),
        .I1(q_buf[30]),
        .I2(show_ahead_reg_n_2),
        .O(\dout_buf[30]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair68" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[31]_i_1 
       (.I0(\q_tmp_reg_n_2_[31] ),
        .I1(q_buf[31]),
        .I2(show_ahead_reg_n_2),
        .O(\dout_buf[31]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'h8AAA)) 
    \dout_buf[34]_i_1 
       (.I0(empty_n_reg_n_2),
        .I1(rdata_ack_t),
        .I2(dout_valid_reg_1),
        .I3(beat_valid),
        .O(pop));
  (* SOFT_HLUTNM = "soft_lutpair69" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[34]_i_2 
       (.I0(\q_tmp_reg_n_2_[34] ),
        .I1(q_buf[34]),
        .I2(show_ahead_reg_n_2),
        .O(\dout_buf[34]_i_2_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair58" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[3]_i_1 
       (.I0(\q_tmp_reg_n_2_[3] ),
        .I1(q_buf[3]),
        .I2(show_ahead_reg_n_2),
        .O(\dout_buf[3]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair59" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[4]_i_1 
       (.I0(\q_tmp_reg_n_2_[4] ),
        .I1(q_buf[4]),
        .I2(show_ahead_reg_n_2),
        .O(\dout_buf[4]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair60" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[5]_i_1 
       (.I0(\q_tmp_reg_n_2_[5] ),
        .I1(q_buf[5]),
        .I2(show_ahead_reg_n_2),
        .O(\dout_buf[5]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair61" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[6]_i_1 
       (.I0(\q_tmp_reg_n_2_[6] ),
        .I1(q_buf[6]),
        .I2(show_ahead_reg_n_2),
        .O(\dout_buf[6]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair62" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[7]_i_1 
       (.I0(\q_tmp_reg_n_2_[7] ),
        .I1(q_buf[7]),
        .I2(show_ahead_reg_n_2),
        .O(\dout_buf[7]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair63" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[8]_i_1 
       (.I0(\q_tmp_reg_n_2_[8] ),
        .I1(q_buf[8]),
        .I2(show_ahead_reg_n_2),
        .O(\dout_buf[8]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair64" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \dout_buf[9]_i_1 
       (.I0(\q_tmp_reg_n_2_[9] ),
        .I1(q_buf[9]),
        .I2(show_ahead_reg_n_2),
        .O(\dout_buf[9]_i_1_n_2 ));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[0] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[0]_i_1_n_2 ),
        .Q(\dout_buf_reg[34]_0 [0]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[10] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[10]_i_1_n_2 ),
        .Q(\dout_buf_reg[34]_0 [10]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[11] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[11]_i_1_n_2 ),
        .Q(\dout_buf_reg[34]_0 [11]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[12] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[12]_i_1_n_2 ),
        .Q(\dout_buf_reg[34]_0 [12]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[13] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[13]_i_1_n_2 ),
        .Q(\dout_buf_reg[34]_0 [13]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[14] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[14]_i_1_n_2 ),
        .Q(\dout_buf_reg[34]_0 [14]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[15] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[15]_i_1_n_2 ),
        .Q(\dout_buf_reg[34]_0 [15]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[16] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[16]_i_1_n_2 ),
        .Q(\dout_buf_reg[34]_0 [16]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[17] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[17]_i_1_n_2 ),
        .Q(\dout_buf_reg[34]_0 [17]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[18] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[18]_i_1_n_2 ),
        .Q(\dout_buf_reg[34]_0 [18]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[19] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[19]_i_1_n_2 ),
        .Q(\dout_buf_reg[34]_0 [19]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[1] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[1]_i_1_n_2 ),
        .Q(\dout_buf_reg[34]_0 [1]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[20] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[20]_i_1_n_2 ),
        .Q(\dout_buf_reg[34]_0 [20]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[21] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[21]_i_1_n_2 ),
        .Q(\dout_buf_reg[34]_0 [21]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[22] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[22]_i_1_n_2 ),
        .Q(\dout_buf_reg[34]_0 [22]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[23] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[23]_i_1_n_2 ),
        .Q(\dout_buf_reg[34]_0 [23]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[24] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[24]_i_1_n_2 ),
        .Q(\dout_buf_reg[34]_0 [24]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[25] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[25]_i_1_n_2 ),
        .Q(\dout_buf_reg[34]_0 [25]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[26] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[26]_i_1_n_2 ),
        .Q(\dout_buf_reg[34]_0 [26]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[27] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[27]_i_1_n_2 ),
        .Q(\dout_buf_reg[34]_0 [27]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[28] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[28]_i_1_n_2 ),
        .Q(\dout_buf_reg[34]_0 [28]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[29] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[29]_i_1_n_2 ),
        .Q(\dout_buf_reg[34]_0 [29]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[2] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[2]_i_1_n_2 ),
        .Q(\dout_buf_reg[34]_0 [2]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[30] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[30]_i_1_n_2 ),
        .Q(\dout_buf_reg[34]_0 [30]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[31] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[31]_i_1_n_2 ),
        .Q(\dout_buf_reg[34]_0 [31]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[34] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[34]_i_2_n_2 ),
        .Q(\dout_buf_reg[34]_0 [32]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[3] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[3]_i_1_n_2 ),
        .Q(\dout_buf_reg[34]_0 [3]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[4] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[4]_i_1_n_2 ),
        .Q(\dout_buf_reg[34]_0 [4]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[5] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[5]_i_1_n_2 ),
        .Q(\dout_buf_reg[34]_0 [5]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[6] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[6]_i_1_n_2 ),
        .Q(\dout_buf_reg[34]_0 [6]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[7] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[7]_i_1_n_2 ),
        .Q(\dout_buf_reg[34]_0 [7]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[8] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[8]_i_1_n_2 ),
        .Q(\dout_buf_reg[34]_0 [8]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \dout_buf_reg[9] 
       (.C(ap_clk),
        .CE(pop),
        .D(\dout_buf[9]_i_1_n_2 ),
        .Q(\dout_buf_reg[34]_0 [9]),
        .R(SR));
  (* SOFT_HLUTNM = "soft_lutpair53" *) 
  LUT4 #(
    .INIT(16'hBAAA)) 
    dout_valid_i_1__0
       (.I0(empty_n_reg_n_2),
        .I1(rdata_ack_t),
        .I2(dout_valid_reg_1),
        .I3(beat_valid),
        .O(dout_valid_i_1__0_n_2));
  FDRE #(
    .INIT(1'b0)) 
    dout_valid_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(dout_valid_i_1__0_n_2),
        .Q(beat_valid),
        .R(SR));
  LUT6 #(
    .INIT(64'hFFDFDFDF0FD0D0D0)) 
    empty_n_i_1
       (.I0(Q[0]),
        .I1(empty_n_i_2__0_n_2),
        .I2(pop),
        .I3(full_n_reg_0),
        .I4(m_axi_gmem_RVALID),
        .I5(empty_n_reg_n_2),
        .O(empty_n_i_1_n_2));
  LUT4 #(
    .INIT(16'hFFFE)) 
    empty_n_i_2__0
       (.I0(usedw_reg__0[6]),
        .I1(Q[5]),
        .I2(Q[3]),
        .I3(empty_n_i_3__0_n_2),
        .O(empty_n_i_2__0_n_2));
  LUT4 #(
    .INIT(16'hFFFE)) 
    empty_n_i_3__0
       (.I0(usedw_reg__0[7]),
        .I1(Q[1]),
        .I2(Q[2]),
        .I3(Q[4]),
        .O(empty_n_i_3__0_n_2));
  FDRE #(
    .INIT(1'b0)) 
    empty_n_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(empty_n_i_1_n_2),
        .Q(empty_n_reg_n_2),
        .R(SR));
  LUT6 #(
    .INIT(64'hFFFFFFFFFDFF5555)) 
    full_n_i_1__0
       (.I0(ap_rst_n),
        .I1(full_n_i_2__5_n_2),
        .I2(full_n_i_3__3_n_2),
        .I3(m_axi_gmem_RVALID),
        .I4(full_n_reg_0),
        .I5(pop),
        .O(full_n_i_1__0_n_2));
  (* SOFT_HLUTNM = "soft_lutpair54" *) 
  LUT4 #(
    .INIT(16'h7FFF)) 
    full_n_i_2__5
       (.I0(Q[0]),
        .I1(Q[2]),
        .I2(usedw_reg__0[6]),
        .I3(Q[4]),
        .O(full_n_i_2__5_n_2));
  LUT4 #(
    .INIT(16'h7FFF)) 
    full_n_i_3__3
       (.I0(Q[3]),
        .I1(Q[1]),
        .I2(Q[5]),
        .I3(usedw_reg__0[7]),
        .O(full_n_i_3__3_n_2));
  FDRE #(
    .INIT(1'b1)) 
    full_n_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(full_n_i_1__0_n_2),
        .Q(full_n_reg_0),
        .R(1'b0));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p3_d32" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p3_d32" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "8960" *) 
  (* RTL_RAM_NAME = "mem" *) 
  (* bram_addr_begin = "0" *) 
  (* bram_addr_end = "511" *) 
  (* bram_slice_begin = "0" *) 
  (* bram_slice_end = "34" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "511" *) 
  (* ram_slice_begin = "0" *) 
  (* ram_slice_end = "34" *) 
  RAMB18E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .INIT_A(18'h00000),
    .INIT_B(18'h00000),
    .RAM_MODE("SDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(36),
    .READ_WIDTH_B(0),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(18'h00000),
    .SRVAL_B(18'h00000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("READ_FIRST"),
    .WRITE_WIDTH_A(0),
    .WRITE_WIDTH_B(36)) 
    mem_reg
       (.ADDRARDADDR({1'b1,rnext,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b1,waddr,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CLKARDCLK(ap_clk),
        .CLKBWRCLK(ap_clk),
        .DIADI(D[15:0]),
        .DIBDI(D[31:16]),
        .DIPADIP(m_axi_gmem_RRESP),
        .DIPBDIP({1'b1,D[32]}),
        .DOADO(q_buf[15:0]),
        .DOBDO(q_buf[31:16]),
        .DOPADOP({mem_reg_n_34,mem_reg_n_35}),
        .DOPBDOP({NLW_mem_reg_DOPBDOP_UNCONNECTED[1],q_buf[34]}),
        .ENARDEN(1'b1),
        .ENBWREN(full_n_reg_0),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .WEA({1'b0,1'b0}),
        .WEBWE({m_axi_gmem_RVALID,m_axi_gmem_RVALID,m_axi_gmem_RVALID,m_axi_gmem_RVALID}));
  LUT6 #(
    .INIT(64'h7555FFFFFFFFFFFF)) 
    mem_reg_i_10
       (.I0(empty_n_reg_n_2),
        .I1(rdata_ack_t),
        .I2(dout_valid_reg_1),
        .I3(beat_valid),
        .I4(\raddr_reg_n_2_[0] ),
        .I5(\raddr_reg_n_2_[1] ),
        .O(mem_reg_i_10_n_2));
  LUT4 #(
    .INIT(16'h9AAA)) 
    mem_reg_i_1__0
       (.I0(\raddr_reg_n_2_[7] ),
        .I1(mem_reg_i_9_n_2),
        .I2(\raddr_reg_n_2_[5] ),
        .I3(\raddr_reg_n_2_[6] ),
        .O(rnext[7]));
  LUT6 #(
    .INIT(64'hF7FFFFFF08000000)) 
    mem_reg_i_2__0
       (.I0(\raddr_reg_n_2_[4] ),
        .I1(\raddr_reg_n_2_[2] ),
        .I2(mem_reg_i_10_n_2),
        .I3(\raddr_reg_n_2_[3] ),
        .I4(\raddr_reg_n_2_[5] ),
        .I5(\raddr_reg_n_2_[6] ),
        .O(rnext[6]));
  LUT5 #(
    .INIT(32'hA6AAAAAA)) 
    mem_reg_i_3__0
       (.I0(\raddr_reg_n_2_[5] ),
        .I1(\raddr_reg_n_2_[3] ),
        .I2(mem_reg_i_10_n_2),
        .I3(\raddr_reg_n_2_[2] ),
        .I4(\raddr_reg_n_2_[4] ),
        .O(rnext[5]));
  LUT6 #(
    .INIT(64'h6AAAAAAAAAAAAAAA)) 
    mem_reg_i_4__0
       (.I0(\raddr_reg_n_2_[4] ),
        .I1(\raddr_reg_n_2_[2] ),
        .I2(pop),
        .I3(\raddr_reg_n_2_[0] ),
        .I4(\raddr_reg_n_2_[1] ),
        .I5(\raddr_reg_n_2_[3] ),
        .O(rnext[4]));
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    mem_reg_i_5__0
       (.I0(\raddr_reg_n_2_[3] ),
        .I1(\raddr_reg_n_2_[1] ),
        .I2(\raddr_reg_n_2_[0] ),
        .I3(pop),
        .I4(\raddr_reg_n_2_[2] ),
        .O(rnext[3]));
  LUT4 #(
    .INIT(16'h6AAA)) 
    mem_reg_i_6__0
       (.I0(\raddr_reg_n_2_[2] ),
        .I1(pop),
        .I2(\raddr_reg_n_2_[0] ),
        .I3(\raddr_reg_n_2_[1] ),
        .O(rnext[2]));
  LUT6 #(
    .INIT(64'h6666A666AAAAAAAA)) 
    mem_reg_i_7__0
       (.I0(\raddr_reg_n_2_[1] ),
        .I1(\raddr_reg_n_2_[0] ),
        .I2(beat_valid),
        .I3(dout_valid_reg_1),
        .I4(rdata_ack_t),
        .I5(empty_n_reg_n_2),
        .O(rnext[1]));
  LUT5 #(
    .INIT(32'h5595AAAA)) 
    mem_reg_i_8
       (.I0(\raddr_reg_n_2_[0] ),
        .I1(beat_valid),
        .I2(dout_valid_reg_1),
        .I3(rdata_ack_t),
        .I4(empty_n_reg_n_2),
        .O(rnext[0]));
  LUT6 #(
    .INIT(64'h7FFFFFFFFFFFFFFF)) 
    mem_reg_i_9
       (.I0(\raddr_reg_n_2_[3] ),
        .I1(\raddr_reg_n_2_[1] ),
        .I2(\raddr_reg_n_2_[0] ),
        .I3(pop),
        .I4(\raddr_reg_n_2_[2] ),
        .I5(\raddr_reg_n_2_[4] ),
        .O(mem_reg_i_9_n_2));
  LUT2 #(
    .INIT(4'h9)) 
    p_0_out__18_carry__0_i_1
       (.I0(usedw_reg__0[6]),
        .I1(usedw_reg__0[7]),
        .O(\usedw_reg[6]_0 [2]));
  LUT2 #(
    .INIT(4'h9)) 
    p_0_out__18_carry__0_i_2
       (.I0(Q[5]),
        .I1(usedw_reg__0[6]),
        .O(\usedw_reg[6]_0 [1]));
  LUT2 #(
    .INIT(4'h9)) 
    p_0_out__18_carry__0_i_3
       (.I0(Q[4]),
        .I1(Q[5]),
        .O(\usedw_reg[6]_0 [0]));
  LUT1 #(
    .INIT(2'h1)) 
    p_0_out__18_carry_i_1
       (.I0(Q[1]),
        .O(DI));
  LUT2 #(
    .INIT(4'h9)) 
    p_0_out__18_carry_i_2
       (.I0(Q[3]),
        .I1(Q[4]),
        .O(S[3]));
  LUT2 #(
    .INIT(4'h9)) 
    p_0_out__18_carry_i_3
       (.I0(Q[2]),
        .I1(Q[3]),
        .O(S[2]));
  LUT2 #(
    .INIT(4'h9)) 
    p_0_out__18_carry_i_4
       (.I0(Q[1]),
        .I1(Q[2]),
        .O(S[1]));
  LUT6 #(
    .INIT(64'h6A66666655555555)) 
    p_0_out__18_carry_i_5
       (.I0(Q[1]),
        .I1(empty_n_reg_n_2),
        .I2(rdata_ack_t),
        .I3(dout_valid_reg_1),
        .I4(beat_valid),
        .I5(push),
        .O(S[0]));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[0] 
       (.C(ap_clk),
        .CE(push),
        .D(D[0]),
        .Q(\q_tmp_reg_n_2_[0] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[10] 
       (.C(ap_clk),
        .CE(push),
        .D(D[10]),
        .Q(\q_tmp_reg_n_2_[10] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[11] 
       (.C(ap_clk),
        .CE(push),
        .D(D[11]),
        .Q(\q_tmp_reg_n_2_[11] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[12] 
       (.C(ap_clk),
        .CE(push),
        .D(D[12]),
        .Q(\q_tmp_reg_n_2_[12] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[13] 
       (.C(ap_clk),
        .CE(push),
        .D(D[13]),
        .Q(\q_tmp_reg_n_2_[13] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[14] 
       (.C(ap_clk),
        .CE(push),
        .D(D[14]),
        .Q(\q_tmp_reg_n_2_[14] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[15] 
       (.C(ap_clk),
        .CE(push),
        .D(D[15]),
        .Q(\q_tmp_reg_n_2_[15] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[16] 
       (.C(ap_clk),
        .CE(push),
        .D(D[16]),
        .Q(\q_tmp_reg_n_2_[16] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[17] 
       (.C(ap_clk),
        .CE(push),
        .D(D[17]),
        .Q(\q_tmp_reg_n_2_[17] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[18] 
       (.C(ap_clk),
        .CE(push),
        .D(D[18]),
        .Q(\q_tmp_reg_n_2_[18] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[19] 
       (.C(ap_clk),
        .CE(push),
        .D(D[19]),
        .Q(\q_tmp_reg_n_2_[19] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[1] 
       (.C(ap_clk),
        .CE(push),
        .D(D[1]),
        .Q(\q_tmp_reg_n_2_[1] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[20] 
       (.C(ap_clk),
        .CE(push),
        .D(D[20]),
        .Q(\q_tmp_reg_n_2_[20] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[21] 
       (.C(ap_clk),
        .CE(push),
        .D(D[21]),
        .Q(\q_tmp_reg_n_2_[21] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[22] 
       (.C(ap_clk),
        .CE(push),
        .D(D[22]),
        .Q(\q_tmp_reg_n_2_[22] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[23] 
       (.C(ap_clk),
        .CE(push),
        .D(D[23]),
        .Q(\q_tmp_reg_n_2_[23] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[24] 
       (.C(ap_clk),
        .CE(push),
        .D(D[24]),
        .Q(\q_tmp_reg_n_2_[24] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[25] 
       (.C(ap_clk),
        .CE(push),
        .D(D[25]),
        .Q(\q_tmp_reg_n_2_[25] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[26] 
       (.C(ap_clk),
        .CE(push),
        .D(D[26]),
        .Q(\q_tmp_reg_n_2_[26] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[27] 
       (.C(ap_clk),
        .CE(push),
        .D(D[27]),
        .Q(\q_tmp_reg_n_2_[27] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[28] 
       (.C(ap_clk),
        .CE(push),
        .D(D[28]),
        .Q(\q_tmp_reg_n_2_[28] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[29] 
       (.C(ap_clk),
        .CE(push),
        .D(D[29]),
        .Q(\q_tmp_reg_n_2_[29] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[2] 
       (.C(ap_clk),
        .CE(push),
        .D(D[2]),
        .Q(\q_tmp_reg_n_2_[2] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[30] 
       (.C(ap_clk),
        .CE(push),
        .D(D[30]),
        .Q(\q_tmp_reg_n_2_[30] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[31] 
       (.C(ap_clk),
        .CE(push),
        .D(D[31]),
        .Q(\q_tmp_reg_n_2_[31] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[34] 
       (.C(ap_clk),
        .CE(push),
        .D(D[32]),
        .Q(\q_tmp_reg_n_2_[34] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[3] 
       (.C(ap_clk),
        .CE(push),
        .D(D[3]),
        .Q(\q_tmp_reg_n_2_[3] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[4] 
       (.C(ap_clk),
        .CE(push),
        .D(D[4]),
        .Q(\q_tmp_reg_n_2_[4] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[5] 
       (.C(ap_clk),
        .CE(push),
        .D(D[5]),
        .Q(\q_tmp_reg_n_2_[5] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[6] 
       (.C(ap_clk),
        .CE(push),
        .D(D[6]),
        .Q(\q_tmp_reg_n_2_[6] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[7] 
       (.C(ap_clk),
        .CE(push),
        .D(D[7]),
        .Q(\q_tmp_reg_n_2_[7] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[8] 
       (.C(ap_clk),
        .CE(push),
        .D(D[8]),
        .Q(\q_tmp_reg_n_2_[8] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \q_tmp_reg[9] 
       (.C(ap_clk),
        .CE(push),
        .D(D[9]),
        .Q(\q_tmp_reg_n_2_[9] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \raddr_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(rnext[0]),
        .Q(\raddr_reg_n_2_[0] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \raddr_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(rnext[1]),
        .Q(\raddr_reg_n_2_[1] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \raddr_reg[2] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(rnext[2]),
        .Q(\raddr_reg_n_2_[2] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \raddr_reg[3] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(rnext[3]),
        .Q(\raddr_reg_n_2_[3] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \raddr_reg[4] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(rnext[4]),
        .Q(\raddr_reg_n_2_[4] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \raddr_reg[5] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(rnext[5]),
        .Q(\raddr_reg_n_2_[5] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \raddr_reg[6] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(rnext[6]),
        .Q(\raddr_reg_n_2_[6] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \raddr_reg[7] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(rnext[7]),
        .Q(\raddr_reg_n_2_[7] ),
        .R(SR));
  LUT5 #(
    .INIT(32'h40000040)) 
    show_ahead_i_1__0
       (.I0(empty_n_i_2__0_n_2),
        .I1(m_axi_gmem_RVALID),
        .I2(full_n_reg_0),
        .I3(Q[0]),
        .I4(pop),
        .O(show_ahead0));
  FDRE #(
    .INIT(1'b0)) 
    show_ahead_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(show_ahead0),
        .Q(show_ahead_reg_n_2),
        .R(SR));
  (* SOFT_HLUTNM = "soft_lutpair54" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \usedw[0]_i_1__0 
       (.I0(Q[0]),
        .O(\usedw[0]_i_1__0_n_2 ));
  LUT6 #(
    .INIT(64'h08FFF700F700F700)) 
    \usedw[7]_i_1 
       (.I0(beat_valid),
        .I1(dout_valid_reg_1),
        .I2(rdata_ack_t),
        .I3(empty_n_reg_n_2),
        .I4(m_axi_gmem_RVALID),
        .I5(full_n_reg_0),
        .O(\usedw[7]_i_1_n_2 ));
  FDRE #(
    .INIT(1'b0)) 
    \usedw_reg[0] 
       (.C(ap_clk),
        .CE(\usedw[7]_i_1_n_2 ),
        .D(\usedw[0]_i_1__0_n_2 ),
        .Q(Q[0]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \usedw_reg[1] 
       (.C(ap_clk),
        .CE(\usedw[7]_i_1_n_2 ),
        .D(\usedw_reg[7]_0 [0]),
        .Q(Q[1]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \usedw_reg[2] 
       (.C(ap_clk),
        .CE(\usedw[7]_i_1_n_2 ),
        .D(\usedw_reg[7]_0 [1]),
        .Q(Q[2]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \usedw_reg[3] 
       (.C(ap_clk),
        .CE(\usedw[7]_i_1_n_2 ),
        .D(\usedw_reg[7]_0 [2]),
        .Q(Q[3]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \usedw_reg[4] 
       (.C(ap_clk),
        .CE(\usedw[7]_i_1_n_2 ),
        .D(\usedw_reg[7]_0 [3]),
        .Q(Q[4]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \usedw_reg[5] 
       (.C(ap_clk),
        .CE(\usedw[7]_i_1_n_2 ),
        .D(\usedw_reg[7]_0 [4]),
        .Q(Q[5]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \usedw_reg[6] 
       (.C(ap_clk),
        .CE(\usedw[7]_i_1_n_2 ),
        .D(\usedw_reg[7]_0 [5]),
        .Q(usedw_reg__0[6]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \usedw_reg[7] 
       (.C(ap_clk),
        .CE(\usedw[7]_i_1_n_2 ),
        .D(\usedw_reg[7]_0 [6]),
        .Q(usedw_reg__0[7]),
        .R(SR));
  (* SOFT_HLUTNM = "soft_lutpair72" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \waddr[0]_i_1__0 
       (.I0(waddr[0]),
        .O(\waddr[0]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair72" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \waddr[1]_i_1__0 
       (.I0(waddr[0]),
        .I1(waddr[1]),
        .O(\waddr[1]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair71" *) 
  LUT3 #(
    .INIT(8'h6A)) 
    \waddr[2]_i_1__0 
       (.I0(waddr[2]),
        .I1(waddr[0]),
        .I2(waddr[1]),
        .O(\waddr[2]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair52" *) 
  LUT4 #(
    .INIT(16'h6AAA)) 
    \waddr[3]_i_1__0 
       (.I0(waddr[3]),
        .I1(waddr[0]),
        .I2(waddr[1]),
        .I3(waddr[2]),
        .O(\waddr[3]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair52" *) 
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    \waddr[4]_i_1__0 
       (.I0(waddr[4]),
        .I1(waddr[2]),
        .I2(waddr[1]),
        .I3(waddr[0]),
        .I4(waddr[3]),
        .O(\waddr[4]_i_1__0_n_2 ));
  LUT6 #(
    .INIT(64'h6AAAAAAAAAAAAAAA)) 
    \waddr[5]_i_1__1 
       (.I0(waddr[5]),
        .I1(waddr[3]),
        .I2(waddr[0]),
        .I3(waddr[1]),
        .I4(waddr[2]),
        .I5(waddr[4]),
        .O(\waddr[5]_i_1__1_n_2 ));
  LUT6 #(
    .INIT(64'h6AAAAAAAAAAAAAAA)) 
    \waddr[6]_i_1__0 
       (.I0(waddr[6]),
        .I1(waddr[4]),
        .I2(waddr[2]),
        .I3(\waddr[6]_i_2__0_n_2 ),
        .I4(waddr[3]),
        .I5(waddr[5]),
        .O(\waddr[6]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair71" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \waddr[6]_i_2__0 
       (.I0(waddr[1]),
        .I1(waddr[0]),
        .O(\waddr[6]_i_2__0_n_2 ));
  LUT2 #(
    .INIT(4'h8)) 
    \waddr[7]_i_1__0 
       (.I0(full_n_reg_0),
        .I1(m_axi_gmem_RVALID),
        .O(push));
  LUT4 #(
    .INIT(16'hB8CC)) 
    \waddr[7]_i_2__0 
       (.I0(\waddr[7]_i_3__0_n_2 ),
        .I1(waddr[7]),
        .I2(\waddr[7]_i_4__0_n_2 ),
        .I3(waddr[6]),
        .O(\waddr[7]_i_2__0_n_2 ));
  LUT6 #(
    .INIT(64'h7FFFFFFFFFFFFFFF)) 
    \waddr[7]_i_3__0 
       (.I0(waddr[4]),
        .I1(waddr[2]),
        .I2(waddr[0]),
        .I3(waddr[1]),
        .I4(waddr[3]),
        .I5(waddr[5]),
        .O(\waddr[7]_i_3__0_n_2 ));
  LUT6 #(
    .INIT(64'h8000000000000000)) 
    \waddr[7]_i_4__0 
       (.I0(waddr[4]),
        .I1(waddr[2]),
        .I2(waddr[1]),
        .I3(waddr[0]),
        .I4(waddr[3]),
        .I5(waddr[5]),
        .O(\waddr[7]_i_4__0_n_2 ));
  FDRE #(
    .INIT(1'b0)) 
    \waddr_reg[0] 
       (.C(ap_clk),
        .CE(push),
        .D(\waddr[0]_i_1__0_n_2 ),
        .Q(waddr[0]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \waddr_reg[1] 
       (.C(ap_clk),
        .CE(push),
        .D(\waddr[1]_i_1__0_n_2 ),
        .Q(waddr[1]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \waddr_reg[2] 
       (.C(ap_clk),
        .CE(push),
        .D(\waddr[2]_i_1__0_n_2 ),
        .Q(waddr[2]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \waddr_reg[3] 
       (.C(ap_clk),
        .CE(push),
        .D(\waddr[3]_i_1__0_n_2 ),
        .Q(waddr[3]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \waddr_reg[4] 
       (.C(ap_clk),
        .CE(push),
        .D(\waddr[4]_i_1__0_n_2 ),
        .Q(waddr[4]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \waddr_reg[5] 
       (.C(ap_clk),
        .CE(push),
        .D(\waddr[5]_i_1__1_n_2 ),
        .Q(waddr[5]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \waddr_reg[6] 
       (.C(ap_clk),
        .CE(push),
        .D(\waddr[6]_i_1__0_n_2 ),
        .Q(waddr[6]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \waddr_reg[7] 
       (.C(ap_clk),
        .CE(push),
        .D(\waddr[7]_i_2__0_n_2 ),
        .Q(waddr[7]),
        .R(SR));
endmodule

module design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo
   (burst_valid,
    invalid_len_event_reg2_reg,
    push,
    E,
    p_26_in,
    D,
    next_wreq,
    \could_multi_bursts.loop_cnt_reg[0] ,
    \sect_len_buf_reg[3] ,
    wreq_handling_reg,
    \could_multi_bursts.sect_handling_reg ,
    \bus_equal_gen.WLAST_Dummy_reg ,
    \could_multi_bursts.last_sect_buf_reg ,
    ap_rst_n_0,
    ap_rst_n_1,
    ap_rst_n_2,
    SR,
    ap_clk,
    in,
    \could_multi_bursts.AWVALID_Dummy_reg ,
    \could_multi_bursts.awaddr_buf_reg[2] ,
    ap_rst_n,
    CO,
    wreq_handling_reg_0,
    fifo_wreq_valid,
    Q,
    sect_cnt0,
    \sect_cnt_reg[0] ,
    \could_multi_bursts.sect_handling_reg_0 ,
    \end_addr_buf_reg[31] ,
    m_axi_gmem_AWREADY,
    \could_multi_bursts.awaddr_buf_reg[2]_0 ,
    \could_multi_bursts.awaddr_buf_reg[2]_1 ,
    \bus_equal_gen.WLAST_Dummy_i_2_0 ,
    \q_reg[0]_0 ,
    \could_multi_bursts.awlen_buf[3]_i_2_0 ,
    \could_multi_bursts.awlen_buf[3]_i_2_1 ,
    wreq_handling_reg_1,
    m_axi_gmem_WLAST,
    \bus_equal_gen.WLAST_Dummy_reg_0 ,
    m_axi_gmem_WREADY,
    \could_multi_bursts.last_sect_buf_reg_0 ,
    \sect_addr_buf_reg[2] ,
    fifo_resp_ready);
  output burst_valid;
  output invalid_len_event_reg2_reg;
  output push;
  output [0:0]E;
  output p_26_in;
  output [19:0]D;
  output next_wreq;
  output \could_multi_bursts.loop_cnt_reg[0] ;
  output [3:0]\sect_len_buf_reg[3] ;
  output wreq_handling_reg;
  output \could_multi_bursts.sect_handling_reg ;
  output \bus_equal_gen.WLAST_Dummy_reg ;
  output \could_multi_bursts.last_sect_buf_reg ;
  output [0:0]ap_rst_n_0;
  output [0:0]ap_rst_n_1;
  output [0:0]ap_rst_n_2;
  input [0:0]SR;
  input ap_clk;
  input [0:0]in;
  input \could_multi_bursts.AWVALID_Dummy_reg ;
  input \could_multi_bursts.awaddr_buf_reg[2] ;
  input ap_rst_n;
  input [0:0]CO;
  input wreq_handling_reg_0;
  input fifo_wreq_valid;
  input [19:0]Q;
  input [18:0]sect_cnt0;
  input [0:0]\sect_cnt_reg[0] ;
  input \could_multi_bursts.sect_handling_reg_0 ;
  input \end_addr_buf_reg[31] ;
  input m_axi_gmem_AWREADY;
  input \could_multi_bursts.awaddr_buf_reg[2]_0 ;
  input \could_multi_bursts.awaddr_buf_reg[2]_1 ;
  input [7:0]\bus_equal_gen.WLAST_Dummy_i_2_0 ;
  input [0:0]\q_reg[0]_0 ;
  input [9:0]\could_multi_bursts.awlen_buf[3]_i_2_0 ;
  input [5:0]\could_multi_bursts.awlen_buf[3]_i_2_1 ;
  input wreq_handling_reg_1;
  input m_axi_gmem_WLAST;
  input \bus_equal_gen.WLAST_Dummy_reg_0 ;
  input m_axi_gmem_WREADY;
  input \could_multi_bursts.last_sect_buf_reg_0 ;
  input [0:0]\sect_addr_buf_reg[2] ;
  input fifo_resp_ready;

  wire [0:0]CO;
  wire [19:0]D;
  wire [0:0]E;
  wire [19:0]Q;
  wire [0:0]SR;
  wire ap_clk;
  wire ap_rst_n;
  wire [0:0]ap_rst_n_0;
  wire [0:0]ap_rst_n_1;
  wire [0:0]ap_rst_n_2;
  wire burst_valid;
  wire [7:0]\bus_equal_gen.WLAST_Dummy_i_2_0 ;
  wire \bus_equal_gen.WLAST_Dummy_i_3_n_2 ;
  wire \bus_equal_gen.WLAST_Dummy_i_4_n_2 ;
  wire \bus_equal_gen.WLAST_Dummy_reg ;
  wire \bus_equal_gen.WLAST_Dummy_reg_0 ;
  wire \could_multi_bursts.AWVALID_Dummy_reg ;
  wire \could_multi_bursts.awaddr_buf[31]_i_5_n_2 ;
  wire \could_multi_bursts.awaddr_buf_reg[2] ;
  wire \could_multi_bursts.awaddr_buf_reg[2]_0 ;
  wire \could_multi_bursts.awaddr_buf_reg[2]_1 ;
  wire [9:0]\could_multi_bursts.awlen_buf[3]_i_2_0 ;
  wire [5:0]\could_multi_bursts.awlen_buf[3]_i_2_1 ;
  wire \could_multi_bursts.awlen_buf[3]_i_3_n_2 ;
  wire \could_multi_bursts.awlen_buf[3]_i_4_n_2 ;
  wire \could_multi_bursts.last_sect_buf_reg ;
  wire \could_multi_bursts.last_sect_buf_reg_0 ;
  wire \could_multi_bursts.loop_cnt_reg[0] ;
  wire \could_multi_bursts.sect_handling_reg ;
  wire \could_multi_bursts.sect_handling_reg_0 ;
  wire data_vld_i_1_n_2;
  wire data_vld_reg_n_2;
  wire \end_addr_buf_reg[31] ;
  wire fifo_burst_ready;
  wire fifo_resp_ready;
  wire fifo_wreq_valid;
  wire full_n_i_1__1_n_2;
  wire full_n_i_2__1_n_2;
  wire [0:0]in;
  wire invalid_len_event_reg2_reg;
  wire m_axi_gmem_AWREADY;
  wire m_axi_gmem_WLAST;
  wire m_axi_gmem_WREADY;
  wire \mem_reg[4][0]_srl5_n_2 ;
  wire \mem_reg[4][1]_srl5_n_2 ;
  wire \mem_reg[4][2]_srl5_n_2 ;
  wire \mem_reg[4][3]_srl5_n_2 ;
  wire next_burst;
  wire next_wreq;
  wire p_26_in;
  wire pop0;
  wire \pout[0]_i_1_n_2 ;
  wire \pout[1]_i_1_n_2 ;
  wire \pout[2]_i_1_n_2 ;
  wire \pout_reg_n_2_[0] ;
  wire \pout_reg_n_2_[1] ;
  wire \pout_reg_n_2_[2] ;
  wire push;
  wire push_0;
  wire [3:0]q;
  wire [0:0]\q_reg[0]_0 ;
  wire [0:0]\sect_addr_buf_reg[2] ;
  wire [18:0]sect_cnt0;
  wire [0:0]\sect_cnt_reg[0] ;
  wire [3:0]\sect_len_buf_reg[3] ;
  wire wreq_handling_reg;
  wire wreq_handling_reg_0;
  wire wreq_handling_reg_1;

  (* SOFT_HLUTNM = "soft_lutpair146" *) 
  LUT4 #(
    .INIT(16'hFB08)) 
    \bus_equal_gen.WLAST_Dummy_i_1 
       (.I0(m_axi_gmem_WLAST),
        .I1(\bus_equal_gen.WLAST_Dummy_reg_0 ),
        .I2(m_axi_gmem_WREADY),
        .I3(next_burst),
        .O(\bus_equal_gen.WLAST_Dummy_reg ));
  LUT5 #(
    .INIT(32'h41000000)) 
    \bus_equal_gen.WLAST_Dummy_i_2 
       (.I0(\bus_equal_gen.WLAST_Dummy_i_3_n_2 ),
        .I1(q[3]),
        .I2(\bus_equal_gen.WLAST_Dummy_i_2_0 [3]),
        .I3(\bus_equal_gen.WLAST_Dummy_i_4_n_2 ),
        .I4(\q_reg[0]_0 ),
        .O(next_burst));
  LUT6 #(
    .INIT(64'hFFFEFFFFFFFFFFFE)) 
    \bus_equal_gen.WLAST_Dummy_i_3 
       (.I0(\bus_equal_gen.WLAST_Dummy_i_2_0 [7]),
        .I1(\bus_equal_gen.WLAST_Dummy_i_2_0 [5]),
        .I2(\bus_equal_gen.WLAST_Dummy_i_2_0 [6]),
        .I3(\bus_equal_gen.WLAST_Dummy_i_2_0 [4]),
        .I4(q[0]),
        .I5(\bus_equal_gen.WLAST_Dummy_i_2_0 [0]),
        .O(\bus_equal_gen.WLAST_Dummy_i_3_n_2 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \bus_equal_gen.WLAST_Dummy_i_4 
       (.I0(\bus_equal_gen.WLAST_Dummy_i_2_0 [1]),
        .I1(q[1]),
        .I2(q[2]),
        .I3(\bus_equal_gen.WLAST_Dummy_i_2_0 [2]),
        .O(\bus_equal_gen.WLAST_Dummy_i_4_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair146" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \bus_equal_gen.len_cnt[7]_i_1 
       (.I0(next_burst),
        .I1(ap_rst_n),
        .O(ap_rst_n_2));
  LUT5 #(
    .INIT(32'h53500000)) 
    \could_multi_bursts.AWVALID_Dummy_i_1 
       (.I0(in),
        .I1(\could_multi_bursts.AWVALID_Dummy_reg ),
        .I2(push),
        .I3(\could_multi_bursts.awaddr_buf_reg[2] ),
        .I4(ap_rst_n),
        .O(invalid_len_event_reg2_reg));
  LUT5 #(
    .INIT(32'h0000555D)) 
    \could_multi_bursts.awaddr_buf[31]_i_2 
       (.I0(\could_multi_bursts.awaddr_buf_reg[2] ),
        .I1(m_axi_gmem_AWREADY),
        .I2(\could_multi_bursts.awaddr_buf_reg[2]_0 ),
        .I3(\could_multi_bursts.awaddr_buf_reg[2]_1 ),
        .I4(\could_multi_bursts.awaddr_buf[31]_i_5_n_2 ),
        .O(push));
  LUT3 #(
    .INIT(8'h7F)) 
    \could_multi_bursts.awaddr_buf[31]_i_5 
       (.I0(fifo_burst_ready),
        .I1(fifo_resp_ready),
        .I2(\could_multi_bursts.sect_handling_reg_0 ),
        .O(\could_multi_bursts.awaddr_buf[31]_i_5_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair160" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \could_multi_bursts.awlen_buf[0]_i_1 
       (.I0(\could_multi_bursts.awlen_buf[3]_i_2_0 [0]),
        .I1(\could_multi_bursts.loop_cnt_reg[0] ),
        .O(\sect_len_buf_reg[3] [0]));
  (* SOFT_HLUTNM = "soft_lutpair161" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \could_multi_bursts.awlen_buf[1]_i_1 
       (.I0(\could_multi_bursts.awlen_buf[3]_i_2_0 [1]),
        .I1(\could_multi_bursts.loop_cnt_reg[0] ),
        .O(\sect_len_buf_reg[3] [1]));
  (* SOFT_HLUTNM = "soft_lutpair160" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \could_multi_bursts.awlen_buf[2]_i_1 
       (.I0(\could_multi_bursts.awlen_buf[3]_i_2_0 [2]),
        .I1(\could_multi_bursts.loop_cnt_reg[0] ),
        .O(\sect_len_buf_reg[3] [2]));
  (* SOFT_HLUTNM = "soft_lutpair161" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \could_multi_bursts.awlen_buf[3]_i_1 
       (.I0(\could_multi_bursts.awlen_buf[3]_i_2_0 [3]),
        .I1(\could_multi_bursts.loop_cnt_reg[0] ),
        .O(\sect_len_buf_reg[3] [3]));
  LUT2 #(
    .INIT(4'hE)) 
    \could_multi_bursts.awlen_buf[3]_i_2 
       (.I0(\could_multi_bursts.awlen_buf[3]_i_3_n_2 ),
        .I1(\could_multi_bursts.awlen_buf[3]_i_4_n_2 ),
        .O(\could_multi_bursts.loop_cnt_reg[0] ));
  LUT6 #(
    .INIT(64'h6FF6FFFFFFFF6FF6)) 
    \could_multi_bursts.awlen_buf[3]_i_3 
       (.I0(\could_multi_bursts.awlen_buf[3]_i_2_1 [0]),
        .I1(\could_multi_bursts.awlen_buf[3]_i_2_0 [4]),
        .I2(\could_multi_bursts.awlen_buf[3]_i_2_0 [6]),
        .I3(\could_multi_bursts.awlen_buf[3]_i_2_1 [2]),
        .I4(\could_multi_bursts.awlen_buf[3]_i_2_0 [5]),
        .I5(\could_multi_bursts.awlen_buf[3]_i_2_1 [1]),
        .O(\could_multi_bursts.awlen_buf[3]_i_3_n_2 ));
  LUT6 #(
    .INIT(64'h6FF6FFFFFFFF6FF6)) 
    \could_multi_bursts.awlen_buf[3]_i_4 
       (.I0(\could_multi_bursts.awlen_buf[3]_i_2_1 [3]),
        .I1(\could_multi_bursts.awlen_buf[3]_i_2_0 [7]),
        .I2(\could_multi_bursts.awlen_buf[3]_i_2_0 [9]),
        .I3(\could_multi_bursts.awlen_buf[3]_i_2_1 [5]),
        .I4(\could_multi_bursts.awlen_buf[3]_i_2_0 [8]),
        .I5(\could_multi_bursts.awlen_buf[3]_i_2_1 [4]),
        .O(\could_multi_bursts.awlen_buf[3]_i_4_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair159" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.last_sect_buf_i_1 
       (.I0(CO),
        .I1(p_26_in),
        .I2(\could_multi_bursts.last_sect_buf_reg_0 ),
        .O(\could_multi_bursts.last_sect_buf_reg ));
  (* SOFT_HLUTNM = "soft_lutpair159" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \could_multi_bursts.loop_cnt[5]_i_1__0 
       (.I0(p_26_in),
        .I1(ap_rst_n),
        .O(ap_rst_n_0));
  (* SOFT_HLUTNM = "soft_lutpair147" *) 
  LUT4 #(
    .INIT(16'hEECE)) 
    \could_multi_bursts.sect_handling_i_1 
       (.I0(\could_multi_bursts.sect_handling_reg_0 ),
        .I1(wreq_handling_reg_0),
        .I2(push),
        .I3(\could_multi_bursts.loop_cnt_reg[0] ),
        .O(\could_multi_bursts.sect_handling_reg ));
  LUT6 #(
    .INIT(64'hFAFAFAFAFAFAFABA)) 
    data_vld_i_1
       (.I0(push_0),
        .I1(pop0),
        .I2(data_vld_reg_n_2),
        .I3(\pout_reg_n_2_[2] ),
        .I4(\pout_reg_n_2_[0] ),
        .I5(\pout_reg_n_2_[1] ),
        .O(data_vld_i_1_n_2));
  FDRE data_vld_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(data_vld_i_1_n_2),
        .Q(data_vld_reg_n_2),
        .R(SR));
  (* SOFT_HLUTNM = "soft_lutpair148" *) 
  LUT4 #(
    .INIT(16'h8FFF)) 
    empty_n_i_1
       (.I0(p_26_in),
        .I1(CO),
        .I2(wreq_handling_reg_0),
        .I3(fifo_wreq_valid),
        .O(E));
  LUT2 #(
    .INIT(4'hB)) 
    empty_n_i_1__0
       (.I0(next_burst),
        .I1(burst_valid),
        .O(pop0));
  FDRE empty_n_reg
       (.C(ap_clk),
        .CE(pop0),
        .D(data_vld_reg_n_2),
        .Q(burst_valid),
        .R(SR));
  LUT6 #(
    .INIT(64'h000000005DDD5D5D)) 
    fifo_wreq_valid_buf_i_1
       (.I0(wreq_handling_reg_0),
        .I1(CO),
        .I2(\could_multi_bursts.sect_handling_reg_0 ),
        .I3(\could_multi_bursts.loop_cnt_reg[0] ),
        .I4(push),
        .I5(\end_addr_buf_reg[31] ),
        .O(next_wreq));
  LUT6 #(
    .INIT(64'hFFFFDDDDD5DDDDDD)) 
    full_n_i_1__1
       (.I0(ap_rst_n),
        .I1(fifo_burst_ready),
        .I2(full_n_i_2__1_n_2),
        .I3(push_0),
        .I4(data_vld_reg_n_2),
        .I5(pop0),
        .O(full_n_i_1__1_n_2));
  LUT3 #(
    .INIT(8'hBF)) 
    full_n_i_2__1
       (.I0(\pout_reg_n_2_[2] ),
        .I1(\pout_reg_n_2_[0] ),
        .I2(\pout_reg_n_2_[1] ),
        .O(full_n_i_2__1_n_2));
  FDRE full_n_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(full_n_i_1__1_n_2),
        .Q(fifo_burst_ready),
        .R(1'b0));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/bus_equal_gen.fifo_burst/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/bus_equal_gen.fifo_burst/mem_reg[4][0]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][0]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push_0),
        .CLK(ap_clk),
        .D(\sect_len_buf_reg[3] [0]),
        .Q(\mem_reg[4][0]_srl5_n_2 ));
  LUT2 #(
    .INIT(4'h2)) 
    \mem_reg[4][0]_srl5_i_1 
       (.I0(push),
        .I1(in),
        .O(push_0));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/bus_equal_gen.fifo_burst/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/bus_equal_gen.fifo_burst/mem_reg[4][1]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][1]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push_0),
        .CLK(ap_clk),
        .D(\sect_len_buf_reg[3] [1]),
        .Q(\mem_reg[4][1]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/bus_equal_gen.fifo_burst/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/bus_equal_gen.fifo_burst/mem_reg[4][2]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][2]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push_0),
        .CLK(ap_clk),
        .D(\sect_len_buf_reg[3] [2]),
        .Q(\mem_reg[4][2]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/bus_equal_gen.fifo_burst/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/bus_equal_gen.fifo_burst/mem_reg[4][3]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][3]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push_0),
        .CLK(ap_clk),
        .D(\sect_len_buf_reg[3] [3]),
        .Q(\mem_reg[4][3]_srl5_n_2 ));
  LUT6 #(
    .INIT(64'hF0FF0FFF0F00E000)) 
    \pout[0]_i_1 
       (.I0(\pout_reg_n_2_[2] ),
        .I1(\pout_reg_n_2_[1] ),
        .I2(pop0),
        .I3(data_vld_reg_n_2),
        .I4(push_0),
        .I5(\pout_reg_n_2_[0] ),
        .O(\pout[0]_i_1_n_2 ));
  LUT6 #(
    .INIT(64'hF708BF40F708BF00)) 
    \pout[1]_i_1 
       (.I0(push_0),
        .I1(data_vld_reg_n_2),
        .I2(pop0),
        .I3(\pout_reg_n_2_[1] ),
        .I4(\pout_reg_n_2_[0] ),
        .I5(\pout_reg_n_2_[2] ),
        .O(\pout[1]_i_1_n_2 ));
  LUT6 #(
    .INIT(64'hF7FFFFBF08000000)) 
    \pout[2]_i_1 
       (.I0(push_0),
        .I1(data_vld_reg_n_2),
        .I2(pop0),
        .I3(\pout_reg_n_2_[1] ),
        .I4(\pout_reg_n_2_[0] ),
        .I5(\pout_reg_n_2_[2] ),
        .O(\pout[2]_i_1_n_2 ));
  FDRE \pout_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\pout[0]_i_1_n_2 ),
        .Q(\pout_reg_n_2_[0] ),
        .R(SR));
  FDRE \pout_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\pout[1]_i_1_n_2 ),
        .Q(\pout_reg_n_2_[1] ),
        .R(SR));
  FDRE \pout_reg[2] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\pout[2]_i_1_n_2 ),
        .Q(\pout_reg_n_2_[2] ),
        .R(SR));
  FDRE \q_reg[0] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][0]_srl5_n_2 ),
        .Q(q[0]),
        .R(SR));
  FDRE \q_reg[1] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][1]_srl5_n_2 ),
        .Q(q[1]),
        .R(SR));
  FDRE \q_reg[2] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][2]_srl5_n_2 ),
        .Q(q[2]),
        .R(SR));
  FDRE \q_reg[3] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][3]_srl5_n_2 ),
        .Q(q[3]),
        .R(SR));
  LUT3 #(
    .INIT(8'h4F)) 
    \sect_addr_buf[11]_i_1 
       (.I0(\sect_addr_buf_reg[2] ),
        .I1(p_26_in),
        .I2(ap_rst_n),
        .O(ap_rst_n_1));
  (* SOFT_HLUTNM = "soft_lutpair158" *) 
  LUT3 #(
    .INIT(8'h8B)) 
    \sect_cnt[0]_i_1 
       (.I0(Q[0]),
        .I1(next_wreq),
        .I2(\sect_cnt_reg[0] ),
        .O(D[0]));
  (* SOFT_HLUTNM = "soft_lutpair153" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_cnt[10]_i_1 
       (.I0(Q[10]),
        .I1(next_wreq),
        .I2(sect_cnt0[9]),
        .O(D[10]));
  (* SOFT_HLUTNM = "soft_lutpair149" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_cnt[11]_i_1 
       (.I0(Q[11]),
        .I1(next_wreq),
        .I2(sect_cnt0[10]),
        .O(D[11]));
  (* SOFT_HLUTNM = "soft_lutpair150" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_cnt[12]_i_1 
       (.I0(Q[12]),
        .I1(next_wreq),
        .I2(sect_cnt0[11]),
        .O(D[12]));
  (* SOFT_HLUTNM = "soft_lutpair152" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_cnt[13]_i_1 
       (.I0(Q[13]),
        .I1(next_wreq),
        .I2(sect_cnt0[12]),
        .O(D[13]));
  (* SOFT_HLUTNM = "soft_lutpair153" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_cnt[14]_i_1 
       (.I0(Q[14]),
        .I1(next_wreq),
        .I2(sect_cnt0[13]),
        .O(D[14]));
  (* SOFT_HLUTNM = "soft_lutpair151" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_cnt[15]_i_1 
       (.I0(Q[15]),
        .I1(next_wreq),
        .I2(sect_cnt0[14]),
        .O(D[15]));
  (* SOFT_HLUTNM = "soft_lutpair152" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_cnt[16]_i_1 
       (.I0(Q[16]),
        .I1(next_wreq),
        .I2(sect_cnt0[15]),
        .O(D[16]));
  (* SOFT_HLUTNM = "soft_lutpair151" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_cnt[17]_i_1 
       (.I0(Q[17]),
        .I1(next_wreq),
        .I2(sect_cnt0[16]),
        .O(D[17]));
  (* SOFT_HLUTNM = "soft_lutpair150" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_cnt[18]_i_1 
       (.I0(Q[18]),
        .I1(next_wreq),
        .I2(sect_cnt0[17]),
        .O(D[18]));
  (* SOFT_HLUTNM = "soft_lutpair149" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_cnt[19]_i_2 
       (.I0(Q[19]),
        .I1(next_wreq),
        .I2(sect_cnt0[18]),
        .O(D[19]));
  (* SOFT_HLUTNM = "soft_lutpair158" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_cnt[1]_i_1 
       (.I0(Q[1]),
        .I1(next_wreq),
        .I2(sect_cnt0[0]),
        .O(D[1]));
  (* SOFT_HLUTNM = "soft_lutpair157" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_cnt[2]_i_1 
       (.I0(Q[2]),
        .I1(next_wreq),
        .I2(sect_cnt0[1]),
        .O(D[2]));
  (* SOFT_HLUTNM = "soft_lutpair157" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_cnt[3]_i_1 
       (.I0(Q[3]),
        .I1(next_wreq),
        .I2(sect_cnt0[2]),
        .O(D[3]));
  (* SOFT_HLUTNM = "soft_lutpair156" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_cnt[4]_i_1 
       (.I0(Q[4]),
        .I1(next_wreq),
        .I2(sect_cnt0[3]),
        .O(D[4]));
  (* SOFT_HLUTNM = "soft_lutpair156" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_cnt[5]_i_1 
       (.I0(Q[5]),
        .I1(next_wreq),
        .I2(sect_cnt0[4]),
        .O(D[5]));
  (* SOFT_HLUTNM = "soft_lutpair154" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_cnt[6]_i_1 
       (.I0(Q[6]),
        .I1(next_wreq),
        .I2(sect_cnt0[5]),
        .O(D[6]));
  (* SOFT_HLUTNM = "soft_lutpair155" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_cnt[7]_i_1 
       (.I0(Q[7]),
        .I1(next_wreq),
        .I2(sect_cnt0[6]),
        .O(D[7]));
  (* SOFT_HLUTNM = "soft_lutpair155" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_cnt[8]_i_1 
       (.I0(Q[8]),
        .I1(next_wreq),
        .I2(sect_cnt0[7]),
        .O(D[8]));
  (* SOFT_HLUTNM = "soft_lutpair154" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_cnt[9]_i_1 
       (.I0(Q[9]),
        .I1(next_wreq),
        .I2(sect_cnt0[8]),
        .O(D[9]));
  (* SOFT_HLUTNM = "soft_lutpair147" *) 
  LUT4 #(
    .INIT(16'h08AA)) 
    \sect_len_buf[9]_i_1 
       (.I0(wreq_handling_reg_0),
        .I1(push),
        .I2(\could_multi_bursts.loop_cnt_reg[0] ),
        .I3(\could_multi_bursts.sect_handling_reg_0 ),
        .O(p_26_in));
  (* SOFT_HLUTNM = "soft_lutpair148" *) 
  LUT4 #(
    .INIT(16'hCEEE)) 
    wreq_handling_i_1
       (.I0(wreq_handling_reg_0),
        .I1(wreq_handling_reg_1),
        .I2(CO),
        .I3(p_26_in),
        .O(wreq_handling_reg));
endmodule

(* ORIG_REF_NAME = "simple_accel_core_gmem_m_axi_fifo" *) 
module design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo__parameterized0
   (fifo_wreq_valid,
    rs2f_wreq_ack,
    empty_n_reg_0,
    empty_n_reg_1,
    empty_n_reg_2,
    \q_reg[33]_0 ,
    S,
    \sect_cnt_reg[19] ,
    \q_reg[33]_1 ,
    empty_n_reg_3,
    \q_reg[33]_2 ,
    SR,
    E,
    ap_clk,
    p_26_in,
    CO,
    \align_len_reg[31] ,
    ap_rst_n,
    Q,
    full_n_reg_0,
    full_n_reg_1,
    full_n_reg_2,
    \sect_cnt_reg[0] ,
    last_sect_carry__0,
    last_sect_carry__0_0,
    push,
    \q_reg[29]_0 );
  output fifo_wreq_valid;
  output rs2f_wreq_ack;
  output [0:0]empty_n_reg_0;
  output empty_n_reg_1;
  output empty_n_reg_2;
  output [30:0]\q_reg[33]_0 ;
  output [3:0]S;
  output [2:0]\sect_cnt_reg[19] ;
  output [0:0]\q_reg[33]_1 ;
  output [0:0]empty_n_reg_3;
  output [0:0]\q_reg[33]_2 ;
  input [0:0]SR;
  input [0:0]E;
  input ap_clk;
  input p_26_in;
  input [0:0]CO;
  input \align_len_reg[31] ;
  input ap_rst_n;
  input [0:0]Q;
  input full_n_reg_0;
  input full_n_reg_1;
  input [0:0]full_n_reg_2;
  input \sect_cnt_reg[0] ;
  input [19:0]last_sect_carry__0;
  input [19:0]last_sect_carry__0_0;
  input push;
  input [29:0]\q_reg[29]_0 ;

  wire [0:0]CO;
  wire [0:0]E;
  wire [0:0]Q;
  wire [3:0]S;
  wire [0:0]SR;
  wire \align_len_reg[31] ;
  wire ap_clk;
  wire ap_rst_n;
  wire data_vld_i_1__0_n_2;
  wire data_vld_reg_n_2;
  wire [0:0]empty_n_reg_0;
  wire empty_n_reg_1;
  wire empty_n_reg_2;
  wire [0:0]empty_n_reg_3;
  wire fifo_wreq_valid;
  wire full_n_i_1__2_n_2;
  wire full_n_i_2__2_n_2;
  wire full_n_reg_0;
  wire full_n_reg_1;
  wire [0:0]full_n_reg_2;
  wire [19:0]last_sect_carry__0;
  wire [19:0]last_sect_carry__0_0;
  wire \mem_reg[4][0]_srl5_n_2 ;
  wire \mem_reg[4][10]_srl5_n_2 ;
  wire \mem_reg[4][11]_srl5_n_2 ;
  wire \mem_reg[4][12]_srl5_n_2 ;
  wire \mem_reg[4][13]_srl5_n_2 ;
  wire \mem_reg[4][14]_srl5_n_2 ;
  wire \mem_reg[4][15]_srl5_n_2 ;
  wire \mem_reg[4][16]_srl5_n_2 ;
  wire \mem_reg[4][17]_srl5_n_2 ;
  wire \mem_reg[4][18]_srl5_n_2 ;
  wire \mem_reg[4][19]_srl5_n_2 ;
  wire \mem_reg[4][1]_srl5_n_2 ;
  wire \mem_reg[4][20]_srl5_n_2 ;
  wire \mem_reg[4][21]_srl5_n_2 ;
  wire \mem_reg[4][22]_srl5_n_2 ;
  wire \mem_reg[4][23]_srl5_n_2 ;
  wire \mem_reg[4][24]_srl5_n_2 ;
  wire \mem_reg[4][25]_srl5_n_2 ;
  wire \mem_reg[4][26]_srl5_n_2 ;
  wire \mem_reg[4][27]_srl5_n_2 ;
  wire \mem_reg[4][28]_srl5_n_2 ;
  wire \mem_reg[4][29]_srl5_n_2 ;
  wire \mem_reg[4][2]_srl5_n_2 ;
  wire \mem_reg[4][33]_srl5_n_2 ;
  wire \mem_reg[4][3]_srl5_n_2 ;
  wire \mem_reg[4][4]_srl5_n_2 ;
  wire \mem_reg[4][5]_srl5_n_2 ;
  wire \mem_reg[4][6]_srl5_n_2 ;
  wire \mem_reg[4][7]_srl5_n_2 ;
  wire \mem_reg[4][8]_srl5_n_2 ;
  wire \mem_reg[4][9]_srl5_n_2 ;
  wire p_26_in;
  wire \pout[0]_i_1_n_2 ;
  wire \pout[1]_i_1_n_2 ;
  wire \pout[2]_i_1_n_2 ;
  wire \pout[2]_i_2_n_2 ;
  wire \pout_reg_n_2_[0] ;
  wire \pout_reg_n_2_[1] ;
  wire \pout_reg_n_2_[2] ;
  wire push;
  wire [29:0]\q_reg[29]_0 ;
  wire [30:0]\q_reg[33]_0 ;
  wire [0:0]\q_reg[33]_1 ;
  wire [0:0]\q_reg[33]_2 ;
  wire rs2f_wreq_ack;
  wire \sect_cnt_reg[0] ;
  wire [2:0]\sect_cnt_reg[19] ;

  LUT6 #(
    .INIT(64'h40004444FFFFFFFF)) 
    \align_len[31]_i_1__0 
       (.I0(\q_reg[33]_0 [30]),
        .I1(fifo_wreq_valid),
        .I2(p_26_in),
        .I3(CO),
        .I4(\align_len_reg[31] ),
        .I5(ap_rst_n),
        .O(\q_reg[33]_2 ));
  (* SOFT_HLUTNM = "soft_lutpair169" *) 
  LUT4 #(
    .INIT(16'h80AA)) 
    \align_len[31]_i_2 
       (.I0(fifo_wreq_valid),
        .I1(p_26_in),
        .I2(CO),
        .I3(\align_len_reg[31] ),
        .O(empty_n_reg_0));
  LUT6 #(
    .INIT(64'hFFFFAAAAFFFEAAAA)) 
    data_vld_i_1__0
       (.I0(push),
        .I1(\pout_reg_n_2_[0] ),
        .I2(\pout_reg_n_2_[1] ),
        .I3(\pout_reg_n_2_[2] ),
        .I4(data_vld_reg_n_2),
        .I5(\pout[2]_i_2_n_2 ),
        .O(data_vld_i_1__0_n_2));
  FDRE data_vld_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(data_vld_i_1__0_n_2),
        .Q(data_vld_reg_n_2),
        .R(SR));
  FDRE empty_n_reg
       (.C(ap_clk),
        .CE(E),
        .D(data_vld_reg_n_2),
        .Q(fifo_wreq_valid),
        .R(SR));
  (* SOFT_HLUTNM = "soft_lutpair170" *) 
  LUT2 #(
    .INIT(4'h1)) 
    fifo_wreq_valid_buf_i_2
       (.I0(fifo_wreq_valid),
        .I1(\sect_cnt_reg[0] ),
        .O(empty_n_reg_1));
  LUT6 #(
    .INIT(64'hDFFF5F5FFFFF5555)) 
    full_n_i_1__2
       (.I0(ap_rst_n),
        .I1(full_n_i_2__2_n_2),
        .I2(\pout[2]_i_2_n_2 ),
        .I3(Q),
        .I4(rs2f_wreq_ack),
        .I5(data_vld_reg_n_2),
        .O(full_n_i_1__2_n_2));
  LUT3 #(
    .INIT(8'hBF)) 
    full_n_i_2__2
       (.I0(\pout_reg_n_2_[2] ),
        .I1(\pout_reg_n_2_[0] ),
        .I2(\pout_reg_n_2_[1] ),
        .O(full_n_i_2__2_n_2));
  FDRE full_n_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(full_n_i_1__2_n_2),
        .Q(rs2f_wreq_ack),
        .R(1'b0));
  LUT1 #(
    .INIT(2'h1)) 
    i__carry_i_1
       (.I0(\q_reg[33]_0 [30]),
        .O(\q_reg[33]_1 ));
  (* SOFT_HLUTNM = "soft_lutpair170" *) 
  LUT2 #(
    .INIT(4'h2)) 
    invalid_len_event_i_1
       (.I0(fifo_wreq_valid),
        .I1(\q_reg[33]_0 [30]),
        .O(empty_n_reg_2));
  LUT4 #(
    .INIT(16'h9009)) 
    last_sect_carry__0_i_1
       (.I0(last_sect_carry__0_0[19]),
        .I1(last_sect_carry__0[19]),
        .I2(last_sect_carry__0_0[18]),
        .I3(last_sect_carry__0[18]),
        .O(\sect_cnt_reg[19] [2]));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    last_sect_carry__0_i_2
       (.I0(last_sect_carry__0[16]),
        .I1(last_sect_carry__0_0[16]),
        .I2(last_sect_carry__0[17]),
        .I3(last_sect_carry__0_0[17]),
        .I4(last_sect_carry__0_0[15]),
        .I5(last_sect_carry__0[15]),
        .O(\sect_cnt_reg[19] [1]));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    last_sect_carry__0_i_3
       (.I0(last_sect_carry__0[14]),
        .I1(last_sect_carry__0_0[14]),
        .I2(last_sect_carry__0[12]),
        .I3(last_sect_carry__0_0[12]),
        .I4(last_sect_carry__0[13]),
        .I5(last_sect_carry__0_0[13]),
        .O(\sect_cnt_reg[19] [0]));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    last_sect_carry_i_1
       (.I0(last_sect_carry__0[11]),
        .I1(last_sect_carry__0_0[11]),
        .I2(last_sect_carry__0[9]),
        .I3(last_sect_carry__0_0[9]),
        .I4(last_sect_carry__0[10]),
        .I5(last_sect_carry__0_0[10]),
        .O(S[3]));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    last_sect_carry_i_2
       (.I0(last_sect_carry__0[7]),
        .I1(last_sect_carry__0_0[7]),
        .I2(last_sect_carry__0[8]),
        .I3(last_sect_carry__0_0[8]),
        .I4(last_sect_carry__0_0[6]),
        .I5(last_sect_carry__0[6]),
        .O(S[2]));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    last_sect_carry_i_3
       (.I0(last_sect_carry__0[5]),
        .I1(last_sect_carry__0_0[5]),
        .I2(last_sect_carry__0[3]),
        .I3(last_sect_carry__0_0[3]),
        .I4(last_sect_carry__0[4]),
        .I5(last_sect_carry__0_0[4]),
        .O(S[1]));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    last_sect_carry_i_4
       (.I0(last_sect_carry__0[2]),
        .I1(last_sect_carry__0_0[2]),
        .I2(last_sect_carry__0[0]),
        .I3(last_sect_carry__0_0[0]),
        .I4(last_sect_carry__0[1]),
        .I5(last_sect_carry__0_0[1]),
        .O(S[0]));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][0]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][0]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[29]_0 [0]),
        .Q(\mem_reg[4][0]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][10]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][10]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[29]_0 [10]),
        .Q(\mem_reg[4][10]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][11]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][11]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[29]_0 [11]),
        .Q(\mem_reg[4][11]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][12]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][12]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[29]_0 [12]),
        .Q(\mem_reg[4][12]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][13]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][13]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[29]_0 [13]),
        .Q(\mem_reg[4][13]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][14]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][14]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[29]_0 [14]),
        .Q(\mem_reg[4][14]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][15]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][15]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[29]_0 [15]),
        .Q(\mem_reg[4][15]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][16]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][16]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[29]_0 [16]),
        .Q(\mem_reg[4][16]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][17]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][17]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[29]_0 [17]),
        .Q(\mem_reg[4][17]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][18]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][18]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[29]_0 [18]),
        .Q(\mem_reg[4][18]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][19]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][19]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[29]_0 [19]),
        .Q(\mem_reg[4][19]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][1]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][1]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[29]_0 [1]),
        .Q(\mem_reg[4][1]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][20]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][20]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[29]_0 [20]),
        .Q(\mem_reg[4][20]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][21]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][21]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[29]_0 [21]),
        .Q(\mem_reg[4][21]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][22]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][22]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[29]_0 [22]),
        .Q(\mem_reg[4][22]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][23]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][23]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[29]_0 [23]),
        .Q(\mem_reg[4][23]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][24]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][24]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[29]_0 [24]),
        .Q(\mem_reg[4][24]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][25]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][25]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[29]_0 [25]),
        .Q(\mem_reg[4][25]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][26]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][26]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[29]_0 [26]),
        .Q(\mem_reg[4][26]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][27]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][27]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[29]_0 [27]),
        .Q(\mem_reg[4][27]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][28]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][28]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[29]_0 [28]),
        .Q(\mem_reg[4][28]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][29]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][29]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[29]_0 [29]),
        .Q(\mem_reg[4][29]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][2]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][2]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[29]_0 [2]),
        .Q(\mem_reg[4][2]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][33]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][33]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(1'b1),
        .Q(\mem_reg[4][33]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][3]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][3]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[29]_0 [3]),
        .Q(\mem_reg[4][3]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][4]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][4]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[29]_0 [4]),
        .Q(\mem_reg[4][4]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][5]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][5]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[29]_0 [5]),
        .Q(\mem_reg[4][5]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][6]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][6]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[29]_0 [6]),
        .Q(\mem_reg[4][6]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][7]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][7]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[29]_0 [7]),
        .Q(\mem_reg[4][7]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][8]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][8]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[29]_0 [8]),
        .Q(\mem_reg[4][8]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][9]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][9]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[29]_0 [9]),
        .Q(\mem_reg[4][9]_srl5_n_2 ));
  LUT6 #(
    .INIT(64'h6F6F6F6F90909080)) 
    \pout[0]_i_1 
       (.I0(\pout[2]_i_2_n_2 ),
        .I1(push),
        .I2(data_vld_reg_n_2),
        .I3(\pout_reg_n_2_[1] ),
        .I4(\pout_reg_n_2_[2] ),
        .I5(\pout_reg_n_2_[0] ),
        .O(\pout[0]_i_1_n_2 ));
  LUT6 #(
    .INIT(64'h3CCCCCCCCCCCC2CC)) 
    \pout[1]_i_1 
       (.I0(\pout_reg_n_2_[2] ),
        .I1(\pout_reg_n_2_[1] ),
        .I2(\pout_reg_n_2_[0] ),
        .I3(data_vld_reg_n_2),
        .I4(push),
        .I5(\pout[2]_i_2_n_2 ),
        .O(\pout[1]_i_1_n_2 ));
  LUT6 #(
    .INIT(64'h6AAAAAAAAAAAA8AA)) 
    \pout[2]_i_1 
       (.I0(\pout_reg_n_2_[2] ),
        .I1(\pout_reg_n_2_[1] ),
        .I2(\pout_reg_n_2_[0] ),
        .I3(data_vld_reg_n_2),
        .I4(push),
        .I5(\pout[2]_i_2_n_2 ),
        .O(\pout[2]_i_1_n_2 ));
  LUT6 #(
    .INIT(64'h8808080888088808)) 
    \pout[2]_i_2 
       (.I0(fifo_wreq_valid),
        .I1(\align_len_reg[31] ),
        .I2(CO),
        .I3(full_n_reg_0),
        .I4(full_n_reg_1),
        .I5(full_n_reg_2),
        .O(\pout[2]_i_2_n_2 ));
  FDRE \pout_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\pout[0]_i_1_n_2 ),
        .Q(\pout_reg_n_2_[0] ),
        .R(SR));
  FDRE \pout_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\pout[1]_i_1_n_2 ),
        .Q(\pout_reg_n_2_[1] ),
        .R(SR));
  FDRE \pout_reg[2] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\pout[2]_i_1_n_2 ),
        .Q(\pout_reg_n_2_[2] ),
        .R(SR));
  FDRE \q_reg[0] 
       (.C(ap_clk),
        .CE(E),
        .D(\mem_reg[4][0]_srl5_n_2 ),
        .Q(\q_reg[33]_0 [0]),
        .R(SR));
  FDRE \q_reg[10] 
       (.C(ap_clk),
        .CE(E),
        .D(\mem_reg[4][10]_srl5_n_2 ),
        .Q(\q_reg[33]_0 [10]),
        .R(SR));
  FDRE \q_reg[11] 
       (.C(ap_clk),
        .CE(E),
        .D(\mem_reg[4][11]_srl5_n_2 ),
        .Q(\q_reg[33]_0 [11]),
        .R(SR));
  FDRE \q_reg[12] 
       (.C(ap_clk),
        .CE(E),
        .D(\mem_reg[4][12]_srl5_n_2 ),
        .Q(\q_reg[33]_0 [12]),
        .R(SR));
  FDRE \q_reg[13] 
       (.C(ap_clk),
        .CE(E),
        .D(\mem_reg[4][13]_srl5_n_2 ),
        .Q(\q_reg[33]_0 [13]),
        .R(SR));
  FDRE \q_reg[14] 
       (.C(ap_clk),
        .CE(E),
        .D(\mem_reg[4][14]_srl5_n_2 ),
        .Q(\q_reg[33]_0 [14]),
        .R(SR));
  FDRE \q_reg[15] 
       (.C(ap_clk),
        .CE(E),
        .D(\mem_reg[4][15]_srl5_n_2 ),
        .Q(\q_reg[33]_0 [15]),
        .R(SR));
  FDRE \q_reg[16] 
       (.C(ap_clk),
        .CE(E),
        .D(\mem_reg[4][16]_srl5_n_2 ),
        .Q(\q_reg[33]_0 [16]),
        .R(SR));
  FDRE \q_reg[17] 
       (.C(ap_clk),
        .CE(E),
        .D(\mem_reg[4][17]_srl5_n_2 ),
        .Q(\q_reg[33]_0 [17]),
        .R(SR));
  FDRE \q_reg[18] 
       (.C(ap_clk),
        .CE(E),
        .D(\mem_reg[4][18]_srl5_n_2 ),
        .Q(\q_reg[33]_0 [18]),
        .R(SR));
  FDRE \q_reg[19] 
       (.C(ap_clk),
        .CE(E),
        .D(\mem_reg[4][19]_srl5_n_2 ),
        .Q(\q_reg[33]_0 [19]),
        .R(SR));
  FDRE \q_reg[1] 
       (.C(ap_clk),
        .CE(E),
        .D(\mem_reg[4][1]_srl5_n_2 ),
        .Q(\q_reg[33]_0 [1]),
        .R(SR));
  FDRE \q_reg[20] 
       (.C(ap_clk),
        .CE(E),
        .D(\mem_reg[4][20]_srl5_n_2 ),
        .Q(\q_reg[33]_0 [20]),
        .R(SR));
  FDRE \q_reg[21] 
       (.C(ap_clk),
        .CE(E),
        .D(\mem_reg[4][21]_srl5_n_2 ),
        .Q(\q_reg[33]_0 [21]),
        .R(SR));
  FDRE \q_reg[22] 
       (.C(ap_clk),
        .CE(E),
        .D(\mem_reg[4][22]_srl5_n_2 ),
        .Q(\q_reg[33]_0 [22]),
        .R(SR));
  FDRE \q_reg[23] 
       (.C(ap_clk),
        .CE(E),
        .D(\mem_reg[4][23]_srl5_n_2 ),
        .Q(\q_reg[33]_0 [23]),
        .R(SR));
  FDRE \q_reg[24] 
       (.C(ap_clk),
        .CE(E),
        .D(\mem_reg[4][24]_srl5_n_2 ),
        .Q(\q_reg[33]_0 [24]),
        .R(SR));
  FDRE \q_reg[25] 
       (.C(ap_clk),
        .CE(E),
        .D(\mem_reg[4][25]_srl5_n_2 ),
        .Q(\q_reg[33]_0 [25]),
        .R(SR));
  FDRE \q_reg[26] 
       (.C(ap_clk),
        .CE(E),
        .D(\mem_reg[4][26]_srl5_n_2 ),
        .Q(\q_reg[33]_0 [26]),
        .R(SR));
  FDRE \q_reg[27] 
       (.C(ap_clk),
        .CE(E),
        .D(\mem_reg[4][27]_srl5_n_2 ),
        .Q(\q_reg[33]_0 [27]),
        .R(SR));
  FDRE \q_reg[28] 
       (.C(ap_clk),
        .CE(E),
        .D(\mem_reg[4][28]_srl5_n_2 ),
        .Q(\q_reg[33]_0 [28]),
        .R(SR));
  FDRE \q_reg[29] 
       (.C(ap_clk),
        .CE(E),
        .D(\mem_reg[4][29]_srl5_n_2 ),
        .Q(\q_reg[33]_0 [29]),
        .R(SR));
  FDRE \q_reg[2] 
       (.C(ap_clk),
        .CE(E),
        .D(\mem_reg[4][2]_srl5_n_2 ),
        .Q(\q_reg[33]_0 [2]),
        .R(SR));
  FDRE \q_reg[33] 
       (.C(ap_clk),
        .CE(E),
        .D(\mem_reg[4][33]_srl5_n_2 ),
        .Q(\q_reg[33]_0 [30]),
        .R(SR));
  FDRE \q_reg[3] 
       (.C(ap_clk),
        .CE(E),
        .D(\mem_reg[4][3]_srl5_n_2 ),
        .Q(\q_reg[33]_0 [3]),
        .R(SR));
  FDRE \q_reg[4] 
       (.C(ap_clk),
        .CE(E),
        .D(\mem_reg[4][4]_srl5_n_2 ),
        .Q(\q_reg[33]_0 [4]),
        .R(SR));
  FDRE \q_reg[5] 
       (.C(ap_clk),
        .CE(E),
        .D(\mem_reg[4][5]_srl5_n_2 ),
        .Q(\q_reg[33]_0 [5]),
        .R(SR));
  FDRE \q_reg[6] 
       (.C(ap_clk),
        .CE(E),
        .D(\mem_reg[4][6]_srl5_n_2 ),
        .Q(\q_reg[33]_0 [6]),
        .R(SR));
  FDRE \q_reg[7] 
       (.C(ap_clk),
        .CE(E),
        .D(\mem_reg[4][7]_srl5_n_2 ),
        .Q(\q_reg[33]_0 [7]),
        .R(SR));
  FDRE \q_reg[8] 
       (.C(ap_clk),
        .CE(E),
        .D(\mem_reg[4][8]_srl5_n_2 ),
        .Q(\q_reg[33]_0 [8]),
        .R(SR));
  FDRE \q_reg[9] 
       (.C(ap_clk),
        .CE(E),
        .D(\mem_reg[4][9]_srl5_n_2 ),
        .Q(\q_reg[33]_0 [9]),
        .R(SR));
  (* SOFT_HLUTNM = "soft_lutpair169" *) 
  LUT4 #(
    .INIT(16'hF0FE)) 
    \sect_cnt[19]_i_1 
       (.I0(fifo_wreq_valid),
        .I1(\sect_cnt_reg[0] ),
        .I2(p_26_in),
        .I3(\align_len_reg[31] ),
        .O(empty_n_reg_3));
endmodule

(* ORIG_REF_NAME = "simple_accel_core_gmem_m_axi_fifo" *) 
module design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo__parameterized0_1
   (fifo_rreq_valid,
    rs2f_rreq_ack,
    D,
    E,
    \could_multi_bursts.loop_cnt_reg[3] ,
    \could_multi_bursts.loop_cnt_reg[0] ,
    S,
    \q_reg[60]_0 ,
    \q_reg[58]_0 ,
    \q_reg[54]_0 ,
    \q_reg[50]_0 ,
    \q_reg[46]_0 ,
    \q_reg[42]_0 ,
    \q_reg[38]_0 ,
    \q_reg[34]_0 ,
    \end_addr_buf_reg[23] ,
    \sect_cnt_reg[19] ,
    invalid_len_event0,
    SR,
    ap_clk,
    ap_rst_n,
    full_n_reg_0,
    CO,
    full_n_reg_1,
    push,
    Q,
    \sect_cnt_reg[0] ,
    \sect_cnt_reg[0]_0 ,
    \sect_cnt_reg[19]_0 ,
    O,
    \sect_cnt_reg[8] ,
    \sect_cnt_reg[12] ,
    \sect_cnt_reg[16] ,
    \sect_cnt_reg[19]_1 ,
    \could_multi_bursts.arlen_buf[3]_i_3 ,
    \could_multi_bursts.arlen_buf[3]_i_3_0 ,
    last_sect_carry__0,
    \q_reg[63]_0 );
  output fifo_rreq_valid;
  output rs2f_rreq_ack;
  output [19:0]D;
  output [0:0]E;
  output \could_multi_bursts.loop_cnt_reg[3] ;
  output \could_multi_bursts.loop_cnt_reg[0] ;
  output [2:0]S;
  output [58:0]\q_reg[60]_0 ;
  output [3:0]\q_reg[58]_0 ;
  output [3:0]\q_reg[54]_0 ;
  output [3:0]\q_reg[50]_0 ;
  output [3:0]\q_reg[46]_0 ;
  output [3:0]\q_reg[42]_0 ;
  output [3:0]\q_reg[38]_0 ;
  output [2:0]\q_reg[34]_0 ;
  output [3:0]\end_addr_buf_reg[23] ;
  output [2:0]\sect_cnt_reg[19] ;
  output invalid_len_event0;
  input [0:0]SR;
  input ap_clk;
  input ap_rst_n;
  input full_n_reg_0;
  input [0:0]CO;
  input full_n_reg_1;
  input push;
  input [19:0]Q;
  input \sect_cnt_reg[0] ;
  input \sect_cnt_reg[0]_0 ;
  input [19:0]\sect_cnt_reg[19]_0 ;
  input [3:0]O;
  input [3:0]\sect_cnt_reg[8] ;
  input [3:0]\sect_cnt_reg[12] ;
  input [3:0]\sect_cnt_reg[16] ;
  input [2:0]\sect_cnt_reg[19]_1 ;
  input [5:0]\could_multi_bursts.arlen_buf[3]_i_3 ;
  input [5:0]\could_multi_bursts.arlen_buf[3]_i_3_0 ;
  input [19:0]last_sect_carry__0;
  input [61:0]\q_reg[63]_0 ;

  wire [0:0]CO;
  wire [19:0]D;
  wire [0:0]E;
  wire [3:0]O;
  wire [19:0]Q;
  wire [2:0]S;
  wire [0:0]SR;
  wire ap_clk;
  wire ap_rst_n;
  wire [5:0]\could_multi_bursts.arlen_buf[3]_i_3 ;
  wire [5:0]\could_multi_bursts.arlen_buf[3]_i_3_0 ;
  wire \could_multi_bursts.loop_cnt_reg[0] ;
  wire \could_multi_bursts.loop_cnt_reg[3] ;
  wire data_vld_i_1__3_n_2;
  wire data_vld_reg_n_2;
  wire [3:0]\end_addr_buf_reg[23] ;
  wire [63:61]fifo_rreq_data;
  wire fifo_rreq_valid;
  wire full_n_i_1__5_n_2;
  wire full_n_i_2__0_n_2;
  wire full_n_i_3__1_n_2;
  wire full_n_i_4__0_n_2;
  wire full_n_reg_0;
  wire full_n_reg_1;
  wire invalid_len_event0;
  wire invalid_len_event_i_2_n_2;
  wire invalid_len_event_i_3_n_2;
  wire invalid_len_event_i_4_n_2;
  wire invalid_len_event_i_5_n_2;
  wire invalid_len_event_i_6_n_2;
  wire invalid_len_event_i_7_n_2;
  wire invalid_len_event_i_8_n_2;
  wire invalid_len_event_i_9_n_2;
  wire [19:0]last_sect_carry__0;
  wire \mem_reg[4][0]_srl5_n_2 ;
  wire \mem_reg[4][10]_srl5_n_2 ;
  wire \mem_reg[4][11]_srl5_n_2 ;
  wire \mem_reg[4][12]_srl5_n_2 ;
  wire \mem_reg[4][13]_srl5_n_2 ;
  wire \mem_reg[4][14]_srl5_n_2 ;
  wire \mem_reg[4][15]_srl5_n_2 ;
  wire \mem_reg[4][16]_srl5_n_2 ;
  wire \mem_reg[4][17]_srl5_n_2 ;
  wire \mem_reg[4][18]_srl5_n_2 ;
  wire \mem_reg[4][19]_srl5_n_2 ;
  wire \mem_reg[4][1]_srl5_n_2 ;
  wire \mem_reg[4][20]_srl5_n_2 ;
  wire \mem_reg[4][21]_srl5_n_2 ;
  wire \mem_reg[4][22]_srl5_n_2 ;
  wire \mem_reg[4][23]_srl5_n_2 ;
  wire \mem_reg[4][24]_srl5_n_2 ;
  wire \mem_reg[4][25]_srl5_n_2 ;
  wire \mem_reg[4][26]_srl5_n_2 ;
  wire \mem_reg[4][27]_srl5_n_2 ;
  wire \mem_reg[4][28]_srl5_n_2 ;
  wire \mem_reg[4][29]_srl5_n_2 ;
  wire \mem_reg[4][2]_srl5_n_2 ;
  wire \mem_reg[4][32]_srl5_n_2 ;
  wire \mem_reg[4][33]_srl5_n_2 ;
  wire \mem_reg[4][34]_srl5_n_2 ;
  wire \mem_reg[4][35]_srl5_n_2 ;
  wire \mem_reg[4][36]_srl5_n_2 ;
  wire \mem_reg[4][37]_srl5_n_2 ;
  wire \mem_reg[4][38]_srl5_n_2 ;
  wire \mem_reg[4][39]_srl5_n_2 ;
  wire \mem_reg[4][3]_srl5_n_2 ;
  wire \mem_reg[4][40]_srl5_n_2 ;
  wire \mem_reg[4][41]_srl5_n_2 ;
  wire \mem_reg[4][42]_srl5_n_2 ;
  wire \mem_reg[4][43]_srl5_n_2 ;
  wire \mem_reg[4][44]_srl5_n_2 ;
  wire \mem_reg[4][45]_srl5_n_2 ;
  wire \mem_reg[4][46]_srl5_n_2 ;
  wire \mem_reg[4][47]_srl5_n_2 ;
  wire \mem_reg[4][48]_srl5_n_2 ;
  wire \mem_reg[4][49]_srl5_n_2 ;
  wire \mem_reg[4][4]_srl5_n_2 ;
  wire \mem_reg[4][50]_srl5_n_2 ;
  wire \mem_reg[4][51]_srl5_n_2 ;
  wire \mem_reg[4][52]_srl5_n_2 ;
  wire \mem_reg[4][53]_srl5_n_2 ;
  wire \mem_reg[4][54]_srl5_n_2 ;
  wire \mem_reg[4][55]_srl5_n_2 ;
  wire \mem_reg[4][56]_srl5_n_2 ;
  wire \mem_reg[4][57]_srl5_n_2 ;
  wire \mem_reg[4][58]_srl5_n_2 ;
  wire \mem_reg[4][59]_srl5_n_2 ;
  wire \mem_reg[4][5]_srl5_n_2 ;
  wire \mem_reg[4][60]_srl5_n_2 ;
  wire \mem_reg[4][61]_srl5_n_2 ;
  wire \mem_reg[4][62]_srl5_n_2 ;
  wire \mem_reg[4][63]_srl5_n_2 ;
  wire \mem_reg[4][6]_srl5_n_2 ;
  wire \mem_reg[4][7]_srl5_n_2 ;
  wire \mem_reg[4][8]_srl5_n_2 ;
  wire \mem_reg[4][9]_srl5_n_2 ;
  wire pop0;
  wire \pout[0]_i_1_n_2 ;
  wire \pout[1]_i_1_n_2 ;
  wire \pout[2]_i_1_n_2 ;
  wire \pout[2]_i_2__1_n_2 ;
  wire \pout_reg_n_2_[0] ;
  wire \pout_reg_n_2_[1] ;
  wire \pout_reg_n_2_[2] ;
  wire push;
  wire [2:0]\q_reg[34]_0 ;
  wire [3:0]\q_reg[38]_0 ;
  wire [3:0]\q_reg[42]_0 ;
  wire [3:0]\q_reg[46]_0 ;
  wire [3:0]\q_reg[50]_0 ;
  wire [3:0]\q_reg[54]_0 ;
  wire [3:0]\q_reg[58]_0 ;
  wire [58:0]\q_reg[60]_0 ;
  wire [61:0]\q_reg[63]_0 ;
  wire rs2f_rreq_ack;
  wire \sect_cnt_reg[0] ;
  wire \sect_cnt_reg[0]_0 ;
  wire [3:0]\sect_cnt_reg[12] ;
  wire [3:0]\sect_cnt_reg[16] ;
  wire [2:0]\sect_cnt_reg[19] ;
  wire [19:0]\sect_cnt_reg[19]_0 ;
  wire [2:0]\sect_cnt_reg[19]_1 ;
  wire [3:0]\sect_cnt_reg[8] ;

  LUT1 #(
    .INIT(2'h1)) 
    align_len0_carry__0_i_1
       (.I0(\q_reg[60]_0 [36]),
        .O(\q_reg[38]_0 [3]));
  LUT1 #(
    .INIT(2'h1)) 
    align_len0_carry__0_i_2
       (.I0(\q_reg[60]_0 [35]),
        .O(\q_reg[38]_0 [2]));
  LUT1 #(
    .INIT(2'h1)) 
    align_len0_carry__0_i_3
       (.I0(\q_reg[60]_0 [34]),
        .O(\q_reg[38]_0 [1]));
  LUT1 #(
    .INIT(2'h1)) 
    align_len0_carry__0_i_4
       (.I0(\q_reg[60]_0 [33]),
        .O(\q_reg[38]_0 [0]));
  LUT1 #(
    .INIT(2'h1)) 
    align_len0_carry__1_i_1
       (.I0(\q_reg[60]_0 [40]),
        .O(\q_reg[42]_0 [3]));
  LUT1 #(
    .INIT(2'h1)) 
    align_len0_carry__1_i_2
       (.I0(\q_reg[60]_0 [39]),
        .O(\q_reg[42]_0 [2]));
  LUT1 #(
    .INIT(2'h1)) 
    align_len0_carry__1_i_3
       (.I0(\q_reg[60]_0 [38]),
        .O(\q_reg[42]_0 [1]));
  LUT1 #(
    .INIT(2'h1)) 
    align_len0_carry__1_i_4
       (.I0(\q_reg[60]_0 [37]),
        .O(\q_reg[42]_0 [0]));
  LUT1 #(
    .INIT(2'h1)) 
    align_len0_carry__2_i_1
       (.I0(\q_reg[60]_0 [44]),
        .O(\q_reg[46]_0 [3]));
  LUT1 #(
    .INIT(2'h1)) 
    align_len0_carry__2_i_2
       (.I0(\q_reg[60]_0 [43]),
        .O(\q_reg[46]_0 [2]));
  LUT1 #(
    .INIT(2'h1)) 
    align_len0_carry__2_i_3
       (.I0(\q_reg[60]_0 [42]),
        .O(\q_reg[46]_0 [1]));
  LUT1 #(
    .INIT(2'h1)) 
    align_len0_carry__2_i_4
       (.I0(\q_reg[60]_0 [41]),
        .O(\q_reg[46]_0 [0]));
  LUT1 #(
    .INIT(2'h1)) 
    align_len0_carry__3_i_1
       (.I0(\q_reg[60]_0 [48]),
        .O(\q_reg[50]_0 [3]));
  LUT1 #(
    .INIT(2'h1)) 
    align_len0_carry__3_i_2
       (.I0(\q_reg[60]_0 [47]),
        .O(\q_reg[50]_0 [2]));
  LUT1 #(
    .INIT(2'h1)) 
    align_len0_carry__3_i_3
       (.I0(\q_reg[60]_0 [46]),
        .O(\q_reg[50]_0 [1]));
  LUT1 #(
    .INIT(2'h1)) 
    align_len0_carry__3_i_4
       (.I0(\q_reg[60]_0 [45]),
        .O(\q_reg[50]_0 [0]));
  LUT1 #(
    .INIT(2'h1)) 
    align_len0_carry__4_i_1
       (.I0(\q_reg[60]_0 [52]),
        .O(\q_reg[54]_0 [3]));
  LUT1 #(
    .INIT(2'h1)) 
    align_len0_carry__4_i_2
       (.I0(\q_reg[60]_0 [51]),
        .O(\q_reg[54]_0 [2]));
  LUT1 #(
    .INIT(2'h1)) 
    align_len0_carry__4_i_3
       (.I0(\q_reg[60]_0 [50]),
        .O(\q_reg[54]_0 [1]));
  LUT1 #(
    .INIT(2'h1)) 
    align_len0_carry__4_i_4
       (.I0(\q_reg[60]_0 [49]),
        .O(\q_reg[54]_0 [0]));
  LUT1 #(
    .INIT(2'h1)) 
    align_len0_carry__5_i_1
       (.I0(\q_reg[60]_0 [56]),
        .O(\q_reg[58]_0 [3]));
  LUT1 #(
    .INIT(2'h1)) 
    align_len0_carry__5_i_2
       (.I0(\q_reg[60]_0 [55]),
        .O(\q_reg[58]_0 [2]));
  LUT1 #(
    .INIT(2'h1)) 
    align_len0_carry__5_i_3
       (.I0(\q_reg[60]_0 [54]),
        .O(\q_reg[58]_0 [1]));
  LUT1 #(
    .INIT(2'h1)) 
    align_len0_carry__5_i_4
       (.I0(\q_reg[60]_0 [53]),
        .O(\q_reg[58]_0 [0]));
  LUT1 #(
    .INIT(2'h1)) 
    align_len0_carry__6_i_1
       (.I0(fifo_rreq_data[61]),
        .O(S[2]));
  LUT1 #(
    .INIT(2'h1)) 
    align_len0_carry__6_i_2
       (.I0(\q_reg[60]_0 [58]),
        .O(S[1]));
  LUT1 #(
    .INIT(2'h1)) 
    align_len0_carry__6_i_3
       (.I0(\q_reg[60]_0 [57]),
        .O(S[0]));
  LUT1 #(
    .INIT(2'h1)) 
    align_len0_carry_i_1
       (.I0(\q_reg[60]_0 [32]),
        .O(\q_reg[34]_0 [2]));
  LUT1 #(
    .INIT(2'h1)) 
    align_len0_carry_i_2
       (.I0(\q_reg[60]_0 [31]),
        .O(\q_reg[34]_0 [1]));
  LUT1 #(
    .INIT(2'h1)) 
    align_len0_carry_i_3
       (.I0(\q_reg[60]_0 [30]),
        .O(\q_reg[34]_0 [0]));
  (* SOFT_HLUTNM = "soft_lutpair80" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \align_len[31]_i_1 
       (.I0(fifo_rreq_valid),
        .I1(\sect_cnt_reg[0]_0 ),
        .O(E));
  LUT6 #(
    .INIT(64'h6FF6FFFFFFFF6FF6)) 
    \could_multi_bursts.arlen_buf[3]_i_4 
       (.I0(\could_multi_bursts.arlen_buf[3]_i_3 [0]),
        .I1(\could_multi_bursts.arlen_buf[3]_i_3_0 [0]),
        .I2(\could_multi_bursts.arlen_buf[3]_i_3_0 [1]),
        .I3(\could_multi_bursts.arlen_buf[3]_i_3 [1]),
        .I4(\could_multi_bursts.arlen_buf[3]_i_3_0 [2]),
        .I5(\could_multi_bursts.arlen_buf[3]_i_3 [2]),
        .O(\could_multi_bursts.loop_cnt_reg[0] ));
  LUT6 #(
    .INIT(64'h6FF6FFFFFFFF6FF6)) 
    \could_multi_bursts.arlen_buf[3]_i_5 
       (.I0(\could_multi_bursts.arlen_buf[3]_i_3 [3]),
        .I1(\could_multi_bursts.arlen_buf[3]_i_3_0 [3]),
        .I2(\could_multi_bursts.arlen_buf[3]_i_3_0 [5]),
        .I3(\could_multi_bursts.arlen_buf[3]_i_3 [5]),
        .I4(\could_multi_bursts.arlen_buf[3]_i_3_0 [4]),
        .I5(\could_multi_bursts.arlen_buf[3]_i_3 [4]),
        .O(\could_multi_bursts.loop_cnt_reg[3] ));
  LUT6 #(
    .INIT(64'hFFFEFFFFAAAAAAAA)) 
    data_vld_i_1__3
       (.I0(push),
        .I1(\pout_reg_n_2_[2] ),
        .I2(\pout_reg_n_2_[0] ),
        .I3(\pout_reg_n_2_[1] ),
        .I4(full_n_i_2__0_n_2),
        .I5(data_vld_reg_n_2),
        .O(data_vld_i_1__3_n_2));
  FDRE data_vld_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(data_vld_i_1__3_n_2),
        .Q(data_vld_reg_n_2),
        .R(SR));
  LUT1 #(
    .INIT(2'h1)) 
    empty_n_i_1__1
       (.I0(\pout[2]_i_2__1_n_2 ),
        .O(pop0));
  FDRE empty_n_reg
       (.C(ap_clk),
        .CE(pop0),
        .D(data_vld_reg_n_2),
        .Q(fifo_rreq_valid),
        .R(SR));
  LUT6 #(
    .INIT(64'hFBFBFBFBFBFBFBBB)) 
    full_n_i_1__5
       (.I0(full_n_i_2__0_n_2),
        .I1(ap_rst_n),
        .I2(rs2f_rreq_ack),
        .I3(full_n_i_3__1_n_2),
        .I4(\pout_reg_n_2_[2] ),
        .I5(full_n_i_4__0_n_2),
        .O(full_n_i_1__5_n_2));
  (* SOFT_HLUTNM = "soft_lutpair81" *) 
  LUT5 #(
    .INIT(32'h20AAAAAA)) 
    full_n_i_2__0
       (.I0(data_vld_reg_n_2),
        .I1(full_n_reg_0),
        .I2(CO),
        .I3(full_n_reg_1),
        .I4(fifo_rreq_valid),
        .O(full_n_i_2__0_n_2));
  LUT6 #(
    .INIT(64'h4FFFFFFFFFFFFFFF)) 
    full_n_i_3__1
       (.I0(full_n_reg_0),
        .I1(CO),
        .I2(full_n_reg_1),
        .I3(fifo_rreq_valid),
        .I4(push),
        .I5(data_vld_reg_n_2),
        .O(full_n_i_3__1_n_2));
  LUT2 #(
    .INIT(4'h7)) 
    full_n_i_4__0
       (.I0(\pout_reg_n_2_[1] ),
        .I1(\pout_reg_n_2_[0] ),
        .O(full_n_i_4__0_n_2));
  FDRE full_n_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(full_n_i_1__5_n_2),
        .Q(rs2f_rreq_ack),
        .R(1'b0));
  LUT5 #(
    .INIT(32'h888A8888)) 
    invalid_len_event_i_1__0
       (.I0(fifo_rreq_valid),
        .I1(fifo_rreq_data[63]),
        .I2(invalid_len_event_i_2_n_2),
        .I3(invalid_len_event_i_3_n_2),
        .I4(invalid_len_event_i_4_n_2),
        .O(invalid_len_event0));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    invalid_len_event_i_2
       (.I0(\q_reg[60]_0 [40]),
        .I1(\q_reg[60]_0 [35]),
        .I2(fifo_rreq_data[61]),
        .I3(\q_reg[60]_0 [46]),
        .I4(invalid_len_event_i_5_n_2),
        .O(invalid_len_event_i_2_n_2));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    invalid_len_event_i_3
       (.I0(\q_reg[60]_0 [37]),
        .I1(\q_reg[60]_0 [31]),
        .I2(\q_reg[60]_0 [54]),
        .I3(\q_reg[60]_0 [48]),
        .I4(invalid_len_event_i_6_n_2),
        .O(invalid_len_event_i_3_n_2));
  LUT6 #(
    .INIT(64'h0000000000000004)) 
    invalid_len_event_i_4
       (.I0(invalid_len_event_i_7_n_2),
        .I1(invalid_len_event_i_8_n_2),
        .I2(invalid_len_event_i_9_n_2),
        .I3(\q_reg[60]_0 [50]),
        .I4(\q_reg[60]_0 [34]),
        .I5(\q_reg[60]_0 [52]),
        .O(invalid_len_event_i_4_n_2));
  LUT4 #(
    .INIT(16'hFFFE)) 
    invalid_len_event_i_5
       (.I0(\q_reg[60]_0 [33]),
        .I1(\q_reg[60]_0 [55]),
        .I2(\q_reg[60]_0 [44]),
        .I3(\q_reg[60]_0 [57]),
        .O(invalid_len_event_i_5_n_2));
  LUT4 #(
    .INIT(16'hFFFE)) 
    invalid_len_event_i_6
       (.I0(\q_reg[60]_0 [53]),
        .I1(\q_reg[60]_0 [58]),
        .I2(fifo_rreq_data[62]),
        .I3(\q_reg[60]_0 [36]),
        .O(invalid_len_event_i_6_n_2));
  LUT4 #(
    .INIT(16'hFFFE)) 
    invalid_len_event_i_7
       (.I0(\q_reg[60]_0 [45]),
        .I1(\q_reg[60]_0 [49]),
        .I2(\q_reg[60]_0 [38]),
        .I3(\q_reg[60]_0 [51]),
        .O(invalid_len_event_i_7_n_2));
  LUT4 #(
    .INIT(16'h0001)) 
    invalid_len_event_i_8
       (.I0(\q_reg[60]_0 [41]),
        .I1(\q_reg[60]_0 [42]),
        .I2(\q_reg[60]_0 [39]),
        .I3(\q_reg[60]_0 [47]),
        .O(invalid_len_event_i_8_n_2));
  LUT4 #(
    .INIT(16'hFFFE)) 
    invalid_len_event_i_9
       (.I0(\q_reg[60]_0 [30]),
        .I1(\q_reg[60]_0 [43]),
        .I2(\q_reg[60]_0 [32]),
        .I3(\q_reg[60]_0 [56]),
        .O(invalid_len_event_i_9_n_2));
  LUT4 #(
    .INIT(16'h9009)) 
    last_sect_carry__0_i_1__0
       (.I0(Q[19]),
        .I1(last_sect_carry__0[19]),
        .I2(Q[18]),
        .I3(last_sect_carry__0[18]),
        .O(\sect_cnt_reg[19] [2]));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    last_sect_carry__0_i_2__0
       (.I0(last_sect_carry__0[17]),
        .I1(Q[17]),
        .I2(last_sect_carry__0[15]),
        .I3(Q[15]),
        .I4(last_sect_carry__0[16]),
        .I5(Q[16]),
        .O(\sect_cnt_reg[19] [1]));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    last_sect_carry__0_i_3__0
       (.I0(last_sect_carry__0[14]),
        .I1(Q[14]),
        .I2(last_sect_carry__0[13]),
        .I3(Q[13]),
        .I4(last_sect_carry__0[12]),
        .I5(Q[12]),
        .O(\sect_cnt_reg[19] [0]));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    last_sect_carry_i_1__0
       (.I0(last_sect_carry__0[11]),
        .I1(Q[11]),
        .I2(last_sect_carry__0[10]),
        .I3(Q[10]),
        .I4(last_sect_carry__0[9]),
        .I5(Q[9]),
        .O(\end_addr_buf_reg[23] [3]));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    last_sect_carry_i_2__0
       (.I0(last_sect_carry__0[7]),
        .I1(Q[7]),
        .I2(last_sect_carry__0[8]),
        .I3(Q[8]),
        .I4(Q[6]),
        .I5(last_sect_carry__0[6]),
        .O(\end_addr_buf_reg[23] [2]));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    last_sect_carry_i_3__0
       (.I0(last_sect_carry__0[3]),
        .I1(Q[3]),
        .I2(last_sect_carry__0[4]),
        .I3(Q[4]),
        .I4(Q[5]),
        .I5(last_sect_carry__0[5]),
        .O(\end_addr_buf_reg[23] [1]));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    last_sect_carry_i_4__0
       (.I0(last_sect_carry__0[0]),
        .I1(Q[0]),
        .I2(last_sect_carry__0[1]),
        .I3(Q[1]),
        .I4(Q[2]),
        .I5(last_sect_carry__0[2]),
        .O(\end_addr_buf_reg[23] [0]));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][0]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][0]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [0]),
        .Q(\mem_reg[4][0]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][10]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][10]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [10]),
        .Q(\mem_reg[4][10]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][11]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][11]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [11]),
        .Q(\mem_reg[4][11]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][12]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][12]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [12]),
        .Q(\mem_reg[4][12]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][13]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][13]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [13]),
        .Q(\mem_reg[4][13]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][14]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][14]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [14]),
        .Q(\mem_reg[4][14]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][15]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][15]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [15]),
        .Q(\mem_reg[4][15]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][16]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][16]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [16]),
        .Q(\mem_reg[4][16]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][17]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][17]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [17]),
        .Q(\mem_reg[4][17]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][18]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][18]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [18]),
        .Q(\mem_reg[4][18]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][19]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][19]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [19]),
        .Q(\mem_reg[4][19]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][1]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][1]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [1]),
        .Q(\mem_reg[4][1]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][20]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][20]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [20]),
        .Q(\mem_reg[4][20]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][21]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][21]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [21]),
        .Q(\mem_reg[4][21]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][22]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][22]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [22]),
        .Q(\mem_reg[4][22]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][23]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][23]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [23]),
        .Q(\mem_reg[4][23]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][24]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][24]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [24]),
        .Q(\mem_reg[4][24]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][25]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][25]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [25]),
        .Q(\mem_reg[4][25]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][26]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][26]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [26]),
        .Q(\mem_reg[4][26]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][27]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][27]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [27]),
        .Q(\mem_reg[4][27]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][28]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][28]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [28]),
        .Q(\mem_reg[4][28]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][29]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][29]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [29]),
        .Q(\mem_reg[4][29]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][2]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][2]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [2]),
        .Q(\mem_reg[4][2]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][32]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][32]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [30]),
        .Q(\mem_reg[4][32]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][33]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][33]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [31]),
        .Q(\mem_reg[4][33]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][34]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][34]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [32]),
        .Q(\mem_reg[4][34]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][35]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][35]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [33]),
        .Q(\mem_reg[4][35]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][36]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][36]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [34]),
        .Q(\mem_reg[4][36]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][37]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][37]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [35]),
        .Q(\mem_reg[4][37]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][38]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][38]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [36]),
        .Q(\mem_reg[4][38]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][39]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][39]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [37]),
        .Q(\mem_reg[4][39]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][3]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][3]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [3]),
        .Q(\mem_reg[4][3]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][40]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][40]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [38]),
        .Q(\mem_reg[4][40]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][41]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][41]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [39]),
        .Q(\mem_reg[4][41]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][42]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][42]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [40]),
        .Q(\mem_reg[4][42]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][43]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][43]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [41]),
        .Q(\mem_reg[4][43]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][44]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][44]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [42]),
        .Q(\mem_reg[4][44]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][45]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][45]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [43]),
        .Q(\mem_reg[4][45]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][46]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][46]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [44]),
        .Q(\mem_reg[4][46]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][47]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][47]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [45]),
        .Q(\mem_reg[4][47]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][48]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][48]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [46]),
        .Q(\mem_reg[4][48]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][49]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][49]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [47]),
        .Q(\mem_reg[4][49]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][4]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][4]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [4]),
        .Q(\mem_reg[4][4]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][50]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][50]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [48]),
        .Q(\mem_reg[4][50]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][51]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][51]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [49]),
        .Q(\mem_reg[4][51]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][52]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][52]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [50]),
        .Q(\mem_reg[4][52]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][53]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][53]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [51]),
        .Q(\mem_reg[4][53]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][54]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][54]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [52]),
        .Q(\mem_reg[4][54]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][55]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][55]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [53]),
        .Q(\mem_reg[4][55]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][56]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][56]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [54]),
        .Q(\mem_reg[4][56]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][57]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][57]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [55]),
        .Q(\mem_reg[4][57]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][58]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][58]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [56]),
        .Q(\mem_reg[4][58]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][59]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][59]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [57]),
        .Q(\mem_reg[4][59]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][5]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][5]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [5]),
        .Q(\mem_reg[4][5]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][60]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][60]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [58]),
        .Q(\mem_reg[4][60]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][61]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][61]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [59]),
        .Q(\mem_reg[4][61]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][62]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][62]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [60]),
        .Q(\mem_reg[4][62]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][63]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][63]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [61]),
        .Q(\mem_reg[4][63]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][6]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][6]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [6]),
        .Q(\mem_reg[4][6]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][7]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][7]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [7]),
        .Q(\mem_reg[4][7]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][8]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][8]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [8]),
        .Q(\mem_reg[4][8]_srl5_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][9]_srl5 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[4][9]_srl5 
       (.A0(\pout_reg_n_2_[0] ),
        .A1(\pout_reg_n_2_[1] ),
        .A2(\pout_reg_n_2_[2] ),
        .A3(1'b0),
        .CE(push),
        .CLK(ap_clk),
        .D(\q_reg[63]_0 [9]),
        .Q(\mem_reg[4][9]_srl5_n_2 ));
  LUT6 #(
    .INIT(64'h0FF0FFFFF00E0000)) 
    \pout[0]_i_1 
       (.I0(\pout_reg_n_2_[2] ),
        .I1(\pout_reg_n_2_[1] ),
        .I2(push),
        .I3(\pout[2]_i_2__1_n_2 ),
        .I4(data_vld_reg_n_2),
        .I5(\pout_reg_n_2_[0] ),
        .O(\pout[0]_i_1_n_2 ));
  LUT6 #(
    .INIT(64'h7F80FD027F80FD00)) 
    \pout[1]_i_1 
       (.I0(data_vld_reg_n_2),
        .I1(\pout[2]_i_2__1_n_2 ),
        .I2(push),
        .I3(\pout_reg_n_2_[1] ),
        .I4(\pout_reg_n_2_[0] ),
        .I5(\pout_reg_n_2_[2] ),
        .O(\pout[1]_i_1_n_2 ));
  LUT6 #(
    .INIT(64'h7FFFFFFD80000000)) 
    \pout[2]_i_1 
       (.I0(data_vld_reg_n_2),
        .I1(\pout[2]_i_2__1_n_2 ),
        .I2(push),
        .I3(\pout_reg_n_2_[1] ),
        .I4(\pout_reg_n_2_[0] ),
        .I5(\pout_reg_n_2_[2] ),
        .O(\pout[2]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair81" *) 
  LUT4 #(
    .INIT(16'h8808)) 
    \pout[2]_i_2__1 
       (.I0(fifo_rreq_valid),
        .I1(full_n_reg_1),
        .I2(CO),
        .I3(full_n_reg_0),
        .O(\pout[2]_i_2__1_n_2 ));
  FDRE \pout_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\pout[0]_i_1_n_2 ),
        .Q(\pout_reg_n_2_[0] ),
        .R(SR));
  FDRE \pout_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\pout[1]_i_1_n_2 ),
        .Q(\pout_reg_n_2_[1] ),
        .R(SR));
  FDRE \pout_reg[2] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\pout[2]_i_1_n_2 ),
        .Q(\pout_reg_n_2_[2] ),
        .R(SR));
  FDRE \q_reg[0] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][0]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [0]),
        .R(SR));
  FDRE \q_reg[10] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][10]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [10]),
        .R(SR));
  FDRE \q_reg[11] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][11]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [11]),
        .R(SR));
  FDRE \q_reg[12] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][12]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [12]),
        .R(SR));
  FDRE \q_reg[13] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][13]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [13]),
        .R(SR));
  FDRE \q_reg[14] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][14]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [14]),
        .R(SR));
  FDRE \q_reg[15] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][15]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [15]),
        .R(SR));
  FDRE \q_reg[16] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][16]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [16]),
        .R(SR));
  FDRE \q_reg[17] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][17]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [17]),
        .R(SR));
  FDRE \q_reg[18] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][18]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [18]),
        .R(SR));
  FDRE \q_reg[19] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][19]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [19]),
        .R(SR));
  FDRE \q_reg[1] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][1]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [1]),
        .R(SR));
  FDRE \q_reg[20] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][20]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [20]),
        .R(SR));
  FDRE \q_reg[21] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][21]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [21]),
        .R(SR));
  FDRE \q_reg[22] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][22]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [22]),
        .R(SR));
  FDRE \q_reg[23] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][23]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [23]),
        .R(SR));
  FDRE \q_reg[24] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][24]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [24]),
        .R(SR));
  FDRE \q_reg[25] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][25]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [25]),
        .R(SR));
  FDRE \q_reg[26] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][26]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [26]),
        .R(SR));
  FDRE \q_reg[27] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][27]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [27]),
        .R(SR));
  FDRE \q_reg[28] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][28]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [28]),
        .R(SR));
  FDRE \q_reg[29] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][29]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [29]),
        .R(SR));
  FDRE \q_reg[2] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][2]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [2]),
        .R(SR));
  FDRE \q_reg[32] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][32]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [30]),
        .R(SR));
  FDRE \q_reg[33] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][33]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [31]),
        .R(SR));
  FDRE \q_reg[34] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][34]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [32]),
        .R(SR));
  FDRE \q_reg[35] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][35]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [33]),
        .R(SR));
  FDRE \q_reg[36] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][36]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [34]),
        .R(SR));
  FDRE \q_reg[37] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][37]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [35]),
        .R(SR));
  FDRE \q_reg[38] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][38]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [36]),
        .R(SR));
  FDRE \q_reg[39] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][39]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [37]),
        .R(SR));
  FDRE \q_reg[3] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][3]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [3]),
        .R(SR));
  FDRE \q_reg[40] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][40]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [38]),
        .R(SR));
  FDRE \q_reg[41] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][41]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [39]),
        .R(SR));
  FDRE \q_reg[42] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][42]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [40]),
        .R(SR));
  FDRE \q_reg[43] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][43]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [41]),
        .R(SR));
  FDRE \q_reg[44] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][44]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [42]),
        .R(SR));
  FDRE \q_reg[45] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][45]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [43]),
        .R(SR));
  FDRE \q_reg[46] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][46]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [44]),
        .R(SR));
  FDRE \q_reg[47] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][47]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [45]),
        .R(SR));
  FDRE \q_reg[48] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][48]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [46]),
        .R(SR));
  FDRE \q_reg[49] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][49]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [47]),
        .R(SR));
  FDRE \q_reg[4] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][4]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [4]),
        .R(SR));
  FDRE \q_reg[50] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][50]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [48]),
        .R(SR));
  FDRE \q_reg[51] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][51]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [49]),
        .R(SR));
  FDRE \q_reg[52] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][52]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [50]),
        .R(SR));
  FDRE \q_reg[53] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][53]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [51]),
        .R(SR));
  FDRE \q_reg[54] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][54]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [52]),
        .R(SR));
  FDRE \q_reg[55] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][55]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [53]),
        .R(SR));
  FDRE \q_reg[56] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][56]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [54]),
        .R(SR));
  FDRE \q_reg[57] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][57]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [55]),
        .R(SR));
  FDRE \q_reg[58] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][58]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [56]),
        .R(SR));
  FDRE \q_reg[59] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][59]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [57]),
        .R(SR));
  FDRE \q_reg[5] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][5]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [5]),
        .R(SR));
  FDRE \q_reg[60] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][60]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [58]),
        .R(SR));
  FDRE \q_reg[61] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][61]_srl5_n_2 ),
        .Q(fifo_rreq_data[61]),
        .R(SR));
  FDRE \q_reg[62] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][62]_srl5_n_2 ),
        .Q(fifo_rreq_data[62]),
        .R(SR));
  FDRE \q_reg[63] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][63]_srl5_n_2 ),
        .Q(fifo_rreq_data[63]),
        .R(SR));
  FDRE \q_reg[6] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][6]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [6]),
        .R(SR));
  FDRE \q_reg[7] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][7]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [7]),
        .R(SR));
  FDRE \q_reg[8] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][8]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [8]),
        .R(SR));
  FDRE \q_reg[9] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[4][9]_srl5_n_2 ),
        .Q(\q_reg[60]_0 [9]),
        .R(SR));
  LUT5 #(
    .INIT(32'hFD550155)) 
    \sect_cnt[0]_i_1__0 
       (.I0(Q[0]),
        .I1(\sect_cnt_reg[0] ),
        .I2(fifo_rreq_valid),
        .I3(\sect_cnt_reg[0]_0 ),
        .I4(\sect_cnt_reg[19]_0 [0]),
        .O(D[0]));
  LUT5 #(
    .INIT(32'hFEAA02AA)) 
    \sect_cnt[10]_i_1__0 
       (.I0(\sect_cnt_reg[12] [1]),
        .I1(\sect_cnt_reg[0] ),
        .I2(fifo_rreq_valid),
        .I3(\sect_cnt_reg[0]_0 ),
        .I4(\sect_cnt_reg[19]_0 [10]),
        .O(D[10]));
  LUT5 #(
    .INIT(32'hFEAA02AA)) 
    \sect_cnt[11]_i_1__0 
       (.I0(\sect_cnt_reg[12] [2]),
        .I1(\sect_cnt_reg[0] ),
        .I2(fifo_rreq_valid),
        .I3(\sect_cnt_reg[0]_0 ),
        .I4(\sect_cnt_reg[19]_0 [11]),
        .O(D[11]));
  LUT5 #(
    .INIT(32'hFEAA02AA)) 
    \sect_cnt[12]_i_1__0 
       (.I0(\sect_cnt_reg[12] [3]),
        .I1(\sect_cnt_reg[0] ),
        .I2(fifo_rreq_valid),
        .I3(\sect_cnt_reg[0]_0 ),
        .I4(\sect_cnt_reg[19]_0 [12]),
        .O(D[12]));
  LUT5 #(
    .INIT(32'hFEAA02AA)) 
    \sect_cnt[13]_i_1__0 
       (.I0(\sect_cnt_reg[16] [0]),
        .I1(\sect_cnt_reg[0] ),
        .I2(fifo_rreq_valid),
        .I3(\sect_cnt_reg[0]_0 ),
        .I4(\sect_cnt_reg[19]_0 [13]),
        .O(D[13]));
  LUT5 #(
    .INIT(32'hFEAA02AA)) 
    \sect_cnt[14]_i_1__0 
       (.I0(\sect_cnt_reg[16] [1]),
        .I1(\sect_cnt_reg[0] ),
        .I2(fifo_rreq_valid),
        .I3(\sect_cnt_reg[0]_0 ),
        .I4(\sect_cnt_reg[19]_0 [14]),
        .O(D[14]));
  LUT5 #(
    .INIT(32'hFEAA02AA)) 
    \sect_cnt[15]_i_1__0 
       (.I0(\sect_cnt_reg[16] [2]),
        .I1(\sect_cnt_reg[0] ),
        .I2(fifo_rreq_valid),
        .I3(\sect_cnt_reg[0]_0 ),
        .I4(\sect_cnt_reg[19]_0 [15]),
        .O(D[15]));
  LUT5 #(
    .INIT(32'hFEAA02AA)) 
    \sect_cnt[16]_i_1__0 
       (.I0(\sect_cnt_reg[16] [3]),
        .I1(\sect_cnt_reg[0] ),
        .I2(fifo_rreq_valid),
        .I3(\sect_cnt_reg[0]_0 ),
        .I4(\sect_cnt_reg[19]_0 [16]),
        .O(D[16]));
  LUT5 #(
    .INIT(32'hFEAA02AA)) 
    \sect_cnt[17]_i_1__0 
       (.I0(\sect_cnt_reg[19]_1 [0]),
        .I1(\sect_cnt_reg[0] ),
        .I2(fifo_rreq_valid),
        .I3(\sect_cnt_reg[0]_0 ),
        .I4(\sect_cnt_reg[19]_0 [17]),
        .O(D[17]));
  LUT5 #(
    .INIT(32'hFEAA02AA)) 
    \sect_cnt[18]_i_1__0 
       (.I0(\sect_cnt_reg[19]_1 [1]),
        .I1(\sect_cnt_reg[0] ),
        .I2(fifo_rreq_valid),
        .I3(\sect_cnt_reg[0]_0 ),
        .I4(\sect_cnt_reg[19]_0 [18]),
        .O(D[18]));
  LUT5 #(
    .INIT(32'hFEAA02AA)) 
    \sect_cnt[19]_i_2__0 
       (.I0(\sect_cnt_reg[19]_1 [2]),
        .I1(\sect_cnt_reg[0] ),
        .I2(fifo_rreq_valid),
        .I3(\sect_cnt_reg[0]_0 ),
        .I4(\sect_cnt_reg[19]_0 [19]),
        .O(D[19]));
  LUT5 #(
    .INIT(32'hFEAA02AA)) 
    \sect_cnt[1]_i_1__0 
       (.I0(O[0]),
        .I1(\sect_cnt_reg[0] ),
        .I2(fifo_rreq_valid),
        .I3(\sect_cnt_reg[0]_0 ),
        .I4(\sect_cnt_reg[19]_0 [1]),
        .O(D[1]));
  LUT5 #(
    .INIT(32'hFEAA02AA)) 
    \sect_cnt[2]_i_1__0 
       (.I0(O[1]),
        .I1(\sect_cnt_reg[0] ),
        .I2(fifo_rreq_valid),
        .I3(\sect_cnt_reg[0]_0 ),
        .I4(\sect_cnt_reg[19]_0 [2]),
        .O(D[2]));
  LUT5 #(
    .INIT(32'hFEAA02AA)) 
    \sect_cnt[3]_i_1__0 
       (.I0(O[2]),
        .I1(\sect_cnt_reg[0] ),
        .I2(fifo_rreq_valid),
        .I3(\sect_cnt_reg[0]_0 ),
        .I4(\sect_cnt_reg[19]_0 [3]),
        .O(D[3]));
  (* SOFT_HLUTNM = "soft_lutpair80" *) 
  LUT5 #(
    .INIT(32'hFEAA02AA)) 
    \sect_cnt[4]_i_1__0 
       (.I0(O[3]),
        .I1(\sect_cnt_reg[0] ),
        .I2(fifo_rreq_valid),
        .I3(\sect_cnt_reg[0]_0 ),
        .I4(\sect_cnt_reg[19]_0 [4]),
        .O(D[4]));
  LUT5 #(
    .INIT(32'hFEAA02AA)) 
    \sect_cnt[5]_i_1__0 
       (.I0(\sect_cnt_reg[8] [0]),
        .I1(\sect_cnt_reg[0] ),
        .I2(fifo_rreq_valid),
        .I3(\sect_cnt_reg[0]_0 ),
        .I4(\sect_cnt_reg[19]_0 [5]),
        .O(D[5]));
  LUT5 #(
    .INIT(32'hFEAA02AA)) 
    \sect_cnt[6]_i_1__0 
       (.I0(\sect_cnt_reg[8] [1]),
        .I1(\sect_cnt_reg[0] ),
        .I2(fifo_rreq_valid),
        .I3(\sect_cnt_reg[0]_0 ),
        .I4(\sect_cnt_reg[19]_0 [6]),
        .O(D[6]));
  LUT5 #(
    .INIT(32'hFEAA02AA)) 
    \sect_cnt[7]_i_1__0 
       (.I0(\sect_cnt_reg[8] [2]),
        .I1(\sect_cnt_reg[0] ),
        .I2(fifo_rreq_valid),
        .I3(\sect_cnt_reg[0]_0 ),
        .I4(\sect_cnt_reg[19]_0 [7]),
        .O(D[7]));
  LUT5 #(
    .INIT(32'hFEAA02AA)) 
    \sect_cnt[8]_i_1__0 
       (.I0(\sect_cnt_reg[8] [3]),
        .I1(\sect_cnt_reg[0] ),
        .I2(fifo_rreq_valid),
        .I3(\sect_cnt_reg[0]_0 ),
        .I4(\sect_cnt_reg[19]_0 [8]),
        .O(D[8]));
  LUT5 #(
    .INIT(32'hFEAA02AA)) 
    \sect_cnt[9]_i_1__0 
       (.I0(\sect_cnt_reg[12] [0]),
        .I1(\sect_cnt_reg[0] ),
        .I2(fifo_rreq_valid),
        .I3(\sect_cnt_reg[0]_0 ),
        .I4(\sect_cnt_reg[19]_0 [9]),
        .O(D[9]));
endmodule

(* ORIG_REF_NAME = "simple_accel_core_gmem_m_axi_fifo" *) 
module design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo__parameterized1
   (fifo_resp_ready,
    next_resp0,
    push,
    ap_clk,
    SR,
    push_0,
    next_resp,
    ap_rst_n,
    \q_reg[1]_0 ,
    \q_reg[1]_1 ,
    m_axi_gmem_BVALID,
    next_resp_reg,
    in);
  output fifo_resp_ready;
  output next_resp0;
  output push;
  input ap_clk;
  input [0:0]SR;
  input push_0;
  input next_resp;
  input ap_rst_n;
  input \q_reg[1]_0 ;
  input \q_reg[1]_1 ;
  input m_axi_gmem_BVALID;
  input next_resp_reg;
  input [0:0]in;

  wire [0:0]SR;
  wire ap_clk;
  wire ap_rst_n;
  wire [1:1]aw2b_awdata;
  wire [1:0]aw2b_bdata;
  wire data_vld_i_1__1_n_2;
  wire data_vld_reg_n_2;
  wire empty_n_i_1__4_n_2;
  wire fifo_resp_ready;
  wire full_n_i_1__3_n_2;
  wire full_n_i_2__3_n_2;
  wire full_n_i_3_n_2;
  wire [0:0]in;
  wire m_axi_gmem_BVALID;
  wire \mem_reg[14][0]_srl15_n_2 ;
  wire \mem_reg[14][1]_srl15_n_2 ;
  wire need_wrsp;
  wire next_resp;
  wire next_resp0;
  wire next_resp_reg;
  wire pop0;
  wire \pout[0]_i_1_n_2 ;
  wire \pout[1]_i_1__0_n_2 ;
  wire \pout[2]_i_1_n_2 ;
  wire \pout[3]_i_1_n_2 ;
  wire \pout[3]_i_2_n_2 ;
  wire \pout[3]_i_3_n_2 ;
  wire \pout[3]_i_4_n_2 ;
  wire [3:0]pout_reg__0;
  wire push;
  wire push_0;
  wire \q_reg[1]_0 ;
  wire \q_reg[1]_1 ;

  (* SOFT_HLUTNM = "soft_lutpair164" *) 
  LUT5 #(
    .INIT(32'hAEAAEEEE)) 
    data_vld_i_1__1
       (.I0(push_0),
        .I1(data_vld_reg_n_2),
        .I2(next_resp),
        .I3(need_wrsp),
        .I4(\pout[3]_i_3_n_2 ),
        .O(data_vld_i_1__1_n_2));
  FDRE data_vld_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(data_vld_i_1__1_n_2),
        .Q(data_vld_reg_n_2),
        .R(SR));
  LUT3 #(
    .INIT(8'hBA)) 
    empty_n_i_1__4
       (.I0(data_vld_reg_n_2),
        .I1(next_resp),
        .I2(need_wrsp),
        .O(empty_n_i_1__4_n_2));
  FDRE empty_n_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(empty_n_i_1__4_n_2),
        .Q(need_wrsp),
        .R(SR));
  LUT6 #(
    .INIT(64'hD5DDDDDDFFFFDDDD)) 
    full_n_i_1__3
       (.I0(ap_rst_n),
        .I1(fifo_resp_ready),
        .I2(full_n_i_2__3_n_2),
        .I3(push_0),
        .I4(data_vld_reg_n_2),
        .I5(full_n_i_3_n_2),
        .O(full_n_i_1__3_n_2));
  (* SOFT_HLUTNM = "soft_lutpair165" *) 
  LUT4 #(
    .INIT(16'hFF7F)) 
    full_n_i_2__3
       (.I0(pout_reg__0[2]),
        .I1(pout_reg__0[3]),
        .I2(pout_reg__0[0]),
        .I3(pout_reg__0[1]),
        .O(full_n_i_2__3_n_2));
  (* SOFT_HLUTNM = "soft_lutpair162" *) 
  LUT2 #(
    .INIT(4'h2)) 
    full_n_i_3
       (.I0(need_wrsp),
        .I1(next_resp),
        .O(full_n_i_3_n_2));
  FDRE full_n_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(full_n_i_1__3_n_2),
        .Q(fifo_resp_ready),
        .R(1'b0));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_resp/mem_reg[14] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_resp/mem_reg[14][0]_srl15 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[14][0]_srl15 
       (.A0(pout_reg__0[0]),
        .A1(pout_reg__0[1]),
        .A2(pout_reg__0[2]),
        .A3(pout_reg__0[3]),
        .CE(push_0),
        .CLK(ap_clk),
        .D(in),
        .Q(\mem_reg[14][0]_srl15_n_2 ));
  (* srl_bus_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_resp/mem_reg[14] " *) 
  (* srl_name = "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_resp/mem_reg[14][1]_srl15 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \mem_reg[14][1]_srl15 
       (.A0(pout_reg__0[0]),
        .A1(pout_reg__0[1]),
        .A2(pout_reg__0[2]),
        .A3(pout_reg__0[3]),
        .CE(push_0),
        .CLK(ap_clk),
        .D(aw2b_awdata),
        .Q(\mem_reg[14][1]_srl15_n_2 ));
  LUT2 #(
    .INIT(4'h2)) 
    \mem_reg[14][1]_srl15_i_1 
       (.I0(\q_reg[1]_0 ),
        .I1(\q_reg[1]_1 ),
        .O(aw2b_awdata));
  LUT5 #(
    .INIT(32'h88F88888)) 
    next_resp_i_1
       (.I0(m_axi_gmem_BVALID),
        .I1(next_resp_reg),
        .I2(need_wrsp),
        .I3(next_resp),
        .I4(aw2b_bdata[0]),
        .O(next_resp0));
  LUT1 #(
    .INIT(2'h1)) 
    \pout[0]_i_1 
       (.I0(pout_reg__0[0]),
        .O(\pout[0]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair162" *) 
  LUT5 #(
    .INIT(32'hBF4040BF)) 
    \pout[1]_i_1__0 
       (.I0(next_resp),
        .I1(need_wrsp),
        .I2(push_0),
        .I3(pout_reg__0[1]),
        .I4(pout_reg__0[0]),
        .O(\pout[1]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair163" *) 
  LUT4 #(
    .INIT(16'h7E81)) 
    \pout[2]_i_1 
       (.I0(pout_reg__0[0]),
        .I1(pout_reg__0[1]),
        .I2(\pout[3]_i_4_n_2 ),
        .I3(pout_reg__0[2]),
        .O(\pout[2]_i_1_n_2 ));
  LUT5 #(
    .INIT(32'hE0000000)) 
    \pout[2]_i_2__0 
       (.I0(aw2b_bdata[0]),
        .I1(aw2b_bdata[1]),
        .I2(need_wrsp),
        .I3(next_resp_reg),
        .I4(next_resp),
        .O(push));
  LUT5 #(
    .INIT(32'h08005900)) 
    \pout[3]_i_1 
       (.I0(push_0),
        .I1(need_wrsp),
        .I2(next_resp),
        .I3(data_vld_reg_n_2),
        .I4(\pout[3]_i_3_n_2 ),
        .O(\pout[3]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair163" *) 
  LUT5 #(
    .INIT(32'h6AAAAAA9)) 
    \pout[3]_i_2 
       (.I0(pout_reg__0[3]),
        .I1(pout_reg__0[0]),
        .I2(pout_reg__0[1]),
        .I3(\pout[3]_i_4_n_2 ),
        .I4(pout_reg__0[2]),
        .O(\pout[3]_i_2_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair165" *) 
  LUT4 #(
    .INIT(16'h0001)) 
    \pout[3]_i_3 
       (.I0(pout_reg__0[2]),
        .I1(pout_reg__0[3]),
        .I2(pout_reg__0[1]),
        .I3(pout_reg__0[0]),
        .O(\pout[3]_i_3_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair164" *) 
  LUT4 #(
    .INIT(16'h0080)) 
    \pout[3]_i_4 
       (.I0(push_0),
        .I1(data_vld_reg_n_2),
        .I2(need_wrsp),
        .I3(next_resp),
        .O(\pout[3]_i_4_n_2 ));
  FDRE \pout_reg[0] 
       (.C(ap_clk),
        .CE(\pout[3]_i_1_n_2 ),
        .D(\pout[0]_i_1_n_2 ),
        .Q(pout_reg__0[0]),
        .R(SR));
  FDRE \pout_reg[1] 
       (.C(ap_clk),
        .CE(\pout[3]_i_1_n_2 ),
        .D(\pout[1]_i_1__0_n_2 ),
        .Q(pout_reg__0[1]),
        .R(SR));
  FDRE \pout_reg[2] 
       (.C(ap_clk),
        .CE(\pout[3]_i_1_n_2 ),
        .D(\pout[2]_i_1_n_2 ),
        .Q(pout_reg__0[2]),
        .R(SR));
  FDRE \pout_reg[3] 
       (.C(ap_clk),
        .CE(\pout[3]_i_1_n_2 ),
        .D(\pout[3]_i_2_n_2 ),
        .Q(pout_reg__0[3]),
        .R(SR));
  LUT2 #(
    .INIT(4'hB)) 
    \q[1]_i_1 
       (.I0(next_resp),
        .I1(need_wrsp),
        .O(pop0));
  FDRE \q_reg[0] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[14][0]_srl15_n_2 ),
        .Q(aw2b_bdata[0]),
        .R(SR));
  FDRE \q_reg[1] 
       (.C(ap_clk),
        .CE(pop0),
        .D(\mem_reg[14][1]_srl15_n_2 ),
        .Q(aw2b_bdata[1]),
        .R(SR));
endmodule

(* ORIG_REF_NAME = "simple_accel_core_gmem_m_axi_fifo" *) 
module design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo__parameterized1_0
   (invalid_len_event_reg2_reg,
    E,
    rreq_handling_reg,
    \could_multi_bursts.sect_handling_reg ,
    \could_multi_bursts.sect_handling_reg_0 ,
    ap_rst_n_0,
    push,
    rreq_handling_reg_0,
    rreq_handling_reg_1,
    \could_multi_bursts.sect_handling_reg_1 ,
    ap_rst_n_1,
    \could_multi_bursts.sect_handling_reg_2 ,
    \end_addr_buf_reg[2] ,
    \beat_len_buf_reg[1] ,
    \beat_len_buf_reg[2] ,
    \start_addr_buf_reg[5] ,
    \beat_len_buf_reg[4] ,
    \beat_len_buf_reg[5] ,
    \end_addr_buf_reg[8] ,
    \start_addr_buf_reg[9] ,
    \end_addr_buf_reg[10] ,
    \beat_len_buf_reg[9] ,
    \could_multi_bursts.sect_handling_reg_3 ,
    \could_multi_bursts.sect_handling_reg_4 ,
    \could_multi_bursts.sect_handling_reg_5 ,
    \could_multi_bursts.sect_handling_reg_6 ,
    \could_multi_bursts.sect_handling_reg_7 ,
    ap_clk,
    SR,
    invalid_len_event_reg2,
    \could_multi_bursts.sect_handling_reg_8 ,
    m_axi_gmem_ARREADY,
    \could_multi_bursts.ARVALID_Dummy_reg ,
    ap_rst_n,
    fifo_rreq_valid,
    rreq_handling_reg_2,
    rreq_handling_reg_3,
    rreq_handling_reg_4,
    data_vld_reg_0,
    next_beat,
    rreq_handling_reg_5,
    beat_valid,
    empty_n_reg_0,
    rdata_ack_t,
    invalid_len_event,
    CO,
    \sect_addr_buf_reg[2] ,
    Q,
    \sect_len_buf_reg[9] ,
    \sect_len_buf_reg[9]_0 ,
    \could_multi_bursts.arlen_buf_reg[0] ,
    \could_multi_bursts.arlen_buf_reg[3] );
  output invalid_len_event_reg2_reg;
  output [0:0]E;
  output rreq_handling_reg;
  output [0:0]\could_multi_bursts.sect_handling_reg ;
  output \could_multi_bursts.sect_handling_reg_0 ;
  output [0:0]ap_rst_n_0;
  output push;
  output [0:0]rreq_handling_reg_0;
  output rreq_handling_reg_1;
  output \could_multi_bursts.sect_handling_reg_1 ;
  output [0:0]ap_rst_n_1;
  output \could_multi_bursts.sect_handling_reg_2 ;
  output \end_addr_buf_reg[2] ;
  output \beat_len_buf_reg[1] ;
  output \beat_len_buf_reg[2] ;
  output \start_addr_buf_reg[5] ;
  output \beat_len_buf_reg[4] ;
  output \beat_len_buf_reg[5] ;
  output \end_addr_buf_reg[8] ;
  output \start_addr_buf_reg[9] ;
  output \end_addr_buf_reg[10] ;
  output \beat_len_buf_reg[9] ;
  output \could_multi_bursts.sect_handling_reg_3 ;
  output \could_multi_bursts.sect_handling_reg_4 ;
  output \could_multi_bursts.sect_handling_reg_5 ;
  output \could_multi_bursts.sect_handling_reg_6 ;
  output \could_multi_bursts.sect_handling_reg_7 ;
  input ap_clk;
  input [0:0]SR;
  input invalid_len_event_reg2;
  input \could_multi_bursts.sect_handling_reg_8 ;
  input m_axi_gmem_ARREADY;
  input \could_multi_bursts.ARVALID_Dummy_reg ;
  input ap_rst_n;
  input fifo_rreq_valid;
  input rreq_handling_reg_2;
  input rreq_handling_reg_3;
  input rreq_handling_reg_4;
  input [0:0]data_vld_reg_0;
  input next_beat;
  input rreq_handling_reg_5;
  input beat_valid;
  input empty_n_reg_0;
  input rdata_ack_t;
  input invalid_len_event;
  input [0:0]CO;
  input [0:0]\sect_addr_buf_reg[2] ;
  input [9:0]Q;
  input [9:0]\sect_len_buf_reg[9] ;
  input [9:0]\sect_len_buf_reg[9]_0 ;
  input \could_multi_bursts.arlen_buf_reg[0] ;
  input [3:0]\could_multi_bursts.arlen_buf_reg[3] ;

  wire [0:0]CO;
  wire [0:0]E;
  wire [9:0]Q;
  wire [0:0]SR;
  wire ap_clk;
  wire ap_rst_n;
  wire [0:0]ap_rst_n_0;
  wire [0:0]ap_rst_n_1;
  wire \beat_len_buf_reg[1] ;
  wire \beat_len_buf_reg[2] ;
  wire \beat_len_buf_reg[4] ;
  wire \beat_len_buf_reg[5] ;
  wire \beat_len_buf_reg[9] ;
  wire beat_valid;
  wire \could_multi_bursts.ARVALID_Dummy_reg ;
  wire \could_multi_bursts.arlen_buf_reg[0] ;
  wire [3:0]\could_multi_bursts.arlen_buf_reg[3] ;
  wire \could_multi_bursts.sect_handling_i_2_n_2 ;
  wire [0:0]\could_multi_bursts.sect_handling_reg ;
  wire \could_multi_bursts.sect_handling_reg_0 ;
  wire \could_multi_bursts.sect_handling_reg_1 ;
  wire \could_multi_bursts.sect_handling_reg_2 ;
  wire \could_multi_bursts.sect_handling_reg_3 ;
  wire \could_multi_bursts.sect_handling_reg_4 ;
  wire \could_multi_bursts.sect_handling_reg_5 ;
  wire \could_multi_bursts.sect_handling_reg_6 ;
  wire \could_multi_bursts.sect_handling_reg_7 ;
  wire \could_multi_bursts.sect_handling_reg_8 ;
  wire data_vld_i_1__4_n_2;
  wire [0:0]data_vld_reg_0;
  wire data_vld_reg_n_2;
  wire empty_n_i_1__3_n_2;
  wire empty_n_reg_0;
  wire empty_n_reg_n_2;
  wire \end_addr_buf_reg[10] ;
  wire \end_addr_buf_reg[2] ;
  wire \end_addr_buf_reg[8] ;
  wire fifo_rctl_ready;
  wire fifo_rreq_valid;
  wire full_n_i_1__6_n_2;
  wire full_n_i_2__6_n_2;
  wire invalid_len_event;
  wire invalid_len_event_reg2;
  wire invalid_len_event_reg2_reg;
  wire m_axi_gmem_ARREADY;
  wire next_beat;
  wire \pout[0]_i_1__0_n_2 ;
  wire \pout[1]_i_1_n_2 ;
  wire \pout[2]_i_1__0_n_2 ;
  wire \pout[3]_i_1__0_n_2 ;
  wire \pout[3]_i_2__0_n_2 ;
  wire \pout[3]_i_3__0_n_2 ;
  wire \pout[3]_i_4__0_n_2 ;
  wire [3:0]pout_reg__0;
  wire push;
  wire rdata_ack_t;
  wire rreq_handling_reg;
  wire [0:0]rreq_handling_reg_0;
  wire rreq_handling_reg_1;
  wire rreq_handling_reg_2;
  wire rreq_handling_reg_3;
  wire rreq_handling_reg_4;
  wire rreq_handling_reg_5;
  wire [0:0]\sect_addr_buf_reg[2] ;
  wire [9:0]\sect_len_buf_reg[9] ;
  wire [9:0]\sect_len_buf_reg[9]_0 ;
  wire \start_addr_buf_reg[5] ;
  wire \start_addr_buf_reg[9] ;

  LUT6 #(
    .INIT(64'h40FF404000000000)) 
    \could_multi_bursts.ARVALID_Dummy_i_1 
       (.I0(invalid_len_event_reg2),
        .I1(\could_multi_bursts.sect_handling_reg_8 ),
        .I2(fifo_rctl_ready),
        .I3(m_axi_gmem_ARREADY),
        .I4(\could_multi_bursts.ARVALID_Dummy_reg ),
        .I5(ap_rst_n),
        .O(invalid_len_event_reg2_reg));
  (* SOFT_HLUTNM = "soft_lutpair75" *) 
  LUT4 #(
    .INIT(16'hD000)) 
    \could_multi_bursts.araddr_buf[31]_i_1 
       (.I0(\could_multi_bursts.ARVALID_Dummy_reg ),
        .I1(m_axi_gmem_ARREADY),
        .I2(fifo_rctl_ready),
        .I3(\could_multi_bursts.sect_handling_reg_8 ),
        .O(push));
  LUT6 #(
    .INIT(64'hFFFFFFFF80880000)) 
    \could_multi_bursts.arlen_buf[0]_i_1 
       (.I0(\could_multi_bursts.sect_handling_reg_8 ),
        .I1(fifo_rctl_ready),
        .I2(m_axi_gmem_ARREADY),
        .I3(\could_multi_bursts.ARVALID_Dummy_reg ),
        .I4(\could_multi_bursts.arlen_buf_reg[0] ),
        .I5(\could_multi_bursts.arlen_buf_reg[3] [0]),
        .O(\could_multi_bursts.sect_handling_reg_3 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF80880000)) 
    \could_multi_bursts.arlen_buf[1]_i_1 
       (.I0(\could_multi_bursts.sect_handling_reg_8 ),
        .I1(fifo_rctl_ready),
        .I2(m_axi_gmem_ARREADY),
        .I3(\could_multi_bursts.ARVALID_Dummy_reg ),
        .I4(\could_multi_bursts.arlen_buf_reg[0] ),
        .I5(\could_multi_bursts.arlen_buf_reg[3] [1]),
        .O(\could_multi_bursts.sect_handling_reg_4 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF80880000)) 
    \could_multi_bursts.arlen_buf[2]_i_1 
       (.I0(\could_multi_bursts.sect_handling_reg_8 ),
        .I1(fifo_rctl_ready),
        .I2(m_axi_gmem_ARREADY),
        .I3(\could_multi_bursts.ARVALID_Dummy_reg ),
        .I4(\could_multi_bursts.arlen_buf_reg[0] ),
        .I5(\could_multi_bursts.arlen_buf_reg[3] [2]),
        .O(\could_multi_bursts.sect_handling_reg_5 ));
  (* SOFT_HLUTNM = "soft_lutpair75" *) 
  LUT4 #(
    .INIT(16'h8088)) 
    \could_multi_bursts.arlen_buf[3]_i_1 
       (.I0(\could_multi_bursts.sect_handling_reg_8 ),
        .I1(fifo_rctl_ready),
        .I2(m_axi_gmem_ARREADY),
        .I3(\could_multi_bursts.ARVALID_Dummy_reg ),
        .O(\could_multi_bursts.sect_handling_reg_6 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF80880000)) 
    \could_multi_bursts.arlen_buf[3]_i_2 
       (.I0(\could_multi_bursts.sect_handling_reg_8 ),
        .I1(fifo_rctl_ready),
        .I2(m_axi_gmem_ARREADY),
        .I3(\could_multi_bursts.ARVALID_Dummy_reg ),
        .I4(\could_multi_bursts.arlen_buf_reg[0] ),
        .I5(\could_multi_bursts.arlen_buf_reg[3] [3]),
        .O(\could_multi_bursts.sect_handling_reg_7 ));
  (* SOFT_HLUTNM = "soft_lutpair78" *) 
  LUT2 #(
    .INIT(4'h7)) 
    \could_multi_bursts.loop_cnt[5]_i_1 
       (.I0(ap_rst_n),
        .I1(\could_multi_bursts.sect_handling_reg_0 ),
        .O(ap_rst_n_0));
  LUT3 #(
    .INIT(8'hCE)) 
    \could_multi_bursts.sect_handling_i_1__0 
       (.I0(\could_multi_bursts.sect_handling_reg_8 ),
        .I1(rreq_handling_reg_5),
        .I2(\could_multi_bursts.sect_handling_i_2_n_2 ),
        .O(\could_multi_bursts.sect_handling_reg_1 ));
  LUT6 #(
    .INIT(64'h0000000000008088)) 
    \could_multi_bursts.sect_handling_i_2 
       (.I0(\could_multi_bursts.sect_handling_reg_8 ),
        .I1(fifo_rctl_ready),
        .I2(m_axi_gmem_ARREADY),
        .I3(\could_multi_bursts.ARVALID_Dummy_reg ),
        .I4(rreq_handling_reg_3),
        .I5(rreq_handling_reg_4),
        .O(\could_multi_bursts.sect_handling_i_2_n_2 ));
  LUT6 #(
    .INIT(64'hBAFAFAFABABABABA)) 
    data_vld_i_1__4
       (.I0(push),
        .I1(\pout[3]_i_3__0_n_2 ),
        .I2(data_vld_reg_n_2),
        .I3(data_vld_reg_0),
        .I4(next_beat),
        .I5(empty_n_reg_n_2),
        .O(data_vld_i_1__4_n_2));
  FDRE data_vld_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(data_vld_i_1__4_n_2),
        .Q(data_vld_reg_n_2),
        .R(SR));
  LUT6 #(
    .INIT(64'hFFFFFFFF22A2AAAA)) 
    empty_n_i_1__3
       (.I0(empty_n_reg_n_2),
        .I1(beat_valid),
        .I2(empty_n_reg_0),
        .I3(rdata_ack_t),
        .I4(data_vld_reg_0),
        .I5(data_vld_reg_n_2),
        .O(empty_n_i_1__3_n_2));
  FDRE empty_n_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(empty_n_i_1__3_n_2),
        .Q(empty_n_reg_n_2),
        .R(SR));
  (* SOFT_HLUTNM = "soft_lutpair77" *) 
  LUT3 #(
    .INIT(8'hA8)) 
    fifo_rreq_valid_buf_i_1
       (.I0(rreq_handling_reg),
        .I1(fifo_rreq_valid),
        .I2(rreq_handling_reg_2),
        .O(E));
  (* SOFT_HLUTNM = "soft_lutpair73" *) 
  LUT3 #(
    .INIT(8'h4F)) 
    fifo_rreq_valid_buf_i_2
       (.I0(\could_multi_bursts.sect_handling_reg_0 ),
        .I1(CO),
        .I2(rreq_handling_reg_5),
        .O(rreq_handling_reg));
  LUT6 #(
    .INIT(64'hFFFFFFFFD500FFFF)) 
    full_n_i_1__6
       (.I0(empty_n_reg_n_2),
        .I1(next_beat),
        .I2(data_vld_reg_0),
        .I3(data_vld_reg_n_2),
        .I4(ap_rst_n),
        .I5(full_n_i_2__6_n_2),
        .O(full_n_i_1__6_n_2));
  LUT6 #(
    .INIT(64'hAAAA2AAAAAAAAAAA)) 
    full_n_i_2__6
       (.I0(fifo_rctl_ready),
        .I1(pout_reg__0[2]),
        .I2(pout_reg__0[3]),
        .I3(pout_reg__0[0]),
        .I4(pout_reg__0[1]),
        .I5(\pout[3]_i_4__0_n_2 ),
        .O(full_n_i_2__6_n_2));
  FDRE full_n_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(full_n_i_1__6_n_2),
        .Q(fifo_rctl_ready),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair79" *) 
  LUT1 #(
    .INIT(2'h1)) 
    invalid_len_event_reg2_i_1
       (.I0(\could_multi_bursts.sect_handling_reg_0 ),
        .O(\could_multi_bursts.sect_handling_reg ));
  LUT1 #(
    .INIT(2'h1)) 
    \pout[0]_i_1__0 
       (.I0(pout_reg__0[0]),
        .O(\pout[0]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair76" *) 
  LUT3 #(
    .INIT(8'h69)) 
    \pout[1]_i_1 
       (.I0(\pout[3]_i_4__0_n_2 ),
        .I1(pout_reg__0[1]),
        .I2(pout_reg__0[0]),
        .O(\pout[1]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair76" *) 
  LUT4 #(
    .INIT(16'h6AA9)) 
    \pout[2]_i_1__0 
       (.I0(pout_reg__0[2]),
        .I1(\pout[3]_i_4__0_n_2 ),
        .I2(pout_reg__0[1]),
        .I3(pout_reg__0[0]),
        .O(\pout[2]_i_1__0_n_2 ));
  LUT6 #(
    .INIT(64'h10A0A0A010101010)) 
    \pout[3]_i_1__0 
       (.I0(push),
        .I1(\pout[3]_i_3__0_n_2 ),
        .I2(data_vld_reg_n_2),
        .I3(data_vld_reg_0),
        .I4(next_beat),
        .I5(empty_n_reg_n_2),
        .O(\pout[3]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair74" *) 
  LUT5 #(
    .INIT(32'h6AAAAAA9)) 
    \pout[3]_i_2__0 
       (.I0(pout_reg__0[3]),
        .I1(pout_reg__0[2]),
        .I2(pout_reg__0[0]),
        .I3(pout_reg__0[1]),
        .I4(\pout[3]_i_4__0_n_2 ),
        .O(\pout[3]_i_2__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair74" *) 
  LUT4 #(
    .INIT(16'h0001)) 
    \pout[3]_i_3__0 
       (.I0(pout_reg__0[2]),
        .I1(pout_reg__0[3]),
        .I2(pout_reg__0[1]),
        .I3(pout_reg__0[0]),
        .O(\pout[3]_i_3__0_n_2 ));
  LUT5 #(
    .INIT(32'h70000000)) 
    \pout[3]_i_4__0 
       (.I0(data_vld_reg_0),
        .I1(next_beat),
        .I2(empty_n_reg_n_2),
        .I3(push),
        .I4(data_vld_reg_n_2),
        .O(\pout[3]_i_4__0_n_2 ));
  FDRE \pout_reg[0] 
       (.C(ap_clk),
        .CE(\pout[3]_i_1__0_n_2 ),
        .D(\pout[0]_i_1__0_n_2 ),
        .Q(pout_reg__0[0]),
        .R(SR));
  FDRE \pout_reg[1] 
       (.C(ap_clk),
        .CE(\pout[3]_i_1__0_n_2 ),
        .D(\pout[1]_i_1_n_2 ),
        .Q(pout_reg__0[1]),
        .R(SR));
  FDRE \pout_reg[2] 
       (.C(ap_clk),
        .CE(\pout[3]_i_1__0_n_2 ),
        .D(\pout[2]_i_1__0_n_2 ),
        .Q(pout_reg__0[2]),
        .R(SR));
  FDRE \pout_reg[3] 
       (.C(ap_clk),
        .CE(\pout[3]_i_1__0_n_2 ),
        .D(\pout[3]_i_2__0_n_2 ),
        .Q(pout_reg__0[3]),
        .R(SR));
  (* SOFT_HLUTNM = "soft_lutpair73" *) 
  LUT5 #(
    .INIT(32'hAEAE0CAE)) 
    rreq_handling_i_1
       (.I0(rreq_handling_reg_5),
        .I1(rreq_handling_reg_2),
        .I2(invalid_len_event),
        .I3(CO),
        .I4(\could_multi_bursts.sect_handling_reg_0 ),
        .O(rreq_handling_reg_1));
  (* SOFT_HLUTNM = "soft_lutpair78" *) 
  LUT3 #(
    .INIT(8'h1F)) 
    \sect_addr_buf[11]_i_1__0 
       (.I0(\could_multi_bursts.sect_handling_reg_0 ),
        .I1(\sect_addr_buf_reg[2] ),
        .I2(ap_rst_n),
        .O(ap_rst_n_1));
  (* SOFT_HLUTNM = "soft_lutpair77" *) 
  LUT4 #(
    .INIT(16'h7775)) 
    \sect_cnt[19]_i_1__0 
       (.I0(\could_multi_bursts.sect_handling_reg_0 ),
        .I1(rreq_handling_reg_5),
        .I2(fifo_rreq_valid),
        .I3(rreq_handling_reg_2),
        .O(rreq_handling_reg_0));
  LUT5 #(
    .INIT(32'hFD00FFFF)) 
    \sect_cnt[19]_i_3 
       (.I0(push),
        .I1(rreq_handling_reg_3),
        .I2(rreq_handling_reg_4),
        .I3(\could_multi_bursts.sect_handling_reg_8 ),
        .I4(rreq_handling_reg_5),
        .O(\could_multi_bursts.sect_handling_reg_0 ));
  LUT6 #(
    .INIT(64'hF3C13301FFCD3F0D)) 
    \sect_len_buf[0]_i_1 
       (.I0(\could_multi_bursts.sect_handling_reg_0 ),
        .I1(\sect_addr_buf_reg[2] ),
        .I2(CO),
        .I3(Q[0]),
        .I4(\sect_len_buf_reg[9] [0]),
        .I5(\sect_len_buf_reg[9]_0 [0]),
        .O(\end_addr_buf_reg[2] ));
  LUT6 #(
    .INIT(64'hF333C101FF3FCD0D)) 
    \sect_len_buf[1]_i_1 
       (.I0(\could_multi_bursts.sect_handling_reg_0 ),
        .I1(\sect_addr_buf_reg[2] ),
        .I2(CO),
        .I3(\sect_len_buf_reg[9] [1]),
        .I4(Q[1]),
        .I5(\sect_len_buf_reg[9]_0 [1]),
        .O(\beat_len_buf_reg[1] ));
  LUT6 #(
    .INIT(64'hF333C101FF3FCD0D)) 
    \sect_len_buf[2]_i_1 
       (.I0(\could_multi_bursts.sect_handling_reg_0 ),
        .I1(\sect_addr_buf_reg[2] ),
        .I2(CO),
        .I3(\sect_len_buf_reg[9] [2]),
        .I4(Q[2]),
        .I5(\sect_len_buf_reg[9]_0 [2]),
        .O(\beat_len_buf_reg[2] ));
  LUT6 #(
    .INIT(64'hF3FFC1CD333F010D)) 
    \sect_len_buf[3]_i_1 
       (.I0(\could_multi_bursts.sect_handling_reg_0 ),
        .I1(\sect_addr_buf_reg[2] ),
        .I2(CO),
        .I3(\sect_len_buf_reg[9]_0 [3]),
        .I4(Q[3]),
        .I5(\sect_len_buf_reg[9] [3]),
        .O(\start_addr_buf_reg[5] ));
  LUT6 #(
    .INIT(64'hF333C101FF3FCD0D)) 
    \sect_len_buf[4]_i_1 
       (.I0(\could_multi_bursts.sect_handling_reg_0 ),
        .I1(\sect_addr_buf_reg[2] ),
        .I2(CO),
        .I3(\sect_len_buf_reg[9] [4]),
        .I4(Q[4]),
        .I5(\sect_len_buf_reg[9]_0 [4]),
        .O(\beat_len_buf_reg[4] ));
  LUT6 #(
    .INIT(64'hF333C101FF3FCD0D)) 
    \sect_len_buf[5]_i_1 
       (.I0(\could_multi_bursts.sect_handling_reg_0 ),
        .I1(\sect_addr_buf_reg[2] ),
        .I2(CO),
        .I3(\sect_len_buf_reg[9] [5]),
        .I4(Q[5]),
        .I5(\sect_len_buf_reg[9]_0 [5]),
        .O(\beat_len_buf_reg[5] ));
  LUT6 #(
    .INIT(64'hF3C1FFCD33013F0D)) 
    \sect_len_buf[6]_i_1 
       (.I0(\could_multi_bursts.sect_handling_reg_0 ),
        .I1(\sect_addr_buf_reg[2] ),
        .I2(CO),
        .I3(Q[6]),
        .I4(\sect_len_buf_reg[9]_0 [6]),
        .I5(\sect_len_buf_reg[9] [6]),
        .O(\end_addr_buf_reg[8] ));
  LUT6 #(
    .INIT(64'hF3FFC1CD333F010D)) 
    \sect_len_buf[7]_i_1 
       (.I0(\could_multi_bursts.sect_handling_reg_0 ),
        .I1(\sect_addr_buf_reg[2] ),
        .I2(CO),
        .I3(\sect_len_buf_reg[9]_0 [7]),
        .I4(Q[7]),
        .I5(\sect_len_buf_reg[9] [7]),
        .O(\start_addr_buf_reg[9] ));
  LUT6 #(
    .INIT(64'hF3C13301FFCD3F0D)) 
    \sect_len_buf[8]_i_1 
       (.I0(\could_multi_bursts.sect_handling_reg_0 ),
        .I1(\sect_addr_buf_reg[2] ),
        .I2(CO),
        .I3(Q[8]),
        .I4(\sect_len_buf_reg[9] [8]),
        .I5(\sect_len_buf_reg[9]_0 [8]),
        .O(\end_addr_buf_reg[10] ));
  (* SOFT_HLUTNM = "soft_lutpair79" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \sect_len_buf[9]_i_1__0 
       (.I0(\could_multi_bursts.sect_handling_reg_0 ),
        .O(\could_multi_bursts.sect_handling_reg_2 ));
  LUT6 #(
    .INIT(64'hF333C101FF3FCD0D)) 
    \sect_len_buf[9]_i_2 
       (.I0(\could_multi_bursts.sect_handling_reg_0 ),
        .I1(\sect_addr_buf_reg[2] ),
        .I2(CO),
        .I3(\sect_len_buf_reg[9] [9]),
        .I4(Q[9]),
        .I5(\sect_len_buf_reg[9]_0 [9]),
        .O(\beat_len_buf_reg[9] ));
endmodule

(* ORIG_REF_NAME = "simple_accel_core_gmem_m_axi_fifo" *) 
module design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo__parameterized2
   (full_n_reg_0,
    empty_n_reg_0,
    \ap_CS_fsm_reg[15] ,
    ap_done,
    ap_clk,
    SR,
    Q,
    ap_start,
    ap_rst_n,
    push);
  output full_n_reg_0;
  output empty_n_reg_0;
  output [1:0]\ap_CS_fsm_reg[15] ;
  output ap_done;
  input ap_clk;
  input [0:0]SR;
  input [2:0]Q;
  input ap_start;
  input ap_rst_n;
  input push;

  wire [2:0]Q;
  wire [0:0]SR;
  wire [1:0]\ap_CS_fsm_reg[15] ;
  wire ap_clk;
  wire ap_done;
  wire ap_rst_n;
  wire ap_start;
  wire data_vld_i_1__2_n_2;
  wire data_vld_reg_n_2;
  wire empty_n_i_1__2_n_2;
  wire empty_n_reg_0;
  wire full_n_i_1__4_n_2;
  wire full_n_i_2_n_2;
  wire full_n_i_3__0_n_2;
  wire full_n_i_4_n_2;
  wire full_n_reg_0;
  wire \pout[0]_i_1__1_n_2 ;
  wire \pout[1]_i_1_n_2 ;
  wire \pout[2]_i_1_n_2 ;
  wire \pout[2]_i_3_n_2 ;
  wire \pout_reg_n_2_[0] ;
  wire \pout_reg_n_2_[1] ;
  wire \pout_reg_n_2_[2] ;
  wire push;

  (* SOFT_HLUTNM = "soft_lutpair166" *) 
  LUT4 #(
    .INIT(16'h8F88)) 
    \ap_CS_fsm[0]_i_1 
       (.I0(empty_n_reg_0),
        .I1(Q[2]),
        .I2(ap_start),
        .I3(Q[0]),
        .O(\ap_CS_fsm_reg[15] [0]));
  LUT3 #(
    .INIT(8'hBA)) 
    \ap_CS_fsm[16]_i_1 
       (.I0(Q[1]),
        .I1(empty_n_reg_0),
        .I2(Q[2]),
        .O(\ap_CS_fsm_reg[15] [1]));
  LUT6 #(
    .INIT(64'hFFFFFFFBAAAAAAAA)) 
    data_vld_i_1__2
       (.I0(push),
        .I1(full_n_i_2_n_2),
        .I2(\pout_reg_n_2_[2] ),
        .I3(\pout_reg_n_2_[0] ),
        .I4(\pout_reg_n_2_[1] ),
        .I5(data_vld_reg_n_2),
        .O(data_vld_i_1__2_n_2));
  FDRE data_vld_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(data_vld_i_1__2_n_2),
        .Q(data_vld_reg_n_2),
        .R(SR));
  (* SOFT_HLUTNM = "soft_lutpair168" *) 
  LUT3 #(
    .INIT(8'hF2)) 
    empty_n_i_1__2
       (.I0(empty_n_reg_0),
        .I1(Q[2]),
        .I2(data_vld_reg_n_2),
        .O(empty_n_i_1__2_n_2));
  FDRE empty_n_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(empty_n_i_1__2_n_2),
        .Q(empty_n_reg_0),
        .R(SR));
  LUT6 #(
    .INIT(64'hFBFBFBFBFBFBFBBB)) 
    full_n_i_1__4
       (.I0(full_n_i_2_n_2),
        .I1(ap_rst_n),
        .I2(full_n_reg_0),
        .I3(full_n_i_3__0_n_2),
        .I4(full_n_i_4_n_2),
        .I5(\pout_reg_n_2_[2] ),
        .O(full_n_i_1__4_n_2));
  (* SOFT_HLUTNM = "soft_lutpair167" *) 
  LUT3 #(
    .INIT(8'h8A)) 
    full_n_i_2
       (.I0(data_vld_reg_n_2),
        .I1(Q[2]),
        .I2(empty_n_reg_0),
        .O(full_n_i_2_n_2));
  (* SOFT_HLUTNM = "soft_lutpair167" *) 
  LUT4 #(
    .INIT(16'hF7FF)) 
    full_n_i_3__0
       (.I0(push),
        .I1(empty_n_reg_0),
        .I2(Q[2]),
        .I3(data_vld_reg_n_2),
        .O(full_n_i_3__0_n_2));
  LUT2 #(
    .INIT(4'h7)) 
    full_n_i_4
       (.I0(\pout_reg_n_2_[1] ),
        .I1(\pout_reg_n_2_[0] ),
        .O(full_n_i_4_n_2));
  FDRE full_n_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(full_n_i_1__4_n_2),
        .Q(full_n_reg_0),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair166" *) 
  LUT2 #(
    .INIT(4'h8)) 
    int_ap_ready_i_1
       (.I0(Q[2]),
        .I1(empty_n_reg_0),
        .O(ap_done));
  LUT6 #(
    .INIT(64'h6F6F90906F6F9080)) 
    \pout[0]_i_1__1 
       (.I0(push),
        .I1(\pout[2]_i_3_n_2 ),
        .I2(data_vld_reg_n_2),
        .I3(\pout_reg_n_2_[1] ),
        .I4(\pout_reg_n_2_[0] ),
        .I5(\pout_reg_n_2_[2] ),
        .O(\pout[0]_i_1__1_n_2 ));
  LUT6 #(
    .INIT(64'h7F80EF107F80EF00)) 
    \pout[1]_i_1 
       (.I0(push),
        .I1(\pout[2]_i_3_n_2 ),
        .I2(data_vld_reg_n_2),
        .I3(\pout_reg_n_2_[1] ),
        .I4(\pout_reg_n_2_[0] ),
        .I5(\pout_reg_n_2_[2] ),
        .O(\pout[1]_i_1_n_2 ));
  LUT6 #(
    .INIT(64'h7FFFFFEF80000000)) 
    \pout[2]_i_1 
       (.I0(push),
        .I1(\pout[2]_i_3_n_2 ),
        .I2(data_vld_reg_n_2),
        .I3(\pout_reg_n_2_[1] ),
        .I4(\pout_reg_n_2_[0] ),
        .I5(\pout_reg_n_2_[2] ),
        .O(\pout[2]_i_1_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair168" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \pout[2]_i_3 
       (.I0(empty_n_reg_0),
        .I1(Q[2]),
        .O(\pout[2]_i_3_n_2 ));
  FDRE \pout_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\pout[0]_i_1__1_n_2 ),
        .Q(\pout_reg_n_2_[0] ),
        .R(SR));
  FDRE \pout_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\pout[1]_i_1_n_2 ),
        .Q(\pout_reg_n_2_[1] ),
        .R(SR));
  FDRE \pout_reg[2] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\pout[2]_i_1_n_2 ),
        .Q(\pout_reg_n_2_[2] ),
        .R(SR));
endmodule

module design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_read
   (full_n_reg,
    SR,
    \could_multi_bursts.ARVALID_Dummy_reg_0 ,
    \state_reg[0] ,
    \ap_CS_fsm_reg[7] ,
    E,
    \usedw_reg[5] ,
    i_reg_137,
    i_reg_1370,
    \state_reg[0]_0 ,
    sum_reg_125,
    sum_reg_1250,
    \ap_CS_fsm_reg[8] ,
    DI,
    m_axi_gmem_ARADDR,
    S,
    \ap_CS_fsm_reg[8]_0 ,
    \ap_CS_fsm_reg[8]_1 ,
    \usedw_reg[6] ,
    \could_multi_bursts.arlen_buf_reg[3]_0 ,
    \data_p1_reg[31] ,
    ap_clk,
    D,
    m_axi_gmem_RRESP,
    m_axi_gmem_RVALID,
    ap_rst_n,
    m_axi_gmem_ARREADY,
    CO,
    ap_enable_reg_pp0_iter1_reg,
    ap_enable_reg_pp0_iter1_reg_0,
    ap_enable_reg_pp0_iter0,
    Q,
    ap_enable_reg_pp0_iter2_reg,
    exitcond_reg_251_pp0_iter1_reg,
    \data_p2_reg[63] ,
    \usedw_reg[7] );
  output full_n_reg;
  output [0:0]SR;
  output \could_multi_bursts.ARVALID_Dummy_reg_0 ;
  output \state_reg[0] ;
  output \ap_CS_fsm_reg[7] ;
  output [0:0]E;
  output [5:0]\usedw_reg[5] ;
  output i_reg_137;
  output i_reg_1370;
  output [0:0]\state_reg[0]_0 ;
  output sum_reg_125;
  output sum_reg_1250;
  output \ap_CS_fsm_reg[8] ;
  output [0:0]DI;
  output [29:0]m_axi_gmem_ARADDR;
  output [3:0]S;
  output \ap_CS_fsm_reg[8]_0 ;
  output \ap_CS_fsm_reg[8]_1 ;
  output [2:0]\usedw_reg[6] ;
  output [3:0]\could_multi_bursts.arlen_buf_reg[3]_0 ;
  output [31:0]\data_p1_reg[31] ;
  input ap_clk;
  input [32:0]D;
  input [1:0]m_axi_gmem_RRESP;
  input m_axi_gmem_RVALID;
  input ap_rst_n;
  input m_axi_gmem_ARREADY;
  input [0:0]CO;
  input ap_enable_reg_pp0_iter1_reg;
  input ap_enable_reg_pp0_iter1_reg_0;
  input ap_enable_reg_pp0_iter0;
  input [2:0]Q;
  input ap_enable_reg_pp0_iter2_reg;
  input exitcond_reg_251_pp0_iter1_reg;
  input [61:0]\data_p2_reg[63] ;
  input [6:0]\usedw_reg[7] ;

  wire [0:0]CO;
  wire [32:0]D;
  wire [0:0]DI;
  wire [0:0]E;
  wire [2:0]Q;
  wire [3:0]S;
  wire [0:0]SR;
  wire align_len;
  wire align_len0_carry__0_n_2;
  wire align_len0_carry__0_n_3;
  wire align_len0_carry__0_n_4;
  wire align_len0_carry__0_n_5;
  wire align_len0_carry__0_n_6;
  wire align_len0_carry__0_n_7;
  wire align_len0_carry__0_n_8;
  wire align_len0_carry__0_n_9;
  wire align_len0_carry__1_n_2;
  wire align_len0_carry__1_n_3;
  wire align_len0_carry__1_n_4;
  wire align_len0_carry__1_n_5;
  wire align_len0_carry__1_n_6;
  wire align_len0_carry__1_n_7;
  wire align_len0_carry__1_n_8;
  wire align_len0_carry__1_n_9;
  wire align_len0_carry__2_n_2;
  wire align_len0_carry__2_n_3;
  wire align_len0_carry__2_n_4;
  wire align_len0_carry__2_n_5;
  wire align_len0_carry__2_n_6;
  wire align_len0_carry__2_n_7;
  wire align_len0_carry__2_n_8;
  wire align_len0_carry__2_n_9;
  wire align_len0_carry__3_n_2;
  wire align_len0_carry__3_n_3;
  wire align_len0_carry__3_n_4;
  wire align_len0_carry__3_n_5;
  wire align_len0_carry__3_n_6;
  wire align_len0_carry__3_n_7;
  wire align_len0_carry__3_n_8;
  wire align_len0_carry__3_n_9;
  wire align_len0_carry__4_n_2;
  wire align_len0_carry__4_n_3;
  wire align_len0_carry__4_n_4;
  wire align_len0_carry__4_n_5;
  wire align_len0_carry__4_n_6;
  wire align_len0_carry__4_n_7;
  wire align_len0_carry__4_n_8;
  wire align_len0_carry__4_n_9;
  wire align_len0_carry__5_n_2;
  wire align_len0_carry__5_n_3;
  wire align_len0_carry__5_n_4;
  wire align_len0_carry__5_n_5;
  wire align_len0_carry__5_n_6;
  wire align_len0_carry__5_n_7;
  wire align_len0_carry__5_n_8;
  wire align_len0_carry__5_n_9;
  wire align_len0_carry__6_n_4;
  wire align_len0_carry__6_n_5;
  wire align_len0_carry__6_n_7;
  wire align_len0_carry__6_n_8;
  wire align_len0_carry__6_n_9;
  wire align_len0_carry_n_2;
  wire align_len0_carry_n_3;
  wire align_len0_carry_n_4;
  wire align_len0_carry_n_5;
  wire align_len0_carry_n_6;
  wire align_len0_carry_n_7;
  wire align_len0_carry_n_8;
  wire \align_len_reg_n_2_[10] ;
  wire \align_len_reg_n_2_[11] ;
  wire \align_len_reg_n_2_[12] ;
  wire \align_len_reg_n_2_[13] ;
  wire \align_len_reg_n_2_[14] ;
  wire \align_len_reg_n_2_[15] ;
  wire \align_len_reg_n_2_[16] ;
  wire \align_len_reg_n_2_[17] ;
  wire \align_len_reg_n_2_[18] ;
  wire \align_len_reg_n_2_[19] ;
  wire \align_len_reg_n_2_[20] ;
  wire \align_len_reg_n_2_[21] ;
  wire \align_len_reg_n_2_[22] ;
  wire \align_len_reg_n_2_[23] ;
  wire \align_len_reg_n_2_[24] ;
  wire \align_len_reg_n_2_[25] ;
  wire \align_len_reg_n_2_[26] ;
  wire \align_len_reg_n_2_[27] ;
  wire \align_len_reg_n_2_[28] ;
  wire \align_len_reg_n_2_[29] ;
  wire \align_len_reg_n_2_[2] ;
  wire \align_len_reg_n_2_[30] ;
  wire \align_len_reg_n_2_[31] ;
  wire \align_len_reg_n_2_[3] ;
  wire \align_len_reg_n_2_[4] ;
  wire \align_len_reg_n_2_[5] ;
  wire \align_len_reg_n_2_[6] ;
  wire \align_len_reg_n_2_[7] ;
  wire \align_len_reg_n_2_[8] ;
  wire \align_len_reg_n_2_[9] ;
  wire \ap_CS_fsm_reg[7] ;
  wire \ap_CS_fsm_reg[8] ;
  wire \ap_CS_fsm_reg[8]_0 ;
  wire \ap_CS_fsm_reg[8]_1 ;
  wire ap_clk;
  wire ap_enable_reg_pp0_iter0;
  wire ap_enable_reg_pp0_iter1_reg;
  wire ap_enable_reg_pp0_iter1_reg_0;
  wire ap_enable_reg_pp0_iter2_reg;
  wire ap_rst_n;
  wire [31:2]araddr_tmp;
  wire \beat_len_buf_reg_n_2_[0] ;
  wire \beat_len_buf_reg_n_2_[1] ;
  wire \beat_len_buf_reg_n_2_[2] ;
  wire \beat_len_buf_reg_n_2_[3] ;
  wire \beat_len_buf_reg_n_2_[4] ;
  wire \beat_len_buf_reg_n_2_[5] ;
  wire \beat_len_buf_reg_n_2_[6] ;
  wire \beat_len_buf_reg_n_2_[7] ;
  wire \beat_len_buf_reg_n_2_[8] ;
  wire \beat_len_buf_reg_n_2_[9] ;
  wire beat_valid;
  wire buff_rdata_n_13;
  wire buff_rdata_n_22;
  wire buff_rdata_n_23;
  wire buff_rdata_n_24;
  wire buff_rdata_n_25;
  wire buff_rdata_n_26;
  wire buff_rdata_n_27;
  wire buff_rdata_n_28;
  wire buff_rdata_n_29;
  wire buff_rdata_n_30;
  wire buff_rdata_n_31;
  wire buff_rdata_n_32;
  wire buff_rdata_n_33;
  wire buff_rdata_n_34;
  wire buff_rdata_n_35;
  wire buff_rdata_n_36;
  wire buff_rdata_n_37;
  wire buff_rdata_n_38;
  wire buff_rdata_n_39;
  wire buff_rdata_n_40;
  wire buff_rdata_n_41;
  wire buff_rdata_n_42;
  wire buff_rdata_n_43;
  wire buff_rdata_n_44;
  wire buff_rdata_n_45;
  wire buff_rdata_n_46;
  wire buff_rdata_n_47;
  wire buff_rdata_n_48;
  wire buff_rdata_n_49;
  wire buff_rdata_n_50;
  wire buff_rdata_n_51;
  wire buff_rdata_n_52;
  wire buff_rdata_n_53;
  wire [31:0]\bus_equal_gen.data_buf ;
  wire \bus_equal_gen.rdata_valid_t_reg_n_2 ;
  wire \could_multi_bursts.ARVALID_Dummy_reg_0 ;
  wire \could_multi_bursts.araddr_buf[31]_i_4_n_2 ;
  wire \could_multi_bursts.araddr_buf[4]_i_3_n_2 ;
  wire \could_multi_bursts.araddr_buf[4]_i_4_n_2 ;
  wire \could_multi_bursts.araddr_buf[4]_i_5_n_2 ;
  wire \could_multi_bursts.araddr_buf[8]_i_3_n_2 ;
  wire \could_multi_bursts.araddr_buf[8]_i_4_n_2 ;
  wire \could_multi_bursts.araddr_buf_reg[12]_i_2_n_2 ;
  wire \could_multi_bursts.araddr_buf_reg[12]_i_2_n_3 ;
  wire \could_multi_bursts.araddr_buf_reg[12]_i_2_n_4 ;
  wire \could_multi_bursts.araddr_buf_reg[12]_i_2_n_5 ;
  wire \could_multi_bursts.araddr_buf_reg[12]_i_2_n_6 ;
  wire \could_multi_bursts.araddr_buf_reg[12]_i_2_n_7 ;
  wire \could_multi_bursts.araddr_buf_reg[12]_i_2_n_8 ;
  wire \could_multi_bursts.araddr_buf_reg[12]_i_2_n_9 ;
  wire \could_multi_bursts.araddr_buf_reg[16]_i_2_n_2 ;
  wire \could_multi_bursts.araddr_buf_reg[16]_i_2_n_3 ;
  wire \could_multi_bursts.araddr_buf_reg[16]_i_2_n_4 ;
  wire \could_multi_bursts.araddr_buf_reg[16]_i_2_n_5 ;
  wire \could_multi_bursts.araddr_buf_reg[16]_i_2_n_6 ;
  wire \could_multi_bursts.araddr_buf_reg[16]_i_2_n_7 ;
  wire \could_multi_bursts.araddr_buf_reg[16]_i_2_n_8 ;
  wire \could_multi_bursts.araddr_buf_reg[16]_i_2_n_9 ;
  wire \could_multi_bursts.araddr_buf_reg[20]_i_2_n_2 ;
  wire \could_multi_bursts.araddr_buf_reg[20]_i_2_n_3 ;
  wire \could_multi_bursts.araddr_buf_reg[20]_i_2_n_4 ;
  wire \could_multi_bursts.araddr_buf_reg[20]_i_2_n_5 ;
  wire \could_multi_bursts.araddr_buf_reg[20]_i_2_n_6 ;
  wire \could_multi_bursts.araddr_buf_reg[20]_i_2_n_7 ;
  wire \could_multi_bursts.araddr_buf_reg[20]_i_2_n_8 ;
  wire \could_multi_bursts.araddr_buf_reg[20]_i_2_n_9 ;
  wire \could_multi_bursts.araddr_buf_reg[24]_i_2_n_2 ;
  wire \could_multi_bursts.araddr_buf_reg[24]_i_2_n_3 ;
  wire \could_multi_bursts.araddr_buf_reg[24]_i_2_n_4 ;
  wire \could_multi_bursts.araddr_buf_reg[24]_i_2_n_5 ;
  wire \could_multi_bursts.araddr_buf_reg[24]_i_2_n_6 ;
  wire \could_multi_bursts.araddr_buf_reg[24]_i_2_n_7 ;
  wire \could_multi_bursts.araddr_buf_reg[24]_i_2_n_8 ;
  wire \could_multi_bursts.araddr_buf_reg[24]_i_2_n_9 ;
  wire \could_multi_bursts.araddr_buf_reg[28]_i_2_n_2 ;
  wire \could_multi_bursts.araddr_buf_reg[28]_i_2_n_3 ;
  wire \could_multi_bursts.araddr_buf_reg[28]_i_2_n_4 ;
  wire \could_multi_bursts.araddr_buf_reg[28]_i_2_n_5 ;
  wire \could_multi_bursts.araddr_buf_reg[28]_i_2_n_6 ;
  wire \could_multi_bursts.araddr_buf_reg[28]_i_2_n_7 ;
  wire \could_multi_bursts.araddr_buf_reg[28]_i_2_n_8 ;
  wire \could_multi_bursts.araddr_buf_reg[28]_i_2_n_9 ;
  wire \could_multi_bursts.araddr_buf_reg[31]_i_3_n_4 ;
  wire \could_multi_bursts.araddr_buf_reg[31]_i_3_n_5 ;
  wire \could_multi_bursts.araddr_buf_reg[31]_i_3_n_7 ;
  wire \could_multi_bursts.araddr_buf_reg[31]_i_3_n_8 ;
  wire \could_multi_bursts.araddr_buf_reg[31]_i_3_n_9 ;
  wire \could_multi_bursts.araddr_buf_reg[4]_i_2_n_2 ;
  wire \could_multi_bursts.araddr_buf_reg[4]_i_2_n_3 ;
  wire \could_multi_bursts.araddr_buf_reg[4]_i_2_n_4 ;
  wire \could_multi_bursts.araddr_buf_reg[4]_i_2_n_5 ;
  wire \could_multi_bursts.araddr_buf_reg[4]_i_2_n_6 ;
  wire \could_multi_bursts.araddr_buf_reg[4]_i_2_n_7 ;
  wire \could_multi_bursts.araddr_buf_reg[4]_i_2_n_8 ;
  wire \could_multi_bursts.araddr_buf_reg[8]_i_2_n_2 ;
  wire \could_multi_bursts.araddr_buf_reg[8]_i_2_n_3 ;
  wire \could_multi_bursts.araddr_buf_reg[8]_i_2_n_4 ;
  wire \could_multi_bursts.araddr_buf_reg[8]_i_2_n_5 ;
  wire \could_multi_bursts.araddr_buf_reg[8]_i_2_n_6 ;
  wire \could_multi_bursts.araddr_buf_reg[8]_i_2_n_7 ;
  wire \could_multi_bursts.araddr_buf_reg[8]_i_2_n_8 ;
  wire \could_multi_bursts.araddr_buf_reg[8]_i_2_n_9 ;
  wire \could_multi_bursts.arlen_buf[3]_i_3_n_2 ;
  wire [3:0]\could_multi_bursts.arlen_buf_reg[3]_0 ;
  wire [5:0]\could_multi_bursts.loop_cnt_reg__0 ;
  wire \could_multi_bursts.sect_handling_reg_n_2 ;
  wire [31:0]\data_p1_reg[31] ;
  wire [61:0]\data_p2_reg[63] ;
  wire [34:34]data_pack;
  wire \end_addr_buf[2]_i_1__0_n_2 ;
  wire \end_addr_buf_reg_n_2_[10] ;
  wire \end_addr_buf_reg_n_2_[11] ;
  wire \end_addr_buf_reg_n_2_[12] ;
  wire \end_addr_buf_reg_n_2_[13] ;
  wire \end_addr_buf_reg_n_2_[14] ;
  wire \end_addr_buf_reg_n_2_[15] ;
  wire \end_addr_buf_reg_n_2_[16] ;
  wire \end_addr_buf_reg_n_2_[17] ;
  wire \end_addr_buf_reg_n_2_[18] ;
  wire \end_addr_buf_reg_n_2_[19] ;
  wire \end_addr_buf_reg_n_2_[20] ;
  wire \end_addr_buf_reg_n_2_[21] ;
  wire \end_addr_buf_reg_n_2_[22] ;
  wire \end_addr_buf_reg_n_2_[23] ;
  wire \end_addr_buf_reg_n_2_[24] ;
  wire \end_addr_buf_reg_n_2_[25] ;
  wire \end_addr_buf_reg_n_2_[26] ;
  wire \end_addr_buf_reg_n_2_[27] ;
  wire \end_addr_buf_reg_n_2_[28] ;
  wire \end_addr_buf_reg_n_2_[29] ;
  wire \end_addr_buf_reg_n_2_[2] ;
  wire \end_addr_buf_reg_n_2_[30] ;
  wire \end_addr_buf_reg_n_2_[31] ;
  wire \end_addr_buf_reg_n_2_[3] ;
  wire \end_addr_buf_reg_n_2_[4] ;
  wire \end_addr_buf_reg_n_2_[5] ;
  wire \end_addr_buf_reg_n_2_[6] ;
  wire \end_addr_buf_reg_n_2_[7] ;
  wire \end_addr_buf_reg_n_2_[8] ;
  wire \end_addr_buf_reg_n_2_[9] ;
  wire end_addr_carry__0_i_1__0_n_2;
  wire end_addr_carry__0_i_2__0_n_2;
  wire end_addr_carry__0_i_3__0_n_2;
  wire end_addr_carry__0_i_4__0_n_2;
  wire end_addr_carry__0_n_2;
  wire end_addr_carry__0_n_3;
  wire end_addr_carry__0_n_4;
  wire end_addr_carry__0_n_5;
  wire end_addr_carry__0_n_6;
  wire end_addr_carry__0_n_7;
  wire end_addr_carry__0_n_8;
  wire end_addr_carry__0_n_9;
  wire end_addr_carry__1_i_1__0_n_2;
  wire end_addr_carry__1_i_2__0_n_2;
  wire end_addr_carry__1_i_3__0_n_2;
  wire end_addr_carry__1_i_4__0_n_2;
  wire end_addr_carry__1_n_2;
  wire end_addr_carry__1_n_3;
  wire end_addr_carry__1_n_4;
  wire end_addr_carry__1_n_5;
  wire end_addr_carry__1_n_6;
  wire end_addr_carry__1_n_7;
  wire end_addr_carry__1_n_8;
  wire end_addr_carry__1_n_9;
  wire end_addr_carry__2_i_1__0_n_2;
  wire end_addr_carry__2_i_2__0_n_2;
  wire end_addr_carry__2_i_3__0_n_2;
  wire end_addr_carry__2_i_4__0_n_2;
  wire end_addr_carry__2_n_2;
  wire end_addr_carry__2_n_3;
  wire end_addr_carry__2_n_4;
  wire end_addr_carry__2_n_5;
  wire end_addr_carry__2_n_6;
  wire end_addr_carry__2_n_7;
  wire end_addr_carry__2_n_8;
  wire end_addr_carry__2_n_9;
  wire end_addr_carry__3_i_1__0_n_2;
  wire end_addr_carry__3_i_2__0_n_2;
  wire end_addr_carry__3_i_3__0_n_2;
  wire end_addr_carry__3_i_4__0_n_2;
  wire end_addr_carry__3_n_2;
  wire end_addr_carry__3_n_3;
  wire end_addr_carry__3_n_4;
  wire end_addr_carry__3_n_5;
  wire end_addr_carry__3_n_6;
  wire end_addr_carry__3_n_7;
  wire end_addr_carry__3_n_8;
  wire end_addr_carry__3_n_9;
  wire end_addr_carry__4_i_1__0_n_2;
  wire end_addr_carry__4_i_2__0_n_2;
  wire end_addr_carry__4_i_3__0_n_2;
  wire end_addr_carry__4_i_4__0_n_2;
  wire end_addr_carry__4_n_2;
  wire end_addr_carry__4_n_3;
  wire end_addr_carry__4_n_4;
  wire end_addr_carry__4_n_5;
  wire end_addr_carry__4_n_6;
  wire end_addr_carry__4_n_7;
  wire end_addr_carry__4_n_8;
  wire end_addr_carry__4_n_9;
  wire end_addr_carry__5_i_1__0_n_2;
  wire end_addr_carry__5_i_2__0_n_2;
  wire end_addr_carry__5_i_3__0_n_2;
  wire end_addr_carry__5_i_4__0_n_2;
  wire end_addr_carry__5_n_2;
  wire end_addr_carry__5_n_3;
  wire end_addr_carry__5_n_4;
  wire end_addr_carry__5_n_5;
  wire end_addr_carry__5_n_6;
  wire end_addr_carry__5_n_7;
  wire end_addr_carry__5_n_8;
  wire end_addr_carry__5_n_9;
  wire end_addr_carry__6_i_1__0_n_2;
  wire end_addr_carry__6_i_2__0_n_2;
  wire end_addr_carry__6_n_5;
  wire end_addr_carry__6_n_8;
  wire end_addr_carry__6_n_9;
  wire end_addr_carry_i_1__0_n_2;
  wire end_addr_carry_i_2__0_n_2;
  wire end_addr_carry_i_3__0_n_2;
  wire end_addr_carry_i_4__0_n_2;
  wire end_addr_carry_n_2;
  wire end_addr_carry_n_3;
  wire end_addr_carry_n_4;
  wire end_addr_carry_n_5;
  wire end_addr_carry_n_6;
  wire end_addr_carry_n_7;
  wire end_addr_carry_n_8;
  wire exitcond_reg_251_pp0_iter1_reg;
  wire fifo_rctl_n_10;
  wire fifo_rctl_n_11;
  wire fifo_rctl_n_12;
  wire fifo_rctl_n_13;
  wire fifo_rctl_n_14;
  wire fifo_rctl_n_15;
  wire fifo_rctl_n_16;
  wire fifo_rctl_n_17;
  wire fifo_rctl_n_18;
  wire fifo_rctl_n_19;
  wire fifo_rctl_n_2;
  wire fifo_rctl_n_20;
  wire fifo_rctl_n_21;
  wire fifo_rctl_n_22;
  wire fifo_rctl_n_23;
  wire fifo_rctl_n_24;
  wire fifo_rctl_n_25;
  wire fifo_rctl_n_26;
  wire fifo_rctl_n_27;
  wire fifo_rctl_n_28;
  wire fifo_rctl_n_4;
  wire fifo_rctl_n_6;
  wire fifo_rctl_n_7;
  wire fifo_rctl_n_9;
  wire [60:32]fifo_rreq_data;
  wire fifo_rreq_n_10;
  wire fifo_rreq_n_100;
  wire fifo_rreq_n_101;
  wire fifo_rreq_n_102;
  wire fifo_rreq_n_103;
  wire fifo_rreq_n_104;
  wire fifo_rreq_n_105;
  wire fifo_rreq_n_106;
  wire fifo_rreq_n_107;
  wire fifo_rreq_n_108;
  wire fifo_rreq_n_109;
  wire fifo_rreq_n_11;
  wire fifo_rreq_n_110;
  wire fifo_rreq_n_111;
  wire fifo_rreq_n_112;
  wire fifo_rreq_n_113;
  wire fifo_rreq_n_114;
  wire fifo_rreq_n_115;
  wire fifo_rreq_n_116;
  wire fifo_rreq_n_117;
  wire fifo_rreq_n_118;
  wire fifo_rreq_n_119;
  wire fifo_rreq_n_12;
  wire fifo_rreq_n_120;
  wire fifo_rreq_n_121;
  wire fifo_rreq_n_122;
  wire fifo_rreq_n_13;
  wire fifo_rreq_n_14;
  wire fifo_rreq_n_15;
  wire fifo_rreq_n_16;
  wire fifo_rreq_n_17;
  wire fifo_rreq_n_18;
  wire fifo_rreq_n_19;
  wire fifo_rreq_n_20;
  wire fifo_rreq_n_21;
  wire fifo_rreq_n_22;
  wire fifo_rreq_n_23;
  wire fifo_rreq_n_25;
  wire fifo_rreq_n_26;
  wire fifo_rreq_n_27;
  wire fifo_rreq_n_28;
  wire fifo_rreq_n_29;
  wire fifo_rreq_n_4;
  wire fifo_rreq_n_5;
  wire fifo_rreq_n_59;
  wire fifo_rreq_n_6;
  wire fifo_rreq_n_60;
  wire fifo_rreq_n_61;
  wire fifo_rreq_n_62;
  wire fifo_rreq_n_63;
  wire fifo_rreq_n_64;
  wire fifo_rreq_n_65;
  wire fifo_rreq_n_66;
  wire fifo_rreq_n_67;
  wire fifo_rreq_n_68;
  wire fifo_rreq_n_69;
  wire fifo_rreq_n_7;
  wire fifo_rreq_n_70;
  wire fifo_rreq_n_71;
  wire fifo_rreq_n_72;
  wire fifo_rreq_n_73;
  wire fifo_rreq_n_74;
  wire fifo_rreq_n_75;
  wire fifo_rreq_n_76;
  wire fifo_rreq_n_77;
  wire fifo_rreq_n_78;
  wire fifo_rreq_n_79;
  wire fifo_rreq_n_8;
  wire fifo_rreq_n_80;
  wire fifo_rreq_n_81;
  wire fifo_rreq_n_82;
  wire fifo_rreq_n_83;
  wire fifo_rreq_n_84;
  wire fifo_rreq_n_85;
  wire fifo_rreq_n_86;
  wire fifo_rreq_n_87;
  wire fifo_rreq_n_88;
  wire fifo_rreq_n_89;
  wire fifo_rreq_n_9;
  wire fifo_rreq_n_90;
  wire fifo_rreq_n_91;
  wire fifo_rreq_n_92;
  wire fifo_rreq_n_93;
  wire fifo_rreq_n_94;
  wire fifo_rreq_n_95;
  wire fifo_rreq_n_96;
  wire fifo_rreq_n_97;
  wire fifo_rreq_n_98;
  wire fifo_rreq_n_99;
  wire fifo_rreq_valid;
  wire fifo_rreq_valid_buf_reg_n_2;
  wire first_sect;
  wire first_sect_carry__0_i_1__0_n_2;
  wire first_sect_carry__0_i_2__0_n_2;
  wire first_sect_carry__0_i_3__0_n_2;
  wire first_sect_carry__0_n_4;
  wire first_sect_carry__0_n_5;
  wire first_sect_carry_i_1__0_n_2;
  wire first_sect_carry_i_2__0_n_2;
  wire first_sect_carry_i_3__0_n_2;
  wire first_sect_carry_i_4__0_n_2;
  wire first_sect_carry_n_2;
  wire first_sect_carry_n_3;
  wire first_sect_carry_n_4;
  wire first_sect_carry_n_5;
  wire full_n_reg;
  wire i_reg_137;
  wire i_reg_1370;
  wire invalid_len_event;
  wire invalid_len_event0;
  wire invalid_len_event_reg1_reg_n_2;
  wire invalid_len_event_reg2;
  wire last_sect;
  wire last_sect_carry__0_n_4;
  wire last_sect_carry__0_n_5;
  wire last_sect_carry_n_2;
  wire last_sect_carry_n_3;
  wire last_sect_carry_n_4;
  wire last_sect_carry_n_5;
  wire [29:0]m_axi_gmem_ARADDR;
  wire m_axi_gmem_ARREADY;
  wire [1:0]m_axi_gmem_RRESP;
  wire m_axi_gmem_RVALID;
  wire next_beat;
  wire next_rreq;
  wire [5:0]p_0_in__2;
  wire [3:0]p_1_in;
  wire p_21_in;
  wire push;
  wire push_0;
  wire rdata_ack_t;
  wire rreq_handling_reg_n_2;
  wire rs2f_rreq_ack;
  wire [63:0]rs2f_rreq_data;
  wire \sect_addr_buf[10]_i_1__0_n_2 ;
  wire \sect_addr_buf[11]_i_2__0_n_2 ;
  wire \sect_addr_buf[12]_i_1__0_n_2 ;
  wire \sect_addr_buf[13]_i_1__0_n_2 ;
  wire \sect_addr_buf[14]_i_1__0_n_2 ;
  wire \sect_addr_buf[15]_i_1__0_n_2 ;
  wire \sect_addr_buf[16]_i_1__0_n_2 ;
  wire \sect_addr_buf[17]_i_1__0_n_2 ;
  wire \sect_addr_buf[18]_i_1__0_n_2 ;
  wire \sect_addr_buf[19]_i_1__0_n_2 ;
  wire \sect_addr_buf[20]_i_1__0_n_2 ;
  wire \sect_addr_buf[21]_i_1__0_n_2 ;
  wire \sect_addr_buf[22]_i_1__0_n_2 ;
  wire \sect_addr_buf[23]_i_1__0_n_2 ;
  wire \sect_addr_buf[24]_i_1__0_n_2 ;
  wire \sect_addr_buf[25]_i_1__0_n_2 ;
  wire \sect_addr_buf[26]_i_1__0_n_2 ;
  wire \sect_addr_buf[27]_i_1__0_n_2 ;
  wire \sect_addr_buf[28]_i_1__0_n_2 ;
  wire \sect_addr_buf[29]_i_1__0_n_2 ;
  wire \sect_addr_buf[2]_i_1__0_n_2 ;
  wire \sect_addr_buf[30]_i_1__0_n_2 ;
  wire \sect_addr_buf[31]_i_1__0_n_2 ;
  wire \sect_addr_buf[3]_i_1__0_n_2 ;
  wire \sect_addr_buf[4]_i_1__0_n_2 ;
  wire \sect_addr_buf[5]_i_1__0_n_2 ;
  wire \sect_addr_buf[6]_i_1__0_n_2 ;
  wire \sect_addr_buf[7]_i_1__0_n_2 ;
  wire \sect_addr_buf[8]_i_1__0_n_2 ;
  wire \sect_addr_buf[9]_i_1__0_n_2 ;
  wire \sect_addr_buf_reg_n_2_[10] ;
  wire \sect_addr_buf_reg_n_2_[11] ;
  wire \sect_addr_buf_reg_n_2_[12] ;
  wire \sect_addr_buf_reg_n_2_[13] ;
  wire \sect_addr_buf_reg_n_2_[14] ;
  wire \sect_addr_buf_reg_n_2_[15] ;
  wire \sect_addr_buf_reg_n_2_[16] ;
  wire \sect_addr_buf_reg_n_2_[17] ;
  wire \sect_addr_buf_reg_n_2_[18] ;
  wire \sect_addr_buf_reg_n_2_[19] ;
  wire \sect_addr_buf_reg_n_2_[20] ;
  wire \sect_addr_buf_reg_n_2_[21] ;
  wire \sect_addr_buf_reg_n_2_[22] ;
  wire \sect_addr_buf_reg_n_2_[23] ;
  wire \sect_addr_buf_reg_n_2_[24] ;
  wire \sect_addr_buf_reg_n_2_[25] ;
  wire \sect_addr_buf_reg_n_2_[26] ;
  wire \sect_addr_buf_reg_n_2_[27] ;
  wire \sect_addr_buf_reg_n_2_[28] ;
  wire \sect_addr_buf_reg_n_2_[29] ;
  wire \sect_addr_buf_reg_n_2_[2] ;
  wire \sect_addr_buf_reg_n_2_[30] ;
  wire \sect_addr_buf_reg_n_2_[31] ;
  wire \sect_addr_buf_reg_n_2_[3] ;
  wire \sect_addr_buf_reg_n_2_[4] ;
  wire \sect_addr_buf_reg_n_2_[5] ;
  wire \sect_addr_buf_reg_n_2_[6] ;
  wire \sect_addr_buf_reg_n_2_[7] ;
  wire \sect_addr_buf_reg_n_2_[8] ;
  wire \sect_addr_buf_reg_n_2_[9] ;
  wire sect_cnt0_carry__0_n_2;
  wire sect_cnt0_carry__0_n_3;
  wire sect_cnt0_carry__0_n_4;
  wire sect_cnt0_carry__0_n_5;
  wire sect_cnt0_carry__0_n_6;
  wire sect_cnt0_carry__0_n_7;
  wire sect_cnt0_carry__0_n_8;
  wire sect_cnt0_carry__0_n_9;
  wire sect_cnt0_carry__1_n_2;
  wire sect_cnt0_carry__1_n_3;
  wire sect_cnt0_carry__1_n_4;
  wire sect_cnt0_carry__1_n_5;
  wire sect_cnt0_carry__1_n_6;
  wire sect_cnt0_carry__1_n_7;
  wire sect_cnt0_carry__1_n_8;
  wire sect_cnt0_carry__1_n_9;
  wire sect_cnt0_carry__2_n_2;
  wire sect_cnt0_carry__2_n_3;
  wire sect_cnt0_carry__2_n_4;
  wire sect_cnt0_carry__2_n_5;
  wire sect_cnt0_carry__2_n_6;
  wire sect_cnt0_carry__2_n_7;
  wire sect_cnt0_carry__2_n_8;
  wire sect_cnt0_carry__2_n_9;
  wire sect_cnt0_carry__3_n_4;
  wire sect_cnt0_carry__3_n_5;
  wire sect_cnt0_carry__3_n_7;
  wire sect_cnt0_carry__3_n_8;
  wire sect_cnt0_carry__3_n_9;
  wire sect_cnt0_carry_n_2;
  wire sect_cnt0_carry_n_3;
  wire sect_cnt0_carry_n_4;
  wire sect_cnt0_carry_n_5;
  wire sect_cnt0_carry_n_6;
  wire sect_cnt0_carry_n_7;
  wire sect_cnt0_carry_n_8;
  wire sect_cnt0_carry_n_9;
  wire \sect_cnt_reg_n_2_[0] ;
  wire \sect_cnt_reg_n_2_[10] ;
  wire \sect_cnt_reg_n_2_[11] ;
  wire \sect_cnt_reg_n_2_[12] ;
  wire \sect_cnt_reg_n_2_[13] ;
  wire \sect_cnt_reg_n_2_[14] ;
  wire \sect_cnt_reg_n_2_[15] ;
  wire \sect_cnt_reg_n_2_[16] ;
  wire \sect_cnt_reg_n_2_[17] ;
  wire \sect_cnt_reg_n_2_[18] ;
  wire \sect_cnt_reg_n_2_[19] ;
  wire \sect_cnt_reg_n_2_[1] ;
  wire \sect_cnt_reg_n_2_[2] ;
  wire \sect_cnt_reg_n_2_[3] ;
  wire \sect_cnt_reg_n_2_[4] ;
  wire \sect_cnt_reg_n_2_[5] ;
  wire \sect_cnt_reg_n_2_[6] ;
  wire \sect_cnt_reg_n_2_[7] ;
  wire \sect_cnt_reg_n_2_[8] ;
  wire \sect_cnt_reg_n_2_[9] ;
  wire \sect_len_buf_reg_n_2_[4] ;
  wire \sect_len_buf_reg_n_2_[5] ;
  wire \sect_len_buf_reg_n_2_[6] ;
  wire \sect_len_buf_reg_n_2_[7] ;
  wire \sect_len_buf_reg_n_2_[8] ;
  wire \sect_len_buf_reg_n_2_[9] ;
  wire \start_addr_buf_reg_n_2_[10] ;
  wire \start_addr_buf_reg_n_2_[11] ;
  wire \start_addr_buf_reg_n_2_[12] ;
  wire \start_addr_buf_reg_n_2_[13] ;
  wire \start_addr_buf_reg_n_2_[14] ;
  wire \start_addr_buf_reg_n_2_[15] ;
  wire \start_addr_buf_reg_n_2_[16] ;
  wire \start_addr_buf_reg_n_2_[17] ;
  wire \start_addr_buf_reg_n_2_[18] ;
  wire \start_addr_buf_reg_n_2_[19] ;
  wire \start_addr_buf_reg_n_2_[20] ;
  wire \start_addr_buf_reg_n_2_[21] ;
  wire \start_addr_buf_reg_n_2_[22] ;
  wire \start_addr_buf_reg_n_2_[23] ;
  wire \start_addr_buf_reg_n_2_[24] ;
  wire \start_addr_buf_reg_n_2_[25] ;
  wire \start_addr_buf_reg_n_2_[26] ;
  wire \start_addr_buf_reg_n_2_[27] ;
  wire \start_addr_buf_reg_n_2_[28] ;
  wire \start_addr_buf_reg_n_2_[29] ;
  wire \start_addr_buf_reg_n_2_[2] ;
  wire \start_addr_buf_reg_n_2_[30] ;
  wire \start_addr_buf_reg_n_2_[31] ;
  wire \start_addr_buf_reg_n_2_[3] ;
  wire \start_addr_buf_reg_n_2_[4] ;
  wire \start_addr_buf_reg_n_2_[5] ;
  wire \start_addr_buf_reg_n_2_[6] ;
  wire \start_addr_buf_reg_n_2_[7] ;
  wire \start_addr_buf_reg_n_2_[8] ;
  wire \start_addr_buf_reg_n_2_[9] ;
  wire \start_addr_reg_n_2_[10] ;
  wire \start_addr_reg_n_2_[11] ;
  wire \start_addr_reg_n_2_[12] ;
  wire \start_addr_reg_n_2_[13] ;
  wire \start_addr_reg_n_2_[14] ;
  wire \start_addr_reg_n_2_[15] ;
  wire \start_addr_reg_n_2_[16] ;
  wire \start_addr_reg_n_2_[17] ;
  wire \start_addr_reg_n_2_[18] ;
  wire \start_addr_reg_n_2_[19] ;
  wire \start_addr_reg_n_2_[20] ;
  wire \start_addr_reg_n_2_[21] ;
  wire \start_addr_reg_n_2_[22] ;
  wire \start_addr_reg_n_2_[23] ;
  wire \start_addr_reg_n_2_[24] ;
  wire \start_addr_reg_n_2_[25] ;
  wire \start_addr_reg_n_2_[26] ;
  wire \start_addr_reg_n_2_[27] ;
  wire \start_addr_reg_n_2_[28] ;
  wire \start_addr_reg_n_2_[29] ;
  wire \start_addr_reg_n_2_[2] ;
  wire \start_addr_reg_n_2_[30] ;
  wire \start_addr_reg_n_2_[31] ;
  wire \start_addr_reg_n_2_[3] ;
  wire \start_addr_reg_n_2_[4] ;
  wire \start_addr_reg_n_2_[5] ;
  wire \start_addr_reg_n_2_[6] ;
  wire \start_addr_reg_n_2_[7] ;
  wire \start_addr_reg_n_2_[8] ;
  wire \start_addr_reg_n_2_[9] ;
  wire \state_reg[0] ;
  wire [0:0]\state_reg[0]_0 ;
  wire sum_reg_125;
  wire sum_reg_1250;
  wire [5:0]\usedw_reg[5] ;
  wire [2:0]\usedw_reg[6] ;
  wire [6:0]\usedw_reg[7] ;
  wire [0:0]NLW_align_len0_carry_O_UNCONNECTED;
  wire [3:2]NLW_align_len0_carry__6_CO_UNCONNECTED;
  wire [3:3]NLW_align_len0_carry__6_O_UNCONNECTED;
  wire [3:2]\NLW_could_multi_bursts.araddr_buf_reg[31]_i_3_CO_UNCONNECTED ;
  wire [3:3]\NLW_could_multi_bursts.araddr_buf_reg[31]_i_3_O_UNCONNECTED ;
  wire [0:0]\NLW_could_multi_bursts.araddr_buf_reg[4]_i_2_O_UNCONNECTED ;
  wire [0:0]NLW_end_addr_carry_O_UNCONNECTED;
  wire [3:1]NLW_end_addr_carry__6_CO_UNCONNECTED;
  wire [3:2]NLW_end_addr_carry__6_O_UNCONNECTED;
  wire [3:0]NLW_first_sect_carry_O_UNCONNECTED;
  wire [3:3]NLW_first_sect_carry__0_CO_UNCONNECTED;
  wire [3:0]NLW_first_sect_carry__0_O_UNCONNECTED;
  wire [3:0]NLW_last_sect_carry_O_UNCONNECTED;
  wire [3:3]NLW_last_sect_carry__0_CO_UNCONNECTED;
  wire [3:0]NLW_last_sect_carry__0_O_UNCONNECTED;
  wire [3:2]NLW_sect_cnt0_carry__3_CO_UNCONNECTED;
  wire [3:3]NLW_sect_cnt0_carry__3_O_UNCONNECTED;

  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 align_len0_carry
       (.CI(1'b0),
        .CO({align_len0_carry_n_2,align_len0_carry_n_3,align_len0_carry_n_4,align_len0_carry_n_5}),
        .CYINIT(1'b0),
        .DI({fifo_rreq_data[34:32],1'b0}),
        .O({align_len0_carry_n_6,align_len0_carry_n_7,align_len0_carry_n_8,NLW_align_len0_carry_O_UNCONNECTED[0]}),
        .S({fifo_rreq_n_113,fifo_rreq_n_114,fifo_rreq_n_115,1'b1}));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 align_len0_carry__0
       (.CI(align_len0_carry_n_2),
        .CO({align_len0_carry__0_n_2,align_len0_carry__0_n_3,align_len0_carry__0_n_4,align_len0_carry__0_n_5}),
        .CYINIT(1'b0),
        .DI(fifo_rreq_data[38:35]),
        .O({align_len0_carry__0_n_6,align_len0_carry__0_n_7,align_len0_carry__0_n_8,align_len0_carry__0_n_9}),
        .S({fifo_rreq_n_109,fifo_rreq_n_110,fifo_rreq_n_111,fifo_rreq_n_112}));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 align_len0_carry__1
       (.CI(align_len0_carry__0_n_2),
        .CO({align_len0_carry__1_n_2,align_len0_carry__1_n_3,align_len0_carry__1_n_4,align_len0_carry__1_n_5}),
        .CYINIT(1'b0),
        .DI(fifo_rreq_data[42:39]),
        .O({align_len0_carry__1_n_6,align_len0_carry__1_n_7,align_len0_carry__1_n_8,align_len0_carry__1_n_9}),
        .S({fifo_rreq_n_105,fifo_rreq_n_106,fifo_rreq_n_107,fifo_rreq_n_108}));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 align_len0_carry__2
       (.CI(align_len0_carry__1_n_2),
        .CO({align_len0_carry__2_n_2,align_len0_carry__2_n_3,align_len0_carry__2_n_4,align_len0_carry__2_n_5}),
        .CYINIT(1'b0),
        .DI(fifo_rreq_data[46:43]),
        .O({align_len0_carry__2_n_6,align_len0_carry__2_n_7,align_len0_carry__2_n_8,align_len0_carry__2_n_9}),
        .S({fifo_rreq_n_101,fifo_rreq_n_102,fifo_rreq_n_103,fifo_rreq_n_104}));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 align_len0_carry__3
       (.CI(align_len0_carry__2_n_2),
        .CO({align_len0_carry__3_n_2,align_len0_carry__3_n_3,align_len0_carry__3_n_4,align_len0_carry__3_n_5}),
        .CYINIT(1'b0),
        .DI(fifo_rreq_data[50:47]),
        .O({align_len0_carry__3_n_6,align_len0_carry__3_n_7,align_len0_carry__3_n_8,align_len0_carry__3_n_9}),
        .S({fifo_rreq_n_97,fifo_rreq_n_98,fifo_rreq_n_99,fifo_rreq_n_100}));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 align_len0_carry__4
       (.CI(align_len0_carry__3_n_2),
        .CO({align_len0_carry__4_n_2,align_len0_carry__4_n_3,align_len0_carry__4_n_4,align_len0_carry__4_n_5}),
        .CYINIT(1'b0),
        .DI(fifo_rreq_data[54:51]),
        .O({align_len0_carry__4_n_6,align_len0_carry__4_n_7,align_len0_carry__4_n_8,align_len0_carry__4_n_9}),
        .S({fifo_rreq_n_93,fifo_rreq_n_94,fifo_rreq_n_95,fifo_rreq_n_96}));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 align_len0_carry__5
       (.CI(align_len0_carry__4_n_2),
        .CO({align_len0_carry__5_n_2,align_len0_carry__5_n_3,align_len0_carry__5_n_4,align_len0_carry__5_n_5}),
        .CYINIT(1'b0),
        .DI(fifo_rreq_data[58:55]),
        .O({align_len0_carry__5_n_6,align_len0_carry__5_n_7,align_len0_carry__5_n_8,align_len0_carry__5_n_9}),
        .S({fifo_rreq_n_89,fifo_rreq_n_90,fifo_rreq_n_91,fifo_rreq_n_92}));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 align_len0_carry__6
       (.CI(align_len0_carry__5_n_2),
        .CO({NLW_align_len0_carry__6_CO_UNCONNECTED[3:2],align_len0_carry__6_n_4,align_len0_carry__6_n_5}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,fifo_rreq_data[60:59]}),
        .O({NLW_align_len0_carry__6_O_UNCONNECTED[3],align_len0_carry__6_n_7,align_len0_carry__6_n_8,align_len0_carry__6_n_9}),
        .S({1'b0,fifo_rreq_n_27,fifo_rreq_n_28,fifo_rreq_n_29}));
  FDRE \align_len_reg[10] 
       (.C(ap_clk),
        .CE(align_len),
        .D(align_len0_carry__1_n_8),
        .Q(\align_len_reg_n_2_[10] ),
        .R(SR));
  FDRE \align_len_reg[11] 
       (.C(ap_clk),
        .CE(align_len),
        .D(align_len0_carry__1_n_7),
        .Q(\align_len_reg_n_2_[11] ),
        .R(SR));
  FDRE \align_len_reg[12] 
       (.C(ap_clk),
        .CE(align_len),
        .D(align_len0_carry__1_n_6),
        .Q(\align_len_reg_n_2_[12] ),
        .R(SR));
  FDRE \align_len_reg[13] 
       (.C(ap_clk),
        .CE(align_len),
        .D(align_len0_carry__2_n_9),
        .Q(\align_len_reg_n_2_[13] ),
        .R(SR));
  FDRE \align_len_reg[14] 
       (.C(ap_clk),
        .CE(align_len),
        .D(align_len0_carry__2_n_8),
        .Q(\align_len_reg_n_2_[14] ),
        .R(SR));
  FDRE \align_len_reg[15] 
       (.C(ap_clk),
        .CE(align_len),
        .D(align_len0_carry__2_n_7),
        .Q(\align_len_reg_n_2_[15] ),
        .R(SR));
  FDRE \align_len_reg[16] 
       (.C(ap_clk),
        .CE(align_len),
        .D(align_len0_carry__2_n_6),
        .Q(\align_len_reg_n_2_[16] ),
        .R(SR));
  FDRE \align_len_reg[17] 
       (.C(ap_clk),
        .CE(align_len),
        .D(align_len0_carry__3_n_9),
        .Q(\align_len_reg_n_2_[17] ),
        .R(SR));
  FDRE \align_len_reg[18] 
       (.C(ap_clk),
        .CE(align_len),
        .D(align_len0_carry__3_n_8),
        .Q(\align_len_reg_n_2_[18] ),
        .R(SR));
  FDRE \align_len_reg[19] 
       (.C(ap_clk),
        .CE(align_len),
        .D(align_len0_carry__3_n_7),
        .Q(\align_len_reg_n_2_[19] ),
        .R(SR));
  FDRE \align_len_reg[20] 
       (.C(ap_clk),
        .CE(align_len),
        .D(align_len0_carry__3_n_6),
        .Q(\align_len_reg_n_2_[20] ),
        .R(SR));
  FDRE \align_len_reg[21] 
       (.C(ap_clk),
        .CE(align_len),
        .D(align_len0_carry__4_n_9),
        .Q(\align_len_reg_n_2_[21] ),
        .R(SR));
  FDRE \align_len_reg[22] 
       (.C(ap_clk),
        .CE(align_len),
        .D(align_len0_carry__4_n_8),
        .Q(\align_len_reg_n_2_[22] ),
        .R(SR));
  FDRE \align_len_reg[23] 
       (.C(ap_clk),
        .CE(align_len),
        .D(align_len0_carry__4_n_7),
        .Q(\align_len_reg_n_2_[23] ),
        .R(SR));
  FDRE \align_len_reg[24] 
       (.C(ap_clk),
        .CE(align_len),
        .D(align_len0_carry__4_n_6),
        .Q(\align_len_reg_n_2_[24] ),
        .R(SR));
  FDRE \align_len_reg[25] 
       (.C(ap_clk),
        .CE(align_len),
        .D(align_len0_carry__5_n_9),
        .Q(\align_len_reg_n_2_[25] ),
        .R(SR));
  FDRE \align_len_reg[26] 
       (.C(ap_clk),
        .CE(align_len),
        .D(align_len0_carry__5_n_8),
        .Q(\align_len_reg_n_2_[26] ),
        .R(SR));
  FDRE \align_len_reg[27] 
       (.C(ap_clk),
        .CE(align_len),
        .D(align_len0_carry__5_n_7),
        .Q(\align_len_reg_n_2_[27] ),
        .R(SR));
  FDRE \align_len_reg[28] 
       (.C(ap_clk),
        .CE(align_len),
        .D(align_len0_carry__5_n_6),
        .Q(\align_len_reg_n_2_[28] ),
        .R(SR));
  FDRE \align_len_reg[29] 
       (.C(ap_clk),
        .CE(align_len),
        .D(align_len0_carry__6_n_9),
        .Q(\align_len_reg_n_2_[29] ),
        .R(SR));
  FDRE \align_len_reg[2] 
       (.C(ap_clk),
        .CE(align_len),
        .D(align_len0_carry_n_8),
        .Q(\align_len_reg_n_2_[2] ),
        .R(SR));
  FDRE \align_len_reg[30] 
       (.C(ap_clk),
        .CE(align_len),
        .D(align_len0_carry__6_n_8),
        .Q(\align_len_reg_n_2_[30] ),
        .R(SR));
  FDRE \align_len_reg[31] 
       (.C(ap_clk),
        .CE(align_len),
        .D(align_len0_carry__6_n_7),
        .Q(\align_len_reg_n_2_[31] ),
        .R(SR));
  FDRE \align_len_reg[3] 
       (.C(ap_clk),
        .CE(align_len),
        .D(align_len0_carry_n_7),
        .Q(\align_len_reg_n_2_[3] ),
        .R(SR));
  FDRE \align_len_reg[4] 
       (.C(ap_clk),
        .CE(align_len),
        .D(align_len0_carry_n_6),
        .Q(\align_len_reg_n_2_[4] ),
        .R(SR));
  FDRE \align_len_reg[5] 
       (.C(ap_clk),
        .CE(align_len),
        .D(align_len0_carry__0_n_9),
        .Q(\align_len_reg_n_2_[5] ),
        .R(SR));
  FDRE \align_len_reg[6] 
       (.C(ap_clk),
        .CE(align_len),
        .D(align_len0_carry__0_n_8),
        .Q(\align_len_reg_n_2_[6] ),
        .R(SR));
  FDRE \align_len_reg[7] 
       (.C(ap_clk),
        .CE(align_len),
        .D(align_len0_carry__0_n_7),
        .Q(\align_len_reg_n_2_[7] ),
        .R(SR));
  FDRE \align_len_reg[8] 
       (.C(ap_clk),
        .CE(align_len),
        .D(align_len0_carry__0_n_6),
        .Q(\align_len_reg_n_2_[8] ),
        .R(SR));
  FDRE \align_len_reg[9] 
       (.C(ap_clk),
        .CE(align_len),
        .D(align_len0_carry__1_n_9),
        .Q(\align_len_reg_n_2_[9] ),
        .R(SR));
  FDRE \beat_len_buf_reg[0] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\align_len_reg_n_2_[2] ),
        .Q(\beat_len_buf_reg_n_2_[0] ),
        .R(SR));
  FDRE \beat_len_buf_reg[1] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\align_len_reg_n_2_[3] ),
        .Q(\beat_len_buf_reg_n_2_[1] ),
        .R(SR));
  FDRE \beat_len_buf_reg[2] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\align_len_reg_n_2_[4] ),
        .Q(\beat_len_buf_reg_n_2_[2] ),
        .R(SR));
  FDRE \beat_len_buf_reg[3] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\align_len_reg_n_2_[5] ),
        .Q(\beat_len_buf_reg_n_2_[3] ),
        .R(SR));
  FDRE \beat_len_buf_reg[4] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\align_len_reg_n_2_[6] ),
        .Q(\beat_len_buf_reg_n_2_[4] ),
        .R(SR));
  FDRE \beat_len_buf_reg[5] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\align_len_reg_n_2_[7] ),
        .Q(\beat_len_buf_reg_n_2_[5] ),
        .R(SR));
  FDRE \beat_len_buf_reg[6] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\align_len_reg_n_2_[8] ),
        .Q(\beat_len_buf_reg_n_2_[6] ),
        .R(SR));
  FDRE \beat_len_buf_reg[7] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\align_len_reg_n_2_[9] ),
        .Q(\beat_len_buf_reg_n_2_[7] ),
        .R(SR));
  FDRE \beat_len_buf_reg[8] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\align_len_reg_n_2_[10] ),
        .Q(\beat_len_buf_reg_n_2_[8] ),
        .R(SR));
  FDRE \beat_len_buf_reg[9] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\align_len_reg_n_2_[11] ),
        .Q(\beat_len_buf_reg_n_2_[9] ),
        .R(SR));
  design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_buffer__parameterized0 buff_rdata
       (.D(D),
        .DI(DI),
        .Q(\usedw_reg[5] ),
        .S(S),
        .SR(SR),
        .ap_clk(ap_clk),
        .ap_rst_n(ap_rst_n),
        .beat_valid(beat_valid),
        .\dout_buf_reg[34]_0 ({data_pack,buff_rdata_n_22,buff_rdata_n_23,buff_rdata_n_24,buff_rdata_n_25,buff_rdata_n_26,buff_rdata_n_27,buff_rdata_n_28,buff_rdata_n_29,buff_rdata_n_30,buff_rdata_n_31,buff_rdata_n_32,buff_rdata_n_33,buff_rdata_n_34,buff_rdata_n_35,buff_rdata_n_36,buff_rdata_n_37,buff_rdata_n_38,buff_rdata_n_39,buff_rdata_n_40,buff_rdata_n_41,buff_rdata_n_42,buff_rdata_n_43,buff_rdata_n_44,buff_rdata_n_45,buff_rdata_n_46,buff_rdata_n_47,buff_rdata_n_48,buff_rdata_n_49,buff_rdata_n_50,buff_rdata_n_51,buff_rdata_n_52,buff_rdata_n_53}),
        .dout_valid_reg_0(buff_rdata_n_13),
        .dout_valid_reg_1(\bus_equal_gen.rdata_valid_t_reg_n_2 ),
        .full_n_reg_0(full_n_reg),
        .m_axi_gmem_RRESP(m_axi_gmem_RRESP),
        .m_axi_gmem_RVALID(m_axi_gmem_RVALID),
        .next_beat(next_beat),
        .rdata_ack_t(rdata_ack_t),
        .\usedw_reg[6]_0 (\usedw_reg[6] ),
        .\usedw_reg[7]_0 (\usedw_reg[7] ));
  FDRE \bus_equal_gen.data_buf_reg[0] 
       (.C(ap_clk),
        .CE(next_beat),
        .D(buff_rdata_n_53),
        .Q(\bus_equal_gen.data_buf [0]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[10] 
       (.C(ap_clk),
        .CE(next_beat),
        .D(buff_rdata_n_43),
        .Q(\bus_equal_gen.data_buf [10]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[11] 
       (.C(ap_clk),
        .CE(next_beat),
        .D(buff_rdata_n_42),
        .Q(\bus_equal_gen.data_buf [11]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[12] 
       (.C(ap_clk),
        .CE(next_beat),
        .D(buff_rdata_n_41),
        .Q(\bus_equal_gen.data_buf [12]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[13] 
       (.C(ap_clk),
        .CE(next_beat),
        .D(buff_rdata_n_40),
        .Q(\bus_equal_gen.data_buf [13]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[14] 
       (.C(ap_clk),
        .CE(next_beat),
        .D(buff_rdata_n_39),
        .Q(\bus_equal_gen.data_buf [14]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[15] 
       (.C(ap_clk),
        .CE(next_beat),
        .D(buff_rdata_n_38),
        .Q(\bus_equal_gen.data_buf [15]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[16] 
       (.C(ap_clk),
        .CE(next_beat),
        .D(buff_rdata_n_37),
        .Q(\bus_equal_gen.data_buf [16]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[17] 
       (.C(ap_clk),
        .CE(next_beat),
        .D(buff_rdata_n_36),
        .Q(\bus_equal_gen.data_buf [17]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[18] 
       (.C(ap_clk),
        .CE(next_beat),
        .D(buff_rdata_n_35),
        .Q(\bus_equal_gen.data_buf [18]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[19] 
       (.C(ap_clk),
        .CE(next_beat),
        .D(buff_rdata_n_34),
        .Q(\bus_equal_gen.data_buf [19]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[1] 
       (.C(ap_clk),
        .CE(next_beat),
        .D(buff_rdata_n_52),
        .Q(\bus_equal_gen.data_buf [1]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[20] 
       (.C(ap_clk),
        .CE(next_beat),
        .D(buff_rdata_n_33),
        .Q(\bus_equal_gen.data_buf [20]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[21] 
       (.C(ap_clk),
        .CE(next_beat),
        .D(buff_rdata_n_32),
        .Q(\bus_equal_gen.data_buf [21]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[22] 
       (.C(ap_clk),
        .CE(next_beat),
        .D(buff_rdata_n_31),
        .Q(\bus_equal_gen.data_buf [22]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[23] 
       (.C(ap_clk),
        .CE(next_beat),
        .D(buff_rdata_n_30),
        .Q(\bus_equal_gen.data_buf [23]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[24] 
       (.C(ap_clk),
        .CE(next_beat),
        .D(buff_rdata_n_29),
        .Q(\bus_equal_gen.data_buf [24]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[25] 
       (.C(ap_clk),
        .CE(next_beat),
        .D(buff_rdata_n_28),
        .Q(\bus_equal_gen.data_buf [25]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[26] 
       (.C(ap_clk),
        .CE(next_beat),
        .D(buff_rdata_n_27),
        .Q(\bus_equal_gen.data_buf [26]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[27] 
       (.C(ap_clk),
        .CE(next_beat),
        .D(buff_rdata_n_26),
        .Q(\bus_equal_gen.data_buf [27]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[28] 
       (.C(ap_clk),
        .CE(next_beat),
        .D(buff_rdata_n_25),
        .Q(\bus_equal_gen.data_buf [28]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[29] 
       (.C(ap_clk),
        .CE(next_beat),
        .D(buff_rdata_n_24),
        .Q(\bus_equal_gen.data_buf [29]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[2] 
       (.C(ap_clk),
        .CE(next_beat),
        .D(buff_rdata_n_51),
        .Q(\bus_equal_gen.data_buf [2]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[30] 
       (.C(ap_clk),
        .CE(next_beat),
        .D(buff_rdata_n_23),
        .Q(\bus_equal_gen.data_buf [30]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[31] 
       (.C(ap_clk),
        .CE(next_beat),
        .D(buff_rdata_n_22),
        .Q(\bus_equal_gen.data_buf [31]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[3] 
       (.C(ap_clk),
        .CE(next_beat),
        .D(buff_rdata_n_50),
        .Q(\bus_equal_gen.data_buf [3]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[4] 
       (.C(ap_clk),
        .CE(next_beat),
        .D(buff_rdata_n_49),
        .Q(\bus_equal_gen.data_buf [4]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[5] 
       (.C(ap_clk),
        .CE(next_beat),
        .D(buff_rdata_n_48),
        .Q(\bus_equal_gen.data_buf [5]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[6] 
       (.C(ap_clk),
        .CE(next_beat),
        .D(buff_rdata_n_47),
        .Q(\bus_equal_gen.data_buf [6]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[7] 
       (.C(ap_clk),
        .CE(next_beat),
        .D(buff_rdata_n_46),
        .Q(\bus_equal_gen.data_buf [7]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[8] 
       (.C(ap_clk),
        .CE(next_beat),
        .D(buff_rdata_n_45),
        .Q(\bus_equal_gen.data_buf [8]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[9] 
       (.C(ap_clk),
        .CE(next_beat),
        .D(buff_rdata_n_44),
        .Q(\bus_equal_gen.data_buf [9]),
        .R(1'b0));
  FDRE \bus_equal_gen.rdata_valid_t_reg 
       (.C(ap_clk),
        .CE(1'b1),
        .D(buff_rdata_n_13),
        .Q(\bus_equal_gen.rdata_valid_t_reg_n_2 ),
        .R(SR));
  FDRE \could_multi_bursts.ARVALID_Dummy_reg 
       (.C(ap_clk),
        .CE(1'b1),
        .D(fifo_rctl_n_2),
        .Q(\could_multi_bursts.ARVALID_Dummy_reg_0 ),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair98" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.araddr_buf[10]_i_1 
       (.I0(\could_multi_bursts.araddr_buf_reg[12]_i_2_n_8 ),
        .I1(\could_multi_bursts.araddr_buf[31]_i_4_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[10] ),
        .O(araddr_tmp[10]));
  (* SOFT_HLUTNM = "soft_lutpair99" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.araddr_buf[11]_i_1 
       (.I0(\could_multi_bursts.araddr_buf_reg[12]_i_2_n_7 ),
        .I1(\could_multi_bursts.araddr_buf[31]_i_4_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[11] ),
        .O(araddr_tmp[11]));
  (* SOFT_HLUTNM = "soft_lutpair99" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.araddr_buf[12]_i_1 
       (.I0(\could_multi_bursts.araddr_buf_reg[12]_i_2_n_6 ),
        .I1(\could_multi_bursts.araddr_buf[31]_i_4_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[12] ),
        .O(araddr_tmp[12]));
  (* SOFT_HLUTNM = "soft_lutpair98" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.araddr_buf[13]_i_1 
       (.I0(\could_multi_bursts.araddr_buf_reg[16]_i_2_n_9 ),
        .I1(\could_multi_bursts.araddr_buf[31]_i_4_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[13] ),
        .O(araddr_tmp[13]));
  (* SOFT_HLUTNM = "soft_lutpair96" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.araddr_buf[14]_i_1 
       (.I0(\could_multi_bursts.araddr_buf_reg[16]_i_2_n_8 ),
        .I1(\could_multi_bursts.araddr_buf[31]_i_4_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[14] ),
        .O(araddr_tmp[14]));
  (* SOFT_HLUTNM = "soft_lutpair97" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.araddr_buf[15]_i_1 
       (.I0(\could_multi_bursts.araddr_buf_reg[16]_i_2_n_7 ),
        .I1(\could_multi_bursts.araddr_buf[31]_i_4_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[15] ),
        .O(araddr_tmp[15]));
  (* SOFT_HLUTNM = "soft_lutpair97" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.araddr_buf[16]_i_1 
       (.I0(\could_multi_bursts.araddr_buf_reg[16]_i_2_n_6 ),
        .I1(\could_multi_bursts.araddr_buf[31]_i_4_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[16] ),
        .O(araddr_tmp[16]));
  (* SOFT_HLUTNM = "soft_lutpair95" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.araddr_buf[17]_i_1 
       (.I0(\could_multi_bursts.araddr_buf_reg[20]_i_2_n_9 ),
        .I1(\could_multi_bursts.araddr_buf[31]_i_4_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[17] ),
        .O(araddr_tmp[17]));
  (* SOFT_HLUTNM = "soft_lutpair94" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.araddr_buf[18]_i_1 
       (.I0(\could_multi_bursts.araddr_buf_reg[20]_i_2_n_8 ),
        .I1(\could_multi_bursts.araddr_buf[31]_i_4_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[18] ),
        .O(araddr_tmp[18]));
  (* SOFT_HLUTNM = "soft_lutpair96" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.araddr_buf[19]_i_1 
       (.I0(\could_multi_bursts.araddr_buf_reg[20]_i_2_n_7 ),
        .I1(\could_multi_bursts.araddr_buf[31]_i_4_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[19] ),
        .O(araddr_tmp[19]));
  (* SOFT_HLUTNM = "soft_lutpair95" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.araddr_buf[20]_i_1 
       (.I0(\could_multi_bursts.araddr_buf_reg[20]_i_2_n_6 ),
        .I1(\could_multi_bursts.araddr_buf[31]_i_4_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[20] ),
        .O(araddr_tmp[20]));
  (* SOFT_HLUTNM = "soft_lutpair94" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.araddr_buf[21]_i_1 
       (.I0(\could_multi_bursts.araddr_buf_reg[24]_i_2_n_9 ),
        .I1(\could_multi_bursts.araddr_buf[31]_i_4_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[21] ),
        .O(araddr_tmp[21]));
  (* SOFT_HLUTNM = "soft_lutpair92" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.araddr_buf[22]_i_1 
       (.I0(\could_multi_bursts.araddr_buf_reg[24]_i_2_n_8 ),
        .I1(\could_multi_bursts.araddr_buf[31]_i_4_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[22] ),
        .O(araddr_tmp[22]));
  (* SOFT_HLUTNM = "soft_lutpair93" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.araddr_buf[23]_i_1 
       (.I0(\could_multi_bursts.araddr_buf_reg[24]_i_2_n_7 ),
        .I1(\could_multi_bursts.araddr_buf[31]_i_4_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[23] ),
        .O(araddr_tmp[23]));
  (* SOFT_HLUTNM = "soft_lutpair93" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.araddr_buf[24]_i_1 
       (.I0(\could_multi_bursts.araddr_buf_reg[24]_i_2_n_6 ),
        .I1(\could_multi_bursts.araddr_buf[31]_i_4_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[24] ),
        .O(araddr_tmp[24]));
  (* SOFT_HLUTNM = "soft_lutpair92" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.araddr_buf[25]_i_1 
       (.I0(\could_multi_bursts.araddr_buf_reg[28]_i_2_n_9 ),
        .I1(\could_multi_bursts.araddr_buf[31]_i_4_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[25] ),
        .O(araddr_tmp[25]));
  (* SOFT_HLUTNM = "soft_lutpair90" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.araddr_buf[26]_i_1 
       (.I0(\could_multi_bursts.araddr_buf_reg[28]_i_2_n_8 ),
        .I1(\could_multi_bursts.araddr_buf[31]_i_4_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[26] ),
        .O(araddr_tmp[26]));
  (* SOFT_HLUTNM = "soft_lutpair91" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.araddr_buf[27]_i_1 
       (.I0(\could_multi_bursts.araddr_buf_reg[28]_i_2_n_7 ),
        .I1(\could_multi_bursts.araddr_buf[31]_i_4_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[27] ),
        .O(araddr_tmp[27]));
  (* SOFT_HLUTNM = "soft_lutpair91" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.araddr_buf[28]_i_1 
       (.I0(\could_multi_bursts.araddr_buf_reg[28]_i_2_n_6 ),
        .I1(\could_multi_bursts.araddr_buf[31]_i_4_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[28] ),
        .O(araddr_tmp[28]));
  (* SOFT_HLUTNM = "soft_lutpair89" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.araddr_buf[29]_i_1 
       (.I0(\could_multi_bursts.araddr_buf_reg[31]_i_3_n_9 ),
        .I1(\could_multi_bursts.araddr_buf[31]_i_4_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[29] ),
        .O(araddr_tmp[29]));
  (* SOFT_HLUTNM = "soft_lutpair114" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.araddr_buf[2]_i_1 
       (.I0(\could_multi_bursts.araddr_buf_reg[4]_i_2_n_8 ),
        .I1(\could_multi_bursts.araddr_buf[31]_i_4_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[2] ),
        .O(araddr_tmp[2]));
  (* SOFT_HLUTNM = "soft_lutpair89" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.araddr_buf[30]_i_1 
       (.I0(\could_multi_bursts.araddr_buf_reg[31]_i_3_n_8 ),
        .I1(\could_multi_bursts.araddr_buf[31]_i_4_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[30] ),
        .O(araddr_tmp[30]));
  (* SOFT_HLUTNM = "soft_lutpair90" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.araddr_buf[31]_i_2 
       (.I0(\could_multi_bursts.araddr_buf_reg[31]_i_3_n_7 ),
        .I1(\could_multi_bursts.araddr_buf[31]_i_4_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[31] ),
        .O(araddr_tmp[31]));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \could_multi_bursts.araddr_buf[31]_i_4 
       (.I0(\could_multi_bursts.loop_cnt_reg__0 [1]),
        .I1(\could_multi_bursts.loop_cnt_reg__0 [0]),
        .I2(\could_multi_bursts.loop_cnt_reg__0 [2]),
        .I3(\could_multi_bursts.loop_cnt_reg__0 [5]),
        .I4(\could_multi_bursts.loop_cnt_reg__0 [4]),
        .I5(\could_multi_bursts.loop_cnt_reg__0 [3]),
        .O(\could_multi_bursts.araddr_buf[31]_i_4_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair112" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.araddr_buf[3]_i_1 
       (.I0(\could_multi_bursts.araddr_buf_reg[4]_i_2_n_7 ),
        .I1(\could_multi_bursts.araddr_buf[31]_i_4_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[3] ),
        .O(araddr_tmp[3]));
  (* SOFT_HLUTNM = "soft_lutpair114" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.araddr_buf[4]_i_1 
       (.I0(\could_multi_bursts.araddr_buf_reg[4]_i_2_n_6 ),
        .I1(\could_multi_bursts.araddr_buf[31]_i_4_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[4] ),
        .O(araddr_tmp[4]));
  LUT4 #(
    .INIT(16'h956A)) 
    \could_multi_bursts.araddr_buf[4]_i_3 
       (.I0(m_axi_gmem_ARADDR[2]),
        .I1(\could_multi_bursts.arlen_buf_reg[3]_0 [1]),
        .I2(\could_multi_bursts.arlen_buf_reg[3]_0 [0]),
        .I3(\could_multi_bursts.arlen_buf_reg[3]_0 [2]),
        .O(\could_multi_bursts.araddr_buf[4]_i_3_n_2 ));
  LUT3 #(
    .INIT(8'h96)) 
    \could_multi_bursts.araddr_buf[4]_i_4 
       (.I0(m_axi_gmem_ARADDR[1]),
        .I1(\could_multi_bursts.arlen_buf_reg[3]_0 [0]),
        .I2(\could_multi_bursts.arlen_buf_reg[3]_0 [1]),
        .O(\could_multi_bursts.araddr_buf[4]_i_4_n_2 ));
  LUT2 #(
    .INIT(4'h9)) 
    \could_multi_bursts.araddr_buf[4]_i_5 
       (.I0(m_axi_gmem_ARADDR[0]),
        .I1(\could_multi_bursts.arlen_buf_reg[3]_0 [0]),
        .O(\could_multi_bursts.araddr_buf[4]_i_5_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair112" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.araddr_buf[5]_i_1 
       (.I0(\could_multi_bursts.araddr_buf_reg[8]_i_2_n_9 ),
        .I1(\could_multi_bursts.araddr_buf[31]_i_4_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[5] ),
        .O(araddr_tmp[5]));
  (* SOFT_HLUTNM = "soft_lutpair100" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.araddr_buf[6]_i_1 
       (.I0(\could_multi_bursts.araddr_buf_reg[8]_i_2_n_8 ),
        .I1(\could_multi_bursts.araddr_buf[31]_i_4_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[6] ),
        .O(araddr_tmp[6]));
  (* SOFT_HLUTNM = "soft_lutpair101" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.araddr_buf[7]_i_1 
       (.I0(\could_multi_bursts.araddr_buf_reg[8]_i_2_n_7 ),
        .I1(\could_multi_bursts.araddr_buf[31]_i_4_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[7] ),
        .O(araddr_tmp[7]));
  (* SOFT_HLUTNM = "soft_lutpair101" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.araddr_buf[8]_i_1 
       (.I0(\could_multi_bursts.araddr_buf_reg[8]_i_2_n_6 ),
        .I1(\could_multi_bursts.araddr_buf[31]_i_4_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[8] ),
        .O(araddr_tmp[8]));
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    \could_multi_bursts.araddr_buf[8]_i_3 
       (.I0(m_axi_gmem_ARADDR[4]),
        .I1(\could_multi_bursts.arlen_buf_reg[3]_0 [2]),
        .I2(\could_multi_bursts.arlen_buf_reg[3]_0 [0]),
        .I3(\could_multi_bursts.arlen_buf_reg[3]_0 [1]),
        .I4(\could_multi_bursts.arlen_buf_reg[3]_0 [3]),
        .O(\could_multi_bursts.araddr_buf[8]_i_3_n_2 ));
  LUT5 #(
    .INIT(32'h95556AAA)) 
    \could_multi_bursts.araddr_buf[8]_i_4 
       (.I0(m_axi_gmem_ARADDR[3]),
        .I1(\could_multi_bursts.arlen_buf_reg[3]_0 [2]),
        .I2(\could_multi_bursts.arlen_buf_reg[3]_0 [0]),
        .I3(\could_multi_bursts.arlen_buf_reg[3]_0 [1]),
        .I4(\could_multi_bursts.arlen_buf_reg[3]_0 [3]),
        .O(\could_multi_bursts.araddr_buf[8]_i_4_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair100" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.araddr_buf[9]_i_1 
       (.I0(\could_multi_bursts.araddr_buf_reg[12]_i_2_n_9 ),
        .I1(\could_multi_bursts.araddr_buf[31]_i_4_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[9] ),
        .O(araddr_tmp[9]));
  FDRE \could_multi_bursts.araddr_buf_reg[10] 
       (.C(ap_clk),
        .CE(push),
        .D(araddr_tmp[10]),
        .Q(m_axi_gmem_ARADDR[8]),
        .R(SR));
  FDRE \could_multi_bursts.araddr_buf_reg[11] 
       (.C(ap_clk),
        .CE(push),
        .D(araddr_tmp[11]),
        .Q(m_axi_gmem_ARADDR[9]),
        .R(SR));
  FDRE \could_multi_bursts.araddr_buf_reg[12] 
       (.C(ap_clk),
        .CE(push),
        .D(araddr_tmp[12]),
        .Q(m_axi_gmem_ARADDR[10]),
        .R(SR));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \could_multi_bursts.araddr_buf_reg[12]_i_2 
       (.CI(\could_multi_bursts.araddr_buf_reg[8]_i_2_n_2 ),
        .CO({\could_multi_bursts.araddr_buf_reg[12]_i_2_n_2 ,\could_multi_bursts.araddr_buf_reg[12]_i_2_n_3 ,\could_multi_bursts.araddr_buf_reg[12]_i_2_n_4 ,\could_multi_bursts.araddr_buf_reg[12]_i_2_n_5 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,m_axi_gmem_ARADDR[8:7]}),
        .O({\could_multi_bursts.araddr_buf_reg[12]_i_2_n_6 ,\could_multi_bursts.araddr_buf_reg[12]_i_2_n_7 ,\could_multi_bursts.araddr_buf_reg[12]_i_2_n_8 ,\could_multi_bursts.araddr_buf_reg[12]_i_2_n_9 }),
        .S(m_axi_gmem_ARADDR[10:7]));
  FDRE \could_multi_bursts.araddr_buf_reg[13] 
       (.C(ap_clk),
        .CE(push),
        .D(araddr_tmp[13]),
        .Q(m_axi_gmem_ARADDR[11]),
        .R(SR));
  FDRE \could_multi_bursts.araddr_buf_reg[14] 
       (.C(ap_clk),
        .CE(push),
        .D(araddr_tmp[14]),
        .Q(m_axi_gmem_ARADDR[12]),
        .R(SR));
  FDRE \could_multi_bursts.araddr_buf_reg[15] 
       (.C(ap_clk),
        .CE(push),
        .D(araddr_tmp[15]),
        .Q(m_axi_gmem_ARADDR[13]),
        .R(SR));
  FDRE \could_multi_bursts.araddr_buf_reg[16] 
       (.C(ap_clk),
        .CE(push),
        .D(araddr_tmp[16]),
        .Q(m_axi_gmem_ARADDR[14]),
        .R(SR));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \could_multi_bursts.araddr_buf_reg[16]_i_2 
       (.CI(\could_multi_bursts.araddr_buf_reg[12]_i_2_n_2 ),
        .CO({\could_multi_bursts.araddr_buf_reg[16]_i_2_n_2 ,\could_multi_bursts.araddr_buf_reg[16]_i_2_n_3 ,\could_multi_bursts.araddr_buf_reg[16]_i_2_n_4 ,\could_multi_bursts.araddr_buf_reg[16]_i_2_n_5 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\could_multi_bursts.araddr_buf_reg[16]_i_2_n_6 ,\could_multi_bursts.araddr_buf_reg[16]_i_2_n_7 ,\could_multi_bursts.araddr_buf_reg[16]_i_2_n_8 ,\could_multi_bursts.araddr_buf_reg[16]_i_2_n_9 }),
        .S(m_axi_gmem_ARADDR[14:11]));
  FDRE \could_multi_bursts.araddr_buf_reg[17] 
       (.C(ap_clk),
        .CE(push),
        .D(araddr_tmp[17]),
        .Q(m_axi_gmem_ARADDR[15]),
        .R(SR));
  FDRE \could_multi_bursts.araddr_buf_reg[18] 
       (.C(ap_clk),
        .CE(push),
        .D(araddr_tmp[18]),
        .Q(m_axi_gmem_ARADDR[16]),
        .R(SR));
  FDRE \could_multi_bursts.araddr_buf_reg[19] 
       (.C(ap_clk),
        .CE(push),
        .D(araddr_tmp[19]),
        .Q(m_axi_gmem_ARADDR[17]),
        .R(SR));
  FDRE \could_multi_bursts.araddr_buf_reg[20] 
       (.C(ap_clk),
        .CE(push),
        .D(araddr_tmp[20]),
        .Q(m_axi_gmem_ARADDR[18]),
        .R(SR));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \could_multi_bursts.araddr_buf_reg[20]_i_2 
       (.CI(\could_multi_bursts.araddr_buf_reg[16]_i_2_n_2 ),
        .CO({\could_multi_bursts.araddr_buf_reg[20]_i_2_n_2 ,\could_multi_bursts.araddr_buf_reg[20]_i_2_n_3 ,\could_multi_bursts.araddr_buf_reg[20]_i_2_n_4 ,\could_multi_bursts.araddr_buf_reg[20]_i_2_n_5 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\could_multi_bursts.araddr_buf_reg[20]_i_2_n_6 ,\could_multi_bursts.araddr_buf_reg[20]_i_2_n_7 ,\could_multi_bursts.araddr_buf_reg[20]_i_2_n_8 ,\could_multi_bursts.araddr_buf_reg[20]_i_2_n_9 }),
        .S(m_axi_gmem_ARADDR[18:15]));
  FDRE \could_multi_bursts.araddr_buf_reg[21] 
       (.C(ap_clk),
        .CE(push),
        .D(araddr_tmp[21]),
        .Q(m_axi_gmem_ARADDR[19]),
        .R(SR));
  FDRE \could_multi_bursts.araddr_buf_reg[22] 
       (.C(ap_clk),
        .CE(push),
        .D(araddr_tmp[22]),
        .Q(m_axi_gmem_ARADDR[20]),
        .R(SR));
  FDRE \could_multi_bursts.araddr_buf_reg[23] 
       (.C(ap_clk),
        .CE(push),
        .D(araddr_tmp[23]),
        .Q(m_axi_gmem_ARADDR[21]),
        .R(SR));
  FDRE \could_multi_bursts.araddr_buf_reg[24] 
       (.C(ap_clk),
        .CE(push),
        .D(araddr_tmp[24]),
        .Q(m_axi_gmem_ARADDR[22]),
        .R(SR));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \could_multi_bursts.araddr_buf_reg[24]_i_2 
       (.CI(\could_multi_bursts.araddr_buf_reg[20]_i_2_n_2 ),
        .CO({\could_multi_bursts.araddr_buf_reg[24]_i_2_n_2 ,\could_multi_bursts.araddr_buf_reg[24]_i_2_n_3 ,\could_multi_bursts.araddr_buf_reg[24]_i_2_n_4 ,\could_multi_bursts.araddr_buf_reg[24]_i_2_n_5 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\could_multi_bursts.araddr_buf_reg[24]_i_2_n_6 ,\could_multi_bursts.araddr_buf_reg[24]_i_2_n_7 ,\could_multi_bursts.araddr_buf_reg[24]_i_2_n_8 ,\could_multi_bursts.araddr_buf_reg[24]_i_2_n_9 }),
        .S(m_axi_gmem_ARADDR[22:19]));
  FDRE \could_multi_bursts.araddr_buf_reg[25] 
       (.C(ap_clk),
        .CE(push),
        .D(araddr_tmp[25]),
        .Q(m_axi_gmem_ARADDR[23]),
        .R(SR));
  FDRE \could_multi_bursts.araddr_buf_reg[26] 
       (.C(ap_clk),
        .CE(push),
        .D(araddr_tmp[26]),
        .Q(m_axi_gmem_ARADDR[24]),
        .R(SR));
  FDRE \could_multi_bursts.araddr_buf_reg[27] 
       (.C(ap_clk),
        .CE(push),
        .D(araddr_tmp[27]),
        .Q(m_axi_gmem_ARADDR[25]),
        .R(SR));
  FDRE \could_multi_bursts.araddr_buf_reg[28] 
       (.C(ap_clk),
        .CE(push),
        .D(araddr_tmp[28]),
        .Q(m_axi_gmem_ARADDR[26]),
        .R(SR));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \could_multi_bursts.araddr_buf_reg[28]_i_2 
       (.CI(\could_multi_bursts.araddr_buf_reg[24]_i_2_n_2 ),
        .CO({\could_multi_bursts.araddr_buf_reg[28]_i_2_n_2 ,\could_multi_bursts.araddr_buf_reg[28]_i_2_n_3 ,\could_multi_bursts.araddr_buf_reg[28]_i_2_n_4 ,\could_multi_bursts.araddr_buf_reg[28]_i_2_n_5 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\could_multi_bursts.araddr_buf_reg[28]_i_2_n_6 ,\could_multi_bursts.araddr_buf_reg[28]_i_2_n_7 ,\could_multi_bursts.araddr_buf_reg[28]_i_2_n_8 ,\could_multi_bursts.araddr_buf_reg[28]_i_2_n_9 }),
        .S(m_axi_gmem_ARADDR[26:23]));
  FDRE \could_multi_bursts.araddr_buf_reg[29] 
       (.C(ap_clk),
        .CE(push),
        .D(araddr_tmp[29]),
        .Q(m_axi_gmem_ARADDR[27]),
        .R(SR));
  FDRE \could_multi_bursts.araddr_buf_reg[2] 
       (.C(ap_clk),
        .CE(push),
        .D(araddr_tmp[2]),
        .Q(m_axi_gmem_ARADDR[0]),
        .R(SR));
  FDRE \could_multi_bursts.araddr_buf_reg[30] 
       (.C(ap_clk),
        .CE(push),
        .D(araddr_tmp[30]),
        .Q(m_axi_gmem_ARADDR[28]),
        .R(SR));
  FDRE \could_multi_bursts.araddr_buf_reg[31] 
       (.C(ap_clk),
        .CE(push),
        .D(araddr_tmp[31]),
        .Q(m_axi_gmem_ARADDR[29]),
        .R(SR));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \could_multi_bursts.araddr_buf_reg[31]_i_3 
       (.CI(\could_multi_bursts.araddr_buf_reg[28]_i_2_n_2 ),
        .CO({\NLW_could_multi_bursts.araddr_buf_reg[31]_i_3_CO_UNCONNECTED [3:2],\could_multi_bursts.araddr_buf_reg[31]_i_3_n_4 ,\could_multi_bursts.araddr_buf_reg[31]_i_3_n_5 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_could_multi_bursts.araddr_buf_reg[31]_i_3_O_UNCONNECTED [3],\could_multi_bursts.araddr_buf_reg[31]_i_3_n_7 ,\could_multi_bursts.araddr_buf_reg[31]_i_3_n_8 ,\could_multi_bursts.araddr_buf_reg[31]_i_3_n_9 }),
        .S({1'b0,m_axi_gmem_ARADDR[29:27]}));
  FDRE \could_multi_bursts.araddr_buf_reg[3] 
       (.C(ap_clk),
        .CE(push),
        .D(araddr_tmp[3]),
        .Q(m_axi_gmem_ARADDR[1]),
        .R(SR));
  FDRE \could_multi_bursts.araddr_buf_reg[4] 
       (.C(ap_clk),
        .CE(push),
        .D(araddr_tmp[4]),
        .Q(m_axi_gmem_ARADDR[2]),
        .R(SR));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \could_multi_bursts.araddr_buf_reg[4]_i_2 
       (.CI(1'b0),
        .CO({\could_multi_bursts.araddr_buf_reg[4]_i_2_n_2 ,\could_multi_bursts.araddr_buf_reg[4]_i_2_n_3 ,\could_multi_bursts.araddr_buf_reg[4]_i_2_n_4 ,\could_multi_bursts.araddr_buf_reg[4]_i_2_n_5 }),
        .CYINIT(1'b0),
        .DI({m_axi_gmem_ARADDR[2:0],1'b0}),
        .O({\could_multi_bursts.araddr_buf_reg[4]_i_2_n_6 ,\could_multi_bursts.araddr_buf_reg[4]_i_2_n_7 ,\could_multi_bursts.araddr_buf_reg[4]_i_2_n_8 ,\NLW_could_multi_bursts.araddr_buf_reg[4]_i_2_O_UNCONNECTED [0]}),
        .S({\could_multi_bursts.araddr_buf[4]_i_3_n_2 ,\could_multi_bursts.araddr_buf[4]_i_4_n_2 ,\could_multi_bursts.araddr_buf[4]_i_5_n_2 ,1'b0}));
  FDRE \could_multi_bursts.araddr_buf_reg[5] 
       (.C(ap_clk),
        .CE(push),
        .D(araddr_tmp[5]),
        .Q(m_axi_gmem_ARADDR[3]),
        .R(SR));
  FDRE \could_multi_bursts.araddr_buf_reg[6] 
       (.C(ap_clk),
        .CE(push),
        .D(araddr_tmp[6]),
        .Q(m_axi_gmem_ARADDR[4]),
        .R(SR));
  FDRE \could_multi_bursts.araddr_buf_reg[7] 
       (.C(ap_clk),
        .CE(push),
        .D(araddr_tmp[7]),
        .Q(m_axi_gmem_ARADDR[5]),
        .R(SR));
  FDRE \could_multi_bursts.araddr_buf_reg[8] 
       (.C(ap_clk),
        .CE(push),
        .D(araddr_tmp[8]),
        .Q(m_axi_gmem_ARADDR[6]),
        .R(SR));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \could_multi_bursts.araddr_buf_reg[8]_i_2 
       (.CI(\could_multi_bursts.araddr_buf_reg[4]_i_2_n_2 ),
        .CO({\could_multi_bursts.araddr_buf_reg[8]_i_2_n_2 ,\could_multi_bursts.araddr_buf_reg[8]_i_2_n_3 ,\could_multi_bursts.araddr_buf_reg[8]_i_2_n_4 ,\could_multi_bursts.araddr_buf_reg[8]_i_2_n_5 }),
        .CYINIT(1'b0),
        .DI(m_axi_gmem_ARADDR[6:3]),
        .O({\could_multi_bursts.araddr_buf_reg[8]_i_2_n_6 ,\could_multi_bursts.araddr_buf_reg[8]_i_2_n_7 ,\could_multi_bursts.araddr_buf_reg[8]_i_2_n_8 ,\could_multi_bursts.araddr_buf_reg[8]_i_2_n_9 }),
        .S({m_axi_gmem_ARADDR[6:5],\could_multi_bursts.araddr_buf[8]_i_3_n_2 ,\could_multi_bursts.araddr_buf[8]_i_4_n_2 }));
  FDRE \could_multi_bursts.araddr_buf_reg[9] 
       (.C(ap_clk),
        .CE(push),
        .D(araddr_tmp[9]),
        .Q(m_axi_gmem_ARADDR[7]),
        .R(SR));
  LUT2 #(
    .INIT(4'hE)) 
    \could_multi_bursts.arlen_buf[3]_i_3 
       (.I0(fifo_rreq_n_26),
        .I1(fifo_rreq_n_25),
        .O(\could_multi_bursts.arlen_buf[3]_i_3_n_2 ));
  FDRE \could_multi_bursts.arlen_buf_reg[0] 
       (.C(ap_clk),
        .CE(fifo_rctl_n_27),
        .D(fifo_rctl_n_24),
        .Q(\could_multi_bursts.arlen_buf_reg[3]_0 [0]),
        .R(SR));
  FDRE \could_multi_bursts.arlen_buf_reg[1] 
       (.C(ap_clk),
        .CE(fifo_rctl_n_27),
        .D(fifo_rctl_n_25),
        .Q(\could_multi_bursts.arlen_buf_reg[3]_0 [1]),
        .R(SR));
  FDRE \could_multi_bursts.arlen_buf_reg[2] 
       (.C(ap_clk),
        .CE(fifo_rctl_n_27),
        .D(fifo_rctl_n_26),
        .Q(\could_multi_bursts.arlen_buf_reg[3]_0 [2]),
        .R(SR));
  FDRE \could_multi_bursts.arlen_buf_reg[3] 
       (.C(ap_clk),
        .CE(fifo_rctl_n_27),
        .D(fifo_rctl_n_28),
        .Q(\could_multi_bursts.arlen_buf_reg[3]_0 [3]),
        .R(SR));
  LUT1 #(
    .INIT(2'h1)) 
    \could_multi_bursts.loop_cnt[0]_i_1__0 
       (.I0(\could_multi_bursts.loop_cnt_reg__0 [0]),
        .O(p_0_in__2[0]));
  (* SOFT_HLUTNM = "soft_lutpair113" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \could_multi_bursts.loop_cnt[1]_i_1__0 
       (.I0(\could_multi_bursts.loop_cnt_reg__0 [0]),
        .I1(\could_multi_bursts.loop_cnt_reg__0 [1]),
        .O(p_0_in__2[1]));
  (* SOFT_HLUTNM = "soft_lutpair113" *) 
  LUT3 #(
    .INIT(8'h6A)) 
    \could_multi_bursts.loop_cnt[2]_i_1__0 
       (.I0(\could_multi_bursts.loop_cnt_reg__0 [2]),
        .I1(\could_multi_bursts.loop_cnt_reg__0 [1]),
        .I2(\could_multi_bursts.loop_cnt_reg__0 [0]),
        .O(p_0_in__2[2]));
  (* SOFT_HLUTNM = "soft_lutpair88" *) 
  LUT4 #(
    .INIT(16'h6AAA)) 
    \could_multi_bursts.loop_cnt[3]_i_1__0 
       (.I0(\could_multi_bursts.loop_cnt_reg__0 [3]),
        .I1(\could_multi_bursts.loop_cnt_reg__0 [0]),
        .I2(\could_multi_bursts.loop_cnt_reg__0 [1]),
        .I3(\could_multi_bursts.loop_cnt_reg__0 [2]),
        .O(p_0_in__2[3]));
  (* SOFT_HLUTNM = "soft_lutpair88" *) 
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    \could_multi_bursts.loop_cnt[4]_i_1__0 
       (.I0(\could_multi_bursts.loop_cnt_reg__0 [4]),
        .I1(\could_multi_bursts.loop_cnt_reg__0 [2]),
        .I2(\could_multi_bursts.loop_cnt_reg__0 [1]),
        .I3(\could_multi_bursts.loop_cnt_reg__0 [0]),
        .I4(\could_multi_bursts.loop_cnt_reg__0 [3]),
        .O(p_0_in__2[4]));
  LUT6 #(
    .INIT(64'h6AAAAAAAAAAAAAAA)) 
    \could_multi_bursts.loop_cnt[5]_i_2__0 
       (.I0(\could_multi_bursts.loop_cnt_reg__0 [5]),
        .I1(\could_multi_bursts.loop_cnt_reg__0 [3]),
        .I2(\could_multi_bursts.loop_cnt_reg__0 [0]),
        .I3(\could_multi_bursts.loop_cnt_reg__0 [1]),
        .I4(\could_multi_bursts.loop_cnt_reg__0 [2]),
        .I5(\could_multi_bursts.loop_cnt_reg__0 [4]),
        .O(p_0_in__2[5]));
  FDRE \could_multi_bursts.loop_cnt_reg[0] 
       (.C(ap_clk),
        .CE(push),
        .D(p_0_in__2[0]),
        .Q(\could_multi_bursts.loop_cnt_reg__0 [0]),
        .R(fifo_rctl_n_7));
  FDRE \could_multi_bursts.loop_cnt_reg[1] 
       (.C(ap_clk),
        .CE(push),
        .D(p_0_in__2[1]),
        .Q(\could_multi_bursts.loop_cnt_reg__0 [1]),
        .R(fifo_rctl_n_7));
  FDRE \could_multi_bursts.loop_cnt_reg[2] 
       (.C(ap_clk),
        .CE(push),
        .D(p_0_in__2[2]),
        .Q(\could_multi_bursts.loop_cnt_reg__0 [2]),
        .R(fifo_rctl_n_7));
  FDRE \could_multi_bursts.loop_cnt_reg[3] 
       (.C(ap_clk),
        .CE(push),
        .D(p_0_in__2[3]),
        .Q(\could_multi_bursts.loop_cnt_reg__0 [3]),
        .R(fifo_rctl_n_7));
  FDRE \could_multi_bursts.loop_cnt_reg[4] 
       (.C(ap_clk),
        .CE(push),
        .D(p_0_in__2[4]),
        .Q(\could_multi_bursts.loop_cnt_reg__0 [4]),
        .R(fifo_rctl_n_7));
  FDRE \could_multi_bursts.loop_cnt_reg[5] 
       (.C(ap_clk),
        .CE(push),
        .D(p_0_in__2[5]),
        .Q(\could_multi_bursts.loop_cnt_reg__0 [5]),
        .R(fifo_rctl_n_7));
  FDRE \could_multi_bursts.sect_handling_reg 
       (.C(ap_clk),
        .CE(1'b1),
        .D(fifo_rctl_n_11),
        .Q(\could_multi_bursts.sect_handling_reg_n_2 ),
        .R(SR));
  LUT2 #(
    .INIT(4'h6)) 
    \end_addr_buf[2]_i_1__0 
       (.I0(\start_addr_reg_n_2_[2] ),
        .I1(\align_len_reg_n_2_[2] ),
        .O(\end_addr_buf[2]_i_1__0_n_2 ));
  FDRE \end_addr_buf_reg[10] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(end_addr_carry__1_n_9),
        .Q(\end_addr_buf_reg_n_2_[10] ),
        .R(SR));
  FDRE \end_addr_buf_reg[11] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(end_addr_carry__1_n_8),
        .Q(\end_addr_buf_reg_n_2_[11] ),
        .R(SR));
  FDRE \end_addr_buf_reg[12] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(end_addr_carry__1_n_7),
        .Q(\end_addr_buf_reg_n_2_[12] ),
        .R(SR));
  FDRE \end_addr_buf_reg[13] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(end_addr_carry__1_n_6),
        .Q(\end_addr_buf_reg_n_2_[13] ),
        .R(SR));
  FDRE \end_addr_buf_reg[14] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(end_addr_carry__2_n_9),
        .Q(\end_addr_buf_reg_n_2_[14] ),
        .R(SR));
  FDRE \end_addr_buf_reg[15] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(end_addr_carry__2_n_8),
        .Q(\end_addr_buf_reg_n_2_[15] ),
        .R(SR));
  FDRE \end_addr_buf_reg[16] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(end_addr_carry__2_n_7),
        .Q(\end_addr_buf_reg_n_2_[16] ),
        .R(SR));
  FDRE \end_addr_buf_reg[17] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(end_addr_carry__2_n_6),
        .Q(\end_addr_buf_reg_n_2_[17] ),
        .R(SR));
  FDRE \end_addr_buf_reg[18] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(end_addr_carry__3_n_9),
        .Q(\end_addr_buf_reg_n_2_[18] ),
        .R(SR));
  FDRE \end_addr_buf_reg[19] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(end_addr_carry__3_n_8),
        .Q(\end_addr_buf_reg_n_2_[19] ),
        .R(SR));
  FDRE \end_addr_buf_reg[20] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(end_addr_carry__3_n_7),
        .Q(\end_addr_buf_reg_n_2_[20] ),
        .R(SR));
  FDRE \end_addr_buf_reg[21] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(end_addr_carry__3_n_6),
        .Q(\end_addr_buf_reg_n_2_[21] ),
        .R(SR));
  FDRE \end_addr_buf_reg[22] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(end_addr_carry__4_n_9),
        .Q(\end_addr_buf_reg_n_2_[22] ),
        .R(SR));
  FDRE \end_addr_buf_reg[23] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(end_addr_carry__4_n_8),
        .Q(\end_addr_buf_reg_n_2_[23] ),
        .R(SR));
  FDRE \end_addr_buf_reg[24] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(end_addr_carry__4_n_7),
        .Q(\end_addr_buf_reg_n_2_[24] ),
        .R(SR));
  FDRE \end_addr_buf_reg[25] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(end_addr_carry__4_n_6),
        .Q(\end_addr_buf_reg_n_2_[25] ),
        .R(SR));
  FDRE \end_addr_buf_reg[26] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(end_addr_carry__5_n_9),
        .Q(\end_addr_buf_reg_n_2_[26] ),
        .R(SR));
  FDRE \end_addr_buf_reg[27] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(end_addr_carry__5_n_8),
        .Q(\end_addr_buf_reg_n_2_[27] ),
        .R(SR));
  FDRE \end_addr_buf_reg[28] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(end_addr_carry__5_n_7),
        .Q(\end_addr_buf_reg_n_2_[28] ),
        .R(SR));
  FDRE \end_addr_buf_reg[29] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(end_addr_carry__5_n_6),
        .Q(\end_addr_buf_reg_n_2_[29] ),
        .R(SR));
  FDRE \end_addr_buf_reg[2] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\end_addr_buf[2]_i_1__0_n_2 ),
        .Q(\end_addr_buf_reg_n_2_[2] ),
        .R(SR));
  FDRE \end_addr_buf_reg[30] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(end_addr_carry__6_n_9),
        .Q(\end_addr_buf_reg_n_2_[30] ),
        .R(SR));
  FDRE \end_addr_buf_reg[31] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(end_addr_carry__6_n_8),
        .Q(\end_addr_buf_reg_n_2_[31] ),
        .R(SR));
  FDRE \end_addr_buf_reg[3] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(end_addr_carry_n_8),
        .Q(\end_addr_buf_reg_n_2_[3] ),
        .R(SR));
  FDRE \end_addr_buf_reg[4] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(end_addr_carry_n_7),
        .Q(\end_addr_buf_reg_n_2_[4] ),
        .R(SR));
  FDRE \end_addr_buf_reg[5] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(end_addr_carry_n_6),
        .Q(\end_addr_buf_reg_n_2_[5] ),
        .R(SR));
  FDRE \end_addr_buf_reg[6] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(end_addr_carry__0_n_9),
        .Q(\end_addr_buf_reg_n_2_[6] ),
        .R(SR));
  FDRE \end_addr_buf_reg[7] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(end_addr_carry__0_n_8),
        .Q(\end_addr_buf_reg_n_2_[7] ),
        .R(SR));
  FDRE \end_addr_buf_reg[8] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(end_addr_carry__0_n_7),
        .Q(\end_addr_buf_reg_n_2_[8] ),
        .R(SR));
  FDRE \end_addr_buf_reg[9] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(end_addr_carry__0_n_6),
        .Q(\end_addr_buf_reg_n_2_[9] ),
        .R(SR));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 end_addr_carry
       (.CI(1'b0),
        .CO({end_addr_carry_n_2,end_addr_carry_n_3,end_addr_carry_n_4,end_addr_carry_n_5}),
        .CYINIT(1'b0),
        .DI({\start_addr_reg_n_2_[5] ,\start_addr_reg_n_2_[4] ,\start_addr_reg_n_2_[3] ,\start_addr_reg_n_2_[2] }),
        .O({end_addr_carry_n_6,end_addr_carry_n_7,end_addr_carry_n_8,NLW_end_addr_carry_O_UNCONNECTED[0]}),
        .S({end_addr_carry_i_1__0_n_2,end_addr_carry_i_2__0_n_2,end_addr_carry_i_3__0_n_2,end_addr_carry_i_4__0_n_2}));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 end_addr_carry__0
       (.CI(end_addr_carry_n_2),
        .CO({end_addr_carry__0_n_2,end_addr_carry__0_n_3,end_addr_carry__0_n_4,end_addr_carry__0_n_5}),
        .CYINIT(1'b0),
        .DI({\start_addr_reg_n_2_[9] ,\start_addr_reg_n_2_[8] ,\start_addr_reg_n_2_[7] ,\start_addr_reg_n_2_[6] }),
        .O({end_addr_carry__0_n_6,end_addr_carry__0_n_7,end_addr_carry__0_n_8,end_addr_carry__0_n_9}),
        .S({end_addr_carry__0_i_1__0_n_2,end_addr_carry__0_i_2__0_n_2,end_addr_carry__0_i_3__0_n_2,end_addr_carry__0_i_4__0_n_2}));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__0_i_1__0
       (.I0(\start_addr_reg_n_2_[9] ),
        .I1(\align_len_reg_n_2_[9] ),
        .O(end_addr_carry__0_i_1__0_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__0_i_2__0
       (.I0(\start_addr_reg_n_2_[8] ),
        .I1(\align_len_reg_n_2_[8] ),
        .O(end_addr_carry__0_i_2__0_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__0_i_3__0
       (.I0(\start_addr_reg_n_2_[7] ),
        .I1(\align_len_reg_n_2_[7] ),
        .O(end_addr_carry__0_i_3__0_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__0_i_4__0
       (.I0(\start_addr_reg_n_2_[6] ),
        .I1(\align_len_reg_n_2_[6] ),
        .O(end_addr_carry__0_i_4__0_n_2));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 end_addr_carry__1
       (.CI(end_addr_carry__0_n_2),
        .CO({end_addr_carry__1_n_2,end_addr_carry__1_n_3,end_addr_carry__1_n_4,end_addr_carry__1_n_5}),
        .CYINIT(1'b0),
        .DI({\start_addr_reg_n_2_[13] ,\start_addr_reg_n_2_[12] ,\start_addr_reg_n_2_[11] ,\start_addr_reg_n_2_[10] }),
        .O({end_addr_carry__1_n_6,end_addr_carry__1_n_7,end_addr_carry__1_n_8,end_addr_carry__1_n_9}),
        .S({end_addr_carry__1_i_1__0_n_2,end_addr_carry__1_i_2__0_n_2,end_addr_carry__1_i_3__0_n_2,end_addr_carry__1_i_4__0_n_2}));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__1_i_1__0
       (.I0(\start_addr_reg_n_2_[13] ),
        .I1(\align_len_reg_n_2_[13] ),
        .O(end_addr_carry__1_i_1__0_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__1_i_2__0
       (.I0(\start_addr_reg_n_2_[12] ),
        .I1(\align_len_reg_n_2_[12] ),
        .O(end_addr_carry__1_i_2__0_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__1_i_3__0
       (.I0(\start_addr_reg_n_2_[11] ),
        .I1(\align_len_reg_n_2_[11] ),
        .O(end_addr_carry__1_i_3__0_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__1_i_4__0
       (.I0(\start_addr_reg_n_2_[10] ),
        .I1(\align_len_reg_n_2_[10] ),
        .O(end_addr_carry__1_i_4__0_n_2));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 end_addr_carry__2
       (.CI(end_addr_carry__1_n_2),
        .CO({end_addr_carry__2_n_2,end_addr_carry__2_n_3,end_addr_carry__2_n_4,end_addr_carry__2_n_5}),
        .CYINIT(1'b0),
        .DI({\start_addr_reg_n_2_[17] ,\start_addr_reg_n_2_[16] ,\start_addr_reg_n_2_[15] ,\start_addr_reg_n_2_[14] }),
        .O({end_addr_carry__2_n_6,end_addr_carry__2_n_7,end_addr_carry__2_n_8,end_addr_carry__2_n_9}),
        .S({end_addr_carry__2_i_1__0_n_2,end_addr_carry__2_i_2__0_n_2,end_addr_carry__2_i_3__0_n_2,end_addr_carry__2_i_4__0_n_2}));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__2_i_1__0
       (.I0(\start_addr_reg_n_2_[17] ),
        .I1(\align_len_reg_n_2_[17] ),
        .O(end_addr_carry__2_i_1__0_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__2_i_2__0
       (.I0(\start_addr_reg_n_2_[16] ),
        .I1(\align_len_reg_n_2_[16] ),
        .O(end_addr_carry__2_i_2__0_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__2_i_3__0
       (.I0(\start_addr_reg_n_2_[15] ),
        .I1(\align_len_reg_n_2_[15] ),
        .O(end_addr_carry__2_i_3__0_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__2_i_4__0
       (.I0(\start_addr_reg_n_2_[14] ),
        .I1(\align_len_reg_n_2_[14] ),
        .O(end_addr_carry__2_i_4__0_n_2));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 end_addr_carry__3
       (.CI(end_addr_carry__2_n_2),
        .CO({end_addr_carry__3_n_2,end_addr_carry__3_n_3,end_addr_carry__3_n_4,end_addr_carry__3_n_5}),
        .CYINIT(1'b0),
        .DI({\start_addr_reg_n_2_[21] ,\start_addr_reg_n_2_[20] ,\start_addr_reg_n_2_[19] ,\start_addr_reg_n_2_[18] }),
        .O({end_addr_carry__3_n_6,end_addr_carry__3_n_7,end_addr_carry__3_n_8,end_addr_carry__3_n_9}),
        .S({end_addr_carry__3_i_1__0_n_2,end_addr_carry__3_i_2__0_n_2,end_addr_carry__3_i_3__0_n_2,end_addr_carry__3_i_4__0_n_2}));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__3_i_1__0
       (.I0(\start_addr_reg_n_2_[21] ),
        .I1(\align_len_reg_n_2_[21] ),
        .O(end_addr_carry__3_i_1__0_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__3_i_2__0
       (.I0(\start_addr_reg_n_2_[20] ),
        .I1(\align_len_reg_n_2_[20] ),
        .O(end_addr_carry__3_i_2__0_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__3_i_3__0
       (.I0(\start_addr_reg_n_2_[19] ),
        .I1(\align_len_reg_n_2_[19] ),
        .O(end_addr_carry__3_i_3__0_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__3_i_4__0
       (.I0(\start_addr_reg_n_2_[18] ),
        .I1(\align_len_reg_n_2_[18] ),
        .O(end_addr_carry__3_i_4__0_n_2));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 end_addr_carry__4
       (.CI(end_addr_carry__3_n_2),
        .CO({end_addr_carry__4_n_2,end_addr_carry__4_n_3,end_addr_carry__4_n_4,end_addr_carry__4_n_5}),
        .CYINIT(1'b0),
        .DI({\start_addr_reg_n_2_[25] ,\start_addr_reg_n_2_[24] ,\start_addr_reg_n_2_[23] ,\start_addr_reg_n_2_[22] }),
        .O({end_addr_carry__4_n_6,end_addr_carry__4_n_7,end_addr_carry__4_n_8,end_addr_carry__4_n_9}),
        .S({end_addr_carry__4_i_1__0_n_2,end_addr_carry__4_i_2__0_n_2,end_addr_carry__4_i_3__0_n_2,end_addr_carry__4_i_4__0_n_2}));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__4_i_1__0
       (.I0(\start_addr_reg_n_2_[25] ),
        .I1(\align_len_reg_n_2_[25] ),
        .O(end_addr_carry__4_i_1__0_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__4_i_2__0
       (.I0(\start_addr_reg_n_2_[24] ),
        .I1(\align_len_reg_n_2_[24] ),
        .O(end_addr_carry__4_i_2__0_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__4_i_3__0
       (.I0(\start_addr_reg_n_2_[23] ),
        .I1(\align_len_reg_n_2_[23] ),
        .O(end_addr_carry__4_i_3__0_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__4_i_4__0
       (.I0(\start_addr_reg_n_2_[22] ),
        .I1(\align_len_reg_n_2_[22] ),
        .O(end_addr_carry__4_i_4__0_n_2));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 end_addr_carry__5
       (.CI(end_addr_carry__4_n_2),
        .CO({end_addr_carry__5_n_2,end_addr_carry__5_n_3,end_addr_carry__5_n_4,end_addr_carry__5_n_5}),
        .CYINIT(1'b0),
        .DI({\start_addr_reg_n_2_[29] ,\start_addr_reg_n_2_[28] ,\start_addr_reg_n_2_[27] ,\start_addr_reg_n_2_[26] }),
        .O({end_addr_carry__5_n_6,end_addr_carry__5_n_7,end_addr_carry__5_n_8,end_addr_carry__5_n_9}),
        .S({end_addr_carry__5_i_1__0_n_2,end_addr_carry__5_i_2__0_n_2,end_addr_carry__5_i_3__0_n_2,end_addr_carry__5_i_4__0_n_2}));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__5_i_1__0
       (.I0(\start_addr_reg_n_2_[29] ),
        .I1(\align_len_reg_n_2_[29] ),
        .O(end_addr_carry__5_i_1__0_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__5_i_2__0
       (.I0(\start_addr_reg_n_2_[28] ),
        .I1(\align_len_reg_n_2_[28] ),
        .O(end_addr_carry__5_i_2__0_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__5_i_3__0
       (.I0(\start_addr_reg_n_2_[27] ),
        .I1(\align_len_reg_n_2_[27] ),
        .O(end_addr_carry__5_i_3__0_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__5_i_4__0
       (.I0(\start_addr_reg_n_2_[26] ),
        .I1(\align_len_reg_n_2_[26] ),
        .O(end_addr_carry__5_i_4__0_n_2));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 end_addr_carry__6
       (.CI(end_addr_carry__5_n_2),
        .CO({NLW_end_addr_carry__6_CO_UNCONNECTED[3:1],end_addr_carry__6_n_5}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,\start_addr_reg_n_2_[30] }),
        .O({NLW_end_addr_carry__6_O_UNCONNECTED[3:2],end_addr_carry__6_n_8,end_addr_carry__6_n_9}),
        .S({1'b0,1'b0,end_addr_carry__6_i_1__0_n_2,end_addr_carry__6_i_2__0_n_2}));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__6_i_1__0
       (.I0(\align_len_reg_n_2_[31] ),
        .I1(\start_addr_reg_n_2_[31] ),
        .O(end_addr_carry__6_i_1__0_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__6_i_2__0
       (.I0(\start_addr_reg_n_2_[30] ),
        .I1(\align_len_reg_n_2_[30] ),
        .O(end_addr_carry__6_i_2__0_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry_i_1__0
       (.I0(\start_addr_reg_n_2_[5] ),
        .I1(\align_len_reg_n_2_[5] ),
        .O(end_addr_carry_i_1__0_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry_i_2__0
       (.I0(\start_addr_reg_n_2_[4] ),
        .I1(\align_len_reg_n_2_[4] ),
        .O(end_addr_carry_i_2__0_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry_i_3__0
       (.I0(\start_addr_reg_n_2_[3] ),
        .I1(\align_len_reg_n_2_[3] ),
        .O(end_addr_carry_i_3__0_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry_i_4__0
       (.I0(\start_addr_reg_n_2_[2] ),
        .I1(\align_len_reg_n_2_[2] ),
        .O(end_addr_carry_i_4__0_n_2));
  design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo__parameterized1_0 fifo_rctl
       (.CO(last_sect),
        .E(next_rreq),
        .Q({\end_addr_buf_reg_n_2_[11] ,\end_addr_buf_reg_n_2_[10] ,\end_addr_buf_reg_n_2_[9] ,\end_addr_buf_reg_n_2_[8] ,\end_addr_buf_reg_n_2_[7] ,\end_addr_buf_reg_n_2_[6] ,\end_addr_buf_reg_n_2_[5] ,\end_addr_buf_reg_n_2_[4] ,\end_addr_buf_reg_n_2_[3] ,\end_addr_buf_reg_n_2_[2] }),
        .SR(SR),
        .ap_clk(ap_clk),
        .ap_rst_n(ap_rst_n),
        .ap_rst_n_0(fifo_rctl_n_7),
        .ap_rst_n_1(fifo_rctl_n_12),
        .\beat_len_buf_reg[1] (fifo_rctl_n_15),
        .\beat_len_buf_reg[2] (fifo_rctl_n_16),
        .\beat_len_buf_reg[4] (fifo_rctl_n_18),
        .\beat_len_buf_reg[5] (fifo_rctl_n_19),
        .\beat_len_buf_reg[9] (fifo_rctl_n_23),
        .beat_valid(beat_valid),
        .\could_multi_bursts.ARVALID_Dummy_reg (\could_multi_bursts.ARVALID_Dummy_reg_0 ),
        .\could_multi_bursts.arlen_buf_reg[0] (\could_multi_bursts.arlen_buf[3]_i_3_n_2 ),
        .\could_multi_bursts.arlen_buf_reg[3] (p_1_in),
        .\could_multi_bursts.sect_handling_reg (p_21_in),
        .\could_multi_bursts.sect_handling_reg_0 (fifo_rctl_n_6),
        .\could_multi_bursts.sect_handling_reg_1 (fifo_rctl_n_11),
        .\could_multi_bursts.sect_handling_reg_2 (fifo_rctl_n_13),
        .\could_multi_bursts.sect_handling_reg_3 (fifo_rctl_n_24),
        .\could_multi_bursts.sect_handling_reg_4 (fifo_rctl_n_25),
        .\could_multi_bursts.sect_handling_reg_5 (fifo_rctl_n_26),
        .\could_multi_bursts.sect_handling_reg_6 (fifo_rctl_n_27),
        .\could_multi_bursts.sect_handling_reg_7 (fifo_rctl_n_28),
        .\could_multi_bursts.sect_handling_reg_8 (\could_multi_bursts.sect_handling_reg_n_2 ),
        .data_vld_reg_0(data_pack),
        .empty_n_reg_0(\bus_equal_gen.rdata_valid_t_reg_n_2 ),
        .\end_addr_buf_reg[10] (fifo_rctl_n_22),
        .\end_addr_buf_reg[2] (fifo_rctl_n_14),
        .\end_addr_buf_reg[8] (fifo_rctl_n_20),
        .fifo_rreq_valid(fifo_rreq_valid),
        .invalid_len_event(invalid_len_event),
        .invalid_len_event_reg2(invalid_len_event_reg2),
        .invalid_len_event_reg2_reg(fifo_rctl_n_2),
        .m_axi_gmem_ARREADY(m_axi_gmem_ARREADY),
        .next_beat(next_beat),
        .push(push),
        .rdata_ack_t(rdata_ack_t),
        .rreq_handling_reg(fifo_rctl_n_4),
        .rreq_handling_reg_0(fifo_rctl_n_9),
        .rreq_handling_reg_1(fifo_rctl_n_10),
        .rreq_handling_reg_2(fifo_rreq_valid_buf_reg_n_2),
        .rreq_handling_reg_3(fifo_rreq_n_25),
        .rreq_handling_reg_4(fifo_rreq_n_26),
        .rreq_handling_reg_5(rreq_handling_reg_n_2),
        .\sect_addr_buf_reg[2] (first_sect),
        .\sect_len_buf_reg[9] ({\beat_len_buf_reg_n_2_[9] ,\beat_len_buf_reg_n_2_[8] ,\beat_len_buf_reg_n_2_[7] ,\beat_len_buf_reg_n_2_[6] ,\beat_len_buf_reg_n_2_[5] ,\beat_len_buf_reg_n_2_[4] ,\beat_len_buf_reg_n_2_[3] ,\beat_len_buf_reg_n_2_[2] ,\beat_len_buf_reg_n_2_[1] ,\beat_len_buf_reg_n_2_[0] }),
        .\sect_len_buf_reg[9]_0 ({\start_addr_buf_reg_n_2_[11] ,\start_addr_buf_reg_n_2_[10] ,\start_addr_buf_reg_n_2_[9] ,\start_addr_buf_reg_n_2_[8] ,\start_addr_buf_reg_n_2_[7] ,\start_addr_buf_reg_n_2_[6] ,\start_addr_buf_reg_n_2_[5] ,\start_addr_buf_reg_n_2_[4] ,\start_addr_buf_reg_n_2_[3] ,\start_addr_buf_reg_n_2_[2] }),
        .\start_addr_buf_reg[5] (fifo_rctl_n_17),
        .\start_addr_buf_reg[9] (fifo_rctl_n_21));
  design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo__parameterized0_1 fifo_rreq
       (.CO(last_sect),
        .D({fifo_rreq_n_4,fifo_rreq_n_5,fifo_rreq_n_6,fifo_rreq_n_7,fifo_rreq_n_8,fifo_rreq_n_9,fifo_rreq_n_10,fifo_rreq_n_11,fifo_rreq_n_12,fifo_rreq_n_13,fifo_rreq_n_14,fifo_rreq_n_15,fifo_rreq_n_16,fifo_rreq_n_17,fifo_rreq_n_18,fifo_rreq_n_19,fifo_rreq_n_20,fifo_rreq_n_21,fifo_rreq_n_22,fifo_rreq_n_23}),
        .E(align_len),
        .O({sect_cnt0_carry_n_6,sect_cnt0_carry_n_7,sect_cnt0_carry_n_8,sect_cnt0_carry_n_9}),
        .Q({\sect_cnt_reg_n_2_[19] ,\sect_cnt_reg_n_2_[18] ,\sect_cnt_reg_n_2_[17] ,\sect_cnt_reg_n_2_[16] ,\sect_cnt_reg_n_2_[15] ,\sect_cnt_reg_n_2_[14] ,\sect_cnt_reg_n_2_[13] ,\sect_cnt_reg_n_2_[12] ,\sect_cnt_reg_n_2_[11] ,\sect_cnt_reg_n_2_[10] ,\sect_cnt_reg_n_2_[9] ,\sect_cnt_reg_n_2_[8] ,\sect_cnt_reg_n_2_[7] ,\sect_cnt_reg_n_2_[6] ,\sect_cnt_reg_n_2_[5] ,\sect_cnt_reg_n_2_[4] ,\sect_cnt_reg_n_2_[3] ,\sect_cnt_reg_n_2_[2] ,\sect_cnt_reg_n_2_[1] ,\sect_cnt_reg_n_2_[0] }),
        .S({fifo_rreq_n_27,fifo_rreq_n_28,fifo_rreq_n_29}),
        .SR(SR),
        .ap_clk(ap_clk),
        .ap_rst_n(ap_rst_n),
        .\could_multi_bursts.arlen_buf[3]_i_3 (\could_multi_bursts.loop_cnt_reg__0 ),
        .\could_multi_bursts.arlen_buf[3]_i_3_0 ({\sect_len_buf_reg_n_2_[9] ,\sect_len_buf_reg_n_2_[8] ,\sect_len_buf_reg_n_2_[7] ,\sect_len_buf_reg_n_2_[6] ,\sect_len_buf_reg_n_2_[5] ,\sect_len_buf_reg_n_2_[4] }),
        .\could_multi_bursts.loop_cnt_reg[0] (fifo_rreq_n_26),
        .\could_multi_bursts.loop_cnt_reg[3] (fifo_rreq_n_25),
        .\end_addr_buf_reg[23] ({fifo_rreq_n_116,fifo_rreq_n_117,fifo_rreq_n_118,fifo_rreq_n_119}),
        .fifo_rreq_valid(fifo_rreq_valid),
        .full_n_reg_0(fifo_rctl_n_6),
        .full_n_reg_1(rreq_handling_reg_n_2),
        .invalid_len_event0(invalid_len_event0),
        .last_sect_carry__0({\end_addr_buf_reg_n_2_[31] ,\end_addr_buf_reg_n_2_[30] ,\end_addr_buf_reg_n_2_[29] ,\end_addr_buf_reg_n_2_[28] ,\end_addr_buf_reg_n_2_[27] ,\end_addr_buf_reg_n_2_[26] ,\end_addr_buf_reg_n_2_[25] ,\end_addr_buf_reg_n_2_[24] ,\end_addr_buf_reg_n_2_[23] ,\end_addr_buf_reg_n_2_[22] ,\end_addr_buf_reg_n_2_[21] ,\end_addr_buf_reg_n_2_[20] ,\end_addr_buf_reg_n_2_[19] ,\end_addr_buf_reg_n_2_[18] ,\end_addr_buf_reg_n_2_[17] ,\end_addr_buf_reg_n_2_[16] ,\end_addr_buf_reg_n_2_[15] ,\end_addr_buf_reg_n_2_[14] ,\end_addr_buf_reg_n_2_[13] ,\end_addr_buf_reg_n_2_[12] }),
        .push(push_0),
        .\q_reg[34]_0 ({fifo_rreq_n_113,fifo_rreq_n_114,fifo_rreq_n_115}),
        .\q_reg[38]_0 ({fifo_rreq_n_109,fifo_rreq_n_110,fifo_rreq_n_111,fifo_rreq_n_112}),
        .\q_reg[42]_0 ({fifo_rreq_n_105,fifo_rreq_n_106,fifo_rreq_n_107,fifo_rreq_n_108}),
        .\q_reg[46]_0 ({fifo_rreq_n_101,fifo_rreq_n_102,fifo_rreq_n_103,fifo_rreq_n_104}),
        .\q_reg[50]_0 ({fifo_rreq_n_97,fifo_rreq_n_98,fifo_rreq_n_99,fifo_rreq_n_100}),
        .\q_reg[54]_0 ({fifo_rreq_n_93,fifo_rreq_n_94,fifo_rreq_n_95,fifo_rreq_n_96}),
        .\q_reg[58]_0 ({fifo_rreq_n_89,fifo_rreq_n_90,fifo_rreq_n_91,fifo_rreq_n_92}),
        .\q_reg[60]_0 ({fifo_rreq_data,fifo_rreq_n_59,fifo_rreq_n_60,fifo_rreq_n_61,fifo_rreq_n_62,fifo_rreq_n_63,fifo_rreq_n_64,fifo_rreq_n_65,fifo_rreq_n_66,fifo_rreq_n_67,fifo_rreq_n_68,fifo_rreq_n_69,fifo_rreq_n_70,fifo_rreq_n_71,fifo_rreq_n_72,fifo_rreq_n_73,fifo_rreq_n_74,fifo_rreq_n_75,fifo_rreq_n_76,fifo_rreq_n_77,fifo_rreq_n_78,fifo_rreq_n_79,fifo_rreq_n_80,fifo_rreq_n_81,fifo_rreq_n_82,fifo_rreq_n_83,fifo_rreq_n_84,fifo_rreq_n_85,fifo_rreq_n_86,fifo_rreq_n_87,fifo_rreq_n_88}),
        .\q_reg[63]_0 ({rs2f_rreq_data[63:32],rs2f_rreq_data[29:0]}),
        .rs2f_rreq_ack(rs2f_rreq_ack),
        .\sect_cnt_reg[0] (fifo_rreq_valid_buf_reg_n_2),
        .\sect_cnt_reg[0]_0 (fifo_rctl_n_4),
        .\sect_cnt_reg[12] ({sect_cnt0_carry__1_n_6,sect_cnt0_carry__1_n_7,sect_cnt0_carry__1_n_8,sect_cnt0_carry__1_n_9}),
        .\sect_cnt_reg[16] ({sect_cnt0_carry__2_n_6,sect_cnt0_carry__2_n_7,sect_cnt0_carry__2_n_8,sect_cnt0_carry__2_n_9}),
        .\sect_cnt_reg[19] ({fifo_rreq_n_120,fifo_rreq_n_121,fifo_rreq_n_122}),
        .\sect_cnt_reg[19]_0 ({\start_addr_reg_n_2_[31] ,\start_addr_reg_n_2_[30] ,\start_addr_reg_n_2_[29] ,\start_addr_reg_n_2_[28] ,\start_addr_reg_n_2_[27] ,\start_addr_reg_n_2_[26] ,\start_addr_reg_n_2_[25] ,\start_addr_reg_n_2_[24] ,\start_addr_reg_n_2_[23] ,\start_addr_reg_n_2_[22] ,\start_addr_reg_n_2_[21] ,\start_addr_reg_n_2_[20] ,\start_addr_reg_n_2_[19] ,\start_addr_reg_n_2_[18] ,\start_addr_reg_n_2_[17] ,\start_addr_reg_n_2_[16] ,\start_addr_reg_n_2_[15] ,\start_addr_reg_n_2_[14] ,\start_addr_reg_n_2_[13] ,\start_addr_reg_n_2_[12] }),
        .\sect_cnt_reg[19]_1 ({sect_cnt0_carry__3_n_7,sect_cnt0_carry__3_n_8,sect_cnt0_carry__3_n_9}),
        .\sect_cnt_reg[8] ({sect_cnt0_carry__0_n_6,sect_cnt0_carry__0_n_7,sect_cnt0_carry__0_n_8,sect_cnt0_carry__0_n_9}));
  FDRE fifo_rreq_valid_buf_reg
       (.C(ap_clk),
        .CE(next_rreq),
        .D(fifo_rreq_valid),
        .Q(fifo_rreq_valid_buf_reg_n_2),
        .R(SR));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 first_sect_carry
       (.CI(1'b0),
        .CO({first_sect_carry_n_2,first_sect_carry_n_3,first_sect_carry_n_4,first_sect_carry_n_5}),
        .CYINIT(1'b1),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_first_sect_carry_O_UNCONNECTED[3:0]),
        .S({first_sect_carry_i_1__0_n_2,first_sect_carry_i_2__0_n_2,first_sect_carry_i_3__0_n_2,first_sect_carry_i_4__0_n_2}));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 first_sect_carry__0
       (.CI(first_sect_carry_n_2),
        .CO({NLW_first_sect_carry__0_CO_UNCONNECTED[3],first_sect,first_sect_carry__0_n_4,first_sect_carry__0_n_5}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_first_sect_carry__0_O_UNCONNECTED[3:0]),
        .S({1'b0,first_sect_carry__0_i_1__0_n_2,first_sect_carry__0_i_2__0_n_2,first_sect_carry__0_i_3__0_n_2}));
  LUT4 #(
    .INIT(16'h9009)) 
    first_sect_carry__0_i_1__0
       (.I0(\start_addr_buf_reg_n_2_[31] ),
        .I1(\sect_cnt_reg_n_2_[19] ),
        .I2(\start_addr_buf_reg_n_2_[30] ),
        .I3(\sect_cnt_reg_n_2_[18] ),
        .O(first_sect_carry__0_i_1__0_n_2));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    first_sect_carry__0_i_2__0
       (.I0(\start_addr_buf_reg_n_2_[29] ),
        .I1(\sect_cnt_reg_n_2_[17] ),
        .I2(\sect_cnt_reg_n_2_[16] ),
        .I3(\start_addr_buf_reg_n_2_[28] ),
        .I4(\sect_cnt_reg_n_2_[15] ),
        .I5(\start_addr_buf_reg_n_2_[27] ),
        .O(first_sect_carry__0_i_2__0_n_2));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    first_sect_carry__0_i_3__0
       (.I0(\start_addr_buf_reg_n_2_[26] ),
        .I1(\sect_cnt_reg_n_2_[14] ),
        .I2(\sect_cnt_reg_n_2_[12] ),
        .I3(\start_addr_buf_reg_n_2_[24] ),
        .I4(\sect_cnt_reg_n_2_[13] ),
        .I5(\start_addr_buf_reg_n_2_[25] ),
        .O(first_sect_carry__0_i_3__0_n_2));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    first_sect_carry_i_1__0
       (.I0(\start_addr_buf_reg_n_2_[23] ),
        .I1(\sect_cnt_reg_n_2_[11] ),
        .I2(\sect_cnt_reg_n_2_[9] ),
        .I3(\start_addr_buf_reg_n_2_[21] ),
        .I4(\sect_cnt_reg_n_2_[10] ),
        .I5(\start_addr_buf_reg_n_2_[22] ),
        .O(first_sect_carry_i_1__0_n_2));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    first_sect_carry_i_2__0
       (.I0(\sect_cnt_reg_n_2_[6] ),
        .I1(\start_addr_buf_reg_n_2_[18] ),
        .I2(\sect_cnt_reg_n_2_[7] ),
        .I3(\start_addr_buf_reg_n_2_[19] ),
        .I4(\start_addr_buf_reg_n_2_[20] ),
        .I5(\sect_cnt_reg_n_2_[8] ),
        .O(first_sect_carry_i_2__0_n_2));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    first_sect_carry_i_3__0
       (.I0(\sect_cnt_reg_n_2_[3] ),
        .I1(\start_addr_buf_reg_n_2_[15] ),
        .I2(\sect_cnt_reg_n_2_[5] ),
        .I3(\start_addr_buf_reg_n_2_[17] ),
        .I4(\start_addr_buf_reg_n_2_[16] ),
        .I5(\sect_cnt_reg_n_2_[4] ),
        .O(first_sect_carry_i_3__0_n_2));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    first_sect_carry_i_4__0
       (.I0(\start_addr_buf_reg_n_2_[12] ),
        .I1(\sect_cnt_reg_n_2_[0] ),
        .I2(\sect_cnt_reg_n_2_[1] ),
        .I3(\start_addr_buf_reg_n_2_[13] ),
        .I4(\sect_cnt_reg_n_2_[2] ),
        .I5(\start_addr_buf_reg_n_2_[14] ),
        .O(first_sect_carry_i_4__0_n_2));
  FDRE invalid_len_event_reg
       (.C(ap_clk),
        .CE(next_rreq),
        .D(invalid_len_event0),
        .Q(invalid_len_event),
        .R(SR));
  FDRE invalid_len_event_reg1_reg
       (.C(ap_clk),
        .CE(next_rreq),
        .D(invalid_len_event),
        .Q(invalid_len_event_reg1_reg_n_2),
        .R(SR));
  FDRE invalid_len_event_reg2_reg
       (.C(ap_clk),
        .CE(p_21_in),
        .D(invalid_len_event_reg1_reg_n_2),
        .Q(invalid_len_event_reg2),
        .R(SR));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 last_sect_carry
       (.CI(1'b0),
        .CO({last_sect_carry_n_2,last_sect_carry_n_3,last_sect_carry_n_4,last_sect_carry_n_5}),
        .CYINIT(1'b1),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_last_sect_carry_O_UNCONNECTED[3:0]),
        .S({fifo_rreq_n_116,fifo_rreq_n_117,fifo_rreq_n_118,fifo_rreq_n_119}));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 last_sect_carry__0
       (.CI(last_sect_carry_n_2),
        .CO({NLW_last_sect_carry__0_CO_UNCONNECTED[3],last_sect,last_sect_carry__0_n_4,last_sect_carry__0_n_5}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_last_sect_carry__0_O_UNCONNECTED[3:0]),
        .S({1'b0,fifo_rreq_n_120,fifo_rreq_n_121,fifo_rreq_n_122}));
  FDRE rreq_handling_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(fifo_rctl_n_10),
        .Q(rreq_handling_reg_n_2),
        .R(SR));
  design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_reg_slice__parameterized0 rs_rdata
       (.CO(CO),
        .Q(Q[2:1]),
        .SR(SR),
        .\ap_CS_fsm_reg[7] (\ap_CS_fsm_reg[7] ),
        .\ap_CS_fsm_reg[8] (\ap_CS_fsm_reg[8] ),
        .\ap_CS_fsm_reg[8]_0 (\ap_CS_fsm_reg[8]_0 ),
        .\ap_CS_fsm_reg[8]_1 (\ap_CS_fsm_reg[8]_1 ),
        .ap_clk(ap_clk),
        .ap_enable_reg_pp0_iter0(ap_enable_reg_pp0_iter0),
        .ap_enable_reg_pp0_iter1_reg(ap_enable_reg_pp0_iter1_reg),
        .ap_enable_reg_pp0_iter1_reg_0(ap_enable_reg_pp0_iter1_reg_0),
        .ap_enable_reg_pp0_iter2_reg(ap_enable_reg_pp0_iter2_reg),
        .ap_rst_n(ap_rst_n),
        .\data_p1_reg[31]_0 (\data_p1_reg[31] ),
        .\data_p2_reg[31]_0 (\bus_equal_gen.data_buf ),
        .exitcond_reg_251_pp0_iter1_reg(exitcond_reg_251_pp0_iter1_reg),
        .i_reg_137(i_reg_137),
        .i_reg_1370(i_reg_1370),
        .rdata_ack_t(rdata_ack_t),
        .s_ready_t_reg_0(\bus_equal_gen.rdata_valid_t_reg_n_2 ),
        .\state_reg[0]_0 (\state_reg[0] ),
        .\state_reg[0]_1 (\state_reg[0]_0 ),
        .sum_reg_125(sum_reg_125),
        .sum_reg_1250(sum_reg_1250));
  design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_reg_slice_2 rs_rreq
       (.E(E),
        .Q(Q[0]),
        .SR(SR),
        .ap_clk(ap_clk),
        .\data_p1_reg[63]_0 ({rs2f_rreq_data[63:32],rs2f_rreq_data[29:0]}),
        .\data_p2_reg[63]_0 (\data_p2_reg[63] ),
        .push(push_0),
        .rs2f_rreq_ack(rs2f_rreq_ack));
  (* SOFT_HLUTNM = "soft_lutpair116" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sect_addr_buf[10]_i_1__0 
       (.I0(first_sect),
        .I1(\start_addr_buf_reg_n_2_[10] ),
        .O(\sect_addr_buf[10]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair115" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sect_addr_buf[11]_i_2__0 
       (.I0(first_sect),
        .I1(\start_addr_buf_reg_n_2_[11] ),
        .O(\sect_addr_buf[11]_i_2__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair111" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[12]_i_1__0 
       (.I0(\start_addr_buf_reg_n_2_[12] ),
        .I1(first_sect),
        .I2(\sect_cnt_reg_n_2_[0] ),
        .O(\sect_addr_buf[12]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair111" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[13]_i_1__0 
       (.I0(\start_addr_buf_reg_n_2_[13] ),
        .I1(first_sect),
        .I2(\sect_cnt_reg_n_2_[1] ),
        .O(\sect_addr_buf[13]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair110" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[14]_i_1__0 
       (.I0(\start_addr_buf_reg_n_2_[14] ),
        .I1(first_sect),
        .I2(\sect_cnt_reg_n_2_[2] ),
        .O(\sect_addr_buf[14]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair110" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[15]_i_1__0 
       (.I0(\start_addr_buf_reg_n_2_[15] ),
        .I1(first_sect),
        .I2(\sect_cnt_reg_n_2_[3] ),
        .O(\sect_addr_buf[15]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair109" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[16]_i_1__0 
       (.I0(\start_addr_buf_reg_n_2_[16] ),
        .I1(first_sect),
        .I2(\sect_cnt_reg_n_2_[4] ),
        .O(\sect_addr_buf[16]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair109" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[17]_i_1__0 
       (.I0(\start_addr_buf_reg_n_2_[17] ),
        .I1(first_sect),
        .I2(\sect_cnt_reg_n_2_[5] ),
        .O(\sect_addr_buf[17]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair108" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[18]_i_1__0 
       (.I0(\start_addr_buf_reg_n_2_[18] ),
        .I1(first_sect),
        .I2(\sect_cnt_reg_n_2_[6] ),
        .O(\sect_addr_buf[18]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair108" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[19]_i_1__0 
       (.I0(\start_addr_buf_reg_n_2_[19] ),
        .I1(first_sect),
        .I2(\sect_cnt_reg_n_2_[7] ),
        .O(\sect_addr_buf[19]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair107" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[20]_i_1__0 
       (.I0(\start_addr_buf_reg_n_2_[20] ),
        .I1(first_sect),
        .I2(\sect_cnt_reg_n_2_[8] ),
        .O(\sect_addr_buf[20]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair107" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[21]_i_1__0 
       (.I0(\start_addr_buf_reg_n_2_[21] ),
        .I1(first_sect),
        .I2(\sect_cnt_reg_n_2_[9] ),
        .O(\sect_addr_buf[21]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair106" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[22]_i_1__0 
       (.I0(\start_addr_buf_reg_n_2_[22] ),
        .I1(first_sect),
        .I2(\sect_cnt_reg_n_2_[10] ),
        .O(\sect_addr_buf[22]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair106" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[23]_i_1__0 
       (.I0(\start_addr_buf_reg_n_2_[23] ),
        .I1(first_sect),
        .I2(\sect_cnt_reg_n_2_[11] ),
        .O(\sect_addr_buf[23]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair105" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[24]_i_1__0 
       (.I0(\start_addr_buf_reg_n_2_[24] ),
        .I1(first_sect),
        .I2(\sect_cnt_reg_n_2_[12] ),
        .O(\sect_addr_buf[24]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair105" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[25]_i_1__0 
       (.I0(\start_addr_buf_reg_n_2_[25] ),
        .I1(first_sect),
        .I2(\sect_cnt_reg_n_2_[13] ),
        .O(\sect_addr_buf[25]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair104" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[26]_i_1__0 
       (.I0(\start_addr_buf_reg_n_2_[26] ),
        .I1(first_sect),
        .I2(\sect_cnt_reg_n_2_[14] ),
        .O(\sect_addr_buf[26]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair104" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[27]_i_1__0 
       (.I0(\start_addr_buf_reg_n_2_[27] ),
        .I1(first_sect),
        .I2(\sect_cnt_reg_n_2_[15] ),
        .O(\sect_addr_buf[27]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair103" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[28]_i_1__0 
       (.I0(\start_addr_buf_reg_n_2_[28] ),
        .I1(first_sect),
        .I2(\sect_cnt_reg_n_2_[16] ),
        .O(\sect_addr_buf[28]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair103" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[29]_i_1__0 
       (.I0(\start_addr_buf_reg_n_2_[29] ),
        .I1(first_sect),
        .I2(\sect_cnt_reg_n_2_[17] ),
        .O(\sect_addr_buf[29]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair119" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sect_addr_buf[2]_i_1__0 
       (.I0(first_sect),
        .I1(\start_addr_buf_reg_n_2_[2] ),
        .O(\sect_addr_buf[2]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair102" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[30]_i_1__0 
       (.I0(\start_addr_buf_reg_n_2_[30] ),
        .I1(first_sect),
        .I2(\sect_cnt_reg_n_2_[18] ),
        .O(\sect_addr_buf[30]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair102" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[31]_i_1__0 
       (.I0(\start_addr_buf_reg_n_2_[31] ),
        .I1(first_sect),
        .I2(\sect_cnt_reg_n_2_[19] ),
        .O(\sect_addr_buf[31]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair117" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sect_addr_buf[3]_i_1__0 
       (.I0(first_sect),
        .I1(\start_addr_buf_reg_n_2_[3] ),
        .O(\sect_addr_buf[3]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair115" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sect_addr_buf[4]_i_1__0 
       (.I0(first_sect),
        .I1(\start_addr_buf_reg_n_2_[4] ),
        .O(\sect_addr_buf[4]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair116" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sect_addr_buf[5]_i_1__0 
       (.I0(first_sect),
        .I1(\start_addr_buf_reg_n_2_[5] ),
        .O(\sect_addr_buf[5]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair118" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sect_addr_buf[6]_i_1__0 
       (.I0(first_sect),
        .I1(\start_addr_buf_reg_n_2_[6] ),
        .O(\sect_addr_buf[6]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair119" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sect_addr_buf[7]_i_1__0 
       (.I0(first_sect),
        .I1(\start_addr_buf_reg_n_2_[7] ),
        .O(\sect_addr_buf[7]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair118" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sect_addr_buf[8]_i_1__0 
       (.I0(first_sect),
        .I1(\start_addr_buf_reg_n_2_[8] ),
        .O(\sect_addr_buf[8]_i_1__0_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair117" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sect_addr_buf[9]_i_1__0 
       (.I0(first_sect),
        .I1(\start_addr_buf_reg_n_2_[9] ),
        .O(\sect_addr_buf[9]_i_1__0_n_2 ));
  FDRE \sect_addr_buf_reg[10] 
       (.C(ap_clk),
        .CE(p_21_in),
        .D(\sect_addr_buf[10]_i_1__0_n_2 ),
        .Q(\sect_addr_buf_reg_n_2_[10] ),
        .R(fifo_rctl_n_12));
  FDRE \sect_addr_buf_reg[11] 
       (.C(ap_clk),
        .CE(p_21_in),
        .D(\sect_addr_buf[11]_i_2__0_n_2 ),
        .Q(\sect_addr_buf_reg_n_2_[11] ),
        .R(fifo_rctl_n_12));
  FDRE \sect_addr_buf_reg[12] 
       (.C(ap_clk),
        .CE(p_21_in),
        .D(\sect_addr_buf[12]_i_1__0_n_2 ),
        .Q(\sect_addr_buf_reg_n_2_[12] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[13] 
       (.C(ap_clk),
        .CE(p_21_in),
        .D(\sect_addr_buf[13]_i_1__0_n_2 ),
        .Q(\sect_addr_buf_reg_n_2_[13] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[14] 
       (.C(ap_clk),
        .CE(p_21_in),
        .D(\sect_addr_buf[14]_i_1__0_n_2 ),
        .Q(\sect_addr_buf_reg_n_2_[14] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[15] 
       (.C(ap_clk),
        .CE(p_21_in),
        .D(\sect_addr_buf[15]_i_1__0_n_2 ),
        .Q(\sect_addr_buf_reg_n_2_[15] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[16] 
       (.C(ap_clk),
        .CE(p_21_in),
        .D(\sect_addr_buf[16]_i_1__0_n_2 ),
        .Q(\sect_addr_buf_reg_n_2_[16] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[17] 
       (.C(ap_clk),
        .CE(p_21_in),
        .D(\sect_addr_buf[17]_i_1__0_n_2 ),
        .Q(\sect_addr_buf_reg_n_2_[17] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[18] 
       (.C(ap_clk),
        .CE(p_21_in),
        .D(\sect_addr_buf[18]_i_1__0_n_2 ),
        .Q(\sect_addr_buf_reg_n_2_[18] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[19] 
       (.C(ap_clk),
        .CE(p_21_in),
        .D(\sect_addr_buf[19]_i_1__0_n_2 ),
        .Q(\sect_addr_buf_reg_n_2_[19] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[20] 
       (.C(ap_clk),
        .CE(p_21_in),
        .D(\sect_addr_buf[20]_i_1__0_n_2 ),
        .Q(\sect_addr_buf_reg_n_2_[20] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[21] 
       (.C(ap_clk),
        .CE(p_21_in),
        .D(\sect_addr_buf[21]_i_1__0_n_2 ),
        .Q(\sect_addr_buf_reg_n_2_[21] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[22] 
       (.C(ap_clk),
        .CE(p_21_in),
        .D(\sect_addr_buf[22]_i_1__0_n_2 ),
        .Q(\sect_addr_buf_reg_n_2_[22] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[23] 
       (.C(ap_clk),
        .CE(p_21_in),
        .D(\sect_addr_buf[23]_i_1__0_n_2 ),
        .Q(\sect_addr_buf_reg_n_2_[23] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[24] 
       (.C(ap_clk),
        .CE(p_21_in),
        .D(\sect_addr_buf[24]_i_1__0_n_2 ),
        .Q(\sect_addr_buf_reg_n_2_[24] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[25] 
       (.C(ap_clk),
        .CE(p_21_in),
        .D(\sect_addr_buf[25]_i_1__0_n_2 ),
        .Q(\sect_addr_buf_reg_n_2_[25] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[26] 
       (.C(ap_clk),
        .CE(p_21_in),
        .D(\sect_addr_buf[26]_i_1__0_n_2 ),
        .Q(\sect_addr_buf_reg_n_2_[26] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[27] 
       (.C(ap_clk),
        .CE(p_21_in),
        .D(\sect_addr_buf[27]_i_1__0_n_2 ),
        .Q(\sect_addr_buf_reg_n_2_[27] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[28] 
       (.C(ap_clk),
        .CE(p_21_in),
        .D(\sect_addr_buf[28]_i_1__0_n_2 ),
        .Q(\sect_addr_buf_reg_n_2_[28] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[29] 
       (.C(ap_clk),
        .CE(p_21_in),
        .D(\sect_addr_buf[29]_i_1__0_n_2 ),
        .Q(\sect_addr_buf_reg_n_2_[29] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[2] 
       (.C(ap_clk),
        .CE(p_21_in),
        .D(\sect_addr_buf[2]_i_1__0_n_2 ),
        .Q(\sect_addr_buf_reg_n_2_[2] ),
        .R(fifo_rctl_n_12));
  FDRE \sect_addr_buf_reg[30] 
       (.C(ap_clk),
        .CE(p_21_in),
        .D(\sect_addr_buf[30]_i_1__0_n_2 ),
        .Q(\sect_addr_buf_reg_n_2_[30] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[31] 
       (.C(ap_clk),
        .CE(p_21_in),
        .D(\sect_addr_buf[31]_i_1__0_n_2 ),
        .Q(\sect_addr_buf_reg_n_2_[31] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[3] 
       (.C(ap_clk),
        .CE(p_21_in),
        .D(\sect_addr_buf[3]_i_1__0_n_2 ),
        .Q(\sect_addr_buf_reg_n_2_[3] ),
        .R(fifo_rctl_n_12));
  FDRE \sect_addr_buf_reg[4] 
       (.C(ap_clk),
        .CE(p_21_in),
        .D(\sect_addr_buf[4]_i_1__0_n_2 ),
        .Q(\sect_addr_buf_reg_n_2_[4] ),
        .R(fifo_rctl_n_12));
  FDRE \sect_addr_buf_reg[5] 
       (.C(ap_clk),
        .CE(p_21_in),
        .D(\sect_addr_buf[5]_i_1__0_n_2 ),
        .Q(\sect_addr_buf_reg_n_2_[5] ),
        .R(fifo_rctl_n_12));
  FDRE \sect_addr_buf_reg[6] 
       (.C(ap_clk),
        .CE(p_21_in),
        .D(\sect_addr_buf[6]_i_1__0_n_2 ),
        .Q(\sect_addr_buf_reg_n_2_[6] ),
        .R(fifo_rctl_n_12));
  FDRE \sect_addr_buf_reg[7] 
       (.C(ap_clk),
        .CE(p_21_in),
        .D(\sect_addr_buf[7]_i_1__0_n_2 ),
        .Q(\sect_addr_buf_reg_n_2_[7] ),
        .R(fifo_rctl_n_12));
  FDRE \sect_addr_buf_reg[8] 
       (.C(ap_clk),
        .CE(p_21_in),
        .D(\sect_addr_buf[8]_i_1__0_n_2 ),
        .Q(\sect_addr_buf_reg_n_2_[8] ),
        .R(fifo_rctl_n_12));
  FDRE \sect_addr_buf_reg[9] 
       (.C(ap_clk),
        .CE(p_21_in),
        .D(\sect_addr_buf[9]_i_1__0_n_2 ),
        .Q(\sect_addr_buf_reg_n_2_[9] ),
        .R(fifo_rctl_n_12));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 sect_cnt0_carry
       (.CI(1'b0),
        .CO({sect_cnt0_carry_n_2,sect_cnt0_carry_n_3,sect_cnt0_carry_n_4,sect_cnt0_carry_n_5}),
        .CYINIT(\sect_cnt_reg_n_2_[0] ),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({sect_cnt0_carry_n_6,sect_cnt0_carry_n_7,sect_cnt0_carry_n_8,sect_cnt0_carry_n_9}),
        .S({\sect_cnt_reg_n_2_[4] ,\sect_cnt_reg_n_2_[3] ,\sect_cnt_reg_n_2_[2] ,\sect_cnt_reg_n_2_[1] }));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 sect_cnt0_carry__0
       (.CI(sect_cnt0_carry_n_2),
        .CO({sect_cnt0_carry__0_n_2,sect_cnt0_carry__0_n_3,sect_cnt0_carry__0_n_4,sect_cnt0_carry__0_n_5}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({sect_cnt0_carry__0_n_6,sect_cnt0_carry__0_n_7,sect_cnt0_carry__0_n_8,sect_cnt0_carry__0_n_9}),
        .S({\sect_cnt_reg_n_2_[8] ,\sect_cnt_reg_n_2_[7] ,\sect_cnt_reg_n_2_[6] ,\sect_cnt_reg_n_2_[5] }));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 sect_cnt0_carry__1
       (.CI(sect_cnt0_carry__0_n_2),
        .CO({sect_cnt0_carry__1_n_2,sect_cnt0_carry__1_n_3,sect_cnt0_carry__1_n_4,sect_cnt0_carry__1_n_5}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({sect_cnt0_carry__1_n_6,sect_cnt0_carry__1_n_7,sect_cnt0_carry__1_n_8,sect_cnt0_carry__1_n_9}),
        .S({\sect_cnt_reg_n_2_[12] ,\sect_cnt_reg_n_2_[11] ,\sect_cnt_reg_n_2_[10] ,\sect_cnt_reg_n_2_[9] }));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 sect_cnt0_carry__2
       (.CI(sect_cnt0_carry__1_n_2),
        .CO({sect_cnt0_carry__2_n_2,sect_cnt0_carry__2_n_3,sect_cnt0_carry__2_n_4,sect_cnt0_carry__2_n_5}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({sect_cnt0_carry__2_n_6,sect_cnt0_carry__2_n_7,sect_cnt0_carry__2_n_8,sect_cnt0_carry__2_n_9}),
        .S({\sect_cnt_reg_n_2_[16] ,\sect_cnt_reg_n_2_[15] ,\sect_cnt_reg_n_2_[14] ,\sect_cnt_reg_n_2_[13] }));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 sect_cnt0_carry__3
       (.CI(sect_cnt0_carry__2_n_2),
        .CO({NLW_sect_cnt0_carry__3_CO_UNCONNECTED[3:2],sect_cnt0_carry__3_n_4,sect_cnt0_carry__3_n_5}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({NLW_sect_cnt0_carry__3_O_UNCONNECTED[3],sect_cnt0_carry__3_n_7,sect_cnt0_carry__3_n_8,sect_cnt0_carry__3_n_9}),
        .S({1'b0,\sect_cnt_reg_n_2_[19] ,\sect_cnt_reg_n_2_[18] ,\sect_cnt_reg_n_2_[17] }));
  FDRE \sect_cnt_reg[0] 
       (.C(ap_clk),
        .CE(fifo_rctl_n_9),
        .D(fifo_rreq_n_23),
        .Q(\sect_cnt_reg_n_2_[0] ),
        .R(SR));
  FDRE \sect_cnt_reg[10] 
       (.C(ap_clk),
        .CE(fifo_rctl_n_9),
        .D(fifo_rreq_n_13),
        .Q(\sect_cnt_reg_n_2_[10] ),
        .R(SR));
  FDRE \sect_cnt_reg[11] 
       (.C(ap_clk),
        .CE(fifo_rctl_n_9),
        .D(fifo_rreq_n_12),
        .Q(\sect_cnt_reg_n_2_[11] ),
        .R(SR));
  FDRE \sect_cnt_reg[12] 
       (.C(ap_clk),
        .CE(fifo_rctl_n_9),
        .D(fifo_rreq_n_11),
        .Q(\sect_cnt_reg_n_2_[12] ),
        .R(SR));
  FDRE \sect_cnt_reg[13] 
       (.C(ap_clk),
        .CE(fifo_rctl_n_9),
        .D(fifo_rreq_n_10),
        .Q(\sect_cnt_reg_n_2_[13] ),
        .R(SR));
  FDRE \sect_cnt_reg[14] 
       (.C(ap_clk),
        .CE(fifo_rctl_n_9),
        .D(fifo_rreq_n_9),
        .Q(\sect_cnt_reg_n_2_[14] ),
        .R(SR));
  FDRE \sect_cnt_reg[15] 
       (.C(ap_clk),
        .CE(fifo_rctl_n_9),
        .D(fifo_rreq_n_8),
        .Q(\sect_cnt_reg_n_2_[15] ),
        .R(SR));
  FDRE \sect_cnt_reg[16] 
       (.C(ap_clk),
        .CE(fifo_rctl_n_9),
        .D(fifo_rreq_n_7),
        .Q(\sect_cnt_reg_n_2_[16] ),
        .R(SR));
  FDRE \sect_cnt_reg[17] 
       (.C(ap_clk),
        .CE(fifo_rctl_n_9),
        .D(fifo_rreq_n_6),
        .Q(\sect_cnt_reg_n_2_[17] ),
        .R(SR));
  FDRE \sect_cnt_reg[18] 
       (.C(ap_clk),
        .CE(fifo_rctl_n_9),
        .D(fifo_rreq_n_5),
        .Q(\sect_cnt_reg_n_2_[18] ),
        .R(SR));
  FDRE \sect_cnt_reg[19] 
       (.C(ap_clk),
        .CE(fifo_rctl_n_9),
        .D(fifo_rreq_n_4),
        .Q(\sect_cnt_reg_n_2_[19] ),
        .R(SR));
  FDRE \sect_cnt_reg[1] 
       (.C(ap_clk),
        .CE(fifo_rctl_n_9),
        .D(fifo_rreq_n_22),
        .Q(\sect_cnt_reg_n_2_[1] ),
        .R(SR));
  FDRE \sect_cnt_reg[2] 
       (.C(ap_clk),
        .CE(fifo_rctl_n_9),
        .D(fifo_rreq_n_21),
        .Q(\sect_cnt_reg_n_2_[2] ),
        .R(SR));
  FDRE \sect_cnt_reg[3] 
       (.C(ap_clk),
        .CE(fifo_rctl_n_9),
        .D(fifo_rreq_n_20),
        .Q(\sect_cnt_reg_n_2_[3] ),
        .R(SR));
  FDRE \sect_cnt_reg[4] 
       (.C(ap_clk),
        .CE(fifo_rctl_n_9),
        .D(fifo_rreq_n_19),
        .Q(\sect_cnt_reg_n_2_[4] ),
        .R(SR));
  FDRE \sect_cnt_reg[5] 
       (.C(ap_clk),
        .CE(fifo_rctl_n_9),
        .D(fifo_rreq_n_18),
        .Q(\sect_cnt_reg_n_2_[5] ),
        .R(SR));
  FDRE \sect_cnt_reg[6] 
       (.C(ap_clk),
        .CE(fifo_rctl_n_9),
        .D(fifo_rreq_n_17),
        .Q(\sect_cnt_reg_n_2_[6] ),
        .R(SR));
  FDRE \sect_cnt_reg[7] 
       (.C(ap_clk),
        .CE(fifo_rctl_n_9),
        .D(fifo_rreq_n_16),
        .Q(\sect_cnt_reg_n_2_[7] ),
        .R(SR));
  FDRE \sect_cnt_reg[8] 
       (.C(ap_clk),
        .CE(fifo_rctl_n_9),
        .D(fifo_rreq_n_15),
        .Q(\sect_cnt_reg_n_2_[8] ),
        .R(SR));
  FDRE \sect_cnt_reg[9] 
       (.C(ap_clk),
        .CE(fifo_rctl_n_9),
        .D(fifo_rreq_n_14),
        .Q(\sect_cnt_reg_n_2_[9] ),
        .R(SR));
  FDRE \sect_len_buf_reg[0] 
       (.C(ap_clk),
        .CE(fifo_rctl_n_13),
        .D(fifo_rctl_n_14),
        .Q(p_1_in[0]),
        .R(SR));
  FDRE \sect_len_buf_reg[1] 
       (.C(ap_clk),
        .CE(fifo_rctl_n_13),
        .D(fifo_rctl_n_15),
        .Q(p_1_in[1]),
        .R(SR));
  FDRE \sect_len_buf_reg[2] 
       (.C(ap_clk),
        .CE(fifo_rctl_n_13),
        .D(fifo_rctl_n_16),
        .Q(p_1_in[2]),
        .R(SR));
  FDRE \sect_len_buf_reg[3] 
       (.C(ap_clk),
        .CE(fifo_rctl_n_13),
        .D(fifo_rctl_n_17),
        .Q(p_1_in[3]),
        .R(SR));
  FDRE \sect_len_buf_reg[4] 
       (.C(ap_clk),
        .CE(fifo_rctl_n_13),
        .D(fifo_rctl_n_18),
        .Q(\sect_len_buf_reg_n_2_[4] ),
        .R(SR));
  FDRE \sect_len_buf_reg[5] 
       (.C(ap_clk),
        .CE(fifo_rctl_n_13),
        .D(fifo_rctl_n_19),
        .Q(\sect_len_buf_reg_n_2_[5] ),
        .R(SR));
  FDRE \sect_len_buf_reg[6] 
       (.C(ap_clk),
        .CE(fifo_rctl_n_13),
        .D(fifo_rctl_n_20),
        .Q(\sect_len_buf_reg_n_2_[6] ),
        .R(SR));
  FDRE \sect_len_buf_reg[7] 
       (.C(ap_clk),
        .CE(fifo_rctl_n_13),
        .D(fifo_rctl_n_21),
        .Q(\sect_len_buf_reg_n_2_[7] ),
        .R(SR));
  FDRE \sect_len_buf_reg[8] 
       (.C(ap_clk),
        .CE(fifo_rctl_n_13),
        .D(fifo_rctl_n_22),
        .Q(\sect_len_buf_reg_n_2_[8] ),
        .R(SR));
  FDRE \sect_len_buf_reg[9] 
       (.C(ap_clk),
        .CE(fifo_rctl_n_13),
        .D(fifo_rctl_n_23),
        .Q(\sect_len_buf_reg_n_2_[9] ),
        .R(SR));
  FDRE \start_addr_buf_reg[10] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\start_addr_reg_n_2_[10] ),
        .Q(\start_addr_buf_reg_n_2_[10] ),
        .R(SR));
  FDRE \start_addr_buf_reg[11] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\start_addr_reg_n_2_[11] ),
        .Q(\start_addr_buf_reg_n_2_[11] ),
        .R(SR));
  FDRE \start_addr_buf_reg[12] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\start_addr_reg_n_2_[12] ),
        .Q(\start_addr_buf_reg_n_2_[12] ),
        .R(SR));
  FDRE \start_addr_buf_reg[13] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\start_addr_reg_n_2_[13] ),
        .Q(\start_addr_buf_reg_n_2_[13] ),
        .R(SR));
  FDRE \start_addr_buf_reg[14] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\start_addr_reg_n_2_[14] ),
        .Q(\start_addr_buf_reg_n_2_[14] ),
        .R(SR));
  FDRE \start_addr_buf_reg[15] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\start_addr_reg_n_2_[15] ),
        .Q(\start_addr_buf_reg_n_2_[15] ),
        .R(SR));
  FDRE \start_addr_buf_reg[16] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\start_addr_reg_n_2_[16] ),
        .Q(\start_addr_buf_reg_n_2_[16] ),
        .R(SR));
  FDRE \start_addr_buf_reg[17] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\start_addr_reg_n_2_[17] ),
        .Q(\start_addr_buf_reg_n_2_[17] ),
        .R(SR));
  FDRE \start_addr_buf_reg[18] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\start_addr_reg_n_2_[18] ),
        .Q(\start_addr_buf_reg_n_2_[18] ),
        .R(SR));
  FDRE \start_addr_buf_reg[19] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\start_addr_reg_n_2_[19] ),
        .Q(\start_addr_buf_reg_n_2_[19] ),
        .R(SR));
  FDRE \start_addr_buf_reg[20] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\start_addr_reg_n_2_[20] ),
        .Q(\start_addr_buf_reg_n_2_[20] ),
        .R(SR));
  FDRE \start_addr_buf_reg[21] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\start_addr_reg_n_2_[21] ),
        .Q(\start_addr_buf_reg_n_2_[21] ),
        .R(SR));
  FDRE \start_addr_buf_reg[22] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\start_addr_reg_n_2_[22] ),
        .Q(\start_addr_buf_reg_n_2_[22] ),
        .R(SR));
  FDRE \start_addr_buf_reg[23] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\start_addr_reg_n_2_[23] ),
        .Q(\start_addr_buf_reg_n_2_[23] ),
        .R(SR));
  FDRE \start_addr_buf_reg[24] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\start_addr_reg_n_2_[24] ),
        .Q(\start_addr_buf_reg_n_2_[24] ),
        .R(SR));
  FDRE \start_addr_buf_reg[25] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\start_addr_reg_n_2_[25] ),
        .Q(\start_addr_buf_reg_n_2_[25] ),
        .R(SR));
  FDRE \start_addr_buf_reg[26] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\start_addr_reg_n_2_[26] ),
        .Q(\start_addr_buf_reg_n_2_[26] ),
        .R(SR));
  FDRE \start_addr_buf_reg[27] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\start_addr_reg_n_2_[27] ),
        .Q(\start_addr_buf_reg_n_2_[27] ),
        .R(SR));
  FDRE \start_addr_buf_reg[28] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\start_addr_reg_n_2_[28] ),
        .Q(\start_addr_buf_reg_n_2_[28] ),
        .R(SR));
  FDRE \start_addr_buf_reg[29] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\start_addr_reg_n_2_[29] ),
        .Q(\start_addr_buf_reg_n_2_[29] ),
        .R(SR));
  FDRE \start_addr_buf_reg[2] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\start_addr_reg_n_2_[2] ),
        .Q(\start_addr_buf_reg_n_2_[2] ),
        .R(SR));
  FDRE \start_addr_buf_reg[30] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\start_addr_reg_n_2_[30] ),
        .Q(\start_addr_buf_reg_n_2_[30] ),
        .R(SR));
  FDRE \start_addr_buf_reg[31] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\start_addr_reg_n_2_[31] ),
        .Q(\start_addr_buf_reg_n_2_[31] ),
        .R(SR));
  FDRE \start_addr_buf_reg[3] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\start_addr_reg_n_2_[3] ),
        .Q(\start_addr_buf_reg_n_2_[3] ),
        .R(SR));
  FDRE \start_addr_buf_reg[4] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\start_addr_reg_n_2_[4] ),
        .Q(\start_addr_buf_reg_n_2_[4] ),
        .R(SR));
  FDRE \start_addr_buf_reg[5] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\start_addr_reg_n_2_[5] ),
        .Q(\start_addr_buf_reg_n_2_[5] ),
        .R(SR));
  FDRE \start_addr_buf_reg[6] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\start_addr_reg_n_2_[6] ),
        .Q(\start_addr_buf_reg_n_2_[6] ),
        .R(SR));
  FDRE \start_addr_buf_reg[7] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\start_addr_reg_n_2_[7] ),
        .Q(\start_addr_buf_reg_n_2_[7] ),
        .R(SR));
  FDRE \start_addr_buf_reg[8] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\start_addr_reg_n_2_[8] ),
        .Q(\start_addr_buf_reg_n_2_[8] ),
        .R(SR));
  FDRE \start_addr_buf_reg[9] 
       (.C(ap_clk),
        .CE(next_rreq),
        .D(\start_addr_reg_n_2_[9] ),
        .Q(\start_addr_buf_reg_n_2_[9] ),
        .R(SR));
  FDRE \start_addr_reg[10] 
       (.C(ap_clk),
        .CE(align_len),
        .D(fifo_rreq_n_80),
        .Q(\start_addr_reg_n_2_[10] ),
        .R(SR));
  FDRE \start_addr_reg[11] 
       (.C(ap_clk),
        .CE(align_len),
        .D(fifo_rreq_n_79),
        .Q(\start_addr_reg_n_2_[11] ),
        .R(SR));
  FDRE \start_addr_reg[12] 
       (.C(ap_clk),
        .CE(align_len),
        .D(fifo_rreq_n_78),
        .Q(\start_addr_reg_n_2_[12] ),
        .R(SR));
  FDRE \start_addr_reg[13] 
       (.C(ap_clk),
        .CE(align_len),
        .D(fifo_rreq_n_77),
        .Q(\start_addr_reg_n_2_[13] ),
        .R(SR));
  FDRE \start_addr_reg[14] 
       (.C(ap_clk),
        .CE(align_len),
        .D(fifo_rreq_n_76),
        .Q(\start_addr_reg_n_2_[14] ),
        .R(SR));
  FDRE \start_addr_reg[15] 
       (.C(ap_clk),
        .CE(align_len),
        .D(fifo_rreq_n_75),
        .Q(\start_addr_reg_n_2_[15] ),
        .R(SR));
  FDRE \start_addr_reg[16] 
       (.C(ap_clk),
        .CE(align_len),
        .D(fifo_rreq_n_74),
        .Q(\start_addr_reg_n_2_[16] ),
        .R(SR));
  FDRE \start_addr_reg[17] 
       (.C(ap_clk),
        .CE(align_len),
        .D(fifo_rreq_n_73),
        .Q(\start_addr_reg_n_2_[17] ),
        .R(SR));
  FDRE \start_addr_reg[18] 
       (.C(ap_clk),
        .CE(align_len),
        .D(fifo_rreq_n_72),
        .Q(\start_addr_reg_n_2_[18] ),
        .R(SR));
  FDRE \start_addr_reg[19] 
       (.C(ap_clk),
        .CE(align_len),
        .D(fifo_rreq_n_71),
        .Q(\start_addr_reg_n_2_[19] ),
        .R(SR));
  FDRE \start_addr_reg[20] 
       (.C(ap_clk),
        .CE(align_len),
        .D(fifo_rreq_n_70),
        .Q(\start_addr_reg_n_2_[20] ),
        .R(SR));
  FDRE \start_addr_reg[21] 
       (.C(ap_clk),
        .CE(align_len),
        .D(fifo_rreq_n_69),
        .Q(\start_addr_reg_n_2_[21] ),
        .R(SR));
  FDRE \start_addr_reg[22] 
       (.C(ap_clk),
        .CE(align_len),
        .D(fifo_rreq_n_68),
        .Q(\start_addr_reg_n_2_[22] ),
        .R(SR));
  FDRE \start_addr_reg[23] 
       (.C(ap_clk),
        .CE(align_len),
        .D(fifo_rreq_n_67),
        .Q(\start_addr_reg_n_2_[23] ),
        .R(SR));
  FDRE \start_addr_reg[24] 
       (.C(ap_clk),
        .CE(align_len),
        .D(fifo_rreq_n_66),
        .Q(\start_addr_reg_n_2_[24] ),
        .R(SR));
  FDRE \start_addr_reg[25] 
       (.C(ap_clk),
        .CE(align_len),
        .D(fifo_rreq_n_65),
        .Q(\start_addr_reg_n_2_[25] ),
        .R(SR));
  FDRE \start_addr_reg[26] 
       (.C(ap_clk),
        .CE(align_len),
        .D(fifo_rreq_n_64),
        .Q(\start_addr_reg_n_2_[26] ),
        .R(SR));
  FDRE \start_addr_reg[27] 
       (.C(ap_clk),
        .CE(align_len),
        .D(fifo_rreq_n_63),
        .Q(\start_addr_reg_n_2_[27] ),
        .R(SR));
  FDRE \start_addr_reg[28] 
       (.C(ap_clk),
        .CE(align_len),
        .D(fifo_rreq_n_62),
        .Q(\start_addr_reg_n_2_[28] ),
        .R(SR));
  FDRE \start_addr_reg[29] 
       (.C(ap_clk),
        .CE(align_len),
        .D(fifo_rreq_n_61),
        .Q(\start_addr_reg_n_2_[29] ),
        .R(SR));
  FDRE \start_addr_reg[2] 
       (.C(ap_clk),
        .CE(align_len),
        .D(fifo_rreq_n_88),
        .Q(\start_addr_reg_n_2_[2] ),
        .R(SR));
  FDRE \start_addr_reg[30] 
       (.C(ap_clk),
        .CE(align_len),
        .D(fifo_rreq_n_60),
        .Q(\start_addr_reg_n_2_[30] ),
        .R(SR));
  FDRE \start_addr_reg[31] 
       (.C(ap_clk),
        .CE(align_len),
        .D(fifo_rreq_n_59),
        .Q(\start_addr_reg_n_2_[31] ),
        .R(SR));
  FDRE \start_addr_reg[3] 
       (.C(ap_clk),
        .CE(align_len),
        .D(fifo_rreq_n_87),
        .Q(\start_addr_reg_n_2_[3] ),
        .R(SR));
  FDRE \start_addr_reg[4] 
       (.C(ap_clk),
        .CE(align_len),
        .D(fifo_rreq_n_86),
        .Q(\start_addr_reg_n_2_[4] ),
        .R(SR));
  FDRE \start_addr_reg[5] 
       (.C(ap_clk),
        .CE(align_len),
        .D(fifo_rreq_n_85),
        .Q(\start_addr_reg_n_2_[5] ),
        .R(SR));
  FDRE \start_addr_reg[6] 
       (.C(ap_clk),
        .CE(align_len),
        .D(fifo_rreq_n_84),
        .Q(\start_addr_reg_n_2_[6] ),
        .R(SR));
  FDRE \start_addr_reg[7] 
       (.C(ap_clk),
        .CE(align_len),
        .D(fifo_rreq_n_83),
        .Q(\start_addr_reg_n_2_[7] ),
        .R(SR));
  FDRE \start_addr_reg[8] 
       (.C(ap_clk),
        .CE(align_len),
        .D(fifo_rreq_n_82),
        .Q(\start_addr_reg_n_2_[8] ),
        .R(SR));
  FDRE \start_addr_reg[9] 
       (.C(ap_clk),
        .CE(align_len),
        .D(fifo_rreq_n_81),
        .Q(\start_addr_reg_n_2_[9] ),
        .R(SR));
endmodule

module design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_reg_slice
   (\state_reg[0]_0 ,
    s_ready_t_reg_0,
    push,
    \data_p1_reg[29]_0 ,
    SR,
    ap_clk,
    rs2f_wreq_ack,
    Q,
    gmem_WREADY,
    ap_reg_ioackin_gmem_WREADY,
    \ap_CS_fsm_reg[9] ,
    \data_p2_reg[29]_0 );
  output [0:0]\state_reg[0]_0 ;
  output [1:0]s_ready_t_reg_0;
  output push;
  output [29:0]\data_p1_reg[29]_0 ;
  input [0:0]SR;
  input ap_clk;
  input rs2f_wreq_ack;
  input [2:0]Q;
  input gmem_WREADY;
  input ap_reg_ioackin_gmem_WREADY;
  input \ap_CS_fsm_reg[9] ;
  input [29:0]\data_p2_reg[29]_0 ;

  wire [2:0]Q;
  wire [0:0]SR;
  wire \ap_CS_fsm_reg[9] ;
  wire ap_clk;
  wire ap_reg_ioackin_gmem_WREADY;
  wire \data_p1[0]_i_1_n_2 ;
  wire \data_p1[10]_i_1_n_2 ;
  wire \data_p1[11]_i_1_n_2 ;
  wire \data_p1[12]_i_1_n_2 ;
  wire \data_p1[13]_i_1_n_2 ;
  wire \data_p1[14]_i_1_n_2 ;
  wire \data_p1[15]_i_1_n_2 ;
  wire \data_p1[16]_i_1_n_2 ;
  wire \data_p1[17]_i_1_n_2 ;
  wire \data_p1[18]_i_1_n_2 ;
  wire \data_p1[19]_i_1_n_2 ;
  wire \data_p1[1]_i_1_n_2 ;
  wire \data_p1[20]_i_1_n_2 ;
  wire \data_p1[21]_i_1_n_2 ;
  wire \data_p1[22]_i_1_n_2 ;
  wire \data_p1[23]_i_1_n_2 ;
  wire \data_p1[24]_i_1_n_2 ;
  wire \data_p1[25]_i_1_n_2 ;
  wire \data_p1[26]_i_1_n_2 ;
  wire \data_p1[27]_i_1_n_2 ;
  wire \data_p1[28]_i_1_n_2 ;
  wire \data_p1[29]_i_2_n_2 ;
  wire \data_p1[2]_i_1_n_2 ;
  wire \data_p1[3]_i_1_n_2 ;
  wire \data_p1[4]_i_1_n_2 ;
  wire \data_p1[5]_i_1_n_2 ;
  wire \data_p1[6]_i_1_n_2 ;
  wire \data_p1[7]_i_1_n_2 ;
  wire \data_p1[8]_i_1_n_2 ;
  wire \data_p1[9]_i_1_n_2 ;
  wire [29:0]\data_p1_reg[29]_0 ;
  wire [29:0]data_p2;
  wire [29:0]\data_p2_reg[29]_0 ;
  wire gmem_AWREADY;
  wire gmem_WREADY;
  wire load_p1;
  wire load_p2;
  wire [1:0]next__0;
  wire push;
  wire rs2f_wreq_ack;
  wire s_ready_t_i_1_n_2;
  wire [1:0]s_ready_t_reg_0;
  wire [1:1]state;
  wire \state[0]_i_1_n_2 ;
  wire \state[1]_i_1__0_n_2 ;
  wire [1:0]state__0;
  wire [0:0]\state_reg[0]_0 ;

  LUT4 #(
    .INIT(16'h0602)) 
    \FSM_sequential_state[0]_i_1 
       (.I0(state__0[0]),
        .I1(state__0[1]),
        .I2(rs2f_wreq_ack),
        .I3(Q[1]),
        .O(next__0[0]));
  (* SOFT_HLUTNM = "soft_lutpair171" *) 
  LUT5 #(
    .INIT(32'h3E020C30)) 
    \FSM_sequential_state[1]_i_1 
       (.I0(gmem_AWREADY),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(rs2f_wreq_ack),
        .I4(Q[1]),
        .O(next__0[1]));
  (* FSM_ENCODED_STATES = "ZERO:00,TWO:01,ONE:10" *) 
  FDRE \FSM_sequential_state_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(next__0[0]),
        .Q(state__0[0]),
        .R(SR));
  (* FSM_ENCODED_STATES = "ZERO:00,TWO:01,ONE:10" *) 
  FDRE \FSM_sequential_state_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(next__0[1]),
        .Q(state__0[1]),
        .R(SR));
  LUT5 #(
    .INIT(32'h888888B8)) 
    \ap_CS_fsm[10]_i_1 
       (.I0(gmem_AWREADY),
        .I1(Q[1]),
        .I2(Q[2]),
        .I3(gmem_WREADY),
        .I4(ap_reg_ioackin_gmem_WREADY),
        .O(s_ready_t_reg_0[1]));
  LUT4 #(
    .INIT(16'h88B8)) 
    \ap_CS_fsm[9]_i_1 
       (.I0(\ap_CS_fsm_reg[9] ),
        .I1(Q[0]),
        .I2(Q[1]),
        .I3(gmem_AWREADY),
        .O(s_ready_t_reg_0[0]));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[0]_i_1 
       (.I0(data_p2[0]),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[29]_0 [0]),
        .O(\data_p1[0]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[10]_i_1 
       (.I0(data_p2[10]),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[29]_0 [10]),
        .O(\data_p1[10]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[11]_i_1 
       (.I0(data_p2[11]),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[29]_0 [11]),
        .O(\data_p1[11]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[12]_i_1 
       (.I0(data_p2[12]),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[29]_0 [12]),
        .O(\data_p1[12]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[13]_i_1 
       (.I0(data_p2[13]),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[29]_0 [13]),
        .O(\data_p1[13]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[14]_i_1 
       (.I0(data_p2[14]),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[29]_0 [14]),
        .O(\data_p1[14]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[15]_i_1 
       (.I0(data_p2[15]),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[29]_0 [15]),
        .O(\data_p1[15]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[16]_i_1 
       (.I0(data_p2[16]),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[29]_0 [16]),
        .O(\data_p1[16]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[17]_i_1 
       (.I0(data_p2[17]),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[29]_0 [17]),
        .O(\data_p1[17]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[18]_i_1 
       (.I0(data_p2[18]),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[29]_0 [18]),
        .O(\data_p1[18]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[19]_i_1 
       (.I0(data_p2[19]),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[29]_0 [19]),
        .O(\data_p1[19]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[1]_i_1 
       (.I0(data_p2[1]),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[29]_0 [1]),
        .O(\data_p1[1]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[20]_i_1 
       (.I0(data_p2[20]),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[29]_0 [20]),
        .O(\data_p1[20]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[21]_i_1 
       (.I0(data_p2[21]),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[29]_0 [21]),
        .O(\data_p1[21]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[22]_i_1 
       (.I0(data_p2[22]),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[29]_0 [22]),
        .O(\data_p1[22]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[23]_i_1 
       (.I0(data_p2[23]),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[29]_0 [23]),
        .O(\data_p1[23]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[24]_i_1 
       (.I0(data_p2[24]),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[29]_0 [24]),
        .O(\data_p1[24]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[25]_i_1 
       (.I0(data_p2[25]),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[29]_0 [25]),
        .O(\data_p1[25]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[26]_i_1 
       (.I0(data_p2[26]),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[29]_0 [26]),
        .O(\data_p1[26]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[27]_i_1 
       (.I0(data_p2[27]),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[29]_0 [27]),
        .O(\data_p1[27]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[28]_i_1 
       (.I0(data_p2[28]),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[29]_0 [28]),
        .O(\data_p1[28]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'h44D0)) 
    \data_p1[29]_i_1 
       (.I0(state__0[1]),
        .I1(rs2f_wreq_ack),
        .I2(Q[1]),
        .I3(state__0[0]),
        .O(load_p1));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[29]_i_2 
       (.I0(data_p2[29]),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[29]_0 [29]),
        .O(\data_p1[29]_i_2_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[2]_i_1 
       (.I0(data_p2[2]),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[29]_0 [2]),
        .O(\data_p1[2]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[3]_i_1 
       (.I0(data_p2[3]),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[29]_0 [3]),
        .O(\data_p1[3]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[4]_i_1 
       (.I0(data_p2[4]),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[29]_0 [4]),
        .O(\data_p1[4]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[5]_i_1 
       (.I0(data_p2[5]),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[29]_0 [5]),
        .O(\data_p1[5]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[6]_i_1 
       (.I0(data_p2[6]),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[29]_0 [6]),
        .O(\data_p1[6]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[7]_i_1 
       (.I0(data_p2[7]),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[29]_0 [7]),
        .O(\data_p1[7]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[8]_i_1 
       (.I0(data_p2[8]),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[29]_0 [8]),
        .O(\data_p1[8]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[9]_i_1 
       (.I0(data_p2[9]),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[29]_0 [9]),
        .O(\data_p1[9]_i_1_n_2 ));
  FDRE \data_p1_reg[0] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[0]_i_1_n_2 ),
        .Q(\data_p1_reg[29]_0 [0]),
        .R(1'b0));
  FDRE \data_p1_reg[10] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[10]_i_1_n_2 ),
        .Q(\data_p1_reg[29]_0 [10]),
        .R(1'b0));
  FDRE \data_p1_reg[11] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[11]_i_1_n_2 ),
        .Q(\data_p1_reg[29]_0 [11]),
        .R(1'b0));
  FDRE \data_p1_reg[12] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[12]_i_1_n_2 ),
        .Q(\data_p1_reg[29]_0 [12]),
        .R(1'b0));
  FDRE \data_p1_reg[13] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[13]_i_1_n_2 ),
        .Q(\data_p1_reg[29]_0 [13]),
        .R(1'b0));
  FDRE \data_p1_reg[14] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[14]_i_1_n_2 ),
        .Q(\data_p1_reg[29]_0 [14]),
        .R(1'b0));
  FDRE \data_p1_reg[15] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[15]_i_1_n_2 ),
        .Q(\data_p1_reg[29]_0 [15]),
        .R(1'b0));
  FDRE \data_p1_reg[16] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[16]_i_1_n_2 ),
        .Q(\data_p1_reg[29]_0 [16]),
        .R(1'b0));
  FDRE \data_p1_reg[17] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[17]_i_1_n_2 ),
        .Q(\data_p1_reg[29]_0 [17]),
        .R(1'b0));
  FDRE \data_p1_reg[18] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[18]_i_1_n_2 ),
        .Q(\data_p1_reg[29]_0 [18]),
        .R(1'b0));
  FDRE \data_p1_reg[19] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[19]_i_1_n_2 ),
        .Q(\data_p1_reg[29]_0 [19]),
        .R(1'b0));
  FDRE \data_p1_reg[1] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[1]_i_1_n_2 ),
        .Q(\data_p1_reg[29]_0 [1]),
        .R(1'b0));
  FDRE \data_p1_reg[20] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[20]_i_1_n_2 ),
        .Q(\data_p1_reg[29]_0 [20]),
        .R(1'b0));
  FDRE \data_p1_reg[21] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[21]_i_1_n_2 ),
        .Q(\data_p1_reg[29]_0 [21]),
        .R(1'b0));
  FDRE \data_p1_reg[22] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[22]_i_1_n_2 ),
        .Q(\data_p1_reg[29]_0 [22]),
        .R(1'b0));
  FDRE \data_p1_reg[23] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[23]_i_1_n_2 ),
        .Q(\data_p1_reg[29]_0 [23]),
        .R(1'b0));
  FDRE \data_p1_reg[24] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[24]_i_1_n_2 ),
        .Q(\data_p1_reg[29]_0 [24]),
        .R(1'b0));
  FDRE \data_p1_reg[25] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[25]_i_1_n_2 ),
        .Q(\data_p1_reg[29]_0 [25]),
        .R(1'b0));
  FDRE \data_p1_reg[26] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[26]_i_1_n_2 ),
        .Q(\data_p1_reg[29]_0 [26]),
        .R(1'b0));
  FDRE \data_p1_reg[27] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[27]_i_1_n_2 ),
        .Q(\data_p1_reg[29]_0 [27]),
        .R(1'b0));
  FDRE \data_p1_reg[28] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[28]_i_1_n_2 ),
        .Q(\data_p1_reg[29]_0 [28]),
        .R(1'b0));
  FDRE \data_p1_reg[29] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[29]_i_2_n_2 ),
        .Q(\data_p1_reg[29]_0 [29]),
        .R(1'b0));
  FDRE \data_p1_reg[2] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[2]_i_1_n_2 ),
        .Q(\data_p1_reg[29]_0 [2]),
        .R(1'b0));
  FDRE \data_p1_reg[3] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[3]_i_1_n_2 ),
        .Q(\data_p1_reg[29]_0 [3]),
        .R(1'b0));
  FDRE \data_p1_reg[4] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[4]_i_1_n_2 ),
        .Q(\data_p1_reg[29]_0 [4]),
        .R(1'b0));
  FDRE \data_p1_reg[5] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[5]_i_1_n_2 ),
        .Q(\data_p1_reg[29]_0 [5]),
        .R(1'b0));
  FDRE \data_p1_reg[6] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[6]_i_1_n_2 ),
        .Q(\data_p1_reg[29]_0 [6]),
        .R(1'b0));
  FDRE \data_p1_reg[7] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[7]_i_1_n_2 ),
        .Q(\data_p1_reg[29]_0 [7]),
        .R(1'b0));
  FDRE \data_p1_reg[8] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[8]_i_1_n_2 ),
        .Q(\data_p1_reg[29]_0 [8]),
        .R(1'b0));
  FDRE \data_p1_reg[9] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[9]_i_1_n_2 ),
        .Q(\data_p1_reg[29]_0 [9]),
        .R(1'b0));
  LUT2 #(
    .INIT(4'h8)) 
    \data_p2[29]_i_1 
       (.I0(Q[1]),
        .I1(gmem_AWREADY),
        .O(load_p2));
  FDRE \data_p2_reg[0] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[29]_0 [0]),
        .Q(data_p2[0]),
        .R(1'b0));
  FDRE \data_p2_reg[10] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[29]_0 [10]),
        .Q(data_p2[10]),
        .R(1'b0));
  FDRE \data_p2_reg[11] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[29]_0 [11]),
        .Q(data_p2[11]),
        .R(1'b0));
  FDRE \data_p2_reg[12] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[29]_0 [12]),
        .Q(data_p2[12]),
        .R(1'b0));
  FDRE \data_p2_reg[13] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[29]_0 [13]),
        .Q(data_p2[13]),
        .R(1'b0));
  FDRE \data_p2_reg[14] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[29]_0 [14]),
        .Q(data_p2[14]),
        .R(1'b0));
  FDRE \data_p2_reg[15] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[29]_0 [15]),
        .Q(data_p2[15]),
        .R(1'b0));
  FDRE \data_p2_reg[16] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[29]_0 [16]),
        .Q(data_p2[16]),
        .R(1'b0));
  FDRE \data_p2_reg[17] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[29]_0 [17]),
        .Q(data_p2[17]),
        .R(1'b0));
  FDRE \data_p2_reg[18] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[29]_0 [18]),
        .Q(data_p2[18]),
        .R(1'b0));
  FDRE \data_p2_reg[19] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[29]_0 [19]),
        .Q(data_p2[19]),
        .R(1'b0));
  FDRE \data_p2_reg[1] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[29]_0 [1]),
        .Q(data_p2[1]),
        .R(1'b0));
  FDRE \data_p2_reg[20] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[29]_0 [20]),
        .Q(data_p2[20]),
        .R(1'b0));
  FDRE \data_p2_reg[21] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[29]_0 [21]),
        .Q(data_p2[21]),
        .R(1'b0));
  FDRE \data_p2_reg[22] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[29]_0 [22]),
        .Q(data_p2[22]),
        .R(1'b0));
  FDRE \data_p2_reg[23] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[29]_0 [23]),
        .Q(data_p2[23]),
        .R(1'b0));
  FDRE \data_p2_reg[24] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[29]_0 [24]),
        .Q(data_p2[24]),
        .R(1'b0));
  FDRE \data_p2_reg[25] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[29]_0 [25]),
        .Q(data_p2[25]),
        .R(1'b0));
  FDRE \data_p2_reg[26] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[29]_0 [26]),
        .Q(data_p2[26]),
        .R(1'b0));
  FDRE \data_p2_reg[27] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[29]_0 [27]),
        .Q(data_p2[27]),
        .R(1'b0));
  FDRE \data_p2_reg[28] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[29]_0 [28]),
        .Q(data_p2[28]),
        .R(1'b0));
  FDRE \data_p2_reg[29] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[29]_0 [29]),
        .Q(data_p2[29]),
        .R(1'b0));
  FDRE \data_p2_reg[2] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[29]_0 [2]),
        .Q(data_p2[2]),
        .R(1'b0));
  FDRE \data_p2_reg[3] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[29]_0 [3]),
        .Q(data_p2[3]),
        .R(1'b0));
  FDRE \data_p2_reg[4] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[29]_0 [4]),
        .Q(data_p2[4]),
        .R(1'b0));
  FDRE \data_p2_reg[5] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[29]_0 [5]),
        .Q(data_p2[5]),
        .R(1'b0));
  FDRE \data_p2_reg[6] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[29]_0 [6]),
        .Q(data_p2[6]),
        .R(1'b0));
  FDRE \data_p2_reg[7] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[29]_0 [7]),
        .Q(data_p2[7]),
        .R(1'b0));
  FDRE \data_p2_reg[8] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[29]_0 [8]),
        .Q(data_p2[8]),
        .R(1'b0));
  FDRE \data_p2_reg[9] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[29]_0 [9]),
        .Q(data_p2[9]),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair172" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \mem_reg[4][0]_srl5_i_1__0 
       (.I0(\state_reg[0]_0 ),
        .I1(rs2f_wreq_ack),
        .O(push));
  (* SOFT_HLUTNM = "soft_lutpair171" *) 
  LUT5 #(
    .INIT(32'hFFDF4455)) 
    s_ready_t_i_1
       (.I0(state__0[1]),
        .I1(rs2f_wreq_ack),
        .I2(Q[1]),
        .I3(state__0[0]),
        .I4(gmem_AWREADY),
        .O(s_ready_t_i_1_n_2));
  FDRE s_ready_t_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_ready_t_i_1_n_2),
        .Q(gmem_AWREADY),
        .R(SR));
  (* SOFT_HLUTNM = "soft_lutpair172" *) 
  LUT5 #(
    .INIT(32'hFCCC4C4C)) 
    \state[0]_i_1 
       (.I0(rs2f_wreq_ack),
        .I1(\state_reg[0]_0 ),
        .I2(state),
        .I3(gmem_AWREADY),
        .I4(Q[1]),
        .O(\state[0]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFF4F)) 
    \state[1]_i_1__0 
       (.I0(Q[1]),
        .I1(state),
        .I2(\state_reg[0]_0 ),
        .I3(rs2f_wreq_ack),
        .O(\state[1]_i_1__0_n_2 ));
  FDRE \state_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\state[0]_i_1_n_2 ),
        .Q(\state_reg[0]_0 ),
        .R(SR));
  FDSE \state_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\state[1]_i_1__0_n_2 ),
        .Q(state),
        .S(SR));
endmodule

(* ORIG_REF_NAME = "simple_accel_core_gmem_m_axi_reg_slice" *) 
module design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_reg_slice_2
   (E,
    push,
    \data_p1_reg[63]_0 ,
    SR,
    ap_clk,
    rs2f_rreq_ack,
    Q,
    \data_p2_reg[63]_0 );
  output [0:0]E;
  output push;
  output [61:0]\data_p1_reg[63]_0 ;
  input [0:0]SR;
  input ap_clk;
  input rs2f_rreq_ack;
  input [0:0]Q;
  input [61:0]\data_p2_reg[63]_0 ;

  wire [0:0]E;
  wire [0:0]Q;
  wire [0:0]SR;
  wire ap_clk;
  wire \data_p1[0]_i_1__0_n_2 ;
  wire \data_p1[10]_i_1__0_n_2 ;
  wire \data_p1[11]_i_1__0_n_2 ;
  wire \data_p1[12]_i_1__0_n_2 ;
  wire \data_p1[13]_i_1__0_n_2 ;
  wire \data_p1[14]_i_1__0_n_2 ;
  wire \data_p1[15]_i_1__0_n_2 ;
  wire \data_p1[16]_i_1__0_n_2 ;
  wire \data_p1[17]_i_1__0_n_2 ;
  wire \data_p1[18]_i_1__0_n_2 ;
  wire \data_p1[19]_i_1__0_n_2 ;
  wire \data_p1[1]_i_1__0_n_2 ;
  wire \data_p1[20]_i_1__0_n_2 ;
  wire \data_p1[21]_i_1__0_n_2 ;
  wire \data_p1[22]_i_1__0_n_2 ;
  wire \data_p1[23]_i_1__0_n_2 ;
  wire \data_p1[24]_i_1__0_n_2 ;
  wire \data_p1[25]_i_1__0_n_2 ;
  wire \data_p1[26]_i_1__0_n_2 ;
  wire \data_p1[27]_i_1__0_n_2 ;
  wire \data_p1[28]_i_1__0_n_2 ;
  wire \data_p1[29]_i_1__0_n_2 ;
  wire \data_p1[2]_i_1__0_n_2 ;
  wire \data_p1[32]_i_1_n_2 ;
  wire \data_p1[33]_i_1_n_2 ;
  wire \data_p1[34]_i_1_n_2 ;
  wire \data_p1[35]_i_1_n_2 ;
  wire \data_p1[36]_i_1_n_2 ;
  wire \data_p1[37]_i_1_n_2 ;
  wire \data_p1[38]_i_1_n_2 ;
  wire \data_p1[39]_i_1_n_2 ;
  wire \data_p1[3]_i_1__0_n_2 ;
  wire \data_p1[40]_i_1_n_2 ;
  wire \data_p1[41]_i_1_n_2 ;
  wire \data_p1[42]_i_1_n_2 ;
  wire \data_p1[43]_i_1_n_2 ;
  wire \data_p1[44]_i_1_n_2 ;
  wire \data_p1[45]_i_1_n_2 ;
  wire \data_p1[46]_i_1_n_2 ;
  wire \data_p1[47]_i_1_n_2 ;
  wire \data_p1[48]_i_1_n_2 ;
  wire \data_p1[49]_i_1_n_2 ;
  wire \data_p1[4]_i_1__0_n_2 ;
  wire \data_p1[50]_i_1_n_2 ;
  wire \data_p1[51]_i_1_n_2 ;
  wire \data_p1[52]_i_1_n_2 ;
  wire \data_p1[53]_i_1_n_2 ;
  wire \data_p1[54]_i_1_n_2 ;
  wire \data_p1[55]_i_1_n_2 ;
  wire \data_p1[56]_i_1_n_2 ;
  wire \data_p1[57]_i_1_n_2 ;
  wire \data_p1[58]_i_1_n_2 ;
  wire \data_p1[59]_i_1_n_2 ;
  wire \data_p1[5]_i_1__0_n_2 ;
  wire \data_p1[60]_i_1_n_2 ;
  wire \data_p1[61]_i_1_n_2 ;
  wire \data_p1[62]_i_1_n_2 ;
  wire \data_p1[63]_i_2_n_2 ;
  wire \data_p1[6]_i_1__0_n_2 ;
  wire \data_p1[7]_i_1__0_n_2 ;
  wire \data_p1[8]_i_1__0_n_2 ;
  wire \data_p1[9]_i_1__0_n_2 ;
  wire [61:0]\data_p1_reg[63]_0 ;
  wire [61:0]\data_p2_reg[63]_0 ;
  wire \data_p2_reg_n_2_[0] ;
  wire \data_p2_reg_n_2_[10] ;
  wire \data_p2_reg_n_2_[11] ;
  wire \data_p2_reg_n_2_[12] ;
  wire \data_p2_reg_n_2_[13] ;
  wire \data_p2_reg_n_2_[14] ;
  wire \data_p2_reg_n_2_[15] ;
  wire \data_p2_reg_n_2_[16] ;
  wire \data_p2_reg_n_2_[17] ;
  wire \data_p2_reg_n_2_[18] ;
  wire \data_p2_reg_n_2_[19] ;
  wire \data_p2_reg_n_2_[1] ;
  wire \data_p2_reg_n_2_[20] ;
  wire \data_p2_reg_n_2_[21] ;
  wire \data_p2_reg_n_2_[22] ;
  wire \data_p2_reg_n_2_[23] ;
  wire \data_p2_reg_n_2_[24] ;
  wire \data_p2_reg_n_2_[25] ;
  wire \data_p2_reg_n_2_[26] ;
  wire \data_p2_reg_n_2_[27] ;
  wire \data_p2_reg_n_2_[28] ;
  wire \data_p2_reg_n_2_[29] ;
  wire \data_p2_reg_n_2_[2] ;
  wire \data_p2_reg_n_2_[32] ;
  wire \data_p2_reg_n_2_[33] ;
  wire \data_p2_reg_n_2_[34] ;
  wire \data_p2_reg_n_2_[35] ;
  wire \data_p2_reg_n_2_[36] ;
  wire \data_p2_reg_n_2_[37] ;
  wire \data_p2_reg_n_2_[38] ;
  wire \data_p2_reg_n_2_[39] ;
  wire \data_p2_reg_n_2_[3] ;
  wire \data_p2_reg_n_2_[40] ;
  wire \data_p2_reg_n_2_[41] ;
  wire \data_p2_reg_n_2_[42] ;
  wire \data_p2_reg_n_2_[43] ;
  wire \data_p2_reg_n_2_[44] ;
  wire \data_p2_reg_n_2_[45] ;
  wire \data_p2_reg_n_2_[46] ;
  wire \data_p2_reg_n_2_[47] ;
  wire \data_p2_reg_n_2_[48] ;
  wire \data_p2_reg_n_2_[49] ;
  wire \data_p2_reg_n_2_[4] ;
  wire \data_p2_reg_n_2_[50] ;
  wire \data_p2_reg_n_2_[51] ;
  wire \data_p2_reg_n_2_[52] ;
  wire \data_p2_reg_n_2_[53] ;
  wire \data_p2_reg_n_2_[54] ;
  wire \data_p2_reg_n_2_[55] ;
  wire \data_p2_reg_n_2_[56] ;
  wire \data_p2_reg_n_2_[57] ;
  wire \data_p2_reg_n_2_[58] ;
  wire \data_p2_reg_n_2_[59] ;
  wire \data_p2_reg_n_2_[5] ;
  wire \data_p2_reg_n_2_[60] ;
  wire \data_p2_reg_n_2_[61] ;
  wire \data_p2_reg_n_2_[62] ;
  wire \data_p2_reg_n_2_[63] ;
  wire \data_p2_reg_n_2_[6] ;
  wire \data_p2_reg_n_2_[7] ;
  wire \data_p2_reg_n_2_[8] ;
  wire \data_p2_reg_n_2_[9] ;
  wire gmem_ARREADY;
  wire load_p1;
  wire [1:0]next__0;
  wire push;
  wire rs2f_rreq_ack;
  wire rs2f_rreq_valid;
  wire s_ready_t_i_1__0_n_2;
  wire [1:1]state;
  wire \state[0]_i_1__0_n_2 ;
  wire \state[1]_i_1__1_n_2 ;
  wire [1:0]state__0;

  LUT4 #(
    .INIT(16'h0602)) 
    \FSM_sequential_state[0]_i_1__0 
       (.I0(state__0[0]),
        .I1(state__0[1]),
        .I2(rs2f_rreq_ack),
        .I3(Q),
        .O(next__0[0]));
  (* SOFT_HLUTNM = "soft_lutpair86" *) 
  LUT5 #(
    .INIT(32'h3E020C30)) 
    \FSM_sequential_state[1]_i_1__0 
       (.I0(gmem_ARREADY),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(rs2f_rreq_ack),
        .I4(Q),
        .O(next__0[1]));
  (* FSM_ENCODED_STATES = "ZERO:00,TWO:01,ONE:10" *) 
  FDRE \FSM_sequential_state_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(next__0[0]),
        .Q(state__0[0]),
        .R(SR));
  (* FSM_ENCODED_STATES = "ZERO:00,TWO:01,ONE:10" *) 
  FDRE \FSM_sequential_state_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(next__0[1]),
        .Q(state__0[1]),
        .R(SR));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[0]_i_1__0 
       (.I0(\data_p2_reg_n_2_[0] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [0]),
        .O(\data_p1[0]_i_1__0_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[10]_i_1__0 
       (.I0(\data_p2_reg_n_2_[10] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [10]),
        .O(\data_p1[10]_i_1__0_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[11]_i_1__0 
       (.I0(\data_p2_reg_n_2_[11] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [11]),
        .O(\data_p1[11]_i_1__0_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[12]_i_1__0 
       (.I0(\data_p2_reg_n_2_[12] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [12]),
        .O(\data_p1[12]_i_1__0_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[13]_i_1__0 
       (.I0(\data_p2_reg_n_2_[13] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [13]),
        .O(\data_p1[13]_i_1__0_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[14]_i_1__0 
       (.I0(\data_p2_reg_n_2_[14] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [14]),
        .O(\data_p1[14]_i_1__0_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[15]_i_1__0 
       (.I0(\data_p2_reg_n_2_[15] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [15]),
        .O(\data_p1[15]_i_1__0_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[16]_i_1__0 
       (.I0(\data_p2_reg_n_2_[16] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [16]),
        .O(\data_p1[16]_i_1__0_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[17]_i_1__0 
       (.I0(\data_p2_reg_n_2_[17] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [17]),
        .O(\data_p1[17]_i_1__0_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[18]_i_1__0 
       (.I0(\data_p2_reg_n_2_[18] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [18]),
        .O(\data_p1[18]_i_1__0_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[19]_i_1__0 
       (.I0(\data_p2_reg_n_2_[19] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [19]),
        .O(\data_p1[19]_i_1__0_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[1]_i_1__0 
       (.I0(\data_p2_reg_n_2_[1] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [1]),
        .O(\data_p1[1]_i_1__0_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[20]_i_1__0 
       (.I0(\data_p2_reg_n_2_[20] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [20]),
        .O(\data_p1[20]_i_1__0_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[21]_i_1__0 
       (.I0(\data_p2_reg_n_2_[21] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [21]),
        .O(\data_p1[21]_i_1__0_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[22]_i_1__0 
       (.I0(\data_p2_reg_n_2_[22] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [22]),
        .O(\data_p1[22]_i_1__0_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[23]_i_1__0 
       (.I0(\data_p2_reg_n_2_[23] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [23]),
        .O(\data_p1[23]_i_1__0_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[24]_i_1__0 
       (.I0(\data_p2_reg_n_2_[24] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [24]),
        .O(\data_p1[24]_i_1__0_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[25]_i_1__0 
       (.I0(\data_p2_reg_n_2_[25] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [25]),
        .O(\data_p1[25]_i_1__0_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[26]_i_1__0 
       (.I0(\data_p2_reg_n_2_[26] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [26]),
        .O(\data_p1[26]_i_1__0_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[27]_i_1__0 
       (.I0(\data_p2_reg_n_2_[27] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [27]),
        .O(\data_p1[27]_i_1__0_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[28]_i_1__0 
       (.I0(\data_p2_reg_n_2_[28] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [28]),
        .O(\data_p1[28]_i_1__0_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[29]_i_1__0 
       (.I0(\data_p2_reg_n_2_[29] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [29]),
        .O(\data_p1[29]_i_1__0_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[2]_i_1__0 
       (.I0(\data_p2_reg_n_2_[2] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [2]),
        .O(\data_p1[2]_i_1__0_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[32]_i_1 
       (.I0(\data_p2_reg_n_2_[32] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [30]),
        .O(\data_p1[32]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[33]_i_1 
       (.I0(\data_p2_reg_n_2_[33] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [31]),
        .O(\data_p1[33]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[34]_i_1 
       (.I0(\data_p2_reg_n_2_[34] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [32]),
        .O(\data_p1[34]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[35]_i_1 
       (.I0(\data_p2_reg_n_2_[35] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [33]),
        .O(\data_p1[35]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[36]_i_1 
       (.I0(\data_p2_reg_n_2_[36] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [34]),
        .O(\data_p1[36]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[37]_i_1 
       (.I0(\data_p2_reg_n_2_[37] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [35]),
        .O(\data_p1[37]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[38]_i_1 
       (.I0(\data_p2_reg_n_2_[38] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [36]),
        .O(\data_p1[38]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[39]_i_1 
       (.I0(\data_p2_reg_n_2_[39] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [37]),
        .O(\data_p1[39]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[3]_i_1__0 
       (.I0(\data_p2_reg_n_2_[3] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [3]),
        .O(\data_p1[3]_i_1__0_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[40]_i_1 
       (.I0(\data_p2_reg_n_2_[40] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [38]),
        .O(\data_p1[40]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[41]_i_1 
       (.I0(\data_p2_reg_n_2_[41] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [39]),
        .O(\data_p1[41]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[42]_i_1 
       (.I0(\data_p2_reg_n_2_[42] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [40]),
        .O(\data_p1[42]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[43]_i_1 
       (.I0(\data_p2_reg_n_2_[43] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [41]),
        .O(\data_p1[43]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[44]_i_1 
       (.I0(\data_p2_reg_n_2_[44] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [42]),
        .O(\data_p1[44]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[45]_i_1 
       (.I0(\data_p2_reg_n_2_[45] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [43]),
        .O(\data_p1[45]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[46]_i_1 
       (.I0(\data_p2_reg_n_2_[46] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [44]),
        .O(\data_p1[46]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[47]_i_1 
       (.I0(\data_p2_reg_n_2_[47] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [45]),
        .O(\data_p1[47]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[48]_i_1 
       (.I0(\data_p2_reg_n_2_[48] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [46]),
        .O(\data_p1[48]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[49]_i_1 
       (.I0(\data_p2_reg_n_2_[49] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [47]),
        .O(\data_p1[49]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[4]_i_1__0 
       (.I0(\data_p2_reg_n_2_[4] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [4]),
        .O(\data_p1[4]_i_1__0_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[50]_i_1 
       (.I0(\data_p2_reg_n_2_[50] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [48]),
        .O(\data_p1[50]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[51]_i_1 
       (.I0(\data_p2_reg_n_2_[51] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [49]),
        .O(\data_p1[51]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[52]_i_1 
       (.I0(\data_p2_reg_n_2_[52] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [50]),
        .O(\data_p1[52]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[53]_i_1 
       (.I0(\data_p2_reg_n_2_[53] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [51]),
        .O(\data_p1[53]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[54]_i_1 
       (.I0(\data_p2_reg_n_2_[54] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [52]),
        .O(\data_p1[54]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[55]_i_1 
       (.I0(\data_p2_reg_n_2_[55] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [53]),
        .O(\data_p1[55]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[56]_i_1 
       (.I0(\data_p2_reg_n_2_[56] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [54]),
        .O(\data_p1[56]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[57]_i_1 
       (.I0(\data_p2_reg_n_2_[57] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [55]),
        .O(\data_p1[57]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[58]_i_1 
       (.I0(\data_p2_reg_n_2_[58] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [56]),
        .O(\data_p1[58]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[59]_i_1 
       (.I0(\data_p2_reg_n_2_[59] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [57]),
        .O(\data_p1[59]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[5]_i_1__0 
       (.I0(\data_p2_reg_n_2_[5] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [5]),
        .O(\data_p1[5]_i_1__0_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[60]_i_1 
       (.I0(\data_p2_reg_n_2_[60] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [58]),
        .O(\data_p1[60]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[61]_i_1 
       (.I0(\data_p2_reg_n_2_[61] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [59]),
        .O(\data_p1[61]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[62]_i_1 
       (.I0(\data_p2_reg_n_2_[62] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [60]),
        .O(\data_p1[62]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'h4E04)) 
    \data_p1[63]_i_1 
       (.I0(state__0[0]),
        .I1(Q),
        .I2(state__0[1]),
        .I3(rs2f_rreq_ack),
        .O(load_p1));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[63]_i_2 
       (.I0(\data_p2_reg_n_2_[63] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [61]),
        .O(\data_p1[63]_i_2_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[6]_i_1__0 
       (.I0(\data_p2_reg_n_2_[6] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [6]),
        .O(\data_p1[6]_i_1__0_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[7]_i_1__0 
       (.I0(\data_p2_reg_n_2_[7] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [7]),
        .O(\data_p1[7]_i_1__0_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[8]_i_1__0 
       (.I0(\data_p2_reg_n_2_[8] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [8]),
        .O(\data_p1[8]_i_1__0_n_2 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \data_p1[9]_i_1__0 
       (.I0(\data_p2_reg_n_2_[9] ),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\data_p2_reg[63]_0 [9]),
        .O(\data_p1[9]_i_1__0_n_2 ));
  FDRE \data_p1_reg[0] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[0]_i_1__0_n_2 ),
        .Q(\data_p1_reg[63]_0 [0]),
        .R(1'b0));
  FDRE \data_p1_reg[10] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[10]_i_1__0_n_2 ),
        .Q(\data_p1_reg[63]_0 [10]),
        .R(1'b0));
  FDRE \data_p1_reg[11] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[11]_i_1__0_n_2 ),
        .Q(\data_p1_reg[63]_0 [11]),
        .R(1'b0));
  FDRE \data_p1_reg[12] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[12]_i_1__0_n_2 ),
        .Q(\data_p1_reg[63]_0 [12]),
        .R(1'b0));
  FDRE \data_p1_reg[13] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[13]_i_1__0_n_2 ),
        .Q(\data_p1_reg[63]_0 [13]),
        .R(1'b0));
  FDRE \data_p1_reg[14] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[14]_i_1__0_n_2 ),
        .Q(\data_p1_reg[63]_0 [14]),
        .R(1'b0));
  FDRE \data_p1_reg[15] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[15]_i_1__0_n_2 ),
        .Q(\data_p1_reg[63]_0 [15]),
        .R(1'b0));
  FDRE \data_p1_reg[16] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[16]_i_1__0_n_2 ),
        .Q(\data_p1_reg[63]_0 [16]),
        .R(1'b0));
  FDRE \data_p1_reg[17] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[17]_i_1__0_n_2 ),
        .Q(\data_p1_reg[63]_0 [17]),
        .R(1'b0));
  FDRE \data_p1_reg[18] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[18]_i_1__0_n_2 ),
        .Q(\data_p1_reg[63]_0 [18]),
        .R(1'b0));
  FDRE \data_p1_reg[19] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[19]_i_1__0_n_2 ),
        .Q(\data_p1_reg[63]_0 [19]),
        .R(1'b0));
  FDRE \data_p1_reg[1] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[1]_i_1__0_n_2 ),
        .Q(\data_p1_reg[63]_0 [1]),
        .R(1'b0));
  FDRE \data_p1_reg[20] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[20]_i_1__0_n_2 ),
        .Q(\data_p1_reg[63]_0 [20]),
        .R(1'b0));
  FDRE \data_p1_reg[21] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[21]_i_1__0_n_2 ),
        .Q(\data_p1_reg[63]_0 [21]),
        .R(1'b0));
  FDRE \data_p1_reg[22] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[22]_i_1__0_n_2 ),
        .Q(\data_p1_reg[63]_0 [22]),
        .R(1'b0));
  FDRE \data_p1_reg[23] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[23]_i_1__0_n_2 ),
        .Q(\data_p1_reg[63]_0 [23]),
        .R(1'b0));
  FDRE \data_p1_reg[24] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[24]_i_1__0_n_2 ),
        .Q(\data_p1_reg[63]_0 [24]),
        .R(1'b0));
  FDRE \data_p1_reg[25] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[25]_i_1__0_n_2 ),
        .Q(\data_p1_reg[63]_0 [25]),
        .R(1'b0));
  FDRE \data_p1_reg[26] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[26]_i_1__0_n_2 ),
        .Q(\data_p1_reg[63]_0 [26]),
        .R(1'b0));
  FDRE \data_p1_reg[27] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[27]_i_1__0_n_2 ),
        .Q(\data_p1_reg[63]_0 [27]),
        .R(1'b0));
  FDRE \data_p1_reg[28] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[28]_i_1__0_n_2 ),
        .Q(\data_p1_reg[63]_0 [28]),
        .R(1'b0));
  FDRE \data_p1_reg[29] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[29]_i_1__0_n_2 ),
        .Q(\data_p1_reg[63]_0 [29]),
        .R(1'b0));
  FDRE \data_p1_reg[2] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[2]_i_1__0_n_2 ),
        .Q(\data_p1_reg[63]_0 [2]),
        .R(1'b0));
  FDRE \data_p1_reg[32] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[32]_i_1_n_2 ),
        .Q(\data_p1_reg[63]_0 [30]),
        .R(1'b0));
  FDRE \data_p1_reg[33] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[33]_i_1_n_2 ),
        .Q(\data_p1_reg[63]_0 [31]),
        .R(1'b0));
  FDRE \data_p1_reg[34] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[34]_i_1_n_2 ),
        .Q(\data_p1_reg[63]_0 [32]),
        .R(1'b0));
  FDRE \data_p1_reg[35] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[35]_i_1_n_2 ),
        .Q(\data_p1_reg[63]_0 [33]),
        .R(1'b0));
  FDRE \data_p1_reg[36] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[36]_i_1_n_2 ),
        .Q(\data_p1_reg[63]_0 [34]),
        .R(1'b0));
  FDRE \data_p1_reg[37] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[37]_i_1_n_2 ),
        .Q(\data_p1_reg[63]_0 [35]),
        .R(1'b0));
  FDRE \data_p1_reg[38] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[38]_i_1_n_2 ),
        .Q(\data_p1_reg[63]_0 [36]),
        .R(1'b0));
  FDRE \data_p1_reg[39] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[39]_i_1_n_2 ),
        .Q(\data_p1_reg[63]_0 [37]),
        .R(1'b0));
  FDRE \data_p1_reg[3] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[3]_i_1__0_n_2 ),
        .Q(\data_p1_reg[63]_0 [3]),
        .R(1'b0));
  FDRE \data_p1_reg[40] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[40]_i_1_n_2 ),
        .Q(\data_p1_reg[63]_0 [38]),
        .R(1'b0));
  FDRE \data_p1_reg[41] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[41]_i_1_n_2 ),
        .Q(\data_p1_reg[63]_0 [39]),
        .R(1'b0));
  FDRE \data_p1_reg[42] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[42]_i_1_n_2 ),
        .Q(\data_p1_reg[63]_0 [40]),
        .R(1'b0));
  FDRE \data_p1_reg[43] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[43]_i_1_n_2 ),
        .Q(\data_p1_reg[63]_0 [41]),
        .R(1'b0));
  FDRE \data_p1_reg[44] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[44]_i_1_n_2 ),
        .Q(\data_p1_reg[63]_0 [42]),
        .R(1'b0));
  FDRE \data_p1_reg[45] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[45]_i_1_n_2 ),
        .Q(\data_p1_reg[63]_0 [43]),
        .R(1'b0));
  FDRE \data_p1_reg[46] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[46]_i_1_n_2 ),
        .Q(\data_p1_reg[63]_0 [44]),
        .R(1'b0));
  FDRE \data_p1_reg[47] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[47]_i_1_n_2 ),
        .Q(\data_p1_reg[63]_0 [45]),
        .R(1'b0));
  FDRE \data_p1_reg[48] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[48]_i_1_n_2 ),
        .Q(\data_p1_reg[63]_0 [46]),
        .R(1'b0));
  FDRE \data_p1_reg[49] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[49]_i_1_n_2 ),
        .Q(\data_p1_reg[63]_0 [47]),
        .R(1'b0));
  FDRE \data_p1_reg[4] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[4]_i_1__0_n_2 ),
        .Q(\data_p1_reg[63]_0 [4]),
        .R(1'b0));
  FDRE \data_p1_reg[50] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[50]_i_1_n_2 ),
        .Q(\data_p1_reg[63]_0 [48]),
        .R(1'b0));
  FDRE \data_p1_reg[51] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[51]_i_1_n_2 ),
        .Q(\data_p1_reg[63]_0 [49]),
        .R(1'b0));
  FDRE \data_p1_reg[52] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[52]_i_1_n_2 ),
        .Q(\data_p1_reg[63]_0 [50]),
        .R(1'b0));
  FDRE \data_p1_reg[53] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[53]_i_1_n_2 ),
        .Q(\data_p1_reg[63]_0 [51]),
        .R(1'b0));
  FDRE \data_p1_reg[54] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[54]_i_1_n_2 ),
        .Q(\data_p1_reg[63]_0 [52]),
        .R(1'b0));
  FDRE \data_p1_reg[55] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[55]_i_1_n_2 ),
        .Q(\data_p1_reg[63]_0 [53]),
        .R(1'b0));
  FDRE \data_p1_reg[56] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[56]_i_1_n_2 ),
        .Q(\data_p1_reg[63]_0 [54]),
        .R(1'b0));
  FDRE \data_p1_reg[57] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[57]_i_1_n_2 ),
        .Q(\data_p1_reg[63]_0 [55]),
        .R(1'b0));
  FDRE \data_p1_reg[58] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[58]_i_1_n_2 ),
        .Q(\data_p1_reg[63]_0 [56]),
        .R(1'b0));
  FDRE \data_p1_reg[59] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[59]_i_1_n_2 ),
        .Q(\data_p1_reg[63]_0 [57]),
        .R(1'b0));
  FDRE \data_p1_reg[5] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[5]_i_1__0_n_2 ),
        .Q(\data_p1_reg[63]_0 [5]),
        .R(1'b0));
  FDRE \data_p1_reg[60] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[60]_i_1_n_2 ),
        .Q(\data_p1_reg[63]_0 [58]),
        .R(1'b0));
  FDRE \data_p1_reg[61] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[61]_i_1_n_2 ),
        .Q(\data_p1_reg[63]_0 [59]),
        .R(1'b0));
  FDRE \data_p1_reg[62] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[62]_i_1_n_2 ),
        .Q(\data_p1_reg[63]_0 [60]),
        .R(1'b0));
  FDRE \data_p1_reg[63] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[63]_i_2_n_2 ),
        .Q(\data_p1_reg[63]_0 [61]),
        .R(1'b0));
  FDRE \data_p1_reg[6] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[6]_i_1__0_n_2 ),
        .Q(\data_p1_reg[63]_0 [6]),
        .R(1'b0));
  FDRE \data_p1_reg[7] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[7]_i_1__0_n_2 ),
        .Q(\data_p1_reg[63]_0 [7]),
        .R(1'b0));
  FDRE \data_p1_reg[8] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[8]_i_1__0_n_2 ),
        .Q(\data_p1_reg[63]_0 [8]),
        .R(1'b0));
  FDRE \data_p1_reg[9] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[9]_i_1__0_n_2 ),
        .Q(\data_p1_reg[63]_0 [9]),
        .R(1'b0));
  LUT2 #(
    .INIT(4'h8)) 
    \data_p2[63]_i_1 
       (.I0(Q),
        .I1(gmem_ARREADY),
        .O(E));
  FDRE \data_p2_reg[0] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [0]),
        .Q(\data_p2_reg_n_2_[0] ),
        .R(1'b0));
  FDRE \data_p2_reg[10] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [10]),
        .Q(\data_p2_reg_n_2_[10] ),
        .R(1'b0));
  FDRE \data_p2_reg[11] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [11]),
        .Q(\data_p2_reg_n_2_[11] ),
        .R(1'b0));
  FDRE \data_p2_reg[12] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [12]),
        .Q(\data_p2_reg_n_2_[12] ),
        .R(1'b0));
  FDRE \data_p2_reg[13] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [13]),
        .Q(\data_p2_reg_n_2_[13] ),
        .R(1'b0));
  FDRE \data_p2_reg[14] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [14]),
        .Q(\data_p2_reg_n_2_[14] ),
        .R(1'b0));
  FDRE \data_p2_reg[15] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [15]),
        .Q(\data_p2_reg_n_2_[15] ),
        .R(1'b0));
  FDRE \data_p2_reg[16] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [16]),
        .Q(\data_p2_reg_n_2_[16] ),
        .R(1'b0));
  FDRE \data_p2_reg[17] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [17]),
        .Q(\data_p2_reg_n_2_[17] ),
        .R(1'b0));
  FDRE \data_p2_reg[18] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [18]),
        .Q(\data_p2_reg_n_2_[18] ),
        .R(1'b0));
  FDRE \data_p2_reg[19] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [19]),
        .Q(\data_p2_reg_n_2_[19] ),
        .R(1'b0));
  FDRE \data_p2_reg[1] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [1]),
        .Q(\data_p2_reg_n_2_[1] ),
        .R(1'b0));
  FDRE \data_p2_reg[20] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [20]),
        .Q(\data_p2_reg_n_2_[20] ),
        .R(1'b0));
  FDRE \data_p2_reg[21] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [21]),
        .Q(\data_p2_reg_n_2_[21] ),
        .R(1'b0));
  FDRE \data_p2_reg[22] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [22]),
        .Q(\data_p2_reg_n_2_[22] ),
        .R(1'b0));
  FDRE \data_p2_reg[23] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [23]),
        .Q(\data_p2_reg_n_2_[23] ),
        .R(1'b0));
  FDRE \data_p2_reg[24] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [24]),
        .Q(\data_p2_reg_n_2_[24] ),
        .R(1'b0));
  FDRE \data_p2_reg[25] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [25]),
        .Q(\data_p2_reg_n_2_[25] ),
        .R(1'b0));
  FDRE \data_p2_reg[26] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [26]),
        .Q(\data_p2_reg_n_2_[26] ),
        .R(1'b0));
  FDRE \data_p2_reg[27] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [27]),
        .Q(\data_p2_reg_n_2_[27] ),
        .R(1'b0));
  FDRE \data_p2_reg[28] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [28]),
        .Q(\data_p2_reg_n_2_[28] ),
        .R(1'b0));
  FDRE \data_p2_reg[29] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [29]),
        .Q(\data_p2_reg_n_2_[29] ),
        .R(1'b0));
  FDRE \data_p2_reg[2] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [2]),
        .Q(\data_p2_reg_n_2_[2] ),
        .R(1'b0));
  FDRE \data_p2_reg[32] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [30]),
        .Q(\data_p2_reg_n_2_[32] ),
        .R(1'b0));
  FDRE \data_p2_reg[33] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [31]),
        .Q(\data_p2_reg_n_2_[33] ),
        .R(1'b0));
  FDRE \data_p2_reg[34] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [32]),
        .Q(\data_p2_reg_n_2_[34] ),
        .R(1'b0));
  FDRE \data_p2_reg[35] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [33]),
        .Q(\data_p2_reg_n_2_[35] ),
        .R(1'b0));
  FDRE \data_p2_reg[36] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [34]),
        .Q(\data_p2_reg_n_2_[36] ),
        .R(1'b0));
  FDRE \data_p2_reg[37] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [35]),
        .Q(\data_p2_reg_n_2_[37] ),
        .R(1'b0));
  FDRE \data_p2_reg[38] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [36]),
        .Q(\data_p2_reg_n_2_[38] ),
        .R(1'b0));
  FDRE \data_p2_reg[39] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [37]),
        .Q(\data_p2_reg_n_2_[39] ),
        .R(1'b0));
  FDRE \data_p2_reg[3] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [3]),
        .Q(\data_p2_reg_n_2_[3] ),
        .R(1'b0));
  FDRE \data_p2_reg[40] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [38]),
        .Q(\data_p2_reg_n_2_[40] ),
        .R(1'b0));
  FDRE \data_p2_reg[41] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [39]),
        .Q(\data_p2_reg_n_2_[41] ),
        .R(1'b0));
  FDRE \data_p2_reg[42] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [40]),
        .Q(\data_p2_reg_n_2_[42] ),
        .R(1'b0));
  FDRE \data_p2_reg[43] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [41]),
        .Q(\data_p2_reg_n_2_[43] ),
        .R(1'b0));
  FDRE \data_p2_reg[44] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [42]),
        .Q(\data_p2_reg_n_2_[44] ),
        .R(1'b0));
  FDRE \data_p2_reg[45] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [43]),
        .Q(\data_p2_reg_n_2_[45] ),
        .R(1'b0));
  FDRE \data_p2_reg[46] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [44]),
        .Q(\data_p2_reg_n_2_[46] ),
        .R(1'b0));
  FDRE \data_p2_reg[47] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [45]),
        .Q(\data_p2_reg_n_2_[47] ),
        .R(1'b0));
  FDRE \data_p2_reg[48] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [46]),
        .Q(\data_p2_reg_n_2_[48] ),
        .R(1'b0));
  FDRE \data_p2_reg[49] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [47]),
        .Q(\data_p2_reg_n_2_[49] ),
        .R(1'b0));
  FDRE \data_p2_reg[4] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [4]),
        .Q(\data_p2_reg_n_2_[4] ),
        .R(1'b0));
  FDRE \data_p2_reg[50] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [48]),
        .Q(\data_p2_reg_n_2_[50] ),
        .R(1'b0));
  FDRE \data_p2_reg[51] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [49]),
        .Q(\data_p2_reg_n_2_[51] ),
        .R(1'b0));
  FDRE \data_p2_reg[52] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [50]),
        .Q(\data_p2_reg_n_2_[52] ),
        .R(1'b0));
  FDRE \data_p2_reg[53] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [51]),
        .Q(\data_p2_reg_n_2_[53] ),
        .R(1'b0));
  FDRE \data_p2_reg[54] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [52]),
        .Q(\data_p2_reg_n_2_[54] ),
        .R(1'b0));
  FDRE \data_p2_reg[55] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [53]),
        .Q(\data_p2_reg_n_2_[55] ),
        .R(1'b0));
  FDRE \data_p2_reg[56] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [54]),
        .Q(\data_p2_reg_n_2_[56] ),
        .R(1'b0));
  FDRE \data_p2_reg[57] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [55]),
        .Q(\data_p2_reg_n_2_[57] ),
        .R(1'b0));
  FDRE \data_p2_reg[58] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [56]),
        .Q(\data_p2_reg_n_2_[58] ),
        .R(1'b0));
  FDRE \data_p2_reg[59] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [57]),
        .Q(\data_p2_reg_n_2_[59] ),
        .R(1'b0));
  FDRE \data_p2_reg[5] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [5]),
        .Q(\data_p2_reg_n_2_[5] ),
        .R(1'b0));
  FDRE \data_p2_reg[60] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [58]),
        .Q(\data_p2_reg_n_2_[60] ),
        .R(1'b0));
  FDRE \data_p2_reg[61] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [59]),
        .Q(\data_p2_reg_n_2_[61] ),
        .R(1'b0));
  FDRE \data_p2_reg[62] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [60]),
        .Q(\data_p2_reg_n_2_[62] ),
        .R(1'b0));
  FDRE \data_p2_reg[63] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [61]),
        .Q(\data_p2_reg_n_2_[63] ),
        .R(1'b0));
  FDRE \data_p2_reg[6] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [6]),
        .Q(\data_p2_reg_n_2_[6] ),
        .R(1'b0));
  FDRE \data_p2_reg[7] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [7]),
        .Q(\data_p2_reg_n_2_[7] ),
        .R(1'b0));
  FDRE \data_p2_reg[8] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [8]),
        .Q(\data_p2_reg_n_2_[8] ),
        .R(1'b0));
  FDRE \data_p2_reg[9] 
       (.C(ap_clk),
        .CE(E),
        .D(\data_p2_reg[63]_0 [9]),
        .Q(\data_p2_reg_n_2_[9] ),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair87" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \mem_reg[4][0]_srl5_i_1__1 
       (.I0(rs2f_rreq_valid),
        .I1(rs2f_rreq_ack),
        .O(push));
  (* SOFT_HLUTNM = "soft_lutpair86" *) 
  LUT5 #(
    .INIT(32'hFFBF0F05)) 
    s_ready_t_i_1__0
       (.I0(state__0[0]),
        .I1(Q),
        .I2(state__0[1]),
        .I3(rs2f_rreq_ack),
        .I4(gmem_ARREADY),
        .O(s_ready_t_i_1__0_n_2));
  FDRE s_ready_t_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_ready_t_i_1__0_n_2),
        .Q(gmem_ARREADY),
        .R(SR));
  (* SOFT_HLUTNM = "soft_lutpair87" *) 
  LUT5 #(
    .INIT(32'hFCCC4C4C)) 
    \state[0]_i_1__0 
       (.I0(rs2f_rreq_ack),
        .I1(rs2f_rreq_valid),
        .I2(state),
        .I3(gmem_ARREADY),
        .I4(Q),
        .O(\state[0]_i_1__0_n_2 ));
  LUT4 #(
    .INIT(16'hFF4F)) 
    \state[1]_i_1__1 
       (.I0(Q),
        .I1(state),
        .I2(rs2f_rreq_valid),
        .I3(rs2f_rreq_ack),
        .O(\state[1]_i_1__1_n_2 ));
  FDRE \state_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\state[0]_i_1__0_n_2 ),
        .Q(rs2f_rreq_valid),
        .R(SR));
  FDSE \state_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\state[1]_i_1__1_n_2 ),
        .Q(state),
        .S(SR));
endmodule

(* ORIG_REF_NAME = "simple_accel_core_gmem_m_axi_reg_slice" *) 
module design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_reg_slice__parameterized0
   (rdata_ack_t,
    \state_reg[0]_0 ,
    \ap_CS_fsm_reg[7] ,
    i_reg_137,
    i_reg_1370,
    \state_reg[0]_1 ,
    sum_reg_125,
    sum_reg_1250,
    \ap_CS_fsm_reg[8] ,
    \ap_CS_fsm_reg[8]_0 ,
    \ap_CS_fsm_reg[8]_1 ,
    \data_p1_reg[31]_0 ,
    SR,
    ap_clk,
    CO,
    ap_enable_reg_pp0_iter1_reg,
    ap_enable_reg_pp0_iter1_reg_0,
    ap_enable_reg_pp0_iter0,
    ap_rst_n,
    Q,
    ap_enable_reg_pp0_iter2_reg,
    s_ready_t_reg_0,
    exitcond_reg_251_pp0_iter1_reg,
    \data_p2_reg[31]_0 );
  output rdata_ack_t;
  output \state_reg[0]_0 ;
  output \ap_CS_fsm_reg[7] ;
  output i_reg_137;
  output i_reg_1370;
  output [0:0]\state_reg[0]_1 ;
  output sum_reg_125;
  output sum_reg_1250;
  output \ap_CS_fsm_reg[8] ;
  output \ap_CS_fsm_reg[8]_0 ;
  output \ap_CS_fsm_reg[8]_1 ;
  output [31:0]\data_p1_reg[31]_0 ;
  input [0:0]SR;
  input ap_clk;
  input [0:0]CO;
  input ap_enable_reg_pp0_iter1_reg;
  input ap_enable_reg_pp0_iter1_reg_0;
  input ap_enable_reg_pp0_iter0;
  input ap_rst_n;
  input [1:0]Q;
  input ap_enable_reg_pp0_iter2_reg;
  input s_ready_t_reg_0;
  input exitcond_reg_251_pp0_iter1_reg;
  input [31:0]\data_p2_reg[31]_0 ;

  wire [0:0]CO;
  wire \FSM_sequential_state[1]_i_2_n_2 ;
  wire [1:0]Q;
  wire [0:0]SR;
  wire \ap_CS_fsm_reg[7] ;
  wire \ap_CS_fsm_reg[8] ;
  wire \ap_CS_fsm_reg[8]_0 ;
  wire \ap_CS_fsm_reg[8]_1 ;
  wire ap_clk;
  wire ap_enable_reg_pp0_iter0;
  wire ap_enable_reg_pp0_iter0_i_2_n_2;
  wire ap_enable_reg_pp0_iter1_reg;
  wire ap_enable_reg_pp0_iter1_reg_0;
  wire ap_enable_reg_pp0_iter2_reg;
  wire ap_rst_n;
  wire \data_p1[0]_i_1__1_n_2 ;
  wire \data_p1[10]_i_1__1_n_2 ;
  wire \data_p1[11]_i_1__1_n_2 ;
  wire \data_p1[12]_i_1__1_n_2 ;
  wire \data_p1[13]_i_1__1_n_2 ;
  wire \data_p1[14]_i_1__1_n_2 ;
  wire \data_p1[15]_i_1__1_n_2 ;
  wire \data_p1[16]_i_1__1_n_2 ;
  wire \data_p1[17]_i_1__1_n_2 ;
  wire \data_p1[18]_i_1__1_n_2 ;
  wire \data_p1[19]_i_1__1_n_2 ;
  wire \data_p1[1]_i_1__1_n_2 ;
  wire \data_p1[20]_i_1__1_n_2 ;
  wire \data_p1[21]_i_1__1_n_2 ;
  wire \data_p1[22]_i_1__1_n_2 ;
  wire \data_p1[23]_i_1__1_n_2 ;
  wire \data_p1[24]_i_1__1_n_2 ;
  wire \data_p1[25]_i_1__1_n_2 ;
  wire \data_p1[26]_i_1__1_n_2 ;
  wire \data_p1[27]_i_1__1_n_2 ;
  wire \data_p1[28]_i_1__1_n_2 ;
  wire \data_p1[29]_i_1__1_n_2 ;
  wire \data_p1[2]_i_1__1_n_2 ;
  wire \data_p1[30]_i_1_n_2 ;
  wire \data_p1[31]_i_2_n_2 ;
  wire \data_p1[3]_i_1__1_n_2 ;
  wire \data_p1[4]_i_1__1_n_2 ;
  wire \data_p1[5]_i_1__1_n_2 ;
  wire \data_p1[6]_i_1__1_n_2 ;
  wire \data_p1[7]_i_1__1_n_2 ;
  wire \data_p1[8]_i_1__1_n_2 ;
  wire \data_p1[9]_i_1__1_n_2 ;
  wire [31:0]\data_p1_reg[31]_0 ;
  wire [31:0]\data_p2_reg[31]_0 ;
  wire \data_p2_reg_n_2_[0] ;
  wire \data_p2_reg_n_2_[10] ;
  wire \data_p2_reg_n_2_[11] ;
  wire \data_p2_reg_n_2_[12] ;
  wire \data_p2_reg_n_2_[13] ;
  wire \data_p2_reg_n_2_[14] ;
  wire \data_p2_reg_n_2_[15] ;
  wire \data_p2_reg_n_2_[16] ;
  wire \data_p2_reg_n_2_[17] ;
  wire \data_p2_reg_n_2_[18] ;
  wire \data_p2_reg_n_2_[19] ;
  wire \data_p2_reg_n_2_[1] ;
  wire \data_p2_reg_n_2_[20] ;
  wire \data_p2_reg_n_2_[21] ;
  wire \data_p2_reg_n_2_[22] ;
  wire \data_p2_reg_n_2_[23] ;
  wire \data_p2_reg_n_2_[24] ;
  wire \data_p2_reg_n_2_[25] ;
  wire \data_p2_reg_n_2_[26] ;
  wire \data_p2_reg_n_2_[27] ;
  wire \data_p2_reg_n_2_[28] ;
  wire \data_p2_reg_n_2_[29] ;
  wire \data_p2_reg_n_2_[2] ;
  wire \data_p2_reg_n_2_[30] ;
  wire \data_p2_reg_n_2_[31] ;
  wire \data_p2_reg_n_2_[3] ;
  wire \data_p2_reg_n_2_[4] ;
  wire \data_p2_reg_n_2_[5] ;
  wire \data_p2_reg_n_2_[6] ;
  wire \data_p2_reg_n_2_[7] ;
  wire \data_p2_reg_n_2_[8] ;
  wire \data_p2_reg_n_2_[9] ;
  wire exitcond_reg_251_pp0_iter1_reg;
  wire gmem_RVALID;
  wire i_reg_137;
  wire i_reg_1370;
  wire load_p1;
  wire load_p2;
  wire [1:0]next__0;
  wire rdata_ack_t;
  wire s_ready_t_i_1__1_n_2;
  wire s_ready_t_reg_0;
  wire [1:1]state;
  wire \state[0]_i_1__1_n_2 ;
  wire \state[1]_i_1_n_2 ;
  wire [1:0]state__0;
  wire \state_reg[0]_0 ;
  wire [0:0]\state_reg[0]_1 ;
  wire sum_reg_125;
  wire sum_reg_1250;

  LUT4 #(
    .INIT(16'h0602)) 
    \FSM_sequential_state[0]_i_1__1 
       (.I0(state__0[0]),
        .I1(state__0[1]),
        .I2(\FSM_sequential_state[1]_i_2_n_2 ),
        .I3(s_ready_t_reg_0),
        .O(next__0[0]));
  (* SOFT_HLUTNM = "soft_lutpair85" *) 
  LUT5 #(
    .INIT(32'h3E020C30)) 
    \FSM_sequential_state[1]_i_1__1 
       (.I0(rdata_ack_t),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(\FSM_sequential_state[1]_i_2_n_2 ),
        .I4(s_ready_t_reg_0),
        .O(next__0[1]));
  (* SOFT_HLUTNM = "soft_lutpair82" *) 
  LUT4 #(
    .INIT(16'h0080)) 
    \FSM_sequential_state[1]_i_2 
       (.I0(gmem_RVALID),
        .I1(Q[1]),
        .I2(ap_enable_reg_pp0_iter1_reg),
        .I3(ap_enable_reg_pp0_iter1_reg_0),
        .O(\FSM_sequential_state[1]_i_2_n_2 ));
  (* FSM_ENCODED_STATES = "ZERO:00,TWO:01,ONE:10" *) 
  FDRE \FSM_sequential_state_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(next__0[0]),
        .Q(state__0[0]),
        .R(SR));
  (* FSM_ENCODED_STATES = "ZERO:00,TWO:01,ONE:10" *) 
  FDRE \FSM_sequential_state_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(next__0[1]),
        .Q(state__0[1]),
        .R(SR));
  LUT6 #(
    .INIT(64'hDFDFDF0000000000)) 
    ap_enable_reg_pp0_iter0_i_1
       (.I0(Q[1]),
        .I1(ap_enable_reg_pp0_iter0_i_2_n_2),
        .I2(CO),
        .I3(Q[0]),
        .I4(ap_enable_reg_pp0_iter0),
        .I5(ap_rst_n),
        .O(\ap_CS_fsm_reg[8] ));
  (* SOFT_HLUTNM = "soft_lutpair83" *) 
  LUT3 #(
    .INIT(8'h04)) 
    ap_enable_reg_pp0_iter0_i_2
       (.I0(gmem_RVALID),
        .I1(ap_enable_reg_pp0_iter1_reg),
        .I2(ap_enable_reg_pp0_iter1_reg_0),
        .O(ap_enable_reg_pp0_iter0_i_2_n_2));
  LUT6 #(
    .INIT(64'h5575003000000000)) 
    ap_enable_reg_pp0_iter1_i_1
       (.I0(CO),
        .I1(gmem_RVALID),
        .I2(ap_enable_reg_pp0_iter1_reg),
        .I3(ap_enable_reg_pp0_iter1_reg_0),
        .I4(ap_enable_reg_pp0_iter0),
        .I5(ap_rst_n),
        .O(\state_reg[0]_0 ));
  LUT6 #(
    .INIT(64'hFF00F40000000000)) 
    ap_enable_reg_pp0_iter2_i_1
       (.I0(Q[0]),
        .I1(ap_enable_reg_pp0_iter2_reg),
        .I2(gmem_RVALID),
        .I3(ap_enable_reg_pp0_iter1_reg),
        .I4(ap_enable_reg_pp0_iter1_reg_0),
        .I5(ap_rst_n),
        .O(\ap_CS_fsm_reg[7] ));
  LUT4 #(
    .INIT(16'hBA8A)) 
    \data_p1[0]_i_1__1 
       (.I0(\data_p2_reg[31]_0 [0]),
        .I1(state__0[1]),
        .I2(state__0[0]),
        .I3(\data_p2_reg_n_2_[0] ),
        .O(\data_p1[0]_i_1__1_n_2 ));
  LUT4 #(
    .INIT(16'hBA8A)) 
    \data_p1[10]_i_1__1 
       (.I0(\data_p2_reg[31]_0 [10]),
        .I1(state__0[1]),
        .I2(state__0[0]),
        .I3(\data_p2_reg_n_2_[10] ),
        .O(\data_p1[10]_i_1__1_n_2 ));
  LUT4 #(
    .INIT(16'hBA8A)) 
    \data_p1[11]_i_1__1 
       (.I0(\data_p2_reg[31]_0 [11]),
        .I1(state__0[1]),
        .I2(state__0[0]),
        .I3(\data_p2_reg_n_2_[11] ),
        .O(\data_p1[11]_i_1__1_n_2 ));
  LUT4 #(
    .INIT(16'hBA8A)) 
    \data_p1[12]_i_1__1 
       (.I0(\data_p2_reg[31]_0 [12]),
        .I1(state__0[1]),
        .I2(state__0[0]),
        .I3(\data_p2_reg_n_2_[12] ),
        .O(\data_p1[12]_i_1__1_n_2 ));
  LUT4 #(
    .INIT(16'hBA8A)) 
    \data_p1[13]_i_1__1 
       (.I0(\data_p2_reg[31]_0 [13]),
        .I1(state__0[1]),
        .I2(state__0[0]),
        .I3(\data_p2_reg_n_2_[13] ),
        .O(\data_p1[13]_i_1__1_n_2 ));
  LUT4 #(
    .INIT(16'hBA8A)) 
    \data_p1[14]_i_1__1 
       (.I0(\data_p2_reg[31]_0 [14]),
        .I1(state__0[1]),
        .I2(state__0[0]),
        .I3(\data_p2_reg_n_2_[14] ),
        .O(\data_p1[14]_i_1__1_n_2 ));
  LUT4 #(
    .INIT(16'hBA8A)) 
    \data_p1[15]_i_1__1 
       (.I0(\data_p2_reg[31]_0 [15]),
        .I1(state__0[1]),
        .I2(state__0[0]),
        .I3(\data_p2_reg_n_2_[15] ),
        .O(\data_p1[15]_i_1__1_n_2 ));
  LUT4 #(
    .INIT(16'hBA8A)) 
    \data_p1[16]_i_1__1 
       (.I0(\data_p2_reg[31]_0 [16]),
        .I1(state__0[1]),
        .I2(state__0[0]),
        .I3(\data_p2_reg_n_2_[16] ),
        .O(\data_p1[16]_i_1__1_n_2 ));
  LUT4 #(
    .INIT(16'hBA8A)) 
    \data_p1[17]_i_1__1 
       (.I0(\data_p2_reg[31]_0 [17]),
        .I1(state__0[1]),
        .I2(state__0[0]),
        .I3(\data_p2_reg_n_2_[17] ),
        .O(\data_p1[17]_i_1__1_n_2 ));
  LUT4 #(
    .INIT(16'hBA8A)) 
    \data_p1[18]_i_1__1 
       (.I0(\data_p2_reg[31]_0 [18]),
        .I1(state__0[1]),
        .I2(state__0[0]),
        .I3(\data_p2_reg_n_2_[18] ),
        .O(\data_p1[18]_i_1__1_n_2 ));
  LUT4 #(
    .INIT(16'hBA8A)) 
    \data_p1[19]_i_1__1 
       (.I0(\data_p2_reg[31]_0 [19]),
        .I1(state__0[1]),
        .I2(state__0[0]),
        .I3(\data_p2_reg_n_2_[19] ),
        .O(\data_p1[19]_i_1__1_n_2 ));
  LUT4 #(
    .INIT(16'hBA8A)) 
    \data_p1[1]_i_1__1 
       (.I0(\data_p2_reg[31]_0 [1]),
        .I1(state__0[1]),
        .I2(state__0[0]),
        .I3(\data_p2_reg_n_2_[1] ),
        .O(\data_p1[1]_i_1__1_n_2 ));
  LUT4 #(
    .INIT(16'hBA8A)) 
    \data_p1[20]_i_1__1 
       (.I0(\data_p2_reg[31]_0 [20]),
        .I1(state__0[1]),
        .I2(state__0[0]),
        .I3(\data_p2_reg_n_2_[20] ),
        .O(\data_p1[20]_i_1__1_n_2 ));
  LUT4 #(
    .INIT(16'hBA8A)) 
    \data_p1[21]_i_1__1 
       (.I0(\data_p2_reg[31]_0 [21]),
        .I1(state__0[1]),
        .I2(state__0[0]),
        .I3(\data_p2_reg_n_2_[21] ),
        .O(\data_p1[21]_i_1__1_n_2 ));
  LUT4 #(
    .INIT(16'hBA8A)) 
    \data_p1[22]_i_1__1 
       (.I0(\data_p2_reg[31]_0 [22]),
        .I1(state__0[1]),
        .I2(state__0[0]),
        .I3(\data_p2_reg_n_2_[22] ),
        .O(\data_p1[22]_i_1__1_n_2 ));
  LUT4 #(
    .INIT(16'hBA8A)) 
    \data_p1[23]_i_1__1 
       (.I0(\data_p2_reg[31]_0 [23]),
        .I1(state__0[1]),
        .I2(state__0[0]),
        .I3(\data_p2_reg_n_2_[23] ),
        .O(\data_p1[23]_i_1__1_n_2 ));
  LUT4 #(
    .INIT(16'hBA8A)) 
    \data_p1[24]_i_1__1 
       (.I0(\data_p2_reg[31]_0 [24]),
        .I1(state__0[1]),
        .I2(state__0[0]),
        .I3(\data_p2_reg_n_2_[24] ),
        .O(\data_p1[24]_i_1__1_n_2 ));
  LUT4 #(
    .INIT(16'hBA8A)) 
    \data_p1[25]_i_1__1 
       (.I0(\data_p2_reg[31]_0 [25]),
        .I1(state__0[1]),
        .I2(state__0[0]),
        .I3(\data_p2_reg_n_2_[25] ),
        .O(\data_p1[25]_i_1__1_n_2 ));
  LUT4 #(
    .INIT(16'hBA8A)) 
    \data_p1[26]_i_1__1 
       (.I0(\data_p2_reg[31]_0 [26]),
        .I1(state__0[1]),
        .I2(state__0[0]),
        .I3(\data_p2_reg_n_2_[26] ),
        .O(\data_p1[26]_i_1__1_n_2 ));
  LUT4 #(
    .INIT(16'hBA8A)) 
    \data_p1[27]_i_1__1 
       (.I0(\data_p2_reg[31]_0 [27]),
        .I1(state__0[1]),
        .I2(state__0[0]),
        .I3(\data_p2_reg_n_2_[27] ),
        .O(\data_p1[27]_i_1__1_n_2 ));
  LUT4 #(
    .INIT(16'hBA8A)) 
    \data_p1[28]_i_1__1 
       (.I0(\data_p2_reg[31]_0 [28]),
        .I1(state__0[1]),
        .I2(state__0[0]),
        .I3(\data_p2_reg_n_2_[28] ),
        .O(\data_p1[28]_i_1__1_n_2 ));
  LUT4 #(
    .INIT(16'hBA8A)) 
    \data_p1[29]_i_1__1 
       (.I0(\data_p2_reg[31]_0 [29]),
        .I1(state__0[1]),
        .I2(state__0[0]),
        .I3(\data_p2_reg_n_2_[29] ),
        .O(\data_p1[29]_i_1__1_n_2 ));
  LUT4 #(
    .INIT(16'hBA8A)) 
    \data_p1[2]_i_1__1 
       (.I0(\data_p2_reg[31]_0 [2]),
        .I1(state__0[1]),
        .I2(state__0[0]),
        .I3(\data_p2_reg_n_2_[2] ),
        .O(\data_p1[2]_i_1__1_n_2 ));
  LUT4 #(
    .INIT(16'hBA8A)) 
    \data_p1[30]_i_1 
       (.I0(\data_p2_reg[31]_0 [30]),
        .I1(state__0[1]),
        .I2(state__0[0]),
        .I3(\data_p2_reg_n_2_[30] ),
        .O(\data_p1[30]_i_1_n_2 ));
  LUT4 #(
    .INIT(16'h08AC)) 
    \data_p1[31]_i_1 
       (.I0(\FSM_sequential_state[1]_i_2_n_2 ),
        .I1(s_ready_t_reg_0),
        .I2(state__0[0]),
        .I3(state__0[1]),
        .O(load_p1));
  LUT4 #(
    .INIT(16'hBA8A)) 
    \data_p1[31]_i_2 
       (.I0(\data_p2_reg[31]_0 [31]),
        .I1(state__0[1]),
        .I2(state__0[0]),
        .I3(\data_p2_reg_n_2_[31] ),
        .O(\data_p1[31]_i_2_n_2 ));
  LUT4 #(
    .INIT(16'hBA8A)) 
    \data_p1[3]_i_1__1 
       (.I0(\data_p2_reg[31]_0 [3]),
        .I1(state__0[1]),
        .I2(state__0[0]),
        .I3(\data_p2_reg_n_2_[3] ),
        .O(\data_p1[3]_i_1__1_n_2 ));
  LUT4 #(
    .INIT(16'hBA8A)) 
    \data_p1[4]_i_1__1 
       (.I0(\data_p2_reg[31]_0 [4]),
        .I1(state__0[1]),
        .I2(state__0[0]),
        .I3(\data_p2_reg_n_2_[4] ),
        .O(\data_p1[4]_i_1__1_n_2 ));
  LUT4 #(
    .INIT(16'hBA8A)) 
    \data_p1[5]_i_1__1 
       (.I0(\data_p2_reg[31]_0 [5]),
        .I1(state__0[1]),
        .I2(state__0[0]),
        .I3(\data_p2_reg_n_2_[5] ),
        .O(\data_p1[5]_i_1__1_n_2 ));
  LUT4 #(
    .INIT(16'hBA8A)) 
    \data_p1[6]_i_1__1 
       (.I0(\data_p2_reg[31]_0 [6]),
        .I1(state__0[1]),
        .I2(state__0[0]),
        .I3(\data_p2_reg_n_2_[6] ),
        .O(\data_p1[6]_i_1__1_n_2 ));
  LUT4 #(
    .INIT(16'hBA8A)) 
    \data_p1[7]_i_1__1 
       (.I0(\data_p2_reg[31]_0 [7]),
        .I1(state__0[1]),
        .I2(state__0[0]),
        .I3(\data_p2_reg_n_2_[7] ),
        .O(\data_p1[7]_i_1__1_n_2 ));
  LUT4 #(
    .INIT(16'hBA8A)) 
    \data_p1[8]_i_1__1 
       (.I0(\data_p2_reg[31]_0 [8]),
        .I1(state__0[1]),
        .I2(state__0[0]),
        .I3(\data_p2_reg_n_2_[8] ),
        .O(\data_p1[8]_i_1__1_n_2 ));
  LUT4 #(
    .INIT(16'hBA8A)) 
    \data_p1[9]_i_1__1 
       (.I0(\data_p2_reg[31]_0 [9]),
        .I1(state__0[1]),
        .I2(state__0[0]),
        .I3(\data_p2_reg_n_2_[9] ),
        .O(\data_p1[9]_i_1__1_n_2 ));
  FDRE \data_p1_reg[0] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[0]_i_1__1_n_2 ),
        .Q(\data_p1_reg[31]_0 [0]),
        .R(1'b0));
  FDRE \data_p1_reg[10] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[10]_i_1__1_n_2 ),
        .Q(\data_p1_reg[31]_0 [10]),
        .R(1'b0));
  FDRE \data_p1_reg[11] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[11]_i_1__1_n_2 ),
        .Q(\data_p1_reg[31]_0 [11]),
        .R(1'b0));
  FDRE \data_p1_reg[12] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[12]_i_1__1_n_2 ),
        .Q(\data_p1_reg[31]_0 [12]),
        .R(1'b0));
  FDRE \data_p1_reg[13] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[13]_i_1__1_n_2 ),
        .Q(\data_p1_reg[31]_0 [13]),
        .R(1'b0));
  FDRE \data_p1_reg[14] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[14]_i_1__1_n_2 ),
        .Q(\data_p1_reg[31]_0 [14]),
        .R(1'b0));
  FDRE \data_p1_reg[15] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[15]_i_1__1_n_2 ),
        .Q(\data_p1_reg[31]_0 [15]),
        .R(1'b0));
  FDRE \data_p1_reg[16] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[16]_i_1__1_n_2 ),
        .Q(\data_p1_reg[31]_0 [16]),
        .R(1'b0));
  FDRE \data_p1_reg[17] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[17]_i_1__1_n_2 ),
        .Q(\data_p1_reg[31]_0 [17]),
        .R(1'b0));
  FDRE \data_p1_reg[18] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[18]_i_1__1_n_2 ),
        .Q(\data_p1_reg[31]_0 [18]),
        .R(1'b0));
  FDRE \data_p1_reg[19] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[19]_i_1__1_n_2 ),
        .Q(\data_p1_reg[31]_0 [19]),
        .R(1'b0));
  FDRE \data_p1_reg[1] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[1]_i_1__1_n_2 ),
        .Q(\data_p1_reg[31]_0 [1]),
        .R(1'b0));
  FDRE \data_p1_reg[20] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[20]_i_1__1_n_2 ),
        .Q(\data_p1_reg[31]_0 [20]),
        .R(1'b0));
  FDRE \data_p1_reg[21] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[21]_i_1__1_n_2 ),
        .Q(\data_p1_reg[31]_0 [21]),
        .R(1'b0));
  FDRE \data_p1_reg[22] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[22]_i_1__1_n_2 ),
        .Q(\data_p1_reg[31]_0 [22]),
        .R(1'b0));
  FDRE \data_p1_reg[23] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[23]_i_1__1_n_2 ),
        .Q(\data_p1_reg[31]_0 [23]),
        .R(1'b0));
  FDRE \data_p1_reg[24] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[24]_i_1__1_n_2 ),
        .Q(\data_p1_reg[31]_0 [24]),
        .R(1'b0));
  FDRE \data_p1_reg[25] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[25]_i_1__1_n_2 ),
        .Q(\data_p1_reg[31]_0 [25]),
        .R(1'b0));
  FDRE \data_p1_reg[26] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[26]_i_1__1_n_2 ),
        .Q(\data_p1_reg[31]_0 [26]),
        .R(1'b0));
  FDRE \data_p1_reg[27] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[27]_i_1__1_n_2 ),
        .Q(\data_p1_reg[31]_0 [27]),
        .R(1'b0));
  FDRE \data_p1_reg[28] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[28]_i_1__1_n_2 ),
        .Q(\data_p1_reg[31]_0 [28]),
        .R(1'b0));
  FDRE \data_p1_reg[29] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[29]_i_1__1_n_2 ),
        .Q(\data_p1_reg[31]_0 [29]),
        .R(1'b0));
  FDRE \data_p1_reg[2] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[2]_i_1__1_n_2 ),
        .Q(\data_p1_reg[31]_0 [2]),
        .R(1'b0));
  FDRE \data_p1_reg[30] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[30]_i_1_n_2 ),
        .Q(\data_p1_reg[31]_0 [30]),
        .R(1'b0));
  FDRE \data_p1_reg[31] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[31]_i_2_n_2 ),
        .Q(\data_p1_reg[31]_0 [31]),
        .R(1'b0));
  FDRE \data_p1_reg[3] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[3]_i_1__1_n_2 ),
        .Q(\data_p1_reg[31]_0 [3]),
        .R(1'b0));
  FDRE \data_p1_reg[4] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[4]_i_1__1_n_2 ),
        .Q(\data_p1_reg[31]_0 [4]),
        .R(1'b0));
  FDRE \data_p1_reg[5] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[5]_i_1__1_n_2 ),
        .Q(\data_p1_reg[31]_0 [5]),
        .R(1'b0));
  FDRE \data_p1_reg[6] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[6]_i_1__1_n_2 ),
        .Q(\data_p1_reg[31]_0 [6]),
        .R(1'b0));
  FDRE \data_p1_reg[7] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[7]_i_1__1_n_2 ),
        .Q(\data_p1_reg[31]_0 [7]),
        .R(1'b0));
  FDRE \data_p1_reg[8] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[8]_i_1__1_n_2 ),
        .Q(\data_p1_reg[31]_0 [8]),
        .R(1'b0));
  FDRE \data_p1_reg[9] 
       (.C(ap_clk),
        .CE(load_p1),
        .D(\data_p1[9]_i_1__1_n_2 ),
        .Q(\data_p1_reg[31]_0 [9]),
        .R(1'b0));
  LUT2 #(
    .INIT(4'h8)) 
    \data_p2[31]_i_1 
       (.I0(s_ready_t_reg_0),
        .I1(rdata_ack_t),
        .O(load_p2));
  FDRE \data_p2_reg[0] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[31]_0 [0]),
        .Q(\data_p2_reg_n_2_[0] ),
        .R(1'b0));
  FDRE \data_p2_reg[10] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[31]_0 [10]),
        .Q(\data_p2_reg_n_2_[10] ),
        .R(1'b0));
  FDRE \data_p2_reg[11] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[31]_0 [11]),
        .Q(\data_p2_reg_n_2_[11] ),
        .R(1'b0));
  FDRE \data_p2_reg[12] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[31]_0 [12]),
        .Q(\data_p2_reg_n_2_[12] ),
        .R(1'b0));
  FDRE \data_p2_reg[13] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[31]_0 [13]),
        .Q(\data_p2_reg_n_2_[13] ),
        .R(1'b0));
  FDRE \data_p2_reg[14] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[31]_0 [14]),
        .Q(\data_p2_reg_n_2_[14] ),
        .R(1'b0));
  FDRE \data_p2_reg[15] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[31]_0 [15]),
        .Q(\data_p2_reg_n_2_[15] ),
        .R(1'b0));
  FDRE \data_p2_reg[16] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[31]_0 [16]),
        .Q(\data_p2_reg_n_2_[16] ),
        .R(1'b0));
  FDRE \data_p2_reg[17] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[31]_0 [17]),
        .Q(\data_p2_reg_n_2_[17] ),
        .R(1'b0));
  FDRE \data_p2_reg[18] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[31]_0 [18]),
        .Q(\data_p2_reg_n_2_[18] ),
        .R(1'b0));
  FDRE \data_p2_reg[19] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[31]_0 [19]),
        .Q(\data_p2_reg_n_2_[19] ),
        .R(1'b0));
  FDRE \data_p2_reg[1] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[31]_0 [1]),
        .Q(\data_p2_reg_n_2_[1] ),
        .R(1'b0));
  FDRE \data_p2_reg[20] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[31]_0 [20]),
        .Q(\data_p2_reg_n_2_[20] ),
        .R(1'b0));
  FDRE \data_p2_reg[21] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[31]_0 [21]),
        .Q(\data_p2_reg_n_2_[21] ),
        .R(1'b0));
  FDRE \data_p2_reg[22] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[31]_0 [22]),
        .Q(\data_p2_reg_n_2_[22] ),
        .R(1'b0));
  FDRE \data_p2_reg[23] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[31]_0 [23]),
        .Q(\data_p2_reg_n_2_[23] ),
        .R(1'b0));
  FDRE \data_p2_reg[24] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[31]_0 [24]),
        .Q(\data_p2_reg_n_2_[24] ),
        .R(1'b0));
  FDRE \data_p2_reg[25] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[31]_0 [25]),
        .Q(\data_p2_reg_n_2_[25] ),
        .R(1'b0));
  FDRE \data_p2_reg[26] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[31]_0 [26]),
        .Q(\data_p2_reg_n_2_[26] ),
        .R(1'b0));
  FDRE \data_p2_reg[27] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[31]_0 [27]),
        .Q(\data_p2_reg_n_2_[27] ),
        .R(1'b0));
  FDRE \data_p2_reg[28] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[31]_0 [28]),
        .Q(\data_p2_reg_n_2_[28] ),
        .R(1'b0));
  FDRE \data_p2_reg[29] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[31]_0 [29]),
        .Q(\data_p2_reg_n_2_[29] ),
        .R(1'b0));
  FDRE \data_p2_reg[2] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[31]_0 [2]),
        .Q(\data_p2_reg_n_2_[2] ),
        .R(1'b0));
  FDRE \data_p2_reg[30] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[31]_0 [30]),
        .Q(\data_p2_reg_n_2_[30] ),
        .R(1'b0));
  FDRE \data_p2_reg[31] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[31]_0 [31]),
        .Q(\data_p2_reg_n_2_[31] ),
        .R(1'b0));
  FDRE \data_p2_reg[3] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[31]_0 [3]),
        .Q(\data_p2_reg_n_2_[3] ),
        .R(1'b0));
  FDRE \data_p2_reg[4] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[31]_0 [4]),
        .Q(\data_p2_reg_n_2_[4] ),
        .R(1'b0));
  FDRE \data_p2_reg[5] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[31]_0 [5]),
        .Q(\data_p2_reg_n_2_[5] ),
        .R(1'b0));
  FDRE \data_p2_reg[6] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[31]_0 [6]),
        .Q(\data_p2_reg_n_2_[6] ),
        .R(1'b0));
  FDRE \data_p2_reg[7] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[31]_0 [7]),
        .Q(\data_p2_reg_n_2_[7] ),
        .R(1'b0));
  FDRE \data_p2_reg[8] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[31]_0 [8]),
        .Q(\data_p2_reg_n_2_[8] ),
        .R(1'b0));
  FDRE \data_p2_reg[9] 
       (.C(ap_clk),
        .CE(load_p2),
        .D(\data_p2_reg[31]_0 [9]),
        .Q(\data_p2_reg_n_2_[9] ),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair82" *) 
  LUT5 #(
    .INIT(32'hB8B8B0B8)) 
    \exitcond_reg_251[0]_i_1 
       (.I0(CO),
        .I1(Q[1]),
        .I2(ap_enable_reg_pp0_iter1_reg_0),
        .I3(ap_enable_reg_pp0_iter1_reg),
        .I4(gmem_RVALID),
        .O(\ap_CS_fsm_reg[8]_1 ));
  (* SOFT_HLUTNM = "soft_lutpair84" *) 
  LUT5 #(
    .INIT(32'hDDFD8888)) 
    \exitcond_reg_251_pp0_iter1_reg[0]_i_1 
       (.I0(Q[1]),
        .I1(ap_enable_reg_pp0_iter1_reg_0),
        .I2(ap_enable_reg_pp0_iter1_reg),
        .I3(gmem_RVALID),
        .I4(exitcond_reg_251_pp0_iter1_reg),
        .O(\ap_CS_fsm_reg[8]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair84" *) 
  LUT4 #(
    .INIT(16'h00B0)) 
    \gmem_addr_1_read_reg_260[31]_i_1 
       (.I0(gmem_RVALID),
        .I1(ap_enable_reg_pp0_iter1_reg),
        .I2(Q[1]),
        .I3(ap_enable_reg_pp0_iter1_reg_0),
        .O(\state_reg[0]_1 ));
  LUT2 #(
    .INIT(4'h2)) 
    \i_reg_137[0]_i_1 
       (.I0(Q[0]),
        .I1(i_reg_1370),
        .O(i_reg_137));
  LUT6 #(
    .INIT(64'h00000000FB000000)) 
    \i_reg_137[0]_i_2 
       (.I0(gmem_RVALID),
        .I1(ap_enable_reg_pp0_iter1_reg),
        .I2(ap_enable_reg_pp0_iter1_reg_0),
        .I3(Q[1]),
        .I4(ap_enable_reg_pp0_iter0),
        .I5(CO),
        .O(i_reg_1370));
  (* SOFT_HLUTNM = "soft_lutpair85" *) 
  LUT5 #(
    .INIT(32'hFFDF4455)) 
    s_ready_t_i_1__1
       (.I0(state__0[1]),
        .I1(\FSM_sequential_state[1]_i_2_n_2 ),
        .I2(s_ready_t_reg_0),
        .I3(state__0[0]),
        .I4(rdata_ack_t),
        .O(s_ready_t_i_1__1_n_2));
  FDRE s_ready_t_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(s_ready_t_i_1__1_n_2),
        .Q(rdata_ack_t),
        .R(SR));
  LUT5 #(
    .INIT(32'hF5FFC000)) 
    \state[0]_i_1__1 
       (.I0(\FSM_sequential_state[1]_i_2_n_2 ),
        .I1(rdata_ack_t),
        .I2(s_ready_t_reg_0),
        .I3(state),
        .I4(gmem_RVALID),
        .O(\state[0]_i_1__1_n_2 ));
  LUT6 #(
    .INIT(64'h4040FF40FFFFFFFF)) 
    \state[1]_i_1 
       (.I0(ap_enable_reg_pp0_iter1_reg_0),
        .I1(ap_enable_reg_pp0_iter1_reg),
        .I2(Q[1]),
        .I3(state),
        .I4(s_ready_t_reg_0),
        .I5(gmem_RVALID),
        .O(\state[1]_i_1_n_2 ));
  FDRE \state_reg[0] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\state[0]_i_1__1_n_2 ),
        .Q(gmem_RVALID),
        .R(SR));
  FDSE \state_reg[1] 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\state[1]_i_1_n_2 ),
        .Q(state),
        .S(SR));
  LUT6 #(
    .INIT(64'hAAAAAAAA0020AAAA)) 
    \sum_reg_125[0]_i_1 
       (.I0(Q[0]),
        .I1(ap_enable_reg_pp0_iter1_reg_0),
        .I2(ap_enable_reg_pp0_iter1_reg),
        .I3(gmem_RVALID),
        .I4(ap_enable_reg_pp0_iter2_reg),
        .I5(exitcond_reg_251_pp0_iter1_reg),
        .O(sum_reg_125));
  (* SOFT_HLUTNM = "soft_lutpair83" *) 
  LUT5 #(
    .INIT(32'h44444044)) 
    \sum_reg_125[0]_i_2 
       (.I0(exitcond_reg_251_pp0_iter1_reg),
        .I1(ap_enable_reg_pp0_iter2_reg),
        .I2(gmem_RVALID),
        .I3(ap_enable_reg_pp0_iter1_reg),
        .I4(ap_enable_reg_pp0_iter1_reg_0),
        .O(sum_reg_1250));
endmodule

module design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_throttl
   (m_axi_gmem_AWVALID,
    Q,
    \throttl_cnt_reg[0]_0 ,
    m_axi_gmem_AWREADY_0,
    \throttl_cnt_reg[5]_0 ,
    \throttl_cnt_reg[7]_0 ,
    AWVALID_Dummy,
    D,
    \throttl_cnt_reg[2]_0 ,
    \throttl_cnt_reg[3]_0 ,
    m_axi_gmem_AWREADY,
    SR,
    E,
    ap_clk);
  output m_axi_gmem_AWVALID;
  output [0:0]Q;
  output \throttl_cnt_reg[0]_0 ;
  output m_axi_gmem_AWREADY_0;
  output \throttl_cnt_reg[5]_0 ;
  output \throttl_cnt_reg[7]_0 ;
  input AWVALID_Dummy;
  input [0:0]D;
  input \throttl_cnt_reg[2]_0 ;
  input [2:0]\throttl_cnt_reg[3]_0 ;
  input m_axi_gmem_AWREADY;
  input [0:0]SR;
  input [0:0]E;
  input ap_clk;

  wire AWVALID_Dummy;
  wire [0:0]D;
  wire [0:0]E;
  wire [0:0]Q;
  wire [0:0]SR;
  wire ap_clk;
  wire m_axi_gmem_AWREADY;
  wire m_axi_gmem_AWREADY_0;
  wire m_axi_gmem_AWVALID;
  wire [7:1]p_0_in;
  wire \throttl_cnt_reg[0]_0 ;
  wire \throttl_cnt_reg[2]_0 ;
  wire [2:0]\throttl_cnt_reg[3]_0 ;
  wire \throttl_cnt_reg[5]_0 ;
  wire \throttl_cnt_reg[7]_0 ;
  wire [7:1]throttl_cnt_reg__0;

  LUT6 #(
    .INIT(64'h0000000000000002)) 
    \could_multi_bursts.AWVALID_Dummy_i_2 
       (.I0(m_axi_gmem_AWREADY),
        .I1(throttl_cnt_reg__0[7]),
        .I2(throttl_cnt_reg__0[4]),
        .I3(throttl_cnt_reg__0[6]),
        .I4(throttl_cnt_reg__0[5]),
        .I5(\throttl_cnt_reg[0]_0 ),
        .O(m_axi_gmem_AWREADY_0));
  (* SOFT_HLUTNM = "soft_lutpair208" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    \could_multi_bursts.awaddr_buf[31]_i_4 
       (.I0(throttl_cnt_reg__0[7]),
        .I1(throttl_cnt_reg__0[4]),
        .I2(throttl_cnt_reg__0[6]),
        .I3(throttl_cnt_reg__0[5]),
        .O(\throttl_cnt_reg[7]_0 ));
  LUT6 #(
    .INIT(64'h0000000000000002)) 
    m_axi_gmem_AWVALID_INST_0
       (.I0(AWVALID_Dummy),
        .I1(throttl_cnt_reg__0[7]),
        .I2(throttl_cnt_reg__0[4]),
        .I3(throttl_cnt_reg__0[6]),
        .I4(throttl_cnt_reg__0[5]),
        .I5(\throttl_cnt_reg[0]_0 ),
        .O(m_axi_gmem_AWVALID));
  LUT4 #(
    .INIT(16'hFFFE)) 
    m_axi_gmem_AWVALID_INST_0_i_1
       (.I0(Q),
        .I1(throttl_cnt_reg__0[1]),
        .I2(throttl_cnt_reg__0[2]),
        .I3(throttl_cnt_reg__0[3]),
        .O(\throttl_cnt_reg[0]_0 ));
  LUT4 #(
    .INIT(16'h9099)) 
    \throttl_cnt[1]_i_1 
       (.I0(Q),
        .I1(throttl_cnt_reg__0[1]),
        .I2(\throttl_cnt_reg[3]_0 [0]),
        .I3(\throttl_cnt_reg[2]_0 ),
        .O(p_0_in[1]));
  LUT5 #(
    .INIT(32'hDDD0000D)) 
    \throttl_cnt[2]_i_1 
       (.I0(\throttl_cnt_reg[2]_0 ),
        .I1(\throttl_cnt_reg[3]_0 [1]),
        .I2(throttl_cnt_reg__0[1]),
        .I3(Q),
        .I4(throttl_cnt_reg__0[2]),
        .O(p_0_in[2]));
  LUT6 #(
    .INIT(64'hFE010000FE01FE01)) 
    \throttl_cnt[3]_i_1 
       (.I0(throttl_cnt_reg__0[2]),
        .I1(Q),
        .I2(throttl_cnt_reg__0[1]),
        .I3(throttl_cnt_reg__0[3]),
        .I4(\throttl_cnt_reg[3]_0 [2]),
        .I5(\throttl_cnt_reg[2]_0 ),
        .O(p_0_in[3]));
  LUT6 #(
    .INIT(64'h00000000FFFE0001)) 
    \throttl_cnt[4]_i_1 
       (.I0(Q),
        .I1(throttl_cnt_reg__0[1]),
        .I2(throttl_cnt_reg__0[2]),
        .I3(throttl_cnt_reg__0[3]),
        .I4(throttl_cnt_reg__0[4]),
        .I5(\throttl_cnt_reg[2]_0 ),
        .O(p_0_in[4]));
  (* SOFT_HLUTNM = "soft_lutpair209" *) 
  LUT4 #(
    .INIT(16'h00E1)) 
    \throttl_cnt[5]_i_1 
       (.I0(throttl_cnt_reg__0[4]),
        .I1(\throttl_cnt_reg[0]_0 ),
        .I2(throttl_cnt_reg__0[5]),
        .I3(\throttl_cnt_reg[2]_0 ),
        .O(p_0_in[5]));
  (* SOFT_HLUTNM = "soft_lutpair209" *) 
  LUT5 #(
    .INIT(32'h0000FE01)) 
    \throttl_cnt[6]_i_1 
       (.I0(\throttl_cnt_reg[0]_0 ),
        .I1(throttl_cnt_reg__0[4]),
        .I2(throttl_cnt_reg__0[5]),
        .I3(throttl_cnt_reg__0[6]),
        .I4(\throttl_cnt_reg[2]_0 ),
        .O(p_0_in[6]));
  LUT6 #(
    .INIT(64'h00000000FFFE0001)) 
    \throttl_cnt[7]_i_2 
       (.I0(throttl_cnt_reg__0[5]),
        .I1(throttl_cnt_reg__0[4]),
        .I2(\throttl_cnt_reg[0]_0 ),
        .I3(throttl_cnt_reg__0[6]),
        .I4(throttl_cnt_reg__0[7]),
        .I5(\throttl_cnt_reg[2]_0 ),
        .O(p_0_in[7]));
  (* SOFT_HLUTNM = "soft_lutpair208" *) 
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \throttl_cnt[7]_i_4 
       (.I0(\throttl_cnt_reg[0]_0 ),
        .I1(throttl_cnt_reg__0[5]),
        .I2(throttl_cnt_reg__0[6]),
        .I3(throttl_cnt_reg__0[4]),
        .I4(throttl_cnt_reg__0[7]),
        .O(\throttl_cnt_reg[5]_0 ));
  FDRE \throttl_cnt_reg[0] 
       (.C(ap_clk),
        .CE(E),
        .D(D),
        .Q(Q),
        .R(SR));
  FDRE \throttl_cnt_reg[1] 
       (.C(ap_clk),
        .CE(E),
        .D(p_0_in[1]),
        .Q(throttl_cnt_reg__0[1]),
        .R(SR));
  FDRE \throttl_cnt_reg[2] 
       (.C(ap_clk),
        .CE(E),
        .D(p_0_in[2]),
        .Q(throttl_cnt_reg__0[2]),
        .R(SR));
  FDRE \throttl_cnt_reg[3] 
       (.C(ap_clk),
        .CE(E),
        .D(p_0_in[3]),
        .Q(throttl_cnt_reg__0[3]),
        .R(SR));
  FDRE \throttl_cnt_reg[4] 
       (.C(ap_clk),
        .CE(E),
        .D(p_0_in[4]),
        .Q(throttl_cnt_reg__0[4]),
        .R(SR));
  FDRE \throttl_cnt_reg[5] 
       (.C(ap_clk),
        .CE(E),
        .D(p_0_in[5]),
        .Q(throttl_cnt_reg__0[5]),
        .R(SR));
  FDRE \throttl_cnt_reg[6] 
       (.C(ap_clk),
        .CE(E),
        .D(p_0_in[6]),
        .Q(throttl_cnt_reg__0[6]),
        .R(SR));
  FDRE \throttl_cnt_reg[7] 
       (.C(ap_clk),
        .CE(E),
        .D(p_0_in[7]),
        .Q(throttl_cnt_reg__0[7]),
        .R(SR));
endmodule

module design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_write
   (full_n_reg,
    empty_n_reg,
    AWVALID_Dummy,
    \bus_equal_gen.WVALID_Dummy_reg_0 ,
    m_axi_gmem_WLAST,
    \ap_CS_fsm_reg[15] ,
    ap_done,
    E,
    \could_multi_bursts.AWVALID_Dummy_reg_0 ,
    D,
    \could_multi_bursts.awlen_buf_reg[3]_0 ,
    \usedw_reg[5] ,
    \ap_CS_fsm_reg[10] ,
    DI,
    m_axi_gmem_AWADDR,
    S,
    \usedw_reg[6] ,
    m_axi_gmem_WDATA,
    m_axi_gmem_WSTRB,
    ap_clk,
    SR,
    ap_rst_n,
    \could_multi_bursts.AWVALID_Dummy_reg_1 ,
    Q,
    ap_start,
    m_axi_gmem_WREADY,
    \throttl_cnt_reg[0] ,
    m_axi_gmem_AWREADY,
    \could_multi_bursts.awaddr_buf_reg[2]_0 ,
    \could_multi_bursts.awaddr_buf_reg[2]_1 ,
    \throttl_cnt_reg[0]_0 ,
    ap_reg_ioackin_gmem_WREADY,
    m_axi_gmem_BVALID,
    \ap_CS_fsm_reg[9] ,
    \data_p2_reg[29] ,
    mem_reg,
    out,
    \usedw_reg[7] );
  output full_n_reg;
  output empty_n_reg;
  output AWVALID_Dummy;
  output \bus_equal_gen.WVALID_Dummy_reg_0 ;
  output m_axi_gmem_WLAST;
  output [5:0]\ap_CS_fsm_reg[15] ;
  output ap_done;
  output [0:0]E;
  output \could_multi_bursts.AWVALID_Dummy_reg_0 ;
  output [0:0]D;
  output [3:0]\could_multi_bursts.awlen_buf_reg[3]_0 ;
  output [5:0]\usedw_reg[5] ;
  output [0:0]\ap_CS_fsm_reg[10] ;
  output [0:0]DI;
  output [29:0]m_axi_gmem_AWADDR;
  output [3:0]S;
  output [2:0]\usedw_reg[6] ;
  output [31:0]m_axi_gmem_WDATA;
  output [3:0]m_axi_gmem_WSTRB;
  input ap_clk;
  input [0:0]SR;
  input ap_rst_n;
  input \could_multi_bursts.AWVALID_Dummy_reg_1 ;
  input [6:0]Q;
  input ap_start;
  input m_axi_gmem_WREADY;
  input \throttl_cnt_reg[0] ;
  input m_axi_gmem_AWREADY;
  input \could_multi_bursts.awaddr_buf_reg[2]_0 ;
  input \could_multi_bursts.awaddr_buf_reg[2]_1 ;
  input [0:0]\throttl_cnt_reg[0]_0 ;
  input ap_reg_ioackin_gmem_WREADY;
  input m_axi_gmem_BVALID;
  input \ap_CS_fsm_reg[9] ;
  input [29:0]\data_p2_reg[29] ;
  input [31:0]mem_reg;
  input [31:0]out;
  input [6:0]\usedw_reg[7] ;

  wire AWVALID_Dummy;
  wire [0:0]D;
  wire [0:0]DI;
  wire [0:0]E;
  wire [6:0]Q;
  wire [3:0]S;
  wire [0:0]SR;
  wire [31:2]align_len0;
  wire align_len0_0;
  wire \align_len0_inferred__1/i__carry_n_3 ;
  wire \align_len0_inferred__1/i__carry_n_4 ;
  wire \align_len0_inferred__1/i__carry_n_5 ;
  wire \align_len_reg_n_2_[2] ;
  wire \align_len_reg_n_2_[31] ;
  wire \align_len_reg_n_2_[3] ;
  wire [0:0]\ap_CS_fsm_reg[10] ;
  wire [5:0]\ap_CS_fsm_reg[15] ;
  wire \ap_CS_fsm_reg[9] ;
  wire ap_clk;
  wire ap_done;
  wire ap_reg_ioackin_gmem_WREADY;
  wire ap_rst_n;
  wire ap_start;
  wire [31:2]awaddr_tmp;
  wire [3:0]awlen_tmp;
  wire [3:0]beat_len_buf;
  wire buff_wdata_n_14;
  wire buff_wdata_n_26;
  wire buff_wdata_n_27;
  wire buff_wdata_n_28;
  wire buff_wdata_n_29;
  wire buff_wdata_n_30;
  wire buff_wdata_n_31;
  wire buff_wdata_n_32;
  wire buff_wdata_n_33;
  wire buff_wdata_n_34;
  wire buff_wdata_n_35;
  wire buff_wdata_n_36;
  wire buff_wdata_n_37;
  wire buff_wdata_n_38;
  wire buff_wdata_n_39;
  wire buff_wdata_n_40;
  wire buff_wdata_n_41;
  wire buff_wdata_n_42;
  wire buff_wdata_n_43;
  wire buff_wdata_n_44;
  wire buff_wdata_n_45;
  wire buff_wdata_n_46;
  wire buff_wdata_n_47;
  wire buff_wdata_n_48;
  wire buff_wdata_n_49;
  wire buff_wdata_n_50;
  wire buff_wdata_n_51;
  wire buff_wdata_n_52;
  wire buff_wdata_n_53;
  wire buff_wdata_n_54;
  wire buff_wdata_n_55;
  wire buff_wdata_n_56;
  wire buff_wdata_n_57;
  wire burst_valid;
  wire \bus_equal_gen.WVALID_Dummy_reg_0 ;
  wire \bus_equal_gen.fifo_burst_n_10 ;
  wire \bus_equal_gen.fifo_burst_n_11 ;
  wire \bus_equal_gen.fifo_burst_n_12 ;
  wire \bus_equal_gen.fifo_burst_n_13 ;
  wire \bus_equal_gen.fifo_burst_n_14 ;
  wire \bus_equal_gen.fifo_burst_n_15 ;
  wire \bus_equal_gen.fifo_burst_n_16 ;
  wire \bus_equal_gen.fifo_burst_n_17 ;
  wire \bus_equal_gen.fifo_burst_n_18 ;
  wire \bus_equal_gen.fifo_burst_n_19 ;
  wire \bus_equal_gen.fifo_burst_n_20 ;
  wire \bus_equal_gen.fifo_burst_n_21 ;
  wire \bus_equal_gen.fifo_burst_n_22 ;
  wire \bus_equal_gen.fifo_burst_n_23 ;
  wire \bus_equal_gen.fifo_burst_n_24 ;
  wire \bus_equal_gen.fifo_burst_n_25 ;
  wire \bus_equal_gen.fifo_burst_n_26 ;
  wire \bus_equal_gen.fifo_burst_n_28 ;
  wire \bus_equal_gen.fifo_burst_n_3 ;
  wire \bus_equal_gen.fifo_burst_n_33 ;
  wire \bus_equal_gen.fifo_burst_n_34 ;
  wire \bus_equal_gen.fifo_burst_n_35 ;
  wire \bus_equal_gen.fifo_burst_n_36 ;
  wire \bus_equal_gen.fifo_burst_n_37 ;
  wire \bus_equal_gen.fifo_burst_n_38 ;
  wire \bus_equal_gen.fifo_burst_n_39 ;
  wire \bus_equal_gen.fifo_burst_n_7 ;
  wire \bus_equal_gen.fifo_burst_n_8 ;
  wire \bus_equal_gen.fifo_burst_n_9 ;
  wire \bus_equal_gen.len_cnt[7]_i_3_n_2 ;
  wire [7:0]\bus_equal_gen.len_cnt_reg__0 ;
  wire \could_multi_bursts.AWVALID_Dummy_reg_0 ;
  wire \could_multi_bursts.AWVALID_Dummy_reg_1 ;
  wire \could_multi_bursts.awaddr_buf[31]_i_7_n_2 ;
  wire \could_multi_bursts.awaddr_buf[4]_i_3_n_2 ;
  wire \could_multi_bursts.awaddr_buf[4]_i_4_n_2 ;
  wire \could_multi_bursts.awaddr_buf[4]_i_5_n_2 ;
  wire \could_multi_bursts.awaddr_buf[8]_i_3_n_2 ;
  wire \could_multi_bursts.awaddr_buf[8]_i_4_n_2 ;
  wire \could_multi_bursts.awaddr_buf_reg[12]_i_2_n_2 ;
  wire \could_multi_bursts.awaddr_buf_reg[12]_i_2_n_3 ;
  wire \could_multi_bursts.awaddr_buf_reg[12]_i_2_n_4 ;
  wire \could_multi_bursts.awaddr_buf_reg[12]_i_2_n_5 ;
  wire \could_multi_bursts.awaddr_buf_reg[16]_i_2_n_2 ;
  wire \could_multi_bursts.awaddr_buf_reg[16]_i_2_n_3 ;
  wire \could_multi_bursts.awaddr_buf_reg[16]_i_2_n_4 ;
  wire \could_multi_bursts.awaddr_buf_reg[16]_i_2_n_5 ;
  wire \could_multi_bursts.awaddr_buf_reg[20]_i_2_n_2 ;
  wire \could_multi_bursts.awaddr_buf_reg[20]_i_2_n_3 ;
  wire \could_multi_bursts.awaddr_buf_reg[20]_i_2_n_4 ;
  wire \could_multi_bursts.awaddr_buf_reg[20]_i_2_n_5 ;
  wire \could_multi_bursts.awaddr_buf_reg[24]_i_2_n_2 ;
  wire \could_multi_bursts.awaddr_buf_reg[24]_i_2_n_3 ;
  wire \could_multi_bursts.awaddr_buf_reg[24]_i_2_n_4 ;
  wire \could_multi_bursts.awaddr_buf_reg[24]_i_2_n_5 ;
  wire \could_multi_bursts.awaddr_buf_reg[28]_i_2_n_2 ;
  wire \could_multi_bursts.awaddr_buf_reg[28]_i_2_n_3 ;
  wire \could_multi_bursts.awaddr_buf_reg[28]_i_2_n_4 ;
  wire \could_multi_bursts.awaddr_buf_reg[28]_i_2_n_5 ;
  wire \could_multi_bursts.awaddr_buf_reg[2]_0 ;
  wire \could_multi_bursts.awaddr_buf_reg[2]_1 ;
  wire \could_multi_bursts.awaddr_buf_reg[31]_i_6_n_4 ;
  wire \could_multi_bursts.awaddr_buf_reg[31]_i_6_n_5 ;
  wire \could_multi_bursts.awaddr_buf_reg[4]_i_2_n_2 ;
  wire \could_multi_bursts.awaddr_buf_reg[4]_i_2_n_3 ;
  wire \could_multi_bursts.awaddr_buf_reg[4]_i_2_n_4 ;
  wire \could_multi_bursts.awaddr_buf_reg[4]_i_2_n_5 ;
  wire \could_multi_bursts.awaddr_buf_reg[8]_i_2_n_2 ;
  wire \could_multi_bursts.awaddr_buf_reg[8]_i_2_n_3 ;
  wire \could_multi_bursts.awaddr_buf_reg[8]_i_2_n_4 ;
  wire \could_multi_bursts.awaddr_buf_reg[8]_i_2_n_5 ;
  wire [3:0]\could_multi_bursts.awlen_buf_reg[3]_0 ;
  wire \could_multi_bursts.last_sect_buf_reg_n_2 ;
  wire [5:0]\could_multi_bursts.loop_cnt_reg__0 ;
  wire \could_multi_bursts.sect_handling_reg_n_2 ;
  wire [31:2]data1;
  wire [29:0]\data_p2_reg[29] ;
  wire empty_n_reg;
  wire [31:2]end_addr;
  wire \end_addr_buf_reg_n_2_[10] ;
  wire \end_addr_buf_reg_n_2_[11] ;
  wire \end_addr_buf_reg_n_2_[2] ;
  wire \end_addr_buf_reg_n_2_[3] ;
  wire \end_addr_buf_reg_n_2_[4] ;
  wire \end_addr_buf_reg_n_2_[5] ;
  wire \end_addr_buf_reg_n_2_[6] ;
  wire \end_addr_buf_reg_n_2_[7] ;
  wire \end_addr_buf_reg_n_2_[8] ;
  wire \end_addr_buf_reg_n_2_[9] ;
  wire end_addr_carry__0_i_1_n_2;
  wire end_addr_carry__0_i_2_n_2;
  wire end_addr_carry__0_i_3_n_2;
  wire end_addr_carry__0_i_4_n_2;
  wire end_addr_carry__0_n_2;
  wire end_addr_carry__0_n_3;
  wire end_addr_carry__0_n_4;
  wire end_addr_carry__0_n_5;
  wire end_addr_carry__1_i_1_n_2;
  wire end_addr_carry__1_i_2_n_2;
  wire end_addr_carry__1_i_3_n_2;
  wire end_addr_carry__1_i_4_n_2;
  wire end_addr_carry__1_n_2;
  wire end_addr_carry__1_n_3;
  wire end_addr_carry__1_n_4;
  wire end_addr_carry__1_n_5;
  wire end_addr_carry__2_i_1_n_2;
  wire end_addr_carry__2_i_2_n_2;
  wire end_addr_carry__2_i_3_n_2;
  wire end_addr_carry__2_i_4_n_2;
  wire end_addr_carry__2_n_2;
  wire end_addr_carry__2_n_3;
  wire end_addr_carry__2_n_4;
  wire end_addr_carry__2_n_5;
  wire end_addr_carry__3_i_1_n_2;
  wire end_addr_carry__3_i_2_n_2;
  wire end_addr_carry__3_i_3_n_2;
  wire end_addr_carry__3_i_4_n_2;
  wire end_addr_carry__3_n_2;
  wire end_addr_carry__3_n_3;
  wire end_addr_carry__3_n_4;
  wire end_addr_carry__3_n_5;
  wire end_addr_carry__4_i_1_n_2;
  wire end_addr_carry__4_i_2_n_2;
  wire end_addr_carry__4_i_3_n_2;
  wire end_addr_carry__4_i_4_n_2;
  wire end_addr_carry__4_n_2;
  wire end_addr_carry__4_n_3;
  wire end_addr_carry__4_n_4;
  wire end_addr_carry__4_n_5;
  wire end_addr_carry__5_i_1_n_2;
  wire end_addr_carry__5_i_2_n_2;
  wire end_addr_carry__5_i_3_n_2;
  wire end_addr_carry__5_i_4_n_2;
  wire end_addr_carry__5_n_2;
  wire end_addr_carry__5_n_3;
  wire end_addr_carry__5_n_4;
  wire end_addr_carry__5_n_5;
  wire end_addr_carry__6_i_1_n_2;
  wire end_addr_carry__6_i_2_n_2;
  wire end_addr_carry__6_n_5;
  wire end_addr_carry_i_1_n_2;
  wire end_addr_carry_i_2_n_2;
  wire end_addr_carry_i_3_n_2;
  wire end_addr_carry_i_4_n_2;
  wire end_addr_carry_n_2;
  wire end_addr_carry_n_3;
  wire end_addr_carry_n_4;
  wire end_addr_carry_n_5;
  wire fifo_resp_ready;
  wire [33:33]fifo_wreq_data;
  wire fifo_wreq_n_10;
  wire fifo_wreq_n_11;
  wire fifo_wreq_n_12;
  wire fifo_wreq_n_13;
  wire fifo_wreq_n_14;
  wire fifo_wreq_n_15;
  wire fifo_wreq_n_16;
  wire fifo_wreq_n_17;
  wire fifo_wreq_n_18;
  wire fifo_wreq_n_19;
  wire fifo_wreq_n_20;
  wire fifo_wreq_n_21;
  wire fifo_wreq_n_22;
  wire fifo_wreq_n_23;
  wire fifo_wreq_n_24;
  wire fifo_wreq_n_25;
  wire fifo_wreq_n_26;
  wire fifo_wreq_n_27;
  wire fifo_wreq_n_28;
  wire fifo_wreq_n_29;
  wire fifo_wreq_n_30;
  wire fifo_wreq_n_31;
  wire fifo_wreq_n_32;
  wire fifo_wreq_n_33;
  wire fifo_wreq_n_34;
  wire fifo_wreq_n_35;
  wire fifo_wreq_n_36;
  wire fifo_wreq_n_37;
  wire fifo_wreq_n_38;
  wire fifo_wreq_n_39;
  wire fifo_wreq_n_40;
  wire fifo_wreq_n_41;
  wire fifo_wreq_n_42;
  wire fifo_wreq_n_43;
  wire fifo_wreq_n_44;
  wire fifo_wreq_n_46;
  wire fifo_wreq_n_47;
  wire fifo_wreq_n_5;
  wire fifo_wreq_n_6;
  wire fifo_wreq_n_8;
  wire fifo_wreq_n_9;
  wire fifo_wreq_valid;
  wire fifo_wreq_valid_buf_reg_n_2;
  wire first_sect;
  wire first_sect_carry__0_i_1_n_2;
  wire first_sect_carry__0_i_2_n_2;
  wire first_sect_carry__0_i_3_n_2;
  wire first_sect_carry__0_n_4;
  wire first_sect_carry__0_n_5;
  wire first_sect_carry_i_1_n_2;
  wire first_sect_carry_i_2_n_2;
  wire first_sect_carry_i_3_n_2;
  wire first_sect_carry_i_4_n_2;
  wire first_sect_carry_n_2;
  wire first_sect_carry_n_3;
  wire first_sect_carry_n_4;
  wire first_sect_carry_n_5;
  wire full_n_reg;
  wire gmem_WREADY;
  wire invalid_len_event;
  wire invalid_len_event_reg1;
  wire invalid_len_event_reg2;
  wire last_sect;
  wire last_sect_carry__0_n_4;
  wire last_sect_carry__0_n_5;
  wire last_sect_carry_n_2;
  wire last_sect_carry_n_3;
  wire last_sect_carry_n_4;
  wire last_sect_carry_n_5;
  wire [29:0]m_axi_gmem_AWADDR;
  wire m_axi_gmem_AWREADY;
  wire m_axi_gmem_BVALID;
  wire [31:0]m_axi_gmem_WDATA;
  wire m_axi_gmem_WLAST;
  wire m_axi_gmem_WREADY;
  wire [3:0]m_axi_gmem_WSTRB;
  wire [31:0]mem_reg;
  wire next_resp;
  wire next_resp0;
  wire next_wreq;
  wire [31:0]out;
  wire [19:0]p_0_in0_in;
  wire [5:0]p_0_in__0;
  wire [7:0]p_0_in__1;
  wire p_26_in;
  wire p_30_in;
  wire pop0;
  wire push;
  wire push_0;
  wire push_1;
  wire rs2f_wreq_ack;
  wire [29:0]rs2f_wreq_data;
  wire rs2f_wreq_valid;
  wire [31:2]sect_addr;
  wire \sect_addr_buf_reg_n_2_[10] ;
  wire \sect_addr_buf_reg_n_2_[11] ;
  wire \sect_addr_buf_reg_n_2_[12] ;
  wire \sect_addr_buf_reg_n_2_[13] ;
  wire \sect_addr_buf_reg_n_2_[14] ;
  wire \sect_addr_buf_reg_n_2_[15] ;
  wire \sect_addr_buf_reg_n_2_[16] ;
  wire \sect_addr_buf_reg_n_2_[17] ;
  wire \sect_addr_buf_reg_n_2_[18] ;
  wire \sect_addr_buf_reg_n_2_[19] ;
  wire \sect_addr_buf_reg_n_2_[20] ;
  wire \sect_addr_buf_reg_n_2_[21] ;
  wire \sect_addr_buf_reg_n_2_[22] ;
  wire \sect_addr_buf_reg_n_2_[23] ;
  wire \sect_addr_buf_reg_n_2_[24] ;
  wire \sect_addr_buf_reg_n_2_[25] ;
  wire \sect_addr_buf_reg_n_2_[26] ;
  wire \sect_addr_buf_reg_n_2_[27] ;
  wire \sect_addr_buf_reg_n_2_[28] ;
  wire \sect_addr_buf_reg_n_2_[29] ;
  wire \sect_addr_buf_reg_n_2_[2] ;
  wire \sect_addr_buf_reg_n_2_[30] ;
  wire \sect_addr_buf_reg_n_2_[31] ;
  wire \sect_addr_buf_reg_n_2_[3] ;
  wire \sect_addr_buf_reg_n_2_[4] ;
  wire \sect_addr_buf_reg_n_2_[5] ;
  wire \sect_addr_buf_reg_n_2_[6] ;
  wire \sect_addr_buf_reg_n_2_[7] ;
  wire \sect_addr_buf_reg_n_2_[8] ;
  wire \sect_addr_buf_reg_n_2_[9] ;
  wire [19:0]sect_cnt;
  wire [19:1]sect_cnt0;
  wire sect_cnt0_carry__0_n_2;
  wire sect_cnt0_carry__0_n_3;
  wire sect_cnt0_carry__0_n_4;
  wire sect_cnt0_carry__0_n_5;
  wire sect_cnt0_carry__1_n_2;
  wire sect_cnt0_carry__1_n_3;
  wire sect_cnt0_carry__1_n_4;
  wire sect_cnt0_carry__1_n_5;
  wire sect_cnt0_carry__2_n_2;
  wire sect_cnt0_carry__2_n_3;
  wire sect_cnt0_carry__2_n_4;
  wire sect_cnt0_carry__2_n_5;
  wire sect_cnt0_carry__3_n_4;
  wire sect_cnt0_carry__3_n_5;
  wire sect_cnt0_carry_n_2;
  wire sect_cnt0_carry_n_3;
  wire sect_cnt0_carry_n_4;
  wire sect_cnt0_carry_n_5;
  wire [9:4]sect_len_buf;
  wire \sect_len_buf[0]_i_1_n_2 ;
  wire \sect_len_buf[1]_i_1_n_2 ;
  wire \sect_len_buf[2]_i_1_n_2 ;
  wire \sect_len_buf[3]_i_1_n_2 ;
  wire \sect_len_buf[4]_i_1_n_2 ;
  wire \sect_len_buf[5]_i_1_n_2 ;
  wire \sect_len_buf[6]_i_1_n_2 ;
  wire \sect_len_buf[7]_i_1_n_2 ;
  wire \sect_len_buf[8]_i_1_n_2 ;
  wire \sect_len_buf[9]_i_2_n_2 ;
  wire \sect_len_buf_reg_n_2_[0] ;
  wire \sect_len_buf_reg_n_2_[1] ;
  wire \sect_len_buf_reg_n_2_[2] ;
  wire \sect_len_buf_reg_n_2_[3] ;
  wire [31:2]start_addr_buf;
  wire \start_addr_reg_n_2_[10] ;
  wire \start_addr_reg_n_2_[11] ;
  wire \start_addr_reg_n_2_[12] ;
  wire \start_addr_reg_n_2_[13] ;
  wire \start_addr_reg_n_2_[14] ;
  wire \start_addr_reg_n_2_[15] ;
  wire \start_addr_reg_n_2_[16] ;
  wire \start_addr_reg_n_2_[17] ;
  wire \start_addr_reg_n_2_[18] ;
  wire \start_addr_reg_n_2_[19] ;
  wire \start_addr_reg_n_2_[20] ;
  wire \start_addr_reg_n_2_[21] ;
  wire \start_addr_reg_n_2_[22] ;
  wire \start_addr_reg_n_2_[23] ;
  wire \start_addr_reg_n_2_[24] ;
  wire \start_addr_reg_n_2_[25] ;
  wire \start_addr_reg_n_2_[26] ;
  wire \start_addr_reg_n_2_[27] ;
  wire \start_addr_reg_n_2_[28] ;
  wire \start_addr_reg_n_2_[29] ;
  wire \start_addr_reg_n_2_[2] ;
  wire \start_addr_reg_n_2_[30] ;
  wire \start_addr_reg_n_2_[31] ;
  wire \start_addr_reg_n_2_[3] ;
  wire \start_addr_reg_n_2_[4] ;
  wire \start_addr_reg_n_2_[5] ;
  wire \start_addr_reg_n_2_[6] ;
  wire \start_addr_reg_n_2_[7] ;
  wire \start_addr_reg_n_2_[8] ;
  wire \start_addr_reg_n_2_[9] ;
  wire \throttl_cnt_reg[0] ;
  wire [0:0]\throttl_cnt_reg[0]_0 ;
  wire [3:0]tmp_strb;
  wire [5:0]\usedw_reg[5] ;
  wire [2:0]\usedw_reg[6] ;
  wire [6:0]\usedw_reg[7] ;
  wire wreq_handling_reg_n_2;
  wire zero_len_event0;
  wire [3:3]\NLW_align_len0_inferred__1/i__carry_CO_UNCONNECTED ;
  wire [0:0]\NLW_align_len0_inferred__1/i__carry_O_UNCONNECTED ;
  wire [3:2]\NLW_could_multi_bursts.awaddr_buf_reg[31]_i_6_CO_UNCONNECTED ;
  wire [3:3]\NLW_could_multi_bursts.awaddr_buf_reg[31]_i_6_O_UNCONNECTED ;
  wire [0:0]\NLW_could_multi_bursts.awaddr_buf_reg[4]_i_2_O_UNCONNECTED ;
  wire [0:0]NLW_end_addr_carry_O_UNCONNECTED;
  wire [3:1]NLW_end_addr_carry__6_CO_UNCONNECTED;
  wire [3:2]NLW_end_addr_carry__6_O_UNCONNECTED;
  wire [3:0]NLW_first_sect_carry_O_UNCONNECTED;
  wire [3:3]NLW_first_sect_carry__0_CO_UNCONNECTED;
  wire [3:0]NLW_first_sect_carry__0_O_UNCONNECTED;
  wire [3:0]NLW_last_sect_carry_O_UNCONNECTED;
  wire [3:3]NLW_last_sect_carry__0_CO_UNCONNECTED;
  wire [3:0]NLW_last_sect_carry__0_O_UNCONNECTED;
  wire [3:2]NLW_sect_cnt0_carry__3_CO_UNCONNECTED;
  wire [3:3]NLW_sect_cnt0_carry__3_O_UNCONNECTED;

  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \align_len0_inferred__1/i__carry 
       (.CI(1'b0),
        .CO({\NLW_align_len0_inferred__1/i__carry_CO_UNCONNECTED [3],\align_len0_inferred__1/i__carry_n_3 ,\align_len0_inferred__1/i__carry_n_4 ,\align_len0_inferred__1/i__carry_n_5 }),
        .CYINIT(1'b0),
        .DI({1'b0,fifo_wreq_data,1'b0,1'b0}),
        .O({align_len0[31],align_len0[3:2],\NLW_align_len0_inferred__1/i__carry_O_UNCONNECTED [0]}),
        .S({1'b1,zero_len_event0,1'b1,1'b1}));
  FDRE \align_len_reg[2] 
       (.C(ap_clk),
        .CE(align_len0_0),
        .D(align_len0[2]),
        .Q(\align_len_reg_n_2_[2] ),
        .R(fifo_wreq_n_47));
  FDRE \align_len_reg[31] 
       (.C(ap_clk),
        .CE(align_len0_0),
        .D(align_len0[31]),
        .Q(\align_len_reg_n_2_[31] ),
        .R(fifo_wreq_n_47));
  FDRE \align_len_reg[3] 
       (.C(ap_clk),
        .CE(align_len0_0),
        .D(align_len0[3]),
        .Q(\align_len_reg_n_2_[3] ),
        .R(fifo_wreq_n_47));
  FDRE \beat_len_buf_reg[0] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(\align_len_reg_n_2_[2] ),
        .Q(beat_len_buf[0]),
        .R(SR));
  FDRE \beat_len_buf_reg[1] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(\align_len_reg_n_2_[3] ),
        .Q(beat_len_buf[1]),
        .R(SR));
  FDRE \beat_len_buf_reg[3] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(\align_len_reg_n_2_[31] ),
        .Q(beat_len_buf[3]),
        .R(SR));
  design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_buffer buff_wdata
       (.DI(DI),
        .E(p_30_in),
        .Q(\usedw_reg[5] ),
        .S(S),
        .SR(SR),
        .\ap_CS_fsm_reg[10] (\ap_CS_fsm_reg[10] ),
        .\ap_CS_fsm_reg[11] (\ap_CS_fsm_reg[15] [4:3]),
        .ap_clk(ap_clk),
        .ap_reg_ioackin_gmem_WREADY(ap_reg_ioackin_gmem_WREADY),
        .ap_rst_n(ap_rst_n),
        .burst_valid(burst_valid),
        .\bus_equal_gen.WVALID_Dummy_reg (buff_wdata_n_14),
        .\dout_buf_reg[35]_0 ({tmp_strb,buff_wdata_n_26,buff_wdata_n_27,buff_wdata_n_28,buff_wdata_n_29,buff_wdata_n_30,buff_wdata_n_31,buff_wdata_n_32,buff_wdata_n_33,buff_wdata_n_34,buff_wdata_n_35,buff_wdata_n_36,buff_wdata_n_37,buff_wdata_n_38,buff_wdata_n_39,buff_wdata_n_40,buff_wdata_n_41,buff_wdata_n_42,buff_wdata_n_43,buff_wdata_n_44,buff_wdata_n_45,buff_wdata_n_46,buff_wdata_n_47,buff_wdata_n_48,buff_wdata_n_49,buff_wdata_n_50,buff_wdata_n_51,buff_wdata_n_52,buff_wdata_n_53,buff_wdata_n_54,buff_wdata_n_55,buff_wdata_n_56,buff_wdata_n_57}),
        .dout_valid_reg_0(\bus_equal_gen.WVALID_Dummy_reg_0 ),
        .gmem_WREADY(gmem_WREADY),
        .m_axi_gmem_WREADY(m_axi_gmem_WREADY),
        .mem_reg_0(mem_reg),
        .out(out),
        .\q_tmp_reg[0]_0 (Q[4:3]),
        .\usedw_reg[6]_0 (\usedw_reg[6] ),
        .\usedw_reg[7]_0 (\usedw_reg[7] ));
  FDRE \bus_equal_gen.WLAST_Dummy_reg 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\bus_equal_gen.fifo_burst_n_35 ),
        .Q(m_axi_gmem_WLAST),
        .R(SR));
  FDRE \bus_equal_gen.WVALID_Dummy_reg 
       (.C(ap_clk),
        .CE(1'b1),
        .D(buff_wdata_n_14),
        .Q(\bus_equal_gen.WVALID_Dummy_reg_0 ),
        .R(SR));
  FDRE \bus_equal_gen.data_buf_reg[0] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(buff_wdata_n_57),
        .Q(m_axi_gmem_WDATA[0]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[10] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(buff_wdata_n_47),
        .Q(m_axi_gmem_WDATA[10]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[11] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(buff_wdata_n_46),
        .Q(m_axi_gmem_WDATA[11]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[12] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(buff_wdata_n_45),
        .Q(m_axi_gmem_WDATA[12]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[13] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(buff_wdata_n_44),
        .Q(m_axi_gmem_WDATA[13]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[14] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(buff_wdata_n_43),
        .Q(m_axi_gmem_WDATA[14]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[15] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(buff_wdata_n_42),
        .Q(m_axi_gmem_WDATA[15]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[16] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(buff_wdata_n_41),
        .Q(m_axi_gmem_WDATA[16]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[17] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(buff_wdata_n_40),
        .Q(m_axi_gmem_WDATA[17]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[18] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(buff_wdata_n_39),
        .Q(m_axi_gmem_WDATA[18]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[19] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(buff_wdata_n_38),
        .Q(m_axi_gmem_WDATA[19]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[1] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(buff_wdata_n_56),
        .Q(m_axi_gmem_WDATA[1]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[20] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(buff_wdata_n_37),
        .Q(m_axi_gmem_WDATA[20]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[21] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(buff_wdata_n_36),
        .Q(m_axi_gmem_WDATA[21]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[22] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(buff_wdata_n_35),
        .Q(m_axi_gmem_WDATA[22]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[23] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(buff_wdata_n_34),
        .Q(m_axi_gmem_WDATA[23]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[24] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(buff_wdata_n_33),
        .Q(m_axi_gmem_WDATA[24]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[25] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(buff_wdata_n_32),
        .Q(m_axi_gmem_WDATA[25]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[26] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(buff_wdata_n_31),
        .Q(m_axi_gmem_WDATA[26]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[27] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(buff_wdata_n_30),
        .Q(m_axi_gmem_WDATA[27]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[28] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(buff_wdata_n_29),
        .Q(m_axi_gmem_WDATA[28]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[29] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(buff_wdata_n_28),
        .Q(m_axi_gmem_WDATA[29]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[2] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(buff_wdata_n_55),
        .Q(m_axi_gmem_WDATA[2]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[30] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(buff_wdata_n_27),
        .Q(m_axi_gmem_WDATA[30]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[31] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(buff_wdata_n_26),
        .Q(m_axi_gmem_WDATA[31]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[3] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(buff_wdata_n_54),
        .Q(m_axi_gmem_WDATA[3]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[4] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(buff_wdata_n_53),
        .Q(m_axi_gmem_WDATA[4]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[5] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(buff_wdata_n_52),
        .Q(m_axi_gmem_WDATA[5]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[6] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(buff_wdata_n_51),
        .Q(m_axi_gmem_WDATA[6]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[7] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(buff_wdata_n_50),
        .Q(m_axi_gmem_WDATA[7]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[8] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(buff_wdata_n_49),
        .Q(m_axi_gmem_WDATA[8]),
        .R(1'b0));
  FDRE \bus_equal_gen.data_buf_reg[9] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(buff_wdata_n_48),
        .Q(m_axi_gmem_WDATA[9]),
        .R(1'b0));
  design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo \bus_equal_gen.fifo_burst 
       (.CO(last_sect),
        .D({\bus_equal_gen.fifo_burst_n_7 ,\bus_equal_gen.fifo_burst_n_8 ,\bus_equal_gen.fifo_burst_n_9 ,\bus_equal_gen.fifo_burst_n_10 ,\bus_equal_gen.fifo_burst_n_11 ,\bus_equal_gen.fifo_burst_n_12 ,\bus_equal_gen.fifo_burst_n_13 ,\bus_equal_gen.fifo_burst_n_14 ,\bus_equal_gen.fifo_burst_n_15 ,\bus_equal_gen.fifo_burst_n_16 ,\bus_equal_gen.fifo_burst_n_17 ,\bus_equal_gen.fifo_burst_n_18 ,\bus_equal_gen.fifo_burst_n_19 ,\bus_equal_gen.fifo_burst_n_20 ,\bus_equal_gen.fifo_burst_n_21 ,\bus_equal_gen.fifo_burst_n_22 ,\bus_equal_gen.fifo_burst_n_23 ,\bus_equal_gen.fifo_burst_n_24 ,\bus_equal_gen.fifo_burst_n_25 ,\bus_equal_gen.fifo_burst_n_26 }),
        .E(pop0),
        .Q({\start_addr_reg_n_2_[31] ,\start_addr_reg_n_2_[30] ,\start_addr_reg_n_2_[29] ,\start_addr_reg_n_2_[28] ,\start_addr_reg_n_2_[27] ,\start_addr_reg_n_2_[26] ,\start_addr_reg_n_2_[25] ,\start_addr_reg_n_2_[24] ,\start_addr_reg_n_2_[23] ,\start_addr_reg_n_2_[22] ,\start_addr_reg_n_2_[21] ,\start_addr_reg_n_2_[20] ,\start_addr_reg_n_2_[19] ,\start_addr_reg_n_2_[18] ,\start_addr_reg_n_2_[17] ,\start_addr_reg_n_2_[16] ,\start_addr_reg_n_2_[15] ,\start_addr_reg_n_2_[14] ,\start_addr_reg_n_2_[13] ,\start_addr_reg_n_2_[12] }),
        .SR(SR),
        .ap_clk(ap_clk),
        .ap_rst_n(ap_rst_n),
        .ap_rst_n_0(\bus_equal_gen.fifo_burst_n_37 ),
        .ap_rst_n_1(\bus_equal_gen.fifo_burst_n_38 ),
        .ap_rst_n_2(\bus_equal_gen.fifo_burst_n_39 ),
        .burst_valid(burst_valid),
        .\bus_equal_gen.WLAST_Dummy_i_2_0 (\bus_equal_gen.len_cnt_reg__0 ),
        .\bus_equal_gen.WLAST_Dummy_reg (\bus_equal_gen.fifo_burst_n_35 ),
        .\bus_equal_gen.WLAST_Dummy_reg_0 (\bus_equal_gen.WVALID_Dummy_reg_0 ),
        .\could_multi_bursts.AWVALID_Dummy_reg (\could_multi_bursts.AWVALID_Dummy_reg_1 ),
        .\could_multi_bursts.awaddr_buf_reg[2] (AWVALID_Dummy),
        .\could_multi_bursts.awaddr_buf_reg[2]_0 (\could_multi_bursts.awaddr_buf_reg[2]_0 ),
        .\could_multi_bursts.awaddr_buf_reg[2]_1 (\could_multi_bursts.awaddr_buf_reg[2]_1 ),
        .\could_multi_bursts.awlen_buf[3]_i_2_0 ({sect_len_buf,\sect_len_buf_reg_n_2_[3] ,\sect_len_buf_reg_n_2_[2] ,\sect_len_buf_reg_n_2_[1] ,\sect_len_buf_reg_n_2_[0] }),
        .\could_multi_bursts.awlen_buf[3]_i_2_1 (\could_multi_bursts.loop_cnt_reg__0 ),
        .\could_multi_bursts.last_sect_buf_reg (\bus_equal_gen.fifo_burst_n_36 ),
        .\could_multi_bursts.last_sect_buf_reg_0 (\could_multi_bursts.last_sect_buf_reg_n_2 ),
        .\could_multi_bursts.loop_cnt_reg[0] (\bus_equal_gen.fifo_burst_n_28 ),
        .\could_multi_bursts.sect_handling_reg (\bus_equal_gen.fifo_burst_n_34 ),
        .\could_multi_bursts.sect_handling_reg_0 (\could_multi_bursts.sect_handling_reg_n_2 ),
        .\end_addr_buf_reg[31] (fifo_wreq_n_5),
        .fifo_resp_ready(fifo_resp_ready),
        .fifo_wreq_valid(fifo_wreq_valid),
        .in(invalid_len_event_reg2),
        .invalid_len_event_reg2_reg(\bus_equal_gen.fifo_burst_n_3 ),
        .m_axi_gmem_AWREADY(m_axi_gmem_AWREADY),
        .m_axi_gmem_WLAST(m_axi_gmem_WLAST),
        .m_axi_gmem_WREADY(m_axi_gmem_WREADY),
        .next_wreq(next_wreq),
        .p_26_in(p_26_in),
        .push(push),
        .\q_reg[0]_0 (p_30_in),
        .\sect_addr_buf_reg[2] (first_sect),
        .sect_cnt0(sect_cnt0),
        .\sect_cnt_reg[0] (sect_cnt[0]),
        .\sect_len_buf_reg[3] (awlen_tmp),
        .wreq_handling_reg(\bus_equal_gen.fifo_burst_n_33 ),
        .wreq_handling_reg_0(wreq_handling_reg_n_2),
        .wreq_handling_reg_1(fifo_wreq_valid_buf_reg_n_2));
  LUT1 #(
    .INIT(2'h1)) 
    \bus_equal_gen.len_cnt[0]_i_1 
       (.I0(\bus_equal_gen.len_cnt_reg__0 [0]),
        .O(p_0_in__1[0]));
  (* SOFT_HLUTNM = "soft_lutpair201" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \bus_equal_gen.len_cnt[1]_i_1 
       (.I0(\bus_equal_gen.len_cnt_reg__0 [1]),
        .I1(\bus_equal_gen.len_cnt_reg__0 [0]),
        .O(p_0_in__1[1]));
  (* SOFT_HLUTNM = "soft_lutpair201" *) 
  LUT3 #(
    .INIT(8'h6A)) 
    \bus_equal_gen.len_cnt[2]_i_1 
       (.I0(\bus_equal_gen.len_cnt_reg__0 [2]),
        .I1(\bus_equal_gen.len_cnt_reg__0 [0]),
        .I2(\bus_equal_gen.len_cnt_reg__0 [1]),
        .O(p_0_in__1[2]));
  (* SOFT_HLUTNM = "soft_lutpair174" *) 
  LUT4 #(
    .INIT(16'h6AAA)) 
    \bus_equal_gen.len_cnt[3]_i_1 
       (.I0(\bus_equal_gen.len_cnt_reg__0 [3]),
        .I1(\bus_equal_gen.len_cnt_reg__0 [1]),
        .I2(\bus_equal_gen.len_cnt_reg__0 [0]),
        .I3(\bus_equal_gen.len_cnt_reg__0 [2]),
        .O(p_0_in__1[3]));
  (* SOFT_HLUTNM = "soft_lutpair174" *) 
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    \bus_equal_gen.len_cnt[4]_i_1 
       (.I0(\bus_equal_gen.len_cnt_reg__0 [4]),
        .I1(\bus_equal_gen.len_cnt_reg__0 [3]),
        .I2(\bus_equal_gen.len_cnt_reg__0 [2]),
        .I3(\bus_equal_gen.len_cnt_reg__0 [0]),
        .I4(\bus_equal_gen.len_cnt_reg__0 [1]),
        .O(p_0_in__1[4]));
  LUT6 #(
    .INIT(64'h6AAAAAAAAAAAAAAA)) 
    \bus_equal_gen.len_cnt[5]_i_1 
       (.I0(\bus_equal_gen.len_cnt_reg__0 [5]),
        .I1(\bus_equal_gen.len_cnt_reg__0 [1]),
        .I2(\bus_equal_gen.len_cnt_reg__0 [0]),
        .I3(\bus_equal_gen.len_cnt_reg__0 [2]),
        .I4(\bus_equal_gen.len_cnt_reg__0 [3]),
        .I5(\bus_equal_gen.len_cnt_reg__0 [4]),
        .O(p_0_in__1[5]));
  (* SOFT_HLUTNM = "soft_lutpair202" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \bus_equal_gen.len_cnt[6]_i_1 
       (.I0(\bus_equal_gen.len_cnt_reg__0 [6]),
        .I1(\bus_equal_gen.len_cnt[7]_i_3_n_2 ),
        .O(p_0_in__1[6]));
  (* SOFT_HLUTNM = "soft_lutpair202" *) 
  LUT3 #(
    .INIT(8'h6A)) 
    \bus_equal_gen.len_cnt[7]_i_2 
       (.I0(\bus_equal_gen.len_cnt_reg__0 [7]),
        .I1(\bus_equal_gen.len_cnt[7]_i_3_n_2 ),
        .I2(\bus_equal_gen.len_cnt_reg__0 [6]),
        .O(p_0_in__1[7]));
  LUT6 #(
    .INIT(64'h8000000000000000)) 
    \bus_equal_gen.len_cnt[7]_i_3 
       (.I0(\bus_equal_gen.len_cnt_reg__0 [5]),
        .I1(\bus_equal_gen.len_cnt_reg__0 [1]),
        .I2(\bus_equal_gen.len_cnt_reg__0 [0]),
        .I3(\bus_equal_gen.len_cnt_reg__0 [2]),
        .I4(\bus_equal_gen.len_cnt_reg__0 [3]),
        .I5(\bus_equal_gen.len_cnt_reg__0 [4]),
        .O(\bus_equal_gen.len_cnt[7]_i_3_n_2 ));
  FDRE \bus_equal_gen.len_cnt_reg[0] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(p_0_in__1[0]),
        .Q(\bus_equal_gen.len_cnt_reg__0 [0]),
        .R(\bus_equal_gen.fifo_burst_n_39 ));
  FDRE \bus_equal_gen.len_cnt_reg[1] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(p_0_in__1[1]),
        .Q(\bus_equal_gen.len_cnt_reg__0 [1]),
        .R(\bus_equal_gen.fifo_burst_n_39 ));
  FDRE \bus_equal_gen.len_cnt_reg[2] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(p_0_in__1[2]),
        .Q(\bus_equal_gen.len_cnt_reg__0 [2]),
        .R(\bus_equal_gen.fifo_burst_n_39 ));
  FDRE \bus_equal_gen.len_cnt_reg[3] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(p_0_in__1[3]),
        .Q(\bus_equal_gen.len_cnt_reg__0 [3]),
        .R(\bus_equal_gen.fifo_burst_n_39 ));
  FDRE \bus_equal_gen.len_cnt_reg[4] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(p_0_in__1[4]),
        .Q(\bus_equal_gen.len_cnt_reg__0 [4]),
        .R(\bus_equal_gen.fifo_burst_n_39 ));
  FDRE \bus_equal_gen.len_cnt_reg[5] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(p_0_in__1[5]),
        .Q(\bus_equal_gen.len_cnt_reg__0 [5]),
        .R(\bus_equal_gen.fifo_burst_n_39 ));
  FDRE \bus_equal_gen.len_cnt_reg[6] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(p_0_in__1[6]),
        .Q(\bus_equal_gen.len_cnt_reg__0 [6]),
        .R(\bus_equal_gen.fifo_burst_n_39 ));
  FDRE \bus_equal_gen.len_cnt_reg[7] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(p_0_in__1[7]),
        .Q(\bus_equal_gen.len_cnt_reg__0 [7]),
        .R(\bus_equal_gen.fifo_burst_n_39 ));
  FDRE \bus_equal_gen.strb_buf_reg[0] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(tmp_strb[0]),
        .Q(m_axi_gmem_WSTRB[0]),
        .R(SR));
  FDRE \bus_equal_gen.strb_buf_reg[1] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(tmp_strb[1]),
        .Q(m_axi_gmem_WSTRB[1]),
        .R(SR));
  FDRE \bus_equal_gen.strb_buf_reg[2] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(tmp_strb[2]),
        .Q(m_axi_gmem_WSTRB[2]),
        .R(SR));
  FDRE \bus_equal_gen.strb_buf_reg[3] 
       (.C(ap_clk),
        .CE(p_30_in),
        .D(tmp_strb[3]),
        .Q(m_axi_gmem_WSTRB[3]),
        .R(SR));
  FDRE \could_multi_bursts.AWVALID_Dummy_reg 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\bus_equal_gen.fifo_burst_n_3 ),
        .Q(AWVALID_Dummy),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair179" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.awaddr_buf[10]_i_1 
       (.I0(data1[10]),
        .I1(\could_multi_bursts.awaddr_buf[31]_i_7_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[10] ),
        .O(awaddr_tmp[10]));
  (* SOFT_HLUTNM = "soft_lutpair180" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.awaddr_buf[11]_i_1 
       (.I0(data1[11]),
        .I1(\could_multi_bursts.awaddr_buf[31]_i_7_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[11] ),
        .O(awaddr_tmp[11]));
  (* SOFT_HLUTNM = "soft_lutpair178" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.awaddr_buf[12]_i_1 
       (.I0(data1[12]),
        .I1(\could_multi_bursts.awaddr_buf[31]_i_7_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[12] ),
        .O(awaddr_tmp[12]));
  (* SOFT_HLUTNM = "soft_lutpair177" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.awaddr_buf[13]_i_1 
       (.I0(data1[13]),
        .I1(\could_multi_bursts.awaddr_buf[31]_i_7_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[13] ),
        .O(awaddr_tmp[13]));
  (* SOFT_HLUTNM = "soft_lutpair184" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.awaddr_buf[14]_i_1 
       (.I0(data1[14]),
        .I1(\could_multi_bursts.awaddr_buf[31]_i_7_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[14] ),
        .O(awaddr_tmp[14]));
  (* SOFT_HLUTNM = "soft_lutpair176" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.awaddr_buf[15]_i_1 
       (.I0(data1[15]),
        .I1(\could_multi_bursts.awaddr_buf[31]_i_7_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[15] ),
        .O(awaddr_tmp[15]));
  (* SOFT_HLUTNM = "soft_lutpair175" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.awaddr_buf[16]_i_1 
       (.I0(data1[16]),
        .I1(\could_multi_bursts.awaddr_buf[31]_i_7_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[16] ),
        .O(awaddr_tmp[16]));
  (* SOFT_HLUTNM = "soft_lutpair187" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.awaddr_buf[17]_i_1 
       (.I0(data1[17]),
        .I1(\could_multi_bursts.awaddr_buf[31]_i_7_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[17] ),
        .O(awaddr_tmp[17]));
  (* SOFT_HLUTNM = "soft_lutpair187" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.awaddr_buf[18]_i_1 
       (.I0(data1[18]),
        .I1(\could_multi_bursts.awaddr_buf[31]_i_7_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[18] ),
        .O(awaddr_tmp[18]));
  (* SOFT_HLUTNM = "soft_lutpair197" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.awaddr_buf[19]_i_1 
       (.I0(data1[19]),
        .I1(\could_multi_bursts.awaddr_buf[31]_i_7_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[19] ),
        .O(awaddr_tmp[19]));
  (* SOFT_HLUTNM = "soft_lutpair197" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.awaddr_buf[20]_i_1 
       (.I0(data1[20]),
        .I1(\could_multi_bursts.awaddr_buf[31]_i_7_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[20] ),
        .O(awaddr_tmp[20]));
  (* SOFT_HLUTNM = "soft_lutpair185" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.awaddr_buf[21]_i_1 
       (.I0(data1[21]),
        .I1(\could_multi_bursts.awaddr_buf[31]_i_7_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[21] ),
        .O(awaddr_tmp[21]));
  (* SOFT_HLUTNM = "soft_lutpair182" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.awaddr_buf[22]_i_1 
       (.I0(data1[22]),
        .I1(\could_multi_bursts.awaddr_buf[31]_i_7_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[22] ),
        .O(awaddr_tmp[22]));
  (* SOFT_HLUTNM = "soft_lutpair184" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.awaddr_buf[23]_i_1 
       (.I0(data1[23]),
        .I1(\could_multi_bursts.awaddr_buf[31]_i_7_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[23] ),
        .O(awaddr_tmp[23]));
  (* SOFT_HLUTNM = "soft_lutpair183" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.awaddr_buf[24]_i_1 
       (.I0(data1[24]),
        .I1(\could_multi_bursts.awaddr_buf[31]_i_7_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[24] ),
        .O(awaddr_tmp[24]));
  (* SOFT_HLUTNM = "soft_lutpair181" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.awaddr_buf[25]_i_1 
       (.I0(data1[25]),
        .I1(\could_multi_bursts.awaddr_buf[31]_i_7_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[25] ),
        .O(awaddr_tmp[25]));
  (* SOFT_HLUTNM = "soft_lutpair178" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.awaddr_buf[26]_i_1 
       (.I0(data1[26]),
        .I1(\could_multi_bursts.awaddr_buf[31]_i_7_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[26] ),
        .O(awaddr_tmp[26]));
  (* SOFT_HLUTNM = "soft_lutpair180" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.awaddr_buf[27]_i_1 
       (.I0(data1[27]),
        .I1(\could_multi_bursts.awaddr_buf[31]_i_7_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[27] ),
        .O(awaddr_tmp[27]));
  (* SOFT_HLUTNM = "soft_lutpair179" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.awaddr_buf[28]_i_1 
       (.I0(data1[28]),
        .I1(\could_multi_bursts.awaddr_buf[31]_i_7_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[28] ),
        .O(awaddr_tmp[28]));
  (* SOFT_HLUTNM = "soft_lutpair177" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.awaddr_buf[29]_i_1 
       (.I0(data1[29]),
        .I1(\could_multi_bursts.awaddr_buf[31]_i_7_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[29] ),
        .O(awaddr_tmp[29]));
  (* SOFT_HLUTNM = "soft_lutpair199" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.awaddr_buf[2]_i_1 
       (.I0(data1[2]),
        .I1(\could_multi_bursts.awaddr_buf[31]_i_7_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[2] ),
        .O(awaddr_tmp[2]));
  (* SOFT_HLUTNM = "soft_lutpair175" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.awaddr_buf[30]_i_1 
       (.I0(data1[30]),
        .I1(\could_multi_bursts.awaddr_buf[31]_i_7_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[30] ),
        .O(awaddr_tmp[30]));
  (* SOFT_HLUTNM = "soft_lutpair176" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.awaddr_buf[31]_i_3 
       (.I0(data1[31]),
        .I1(\could_multi_bursts.awaddr_buf[31]_i_7_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[31] ),
        .O(awaddr_tmp[31]));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \could_multi_bursts.awaddr_buf[31]_i_7 
       (.I0(\could_multi_bursts.loop_cnt_reg__0 [0]),
        .I1(\could_multi_bursts.loop_cnt_reg__0 [1]),
        .I2(\could_multi_bursts.loop_cnt_reg__0 [2]),
        .I3(\could_multi_bursts.loop_cnt_reg__0 [5]),
        .I4(\could_multi_bursts.loop_cnt_reg__0 [4]),
        .I5(\could_multi_bursts.loop_cnt_reg__0 [3]),
        .O(\could_multi_bursts.awaddr_buf[31]_i_7_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair198" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.awaddr_buf[3]_i_1 
       (.I0(data1[3]),
        .I1(\could_multi_bursts.awaddr_buf[31]_i_7_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[3] ),
        .O(awaddr_tmp[3]));
  (* SOFT_HLUTNM = "soft_lutpair199" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.awaddr_buf[4]_i_1 
       (.I0(data1[4]),
        .I1(\could_multi_bursts.awaddr_buf[31]_i_7_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[4] ),
        .O(awaddr_tmp[4]));
  LUT4 #(
    .INIT(16'h956A)) 
    \could_multi_bursts.awaddr_buf[4]_i_3 
       (.I0(m_axi_gmem_AWADDR[2]),
        .I1(\could_multi_bursts.awlen_buf_reg[3]_0 [1]),
        .I2(\could_multi_bursts.awlen_buf_reg[3]_0 [0]),
        .I3(\could_multi_bursts.awlen_buf_reg[3]_0 [2]),
        .O(\could_multi_bursts.awaddr_buf[4]_i_3_n_2 ));
  LUT3 #(
    .INIT(8'h96)) 
    \could_multi_bursts.awaddr_buf[4]_i_4 
       (.I0(m_axi_gmem_AWADDR[1]),
        .I1(\could_multi_bursts.awlen_buf_reg[3]_0 [0]),
        .I2(\could_multi_bursts.awlen_buf_reg[3]_0 [1]),
        .O(\could_multi_bursts.awaddr_buf[4]_i_4_n_2 ));
  LUT2 #(
    .INIT(4'h9)) 
    \could_multi_bursts.awaddr_buf[4]_i_5 
       (.I0(m_axi_gmem_AWADDR[0]),
        .I1(\could_multi_bursts.awlen_buf_reg[3]_0 [0]),
        .O(\could_multi_bursts.awaddr_buf[4]_i_5_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair198" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.awaddr_buf[5]_i_1 
       (.I0(data1[5]),
        .I1(\could_multi_bursts.awaddr_buf[31]_i_7_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[5] ),
        .O(awaddr_tmp[5]));
  (* SOFT_HLUTNM = "soft_lutpair185" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.awaddr_buf[6]_i_1 
       (.I0(data1[6]),
        .I1(\could_multi_bursts.awaddr_buf[31]_i_7_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[6] ),
        .O(awaddr_tmp[6]));
  (* SOFT_HLUTNM = "soft_lutpair183" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.awaddr_buf[7]_i_1 
       (.I0(data1[7]),
        .I1(\could_multi_bursts.awaddr_buf[31]_i_7_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[7] ),
        .O(awaddr_tmp[7]));
  (* SOFT_HLUTNM = "soft_lutpair182" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.awaddr_buf[8]_i_1 
       (.I0(data1[8]),
        .I1(\could_multi_bursts.awaddr_buf[31]_i_7_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[8] ),
        .O(awaddr_tmp[8]));
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    \could_multi_bursts.awaddr_buf[8]_i_3 
       (.I0(m_axi_gmem_AWADDR[4]),
        .I1(\could_multi_bursts.awlen_buf_reg[3]_0 [0]),
        .I2(\could_multi_bursts.awlen_buf_reg[3]_0 [1]),
        .I3(\could_multi_bursts.awlen_buf_reg[3]_0 [2]),
        .I4(\could_multi_bursts.awlen_buf_reg[3]_0 [3]),
        .O(\could_multi_bursts.awaddr_buf[8]_i_3_n_2 ));
  LUT5 #(
    .INIT(32'h95556AAA)) 
    \could_multi_bursts.awaddr_buf[8]_i_4 
       (.I0(m_axi_gmem_AWADDR[3]),
        .I1(\could_multi_bursts.awlen_buf_reg[3]_0 [0]),
        .I2(\could_multi_bursts.awlen_buf_reg[3]_0 [1]),
        .I3(\could_multi_bursts.awlen_buf_reg[3]_0 [2]),
        .I4(\could_multi_bursts.awlen_buf_reg[3]_0 [3]),
        .O(\could_multi_bursts.awaddr_buf[8]_i_4_n_2 ));
  (* SOFT_HLUTNM = "soft_lutpair181" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \could_multi_bursts.awaddr_buf[9]_i_1 
       (.I0(data1[9]),
        .I1(\could_multi_bursts.awaddr_buf[31]_i_7_n_2 ),
        .I2(\sect_addr_buf_reg_n_2_[9] ),
        .O(awaddr_tmp[9]));
  FDRE \could_multi_bursts.awaddr_buf_reg[10] 
       (.C(ap_clk),
        .CE(push),
        .D(awaddr_tmp[10]),
        .Q(m_axi_gmem_AWADDR[8]),
        .R(SR));
  FDRE \could_multi_bursts.awaddr_buf_reg[11] 
       (.C(ap_clk),
        .CE(push),
        .D(awaddr_tmp[11]),
        .Q(m_axi_gmem_AWADDR[9]),
        .R(SR));
  FDRE \could_multi_bursts.awaddr_buf_reg[12] 
       (.C(ap_clk),
        .CE(push),
        .D(awaddr_tmp[12]),
        .Q(m_axi_gmem_AWADDR[10]),
        .R(SR));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \could_multi_bursts.awaddr_buf_reg[12]_i_2 
       (.CI(\could_multi_bursts.awaddr_buf_reg[8]_i_2_n_2 ),
        .CO({\could_multi_bursts.awaddr_buf_reg[12]_i_2_n_2 ,\could_multi_bursts.awaddr_buf_reg[12]_i_2_n_3 ,\could_multi_bursts.awaddr_buf_reg[12]_i_2_n_4 ,\could_multi_bursts.awaddr_buf_reg[12]_i_2_n_5 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,m_axi_gmem_AWADDR[8:7]}),
        .O(data1[12:9]),
        .S(m_axi_gmem_AWADDR[10:7]));
  FDRE \could_multi_bursts.awaddr_buf_reg[13] 
       (.C(ap_clk),
        .CE(push),
        .D(awaddr_tmp[13]),
        .Q(m_axi_gmem_AWADDR[11]),
        .R(SR));
  FDRE \could_multi_bursts.awaddr_buf_reg[14] 
       (.C(ap_clk),
        .CE(push),
        .D(awaddr_tmp[14]),
        .Q(m_axi_gmem_AWADDR[12]),
        .R(SR));
  FDRE \could_multi_bursts.awaddr_buf_reg[15] 
       (.C(ap_clk),
        .CE(push),
        .D(awaddr_tmp[15]),
        .Q(m_axi_gmem_AWADDR[13]),
        .R(SR));
  FDRE \could_multi_bursts.awaddr_buf_reg[16] 
       (.C(ap_clk),
        .CE(push),
        .D(awaddr_tmp[16]),
        .Q(m_axi_gmem_AWADDR[14]),
        .R(SR));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \could_multi_bursts.awaddr_buf_reg[16]_i_2 
       (.CI(\could_multi_bursts.awaddr_buf_reg[12]_i_2_n_2 ),
        .CO({\could_multi_bursts.awaddr_buf_reg[16]_i_2_n_2 ,\could_multi_bursts.awaddr_buf_reg[16]_i_2_n_3 ,\could_multi_bursts.awaddr_buf_reg[16]_i_2_n_4 ,\could_multi_bursts.awaddr_buf_reg[16]_i_2_n_5 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(data1[16:13]),
        .S(m_axi_gmem_AWADDR[14:11]));
  FDRE \could_multi_bursts.awaddr_buf_reg[17] 
       (.C(ap_clk),
        .CE(push),
        .D(awaddr_tmp[17]),
        .Q(m_axi_gmem_AWADDR[15]),
        .R(SR));
  FDRE \could_multi_bursts.awaddr_buf_reg[18] 
       (.C(ap_clk),
        .CE(push),
        .D(awaddr_tmp[18]),
        .Q(m_axi_gmem_AWADDR[16]),
        .R(SR));
  FDRE \could_multi_bursts.awaddr_buf_reg[19] 
       (.C(ap_clk),
        .CE(push),
        .D(awaddr_tmp[19]),
        .Q(m_axi_gmem_AWADDR[17]),
        .R(SR));
  FDRE \could_multi_bursts.awaddr_buf_reg[20] 
       (.C(ap_clk),
        .CE(push),
        .D(awaddr_tmp[20]),
        .Q(m_axi_gmem_AWADDR[18]),
        .R(SR));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \could_multi_bursts.awaddr_buf_reg[20]_i_2 
       (.CI(\could_multi_bursts.awaddr_buf_reg[16]_i_2_n_2 ),
        .CO({\could_multi_bursts.awaddr_buf_reg[20]_i_2_n_2 ,\could_multi_bursts.awaddr_buf_reg[20]_i_2_n_3 ,\could_multi_bursts.awaddr_buf_reg[20]_i_2_n_4 ,\could_multi_bursts.awaddr_buf_reg[20]_i_2_n_5 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(data1[20:17]),
        .S(m_axi_gmem_AWADDR[18:15]));
  FDRE \could_multi_bursts.awaddr_buf_reg[21] 
       (.C(ap_clk),
        .CE(push),
        .D(awaddr_tmp[21]),
        .Q(m_axi_gmem_AWADDR[19]),
        .R(SR));
  FDRE \could_multi_bursts.awaddr_buf_reg[22] 
       (.C(ap_clk),
        .CE(push),
        .D(awaddr_tmp[22]),
        .Q(m_axi_gmem_AWADDR[20]),
        .R(SR));
  FDRE \could_multi_bursts.awaddr_buf_reg[23] 
       (.C(ap_clk),
        .CE(push),
        .D(awaddr_tmp[23]),
        .Q(m_axi_gmem_AWADDR[21]),
        .R(SR));
  FDRE \could_multi_bursts.awaddr_buf_reg[24] 
       (.C(ap_clk),
        .CE(push),
        .D(awaddr_tmp[24]),
        .Q(m_axi_gmem_AWADDR[22]),
        .R(SR));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \could_multi_bursts.awaddr_buf_reg[24]_i_2 
       (.CI(\could_multi_bursts.awaddr_buf_reg[20]_i_2_n_2 ),
        .CO({\could_multi_bursts.awaddr_buf_reg[24]_i_2_n_2 ,\could_multi_bursts.awaddr_buf_reg[24]_i_2_n_3 ,\could_multi_bursts.awaddr_buf_reg[24]_i_2_n_4 ,\could_multi_bursts.awaddr_buf_reg[24]_i_2_n_5 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(data1[24:21]),
        .S(m_axi_gmem_AWADDR[22:19]));
  FDRE \could_multi_bursts.awaddr_buf_reg[25] 
       (.C(ap_clk),
        .CE(push),
        .D(awaddr_tmp[25]),
        .Q(m_axi_gmem_AWADDR[23]),
        .R(SR));
  FDRE \could_multi_bursts.awaddr_buf_reg[26] 
       (.C(ap_clk),
        .CE(push),
        .D(awaddr_tmp[26]),
        .Q(m_axi_gmem_AWADDR[24]),
        .R(SR));
  FDRE \could_multi_bursts.awaddr_buf_reg[27] 
       (.C(ap_clk),
        .CE(push),
        .D(awaddr_tmp[27]),
        .Q(m_axi_gmem_AWADDR[25]),
        .R(SR));
  FDRE \could_multi_bursts.awaddr_buf_reg[28] 
       (.C(ap_clk),
        .CE(push),
        .D(awaddr_tmp[28]),
        .Q(m_axi_gmem_AWADDR[26]),
        .R(SR));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \could_multi_bursts.awaddr_buf_reg[28]_i_2 
       (.CI(\could_multi_bursts.awaddr_buf_reg[24]_i_2_n_2 ),
        .CO({\could_multi_bursts.awaddr_buf_reg[28]_i_2_n_2 ,\could_multi_bursts.awaddr_buf_reg[28]_i_2_n_3 ,\could_multi_bursts.awaddr_buf_reg[28]_i_2_n_4 ,\could_multi_bursts.awaddr_buf_reg[28]_i_2_n_5 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(data1[28:25]),
        .S(m_axi_gmem_AWADDR[26:23]));
  FDRE \could_multi_bursts.awaddr_buf_reg[29] 
       (.C(ap_clk),
        .CE(push),
        .D(awaddr_tmp[29]),
        .Q(m_axi_gmem_AWADDR[27]),
        .R(SR));
  FDRE \could_multi_bursts.awaddr_buf_reg[2] 
       (.C(ap_clk),
        .CE(push),
        .D(awaddr_tmp[2]),
        .Q(m_axi_gmem_AWADDR[0]),
        .R(SR));
  FDRE \could_multi_bursts.awaddr_buf_reg[30] 
       (.C(ap_clk),
        .CE(push),
        .D(awaddr_tmp[30]),
        .Q(m_axi_gmem_AWADDR[28]),
        .R(SR));
  FDRE \could_multi_bursts.awaddr_buf_reg[31] 
       (.C(ap_clk),
        .CE(push),
        .D(awaddr_tmp[31]),
        .Q(m_axi_gmem_AWADDR[29]),
        .R(SR));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \could_multi_bursts.awaddr_buf_reg[31]_i_6 
       (.CI(\could_multi_bursts.awaddr_buf_reg[28]_i_2_n_2 ),
        .CO({\NLW_could_multi_bursts.awaddr_buf_reg[31]_i_6_CO_UNCONNECTED [3:2],\could_multi_bursts.awaddr_buf_reg[31]_i_6_n_4 ,\could_multi_bursts.awaddr_buf_reg[31]_i_6_n_5 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_could_multi_bursts.awaddr_buf_reg[31]_i_6_O_UNCONNECTED [3],data1[31:29]}),
        .S({1'b0,m_axi_gmem_AWADDR[29:27]}));
  FDRE \could_multi_bursts.awaddr_buf_reg[3] 
       (.C(ap_clk),
        .CE(push),
        .D(awaddr_tmp[3]),
        .Q(m_axi_gmem_AWADDR[1]),
        .R(SR));
  FDRE \could_multi_bursts.awaddr_buf_reg[4] 
       (.C(ap_clk),
        .CE(push),
        .D(awaddr_tmp[4]),
        .Q(m_axi_gmem_AWADDR[2]),
        .R(SR));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \could_multi_bursts.awaddr_buf_reg[4]_i_2 
       (.CI(1'b0),
        .CO({\could_multi_bursts.awaddr_buf_reg[4]_i_2_n_2 ,\could_multi_bursts.awaddr_buf_reg[4]_i_2_n_3 ,\could_multi_bursts.awaddr_buf_reg[4]_i_2_n_4 ,\could_multi_bursts.awaddr_buf_reg[4]_i_2_n_5 }),
        .CYINIT(1'b0),
        .DI({m_axi_gmem_AWADDR[2:0],1'b0}),
        .O({data1[4:2],\NLW_could_multi_bursts.awaddr_buf_reg[4]_i_2_O_UNCONNECTED [0]}),
        .S({\could_multi_bursts.awaddr_buf[4]_i_3_n_2 ,\could_multi_bursts.awaddr_buf[4]_i_4_n_2 ,\could_multi_bursts.awaddr_buf[4]_i_5_n_2 ,1'b0}));
  FDRE \could_multi_bursts.awaddr_buf_reg[5] 
       (.C(ap_clk),
        .CE(push),
        .D(awaddr_tmp[5]),
        .Q(m_axi_gmem_AWADDR[3]),
        .R(SR));
  FDRE \could_multi_bursts.awaddr_buf_reg[6] 
       (.C(ap_clk),
        .CE(push),
        .D(awaddr_tmp[6]),
        .Q(m_axi_gmem_AWADDR[4]),
        .R(SR));
  FDRE \could_multi_bursts.awaddr_buf_reg[7] 
       (.C(ap_clk),
        .CE(push),
        .D(awaddr_tmp[7]),
        .Q(m_axi_gmem_AWADDR[5]),
        .R(SR));
  FDRE \could_multi_bursts.awaddr_buf_reg[8] 
       (.C(ap_clk),
        .CE(push),
        .D(awaddr_tmp[8]),
        .Q(m_axi_gmem_AWADDR[6]),
        .R(SR));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \could_multi_bursts.awaddr_buf_reg[8]_i_2 
       (.CI(\could_multi_bursts.awaddr_buf_reg[4]_i_2_n_2 ),
        .CO({\could_multi_bursts.awaddr_buf_reg[8]_i_2_n_2 ,\could_multi_bursts.awaddr_buf_reg[8]_i_2_n_3 ,\could_multi_bursts.awaddr_buf_reg[8]_i_2_n_4 ,\could_multi_bursts.awaddr_buf_reg[8]_i_2_n_5 }),
        .CYINIT(1'b0),
        .DI(m_axi_gmem_AWADDR[6:3]),
        .O(data1[8:5]),
        .S({m_axi_gmem_AWADDR[6:5],\could_multi_bursts.awaddr_buf[8]_i_3_n_2 ,\could_multi_bursts.awaddr_buf[8]_i_4_n_2 }));
  FDRE \could_multi_bursts.awaddr_buf_reg[9] 
       (.C(ap_clk),
        .CE(push),
        .D(awaddr_tmp[9]),
        .Q(m_axi_gmem_AWADDR[7]),
        .R(SR));
  FDRE \could_multi_bursts.awlen_buf_reg[0] 
       (.C(ap_clk),
        .CE(push),
        .D(awlen_tmp[0]),
        .Q(\could_multi_bursts.awlen_buf_reg[3]_0 [0]),
        .R(SR));
  FDRE \could_multi_bursts.awlen_buf_reg[1] 
       (.C(ap_clk),
        .CE(push),
        .D(awlen_tmp[1]),
        .Q(\could_multi_bursts.awlen_buf_reg[3]_0 [1]),
        .R(SR));
  FDRE \could_multi_bursts.awlen_buf_reg[2] 
       (.C(ap_clk),
        .CE(push),
        .D(awlen_tmp[2]),
        .Q(\could_multi_bursts.awlen_buf_reg[3]_0 [2]),
        .R(SR));
  FDRE \could_multi_bursts.awlen_buf_reg[3] 
       (.C(ap_clk),
        .CE(push),
        .D(awlen_tmp[3]),
        .Q(\could_multi_bursts.awlen_buf_reg[3]_0 [3]),
        .R(SR));
  FDRE \could_multi_bursts.last_sect_buf_reg 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\bus_equal_gen.fifo_burst_n_36 ),
        .Q(\could_multi_bursts.last_sect_buf_reg_n_2 ),
        .R(SR));
  LUT1 #(
    .INIT(2'h1)) 
    \could_multi_bursts.loop_cnt[0]_i_1 
       (.I0(\could_multi_bursts.loop_cnt_reg__0 [0]),
        .O(p_0_in__0[0]));
  (* SOFT_HLUTNM = "soft_lutpair200" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \could_multi_bursts.loop_cnt[1]_i_1 
       (.I0(\could_multi_bursts.loop_cnt_reg__0 [1]),
        .I1(\could_multi_bursts.loop_cnt_reg__0 [0]),
        .O(p_0_in__0[1]));
  (* SOFT_HLUTNM = "soft_lutpair200" *) 
  LUT3 #(
    .INIT(8'h6A)) 
    \could_multi_bursts.loop_cnt[2]_i_1 
       (.I0(\could_multi_bursts.loop_cnt_reg__0 [2]),
        .I1(\could_multi_bursts.loop_cnt_reg__0 [0]),
        .I2(\could_multi_bursts.loop_cnt_reg__0 [1]),
        .O(p_0_in__0[2]));
  (* SOFT_HLUTNM = "soft_lutpair173" *) 
  LUT4 #(
    .INIT(16'h6AAA)) 
    \could_multi_bursts.loop_cnt[3]_i_1 
       (.I0(\could_multi_bursts.loop_cnt_reg__0 [3]),
        .I1(\could_multi_bursts.loop_cnt_reg__0 [1]),
        .I2(\could_multi_bursts.loop_cnt_reg__0 [0]),
        .I3(\could_multi_bursts.loop_cnt_reg__0 [2]),
        .O(p_0_in__0[3]));
  (* SOFT_HLUTNM = "soft_lutpair173" *) 
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    \could_multi_bursts.loop_cnt[4]_i_1 
       (.I0(\could_multi_bursts.loop_cnt_reg__0 [4]),
        .I1(\could_multi_bursts.loop_cnt_reg__0 [2]),
        .I2(\could_multi_bursts.loop_cnt_reg__0 [0]),
        .I3(\could_multi_bursts.loop_cnt_reg__0 [1]),
        .I4(\could_multi_bursts.loop_cnt_reg__0 [3]),
        .O(p_0_in__0[4]));
  LUT6 #(
    .INIT(64'h6AAAAAAAAAAAAAAA)) 
    \could_multi_bursts.loop_cnt[5]_i_2 
       (.I0(\could_multi_bursts.loop_cnt_reg__0 [5]),
        .I1(\could_multi_bursts.loop_cnt_reg__0 [3]),
        .I2(\could_multi_bursts.loop_cnt_reg__0 [1]),
        .I3(\could_multi_bursts.loop_cnt_reg__0 [0]),
        .I4(\could_multi_bursts.loop_cnt_reg__0 [2]),
        .I5(\could_multi_bursts.loop_cnt_reg__0 [4]),
        .O(p_0_in__0[5]));
  FDRE \could_multi_bursts.loop_cnt_reg[0] 
       (.C(ap_clk),
        .CE(push),
        .D(p_0_in__0[0]),
        .Q(\could_multi_bursts.loop_cnt_reg__0 [0]),
        .R(\bus_equal_gen.fifo_burst_n_37 ));
  FDRE \could_multi_bursts.loop_cnt_reg[1] 
       (.C(ap_clk),
        .CE(push),
        .D(p_0_in__0[1]),
        .Q(\could_multi_bursts.loop_cnt_reg__0 [1]),
        .R(\bus_equal_gen.fifo_burst_n_37 ));
  FDRE \could_multi_bursts.loop_cnt_reg[2] 
       (.C(ap_clk),
        .CE(push),
        .D(p_0_in__0[2]),
        .Q(\could_multi_bursts.loop_cnt_reg__0 [2]),
        .R(\bus_equal_gen.fifo_burst_n_37 ));
  FDRE \could_multi_bursts.loop_cnt_reg[3] 
       (.C(ap_clk),
        .CE(push),
        .D(p_0_in__0[3]),
        .Q(\could_multi_bursts.loop_cnt_reg__0 [3]),
        .R(\bus_equal_gen.fifo_burst_n_37 ));
  FDRE \could_multi_bursts.loop_cnt_reg[4] 
       (.C(ap_clk),
        .CE(push),
        .D(p_0_in__0[4]),
        .Q(\could_multi_bursts.loop_cnt_reg__0 [4]),
        .R(\bus_equal_gen.fifo_burst_n_37 ));
  FDRE \could_multi_bursts.loop_cnt_reg[5] 
       (.C(ap_clk),
        .CE(push),
        .D(p_0_in__0[5]),
        .Q(\could_multi_bursts.loop_cnt_reg__0 [5]),
        .R(\bus_equal_gen.fifo_burst_n_37 ));
  FDRE \could_multi_bursts.sect_handling_reg 
       (.C(ap_clk),
        .CE(1'b1),
        .D(\bus_equal_gen.fifo_burst_n_34 ),
        .Q(\could_multi_bursts.sect_handling_reg_n_2 ),
        .R(SR));
  LUT2 #(
    .INIT(4'h6)) 
    \end_addr_buf[2]_i_1 
       (.I0(\start_addr_reg_n_2_[2] ),
        .I1(\align_len_reg_n_2_[2] ),
        .O(end_addr[2]));
  FDRE \end_addr_buf_reg[10] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(end_addr[10]),
        .Q(\end_addr_buf_reg_n_2_[10] ),
        .R(SR));
  FDRE \end_addr_buf_reg[11] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(end_addr[11]),
        .Q(\end_addr_buf_reg_n_2_[11] ),
        .R(SR));
  FDRE \end_addr_buf_reg[12] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(end_addr[12]),
        .Q(p_0_in0_in[0]),
        .R(SR));
  FDRE \end_addr_buf_reg[13] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(end_addr[13]),
        .Q(p_0_in0_in[1]),
        .R(SR));
  FDRE \end_addr_buf_reg[14] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(end_addr[14]),
        .Q(p_0_in0_in[2]),
        .R(SR));
  FDRE \end_addr_buf_reg[15] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(end_addr[15]),
        .Q(p_0_in0_in[3]),
        .R(SR));
  FDRE \end_addr_buf_reg[16] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(end_addr[16]),
        .Q(p_0_in0_in[4]),
        .R(SR));
  FDRE \end_addr_buf_reg[17] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(end_addr[17]),
        .Q(p_0_in0_in[5]),
        .R(SR));
  FDRE \end_addr_buf_reg[18] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(end_addr[18]),
        .Q(p_0_in0_in[6]),
        .R(SR));
  FDRE \end_addr_buf_reg[19] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(end_addr[19]),
        .Q(p_0_in0_in[7]),
        .R(SR));
  FDRE \end_addr_buf_reg[20] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(end_addr[20]),
        .Q(p_0_in0_in[8]),
        .R(SR));
  FDRE \end_addr_buf_reg[21] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(end_addr[21]),
        .Q(p_0_in0_in[9]),
        .R(SR));
  FDRE \end_addr_buf_reg[22] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(end_addr[22]),
        .Q(p_0_in0_in[10]),
        .R(SR));
  FDRE \end_addr_buf_reg[23] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(end_addr[23]),
        .Q(p_0_in0_in[11]),
        .R(SR));
  FDRE \end_addr_buf_reg[24] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(end_addr[24]),
        .Q(p_0_in0_in[12]),
        .R(SR));
  FDRE \end_addr_buf_reg[25] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(end_addr[25]),
        .Q(p_0_in0_in[13]),
        .R(SR));
  FDRE \end_addr_buf_reg[26] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(end_addr[26]),
        .Q(p_0_in0_in[14]),
        .R(SR));
  FDRE \end_addr_buf_reg[27] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(end_addr[27]),
        .Q(p_0_in0_in[15]),
        .R(SR));
  FDRE \end_addr_buf_reg[28] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(end_addr[28]),
        .Q(p_0_in0_in[16]),
        .R(SR));
  FDRE \end_addr_buf_reg[29] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(end_addr[29]),
        .Q(p_0_in0_in[17]),
        .R(SR));
  FDRE \end_addr_buf_reg[2] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(end_addr[2]),
        .Q(\end_addr_buf_reg_n_2_[2] ),
        .R(SR));
  FDRE \end_addr_buf_reg[30] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(end_addr[30]),
        .Q(p_0_in0_in[18]),
        .R(SR));
  FDRE \end_addr_buf_reg[31] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(end_addr[31]),
        .Q(p_0_in0_in[19]),
        .R(SR));
  FDRE \end_addr_buf_reg[3] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(end_addr[3]),
        .Q(\end_addr_buf_reg_n_2_[3] ),
        .R(SR));
  FDRE \end_addr_buf_reg[4] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(end_addr[4]),
        .Q(\end_addr_buf_reg_n_2_[4] ),
        .R(SR));
  FDRE \end_addr_buf_reg[5] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(end_addr[5]),
        .Q(\end_addr_buf_reg_n_2_[5] ),
        .R(SR));
  FDRE \end_addr_buf_reg[6] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(end_addr[6]),
        .Q(\end_addr_buf_reg_n_2_[6] ),
        .R(SR));
  FDRE \end_addr_buf_reg[7] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(end_addr[7]),
        .Q(\end_addr_buf_reg_n_2_[7] ),
        .R(SR));
  FDRE \end_addr_buf_reg[8] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(end_addr[8]),
        .Q(\end_addr_buf_reg_n_2_[8] ),
        .R(SR));
  FDRE \end_addr_buf_reg[9] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(end_addr[9]),
        .Q(\end_addr_buf_reg_n_2_[9] ),
        .R(SR));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 end_addr_carry
       (.CI(1'b0),
        .CO({end_addr_carry_n_2,end_addr_carry_n_3,end_addr_carry_n_4,end_addr_carry_n_5}),
        .CYINIT(1'b0),
        .DI({\start_addr_reg_n_2_[5] ,\start_addr_reg_n_2_[4] ,\start_addr_reg_n_2_[3] ,\start_addr_reg_n_2_[2] }),
        .O({end_addr[5:3],NLW_end_addr_carry_O_UNCONNECTED[0]}),
        .S({end_addr_carry_i_1_n_2,end_addr_carry_i_2_n_2,end_addr_carry_i_3_n_2,end_addr_carry_i_4_n_2}));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 end_addr_carry__0
       (.CI(end_addr_carry_n_2),
        .CO({end_addr_carry__0_n_2,end_addr_carry__0_n_3,end_addr_carry__0_n_4,end_addr_carry__0_n_5}),
        .CYINIT(1'b0),
        .DI({\start_addr_reg_n_2_[9] ,\start_addr_reg_n_2_[8] ,\start_addr_reg_n_2_[7] ,\start_addr_reg_n_2_[6] }),
        .O(end_addr[9:6]),
        .S({end_addr_carry__0_i_1_n_2,end_addr_carry__0_i_2_n_2,end_addr_carry__0_i_3_n_2,end_addr_carry__0_i_4_n_2}));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__0_i_1
       (.I0(\start_addr_reg_n_2_[9] ),
        .I1(\align_len_reg_n_2_[31] ),
        .O(end_addr_carry__0_i_1_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__0_i_2
       (.I0(\start_addr_reg_n_2_[8] ),
        .I1(\align_len_reg_n_2_[31] ),
        .O(end_addr_carry__0_i_2_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__0_i_3
       (.I0(\start_addr_reg_n_2_[7] ),
        .I1(\align_len_reg_n_2_[31] ),
        .O(end_addr_carry__0_i_3_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__0_i_4
       (.I0(\start_addr_reg_n_2_[6] ),
        .I1(\align_len_reg_n_2_[31] ),
        .O(end_addr_carry__0_i_4_n_2));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 end_addr_carry__1
       (.CI(end_addr_carry__0_n_2),
        .CO({end_addr_carry__1_n_2,end_addr_carry__1_n_3,end_addr_carry__1_n_4,end_addr_carry__1_n_5}),
        .CYINIT(1'b0),
        .DI({\start_addr_reg_n_2_[13] ,\start_addr_reg_n_2_[12] ,\start_addr_reg_n_2_[11] ,\start_addr_reg_n_2_[10] }),
        .O(end_addr[13:10]),
        .S({end_addr_carry__1_i_1_n_2,end_addr_carry__1_i_2_n_2,end_addr_carry__1_i_3_n_2,end_addr_carry__1_i_4_n_2}));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__1_i_1
       (.I0(\start_addr_reg_n_2_[13] ),
        .I1(\align_len_reg_n_2_[31] ),
        .O(end_addr_carry__1_i_1_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__1_i_2
       (.I0(\start_addr_reg_n_2_[12] ),
        .I1(\align_len_reg_n_2_[31] ),
        .O(end_addr_carry__1_i_2_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__1_i_3
       (.I0(\start_addr_reg_n_2_[11] ),
        .I1(\align_len_reg_n_2_[31] ),
        .O(end_addr_carry__1_i_3_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__1_i_4
       (.I0(\start_addr_reg_n_2_[10] ),
        .I1(\align_len_reg_n_2_[31] ),
        .O(end_addr_carry__1_i_4_n_2));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 end_addr_carry__2
       (.CI(end_addr_carry__1_n_2),
        .CO({end_addr_carry__2_n_2,end_addr_carry__2_n_3,end_addr_carry__2_n_4,end_addr_carry__2_n_5}),
        .CYINIT(1'b0),
        .DI({\start_addr_reg_n_2_[17] ,\start_addr_reg_n_2_[16] ,\start_addr_reg_n_2_[15] ,\start_addr_reg_n_2_[14] }),
        .O(end_addr[17:14]),
        .S({end_addr_carry__2_i_1_n_2,end_addr_carry__2_i_2_n_2,end_addr_carry__2_i_3_n_2,end_addr_carry__2_i_4_n_2}));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__2_i_1
       (.I0(\start_addr_reg_n_2_[17] ),
        .I1(\align_len_reg_n_2_[31] ),
        .O(end_addr_carry__2_i_1_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__2_i_2
       (.I0(\start_addr_reg_n_2_[16] ),
        .I1(\align_len_reg_n_2_[31] ),
        .O(end_addr_carry__2_i_2_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__2_i_3
       (.I0(\start_addr_reg_n_2_[15] ),
        .I1(\align_len_reg_n_2_[31] ),
        .O(end_addr_carry__2_i_3_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__2_i_4
       (.I0(\start_addr_reg_n_2_[14] ),
        .I1(\align_len_reg_n_2_[31] ),
        .O(end_addr_carry__2_i_4_n_2));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 end_addr_carry__3
       (.CI(end_addr_carry__2_n_2),
        .CO({end_addr_carry__3_n_2,end_addr_carry__3_n_3,end_addr_carry__3_n_4,end_addr_carry__3_n_5}),
        .CYINIT(1'b0),
        .DI({\start_addr_reg_n_2_[21] ,\start_addr_reg_n_2_[20] ,\start_addr_reg_n_2_[19] ,\start_addr_reg_n_2_[18] }),
        .O(end_addr[21:18]),
        .S({end_addr_carry__3_i_1_n_2,end_addr_carry__3_i_2_n_2,end_addr_carry__3_i_3_n_2,end_addr_carry__3_i_4_n_2}));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__3_i_1
       (.I0(\start_addr_reg_n_2_[21] ),
        .I1(\align_len_reg_n_2_[31] ),
        .O(end_addr_carry__3_i_1_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__3_i_2
       (.I0(\start_addr_reg_n_2_[20] ),
        .I1(\align_len_reg_n_2_[31] ),
        .O(end_addr_carry__3_i_2_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__3_i_3
       (.I0(\start_addr_reg_n_2_[19] ),
        .I1(\align_len_reg_n_2_[31] ),
        .O(end_addr_carry__3_i_3_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__3_i_4
       (.I0(\start_addr_reg_n_2_[18] ),
        .I1(\align_len_reg_n_2_[31] ),
        .O(end_addr_carry__3_i_4_n_2));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 end_addr_carry__4
       (.CI(end_addr_carry__3_n_2),
        .CO({end_addr_carry__4_n_2,end_addr_carry__4_n_3,end_addr_carry__4_n_4,end_addr_carry__4_n_5}),
        .CYINIT(1'b0),
        .DI({\start_addr_reg_n_2_[25] ,\start_addr_reg_n_2_[24] ,\start_addr_reg_n_2_[23] ,\start_addr_reg_n_2_[22] }),
        .O(end_addr[25:22]),
        .S({end_addr_carry__4_i_1_n_2,end_addr_carry__4_i_2_n_2,end_addr_carry__4_i_3_n_2,end_addr_carry__4_i_4_n_2}));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__4_i_1
       (.I0(\start_addr_reg_n_2_[25] ),
        .I1(\align_len_reg_n_2_[31] ),
        .O(end_addr_carry__4_i_1_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__4_i_2
       (.I0(\start_addr_reg_n_2_[24] ),
        .I1(\align_len_reg_n_2_[31] ),
        .O(end_addr_carry__4_i_2_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__4_i_3
       (.I0(\start_addr_reg_n_2_[23] ),
        .I1(\align_len_reg_n_2_[31] ),
        .O(end_addr_carry__4_i_3_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__4_i_4
       (.I0(\start_addr_reg_n_2_[22] ),
        .I1(\align_len_reg_n_2_[31] ),
        .O(end_addr_carry__4_i_4_n_2));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 end_addr_carry__5
       (.CI(end_addr_carry__4_n_2),
        .CO({end_addr_carry__5_n_2,end_addr_carry__5_n_3,end_addr_carry__5_n_4,end_addr_carry__5_n_5}),
        .CYINIT(1'b0),
        .DI({\start_addr_reg_n_2_[29] ,\start_addr_reg_n_2_[28] ,\start_addr_reg_n_2_[27] ,\start_addr_reg_n_2_[26] }),
        .O(end_addr[29:26]),
        .S({end_addr_carry__5_i_1_n_2,end_addr_carry__5_i_2_n_2,end_addr_carry__5_i_3_n_2,end_addr_carry__5_i_4_n_2}));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__5_i_1
       (.I0(\start_addr_reg_n_2_[29] ),
        .I1(\align_len_reg_n_2_[31] ),
        .O(end_addr_carry__5_i_1_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__5_i_2
       (.I0(\start_addr_reg_n_2_[28] ),
        .I1(\align_len_reg_n_2_[31] ),
        .O(end_addr_carry__5_i_2_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__5_i_3
       (.I0(\start_addr_reg_n_2_[27] ),
        .I1(\align_len_reg_n_2_[31] ),
        .O(end_addr_carry__5_i_3_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__5_i_4
       (.I0(\start_addr_reg_n_2_[26] ),
        .I1(\align_len_reg_n_2_[31] ),
        .O(end_addr_carry__5_i_4_n_2));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 end_addr_carry__6
       (.CI(end_addr_carry__5_n_2),
        .CO({NLW_end_addr_carry__6_CO_UNCONNECTED[3:1],end_addr_carry__6_n_5}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,\start_addr_reg_n_2_[30] }),
        .O({NLW_end_addr_carry__6_O_UNCONNECTED[3:2],end_addr[31:30]}),
        .S({1'b0,1'b0,end_addr_carry__6_i_1_n_2,end_addr_carry__6_i_2_n_2}));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__6_i_1
       (.I0(\align_len_reg_n_2_[31] ),
        .I1(\start_addr_reg_n_2_[31] ),
        .O(end_addr_carry__6_i_1_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry__6_i_2
       (.I0(\start_addr_reg_n_2_[30] ),
        .I1(\align_len_reg_n_2_[31] ),
        .O(end_addr_carry__6_i_2_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry_i_1
       (.I0(\start_addr_reg_n_2_[5] ),
        .I1(\align_len_reg_n_2_[31] ),
        .O(end_addr_carry_i_1_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry_i_2
       (.I0(\start_addr_reg_n_2_[4] ),
        .I1(\align_len_reg_n_2_[31] ),
        .O(end_addr_carry_i_2_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry_i_3
       (.I0(\start_addr_reg_n_2_[3] ),
        .I1(\align_len_reg_n_2_[3] ),
        .O(end_addr_carry_i_3_n_2));
  LUT2 #(
    .INIT(4'h6)) 
    end_addr_carry_i_4
       (.I0(\start_addr_reg_n_2_[2] ),
        .I1(\align_len_reg_n_2_[2] ),
        .O(end_addr_carry_i_4_n_2));
  design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo__parameterized1 fifo_resp
       (.SR(SR),
        .ap_clk(ap_clk),
        .ap_rst_n(ap_rst_n),
        .fifo_resp_ready(fifo_resp_ready),
        .in(invalid_len_event_reg2),
        .m_axi_gmem_BVALID(m_axi_gmem_BVALID),
        .next_resp(next_resp),
        .next_resp0(next_resp0),
        .next_resp_reg(full_n_reg),
        .push(push_0),
        .push_0(push),
        .\q_reg[1]_0 (\could_multi_bursts.last_sect_buf_reg_n_2 ),
        .\q_reg[1]_1 (\bus_equal_gen.fifo_burst_n_28 ));
  design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo__parameterized2 fifo_resp_to_user
       (.Q({Q[6:5],Q[0]}),
        .SR(SR),
        .\ap_CS_fsm_reg[15] ({\ap_CS_fsm_reg[15] [5],\ap_CS_fsm_reg[15] [0]}),
        .ap_clk(ap_clk),
        .ap_done(ap_done),
        .ap_rst_n(ap_rst_n),
        .ap_start(ap_start),
        .empty_n_reg_0(empty_n_reg),
        .full_n_reg_0(full_n_reg),
        .push(push_0));
  design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo__parameterized0 fifo_wreq
       (.CO(last_sect),
        .E(pop0),
        .Q(rs2f_wreq_valid),
        .S({fifo_wreq_n_38,fifo_wreq_n_39,fifo_wreq_n_40,fifo_wreq_n_41}),
        .SR(SR),
        .\align_len_reg[31] (wreq_handling_reg_n_2),
        .ap_clk(ap_clk),
        .ap_rst_n(ap_rst_n),
        .empty_n_reg_0(align_len0_0),
        .empty_n_reg_1(fifo_wreq_n_5),
        .empty_n_reg_2(fifo_wreq_n_6),
        .empty_n_reg_3(fifo_wreq_n_46),
        .fifo_wreq_valid(fifo_wreq_valid),
        .full_n_reg_0(\could_multi_bursts.sect_handling_reg_n_2 ),
        .full_n_reg_1(\bus_equal_gen.fifo_burst_n_28 ),
        .full_n_reg_2(push),
        .last_sect_carry__0(p_0_in0_in),
        .last_sect_carry__0_0(sect_cnt),
        .p_26_in(p_26_in),
        .push(push_1),
        .\q_reg[29]_0 (rs2f_wreq_data),
        .\q_reg[33]_0 ({fifo_wreq_data,fifo_wreq_n_8,fifo_wreq_n_9,fifo_wreq_n_10,fifo_wreq_n_11,fifo_wreq_n_12,fifo_wreq_n_13,fifo_wreq_n_14,fifo_wreq_n_15,fifo_wreq_n_16,fifo_wreq_n_17,fifo_wreq_n_18,fifo_wreq_n_19,fifo_wreq_n_20,fifo_wreq_n_21,fifo_wreq_n_22,fifo_wreq_n_23,fifo_wreq_n_24,fifo_wreq_n_25,fifo_wreq_n_26,fifo_wreq_n_27,fifo_wreq_n_28,fifo_wreq_n_29,fifo_wreq_n_30,fifo_wreq_n_31,fifo_wreq_n_32,fifo_wreq_n_33,fifo_wreq_n_34,fifo_wreq_n_35,fifo_wreq_n_36,fifo_wreq_n_37}),
        .\q_reg[33]_1 (zero_len_event0),
        .\q_reg[33]_2 (fifo_wreq_n_47),
        .rs2f_wreq_ack(rs2f_wreq_ack),
        .\sect_cnt_reg[0] (fifo_wreq_valid_buf_reg_n_2),
        .\sect_cnt_reg[19] ({fifo_wreq_n_42,fifo_wreq_n_43,fifo_wreq_n_44}));
  FDRE fifo_wreq_valid_buf_reg
       (.C(ap_clk),
        .CE(next_wreq),
        .D(fifo_wreq_valid),
        .Q(fifo_wreq_valid_buf_reg_n_2),
        .R(SR));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 first_sect_carry
       (.CI(1'b0),
        .CO({first_sect_carry_n_2,first_sect_carry_n_3,first_sect_carry_n_4,first_sect_carry_n_5}),
        .CYINIT(1'b1),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_first_sect_carry_O_UNCONNECTED[3:0]),
        .S({first_sect_carry_i_1_n_2,first_sect_carry_i_2_n_2,first_sect_carry_i_3_n_2,first_sect_carry_i_4_n_2}));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 first_sect_carry__0
       (.CI(first_sect_carry_n_2),
        .CO({NLW_first_sect_carry__0_CO_UNCONNECTED[3],first_sect,first_sect_carry__0_n_4,first_sect_carry__0_n_5}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_first_sect_carry__0_O_UNCONNECTED[3:0]),
        .S({1'b0,first_sect_carry__0_i_1_n_2,first_sect_carry__0_i_2_n_2,first_sect_carry__0_i_3_n_2}));
  LUT4 #(
    .INIT(16'h9009)) 
    first_sect_carry__0_i_1
       (.I0(start_addr_buf[31]),
        .I1(sect_cnt[19]),
        .I2(start_addr_buf[30]),
        .I3(sect_cnt[18]),
        .O(first_sect_carry__0_i_1_n_2));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    first_sect_carry__0_i_2
       (.I0(sect_cnt[15]),
        .I1(start_addr_buf[27]),
        .I2(sect_cnt[16]),
        .I3(start_addr_buf[28]),
        .I4(start_addr_buf[29]),
        .I5(sect_cnt[17]),
        .O(first_sect_carry__0_i_2_n_2));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    first_sect_carry__0_i_3
       (.I0(start_addr_buf[26]),
        .I1(sect_cnt[14]),
        .I2(sect_cnt[12]),
        .I3(start_addr_buf[24]),
        .I4(sect_cnt[13]),
        .I5(start_addr_buf[25]),
        .O(first_sect_carry__0_i_3_n_2));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    first_sect_carry_i_1
       (.I0(start_addr_buf[23]),
        .I1(sect_cnt[11]),
        .I2(sect_cnt[9]),
        .I3(start_addr_buf[21]),
        .I4(sect_cnt[10]),
        .I5(start_addr_buf[22]),
        .O(first_sect_carry_i_1_n_2));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    first_sect_carry_i_2
       (.I0(sect_cnt[6]),
        .I1(start_addr_buf[18]),
        .I2(sect_cnt[7]),
        .I3(start_addr_buf[19]),
        .I4(start_addr_buf[20]),
        .I5(sect_cnt[8]),
        .O(first_sect_carry_i_2_n_2));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    first_sect_carry_i_3
       (.I0(start_addr_buf[17]),
        .I1(sect_cnt[5]),
        .I2(sect_cnt[3]),
        .I3(start_addr_buf[15]),
        .I4(sect_cnt[4]),
        .I5(start_addr_buf[16]),
        .O(first_sect_carry_i_3_n_2));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    first_sect_carry_i_4
       (.I0(start_addr_buf[14]),
        .I1(sect_cnt[2]),
        .I2(sect_cnt[0]),
        .I3(start_addr_buf[12]),
        .I4(sect_cnt[1]),
        .I5(start_addr_buf[13]),
        .O(first_sect_carry_i_4_n_2));
  FDRE invalid_len_event_reg
       (.C(ap_clk),
        .CE(next_wreq),
        .D(fifo_wreq_n_6),
        .Q(invalid_len_event),
        .R(SR));
  FDRE invalid_len_event_reg1_reg
       (.C(ap_clk),
        .CE(next_wreq),
        .D(invalid_len_event),
        .Q(invalid_len_event_reg1),
        .R(SR));
  FDRE invalid_len_event_reg2_reg
       (.C(ap_clk),
        .CE(p_26_in),
        .D(invalid_len_event_reg1),
        .Q(invalid_len_event_reg2),
        .R(SR));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 last_sect_carry
       (.CI(1'b0),
        .CO({last_sect_carry_n_2,last_sect_carry_n_3,last_sect_carry_n_4,last_sect_carry_n_5}),
        .CYINIT(1'b1),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_last_sect_carry_O_UNCONNECTED[3:0]),
        .S({fifo_wreq_n_38,fifo_wreq_n_39,fifo_wreq_n_40,fifo_wreq_n_41}));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 last_sect_carry__0
       (.CI(last_sect_carry_n_2),
        .CO({NLW_last_sect_carry__0_CO_UNCONNECTED[3],last_sect,last_sect_carry__0_n_4,last_sect_carry__0_n_5}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_last_sect_carry__0_O_UNCONNECTED[3:0]),
        .S({1'b0,fifo_wreq_n_42,fifo_wreq_n_43,fifo_wreq_n_44}));
  FDRE next_resp_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(next_resp0),
        .Q(next_resp),
        .R(SR));
  design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_reg_slice rs_wreq
       (.Q(Q[3:1]),
        .SR(SR),
        .\ap_CS_fsm_reg[9] (\ap_CS_fsm_reg[9] ),
        .ap_clk(ap_clk),
        .ap_reg_ioackin_gmem_WREADY(ap_reg_ioackin_gmem_WREADY),
        .\data_p1_reg[29]_0 (rs2f_wreq_data),
        .\data_p2_reg[29]_0 (\data_p2_reg[29] ),
        .gmem_WREADY(gmem_WREADY),
        .push(push_1),
        .rs2f_wreq_ack(rs2f_wreq_ack),
        .s_ready_t_reg_0(\ap_CS_fsm_reg[15] [2:1]),
        .\state_reg[0]_0 (rs2f_wreq_valid));
  (* SOFT_HLUTNM = "soft_lutpair204" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sect_addr_buf[10]_i_1 
       (.I0(first_sect),
        .I1(start_addr_buf[10]),
        .O(sect_addr[10]));
  (* SOFT_HLUTNM = "soft_lutpair203" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sect_addr_buf[11]_i_2 
       (.I0(first_sect),
        .I1(start_addr_buf[11]),
        .O(sect_addr[11]));
  (* SOFT_HLUTNM = "soft_lutpair196" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[12]_i_1 
       (.I0(start_addr_buf[12]),
        .I1(first_sect),
        .I2(sect_cnt[0]),
        .O(sect_addr[12]));
  (* SOFT_HLUTNM = "soft_lutpair196" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[13]_i_1 
       (.I0(start_addr_buf[13]),
        .I1(first_sect),
        .I2(sect_cnt[1]),
        .O(sect_addr[13]));
  (* SOFT_HLUTNM = "soft_lutpair195" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[14]_i_1 
       (.I0(start_addr_buf[14]),
        .I1(first_sect),
        .I2(sect_cnt[2]),
        .O(sect_addr[14]));
  (* SOFT_HLUTNM = "soft_lutpair195" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[15]_i_1 
       (.I0(start_addr_buf[15]),
        .I1(first_sect),
        .I2(sect_cnt[3]),
        .O(sect_addr[15]));
  (* SOFT_HLUTNM = "soft_lutpair194" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[16]_i_1 
       (.I0(start_addr_buf[16]),
        .I1(first_sect),
        .I2(sect_cnt[4]),
        .O(sect_addr[16]));
  (* SOFT_HLUTNM = "soft_lutpair194" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[17]_i_1 
       (.I0(start_addr_buf[17]),
        .I1(first_sect),
        .I2(sect_cnt[5]),
        .O(sect_addr[17]));
  (* SOFT_HLUTNM = "soft_lutpair193" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[18]_i_1 
       (.I0(start_addr_buf[18]),
        .I1(first_sect),
        .I2(sect_cnt[6]),
        .O(sect_addr[18]));
  (* SOFT_HLUTNM = "soft_lutpair193" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[19]_i_1 
       (.I0(start_addr_buf[19]),
        .I1(first_sect),
        .I2(sect_cnt[7]),
        .O(sect_addr[19]));
  (* SOFT_HLUTNM = "soft_lutpair192" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[20]_i_1 
       (.I0(start_addr_buf[20]),
        .I1(first_sect),
        .I2(sect_cnt[8]),
        .O(sect_addr[20]));
  (* SOFT_HLUTNM = "soft_lutpair192" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[21]_i_1 
       (.I0(start_addr_buf[21]),
        .I1(first_sect),
        .I2(sect_cnt[9]),
        .O(sect_addr[21]));
  (* SOFT_HLUTNM = "soft_lutpair191" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[22]_i_1 
       (.I0(start_addr_buf[22]),
        .I1(first_sect),
        .I2(sect_cnt[10]),
        .O(sect_addr[22]));
  (* SOFT_HLUTNM = "soft_lutpair191" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[23]_i_1 
       (.I0(start_addr_buf[23]),
        .I1(first_sect),
        .I2(sect_cnt[11]),
        .O(sect_addr[23]));
  (* SOFT_HLUTNM = "soft_lutpair190" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[24]_i_1 
       (.I0(start_addr_buf[24]),
        .I1(first_sect),
        .I2(sect_cnt[12]),
        .O(sect_addr[24]));
  (* SOFT_HLUTNM = "soft_lutpair190" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[25]_i_1 
       (.I0(start_addr_buf[25]),
        .I1(first_sect),
        .I2(sect_cnt[13]),
        .O(sect_addr[25]));
  (* SOFT_HLUTNM = "soft_lutpair189" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[26]_i_1 
       (.I0(start_addr_buf[26]),
        .I1(first_sect),
        .I2(sect_cnt[14]),
        .O(sect_addr[26]));
  (* SOFT_HLUTNM = "soft_lutpair188" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[27]_i_1 
       (.I0(start_addr_buf[27]),
        .I1(first_sect),
        .I2(sect_cnt[15]),
        .O(sect_addr[27]));
  (* SOFT_HLUTNM = "soft_lutpair189" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[28]_i_1 
       (.I0(start_addr_buf[28]),
        .I1(first_sect),
        .I2(sect_cnt[16]),
        .O(sect_addr[28]));
  (* SOFT_HLUTNM = "soft_lutpair186" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[29]_i_1 
       (.I0(start_addr_buf[29]),
        .I1(first_sect),
        .I2(sect_cnt[17]),
        .O(sect_addr[29]));
  (* SOFT_HLUTNM = "soft_lutpair203" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sect_addr_buf[2]_i_1 
       (.I0(first_sect),
        .I1(start_addr_buf[2]),
        .O(sect_addr[2]));
  (* SOFT_HLUTNM = "soft_lutpair188" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[30]_i_1 
       (.I0(start_addr_buf[30]),
        .I1(first_sect),
        .I2(sect_cnt[18]),
        .O(sect_addr[30]));
  (* SOFT_HLUTNM = "soft_lutpair186" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sect_addr_buf[31]_i_1 
       (.I0(start_addr_buf[31]),
        .I1(first_sect),
        .I2(sect_cnt[19]),
        .O(sect_addr[31]));
  (* SOFT_HLUTNM = "soft_lutpair204" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sect_addr_buf[3]_i_1 
       (.I0(first_sect),
        .I1(start_addr_buf[3]),
        .O(sect_addr[3]));
  (* SOFT_HLUTNM = "soft_lutpair206" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sect_addr_buf[4]_i_1 
       (.I0(first_sect),
        .I1(start_addr_buf[4]),
        .O(sect_addr[4]));
  (* SOFT_HLUTNM = "soft_lutpair205" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sect_addr_buf[5]_i_1 
       (.I0(first_sect),
        .I1(start_addr_buf[5]),
        .O(sect_addr[5]));
  (* SOFT_HLUTNM = "soft_lutpair207" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sect_addr_buf[6]_i_1 
       (.I0(first_sect),
        .I1(start_addr_buf[6]),
        .O(sect_addr[6]));
  (* SOFT_HLUTNM = "soft_lutpair207" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sect_addr_buf[7]_i_1 
       (.I0(first_sect),
        .I1(start_addr_buf[7]),
        .O(sect_addr[7]));
  (* SOFT_HLUTNM = "soft_lutpair206" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sect_addr_buf[8]_i_1 
       (.I0(first_sect),
        .I1(start_addr_buf[8]),
        .O(sect_addr[8]));
  (* SOFT_HLUTNM = "soft_lutpair205" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sect_addr_buf[9]_i_1 
       (.I0(first_sect),
        .I1(start_addr_buf[9]),
        .O(sect_addr[9]));
  FDRE \sect_addr_buf_reg[10] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(sect_addr[10]),
        .Q(\sect_addr_buf_reg_n_2_[10] ),
        .R(\bus_equal_gen.fifo_burst_n_38 ));
  FDRE \sect_addr_buf_reg[11] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(sect_addr[11]),
        .Q(\sect_addr_buf_reg_n_2_[11] ),
        .R(\bus_equal_gen.fifo_burst_n_38 ));
  FDRE \sect_addr_buf_reg[12] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(sect_addr[12]),
        .Q(\sect_addr_buf_reg_n_2_[12] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[13] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(sect_addr[13]),
        .Q(\sect_addr_buf_reg_n_2_[13] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[14] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(sect_addr[14]),
        .Q(\sect_addr_buf_reg_n_2_[14] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[15] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(sect_addr[15]),
        .Q(\sect_addr_buf_reg_n_2_[15] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[16] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(sect_addr[16]),
        .Q(\sect_addr_buf_reg_n_2_[16] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[17] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(sect_addr[17]),
        .Q(\sect_addr_buf_reg_n_2_[17] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[18] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(sect_addr[18]),
        .Q(\sect_addr_buf_reg_n_2_[18] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[19] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(sect_addr[19]),
        .Q(\sect_addr_buf_reg_n_2_[19] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[20] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(sect_addr[20]),
        .Q(\sect_addr_buf_reg_n_2_[20] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[21] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(sect_addr[21]),
        .Q(\sect_addr_buf_reg_n_2_[21] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[22] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(sect_addr[22]),
        .Q(\sect_addr_buf_reg_n_2_[22] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[23] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(sect_addr[23]),
        .Q(\sect_addr_buf_reg_n_2_[23] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[24] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(sect_addr[24]),
        .Q(\sect_addr_buf_reg_n_2_[24] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[25] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(sect_addr[25]),
        .Q(\sect_addr_buf_reg_n_2_[25] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[26] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(sect_addr[26]),
        .Q(\sect_addr_buf_reg_n_2_[26] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[27] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(sect_addr[27]),
        .Q(\sect_addr_buf_reg_n_2_[27] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[28] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(sect_addr[28]),
        .Q(\sect_addr_buf_reg_n_2_[28] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[29] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(sect_addr[29]),
        .Q(\sect_addr_buf_reg_n_2_[29] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[2] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(sect_addr[2]),
        .Q(\sect_addr_buf_reg_n_2_[2] ),
        .R(\bus_equal_gen.fifo_burst_n_38 ));
  FDRE \sect_addr_buf_reg[30] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(sect_addr[30]),
        .Q(\sect_addr_buf_reg_n_2_[30] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[31] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(sect_addr[31]),
        .Q(\sect_addr_buf_reg_n_2_[31] ),
        .R(SR));
  FDRE \sect_addr_buf_reg[3] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(sect_addr[3]),
        .Q(\sect_addr_buf_reg_n_2_[3] ),
        .R(\bus_equal_gen.fifo_burst_n_38 ));
  FDRE \sect_addr_buf_reg[4] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(sect_addr[4]),
        .Q(\sect_addr_buf_reg_n_2_[4] ),
        .R(\bus_equal_gen.fifo_burst_n_38 ));
  FDRE \sect_addr_buf_reg[5] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(sect_addr[5]),
        .Q(\sect_addr_buf_reg_n_2_[5] ),
        .R(\bus_equal_gen.fifo_burst_n_38 ));
  FDRE \sect_addr_buf_reg[6] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(sect_addr[6]),
        .Q(\sect_addr_buf_reg_n_2_[6] ),
        .R(\bus_equal_gen.fifo_burst_n_38 ));
  FDRE \sect_addr_buf_reg[7] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(sect_addr[7]),
        .Q(\sect_addr_buf_reg_n_2_[7] ),
        .R(\bus_equal_gen.fifo_burst_n_38 ));
  FDRE \sect_addr_buf_reg[8] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(sect_addr[8]),
        .Q(\sect_addr_buf_reg_n_2_[8] ),
        .R(\bus_equal_gen.fifo_burst_n_38 ));
  FDRE \sect_addr_buf_reg[9] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(sect_addr[9]),
        .Q(\sect_addr_buf_reg_n_2_[9] ),
        .R(\bus_equal_gen.fifo_burst_n_38 ));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 sect_cnt0_carry
       (.CI(1'b0),
        .CO({sect_cnt0_carry_n_2,sect_cnt0_carry_n_3,sect_cnt0_carry_n_4,sect_cnt0_carry_n_5}),
        .CYINIT(sect_cnt[0]),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(sect_cnt0[4:1]),
        .S(sect_cnt[4:1]));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 sect_cnt0_carry__0
       (.CI(sect_cnt0_carry_n_2),
        .CO({sect_cnt0_carry__0_n_2,sect_cnt0_carry__0_n_3,sect_cnt0_carry__0_n_4,sect_cnt0_carry__0_n_5}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(sect_cnt0[8:5]),
        .S(sect_cnt[8:5]));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 sect_cnt0_carry__1
       (.CI(sect_cnt0_carry__0_n_2),
        .CO({sect_cnt0_carry__1_n_2,sect_cnt0_carry__1_n_3,sect_cnt0_carry__1_n_4,sect_cnt0_carry__1_n_5}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(sect_cnt0[12:9]),
        .S(sect_cnt[12:9]));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 sect_cnt0_carry__2
       (.CI(sect_cnt0_carry__1_n_2),
        .CO({sect_cnt0_carry__2_n_2,sect_cnt0_carry__2_n_3,sect_cnt0_carry__2_n_4,sect_cnt0_carry__2_n_5}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(sect_cnt0[16:13]),
        .S(sect_cnt[16:13]));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 sect_cnt0_carry__3
       (.CI(sect_cnt0_carry__2_n_2),
        .CO({NLW_sect_cnt0_carry__3_CO_UNCONNECTED[3:2],sect_cnt0_carry__3_n_4,sect_cnt0_carry__3_n_5}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({NLW_sect_cnt0_carry__3_O_UNCONNECTED[3],sect_cnt0[19:17]}),
        .S({1'b0,sect_cnt[19:17]}));
  FDRE \sect_cnt_reg[0] 
       (.C(ap_clk),
        .CE(fifo_wreq_n_46),
        .D(\bus_equal_gen.fifo_burst_n_26 ),
        .Q(sect_cnt[0]),
        .R(SR));
  FDRE \sect_cnt_reg[10] 
       (.C(ap_clk),
        .CE(fifo_wreq_n_46),
        .D(\bus_equal_gen.fifo_burst_n_16 ),
        .Q(sect_cnt[10]),
        .R(SR));
  FDRE \sect_cnt_reg[11] 
       (.C(ap_clk),
        .CE(fifo_wreq_n_46),
        .D(\bus_equal_gen.fifo_burst_n_15 ),
        .Q(sect_cnt[11]),
        .R(SR));
  FDRE \sect_cnt_reg[12] 
       (.C(ap_clk),
        .CE(fifo_wreq_n_46),
        .D(\bus_equal_gen.fifo_burst_n_14 ),
        .Q(sect_cnt[12]),
        .R(SR));
  FDRE \sect_cnt_reg[13] 
       (.C(ap_clk),
        .CE(fifo_wreq_n_46),
        .D(\bus_equal_gen.fifo_burst_n_13 ),
        .Q(sect_cnt[13]),
        .R(SR));
  FDRE \sect_cnt_reg[14] 
       (.C(ap_clk),
        .CE(fifo_wreq_n_46),
        .D(\bus_equal_gen.fifo_burst_n_12 ),
        .Q(sect_cnt[14]),
        .R(SR));
  FDRE \sect_cnt_reg[15] 
       (.C(ap_clk),
        .CE(fifo_wreq_n_46),
        .D(\bus_equal_gen.fifo_burst_n_11 ),
        .Q(sect_cnt[15]),
        .R(SR));
  FDRE \sect_cnt_reg[16] 
       (.C(ap_clk),
        .CE(fifo_wreq_n_46),
        .D(\bus_equal_gen.fifo_burst_n_10 ),
        .Q(sect_cnt[16]),
        .R(SR));
  FDRE \sect_cnt_reg[17] 
       (.C(ap_clk),
        .CE(fifo_wreq_n_46),
        .D(\bus_equal_gen.fifo_burst_n_9 ),
        .Q(sect_cnt[17]),
        .R(SR));
  FDRE \sect_cnt_reg[18] 
       (.C(ap_clk),
        .CE(fifo_wreq_n_46),
        .D(\bus_equal_gen.fifo_burst_n_8 ),
        .Q(sect_cnt[18]),
        .R(SR));
  FDRE \sect_cnt_reg[19] 
       (.C(ap_clk),
        .CE(fifo_wreq_n_46),
        .D(\bus_equal_gen.fifo_burst_n_7 ),
        .Q(sect_cnt[19]),
        .R(SR));
  FDRE \sect_cnt_reg[1] 
       (.C(ap_clk),
        .CE(fifo_wreq_n_46),
        .D(\bus_equal_gen.fifo_burst_n_25 ),
        .Q(sect_cnt[1]),
        .R(SR));
  FDRE \sect_cnt_reg[2] 
       (.C(ap_clk),
        .CE(fifo_wreq_n_46),
        .D(\bus_equal_gen.fifo_burst_n_24 ),
        .Q(sect_cnt[2]),
        .R(SR));
  FDRE \sect_cnt_reg[3] 
       (.C(ap_clk),
        .CE(fifo_wreq_n_46),
        .D(\bus_equal_gen.fifo_burst_n_23 ),
        .Q(sect_cnt[3]),
        .R(SR));
  FDRE \sect_cnt_reg[4] 
       (.C(ap_clk),
        .CE(fifo_wreq_n_46),
        .D(\bus_equal_gen.fifo_burst_n_22 ),
        .Q(sect_cnt[4]),
        .R(SR));
  FDRE \sect_cnt_reg[5] 
       (.C(ap_clk),
        .CE(fifo_wreq_n_46),
        .D(\bus_equal_gen.fifo_burst_n_21 ),
        .Q(sect_cnt[5]),
        .R(SR));
  FDRE \sect_cnt_reg[6] 
       (.C(ap_clk),
        .CE(fifo_wreq_n_46),
        .D(\bus_equal_gen.fifo_burst_n_20 ),
        .Q(sect_cnt[6]),
        .R(SR));
  FDRE \sect_cnt_reg[7] 
       (.C(ap_clk),
        .CE(fifo_wreq_n_46),
        .D(\bus_equal_gen.fifo_burst_n_19 ),
        .Q(sect_cnt[7]),
        .R(SR));
  FDRE \sect_cnt_reg[8] 
       (.C(ap_clk),
        .CE(fifo_wreq_n_46),
        .D(\bus_equal_gen.fifo_burst_n_18 ),
        .Q(sect_cnt[8]),
        .R(SR));
  FDRE \sect_cnt_reg[9] 
       (.C(ap_clk),
        .CE(fifo_wreq_n_46),
        .D(\bus_equal_gen.fifo_burst_n_17 ),
        .Q(sect_cnt[9]),
        .R(SR));
  LUT5 #(
    .INIT(32'hCC0FAAFF)) 
    \sect_len_buf[0]_i_1 
       (.I0(\end_addr_buf_reg_n_2_[2] ),
        .I1(beat_len_buf[0]),
        .I2(start_addr_buf[2]),
        .I3(last_sect),
        .I4(first_sect),
        .O(\sect_len_buf[0]_i_1_n_2 ));
  LUT5 #(
    .INIT(32'hAA0FCCFF)) 
    \sect_len_buf[1]_i_1 
       (.I0(beat_len_buf[1]),
        .I1(\end_addr_buf_reg_n_2_[3] ),
        .I2(start_addr_buf[3]),
        .I3(last_sect),
        .I4(first_sect),
        .O(\sect_len_buf[1]_i_1_n_2 ));
  LUT5 #(
    .INIT(32'hF033AAFF)) 
    \sect_len_buf[2]_i_1 
       (.I0(\end_addr_buf_reg_n_2_[4] ),
        .I1(start_addr_buf[4]),
        .I2(beat_len_buf[3]),
        .I3(last_sect),
        .I4(first_sect),
        .O(\sect_len_buf[2]_i_1_n_2 ));
  LUT5 #(
    .INIT(32'hF033AAFF)) 
    \sect_len_buf[3]_i_1 
       (.I0(\end_addr_buf_reg_n_2_[5] ),
        .I1(start_addr_buf[5]),
        .I2(beat_len_buf[3]),
        .I3(last_sect),
        .I4(first_sect),
        .O(\sect_len_buf[3]_i_1_n_2 ));
  LUT5 #(
    .INIT(32'hF033AAFF)) 
    \sect_len_buf[4]_i_1 
       (.I0(\end_addr_buf_reg_n_2_[6] ),
        .I1(start_addr_buf[6]),
        .I2(beat_len_buf[3]),
        .I3(last_sect),
        .I4(first_sect),
        .O(\sect_len_buf[4]_i_1_n_2 ));
  LUT5 #(
    .INIT(32'hF033AAFF)) 
    \sect_len_buf[5]_i_1 
       (.I0(\end_addr_buf_reg_n_2_[7] ),
        .I1(start_addr_buf[7]),
        .I2(beat_len_buf[3]),
        .I3(last_sect),
        .I4(first_sect),
        .O(\sect_len_buf[5]_i_1_n_2 ));
  LUT5 #(
    .INIT(32'hF033AAFF)) 
    \sect_len_buf[6]_i_1 
       (.I0(\end_addr_buf_reg_n_2_[8] ),
        .I1(start_addr_buf[8]),
        .I2(beat_len_buf[3]),
        .I3(last_sect),
        .I4(first_sect),
        .O(\sect_len_buf[6]_i_1_n_2 ));
  LUT5 #(
    .INIT(32'hF033AAFF)) 
    \sect_len_buf[7]_i_1 
       (.I0(\end_addr_buf_reg_n_2_[9] ),
        .I1(start_addr_buf[9]),
        .I2(beat_len_buf[3]),
        .I3(last_sect),
        .I4(first_sect),
        .O(\sect_len_buf[7]_i_1_n_2 ));
  LUT5 #(
    .INIT(32'hF033AAFF)) 
    \sect_len_buf[8]_i_1 
       (.I0(\end_addr_buf_reg_n_2_[10] ),
        .I1(start_addr_buf[10]),
        .I2(beat_len_buf[3]),
        .I3(last_sect),
        .I4(first_sect),
        .O(\sect_len_buf[8]_i_1_n_2 ));
  LUT5 #(
    .INIT(32'hAA0FCCFF)) 
    \sect_len_buf[9]_i_2 
       (.I0(beat_len_buf[3]),
        .I1(\end_addr_buf_reg_n_2_[11] ),
        .I2(start_addr_buf[11]),
        .I3(last_sect),
        .I4(first_sect),
        .O(\sect_len_buf[9]_i_2_n_2 ));
  FDRE \sect_len_buf_reg[0] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(\sect_len_buf[0]_i_1_n_2 ),
        .Q(\sect_len_buf_reg_n_2_[0] ),
        .R(SR));
  FDRE \sect_len_buf_reg[1] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(\sect_len_buf[1]_i_1_n_2 ),
        .Q(\sect_len_buf_reg_n_2_[1] ),
        .R(SR));
  FDRE \sect_len_buf_reg[2] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(\sect_len_buf[2]_i_1_n_2 ),
        .Q(\sect_len_buf_reg_n_2_[2] ),
        .R(SR));
  FDRE \sect_len_buf_reg[3] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(\sect_len_buf[3]_i_1_n_2 ),
        .Q(\sect_len_buf_reg_n_2_[3] ),
        .R(SR));
  FDRE \sect_len_buf_reg[4] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(\sect_len_buf[4]_i_1_n_2 ),
        .Q(sect_len_buf[4]),
        .R(SR));
  FDRE \sect_len_buf_reg[5] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(\sect_len_buf[5]_i_1_n_2 ),
        .Q(sect_len_buf[5]),
        .R(SR));
  FDRE \sect_len_buf_reg[6] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(\sect_len_buf[6]_i_1_n_2 ),
        .Q(sect_len_buf[6]),
        .R(SR));
  FDRE \sect_len_buf_reg[7] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(\sect_len_buf[7]_i_1_n_2 ),
        .Q(sect_len_buf[7]),
        .R(SR));
  FDRE \sect_len_buf_reg[8] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(\sect_len_buf[8]_i_1_n_2 ),
        .Q(sect_len_buf[8]),
        .R(SR));
  FDRE \sect_len_buf_reg[9] 
       (.C(ap_clk),
        .CE(p_26_in),
        .D(\sect_len_buf[9]_i_2_n_2 ),
        .Q(sect_len_buf[9]),
        .R(SR));
  FDRE \start_addr_buf_reg[10] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(\start_addr_reg_n_2_[10] ),
        .Q(start_addr_buf[10]),
        .R(SR));
  FDRE \start_addr_buf_reg[11] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(\start_addr_reg_n_2_[11] ),
        .Q(start_addr_buf[11]),
        .R(SR));
  FDRE \start_addr_buf_reg[12] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(\start_addr_reg_n_2_[12] ),
        .Q(start_addr_buf[12]),
        .R(SR));
  FDRE \start_addr_buf_reg[13] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(\start_addr_reg_n_2_[13] ),
        .Q(start_addr_buf[13]),
        .R(SR));
  FDRE \start_addr_buf_reg[14] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(\start_addr_reg_n_2_[14] ),
        .Q(start_addr_buf[14]),
        .R(SR));
  FDRE \start_addr_buf_reg[15] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(\start_addr_reg_n_2_[15] ),
        .Q(start_addr_buf[15]),
        .R(SR));
  FDRE \start_addr_buf_reg[16] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(\start_addr_reg_n_2_[16] ),
        .Q(start_addr_buf[16]),
        .R(SR));
  FDRE \start_addr_buf_reg[17] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(\start_addr_reg_n_2_[17] ),
        .Q(start_addr_buf[17]),
        .R(SR));
  FDRE \start_addr_buf_reg[18] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(\start_addr_reg_n_2_[18] ),
        .Q(start_addr_buf[18]),
        .R(SR));
  FDRE \start_addr_buf_reg[19] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(\start_addr_reg_n_2_[19] ),
        .Q(start_addr_buf[19]),
        .R(SR));
  FDRE \start_addr_buf_reg[20] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(\start_addr_reg_n_2_[20] ),
        .Q(start_addr_buf[20]),
        .R(SR));
  FDRE \start_addr_buf_reg[21] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(\start_addr_reg_n_2_[21] ),
        .Q(start_addr_buf[21]),
        .R(SR));
  FDRE \start_addr_buf_reg[22] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(\start_addr_reg_n_2_[22] ),
        .Q(start_addr_buf[22]),
        .R(SR));
  FDRE \start_addr_buf_reg[23] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(\start_addr_reg_n_2_[23] ),
        .Q(start_addr_buf[23]),
        .R(SR));
  FDRE \start_addr_buf_reg[24] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(\start_addr_reg_n_2_[24] ),
        .Q(start_addr_buf[24]),
        .R(SR));
  FDRE \start_addr_buf_reg[25] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(\start_addr_reg_n_2_[25] ),
        .Q(start_addr_buf[25]),
        .R(SR));
  FDRE \start_addr_buf_reg[26] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(\start_addr_reg_n_2_[26] ),
        .Q(start_addr_buf[26]),
        .R(SR));
  FDRE \start_addr_buf_reg[27] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(\start_addr_reg_n_2_[27] ),
        .Q(start_addr_buf[27]),
        .R(SR));
  FDRE \start_addr_buf_reg[28] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(\start_addr_reg_n_2_[28] ),
        .Q(start_addr_buf[28]),
        .R(SR));
  FDRE \start_addr_buf_reg[29] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(\start_addr_reg_n_2_[29] ),
        .Q(start_addr_buf[29]),
        .R(SR));
  FDRE \start_addr_buf_reg[2] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(\start_addr_reg_n_2_[2] ),
        .Q(start_addr_buf[2]),
        .R(SR));
  FDRE \start_addr_buf_reg[30] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(\start_addr_reg_n_2_[30] ),
        .Q(start_addr_buf[30]),
        .R(SR));
  FDRE \start_addr_buf_reg[31] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(\start_addr_reg_n_2_[31] ),
        .Q(start_addr_buf[31]),
        .R(SR));
  FDRE \start_addr_buf_reg[3] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(\start_addr_reg_n_2_[3] ),
        .Q(start_addr_buf[3]),
        .R(SR));
  FDRE \start_addr_buf_reg[4] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(\start_addr_reg_n_2_[4] ),
        .Q(start_addr_buf[4]),
        .R(SR));
  FDRE \start_addr_buf_reg[5] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(\start_addr_reg_n_2_[5] ),
        .Q(start_addr_buf[5]),
        .R(SR));
  FDRE \start_addr_buf_reg[6] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(\start_addr_reg_n_2_[6] ),
        .Q(start_addr_buf[6]),
        .R(SR));
  FDRE \start_addr_buf_reg[7] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(\start_addr_reg_n_2_[7] ),
        .Q(start_addr_buf[7]),
        .R(SR));
  FDRE \start_addr_buf_reg[8] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(\start_addr_reg_n_2_[8] ),
        .Q(start_addr_buf[8]),
        .R(SR));
  FDRE \start_addr_buf_reg[9] 
       (.C(ap_clk),
        .CE(next_wreq),
        .D(\start_addr_reg_n_2_[9] ),
        .Q(start_addr_buf[9]),
        .R(SR));
  FDRE \start_addr_reg[10] 
       (.C(ap_clk),
        .CE(align_len0_0),
        .D(fifo_wreq_n_29),
        .Q(\start_addr_reg_n_2_[10] ),
        .R(SR));
  FDRE \start_addr_reg[11] 
       (.C(ap_clk),
        .CE(align_len0_0),
        .D(fifo_wreq_n_28),
        .Q(\start_addr_reg_n_2_[11] ),
        .R(SR));
  FDRE \start_addr_reg[12] 
       (.C(ap_clk),
        .CE(align_len0_0),
        .D(fifo_wreq_n_27),
        .Q(\start_addr_reg_n_2_[12] ),
        .R(SR));
  FDRE \start_addr_reg[13] 
       (.C(ap_clk),
        .CE(align_len0_0),
        .D(fifo_wreq_n_26),
        .Q(\start_addr_reg_n_2_[13] ),
        .R(SR));
  FDRE \start_addr_reg[14] 
       (.C(ap_clk),
        .CE(align_len0_0),
        .D(fifo_wreq_n_25),
        .Q(\start_addr_reg_n_2_[14] ),
        .R(SR));
  FDRE \start_addr_reg[15] 
       (.C(ap_clk),
        .CE(align_len0_0),
        .D(fifo_wreq_n_24),
        .Q(\start_addr_reg_n_2_[15] ),
        .R(SR));
  FDRE \start_addr_reg[16] 
       (.C(ap_clk),
        .CE(align_len0_0),
        .D(fifo_wreq_n_23),
        .Q(\start_addr_reg_n_2_[16] ),
        .R(SR));
  FDRE \start_addr_reg[17] 
       (.C(ap_clk),
        .CE(align_len0_0),
        .D(fifo_wreq_n_22),
        .Q(\start_addr_reg_n_2_[17] ),
        .R(SR));
  FDRE \start_addr_reg[18] 
       (.C(ap_clk),
        .CE(align_len0_0),
        .D(fifo_wreq_n_21),
        .Q(\start_addr_reg_n_2_[18] ),
        .R(SR));
  FDRE \start_addr_reg[19] 
       (.C(ap_clk),
        .CE(align_len0_0),
        .D(fifo_wreq_n_20),
        .Q(\start_addr_reg_n_2_[19] ),
        .R(SR));
  FDRE \start_addr_reg[20] 
       (.C(ap_clk),
        .CE(align_len0_0),
        .D(fifo_wreq_n_19),
        .Q(\start_addr_reg_n_2_[20] ),
        .R(SR));
  FDRE \start_addr_reg[21] 
       (.C(ap_clk),
        .CE(align_len0_0),
        .D(fifo_wreq_n_18),
        .Q(\start_addr_reg_n_2_[21] ),
        .R(SR));
  FDRE \start_addr_reg[22] 
       (.C(ap_clk),
        .CE(align_len0_0),
        .D(fifo_wreq_n_17),
        .Q(\start_addr_reg_n_2_[22] ),
        .R(SR));
  FDRE \start_addr_reg[23] 
       (.C(ap_clk),
        .CE(align_len0_0),
        .D(fifo_wreq_n_16),
        .Q(\start_addr_reg_n_2_[23] ),
        .R(SR));
  FDRE \start_addr_reg[24] 
       (.C(ap_clk),
        .CE(align_len0_0),
        .D(fifo_wreq_n_15),
        .Q(\start_addr_reg_n_2_[24] ),
        .R(SR));
  FDRE \start_addr_reg[25] 
       (.C(ap_clk),
        .CE(align_len0_0),
        .D(fifo_wreq_n_14),
        .Q(\start_addr_reg_n_2_[25] ),
        .R(SR));
  FDRE \start_addr_reg[26] 
       (.C(ap_clk),
        .CE(align_len0_0),
        .D(fifo_wreq_n_13),
        .Q(\start_addr_reg_n_2_[26] ),
        .R(SR));
  FDRE \start_addr_reg[27] 
       (.C(ap_clk),
        .CE(align_len0_0),
        .D(fifo_wreq_n_12),
        .Q(\start_addr_reg_n_2_[27] ),
        .R(SR));
  FDRE \start_addr_reg[28] 
       (.C(ap_clk),
        .CE(align_len0_0),
        .D(fifo_wreq_n_11),
        .Q(\start_addr_reg_n_2_[28] ),
        .R(SR));
  FDRE \start_addr_reg[29] 
       (.C(ap_clk),
        .CE(align_len0_0),
        .D(fifo_wreq_n_10),
        .Q(\start_addr_reg_n_2_[29] ),
        .R(SR));
  FDRE \start_addr_reg[2] 
       (.C(ap_clk),
        .CE(align_len0_0),
        .D(fifo_wreq_n_37),
        .Q(\start_addr_reg_n_2_[2] ),
        .R(SR));
  FDRE \start_addr_reg[30] 
       (.C(ap_clk),
        .CE(align_len0_0),
        .D(fifo_wreq_n_9),
        .Q(\start_addr_reg_n_2_[30] ),
        .R(SR));
  FDRE \start_addr_reg[31] 
       (.C(ap_clk),
        .CE(align_len0_0),
        .D(fifo_wreq_n_8),
        .Q(\start_addr_reg_n_2_[31] ),
        .R(SR));
  FDRE \start_addr_reg[3] 
       (.C(ap_clk),
        .CE(align_len0_0),
        .D(fifo_wreq_n_36),
        .Q(\start_addr_reg_n_2_[3] ),
        .R(SR));
  FDRE \start_addr_reg[4] 
       (.C(ap_clk),
        .CE(align_len0_0),
        .D(fifo_wreq_n_35),
        .Q(\start_addr_reg_n_2_[4] ),
        .R(SR));
  FDRE \start_addr_reg[5] 
       (.C(ap_clk),
        .CE(align_len0_0),
        .D(fifo_wreq_n_34),
        .Q(\start_addr_reg_n_2_[5] ),
        .R(SR));
  FDRE \start_addr_reg[6] 
       (.C(ap_clk),
        .CE(align_len0_0),
        .D(fifo_wreq_n_33),
        .Q(\start_addr_reg_n_2_[6] ),
        .R(SR));
  FDRE \start_addr_reg[7] 
       (.C(ap_clk),
        .CE(align_len0_0),
        .D(fifo_wreq_n_32),
        .Q(\start_addr_reg_n_2_[7] ),
        .R(SR));
  FDRE \start_addr_reg[8] 
       (.C(ap_clk),
        .CE(align_len0_0),
        .D(fifo_wreq_n_31),
        .Q(\start_addr_reg_n_2_[8] ),
        .R(SR));
  FDRE \start_addr_reg[9] 
       (.C(ap_clk),
        .CE(align_len0_0),
        .D(fifo_wreq_n_30),
        .Q(\start_addr_reg_n_2_[9] ),
        .R(SR));
  LUT3 #(
    .INIT(8'h8B)) 
    \throttl_cnt[0]_i_1 
       (.I0(\could_multi_bursts.awlen_buf_reg[3]_0 [0]),
        .I1(\could_multi_bursts.AWVALID_Dummy_reg_0 ),
        .I2(\throttl_cnt_reg[0]_0 ),
        .O(D));
  LUT4 #(
    .INIT(16'hEAAA)) 
    \throttl_cnt[7]_i_1 
       (.I0(\could_multi_bursts.AWVALID_Dummy_reg_0 ),
        .I1(m_axi_gmem_WREADY),
        .I2(\bus_equal_gen.WVALID_Dummy_reg_0 ),
        .I3(\throttl_cnt_reg[0] ),
        .O(E));
  LUT6 #(
    .INIT(64'h8888888888888880)) 
    \throttl_cnt[7]_i_3 
       (.I0(\could_multi_bursts.AWVALID_Dummy_reg_1 ),
        .I1(AWVALID_Dummy),
        .I2(\could_multi_bursts.awlen_buf_reg[3]_0 [0]),
        .I3(\could_multi_bursts.awlen_buf_reg[3]_0 [1]),
        .I4(\could_multi_bursts.awlen_buf_reg[3]_0 [2]),
        .I5(\could_multi_bursts.awlen_buf_reg[3]_0 [3]),
        .O(\could_multi_bursts.AWVALID_Dummy_reg_0 ));
  FDRE wreq_handling_reg
       (.C(ap_clk),
        .CE(1'b1),
        .D(\bus_equal_gen.fifo_burst_n_33 ),
        .Q(wreq_handling_reg_n_2),
        .R(SR));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
