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
//-- Source file: dma_core_ahbm_wr.v
//---------------------------------------------------------



module dma_ahb64_core0_ahbm_wr(clk,reset,rd_transfer,rd_transfer_size,joint_req,joint_in_prog,joint_stall,wr_last_cmd,wr_ch_num,wr_ch_num_resp,wr_port_num,wr_cmd_port,wr_burst_start,wr_burst_addr,wr_burst_size,wr_cmd_pending,wr_line_cmd,ch_fifo_rd,ch_fifo_rd_num,ch_fifo_rdata,ch_fifo_rd_valid,ch_fifo_rsize,ch_fifo_wr_ready,wr_transfer,wr_transfer_num,wr_transfer_size,wr_next_size,wr_slverr,wr_clr,wr_clr_last,wr_clr_line,wr_clr_line_num,wr_cmd_full,wr_hold,ahb_wr_timeout,ahb_wr_timeout_num,HADDR,HBURST,HSIZE,HTRANS,HLAST,HWDATA,HREADY,HRESP,HOLD,SYNC);

   
   input               clk;
   input               reset;

   input               rd_transfer;
   input [4-1:0]      rd_transfer_size;
   input               joint_req;
   input               joint_in_prog;
   output               joint_stall;
   
   //command
   input               wr_last_cmd;
   input [2:0]               wr_ch_num;
   output [2:0]           wr_ch_num_resp;
   output               wr_port_num;
   input               wr_cmd_port;
   input               wr_burst_start;
   input [32-1:0]      wr_burst_addr;
   input [8-1:0]     wr_burst_size;
   output               wr_cmd_pending;
   input               wr_line_cmd;
   
   //data
   output               ch_fifo_rd;
   output [2:0]           ch_fifo_rd_num;
   input [64-1:0]      ch_fifo_rdata;
   input               ch_fifo_rd_valid;
   output [4-1:0]     ch_fifo_rsize;
   input               ch_fifo_wr_ready;
   output               wr_transfer;
   output [2:0]           wr_transfer_num;
   output [4-1:0]     wr_transfer_size;
   output [4-1:0]     wr_next_size;
   
   //resp
   output               wr_slverr;
   output               wr_clr;
   output               wr_clr_last;
   output               wr_clr_line;
   output [2:0]           wr_clr_line_num;
   output               wr_cmd_full;
   output               wr_hold;
   output               ahb_wr_timeout;
   output [2:0]           ahb_wr_timeout_num;
   
   output [32-1:0]     HADDR;
   output [2:0]           HBURST;
   output [1:0]           HSIZE;
   output [1:0]           HTRANS;
   output               HLAST;
   output [64-1:0]     HWDATA;              
   input               HREADY;
   input               HRESP;
   input               HOLD;
   input               SYNC;
      

   
   wire [32-1:0]       HADDR_base;
   wire [2:0]               HBURST_pre;
   wire [1:0]               HSIZE_pre;
   wire [2:0]               HBURST;
   wire [1:0]               HSIZE;
   reg [1:0]               HTRANS;
   wire [64-1:0]       HWDATA;
   wire               wr_last_cmd_out;
   
   wire               ch_fifo_rd_last;
   wire               data_ready_pre;
   wire               data_ready;
   reg                   data_phase;
   reg [3:0]               data_counter;
   wire [3:0]               data_num_pre;
   wire [3:0]               data_num;
   wire               data_last;
   wire               data_pending_pre;
   wire               data_pending;
   wire [8-1:3] strb_num;
   reg [3:0]              cmd_counter;
   reg [3:0]               last_counter;
   wire [3:0]               cmd_num;
   wire               cmd_single_in;
   wire               cmd_single_out;
   wire               cmd_last;
   wire               cmd_empty;
   wire               cmd_full;
   wire               cmd_data_empty;
   wire               cmd_data_full;
   wire               data_empty;
   wire               data_full;
   wire [2:0]               data_fullness_pre;
   reg [2:0]               data_fullness;
   reg [1:0]               data_on_the_way;
   wire [4-1:0]       data_width;
   wire               ahb_cmd;
   wire               ahb_cmd_first;
   wire               ahb_cmd_last;
   wire               ahb_data_last;
   wire               ahb_idle;
   wire               ahb_busy;
   wire [4-1:0]       wr_next_size_in;
   wire               wr_transfer_pre;
   reg [4-1:0]           wr_transfer_size_pre;
   reg [2:0]               wr_transfer_num_pre;
   wire               wr_transfer;
   reg [4-1:0]           wr_transfer_size;
   reg [2:0]               wr_transfer_num;
   reg [2:0]               wr_ch_num_resp;
   wire               wr_port_num;
   wire [2:0]               wr_ch_num_out;
   wire [2:0]               ch_fifo_rd_num;
   wire               wr_clr_pre;
   wire               wr_clr;
   wire               wr_clr_last_pre;
   wire               wr_clr_last;
   wire               wr_clr_line_pre;
   wire               wr_clr_line_pre_d;
   wire               wr_clr_line_stall;
   wire               wr_clr_line;
   wire               wr_line_out;
   wire               port_change;
   wire               port_change_end;
   reg [2:0]               wr_clr_line_num_reg;
   reg                   ahb_cmd_last_d;
   reg                   wr_last_cmd_d;
   wire               wr_last_cmd_valid;
   wire               cmd_pending_pre;
   wire               wr_slverr_pre;
   reg                   wr_slverr_reg;
   
   wire               joint_req_out;
   wire [4-1:0]       rd_transfer_size_joint;
   wire               rd_transfer_full;
   wire               joint_stall;
   wire               joint_fifo_rd_valid;
   

   
   
   parameter                  TRANS_IDLE   = 2'b00;
   parameter                  TRANS_BUSY   = 2'b01;
   parameter                  TRANS_NONSEQ = 2'b10;
   parameter               TRANS_SEQ    = 2'b11;
   
   parameter                  BURST_SINGLE = 3'b000;
   parameter               BURST_INCR4  = 3'b011;
   parameter               BURST_INCR8  = 3'b101;
   parameter               BURST_INCR16 = 3'b111;


   
   prgen_joint_stall #(4)
     gen_joint_stall (
              .clk(clk),
              .reset(reset),
              .joint_req_out(joint_req_out),
              .rd_transfer(rd_transfer),
              .rd_transfer_size(rd_transfer_size),
              .ch_fifo_rd(ch_fifo_rd),
              .data_fullness_pre(data_fullness_pre),
              .HOLD(HOLD),
              .joint_fifo_rd_valid(joint_fifo_rd_valid),
              .rd_transfer_size_joint(rd_transfer_size_joint),
              .rd_transfer_full(rd_transfer_full),
              .joint_stall(joint_stall)
              );


   
   
   prgen_delay #(2) delay_fifo_rd0 (.clk(clk), .reset(reset), .din(ch_fifo_rd), .dout(data_ready_pre));
   prgen_delay #(1) delay_fifo_rd1 (.clk(clk), .reset(reset), .din(data_ready_pre), .dout(data_ready));
         

   assign               ch_fifo_rd = 
                  joint_fifo_rd_valid |
                  
                  ((~cmd_data_empty) &
                   (~data_pending) &
                   (~wr_clr_line_stall) &
                   (~joint_in_prog) &
                   & ch_fifo_wr_ready);

   
   assign               wr_hold          = cmd_full;     
   assign               ch_fifo_rd_last  = ch_fifo_rd & data_last; 
   assign               cmd_pending_pre  = HTRANS[1] & (~HREADY);
   
   assign               ahb_cmd          = HTRANS[1] & HREADY & (~HOLD);
   assign               ahb_cmd_first    = ahb_cmd & (HTRANS[1:0] == TRANS_NONSEQ);
   assign               ahb_cmd_last     = ahb_cmd & cmd_last;
   assign               ahb_idle         = HTRANS[1:0] == TRANS_IDLE;
   assign               ahb_busy         = HTRANS[1:0] == TRANS_BUSY;
   
   assign               wr_transfer_pre  = data_phase & HREADY;
   assign               wr_slverr_pre    = data_phase & HREADY & HRESP;
   assign               wr_clr_line_pre  = ch_fifo_rd_last & wr_line_out;
   
   assign               wr_cmd_full      = cmd_data_full | cmd_full;

   prgen_stall stall_wr_clr (.clk(clk), .reset(reset), .din(ahb_data_last), .stall(SYNC), .dout(wr_clr_pre));
   prgen_stall stall_wr_clr_last (.clk(clk), .reset(reset), .din(wr_last_cmd_valid), .stall(SYNC), .dout(wr_clr_last_pre));
   
   prgen_delay #(1) delay_wr_clr (.clk(clk), .reset(reset), .din(wr_clr_pre), .dout(wr_clr));
   prgen_delay #(1) delay_wr_clr_last (.clk(clk), .reset(reset), .din(wr_clr_last_pre), .dout(wr_clr_last));
   
   prgen_delay #(1) delay_cmd_pending (.clk(clk), .reset(reset), .din(cmd_pending_pre), .dout(wr_cmd_pending));
   
   always @(posedge clk or posedge reset)
     if (reset)
       ahb_cmd_last_d <= #1 1'b0;
     else if (ahb_cmd_last)
       ahb_cmd_last_d <= #1 1'b1;
     else if (ahb_data_last)
       ahb_cmd_last_d <= #1 1'b0;

   always @(posedge clk or posedge reset)
     if (reset)
       wr_last_cmd_d <= #1 1'b0;
     else if (ahb_cmd_last)
       wr_last_cmd_d <= #1 wr_last_cmd_out;
     else if (ahb_data_last)
       wr_last_cmd_d <= #1 1'b0;

   always @(posedge clk or posedge reset)
     if (reset)
       wr_slverr_reg <= #1 1'b0;
     else if (wr_slverr_pre)
       wr_slverr_reg <= #1 1'b1;
     else if (wr_slverr)
       wr_slverr_reg <= #1 1'b0;

   assign               wr_slverr = wr_slverr_reg & wr_clr;
   
   assign               ahb_data_last     = ahb_cmd_last_d & HREADY;
   assign               wr_last_cmd_valid = wr_last_cmd_d & ahb_data_last;

   

   assign               wr_clr_line       = 1'b0;
   assign               wr_clr_line_stall = 1'b0;
   assign               wr_clr_line_num   = 3'd0;
      
   

   assign               cmd_num          = 
                  HBURST == BURST_INCR16 ? 4'd15 :
                  HBURST == BURST_INCR8  ? 4'd7 :
                  HBURST == BURST_INCR4  ? 4'd3 : 4'd0;

   assign               cmd_last         = cmd_single_out | (last_counter == 'd0);
   
   always @(posedge clk or posedge reset)
     if (reset)
       last_counter <= #1 4'hf;
     else if (ahb_cmd & (HTRANS == TRANS_NONSEQ))
       last_counter <= #1 cmd_num - 1'b1;
     else if (ahb_cmd)
       last_counter <= #1 last_counter - 1'b1;

   always @(posedge clk or posedge reset)
     if (reset)
       cmd_counter <= #1 4'd0;
     else if (ahb_cmd_last)
       cmd_counter <= #1 4'd0;
     else if (ahb_cmd)
       cmd_counter <= #1 cmd_counter + 1'b1;

   assign               data_last        = data_counter == data_num;
   
   always @(posedge clk or posedge reset)
     if (reset)
       data_counter <= #1 4'd0;
     else if (ch_fifo_rd & data_last)
       data_counter <= #1 4'd0;
     else if (ch_fifo_rd)
       data_counter <= #1 data_counter + 1'b1;
   
   always @(posedge clk or posedge reset)
     if (reset)
       data_phase <= #1 1'b0;
     else if (ahb_cmd)
       data_phase <= #1 1'b1;
     else if (ahb_data_last)
       data_phase <= #1 1'b0;
   

   assign               data_width = 
                  HSIZE == 2'b00 ? 'd1 :
                  HSIZE == 2'b01 ? 'd2 : 
                  HSIZE == 2'b10 ? 'd4 : 'd8;

   assign               wr_next_size_in = {|wr_burst_size[8-1:3], wr_burst_size[3-1:0]};
   
   assign               ch_fifo_rsize = joint_fifo_rd_valid ? rd_transfer_size_joint : wr_next_size;
   
   assign               HADDR = HADDR_base | {cmd_counter, {3{1'b0}}};
   
   assign               strb_num = wr_burst_size[8-1:3];

   assign               cmd_single_in = strb_num <= 'd1;
   
   assign               data_num_pre = 
                  strb_num == 'd16 ? 'd15 :
                  strb_num == 'd8  ? 'd7  :
                  strb_num == 'd4  ? 'd3  : 'd0;
   
   assign               HBURST_pre =
                  strb_num == 'd16 ? BURST_INCR16 :
                  strb_num == 'd8  ? BURST_INCR8  :
                  strb_num == 'd4  ? BURST_INCR4  : BURST_SINGLE;

   assign               HSIZE_pre =
                  wr_burst_size == 'd1 ? 2'b00 :
                  wr_burst_size == 'd2 ? 2'b01 : 
                  wr_burst_size == 'd4 ? 2'b10 : 3;

   assign               HLAST = cmd_last & (~cmd_empty);
   
   always @(posedge clk or posedge reset)
     if (reset)
       HTRANS <= #1 TRANS_IDLE;
     else if (port_change)
       HTRANS <= #1 TRANS_IDLE;
     else if (ahb_idle & port_change_end & (data_fullness_pre > 'd0))
       HTRANS <= #1 TRANS_NONSEQ;
     else if (ahb_cmd_last & ((data_fullness > 'd2) | data_ready_pre)) //burst end and data ready
       HTRANS <= #1 TRANS_NONSEQ;
     else if (ahb_idle & ((data_fullness > 'd1) | data_ready_pre)) //bus idle and data ready
       HTRANS <= #1 TRANS_NONSEQ;
     else if (ahb_cmd_last)
       HTRANS <= #1 TRANS_IDLE;
     else if (ahb_cmd & (data_fullness_pre <= 'd1) & (~data_ready_pre))
       HTRANS <= #1 TRANS_BUSY;
     else if (ahb_cmd | (ahb_busy & data_ready_pre))
       HTRANS <= #1 TRANS_SEQ;
   
   always @(posedge clk or posedge reset)
     if (reset)
       begin
      wr_transfer_size_pre <= #1 {4{1'b0}};
      wr_transfer_num_pre  <= #1 3'd0;
       end
     else if (ahb_cmd)
       begin
      wr_transfer_size_pre <= #1 data_width;
      wr_transfer_num_pre  <= #1 wr_ch_num_out;
       end

   prgen_delay #(1) delay_wr_transfer (.clk(clk), .reset(reset), .din(wr_transfer_pre), .dout(wr_transfer));
   
   always @(posedge clk or posedge reset)
     if (reset)
       begin
      wr_transfer_num  <= #1 3'd0;
      wr_transfer_size <= #1 3'd0;
       end
     else if (wr_transfer_pre)
       begin
      wr_transfer_num  <= #1 wr_transfer_num_pre;
      wr_transfer_size <= #1 wr_transfer_size_pre;
       end
   
   always @(posedge clk or posedge reset)
     if (reset)
       wr_ch_num_resp <= #1 3'd0;
     else if (ahb_data_last)
       wr_ch_num_resp <= #1 wr_transfer_num_pre;
   

   prgen_fifo #(32+3+2+1+1+3+1+1, 2+1) 
   cmd_fifo(
        .clk(clk),
        .reset(reset),
        .push(wr_burst_start),
        .pop(ahb_cmd_last),
        .din({wr_burst_addr,
          HBURST_pre,
          HSIZE_pre,
          wr_last_cmd,
          wr_cmd_port,
          wr_ch_num,
          joint_req,
          cmd_single_in
          }),
        .dout({HADDR_base,
           HBURST,
           HSIZE,
           wr_last_cmd_out,
           wr_port_num,
           wr_ch_num_out,
           joint_req_out,
           cmd_single_out
           }),
        .empty(cmd_empty),
        .full(cmd_full)
        );

   
   prgen_fifo #(4+4+3+1, 2+1)
   cmd_data_fifo(
         .clk(clk),
         .reset(reset),
         .push(wr_burst_start),
         .pop(ch_fifo_rd_last),
         .din({wr_next_size_in,
               data_num_pre,
               wr_ch_num,
               wr_line_cmd
               }),
         .dout({wr_next_size,
            data_num,
            ch_fifo_rd_num,
            wr_line_out
            }),
         .empty(cmd_data_empty),
         .full(cmd_data_full)
         );


   assign port_change     = 1'b0;
   assign port_change_end = 1'b0;
   
   
   assign data_fullness_pre = data_fullness + data_ready - wr_transfer_pre;
   
   always @(posedge clk or posedge reset)
     if (reset)
       data_fullness <= #1 3'd0;
     else if (data_ready | wr_transfer_pre)
       data_fullness <= #1 data_fullness_pre;

   always @(posedge clk or posedge reset)
     if (reset)
       data_on_the_way <= #1 2'd0;
     else if (ch_fifo_rd | data_ready)
       data_on_the_way <= #1 data_on_the_way + ch_fifo_rd - data_ready;
   
   assign data_pending_pre =  ((data_fullness + data_on_the_way) > 'd3) & (~wr_transfer_pre);

   prgen_delay #(1) delay_data_pending (.clk(clk), .reset(reset), .din(data_pending_pre), .dout(data_pending));

   //depth is set by maximum fifo read data latency
   prgen_fifo #(64, 5+2)
   data_fifo(
                      .clk(clk),
                      .reset(reset),
                      .push(data_ready),
                      .pop(wr_transfer_pre),
                      .din(ch_fifo_rdata),
                      .dout(HWDATA),
                      .empty(data_empty),
                      .full(data_full)
                      );
   
   
   dma_ahb64_core0_ahbm_timeout  dma_ahb64_core0_ahbm_timeout (
                             .clk(clk),
                             .reset(reset),
                             .HTRANS(HTRANS),
                             .HREADY(HREADY),
                             .ahb_timeout(ahb_wr_timeout)
                             );
                      
   assign                     ahb_wr_timeout_num = wr_ch_num_out;
   

                      
endmodule

  


