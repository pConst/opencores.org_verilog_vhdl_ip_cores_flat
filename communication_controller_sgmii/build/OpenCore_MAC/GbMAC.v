`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:49:28 06/15/2010 
// Design Name: 
// Module Name:    GbMAC_verify 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module GbMAC(
	input clk_125M,
	input clk_25M,		//10Mbps not supported
	input clk_125M_90,
	input clk_25M_90,
	input MAC_Sysclk,	//FIFO interface of MAC block
	input MAC_Regclk,	//Register interface of MAC block

	input cal_blk_clk,	//calibration clock
	input rstn,			//hardware reset
	input MACrst,		//Software reset of mac
	
	
	//MDIO interface
	inout  mdio,
	output mdc,
	
	
	//GMII interface	
	
	output [7:0] 	GMII_TXD,
	output 			GMII_TX_EN,
	output 			GMII_TX_ER,
	output 			GMII_TXClk,	
	input [7:0] 	GMII_RXD,
	input 			GMII_RX_EN,
	input 			GMII_RX_ER,
	input 			GMII_RXClk,
	
	//SGMII interface
	
	output 	SGMII_Tx,
	input	SGMII_Rx,
	
	//RGMII interface
	//RX 
	input 			RGMII_Rx_DV,
	input [3:0] 	RGMII_Rx_D,
	input 			RGMII_Rx_CLK,	
	//TX
	output 			RGMII_Tx_CLK,
	output 			RGMII_Tx_EN,
	output [3:0] 	RGMII_Tx_D,	
	
	//Host interface
	input [7:0] 	address		,
	input 			read		,
	input 			write		,
	input [15:0] 	writedata	,
	output [15:0] 	readdata	,
	output 			waitreq		,
		
	//status
	output led_an				,
	output led_link				,
	output [2:0] Speed			,
	output reg [3:0] link_stat	,
	
	output 			pktlen_fifo_ra		,
	output [15:0] 	pktlen_fifo_data	,
	input			pktlen_fifo_rd		,
	
	//PACKET Inteface
	output          Rx_mac_ra               ,
	input           Rx_mac_rd               ,
	output  [31:0]  Rx_mac_data             ,
	output  [1:0]   Rx_mac_BE               ,
	output          Rx_mac_pa               ,
	output          Rx_mac_sop              ,
	output          Rx_mac_eop              ,
	//user interface 
	output          Tx_mac_wa               ,
	input           Tx_mac_wr               ,
	input   [31:0]  Tx_mac_data             ,
	input   [1:0]   Tx_mac_BE               ,//big endian
	input           Tx_mac_sop              ,
	input           Tx_mac_eop              	
);

	//clocks
	wire CLK_125M_90;
	wire CLK_125M;
	wire CLK_25M;
	wire CLK_25M_90;
	
	//MAC Module signals
	wire [2:0] gEMAC_Speed;
	
	//user interface RX 
	wire Rx_ra, Rx_pa,Tx_wa, Tx_pa, Rx_sop, Rx_eop, Tx_sop, Tx_eop;
	wire Tx_wr;
	wire Rx_rd;
	wire [31:0] Rx_data, Tx_data;
	wire [1:0] Rx_BE, Tx_BE;
	wire pkt_length_fifo_rd, pkt_length_fifo_ra;
	wire [15:0] pkt_length_fifo_data;
	

	//host interface
	wire RxClk_MAC;//For MAC Receiver block
	wire TxClk_MAC;//For MAC Transmitter block
	wire MAC_RegSelect;
	wire MAC_RdnWr;
	wire [15:0] MAC_RegDin;
	wire [15:0] MAC_RegDout;
	wire [7:0] MAC_RegAddr;
	wire MAC_RegWait;	
	wire MAC_rsti;
	
	wire sysrst;	
	reg pwr_on_rst;	
	
	
	wire [35:0] LoopbackFIFO_din,LoopbackFIFO_dout;
	wire LoopbackFIFO_empty;
	wire LoopbackFIFO_full;
	wire LoopbackFIFO_wren;
	reg LoopbackFIFO_rden;
	wire sysclk,regclk;
	
	reg [3:0] pwr_on_cnt;
	reg Sync_Rst, CE;
	
	assign CLK_125M 	= clk_125M;
	assign CLK_125M_90 	= clk_125M_90;
	assign CLK_25M 		= clk_25M;
	assign CLK_25M_90	= clk_25M_90;
	assign sysclk 		= MAC_Sysclk;
	assign regclk 		= MAC_Regclk;
	
	
	
	//Phy interface         
	wire MAC_Tx_Clk_d;
	wire MAC_Tx_Clk;
	wire MAC_Rx_Clk;
	
	wire [31:0] MAC_Monitoring;
	wire 		MAC_GMII_TxER;
	wire 		MAC_GMII_TxEN;
	wire [7:0] 	MAC_GMII_TxD;
	wire		MAC_GMII_RxDV;
	wire 		MAC_GMII_RxER;
	wire 		GMII_RxDV;
	wire [7:0] 	MAC_GMII_RxD;
	wire MAC_Carrier_Sense;
	wire MAC_Colision_Detect;
	
	
	/* Altera GBX signals */
	wire [7:0] gmii_rx_d;
	wire gmii_rx_dv;
	wire gmii_rx_err;
	wire [7:0] gmii_tx_d;
	wire gmii_tx_en;
	wire gmii_tx_err;
	wire GXB_tx_clk;
	wire GXB_rx_clk;	
	wire [3:0] mii_rx_d;
	wire [3:0] mii_tx_d;
	wire mii_rx_dv;
	wire mii_tx_en;
	wire mii_rx_err;
	wire mii_tx_err;
	wire set_100;
	wire hd_ena;
	wire GXB_reset;
	wire [4:0] GXB_reg_addr;
	wire [15:0] GXB_readdata;
	wire [15:0] GXB_writedata;
	wire GXB_read;
	wire GXB_write;
	wire GXB_wait;
	wire GXB_regclk;
	wire GXB_refclk;
	wire GXB_reconfig_clk;
	wire [3:0] GXB_reconfig_togxb;
	wire GXB_led_an;
	wire GXB_tx_clkena;
	wire GXB_rx_clkena;
	wire GXB_led_link;
	wire GXB_cs; 

	wire mdi;
	wire mdo;
	wire mdoe;

	/*
	wire Rx_mac_ra,Rx_mac_rd,Rx_mac_pa,  Rx_mac_sop,Rx_mac_eop;
	wire [31:0]  Rx_mac_data  ;
	wire [1:0]   Rx_mac_BE    ;
	wire Tx_mac_wa, Tx_mac_wr,Tx_mac_sop,Tx_mac_eop;
	wire [31:0]  Tx_mac_data;
	wire [1:0]   Tx_mac_BE ;*/
	
	initial 
	begin
	pwr_on_rst <= 1;
	pwr_on_cnt <= 0;
	end
	
	//power on reset circuit
	always@(posedge CLK_125M)
	begin
		if (pwr_on_cnt!=15) pwr_on_cnt <= pwr_on_cnt+1;
		if (pwr_on_cnt<15 && pwr_on_cnt>9)	
					pwr_on_rst <= 1;
					else
					pwr_on_rst <= 0;
	end
	
	always@(posedge(CLK_125M))
	begin
	  if(!rstn)
		begin
			Sync_Rst <= 1;
			CE <= 0;
		end
		else
		begin
			Sync_Rst <= 0;		
			CE <= 1;
		end
	end
	assign sysrst = (~rstn)|pwr_on_rst;
	assign MAC_rsti = MACrst | pwr_on_rst | (~rstn);
	assign MAC_Carrier_Sense = 0;
	assign MAC_Colision_Detect = 0;

		//MAC Module
		MAC_top  gMAC(                //system signals
		.Reset			(MAC_rsti),
		.Clk_125M		(CLK_125M),
		.Clk_125M_90	(CLK_125M_90),
		.Clk_25M_90		(CLK_25M_90),
		.Clk_25M		(CLK_25M),
		.Clk_user		(sysclk),
		.Clk_reg		(regclk),		
		.Tx_clk			(clk_25M),	//used only in MII mode
		
		
		.Speed			(Speed),
		
		//user interface RX 
		.Rx_mac_ra		(Rx_ra),
		.Rx_mac_rd		(Rx_rd),
		.Rx_mac_data	(Rx_data),
		.Rx_mac_BE		(Rx_BE),
		.Rx_mac_pa		(Rx_pa),
		.Rx_mac_sop		(Rx_sop),
		.Rx_mac_eop		(Rx_eop),
		//user interface 
		.Tx_mac_wa		(Tx_wa),
		.Tx_mac_wr		(Tx_wr),
		.Tx_mac_data	(Tx_data),
		.Tx_mac_BE		(Tx_BE),//big endian
		.Tx_mac_sop		(Tx_sop),
		.Tx_mac_eop		(Tx_eop),
		//pkg_lgth fifo
		.Pkg_lgth_fifo_rd	(pktlen_fifo_rd),
		.Pkg_lgth_fifo_ra	(pktlen_fifo_ra),
		.Pkg_lgth_fifo_data	(pktlen_fifo_data),
		//Phy interface          
		//Phy interface         
		.Rx_clk			(MAC_Rx_Clk),
		.Gtx_clk		(MAC_Tx_Clk),			//used only in GMII mode
		.Gtx_clk_d		(MAC_Tx_Clk_d),
		.Tx_er			(MAC_GMII_TxER),
		.Tx_en			(MAC_GMII_TxEN),
		.Txd			(MAC_GMII_TxD),
		.Rx_er			(MAC_GMII_RxER),
		.Rx_dv			(MAC_GMII_RxDV),
		.Rxd			(MAC_GMII_RxD),
		.Crs			(MAC_Carrier_Sense),
		.Col			(MAC_Colision_Detect),
		//host interface
		.CSB			(MAC_RegSelect),
		.WRB			(MAC_RdnWr),
		.CD_in			(MAC_RegDin),
		.CD_out			(MAC_RegDout),
		.CA				(MAC_RegAddr),                
		.Monitoring		(MAC_Monitoring),
		//mdx
		.Mdo(mdo),                 // MII Management Data Output
		.MdoEn(mdoe),              // MII Management Data Output Enable
		.Mdi(mdi),
		.Mdc(mdc)                  // MII Management Data Clock       
		);     

	assign mdio = mdoe?(mdo):1'bz;
	assign mdi = mdio;

	//RGMII adapter
	RGMII2GMII R2G(
    .RGMII_RxD(RGMII_Rx_D),
    .RGMII_RxCtl(RGMII_Rx_DV),
    .RGMII_RxClk(RGMII_Rx_CLK),
    .RxD(MAC_GMII_RxD),
    .RxDV(MAC_GMII_RxDV),
    .RxER(MAC_GMII_RxER),
    .RxClk(MAC_Rx_Clk),
	.ClkEN(1'b1),
	.rst(sysrst)
    );
	
	GMII2RGMII G2R(
    .TxD(MAC_GMII_TxD),
    .TxClk(MAC_Tx_Clk),
    .TxClk90(MAC_Tx_Clk_d),
    .TxEn(MAC_GMII_TxEN),
    .TxErr(MAC_GMII_TxER),
    .RGMII_TxD(RGMII_Tx_D),
    .RGMII_TxCtl(RGMII_Tx_EN),
    .RGMII_TxClk(RGMII_Tx_CLK),
    
	.ClkEN(1'b1),
	.rst(sysrst)
    );

	always@(posedge MAC_Rx_Clk)
	begin
		if((~MAC_GMII_RxDV) & (~MAC_GMII_RxER)) link_stat <= MAC_GMII_RxD[3:0];
	end

	//GMII to SGMII
	/*
	sgmii_if sgmii (
	 .gmii_rx_d(gmii_rx_d),
	 .gmii_rx_dv(gmii_rx_dv),
	 .gmii_rx_err(gmii_rx_err),
	 .gmii_tx_d(gmii_tx_d),
	 .gmii_tx_en(gmii_tx_en),
	 .gmii_tx_err(gmii_tx_err),
	 
	 .tx_clk(GXB_tx_clk),
	 .rx_clk(GXB_rx_clk),
	 
	 .mii_rx_d(mii_rx_d),
	 .mii_rx_dv(mii_rx_dv),
	 .mii_rx_err(mii_rx_err),
	 .mii_tx_d(mii_tx_d),
	 .mii_tx_en(mii_tx_en),
	 .mii_tx_err(mii_tx_err),
	 .mii_col(),
	 .mii_crs(),
	 
	 .set_10(),
	 .set_100(set_100),
	 .set_1000(),
	 .hd_ena(hd_ena),
	 
	 .reset_tx_clk(GXB_reset),
	 .reset_rx_clk(GXB_reset),
	 
	 .address(GXB_reg_addr),
	 .readdata(GXB_readdata),
	 .read(GXB_read),
	 .writedata(GXB_writedata),
	 .write(GXB_write),
	 .waitrequest(GXB_wait),
	 .clk(GXB_regclk),
	 .reset(GXB_reset),
	 
	 .txp(SGMII_Tx),
	 .rxp(SGMII_Rx),
	 .ref_clk(GXB_refclk),
	 .reconfig_clk(GXB_reconfig_clk),
	 .reconfig_togxb(GXB_reconfig_togxb),
	 .reconfig_fromgxb(),
	 .led_col(),
	 .led_crs(),
	 .led_an(GXB_led_an),
	 .tx_clkena(GXB_tx_clkena),
	 .rx_clkena(GXB_rx_clkena),
	 .led_link(GXB_led_link),
	 .led_disp_err(),
	 .gxb_cal_blk_clk(GXB_refclk),
	 .led_char_err()
	);
	
	//MII is open
	assign GXB_reset = MAC_rsti;	
	assign GXB_regclk = regclk;
	assign GXB_reg_addr = address[4:0];
	assign GXB_writedata = writedata;
	assign GXB_read = read & GXB_cs;
	assign GXB_write = write & GXB_cs;
	assign GXB_cs = (address[7]==1'b1)?1'b1:1'b0;
	
	assign led_an = GXB_led_an;
	assign led_link = GXB_led_link;
	
	//Others signal 
	assign GXB_reconfig_clk = 1'b0;
	assign reconfig_togxb = 4'b0010;
	assign GXB_refclk = clk_125M;
	
	//Connect MAC and GXB
	//GMII Interafce
	assign MAC_GMII_RxD = gmii_rx_d;
	assign MAC_GMII_RxDV = gmii_rx_dv;
	assign MAC_GMII_RxER = gmii_rx_err;
	assign gmii_tx_d = MAC_GMII_TxD;
	assign gmii_tx_en= MAC_GMII_TxEN;
	assign gmii_tx_err = MAC_GMII_TxER;
	
	assign MAC_Tx_Clk = GXB_tx_clk;
	assign MAC_Rx_Clk = GXB_rx_clk;	
	
	*/
	
	assign MAC_RegSelect = (address[7]==1'b1)?1'b1:1'b0;
	assign MAC_RdnWr = ~(write & (~read)& (~MAC_RegSelect));
	assign MAC_RegAddr[7:1] = address[6:0];
	assign MAC_RegDin = writedata;
	//Multiplex data out
	assign readdata = ((~MAC_RegSelect) & (~GXB_cs))?MAC_RegDout:GXB_readdata;
	//wait signal
	assign waitreq = (GXB_wait & GXB_cs) | (MAC_RegWait & (~MAC_RegSelect));
	
	reg MAC_RegSelect_rd ;
	assign MAC_RegWait = (~MAC_RegSelect_rd) & (~MAC_RegSelect & read);
	always@(posedge regclk)
	begin
		MAC_RegSelect_rd <= (~MAC_RegSelect & read) ;
	end
		
	assign Tx_mac_wa = Tx_wa;
	assign Tx_wr = Tx_mac_wr;
	assign Tx_sop = Tx_mac_sop;
	assign Tx_eop = Tx_mac_eop;
	assign Tx_BE = Tx_mac_BE;
	assign Tx_data = Tx_mac_data;
	//MAC BLOCK
//	assign Tx_data 	= LoopbackFIFO_dout[31:0];
//	assign Tx_BE 	= LoopbackFIFO_dout[35:34];
//	assign Tx_sop 	= LoopbackFIFO_dout[32];
//	assign Tx_eop 	= LoopbackFIFO_dout[33];
//	assign LoopbackFIFO_din = {Rx_BE,Rx_eop,Rx_sop, Rx_data};
	
//	always@(posedge sysclk)
//	begin
//		
//		Rx_rd <= Rx_ra & (~LoopbackFIFO_full);
//		LoopbackFIFO_rden <= Tx_wa & (~LoopbackFIFO_empty);	
//		Tx_wr <= LoopbackFIFO_rden;	 
//		
//	end
//	assign LoopbackFIFO_wren = Rx_pa;
		
//	//Loopback FIFO block
//	lpbff	lpbff_inst (
//	.data ( LoopbackFIFO_din ),
//	.rdreq ( LoopbackFIFO_rden ),
//	.clock (sysclk),
//	.wrreq ( LoopbackFIFO_wren ),
//	.q ( LoopbackFIFO_dout ),
//	.almost_empty (LoopbackFIFO_empty ),
//	.almost_full (LoopbackFIFO_full )
//	);

	assign Rx_mac_ra = Rx_ra;
	assign Rx_mac_pa = Rx_pa;
	assign Rx_mac_BE = Rx_BE;
	assign Rx_mac_sop = Rx_sop;
	assign Rx_mac_eop = Rx_eop;
	assign Rx_rd = Rx_mac_rd;
	assign Rx_mac_data = Rx_data;

endmodule

		