-----------------------------------------------------------------------------
-- LEON3 Demonstration design test bench configuration
-- Copyright (C) 2004 Jiri Gaisler, Gaisler Research
--
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
-- GNU General Public License for more details.
------------------------------------------------------------------------------


library techmap;
use techmap.gencomp.all;

package config is


-- Technology and synthesis options
  constant CFG_FABTECH : integer := axcel;
  constant CFG_MEMTECH : integer := axcel;
  constant CFG_PADTECH : integer := axcel;
  constant CFG_NOASYNC : integer := 0;

-- Clock generator
  constant CFG_CLKTECH : integer := axcel;
  constant CFG_CLKMUL : integer := 2;
  constant CFG_CLKDIV : integer := 2;
  constant CFG_PCIDLL : integer := 0;
  constant CFG_PCISYSCLK: integer := 0;
  constant CFG_CLK_NOFB : integer := 0;

-- LEON3 processor core
  constant CFG_LEON3 : integer := 1;
  constant CFG_NCPU : integer := (1);
  constant CFG_NWIN : integer := (8);
  constant CFG_V8 : integer := 0;
  constant CFG_MAC : integer := 0;
  constant CFG_SVT : integer := 0;
  constant CFG_RSTADDR : integer := 16#00000#;
  constant CFG_LDDEL : integer := (1);
  constant CFG_NWP : integer := (1);
  constant CFG_PWD : integer := 1*2;
  constant CFG_FPU : integer := 0 + 16*0;
  constant CFG_GRFPUSH : integer := 0;
  constant CFG_ICEN : integer := 1;
  constant CFG_ISETS : integer := 1;
  constant CFG_ISETSZ : integer := 8;
  constant CFG_ILINE : integer := 8;
  constant CFG_IREPL : integer := 0;
  constant CFG_ILOCK : integer := 0;
  constant CFG_ILRAMEN : integer := 0;
  constant CFG_ILRAMADDR: integer := 16#8E#;
  constant CFG_ILRAMSZ : integer := 1;
  constant CFG_DCEN : integer := 1;
  constant CFG_DSETS : integer := 1;
  constant CFG_DSETSZ : integer := 4;
  constant CFG_DLINE : integer := 8;
  constant CFG_DREPL : integer := 0;
  constant CFG_DLOCK : integer := 0;
  constant CFG_DSNOOP : integer := 0 + 0 + 4*0;
  constant CFG_DFIXED : integer := 16#0#;
  constant CFG_DLRAMEN : integer := 0;
  constant CFG_DLRAMADDR: integer := 16#8F#;
  constant CFG_DLRAMSZ : integer := 1;
  constant CFG_MMUEN : integer := 0;
  constant CFG_ITLBNUM : integer := 2;
  constant CFG_DTLBNUM : integer := 2;
  constant CFG_TLB_TYPE : integer := 1;
  constant CFG_TLB_REP : integer := 1;
  constant CFG_DSU : integer := 1;
  constant CFG_ITBSZ : integer := 2;
  constant CFG_ATBSZ : integer := 2;
  constant CFG_LEON3FT_EN : integer := 0;
  constant CFG_IUFT_EN : integer := 0;
  constant CFG_FPUFT_EN : integer := 0;
  constant CFG_RF_ERRINJ : integer := 0;
  constant CFG_CACHE_FT_EN : integer := 0;
  constant CFG_CACHE_ERRINJ : integer := 0;
  constant CFG_LEON3_NETLIST: integer := 0;
  constant CFG_DISAS : integer := 0 + 0;
  constant CFG_PCLOW : integer := 2;

-- AMBA settings
  constant CFG_DEFMST : integer := (0);
  constant CFG_RROBIN : integer := 1;
  constant CFG_SPLIT : integer := 0;
  constant CFG_AHBIO : integer := 16#FFF#;
  constant CFG_APBADDR : integer := 16#800#;

-- DSU UART
  constant CFG_AHB_UART : integer := 1;

-- PROM/SRAM controller
  constant CFG_SRCTRL : integer := 0;
  constant CFG_SRCTRL_PROMWS : integer := 0;
  constant CFG_SRCTRL_RAMWS : integer := 0;
  constant CFG_SRCTRL_IOWS : integer := 0;
  constant CFG_SRCTRL_RMW : integer := 0;
  constant CFG_SRCTRL_8BIT : integer := 0;

  constant CFG_SRCTRL_SRBANKS : integer := 1;
  constant CFG_SRCTRL_BANKSZ : integer := 0;
  constant CFG_SRCTRL_ROMASEL : integer := 0;
-- LEON2 memory controller
  constant CFG_MCTRL_LEON2 : integer := 1;
  constant CFG_MCTRL_RAM8BIT : integer := 0;
  constant CFG_MCTRL_RAM16BIT : integer := 0;
  constant CFG_MCTRL_5CS : integer := 0;
  constant CFG_MCTRL_SDEN : integer := 1;
  constant CFG_MCTRL_SEPBUS : integer := 1;
  constant CFG_MCTRL_INVCLK : integer := 0;
  constant CFG_MCTRL_SD64 : integer := 1;
  constant CFG_MCTRL_PAGE : integer := 0 + 0;

-- SDRAM controller
  constant CFG_SDCTRL : integer := 0;
  constant CFG_SDCTRL_INVCLK : integer := 0;
  constant CFG_SDCTRL_SD64 : integer := 0;
  constant CFG_SDCTRL_PAGE : integer := 0 + 0;

-- AHB RAM
  constant CFG_AHBRAMEN : integer := 0;
  constant CFG_AHBRSZ : integer := 1;
  constant CFG_AHBRADDR : integer := 16#A00#;

-- PCI interface
  constant CFG_PCI : integer := 1;
  constant CFG_PCIVID : integer := 16#16E3#;
  constant CFG_PCIDID : integer := 16#0210#;
  constant CFG_PCIDEPTH : integer := 8;
  constant CFG_PCI_MTF : integer := 1;

-- PCI arbiter
  constant CFG_PCI_ARB : integer := 0;
  constant CFG_PCI_ARBAPB : integer := 0;
  constant CFG_PCI_ARB_NGNT : integer := 4;

-- PCI trace buffer
  constant CFG_PCITBUFEN: integer := 0;
  constant CFG_PCITBUF : integer := 256;

-- UART 1
  constant CFG_UART1_ENABLE : integer := 1;
  constant CFG_UART1_FIFO : integer := 2;

-- UART 2
  constant CFG_UART2_ENABLE : integer := 1;
  constant CFG_UART2_FIFO : integer := 2;

-- LEON3 interrupt controller
  constant CFG_IRQ3_ENABLE : integer := 1;

-- Modular timer
  constant CFG_GPT_ENABLE : integer := 1;
  constant CFG_GPT_NTIM : integer := (3);
  constant CFG_GPT_SW : integer := (16);
  constant CFG_GPT_TW : integer := (32);
  constant CFG_GPT_IRQ : integer := (6);
  constant CFG_GPT_SEPIRQ : integer := 1;
  constant CFG_GPT_WDOGEN : integer := 1;
  constant CFG_GPT_WDOG : integer := 16#FFF#;

-- GPIO port
  constant CFG_GRGPIO_ENABLE : integer := 1;
  constant CFG_GRGPIO_IMASK : integer := 16#FFFE#;
  constant CFG_GRGPIO_WIDTH : integer := (16);

-- GRLIB debugging
  constant CFG_DUART : integer := 0;


  constant CFG_SDEN : integer := CFG_MCTRL_SDEN + CFG_SDCTRL;
  constant CFG_INVCLK : integer := CFG_MCTRL_INVCLK + CFG_SDCTRL_INVCLK;
end;
