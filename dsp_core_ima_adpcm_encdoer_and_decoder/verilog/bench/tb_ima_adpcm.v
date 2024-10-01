//---------------------------------------------------------------------------------------
//	Project:	ADPCM Encoder / Decoder 
// 
//	Filename:	tb_ima_adpcm.v			(April 26, 2010 )
// 
//	Author(s):	Moti Litochevski 
// 
//	Description:
//		This file implements the ADPCM encoder & decoder test bench. The input samples 
//		to be encoded are read from a binary input file. The encoder stream output and 
//		decoded samples are also compared with binary files generated by the Scilab 
//		simulation.
//
//---------------------------------------------------------------------------------------
//
//	To Do: 
//	- 
// 
//---------------------------------------------------------------------------------------
// 
//	Copyright (C) 2010 Moti Litochevski 
// 
//	This source file may be used and distributed without restriction provided that this 
//	copyright statement is not removed from the file and that any derivative work 
//	contains the original copyright notice and the associated disclaimer.
//
//	THIS SOURCE FILE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, 
//	INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND 
//	FITNESS FOR A PARTICULAR PURPOSE. 
// 
//---------------------------------------------------------------------------------------

`timescale 1ns / 1ns

module test;
//---------------------------------------------------------------------------------------
// internal signal  
reg clock;				// global clock 
reg reset;				// global reset 
reg [15:0] inSamp;		// encoder input sample 
reg inValid;			// encoder input valid flag 
wire inReady;			// encoder input ready indication  
wire [3:0] encPcm;		// encoder encoded output value 
wire encValid;			// encoder output valid flag 
wire [15:0] decSamp;	// decoder output sample value 
wire decValid;			// decoder output valid flag 
integer sampCount, encCount, decCount;
integer infid, encfid, decfid;
integer intmp, enctmp, dectmp;
reg [3:0] encExpVal;
reg [15:0] decExpVal;
reg [31:0] dispCount;

// global definitions 
`define EOF				-1

// file names 
`define IN_FILE		"../../../scilab/test_in.bin"
`define ENC_FILE	"../../../scilab/test_enc.bin"
`define DEC_FILE	"../../../scilab/test_dec.bin"

//---------------------------------------------------------------------------------------
// test bench implementation 
// global signals generation  
initial
begin
	clock = 0;
	reset = 1;
	#40 reset = 0;
end 

// clock generator - 50MHz clock 
always 
begin 
	#10 clock = 0;
	#10 clock = 1;
end 

// test bench dump variables 
initial 
begin 
	$display("");
	$display("IMA ADPCM encoder & decoder simulation");
	$display("--------------------------------------");
	$dumpfile("test.vcd");
	$dumpvars(0, test);
end 

//------------------------------------------------------------------
// encoder input samples read process 
initial 
begin 
	// clear encoder input signal 
	inSamp = 16'b0;
	inValid = 1'b0;
	// clear samples counter 
	sampCount = 0;
	
	// binary input file 
	infid = $fopen(`IN_FILE, "rb");
	
	// wait for reset release
	while (reset) @(posedge clock);
	repeat (50) @(posedge clock);

	// read input samples file 
	intmp = $fgetc(infid);
	while (intmp != `EOF)
	begin 
		// read the next character to form the new input sample 
		// Note that first byte is used as the low byte of the sample 
		inSamp[7:0] <= intmp;
		inSamp[15:8] <= $fgetc(infid);
		// sign input sample is valid 
		inValid <= 1'b1;
		@(posedge clock);
		
		// update the sample counter 
		sampCount = sampCount + 1;
		
		// wait for encoder input ready assertion to confirm the new sample was read
		// by the encoder.
		while (!inReady)
			@(posedge clock);
		
		// read next character from the input file 
		intmp = $fgetc(infid);
	end 
	// sign input is not valid 
	inValid <= 1'b0;
	@(posedge clock);
	
	// close input file 
	$fclose(infid);
end 

// encoder output checker - the encoder output is compared to the value read from 
// the ADPCM coded samples file. 
initial 
begin 
	// clear encoded sample value 
	encCount = 0;
	// open input file 
	encfid = $fopen(`ENC_FILE, "rb");

	// wait for reset release
	while (reset) @(posedge clock);
		
	// encoder output compare loop 
	enctmp = $fgetc(encfid);
	while (enctmp != `EOF)
	begin 
		// assign the expected value to a register with the same width 
		encExpVal = enctmp;
		
		// wait for encoder output valid 
		while (!encValid)
			@(posedge clock);
		
		// compare the encoded value with the value read from the input file 
		if (encPcm != encExpVal)
		begin 
			// announce error detection and exit simulation 
			$display(" Error!");
			$display("Error found in encoder output index %0d.", encCount+1);
			$display("   (expected value 'h%x, got value 'h%x)", encExpVal, encPcm);
			// wait for a few clock cycles before ending simulation 
			repeat (20) @(posedge clock);
			$finish;
		end 
		
		// update the encoded sample counter 
		encCount = encCount + 1;
		// delay for a clock cycle after comparison 
		@(posedge clock);
		
		// read next char from input file 
		enctmp = $fgetc(encfid);
	end 
	
	// close input file 
	$fclose(encfid);
end 

// decoder output checker - the decoder output is compared to the value read from 
// the ADPCM decoded samples file. 
initial 
begin 
	// clear decoded sample value 
	decCount = 0;
	dispCount = 0;
	// open input file 
	decfid = $fopen(`DEC_FILE, "rb");

	// wait for reset release
	while (reset) @(posedge clock);

	// display simulation progress bar title 
	$write("Simulation progress: ");
		
	// decoder output compare loop 
	dectmp = $fgetc(decfid);
	while (dectmp != `EOF)
	begin 
		// read the next char to form the expected 16 bit sample value 
		decExpVal[7:0] = dectmp;
		decExpVal[15:8] = $fgetc(decfid);
		
		// wait for decoder output valid 
		while (!decValid)
			@(posedge clock);
		
		// compare the decoded value with the value read from the input file 
		if (decSamp != decExpVal)
		begin 
			// announce error detection and exit simulation 
			$display(" Error!");
			$display("Error found in decoder output index %0d.", decCount+1);
			$display("   (expected value 'h%x, got value 'h%x)", decExpVal, decSamp);
			// wait for a few clock cycles before ending simulation 
			repeat (20) @(posedge clock);
			$finish;
		end 
		// delay for a clock cycle after comparison 
		@(posedge clock);
		
		// update the decoded sample counter 
		decCount = decCount + 1;
		
		// check if simulation progress should be displayed
		if (dispCount[31:13] != (decCount >> 13))
			$write(".");
		// update the display counter 
		dispCount = decCount;
		
		// read next char from input file 
		dectmp = $fgetc(decfid);
	end 
	
	// close input file 
	$fclose(decfid);
	
	// when decoder output is done announce simulation was successful 
	$display(" Done");
	$display("Simulation ended successfully after %0d samples", decCount);
	$finish;
end 

//------------------------------------------------------------------
// device under test 
// Encoder instance 
ima_adpcm_enc enc
(
	.clock(clock), 
	.reset(reset), 
	.inSamp(inSamp), 
	.inValid(inValid),
	.inReady(inReady),
	.outPCM(encPcm), 
	.outValid(encValid), 
	.outPredictSamp(/* not used */), 
	.outStepIndex(/* not used */) 
);

// Decoder instance 
ima_adpcm_dec dec 
(
	.clock(clock), 
	.reset(reset), 
	.inPCM(encPcm), 
	.inValid(encValid),
	.inReady(decReady),
	.inPredictSamp(16'b0), 
	.inStepIndex(7'b0), 
	.inStateLoad(1'b0), 
	.outSamp(decSamp), 
	.outValid(decValid) 
);

endmodule
//---------------------------------------------------------------------------------------
//						Th.. Th.. Th.. Thats all folks !!!
//---------------------------------------------------------------------------------------
