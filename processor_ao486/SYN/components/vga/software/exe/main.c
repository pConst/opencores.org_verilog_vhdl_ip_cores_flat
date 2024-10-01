#include <stdio.h>
#include <unistd.h>

#include "system.h"
#include "io.h"

static unsigned char palette3[256][3]=
{
  0x00,0x00,0x00, 0x00,0x00,0x2a, 0x00,0x2a,0x00, 0x00,0x2a,0x2a, 0x2a,0x00,0x00, 0x2a,0x00,0x2a, 0x2a,0x15,0x00, 0x2a,0x2a,0x2a,
  0x15,0x15,0x15, 0x15,0x15,0x3f, 0x15,0x3f,0x15, 0x15,0x3f,0x3f, 0x3f,0x15,0x15, 0x3f,0x15,0x3f, 0x3f,0x3f,0x15, 0x3f,0x3f,0x3f,
  0x00,0x00,0x00, 0x05,0x05,0x05, 0x08,0x08,0x08, 0x0b,0x0b,0x0b, 0x0e,0x0e,0x0e, 0x11,0x11,0x11, 0x14,0x14,0x14, 0x18,0x18,0x18,
  0x1c,0x1c,0x1c, 0x20,0x20,0x20, 0x24,0x24,0x24, 0x28,0x28,0x28, 0x2d,0x2d,0x2d, 0x32,0x32,0x32, 0x38,0x38,0x38, 0x3f,0x3f,0x3f,
  0x00,0x00,0x3f, 0x10,0x00,0x3f, 0x1f,0x00,0x3f, 0x2f,0x00,0x3f, 0x3f,0x00,0x3f, 0x3f,0x00,0x2f, 0x3f,0x00,0x1f, 0x3f,0x00,0x10,
  0x3f,0x00,0x00, 0x3f,0x10,0x00, 0x3f,0x1f,0x00, 0x3f,0x2f,0x00, 0x3f,0x3f,0x00, 0x2f,0x3f,0x00, 0x1f,0x3f,0x00, 0x10,0x3f,0x00,
  0x00,0x3f,0x00, 0x00,0x3f,0x10, 0x00,0x3f,0x1f, 0x00,0x3f,0x2f, 0x00,0x3f,0x3f, 0x00,0x2f,0x3f, 0x00,0x1f,0x3f, 0x00,0x10,0x3f,
  0x1f,0x1f,0x3f, 0x27,0x1f,0x3f, 0x2f,0x1f,0x3f, 0x37,0x1f,0x3f, 0x3f,0x1f,0x3f, 0x3f,0x1f,0x37, 0x3f,0x1f,0x2f, 0x3f,0x1f,0x27,

  0x3f,0x1f,0x1f, 0x3f,0x27,0x1f, 0x3f,0x2f,0x1f, 0x3f,0x37,0x1f, 0x3f,0x3f,0x1f, 0x37,0x3f,0x1f, 0x2f,0x3f,0x1f, 0x27,0x3f,0x1f,
  0x1f,0x3f,0x1f, 0x1f,0x3f,0x27, 0x1f,0x3f,0x2f, 0x1f,0x3f,0x37, 0x1f,0x3f,0x3f, 0x1f,0x37,0x3f, 0x1f,0x2f,0x3f, 0x1f,0x27,0x3f,
  0x2d,0x2d,0x3f, 0x31,0x2d,0x3f, 0x36,0x2d,0x3f, 0x3a,0x2d,0x3f, 0x3f,0x2d,0x3f, 0x3f,0x2d,0x3a, 0x3f,0x2d,0x36, 0x3f,0x2d,0x31,
  0x3f,0x2d,0x2d, 0x3f,0x31,0x2d, 0x3f,0x36,0x2d, 0x3f,0x3a,0x2d, 0x3f,0x3f,0x2d, 0x3a,0x3f,0x2d, 0x36,0x3f,0x2d, 0x31,0x3f,0x2d,
  0x2d,0x3f,0x2d, 0x2d,0x3f,0x31, 0x2d,0x3f,0x36, 0x2d,0x3f,0x3a, 0x2d,0x3f,0x3f, 0x2d,0x3a,0x3f, 0x2d,0x36,0x3f, 0x2d,0x31,0x3f,
  0x00,0x00,0x1c, 0x07,0x00,0x1c, 0x0e,0x00,0x1c, 0x15,0x00,0x1c, 0x1c,0x00,0x1c, 0x1c,0x00,0x15, 0x1c,0x00,0x0e, 0x1c,0x00,0x07,
  0x1c,0x00,0x00, 0x1c,0x07,0x00, 0x1c,0x0e,0x00, 0x1c,0x15,0x00, 0x1c,0x1c,0x00, 0x15,0x1c,0x00, 0x0e,0x1c,0x00, 0x07,0x1c,0x00,
  0x00,0x1c,0x00, 0x00,0x1c,0x07, 0x00,0x1c,0x0e, 0x00,0x1c,0x15, 0x00,0x1c,0x1c, 0x00,0x15,0x1c, 0x00,0x0e,0x1c, 0x00,0x07,0x1c,

  0x0e,0x0e,0x1c, 0x11,0x0e,0x1c, 0x15,0x0e,0x1c, 0x18,0x0e,0x1c, 0x1c,0x0e,0x1c, 0x1c,0x0e,0x18, 0x1c,0x0e,0x15, 0x1c,0x0e,0x11,
  0x1c,0x0e,0x0e, 0x1c,0x11,0x0e, 0x1c,0x15,0x0e, 0x1c,0x18,0x0e, 0x1c,0x1c,0x0e, 0x18,0x1c,0x0e, 0x15,0x1c,0x0e, 0x11,0x1c,0x0e,
  0x0e,0x1c,0x0e, 0x0e,0x1c,0x11, 0x0e,0x1c,0x15, 0x0e,0x1c,0x18, 0x0e,0x1c,0x1c, 0x0e,0x18,0x1c, 0x0e,0x15,0x1c, 0x0e,0x11,0x1c,
  0x14,0x14,0x1c, 0x16,0x14,0x1c, 0x18,0x14,0x1c, 0x1a,0x14,0x1c, 0x1c,0x14,0x1c, 0x1c,0x14,0x1a, 0x1c,0x14,0x18, 0x1c,0x14,0x16,
  0x1c,0x14,0x14, 0x1c,0x16,0x14, 0x1c,0x18,0x14, 0x1c,0x1a,0x14, 0x1c,0x1c,0x14, 0x1a,0x1c,0x14, 0x18,0x1c,0x14, 0x16,0x1c,0x14,
  0x14,0x1c,0x14, 0x14,0x1c,0x16, 0x14,0x1c,0x18, 0x14,0x1c,0x1a, 0x14,0x1c,0x1c, 0x14,0x1a,0x1c, 0x14,0x18,0x1c, 0x14,0x16,0x1c,
  0x00,0x00,0x10, 0x04,0x00,0x10, 0x08,0x00,0x10, 0x0c,0x00,0x10, 0x10,0x00,0x10, 0x10,0x00,0x0c, 0x10,0x00,0x08, 0x10,0x00,0x04,
  0x10,0x00,0x00, 0x10,0x04,0x00, 0x10,0x08,0x00, 0x10,0x0c,0x00, 0x10,0x10,0x00, 0x0c,0x10,0x00, 0x08,0x10,0x00, 0x04,0x10,0x00,

  0x00,0x10,0x00, 0x00,0x10,0x04, 0x00,0x10,0x08, 0x00,0x10,0x0c, 0x00,0x10,0x10, 0x00,0x0c,0x10, 0x00,0x08,0x10, 0x00,0x04,0x10,
  0x08,0x08,0x10, 0x0a,0x08,0x10, 0x0c,0x08,0x10, 0x0e,0x08,0x10, 0x10,0x08,0x10, 0x10,0x08,0x0e, 0x10,0x08,0x0c, 0x10,0x08,0x0a,
  0x10,0x08,0x08, 0x10,0x0a,0x08, 0x10,0x0c,0x08, 0x10,0x0e,0x08, 0x10,0x10,0x08, 0x0e,0x10,0x08, 0x0c,0x10,0x08, 0x0a,0x10,0x08,
  0x08,0x10,0x08, 0x08,0x10,0x0a, 0x08,0x10,0x0c, 0x08,0x10,0x0e, 0x08,0x10,0x10, 0x08,0x0e,0x10, 0x08,0x0c,0x10, 0x08,0x0a,0x10,
  0x0b,0x0b,0x10, 0x0c,0x0b,0x10, 0x0d,0x0b,0x10, 0x0f,0x0b,0x10, 0x10,0x0b,0x10, 0x10,0x0b,0x0f, 0x10,0x0b,0x0d, 0x10,0x0b,0x0c,
  0x10,0x0b,0x0b, 0x10,0x0c,0x0b, 0x10,0x0d,0x0b, 0x10,0x0f,0x0b, 0x10,0x10,0x0b, 0x0f,0x10,0x0b, 0x0d,0x10,0x0b, 0x0c,0x10,0x0b,
  0x0b,0x10,0x0b, 0x0b,0x10,0x0c, 0x0b,0x10,0x0d, 0x0b,0x10,0x0f, 0x0b,0x10,0x10, 0x0b,0x0f,0x10, 0x0b,0x0d,0x10, 0x0b,0x0c,0x10,
  0x00,0x00,0x00, 0x00,0x00,0x00, 0x00,0x00,0x00, 0x00,0x00,0x00, 0x00,0x00,0x00, 0x00,0x00,0x00, 0x00,0x00,0x00, 0x00,0x00,0x00
};

static unsigned char palette0[63+1][3]=
{
  0x00,0x00,0x00, 0x00,0x00,0x00, 0x00,0x00,0x00, 0x00,0x00,0x00, 0x00,0x00,0x00, 0x00,0x00,0x00, 0x00,0x00,0x00, 0x00,0x00,0x00,
  0x2a,0x2a,0x2a, 0x2a,0x2a,0x2a, 0x2a,0x2a,0x2a, 0x2a,0x2a,0x2a, 0x2a,0x2a,0x2a, 0x2a,0x2a,0x2a, 0x2a,0x2a,0x2a, 0x2a,0x2a,0x2a,
  0x2a,0x2a,0x2a, 0x2a,0x2a,0x2a, 0x2a,0x2a,0x2a, 0x2a,0x2a,0x2a, 0x2a,0x2a,0x2a, 0x2a,0x2a,0x2a, 0x2a,0x2a,0x2a, 0x2a,0x2a,0x2a,
  0x3f,0x3f,0x3f, 0x3f,0x3f,0x3f, 0x3f,0x3f,0x3f, 0x3f,0x3f,0x3f, 0x3f,0x3f,0x3f, 0x3f,0x3f,0x3f, 0x3f,0x3f,0x3f, 0x3f,0x3f,0x3f,
  0x00,0x00,0x00, 0x00,0x00,0x00, 0x00,0x00,0x00, 0x00,0x00,0x00, 0x00,0x00,0x00, 0x00,0x00,0x00, 0x00,0x00,0x00, 0x00,0x00,0x00,
  0x2a,0x2a,0x2a, 0x2a,0x2a,0x2a, 0x2a,0x2a,0x2a, 0x2a,0x2a,0x2a, 0x2a,0x2a,0x2a, 0x2a,0x2a,0x2a, 0x2a,0x2a,0x2a, 0x2a,0x2a,0x2a,
  0x2a,0x2a,0x2a, 0x2a,0x2a,0x2a, 0x2a,0x2a,0x2a, 0x2a,0x2a,0x2a, 0x2a,0x2a,0x2a, 0x2a,0x2a,0x2a, 0x2a,0x2a,0x2a, 0x2a,0x2a,0x2a,
  0x3f,0x3f,0x3f, 0x3f,0x3f,0x3f, 0x3f,0x3f,0x3f, 0x3f,0x3f,0x3f, 0x3f,0x3f,0x3f, 0x3f,0x3f,0x3f, 0x3f,0x3f,0x3f, 0x3f,0x3f,0x3f
};

static unsigned char palette1[63+1][3]=
{
  0x00,0x00,0x00, 0x00,0x00,0x2a, 0x00,0x2a,0x00, 0x00,0x2a,0x2a, 0x2a,0x00,0x00, 0x2a,0x00,0x2a, 0x2a,0x15,0x00, 0x2a,0x2a,0x2a,
  0x00,0x00,0x00, 0x00,0x00,0x2a, 0x00,0x2a,0x00, 0x00,0x2a,0x2a, 0x2a,0x00,0x00, 0x2a,0x00,0x2a, 0x2a,0x15,0x00, 0x2a,0x2a,0x2a,
  0x15,0x15,0x15, 0x15,0x15,0x3f, 0x15,0x3f,0x15, 0x15,0x3f,0x3f, 0x3f,0x15,0x15, 0x3f,0x15,0x3f, 0x3f,0x3f,0x15, 0x3f,0x3f,0x3f,
  0x15,0x15,0x15, 0x15,0x15,0x3f, 0x15,0x3f,0x15, 0x15,0x3f,0x3f, 0x3f,0x15,0x15, 0x3f,0x15,0x3f, 0x3f,0x3f,0x15, 0x3f,0x3f,0x3f,
  0x00,0x00,0x00, 0x00,0x00,0x2a, 0x00,0x2a,0x00, 0x00,0x2a,0x2a, 0x2a,0x00,0x00, 0x2a,0x00,0x2a, 0x2a,0x15,0x00, 0x2a,0x2a,0x2a,
  0x00,0x00,0x00, 0x00,0x00,0x2a, 0x00,0x2a,0x00, 0x00,0x2a,0x2a, 0x2a,0x00,0x00, 0x2a,0x00,0x2a, 0x2a,0x15,0x00, 0x2a,0x2a,0x2a,
  0x15,0x15,0x15, 0x15,0x15,0x3f, 0x15,0x3f,0x15, 0x15,0x3f,0x3f, 0x3f,0x15,0x15, 0x3f,0x15,0x3f, 0x3f,0x3f,0x15, 0x3f,0x3f,0x3f,
  0x15,0x15,0x15, 0x15,0x15,0x3f, 0x15,0x3f,0x15, 0x15,0x3f,0x3f, 0x3f,0x15,0x15, 0x3f,0x15,0x3f, 0x3f,0x3f,0x15, 0x3f,0x3f,0x3f
};
static unsigned char palette2[63+1][3]=
{
  0x00,0x00,0x00, 0x00,0x00,0x2a, 0x00,0x2a,0x00, 0x00,0x2a,0x2a, 0x2a,0x00,0x00, 0x2a,0x00,0x2a, 0x2a,0x2a,0x00, 0x2a,0x2a,0x2a,
  0x00,0x00,0x15, 0x00,0x00,0x3f, 0x00,0x2a,0x15, 0x00,0x2a,0x3f, 0x2a,0x00,0x15, 0x2a,0x00,0x3f, 0x2a,0x2a,0x15, 0x2a,0x2a,0x3f,
  0x00,0x15,0x00, 0x00,0x15,0x2a, 0x00,0x3f,0x00, 0x00,0x3f,0x2a, 0x2a,0x15,0x00, 0x2a,0x15,0x2a, 0x2a,0x3f,0x00, 0x2a,0x3f,0x2a,
  0x00,0x15,0x15, 0x00,0x15,0x3f, 0x00,0x3f,0x15, 0x00,0x3f,0x3f, 0x2a,0x15,0x15, 0x2a,0x15,0x3f, 0x2a,0x3f,0x15, 0x2a,0x3f,0x3f,
  0x15,0x00,0x00, 0x15,0x00,0x2a, 0x15,0x2a,0x00, 0x15,0x2a,0x2a, 0x3f,0x00,0x00, 0x3f,0x00,0x2a, 0x3f,0x2a,0x00, 0x3f,0x2a,0x2a,
  0x15,0x00,0x15, 0x15,0x00,0x3f, 0x15,0x2a,0x15, 0x15,0x2a,0x3f, 0x3f,0x00,0x15, 0x3f,0x00,0x3f, 0x3f,0x2a,0x15, 0x3f,0x2a,0x3f,
  0x15,0x15,0x00, 0x15,0x15,0x2a, 0x15,0x3f,0x00, 0x15,0x3f,0x2a, 0x3f,0x15,0x00, 0x3f,0x15,0x2a, 0x3f,0x3f,0x00, 0x3f,0x3f,0x2a,
  0x15,0x15,0x15, 0x15,0x15,0x3f, 0x15,0x3f,0x15, 0x15,0x3f,0x3f, 0x3f,0x15,0x15, 0x3f,0x15,0x3f, 0x3f,0x3f,0x15, 0x3f,0x3f,0x3f
};

void test_mode13() {
	int i;

	/*
	unsigned char *mem = (unsigned char *)VGA_0_MEM_BASE;

	mem[0] = 1;
	mem[1] = 2;
	mem[2] = 3;
	mem[3] = 4;
	*/

	for(i=0; i<320; i++) IOWR_8DIRECT(VGA_0_MEM_BASE, i, (i%2)? 2 : 1);

	for(i=0; i<320; i++) IOWR_8DIRECT(VGA_0_MEM_BASE, 63680+i, (i%2)? 2 : 1);

	for(i=0; i<200; i++) IOWR_8DIRECT(VGA_0_MEM_BASE, i*320, (i%2)? 2 : 1);

	for(i=0; i<200; i++) IOWR_8DIRECT(VGA_0_MEM_BASE, 319+i*320, (i%2)? 2 : 1);

	for(i=0; i<64000; i++) IOWR_8DIRECT(VGA_0_MEM_BASE, i, i);


	/*
	IOWR_8DIRECT(VGA_0_IO_C_BASE, 9, 0x00);
	IOWR_8DIRECT(VGA_0_IO_C_BASE, 9, 0x00);
	IOWR_8DIRECT(VGA_0_IO_C_BASE, 9, 0xFF);

	IOWR_8DIRECT(VGA_0_IO_C_BASE, 9, 0xFF);
	IOWR_8DIRECT(VGA_0_IO_C_BASE, 9, 0x00);
	IOWR_8DIRECT(VGA_0_IO_C_BASE, 9, 0x00);
	*/
}

void test_text_mode() {
	int i;

	//disable chained mode and odd/even mode
	IOWR_8DIRECT(VGA_0_IO_C_BASE, 4, 4);
	IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, 0x6);

	//enable page 2 write
	IOWR_8DIRECT(VGA_0_IO_C_BASE, 4, 2);
	IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, 0x4);

	//load font data
	IOWR_8DIRECT(VGA_0_MEM_BASE, 0, 0x81);
	IOWR_8DIRECT(VGA_0_MEM_BASE, 1, 0x42);
	IOWR_8DIRECT(VGA_0_MEM_BASE, 2, 0x24);
	IOWR_8DIRECT(VGA_0_MEM_BASE, 3, 0x18);
	IOWR_8DIRECT(VGA_0_MEM_BASE, 4, 0x18);
	IOWR_8DIRECT(VGA_0_MEM_BASE, 5, 0x24);
	IOWR_8DIRECT(VGA_0_MEM_BASE, 6, 0x42);
	IOWR_8DIRECT(VGA_0_MEM_BASE, 7, 0x81);

	IOWR_8DIRECT(VGA_0_MEM_BASE, 8,  0x81);
	IOWR_8DIRECT(VGA_0_MEM_BASE, 9,  0x42);
	IOWR_8DIRECT(VGA_0_MEM_BASE, 10, 0x24);
	IOWR_8DIRECT(VGA_0_MEM_BASE, 11, 0x18);
	IOWR_8DIRECT(VGA_0_MEM_BASE, 12, 0x18);
	IOWR_8DIRECT(VGA_0_MEM_BASE, 13, 0x24);
	IOWR_8DIRECT(VGA_0_MEM_BASE, 14, 0x42);
	IOWR_8DIRECT(VGA_0_MEM_BASE, 15, 0x81);

	unsigned char mode_01[] =
	{
	 /* index=0x17 vga mode 0x01 */
	 40, 24, 16, 0x00, 0x08, /* tw, th-1, ch, slength */
	 0x08, 0x03, 0x00, 0x02, /* sequ_regs */
	 0x67, /* miscreg */
	 0x2d, 0x27, 0x28, 0x90, 0x2b, 0xa0, 0xbf, 0x1f,
	 0x00, 0x4f, 0x0d, 0x0e, 0x00, 0x00, 0x00, 0x00,
	 0x9c, 0x8e, 0x8f, 0x14, 0x1f, 0x96, 0xb9, 0xa3,
	 0xff, /* crtc_regs */
	 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x14, 0x07,
	 0x38, 0x39, 0x3a, 0x3b, 0x3c, 0x3d, 0x3e, 0x3f,
	 0x0c, 0x00, 0x0f, 0x08, /* actl_regs */
	 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x0e, 0x0f, 0xff, /* grdc_regs */
	};
	unsigned char mode_03[] =
	{
	 /* index=0x18 vga mode 0x03 */
	 80, 24, 16, 0x00, 0x10, /* tw, th-1, ch, slength */
	 0x00, 0x03, 0x00, 0x02, /* sequ_regs */
	 0x67, /* miscreg */
	 0x5f, 0x4f, 0x50, 0x82, 0x55, 0x81, 0xbf, 0x1f,
	 0x00, 0x4f, 0x0d, 0x0e, 0x00, 0x00, 0x00, 0x00,
	 0x9c, 0x8e, 0x8f, 0x28, 0x1f, 0x96, 0xb9, 0xa3,
	 0xff, /* crtc_regs */
	 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x14, 0x07,
	 0x38, 0x39, 0x3a, 0x3b, 0x3c, 0x3d, 0x3e, 0x3f,
	 0x0c, 0x00, 0x0f, 0x08, /* actl_regs */
	 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x0e, 0x0f, 0xff, /* grdc_regs */
	};

	unsigned char mode_07[] =
	{
	 /* index=0x19 vga mode 0x07 */
	 80, 24, 16, 0x00, 0x10, /* tw, th-1, ch, slength */
	 0x00, 0x03, 0x00, 0x02, /* sequ_regs */
	 0x66, /* miscreg */
	 0x5f, 0x4f, 0x50, 0x82, 0x55, 0x81, 0xbf, 0x1f,
	 0x00, 0x4f, 0x0d, 0x0e, 0x00, 0x00, 0x00, 0x00,
	 0x9c, 0x8e, 0x8f, 0x28, 0x0f, 0x96, 0xb9, 0xa3,
	 0xff, /* crtc_regs */
	 0x00, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08,
	 0x10, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18,
	 0x0e, 0x00, 0x0f, 0x08, /* actl_regs */
	 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x0a, 0x0f, 0xff, /* grdc_regs */
	};

	unsigned char *mode = mode_07;
	int mode_num = 0x07;

	//load sequencer
	for(i=0; i<4; i++) {
		IOWR_8DIRECT(VGA_0_IO_C_BASE, 4, i+1);
		IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, mode[5+i]);
	}

	//load misc
	IOWR_8DIRECT(VGA_0_IO_C_BASE, 2, mode[9]);

	//load crtc -- disable protect
	if(mode_num != 0x07) {
		IOWR_8DIRECT(VGA_0_IO_D_BASE, 4, 0x11);
		IOWR_8DIRECT(VGA_0_IO_D_BASE, 5, mode[27] & 0x7F);

		for(i=0; i<0x18; i++) {
			IOWR_8DIRECT(VGA_0_IO_D_BASE, 4, i);
			IOWR_8DIRECT(VGA_0_IO_D_BASE, 5, mode[10+i]);
		}
	}
	else {
		IOWR_8DIRECT(VGA_0_IO_B_BASE, 4, 0x11);
		IOWR_8DIRECT(VGA_0_IO_B_BASE, 5, mode[27] & 0x7F);

		for(i=0; i<0x18; i++) {
			IOWR_8DIRECT(VGA_0_IO_B_BASE, 4, i);
			IOWR_8DIRECT(VGA_0_IO_B_BASE, 5, mode[10+i]);
		}
	}
	//load attrib
	for(i=0; i<0x14; i++) {
		IOWR_8DIRECT(VGA_0_IO_C_BASE, 0, 0x20 | i);
		IOWR_8DIRECT(VGA_0_IO_C_BASE, 0, mode[35+i]);
	}

	//load graphic
	for(i=0; i<0x09; i++) {
		IOWR_8DIRECT(VGA_0_IO_C_BASE, 0xE, i);
		IOWR_8DIRECT(VGA_0_IO_C_BASE, 0xF, mode[55+i]);
	}

	//clear memory
	for(i=0; i<4000; i++) IOWR_8DIRECT(VGA_0_MEM_BASE, 0x18000 + i, 0x00);
	for(i=0; i<4000; i++) IOWR_8DIRECT(VGA_0_MEM_BASE, 0x10000 + i, 0x00);

	// for mode 0,3
	if(mode_num == 0x01 || mode_num == 0x03) {
		IOWR_8DIRECT(VGA_0_MEM_BASE, 0x18001, 0x04);
		IOWR_8DIRECT(VGA_0_MEM_BASE, 0x1804f, 0x04);

		IOWR_8DIRECT(VGA_0_MEM_BASE, 0x18000 + 1920 + 1, 0x04);
		IOWR_8DIRECT(VGA_0_MEM_BASE, 0x18000 + 1999, 0x04);

		IOWR_8DIRECT(VGA_0_MEM_BASE, 0x18000 + 160 - 1, 0x04);
		IOWR_8DIRECT(VGA_0_MEM_BASE, 0x18000 + 3840 + 1, 0x04);
		IOWR_8DIRECT(VGA_0_MEM_BASE, 0x18000 + 3999, 0x04);
	}

	//for mode 7
	if(mode_num == 0x07) {
		IOWR_8DIRECT(VGA_0_MEM_BASE, 0x10000 + 1, 0x04);
		IOWR_8DIRECT(VGA_0_MEM_BASE, 0x10000 + 160 -1, 0x04);

		IOWR_8DIRECT(VGA_0_MEM_BASE, 0x10000 + 3840 + 1, 0x04);
		IOWR_8DIRECT(VGA_0_MEM_BASE, 0x10000 + 4000 - 1, 0x04);
	}
}

int main() {

	IOWR(VGA_0_SYS_BASE, 0, 0xC000);

	int i;
	for(i=0; i<128; i++) {
		IOWR(VGA_0_SYS_BASE, i, ('0'+(i%10)));
	}

	usleep(1000000);

	IOWR(VGA_0_SYS_BASE, 0, 0x8000);

	//--------------------

	//load dac
	IOWR_8DIRECT(VGA_0_IO_C_BASE, 8, 0);

	/*
	for(i=0; i<256; i++) {
		IOWR_8DIRECT(VGA_0_IO_C_BASE, 9, palette3[i][0]);
		IOWR_8DIRECT(VGA_0_IO_C_BASE, 9, palette3[i][1]);
		IOWR_8DIRECT(VGA_0_IO_C_BASE, 9, palette3[i][2]);
	}
	*/

	for(i=0; i<64; i++) {
		IOWR_8DIRECT(VGA_0_IO_C_BASE, 9, palette2[i][0]);
		IOWR_8DIRECT(VGA_0_IO_C_BASE, 9, palette2[i][1]);
		IOWR_8DIRECT(VGA_0_IO_C_BASE, 9, palette2[i][2]);
	}


	//test_mode13();
	//return 0;

	//test_text_mode();
	//return 0;

	unsigned char mode_04[] =
	{
	 /* index=0x04 vga mode 0x04 */
	 40, 24, 8, 0x00, 0x08, /* tw, th-1, ch, slength */
	 0x09, 0x03, 0x00, 0x02, /* sequ_regs */
	 0x63, /* miscreg */
	 0x2d, 0x27, 0x28, 0x90, 0x2b, 0x80, 0xbf, 0x1f,
	 0x00, 0xc1, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	 0x9c, 0x8e, 0x8f, 0x14, 0x00, 0x96, 0xb9, 0xa2,
	 0xff, /* crtc_regs */
	 0x00, 0x13, 0x15, 0x17, 0x02, 0x04, 0x06, 0x07,
	 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
	 0x01, 0x00, 0x03, 0x00, /* actl_regs */
	 0x00, 0x00, 0x00, 0x00, 0x00, 0x30, 0x0f, 0x0f, 0xff, /* grdc_regs */
	};

	unsigned char mode_05[] =
	{
	 /* index=0x05 vga mode 0x05 */
	 40, 24, 8, 0x00, 0x08, /* tw, th-1, ch, slength */
	 0x09, 0x03, 0x00, 0x02, /* sequ_regs */
	 0x63, /* miscreg */
	 0x2d, 0x27, 0x28, 0x90, 0x2b, 0x80, 0xbf, 0x1f,
	 0x00, 0xc1, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	 0x9c, 0x8e, 0x8f, 0x14, 0x00, 0x96, 0xb9, 0xa2,
	 0xff, /* crtc_regs */
	 0x00, 0x13, 0x15, 0x17, 0x02, 0x04, 0x06, 0x07,
	 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
	 0x01, 0x00, 0x03, 0x00, /* actl_regs */
	 0x00, 0x00, 0x00, 0x00, 0x00, 0x30, 0x0f, 0x0f, 0xff, /* grdc_regs */
	};
	unsigned char mode_06[] =
	{
	 /* index=0x06 vga mode 0x06 */
	 80, 24, 8, 0x00, 0x10, /* tw, th-1, ch, slength */
	 0x01, 0x01, 0x00, 0x06, /* sequ_regs */
	 0x63, /* miscreg */
	 0x5f, 0x4f, 0x50, 0x82, 0x54, 0x80, 0xbf, 0x1f,
	 0x00, 0xc1, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	 0x9c, 0x8e, 0x8f, 0x28, 0x00, 0x96, 0xb9, 0xc2,
	 0xff, /* crtc_regs */
	 0x00, 0x17, 0x17, 0x17, 0x17, 0x17, 0x17, 0x17,
	 0x17, 0x17, 0x17, 0x17, 0x17, 0x17, 0x17, 0x17,
	 0x01, 0x00, 0x01, 0x00, /* actl_regs */
	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0d, 0x0f, 0xff, /* grdc_regs */
	};
	unsigned char mode_0d[] =
	{
	 /* index=0x0d vga mode 0x0d */
	 40, 24, 8, 0x00, 0x20, /* tw, th-1, ch, slength */
	 0x09, 0x0f, 0x00, 0x06, /* sequ_regs */
	 0x63, /* miscreg */
	 0x2d, 0x27, 0x28, 0x90, 0x2b, 0x80, 0xbf, 0x1f,
	 0x00, 0xc0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	 0x9c, 0x8e, 0x8f, 0x14, 0x00, 0x96, 0xb9, 0xe3,
	 0xff, /* crtc_regs */
	 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
	 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
	 0x01, 0x00, 0x0f, 0x00, /* actl_regs */
	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x05, 0x0f, 0xff, /* grdc_regs */
	};
	unsigned char mode_0e[] =
	{
	 /* index=0x0e vga mode 0x0e */
	 80, 24, 8, 0x00, 0x40, /* tw, th-1, ch, slength */
	 0x01, 0x0f, 0x00, 0x06, /* sequ_regs */
	 0x63, /* miscreg */
	 0x5f, 0x4f, 0x50, 0x82, 0x54, 0x80, 0xbf, 0x1f,
	 0x00, 0xc0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	 0x9c, 0x8e, 0x8f, 0x28, 0x00, 0x96, 0xb9, 0xe3,
	 0xff, /* crtc_regs */
	 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
	 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
	 0x01, 0x00, 0x0f, 0x00, /* actl_regs */
	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x05, 0x0f, 0xff, /* grdc_regs */
	};
	unsigned char mode_0f[] =
	{
	 /* index=0x11 vga mode 0x0f */
	 80, 24, 14, 0x00, 0x80, /* tw, th-1, ch, slength */
	 0x01, 0x0f, 0x00, 0x06, /* sequ_regs */
	 0xa3, /* miscreg */
	 0x5f, 0x4f, 0x50, 0x82, 0x54, 0x80, 0xbf, 0x1f,
	 0x00, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	 0x83, 0x85, 0x5d, 0x28, 0x0f, 0x63, 0xba, 0xe3,
	 0xff, /* crtc_regs */
	 0x00, 0x08, 0x00, 0x00, 0x18, 0x18, 0x00, 0x00,
	 0x00, 0x08, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00,
	 0x01, 0x00, 0x01, 0x00, /* actl_regs */
	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x05, 0x0f, 0xff, /* grdc_regs */
	};
	unsigned char mode_10[] =
	{
	 /* index=0x12 vga mode 0x10 */
	 80, 24, 14, 0x00, 0x80, /* tw, th-1, ch, slength */
	 0x01, 0x0f, 0x00, 0x06, /* sequ_regs */
	 0xa3, /* miscreg */
	 0x5f, 0x4f, 0x50, 0x82, 0x54, 0x80, 0xbf, 0x1f,
	 0x00, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	 0x83, 0x85, 0x5d, 0x28, 0x0f, 0x63, 0xba, 0xe3,
	 0xff, /* crtc_regs */
	 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x14, 0x07,
	 0x38, 0x39, 0x3a, 0x3b, 0x3c, 0x3d, 0x3e, 0x3f,
	 0x01, 0x00, 0x0f, 0x00, /* actl_regs */
	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x05, 0x0f, 0xff, /* grdc_regs */
	};
	unsigned char mode_11[] =
	{
	 /* index=0x1a vga mode 0x11 */
	 80, 29, 16, 0x00, 0x00, /* tw, th-1, ch, slength */
	 0x01, 0x0f, 0x00, 0x06, /* sequ_regs */
	 0xe3, /* miscreg */
	 0x5f, 0x4f, 0x50, 0x82, 0x54, 0x80, 0x0b, 0x3e,
	 0x00, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	 0xea, 0x8c, 0xdf, 0x28, 0x00, 0xe7, 0x04, 0xe3,
	 0xff, /* crtc_regs */
	 0x00, 0x3f, 0x00, 0x3f, 0x00, 0x3f, 0x00, 0x3f,
	 0x00, 0x3f, 0x00, 0x3f, 0x00, 0x3f, 0x00, 0x3f,
	 0x01, 0x00, 0x0f, 0x00, /* actl_regs */
	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x05, 0x0f, 0xff, /* grdc_regs */
	};
	unsigned char mode_12[] =
	{
	 /* index=0x1b vga mode 0x12 */
	 80, 29, 16, 0x00, 0x00, /* tw, th-1, ch, slength */
	 0x01, 0x0f, 0x00, 0x06, /* sequ_regs */
	 0xe3, /* miscreg */
	 0x5f, 0x4f, 0x50, 0x82, 0x54, 0x80, 0x0b, 0x3e,
	 0x00, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	 0xea, 0x8c, 0xdf, 0x28, 0x00, 0xe7, 0x04, 0xe3,
	 0xff, /* crtc_regs */
	 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x14, 0x07,
	 0x38, 0x39, 0x3a, 0x3b, 0x3c, 0x3d, 0x3e, 0x3f,
	 0x01, 0x00, 0x0f, 0x00, /* actl_regs */
	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x05, 0x0f, 0xff, /* grdc_regs */
	};

	unsigned char *mode = mode_12;
	int mode_num = 0x12;

	//load sequencer
	for(i=0; i<4; i++) {
		IOWR_8DIRECT(VGA_0_IO_C_BASE, 4, i+1);
		IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, mode[5+i]);
	}

	//load misc
	IOWR_8DIRECT(VGA_0_IO_C_BASE, 2, mode[9]);

	//load crtc -- disable protect
	if(mode_num != 0x07) {
		IOWR_8DIRECT(VGA_0_IO_D_BASE, 4, 0x11);
		IOWR_8DIRECT(VGA_0_IO_D_BASE, 5, mode[27] & 0x7F);

		for(i=0; i<0x18; i++) {
			IOWR_8DIRECT(VGA_0_IO_D_BASE, 4, i);
			IOWR_8DIRECT(VGA_0_IO_D_BASE, 5, mode[10+i]);
		}
	}
	else {
		IOWR_8DIRECT(VGA_0_IO_B_BASE, 4, 0x11);
		IOWR_8DIRECT(VGA_0_IO_B_BASE, 5, mode[27] & 0x7F);

		for(i=0; i<0x18; i++) {
			IOWR_8DIRECT(VGA_0_IO_B_BASE, 4, i);
			IOWR_8DIRECT(VGA_0_IO_B_BASE, 5, mode[10+i]);
		}
	}
	//load attrib
	for(i=0; i<0x14; i++) {
		IOWR_8DIRECT(VGA_0_IO_C_BASE, 0, 0x20 | i);
		IOWR_8DIRECT(VGA_0_IO_C_BASE, 0, mode[35+i]);
	}

	//load graphic
	for(i=0; i<0x09; i++) {
		IOWR_8DIRECT(VGA_0_IO_C_BASE, 0xE, i);
		IOWR_8DIRECT(VGA_0_IO_C_BASE, 0xF, mode[55+i]);
	}

	//draw pixels
	if(mode_num == 0x04 || mode_num == 0x05) {
		IOWR_8DIRECT(VGA_0_MEM_BASE, 0x18000, (3 << 6) | (2 << 4) | (1 << 2) | (3 << 0));

		IOWR_8DIRECT(VGA_0_MEM_BASE, 0x18000 + 1, (2 << 6) | (2 << 4) | (2 << 2) | (3 << 0));

		IOWR_8DIRECT(VGA_0_MEM_BASE, 0x18000 + 79, (1 << 6) | (1 << 4) | (1 << 2) | (2 << 0));
		IOWR_8DIRECT(VGA_0_MEM_BASE, 0x18000 + 80, (3 << 6) | (3 << 4) | (3 << 2) | (1 << 0));

		IOWR_8DIRECT(VGA_0_MEM_BASE, 0x18000 + 80*99, (3 << 6) | (3 << 4) | (3 << 2) | (3 << 0));
		IOWR_8DIRECT(VGA_0_MEM_BASE, 0x1A000 + 80*99, (2 << 6) | (2 << 4) | (2 << 2) | (2 << 0));

		IOWR_8DIRECT(VGA_0_MEM_BASE, 0x1A000, (3 << 6) | (2 << 4) | (1 << 2) | (3 << 0));

		IOWR_8DIRECT(VGA_0_MEM_BASE, 0x18000 + 80*99 + 79, (1 << 6) | (1 << 4) | (1 << 2) | (1 << 0));
		IOWR_8DIRECT(VGA_0_MEM_BASE, 0x1A000 + 80*99 + 79, (3 << 6) | (2 << 4) | (3 << 2) | (2 << 0));
	}
	if(mode_num == 0x06) {
		IOWR_8DIRECT(VGA_0_MEM_BASE, 0x18000, 0x81);
		IOWR_8DIRECT(VGA_0_MEM_BASE, 0x18000 + 1, 0x81);

		IOWR_8DIRECT(VGA_0_MEM_BASE, 0x18000 + 79, 0x81);
		IOWR_8DIRECT(VGA_0_MEM_BASE, 0x18000 + 80, 0xFF);

		IOWR_8DIRECT(VGA_0_MEM_BASE, 0x1A000, 0x42);

		IOWR_8DIRECT(VGA_0_MEM_BASE, 0x18000 + 80*99, 0xd0);
		IOWR_8DIRECT(VGA_0_MEM_BASE, 0x1A000 + 80*99, 0xb0);

		IOWR_8DIRECT(VGA_0_MEM_BASE, 0x18000 + 80*99 + 79, 0xd0);
		IOWR_8DIRECT(VGA_0_MEM_BASE, 0x1A000 + 80*99 + 79, 0xb0);

		//for(i=0; i<100; i++) {
		//	IOWR_8DIRECT(VGA_0_MEM_BASE, 0x18000 + 80*i, 0x80);
		//	IOWR_8DIRECT(VGA_0_MEM_BASE, 0x1A000 + 80*i, 0x80);
		//}
	}


	if(mode_num == 0x0d) {
		IOWR_8DIRECT(VGA_0_IO_C_BASE, 4, 2);

		IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, 0x1);
		IOWR_8DIRECT(VGA_0_MEM_BASE, 0, 0x81);

		IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, 0x2);
		IOWR_8DIRECT(VGA_0_MEM_BASE,  39, 0x81);

		IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, 0x4);
		IOWR_8DIRECT(VGA_0_MEM_BASE,  40, 0x81);

		IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, 0x8);
		IOWR_8DIRECT(VGA_0_MEM_BASE,  199*40, 0x81);

		IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, 0xe);
		IOWR_8DIRECT(VGA_0_MEM_BASE,  199*40+39, 0x81);
	}
	if(mode_num == 0x0e) {
		IOWR_8DIRECT(VGA_0_IO_C_BASE, 4, 2);

		IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, 0x1);
		IOWR_8DIRECT(VGA_0_MEM_BASE, 0, 0x81);

		IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, 0x2);
		IOWR_8DIRECT(VGA_0_MEM_BASE,  79, 0x81);

		IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, 0x4);
		IOWR_8DIRECT(VGA_0_MEM_BASE,  80, 0x81);

		IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, 0x8);
		IOWR_8DIRECT(VGA_0_MEM_BASE,  199*80, 0x81);

		IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, 0xe);
		IOWR_8DIRECT(VGA_0_MEM_BASE,  199*80+79, 0x81);
	}
	if(mode_num == 0x0f) {
		IOWR_8DIRECT(VGA_0_IO_C_BASE, 4, 2);

		IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, 0x1);
		IOWR_8DIRECT(VGA_0_MEM_BASE,  0, 0x81);

		IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, 0x1);
		IOWR_8DIRECT(VGA_0_MEM_BASE,  79, 0x81);

		IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, 0x5);
		IOWR_8DIRECT(VGA_0_MEM_BASE,  80, 0x81);

		IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, 0x2);
		IOWR_8DIRECT(VGA_0_MEM_BASE,  81, 0x81);

		IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, 0x4);
		IOWR_8DIRECT(VGA_0_MEM_BASE,  82, 0x81);

		IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, 0x8);
		IOWR_8DIRECT(VGA_0_MEM_BASE,  83, 0x81);

		IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, 0xf);
		IOWR_8DIRECT(VGA_0_MEM_BASE,  84, 0x81);

		IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, 0xf);
		IOWR_8DIRECT(VGA_0_MEM_BASE,  349*80, 0x81);

		IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, 0xf);
		IOWR_8DIRECT(VGA_0_MEM_BASE,  349*80 + 79, 0xc1);
	}
	if(mode_num == 0x10) {
		IOWR_8DIRECT(VGA_0_IO_C_BASE, 4, 2);

		IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, 0x1);
		IOWR_8DIRECT(VGA_0_MEM_BASE, 0, 0x81);

		IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, 0x2);
		IOWR_8DIRECT(VGA_0_MEM_BASE,  79, 0x81);

		IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, 0x4);
		IOWR_8DIRECT(VGA_0_MEM_BASE,  80, 0x81);

		IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, 0x8);
		IOWR_8DIRECT(VGA_0_MEM_BASE,  349*80, 0x81);

		IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, 0xe);
		IOWR_8DIRECT(VGA_0_MEM_BASE,  349*80+79, 0x81);
	}
	if(mode_num == 0x11) {
		IOWR_8DIRECT(VGA_0_MEM_BASE, 0, 0x81);
		IOWR_8DIRECT(VGA_0_MEM_BASE, 79, 0x81);

		IOWR_8DIRECT(VGA_0_MEM_BASE, 80, 0x42);

		IOWR_8DIRECT(VGA_0_MEM_BASE, 479*80, 0x81);
		IOWR_8DIRECT(VGA_0_MEM_BASE, 479*80 + 79, 0x81);
	}
	if(mode_num == 0x12) {
		IOWR_8DIRECT(VGA_0_IO_C_BASE, 4, 2);

		IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, 0x1);
		IOWR_8DIRECT(VGA_0_MEM_BASE,  0, 0x81);

		IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, 0x1);
		IOWR_8DIRECT(VGA_0_MEM_BASE,  79, 0x81);

		IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, 0x5);
		IOWR_8DIRECT(VGA_0_MEM_BASE,  80, 0x81);

		IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, 0x2);
		IOWR_8DIRECT(VGA_0_MEM_BASE,  81, 0x81);

		IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, 0x4);
		IOWR_8DIRECT(VGA_0_MEM_BASE,  82, 0x81);

		IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, 0x8);
		IOWR_8DIRECT(VGA_0_MEM_BASE,  83, 0x81);

		IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, 0xf);
		IOWR_8DIRECT(VGA_0_MEM_BASE,  84, 0x81);

		IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, 0xf);
		IOWR_8DIRECT(VGA_0_MEM_BASE,  479*80, 0x81);

		IOWR_8DIRECT(VGA_0_IO_C_BASE, 5, 0xf);
		IOWR_8DIRECT(VGA_0_MEM_BASE,  479*80 + 79, 0xc1);
	}
	return 0;
}


