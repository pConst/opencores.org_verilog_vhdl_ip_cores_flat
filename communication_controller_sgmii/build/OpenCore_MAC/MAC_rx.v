//////////////////////////////////////////////////////////////////////
////                                                              ////
////  MAC_rx.v                                                    ////
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
// Revision 1.3  2006/01/19 14:07:52  maverickist
// verification is complete.
//
// Revision 1.2  2005/12/16 06:44:13  Administrator
// replaced tab with space.
// passed 9.6k length frame test.
//
// Revision 1.1.1.1  2005/12/13 01:51:44  Administrator
// no message
//
`include "header.v"

module MAC_rx (
output [23:0]	 Monitoring,
input           Reset   ,
input           Clk_user,
input           Clk     ,
                //RMII interface
input           MCrs_dv ,       
input   [7:0]   MRxD    ,       
input           MRxErr  ,       
                //flow_control signals  
output  [15:0]  pause_quanta        ,   
output          pause_quanta_val    ,   
                //user interface 
output          Rx_mac_ra   ,
input           Rx_mac_rd   ,
output  [31:0]  Rx_mac_data ,
output  [1:0]   Rx_mac_BE   ,
output          Rx_mac_pa   ,
output          Rx_mac_sop  ,
output          Rx_mac_eop  ,
                //CPU
input           MAC_rx_add_chk_en   ,   
input   [7:0]   MAC_add_prom_data   ,   
input   [2:0]   MAC_add_prom_add    ,   
input           MAC_add_prom_wr     ,   
input           broadcast_filter_en     ,
input   [15:0]  broadcast_bucket_depth              ,    
input   [15:0]  broadcast_bucket_interval           ,
input           RX_APPEND_CRC,
input   [4:0]   Rx_Hwmark           ,
input   [4:0]   Rx_Lwmark           ,
input           CRC_chk_en  ,               
input   [5:0]   RX_IFG_SET    ,
input   [15:0]  RX_MAX_LENGTH   ,// 1518
input   [6:0]   RX_MIN_LENGTH   ,// 64
                //RMON interface
output  [15:0]  Rx_pkt_length_rmon      ,
output          Rx_apply_rmon           ,
output  [2:0]   Rx_pkt_err_type_rmon    ,
output  [2:0]   Rx_pkt_type_rmon        
);
//******************************************************************************
//internal signals                                                              
//******************************************************************************
                //CRC_chk interface
wire            CRC_en  ;       
wire            CRC_init;       
wire            CRC_err ;
                //MAC_rx_add_chk interface
wire            MAC_add_en          ;
wire            MAC_rx_add_chk_err  ;
                //broadcast_filter
wire            broadcast_ptr           ;
wire            broadcast_drop          ;
                //flow_control signals  
//wire    [15:0]  pause_quanta        ;   
//wire            pause_quanta_val    ;
                //MAC_rx_ctrl interface 
wire    [7:0]   Fifo_data       ;
wire            Fifo_data_en    ;
wire            Fifo_full       ;
wire            Fifo_data_err   ;
wire            Fifo_data_end   ;
//******************************************************************************
//instantiation                                                            
//******************************************************************************

assign Monitoring = {1'b0,Clk,MCrs_dv,MRxErr,Fifo_data_err,Fifo_data_end,Fifo_data_en,Fifo_full,
							Fifo_data,
							MRxD};

MAC_rx_ctrl U_MAC_rx_ctrl(
.Reset                       (Reset                     ),                                              
.Clk                         (Clk                       ),                                                 
  //RMII interface           ( //RMII interface         ),                                                    
.MCrs_dv                     (MCrs_dv                   ),                             
.MRxD                        (MRxD                      ),                         
.MRxErr                      (MRxErr                    ),                             
 //CRC_chk interface         (//CRC_chk interface       ),                                                   
.CRC_en                      (CRC_en                    ),                                          
.CRC_init                    (CRC_init                  ),                           
.CRC_err                     (CRC_err                   ),                              
 //MAC_rx_add_chk interface  (//MAC_rx_add_chk interface),                                                   
.MAC_add_en                  (MAC_add_en                ),                                             
.MAC_rx_add_chk_err          (MAC_rx_add_chk_err        ),                             
 //broadcast_filter          (//broadcast_filter        ),                           
.broadcast_ptr               (broadcast_ptr             ),                         
.broadcast_drop              (broadcast_drop            ),                             
 //flow_control signals      (//flow_control signals    ),                           
.pause_quanta                (pause_quanta              ),                         
.pause_quanta_val            (pause_quanta_val          ),                         
 //MAC_rx_FF interface       (//MAC_rx_FF interface     ),                                                   
.Fifo_data                   (Fifo_data                 ),                                         
.Fifo_data_en                (Fifo_data_en              ),                                         
.Fifo_data_err               (Fifo_data_err             ),                         
.Fifo_data_end               (Fifo_data_end             ),                         
.Fifo_full                   (Fifo_full                 ),                                      
 //RMON interface            (//RMON interface          ),                               
.Rx_pkt_type_rmon            (Rx_pkt_type_rmon          ),                                        
.Rx_pkt_length_rmon          (Rx_pkt_length_rmon        ),                                             
.Rx_apply_rmon               (Rx_apply_rmon             ),                                         
.Rx_pkt_err_type_rmon        (Rx_pkt_err_type_rmon      ),                                         
 //CPU                       (//CPU                     ),   
.RX_IFG_SET                  (RX_IFG_SET                ),                             
.RX_MAX_LENGTH               (RX_MAX_LENGTH             ),                           
.RX_MIN_LENGTH               (RX_MIN_LENGTH             )                           
);

MAC_rx_FF  U_MAC_rx_FF (
.Reset                       (Reset                     ),
.Clk_MAC                     (Clk                       ), 
.Clk_SYS                     (Clk_user                  ), 
 //MAC_rx_ctrl interface     (//MAC_rx_ctrl interface   ),
.Fifo_data                   (Fifo_data                 ),
.Fifo_data_en                (Fifo_data_en              ),
.Fifo_full                   (Fifo_full                 ),
.Fifo_data_err               (Fifo_data_err             ),
.Fifo_data_end               (Fifo_data_end             ),
 //CPU                       (//CPU                     ),
.Rx_Hwmark                   (Rx_Hwmark                 ),
.Rx_Lwmark                   (Rx_Lwmark                 ),
.RX_APPEND_CRC               (RX_APPEND_CRC             ),
 //user interface            (//user interface          ),
.Rx_mac_ra                   (Rx_mac_ra                 ),
.Rx_mac_rd                   (Rx_mac_rd                 ),
.Rx_mac_data                 (Rx_mac_data               ), 
.Rx_mac_BE                   (Rx_mac_BE                 ),
.Rx_mac_sop                  (Rx_mac_sop                ), 
.Rx_mac_pa                   (Rx_mac_pa                 ),
.Rx_mac_eop                  (Rx_mac_eop                ) 
); 

`ifdef MAC_BROADCAST_FILTER_EN
Broadcast_filter U_Broadcast_filter(
.Reset                      (Reset                      ),
.Clk                        (Clk                        ),
 //MAC_rx_ctrl              (//MAC_rx_ctrl              ),
.broadcast_ptr              (broadcast_ptr              ),
.broadcast_drop             (broadcast_drop             ),
 //FromCPU                  (//FromCPU                  ),
.broadcast_filter_en        (broadcast_filter_en        ),
.broadcast_bucket_depth     (broadcast_bucket_depth     ),           
.broadcast_bucket_interval  (broadcast_bucket_interval  )
); 
`else
assign broadcast_drop=0;
`endif

CRC_chk U_CRC_chk(
.Reset                      (Reset                      ),
.Clk                        (Clk                        ),
.CRC_data                   (Fifo_data                  ),
.CRC_init                   (CRC_init                   ),
.CRC_en                     (CRC_en                     ),
 //From CPU                 (//From CPU                 ),
.CRC_chk_en                 (CRC_chk_en                 ),
.CRC_err                    (CRC_err                    )
);   

`ifdef MAC_TARGET_CHECK_EN
MAC_rx_add_chk U_MAC_rx_add_chk(
.Reset                      (Reset                      ),
.Clk                        (Clk                        ),
.Init                       (CRC_init                   ),
.data                       (Fifo_data                  ),
.MAC_add_en                 (MAC_add_en                 ),
.MAC_rx_add_chk_err         (MAC_rx_add_chk_err         ),
 //From CPU                 (//From CPU                 ),
.MAC_rx_add_chk_en          (MAC_rx_add_chk_en          ),
.MAC_add_prom_data          (MAC_add_prom_data          ),
.MAC_add_prom_add           (MAC_add_prom_add           ),
.MAC_add_prom_wr            (MAC_add_prom_wr            )
);
`else
assign MAC_rx_add_chk_err=0;
`endif



endmodule