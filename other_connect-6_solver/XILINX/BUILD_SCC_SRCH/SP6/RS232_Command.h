//////////////////	Command Action	/////////////////////
parameter	SETUP	=	8'h61;
parameter	ERASE	=	8'h72;
parameter	WRITE	=	8'h83;
parameter	READ	=	8'h94;
parameter	LCD_DAT	=	8'h83;
parameter	LCD_CMD	=	8'h94;
//////////////////	Command Target	/////////////////////
parameter	LED		=	8'hF0;
parameter	SEG7	=	8'hE1;
parameter	PS2		=	8'hD2;
parameter	FLASH	=	8'hC3;
parameter	SDRAM	=	8'hB4;
parameter	SRAM	=	8'hA5;
parameter	LCD		=	8'h96;
parameter	VGA		=	8'h87;
parameter	SDRSEL	=	8'h1F;
parameter	FLSEL	=	8'h2E;
parameter	EXTIO	=	8'h3D;
parameter	SET_REG	=	8'h4C;
parameter	SRSEL	=	8'h5B;
parameter   SAFE 	=   8'h6A;
//////////////////	Command Mode	/////////////////////
parameter	OUTSEL	=	8'h33;
parameter	NORMAL	= 	8'hAA;
parameter	DISPLAY	=	8'hCC;
parameter	BURST	= 	8'hFF;
