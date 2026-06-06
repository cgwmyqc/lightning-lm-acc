-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
-- Date        : Fri May 22 16:44:09 2026
-- Host        : DESKTOP-QEQDV5I running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim -rename_top design_1_simple_accel_core_0_3 -prefix
--               design_1_simple_accel_core_0_3_ design_1_simple_accel_core_0_3_sim_netlist.vhdl
-- Design      : design_1_simple_accel_core_0_3
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z015clg485-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_simple_accel_core_0_3_simple_accel_core_control_s_axi is
  port (
    \FSM_onehot_wstate_reg[1]_0\ : out STD_LOGIC;
    \FSM_onehot_wstate_reg[2]_0\ : out STD_LOGIC;
    s_axi_control_BVALID : out STD_LOGIC;
    \FSM_onehot_rstate_reg[1]_0\ : out STD_LOGIC;
    s_axi_control_RVALID : out STD_LOGIC;
    ap_start : out STD_LOGIC;
    Q : out STD_LOGIC_VECTOR ( 31 downto 0 );
    \int_in_buf_reg[31]_0\ : out STD_LOGIC_VECTOR ( 29 downto 0 );
    \int_out_buf_reg[31]_0\ : out STD_LOGIC_VECTOR ( 29 downto 0 );
    interrupt : out STD_LOGIC;
    D : out STD_LOGIC_VECTOR ( 0 to 0 );
    E : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_control_RDATA : out STD_LOGIC_VECTOR ( 31 downto 0 );
    SR : in STD_LOGIC_VECTOR ( 0 to 0 );
    ap_clk : in STD_LOGIC;
    ap_done : in STD_LOGIC;
    s_axi_control_AWVALID : in STD_LOGIC;
    s_axi_control_WVALID : in STD_LOGIC;
    s_axi_control_BREADY : in STD_LOGIC;
    s_axi_control_WDATA : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_control_WSTRB : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_control_ARVALID : in STD_LOGIC;
    s_axi_control_RREADY : in STD_LOGIC;
    s_axi_control_ARADDR : in STD_LOGIC_VECTOR ( 5 downto 0 );
    \ap_CS_fsm_reg[1]\ : in STD_LOGIC;
    \ap_CS_fsm_reg[1]_0\ : in STD_LOGIC;
    int_ap_start_reg_0 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \ap_CS_fsm_reg[1]_1\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_control_AWADDR : in STD_LOGIC_VECTOR ( 5 downto 0 );
    gmem_BVALID : in STD_LOGIC
  );
end design_1_simple_accel_core_0_3_simple_accel_core_control_s_axi;

architecture STRUCTURE of design_1_simple_accel_core_0_3_simple_accel_core_control_s_axi is
  signal \^e\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \FSM_onehot_rstate[1]_i_1_n_2\ : STD_LOGIC;
  signal \FSM_onehot_rstate[2]_i_1_n_2\ : STD_LOGIC;
  signal \^fsm_onehot_rstate_reg[1]_0\ : STD_LOGIC;
  signal \FSM_onehot_wstate[1]_i_1_n_2\ : STD_LOGIC;
  signal \FSM_onehot_wstate[2]_i_1_n_2\ : STD_LOGIC;
  signal \FSM_onehot_wstate[3]_i_1_n_2\ : STD_LOGIC;
  signal \^fsm_onehot_wstate_reg[1]_0\ : STD_LOGIC;
  signal \^fsm_onehot_wstate_reg[2]_0\ : STD_LOGIC;
  signal \^q\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ap_idle : STD_LOGIC;
  signal \^ap_start\ : STD_LOGIC;
  signal ar_hs : STD_LOGIC;
  signal data0 : STD_LOGIC_VECTOR ( 7 downto 1 );
  signal int_ap_done_i_1_n_2 : STD_LOGIC;
  signal int_ap_start3_out : STD_LOGIC;
  signal int_ap_start_i_1_n_2 : STD_LOGIC;
  signal int_auto_restart_i_1_n_2 : STD_LOGIC;
  signal int_gie_i_1_n_2 : STD_LOGIC;
  signal int_gie_reg_n_2 : STD_LOGIC;
  signal \int_ier[0]_i_1_n_2\ : STD_LOGIC;
  signal \int_ier[1]_i_1_n_2\ : STD_LOGIC;
  signal \int_ier[1]_i_2_n_2\ : STD_LOGIC;
  signal \int_ier_reg_n_2_[0]\ : STD_LOGIC;
  signal int_in_buf0 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \int_in_buf[31]_i_1_n_2\ : STD_LOGIC;
  signal \int_in_buf[31]_i_3_n_2\ : STD_LOGIC;
  signal \^int_in_buf_reg[31]_0\ : STD_LOGIC_VECTOR ( 29 downto 0 );
  signal \int_in_buf_reg_n_2_[0]\ : STD_LOGIC;
  signal \int_in_buf_reg_n_2_[1]\ : STD_LOGIC;
  signal int_isr6_out : STD_LOGIC;
  signal \int_isr[0]_i_1_n_2\ : STD_LOGIC;
  signal \int_isr[1]_i_1_n_2\ : STD_LOGIC;
  signal \int_isr_reg_n_2_[0]\ : STD_LOGIC;
  signal int_num_items0 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \int_num_items[31]_i_1_n_2\ : STD_LOGIC;
  signal \int_num_items[31]_i_3_n_2\ : STD_LOGIC;
  signal int_out_buf0 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \int_out_buf[31]_i_1_n_2\ : STD_LOGIC;
  signal \^int_out_buf_reg[31]_0\ : STD_LOGIC_VECTOR ( 29 downto 0 );
  signal \int_out_buf_reg_n_2_[0]\ : STD_LOGIC;
  signal \int_out_buf_reg_n_2_[1]\ : STD_LOGIC;
  signal p_0_in : STD_LOGIC;
  signal p_1_in : STD_LOGIC;
  signal rdata : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \rdata[0]_i_2_n_2\ : STD_LOGIC;
  signal \rdata[0]_i_3_n_2\ : STD_LOGIC;
  signal \rdata[1]_i_2_n_2\ : STD_LOGIC;
  signal \rdata[1]_i_3_n_2\ : STD_LOGIC;
  signal \rdata[2]_i_2_n_2\ : STD_LOGIC;
  signal \rdata[31]_i_3_n_2\ : STD_LOGIC;
  signal \rdata[31]_i_4_n_2\ : STD_LOGIC;
  signal \rdata[31]_i_5_n_2\ : STD_LOGIC;
  signal \rdata[3]_i_2_n_2\ : STD_LOGIC;
  signal \rdata[7]_i_2_n_2\ : STD_LOGIC;
  signal \^s_axi_control_bvalid\ : STD_LOGIC;
  signal \^s_axi_control_rvalid\ : STD_LOGIC;
  signal waddr : STD_LOGIC;
  signal \waddr_reg_n_2_[0]\ : STD_LOGIC;
  signal \waddr_reg_n_2_[1]\ : STD_LOGIC;
  signal \waddr_reg_n_2_[2]\ : STD_LOGIC;
  signal \waddr_reg_n_2_[3]\ : STD_LOGIC;
  signal \waddr_reg_n_2_[4]\ : STD_LOGIC;
  signal \waddr_reg_n_2_[5]\ : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \FSM_onehot_rstate[1]_i_1\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \FSM_onehot_rstate[2]_i_1\ : label is "soft_lutpair1";
  attribute FSM_ENCODED_STATES : string;
  attribute FSM_ENCODED_STATES of \FSM_onehot_rstate_reg[1]\ : label is "RDIDLE:010,RDDATA:100,iSTATE:001";
  attribute FSM_ENCODED_STATES of \FSM_onehot_rstate_reg[2]\ : label is "RDIDLE:010,RDDATA:100,iSTATE:001";
  attribute FSM_ENCODED_STATES of \FSM_onehot_wstate_reg[1]\ : label is "WRDATA:0100,WRRESP:1000,WRIDLE:0010,iSTATE:0001";
  attribute FSM_ENCODED_STATES of \FSM_onehot_wstate_reg[2]\ : label is "WRDATA:0100,WRRESP:1000,WRIDLE:0010,iSTATE:0001";
  attribute FSM_ENCODED_STATES of \FSM_onehot_wstate_reg[3]\ : label is "WRDATA:0100,WRRESP:1000,WRIDLE:0010,iSTATE:0001";
  attribute SOFT_HLUTNM of int_ap_idle_i_1 : label is "soft_lutpair51";
  attribute SOFT_HLUTNM of int_ap_start_i_2 : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \int_in_buf[10]_i_1\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \int_in_buf[11]_i_1\ : label is "soft_lutpair16";
  attribute SOFT_HLUTNM of \int_in_buf[12]_i_1\ : label is "soft_lutpair16";
  attribute SOFT_HLUTNM of \int_in_buf[13]_i_1\ : label is "soft_lutpair15";
  attribute SOFT_HLUTNM of \int_in_buf[14]_i_1\ : label is "soft_lutpair15";
  attribute SOFT_HLUTNM of \int_in_buf[15]_i_1\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \int_in_buf[16]_i_1\ : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of \int_in_buf[17]_i_1\ : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of \int_in_buf[18]_i_1\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of \int_in_buf[19]_i_1\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of \int_in_buf[1]_i_1\ : label is "soft_lutpair19";
  attribute SOFT_HLUTNM of \int_in_buf[20]_i_1\ : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of \int_in_buf[21]_i_1\ : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of \int_in_buf[22]_i_1\ : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \int_in_buf[23]_i_1\ : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \int_in_buf[24]_i_1\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \int_in_buf[25]_i_1\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \int_in_buf[26]_i_1\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \int_in_buf[27]_i_1\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \int_in_buf[28]_i_1\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \int_in_buf[29]_i_1\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \int_in_buf[2]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \int_in_buf[30]_i_1\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \int_in_buf[31]_i_2\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \int_in_buf[3]_i_1\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \int_in_buf[4]_i_1\ : label is "soft_lutpair19";
  attribute SOFT_HLUTNM of \int_in_buf[5]_i_1\ : label is "soft_lutpair18";
  attribute SOFT_HLUTNM of \int_in_buf[6]_i_1\ : label is "soft_lutpair18";
  attribute SOFT_HLUTNM of \int_in_buf[7]_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \int_in_buf[8]_i_1\ : label is "soft_lutpair17";
  attribute SOFT_HLUTNM of \int_in_buf[9]_i_1\ : label is "soft_lutpair17";
  attribute SOFT_HLUTNM of \int_isr[0]_i_2\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \int_num_items[0]_i_1\ : label is "soft_lutpair50";
  attribute SOFT_HLUTNM of \int_num_items[10]_i_1\ : label is "soft_lutpair42";
  attribute SOFT_HLUTNM of \int_num_items[11]_i_1\ : label is "soft_lutpair46";
  attribute SOFT_HLUTNM of \int_num_items[12]_i_1\ : label is "soft_lutpair45";
  attribute SOFT_HLUTNM of \int_num_items[13]_i_1\ : label is "soft_lutpair45";
  attribute SOFT_HLUTNM of \int_num_items[14]_i_1\ : label is "soft_lutpair44";
  attribute SOFT_HLUTNM of \int_num_items[15]_i_1\ : label is "soft_lutpair42";
  attribute SOFT_HLUTNM of \int_num_items[16]_i_1\ : label is "soft_lutpair43";
  attribute SOFT_HLUTNM of \int_num_items[17]_i_1\ : label is "soft_lutpair41";
  attribute SOFT_HLUTNM of \int_num_items[18]_i_1\ : label is "soft_lutpair43";
  attribute SOFT_HLUTNM of \int_num_items[19]_i_1\ : label is "soft_lutpair41";
  attribute SOFT_HLUTNM of \int_num_items[1]_i_1\ : label is "soft_lutpair50";
  attribute SOFT_HLUTNM of \int_num_items[20]_i_1\ : label is "soft_lutpair34";
  attribute SOFT_HLUTNM of \int_num_items[21]_i_1\ : label is "soft_lutpair34";
  attribute SOFT_HLUTNM of \int_num_items[22]_i_1\ : label is "soft_lutpair29";
  attribute SOFT_HLUTNM of \int_num_items[23]_i_1\ : label is "soft_lutpair29";
  attribute SOFT_HLUTNM of \int_num_items[24]_i_1\ : label is "soft_lutpair40";
  attribute SOFT_HLUTNM of \int_num_items[25]_i_1\ : label is "soft_lutpair40";
  attribute SOFT_HLUTNM of \int_num_items[26]_i_1\ : label is "soft_lutpair39";
  attribute SOFT_HLUTNM of \int_num_items[27]_i_1\ : label is "soft_lutpair39";
  attribute SOFT_HLUTNM of \int_num_items[28]_i_1\ : label is "soft_lutpair38";
  attribute SOFT_HLUTNM of \int_num_items[29]_i_1\ : label is "soft_lutpair38";
  attribute SOFT_HLUTNM of \int_num_items[2]_i_1\ : label is "soft_lutpair49";
  attribute SOFT_HLUTNM of \int_num_items[30]_i_1\ : label is "soft_lutpair37";
  attribute SOFT_HLUTNM of \int_num_items[31]_i_2\ : label is "soft_lutpair37";
  attribute SOFT_HLUTNM of \int_num_items[3]_i_1\ : label is "soft_lutpair49";
  attribute SOFT_HLUTNM of \int_num_items[4]_i_1\ : label is "soft_lutpair48";
  attribute SOFT_HLUTNM of \int_num_items[5]_i_1\ : label is "soft_lutpair48";
  attribute SOFT_HLUTNM of \int_num_items[6]_i_1\ : label is "soft_lutpair47";
  attribute SOFT_HLUTNM of \int_num_items[7]_i_1\ : label is "soft_lutpair47";
  attribute SOFT_HLUTNM of \int_num_items[8]_i_1\ : label is "soft_lutpair46";
  attribute SOFT_HLUTNM of \int_num_items[9]_i_1\ : label is "soft_lutpair44";
  attribute SOFT_HLUTNM of \int_out_buf[0]_i_1\ : label is "soft_lutpair36";
  attribute SOFT_HLUTNM of \int_out_buf[10]_i_1\ : label is "soft_lutpair31";
  attribute SOFT_HLUTNM of \int_out_buf[11]_i_1\ : label is "soft_lutpair31";
  attribute SOFT_HLUTNM of \int_out_buf[12]_i_1\ : label is "soft_lutpair30";
  attribute SOFT_HLUTNM of \int_out_buf[13]_i_1\ : label is "soft_lutpair30";
  attribute SOFT_HLUTNM of \int_out_buf[14]_i_1\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \int_out_buf[15]_i_1\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \int_out_buf[16]_i_1\ : label is "soft_lutpair27";
  attribute SOFT_HLUTNM of \int_out_buf[17]_i_1\ : label is "soft_lutpair27";
  attribute SOFT_HLUTNM of \int_out_buf[18]_i_1\ : label is "soft_lutpair26";
  attribute SOFT_HLUTNM of \int_out_buf[19]_i_1\ : label is "soft_lutpair26";
  attribute SOFT_HLUTNM of \int_out_buf[1]_i_1\ : label is "soft_lutpair36";
  attribute SOFT_HLUTNM of \int_out_buf[20]_i_1\ : label is "soft_lutpair25";
  attribute SOFT_HLUTNM of \int_out_buf[21]_i_1\ : label is "soft_lutpair25";
  attribute SOFT_HLUTNM of \int_out_buf[22]_i_1\ : label is "soft_lutpair24";
  attribute SOFT_HLUTNM of \int_out_buf[23]_i_1\ : label is "soft_lutpair24";
  attribute SOFT_HLUTNM of \int_out_buf[24]_i_1\ : label is "soft_lutpair23";
  attribute SOFT_HLUTNM of \int_out_buf[25]_i_1\ : label is "soft_lutpair23";
  attribute SOFT_HLUTNM of \int_out_buf[26]_i_1\ : label is "soft_lutpair22";
  attribute SOFT_HLUTNM of \int_out_buf[27]_i_1\ : label is "soft_lutpair22";
  attribute SOFT_HLUTNM of \int_out_buf[28]_i_1\ : label is "soft_lutpair21";
  attribute SOFT_HLUTNM of \int_out_buf[29]_i_1\ : label is "soft_lutpair21";
  attribute SOFT_HLUTNM of \int_out_buf[2]_i_1\ : label is "soft_lutpair35";
  attribute SOFT_HLUTNM of \int_out_buf[30]_i_1\ : label is "soft_lutpair20";
  attribute SOFT_HLUTNM of \int_out_buf[31]_i_2\ : label is "soft_lutpair20";
  attribute SOFT_HLUTNM of \int_out_buf[3]_i_1\ : label is "soft_lutpair35";
  attribute SOFT_HLUTNM of \int_out_buf[4]_i_1\ : label is "soft_lutpair28";
  attribute SOFT_HLUTNM of \int_out_buf[5]_i_1\ : label is "soft_lutpair33";
  attribute SOFT_HLUTNM of \int_out_buf[6]_i_1\ : label is "soft_lutpair33";
  attribute SOFT_HLUTNM of \int_out_buf[7]_i_1\ : label is "soft_lutpair28";
  attribute SOFT_HLUTNM of \int_out_buf[8]_i_1\ : label is "soft_lutpair32";
  attribute SOFT_HLUTNM of \int_out_buf[9]_i_1\ : label is "soft_lutpair32";
  attribute SOFT_HLUTNM of \num_items_read_reg_222[31]_i_1\ : label is "soft_lutpair51";
  attribute SOFT_HLUTNM of \rdata[2]_i_2\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \rdata[3]_i_2\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \rdata[7]_i_2\ : label is "soft_lutpair3";
begin
  E(0) <= \^e\(0);
  \FSM_onehot_rstate_reg[1]_0\ <= \^fsm_onehot_rstate_reg[1]_0\;
  \FSM_onehot_wstate_reg[1]_0\ <= \^fsm_onehot_wstate_reg[1]_0\;
  \FSM_onehot_wstate_reg[2]_0\ <= \^fsm_onehot_wstate_reg[2]_0\;
  Q(31 downto 0) <= \^q\(31 downto 0);
  ap_start <= \^ap_start\;
  \int_in_buf_reg[31]_0\(29 downto 0) <= \^int_in_buf_reg[31]_0\(29 downto 0);
  \int_out_buf_reg[31]_0\(29 downto 0) <= \^int_out_buf_reg[31]_0\(29 downto 0);
  s_axi_control_BVALID <= \^s_axi_control_bvalid\;
  s_axi_control_RVALID <= \^s_axi_control_rvalid\;
\FSM_onehot_rstate[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8BFB"
    )
        port map (
      I0 => s_axi_control_RREADY,
      I1 => \^s_axi_control_rvalid\,
      I2 => \^fsm_onehot_rstate_reg[1]_0\,
      I3 => s_axi_control_ARVALID,
      O => \FSM_onehot_rstate[1]_i_1_n_2\
    );
\FSM_onehot_rstate[2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8F88"
    )
        port map (
      I0 => s_axi_control_ARVALID,
      I1 => \^fsm_onehot_rstate_reg[1]_0\,
      I2 => s_axi_control_RREADY,
      I3 => \^s_axi_control_rvalid\,
      O => \FSM_onehot_rstate[2]_i_1_n_2\
    );
\FSM_onehot_rstate_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \FSM_onehot_rstate[1]_i_1_n_2\,
      Q => \^fsm_onehot_rstate_reg[1]_0\,
      R => SR(0)
    );
\FSM_onehot_rstate_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \FSM_onehot_rstate[2]_i_1_n_2\,
      Q => \^s_axi_control_rvalid\,
      R => SR(0)
    );
\FSM_onehot_wstate[1]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FF474447"
    )
        port map (
      I0 => s_axi_control_AWVALID,
      I1 => \^fsm_onehot_wstate_reg[1]_0\,
      I2 => \^fsm_onehot_wstate_reg[2]_0\,
      I3 => \^s_axi_control_bvalid\,
      I4 => s_axi_control_BREADY,
      O => \FSM_onehot_wstate[1]_i_1_n_2\
    );
\FSM_onehot_wstate[2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8F88"
    )
        port map (
      I0 => \^fsm_onehot_wstate_reg[1]_0\,
      I1 => s_axi_control_AWVALID,
      I2 => s_axi_control_WVALID,
      I3 => \^fsm_onehot_wstate_reg[2]_0\,
      O => \FSM_onehot_wstate[2]_i_1_n_2\
    );
\FSM_onehot_wstate[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8F88"
    )
        port map (
      I0 => s_axi_control_WVALID,
      I1 => \^fsm_onehot_wstate_reg[2]_0\,
      I2 => s_axi_control_BREADY,
      I3 => \^s_axi_control_bvalid\,
      O => \FSM_onehot_wstate[3]_i_1_n_2\
    );
\FSM_onehot_wstate_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \FSM_onehot_wstate[1]_i_1_n_2\,
      Q => \^fsm_onehot_wstate_reg[1]_0\,
      R => SR(0)
    );
\FSM_onehot_wstate_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \FSM_onehot_wstate[2]_i_1_n_2\,
      Q => \^fsm_onehot_wstate_reg[2]_0\,
      R => SR(0)
    );
\FSM_onehot_wstate_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \FSM_onehot_wstate[3]_i_1_n_2\,
      Q => \^s_axi_control_bvalid\,
      R => SR(0)
    );
\ap_CS_fsm[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAAAAAAAAAAABA"
    )
        port map (
      I0 => \^e\(0),
      I1 => \ap_CS_fsm_reg[1]\,
      I2 => \ap_CS_fsm_reg[1]_0\,
      I3 => int_ap_start_reg_0(1),
      I4 => int_ap_start_reg_0(2),
      I5 => \ap_CS_fsm_reg[1]_1\(0),
      O => D(0)
    );
int_ap_done_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFBFFFFAAAAAAAA"
    )
        port map (
      I0 => ap_done,
      I1 => ar_hs,
      I2 => s_axi_control_ARADDR(2),
      I3 => s_axi_control_ARADDR(3),
      I4 => \rdata[31]_i_5_n_2\,
      I5 => data0(1),
      O => int_ap_done_i_1_n_2
    );
int_ap_done_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => int_ap_done_i_1_n_2,
      Q => data0(1),
      R => SR(0)
    );
int_ap_idle_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => int_ap_start_reg_0(0),
      I1 => \^ap_start\,
      O => ap_idle
    );
int_ap_idle_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => ap_idle,
      Q => data0(2),
      R => SR(0)
    );
int_ap_ready_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => ap_done,
      Q => data0(3),
      R => SR(0)
    );
int_ap_start_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFBFFF80"
    )
        port map (
      I0 => data0(7),
      I1 => gmem_BVALID,
      I2 => int_ap_start_reg_0(3),
      I3 => int_ap_start3_out,
      I4 => \^ap_start\,
      O => int_ap_start_i_1_n_2
    );
int_ap_start_i_2: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000200"
    )
        port map (
      I0 => s_axi_control_WDATA(0),
      I1 => \waddr_reg_n_2_[3]\,
      I2 => \int_ier[1]_i_2_n_2\,
      I3 => s_axi_control_WSTRB(0),
      I4 => \waddr_reg_n_2_[2]\,
      O => int_ap_start3_out
    );
int_ap_start_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => int_ap_start_i_1_n_2,
      Q => \^ap_start\,
      R => SR(0)
    );
int_auto_restart_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFEF00000020"
    )
        port map (
      I0 => s_axi_control_WDATA(7),
      I1 => \waddr_reg_n_2_[2]\,
      I2 => s_axi_control_WSTRB(0),
      I3 => \int_ier[1]_i_2_n_2\,
      I4 => \waddr_reg_n_2_[3]\,
      I5 => data0(7),
      O => int_auto_restart_i_1_n_2
    );
int_auto_restart_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => int_auto_restart_i_1_n_2,
      Q => data0(7),
      R => SR(0)
    );
int_gie_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FEFFFFFF02000000"
    )
        port map (
      I0 => s_axi_control_WDATA(0),
      I1 => \int_ier[1]_i_2_n_2\,
      I2 => \waddr_reg_n_2_[3]\,
      I3 => s_axi_control_WSTRB(0),
      I4 => \waddr_reg_n_2_[2]\,
      I5 => int_gie_reg_n_2,
      O => int_gie_i_1_n_2
    );
int_gie_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => int_gie_i_1_n_2,
      Q => int_gie_reg_n_2,
      R => SR(0)
    );
\int_ier[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFEFFF00002000"
    )
        port map (
      I0 => s_axi_control_WDATA(0),
      I1 => \waddr_reg_n_2_[2]\,
      I2 => s_axi_control_WSTRB(0),
      I3 => \waddr_reg_n_2_[3]\,
      I4 => \int_ier[1]_i_2_n_2\,
      I5 => \int_ier_reg_n_2_[0]\,
      O => \int_ier[0]_i_1_n_2\
    );
\int_ier[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFEFFF00002000"
    )
        port map (
      I0 => s_axi_control_WDATA(1),
      I1 => \waddr_reg_n_2_[2]\,
      I2 => s_axi_control_WSTRB(0),
      I3 => \waddr_reg_n_2_[3]\,
      I4 => \int_ier[1]_i_2_n_2\,
      I5 => p_0_in,
      O => \int_ier[1]_i_1_n_2\
    );
\int_ier[1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFEFFFFFF"
    )
        port map (
      I0 => \waddr_reg_n_2_[5]\,
      I1 => \waddr_reg_n_2_[0]\,
      I2 => \waddr_reg_n_2_[1]\,
      I3 => s_axi_control_WVALID,
      I4 => \^fsm_onehot_wstate_reg[2]_0\,
      I5 => \waddr_reg_n_2_[4]\,
      O => \int_ier[1]_i_2_n_2\
    );
\int_ier_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \int_ier[0]_i_1_n_2\,
      Q => \int_ier_reg_n_2_[0]\,
      R => SR(0)
    );
\int_ier_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \int_ier[1]_i_1_n_2\,
      Q => p_0_in,
      R => SR(0)
    );
\int_in_buf[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(0),
      I1 => s_axi_control_WSTRB(0),
      I2 => \int_in_buf_reg_n_2_[0]\,
      O => int_in_buf0(0)
    );
\int_in_buf[10]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(10),
      I1 => s_axi_control_WSTRB(1),
      I2 => \^int_in_buf_reg[31]_0\(8),
      O => int_in_buf0(10)
    );
\int_in_buf[11]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(11),
      I1 => s_axi_control_WSTRB(1),
      I2 => \^int_in_buf_reg[31]_0\(9),
      O => int_in_buf0(11)
    );
\int_in_buf[12]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(12),
      I1 => s_axi_control_WSTRB(1),
      I2 => \^int_in_buf_reg[31]_0\(10),
      O => int_in_buf0(12)
    );
\int_in_buf[13]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(13),
      I1 => s_axi_control_WSTRB(1),
      I2 => \^int_in_buf_reg[31]_0\(11),
      O => int_in_buf0(13)
    );
\int_in_buf[14]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(14),
      I1 => s_axi_control_WSTRB(1),
      I2 => \^int_in_buf_reg[31]_0\(12),
      O => int_in_buf0(14)
    );
\int_in_buf[15]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(15),
      I1 => s_axi_control_WSTRB(1),
      I2 => \^int_in_buf_reg[31]_0\(13),
      O => int_in_buf0(15)
    );
\int_in_buf[16]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(16),
      I1 => s_axi_control_WSTRB(2),
      I2 => \^int_in_buf_reg[31]_0\(14),
      O => int_in_buf0(16)
    );
\int_in_buf[17]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(17),
      I1 => s_axi_control_WSTRB(2),
      I2 => \^int_in_buf_reg[31]_0\(15),
      O => int_in_buf0(17)
    );
\int_in_buf[18]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(18),
      I1 => s_axi_control_WSTRB(2),
      I2 => \^int_in_buf_reg[31]_0\(16),
      O => int_in_buf0(18)
    );
\int_in_buf[19]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(19),
      I1 => s_axi_control_WSTRB(2),
      I2 => \^int_in_buf_reg[31]_0\(17),
      O => int_in_buf0(19)
    );
\int_in_buf[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(1),
      I1 => s_axi_control_WSTRB(0),
      I2 => \int_in_buf_reg_n_2_[1]\,
      O => int_in_buf0(1)
    );
\int_in_buf[20]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(20),
      I1 => s_axi_control_WSTRB(2),
      I2 => \^int_in_buf_reg[31]_0\(18),
      O => int_in_buf0(20)
    );
\int_in_buf[21]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(21),
      I1 => s_axi_control_WSTRB(2),
      I2 => \^int_in_buf_reg[31]_0\(19),
      O => int_in_buf0(21)
    );
\int_in_buf[22]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(22),
      I1 => s_axi_control_WSTRB(2),
      I2 => \^int_in_buf_reg[31]_0\(20),
      O => int_in_buf0(22)
    );
\int_in_buf[23]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(23),
      I1 => s_axi_control_WSTRB(2),
      I2 => \^int_in_buf_reg[31]_0\(21),
      O => int_in_buf0(23)
    );
\int_in_buf[24]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(24),
      I1 => s_axi_control_WSTRB(3),
      I2 => \^int_in_buf_reg[31]_0\(22),
      O => int_in_buf0(24)
    );
\int_in_buf[25]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(25),
      I1 => s_axi_control_WSTRB(3),
      I2 => \^int_in_buf_reg[31]_0\(23),
      O => int_in_buf0(25)
    );
\int_in_buf[26]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(26),
      I1 => s_axi_control_WSTRB(3),
      I2 => \^int_in_buf_reg[31]_0\(24),
      O => int_in_buf0(26)
    );
\int_in_buf[27]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(27),
      I1 => s_axi_control_WSTRB(3),
      I2 => \^int_in_buf_reg[31]_0\(25),
      O => int_in_buf0(27)
    );
\int_in_buf[28]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(28),
      I1 => s_axi_control_WSTRB(3),
      I2 => \^int_in_buf_reg[31]_0\(26),
      O => int_in_buf0(28)
    );
\int_in_buf[29]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(29),
      I1 => s_axi_control_WSTRB(3),
      I2 => \^int_in_buf_reg[31]_0\(27),
      O => int_in_buf0(29)
    );
\int_in_buf[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(2),
      I1 => s_axi_control_WSTRB(0),
      I2 => \^int_in_buf_reg[31]_0\(0),
      O => int_in_buf0(2)
    );
\int_in_buf[30]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(30),
      I1 => s_axi_control_WSTRB(3),
      I2 => \^int_in_buf_reg[31]_0\(28),
      O => int_in_buf0(30)
    );
\int_in_buf[31]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"10"
    )
        port map (
      I0 => \waddr_reg_n_2_[3]\,
      I1 => \waddr_reg_n_2_[2]\,
      I2 => \int_in_buf[31]_i_3_n_2\,
      O => \int_in_buf[31]_i_1_n_2\
    );
\int_in_buf[31]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(31),
      I1 => s_axi_control_WSTRB(3),
      I2 => \^int_in_buf_reg[31]_0\(29),
      O => int_in_buf0(31)
    );
\int_in_buf[31]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000080000"
    )
        port map (
      I0 => \^fsm_onehot_wstate_reg[2]_0\,
      I1 => s_axi_control_WVALID,
      I2 => \waddr_reg_n_2_[1]\,
      I3 => \waddr_reg_n_2_[0]\,
      I4 => \waddr_reg_n_2_[4]\,
      I5 => \waddr_reg_n_2_[5]\,
      O => \int_in_buf[31]_i_3_n_2\
    );
\int_in_buf[3]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(3),
      I1 => s_axi_control_WSTRB(0),
      I2 => \^int_in_buf_reg[31]_0\(1),
      O => int_in_buf0(3)
    );
\int_in_buf[4]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(4),
      I1 => s_axi_control_WSTRB(0),
      I2 => \^int_in_buf_reg[31]_0\(2),
      O => int_in_buf0(4)
    );
\int_in_buf[5]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(5),
      I1 => s_axi_control_WSTRB(0),
      I2 => \^int_in_buf_reg[31]_0\(3),
      O => int_in_buf0(5)
    );
\int_in_buf[6]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(6),
      I1 => s_axi_control_WSTRB(0),
      I2 => \^int_in_buf_reg[31]_0\(4),
      O => int_in_buf0(6)
    );
\int_in_buf[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(7),
      I1 => s_axi_control_WSTRB(0),
      I2 => \^int_in_buf_reg[31]_0\(5),
      O => int_in_buf0(7)
    );
\int_in_buf[8]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(8),
      I1 => s_axi_control_WSTRB(1),
      I2 => \^int_in_buf_reg[31]_0\(6),
      O => int_in_buf0(8)
    );
\int_in_buf[9]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(9),
      I1 => s_axi_control_WSTRB(1),
      I2 => \^int_in_buf_reg[31]_0\(7),
      O => int_in_buf0(9)
    );
\int_in_buf_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_in_buf[31]_i_1_n_2\,
      D => int_in_buf0(0),
      Q => \int_in_buf_reg_n_2_[0]\,
      R => SR(0)
    );
\int_in_buf_reg[10]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_in_buf[31]_i_1_n_2\,
      D => int_in_buf0(10),
      Q => \^int_in_buf_reg[31]_0\(8),
      R => SR(0)
    );
\int_in_buf_reg[11]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_in_buf[31]_i_1_n_2\,
      D => int_in_buf0(11),
      Q => \^int_in_buf_reg[31]_0\(9),
      R => SR(0)
    );
\int_in_buf_reg[12]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_in_buf[31]_i_1_n_2\,
      D => int_in_buf0(12),
      Q => \^int_in_buf_reg[31]_0\(10),
      R => SR(0)
    );
\int_in_buf_reg[13]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_in_buf[31]_i_1_n_2\,
      D => int_in_buf0(13),
      Q => \^int_in_buf_reg[31]_0\(11),
      R => SR(0)
    );
\int_in_buf_reg[14]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_in_buf[31]_i_1_n_2\,
      D => int_in_buf0(14),
      Q => \^int_in_buf_reg[31]_0\(12),
      R => SR(0)
    );
\int_in_buf_reg[15]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_in_buf[31]_i_1_n_2\,
      D => int_in_buf0(15),
      Q => \^int_in_buf_reg[31]_0\(13),
      R => SR(0)
    );
\int_in_buf_reg[16]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_in_buf[31]_i_1_n_2\,
      D => int_in_buf0(16),
      Q => \^int_in_buf_reg[31]_0\(14),
      R => SR(0)
    );
\int_in_buf_reg[17]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_in_buf[31]_i_1_n_2\,
      D => int_in_buf0(17),
      Q => \^int_in_buf_reg[31]_0\(15),
      R => SR(0)
    );
\int_in_buf_reg[18]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_in_buf[31]_i_1_n_2\,
      D => int_in_buf0(18),
      Q => \^int_in_buf_reg[31]_0\(16),
      R => SR(0)
    );
\int_in_buf_reg[19]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_in_buf[31]_i_1_n_2\,
      D => int_in_buf0(19),
      Q => \^int_in_buf_reg[31]_0\(17),
      R => SR(0)
    );
\int_in_buf_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_in_buf[31]_i_1_n_2\,
      D => int_in_buf0(1),
      Q => \int_in_buf_reg_n_2_[1]\,
      R => SR(0)
    );
\int_in_buf_reg[20]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_in_buf[31]_i_1_n_2\,
      D => int_in_buf0(20),
      Q => \^int_in_buf_reg[31]_0\(18),
      R => SR(0)
    );
\int_in_buf_reg[21]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_in_buf[31]_i_1_n_2\,
      D => int_in_buf0(21),
      Q => \^int_in_buf_reg[31]_0\(19),
      R => SR(0)
    );
\int_in_buf_reg[22]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_in_buf[31]_i_1_n_2\,
      D => int_in_buf0(22),
      Q => \^int_in_buf_reg[31]_0\(20),
      R => SR(0)
    );
\int_in_buf_reg[23]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_in_buf[31]_i_1_n_2\,
      D => int_in_buf0(23),
      Q => \^int_in_buf_reg[31]_0\(21),
      R => SR(0)
    );
\int_in_buf_reg[24]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_in_buf[31]_i_1_n_2\,
      D => int_in_buf0(24),
      Q => \^int_in_buf_reg[31]_0\(22),
      R => SR(0)
    );
\int_in_buf_reg[25]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_in_buf[31]_i_1_n_2\,
      D => int_in_buf0(25),
      Q => \^int_in_buf_reg[31]_0\(23),
      R => SR(0)
    );
\int_in_buf_reg[26]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_in_buf[31]_i_1_n_2\,
      D => int_in_buf0(26),
      Q => \^int_in_buf_reg[31]_0\(24),
      R => SR(0)
    );
\int_in_buf_reg[27]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_in_buf[31]_i_1_n_2\,
      D => int_in_buf0(27),
      Q => \^int_in_buf_reg[31]_0\(25),
      R => SR(0)
    );
\int_in_buf_reg[28]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_in_buf[31]_i_1_n_2\,
      D => int_in_buf0(28),
      Q => \^int_in_buf_reg[31]_0\(26),
      R => SR(0)
    );
\int_in_buf_reg[29]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_in_buf[31]_i_1_n_2\,
      D => int_in_buf0(29),
      Q => \^int_in_buf_reg[31]_0\(27),
      R => SR(0)
    );
\int_in_buf_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_in_buf[31]_i_1_n_2\,
      D => int_in_buf0(2),
      Q => \^int_in_buf_reg[31]_0\(0),
      R => SR(0)
    );
\int_in_buf_reg[30]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_in_buf[31]_i_1_n_2\,
      D => int_in_buf0(30),
      Q => \^int_in_buf_reg[31]_0\(28),
      R => SR(0)
    );
\int_in_buf_reg[31]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_in_buf[31]_i_1_n_2\,
      D => int_in_buf0(31),
      Q => \^int_in_buf_reg[31]_0\(29),
      R => SR(0)
    );
\int_in_buf_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_in_buf[31]_i_1_n_2\,
      D => int_in_buf0(3),
      Q => \^int_in_buf_reg[31]_0\(1),
      R => SR(0)
    );
\int_in_buf_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_in_buf[31]_i_1_n_2\,
      D => int_in_buf0(4),
      Q => \^int_in_buf_reg[31]_0\(2),
      R => SR(0)
    );
\int_in_buf_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_in_buf[31]_i_1_n_2\,
      D => int_in_buf0(5),
      Q => \^int_in_buf_reg[31]_0\(3),
      R => SR(0)
    );
\int_in_buf_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_in_buf[31]_i_1_n_2\,
      D => int_in_buf0(6),
      Q => \^int_in_buf_reg[31]_0\(4),
      R => SR(0)
    );
\int_in_buf_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_in_buf[31]_i_1_n_2\,
      D => int_in_buf0(7),
      Q => \^int_in_buf_reg[31]_0\(5),
      R => SR(0)
    );
\int_in_buf_reg[8]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_in_buf[31]_i_1_n_2\,
      D => int_in_buf0(8),
      Q => \^int_in_buf_reg[31]_0\(6),
      R => SR(0)
    );
\int_in_buf_reg[9]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_in_buf[31]_i_1_n_2\,
      D => int_in_buf0(9),
      Q => \^int_in_buf_reg[31]_0\(7),
      R => SR(0)
    );
\int_isr[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F7777777F8888888"
    )
        port map (
      I0 => s_axi_control_WDATA(0),
      I1 => int_isr6_out,
      I2 => int_ap_start_reg_0(3),
      I3 => gmem_BVALID,
      I4 => \int_ier_reg_n_2_[0]\,
      I5 => \int_isr_reg_n_2_[0]\,
      O => \int_isr[0]_i_1_n_2\
    );
\int_isr[0]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0080"
    )
        port map (
      I0 => s_axi_control_WSTRB(0),
      I1 => \waddr_reg_n_2_[2]\,
      I2 => \waddr_reg_n_2_[3]\,
      I3 => \int_ier[1]_i_2_n_2\,
      O => int_isr6_out
    );
\int_isr[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F7777777F8888888"
    )
        port map (
      I0 => s_axi_control_WDATA(1),
      I1 => int_isr6_out,
      I2 => int_ap_start_reg_0(3),
      I3 => gmem_BVALID,
      I4 => p_0_in,
      I5 => p_1_in,
      O => \int_isr[1]_i_1_n_2\
    );
\int_isr_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \int_isr[0]_i_1_n_2\,
      Q => \int_isr_reg_n_2_[0]\,
      R => SR(0)
    );
\int_isr_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \int_isr[1]_i_1_n_2\,
      Q => p_1_in,
      R => SR(0)
    );
\int_num_items[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(0),
      I1 => s_axi_control_WSTRB(0),
      I2 => \^q\(0),
      O => int_num_items0(0)
    );
\int_num_items[10]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(10),
      I1 => s_axi_control_WSTRB(1),
      I2 => \^q\(10),
      O => int_num_items0(10)
    );
\int_num_items[11]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(11),
      I1 => s_axi_control_WSTRB(1),
      I2 => \^q\(11),
      O => int_num_items0(11)
    );
\int_num_items[12]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(12),
      I1 => s_axi_control_WSTRB(1),
      I2 => \^q\(12),
      O => int_num_items0(12)
    );
\int_num_items[13]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(13),
      I1 => s_axi_control_WSTRB(1),
      I2 => \^q\(13),
      O => int_num_items0(13)
    );
\int_num_items[14]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(14),
      I1 => s_axi_control_WSTRB(1),
      I2 => \^q\(14),
      O => int_num_items0(14)
    );
\int_num_items[15]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(15),
      I1 => s_axi_control_WSTRB(1),
      I2 => \^q\(15),
      O => int_num_items0(15)
    );
\int_num_items[16]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(16),
      I1 => s_axi_control_WSTRB(2),
      I2 => \^q\(16),
      O => int_num_items0(16)
    );
\int_num_items[17]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(17),
      I1 => s_axi_control_WSTRB(2),
      I2 => \^q\(17),
      O => int_num_items0(17)
    );
\int_num_items[18]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(18),
      I1 => s_axi_control_WSTRB(2),
      I2 => \^q\(18),
      O => int_num_items0(18)
    );
\int_num_items[19]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(19),
      I1 => s_axi_control_WSTRB(2),
      I2 => \^q\(19),
      O => int_num_items0(19)
    );
\int_num_items[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(1),
      I1 => s_axi_control_WSTRB(0),
      I2 => \^q\(1),
      O => int_num_items0(1)
    );
\int_num_items[20]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(20),
      I1 => s_axi_control_WSTRB(2),
      I2 => \^q\(20),
      O => int_num_items0(20)
    );
\int_num_items[21]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(21),
      I1 => s_axi_control_WSTRB(2),
      I2 => \^q\(21),
      O => int_num_items0(21)
    );
\int_num_items[22]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(22),
      I1 => s_axi_control_WSTRB(2),
      I2 => \^q\(22),
      O => int_num_items0(22)
    );
\int_num_items[23]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(23),
      I1 => s_axi_control_WSTRB(2),
      I2 => \^q\(23),
      O => int_num_items0(23)
    );
\int_num_items[24]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(24),
      I1 => s_axi_control_WSTRB(3),
      I2 => \^q\(24),
      O => int_num_items0(24)
    );
\int_num_items[25]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(25),
      I1 => s_axi_control_WSTRB(3),
      I2 => \^q\(25),
      O => int_num_items0(25)
    );
\int_num_items[26]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(26),
      I1 => s_axi_control_WSTRB(3),
      I2 => \^q\(26),
      O => int_num_items0(26)
    );
\int_num_items[27]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(27),
      I1 => s_axi_control_WSTRB(3),
      I2 => \^q\(27),
      O => int_num_items0(27)
    );
\int_num_items[28]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(28),
      I1 => s_axi_control_WSTRB(3),
      I2 => \^q\(28),
      O => int_num_items0(28)
    );
\int_num_items[29]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(29),
      I1 => s_axi_control_WSTRB(3),
      I2 => \^q\(29),
      O => int_num_items0(29)
    );
\int_num_items[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(2),
      I1 => s_axi_control_WSTRB(0),
      I2 => \^q\(2),
      O => int_num_items0(2)
    );
\int_num_items[30]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(30),
      I1 => s_axi_control_WSTRB(3),
      I2 => \^q\(30),
      O => int_num_items0(30)
    );
\int_num_items[31]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0200"
    )
        port map (
      I0 => \int_num_items[31]_i_3_n_2\,
      I1 => \waddr_reg_n_2_[2]\,
      I2 => \waddr_reg_n_2_[3]\,
      I3 => \waddr_reg_n_2_[5]\,
      O => \int_num_items[31]_i_1_n_2\
    );
\int_num_items[31]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(31),
      I1 => s_axi_control_WSTRB(3),
      I2 => \^q\(31),
      O => int_num_items0(31)
    );
\int_num_items[31]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000040"
    )
        port map (
      I0 => \waddr_reg_n_2_[4]\,
      I1 => \^fsm_onehot_wstate_reg[2]_0\,
      I2 => s_axi_control_WVALID,
      I3 => \waddr_reg_n_2_[1]\,
      I4 => \waddr_reg_n_2_[0]\,
      O => \int_num_items[31]_i_3_n_2\
    );
\int_num_items[3]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(3),
      I1 => s_axi_control_WSTRB(0),
      I2 => \^q\(3),
      O => int_num_items0(3)
    );
\int_num_items[4]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(4),
      I1 => s_axi_control_WSTRB(0),
      I2 => \^q\(4),
      O => int_num_items0(4)
    );
\int_num_items[5]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(5),
      I1 => s_axi_control_WSTRB(0),
      I2 => \^q\(5),
      O => int_num_items0(5)
    );
\int_num_items[6]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(6),
      I1 => s_axi_control_WSTRB(0),
      I2 => \^q\(6),
      O => int_num_items0(6)
    );
\int_num_items[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(7),
      I1 => s_axi_control_WSTRB(0),
      I2 => \^q\(7),
      O => int_num_items0(7)
    );
\int_num_items[8]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(8),
      I1 => s_axi_control_WSTRB(1),
      I2 => \^q\(8),
      O => int_num_items0(8)
    );
\int_num_items[9]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(9),
      I1 => s_axi_control_WSTRB(1),
      I2 => \^q\(9),
      O => int_num_items0(9)
    );
\int_num_items_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_num_items[31]_i_1_n_2\,
      D => int_num_items0(0),
      Q => \^q\(0),
      R => SR(0)
    );
\int_num_items_reg[10]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_num_items[31]_i_1_n_2\,
      D => int_num_items0(10),
      Q => \^q\(10),
      R => SR(0)
    );
\int_num_items_reg[11]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_num_items[31]_i_1_n_2\,
      D => int_num_items0(11),
      Q => \^q\(11),
      R => SR(0)
    );
\int_num_items_reg[12]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_num_items[31]_i_1_n_2\,
      D => int_num_items0(12),
      Q => \^q\(12),
      R => SR(0)
    );
\int_num_items_reg[13]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_num_items[31]_i_1_n_2\,
      D => int_num_items0(13),
      Q => \^q\(13),
      R => SR(0)
    );
\int_num_items_reg[14]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_num_items[31]_i_1_n_2\,
      D => int_num_items0(14),
      Q => \^q\(14),
      R => SR(0)
    );
\int_num_items_reg[15]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_num_items[31]_i_1_n_2\,
      D => int_num_items0(15),
      Q => \^q\(15),
      R => SR(0)
    );
\int_num_items_reg[16]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_num_items[31]_i_1_n_2\,
      D => int_num_items0(16),
      Q => \^q\(16),
      R => SR(0)
    );
\int_num_items_reg[17]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_num_items[31]_i_1_n_2\,
      D => int_num_items0(17),
      Q => \^q\(17),
      R => SR(0)
    );
\int_num_items_reg[18]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_num_items[31]_i_1_n_2\,
      D => int_num_items0(18),
      Q => \^q\(18),
      R => SR(0)
    );
\int_num_items_reg[19]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_num_items[31]_i_1_n_2\,
      D => int_num_items0(19),
      Q => \^q\(19),
      R => SR(0)
    );
\int_num_items_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_num_items[31]_i_1_n_2\,
      D => int_num_items0(1),
      Q => \^q\(1),
      R => SR(0)
    );
\int_num_items_reg[20]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_num_items[31]_i_1_n_2\,
      D => int_num_items0(20),
      Q => \^q\(20),
      R => SR(0)
    );
\int_num_items_reg[21]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_num_items[31]_i_1_n_2\,
      D => int_num_items0(21),
      Q => \^q\(21),
      R => SR(0)
    );
\int_num_items_reg[22]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_num_items[31]_i_1_n_2\,
      D => int_num_items0(22),
      Q => \^q\(22),
      R => SR(0)
    );
\int_num_items_reg[23]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_num_items[31]_i_1_n_2\,
      D => int_num_items0(23),
      Q => \^q\(23),
      R => SR(0)
    );
\int_num_items_reg[24]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_num_items[31]_i_1_n_2\,
      D => int_num_items0(24),
      Q => \^q\(24),
      R => SR(0)
    );
\int_num_items_reg[25]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_num_items[31]_i_1_n_2\,
      D => int_num_items0(25),
      Q => \^q\(25),
      R => SR(0)
    );
\int_num_items_reg[26]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_num_items[31]_i_1_n_2\,
      D => int_num_items0(26),
      Q => \^q\(26),
      R => SR(0)
    );
\int_num_items_reg[27]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_num_items[31]_i_1_n_2\,
      D => int_num_items0(27),
      Q => \^q\(27),
      R => SR(0)
    );
\int_num_items_reg[28]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_num_items[31]_i_1_n_2\,
      D => int_num_items0(28),
      Q => \^q\(28),
      R => SR(0)
    );
\int_num_items_reg[29]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_num_items[31]_i_1_n_2\,
      D => int_num_items0(29),
      Q => \^q\(29),
      R => SR(0)
    );
\int_num_items_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_num_items[31]_i_1_n_2\,
      D => int_num_items0(2),
      Q => \^q\(2),
      R => SR(0)
    );
\int_num_items_reg[30]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_num_items[31]_i_1_n_2\,
      D => int_num_items0(30),
      Q => \^q\(30),
      R => SR(0)
    );
\int_num_items_reg[31]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_num_items[31]_i_1_n_2\,
      D => int_num_items0(31),
      Q => \^q\(31),
      R => SR(0)
    );
\int_num_items_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_num_items[31]_i_1_n_2\,
      D => int_num_items0(3),
      Q => \^q\(3),
      R => SR(0)
    );
\int_num_items_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_num_items[31]_i_1_n_2\,
      D => int_num_items0(4),
      Q => \^q\(4),
      R => SR(0)
    );
\int_num_items_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_num_items[31]_i_1_n_2\,
      D => int_num_items0(5),
      Q => \^q\(5),
      R => SR(0)
    );
\int_num_items_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_num_items[31]_i_1_n_2\,
      D => int_num_items0(6),
      Q => \^q\(6),
      R => SR(0)
    );
\int_num_items_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_num_items[31]_i_1_n_2\,
      D => int_num_items0(7),
      Q => \^q\(7),
      R => SR(0)
    );
\int_num_items_reg[8]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_num_items[31]_i_1_n_2\,
      D => int_num_items0(8),
      Q => \^q\(8),
      R => SR(0)
    );
\int_num_items_reg[9]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_num_items[31]_i_1_n_2\,
      D => int_num_items0(9),
      Q => \^q\(9),
      R => SR(0)
    );
\int_out_buf[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(0),
      I1 => s_axi_control_WSTRB(0),
      I2 => \int_out_buf_reg_n_2_[0]\,
      O => int_out_buf0(0)
    );
\int_out_buf[10]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(10),
      I1 => s_axi_control_WSTRB(1),
      I2 => \^int_out_buf_reg[31]_0\(8),
      O => int_out_buf0(10)
    );
\int_out_buf[11]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(11),
      I1 => s_axi_control_WSTRB(1),
      I2 => \^int_out_buf_reg[31]_0\(9),
      O => int_out_buf0(11)
    );
\int_out_buf[12]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(12),
      I1 => s_axi_control_WSTRB(1),
      I2 => \^int_out_buf_reg[31]_0\(10),
      O => int_out_buf0(12)
    );
\int_out_buf[13]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(13),
      I1 => s_axi_control_WSTRB(1),
      I2 => \^int_out_buf_reg[31]_0\(11),
      O => int_out_buf0(13)
    );
\int_out_buf[14]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(14),
      I1 => s_axi_control_WSTRB(1),
      I2 => \^int_out_buf_reg[31]_0\(12),
      O => int_out_buf0(14)
    );
\int_out_buf[15]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(15),
      I1 => s_axi_control_WSTRB(1),
      I2 => \^int_out_buf_reg[31]_0\(13),
      O => int_out_buf0(15)
    );
\int_out_buf[16]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(16),
      I1 => s_axi_control_WSTRB(2),
      I2 => \^int_out_buf_reg[31]_0\(14),
      O => int_out_buf0(16)
    );
\int_out_buf[17]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(17),
      I1 => s_axi_control_WSTRB(2),
      I2 => \^int_out_buf_reg[31]_0\(15),
      O => int_out_buf0(17)
    );
\int_out_buf[18]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(18),
      I1 => s_axi_control_WSTRB(2),
      I2 => \^int_out_buf_reg[31]_0\(16),
      O => int_out_buf0(18)
    );
\int_out_buf[19]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(19),
      I1 => s_axi_control_WSTRB(2),
      I2 => \^int_out_buf_reg[31]_0\(17),
      O => int_out_buf0(19)
    );
\int_out_buf[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(1),
      I1 => s_axi_control_WSTRB(0),
      I2 => \int_out_buf_reg_n_2_[1]\,
      O => int_out_buf0(1)
    );
\int_out_buf[20]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(20),
      I1 => s_axi_control_WSTRB(2),
      I2 => \^int_out_buf_reg[31]_0\(18),
      O => int_out_buf0(20)
    );
\int_out_buf[21]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(21),
      I1 => s_axi_control_WSTRB(2),
      I2 => \^int_out_buf_reg[31]_0\(19),
      O => int_out_buf0(21)
    );
\int_out_buf[22]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(22),
      I1 => s_axi_control_WSTRB(2),
      I2 => \^int_out_buf_reg[31]_0\(20),
      O => int_out_buf0(22)
    );
\int_out_buf[23]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(23),
      I1 => s_axi_control_WSTRB(2),
      I2 => \^int_out_buf_reg[31]_0\(21),
      O => int_out_buf0(23)
    );
\int_out_buf[24]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(24),
      I1 => s_axi_control_WSTRB(3),
      I2 => \^int_out_buf_reg[31]_0\(22),
      O => int_out_buf0(24)
    );
\int_out_buf[25]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(25),
      I1 => s_axi_control_WSTRB(3),
      I2 => \^int_out_buf_reg[31]_0\(23),
      O => int_out_buf0(25)
    );
\int_out_buf[26]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(26),
      I1 => s_axi_control_WSTRB(3),
      I2 => \^int_out_buf_reg[31]_0\(24),
      O => int_out_buf0(26)
    );
\int_out_buf[27]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(27),
      I1 => s_axi_control_WSTRB(3),
      I2 => \^int_out_buf_reg[31]_0\(25),
      O => int_out_buf0(27)
    );
\int_out_buf[28]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(28),
      I1 => s_axi_control_WSTRB(3),
      I2 => \^int_out_buf_reg[31]_0\(26),
      O => int_out_buf0(28)
    );
\int_out_buf[29]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(29),
      I1 => s_axi_control_WSTRB(3),
      I2 => \^int_out_buf_reg[31]_0\(27),
      O => int_out_buf0(29)
    );
\int_out_buf[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(2),
      I1 => s_axi_control_WSTRB(0),
      I2 => \^int_out_buf_reg[31]_0\(0),
      O => int_out_buf0(2)
    );
\int_out_buf[30]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(30),
      I1 => s_axi_control_WSTRB(3),
      I2 => \^int_out_buf_reg[31]_0\(28),
      O => int_out_buf0(30)
    );
\int_out_buf[31]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => \int_in_buf[31]_i_3_n_2\,
      I1 => \waddr_reg_n_2_[3]\,
      I2 => \waddr_reg_n_2_[2]\,
      O => \int_out_buf[31]_i_1_n_2\
    );
\int_out_buf[31]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(31),
      I1 => s_axi_control_WSTRB(3),
      I2 => \^int_out_buf_reg[31]_0\(29),
      O => int_out_buf0(31)
    );
\int_out_buf[3]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(3),
      I1 => s_axi_control_WSTRB(0),
      I2 => \^int_out_buf_reg[31]_0\(1),
      O => int_out_buf0(3)
    );
\int_out_buf[4]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(4),
      I1 => s_axi_control_WSTRB(0),
      I2 => \^int_out_buf_reg[31]_0\(2),
      O => int_out_buf0(4)
    );
\int_out_buf[5]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(5),
      I1 => s_axi_control_WSTRB(0),
      I2 => \^int_out_buf_reg[31]_0\(3),
      O => int_out_buf0(5)
    );
\int_out_buf[6]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(6),
      I1 => s_axi_control_WSTRB(0),
      I2 => \^int_out_buf_reg[31]_0\(4),
      O => int_out_buf0(6)
    );
\int_out_buf[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(7),
      I1 => s_axi_control_WSTRB(0),
      I2 => \^int_out_buf_reg[31]_0\(5),
      O => int_out_buf0(7)
    );
\int_out_buf[8]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(8),
      I1 => s_axi_control_WSTRB(1),
      I2 => \^int_out_buf_reg[31]_0\(6),
      O => int_out_buf0(8)
    );
\int_out_buf[9]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_control_WDATA(9),
      I1 => s_axi_control_WSTRB(1),
      I2 => \^int_out_buf_reg[31]_0\(7),
      O => int_out_buf0(9)
    );
\int_out_buf_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_out_buf[31]_i_1_n_2\,
      D => int_out_buf0(0),
      Q => \int_out_buf_reg_n_2_[0]\,
      R => SR(0)
    );
\int_out_buf_reg[10]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_out_buf[31]_i_1_n_2\,
      D => int_out_buf0(10),
      Q => \^int_out_buf_reg[31]_0\(8),
      R => SR(0)
    );
\int_out_buf_reg[11]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_out_buf[31]_i_1_n_2\,
      D => int_out_buf0(11),
      Q => \^int_out_buf_reg[31]_0\(9),
      R => SR(0)
    );
\int_out_buf_reg[12]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_out_buf[31]_i_1_n_2\,
      D => int_out_buf0(12),
      Q => \^int_out_buf_reg[31]_0\(10),
      R => SR(0)
    );
\int_out_buf_reg[13]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_out_buf[31]_i_1_n_2\,
      D => int_out_buf0(13),
      Q => \^int_out_buf_reg[31]_0\(11),
      R => SR(0)
    );
\int_out_buf_reg[14]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_out_buf[31]_i_1_n_2\,
      D => int_out_buf0(14),
      Q => \^int_out_buf_reg[31]_0\(12),
      R => SR(0)
    );
\int_out_buf_reg[15]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_out_buf[31]_i_1_n_2\,
      D => int_out_buf0(15),
      Q => \^int_out_buf_reg[31]_0\(13),
      R => SR(0)
    );
\int_out_buf_reg[16]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_out_buf[31]_i_1_n_2\,
      D => int_out_buf0(16),
      Q => \^int_out_buf_reg[31]_0\(14),
      R => SR(0)
    );
\int_out_buf_reg[17]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_out_buf[31]_i_1_n_2\,
      D => int_out_buf0(17),
      Q => \^int_out_buf_reg[31]_0\(15),
      R => SR(0)
    );
\int_out_buf_reg[18]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_out_buf[31]_i_1_n_2\,
      D => int_out_buf0(18),
      Q => \^int_out_buf_reg[31]_0\(16),
      R => SR(0)
    );
\int_out_buf_reg[19]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_out_buf[31]_i_1_n_2\,
      D => int_out_buf0(19),
      Q => \^int_out_buf_reg[31]_0\(17),
      R => SR(0)
    );
\int_out_buf_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_out_buf[31]_i_1_n_2\,
      D => int_out_buf0(1),
      Q => \int_out_buf_reg_n_2_[1]\,
      R => SR(0)
    );
\int_out_buf_reg[20]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_out_buf[31]_i_1_n_2\,
      D => int_out_buf0(20),
      Q => \^int_out_buf_reg[31]_0\(18),
      R => SR(0)
    );
\int_out_buf_reg[21]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_out_buf[31]_i_1_n_2\,
      D => int_out_buf0(21),
      Q => \^int_out_buf_reg[31]_0\(19),
      R => SR(0)
    );
\int_out_buf_reg[22]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_out_buf[31]_i_1_n_2\,
      D => int_out_buf0(22),
      Q => \^int_out_buf_reg[31]_0\(20),
      R => SR(0)
    );
\int_out_buf_reg[23]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_out_buf[31]_i_1_n_2\,
      D => int_out_buf0(23),
      Q => \^int_out_buf_reg[31]_0\(21),
      R => SR(0)
    );
\int_out_buf_reg[24]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_out_buf[31]_i_1_n_2\,
      D => int_out_buf0(24),
      Q => \^int_out_buf_reg[31]_0\(22),
      R => SR(0)
    );
\int_out_buf_reg[25]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_out_buf[31]_i_1_n_2\,
      D => int_out_buf0(25),
      Q => \^int_out_buf_reg[31]_0\(23),
      R => SR(0)
    );
\int_out_buf_reg[26]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_out_buf[31]_i_1_n_2\,
      D => int_out_buf0(26),
      Q => \^int_out_buf_reg[31]_0\(24),
      R => SR(0)
    );
\int_out_buf_reg[27]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_out_buf[31]_i_1_n_2\,
      D => int_out_buf0(27),
      Q => \^int_out_buf_reg[31]_0\(25),
      R => SR(0)
    );
\int_out_buf_reg[28]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_out_buf[31]_i_1_n_2\,
      D => int_out_buf0(28),
      Q => \^int_out_buf_reg[31]_0\(26),
      R => SR(0)
    );
\int_out_buf_reg[29]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_out_buf[31]_i_1_n_2\,
      D => int_out_buf0(29),
      Q => \^int_out_buf_reg[31]_0\(27),
      R => SR(0)
    );
\int_out_buf_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_out_buf[31]_i_1_n_2\,
      D => int_out_buf0(2),
      Q => \^int_out_buf_reg[31]_0\(0),
      R => SR(0)
    );
\int_out_buf_reg[30]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_out_buf[31]_i_1_n_2\,
      D => int_out_buf0(30),
      Q => \^int_out_buf_reg[31]_0\(28),
      R => SR(0)
    );
\int_out_buf_reg[31]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_out_buf[31]_i_1_n_2\,
      D => int_out_buf0(31),
      Q => \^int_out_buf_reg[31]_0\(29),
      R => SR(0)
    );
\int_out_buf_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_out_buf[31]_i_1_n_2\,
      D => int_out_buf0(3),
      Q => \^int_out_buf_reg[31]_0\(1),
      R => SR(0)
    );
\int_out_buf_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_out_buf[31]_i_1_n_2\,
      D => int_out_buf0(4),
      Q => \^int_out_buf_reg[31]_0\(2),
      R => SR(0)
    );
\int_out_buf_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_out_buf[31]_i_1_n_2\,
      D => int_out_buf0(5),
      Q => \^int_out_buf_reg[31]_0\(3),
      R => SR(0)
    );
\int_out_buf_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_out_buf[31]_i_1_n_2\,
      D => int_out_buf0(6),
      Q => \^int_out_buf_reg[31]_0\(4),
      R => SR(0)
    );
\int_out_buf_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_out_buf[31]_i_1_n_2\,
      D => int_out_buf0(7),
      Q => \^int_out_buf_reg[31]_0\(5),
      R => SR(0)
    );
\int_out_buf_reg[8]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_out_buf[31]_i_1_n_2\,
      D => int_out_buf0(8),
      Q => \^int_out_buf_reg[31]_0\(6),
      R => SR(0)
    );
\int_out_buf_reg[9]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \int_out_buf[31]_i_1_n_2\,
      D => int_out_buf0(9),
      Q => \^int_out_buf_reg[31]_0\(7),
      R => SR(0)
    );
interrupt_INST_0: unisim.vcomponents.LUT3
    generic map(
      INIT => X"A8"
    )
        port map (
      I0 => int_gie_reg_n_2,
      I1 => p_1_in,
      I2 => \int_isr_reg_n_2_[0]\,
      O => interrupt
    );
\num_items_read_reg_222[31]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \^ap_start\,
      I1 => int_ap_start_reg_0(0),
      O => \^e\(0)
    );
\rdata[0]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"AFA0C0C0"
    )
        port map (
      I0 => \int_in_buf_reg_n_2_[0]\,
      I1 => \int_out_buf_reg_n_2_[0]\,
      I2 => \rdata[31]_i_3_n_2\,
      I3 => \^q\(0),
      I4 => \rdata[31]_i_4_n_2\,
      O => \rdata[0]_i_2_n_2\
    );
\rdata[0]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \^ap_start\,
      I1 => int_gie_reg_n_2,
      I2 => \rdata[31]_i_3_n_2\,
      I3 => \int_ier_reg_n_2_[0]\,
      I4 => \rdata[31]_i_4_n_2\,
      I5 => \int_isr_reg_n_2_[0]\,
      O => \rdata[0]_i_3_n_2\
    );
\rdata[10]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000AFC0A0C0"
    )
        port map (
      I0 => \^int_in_buf_reg[31]_0\(8),
      I1 => \^int_out_buf_reg[31]_0\(8),
      I2 => \rdata[31]_i_3_n_2\,
      I3 => \rdata[31]_i_4_n_2\,
      I4 => \^q\(10),
      I5 => \rdata[31]_i_5_n_2\,
      O => rdata(10)
    );
\rdata[11]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000AFC0A0C0"
    )
        port map (
      I0 => \^int_in_buf_reg[31]_0\(9),
      I1 => \^int_out_buf_reg[31]_0\(9),
      I2 => \rdata[31]_i_3_n_2\,
      I3 => \rdata[31]_i_4_n_2\,
      I4 => \^q\(11),
      I5 => \rdata[31]_i_5_n_2\,
      O => rdata(11)
    );
\rdata[12]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000AFC0A0C0"
    )
        port map (
      I0 => \^int_in_buf_reg[31]_0\(10),
      I1 => \^int_out_buf_reg[31]_0\(10),
      I2 => \rdata[31]_i_3_n_2\,
      I3 => \rdata[31]_i_4_n_2\,
      I4 => \^q\(12),
      I5 => \rdata[31]_i_5_n_2\,
      O => rdata(12)
    );
\rdata[13]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000AFC0A0C0"
    )
        port map (
      I0 => \^int_in_buf_reg[31]_0\(11),
      I1 => \^int_out_buf_reg[31]_0\(11),
      I2 => \rdata[31]_i_3_n_2\,
      I3 => \rdata[31]_i_4_n_2\,
      I4 => \^q\(13),
      I5 => \rdata[31]_i_5_n_2\,
      O => rdata(13)
    );
\rdata[14]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000AFC0A0C0"
    )
        port map (
      I0 => \^int_in_buf_reg[31]_0\(12),
      I1 => \^int_out_buf_reg[31]_0\(12),
      I2 => \rdata[31]_i_3_n_2\,
      I3 => \rdata[31]_i_4_n_2\,
      I4 => \^q\(14),
      I5 => \rdata[31]_i_5_n_2\,
      O => rdata(14)
    );
\rdata[15]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000AFC0A0C0"
    )
        port map (
      I0 => \^int_in_buf_reg[31]_0\(13),
      I1 => \^int_out_buf_reg[31]_0\(13),
      I2 => \rdata[31]_i_3_n_2\,
      I3 => \rdata[31]_i_4_n_2\,
      I4 => \^q\(15),
      I5 => \rdata[31]_i_5_n_2\,
      O => rdata(15)
    );
\rdata[16]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000AFC0A0C0"
    )
        port map (
      I0 => \^int_in_buf_reg[31]_0\(14),
      I1 => \^int_out_buf_reg[31]_0\(14),
      I2 => \rdata[31]_i_3_n_2\,
      I3 => \rdata[31]_i_4_n_2\,
      I4 => \^q\(16),
      I5 => \rdata[31]_i_5_n_2\,
      O => rdata(16)
    );
\rdata[17]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000AFC0A0C0"
    )
        port map (
      I0 => \^int_in_buf_reg[31]_0\(15),
      I1 => \^int_out_buf_reg[31]_0\(15),
      I2 => \rdata[31]_i_3_n_2\,
      I3 => \rdata[31]_i_4_n_2\,
      I4 => \^q\(17),
      I5 => \rdata[31]_i_5_n_2\,
      O => rdata(17)
    );
\rdata[18]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000AFC0A0C0"
    )
        port map (
      I0 => \^int_in_buf_reg[31]_0\(16),
      I1 => \^int_out_buf_reg[31]_0\(16),
      I2 => \rdata[31]_i_3_n_2\,
      I3 => \rdata[31]_i_4_n_2\,
      I4 => \^q\(18),
      I5 => \rdata[31]_i_5_n_2\,
      O => rdata(18)
    );
\rdata[19]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000AFC0A0C0"
    )
        port map (
      I0 => \^int_in_buf_reg[31]_0\(17),
      I1 => \^int_out_buf_reg[31]_0\(17),
      I2 => \rdata[31]_i_3_n_2\,
      I3 => \rdata[31]_i_4_n_2\,
      I4 => \^q\(19),
      I5 => \rdata[31]_i_5_n_2\,
      O => rdata(19)
    );
\rdata[1]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"AFA0C0C0"
    )
        port map (
      I0 => \int_in_buf_reg_n_2_[1]\,
      I1 => \int_out_buf_reg_n_2_[1]\,
      I2 => \rdata[31]_i_3_n_2\,
      I3 => \^q\(1),
      I4 => \rdata[31]_i_4_n_2\,
      O => \rdata[1]_i_2_n_2\
    );
\rdata[1]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B833B800"
    )
        port map (
      I0 => data0(1),
      I1 => \rdata[31]_i_3_n_2\,
      I2 => p_0_in,
      I3 => \rdata[31]_i_4_n_2\,
      I4 => p_1_in,
      O => \rdata[1]_i_3_n_2\
    );
\rdata[20]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000AFC0A0C0"
    )
        port map (
      I0 => \^int_in_buf_reg[31]_0\(18),
      I1 => \^int_out_buf_reg[31]_0\(18),
      I2 => \rdata[31]_i_3_n_2\,
      I3 => \rdata[31]_i_4_n_2\,
      I4 => \^q\(20),
      I5 => \rdata[31]_i_5_n_2\,
      O => rdata(20)
    );
\rdata[21]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000AFC0A0C0"
    )
        port map (
      I0 => \^int_in_buf_reg[31]_0\(19),
      I1 => \^int_out_buf_reg[31]_0\(19),
      I2 => \rdata[31]_i_3_n_2\,
      I3 => \rdata[31]_i_4_n_2\,
      I4 => \^q\(21),
      I5 => \rdata[31]_i_5_n_2\,
      O => rdata(21)
    );
\rdata[22]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000AFC0A0C0"
    )
        port map (
      I0 => \^int_in_buf_reg[31]_0\(20),
      I1 => \^int_out_buf_reg[31]_0\(20),
      I2 => \rdata[31]_i_3_n_2\,
      I3 => \rdata[31]_i_4_n_2\,
      I4 => \^q\(22),
      I5 => \rdata[31]_i_5_n_2\,
      O => rdata(22)
    );
\rdata[23]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000AFC0A0C0"
    )
        port map (
      I0 => \^int_in_buf_reg[31]_0\(21),
      I1 => \^int_out_buf_reg[31]_0\(21),
      I2 => \rdata[31]_i_3_n_2\,
      I3 => \rdata[31]_i_4_n_2\,
      I4 => \^q\(23),
      I5 => \rdata[31]_i_5_n_2\,
      O => rdata(23)
    );
\rdata[24]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000AFC0A0C0"
    )
        port map (
      I0 => \^int_in_buf_reg[31]_0\(22),
      I1 => \^int_out_buf_reg[31]_0\(22),
      I2 => \rdata[31]_i_3_n_2\,
      I3 => \rdata[31]_i_4_n_2\,
      I4 => \^q\(24),
      I5 => \rdata[31]_i_5_n_2\,
      O => rdata(24)
    );
\rdata[25]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000AFC0A0C0"
    )
        port map (
      I0 => \^int_in_buf_reg[31]_0\(23),
      I1 => \^int_out_buf_reg[31]_0\(23),
      I2 => \rdata[31]_i_3_n_2\,
      I3 => \rdata[31]_i_4_n_2\,
      I4 => \^q\(25),
      I5 => \rdata[31]_i_5_n_2\,
      O => rdata(25)
    );
\rdata[26]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000AFC0A0C0"
    )
        port map (
      I0 => \^int_in_buf_reg[31]_0\(24),
      I1 => \^int_out_buf_reg[31]_0\(24),
      I2 => \rdata[31]_i_3_n_2\,
      I3 => \rdata[31]_i_4_n_2\,
      I4 => \^q\(26),
      I5 => \rdata[31]_i_5_n_2\,
      O => rdata(26)
    );
\rdata[27]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000AFC0A0C0"
    )
        port map (
      I0 => \^int_in_buf_reg[31]_0\(25),
      I1 => \^int_out_buf_reg[31]_0\(25),
      I2 => \rdata[31]_i_3_n_2\,
      I3 => \rdata[31]_i_4_n_2\,
      I4 => \^q\(27),
      I5 => \rdata[31]_i_5_n_2\,
      O => rdata(27)
    );
\rdata[28]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000AFC0A0C0"
    )
        port map (
      I0 => \^int_in_buf_reg[31]_0\(26),
      I1 => \^int_out_buf_reg[31]_0\(26),
      I2 => \rdata[31]_i_3_n_2\,
      I3 => \rdata[31]_i_4_n_2\,
      I4 => \^q\(28),
      I5 => \rdata[31]_i_5_n_2\,
      O => rdata(28)
    );
\rdata[29]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000AFC0A0C0"
    )
        port map (
      I0 => \^int_in_buf_reg[31]_0\(27),
      I1 => \^int_out_buf_reg[31]_0\(27),
      I2 => \rdata[31]_i_3_n_2\,
      I3 => \rdata[31]_i_4_n_2\,
      I4 => \^q\(29),
      I5 => \rdata[31]_i_5_n_2\,
      O => rdata(29)
    );
\rdata[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B833B80030003000"
    )
        port map (
      I0 => data0(2),
      I1 => \rdata[31]_i_5_n_2\,
      I2 => \rdata[2]_i_2_n_2\,
      I3 => \rdata[31]_i_3_n_2\,
      I4 => \^q\(2),
      I5 => \rdata[31]_i_4_n_2\,
      O => rdata(2)
    );
\rdata[2]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \^int_in_buf_reg[31]_0\(0),
      I1 => \rdata[31]_i_4_n_2\,
      I2 => \^int_out_buf_reg[31]_0\(0),
      O => \rdata[2]_i_2_n_2\
    );
\rdata[30]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000AFC0A0C0"
    )
        port map (
      I0 => \^int_in_buf_reg[31]_0\(28),
      I1 => \^int_out_buf_reg[31]_0\(28),
      I2 => \rdata[31]_i_3_n_2\,
      I3 => \rdata[31]_i_4_n_2\,
      I4 => \^q\(30),
      I5 => \rdata[31]_i_5_n_2\,
      O => rdata(30)
    );
\rdata[31]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \^fsm_onehot_rstate_reg[1]_0\,
      I1 => s_axi_control_ARVALID,
      O => ar_hs
    );
\rdata[31]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000AFC0A0C0"
    )
        port map (
      I0 => \^int_in_buf_reg[31]_0\(29),
      I1 => \^int_out_buf_reg[31]_0\(29),
      I2 => \rdata[31]_i_3_n_2\,
      I3 => \rdata[31]_i_4_n_2\,
      I4 => \^q\(31),
      I5 => \rdata[31]_i_5_n_2\,
      O => rdata(31)
    );
\rdata[31]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000101010001"
    )
        port map (
      I0 => s_axi_control_ARADDR(1),
      I1 => s_axi_control_ARADDR(0),
      I2 => s_axi_control_ARADDR(5),
      I3 => s_axi_control_ARADDR(3),
      I4 => s_axi_control_ARADDR(4),
      I5 => s_axi_control_ARADDR(2),
      O => \rdata[31]_i_3_n_2\
    );
\rdata[31]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000113"
    )
        port map (
      I0 => s_axi_control_ARADDR(5),
      I1 => s_axi_control_ARADDR(2),
      I2 => s_axi_control_ARADDR(4),
      I3 => s_axi_control_ARADDR(3),
      I4 => s_axi_control_ARADDR(1),
      I5 => s_axi_control_ARADDR(0),
      O => \rdata[31]_i_4_n_2\
    );
\rdata[31]_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0001"
    )
        port map (
      I0 => s_axi_control_ARADDR(1),
      I1 => s_axi_control_ARADDR(0),
      I2 => s_axi_control_ARADDR(5),
      I3 => s_axi_control_ARADDR(4),
      O => \rdata[31]_i_5_n_2\
    );
\rdata[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B833B80030003000"
    )
        port map (
      I0 => data0(3),
      I1 => \rdata[31]_i_5_n_2\,
      I2 => \rdata[3]_i_2_n_2\,
      I3 => \rdata[31]_i_3_n_2\,
      I4 => \^q\(3),
      I5 => \rdata[31]_i_4_n_2\,
      O => rdata(3)
    );
\rdata[3]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \^int_in_buf_reg[31]_0\(1),
      I1 => \rdata[31]_i_4_n_2\,
      I2 => \^int_out_buf_reg[31]_0\(1),
      O => \rdata[3]_i_2_n_2\
    );
\rdata[4]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000AFC0A0C0"
    )
        port map (
      I0 => \^int_in_buf_reg[31]_0\(2),
      I1 => \^int_out_buf_reg[31]_0\(2),
      I2 => \rdata[31]_i_3_n_2\,
      I3 => \rdata[31]_i_4_n_2\,
      I4 => \^q\(4),
      I5 => \rdata[31]_i_5_n_2\,
      O => rdata(4)
    );
\rdata[5]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000AFC0A0C0"
    )
        port map (
      I0 => \^int_in_buf_reg[31]_0\(3),
      I1 => \^int_out_buf_reg[31]_0\(3),
      I2 => \rdata[31]_i_3_n_2\,
      I3 => \rdata[31]_i_4_n_2\,
      I4 => \^q\(5),
      I5 => \rdata[31]_i_5_n_2\,
      O => rdata(5)
    );
\rdata[6]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000AFC0A0C0"
    )
        port map (
      I0 => \^int_in_buf_reg[31]_0\(4),
      I1 => \^int_out_buf_reg[31]_0\(4),
      I2 => \rdata[31]_i_3_n_2\,
      I3 => \rdata[31]_i_4_n_2\,
      I4 => \^q\(6),
      I5 => \rdata[31]_i_5_n_2\,
      O => rdata(6)
    );
\rdata[7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B833B80030003000"
    )
        port map (
      I0 => data0(7),
      I1 => \rdata[31]_i_5_n_2\,
      I2 => \rdata[7]_i_2_n_2\,
      I3 => \rdata[31]_i_3_n_2\,
      I4 => \^q\(7),
      I5 => \rdata[31]_i_4_n_2\,
      O => rdata(7)
    );
\rdata[7]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \^int_in_buf_reg[31]_0\(5),
      I1 => \rdata[31]_i_4_n_2\,
      I2 => \^int_out_buf_reg[31]_0\(5),
      O => \rdata[7]_i_2_n_2\
    );
\rdata[8]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000AFC0A0C0"
    )
        port map (
      I0 => \^int_in_buf_reg[31]_0\(6),
      I1 => \^int_out_buf_reg[31]_0\(6),
      I2 => \rdata[31]_i_3_n_2\,
      I3 => \rdata[31]_i_4_n_2\,
      I4 => \^q\(8),
      I5 => \rdata[31]_i_5_n_2\,
      O => rdata(8)
    );
\rdata[9]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000AFC0A0C0"
    )
        port map (
      I0 => \^int_in_buf_reg[31]_0\(7),
      I1 => \^int_out_buf_reg[31]_0\(7),
      I2 => \rdata[31]_i_3_n_2\,
      I3 => \rdata[31]_i_4_n_2\,
      I4 => \^q\(9),
      I5 => \rdata[31]_i_5_n_2\,
      O => rdata(9)
    );
\rdata_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(0),
      Q => s_axi_control_RDATA(0),
      R => '0'
    );
\rdata_reg[0]_i_1\: unisim.vcomponents.MUXF7
     port map (
      I0 => \rdata[0]_i_2_n_2\,
      I1 => \rdata[0]_i_3_n_2\,
      O => rdata(0),
      S => \rdata[31]_i_5_n_2\
    );
\rdata_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(10),
      Q => s_axi_control_RDATA(10),
      R => '0'
    );
\rdata_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(11),
      Q => s_axi_control_RDATA(11),
      R => '0'
    );
\rdata_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(12),
      Q => s_axi_control_RDATA(12),
      R => '0'
    );
\rdata_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(13),
      Q => s_axi_control_RDATA(13),
      R => '0'
    );
\rdata_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(14),
      Q => s_axi_control_RDATA(14),
      R => '0'
    );
\rdata_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(15),
      Q => s_axi_control_RDATA(15),
      R => '0'
    );
\rdata_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(16),
      Q => s_axi_control_RDATA(16),
      R => '0'
    );
\rdata_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(17),
      Q => s_axi_control_RDATA(17),
      R => '0'
    );
\rdata_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(18),
      Q => s_axi_control_RDATA(18),
      R => '0'
    );
\rdata_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(19),
      Q => s_axi_control_RDATA(19),
      R => '0'
    );
\rdata_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(1),
      Q => s_axi_control_RDATA(1),
      R => '0'
    );
\rdata_reg[1]_i_1\: unisim.vcomponents.MUXF7
     port map (
      I0 => \rdata[1]_i_2_n_2\,
      I1 => \rdata[1]_i_3_n_2\,
      O => rdata(1),
      S => \rdata[31]_i_5_n_2\
    );
\rdata_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(20),
      Q => s_axi_control_RDATA(20),
      R => '0'
    );
\rdata_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(21),
      Q => s_axi_control_RDATA(21),
      R => '0'
    );
\rdata_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(22),
      Q => s_axi_control_RDATA(22),
      R => '0'
    );
\rdata_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(23),
      Q => s_axi_control_RDATA(23),
      R => '0'
    );
\rdata_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(24),
      Q => s_axi_control_RDATA(24),
      R => '0'
    );
\rdata_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(25),
      Q => s_axi_control_RDATA(25),
      R => '0'
    );
\rdata_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(26),
      Q => s_axi_control_RDATA(26),
      R => '0'
    );
\rdata_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(27),
      Q => s_axi_control_RDATA(27),
      R => '0'
    );
\rdata_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(28),
      Q => s_axi_control_RDATA(28),
      R => '0'
    );
\rdata_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(29),
      Q => s_axi_control_RDATA(29),
      R => '0'
    );
\rdata_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(2),
      Q => s_axi_control_RDATA(2),
      R => '0'
    );
\rdata_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(30),
      Q => s_axi_control_RDATA(30),
      R => '0'
    );
\rdata_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(31),
      Q => s_axi_control_RDATA(31),
      R => '0'
    );
\rdata_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(3),
      Q => s_axi_control_RDATA(3),
      R => '0'
    );
\rdata_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(4),
      Q => s_axi_control_RDATA(4),
      R => '0'
    );
\rdata_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(5),
      Q => s_axi_control_RDATA(5),
      R => '0'
    );
\rdata_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(6),
      Q => s_axi_control_RDATA(6),
      R => '0'
    );
\rdata_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(7),
      Q => s_axi_control_RDATA(7),
      R => '0'
    );
\rdata_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(8),
      Q => s_axi_control_RDATA(8),
      R => '0'
    );
\rdata_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ar_hs,
      D => rdata(9),
      Q => s_axi_control_RDATA(9),
      R => '0'
    );
\waddr[5]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => s_axi_control_AWVALID,
      I1 => \^fsm_onehot_wstate_reg[1]_0\,
      O => waddr
    );
\waddr_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => waddr,
      D => s_axi_control_AWADDR(0),
      Q => \waddr_reg_n_2_[0]\,
      R => '0'
    );
\waddr_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => waddr,
      D => s_axi_control_AWADDR(1),
      Q => \waddr_reg_n_2_[1]\,
      R => '0'
    );
\waddr_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => waddr,
      D => s_axi_control_AWADDR(2),
      Q => \waddr_reg_n_2_[2]\,
      R => '0'
    );
\waddr_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => waddr,
      D => s_axi_control_AWADDR(3),
      Q => \waddr_reg_n_2_[3]\,
      R => '0'
    );
\waddr_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => waddr,
      D => s_axi_control_AWADDR(4),
      Q => \waddr_reg_n_2_[4]\,
      R => '0'
    );
\waddr_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => waddr,
      D => s_axi_control_AWADDR(5),
      Q => \waddr_reg_n_2_[5]\,
      R => '0'
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_buffer is
  port (
    gmem_WREADY : out STD_LOGIC;
    Q : out STD_LOGIC_VECTOR ( 5 downto 0 );
    E : out STD_LOGIC_VECTOR ( 0 to 0 );
    \ap_CS_fsm_reg[11]\ : out STD_LOGIC_VECTOR ( 1 downto 0 );
    \ap_CS_fsm_reg[10]\ : out STD_LOGIC_VECTOR ( 0 to 0 );
    DI : out STD_LOGIC_VECTOR ( 0 to 0 );
    \bus_equal_gen.WVALID_Dummy_reg\ : out STD_LOGIC;
    S : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \usedw_reg[6]_0\ : out STD_LOGIC_VECTOR ( 2 downto 0 );
    \dout_buf_reg[35]_0\ : out STD_LOGIC_VECTOR ( 35 downto 0 );
    ap_clk : in STD_LOGIC;
    SR : in STD_LOGIC_VECTOR ( 0 to 0 );
    ap_rst_n : in STD_LOGIC;
    dout_valid_reg_0 : in STD_LOGIC;
    m_axi_gmem_WREADY : in STD_LOGIC;
    burst_valid : in STD_LOGIC;
    \q_tmp_reg[0]_0\ : in STD_LOGIC_VECTOR ( 1 downto 0 );
    ap_reg_ioackin_gmem_WREADY : in STD_LOGIC;
    mem_reg_0 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    \out\ : in STD_LOGIC_VECTOR ( 31 downto 0 );
    \usedw_reg[7]_0\ : in STD_LOGIC_VECTOR ( 6 downto 0 )
  );
end design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_buffer;

architecture STRUCTURE of design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_buffer is
  signal \^q\ : STD_LOGIC_VECTOR ( 5 downto 0 );
  signal data_valid : STD_LOGIC;
  signal \dout_buf[0]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[10]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[11]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[12]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[13]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[14]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[15]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[16]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[17]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[18]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[19]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[1]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[20]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[21]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[22]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[23]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[24]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[25]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[26]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[27]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[28]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[29]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[2]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[30]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[31]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[32]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[33]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[34]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[35]_i_2_n_2\ : STD_LOGIC;
  signal \dout_buf[3]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[4]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[5]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[6]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[7]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[8]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[9]_i_1_n_2\ : STD_LOGIC;
  signal dout_valid_i_1_n_2 : STD_LOGIC;
  signal empty_n_i_1_n_2 : STD_LOGIC;
  signal empty_n_i_2_n_2 : STD_LOGIC;
  signal empty_n_i_3_n_2 : STD_LOGIC;
  signal empty_n_reg_n_2 : STD_LOGIC;
  signal full_n_i_1_n_2 : STD_LOGIC;
  signal \full_n_i_2__4_n_2\ : STD_LOGIC;
  signal \full_n_i_3__2_n_2\ : STD_LOGIC;
  signal \^gmem_wready\ : STD_LOGIC;
  signal gmem_WVALID : STD_LOGIC;
  signal \mem_reg_i_10__0_n_2\ : STD_LOGIC;
  signal mem_reg_i_11_n_2 : STD_LOGIC;
  signal mem_reg_i_12_n_2 : STD_LOGIC;
  signal mem_reg_i_13_n_2 : STD_LOGIC;
  signal mem_reg_i_14_n_2 : STD_LOGIC;
  signal mem_reg_i_15_n_2 : STD_LOGIC;
  signal mem_reg_i_16_n_2 : STD_LOGIC;
  signal mem_reg_i_17_n_2 : STD_LOGIC;
  signal mem_reg_i_18_n_2 : STD_LOGIC;
  signal mem_reg_i_19_n_2 : STD_LOGIC;
  signal mem_reg_i_20_n_2 : STD_LOGIC;
  signal mem_reg_i_21_n_2 : STD_LOGIC;
  signal mem_reg_i_22_n_2 : STD_LOGIC;
  signal mem_reg_i_23_n_2 : STD_LOGIC;
  signal mem_reg_i_24_n_2 : STD_LOGIC;
  signal mem_reg_i_25_n_2 : STD_LOGIC;
  signal mem_reg_i_26_n_2 : STD_LOGIC;
  signal mem_reg_i_27_n_2 : STD_LOGIC;
  signal mem_reg_i_28_n_2 : STD_LOGIC;
  signal mem_reg_i_29_n_2 : STD_LOGIC;
  signal mem_reg_i_30_n_2 : STD_LOGIC;
  signal mem_reg_i_31_n_2 : STD_LOGIC;
  signal mem_reg_i_32_n_2 : STD_LOGIC;
  signal mem_reg_i_33_n_2 : STD_LOGIC;
  signal mem_reg_i_34_n_2 : STD_LOGIC;
  signal mem_reg_i_35_n_2 : STD_LOGIC;
  signal mem_reg_i_36_n_2 : STD_LOGIC;
  signal mem_reg_i_37_n_2 : STD_LOGIC;
  signal mem_reg_i_38_n_2 : STD_LOGIC;
  signal mem_reg_i_39_n_2 : STD_LOGIC;
  signal mem_reg_i_40_n_2 : STD_LOGIC;
  signal mem_reg_i_42_n_2 : STD_LOGIC;
  signal mem_reg_i_43_n_2 : STD_LOGIC;
  signal \mem_reg_i_8__0_n_2\ : STD_LOGIC;
  signal \mem_reg_i_9__0_n_2\ : STD_LOGIC;
  signal pop : STD_LOGIC;
  signal push : STD_LOGIC;
  signal q_buf : STD_LOGIC_VECTOR ( 35 downto 0 );
  signal q_tmp : STD_LOGIC_VECTOR ( 35 downto 0 );
  signal raddr : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal rnext : STD_LOGIC_VECTOR ( 7 downto 1 );
  signal show_ahead : STD_LOGIC;
  signal show_ahead0 : STD_LOGIC;
  signal \usedw[0]_i_1_n_2\ : STD_LOGIC;
  signal \usedw[7]_i_1__0_n_2\ : STD_LOGIC;
  signal \usedw_reg__0\ : STD_LOGIC_VECTOR ( 7 downto 6 );
  signal waddr : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \waddr[0]_i_1_n_2\ : STD_LOGIC;
  signal \waddr[1]_i_1_n_2\ : STD_LOGIC;
  signal \waddr[2]_i_1_n_2\ : STD_LOGIC;
  signal \waddr[3]_i_1_n_2\ : STD_LOGIC;
  signal \waddr[4]_i_1_n_2\ : STD_LOGIC;
  signal \waddr[5]_i_1__0_n_2\ : STD_LOGIC;
  signal \waddr[6]_i_1_n_2\ : STD_LOGIC;
  signal \waddr[6]_i_2_n_2\ : STD_LOGIC;
  signal \waddr[7]_i_2_n_2\ : STD_LOGIC;
  signal \waddr[7]_i_3_n_2\ : STD_LOGIC;
  signal \waddr[7]_i_4_n_2\ : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \ap_CS_fsm[11]_i_1\ : label is "soft_lutpair124";
  attribute SOFT_HLUTNM of \ap_CS_fsm[12]_i_1\ : label is "soft_lutpair124";
  attribute SOFT_HLUTNM of \bus_equal_gen.WVALID_Dummy_i_1\ : label is "soft_lutpair123";
  attribute SOFT_HLUTNM of \bus_equal_gen.data_buf[31]_i_1\ : label is "soft_lutpair123";
  attribute SOFT_HLUTNM of \dout_buf[0]_i_1\ : label is "soft_lutpair126";
  attribute SOFT_HLUTNM of \dout_buf[10]_i_1\ : label is "soft_lutpair136";
  attribute SOFT_HLUTNM of \dout_buf[11]_i_1\ : label is "soft_lutpair137";
  attribute SOFT_HLUTNM of \dout_buf[12]_i_1\ : label is "soft_lutpair138";
  attribute SOFT_HLUTNM of \dout_buf[13]_i_1\ : label is "soft_lutpair139";
  attribute SOFT_HLUTNM of \dout_buf[14]_i_1\ : label is "soft_lutpair138";
  attribute SOFT_HLUTNM of \dout_buf[15]_i_1\ : label is "soft_lutpair137";
  attribute SOFT_HLUTNM of \dout_buf[16]_i_1\ : label is "soft_lutpair134";
  attribute SOFT_HLUTNM of \dout_buf[17]_i_1\ : label is "soft_lutpair133";
  attribute SOFT_HLUTNM of \dout_buf[18]_i_1\ : label is "soft_lutpair127";
  attribute SOFT_HLUTNM of \dout_buf[19]_i_1\ : label is "soft_lutpair126";
  attribute SOFT_HLUTNM of \dout_buf[1]_i_1\ : label is "soft_lutpair127";
  attribute SOFT_HLUTNM of \dout_buf[20]_i_1\ : label is "soft_lutpair128";
  attribute SOFT_HLUTNM of \dout_buf[21]_i_1\ : label is "soft_lutpair129";
  attribute SOFT_HLUTNM of \dout_buf[22]_i_1\ : label is "soft_lutpair131";
  attribute SOFT_HLUTNM of \dout_buf[23]_i_1\ : label is "soft_lutpair135";
  attribute SOFT_HLUTNM of \dout_buf[24]_i_1\ : label is "soft_lutpair130";
  attribute SOFT_HLUTNM of \dout_buf[25]_i_1\ : label is "soft_lutpair139";
  attribute SOFT_HLUTNM of \dout_buf[26]_i_1\ : label is "soft_lutpair132";
  attribute SOFT_HLUTNM of \dout_buf[27]_i_1\ : label is "soft_lutpair142";
  attribute SOFT_HLUTNM of \dout_buf[28]_i_1\ : label is "soft_lutpair142";
  attribute SOFT_HLUTNM of \dout_buf[29]_i_1\ : label is "soft_lutpair143";
  attribute SOFT_HLUTNM of \dout_buf[2]_i_1\ : label is "soft_lutpair128";
  attribute SOFT_HLUTNM of \dout_buf[30]_i_1\ : label is "soft_lutpair136";
  attribute SOFT_HLUTNM of \dout_buf[31]_i_1\ : label is "soft_lutpair143";
  attribute SOFT_HLUTNM of \dout_buf[32]_i_1\ : label is "soft_lutpair140";
  attribute SOFT_HLUTNM of \dout_buf[33]_i_1\ : label is "soft_lutpair141";
  attribute SOFT_HLUTNM of \dout_buf[34]_i_1\ : label is "soft_lutpair140";
  attribute SOFT_HLUTNM of \dout_buf[35]_i_2\ : label is "soft_lutpair141";
  attribute SOFT_HLUTNM of \dout_buf[3]_i_1\ : label is "soft_lutpair129";
  attribute SOFT_HLUTNM of \dout_buf[4]_i_1\ : label is "soft_lutpair130";
  attribute SOFT_HLUTNM of \dout_buf[5]_i_1\ : label is "soft_lutpair131";
  attribute SOFT_HLUTNM of \dout_buf[6]_i_1\ : label is "soft_lutpair132";
  attribute SOFT_HLUTNM of \dout_buf[7]_i_1\ : label is "soft_lutpair133";
  attribute SOFT_HLUTNM of \dout_buf[8]_i_1\ : label is "soft_lutpair134";
  attribute SOFT_HLUTNM of \dout_buf[9]_i_1\ : label is "soft_lutpair135";
  attribute SOFT_HLUTNM of dout_valid_i_1 : label is "soft_lutpair122";
  attribute SOFT_HLUTNM of empty_n_i_1 : label is "soft_lutpair121";
  attribute SOFT_HLUTNM of \full_n_i_2__4\ : label is "soft_lutpair125";
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ : string;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of mem_reg : label is "p4_d32";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ : string;
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of mem_reg : label is "p4_d32";
  attribute METHODOLOGY_DRC_VIOS : string;
  attribute METHODOLOGY_DRC_VIOS of mem_reg : label is "{SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS : integer;
  attribute RTL_RAM_BITS of mem_reg : label is 9216;
  attribute RTL_RAM_NAME : string;
  attribute RTL_RAM_NAME of mem_reg : label is "mem";
  attribute bram_addr_begin : integer;
  attribute bram_addr_begin of mem_reg : label is 0;
  attribute bram_addr_end : integer;
  attribute bram_addr_end of mem_reg : label is 511;
  attribute bram_slice_begin : integer;
  attribute bram_slice_begin of mem_reg : label is 0;
  attribute bram_slice_end : integer;
  attribute bram_slice_end of mem_reg : label is 35;
  attribute ram_addr_begin : integer;
  attribute ram_addr_begin of mem_reg : label is 0;
  attribute ram_addr_end : integer;
  attribute ram_addr_end of mem_reg : label is 511;
  attribute ram_slice_begin : integer;
  attribute ram_slice_begin of mem_reg : label is 0;
  attribute ram_slice_end : integer;
  attribute ram_slice_end of mem_reg : label is 35;
  attribute SOFT_HLUTNM of mem_reg_i_43 : label is "soft_lutpair122";
  attribute SOFT_HLUTNM of show_ahead_i_1 : label is "soft_lutpair121";
  attribute SOFT_HLUTNM of \usedw[0]_i_1\ : label is "soft_lutpair125";
  attribute SOFT_HLUTNM of \waddr[0]_i_1\ : label is "soft_lutpair145";
  attribute SOFT_HLUTNM of \waddr[1]_i_1\ : label is "soft_lutpair145";
  attribute SOFT_HLUTNM of \waddr[2]_i_1\ : label is "soft_lutpair144";
  attribute SOFT_HLUTNM of \waddr[3]_i_1\ : label is "soft_lutpair120";
  attribute SOFT_HLUTNM of \waddr[4]_i_1\ : label is "soft_lutpair120";
  attribute SOFT_HLUTNM of \waddr[6]_i_2\ : label is "soft_lutpair144";
begin
  Q(5 downto 0) <= \^q\(5 downto 0);
  gmem_WREADY <= \^gmem_wready\;
\ap_CS_fsm[11]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FC02"
    )
        port map (
      I0 => \q_tmp_reg[0]_0\(1),
      I1 => \^gmem_wready\,
      I2 => ap_reg_ioackin_gmem_WREADY,
      I3 => \q_tmp_reg[0]_0\(0),
      O => \ap_CS_fsm_reg[11]\(0)
    );
\ap_CS_fsm[12]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"A8"
    )
        port map (
      I0 => \q_tmp_reg[0]_0\(1),
      I1 => ap_reg_ioackin_gmem_WREADY,
      I2 => \^gmem_wready\,
      O => \ap_CS_fsm_reg[11]\(1)
    );
\bus_equal_gen.WVALID_Dummy_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F222"
    )
        port map (
      I0 => dout_valid_reg_0,
      I1 => m_axi_gmem_WREADY,
      I2 => data_valid,
      I3 => burst_valid,
      O => \bus_equal_gen.WVALID_Dummy_reg\
    );
\bus_equal_gen.data_buf[31]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A200"
    )
        port map (
      I0 => data_valid,
      I1 => dout_valid_reg_0,
      I2 => m_axi_gmem_WREADY,
      I3 => burst_valid,
      O => E(0)
    );
\dout_buf[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(0),
      I1 => q_buf(0),
      I2 => show_ahead,
      O => \dout_buf[0]_i_1_n_2\
    );
\dout_buf[10]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(10),
      I1 => q_buf(10),
      I2 => show_ahead,
      O => \dout_buf[10]_i_1_n_2\
    );
\dout_buf[11]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(11),
      I1 => q_buf(11),
      I2 => show_ahead,
      O => \dout_buf[11]_i_1_n_2\
    );
\dout_buf[12]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(12),
      I1 => q_buf(12),
      I2 => show_ahead,
      O => \dout_buf[12]_i_1_n_2\
    );
\dout_buf[13]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(13),
      I1 => q_buf(13),
      I2 => show_ahead,
      O => \dout_buf[13]_i_1_n_2\
    );
\dout_buf[14]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(14),
      I1 => q_buf(14),
      I2 => show_ahead,
      O => \dout_buf[14]_i_1_n_2\
    );
\dout_buf[15]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(15),
      I1 => q_buf(15),
      I2 => show_ahead,
      O => \dout_buf[15]_i_1_n_2\
    );
\dout_buf[16]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(16),
      I1 => q_buf(16),
      I2 => show_ahead,
      O => \dout_buf[16]_i_1_n_2\
    );
\dout_buf[17]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(17),
      I1 => q_buf(17),
      I2 => show_ahead,
      O => \dout_buf[17]_i_1_n_2\
    );
\dout_buf[18]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(18),
      I1 => q_buf(18),
      I2 => show_ahead,
      O => \dout_buf[18]_i_1_n_2\
    );
\dout_buf[19]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(19),
      I1 => q_buf(19),
      I2 => show_ahead,
      O => \dout_buf[19]_i_1_n_2\
    );
\dout_buf[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(1),
      I1 => q_buf(1),
      I2 => show_ahead,
      O => \dout_buf[1]_i_1_n_2\
    );
\dout_buf[20]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(20),
      I1 => q_buf(20),
      I2 => show_ahead,
      O => \dout_buf[20]_i_1_n_2\
    );
\dout_buf[21]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(21),
      I1 => q_buf(21),
      I2 => show_ahead,
      O => \dout_buf[21]_i_1_n_2\
    );
\dout_buf[22]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(22),
      I1 => q_buf(22),
      I2 => show_ahead,
      O => \dout_buf[22]_i_1_n_2\
    );
\dout_buf[23]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(23),
      I1 => q_buf(23),
      I2 => show_ahead,
      O => \dout_buf[23]_i_1_n_2\
    );
\dout_buf[24]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(24),
      I1 => q_buf(24),
      I2 => show_ahead,
      O => \dout_buf[24]_i_1_n_2\
    );
\dout_buf[25]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(25),
      I1 => q_buf(25),
      I2 => show_ahead,
      O => \dout_buf[25]_i_1_n_2\
    );
\dout_buf[26]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(26),
      I1 => q_buf(26),
      I2 => show_ahead,
      O => \dout_buf[26]_i_1_n_2\
    );
\dout_buf[27]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(27),
      I1 => q_buf(27),
      I2 => show_ahead,
      O => \dout_buf[27]_i_1_n_2\
    );
\dout_buf[28]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(28),
      I1 => q_buf(28),
      I2 => show_ahead,
      O => \dout_buf[28]_i_1_n_2\
    );
\dout_buf[29]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(29),
      I1 => q_buf(29),
      I2 => show_ahead,
      O => \dout_buf[29]_i_1_n_2\
    );
\dout_buf[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(2),
      I1 => q_buf(2),
      I2 => show_ahead,
      O => \dout_buf[2]_i_1_n_2\
    );
\dout_buf[30]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(30),
      I1 => q_buf(30),
      I2 => show_ahead,
      O => \dout_buf[30]_i_1_n_2\
    );
\dout_buf[31]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(31),
      I1 => q_buf(31),
      I2 => show_ahead,
      O => \dout_buf[31]_i_1_n_2\
    );
\dout_buf[32]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(35),
      I1 => q_buf(32),
      I2 => show_ahead,
      O => \dout_buf[32]_i_1_n_2\
    );
\dout_buf[33]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(35),
      I1 => q_buf(33),
      I2 => show_ahead,
      O => \dout_buf[33]_i_1_n_2\
    );
\dout_buf[34]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(35),
      I1 => q_buf(34),
      I2 => show_ahead,
      O => \dout_buf[34]_i_1_n_2\
    );
\dout_buf[35]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"AA2A2222"
    )
        port map (
      I0 => empty_n_reg_n_2,
      I1 => data_valid,
      I2 => dout_valid_reg_0,
      I3 => m_axi_gmem_WREADY,
      I4 => burst_valid,
      O => pop
    );
\dout_buf[35]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(35),
      I1 => q_buf(35),
      I2 => show_ahead,
      O => \dout_buf[35]_i_2_n_2\
    );
\dout_buf[3]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(3),
      I1 => q_buf(3),
      I2 => show_ahead,
      O => \dout_buf[3]_i_1_n_2\
    );
\dout_buf[4]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(4),
      I1 => q_buf(4),
      I2 => show_ahead,
      O => \dout_buf[4]_i_1_n_2\
    );
\dout_buf[5]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(5),
      I1 => q_buf(5),
      I2 => show_ahead,
      O => \dout_buf[5]_i_1_n_2\
    );
\dout_buf[6]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(6),
      I1 => q_buf(6),
      I2 => show_ahead,
      O => \dout_buf[6]_i_1_n_2\
    );
\dout_buf[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(7),
      I1 => q_buf(7),
      I2 => show_ahead,
      O => \dout_buf[7]_i_1_n_2\
    );
\dout_buf[8]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(8),
      I1 => q_buf(8),
      I2 => show_ahead,
      O => \dout_buf[8]_i_1_n_2\
    );
\dout_buf[9]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => q_tmp(9),
      I1 => q_buf(9),
      I2 => show_ahead,
      O => \dout_buf[9]_i_1_n_2\
    );
\dout_buf_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[0]_i_1_n_2\,
      Q => \dout_buf_reg[35]_0\(0),
      R => SR(0)
    );
\dout_buf_reg[10]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[10]_i_1_n_2\,
      Q => \dout_buf_reg[35]_0\(10),
      R => SR(0)
    );
\dout_buf_reg[11]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[11]_i_1_n_2\,
      Q => \dout_buf_reg[35]_0\(11),
      R => SR(0)
    );
\dout_buf_reg[12]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[12]_i_1_n_2\,
      Q => \dout_buf_reg[35]_0\(12),
      R => SR(0)
    );
\dout_buf_reg[13]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[13]_i_1_n_2\,
      Q => \dout_buf_reg[35]_0\(13),
      R => SR(0)
    );
\dout_buf_reg[14]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[14]_i_1_n_2\,
      Q => \dout_buf_reg[35]_0\(14),
      R => SR(0)
    );
\dout_buf_reg[15]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[15]_i_1_n_2\,
      Q => \dout_buf_reg[35]_0\(15),
      R => SR(0)
    );
\dout_buf_reg[16]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[16]_i_1_n_2\,
      Q => \dout_buf_reg[35]_0\(16),
      R => SR(0)
    );
\dout_buf_reg[17]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[17]_i_1_n_2\,
      Q => \dout_buf_reg[35]_0\(17),
      R => SR(0)
    );
\dout_buf_reg[18]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[18]_i_1_n_2\,
      Q => \dout_buf_reg[35]_0\(18),
      R => SR(0)
    );
\dout_buf_reg[19]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[19]_i_1_n_2\,
      Q => \dout_buf_reg[35]_0\(19),
      R => SR(0)
    );
\dout_buf_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[1]_i_1_n_2\,
      Q => \dout_buf_reg[35]_0\(1),
      R => SR(0)
    );
\dout_buf_reg[20]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[20]_i_1_n_2\,
      Q => \dout_buf_reg[35]_0\(20),
      R => SR(0)
    );
\dout_buf_reg[21]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[21]_i_1_n_2\,
      Q => \dout_buf_reg[35]_0\(21),
      R => SR(0)
    );
\dout_buf_reg[22]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[22]_i_1_n_2\,
      Q => \dout_buf_reg[35]_0\(22),
      R => SR(0)
    );
\dout_buf_reg[23]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[23]_i_1_n_2\,
      Q => \dout_buf_reg[35]_0\(23),
      R => SR(0)
    );
\dout_buf_reg[24]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[24]_i_1_n_2\,
      Q => \dout_buf_reg[35]_0\(24),
      R => SR(0)
    );
\dout_buf_reg[25]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[25]_i_1_n_2\,
      Q => \dout_buf_reg[35]_0\(25),
      R => SR(0)
    );
\dout_buf_reg[26]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[26]_i_1_n_2\,
      Q => \dout_buf_reg[35]_0\(26),
      R => SR(0)
    );
\dout_buf_reg[27]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[27]_i_1_n_2\,
      Q => \dout_buf_reg[35]_0\(27),
      R => SR(0)
    );
\dout_buf_reg[28]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[28]_i_1_n_2\,
      Q => \dout_buf_reg[35]_0\(28),
      R => SR(0)
    );
\dout_buf_reg[29]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[29]_i_1_n_2\,
      Q => \dout_buf_reg[35]_0\(29),
      R => SR(0)
    );
\dout_buf_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[2]_i_1_n_2\,
      Q => \dout_buf_reg[35]_0\(2),
      R => SR(0)
    );
\dout_buf_reg[30]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[30]_i_1_n_2\,
      Q => \dout_buf_reg[35]_0\(30),
      R => SR(0)
    );
\dout_buf_reg[31]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[31]_i_1_n_2\,
      Q => \dout_buf_reg[35]_0\(31),
      R => SR(0)
    );
\dout_buf_reg[32]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[32]_i_1_n_2\,
      Q => \dout_buf_reg[35]_0\(32),
      R => SR(0)
    );
\dout_buf_reg[33]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[33]_i_1_n_2\,
      Q => \dout_buf_reg[35]_0\(33),
      R => SR(0)
    );
\dout_buf_reg[34]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[34]_i_1_n_2\,
      Q => \dout_buf_reg[35]_0\(34),
      R => SR(0)
    );
\dout_buf_reg[35]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[35]_i_2_n_2\,
      Q => \dout_buf_reg[35]_0\(35),
      R => SR(0)
    );
\dout_buf_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[3]_i_1_n_2\,
      Q => \dout_buf_reg[35]_0\(3),
      R => SR(0)
    );
\dout_buf_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[4]_i_1_n_2\,
      Q => \dout_buf_reg[35]_0\(4),
      R => SR(0)
    );
\dout_buf_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[5]_i_1_n_2\,
      Q => \dout_buf_reg[35]_0\(5),
      R => SR(0)
    );
\dout_buf_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[6]_i_1_n_2\,
      Q => \dout_buf_reg[35]_0\(6),
      R => SR(0)
    );
\dout_buf_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[7]_i_1_n_2\,
      Q => \dout_buf_reg[35]_0\(7),
      R => SR(0)
    );
\dout_buf_reg[8]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[8]_i_1_n_2\,
      Q => \dout_buf_reg[35]_0\(8),
      R => SR(0)
    );
\dout_buf_reg[9]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[9]_i_1_n_2\,
      Q => \dout_buf_reg[35]_0\(9),
      R => SR(0)
    );
dout_valid_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"AAEAEEEE"
    )
        port map (
      I0 => empty_n_reg_n_2,
      I1 => data_valid,
      I2 => dout_valid_reg_0,
      I3 => m_axi_gmem_WREADY,
      I4 => burst_valid,
      O => dout_valid_i_1_n_2
    );
dout_valid_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => dout_valid_i_1_n_2,
      Q => data_valid,
      R => SR(0)
    );
empty_n_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFDF00D"
    )
        port map (
      I0 => \^q\(0),
      I1 => empty_n_i_2_n_2,
      I2 => push,
      I3 => mem_reg_i_43_n_2,
      I4 => empty_n_reg_n_2,
      O => empty_n_i_1_n_2
    );
empty_n_i_2: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \usedw_reg__0\(6),
      I1 => \^q\(5),
      I2 => \^q\(3),
      I3 => empty_n_i_3_n_2,
      O => empty_n_i_2_n_2
    );
empty_n_i_3: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \usedw_reg__0\(7),
      I1 => \^q\(1),
      I2 => \^q\(2),
      I3 => \^q\(4),
      O => empty_n_i_3_n_2
    );
empty_n_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => empty_n_i_1_n_2,
      Q => empty_n_reg_n_2,
      R => SR(0)
    );
full_n_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FDFFFFFFFD5555FF"
    )
        port map (
      I0 => ap_rst_n,
      I1 => \full_n_i_2__4_n_2\,
      I2 => \full_n_i_3__2_n_2\,
      I3 => mem_reg_i_43_n_2,
      I4 => push,
      I5 => \^gmem_wready\,
      O => full_n_i_1_n_2
    );
\full_n_i_2__4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => \usedw_reg__0\(6),
      I1 => \usedw_reg__0\(7),
      I2 => \^q\(0),
      I3 => \^q\(1),
      O => \full_n_i_2__4_n_2\
    );
\full_n_i_3__2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => \^q\(5),
      I1 => \^q\(4),
      I2 => \^q\(2),
      I3 => \^q\(3),
      O => \full_n_i_3__2_n_2\
    );
full_n_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '1'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => full_n_i_1_n_2,
      Q => \^gmem_wready\,
      R => '0'
    );
mem_reg: unisim.vcomponents.RAMB18E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      INIT_A => X"00000",
      INIT_B => X"00000",
      RAM_MODE => "SDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 36,
      READ_WIDTH_B => 0,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"00000",
      SRVAL_B => X"00000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "READ_FIRST",
      WRITE_WIDTH_A => 0,
      WRITE_WIDTH_B => 36
    )
        port map (
      ADDRARDADDR(13) => '1',
      ADDRARDADDR(12 downto 6) => rnext(7 downto 1),
      ADDRARDADDR(5) => \mem_reg_i_8__0_n_2\,
      ADDRARDADDR(4 downto 0) => B"11111",
      ADDRBWRADDR(13) => '1',
      ADDRBWRADDR(12 downto 5) => waddr(7 downto 0),
      ADDRBWRADDR(4 downto 0) => B"11111",
      CLKARDCLK => ap_clk,
      CLKBWRCLK => ap_clk,
      DIADI(15) => \mem_reg_i_9__0_n_2\,
      DIADI(14) => \mem_reg_i_10__0_n_2\,
      DIADI(13) => mem_reg_i_11_n_2,
      DIADI(12) => mem_reg_i_12_n_2,
      DIADI(11) => mem_reg_i_13_n_2,
      DIADI(10) => mem_reg_i_14_n_2,
      DIADI(9) => mem_reg_i_15_n_2,
      DIADI(8) => mem_reg_i_16_n_2,
      DIADI(7) => mem_reg_i_17_n_2,
      DIADI(6) => mem_reg_i_18_n_2,
      DIADI(5) => mem_reg_i_19_n_2,
      DIADI(4) => mem_reg_i_20_n_2,
      DIADI(3) => mem_reg_i_21_n_2,
      DIADI(2) => mem_reg_i_22_n_2,
      DIADI(1) => mem_reg_i_23_n_2,
      DIADI(0) => mem_reg_i_24_n_2,
      DIBDI(15) => mem_reg_i_25_n_2,
      DIBDI(14) => mem_reg_i_26_n_2,
      DIBDI(13) => mem_reg_i_27_n_2,
      DIBDI(12) => mem_reg_i_28_n_2,
      DIBDI(11) => mem_reg_i_29_n_2,
      DIBDI(10) => mem_reg_i_30_n_2,
      DIBDI(9) => mem_reg_i_31_n_2,
      DIBDI(8) => mem_reg_i_32_n_2,
      DIBDI(7) => mem_reg_i_33_n_2,
      DIBDI(6) => mem_reg_i_34_n_2,
      DIBDI(5) => mem_reg_i_35_n_2,
      DIBDI(4) => mem_reg_i_36_n_2,
      DIBDI(3) => mem_reg_i_37_n_2,
      DIBDI(2) => mem_reg_i_38_n_2,
      DIBDI(1) => mem_reg_i_39_n_2,
      DIBDI(0) => mem_reg_i_40_n_2,
      DIPADIP(1 downto 0) => B"11",
      DIPBDIP(1 downto 0) => B"11",
      DOADO(15 downto 0) => q_buf(15 downto 0),
      DOBDO(15 downto 0) => q_buf(31 downto 16),
      DOPADOP(1 downto 0) => q_buf(33 downto 32),
      DOPBDOP(1 downto 0) => q_buf(35 downto 34),
      ENARDEN => '1',
      ENBWREN => \^gmem_wready\,
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      WEA(1 downto 0) => B"00",
      WEBWE(3) => gmem_WVALID,
      WEBWE(2) => gmem_WVALID,
      WEBWE(1) => gmem_WVALID,
      WEBWE(0) => gmem_WVALID
    );
mem_reg_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A6AA"
    )
        port map (
      I0 => raddr(7),
      I1 => raddr(5),
      I2 => mem_reg_i_42_n_2,
      I3 => raddr(6),
      O => rnext(7)
    );
\mem_reg_i_10__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => mem_reg_0(14),
      I1 => \q_tmp_reg[0]_0\(1),
      I2 => \out\(14),
      O => \mem_reg_i_10__0_n_2\
    );
mem_reg_i_11: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => mem_reg_0(13),
      I1 => \q_tmp_reg[0]_0\(1),
      I2 => \out\(13),
      O => mem_reg_i_11_n_2
    );
mem_reg_i_12: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => mem_reg_0(12),
      I1 => \q_tmp_reg[0]_0\(1),
      I2 => \out\(12),
      O => mem_reg_i_12_n_2
    );
mem_reg_i_13: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => mem_reg_0(11),
      I1 => \q_tmp_reg[0]_0\(1),
      I2 => \out\(11),
      O => mem_reg_i_13_n_2
    );
mem_reg_i_14: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => mem_reg_0(10),
      I1 => \q_tmp_reg[0]_0\(1),
      I2 => \out\(10),
      O => mem_reg_i_14_n_2
    );
mem_reg_i_15: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => mem_reg_0(9),
      I1 => \q_tmp_reg[0]_0\(1),
      I2 => \out\(9),
      O => mem_reg_i_15_n_2
    );
mem_reg_i_16: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => mem_reg_0(8),
      I1 => \q_tmp_reg[0]_0\(1),
      I2 => \out\(8),
      O => mem_reg_i_16_n_2
    );
mem_reg_i_17: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => mem_reg_0(7),
      I1 => \q_tmp_reg[0]_0\(1),
      I2 => \out\(7),
      O => mem_reg_i_17_n_2
    );
mem_reg_i_18: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => mem_reg_0(6),
      I1 => \q_tmp_reg[0]_0\(1),
      I2 => \out\(6),
      O => mem_reg_i_18_n_2
    );
mem_reg_i_19: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => mem_reg_0(5),
      I1 => \q_tmp_reg[0]_0\(1),
      I2 => \out\(5),
      O => mem_reg_i_19_n_2
    );
mem_reg_i_2: unisim.vcomponents.LUT3
    generic map(
      INIT => X"9A"
    )
        port map (
      I0 => raddr(6),
      I1 => mem_reg_i_42_n_2,
      I2 => raddr(5),
      O => rnext(6)
    );
mem_reg_i_20: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => mem_reg_0(4),
      I1 => \q_tmp_reg[0]_0\(1),
      I2 => \out\(4),
      O => mem_reg_i_20_n_2
    );
mem_reg_i_21: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => mem_reg_0(3),
      I1 => \q_tmp_reg[0]_0\(1),
      I2 => \out\(3),
      O => mem_reg_i_21_n_2
    );
mem_reg_i_22: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => mem_reg_0(2),
      I1 => \q_tmp_reg[0]_0\(1),
      I2 => \out\(2),
      O => mem_reg_i_22_n_2
    );
mem_reg_i_23: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => mem_reg_0(1),
      I1 => \q_tmp_reg[0]_0\(1),
      I2 => \out\(1),
      O => mem_reg_i_23_n_2
    );
mem_reg_i_24: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => mem_reg_0(0),
      I1 => \q_tmp_reg[0]_0\(1),
      I2 => \out\(0),
      O => mem_reg_i_24_n_2
    );
mem_reg_i_25: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => mem_reg_0(31),
      I1 => \q_tmp_reg[0]_0\(1),
      I2 => \out\(31),
      O => mem_reg_i_25_n_2
    );
mem_reg_i_26: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => mem_reg_0(30),
      I1 => \q_tmp_reg[0]_0\(1),
      I2 => \out\(30),
      O => mem_reg_i_26_n_2
    );
mem_reg_i_27: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => mem_reg_0(29),
      I1 => \q_tmp_reg[0]_0\(1),
      I2 => \out\(29),
      O => mem_reg_i_27_n_2
    );
mem_reg_i_28: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => mem_reg_0(28),
      I1 => \q_tmp_reg[0]_0\(1),
      I2 => \out\(28),
      O => mem_reg_i_28_n_2
    );
mem_reg_i_29: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => mem_reg_0(27),
      I1 => \q_tmp_reg[0]_0\(1),
      I2 => \out\(27),
      O => mem_reg_i_29_n_2
    );
mem_reg_i_3: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => mem_reg_i_42_n_2,
      I1 => raddr(5),
      O => rnext(5)
    );
mem_reg_i_30: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => mem_reg_0(26),
      I1 => \q_tmp_reg[0]_0\(1),
      I2 => \out\(26),
      O => mem_reg_i_30_n_2
    );
mem_reg_i_31: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => mem_reg_0(25),
      I1 => \q_tmp_reg[0]_0\(1),
      I2 => \out\(25),
      O => mem_reg_i_31_n_2
    );
mem_reg_i_32: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => mem_reg_0(24),
      I1 => \q_tmp_reg[0]_0\(1),
      I2 => \out\(24),
      O => mem_reg_i_32_n_2
    );
mem_reg_i_33: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => mem_reg_0(23),
      I1 => \q_tmp_reg[0]_0\(1),
      I2 => \out\(23),
      O => mem_reg_i_33_n_2
    );
mem_reg_i_34: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => mem_reg_0(22),
      I1 => \q_tmp_reg[0]_0\(1),
      I2 => \out\(22),
      O => mem_reg_i_34_n_2
    );
mem_reg_i_35: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => mem_reg_0(21),
      I1 => \q_tmp_reg[0]_0\(1),
      I2 => \out\(21),
      O => mem_reg_i_35_n_2
    );
mem_reg_i_36: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => mem_reg_0(20),
      I1 => \q_tmp_reg[0]_0\(1),
      I2 => \out\(20),
      O => mem_reg_i_36_n_2
    );
mem_reg_i_37: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => mem_reg_0(19),
      I1 => \q_tmp_reg[0]_0\(1),
      I2 => \out\(19),
      O => mem_reg_i_37_n_2
    );
mem_reg_i_38: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => mem_reg_0(18),
      I1 => \q_tmp_reg[0]_0\(1),
      I2 => \out\(18),
      O => mem_reg_i_38_n_2
    );
mem_reg_i_39: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => mem_reg_0(17),
      I1 => \q_tmp_reg[0]_0\(1),
      I2 => \out\(17),
      O => mem_reg_i_39_n_2
    );
mem_reg_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AA6AAAAAAAAAAAAA"
    )
        port map (
      I0 => raddr(4),
      I1 => raddr(2),
      I2 => raddr(0),
      I3 => mem_reg_i_43_n_2,
      I4 => raddr(1),
      I5 => raddr(3),
      O => rnext(4)
    );
mem_reg_i_40: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => mem_reg_0(16),
      I1 => \q_tmp_reg[0]_0\(1),
      I2 => \out\(16),
      O => mem_reg_i_40_n_2
    );
mem_reg_i_41: unisim.vcomponents.LUT3
    generic map(
      INIT => X"54"
    )
        port map (
      I0 => ap_reg_ioackin_gmem_WREADY,
      I1 => \q_tmp_reg[0]_0\(1),
      I2 => \q_tmp_reg[0]_0\(0),
      O => gmem_WVALID
    );
mem_reg_i_42: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F7FFFFFFFFFFFFFF"
    )
        port map (
      I0 => raddr(3),
      I1 => raddr(1),
      I2 => mem_reg_i_43_n_2,
      I3 => raddr(0),
      I4 => raddr(2),
      I5 => raddr(4),
      O => mem_reg_i_42_n_2
    );
mem_reg_i_43: unisim.vcomponents.LUT5
    generic map(
      INIT => X"7500FFFF"
    )
        port map (
      I0 => burst_valid,
      I1 => m_axi_gmem_WREADY,
      I2 => dout_valid_reg_0,
      I3 => data_valid,
      I4 => empty_n_reg_n_2,
      O => mem_reg_i_43_n_2
    );
mem_reg_i_5: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A6AAAAAA"
    )
        port map (
      I0 => raddr(3),
      I1 => raddr(1),
      I2 => mem_reg_i_43_n_2,
      I3 => raddr(0),
      I4 => raddr(2),
      O => rnext(3)
    );
mem_reg_i_6: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A6AA"
    )
        port map (
      I0 => raddr(2),
      I1 => raddr(0),
      I2 => mem_reg_i_43_n_2,
      I3 => raddr(1),
      O => rnext(2)
    );
mem_reg_i_7: unisim.vcomponents.LUT3
    generic map(
      INIT => X"9A"
    )
        port map (
      I0 => raddr(1),
      I1 => mem_reg_i_43_n_2,
      I2 => raddr(0),
      O => rnext(1)
    );
\mem_reg_i_8__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6666A666A6A6A6A6"
    )
        port map (
      I0 => raddr(0),
      I1 => empty_n_reg_n_2,
      I2 => data_valid,
      I3 => dout_valid_reg_0,
      I4 => m_axi_gmem_WREADY,
      I5 => burst_valid,
      O => \mem_reg_i_8__0_n_2\
    );
\mem_reg_i_9__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => mem_reg_0(15),
      I1 => \q_tmp_reg[0]_0\(1),
      I2 => \out\(15),
      O => \mem_reg_i_9__0_n_2\
    );
\p_0_out_carry__0_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \usedw_reg__0\(6),
      I1 => \usedw_reg__0\(7),
      O => \usedw_reg[6]_0\(2)
    );
\p_0_out_carry__0_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^q\(5),
      I1 => \usedw_reg__0\(6),
      O => \usedw_reg[6]_0\(1)
    );
\p_0_out_carry__0_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^q\(4),
      I1 => \^q\(5),
      O => \usedw_reg[6]_0\(0)
    );
p_0_out_carry_i_1: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q\(1),
      O => DI(0)
    );
p_0_out_carry_i_2: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^q\(3),
      I1 => \^q\(4),
      O => S(3)
    );
p_0_out_carry_i_3: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^q\(2),
      I1 => \^q\(3),
      O => S(2)
    );
p_0_out_carry_i_4: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^q\(1),
      I1 => \^q\(2),
      O => S(1)
    );
p_0_out_carry_i_5: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5555999555555555"
    )
        port map (
      I0 => \^q\(1),
      I1 => \^gmem_wready\,
      I2 => \q_tmp_reg[0]_0\(0),
      I3 => \q_tmp_reg[0]_0\(1),
      I4 => ap_reg_ioackin_gmem_WREADY,
      I5 => mem_reg_i_43_n_2,
      O => S(0)
    );
\q_tmp_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => mem_reg_i_24_n_2,
      Q => q_tmp(0),
      R => SR(0)
    );
\q_tmp_reg[10]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => mem_reg_i_14_n_2,
      Q => q_tmp(10),
      R => SR(0)
    );
\q_tmp_reg[11]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => mem_reg_i_13_n_2,
      Q => q_tmp(11),
      R => SR(0)
    );
\q_tmp_reg[12]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => mem_reg_i_12_n_2,
      Q => q_tmp(12),
      R => SR(0)
    );
\q_tmp_reg[13]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => mem_reg_i_11_n_2,
      Q => q_tmp(13),
      R => SR(0)
    );
\q_tmp_reg[14]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => \mem_reg_i_10__0_n_2\,
      Q => q_tmp(14),
      R => SR(0)
    );
\q_tmp_reg[15]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => \mem_reg_i_9__0_n_2\,
      Q => q_tmp(15),
      R => SR(0)
    );
\q_tmp_reg[16]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => mem_reg_i_40_n_2,
      Q => q_tmp(16),
      R => SR(0)
    );
\q_tmp_reg[17]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => mem_reg_i_39_n_2,
      Q => q_tmp(17),
      R => SR(0)
    );
\q_tmp_reg[18]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => mem_reg_i_38_n_2,
      Q => q_tmp(18),
      R => SR(0)
    );
\q_tmp_reg[19]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => mem_reg_i_37_n_2,
      Q => q_tmp(19),
      R => SR(0)
    );
\q_tmp_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => mem_reg_i_23_n_2,
      Q => q_tmp(1),
      R => SR(0)
    );
\q_tmp_reg[20]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => mem_reg_i_36_n_2,
      Q => q_tmp(20),
      R => SR(0)
    );
\q_tmp_reg[21]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => mem_reg_i_35_n_2,
      Q => q_tmp(21),
      R => SR(0)
    );
\q_tmp_reg[22]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => mem_reg_i_34_n_2,
      Q => q_tmp(22),
      R => SR(0)
    );
\q_tmp_reg[23]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => mem_reg_i_33_n_2,
      Q => q_tmp(23),
      R => SR(0)
    );
\q_tmp_reg[24]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => mem_reg_i_32_n_2,
      Q => q_tmp(24),
      R => SR(0)
    );
\q_tmp_reg[25]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => mem_reg_i_31_n_2,
      Q => q_tmp(25),
      R => SR(0)
    );
\q_tmp_reg[26]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => mem_reg_i_30_n_2,
      Q => q_tmp(26),
      R => SR(0)
    );
\q_tmp_reg[27]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => mem_reg_i_29_n_2,
      Q => q_tmp(27),
      R => SR(0)
    );
\q_tmp_reg[28]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => mem_reg_i_28_n_2,
      Q => q_tmp(28),
      R => SR(0)
    );
\q_tmp_reg[29]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => mem_reg_i_27_n_2,
      Q => q_tmp(29),
      R => SR(0)
    );
\q_tmp_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => mem_reg_i_22_n_2,
      Q => q_tmp(2),
      R => SR(0)
    );
\q_tmp_reg[30]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => mem_reg_i_26_n_2,
      Q => q_tmp(30),
      R => SR(0)
    );
\q_tmp_reg[31]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => mem_reg_i_25_n_2,
      Q => q_tmp(31),
      R => SR(0)
    );
\q_tmp_reg[35]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => '1',
      Q => q_tmp(35),
      R => SR(0)
    );
\q_tmp_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => mem_reg_i_21_n_2,
      Q => q_tmp(3),
      R => SR(0)
    );
\q_tmp_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => mem_reg_i_20_n_2,
      Q => q_tmp(4),
      R => SR(0)
    );
\q_tmp_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => mem_reg_i_19_n_2,
      Q => q_tmp(5),
      R => SR(0)
    );
\q_tmp_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => mem_reg_i_18_n_2,
      Q => q_tmp(6),
      R => SR(0)
    );
\q_tmp_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => mem_reg_i_17_n_2,
      Q => q_tmp(7),
      R => SR(0)
    );
\q_tmp_reg[8]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => mem_reg_i_16_n_2,
      Q => q_tmp(8),
      R => SR(0)
    );
\q_tmp_reg[9]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => mem_reg_i_15_n_2,
      Q => q_tmp(9),
      R => SR(0)
    );
\raddr_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \mem_reg_i_8__0_n_2\,
      Q => raddr(0),
      R => SR(0)
    );
\raddr_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => rnext(1),
      Q => raddr(1),
      R => SR(0)
    );
\raddr_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => rnext(2),
      Q => raddr(2),
      R => SR(0)
    );
\raddr_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => rnext(3),
      Q => raddr(3),
      R => SR(0)
    );
\raddr_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => rnext(4),
      Q => raddr(4),
      R => SR(0)
    );
\raddr_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => rnext(5),
      Q => raddr(5),
      R => SR(0)
    );
\raddr_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => rnext(6),
      Q => raddr(6),
      R => SR(0)
    );
\raddr_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => rnext(7),
      Q => raddr(7),
      R => SR(0)
    );
show_ahead_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0440"
    )
        port map (
      I0 => empty_n_i_2_n_2,
      I1 => push,
      I2 => mem_reg_i_43_n_2,
      I3 => \^q\(0),
      O => show_ahead0
    );
show_ahead_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => show_ahead0,
      Q => show_ahead,
      R => SR(0)
    );
\tmp_2_reg_270[31]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"A8"
    )
        port map (
      I0 => \q_tmp_reg[0]_0\(0),
      I1 => ap_reg_ioackin_gmem_WREADY,
      I2 => \^gmem_wready\,
      O => \ap_CS_fsm_reg[10]\(0)
    );
\usedw[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q\(0),
      O => \usedw[0]_i_1_n_2\
    );
\usedw[7]_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"55D5DDDDAA2A2222"
    )
        port map (
      I0 => empty_n_reg_n_2,
      I1 => data_valid,
      I2 => dout_valid_reg_0,
      I3 => m_axi_gmem_WREADY,
      I4 => burst_valid,
      I5 => push,
      O => \usedw[7]_i_1__0_n_2\
    );
\usedw_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \usedw[7]_i_1__0_n_2\,
      D => \usedw[0]_i_1_n_2\,
      Q => \^q\(0),
      R => SR(0)
    );
\usedw_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \usedw[7]_i_1__0_n_2\,
      D => \usedw_reg[7]_0\(0),
      Q => \^q\(1),
      R => SR(0)
    );
\usedw_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \usedw[7]_i_1__0_n_2\,
      D => \usedw_reg[7]_0\(1),
      Q => \^q\(2),
      R => SR(0)
    );
\usedw_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \usedw[7]_i_1__0_n_2\,
      D => \usedw_reg[7]_0\(2),
      Q => \^q\(3),
      R => SR(0)
    );
\usedw_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \usedw[7]_i_1__0_n_2\,
      D => \usedw_reg[7]_0\(3),
      Q => \^q\(4),
      R => SR(0)
    );
\usedw_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \usedw[7]_i_1__0_n_2\,
      D => \usedw_reg[7]_0\(4),
      Q => \^q\(5),
      R => SR(0)
    );
\usedw_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \usedw[7]_i_1__0_n_2\,
      D => \usedw_reg[7]_0\(5),
      Q => \usedw_reg__0\(6),
      R => SR(0)
    );
\usedw_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \usedw[7]_i_1__0_n_2\,
      D => \usedw_reg[7]_0\(6),
      Q => \usedw_reg__0\(7),
      R => SR(0)
    );
\waddr[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => waddr(0),
      O => \waddr[0]_i_1_n_2\
    );
\waddr[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => waddr(0),
      I1 => waddr(1),
      O => \waddr[1]_i_1_n_2\
    );
\waddr[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"6A"
    )
        port map (
      I0 => waddr(2),
      I1 => waddr(0),
      I2 => waddr(1),
      O => \waddr[2]_i_1_n_2\
    );
\waddr[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6AAA"
    )
        port map (
      I0 => waddr(3),
      I1 => waddr(0),
      I2 => waddr(1),
      I3 => waddr(2),
      O => \waddr[3]_i_1_n_2\
    );
\waddr[4]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"6AAAAAAA"
    )
        port map (
      I0 => waddr(4),
      I1 => waddr(2),
      I2 => waddr(1),
      I3 => waddr(0),
      I4 => waddr(3),
      O => \waddr[4]_i_1_n_2\
    );
\waddr[5]_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6AAAAAAAAAAAAAAA"
    )
        port map (
      I0 => waddr(5),
      I1 => waddr(3),
      I2 => waddr(0),
      I3 => waddr(1),
      I4 => waddr(2),
      I5 => waddr(4),
      O => \waddr[5]_i_1__0_n_2\
    );
\waddr[6]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6AAAAAAAAAAAAAAA"
    )
        port map (
      I0 => waddr(6),
      I1 => waddr(4),
      I2 => waddr(2),
      I3 => \waddr[6]_i_2_n_2\,
      I4 => waddr(3),
      I5 => waddr(5),
      O => \waddr[6]_i_1_n_2\
    );
\waddr[6]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => waddr(1),
      I1 => waddr(0),
      O => \waddr[6]_i_2_n_2\
    );
\waddr[7]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"00A8"
    )
        port map (
      I0 => \^gmem_wready\,
      I1 => \q_tmp_reg[0]_0\(0),
      I2 => \q_tmp_reg[0]_0\(1),
      I3 => ap_reg_ioackin_gmem_WREADY,
      O => push
    );
\waddr[7]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B8CC"
    )
        port map (
      I0 => \waddr[7]_i_3_n_2\,
      I1 => waddr(7),
      I2 => \waddr[7]_i_4_n_2\,
      I3 => waddr(6),
      O => \waddr[7]_i_2_n_2\
    );
\waddr[7]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7FFFFFFFFFFFFFFF"
    )
        port map (
      I0 => waddr(4),
      I1 => waddr(2),
      I2 => waddr(0),
      I3 => waddr(1),
      I4 => waddr(3),
      I5 => waddr(5),
      O => \waddr[7]_i_3_n_2\
    );
\waddr[7]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8000000000000000"
    )
        port map (
      I0 => waddr(4),
      I1 => waddr(2),
      I2 => waddr(1),
      I3 => waddr(0),
      I4 => waddr(3),
      I5 => waddr(5),
      O => \waddr[7]_i_4_n_2\
    );
\waddr_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => \waddr[0]_i_1_n_2\,
      Q => waddr(0),
      R => SR(0)
    );
\waddr_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => \waddr[1]_i_1_n_2\,
      Q => waddr(1),
      R => SR(0)
    );
\waddr_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => \waddr[2]_i_1_n_2\,
      Q => waddr(2),
      R => SR(0)
    );
\waddr_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => \waddr[3]_i_1_n_2\,
      Q => waddr(3),
      R => SR(0)
    );
\waddr_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => \waddr[4]_i_1_n_2\,
      Q => waddr(4),
      R => SR(0)
    );
\waddr_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => \waddr[5]_i_1__0_n_2\,
      Q => waddr(5),
      R => SR(0)
    );
\waddr_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => \waddr[6]_i_1_n_2\,
      Q => waddr(6),
      R => SR(0)
    );
\waddr_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => \waddr[7]_i_2_n_2\,
      Q => waddr(7),
      R => SR(0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity \design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_buffer__parameterized0\ is
  port (
    full_n_reg_0 : out STD_LOGIC;
    beat_valid : out STD_LOGIC;
    SR : out STD_LOGIC_VECTOR ( 0 to 0 );
    next_beat : out STD_LOGIC;
    Q : out STD_LOGIC_VECTOR ( 5 downto 0 );
    DI : out STD_LOGIC_VECTOR ( 0 to 0 );
    dout_valid_reg_0 : out STD_LOGIC;
    S : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \usedw_reg[6]_0\ : out STD_LOGIC_VECTOR ( 2 downto 0 );
    \dout_buf_reg[34]_0\ : out STD_LOGIC_VECTOR ( 32 downto 0 );
    ap_clk : in STD_LOGIC;
    D : in STD_LOGIC_VECTOR ( 32 downto 0 );
    m_axi_gmem_RRESP : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_gmem_RVALID : in STD_LOGIC;
    ap_rst_n : in STD_LOGIC;
    dout_valid_reg_1 : in STD_LOGIC;
    rdata_ack_t : in STD_LOGIC;
    \usedw_reg[7]_0\ : in STD_LOGIC_VECTOR ( 6 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_buffer__parameterized0\ : entity is "simple_accel_core_gmem_m_axi_buffer";
end \design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_buffer__parameterized0\;

architecture STRUCTURE of \design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_buffer__parameterized0\ is
  signal \^q\ : STD_LOGIC_VECTOR ( 5 downto 0 );
  signal \^sr\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \^beat_valid\ : STD_LOGIC;
  signal \dout_buf[0]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[10]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[11]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[12]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[13]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[14]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[15]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[16]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[17]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[18]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[19]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[1]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[20]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[21]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[22]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[23]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[24]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[25]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[26]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[27]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[28]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[29]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[2]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[30]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[31]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[34]_i_2_n_2\ : STD_LOGIC;
  signal \dout_buf[3]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[4]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[5]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[6]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[7]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[8]_i_1_n_2\ : STD_LOGIC;
  signal \dout_buf[9]_i_1_n_2\ : STD_LOGIC;
  signal \dout_valid_i_1__0_n_2\ : STD_LOGIC;
  signal empty_n_i_1_n_2 : STD_LOGIC;
  signal \empty_n_i_2__0_n_2\ : STD_LOGIC;
  signal \empty_n_i_3__0_n_2\ : STD_LOGIC;
  signal empty_n_reg_n_2 : STD_LOGIC;
  signal \full_n_i_1__0_n_2\ : STD_LOGIC;
  signal \full_n_i_2__5_n_2\ : STD_LOGIC;
  signal \full_n_i_3__3_n_2\ : STD_LOGIC;
  signal \^full_n_reg_0\ : STD_LOGIC;
  signal mem_reg_i_10_n_2 : STD_LOGIC;
  signal mem_reg_i_9_n_2 : STD_LOGIC;
  signal mem_reg_n_34 : STD_LOGIC;
  signal mem_reg_n_35 : STD_LOGIC;
  signal pop : STD_LOGIC;
  signal push : STD_LOGIC;
  signal q_buf : STD_LOGIC_VECTOR ( 34 downto 0 );
  signal \q_tmp_reg_n_2_[0]\ : STD_LOGIC;
  signal \q_tmp_reg_n_2_[10]\ : STD_LOGIC;
  signal \q_tmp_reg_n_2_[11]\ : STD_LOGIC;
  signal \q_tmp_reg_n_2_[12]\ : STD_LOGIC;
  signal \q_tmp_reg_n_2_[13]\ : STD_LOGIC;
  signal \q_tmp_reg_n_2_[14]\ : STD_LOGIC;
  signal \q_tmp_reg_n_2_[15]\ : STD_LOGIC;
  signal \q_tmp_reg_n_2_[16]\ : STD_LOGIC;
  signal \q_tmp_reg_n_2_[17]\ : STD_LOGIC;
  signal \q_tmp_reg_n_2_[18]\ : STD_LOGIC;
  signal \q_tmp_reg_n_2_[19]\ : STD_LOGIC;
  signal \q_tmp_reg_n_2_[1]\ : STD_LOGIC;
  signal \q_tmp_reg_n_2_[20]\ : STD_LOGIC;
  signal \q_tmp_reg_n_2_[21]\ : STD_LOGIC;
  signal \q_tmp_reg_n_2_[22]\ : STD_LOGIC;
  signal \q_tmp_reg_n_2_[23]\ : STD_LOGIC;
  signal \q_tmp_reg_n_2_[24]\ : STD_LOGIC;
  signal \q_tmp_reg_n_2_[25]\ : STD_LOGIC;
  signal \q_tmp_reg_n_2_[26]\ : STD_LOGIC;
  signal \q_tmp_reg_n_2_[27]\ : STD_LOGIC;
  signal \q_tmp_reg_n_2_[28]\ : STD_LOGIC;
  signal \q_tmp_reg_n_2_[29]\ : STD_LOGIC;
  signal \q_tmp_reg_n_2_[2]\ : STD_LOGIC;
  signal \q_tmp_reg_n_2_[30]\ : STD_LOGIC;
  signal \q_tmp_reg_n_2_[31]\ : STD_LOGIC;
  signal \q_tmp_reg_n_2_[34]\ : STD_LOGIC;
  signal \q_tmp_reg_n_2_[3]\ : STD_LOGIC;
  signal \q_tmp_reg_n_2_[4]\ : STD_LOGIC;
  signal \q_tmp_reg_n_2_[5]\ : STD_LOGIC;
  signal \q_tmp_reg_n_2_[6]\ : STD_LOGIC;
  signal \q_tmp_reg_n_2_[7]\ : STD_LOGIC;
  signal \q_tmp_reg_n_2_[8]\ : STD_LOGIC;
  signal \q_tmp_reg_n_2_[9]\ : STD_LOGIC;
  signal \raddr_reg_n_2_[0]\ : STD_LOGIC;
  signal \raddr_reg_n_2_[1]\ : STD_LOGIC;
  signal \raddr_reg_n_2_[2]\ : STD_LOGIC;
  signal \raddr_reg_n_2_[3]\ : STD_LOGIC;
  signal \raddr_reg_n_2_[4]\ : STD_LOGIC;
  signal \raddr_reg_n_2_[5]\ : STD_LOGIC;
  signal \raddr_reg_n_2_[6]\ : STD_LOGIC;
  signal \raddr_reg_n_2_[7]\ : STD_LOGIC;
  signal rnext : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal show_ahead0 : STD_LOGIC;
  signal show_ahead_reg_n_2 : STD_LOGIC;
  signal \usedw[0]_i_1__0_n_2\ : STD_LOGIC;
  signal \usedw[7]_i_1_n_2\ : STD_LOGIC;
  signal \usedw_reg__0\ : STD_LOGIC_VECTOR ( 7 downto 6 );
  signal waddr : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \waddr[0]_i_1__0_n_2\ : STD_LOGIC;
  signal \waddr[1]_i_1__0_n_2\ : STD_LOGIC;
  signal \waddr[2]_i_1__0_n_2\ : STD_LOGIC;
  signal \waddr[3]_i_1__0_n_2\ : STD_LOGIC;
  signal \waddr[4]_i_1__0_n_2\ : STD_LOGIC;
  signal \waddr[5]_i_1__1_n_2\ : STD_LOGIC;
  signal \waddr[6]_i_1__0_n_2\ : STD_LOGIC;
  signal \waddr[6]_i_2__0_n_2\ : STD_LOGIC;
  signal \waddr[7]_i_2__0_n_2\ : STD_LOGIC;
  signal \waddr[7]_i_3__0_n_2\ : STD_LOGIC;
  signal \waddr[7]_i_4__0_n_2\ : STD_LOGIC;
  signal NLW_mem_reg_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 1 to 1 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \bus_equal_gen.data_buf[31]_i_1__0\ : label is "soft_lutpair53";
  attribute SOFT_HLUTNM of \dout_buf[0]_i_1\ : label is "soft_lutpair55";
  attribute SOFT_HLUTNM of \dout_buf[10]_i_1\ : label is "soft_lutpair62";
  attribute SOFT_HLUTNM of \dout_buf[11]_i_1\ : label is "soft_lutpair65";
  attribute SOFT_HLUTNM of \dout_buf[12]_i_1\ : label is "soft_lutpair66";
  attribute SOFT_HLUTNM of \dout_buf[13]_i_1\ : label is "soft_lutpair67";
  attribute SOFT_HLUTNM of \dout_buf[14]_i_1\ : label is "soft_lutpair64";
  attribute SOFT_HLUTNM of \dout_buf[15]_i_1\ : label is "soft_lutpair63";
  attribute SOFT_HLUTNM of \dout_buf[16]_i_1\ : label is "soft_lutpair56";
  attribute SOFT_HLUTNM of \dout_buf[17]_i_1\ : label is "soft_lutpair55";
  attribute SOFT_HLUTNM of \dout_buf[18]_i_1\ : label is "soft_lutpair58";
  attribute SOFT_HLUTNM of \dout_buf[19]_i_1\ : label is "soft_lutpair57";
  attribute SOFT_HLUTNM of \dout_buf[1]_i_1\ : label is "soft_lutpair56";
  attribute SOFT_HLUTNM of \dout_buf[20]_i_1\ : label is "soft_lutpair59";
  attribute SOFT_HLUTNM of \dout_buf[21]_i_1\ : label is "soft_lutpair65";
  attribute SOFT_HLUTNM of \dout_buf[22]_i_1\ : label is "soft_lutpair60";
  attribute SOFT_HLUTNM of \dout_buf[23]_i_1\ : label is "soft_lutpair61";
  attribute SOFT_HLUTNM of \dout_buf[24]_i_1\ : label is "soft_lutpair68";
  attribute SOFT_HLUTNM of \dout_buf[25]_i_1\ : label is "soft_lutpair69";
  attribute SOFT_HLUTNM of \dout_buf[26]_i_1\ : label is "soft_lutpair66";
  attribute SOFT_HLUTNM of \dout_buf[27]_i_1\ : label is "soft_lutpair70";
  attribute SOFT_HLUTNM of \dout_buf[28]_i_1\ : label is "soft_lutpair70";
  attribute SOFT_HLUTNM of \dout_buf[2]_i_1\ : label is "soft_lutpair57";
  attribute SOFT_HLUTNM of \dout_buf[30]_i_1\ : label is "soft_lutpair67";
  attribute SOFT_HLUTNM of \dout_buf[31]_i_1\ : label is "soft_lutpair68";
  attribute SOFT_HLUTNM of \dout_buf[34]_i_2\ : label is "soft_lutpair69";
  attribute SOFT_HLUTNM of \dout_buf[3]_i_1\ : label is "soft_lutpair58";
  attribute SOFT_HLUTNM of \dout_buf[4]_i_1\ : label is "soft_lutpair59";
  attribute SOFT_HLUTNM of \dout_buf[5]_i_1\ : label is "soft_lutpair60";
  attribute SOFT_HLUTNM of \dout_buf[6]_i_1\ : label is "soft_lutpair61";
  attribute SOFT_HLUTNM of \dout_buf[7]_i_1\ : label is "soft_lutpair62";
  attribute SOFT_HLUTNM of \dout_buf[8]_i_1\ : label is "soft_lutpair63";
  attribute SOFT_HLUTNM of \dout_buf[9]_i_1\ : label is "soft_lutpair64";
  attribute SOFT_HLUTNM of \dout_valid_i_1__0\ : label is "soft_lutpair53";
  attribute SOFT_HLUTNM of \full_n_i_2__5\ : label is "soft_lutpair54";
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ : string;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of mem_reg : label is "p3_d32";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ : string;
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of mem_reg : label is "p3_d32";
  attribute METHODOLOGY_DRC_VIOS : string;
  attribute METHODOLOGY_DRC_VIOS of mem_reg : label is "{SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS : integer;
  attribute RTL_RAM_BITS of mem_reg : label is 8960;
  attribute RTL_RAM_NAME : string;
  attribute RTL_RAM_NAME of mem_reg : label is "mem";
  attribute bram_addr_begin : integer;
  attribute bram_addr_begin of mem_reg : label is 0;
  attribute bram_addr_end : integer;
  attribute bram_addr_end of mem_reg : label is 511;
  attribute bram_slice_begin : integer;
  attribute bram_slice_begin of mem_reg : label is 0;
  attribute bram_slice_end : integer;
  attribute bram_slice_end of mem_reg : label is 34;
  attribute ram_addr_begin : integer;
  attribute ram_addr_begin of mem_reg : label is 0;
  attribute ram_addr_end : integer;
  attribute ram_addr_end of mem_reg : label is 511;
  attribute ram_slice_begin : integer;
  attribute ram_slice_begin of mem_reg : label is 0;
  attribute ram_slice_end : integer;
  attribute ram_slice_end of mem_reg : label is 34;
  attribute SOFT_HLUTNM of \usedw[0]_i_1__0\ : label is "soft_lutpair54";
  attribute SOFT_HLUTNM of \waddr[0]_i_1__0\ : label is "soft_lutpair72";
  attribute SOFT_HLUTNM of \waddr[1]_i_1__0\ : label is "soft_lutpair72";
  attribute SOFT_HLUTNM of \waddr[2]_i_1__0\ : label is "soft_lutpair71";
  attribute SOFT_HLUTNM of \waddr[3]_i_1__0\ : label is "soft_lutpair52";
  attribute SOFT_HLUTNM of \waddr[4]_i_1__0\ : label is "soft_lutpair52";
  attribute SOFT_HLUTNM of \waddr[6]_i_2__0\ : label is "soft_lutpair71";
begin
  Q(5 downto 0) <= \^q\(5 downto 0);
  SR(0) <= \^sr\(0);
  beat_valid <= \^beat_valid\;
  full_n_reg_0 <= \^full_n_reg_0\;
\bus_equal_gen.data_buf[31]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"A2"
    )
        port map (
      I0 => \^beat_valid\,
      I1 => dout_valid_reg_1,
      I2 => rdata_ack_t,
      O => next_beat
    );
\bus_equal_gen.rdata_valid_t_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"BA"
    )
        port map (
      I0 => \^beat_valid\,
      I1 => rdata_ack_t,
      I2 => dout_valid_reg_1,
      O => dout_valid_reg_0
    );
\could_multi_bursts.awaddr_buf[31]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => ap_rst_n,
      O => \^sr\(0)
    );
\dout_buf[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \q_tmp_reg_n_2_[0]\,
      I1 => q_buf(0),
      I2 => show_ahead_reg_n_2,
      O => \dout_buf[0]_i_1_n_2\
    );
\dout_buf[10]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \q_tmp_reg_n_2_[10]\,
      I1 => q_buf(10),
      I2 => show_ahead_reg_n_2,
      O => \dout_buf[10]_i_1_n_2\
    );
\dout_buf[11]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \q_tmp_reg_n_2_[11]\,
      I1 => q_buf(11),
      I2 => show_ahead_reg_n_2,
      O => \dout_buf[11]_i_1_n_2\
    );
\dout_buf[12]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \q_tmp_reg_n_2_[12]\,
      I1 => q_buf(12),
      I2 => show_ahead_reg_n_2,
      O => \dout_buf[12]_i_1_n_2\
    );
\dout_buf[13]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \q_tmp_reg_n_2_[13]\,
      I1 => q_buf(13),
      I2 => show_ahead_reg_n_2,
      O => \dout_buf[13]_i_1_n_2\
    );
\dout_buf[14]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \q_tmp_reg_n_2_[14]\,
      I1 => q_buf(14),
      I2 => show_ahead_reg_n_2,
      O => \dout_buf[14]_i_1_n_2\
    );
\dout_buf[15]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \q_tmp_reg_n_2_[15]\,
      I1 => q_buf(15),
      I2 => show_ahead_reg_n_2,
      O => \dout_buf[15]_i_1_n_2\
    );
\dout_buf[16]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \q_tmp_reg_n_2_[16]\,
      I1 => q_buf(16),
      I2 => show_ahead_reg_n_2,
      O => \dout_buf[16]_i_1_n_2\
    );
\dout_buf[17]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \q_tmp_reg_n_2_[17]\,
      I1 => q_buf(17),
      I2 => show_ahead_reg_n_2,
      O => \dout_buf[17]_i_1_n_2\
    );
\dout_buf[18]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \q_tmp_reg_n_2_[18]\,
      I1 => q_buf(18),
      I2 => show_ahead_reg_n_2,
      O => \dout_buf[18]_i_1_n_2\
    );
\dout_buf[19]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \q_tmp_reg_n_2_[19]\,
      I1 => q_buf(19),
      I2 => show_ahead_reg_n_2,
      O => \dout_buf[19]_i_1_n_2\
    );
\dout_buf[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \q_tmp_reg_n_2_[1]\,
      I1 => q_buf(1),
      I2 => show_ahead_reg_n_2,
      O => \dout_buf[1]_i_1_n_2\
    );
\dout_buf[20]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \q_tmp_reg_n_2_[20]\,
      I1 => q_buf(20),
      I2 => show_ahead_reg_n_2,
      O => \dout_buf[20]_i_1_n_2\
    );
\dout_buf[21]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \q_tmp_reg_n_2_[21]\,
      I1 => q_buf(21),
      I2 => show_ahead_reg_n_2,
      O => \dout_buf[21]_i_1_n_2\
    );
\dout_buf[22]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \q_tmp_reg_n_2_[22]\,
      I1 => q_buf(22),
      I2 => show_ahead_reg_n_2,
      O => \dout_buf[22]_i_1_n_2\
    );
\dout_buf[23]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \q_tmp_reg_n_2_[23]\,
      I1 => q_buf(23),
      I2 => show_ahead_reg_n_2,
      O => \dout_buf[23]_i_1_n_2\
    );
\dout_buf[24]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \q_tmp_reg_n_2_[24]\,
      I1 => q_buf(24),
      I2 => show_ahead_reg_n_2,
      O => \dout_buf[24]_i_1_n_2\
    );
\dout_buf[25]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \q_tmp_reg_n_2_[25]\,
      I1 => q_buf(25),
      I2 => show_ahead_reg_n_2,
      O => \dout_buf[25]_i_1_n_2\
    );
\dout_buf[26]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \q_tmp_reg_n_2_[26]\,
      I1 => q_buf(26),
      I2 => show_ahead_reg_n_2,
      O => \dout_buf[26]_i_1_n_2\
    );
\dout_buf[27]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \q_tmp_reg_n_2_[27]\,
      I1 => q_buf(27),
      I2 => show_ahead_reg_n_2,
      O => \dout_buf[27]_i_1_n_2\
    );
\dout_buf[28]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \q_tmp_reg_n_2_[28]\,
      I1 => q_buf(28),
      I2 => show_ahead_reg_n_2,
      O => \dout_buf[28]_i_1_n_2\
    );
\dout_buf[29]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \q_tmp_reg_n_2_[29]\,
      I1 => q_buf(29),
      I2 => show_ahead_reg_n_2,
      O => \dout_buf[29]_i_1_n_2\
    );
\dout_buf[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \q_tmp_reg_n_2_[2]\,
      I1 => q_buf(2),
      I2 => show_ahead_reg_n_2,
      O => \dout_buf[2]_i_1_n_2\
    );
\dout_buf[30]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \q_tmp_reg_n_2_[30]\,
      I1 => q_buf(30),
      I2 => show_ahead_reg_n_2,
      O => \dout_buf[30]_i_1_n_2\
    );
\dout_buf[31]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \q_tmp_reg_n_2_[31]\,
      I1 => q_buf(31),
      I2 => show_ahead_reg_n_2,
      O => \dout_buf[31]_i_1_n_2\
    );
\dout_buf[34]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8AAA"
    )
        port map (
      I0 => empty_n_reg_n_2,
      I1 => rdata_ack_t,
      I2 => dout_valid_reg_1,
      I3 => \^beat_valid\,
      O => pop
    );
\dout_buf[34]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \q_tmp_reg_n_2_[34]\,
      I1 => q_buf(34),
      I2 => show_ahead_reg_n_2,
      O => \dout_buf[34]_i_2_n_2\
    );
\dout_buf[3]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \q_tmp_reg_n_2_[3]\,
      I1 => q_buf(3),
      I2 => show_ahead_reg_n_2,
      O => \dout_buf[3]_i_1_n_2\
    );
\dout_buf[4]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \q_tmp_reg_n_2_[4]\,
      I1 => q_buf(4),
      I2 => show_ahead_reg_n_2,
      O => \dout_buf[4]_i_1_n_2\
    );
\dout_buf[5]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \q_tmp_reg_n_2_[5]\,
      I1 => q_buf(5),
      I2 => show_ahead_reg_n_2,
      O => \dout_buf[5]_i_1_n_2\
    );
\dout_buf[6]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \q_tmp_reg_n_2_[6]\,
      I1 => q_buf(6),
      I2 => show_ahead_reg_n_2,
      O => \dout_buf[6]_i_1_n_2\
    );
\dout_buf[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \q_tmp_reg_n_2_[7]\,
      I1 => q_buf(7),
      I2 => show_ahead_reg_n_2,
      O => \dout_buf[7]_i_1_n_2\
    );
\dout_buf[8]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \q_tmp_reg_n_2_[8]\,
      I1 => q_buf(8),
      I2 => show_ahead_reg_n_2,
      O => \dout_buf[8]_i_1_n_2\
    );
\dout_buf[9]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => \q_tmp_reg_n_2_[9]\,
      I1 => q_buf(9),
      I2 => show_ahead_reg_n_2,
      O => \dout_buf[9]_i_1_n_2\
    );
\dout_buf_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[0]_i_1_n_2\,
      Q => \dout_buf_reg[34]_0\(0),
      R => \^sr\(0)
    );
\dout_buf_reg[10]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[10]_i_1_n_2\,
      Q => \dout_buf_reg[34]_0\(10),
      R => \^sr\(0)
    );
\dout_buf_reg[11]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[11]_i_1_n_2\,
      Q => \dout_buf_reg[34]_0\(11),
      R => \^sr\(0)
    );
\dout_buf_reg[12]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[12]_i_1_n_2\,
      Q => \dout_buf_reg[34]_0\(12),
      R => \^sr\(0)
    );
\dout_buf_reg[13]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[13]_i_1_n_2\,
      Q => \dout_buf_reg[34]_0\(13),
      R => \^sr\(0)
    );
\dout_buf_reg[14]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[14]_i_1_n_2\,
      Q => \dout_buf_reg[34]_0\(14),
      R => \^sr\(0)
    );
\dout_buf_reg[15]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[15]_i_1_n_2\,
      Q => \dout_buf_reg[34]_0\(15),
      R => \^sr\(0)
    );
\dout_buf_reg[16]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[16]_i_1_n_2\,
      Q => \dout_buf_reg[34]_0\(16),
      R => \^sr\(0)
    );
\dout_buf_reg[17]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[17]_i_1_n_2\,
      Q => \dout_buf_reg[34]_0\(17),
      R => \^sr\(0)
    );
\dout_buf_reg[18]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[18]_i_1_n_2\,
      Q => \dout_buf_reg[34]_0\(18),
      R => \^sr\(0)
    );
\dout_buf_reg[19]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[19]_i_1_n_2\,
      Q => \dout_buf_reg[34]_0\(19),
      R => \^sr\(0)
    );
\dout_buf_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[1]_i_1_n_2\,
      Q => \dout_buf_reg[34]_0\(1),
      R => \^sr\(0)
    );
\dout_buf_reg[20]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[20]_i_1_n_2\,
      Q => \dout_buf_reg[34]_0\(20),
      R => \^sr\(0)
    );
\dout_buf_reg[21]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[21]_i_1_n_2\,
      Q => \dout_buf_reg[34]_0\(21),
      R => \^sr\(0)
    );
\dout_buf_reg[22]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[22]_i_1_n_2\,
      Q => \dout_buf_reg[34]_0\(22),
      R => \^sr\(0)
    );
\dout_buf_reg[23]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[23]_i_1_n_2\,
      Q => \dout_buf_reg[34]_0\(23),
      R => \^sr\(0)
    );
\dout_buf_reg[24]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[24]_i_1_n_2\,
      Q => \dout_buf_reg[34]_0\(24),
      R => \^sr\(0)
    );
\dout_buf_reg[25]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[25]_i_1_n_2\,
      Q => \dout_buf_reg[34]_0\(25),
      R => \^sr\(0)
    );
\dout_buf_reg[26]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[26]_i_1_n_2\,
      Q => \dout_buf_reg[34]_0\(26),
      R => \^sr\(0)
    );
\dout_buf_reg[27]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[27]_i_1_n_2\,
      Q => \dout_buf_reg[34]_0\(27),
      R => \^sr\(0)
    );
\dout_buf_reg[28]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[28]_i_1_n_2\,
      Q => \dout_buf_reg[34]_0\(28),
      R => \^sr\(0)
    );
\dout_buf_reg[29]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[29]_i_1_n_2\,
      Q => \dout_buf_reg[34]_0\(29),
      R => \^sr\(0)
    );
\dout_buf_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[2]_i_1_n_2\,
      Q => \dout_buf_reg[34]_0\(2),
      R => \^sr\(0)
    );
\dout_buf_reg[30]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[30]_i_1_n_2\,
      Q => \dout_buf_reg[34]_0\(30),
      R => \^sr\(0)
    );
\dout_buf_reg[31]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[31]_i_1_n_2\,
      Q => \dout_buf_reg[34]_0\(31),
      R => \^sr\(0)
    );
\dout_buf_reg[34]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[34]_i_2_n_2\,
      Q => \dout_buf_reg[34]_0\(32),
      R => \^sr\(0)
    );
\dout_buf_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[3]_i_1_n_2\,
      Q => \dout_buf_reg[34]_0\(3),
      R => \^sr\(0)
    );
\dout_buf_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[4]_i_1_n_2\,
      Q => \dout_buf_reg[34]_0\(4),
      R => \^sr\(0)
    );
\dout_buf_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[5]_i_1_n_2\,
      Q => \dout_buf_reg[34]_0\(5),
      R => \^sr\(0)
    );
\dout_buf_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[6]_i_1_n_2\,
      Q => \dout_buf_reg[34]_0\(6),
      R => \^sr\(0)
    );
\dout_buf_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[7]_i_1_n_2\,
      Q => \dout_buf_reg[34]_0\(7),
      R => \^sr\(0)
    );
\dout_buf_reg[8]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[8]_i_1_n_2\,
      Q => \dout_buf_reg[34]_0\(8),
      R => \^sr\(0)
    );
\dout_buf_reg[9]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => pop,
      D => \dout_buf[9]_i_1_n_2\,
      Q => \dout_buf_reg[34]_0\(9),
      R => \^sr\(0)
    );
\dout_valid_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BAAA"
    )
        port map (
      I0 => empty_n_reg_n_2,
      I1 => rdata_ack_t,
      I2 => dout_valid_reg_1,
      I3 => \^beat_valid\,
      O => \dout_valid_i_1__0_n_2\
    );
dout_valid_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \dout_valid_i_1__0_n_2\,
      Q => \^beat_valid\,
      R => \^sr\(0)
    );
empty_n_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFDFDFDF0FD0D0D0"
    )
        port map (
      I0 => \^q\(0),
      I1 => \empty_n_i_2__0_n_2\,
      I2 => pop,
      I3 => \^full_n_reg_0\,
      I4 => m_axi_gmem_RVALID,
      I5 => empty_n_reg_n_2,
      O => empty_n_i_1_n_2
    );
\empty_n_i_2__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \usedw_reg__0\(6),
      I1 => \^q\(5),
      I2 => \^q\(3),
      I3 => \empty_n_i_3__0_n_2\,
      O => \empty_n_i_2__0_n_2\
    );
\empty_n_i_3__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \usedw_reg__0\(7),
      I1 => \^q\(1),
      I2 => \^q\(2),
      I3 => \^q\(4),
      O => \empty_n_i_3__0_n_2\
    );
empty_n_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => empty_n_i_1_n_2,
      Q => empty_n_reg_n_2,
      R => \^sr\(0)
    );
\full_n_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFDFF5555"
    )
        port map (
      I0 => ap_rst_n,
      I1 => \full_n_i_2__5_n_2\,
      I2 => \full_n_i_3__3_n_2\,
      I3 => m_axi_gmem_RVALID,
      I4 => \^full_n_reg_0\,
      I5 => pop,
      O => \full_n_i_1__0_n_2\
    );
\full_n_i_2__5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => \^q\(0),
      I1 => \^q\(2),
      I2 => \usedw_reg__0\(6),
      I3 => \^q\(4),
      O => \full_n_i_2__5_n_2\
    );
\full_n_i_3__3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => \^q\(3),
      I1 => \^q\(1),
      I2 => \^q\(5),
      I3 => \usedw_reg__0\(7),
      O => \full_n_i_3__3_n_2\
    );
full_n_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '1'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \full_n_i_1__0_n_2\,
      Q => \^full_n_reg_0\,
      R => '0'
    );
mem_reg: unisim.vcomponents.RAMB18E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      INIT_A => X"00000",
      INIT_B => X"00000",
      RAM_MODE => "SDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 36,
      READ_WIDTH_B => 0,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"00000",
      SRVAL_B => X"00000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "READ_FIRST",
      WRITE_WIDTH_A => 0,
      WRITE_WIDTH_B => 36
    )
        port map (
      ADDRARDADDR(13) => '1',
      ADDRARDADDR(12 downto 5) => rnext(7 downto 0),
      ADDRARDADDR(4 downto 0) => B"11111",
      ADDRBWRADDR(13) => '1',
      ADDRBWRADDR(12 downto 5) => waddr(7 downto 0),
      ADDRBWRADDR(4 downto 0) => B"11111",
      CLKARDCLK => ap_clk,
      CLKBWRCLK => ap_clk,
      DIADI(15 downto 0) => D(15 downto 0),
      DIBDI(15 downto 0) => D(31 downto 16),
      DIPADIP(1 downto 0) => m_axi_gmem_RRESP(1 downto 0),
      DIPBDIP(1) => '1',
      DIPBDIP(0) => D(32),
      DOADO(15 downto 0) => q_buf(15 downto 0),
      DOBDO(15 downto 0) => q_buf(31 downto 16),
      DOPADOP(1) => mem_reg_n_34,
      DOPADOP(0) => mem_reg_n_35,
      DOPBDOP(1) => NLW_mem_reg_DOPBDOP_UNCONNECTED(1),
      DOPBDOP(0) => q_buf(34),
      ENARDEN => '1',
      ENBWREN => \^full_n_reg_0\,
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      WEA(1 downto 0) => B"00",
      WEBWE(3) => m_axi_gmem_RVALID,
      WEBWE(2) => m_axi_gmem_RVALID,
      WEBWE(1) => m_axi_gmem_RVALID,
      WEBWE(0) => m_axi_gmem_RVALID
    );
mem_reg_i_10: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7555FFFFFFFFFFFF"
    )
        port map (
      I0 => empty_n_reg_n_2,
      I1 => rdata_ack_t,
      I2 => dout_valid_reg_1,
      I3 => \^beat_valid\,
      I4 => \raddr_reg_n_2_[0]\,
      I5 => \raddr_reg_n_2_[1]\,
      O => mem_reg_i_10_n_2
    );
\mem_reg_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9AAA"
    )
        port map (
      I0 => \raddr_reg_n_2_[7]\,
      I1 => mem_reg_i_9_n_2,
      I2 => \raddr_reg_n_2_[5]\,
      I3 => \raddr_reg_n_2_[6]\,
      O => rnext(7)
    );
\mem_reg_i_2__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F7FFFFFF08000000"
    )
        port map (
      I0 => \raddr_reg_n_2_[4]\,
      I1 => \raddr_reg_n_2_[2]\,
      I2 => mem_reg_i_10_n_2,
      I3 => \raddr_reg_n_2_[3]\,
      I4 => \raddr_reg_n_2_[5]\,
      I5 => \raddr_reg_n_2_[6]\,
      O => rnext(6)
    );
\mem_reg_i_3__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A6AAAAAA"
    )
        port map (
      I0 => \raddr_reg_n_2_[5]\,
      I1 => \raddr_reg_n_2_[3]\,
      I2 => mem_reg_i_10_n_2,
      I3 => \raddr_reg_n_2_[2]\,
      I4 => \raddr_reg_n_2_[4]\,
      O => rnext(5)
    );
\mem_reg_i_4__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6AAAAAAAAAAAAAAA"
    )
        port map (
      I0 => \raddr_reg_n_2_[4]\,
      I1 => \raddr_reg_n_2_[2]\,
      I2 => pop,
      I3 => \raddr_reg_n_2_[0]\,
      I4 => \raddr_reg_n_2_[1]\,
      I5 => \raddr_reg_n_2_[3]\,
      O => rnext(4)
    );
\mem_reg_i_5__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"6AAAAAAA"
    )
        port map (
      I0 => \raddr_reg_n_2_[3]\,
      I1 => \raddr_reg_n_2_[1]\,
      I2 => \raddr_reg_n_2_[0]\,
      I3 => pop,
      I4 => \raddr_reg_n_2_[2]\,
      O => rnext(3)
    );
\mem_reg_i_6__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6AAA"
    )
        port map (
      I0 => \raddr_reg_n_2_[2]\,
      I1 => pop,
      I2 => \raddr_reg_n_2_[0]\,
      I3 => \raddr_reg_n_2_[1]\,
      O => rnext(2)
    );
\mem_reg_i_7__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6666A666AAAAAAAA"
    )
        port map (
      I0 => \raddr_reg_n_2_[1]\,
      I1 => \raddr_reg_n_2_[0]\,
      I2 => \^beat_valid\,
      I3 => dout_valid_reg_1,
      I4 => rdata_ack_t,
      I5 => empty_n_reg_n_2,
      O => rnext(1)
    );
mem_reg_i_8: unisim.vcomponents.LUT5
    generic map(
      INIT => X"5595AAAA"
    )
        port map (
      I0 => \raddr_reg_n_2_[0]\,
      I1 => \^beat_valid\,
      I2 => dout_valid_reg_1,
      I3 => rdata_ack_t,
      I4 => empty_n_reg_n_2,
      O => rnext(0)
    );
mem_reg_i_9: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7FFFFFFFFFFFFFFF"
    )
        port map (
      I0 => \raddr_reg_n_2_[3]\,
      I1 => \raddr_reg_n_2_[1]\,
      I2 => \raddr_reg_n_2_[0]\,
      I3 => pop,
      I4 => \raddr_reg_n_2_[2]\,
      I5 => \raddr_reg_n_2_[4]\,
      O => mem_reg_i_9_n_2
    );
\p_0_out__18_carry__0_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \usedw_reg__0\(6),
      I1 => \usedw_reg__0\(7),
      O => \usedw_reg[6]_0\(2)
    );
\p_0_out__18_carry__0_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^q\(5),
      I1 => \usedw_reg__0\(6),
      O => \usedw_reg[6]_0\(1)
    );
\p_0_out__18_carry__0_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^q\(4),
      I1 => \^q\(5),
      O => \usedw_reg[6]_0\(0)
    );
\p_0_out__18_carry_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q\(1),
      O => DI(0)
    );
\p_0_out__18_carry_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^q\(3),
      I1 => \^q\(4),
      O => S(3)
    );
\p_0_out__18_carry_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^q\(2),
      I1 => \^q\(3),
      O => S(2)
    );
\p_0_out__18_carry_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^q\(1),
      I1 => \^q\(2),
      O => S(1)
    );
\p_0_out__18_carry_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6A66666655555555"
    )
        port map (
      I0 => \^q\(1),
      I1 => empty_n_reg_n_2,
      I2 => rdata_ack_t,
      I3 => dout_valid_reg_1,
      I4 => \^beat_valid\,
      I5 => push,
      O => S(0)
    );
\q_tmp_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => D(0),
      Q => \q_tmp_reg_n_2_[0]\,
      R => \^sr\(0)
    );
\q_tmp_reg[10]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => D(10),
      Q => \q_tmp_reg_n_2_[10]\,
      R => \^sr\(0)
    );
\q_tmp_reg[11]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => D(11),
      Q => \q_tmp_reg_n_2_[11]\,
      R => \^sr\(0)
    );
\q_tmp_reg[12]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => D(12),
      Q => \q_tmp_reg_n_2_[12]\,
      R => \^sr\(0)
    );
\q_tmp_reg[13]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => D(13),
      Q => \q_tmp_reg_n_2_[13]\,
      R => \^sr\(0)
    );
\q_tmp_reg[14]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => D(14),
      Q => \q_tmp_reg_n_2_[14]\,
      R => \^sr\(0)
    );
\q_tmp_reg[15]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => D(15),
      Q => \q_tmp_reg_n_2_[15]\,
      R => \^sr\(0)
    );
\q_tmp_reg[16]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => D(16),
      Q => \q_tmp_reg_n_2_[16]\,
      R => \^sr\(0)
    );
\q_tmp_reg[17]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => D(17),
      Q => \q_tmp_reg_n_2_[17]\,
      R => \^sr\(0)
    );
\q_tmp_reg[18]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => D(18),
      Q => \q_tmp_reg_n_2_[18]\,
      R => \^sr\(0)
    );
\q_tmp_reg[19]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => D(19),
      Q => \q_tmp_reg_n_2_[19]\,
      R => \^sr\(0)
    );
\q_tmp_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => D(1),
      Q => \q_tmp_reg_n_2_[1]\,
      R => \^sr\(0)
    );
\q_tmp_reg[20]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => D(20),
      Q => \q_tmp_reg_n_2_[20]\,
      R => \^sr\(0)
    );
\q_tmp_reg[21]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => D(21),
      Q => \q_tmp_reg_n_2_[21]\,
      R => \^sr\(0)
    );
\q_tmp_reg[22]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => D(22),
      Q => \q_tmp_reg_n_2_[22]\,
      R => \^sr\(0)
    );
\q_tmp_reg[23]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => D(23),
      Q => \q_tmp_reg_n_2_[23]\,
      R => \^sr\(0)
    );
\q_tmp_reg[24]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => D(24),
      Q => \q_tmp_reg_n_2_[24]\,
      R => \^sr\(0)
    );
\q_tmp_reg[25]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => D(25),
      Q => \q_tmp_reg_n_2_[25]\,
      R => \^sr\(0)
    );
\q_tmp_reg[26]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => D(26),
      Q => \q_tmp_reg_n_2_[26]\,
      R => \^sr\(0)
    );
\q_tmp_reg[27]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => D(27),
      Q => \q_tmp_reg_n_2_[27]\,
      R => \^sr\(0)
    );
\q_tmp_reg[28]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => D(28),
      Q => \q_tmp_reg_n_2_[28]\,
      R => \^sr\(0)
    );
\q_tmp_reg[29]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => D(29),
      Q => \q_tmp_reg_n_2_[29]\,
      R => \^sr\(0)
    );
\q_tmp_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => D(2),
      Q => \q_tmp_reg_n_2_[2]\,
      R => \^sr\(0)
    );
\q_tmp_reg[30]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => D(30),
      Q => \q_tmp_reg_n_2_[30]\,
      R => \^sr\(0)
    );
\q_tmp_reg[31]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => D(31),
      Q => \q_tmp_reg_n_2_[31]\,
      R => \^sr\(0)
    );
\q_tmp_reg[34]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => D(32),
      Q => \q_tmp_reg_n_2_[34]\,
      R => \^sr\(0)
    );
\q_tmp_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => D(3),
      Q => \q_tmp_reg_n_2_[3]\,
      R => \^sr\(0)
    );
\q_tmp_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => D(4),
      Q => \q_tmp_reg_n_2_[4]\,
      R => \^sr\(0)
    );
\q_tmp_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => D(5),
      Q => \q_tmp_reg_n_2_[5]\,
      R => \^sr\(0)
    );
\q_tmp_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => D(6),
      Q => \q_tmp_reg_n_2_[6]\,
      R => \^sr\(0)
    );
\q_tmp_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => D(7),
      Q => \q_tmp_reg_n_2_[7]\,
      R => \^sr\(0)
    );
\q_tmp_reg[8]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => D(8),
      Q => \q_tmp_reg_n_2_[8]\,
      R => \^sr\(0)
    );
\q_tmp_reg[9]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => D(9),
      Q => \q_tmp_reg_n_2_[9]\,
      R => \^sr\(0)
    );
\raddr_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => rnext(0),
      Q => \raddr_reg_n_2_[0]\,
      R => \^sr\(0)
    );
\raddr_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => rnext(1),
      Q => \raddr_reg_n_2_[1]\,
      R => \^sr\(0)
    );
\raddr_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => rnext(2),
      Q => \raddr_reg_n_2_[2]\,
      R => \^sr\(0)
    );
\raddr_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => rnext(3),
      Q => \raddr_reg_n_2_[3]\,
      R => \^sr\(0)
    );
\raddr_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => rnext(4),
      Q => \raddr_reg_n_2_[4]\,
      R => \^sr\(0)
    );
\raddr_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => rnext(5),
      Q => \raddr_reg_n_2_[5]\,
      R => \^sr\(0)
    );
\raddr_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => rnext(6),
      Q => \raddr_reg_n_2_[6]\,
      R => \^sr\(0)
    );
\raddr_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => rnext(7),
      Q => \raddr_reg_n_2_[7]\,
      R => \^sr\(0)
    );
\show_ahead_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"40000040"
    )
        port map (
      I0 => \empty_n_i_2__0_n_2\,
      I1 => m_axi_gmem_RVALID,
      I2 => \^full_n_reg_0\,
      I3 => \^q\(0),
      I4 => pop,
      O => show_ahead0
    );
show_ahead_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => show_ahead0,
      Q => show_ahead_reg_n_2,
      R => \^sr\(0)
    );
\usedw[0]_i_1__0\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q\(0),
      O => \usedw[0]_i_1__0_n_2\
    );
\usedw[7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"08FFF700F700F700"
    )
        port map (
      I0 => \^beat_valid\,
      I1 => dout_valid_reg_1,
      I2 => rdata_ack_t,
      I3 => empty_n_reg_n_2,
      I4 => m_axi_gmem_RVALID,
      I5 => \^full_n_reg_0\,
      O => \usedw[7]_i_1_n_2\
    );
\usedw_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \usedw[7]_i_1_n_2\,
      D => \usedw[0]_i_1__0_n_2\,
      Q => \^q\(0),
      R => \^sr\(0)
    );
\usedw_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \usedw[7]_i_1_n_2\,
      D => \usedw_reg[7]_0\(0),
      Q => \^q\(1),
      R => \^sr\(0)
    );
\usedw_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \usedw[7]_i_1_n_2\,
      D => \usedw_reg[7]_0\(1),
      Q => \^q\(2),
      R => \^sr\(0)
    );
\usedw_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \usedw[7]_i_1_n_2\,
      D => \usedw_reg[7]_0\(2),
      Q => \^q\(3),
      R => \^sr\(0)
    );
\usedw_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \usedw[7]_i_1_n_2\,
      D => \usedw_reg[7]_0\(3),
      Q => \^q\(4),
      R => \^sr\(0)
    );
\usedw_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \usedw[7]_i_1_n_2\,
      D => \usedw_reg[7]_0\(4),
      Q => \^q\(5),
      R => \^sr\(0)
    );
\usedw_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \usedw[7]_i_1_n_2\,
      D => \usedw_reg[7]_0\(5),
      Q => \usedw_reg__0\(6),
      R => \^sr\(0)
    );
\usedw_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => \usedw[7]_i_1_n_2\,
      D => \usedw_reg[7]_0\(6),
      Q => \usedw_reg__0\(7),
      R => \^sr\(0)
    );
\waddr[0]_i_1__0\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => waddr(0),
      O => \waddr[0]_i_1__0_n_2\
    );
\waddr[1]_i_1__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => waddr(0),
      I1 => waddr(1),
      O => \waddr[1]_i_1__0_n_2\
    );
\waddr[2]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"6A"
    )
        port map (
      I0 => waddr(2),
      I1 => waddr(0),
      I2 => waddr(1),
      O => \waddr[2]_i_1__0_n_2\
    );
\waddr[3]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6AAA"
    )
        port map (
      I0 => waddr(3),
      I1 => waddr(0),
      I2 => waddr(1),
      I3 => waddr(2),
      O => \waddr[3]_i_1__0_n_2\
    );
\waddr[4]_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"6AAAAAAA"
    )
        port map (
      I0 => waddr(4),
      I1 => waddr(2),
      I2 => waddr(1),
      I3 => waddr(0),
      I4 => waddr(3),
      O => \waddr[4]_i_1__0_n_2\
    );
\waddr[5]_i_1__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6AAAAAAAAAAAAAAA"
    )
        port map (
      I0 => waddr(5),
      I1 => waddr(3),
      I2 => waddr(0),
      I3 => waddr(1),
      I4 => waddr(2),
      I5 => waddr(4),
      O => \waddr[5]_i_1__1_n_2\
    );
\waddr[6]_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6AAAAAAAAAAAAAAA"
    )
        port map (
      I0 => waddr(6),
      I1 => waddr(4),
      I2 => waddr(2),
      I3 => \waddr[6]_i_2__0_n_2\,
      I4 => waddr(3),
      I5 => waddr(5),
      O => \waddr[6]_i_1__0_n_2\
    );
\waddr[6]_i_2__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => waddr(1),
      I1 => waddr(0),
      O => \waddr[6]_i_2__0_n_2\
    );
\waddr[7]_i_1__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \^full_n_reg_0\,
      I1 => m_axi_gmem_RVALID,
      O => push
    );
\waddr[7]_i_2__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B8CC"
    )
        port map (
      I0 => \waddr[7]_i_3__0_n_2\,
      I1 => waddr(7),
      I2 => \waddr[7]_i_4__0_n_2\,
      I3 => waddr(6),
      O => \waddr[7]_i_2__0_n_2\
    );
\waddr[7]_i_3__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7FFFFFFFFFFFFFFF"
    )
        port map (
      I0 => waddr(4),
      I1 => waddr(2),
      I2 => waddr(0),
      I3 => waddr(1),
      I4 => waddr(3),
      I5 => waddr(5),
      O => \waddr[7]_i_3__0_n_2\
    );
\waddr[7]_i_4__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8000000000000000"
    )
        port map (
      I0 => waddr(4),
      I1 => waddr(2),
      I2 => waddr(1),
      I3 => waddr(0),
      I4 => waddr(3),
      I5 => waddr(5),
      O => \waddr[7]_i_4__0_n_2\
    );
\waddr_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => \waddr[0]_i_1__0_n_2\,
      Q => waddr(0),
      R => \^sr\(0)
    );
\waddr_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => \waddr[1]_i_1__0_n_2\,
      Q => waddr(1),
      R => \^sr\(0)
    );
\waddr_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => \waddr[2]_i_1__0_n_2\,
      Q => waddr(2),
      R => \^sr\(0)
    );
\waddr_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => \waddr[3]_i_1__0_n_2\,
      Q => waddr(3),
      R => \^sr\(0)
    );
\waddr_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => \waddr[4]_i_1__0_n_2\,
      Q => waddr(4),
      R => \^sr\(0)
    );
\waddr_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => \waddr[5]_i_1__1_n_2\,
      Q => waddr(5),
      R => \^sr\(0)
    );
\waddr_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => \waddr[6]_i_1__0_n_2\,
      Q => waddr(6),
      R => \^sr\(0)
    );
\waddr_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => push,
      D => \waddr[7]_i_2__0_n_2\,
      Q => waddr(7),
      R => \^sr\(0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo is
  port (
    burst_valid : out STD_LOGIC;
    invalid_len_event_reg2_reg : out STD_LOGIC;
    push : out STD_LOGIC;
    E : out STD_LOGIC_VECTOR ( 0 to 0 );
    p_26_in : out STD_LOGIC;
    D : out STD_LOGIC_VECTOR ( 19 downto 0 );
    next_wreq : out STD_LOGIC;
    \could_multi_bursts.loop_cnt_reg[0]\ : out STD_LOGIC;
    \sect_len_buf_reg[3]\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    wreq_handling_reg : out STD_LOGIC;
    \could_multi_bursts.sect_handling_reg\ : out STD_LOGIC;
    \bus_equal_gen.WLAST_Dummy_reg\ : out STD_LOGIC;
    \could_multi_bursts.last_sect_buf_reg\ : out STD_LOGIC;
    ap_rst_n_0 : out STD_LOGIC_VECTOR ( 0 to 0 );
    ap_rst_n_1 : out STD_LOGIC_VECTOR ( 0 to 0 );
    ap_rst_n_2 : out STD_LOGIC_VECTOR ( 0 to 0 );
    SR : in STD_LOGIC_VECTOR ( 0 to 0 );
    ap_clk : in STD_LOGIC;
    \in\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    \could_multi_bursts.AWVALID_Dummy_reg\ : in STD_LOGIC;
    \could_multi_bursts.awaddr_buf_reg[2]\ : in STD_LOGIC;
    ap_rst_n : in STD_LOGIC;
    CO : in STD_LOGIC_VECTOR ( 0 to 0 );
    wreq_handling_reg_0 : in STD_LOGIC;
    fifo_wreq_valid : in STD_LOGIC;
    Q : in STD_LOGIC_VECTOR ( 19 downto 0 );
    sect_cnt0 : in STD_LOGIC_VECTOR ( 18 downto 0 );
    \sect_cnt_reg[0]\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    \could_multi_bursts.sect_handling_reg_0\ : in STD_LOGIC;
    \end_addr_buf_reg[31]\ : in STD_LOGIC;
    m_axi_gmem_AWREADY : in STD_LOGIC;
    \could_multi_bursts.awaddr_buf_reg[2]_0\ : in STD_LOGIC;
    \could_multi_bursts.awaddr_buf_reg[2]_1\ : in STD_LOGIC;
    \bus_equal_gen.WLAST_Dummy_i_2_0\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \q_reg[0]_0\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    \could_multi_bursts.awlen_buf[3]_i_2_0\ : in STD_LOGIC_VECTOR ( 9 downto 0 );
    \could_multi_bursts.awlen_buf[3]_i_2_1\ : in STD_LOGIC_VECTOR ( 5 downto 0 );
    wreq_handling_reg_1 : in STD_LOGIC;
    m_axi_gmem_WLAST : in STD_LOGIC;
    \bus_equal_gen.WLAST_Dummy_reg_0\ : in STD_LOGIC;
    m_axi_gmem_WREADY : in STD_LOGIC;
    \could_multi_bursts.last_sect_buf_reg_0\ : in STD_LOGIC;
    \sect_addr_buf_reg[2]\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    fifo_resp_ready : in STD_LOGIC
  );
end design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo;

architecture STRUCTURE of design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo is
  signal \^burst_valid\ : STD_LOGIC;
  signal \bus_equal_gen.WLAST_Dummy_i_3_n_2\ : STD_LOGIC;
  signal \bus_equal_gen.WLAST_Dummy_i_4_n_2\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf[31]_i_5_n_2\ : STD_LOGIC;
  signal \could_multi_bursts.awlen_buf[3]_i_3_n_2\ : STD_LOGIC;
  signal \could_multi_bursts.awlen_buf[3]_i_4_n_2\ : STD_LOGIC;
  signal \^could_multi_bursts.loop_cnt_reg[0]\ : STD_LOGIC;
  signal data_vld_i_1_n_2 : STD_LOGIC;
  signal data_vld_reg_n_2 : STD_LOGIC;
  signal fifo_burst_ready : STD_LOGIC;
  signal \full_n_i_1__1_n_2\ : STD_LOGIC;
  signal \full_n_i_2__1_n_2\ : STD_LOGIC;
  signal \mem_reg[4][0]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][1]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][2]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][3]_srl5_n_2\ : STD_LOGIC;
  signal next_burst : STD_LOGIC;
  signal \^next_wreq\ : STD_LOGIC;
  signal \^p_26_in\ : STD_LOGIC;
  signal pop0 : STD_LOGIC;
  signal \pout[0]_i_1_n_2\ : STD_LOGIC;
  signal \pout[1]_i_1_n_2\ : STD_LOGIC;
  signal \pout[2]_i_1_n_2\ : STD_LOGIC;
  signal \pout_reg_n_2_[0]\ : STD_LOGIC;
  signal \pout_reg_n_2_[1]\ : STD_LOGIC;
  signal \pout_reg_n_2_[2]\ : STD_LOGIC;
  signal \^push\ : STD_LOGIC;
  signal push_0 : STD_LOGIC;
  signal \^q\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \^sect_len_buf_reg[3]\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \bus_equal_gen.WLAST_Dummy_i_1\ : label is "soft_lutpair146";
  attribute SOFT_HLUTNM of \bus_equal_gen.len_cnt[7]_i_1\ : label is "soft_lutpair146";
  attribute SOFT_HLUTNM of \could_multi_bursts.awlen_buf[0]_i_1\ : label is "soft_lutpair160";
  attribute SOFT_HLUTNM of \could_multi_bursts.awlen_buf[1]_i_1\ : label is "soft_lutpair161";
  attribute SOFT_HLUTNM of \could_multi_bursts.awlen_buf[2]_i_1\ : label is "soft_lutpair160";
  attribute SOFT_HLUTNM of \could_multi_bursts.awlen_buf[3]_i_1\ : label is "soft_lutpair161";
  attribute SOFT_HLUTNM of \could_multi_bursts.last_sect_buf_i_1\ : label is "soft_lutpair159";
  attribute SOFT_HLUTNM of \could_multi_bursts.loop_cnt[5]_i_1__0\ : label is "soft_lutpair159";
  attribute SOFT_HLUTNM of \could_multi_bursts.sect_handling_i_1\ : label is "soft_lutpair147";
  attribute SOFT_HLUTNM of empty_n_i_1 : label is "soft_lutpair148";
  attribute srl_bus_name : string;
  attribute srl_bus_name of \mem_reg[4][0]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/bus_equal_gen.fifo_burst/mem_reg[4] ";
  attribute srl_name : string;
  attribute srl_name of \mem_reg[4][0]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/bus_equal_gen.fifo_burst/mem_reg[4][0]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][1]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/bus_equal_gen.fifo_burst/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][1]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/bus_equal_gen.fifo_burst/mem_reg[4][1]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][2]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/bus_equal_gen.fifo_burst/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][2]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/bus_equal_gen.fifo_burst/mem_reg[4][2]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][3]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/bus_equal_gen.fifo_burst/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][3]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/bus_equal_gen.fifo_burst/mem_reg[4][3]_srl5 ";
  attribute SOFT_HLUTNM of \sect_cnt[0]_i_1\ : label is "soft_lutpair158";
  attribute SOFT_HLUTNM of \sect_cnt[10]_i_1\ : label is "soft_lutpair153";
  attribute SOFT_HLUTNM of \sect_cnt[11]_i_1\ : label is "soft_lutpair149";
  attribute SOFT_HLUTNM of \sect_cnt[12]_i_1\ : label is "soft_lutpair150";
  attribute SOFT_HLUTNM of \sect_cnt[13]_i_1\ : label is "soft_lutpair152";
  attribute SOFT_HLUTNM of \sect_cnt[14]_i_1\ : label is "soft_lutpair153";
  attribute SOFT_HLUTNM of \sect_cnt[15]_i_1\ : label is "soft_lutpair151";
  attribute SOFT_HLUTNM of \sect_cnt[16]_i_1\ : label is "soft_lutpair152";
  attribute SOFT_HLUTNM of \sect_cnt[17]_i_1\ : label is "soft_lutpair151";
  attribute SOFT_HLUTNM of \sect_cnt[18]_i_1\ : label is "soft_lutpair150";
  attribute SOFT_HLUTNM of \sect_cnt[19]_i_2\ : label is "soft_lutpair149";
  attribute SOFT_HLUTNM of \sect_cnt[1]_i_1\ : label is "soft_lutpair158";
  attribute SOFT_HLUTNM of \sect_cnt[2]_i_1\ : label is "soft_lutpair157";
  attribute SOFT_HLUTNM of \sect_cnt[3]_i_1\ : label is "soft_lutpair157";
  attribute SOFT_HLUTNM of \sect_cnt[4]_i_1\ : label is "soft_lutpair156";
  attribute SOFT_HLUTNM of \sect_cnt[5]_i_1\ : label is "soft_lutpair156";
  attribute SOFT_HLUTNM of \sect_cnt[6]_i_1\ : label is "soft_lutpair154";
  attribute SOFT_HLUTNM of \sect_cnt[7]_i_1\ : label is "soft_lutpair155";
  attribute SOFT_HLUTNM of \sect_cnt[8]_i_1\ : label is "soft_lutpair155";
  attribute SOFT_HLUTNM of \sect_cnt[9]_i_1\ : label is "soft_lutpair154";
  attribute SOFT_HLUTNM of \sect_len_buf[9]_i_1\ : label is "soft_lutpair147";
  attribute SOFT_HLUTNM of wreq_handling_i_1 : label is "soft_lutpair148";
begin
  burst_valid <= \^burst_valid\;
  \could_multi_bursts.loop_cnt_reg[0]\ <= \^could_multi_bursts.loop_cnt_reg[0]\;
  next_wreq <= \^next_wreq\;
  p_26_in <= \^p_26_in\;
  push <= \^push\;
  \sect_len_buf_reg[3]\(3 downto 0) <= \^sect_len_buf_reg[3]\(3 downto 0);
\bus_equal_gen.WLAST_Dummy_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => m_axi_gmem_WLAST,
      I1 => \bus_equal_gen.WLAST_Dummy_reg_0\,
      I2 => m_axi_gmem_WREADY,
      I3 => next_burst,
      O => \bus_equal_gen.WLAST_Dummy_reg\
    );
\bus_equal_gen.WLAST_Dummy_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"41000000"
    )
        port map (
      I0 => \bus_equal_gen.WLAST_Dummy_i_3_n_2\,
      I1 => \^q\(3),
      I2 => \bus_equal_gen.WLAST_Dummy_i_2_0\(3),
      I3 => \bus_equal_gen.WLAST_Dummy_i_4_n_2\,
      I4 => \q_reg[0]_0\(0),
      O => next_burst
    );
\bus_equal_gen.WLAST_Dummy_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFEFFFFFFFFFFFE"
    )
        port map (
      I0 => \bus_equal_gen.WLAST_Dummy_i_2_0\(7),
      I1 => \bus_equal_gen.WLAST_Dummy_i_2_0\(5),
      I2 => \bus_equal_gen.WLAST_Dummy_i_2_0\(6),
      I3 => \bus_equal_gen.WLAST_Dummy_i_2_0\(4),
      I4 => \^q\(0),
      I5 => \bus_equal_gen.WLAST_Dummy_i_2_0\(0),
      O => \bus_equal_gen.WLAST_Dummy_i_3_n_2\
    );
\bus_equal_gen.WLAST_Dummy_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \bus_equal_gen.WLAST_Dummy_i_2_0\(1),
      I1 => \^q\(1),
      I2 => \^q\(2),
      I3 => \bus_equal_gen.WLAST_Dummy_i_2_0\(2),
      O => \bus_equal_gen.WLAST_Dummy_i_4_n_2\
    );
\bus_equal_gen.len_cnt[7]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => next_burst,
      I1 => ap_rst_n,
      O => ap_rst_n_2(0)
    );
\could_multi_bursts.AWVALID_Dummy_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"53500000"
    )
        port map (
      I0 => \in\(0),
      I1 => \could_multi_bursts.AWVALID_Dummy_reg\,
      I2 => \^push\,
      I3 => \could_multi_bursts.awaddr_buf_reg[2]\,
      I4 => ap_rst_n,
      O => invalid_len_event_reg2_reg
    );
\could_multi_bursts.awaddr_buf[31]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0000555D"
    )
        port map (
      I0 => \could_multi_bursts.awaddr_buf_reg[2]\,
      I1 => m_axi_gmem_AWREADY,
      I2 => \could_multi_bursts.awaddr_buf_reg[2]_0\,
      I3 => \could_multi_bursts.awaddr_buf_reg[2]_1\,
      I4 => \could_multi_bursts.awaddr_buf[31]_i_5_n_2\,
      O => \^push\
    );
\could_multi_bursts.awaddr_buf[31]_i_5\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"7F"
    )
        port map (
      I0 => fifo_burst_ready,
      I1 => fifo_resp_ready,
      I2 => \could_multi_bursts.sect_handling_reg_0\,
      O => \could_multi_bursts.awaddr_buf[31]_i_5_n_2\
    );
\could_multi_bursts.awlen_buf[0]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => \could_multi_bursts.awlen_buf[3]_i_2_0\(0),
      I1 => \^could_multi_bursts.loop_cnt_reg[0]\,
      O => \^sect_len_buf_reg[3]\(0)
    );
\could_multi_bursts.awlen_buf[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => \could_multi_bursts.awlen_buf[3]_i_2_0\(1),
      I1 => \^could_multi_bursts.loop_cnt_reg[0]\,
      O => \^sect_len_buf_reg[3]\(1)
    );
\could_multi_bursts.awlen_buf[2]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => \could_multi_bursts.awlen_buf[3]_i_2_0\(2),
      I1 => \^could_multi_bursts.loop_cnt_reg[0]\,
      O => \^sect_len_buf_reg[3]\(2)
    );
\could_multi_bursts.awlen_buf[3]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => \could_multi_bursts.awlen_buf[3]_i_2_0\(3),
      I1 => \^could_multi_bursts.loop_cnt_reg[0]\,
      O => \^sect_len_buf_reg[3]\(3)
    );
\could_multi_bursts.awlen_buf[3]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => \could_multi_bursts.awlen_buf[3]_i_3_n_2\,
      I1 => \could_multi_bursts.awlen_buf[3]_i_4_n_2\,
      O => \^could_multi_bursts.loop_cnt_reg[0]\
    );
\could_multi_bursts.awlen_buf[3]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6FF6FFFFFFFF6FF6"
    )
        port map (
      I0 => \could_multi_bursts.awlen_buf[3]_i_2_1\(0),
      I1 => \could_multi_bursts.awlen_buf[3]_i_2_0\(4),
      I2 => \could_multi_bursts.awlen_buf[3]_i_2_0\(6),
      I3 => \could_multi_bursts.awlen_buf[3]_i_2_1\(2),
      I4 => \could_multi_bursts.awlen_buf[3]_i_2_0\(5),
      I5 => \could_multi_bursts.awlen_buf[3]_i_2_1\(1),
      O => \could_multi_bursts.awlen_buf[3]_i_3_n_2\
    );
\could_multi_bursts.awlen_buf[3]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6FF6FFFFFFFF6FF6"
    )
        port map (
      I0 => \could_multi_bursts.awlen_buf[3]_i_2_1\(3),
      I1 => \could_multi_bursts.awlen_buf[3]_i_2_0\(7),
      I2 => \could_multi_bursts.awlen_buf[3]_i_2_0\(9),
      I3 => \could_multi_bursts.awlen_buf[3]_i_2_1\(5),
      I4 => \could_multi_bursts.awlen_buf[3]_i_2_0\(8),
      I5 => \could_multi_bursts.awlen_buf[3]_i_2_1\(4),
      O => \could_multi_bursts.awlen_buf[3]_i_4_n_2\
    );
\could_multi_bursts.last_sect_buf_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => CO(0),
      I1 => \^p_26_in\,
      I2 => \could_multi_bursts.last_sect_buf_reg_0\,
      O => \could_multi_bursts.last_sect_buf_reg\
    );
\could_multi_bursts.loop_cnt[5]_i_1__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => \^p_26_in\,
      I1 => ap_rst_n,
      O => ap_rst_n_0(0)
    );
\could_multi_bursts.sect_handling_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"EECE"
    )
        port map (
      I0 => \could_multi_bursts.sect_handling_reg_0\,
      I1 => wreq_handling_reg_0,
      I2 => \^push\,
      I3 => \^could_multi_bursts.loop_cnt_reg[0]\,
      O => \could_multi_bursts.sect_handling_reg\
    );
data_vld_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FAFAFAFAFAFAFABA"
    )
        port map (
      I0 => push_0,
      I1 => pop0,
      I2 => data_vld_reg_n_2,
      I3 => \pout_reg_n_2_[2]\,
      I4 => \pout_reg_n_2_[0]\,
      I5 => \pout_reg_n_2_[1]\,
      O => data_vld_i_1_n_2
    );
data_vld_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => data_vld_i_1_n_2,
      Q => data_vld_reg_n_2,
      R => SR(0)
    );
empty_n_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8FFF"
    )
        port map (
      I0 => \^p_26_in\,
      I1 => CO(0),
      I2 => wreq_handling_reg_0,
      I3 => fifo_wreq_valid,
      O => E(0)
    );
\empty_n_i_1__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => next_burst,
      I1 => \^burst_valid\,
      O => pop0
    );
empty_n_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => data_vld_reg_n_2,
      Q => \^burst_valid\,
      R => SR(0)
    );
fifo_wreq_valid_buf_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000005DDD5D5D"
    )
        port map (
      I0 => wreq_handling_reg_0,
      I1 => CO(0),
      I2 => \could_multi_bursts.sect_handling_reg_0\,
      I3 => \^could_multi_bursts.loop_cnt_reg[0]\,
      I4 => \^push\,
      I5 => \end_addr_buf_reg[31]\,
      O => \^next_wreq\
    );
\full_n_i_1__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFDDDDD5DDDDDD"
    )
        port map (
      I0 => ap_rst_n,
      I1 => fifo_burst_ready,
      I2 => \full_n_i_2__1_n_2\,
      I3 => push_0,
      I4 => data_vld_reg_n_2,
      I5 => pop0,
      O => \full_n_i_1__1_n_2\
    );
\full_n_i_2__1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"BF"
    )
        port map (
      I0 => \pout_reg_n_2_[2]\,
      I1 => \pout_reg_n_2_[0]\,
      I2 => \pout_reg_n_2_[1]\,
      O => \full_n_i_2__1_n_2\
    );
full_n_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \full_n_i_1__1_n_2\,
      Q => fifo_burst_ready,
      R => '0'
    );
\mem_reg[4][0]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push_0,
      CLK => ap_clk,
      D => \^sect_len_buf_reg[3]\(0),
      Q => \mem_reg[4][0]_srl5_n_2\
    );
\mem_reg[4][0]_srl5_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \^push\,
      I1 => \in\(0),
      O => push_0
    );
\mem_reg[4][1]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push_0,
      CLK => ap_clk,
      D => \^sect_len_buf_reg[3]\(1),
      Q => \mem_reg[4][1]_srl5_n_2\
    );
\mem_reg[4][2]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push_0,
      CLK => ap_clk,
      D => \^sect_len_buf_reg[3]\(2),
      Q => \mem_reg[4][2]_srl5_n_2\
    );
\mem_reg[4][3]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push_0,
      CLK => ap_clk,
      D => \^sect_len_buf_reg[3]\(3),
      Q => \mem_reg[4][3]_srl5_n_2\
    );
\pout[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0FF0FFF0F00E000"
    )
        port map (
      I0 => \pout_reg_n_2_[2]\,
      I1 => \pout_reg_n_2_[1]\,
      I2 => pop0,
      I3 => data_vld_reg_n_2,
      I4 => push_0,
      I5 => \pout_reg_n_2_[0]\,
      O => \pout[0]_i_1_n_2\
    );
\pout[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F708BF40F708BF00"
    )
        port map (
      I0 => push_0,
      I1 => data_vld_reg_n_2,
      I2 => pop0,
      I3 => \pout_reg_n_2_[1]\,
      I4 => \pout_reg_n_2_[0]\,
      I5 => \pout_reg_n_2_[2]\,
      O => \pout[1]_i_1_n_2\
    );
\pout[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F7FFFFBF08000000"
    )
        port map (
      I0 => push_0,
      I1 => data_vld_reg_n_2,
      I2 => pop0,
      I3 => \pout_reg_n_2_[1]\,
      I4 => \pout_reg_n_2_[0]\,
      I5 => \pout_reg_n_2_[2]\,
      O => \pout[2]_i_1_n_2\
    );
\pout_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \pout[0]_i_1_n_2\,
      Q => \pout_reg_n_2_[0]\,
      R => SR(0)
    );
\pout_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \pout[1]_i_1_n_2\,
      Q => \pout_reg_n_2_[1]\,
      R => SR(0)
    );
\pout_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \pout[2]_i_1_n_2\,
      Q => \pout_reg_n_2_[2]\,
      R => SR(0)
    );
\q_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][0]_srl5_n_2\,
      Q => \^q\(0),
      R => SR(0)
    );
\q_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][1]_srl5_n_2\,
      Q => \^q\(1),
      R => SR(0)
    );
\q_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][2]_srl5_n_2\,
      Q => \^q\(2),
      R => SR(0)
    );
\q_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][3]_srl5_n_2\,
      Q => \^q\(3),
      R => SR(0)
    );
\sect_addr_buf[11]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"4F"
    )
        port map (
      I0 => \sect_addr_buf_reg[2]\(0),
      I1 => \^p_26_in\,
      I2 => ap_rst_n,
      O => ap_rst_n_1(0)
    );
\sect_cnt[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8B"
    )
        port map (
      I0 => Q(0),
      I1 => \^next_wreq\,
      I2 => \sect_cnt_reg[0]\(0),
      O => D(0)
    );
\sect_cnt[10]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => Q(10),
      I1 => \^next_wreq\,
      I2 => sect_cnt0(9),
      O => D(10)
    );
\sect_cnt[11]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => Q(11),
      I1 => \^next_wreq\,
      I2 => sect_cnt0(10),
      O => D(11)
    );
\sect_cnt[12]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => Q(12),
      I1 => \^next_wreq\,
      I2 => sect_cnt0(11),
      O => D(12)
    );
\sect_cnt[13]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => Q(13),
      I1 => \^next_wreq\,
      I2 => sect_cnt0(12),
      O => D(13)
    );
\sect_cnt[14]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => Q(14),
      I1 => \^next_wreq\,
      I2 => sect_cnt0(13),
      O => D(14)
    );
\sect_cnt[15]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => Q(15),
      I1 => \^next_wreq\,
      I2 => sect_cnt0(14),
      O => D(15)
    );
\sect_cnt[16]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => Q(16),
      I1 => \^next_wreq\,
      I2 => sect_cnt0(15),
      O => D(16)
    );
\sect_cnt[17]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => Q(17),
      I1 => \^next_wreq\,
      I2 => sect_cnt0(16),
      O => D(17)
    );
\sect_cnt[18]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => Q(18),
      I1 => \^next_wreq\,
      I2 => sect_cnt0(17),
      O => D(18)
    );
\sect_cnt[19]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => Q(19),
      I1 => \^next_wreq\,
      I2 => sect_cnt0(18),
      O => D(19)
    );
\sect_cnt[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => Q(1),
      I1 => \^next_wreq\,
      I2 => sect_cnt0(0),
      O => D(1)
    );
\sect_cnt[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => Q(2),
      I1 => \^next_wreq\,
      I2 => sect_cnt0(1),
      O => D(2)
    );
\sect_cnt[3]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => Q(3),
      I1 => \^next_wreq\,
      I2 => sect_cnt0(2),
      O => D(3)
    );
\sect_cnt[4]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => Q(4),
      I1 => \^next_wreq\,
      I2 => sect_cnt0(3),
      O => D(4)
    );
\sect_cnt[5]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => Q(5),
      I1 => \^next_wreq\,
      I2 => sect_cnt0(4),
      O => D(5)
    );
\sect_cnt[6]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => Q(6),
      I1 => \^next_wreq\,
      I2 => sect_cnt0(5),
      O => D(6)
    );
\sect_cnt[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => Q(7),
      I1 => \^next_wreq\,
      I2 => sect_cnt0(6),
      O => D(7)
    );
\sect_cnt[8]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => Q(8),
      I1 => \^next_wreq\,
      I2 => sect_cnt0(7),
      O => D(8)
    );
\sect_cnt[9]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => Q(9),
      I1 => \^next_wreq\,
      I2 => sect_cnt0(8),
      O => D(9)
    );
\sect_len_buf[9]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"08AA"
    )
        port map (
      I0 => wreq_handling_reg_0,
      I1 => \^push\,
      I2 => \^could_multi_bursts.loop_cnt_reg[0]\,
      I3 => \could_multi_bursts.sect_handling_reg_0\,
      O => \^p_26_in\
    );
wreq_handling_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"CEEE"
    )
        port map (
      I0 => wreq_handling_reg_0,
      I1 => wreq_handling_reg_1,
      I2 => CO(0),
      I3 => \^p_26_in\,
      O => wreq_handling_reg
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity \design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo__parameterized0\ is
  port (
    fifo_wreq_valid : out STD_LOGIC;
    rs2f_wreq_ack : out STD_LOGIC;
    empty_n_reg_0 : out STD_LOGIC_VECTOR ( 0 to 0 );
    empty_n_reg_1 : out STD_LOGIC;
    empty_n_reg_2 : out STD_LOGIC;
    \q_reg[33]_0\ : out STD_LOGIC_VECTOR ( 30 downto 0 );
    S : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \sect_cnt_reg[19]\ : out STD_LOGIC_VECTOR ( 2 downto 0 );
    \q_reg[33]_1\ : out STD_LOGIC_VECTOR ( 0 to 0 );
    empty_n_reg_3 : out STD_LOGIC_VECTOR ( 0 to 0 );
    \q_reg[33]_2\ : out STD_LOGIC_VECTOR ( 0 to 0 );
    SR : in STD_LOGIC_VECTOR ( 0 to 0 );
    E : in STD_LOGIC_VECTOR ( 0 to 0 );
    ap_clk : in STD_LOGIC;
    p_26_in : in STD_LOGIC;
    CO : in STD_LOGIC_VECTOR ( 0 to 0 );
    \align_len_reg[31]\ : in STD_LOGIC;
    ap_rst_n : in STD_LOGIC;
    Q : in STD_LOGIC_VECTOR ( 0 to 0 );
    full_n_reg_0 : in STD_LOGIC;
    full_n_reg_1 : in STD_LOGIC;
    full_n_reg_2 : in STD_LOGIC_VECTOR ( 0 to 0 );
    \sect_cnt_reg[0]\ : in STD_LOGIC;
    \last_sect_carry__0\ : in STD_LOGIC_VECTOR ( 19 downto 0 );
    \last_sect_carry__0_0\ : in STD_LOGIC_VECTOR ( 19 downto 0 );
    push : in STD_LOGIC;
    \q_reg[29]_0\ : in STD_LOGIC_VECTOR ( 29 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo__parameterized0\ : entity is "simple_accel_core_gmem_m_axi_fifo";
end \design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo__parameterized0\;

architecture STRUCTURE of \design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo__parameterized0\ is
  signal \data_vld_i_1__0_n_2\ : STD_LOGIC;
  signal data_vld_reg_n_2 : STD_LOGIC;
  signal \^fifo_wreq_valid\ : STD_LOGIC;
  signal \full_n_i_1__2_n_2\ : STD_LOGIC;
  signal \full_n_i_2__2_n_2\ : STD_LOGIC;
  signal \mem_reg[4][0]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][10]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][11]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][12]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][13]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][14]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][15]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][16]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][17]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][18]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][19]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][1]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][20]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][21]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][22]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][23]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][24]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][25]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][26]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][27]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][28]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][29]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][2]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][33]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][3]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][4]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][5]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][6]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][7]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][8]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][9]_srl5_n_2\ : STD_LOGIC;
  signal \pout[0]_i_1_n_2\ : STD_LOGIC;
  signal \pout[1]_i_1_n_2\ : STD_LOGIC;
  signal \pout[2]_i_1_n_2\ : STD_LOGIC;
  signal \pout[2]_i_2_n_2\ : STD_LOGIC;
  signal \pout_reg_n_2_[0]\ : STD_LOGIC;
  signal \pout_reg_n_2_[1]\ : STD_LOGIC;
  signal \pout_reg_n_2_[2]\ : STD_LOGIC;
  signal \^q_reg[33]_0\ : STD_LOGIC_VECTOR ( 30 downto 0 );
  signal \^rs2f_wreq_ack\ : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \align_len[31]_i_2\ : label is "soft_lutpair169";
  attribute SOFT_HLUTNM of fifo_wreq_valid_buf_i_2 : label is "soft_lutpair170";
  attribute SOFT_HLUTNM of invalid_len_event_i_1 : label is "soft_lutpair170";
  attribute srl_bus_name : string;
  attribute srl_bus_name of \mem_reg[4][0]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] ";
  attribute srl_name : string;
  attribute srl_name of \mem_reg[4][0]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][0]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][10]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][10]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][10]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][11]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][11]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][11]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][12]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][12]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][12]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][13]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][13]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][13]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][14]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][14]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][14]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][15]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][15]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][15]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][16]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][16]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][16]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][17]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][17]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][17]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][18]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][18]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][18]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][19]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][19]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][19]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][1]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][1]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][1]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][20]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][20]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][20]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][21]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][21]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][21]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][22]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][22]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][22]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][23]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][23]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][23]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][24]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][24]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][24]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][25]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][25]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][25]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][26]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][26]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][26]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][27]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][27]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][27]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][28]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][28]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][28]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][29]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][29]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][29]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][2]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][2]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][2]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][33]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][33]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][33]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][3]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][3]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][3]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][4]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][4]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][4]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][5]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][5]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][5]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][6]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][6]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][6]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][7]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][7]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][7]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][8]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][8]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][8]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][9]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][9]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_wreq/mem_reg[4][9]_srl5 ";
  attribute SOFT_HLUTNM of \sect_cnt[19]_i_1\ : label is "soft_lutpair169";
begin
  fifo_wreq_valid <= \^fifo_wreq_valid\;
  \q_reg[33]_0\(30 downto 0) <= \^q_reg[33]_0\(30 downto 0);
  rs2f_wreq_ack <= \^rs2f_wreq_ack\;
\align_len[31]_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"40004444FFFFFFFF"
    )
        port map (
      I0 => \^q_reg[33]_0\(30),
      I1 => \^fifo_wreq_valid\,
      I2 => p_26_in,
      I3 => CO(0),
      I4 => \align_len_reg[31]\,
      I5 => ap_rst_n,
      O => \q_reg[33]_2\(0)
    );
\align_len[31]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"80AA"
    )
        port map (
      I0 => \^fifo_wreq_valid\,
      I1 => p_26_in,
      I2 => CO(0),
      I3 => \align_len_reg[31]\,
      O => empty_n_reg_0(0)
    );
\data_vld_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFAAAAFFFEAAAA"
    )
        port map (
      I0 => push,
      I1 => \pout_reg_n_2_[0]\,
      I2 => \pout_reg_n_2_[1]\,
      I3 => \pout_reg_n_2_[2]\,
      I4 => data_vld_reg_n_2,
      I5 => \pout[2]_i_2_n_2\,
      O => \data_vld_i_1__0_n_2\
    );
data_vld_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \data_vld_i_1__0_n_2\,
      Q => data_vld_reg_n_2,
      R => SR(0)
    );
empty_n_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => data_vld_reg_n_2,
      Q => \^fifo_wreq_valid\,
      R => SR(0)
    );
fifo_wreq_valid_buf_i_2: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^fifo_wreq_valid\,
      I1 => \sect_cnt_reg[0]\,
      O => empty_n_reg_1
    );
\full_n_i_1__2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"DFFF5F5FFFFF5555"
    )
        port map (
      I0 => ap_rst_n,
      I1 => \full_n_i_2__2_n_2\,
      I2 => \pout[2]_i_2_n_2\,
      I3 => Q(0),
      I4 => \^rs2f_wreq_ack\,
      I5 => data_vld_reg_n_2,
      O => \full_n_i_1__2_n_2\
    );
\full_n_i_2__2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"BF"
    )
        port map (
      I0 => \pout_reg_n_2_[2]\,
      I1 => \pout_reg_n_2_[0]\,
      I2 => \pout_reg_n_2_[1]\,
      O => \full_n_i_2__2_n_2\
    );
full_n_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \full_n_i_1__2_n_2\,
      Q => \^rs2f_wreq_ack\,
      R => '0'
    );
\i__carry_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q_reg[33]_0\(30),
      O => \q_reg[33]_1\(0)
    );
invalid_len_event_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \^fifo_wreq_valid\,
      I1 => \^q_reg[33]_0\(30),
      O => empty_n_reg_2
    );
\last_sect_carry__0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \last_sect_carry__0_0\(19),
      I1 => \last_sect_carry__0\(19),
      I2 => \last_sect_carry__0_0\(18),
      I3 => \last_sect_carry__0\(18),
      O => \sect_cnt_reg[19]\(2)
    );
\last_sect_carry__0_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \last_sect_carry__0\(16),
      I1 => \last_sect_carry__0_0\(16),
      I2 => \last_sect_carry__0\(17),
      I3 => \last_sect_carry__0_0\(17),
      I4 => \last_sect_carry__0_0\(15),
      I5 => \last_sect_carry__0\(15),
      O => \sect_cnt_reg[19]\(1)
    );
\last_sect_carry__0_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \last_sect_carry__0\(14),
      I1 => \last_sect_carry__0_0\(14),
      I2 => \last_sect_carry__0\(12),
      I3 => \last_sect_carry__0_0\(12),
      I4 => \last_sect_carry__0\(13),
      I5 => \last_sect_carry__0_0\(13),
      O => \sect_cnt_reg[19]\(0)
    );
last_sect_carry_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \last_sect_carry__0\(11),
      I1 => \last_sect_carry__0_0\(11),
      I2 => \last_sect_carry__0\(9),
      I3 => \last_sect_carry__0_0\(9),
      I4 => \last_sect_carry__0\(10),
      I5 => \last_sect_carry__0_0\(10),
      O => S(3)
    );
last_sect_carry_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \last_sect_carry__0\(7),
      I1 => \last_sect_carry__0_0\(7),
      I2 => \last_sect_carry__0\(8),
      I3 => \last_sect_carry__0_0\(8),
      I4 => \last_sect_carry__0_0\(6),
      I5 => \last_sect_carry__0\(6),
      O => S(2)
    );
last_sect_carry_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \last_sect_carry__0\(5),
      I1 => \last_sect_carry__0_0\(5),
      I2 => \last_sect_carry__0\(3),
      I3 => \last_sect_carry__0_0\(3),
      I4 => \last_sect_carry__0\(4),
      I5 => \last_sect_carry__0_0\(4),
      O => S(1)
    );
last_sect_carry_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \last_sect_carry__0\(2),
      I1 => \last_sect_carry__0_0\(2),
      I2 => \last_sect_carry__0\(0),
      I3 => \last_sect_carry__0_0\(0),
      I4 => \last_sect_carry__0\(1),
      I5 => \last_sect_carry__0_0\(1),
      O => S(0)
    );
\mem_reg[4][0]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[29]_0\(0),
      Q => \mem_reg[4][0]_srl5_n_2\
    );
\mem_reg[4][10]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[29]_0\(10),
      Q => \mem_reg[4][10]_srl5_n_2\
    );
\mem_reg[4][11]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[29]_0\(11),
      Q => \mem_reg[4][11]_srl5_n_2\
    );
\mem_reg[4][12]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[29]_0\(12),
      Q => \mem_reg[4][12]_srl5_n_2\
    );
\mem_reg[4][13]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[29]_0\(13),
      Q => \mem_reg[4][13]_srl5_n_2\
    );
\mem_reg[4][14]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[29]_0\(14),
      Q => \mem_reg[4][14]_srl5_n_2\
    );
\mem_reg[4][15]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[29]_0\(15),
      Q => \mem_reg[4][15]_srl5_n_2\
    );
\mem_reg[4][16]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[29]_0\(16),
      Q => \mem_reg[4][16]_srl5_n_2\
    );
\mem_reg[4][17]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[29]_0\(17),
      Q => \mem_reg[4][17]_srl5_n_2\
    );
\mem_reg[4][18]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[29]_0\(18),
      Q => \mem_reg[4][18]_srl5_n_2\
    );
\mem_reg[4][19]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[29]_0\(19),
      Q => \mem_reg[4][19]_srl5_n_2\
    );
\mem_reg[4][1]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[29]_0\(1),
      Q => \mem_reg[4][1]_srl5_n_2\
    );
\mem_reg[4][20]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[29]_0\(20),
      Q => \mem_reg[4][20]_srl5_n_2\
    );
\mem_reg[4][21]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[29]_0\(21),
      Q => \mem_reg[4][21]_srl5_n_2\
    );
\mem_reg[4][22]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[29]_0\(22),
      Q => \mem_reg[4][22]_srl5_n_2\
    );
\mem_reg[4][23]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[29]_0\(23),
      Q => \mem_reg[4][23]_srl5_n_2\
    );
\mem_reg[4][24]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[29]_0\(24),
      Q => \mem_reg[4][24]_srl5_n_2\
    );
\mem_reg[4][25]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[29]_0\(25),
      Q => \mem_reg[4][25]_srl5_n_2\
    );
\mem_reg[4][26]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[29]_0\(26),
      Q => \mem_reg[4][26]_srl5_n_2\
    );
\mem_reg[4][27]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[29]_0\(27),
      Q => \mem_reg[4][27]_srl5_n_2\
    );
\mem_reg[4][28]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[29]_0\(28),
      Q => \mem_reg[4][28]_srl5_n_2\
    );
\mem_reg[4][29]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[29]_0\(29),
      Q => \mem_reg[4][29]_srl5_n_2\
    );
\mem_reg[4][2]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[29]_0\(2),
      Q => \mem_reg[4][2]_srl5_n_2\
    );
\mem_reg[4][33]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => '1',
      Q => \mem_reg[4][33]_srl5_n_2\
    );
\mem_reg[4][3]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[29]_0\(3),
      Q => \mem_reg[4][3]_srl5_n_2\
    );
\mem_reg[4][4]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[29]_0\(4),
      Q => \mem_reg[4][4]_srl5_n_2\
    );
\mem_reg[4][5]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[29]_0\(5),
      Q => \mem_reg[4][5]_srl5_n_2\
    );
\mem_reg[4][6]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[29]_0\(6),
      Q => \mem_reg[4][6]_srl5_n_2\
    );
\mem_reg[4][7]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[29]_0\(7),
      Q => \mem_reg[4][7]_srl5_n_2\
    );
\mem_reg[4][8]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[29]_0\(8),
      Q => \mem_reg[4][8]_srl5_n_2\
    );
\mem_reg[4][9]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[29]_0\(9),
      Q => \mem_reg[4][9]_srl5_n_2\
    );
\pout[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6F6F6F6F90909080"
    )
        port map (
      I0 => \pout[2]_i_2_n_2\,
      I1 => push,
      I2 => data_vld_reg_n_2,
      I3 => \pout_reg_n_2_[1]\,
      I4 => \pout_reg_n_2_[2]\,
      I5 => \pout_reg_n_2_[0]\,
      O => \pout[0]_i_1_n_2\
    );
\pout[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"3CCCCCCCCCCCC2CC"
    )
        port map (
      I0 => \pout_reg_n_2_[2]\,
      I1 => \pout_reg_n_2_[1]\,
      I2 => \pout_reg_n_2_[0]\,
      I3 => data_vld_reg_n_2,
      I4 => push,
      I5 => \pout[2]_i_2_n_2\,
      O => \pout[1]_i_1_n_2\
    );
\pout[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6AAAAAAAAAAAA8AA"
    )
        port map (
      I0 => \pout_reg_n_2_[2]\,
      I1 => \pout_reg_n_2_[1]\,
      I2 => \pout_reg_n_2_[0]\,
      I3 => data_vld_reg_n_2,
      I4 => push,
      I5 => \pout[2]_i_2_n_2\,
      O => \pout[2]_i_1_n_2\
    );
\pout[2]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8808080888088808"
    )
        port map (
      I0 => \^fifo_wreq_valid\,
      I1 => \align_len_reg[31]\,
      I2 => CO(0),
      I3 => full_n_reg_0,
      I4 => full_n_reg_1,
      I5 => full_n_reg_2(0),
      O => \pout[2]_i_2_n_2\
    );
\pout_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \pout[0]_i_1_n_2\,
      Q => \pout_reg_n_2_[0]\,
      R => SR(0)
    );
\pout_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \pout[1]_i_1_n_2\,
      Q => \pout_reg_n_2_[1]\,
      R => SR(0)
    );
\pout_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \pout[2]_i_1_n_2\,
      Q => \pout_reg_n_2_[2]\,
      R => SR(0)
    );
\q_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => \mem_reg[4][0]_srl5_n_2\,
      Q => \^q_reg[33]_0\(0),
      R => SR(0)
    );
\q_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => \mem_reg[4][10]_srl5_n_2\,
      Q => \^q_reg[33]_0\(10),
      R => SR(0)
    );
\q_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => \mem_reg[4][11]_srl5_n_2\,
      Q => \^q_reg[33]_0\(11),
      R => SR(0)
    );
\q_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => \mem_reg[4][12]_srl5_n_2\,
      Q => \^q_reg[33]_0\(12),
      R => SR(0)
    );
\q_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => \mem_reg[4][13]_srl5_n_2\,
      Q => \^q_reg[33]_0\(13),
      R => SR(0)
    );
\q_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => \mem_reg[4][14]_srl5_n_2\,
      Q => \^q_reg[33]_0\(14),
      R => SR(0)
    );
\q_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => \mem_reg[4][15]_srl5_n_2\,
      Q => \^q_reg[33]_0\(15),
      R => SR(0)
    );
\q_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => \mem_reg[4][16]_srl5_n_2\,
      Q => \^q_reg[33]_0\(16),
      R => SR(0)
    );
\q_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => \mem_reg[4][17]_srl5_n_2\,
      Q => \^q_reg[33]_0\(17),
      R => SR(0)
    );
\q_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => \mem_reg[4][18]_srl5_n_2\,
      Q => \^q_reg[33]_0\(18),
      R => SR(0)
    );
\q_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => \mem_reg[4][19]_srl5_n_2\,
      Q => \^q_reg[33]_0\(19),
      R => SR(0)
    );
\q_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => \mem_reg[4][1]_srl5_n_2\,
      Q => \^q_reg[33]_0\(1),
      R => SR(0)
    );
\q_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => \mem_reg[4][20]_srl5_n_2\,
      Q => \^q_reg[33]_0\(20),
      R => SR(0)
    );
\q_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => \mem_reg[4][21]_srl5_n_2\,
      Q => \^q_reg[33]_0\(21),
      R => SR(0)
    );
\q_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => \mem_reg[4][22]_srl5_n_2\,
      Q => \^q_reg[33]_0\(22),
      R => SR(0)
    );
\q_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => \mem_reg[4][23]_srl5_n_2\,
      Q => \^q_reg[33]_0\(23),
      R => SR(0)
    );
\q_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => \mem_reg[4][24]_srl5_n_2\,
      Q => \^q_reg[33]_0\(24),
      R => SR(0)
    );
\q_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => \mem_reg[4][25]_srl5_n_2\,
      Q => \^q_reg[33]_0\(25),
      R => SR(0)
    );
\q_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => \mem_reg[4][26]_srl5_n_2\,
      Q => \^q_reg[33]_0\(26),
      R => SR(0)
    );
\q_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => \mem_reg[4][27]_srl5_n_2\,
      Q => \^q_reg[33]_0\(27),
      R => SR(0)
    );
\q_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => \mem_reg[4][28]_srl5_n_2\,
      Q => \^q_reg[33]_0\(28),
      R => SR(0)
    );
\q_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => \mem_reg[4][29]_srl5_n_2\,
      Q => \^q_reg[33]_0\(29),
      R => SR(0)
    );
\q_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => \mem_reg[4][2]_srl5_n_2\,
      Q => \^q_reg[33]_0\(2),
      R => SR(0)
    );
\q_reg[33]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => \mem_reg[4][33]_srl5_n_2\,
      Q => \^q_reg[33]_0\(30),
      R => SR(0)
    );
\q_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => \mem_reg[4][3]_srl5_n_2\,
      Q => \^q_reg[33]_0\(3),
      R => SR(0)
    );
\q_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => \mem_reg[4][4]_srl5_n_2\,
      Q => \^q_reg[33]_0\(4),
      R => SR(0)
    );
\q_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => \mem_reg[4][5]_srl5_n_2\,
      Q => \^q_reg[33]_0\(5),
      R => SR(0)
    );
\q_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => \mem_reg[4][6]_srl5_n_2\,
      Q => \^q_reg[33]_0\(6),
      R => SR(0)
    );
\q_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => \mem_reg[4][7]_srl5_n_2\,
      Q => \^q_reg[33]_0\(7),
      R => SR(0)
    );
\q_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => \mem_reg[4][8]_srl5_n_2\,
      Q => \^q_reg[33]_0\(8),
      R => SR(0)
    );
\q_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => \mem_reg[4][9]_srl5_n_2\,
      Q => \^q_reg[33]_0\(9),
      R => SR(0)
    );
\sect_cnt[19]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F0FE"
    )
        port map (
      I0 => \^fifo_wreq_valid\,
      I1 => \sect_cnt_reg[0]\,
      I2 => p_26_in,
      I3 => \align_len_reg[31]\,
      O => empty_n_reg_3(0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity \design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo__parameterized0_1\ is
  port (
    fifo_rreq_valid : out STD_LOGIC;
    rs2f_rreq_ack : out STD_LOGIC;
    D : out STD_LOGIC_VECTOR ( 19 downto 0 );
    E : out STD_LOGIC_VECTOR ( 0 to 0 );
    \could_multi_bursts.loop_cnt_reg[3]\ : out STD_LOGIC;
    \could_multi_bursts.loop_cnt_reg[0]\ : out STD_LOGIC;
    S : out STD_LOGIC_VECTOR ( 2 downto 0 );
    \q_reg[60]_0\ : out STD_LOGIC_VECTOR ( 58 downto 0 );
    \q_reg[58]_0\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \q_reg[54]_0\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \q_reg[50]_0\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \q_reg[46]_0\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \q_reg[42]_0\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \q_reg[38]_0\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \q_reg[34]_0\ : out STD_LOGIC_VECTOR ( 2 downto 0 );
    \end_addr_buf_reg[23]\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \sect_cnt_reg[19]\ : out STD_LOGIC_VECTOR ( 2 downto 0 );
    invalid_len_event0 : out STD_LOGIC;
    SR : in STD_LOGIC_VECTOR ( 0 to 0 );
    ap_clk : in STD_LOGIC;
    ap_rst_n : in STD_LOGIC;
    full_n_reg_0 : in STD_LOGIC;
    CO : in STD_LOGIC_VECTOR ( 0 to 0 );
    full_n_reg_1 : in STD_LOGIC;
    push : in STD_LOGIC;
    Q : in STD_LOGIC_VECTOR ( 19 downto 0 );
    \sect_cnt_reg[0]\ : in STD_LOGIC;
    \sect_cnt_reg[0]_0\ : in STD_LOGIC;
    \sect_cnt_reg[19]_0\ : in STD_LOGIC_VECTOR ( 19 downto 0 );
    O : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \sect_cnt_reg[8]\ : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \sect_cnt_reg[12]\ : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \sect_cnt_reg[16]\ : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \sect_cnt_reg[19]_1\ : in STD_LOGIC_VECTOR ( 2 downto 0 );
    \could_multi_bursts.arlen_buf[3]_i_3\ : in STD_LOGIC_VECTOR ( 5 downto 0 );
    \could_multi_bursts.arlen_buf[3]_i_3_0\ : in STD_LOGIC_VECTOR ( 5 downto 0 );
    \last_sect_carry__0\ : in STD_LOGIC_VECTOR ( 19 downto 0 );
    \q_reg[63]_0\ : in STD_LOGIC_VECTOR ( 61 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo__parameterized0_1\ : entity is "simple_accel_core_gmem_m_axi_fifo";
end \design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo__parameterized0_1\;

architecture STRUCTURE of \design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo__parameterized0_1\ is
  signal \data_vld_i_1__3_n_2\ : STD_LOGIC;
  signal data_vld_reg_n_2 : STD_LOGIC;
  signal fifo_rreq_data : STD_LOGIC_VECTOR ( 63 downto 61 );
  signal \^fifo_rreq_valid\ : STD_LOGIC;
  signal \full_n_i_1__5_n_2\ : STD_LOGIC;
  signal \full_n_i_2__0_n_2\ : STD_LOGIC;
  signal \full_n_i_3__1_n_2\ : STD_LOGIC;
  signal \full_n_i_4__0_n_2\ : STD_LOGIC;
  signal invalid_len_event_i_2_n_2 : STD_LOGIC;
  signal invalid_len_event_i_3_n_2 : STD_LOGIC;
  signal invalid_len_event_i_4_n_2 : STD_LOGIC;
  signal invalid_len_event_i_5_n_2 : STD_LOGIC;
  signal invalid_len_event_i_6_n_2 : STD_LOGIC;
  signal invalid_len_event_i_7_n_2 : STD_LOGIC;
  signal invalid_len_event_i_8_n_2 : STD_LOGIC;
  signal invalid_len_event_i_9_n_2 : STD_LOGIC;
  signal \mem_reg[4][0]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][10]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][11]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][12]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][13]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][14]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][15]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][16]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][17]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][18]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][19]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][1]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][20]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][21]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][22]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][23]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][24]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][25]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][26]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][27]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][28]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][29]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][2]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][32]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][33]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][34]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][35]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][36]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][37]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][38]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][39]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][3]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][40]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][41]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][42]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][43]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][44]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][45]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][46]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][47]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][48]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][49]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][4]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][50]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][51]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][52]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][53]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][54]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][55]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][56]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][57]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][58]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][59]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][5]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][60]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][61]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][62]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][63]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][6]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][7]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][8]_srl5_n_2\ : STD_LOGIC;
  signal \mem_reg[4][9]_srl5_n_2\ : STD_LOGIC;
  signal pop0 : STD_LOGIC;
  signal \pout[0]_i_1_n_2\ : STD_LOGIC;
  signal \pout[1]_i_1_n_2\ : STD_LOGIC;
  signal \pout[2]_i_1_n_2\ : STD_LOGIC;
  signal \pout[2]_i_2__1_n_2\ : STD_LOGIC;
  signal \pout_reg_n_2_[0]\ : STD_LOGIC;
  signal \pout_reg_n_2_[1]\ : STD_LOGIC;
  signal \pout_reg_n_2_[2]\ : STD_LOGIC;
  signal \^q_reg[60]_0\ : STD_LOGIC_VECTOR ( 58 downto 0 );
  signal \^rs2f_rreq_ack\ : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \align_len[31]_i_1\ : label is "soft_lutpair80";
  attribute SOFT_HLUTNM of \full_n_i_2__0\ : label is "soft_lutpair81";
  attribute srl_bus_name : string;
  attribute srl_bus_name of \mem_reg[4][0]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name : string;
  attribute srl_name of \mem_reg[4][0]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][0]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][10]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][10]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][10]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][11]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][11]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][11]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][12]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][12]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][12]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][13]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][13]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][13]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][14]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][14]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][14]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][15]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][15]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][15]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][16]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][16]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][16]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][17]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][17]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][17]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][18]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][18]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][18]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][19]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][19]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][19]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][1]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][1]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][1]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][20]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][20]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][20]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][21]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][21]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][21]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][22]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][22]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][22]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][23]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][23]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][23]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][24]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][24]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][24]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][25]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][25]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][25]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][26]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][26]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][26]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][27]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][27]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][27]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][28]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][28]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][28]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][29]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][29]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][29]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][2]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][2]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][2]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][32]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][32]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][32]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][33]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][33]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][33]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][34]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][34]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][34]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][35]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][35]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][35]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][36]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][36]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][36]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][37]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][37]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][37]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][38]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][38]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][38]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][39]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][39]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][39]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][3]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][3]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][3]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][40]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][40]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][40]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][41]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][41]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][41]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][42]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][42]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][42]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][43]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][43]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][43]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][44]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][44]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][44]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][45]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][45]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][45]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][46]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][46]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][46]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][47]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][47]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][47]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][48]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][48]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][48]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][49]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][49]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][49]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][4]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][4]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][4]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][50]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][50]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][50]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][51]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][51]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][51]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][52]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][52]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][52]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][53]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][53]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][53]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][54]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][54]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][54]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][55]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][55]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][55]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][56]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][56]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][56]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][57]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][57]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][57]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][58]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][58]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][58]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][59]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][59]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][59]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][5]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][5]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][5]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][60]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][60]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][60]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][61]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][61]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][61]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][62]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][62]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][62]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][63]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][63]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][63]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][6]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][6]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][6]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][7]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][7]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][7]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][8]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][8]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][8]_srl5 ";
  attribute srl_bus_name of \mem_reg[4][9]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4] ";
  attribute srl_name of \mem_reg[4][9]_srl5\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_read/fifo_rreq/mem_reg[4][9]_srl5 ";
  attribute SOFT_HLUTNM of \pout[2]_i_2__1\ : label is "soft_lutpair81";
  attribute SOFT_HLUTNM of \sect_cnt[4]_i_1__0\ : label is "soft_lutpair80";
begin
  fifo_rreq_valid <= \^fifo_rreq_valid\;
  \q_reg[60]_0\(58 downto 0) <= \^q_reg[60]_0\(58 downto 0);
  rs2f_rreq_ack <= \^rs2f_rreq_ack\;
\align_len0_carry__0_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q_reg[60]_0\(36),
      O => \q_reg[38]_0\(3)
    );
\align_len0_carry__0_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q_reg[60]_0\(35),
      O => \q_reg[38]_0\(2)
    );
\align_len0_carry__0_i_3\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q_reg[60]_0\(34),
      O => \q_reg[38]_0\(1)
    );
\align_len0_carry__0_i_4\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q_reg[60]_0\(33),
      O => \q_reg[38]_0\(0)
    );
\align_len0_carry__1_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q_reg[60]_0\(40),
      O => \q_reg[42]_0\(3)
    );
\align_len0_carry__1_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q_reg[60]_0\(39),
      O => \q_reg[42]_0\(2)
    );
\align_len0_carry__1_i_3\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q_reg[60]_0\(38),
      O => \q_reg[42]_0\(1)
    );
\align_len0_carry__1_i_4\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q_reg[60]_0\(37),
      O => \q_reg[42]_0\(0)
    );
\align_len0_carry__2_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q_reg[60]_0\(44),
      O => \q_reg[46]_0\(3)
    );
\align_len0_carry__2_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q_reg[60]_0\(43),
      O => \q_reg[46]_0\(2)
    );
\align_len0_carry__2_i_3\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q_reg[60]_0\(42),
      O => \q_reg[46]_0\(1)
    );
\align_len0_carry__2_i_4\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q_reg[60]_0\(41),
      O => \q_reg[46]_0\(0)
    );
\align_len0_carry__3_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q_reg[60]_0\(48),
      O => \q_reg[50]_0\(3)
    );
\align_len0_carry__3_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q_reg[60]_0\(47),
      O => \q_reg[50]_0\(2)
    );
\align_len0_carry__3_i_3\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q_reg[60]_0\(46),
      O => \q_reg[50]_0\(1)
    );
\align_len0_carry__3_i_4\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q_reg[60]_0\(45),
      O => \q_reg[50]_0\(0)
    );
\align_len0_carry__4_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q_reg[60]_0\(52),
      O => \q_reg[54]_0\(3)
    );
\align_len0_carry__4_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q_reg[60]_0\(51),
      O => \q_reg[54]_0\(2)
    );
\align_len0_carry__4_i_3\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q_reg[60]_0\(50),
      O => \q_reg[54]_0\(1)
    );
\align_len0_carry__4_i_4\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q_reg[60]_0\(49),
      O => \q_reg[54]_0\(0)
    );
\align_len0_carry__5_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q_reg[60]_0\(56),
      O => \q_reg[58]_0\(3)
    );
\align_len0_carry__5_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q_reg[60]_0\(55),
      O => \q_reg[58]_0\(2)
    );
\align_len0_carry__5_i_3\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q_reg[60]_0\(54),
      O => \q_reg[58]_0\(1)
    );
\align_len0_carry__5_i_4\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q_reg[60]_0\(53),
      O => \q_reg[58]_0\(0)
    );
\align_len0_carry__6_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => fifo_rreq_data(61),
      O => S(2)
    );
\align_len0_carry__6_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q_reg[60]_0\(58),
      O => S(1)
    );
\align_len0_carry__6_i_3\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q_reg[60]_0\(57),
      O => S(0)
    );
align_len0_carry_i_1: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q_reg[60]_0\(32),
      O => \q_reg[34]_0\(2)
    );
align_len0_carry_i_2: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q_reg[60]_0\(31),
      O => \q_reg[34]_0\(1)
    );
align_len0_carry_i_3: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q_reg[60]_0\(30),
      O => \q_reg[34]_0\(0)
    );
\align_len[31]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \^fifo_rreq_valid\,
      I1 => \sect_cnt_reg[0]_0\,
      O => E(0)
    );
\could_multi_bursts.arlen_buf[3]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6FF6FFFFFFFF6FF6"
    )
        port map (
      I0 => \could_multi_bursts.arlen_buf[3]_i_3\(0),
      I1 => \could_multi_bursts.arlen_buf[3]_i_3_0\(0),
      I2 => \could_multi_bursts.arlen_buf[3]_i_3_0\(1),
      I3 => \could_multi_bursts.arlen_buf[3]_i_3\(1),
      I4 => \could_multi_bursts.arlen_buf[3]_i_3_0\(2),
      I5 => \could_multi_bursts.arlen_buf[3]_i_3\(2),
      O => \could_multi_bursts.loop_cnt_reg[0]\
    );
\could_multi_bursts.arlen_buf[3]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6FF6FFFFFFFF6FF6"
    )
        port map (
      I0 => \could_multi_bursts.arlen_buf[3]_i_3\(3),
      I1 => \could_multi_bursts.arlen_buf[3]_i_3_0\(3),
      I2 => \could_multi_bursts.arlen_buf[3]_i_3_0\(5),
      I3 => \could_multi_bursts.arlen_buf[3]_i_3\(5),
      I4 => \could_multi_bursts.arlen_buf[3]_i_3_0\(4),
      I5 => \could_multi_bursts.arlen_buf[3]_i_3\(4),
      O => \could_multi_bursts.loop_cnt_reg[3]\
    );
\data_vld_i_1__3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFEFFFFAAAAAAAA"
    )
        port map (
      I0 => push,
      I1 => \pout_reg_n_2_[2]\,
      I2 => \pout_reg_n_2_[0]\,
      I3 => \pout_reg_n_2_[1]\,
      I4 => \full_n_i_2__0_n_2\,
      I5 => data_vld_reg_n_2,
      O => \data_vld_i_1__3_n_2\
    );
data_vld_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \data_vld_i_1__3_n_2\,
      Q => data_vld_reg_n_2,
      R => SR(0)
    );
\empty_n_i_1__1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \pout[2]_i_2__1_n_2\,
      O => pop0
    );
empty_n_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => data_vld_reg_n_2,
      Q => \^fifo_rreq_valid\,
      R => SR(0)
    );
\full_n_i_1__5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FBFBFBFBFBFBFBBB"
    )
        port map (
      I0 => \full_n_i_2__0_n_2\,
      I1 => ap_rst_n,
      I2 => \^rs2f_rreq_ack\,
      I3 => \full_n_i_3__1_n_2\,
      I4 => \pout_reg_n_2_[2]\,
      I5 => \full_n_i_4__0_n_2\,
      O => \full_n_i_1__5_n_2\
    );
\full_n_i_2__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"20AAAAAA"
    )
        port map (
      I0 => data_vld_reg_n_2,
      I1 => full_n_reg_0,
      I2 => CO(0),
      I3 => full_n_reg_1,
      I4 => \^fifo_rreq_valid\,
      O => \full_n_i_2__0_n_2\
    );
\full_n_i_3__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4FFFFFFFFFFFFFFF"
    )
        port map (
      I0 => full_n_reg_0,
      I1 => CO(0),
      I2 => full_n_reg_1,
      I3 => \^fifo_rreq_valid\,
      I4 => push,
      I5 => data_vld_reg_n_2,
      O => \full_n_i_3__1_n_2\
    );
\full_n_i_4__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"7"
    )
        port map (
      I0 => \pout_reg_n_2_[1]\,
      I1 => \pout_reg_n_2_[0]\,
      O => \full_n_i_4__0_n_2\
    );
full_n_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \full_n_i_1__5_n_2\,
      Q => \^rs2f_rreq_ack\,
      R => '0'
    );
\invalid_len_event_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"888A8888"
    )
        port map (
      I0 => \^fifo_rreq_valid\,
      I1 => fifo_rreq_data(63),
      I2 => invalid_len_event_i_2_n_2,
      I3 => invalid_len_event_i_3_n_2,
      I4 => invalid_len_event_i_4_n_2,
      O => invalid_len_event0
    );
invalid_len_event_i_2: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => \^q_reg[60]_0\(40),
      I1 => \^q_reg[60]_0\(35),
      I2 => fifo_rreq_data(61),
      I3 => \^q_reg[60]_0\(46),
      I4 => invalid_len_event_i_5_n_2,
      O => invalid_len_event_i_2_n_2
    );
invalid_len_event_i_3: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => \^q_reg[60]_0\(37),
      I1 => \^q_reg[60]_0\(31),
      I2 => \^q_reg[60]_0\(54),
      I3 => \^q_reg[60]_0\(48),
      I4 => invalid_len_event_i_6_n_2,
      O => invalid_len_event_i_3_n_2
    );
invalid_len_event_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000004"
    )
        port map (
      I0 => invalid_len_event_i_7_n_2,
      I1 => invalid_len_event_i_8_n_2,
      I2 => invalid_len_event_i_9_n_2,
      I3 => \^q_reg[60]_0\(50),
      I4 => \^q_reg[60]_0\(34),
      I5 => \^q_reg[60]_0\(52),
      O => invalid_len_event_i_4_n_2
    );
invalid_len_event_i_5: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \^q_reg[60]_0\(33),
      I1 => \^q_reg[60]_0\(55),
      I2 => \^q_reg[60]_0\(44),
      I3 => \^q_reg[60]_0\(57),
      O => invalid_len_event_i_5_n_2
    );
invalid_len_event_i_6: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \^q_reg[60]_0\(53),
      I1 => \^q_reg[60]_0\(58),
      I2 => fifo_rreq_data(62),
      I3 => \^q_reg[60]_0\(36),
      O => invalid_len_event_i_6_n_2
    );
invalid_len_event_i_7: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \^q_reg[60]_0\(45),
      I1 => \^q_reg[60]_0\(49),
      I2 => \^q_reg[60]_0\(38),
      I3 => \^q_reg[60]_0\(51),
      O => invalid_len_event_i_7_n_2
    );
invalid_len_event_i_8: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0001"
    )
        port map (
      I0 => \^q_reg[60]_0\(41),
      I1 => \^q_reg[60]_0\(42),
      I2 => \^q_reg[60]_0\(39),
      I3 => \^q_reg[60]_0\(47),
      O => invalid_len_event_i_8_n_2
    );
invalid_len_event_i_9: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \^q_reg[60]_0\(30),
      I1 => \^q_reg[60]_0\(43),
      I2 => \^q_reg[60]_0\(32),
      I3 => \^q_reg[60]_0\(56),
      O => invalid_len_event_i_9_n_2
    );
\last_sect_carry__0_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => Q(19),
      I1 => \last_sect_carry__0\(19),
      I2 => Q(18),
      I3 => \last_sect_carry__0\(18),
      O => \sect_cnt_reg[19]\(2)
    );
\last_sect_carry__0_i_2__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \last_sect_carry__0\(17),
      I1 => Q(17),
      I2 => \last_sect_carry__0\(15),
      I3 => Q(15),
      I4 => \last_sect_carry__0\(16),
      I5 => Q(16),
      O => \sect_cnt_reg[19]\(1)
    );
\last_sect_carry__0_i_3__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \last_sect_carry__0\(14),
      I1 => Q(14),
      I2 => \last_sect_carry__0\(13),
      I3 => Q(13),
      I4 => \last_sect_carry__0\(12),
      I5 => Q(12),
      O => \sect_cnt_reg[19]\(0)
    );
\last_sect_carry_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \last_sect_carry__0\(11),
      I1 => Q(11),
      I2 => \last_sect_carry__0\(10),
      I3 => Q(10),
      I4 => \last_sect_carry__0\(9),
      I5 => Q(9),
      O => \end_addr_buf_reg[23]\(3)
    );
\last_sect_carry_i_2__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \last_sect_carry__0\(7),
      I1 => Q(7),
      I2 => \last_sect_carry__0\(8),
      I3 => Q(8),
      I4 => Q(6),
      I5 => \last_sect_carry__0\(6),
      O => \end_addr_buf_reg[23]\(2)
    );
\last_sect_carry_i_3__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \last_sect_carry__0\(3),
      I1 => Q(3),
      I2 => \last_sect_carry__0\(4),
      I3 => Q(4),
      I4 => Q(5),
      I5 => \last_sect_carry__0\(5),
      O => \end_addr_buf_reg[23]\(1)
    );
\last_sect_carry_i_4__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \last_sect_carry__0\(0),
      I1 => Q(0),
      I2 => \last_sect_carry__0\(1),
      I3 => Q(1),
      I4 => Q(2),
      I5 => \last_sect_carry__0\(2),
      O => \end_addr_buf_reg[23]\(0)
    );
\mem_reg[4][0]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(0),
      Q => \mem_reg[4][0]_srl5_n_2\
    );
\mem_reg[4][10]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(10),
      Q => \mem_reg[4][10]_srl5_n_2\
    );
\mem_reg[4][11]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(11),
      Q => \mem_reg[4][11]_srl5_n_2\
    );
\mem_reg[4][12]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(12),
      Q => \mem_reg[4][12]_srl5_n_2\
    );
\mem_reg[4][13]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(13),
      Q => \mem_reg[4][13]_srl5_n_2\
    );
\mem_reg[4][14]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(14),
      Q => \mem_reg[4][14]_srl5_n_2\
    );
\mem_reg[4][15]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(15),
      Q => \mem_reg[4][15]_srl5_n_2\
    );
\mem_reg[4][16]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(16),
      Q => \mem_reg[4][16]_srl5_n_2\
    );
\mem_reg[4][17]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(17),
      Q => \mem_reg[4][17]_srl5_n_2\
    );
\mem_reg[4][18]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(18),
      Q => \mem_reg[4][18]_srl5_n_2\
    );
\mem_reg[4][19]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(19),
      Q => \mem_reg[4][19]_srl5_n_2\
    );
\mem_reg[4][1]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(1),
      Q => \mem_reg[4][1]_srl5_n_2\
    );
\mem_reg[4][20]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(20),
      Q => \mem_reg[4][20]_srl5_n_2\
    );
\mem_reg[4][21]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(21),
      Q => \mem_reg[4][21]_srl5_n_2\
    );
\mem_reg[4][22]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(22),
      Q => \mem_reg[4][22]_srl5_n_2\
    );
\mem_reg[4][23]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(23),
      Q => \mem_reg[4][23]_srl5_n_2\
    );
\mem_reg[4][24]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(24),
      Q => \mem_reg[4][24]_srl5_n_2\
    );
\mem_reg[4][25]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(25),
      Q => \mem_reg[4][25]_srl5_n_2\
    );
\mem_reg[4][26]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(26),
      Q => \mem_reg[4][26]_srl5_n_2\
    );
\mem_reg[4][27]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(27),
      Q => \mem_reg[4][27]_srl5_n_2\
    );
\mem_reg[4][28]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(28),
      Q => \mem_reg[4][28]_srl5_n_2\
    );
\mem_reg[4][29]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(29),
      Q => \mem_reg[4][29]_srl5_n_2\
    );
\mem_reg[4][2]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(2),
      Q => \mem_reg[4][2]_srl5_n_2\
    );
\mem_reg[4][32]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(30),
      Q => \mem_reg[4][32]_srl5_n_2\
    );
\mem_reg[4][33]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(31),
      Q => \mem_reg[4][33]_srl5_n_2\
    );
\mem_reg[4][34]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(32),
      Q => \mem_reg[4][34]_srl5_n_2\
    );
\mem_reg[4][35]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(33),
      Q => \mem_reg[4][35]_srl5_n_2\
    );
\mem_reg[4][36]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(34),
      Q => \mem_reg[4][36]_srl5_n_2\
    );
\mem_reg[4][37]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(35),
      Q => \mem_reg[4][37]_srl5_n_2\
    );
\mem_reg[4][38]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(36),
      Q => \mem_reg[4][38]_srl5_n_2\
    );
\mem_reg[4][39]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(37),
      Q => \mem_reg[4][39]_srl5_n_2\
    );
\mem_reg[4][3]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(3),
      Q => \mem_reg[4][3]_srl5_n_2\
    );
\mem_reg[4][40]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(38),
      Q => \mem_reg[4][40]_srl5_n_2\
    );
\mem_reg[4][41]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(39),
      Q => \mem_reg[4][41]_srl5_n_2\
    );
\mem_reg[4][42]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(40),
      Q => \mem_reg[4][42]_srl5_n_2\
    );
\mem_reg[4][43]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(41),
      Q => \mem_reg[4][43]_srl5_n_2\
    );
\mem_reg[4][44]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(42),
      Q => \mem_reg[4][44]_srl5_n_2\
    );
\mem_reg[4][45]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(43),
      Q => \mem_reg[4][45]_srl5_n_2\
    );
\mem_reg[4][46]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(44),
      Q => \mem_reg[4][46]_srl5_n_2\
    );
\mem_reg[4][47]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(45),
      Q => \mem_reg[4][47]_srl5_n_2\
    );
\mem_reg[4][48]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(46),
      Q => \mem_reg[4][48]_srl5_n_2\
    );
\mem_reg[4][49]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(47),
      Q => \mem_reg[4][49]_srl5_n_2\
    );
\mem_reg[4][4]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(4),
      Q => \mem_reg[4][4]_srl5_n_2\
    );
\mem_reg[4][50]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(48),
      Q => \mem_reg[4][50]_srl5_n_2\
    );
\mem_reg[4][51]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(49),
      Q => \mem_reg[4][51]_srl5_n_2\
    );
\mem_reg[4][52]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(50),
      Q => \mem_reg[4][52]_srl5_n_2\
    );
\mem_reg[4][53]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(51),
      Q => \mem_reg[4][53]_srl5_n_2\
    );
\mem_reg[4][54]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(52),
      Q => \mem_reg[4][54]_srl5_n_2\
    );
\mem_reg[4][55]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(53),
      Q => \mem_reg[4][55]_srl5_n_2\
    );
\mem_reg[4][56]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(54),
      Q => \mem_reg[4][56]_srl5_n_2\
    );
\mem_reg[4][57]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(55),
      Q => \mem_reg[4][57]_srl5_n_2\
    );
\mem_reg[4][58]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(56),
      Q => \mem_reg[4][58]_srl5_n_2\
    );
\mem_reg[4][59]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(57),
      Q => \mem_reg[4][59]_srl5_n_2\
    );
\mem_reg[4][5]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(5),
      Q => \mem_reg[4][5]_srl5_n_2\
    );
\mem_reg[4][60]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(58),
      Q => \mem_reg[4][60]_srl5_n_2\
    );
\mem_reg[4][61]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(59),
      Q => \mem_reg[4][61]_srl5_n_2\
    );
\mem_reg[4][62]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(60),
      Q => \mem_reg[4][62]_srl5_n_2\
    );
\mem_reg[4][63]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(61),
      Q => \mem_reg[4][63]_srl5_n_2\
    );
\mem_reg[4][6]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(6),
      Q => \mem_reg[4][6]_srl5_n_2\
    );
\mem_reg[4][7]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(7),
      Q => \mem_reg[4][7]_srl5_n_2\
    );
\mem_reg[4][8]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(8),
      Q => \mem_reg[4][8]_srl5_n_2\
    );
\mem_reg[4][9]_srl5\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg_n_2_[0]\,
      A1 => \pout_reg_n_2_[1]\,
      A2 => \pout_reg_n_2_[2]\,
      A3 => '0',
      CE => push,
      CLK => ap_clk,
      D => \q_reg[63]_0\(9),
      Q => \mem_reg[4][9]_srl5_n_2\
    );
\pout[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0FF0FFFFF00E0000"
    )
        port map (
      I0 => \pout_reg_n_2_[2]\,
      I1 => \pout_reg_n_2_[1]\,
      I2 => push,
      I3 => \pout[2]_i_2__1_n_2\,
      I4 => data_vld_reg_n_2,
      I5 => \pout_reg_n_2_[0]\,
      O => \pout[0]_i_1_n_2\
    );
\pout[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7F80FD027F80FD00"
    )
        port map (
      I0 => data_vld_reg_n_2,
      I1 => \pout[2]_i_2__1_n_2\,
      I2 => push,
      I3 => \pout_reg_n_2_[1]\,
      I4 => \pout_reg_n_2_[0]\,
      I5 => \pout_reg_n_2_[2]\,
      O => \pout[1]_i_1_n_2\
    );
\pout[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7FFFFFFD80000000"
    )
        port map (
      I0 => data_vld_reg_n_2,
      I1 => \pout[2]_i_2__1_n_2\,
      I2 => push,
      I3 => \pout_reg_n_2_[1]\,
      I4 => \pout_reg_n_2_[0]\,
      I5 => \pout_reg_n_2_[2]\,
      O => \pout[2]_i_1_n_2\
    );
\pout[2]_i_2__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8808"
    )
        port map (
      I0 => \^fifo_rreq_valid\,
      I1 => full_n_reg_1,
      I2 => CO(0),
      I3 => full_n_reg_0,
      O => \pout[2]_i_2__1_n_2\
    );
\pout_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \pout[0]_i_1_n_2\,
      Q => \pout_reg_n_2_[0]\,
      R => SR(0)
    );
\pout_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \pout[1]_i_1_n_2\,
      Q => \pout_reg_n_2_[1]\,
      R => SR(0)
    );
\pout_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \pout[2]_i_1_n_2\,
      Q => \pout_reg_n_2_[2]\,
      R => SR(0)
    );
\q_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][0]_srl5_n_2\,
      Q => \^q_reg[60]_0\(0),
      R => SR(0)
    );
\q_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][10]_srl5_n_2\,
      Q => \^q_reg[60]_0\(10),
      R => SR(0)
    );
\q_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][11]_srl5_n_2\,
      Q => \^q_reg[60]_0\(11),
      R => SR(0)
    );
\q_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][12]_srl5_n_2\,
      Q => \^q_reg[60]_0\(12),
      R => SR(0)
    );
\q_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][13]_srl5_n_2\,
      Q => \^q_reg[60]_0\(13),
      R => SR(0)
    );
\q_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][14]_srl5_n_2\,
      Q => \^q_reg[60]_0\(14),
      R => SR(0)
    );
\q_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][15]_srl5_n_2\,
      Q => \^q_reg[60]_0\(15),
      R => SR(0)
    );
\q_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][16]_srl5_n_2\,
      Q => \^q_reg[60]_0\(16),
      R => SR(0)
    );
\q_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][17]_srl5_n_2\,
      Q => \^q_reg[60]_0\(17),
      R => SR(0)
    );
\q_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][18]_srl5_n_2\,
      Q => \^q_reg[60]_0\(18),
      R => SR(0)
    );
\q_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][19]_srl5_n_2\,
      Q => \^q_reg[60]_0\(19),
      R => SR(0)
    );
\q_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][1]_srl5_n_2\,
      Q => \^q_reg[60]_0\(1),
      R => SR(0)
    );
\q_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][20]_srl5_n_2\,
      Q => \^q_reg[60]_0\(20),
      R => SR(0)
    );
\q_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][21]_srl5_n_2\,
      Q => \^q_reg[60]_0\(21),
      R => SR(0)
    );
\q_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][22]_srl5_n_2\,
      Q => \^q_reg[60]_0\(22),
      R => SR(0)
    );
\q_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][23]_srl5_n_2\,
      Q => \^q_reg[60]_0\(23),
      R => SR(0)
    );
\q_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][24]_srl5_n_2\,
      Q => \^q_reg[60]_0\(24),
      R => SR(0)
    );
\q_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][25]_srl5_n_2\,
      Q => \^q_reg[60]_0\(25),
      R => SR(0)
    );
\q_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][26]_srl5_n_2\,
      Q => \^q_reg[60]_0\(26),
      R => SR(0)
    );
\q_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][27]_srl5_n_2\,
      Q => \^q_reg[60]_0\(27),
      R => SR(0)
    );
\q_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][28]_srl5_n_2\,
      Q => \^q_reg[60]_0\(28),
      R => SR(0)
    );
\q_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][29]_srl5_n_2\,
      Q => \^q_reg[60]_0\(29),
      R => SR(0)
    );
\q_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][2]_srl5_n_2\,
      Q => \^q_reg[60]_0\(2),
      R => SR(0)
    );
\q_reg[32]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][32]_srl5_n_2\,
      Q => \^q_reg[60]_0\(30),
      R => SR(0)
    );
\q_reg[33]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][33]_srl5_n_2\,
      Q => \^q_reg[60]_0\(31),
      R => SR(0)
    );
\q_reg[34]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][34]_srl5_n_2\,
      Q => \^q_reg[60]_0\(32),
      R => SR(0)
    );
\q_reg[35]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][35]_srl5_n_2\,
      Q => \^q_reg[60]_0\(33),
      R => SR(0)
    );
\q_reg[36]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][36]_srl5_n_2\,
      Q => \^q_reg[60]_0\(34),
      R => SR(0)
    );
\q_reg[37]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][37]_srl5_n_2\,
      Q => \^q_reg[60]_0\(35),
      R => SR(0)
    );
\q_reg[38]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][38]_srl5_n_2\,
      Q => \^q_reg[60]_0\(36),
      R => SR(0)
    );
\q_reg[39]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][39]_srl5_n_2\,
      Q => \^q_reg[60]_0\(37),
      R => SR(0)
    );
\q_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][3]_srl5_n_2\,
      Q => \^q_reg[60]_0\(3),
      R => SR(0)
    );
\q_reg[40]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][40]_srl5_n_2\,
      Q => \^q_reg[60]_0\(38),
      R => SR(0)
    );
\q_reg[41]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][41]_srl5_n_2\,
      Q => \^q_reg[60]_0\(39),
      R => SR(0)
    );
\q_reg[42]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][42]_srl5_n_2\,
      Q => \^q_reg[60]_0\(40),
      R => SR(0)
    );
\q_reg[43]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][43]_srl5_n_2\,
      Q => \^q_reg[60]_0\(41),
      R => SR(0)
    );
\q_reg[44]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][44]_srl5_n_2\,
      Q => \^q_reg[60]_0\(42),
      R => SR(0)
    );
\q_reg[45]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][45]_srl5_n_2\,
      Q => \^q_reg[60]_0\(43),
      R => SR(0)
    );
\q_reg[46]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][46]_srl5_n_2\,
      Q => \^q_reg[60]_0\(44),
      R => SR(0)
    );
\q_reg[47]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][47]_srl5_n_2\,
      Q => \^q_reg[60]_0\(45),
      R => SR(0)
    );
\q_reg[48]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][48]_srl5_n_2\,
      Q => \^q_reg[60]_0\(46),
      R => SR(0)
    );
\q_reg[49]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][49]_srl5_n_2\,
      Q => \^q_reg[60]_0\(47),
      R => SR(0)
    );
\q_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][4]_srl5_n_2\,
      Q => \^q_reg[60]_0\(4),
      R => SR(0)
    );
\q_reg[50]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][50]_srl5_n_2\,
      Q => \^q_reg[60]_0\(48),
      R => SR(0)
    );
\q_reg[51]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][51]_srl5_n_2\,
      Q => \^q_reg[60]_0\(49),
      R => SR(0)
    );
\q_reg[52]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][52]_srl5_n_2\,
      Q => \^q_reg[60]_0\(50),
      R => SR(0)
    );
\q_reg[53]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][53]_srl5_n_2\,
      Q => \^q_reg[60]_0\(51),
      R => SR(0)
    );
\q_reg[54]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][54]_srl5_n_2\,
      Q => \^q_reg[60]_0\(52),
      R => SR(0)
    );
\q_reg[55]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][55]_srl5_n_2\,
      Q => \^q_reg[60]_0\(53),
      R => SR(0)
    );
\q_reg[56]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][56]_srl5_n_2\,
      Q => \^q_reg[60]_0\(54),
      R => SR(0)
    );
\q_reg[57]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][57]_srl5_n_2\,
      Q => \^q_reg[60]_0\(55),
      R => SR(0)
    );
\q_reg[58]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][58]_srl5_n_2\,
      Q => \^q_reg[60]_0\(56),
      R => SR(0)
    );
\q_reg[59]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][59]_srl5_n_2\,
      Q => \^q_reg[60]_0\(57),
      R => SR(0)
    );
\q_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][5]_srl5_n_2\,
      Q => \^q_reg[60]_0\(5),
      R => SR(0)
    );
\q_reg[60]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][60]_srl5_n_2\,
      Q => \^q_reg[60]_0\(58),
      R => SR(0)
    );
\q_reg[61]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][61]_srl5_n_2\,
      Q => fifo_rreq_data(61),
      R => SR(0)
    );
\q_reg[62]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][62]_srl5_n_2\,
      Q => fifo_rreq_data(62),
      R => SR(0)
    );
\q_reg[63]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][63]_srl5_n_2\,
      Q => fifo_rreq_data(63),
      R => SR(0)
    );
\q_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][6]_srl5_n_2\,
      Q => \^q_reg[60]_0\(6),
      R => SR(0)
    );
\q_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][7]_srl5_n_2\,
      Q => \^q_reg[60]_0\(7),
      R => SR(0)
    );
\q_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][8]_srl5_n_2\,
      Q => \^q_reg[60]_0\(8),
      R => SR(0)
    );
\q_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[4][9]_srl5_n_2\,
      Q => \^q_reg[60]_0\(9),
      R => SR(0)
    );
\sect_cnt[0]_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FD550155"
    )
        port map (
      I0 => Q(0),
      I1 => \sect_cnt_reg[0]\,
      I2 => \^fifo_rreq_valid\,
      I3 => \sect_cnt_reg[0]_0\,
      I4 => \sect_cnt_reg[19]_0\(0),
      O => D(0)
    );
\sect_cnt[10]_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FEAA02AA"
    )
        port map (
      I0 => \sect_cnt_reg[12]\(1),
      I1 => \sect_cnt_reg[0]\,
      I2 => \^fifo_rreq_valid\,
      I3 => \sect_cnt_reg[0]_0\,
      I4 => \sect_cnt_reg[19]_0\(10),
      O => D(10)
    );
\sect_cnt[11]_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FEAA02AA"
    )
        port map (
      I0 => \sect_cnt_reg[12]\(2),
      I1 => \sect_cnt_reg[0]\,
      I2 => \^fifo_rreq_valid\,
      I3 => \sect_cnt_reg[0]_0\,
      I4 => \sect_cnt_reg[19]_0\(11),
      O => D(11)
    );
\sect_cnt[12]_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FEAA02AA"
    )
        port map (
      I0 => \sect_cnt_reg[12]\(3),
      I1 => \sect_cnt_reg[0]\,
      I2 => \^fifo_rreq_valid\,
      I3 => \sect_cnt_reg[0]_0\,
      I4 => \sect_cnt_reg[19]_0\(12),
      O => D(12)
    );
\sect_cnt[13]_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FEAA02AA"
    )
        port map (
      I0 => \sect_cnt_reg[16]\(0),
      I1 => \sect_cnt_reg[0]\,
      I2 => \^fifo_rreq_valid\,
      I3 => \sect_cnt_reg[0]_0\,
      I4 => \sect_cnt_reg[19]_0\(13),
      O => D(13)
    );
\sect_cnt[14]_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FEAA02AA"
    )
        port map (
      I0 => \sect_cnt_reg[16]\(1),
      I1 => \sect_cnt_reg[0]\,
      I2 => \^fifo_rreq_valid\,
      I3 => \sect_cnt_reg[0]_0\,
      I4 => \sect_cnt_reg[19]_0\(14),
      O => D(14)
    );
\sect_cnt[15]_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FEAA02AA"
    )
        port map (
      I0 => \sect_cnt_reg[16]\(2),
      I1 => \sect_cnt_reg[0]\,
      I2 => \^fifo_rreq_valid\,
      I3 => \sect_cnt_reg[0]_0\,
      I4 => \sect_cnt_reg[19]_0\(15),
      O => D(15)
    );
\sect_cnt[16]_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FEAA02AA"
    )
        port map (
      I0 => \sect_cnt_reg[16]\(3),
      I1 => \sect_cnt_reg[0]\,
      I2 => \^fifo_rreq_valid\,
      I3 => \sect_cnt_reg[0]_0\,
      I4 => \sect_cnt_reg[19]_0\(16),
      O => D(16)
    );
\sect_cnt[17]_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FEAA02AA"
    )
        port map (
      I0 => \sect_cnt_reg[19]_1\(0),
      I1 => \sect_cnt_reg[0]\,
      I2 => \^fifo_rreq_valid\,
      I3 => \sect_cnt_reg[0]_0\,
      I4 => \sect_cnt_reg[19]_0\(17),
      O => D(17)
    );
\sect_cnt[18]_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FEAA02AA"
    )
        port map (
      I0 => \sect_cnt_reg[19]_1\(1),
      I1 => \sect_cnt_reg[0]\,
      I2 => \^fifo_rreq_valid\,
      I3 => \sect_cnt_reg[0]_0\,
      I4 => \sect_cnt_reg[19]_0\(18),
      O => D(18)
    );
\sect_cnt[19]_i_2__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FEAA02AA"
    )
        port map (
      I0 => \sect_cnt_reg[19]_1\(2),
      I1 => \sect_cnt_reg[0]\,
      I2 => \^fifo_rreq_valid\,
      I3 => \sect_cnt_reg[0]_0\,
      I4 => \sect_cnt_reg[19]_0\(19),
      O => D(19)
    );
\sect_cnt[1]_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FEAA02AA"
    )
        port map (
      I0 => O(0),
      I1 => \sect_cnt_reg[0]\,
      I2 => \^fifo_rreq_valid\,
      I3 => \sect_cnt_reg[0]_0\,
      I4 => \sect_cnt_reg[19]_0\(1),
      O => D(1)
    );
\sect_cnt[2]_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FEAA02AA"
    )
        port map (
      I0 => O(1),
      I1 => \sect_cnt_reg[0]\,
      I2 => \^fifo_rreq_valid\,
      I3 => \sect_cnt_reg[0]_0\,
      I4 => \sect_cnt_reg[19]_0\(2),
      O => D(2)
    );
\sect_cnt[3]_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FEAA02AA"
    )
        port map (
      I0 => O(2),
      I1 => \sect_cnt_reg[0]\,
      I2 => \^fifo_rreq_valid\,
      I3 => \sect_cnt_reg[0]_0\,
      I4 => \sect_cnt_reg[19]_0\(3),
      O => D(3)
    );
\sect_cnt[4]_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FEAA02AA"
    )
        port map (
      I0 => O(3),
      I1 => \sect_cnt_reg[0]\,
      I2 => \^fifo_rreq_valid\,
      I3 => \sect_cnt_reg[0]_0\,
      I4 => \sect_cnt_reg[19]_0\(4),
      O => D(4)
    );
\sect_cnt[5]_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FEAA02AA"
    )
        port map (
      I0 => \sect_cnt_reg[8]\(0),
      I1 => \sect_cnt_reg[0]\,
      I2 => \^fifo_rreq_valid\,
      I3 => \sect_cnt_reg[0]_0\,
      I4 => \sect_cnt_reg[19]_0\(5),
      O => D(5)
    );
\sect_cnt[6]_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FEAA02AA"
    )
        port map (
      I0 => \sect_cnt_reg[8]\(1),
      I1 => \sect_cnt_reg[0]\,
      I2 => \^fifo_rreq_valid\,
      I3 => \sect_cnt_reg[0]_0\,
      I4 => \sect_cnt_reg[19]_0\(6),
      O => D(6)
    );
\sect_cnt[7]_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FEAA02AA"
    )
        port map (
      I0 => \sect_cnt_reg[8]\(2),
      I1 => \sect_cnt_reg[0]\,
      I2 => \^fifo_rreq_valid\,
      I3 => \sect_cnt_reg[0]_0\,
      I4 => \sect_cnt_reg[19]_0\(7),
      O => D(7)
    );
\sect_cnt[8]_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FEAA02AA"
    )
        port map (
      I0 => \sect_cnt_reg[8]\(3),
      I1 => \sect_cnt_reg[0]\,
      I2 => \^fifo_rreq_valid\,
      I3 => \sect_cnt_reg[0]_0\,
      I4 => \sect_cnt_reg[19]_0\(8),
      O => D(8)
    );
\sect_cnt[9]_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FEAA02AA"
    )
        port map (
      I0 => \sect_cnt_reg[12]\(0),
      I1 => \sect_cnt_reg[0]\,
      I2 => \^fifo_rreq_valid\,
      I3 => \sect_cnt_reg[0]_0\,
      I4 => \sect_cnt_reg[19]_0\(9),
      O => D(9)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity \design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo__parameterized1\ is
  port (
    fifo_resp_ready : out STD_LOGIC;
    next_resp0 : out STD_LOGIC;
    push : out STD_LOGIC;
    ap_clk : in STD_LOGIC;
    SR : in STD_LOGIC_VECTOR ( 0 to 0 );
    push_0 : in STD_LOGIC;
    next_resp : in STD_LOGIC;
    ap_rst_n : in STD_LOGIC;
    \q_reg[1]_0\ : in STD_LOGIC;
    \q_reg[1]_1\ : in STD_LOGIC;
    m_axi_gmem_BVALID : in STD_LOGIC;
    next_resp_reg : in STD_LOGIC;
    \in\ : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo__parameterized1\ : entity is "simple_accel_core_gmem_m_axi_fifo";
end \design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo__parameterized1\;

architecture STRUCTURE of \design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo__parameterized1\ is
  signal aw2b_awdata : STD_LOGIC_VECTOR ( 1 to 1 );
  signal aw2b_bdata : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \data_vld_i_1__1_n_2\ : STD_LOGIC;
  signal data_vld_reg_n_2 : STD_LOGIC;
  signal \empty_n_i_1__4_n_2\ : STD_LOGIC;
  signal \^fifo_resp_ready\ : STD_LOGIC;
  signal \full_n_i_1__3_n_2\ : STD_LOGIC;
  signal \full_n_i_2__3_n_2\ : STD_LOGIC;
  signal full_n_i_3_n_2 : STD_LOGIC;
  signal \mem_reg[14][0]_srl15_n_2\ : STD_LOGIC;
  signal \mem_reg[14][1]_srl15_n_2\ : STD_LOGIC;
  signal need_wrsp : STD_LOGIC;
  signal pop0 : STD_LOGIC;
  signal \pout[0]_i_1_n_2\ : STD_LOGIC;
  signal \pout[1]_i_1__0_n_2\ : STD_LOGIC;
  signal \pout[2]_i_1_n_2\ : STD_LOGIC;
  signal \pout[3]_i_1_n_2\ : STD_LOGIC;
  signal \pout[3]_i_2_n_2\ : STD_LOGIC;
  signal \pout[3]_i_3_n_2\ : STD_LOGIC;
  signal \pout[3]_i_4_n_2\ : STD_LOGIC;
  signal \pout_reg__0\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \data_vld_i_1__1\ : label is "soft_lutpair164";
  attribute SOFT_HLUTNM of \full_n_i_2__3\ : label is "soft_lutpair165";
  attribute SOFT_HLUTNM of full_n_i_3 : label is "soft_lutpair162";
  attribute srl_bus_name : string;
  attribute srl_bus_name of \mem_reg[14][0]_srl15\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_resp/mem_reg[14] ";
  attribute srl_name : string;
  attribute srl_name of \mem_reg[14][0]_srl15\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_resp/mem_reg[14][0]_srl15 ";
  attribute srl_bus_name of \mem_reg[14][1]_srl15\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_resp/mem_reg[14] ";
  attribute srl_name of \mem_reg[14][1]_srl15\ : label is "inst/\simple_accel_core_gmem_m_axi_U/bus_write/fifo_resp/mem_reg[14][1]_srl15 ";
  attribute SOFT_HLUTNM of \pout[1]_i_1__0\ : label is "soft_lutpair162";
  attribute SOFT_HLUTNM of \pout[2]_i_1\ : label is "soft_lutpair163";
  attribute SOFT_HLUTNM of \pout[3]_i_2\ : label is "soft_lutpair163";
  attribute SOFT_HLUTNM of \pout[3]_i_3\ : label is "soft_lutpair165";
  attribute SOFT_HLUTNM of \pout[3]_i_4\ : label is "soft_lutpair164";
begin
  fifo_resp_ready <= \^fifo_resp_ready\;
\data_vld_i_1__1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"AEAAEEEE"
    )
        port map (
      I0 => push_0,
      I1 => data_vld_reg_n_2,
      I2 => next_resp,
      I3 => need_wrsp,
      I4 => \pout[3]_i_3_n_2\,
      O => \data_vld_i_1__1_n_2\
    );
data_vld_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \data_vld_i_1__1_n_2\,
      Q => data_vld_reg_n_2,
      R => SR(0)
    );
\empty_n_i_1__4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"BA"
    )
        port map (
      I0 => data_vld_reg_n_2,
      I1 => next_resp,
      I2 => need_wrsp,
      O => \empty_n_i_1__4_n_2\
    );
empty_n_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \empty_n_i_1__4_n_2\,
      Q => need_wrsp,
      R => SR(0)
    );
\full_n_i_1__3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"D5DDDDDDFFFFDDDD"
    )
        port map (
      I0 => ap_rst_n,
      I1 => \^fifo_resp_ready\,
      I2 => \full_n_i_2__3_n_2\,
      I3 => push_0,
      I4 => data_vld_reg_n_2,
      I5 => full_n_i_3_n_2,
      O => \full_n_i_1__3_n_2\
    );
\full_n_i_2__3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FF7F"
    )
        port map (
      I0 => \pout_reg__0\(2),
      I1 => \pout_reg__0\(3),
      I2 => \pout_reg__0\(0),
      I3 => \pout_reg__0\(1),
      O => \full_n_i_2__3_n_2\
    );
full_n_i_3: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => need_wrsp,
      I1 => next_resp,
      O => full_n_i_3_n_2
    );
full_n_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \full_n_i_1__3_n_2\,
      Q => \^fifo_resp_ready\,
      R => '0'
    );
\mem_reg[14][0]_srl15\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg__0\(0),
      A1 => \pout_reg__0\(1),
      A2 => \pout_reg__0\(2),
      A3 => \pout_reg__0\(3),
      CE => push_0,
      CLK => ap_clk,
      D => \in\(0),
      Q => \mem_reg[14][0]_srl15_n_2\
    );
\mem_reg[14][1]_srl15\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000"
    )
        port map (
      A0 => \pout_reg__0\(0),
      A1 => \pout_reg__0\(1),
      A2 => \pout_reg__0\(2),
      A3 => \pout_reg__0\(3),
      CE => push_0,
      CLK => ap_clk,
      D => aw2b_awdata(1),
      Q => \mem_reg[14][1]_srl15_n_2\
    );
\mem_reg[14][1]_srl15_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \q_reg[1]_0\,
      I1 => \q_reg[1]_1\,
      O => aw2b_awdata(1)
    );
next_resp_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"88F88888"
    )
        port map (
      I0 => m_axi_gmem_BVALID,
      I1 => next_resp_reg,
      I2 => need_wrsp,
      I3 => next_resp,
      I4 => aw2b_bdata(0),
      O => next_resp0
    );
\pout[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \pout_reg__0\(0),
      O => \pout[0]_i_1_n_2\
    );
\pout[1]_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"BF4040BF"
    )
        port map (
      I0 => next_resp,
      I1 => need_wrsp,
      I2 => push_0,
      I3 => \pout_reg__0\(1),
      I4 => \pout_reg__0\(0),
      O => \pout[1]_i_1__0_n_2\
    );
\pout[2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7E81"
    )
        port map (
      I0 => \pout_reg__0\(0),
      I1 => \pout_reg__0\(1),
      I2 => \pout[3]_i_4_n_2\,
      I3 => \pout_reg__0\(2),
      O => \pout[2]_i_1_n_2\
    );
\pout[2]_i_2__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"E0000000"
    )
        port map (
      I0 => aw2b_bdata(0),
      I1 => aw2b_bdata(1),
      I2 => need_wrsp,
      I3 => next_resp_reg,
      I4 => next_resp,
      O => push
    );
\pout[3]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"08005900"
    )
        port map (
      I0 => push_0,
      I1 => need_wrsp,
      I2 => next_resp,
      I3 => data_vld_reg_n_2,
      I4 => \pout[3]_i_3_n_2\,
      O => \pout[3]_i_1_n_2\
    );
\pout[3]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"6AAAAAA9"
    )
        port map (
      I0 => \pout_reg__0\(3),
      I1 => \pout_reg__0\(0),
      I2 => \pout_reg__0\(1),
      I3 => \pout[3]_i_4_n_2\,
      I4 => \pout_reg__0\(2),
      O => \pout[3]_i_2_n_2\
    );
\pout[3]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0001"
    )
        port map (
      I0 => \pout_reg__0\(2),
      I1 => \pout_reg__0\(3),
      I2 => \pout_reg__0\(1),
      I3 => \pout_reg__0\(0),
      O => \pout[3]_i_3_n_2\
    );
\pout[3]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0080"
    )
        port map (
      I0 => push_0,
      I1 => data_vld_reg_n_2,
      I2 => need_wrsp,
      I3 => next_resp,
      O => \pout[3]_i_4_n_2\
    );
\pout_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \pout[3]_i_1_n_2\,
      D => \pout[0]_i_1_n_2\,
      Q => \pout_reg__0\(0),
      R => SR(0)
    );
\pout_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \pout[3]_i_1_n_2\,
      D => \pout[1]_i_1__0_n_2\,
      Q => \pout_reg__0\(1),
      R => SR(0)
    );
\pout_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \pout[3]_i_1_n_2\,
      D => \pout[2]_i_1_n_2\,
      Q => \pout_reg__0\(2),
      R => SR(0)
    );
\pout_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \pout[3]_i_1_n_2\,
      D => \pout[3]_i_2_n_2\,
      Q => \pout_reg__0\(3),
      R => SR(0)
    );
\q[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => next_resp,
      I1 => need_wrsp,
      O => pop0
    );
\q_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[14][0]_srl15_n_2\,
      Q => aw2b_bdata(0),
      R => SR(0)
    );
\q_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => pop0,
      D => \mem_reg[14][1]_srl15_n_2\,
      Q => aw2b_bdata(1),
      R => SR(0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity \design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo__parameterized1_0\ is
  port (
    invalid_len_event_reg2_reg : out STD_LOGIC;
    E : out STD_LOGIC_VECTOR ( 0 to 0 );
    rreq_handling_reg : out STD_LOGIC;
    \could_multi_bursts.sect_handling_reg\ : out STD_LOGIC_VECTOR ( 0 to 0 );
    \could_multi_bursts.sect_handling_reg_0\ : out STD_LOGIC;
    ap_rst_n_0 : out STD_LOGIC_VECTOR ( 0 to 0 );
    push : out STD_LOGIC;
    rreq_handling_reg_0 : out STD_LOGIC_VECTOR ( 0 to 0 );
    rreq_handling_reg_1 : out STD_LOGIC;
    \could_multi_bursts.sect_handling_reg_1\ : out STD_LOGIC;
    ap_rst_n_1 : out STD_LOGIC_VECTOR ( 0 to 0 );
    \could_multi_bursts.sect_handling_reg_2\ : out STD_LOGIC;
    \end_addr_buf_reg[2]\ : out STD_LOGIC;
    \beat_len_buf_reg[1]\ : out STD_LOGIC;
    \beat_len_buf_reg[2]\ : out STD_LOGIC;
    \start_addr_buf_reg[5]\ : out STD_LOGIC;
    \beat_len_buf_reg[4]\ : out STD_LOGIC;
    \beat_len_buf_reg[5]\ : out STD_LOGIC;
    \end_addr_buf_reg[8]\ : out STD_LOGIC;
    \start_addr_buf_reg[9]\ : out STD_LOGIC;
    \end_addr_buf_reg[10]\ : out STD_LOGIC;
    \beat_len_buf_reg[9]\ : out STD_LOGIC;
    \could_multi_bursts.sect_handling_reg_3\ : out STD_LOGIC;
    \could_multi_bursts.sect_handling_reg_4\ : out STD_LOGIC;
    \could_multi_bursts.sect_handling_reg_5\ : out STD_LOGIC;
    \could_multi_bursts.sect_handling_reg_6\ : out STD_LOGIC;
    \could_multi_bursts.sect_handling_reg_7\ : out STD_LOGIC;
    ap_clk : in STD_LOGIC;
    SR : in STD_LOGIC_VECTOR ( 0 to 0 );
    invalid_len_event_reg2 : in STD_LOGIC;
    \could_multi_bursts.sect_handling_reg_8\ : in STD_LOGIC;
    m_axi_gmem_ARREADY : in STD_LOGIC;
    \could_multi_bursts.ARVALID_Dummy_reg\ : in STD_LOGIC;
    ap_rst_n : in STD_LOGIC;
    fifo_rreq_valid : in STD_LOGIC;
    rreq_handling_reg_2 : in STD_LOGIC;
    rreq_handling_reg_3 : in STD_LOGIC;
    rreq_handling_reg_4 : in STD_LOGIC;
    data_vld_reg_0 : in STD_LOGIC_VECTOR ( 0 to 0 );
    next_beat : in STD_LOGIC;
    rreq_handling_reg_5 : in STD_LOGIC;
    beat_valid : in STD_LOGIC;
    empty_n_reg_0 : in STD_LOGIC;
    rdata_ack_t : in STD_LOGIC;
    invalid_len_event : in STD_LOGIC;
    CO : in STD_LOGIC_VECTOR ( 0 to 0 );
    \sect_addr_buf_reg[2]\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    Q : in STD_LOGIC_VECTOR ( 9 downto 0 );
    \sect_len_buf_reg[9]\ : in STD_LOGIC_VECTOR ( 9 downto 0 );
    \sect_len_buf_reg[9]_0\ : in STD_LOGIC_VECTOR ( 9 downto 0 );
    \could_multi_bursts.arlen_buf_reg[0]\ : in STD_LOGIC;
    \could_multi_bursts.arlen_buf_reg[3]\ : in STD_LOGIC_VECTOR ( 3 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo__parameterized1_0\ : entity is "simple_accel_core_gmem_m_axi_fifo";
end \design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo__parameterized1_0\;

architecture STRUCTURE of \design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo__parameterized1_0\ is
  signal \could_multi_bursts.sect_handling_i_2_n_2\ : STD_LOGIC;
  signal \^could_multi_bursts.sect_handling_reg_0\ : STD_LOGIC;
  signal \data_vld_i_1__4_n_2\ : STD_LOGIC;
  signal data_vld_reg_n_2 : STD_LOGIC;
  signal \empty_n_i_1__3_n_2\ : STD_LOGIC;
  signal empty_n_reg_n_2 : STD_LOGIC;
  signal fifo_rctl_ready : STD_LOGIC;
  signal \full_n_i_1__6_n_2\ : STD_LOGIC;
  signal \full_n_i_2__6_n_2\ : STD_LOGIC;
  signal \pout[0]_i_1__0_n_2\ : STD_LOGIC;
  signal \pout[1]_i_1_n_2\ : STD_LOGIC;
  signal \pout[2]_i_1__0_n_2\ : STD_LOGIC;
  signal \pout[3]_i_1__0_n_2\ : STD_LOGIC;
  signal \pout[3]_i_2__0_n_2\ : STD_LOGIC;
  signal \pout[3]_i_3__0_n_2\ : STD_LOGIC;
  signal \pout[3]_i_4__0_n_2\ : STD_LOGIC;
  signal \pout_reg__0\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \^push\ : STD_LOGIC;
  signal \^rreq_handling_reg\ : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \could_multi_bursts.araddr_buf[31]_i_1\ : label is "soft_lutpair75";
  attribute SOFT_HLUTNM of \could_multi_bursts.arlen_buf[3]_i_1\ : label is "soft_lutpair75";
  attribute SOFT_HLUTNM of \could_multi_bursts.loop_cnt[5]_i_1\ : label is "soft_lutpair78";
  attribute SOFT_HLUTNM of fifo_rreq_valid_buf_i_1 : label is "soft_lutpair77";
  attribute SOFT_HLUTNM of fifo_rreq_valid_buf_i_2 : label is "soft_lutpair73";
  attribute SOFT_HLUTNM of invalid_len_event_reg2_i_1 : label is "soft_lutpair79";
  attribute SOFT_HLUTNM of \pout[1]_i_1\ : label is "soft_lutpair76";
  attribute SOFT_HLUTNM of \pout[2]_i_1__0\ : label is "soft_lutpair76";
  attribute SOFT_HLUTNM of \pout[3]_i_2__0\ : label is "soft_lutpair74";
  attribute SOFT_HLUTNM of \pout[3]_i_3__0\ : label is "soft_lutpair74";
  attribute SOFT_HLUTNM of rreq_handling_i_1 : label is "soft_lutpair73";
  attribute SOFT_HLUTNM of \sect_addr_buf[11]_i_1__0\ : label is "soft_lutpair78";
  attribute SOFT_HLUTNM of \sect_cnt[19]_i_1__0\ : label is "soft_lutpair77";
  attribute SOFT_HLUTNM of \sect_len_buf[9]_i_1__0\ : label is "soft_lutpair79";
begin
  \could_multi_bursts.sect_handling_reg_0\ <= \^could_multi_bursts.sect_handling_reg_0\;
  push <= \^push\;
  rreq_handling_reg <= \^rreq_handling_reg\;
\could_multi_bursts.ARVALID_Dummy_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"40FF404000000000"
    )
        port map (
      I0 => invalid_len_event_reg2,
      I1 => \could_multi_bursts.sect_handling_reg_8\,
      I2 => fifo_rctl_ready,
      I3 => m_axi_gmem_ARREADY,
      I4 => \could_multi_bursts.ARVALID_Dummy_reg\,
      I5 => ap_rst_n,
      O => invalid_len_event_reg2_reg
    );
\could_multi_bursts.araddr_buf[31]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"D000"
    )
        port map (
      I0 => \could_multi_bursts.ARVALID_Dummy_reg\,
      I1 => m_axi_gmem_ARREADY,
      I2 => fifo_rctl_ready,
      I3 => \could_multi_bursts.sect_handling_reg_8\,
      O => \^push\
    );
\could_multi_bursts.arlen_buf[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF80880000"
    )
        port map (
      I0 => \could_multi_bursts.sect_handling_reg_8\,
      I1 => fifo_rctl_ready,
      I2 => m_axi_gmem_ARREADY,
      I3 => \could_multi_bursts.ARVALID_Dummy_reg\,
      I4 => \could_multi_bursts.arlen_buf_reg[0]\,
      I5 => \could_multi_bursts.arlen_buf_reg[3]\(0),
      O => \could_multi_bursts.sect_handling_reg_3\
    );
\could_multi_bursts.arlen_buf[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF80880000"
    )
        port map (
      I0 => \could_multi_bursts.sect_handling_reg_8\,
      I1 => fifo_rctl_ready,
      I2 => m_axi_gmem_ARREADY,
      I3 => \could_multi_bursts.ARVALID_Dummy_reg\,
      I4 => \could_multi_bursts.arlen_buf_reg[0]\,
      I5 => \could_multi_bursts.arlen_buf_reg[3]\(1),
      O => \could_multi_bursts.sect_handling_reg_4\
    );
\could_multi_bursts.arlen_buf[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF80880000"
    )
        port map (
      I0 => \could_multi_bursts.sect_handling_reg_8\,
      I1 => fifo_rctl_ready,
      I2 => m_axi_gmem_ARREADY,
      I3 => \could_multi_bursts.ARVALID_Dummy_reg\,
      I4 => \could_multi_bursts.arlen_buf_reg[0]\,
      I5 => \could_multi_bursts.arlen_buf_reg[3]\(2),
      O => \could_multi_bursts.sect_handling_reg_5\
    );
\could_multi_bursts.arlen_buf[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8088"
    )
        port map (
      I0 => \could_multi_bursts.sect_handling_reg_8\,
      I1 => fifo_rctl_ready,
      I2 => m_axi_gmem_ARREADY,
      I3 => \could_multi_bursts.ARVALID_Dummy_reg\,
      O => \could_multi_bursts.sect_handling_reg_6\
    );
\could_multi_bursts.arlen_buf[3]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF80880000"
    )
        port map (
      I0 => \could_multi_bursts.sect_handling_reg_8\,
      I1 => fifo_rctl_ready,
      I2 => m_axi_gmem_ARREADY,
      I3 => \could_multi_bursts.ARVALID_Dummy_reg\,
      I4 => \could_multi_bursts.arlen_buf_reg[0]\,
      I5 => \could_multi_bursts.arlen_buf_reg[3]\(3),
      O => \could_multi_bursts.sect_handling_reg_7\
    );
\could_multi_bursts.loop_cnt[5]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"7"
    )
        port map (
      I0 => ap_rst_n,
      I1 => \^could_multi_bursts.sect_handling_reg_0\,
      O => ap_rst_n_0(0)
    );
\could_multi_bursts.sect_handling_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"CE"
    )
        port map (
      I0 => \could_multi_bursts.sect_handling_reg_8\,
      I1 => rreq_handling_reg_5,
      I2 => \could_multi_bursts.sect_handling_i_2_n_2\,
      O => \could_multi_bursts.sect_handling_reg_1\
    );
\could_multi_bursts.sect_handling_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000008088"
    )
        port map (
      I0 => \could_multi_bursts.sect_handling_reg_8\,
      I1 => fifo_rctl_ready,
      I2 => m_axi_gmem_ARREADY,
      I3 => \could_multi_bursts.ARVALID_Dummy_reg\,
      I4 => rreq_handling_reg_3,
      I5 => rreq_handling_reg_4,
      O => \could_multi_bursts.sect_handling_i_2_n_2\
    );
\data_vld_i_1__4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BAFAFAFABABABABA"
    )
        port map (
      I0 => \^push\,
      I1 => \pout[3]_i_3__0_n_2\,
      I2 => data_vld_reg_n_2,
      I3 => data_vld_reg_0(0),
      I4 => next_beat,
      I5 => empty_n_reg_n_2,
      O => \data_vld_i_1__4_n_2\
    );
data_vld_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \data_vld_i_1__4_n_2\,
      Q => data_vld_reg_n_2,
      R => SR(0)
    );
\empty_n_i_1__3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF22A2AAAA"
    )
        port map (
      I0 => empty_n_reg_n_2,
      I1 => beat_valid,
      I2 => empty_n_reg_0,
      I3 => rdata_ack_t,
      I4 => data_vld_reg_0(0),
      I5 => data_vld_reg_n_2,
      O => \empty_n_i_1__3_n_2\
    );
empty_n_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \empty_n_i_1__3_n_2\,
      Q => empty_n_reg_n_2,
      R => SR(0)
    );
fifo_rreq_valid_buf_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"A8"
    )
        port map (
      I0 => \^rreq_handling_reg\,
      I1 => fifo_rreq_valid,
      I2 => rreq_handling_reg_2,
      O => E(0)
    );
fifo_rreq_valid_buf_i_2: unisim.vcomponents.LUT3
    generic map(
      INIT => X"4F"
    )
        port map (
      I0 => \^could_multi_bursts.sect_handling_reg_0\,
      I1 => CO(0),
      I2 => rreq_handling_reg_5,
      O => \^rreq_handling_reg\
    );
\full_n_i_1__6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFD500FFFF"
    )
        port map (
      I0 => empty_n_reg_n_2,
      I1 => next_beat,
      I2 => data_vld_reg_0(0),
      I3 => data_vld_reg_n_2,
      I4 => ap_rst_n,
      I5 => \full_n_i_2__6_n_2\,
      O => \full_n_i_1__6_n_2\
    );
\full_n_i_2__6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAA2AAAAAAAAAAA"
    )
        port map (
      I0 => fifo_rctl_ready,
      I1 => \pout_reg__0\(2),
      I2 => \pout_reg__0\(3),
      I3 => \pout_reg__0\(0),
      I4 => \pout_reg__0\(1),
      I5 => \pout[3]_i_4__0_n_2\,
      O => \full_n_i_2__6_n_2\
    );
full_n_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \full_n_i_1__6_n_2\,
      Q => fifo_rctl_ready,
      R => '0'
    );
invalid_len_event_reg2_i_1: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^could_multi_bursts.sect_handling_reg_0\,
      O => \could_multi_bursts.sect_handling_reg\(0)
    );
\pout[0]_i_1__0\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \pout_reg__0\(0),
      O => \pout[0]_i_1__0_n_2\
    );
\pout[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"69"
    )
        port map (
      I0 => \pout[3]_i_4__0_n_2\,
      I1 => \pout_reg__0\(1),
      I2 => \pout_reg__0\(0),
      O => \pout[1]_i_1_n_2\
    );
\pout[2]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6AA9"
    )
        port map (
      I0 => \pout_reg__0\(2),
      I1 => \pout[3]_i_4__0_n_2\,
      I2 => \pout_reg__0\(1),
      I3 => \pout_reg__0\(0),
      O => \pout[2]_i_1__0_n_2\
    );
\pout[3]_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"10A0A0A010101010"
    )
        port map (
      I0 => \^push\,
      I1 => \pout[3]_i_3__0_n_2\,
      I2 => data_vld_reg_n_2,
      I3 => data_vld_reg_0(0),
      I4 => next_beat,
      I5 => empty_n_reg_n_2,
      O => \pout[3]_i_1__0_n_2\
    );
\pout[3]_i_2__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"6AAAAAA9"
    )
        port map (
      I0 => \pout_reg__0\(3),
      I1 => \pout_reg__0\(2),
      I2 => \pout_reg__0\(0),
      I3 => \pout_reg__0\(1),
      I4 => \pout[3]_i_4__0_n_2\,
      O => \pout[3]_i_2__0_n_2\
    );
\pout[3]_i_3__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0001"
    )
        port map (
      I0 => \pout_reg__0\(2),
      I1 => \pout_reg__0\(3),
      I2 => \pout_reg__0\(1),
      I3 => \pout_reg__0\(0),
      O => \pout[3]_i_3__0_n_2\
    );
\pout[3]_i_4__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"70000000"
    )
        port map (
      I0 => data_vld_reg_0(0),
      I1 => next_beat,
      I2 => empty_n_reg_n_2,
      I3 => \^push\,
      I4 => data_vld_reg_n_2,
      O => \pout[3]_i_4__0_n_2\
    );
\pout_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \pout[3]_i_1__0_n_2\,
      D => \pout[0]_i_1__0_n_2\,
      Q => \pout_reg__0\(0),
      R => SR(0)
    );
\pout_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \pout[3]_i_1__0_n_2\,
      D => \pout[1]_i_1_n_2\,
      Q => \pout_reg__0\(1),
      R => SR(0)
    );
\pout_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \pout[3]_i_1__0_n_2\,
      D => \pout[2]_i_1__0_n_2\,
      Q => \pout_reg__0\(2),
      R => SR(0)
    );
\pout_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \pout[3]_i_1__0_n_2\,
      D => \pout[3]_i_2__0_n_2\,
      Q => \pout_reg__0\(3),
      R => SR(0)
    );
rreq_handling_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"AEAE0CAE"
    )
        port map (
      I0 => rreq_handling_reg_5,
      I1 => rreq_handling_reg_2,
      I2 => invalid_len_event,
      I3 => CO(0),
      I4 => \^could_multi_bursts.sect_handling_reg_0\,
      O => rreq_handling_reg_1
    );
\sect_addr_buf[11]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"1F"
    )
        port map (
      I0 => \^could_multi_bursts.sect_handling_reg_0\,
      I1 => \sect_addr_buf_reg[2]\(0),
      I2 => ap_rst_n,
      O => ap_rst_n_1(0)
    );
\sect_cnt[19]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7775"
    )
        port map (
      I0 => \^could_multi_bursts.sect_handling_reg_0\,
      I1 => rreq_handling_reg_5,
      I2 => fifo_rreq_valid,
      I3 => rreq_handling_reg_2,
      O => rreq_handling_reg_0(0)
    );
\sect_cnt[19]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FD00FFFF"
    )
        port map (
      I0 => \^push\,
      I1 => rreq_handling_reg_3,
      I2 => rreq_handling_reg_4,
      I3 => \could_multi_bursts.sect_handling_reg_8\,
      I4 => rreq_handling_reg_5,
      O => \^could_multi_bursts.sect_handling_reg_0\
    );
\sect_len_buf[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F3C13301FFCD3F0D"
    )
        port map (
      I0 => \^could_multi_bursts.sect_handling_reg_0\,
      I1 => \sect_addr_buf_reg[2]\(0),
      I2 => CO(0),
      I3 => Q(0),
      I4 => \sect_len_buf_reg[9]\(0),
      I5 => \sect_len_buf_reg[9]_0\(0),
      O => \end_addr_buf_reg[2]\
    );
\sect_len_buf[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F333C101FF3FCD0D"
    )
        port map (
      I0 => \^could_multi_bursts.sect_handling_reg_0\,
      I1 => \sect_addr_buf_reg[2]\(0),
      I2 => CO(0),
      I3 => \sect_len_buf_reg[9]\(1),
      I4 => Q(1),
      I5 => \sect_len_buf_reg[9]_0\(1),
      O => \beat_len_buf_reg[1]\
    );
\sect_len_buf[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F333C101FF3FCD0D"
    )
        port map (
      I0 => \^could_multi_bursts.sect_handling_reg_0\,
      I1 => \sect_addr_buf_reg[2]\(0),
      I2 => CO(0),
      I3 => \sect_len_buf_reg[9]\(2),
      I4 => Q(2),
      I5 => \sect_len_buf_reg[9]_0\(2),
      O => \beat_len_buf_reg[2]\
    );
\sect_len_buf[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F3FFC1CD333F010D"
    )
        port map (
      I0 => \^could_multi_bursts.sect_handling_reg_0\,
      I1 => \sect_addr_buf_reg[2]\(0),
      I2 => CO(0),
      I3 => \sect_len_buf_reg[9]_0\(3),
      I4 => Q(3),
      I5 => \sect_len_buf_reg[9]\(3),
      O => \start_addr_buf_reg[5]\
    );
\sect_len_buf[4]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F333C101FF3FCD0D"
    )
        port map (
      I0 => \^could_multi_bursts.sect_handling_reg_0\,
      I1 => \sect_addr_buf_reg[2]\(0),
      I2 => CO(0),
      I3 => \sect_len_buf_reg[9]\(4),
      I4 => Q(4),
      I5 => \sect_len_buf_reg[9]_0\(4),
      O => \beat_len_buf_reg[4]\
    );
\sect_len_buf[5]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F333C101FF3FCD0D"
    )
        port map (
      I0 => \^could_multi_bursts.sect_handling_reg_0\,
      I1 => \sect_addr_buf_reg[2]\(0),
      I2 => CO(0),
      I3 => \sect_len_buf_reg[9]\(5),
      I4 => Q(5),
      I5 => \sect_len_buf_reg[9]_0\(5),
      O => \beat_len_buf_reg[5]\
    );
\sect_len_buf[6]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F3C1FFCD33013F0D"
    )
        port map (
      I0 => \^could_multi_bursts.sect_handling_reg_0\,
      I1 => \sect_addr_buf_reg[2]\(0),
      I2 => CO(0),
      I3 => Q(6),
      I4 => \sect_len_buf_reg[9]_0\(6),
      I5 => \sect_len_buf_reg[9]\(6),
      O => \end_addr_buf_reg[8]\
    );
\sect_len_buf[7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F3FFC1CD333F010D"
    )
        port map (
      I0 => \^could_multi_bursts.sect_handling_reg_0\,
      I1 => \sect_addr_buf_reg[2]\(0),
      I2 => CO(0),
      I3 => \sect_len_buf_reg[9]_0\(7),
      I4 => Q(7),
      I5 => \sect_len_buf_reg[9]\(7),
      O => \start_addr_buf_reg[9]\
    );
\sect_len_buf[8]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F3C13301FFCD3F0D"
    )
        port map (
      I0 => \^could_multi_bursts.sect_handling_reg_0\,
      I1 => \sect_addr_buf_reg[2]\(0),
      I2 => CO(0),
      I3 => Q(8),
      I4 => \sect_len_buf_reg[9]\(8),
      I5 => \sect_len_buf_reg[9]_0\(8),
      O => \end_addr_buf_reg[10]\
    );
\sect_len_buf[9]_i_1__0\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^could_multi_bursts.sect_handling_reg_0\,
      O => \could_multi_bursts.sect_handling_reg_2\
    );
\sect_len_buf[9]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F333C101FF3FCD0D"
    )
        port map (
      I0 => \^could_multi_bursts.sect_handling_reg_0\,
      I1 => \sect_addr_buf_reg[2]\(0),
      I2 => CO(0),
      I3 => \sect_len_buf_reg[9]\(9),
      I4 => Q(9),
      I5 => \sect_len_buf_reg[9]_0\(9),
      O => \beat_len_buf_reg[9]\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity \design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo__parameterized2\ is
  port (
    full_n_reg_0 : out STD_LOGIC;
    empty_n_reg_0 : out STD_LOGIC;
    \ap_CS_fsm_reg[15]\ : out STD_LOGIC_VECTOR ( 1 downto 0 );
    ap_done : out STD_LOGIC;
    ap_clk : in STD_LOGIC;
    SR : in STD_LOGIC_VECTOR ( 0 to 0 );
    Q : in STD_LOGIC_VECTOR ( 2 downto 0 );
    ap_start : in STD_LOGIC;
    ap_rst_n : in STD_LOGIC;
    push : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo__parameterized2\ : entity is "simple_accel_core_gmem_m_axi_fifo";
end \design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo__parameterized2\;

architecture STRUCTURE of \design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo__parameterized2\ is
  signal \data_vld_i_1__2_n_2\ : STD_LOGIC;
  signal data_vld_reg_n_2 : STD_LOGIC;
  signal \empty_n_i_1__2_n_2\ : STD_LOGIC;
  signal \^empty_n_reg_0\ : STD_LOGIC;
  signal \full_n_i_1__4_n_2\ : STD_LOGIC;
  signal full_n_i_2_n_2 : STD_LOGIC;
  signal \full_n_i_3__0_n_2\ : STD_LOGIC;
  signal full_n_i_4_n_2 : STD_LOGIC;
  signal \^full_n_reg_0\ : STD_LOGIC;
  signal \pout[0]_i_1__1_n_2\ : STD_LOGIC;
  signal \pout[1]_i_1_n_2\ : STD_LOGIC;
  signal \pout[2]_i_1_n_2\ : STD_LOGIC;
  signal \pout[2]_i_3_n_2\ : STD_LOGIC;
  signal \pout_reg_n_2_[0]\ : STD_LOGIC;
  signal \pout_reg_n_2_[1]\ : STD_LOGIC;
  signal \pout_reg_n_2_[2]\ : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \ap_CS_fsm[0]_i_1\ : label is "soft_lutpair166";
  attribute SOFT_HLUTNM of \empty_n_i_1__2\ : label is "soft_lutpair168";
  attribute SOFT_HLUTNM of full_n_i_2 : label is "soft_lutpair167";
  attribute SOFT_HLUTNM of \full_n_i_3__0\ : label is "soft_lutpair167";
  attribute SOFT_HLUTNM of int_ap_ready_i_1 : label is "soft_lutpair166";
  attribute SOFT_HLUTNM of \pout[2]_i_3\ : label is "soft_lutpair168";
begin
  empty_n_reg_0 <= \^empty_n_reg_0\;
  full_n_reg_0 <= \^full_n_reg_0\;
\ap_CS_fsm[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8F88"
    )
        port map (
      I0 => \^empty_n_reg_0\,
      I1 => Q(2),
      I2 => ap_start,
      I3 => Q(0),
      O => \ap_CS_fsm_reg[15]\(0)
    );
\ap_CS_fsm[16]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"BA"
    )
        port map (
      I0 => Q(1),
      I1 => \^empty_n_reg_0\,
      I2 => Q(2),
      O => \ap_CS_fsm_reg[15]\(1)
    );
\data_vld_i_1__2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFBAAAAAAAA"
    )
        port map (
      I0 => push,
      I1 => full_n_i_2_n_2,
      I2 => \pout_reg_n_2_[2]\,
      I3 => \pout_reg_n_2_[0]\,
      I4 => \pout_reg_n_2_[1]\,
      I5 => data_vld_reg_n_2,
      O => \data_vld_i_1__2_n_2\
    );
data_vld_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \data_vld_i_1__2_n_2\,
      Q => data_vld_reg_n_2,
      R => SR(0)
    );
\empty_n_i_1__2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"F2"
    )
        port map (
      I0 => \^empty_n_reg_0\,
      I1 => Q(2),
      I2 => data_vld_reg_n_2,
      O => \empty_n_i_1__2_n_2\
    );
empty_n_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \empty_n_i_1__2_n_2\,
      Q => \^empty_n_reg_0\,
      R => SR(0)
    );
\full_n_i_1__4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FBFBFBFBFBFBFBBB"
    )
        port map (
      I0 => full_n_i_2_n_2,
      I1 => ap_rst_n,
      I2 => \^full_n_reg_0\,
      I3 => \full_n_i_3__0_n_2\,
      I4 => full_n_i_4_n_2,
      I5 => \pout_reg_n_2_[2]\,
      O => \full_n_i_1__4_n_2\
    );
full_n_i_2: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8A"
    )
        port map (
      I0 => data_vld_reg_n_2,
      I1 => Q(2),
      I2 => \^empty_n_reg_0\,
      O => full_n_i_2_n_2
    );
\full_n_i_3__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F7FF"
    )
        port map (
      I0 => push,
      I1 => \^empty_n_reg_0\,
      I2 => Q(2),
      I3 => data_vld_reg_n_2,
      O => \full_n_i_3__0_n_2\
    );
full_n_i_4: unisim.vcomponents.LUT2
    generic map(
      INIT => X"7"
    )
        port map (
      I0 => \pout_reg_n_2_[1]\,
      I1 => \pout_reg_n_2_[0]\,
      O => full_n_i_4_n_2
    );
full_n_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \full_n_i_1__4_n_2\,
      Q => \^full_n_reg_0\,
      R => '0'
    );
int_ap_ready_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => Q(2),
      I1 => \^empty_n_reg_0\,
      O => ap_done
    );
\pout[0]_i_1__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6F6F90906F6F9080"
    )
        port map (
      I0 => push,
      I1 => \pout[2]_i_3_n_2\,
      I2 => data_vld_reg_n_2,
      I3 => \pout_reg_n_2_[1]\,
      I4 => \pout_reg_n_2_[0]\,
      I5 => \pout_reg_n_2_[2]\,
      O => \pout[0]_i_1__1_n_2\
    );
\pout[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7F80EF107F80EF00"
    )
        port map (
      I0 => push,
      I1 => \pout[2]_i_3_n_2\,
      I2 => data_vld_reg_n_2,
      I3 => \pout_reg_n_2_[1]\,
      I4 => \pout_reg_n_2_[0]\,
      I5 => \pout_reg_n_2_[2]\,
      O => \pout[1]_i_1_n_2\
    );
\pout[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7FFFFFEF80000000"
    )
        port map (
      I0 => push,
      I1 => \pout[2]_i_3_n_2\,
      I2 => data_vld_reg_n_2,
      I3 => \pout_reg_n_2_[1]\,
      I4 => \pout_reg_n_2_[0]\,
      I5 => \pout_reg_n_2_[2]\,
      O => \pout[2]_i_1_n_2\
    );
\pout[2]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \^empty_n_reg_0\,
      I1 => Q(2),
      O => \pout[2]_i_3_n_2\
    );
\pout_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \pout[0]_i_1__1_n_2\,
      Q => \pout_reg_n_2_[0]\,
      R => SR(0)
    );
\pout_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \pout[1]_i_1_n_2\,
      Q => \pout_reg_n_2_[1]\,
      R => SR(0)
    );
\pout_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \pout[2]_i_1_n_2\,
      Q => \pout_reg_n_2_[2]\,
      R => SR(0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_reg_slice is
  port (
    \state_reg[0]_0\ : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_ready_t_reg_0 : out STD_LOGIC_VECTOR ( 1 downto 0 );
    push : out STD_LOGIC;
    \data_p1_reg[29]_0\ : out STD_LOGIC_VECTOR ( 29 downto 0 );
    SR : in STD_LOGIC_VECTOR ( 0 to 0 );
    ap_clk : in STD_LOGIC;
    rs2f_wreq_ack : in STD_LOGIC;
    Q : in STD_LOGIC_VECTOR ( 2 downto 0 );
    gmem_WREADY : in STD_LOGIC;
    ap_reg_ioackin_gmem_WREADY : in STD_LOGIC;
    \ap_CS_fsm_reg[9]\ : in STD_LOGIC;
    \data_p2_reg[29]_0\ : in STD_LOGIC_VECTOR ( 29 downto 0 )
  );
end design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_reg_slice;

architecture STRUCTURE of design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_reg_slice is
  signal \data_p1[0]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[10]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[11]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[12]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[13]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[14]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[15]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[16]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[17]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[18]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[19]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[1]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[20]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[21]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[22]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[23]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[24]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[25]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[26]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[27]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[28]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[29]_i_2_n_2\ : STD_LOGIC;
  signal \data_p1[2]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[3]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[4]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[5]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[6]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[7]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[8]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[9]_i_1_n_2\ : STD_LOGIC;
  signal data_p2 : STD_LOGIC_VECTOR ( 29 downto 0 );
  signal gmem_AWREADY : STD_LOGIC;
  signal load_p1 : STD_LOGIC;
  signal load_p2 : STD_LOGIC;
  signal \next__0\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal s_ready_t_i_1_n_2 : STD_LOGIC;
  signal state : STD_LOGIC_VECTOR ( 1 to 1 );
  signal \state[0]_i_1_n_2\ : STD_LOGIC;
  signal \state[1]_i_1__0_n_2\ : STD_LOGIC;
  signal \state__0\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \^state_reg[0]_0\ : STD_LOGIC_VECTOR ( 0 to 0 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \FSM_sequential_state[1]_i_1\ : label is "soft_lutpair171";
  attribute FSM_ENCODED_STATES : string;
  attribute FSM_ENCODED_STATES of \FSM_sequential_state_reg[0]\ : label is "ZERO:00,TWO:01,ONE:10";
  attribute FSM_ENCODED_STATES of \FSM_sequential_state_reg[1]\ : label is "ZERO:00,TWO:01,ONE:10";
  attribute SOFT_HLUTNM of \mem_reg[4][0]_srl5_i_1__0\ : label is "soft_lutpair172";
  attribute SOFT_HLUTNM of s_ready_t_i_1 : label is "soft_lutpair171";
  attribute SOFT_HLUTNM of \state[0]_i_1\ : label is "soft_lutpair172";
begin
  \state_reg[0]_0\(0) <= \^state_reg[0]_0\(0);
\FSM_sequential_state[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0602"
    )
        port map (
      I0 => \state__0\(0),
      I1 => \state__0\(1),
      I2 => rs2f_wreq_ack,
      I3 => Q(1),
      O => \next__0\(0)
    );
\FSM_sequential_state[1]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"3E020C30"
    )
        port map (
      I0 => gmem_AWREADY,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => rs2f_wreq_ack,
      I4 => Q(1),
      O => \next__0\(1)
    );
\FSM_sequential_state_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \next__0\(0),
      Q => \state__0\(0),
      R => SR(0)
    );
\FSM_sequential_state_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \next__0\(1),
      Q => \state__0\(1),
      R => SR(0)
    );
\ap_CS_fsm[10]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"888888B8"
    )
        port map (
      I0 => gmem_AWREADY,
      I1 => Q(1),
      I2 => Q(2),
      I3 => gmem_WREADY,
      I4 => ap_reg_ioackin_gmem_WREADY,
      O => s_ready_t_reg_0(1)
    );
\ap_CS_fsm[9]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"88B8"
    )
        port map (
      I0 => \ap_CS_fsm_reg[9]\,
      I1 => Q(0),
      I2 => Q(1),
      I3 => gmem_AWREADY,
      O => s_ready_t_reg_0(0)
    );
\data_p1[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => data_p2(0),
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[29]_0\(0),
      O => \data_p1[0]_i_1_n_2\
    );
\data_p1[10]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => data_p2(10),
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[29]_0\(10),
      O => \data_p1[10]_i_1_n_2\
    );
\data_p1[11]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => data_p2(11),
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[29]_0\(11),
      O => \data_p1[11]_i_1_n_2\
    );
\data_p1[12]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => data_p2(12),
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[29]_0\(12),
      O => \data_p1[12]_i_1_n_2\
    );
\data_p1[13]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => data_p2(13),
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[29]_0\(13),
      O => \data_p1[13]_i_1_n_2\
    );
\data_p1[14]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => data_p2(14),
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[29]_0\(14),
      O => \data_p1[14]_i_1_n_2\
    );
\data_p1[15]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => data_p2(15),
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[29]_0\(15),
      O => \data_p1[15]_i_1_n_2\
    );
\data_p1[16]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => data_p2(16),
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[29]_0\(16),
      O => \data_p1[16]_i_1_n_2\
    );
\data_p1[17]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => data_p2(17),
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[29]_0\(17),
      O => \data_p1[17]_i_1_n_2\
    );
\data_p1[18]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => data_p2(18),
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[29]_0\(18),
      O => \data_p1[18]_i_1_n_2\
    );
\data_p1[19]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => data_p2(19),
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[29]_0\(19),
      O => \data_p1[19]_i_1_n_2\
    );
\data_p1[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => data_p2(1),
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[29]_0\(1),
      O => \data_p1[1]_i_1_n_2\
    );
\data_p1[20]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => data_p2(20),
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[29]_0\(20),
      O => \data_p1[20]_i_1_n_2\
    );
\data_p1[21]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => data_p2(21),
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[29]_0\(21),
      O => \data_p1[21]_i_1_n_2\
    );
\data_p1[22]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => data_p2(22),
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[29]_0\(22),
      O => \data_p1[22]_i_1_n_2\
    );
\data_p1[23]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => data_p2(23),
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[29]_0\(23),
      O => \data_p1[23]_i_1_n_2\
    );
\data_p1[24]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => data_p2(24),
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[29]_0\(24),
      O => \data_p1[24]_i_1_n_2\
    );
\data_p1[25]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => data_p2(25),
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[29]_0\(25),
      O => \data_p1[25]_i_1_n_2\
    );
\data_p1[26]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => data_p2(26),
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[29]_0\(26),
      O => \data_p1[26]_i_1_n_2\
    );
\data_p1[27]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => data_p2(27),
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[29]_0\(27),
      O => \data_p1[27]_i_1_n_2\
    );
\data_p1[28]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => data_p2(28),
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[29]_0\(28),
      O => \data_p1[28]_i_1_n_2\
    );
\data_p1[29]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D0"
    )
        port map (
      I0 => \state__0\(1),
      I1 => rs2f_wreq_ack,
      I2 => Q(1),
      I3 => \state__0\(0),
      O => load_p1
    );
\data_p1[29]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => data_p2(29),
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[29]_0\(29),
      O => \data_p1[29]_i_2_n_2\
    );
\data_p1[2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => data_p2(2),
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[29]_0\(2),
      O => \data_p1[2]_i_1_n_2\
    );
\data_p1[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => data_p2(3),
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[29]_0\(3),
      O => \data_p1[3]_i_1_n_2\
    );
\data_p1[4]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => data_p2(4),
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[29]_0\(4),
      O => \data_p1[4]_i_1_n_2\
    );
\data_p1[5]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => data_p2(5),
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[29]_0\(5),
      O => \data_p1[5]_i_1_n_2\
    );
\data_p1[6]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => data_p2(6),
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[29]_0\(6),
      O => \data_p1[6]_i_1_n_2\
    );
\data_p1[7]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => data_p2(7),
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[29]_0\(7),
      O => \data_p1[7]_i_1_n_2\
    );
\data_p1[8]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => data_p2(8),
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[29]_0\(8),
      O => \data_p1[8]_i_1_n_2\
    );
\data_p1[9]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => data_p2(9),
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[29]_0\(9),
      O => \data_p1[9]_i_1_n_2\
    );
\data_p1_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[0]_i_1_n_2\,
      Q => \data_p1_reg[29]_0\(0),
      R => '0'
    );
\data_p1_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[10]_i_1_n_2\,
      Q => \data_p1_reg[29]_0\(10),
      R => '0'
    );
\data_p1_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[11]_i_1_n_2\,
      Q => \data_p1_reg[29]_0\(11),
      R => '0'
    );
\data_p1_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[12]_i_1_n_2\,
      Q => \data_p1_reg[29]_0\(12),
      R => '0'
    );
\data_p1_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[13]_i_1_n_2\,
      Q => \data_p1_reg[29]_0\(13),
      R => '0'
    );
\data_p1_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[14]_i_1_n_2\,
      Q => \data_p1_reg[29]_0\(14),
      R => '0'
    );
\data_p1_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[15]_i_1_n_2\,
      Q => \data_p1_reg[29]_0\(15),
      R => '0'
    );
\data_p1_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[16]_i_1_n_2\,
      Q => \data_p1_reg[29]_0\(16),
      R => '0'
    );
\data_p1_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[17]_i_1_n_2\,
      Q => \data_p1_reg[29]_0\(17),
      R => '0'
    );
\data_p1_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[18]_i_1_n_2\,
      Q => \data_p1_reg[29]_0\(18),
      R => '0'
    );
\data_p1_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[19]_i_1_n_2\,
      Q => \data_p1_reg[29]_0\(19),
      R => '0'
    );
\data_p1_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[1]_i_1_n_2\,
      Q => \data_p1_reg[29]_0\(1),
      R => '0'
    );
\data_p1_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[20]_i_1_n_2\,
      Q => \data_p1_reg[29]_0\(20),
      R => '0'
    );
\data_p1_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[21]_i_1_n_2\,
      Q => \data_p1_reg[29]_0\(21),
      R => '0'
    );
\data_p1_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[22]_i_1_n_2\,
      Q => \data_p1_reg[29]_0\(22),
      R => '0'
    );
\data_p1_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[23]_i_1_n_2\,
      Q => \data_p1_reg[29]_0\(23),
      R => '0'
    );
\data_p1_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[24]_i_1_n_2\,
      Q => \data_p1_reg[29]_0\(24),
      R => '0'
    );
\data_p1_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[25]_i_1_n_2\,
      Q => \data_p1_reg[29]_0\(25),
      R => '0'
    );
\data_p1_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[26]_i_1_n_2\,
      Q => \data_p1_reg[29]_0\(26),
      R => '0'
    );
\data_p1_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[27]_i_1_n_2\,
      Q => \data_p1_reg[29]_0\(27),
      R => '0'
    );
\data_p1_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[28]_i_1_n_2\,
      Q => \data_p1_reg[29]_0\(28),
      R => '0'
    );
\data_p1_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[29]_i_2_n_2\,
      Q => \data_p1_reg[29]_0\(29),
      R => '0'
    );
\data_p1_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[2]_i_1_n_2\,
      Q => \data_p1_reg[29]_0\(2),
      R => '0'
    );
\data_p1_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[3]_i_1_n_2\,
      Q => \data_p1_reg[29]_0\(3),
      R => '0'
    );
\data_p1_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[4]_i_1_n_2\,
      Q => \data_p1_reg[29]_0\(4),
      R => '0'
    );
\data_p1_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[5]_i_1_n_2\,
      Q => \data_p1_reg[29]_0\(5),
      R => '0'
    );
\data_p1_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[6]_i_1_n_2\,
      Q => \data_p1_reg[29]_0\(6),
      R => '0'
    );
\data_p1_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[7]_i_1_n_2\,
      Q => \data_p1_reg[29]_0\(7),
      R => '0'
    );
\data_p1_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[8]_i_1_n_2\,
      Q => \data_p1_reg[29]_0\(8),
      R => '0'
    );
\data_p1_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[9]_i_1_n_2\,
      Q => \data_p1_reg[29]_0\(9),
      R => '0'
    );
\data_p2[29]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => Q(1),
      I1 => gmem_AWREADY,
      O => load_p2
    );
\data_p2_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[29]_0\(0),
      Q => data_p2(0),
      R => '0'
    );
\data_p2_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[29]_0\(10),
      Q => data_p2(10),
      R => '0'
    );
\data_p2_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[29]_0\(11),
      Q => data_p2(11),
      R => '0'
    );
\data_p2_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[29]_0\(12),
      Q => data_p2(12),
      R => '0'
    );
\data_p2_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[29]_0\(13),
      Q => data_p2(13),
      R => '0'
    );
\data_p2_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[29]_0\(14),
      Q => data_p2(14),
      R => '0'
    );
\data_p2_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[29]_0\(15),
      Q => data_p2(15),
      R => '0'
    );
\data_p2_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[29]_0\(16),
      Q => data_p2(16),
      R => '0'
    );
\data_p2_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[29]_0\(17),
      Q => data_p2(17),
      R => '0'
    );
\data_p2_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[29]_0\(18),
      Q => data_p2(18),
      R => '0'
    );
\data_p2_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[29]_0\(19),
      Q => data_p2(19),
      R => '0'
    );
\data_p2_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[29]_0\(1),
      Q => data_p2(1),
      R => '0'
    );
\data_p2_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[29]_0\(20),
      Q => data_p2(20),
      R => '0'
    );
\data_p2_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[29]_0\(21),
      Q => data_p2(21),
      R => '0'
    );
\data_p2_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[29]_0\(22),
      Q => data_p2(22),
      R => '0'
    );
\data_p2_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[29]_0\(23),
      Q => data_p2(23),
      R => '0'
    );
\data_p2_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[29]_0\(24),
      Q => data_p2(24),
      R => '0'
    );
\data_p2_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[29]_0\(25),
      Q => data_p2(25),
      R => '0'
    );
\data_p2_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[29]_0\(26),
      Q => data_p2(26),
      R => '0'
    );
\data_p2_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[29]_0\(27),
      Q => data_p2(27),
      R => '0'
    );
\data_p2_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[29]_0\(28),
      Q => data_p2(28),
      R => '0'
    );
\data_p2_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[29]_0\(29),
      Q => data_p2(29),
      R => '0'
    );
\data_p2_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[29]_0\(2),
      Q => data_p2(2),
      R => '0'
    );
\data_p2_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[29]_0\(3),
      Q => data_p2(3),
      R => '0'
    );
\data_p2_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[29]_0\(4),
      Q => data_p2(4),
      R => '0'
    );
\data_p2_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[29]_0\(5),
      Q => data_p2(5),
      R => '0'
    );
\data_p2_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[29]_0\(6),
      Q => data_p2(6),
      R => '0'
    );
\data_p2_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[29]_0\(7),
      Q => data_p2(7),
      R => '0'
    );
\data_p2_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[29]_0\(8),
      Q => data_p2(8),
      R => '0'
    );
\data_p2_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[29]_0\(9),
      Q => data_p2(9),
      R => '0'
    );
\mem_reg[4][0]_srl5_i_1__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \^state_reg[0]_0\(0),
      I1 => rs2f_wreq_ack,
      O => push
    );
s_ready_t_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFDF4455"
    )
        port map (
      I0 => \state__0\(1),
      I1 => rs2f_wreq_ack,
      I2 => Q(1),
      I3 => \state__0\(0),
      I4 => gmem_AWREADY,
      O => s_ready_t_i_1_n_2
    );
s_ready_t_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => s_ready_t_i_1_n_2,
      Q => gmem_AWREADY,
      R => SR(0)
    );
\state[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FCCC4C4C"
    )
        port map (
      I0 => rs2f_wreq_ack,
      I1 => \^state_reg[0]_0\(0),
      I2 => state(1),
      I3 => gmem_AWREADY,
      I4 => Q(1),
      O => \state[0]_i_1_n_2\
    );
\state[1]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FF4F"
    )
        port map (
      I0 => Q(1),
      I1 => state(1),
      I2 => \^state_reg[0]_0\(0),
      I3 => rs2f_wreq_ack,
      O => \state[1]_i_1__0_n_2\
    );
\state_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \state[0]_i_1_n_2\,
      Q => \^state_reg[0]_0\(0),
      R => SR(0)
    );
\state_reg[1]\: unisim.vcomponents.FDSE
     port map (
      C => ap_clk,
      CE => '1',
      D => \state[1]_i_1__0_n_2\,
      Q => state(1),
      S => SR(0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_reg_slice_2 is
  port (
    E : out STD_LOGIC_VECTOR ( 0 to 0 );
    push : out STD_LOGIC;
    \data_p1_reg[63]_0\ : out STD_LOGIC_VECTOR ( 61 downto 0 );
    SR : in STD_LOGIC_VECTOR ( 0 to 0 );
    ap_clk : in STD_LOGIC;
    rs2f_rreq_ack : in STD_LOGIC;
    Q : in STD_LOGIC_VECTOR ( 0 to 0 );
    \data_p2_reg[63]_0\ : in STD_LOGIC_VECTOR ( 61 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_reg_slice_2 : entity is "simple_accel_core_gmem_m_axi_reg_slice";
end design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_reg_slice_2;

architecture STRUCTURE of design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_reg_slice_2 is
  signal \^e\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \data_p1[0]_i_1__0_n_2\ : STD_LOGIC;
  signal \data_p1[10]_i_1__0_n_2\ : STD_LOGIC;
  signal \data_p1[11]_i_1__0_n_2\ : STD_LOGIC;
  signal \data_p1[12]_i_1__0_n_2\ : STD_LOGIC;
  signal \data_p1[13]_i_1__0_n_2\ : STD_LOGIC;
  signal \data_p1[14]_i_1__0_n_2\ : STD_LOGIC;
  signal \data_p1[15]_i_1__0_n_2\ : STD_LOGIC;
  signal \data_p1[16]_i_1__0_n_2\ : STD_LOGIC;
  signal \data_p1[17]_i_1__0_n_2\ : STD_LOGIC;
  signal \data_p1[18]_i_1__0_n_2\ : STD_LOGIC;
  signal \data_p1[19]_i_1__0_n_2\ : STD_LOGIC;
  signal \data_p1[1]_i_1__0_n_2\ : STD_LOGIC;
  signal \data_p1[20]_i_1__0_n_2\ : STD_LOGIC;
  signal \data_p1[21]_i_1__0_n_2\ : STD_LOGIC;
  signal \data_p1[22]_i_1__0_n_2\ : STD_LOGIC;
  signal \data_p1[23]_i_1__0_n_2\ : STD_LOGIC;
  signal \data_p1[24]_i_1__0_n_2\ : STD_LOGIC;
  signal \data_p1[25]_i_1__0_n_2\ : STD_LOGIC;
  signal \data_p1[26]_i_1__0_n_2\ : STD_LOGIC;
  signal \data_p1[27]_i_1__0_n_2\ : STD_LOGIC;
  signal \data_p1[28]_i_1__0_n_2\ : STD_LOGIC;
  signal \data_p1[29]_i_1__0_n_2\ : STD_LOGIC;
  signal \data_p1[2]_i_1__0_n_2\ : STD_LOGIC;
  signal \data_p1[32]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[33]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[34]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[35]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[36]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[37]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[38]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[39]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[3]_i_1__0_n_2\ : STD_LOGIC;
  signal \data_p1[40]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[41]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[42]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[43]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[44]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[45]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[46]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[47]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[48]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[49]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[4]_i_1__0_n_2\ : STD_LOGIC;
  signal \data_p1[50]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[51]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[52]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[53]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[54]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[55]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[56]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[57]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[58]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[59]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[5]_i_1__0_n_2\ : STD_LOGIC;
  signal \data_p1[60]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[61]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[62]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[63]_i_2_n_2\ : STD_LOGIC;
  signal \data_p1[6]_i_1__0_n_2\ : STD_LOGIC;
  signal \data_p1[7]_i_1__0_n_2\ : STD_LOGIC;
  signal \data_p1[8]_i_1__0_n_2\ : STD_LOGIC;
  signal \data_p1[9]_i_1__0_n_2\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[0]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[10]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[11]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[12]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[13]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[14]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[15]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[16]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[17]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[18]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[19]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[1]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[20]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[21]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[22]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[23]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[24]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[25]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[26]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[27]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[28]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[29]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[2]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[32]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[33]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[34]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[35]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[36]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[37]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[38]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[39]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[3]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[40]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[41]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[42]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[43]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[44]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[45]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[46]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[47]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[48]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[49]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[4]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[50]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[51]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[52]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[53]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[54]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[55]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[56]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[57]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[58]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[59]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[5]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[60]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[61]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[62]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[63]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[6]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[7]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[8]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[9]\ : STD_LOGIC;
  signal gmem_ARREADY : STD_LOGIC;
  signal load_p1 : STD_LOGIC;
  signal \next__0\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal rs2f_rreq_valid : STD_LOGIC;
  signal \s_ready_t_i_1__0_n_2\ : STD_LOGIC;
  signal state : STD_LOGIC_VECTOR ( 1 to 1 );
  signal \state[0]_i_1__0_n_2\ : STD_LOGIC;
  signal \state[1]_i_1__1_n_2\ : STD_LOGIC;
  signal \state__0\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \FSM_sequential_state[1]_i_1__0\ : label is "soft_lutpair86";
  attribute FSM_ENCODED_STATES : string;
  attribute FSM_ENCODED_STATES of \FSM_sequential_state_reg[0]\ : label is "ZERO:00,TWO:01,ONE:10";
  attribute FSM_ENCODED_STATES of \FSM_sequential_state_reg[1]\ : label is "ZERO:00,TWO:01,ONE:10";
  attribute SOFT_HLUTNM of \mem_reg[4][0]_srl5_i_1__1\ : label is "soft_lutpair87";
  attribute SOFT_HLUTNM of \s_ready_t_i_1__0\ : label is "soft_lutpair86";
  attribute SOFT_HLUTNM of \state[0]_i_1__0\ : label is "soft_lutpair87";
begin
  E(0) <= \^e\(0);
\FSM_sequential_state[0]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0602"
    )
        port map (
      I0 => \state__0\(0),
      I1 => \state__0\(1),
      I2 => rs2f_rreq_ack,
      I3 => Q(0),
      O => \next__0\(0)
    );
\FSM_sequential_state[1]_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"3E020C30"
    )
        port map (
      I0 => gmem_ARREADY,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => rs2f_rreq_ack,
      I4 => Q(0),
      O => \next__0\(1)
    );
\FSM_sequential_state_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \next__0\(0),
      Q => \state__0\(0),
      R => SR(0)
    );
\FSM_sequential_state_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \next__0\(1),
      Q => \state__0\(1),
      R => SR(0)
    );
\data_p1[0]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[0]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(0),
      O => \data_p1[0]_i_1__0_n_2\
    );
\data_p1[10]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[10]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(10),
      O => \data_p1[10]_i_1__0_n_2\
    );
\data_p1[11]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[11]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(11),
      O => \data_p1[11]_i_1__0_n_2\
    );
\data_p1[12]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[12]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(12),
      O => \data_p1[12]_i_1__0_n_2\
    );
\data_p1[13]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[13]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(13),
      O => \data_p1[13]_i_1__0_n_2\
    );
\data_p1[14]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[14]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(14),
      O => \data_p1[14]_i_1__0_n_2\
    );
\data_p1[15]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[15]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(15),
      O => \data_p1[15]_i_1__0_n_2\
    );
\data_p1[16]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[16]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(16),
      O => \data_p1[16]_i_1__0_n_2\
    );
\data_p1[17]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[17]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(17),
      O => \data_p1[17]_i_1__0_n_2\
    );
\data_p1[18]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[18]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(18),
      O => \data_p1[18]_i_1__0_n_2\
    );
\data_p1[19]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[19]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(19),
      O => \data_p1[19]_i_1__0_n_2\
    );
\data_p1[1]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[1]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(1),
      O => \data_p1[1]_i_1__0_n_2\
    );
\data_p1[20]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[20]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(20),
      O => \data_p1[20]_i_1__0_n_2\
    );
\data_p1[21]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[21]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(21),
      O => \data_p1[21]_i_1__0_n_2\
    );
\data_p1[22]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[22]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(22),
      O => \data_p1[22]_i_1__0_n_2\
    );
\data_p1[23]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[23]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(23),
      O => \data_p1[23]_i_1__0_n_2\
    );
\data_p1[24]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[24]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(24),
      O => \data_p1[24]_i_1__0_n_2\
    );
\data_p1[25]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[25]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(25),
      O => \data_p1[25]_i_1__0_n_2\
    );
\data_p1[26]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[26]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(26),
      O => \data_p1[26]_i_1__0_n_2\
    );
\data_p1[27]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[27]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(27),
      O => \data_p1[27]_i_1__0_n_2\
    );
\data_p1[28]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[28]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(28),
      O => \data_p1[28]_i_1__0_n_2\
    );
\data_p1[29]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[29]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(29),
      O => \data_p1[29]_i_1__0_n_2\
    );
\data_p1[2]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[2]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(2),
      O => \data_p1[2]_i_1__0_n_2\
    );
\data_p1[32]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[32]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(30),
      O => \data_p1[32]_i_1_n_2\
    );
\data_p1[33]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[33]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(31),
      O => \data_p1[33]_i_1_n_2\
    );
\data_p1[34]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[34]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(32),
      O => \data_p1[34]_i_1_n_2\
    );
\data_p1[35]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[35]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(33),
      O => \data_p1[35]_i_1_n_2\
    );
\data_p1[36]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[36]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(34),
      O => \data_p1[36]_i_1_n_2\
    );
\data_p1[37]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[37]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(35),
      O => \data_p1[37]_i_1_n_2\
    );
\data_p1[38]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[38]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(36),
      O => \data_p1[38]_i_1_n_2\
    );
\data_p1[39]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[39]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(37),
      O => \data_p1[39]_i_1_n_2\
    );
\data_p1[3]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[3]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(3),
      O => \data_p1[3]_i_1__0_n_2\
    );
\data_p1[40]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[40]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(38),
      O => \data_p1[40]_i_1_n_2\
    );
\data_p1[41]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[41]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(39),
      O => \data_p1[41]_i_1_n_2\
    );
\data_p1[42]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[42]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(40),
      O => \data_p1[42]_i_1_n_2\
    );
\data_p1[43]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[43]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(41),
      O => \data_p1[43]_i_1_n_2\
    );
\data_p1[44]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[44]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(42),
      O => \data_p1[44]_i_1_n_2\
    );
\data_p1[45]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[45]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(43),
      O => \data_p1[45]_i_1_n_2\
    );
\data_p1[46]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[46]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(44),
      O => \data_p1[46]_i_1_n_2\
    );
\data_p1[47]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[47]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(45),
      O => \data_p1[47]_i_1_n_2\
    );
\data_p1[48]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[48]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(46),
      O => \data_p1[48]_i_1_n_2\
    );
\data_p1[49]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[49]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(47),
      O => \data_p1[49]_i_1_n_2\
    );
\data_p1[4]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[4]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(4),
      O => \data_p1[4]_i_1__0_n_2\
    );
\data_p1[50]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[50]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(48),
      O => \data_p1[50]_i_1_n_2\
    );
\data_p1[51]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[51]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(49),
      O => \data_p1[51]_i_1_n_2\
    );
\data_p1[52]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[52]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(50),
      O => \data_p1[52]_i_1_n_2\
    );
\data_p1[53]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[53]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(51),
      O => \data_p1[53]_i_1_n_2\
    );
\data_p1[54]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[54]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(52),
      O => \data_p1[54]_i_1_n_2\
    );
\data_p1[55]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[55]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(53),
      O => \data_p1[55]_i_1_n_2\
    );
\data_p1[56]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[56]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(54),
      O => \data_p1[56]_i_1_n_2\
    );
\data_p1[57]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[57]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(55),
      O => \data_p1[57]_i_1_n_2\
    );
\data_p1[58]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[58]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(56),
      O => \data_p1[58]_i_1_n_2\
    );
\data_p1[59]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[59]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(57),
      O => \data_p1[59]_i_1_n_2\
    );
\data_p1[5]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[5]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(5),
      O => \data_p1[5]_i_1__0_n_2\
    );
\data_p1[60]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[60]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(58),
      O => \data_p1[60]_i_1_n_2\
    );
\data_p1[61]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[61]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(59),
      O => \data_p1[61]_i_1_n_2\
    );
\data_p1[62]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[62]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(60),
      O => \data_p1[62]_i_1_n_2\
    );
\data_p1[63]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4E04"
    )
        port map (
      I0 => \state__0\(0),
      I1 => Q(0),
      I2 => \state__0\(1),
      I3 => rs2f_rreq_ack,
      O => load_p1
    );
\data_p1[63]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[63]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(61),
      O => \data_p1[63]_i_2_n_2\
    );
\data_p1[6]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[6]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(6),
      O => \data_p1[6]_i_1__0_n_2\
    );
\data_p1[7]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[7]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(7),
      O => \data_p1[7]_i_1__0_n_2\
    );
\data_p1[8]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[8]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(8),
      O => \data_p1[8]_i_1__0_n_2\
    );
\data_p1[9]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => \data_p2_reg_n_2_[9]\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \data_p2_reg[63]_0\(9),
      O => \data_p1[9]_i_1__0_n_2\
    );
\data_p1_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[0]_i_1__0_n_2\,
      Q => \data_p1_reg[63]_0\(0),
      R => '0'
    );
\data_p1_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[10]_i_1__0_n_2\,
      Q => \data_p1_reg[63]_0\(10),
      R => '0'
    );
\data_p1_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[11]_i_1__0_n_2\,
      Q => \data_p1_reg[63]_0\(11),
      R => '0'
    );
\data_p1_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[12]_i_1__0_n_2\,
      Q => \data_p1_reg[63]_0\(12),
      R => '0'
    );
\data_p1_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[13]_i_1__0_n_2\,
      Q => \data_p1_reg[63]_0\(13),
      R => '0'
    );
\data_p1_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[14]_i_1__0_n_2\,
      Q => \data_p1_reg[63]_0\(14),
      R => '0'
    );
\data_p1_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[15]_i_1__0_n_2\,
      Q => \data_p1_reg[63]_0\(15),
      R => '0'
    );
\data_p1_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[16]_i_1__0_n_2\,
      Q => \data_p1_reg[63]_0\(16),
      R => '0'
    );
\data_p1_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[17]_i_1__0_n_2\,
      Q => \data_p1_reg[63]_0\(17),
      R => '0'
    );
\data_p1_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[18]_i_1__0_n_2\,
      Q => \data_p1_reg[63]_0\(18),
      R => '0'
    );
\data_p1_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[19]_i_1__0_n_2\,
      Q => \data_p1_reg[63]_0\(19),
      R => '0'
    );
\data_p1_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[1]_i_1__0_n_2\,
      Q => \data_p1_reg[63]_0\(1),
      R => '0'
    );
\data_p1_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[20]_i_1__0_n_2\,
      Q => \data_p1_reg[63]_0\(20),
      R => '0'
    );
\data_p1_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[21]_i_1__0_n_2\,
      Q => \data_p1_reg[63]_0\(21),
      R => '0'
    );
\data_p1_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[22]_i_1__0_n_2\,
      Q => \data_p1_reg[63]_0\(22),
      R => '0'
    );
\data_p1_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[23]_i_1__0_n_2\,
      Q => \data_p1_reg[63]_0\(23),
      R => '0'
    );
\data_p1_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[24]_i_1__0_n_2\,
      Q => \data_p1_reg[63]_0\(24),
      R => '0'
    );
\data_p1_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[25]_i_1__0_n_2\,
      Q => \data_p1_reg[63]_0\(25),
      R => '0'
    );
\data_p1_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[26]_i_1__0_n_2\,
      Q => \data_p1_reg[63]_0\(26),
      R => '0'
    );
\data_p1_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[27]_i_1__0_n_2\,
      Q => \data_p1_reg[63]_0\(27),
      R => '0'
    );
\data_p1_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[28]_i_1__0_n_2\,
      Q => \data_p1_reg[63]_0\(28),
      R => '0'
    );
\data_p1_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[29]_i_1__0_n_2\,
      Q => \data_p1_reg[63]_0\(29),
      R => '0'
    );
\data_p1_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[2]_i_1__0_n_2\,
      Q => \data_p1_reg[63]_0\(2),
      R => '0'
    );
\data_p1_reg[32]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[32]_i_1_n_2\,
      Q => \data_p1_reg[63]_0\(30),
      R => '0'
    );
\data_p1_reg[33]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[33]_i_1_n_2\,
      Q => \data_p1_reg[63]_0\(31),
      R => '0'
    );
\data_p1_reg[34]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[34]_i_1_n_2\,
      Q => \data_p1_reg[63]_0\(32),
      R => '0'
    );
\data_p1_reg[35]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[35]_i_1_n_2\,
      Q => \data_p1_reg[63]_0\(33),
      R => '0'
    );
\data_p1_reg[36]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[36]_i_1_n_2\,
      Q => \data_p1_reg[63]_0\(34),
      R => '0'
    );
\data_p1_reg[37]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[37]_i_1_n_2\,
      Q => \data_p1_reg[63]_0\(35),
      R => '0'
    );
\data_p1_reg[38]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[38]_i_1_n_2\,
      Q => \data_p1_reg[63]_0\(36),
      R => '0'
    );
\data_p1_reg[39]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[39]_i_1_n_2\,
      Q => \data_p1_reg[63]_0\(37),
      R => '0'
    );
\data_p1_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[3]_i_1__0_n_2\,
      Q => \data_p1_reg[63]_0\(3),
      R => '0'
    );
\data_p1_reg[40]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[40]_i_1_n_2\,
      Q => \data_p1_reg[63]_0\(38),
      R => '0'
    );
\data_p1_reg[41]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[41]_i_1_n_2\,
      Q => \data_p1_reg[63]_0\(39),
      R => '0'
    );
\data_p1_reg[42]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[42]_i_1_n_2\,
      Q => \data_p1_reg[63]_0\(40),
      R => '0'
    );
\data_p1_reg[43]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[43]_i_1_n_2\,
      Q => \data_p1_reg[63]_0\(41),
      R => '0'
    );
\data_p1_reg[44]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[44]_i_1_n_2\,
      Q => \data_p1_reg[63]_0\(42),
      R => '0'
    );
\data_p1_reg[45]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[45]_i_1_n_2\,
      Q => \data_p1_reg[63]_0\(43),
      R => '0'
    );
\data_p1_reg[46]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[46]_i_1_n_2\,
      Q => \data_p1_reg[63]_0\(44),
      R => '0'
    );
\data_p1_reg[47]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[47]_i_1_n_2\,
      Q => \data_p1_reg[63]_0\(45),
      R => '0'
    );
\data_p1_reg[48]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[48]_i_1_n_2\,
      Q => \data_p1_reg[63]_0\(46),
      R => '0'
    );
\data_p1_reg[49]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[49]_i_1_n_2\,
      Q => \data_p1_reg[63]_0\(47),
      R => '0'
    );
\data_p1_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[4]_i_1__0_n_2\,
      Q => \data_p1_reg[63]_0\(4),
      R => '0'
    );
\data_p1_reg[50]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[50]_i_1_n_2\,
      Q => \data_p1_reg[63]_0\(48),
      R => '0'
    );
\data_p1_reg[51]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[51]_i_1_n_2\,
      Q => \data_p1_reg[63]_0\(49),
      R => '0'
    );
\data_p1_reg[52]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[52]_i_1_n_2\,
      Q => \data_p1_reg[63]_0\(50),
      R => '0'
    );
\data_p1_reg[53]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[53]_i_1_n_2\,
      Q => \data_p1_reg[63]_0\(51),
      R => '0'
    );
\data_p1_reg[54]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[54]_i_1_n_2\,
      Q => \data_p1_reg[63]_0\(52),
      R => '0'
    );
\data_p1_reg[55]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[55]_i_1_n_2\,
      Q => \data_p1_reg[63]_0\(53),
      R => '0'
    );
\data_p1_reg[56]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[56]_i_1_n_2\,
      Q => \data_p1_reg[63]_0\(54),
      R => '0'
    );
\data_p1_reg[57]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[57]_i_1_n_2\,
      Q => \data_p1_reg[63]_0\(55),
      R => '0'
    );
\data_p1_reg[58]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[58]_i_1_n_2\,
      Q => \data_p1_reg[63]_0\(56),
      R => '0'
    );
\data_p1_reg[59]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[59]_i_1_n_2\,
      Q => \data_p1_reg[63]_0\(57),
      R => '0'
    );
\data_p1_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[5]_i_1__0_n_2\,
      Q => \data_p1_reg[63]_0\(5),
      R => '0'
    );
\data_p1_reg[60]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[60]_i_1_n_2\,
      Q => \data_p1_reg[63]_0\(58),
      R => '0'
    );
\data_p1_reg[61]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[61]_i_1_n_2\,
      Q => \data_p1_reg[63]_0\(59),
      R => '0'
    );
\data_p1_reg[62]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[62]_i_1_n_2\,
      Q => \data_p1_reg[63]_0\(60),
      R => '0'
    );
\data_p1_reg[63]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[63]_i_2_n_2\,
      Q => \data_p1_reg[63]_0\(61),
      R => '0'
    );
\data_p1_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[6]_i_1__0_n_2\,
      Q => \data_p1_reg[63]_0\(6),
      R => '0'
    );
\data_p1_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[7]_i_1__0_n_2\,
      Q => \data_p1_reg[63]_0\(7),
      R => '0'
    );
\data_p1_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[8]_i_1__0_n_2\,
      Q => \data_p1_reg[63]_0\(8),
      R => '0'
    );
\data_p1_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[9]_i_1__0_n_2\,
      Q => \data_p1_reg[63]_0\(9),
      R => '0'
    );
\data_p2[63]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => Q(0),
      I1 => gmem_ARREADY,
      O => \^e\(0)
    );
\data_p2_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(0),
      Q => \data_p2_reg_n_2_[0]\,
      R => '0'
    );
\data_p2_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(10),
      Q => \data_p2_reg_n_2_[10]\,
      R => '0'
    );
\data_p2_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(11),
      Q => \data_p2_reg_n_2_[11]\,
      R => '0'
    );
\data_p2_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(12),
      Q => \data_p2_reg_n_2_[12]\,
      R => '0'
    );
\data_p2_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(13),
      Q => \data_p2_reg_n_2_[13]\,
      R => '0'
    );
\data_p2_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(14),
      Q => \data_p2_reg_n_2_[14]\,
      R => '0'
    );
\data_p2_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(15),
      Q => \data_p2_reg_n_2_[15]\,
      R => '0'
    );
\data_p2_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(16),
      Q => \data_p2_reg_n_2_[16]\,
      R => '0'
    );
\data_p2_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(17),
      Q => \data_p2_reg_n_2_[17]\,
      R => '0'
    );
\data_p2_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(18),
      Q => \data_p2_reg_n_2_[18]\,
      R => '0'
    );
\data_p2_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(19),
      Q => \data_p2_reg_n_2_[19]\,
      R => '0'
    );
\data_p2_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(1),
      Q => \data_p2_reg_n_2_[1]\,
      R => '0'
    );
\data_p2_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(20),
      Q => \data_p2_reg_n_2_[20]\,
      R => '0'
    );
\data_p2_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(21),
      Q => \data_p2_reg_n_2_[21]\,
      R => '0'
    );
\data_p2_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(22),
      Q => \data_p2_reg_n_2_[22]\,
      R => '0'
    );
\data_p2_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(23),
      Q => \data_p2_reg_n_2_[23]\,
      R => '0'
    );
\data_p2_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(24),
      Q => \data_p2_reg_n_2_[24]\,
      R => '0'
    );
\data_p2_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(25),
      Q => \data_p2_reg_n_2_[25]\,
      R => '0'
    );
\data_p2_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(26),
      Q => \data_p2_reg_n_2_[26]\,
      R => '0'
    );
\data_p2_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(27),
      Q => \data_p2_reg_n_2_[27]\,
      R => '0'
    );
\data_p2_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(28),
      Q => \data_p2_reg_n_2_[28]\,
      R => '0'
    );
\data_p2_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(29),
      Q => \data_p2_reg_n_2_[29]\,
      R => '0'
    );
\data_p2_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(2),
      Q => \data_p2_reg_n_2_[2]\,
      R => '0'
    );
\data_p2_reg[32]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(30),
      Q => \data_p2_reg_n_2_[32]\,
      R => '0'
    );
\data_p2_reg[33]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(31),
      Q => \data_p2_reg_n_2_[33]\,
      R => '0'
    );
\data_p2_reg[34]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(32),
      Q => \data_p2_reg_n_2_[34]\,
      R => '0'
    );
\data_p2_reg[35]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(33),
      Q => \data_p2_reg_n_2_[35]\,
      R => '0'
    );
\data_p2_reg[36]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(34),
      Q => \data_p2_reg_n_2_[36]\,
      R => '0'
    );
\data_p2_reg[37]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(35),
      Q => \data_p2_reg_n_2_[37]\,
      R => '0'
    );
\data_p2_reg[38]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(36),
      Q => \data_p2_reg_n_2_[38]\,
      R => '0'
    );
\data_p2_reg[39]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(37),
      Q => \data_p2_reg_n_2_[39]\,
      R => '0'
    );
\data_p2_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(3),
      Q => \data_p2_reg_n_2_[3]\,
      R => '0'
    );
\data_p2_reg[40]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(38),
      Q => \data_p2_reg_n_2_[40]\,
      R => '0'
    );
\data_p2_reg[41]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(39),
      Q => \data_p2_reg_n_2_[41]\,
      R => '0'
    );
\data_p2_reg[42]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(40),
      Q => \data_p2_reg_n_2_[42]\,
      R => '0'
    );
\data_p2_reg[43]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(41),
      Q => \data_p2_reg_n_2_[43]\,
      R => '0'
    );
\data_p2_reg[44]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(42),
      Q => \data_p2_reg_n_2_[44]\,
      R => '0'
    );
\data_p2_reg[45]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(43),
      Q => \data_p2_reg_n_2_[45]\,
      R => '0'
    );
\data_p2_reg[46]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(44),
      Q => \data_p2_reg_n_2_[46]\,
      R => '0'
    );
\data_p2_reg[47]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(45),
      Q => \data_p2_reg_n_2_[47]\,
      R => '0'
    );
\data_p2_reg[48]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(46),
      Q => \data_p2_reg_n_2_[48]\,
      R => '0'
    );
\data_p2_reg[49]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(47),
      Q => \data_p2_reg_n_2_[49]\,
      R => '0'
    );
\data_p2_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(4),
      Q => \data_p2_reg_n_2_[4]\,
      R => '0'
    );
\data_p2_reg[50]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(48),
      Q => \data_p2_reg_n_2_[50]\,
      R => '0'
    );
\data_p2_reg[51]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(49),
      Q => \data_p2_reg_n_2_[51]\,
      R => '0'
    );
\data_p2_reg[52]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(50),
      Q => \data_p2_reg_n_2_[52]\,
      R => '0'
    );
\data_p2_reg[53]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(51),
      Q => \data_p2_reg_n_2_[53]\,
      R => '0'
    );
\data_p2_reg[54]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(52),
      Q => \data_p2_reg_n_2_[54]\,
      R => '0'
    );
\data_p2_reg[55]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(53),
      Q => \data_p2_reg_n_2_[55]\,
      R => '0'
    );
\data_p2_reg[56]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(54),
      Q => \data_p2_reg_n_2_[56]\,
      R => '0'
    );
\data_p2_reg[57]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(55),
      Q => \data_p2_reg_n_2_[57]\,
      R => '0'
    );
\data_p2_reg[58]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(56),
      Q => \data_p2_reg_n_2_[58]\,
      R => '0'
    );
\data_p2_reg[59]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(57),
      Q => \data_p2_reg_n_2_[59]\,
      R => '0'
    );
\data_p2_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(5),
      Q => \data_p2_reg_n_2_[5]\,
      R => '0'
    );
\data_p2_reg[60]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(58),
      Q => \data_p2_reg_n_2_[60]\,
      R => '0'
    );
\data_p2_reg[61]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(59),
      Q => \data_p2_reg_n_2_[61]\,
      R => '0'
    );
\data_p2_reg[62]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(60),
      Q => \data_p2_reg_n_2_[62]\,
      R => '0'
    );
\data_p2_reg[63]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(61),
      Q => \data_p2_reg_n_2_[63]\,
      R => '0'
    );
\data_p2_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(6),
      Q => \data_p2_reg_n_2_[6]\,
      R => '0'
    );
\data_p2_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(7),
      Q => \data_p2_reg_n_2_[7]\,
      R => '0'
    );
\data_p2_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(8),
      Q => \data_p2_reg_n_2_[8]\,
      R => '0'
    );
\data_p2_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => \^e\(0),
      D => \data_p2_reg[63]_0\(9),
      Q => \data_p2_reg_n_2_[9]\,
      R => '0'
    );
\mem_reg[4][0]_srl5_i_1__1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => rs2f_rreq_valid,
      I1 => rs2f_rreq_ack,
      O => push
    );
\s_ready_t_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFBF0F05"
    )
        port map (
      I0 => \state__0\(0),
      I1 => Q(0),
      I2 => \state__0\(1),
      I3 => rs2f_rreq_ack,
      I4 => gmem_ARREADY,
      O => \s_ready_t_i_1__0_n_2\
    );
s_ready_t_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \s_ready_t_i_1__0_n_2\,
      Q => gmem_ARREADY,
      R => SR(0)
    );
\state[0]_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FCCC4C4C"
    )
        port map (
      I0 => rs2f_rreq_ack,
      I1 => rs2f_rreq_valid,
      I2 => state(1),
      I3 => gmem_ARREADY,
      I4 => Q(0),
      O => \state[0]_i_1__0_n_2\
    );
\state[1]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FF4F"
    )
        port map (
      I0 => Q(0),
      I1 => state(1),
      I2 => rs2f_rreq_valid,
      I3 => rs2f_rreq_ack,
      O => \state[1]_i_1__1_n_2\
    );
\state_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \state[0]_i_1__0_n_2\,
      Q => rs2f_rreq_valid,
      R => SR(0)
    );
\state_reg[1]\: unisim.vcomponents.FDSE
     port map (
      C => ap_clk,
      CE => '1',
      D => \state[1]_i_1__1_n_2\,
      Q => state(1),
      S => SR(0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity \design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_reg_slice__parameterized0\ is
  port (
    rdata_ack_t : out STD_LOGIC;
    \state_reg[0]_0\ : out STD_LOGIC;
    \ap_CS_fsm_reg[7]\ : out STD_LOGIC;
    i_reg_137 : out STD_LOGIC;
    i_reg_1370 : out STD_LOGIC;
    \state_reg[0]_1\ : out STD_LOGIC_VECTOR ( 0 to 0 );
    sum_reg_125 : out STD_LOGIC;
    sum_reg_1250 : out STD_LOGIC;
    \ap_CS_fsm_reg[8]\ : out STD_LOGIC;
    \ap_CS_fsm_reg[8]_0\ : out STD_LOGIC;
    \ap_CS_fsm_reg[8]_1\ : out STD_LOGIC;
    \data_p1_reg[31]_0\ : out STD_LOGIC_VECTOR ( 31 downto 0 );
    SR : in STD_LOGIC_VECTOR ( 0 to 0 );
    ap_clk : in STD_LOGIC;
    CO : in STD_LOGIC_VECTOR ( 0 to 0 );
    ap_enable_reg_pp0_iter1_reg : in STD_LOGIC;
    ap_enable_reg_pp0_iter1_reg_0 : in STD_LOGIC;
    ap_enable_reg_pp0_iter0 : in STD_LOGIC;
    ap_rst_n : in STD_LOGIC;
    Q : in STD_LOGIC_VECTOR ( 1 downto 0 );
    ap_enable_reg_pp0_iter2_reg : in STD_LOGIC;
    s_ready_t_reg_0 : in STD_LOGIC;
    exitcond_reg_251_pp0_iter1_reg : in STD_LOGIC;
    \data_p2_reg[31]_0\ : in STD_LOGIC_VECTOR ( 31 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_reg_slice__parameterized0\ : entity is "simple_accel_core_gmem_m_axi_reg_slice";
end \design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_reg_slice__parameterized0\;

architecture STRUCTURE of \design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_reg_slice__parameterized0\ is
  signal \FSM_sequential_state[1]_i_2_n_2\ : STD_LOGIC;
  signal ap_enable_reg_pp0_iter0_i_2_n_2 : STD_LOGIC;
  signal \data_p1[0]_i_1__1_n_2\ : STD_LOGIC;
  signal \data_p1[10]_i_1__1_n_2\ : STD_LOGIC;
  signal \data_p1[11]_i_1__1_n_2\ : STD_LOGIC;
  signal \data_p1[12]_i_1__1_n_2\ : STD_LOGIC;
  signal \data_p1[13]_i_1__1_n_2\ : STD_LOGIC;
  signal \data_p1[14]_i_1__1_n_2\ : STD_LOGIC;
  signal \data_p1[15]_i_1__1_n_2\ : STD_LOGIC;
  signal \data_p1[16]_i_1__1_n_2\ : STD_LOGIC;
  signal \data_p1[17]_i_1__1_n_2\ : STD_LOGIC;
  signal \data_p1[18]_i_1__1_n_2\ : STD_LOGIC;
  signal \data_p1[19]_i_1__1_n_2\ : STD_LOGIC;
  signal \data_p1[1]_i_1__1_n_2\ : STD_LOGIC;
  signal \data_p1[20]_i_1__1_n_2\ : STD_LOGIC;
  signal \data_p1[21]_i_1__1_n_2\ : STD_LOGIC;
  signal \data_p1[22]_i_1__1_n_2\ : STD_LOGIC;
  signal \data_p1[23]_i_1__1_n_2\ : STD_LOGIC;
  signal \data_p1[24]_i_1__1_n_2\ : STD_LOGIC;
  signal \data_p1[25]_i_1__1_n_2\ : STD_LOGIC;
  signal \data_p1[26]_i_1__1_n_2\ : STD_LOGIC;
  signal \data_p1[27]_i_1__1_n_2\ : STD_LOGIC;
  signal \data_p1[28]_i_1__1_n_2\ : STD_LOGIC;
  signal \data_p1[29]_i_1__1_n_2\ : STD_LOGIC;
  signal \data_p1[2]_i_1__1_n_2\ : STD_LOGIC;
  signal \data_p1[30]_i_1_n_2\ : STD_LOGIC;
  signal \data_p1[31]_i_2_n_2\ : STD_LOGIC;
  signal \data_p1[3]_i_1__1_n_2\ : STD_LOGIC;
  signal \data_p1[4]_i_1__1_n_2\ : STD_LOGIC;
  signal \data_p1[5]_i_1__1_n_2\ : STD_LOGIC;
  signal \data_p1[6]_i_1__1_n_2\ : STD_LOGIC;
  signal \data_p1[7]_i_1__1_n_2\ : STD_LOGIC;
  signal \data_p1[8]_i_1__1_n_2\ : STD_LOGIC;
  signal \data_p1[9]_i_1__1_n_2\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[0]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[10]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[11]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[12]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[13]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[14]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[15]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[16]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[17]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[18]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[19]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[1]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[20]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[21]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[22]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[23]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[24]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[25]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[26]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[27]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[28]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[29]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[2]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[30]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[31]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[3]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[4]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[5]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[6]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[7]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[8]\ : STD_LOGIC;
  signal \data_p2_reg_n_2_[9]\ : STD_LOGIC;
  signal gmem_RVALID : STD_LOGIC;
  signal \^i_reg_1370\ : STD_LOGIC;
  signal load_p1 : STD_LOGIC;
  signal load_p2 : STD_LOGIC;
  signal \next__0\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \^rdata_ack_t\ : STD_LOGIC;
  signal \s_ready_t_i_1__1_n_2\ : STD_LOGIC;
  signal state : STD_LOGIC_VECTOR ( 1 to 1 );
  signal \state[0]_i_1__1_n_2\ : STD_LOGIC;
  signal \state[1]_i_1_n_2\ : STD_LOGIC;
  signal \state__0\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \FSM_sequential_state[1]_i_1__1\ : label is "soft_lutpair85";
  attribute SOFT_HLUTNM of \FSM_sequential_state[1]_i_2\ : label is "soft_lutpair82";
  attribute FSM_ENCODED_STATES : string;
  attribute FSM_ENCODED_STATES of \FSM_sequential_state_reg[0]\ : label is "ZERO:00,TWO:01,ONE:10";
  attribute FSM_ENCODED_STATES of \FSM_sequential_state_reg[1]\ : label is "ZERO:00,TWO:01,ONE:10";
  attribute SOFT_HLUTNM of ap_enable_reg_pp0_iter0_i_2 : label is "soft_lutpair83";
  attribute SOFT_HLUTNM of \exitcond_reg_251[0]_i_1\ : label is "soft_lutpair82";
  attribute SOFT_HLUTNM of \exitcond_reg_251_pp0_iter1_reg[0]_i_1\ : label is "soft_lutpair84";
  attribute SOFT_HLUTNM of \gmem_addr_1_read_reg_260[31]_i_1\ : label is "soft_lutpair84";
  attribute SOFT_HLUTNM of \s_ready_t_i_1__1\ : label is "soft_lutpair85";
  attribute SOFT_HLUTNM of \sum_reg_125[0]_i_2\ : label is "soft_lutpair83";
begin
  i_reg_1370 <= \^i_reg_1370\;
  rdata_ack_t <= \^rdata_ack_t\;
\FSM_sequential_state[0]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0602"
    )
        port map (
      I0 => \state__0\(0),
      I1 => \state__0\(1),
      I2 => \FSM_sequential_state[1]_i_2_n_2\,
      I3 => s_ready_t_reg_0,
      O => \next__0\(0)
    );
\FSM_sequential_state[1]_i_1__1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"3E020C30"
    )
        port map (
      I0 => \^rdata_ack_t\,
      I1 => \state__0\(0),
      I2 => \state__0\(1),
      I3 => \FSM_sequential_state[1]_i_2_n_2\,
      I4 => s_ready_t_reg_0,
      O => \next__0\(1)
    );
\FSM_sequential_state[1]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0080"
    )
        port map (
      I0 => gmem_RVALID,
      I1 => Q(1),
      I2 => ap_enable_reg_pp0_iter1_reg,
      I3 => ap_enable_reg_pp0_iter1_reg_0,
      O => \FSM_sequential_state[1]_i_2_n_2\
    );
\FSM_sequential_state_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \next__0\(0),
      Q => \state__0\(0),
      R => SR(0)
    );
\FSM_sequential_state_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \next__0\(1),
      Q => \state__0\(1),
      R => SR(0)
    );
ap_enable_reg_pp0_iter0_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"DFDFDF0000000000"
    )
        port map (
      I0 => Q(1),
      I1 => ap_enable_reg_pp0_iter0_i_2_n_2,
      I2 => CO(0),
      I3 => Q(0),
      I4 => ap_enable_reg_pp0_iter0,
      I5 => ap_rst_n,
      O => \ap_CS_fsm_reg[8]\
    );
ap_enable_reg_pp0_iter0_i_2: unisim.vcomponents.LUT3
    generic map(
      INIT => X"04"
    )
        port map (
      I0 => gmem_RVALID,
      I1 => ap_enable_reg_pp0_iter1_reg,
      I2 => ap_enable_reg_pp0_iter1_reg_0,
      O => ap_enable_reg_pp0_iter0_i_2_n_2
    );
ap_enable_reg_pp0_iter1_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5575003000000000"
    )
        port map (
      I0 => CO(0),
      I1 => gmem_RVALID,
      I2 => ap_enable_reg_pp0_iter1_reg,
      I3 => ap_enable_reg_pp0_iter1_reg_0,
      I4 => ap_enable_reg_pp0_iter0,
      I5 => ap_rst_n,
      O => \state_reg[0]_0\
    );
ap_enable_reg_pp0_iter2_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF00F40000000000"
    )
        port map (
      I0 => Q(0),
      I1 => ap_enable_reg_pp0_iter2_reg,
      I2 => gmem_RVALID,
      I3 => ap_enable_reg_pp0_iter1_reg,
      I4 => ap_enable_reg_pp0_iter1_reg_0,
      I5 => ap_rst_n,
      O => \ap_CS_fsm_reg[7]\
    );
\data_p1[0]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BA8A"
    )
        port map (
      I0 => \data_p2_reg[31]_0\(0),
      I1 => \state__0\(1),
      I2 => \state__0\(0),
      I3 => \data_p2_reg_n_2_[0]\,
      O => \data_p1[0]_i_1__1_n_2\
    );
\data_p1[10]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BA8A"
    )
        port map (
      I0 => \data_p2_reg[31]_0\(10),
      I1 => \state__0\(1),
      I2 => \state__0\(0),
      I3 => \data_p2_reg_n_2_[10]\,
      O => \data_p1[10]_i_1__1_n_2\
    );
\data_p1[11]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BA8A"
    )
        port map (
      I0 => \data_p2_reg[31]_0\(11),
      I1 => \state__0\(1),
      I2 => \state__0\(0),
      I3 => \data_p2_reg_n_2_[11]\,
      O => \data_p1[11]_i_1__1_n_2\
    );
\data_p1[12]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BA8A"
    )
        port map (
      I0 => \data_p2_reg[31]_0\(12),
      I1 => \state__0\(1),
      I2 => \state__0\(0),
      I3 => \data_p2_reg_n_2_[12]\,
      O => \data_p1[12]_i_1__1_n_2\
    );
\data_p1[13]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BA8A"
    )
        port map (
      I0 => \data_p2_reg[31]_0\(13),
      I1 => \state__0\(1),
      I2 => \state__0\(0),
      I3 => \data_p2_reg_n_2_[13]\,
      O => \data_p1[13]_i_1__1_n_2\
    );
\data_p1[14]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BA8A"
    )
        port map (
      I0 => \data_p2_reg[31]_0\(14),
      I1 => \state__0\(1),
      I2 => \state__0\(0),
      I3 => \data_p2_reg_n_2_[14]\,
      O => \data_p1[14]_i_1__1_n_2\
    );
\data_p1[15]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BA8A"
    )
        port map (
      I0 => \data_p2_reg[31]_0\(15),
      I1 => \state__0\(1),
      I2 => \state__0\(0),
      I3 => \data_p2_reg_n_2_[15]\,
      O => \data_p1[15]_i_1__1_n_2\
    );
\data_p1[16]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BA8A"
    )
        port map (
      I0 => \data_p2_reg[31]_0\(16),
      I1 => \state__0\(1),
      I2 => \state__0\(0),
      I3 => \data_p2_reg_n_2_[16]\,
      O => \data_p1[16]_i_1__1_n_2\
    );
\data_p1[17]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BA8A"
    )
        port map (
      I0 => \data_p2_reg[31]_0\(17),
      I1 => \state__0\(1),
      I2 => \state__0\(0),
      I3 => \data_p2_reg_n_2_[17]\,
      O => \data_p1[17]_i_1__1_n_2\
    );
\data_p1[18]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BA8A"
    )
        port map (
      I0 => \data_p2_reg[31]_0\(18),
      I1 => \state__0\(1),
      I2 => \state__0\(0),
      I3 => \data_p2_reg_n_2_[18]\,
      O => \data_p1[18]_i_1__1_n_2\
    );
\data_p1[19]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BA8A"
    )
        port map (
      I0 => \data_p2_reg[31]_0\(19),
      I1 => \state__0\(1),
      I2 => \state__0\(0),
      I3 => \data_p2_reg_n_2_[19]\,
      O => \data_p1[19]_i_1__1_n_2\
    );
\data_p1[1]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BA8A"
    )
        port map (
      I0 => \data_p2_reg[31]_0\(1),
      I1 => \state__0\(1),
      I2 => \state__0\(0),
      I3 => \data_p2_reg_n_2_[1]\,
      O => \data_p1[1]_i_1__1_n_2\
    );
\data_p1[20]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BA8A"
    )
        port map (
      I0 => \data_p2_reg[31]_0\(20),
      I1 => \state__0\(1),
      I2 => \state__0\(0),
      I3 => \data_p2_reg_n_2_[20]\,
      O => \data_p1[20]_i_1__1_n_2\
    );
\data_p1[21]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BA8A"
    )
        port map (
      I0 => \data_p2_reg[31]_0\(21),
      I1 => \state__0\(1),
      I2 => \state__0\(0),
      I3 => \data_p2_reg_n_2_[21]\,
      O => \data_p1[21]_i_1__1_n_2\
    );
\data_p1[22]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BA8A"
    )
        port map (
      I0 => \data_p2_reg[31]_0\(22),
      I1 => \state__0\(1),
      I2 => \state__0\(0),
      I3 => \data_p2_reg_n_2_[22]\,
      O => \data_p1[22]_i_1__1_n_2\
    );
\data_p1[23]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BA8A"
    )
        port map (
      I0 => \data_p2_reg[31]_0\(23),
      I1 => \state__0\(1),
      I2 => \state__0\(0),
      I3 => \data_p2_reg_n_2_[23]\,
      O => \data_p1[23]_i_1__1_n_2\
    );
\data_p1[24]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BA8A"
    )
        port map (
      I0 => \data_p2_reg[31]_0\(24),
      I1 => \state__0\(1),
      I2 => \state__0\(0),
      I3 => \data_p2_reg_n_2_[24]\,
      O => \data_p1[24]_i_1__1_n_2\
    );
\data_p1[25]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BA8A"
    )
        port map (
      I0 => \data_p2_reg[31]_0\(25),
      I1 => \state__0\(1),
      I2 => \state__0\(0),
      I3 => \data_p2_reg_n_2_[25]\,
      O => \data_p1[25]_i_1__1_n_2\
    );
\data_p1[26]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BA8A"
    )
        port map (
      I0 => \data_p2_reg[31]_0\(26),
      I1 => \state__0\(1),
      I2 => \state__0\(0),
      I3 => \data_p2_reg_n_2_[26]\,
      O => \data_p1[26]_i_1__1_n_2\
    );
\data_p1[27]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BA8A"
    )
        port map (
      I0 => \data_p2_reg[31]_0\(27),
      I1 => \state__0\(1),
      I2 => \state__0\(0),
      I3 => \data_p2_reg_n_2_[27]\,
      O => \data_p1[27]_i_1__1_n_2\
    );
\data_p1[28]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BA8A"
    )
        port map (
      I0 => \data_p2_reg[31]_0\(28),
      I1 => \state__0\(1),
      I2 => \state__0\(0),
      I3 => \data_p2_reg_n_2_[28]\,
      O => \data_p1[28]_i_1__1_n_2\
    );
\data_p1[29]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BA8A"
    )
        port map (
      I0 => \data_p2_reg[31]_0\(29),
      I1 => \state__0\(1),
      I2 => \state__0\(0),
      I3 => \data_p2_reg_n_2_[29]\,
      O => \data_p1[29]_i_1__1_n_2\
    );
\data_p1[2]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BA8A"
    )
        port map (
      I0 => \data_p2_reg[31]_0\(2),
      I1 => \state__0\(1),
      I2 => \state__0\(0),
      I3 => \data_p2_reg_n_2_[2]\,
      O => \data_p1[2]_i_1__1_n_2\
    );
\data_p1[30]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BA8A"
    )
        port map (
      I0 => \data_p2_reg[31]_0\(30),
      I1 => \state__0\(1),
      I2 => \state__0\(0),
      I3 => \data_p2_reg_n_2_[30]\,
      O => \data_p1[30]_i_1_n_2\
    );
\data_p1[31]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"08AC"
    )
        port map (
      I0 => \FSM_sequential_state[1]_i_2_n_2\,
      I1 => s_ready_t_reg_0,
      I2 => \state__0\(0),
      I3 => \state__0\(1),
      O => load_p1
    );
\data_p1[31]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BA8A"
    )
        port map (
      I0 => \data_p2_reg[31]_0\(31),
      I1 => \state__0\(1),
      I2 => \state__0\(0),
      I3 => \data_p2_reg_n_2_[31]\,
      O => \data_p1[31]_i_2_n_2\
    );
\data_p1[3]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BA8A"
    )
        port map (
      I0 => \data_p2_reg[31]_0\(3),
      I1 => \state__0\(1),
      I2 => \state__0\(0),
      I3 => \data_p2_reg_n_2_[3]\,
      O => \data_p1[3]_i_1__1_n_2\
    );
\data_p1[4]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BA8A"
    )
        port map (
      I0 => \data_p2_reg[31]_0\(4),
      I1 => \state__0\(1),
      I2 => \state__0\(0),
      I3 => \data_p2_reg_n_2_[4]\,
      O => \data_p1[4]_i_1__1_n_2\
    );
\data_p1[5]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BA8A"
    )
        port map (
      I0 => \data_p2_reg[31]_0\(5),
      I1 => \state__0\(1),
      I2 => \state__0\(0),
      I3 => \data_p2_reg_n_2_[5]\,
      O => \data_p1[5]_i_1__1_n_2\
    );
\data_p1[6]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BA8A"
    )
        port map (
      I0 => \data_p2_reg[31]_0\(6),
      I1 => \state__0\(1),
      I2 => \state__0\(0),
      I3 => \data_p2_reg_n_2_[6]\,
      O => \data_p1[6]_i_1__1_n_2\
    );
\data_p1[7]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BA8A"
    )
        port map (
      I0 => \data_p2_reg[31]_0\(7),
      I1 => \state__0\(1),
      I2 => \state__0\(0),
      I3 => \data_p2_reg_n_2_[7]\,
      O => \data_p1[7]_i_1__1_n_2\
    );
\data_p1[8]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BA8A"
    )
        port map (
      I0 => \data_p2_reg[31]_0\(8),
      I1 => \state__0\(1),
      I2 => \state__0\(0),
      I3 => \data_p2_reg_n_2_[8]\,
      O => \data_p1[8]_i_1__1_n_2\
    );
\data_p1[9]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BA8A"
    )
        port map (
      I0 => \data_p2_reg[31]_0\(9),
      I1 => \state__0\(1),
      I2 => \state__0\(0),
      I3 => \data_p2_reg_n_2_[9]\,
      O => \data_p1[9]_i_1__1_n_2\
    );
\data_p1_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[0]_i_1__1_n_2\,
      Q => \data_p1_reg[31]_0\(0),
      R => '0'
    );
\data_p1_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[10]_i_1__1_n_2\,
      Q => \data_p1_reg[31]_0\(10),
      R => '0'
    );
\data_p1_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[11]_i_1__1_n_2\,
      Q => \data_p1_reg[31]_0\(11),
      R => '0'
    );
\data_p1_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[12]_i_1__1_n_2\,
      Q => \data_p1_reg[31]_0\(12),
      R => '0'
    );
\data_p1_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[13]_i_1__1_n_2\,
      Q => \data_p1_reg[31]_0\(13),
      R => '0'
    );
\data_p1_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[14]_i_1__1_n_2\,
      Q => \data_p1_reg[31]_0\(14),
      R => '0'
    );
\data_p1_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[15]_i_1__1_n_2\,
      Q => \data_p1_reg[31]_0\(15),
      R => '0'
    );
\data_p1_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[16]_i_1__1_n_2\,
      Q => \data_p1_reg[31]_0\(16),
      R => '0'
    );
\data_p1_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[17]_i_1__1_n_2\,
      Q => \data_p1_reg[31]_0\(17),
      R => '0'
    );
\data_p1_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[18]_i_1__1_n_2\,
      Q => \data_p1_reg[31]_0\(18),
      R => '0'
    );
\data_p1_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[19]_i_1__1_n_2\,
      Q => \data_p1_reg[31]_0\(19),
      R => '0'
    );
\data_p1_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[1]_i_1__1_n_2\,
      Q => \data_p1_reg[31]_0\(1),
      R => '0'
    );
\data_p1_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[20]_i_1__1_n_2\,
      Q => \data_p1_reg[31]_0\(20),
      R => '0'
    );
\data_p1_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[21]_i_1__1_n_2\,
      Q => \data_p1_reg[31]_0\(21),
      R => '0'
    );
\data_p1_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[22]_i_1__1_n_2\,
      Q => \data_p1_reg[31]_0\(22),
      R => '0'
    );
\data_p1_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[23]_i_1__1_n_2\,
      Q => \data_p1_reg[31]_0\(23),
      R => '0'
    );
\data_p1_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[24]_i_1__1_n_2\,
      Q => \data_p1_reg[31]_0\(24),
      R => '0'
    );
\data_p1_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[25]_i_1__1_n_2\,
      Q => \data_p1_reg[31]_0\(25),
      R => '0'
    );
\data_p1_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[26]_i_1__1_n_2\,
      Q => \data_p1_reg[31]_0\(26),
      R => '0'
    );
\data_p1_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[27]_i_1__1_n_2\,
      Q => \data_p1_reg[31]_0\(27),
      R => '0'
    );
\data_p1_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[28]_i_1__1_n_2\,
      Q => \data_p1_reg[31]_0\(28),
      R => '0'
    );
\data_p1_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[29]_i_1__1_n_2\,
      Q => \data_p1_reg[31]_0\(29),
      R => '0'
    );
\data_p1_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[2]_i_1__1_n_2\,
      Q => \data_p1_reg[31]_0\(2),
      R => '0'
    );
\data_p1_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[30]_i_1_n_2\,
      Q => \data_p1_reg[31]_0\(30),
      R => '0'
    );
\data_p1_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[31]_i_2_n_2\,
      Q => \data_p1_reg[31]_0\(31),
      R => '0'
    );
\data_p1_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[3]_i_1__1_n_2\,
      Q => \data_p1_reg[31]_0\(3),
      R => '0'
    );
\data_p1_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[4]_i_1__1_n_2\,
      Q => \data_p1_reg[31]_0\(4),
      R => '0'
    );
\data_p1_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[5]_i_1__1_n_2\,
      Q => \data_p1_reg[31]_0\(5),
      R => '0'
    );
\data_p1_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[6]_i_1__1_n_2\,
      Q => \data_p1_reg[31]_0\(6),
      R => '0'
    );
\data_p1_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[7]_i_1__1_n_2\,
      Q => \data_p1_reg[31]_0\(7),
      R => '0'
    );
\data_p1_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[8]_i_1__1_n_2\,
      Q => \data_p1_reg[31]_0\(8),
      R => '0'
    );
\data_p1_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p1,
      D => \data_p1[9]_i_1__1_n_2\,
      Q => \data_p1_reg[31]_0\(9),
      R => '0'
    );
\data_p2[31]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => s_ready_t_reg_0,
      I1 => \^rdata_ack_t\,
      O => load_p2
    );
\data_p2_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[31]_0\(0),
      Q => \data_p2_reg_n_2_[0]\,
      R => '0'
    );
\data_p2_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[31]_0\(10),
      Q => \data_p2_reg_n_2_[10]\,
      R => '0'
    );
\data_p2_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[31]_0\(11),
      Q => \data_p2_reg_n_2_[11]\,
      R => '0'
    );
\data_p2_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[31]_0\(12),
      Q => \data_p2_reg_n_2_[12]\,
      R => '0'
    );
\data_p2_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[31]_0\(13),
      Q => \data_p2_reg_n_2_[13]\,
      R => '0'
    );
\data_p2_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[31]_0\(14),
      Q => \data_p2_reg_n_2_[14]\,
      R => '0'
    );
\data_p2_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[31]_0\(15),
      Q => \data_p2_reg_n_2_[15]\,
      R => '0'
    );
\data_p2_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[31]_0\(16),
      Q => \data_p2_reg_n_2_[16]\,
      R => '0'
    );
\data_p2_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[31]_0\(17),
      Q => \data_p2_reg_n_2_[17]\,
      R => '0'
    );
\data_p2_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[31]_0\(18),
      Q => \data_p2_reg_n_2_[18]\,
      R => '0'
    );
\data_p2_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[31]_0\(19),
      Q => \data_p2_reg_n_2_[19]\,
      R => '0'
    );
\data_p2_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[31]_0\(1),
      Q => \data_p2_reg_n_2_[1]\,
      R => '0'
    );
\data_p2_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[31]_0\(20),
      Q => \data_p2_reg_n_2_[20]\,
      R => '0'
    );
\data_p2_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[31]_0\(21),
      Q => \data_p2_reg_n_2_[21]\,
      R => '0'
    );
\data_p2_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[31]_0\(22),
      Q => \data_p2_reg_n_2_[22]\,
      R => '0'
    );
\data_p2_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[31]_0\(23),
      Q => \data_p2_reg_n_2_[23]\,
      R => '0'
    );
\data_p2_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[31]_0\(24),
      Q => \data_p2_reg_n_2_[24]\,
      R => '0'
    );
\data_p2_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[31]_0\(25),
      Q => \data_p2_reg_n_2_[25]\,
      R => '0'
    );
\data_p2_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[31]_0\(26),
      Q => \data_p2_reg_n_2_[26]\,
      R => '0'
    );
\data_p2_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[31]_0\(27),
      Q => \data_p2_reg_n_2_[27]\,
      R => '0'
    );
\data_p2_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[31]_0\(28),
      Q => \data_p2_reg_n_2_[28]\,
      R => '0'
    );
\data_p2_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[31]_0\(29),
      Q => \data_p2_reg_n_2_[29]\,
      R => '0'
    );
\data_p2_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[31]_0\(2),
      Q => \data_p2_reg_n_2_[2]\,
      R => '0'
    );
\data_p2_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[31]_0\(30),
      Q => \data_p2_reg_n_2_[30]\,
      R => '0'
    );
\data_p2_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[31]_0\(31),
      Q => \data_p2_reg_n_2_[31]\,
      R => '0'
    );
\data_p2_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[31]_0\(3),
      Q => \data_p2_reg_n_2_[3]\,
      R => '0'
    );
\data_p2_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[31]_0\(4),
      Q => \data_p2_reg_n_2_[4]\,
      R => '0'
    );
\data_p2_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[31]_0\(5),
      Q => \data_p2_reg_n_2_[5]\,
      R => '0'
    );
\data_p2_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[31]_0\(6),
      Q => \data_p2_reg_n_2_[6]\,
      R => '0'
    );
\data_p2_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[31]_0\(7),
      Q => \data_p2_reg_n_2_[7]\,
      R => '0'
    );
\data_p2_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[31]_0\(8),
      Q => \data_p2_reg_n_2_[8]\,
      R => '0'
    );
\data_p2_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => load_p2,
      D => \data_p2_reg[31]_0\(9),
      Q => \data_p2_reg_n_2_[9]\,
      R => '0'
    );
\exitcond_reg_251[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8B8B0B8"
    )
        port map (
      I0 => CO(0),
      I1 => Q(1),
      I2 => ap_enable_reg_pp0_iter1_reg_0,
      I3 => ap_enable_reg_pp0_iter1_reg,
      I4 => gmem_RVALID,
      O => \ap_CS_fsm_reg[8]_1\
    );
\exitcond_reg_251_pp0_iter1_reg[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"DDFD8888"
    )
        port map (
      I0 => Q(1),
      I1 => ap_enable_reg_pp0_iter1_reg_0,
      I2 => ap_enable_reg_pp0_iter1_reg,
      I3 => gmem_RVALID,
      I4 => exitcond_reg_251_pp0_iter1_reg,
      O => \ap_CS_fsm_reg[8]_0\
    );
\gmem_addr_1_read_reg_260[31]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"00B0"
    )
        port map (
      I0 => gmem_RVALID,
      I1 => ap_enable_reg_pp0_iter1_reg,
      I2 => Q(1),
      I3 => ap_enable_reg_pp0_iter1_reg_0,
      O => \state_reg[0]_1\(0)
    );
\i_reg_137[0]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => Q(0),
      I1 => \^i_reg_1370\,
      O => i_reg_137
    );
\i_reg_137[0]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000FB000000"
    )
        port map (
      I0 => gmem_RVALID,
      I1 => ap_enable_reg_pp0_iter1_reg,
      I2 => ap_enable_reg_pp0_iter1_reg_0,
      I3 => Q(1),
      I4 => ap_enable_reg_pp0_iter0,
      I5 => CO(0),
      O => \^i_reg_1370\
    );
\s_ready_t_i_1__1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFDF4455"
    )
        port map (
      I0 => \state__0\(1),
      I1 => \FSM_sequential_state[1]_i_2_n_2\,
      I2 => s_ready_t_reg_0,
      I3 => \state__0\(0),
      I4 => \^rdata_ack_t\,
      O => \s_ready_t_i_1__1_n_2\
    );
s_ready_t_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \s_ready_t_i_1__1_n_2\,
      Q => \^rdata_ack_t\,
      R => SR(0)
    );
\state[0]_i_1__1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F5FFC000"
    )
        port map (
      I0 => \FSM_sequential_state[1]_i_2_n_2\,
      I1 => \^rdata_ack_t\,
      I2 => s_ready_t_reg_0,
      I3 => state(1),
      I4 => gmem_RVALID,
      O => \state[0]_i_1__1_n_2\
    );
\state[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4040FF40FFFFFFFF"
    )
        port map (
      I0 => ap_enable_reg_pp0_iter1_reg_0,
      I1 => ap_enable_reg_pp0_iter1_reg,
      I2 => Q(1),
      I3 => state(1),
      I4 => s_ready_t_reg_0,
      I5 => gmem_RVALID,
      O => \state[1]_i_1_n_2\
    );
\state_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \state[0]_i_1__1_n_2\,
      Q => gmem_RVALID,
      R => SR(0)
    );
\state_reg[1]\: unisim.vcomponents.FDSE
     port map (
      C => ap_clk,
      CE => '1',
      D => \state[1]_i_1_n_2\,
      Q => state(1),
      S => SR(0)
    );
\sum_reg_125[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAAAAA0020AAAA"
    )
        port map (
      I0 => Q(0),
      I1 => ap_enable_reg_pp0_iter1_reg_0,
      I2 => ap_enable_reg_pp0_iter1_reg,
      I3 => gmem_RVALID,
      I4 => ap_enable_reg_pp0_iter2_reg,
      I5 => exitcond_reg_251_pp0_iter1_reg,
      O => sum_reg_125
    );
\sum_reg_125[0]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"44444044"
    )
        port map (
      I0 => exitcond_reg_251_pp0_iter1_reg,
      I1 => ap_enable_reg_pp0_iter2_reg,
      I2 => gmem_RVALID,
      I3 => ap_enable_reg_pp0_iter1_reg,
      I4 => ap_enable_reg_pp0_iter1_reg_0,
      O => sum_reg_1250
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_throttl is
  port (
    m_axi_gmem_AWVALID : out STD_LOGIC;
    Q : out STD_LOGIC_VECTOR ( 0 to 0 );
    \throttl_cnt_reg[0]_0\ : out STD_LOGIC;
    m_axi_gmem_AWREADY_0 : out STD_LOGIC;
    \throttl_cnt_reg[5]_0\ : out STD_LOGIC;
    \throttl_cnt_reg[7]_0\ : out STD_LOGIC;
    AWVALID_Dummy : in STD_LOGIC;
    D : in STD_LOGIC_VECTOR ( 0 to 0 );
    \throttl_cnt_reg[2]_0\ : in STD_LOGIC;
    \throttl_cnt_reg[3]_0\ : in STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_gmem_AWREADY : in STD_LOGIC;
    SR : in STD_LOGIC_VECTOR ( 0 to 0 );
    E : in STD_LOGIC_VECTOR ( 0 to 0 );
    ap_clk : in STD_LOGIC
  );
end design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_throttl;

architecture STRUCTURE of design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_throttl is
  signal \^q\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal p_0_in : STD_LOGIC_VECTOR ( 7 downto 1 );
  signal \^throttl_cnt_reg[0]_0\ : STD_LOGIC;
  signal \throttl_cnt_reg__0\ : STD_LOGIC_VECTOR ( 7 downto 1 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \could_multi_bursts.awaddr_buf[31]_i_4\ : label is "soft_lutpair208";
  attribute SOFT_HLUTNM of \throttl_cnt[5]_i_1\ : label is "soft_lutpair209";
  attribute SOFT_HLUTNM of \throttl_cnt[6]_i_1\ : label is "soft_lutpair209";
  attribute SOFT_HLUTNM of \throttl_cnt[7]_i_4\ : label is "soft_lutpair208";
begin
  Q(0) <= \^q\(0);
  \throttl_cnt_reg[0]_0\ <= \^throttl_cnt_reg[0]_0\;
\could_multi_bursts.AWVALID_Dummy_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000002"
    )
        port map (
      I0 => m_axi_gmem_AWREADY,
      I1 => \throttl_cnt_reg__0\(7),
      I2 => \throttl_cnt_reg__0\(4),
      I3 => \throttl_cnt_reg__0\(6),
      I4 => \throttl_cnt_reg__0\(5),
      I5 => \^throttl_cnt_reg[0]_0\,
      O => m_axi_gmem_AWREADY_0
    );
\could_multi_bursts.awaddr_buf[31]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \throttl_cnt_reg__0\(7),
      I1 => \throttl_cnt_reg__0\(4),
      I2 => \throttl_cnt_reg__0\(6),
      I3 => \throttl_cnt_reg__0\(5),
      O => \throttl_cnt_reg[7]_0\
    );
m_axi_gmem_AWVALID_INST_0: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000002"
    )
        port map (
      I0 => AWVALID_Dummy,
      I1 => \throttl_cnt_reg__0\(7),
      I2 => \throttl_cnt_reg__0\(4),
      I3 => \throttl_cnt_reg__0\(6),
      I4 => \throttl_cnt_reg__0\(5),
      I5 => \^throttl_cnt_reg[0]_0\,
      O => m_axi_gmem_AWVALID
    );
m_axi_gmem_AWVALID_INST_0_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \^q\(0),
      I1 => \throttl_cnt_reg__0\(1),
      I2 => \throttl_cnt_reg__0\(2),
      I3 => \throttl_cnt_reg__0\(3),
      O => \^throttl_cnt_reg[0]_0\
    );
\throttl_cnt[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9099"
    )
        port map (
      I0 => \^q\(0),
      I1 => \throttl_cnt_reg__0\(1),
      I2 => \throttl_cnt_reg[3]_0\(0),
      I3 => \throttl_cnt_reg[2]_0\,
      O => p_0_in(1)
    );
\throttl_cnt[2]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"DDD0000D"
    )
        port map (
      I0 => \throttl_cnt_reg[2]_0\,
      I1 => \throttl_cnt_reg[3]_0\(1),
      I2 => \throttl_cnt_reg__0\(1),
      I3 => \^q\(0),
      I4 => \throttl_cnt_reg__0\(2),
      O => p_0_in(2)
    );
\throttl_cnt[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FE010000FE01FE01"
    )
        port map (
      I0 => \throttl_cnt_reg__0\(2),
      I1 => \^q\(0),
      I2 => \throttl_cnt_reg__0\(1),
      I3 => \throttl_cnt_reg__0\(3),
      I4 => \throttl_cnt_reg[3]_0\(2),
      I5 => \throttl_cnt_reg[2]_0\,
      O => p_0_in(3)
    );
\throttl_cnt[4]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000FFFE0001"
    )
        port map (
      I0 => \^q\(0),
      I1 => \throttl_cnt_reg__0\(1),
      I2 => \throttl_cnt_reg__0\(2),
      I3 => \throttl_cnt_reg__0\(3),
      I4 => \throttl_cnt_reg__0\(4),
      I5 => \throttl_cnt_reg[2]_0\,
      O => p_0_in(4)
    );
\throttl_cnt[5]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"00E1"
    )
        port map (
      I0 => \throttl_cnt_reg__0\(4),
      I1 => \^throttl_cnt_reg[0]_0\,
      I2 => \throttl_cnt_reg__0\(5),
      I3 => \throttl_cnt_reg[2]_0\,
      O => p_0_in(5)
    );
\throttl_cnt[6]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0000FE01"
    )
        port map (
      I0 => \^throttl_cnt_reg[0]_0\,
      I1 => \throttl_cnt_reg__0\(4),
      I2 => \throttl_cnt_reg__0\(5),
      I3 => \throttl_cnt_reg__0\(6),
      I4 => \throttl_cnt_reg[2]_0\,
      O => p_0_in(6)
    );
\throttl_cnt[7]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000FFFE0001"
    )
        port map (
      I0 => \throttl_cnt_reg__0\(5),
      I1 => \throttl_cnt_reg__0\(4),
      I2 => \^throttl_cnt_reg[0]_0\,
      I3 => \throttl_cnt_reg__0\(6),
      I4 => \throttl_cnt_reg__0\(7),
      I5 => \throttl_cnt_reg[2]_0\,
      O => p_0_in(7)
    );
\throttl_cnt[7]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => \^throttl_cnt_reg[0]_0\,
      I1 => \throttl_cnt_reg__0\(5),
      I2 => \throttl_cnt_reg__0\(6),
      I3 => \throttl_cnt_reg__0\(4),
      I4 => \throttl_cnt_reg__0\(7),
      O => \throttl_cnt_reg[5]_0\
    );
\throttl_cnt_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => D(0),
      Q => \^q\(0),
      R => SR(0)
    );
\throttl_cnt_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => p_0_in(1),
      Q => \throttl_cnt_reg__0\(1),
      R => SR(0)
    );
\throttl_cnt_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => p_0_in(2),
      Q => \throttl_cnt_reg__0\(2),
      R => SR(0)
    );
\throttl_cnt_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => p_0_in(3),
      Q => \throttl_cnt_reg__0\(3),
      R => SR(0)
    );
\throttl_cnt_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => p_0_in(4),
      Q => \throttl_cnt_reg__0\(4),
      R => SR(0)
    );
\throttl_cnt_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => p_0_in(5),
      Q => \throttl_cnt_reg__0\(5),
      R => SR(0)
    );
\throttl_cnt_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => p_0_in(6),
      Q => \throttl_cnt_reg__0\(6),
      R => SR(0)
    );
\throttl_cnt_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => E(0),
      D => p_0_in(7),
      Q => \throttl_cnt_reg__0\(7),
      R => SR(0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_read is
  port (
    full_n_reg : out STD_LOGIC;
    SR : out STD_LOGIC_VECTOR ( 0 to 0 );
    \could_multi_bursts.ARVALID_Dummy_reg_0\ : out STD_LOGIC;
    \state_reg[0]\ : out STD_LOGIC;
    \ap_CS_fsm_reg[7]\ : out STD_LOGIC;
    E : out STD_LOGIC_VECTOR ( 0 to 0 );
    \usedw_reg[5]\ : out STD_LOGIC_VECTOR ( 5 downto 0 );
    i_reg_137 : out STD_LOGIC;
    i_reg_1370 : out STD_LOGIC;
    \state_reg[0]_0\ : out STD_LOGIC_VECTOR ( 0 to 0 );
    sum_reg_125 : out STD_LOGIC;
    sum_reg_1250 : out STD_LOGIC;
    \ap_CS_fsm_reg[8]\ : out STD_LOGIC;
    DI : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axi_gmem_ARADDR : out STD_LOGIC_VECTOR ( 29 downto 0 );
    S : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \ap_CS_fsm_reg[8]_0\ : out STD_LOGIC;
    \ap_CS_fsm_reg[8]_1\ : out STD_LOGIC;
    \usedw_reg[6]\ : out STD_LOGIC_VECTOR ( 2 downto 0 );
    \could_multi_bursts.arlen_buf_reg[3]_0\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \data_p1_reg[31]\ : out STD_LOGIC_VECTOR ( 31 downto 0 );
    ap_clk : in STD_LOGIC;
    D : in STD_LOGIC_VECTOR ( 32 downto 0 );
    m_axi_gmem_RRESP : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_gmem_RVALID : in STD_LOGIC;
    ap_rst_n : in STD_LOGIC;
    m_axi_gmem_ARREADY : in STD_LOGIC;
    CO : in STD_LOGIC_VECTOR ( 0 to 0 );
    ap_enable_reg_pp0_iter1_reg : in STD_LOGIC;
    ap_enable_reg_pp0_iter1_reg_0 : in STD_LOGIC;
    ap_enable_reg_pp0_iter0 : in STD_LOGIC;
    Q : in STD_LOGIC_VECTOR ( 2 downto 0 );
    ap_enable_reg_pp0_iter2_reg : in STD_LOGIC;
    exitcond_reg_251_pp0_iter1_reg : in STD_LOGIC;
    \data_p2_reg[63]\ : in STD_LOGIC_VECTOR ( 61 downto 0 );
    \usedw_reg[7]\ : in STD_LOGIC_VECTOR ( 6 downto 0 )
  );
end design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_read;

architecture STRUCTURE of design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_read is
  signal \^sr\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal align_len : STD_LOGIC;
  signal \align_len0_carry__0_n_2\ : STD_LOGIC;
  signal \align_len0_carry__0_n_3\ : STD_LOGIC;
  signal \align_len0_carry__0_n_4\ : STD_LOGIC;
  signal \align_len0_carry__0_n_5\ : STD_LOGIC;
  signal \align_len0_carry__0_n_6\ : STD_LOGIC;
  signal \align_len0_carry__0_n_7\ : STD_LOGIC;
  signal \align_len0_carry__0_n_8\ : STD_LOGIC;
  signal \align_len0_carry__0_n_9\ : STD_LOGIC;
  signal \align_len0_carry__1_n_2\ : STD_LOGIC;
  signal \align_len0_carry__1_n_3\ : STD_LOGIC;
  signal \align_len0_carry__1_n_4\ : STD_LOGIC;
  signal \align_len0_carry__1_n_5\ : STD_LOGIC;
  signal \align_len0_carry__1_n_6\ : STD_LOGIC;
  signal \align_len0_carry__1_n_7\ : STD_LOGIC;
  signal \align_len0_carry__1_n_8\ : STD_LOGIC;
  signal \align_len0_carry__1_n_9\ : STD_LOGIC;
  signal \align_len0_carry__2_n_2\ : STD_LOGIC;
  signal \align_len0_carry__2_n_3\ : STD_LOGIC;
  signal \align_len0_carry__2_n_4\ : STD_LOGIC;
  signal \align_len0_carry__2_n_5\ : STD_LOGIC;
  signal \align_len0_carry__2_n_6\ : STD_LOGIC;
  signal \align_len0_carry__2_n_7\ : STD_LOGIC;
  signal \align_len0_carry__2_n_8\ : STD_LOGIC;
  signal \align_len0_carry__2_n_9\ : STD_LOGIC;
  signal \align_len0_carry__3_n_2\ : STD_LOGIC;
  signal \align_len0_carry__3_n_3\ : STD_LOGIC;
  signal \align_len0_carry__3_n_4\ : STD_LOGIC;
  signal \align_len0_carry__3_n_5\ : STD_LOGIC;
  signal \align_len0_carry__3_n_6\ : STD_LOGIC;
  signal \align_len0_carry__3_n_7\ : STD_LOGIC;
  signal \align_len0_carry__3_n_8\ : STD_LOGIC;
  signal \align_len0_carry__3_n_9\ : STD_LOGIC;
  signal \align_len0_carry__4_n_2\ : STD_LOGIC;
  signal \align_len0_carry__4_n_3\ : STD_LOGIC;
  signal \align_len0_carry__4_n_4\ : STD_LOGIC;
  signal \align_len0_carry__4_n_5\ : STD_LOGIC;
  signal \align_len0_carry__4_n_6\ : STD_LOGIC;
  signal \align_len0_carry__4_n_7\ : STD_LOGIC;
  signal \align_len0_carry__4_n_8\ : STD_LOGIC;
  signal \align_len0_carry__4_n_9\ : STD_LOGIC;
  signal \align_len0_carry__5_n_2\ : STD_LOGIC;
  signal \align_len0_carry__5_n_3\ : STD_LOGIC;
  signal \align_len0_carry__5_n_4\ : STD_LOGIC;
  signal \align_len0_carry__5_n_5\ : STD_LOGIC;
  signal \align_len0_carry__5_n_6\ : STD_LOGIC;
  signal \align_len0_carry__5_n_7\ : STD_LOGIC;
  signal \align_len0_carry__5_n_8\ : STD_LOGIC;
  signal \align_len0_carry__5_n_9\ : STD_LOGIC;
  signal \align_len0_carry__6_n_4\ : STD_LOGIC;
  signal \align_len0_carry__6_n_5\ : STD_LOGIC;
  signal \align_len0_carry__6_n_7\ : STD_LOGIC;
  signal \align_len0_carry__6_n_8\ : STD_LOGIC;
  signal \align_len0_carry__6_n_9\ : STD_LOGIC;
  signal align_len0_carry_n_2 : STD_LOGIC;
  signal align_len0_carry_n_3 : STD_LOGIC;
  signal align_len0_carry_n_4 : STD_LOGIC;
  signal align_len0_carry_n_5 : STD_LOGIC;
  signal align_len0_carry_n_6 : STD_LOGIC;
  signal align_len0_carry_n_7 : STD_LOGIC;
  signal align_len0_carry_n_8 : STD_LOGIC;
  signal \align_len_reg_n_2_[10]\ : STD_LOGIC;
  signal \align_len_reg_n_2_[11]\ : STD_LOGIC;
  signal \align_len_reg_n_2_[12]\ : STD_LOGIC;
  signal \align_len_reg_n_2_[13]\ : STD_LOGIC;
  signal \align_len_reg_n_2_[14]\ : STD_LOGIC;
  signal \align_len_reg_n_2_[15]\ : STD_LOGIC;
  signal \align_len_reg_n_2_[16]\ : STD_LOGIC;
  signal \align_len_reg_n_2_[17]\ : STD_LOGIC;
  signal \align_len_reg_n_2_[18]\ : STD_LOGIC;
  signal \align_len_reg_n_2_[19]\ : STD_LOGIC;
  signal \align_len_reg_n_2_[20]\ : STD_LOGIC;
  signal \align_len_reg_n_2_[21]\ : STD_LOGIC;
  signal \align_len_reg_n_2_[22]\ : STD_LOGIC;
  signal \align_len_reg_n_2_[23]\ : STD_LOGIC;
  signal \align_len_reg_n_2_[24]\ : STD_LOGIC;
  signal \align_len_reg_n_2_[25]\ : STD_LOGIC;
  signal \align_len_reg_n_2_[26]\ : STD_LOGIC;
  signal \align_len_reg_n_2_[27]\ : STD_LOGIC;
  signal \align_len_reg_n_2_[28]\ : STD_LOGIC;
  signal \align_len_reg_n_2_[29]\ : STD_LOGIC;
  signal \align_len_reg_n_2_[2]\ : STD_LOGIC;
  signal \align_len_reg_n_2_[30]\ : STD_LOGIC;
  signal \align_len_reg_n_2_[31]\ : STD_LOGIC;
  signal \align_len_reg_n_2_[3]\ : STD_LOGIC;
  signal \align_len_reg_n_2_[4]\ : STD_LOGIC;
  signal \align_len_reg_n_2_[5]\ : STD_LOGIC;
  signal \align_len_reg_n_2_[6]\ : STD_LOGIC;
  signal \align_len_reg_n_2_[7]\ : STD_LOGIC;
  signal \align_len_reg_n_2_[8]\ : STD_LOGIC;
  signal \align_len_reg_n_2_[9]\ : STD_LOGIC;
  signal araddr_tmp : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal \beat_len_buf_reg_n_2_[0]\ : STD_LOGIC;
  signal \beat_len_buf_reg_n_2_[1]\ : STD_LOGIC;
  signal \beat_len_buf_reg_n_2_[2]\ : STD_LOGIC;
  signal \beat_len_buf_reg_n_2_[3]\ : STD_LOGIC;
  signal \beat_len_buf_reg_n_2_[4]\ : STD_LOGIC;
  signal \beat_len_buf_reg_n_2_[5]\ : STD_LOGIC;
  signal \beat_len_buf_reg_n_2_[6]\ : STD_LOGIC;
  signal \beat_len_buf_reg_n_2_[7]\ : STD_LOGIC;
  signal \beat_len_buf_reg_n_2_[8]\ : STD_LOGIC;
  signal \beat_len_buf_reg_n_2_[9]\ : STD_LOGIC;
  signal beat_valid : STD_LOGIC;
  signal buff_rdata_n_13 : STD_LOGIC;
  signal buff_rdata_n_22 : STD_LOGIC;
  signal buff_rdata_n_23 : STD_LOGIC;
  signal buff_rdata_n_24 : STD_LOGIC;
  signal buff_rdata_n_25 : STD_LOGIC;
  signal buff_rdata_n_26 : STD_LOGIC;
  signal buff_rdata_n_27 : STD_LOGIC;
  signal buff_rdata_n_28 : STD_LOGIC;
  signal buff_rdata_n_29 : STD_LOGIC;
  signal buff_rdata_n_30 : STD_LOGIC;
  signal buff_rdata_n_31 : STD_LOGIC;
  signal buff_rdata_n_32 : STD_LOGIC;
  signal buff_rdata_n_33 : STD_LOGIC;
  signal buff_rdata_n_34 : STD_LOGIC;
  signal buff_rdata_n_35 : STD_LOGIC;
  signal buff_rdata_n_36 : STD_LOGIC;
  signal buff_rdata_n_37 : STD_LOGIC;
  signal buff_rdata_n_38 : STD_LOGIC;
  signal buff_rdata_n_39 : STD_LOGIC;
  signal buff_rdata_n_40 : STD_LOGIC;
  signal buff_rdata_n_41 : STD_LOGIC;
  signal buff_rdata_n_42 : STD_LOGIC;
  signal buff_rdata_n_43 : STD_LOGIC;
  signal buff_rdata_n_44 : STD_LOGIC;
  signal buff_rdata_n_45 : STD_LOGIC;
  signal buff_rdata_n_46 : STD_LOGIC;
  signal buff_rdata_n_47 : STD_LOGIC;
  signal buff_rdata_n_48 : STD_LOGIC;
  signal buff_rdata_n_49 : STD_LOGIC;
  signal buff_rdata_n_50 : STD_LOGIC;
  signal buff_rdata_n_51 : STD_LOGIC;
  signal buff_rdata_n_52 : STD_LOGIC;
  signal buff_rdata_n_53 : STD_LOGIC;
  signal \bus_equal_gen.data_buf\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \bus_equal_gen.rdata_valid_t_reg_n_2\ : STD_LOGIC;
  signal \^could_multi_bursts.arvalid_dummy_reg_0\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf[31]_i_4_n_2\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf[4]_i_3_n_2\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf[4]_i_4_n_2\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf[4]_i_5_n_2\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf[8]_i_3_n_2\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf[8]_i_4_n_2\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[12]_i_2_n_2\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[12]_i_2_n_3\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[12]_i_2_n_4\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[12]_i_2_n_5\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[12]_i_2_n_6\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[12]_i_2_n_7\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[12]_i_2_n_8\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[12]_i_2_n_9\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[16]_i_2_n_2\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[16]_i_2_n_3\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[16]_i_2_n_4\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[16]_i_2_n_5\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[16]_i_2_n_6\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[16]_i_2_n_7\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[16]_i_2_n_8\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[16]_i_2_n_9\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[20]_i_2_n_2\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[20]_i_2_n_3\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[20]_i_2_n_4\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[20]_i_2_n_5\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[20]_i_2_n_6\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[20]_i_2_n_7\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[20]_i_2_n_8\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[20]_i_2_n_9\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[24]_i_2_n_2\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[24]_i_2_n_3\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[24]_i_2_n_4\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[24]_i_2_n_5\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[24]_i_2_n_6\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[24]_i_2_n_7\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[24]_i_2_n_8\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[24]_i_2_n_9\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[28]_i_2_n_2\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[28]_i_2_n_3\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[28]_i_2_n_4\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[28]_i_2_n_5\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[28]_i_2_n_6\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[28]_i_2_n_7\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[28]_i_2_n_8\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[28]_i_2_n_9\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[31]_i_3_n_4\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[31]_i_3_n_5\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[31]_i_3_n_7\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[31]_i_3_n_8\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[31]_i_3_n_9\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[4]_i_2_n_2\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[4]_i_2_n_3\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[4]_i_2_n_4\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[4]_i_2_n_5\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[4]_i_2_n_6\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[4]_i_2_n_7\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[4]_i_2_n_8\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[8]_i_2_n_2\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[8]_i_2_n_3\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[8]_i_2_n_4\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[8]_i_2_n_5\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[8]_i_2_n_6\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[8]_i_2_n_7\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[8]_i_2_n_8\ : STD_LOGIC;
  signal \could_multi_bursts.araddr_buf_reg[8]_i_2_n_9\ : STD_LOGIC;
  signal \could_multi_bursts.arlen_buf[3]_i_3_n_2\ : STD_LOGIC;
  signal \^could_multi_bursts.arlen_buf_reg[3]_0\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \could_multi_bursts.loop_cnt_reg__0\ : STD_LOGIC_VECTOR ( 5 downto 0 );
  signal \could_multi_bursts.sect_handling_reg_n_2\ : STD_LOGIC;
  signal data_pack : STD_LOGIC_VECTOR ( 34 to 34 );
  signal \end_addr_buf[2]_i_1__0_n_2\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[10]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[11]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[12]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[13]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[14]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[15]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[16]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[17]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[18]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[19]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[20]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[21]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[22]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[23]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[24]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[25]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[26]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[27]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[28]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[29]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[2]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[30]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[31]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[3]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[4]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[5]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[6]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[7]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[8]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[9]\ : STD_LOGIC;
  signal \end_addr_carry__0_i_1__0_n_2\ : STD_LOGIC;
  signal \end_addr_carry__0_i_2__0_n_2\ : STD_LOGIC;
  signal \end_addr_carry__0_i_3__0_n_2\ : STD_LOGIC;
  signal \end_addr_carry__0_i_4__0_n_2\ : STD_LOGIC;
  signal \end_addr_carry__0_n_2\ : STD_LOGIC;
  signal \end_addr_carry__0_n_3\ : STD_LOGIC;
  signal \end_addr_carry__0_n_4\ : STD_LOGIC;
  signal \end_addr_carry__0_n_5\ : STD_LOGIC;
  signal \end_addr_carry__0_n_6\ : STD_LOGIC;
  signal \end_addr_carry__0_n_7\ : STD_LOGIC;
  signal \end_addr_carry__0_n_8\ : STD_LOGIC;
  signal \end_addr_carry__0_n_9\ : STD_LOGIC;
  signal \end_addr_carry__1_i_1__0_n_2\ : STD_LOGIC;
  signal \end_addr_carry__1_i_2__0_n_2\ : STD_LOGIC;
  signal \end_addr_carry__1_i_3__0_n_2\ : STD_LOGIC;
  signal \end_addr_carry__1_i_4__0_n_2\ : STD_LOGIC;
  signal \end_addr_carry__1_n_2\ : STD_LOGIC;
  signal \end_addr_carry__1_n_3\ : STD_LOGIC;
  signal \end_addr_carry__1_n_4\ : STD_LOGIC;
  signal \end_addr_carry__1_n_5\ : STD_LOGIC;
  signal \end_addr_carry__1_n_6\ : STD_LOGIC;
  signal \end_addr_carry__1_n_7\ : STD_LOGIC;
  signal \end_addr_carry__1_n_8\ : STD_LOGIC;
  signal \end_addr_carry__1_n_9\ : STD_LOGIC;
  signal \end_addr_carry__2_i_1__0_n_2\ : STD_LOGIC;
  signal \end_addr_carry__2_i_2__0_n_2\ : STD_LOGIC;
  signal \end_addr_carry__2_i_3__0_n_2\ : STD_LOGIC;
  signal \end_addr_carry__2_i_4__0_n_2\ : STD_LOGIC;
  signal \end_addr_carry__2_n_2\ : STD_LOGIC;
  signal \end_addr_carry__2_n_3\ : STD_LOGIC;
  signal \end_addr_carry__2_n_4\ : STD_LOGIC;
  signal \end_addr_carry__2_n_5\ : STD_LOGIC;
  signal \end_addr_carry__2_n_6\ : STD_LOGIC;
  signal \end_addr_carry__2_n_7\ : STD_LOGIC;
  signal \end_addr_carry__2_n_8\ : STD_LOGIC;
  signal \end_addr_carry__2_n_9\ : STD_LOGIC;
  signal \end_addr_carry__3_i_1__0_n_2\ : STD_LOGIC;
  signal \end_addr_carry__3_i_2__0_n_2\ : STD_LOGIC;
  signal \end_addr_carry__3_i_3__0_n_2\ : STD_LOGIC;
  signal \end_addr_carry__3_i_4__0_n_2\ : STD_LOGIC;
  signal \end_addr_carry__3_n_2\ : STD_LOGIC;
  signal \end_addr_carry__3_n_3\ : STD_LOGIC;
  signal \end_addr_carry__3_n_4\ : STD_LOGIC;
  signal \end_addr_carry__3_n_5\ : STD_LOGIC;
  signal \end_addr_carry__3_n_6\ : STD_LOGIC;
  signal \end_addr_carry__3_n_7\ : STD_LOGIC;
  signal \end_addr_carry__3_n_8\ : STD_LOGIC;
  signal \end_addr_carry__3_n_9\ : STD_LOGIC;
  signal \end_addr_carry__4_i_1__0_n_2\ : STD_LOGIC;
  signal \end_addr_carry__4_i_2__0_n_2\ : STD_LOGIC;
  signal \end_addr_carry__4_i_3__0_n_2\ : STD_LOGIC;
  signal \end_addr_carry__4_i_4__0_n_2\ : STD_LOGIC;
  signal \end_addr_carry__4_n_2\ : STD_LOGIC;
  signal \end_addr_carry__4_n_3\ : STD_LOGIC;
  signal \end_addr_carry__4_n_4\ : STD_LOGIC;
  signal \end_addr_carry__4_n_5\ : STD_LOGIC;
  signal \end_addr_carry__4_n_6\ : STD_LOGIC;
  signal \end_addr_carry__4_n_7\ : STD_LOGIC;
  signal \end_addr_carry__4_n_8\ : STD_LOGIC;
  signal \end_addr_carry__4_n_9\ : STD_LOGIC;
  signal \end_addr_carry__5_i_1__0_n_2\ : STD_LOGIC;
  signal \end_addr_carry__5_i_2__0_n_2\ : STD_LOGIC;
  signal \end_addr_carry__5_i_3__0_n_2\ : STD_LOGIC;
  signal \end_addr_carry__5_i_4__0_n_2\ : STD_LOGIC;
  signal \end_addr_carry__5_n_2\ : STD_LOGIC;
  signal \end_addr_carry__5_n_3\ : STD_LOGIC;
  signal \end_addr_carry__5_n_4\ : STD_LOGIC;
  signal \end_addr_carry__5_n_5\ : STD_LOGIC;
  signal \end_addr_carry__5_n_6\ : STD_LOGIC;
  signal \end_addr_carry__5_n_7\ : STD_LOGIC;
  signal \end_addr_carry__5_n_8\ : STD_LOGIC;
  signal \end_addr_carry__5_n_9\ : STD_LOGIC;
  signal \end_addr_carry__6_i_1__0_n_2\ : STD_LOGIC;
  signal \end_addr_carry__6_i_2__0_n_2\ : STD_LOGIC;
  signal \end_addr_carry__6_n_5\ : STD_LOGIC;
  signal \end_addr_carry__6_n_8\ : STD_LOGIC;
  signal \end_addr_carry__6_n_9\ : STD_LOGIC;
  signal \end_addr_carry_i_1__0_n_2\ : STD_LOGIC;
  signal \end_addr_carry_i_2__0_n_2\ : STD_LOGIC;
  signal \end_addr_carry_i_3__0_n_2\ : STD_LOGIC;
  signal \end_addr_carry_i_4__0_n_2\ : STD_LOGIC;
  signal end_addr_carry_n_2 : STD_LOGIC;
  signal end_addr_carry_n_3 : STD_LOGIC;
  signal end_addr_carry_n_4 : STD_LOGIC;
  signal end_addr_carry_n_5 : STD_LOGIC;
  signal end_addr_carry_n_6 : STD_LOGIC;
  signal end_addr_carry_n_7 : STD_LOGIC;
  signal end_addr_carry_n_8 : STD_LOGIC;
  signal fifo_rctl_n_10 : STD_LOGIC;
  signal fifo_rctl_n_11 : STD_LOGIC;
  signal fifo_rctl_n_12 : STD_LOGIC;
  signal fifo_rctl_n_13 : STD_LOGIC;
  signal fifo_rctl_n_14 : STD_LOGIC;
  signal fifo_rctl_n_15 : STD_LOGIC;
  signal fifo_rctl_n_16 : STD_LOGIC;
  signal fifo_rctl_n_17 : STD_LOGIC;
  signal fifo_rctl_n_18 : STD_LOGIC;
  signal fifo_rctl_n_19 : STD_LOGIC;
  signal fifo_rctl_n_2 : STD_LOGIC;
  signal fifo_rctl_n_20 : STD_LOGIC;
  signal fifo_rctl_n_21 : STD_LOGIC;
  signal fifo_rctl_n_22 : STD_LOGIC;
  signal fifo_rctl_n_23 : STD_LOGIC;
  signal fifo_rctl_n_24 : STD_LOGIC;
  signal fifo_rctl_n_25 : STD_LOGIC;
  signal fifo_rctl_n_26 : STD_LOGIC;
  signal fifo_rctl_n_27 : STD_LOGIC;
  signal fifo_rctl_n_28 : STD_LOGIC;
  signal fifo_rctl_n_4 : STD_LOGIC;
  signal fifo_rctl_n_6 : STD_LOGIC;
  signal fifo_rctl_n_7 : STD_LOGIC;
  signal fifo_rctl_n_9 : STD_LOGIC;
  signal fifo_rreq_data : STD_LOGIC_VECTOR ( 60 downto 32 );
  signal fifo_rreq_n_10 : STD_LOGIC;
  signal fifo_rreq_n_100 : STD_LOGIC;
  signal fifo_rreq_n_101 : STD_LOGIC;
  signal fifo_rreq_n_102 : STD_LOGIC;
  signal fifo_rreq_n_103 : STD_LOGIC;
  signal fifo_rreq_n_104 : STD_LOGIC;
  signal fifo_rreq_n_105 : STD_LOGIC;
  signal fifo_rreq_n_106 : STD_LOGIC;
  signal fifo_rreq_n_107 : STD_LOGIC;
  signal fifo_rreq_n_108 : STD_LOGIC;
  signal fifo_rreq_n_109 : STD_LOGIC;
  signal fifo_rreq_n_11 : STD_LOGIC;
  signal fifo_rreq_n_110 : STD_LOGIC;
  signal fifo_rreq_n_111 : STD_LOGIC;
  signal fifo_rreq_n_112 : STD_LOGIC;
  signal fifo_rreq_n_113 : STD_LOGIC;
  signal fifo_rreq_n_114 : STD_LOGIC;
  signal fifo_rreq_n_115 : STD_LOGIC;
  signal fifo_rreq_n_116 : STD_LOGIC;
  signal fifo_rreq_n_117 : STD_LOGIC;
  signal fifo_rreq_n_118 : STD_LOGIC;
  signal fifo_rreq_n_119 : STD_LOGIC;
  signal fifo_rreq_n_12 : STD_LOGIC;
  signal fifo_rreq_n_120 : STD_LOGIC;
  signal fifo_rreq_n_121 : STD_LOGIC;
  signal fifo_rreq_n_122 : STD_LOGIC;
  signal fifo_rreq_n_13 : STD_LOGIC;
  signal fifo_rreq_n_14 : STD_LOGIC;
  signal fifo_rreq_n_15 : STD_LOGIC;
  signal fifo_rreq_n_16 : STD_LOGIC;
  signal fifo_rreq_n_17 : STD_LOGIC;
  signal fifo_rreq_n_18 : STD_LOGIC;
  signal fifo_rreq_n_19 : STD_LOGIC;
  signal fifo_rreq_n_20 : STD_LOGIC;
  signal fifo_rreq_n_21 : STD_LOGIC;
  signal fifo_rreq_n_22 : STD_LOGIC;
  signal fifo_rreq_n_23 : STD_LOGIC;
  signal fifo_rreq_n_25 : STD_LOGIC;
  signal fifo_rreq_n_26 : STD_LOGIC;
  signal fifo_rreq_n_27 : STD_LOGIC;
  signal fifo_rreq_n_28 : STD_LOGIC;
  signal fifo_rreq_n_29 : STD_LOGIC;
  signal fifo_rreq_n_4 : STD_LOGIC;
  signal fifo_rreq_n_5 : STD_LOGIC;
  signal fifo_rreq_n_59 : STD_LOGIC;
  signal fifo_rreq_n_6 : STD_LOGIC;
  signal fifo_rreq_n_60 : STD_LOGIC;
  signal fifo_rreq_n_61 : STD_LOGIC;
  signal fifo_rreq_n_62 : STD_LOGIC;
  signal fifo_rreq_n_63 : STD_LOGIC;
  signal fifo_rreq_n_64 : STD_LOGIC;
  signal fifo_rreq_n_65 : STD_LOGIC;
  signal fifo_rreq_n_66 : STD_LOGIC;
  signal fifo_rreq_n_67 : STD_LOGIC;
  signal fifo_rreq_n_68 : STD_LOGIC;
  signal fifo_rreq_n_69 : STD_LOGIC;
  signal fifo_rreq_n_7 : STD_LOGIC;
  signal fifo_rreq_n_70 : STD_LOGIC;
  signal fifo_rreq_n_71 : STD_LOGIC;
  signal fifo_rreq_n_72 : STD_LOGIC;
  signal fifo_rreq_n_73 : STD_LOGIC;
  signal fifo_rreq_n_74 : STD_LOGIC;
  signal fifo_rreq_n_75 : STD_LOGIC;
  signal fifo_rreq_n_76 : STD_LOGIC;
  signal fifo_rreq_n_77 : STD_LOGIC;
  signal fifo_rreq_n_78 : STD_LOGIC;
  signal fifo_rreq_n_79 : STD_LOGIC;
  signal fifo_rreq_n_8 : STD_LOGIC;
  signal fifo_rreq_n_80 : STD_LOGIC;
  signal fifo_rreq_n_81 : STD_LOGIC;
  signal fifo_rreq_n_82 : STD_LOGIC;
  signal fifo_rreq_n_83 : STD_LOGIC;
  signal fifo_rreq_n_84 : STD_LOGIC;
  signal fifo_rreq_n_85 : STD_LOGIC;
  signal fifo_rreq_n_86 : STD_LOGIC;
  signal fifo_rreq_n_87 : STD_LOGIC;
  signal fifo_rreq_n_88 : STD_LOGIC;
  signal fifo_rreq_n_89 : STD_LOGIC;
  signal fifo_rreq_n_9 : STD_LOGIC;
  signal fifo_rreq_n_90 : STD_LOGIC;
  signal fifo_rreq_n_91 : STD_LOGIC;
  signal fifo_rreq_n_92 : STD_LOGIC;
  signal fifo_rreq_n_93 : STD_LOGIC;
  signal fifo_rreq_n_94 : STD_LOGIC;
  signal fifo_rreq_n_95 : STD_LOGIC;
  signal fifo_rreq_n_96 : STD_LOGIC;
  signal fifo_rreq_n_97 : STD_LOGIC;
  signal fifo_rreq_n_98 : STD_LOGIC;
  signal fifo_rreq_n_99 : STD_LOGIC;
  signal fifo_rreq_valid : STD_LOGIC;
  signal fifo_rreq_valid_buf_reg_n_2 : STD_LOGIC;
  signal first_sect : STD_LOGIC;
  signal \first_sect_carry__0_i_1__0_n_2\ : STD_LOGIC;
  signal \first_sect_carry__0_i_2__0_n_2\ : STD_LOGIC;
  signal \first_sect_carry__0_i_3__0_n_2\ : STD_LOGIC;
  signal \first_sect_carry__0_n_4\ : STD_LOGIC;
  signal \first_sect_carry__0_n_5\ : STD_LOGIC;
  signal \first_sect_carry_i_1__0_n_2\ : STD_LOGIC;
  signal \first_sect_carry_i_2__0_n_2\ : STD_LOGIC;
  signal \first_sect_carry_i_3__0_n_2\ : STD_LOGIC;
  signal \first_sect_carry_i_4__0_n_2\ : STD_LOGIC;
  signal first_sect_carry_n_2 : STD_LOGIC;
  signal first_sect_carry_n_3 : STD_LOGIC;
  signal first_sect_carry_n_4 : STD_LOGIC;
  signal first_sect_carry_n_5 : STD_LOGIC;
  signal invalid_len_event : STD_LOGIC;
  signal invalid_len_event0 : STD_LOGIC;
  signal invalid_len_event_reg1_reg_n_2 : STD_LOGIC;
  signal invalid_len_event_reg2 : STD_LOGIC;
  signal last_sect : STD_LOGIC;
  signal \last_sect_carry__0_n_4\ : STD_LOGIC;
  signal \last_sect_carry__0_n_5\ : STD_LOGIC;
  signal last_sect_carry_n_2 : STD_LOGIC;
  signal last_sect_carry_n_3 : STD_LOGIC;
  signal last_sect_carry_n_4 : STD_LOGIC;
  signal last_sect_carry_n_5 : STD_LOGIC;
  signal \^m_axi_gmem_araddr\ : STD_LOGIC_VECTOR ( 29 downto 0 );
  signal next_beat : STD_LOGIC;
  signal next_rreq : STD_LOGIC;
  signal \p_0_in__2\ : STD_LOGIC_VECTOR ( 5 downto 0 );
  signal p_1_in : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal p_21_in : STD_LOGIC;
  signal push : STD_LOGIC;
  signal push_0 : STD_LOGIC;
  signal rdata_ack_t : STD_LOGIC;
  signal rreq_handling_reg_n_2 : STD_LOGIC;
  signal rs2f_rreq_ack : STD_LOGIC;
  signal rs2f_rreq_data : STD_LOGIC_VECTOR ( 63 downto 0 );
  signal \sect_addr_buf[10]_i_1__0_n_2\ : STD_LOGIC;
  signal \sect_addr_buf[11]_i_2__0_n_2\ : STD_LOGIC;
  signal \sect_addr_buf[12]_i_1__0_n_2\ : STD_LOGIC;
  signal \sect_addr_buf[13]_i_1__0_n_2\ : STD_LOGIC;
  signal \sect_addr_buf[14]_i_1__0_n_2\ : STD_LOGIC;
  signal \sect_addr_buf[15]_i_1__0_n_2\ : STD_LOGIC;
  signal \sect_addr_buf[16]_i_1__0_n_2\ : STD_LOGIC;
  signal \sect_addr_buf[17]_i_1__0_n_2\ : STD_LOGIC;
  signal \sect_addr_buf[18]_i_1__0_n_2\ : STD_LOGIC;
  signal \sect_addr_buf[19]_i_1__0_n_2\ : STD_LOGIC;
  signal \sect_addr_buf[20]_i_1__0_n_2\ : STD_LOGIC;
  signal \sect_addr_buf[21]_i_1__0_n_2\ : STD_LOGIC;
  signal \sect_addr_buf[22]_i_1__0_n_2\ : STD_LOGIC;
  signal \sect_addr_buf[23]_i_1__0_n_2\ : STD_LOGIC;
  signal \sect_addr_buf[24]_i_1__0_n_2\ : STD_LOGIC;
  signal \sect_addr_buf[25]_i_1__0_n_2\ : STD_LOGIC;
  signal \sect_addr_buf[26]_i_1__0_n_2\ : STD_LOGIC;
  signal \sect_addr_buf[27]_i_1__0_n_2\ : STD_LOGIC;
  signal \sect_addr_buf[28]_i_1__0_n_2\ : STD_LOGIC;
  signal \sect_addr_buf[29]_i_1__0_n_2\ : STD_LOGIC;
  signal \sect_addr_buf[2]_i_1__0_n_2\ : STD_LOGIC;
  signal \sect_addr_buf[30]_i_1__0_n_2\ : STD_LOGIC;
  signal \sect_addr_buf[31]_i_1__0_n_2\ : STD_LOGIC;
  signal \sect_addr_buf[3]_i_1__0_n_2\ : STD_LOGIC;
  signal \sect_addr_buf[4]_i_1__0_n_2\ : STD_LOGIC;
  signal \sect_addr_buf[5]_i_1__0_n_2\ : STD_LOGIC;
  signal \sect_addr_buf[6]_i_1__0_n_2\ : STD_LOGIC;
  signal \sect_addr_buf[7]_i_1__0_n_2\ : STD_LOGIC;
  signal \sect_addr_buf[8]_i_1__0_n_2\ : STD_LOGIC;
  signal \sect_addr_buf[9]_i_1__0_n_2\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[10]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[11]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[12]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[13]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[14]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[15]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[16]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[17]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[18]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[19]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[20]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[21]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[22]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[23]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[24]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[25]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[26]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[27]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[28]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[29]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[2]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[30]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[31]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[3]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[4]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[5]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[6]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[7]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[8]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[9]\ : STD_LOGIC;
  signal \sect_cnt0_carry__0_n_2\ : STD_LOGIC;
  signal \sect_cnt0_carry__0_n_3\ : STD_LOGIC;
  signal \sect_cnt0_carry__0_n_4\ : STD_LOGIC;
  signal \sect_cnt0_carry__0_n_5\ : STD_LOGIC;
  signal \sect_cnt0_carry__0_n_6\ : STD_LOGIC;
  signal \sect_cnt0_carry__0_n_7\ : STD_LOGIC;
  signal \sect_cnt0_carry__0_n_8\ : STD_LOGIC;
  signal \sect_cnt0_carry__0_n_9\ : STD_LOGIC;
  signal \sect_cnt0_carry__1_n_2\ : STD_LOGIC;
  signal \sect_cnt0_carry__1_n_3\ : STD_LOGIC;
  signal \sect_cnt0_carry__1_n_4\ : STD_LOGIC;
  signal \sect_cnt0_carry__1_n_5\ : STD_LOGIC;
  signal \sect_cnt0_carry__1_n_6\ : STD_LOGIC;
  signal \sect_cnt0_carry__1_n_7\ : STD_LOGIC;
  signal \sect_cnt0_carry__1_n_8\ : STD_LOGIC;
  signal \sect_cnt0_carry__1_n_9\ : STD_LOGIC;
  signal \sect_cnt0_carry__2_n_2\ : STD_LOGIC;
  signal \sect_cnt0_carry__2_n_3\ : STD_LOGIC;
  signal \sect_cnt0_carry__2_n_4\ : STD_LOGIC;
  signal \sect_cnt0_carry__2_n_5\ : STD_LOGIC;
  signal \sect_cnt0_carry__2_n_6\ : STD_LOGIC;
  signal \sect_cnt0_carry__2_n_7\ : STD_LOGIC;
  signal \sect_cnt0_carry__2_n_8\ : STD_LOGIC;
  signal \sect_cnt0_carry__2_n_9\ : STD_LOGIC;
  signal \sect_cnt0_carry__3_n_4\ : STD_LOGIC;
  signal \sect_cnt0_carry__3_n_5\ : STD_LOGIC;
  signal \sect_cnt0_carry__3_n_7\ : STD_LOGIC;
  signal \sect_cnt0_carry__3_n_8\ : STD_LOGIC;
  signal \sect_cnt0_carry__3_n_9\ : STD_LOGIC;
  signal sect_cnt0_carry_n_2 : STD_LOGIC;
  signal sect_cnt0_carry_n_3 : STD_LOGIC;
  signal sect_cnt0_carry_n_4 : STD_LOGIC;
  signal sect_cnt0_carry_n_5 : STD_LOGIC;
  signal sect_cnt0_carry_n_6 : STD_LOGIC;
  signal sect_cnt0_carry_n_7 : STD_LOGIC;
  signal sect_cnt0_carry_n_8 : STD_LOGIC;
  signal sect_cnt0_carry_n_9 : STD_LOGIC;
  signal \sect_cnt_reg_n_2_[0]\ : STD_LOGIC;
  signal \sect_cnt_reg_n_2_[10]\ : STD_LOGIC;
  signal \sect_cnt_reg_n_2_[11]\ : STD_LOGIC;
  signal \sect_cnt_reg_n_2_[12]\ : STD_LOGIC;
  signal \sect_cnt_reg_n_2_[13]\ : STD_LOGIC;
  signal \sect_cnt_reg_n_2_[14]\ : STD_LOGIC;
  signal \sect_cnt_reg_n_2_[15]\ : STD_LOGIC;
  signal \sect_cnt_reg_n_2_[16]\ : STD_LOGIC;
  signal \sect_cnt_reg_n_2_[17]\ : STD_LOGIC;
  signal \sect_cnt_reg_n_2_[18]\ : STD_LOGIC;
  signal \sect_cnt_reg_n_2_[19]\ : STD_LOGIC;
  signal \sect_cnt_reg_n_2_[1]\ : STD_LOGIC;
  signal \sect_cnt_reg_n_2_[2]\ : STD_LOGIC;
  signal \sect_cnt_reg_n_2_[3]\ : STD_LOGIC;
  signal \sect_cnt_reg_n_2_[4]\ : STD_LOGIC;
  signal \sect_cnt_reg_n_2_[5]\ : STD_LOGIC;
  signal \sect_cnt_reg_n_2_[6]\ : STD_LOGIC;
  signal \sect_cnt_reg_n_2_[7]\ : STD_LOGIC;
  signal \sect_cnt_reg_n_2_[8]\ : STD_LOGIC;
  signal \sect_cnt_reg_n_2_[9]\ : STD_LOGIC;
  signal \sect_len_buf_reg_n_2_[4]\ : STD_LOGIC;
  signal \sect_len_buf_reg_n_2_[5]\ : STD_LOGIC;
  signal \sect_len_buf_reg_n_2_[6]\ : STD_LOGIC;
  signal \sect_len_buf_reg_n_2_[7]\ : STD_LOGIC;
  signal \sect_len_buf_reg_n_2_[8]\ : STD_LOGIC;
  signal \sect_len_buf_reg_n_2_[9]\ : STD_LOGIC;
  signal \start_addr_buf_reg_n_2_[10]\ : STD_LOGIC;
  signal \start_addr_buf_reg_n_2_[11]\ : STD_LOGIC;
  signal \start_addr_buf_reg_n_2_[12]\ : STD_LOGIC;
  signal \start_addr_buf_reg_n_2_[13]\ : STD_LOGIC;
  signal \start_addr_buf_reg_n_2_[14]\ : STD_LOGIC;
  signal \start_addr_buf_reg_n_2_[15]\ : STD_LOGIC;
  signal \start_addr_buf_reg_n_2_[16]\ : STD_LOGIC;
  signal \start_addr_buf_reg_n_2_[17]\ : STD_LOGIC;
  signal \start_addr_buf_reg_n_2_[18]\ : STD_LOGIC;
  signal \start_addr_buf_reg_n_2_[19]\ : STD_LOGIC;
  signal \start_addr_buf_reg_n_2_[20]\ : STD_LOGIC;
  signal \start_addr_buf_reg_n_2_[21]\ : STD_LOGIC;
  signal \start_addr_buf_reg_n_2_[22]\ : STD_LOGIC;
  signal \start_addr_buf_reg_n_2_[23]\ : STD_LOGIC;
  signal \start_addr_buf_reg_n_2_[24]\ : STD_LOGIC;
  signal \start_addr_buf_reg_n_2_[25]\ : STD_LOGIC;
  signal \start_addr_buf_reg_n_2_[26]\ : STD_LOGIC;
  signal \start_addr_buf_reg_n_2_[27]\ : STD_LOGIC;
  signal \start_addr_buf_reg_n_2_[28]\ : STD_LOGIC;
  signal \start_addr_buf_reg_n_2_[29]\ : STD_LOGIC;
  signal \start_addr_buf_reg_n_2_[2]\ : STD_LOGIC;
  signal \start_addr_buf_reg_n_2_[30]\ : STD_LOGIC;
  signal \start_addr_buf_reg_n_2_[31]\ : STD_LOGIC;
  signal \start_addr_buf_reg_n_2_[3]\ : STD_LOGIC;
  signal \start_addr_buf_reg_n_2_[4]\ : STD_LOGIC;
  signal \start_addr_buf_reg_n_2_[5]\ : STD_LOGIC;
  signal \start_addr_buf_reg_n_2_[6]\ : STD_LOGIC;
  signal \start_addr_buf_reg_n_2_[7]\ : STD_LOGIC;
  signal \start_addr_buf_reg_n_2_[8]\ : STD_LOGIC;
  signal \start_addr_buf_reg_n_2_[9]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[10]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[11]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[12]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[13]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[14]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[15]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[16]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[17]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[18]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[19]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[20]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[21]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[22]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[23]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[24]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[25]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[26]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[27]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[28]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[29]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[2]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[30]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[31]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[3]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[4]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[5]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[6]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[7]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[8]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[9]\ : STD_LOGIC;
  signal NLW_align_len0_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \NLW_align_len0_carry__6_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal \NLW_align_len0_carry__6_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_could_multi_bursts.araddr_buf_reg[31]_i_3_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal \NLW_could_multi_bursts.araddr_buf_reg[31]_i_3_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_could_multi_bursts.araddr_buf_reg[4]_i_2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_end_addr_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \NLW_end_addr_carry__6_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal \NLW_end_addr_carry__6_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal NLW_first_sect_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_first_sect_carry__0_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_first_sect_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_last_sect_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_last_sect_carry__0_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_last_sect_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_sect_cnt0_carry__3_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal \NLW_sect_cnt0_carry__3_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  attribute METHODOLOGY_DRC_VIOS : string;
  attribute METHODOLOGY_DRC_VIOS of align_len0_carry : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \align_len0_carry__0\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \align_len0_carry__1\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \align_len0_carry__2\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \align_len0_carry__3\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \align_len0_carry__4\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \align_len0_carry__5\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \align_len0_carry__6\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \could_multi_bursts.araddr_buf[10]_i_1\ : label is "soft_lutpair98";
  attribute SOFT_HLUTNM of \could_multi_bursts.araddr_buf[11]_i_1\ : label is "soft_lutpair99";
  attribute SOFT_HLUTNM of \could_multi_bursts.araddr_buf[12]_i_1\ : label is "soft_lutpair99";
  attribute SOFT_HLUTNM of \could_multi_bursts.araddr_buf[13]_i_1\ : label is "soft_lutpair98";
  attribute SOFT_HLUTNM of \could_multi_bursts.araddr_buf[14]_i_1\ : label is "soft_lutpair96";
  attribute SOFT_HLUTNM of \could_multi_bursts.araddr_buf[15]_i_1\ : label is "soft_lutpair97";
  attribute SOFT_HLUTNM of \could_multi_bursts.araddr_buf[16]_i_1\ : label is "soft_lutpair97";
  attribute SOFT_HLUTNM of \could_multi_bursts.araddr_buf[17]_i_1\ : label is "soft_lutpair95";
  attribute SOFT_HLUTNM of \could_multi_bursts.araddr_buf[18]_i_1\ : label is "soft_lutpair94";
  attribute SOFT_HLUTNM of \could_multi_bursts.araddr_buf[19]_i_1\ : label is "soft_lutpair96";
  attribute SOFT_HLUTNM of \could_multi_bursts.araddr_buf[20]_i_1\ : label is "soft_lutpair95";
  attribute SOFT_HLUTNM of \could_multi_bursts.araddr_buf[21]_i_1\ : label is "soft_lutpair94";
  attribute SOFT_HLUTNM of \could_multi_bursts.araddr_buf[22]_i_1\ : label is "soft_lutpair92";
  attribute SOFT_HLUTNM of \could_multi_bursts.araddr_buf[23]_i_1\ : label is "soft_lutpair93";
  attribute SOFT_HLUTNM of \could_multi_bursts.araddr_buf[24]_i_1\ : label is "soft_lutpair93";
  attribute SOFT_HLUTNM of \could_multi_bursts.araddr_buf[25]_i_1\ : label is "soft_lutpair92";
  attribute SOFT_HLUTNM of \could_multi_bursts.araddr_buf[26]_i_1\ : label is "soft_lutpair90";
  attribute SOFT_HLUTNM of \could_multi_bursts.araddr_buf[27]_i_1\ : label is "soft_lutpair91";
  attribute SOFT_HLUTNM of \could_multi_bursts.araddr_buf[28]_i_1\ : label is "soft_lutpair91";
  attribute SOFT_HLUTNM of \could_multi_bursts.araddr_buf[29]_i_1\ : label is "soft_lutpair89";
  attribute SOFT_HLUTNM of \could_multi_bursts.araddr_buf[2]_i_1\ : label is "soft_lutpair114";
  attribute SOFT_HLUTNM of \could_multi_bursts.araddr_buf[30]_i_1\ : label is "soft_lutpair89";
  attribute SOFT_HLUTNM of \could_multi_bursts.araddr_buf[31]_i_2\ : label is "soft_lutpair90";
  attribute SOFT_HLUTNM of \could_multi_bursts.araddr_buf[3]_i_1\ : label is "soft_lutpair112";
  attribute SOFT_HLUTNM of \could_multi_bursts.araddr_buf[4]_i_1\ : label is "soft_lutpair114";
  attribute SOFT_HLUTNM of \could_multi_bursts.araddr_buf[5]_i_1\ : label is "soft_lutpair112";
  attribute SOFT_HLUTNM of \could_multi_bursts.araddr_buf[6]_i_1\ : label is "soft_lutpair100";
  attribute SOFT_HLUTNM of \could_multi_bursts.araddr_buf[7]_i_1\ : label is "soft_lutpair101";
  attribute SOFT_HLUTNM of \could_multi_bursts.araddr_buf[8]_i_1\ : label is "soft_lutpair101";
  attribute SOFT_HLUTNM of \could_multi_bursts.araddr_buf[9]_i_1\ : label is "soft_lutpair100";
  attribute METHODOLOGY_DRC_VIOS of \could_multi_bursts.araddr_buf_reg[12]_i_2\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \could_multi_bursts.araddr_buf_reg[16]_i_2\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \could_multi_bursts.araddr_buf_reg[20]_i_2\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \could_multi_bursts.araddr_buf_reg[24]_i_2\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \could_multi_bursts.araddr_buf_reg[28]_i_2\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \could_multi_bursts.araddr_buf_reg[31]_i_3\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \could_multi_bursts.araddr_buf_reg[4]_i_2\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \could_multi_bursts.araddr_buf_reg[8]_i_2\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute SOFT_HLUTNM of \could_multi_bursts.loop_cnt[1]_i_1__0\ : label is "soft_lutpair113";
  attribute SOFT_HLUTNM of \could_multi_bursts.loop_cnt[2]_i_1__0\ : label is "soft_lutpair113";
  attribute SOFT_HLUTNM of \could_multi_bursts.loop_cnt[3]_i_1__0\ : label is "soft_lutpair88";
  attribute SOFT_HLUTNM of \could_multi_bursts.loop_cnt[4]_i_1__0\ : label is "soft_lutpair88";
  attribute METHODOLOGY_DRC_VIOS of end_addr_carry : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \end_addr_carry__0\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \end_addr_carry__1\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \end_addr_carry__2\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \end_addr_carry__3\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \end_addr_carry__4\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \end_addr_carry__5\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \end_addr_carry__6\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of first_sect_carry : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \first_sect_carry__0\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of last_sect_carry : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \last_sect_carry__0\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute SOFT_HLUTNM of \sect_addr_buf[10]_i_1__0\ : label is "soft_lutpair116";
  attribute SOFT_HLUTNM of \sect_addr_buf[11]_i_2__0\ : label is "soft_lutpair115";
  attribute SOFT_HLUTNM of \sect_addr_buf[12]_i_1__0\ : label is "soft_lutpair111";
  attribute SOFT_HLUTNM of \sect_addr_buf[13]_i_1__0\ : label is "soft_lutpair111";
  attribute SOFT_HLUTNM of \sect_addr_buf[14]_i_1__0\ : label is "soft_lutpair110";
  attribute SOFT_HLUTNM of \sect_addr_buf[15]_i_1__0\ : label is "soft_lutpair110";
  attribute SOFT_HLUTNM of \sect_addr_buf[16]_i_1__0\ : label is "soft_lutpair109";
  attribute SOFT_HLUTNM of \sect_addr_buf[17]_i_1__0\ : label is "soft_lutpair109";
  attribute SOFT_HLUTNM of \sect_addr_buf[18]_i_1__0\ : label is "soft_lutpair108";
  attribute SOFT_HLUTNM of \sect_addr_buf[19]_i_1__0\ : label is "soft_lutpair108";
  attribute SOFT_HLUTNM of \sect_addr_buf[20]_i_1__0\ : label is "soft_lutpair107";
  attribute SOFT_HLUTNM of \sect_addr_buf[21]_i_1__0\ : label is "soft_lutpair107";
  attribute SOFT_HLUTNM of \sect_addr_buf[22]_i_1__0\ : label is "soft_lutpair106";
  attribute SOFT_HLUTNM of \sect_addr_buf[23]_i_1__0\ : label is "soft_lutpair106";
  attribute SOFT_HLUTNM of \sect_addr_buf[24]_i_1__0\ : label is "soft_lutpair105";
  attribute SOFT_HLUTNM of \sect_addr_buf[25]_i_1__0\ : label is "soft_lutpair105";
  attribute SOFT_HLUTNM of \sect_addr_buf[26]_i_1__0\ : label is "soft_lutpair104";
  attribute SOFT_HLUTNM of \sect_addr_buf[27]_i_1__0\ : label is "soft_lutpair104";
  attribute SOFT_HLUTNM of \sect_addr_buf[28]_i_1__0\ : label is "soft_lutpair103";
  attribute SOFT_HLUTNM of \sect_addr_buf[29]_i_1__0\ : label is "soft_lutpair103";
  attribute SOFT_HLUTNM of \sect_addr_buf[2]_i_1__0\ : label is "soft_lutpair119";
  attribute SOFT_HLUTNM of \sect_addr_buf[30]_i_1__0\ : label is "soft_lutpair102";
  attribute SOFT_HLUTNM of \sect_addr_buf[31]_i_1__0\ : label is "soft_lutpair102";
  attribute SOFT_HLUTNM of \sect_addr_buf[3]_i_1__0\ : label is "soft_lutpair117";
  attribute SOFT_HLUTNM of \sect_addr_buf[4]_i_1__0\ : label is "soft_lutpair115";
  attribute SOFT_HLUTNM of \sect_addr_buf[5]_i_1__0\ : label is "soft_lutpair116";
  attribute SOFT_HLUTNM of \sect_addr_buf[6]_i_1__0\ : label is "soft_lutpair118";
  attribute SOFT_HLUTNM of \sect_addr_buf[7]_i_1__0\ : label is "soft_lutpair119";
  attribute SOFT_HLUTNM of \sect_addr_buf[8]_i_1__0\ : label is "soft_lutpair118";
  attribute SOFT_HLUTNM of \sect_addr_buf[9]_i_1__0\ : label is "soft_lutpair117";
  attribute METHODOLOGY_DRC_VIOS of sect_cnt0_carry : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \sect_cnt0_carry__0\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \sect_cnt0_carry__1\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \sect_cnt0_carry__2\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \sect_cnt0_carry__3\ : label is "{SYNTH-8 {cell *THIS*}}";
begin
  SR(0) <= \^sr\(0);
  \could_multi_bursts.ARVALID_Dummy_reg_0\ <= \^could_multi_bursts.arvalid_dummy_reg_0\;
  \could_multi_bursts.arlen_buf_reg[3]_0\(3 downto 0) <= \^could_multi_bursts.arlen_buf_reg[3]_0\(3 downto 0);
  m_axi_gmem_ARADDR(29 downto 0) <= \^m_axi_gmem_araddr\(29 downto 0);
align_len0_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => align_len0_carry_n_2,
      CO(2) => align_len0_carry_n_3,
      CO(1) => align_len0_carry_n_4,
      CO(0) => align_len0_carry_n_5,
      CYINIT => '0',
      DI(3 downto 1) => fifo_rreq_data(34 downto 32),
      DI(0) => '0',
      O(3) => align_len0_carry_n_6,
      O(2) => align_len0_carry_n_7,
      O(1) => align_len0_carry_n_8,
      O(0) => NLW_align_len0_carry_O_UNCONNECTED(0),
      S(3) => fifo_rreq_n_113,
      S(2) => fifo_rreq_n_114,
      S(1) => fifo_rreq_n_115,
      S(0) => '1'
    );
\align_len0_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => align_len0_carry_n_2,
      CO(3) => \align_len0_carry__0_n_2\,
      CO(2) => \align_len0_carry__0_n_3\,
      CO(1) => \align_len0_carry__0_n_4\,
      CO(0) => \align_len0_carry__0_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => fifo_rreq_data(38 downto 35),
      O(3) => \align_len0_carry__0_n_6\,
      O(2) => \align_len0_carry__0_n_7\,
      O(1) => \align_len0_carry__0_n_8\,
      O(0) => \align_len0_carry__0_n_9\,
      S(3) => fifo_rreq_n_109,
      S(2) => fifo_rreq_n_110,
      S(1) => fifo_rreq_n_111,
      S(0) => fifo_rreq_n_112
    );
\align_len0_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \align_len0_carry__0_n_2\,
      CO(3) => \align_len0_carry__1_n_2\,
      CO(2) => \align_len0_carry__1_n_3\,
      CO(1) => \align_len0_carry__1_n_4\,
      CO(0) => \align_len0_carry__1_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => fifo_rreq_data(42 downto 39),
      O(3) => \align_len0_carry__1_n_6\,
      O(2) => \align_len0_carry__1_n_7\,
      O(1) => \align_len0_carry__1_n_8\,
      O(0) => \align_len0_carry__1_n_9\,
      S(3) => fifo_rreq_n_105,
      S(2) => fifo_rreq_n_106,
      S(1) => fifo_rreq_n_107,
      S(0) => fifo_rreq_n_108
    );
\align_len0_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \align_len0_carry__1_n_2\,
      CO(3) => \align_len0_carry__2_n_2\,
      CO(2) => \align_len0_carry__2_n_3\,
      CO(1) => \align_len0_carry__2_n_4\,
      CO(0) => \align_len0_carry__2_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => fifo_rreq_data(46 downto 43),
      O(3) => \align_len0_carry__2_n_6\,
      O(2) => \align_len0_carry__2_n_7\,
      O(1) => \align_len0_carry__2_n_8\,
      O(0) => \align_len0_carry__2_n_9\,
      S(3) => fifo_rreq_n_101,
      S(2) => fifo_rreq_n_102,
      S(1) => fifo_rreq_n_103,
      S(0) => fifo_rreq_n_104
    );
\align_len0_carry__3\: unisim.vcomponents.CARRY4
     port map (
      CI => \align_len0_carry__2_n_2\,
      CO(3) => \align_len0_carry__3_n_2\,
      CO(2) => \align_len0_carry__3_n_3\,
      CO(1) => \align_len0_carry__3_n_4\,
      CO(0) => \align_len0_carry__3_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => fifo_rreq_data(50 downto 47),
      O(3) => \align_len0_carry__3_n_6\,
      O(2) => \align_len0_carry__3_n_7\,
      O(1) => \align_len0_carry__3_n_8\,
      O(0) => \align_len0_carry__3_n_9\,
      S(3) => fifo_rreq_n_97,
      S(2) => fifo_rreq_n_98,
      S(1) => fifo_rreq_n_99,
      S(0) => fifo_rreq_n_100
    );
\align_len0_carry__4\: unisim.vcomponents.CARRY4
     port map (
      CI => \align_len0_carry__3_n_2\,
      CO(3) => \align_len0_carry__4_n_2\,
      CO(2) => \align_len0_carry__4_n_3\,
      CO(1) => \align_len0_carry__4_n_4\,
      CO(0) => \align_len0_carry__4_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => fifo_rreq_data(54 downto 51),
      O(3) => \align_len0_carry__4_n_6\,
      O(2) => \align_len0_carry__4_n_7\,
      O(1) => \align_len0_carry__4_n_8\,
      O(0) => \align_len0_carry__4_n_9\,
      S(3) => fifo_rreq_n_93,
      S(2) => fifo_rreq_n_94,
      S(1) => fifo_rreq_n_95,
      S(0) => fifo_rreq_n_96
    );
\align_len0_carry__5\: unisim.vcomponents.CARRY4
     port map (
      CI => \align_len0_carry__4_n_2\,
      CO(3) => \align_len0_carry__5_n_2\,
      CO(2) => \align_len0_carry__5_n_3\,
      CO(1) => \align_len0_carry__5_n_4\,
      CO(0) => \align_len0_carry__5_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => fifo_rreq_data(58 downto 55),
      O(3) => \align_len0_carry__5_n_6\,
      O(2) => \align_len0_carry__5_n_7\,
      O(1) => \align_len0_carry__5_n_8\,
      O(0) => \align_len0_carry__5_n_9\,
      S(3) => fifo_rreq_n_89,
      S(2) => fifo_rreq_n_90,
      S(1) => fifo_rreq_n_91,
      S(0) => fifo_rreq_n_92
    );
\align_len0_carry__6\: unisim.vcomponents.CARRY4
     port map (
      CI => \align_len0_carry__5_n_2\,
      CO(3 downto 2) => \NLW_align_len0_carry__6_CO_UNCONNECTED\(3 downto 2),
      CO(1) => \align_len0_carry__6_n_4\,
      CO(0) => \align_len0_carry__6_n_5\,
      CYINIT => '0',
      DI(3 downto 2) => B"00",
      DI(1 downto 0) => fifo_rreq_data(60 downto 59),
      O(3) => \NLW_align_len0_carry__6_O_UNCONNECTED\(3),
      O(2) => \align_len0_carry__6_n_7\,
      O(1) => \align_len0_carry__6_n_8\,
      O(0) => \align_len0_carry__6_n_9\,
      S(3) => '0',
      S(2) => fifo_rreq_n_27,
      S(1) => fifo_rreq_n_28,
      S(0) => fifo_rreq_n_29
    );
\align_len_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => \align_len0_carry__1_n_8\,
      Q => \align_len_reg_n_2_[10]\,
      R => \^sr\(0)
    );
\align_len_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => \align_len0_carry__1_n_7\,
      Q => \align_len_reg_n_2_[11]\,
      R => \^sr\(0)
    );
\align_len_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => \align_len0_carry__1_n_6\,
      Q => \align_len_reg_n_2_[12]\,
      R => \^sr\(0)
    );
\align_len_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => \align_len0_carry__2_n_9\,
      Q => \align_len_reg_n_2_[13]\,
      R => \^sr\(0)
    );
\align_len_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => \align_len0_carry__2_n_8\,
      Q => \align_len_reg_n_2_[14]\,
      R => \^sr\(0)
    );
\align_len_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => \align_len0_carry__2_n_7\,
      Q => \align_len_reg_n_2_[15]\,
      R => \^sr\(0)
    );
\align_len_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => \align_len0_carry__2_n_6\,
      Q => \align_len_reg_n_2_[16]\,
      R => \^sr\(0)
    );
\align_len_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => \align_len0_carry__3_n_9\,
      Q => \align_len_reg_n_2_[17]\,
      R => \^sr\(0)
    );
\align_len_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => \align_len0_carry__3_n_8\,
      Q => \align_len_reg_n_2_[18]\,
      R => \^sr\(0)
    );
\align_len_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => \align_len0_carry__3_n_7\,
      Q => \align_len_reg_n_2_[19]\,
      R => \^sr\(0)
    );
\align_len_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => \align_len0_carry__3_n_6\,
      Q => \align_len_reg_n_2_[20]\,
      R => \^sr\(0)
    );
\align_len_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => \align_len0_carry__4_n_9\,
      Q => \align_len_reg_n_2_[21]\,
      R => \^sr\(0)
    );
\align_len_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => \align_len0_carry__4_n_8\,
      Q => \align_len_reg_n_2_[22]\,
      R => \^sr\(0)
    );
\align_len_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => \align_len0_carry__4_n_7\,
      Q => \align_len_reg_n_2_[23]\,
      R => \^sr\(0)
    );
\align_len_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => \align_len0_carry__4_n_6\,
      Q => \align_len_reg_n_2_[24]\,
      R => \^sr\(0)
    );
\align_len_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => \align_len0_carry__5_n_9\,
      Q => \align_len_reg_n_2_[25]\,
      R => \^sr\(0)
    );
\align_len_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => \align_len0_carry__5_n_8\,
      Q => \align_len_reg_n_2_[26]\,
      R => \^sr\(0)
    );
\align_len_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => \align_len0_carry__5_n_7\,
      Q => \align_len_reg_n_2_[27]\,
      R => \^sr\(0)
    );
\align_len_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => \align_len0_carry__5_n_6\,
      Q => \align_len_reg_n_2_[28]\,
      R => \^sr\(0)
    );
\align_len_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => \align_len0_carry__6_n_9\,
      Q => \align_len_reg_n_2_[29]\,
      R => \^sr\(0)
    );
\align_len_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => align_len0_carry_n_8,
      Q => \align_len_reg_n_2_[2]\,
      R => \^sr\(0)
    );
\align_len_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => \align_len0_carry__6_n_8\,
      Q => \align_len_reg_n_2_[30]\,
      R => \^sr\(0)
    );
\align_len_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => \align_len0_carry__6_n_7\,
      Q => \align_len_reg_n_2_[31]\,
      R => \^sr\(0)
    );
\align_len_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => align_len0_carry_n_7,
      Q => \align_len_reg_n_2_[3]\,
      R => \^sr\(0)
    );
\align_len_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => align_len0_carry_n_6,
      Q => \align_len_reg_n_2_[4]\,
      R => \^sr\(0)
    );
\align_len_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => \align_len0_carry__0_n_9\,
      Q => \align_len_reg_n_2_[5]\,
      R => \^sr\(0)
    );
\align_len_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => \align_len0_carry__0_n_8\,
      Q => \align_len_reg_n_2_[6]\,
      R => \^sr\(0)
    );
\align_len_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => \align_len0_carry__0_n_7\,
      Q => \align_len_reg_n_2_[7]\,
      R => \^sr\(0)
    );
\align_len_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => \align_len0_carry__0_n_6\,
      Q => \align_len_reg_n_2_[8]\,
      R => \^sr\(0)
    );
\align_len_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => \align_len0_carry__1_n_9\,
      Q => \align_len_reg_n_2_[9]\,
      R => \^sr\(0)
    );
\beat_len_buf_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \align_len_reg_n_2_[2]\,
      Q => \beat_len_buf_reg_n_2_[0]\,
      R => \^sr\(0)
    );
\beat_len_buf_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \align_len_reg_n_2_[3]\,
      Q => \beat_len_buf_reg_n_2_[1]\,
      R => \^sr\(0)
    );
\beat_len_buf_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \align_len_reg_n_2_[4]\,
      Q => \beat_len_buf_reg_n_2_[2]\,
      R => \^sr\(0)
    );
\beat_len_buf_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \align_len_reg_n_2_[5]\,
      Q => \beat_len_buf_reg_n_2_[3]\,
      R => \^sr\(0)
    );
\beat_len_buf_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \align_len_reg_n_2_[6]\,
      Q => \beat_len_buf_reg_n_2_[4]\,
      R => \^sr\(0)
    );
\beat_len_buf_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \align_len_reg_n_2_[7]\,
      Q => \beat_len_buf_reg_n_2_[5]\,
      R => \^sr\(0)
    );
\beat_len_buf_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \align_len_reg_n_2_[8]\,
      Q => \beat_len_buf_reg_n_2_[6]\,
      R => \^sr\(0)
    );
\beat_len_buf_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \align_len_reg_n_2_[9]\,
      Q => \beat_len_buf_reg_n_2_[7]\,
      R => \^sr\(0)
    );
\beat_len_buf_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \align_len_reg_n_2_[10]\,
      Q => \beat_len_buf_reg_n_2_[8]\,
      R => \^sr\(0)
    );
\beat_len_buf_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \align_len_reg_n_2_[11]\,
      Q => \beat_len_buf_reg_n_2_[9]\,
      R => \^sr\(0)
    );
buff_rdata: entity work.\design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_buffer__parameterized0\
     port map (
      D(32 downto 0) => D(32 downto 0),
      DI(0) => DI(0),
      Q(5 downto 0) => \usedw_reg[5]\(5 downto 0),
      S(3 downto 0) => S(3 downto 0),
      SR(0) => \^sr\(0),
      ap_clk => ap_clk,
      ap_rst_n => ap_rst_n,
      beat_valid => beat_valid,
      \dout_buf_reg[34]_0\(32) => data_pack(34),
      \dout_buf_reg[34]_0\(31) => buff_rdata_n_22,
      \dout_buf_reg[34]_0\(30) => buff_rdata_n_23,
      \dout_buf_reg[34]_0\(29) => buff_rdata_n_24,
      \dout_buf_reg[34]_0\(28) => buff_rdata_n_25,
      \dout_buf_reg[34]_0\(27) => buff_rdata_n_26,
      \dout_buf_reg[34]_0\(26) => buff_rdata_n_27,
      \dout_buf_reg[34]_0\(25) => buff_rdata_n_28,
      \dout_buf_reg[34]_0\(24) => buff_rdata_n_29,
      \dout_buf_reg[34]_0\(23) => buff_rdata_n_30,
      \dout_buf_reg[34]_0\(22) => buff_rdata_n_31,
      \dout_buf_reg[34]_0\(21) => buff_rdata_n_32,
      \dout_buf_reg[34]_0\(20) => buff_rdata_n_33,
      \dout_buf_reg[34]_0\(19) => buff_rdata_n_34,
      \dout_buf_reg[34]_0\(18) => buff_rdata_n_35,
      \dout_buf_reg[34]_0\(17) => buff_rdata_n_36,
      \dout_buf_reg[34]_0\(16) => buff_rdata_n_37,
      \dout_buf_reg[34]_0\(15) => buff_rdata_n_38,
      \dout_buf_reg[34]_0\(14) => buff_rdata_n_39,
      \dout_buf_reg[34]_0\(13) => buff_rdata_n_40,
      \dout_buf_reg[34]_0\(12) => buff_rdata_n_41,
      \dout_buf_reg[34]_0\(11) => buff_rdata_n_42,
      \dout_buf_reg[34]_0\(10) => buff_rdata_n_43,
      \dout_buf_reg[34]_0\(9) => buff_rdata_n_44,
      \dout_buf_reg[34]_0\(8) => buff_rdata_n_45,
      \dout_buf_reg[34]_0\(7) => buff_rdata_n_46,
      \dout_buf_reg[34]_0\(6) => buff_rdata_n_47,
      \dout_buf_reg[34]_0\(5) => buff_rdata_n_48,
      \dout_buf_reg[34]_0\(4) => buff_rdata_n_49,
      \dout_buf_reg[34]_0\(3) => buff_rdata_n_50,
      \dout_buf_reg[34]_0\(2) => buff_rdata_n_51,
      \dout_buf_reg[34]_0\(1) => buff_rdata_n_52,
      \dout_buf_reg[34]_0\(0) => buff_rdata_n_53,
      dout_valid_reg_0 => buff_rdata_n_13,
      dout_valid_reg_1 => \bus_equal_gen.rdata_valid_t_reg_n_2\,
      full_n_reg_0 => full_n_reg,
      m_axi_gmem_RRESP(1 downto 0) => m_axi_gmem_RRESP(1 downto 0),
      m_axi_gmem_RVALID => m_axi_gmem_RVALID,
      next_beat => next_beat,
      rdata_ack_t => rdata_ack_t,
      \usedw_reg[6]_0\(2 downto 0) => \usedw_reg[6]\(2 downto 0),
      \usedw_reg[7]_0\(6 downto 0) => \usedw_reg[7]\(6 downto 0)
    );
\bus_equal_gen.data_buf_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_beat,
      D => buff_rdata_n_53,
      Q => \bus_equal_gen.data_buf\(0),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_beat,
      D => buff_rdata_n_43,
      Q => \bus_equal_gen.data_buf\(10),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_beat,
      D => buff_rdata_n_42,
      Q => \bus_equal_gen.data_buf\(11),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_beat,
      D => buff_rdata_n_41,
      Q => \bus_equal_gen.data_buf\(12),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_beat,
      D => buff_rdata_n_40,
      Q => \bus_equal_gen.data_buf\(13),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_beat,
      D => buff_rdata_n_39,
      Q => \bus_equal_gen.data_buf\(14),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_beat,
      D => buff_rdata_n_38,
      Q => \bus_equal_gen.data_buf\(15),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_beat,
      D => buff_rdata_n_37,
      Q => \bus_equal_gen.data_buf\(16),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_beat,
      D => buff_rdata_n_36,
      Q => \bus_equal_gen.data_buf\(17),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_beat,
      D => buff_rdata_n_35,
      Q => \bus_equal_gen.data_buf\(18),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_beat,
      D => buff_rdata_n_34,
      Q => \bus_equal_gen.data_buf\(19),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_beat,
      D => buff_rdata_n_52,
      Q => \bus_equal_gen.data_buf\(1),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_beat,
      D => buff_rdata_n_33,
      Q => \bus_equal_gen.data_buf\(20),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_beat,
      D => buff_rdata_n_32,
      Q => \bus_equal_gen.data_buf\(21),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_beat,
      D => buff_rdata_n_31,
      Q => \bus_equal_gen.data_buf\(22),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_beat,
      D => buff_rdata_n_30,
      Q => \bus_equal_gen.data_buf\(23),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_beat,
      D => buff_rdata_n_29,
      Q => \bus_equal_gen.data_buf\(24),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_beat,
      D => buff_rdata_n_28,
      Q => \bus_equal_gen.data_buf\(25),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_beat,
      D => buff_rdata_n_27,
      Q => \bus_equal_gen.data_buf\(26),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_beat,
      D => buff_rdata_n_26,
      Q => \bus_equal_gen.data_buf\(27),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_beat,
      D => buff_rdata_n_25,
      Q => \bus_equal_gen.data_buf\(28),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_beat,
      D => buff_rdata_n_24,
      Q => \bus_equal_gen.data_buf\(29),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_beat,
      D => buff_rdata_n_51,
      Q => \bus_equal_gen.data_buf\(2),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_beat,
      D => buff_rdata_n_23,
      Q => \bus_equal_gen.data_buf\(30),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_beat,
      D => buff_rdata_n_22,
      Q => \bus_equal_gen.data_buf\(31),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_beat,
      D => buff_rdata_n_50,
      Q => \bus_equal_gen.data_buf\(3),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_beat,
      D => buff_rdata_n_49,
      Q => \bus_equal_gen.data_buf\(4),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_beat,
      D => buff_rdata_n_48,
      Q => \bus_equal_gen.data_buf\(5),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_beat,
      D => buff_rdata_n_47,
      Q => \bus_equal_gen.data_buf\(6),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_beat,
      D => buff_rdata_n_46,
      Q => \bus_equal_gen.data_buf\(7),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_beat,
      D => buff_rdata_n_45,
      Q => \bus_equal_gen.data_buf\(8),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_beat,
      D => buff_rdata_n_44,
      Q => \bus_equal_gen.data_buf\(9),
      R => '0'
    );
\bus_equal_gen.rdata_valid_t_reg\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => buff_rdata_n_13,
      Q => \bus_equal_gen.rdata_valid_t_reg_n_2\,
      R => \^sr\(0)
    );
\could_multi_bursts.ARVALID_Dummy_reg\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => fifo_rctl_n_2,
      Q => \^could_multi_bursts.arvalid_dummy_reg_0\,
      R => '0'
    );
\could_multi_bursts.araddr_buf[10]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \could_multi_bursts.araddr_buf_reg[12]_i_2_n_8\,
      I1 => \could_multi_bursts.araddr_buf[31]_i_4_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[10]\,
      O => araddr_tmp(10)
    );
\could_multi_bursts.araddr_buf[11]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \could_multi_bursts.araddr_buf_reg[12]_i_2_n_7\,
      I1 => \could_multi_bursts.araddr_buf[31]_i_4_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[11]\,
      O => araddr_tmp(11)
    );
\could_multi_bursts.araddr_buf[12]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \could_multi_bursts.araddr_buf_reg[12]_i_2_n_6\,
      I1 => \could_multi_bursts.araddr_buf[31]_i_4_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[12]\,
      O => araddr_tmp(12)
    );
\could_multi_bursts.araddr_buf[13]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \could_multi_bursts.araddr_buf_reg[16]_i_2_n_9\,
      I1 => \could_multi_bursts.araddr_buf[31]_i_4_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[13]\,
      O => araddr_tmp(13)
    );
\could_multi_bursts.araddr_buf[14]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \could_multi_bursts.araddr_buf_reg[16]_i_2_n_8\,
      I1 => \could_multi_bursts.araddr_buf[31]_i_4_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[14]\,
      O => araddr_tmp(14)
    );
\could_multi_bursts.araddr_buf[15]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \could_multi_bursts.araddr_buf_reg[16]_i_2_n_7\,
      I1 => \could_multi_bursts.araddr_buf[31]_i_4_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[15]\,
      O => araddr_tmp(15)
    );
\could_multi_bursts.araddr_buf[16]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \could_multi_bursts.araddr_buf_reg[16]_i_2_n_6\,
      I1 => \could_multi_bursts.araddr_buf[31]_i_4_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[16]\,
      O => araddr_tmp(16)
    );
\could_multi_bursts.araddr_buf[17]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \could_multi_bursts.araddr_buf_reg[20]_i_2_n_9\,
      I1 => \could_multi_bursts.araddr_buf[31]_i_4_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[17]\,
      O => araddr_tmp(17)
    );
\could_multi_bursts.araddr_buf[18]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \could_multi_bursts.araddr_buf_reg[20]_i_2_n_8\,
      I1 => \could_multi_bursts.araddr_buf[31]_i_4_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[18]\,
      O => araddr_tmp(18)
    );
\could_multi_bursts.araddr_buf[19]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \could_multi_bursts.araddr_buf_reg[20]_i_2_n_7\,
      I1 => \could_multi_bursts.araddr_buf[31]_i_4_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[19]\,
      O => araddr_tmp(19)
    );
\could_multi_bursts.araddr_buf[20]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \could_multi_bursts.araddr_buf_reg[20]_i_2_n_6\,
      I1 => \could_multi_bursts.araddr_buf[31]_i_4_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[20]\,
      O => araddr_tmp(20)
    );
\could_multi_bursts.araddr_buf[21]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \could_multi_bursts.araddr_buf_reg[24]_i_2_n_9\,
      I1 => \could_multi_bursts.araddr_buf[31]_i_4_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[21]\,
      O => araddr_tmp(21)
    );
\could_multi_bursts.araddr_buf[22]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \could_multi_bursts.araddr_buf_reg[24]_i_2_n_8\,
      I1 => \could_multi_bursts.araddr_buf[31]_i_4_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[22]\,
      O => araddr_tmp(22)
    );
\could_multi_bursts.araddr_buf[23]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \could_multi_bursts.araddr_buf_reg[24]_i_2_n_7\,
      I1 => \could_multi_bursts.araddr_buf[31]_i_4_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[23]\,
      O => araddr_tmp(23)
    );
\could_multi_bursts.araddr_buf[24]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \could_multi_bursts.araddr_buf_reg[24]_i_2_n_6\,
      I1 => \could_multi_bursts.araddr_buf[31]_i_4_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[24]\,
      O => araddr_tmp(24)
    );
\could_multi_bursts.araddr_buf[25]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \could_multi_bursts.araddr_buf_reg[28]_i_2_n_9\,
      I1 => \could_multi_bursts.araddr_buf[31]_i_4_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[25]\,
      O => araddr_tmp(25)
    );
\could_multi_bursts.araddr_buf[26]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \could_multi_bursts.araddr_buf_reg[28]_i_2_n_8\,
      I1 => \could_multi_bursts.araddr_buf[31]_i_4_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[26]\,
      O => araddr_tmp(26)
    );
\could_multi_bursts.araddr_buf[27]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \could_multi_bursts.araddr_buf_reg[28]_i_2_n_7\,
      I1 => \could_multi_bursts.araddr_buf[31]_i_4_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[27]\,
      O => araddr_tmp(27)
    );
\could_multi_bursts.araddr_buf[28]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \could_multi_bursts.araddr_buf_reg[28]_i_2_n_6\,
      I1 => \could_multi_bursts.araddr_buf[31]_i_4_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[28]\,
      O => araddr_tmp(28)
    );
\could_multi_bursts.araddr_buf[29]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \could_multi_bursts.araddr_buf_reg[31]_i_3_n_9\,
      I1 => \could_multi_bursts.araddr_buf[31]_i_4_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[29]\,
      O => araddr_tmp(29)
    );
\could_multi_bursts.araddr_buf[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \could_multi_bursts.araddr_buf_reg[4]_i_2_n_8\,
      I1 => \could_multi_bursts.araddr_buf[31]_i_4_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[2]\,
      O => araddr_tmp(2)
    );
\could_multi_bursts.araddr_buf[30]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \could_multi_bursts.araddr_buf_reg[31]_i_3_n_8\,
      I1 => \could_multi_bursts.araddr_buf[31]_i_4_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[30]\,
      O => araddr_tmp(30)
    );
\could_multi_bursts.araddr_buf[31]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \could_multi_bursts.araddr_buf_reg[31]_i_3_n_7\,
      I1 => \could_multi_bursts.araddr_buf[31]_i_4_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[31]\,
      O => araddr_tmp(31)
    );
\could_multi_bursts.araddr_buf[31]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => \could_multi_bursts.loop_cnt_reg__0\(1),
      I1 => \could_multi_bursts.loop_cnt_reg__0\(0),
      I2 => \could_multi_bursts.loop_cnt_reg__0\(2),
      I3 => \could_multi_bursts.loop_cnt_reg__0\(5),
      I4 => \could_multi_bursts.loop_cnt_reg__0\(4),
      I5 => \could_multi_bursts.loop_cnt_reg__0\(3),
      O => \could_multi_bursts.araddr_buf[31]_i_4_n_2\
    );
\could_multi_bursts.araddr_buf[3]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \could_multi_bursts.araddr_buf_reg[4]_i_2_n_7\,
      I1 => \could_multi_bursts.araddr_buf[31]_i_4_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[3]\,
      O => araddr_tmp(3)
    );
\could_multi_bursts.araddr_buf[4]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \could_multi_bursts.araddr_buf_reg[4]_i_2_n_6\,
      I1 => \could_multi_bursts.araddr_buf[31]_i_4_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[4]\,
      O => araddr_tmp(4)
    );
\could_multi_bursts.araddr_buf[4]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"956A"
    )
        port map (
      I0 => \^m_axi_gmem_araddr\(2),
      I1 => \^could_multi_bursts.arlen_buf_reg[3]_0\(1),
      I2 => \^could_multi_bursts.arlen_buf_reg[3]_0\(0),
      I3 => \^could_multi_bursts.arlen_buf_reg[3]_0\(2),
      O => \could_multi_bursts.araddr_buf[4]_i_3_n_2\
    );
\could_multi_bursts.araddr_buf[4]_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => \^m_axi_gmem_araddr\(1),
      I1 => \^could_multi_bursts.arlen_buf_reg[3]_0\(0),
      I2 => \^could_multi_bursts.arlen_buf_reg[3]_0\(1),
      O => \could_multi_bursts.araddr_buf[4]_i_4_n_2\
    );
\could_multi_bursts.araddr_buf[4]_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^m_axi_gmem_araddr\(0),
      I1 => \^could_multi_bursts.arlen_buf_reg[3]_0\(0),
      O => \could_multi_bursts.araddr_buf[4]_i_5_n_2\
    );
\could_multi_bursts.araddr_buf[5]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \could_multi_bursts.araddr_buf_reg[8]_i_2_n_9\,
      I1 => \could_multi_bursts.araddr_buf[31]_i_4_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[5]\,
      O => araddr_tmp(5)
    );
\could_multi_bursts.araddr_buf[6]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \could_multi_bursts.araddr_buf_reg[8]_i_2_n_8\,
      I1 => \could_multi_bursts.araddr_buf[31]_i_4_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[6]\,
      O => araddr_tmp(6)
    );
\could_multi_bursts.araddr_buf[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \could_multi_bursts.araddr_buf_reg[8]_i_2_n_7\,
      I1 => \could_multi_bursts.araddr_buf[31]_i_4_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[7]\,
      O => araddr_tmp(7)
    );
\could_multi_bursts.araddr_buf[8]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \could_multi_bursts.araddr_buf_reg[8]_i_2_n_6\,
      I1 => \could_multi_bursts.araddr_buf[31]_i_4_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[8]\,
      O => araddr_tmp(8)
    );
\could_multi_bursts.araddr_buf[8]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"6AAAAAAA"
    )
        port map (
      I0 => \^m_axi_gmem_araddr\(4),
      I1 => \^could_multi_bursts.arlen_buf_reg[3]_0\(2),
      I2 => \^could_multi_bursts.arlen_buf_reg[3]_0\(0),
      I3 => \^could_multi_bursts.arlen_buf_reg[3]_0\(1),
      I4 => \^could_multi_bursts.arlen_buf_reg[3]_0\(3),
      O => \could_multi_bursts.araddr_buf[8]_i_3_n_2\
    );
\could_multi_bursts.araddr_buf[8]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"95556AAA"
    )
        port map (
      I0 => \^m_axi_gmem_araddr\(3),
      I1 => \^could_multi_bursts.arlen_buf_reg[3]_0\(2),
      I2 => \^could_multi_bursts.arlen_buf_reg[3]_0\(0),
      I3 => \^could_multi_bursts.arlen_buf_reg[3]_0\(1),
      I4 => \^could_multi_bursts.arlen_buf_reg[3]_0\(3),
      O => \could_multi_bursts.araddr_buf[8]_i_4_n_2\
    );
\could_multi_bursts.araddr_buf[9]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \could_multi_bursts.araddr_buf_reg[12]_i_2_n_9\,
      I1 => \could_multi_bursts.araddr_buf[31]_i_4_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[9]\,
      O => araddr_tmp(9)
    );
\could_multi_bursts.araddr_buf_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => araddr_tmp(10),
      Q => \^m_axi_gmem_araddr\(8),
      R => \^sr\(0)
    );
\could_multi_bursts.araddr_buf_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => araddr_tmp(11),
      Q => \^m_axi_gmem_araddr\(9),
      R => \^sr\(0)
    );
\could_multi_bursts.araddr_buf_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => araddr_tmp(12),
      Q => \^m_axi_gmem_araddr\(10),
      R => \^sr\(0)
    );
\could_multi_bursts.araddr_buf_reg[12]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => \could_multi_bursts.araddr_buf_reg[8]_i_2_n_2\,
      CO(3) => \could_multi_bursts.araddr_buf_reg[12]_i_2_n_2\,
      CO(2) => \could_multi_bursts.araddr_buf_reg[12]_i_2_n_3\,
      CO(1) => \could_multi_bursts.araddr_buf_reg[12]_i_2_n_4\,
      CO(0) => \could_multi_bursts.araddr_buf_reg[12]_i_2_n_5\,
      CYINIT => '0',
      DI(3 downto 2) => B"00",
      DI(1 downto 0) => \^m_axi_gmem_araddr\(8 downto 7),
      O(3) => \could_multi_bursts.araddr_buf_reg[12]_i_2_n_6\,
      O(2) => \could_multi_bursts.araddr_buf_reg[12]_i_2_n_7\,
      O(1) => \could_multi_bursts.araddr_buf_reg[12]_i_2_n_8\,
      O(0) => \could_multi_bursts.araddr_buf_reg[12]_i_2_n_9\,
      S(3 downto 0) => \^m_axi_gmem_araddr\(10 downto 7)
    );
\could_multi_bursts.araddr_buf_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => araddr_tmp(13),
      Q => \^m_axi_gmem_araddr\(11),
      R => \^sr\(0)
    );
\could_multi_bursts.araddr_buf_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => araddr_tmp(14),
      Q => \^m_axi_gmem_araddr\(12),
      R => \^sr\(0)
    );
\could_multi_bursts.araddr_buf_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => araddr_tmp(15),
      Q => \^m_axi_gmem_araddr\(13),
      R => \^sr\(0)
    );
\could_multi_bursts.araddr_buf_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => araddr_tmp(16),
      Q => \^m_axi_gmem_araddr\(14),
      R => \^sr\(0)
    );
\could_multi_bursts.araddr_buf_reg[16]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => \could_multi_bursts.araddr_buf_reg[12]_i_2_n_2\,
      CO(3) => \could_multi_bursts.araddr_buf_reg[16]_i_2_n_2\,
      CO(2) => \could_multi_bursts.araddr_buf_reg[16]_i_2_n_3\,
      CO(1) => \could_multi_bursts.araddr_buf_reg[16]_i_2_n_4\,
      CO(0) => \could_multi_bursts.araddr_buf_reg[16]_i_2_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \could_multi_bursts.araddr_buf_reg[16]_i_2_n_6\,
      O(2) => \could_multi_bursts.araddr_buf_reg[16]_i_2_n_7\,
      O(1) => \could_multi_bursts.araddr_buf_reg[16]_i_2_n_8\,
      O(0) => \could_multi_bursts.araddr_buf_reg[16]_i_2_n_9\,
      S(3 downto 0) => \^m_axi_gmem_araddr\(14 downto 11)
    );
\could_multi_bursts.araddr_buf_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => araddr_tmp(17),
      Q => \^m_axi_gmem_araddr\(15),
      R => \^sr\(0)
    );
\could_multi_bursts.araddr_buf_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => araddr_tmp(18),
      Q => \^m_axi_gmem_araddr\(16),
      R => \^sr\(0)
    );
\could_multi_bursts.araddr_buf_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => araddr_tmp(19),
      Q => \^m_axi_gmem_araddr\(17),
      R => \^sr\(0)
    );
\could_multi_bursts.araddr_buf_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => araddr_tmp(20),
      Q => \^m_axi_gmem_araddr\(18),
      R => \^sr\(0)
    );
\could_multi_bursts.araddr_buf_reg[20]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => \could_multi_bursts.araddr_buf_reg[16]_i_2_n_2\,
      CO(3) => \could_multi_bursts.araddr_buf_reg[20]_i_2_n_2\,
      CO(2) => \could_multi_bursts.araddr_buf_reg[20]_i_2_n_3\,
      CO(1) => \could_multi_bursts.araddr_buf_reg[20]_i_2_n_4\,
      CO(0) => \could_multi_bursts.araddr_buf_reg[20]_i_2_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \could_multi_bursts.araddr_buf_reg[20]_i_2_n_6\,
      O(2) => \could_multi_bursts.araddr_buf_reg[20]_i_2_n_7\,
      O(1) => \could_multi_bursts.araddr_buf_reg[20]_i_2_n_8\,
      O(0) => \could_multi_bursts.araddr_buf_reg[20]_i_2_n_9\,
      S(3 downto 0) => \^m_axi_gmem_araddr\(18 downto 15)
    );
\could_multi_bursts.araddr_buf_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => araddr_tmp(21),
      Q => \^m_axi_gmem_araddr\(19),
      R => \^sr\(0)
    );
\could_multi_bursts.araddr_buf_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => araddr_tmp(22),
      Q => \^m_axi_gmem_araddr\(20),
      R => \^sr\(0)
    );
\could_multi_bursts.araddr_buf_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => araddr_tmp(23),
      Q => \^m_axi_gmem_araddr\(21),
      R => \^sr\(0)
    );
\could_multi_bursts.araddr_buf_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => araddr_tmp(24),
      Q => \^m_axi_gmem_araddr\(22),
      R => \^sr\(0)
    );
\could_multi_bursts.araddr_buf_reg[24]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => \could_multi_bursts.araddr_buf_reg[20]_i_2_n_2\,
      CO(3) => \could_multi_bursts.araddr_buf_reg[24]_i_2_n_2\,
      CO(2) => \could_multi_bursts.araddr_buf_reg[24]_i_2_n_3\,
      CO(1) => \could_multi_bursts.araddr_buf_reg[24]_i_2_n_4\,
      CO(0) => \could_multi_bursts.araddr_buf_reg[24]_i_2_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \could_multi_bursts.araddr_buf_reg[24]_i_2_n_6\,
      O(2) => \could_multi_bursts.araddr_buf_reg[24]_i_2_n_7\,
      O(1) => \could_multi_bursts.araddr_buf_reg[24]_i_2_n_8\,
      O(0) => \could_multi_bursts.araddr_buf_reg[24]_i_2_n_9\,
      S(3 downto 0) => \^m_axi_gmem_araddr\(22 downto 19)
    );
\could_multi_bursts.araddr_buf_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => araddr_tmp(25),
      Q => \^m_axi_gmem_araddr\(23),
      R => \^sr\(0)
    );
\could_multi_bursts.araddr_buf_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => araddr_tmp(26),
      Q => \^m_axi_gmem_araddr\(24),
      R => \^sr\(0)
    );
\could_multi_bursts.araddr_buf_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => araddr_tmp(27),
      Q => \^m_axi_gmem_araddr\(25),
      R => \^sr\(0)
    );
\could_multi_bursts.araddr_buf_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => araddr_tmp(28),
      Q => \^m_axi_gmem_araddr\(26),
      R => \^sr\(0)
    );
\could_multi_bursts.araddr_buf_reg[28]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => \could_multi_bursts.araddr_buf_reg[24]_i_2_n_2\,
      CO(3) => \could_multi_bursts.araddr_buf_reg[28]_i_2_n_2\,
      CO(2) => \could_multi_bursts.araddr_buf_reg[28]_i_2_n_3\,
      CO(1) => \could_multi_bursts.araddr_buf_reg[28]_i_2_n_4\,
      CO(0) => \could_multi_bursts.araddr_buf_reg[28]_i_2_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \could_multi_bursts.araddr_buf_reg[28]_i_2_n_6\,
      O(2) => \could_multi_bursts.araddr_buf_reg[28]_i_2_n_7\,
      O(1) => \could_multi_bursts.araddr_buf_reg[28]_i_2_n_8\,
      O(0) => \could_multi_bursts.araddr_buf_reg[28]_i_2_n_9\,
      S(3 downto 0) => \^m_axi_gmem_araddr\(26 downto 23)
    );
\could_multi_bursts.araddr_buf_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => araddr_tmp(29),
      Q => \^m_axi_gmem_araddr\(27),
      R => \^sr\(0)
    );
\could_multi_bursts.araddr_buf_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => araddr_tmp(2),
      Q => \^m_axi_gmem_araddr\(0),
      R => \^sr\(0)
    );
\could_multi_bursts.araddr_buf_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => araddr_tmp(30),
      Q => \^m_axi_gmem_araddr\(28),
      R => \^sr\(0)
    );
\could_multi_bursts.araddr_buf_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => araddr_tmp(31),
      Q => \^m_axi_gmem_araddr\(29),
      R => \^sr\(0)
    );
\could_multi_bursts.araddr_buf_reg[31]_i_3\: unisim.vcomponents.CARRY4
     port map (
      CI => \could_multi_bursts.araddr_buf_reg[28]_i_2_n_2\,
      CO(3 downto 2) => \NLW_could_multi_bursts.araddr_buf_reg[31]_i_3_CO_UNCONNECTED\(3 downto 2),
      CO(1) => \could_multi_bursts.araddr_buf_reg[31]_i_3_n_4\,
      CO(0) => \could_multi_bursts.araddr_buf_reg[31]_i_3_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \NLW_could_multi_bursts.araddr_buf_reg[31]_i_3_O_UNCONNECTED\(3),
      O(2) => \could_multi_bursts.araddr_buf_reg[31]_i_3_n_7\,
      O(1) => \could_multi_bursts.araddr_buf_reg[31]_i_3_n_8\,
      O(0) => \could_multi_bursts.araddr_buf_reg[31]_i_3_n_9\,
      S(3) => '0',
      S(2 downto 0) => \^m_axi_gmem_araddr\(29 downto 27)
    );
\could_multi_bursts.araddr_buf_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => araddr_tmp(3),
      Q => \^m_axi_gmem_araddr\(1),
      R => \^sr\(0)
    );
\could_multi_bursts.araddr_buf_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => araddr_tmp(4),
      Q => \^m_axi_gmem_araddr\(2),
      R => \^sr\(0)
    );
\could_multi_bursts.araddr_buf_reg[4]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \could_multi_bursts.araddr_buf_reg[4]_i_2_n_2\,
      CO(2) => \could_multi_bursts.araddr_buf_reg[4]_i_2_n_3\,
      CO(1) => \could_multi_bursts.araddr_buf_reg[4]_i_2_n_4\,
      CO(0) => \could_multi_bursts.araddr_buf_reg[4]_i_2_n_5\,
      CYINIT => '0',
      DI(3 downto 1) => \^m_axi_gmem_araddr\(2 downto 0),
      DI(0) => '0',
      O(3) => \could_multi_bursts.araddr_buf_reg[4]_i_2_n_6\,
      O(2) => \could_multi_bursts.araddr_buf_reg[4]_i_2_n_7\,
      O(1) => \could_multi_bursts.araddr_buf_reg[4]_i_2_n_8\,
      O(0) => \NLW_could_multi_bursts.araddr_buf_reg[4]_i_2_O_UNCONNECTED\(0),
      S(3) => \could_multi_bursts.araddr_buf[4]_i_3_n_2\,
      S(2) => \could_multi_bursts.araddr_buf[4]_i_4_n_2\,
      S(1) => \could_multi_bursts.araddr_buf[4]_i_5_n_2\,
      S(0) => '0'
    );
\could_multi_bursts.araddr_buf_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => araddr_tmp(5),
      Q => \^m_axi_gmem_araddr\(3),
      R => \^sr\(0)
    );
\could_multi_bursts.araddr_buf_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => araddr_tmp(6),
      Q => \^m_axi_gmem_araddr\(4),
      R => \^sr\(0)
    );
\could_multi_bursts.araddr_buf_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => araddr_tmp(7),
      Q => \^m_axi_gmem_araddr\(5),
      R => \^sr\(0)
    );
\could_multi_bursts.araddr_buf_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => araddr_tmp(8),
      Q => \^m_axi_gmem_araddr\(6),
      R => \^sr\(0)
    );
\could_multi_bursts.araddr_buf_reg[8]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => \could_multi_bursts.araddr_buf_reg[4]_i_2_n_2\,
      CO(3) => \could_multi_bursts.araddr_buf_reg[8]_i_2_n_2\,
      CO(2) => \could_multi_bursts.araddr_buf_reg[8]_i_2_n_3\,
      CO(1) => \could_multi_bursts.araddr_buf_reg[8]_i_2_n_4\,
      CO(0) => \could_multi_bursts.araddr_buf_reg[8]_i_2_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => \^m_axi_gmem_araddr\(6 downto 3),
      O(3) => \could_multi_bursts.araddr_buf_reg[8]_i_2_n_6\,
      O(2) => \could_multi_bursts.araddr_buf_reg[8]_i_2_n_7\,
      O(1) => \could_multi_bursts.araddr_buf_reg[8]_i_2_n_8\,
      O(0) => \could_multi_bursts.araddr_buf_reg[8]_i_2_n_9\,
      S(3 downto 2) => \^m_axi_gmem_araddr\(6 downto 5),
      S(1) => \could_multi_bursts.araddr_buf[8]_i_3_n_2\,
      S(0) => \could_multi_bursts.araddr_buf[8]_i_4_n_2\
    );
\could_multi_bursts.araddr_buf_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => araddr_tmp(9),
      Q => \^m_axi_gmem_araddr\(7),
      R => \^sr\(0)
    );
\could_multi_bursts.arlen_buf[3]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => fifo_rreq_n_26,
      I1 => fifo_rreq_n_25,
      O => \could_multi_bursts.arlen_buf[3]_i_3_n_2\
    );
\could_multi_bursts.arlen_buf_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_rctl_n_27,
      D => fifo_rctl_n_24,
      Q => \^could_multi_bursts.arlen_buf_reg[3]_0\(0),
      R => \^sr\(0)
    );
\could_multi_bursts.arlen_buf_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_rctl_n_27,
      D => fifo_rctl_n_25,
      Q => \^could_multi_bursts.arlen_buf_reg[3]_0\(1),
      R => \^sr\(0)
    );
\could_multi_bursts.arlen_buf_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_rctl_n_27,
      D => fifo_rctl_n_26,
      Q => \^could_multi_bursts.arlen_buf_reg[3]_0\(2),
      R => \^sr\(0)
    );
\could_multi_bursts.arlen_buf_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_rctl_n_27,
      D => fifo_rctl_n_28,
      Q => \^could_multi_bursts.arlen_buf_reg[3]_0\(3),
      R => \^sr\(0)
    );
\could_multi_bursts.loop_cnt[0]_i_1__0\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \could_multi_bursts.loop_cnt_reg__0\(0),
      O => \p_0_in__2\(0)
    );
\could_multi_bursts.loop_cnt[1]_i_1__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \could_multi_bursts.loop_cnt_reg__0\(0),
      I1 => \could_multi_bursts.loop_cnt_reg__0\(1),
      O => \p_0_in__2\(1)
    );
\could_multi_bursts.loop_cnt[2]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"6A"
    )
        port map (
      I0 => \could_multi_bursts.loop_cnt_reg__0\(2),
      I1 => \could_multi_bursts.loop_cnt_reg__0\(1),
      I2 => \could_multi_bursts.loop_cnt_reg__0\(0),
      O => \p_0_in__2\(2)
    );
\could_multi_bursts.loop_cnt[3]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6AAA"
    )
        port map (
      I0 => \could_multi_bursts.loop_cnt_reg__0\(3),
      I1 => \could_multi_bursts.loop_cnt_reg__0\(0),
      I2 => \could_multi_bursts.loop_cnt_reg__0\(1),
      I3 => \could_multi_bursts.loop_cnt_reg__0\(2),
      O => \p_0_in__2\(3)
    );
\could_multi_bursts.loop_cnt[4]_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"6AAAAAAA"
    )
        port map (
      I0 => \could_multi_bursts.loop_cnt_reg__0\(4),
      I1 => \could_multi_bursts.loop_cnt_reg__0\(2),
      I2 => \could_multi_bursts.loop_cnt_reg__0\(1),
      I3 => \could_multi_bursts.loop_cnt_reg__0\(0),
      I4 => \could_multi_bursts.loop_cnt_reg__0\(3),
      O => \p_0_in__2\(4)
    );
\could_multi_bursts.loop_cnt[5]_i_2__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6AAAAAAAAAAAAAAA"
    )
        port map (
      I0 => \could_multi_bursts.loop_cnt_reg__0\(5),
      I1 => \could_multi_bursts.loop_cnt_reg__0\(3),
      I2 => \could_multi_bursts.loop_cnt_reg__0\(0),
      I3 => \could_multi_bursts.loop_cnt_reg__0\(1),
      I4 => \could_multi_bursts.loop_cnt_reg__0\(2),
      I5 => \could_multi_bursts.loop_cnt_reg__0\(4),
      O => \p_0_in__2\(5)
    );
\could_multi_bursts.loop_cnt_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => \p_0_in__2\(0),
      Q => \could_multi_bursts.loop_cnt_reg__0\(0),
      R => fifo_rctl_n_7
    );
\could_multi_bursts.loop_cnt_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => \p_0_in__2\(1),
      Q => \could_multi_bursts.loop_cnt_reg__0\(1),
      R => fifo_rctl_n_7
    );
\could_multi_bursts.loop_cnt_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => \p_0_in__2\(2),
      Q => \could_multi_bursts.loop_cnt_reg__0\(2),
      R => fifo_rctl_n_7
    );
\could_multi_bursts.loop_cnt_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => \p_0_in__2\(3),
      Q => \could_multi_bursts.loop_cnt_reg__0\(3),
      R => fifo_rctl_n_7
    );
\could_multi_bursts.loop_cnt_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => \p_0_in__2\(4),
      Q => \could_multi_bursts.loop_cnt_reg__0\(4),
      R => fifo_rctl_n_7
    );
\could_multi_bursts.loop_cnt_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => \p_0_in__2\(5),
      Q => \could_multi_bursts.loop_cnt_reg__0\(5),
      R => fifo_rctl_n_7
    );
\could_multi_bursts.sect_handling_reg\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => fifo_rctl_n_11,
      Q => \could_multi_bursts.sect_handling_reg_n_2\,
      R => \^sr\(0)
    );
\end_addr_buf[2]_i_1__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[2]\,
      I1 => \align_len_reg_n_2_[2]\,
      O => \end_addr_buf[2]_i_1__0_n_2\
    );
\end_addr_buf_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \end_addr_carry__1_n_9\,
      Q => \end_addr_buf_reg_n_2_[10]\,
      R => \^sr\(0)
    );
\end_addr_buf_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \end_addr_carry__1_n_8\,
      Q => \end_addr_buf_reg_n_2_[11]\,
      R => \^sr\(0)
    );
\end_addr_buf_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \end_addr_carry__1_n_7\,
      Q => \end_addr_buf_reg_n_2_[12]\,
      R => \^sr\(0)
    );
\end_addr_buf_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \end_addr_carry__1_n_6\,
      Q => \end_addr_buf_reg_n_2_[13]\,
      R => \^sr\(0)
    );
\end_addr_buf_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \end_addr_carry__2_n_9\,
      Q => \end_addr_buf_reg_n_2_[14]\,
      R => \^sr\(0)
    );
\end_addr_buf_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \end_addr_carry__2_n_8\,
      Q => \end_addr_buf_reg_n_2_[15]\,
      R => \^sr\(0)
    );
\end_addr_buf_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \end_addr_carry__2_n_7\,
      Q => \end_addr_buf_reg_n_2_[16]\,
      R => \^sr\(0)
    );
\end_addr_buf_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \end_addr_carry__2_n_6\,
      Q => \end_addr_buf_reg_n_2_[17]\,
      R => \^sr\(0)
    );
\end_addr_buf_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \end_addr_carry__3_n_9\,
      Q => \end_addr_buf_reg_n_2_[18]\,
      R => \^sr\(0)
    );
\end_addr_buf_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \end_addr_carry__3_n_8\,
      Q => \end_addr_buf_reg_n_2_[19]\,
      R => \^sr\(0)
    );
\end_addr_buf_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \end_addr_carry__3_n_7\,
      Q => \end_addr_buf_reg_n_2_[20]\,
      R => \^sr\(0)
    );
\end_addr_buf_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \end_addr_carry__3_n_6\,
      Q => \end_addr_buf_reg_n_2_[21]\,
      R => \^sr\(0)
    );
\end_addr_buf_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \end_addr_carry__4_n_9\,
      Q => \end_addr_buf_reg_n_2_[22]\,
      R => \^sr\(0)
    );
\end_addr_buf_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \end_addr_carry__4_n_8\,
      Q => \end_addr_buf_reg_n_2_[23]\,
      R => \^sr\(0)
    );
\end_addr_buf_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \end_addr_carry__4_n_7\,
      Q => \end_addr_buf_reg_n_2_[24]\,
      R => \^sr\(0)
    );
\end_addr_buf_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \end_addr_carry__4_n_6\,
      Q => \end_addr_buf_reg_n_2_[25]\,
      R => \^sr\(0)
    );
\end_addr_buf_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \end_addr_carry__5_n_9\,
      Q => \end_addr_buf_reg_n_2_[26]\,
      R => \^sr\(0)
    );
\end_addr_buf_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \end_addr_carry__5_n_8\,
      Q => \end_addr_buf_reg_n_2_[27]\,
      R => \^sr\(0)
    );
\end_addr_buf_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \end_addr_carry__5_n_7\,
      Q => \end_addr_buf_reg_n_2_[28]\,
      R => \^sr\(0)
    );
\end_addr_buf_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \end_addr_carry__5_n_6\,
      Q => \end_addr_buf_reg_n_2_[29]\,
      R => \^sr\(0)
    );
\end_addr_buf_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \end_addr_buf[2]_i_1__0_n_2\,
      Q => \end_addr_buf_reg_n_2_[2]\,
      R => \^sr\(0)
    );
\end_addr_buf_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \end_addr_carry__6_n_9\,
      Q => \end_addr_buf_reg_n_2_[30]\,
      R => \^sr\(0)
    );
\end_addr_buf_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \end_addr_carry__6_n_8\,
      Q => \end_addr_buf_reg_n_2_[31]\,
      R => \^sr\(0)
    );
\end_addr_buf_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => end_addr_carry_n_8,
      Q => \end_addr_buf_reg_n_2_[3]\,
      R => \^sr\(0)
    );
\end_addr_buf_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => end_addr_carry_n_7,
      Q => \end_addr_buf_reg_n_2_[4]\,
      R => \^sr\(0)
    );
\end_addr_buf_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => end_addr_carry_n_6,
      Q => \end_addr_buf_reg_n_2_[5]\,
      R => \^sr\(0)
    );
\end_addr_buf_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \end_addr_carry__0_n_9\,
      Q => \end_addr_buf_reg_n_2_[6]\,
      R => \^sr\(0)
    );
\end_addr_buf_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \end_addr_carry__0_n_8\,
      Q => \end_addr_buf_reg_n_2_[7]\,
      R => \^sr\(0)
    );
\end_addr_buf_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \end_addr_carry__0_n_7\,
      Q => \end_addr_buf_reg_n_2_[8]\,
      R => \^sr\(0)
    );
\end_addr_buf_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \end_addr_carry__0_n_6\,
      Q => \end_addr_buf_reg_n_2_[9]\,
      R => \^sr\(0)
    );
end_addr_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => end_addr_carry_n_2,
      CO(2) => end_addr_carry_n_3,
      CO(1) => end_addr_carry_n_4,
      CO(0) => end_addr_carry_n_5,
      CYINIT => '0',
      DI(3) => \start_addr_reg_n_2_[5]\,
      DI(2) => \start_addr_reg_n_2_[4]\,
      DI(1) => \start_addr_reg_n_2_[3]\,
      DI(0) => \start_addr_reg_n_2_[2]\,
      O(3) => end_addr_carry_n_6,
      O(2) => end_addr_carry_n_7,
      O(1) => end_addr_carry_n_8,
      O(0) => NLW_end_addr_carry_O_UNCONNECTED(0),
      S(3) => \end_addr_carry_i_1__0_n_2\,
      S(2) => \end_addr_carry_i_2__0_n_2\,
      S(1) => \end_addr_carry_i_3__0_n_2\,
      S(0) => \end_addr_carry_i_4__0_n_2\
    );
\end_addr_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => end_addr_carry_n_2,
      CO(3) => \end_addr_carry__0_n_2\,
      CO(2) => \end_addr_carry__0_n_3\,
      CO(1) => \end_addr_carry__0_n_4\,
      CO(0) => \end_addr_carry__0_n_5\,
      CYINIT => '0',
      DI(3) => \start_addr_reg_n_2_[9]\,
      DI(2) => \start_addr_reg_n_2_[8]\,
      DI(1) => \start_addr_reg_n_2_[7]\,
      DI(0) => \start_addr_reg_n_2_[6]\,
      O(3) => \end_addr_carry__0_n_6\,
      O(2) => \end_addr_carry__0_n_7\,
      O(1) => \end_addr_carry__0_n_8\,
      O(0) => \end_addr_carry__0_n_9\,
      S(3) => \end_addr_carry__0_i_1__0_n_2\,
      S(2) => \end_addr_carry__0_i_2__0_n_2\,
      S(1) => \end_addr_carry__0_i_3__0_n_2\,
      S(0) => \end_addr_carry__0_i_4__0_n_2\
    );
\end_addr_carry__0_i_1__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[9]\,
      I1 => \align_len_reg_n_2_[9]\,
      O => \end_addr_carry__0_i_1__0_n_2\
    );
\end_addr_carry__0_i_2__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[8]\,
      I1 => \align_len_reg_n_2_[8]\,
      O => \end_addr_carry__0_i_2__0_n_2\
    );
\end_addr_carry__0_i_3__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[7]\,
      I1 => \align_len_reg_n_2_[7]\,
      O => \end_addr_carry__0_i_3__0_n_2\
    );
\end_addr_carry__0_i_4__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[6]\,
      I1 => \align_len_reg_n_2_[6]\,
      O => \end_addr_carry__0_i_4__0_n_2\
    );
\end_addr_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \end_addr_carry__0_n_2\,
      CO(3) => \end_addr_carry__1_n_2\,
      CO(2) => \end_addr_carry__1_n_3\,
      CO(1) => \end_addr_carry__1_n_4\,
      CO(0) => \end_addr_carry__1_n_5\,
      CYINIT => '0',
      DI(3) => \start_addr_reg_n_2_[13]\,
      DI(2) => \start_addr_reg_n_2_[12]\,
      DI(1) => \start_addr_reg_n_2_[11]\,
      DI(0) => \start_addr_reg_n_2_[10]\,
      O(3) => \end_addr_carry__1_n_6\,
      O(2) => \end_addr_carry__1_n_7\,
      O(1) => \end_addr_carry__1_n_8\,
      O(0) => \end_addr_carry__1_n_9\,
      S(3) => \end_addr_carry__1_i_1__0_n_2\,
      S(2) => \end_addr_carry__1_i_2__0_n_2\,
      S(1) => \end_addr_carry__1_i_3__0_n_2\,
      S(0) => \end_addr_carry__1_i_4__0_n_2\
    );
\end_addr_carry__1_i_1__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[13]\,
      I1 => \align_len_reg_n_2_[13]\,
      O => \end_addr_carry__1_i_1__0_n_2\
    );
\end_addr_carry__1_i_2__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[12]\,
      I1 => \align_len_reg_n_2_[12]\,
      O => \end_addr_carry__1_i_2__0_n_2\
    );
\end_addr_carry__1_i_3__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[11]\,
      I1 => \align_len_reg_n_2_[11]\,
      O => \end_addr_carry__1_i_3__0_n_2\
    );
\end_addr_carry__1_i_4__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[10]\,
      I1 => \align_len_reg_n_2_[10]\,
      O => \end_addr_carry__1_i_4__0_n_2\
    );
\end_addr_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \end_addr_carry__1_n_2\,
      CO(3) => \end_addr_carry__2_n_2\,
      CO(2) => \end_addr_carry__2_n_3\,
      CO(1) => \end_addr_carry__2_n_4\,
      CO(0) => \end_addr_carry__2_n_5\,
      CYINIT => '0',
      DI(3) => \start_addr_reg_n_2_[17]\,
      DI(2) => \start_addr_reg_n_2_[16]\,
      DI(1) => \start_addr_reg_n_2_[15]\,
      DI(0) => \start_addr_reg_n_2_[14]\,
      O(3) => \end_addr_carry__2_n_6\,
      O(2) => \end_addr_carry__2_n_7\,
      O(1) => \end_addr_carry__2_n_8\,
      O(0) => \end_addr_carry__2_n_9\,
      S(3) => \end_addr_carry__2_i_1__0_n_2\,
      S(2) => \end_addr_carry__2_i_2__0_n_2\,
      S(1) => \end_addr_carry__2_i_3__0_n_2\,
      S(0) => \end_addr_carry__2_i_4__0_n_2\
    );
\end_addr_carry__2_i_1__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[17]\,
      I1 => \align_len_reg_n_2_[17]\,
      O => \end_addr_carry__2_i_1__0_n_2\
    );
\end_addr_carry__2_i_2__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[16]\,
      I1 => \align_len_reg_n_2_[16]\,
      O => \end_addr_carry__2_i_2__0_n_2\
    );
\end_addr_carry__2_i_3__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[15]\,
      I1 => \align_len_reg_n_2_[15]\,
      O => \end_addr_carry__2_i_3__0_n_2\
    );
\end_addr_carry__2_i_4__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[14]\,
      I1 => \align_len_reg_n_2_[14]\,
      O => \end_addr_carry__2_i_4__0_n_2\
    );
\end_addr_carry__3\: unisim.vcomponents.CARRY4
     port map (
      CI => \end_addr_carry__2_n_2\,
      CO(3) => \end_addr_carry__3_n_2\,
      CO(2) => \end_addr_carry__3_n_3\,
      CO(1) => \end_addr_carry__3_n_4\,
      CO(0) => \end_addr_carry__3_n_5\,
      CYINIT => '0',
      DI(3) => \start_addr_reg_n_2_[21]\,
      DI(2) => \start_addr_reg_n_2_[20]\,
      DI(1) => \start_addr_reg_n_2_[19]\,
      DI(0) => \start_addr_reg_n_2_[18]\,
      O(3) => \end_addr_carry__3_n_6\,
      O(2) => \end_addr_carry__3_n_7\,
      O(1) => \end_addr_carry__3_n_8\,
      O(0) => \end_addr_carry__3_n_9\,
      S(3) => \end_addr_carry__3_i_1__0_n_2\,
      S(2) => \end_addr_carry__3_i_2__0_n_2\,
      S(1) => \end_addr_carry__3_i_3__0_n_2\,
      S(0) => \end_addr_carry__3_i_4__0_n_2\
    );
\end_addr_carry__3_i_1__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[21]\,
      I1 => \align_len_reg_n_2_[21]\,
      O => \end_addr_carry__3_i_1__0_n_2\
    );
\end_addr_carry__3_i_2__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[20]\,
      I1 => \align_len_reg_n_2_[20]\,
      O => \end_addr_carry__3_i_2__0_n_2\
    );
\end_addr_carry__3_i_3__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[19]\,
      I1 => \align_len_reg_n_2_[19]\,
      O => \end_addr_carry__3_i_3__0_n_2\
    );
\end_addr_carry__3_i_4__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[18]\,
      I1 => \align_len_reg_n_2_[18]\,
      O => \end_addr_carry__3_i_4__0_n_2\
    );
\end_addr_carry__4\: unisim.vcomponents.CARRY4
     port map (
      CI => \end_addr_carry__3_n_2\,
      CO(3) => \end_addr_carry__4_n_2\,
      CO(2) => \end_addr_carry__4_n_3\,
      CO(1) => \end_addr_carry__4_n_4\,
      CO(0) => \end_addr_carry__4_n_5\,
      CYINIT => '0',
      DI(3) => \start_addr_reg_n_2_[25]\,
      DI(2) => \start_addr_reg_n_2_[24]\,
      DI(1) => \start_addr_reg_n_2_[23]\,
      DI(0) => \start_addr_reg_n_2_[22]\,
      O(3) => \end_addr_carry__4_n_6\,
      O(2) => \end_addr_carry__4_n_7\,
      O(1) => \end_addr_carry__4_n_8\,
      O(0) => \end_addr_carry__4_n_9\,
      S(3) => \end_addr_carry__4_i_1__0_n_2\,
      S(2) => \end_addr_carry__4_i_2__0_n_2\,
      S(1) => \end_addr_carry__4_i_3__0_n_2\,
      S(0) => \end_addr_carry__4_i_4__0_n_2\
    );
\end_addr_carry__4_i_1__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[25]\,
      I1 => \align_len_reg_n_2_[25]\,
      O => \end_addr_carry__4_i_1__0_n_2\
    );
\end_addr_carry__4_i_2__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[24]\,
      I1 => \align_len_reg_n_2_[24]\,
      O => \end_addr_carry__4_i_2__0_n_2\
    );
\end_addr_carry__4_i_3__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[23]\,
      I1 => \align_len_reg_n_2_[23]\,
      O => \end_addr_carry__4_i_3__0_n_2\
    );
\end_addr_carry__4_i_4__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[22]\,
      I1 => \align_len_reg_n_2_[22]\,
      O => \end_addr_carry__4_i_4__0_n_2\
    );
\end_addr_carry__5\: unisim.vcomponents.CARRY4
     port map (
      CI => \end_addr_carry__4_n_2\,
      CO(3) => \end_addr_carry__5_n_2\,
      CO(2) => \end_addr_carry__5_n_3\,
      CO(1) => \end_addr_carry__5_n_4\,
      CO(0) => \end_addr_carry__5_n_5\,
      CYINIT => '0',
      DI(3) => \start_addr_reg_n_2_[29]\,
      DI(2) => \start_addr_reg_n_2_[28]\,
      DI(1) => \start_addr_reg_n_2_[27]\,
      DI(0) => \start_addr_reg_n_2_[26]\,
      O(3) => \end_addr_carry__5_n_6\,
      O(2) => \end_addr_carry__5_n_7\,
      O(1) => \end_addr_carry__5_n_8\,
      O(0) => \end_addr_carry__5_n_9\,
      S(3) => \end_addr_carry__5_i_1__0_n_2\,
      S(2) => \end_addr_carry__5_i_2__0_n_2\,
      S(1) => \end_addr_carry__5_i_3__0_n_2\,
      S(0) => \end_addr_carry__5_i_4__0_n_2\
    );
\end_addr_carry__5_i_1__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[29]\,
      I1 => \align_len_reg_n_2_[29]\,
      O => \end_addr_carry__5_i_1__0_n_2\
    );
\end_addr_carry__5_i_2__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[28]\,
      I1 => \align_len_reg_n_2_[28]\,
      O => \end_addr_carry__5_i_2__0_n_2\
    );
\end_addr_carry__5_i_3__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[27]\,
      I1 => \align_len_reg_n_2_[27]\,
      O => \end_addr_carry__5_i_3__0_n_2\
    );
\end_addr_carry__5_i_4__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[26]\,
      I1 => \align_len_reg_n_2_[26]\,
      O => \end_addr_carry__5_i_4__0_n_2\
    );
\end_addr_carry__6\: unisim.vcomponents.CARRY4
     port map (
      CI => \end_addr_carry__5_n_2\,
      CO(3 downto 1) => \NLW_end_addr_carry__6_CO_UNCONNECTED\(3 downto 1),
      CO(0) => \end_addr_carry__6_n_5\,
      CYINIT => '0',
      DI(3 downto 1) => B"000",
      DI(0) => \start_addr_reg_n_2_[30]\,
      O(3 downto 2) => \NLW_end_addr_carry__6_O_UNCONNECTED\(3 downto 2),
      O(1) => \end_addr_carry__6_n_8\,
      O(0) => \end_addr_carry__6_n_9\,
      S(3 downto 2) => B"00",
      S(1) => \end_addr_carry__6_i_1__0_n_2\,
      S(0) => \end_addr_carry__6_i_2__0_n_2\
    );
\end_addr_carry__6_i_1__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \align_len_reg_n_2_[31]\,
      I1 => \start_addr_reg_n_2_[31]\,
      O => \end_addr_carry__6_i_1__0_n_2\
    );
\end_addr_carry__6_i_2__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[30]\,
      I1 => \align_len_reg_n_2_[30]\,
      O => \end_addr_carry__6_i_2__0_n_2\
    );
\end_addr_carry_i_1__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[5]\,
      I1 => \align_len_reg_n_2_[5]\,
      O => \end_addr_carry_i_1__0_n_2\
    );
\end_addr_carry_i_2__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[4]\,
      I1 => \align_len_reg_n_2_[4]\,
      O => \end_addr_carry_i_2__0_n_2\
    );
\end_addr_carry_i_3__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[3]\,
      I1 => \align_len_reg_n_2_[3]\,
      O => \end_addr_carry_i_3__0_n_2\
    );
\end_addr_carry_i_4__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[2]\,
      I1 => \align_len_reg_n_2_[2]\,
      O => \end_addr_carry_i_4__0_n_2\
    );
fifo_rctl: entity work.\design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo__parameterized1_0\
     port map (
      CO(0) => last_sect,
      E(0) => next_rreq,
      Q(9) => \end_addr_buf_reg_n_2_[11]\,
      Q(8) => \end_addr_buf_reg_n_2_[10]\,
      Q(7) => \end_addr_buf_reg_n_2_[9]\,
      Q(6) => \end_addr_buf_reg_n_2_[8]\,
      Q(5) => \end_addr_buf_reg_n_2_[7]\,
      Q(4) => \end_addr_buf_reg_n_2_[6]\,
      Q(3) => \end_addr_buf_reg_n_2_[5]\,
      Q(2) => \end_addr_buf_reg_n_2_[4]\,
      Q(1) => \end_addr_buf_reg_n_2_[3]\,
      Q(0) => \end_addr_buf_reg_n_2_[2]\,
      SR(0) => \^sr\(0),
      ap_clk => ap_clk,
      ap_rst_n => ap_rst_n,
      ap_rst_n_0(0) => fifo_rctl_n_7,
      ap_rst_n_1(0) => fifo_rctl_n_12,
      \beat_len_buf_reg[1]\ => fifo_rctl_n_15,
      \beat_len_buf_reg[2]\ => fifo_rctl_n_16,
      \beat_len_buf_reg[4]\ => fifo_rctl_n_18,
      \beat_len_buf_reg[5]\ => fifo_rctl_n_19,
      \beat_len_buf_reg[9]\ => fifo_rctl_n_23,
      beat_valid => beat_valid,
      \could_multi_bursts.ARVALID_Dummy_reg\ => \^could_multi_bursts.arvalid_dummy_reg_0\,
      \could_multi_bursts.arlen_buf_reg[0]\ => \could_multi_bursts.arlen_buf[3]_i_3_n_2\,
      \could_multi_bursts.arlen_buf_reg[3]\(3 downto 0) => p_1_in(3 downto 0),
      \could_multi_bursts.sect_handling_reg\(0) => p_21_in,
      \could_multi_bursts.sect_handling_reg_0\ => fifo_rctl_n_6,
      \could_multi_bursts.sect_handling_reg_1\ => fifo_rctl_n_11,
      \could_multi_bursts.sect_handling_reg_2\ => fifo_rctl_n_13,
      \could_multi_bursts.sect_handling_reg_3\ => fifo_rctl_n_24,
      \could_multi_bursts.sect_handling_reg_4\ => fifo_rctl_n_25,
      \could_multi_bursts.sect_handling_reg_5\ => fifo_rctl_n_26,
      \could_multi_bursts.sect_handling_reg_6\ => fifo_rctl_n_27,
      \could_multi_bursts.sect_handling_reg_7\ => fifo_rctl_n_28,
      \could_multi_bursts.sect_handling_reg_8\ => \could_multi_bursts.sect_handling_reg_n_2\,
      data_vld_reg_0(0) => data_pack(34),
      empty_n_reg_0 => \bus_equal_gen.rdata_valid_t_reg_n_2\,
      \end_addr_buf_reg[10]\ => fifo_rctl_n_22,
      \end_addr_buf_reg[2]\ => fifo_rctl_n_14,
      \end_addr_buf_reg[8]\ => fifo_rctl_n_20,
      fifo_rreq_valid => fifo_rreq_valid,
      invalid_len_event => invalid_len_event,
      invalid_len_event_reg2 => invalid_len_event_reg2,
      invalid_len_event_reg2_reg => fifo_rctl_n_2,
      m_axi_gmem_ARREADY => m_axi_gmem_ARREADY,
      next_beat => next_beat,
      push => push,
      rdata_ack_t => rdata_ack_t,
      rreq_handling_reg => fifo_rctl_n_4,
      rreq_handling_reg_0(0) => fifo_rctl_n_9,
      rreq_handling_reg_1 => fifo_rctl_n_10,
      rreq_handling_reg_2 => fifo_rreq_valid_buf_reg_n_2,
      rreq_handling_reg_3 => fifo_rreq_n_25,
      rreq_handling_reg_4 => fifo_rreq_n_26,
      rreq_handling_reg_5 => rreq_handling_reg_n_2,
      \sect_addr_buf_reg[2]\(0) => first_sect,
      \sect_len_buf_reg[9]\(9) => \beat_len_buf_reg_n_2_[9]\,
      \sect_len_buf_reg[9]\(8) => \beat_len_buf_reg_n_2_[8]\,
      \sect_len_buf_reg[9]\(7) => \beat_len_buf_reg_n_2_[7]\,
      \sect_len_buf_reg[9]\(6) => \beat_len_buf_reg_n_2_[6]\,
      \sect_len_buf_reg[9]\(5) => \beat_len_buf_reg_n_2_[5]\,
      \sect_len_buf_reg[9]\(4) => \beat_len_buf_reg_n_2_[4]\,
      \sect_len_buf_reg[9]\(3) => \beat_len_buf_reg_n_2_[3]\,
      \sect_len_buf_reg[9]\(2) => \beat_len_buf_reg_n_2_[2]\,
      \sect_len_buf_reg[9]\(1) => \beat_len_buf_reg_n_2_[1]\,
      \sect_len_buf_reg[9]\(0) => \beat_len_buf_reg_n_2_[0]\,
      \sect_len_buf_reg[9]_0\(9) => \start_addr_buf_reg_n_2_[11]\,
      \sect_len_buf_reg[9]_0\(8) => \start_addr_buf_reg_n_2_[10]\,
      \sect_len_buf_reg[9]_0\(7) => \start_addr_buf_reg_n_2_[9]\,
      \sect_len_buf_reg[9]_0\(6) => \start_addr_buf_reg_n_2_[8]\,
      \sect_len_buf_reg[9]_0\(5) => \start_addr_buf_reg_n_2_[7]\,
      \sect_len_buf_reg[9]_0\(4) => \start_addr_buf_reg_n_2_[6]\,
      \sect_len_buf_reg[9]_0\(3) => \start_addr_buf_reg_n_2_[5]\,
      \sect_len_buf_reg[9]_0\(2) => \start_addr_buf_reg_n_2_[4]\,
      \sect_len_buf_reg[9]_0\(1) => \start_addr_buf_reg_n_2_[3]\,
      \sect_len_buf_reg[9]_0\(0) => \start_addr_buf_reg_n_2_[2]\,
      \start_addr_buf_reg[5]\ => fifo_rctl_n_17,
      \start_addr_buf_reg[9]\ => fifo_rctl_n_21
    );
fifo_rreq: entity work.\design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo__parameterized0_1\
     port map (
      CO(0) => last_sect,
      D(19) => fifo_rreq_n_4,
      D(18) => fifo_rreq_n_5,
      D(17) => fifo_rreq_n_6,
      D(16) => fifo_rreq_n_7,
      D(15) => fifo_rreq_n_8,
      D(14) => fifo_rreq_n_9,
      D(13) => fifo_rreq_n_10,
      D(12) => fifo_rreq_n_11,
      D(11) => fifo_rreq_n_12,
      D(10) => fifo_rreq_n_13,
      D(9) => fifo_rreq_n_14,
      D(8) => fifo_rreq_n_15,
      D(7) => fifo_rreq_n_16,
      D(6) => fifo_rreq_n_17,
      D(5) => fifo_rreq_n_18,
      D(4) => fifo_rreq_n_19,
      D(3) => fifo_rreq_n_20,
      D(2) => fifo_rreq_n_21,
      D(1) => fifo_rreq_n_22,
      D(0) => fifo_rreq_n_23,
      E(0) => align_len,
      O(3) => sect_cnt0_carry_n_6,
      O(2) => sect_cnt0_carry_n_7,
      O(1) => sect_cnt0_carry_n_8,
      O(0) => sect_cnt0_carry_n_9,
      Q(19) => \sect_cnt_reg_n_2_[19]\,
      Q(18) => \sect_cnt_reg_n_2_[18]\,
      Q(17) => \sect_cnt_reg_n_2_[17]\,
      Q(16) => \sect_cnt_reg_n_2_[16]\,
      Q(15) => \sect_cnt_reg_n_2_[15]\,
      Q(14) => \sect_cnt_reg_n_2_[14]\,
      Q(13) => \sect_cnt_reg_n_2_[13]\,
      Q(12) => \sect_cnt_reg_n_2_[12]\,
      Q(11) => \sect_cnt_reg_n_2_[11]\,
      Q(10) => \sect_cnt_reg_n_2_[10]\,
      Q(9) => \sect_cnt_reg_n_2_[9]\,
      Q(8) => \sect_cnt_reg_n_2_[8]\,
      Q(7) => \sect_cnt_reg_n_2_[7]\,
      Q(6) => \sect_cnt_reg_n_2_[6]\,
      Q(5) => \sect_cnt_reg_n_2_[5]\,
      Q(4) => \sect_cnt_reg_n_2_[4]\,
      Q(3) => \sect_cnt_reg_n_2_[3]\,
      Q(2) => \sect_cnt_reg_n_2_[2]\,
      Q(1) => \sect_cnt_reg_n_2_[1]\,
      Q(0) => \sect_cnt_reg_n_2_[0]\,
      S(2) => fifo_rreq_n_27,
      S(1) => fifo_rreq_n_28,
      S(0) => fifo_rreq_n_29,
      SR(0) => \^sr\(0),
      ap_clk => ap_clk,
      ap_rst_n => ap_rst_n,
      \could_multi_bursts.arlen_buf[3]_i_3\(5 downto 0) => \could_multi_bursts.loop_cnt_reg__0\(5 downto 0),
      \could_multi_bursts.arlen_buf[3]_i_3_0\(5) => \sect_len_buf_reg_n_2_[9]\,
      \could_multi_bursts.arlen_buf[3]_i_3_0\(4) => \sect_len_buf_reg_n_2_[8]\,
      \could_multi_bursts.arlen_buf[3]_i_3_0\(3) => \sect_len_buf_reg_n_2_[7]\,
      \could_multi_bursts.arlen_buf[3]_i_3_0\(2) => \sect_len_buf_reg_n_2_[6]\,
      \could_multi_bursts.arlen_buf[3]_i_3_0\(1) => \sect_len_buf_reg_n_2_[5]\,
      \could_multi_bursts.arlen_buf[3]_i_3_0\(0) => \sect_len_buf_reg_n_2_[4]\,
      \could_multi_bursts.loop_cnt_reg[0]\ => fifo_rreq_n_26,
      \could_multi_bursts.loop_cnt_reg[3]\ => fifo_rreq_n_25,
      \end_addr_buf_reg[23]\(3) => fifo_rreq_n_116,
      \end_addr_buf_reg[23]\(2) => fifo_rreq_n_117,
      \end_addr_buf_reg[23]\(1) => fifo_rreq_n_118,
      \end_addr_buf_reg[23]\(0) => fifo_rreq_n_119,
      fifo_rreq_valid => fifo_rreq_valid,
      full_n_reg_0 => fifo_rctl_n_6,
      full_n_reg_1 => rreq_handling_reg_n_2,
      invalid_len_event0 => invalid_len_event0,
      \last_sect_carry__0\(19) => \end_addr_buf_reg_n_2_[31]\,
      \last_sect_carry__0\(18) => \end_addr_buf_reg_n_2_[30]\,
      \last_sect_carry__0\(17) => \end_addr_buf_reg_n_2_[29]\,
      \last_sect_carry__0\(16) => \end_addr_buf_reg_n_2_[28]\,
      \last_sect_carry__0\(15) => \end_addr_buf_reg_n_2_[27]\,
      \last_sect_carry__0\(14) => \end_addr_buf_reg_n_2_[26]\,
      \last_sect_carry__0\(13) => \end_addr_buf_reg_n_2_[25]\,
      \last_sect_carry__0\(12) => \end_addr_buf_reg_n_2_[24]\,
      \last_sect_carry__0\(11) => \end_addr_buf_reg_n_2_[23]\,
      \last_sect_carry__0\(10) => \end_addr_buf_reg_n_2_[22]\,
      \last_sect_carry__0\(9) => \end_addr_buf_reg_n_2_[21]\,
      \last_sect_carry__0\(8) => \end_addr_buf_reg_n_2_[20]\,
      \last_sect_carry__0\(7) => \end_addr_buf_reg_n_2_[19]\,
      \last_sect_carry__0\(6) => \end_addr_buf_reg_n_2_[18]\,
      \last_sect_carry__0\(5) => \end_addr_buf_reg_n_2_[17]\,
      \last_sect_carry__0\(4) => \end_addr_buf_reg_n_2_[16]\,
      \last_sect_carry__0\(3) => \end_addr_buf_reg_n_2_[15]\,
      \last_sect_carry__0\(2) => \end_addr_buf_reg_n_2_[14]\,
      \last_sect_carry__0\(1) => \end_addr_buf_reg_n_2_[13]\,
      \last_sect_carry__0\(0) => \end_addr_buf_reg_n_2_[12]\,
      push => push_0,
      \q_reg[34]_0\(2) => fifo_rreq_n_113,
      \q_reg[34]_0\(1) => fifo_rreq_n_114,
      \q_reg[34]_0\(0) => fifo_rreq_n_115,
      \q_reg[38]_0\(3) => fifo_rreq_n_109,
      \q_reg[38]_0\(2) => fifo_rreq_n_110,
      \q_reg[38]_0\(1) => fifo_rreq_n_111,
      \q_reg[38]_0\(0) => fifo_rreq_n_112,
      \q_reg[42]_0\(3) => fifo_rreq_n_105,
      \q_reg[42]_0\(2) => fifo_rreq_n_106,
      \q_reg[42]_0\(1) => fifo_rreq_n_107,
      \q_reg[42]_0\(0) => fifo_rreq_n_108,
      \q_reg[46]_0\(3) => fifo_rreq_n_101,
      \q_reg[46]_0\(2) => fifo_rreq_n_102,
      \q_reg[46]_0\(1) => fifo_rreq_n_103,
      \q_reg[46]_0\(0) => fifo_rreq_n_104,
      \q_reg[50]_0\(3) => fifo_rreq_n_97,
      \q_reg[50]_0\(2) => fifo_rreq_n_98,
      \q_reg[50]_0\(1) => fifo_rreq_n_99,
      \q_reg[50]_0\(0) => fifo_rreq_n_100,
      \q_reg[54]_0\(3) => fifo_rreq_n_93,
      \q_reg[54]_0\(2) => fifo_rreq_n_94,
      \q_reg[54]_0\(1) => fifo_rreq_n_95,
      \q_reg[54]_0\(0) => fifo_rreq_n_96,
      \q_reg[58]_0\(3) => fifo_rreq_n_89,
      \q_reg[58]_0\(2) => fifo_rreq_n_90,
      \q_reg[58]_0\(1) => fifo_rreq_n_91,
      \q_reg[58]_0\(0) => fifo_rreq_n_92,
      \q_reg[60]_0\(58 downto 30) => fifo_rreq_data(60 downto 32),
      \q_reg[60]_0\(29) => fifo_rreq_n_59,
      \q_reg[60]_0\(28) => fifo_rreq_n_60,
      \q_reg[60]_0\(27) => fifo_rreq_n_61,
      \q_reg[60]_0\(26) => fifo_rreq_n_62,
      \q_reg[60]_0\(25) => fifo_rreq_n_63,
      \q_reg[60]_0\(24) => fifo_rreq_n_64,
      \q_reg[60]_0\(23) => fifo_rreq_n_65,
      \q_reg[60]_0\(22) => fifo_rreq_n_66,
      \q_reg[60]_0\(21) => fifo_rreq_n_67,
      \q_reg[60]_0\(20) => fifo_rreq_n_68,
      \q_reg[60]_0\(19) => fifo_rreq_n_69,
      \q_reg[60]_0\(18) => fifo_rreq_n_70,
      \q_reg[60]_0\(17) => fifo_rreq_n_71,
      \q_reg[60]_0\(16) => fifo_rreq_n_72,
      \q_reg[60]_0\(15) => fifo_rreq_n_73,
      \q_reg[60]_0\(14) => fifo_rreq_n_74,
      \q_reg[60]_0\(13) => fifo_rreq_n_75,
      \q_reg[60]_0\(12) => fifo_rreq_n_76,
      \q_reg[60]_0\(11) => fifo_rreq_n_77,
      \q_reg[60]_0\(10) => fifo_rreq_n_78,
      \q_reg[60]_0\(9) => fifo_rreq_n_79,
      \q_reg[60]_0\(8) => fifo_rreq_n_80,
      \q_reg[60]_0\(7) => fifo_rreq_n_81,
      \q_reg[60]_0\(6) => fifo_rreq_n_82,
      \q_reg[60]_0\(5) => fifo_rreq_n_83,
      \q_reg[60]_0\(4) => fifo_rreq_n_84,
      \q_reg[60]_0\(3) => fifo_rreq_n_85,
      \q_reg[60]_0\(2) => fifo_rreq_n_86,
      \q_reg[60]_0\(1) => fifo_rreq_n_87,
      \q_reg[60]_0\(0) => fifo_rreq_n_88,
      \q_reg[63]_0\(61 downto 30) => rs2f_rreq_data(63 downto 32),
      \q_reg[63]_0\(29 downto 0) => rs2f_rreq_data(29 downto 0),
      rs2f_rreq_ack => rs2f_rreq_ack,
      \sect_cnt_reg[0]\ => fifo_rreq_valid_buf_reg_n_2,
      \sect_cnt_reg[0]_0\ => fifo_rctl_n_4,
      \sect_cnt_reg[12]\(3) => \sect_cnt0_carry__1_n_6\,
      \sect_cnt_reg[12]\(2) => \sect_cnt0_carry__1_n_7\,
      \sect_cnt_reg[12]\(1) => \sect_cnt0_carry__1_n_8\,
      \sect_cnt_reg[12]\(0) => \sect_cnt0_carry__1_n_9\,
      \sect_cnt_reg[16]\(3) => \sect_cnt0_carry__2_n_6\,
      \sect_cnt_reg[16]\(2) => \sect_cnt0_carry__2_n_7\,
      \sect_cnt_reg[16]\(1) => \sect_cnt0_carry__2_n_8\,
      \sect_cnt_reg[16]\(0) => \sect_cnt0_carry__2_n_9\,
      \sect_cnt_reg[19]\(2) => fifo_rreq_n_120,
      \sect_cnt_reg[19]\(1) => fifo_rreq_n_121,
      \sect_cnt_reg[19]\(0) => fifo_rreq_n_122,
      \sect_cnt_reg[19]_0\(19) => \start_addr_reg_n_2_[31]\,
      \sect_cnt_reg[19]_0\(18) => \start_addr_reg_n_2_[30]\,
      \sect_cnt_reg[19]_0\(17) => \start_addr_reg_n_2_[29]\,
      \sect_cnt_reg[19]_0\(16) => \start_addr_reg_n_2_[28]\,
      \sect_cnt_reg[19]_0\(15) => \start_addr_reg_n_2_[27]\,
      \sect_cnt_reg[19]_0\(14) => \start_addr_reg_n_2_[26]\,
      \sect_cnt_reg[19]_0\(13) => \start_addr_reg_n_2_[25]\,
      \sect_cnt_reg[19]_0\(12) => \start_addr_reg_n_2_[24]\,
      \sect_cnt_reg[19]_0\(11) => \start_addr_reg_n_2_[23]\,
      \sect_cnt_reg[19]_0\(10) => \start_addr_reg_n_2_[22]\,
      \sect_cnt_reg[19]_0\(9) => \start_addr_reg_n_2_[21]\,
      \sect_cnt_reg[19]_0\(8) => \start_addr_reg_n_2_[20]\,
      \sect_cnt_reg[19]_0\(7) => \start_addr_reg_n_2_[19]\,
      \sect_cnt_reg[19]_0\(6) => \start_addr_reg_n_2_[18]\,
      \sect_cnt_reg[19]_0\(5) => \start_addr_reg_n_2_[17]\,
      \sect_cnt_reg[19]_0\(4) => \start_addr_reg_n_2_[16]\,
      \sect_cnt_reg[19]_0\(3) => \start_addr_reg_n_2_[15]\,
      \sect_cnt_reg[19]_0\(2) => \start_addr_reg_n_2_[14]\,
      \sect_cnt_reg[19]_0\(1) => \start_addr_reg_n_2_[13]\,
      \sect_cnt_reg[19]_0\(0) => \start_addr_reg_n_2_[12]\,
      \sect_cnt_reg[19]_1\(2) => \sect_cnt0_carry__3_n_7\,
      \sect_cnt_reg[19]_1\(1) => \sect_cnt0_carry__3_n_8\,
      \sect_cnt_reg[19]_1\(0) => \sect_cnt0_carry__3_n_9\,
      \sect_cnt_reg[8]\(3) => \sect_cnt0_carry__0_n_6\,
      \sect_cnt_reg[8]\(2) => \sect_cnt0_carry__0_n_7\,
      \sect_cnt_reg[8]\(1) => \sect_cnt0_carry__0_n_8\,
      \sect_cnt_reg[8]\(0) => \sect_cnt0_carry__0_n_9\
    );
fifo_rreq_valid_buf_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => fifo_rreq_valid,
      Q => fifo_rreq_valid_buf_reg_n_2,
      R => \^sr\(0)
    );
first_sect_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => first_sect_carry_n_2,
      CO(2) => first_sect_carry_n_3,
      CO(1) => first_sect_carry_n_4,
      CO(0) => first_sect_carry_n_5,
      CYINIT => '1',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => NLW_first_sect_carry_O_UNCONNECTED(3 downto 0),
      S(3) => \first_sect_carry_i_1__0_n_2\,
      S(2) => \first_sect_carry_i_2__0_n_2\,
      S(1) => \first_sect_carry_i_3__0_n_2\,
      S(0) => \first_sect_carry_i_4__0_n_2\
    );
\first_sect_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => first_sect_carry_n_2,
      CO(3) => \NLW_first_sect_carry__0_CO_UNCONNECTED\(3),
      CO(2) => first_sect,
      CO(1) => \first_sect_carry__0_n_4\,
      CO(0) => \first_sect_carry__0_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_first_sect_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => '0',
      S(2) => \first_sect_carry__0_i_1__0_n_2\,
      S(1) => \first_sect_carry__0_i_2__0_n_2\,
      S(0) => \first_sect_carry__0_i_3__0_n_2\
    );
\first_sect_carry__0_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \start_addr_buf_reg_n_2_[31]\,
      I1 => \sect_cnt_reg_n_2_[19]\,
      I2 => \start_addr_buf_reg_n_2_[30]\,
      I3 => \sect_cnt_reg_n_2_[18]\,
      O => \first_sect_carry__0_i_1__0_n_2\
    );
\first_sect_carry__0_i_2__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \start_addr_buf_reg_n_2_[29]\,
      I1 => \sect_cnt_reg_n_2_[17]\,
      I2 => \sect_cnt_reg_n_2_[16]\,
      I3 => \start_addr_buf_reg_n_2_[28]\,
      I4 => \sect_cnt_reg_n_2_[15]\,
      I5 => \start_addr_buf_reg_n_2_[27]\,
      O => \first_sect_carry__0_i_2__0_n_2\
    );
\first_sect_carry__0_i_3__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \start_addr_buf_reg_n_2_[26]\,
      I1 => \sect_cnt_reg_n_2_[14]\,
      I2 => \sect_cnt_reg_n_2_[12]\,
      I3 => \start_addr_buf_reg_n_2_[24]\,
      I4 => \sect_cnt_reg_n_2_[13]\,
      I5 => \start_addr_buf_reg_n_2_[25]\,
      O => \first_sect_carry__0_i_3__0_n_2\
    );
\first_sect_carry_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \start_addr_buf_reg_n_2_[23]\,
      I1 => \sect_cnt_reg_n_2_[11]\,
      I2 => \sect_cnt_reg_n_2_[9]\,
      I3 => \start_addr_buf_reg_n_2_[21]\,
      I4 => \sect_cnt_reg_n_2_[10]\,
      I5 => \start_addr_buf_reg_n_2_[22]\,
      O => \first_sect_carry_i_1__0_n_2\
    );
\first_sect_carry_i_2__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \sect_cnt_reg_n_2_[6]\,
      I1 => \start_addr_buf_reg_n_2_[18]\,
      I2 => \sect_cnt_reg_n_2_[7]\,
      I3 => \start_addr_buf_reg_n_2_[19]\,
      I4 => \start_addr_buf_reg_n_2_[20]\,
      I5 => \sect_cnt_reg_n_2_[8]\,
      O => \first_sect_carry_i_2__0_n_2\
    );
\first_sect_carry_i_3__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \sect_cnt_reg_n_2_[3]\,
      I1 => \start_addr_buf_reg_n_2_[15]\,
      I2 => \sect_cnt_reg_n_2_[5]\,
      I3 => \start_addr_buf_reg_n_2_[17]\,
      I4 => \start_addr_buf_reg_n_2_[16]\,
      I5 => \sect_cnt_reg_n_2_[4]\,
      O => \first_sect_carry_i_3__0_n_2\
    );
\first_sect_carry_i_4__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \start_addr_buf_reg_n_2_[12]\,
      I1 => \sect_cnt_reg_n_2_[0]\,
      I2 => \sect_cnt_reg_n_2_[1]\,
      I3 => \start_addr_buf_reg_n_2_[13]\,
      I4 => \sect_cnt_reg_n_2_[2]\,
      I5 => \start_addr_buf_reg_n_2_[14]\,
      O => \first_sect_carry_i_4__0_n_2\
    );
invalid_len_event_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => invalid_len_event0,
      Q => invalid_len_event,
      R => \^sr\(0)
    );
invalid_len_event_reg1_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => invalid_len_event,
      Q => invalid_len_event_reg1_reg_n_2,
      R => \^sr\(0)
    );
invalid_len_event_reg2_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_21_in,
      D => invalid_len_event_reg1_reg_n_2,
      Q => invalid_len_event_reg2,
      R => \^sr\(0)
    );
last_sect_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => last_sect_carry_n_2,
      CO(2) => last_sect_carry_n_3,
      CO(1) => last_sect_carry_n_4,
      CO(0) => last_sect_carry_n_5,
      CYINIT => '1',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => NLW_last_sect_carry_O_UNCONNECTED(3 downto 0),
      S(3) => fifo_rreq_n_116,
      S(2) => fifo_rreq_n_117,
      S(1) => fifo_rreq_n_118,
      S(0) => fifo_rreq_n_119
    );
\last_sect_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => last_sect_carry_n_2,
      CO(3) => \NLW_last_sect_carry__0_CO_UNCONNECTED\(3),
      CO(2) => last_sect,
      CO(1) => \last_sect_carry__0_n_4\,
      CO(0) => \last_sect_carry__0_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_last_sect_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => '0',
      S(2) => fifo_rreq_n_120,
      S(1) => fifo_rreq_n_121,
      S(0) => fifo_rreq_n_122
    );
rreq_handling_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => fifo_rctl_n_10,
      Q => rreq_handling_reg_n_2,
      R => \^sr\(0)
    );
rs_rdata: entity work.\design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_reg_slice__parameterized0\
     port map (
      CO(0) => CO(0),
      Q(1 downto 0) => Q(2 downto 1),
      SR(0) => \^sr\(0),
      \ap_CS_fsm_reg[7]\ => \ap_CS_fsm_reg[7]\,
      \ap_CS_fsm_reg[8]\ => \ap_CS_fsm_reg[8]\,
      \ap_CS_fsm_reg[8]_0\ => \ap_CS_fsm_reg[8]_0\,
      \ap_CS_fsm_reg[8]_1\ => \ap_CS_fsm_reg[8]_1\,
      ap_clk => ap_clk,
      ap_enable_reg_pp0_iter0 => ap_enable_reg_pp0_iter0,
      ap_enable_reg_pp0_iter1_reg => ap_enable_reg_pp0_iter1_reg,
      ap_enable_reg_pp0_iter1_reg_0 => ap_enable_reg_pp0_iter1_reg_0,
      ap_enable_reg_pp0_iter2_reg => ap_enable_reg_pp0_iter2_reg,
      ap_rst_n => ap_rst_n,
      \data_p1_reg[31]_0\(31 downto 0) => \data_p1_reg[31]\(31 downto 0),
      \data_p2_reg[31]_0\(31 downto 0) => \bus_equal_gen.data_buf\(31 downto 0),
      exitcond_reg_251_pp0_iter1_reg => exitcond_reg_251_pp0_iter1_reg,
      i_reg_137 => i_reg_137,
      i_reg_1370 => i_reg_1370,
      rdata_ack_t => rdata_ack_t,
      s_ready_t_reg_0 => \bus_equal_gen.rdata_valid_t_reg_n_2\,
      \state_reg[0]_0\ => \state_reg[0]\,
      \state_reg[0]_1\(0) => \state_reg[0]_0\(0),
      sum_reg_125 => sum_reg_125,
      sum_reg_1250 => sum_reg_1250
    );
rs_rreq: entity work.design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_reg_slice_2
     port map (
      E(0) => E(0),
      Q(0) => Q(0),
      SR(0) => \^sr\(0),
      ap_clk => ap_clk,
      \data_p1_reg[63]_0\(61 downto 30) => rs2f_rreq_data(63 downto 32),
      \data_p1_reg[63]_0\(29 downto 0) => rs2f_rreq_data(29 downto 0),
      \data_p2_reg[63]_0\(61 downto 0) => \data_p2_reg[63]\(61 downto 0),
      push => push_0,
      rs2f_rreq_ack => rs2f_rreq_ack
    );
\sect_addr_buf[10]_i_1__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => first_sect,
      I1 => \start_addr_buf_reg_n_2_[10]\,
      O => \sect_addr_buf[10]_i_1__0_n_2\
    );
\sect_addr_buf[11]_i_2__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => first_sect,
      I1 => \start_addr_buf_reg_n_2_[11]\,
      O => \sect_addr_buf[11]_i_2__0_n_2\
    );
\sect_addr_buf[12]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \start_addr_buf_reg_n_2_[12]\,
      I1 => first_sect,
      I2 => \sect_cnt_reg_n_2_[0]\,
      O => \sect_addr_buf[12]_i_1__0_n_2\
    );
\sect_addr_buf[13]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \start_addr_buf_reg_n_2_[13]\,
      I1 => first_sect,
      I2 => \sect_cnt_reg_n_2_[1]\,
      O => \sect_addr_buf[13]_i_1__0_n_2\
    );
\sect_addr_buf[14]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \start_addr_buf_reg_n_2_[14]\,
      I1 => first_sect,
      I2 => \sect_cnt_reg_n_2_[2]\,
      O => \sect_addr_buf[14]_i_1__0_n_2\
    );
\sect_addr_buf[15]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \start_addr_buf_reg_n_2_[15]\,
      I1 => first_sect,
      I2 => \sect_cnt_reg_n_2_[3]\,
      O => \sect_addr_buf[15]_i_1__0_n_2\
    );
\sect_addr_buf[16]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \start_addr_buf_reg_n_2_[16]\,
      I1 => first_sect,
      I2 => \sect_cnt_reg_n_2_[4]\,
      O => \sect_addr_buf[16]_i_1__0_n_2\
    );
\sect_addr_buf[17]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \start_addr_buf_reg_n_2_[17]\,
      I1 => first_sect,
      I2 => \sect_cnt_reg_n_2_[5]\,
      O => \sect_addr_buf[17]_i_1__0_n_2\
    );
\sect_addr_buf[18]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \start_addr_buf_reg_n_2_[18]\,
      I1 => first_sect,
      I2 => \sect_cnt_reg_n_2_[6]\,
      O => \sect_addr_buf[18]_i_1__0_n_2\
    );
\sect_addr_buf[19]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \start_addr_buf_reg_n_2_[19]\,
      I1 => first_sect,
      I2 => \sect_cnt_reg_n_2_[7]\,
      O => \sect_addr_buf[19]_i_1__0_n_2\
    );
\sect_addr_buf[20]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \start_addr_buf_reg_n_2_[20]\,
      I1 => first_sect,
      I2 => \sect_cnt_reg_n_2_[8]\,
      O => \sect_addr_buf[20]_i_1__0_n_2\
    );
\sect_addr_buf[21]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \start_addr_buf_reg_n_2_[21]\,
      I1 => first_sect,
      I2 => \sect_cnt_reg_n_2_[9]\,
      O => \sect_addr_buf[21]_i_1__0_n_2\
    );
\sect_addr_buf[22]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \start_addr_buf_reg_n_2_[22]\,
      I1 => first_sect,
      I2 => \sect_cnt_reg_n_2_[10]\,
      O => \sect_addr_buf[22]_i_1__0_n_2\
    );
\sect_addr_buf[23]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \start_addr_buf_reg_n_2_[23]\,
      I1 => first_sect,
      I2 => \sect_cnt_reg_n_2_[11]\,
      O => \sect_addr_buf[23]_i_1__0_n_2\
    );
\sect_addr_buf[24]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \start_addr_buf_reg_n_2_[24]\,
      I1 => first_sect,
      I2 => \sect_cnt_reg_n_2_[12]\,
      O => \sect_addr_buf[24]_i_1__0_n_2\
    );
\sect_addr_buf[25]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \start_addr_buf_reg_n_2_[25]\,
      I1 => first_sect,
      I2 => \sect_cnt_reg_n_2_[13]\,
      O => \sect_addr_buf[25]_i_1__0_n_2\
    );
\sect_addr_buf[26]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \start_addr_buf_reg_n_2_[26]\,
      I1 => first_sect,
      I2 => \sect_cnt_reg_n_2_[14]\,
      O => \sect_addr_buf[26]_i_1__0_n_2\
    );
\sect_addr_buf[27]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \start_addr_buf_reg_n_2_[27]\,
      I1 => first_sect,
      I2 => \sect_cnt_reg_n_2_[15]\,
      O => \sect_addr_buf[27]_i_1__0_n_2\
    );
\sect_addr_buf[28]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \start_addr_buf_reg_n_2_[28]\,
      I1 => first_sect,
      I2 => \sect_cnt_reg_n_2_[16]\,
      O => \sect_addr_buf[28]_i_1__0_n_2\
    );
\sect_addr_buf[29]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \start_addr_buf_reg_n_2_[29]\,
      I1 => first_sect,
      I2 => \sect_cnt_reg_n_2_[17]\,
      O => \sect_addr_buf[29]_i_1__0_n_2\
    );
\sect_addr_buf[2]_i_1__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => first_sect,
      I1 => \start_addr_buf_reg_n_2_[2]\,
      O => \sect_addr_buf[2]_i_1__0_n_2\
    );
\sect_addr_buf[30]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \start_addr_buf_reg_n_2_[30]\,
      I1 => first_sect,
      I2 => \sect_cnt_reg_n_2_[18]\,
      O => \sect_addr_buf[30]_i_1__0_n_2\
    );
\sect_addr_buf[31]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \start_addr_buf_reg_n_2_[31]\,
      I1 => first_sect,
      I2 => \sect_cnt_reg_n_2_[19]\,
      O => \sect_addr_buf[31]_i_1__0_n_2\
    );
\sect_addr_buf[3]_i_1__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => first_sect,
      I1 => \start_addr_buf_reg_n_2_[3]\,
      O => \sect_addr_buf[3]_i_1__0_n_2\
    );
\sect_addr_buf[4]_i_1__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => first_sect,
      I1 => \start_addr_buf_reg_n_2_[4]\,
      O => \sect_addr_buf[4]_i_1__0_n_2\
    );
\sect_addr_buf[5]_i_1__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => first_sect,
      I1 => \start_addr_buf_reg_n_2_[5]\,
      O => \sect_addr_buf[5]_i_1__0_n_2\
    );
\sect_addr_buf[6]_i_1__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => first_sect,
      I1 => \start_addr_buf_reg_n_2_[6]\,
      O => \sect_addr_buf[6]_i_1__0_n_2\
    );
\sect_addr_buf[7]_i_1__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => first_sect,
      I1 => \start_addr_buf_reg_n_2_[7]\,
      O => \sect_addr_buf[7]_i_1__0_n_2\
    );
\sect_addr_buf[8]_i_1__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => first_sect,
      I1 => \start_addr_buf_reg_n_2_[8]\,
      O => \sect_addr_buf[8]_i_1__0_n_2\
    );
\sect_addr_buf[9]_i_1__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => first_sect,
      I1 => \start_addr_buf_reg_n_2_[9]\,
      O => \sect_addr_buf[9]_i_1__0_n_2\
    );
\sect_addr_buf_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_21_in,
      D => \sect_addr_buf[10]_i_1__0_n_2\,
      Q => \sect_addr_buf_reg_n_2_[10]\,
      R => fifo_rctl_n_12
    );
\sect_addr_buf_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_21_in,
      D => \sect_addr_buf[11]_i_2__0_n_2\,
      Q => \sect_addr_buf_reg_n_2_[11]\,
      R => fifo_rctl_n_12
    );
\sect_addr_buf_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_21_in,
      D => \sect_addr_buf[12]_i_1__0_n_2\,
      Q => \sect_addr_buf_reg_n_2_[12]\,
      R => \^sr\(0)
    );
\sect_addr_buf_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_21_in,
      D => \sect_addr_buf[13]_i_1__0_n_2\,
      Q => \sect_addr_buf_reg_n_2_[13]\,
      R => \^sr\(0)
    );
\sect_addr_buf_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_21_in,
      D => \sect_addr_buf[14]_i_1__0_n_2\,
      Q => \sect_addr_buf_reg_n_2_[14]\,
      R => \^sr\(0)
    );
\sect_addr_buf_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_21_in,
      D => \sect_addr_buf[15]_i_1__0_n_2\,
      Q => \sect_addr_buf_reg_n_2_[15]\,
      R => \^sr\(0)
    );
\sect_addr_buf_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_21_in,
      D => \sect_addr_buf[16]_i_1__0_n_2\,
      Q => \sect_addr_buf_reg_n_2_[16]\,
      R => \^sr\(0)
    );
\sect_addr_buf_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_21_in,
      D => \sect_addr_buf[17]_i_1__0_n_2\,
      Q => \sect_addr_buf_reg_n_2_[17]\,
      R => \^sr\(0)
    );
\sect_addr_buf_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_21_in,
      D => \sect_addr_buf[18]_i_1__0_n_2\,
      Q => \sect_addr_buf_reg_n_2_[18]\,
      R => \^sr\(0)
    );
\sect_addr_buf_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_21_in,
      D => \sect_addr_buf[19]_i_1__0_n_2\,
      Q => \sect_addr_buf_reg_n_2_[19]\,
      R => \^sr\(0)
    );
\sect_addr_buf_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_21_in,
      D => \sect_addr_buf[20]_i_1__0_n_2\,
      Q => \sect_addr_buf_reg_n_2_[20]\,
      R => \^sr\(0)
    );
\sect_addr_buf_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_21_in,
      D => \sect_addr_buf[21]_i_1__0_n_2\,
      Q => \sect_addr_buf_reg_n_2_[21]\,
      R => \^sr\(0)
    );
\sect_addr_buf_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_21_in,
      D => \sect_addr_buf[22]_i_1__0_n_2\,
      Q => \sect_addr_buf_reg_n_2_[22]\,
      R => \^sr\(0)
    );
\sect_addr_buf_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_21_in,
      D => \sect_addr_buf[23]_i_1__0_n_2\,
      Q => \sect_addr_buf_reg_n_2_[23]\,
      R => \^sr\(0)
    );
\sect_addr_buf_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_21_in,
      D => \sect_addr_buf[24]_i_1__0_n_2\,
      Q => \sect_addr_buf_reg_n_2_[24]\,
      R => \^sr\(0)
    );
\sect_addr_buf_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_21_in,
      D => \sect_addr_buf[25]_i_1__0_n_2\,
      Q => \sect_addr_buf_reg_n_2_[25]\,
      R => \^sr\(0)
    );
\sect_addr_buf_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_21_in,
      D => \sect_addr_buf[26]_i_1__0_n_2\,
      Q => \sect_addr_buf_reg_n_2_[26]\,
      R => \^sr\(0)
    );
\sect_addr_buf_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_21_in,
      D => \sect_addr_buf[27]_i_1__0_n_2\,
      Q => \sect_addr_buf_reg_n_2_[27]\,
      R => \^sr\(0)
    );
\sect_addr_buf_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_21_in,
      D => \sect_addr_buf[28]_i_1__0_n_2\,
      Q => \sect_addr_buf_reg_n_2_[28]\,
      R => \^sr\(0)
    );
\sect_addr_buf_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_21_in,
      D => \sect_addr_buf[29]_i_1__0_n_2\,
      Q => \sect_addr_buf_reg_n_2_[29]\,
      R => \^sr\(0)
    );
\sect_addr_buf_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_21_in,
      D => \sect_addr_buf[2]_i_1__0_n_2\,
      Q => \sect_addr_buf_reg_n_2_[2]\,
      R => fifo_rctl_n_12
    );
\sect_addr_buf_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_21_in,
      D => \sect_addr_buf[30]_i_1__0_n_2\,
      Q => \sect_addr_buf_reg_n_2_[30]\,
      R => \^sr\(0)
    );
\sect_addr_buf_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_21_in,
      D => \sect_addr_buf[31]_i_1__0_n_2\,
      Q => \sect_addr_buf_reg_n_2_[31]\,
      R => \^sr\(0)
    );
\sect_addr_buf_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_21_in,
      D => \sect_addr_buf[3]_i_1__0_n_2\,
      Q => \sect_addr_buf_reg_n_2_[3]\,
      R => fifo_rctl_n_12
    );
\sect_addr_buf_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_21_in,
      D => \sect_addr_buf[4]_i_1__0_n_2\,
      Q => \sect_addr_buf_reg_n_2_[4]\,
      R => fifo_rctl_n_12
    );
\sect_addr_buf_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_21_in,
      D => \sect_addr_buf[5]_i_1__0_n_2\,
      Q => \sect_addr_buf_reg_n_2_[5]\,
      R => fifo_rctl_n_12
    );
\sect_addr_buf_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_21_in,
      D => \sect_addr_buf[6]_i_1__0_n_2\,
      Q => \sect_addr_buf_reg_n_2_[6]\,
      R => fifo_rctl_n_12
    );
\sect_addr_buf_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_21_in,
      D => \sect_addr_buf[7]_i_1__0_n_2\,
      Q => \sect_addr_buf_reg_n_2_[7]\,
      R => fifo_rctl_n_12
    );
\sect_addr_buf_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_21_in,
      D => \sect_addr_buf[8]_i_1__0_n_2\,
      Q => \sect_addr_buf_reg_n_2_[8]\,
      R => fifo_rctl_n_12
    );
\sect_addr_buf_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_21_in,
      D => \sect_addr_buf[9]_i_1__0_n_2\,
      Q => \sect_addr_buf_reg_n_2_[9]\,
      R => fifo_rctl_n_12
    );
sect_cnt0_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => sect_cnt0_carry_n_2,
      CO(2) => sect_cnt0_carry_n_3,
      CO(1) => sect_cnt0_carry_n_4,
      CO(0) => sect_cnt0_carry_n_5,
      CYINIT => \sect_cnt_reg_n_2_[0]\,
      DI(3 downto 0) => B"0000",
      O(3) => sect_cnt0_carry_n_6,
      O(2) => sect_cnt0_carry_n_7,
      O(1) => sect_cnt0_carry_n_8,
      O(0) => sect_cnt0_carry_n_9,
      S(3) => \sect_cnt_reg_n_2_[4]\,
      S(2) => \sect_cnt_reg_n_2_[3]\,
      S(1) => \sect_cnt_reg_n_2_[2]\,
      S(0) => \sect_cnt_reg_n_2_[1]\
    );
\sect_cnt0_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => sect_cnt0_carry_n_2,
      CO(3) => \sect_cnt0_carry__0_n_2\,
      CO(2) => \sect_cnt0_carry__0_n_3\,
      CO(1) => \sect_cnt0_carry__0_n_4\,
      CO(0) => \sect_cnt0_carry__0_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \sect_cnt0_carry__0_n_6\,
      O(2) => \sect_cnt0_carry__0_n_7\,
      O(1) => \sect_cnt0_carry__0_n_8\,
      O(0) => \sect_cnt0_carry__0_n_9\,
      S(3) => \sect_cnt_reg_n_2_[8]\,
      S(2) => \sect_cnt_reg_n_2_[7]\,
      S(1) => \sect_cnt_reg_n_2_[6]\,
      S(0) => \sect_cnt_reg_n_2_[5]\
    );
\sect_cnt0_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \sect_cnt0_carry__0_n_2\,
      CO(3) => \sect_cnt0_carry__1_n_2\,
      CO(2) => \sect_cnt0_carry__1_n_3\,
      CO(1) => \sect_cnt0_carry__1_n_4\,
      CO(0) => \sect_cnt0_carry__1_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \sect_cnt0_carry__1_n_6\,
      O(2) => \sect_cnt0_carry__1_n_7\,
      O(1) => \sect_cnt0_carry__1_n_8\,
      O(0) => \sect_cnt0_carry__1_n_9\,
      S(3) => \sect_cnt_reg_n_2_[12]\,
      S(2) => \sect_cnt_reg_n_2_[11]\,
      S(1) => \sect_cnt_reg_n_2_[10]\,
      S(0) => \sect_cnt_reg_n_2_[9]\
    );
\sect_cnt0_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \sect_cnt0_carry__1_n_2\,
      CO(3) => \sect_cnt0_carry__2_n_2\,
      CO(2) => \sect_cnt0_carry__2_n_3\,
      CO(1) => \sect_cnt0_carry__2_n_4\,
      CO(0) => \sect_cnt0_carry__2_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \sect_cnt0_carry__2_n_6\,
      O(2) => \sect_cnt0_carry__2_n_7\,
      O(1) => \sect_cnt0_carry__2_n_8\,
      O(0) => \sect_cnt0_carry__2_n_9\,
      S(3) => \sect_cnt_reg_n_2_[16]\,
      S(2) => \sect_cnt_reg_n_2_[15]\,
      S(1) => \sect_cnt_reg_n_2_[14]\,
      S(0) => \sect_cnt_reg_n_2_[13]\
    );
\sect_cnt0_carry__3\: unisim.vcomponents.CARRY4
     port map (
      CI => \sect_cnt0_carry__2_n_2\,
      CO(3 downto 2) => \NLW_sect_cnt0_carry__3_CO_UNCONNECTED\(3 downto 2),
      CO(1) => \sect_cnt0_carry__3_n_4\,
      CO(0) => \sect_cnt0_carry__3_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \NLW_sect_cnt0_carry__3_O_UNCONNECTED\(3),
      O(2) => \sect_cnt0_carry__3_n_7\,
      O(1) => \sect_cnt0_carry__3_n_8\,
      O(0) => \sect_cnt0_carry__3_n_9\,
      S(3) => '0',
      S(2) => \sect_cnt_reg_n_2_[19]\,
      S(1) => \sect_cnt_reg_n_2_[18]\,
      S(0) => \sect_cnt_reg_n_2_[17]\
    );
\sect_cnt_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_rctl_n_9,
      D => fifo_rreq_n_23,
      Q => \sect_cnt_reg_n_2_[0]\,
      R => \^sr\(0)
    );
\sect_cnt_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_rctl_n_9,
      D => fifo_rreq_n_13,
      Q => \sect_cnt_reg_n_2_[10]\,
      R => \^sr\(0)
    );
\sect_cnt_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_rctl_n_9,
      D => fifo_rreq_n_12,
      Q => \sect_cnt_reg_n_2_[11]\,
      R => \^sr\(0)
    );
\sect_cnt_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_rctl_n_9,
      D => fifo_rreq_n_11,
      Q => \sect_cnt_reg_n_2_[12]\,
      R => \^sr\(0)
    );
\sect_cnt_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_rctl_n_9,
      D => fifo_rreq_n_10,
      Q => \sect_cnt_reg_n_2_[13]\,
      R => \^sr\(0)
    );
\sect_cnt_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_rctl_n_9,
      D => fifo_rreq_n_9,
      Q => \sect_cnt_reg_n_2_[14]\,
      R => \^sr\(0)
    );
\sect_cnt_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_rctl_n_9,
      D => fifo_rreq_n_8,
      Q => \sect_cnt_reg_n_2_[15]\,
      R => \^sr\(0)
    );
\sect_cnt_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_rctl_n_9,
      D => fifo_rreq_n_7,
      Q => \sect_cnt_reg_n_2_[16]\,
      R => \^sr\(0)
    );
\sect_cnt_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_rctl_n_9,
      D => fifo_rreq_n_6,
      Q => \sect_cnt_reg_n_2_[17]\,
      R => \^sr\(0)
    );
\sect_cnt_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_rctl_n_9,
      D => fifo_rreq_n_5,
      Q => \sect_cnt_reg_n_2_[18]\,
      R => \^sr\(0)
    );
\sect_cnt_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_rctl_n_9,
      D => fifo_rreq_n_4,
      Q => \sect_cnt_reg_n_2_[19]\,
      R => \^sr\(0)
    );
\sect_cnt_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_rctl_n_9,
      D => fifo_rreq_n_22,
      Q => \sect_cnt_reg_n_2_[1]\,
      R => \^sr\(0)
    );
\sect_cnt_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_rctl_n_9,
      D => fifo_rreq_n_21,
      Q => \sect_cnt_reg_n_2_[2]\,
      R => \^sr\(0)
    );
\sect_cnt_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_rctl_n_9,
      D => fifo_rreq_n_20,
      Q => \sect_cnt_reg_n_2_[3]\,
      R => \^sr\(0)
    );
\sect_cnt_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_rctl_n_9,
      D => fifo_rreq_n_19,
      Q => \sect_cnt_reg_n_2_[4]\,
      R => \^sr\(0)
    );
\sect_cnt_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_rctl_n_9,
      D => fifo_rreq_n_18,
      Q => \sect_cnt_reg_n_2_[5]\,
      R => \^sr\(0)
    );
\sect_cnt_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_rctl_n_9,
      D => fifo_rreq_n_17,
      Q => \sect_cnt_reg_n_2_[6]\,
      R => \^sr\(0)
    );
\sect_cnt_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_rctl_n_9,
      D => fifo_rreq_n_16,
      Q => \sect_cnt_reg_n_2_[7]\,
      R => \^sr\(0)
    );
\sect_cnt_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_rctl_n_9,
      D => fifo_rreq_n_15,
      Q => \sect_cnt_reg_n_2_[8]\,
      R => \^sr\(0)
    );
\sect_cnt_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_rctl_n_9,
      D => fifo_rreq_n_14,
      Q => \sect_cnt_reg_n_2_[9]\,
      R => \^sr\(0)
    );
\sect_len_buf_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_rctl_n_13,
      D => fifo_rctl_n_14,
      Q => p_1_in(0),
      R => \^sr\(0)
    );
\sect_len_buf_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_rctl_n_13,
      D => fifo_rctl_n_15,
      Q => p_1_in(1),
      R => \^sr\(0)
    );
\sect_len_buf_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_rctl_n_13,
      D => fifo_rctl_n_16,
      Q => p_1_in(2),
      R => \^sr\(0)
    );
\sect_len_buf_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_rctl_n_13,
      D => fifo_rctl_n_17,
      Q => p_1_in(3),
      R => \^sr\(0)
    );
\sect_len_buf_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_rctl_n_13,
      D => fifo_rctl_n_18,
      Q => \sect_len_buf_reg_n_2_[4]\,
      R => \^sr\(0)
    );
\sect_len_buf_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_rctl_n_13,
      D => fifo_rctl_n_19,
      Q => \sect_len_buf_reg_n_2_[5]\,
      R => \^sr\(0)
    );
\sect_len_buf_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_rctl_n_13,
      D => fifo_rctl_n_20,
      Q => \sect_len_buf_reg_n_2_[6]\,
      R => \^sr\(0)
    );
\sect_len_buf_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_rctl_n_13,
      D => fifo_rctl_n_21,
      Q => \sect_len_buf_reg_n_2_[7]\,
      R => \^sr\(0)
    );
\sect_len_buf_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_rctl_n_13,
      D => fifo_rctl_n_22,
      Q => \sect_len_buf_reg_n_2_[8]\,
      R => \^sr\(0)
    );
\sect_len_buf_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_rctl_n_13,
      D => fifo_rctl_n_23,
      Q => \sect_len_buf_reg_n_2_[9]\,
      R => \^sr\(0)
    );
\start_addr_buf_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \start_addr_reg_n_2_[10]\,
      Q => \start_addr_buf_reg_n_2_[10]\,
      R => \^sr\(0)
    );
\start_addr_buf_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \start_addr_reg_n_2_[11]\,
      Q => \start_addr_buf_reg_n_2_[11]\,
      R => \^sr\(0)
    );
\start_addr_buf_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \start_addr_reg_n_2_[12]\,
      Q => \start_addr_buf_reg_n_2_[12]\,
      R => \^sr\(0)
    );
\start_addr_buf_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \start_addr_reg_n_2_[13]\,
      Q => \start_addr_buf_reg_n_2_[13]\,
      R => \^sr\(0)
    );
\start_addr_buf_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \start_addr_reg_n_2_[14]\,
      Q => \start_addr_buf_reg_n_2_[14]\,
      R => \^sr\(0)
    );
\start_addr_buf_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \start_addr_reg_n_2_[15]\,
      Q => \start_addr_buf_reg_n_2_[15]\,
      R => \^sr\(0)
    );
\start_addr_buf_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \start_addr_reg_n_2_[16]\,
      Q => \start_addr_buf_reg_n_2_[16]\,
      R => \^sr\(0)
    );
\start_addr_buf_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \start_addr_reg_n_2_[17]\,
      Q => \start_addr_buf_reg_n_2_[17]\,
      R => \^sr\(0)
    );
\start_addr_buf_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \start_addr_reg_n_2_[18]\,
      Q => \start_addr_buf_reg_n_2_[18]\,
      R => \^sr\(0)
    );
\start_addr_buf_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \start_addr_reg_n_2_[19]\,
      Q => \start_addr_buf_reg_n_2_[19]\,
      R => \^sr\(0)
    );
\start_addr_buf_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \start_addr_reg_n_2_[20]\,
      Q => \start_addr_buf_reg_n_2_[20]\,
      R => \^sr\(0)
    );
\start_addr_buf_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \start_addr_reg_n_2_[21]\,
      Q => \start_addr_buf_reg_n_2_[21]\,
      R => \^sr\(0)
    );
\start_addr_buf_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \start_addr_reg_n_2_[22]\,
      Q => \start_addr_buf_reg_n_2_[22]\,
      R => \^sr\(0)
    );
\start_addr_buf_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \start_addr_reg_n_2_[23]\,
      Q => \start_addr_buf_reg_n_2_[23]\,
      R => \^sr\(0)
    );
\start_addr_buf_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \start_addr_reg_n_2_[24]\,
      Q => \start_addr_buf_reg_n_2_[24]\,
      R => \^sr\(0)
    );
\start_addr_buf_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \start_addr_reg_n_2_[25]\,
      Q => \start_addr_buf_reg_n_2_[25]\,
      R => \^sr\(0)
    );
\start_addr_buf_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \start_addr_reg_n_2_[26]\,
      Q => \start_addr_buf_reg_n_2_[26]\,
      R => \^sr\(0)
    );
\start_addr_buf_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \start_addr_reg_n_2_[27]\,
      Q => \start_addr_buf_reg_n_2_[27]\,
      R => \^sr\(0)
    );
\start_addr_buf_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \start_addr_reg_n_2_[28]\,
      Q => \start_addr_buf_reg_n_2_[28]\,
      R => \^sr\(0)
    );
\start_addr_buf_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \start_addr_reg_n_2_[29]\,
      Q => \start_addr_buf_reg_n_2_[29]\,
      R => \^sr\(0)
    );
\start_addr_buf_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \start_addr_reg_n_2_[2]\,
      Q => \start_addr_buf_reg_n_2_[2]\,
      R => \^sr\(0)
    );
\start_addr_buf_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \start_addr_reg_n_2_[30]\,
      Q => \start_addr_buf_reg_n_2_[30]\,
      R => \^sr\(0)
    );
\start_addr_buf_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \start_addr_reg_n_2_[31]\,
      Q => \start_addr_buf_reg_n_2_[31]\,
      R => \^sr\(0)
    );
\start_addr_buf_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \start_addr_reg_n_2_[3]\,
      Q => \start_addr_buf_reg_n_2_[3]\,
      R => \^sr\(0)
    );
\start_addr_buf_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \start_addr_reg_n_2_[4]\,
      Q => \start_addr_buf_reg_n_2_[4]\,
      R => \^sr\(0)
    );
\start_addr_buf_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \start_addr_reg_n_2_[5]\,
      Q => \start_addr_buf_reg_n_2_[5]\,
      R => \^sr\(0)
    );
\start_addr_buf_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \start_addr_reg_n_2_[6]\,
      Q => \start_addr_buf_reg_n_2_[6]\,
      R => \^sr\(0)
    );
\start_addr_buf_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \start_addr_reg_n_2_[7]\,
      Q => \start_addr_buf_reg_n_2_[7]\,
      R => \^sr\(0)
    );
\start_addr_buf_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \start_addr_reg_n_2_[8]\,
      Q => \start_addr_buf_reg_n_2_[8]\,
      R => \^sr\(0)
    );
\start_addr_buf_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_rreq,
      D => \start_addr_reg_n_2_[9]\,
      Q => \start_addr_buf_reg_n_2_[9]\,
      R => \^sr\(0)
    );
\start_addr_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => fifo_rreq_n_80,
      Q => \start_addr_reg_n_2_[10]\,
      R => \^sr\(0)
    );
\start_addr_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => fifo_rreq_n_79,
      Q => \start_addr_reg_n_2_[11]\,
      R => \^sr\(0)
    );
\start_addr_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => fifo_rreq_n_78,
      Q => \start_addr_reg_n_2_[12]\,
      R => \^sr\(0)
    );
\start_addr_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => fifo_rreq_n_77,
      Q => \start_addr_reg_n_2_[13]\,
      R => \^sr\(0)
    );
\start_addr_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => fifo_rreq_n_76,
      Q => \start_addr_reg_n_2_[14]\,
      R => \^sr\(0)
    );
\start_addr_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => fifo_rreq_n_75,
      Q => \start_addr_reg_n_2_[15]\,
      R => \^sr\(0)
    );
\start_addr_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => fifo_rreq_n_74,
      Q => \start_addr_reg_n_2_[16]\,
      R => \^sr\(0)
    );
\start_addr_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => fifo_rreq_n_73,
      Q => \start_addr_reg_n_2_[17]\,
      R => \^sr\(0)
    );
\start_addr_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => fifo_rreq_n_72,
      Q => \start_addr_reg_n_2_[18]\,
      R => \^sr\(0)
    );
\start_addr_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => fifo_rreq_n_71,
      Q => \start_addr_reg_n_2_[19]\,
      R => \^sr\(0)
    );
\start_addr_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => fifo_rreq_n_70,
      Q => \start_addr_reg_n_2_[20]\,
      R => \^sr\(0)
    );
\start_addr_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => fifo_rreq_n_69,
      Q => \start_addr_reg_n_2_[21]\,
      R => \^sr\(0)
    );
\start_addr_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => fifo_rreq_n_68,
      Q => \start_addr_reg_n_2_[22]\,
      R => \^sr\(0)
    );
\start_addr_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => fifo_rreq_n_67,
      Q => \start_addr_reg_n_2_[23]\,
      R => \^sr\(0)
    );
\start_addr_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => fifo_rreq_n_66,
      Q => \start_addr_reg_n_2_[24]\,
      R => \^sr\(0)
    );
\start_addr_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => fifo_rreq_n_65,
      Q => \start_addr_reg_n_2_[25]\,
      R => \^sr\(0)
    );
\start_addr_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => fifo_rreq_n_64,
      Q => \start_addr_reg_n_2_[26]\,
      R => \^sr\(0)
    );
\start_addr_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => fifo_rreq_n_63,
      Q => \start_addr_reg_n_2_[27]\,
      R => \^sr\(0)
    );
\start_addr_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => fifo_rreq_n_62,
      Q => \start_addr_reg_n_2_[28]\,
      R => \^sr\(0)
    );
\start_addr_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => fifo_rreq_n_61,
      Q => \start_addr_reg_n_2_[29]\,
      R => \^sr\(0)
    );
\start_addr_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => fifo_rreq_n_88,
      Q => \start_addr_reg_n_2_[2]\,
      R => \^sr\(0)
    );
\start_addr_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => fifo_rreq_n_60,
      Q => \start_addr_reg_n_2_[30]\,
      R => \^sr\(0)
    );
\start_addr_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => fifo_rreq_n_59,
      Q => \start_addr_reg_n_2_[31]\,
      R => \^sr\(0)
    );
\start_addr_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => fifo_rreq_n_87,
      Q => \start_addr_reg_n_2_[3]\,
      R => \^sr\(0)
    );
\start_addr_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => fifo_rreq_n_86,
      Q => \start_addr_reg_n_2_[4]\,
      R => \^sr\(0)
    );
\start_addr_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => fifo_rreq_n_85,
      Q => \start_addr_reg_n_2_[5]\,
      R => \^sr\(0)
    );
\start_addr_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => fifo_rreq_n_84,
      Q => \start_addr_reg_n_2_[6]\,
      R => \^sr\(0)
    );
\start_addr_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => fifo_rreq_n_83,
      Q => \start_addr_reg_n_2_[7]\,
      R => \^sr\(0)
    );
\start_addr_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => fifo_rreq_n_82,
      Q => \start_addr_reg_n_2_[8]\,
      R => \^sr\(0)
    );
\start_addr_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len,
      D => fifo_rreq_n_81,
      Q => \start_addr_reg_n_2_[9]\,
      R => \^sr\(0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_write is
  port (
    full_n_reg : out STD_LOGIC;
    empty_n_reg : out STD_LOGIC;
    AWVALID_Dummy : out STD_LOGIC;
    \bus_equal_gen.WVALID_Dummy_reg_0\ : out STD_LOGIC;
    m_axi_gmem_WLAST : out STD_LOGIC;
    \ap_CS_fsm_reg[15]\ : out STD_LOGIC_VECTOR ( 5 downto 0 );
    ap_done : out STD_LOGIC;
    E : out STD_LOGIC_VECTOR ( 0 to 0 );
    \could_multi_bursts.AWVALID_Dummy_reg_0\ : out STD_LOGIC;
    D : out STD_LOGIC_VECTOR ( 0 to 0 );
    \could_multi_bursts.awlen_buf_reg[3]_0\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \usedw_reg[5]\ : out STD_LOGIC_VECTOR ( 5 downto 0 );
    \ap_CS_fsm_reg[10]\ : out STD_LOGIC_VECTOR ( 0 to 0 );
    DI : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axi_gmem_AWADDR : out STD_LOGIC_VECTOR ( 29 downto 0 );
    S : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \usedw_reg[6]\ : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_gmem_WDATA : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_gmem_WSTRB : out STD_LOGIC_VECTOR ( 3 downto 0 );
    ap_clk : in STD_LOGIC;
    SR : in STD_LOGIC_VECTOR ( 0 to 0 );
    ap_rst_n : in STD_LOGIC;
    \could_multi_bursts.AWVALID_Dummy_reg_1\ : in STD_LOGIC;
    Q : in STD_LOGIC_VECTOR ( 6 downto 0 );
    ap_start : in STD_LOGIC;
    m_axi_gmem_WREADY : in STD_LOGIC;
    \throttl_cnt_reg[0]\ : in STD_LOGIC;
    m_axi_gmem_AWREADY : in STD_LOGIC;
    \could_multi_bursts.awaddr_buf_reg[2]_0\ : in STD_LOGIC;
    \could_multi_bursts.awaddr_buf_reg[2]_1\ : in STD_LOGIC;
    \throttl_cnt_reg[0]_0\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    ap_reg_ioackin_gmem_WREADY : in STD_LOGIC;
    m_axi_gmem_BVALID : in STD_LOGIC;
    \ap_CS_fsm_reg[9]\ : in STD_LOGIC;
    \data_p2_reg[29]\ : in STD_LOGIC_VECTOR ( 29 downto 0 );
    mem_reg : in STD_LOGIC_VECTOR ( 31 downto 0 );
    \out\ : in STD_LOGIC_VECTOR ( 31 downto 0 );
    \usedw_reg[7]\ : in STD_LOGIC_VECTOR ( 6 downto 0 )
  );
end design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_write;

architecture STRUCTURE of design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_write is
  signal \^awvalid_dummy\ : STD_LOGIC;
  signal align_len0 : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal align_len0_0 : STD_LOGIC;
  signal \align_len0_inferred__1/i__carry_n_3\ : STD_LOGIC;
  signal \align_len0_inferred__1/i__carry_n_4\ : STD_LOGIC;
  signal \align_len0_inferred__1/i__carry_n_5\ : STD_LOGIC;
  signal \align_len_reg_n_2_[2]\ : STD_LOGIC;
  signal \align_len_reg_n_2_[31]\ : STD_LOGIC;
  signal \align_len_reg_n_2_[3]\ : STD_LOGIC;
  signal awaddr_tmp : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal awlen_tmp : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal beat_len_buf : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal buff_wdata_n_14 : STD_LOGIC;
  signal buff_wdata_n_26 : STD_LOGIC;
  signal buff_wdata_n_27 : STD_LOGIC;
  signal buff_wdata_n_28 : STD_LOGIC;
  signal buff_wdata_n_29 : STD_LOGIC;
  signal buff_wdata_n_30 : STD_LOGIC;
  signal buff_wdata_n_31 : STD_LOGIC;
  signal buff_wdata_n_32 : STD_LOGIC;
  signal buff_wdata_n_33 : STD_LOGIC;
  signal buff_wdata_n_34 : STD_LOGIC;
  signal buff_wdata_n_35 : STD_LOGIC;
  signal buff_wdata_n_36 : STD_LOGIC;
  signal buff_wdata_n_37 : STD_LOGIC;
  signal buff_wdata_n_38 : STD_LOGIC;
  signal buff_wdata_n_39 : STD_LOGIC;
  signal buff_wdata_n_40 : STD_LOGIC;
  signal buff_wdata_n_41 : STD_LOGIC;
  signal buff_wdata_n_42 : STD_LOGIC;
  signal buff_wdata_n_43 : STD_LOGIC;
  signal buff_wdata_n_44 : STD_LOGIC;
  signal buff_wdata_n_45 : STD_LOGIC;
  signal buff_wdata_n_46 : STD_LOGIC;
  signal buff_wdata_n_47 : STD_LOGIC;
  signal buff_wdata_n_48 : STD_LOGIC;
  signal buff_wdata_n_49 : STD_LOGIC;
  signal buff_wdata_n_50 : STD_LOGIC;
  signal buff_wdata_n_51 : STD_LOGIC;
  signal buff_wdata_n_52 : STD_LOGIC;
  signal buff_wdata_n_53 : STD_LOGIC;
  signal buff_wdata_n_54 : STD_LOGIC;
  signal buff_wdata_n_55 : STD_LOGIC;
  signal buff_wdata_n_56 : STD_LOGIC;
  signal buff_wdata_n_57 : STD_LOGIC;
  signal burst_valid : STD_LOGIC;
  signal \^bus_equal_gen.wvalid_dummy_reg_0\ : STD_LOGIC;
  signal \bus_equal_gen.fifo_burst_n_10\ : STD_LOGIC;
  signal \bus_equal_gen.fifo_burst_n_11\ : STD_LOGIC;
  signal \bus_equal_gen.fifo_burst_n_12\ : STD_LOGIC;
  signal \bus_equal_gen.fifo_burst_n_13\ : STD_LOGIC;
  signal \bus_equal_gen.fifo_burst_n_14\ : STD_LOGIC;
  signal \bus_equal_gen.fifo_burst_n_15\ : STD_LOGIC;
  signal \bus_equal_gen.fifo_burst_n_16\ : STD_LOGIC;
  signal \bus_equal_gen.fifo_burst_n_17\ : STD_LOGIC;
  signal \bus_equal_gen.fifo_burst_n_18\ : STD_LOGIC;
  signal \bus_equal_gen.fifo_burst_n_19\ : STD_LOGIC;
  signal \bus_equal_gen.fifo_burst_n_20\ : STD_LOGIC;
  signal \bus_equal_gen.fifo_burst_n_21\ : STD_LOGIC;
  signal \bus_equal_gen.fifo_burst_n_22\ : STD_LOGIC;
  signal \bus_equal_gen.fifo_burst_n_23\ : STD_LOGIC;
  signal \bus_equal_gen.fifo_burst_n_24\ : STD_LOGIC;
  signal \bus_equal_gen.fifo_burst_n_25\ : STD_LOGIC;
  signal \bus_equal_gen.fifo_burst_n_26\ : STD_LOGIC;
  signal \bus_equal_gen.fifo_burst_n_28\ : STD_LOGIC;
  signal \bus_equal_gen.fifo_burst_n_3\ : STD_LOGIC;
  signal \bus_equal_gen.fifo_burst_n_33\ : STD_LOGIC;
  signal \bus_equal_gen.fifo_burst_n_34\ : STD_LOGIC;
  signal \bus_equal_gen.fifo_burst_n_35\ : STD_LOGIC;
  signal \bus_equal_gen.fifo_burst_n_36\ : STD_LOGIC;
  signal \bus_equal_gen.fifo_burst_n_37\ : STD_LOGIC;
  signal \bus_equal_gen.fifo_burst_n_38\ : STD_LOGIC;
  signal \bus_equal_gen.fifo_burst_n_39\ : STD_LOGIC;
  signal \bus_equal_gen.fifo_burst_n_7\ : STD_LOGIC;
  signal \bus_equal_gen.fifo_burst_n_8\ : STD_LOGIC;
  signal \bus_equal_gen.fifo_burst_n_9\ : STD_LOGIC;
  signal \bus_equal_gen.len_cnt[7]_i_3_n_2\ : STD_LOGIC;
  signal \bus_equal_gen.len_cnt_reg__0\ : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \^could_multi_bursts.awvalid_dummy_reg_0\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf[31]_i_7_n_2\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf[4]_i_3_n_2\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf[4]_i_4_n_2\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf[4]_i_5_n_2\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf[8]_i_3_n_2\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf[8]_i_4_n_2\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf_reg[12]_i_2_n_2\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf_reg[12]_i_2_n_3\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf_reg[12]_i_2_n_4\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf_reg[12]_i_2_n_5\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf_reg[16]_i_2_n_2\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf_reg[16]_i_2_n_3\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf_reg[16]_i_2_n_4\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf_reg[16]_i_2_n_5\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf_reg[20]_i_2_n_2\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf_reg[20]_i_2_n_3\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf_reg[20]_i_2_n_4\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf_reg[20]_i_2_n_5\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf_reg[24]_i_2_n_2\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf_reg[24]_i_2_n_3\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf_reg[24]_i_2_n_4\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf_reg[24]_i_2_n_5\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf_reg[28]_i_2_n_2\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf_reg[28]_i_2_n_3\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf_reg[28]_i_2_n_4\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf_reg[28]_i_2_n_5\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf_reg[31]_i_6_n_4\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf_reg[31]_i_6_n_5\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf_reg[4]_i_2_n_2\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf_reg[4]_i_2_n_3\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf_reg[4]_i_2_n_4\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf_reg[4]_i_2_n_5\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf_reg[8]_i_2_n_2\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf_reg[8]_i_2_n_3\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf_reg[8]_i_2_n_4\ : STD_LOGIC;
  signal \could_multi_bursts.awaddr_buf_reg[8]_i_2_n_5\ : STD_LOGIC;
  signal \^could_multi_bursts.awlen_buf_reg[3]_0\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \could_multi_bursts.last_sect_buf_reg_n_2\ : STD_LOGIC;
  signal \could_multi_bursts.loop_cnt_reg__0\ : STD_LOGIC_VECTOR ( 5 downto 0 );
  signal \could_multi_bursts.sect_handling_reg_n_2\ : STD_LOGIC;
  signal data1 : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal end_addr : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal \end_addr_buf_reg_n_2_[10]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[11]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[2]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[3]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[4]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[5]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[6]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[7]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[8]\ : STD_LOGIC;
  signal \end_addr_buf_reg_n_2_[9]\ : STD_LOGIC;
  signal \end_addr_carry__0_i_1_n_2\ : STD_LOGIC;
  signal \end_addr_carry__0_i_2_n_2\ : STD_LOGIC;
  signal \end_addr_carry__0_i_3_n_2\ : STD_LOGIC;
  signal \end_addr_carry__0_i_4_n_2\ : STD_LOGIC;
  signal \end_addr_carry__0_n_2\ : STD_LOGIC;
  signal \end_addr_carry__0_n_3\ : STD_LOGIC;
  signal \end_addr_carry__0_n_4\ : STD_LOGIC;
  signal \end_addr_carry__0_n_5\ : STD_LOGIC;
  signal \end_addr_carry__1_i_1_n_2\ : STD_LOGIC;
  signal \end_addr_carry__1_i_2_n_2\ : STD_LOGIC;
  signal \end_addr_carry__1_i_3_n_2\ : STD_LOGIC;
  signal \end_addr_carry__1_i_4_n_2\ : STD_LOGIC;
  signal \end_addr_carry__1_n_2\ : STD_LOGIC;
  signal \end_addr_carry__1_n_3\ : STD_LOGIC;
  signal \end_addr_carry__1_n_4\ : STD_LOGIC;
  signal \end_addr_carry__1_n_5\ : STD_LOGIC;
  signal \end_addr_carry__2_i_1_n_2\ : STD_LOGIC;
  signal \end_addr_carry__2_i_2_n_2\ : STD_LOGIC;
  signal \end_addr_carry__2_i_3_n_2\ : STD_LOGIC;
  signal \end_addr_carry__2_i_4_n_2\ : STD_LOGIC;
  signal \end_addr_carry__2_n_2\ : STD_LOGIC;
  signal \end_addr_carry__2_n_3\ : STD_LOGIC;
  signal \end_addr_carry__2_n_4\ : STD_LOGIC;
  signal \end_addr_carry__2_n_5\ : STD_LOGIC;
  signal \end_addr_carry__3_i_1_n_2\ : STD_LOGIC;
  signal \end_addr_carry__3_i_2_n_2\ : STD_LOGIC;
  signal \end_addr_carry__3_i_3_n_2\ : STD_LOGIC;
  signal \end_addr_carry__3_i_4_n_2\ : STD_LOGIC;
  signal \end_addr_carry__3_n_2\ : STD_LOGIC;
  signal \end_addr_carry__3_n_3\ : STD_LOGIC;
  signal \end_addr_carry__3_n_4\ : STD_LOGIC;
  signal \end_addr_carry__3_n_5\ : STD_LOGIC;
  signal \end_addr_carry__4_i_1_n_2\ : STD_LOGIC;
  signal \end_addr_carry__4_i_2_n_2\ : STD_LOGIC;
  signal \end_addr_carry__4_i_3_n_2\ : STD_LOGIC;
  signal \end_addr_carry__4_i_4_n_2\ : STD_LOGIC;
  signal \end_addr_carry__4_n_2\ : STD_LOGIC;
  signal \end_addr_carry__4_n_3\ : STD_LOGIC;
  signal \end_addr_carry__4_n_4\ : STD_LOGIC;
  signal \end_addr_carry__4_n_5\ : STD_LOGIC;
  signal \end_addr_carry__5_i_1_n_2\ : STD_LOGIC;
  signal \end_addr_carry__5_i_2_n_2\ : STD_LOGIC;
  signal \end_addr_carry__5_i_3_n_2\ : STD_LOGIC;
  signal \end_addr_carry__5_i_4_n_2\ : STD_LOGIC;
  signal \end_addr_carry__5_n_2\ : STD_LOGIC;
  signal \end_addr_carry__5_n_3\ : STD_LOGIC;
  signal \end_addr_carry__5_n_4\ : STD_LOGIC;
  signal \end_addr_carry__5_n_5\ : STD_LOGIC;
  signal \end_addr_carry__6_i_1_n_2\ : STD_LOGIC;
  signal \end_addr_carry__6_i_2_n_2\ : STD_LOGIC;
  signal \end_addr_carry__6_n_5\ : STD_LOGIC;
  signal end_addr_carry_i_1_n_2 : STD_LOGIC;
  signal end_addr_carry_i_2_n_2 : STD_LOGIC;
  signal end_addr_carry_i_3_n_2 : STD_LOGIC;
  signal end_addr_carry_i_4_n_2 : STD_LOGIC;
  signal end_addr_carry_n_2 : STD_LOGIC;
  signal end_addr_carry_n_3 : STD_LOGIC;
  signal end_addr_carry_n_4 : STD_LOGIC;
  signal end_addr_carry_n_5 : STD_LOGIC;
  signal fifo_resp_ready : STD_LOGIC;
  signal fifo_wreq_data : STD_LOGIC_VECTOR ( 33 to 33 );
  signal fifo_wreq_n_10 : STD_LOGIC;
  signal fifo_wreq_n_11 : STD_LOGIC;
  signal fifo_wreq_n_12 : STD_LOGIC;
  signal fifo_wreq_n_13 : STD_LOGIC;
  signal fifo_wreq_n_14 : STD_LOGIC;
  signal fifo_wreq_n_15 : STD_LOGIC;
  signal fifo_wreq_n_16 : STD_LOGIC;
  signal fifo_wreq_n_17 : STD_LOGIC;
  signal fifo_wreq_n_18 : STD_LOGIC;
  signal fifo_wreq_n_19 : STD_LOGIC;
  signal fifo_wreq_n_20 : STD_LOGIC;
  signal fifo_wreq_n_21 : STD_LOGIC;
  signal fifo_wreq_n_22 : STD_LOGIC;
  signal fifo_wreq_n_23 : STD_LOGIC;
  signal fifo_wreq_n_24 : STD_LOGIC;
  signal fifo_wreq_n_25 : STD_LOGIC;
  signal fifo_wreq_n_26 : STD_LOGIC;
  signal fifo_wreq_n_27 : STD_LOGIC;
  signal fifo_wreq_n_28 : STD_LOGIC;
  signal fifo_wreq_n_29 : STD_LOGIC;
  signal fifo_wreq_n_30 : STD_LOGIC;
  signal fifo_wreq_n_31 : STD_LOGIC;
  signal fifo_wreq_n_32 : STD_LOGIC;
  signal fifo_wreq_n_33 : STD_LOGIC;
  signal fifo_wreq_n_34 : STD_LOGIC;
  signal fifo_wreq_n_35 : STD_LOGIC;
  signal fifo_wreq_n_36 : STD_LOGIC;
  signal fifo_wreq_n_37 : STD_LOGIC;
  signal fifo_wreq_n_38 : STD_LOGIC;
  signal fifo_wreq_n_39 : STD_LOGIC;
  signal fifo_wreq_n_40 : STD_LOGIC;
  signal fifo_wreq_n_41 : STD_LOGIC;
  signal fifo_wreq_n_42 : STD_LOGIC;
  signal fifo_wreq_n_43 : STD_LOGIC;
  signal fifo_wreq_n_44 : STD_LOGIC;
  signal fifo_wreq_n_46 : STD_LOGIC;
  signal fifo_wreq_n_47 : STD_LOGIC;
  signal fifo_wreq_n_5 : STD_LOGIC;
  signal fifo_wreq_n_6 : STD_LOGIC;
  signal fifo_wreq_n_8 : STD_LOGIC;
  signal fifo_wreq_n_9 : STD_LOGIC;
  signal fifo_wreq_valid : STD_LOGIC;
  signal fifo_wreq_valid_buf_reg_n_2 : STD_LOGIC;
  signal first_sect : STD_LOGIC;
  signal \first_sect_carry__0_i_1_n_2\ : STD_LOGIC;
  signal \first_sect_carry__0_i_2_n_2\ : STD_LOGIC;
  signal \first_sect_carry__0_i_3_n_2\ : STD_LOGIC;
  signal \first_sect_carry__0_n_4\ : STD_LOGIC;
  signal \first_sect_carry__0_n_5\ : STD_LOGIC;
  signal first_sect_carry_i_1_n_2 : STD_LOGIC;
  signal first_sect_carry_i_2_n_2 : STD_LOGIC;
  signal first_sect_carry_i_3_n_2 : STD_LOGIC;
  signal first_sect_carry_i_4_n_2 : STD_LOGIC;
  signal first_sect_carry_n_2 : STD_LOGIC;
  signal first_sect_carry_n_3 : STD_LOGIC;
  signal first_sect_carry_n_4 : STD_LOGIC;
  signal first_sect_carry_n_5 : STD_LOGIC;
  signal \^full_n_reg\ : STD_LOGIC;
  signal gmem_WREADY : STD_LOGIC;
  signal invalid_len_event : STD_LOGIC;
  signal invalid_len_event_reg1 : STD_LOGIC;
  signal invalid_len_event_reg2 : STD_LOGIC;
  signal last_sect : STD_LOGIC;
  signal \last_sect_carry__0_n_4\ : STD_LOGIC;
  signal \last_sect_carry__0_n_5\ : STD_LOGIC;
  signal last_sect_carry_n_2 : STD_LOGIC;
  signal last_sect_carry_n_3 : STD_LOGIC;
  signal last_sect_carry_n_4 : STD_LOGIC;
  signal last_sect_carry_n_5 : STD_LOGIC;
  signal \^m_axi_gmem_awaddr\ : STD_LOGIC_VECTOR ( 29 downto 0 );
  signal \^m_axi_gmem_wlast\ : STD_LOGIC;
  signal next_resp : STD_LOGIC;
  signal next_resp0 : STD_LOGIC;
  signal next_wreq : STD_LOGIC;
  signal p_0_in0_in : STD_LOGIC_VECTOR ( 19 downto 0 );
  signal \p_0_in__0\ : STD_LOGIC_VECTOR ( 5 downto 0 );
  signal \p_0_in__1\ : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal p_26_in : STD_LOGIC;
  signal p_30_in : STD_LOGIC;
  signal pop0 : STD_LOGIC;
  signal push : STD_LOGIC;
  signal push_0 : STD_LOGIC;
  signal push_1 : STD_LOGIC;
  signal rs2f_wreq_ack : STD_LOGIC;
  signal rs2f_wreq_data : STD_LOGIC_VECTOR ( 29 downto 0 );
  signal rs2f_wreq_valid : STD_LOGIC;
  signal sect_addr : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal \sect_addr_buf_reg_n_2_[10]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[11]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[12]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[13]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[14]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[15]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[16]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[17]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[18]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[19]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[20]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[21]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[22]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[23]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[24]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[25]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[26]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[27]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[28]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[29]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[2]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[30]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[31]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[3]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[4]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[5]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[6]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[7]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[8]\ : STD_LOGIC;
  signal \sect_addr_buf_reg_n_2_[9]\ : STD_LOGIC;
  signal sect_cnt : STD_LOGIC_VECTOR ( 19 downto 0 );
  signal sect_cnt0 : STD_LOGIC_VECTOR ( 19 downto 1 );
  signal \sect_cnt0_carry__0_n_2\ : STD_LOGIC;
  signal \sect_cnt0_carry__0_n_3\ : STD_LOGIC;
  signal \sect_cnt0_carry__0_n_4\ : STD_LOGIC;
  signal \sect_cnt0_carry__0_n_5\ : STD_LOGIC;
  signal \sect_cnt0_carry__1_n_2\ : STD_LOGIC;
  signal \sect_cnt0_carry__1_n_3\ : STD_LOGIC;
  signal \sect_cnt0_carry__1_n_4\ : STD_LOGIC;
  signal \sect_cnt0_carry__1_n_5\ : STD_LOGIC;
  signal \sect_cnt0_carry__2_n_2\ : STD_LOGIC;
  signal \sect_cnt0_carry__2_n_3\ : STD_LOGIC;
  signal \sect_cnt0_carry__2_n_4\ : STD_LOGIC;
  signal \sect_cnt0_carry__2_n_5\ : STD_LOGIC;
  signal \sect_cnt0_carry__3_n_4\ : STD_LOGIC;
  signal \sect_cnt0_carry__3_n_5\ : STD_LOGIC;
  signal sect_cnt0_carry_n_2 : STD_LOGIC;
  signal sect_cnt0_carry_n_3 : STD_LOGIC;
  signal sect_cnt0_carry_n_4 : STD_LOGIC;
  signal sect_cnt0_carry_n_5 : STD_LOGIC;
  signal sect_len_buf : STD_LOGIC_VECTOR ( 9 downto 4 );
  signal \sect_len_buf[0]_i_1_n_2\ : STD_LOGIC;
  signal \sect_len_buf[1]_i_1_n_2\ : STD_LOGIC;
  signal \sect_len_buf[2]_i_1_n_2\ : STD_LOGIC;
  signal \sect_len_buf[3]_i_1_n_2\ : STD_LOGIC;
  signal \sect_len_buf[4]_i_1_n_2\ : STD_LOGIC;
  signal \sect_len_buf[5]_i_1_n_2\ : STD_LOGIC;
  signal \sect_len_buf[6]_i_1_n_2\ : STD_LOGIC;
  signal \sect_len_buf[7]_i_1_n_2\ : STD_LOGIC;
  signal \sect_len_buf[8]_i_1_n_2\ : STD_LOGIC;
  signal \sect_len_buf[9]_i_2_n_2\ : STD_LOGIC;
  signal \sect_len_buf_reg_n_2_[0]\ : STD_LOGIC;
  signal \sect_len_buf_reg_n_2_[1]\ : STD_LOGIC;
  signal \sect_len_buf_reg_n_2_[2]\ : STD_LOGIC;
  signal \sect_len_buf_reg_n_2_[3]\ : STD_LOGIC;
  signal start_addr_buf : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal \start_addr_reg_n_2_[10]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[11]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[12]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[13]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[14]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[15]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[16]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[17]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[18]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[19]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[20]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[21]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[22]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[23]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[24]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[25]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[26]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[27]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[28]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[29]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[2]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[30]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[31]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[3]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[4]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[5]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[6]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[7]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[8]\ : STD_LOGIC;
  signal \start_addr_reg_n_2_[9]\ : STD_LOGIC;
  signal tmp_strb : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal wreq_handling_reg_n_2 : STD_LOGIC;
  signal zero_len_event0 : STD_LOGIC;
  signal \NLW_align_len0_inferred__1/i__carry_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_align_len0_inferred__1/i__carry_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \NLW_could_multi_bursts.awaddr_buf_reg[31]_i_6_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal \NLW_could_multi_bursts.awaddr_buf_reg[31]_i_6_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_could_multi_bursts.awaddr_buf_reg[4]_i_2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_end_addr_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \NLW_end_addr_carry__6_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal \NLW_end_addr_carry__6_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal NLW_first_sect_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_first_sect_carry__0_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_first_sect_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_last_sect_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_last_sect_carry__0_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_last_sect_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_sect_cnt0_carry__3_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal \NLW_sect_cnt0_carry__3_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  attribute METHODOLOGY_DRC_VIOS : string;
  attribute METHODOLOGY_DRC_VIOS of \align_len0_inferred__1/i__carry\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \bus_equal_gen.len_cnt[1]_i_1\ : label is "soft_lutpair201";
  attribute SOFT_HLUTNM of \bus_equal_gen.len_cnt[2]_i_1\ : label is "soft_lutpair201";
  attribute SOFT_HLUTNM of \bus_equal_gen.len_cnt[3]_i_1\ : label is "soft_lutpair174";
  attribute SOFT_HLUTNM of \bus_equal_gen.len_cnt[4]_i_1\ : label is "soft_lutpair174";
  attribute SOFT_HLUTNM of \bus_equal_gen.len_cnt[6]_i_1\ : label is "soft_lutpair202";
  attribute SOFT_HLUTNM of \bus_equal_gen.len_cnt[7]_i_2\ : label is "soft_lutpair202";
  attribute SOFT_HLUTNM of \could_multi_bursts.awaddr_buf[10]_i_1\ : label is "soft_lutpair179";
  attribute SOFT_HLUTNM of \could_multi_bursts.awaddr_buf[11]_i_1\ : label is "soft_lutpair180";
  attribute SOFT_HLUTNM of \could_multi_bursts.awaddr_buf[12]_i_1\ : label is "soft_lutpair178";
  attribute SOFT_HLUTNM of \could_multi_bursts.awaddr_buf[13]_i_1\ : label is "soft_lutpair177";
  attribute SOFT_HLUTNM of \could_multi_bursts.awaddr_buf[14]_i_1\ : label is "soft_lutpair184";
  attribute SOFT_HLUTNM of \could_multi_bursts.awaddr_buf[15]_i_1\ : label is "soft_lutpair176";
  attribute SOFT_HLUTNM of \could_multi_bursts.awaddr_buf[16]_i_1\ : label is "soft_lutpair175";
  attribute SOFT_HLUTNM of \could_multi_bursts.awaddr_buf[17]_i_1\ : label is "soft_lutpair187";
  attribute SOFT_HLUTNM of \could_multi_bursts.awaddr_buf[18]_i_1\ : label is "soft_lutpair187";
  attribute SOFT_HLUTNM of \could_multi_bursts.awaddr_buf[19]_i_1\ : label is "soft_lutpair197";
  attribute SOFT_HLUTNM of \could_multi_bursts.awaddr_buf[20]_i_1\ : label is "soft_lutpair197";
  attribute SOFT_HLUTNM of \could_multi_bursts.awaddr_buf[21]_i_1\ : label is "soft_lutpair185";
  attribute SOFT_HLUTNM of \could_multi_bursts.awaddr_buf[22]_i_1\ : label is "soft_lutpair182";
  attribute SOFT_HLUTNM of \could_multi_bursts.awaddr_buf[23]_i_1\ : label is "soft_lutpair184";
  attribute SOFT_HLUTNM of \could_multi_bursts.awaddr_buf[24]_i_1\ : label is "soft_lutpair183";
  attribute SOFT_HLUTNM of \could_multi_bursts.awaddr_buf[25]_i_1\ : label is "soft_lutpair181";
  attribute SOFT_HLUTNM of \could_multi_bursts.awaddr_buf[26]_i_1\ : label is "soft_lutpair178";
  attribute SOFT_HLUTNM of \could_multi_bursts.awaddr_buf[27]_i_1\ : label is "soft_lutpair180";
  attribute SOFT_HLUTNM of \could_multi_bursts.awaddr_buf[28]_i_1\ : label is "soft_lutpair179";
  attribute SOFT_HLUTNM of \could_multi_bursts.awaddr_buf[29]_i_1\ : label is "soft_lutpair177";
  attribute SOFT_HLUTNM of \could_multi_bursts.awaddr_buf[2]_i_1\ : label is "soft_lutpair199";
  attribute SOFT_HLUTNM of \could_multi_bursts.awaddr_buf[30]_i_1\ : label is "soft_lutpair175";
  attribute SOFT_HLUTNM of \could_multi_bursts.awaddr_buf[31]_i_3\ : label is "soft_lutpair176";
  attribute SOFT_HLUTNM of \could_multi_bursts.awaddr_buf[3]_i_1\ : label is "soft_lutpair198";
  attribute SOFT_HLUTNM of \could_multi_bursts.awaddr_buf[4]_i_1\ : label is "soft_lutpair199";
  attribute SOFT_HLUTNM of \could_multi_bursts.awaddr_buf[5]_i_1\ : label is "soft_lutpair198";
  attribute SOFT_HLUTNM of \could_multi_bursts.awaddr_buf[6]_i_1\ : label is "soft_lutpair185";
  attribute SOFT_HLUTNM of \could_multi_bursts.awaddr_buf[7]_i_1\ : label is "soft_lutpair183";
  attribute SOFT_HLUTNM of \could_multi_bursts.awaddr_buf[8]_i_1\ : label is "soft_lutpair182";
  attribute SOFT_HLUTNM of \could_multi_bursts.awaddr_buf[9]_i_1\ : label is "soft_lutpair181";
  attribute METHODOLOGY_DRC_VIOS of \could_multi_bursts.awaddr_buf_reg[12]_i_2\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \could_multi_bursts.awaddr_buf_reg[16]_i_2\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \could_multi_bursts.awaddr_buf_reg[20]_i_2\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \could_multi_bursts.awaddr_buf_reg[24]_i_2\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \could_multi_bursts.awaddr_buf_reg[28]_i_2\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \could_multi_bursts.awaddr_buf_reg[31]_i_6\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \could_multi_bursts.awaddr_buf_reg[4]_i_2\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \could_multi_bursts.awaddr_buf_reg[8]_i_2\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute SOFT_HLUTNM of \could_multi_bursts.loop_cnt[1]_i_1\ : label is "soft_lutpair200";
  attribute SOFT_HLUTNM of \could_multi_bursts.loop_cnt[2]_i_1\ : label is "soft_lutpair200";
  attribute SOFT_HLUTNM of \could_multi_bursts.loop_cnt[3]_i_1\ : label is "soft_lutpair173";
  attribute SOFT_HLUTNM of \could_multi_bursts.loop_cnt[4]_i_1\ : label is "soft_lutpair173";
  attribute METHODOLOGY_DRC_VIOS of end_addr_carry : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \end_addr_carry__0\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \end_addr_carry__1\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \end_addr_carry__2\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \end_addr_carry__3\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \end_addr_carry__4\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \end_addr_carry__5\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \end_addr_carry__6\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of first_sect_carry : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \first_sect_carry__0\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of last_sect_carry : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \last_sect_carry__0\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute SOFT_HLUTNM of \sect_addr_buf[10]_i_1\ : label is "soft_lutpair204";
  attribute SOFT_HLUTNM of \sect_addr_buf[11]_i_2\ : label is "soft_lutpair203";
  attribute SOFT_HLUTNM of \sect_addr_buf[12]_i_1\ : label is "soft_lutpair196";
  attribute SOFT_HLUTNM of \sect_addr_buf[13]_i_1\ : label is "soft_lutpair196";
  attribute SOFT_HLUTNM of \sect_addr_buf[14]_i_1\ : label is "soft_lutpair195";
  attribute SOFT_HLUTNM of \sect_addr_buf[15]_i_1\ : label is "soft_lutpair195";
  attribute SOFT_HLUTNM of \sect_addr_buf[16]_i_1\ : label is "soft_lutpair194";
  attribute SOFT_HLUTNM of \sect_addr_buf[17]_i_1\ : label is "soft_lutpair194";
  attribute SOFT_HLUTNM of \sect_addr_buf[18]_i_1\ : label is "soft_lutpair193";
  attribute SOFT_HLUTNM of \sect_addr_buf[19]_i_1\ : label is "soft_lutpair193";
  attribute SOFT_HLUTNM of \sect_addr_buf[20]_i_1\ : label is "soft_lutpair192";
  attribute SOFT_HLUTNM of \sect_addr_buf[21]_i_1\ : label is "soft_lutpair192";
  attribute SOFT_HLUTNM of \sect_addr_buf[22]_i_1\ : label is "soft_lutpair191";
  attribute SOFT_HLUTNM of \sect_addr_buf[23]_i_1\ : label is "soft_lutpair191";
  attribute SOFT_HLUTNM of \sect_addr_buf[24]_i_1\ : label is "soft_lutpair190";
  attribute SOFT_HLUTNM of \sect_addr_buf[25]_i_1\ : label is "soft_lutpair190";
  attribute SOFT_HLUTNM of \sect_addr_buf[26]_i_1\ : label is "soft_lutpair189";
  attribute SOFT_HLUTNM of \sect_addr_buf[27]_i_1\ : label is "soft_lutpair188";
  attribute SOFT_HLUTNM of \sect_addr_buf[28]_i_1\ : label is "soft_lutpair189";
  attribute SOFT_HLUTNM of \sect_addr_buf[29]_i_1\ : label is "soft_lutpair186";
  attribute SOFT_HLUTNM of \sect_addr_buf[2]_i_1\ : label is "soft_lutpair203";
  attribute SOFT_HLUTNM of \sect_addr_buf[30]_i_1\ : label is "soft_lutpair188";
  attribute SOFT_HLUTNM of \sect_addr_buf[31]_i_1\ : label is "soft_lutpair186";
  attribute SOFT_HLUTNM of \sect_addr_buf[3]_i_1\ : label is "soft_lutpair204";
  attribute SOFT_HLUTNM of \sect_addr_buf[4]_i_1\ : label is "soft_lutpair206";
  attribute SOFT_HLUTNM of \sect_addr_buf[5]_i_1\ : label is "soft_lutpair205";
  attribute SOFT_HLUTNM of \sect_addr_buf[6]_i_1\ : label is "soft_lutpair207";
  attribute SOFT_HLUTNM of \sect_addr_buf[7]_i_1\ : label is "soft_lutpair207";
  attribute SOFT_HLUTNM of \sect_addr_buf[8]_i_1\ : label is "soft_lutpair206";
  attribute SOFT_HLUTNM of \sect_addr_buf[9]_i_1\ : label is "soft_lutpair205";
  attribute METHODOLOGY_DRC_VIOS of sect_cnt0_carry : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \sect_cnt0_carry__0\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \sect_cnt0_carry__1\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \sect_cnt0_carry__2\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \sect_cnt0_carry__3\ : label is "{SYNTH-8 {cell *THIS*}}";
begin
  AWVALID_Dummy <= \^awvalid_dummy\;
  \bus_equal_gen.WVALID_Dummy_reg_0\ <= \^bus_equal_gen.wvalid_dummy_reg_0\;
  \could_multi_bursts.AWVALID_Dummy_reg_0\ <= \^could_multi_bursts.awvalid_dummy_reg_0\;
  \could_multi_bursts.awlen_buf_reg[3]_0\(3 downto 0) <= \^could_multi_bursts.awlen_buf_reg[3]_0\(3 downto 0);
  full_n_reg <= \^full_n_reg\;
  m_axi_gmem_AWADDR(29 downto 0) <= \^m_axi_gmem_awaddr\(29 downto 0);
  m_axi_gmem_WLAST <= \^m_axi_gmem_wlast\;
\align_len0_inferred__1/i__carry\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \NLW_align_len0_inferred__1/i__carry_CO_UNCONNECTED\(3),
      CO(2) => \align_len0_inferred__1/i__carry_n_3\,
      CO(1) => \align_len0_inferred__1/i__carry_n_4\,
      CO(0) => \align_len0_inferred__1/i__carry_n_5\,
      CYINIT => '0',
      DI(3) => '0',
      DI(2) => fifo_wreq_data(33),
      DI(1 downto 0) => B"00",
      O(3) => align_len0(31),
      O(2 downto 1) => align_len0(3 downto 2),
      O(0) => \NLW_align_len0_inferred__1/i__carry_O_UNCONNECTED\(0),
      S(3) => '1',
      S(2) => zero_len_event0,
      S(1 downto 0) => B"11"
    );
\align_len_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len0_0,
      D => align_len0(2),
      Q => \align_len_reg_n_2_[2]\,
      R => fifo_wreq_n_47
    );
\align_len_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len0_0,
      D => align_len0(31),
      Q => \align_len_reg_n_2_[31]\,
      R => fifo_wreq_n_47
    );
\align_len_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len0_0,
      D => align_len0(3),
      Q => \align_len_reg_n_2_[3]\,
      R => fifo_wreq_n_47
    );
\beat_len_buf_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => \align_len_reg_n_2_[2]\,
      Q => beat_len_buf(0),
      R => SR(0)
    );
\beat_len_buf_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => \align_len_reg_n_2_[3]\,
      Q => beat_len_buf(1),
      R => SR(0)
    );
\beat_len_buf_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => \align_len_reg_n_2_[31]\,
      Q => beat_len_buf(3),
      R => SR(0)
    );
buff_wdata: entity work.design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_buffer
     port map (
      DI(0) => DI(0),
      E(0) => p_30_in,
      Q(5 downto 0) => \usedw_reg[5]\(5 downto 0),
      S(3 downto 0) => S(3 downto 0),
      SR(0) => SR(0),
      \ap_CS_fsm_reg[10]\(0) => \ap_CS_fsm_reg[10]\(0),
      \ap_CS_fsm_reg[11]\(1 downto 0) => \ap_CS_fsm_reg[15]\(4 downto 3),
      ap_clk => ap_clk,
      ap_reg_ioackin_gmem_WREADY => ap_reg_ioackin_gmem_WREADY,
      ap_rst_n => ap_rst_n,
      burst_valid => burst_valid,
      \bus_equal_gen.WVALID_Dummy_reg\ => buff_wdata_n_14,
      \dout_buf_reg[35]_0\(35 downto 32) => tmp_strb(3 downto 0),
      \dout_buf_reg[35]_0\(31) => buff_wdata_n_26,
      \dout_buf_reg[35]_0\(30) => buff_wdata_n_27,
      \dout_buf_reg[35]_0\(29) => buff_wdata_n_28,
      \dout_buf_reg[35]_0\(28) => buff_wdata_n_29,
      \dout_buf_reg[35]_0\(27) => buff_wdata_n_30,
      \dout_buf_reg[35]_0\(26) => buff_wdata_n_31,
      \dout_buf_reg[35]_0\(25) => buff_wdata_n_32,
      \dout_buf_reg[35]_0\(24) => buff_wdata_n_33,
      \dout_buf_reg[35]_0\(23) => buff_wdata_n_34,
      \dout_buf_reg[35]_0\(22) => buff_wdata_n_35,
      \dout_buf_reg[35]_0\(21) => buff_wdata_n_36,
      \dout_buf_reg[35]_0\(20) => buff_wdata_n_37,
      \dout_buf_reg[35]_0\(19) => buff_wdata_n_38,
      \dout_buf_reg[35]_0\(18) => buff_wdata_n_39,
      \dout_buf_reg[35]_0\(17) => buff_wdata_n_40,
      \dout_buf_reg[35]_0\(16) => buff_wdata_n_41,
      \dout_buf_reg[35]_0\(15) => buff_wdata_n_42,
      \dout_buf_reg[35]_0\(14) => buff_wdata_n_43,
      \dout_buf_reg[35]_0\(13) => buff_wdata_n_44,
      \dout_buf_reg[35]_0\(12) => buff_wdata_n_45,
      \dout_buf_reg[35]_0\(11) => buff_wdata_n_46,
      \dout_buf_reg[35]_0\(10) => buff_wdata_n_47,
      \dout_buf_reg[35]_0\(9) => buff_wdata_n_48,
      \dout_buf_reg[35]_0\(8) => buff_wdata_n_49,
      \dout_buf_reg[35]_0\(7) => buff_wdata_n_50,
      \dout_buf_reg[35]_0\(6) => buff_wdata_n_51,
      \dout_buf_reg[35]_0\(5) => buff_wdata_n_52,
      \dout_buf_reg[35]_0\(4) => buff_wdata_n_53,
      \dout_buf_reg[35]_0\(3) => buff_wdata_n_54,
      \dout_buf_reg[35]_0\(2) => buff_wdata_n_55,
      \dout_buf_reg[35]_0\(1) => buff_wdata_n_56,
      \dout_buf_reg[35]_0\(0) => buff_wdata_n_57,
      dout_valid_reg_0 => \^bus_equal_gen.wvalid_dummy_reg_0\,
      gmem_WREADY => gmem_WREADY,
      m_axi_gmem_WREADY => m_axi_gmem_WREADY,
      mem_reg_0(31 downto 0) => mem_reg(31 downto 0),
      \out\(31 downto 0) => \out\(31 downto 0),
      \q_tmp_reg[0]_0\(1 downto 0) => Q(4 downto 3),
      \usedw_reg[6]_0\(2 downto 0) => \usedw_reg[6]\(2 downto 0),
      \usedw_reg[7]_0\(6 downto 0) => \usedw_reg[7]\(6 downto 0)
    );
\bus_equal_gen.WLAST_Dummy_reg\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \bus_equal_gen.fifo_burst_n_35\,
      Q => \^m_axi_gmem_wlast\,
      R => SR(0)
    );
\bus_equal_gen.WVALID_Dummy_reg\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => buff_wdata_n_14,
      Q => \^bus_equal_gen.wvalid_dummy_reg_0\,
      R => SR(0)
    );
\bus_equal_gen.data_buf_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => buff_wdata_n_57,
      Q => m_axi_gmem_WDATA(0),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => buff_wdata_n_47,
      Q => m_axi_gmem_WDATA(10),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => buff_wdata_n_46,
      Q => m_axi_gmem_WDATA(11),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => buff_wdata_n_45,
      Q => m_axi_gmem_WDATA(12),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => buff_wdata_n_44,
      Q => m_axi_gmem_WDATA(13),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => buff_wdata_n_43,
      Q => m_axi_gmem_WDATA(14),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => buff_wdata_n_42,
      Q => m_axi_gmem_WDATA(15),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => buff_wdata_n_41,
      Q => m_axi_gmem_WDATA(16),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => buff_wdata_n_40,
      Q => m_axi_gmem_WDATA(17),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => buff_wdata_n_39,
      Q => m_axi_gmem_WDATA(18),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => buff_wdata_n_38,
      Q => m_axi_gmem_WDATA(19),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => buff_wdata_n_56,
      Q => m_axi_gmem_WDATA(1),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => buff_wdata_n_37,
      Q => m_axi_gmem_WDATA(20),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => buff_wdata_n_36,
      Q => m_axi_gmem_WDATA(21),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => buff_wdata_n_35,
      Q => m_axi_gmem_WDATA(22),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => buff_wdata_n_34,
      Q => m_axi_gmem_WDATA(23),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => buff_wdata_n_33,
      Q => m_axi_gmem_WDATA(24),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => buff_wdata_n_32,
      Q => m_axi_gmem_WDATA(25),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => buff_wdata_n_31,
      Q => m_axi_gmem_WDATA(26),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => buff_wdata_n_30,
      Q => m_axi_gmem_WDATA(27),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => buff_wdata_n_29,
      Q => m_axi_gmem_WDATA(28),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => buff_wdata_n_28,
      Q => m_axi_gmem_WDATA(29),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => buff_wdata_n_55,
      Q => m_axi_gmem_WDATA(2),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => buff_wdata_n_27,
      Q => m_axi_gmem_WDATA(30),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => buff_wdata_n_26,
      Q => m_axi_gmem_WDATA(31),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => buff_wdata_n_54,
      Q => m_axi_gmem_WDATA(3),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => buff_wdata_n_53,
      Q => m_axi_gmem_WDATA(4),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => buff_wdata_n_52,
      Q => m_axi_gmem_WDATA(5),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => buff_wdata_n_51,
      Q => m_axi_gmem_WDATA(6),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => buff_wdata_n_50,
      Q => m_axi_gmem_WDATA(7),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => buff_wdata_n_49,
      Q => m_axi_gmem_WDATA(8),
      R => '0'
    );
\bus_equal_gen.data_buf_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => buff_wdata_n_48,
      Q => m_axi_gmem_WDATA(9),
      R => '0'
    );
\bus_equal_gen.fifo_burst\: entity work.design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo
     port map (
      CO(0) => last_sect,
      D(19) => \bus_equal_gen.fifo_burst_n_7\,
      D(18) => \bus_equal_gen.fifo_burst_n_8\,
      D(17) => \bus_equal_gen.fifo_burst_n_9\,
      D(16) => \bus_equal_gen.fifo_burst_n_10\,
      D(15) => \bus_equal_gen.fifo_burst_n_11\,
      D(14) => \bus_equal_gen.fifo_burst_n_12\,
      D(13) => \bus_equal_gen.fifo_burst_n_13\,
      D(12) => \bus_equal_gen.fifo_burst_n_14\,
      D(11) => \bus_equal_gen.fifo_burst_n_15\,
      D(10) => \bus_equal_gen.fifo_burst_n_16\,
      D(9) => \bus_equal_gen.fifo_burst_n_17\,
      D(8) => \bus_equal_gen.fifo_burst_n_18\,
      D(7) => \bus_equal_gen.fifo_burst_n_19\,
      D(6) => \bus_equal_gen.fifo_burst_n_20\,
      D(5) => \bus_equal_gen.fifo_burst_n_21\,
      D(4) => \bus_equal_gen.fifo_burst_n_22\,
      D(3) => \bus_equal_gen.fifo_burst_n_23\,
      D(2) => \bus_equal_gen.fifo_burst_n_24\,
      D(1) => \bus_equal_gen.fifo_burst_n_25\,
      D(0) => \bus_equal_gen.fifo_burst_n_26\,
      E(0) => pop0,
      Q(19) => \start_addr_reg_n_2_[31]\,
      Q(18) => \start_addr_reg_n_2_[30]\,
      Q(17) => \start_addr_reg_n_2_[29]\,
      Q(16) => \start_addr_reg_n_2_[28]\,
      Q(15) => \start_addr_reg_n_2_[27]\,
      Q(14) => \start_addr_reg_n_2_[26]\,
      Q(13) => \start_addr_reg_n_2_[25]\,
      Q(12) => \start_addr_reg_n_2_[24]\,
      Q(11) => \start_addr_reg_n_2_[23]\,
      Q(10) => \start_addr_reg_n_2_[22]\,
      Q(9) => \start_addr_reg_n_2_[21]\,
      Q(8) => \start_addr_reg_n_2_[20]\,
      Q(7) => \start_addr_reg_n_2_[19]\,
      Q(6) => \start_addr_reg_n_2_[18]\,
      Q(5) => \start_addr_reg_n_2_[17]\,
      Q(4) => \start_addr_reg_n_2_[16]\,
      Q(3) => \start_addr_reg_n_2_[15]\,
      Q(2) => \start_addr_reg_n_2_[14]\,
      Q(1) => \start_addr_reg_n_2_[13]\,
      Q(0) => \start_addr_reg_n_2_[12]\,
      SR(0) => SR(0),
      ap_clk => ap_clk,
      ap_rst_n => ap_rst_n,
      ap_rst_n_0(0) => \bus_equal_gen.fifo_burst_n_37\,
      ap_rst_n_1(0) => \bus_equal_gen.fifo_burst_n_38\,
      ap_rst_n_2(0) => \bus_equal_gen.fifo_burst_n_39\,
      burst_valid => burst_valid,
      \bus_equal_gen.WLAST_Dummy_i_2_0\(7 downto 0) => \bus_equal_gen.len_cnt_reg__0\(7 downto 0),
      \bus_equal_gen.WLAST_Dummy_reg\ => \bus_equal_gen.fifo_burst_n_35\,
      \bus_equal_gen.WLAST_Dummy_reg_0\ => \^bus_equal_gen.wvalid_dummy_reg_0\,
      \could_multi_bursts.AWVALID_Dummy_reg\ => \could_multi_bursts.AWVALID_Dummy_reg_1\,
      \could_multi_bursts.awaddr_buf_reg[2]\ => \^awvalid_dummy\,
      \could_multi_bursts.awaddr_buf_reg[2]_0\ => \could_multi_bursts.awaddr_buf_reg[2]_0\,
      \could_multi_bursts.awaddr_buf_reg[2]_1\ => \could_multi_bursts.awaddr_buf_reg[2]_1\,
      \could_multi_bursts.awlen_buf[3]_i_2_0\(9 downto 4) => sect_len_buf(9 downto 4),
      \could_multi_bursts.awlen_buf[3]_i_2_0\(3) => \sect_len_buf_reg_n_2_[3]\,
      \could_multi_bursts.awlen_buf[3]_i_2_0\(2) => \sect_len_buf_reg_n_2_[2]\,
      \could_multi_bursts.awlen_buf[3]_i_2_0\(1) => \sect_len_buf_reg_n_2_[1]\,
      \could_multi_bursts.awlen_buf[3]_i_2_0\(0) => \sect_len_buf_reg_n_2_[0]\,
      \could_multi_bursts.awlen_buf[3]_i_2_1\(5 downto 0) => \could_multi_bursts.loop_cnt_reg__0\(5 downto 0),
      \could_multi_bursts.last_sect_buf_reg\ => \bus_equal_gen.fifo_burst_n_36\,
      \could_multi_bursts.last_sect_buf_reg_0\ => \could_multi_bursts.last_sect_buf_reg_n_2\,
      \could_multi_bursts.loop_cnt_reg[0]\ => \bus_equal_gen.fifo_burst_n_28\,
      \could_multi_bursts.sect_handling_reg\ => \bus_equal_gen.fifo_burst_n_34\,
      \could_multi_bursts.sect_handling_reg_0\ => \could_multi_bursts.sect_handling_reg_n_2\,
      \end_addr_buf_reg[31]\ => fifo_wreq_n_5,
      fifo_resp_ready => fifo_resp_ready,
      fifo_wreq_valid => fifo_wreq_valid,
      \in\(0) => invalid_len_event_reg2,
      invalid_len_event_reg2_reg => \bus_equal_gen.fifo_burst_n_3\,
      m_axi_gmem_AWREADY => m_axi_gmem_AWREADY,
      m_axi_gmem_WLAST => \^m_axi_gmem_wlast\,
      m_axi_gmem_WREADY => m_axi_gmem_WREADY,
      next_wreq => next_wreq,
      p_26_in => p_26_in,
      push => push,
      \q_reg[0]_0\(0) => p_30_in,
      \sect_addr_buf_reg[2]\(0) => first_sect,
      sect_cnt0(18 downto 0) => sect_cnt0(19 downto 1),
      \sect_cnt_reg[0]\(0) => sect_cnt(0),
      \sect_len_buf_reg[3]\(3 downto 0) => awlen_tmp(3 downto 0),
      wreq_handling_reg => \bus_equal_gen.fifo_burst_n_33\,
      wreq_handling_reg_0 => wreq_handling_reg_n_2,
      wreq_handling_reg_1 => fifo_wreq_valid_buf_reg_n_2
    );
\bus_equal_gen.len_cnt[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \bus_equal_gen.len_cnt_reg__0\(0),
      O => \p_0_in__1\(0)
    );
\bus_equal_gen.len_cnt[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \bus_equal_gen.len_cnt_reg__0\(1),
      I1 => \bus_equal_gen.len_cnt_reg__0\(0),
      O => \p_0_in__1\(1)
    );
\bus_equal_gen.len_cnt[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"6A"
    )
        port map (
      I0 => \bus_equal_gen.len_cnt_reg__0\(2),
      I1 => \bus_equal_gen.len_cnt_reg__0\(0),
      I2 => \bus_equal_gen.len_cnt_reg__0\(1),
      O => \p_0_in__1\(2)
    );
\bus_equal_gen.len_cnt[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6AAA"
    )
        port map (
      I0 => \bus_equal_gen.len_cnt_reg__0\(3),
      I1 => \bus_equal_gen.len_cnt_reg__0\(1),
      I2 => \bus_equal_gen.len_cnt_reg__0\(0),
      I3 => \bus_equal_gen.len_cnt_reg__0\(2),
      O => \p_0_in__1\(3)
    );
\bus_equal_gen.len_cnt[4]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"6AAAAAAA"
    )
        port map (
      I0 => \bus_equal_gen.len_cnt_reg__0\(4),
      I1 => \bus_equal_gen.len_cnt_reg__0\(3),
      I2 => \bus_equal_gen.len_cnt_reg__0\(2),
      I3 => \bus_equal_gen.len_cnt_reg__0\(0),
      I4 => \bus_equal_gen.len_cnt_reg__0\(1),
      O => \p_0_in__1\(4)
    );
\bus_equal_gen.len_cnt[5]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6AAAAAAAAAAAAAAA"
    )
        port map (
      I0 => \bus_equal_gen.len_cnt_reg__0\(5),
      I1 => \bus_equal_gen.len_cnt_reg__0\(1),
      I2 => \bus_equal_gen.len_cnt_reg__0\(0),
      I3 => \bus_equal_gen.len_cnt_reg__0\(2),
      I4 => \bus_equal_gen.len_cnt_reg__0\(3),
      I5 => \bus_equal_gen.len_cnt_reg__0\(4),
      O => \p_0_in__1\(5)
    );
\bus_equal_gen.len_cnt[6]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \bus_equal_gen.len_cnt_reg__0\(6),
      I1 => \bus_equal_gen.len_cnt[7]_i_3_n_2\,
      O => \p_0_in__1\(6)
    );
\bus_equal_gen.len_cnt[7]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"6A"
    )
        port map (
      I0 => \bus_equal_gen.len_cnt_reg__0\(7),
      I1 => \bus_equal_gen.len_cnt[7]_i_3_n_2\,
      I2 => \bus_equal_gen.len_cnt_reg__0\(6),
      O => \p_0_in__1\(7)
    );
\bus_equal_gen.len_cnt[7]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8000000000000000"
    )
        port map (
      I0 => \bus_equal_gen.len_cnt_reg__0\(5),
      I1 => \bus_equal_gen.len_cnt_reg__0\(1),
      I2 => \bus_equal_gen.len_cnt_reg__0\(0),
      I3 => \bus_equal_gen.len_cnt_reg__0\(2),
      I4 => \bus_equal_gen.len_cnt_reg__0\(3),
      I5 => \bus_equal_gen.len_cnt_reg__0\(4),
      O => \bus_equal_gen.len_cnt[7]_i_3_n_2\
    );
\bus_equal_gen.len_cnt_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => \p_0_in__1\(0),
      Q => \bus_equal_gen.len_cnt_reg__0\(0),
      R => \bus_equal_gen.fifo_burst_n_39\
    );
\bus_equal_gen.len_cnt_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => \p_0_in__1\(1),
      Q => \bus_equal_gen.len_cnt_reg__0\(1),
      R => \bus_equal_gen.fifo_burst_n_39\
    );
\bus_equal_gen.len_cnt_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => \p_0_in__1\(2),
      Q => \bus_equal_gen.len_cnt_reg__0\(2),
      R => \bus_equal_gen.fifo_burst_n_39\
    );
\bus_equal_gen.len_cnt_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => \p_0_in__1\(3),
      Q => \bus_equal_gen.len_cnt_reg__0\(3),
      R => \bus_equal_gen.fifo_burst_n_39\
    );
\bus_equal_gen.len_cnt_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => \p_0_in__1\(4),
      Q => \bus_equal_gen.len_cnt_reg__0\(4),
      R => \bus_equal_gen.fifo_burst_n_39\
    );
\bus_equal_gen.len_cnt_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => \p_0_in__1\(5),
      Q => \bus_equal_gen.len_cnt_reg__0\(5),
      R => \bus_equal_gen.fifo_burst_n_39\
    );
\bus_equal_gen.len_cnt_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => \p_0_in__1\(6),
      Q => \bus_equal_gen.len_cnt_reg__0\(6),
      R => \bus_equal_gen.fifo_burst_n_39\
    );
\bus_equal_gen.len_cnt_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => \p_0_in__1\(7),
      Q => \bus_equal_gen.len_cnt_reg__0\(7),
      R => \bus_equal_gen.fifo_burst_n_39\
    );
\bus_equal_gen.strb_buf_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => tmp_strb(0),
      Q => m_axi_gmem_WSTRB(0),
      R => SR(0)
    );
\bus_equal_gen.strb_buf_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => tmp_strb(1),
      Q => m_axi_gmem_WSTRB(1),
      R => SR(0)
    );
\bus_equal_gen.strb_buf_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => tmp_strb(2),
      Q => m_axi_gmem_WSTRB(2),
      R => SR(0)
    );
\bus_equal_gen.strb_buf_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_30_in,
      D => tmp_strb(3),
      Q => m_axi_gmem_WSTRB(3),
      R => SR(0)
    );
\could_multi_bursts.AWVALID_Dummy_reg\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \bus_equal_gen.fifo_burst_n_3\,
      Q => \^awvalid_dummy\,
      R => '0'
    );
\could_multi_bursts.awaddr_buf[10]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => data1(10),
      I1 => \could_multi_bursts.awaddr_buf[31]_i_7_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[10]\,
      O => awaddr_tmp(10)
    );
\could_multi_bursts.awaddr_buf[11]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => data1(11),
      I1 => \could_multi_bursts.awaddr_buf[31]_i_7_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[11]\,
      O => awaddr_tmp(11)
    );
\could_multi_bursts.awaddr_buf[12]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => data1(12),
      I1 => \could_multi_bursts.awaddr_buf[31]_i_7_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[12]\,
      O => awaddr_tmp(12)
    );
\could_multi_bursts.awaddr_buf[13]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => data1(13),
      I1 => \could_multi_bursts.awaddr_buf[31]_i_7_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[13]\,
      O => awaddr_tmp(13)
    );
\could_multi_bursts.awaddr_buf[14]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => data1(14),
      I1 => \could_multi_bursts.awaddr_buf[31]_i_7_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[14]\,
      O => awaddr_tmp(14)
    );
\could_multi_bursts.awaddr_buf[15]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => data1(15),
      I1 => \could_multi_bursts.awaddr_buf[31]_i_7_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[15]\,
      O => awaddr_tmp(15)
    );
\could_multi_bursts.awaddr_buf[16]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => data1(16),
      I1 => \could_multi_bursts.awaddr_buf[31]_i_7_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[16]\,
      O => awaddr_tmp(16)
    );
\could_multi_bursts.awaddr_buf[17]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => data1(17),
      I1 => \could_multi_bursts.awaddr_buf[31]_i_7_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[17]\,
      O => awaddr_tmp(17)
    );
\could_multi_bursts.awaddr_buf[18]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => data1(18),
      I1 => \could_multi_bursts.awaddr_buf[31]_i_7_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[18]\,
      O => awaddr_tmp(18)
    );
\could_multi_bursts.awaddr_buf[19]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => data1(19),
      I1 => \could_multi_bursts.awaddr_buf[31]_i_7_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[19]\,
      O => awaddr_tmp(19)
    );
\could_multi_bursts.awaddr_buf[20]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => data1(20),
      I1 => \could_multi_bursts.awaddr_buf[31]_i_7_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[20]\,
      O => awaddr_tmp(20)
    );
\could_multi_bursts.awaddr_buf[21]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => data1(21),
      I1 => \could_multi_bursts.awaddr_buf[31]_i_7_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[21]\,
      O => awaddr_tmp(21)
    );
\could_multi_bursts.awaddr_buf[22]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => data1(22),
      I1 => \could_multi_bursts.awaddr_buf[31]_i_7_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[22]\,
      O => awaddr_tmp(22)
    );
\could_multi_bursts.awaddr_buf[23]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => data1(23),
      I1 => \could_multi_bursts.awaddr_buf[31]_i_7_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[23]\,
      O => awaddr_tmp(23)
    );
\could_multi_bursts.awaddr_buf[24]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => data1(24),
      I1 => \could_multi_bursts.awaddr_buf[31]_i_7_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[24]\,
      O => awaddr_tmp(24)
    );
\could_multi_bursts.awaddr_buf[25]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => data1(25),
      I1 => \could_multi_bursts.awaddr_buf[31]_i_7_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[25]\,
      O => awaddr_tmp(25)
    );
\could_multi_bursts.awaddr_buf[26]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => data1(26),
      I1 => \could_multi_bursts.awaddr_buf[31]_i_7_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[26]\,
      O => awaddr_tmp(26)
    );
\could_multi_bursts.awaddr_buf[27]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => data1(27),
      I1 => \could_multi_bursts.awaddr_buf[31]_i_7_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[27]\,
      O => awaddr_tmp(27)
    );
\could_multi_bursts.awaddr_buf[28]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => data1(28),
      I1 => \could_multi_bursts.awaddr_buf[31]_i_7_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[28]\,
      O => awaddr_tmp(28)
    );
\could_multi_bursts.awaddr_buf[29]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => data1(29),
      I1 => \could_multi_bursts.awaddr_buf[31]_i_7_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[29]\,
      O => awaddr_tmp(29)
    );
\could_multi_bursts.awaddr_buf[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => data1(2),
      I1 => \could_multi_bursts.awaddr_buf[31]_i_7_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[2]\,
      O => awaddr_tmp(2)
    );
\could_multi_bursts.awaddr_buf[30]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => data1(30),
      I1 => \could_multi_bursts.awaddr_buf[31]_i_7_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[30]\,
      O => awaddr_tmp(30)
    );
\could_multi_bursts.awaddr_buf[31]_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => data1(31),
      I1 => \could_multi_bursts.awaddr_buf[31]_i_7_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[31]\,
      O => awaddr_tmp(31)
    );
\could_multi_bursts.awaddr_buf[31]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => \could_multi_bursts.loop_cnt_reg__0\(0),
      I1 => \could_multi_bursts.loop_cnt_reg__0\(1),
      I2 => \could_multi_bursts.loop_cnt_reg__0\(2),
      I3 => \could_multi_bursts.loop_cnt_reg__0\(5),
      I4 => \could_multi_bursts.loop_cnt_reg__0\(4),
      I5 => \could_multi_bursts.loop_cnt_reg__0\(3),
      O => \could_multi_bursts.awaddr_buf[31]_i_7_n_2\
    );
\could_multi_bursts.awaddr_buf[3]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => data1(3),
      I1 => \could_multi_bursts.awaddr_buf[31]_i_7_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[3]\,
      O => awaddr_tmp(3)
    );
\could_multi_bursts.awaddr_buf[4]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => data1(4),
      I1 => \could_multi_bursts.awaddr_buf[31]_i_7_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[4]\,
      O => awaddr_tmp(4)
    );
\could_multi_bursts.awaddr_buf[4]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"956A"
    )
        port map (
      I0 => \^m_axi_gmem_awaddr\(2),
      I1 => \^could_multi_bursts.awlen_buf_reg[3]_0\(1),
      I2 => \^could_multi_bursts.awlen_buf_reg[3]_0\(0),
      I3 => \^could_multi_bursts.awlen_buf_reg[3]_0\(2),
      O => \could_multi_bursts.awaddr_buf[4]_i_3_n_2\
    );
\could_multi_bursts.awaddr_buf[4]_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => \^m_axi_gmem_awaddr\(1),
      I1 => \^could_multi_bursts.awlen_buf_reg[3]_0\(0),
      I2 => \^could_multi_bursts.awlen_buf_reg[3]_0\(1),
      O => \could_multi_bursts.awaddr_buf[4]_i_4_n_2\
    );
\could_multi_bursts.awaddr_buf[4]_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^m_axi_gmem_awaddr\(0),
      I1 => \^could_multi_bursts.awlen_buf_reg[3]_0\(0),
      O => \could_multi_bursts.awaddr_buf[4]_i_5_n_2\
    );
\could_multi_bursts.awaddr_buf[5]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => data1(5),
      I1 => \could_multi_bursts.awaddr_buf[31]_i_7_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[5]\,
      O => awaddr_tmp(5)
    );
\could_multi_bursts.awaddr_buf[6]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => data1(6),
      I1 => \could_multi_bursts.awaddr_buf[31]_i_7_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[6]\,
      O => awaddr_tmp(6)
    );
\could_multi_bursts.awaddr_buf[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => data1(7),
      I1 => \could_multi_bursts.awaddr_buf[31]_i_7_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[7]\,
      O => awaddr_tmp(7)
    );
\could_multi_bursts.awaddr_buf[8]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => data1(8),
      I1 => \could_multi_bursts.awaddr_buf[31]_i_7_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[8]\,
      O => awaddr_tmp(8)
    );
\could_multi_bursts.awaddr_buf[8]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"6AAAAAAA"
    )
        port map (
      I0 => \^m_axi_gmem_awaddr\(4),
      I1 => \^could_multi_bursts.awlen_buf_reg[3]_0\(0),
      I2 => \^could_multi_bursts.awlen_buf_reg[3]_0\(1),
      I3 => \^could_multi_bursts.awlen_buf_reg[3]_0\(2),
      I4 => \^could_multi_bursts.awlen_buf_reg[3]_0\(3),
      O => \could_multi_bursts.awaddr_buf[8]_i_3_n_2\
    );
\could_multi_bursts.awaddr_buf[8]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"95556AAA"
    )
        port map (
      I0 => \^m_axi_gmem_awaddr\(3),
      I1 => \^could_multi_bursts.awlen_buf_reg[3]_0\(0),
      I2 => \^could_multi_bursts.awlen_buf_reg[3]_0\(1),
      I3 => \^could_multi_bursts.awlen_buf_reg[3]_0\(2),
      I4 => \^could_multi_bursts.awlen_buf_reg[3]_0\(3),
      O => \could_multi_bursts.awaddr_buf[8]_i_4_n_2\
    );
\could_multi_bursts.awaddr_buf[9]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => data1(9),
      I1 => \could_multi_bursts.awaddr_buf[31]_i_7_n_2\,
      I2 => \sect_addr_buf_reg_n_2_[9]\,
      O => awaddr_tmp(9)
    );
\could_multi_bursts.awaddr_buf_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => awaddr_tmp(10),
      Q => \^m_axi_gmem_awaddr\(8),
      R => SR(0)
    );
\could_multi_bursts.awaddr_buf_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => awaddr_tmp(11),
      Q => \^m_axi_gmem_awaddr\(9),
      R => SR(0)
    );
\could_multi_bursts.awaddr_buf_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => awaddr_tmp(12),
      Q => \^m_axi_gmem_awaddr\(10),
      R => SR(0)
    );
\could_multi_bursts.awaddr_buf_reg[12]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => \could_multi_bursts.awaddr_buf_reg[8]_i_2_n_2\,
      CO(3) => \could_multi_bursts.awaddr_buf_reg[12]_i_2_n_2\,
      CO(2) => \could_multi_bursts.awaddr_buf_reg[12]_i_2_n_3\,
      CO(1) => \could_multi_bursts.awaddr_buf_reg[12]_i_2_n_4\,
      CO(0) => \could_multi_bursts.awaddr_buf_reg[12]_i_2_n_5\,
      CYINIT => '0',
      DI(3 downto 2) => B"00",
      DI(1 downto 0) => \^m_axi_gmem_awaddr\(8 downto 7),
      O(3 downto 0) => data1(12 downto 9),
      S(3 downto 0) => \^m_axi_gmem_awaddr\(10 downto 7)
    );
\could_multi_bursts.awaddr_buf_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => awaddr_tmp(13),
      Q => \^m_axi_gmem_awaddr\(11),
      R => SR(0)
    );
\could_multi_bursts.awaddr_buf_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => awaddr_tmp(14),
      Q => \^m_axi_gmem_awaddr\(12),
      R => SR(0)
    );
\could_multi_bursts.awaddr_buf_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => awaddr_tmp(15),
      Q => \^m_axi_gmem_awaddr\(13),
      R => SR(0)
    );
\could_multi_bursts.awaddr_buf_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => awaddr_tmp(16),
      Q => \^m_axi_gmem_awaddr\(14),
      R => SR(0)
    );
\could_multi_bursts.awaddr_buf_reg[16]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => \could_multi_bursts.awaddr_buf_reg[12]_i_2_n_2\,
      CO(3) => \could_multi_bursts.awaddr_buf_reg[16]_i_2_n_2\,
      CO(2) => \could_multi_bursts.awaddr_buf_reg[16]_i_2_n_3\,
      CO(1) => \could_multi_bursts.awaddr_buf_reg[16]_i_2_n_4\,
      CO(0) => \could_multi_bursts.awaddr_buf_reg[16]_i_2_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => data1(16 downto 13),
      S(3 downto 0) => \^m_axi_gmem_awaddr\(14 downto 11)
    );
\could_multi_bursts.awaddr_buf_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => awaddr_tmp(17),
      Q => \^m_axi_gmem_awaddr\(15),
      R => SR(0)
    );
\could_multi_bursts.awaddr_buf_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => awaddr_tmp(18),
      Q => \^m_axi_gmem_awaddr\(16),
      R => SR(0)
    );
\could_multi_bursts.awaddr_buf_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => awaddr_tmp(19),
      Q => \^m_axi_gmem_awaddr\(17),
      R => SR(0)
    );
\could_multi_bursts.awaddr_buf_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => awaddr_tmp(20),
      Q => \^m_axi_gmem_awaddr\(18),
      R => SR(0)
    );
\could_multi_bursts.awaddr_buf_reg[20]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => \could_multi_bursts.awaddr_buf_reg[16]_i_2_n_2\,
      CO(3) => \could_multi_bursts.awaddr_buf_reg[20]_i_2_n_2\,
      CO(2) => \could_multi_bursts.awaddr_buf_reg[20]_i_2_n_3\,
      CO(1) => \could_multi_bursts.awaddr_buf_reg[20]_i_2_n_4\,
      CO(0) => \could_multi_bursts.awaddr_buf_reg[20]_i_2_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => data1(20 downto 17),
      S(3 downto 0) => \^m_axi_gmem_awaddr\(18 downto 15)
    );
\could_multi_bursts.awaddr_buf_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => awaddr_tmp(21),
      Q => \^m_axi_gmem_awaddr\(19),
      R => SR(0)
    );
\could_multi_bursts.awaddr_buf_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => awaddr_tmp(22),
      Q => \^m_axi_gmem_awaddr\(20),
      R => SR(0)
    );
\could_multi_bursts.awaddr_buf_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => awaddr_tmp(23),
      Q => \^m_axi_gmem_awaddr\(21),
      R => SR(0)
    );
\could_multi_bursts.awaddr_buf_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => awaddr_tmp(24),
      Q => \^m_axi_gmem_awaddr\(22),
      R => SR(0)
    );
\could_multi_bursts.awaddr_buf_reg[24]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => \could_multi_bursts.awaddr_buf_reg[20]_i_2_n_2\,
      CO(3) => \could_multi_bursts.awaddr_buf_reg[24]_i_2_n_2\,
      CO(2) => \could_multi_bursts.awaddr_buf_reg[24]_i_2_n_3\,
      CO(1) => \could_multi_bursts.awaddr_buf_reg[24]_i_2_n_4\,
      CO(0) => \could_multi_bursts.awaddr_buf_reg[24]_i_2_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => data1(24 downto 21),
      S(3 downto 0) => \^m_axi_gmem_awaddr\(22 downto 19)
    );
\could_multi_bursts.awaddr_buf_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => awaddr_tmp(25),
      Q => \^m_axi_gmem_awaddr\(23),
      R => SR(0)
    );
\could_multi_bursts.awaddr_buf_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => awaddr_tmp(26),
      Q => \^m_axi_gmem_awaddr\(24),
      R => SR(0)
    );
\could_multi_bursts.awaddr_buf_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => awaddr_tmp(27),
      Q => \^m_axi_gmem_awaddr\(25),
      R => SR(0)
    );
\could_multi_bursts.awaddr_buf_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => awaddr_tmp(28),
      Q => \^m_axi_gmem_awaddr\(26),
      R => SR(0)
    );
\could_multi_bursts.awaddr_buf_reg[28]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => \could_multi_bursts.awaddr_buf_reg[24]_i_2_n_2\,
      CO(3) => \could_multi_bursts.awaddr_buf_reg[28]_i_2_n_2\,
      CO(2) => \could_multi_bursts.awaddr_buf_reg[28]_i_2_n_3\,
      CO(1) => \could_multi_bursts.awaddr_buf_reg[28]_i_2_n_4\,
      CO(0) => \could_multi_bursts.awaddr_buf_reg[28]_i_2_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => data1(28 downto 25),
      S(3 downto 0) => \^m_axi_gmem_awaddr\(26 downto 23)
    );
\could_multi_bursts.awaddr_buf_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => awaddr_tmp(29),
      Q => \^m_axi_gmem_awaddr\(27),
      R => SR(0)
    );
\could_multi_bursts.awaddr_buf_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => awaddr_tmp(2),
      Q => \^m_axi_gmem_awaddr\(0),
      R => SR(0)
    );
\could_multi_bursts.awaddr_buf_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => awaddr_tmp(30),
      Q => \^m_axi_gmem_awaddr\(28),
      R => SR(0)
    );
\could_multi_bursts.awaddr_buf_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => awaddr_tmp(31),
      Q => \^m_axi_gmem_awaddr\(29),
      R => SR(0)
    );
\could_multi_bursts.awaddr_buf_reg[31]_i_6\: unisim.vcomponents.CARRY4
     port map (
      CI => \could_multi_bursts.awaddr_buf_reg[28]_i_2_n_2\,
      CO(3 downto 2) => \NLW_could_multi_bursts.awaddr_buf_reg[31]_i_6_CO_UNCONNECTED\(3 downto 2),
      CO(1) => \could_multi_bursts.awaddr_buf_reg[31]_i_6_n_4\,
      CO(0) => \could_multi_bursts.awaddr_buf_reg[31]_i_6_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \NLW_could_multi_bursts.awaddr_buf_reg[31]_i_6_O_UNCONNECTED\(3),
      O(2 downto 0) => data1(31 downto 29),
      S(3) => '0',
      S(2 downto 0) => \^m_axi_gmem_awaddr\(29 downto 27)
    );
\could_multi_bursts.awaddr_buf_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => awaddr_tmp(3),
      Q => \^m_axi_gmem_awaddr\(1),
      R => SR(0)
    );
\could_multi_bursts.awaddr_buf_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => awaddr_tmp(4),
      Q => \^m_axi_gmem_awaddr\(2),
      R => SR(0)
    );
\could_multi_bursts.awaddr_buf_reg[4]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \could_multi_bursts.awaddr_buf_reg[4]_i_2_n_2\,
      CO(2) => \could_multi_bursts.awaddr_buf_reg[4]_i_2_n_3\,
      CO(1) => \could_multi_bursts.awaddr_buf_reg[4]_i_2_n_4\,
      CO(0) => \could_multi_bursts.awaddr_buf_reg[4]_i_2_n_5\,
      CYINIT => '0',
      DI(3 downto 1) => \^m_axi_gmem_awaddr\(2 downto 0),
      DI(0) => '0',
      O(3 downto 1) => data1(4 downto 2),
      O(0) => \NLW_could_multi_bursts.awaddr_buf_reg[4]_i_2_O_UNCONNECTED\(0),
      S(3) => \could_multi_bursts.awaddr_buf[4]_i_3_n_2\,
      S(2) => \could_multi_bursts.awaddr_buf[4]_i_4_n_2\,
      S(1) => \could_multi_bursts.awaddr_buf[4]_i_5_n_2\,
      S(0) => '0'
    );
\could_multi_bursts.awaddr_buf_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => awaddr_tmp(5),
      Q => \^m_axi_gmem_awaddr\(3),
      R => SR(0)
    );
\could_multi_bursts.awaddr_buf_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => awaddr_tmp(6),
      Q => \^m_axi_gmem_awaddr\(4),
      R => SR(0)
    );
\could_multi_bursts.awaddr_buf_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => awaddr_tmp(7),
      Q => \^m_axi_gmem_awaddr\(5),
      R => SR(0)
    );
\could_multi_bursts.awaddr_buf_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => awaddr_tmp(8),
      Q => \^m_axi_gmem_awaddr\(6),
      R => SR(0)
    );
\could_multi_bursts.awaddr_buf_reg[8]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => \could_multi_bursts.awaddr_buf_reg[4]_i_2_n_2\,
      CO(3) => \could_multi_bursts.awaddr_buf_reg[8]_i_2_n_2\,
      CO(2) => \could_multi_bursts.awaddr_buf_reg[8]_i_2_n_3\,
      CO(1) => \could_multi_bursts.awaddr_buf_reg[8]_i_2_n_4\,
      CO(0) => \could_multi_bursts.awaddr_buf_reg[8]_i_2_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => \^m_axi_gmem_awaddr\(6 downto 3),
      O(3 downto 0) => data1(8 downto 5),
      S(3 downto 2) => \^m_axi_gmem_awaddr\(6 downto 5),
      S(1) => \could_multi_bursts.awaddr_buf[8]_i_3_n_2\,
      S(0) => \could_multi_bursts.awaddr_buf[8]_i_4_n_2\
    );
\could_multi_bursts.awaddr_buf_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => awaddr_tmp(9),
      Q => \^m_axi_gmem_awaddr\(7),
      R => SR(0)
    );
\could_multi_bursts.awlen_buf_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => awlen_tmp(0),
      Q => \^could_multi_bursts.awlen_buf_reg[3]_0\(0),
      R => SR(0)
    );
\could_multi_bursts.awlen_buf_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => awlen_tmp(1),
      Q => \^could_multi_bursts.awlen_buf_reg[3]_0\(1),
      R => SR(0)
    );
\could_multi_bursts.awlen_buf_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => awlen_tmp(2),
      Q => \^could_multi_bursts.awlen_buf_reg[3]_0\(2),
      R => SR(0)
    );
\could_multi_bursts.awlen_buf_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => awlen_tmp(3),
      Q => \^could_multi_bursts.awlen_buf_reg[3]_0\(3),
      R => SR(0)
    );
\could_multi_bursts.last_sect_buf_reg\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \bus_equal_gen.fifo_burst_n_36\,
      Q => \could_multi_bursts.last_sect_buf_reg_n_2\,
      R => SR(0)
    );
\could_multi_bursts.loop_cnt[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \could_multi_bursts.loop_cnt_reg__0\(0),
      O => \p_0_in__0\(0)
    );
\could_multi_bursts.loop_cnt[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \could_multi_bursts.loop_cnt_reg__0\(1),
      I1 => \could_multi_bursts.loop_cnt_reg__0\(0),
      O => \p_0_in__0\(1)
    );
\could_multi_bursts.loop_cnt[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"6A"
    )
        port map (
      I0 => \could_multi_bursts.loop_cnt_reg__0\(2),
      I1 => \could_multi_bursts.loop_cnt_reg__0\(0),
      I2 => \could_multi_bursts.loop_cnt_reg__0\(1),
      O => \p_0_in__0\(2)
    );
\could_multi_bursts.loop_cnt[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6AAA"
    )
        port map (
      I0 => \could_multi_bursts.loop_cnt_reg__0\(3),
      I1 => \could_multi_bursts.loop_cnt_reg__0\(1),
      I2 => \could_multi_bursts.loop_cnt_reg__0\(0),
      I3 => \could_multi_bursts.loop_cnt_reg__0\(2),
      O => \p_0_in__0\(3)
    );
\could_multi_bursts.loop_cnt[4]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"6AAAAAAA"
    )
        port map (
      I0 => \could_multi_bursts.loop_cnt_reg__0\(4),
      I1 => \could_multi_bursts.loop_cnt_reg__0\(2),
      I2 => \could_multi_bursts.loop_cnt_reg__0\(0),
      I3 => \could_multi_bursts.loop_cnt_reg__0\(1),
      I4 => \could_multi_bursts.loop_cnt_reg__0\(3),
      O => \p_0_in__0\(4)
    );
\could_multi_bursts.loop_cnt[5]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6AAAAAAAAAAAAAAA"
    )
        port map (
      I0 => \could_multi_bursts.loop_cnt_reg__0\(5),
      I1 => \could_multi_bursts.loop_cnt_reg__0\(3),
      I2 => \could_multi_bursts.loop_cnt_reg__0\(1),
      I3 => \could_multi_bursts.loop_cnt_reg__0\(0),
      I4 => \could_multi_bursts.loop_cnt_reg__0\(2),
      I5 => \could_multi_bursts.loop_cnt_reg__0\(4),
      O => \p_0_in__0\(5)
    );
\could_multi_bursts.loop_cnt_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => \p_0_in__0\(0),
      Q => \could_multi_bursts.loop_cnt_reg__0\(0),
      R => \bus_equal_gen.fifo_burst_n_37\
    );
\could_multi_bursts.loop_cnt_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => \p_0_in__0\(1),
      Q => \could_multi_bursts.loop_cnt_reg__0\(1),
      R => \bus_equal_gen.fifo_burst_n_37\
    );
\could_multi_bursts.loop_cnt_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => \p_0_in__0\(2),
      Q => \could_multi_bursts.loop_cnt_reg__0\(2),
      R => \bus_equal_gen.fifo_burst_n_37\
    );
\could_multi_bursts.loop_cnt_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => \p_0_in__0\(3),
      Q => \could_multi_bursts.loop_cnt_reg__0\(3),
      R => \bus_equal_gen.fifo_burst_n_37\
    );
\could_multi_bursts.loop_cnt_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => \p_0_in__0\(4),
      Q => \could_multi_bursts.loop_cnt_reg__0\(4),
      R => \bus_equal_gen.fifo_burst_n_37\
    );
\could_multi_bursts.loop_cnt_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => push,
      D => \p_0_in__0\(5),
      Q => \could_multi_bursts.loop_cnt_reg__0\(5),
      R => \bus_equal_gen.fifo_burst_n_37\
    );
\could_multi_bursts.sect_handling_reg\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \bus_equal_gen.fifo_burst_n_34\,
      Q => \could_multi_bursts.sect_handling_reg_n_2\,
      R => SR(0)
    );
\end_addr_buf[2]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[2]\,
      I1 => \align_len_reg_n_2_[2]\,
      O => end_addr(2)
    );
\end_addr_buf_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => end_addr(10),
      Q => \end_addr_buf_reg_n_2_[10]\,
      R => SR(0)
    );
\end_addr_buf_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => end_addr(11),
      Q => \end_addr_buf_reg_n_2_[11]\,
      R => SR(0)
    );
\end_addr_buf_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => end_addr(12),
      Q => p_0_in0_in(0),
      R => SR(0)
    );
\end_addr_buf_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => end_addr(13),
      Q => p_0_in0_in(1),
      R => SR(0)
    );
\end_addr_buf_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => end_addr(14),
      Q => p_0_in0_in(2),
      R => SR(0)
    );
\end_addr_buf_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => end_addr(15),
      Q => p_0_in0_in(3),
      R => SR(0)
    );
\end_addr_buf_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => end_addr(16),
      Q => p_0_in0_in(4),
      R => SR(0)
    );
\end_addr_buf_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => end_addr(17),
      Q => p_0_in0_in(5),
      R => SR(0)
    );
\end_addr_buf_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => end_addr(18),
      Q => p_0_in0_in(6),
      R => SR(0)
    );
\end_addr_buf_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => end_addr(19),
      Q => p_0_in0_in(7),
      R => SR(0)
    );
\end_addr_buf_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => end_addr(20),
      Q => p_0_in0_in(8),
      R => SR(0)
    );
\end_addr_buf_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => end_addr(21),
      Q => p_0_in0_in(9),
      R => SR(0)
    );
\end_addr_buf_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => end_addr(22),
      Q => p_0_in0_in(10),
      R => SR(0)
    );
\end_addr_buf_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => end_addr(23),
      Q => p_0_in0_in(11),
      R => SR(0)
    );
\end_addr_buf_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => end_addr(24),
      Q => p_0_in0_in(12),
      R => SR(0)
    );
\end_addr_buf_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => end_addr(25),
      Q => p_0_in0_in(13),
      R => SR(0)
    );
\end_addr_buf_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => end_addr(26),
      Q => p_0_in0_in(14),
      R => SR(0)
    );
\end_addr_buf_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => end_addr(27),
      Q => p_0_in0_in(15),
      R => SR(0)
    );
\end_addr_buf_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => end_addr(28),
      Q => p_0_in0_in(16),
      R => SR(0)
    );
\end_addr_buf_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => end_addr(29),
      Q => p_0_in0_in(17),
      R => SR(0)
    );
\end_addr_buf_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => end_addr(2),
      Q => \end_addr_buf_reg_n_2_[2]\,
      R => SR(0)
    );
\end_addr_buf_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => end_addr(30),
      Q => p_0_in0_in(18),
      R => SR(0)
    );
\end_addr_buf_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => end_addr(31),
      Q => p_0_in0_in(19),
      R => SR(0)
    );
\end_addr_buf_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => end_addr(3),
      Q => \end_addr_buf_reg_n_2_[3]\,
      R => SR(0)
    );
\end_addr_buf_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => end_addr(4),
      Q => \end_addr_buf_reg_n_2_[4]\,
      R => SR(0)
    );
\end_addr_buf_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => end_addr(5),
      Q => \end_addr_buf_reg_n_2_[5]\,
      R => SR(0)
    );
\end_addr_buf_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => end_addr(6),
      Q => \end_addr_buf_reg_n_2_[6]\,
      R => SR(0)
    );
\end_addr_buf_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => end_addr(7),
      Q => \end_addr_buf_reg_n_2_[7]\,
      R => SR(0)
    );
\end_addr_buf_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => end_addr(8),
      Q => \end_addr_buf_reg_n_2_[8]\,
      R => SR(0)
    );
\end_addr_buf_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => end_addr(9),
      Q => \end_addr_buf_reg_n_2_[9]\,
      R => SR(0)
    );
end_addr_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => end_addr_carry_n_2,
      CO(2) => end_addr_carry_n_3,
      CO(1) => end_addr_carry_n_4,
      CO(0) => end_addr_carry_n_5,
      CYINIT => '0',
      DI(3) => \start_addr_reg_n_2_[5]\,
      DI(2) => \start_addr_reg_n_2_[4]\,
      DI(1) => \start_addr_reg_n_2_[3]\,
      DI(0) => \start_addr_reg_n_2_[2]\,
      O(3 downto 1) => end_addr(5 downto 3),
      O(0) => NLW_end_addr_carry_O_UNCONNECTED(0),
      S(3) => end_addr_carry_i_1_n_2,
      S(2) => end_addr_carry_i_2_n_2,
      S(1) => end_addr_carry_i_3_n_2,
      S(0) => end_addr_carry_i_4_n_2
    );
\end_addr_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => end_addr_carry_n_2,
      CO(3) => \end_addr_carry__0_n_2\,
      CO(2) => \end_addr_carry__0_n_3\,
      CO(1) => \end_addr_carry__0_n_4\,
      CO(0) => \end_addr_carry__0_n_5\,
      CYINIT => '0',
      DI(3) => \start_addr_reg_n_2_[9]\,
      DI(2) => \start_addr_reg_n_2_[8]\,
      DI(1) => \start_addr_reg_n_2_[7]\,
      DI(0) => \start_addr_reg_n_2_[6]\,
      O(3 downto 0) => end_addr(9 downto 6),
      S(3) => \end_addr_carry__0_i_1_n_2\,
      S(2) => \end_addr_carry__0_i_2_n_2\,
      S(1) => \end_addr_carry__0_i_3_n_2\,
      S(0) => \end_addr_carry__0_i_4_n_2\
    );
\end_addr_carry__0_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[9]\,
      I1 => \align_len_reg_n_2_[31]\,
      O => \end_addr_carry__0_i_1_n_2\
    );
\end_addr_carry__0_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[8]\,
      I1 => \align_len_reg_n_2_[31]\,
      O => \end_addr_carry__0_i_2_n_2\
    );
\end_addr_carry__0_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[7]\,
      I1 => \align_len_reg_n_2_[31]\,
      O => \end_addr_carry__0_i_3_n_2\
    );
\end_addr_carry__0_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[6]\,
      I1 => \align_len_reg_n_2_[31]\,
      O => \end_addr_carry__0_i_4_n_2\
    );
\end_addr_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \end_addr_carry__0_n_2\,
      CO(3) => \end_addr_carry__1_n_2\,
      CO(2) => \end_addr_carry__1_n_3\,
      CO(1) => \end_addr_carry__1_n_4\,
      CO(0) => \end_addr_carry__1_n_5\,
      CYINIT => '0',
      DI(3) => \start_addr_reg_n_2_[13]\,
      DI(2) => \start_addr_reg_n_2_[12]\,
      DI(1) => \start_addr_reg_n_2_[11]\,
      DI(0) => \start_addr_reg_n_2_[10]\,
      O(3 downto 0) => end_addr(13 downto 10),
      S(3) => \end_addr_carry__1_i_1_n_2\,
      S(2) => \end_addr_carry__1_i_2_n_2\,
      S(1) => \end_addr_carry__1_i_3_n_2\,
      S(0) => \end_addr_carry__1_i_4_n_2\
    );
\end_addr_carry__1_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[13]\,
      I1 => \align_len_reg_n_2_[31]\,
      O => \end_addr_carry__1_i_1_n_2\
    );
\end_addr_carry__1_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[12]\,
      I1 => \align_len_reg_n_2_[31]\,
      O => \end_addr_carry__1_i_2_n_2\
    );
\end_addr_carry__1_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[11]\,
      I1 => \align_len_reg_n_2_[31]\,
      O => \end_addr_carry__1_i_3_n_2\
    );
\end_addr_carry__1_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[10]\,
      I1 => \align_len_reg_n_2_[31]\,
      O => \end_addr_carry__1_i_4_n_2\
    );
\end_addr_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \end_addr_carry__1_n_2\,
      CO(3) => \end_addr_carry__2_n_2\,
      CO(2) => \end_addr_carry__2_n_3\,
      CO(1) => \end_addr_carry__2_n_4\,
      CO(0) => \end_addr_carry__2_n_5\,
      CYINIT => '0',
      DI(3) => \start_addr_reg_n_2_[17]\,
      DI(2) => \start_addr_reg_n_2_[16]\,
      DI(1) => \start_addr_reg_n_2_[15]\,
      DI(0) => \start_addr_reg_n_2_[14]\,
      O(3 downto 0) => end_addr(17 downto 14),
      S(3) => \end_addr_carry__2_i_1_n_2\,
      S(2) => \end_addr_carry__2_i_2_n_2\,
      S(1) => \end_addr_carry__2_i_3_n_2\,
      S(0) => \end_addr_carry__2_i_4_n_2\
    );
\end_addr_carry__2_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[17]\,
      I1 => \align_len_reg_n_2_[31]\,
      O => \end_addr_carry__2_i_1_n_2\
    );
\end_addr_carry__2_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[16]\,
      I1 => \align_len_reg_n_2_[31]\,
      O => \end_addr_carry__2_i_2_n_2\
    );
\end_addr_carry__2_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[15]\,
      I1 => \align_len_reg_n_2_[31]\,
      O => \end_addr_carry__2_i_3_n_2\
    );
\end_addr_carry__2_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[14]\,
      I1 => \align_len_reg_n_2_[31]\,
      O => \end_addr_carry__2_i_4_n_2\
    );
\end_addr_carry__3\: unisim.vcomponents.CARRY4
     port map (
      CI => \end_addr_carry__2_n_2\,
      CO(3) => \end_addr_carry__3_n_2\,
      CO(2) => \end_addr_carry__3_n_3\,
      CO(1) => \end_addr_carry__3_n_4\,
      CO(0) => \end_addr_carry__3_n_5\,
      CYINIT => '0',
      DI(3) => \start_addr_reg_n_2_[21]\,
      DI(2) => \start_addr_reg_n_2_[20]\,
      DI(1) => \start_addr_reg_n_2_[19]\,
      DI(0) => \start_addr_reg_n_2_[18]\,
      O(3 downto 0) => end_addr(21 downto 18),
      S(3) => \end_addr_carry__3_i_1_n_2\,
      S(2) => \end_addr_carry__3_i_2_n_2\,
      S(1) => \end_addr_carry__3_i_3_n_2\,
      S(0) => \end_addr_carry__3_i_4_n_2\
    );
\end_addr_carry__3_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[21]\,
      I1 => \align_len_reg_n_2_[31]\,
      O => \end_addr_carry__3_i_1_n_2\
    );
\end_addr_carry__3_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[20]\,
      I1 => \align_len_reg_n_2_[31]\,
      O => \end_addr_carry__3_i_2_n_2\
    );
\end_addr_carry__3_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[19]\,
      I1 => \align_len_reg_n_2_[31]\,
      O => \end_addr_carry__3_i_3_n_2\
    );
\end_addr_carry__3_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[18]\,
      I1 => \align_len_reg_n_2_[31]\,
      O => \end_addr_carry__3_i_4_n_2\
    );
\end_addr_carry__4\: unisim.vcomponents.CARRY4
     port map (
      CI => \end_addr_carry__3_n_2\,
      CO(3) => \end_addr_carry__4_n_2\,
      CO(2) => \end_addr_carry__4_n_3\,
      CO(1) => \end_addr_carry__4_n_4\,
      CO(0) => \end_addr_carry__4_n_5\,
      CYINIT => '0',
      DI(3) => \start_addr_reg_n_2_[25]\,
      DI(2) => \start_addr_reg_n_2_[24]\,
      DI(1) => \start_addr_reg_n_2_[23]\,
      DI(0) => \start_addr_reg_n_2_[22]\,
      O(3 downto 0) => end_addr(25 downto 22),
      S(3) => \end_addr_carry__4_i_1_n_2\,
      S(2) => \end_addr_carry__4_i_2_n_2\,
      S(1) => \end_addr_carry__4_i_3_n_2\,
      S(0) => \end_addr_carry__4_i_4_n_2\
    );
\end_addr_carry__4_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[25]\,
      I1 => \align_len_reg_n_2_[31]\,
      O => \end_addr_carry__4_i_1_n_2\
    );
\end_addr_carry__4_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[24]\,
      I1 => \align_len_reg_n_2_[31]\,
      O => \end_addr_carry__4_i_2_n_2\
    );
\end_addr_carry__4_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[23]\,
      I1 => \align_len_reg_n_2_[31]\,
      O => \end_addr_carry__4_i_3_n_2\
    );
\end_addr_carry__4_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[22]\,
      I1 => \align_len_reg_n_2_[31]\,
      O => \end_addr_carry__4_i_4_n_2\
    );
\end_addr_carry__5\: unisim.vcomponents.CARRY4
     port map (
      CI => \end_addr_carry__4_n_2\,
      CO(3) => \end_addr_carry__5_n_2\,
      CO(2) => \end_addr_carry__5_n_3\,
      CO(1) => \end_addr_carry__5_n_4\,
      CO(0) => \end_addr_carry__5_n_5\,
      CYINIT => '0',
      DI(3) => \start_addr_reg_n_2_[29]\,
      DI(2) => \start_addr_reg_n_2_[28]\,
      DI(1) => \start_addr_reg_n_2_[27]\,
      DI(0) => \start_addr_reg_n_2_[26]\,
      O(3 downto 0) => end_addr(29 downto 26),
      S(3) => \end_addr_carry__5_i_1_n_2\,
      S(2) => \end_addr_carry__5_i_2_n_2\,
      S(1) => \end_addr_carry__5_i_3_n_2\,
      S(0) => \end_addr_carry__5_i_4_n_2\
    );
\end_addr_carry__5_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[29]\,
      I1 => \align_len_reg_n_2_[31]\,
      O => \end_addr_carry__5_i_1_n_2\
    );
\end_addr_carry__5_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[28]\,
      I1 => \align_len_reg_n_2_[31]\,
      O => \end_addr_carry__5_i_2_n_2\
    );
\end_addr_carry__5_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[27]\,
      I1 => \align_len_reg_n_2_[31]\,
      O => \end_addr_carry__5_i_3_n_2\
    );
\end_addr_carry__5_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[26]\,
      I1 => \align_len_reg_n_2_[31]\,
      O => \end_addr_carry__5_i_4_n_2\
    );
\end_addr_carry__6\: unisim.vcomponents.CARRY4
     port map (
      CI => \end_addr_carry__5_n_2\,
      CO(3 downto 1) => \NLW_end_addr_carry__6_CO_UNCONNECTED\(3 downto 1),
      CO(0) => \end_addr_carry__6_n_5\,
      CYINIT => '0',
      DI(3 downto 1) => B"000",
      DI(0) => \start_addr_reg_n_2_[30]\,
      O(3 downto 2) => \NLW_end_addr_carry__6_O_UNCONNECTED\(3 downto 2),
      O(1 downto 0) => end_addr(31 downto 30),
      S(3 downto 2) => B"00",
      S(1) => \end_addr_carry__6_i_1_n_2\,
      S(0) => \end_addr_carry__6_i_2_n_2\
    );
\end_addr_carry__6_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \align_len_reg_n_2_[31]\,
      I1 => \start_addr_reg_n_2_[31]\,
      O => \end_addr_carry__6_i_1_n_2\
    );
\end_addr_carry__6_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[30]\,
      I1 => \align_len_reg_n_2_[31]\,
      O => \end_addr_carry__6_i_2_n_2\
    );
end_addr_carry_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[5]\,
      I1 => \align_len_reg_n_2_[31]\,
      O => end_addr_carry_i_1_n_2
    );
end_addr_carry_i_2: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[4]\,
      I1 => \align_len_reg_n_2_[31]\,
      O => end_addr_carry_i_2_n_2
    );
end_addr_carry_i_3: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[3]\,
      I1 => \align_len_reg_n_2_[3]\,
      O => end_addr_carry_i_3_n_2
    );
end_addr_carry_i_4: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \start_addr_reg_n_2_[2]\,
      I1 => \align_len_reg_n_2_[2]\,
      O => end_addr_carry_i_4_n_2
    );
fifo_resp: entity work.\design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo__parameterized1\
     port map (
      SR(0) => SR(0),
      ap_clk => ap_clk,
      ap_rst_n => ap_rst_n,
      fifo_resp_ready => fifo_resp_ready,
      \in\(0) => invalid_len_event_reg2,
      m_axi_gmem_BVALID => m_axi_gmem_BVALID,
      next_resp => next_resp,
      next_resp0 => next_resp0,
      next_resp_reg => \^full_n_reg\,
      push => push_0,
      push_0 => push,
      \q_reg[1]_0\ => \could_multi_bursts.last_sect_buf_reg_n_2\,
      \q_reg[1]_1\ => \bus_equal_gen.fifo_burst_n_28\
    );
fifo_resp_to_user: entity work.\design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo__parameterized2\
     port map (
      Q(2 downto 1) => Q(6 downto 5),
      Q(0) => Q(0),
      SR(0) => SR(0),
      \ap_CS_fsm_reg[15]\(1) => \ap_CS_fsm_reg[15]\(5),
      \ap_CS_fsm_reg[15]\(0) => \ap_CS_fsm_reg[15]\(0),
      ap_clk => ap_clk,
      ap_done => ap_done,
      ap_rst_n => ap_rst_n,
      ap_start => ap_start,
      empty_n_reg_0 => empty_n_reg,
      full_n_reg_0 => \^full_n_reg\,
      push => push_0
    );
fifo_wreq: entity work.\design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_fifo__parameterized0\
     port map (
      CO(0) => last_sect,
      E(0) => pop0,
      Q(0) => rs2f_wreq_valid,
      S(3) => fifo_wreq_n_38,
      S(2) => fifo_wreq_n_39,
      S(1) => fifo_wreq_n_40,
      S(0) => fifo_wreq_n_41,
      SR(0) => SR(0),
      \align_len_reg[31]\ => wreq_handling_reg_n_2,
      ap_clk => ap_clk,
      ap_rst_n => ap_rst_n,
      empty_n_reg_0(0) => align_len0_0,
      empty_n_reg_1 => fifo_wreq_n_5,
      empty_n_reg_2 => fifo_wreq_n_6,
      empty_n_reg_3(0) => fifo_wreq_n_46,
      fifo_wreq_valid => fifo_wreq_valid,
      full_n_reg_0 => \could_multi_bursts.sect_handling_reg_n_2\,
      full_n_reg_1 => \bus_equal_gen.fifo_burst_n_28\,
      full_n_reg_2(0) => push,
      \last_sect_carry__0\(19 downto 0) => p_0_in0_in(19 downto 0),
      \last_sect_carry__0_0\(19 downto 0) => sect_cnt(19 downto 0),
      p_26_in => p_26_in,
      push => push_1,
      \q_reg[29]_0\(29 downto 0) => rs2f_wreq_data(29 downto 0),
      \q_reg[33]_0\(30) => fifo_wreq_data(33),
      \q_reg[33]_0\(29) => fifo_wreq_n_8,
      \q_reg[33]_0\(28) => fifo_wreq_n_9,
      \q_reg[33]_0\(27) => fifo_wreq_n_10,
      \q_reg[33]_0\(26) => fifo_wreq_n_11,
      \q_reg[33]_0\(25) => fifo_wreq_n_12,
      \q_reg[33]_0\(24) => fifo_wreq_n_13,
      \q_reg[33]_0\(23) => fifo_wreq_n_14,
      \q_reg[33]_0\(22) => fifo_wreq_n_15,
      \q_reg[33]_0\(21) => fifo_wreq_n_16,
      \q_reg[33]_0\(20) => fifo_wreq_n_17,
      \q_reg[33]_0\(19) => fifo_wreq_n_18,
      \q_reg[33]_0\(18) => fifo_wreq_n_19,
      \q_reg[33]_0\(17) => fifo_wreq_n_20,
      \q_reg[33]_0\(16) => fifo_wreq_n_21,
      \q_reg[33]_0\(15) => fifo_wreq_n_22,
      \q_reg[33]_0\(14) => fifo_wreq_n_23,
      \q_reg[33]_0\(13) => fifo_wreq_n_24,
      \q_reg[33]_0\(12) => fifo_wreq_n_25,
      \q_reg[33]_0\(11) => fifo_wreq_n_26,
      \q_reg[33]_0\(10) => fifo_wreq_n_27,
      \q_reg[33]_0\(9) => fifo_wreq_n_28,
      \q_reg[33]_0\(8) => fifo_wreq_n_29,
      \q_reg[33]_0\(7) => fifo_wreq_n_30,
      \q_reg[33]_0\(6) => fifo_wreq_n_31,
      \q_reg[33]_0\(5) => fifo_wreq_n_32,
      \q_reg[33]_0\(4) => fifo_wreq_n_33,
      \q_reg[33]_0\(3) => fifo_wreq_n_34,
      \q_reg[33]_0\(2) => fifo_wreq_n_35,
      \q_reg[33]_0\(1) => fifo_wreq_n_36,
      \q_reg[33]_0\(0) => fifo_wreq_n_37,
      \q_reg[33]_1\(0) => zero_len_event0,
      \q_reg[33]_2\(0) => fifo_wreq_n_47,
      rs2f_wreq_ack => rs2f_wreq_ack,
      \sect_cnt_reg[0]\ => fifo_wreq_valid_buf_reg_n_2,
      \sect_cnt_reg[19]\(2) => fifo_wreq_n_42,
      \sect_cnt_reg[19]\(1) => fifo_wreq_n_43,
      \sect_cnt_reg[19]\(0) => fifo_wreq_n_44
    );
fifo_wreq_valid_buf_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => fifo_wreq_valid,
      Q => fifo_wreq_valid_buf_reg_n_2,
      R => SR(0)
    );
first_sect_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => first_sect_carry_n_2,
      CO(2) => first_sect_carry_n_3,
      CO(1) => first_sect_carry_n_4,
      CO(0) => first_sect_carry_n_5,
      CYINIT => '1',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => NLW_first_sect_carry_O_UNCONNECTED(3 downto 0),
      S(3) => first_sect_carry_i_1_n_2,
      S(2) => first_sect_carry_i_2_n_2,
      S(1) => first_sect_carry_i_3_n_2,
      S(0) => first_sect_carry_i_4_n_2
    );
\first_sect_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => first_sect_carry_n_2,
      CO(3) => \NLW_first_sect_carry__0_CO_UNCONNECTED\(3),
      CO(2) => first_sect,
      CO(1) => \first_sect_carry__0_n_4\,
      CO(0) => \first_sect_carry__0_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_first_sect_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => '0',
      S(2) => \first_sect_carry__0_i_1_n_2\,
      S(1) => \first_sect_carry__0_i_2_n_2\,
      S(0) => \first_sect_carry__0_i_3_n_2\
    );
\first_sect_carry__0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => start_addr_buf(31),
      I1 => sect_cnt(19),
      I2 => start_addr_buf(30),
      I3 => sect_cnt(18),
      O => \first_sect_carry__0_i_1_n_2\
    );
\first_sect_carry__0_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => sect_cnt(15),
      I1 => start_addr_buf(27),
      I2 => sect_cnt(16),
      I3 => start_addr_buf(28),
      I4 => start_addr_buf(29),
      I5 => sect_cnt(17),
      O => \first_sect_carry__0_i_2_n_2\
    );
\first_sect_carry__0_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => start_addr_buf(26),
      I1 => sect_cnt(14),
      I2 => sect_cnt(12),
      I3 => start_addr_buf(24),
      I4 => sect_cnt(13),
      I5 => start_addr_buf(25),
      O => \first_sect_carry__0_i_3_n_2\
    );
first_sect_carry_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => start_addr_buf(23),
      I1 => sect_cnt(11),
      I2 => sect_cnt(9),
      I3 => start_addr_buf(21),
      I4 => sect_cnt(10),
      I5 => start_addr_buf(22),
      O => first_sect_carry_i_1_n_2
    );
first_sect_carry_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => sect_cnt(6),
      I1 => start_addr_buf(18),
      I2 => sect_cnt(7),
      I3 => start_addr_buf(19),
      I4 => start_addr_buf(20),
      I5 => sect_cnt(8),
      O => first_sect_carry_i_2_n_2
    );
first_sect_carry_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => start_addr_buf(17),
      I1 => sect_cnt(5),
      I2 => sect_cnt(3),
      I3 => start_addr_buf(15),
      I4 => sect_cnt(4),
      I5 => start_addr_buf(16),
      O => first_sect_carry_i_3_n_2
    );
first_sect_carry_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => start_addr_buf(14),
      I1 => sect_cnt(2),
      I2 => sect_cnt(0),
      I3 => start_addr_buf(12),
      I4 => sect_cnt(1),
      I5 => start_addr_buf(13),
      O => first_sect_carry_i_4_n_2
    );
invalid_len_event_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => fifo_wreq_n_6,
      Q => invalid_len_event,
      R => SR(0)
    );
invalid_len_event_reg1_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => invalid_len_event,
      Q => invalid_len_event_reg1,
      R => SR(0)
    );
invalid_len_event_reg2_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => invalid_len_event_reg1,
      Q => invalid_len_event_reg2,
      R => SR(0)
    );
last_sect_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => last_sect_carry_n_2,
      CO(2) => last_sect_carry_n_3,
      CO(1) => last_sect_carry_n_4,
      CO(0) => last_sect_carry_n_5,
      CYINIT => '1',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => NLW_last_sect_carry_O_UNCONNECTED(3 downto 0),
      S(3) => fifo_wreq_n_38,
      S(2) => fifo_wreq_n_39,
      S(1) => fifo_wreq_n_40,
      S(0) => fifo_wreq_n_41
    );
\last_sect_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => last_sect_carry_n_2,
      CO(3) => \NLW_last_sect_carry__0_CO_UNCONNECTED\(3),
      CO(2) => last_sect,
      CO(1) => \last_sect_carry__0_n_4\,
      CO(0) => \last_sect_carry__0_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_last_sect_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => '0',
      S(2) => fifo_wreq_n_42,
      S(1) => fifo_wreq_n_43,
      S(0) => fifo_wreq_n_44
    );
next_resp_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => next_resp0,
      Q => next_resp,
      R => SR(0)
    );
rs_wreq: entity work.design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_reg_slice
     port map (
      Q(2 downto 0) => Q(3 downto 1),
      SR(0) => SR(0),
      \ap_CS_fsm_reg[9]\ => \ap_CS_fsm_reg[9]\,
      ap_clk => ap_clk,
      ap_reg_ioackin_gmem_WREADY => ap_reg_ioackin_gmem_WREADY,
      \data_p1_reg[29]_0\(29 downto 0) => rs2f_wreq_data(29 downto 0),
      \data_p2_reg[29]_0\(29 downto 0) => \data_p2_reg[29]\(29 downto 0),
      gmem_WREADY => gmem_WREADY,
      push => push_1,
      rs2f_wreq_ack => rs2f_wreq_ack,
      s_ready_t_reg_0(1 downto 0) => \ap_CS_fsm_reg[15]\(2 downto 1),
      \state_reg[0]_0\(0) => rs2f_wreq_valid
    );
\sect_addr_buf[10]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => first_sect,
      I1 => start_addr_buf(10),
      O => sect_addr(10)
    );
\sect_addr_buf[11]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => first_sect,
      I1 => start_addr_buf(11),
      O => sect_addr(11)
    );
\sect_addr_buf[12]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => start_addr_buf(12),
      I1 => first_sect,
      I2 => sect_cnt(0),
      O => sect_addr(12)
    );
\sect_addr_buf[13]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => start_addr_buf(13),
      I1 => first_sect,
      I2 => sect_cnt(1),
      O => sect_addr(13)
    );
\sect_addr_buf[14]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => start_addr_buf(14),
      I1 => first_sect,
      I2 => sect_cnt(2),
      O => sect_addr(14)
    );
\sect_addr_buf[15]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => start_addr_buf(15),
      I1 => first_sect,
      I2 => sect_cnt(3),
      O => sect_addr(15)
    );
\sect_addr_buf[16]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => start_addr_buf(16),
      I1 => first_sect,
      I2 => sect_cnt(4),
      O => sect_addr(16)
    );
\sect_addr_buf[17]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => start_addr_buf(17),
      I1 => first_sect,
      I2 => sect_cnt(5),
      O => sect_addr(17)
    );
\sect_addr_buf[18]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => start_addr_buf(18),
      I1 => first_sect,
      I2 => sect_cnt(6),
      O => sect_addr(18)
    );
\sect_addr_buf[19]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => start_addr_buf(19),
      I1 => first_sect,
      I2 => sect_cnt(7),
      O => sect_addr(19)
    );
\sect_addr_buf[20]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => start_addr_buf(20),
      I1 => first_sect,
      I2 => sect_cnt(8),
      O => sect_addr(20)
    );
\sect_addr_buf[21]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => start_addr_buf(21),
      I1 => first_sect,
      I2 => sect_cnt(9),
      O => sect_addr(21)
    );
\sect_addr_buf[22]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => start_addr_buf(22),
      I1 => first_sect,
      I2 => sect_cnt(10),
      O => sect_addr(22)
    );
\sect_addr_buf[23]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => start_addr_buf(23),
      I1 => first_sect,
      I2 => sect_cnt(11),
      O => sect_addr(23)
    );
\sect_addr_buf[24]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => start_addr_buf(24),
      I1 => first_sect,
      I2 => sect_cnt(12),
      O => sect_addr(24)
    );
\sect_addr_buf[25]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => start_addr_buf(25),
      I1 => first_sect,
      I2 => sect_cnt(13),
      O => sect_addr(25)
    );
\sect_addr_buf[26]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => start_addr_buf(26),
      I1 => first_sect,
      I2 => sect_cnt(14),
      O => sect_addr(26)
    );
\sect_addr_buf[27]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => start_addr_buf(27),
      I1 => first_sect,
      I2 => sect_cnt(15),
      O => sect_addr(27)
    );
\sect_addr_buf[28]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => start_addr_buf(28),
      I1 => first_sect,
      I2 => sect_cnt(16),
      O => sect_addr(28)
    );
\sect_addr_buf[29]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => start_addr_buf(29),
      I1 => first_sect,
      I2 => sect_cnt(17),
      O => sect_addr(29)
    );
\sect_addr_buf[2]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => first_sect,
      I1 => start_addr_buf(2),
      O => sect_addr(2)
    );
\sect_addr_buf[30]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => start_addr_buf(30),
      I1 => first_sect,
      I2 => sect_cnt(18),
      O => sect_addr(30)
    );
\sect_addr_buf[31]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => start_addr_buf(31),
      I1 => first_sect,
      I2 => sect_cnt(19),
      O => sect_addr(31)
    );
\sect_addr_buf[3]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => first_sect,
      I1 => start_addr_buf(3),
      O => sect_addr(3)
    );
\sect_addr_buf[4]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => first_sect,
      I1 => start_addr_buf(4),
      O => sect_addr(4)
    );
\sect_addr_buf[5]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => first_sect,
      I1 => start_addr_buf(5),
      O => sect_addr(5)
    );
\sect_addr_buf[6]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => first_sect,
      I1 => start_addr_buf(6),
      O => sect_addr(6)
    );
\sect_addr_buf[7]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => first_sect,
      I1 => start_addr_buf(7),
      O => sect_addr(7)
    );
\sect_addr_buf[8]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => first_sect,
      I1 => start_addr_buf(8),
      O => sect_addr(8)
    );
\sect_addr_buf[9]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => first_sect,
      I1 => start_addr_buf(9),
      O => sect_addr(9)
    );
\sect_addr_buf_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => sect_addr(10),
      Q => \sect_addr_buf_reg_n_2_[10]\,
      R => \bus_equal_gen.fifo_burst_n_38\
    );
\sect_addr_buf_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => sect_addr(11),
      Q => \sect_addr_buf_reg_n_2_[11]\,
      R => \bus_equal_gen.fifo_burst_n_38\
    );
\sect_addr_buf_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => sect_addr(12),
      Q => \sect_addr_buf_reg_n_2_[12]\,
      R => SR(0)
    );
\sect_addr_buf_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => sect_addr(13),
      Q => \sect_addr_buf_reg_n_2_[13]\,
      R => SR(0)
    );
\sect_addr_buf_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => sect_addr(14),
      Q => \sect_addr_buf_reg_n_2_[14]\,
      R => SR(0)
    );
\sect_addr_buf_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => sect_addr(15),
      Q => \sect_addr_buf_reg_n_2_[15]\,
      R => SR(0)
    );
\sect_addr_buf_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => sect_addr(16),
      Q => \sect_addr_buf_reg_n_2_[16]\,
      R => SR(0)
    );
\sect_addr_buf_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => sect_addr(17),
      Q => \sect_addr_buf_reg_n_2_[17]\,
      R => SR(0)
    );
\sect_addr_buf_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => sect_addr(18),
      Q => \sect_addr_buf_reg_n_2_[18]\,
      R => SR(0)
    );
\sect_addr_buf_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => sect_addr(19),
      Q => \sect_addr_buf_reg_n_2_[19]\,
      R => SR(0)
    );
\sect_addr_buf_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => sect_addr(20),
      Q => \sect_addr_buf_reg_n_2_[20]\,
      R => SR(0)
    );
\sect_addr_buf_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => sect_addr(21),
      Q => \sect_addr_buf_reg_n_2_[21]\,
      R => SR(0)
    );
\sect_addr_buf_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => sect_addr(22),
      Q => \sect_addr_buf_reg_n_2_[22]\,
      R => SR(0)
    );
\sect_addr_buf_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => sect_addr(23),
      Q => \sect_addr_buf_reg_n_2_[23]\,
      R => SR(0)
    );
\sect_addr_buf_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => sect_addr(24),
      Q => \sect_addr_buf_reg_n_2_[24]\,
      R => SR(0)
    );
\sect_addr_buf_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => sect_addr(25),
      Q => \sect_addr_buf_reg_n_2_[25]\,
      R => SR(0)
    );
\sect_addr_buf_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => sect_addr(26),
      Q => \sect_addr_buf_reg_n_2_[26]\,
      R => SR(0)
    );
\sect_addr_buf_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => sect_addr(27),
      Q => \sect_addr_buf_reg_n_2_[27]\,
      R => SR(0)
    );
\sect_addr_buf_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => sect_addr(28),
      Q => \sect_addr_buf_reg_n_2_[28]\,
      R => SR(0)
    );
\sect_addr_buf_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => sect_addr(29),
      Q => \sect_addr_buf_reg_n_2_[29]\,
      R => SR(0)
    );
\sect_addr_buf_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => sect_addr(2),
      Q => \sect_addr_buf_reg_n_2_[2]\,
      R => \bus_equal_gen.fifo_burst_n_38\
    );
\sect_addr_buf_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => sect_addr(30),
      Q => \sect_addr_buf_reg_n_2_[30]\,
      R => SR(0)
    );
\sect_addr_buf_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => sect_addr(31),
      Q => \sect_addr_buf_reg_n_2_[31]\,
      R => SR(0)
    );
\sect_addr_buf_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => sect_addr(3),
      Q => \sect_addr_buf_reg_n_2_[3]\,
      R => \bus_equal_gen.fifo_burst_n_38\
    );
\sect_addr_buf_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => sect_addr(4),
      Q => \sect_addr_buf_reg_n_2_[4]\,
      R => \bus_equal_gen.fifo_burst_n_38\
    );
\sect_addr_buf_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => sect_addr(5),
      Q => \sect_addr_buf_reg_n_2_[5]\,
      R => \bus_equal_gen.fifo_burst_n_38\
    );
\sect_addr_buf_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => sect_addr(6),
      Q => \sect_addr_buf_reg_n_2_[6]\,
      R => \bus_equal_gen.fifo_burst_n_38\
    );
\sect_addr_buf_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => sect_addr(7),
      Q => \sect_addr_buf_reg_n_2_[7]\,
      R => \bus_equal_gen.fifo_burst_n_38\
    );
\sect_addr_buf_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => sect_addr(8),
      Q => \sect_addr_buf_reg_n_2_[8]\,
      R => \bus_equal_gen.fifo_burst_n_38\
    );
\sect_addr_buf_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => sect_addr(9),
      Q => \sect_addr_buf_reg_n_2_[9]\,
      R => \bus_equal_gen.fifo_burst_n_38\
    );
sect_cnt0_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => sect_cnt0_carry_n_2,
      CO(2) => sect_cnt0_carry_n_3,
      CO(1) => sect_cnt0_carry_n_4,
      CO(0) => sect_cnt0_carry_n_5,
      CYINIT => sect_cnt(0),
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => sect_cnt0(4 downto 1),
      S(3 downto 0) => sect_cnt(4 downto 1)
    );
\sect_cnt0_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => sect_cnt0_carry_n_2,
      CO(3) => \sect_cnt0_carry__0_n_2\,
      CO(2) => \sect_cnt0_carry__0_n_3\,
      CO(1) => \sect_cnt0_carry__0_n_4\,
      CO(0) => \sect_cnt0_carry__0_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => sect_cnt0(8 downto 5),
      S(3 downto 0) => sect_cnt(8 downto 5)
    );
\sect_cnt0_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \sect_cnt0_carry__0_n_2\,
      CO(3) => \sect_cnt0_carry__1_n_2\,
      CO(2) => \sect_cnt0_carry__1_n_3\,
      CO(1) => \sect_cnt0_carry__1_n_4\,
      CO(0) => \sect_cnt0_carry__1_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => sect_cnt0(12 downto 9),
      S(3 downto 0) => sect_cnt(12 downto 9)
    );
\sect_cnt0_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \sect_cnt0_carry__1_n_2\,
      CO(3) => \sect_cnt0_carry__2_n_2\,
      CO(2) => \sect_cnt0_carry__2_n_3\,
      CO(1) => \sect_cnt0_carry__2_n_4\,
      CO(0) => \sect_cnt0_carry__2_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => sect_cnt0(16 downto 13),
      S(3 downto 0) => sect_cnt(16 downto 13)
    );
\sect_cnt0_carry__3\: unisim.vcomponents.CARRY4
     port map (
      CI => \sect_cnt0_carry__2_n_2\,
      CO(3 downto 2) => \NLW_sect_cnt0_carry__3_CO_UNCONNECTED\(3 downto 2),
      CO(1) => \sect_cnt0_carry__3_n_4\,
      CO(0) => \sect_cnt0_carry__3_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \NLW_sect_cnt0_carry__3_O_UNCONNECTED\(3),
      O(2 downto 0) => sect_cnt0(19 downto 17),
      S(3) => '0',
      S(2 downto 0) => sect_cnt(19 downto 17)
    );
\sect_cnt_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_wreq_n_46,
      D => \bus_equal_gen.fifo_burst_n_26\,
      Q => sect_cnt(0),
      R => SR(0)
    );
\sect_cnt_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_wreq_n_46,
      D => \bus_equal_gen.fifo_burst_n_16\,
      Q => sect_cnt(10),
      R => SR(0)
    );
\sect_cnt_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_wreq_n_46,
      D => \bus_equal_gen.fifo_burst_n_15\,
      Q => sect_cnt(11),
      R => SR(0)
    );
\sect_cnt_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_wreq_n_46,
      D => \bus_equal_gen.fifo_burst_n_14\,
      Q => sect_cnt(12),
      R => SR(0)
    );
\sect_cnt_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_wreq_n_46,
      D => \bus_equal_gen.fifo_burst_n_13\,
      Q => sect_cnt(13),
      R => SR(0)
    );
\sect_cnt_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_wreq_n_46,
      D => \bus_equal_gen.fifo_burst_n_12\,
      Q => sect_cnt(14),
      R => SR(0)
    );
\sect_cnt_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_wreq_n_46,
      D => \bus_equal_gen.fifo_burst_n_11\,
      Q => sect_cnt(15),
      R => SR(0)
    );
\sect_cnt_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_wreq_n_46,
      D => \bus_equal_gen.fifo_burst_n_10\,
      Q => sect_cnt(16),
      R => SR(0)
    );
\sect_cnt_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_wreq_n_46,
      D => \bus_equal_gen.fifo_burst_n_9\,
      Q => sect_cnt(17),
      R => SR(0)
    );
\sect_cnt_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_wreq_n_46,
      D => \bus_equal_gen.fifo_burst_n_8\,
      Q => sect_cnt(18),
      R => SR(0)
    );
\sect_cnt_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_wreq_n_46,
      D => \bus_equal_gen.fifo_burst_n_7\,
      Q => sect_cnt(19),
      R => SR(0)
    );
\sect_cnt_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_wreq_n_46,
      D => \bus_equal_gen.fifo_burst_n_25\,
      Q => sect_cnt(1),
      R => SR(0)
    );
\sect_cnt_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_wreq_n_46,
      D => \bus_equal_gen.fifo_burst_n_24\,
      Q => sect_cnt(2),
      R => SR(0)
    );
\sect_cnt_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_wreq_n_46,
      D => \bus_equal_gen.fifo_burst_n_23\,
      Q => sect_cnt(3),
      R => SR(0)
    );
\sect_cnt_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_wreq_n_46,
      D => \bus_equal_gen.fifo_burst_n_22\,
      Q => sect_cnt(4),
      R => SR(0)
    );
\sect_cnt_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_wreq_n_46,
      D => \bus_equal_gen.fifo_burst_n_21\,
      Q => sect_cnt(5),
      R => SR(0)
    );
\sect_cnt_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_wreq_n_46,
      D => \bus_equal_gen.fifo_burst_n_20\,
      Q => sect_cnt(6),
      R => SR(0)
    );
\sect_cnt_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_wreq_n_46,
      D => \bus_equal_gen.fifo_burst_n_19\,
      Q => sect_cnt(7),
      R => SR(0)
    );
\sect_cnt_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_wreq_n_46,
      D => \bus_equal_gen.fifo_burst_n_18\,
      Q => sect_cnt(8),
      R => SR(0)
    );
\sect_cnt_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => fifo_wreq_n_46,
      D => \bus_equal_gen.fifo_burst_n_17\,
      Q => sect_cnt(9),
      R => SR(0)
    );
\sect_len_buf[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"CC0FAAFF"
    )
        port map (
      I0 => \end_addr_buf_reg_n_2_[2]\,
      I1 => beat_len_buf(0),
      I2 => start_addr_buf(2),
      I3 => last_sect,
      I4 => first_sect,
      O => \sect_len_buf[0]_i_1_n_2\
    );
\sect_len_buf[1]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"AA0FCCFF"
    )
        port map (
      I0 => beat_len_buf(1),
      I1 => \end_addr_buf_reg_n_2_[3]\,
      I2 => start_addr_buf(3),
      I3 => last_sect,
      I4 => first_sect,
      O => \sect_len_buf[1]_i_1_n_2\
    );
\sect_len_buf[2]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F033AAFF"
    )
        port map (
      I0 => \end_addr_buf_reg_n_2_[4]\,
      I1 => start_addr_buf(4),
      I2 => beat_len_buf(3),
      I3 => last_sect,
      I4 => first_sect,
      O => \sect_len_buf[2]_i_1_n_2\
    );
\sect_len_buf[3]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F033AAFF"
    )
        port map (
      I0 => \end_addr_buf_reg_n_2_[5]\,
      I1 => start_addr_buf(5),
      I2 => beat_len_buf(3),
      I3 => last_sect,
      I4 => first_sect,
      O => \sect_len_buf[3]_i_1_n_2\
    );
\sect_len_buf[4]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F033AAFF"
    )
        port map (
      I0 => \end_addr_buf_reg_n_2_[6]\,
      I1 => start_addr_buf(6),
      I2 => beat_len_buf(3),
      I3 => last_sect,
      I4 => first_sect,
      O => \sect_len_buf[4]_i_1_n_2\
    );
\sect_len_buf[5]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F033AAFF"
    )
        port map (
      I0 => \end_addr_buf_reg_n_2_[7]\,
      I1 => start_addr_buf(7),
      I2 => beat_len_buf(3),
      I3 => last_sect,
      I4 => first_sect,
      O => \sect_len_buf[5]_i_1_n_2\
    );
\sect_len_buf[6]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F033AAFF"
    )
        port map (
      I0 => \end_addr_buf_reg_n_2_[8]\,
      I1 => start_addr_buf(8),
      I2 => beat_len_buf(3),
      I3 => last_sect,
      I4 => first_sect,
      O => \sect_len_buf[6]_i_1_n_2\
    );
\sect_len_buf[7]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F033AAFF"
    )
        port map (
      I0 => \end_addr_buf_reg_n_2_[9]\,
      I1 => start_addr_buf(9),
      I2 => beat_len_buf(3),
      I3 => last_sect,
      I4 => first_sect,
      O => \sect_len_buf[7]_i_1_n_2\
    );
\sect_len_buf[8]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F033AAFF"
    )
        port map (
      I0 => \end_addr_buf_reg_n_2_[10]\,
      I1 => start_addr_buf(10),
      I2 => beat_len_buf(3),
      I3 => last_sect,
      I4 => first_sect,
      O => \sect_len_buf[8]_i_1_n_2\
    );
\sect_len_buf[9]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"AA0FCCFF"
    )
        port map (
      I0 => beat_len_buf(3),
      I1 => \end_addr_buf_reg_n_2_[11]\,
      I2 => start_addr_buf(11),
      I3 => last_sect,
      I4 => first_sect,
      O => \sect_len_buf[9]_i_2_n_2\
    );
\sect_len_buf_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => \sect_len_buf[0]_i_1_n_2\,
      Q => \sect_len_buf_reg_n_2_[0]\,
      R => SR(0)
    );
\sect_len_buf_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => \sect_len_buf[1]_i_1_n_2\,
      Q => \sect_len_buf_reg_n_2_[1]\,
      R => SR(0)
    );
\sect_len_buf_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => \sect_len_buf[2]_i_1_n_2\,
      Q => \sect_len_buf_reg_n_2_[2]\,
      R => SR(0)
    );
\sect_len_buf_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => \sect_len_buf[3]_i_1_n_2\,
      Q => \sect_len_buf_reg_n_2_[3]\,
      R => SR(0)
    );
\sect_len_buf_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => \sect_len_buf[4]_i_1_n_2\,
      Q => sect_len_buf(4),
      R => SR(0)
    );
\sect_len_buf_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => \sect_len_buf[5]_i_1_n_2\,
      Q => sect_len_buf(5),
      R => SR(0)
    );
\sect_len_buf_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => \sect_len_buf[6]_i_1_n_2\,
      Q => sect_len_buf(6),
      R => SR(0)
    );
\sect_len_buf_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => \sect_len_buf[7]_i_1_n_2\,
      Q => sect_len_buf(7),
      R => SR(0)
    );
\sect_len_buf_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => \sect_len_buf[8]_i_1_n_2\,
      Q => sect_len_buf(8),
      R => SR(0)
    );
\sect_len_buf_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => p_26_in,
      D => \sect_len_buf[9]_i_2_n_2\,
      Q => sect_len_buf(9),
      R => SR(0)
    );
\start_addr_buf_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => \start_addr_reg_n_2_[10]\,
      Q => start_addr_buf(10),
      R => SR(0)
    );
\start_addr_buf_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => \start_addr_reg_n_2_[11]\,
      Q => start_addr_buf(11),
      R => SR(0)
    );
\start_addr_buf_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => \start_addr_reg_n_2_[12]\,
      Q => start_addr_buf(12),
      R => SR(0)
    );
\start_addr_buf_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => \start_addr_reg_n_2_[13]\,
      Q => start_addr_buf(13),
      R => SR(0)
    );
\start_addr_buf_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => \start_addr_reg_n_2_[14]\,
      Q => start_addr_buf(14),
      R => SR(0)
    );
\start_addr_buf_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => \start_addr_reg_n_2_[15]\,
      Q => start_addr_buf(15),
      R => SR(0)
    );
\start_addr_buf_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => \start_addr_reg_n_2_[16]\,
      Q => start_addr_buf(16),
      R => SR(0)
    );
\start_addr_buf_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => \start_addr_reg_n_2_[17]\,
      Q => start_addr_buf(17),
      R => SR(0)
    );
\start_addr_buf_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => \start_addr_reg_n_2_[18]\,
      Q => start_addr_buf(18),
      R => SR(0)
    );
\start_addr_buf_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => \start_addr_reg_n_2_[19]\,
      Q => start_addr_buf(19),
      R => SR(0)
    );
\start_addr_buf_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => \start_addr_reg_n_2_[20]\,
      Q => start_addr_buf(20),
      R => SR(0)
    );
\start_addr_buf_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => \start_addr_reg_n_2_[21]\,
      Q => start_addr_buf(21),
      R => SR(0)
    );
\start_addr_buf_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => \start_addr_reg_n_2_[22]\,
      Q => start_addr_buf(22),
      R => SR(0)
    );
\start_addr_buf_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => \start_addr_reg_n_2_[23]\,
      Q => start_addr_buf(23),
      R => SR(0)
    );
\start_addr_buf_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => \start_addr_reg_n_2_[24]\,
      Q => start_addr_buf(24),
      R => SR(0)
    );
\start_addr_buf_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => \start_addr_reg_n_2_[25]\,
      Q => start_addr_buf(25),
      R => SR(0)
    );
\start_addr_buf_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => \start_addr_reg_n_2_[26]\,
      Q => start_addr_buf(26),
      R => SR(0)
    );
\start_addr_buf_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => \start_addr_reg_n_2_[27]\,
      Q => start_addr_buf(27),
      R => SR(0)
    );
\start_addr_buf_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => \start_addr_reg_n_2_[28]\,
      Q => start_addr_buf(28),
      R => SR(0)
    );
\start_addr_buf_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => \start_addr_reg_n_2_[29]\,
      Q => start_addr_buf(29),
      R => SR(0)
    );
\start_addr_buf_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => \start_addr_reg_n_2_[2]\,
      Q => start_addr_buf(2),
      R => SR(0)
    );
\start_addr_buf_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => \start_addr_reg_n_2_[30]\,
      Q => start_addr_buf(30),
      R => SR(0)
    );
\start_addr_buf_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => \start_addr_reg_n_2_[31]\,
      Q => start_addr_buf(31),
      R => SR(0)
    );
\start_addr_buf_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => \start_addr_reg_n_2_[3]\,
      Q => start_addr_buf(3),
      R => SR(0)
    );
\start_addr_buf_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => \start_addr_reg_n_2_[4]\,
      Q => start_addr_buf(4),
      R => SR(0)
    );
\start_addr_buf_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => \start_addr_reg_n_2_[5]\,
      Q => start_addr_buf(5),
      R => SR(0)
    );
\start_addr_buf_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => \start_addr_reg_n_2_[6]\,
      Q => start_addr_buf(6),
      R => SR(0)
    );
\start_addr_buf_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => \start_addr_reg_n_2_[7]\,
      Q => start_addr_buf(7),
      R => SR(0)
    );
\start_addr_buf_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => \start_addr_reg_n_2_[8]\,
      Q => start_addr_buf(8),
      R => SR(0)
    );
\start_addr_buf_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => next_wreq,
      D => \start_addr_reg_n_2_[9]\,
      Q => start_addr_buf(9),
      R => SR(0)
    );
\start_addr_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len0_0,
      D => fifo_wreq_n_29,
      Q => \start_addr_reg_n_2_[10]\,
      R => SR(0)
    );
\start_addr_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len0_0,
      D => fifo_wreq_n_28,
      Q => \start_addr_reg_n_2_[11]\,
      R => SR(0)
    );
\start_addr_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len0_0,
      D => fifo_wreq_n_27,
      Q => \start_addr_reg_n_2_[12]\,
      R => SR(0)
    );
\start_addr_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len0_0,
      D => fifo_wreq_n_26,
      Q => \start_addr_reg_n_2_[13]\,
      R => SR(0)
    );
\start_addr_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len0_0,
      D => fifo_wreq_n_25,
      Q => \start_addr_reg_n_2_[14]\,
      R => SR(0)
    );
\start_addr_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len0_0,
      D => fifo_wreq_n_24,
      Q => \start_addr_reg_n_2_[15]\,
      R => SR(0)
    );
\start_addr_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len0_0,
      D => fifo_wreq_n_23,
      Q => \start_addr_reg_n_2_[16]\,
      R => SR(0)
    );
\start_addr_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len0_0,
      D => fifo_wreq_n_22,
      Q => \start_addr_reg_n_2_[17]\,
      R => SR(0)
    );
\start_addr_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len0_0,
      D => fifo_wreq_n_21,
      Q => \start_addr_reg_n_2_[18]\,
      R => SR(0)
    );
\start_addr_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len0_0,
      D => fifo_wreq_n_20,
      Q => \start_addr_reg_n_2_[19]\,
      R => SR(0)
    );
\start_addr_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len0_0,
      D => fifo_wreq_n_19,
      Q => \start_addr_reg_n_2_[20]\,
      R => SR(0)
    );
\start_addr_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len0_0,
      D => fifo_wreq_n_18,
      Q => \start_addr_reg_n_2_[21]\,
      R => SR(0)
    );
\start_addr_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len0_0,
      D => fifo_wreq_n_17,
      Q => \start_addr_reg_n_2_[22]\,
      R => SR(0)
    );
\start_addr_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len0_0,
      D => fifo_wreq_n_16,
      Q => \start_addr_reg_n_2_[23]\,
      R => SR(0)
    );
\start_addr_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len0_0,
      D => fifo_wreq_n_15,
      Q => \start_addr_reg_n_2_[24]\,
      R => SR(0)
    );
\start_addr_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len0_0,
      D => fifo_wreq_n_14,
      Q => \start_addr_reg_n_2_[25]\,
      R => SR(0)
    );
\start_addr_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len0_0,
      D => fifo_wreq_n_13,
      Q => \start_addr_reg_n_2_[26]\,
      R => SR(0)
    );
\start_addr_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len0_0,
      D => fifo_wreq_n_12,
      Q => \start_addr_reg_n_2_[27]\,
      R => SR(0)
    );
\start_addr_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len0_0,
      D => fifo_wreq_n_11,
      Q => \start_addr_reg_n_2_[28]\,
      R => SR(0)
    );
\start_addr_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len0_0,
      D => fifo_wreq_n_10,
      Q => \start_addr_reg_n_2_[29]\,
      R => SR(0)
    );
\start_addr_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len0_0,
      D => fifo_wreq_n_37,
      Q => \start_addr_reg_n_2_[2]\,
      R => SR(0)
    );
\start_addr_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len0_0,
      D => fifo_wreq_n_9,
      Q => \start_addr_reg_n_2_[30]\,
      R => SR(0)
    );
\start_addr_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len0_0,
      D => fifo_wreq_n_8,
      Q => \start_addr_reg_n_2_[31]\,
      R => SR(0)
    );
\start_addr_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len0_0,
      D => fifo_wreq_n_36,
      Q => \start_addr_reg_n_2_[3]\,
      R => SR(0)
    );
\start_addr_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len0_0,
      D => fifo_wreq_n_35,
      Q => \start_addr_reg_n_2_[4]\,
      R => SR(0)
    );
\start_addr_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len0_0,
      D => fifo_wreq_n_34,
      Q => \start_addr_reg_n_2_[5]\,
      R => SR(0)
    );
\start_addr_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len0_0,
      D => fifo_wreq_n_33,
      Q => \start_addr_reg_n_2_[6]\,
      R => SR(0)
    );
\start_addr_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len0_0,
      D => fifo_wreq_n_32,
      Q => \start_addr_reg_n_2_[7]\,
      R => SR(0)
    );
\start_addr_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len0_0,
      D => fifo_wreq_n_31,
      Q => \start_addr_reg_n_2_[8]\,
      R => SR(0)
    );
\start_addr_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => align_len0_0,
      D => fifo_wreq_n_30,
      Q => \start_addr_reg_n_2_[9]\,
      R => SR(0)
    );
\throttl_cnt[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8B"
    )
        port map (
      I0 => \^could_multi_bursts.awlen_buf_reg[3]_0\(0),
      I1 => \^could_multi_bursts.awvalid_dummy_reg_0\,
      I2 => \throttl_cnt_reg[0]_0\(0),
      O => D(0)
    );
\throttl_cnt[7]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"EAAA"
    )
        port map (
      I0 => \^could_multi_bursts.awvalid_dummy_reg_0\,
      I1 => m_axi_gmem_WREADY,
      I2 => \^bus_equal_gen.wvalid_dummy_reg_0\,
      I3 => \throttl_cnt_reg[0]\,
      O => E(0)
    );
\throttl_cnt[7]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8888888888888880"
    )
        port map (
      I0 => \could_multi_bursts.AWVALID_Dummy_reg_1\,
      I1 => \^awvalid_dummy\,
      I2 => \^could_multi_bursts.awlen_buf_reg[3]_0\(0),
      I3 => \^could_multi_bursts.awlen_buf_reg[3]_0\(1),
      I4 => \^could_multi_bursts.awlen_buf_reg[3]_0\(2),
      I5 => \^could_multi_bursts.awlen_buf_reg[3]_0\(3),
      O => \^could_multi_bursts.awvalid_dummy_reg_0\
    );
wreq_handling_reg: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => \bus_equal_gen.fifo_burst_n_33\,
      Q => wreq_handling_reg_n_2,
      R => SR(0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi is
  port (
    full_n_reg : out STD_LOGIC;
    SR : out STD_LOGIC_VECTOR ( 0 to 0 );
    full_n_reg_0 : out STD_LOGIC;
    gmem_BVALID : out STD_LOGIC;
    \bus_equal_gen.WVALID_Dummy_reg\ : out STD_LOGIC;
    m_axi_gmem_WLAST : out STD_LOGIC;
    \could_multi_bursts.ARVALID_Dummy_reg\ : out STD_LOGIC;
    \state_reg[0]\ : out STD_LOGIC;
    \ap_CS_fsm_reg[7]\ : out STD_LOGIC;
    \ap_CS_fsm_reg[15]\ : out STD_LOGIC_VECTOR ( 6 downto 0 );
    ap_done : out STD_LOGIC;
    m_axi_gmem_AWVALID : out STD_LOGIC;
    \could_multi_bursts.awlen_buf_reg[3]\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    i_reg_137 : out STD_LOGIC;
    i_reg_1370 : out STD_LOGIC;
    E : out STD_LOGIC_VECTOR ( 0 to 0 );
    sum_reg_125 : out STD_LOGIC;
    sum_reg_1250 : out STD_LOGIC;
    \ap_CS_fsm_reg[8]\ : out STD_LOGIC;
    \ap_CS_fsm_reg[10]\ : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axi_gmem_AWADDR : out STD_LOGIC_VECTOR ( 29 downto 0 );
    m_axi_gmem_ARADDR : out STD_LOGIC_VECTOR ( 29 downto 0 );
    \ap_CS_fsm_reg[8]_0\ : out STD_LOGIC;
    \ap_CS_fsm_reg[8]_1\ : out STD_LOGIC;
    \could_multi_bursts.arlen_buf_reg[3]\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_gmem_WDATA : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_gmem_WSTRB : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \data_p1_reg[31]\ : out STD_LOGIC_VECTOR ( 31 downto 0 );
    ap_clk : in STD_LOGIC;
    D : in STD_LOGIC_VECTOR ( 32 downto 0 );
    m_axi_gmem_RRESP : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_gmem_RVALID : in STD_LOGIC;
    ap_rst_n : in STD_LOGIC;
    m_axi_gmem_ARREADY : in STD_LOGIC;
    CO : in STD_LOGIC_VECTOR ( 0 to 0 );
    ap_enable_reg_pp0_iter1_reg : in STD_LOGIC;
    ap_enable_reg_pp0_iter1_reg_0 : in STD_LOGIC;
    ap_enable_reg_pp0_iter0 : in STD_LOGIC;
    Q : in STD_LOGIC_VECTOR ( 8 downto 0 );
    ap_enable_reg_pp0_iter2_reg : in STD_LOGIC;
    ap_start : in STD_LOGIC;
    m_axi_gmem_WREADY : in STD_LOGIC;
    m_axi_gmem_AWREADY : in STD_LOGIC;
    ap_reg_ioackin_gmem_WREADY : in STD_LOGIC;
    m_axi_gmem_BVALID : in STD_LOGIC;
    \ap_CS_fsm_reg[9]\ : in STD_LOGIC;
    exitcond_reg_251_pp0_iter1_reg : in STD_LOGIC;
    \data_p2_reg[29]\ : in STD_LOGIC_VECTOR ( 29 downto 0 );
    \data_p2_reg[63]\ : in STD_LOGIC_VECTOR ( 61 downto 0 );
    mem_reg : in STD_LOGIC_VECTOR ( 31 downto 0 );
    \out\ : in STD_LOGIC_VECTOR ( 31 downto 0 )
  );
end design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi;

architecture STRUCTURE of design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi is
  signal AWVALID_Dummy : STD_LOGIC;
  signal \^sr\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \buff_rdata/usedw_reg\ : STD_LOGIC_VECTOR ( 5 downto 0 );
  signal \buff_wdata/usedw_reg\ : STD_LOGIC_VECTOR ( 5 downto 0 );
  signal bus_read_n_20 : STD_LOGIC;
  signal bus_read_n_51 : STD_LOGIC;
  signal bus_read_n_52 : STD_LOGIC;
  signal bus_read_n_53 : STD_LOGIC;
  signal bus_read_n_54 : STD_LOGIC;
  signal bus_read_n_57 : STD_LOGIC;
  signal bus_read_n_58 : STD_LOGIC;
  signal bus_read_n_59 : STD_LOGIC;
  signal bus_write_n_14 : STD_LOGIC;
  signal bus_write_n_15 : STD_LOGIC;
  signal bus_write_n_28 : STD_LOGIC;
  signal bus_write_n_59 : STD_LOGIC;
  signal bus_write_n_60 : STD_LOGIC;
  signal bus_write_n_61 : STD_LOGIC;
  signal bus_write_n_62 : STD_LOGIC;
  signal bus_write_n_63 : STD_LOGIC;
  signal bus_write_n_64 : STD_LOGIC;
  signal bus_write_n_65 : STD_LOGIC;
  signal \^could_multi_bursts.awlen_buf_reg[3]\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal p_0_in : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \p_0_out__18_carry__0_n_4\ : STD_LOGIC;
  signal \p_0_out__18_carry__0_n_5\ : STD_LOGIC;
  signal \p_0_out__18_carry__0_n_7\ : STD_LOGIC;
  signal \p_0_out__18_carry__0_n_8\ : STD_LOGIC;
  signal \p_0_out__18_carry__0_n_9\ : STD_LOGIC;
  signal \p_0_out__18_carry_n_2\ : STD_LOGIC;
  signal \p_0_out__18_carry_n_3\ : STD_LOGIC;
  signal \p_0_out__18_carry_n_4\ : STD_LOGIC;
  signal \p_0_out__18_carry_n_5\ : STD_LOGIC;
  signal \p_0_out__18_carry_n_6\ : STD_LOGIC;
  signal \p_0_out__18_carry_n_7\ : STD_LOGIC;
  signal \p_0_out__18_carry_n_8\ : STD_LOGIC;
  signal \p_0_out__18_carry_n_9\ : STD_LOGIC;
  signal \p_0_out_carry__0_n_4\ : STD_LOGIC;
  signal \p_0_out_carry__0_n_5\ : STD_LOGIC;
  signal \p_0_out_carry__0_n_7\ : STD_LOGIC;
  signal \p_0_out_carry__0_n_8\ : STD_LOGIC;
  signal \p_0_out_carry__0_n_9\ : STD_LOGIC;
  signal p_0_out_carry_n_2 : STD_LOGIC;
  signal p_0_out_carry_n_3 : STD_LOGIC;
  signal p_0_out_carry_n_4 : STD_LOGIC;
  signal p_0_out_carry_n_5 : STD_LOGIC;
  signal p_0_out_carry_n_6 : STD_LOGIC;
  signal p_0_out_carry_n_7 : STD_LOGIC;
  signal p_0_out_carry_n_8 : STD_LOGIC;
  signal p_0_out_carry_n_9 : STD_LOGIC;
  signal throttl_cnt_reg : STD_LOGIC_VECTOR ( 0 to 0 );
  signal wreq_throttl_n_4 : STD_LOGIC;
  signal wreq_throttl_n_5 : STD_LOGIC;
  signal wreq_throttl_n_6 : STD_LOGIC;
  signal wreq_throttl_n_7 : STD_LOGIC;
  signal \NLW_p_0_out__18_carry__0_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal \NLW_p_0_out__18_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_p_0_out_carry__0_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal \NLW_p_0_out_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  attribute METHODOLOGY_DRC_VIOS : string;
  attribute METHODOLOGY_DRC_VIOS of \p_0_out__18_carry\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \p_0_out__18_carry__0\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of p_0_out_carry : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \p_0_out_carry__0\ : label is "{SYNTH-8 {cell *THIS*}}";
begin
  SR(0) <= \^sr\(0);
  \could_multi_bursts.awlen_buf_reg[3]\(3 downto 0) <= \^could_multi_bursts.awlen_buf_reg[3]\(3 downto 0);
bus_read: entity work.design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_read
     port map (
      CO(0) => CO(0),
      D(32 downto 0) => D(32 downto 0),
      DI(0) => bus_read_n_20,
      E(0) => \ap_CS_fsm_reg[15]\(1),
      Q(2 downto 0) => Q(3 downto 1),
      S(3) => bus_read_n_51,
      S(2) => bus_read_n_52,
      S(1) => bus_read_n_53,
      S(0) => bus_read_n_54,
      SR(0) => \^sr\(0),
      \ap_CS_fsm_reg[7]\ => \ap_CS_fsm_reg[7]\,
      \ap_CS_fsm_reg[8]\ => \ap_CS_fsm_reg[8]\,
      \ap_CS_fsm_reg[8]_0\ => \ap_CS_fsm_reg[8]_0\,
      \ap_CS_fsm_reg[8]_1\ => \ap_CS_fsm_reg[8]_1\,
      ap_clk => ap_clk,
      ap_enable_reg_pp0_iter0 => ap_enable_reg_pp0_iter0,
      ap_enable_reg_pp0_iter1_reg => ap_enable_reg_pp0_iter1_reg,
      ap_enable_reg_pp0_iter1_reg_0 => ap_enable_reg_pp0_iter1_reg_0,
      ap_enable_reg_pp0_iter2_reg => ap_enable_reg_pp0_iter2_reg,
      ap_rst_n => ap_rst_n,
      \could_multi_bursts.ARVALID_Dummy_reg_0\ => \could_multi_bursts.ARVALID_Dummy_reg\,
      \could_multi_bursts.arlen_buf_reg[3]_0\(3 downto 0) => \could_multi_bursts.arlen_buf_reg[3]\(3 downto 0),
      \data_p1_reg[31]\(31 downto 0) => \data_p1_reg[31]\(31 downto 0),
      \data_p2_reg[63]\(61 downto 0) => \data_p2_reg[63]\(61 downto 0),
      exitcond_reg_251_pp0_iter1_reg => exitcond_reg_251_pp0_iter1_reg,
      full_n_reg => full_n_reg,
      i_reg_137 => i_reg_137,
      i_reg_1370 => i_reg_1370,
      m_axi_gmem_ARADDR(29 downto 0) => m_axi_gmem_ARADDR(29 downto 0),
      m_axi_gmem_ARREADY => m_axi_gmem_ARREADY,
      m_axi_gmem_RRESP(1 downto 0) => m_axi_gmem_RRESP(1 downto 0),
      m_axi_gmem_RVALID => m_axi_gmem_RVALID,
      \state_reg[0]\ => \state_reg[0]\,
      \state_reg[0]_0\(0) => E(0),
      sum_reg_125 => sum_reg_125,
      sum_reg_1250 => sum_reg_1250,
      \usedw_reg[5]\(5 downto 0) => \buff_rdata/usedw_reg\(5 downto 0),
      \usedw_reg[6]\(2) => bus_read_n_57,
      \usedw_reg[6]\(1) => bus_read_n_58,
      \usedw_reg[6]\(0) => bus_read_n_59,
      \usedw_reg[7]\(6) => \p_0_out__18_carry__0_n_7\,
      \usedw_reg[7]\(5) => \p_0_out__18_carry__0_n_8\,
      \usedw_reg[7]\(4) => \p_0_out__18_carry__0_n_9\,
      \usedw_reg[7]\(3) => \p_0_out__18_carry_n_6\,
      \usedw_reg[7]\(2) => \p_0_out__18_carry_n_7\,
      \usedw_reg[7]\(1) => \p_0_out__18_carry_n_8\,
      \usedw_reg[7]\(0) => \p_0_out__18_carry_n_9\
    );
bus_write: entity work.design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_write
     port map (
      AWVALID_Dummy => AWVALID_Dummy,
      D(0) => p_0_in(0),
      DI(0) => bus_write_n_28,
      E(0) => bus_write_n_14,
      Q(6 downto 1) => Q(8 downto 3),
      Q(0) => Q(0),
      S(3) => bus_write_n_59,
      S(2) => bus_write_n_60,
      S(1) => bus_write_n_61,
      S(0) => bus_write_n_62,
      SR(0) => \^sr\(0),
      \ap_CS_fsm_reg[10]\(0) => \ap_CS_fsm_reg[10]\(0),
      \ap_CS_fsm_reg[15]\(5 downto 1) => \ap_CS_fsm_reg[15]\(6 downto 2),
      \ap_CS_fsm_reg[15]\(0) => \ap_CS_fsm_reg[15]\(0),
      \ap_CS_fsm_reg[9]\ => \ap_CS_fsm_reg[9]\,
      ap_clk => ap_clk,
      ap_done => ap_done,
      ap_reg_ioackin_gmem_WREADY => ap_reg_ioackin_gmem_WREADY,
      ap_rst_n => ap_rst_n,
      ap_start => ap_start,
      \bus_equal_gen.WVALID_Dummy_reg_0\ => \bus_equal_gen.WVALID_Dummy_reg\,
      \could_multi_bursts.AWVALID_Dummy_reg_0\ => bus_write_n_15,
      \could_multi_bursts.AWVALID_Dummy_reg_1\ => wreq_throttl_n_5,
      \could_multi_bursts.awaddr_buf_reg[2]_0\ => wreq_throttl_n_7,
      \could_multi_bursts.awaddr_buf_reg[2]_1\ => wreq_throttl_n_4,
      \could_multi_bursts.awlen_buf_reg[3]_0\(3 downto 0) => \^could_multi_bursts.awlen_buf_reg[3]\(3 downto 0),
      \data_p2_reg[29]\(29 downto 0) => \data_p2_reg[29]\(29 downto 0),
      empty_n_reg => gmem_BVALID,
      full_n_reg => full_n_reg_0,
      m_axi_gmem_AWADDR(29 downto 0) => m_axi_gmem_AWADDR(29 downto 0),
      m_axi_gmem_AWREADY => m_axi_gmem_AWREADY,
      m_axi_gmem_BVALID => m_axi_gmem_BVALID,
      m_axi_gmem_WDATA(31 downto 0) => m_axi_gmem_WDATA(31 downto 0),
      m_axi_gmem_WLAST => m_axi_gmem_WLAST,
      m_axi_gmem_WREADY => m_axi_gmem_WREADY,
      m_axi_gmem_WSTRB(3 downto 0) => m_axi_gmem_WSTRB(3 downto 0),
      mem_reg(31 downto 0) => mem_reg(31 downto 0),
      \out\(31 downto 0) => \out\(31 downto 0),
      \throttl_cnt_reg[0]\ => wreq_throttl_n_6,
      \throttl_cnt_reg[0]_0\(0) => throttl_cnt_reg(0),
      \usedw_reg[5]\(5 downto 0) => \buff_wdata/usedw_reg\(5 downto 0),
      \usedw_reg[6]\(2) => bus_write_n_63,
      \usedw_reg[6]\(1) => bus_write_n_64,
      \usedw_reg[6]\(0) => bus_write_n_65,
      \usedw_reg[7]\(6) => \p_0_out_carry__0_n_7\,
      \usedw_reg[7]\(5) => \p_0_out_carry__0_n_8\,
      \usedw_reg[7]\(4) => \p_0_out_carry__0_n_9\,
      \usedw_reg[7]\(3) => p_0_out_carry_n_6,
      \usedw_reg[7]\(2) => p_0_out_carry_n_7,
      \usedw_reg[7]\(1) => p_0_out_carry_n_8,
      \usedw_reg[7]\(0) => p_0_out_carry_n_9
    );
\p_0_out__18_carry\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \p_0_out__18_carry_n_2\,
      CO(2) => \p_0_out__18_carry_n_3\,
      CO(1) => \p_0_out__18_carry_n_4\,
      CO(0) => \p_0_out__18_carry_n_5\,
      CYINIT => \buff_rdata/usedw_reg\(0),
      DI(3 downto 1) => \buff_rdata/usedw_reg\(3 downto 1),
      DI(0) => bus_read_n_20,
      O(3) => \p_0_out__18_carry_n_6\,
      O(2) => \p_0_out__18_carry_n_7\,
      O(1) => \p_0_out__18_carry_n_8\,
      O(0) => \p_0_out__18_carry_n_9\,
      S(3) => bus_read_n_51,
      S(2) => bus_read_n_52,
      S(1) => bus_read_n_53,
      S(0) => bus_read_n_54
    );
\p_0_out__18_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => \p_0_out__18_carry_n_2\,
      CO(3 downto 2) => \NLW_p_0_out__18_carry__0_CO_UNCONNECTED\(3 downto 2),
      CO(1) => \p_0_out__18_carry__0_n_4\,
      CO(0) => \p_0_out__18_carry__0_n_5\,
      CYINIT => '0',
      DI(3 downto 2) => B"00",
      DI(1 downto 0) => \buff_rdata/usedw_reg\(5 downto 4),
      O(3) => \NLW_p_0_out__18_carry__0_O_UNCONNECTED\(3),
      O(2) => \p_0_out__18_carry__0_n_7\,
      O(1) => \p_0_out__18_carry__0_n_8\,
      O(0) => \p_0_out__18_carry__0_n_9\,
      S(3) => '0',
      S(2) => bus_read_n_57,
      S(1) => bus_read_n_58,
      S(0) => bus_read_n_59
    );
p_0_out_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => p_0_out_carry_n_2,
      CO(2) => p_0_out_carry_n_3,
      CO(1) => p_0_out_carry_n_4,
      CO(0) => p_0_out_carry_n_5,
      CYINIT => \buff_wdata/usedw_reg\(0),
      DI(3 downto 1) => \buff_wdata/usedw_reg\(3 downto 1),
      DI(0) => bus_write_n_28,
      O(3) => p_0_out_carry_n_6,
      O(2) => p_0_out_carry_n_7,
      O(1) => p_0_out_carry_n_8,
      O(0) => p_0_out_carry_n_9,
      S(3) => bus_write_n_59,
      S(2) => bus_write_n_60,
      S(1) => bus_write_n_61,
      S(0) => bus_write_n_62
    );
\p_0_out_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => p_0_out_carry_n_2,
      CO(3 downto 2) => \NLW_p_0_out_carry__0_CO_UNCONNECTED\(3 downto 2),
      CO(1) => \p_0_out_carry__0_n_4\,
      CO(0) => \p_0_out_carry__0_n_5\,
      CYINIT => '0',
      DI(3 downto 2) => B"00",
      DI(1 downto 0) => \buff_wdata/usedw_reg\(5 downto 4),
      O(3) => \NLW_p_0_out_carry__0_O_UNCONNECTED\(3),
      O(2) => \p_0_out_carry__0_n_7\,
      O(1) => \p_0_out_carry__0_n_8\,
      O(0) => \p_0_out_carry__0_n_9\,
      S(3) => '0',
      S(2) => bus_write_n_63,
      S(1) => bus_write_n_64,
      S(0) => bus_write_n_65
    );
wreq_throttl: entity work.design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi_throttl
     port map (
      AWVALID_Dummy => AWVALID_Dummy,
      D(0) => p_0_in(0),
      E(0) => bus_write_n_14,
      Q(0) => throttl_cnt_reg(0),
      SR(0) => \^sr\(0),
      ap_clk => ap_clk,
      m_axi_gmem_AWREADY => m_axi_gmem_AWREADY,
      m_axi_gmem_AWREADY_0 => wreq_throttl_n_5,
      m_axi_gmem_AWVALID => m_axi_gmem_AWVALID,
      \throttl_cnt_reg[0]_0\ => wreq_throttl_n_4,
      \throttl_cnt_reg[2]_0\ => bus_write_n_15,
      \throttl_cnt_reg[3]_0\(2 downto 0) => \^could_multi_bursts.awlen_buf_reg[3]\(3 downto 1),
      \throttl_cnt_reg[5]_0\ => wreq_throttl_n_6,
      \throttl_cnt_reg[7]_0\ => wreq_throttl_n_7
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_simple_accel_core_0_3_simple_accel_core is
  port (
    ap_clk : in STD_LOGIC;
    ap_rst_n : in STD_LOGIC;
    m_axi_gmem_AWVALID : out STD_LOGIC;
    m_axi_gmem_AWREADY : in STD_LOGIC;
    m_axi_gmem_AWADDR : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_gmem_AWID : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axi_gmem_AWLEN : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axi_gmem_AWSIZE : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_gmem_AWBURST : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_gmem_AWLOCK : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_gmem_AWCACHE : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_gmem_AWPROT : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_gmem_AWQOS : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_gmem_AWREGION : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_gmem_AWUSER : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axi_gmem_WVALID : out STD_LOGIC;
    m_axi_gmem_WREADY : in STD_LOGIC;
    m_axi_gmem_WDATA : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_gmem_WSTRB : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_gmem_WLAST : out STD_LOGIC;
    m_axi_gmem_WID : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axi_gmem_WUSER : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axi_gmem_ARVALID : out STD_LOGIC;
    m_axi_gmem_ARREADY : in STD_LOGIC;
    m_axi_gmem_ARADDR : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_gmem_ARID : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axi_gmem_ARLEN : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axi_gmem_ARSIZE : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_gmem_ARBURST : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_gmem_ARLOCK : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_gmem_ARCACHE : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_gmem_ARPROT : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_gmem_ARQOS : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_gmem_ARREGION : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_gmem_ARUSER : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axi_gmem_RVALID : in STD_LOGIC;
    m_axi_gmem_RREADY : out STD_LOGIC;
    m_axi_gmem_RDATA : in STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_gmem_RLAST : in STD_LOGIC;
    m_axi_gmem_RID : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_axi_gmem_RUSER : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_axi_gmem_RRESP : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_gmem_BVALID : in STD_LOGIC;
    m_axi_gmem_BREADY : out STD_LOGIC;
    m_axi_gmem_BRESP : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_gmem_BID : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_axi_gmem_BUSER : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_control_AWVALID : in STD_LOGIC;
    s_axi_control_AWREADY : out STD_LOGIC;
    s_axi_control_AWADDR : in STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axi_control_WVALID : in STD_LOGIC;
    s_axi_control_WREADY : out STD_LOGIC;
    s_axi_control_WDATA : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_control_WSTRB : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_control_ARVALID : in STD_LOGIC;
    s_axi_control_ARREADY : out STD_LOGIC;
    s_axi_control_ARADDR : in STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axi_control_RVALID : out STD_LOGIC;
    s_axi_control_RREADY : in STD_LOGIC;
    s_axi_control_RDATA : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_control_RRESP : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_control_BVALID : out STD_LOGIC;
    s_axi_control_BREADY : in STD_LOGIC;
    s_axi_control_BRESP : out STD_LOGIC_VECTOR ( 1 downto 0 );
    interrupt : out STD_LOGIC
  );
  attribute C_M_AXI_DATA_WIDTH : integer;
  attribute C_M_AXI_DATA_WIDTH of design_1_simple_accel_core_0_3_simple_accel_core : entity is 32;
  attribute C_M_AXI_GMEM_ADDR_WIDTH : integer;
  attribute C_M_AXI_GMEM_ADDR_WIDTH of design_1_simple_accel_core_0_3_simple_accel_core : entity is 32;
  attribute C_M_AXI_GMEM_ARUSER_WIDTH : integer;
  attribute C_M_AXI_GMEM_ARUSER_WIDTH of design_1_simple_accel_core_0_3_simple_accel_core : entity is 1;
  attribute C_M_AXI_GMEM_AWUSER_WIDTH : integer;
  attribute C_M_AXI_GMEM_AWUSER_WIDTH of design_1_simple_accel_core_0_3_simple_accel_core : entity is 1;
  attribute C_M_AXI_GMEM_BUSER_WIDTH : integer;
  attribute C_M_AXI_GMEM_BUSER_WIDTH of design_1_simple_accel_core_0_3_simple_accel_core : entity is 1;
  attribute C_M_AXI_GMEM_CACHE_VALUE : integer;
  attribute C_M_AXI_GMEM_CACHE_VALUE of design_1_simple_accel_core_0_3_simple_accel_core : entity is 3;
  attribute C_M_AXI_GMEM_DATA_WIDTH : integer;
  attribute C_M_AXI_GMEM_DATA_WIDTH of design_1_simple_accel_core_0_3_simple_accel_core : entity is 32;
  attribute C_M_AXI_GMEM_ID_WIDTH : integer;
  attribute C_M_AXI_GMEM_ID_WIDTH of design_1_simple_accel_core_0_3_simple_accel_core : entity is 1;
  attribute C_M_AXI_GMEM_PROT_VALUE : integer;
  attribute C_M_AXI_GMEM_PROT_VALUE of design_1_simple_accel_core_0_3_simple_accel_core : entity is 0;
  attribute C_M_AXI_GMEM_RUSER_WIDTH : integer;
  attribute C_M_AXI_GMEM_RUSER_WIDTH of design_1_simple_accel_core_0_3_simple_accel_core : entity is 1;
  attribute C_M_AXI_GMEM_USER_VALUE : integer;
  attribute C_M_AXI_GMEM_USER_VALUE of design_1_simple_accel_core_0_3_simple_accel_core : entity is 0;
  attribute C_M_AXI_GMEM_WSTRB_WIDTH : integer;
  attribute C_M_AXI_GMEM_WSTRB_WIDTH of design_1_simple_accel_core_0_3_simple_accel_core : entity is 4;
  attribute C_M_AXI_GMEM_WUSER_WIDTH : integer;
  attribute C_M_AXI_GMEM_WUSER_WIDTH of design_1_simple_accel_core_0_3_simple_accel_core : entity is 1;
  attribute C_M_AXI_WSTRB_WIDTH : integer;
  attribute C_M_AXI_WSTRB_WIDTH of design_1_simple_accel_core_0_3_simple_accel_core : entity is 4;
  attribute C_S_AXI_CONTROL_ADDR_WIDTH : integer;
  attribute C_S_AXI_CONTROL_ADDR_WIDTH of design_1_simple_accel_core_0_3_simple_accel_core : entity is 6;
  attribute C_S_AXI_CONTROL_DATA_WIDTH : integer;
  attribute C_S_AXI_CONTROL_DATA_WIDTH of design_1_simple_accel_core_0_3_simple_accel_core : entity is 32;
  attribute C_S_AXI_CONTROL_WSTRB_WIDTH : integer;
  attribute C_S_AXI_CONTROL_WSTRB_WIDTH of design_1_simple_accel_core_0_3_simple_accel_core : entity is 4;
  attribute C_S_AXI_DATA_WIDTH : integer;
  attribute C_S_AXI_DATA_WIDTH of design_1_simple_accel_core_0_3_simple_accel_core : entity is 32;
  attribute C_S_AXI_WSTRB_WIDTH : integer;
  attribute C_S_AXI_WSTRB_WIDTH of design_1_simple_accel_core_0_3_simple_accel_core : entity is 4;
  attribute ap_ST_fsm_pp0_stage0 : string;
  attribute ap_ST_fsm_pp0_stage0 of design_1_simple_accel_core_0_3_simple_accel_core : entity is "17'b00000000100000000";
  attribute ap_ST_fsm_state1 : string;
  attribute ap_ST_fsm_state1 of design_1_simple_accel_core_0_3_simple_accel_core : entity is "17'b00000000000000001";
  attribute ap_ST_fsm_state12 : string;
  attribute ap_ST_fsm_state12 of design_1_simple_accel_core_0_3_simple_accel_core : entity is "17'b00000001000000000";
  attribute ap_ST_fsm_state13 : string;
  attribute ap_ST_fsm_state13 of design_1_simple_accel_core_0_3_simple_accel_core : entity is "17'b00000010000000000";
  attribute ap_ST_fsm_state14 : string;
  attribute ap_ST_fsm_state14 of design_1_simple_accel_core_0_3_simple_accel_core : entity is "17'b00000100000000000";
  attribute ap_ST_fsm_state15 : string;
  attribute ap_ST_fsm_state15 of design_1_simple_accel_core_0_3_simple_accel_core : entity is "17'b00001000000000000";
  attribute ap_ST_fsm_state16 : string;
  attribute ap_ST_fsm_state16 of design_1_simple_accel_core_0_3_simple_accel_core : entity is "17'b00010000000000000";
  attribute ap_ST_fsm_state17 : string;
  attribute ap_ST_fsm_state17 of design_1_simple_accel_core_0_3_simple_accel_core : entity is "17'b00100000000000000";
  attribute ap_ST_fsm_state18 : string;
  attribute ap_ST_fsm_state18 of design_1_simple_accel_core_0_3_simple_accel_core : entity is "17'b01000000000000000";
  attribute ap_ST_fsm_state19 : string;
  attribute ap_ST_fsm_state19 of design_1_simple_accel_core_0_3_simple_accel_core : entity is "17'b10000000000000000";
  attribute ap_ST_fsm_state2 : string;
  attribute ap_ST_fsm_state2 of design_1_simple_accel_core_0_3_simple_accel_core : entity is "17'b00000000000000010";
  attribute ap_ST_fsm_state3 : string;
  attribute ap_ST_fsm_state3 of design_1_simple_accel_core_0_3_simple_accel_core : entity is "17'b00000000000000100";
  attribute ap_ST_fsm_state4 : string;
  attribute ap_ST_fsm_state4 of design_1_simple_accel_core_0_3_simple_accel_core : entity is "17'b00000000000001000";
  attribute ap_ST_fsm_state5 : string;
  attribute ap_ST_fsm_state5 of design_1_simple_accel_core_0_3_simple_accel_core : entity is "17'b00000000000010000";
  attribute ap_ST_fsm_state6 : string;
  attribute ap_ST_fsm_state6 of design_1_simple_accel_core_0_3_simple_accel_core : entity is "17'b00000000000100000";
  attribute ap_ST_fsm_state7 : string;
  attribute ap_ST_fsm_state7 of design_1_simple_accel_core_0_3_simple_accel_core : entity is "17'b00000000001000000";
  attribute ap_ST_fsm_state8 : string;
  attribute ap_ST_fsm_state8 of design_1_simple_accel_core_0_3_simple_accel_core : entity is "17'b00000000010000000";
  attribute hls_module : string;
  attribute hls_module of design_1_simple_accel_core_0_3_simple_accel_core : entity is "yes";
end design_1_simple_accel_core_0_3_simple_accel_core;

architecture STRUCTURE of design_1_simple_accel_core_0_3_simple_accel_core is
  signal \<const0>\ : STD_LOGIC;
  signal \<const1>\ : STD_LOGIC;
  signal \ap_CS_fsm[1]_i_2_n_2\ : STD_LOGIC;
  signal \ap_CS_fsm[1]_i_3_n_2\ : STD_LOGIC;
  signal \ap_CS_fsm[1]_i_4_n_2\ : STD_LOGIC;
  signal \ap_CS_fsm[1]_i_5_n_2\ : STD_LOGIC;
  signal \ap_CS_fsm[9]_i_2_n_2\ : STD_LOGIC;
  signal ap_CS_fsm_pp0_stage0 : STD_LOGIC;
  signal \ap_CS_fsm_reg_n_2_[0]\ : STD_LOGIC;
  signal \ap_CS_fsm_reg_n_2_[12]\ : STD_LOGIC;
  signal \ap_CS_fsm_reg_n_2_[13]\ : STD_LOGIC;
  signal \ap_CS_fsm_reg_n_2_[14]\ : STD_LOGIC;
  signal \ap_CS_fsm_reg_n_2_[15]\ : STD_LOGIC;
  signal \ap_CS_fsm_reg_n_2_[2]\ : STD_LOGIC;
  signal \ap_CS_fsm_reg_n_2_[3]\ : STD_LOGIC;
  signal \ap_CS_fsm_reg_n_2_[4]\ : STD_LOGIC;
  signal \ap_CS_fsm_reg_n_2_[5]\ : STD_LOGIC;
  signal \ap_CS_fsm_reg_n_2_[6]\ : STD_LOGIC;
  signal ap_CS_fsm_state12 : STD_LOGIC;
  signal ap_CS_fsm_state13 : STD_LOGIC;
  signal ap_CS_fsm_state14 : STD_LOGIC;
  signal ap_CS_fsm_state19 : STD_LOGIC;
  signal ap_CS_fsm_state2 : STD_LOGIC;
  signal ap_CS_fsm_state8 : STD_LOGIC;
  signal ap_NS_fsm : STD_LOGIC_VECTOR ( 16 downto 0 );
  signal ap_NS_fsm112_out : STD_LOGIC;
  signal ap_NS_fsm120_out : STD_LOGIC;
  signal ap_condition_pp0_exit_iter0_state9 : STD_LOGIC;
  signal ap_done : STD_LOGIC;
  signal ap_enable_reg_pp0_iter0 : STD_LOGIC;
  signal ap_enable_reg_pp0_iter1_reg_n_2 : STD_LOGIC;
  signal ap_enable_reg_pp0_iter2_reg_n_2 : STD_LOGIC;
  signal ap_reg_ioackin_gmem_WREADY : STD_LOGIC;
  signal ap_reg_ioackin_gmem_WREADY_i_1_n_2 : STD_LOGIC;
  signal ap_rst_n_inv : STD_LOGIC;
  signal ap_start : STD_LOGIC;
  signal \bus_read/rs_rreq/load_p2\ : STD_LOGIC;
  signal exitcond_reg_251_pp0_iter1_reg : STD_LOGIC;
  signal \exitcond_reg_251_reg_n_2_[0]\ : STD_LOGIC;
  signal gmem_BVALID : STD_LOGIC;
  signal gmem_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal gmem_addr_1_read_reg_260 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal gmem_addr_1_read_reg_2600 : STD_LOGIC;
  signal gmem_addr_reg_244 : STD_LOGIC_VECTOR ( 29 downto 0 );
  signal i_reg_137 : STD_LOGIC;
  signal i_reg_1370 : STD_LOGIC;
  signal \i_reg_137[0]_i_11_n_2\ : STD_LOGIC;
  signal \i_reg_137[0]_i_12_n_2\ : STD_LOGIC;
  signal \i_reg_137[0]_i_13_n_2\ : STD_LOGIC;
  signal \i_reg_137[0]_i_14_n_2\ : STD_LOGIC;
  signal \i_reg_137[0]_i_15_n_2\ : STD_LOGIC;
  signal \i_reg_137[0]_i_16_n_2\ : STD_LOGIC;
  signal \i_reg_137[0]_i_17_n_2\ : STD_LOGIC;
  signal \i_reg_137[0]_i_18_n_2\ : STD_LOGIC;
  signal \i_reg_137[0]_i_5_n_2\ : STD_LOGIC;
  signal \i_reg_137[0]_i_7_n_2\ : STD_LOGIC;
  signal \i_reg_137[0]_i_8_n_2\ : STD_LOGIC;
  signal \i_reg_137[0]_i_9_n_2\ : STD_LOGIC;
  signal i_reg_137_reg : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \i_reg_137_reg[0]_i_10_n_2\ : STD_LOGIC;
  signal \i_reg_137_reg[0]_i_10_n_3\ : STD_LOGIC;
  signal \i_reg_137_reg[0]_i_10_n_4\ : STD_LOGIC;
  signal \i_reg_137_reg[0]_i_10_n_5\ : STD_LOGIC;
  signal \i_reg_137_reg[0]_i_3_n_2\ : STD_LOGIC;
  signal \i_reg_137_reg[0]_i_3_n_3\ : STD_LOGIC;
  signal \i_reg_137_reg[0]_i_3_n_4\ : STD_LOGIC;
  signal \i_reg_137_reg[0]_i_3_n_5\ : STD_LOGIC;
  signal \i_reg_137_reg[0]_i_3_n_6\ : STD_LOGIC;
  signal \i_reg_137_reg[0]_i_3_n_7\ : STD_LOGIC;
  signal \i_reg_137_reg[0]_i_3_n_8\ : STD_LOGIC;
  signal \i_reg_137_reg[0]_i_3_n_9\ : STD_LOGIC;
  signal \i_reg_137_reg[0]_i_4_n_4\ : STD_LOGIC;
  signal \i_reg_137_reg[0]_i_4_n_5\ : STD_LOGIC;
  signal \i_reg_137_reg[0]_i_6_n_2\ : STD_LOGIC;
  signal \i_reg_137_reg[0]_i_6_n_3\ : STD_LOGIC;
  signal \i_reg_137_reg[0]_i_6_n_4\ : STD_LOGIC;
  signal \i_reg_137_reg[0]_i_6_n_5\ : STD_LOGIC;
  signal \i_reg_137_reg[12]_i_1_n_2\ : STD_LOGIC;
  signal \i_reg_137_reg[12]_i_1_n_3\ : STD_LOGIC;
  signal \i_reg_137_reg[12]_i_1_n_4\ : STD_LOGIC;
  signal \i_reg_137_reg[12]_i_1_n_5\ : STD_LOGIC;
  signal \i_reg_137_reg[12]_i_1_n_6\ : STD_LOGIC;
  signal \i_reg_137_reg[12]_i_1_n_7\ : STD_LOGIC;
  signal \i_reg_137_reg[12]_i_1_n_8\ : STD_LOGIC;
  signal \i_reg_137_reg[12]_i_1_n_9\ : STD_LOGIC;
  signal \i_reg_137_reg[16]_i_1_n_2\ : STD_LOGIC;
  signal \i_reg_137_reg[16]_i_1_n_3\ : STD_LOGIC;
  signal \i_reg_137_reg[16]_i_1_n_4\ : STD_LOGIC;
  signal \i_reg_137_reg[16]_i_1_n_5\ : STD_LOGIC;
  signal \i_reg_137_reg[16]_i_1_n_6\ : STD_LOGIC;
  signal \i_reg_137_reg[16]_i_1_n_7\ : STD_LOGIC;
  signal \i_reg_137_reg[16]_i_1_n_8\ : STD_LOGIC;
  signal \i_reg_137_reg[16]_i_1_n_9\ : STD_LOGIC;
  signal \i_reg_137_reg[20]_i_1_n_2\ : STD_LOGIC;
  signal \i_reg_137_reg[20]_i_1_n_3\ : STD_LOGIC;
  signal \i_reg_137_reg[20]_i_1_n_4\ : STD_LOGIC;
  signal \i_reg_137_reg[20]_i_1_n_5\ : STD_LOGIC;
  signal \i_reg_137_reg[20]_i_1_n_6\ : STD_LOGIC;
  signal \i_reg_137_reg[20]_i_1_n_7\ : STD_LOGIC;
  signal \i_reg_137_reg[20]_i_1_n_8\ : STD_LOGIC;
  signal \i_reg_137_reg[20]_i_1_n_9\ : STD_LOGIC;
  signal \i_reg_137_reg[24]_i_1_n_2\ : STD_LOGIC;
  signal \i_reg_137_reg[24]_i_1_n_3\ : STD_LOGIC;
  signal \i_reg_137_reg[24]_i_1_n_4\ : STD_LOGIC;
  signal \i_reg_137_reg[24]_i_1_n_5\ : STD_LOGIC;
  signal \i_reg_137_reg[24]_i_1_n_6\ : STD_LOGIC;
  signal \i_reg_137_reg[24]_i_1_n_7\ : STD_LOGIC;
  signal \i_reg_137_reg[24]_i_1_n_8\ : STD_LOGIC;
  signal \i_reg_137_reg[24]_i_1_n_9\ : STD_LOGIC;
  signal \i_reg_137_reg[28]_i_1_n_3\ : STD_LOGIC;
  signal \i_reg_137_reg[28]_i_1_n_4\ : STD_LOGIC;
  signal \i_reg_137_reg[28]_i_1_n_5\ : STD_LOGIC;
  signal \i_reg_137_reg[28]_i_1_n_6\ : STD_LOGIC;
  signal \i_reg_137_reg[28]_i_1_n_7\ : STD_LOGIC;
  signal \i_reg_137_reg[28]_i_1_n_8\ : STD_LOGIC;
  signal \i_reg_137_reg[28]_i_1_n_9\ : STD_LOGIC;
  signal \i_reg_137_reg[4]_i_1_n_2\ : STD_LOGIC;
  signal \i_reg_137_reg[4]_i_1_n_3\ : STD_LOGIC;
  signal \i_reg_137_reg[4]_i_1_n_4\ : STD_LOGIC;
  signal \i_reg_137_reg[4]_i_1_n_5\ : STD_LOGIC;
  signal \i_reg_137_reg[4]_i_1_n_6\ : STD_LOGIC;
  signal \i_reg_137_reg[4]_i_1_n_7\ : STD_LOGIC;
  signal \i_reg_137_reg[4]_i_1_n_8\ : STD_LOGIC;
  signal \i_reg_137_reg[4]_i_1_n_9\ : STD_LOGIC;
  signal \i_reg_137_reg[8]_i_1_n_2\ : STD_LOGIC;
  signal \i_reg_137_reg[8]_i_1_n_3\ : STD_LOGIC;
  signal \i_reg_137_reg[8]_i_1_n_4\ : STD_LOGIC;
  signal \i_reg_137_reg[8]_i_1_n_5\ : STD_LOGIC;
  signal \i_reg_137_reg[8]_i_1_n_6\ : STD_LOGIC;
  signal \i_reg_137_reg[8]_i_1_n_7\ : STD_LOGIC;
  signal \i_reg_137_reg[8]_i_1_n_8\ : STD_LOGIC;
  signal \i_reg_137_reg[8]_i_1_n_9\ : STD_LOGIC;
  signal in_buf : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal in_buf1_reg_233 : STD_LOGIC_VECTOR ( 29 downto 0 );
  signal \^m_axi_gmem_araddr\ : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal \^m_axi_gmem_arlen\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \^m_axi_gmem_awaddr\ : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal \^m_axi_gmem_awlen\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal num_items : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal num_items_read_reg_222 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal out_buf : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal out_buf3_reg_228 : STD_LOGIC_VECTOR ( 29 downto 0 );
  signal simple_accel_core_gmem_m_axi_U_n_10 : STD_LOGIC;
  signal simple_accel_core_gmem_m_axi_U_n_29 : STD_LOGIC;
  signal simple_accel_core_gmem_m_axi_U_n_9 : STD_LOGIC;
  signal simple_accel_core_gmem_m_axi_U_n_91 : STD_LOGIC;
  signal simple_accel_core_gmem_m_axi_U_n_92 : STD_LOGIC;
  signal sum_reg_125 : STD_LOGIC;
  signal sum_reg_1250 : STD_LOGIC;
  signal \sum_reg_125[0]_i_4_n_2\ : STD_LOGIC;
  signal \sum_reg_125[0]_i_5_n_2\ : STD_LOGIC;
  signal \sum_reg_125[0]_i_6_n_2\ : STD_LOGIC;
  signal \sum_reg_125[0]_i_7_n_2\ : STD_LOGIC;
  signal \sum_reg_125[12]_i_2_n_2\ : STD_LOGIC;
  signal \sum_reg_125[12]_i_3_n_2\ : STD_LOGIC;
  signal \sum_reg_125[12]_i_4_n_2\ : STD_LOGIC;
  signal \sum_reg_125[12]_i_5_n_2\ : STD_LOGIC;
  signal \sum_reg_125[16]_i_2_n_2\ : STD_LOGIC;
  signal \sum_reg_125[16]_i_3_n_2\ : STD_LOGIC;
  signal \sum_reg_125[16]_i_4_n_2\ : STD_LOGIC;
  signal \sum_reg_125[16]_i_5_n_2\ : STD_LOGIC;
  signal \sum_reg_125[20]_i_2_n_2\ : STD_LOGIC;
  signal \sum_reg_125[20]_i_3_n_2\ : STD_LOGIC;
  signal \sum_reg_125[20]_i_4_n_2\ : STD_LOGIC;
  signal \sum_reg_125[20]_i_5_n_2\ : STD_LOGIC;
  signal \sum_reg_125[24]_i_2_n_2\ : STD_LOGIC;
  signal \sum_reg_125[24]_i_3_n_2\ : STD_LOGIC;
  signal \sum_reg_125[24]_i_4_n_2\ : STD_LOGIC;
  signal \sum_reg_125[24]_i_5_n_2\ : STD_LOGIC;
  signal \sum_reg_125[28]_i_2_n_2\ : STD_LOGIC;
  signal \sum_reg_125[28]_i_3_n_2\ : STD_LOGIC;
  signal \sum_reg_125[28]_i_4_n_2\ : STD_LOGIC;
  signal \sum_reg_125[28]_i_5_n_2\ : STD_LOGIC;
  signal \sum_reg_125[4]_i_2_n_2\ : STD_LOGIC;
  signal \sum_reg_125[4]_i_3_n_2\ : STD_LOGIC;
  signal \sum_reg_125[4]_i_4_n_2\ : STD_LOGIC;
  signal \sum_reg_125[4]_i_5_n_2\ : STD_LOGIC;
  signal \sum_reg_125[8]_i_2_n_2\ : STD_LOGIC;
  signal \sum_reg_125[8]_i_3_n_2\ : STD_LOGIC;
  signal \sum_reg_125[8]_i_4_n_2\ : STD_LOGIC;
  signal \sum_reg_125[8]_i_5_n_2\ : STD_LOGIC;
  signal sum_reg_125_reg : STD_LOGIC_VECTOR ( 63 downto 32 );
  signal \sum_reg_125_reg[0]_i_3_n_2\ : STD_LOGIC;
  signal \sum_reg_125_reg[0]_i_3_n_3\ : STD_LOGIC;
  signal \sum_reg_125_reg[0]_i_3_n_4\ : STD_LOGIC;
  signal \sum_reg_125_reg[0]_i_3_n_5\ : STD_LOGIC;
  signal \sum_reg_125_reg[0]_i_3_n_6\ : STD_LOGIC;
  signal \sum_reg_125_reg[0]_i_3_n_7\ : STD_LOGIC;
  signal \sum_reg_125_reg[0]_i_3_n_8\ : STD_LOGIC;
  signal \sum_reg_125_reg[0]_i_3_n_9\ : STD_LOGIC;
  signal \sum_reg_125_reg[12]_i_1_n_2\ : STD_LOGIC;
  signal \sum_reg_125_reg[12]_i_1_n_3\ : STD_LOGIC;
  signal \sum_reg_125_reg[12]_i_1_n_4\ : STD_LOGIC;
  signal \sum_reg_125_reg[12]_i_1_n_5\ : STD_LOGIC;
  signal \sum_reg_125_reg[12]_i_1_n_6\ : STD_LOGIC;
  signal \sum_reg_125_reg[12]_i_1_n_7\ : STD_LOGIC;
  signal \sum_reg_125_reg[12]_i_1_n_8\ : STD_LOGIC;
  signal \sum_reg_125_reg[12]_i_1_n_9\ : STD_LOGIC;
  signal \sum_reg_125_reg[16]_i_1_n_2\ : STD_LOGIC;
  signal \sum_reg_125_reg[16]_i_1_n_3\ : STD_LOGIC;
  signal \sum_reg_125_reg[16]_i_1_n_4\ : STD_LOGIC;
  signal \sum_reg_125_reg[16]_i_1_n_5\ : STD_LOGIC;
  signal \sum_reg_125_reg[16]_i_1_n_6\ : STD_LOGIC;
  signal \sum_reg_125_reg[16]_i_1_n_7\ : STD_LOGIC;
  signal \sum_reg_125_reg[16]_i_1_n_8\ : STD_LOGIC;
  signal \sum_reg_125_reg[16]_i_1_n_9\ : STD_LOGIC;
  signal \sum_reg_125_reg[20]_i_1_n_2\ : STD_LOGIC;
  signal \sum_reg_125_reg[20]_i_1_n_3\ : STD_LOGIC;
  signal \sum_reg_125_reg[20]_i_1_n_4\ : STD_LOGIC;
  signal \sum_reg_125_reg[20]_i_1_n_5\ : STD_LOGIC;
  signal \sum_reg_125_reg[20]_i_1_n_6\ : STD_LOGIC;
  signal \sum_reg_125_reg[20]_i_1_n_7\ : STD_LOGIC;
  signal \sum_reg_125_reg[20]_i_1_n_8\ : STD_LOGIC;
  signal \sum_reg_125_reg[20]_i_1_n_9\ : STD_LOGIC;
  signal \sum_reg_125_reg[24]_i_1_n_2\ : STD_LOGIC;
  signal \sum_reg_125_reg[24]_i_1_n_3\ : STD_LOGIC;
  signal \sum_reg_125_reg[24]_i_1_n_4\ : STD_LOGIC;
  signal \sum_reg_125_reg[24]_i_1_n_5\ : STD_LOGIC;
  signal \sum_reg_125_reg[24]_i_1_n_6\ : STD_LOGIC;
  signal \sum_reg_125_reg[24]_i_1_n_7\ : STD_LOGIC;
  signal \sum_reg_125_reg[24]_i_1_n_8\ : STD_LOGIC;
  signal \sum_reg_125_reg[24]_i_1_n_9\ : STD_LOGIC;
  signal \sum_reg_125_reg[28]_i_1_n_2\ : STD_LOGIC;
  signal \sum_reg_125_reg[28]_i_1_n_3\ : STD_LOGIC;
  signal \sum_reg_125_reg[28]_i_1_n_4\ : STD_LOGIC;
  signal \sum_reg_125_reg[28]_i_1_n_5\ : STD_LOGIC;
  signal \sum_reg_125_reg[28]_i_1_n_6\ : STD_LOGIC;
  signal \sum_reg_125_reg[28]_i_1_n_7\ : STD_LOGIC;
  signal \sum_reg_125_reg[28]_i_1_n_8\ : STD_LOGIC;
  signal \sum_reg_125_reg[28]_i_1_n_9\ : STD_LOGIC;
  signal \sum_reg_125_reg[32]_i_1_n_2\ : STD_LOGIC;
  signal \sum_reg_125_reg[32]_i_1_n_3\ : STD_LOGIC;
  signal \sum_reg_125_reg[32]_i_1_n_4\ : STD_LOGIC;
  signal \sum_reg_125_reg[32]_i_1_n_5\ : STD_LOGIC;
  signal \sum_reg_125_reg[32]_i_1_n_6\ : STD_LOGIC;
  signal \sum_reg_125_reg[32]_i_1_n_7\ : STD_LOGIC;
  signal \sum_reg_125_reg[32]_i_1_n_8\ : STD_LOGIC;
  signal \sum_reg_125_reg[32]_i_1_n_9\ : STD_LOGIC;
  signal \sum_reg_125_reg[36]_i_1_n_2\ : STD_LOGIC;
  signal \sum_reg_125_reg[36]_i_1_n_3\ : STD_LOGIC;
  signal \sum_reg_125_reg[36]_i_1_n_4\ : STD_LOGIC;
  signal \sum_reg_125_reg[36]_i_1_n_5\ : STD_LOGIC;
  signal \sum_reg_125_reg[36]_i_1_n_6\ : STD_LOGIC;
  signal \sum_reg_125_reg[36]_i_1_n_7\ : STD_LOGIC;
  signal \sum_reg_125_reg[36]_i_1_n_8\ : STD_LOGIC;
  signal \sum_reg_125_reg[36]_i_1_n_9\ : STD_LOGIC;
  signal \sum_reg_125_reg[40]_i_1_n_2\ : STD_LOGIC;
  signal \sum_reg_125_reg[40]_i_1_n_3\ : STD_LOGIC;
  signal \sum_reg_125_reg[40]_i_1_n_4\ : STD_LOGIC;
  signal \sum_reg_125_reg[40]_i_1_n_5\ : STD_LOGIC;
  signal \sum_reg_125_reg[40]_i_1_n_6\ : STD_LOGIC;
  signal \sum_reg_125_reg[40]_i_1_n_7\ : STD_LOGIC;
  signal \sum_reg_125_reg[40]_i_1_n_8\ : STD_LOGIC;
  signal \sum_reg_125_reg[40]_i_1_n_9\ : STD_LOGIC;
  signal \sum_reg_125_reg[44]_i_1_n_2\ : STD_LOGIC;
  signal \sum_reg_125_reg[44]_i_1_n_3\ : STD_LOGIC;
  signal \sum_reg_125_reg[44]_i_1_n_4\ : STD_LOGIC;
  signal \sum_reg_125_reg[44]_i_1_n_5\ : STD_LOGIC;
  signal \sum_reg_125_reg[44]_i_1_n_6\ : STD_LOGIC;
  signal \sum_reg_125_reg[44]_i_1_n_7\ : STD_LOGIC;
  signal \sum_reg_125_reg[44]_i_1_n_8\ : STD_LOGIC;
  signal \sum_reg_125_reg[44]_i_1_n_9\ : STD_LOGIC;
  signal \sum_reg_125_reg[48]_i_1_n_2\ : STD_LOGIC;
  signal \sum_reg_125_reg[48]_i_1_n_3\ : STD_LOGIC;
  signal \sum_reg_125_reg[48]_i_1_n_4\ : STD_LOGIC;
  signal \sum_reg_125_reg[48]_i_1_n_5\ : STD_LOGIC;
  signal \sum_reg_125_reg[48]_i_1_n_6\ : STD_LOGIC;
  signal \sum_reg_125_reg[48]_i_1_n_7\ : STD_LOGIC;
  signal \sum_reg_125_reg[48]_i_1_n_8\ : STD_LOGIC;
  signal \sum_reg_125_reg[48]_i_1_n_9\ : STD_LOGIC;
  signal \sum_reg_125_reg[4]_i_1_n_2\ : STD_LOGIC;
  signal \sum_reg_125_reg[4]_i_1_n_3\ : STD_LOGIC;
  signal \sum_reg_125_reg[4]_i_1_n_4\ : STD_LOGIC;
  signal \sum_reg_125_reg[4]_i_1_n_5\ : STD_LOGIC;
  signal \sum_reg_125_reg[4]_i_1_n_6\ : STD_LOGIC;
  signal \sum_reg_125_reg[4]_i_1_n_7\ : STD_LOGIC;
  signal \sum_reg_125_reg[4]_i_1_n_8\ : STD_LOGIC;
  signal \sum_reg_125_reg[4]_i_1_n_9\ : STD_LOGIC;
  signal \sum_reg_125_reg[52]_i_1_n_2\ : STD_LOGIC;
  signal \sum_reg_125_reg[52]_i_1_n_3\ : STD_LOGIC;
  signal \sum_reg_125_reg[52]_i_1_n_4\ : STD_LOGIC;
  signal \sum_reg_125_reg[52]_i_1_n_5\ : STD_LOGIC;
  signal \sum_reg_125_reg[52]_i_1_n_6\ : STD_LOGIC;
  signal \sum_reg_125_reg[52]_i_1_n_7\ : STD_LOGIC;
  signal \sum_reg_125_reg[52]_i_1_n_8\ : STD_LOGIC;
  signal \sum_reg_125_reg[52]_i_1_n_9\ : STD_LOGIC;
  signal \sum_reg_125_reg[56]_i_1_n_2\ : STD_LOGIC;
  signal \sum_reg_125_reg[56]_i_1_n_3\ : STD_LOGIC;
  signal \sum_reg_125_reg[56]_i_1_n_4\ : STD_LOGIC;
  signal \sum_reg_125_reg[56]_i_1_n_5\ : STD_LOGIC;
  signal \sum_reg_125_reg[56]_i_1_n_6\ : STD_LOGIC;
  signal \sum_reg_125_reg[56]_i_1_n_7\ : STD_LOGIC;
  signal \sum_reg_125_reg[56]_i_1_n_8\ : STD_LOGIC;
  signal \sum_reg_125_reg[56]_i_1_n_9\ : STD_LOGIC;
  signal \sum_reg_125_reg[60]_i_1_n_3\ : STD_LOGIC;
  signal \sum_reg_125_reg[60]_i_1_n_4\ : STD_LOGIC;
  signal \sum_reg_125_reg[60]_i_1_n_5\ : STD_LOGIC;
  signal \sum_reg_125_reg[60]_i_1_n_6\ : STD_LOGIC;
  signal \sum_reg_125_reg[60]_i_1_n_7\ : STD_LOGIC;
  signal \sum_reg_125_reg[60]_i_1_n_8\ : STD_LOGIC;
  signal \sum_reg_125_reg[60]_i_1_n_9\ : STD_LOGIC;
  signal \sum_reg_125_reg[8]_i_1_n_2\ : STD_LOGIC;
  signal \sum_reg_125_reg[8]_i_1_n_3\ : STD_LOGIC;
  signal \sum_reg_125_reg[8]_i_1_n_4\ : STD_LOGIC;
  signal \sum_reg_125_reg[8]_i_1_n_5\ : STD_LOGIC;
  signal \sum_reg_125_reg[8]_i_1_n_6\ : STD_LOGIC;
  signal \sum_reg_125_reg[8]_i_1_n_7\ : STD_LOGIC;
  signal \sum_reg_125_reg[8]_i_1_n_8\ : STD_LOGIC;
  signal \sum_reg_125_reg[8]_i_1_n_9\ : STD_LOGIC;
  signal \sum_reg_125_reg__0\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal tmp_2_reg_270 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \NLW_i_reg_137_reg[0]_i_10_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_i_reg_137_reg[0]_i_4_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_i_reg_137_reg[0]_i_4_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_i_reg_137_reg[0]_i_6_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_i_reg_137_reg[28]_i_1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_sum_reg_125_reg[60]_i_1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \ap_CS_fsm[1]_i_3\ : label is "soft_lutpair210";
  attribute FSM_ENCODING : string;
  attribute FSM_ENCODING of \ap_CS_fsm_reg[0]\ : label is "none";
  attribute FSM_ENCODING of \ap_CS_fsm_reg[10]\ : label is "none";
  attribute FSM_ENCODING of \ap_CS_fsm_reg[11]\ : label is "none";
  attribute FSM_ENCODING of \ap_CS_fsm_reg[12]\ : label is "none";
  attribute FSM_ENCODING of \ap_CS_fsm_reg[13]\ : label is "none";
  attribute FSM_ENCODING of \ap_CS_fsm_reg[14]\ : label is "none";
  attribute FSM_ENCODING of \ap_CS_fsm_reg[15]\ : label is "none";
  attribute FSM_ENCODING of \ap_CS_fsm_reg[16]\ : label is "none";
  attribute FSM_ENCODING of \ap_CS_fsm_reg[1]\ : label is "none";
  attribute FSM_ENCODING of \ap_CS_fsm_reg[2]\ : label is "none";
  attribute FSM_ENCODING of \ap_CS_fsm_reg[3]\ : label is "none";
  attribute FSM_ENCODING of \ap_CS_fsm_reg[4]\ : label is "none";
  attribute FSM_ENCODING of \ap_CS_fsm_reg[5]\ : label is "none";
  attribute FSM_ENCODING of \ap_CS_fsm_reg[6]\ : label is "none";
  attribute FSM_ENCODING of \ap_CS_fsm_reg[7]\ : label is "none";
  attribute FSM_ENCODING of \ap_CS_fsm_reg[8]\ : label is "none";
  attribute FSM_ENCODING of \ap_CS_fsm_reg[9]\ : label is "none";
  attribute SOFT_HLUTNM of ap_reg_ioackin_gmem_WREADY_i_1 : label is "soft_lutpair210";
  attribute METHODOLOGY_DRC_VIOS : string;
  attribute METHODOLOGY_DRC_VIOS of \i_reg_137_reg[0]_i_10\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \i_reg_137_reg[0]_i_3\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \i_reg_137_reg[0]_i_4\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \i_reg_137_reg[0]_i_6\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \i_reg_137_reg[12]_i_1\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \i_reg_137_reg[16]_i_1\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \i_reg_137_reg[20]_i_1\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \i_reg_137_reg[24]_i_1\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \i_reg_137_reg[28]_i_1\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \i_reg_137_reg[4]_i_1\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \i_reg_137_reg[8]_i_1\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \sum_reg_125_reg[0]_i_3\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \sum_reg_125_reg[12]_i_1\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \sum_reg_125_reg[16]_i_1\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \sum_reg_125_reg[20]_i_1\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \sum_reg_125_reg[24]_i_1\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \sum_reg_125_reg[28]_i_1\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \sum_reg_125_reg[32]_i_1\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \sum_reg_125_reg[36]_i_1\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \sum_reg_125_reg[40]_i_1\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \sum_reg_125_reg[44]_i_1\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \sum_reg_125_reg[48]_i_1\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \sum_reg_125_reg[4]_i_1\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \sum_reg_125_reg[52]_i_1\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \sum_reg_125_reg[56]_i_1\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \sum_reg_125_reg[60]_i_1\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \sum_reg_125_reg[8]_i_1\ : label is "{SYNTH-8 {cell *THIS*}}";
begin
  m_axi_gmem_ARADDR(31 downto 2) <= \^m_axi_gmem_araddr\(31 downto 2);
  m_axi_gmem_ARADDR(1) <= \<const0>\;
  m_axi_gmem_ARADDR(0) <= \<const0>\;
  m_axi_gmem_ARBURST(1) <= \<const0>\;
  m_axi_gmem_ARBURST(0) <= \<const1>\;
  m_axi_gmem_ARCACHE(3) <= \<const0>\;
  m_axi_gmem_ARCACHE(2) <= \<const0>\;
  m_axi_gmem_ARCACHE(1) <= \<const1>\;
  m_axi_gmem_ARCACHE(0) <= \<const1>\;
  m_axi_gmem_ARID(0) <= \<const0>\;
  m_axi_gmem_ARLEN(7) <= \<const0>\;
  m_axi_gmem_ARLEN(6) <= \<const0>\;
  m_axi_gmem_ARLEN(5) <= \<const0>\;
  m_axi_gmem_ARLEN(4) <= \<const0>\;
  m_axi_gmem_ARLEN(3 downto 0) <= \^m_axi_gmem_arlen\(3 downto 0);
  m_axi_gmem_ARLOCK(1) <= \<const0>\;
  m_axi_gmem_ARLOCK(0) <= \<const0>\;
  m_axi_gmem_ARPROT(2) <= \<const0>\;
  m_axi_gmem_ARPROT(1) <= \<const0>\;
  m_axi_gmem_ARPROT(0) <= \<const0>\;
  m_axi_gmem_ARQOS(3) <= \<const0>\;
  m_axi_gmem_ARQOS(2) <= \<const0>\;
  m_axi_gmem_ARQOS(1) <= \<const0>\;
  m_axi_gmem_ARQOS(0) <= \<const0>\;
  m_axi_gmem_ARREGION(3) <= \<const0>\;
  m_axi_gmem_ARREGION(2) <= \<const0>\;
  m_axi_gmem_ARREGION(1) <= \<const0>\;
  m_axi_gmem_ARREGION(0) <= \<const0>\;
  m_axi_gmem_ARSIZE(2) <= \<const0>\;
  m_axi_gmem_ARSIZE(1) <= \<const1>\;
  m_axi_gmem_ARSIZE(0) <= \<const0>\;
  m_axi_gmem_ARUSER(0) <= \<const0>\;
  m_axi_gmem_AWADDR(31 downto 2) <= \^m_axi_gmem_awaddr\(31 downto 2);
  m_axi_gmem_AWADDR(1) <= \<const0>\;
  m_axi_gmem_AWADDR(0) <= \<const0>\;
  m_axi_gmem_AWBURST(1) <= \<const0>\;
  m_axi_gmem_AWBURST(0) <= \<const1>\;
  m_axi_gmem_AWCACHE(3) <= \<const0>\;
  m_axi_gmem_AWCACHE(2) <= \<const0>\;
  m_axi_gmem_AWCACHE(1) <= \<const1>\;
  m_axi_gmem_AWCACHE(0) <= \<const1>\;
  m_axi_gmem_AWID(0) <= \<const0>\;
  m_axi_gmem_AWLEN(7) <= \<const0>\;
  m_axi_gmem_AWLEN(6) <= \<const0>\;
  m_axi_gmem_AWLEN(5) <= \<const0>\;
  m_axi_gmem_AWLEN(4) <= \<const0>\;
  m_axi_gmem_AWLEN(3 downto 0) <= \^m_axi_gmem_awlen\(3 downto 0);
  m_axi_gmem_AWLOCK(1) <= \<const0>\;
  m_axi_gmem_AWLOCK(0) <= \<const0>\;
  m_axi_gmem_AWPROT(2) <= \<const0>\;
  m_axi_gmem_AWPROT(1) <= \<const0>\;
  m_axi_gmem_AWPROT(0) <= \<const0>\;
  m_axi_gmem_AWQOS(3) <= \<const0>\;
  m_axi_gmem_AWQOS(2) <= \<const0>\;
  m_axi_gmem_AWQOS(1) <= \<const0>\;
  m_axi_gmem_AWQOS(0) <= \<const0>\;
  m_axi_gmem_AWREGION(3) <= \<const0>\;
  m_axi_gmem_AWREGION(2) <= \<const0>\;
  m_axi_gmem_AWREGION(1) <= \<const0>\;
  m_axi_gmem_AWREGION(0) <= \<const0>\;
  m_axi_gmem_AWSIZE(2) <= \<const0>\;
  m_axi_gmem_AWSIZE(1) <= \<const1>\;
  m_axi_gmem_AWSIZE(0) <= \<const0>\;
  m_axi_gmem_AWUSER(0) <= \<const0>\;
  m_axi_gmem_WID(0) <= \<const0>\;
  m_axi_gmem_WUSER(0) <= \<const0>\;
  s_axi_control_BRESP(1) <= \<const0>\;
  s_axi_control_BRESP(0) <= \<const0>\;
  s_axi_control_RRESP(1) <= \<const0>\;
  s_axi_control_RRESP(0) <= \<const0>\;
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
VCC: unisim.vcomponents.VCC
     port map (
      P => \<const1>\
    );
\ap_CS_fsm[1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => ap_CS_fsm_pp0_stage0,
      I1 => \ap_CS_fsm_reg_n_2_[15]\,
      I2 => \ap_CS_fsm_reg_n_2_[0]\,
      I3 => \ap_CS_fsm_reg_n_2_[3]\,
      I4 => \ap_CS_fsm[1]_i_4_n_2\,
      I5 => \ap_CS_fsm[1]_i_5_n_2\,
      O => \ap_CS_fsm[1]_i_2_n_2\
    );
\ap_CS_fsm[1]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => ap_CS_fsm_state13,
      I1 => ap_CS_fsm_state14,
      O => \ap_CS_fsm[1]_i_3_n_2\
    );
\ap_CS_fsm[1]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \ap_CS_fsm_reg_n_2_[12]\,
      I1 => \ap_CS_fsm_reg_n_2_[5]\,
      I2 => \ap_CS_fsm_reg_n_2_[14]\,
      I3 => ap_CS_fsm_state19,
      O => \ap_CS_fsm[1]_i_4_n_2\
    );
\ap_CS_fsm[1]_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \ap_CS_fsm_reg_n_2_[4]\,
      I1 => ap_CS_fsm_state12,
      I2 => \ap_CS_fsm_reg_n_2_[13]\,
      I3 => ap_CS_fsm_state8,
      O => \ap_CS_fsm[1]_i_5_n_2\
    );
\ap_CS_fsm[8]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"BA"
    )
        port map (
      I0 => ap_CS_fsm_state8,
      I1 => \ap_CS_fsm[9]_i_2_n_2\,
      I2 => ap_CS_fsm_pp0_stage0,
      O => ap_NS_fsm(8)
    );
\ap_CS_fsm[9]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"00EA"
    )
        port map (
      I0 => ap_enable_reg_pp0_iter2_reg_n_2,
      I1 => ap_enable_reg_pp0_iter0,
      I2 => ap_condition_pp0_exit_iter0_state9,
      I3 => ap_enable_reg_pp0_iter1_reg_n_2,
      O => \ap_CS_fsm[9]_i_2_n_2\
    );
\ap_CS_fsm_reg[0]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => ap_NS_fsm(0),
      Q => \ap_CS_fsm_reg_n_2_[0]\,
      S => ap_rst_n_inv
    );
\ap_CS_fsm_reg[10]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => ap_NS_fsm(10),
      Q => ap_CS_fsm_state13,
      R => ap_rst_n_inv
    );
\ap_CS_fsm_reg[11]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => ap_NS_fsm(11),
      Q => ap_CS_fsm_state14,
      R => ap_rst_n_inv
    );
\ap_CS_fsm_reg[12]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => ap_NS_fsm(12),
      Q => \ap_CS_fsm_reg_n_2_[12]\,
      R => ap_rst_n_inv
    );
\ap_CS_fsm_reg[13]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \ap_CS_fsm_reg_n_2_[12]\,
      Q => \ap_CS_fsm_reg_n_2_[13]\,
      R => ap_rst_n_inv
    );
\ap_CS_fsm_reg[14]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \ap_CS_fsm_reg_n_2_[13]\,
      Q => \ap_CS_fsm_reg_n_2_[14]\,
      R => ap_rst_n_inv
    );
\ap_CS_fsm_reg[15]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \ap_CS_fsm_reg_n_2_[14]\,
      Q => \ap_CS_fsm_reg_n_2_[15]\,
      R => ap_rst_n_inv
    );
\ap_CS_fsm_reg[16]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => ap_NS_fsm(16),
      Q => ap_CS_fsm_state19,
      R => ap_rst_n_inv
    );
\ap_CS_fsm_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => ap_NS_fsm(1),
      Q => ap_CS_fsm_state2,
      R => ap_rst_n_inv
    );
\ap_CS_fsm_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \bus_read/rs_rreq/load_p2\,
      Q => \ap_CS_fsm_reg_n_2_[2]\,
      R => ap_rst_n_inv
    );
\ap_CS_fsm_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \ap_CS_fsm_reg_n_2_[2]\,
      Q => \ap_CS_fsm_reg_n_2_[3]\,
      R => ap_rst_n_inv
    );
\ap_CS_fsm_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \ap_CS_fsm_reg_n_2_[3]\,
      Q => \ap_CS_fsm_reg_n_2_[4]\,
      R => ap_rst_n_inv
    );
\ap_CS_fsm_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \ap_CS_fsm_reg_n_2_[4]\,
      Q => \ap_CS_fsm_reg_n_2_[5]\,
      R => ap_rst_n_inv
    );
\ap_CS_fsm_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \ap_CS_fsm_reg_n_2_[5]\,
      Q => \ap_CS_fsm_reg_n_2_[6]\,
      R => ap_rst_n_inv
    );
\ap_CS_fsm_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => \ap_CS_fsm_reg_n_2_[6]\,
      Q => ap_CS_fsm_state8,
      R => ap_rst_n_inv
    );
\ap_CS_fsm_reg[8]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => ap_NS_fsm(8),
      Q => ap_CS_fsm_pp0_stage0,
      R => ap_rst_n_inv
    );
\ap_CS_fsm_reg[9]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => ap_NS_fsm(9),
      Q => ap_CS_fsm_state12,
      R => ap_rst_n_inv
    );
ap_enable_reg_pp0_iter0_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => simple_accel_core_gmem_m_axi_U_n_29,
      Q => ap_enable_reg_pp0_iter0,
      R => '0'
    );
ap_enable_reg_pp0_iter1_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => simple_accel_core_gmem_m_axi_U_n_9,
      Q => ap_enable_reg_pp0_iter1_reg_n_2,
      R => '0'
    );
ap_enable_reg_pp0_iter2_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => simple_accel_core_gmem_m_axi_U_n_10,
      Q => ap_enable_reg_pp0_iter2_reg_n_2,
      R => '0'
    );
ap_reg_ioackin_gmem_WREADY_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0020"
    )
        port map (
      I0 => ap_rst_n,
      I1 => ap_CS_fsm_state14,
      I2 => ap_reg_ioackin_gmem_WREADY,
      I3 => ap_CS_fsm_state13,
      O => ap_reg_ioackin_gmem_WREADY_i_1_n_2
    );
ap_reg_ioackin_gmem_WREADY_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => ap_clk,
      CE => '1',
      D => ap_reg_ioackin_gmem_WREADY_i_1_n_2,
      Q => ap_reg_ioackin_gmem_WREADY,
      R => '0'
    );
\exitcond_reg_251_pp0_iter1_reg_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => simple_accel_core_gmem_m_axi_U_n_91,
      Q => exitcond_reg_251_pp0_iter1_reg,
      R => '0'
    );
\exitcond_reg_251_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => '1',
      D => simple_accel_core_gmem_m_axi_U_n_92,
      Q => \exitcond_reg_251_reg_n_2_[0]\,
      R => '0'
    );
\gmem_addr_1_read_reg_260_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => gmem_addr_1_read_reg_2600,
      D => gmem_RDATA(0),
      Q => gmem_addr_1_read_reg_260(0),
      R => '0'
    );
\gmem_addr_1_read_reg_260_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => gmem_addr_1_read_reg_2600,
      D => gmem_RDATA(10),
      Q => gmem_addr_1_read_reg_260(10),
      R => '0'
    );
\gmem_addr_1_read_reg_260_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => gmem_addr_1_read_reg_2600,
      D => gmem_RDATA(11),
      Q => gmem_addr_1_read_reg_260(11),
      R => '0'
    );
\gmem_addr_1_read_reg_260_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => gmem_addr_1_read_reg_2600,
      D => gmem_RDATA(12),
      Q => gmem_addr_1_read_reg_260(12),
      R => '0'
    );
\gmem_addr_1_read_reg_260_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => gmem_addr_1_read_reg_2600,
      D => gmem_RDATA(13),
      Q => gmem_addr_1_read_reg_260(13),
      R => '0'
    );
\gmem_addr_1_read_reg_260_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => gmem_addr_1_read_reg_2600,
      D => gmem_RDATA(14),
      Q => gmem_addr_1_read_reg_260(14),
      R => '0'
    );
\gmem_addr_1_read_reg_260_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => gmem_addr_1_read_reg_2600,
      D => gmem_RDATA(15),
      Q => gmem_addr_1_read_reg_260(15),
      R => '0'
    );
\gmem_addr_1_read_reg_260_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => gmem_addr_1_read_reg_2600,
      D => gmem_RDATA(16),
      Q => gmem_addr_1_read_reg_260(16),
      R => '0'
    );
\gmem_addr_1_read_reg_260_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => gmem_addr_1_read_reg_2600,
      D => gmem_RDATA(17),
      Q => gmem_addr_1_read_reg_260(17),
      R => '0'
    );
\gmem_addr_1_read_reg_260_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => gmem_addr_1_read_reg_2600,
      D => gmem_RDATA(18),
      Q => gmem_addr_1_read_reg_260(18),
      R => '0'
    );
\gmem_addr_1_read_reg_260_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => gmem_addr_1_read_reg_2600,
      D => gmem_RDATA(19),
      Q => gmem_addr_1_read_reg_260(19),
      R => '0'
    );
\gmem_addr_1_read_reg_260_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => gmem_addr_1_read_reg_2600,
      D => gmem_RDATA(1),
      Q => gmem_addr_1_read_reg_260(1),
      R => '0'
    );
\gmem_addr_1_read_reg_260_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => gmem_addr_1_read_reg_2600,
      D => gmem_RDATA(20),
      Q => gmem_addr_1_read_reg_260(20),
      R => '0'
    );
\gmem_addr_1_read_reg_260_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => gmem_addr_1_read_reg_2600,
      D => gmem_RDATA(21),
      Q => gmem_addr_1_read_reg_260(21),
      R => '0'
    );
\gmem_addr_1_read_reg_260_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => gmem_addr_1_read_reg_2600,
      D => gmem_RDATA(22),
      Q => gmem_addr_1_read_reg_260(22),
      R => '0'
    );
\gmem_addr_1_read_reg_260_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => gmem_addr_1_read_reg_2600,
      D => gmem_RDATA(23),
      Q => gmem_addr_1_read_reg_260(23),
      R => '0'
    );
\gmem_addr_1_read_reg_260_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => gmem_addr_1_read_reg_2600,
      D => gmem_RDATA(24),
      Q => gmem_addr_1_read_reg_260(24),
      R => '0'
    );
\gmem_addr_1_read_reg_260_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => gmem_addr_1_read_reg_2600,
      D => gmem_RDATA(25),
      Q => gmem_addr_1_read_reg_260(25),
      R => '0'
    );
\gmem_addr_1_read_reg_260_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => gmem_addr_1_read_reg_2600,
      D => gmem_RDATA(26),
      Q => gmem_addr_1_read_reg_260(26),
      R => '0'
    );
\gmem_addr_1_read_reg_260_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => gmem_addr_1_read_reg_2600,
      D => gmem_RDATA(27),
      Q => gmem_addr_1_read_reg_260(27),
      R => '0'
    );
\gmem_addr_1_read_reg_260_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => gmem_addr_1_read_reg_2600,
      D => gmem_RDATA(28),
      Q => gmem_addr_1_read_reg_260(28),
      R => '0'
    );
\gmem_addr_1_read_reg_260_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => gmem_addr_1_read_reg_2600,
      D => gmem_RDATA(29),
      Q => gmem_addr_1_read_reg_260(29),
      R => '0'
    );
\gmem_addr_1_read_reg_260_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => gmem_addr_1_read_reg_2600,
      D => gmem_RDATA(2),
      Q => gmem_addr_1_read_reg_260(2),
      R => '0'
    );
\gmem_addr_1_read_reg_260_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => gmem_addr_1_read_reg_2600,
      D => gmem_RDATA(30),
      Q => gmem_addr_1_read_reg_260(30),
      R => '0'
    );
\gmem_addr_1_read_reg_260_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => gmem_addr_1_read_reg_2600,
      D => gmem_RDATA(31),
      Q => gmem_addr_1_read_reg_260(31),
      R => '0'
    );
\gmem_addr_1_read_reg_260_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => gmem_addr_1_read_reg_2600,
      D => gmem_RDATA(3),
      Q => gmem_addr_1_read_reg_260(3),
      R => '0'
    );
\gmem_addr_1_read_reg_260_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => gmem_addr_1_read_reg_2600,
      D => gmem_RDATA(4),
      Q => gmem_addr_1_read_reg_260(4),
      R => '0'
    );
\gmem_addr_1_read_reg_260_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => gmem_addr_1_read_reg_2600,
      D => gmem_RDATA(5),
      Q => gmem_addr_1_read_reg_260(5),
      R => '0'
    );
\gmem_addr_1_read_reg_260_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => gmem_addr_1_read_reg_2600,
      D => gmem_RDATA(6),
      Q => gmem_addr_1_read_reg_260(6),
      R => '0'
    );
\gmem_addr_1_read_reg_260_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => gmem_addr_1_read_reg_2600,
      D => gmem_RDATA(7),
      Q => gmem_addr_1_read_reg_260(7),
      R => '0'
    );
\gmem_addr_1_read_reg_260_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => gmem_addr_1_read_reg_2600,
      D => gmem_RDATA(8),
      Q => gmem_addr_1_read_reg_260(8),
      R => '0'
    );
\gmem_addr_1_read_reg_260_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => gmem_addr_1_read_reg_2600,
      D => gmem_RDATA(9),
      Q => gmem_addr_1_read_reg_260(9),
      R => '0'
    );
\gmem_addr_reg_244_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_CS_fsm_state8,
      D => out_buf3_reg_228(0),
      Q => gmem_addr_reg_244(0),
      R => '0'
    );
\gmem_addr_reg_244_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_CS_fsm_state8,
      D => out_buf3_reg_228(10),
      Q => gmem_addr_reg_244(10),
      R => '0'
    );
\gmem_addr_reg_244_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_CS_fsm_state8,
      D => out_buf3_reg_228(11),
      Q => gmem_addr_reg_244(11),
      R => '0'
    );
\gmem_addr_reg_244_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_CS_fsm_state8,
      D => out_buf3_reg_228(12),
      Q => gmem_addr_reg_244(12),
      R => '0'
    );
\gmem_addr_reg_244_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_CS_fsm_state8,
      D => out_buf3_reg_228(13),
      Q => gmem_addr_reg_244(13),
      R => '0'
    );
\gmem_addr_reg_244_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_CS_fsm_state8,
      D => out_buf3_reg_228(14),
      Q => gmem_addr_reg_244(14),
      R => '0'
    );
\gmem_addr_reg_244_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_CS_fsm_state8,
      D => out_buf3_reg_228(15),
      Q => gmem_addr_reg_244(15),
      R => '0'
    );
\gmem_addr_reg_244_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_CS_fsm_state8,
      D => out_buf3_reg_228(16),
      Q => gmem_addr_reg_244(16),
      R => '0'
    );
\gmem_addr_reg_244_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_CS_fsm_state8,
      D => out_buf3_reg_228(17),
      Q => gmem_addr_reg_244(17),
      R => '0'
    );
\gmem_addr_reg_244_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_CS_fsm_state8,
      D => out_buf3_reg_228(18),
      Q => gmem_addr_reg_244(18),
      R => '0'
    );
\gmem_addr_reg_244_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_CS_fsm_state8,
      D => out_buf3_reg_228(19),
      Q => gmem_addr_reg_244(19),
      R => '0'
    );
\gmem_addr_reg_244_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_CS_fsm_state8,
      D => out_buf3_reg_228(1),
      Q => gmem_addr_reg_244(1),
      R => '0'
    );
\gmem_addr_reg_244_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_CS_fsm_state8,
      D => out_buf3_reg_228(20),
      Q => gmem_addr_reg_244(20),
      R => '0'
    );
\gmem_addr_reg_244_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_CS_fsm_state8,
      D => out_buf3_reg_228(21),
      Q => gmem_addr_reg_244(21),
      R => '0'
    );
\gmem_addr_reg_244_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_CS_fsm_state8,
      D => out_buf3_reg_228(22),
      Q => gmem_addr_reg_244(22),
      R => '0'
    );
\gmem_addr_reg_244_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_CS_fsm_state8,
      D => out_buf3_reg_228(23),
      Q => gmem_addr_reg_244(23),
      R => '0'
    );
\gmem_addr_reg_244_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_CS_fsm_state8,
      D => out_buf3_reg_228(24),
      Q => gmem_addr_reg_244(24),
      R => '0'
    );
\gmem_addr_reg_244_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_CS_fsm_state8,
      D => out_buf3_reg_228(25),
      Q => gmem_addr_reg_244(25),
      R => '0'
    );
\gmem_addr_reg_244_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_CS_fsm_state8,
      D => out_buf3_reg_228(26),
      Q => gmem_addr_reg_244(26),
      R => '0'
    );
\gmem_addr_reg_244_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_CS_fsm_state8,
      D => out_buf3_reg_228(27),
      Q => gmem_addr_reg_244(27),
      R => '0'
    );
\gmem_addr_reg_244_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_CS_fsm_state8,
      D => out_buf3_reg_228(28),
      Q => gmem_addr_reg_244(28),
      R => '0'
    );
\gmem_addr_reg_244_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_CS_fsm_state8,
      D => out_buf3_reg_228(29),
      Q => gmem_addr_reg_244(29),
      R => '0'
    );
\gmem_addr_reg_244_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_CS_fsm_state8,
      D => out_buf3_reg_228(2),
      Q => gmem_addr_reg_244(2),
      R => '0'
    );
\gmem_addr_reg_244_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_CS_fsm_state8,
      D => out_buf3_reg_228(3),
      Q => gmem_addr_reg_244(3),
      R => '0'
    );
\gmem_addr_reg_244_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_CS_fsm_state8,
      D => out_buf3_reg_228(4),
      Q => gmem_addr_reg_244(4),
      R => '0'
    );
\gmem_addr_reg_244_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_CS_fsm_state8,
      D => out_buf3_reg_228(5),
      Q => gmem_addr_reg_244(5),
      R => '0'
    );
\gmem_addr_reg_244_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_CS_fsm_state8,
      D => out_buf3_reg_228(6),
      Q => gmem_addr_reg_244(6),
      R => '0'
    );
\gmem_addr_reg_244_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_CS_fsm_state8,
      D => out_buf3_reg_228(7),
      Q => gmem_addr_reg_244(7),
      R => '0'
    );
\gmem_addr_reg_244_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_CS_fsm_state8,
      D => out_buf3_reg_228(8),
      Q => gmem_addr_reg_244(8),
      R => '0'
    );
\gmem_addr_reg_244_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_CS_fsm_state8,
      D => out_buf3_reg_228(9),
      Q => gmem_addr_reg_244(9),
      R => '0'
    );
\i_reg_137[0]_i_11\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => num_items_read_reg_222(22),
      I1 => i_reg_137_reg(22),
      I2 => num_items_read_reg_222(23),
      I3 => i_reg_137_reg(23),
      I4 => i_reg_137_reg(21),
      I5 => num_items_read_reg_222(21),
      O => \i_reg_137[0]_i_11_n_2\
    );
\i_reg_137[0]_i_12\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => num_items_read_reg_222(18),
      I1 => i_reg_137_reg(18),
      I2 => num_items_read_reg_222(20),
      I3 => i_reg_137_reg(20),
      I4 => i_reg_137_reg(19),
      I5 => num_items_read_reg_222(19),
      O => \i_reg_137[0]_i_12_n_2\
    );
\i_reg_137[0]_i_13\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => num_items_read_reg_222(15),
      I1 => i_reg_137_reg(15),
      I2 => num_items_read_reg_222(16),
      I3 => i_reg_137_reg(16),
      I4 => i_reg_137_reg(17),
      I5 => num_items_read_reg_222(17),
      O => \i_reg_137[0]_i_13_n_2\
    );
\i_reg_137[0]_i_14\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => num_items_read_reg_222(13),
      I1 => i_reg_137_reg(13),
      I2 => num_items_read_reg_222(14),
      I3 => i_reg_137_reg(14),
      I4 => i_reg_137_reg(12),
      I5 => num_items_read_reg_222(12),
      O => \i_reg_137[0]_i_14_n_2\
    );
\i_reg_137[0]_i_15\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => num_items_read_reg_222(10),
      I1 => i_reg_137_reg(10),
      I2 => num_items_read_reg_222(11),
      I3 => i_reg_137_reg(11),
      I4 => i_reg_137_reg(9),
      I5 => num_items_read_reg_222(9),
      O => \i_reg_137[0]_i_15_n_2\
    );
\i_reg_137[0]_i_16\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => num_items_read_reg_222(7),
      I1 => i_reg_137_reg(7),
      I2 => num_items_read_reg_222(8),
      I3 => i_reg_137_reg(8),
      I4 => i_reg_137_reg(6),
      I5 => num_items_read_reg_222(6),
      O => \i_reg_137[0]_i_16_n_2\
    );
\i_reg_137[0]_i_17\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => num_items_read_reg_222(3),
      I1 => i_reg_137_reg(3),
      I2 => num_items_read_reg_222(5),
      I3 => i_reg_137_reg(5),
      I4 => i_reg_137_reg(4),
      I5 => num_items_read_reg_222(4),
      O => \i_reg_137[0]_i_17_n_2\
    );
\i_reg_137[0]_i_18\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => i_reg_137_reg(0),
      I1 => num_items_read_reg_222(0),
      I2 => num_items_read_reg_222(2),
      I3 => i_reg_137_reg(2),
      I4 => i_reg_137_reg(1),
      I5 => num_items_read_reg_222(1),
      O => \i_reg_137[0]_i_18_n_2\
    );
\i_reg_137[0]_i_5\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => i_reg_137_reg(0),
      O => \i_reg_137[0]_i_5_n_2\
    );
\i_reg_137[0]_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => i_reg_137_reg(31),
      I1 => num_items_read_reg_222(31),
      I2 => i_reg_137_reg(30),
      I3 => num_items_read_reg_222(30),
      O => \i_reg_137[0]_i_7_n_2\
    );
\i_reg_137[0]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => num_items_read_reg_222(28),
      I1 => i_reg_137_reg(28),
      I2 => num_items_read_reg_222(29),
      I3 => i_reg_137_reg(29),
      I4 => i_reg_137_reg(27),
      I5 => num_items_read_reg_222(27),
      O => \i_reg_137[0]_i_8_n_2\
    );
\i_reg_137[0]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => num_items_read_reg_222(25),
      I1 => i_reg_137_reg(25),
      I2 => num_items_read_reg_222(26),
      I3 => i_reg_137_reg(26),
      I4 => i_reg_137_reg(24),
      I5 => num_items_read_reg_222(24),
      O => \i_reg_137[0]_i_9_n_2\
    );
\i_reg_137_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => i_reg_1370,
      D => \i_reg_137_reg[0]_i_3_n_9\,
      Q => i_reg_137_reg(0),
      R => i_reg_137
    );
\i_reg_137_reg[0]_i_10\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \i_reg_137_reg[0]_i_10_n_2\,
      CO(2) => \i_reg_137_reg[0]_i_10_n_3\,
      CO(1) => \i_reg_137_reg[0]_i_10_n_4\,
      CO(0) => \i_reg_137_reg[0]_i_10_n_5\,
      CYINIT => '1',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_i_reg_137_reg[0]_i_10_O_UNCONNECTED\(3 downto 0),
      S(3) => \i_reg_137[0]_i_15_n_2\,
      S(2) => \i_reg_137[0]_i_16_n_2\,
      S(1) => \i_reg_137[0]_i_17_n_2\,
      S(0) => \i_reg_137[0]_i_18_n_2\
    );
\i_reg_137_reg[0]_i_3\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \i_reg_137_reg[0]_i_3_n_2\,
      CO(2) => \i_reg_137_reg[0]_i_3_n_3\,
      CO(1) => \i_reg_137_reg[0]_i_3_n_4\,
      CO(0) => \i_reg_137_reg[0]_i_3_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0001",
      O(3) => \i_reg_137_reg[0]_i_3_n_6\,
      O(2) => \i_reg_137_reg[0]_i_3_n_7\,
      O(1) => \i_reg_137_reg[0]_i_3_n_8\,
      O(0) => \i_reg_137_reg[0]_i_3_n_9\,
      S(3 downto 1) => i_reg_137_reg(3 downto 1),
      S(0) => \i_reg_137[0]_i_5_n_2\
    );
\i_reg_137_reg[0]_i_4\: unisim.vcomponents.CARRY4
     port map (
      CI => \i_reg_137_reg[0]_i_6_n_2\,
      CO(3) => \NLW_i_reg_137_reg[0]_i_4_CO_UNCONNECTED\(3),
      CO(2) => ap_condition_pp0_exit_iter0_state9,
      CO(1) => \i_reg_137_reg[0]_i_4_n_4\,
      CO(0) => \i_reg_137_reg[0]_i_4_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_i_reg_137_reg[0]_i_4_O_UNCONNECTED\(3 downto 0),
      S(3) => '0',
      S(2) => \i_reg_137[0]_i_7_n_2\,
      S(1) => \i_reg_137[0]_i_8_n_2\,
      S(0) => \i_reg_137[0]_i_9_n_2\
    );
\i_reg_137_reg[0]_i_6\: unisim.vcomponents.CARRY4
     port map (
      CI => \i_reg_137_reg[0]_i_10_n_2\,
      CO(3) => \i_reg_137_reg[0]_i_6_n_2\,
      CO(2) => \i_reg_137_reg[0]_i_6_n_3\,
      CO(1) => \i_reg_137_reg[0]_i_6_n_4\,
      CO(0) => \i_reg_137_reg[0]_i_6_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_i_reg_137_reg[0]_i_6_O_UNCONNECTED\(3 downto 0),
      S(3) => \i_reg_137[0]_i_11_n_2\,
      S(2) => \i_reg_137[0]_i_12_n_2\,
      S(1) => \i_reg_137[0]_i_13_n_2\,
      S(0) => \i_reg_137[0]_i_14_n_2\
    );
\i_reg_137_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => i_reg_1370,
      D => \i_reg_137_reg[8]_i_1_n_7\,
      Q => i_reg_137_reg(10),
      R => i_reg_137
    );
\i_reg_137_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => i_reg_1370,
      D => \i_reg_137_reg[8]_i_1_n_6\,
      Q => i_reg_137_reg(11),
      R => i_reg_137
    );
\i_reg_137_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => i_reg_1370,
      D => \i_reg_137_reg[12]_i_1_n_9\,
      Q => i_reg_137_reg(12),
      R => i_reg_137
    );
\i_reg_137_reg[12]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \i_reg_137_reg[8]_i_1_n_2\,
      CO(3) => \i_reg_137_reg[12]_i_1_n_2\,
      CO(2) => \i_reg_137_reg[12]_i_1_n_3\,
      CO(1) => \i_reg_137_reg[12]_i_1_n_4\,
      CO(0) => \i_reg_137_reg[12]_i_1_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \i_reg_137_reg[12]_i_1_n_6\,
      O(2) => \i_reg_137_reg[12]_i_1_n_7\,
      O(1) => \i_reg_137_reg[12]_i_1_n_8\,
      O(0) => \i_reg_137_reg[12]_i_1_n_9\,
      S(3 downto 0) => i_reg_137_reg(15 downto 12)
    );
\i_reg_137_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => i_reg_1370,
      D => \i_reg_137_reg[12]_i_1_n_8\,
      Q => i_reg_137_reg(13),
      R => i_reg_137
    );
\i_reg_137_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => i_reg_1370,
      D => \i_reg_137_reg[12]_i_1_n_7\,
      Q => i_reg_137_reg(14),
      R => i_reg_137
    );
\i_reg_137_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => i_reg_1370,
      D => \i_reg_137_reg[12]_i_1_n_6\,
      Q => i_reg_137_reg(15),
      R => i_reg_137
    );
\i_reg_137_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => i_reg_1370,
      D => \i_reg_137_reg[16]_i_1_n_9\,
      Q => i_reg_137_reg(16),
      R => i_reg_137
    );
\i_reg_137_reg[16]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \i_reg_137_reg[12]_i_1_n_2\,
      CO(3) => \i_reg_137_reg[16]_i_1_n_2\,
      CO(2) => \i_reg_137_reg[16]_i_1_n_3\,
      CO(1) => \i_reg_137_reg[16]_i_1_n_4\,
      CO(0) => \i_reg_137_reg[16]_i_1_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \i_reg_137_reg[16]_i_1_n_6\,
      O(2) => \i_reg_137_reg[16]_i_1_n_7\,
      O(1) => \i_reg_137_reg[16]_i_1_n_8\,
      O(0) => \i_reg_137_reg[16]_i_1_n_9\,
      S(3 downto 0) => i_reg_137_reg(19 downto 16)
    );
\i_reg_137_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => i_reg_1370,
      D => \i_reg_137_reg[16]_i_1_n_8\,
      Q => i_reg_137_reg(17),
      R => i_reg_137
    );
\i_reg_137_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => i_reg_1370,
      D => \i_reg_137_reg[16]_i_1_n_7\,
      Q => i_reg_137_reg(18),
      R => i_reg_137
    );
\i_reg_137_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => i_reg_1370,
      D => \i_reg_137_reg[16]_i_1_n_6\,
      Q => i_reg_137_reg(19),
      R => i_reg_137
    );
\i_reg_137_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => i_reg_1370,
      D => \i_reg_137_reg[0]_i_3_n_8\,
      Q => i_reg_137_reg(1),
      R => i_reg_137
    );
\i_reg_137_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => i_reg_1370,
      D => \i_reg_137_reg[20]_i_1_n_9\,
      Q => i_reg_137_reg(20),
      R => i_reg_137
    );
\i_reg_137_reg[20]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \i_reg_137_reg[16]_i_1_n_2\,
      CO(3) => \i_reg_137_reg[20]_i_1_n_2\,
      CO(2) => \i_reg_137_reg[20]_i_1_n_3\,
      CO(1) => \i_reg_137_reg[20]_i_1_n_4\,
      CO(0) => \i_reg_137_reg[20]_i_1_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \i_reg_137_reg[20]_i_1_n_6\,
      O(2) => \i_reg_137_reg[20]_i_1_n_7\,
      O(1) => \i_reg_137_reg[20]_i_1_n_8\,
      O(0) => \i_reg_137_reg[20]_i_1_n_9\,
      S(3 downto 0) => i_reg_137_reg(23 downto 20)
    );
\i_reg_137_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => i_reg_1370,
      D => \i_reg_137_reg[20]_i_1_n_8\,
      Q => i_reg_137_reg(21),
      R => i_reg_137
    );
\i_reg_137_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => i_reg_1370,
      D => \i_reg_137_reg[20]_i_1_n_7\,
      Q => i_reg_137_reg(22),
      R => i_reg_137
    );
\i_reg_137_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => i_reg_1370,
      D => \i_reg_137_reg[20]_i_1_n_6\,
      Q => i_reg_137_reg(23),
      R => i_reg_137
    );
\i_reg_137_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => i_reg_1370,
      D => \i_reg_137_reg[24]_i_1_n_9\,
      Q => i_reg_137_reg(24),
      R => i_reg_137
    );
\i_reg_137_reg[24]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \i_reg_137_reg[20]_i_1_n_2\,
      CO(3) => \i_reg_137_reg[24]_i_1_n_2\,
      CO(2) => \i_reg_137_reg[24]_i_1_n_3\,
      CO(1) => \i_reg_137_reg[24]_i_1_n_4\,
      CO(0) => \i_reg_137_reg[24]_i_1_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \i_reg_137_reg[24]_i_1_n_6\,
      O(2) => \i_reg_137_reg[24]_i_1_n_7\,
      O(1) => \i_reg_137_reg[24]_i_1_n_8\,
      O(0) => \i_reg_137_reg[24]_i_1_n_9\,
      S(3 downto 0) => i_reg_137_reg(27 downto 24)
    );
\i_reg_137_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => i_reg_1370,
      D => \i_reg_137_reg[24]_i_1_n_8\,
      Q => i_reg_137_reg(25),
      R => i_reg_137
    );
\i_reg_137_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => i_reg_1370,
      D => \i_reg_137_reg[24]_i_1_n_7\,
      Q => i_reg_137_reg(26),
      R => i_reg_137
    );
\i_reg_137_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => i_reg_1370,
      D => \i_reg_137_reg[24]_i_1_n_6\,
      Q => i_reg_137_reg(27),
      R => i_reg_137
    );
\i_reg_137_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => i_reg_1370,
      D => \i_reg_137_reg[28]_i_1_n_9\,
      Q => i_reg_137_reg(28),
      R => i_reg_137
    );
\i_reg_137_reg[28]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \i_reg_137_reg[24]_i_1_n_2\,
      CO(3) => \NLW_i_reg_137_reg[28]_i_1_CO_UNCONNECTED\(3),
      CO(2) => \i_reg_137_reg[28]_i_1_n_3\,
      CO(1) => \i_reg_137_reg[28]_i_1_n_4\,
      CO(0) => \i_reg_137_reg[28]_i_1_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \i_reg_137_reg[28]_i_1_n_6\,
      O(2) => \i_reg_137_reg[28]_i_1_n_7\,
      O(1) => \i_reg_137_reg[28]_i_1_n_8\,
      O(0) => \i_reg_137_reg[28]_i_1_n_9\,
      S(3 downto 0) => i_reg_137_reg(31 downto 28)
    );
\i_reg_137_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => i_reg_1370,
      D => \i_reg_137_reg[28]_i_1_n_8\,
      Q => i_reg_137_reg(29),
      R => i_reg_137
    );
\i_reg_137_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => i_reg_1370,
      D => \i_reg_137_reg[0]_i_3_n_7\,
      Q => i_reg_137_reg(2),
      R => i_reg_137
    );
\i_reg_137_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => i_reg_1370,
      D => \i_reg_137_reg[28]_i_1_n_7\,
      Q => i_reg_137_reg(30),
      R => i_reg_137
    );
\i_reg_137_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => i_reg_1370,
      D => \i_reg_137_reg[28]_i_1_n_6\,
      Q => i_reg_137_reg(31),
      R => i_reg_137
    );
\i_reg_137_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => i_reg_1370,
      D => \i_reg_137_reg[0]_i_3_n_6\,
      Q => i_reg_137_reg(3),
      R => i_reg_137
    );
\i_reg_137_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => i_reg_1370,
      D => \i_reg_137_reg[4]_i_1_n_9\,
      Q => i_reg_137_reg(4),
      R => i_reg_137
    );
\i_reg_137_reg[4]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \i_reg_137_reg[0]_i_3_n_2\,
      CO(3) => \i_reg_137_reg[4]_i_1_n_2\,
      CO(2) => \i_reg_137_reg[4]_i_1_n_3\,
      CO(1) => \i_reg_137_reg[4]_i_1_n_4\,
      CO(0) => \i_reg_137_reg[4]_i_1_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \i_reg_137_reg[4]_i_1_n_6\,
      O(2) => \i_reg_137_reg[4]_i_1_n_7\,
      O(1) => \i_reg_137_reg[4]_i_1_n_8\,
      O(0) => \i_reg_137_reg[4]_i_1_n_9\,
      S(3 downto 0) => i_reg_137_reg(7 downto 4)
    );
\i_reg_137_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => i_reg_1370,
      D => \i_reg_137_reg[4]_i_1_n_8\,
      Q => i_reg_137_reg(5),
      R => i_reg_137
    );
\i_reg_137_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => i_reg_1370,
      D => \i_reg_137_reg[4]_i_1_n_7\,
      Q => i_reg_137_reg(6),
      R => i_reg_137
    );
\i_reg_137_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => i_reg_1370,
      D => \i_reg_137_reg[4]_i_1_n_6\,
      Q => i_reg_137_reg(7),
      R => i_reg_137
    );
\i_reg_137_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => i_reg_1370,
      D => \i_reg_137_reg[8]_i_1_n_9\,
      Q => i_reg_137_reg(8),
      R => i_reg_137
    );
\i_reg_137_reg[8]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \i_reg_137_reg[4]_i_1_n_2\,
      CO(3) => \i_reg_137_reg[8]_i_1_n_2\,
      CO(2) => \i_reg_137_reg[8]_i_1_n_3\,
      CO(1) => \i_reg_137_reg[8]_i_1_n_4\,
      CO(0) => \i_reg_137_reg[8]_i_1_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \i_reg_137_reg[8]_i_1_n_6\,
      O(2) => \i_reg_137_reg[8]_i_1_n_7\,
      O(1) => \i_reg_137_reg[8]_i_1_n_8\,
      O(0) => \i_reg_137_reg[8]_i_1_n_9\,
      S(3 downto 0) => i_reg_137_reg(11 downto 8)
    );
\i_reg_137_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => i_reg_1370,
      D => \i_reg_137_reg[8]_i_1_n_8\,
      Q => i_reg_137_reg(9),
      R => i_reg_137
    );
\in_buf1_reg_233_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => in_buf(2),
      Q => in_buf1_reg_233(0),
      R => '0'
    );
\in_buf1_reg_233_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => in_buf(12),
      Q => in_buf1_reg_233(10),
      R => '0'
    );
\in_buf1_reg_233_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => in_buf(13),
      Q => in_buf1_reg_233(11),
      R => '0'
    );
\in_buf1_reg_233_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => in_buf(14),
      Q => in_buf1_reg_233(12),
      R => '0'
    );
\in_buf1_reg_233_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => in_buf(15),
      Q => in_buf1_reg_233(13),
      R => '0'
    );
\in_buf1_reg_233_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => in_buf(16),
      Q => in_buf1_reg_233(14),
      R => '0'
    );
\in_buf1_reg_233_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => in_buf(17),
      Q => in_buf1_reg_233(15),
      R => '0'
    );
\in_buf1_reg_233_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => in_buf(18),
      Q => in_buf1_reg_233(16),
      R => '0'
    );
\in_buf1_reg_233_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => in_buf(19),
      Q => in_buf1_reg_233(17),
      R => '0'
    );
\in_buf1_reg_233_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => in_buf(20),
      Q => in_buf1_reg_233(18),
      R => '0'
    );
\in_buf1_reg_233_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => in_buf(21),
      Q => in_buf1_reg_233(19),
      R => '0'
    );
\in_buf1_reg_233_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => in_buf(3),
      Q => in_buf1_reg_233(1),
      R => '0'
    );
\in_buf1_reg_233_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => in_buf(22),
      Q => in_buf1_reg_233(20),
      R => '0'
    );
\in_buf1_reg_233_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => in_buf(23),
      Q => in_buf1_reg_233(21),
      R => '0'
    );
\in_buf1_reg_233_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => in_buf(24),
      Q => in_buf1_reg_233(22),
      R => '0'
    );
\in_buf1_reg_233_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => in_buf(25),
      Q => in_buf1_reg_233(23),
      R => '0'
    );
\in_buf1_reg_233_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => in_buf(26),
      Q => in_buf1_reg_233(24),
      R => '0'
    );
\in_buf1_reg_233_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => in_buf(27),
      Q => in_buf1_reg_233(25),
      R => '0'
    );
\in_buf1_reg_233_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => in_buf(28),
      Q => in_buf1_reg_233(26),
      R => '0'
    );
\in_buf1_reg_233_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => in_buf(29),
      Q => in_buf1_reg_233(27),
      R => '0'
    );
\in_buf1_reg_233_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => in_buf(30),
      Q => in_buf1_reg_233(28),
      R => '0'
    );
\in_buf1_reg_233_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => in_buf(31),
      Q => in_buf1_reg_233(29),
      R => '0'
    );
\in_buf1_reg_233_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => in_buf(4),
      Q => in_buf1_reg_233(2),
      R => '0'
    );
\in_buf1_reg_233_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => in_buf(5),
      Q => in_buf1_reg_233(3),
      R => '0'
    );
\in_buf1_reg_233_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => in_buf(6),
      Q => in_buf1_reg_233(4),
      R => '0'
    );
\in_buf1_reg_233_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => in_buf(7),
      Q => in_buf1_reg_233(5),
      R => '0'
    );
\in_buf1_reg_233_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => in_buf(8),
      Q => in_buf1_reg_233(6),
      R => '0'
    );
\in_buf1_reg_233_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => in_buf(9),
      Q => in_buf1_reg_233(7),
      R => '0'
    );
\in_buf1_reg_233_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => in_buf(10),
      Q => in_buf1_reg_233(8),
      R => '0'
    );
\in_buf1_reg_233_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => in_buf(11),
      Q => in_buf1_reg_233(9),
      R => '0'
    );
\num_items_read_reg_222_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => num_items(0),
      Q => num_items_read_reg_222(0),
      R => '0'
    );
\num_items_read_reg_222_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => num_items(10),
      Q => num_items_read_reg_222(10),
      R => '0'
    );
\num_items_read_reg_222_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => num_items(11),
      Q => num_items_read_reg_222(11),
      R => '0'
    );
\num_items_read_reg_222_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => num_items(12),
      Q => num_items_read_reg_222(12),
      R => '0'
    );
\num_items_read_reg_222_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => num_items(13),
      Q => num_items_read_reg_222(13),
      R => '0'
    );
\num_items_read_reg_222_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => num_items(14),
      Q => num_items_read_reg_222(14),
      R => '0'
    );
\num_items_read_reg_222_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => num_items(15),
      Q => num_items_read_reg_222(15),
      R => '0'
    );
\num_items_read_reg_222_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => num_items(16),
      Q => num_items_read_reg_222(16),
      R => '0'
    );
\num_items_read_reg_222_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => num_items(17),
      Q => num_items_read_reg_222(17),
      R => '0'
    );
\num_items_read_reg_222_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => num_items(18),
      Q => num_items_read_reg_222(18),
      R => '0'
    );
\num_items_read_reg_222_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => num_items(19),
      Q => num_items_read_reg_222(19),
      R => '0'
    );
\num_items_read_reg_222_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => num_items(1),
      Q => num_items_read_reg_222(1),
      R => '0'
    );
\num_items_read_reg_222_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => num_items(20),
      Q => num_items_read_reg_222(20),
      R => '0'
    );
\num_items_read_reg_222_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => num_items(21),
      Q => num_items_read_reg_222(21),
      R => '0'
    );
\num_items_read_reg_222_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => num_items(22),
      Q => num_items_read_reg_222(22),
      R => '0'
    );
\num_items_read_reg_222_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => num_items(23),
      Q => num_items_read_reg_222(23),
      R => '0'
    );
\num_items_read_reg_222_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => num_items(24),
      Q => num_items_read_reg_222(24),
      R => '0'
    );
\num_items_read_reg_222_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => num_items(25),
      Q => num_items_read_reg_222(25),
      R => '0'
    );
\num_items_read_reg_222_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => num_items(26),
      Q => num_items_read_reg_222(26),
      R => '0'
    );
\num_items_read_reg_222_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => num_items(27),
      Q => num_items_read_reg_222(27),
      R => '0'
    );
\num_items_read_reg_222_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => num_items(28),
      Q => num_items_read_reg_222(28),
      R => '0'
    );
\num_items_read_reg_222_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => num_items(29),
      Q => num_items_read_reg_222(29),
      R => '0'
    );
\num_items_read_reg_222_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => num_items(2),
      Q => num_items_read_reg_222(2),
      R => '0'
    );
\num_items_read_reg_222_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => num_items(30),
      Q => num_items_read_reg_222(30),
      R => '0'
    );
\num_items_read_reg_222_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => num_items(31),
      Q => num_items_read_reg_222(31),
      R => '0'
    );
\num_items_read_reg_222_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => num_items(3),
      Q => num_items_read_reg_222(3),
      R => '0'
    );
\num_items_read_reg_222_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => num_items(4),
      Q => num_items_read_reg_222(4),
      R => '0'
    );
\num_items_read_reg_222_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => num_items(5),
      Q => num_items_read_reg_222(5),
      R => '0'
    );
\num_items_read_reg_222_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => num_items(6),
      Q => num_items_read_reg_222(6),
      R => '0'
    );
\num_items_read_reg_222_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => num_items(7),
      Q => num_items_read_reg_222(7),
      R => '0'
    );
\num_items_read_reg_222_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => num_items(8),
      Q => num_items_read_reg_222(8),
      R => '0'
    );
\num_items_read_reg_222_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => num_items(9),
      Q => num_items_read_reg_222(9),
      R => '0'
    );
\out_buf3_reg_228_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => out_buf(2),
      Q => out_buf3_reg_228(0),
      R => '0'
    );
\out_buf3_reg_228_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => out_buf(12),
      Q => out_buf3_reg_228(10),
      R => '0'
    );
\out_buf3_reg_228_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => out_buf(13),
      Q => out_buf3_reg_228(11),
      R => '0'
    );
\out_buf3_reg_228_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => out_buf(14),
      Q => out_buf3_reg_228(12),
      R => '0'
    );
\out_buf3_reg_228_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => out_buf(15),
      Q => out_buf3_reg_228(13),
      R => '0'
    );
\out_buf3_reg_228_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => out_buf(16),
      Q => out_buf3_reg_228(14),
      R => '0'
    );
\out_buf3_reg_228_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => out_buf(17),
      Q => out_buf3_reg_228(15),
      R => '0'
    );
\out_buf3_reg_228_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => out_buf(18),
      Q => out_buf3_reg_228(16),
      R => '0'
    );
\out_buf3_reg_228_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => out_buf(19),
      Q => out_buf3_reg_228(17),
      R => '0'
    );
\out_buf3_reg_228_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => out_buf(20),
      Q => out_buf3_reg_228(18),
      R => '0'
    );
\out_buf3_reg_228_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => out_buf(21),
      Q => out_buf3_reg_228(19),
      R => '0'
    );
\out_buf3_reg_228_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => out_buf(3),
      Q => out_buf3_reg_228(1),
      R => '0'
    );
\out_buf3_reg_228_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => out_buf(22),
      Q => out_buf3_reg_228(20),
      R => '0'
    );
\out_buf3_reg_228_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => out_buf(23),
      Q => out_buf3_reg_228(21),
      R => '0'
    );
\out_buf3_reg_228_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => out_buf(24),
      Q => out_buf3_reg_228(22),
      R => '0'
    );
\out_buf3_reg_228_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => out_buf(25),
      Q => out_buf3_reg_228(23),
      R => '0'
    );
\out_buf3_reg_228_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => out_buf(26),
      Q => out_buf3_reg_228(24),
      R => '0'
    );
\out_buf3_reg_228_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => out_buf(27),
      Q => out_buf3_reg_228(25),
      R => '0'
    );
\out_buf3_reg_228_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => out_buf(28),
      Q => out_buf3_reg_228(26),
      R => '0'
    );
\out_buf3_reg_228_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => out_buf(29),
      Q => out_buf3_reg_228(27),
      R => '0'
    );
\out_buf3_reg_228_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => out_buf(30),
      Q => out_buf3_reg_228(28),
      R => '0'
    );
\out_buf3_reg_228_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => out_buf(31),
      Q => out_buf3_reg_228(29),
      R => '0'
    );
\out_buf3_reg_228_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => out_buf(4),
      Q => out_buf3_reg_228(2),
      R => '0'
    );
\out_buf3_reg_228_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => out_buf(5),
      Q => out_buf3_reg_228(3),
      R => '0'
    );
\out_buf3_reg_228_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => out_buf(6),
      Q => out_buf3_reg_228(4),
      R => '0'
    );
\out_buf3_reg_228_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => out_buf(7),
      Q => out_buf3_reg_228(5),
      R => '0'
    );
\out_buf3_reg_228_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => out_buf(8),
      Q => out_buf3_reg_228(6),
      R => '0'
    );
\out_buf3_reg_228_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => out_buf(9),
      Q => out_buf3_reg_228(7),
      R => '0'
    );
\out_buf3_reg_228_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => out_buf(10),
      Q => out_buf3_reg_228(8),
      R => '0'
    );
\out_buf3_reg_228_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm120_out,
      D => out_buf(11),
      Q => out_buf3_reg_228(9),
      R => '0'
    );
simple_accel_core_control_s_axi_U: entity work.design_1_simple_accel_core_0_3_simple_accel_core_control_s_axi
     port map (
      D(0) => ap_NS_fsm(1),
      E(0) => ap_NS_fsm120_out,
      \FSM_onehot_rstate_reg[1]_0\ => s_axi_control_ARREADY,
      \FSM_onehot_wstate_reg[1]_0\ => s_axi_control_AWREADY,
      \FSM_onehot_wstate_reg[2]_0\ => s_axi_control_WREADY,
      Q(31 downto 0) => num_items(31 downto 0),
      SR(0) => ap_rst_n_inv,
      \ap_CS_fsm_reg[1]\ => \ap_CS_fsm[1]_i_2_n_2\,
      \ap_CS_fsm_reg[1]_0\ => \ap_CS_fsm[1]_i_3_n_2\,
      \ap_CS_fsm_reg[1]_1\(0) => \bus_read/rs_rreq/load_p2\,
      ap_clk => ap_clk,
      ap_done => ap_done,
      ap_start => ap_start,
      gmem_BVALID => gmem_BVALID,
      int_ap_start_reg_0(3) => ap_CS_fsm_state19,
      int_ap_start_reg_0(2) => \ap_CS_fsm_reg_n_2_[6]\,
      int_ap_start_reg_0(1) => \ap_CS_fsm_reg_n_2_[2]\,
      int_ap_start_reg_0(0) => \ap_CS_fsm_reg_n_2_[0]\,
      \int_in_buf_reg[31]_0\(29 downto 0) => in_buf(31 downto 2),
      \int_out_buf_reg[31]_0\(29 downto 0) => out_buf(31 downto 2),
      interrupt => interrupt,
      s_axi_control_ARADDR(5 downto 0) => s_axi_control_ARADDR(5 downto 0),
      s_axi_control_ARVALID => s_axi_control_ARVALID,
      s_axi_control_AWADDR(5 downto 0) => s_axi_control_AWADDR(5 downto 0),
      s_axi_control_AWVALID => s_axi_control_AWVALID,
      s_axi_control_BREADY => s_axi_control_BREADY,
      s_axi_control_BVALID => s_axi_control_BVALID,
      s_axi_control_RDATA(31 downto 0) => s_axi_control_RDATA(31 downto 0),
      s_axi_control_RREADY => s_axi_control_RREADY,
      s_axi_control_RVALID => s_axi_control_RVALID,
      s_axi_control_WDATA(31 downto 0) => s_axi_control_WDATA(31 downto 0),
      s_axi_control_WSTRB(3 downto 0) => s_axi_control_WSTRB(3 downto 0),
      s_axi_control_WVALID => s_axi_control_WVALID
    );
simple_accel_core_gmem_m_axi_U: entity work.design_1_simple_accel_core_0_3_simple_accel_core_gmem_m_axi
     port map (
      CO(0) => ap_condition_pp0_exit_iter0_state9,
      D(32) => m_axi_gmem_RLAST,
      D(31 downto 0) => m_axi_gmem_RDATA(31 downto 0),
      E(0) => gmem_addr_1_read_reg_2600,
      Q(8) => ap_CS_fsm_state19,
      Q(7) => \ap_CS_fsm_reg_n_2_[15]\,
      Q(6) => ap_CS_fsm_state14,
      Q(5) => ap_CS_fsm_state13,
      Q(4) => ap_CS_fsm_state12,
      Q(3) => ap_CS_fsm_pp0_stage0,
      Q(2) => ap_CS_fsm_state8,
      Q(1) => ap_CS_fsm_state2,
      Q(0) => \ap_CS_fsm_reg_n_2_[0]\,
      SR(0) => ap_rst_n_inv,
      \ap_CS_fsm_reg[10]\(0) => ap_NS_fsm112_out,
      \ap_CS_fsm_reg[15]\(6) => ap_NS_fsm(16),
      \ap_CS_fsm_reg[15]\(5 downto 2) => ap_NS_fsm(12 downto 9),
      \ap_CS_fsm_reg[15]\(1) => \bus_read/rs_rreq/load_p2\,
      \ap_CS_fsm_reg[15]\(0) => ap_NS_fsm(0),
      \ap_CS_fsm_reg[7]\ => simple_accel_core_gmem_m_axi_U_n_10,
      \ap_CS_fsm_reg[8]\ => simple_accel_core_gmem_m_axi_U_n_29,
      \ap_CS_fsm_reg[8]_0\ => simple_accel_core_gmem_m_axi_U_n_91,
      \ap_CS_fsm_reg[8]_1\ => simple_accel_core_gmem_m_axi_U_n_92,
      \ap_CS_fsm_reg[9]\ => \ap_CS_fsm[9]_i_2_n_2\,
      ap_clk => ap_clk,
      ap_done => ap_done,
      ap_enable_reg_pp0_iter0 => ap_enable_reg_pp0_iter0,
      ap_enable_reg_pp0_iter1_reg => ap_enable_reg_pp0_iter1_reg_n_2,
      ap_enable_reg_pp0_iter1_reg_0 => \exitcond_reg_251_reg_n_2_[0]\,
      ap_enable_reg_pp0_iter2_reg => ap_enable_reg_pp0_iter2_reg_n_2,
      ap_reg_ioackin_gmem_WREADY => ap_reg_ioackin_gmem_WREADY,
      ap_rst_n => ap_rst_n,
      ap_start => ap_start,
      \bus_equal_gen.WVALID_Dummy_reg\ => m_axi_gmem_WVALID,
      \could_multi_bursts.ARVALID_Dummy_reg\ => m_axi_gmem_ARVALID,
      \could_multi_bursts.arlen_buf_reg[3]\(3 downto 0) => \^m_axi_gmem_arlen\(3 downto 0),
      \could_multi_bursts.awlen_buf_reg[3]\(3 downto 0) => \^m_axi_gmem_awlen\(3 downto 0),
      \data_p1_reg[31]\(31 downto 0) => gmem_RDATA(31 downto 0),
      \data_p2_reg[29]\(29 downto 0) => gmem_addr_reg_244(29 downto 0),
      \data_p2_reg[63]\(61 downto 30) => num_items_read_reg_222(31 downto 0),
      \data_p2_reg[63]\(29 downto 0) => in_buf1_reg_233(29 downto 0),
      exitcond_reg_251_pp0_iter1_reg => exitcond_reg_251_pp0_iter1_reg,
      full_n_reg => m_axi_gmem_RREADY,
      full_n_reg_0 => m_axi_gmem_BREADY,
      gmem_BVALID => gmem_BVALID,
      i_reg_137 => i_reg_137,
      i_reg_1370 => i_reg_1370,
      m_axi_gmem_ARADDR(29 downto 0) => \^m_axi_gmem_araddr\(31 downto 2),
      m_axi_gmem_ARREADY => m_axi_gmem_ARREADY,
      m_axi_gmem_AWADDR(29 downto 0) => \^m_axi_gmem_awaddr\(31 downto 2),
      m_axi_gmem_AWREADY => m_axi_gmem_AWREADY,
      m_axi_gmem_AWVALID => m_axi_gmem_AWVALID,
      m_axi_gmem_BVALID => m_axi_gmem_BVALID,
      m_axi_gmem_RRESP(1 downto 0) => m_axi_gmem_RRESP(1 downto 0),
      m_axi_gmem_RVALID => m_axi_gmem_RVALID,
      m_axi_gmem_WDATA(31 downto 0) => m_axi_gmem_WDATA(31 downto 0),
      m_axi_gmem_WLAST => m_axi_gmem_WLAST,
      m_axi_gmem_WREADY => m_axi_gmem_WREADY,
      m_axi_gmem_WSTRB(3 downto 0) => m_axi_gmem_WSTRB(3 downto 0),
      mem_reg(31 downto 0) => tmp_2_reg_270(31 downto 0),
      \out\(31 downto 0) => \sum_reg_125_reg__0\(31 downto 0),
      \state_reg[0]\ => simple_accel_core_gmem_m_axi_U_n_9,
      sum_reg_125 => sum_reg_125,
      sum_reg_1250 => sum_reg_1250
    );
\sum_reg_125[0]_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => gmem_addr_1_read_reg_260(3),
      I1 => \sum_reg_125_reg__0\(3),
      O => \sum_reg_125[0]_i_4_n_2\
    );
\sum_reg_125[0]_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => gmem_addr_1_read_reg_260(2),
      I1 => \sum_reg_125_reg__0\(2),
      O => \sum_reg_125[0]_i_5_n_2\
    );
\sum_reg_125[0]_i_6\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => gmem_addr_1_read_reg_260(1),
      I1 => \sum_reg_125_reg__0\(1),
      O => \sum_reg_125[0]_i_6_n_2\
    );
\sum_reg_125[0]_i_7\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => gmem_addr_1_read_reg_260(0),
      I1 => \sum_reg_125_reg__0\(0),
      O => \sum_reg_125[0]_i_7_n_2\
    );
\sum_reg_125[12]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => gmem_addr_1_read_reg_260(15),
      I1 => \sum_reg_125_reg__0\(15),
      O => \sum_reg_125[12]_i_2_n_2\
    );
\sum_reg_125[12]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => gmem_addr_1_read_reg_260(14),
      I1 => \sum_reg_125_reg__0\(14),
      O => \sum_reg_125[12]_i_3_n_2\
    );
\sum_reg_125[12]_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => gmem_addr_1_read_reg_260(13),
      I1 => \sum_reg_125_reg__0\(13),
      O => \sum_reg_125[12]_i_4_n_2\
    );
\sum_reg_125[12]_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => gmem_addr_1_read_reg_260(12),
      I1 => \sum_reg_125_reg__0\(12),
      O => \sum_reg_125[12]_i_5_n_2\
    );
\sum_reg_125[16]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => gmem_addr_1_read_reg_260(19),
      I1 => \sum_reg_125_reg__0\(19),
      O => \sum_reg_125[16]_i_2_n_2\
    );
\sum_reg_125[16]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => gmem_addr_1_read_reg_260(18),
      I1 => \sum_reg_125_reg__0\(18),
      O => \sum_reg_125[16]_i_3_n_2\
    );
\sum_reg_125[16]_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => gmem_addr_1_read_reg_260(17),
      I1 => \sum_reg_125_reg__0\(17),
      O => \sum_reg_125[16]_i_4_n_2\
    );
\sum_reg_125[16]_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => gmem_addr_1_read_reg_260(16),
      I1 => \sum_reg_125_reg__0\(16),
      O => \sum_reg_125[16]_i_5_n_2\
    );
\sum_reg_125[20]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => gmem_addr_1_read_reg_260(23),
      I1 => \sum_reg_125_reg__0\(23),
      O => \sum_reg_125[20]_i_2_n_2\
    );
\sum_reg_125[20]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => gmem_addr_1_read_reg_260(22),
      I1 => \sum_reg_125_reg__0\(22),
      O => \sum_reg_125[20]_i_3_n_2\
    );
\sum_reg_125[20]_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => gmem_addr_1_read_reg_260(21),
      I1 => \sum_reg_125_reg__0\(21),
      O => \sum_reg_125[20]_i_4_n_2\
    );
\sum_reg_125[20]_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => gmem_addr_1_read_reg_260(20),
      I1 => \sum_reg_125_reg__0\(20),
      O => \sum_reg_125[20]_i_5_n_2\
    );
\sum_reg_125[24]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => gmem_addr_1_read_reg_260(27),
      I1 => \sum_reg_125_reg__0\(27),
      O => \sum_reg_125[24]_i_2_n_2\
    );
\sum_reg_125[24]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => gmem_addr_1_read_reg_260(26),
      I1 => \sum_reg_125_reg__0\(26),
      O => \sum_reg_125[24]_i_3_n_2\
    );
\sum_reg_125[24]_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => gmem_addr_1_read_reg_260(25),
      I1 => \sum_reg_125_reg__0\(25),
      O => \sum_reg_125[24]_i_4_n_2\
    );
\sum_reg_125[24]_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => gmem_addr_1_read_reg_260(24),
      I1 => \sum_reg_125_reg__0\(24),
      O => \sum_reg_125[24]_i_5_n_2\
    );
\sum_reg_125[28]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => gmem_addr_1_read_reg_260(31),
      I1 => \sum_reg_125_reg__0\(31),
      O => \sum_reg_125[28]_i_2_n_2\
    );
\sum_reg_125[28]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => gmem_addr_1_read_reg_260(30),
      I1 => \sum_reg_125_reg__0\(30),
      O => \sum_reg_125[28]_i_3_n_2\
    );
\sum_reg_125[28]_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => gmem_addr_1_read_reg_260(29),
      I1 => \sum_reg_125_reg__0\(29),
      O => \sum_reg_125[28]_i_4_n_2\
    );
\sum_reg_125[28]_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => gmem_addr_1_read_reg_260(28),
      I1 => \sum_reg_125_reg__0\(28),
      O => \sum_reg_125[28]_i_5_n_2\
    );
\sum_reg_125[4]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => gmem_addr_1_read_reg_260(7),
      I1 => \sum_reg_125_reg__0\(7),
      O => \sum_reg_125[4]_i_2_n_2\
    );
\sum_reg_125[4]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => gmem_addr_1_read_reg_260(6),
      I1 => \sum_reg_125_reg__0\(6),
      O => \sum_reg_125[4]_i_3_n_2\
    );
\sum_reg_125[4]_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => gmem_addr_1_read_reg_260(5),
      I1 => \sum_reg_125_reg__0\(5),
      O => \sum_reg_125[4]_i_4_n_2\
    );
\sum_reg_125[4]_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => gmem_addr_1_read_reg_260(4),
      I1 => \sum_reg_125_reg__0\(4),
      O => \sum_reg_125[4]_i_5_n_2\
    );
\sum_reg_125[8]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => gmem_addr_1_read_reg_260(11),
      I1 => \sum_reg_125_reg__0\(11),
      O => \sum_reg_125[8]_i_2_n_2\
    );
\sum_reg_125[8]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => gmem_addr_1_read_reg_260(10),
      I1 => \sum_reg_125_reg__0\(10),
      O => \sum_reg_125[8]_i_3_n_2\
    );
\sum_reg_125[8]_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => gmem_addr_1_read_reg_260(9),
      I1 => \sum_reg_125_reg__0\(9),
      O => \sum_reg_125[8]_i_4_n_2\
    );
\sum_reg_125[8]_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => gmem_addr_1_read_reg_260(8),
      I1 => \sum_reg_125_reg__0\(8),
      O => \sum_reg_125[8]_i_5_n_2\
    );
\sum_reg_125_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[0]_i_3_n_9\,
      Q => \sum_reg_125_reg__0\(0),
      R => sum_reg_125
    );
\sum_reg_125_reg[0]_i_3\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \sum_reg_125_reg[0]_i_3_n_2\,
      CO(2) => \sum_reg_125_reg[0]_i_3_n_3\,
      CO(1) => \sum_reg_125_reg[0]_i_3_n_4\,
      CO(0) => \sum_reg_125_reg[0]_i_3_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => gmem_addr_1_read_reg_260(3 downto 0),
      O(3) => \sum_reg_125_reg[0]_i_3_n_6\,
      O(2) => \sum_reg_125_reg[0]_i_3_n_7\,
      O(1) => \sum_reg_125_reg[0]_i_3_n_8\,
      O(0) => \sum_reg_125_reg[0]_i_3_n_9\,
      S(3) => \sum_reg_125[0]_i_4_n_2\,
      S(2) => \sum_reg_125[0]_i_5_n_2\,
      S(1) => \sum_reg_125[0]_i_6_n_2\,
      S(0) => \sum_reg_125[0]_i_7_n_2\
    );
\sum_reg_125_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[8]_i_1_n_7\,
      Q => \sum_reg_125_reg__0\(10),
      R => sum_reg_125
    );
\sum_reg_125_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[8]_i_1_n_6\,
      Q => \sum_reg_125_reg__0\(11),
      R => sum_reg_125
    );
\sum_reg_125_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[12]_i_1_n_9\,
      Q => \sum_reg_125_reg__0\(12),
      R => sum_reg_125
    );
\sum_reg_125_reg[12]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \sum_reg_125_reg[8]_i_1_n_2\,
      CO(3) => \sum_reg_125_reg[12]_i_1_n_2\,
      CO(2) => \sum_reg_125_reg[12]_i_1_n_3\,
      CO(1) => \sum_reg_125_reg[12]_i_1_n_4\,
      CO(0) => \sum_reg_125_reg[12]_i_1_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => gmem_addr_1_read_reg_260(15 downto 12),
      O(3) => \sum_reg_125_reg[12]_i_1_n_6\,
      O(2) => \sum_reg_125_reg[12]_i_1_n_7\,
      O(1) => \sum_reg_125_reg[12]_i_1_n_8\,
      O(0) => \sum_reg_125_reg[12]_i_1_n_9\,
      S(3) => \sum_reg_125[12]_i_2_n_2\,
      S(2) => \sum_reg_125[12]_i_3_n_2\,
      S(1) => \sum_reg_125[12]_i_4_n_2\,
      S(0) => \sum_reg_125[12]_i_5_n_2\
    );
\sum_reg_125_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[12]_i_1_n_8\,
      Q => \sum_reg_125_reg__0\(13),
      R => sum_reg_125
    );
\sum_reg_125_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[12]_i_1_n_7\,
      Q => \sum_reg_125_reg__0\(14),
      R => sum_reg_125
    );
\sum_reg_125_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[12]_i_1_n_6\,
      Q => \sum_reg_125_reg__0\(15),
      R => sum_reg_125
    );
\sum_reg_125_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[16]_i_1_n_9\,
      Q => \sum_reg_125_reg__0\(16),
      R => sum_reg_125
    );
\sum_reg_125_reg[16]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \sum_reg_125_reg[12]_i_1_n_2\,
      CO(3) => \sum_reg_125_reg[16]_i_1_n_2\,
      CO(2) => \sum_reg_125_reg[16]_i_1_n_3\,
      CO(1) => \sum_reg_125_reg[16]_i_1_n_4\,
      CO(0) => \sum_reg_125_reg[16]_i_1_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => gmem_addr_1_read_reg_260(19 downto 16),
      O(3) => \sum_reg_125_reg[16]_i_1_n_6\,
      O(2) => \sum_reg_125_reg[16]_i_1_n_7\,
      O(1) => \sum_reg_125_reg[16]_i_1_n_8\,
      O(0) => \sum_reg_125_reg[16]_i_1_n_9\,
      S(3) => \sum_reg_125[16]_i_2_n_2\,
      S(2) => \sum_reg_125[16]_i_3_n_2\,
      S(1) => \sum_reg_125[16]_i_4_n_2\,
      S(0) => \sum_reg_125[16]_i_5_n_2\
    );
\sum_reg_125_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[16]_i_1_n_8\,
      Q => \sum_reg_125_reg__0\(17),
      R => sum_reg_125
    );
\sum_reg_125_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[16]_i_1_n_7\,
      Q => \sum_reg_125_reg__0\(18),
      R => sum_reg_125
    );
\sum_reg_125_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[16]_i_1_n_6\,
      Q => \sum_reg_125_reg__0\(19),
      R => sum_reg_125
    );
\sum_reg_125_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[0]_i_3_n_8\,
      Q => \sum_reg_125_reg__0\(1),
      R => sum_reg_125
    );
\sum_reg_125_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[20]_i_1_n_9\,
      Q => \sum_reg_125_reg__0\(20),
      R => sum_reg_125
    );
\sum_reg_125_reg[20]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \sum_reg_125_reg[16]_i_1_n_2\,
      CO(3) => \sum_reg_125_reg[20]_i_1_n_2\,
      CO(2) => \sum_reg_125_reg[20]_i_1_n_3\,
      CO(1) => \sum_reg_125_reg[20]_i_1_n_4\,
      CO(0) => \sum_reg_125_reg[20]_i_1_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => gmem_addr_1_read_reg_260(23 downto 20),
      O(3) => \sum_reg_125_reg[20]_i_1_n_6\,
      O(2) => \sum_reg_125_reg[20]_i_1_n_7\,
      O(1) => \sum_reg_125_reg[20]_i_1_n_8\,
      O(0) => \sum_reg_125_reg[20]_i_1_n_9\,
      S(3) => \sum_reg_125[20]_i_2_n_2\,
      S(2) => \sum_reg_125[20]_i_3_n_2\,
      S(1) => \sum_reg_125[20]_i_4_n_2\,
      S(0) => \sum_reg_125[20]_i_5_n_2\
    );
\sum_reg_125_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[20]_i_1_n_8\,
      Q => \sum_reg_125_reg__0\(21),
      R => sum_reg_125
    );
\sum_reg_125_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[20]_i_1_n_7\,
      Q => \sum_reg_125_reg__0\(22),
      R => sum_reg_125
    );
\sum_reg_125_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[20]_i_1_n_6\,
      Q => \sum_reg_125_reg__0\(23),
      R => sum_reg_125
    );
\sum_reg_125_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[24]_i_1_n_9\,
      Q => \sum_reg_125_reg__0\(24),
      R => sum_reg_125
    );
\sum_reg_125_reg[24]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \sum_reg_125_reg[20]_i_1_n_2\,
      CO(3) => \sum_reg_125_reg[24]_i_1_n_2\,
      CO(2) => \sum_reg_125_reg[24]_i_1_n_3\,
      CO(1) => \sum_reg_125_reg[24]_i_1_n_4\,
      CO(0) => \sum_reg_125_reg[24]_i_1_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => gmem_addr_1_read_reg_260(27 downto 24),
      O(3) => \sum_reg_125_reg[24]_i_1_n_6\,
      O(2) => \sum_reg_125_reg[24]_i_1_n_7\,
      O(1) => \sum_reg_125_reg[24]_i_1_n_8\,
      O(0) => \sum_reg_125_reg[24]_i_1_n_9\,
      S(3) => \sum_reg_125[24]_i_2_n_2\,
      S(2) => \sum_reg_125[24]_i_3_n_2\,
      S(1) => \sum_reg_125[24]_i_4_n_2\,
      S(0) => \sum_reg_125[24]_i_5_n_2\
    );
\sum_reg_125_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[24]_i_1_n_8\,
      Q => \sum_reg_125_reg__0\(25),
      R => sum_reg_125
    );
\sum_reg_125_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[24]_i_1_n_7\,
      Q => \sum_reg_125_reg__0\(26),
      R => sum_reg_125
    );
\sum_reg_125_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[24]_i_1_n_6\,
      Q => \sum_reg_125_reg__0\(27),
      R => sum_reg_125
    );
\sum_reg_125_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[28]_i_1_n_9\,
      Q => \sum_reg_125_reg__0\(28),
      R => sum_reg_125
    );
\sum_reg_125_reg[28]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \sum_reg_125_reg[24]_i_1_n_2\,
      CO(3) => \sum_reg_125_reg[28]_i_1_n_2\,
      CO(2) => \sum_reg_125_reg[28]_i_1_n_3\,
      CO(1) => \sum_reg_125_reg[28]_i_1_n_4\,
      CO(0) => \sum_reg_125_reg[28]_i_1_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => gmem_addr_1_read_reg_260(31 downto 28),
      O(3) => \sum_reg_125_reg[28]_i_1_n_6\,
      O(2) => \sum_reg_125_reg[28]_i_1_n_7\,
      O(1) => \sum_reg_125_reg[28]_i_1_n_8\,
      O(0) => \sum_reg_125_reg[28]_i_1_n_9\,
      S(3) => \sum_reg_125[28]_i_2_n_2\,
      S(2) => \sum_reg_125[28]_i_3_n_2\,
      S(1) => \sum_reg_125[28]_i_4_n_2\,
      S(0) => \sum_reg_125[28]_i_5_n_2\
    );
\sum_reg_125_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[28]_i_1_n_8\,
      Q => \sum_reg_125_reg__0\(29),
      R => sum_reg_125
    );
\sum_reg_125_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[0]_i_3_n_7\,
      Q => \sum_reg_125_reg__0\(2),
      R => sum_reg_125
    );
\sum_reg_125_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[28]_i_1_n_7\,
      Q => \sum_reg_125_reg__0\(30),
      R => sum_reg_125
    );
\sum_reg_125_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[28]_i_1_n_6\,
      Q => \sum_reg_125_reg__0\(31),
      R => sum_reg_125
    );
\sum_reg_125_reg[32]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[32]_i_1_n_9\,
      Q => sum_reg_125_reg(32),
      R => sum_reg_125
    );
\sum_reg_125_reg[32]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \sum_reg_125_reg[28]_i_1_n_2\,
      CO(3) => \sum_reg_125_reg[32]_i_1_n_2\,
      CO(2) => \sum_reg_125_reg[32]_i_1_n_3\,
      CO(1) => \sum_reg_125_reg[32]_i_1_n_4\,
      CO(0) => \sum_reg_125_reg[32]_i_1_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \sum_reg_125_reg[32]_i_1_n_6\,
      O(2) => \sum_reg_125_reg[32]_i_1_n_7\,
      O(1) => \sum_reg_125_reg[32]_i_1_n_8\,
      O(0) => \sum_reg_125_reg[32]_i_1_n_9\,
      S(3 downto 0) => sum_reg_125_reg(35 downto 32)
    );
\sum_reg_125_reg[33]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[32]_i_1_n_8\,
      Q => sum_reg_125_reg(33),
      R => sum_reg_125
    );
\sum_reg_125_reg[34]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[32]_i_1_n_7\,
      Q => sum_reg_125_reg(34),
      R => sum_reg_125
    );
\sum_reg_125_reg[35]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[32]_i_1_n_6\,
      Q => sum_reg_125_reg(35),
      R => sum_reg_125
    );
\sum_reg_125_reg[36]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[36]_i_1_n_9\,
      Q => sum_reg_125_reg(36),
      R => sum_reg_125
    );
\sum_reg_125_reg[36]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \sum_reg_125_reg[32]_i_1_n_2\,
      CO(3) => \sum_reg_125_reg[36]_i_1_n_2\,
      CO(2) => \sum_reg_125_reg[36]_i_1_n_3\,
      CO(1) => \sum_reg_125_reg[36]_i_1_n_4\,
      CO(0) => \sum_reg_125_reg[36]_i_1_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \sum_reg_125_reg[36]_i_1_n_6\,
      O(2) => \sum_reg_125_reg[36]_i_1_n_7\,
      O(1) => \sum_reg_125_reg[36]_i_1_n_8\,
      O(0) => \sum_reg_125_reg[36]_i_1_n_9\,
      S(3 downto 0) => sum_reg_125_reg(39 downto 36)
    );
\sum_reg_125_reg[37]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[36]_i_1_n_8\,
      Q => sum_reg_125_reg(37),
      R => sum_reg_125
    );
\sum_reg_125_reg[38]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[36]_i_1_n_7\,
      Q => sum_reg_125_reg(38),
      R => sum_reg_125
    );
\sum_reg_125_reg[39]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[36]_i_1_n_6\,
      Q => sum_reg_125_reg(39),
      R => sum_reg_125
    );
\sum_reg_125_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[0]_i_3_n_6\,
      Q => \sum_reg_125_reg__0\(3),
      R => sum_reg_125
    );
\sum_reg_125_reg[40]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[40]_i_1_n_9\,
      Q => sum_reg_125_reg(40),
      R => sum_reg_125
    );
\sum_reg_125_reg[40]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \sum_reg_125_reg[36]_i_1_n_2\,
      CO(3) => \sum_reg_125_reg[40]_i_1_n_2\,
      CO(2) => \sum_reg_125_reg[40]_i_1_n_3\,
      CO(1) => \sum_reg_125_reg[40]_i_1_n_4\,
      CO(0) => \sum_reg_125_reg[40]_i_1_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \sum_reg_125_reg[40]_i_1_n_6\,
      O(2) => \sum_reg_125_reg[40]_i_1_n_7\,
      O(1) => \sum_reg_125_reg[40]_i_1_n_8\,
      O(0) => \sum_reg_125_reg[40]_i_1_n_9\,
      S(3 downto 0) => sum_reg_125_reg(43 downto 40)
    );
\sum_reg_125_reg[41]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[40]_i_1_n_8\,
      Q => sum_reg_125_reg(41),
      R => sum_reg_125
    );
\sum_reg_125_reg[42]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[40]_i_1_n_7\,
      Q => sum_reg_125_reg(42),
      R => sum_reg_125
    );
\sum_reg_125_reg[43]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[40]_i_1_n_6\,
      Q => sum_reg_125_reg(43),
      R => sum_reg_125
    );
\sum_reg_125_reg[44]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[44]_i_1_n_9\,
      Q => sum_reg_125_reg(44),
      R => sum_reg_125
    );
\sum_reg_125_reg[44]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \sum_reg_125_reg[40]_i_1_n_2\,
      CO(3) => \sum_reg_125_reg[44]_i_1_n_2\,
      CO(2) => \sum_reg_125_reg[44]_i_1_n_3\,
      CO(1) => \sum_reg_125_reg[44]_i_1_n_4\,
      CO(0) => \sum_reg_125_reg[44]_i_1_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \sum_reg_125_reg[44]_i_1_n_6\,
      O(2) => \sum_reg_125_reg[44]_i_1_n_7\,
      O(1) => \sum_reg_125_reg[44]_i_1_n_8\,
      O(0) => \sum_reg_125_reg[44]_i_1_n_9\,
      S(3 downto 0) => sum_reg_125_reg(47 downto 44)
    );
\sum_reg_125_reg[45]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[44]_i_1_n_8\,
      Q => sum_reg_125_reg(45),
      R => sum_reg_125
    );
\sum_reg_125_reg[46]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[44]_i_1_n_7\,
      Q => sum_reg_125_reg(46),
      R => sum_reg_125
    );
\sum_reg_125_reg[47]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[44]_i_1_n_6\,
      Q => sum_reg_125_reg(47),
      R => sum_reg_125
    );
\sum_reg_125_reg[48]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[48]_i_1_n_9\,
      Q => sum_reg_125_reg(48),
      R => sum_reg_125
    );
\sum_reg_125_reg[48]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \sum_reg_125_reg[44]_i_1_n_2\,
      CO(3) => \sum_reg_125_reg[48]_i_1_n_2\,
      CO(2) => \sum_reg_125_reg[48]_i_1_n_3\,
      CO(1) => \sum_reg_125_reg[48]_i_1_n_4\,
      CO(0) => \sum_reg_125_reg[48]_i_1_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \sum_reg_125_reg[48]_i_1_n_6\,
      O(2) => \sum_reg_125_reg[48]_i_1_n_7\,
      O(1) => \sum_reg_125_reg[48]_i_1_n_8\,
      O(0) => \sum_reg_125_reg[48]_i_1_n_9\,
      S(3 downto 0) => sum_reg_125_reg(51 downto 48)
    );
\sum_reg_125_reg[49]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[48]_i_1_n_8\,
      Q => sum_reg_125_reg(49),
      R => sum_reg_125
    );
\sum_reg_125_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[4]_i_1_n_9\,
      Q => \sum_reg_125_reg__0\(4),
      R => sum_reg_125
    );
\sum_reg_125_reg[4]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \sum_reg_125_reg[0]_i_3_n_2\,
      CO(3) => \sum_reg_125_reg[4]_i_1_n_2\,
      CO(2) => \sum_reg_125_reg[4]_i_1_n_3\,
      CO(1) => \sum_reg_125_reg[4]_i_1_n_4\,
      CO(0) => \sum_reg_125_reg[4]_i_1_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => gmem_addr_1_read_reg_260(7 downto 4),
      O(3) => \sum_reg_125_reg[4]_i_1_n_6\,
      O(2) => \sum_reg_125_reg[4]_i_1_n_7\,
      O(1) => \sum_reg_125_reg[4]_i_1_n_8\,
      O(0) => \sum_reg_125_reg[4]_i_1_n_9\,
      S(3) => \sum_reg_125[4]_i_2_n_2\,
      S(2) => \sum_reg_125[4]_i_3_n_2\,
      S(1) => \sum_reg_125[4]_i_4_n_2\,
      S(0) => \sum_reg_125[4]_i_5_n_2\
    );
\sum_reg_125_reg[50]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[48]_i_1_n_7\,
      Q => sum_reg_125_reg(50),
      R => sum_reg_125
    );
\sum_reg_125_reg[51]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[48]_i_1_n_6\,
      Q => sum_reg_125_reg(51),
      R => sum_reg_125
    );
\sum_reg_125_reg[52]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[52]_i_1_n_9\,
      Q => sum_reg_125_reg(52),
      R => sum_reg_125
    );
\sum_reg_125_reg[52]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \sum_reg_125_reg[48]_i_1_n_2\,
      CO(3) => \sum_reg_125_reg[52]_i_1_n_2\,
      CO(2) => \sum_reg_125_reg[52]_i_1_n_3\,
      CO(1) => \sum_reg_125_reg[52]_i_1_n_4\,
      CO(0) => \sum_reg_125_reg[52]_i_1_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \sum_reg_125_reg[52]_i_1_n_6\,
      O(2) => \sum_reg_125_reg[52]_i_1_n_7\,
      O(1) => \sum_reg_125_reg[52]_i_1_n_8\,
      O(0) => \sum_reg_125_reg[52]_i_1_n_9\,
      S(3 downto 0) => sum_reg_125_reg(55 downto 52)
    );
\sum_reg_125_reg[53]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[52]_i_1_n_8\,
      Q => sum_reg_125_reg(53),
      R => sum_reg_125
    );
\sum_reg_125_reg[54]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[52]_i_1_n_7\,
      Q => sum_reg_125_reg(54),
      R => sum_reg_125
    );
\sum_reg_125_reg[55]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[52]_i_1_n_6\,
      Q => sum_reg_125_reg(55),
      R => sum_reg_125
    );
\sum_reg_125_reg[56]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[56]_i_1_n_9\,
      Q => sum_reg_125_reg(56),
      R => sum_reg_125
    );
\sum_reg_125_reg[56]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \sum_reg_125_reg[52]_i_1_n_2\,
      CO(3) => \sum_reg_125_reg[56]_i_1_n_2\,
      CO(2) => \sum_reg_125_reg[56]_i_1_n_3\,
      CO(1) => \sum_reg_125_reg[56]_i_1_n_4\,
      CO(0) => \sum_reg_125_reg[56]_i_1_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \sum_reg_125_reg[56]_i_1_n_6\,
      O(2) => \sum_reg_125_reg[56]_i_1_n_7\,
      O(1) => \sum_reg_125_reg[56]_i_1_n_8\,
      O(0) => \sum_reg_125_reg[56]_i_1_n_9\,
      S(3 downto 0) => sum_reg_125_reg(59 downto 56)
    );
\sum_reg_125_reg[57]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[56]_i_1_n_8\,
      Q => sum_reg_125_reg(57),
      R => sum_reg_125
    );
\sum_reg_125_reg[58]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[56]_i_1_n_7\,
      Q => sum_reg_125_reg(58),
      R => sum_reg_125
    );
\sum_reg_125_reg[59]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[56]_i_1_n_6\,
      Q => sum_reg_125_reg(59),
      R => sum_reg_125
    );
\sum_reg_125_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[4]_i_1_n_8\,
      Q => \sum_reg_125_reg__0\(5),
      R => sum_reg_125
    );
\sum_reg_125_reg[60]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[60]_i_1_n_9\,
      Q => sum_reg_125_reg(60),
      R => sum_reg_125
    );
\sum_reg_125_reg[60]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \sum_reg_125_reg[56]_i_1_n_2\,
      CO(3) => \NLW_sum_reg_125_reg[60]_i_1_CO_UNCONNECTED\(3),
      CO(2) => \sum_reg_125_reg[60]_i_1_n_3\,
      CO(1) => \sum_reg_125_reg[60]_i_1_n_4\,
      CO(0) => \sum_reg_125_reg[60]_i_1_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \sum_reg_125_reg[60]_i_1_n_6\,
      O(2) => \sum_reg_125_reg[60]_i_1_n_7\,
      O(1) => \sum_reg_125_reg[60]_i_1_n_8\,
      O(0) => \sum_reg_125_reg[60]_i_1_n_9\,
      S(3 downto 0) => sum_reg_125_reg(63 downto 60)
    );
\sum_reg_125_reg[61]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[60]_i_1_n_8\,
      Q => sum_reg_125_reg(61),
      R => sum_reg_125
    );
\sum_reg_125_reg[62]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[60]_i_1_n_7\,
      Q => sum_reg_125_reg(62),
      R => sum_reg_125
    );
\sum_reg_125_reg[63]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[60]_i_1_n_6\,
      Q => sum_reg_125_reg(63),
      R => sum_reg_125
    );
\sum_reg_125_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[4]_i_1_n_7\,
      Q => \sum_reg_125_reg__0\(6),
      R => sum_reg_125
    );
\sum_reg_125_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[4]_i_1_n_6\,
      Q => \sum_reg_125_reg__0\(7),
      R => sum_reg_125
    );
\sum_reg_125_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[8]_i_1_n_9\,
      Q => \sum_reg_125_reg__0\(8),
      R => sum_reg_125
    );
\sum_reg_125_reg[8]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \sum_reg_125_reg[4]_i_1_n_2\,
      CO(3) => \sum_reg_125_reg[8]_i_1_n_2\,
      CO(2) => \sum_reg_125_reg[8]_i_1_n_3\,
      CO(1) => \sum_reg_125_reg[8]_i_1_n_4\,
      CO(0) => \sum_reg_125_reg[8]_i_1_n_5\,
      CYINIT => '0',
      DI(3 downto 0) => gmem_addr_1_read_reg_260(11 downto 8),
      O(3) => \sum_reg_125_reg[8]_i_1_n_6\,
      O(2) => \sum_reg_125_reg[8]_i_1_n_7\,
      O(1) => \sum_reg_125_reg[8]_i_1_n_8\,
      O(0) => \sum_reg_125_reg[8]_i_1_n_9\,
      S(3) => \sum_reg_125[8]_i_2_n_2\,
      S(2) => \sum_reg_125[8]_i_3_n_2\,
      S(1) => \sum_reg_125[8]_i_4_n_2\,
      S(0) => \sum_reg_125[8]_i_5_n_2\
    );
\sum_reg_125_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => sum_reg_1250,
      D => \sum_reg_125_reg[8]_i_1_n_8\,
      Q => \sum_reg_125_reg__0\(9),
      R => sum_reg_125
    );
\tmp_2_reg_270_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm112_out,
      D => sum_reg_125_reg(32),
      Q => tmp_2_reg_270(0),
      R => '0'
    );
\tmp_2_reg_270_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm112_out,
      D => sum_reg_125_reg(42),
      Q => tmp_2_reg_270(10),
      R => '0'
    );
\tmp_2_reg_270_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm112_out,
      D => sum_reg_125_reg(43),
      Q => tmp_2_reg_270(11),
      R => '0'
    );
\tmp_2_reg_270_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm112_out,
      D => sum_reg_125_reg(44),
      Q => tmp_2_reg_270(12),
      R => '0'
    );
\tmp_2_reg_270_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm112_out,
      D => sum_reg_125_reg(45),
      Q => tmp_2_reg_270(13),
      R => '0'
    );
\tmp_2_reg_270_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm112_out,
      D => sum_reg_125_reg(46),
      Q => tmp_2_reg_270(14),
      R => '0'
    );
\tmp_2_reg_270_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm112_out,
      D => sum_reg_125_reg(47),
      Q => tmp_2_reg_270(15),
      R => '0'
    );
\tmp_2_reg_270_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm112_out,
      D => sum_reg_125_reg(48),
      Q => tmp_2_reg_270(16),
      R => '0'
    );
\tmp_2_reg_270_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm112_out,
      D => sum_reg_125_reg(49),
      Q => tmp_2_reg_270(17),
      R => '0'
    );
\tmp_2_reg_270_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm112_out,
      D => sum_reg_125_reg(50),
      Q => tmp_2_reg_270(18),
      R => '0'
    );
\tmp_2_reg_270_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm112_out,
      D => sum_reg_125_reg(51),
      Q => tmp_2_reg_270(19),
      R => '0'
    );
\tmp_2_reg_270_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm112_out,
      D => sum_reg_125_reg(33),
      Q => tmp_2_reg_270(1),
      R => '0'
    );
\tmp_2_reg_270_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm112_out,
      D => sum_reg_125_reg(52),
      Q => tmp_2_reg_270(20),
      R => '0'
    );
\tmp_2_reg_270_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm112_out,
      D => sum_reg_125_reg(53),
      Q => tmp_2_reg_270(21),
      R => '0'
    );
\tmp_2_reg_270_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm112_out,
      D => sum_reg_125_reg(54),
      Q => tmp_2_reg_270(22),
      R => '0'
    );
\tmp_2_reg_270_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm112_out,
      D => sum_reg_125_reg(55),
      Q => tmp_2_reg_270(23),
      R => '0'
    );
\tmp_2_reg_270_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm112_out,
      D => sum_reg_125_reg(56),
      Q => tmp_2_reg_270(24),
      R => '0'
    );
\tmp_2_reg_270_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm112_out,
      D => sum_reg_125_reg(57),
      Q => tmp_2_reg_270(25),
      R => '0'
    );
\tmp_2_reg_270_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm112_out,
      D => sum_reg_125_reg(58),
      Q => tmp_2_reg_270(26),
      R => '0'
    );
\tmp_2_reg_270_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm112_out,
      D => sum_reg_125_reg(59),
      Q => tmp_2_reg_270(27),
      R => '0'
    );
\tmp_2_reg_270_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm112_out,
      D => sum_reg_125_reg(60),
      Q => tmp_2_reg_270(28),
      R => '0'
    );
\tmp_2_reg_270_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm112_out,
      D => sum_reg_125_reg(61),
      Q => tmp_2_reg_270(29),
      R => '0'
    );
\tmp_2_reg_270_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm112_out,
      D => sum_reg_125_reg(34),
      Q => tmp_2_reg_270(2),
      R => '0'
    );
\tmp_2_reg_270_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm112_out,
      D => sum_reg_125_reg(62),
      Q => tmp_2_reg_270(30),
      R => '0'
    );
\tmp_2_reg_270_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm112_out,
      D => sum_reg_125_reg(63),
      Q => tmp_2_reg_270(31),
      R => '0'
    );
\tmp_2_reg_270_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm112_out,
      D => sum_reg_125_reg(35),
      Q => tmp_2_reg_270(3),
      R => '0'
    );
\tmp_2_reg_270_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm112_out,
      D => sum_reg_125_reg(36),
      Q => tmp_2_reg_270(4),
      R => '0'
    );
\tmp_2_reg_270_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm112_out,
      D => sum_reg_125_reg(37),
      Q => tmp_2_reg_270(5),
      R => '0'
    );
\tmp_2_reg_270_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm112_out,
      D => sum_reg_125_reg(38),
      Q => tmp_2_reg_270(6),
      R => '0'
    );
\tmp_2_reg_270_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm112_out,
      D => sum_reg_125_reg(39),
      Q => tmp_2_reg_270(7),
      R => '0'
    );
\tmp_2_reg_270_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm112_out,
      D => sum_reg_125_reg(40),
      Q => tmp_2_reg_270(8),
      R => '0'
    );
\tmp_2_reg_270_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => ap_clk,
      CE => ap_NS_fsm112_out,
      D => sum_reg_125_reg(41),
      Q => tmp_2_reg_270(9),
      R => '0'
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_simple_accel_core_0_3 is
  port (
    s_axi_control_AWADDR : in STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axi_control_AWVALID : in STD_LOGIC;
    s_axi_control_AWREADY : out STD_LOGIC;
    s_axi_control_WDATA : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_control_WSTRB : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_control_WVALID : in STD_LOGIC;
    s_axi_control_WREADY : out STD_LOGIC;
    s_axi_control_BRESP : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_control_BVALID : out STD_LOGIC;
    s_axi_control_BREADY : in STD_LOGIC;
    s_axi_control_ARADDR : in STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axi_control_ARVALID : in STD_LOGIC;
    s_axi_control_ARREADY : out STD_LOGIC;
    s_axi_control_RDATA : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_control_RRESP : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_control_RVALID : out STD_LOGIC;
    s_axi_control_RREADY : in STD_LOGIC;
    ap_clk : in STD_LOGIC;
    ap_rst_n : in STD_LOGIC;
    interrupt : out STD_LOGIC;
    m_axi_gmem_AWADDR : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_gmem_AWLEN : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axi_gmem_AWSIZE : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_gmem_AWBURST : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_gmem_AWLOCK : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_gmem_AWREGION : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_gmem_AWCACHE : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_gmem_AWPROT : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_gmem_AWQOS : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_gmem_AWVALID : out STD_LOGIC;
    m_axi_gmem_AWREADY : in STD_LOGIC;
    m_axi_gmem_WDATA : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_gmem_WSTRB : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_gmem_WLAST : out STD_LOGIC;
    m_axi_gmem_WVALID : out STD_LOGIC;
    m_axi_gmem_WREADY : in STD_LOGIC;
    m_axi_gmem_BRESP : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_gmem_BVALID : in STD_LOGIC;
    m_axi_gmem_BREADY : out STD_LOGIC;
    m_axi_gmem_ARADDR : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_gmem_ARLEN : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axi_gmem_ARSIZE : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_gmem_ARBURST : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_gmem_ARLOCK : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_gmem_ARREGION : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_gmem_ARCACHE : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_gmem_ARPROT : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_gmem_ARQOS : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_gmem_ARVALID : out STD_LOGIC;
    m_axi_gmem_ARREADY : in STD_LOGIC;
    m_axi_gmem_RDATA : in STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_gmem_RRESP : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_gmem_RLAST : in STD_LOGIC;
    m_axi_gmem_RVALID : in STD_LOGIC;
    m_axi_gmem_RREADY : out STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of design_1_simple_accel_core_0_3 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of design_1_simple_accel_core_0_3 : entity is "design_1_simple_accel_core_0_3,simple_accel_core,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of design_1_simple_accel_core_0_3 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of design_1_simple_accel_core_0_3 : entity is "HLS";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of design_1_simple_accel_core_0_3 : entity is "simple_accel_core,Vivado 2018.3";
  attribute hls_module : string;
  attribute hls_module of design_1_simple_accel_core_0_3 : entity is "yes";
end design_1_simple_accel_core_0_3;

architecture STRUCTURE of design_1_simple_accel_core_0_3 is
  signal NLW_inst_m_axi_gmem_ARID_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_inst_m_axi_gmem_ARUSER_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_inst_m_axi_gmem_AWID_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_inst_m_axi_gmem_AWUSER_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_inst_m_axi_gmem_WID_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_inst_m_axi_gmem_WUSER_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  attribute C_M_AXI_DATA_WIDTH : integer;
  attribute C_M_AXI_DATA_WIDTH of inst : label is 32;
  attribute C_M_AXI_GMEM_ADDR_WIDTH : integer;
  attribute C_M_AXI_GMEM_ADDR_WIDTH of inst : label is 32;
  attribute C_M_AXI_GMEM_ARUSER_WIDTH : integer;
  attribute C_M_AXI_GMEM_ARUSER_WIDTH of inst : label is 1;
  attribute C_M_AXI_GMEM_AWUSER_WIDTH : integer;
  attribute C_M_AXI_GMEM_AWUSER_WIDTH of inst : label is 1;
  attribute C_M_AXI_GMEM_BUSER_WIDTH : integer;
  attribute C_M_AXI_GMEM_BUSER_WIDTH of inst : label is 1;
  attribute C_M_AXI_GMEM_CACHE_VALUE : integer;
  attribute C_M_AXI_GMEM_CACHE_VALUE of inst : label is 3;
  attribute C_M_AXI_GMEM_DATA_WIDTH : integer;
  attribute C_M_AXI_GMEM_DATA_WIDTH of inst : label is 32;
  attribute C_M_AXI_GMEM_ID_WIDTH : integer;
  attribute C_M_AXI_GMEM_ID_WIDTH of inst : label is 1;
  attribute C_M_AXI_GMEM_PROT_VALUE : integer;
  attribute C_M_AXI_GMEM_PROT_VALUE of inst : label is 0;
  attribute C_M_AXI_GMEM_RUSER_WIDTH : integer;
  attribute C_M_AXI_GMEM_RUSER_WIDTH of inst : label is 1;
  attribute C_M_AXI_GMEM_USER_VALUE : integer;
  attribute C_M_AXI_GMEM_USER_VALUE of inst : label is 0;
  attribute C_M_AXI_GMEM_WSTRB_WIDTH : integer;
  attribute C_M_AXI_GMEM_WSTRB_WIDTH of inst : label is 4;
  attribute C_M_AXI_GMEM_WUSER_WIDTH : integer;
  attribute C_M_AXI_GMEM_WUSER_WIDTH of inst : label is 1;
  attribute C_M_AXI_WSTRB_WIDTH : integer;
  attribute C_M_AXI_WSTRB_WIDTH of inst : label is 4;
  attribute C_S_AXI_CONTROL_ADDR_WIDTH : integer;
  attribute C_S_AXI_CONTROL_ADDR_WIDTH of inst : label is 6;
  attribute C_S_AXI_CONTROL_DATA_WIDTH : integer;
  attribute C_S_AXI_CONTROL_DATA_WIDTH of inst : label is 32;
  attribute C_S_AXI_CONTROL_WSTRB_WIDTH : integer;
  attribute C_S_AXI_CONTROL_WSTRB_WIDTH of inst : label is 4;
  attribute C_S_AXI_DATA_WIDTH : integer;
  attribute C_S_AXI_DATA_WIDTH of inst : label is 32;
  attribute C_S_AXI_WSTRB_WIDTH : integer;
  attribute C_S_AXI_WSTRB_WIDTH of inst : label is 4;
  attribute ap_ST_fsm_pp0_stage0 : string;
  attribute ap_ST_fsm_pp0_stage0 of inst : label is "17'b00000000100000000";
  attribute ap_ST_fsm_state1 : string;
  attribute ap_ST_fsm_state1 of inst : label is "17'b00000000000000001";
  attribute ap_ST_fsm_state12 : string;
  attribute ap_ST_fsm_state12 of inst : label is "17'b00000001000000000";
  attribute ap_ST_fsm_state13 : string;
  attribute ap_ST_fsm_state13 of inst : label is "17'b00000010000000000";
  attribute ap_ST_fsm_state14 : string;
  attribute ap_ST_fsm_state14 of inst : label is "17'b00000100000000000";
  attribute ap_ST_fsm_state15 : string;
  attribute ap_ST_fsm_state15 of inst : label is "17'b00001000000000000";
  attribute ap_ST_fsm_state16 : string;
  attribute ap_ST_fsm_state16 of inst : label is "17'b00010000000000000";
  attribute ap_ST_fsm_state17 : string;
  attribute ap_ST_fsm_state17 of inst : label is "17'b00100000000000000";
  attribute ap_ST_fsm_state18 : string;
  attribute ap_ST_fsm_state18 of inst : label is "17'b01000000000000000";
  attribute ap_ST_fsm_state19 : string;
  attribute ap_ST_fsm_state19 of inst : label is "17'b10000000000000000";
  attribute ap_ST_fsm_state2 : string;
  attribute ap_ST_fsm_state2 of inst : label is "17'b00000000000000010";
  attribute ap_ST_fsm_state3 : string;
  attribute ap_ST_fsm_state3 of inst : label is "17'b00000000000000100";
  attribute ap_ST_fsm_state4 : string;
  attribute ap_ST_fsm_state4 of inst : label is "17'b00000000000001000";
  attribute ap_ST_fsm_state5 : string;
  attribute ap_ST_fsm_state5 of inst : label is "17'b00000000000010000";
  attribute ap_ST_fsm_state6 : string;
  attribute ap_ST_fsm_state6 of inst : label is "17'b00000000000100000";
  attribute ap_ST_fsm_state7 : string;
  attribute ap_ST_fsm_state7 of inst : label is "17'b00000000001000000";
  attribute ap_ST_fsm_state8 : string;
  attribute ap_ST_fsm_state8 of inst : label is "17'b00000000010000000";
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of ap_clk : signal is "xilinx.com:signal:clock:1.0 ap_clk CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of ap_clk : signal is "XIL_INTERFACENAME ap_clk, ASSOCIATED_BUSIF s_axi_control:m_axi_gmem, ASSOCIATED_RESET ap_rst_n, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {CLK {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 1} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}}}, FREQ_HZ 62500000, PHASE 0.000, CLK_DOMAIN design_1_xdma_0_0_axi_aclk, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of ap_rst_n : signal is "xilinx.com:signal:reset:1.0 ap_rst_n RST";
  attribute X_INTERFACE_PARAMETER of ap_rst_n : signal is "XIL_INTERFACENAME ap_rst_n, POLARITY ACTIVE_LOW, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {RST {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 1} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}}}, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of interrupt : signal is "xilinx.com:signal:interrupt:1.0 interrupt INTERRUPT";
  attribute X_INTERFACE_PARAMETER of interrupt : signal is "XIL_INTERFACENAME interrupt, SENSITIVITY LEVEL_HIGH, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {INTERRUPT {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 1} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}}}, PortWidth 1";
  attribute X_INTERFACE_INFO of m_axi_gmem_ARREADY : signal is "xilinx.com:interface:aximm:1.0 m_axi_gmem ARREADY";
  attribute X_INTERFACE_INFO of m_axi_gmem_ARVALID : signal is "xilinx.com:interface:aximm:1.0 m_axi_gmem ARVALID";
  attribute X_INTERFACE_INFO of m_axi_gmem_AWREADY : signal is "xilinx.com:interface:aximm:1.0 m_axi_gmem AWREADY";
  attribute X_INTERFACE_INFO of m_axi_gmem_AWVALID : signal is "xilinx.com:interface:aximm:1.0 m_axi_gmem AWVALID";
  attribute X_INTERFACE_INFO of m_axi_gmem_BREADY : signal is "xilinx.com:interface:aximm:1.0 m_axi_gmem BREADY";
  attribute X_INTERFACE_INFO of m_axi_gmem_BVALID : signal is "xilinx.com:interface:aximm:1.0 m_axi_gmem BVALID";
  attribute X_INTERFACE_INFO of m_axi_gmem_RLAST : signal is "xilinx.com:interface:aximm:1.0 m_axi_gmem RLAST";
  attribute X_INTERFACE_INFO of m_axi_gmem_RREADY : signal is "xilinx.com:interface:aximm:1.0 m_axi_gmem RREADY";
  attribute X_INTERFACE_PARAMETER of m_axi_gmem_RREADY : signal is "XIL_INTERFACENAME m_axi_gmem, ADDR_WIDTH 32, MAX_BURST_LENGTH 256, NUM_READ_OUTSTANDING 16, NUM_WRITE_OUTSTANDING 16, MAX_READ_BURST_LENGTH 16, MAX_WRITE_BURST_LENGTH 16, PROTOCOL AXI4, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, SUPPORTS_NARROW_BURST 0, DATA_WIDTH 32, FREQ_HZ 62500000, ID_WIDTH 0, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, HAS_LOCK 1, HAS_PROT 1, HAS_CACHE 1, HAS_QOS 1, HAS_REGION 1, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, PHASE 0.000, CLK_DOMAIN design_1_xdma_0_0_axi_aclk, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of m_axi_gmem_RVALID : signal is "xilinx.com:interface:aximm:1.0 m_axi_gmem RVALID";
  attribute X_INTERFACE_INFO of m_axi_gmem_WLAST : signal is "xilinx.com:interface:aximm:1.0 m_axi_gmem WLAST";
  attribute X_INTERFACE_INFO of m_axi_gmem_WREADY : signal is "xilinx.com:interface:aximm:1.0 m_axi_gmem WREADY";
  attribute X_INTERFACE_INFO of m_axi_gmem_WVALID : signal is "xilinx.com:interface:aximm:1.0 m_axi_gmem WVALID";
  attribute X_INTERFACE_INFO of s_axi_control_ARREADY : signal is "xilinx.com:interface:aximm:1.0 s_axi_control ARREADY";
  attribute X_INTERFACE_INFO of s_axi_control_ARVALID : signal is "xilinx.com:interface:aximm:1.0 s_axi_control ARVALID";
  attribute X_INTERFACE_INFO of s_axi_control_AWREADY : signal is "xilinx.com:interface:aximm:1.0 s_axi_control AWREADY";
  attribute X_INTERFACE_INFO of s_axi_control_AWVALID : signal is "xilinx.com:interface:aximm:1.0 s_axi_control AWVALID";
  attribute X_INTERFACE_INFO of s_axi_control_BREADY : signal is "xilinx.com:interface:aximm:1.0 s_axi_control BREADY";
  attribute X_INTERFACE_INFO of s_axi_control_BVALID : signal is "xilinx.com:interface:aximm:1.0 s_axi_control BVALID";
  attribute X_INTERFACE_INFO of s_axi_control_RREADY : signal is "xilinx.com:interface:aximm:1.0 s_axi_control RREADY";
  attribute X_INTERFACE_PARAMETER of s_axi_control_RREADY : signal is "XIL_INTERFACENAME s_axi_control, ADDR_WIDTH 6, DATA_WIDTH 32, PROTOCOL AXI4LITE, READ_WRITE_MODE READ_WRITE, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {CLK {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 1} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}}}, FREQ_HZ 62500000, ID_WIDTH 0, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.000, CLK_DOMAIN design_1_xdma_0_0_axi_aclk, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s_axi_control_RVALID : signal is "xilinx.com:interface:aximm:1.0 s_axi_control RVALID";
  attribute X_INTERFACE_INFO of s_axi_control_WREADY : signal is "xilinx.com:interface:aximm:1.0 s_axi_control WREADY";
  attribute X_INTERFACE_INFO of s_axi_control_WVALID : signal is "xilinx.com:interface:aximm:1.0 s_axi_control WVALID";
  attribute X_INTERFACE_INFO of m_axi_gmem_ARADDR : signal is "xilinx.com:interface:aximm:1.0 m_axi_gmem ARADDR";
  attribute X_INTERFACE_INFO of m_axi_gmem_ARBURST : signal is "xilinx.com:interface:aximm:1.0 m_axi_gmem ARBURST";
  attribute X_INTERFACE_INFO of m_axi_gmem_ARCACHE : signal is "xilinx.com:interface:aximm:1.0 m_axi_gmem ARCACHE";
  attribute X_INTERFACE_INFO of m_axi_gmem_ARLEN : signal is "xilinx.com:interface:aximm:1.0 m_axi_gmem ARLEN";
  attribute X_INTERFACE_INFO of m_axi_gmem_ARLOCK : signal is "xilinx.com:interface:aximm:1.0 m_axi_gmem ARLOCK";
  attribute X_INTERFACE_INFO of m_axi_gmem_ARPROT : signal is "xilinx.com:interface:aximm:1.0 m_axi_gmem ARPROT";
  attribute X_INTERFACE_INFO of m_axi_gmem_ARQOS : signal is "xilinx.com:interface:aximm:1.0 m_axi_gmem ARQOS";
  attribute X_INTERFACE_INFO of m_axi_gmem_ARREGION : signal is "xilinx.com:interface:aximm:1.0 m_axi_gmem ARREGION";
  attribute X_INTERFACE_INFO of m_axi_gmem_ARSIZE : signal is "xilinx.com:interface:aximm:1.0 m_axi_gmem ARSIZE";
  attribute X_INTERFACE_INFO of m_axi_gmem_AWADDR : signal is "xilinx.com:interface:aximm:1.0 m_axi_gmem AWADDR";
  attribute X_INTERFACE_INFO of m_axi_gmem_AWBURST : signal is "xilinx.com:interface:aximm:1.0 m_axi_gmem AWBURST";
  attribute X_INTERFACE_INFO of m_axi_gmem_AWCACHE : signal is "xilinx.com:interface:aximm:1.0 m_axi_gmem AWCACHE";
  attribute X_INTERFACE_INFO of m_axi_gmem_AWLEN : signal is "xilinx.com:interface:aximm:1.0 m_axi_gmem AWLEN";
  attribute X_INTERFACE_INFO of m_axi_gmem_AWLOCK : signal is "xilinx.com:interface:aximm:1.0 m_axi_gmem AWLOCK";
  attribute X_INTERFACE_INFO of m_axi_gmem_AWPROT : signal is "xilinx.com:interface:aximm:1.0 m_axi_gmem AWPROT";
  attribute X_INTERFACE_INFO of m_axi_gmem_AWQOS : signal is "xilinx.com:interface:aximm:1.0 m_axi_gmem AWQOS";
  attribute X_INTERFACE_INFO of m_axi_gmem_AWREGION : signal is "xilinx.com:interface:aximm:1.0 m_axi_gmem AWREGION";
  attribute X_INTERFACE_INFO of m_axi_gmem_AWSIZE : signal is "xilinx.com:interface:aximm:1.0 m_axi_gmem AWSIZE";
  attribute X_INTERFACE_INFO of m_axi_gmem_BRESP : signal is "xilinx.com:interface:aximm:1.0 m_axi_gmem BRESP";
  attribute X_INTERFACE_INFO of m_axi_gmem_RDATA : signal is "xilinx.com:interface:aximm:1.0 m_axi_gmem RDATA";
  attribute X_INTERFACE_INFO of m_axi_gmem_RRESP : signal is "xilinx.com:interface:aximm:1.0 m_axi_gmem RRESP";
  attribute X_INTERFACE_INFO of m_axi_gmem_WDATA : signal is "xilinx.com:interface:aximm:1.0 m_axi_gmem WDATA";
  attribute X_INTERFACE_INFO of m_axi_gmem_WSTRB : signal is "xilinx.com:interface:aximm:1.0 m_axi_gmem WSTRB";
  attribute X_INTERFACE_INFO of s_axi_control_ARADDR : signal is "xilinx.com:interface:aximm:1.0 s_axi_control ARADDR";
  attribute X_INTERFACE_INFO of s_axi_control_AWADDR : signal is "xilinx.com:interface:aximm:1.0 s_axi_control AWADDR";
  attribute X_INTERFACE_INFO of s_axi_control_BRESP : signal is "xilinx.com:interface:aximm:1.0 s_axi_control BRESP";
  attribute X_INTERFACE_INFO of s_axi_control_RDATA : signal is "xilinx.com:interface:aximm:1.0 s_axi_control RDATA";
  attribute X_INTERFACE_INFO of s_axi_control_RRESP : signal is "xilinx.com:interface:aximm:1.0 s_axi_control RRESP";
  attribute X_INTERFACE_INFO of s_axi_control_WDATA : signal is "xilinx.com:interface:aximm:1.0 s_axi_control WDATA";
  attribute X_INTERFACE_INFO of s_axi_control_WSTRB : signal is "xilinx.com:interface:aximm:1.0 s_axi_control WSTRB";
begin
inst: entity work.design_1_simple_accel_core_0_3_simple_accel_core
     port map (
      ap_clk => ap_clk,
      ap_rst_n => ap_rst_n,
      interrupt => interrupt,
      m_axi_gmem_ARADDR(31 downto 0) => m_axi_gmem_ARADDR(31 downto 0),
      m_axi_gmem_ARBURST(1 downto 0) => m_axi_gmem_ARBURST(1 downto 0),
      m_axi_gmem_ARCACHE(3 downto 0) => m_axi_gmem_ARCACHE(3 downto 0),
      m_axi_gmem_ARID(0) => NLW_inst_m_axi_gmem_ARID_UNCONNECTED(0),
      m_axi_gmem_ARLEN(7 downto 0) => m_axi_gmem_ARLEN(7 downto 0),
      m_axi_gmem_ARLOCK(1 downto 0) => m_axi_gmem_ARLOCK(1 downto 0),
      m_axi_gmem_ARPROT(2 downto 0) => m_axi_gmem_ARPROT(2 downto 0),
      m_axi_gmem_ARQOS(3 downto 0) => m_axi_gmem_ARQOS(3 downto 0),
      m_axi_gmem_ARREADY => m_axi_gmem_ARREADY,
      m_axi_gmem_ARREGION(3 downto 0) => m_axi_gmem_ARREGION(3 downto 0),
      m_axi_gmem_ARSIZE(2 downto 0) => m_axi_gmem_ARSIZE(2 downto 0),
      m_axi_gmem_ARUSER(0) => NLW_inst_m_axi_gmem_ARUSER_UNCONNECTED(0),
      m_axi_gmem_ARVALID => m_axi_gmem_ARVALID,
      m_axi_gmem_AWADDR(31 downto 0) => m_axi_gmem_AWADDR(31 downto 0),
      m_axi_gmem_AWBURST(1 downto 0) => m_axi_gmem_AWBURST(1 downto 0),
      m_axi_gmem_AWCACHE(3 downto 0) => m_axi_gmem_AWCACHE(3 downto 0),
      m_axi_gmem_AWID(0) => NLW_inst_m_axi_gmem_AWID_UNCONNECTED(0),
      m_axi_gmem_AWLEN(7 downto 0) => m_axi_gmem_AWLEN(7 downto 0),
      m_axi_gmem_AWLOCK(1 downto 0) => m_axi_gmem_AWLOCK(1 downto 0),
      m_axi_gmem_AWPROT(2 downto 0) => m_axi_gmem_AWPROT(2 downto 0),
      m_axi_gmem_AWQOS(3 downto 0) => m_axi_gmem_AWQOS(3 downto 0),
      m_axi_gmem_AWREADY => m_axi_gmem_AWREADY,
      m_axi_gmem_AWREGION(3 downto 0) => m_axi_gmem_AWREGION(3 downto 0),
      m_axi_gmem_AWSIZE(2 downto 0) => m_axi_gmem_AWSIZE(2 downto 0),
      m_axi_gmem_AWUSER(0) => NLW_inst_m_axi_gmem_AWUSER_UNCONNECTED(0),
      m_axi_gmem_AWVALID => m_axi_gmem_AWVALID,
      m_axi_gmem_BID(0) => '0',
      m_axi_gmem_BREADY => m_axi_gmem_BREADY,
      m_axi_gmem_BRESP(1 downto 0) => m_axi_gmem_BRESP(1 downto 0),
      m_axi_gmem_BUSER(0) => '0',
      m_axi_gmem_BVALID => m_axi_gmem_BVALID,
      m_axi_gmem_RDATA(31 downto 0) => m_axi_gmem_RDATA(31 downto 0),
      m_axi_gmem_RID(0) => '0',
      m_axi_gmem_RLAST => m_axi_gmem_RLAST,
      m_axi_gmem_RREADY => m_axi_gmem_RREADY,
      m_axi_gmem_RRESP(1 downto 0) => m_axi_gmem_RRESP(1 downto 0),
      m_axi_gmem_RUSER(0) => '0',
      m_axi_gmem_RVALID => m_axi_gmem_RVALID,
      m_axi_gmem_WDATA(31 downto 0) => m_axi_gmem_WDATA(31 downto 0),
      m_axi_gmem_WID(0) => NLW_inst_m_axi_gmem_WID_UNCONNECTED(0),
      m_axi_gmem_WLAST => m_axi_gmem_WLAST,
      m_axi_gmem_WREADY => m_axi_gmem_WREADY,
      m_axi_gmem_WSTRB(3 downto 0) => m_axi_gmem_WSTRB(3 downto 0),
      m_axi_gmem_WUSER(0) => NLW_inst_m_axi_gmem_WUSER_UNCONNECTED(0),
      m_axi_gmem_WVALID => m_axi_gmem_WVALID,
      s_axi_control_ARADDR(5 downto 0) => s_axi_control_ARADDR(5 downto 0),
      s_axi_control_ARREADY => s_axi_control_ARREADY,
      s_axi_control_ARVALID => s_axi_control_ARVALID,
      s_axi_control_AWADDR(5 downto 0) => s_axi_control_AWADDR(5 downto 0),
      s_axi_control_AWREADY => s_axi_control_AWREADY,
      s_axi_control_AWVALID => s_axi_control_AWVALID,
      s_axi_control_BREADY => s_axi_control_BREADY,
      s_axi_control_BRESP(1 downto 0) => s_axi_control_BRESP(1 downto 0),
      s_axi_control_BVALID => s_axi_control_BVALID,
      s_axi_control_RDATA(31 downto 0) => s_axi_control_RDATA(31 downto 0),
      s_axi_control_RREADY => s_axi_control_RREADY,
      s_axi_control_RRESP(1 downto 0) => s_axi_control_RRESP(1 downto 0),
      s_axi_control_RVALID => s_axi_control_RVALID,
      s_axi_control_WDATA(31 downto 0) => s_axi_control_WDATA(31 downto 0),
      s_axi_control_WREADY => s_axi_control_WREADY,
      s_axi_control_WSTRB(3 downto 0) => s_axi_control_WSTRB(3 downto 0),
      s_axi_control_WVALID => s_axi_control_WVALID
    );
end STRUCTURE;
