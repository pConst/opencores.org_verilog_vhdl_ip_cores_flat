/////////////////////////////////////////////////////////////////////
////                                                             ////
////  Author: Eyal Hochberg                                      ////
////          eyal@provartec.com                                 ////
////                                                             ////
////  Downloaded from: http://www.opencores.org                  ////
/////////////////////////////////////////////////////////////////////
////                                                             ////
//// Copyright (C) 2010 Provartec LTD                            ////
//// www.provartec.com                                           ////
//// info@provartec.com                                          ////
////                                                             ////
//// This source file may be used and distributed without        ////
//// restriction provided that this copyright statement is not   ////
//// removed from the file and that any derivative work contains ////
//// the original copyright notice and the associated disclaimer.////
////                                                             ////
//// This source file is free software; you can redistribute it  ////
//// and/or modify it under the terms of the GNU Lesser General  ////
//// Public License as published by the Free Software Foundation.////
////                                                             ////
//// This source is distributed in the hope that it will be      ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied  ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR     ////
//// PURPOSE.  See the GNU Lesser General Public License for more////
//// details. http://www.gnu.org/licenses/lgpl.html              ////
////                                                             ////
/////////////////////////////////////////////////////////////////////
//---------------------------------------------------------
//-- File generated by RobustVerilog parser
//-- Version: 1.0
//-- Invoked Fri Mar 25 23:32:59 2011
//--
//-- Source file: dma_core_top.v
//---------------------------------------------------------



module dma_ahb64_core0_top(clk,reset,scan_en,idle,ch_int_all_proc,ch_start,clkdiv,periph_tx_req,periph_tx_clr,periph_rx_req,periph_rx_clr,pclken,psel,penable,paddr,pwrite,pwdata,prdata,pslverr,pready,rd_port_num,wr_port_num,joint_mode,joint_remote,rd_prio_top,rd_prio_high,rd_prio_top_num,rd_prio_high_num,wr_prio_top,wr_prio_high,wr_prio_top_num,wr_prio_high_num,WHADDR,WHBURST,WHSIZE,WHTRANS,WHWDATA,WHREADY,WHRESP,RHADDR,RHBURST,RHSIZE,RHTRANS,RHRDATA,RHREADY,RHRESP,WHLAST,WHOLD,RHLAST,RHOLD);

   input             clk;
   input             reset;
   input             scan_en;

   output             idle;
   output [8*1-1:0]  ch_int_all_proc;
   input [7:0]                 ch_start;
   input [3:0]             clkdiv;    
   
   input [31:1]         periph_tx_req;
   output [31:1]         periph_tx_clr;
   input [31:1]         periph_rx_req;
   output [31:1]         periph_rx_clr;
   
   input                    pclken;
   input                    psel;
   input                    penable;
   input [10:0]             paddr;
   input                    pwrite;
   input [31:0]             pwdata;
   output [31:0]            prdata;
   output                   pslverr;
   output                   pready;

   output             rd_port_num;
   output             wr_port_num;

   input             joint_mode;
   input             joint_remote;
   input              rd_prio_top;
   input              rd_prio_high;
   input [2:0]             rd_prio_top_num;
   input [2:0]             rd_prio_high_num;
   input              wr_prio_top;
   input              wr_prio_high;
   input [2:0]             wr_prio_top_num;
   input [2:0]             wr_prio_high_num;
   
   output [32-1:0]   WHADDR;
   output [2:0]             WHBURST;
   output [1:0]             WHSIZE;
   output [1:0]             WHTRANS;
   output [64-1:0]   WHWDATA;
   input                    WHREADY;
   input                    WHRESP;
   output [32-1:0]   RHADDR;
   output [2:0]             RHBURST;
   output [1:0]             RHSIZE;
   output [1:0]             RHTRANS;
   input [64-1:0]    RHRDATA;
   input                    RHREADY;
   input                    RHRESP;
   output                   WHLAST;
   input                    WHOLD;
   output                   RHLAST;
   input                    RHOLD;
  
   wire [32-1:0]     slow_WHADDR;
   wire [2:0]               slow_WHBURST;
   wire [1:0]               slow_WHSIZE;
   wire [1:0]               slow_WHTRANS;
   wire [64-1:0]     slow_WHWDATA;
   wire                     slow_WHREADY;
   wire                     slow_WHRESP;
   wire [32-1:0]     slow_RHADDR;
   wire [2:0]               slow_RHBURST;
   wire [1:0]               slow_RHSIZE;
   wire [1:0]               slow_RHTRANS;
   wire [64-1:0]     slow_RHRDATA;
   wire                     slow_RHREADY;
   wire                     slow_RHRESP;
   wire                     slow_WHLAST;
   wire                     slow_WHOLD;
   wire                     slow_RHLAST;
   wire                     slow_RHOLD;
   wire                     slow_WSYNC;
   wire                     slow_RSYNC;
   
   wire             slow_rd_port_num;
   wire             slow_wr_port_num;
   
   wire             clk_out;
   wire             clken;
   wire             bypass;
   
   
  
   assign             clk_out      = clk;
   assign             clken        = 1'b1;

   assign                   WHADDR = slow_WHADDR;
   assign                   WHBURST = slow_WHBURST;
   assign                   WHSIZE = slow_WHSIZE;
   assign                   WHTRANS = slow_WHTRANS;
   assign                   WHWDATA = slow_WHWDATA;
   assign                   RHADDR = slow_RHADDR;
   assign                   RHBURST = slow_RHBURST;
   assign                   RHSIZE = slow_RHSIZE;
   assign                   RHTRANS = slow_RHTRANS;
   assign                   WHLAST = slow_WHLAST;
   assign                   RHLAST = slow_RHLAST;
   assign                   slow_WHREADY = WHREADY;
   assign                   slow_WHRESP = WHRESP;
   assign                   slow_RHRDATA = RHRDATA;
   assign                   slow_RHREADY = RHREADY;
   assign                   slow_RHRESP = RHRESP;
   assign                   slow_WHOLD = WHOLD;
   assign                   slow_RHOLD = RHOLD;
   assign                   slow_WSYNC   = 1'b0;
   assign                   slow_RSYNC   = 1'b0;
   assign             rd_port_num  = slow_rd_port_num;
   assign             wr_port_num  = slow_wr_port_num;
   

   dma_ahb64_core0
   dma_ahb64_core0 (
         .clk(clk_out),
         .reset(reset),
         .scan_en(scan_en),

         .idle(idle),
         .ch_int_all_proc(ch_int_all_proc),
         .ch_start(ch_start),
      
         .periph_tx_req(periph_tx_req),
         .periph_tx_clr(periph_tx_clr),
         .periph_rx_req(periph_rx_req),
         .periph_rx_clr(periph_rx_clr),

         .pclk(clk),
         .clken(clken),
         .pclken(pclken),
         .psel(psel),
         .penable(penable),
         .paddr(paddr[10:0]),
         .pwrite(pwrite),
         .pwdata(pwdata),
         .prdata(prdata),
         .pslverr(pslverr),

         .joint_mode_in(joint_mode),
         .joint_remote(joint_remote),
         .rd_prio_top(rd_prio_top),
         .rd_prio_high(rd_prio_high),
         .rd_prio_top_num(rd_prio_top_num),
         .rd_prio_high_num(rd_prio_high_num),
         .wr_prio_top(wr_prio_top),
         .wr_prio_high(wr_prio_high),
         .wr_prio_top_num(wr_prio_top_num),
         .wr_prio_high_num(wr_prio_high_num),
         
         .rd_port_num(slow_rd_port_num),
         .wr_port_num(slow_wr_port_num),
         
         .WHADDR(slow_WHADDR),
         .WHBURST(slow_WHBURST),
         .WHSIZE(slow_WHSIZE),
         .WHTRANS(slow_WHTRANS),
         .WHWDATA(slow_WHWDATA),
         .WHREADY(slow_WHREADY),
         .WHRESP(slow_WHRESP),
         .RHADDR(slow_RHADDR),
         .RHBURST(slow_RHBURST),
         .RHSIZE(slow_RHSIZE),
         .RHTRANS(slow_RHTRANS),
         .RHRDATA(slow_RHRDATA),
         .RHREADY(slow_RHREADY),
         .RHRESP(slow_RHRESP),
         .WHLAST(slow_WHLAST),
         .WHOLD(slow_WHOLD),
         .RHLAST(slow_RHLAST),
         .RHOLD(slow_RHOLD),
         .WSYNC(slow_WSYNC),
         .RSYNC(slow_RSYNC)
         );

   

   
endmodule





   


