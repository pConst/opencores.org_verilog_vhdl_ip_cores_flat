`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:57:12 06/01/2010 
// Design Name: 
// Module Name:    GMII2RGMII 
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
module GMII2RGMII(
    input [7:0] TxD,
    input TxClk,
    input TxEn,
    input TxErr,
    input TxClk90,
    output [3:0] RGMII_TxD,
    output RGMII_TxCtl,
    output RGMII_TxClk,
	 input ClkEN,
	 input rst
    );

	reg [3:0] TxHighNib;
	reg [3:0] TxHighNib2;
	reg [3:0] TxLowNib;
	reg 	TX_EN1;
	wire 	EN_xor_ERR1;
	reg	EN_xor_ERR2;
	reg	EN_xor_ERR3;

	wire 	DDR_R;
	reg 	DDR_S;
	wire 	DDR_CE;

	wire [5:0] dataout;
	wire [5:0] datain_h;
	wire [5:0] datain_l;
	

	initial 
	begin	
	DDR_S <= 0;	
	end
	
	assign DDR_CE = ClkEN;
	assign DDR_R = rst;
	
	always@(posedge(TxClk))
	begin
			TxLowNib <= TxD[3:0];		
			TxHighNib <= TxD[7:4];
	end
		
	always@(posedge(TxClk))
	begin
		TX_EN1 <= TxEn;
		EN_xor_ERR2 <= EN_xor_ERR1;
	end
	
	assign EN_xor_ERR1 = TxEn^TxErr;
	
	assign datain_h = {1'b1,TX_EN1,TxLowNib};		
	assign datain_l = {1'b0,EN_xor_ERR2,TxHighNib};		
	
	DDR_O ODDR_inst(	.datain_h	(datain_h),
						.datain_l	(datain_l),
						.outclock	(TxClk),
						.dataout	(dataout));

	assign RGMII_TxD = dataout[3:0];
	assign RGMII_TxCtl = dataout[4];
		
	DDR_O_CLK ODDRCLK_inst(	.datain_h	(1'b1),
						.datain_l	(1'b0),
						.outclock	(TxClk90),
						.dataout	(RGMII_TxClk));

	
	
endmodule
