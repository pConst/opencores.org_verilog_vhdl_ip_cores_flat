------------------------------------------------------------------------------
--  LEON3 Demonstration design test bench
--  Copyright (C) 2004 Jiri Gaisler, Gaisler Research
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library gaisler;
use gaisler.libdcom.all;
use gaisler.sim.all;
library techmap;
use techmap.gencomp.all;
library micron;
use micron.components.all;
use work.debug.all;

use work.config.all;	-- configuration

entity testbench is
  generic (
    fabtech   : integer := CFG_FABTECH;
    memtech   : integer := CFG_MEMTECH;
    padtech   : integer := CFG_PADTECH;
    clktech   : integer := CFG_CLKTECH;
    ncpu      : integer := CFG_NCPU;
    disas     : integer := CFG_DISAS;	-- Enable disassembly to console
    dbguart   : integer := CFG_DUART;	-- Print UART on console
    pclow     : integer := CFG_PCLOW;

    clkperiod : integer := 20;		-- system clock period
    romwidth  : integer := 8;		-- rom data width (8/32)
    romdepth  : integer := 23;		-- rom address depth
    sramwidth  : integer := 32;		-- ram data width (8/16/32)
    sramdepth  : integer := 20;		-- ram address depth
    srambanks  : integer := 1		-- number of ram banks
  );
end; 

architecture behav of testbench is

constant promfile  : string := "prom.srec";  -- rom contents
constant sramfile  : string := "sram.srec";  -- ram contents
constant sdramfile : string := "sdram.srec"; -- sdram contents

component leon3mp 
  generic (
    fabtech  : integer := CFG_FABTECH;
    memtech  : integer := CFG_MEMTECH;
    padtech  : integer := CFG_PADTECH;
    clktech  : integer := CFG_CLKTECH;
    ncpu     : integer := CFG_NCPU;
    disas    : integer := CFG_DISAS;	-- Enable disassembly to console
    dbguart  : integer := CFG_DUART;	-- Print UART on console
    pclow    : integer := CFG_PCLOW
  );
  port (
    resetn	: in  std_ulogic;
    clk		: in  std_ulogic;
    clkout      : out std_ulogic;
    pllref      : in  std_ulogic;
    errorn	: out std_ulogic;
    address 	: out std_logic_vector(27 downto 0);
    data	: inout std_logic_vector(31 downto 0);

    ramsn  	: out std_ulogic;
    ramoen 	: out std_ulogic;
    rwen   	: out std_ulogic;
    mben        : out std_logic_vector (3 downto 0);
    iosn        : out std_ulogic;
    romsn  	: out std_ulogic;
    oen    	: out std_ulogic;
    writen 	: out std_ulogic;
    
    sa      	: out std_logic_vector(11 downto 0);
    sd   	: inout std_logic_vector(31 downto 0);
    sdclk  	: out std_ulogic;
    sdcke  	: out std_ulogic;    -- sdram clock enable
    sdcsn  	: out std_ulogic;    -- sdram chip select
    sdwen  	: out std_ulogic;                       -- sdram write enable
    sdrasn  	: out std_ulogic;                       -- sdram ras
    sdcasn  	: out std_ulogic;                       -- sdram cas
    sddqm   	: out std_logic_vector (3 downto 0);    -- sdram dqm
    sdba        : out std_logic_vector (1 downto 0);
    
    dsutx  	: out std_ulogic; 			-- DSU tx data
    dsurx  	: in  std_ulogic;  			-- DSU rx data
    dsubren  	: in std_ulogic;
    dsuact  	: out std_ulogic;
    
    rxd1   	: in  std_ulogic;  			-- UART1 rx data
    txd1   	: out std_ulogic; 			-- UART1 tx data    
   
    ata_rst   : out std_logic; 
    ata_data  : inout std_logic_vector(15 downto 0);
    ata_da    : out std_logic_vector(2 downto 0);  
    ata_cs0   : out std_logic;
    ata_cs1   : out std_logic;
    ata_dior  : out std_logic;
    ata_diow  : out std_logic;
    ata_iordy : in std_logic;
    ata_intrq : in std_logic;
    ata_dmack : out std_logic;
    cf_power  : out std_logic;  
    cf_gnd_da : out std_logic_vector(10 downto 3); -- grounded address lines
    cf_atasel : out std_logic; -- grounded to select true IDE mode
    cf_we     : out std_logic; -- should be connected to VCC in true IDE mode
    cf_csel   : out std_logic;

    -- for smc lan chip
    eth_aen    : out std_ulogic; 
    eth_readn  : out std_ulogic; 
    eth_writen : out std_ulogic; 
    eth_nbe    : out std_logic_vector (3 downto 0);
    
    eth_lclk     : out std_ulogic;
    eth_nads     : out std_logic;
    eth_ncycle   : out std_logic;
    eth_wnr      : out std_logic;
    eth_nvlbus   : out std_logic;
    eth_nrdyrtn  : out std_logic;
    eth_ndatacs  : out std_logic
	);
end component;

signal clk : std_logic := '0';
signal clkout, pllref : std_ulogic;
signal Rst    : std_logic := '0';			-- Reset
constant ct : integer := clkperiod/2;

signal address  : std_logic_vector(27 downto 0);
signal data     : std_logic_vector(31 downto 0);

signal ramsn    : std_ulogic;
signal ramoen   : std_ulogic;
signal rwen     : std_ulogic;
signal mben     : std_logic_vector(3 downto 0);
--signal rwenx    : std_logic_vector(3 downto 0);
signal romsn    : std_ulogic;
signal iosn     : std_ulogic;
signal oen      : std_ulogic;
--signal read     : std_ulogic;
signal writen   : std_ulogic;
signal brdyn    : std_ulogic;
signal bexcn    : std_ulogic;
signal wdog     : std_ulogic;
signal dsuen, dsutx, dsurx, dsubren, dsuact : std_ulogic;
signal dsurst   : std_ulogic;
signal test     : std_ulogic;
signal error    : std_logic;
signal gpio	: std_logic_vector(7 downto 0);
signal GND      : std_ulogic := '0';
signal VCC      : std_ulogic := '1';
signal NC       : std_ulogic := 'Z';
signal clk2     : std_ulogic := '1';
    
signal sdcke    : std_ulogic;  -- clk en
signal sdcsn    : std_ulogic;  -- chip sel
signal sdwen    : std_ulogic;                       -- write en
signal sdrasn   : std_ulogic;                       -- row addr stb
signal sdcasn   : std_ulogic;                       -- col addr stb
signal sddqm    : std_logic_vector (3 downto 0);  -- data i/o mask
signal sdclk    : std_ulogic;
signal sdba     : std_logic_vector(1 downto 0); 

signal plllock    : std_ulogic;       
signal txd1, rxd1 : std_ulogic;       
--signal txd2, rxd2 : std_ulogic;       

-- for smc lan chip
signal eth_aen    : std_ulogic; -- for smsc eth
signal eth_readn  : std_ulogic; -- for smsc eth
signal eth_writen : std_ulogic; -- for smsc eth
signal eth_nbe    : std_logic_vector(3 downto 0); -- for smsc eth
signal eth_datacsn : std_ulogic;

constant lresp : boolean := false;

signal sa      	: std_logic_vector(14 downto 0);
signal sd   	: std_logic_vector(31 downto 0);

-- ATA signals
signal ata_rst   : std_logic;   
signal ata_data  : std_logic_vector(15 downto 0);
signal ata_da    : std_logic_vector(2 downto 0);
signal ata_cs0   : std_logic;
signal ata_cs1   : std_logic;
signal ata_dior  : std_logic;
signal ata_diow  : std_logic;
signal ata_iordy : std_logic;
signal ata_intrq : std_logic;
signal ata_dmack : std_logic;
signal cf_gnd_da : std_logic_vector(10 downto 3); 
signal cf_atasel : std_logic; 
signal cf_we     : std_logic; 
signal cf_power  : std_logic;
signal cf_csel   : std_logic;

signal from_ata : ata_out_type := ATAO_RESET_VECTOR;
signal to_ata : ata_in_type := ATAI_RESET_VECTOR;

begin

-- clock and reset

  clk <= not clk after ct * 1 ns;
  rst <= dsurst;
  dsubren <= '1'; rxd1 <= '1';
  pllref <= clkout;
  d3 : leon3mp
        generic map ( fabtech, memtech, padtech, clktech, ncpu,
	disas, dbguart, pclow )
        port map (rst, clk, clkout, pllref, error, address, data,
                  ramsn, ramoen, rwen, mben, iosn,
                  romsn, oen, writen,
                  sa(11 downto 0), sd, sdclk, sdcke, sdcsn, sdwen, sdrasn, sdcasn, sddqm, sdba,
                  dsutx, dsurx, dsubren, dsuact,
                  rxd1, txd1, 
                  ata_rst, ata_data, ata_da, ata_cs0, ata_cs1, ata_dior, ata_diow, 
                  ata_iordy, ata_intrq, ata_dmack, 
                  cf_power, cf_gnd_da, cf_atasel, cf_we, cf_csel,
                  eth_aen, eth_readn, eth_writen, eth_nbe); 

-- optional sdram

  sd1 : if (CFG_MCTRL_SDEN = 1) and (CFG_MCTRL_SEPBUS = 1) generate
    u0: mt48lc16m16a2 generic map (index => 0, fname => sdramfile)
	PORT MAP(
            Dq => sd(31 downto 16), Addr => sa(12 downto 0),
            Ba => sdba, Clk => sdclk, Cke => sdcke,
            Cs_n => sdcsn, Ras_n => sdrasn, Cas_n => sdcasn, We_n => sdwen,
            Dqm => sddqm(3 downto 2));
    u1: mt48lc16m16a2 generic map (index => 16, fname => sdramfile)
	PORT MAP(
            Dq => sd(15 downto 0), Addr => sa(12 downto 0),
            Ba => sdba, Clk => sdclk, Cke => sdcke,
            Cs_n => sdcsn, Ras_n => sdrasn, Cas_n => sdcasn, We_n => sdwen,
            Dqm => sddqm(1 downto 0));
    u2: mt48lc16m16a2 generic map (index => 0, fname => sdramfile)
	PORT MAP(
            Dq => sd(31 downto 16), Addr => sa(12 downto 0),
            Ba => sdba, Clk => sdclk, Cke => sdcke,
            Cs_n => sdcsn, Ras_n => sdrasn, Cas_n => sdcasn, We_n => sdwen,
            Dqm => sddqm(3 downto 2));
    u3: mt48lc16m16a2 generic map (index => 16, fname => sdramfile)
	PORT MAP(
            Dq => sd(15 downto 0), Addr => sa(12 downto 0),
            Ba => sdba, Clk => sdclk, Cke => sdcke,
            Cs_n => sdcsn, Ras_n => sdrasn, Cas_n => sdcasn, We_n => sdwen,
            Dqm => sddqm(1 downto 0));

  end generate;

  -- 8 bit prom
  prom0 : sram generic map (index => 6, abits => romdepth, fname => promfile)
	port map (address(romdepth-1 downto 0), data(31 downto 24), 
		  romsn, rwen, oen);

  sram0 : for i in 0 to (sramwidth/8)-1 generate
    sr0 : sram generic map (index => i, abits => sramdepth, fname => sramfile)
      port map (address(sramdepth+1 downto 2), data(31-i*8 downto 24-i*8), ramsn,
		  rwen, ramoen);
  end generate;
  
  disk: ata_device
    generic map( sector_length => 512, log2_size => 14)
    port map( clk => clk, rst => rst, d => ata_data, atai => to_ata,
      atao => from_ata
    );
  to_ata.cs(0)<=ata_cs0; to_ata.cs(1)<=ata_cs1;
  to_ata.da<=ata_da; to_ata.dmack<=ata_dmack;
  to_ata.dior<=ata_dior; to_ata.diow<=ata_diow; to_ata.reset<=ata_rst;
  ata_intrq<=from_ata.intrq; ata_iordy<=from_ata.iordy;

  error <= 'H';			  -- ERROR pull-up

   iuerr : process
   begin
     wait for 2500 ns;
     if to_x01(error) = '1' then wait on error; end if;
     assert (to_x01(error) = '1') 
       report "*** IU in error mode, simulation halted ***"
         severity failure ;
   end process;

  data <= buskeep(data), (others => 'H') after 250 ns;
  sd <= buskeep(sd), (others => 'H') after 250 ns;

  test0 :  grtestmod
    port map ( rst, clk, error, address(21 downto 2), data,
    	       iosn, oen, writen, brdyn);


  dsucom : process
    procedure dsucfg(signal dsurx : in std_ulogic; signal dsutx : out std_ulogic) is
    variable w32 : std_logic_vector(31 downto 0);
    variable c8  : std_logic_vector(7 downto 0);
    constant txp : time := 160 * 1 ns;
    begin
    dsutx <= '1';
    dsurst <= '0';
    wait for 500 ns;
    dsurst <= '1';
    wait;
    wait for 5000 ns;
    txc(dsutx, 16#55#, txp);		-- sync uart

--    txc(dsutx, 16#c0#, txp);
--    txa(dsutx, 16#90#, 16#00#, 16#00#, 16#00#, txp);
--    txa(dsutx, 16#00#, 16#00#, 16#02#, 16#ae#, txp);
--    txc(dsutx, 16#c0#, txp);
--    txa(dsutx, 16#91#, 16#00#, 16#00#, 16#00#, txp);
--    txa(dsutx, 16#00#, 16#00#, 16#06#, 16#ae#, txp);
--    txc(dsutx, 16#c0#, txp);
--    txa(dsutx, 16#90#, 16#00#, 16#00#, 16#24#, txp);
--    txa(dsutx, 16#00#, 16#00#, 16#06#, 16#03#, txp);
--    txc(dsutx, 16#c0#, txp);
--    txa(dsutx, 16#90#, 16#00#, 16#00#, 16#20#, txp);
--    txa(dsutx, 16#00#, 16#00#, 16#06#, 16#fc#, txp);

    txc(dsutx, 16#c0#, txp);
    txa(dsutx, 16#90#, 16#00#, 16#00#, 16#00#, txp);
    txa(dsutx, 16#00#, 16#00#, 16#00#, 16#2f#, txp);
    txc(dsutx, 16#c0#, txp);
    txa(dsutx, 16#91#, 16#00#, 16#00#, 16#00#, txp);
    txa(dsutx, 16#00#, 16#00#, 16#00#, 16#6f#, txp);
    txc(dsutx, 16#c0#, txp);
    txa(dsutx, 16#90#, 16#11#, 16#00#, 16#00#, txp);
    txa(dsutx, 16#00#, 16#00#, 16#00#, 16#00#, txp);
    txc(dsutx, 16#c0#, txp);
    txa(dsutx, 16#90#, 16#40#, 16#00#, 16#04#, txp);
    txa(dsutx, 16#00#, 16#02#, 16#20#, 16#01#, txp);
    txc(dsutx, 16#c0#, txp);
    txa(dsutx, 16#90#, 16#00#, 16#00#, 16#20#, txp);
    txa(dsutx, 16#00#, 16#00#, 16#00#, 16#02#, txp);

    txc(dsutx, 16#c0#, txp);
    txa(dsutx, 16#90#, 16#00#, 16#00#, 16#20#, txp);
    txa(dsutx, 16#00#, 16#00#, 16#00#, 16#0f#, txp);

    txc(dsutx, 16#c0#, txp);
    txa(dsutx, 16#40#, 16#00#, 16#43#, 16#10#, txp);
    txa(dsutx, 16#00#, 16#00#, 16#00#, 16#0f#, txp);

    txc(dsutx, 16#c0#, txp);
    txa(dsutx, 16#91#, 16#40#, 16#00#, 16#24#, txp);
    txa(dsutx, 16#00#, 16#00#, 16#00#, 16#24#, txp);
    txc(dsutx, 16#c0#, txp);
    txa(dsutx, 16#91#, 16#70#, 16#00#, 16#00#, txp);
    txa(dsutx, 16#00#, 16#00#, 16#00#, 16#03#, txp);





    txc(dsutx, 16#c0#, txp);
    txa(dsutx, 16#90#, 16#00#, 16#00#, 16#20#, txp);
    txa(dsutx, 16#00#, 16#00#, 16#ff#, 16#ff#, txp);

    txc(dsutx, 16#c0#, txp);
    txa(dsutx, 16#90#, 16#40#, 16#00#, 16#48#, txp);
    txa(dsutx, 16#00#, 16#00#, 16#00#, 16#12#, txp);

    txc(dsutx, 16#c0#, txp);
    txa(dsutx, 16#90#, 16#40#, 16#00#, 16#60#, txp);
    txa(dsutx, 16#00#, 16#00#, 16#12#, 16#10#, txp);

    txc(dsutx, 16#80#, txp);
    txa(dsutx, 16#90#, 16#00#, 16#00#, 16#00#, txp);
    rxi(dsurx, w32, txp, lresp);

    txc(dsutx, 16#a0#, txp);
    txa(dsutx, 16#40#, 16#00#, 16#00#, 16#00#, txp);
    rxi(dsurx, w32, txp, lresp);

    end;

  begin

    dsucfg(dsutx, dsurx);

    wait;
  end process;
end ;

