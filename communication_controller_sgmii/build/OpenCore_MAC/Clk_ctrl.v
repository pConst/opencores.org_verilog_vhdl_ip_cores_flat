//////////////////////////////////////////////////////////////////////
////                                                              ////
////  Clk_ctrl.v                                                  ////
////                                                              ////
////  This file is part of the Ethernet IP core project           ////
////  http://www.opencores.org/projects.cgi/web/ethernet_tri_mode/////
////                                                              ////
////  Author(s):                                                  ////
////      - Jon Gao (gaojon@yahoo.com)                            ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2001 Authors                                   ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//                                                                    
// CVS Revision History                                               
//                                                                    
// $Log: not supported by cvs2svn $
// Revision 1.2  2005/12/16 06:44:13  Administrator
// replaced tab with space.
// passed 9.6k length frame test.
//
// Revision 1.1.1.1  2005/12/13 01:51:44  Administrator
// no message
// 

module Clk_ctrl(   
Reset           ,
Clk_125M        ,
Clk_25M,
Clk_125M_90,
Clk_25M_90,
//host interface,
Speed           ,
//Phy interface ,
Gtx_clk         ,
Rx_clk          ,
//Tx_clk          , //Replace this clock by Clk_25M
//interface clk ,
MAC_tx_clk_d	,
MAC_tx_clk      ,
MAC_rx_clk      ,
MAC_tx_clk_div  ,
MAC_rx_clk_div  
);
input           Reset           ;
input           Clk_125M        ;
input			Clk_25M;
input			Clk_125M_90;
input			Clk_25M_90;

                //host interface
input   [2:0]   Speed           ;       
                //Phy interface         
output          Gtx_clk         ;//used only in GMII mode
input           Rx_clk          ;
//input           Tx_clk          ;//used only in MII mode
                //interface clk signals
output          MAC_tx_clk      ;
output          MAC_rx_clk      ;
output          MAC_tx_clk_div  ;
output          MAC_rx_clk_div  ;
output 			MAC_tx_clk_d;

//******************************************************************************
//internal signals                                                              
//******************************************************************************
wire            Rx_clk_div2 ;
wire            Tx_clk_div2 ;
wire 			transmit_clk;
wire 		clk_125_0;
wire 		clk_125_90;
wire 		clk_25_0;
wire 		clk_25_90;

assign clk_125_0 	= Clk_125M;
assign clk_25_0 	= Clk_25M;
assign clk_125_90	= Clk_125M_90;
assign clk_25_90	= Clk_25M_90;

//******************************************************************************
//                                                              
//******************************************************************************

assign MAC_rx_clk   =	Rx_clk;
assign MAC_tx_clk	= 	transmit_clk;
assign Gtx_clk 		= 	transmit_clk;




CLK_DIV2 U_0_CLK_DIV2(
.Reset          (Reset          ),
.IN             (Rx_clk         ),
.OUT            (Rx_clk_div2    )
);
//
CLK_DIV2 U_1_CLK_DIV2(
.Reset          (Reset          ),
.IN             (clk_25_0       ),
.OUT            (Tx_clk_div2    )
);
//

CLK_SWITCH_ALT2 U_0_CLK_SWITCH(
.IN_0           (Rx_clk_div2    ),
.IN_1           (Rx_clk         ),
.SW             (Speed[2]       ),
.OUT            (MAC_rx_clk_div )
);

//
//CLK_SWITCH_ALT2 U_2_CLK_SWITCH(
//.IN_0           (Tx_clk_div2    ),
//.IN_1           (clk_125_0      ),
//.SW             (Speed[2]       ),
//.OUT            ( )
//);

assign MAC_tx_clk_div = clk_125_0;

//CLK_SWITCH_ALT2 U_1_CLK_SWITCH(
//.IN_0           (clk_25_0  		),
//.IN_1           (clk_125_0      ),
//.SW             (Speed[2]       ),
//.OUT            (transmit_clk )
//);

assign transmit_clk = clk_125_0;


//
CLK_SWITCH_ALT2 U_3_CLK_SWITCH(
.IN_0           (clk_25_90    ),
.IN_1           (clk_125_90   	),
.SW             (Speed[2]       ),
.OUT            (MAC_tx_clk_d)
);




endmodule
