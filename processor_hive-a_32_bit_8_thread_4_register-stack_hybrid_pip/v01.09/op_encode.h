`define ie		4'b0010
`define iez		4'b0011
`define il		4'b0100
`define ilz		4'b0101
`define ile		4'b0110
`define ilez	4'b0111
`define iug		4'b1000
`define igz		4'b1001
`define iuge	4'b1010
`define igez	4'b1011
`define igl		4'b1100
`define iglz	4'b1101
`define igle	3'b111
//
`define ez		3'b001
`define lz		3'b010
`define lez		3'b011
`define gz		3'b100
`define gez		3'b101
`define glz		3'b110
`define glez	3'b111
//
localparam	OP_W = 10;
//
// immediate read & write - 64 codes
localparam	[OP_W-1:0]	op_rd_i		= { 4'h0, 2'b00, 4'bxxxx };	// mem(B+I[3:0]) => A  read immediate w/ offset (signed)
localparam	[OP_W-1:0]	op_rd_ix		= { 4'h0, 2'b01, 4'bxxxx };	// {mem(B+I[3:0]), A[lo]} => A  read immediate extended w/ offset
localparam	[OP_W-1:0]	op_wr_i		= { 4'h0, 2'b10, 4'bxxxx };	// A[lo] => mem(B+I[3:0])  write immediate w/ offset
localparam	[OP_W-1:0]	op_wr_ix		= { 4'h0, 2'b11, 4'bxxxx };	// A[hi] => mem(B+I[3:0])  write immediate extended w/ offset
// immediate conditional jump - 384 codes
localparam	[OP_W-1:0]	op_jmp_ie	= { 1'b0, `ie,   5'bxxxxx };	// (A?B), (A?0) PC+I[4:0] => PC  jump relative immediate conditional
localparam	[OP_W-1:0]	op_jmp_iez	= { 1'b0, `iez,  5'bxxxxx };
localparam	[OP_W-1:0]	op_jmp_il	= { 1'b0, `il,   5'bxxxxx };
localparam	[OP_W-1:0]	op_jmp_ilz	= { 1'b0, `ilz,  5'bxxxxx };
localparam	[OP_W-1:0]	op_jmp_ile	= { 1'b0, `ile,  5'bxxxxx };
localparam	[OP_W-1:0]	op_jmp_ilez	= { 1'b0, `ilez, 5'bxxxxx };
localparam	[OP_W-1:0]	op_jmp_iug	= { 1'b0, `iug,  5'bxxxxx };
localparam	[OP_W-1:0]	op_jmp_igz	= { 1'b0, `igz,  5'bxxxxx };
localparam	[OP_W-1:0]	op_jmp_iuge	= { 1'b0, `iuge, 5'bxxxxx };
localparam	[OP_W-1:0]	op_jmp_igez	= { 1'b0, `igez, 5'bxxxxx };
localparam	[OP_W-1:0]	op_jmp_igl	= { 1'b0, `igl,  5'bxxxxx };
localparam	[OP_W-1:0]	op_jmp_iglz	= { 1'b0, `iglz, 5'bxxxxx };
// immediate unconditional jump - 64 codes
localparam	[OP_W-1:0]	op_jmp_i		= { 1'b0, `igle, 6'bxxxxxx };
// immediate byte - 256 codes
localparam	[OP_W-1:0]	op_byt_i		= { 2'b10, 8'bxxxxxxxx };	// I[7:0] => A  byte immediate (signed)
// immediate shift - 128 codes
localparam	[OP_W-1:0]	op_shl_i		= { 4'hc, 6'bxxxxxx };	// A<<I => A  shift left A (signed) immediate
localparam	[OP_W-1:0]	op_shl_iu	= { 4'hd, 6'bxxxxxx };	// 1<<I | A<<I => A  shift left immediate unsigned
// immediate add - 64 codes
localparam	[OP_W-1:0]	op_add_i		= { 4'he, 6'bxxxxxx };	// A+I[5:0] => A  add immediate (I signed)
// conditional jump - 7 of 8 codes
localparam	[OP_W-1:0]	op_jmp_ez	= { 4'hf, 3'b000, `ez   };	// (A?0) PC+B[lo] => PC  jump relative conditional
localparam	[OP_W-1:0]	op_jmp_lz	= { 4'hf, 3'b000, `lz   };
localparam	[OP_W-1:0]	op_jmp_lez	= { 4'hf, 3'b000, `lez  };
localparam	[OP_W-1:0]	op_jmp_gz	= { 4'hf, 3'b000, `gz   };
localparam	[OP_W-1:0]	op_jmp_gez	= { 4'hf, 3'b000, `gez  };
localparam	[OP_W-1:0]	op_jmp_glz	= { 4'hf, 3'b000, `glz  };
localparam	[OP_W-1:0]	op_jmp		= { 4'hf, 3'b000, `glez };
// conditional goto - 7 of 8 codes
localparam	[OP_W-1:0]	op_gto_ez	= { 4'hf, 3'b001, `ez   };	// (A?0) B[lo] => PC  jump absolute conditional
localparam	[OP_W-1:0]	op_gto_lz	= { 4'hf, 3'b001, `lz   };
localparam	[OP_W-1:0]	op_gto_lez	= { 4'hf, 3'b001, `lez  };
localparam	[OP_W-1:0]	op_gto_gz	= { 4'hf, 3'b001, `gz   };
localparam	[OP_W-1:0]	op_gto_gez	= { 4'hf, 3'b001, `gez  };
localparam	[OP_W-1:0]	op_gto_glz	= { 4'hf, 3'b001, `glz  };
localparam	[OP_W-1:0]	op_gto		= { 4'hf, 3'b001, `glez };
// singles - 48 codes
localparam	[OP_W-1:0]	op_add		= { 4'hf, 2'b01, 4'h0 };	// A+B => A  add
localparam	[OP_W-1:0]	op_add_x		= { 4'hf, 2'b01, 4'h2 };	// A+B => A  add extended (signed)
localparam	[OP_W-1:0]	op_add_ux	= { 4'hf, 2'b01, 4'h3 };	// A+B => A  add extended unsigned
localparam	[OP_W-1:0]	op_sub		= { 4'hf, 2'b01, 4'h4 };	// A-B => A  subtract
localparam	[OP_W-1:0]	op_sub_x		= { 4'hf, 2'b01, 4'h6 };	// A-B => A  subtract extended (signed)
localparam	[OP_W-1:0]	op_sub_ux	= { 4'hf, 2'b01, 4'h7 };	// A-B => A  subtract extended unsigned
localparam	[OP_W-1:0]	op_mul		= { 4'hf, 2'b01, 4'h8 };	// A*B => A  multiply
localparam	[OP_W-1:0]	op_mul_x		= { 4'hf, 2'b01, 4'ha };	// A*B => A  multiply extended (signed)
localparam	[OP_W-1:0]	op_mul_ux	= { 4'hf, 2'b01, 4'hb };	// A*B => A  multiply extended unsigned
localparam	[OP_W-1:0]	op_shl		= { 4'hf, 2'b01, 4'hc };	// A<<B => A  shift left A (signed)
localparam	[OP_W-1:0]	op_shl_u		= { 4'hf, 2'b01, 4'hd };	// 1<<B | A<<B => A  2^B | shift left A unsigned
//
localparam	[OP_W-1:0]	op_and		= { 4'hf, 2'b10, 4'h0 };	// A&B => A  logical AND
localparam	[OP_W-1:0]	op_or			= { 4'hf, 2'b10, 4'h1 };	// A|B => A  logical OR
localparam	[OP_W-1:0]	op_xor		= { 4'hf, 2'b10, 4'h2 };	// A^B => A  logical XOR
localparam	[OP_W-1:0]	op_not		= { 4'hf, 2'b10, 4'h3 };	// ~B => A  logical NOT
localparam	[OP_W-1:0]	op_and_b		= { 4'hf, 2'b10, 4'h4 };	// &B => A  logical AND bit reduction
localparam	[OP_W-1:0]	op_or_b		= { 4'hf, 2'b10, 4'h5 };	// |B => A  logical OR bit reduction
localparam	[OP_W-1:0]	op_xor_b		= { 4'hf, 2'b10, 4'h6 };	// ^B => A  logical XOR bit reduction
//
localparam	[OP_W-1:0]	op_lit		= { 4'hf, 2'b11, 4'h0 };	// mem(PC) => A  literal low (signed)
localparam	[OP_W-1:0]	op_lit_u		= { 4'hf, 2'b11, 4'h1 };	// mem(PC) => A  literal low unsigned
localparam	[OP_W-1:0]	op_lit_x		= { 4'hf, 2'b11, 4'h2 };	// {mem(PC),A[lo]} => A  literal extended
localparam	[OP_W-1:0]	op_cpy		= { 4'hf, 2'b11, 4'h4 };	// B => A  copy
localparam	[OP_W-1:0]	op_pc			= { 4'hf, 2'b11, 4'h8 };	// PC => A  read PC (unsigned)
localparam	[OP_W-1:0]	op_gsb		= { 4'hf, 2'b11, 4'h9 };	// B[lo] => PC, PC => A  subroutine call
localparam	[OP_W-1:0]	op_cls		= { 4'hf, 2'b11, 4'hc };	// clear stacks
localparam	[OP_W-1:0]	op_pop		= { 4'hf, 2'b11, 4'he };	// do nothing (but allow pops)
localparam	[OP_W-1:0]	op_nop		= { 4'hf, 2'b11, 4'hf };	// do nothing (no pops either)
