#objdump: -dr --stop-address=128
#name: Sample Program

.*: .*

Disassembly of section \.text:

0+ <init>:
[ 	]+[0-9a-f]+:[ 	]+28          	clr
[ 	]+[0-9a-f]+:[ 	]+71          	t0x	r1
[ 	]+[0-9a-f]+:[ 	]+72          	t0x	r2
[ 	]+[0-9a-f]+:[ 	]+73          	t0x	r3
[ 	]+[0-9a-f]+:[ 	]+74          	t0x	r4
[ 	]+[0-9a-f]+:[ 	]+75          	t0x	r5
[ 	]+[0-9a-f]+:[ 	]+42          	dec	r2

00000007 <sum>:
[ 	]+[0-9a-f]+:[ 	]+77          	t0x	r7
[ 	]+[0-9a-f]+:[ 	]+f5          	ldx	r4 \+\+
[ 	]+[0-9a-f]+:[ 	]+57          	add	r7
[ 	]+[0-9a-f]+:[ 	]+91 00       	brnc	0
[ 	]+[0-9a-f]+:[ 	]+R_OPEN8_PCREL	\.text\+0x[0-9a-f]+
[ 	]+[0-9a-f]+:[ 	]+01          	inc	r1

0000000d <no_carry>:
[ 	]+[0-9a-f]+:[ 	]+a2 00       	dbnz	r2, 0
[ 	]+[0-9a-f]+:[ 	]+R_OPEN8_PCREL	\.text\+0x[0-9a-f]+
[ 	]+[0-9a-f]+:[ 	]+bc 00 00    	jmp	0	; 0x0 <init>
[ 	]+[0-9a-f]+:[ 	]+R_OPEN8_CALL	\.text
[ 	]+[0-9a-f]+:[ 	]+10          	tx0	r0
[ 	]+[0-9a-f]+:[ 	]+11          	tx0	r1
[ 	]+[0-9a-f]+:[ 	]+12          	tx0	r2
[ 	]+[0-9a-f]+:[ 	]+13          	tx0	r3
[ 	]+[0-9a-f]+:[ 	]+14          	tx0	r4
[ 	]+[0-9a-f]+:[ 	]+15          	tx0	r5
[ 	]+[0-9a-f]+:[ 	]+16          	tx0	r6
[ 	]+[0-9a-f]+:[ 	]+17          	tx0	r7
[ 	]+[0-9a-f]+:[ 	]+18          	or	r0
[ 	]+[0-9a-f]+:[ 	]+19          	or	r1
[ 	]+[0-9a-f]+:[ 	]+1a          	or	r2
[ 	]+[0-9a-f]+:[ 	]+1b          	or	r3
[ 	]+[0-9a-f]+:[ 	]+1c          	or	r4
[ 	]+[0-9a-f]+:[ 	]+1d          	or	r5
[ 	]+[0-9a-f]+:[ 	]+1e          	or	r6
[ 	]+[0-9a-f]+:[ 	]+1f          	or	r7
[ 	]+[0-9a-f]+:[ 	]+20          	and	r0
[ 	]+[0-9a-f]+:[ 	]+21          	and	r1
[ 	]+[0-9a-f]+:[ 	]+22          	and	r2
[ 	]+[0-9a-f]+:[ 	]+23          	and	r3
[ 	]+[0-9a-f]+:[ 	]+24          	and	r4
[ 	]+[0-9a-f]+:[ 	]+25          	and	r5
[ 	]+[0-9a-f]+:[ 	]+26          	and	r6
[ 	]+[0-9a-f]+:[ 	]+27          	and	r7
[ 	]+[0-9a-f]+:[ 	]+28          	clr
[ 	]+[0-9a-f]+:[ 	]+29          	xor	r1
[ 	]+[0-9a-f]+:[ 	]+2a          	xor	r2
[ 	]+[0-9a-f]+:[ 	]+2b          	xor	r3
[ 	]+[0-9a-f]+:[ 	]+2c          	xor	r4
[ 	]+[0-9a-f]+:[ 	]+2d          	xor	r5
[ 	]+[0-9a-f]+:[ 	]+2e          	xor	r6
[ 	]+[0-9a-f]+:[ 	]+2f          	xor	r7
[ 	]+[0-9a-f]+:[ 	]+30          	rol	r0
[ 	]+[0-9a-f]+:[ 	]+31          	rol	r1
[ 	]+[0-9a-f]+:[ 	]+32          	rol	r2
[ 	]+[0-9a-f]+:[ 	]+33          	rol	r3
[ 	]+[0-9a-f]+:[ 	]+34          	rol	r4
[ 	]+[0-9a-f]+:[ 	]+35          	rol	r5
[ 	]+[0-9a-f]+:[ 	]+36          	rol	r6
[ 	]+[0-9a-f]+:[ 	]+37          	rol	r7
[ 	]+[0-9a-f]+:[ 	]+38          	ror	r0
[ 	]+[0-9a-f]+:[ 	]+39          	ror	r1
[ 	]+[0-9a-f]+:[ 	]+3a          	ror	r2
[ 	]+[0-9a-f]+:[ 	]+3b          	ror	r3
[ 	]+[0-9a-f]+:[ 	]+3c          	ror	r4
[ 	]+[0-9a-f]+:[ 	]+3d          	ror	r5
[ 	]+[0-9a-f]+:[ 	]+3e          	ror	r6
[ 	]+[0-9a-f]+:[ 	]+3f          	ror	r7
[ 	]+[0-9a-f]+:[ 	]+40          	dec	r0
[ 	]+[0-9a-f]+:[ 	]+41          	dec	r1
[ 	]+[0-9a-f]+:[ 	]+42          	dec	r2
[ 	]+[0-9a-f]+:[ 	]+43          	dec	r3
[ 	]+[0-9a-f]+:[ 	]+44          	dec	r4
[ 	]+[0-9a-f]+:[ 	]+45          	dec	r5
[ 	]+[0-9a-f]+:[ 	]+46          	dec	r6
[ 	]+[0-9a-f]+:[ 	]+47          	dec	r7
[ 	]+[0-9a-f]+:[ 	]+48          	sbc	r0
[ 	]+[0-9a-f]+:[ 	]+49          	sbc	r1
[ 	]+[0-9a-f]+:[ 	]+4a          	sbc	r2
[ 	]+[0-9a-f]+:[ 	]+4b          	sbc	r3
[ 	]+[0-9a-f]+:[ 	]+4c          	sbc	r4
[ 	]+[0-9a-f]+:[ 	]+4d          	sbc	r5
[ 	]+[0-9a-f]+:[ 	]+4e          	sbc	r6
[ 	]+[0-9a-f]+:[ 	]+4f          	sbc	r7
[ 	]+[0-9a-f]+:[ 	]+50          	add	r0
[ 	]+[0-9a-f]+:[ 	]+51          	add	r1
[ 	]+[0-9a-f]+:[ 	]+52          	add	r2
[ 	]+[0-9a-f]+:[ 	]+53          	add	r3
[ 	]+[0-9a-f]+:[ 	]+54          	add	r4
[ 	]+[0-9a-f]+:[ 	]+55          	add	r5
[ 	]+[0-9a-f]+:[ 	]+56          	add	r6
[ 	]+[0-9a-f]+:[ 	]+57          	add	r7
[ 	]+[0-9a-f]+:[ 	]+58          	stz
[ 	]+[0-9a-f]+:[ 	]+59          	stc
[ 	]+[0-9a-f]+:[ 	]+5a          	stn
[ 	]+[0-9a-f]+:[ 	]+5b          	sti
[ 	]+[0-9a-f]+:[ 	]+5c          	stp	4
[ 	]+[0-9a-f]+:[ 	]+5d          	stp	5
[ 	]+[0-9a-f]+:[ 	]+5e          	stp	6
[ 	]+[0-9a-f]+:[ 	]+5f          	stp	7
[ 	]+[0-9a-f]+:[ 	]+60          	btt	0
[ 	]+[0-9a-f]+:[ 	]+61          	btt	1
[ 	]+[0-9a-f]+:[ 	]+62          	btt	2
[ 	]+[0-9a-f]+:[ 	]+63          	btt	3
[ 	]+[0-9a-f]+:[ 	]+64          	btt	4
[ 	]+[0-9a-f]+:[ 	]+65          	btt	5
[ 	]+[0-9a-f]+:[ 	]+66          	btt	6
[ 	]+[0-9a-f]+:[ 	]+67          	btt	7
[ 	]+[0-9a-f]+:[ 	]+68          	clz
[ 	]+[0-9a-f]+:[ 	]+69          	clc
[ 	]+[0-9a-f]+:[ 	]+6a          	cln
[ 	]+[0-9a-f]+:[ 	]+6b          	cli
[ 	]+[0-9a-f]+:[ 	]+6c          	clp	4
[ 	]+[0-9a-f]+:[ 	]+6d          	clp	5
[ 	]+[0-9a-f]+:[ 	]+6e          	clp	6
[ 	]+[0-9a-f]+:[ 	]+6f          	clp	7
[ 	]+[0-9a-f]+:[ 	]+70          	t0x	r0
[ 	]+[0-9a-f]+:[ 	]+71          	t0x	r1
[ 	]+[0-9a-f]+:[ 	]+72          	t0x	r2
[ 	]+[0-9a-f]+:[ 	]+73          	t0x	r3
[ 	]+[0-9a-f]+:[ 	]+74          	t0x	r4
[ 	]+[0-9a-f]+:[ 	]+75          	t0x	r5
[ 	]+[0-9a-f]+:[ 	]+76          	t0x	r6
[ 	]+[0-9a-f]+:[ 	]+77          	t0x	r7
[ 	]+[0-9a-f]+:[ 	]+78          	cmp	r0
[ 	]+[0-9a-f]+:[ 	]+79          	cmp	r1
[ 	]+[0-9a-f]+:[ 	]+7a          	cmp	r2
[ 	]+[0-9a-f]+:[ 	]+7b          	cmp	r3
[ 	]+[0-9a-f]+:[ 	]+7c          	cmp	r4
[ 	]+[0-9a-f]+:[ 	]+7d          	cmp	r5
