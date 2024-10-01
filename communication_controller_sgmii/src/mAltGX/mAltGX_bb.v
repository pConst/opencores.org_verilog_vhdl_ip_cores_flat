// megafunction wizard: %ALTGX%VBB%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: alt_c3gxb 

// ============================================================
// File Name: mAltGX.v
// Megafunction Name(s):
// 			alt_c3gxb
//
// Simulation Library Files(s):
// 			altera_mf;cycloneiv_hssi
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 11.1 Build 259 01/25/2012 SP 2 SJ Web Edition
// ************************************************************

//Copyright (C) 1991-2011 Altera Corporation
//Your use of Altera Corporation's design tools, logic functions 
//and other software and tools, and its AMPP partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Altera Program License 
//Subscription Agreement, Altera MegaCore Function License 
//Agreement, or other applicable license agreement, including, 
//without limitation, that your use is for the sole purpose of 
//programming logic devices manufactured by Altera and sold by 
//Altera or its authorized distributors.  Please refer to the 
//applicable agreement for further details.

module mAltGX (
	cal_blk_clk,
	gxb_powerdown,
	pll_inclk,
	reconfig_clk,
	reconfig_togxb,
	rx_analogreset,
	rx_datain,
	rx_digitalreset,
	tx_ctrlenable,
	tx_datain,
	tx_digitalreset,
	pll_locked,
	reconfig_fromgxb,
	rx_ctrldetect,
	rx_dataout,
	rx_disperr,
	rx_errdetect,
	rx_patterndetect,
	rx_rlv,
	rx_syncstatus,
	tx_clkout,
	tx_dataout)/* synthesis synthesis_clearbox = 1 */;

	input	  cal_blk_clk;
	input	[0:0]  gxb_powerdown;
	input	[0:0]  pll_inclk;
	input	  reconfig_clk;
	input	[3:0]  reconfig_togxb;
	input	[0:0]  rx_analogreset;
	input	[0:0]  rx_datain;
	input	[0:0]  rx_digitalreset;
	input	[0:0]  tx_ctrlenable;
	input	[7:0]  tx_datain;
	input	[0:0]  tx_digitalreset;
	output	[0:0]  pll_locked;
	output	[4:0]  reconfig_fromgxb;
	output	[0:0]  rx_ctrldetect;
	output	[7:0]  rx_dataout;
	output	[0:0]  rx_disperr;
	output	[0:0]  rx_errdetect;
	output	[0:0]  rx_patterndetect;
	output	[0:0]  rx_rlv;
	output	[0:0]  rx_syncstatus;
	output	[0:0]  tx_clkout;
	output	[0:0]  tx_dataout;

	parameter		starting_channel_number = 0;


endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone IV GX"
// Retrieval info: PRIVATE: NUM_KEYS NUMERIC "0"
// Retrieval info: PRIVATE: RECONFIG_PROTOCOL STRING "BASIC"
// Retrieval info: PRIVATE: RECONFIG_SUBPROTOCOL STRING "none"
// Retrieval info: PRIVATE: RX_ENABLE_DC_COUPLING STRING "false"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
// Retrieval info: PRIVATE: WIZ_BASE_DATA_RATE STRING "1250.0"
// Retrieval info: PRIVATE: WIZ_BASE_DATA_RATE_ENABLE STRING "0"
// Retrieval info: PRIVATE: WIZ_DATA_RATE STRING "1250.0"
// Retrieval info: PRIVATE: WIZ_DPRIO_INCLK_FREQ_ARRAY STRING "100 100 100 100 100 100 100 100"
// Retrieval info: PRIVATE: WIZ_DPRIO_INPUT_A STRING "2000"
// Retrieval info: PRIVATE: WIZ_DPRIO_INPUT_A_UNIT STRING "Mbps"
// Retrieval info: PRIVATE: WIZ_DPRIO_INPUT_B STRING "100"
// Retrieval info: PRIVATE: WIZ_DPRIO_INPUT_B_UNIT STRING "MHz"
// Retrieval info: PRIVATE: WIZ_DPRIO_INPUT_SELECTION NUMERIC "0"
// Retrieval info: PRIVATE: WIZ_DPRIO_REF_CLK0_FREQ STRING "125.0"
// Retrieval info: PRIVATE: WIZ_DPRIO_REF_CLK0_PROTOCOL STRING "GIGE"
// Retrieval info: PRIVATE: WIZ_DPRIO_REF_CLK1_FREQ STRING "250"
// Retrieval info: PRIVATE: WIZ_DPRIO_REF_CLK1_PROTOCOL STRING "Basic"
// Retrieval info: PRIVATE: WIZ_DPRIO_REF_CLK2_FREQ STRING "250"
// Retrieval info: PRIVATE: WIZ_DPRIO_REF_CLK2_PROTOCOL STRING "Basic"
// Retrieval info: PRIVATE: WIZ_DPRIO_REF_CLK3_FREQ STRING "250"
// Retrieval info: PRIVATE: WIZ_DPRIO_REF_CLK3_PROTOCOL STRING "Basic"
// Retrieval info: PRIVATE: WIZ_DPRIO_REF_CLK4_FREQ STRING "250"
// Retrieval info: PRIVATE: WIZ_DPRIO_REF_CLK4_PROTOCOL STRING "Basic"
// Retrieval info: PRIVATE: WIZ_DPRIO_REF_CLK5_FREQ STRING "250"
// Retrieval info: PRIVATE: WIZ_DPRIO_REF_CLK5_PROTOCOL STRING "Basic"
// Retrieval info: PRIVATE: WIZ_DPRIO_REF_CLK6_FREQ STRING "250"
// Retrieval info: PRIVATE: WIZ_DPRIO_REF_CLK6_PROTOCOL STRING "Basic"
// Retrieval info: PRIVATE: WIZ_ENABLE_EQUALIZER_CTRL NUMERIC "1"
// Retrieval info: PRIVATE: WIZ_EQUALIZER_CTRL_SETTING NUMERIC "1"
// Retrieval info: PRIVATE: WIZ_FORCE_DEFAULT_SETTINGS NUMERIC "1"
// Retrieval info: PRIVATE: WIZ_INCLK_FREQ STRING "125.0"
// Retrieval info: PRIVATE: WIZ_INCLK_FREQ_ARRAY STRING "62.5 125.0"
// Retrieval info: PRIVATE: WIZ_INPUT_A STRING "1250.0"
// Retrieval info: PRIVATE: WIZ_INPUT_A_UNIT STRING "Mbps"
// Retrieval info: PRIVATE: WIZ_INPUT_B STRING "125.0"
// Retrieval info: PRIVATE: WIZ_INPUT_B_UNIT STRING "MHz"
// Retrieval info: PRIVATE: WIZ_INPUT_SELECTION NUMERIC "0"
// Retrieval info: PRIVATE: WIZ_PROTOCOL STRING "GIGE"
// Retrieval info: PRIVATE: WIZ_SUBPROTOCOL STRING "None"
// Retrieval info: PRIVATE: WIZ_WORD_ALIGN_FLIP_PATTERN STRING "0"
// Retrieval info: PARAMETER: STARTING_CHANNEL_NUMBER NUMERIC "0"
// Retrieval info: CONSTANT: EFFECTIVE_DATA_RATE STRING "1250.0 Mbps"
// Retrieval info: CONSTANT: ENABLE_LC_TX_PLL STRING "false"
// Retrieval info: CONSTANT: ENABLE_PLL_INCLK_ALT_DRIVE_RX_CRU STRING "true"
// Retrieval info: CONSTANT: ENABLE_PLL_INCLK_DRIVE_RX_CRU STRING "true"
// Retrieval info: CONSTANT: EQUALIZER_DCGAIN_SETTING NUMERIC "0"
// Retrieval info: CONSTANT: GEN_RECONFIG_PLL STRING "false"
// Retrieval info: CONSTANT: GX_CHANNEL_TYPE STRING ""
// Retrieval info: CONSTANT: INPUT_CLOCK_FREQUENCY STRING "125.0 MHz"
// Retrieval info: CONSTANT: INTENDED_DEVICE_FAMILY STRING "Cyclone IV GX"
// Retrieval info: CONSTANT: INTENDED_DEVICE_SPEED_GRADE STRING "6"
// Retrieval info: CONSTANT: INTENDED_DEVICE_VARIANT STRING "ANY"
// Retrieval info: CONSTANT: LOOPBACK_MODE STRING "none"
// Retrieval info: CONSTANT: LPM_TYPE STRING "alt_c3gxb"
// Retrieval info: CONSTANT: NUMBER_OF_CHANNELS NUMERIC "1"
// Retrieval info: CONSTANT: OPERATION_MODE STRING "duplex"
// Retrieval info: CONSTANT: PLL_BANDWIDTH_TYPE STRING "Auto"
// Retrieval info: CONSTANT: PLL_CONTROL_WIDTH NUMERIC "1"
// Retrieval info: CONSTANT: PLL_INCLK_PERIOD NUMERIC "8000"
// Retrieval info: CONSTANT: PLL_PFD_FB_MODE STRING "internal"
// Retrieval info: CONSTANT: PREEMPHASIS_CTRL_1STPOSTTAP_SETTING NUMERIC "0"
// Retrieval info: CONSTANT: PROTOCOL STRING "gige"
// Retrieval info: CONSTANT: RECEIVER_TERMINATION STRING "oct_100_ohms"
// Retrieval info: CONSTANT: RECONFIG_DPRIO_MODE NUMERIC "0"
// Retrieval info: CONSTANT: RX_8B_10B_MODE STRING "normal"
// Retrieval info: CONSTANT: RX_ALIGN_PATTERN STRING "0101111100"
// Retrieval info: CONSTANT: RX_ALIGN_PATTERN_LENGTH NUMERIC "10"
// Retrieval info: CONSTANT: RX_ALLOW_ALIGN_POLARITY_INVERSION STRING "false"
// Retrieval info: CONSTANT: RX_ALLOW_PIPE_POLARITY_INVERSION STRING "false"
// Retrieval info: CONSTANT: RX_BITSLIP_ENABLE STRING "false"
// Retrieval info: CONSTANT: RX_BYTE_ORDERING_MODE STRING "NONE"
// Retrieval info: CONSTANT: RX_CHANNEL_WIDTH NUMERIC "8"
// Retrieval info: CONSTANT: RX_COMMON_MODE STRING "0.82v"
// Retrieval info: CONSTANT: RX_CRU_INCLOCK0_PERIOD NUMERIC "8000"
// Retrieval info: CONSTANT: RX_DATAPATH_PROTOCOL STRING "basic"
// Retrieval info: CONSTANT: RX_DATA_RATE NUMERIC "1250"
// Retrieval info: CONSTANT: RX_DATA_RATE_REMAINDER NUMERIC "0"
// Retrieval info: CONSTANT: RX_DIGITALRESET_PORT_WIDTH NUMERIC "1"
// Retrieval info: CONSTANT: RX_ENABLE_BIT_REVERSAL STRING "false"
// Retrieval info: CONSTANT: RX_ENABLE_LOCK_TO_DATA_SIG STRING "false"
// Retrieval info: CONSTANT: RX_ENABLE_LOCK_TO_REFCLK_SIG STRING "false"
// Retrieval info: CONSTANT: RX_ENABLE_SELF_TEST_MODE STRING "false"
// Retrieval info: CONSTANT: RX_FORCE_SIGNAL_DETECT STRING "true"
// Retrieval info: CONSTANT: RX_PPMSELECT NUMERIC "8"
// Retrieval info: CONSTANT: RX_RATE_MATCH_FIFO_MODE STRING "normal"
// Retrieval info: CONSTANT: RX_RATE_MATCH_PATTERN1 STRING "10100010010101111100"
// Retrieval info: CONSTANT: RX_RATE_MATCH_PATTERN2 STRING "10101011011010000011"
// Retrieval info: CONSTANT: RX_RATE_MATCH_PATTERN_SIZE NUMERIC "20"
// Retrieval info: CONSTANT: RX_RUN_LENGTH NUMERIC "40"
// Retrieval info: CONSTANT: RX_RUN_LENGTH_ENABLE STRING "true"
// Retrieval info: CONSTANT: RX_SIGNAL_DETECT_THRESHOLD NUMERIC "8"
// Retrieval info: CONSTANT: RX_USE_ALIGN_STATE_MACHINE STRING "true"
// Retrieval info: CONSTANT: RX_USE_CLKOUT STRING "false"
// Retrieval info: CONSTANT: RX_USE_CORECLK STRING "false"
// Retrieval info: CONSTANT: RX_USE_DESERIALIZER_DOUBLE_DATA_MODE STRING "false"
// Retrieval info: CONSTANT: RX_USE_DESKEW_FIFO STRING "false"
// Retrieval info: CONSTANT: RX_USE_DOUBLE_DATA_MODE STRING "false"
// Retrieval info: CONSTANT: RX_USE_RATE_MATCH_PATTERN1_ONLY STRING "false"
// Retrieval info: CONSTANT: TRANSMITTER_TERMINATION STRING "oct_100_ohms"
// Retrieval info: CONSTANT: TX_8B_10B_MODE STRING "normal"
// Retrieval info: CONSTANT: TX_ALLOW_POLARITY_INVERSION STRING "false"
// Retrieval info: CONSTANT: TX_CHANNEL_WIDTH NUMERIC "8"
// Retrieval info: CONSTANT: TX_CLKOUT_WIDTH NUMERIC "1"
// Retrieval info: CONSTANT: TX_COMMON_MODE STRING "0.65v"
// Retrieval info: CONSTANT: TX_DATA_RATE NUMERIC "1250"
// Retrieval info: CONSTANT: TX_DATA_RATE_REMAINDER NUMERIC "0"
// Retrieval info: CONSTANT: TX_DIGITALRESET_PORT_WIDTH NUMERIC "1"
// Retrieval info: CONSTANT: TX_ENABLE_BIT_REVERSAL STRING "false"
// Retrieval info: CONSTANT: TX_ENABLE_SELF_TEST_MODE STRING "false"
// Retrieval info: CONSTANT: TX_PLL_BANDWIDTH_TYPE STRING "Auto"
// Retrieval info: CONSTANT: TX_PLL_INCLK0_PERIOD NUMERIC "8000"
// Retrieval info: CONSTANT: TX_PLL_TYPE STRING "CMU"
// Retrieval info: CONSTANT: TX_SLEW_RATE STRING "medium"
// Retrieval info: CONSTANT: TX_TRANSMIT_PROTOCOL STRING "basic"
// Retrieval info: CONSTANT: TX_USE_CORECLK STRING "false"
// Retrieval info: CONSTANT: TX_USE_DOUBLE_DATA_MODE STRING "false"
// Retrieval info: CONSTANT: TX_USE_SERIALIZER_DOUBLE_DATA_MODE STRING "false"
// Retrieval info: CONSTANT: USE_CALIBRATION_BLOCK STRING "true"
// Retrieval info: CONSTANT: VOD_CTRL_SETTING NUMERIC "4"
// Retrieval info: CONSTANT: equalization_setting NUMERIC "5"
// Retrieval info: CONSTANT: gxb_powerdown_width NUMERIC "1"
// Retrieval info: CONSTANT: iqtxrxclk_allowed STRING ""
// Retrieval info: CONSTANT: number_of_quads NUMERIC "1"
// Retrieval info: CONSTANT: pll_divide_by STRING "1"
// Retrieval info: CONSTANT: pll_multiply_by STRING "5"
// Retrieval info: CONSTANT: reconfig_calibration STRING "true"
// Retrieval info: CONSTANT: reconfig_fromgxb_port_width NUMERIC "5"
// Retrieval info: CONSTANT: reconfig_pll_control_width NUMERIC "1"
// Retrieval info: CONSTANT: reconfig_togxb_port_width NUMERIC "4"
// Retrieval info: CONSTANT: rx_deskew_pattern STRING "0"
// Retrieval info: CONSTANT: rx_dwidth_factor NUMERIC "1"
// Retrieval info: CONSTANT: rx_enable_second_order_loop STRING "false"
// Retrieval info: CONSTANT: rx_loop_1_digital_filter NUMERIC "8"
// Retrieval info: CONSTANT: rx_signal_detect_loss_threshold STRING "1"
// Retrieval info: CONSTANT: rx_signal_detect_valid_threshold STRING "14"
// Retrieval info: CONSTANT: rx_use_external_termination STRING "false"
// Retrieval info: CONSTANT: rx_word_aligner_num_byte NUMERIC "1"
// Retrieval info: CONSTANT: top_module_name STRING "mAltGX"
// Retrieval info: CONSTANT: tx_bitslip_enable STRING "FALSE"
// Retrieval info: CONSTANT: tx_dwidth_factor NUMERIC "1"
// Retrieval info: CONSTANT: tx_use_external_termination STRING "false"
// Retrieval info: USED_PORT: cal_blk_clk 0 0 0 0 INPUT NODEFVAL "cal_blk_clk"
// Retrieval info: USED_PORT: gxb_powerdown 0 0 1 0 INPUT NODEFVAL "gxb_powerdown[0..0]"
// Retrieval info: USED_PORT: pll_inclk 0 0 1 0 INPUT NODEFVAL "pll_inclk[0..0]"
// Retrieval info: USED_PORT: pll_locked 0 0 1 0 OUTPUT NODEFVAL "pll_locked[0..0]"
// Retrieval info: USED_PORT: reconfig_clk 0 0 0 0 INPUT NODEFVAL "reconfig_clk"
// Retrieval info: USED_PORT: reconfig_fromgxb 0 0 5 0 OUTPUT NODEFVAL "reconfig_fromgxb[4..0]"
// Retrieval info: USED_PORT: reconfig_togxb 0 0 4 0 INPUT NODEFVAL "reconfig_togxb[3..0]"
// Retrieval info: USED_PORT: rx_analogreset 0 0 1 0 INPUT NODEFVAL "rx_analogreset[0..0]"
// Retrieval info: USED_PORT: rx_ctrldetect 0 0 1 0 OUTPUT NODEFVAL "rx_ctrldetect[0..0]"
// Retrieval info: USED_PORT: rx_datain 0 0 1 0 INPUT NODEFVAL "rx_datain[0..0]"
// Retrieval info: USED_PORT: rx_dataout 0 0 8 0 OUTPUT NODEFVAL "rx_dataout[7..0]"
// Retrieval info: USED_PORT: rx_digitalreset 0 0 1 0 INPUT NODEFVAL "rx_digitalreset[0..0]"
// Retrieval info: USED_PORT: rx_disperr 0 0 1 0 OUTPUT NODEFVAL "rx_disperr[0..0]"
// Retrieval info: USED_PORT: rx_errdetect 0 0 1 0 OUTPUT NODEFVAL "rx_errdetect[0..0]"
// Retrieval info: USED_PORT: rx_patterndetect 0 0 1 0 OUTPUT NODEFVAL "rx_patterndetect[0..0]"
// Retrieval info: USED_PORT: rx_rlv 0 0 1 0 OUTPUT NODEFVAL "rx_rlv[0..0]"
// Retrieval info: USED_PORT: rx_syncstatus 0 0 1 0 OUTPUT NODEFVAL "rx_syncstatus[0..0]"
// Retrieval info: USED_PORT: tx_clkout 0 0 1 0 OUTPUT NODEFVAL "tx_clkout[0..0]"
// Retrieval info: USED_PORT: tx_ctrlenable 0 0 1 0 INPUT NODEFVAL "tx_ctrlenable[0..0]"
// Retrieval info: USED_PORT: tx_datain 0 0 8 0 INPUT NODEFVAL "tx_datain[7..0]"
// Retrieval info: USED_PORT: tx_dataout 0 0 1 0 OUTPUT NODEFVAL "tx_dataout[0..0]"
// Retrieval info: USED_PORT: tx_digitalreset 0 0 1 0 INPUT NODEFVAL "tx_digitalreset[0..0]"
// Retrieval info: CONNECT: @cal_blk_clk 0 0 0 0 cal_blk_clk 0 0 0 0
// Retrieval info: CONNECT: @gxb_powerdown 0 0 1 0 gxb_powerdown 0 0 1 0
// Retrieval info: CONNECT: @pll_inclk 0 0 1 0 pll_inclk 0 0 1 0
// Retrieval info: CONNECT: @reconfig_clk 0 0 0 0 reconfig_clk 0 0 0 0
// Retrieval info: CONNECT: @reconfig_togxb 0 0 4 0 reconfig_togxb 0 0 4 0
// Retrieval info: CONNECT: @rx_analogreset 0 0 1 0 rx_analogreset 0 0 1 0
// Retrieval info: CONNECT: @rx_datain 0 0 1 0 rx_datain 0 0 1 0
// Retrieval info: CONNECT: @rx_digitalreset 0 0 1 0 rx_digitalreset 0 0 1 0
// Retrieval info: CONNECT: @tx_ctrlenable 0 0 1 0 tx_ctrlenable 0 0 1 0
// Retrieval info: CONNECT: @tx_datain 0 0 8 0 tx_datain 0 0 8 0
// Retrieval info: CONNECT: @tx_digitalreset 0 0 1 0 tx_digitalreset 0 0 1 0
// Retrieval info: CONNECT: pll_locked 0 0 1 0 @pll_locked 0 0 1 0
// Retrieval info: CONNECT: reconfig_fromgxb 0 0 5 0 @reconfig_fromgxb 0 0 5 0
// Retrieval info: CONNECT: rx_ctrldetect 0 0 1 0 @rx_ctrldetect 0 0 1 0
// Retrieval info: CONNECT: rx_dataout 0 0 8 0 @rx_dataout 0 0 8 0
// Retrieval info: CONNECT: rx_disperr 0 0 1 0 @rx_disperr 0 0 1 0
// Retrieval info: CONNECT: rx_errdetect 0 0 1 0 @rx_errdetect 0 0 1 0
// Retrieval info: CONNECT: rx_patterndetect 0 0 1 0 @rx_patterndetect 0 0 1 0
// Retrieval info: CONNECT: rx_rlv 0 0 1 0 @rx_rlv 0 0 1 0
// Retrieval info: CONNECT: rx_syncstatus 0 0 1 0 @rx_syncstatus 0 0 1 0
// Retrieval info: CONNECT: tx_clkout 0 0 1 0 @tx_clkout 0 0 1 0
// Retrieval info: CONNECT: tx_dataout 0 0 1 0 @tx_dataout 0 0 1 0
// Retrieval info: GEN_FILE: TYPE_NORMAL mAltGX.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL mAltGX.ppf TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL mAltGX.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL mAltGX.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL mAltGX.bsf FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL mAltGX_inst.v FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL mAltGX_bb.v TRUE
// Retrieval info: LIB_FILE: altera_mf
// Retrieval info: LIB_FILE: cycloneiv_hssi
// Retrieval info: CBX_MODULE_PREFIX: ON
