-- megafunction wizard: %Triple Speed Ethernet v8.1%
-- GENERATION: XML

-- ============================================================
-- Megafunction Name(s):
-- 			altera_tse_mac
-- ============================================================
-- Generated by Triple Speed Ethernet 8.1 [Altera, IP Toolbench 1.3.0 Build 163]
-- ************************************************************
-- THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
-- ************************************************************
-- Copyright (C) 1991-2013 Altera Corporation
-- Any megafunction design, and related net list (encrypted or decrypted),
-- support information, device programming or simulation file, and any other
-- associated documentation or information provided by Altera or a partner
-- under Altera's Megafunction Partnership Program may be used only to
-- program PLD devices (but not masked PLD devices) from Altera.  Any other
-- use of such megafunction design, net list, support information, device
-- programming or simulation file, or any other related documentation or
-- information is prohibited for any other purpose, including, but not
-- limited to modification, reverse engineering, de-compiling, or use with
-- any other silicon devices, unless such use is explicitly licensed under
-- a separate agreement with Altera or a megafunction partner.  Title to
-- the intellectual property, including patents, copyrights, trademarks,
-- trade secrets, or maskworks, embodied in any such megafunction design,
-- net list, support information, device programming or simulation file, or
-- any other related documentation or information provided by Altera or a
-- megafunction partner, remains with Altera, the megafunction partner, or
-- their respective licensors.  No other licenses, including any licenses
-- needed under any third party's intellectual property, are provided herein.

library IEEE;
use IEEE.std_logic_1164.all;

ENTITY esoc_port_mac IS
	PORT (
		ff_tx_crc_fwd	: IN STD_LOGIC;
		ff_tx_data	: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		ff_tx_eop	: IN STD_LOGIC;
		ff_tx_err	: IN STD_LOGIC;
		ff_tx_mod	: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		ff_tx_sop	: IN STD_LOGIC;
		ff_tx_wren	: IN STD_LOGIC;
		ff_tx_clk	: IN STD_LOGIC;
		ff_rx_rdy	: IN STD_LOGIC;
		ff_rx_clk	: IN STD_LOGIC;
		address	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		read	: IN STD_LOGIC;
		writedata	: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		write	: IN STD_LOGIC;
		clk	: IN STD_LOGIC;
		reset	: IN STD_LOGIC;
		rgmii_in	: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		rx_control	: IN STD_LOGIC;
		tx_clk	: IN STD_LOGIC;
		rx_clk	: IN STD_LOGIC;
		set_10	: IN STD_LOGIC;
		set_1000	: IN STD_LOGIC;
		xon_gen	: IN STD_LOGIC;
		xoff_gen	: IN STD_LOGIC;
		magic_sleep_n	: IN STD_LOGIC;
		mdio_in	: IN STD_LOGIC;
		ff_tx_rdy	: OUT STD_LOGIC;
		ff_rx_data	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		ff_rx_dval	: OUT STD_LOGIC;
		ff_rx_eop	: OUT STD_LOGIC;
		ff_rx_mod	: OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
		ff_rx_sop	: OUT STD_LOGIC;
		rx_err	: OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
		rx_err_stat	: OUT STD_LOGIC_VECTOR (17 DOWNTO 0);
		rx_frm_type	: OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		ff_rx_dsav	: OUT STD_LOGIC;
		readdata	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		waitrequest	: OUT STD_LOGIC;
		rgmii_out	: OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		tx_control	: OUT STD_LOGIC;
		ena_10	: OUT STD_LOGIC;
		eth_mode	: OUT STD_LOGIC;
		ff_tx_septy	: OUT STD_LOGIC;
		tx_ff_uflow	: OUT STD_LOGIC;
		ff_rx_a_full	: OUT STD_LOGIC;
		ff_rx_a_empty	: OUT STD_LOGIC;
		ff_tx_a_full	: OUT STD_LOGIC;
		ff_tx_a_empty	: OUT STD_LOGIC;
		magic_wakeup	: OUT STD_LOGIC;
		mdio_out	: OUT STD_LOGIC;
		mdio_oen	: OUT STD_LOGIC;
		mdc	: OUT STD_LOGIC
	);
END esoc_port_mac;

ARCHITECTURE SYN OF esoc_port_mac IS


	COMPONENT altera_tse_mac
	GENERIC (
		ENABLE_MAGIC_DETECT	: NATURAL;
		ENABLE_MDIO	: NATURAL;
		ENABLE_SHIFT16	: NATURAL;
		ENABLE_SUP_ADDR	: NATURAL;
		CORE_VERSION	: STD_LOGIC_VECTOR := X"0800";
		CRC32GENDELAY	: NATURAL;
		MDIO_CLK_DIV	: NATURAL;
		ENA_HASH	: NATURAL;
		USE_SYNC_RESET	: NATURAL;
		STAT_CNT_ENA	: NATURAL;
		ENABLE_HD_LOGIC	: NATURAL;
		REDUCED_INTERFACE_ENA	: NATURAL;
		CRC32S1L2_EXTERN	: NATURAL;
		ENABLE_GMII_LOOPBACK	: NATURAL;
		CRC32DWIDTH	: NATURAL;
		CUST_VERSION	: NATURAL;
		RESET_LEVEL	: STD_LOGIC_VECTOR := X"01";
		CRC32CHECK16BIT	: STD_LOGIC_VECTOR := X"00";
		ENABLE_MAC_FLOW_CTRL	: NATURAL;
		ENABLE_MAC_TXADDR_SET	: NATURAL;
		ENABLE_MAC_RX_VLAN	: NATURAL;
		ENABLE_MAC_TX_VLAN	: NATURAL;
		EG_FIFO	: NATURAL;
		EG_ADDR	: NATURAL;
		ING_FIFO	: NATURAL;
		ENABLE_ENA	: NATURAL;
		ING_ADDR	: NATURAL;
		RAM_TYPE	: STRING;
		INSERT_TA	: NATURAL;
		ENABLE_MACLITE	: NATURAL;
		MACLITE_GIGE	: NATURAL
	);
	PORT (
		ff_tx_crc_fwd	: IN STD_LOGIC;
		ff_tx_data	: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		ff_tx_eop	: IN STD_LOGIC;
		ff_tx_err	: IN STD_LOGIC;
		ff_tx_mod	: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		ff_tx_sop	: IN STD_LOGIC;
		ff_tx_wren	: IN STD_LOGIC;
		ff_tx_clk	: IN STD_LOGIC;
		ff_rx_rdy	: IN STD_LOGIC;
		ff_rx_clk	: IN STD_LOGIC;
		address	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		read	: IN STD_LOGIC;
		writedata	: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		write	: IN STD_LOGIC;
		clk	: IN STD_LOGIC;
		reset	: IN STD_LOGIC;
		rgmii_in	: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		rx_control	: IN STD_LOGIC;
		tx_clk	: IN STD_LOGIC;
		rx_clk	: IN STD_LOGIC;
		set_10	: IN STD_LOGIC;
		set_1000	: IN STD_LOGIC;
		xon_gen	: IN STD_LOGIC;
		xoff_gen	: IN STD_LOGIC;
		magic_sleep_n	: IN STD_LOGIC;
		mdio_in	: IN STD_LOGIC;
		ff_tx_rdy	: OUT STD_LOGIC;
		ff_rx_data	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		ff_rx_dval	: OUT STD_LOGIC;
		ff_rx_eop	: OUT STD_LOGIC;
		ff_rx_mod	: OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
		ff_rx_sop	: OUT STD_LOGIC;
		rx_err	: OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
		rx_err_stat	: OUT STD_LOGIC_VECTOR (17 DOWNTO 0);
		rx_frm_type	: OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		ff_rx_dsav	: OUT STD_LOGIC;
		readdata	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		waitrequest	: OUT STD_LOGIC;
		rgmii_out	: OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		tx_control	: OUT STD_LOGIC;
		ena_10	: OUT STD_LOGIC;
		eth_mode	: OUT STD_LOGIC;
		ff_tx_septy	: OUT STD_LOGIC;
		tx_ff_uflow	: OUT STD_LOGIC;
		ff_rx_a_full	: OUT STD_LOGIC;
		ff_rx_a_empty	: OUT STD_LOGIC;
		ff_tx_a_full	: OUT STD_LOGIC;
		ff_tx_a_empty	: OUT STD_LOGIC;
		magic_wakeup	: OUT STD_LOGIC;
		mdio_out	: OUT STD_LOGIC;
		mdio_oen	: OUT STD_LOGIC;
		mdc	: OUT STD_LOGIC
	);

	END COMPONENT;

BEGIN

	altera_tse_mac_inst : altera_tse_mac
	GENERIC MAP (
		ENABLE_MAGIC_DETECT => 1,
		ENABLE_MDIO => 1,
		ENABLE_SHIFT16 => 0,
		ENABLE_SUP_ADDR => 0,
		CORE_VERSION => X"0800",
		CRC32GENDELAY => 6,
		MDIO_CLK_DIV => 40,
		ENA_HASH => 0,
		USE_SYNC_RESET => 0,
		STAT_CNT_ENA => 1,
		ENABLE_HD_LOGIC => 1,
		REDUCED_INTERFACE_ENA => 1,
		CRC32S1L2_EXTERN => 0,
		ENABLE_GMII_LOOPBACK => 1,
		CRC32DWIDTH => 8,
		CUST_VERSION => 0,
		RESET_LEVEL => X"01",
		CRC32CHECK16BIT => X"00",
		ENABLE_MAC_FLOW_CTRL => 1,
		ENABLE_MAC_TXADDR_SET => 1,
		ENABLE_MAC_RX_VLAN => 0,
		ENABLE_MAC_TX_VLAN => 0,
		EG_FIFO => 2048,
		EG_ADDR => 11,
		ING_FIFO => 2048,
		ENABLE_ENA => 32,
		ING_ADDR => 11,
		RAM_TYPE => "AUTO",
		INSERT_TA => 0,
		ENABLE_MACLITE => 0,
		MACLITE_GIGE => 0
	)
	PORT MAP (
		ff_tx_crc_fwd  =>  ff_tx_crc_fwd,
		ff_tx_data  =>  ff_tx_data,
		ff_tx_eop  =>  ff_tx_eop,
		ff_tx_err  =>  ff_tx_err,
		ff_tx_mod  =>  ff_tx_mod,
		ff_tx_rdy  =>  ff_tx_rdy,
		ff_tx_sop  =>  ff_tx_sop,
		ff_tx_wren  =>  ff_tx_wren,
		ff_tx_clk  =>  ff_tx_clk,
		ff_rx_data  =>  ff_rx_data,
		ff_rx_dval  =>  ff_rx_dval,
		ff_rx_eop  =>  ff_rx_eop,
		ff_rx_mod  =>  ff_rx_mod,
		ff_rx_rdy  =>  ff_rx_rdy,
		ff_rx_sop  =>  ff_rx_sop,
		rx_err  =>  rx_err,
		rx_err_stat  =>  rx_err_stat,
		rx_frm_type  =>  rx_frm_type,
		ff_rx_dsav  =>  ff_rx_dsav,
		ff_rx_clk  =>  ff_rx_clk,
		address  =>  address,
		readdata  =>  readdata,
		read  =>  read,
		writedata  =>  writedata,
		write  =>  write,
		waitrequest  =>  waitrequest,
		clk  =>  clk,
		reset  =>  reset,
		rgmii_in  =>  rgmii_in,
		rgmii_out  =>  rgmii_out,
		rx_control  =>  rx_control,
		tx_control  =>  tx_control,
		tx_clk  =>  tx_clk,
		rx_clk  =>  rx_clk,
		set_10  =>  set_10,
		set_1000  =>  set_1000,
		ena_10  =>  ena_10,
		eth_mode  =>  eth_mode,
		ff_tx_septy  =>  ff_tx_septy,
		tx_ff_uflow  =>  tx_ff_uflow,
		ff_rx_a_full  =>  ff_rx_a_full,
		ff_rx_a_empty  =>  ff_rx_a_empty,
		ff_tx_a_full  =>  ff_tx_a_full,
		ff_tx_a_empty  =>  ff_tx_a_empty,
		xon_gen  =>  xon_gen,
		xoff_gen  =>  xoff_gen,
		magic_wakeup  =>  magic_wakeup,
		magic_sleep_n  =>  magic_sleep_n,
		mdio_out  =>  mdio_out,
		mdio_oen  =>  mdio_oen,
		mdio_in  =>  mdio_in,
		mdc  =>  mdc
	);


END SYN;


-- =========================================================
-- Triple Speed Ethernet Wizard Data
-- ===============================
-- DO NOT EDIT FOLLOWING DATA
-- @Altera, IP Toolbench@
-- Warning: If you modify this section, Triple Speed Ethernet Wizard may not be able to reproduce your chosen configuration.
-- 
-- Retrieval info: <?xml version="1.0"?>
-- Retrieval info: <MEGACORE title="Triple Speed Ethernet MegaCore Function"  version="8.1"  build="163"  iptb_version="1.3.0 Build 163"  format_version="120" >
-- Retrieval info:  <NETLIST_SECTION class="altera.ipbu.flowbase.netlist.model.TSEMVCModel"  active_core="altera_tse_mac" >
-- Retrieval info:   <STATIC_SECTION>
-- Retrieval info:    <PRIVATES>
-- Retrieval info:     <NAMESPACE name = "parameterization">
-- Retrieval info:      <PRIVATE name = "atlanticSinkClockRate" value="0"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "atlanticSinkClockSource" value="unassigned"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "atlanticSourceClockRate" value="0"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "atlanticSourceClockSource" value="unassigned"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "avalonSlaveClockRate" value="0"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "avalonSlaveClockSource" value="unassigned"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "avalonStNeighbours" value="{}"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "channel_count" value="1"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "core_variation" value="MAC_ONLY"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "core_version" value="1794"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "crc32dwidth" value="8"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "crc32gendelay" value="6"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "crc32s1l2_extern" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "cust_version" value="0"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "dataBitsPerSymbol" value="8"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "dev_version" value="2048"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "deviceFamily" value="STRATIX"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "eg_addr" value="11"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "eg_fifo" value="2048"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "ena_hash" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_alt_reconfig" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_clk_sharing" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_ena" value="32"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_fifoless" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_gmii_loopback" value="1"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_hd_logic" value="1"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_mac_flow_ctrl" value="1"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_mac_txaddr_set" value="1"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_mac_vlan" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_maclite" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_magic_detect" value="1"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_multi_channel" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_pkt_class" value="1"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_pma" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_reg_sharing" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_sgmii" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_shift16" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_sup_addr" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_use_internal_fifo" value="1"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "export_calblkclk" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "export_pwrdn" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "gigeAdvanceMode" value="1"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "ifGMII" value="RGMII"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "ifPCSuseEmbeddedSerdes" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "ing_addr" value="11"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "ing_fifo" value="2048"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "insert_ta" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "maclite_gige" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "max_channels" value="0"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "mdio_clk_div" value="40"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "phy_identifier" value="0"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "ramType" value="AUTO"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "sopcSystemTopLevelName" value="system"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "stat_cnt_ena" value="1"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "timingAdapterName" value="timingAdapter"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "toolContext" value="STANDALONE"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "transceiver_type" value="GXB"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "uiEgFIFOSize" value="2048 x 32 Bits"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "uiHostClockFrequency" value="0"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "uiIngFIFOSize" value="2048 x 32 Bits"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "uiMACFIFO" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "uiMACOptions" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "uiMDIOFreq" value="0.0 MHz"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "uiMIIInterfaceOptions" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "uiPCSInterface" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "uiPCSInterfaceOptions" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "useLvds" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "useMAC" value="1"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "useMDIO" value="1"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "usePCS" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "use_sync_reset" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "simgen_enable">
-- Retrieval info:      <PRIVATE name = "language" value="VHDL"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enabled" value="1"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "gb_enabled" value="0"  type="STRING"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "testbench">
-- Retrieval info:      <PRIVATE name = "variation_name" value="esoc_port_mac"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "project_name" value="system"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "output_name" value="esoc_port_mac"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "tool_context" value="STANDALONE"  type="STRING"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "constraint_file_generator">
-- Retrieval info:      <PRIVATE name = "variation_name" value="esoc_port_mac"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "instance_name" value="esoc_port_mac"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "output_name" value="esoc_port_mac"  type="STRING"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "modelsim_script_generator">
-- Retrieval info:      <PRIVATE name = "variation_name" value="esoc_port_mac"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "instance_name" value="esoc_port_mac"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "plugin_worker" value="1"  type="STRING"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "europa_executor">
-- Retrieval info:      <PRIVATE name = "plugin_worker" value="0"  type="STRING"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "simgen">
-- Retrieval info:      <PRIVATE name = "use_alt_top" value="0"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "filename" value="esoc_port_mac.vho"  type="STRING"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "modelsim_wave_script_plugin">
-- Retrieval info:      <PRIVATE name = "plugin_worker" value="1"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "output_name" value="esoc_port_mac"  type="STRING"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "nativelink">
-- Retrieval info:      <PRIVATE name = "plugin_worker" value="1"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "language" value="VHDL"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "output_name" value="esoc_port_mac"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "variation_name" value="esoc_port_mac"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "top_level_name" value="esoc_port_mac"  type="STRING"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "greybox">
-- Retrieval info:      <PRIVATE name = "filename" value="esoc_port_mac_syn.v"  type="STRING"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "serializer"/>
-- Retrieval info:    </PRIVATES>
-- Retrieval info:    <FILES/>
-- Retrieval info:    <PORTS/>
-- Retrieval info:    <LIBRARIES/>
-- Retrieval info:   </STATIC_SECTION>
-- Retrieval info:  </NETLIST_SECTION>
-- Retrieval info: </MEGACORE>
-- =========================================================
-- RELATED_FILES: esoc_port_mac.vhd, altera_tse_mac.v;
-- IPFS_FILES: esoc_port_mac.vho;
-- =========================================================
