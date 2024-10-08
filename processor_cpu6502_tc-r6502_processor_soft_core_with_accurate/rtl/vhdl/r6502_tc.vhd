-- VHDL Entity R6502_TC.R6502_TC.symbol
--
-- Created:
--          by - eda.UNKNOWN (ENTW1)
--          at - 14:13:53 08.03.2010
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.1 (Build 12)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY R6502_TC IS
   PORT( 
      clk_clk_i   : IN     std_logic;
      d_i         : IN     std_logic_vector (7 DOWNTO 0);
      irq_n_i     : IN     std_logic;
      nmi_n_i     : IN     std_logic;
      rdy_i       : IN     std_logic;
      rst_rst_n_i : IN     std_logic;
      so_n_i      : IN     std_logic;
      a_o         : OUT    std_logic_vector (15 DOWNTO 0);
      d_o         : OUT    std_logic_vector (7 DOWNTO 0);
      rd_o        : OUT    std_logic;
      sync_o      : OUT    std_logic;
      wr_n_o      : OUT    std_logic;
      wr_o        : OUT    std_logic
   );

-- Declarations

END R6502_TC ;

-- Jens-D. Gutschmidt     Project:  R6502_TC  
-- scantara2003@yahoo.de                      
-- COPYRIGHT (C) 2008-2010 by Jens Gutschmidt and OPENCORES.ORG                                                                                
--                                                                                                                                             
-- This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by   
-- the Free Software Foundation, either version 3 of the License, or any later version.                                                        
--                                                                                                                                             
-- This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of              
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.                                  
--                                                                                                                                             
-- You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.     
--                                                                                                                                             
-- CVS Revisins History                                                                                                                        
--                                                                                                                                             
-- $Log: struct.bd,v $                                                                                                                         
--   <<-- more -->>                                                                                                                            
-- Title:  Top Level  
-- Path:  R6502_TC/R6502_TC/struct  
-- Edited:  by eda on 08 Feb 2010  
--
-- VHDL Architecture R6502_TC.R6502_TC.struct
--
-- Created:
--          by - eda.UNKNOWN (ENTW1)
--          at - 14:13:53 08.03.2010
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.1 (Build 12)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY R6502_TC;

ARCHITECTURE struct OF R6502_TC IS

   -- Architecture declarations

   -- Internal signal declarations


   -- Component Declarations
   COMPONENT Core
   PORT (
      clk_clk_i   : IN     std_logic ;
      d_i         : IN     std_logic_vector (7 DOWNTO 0);
      irq_n_i     : IN     std_logic ;
      nmi_n_i     : IN     std_logic ;
      rdy_i       : IN     std_logic ;
      rst_rst_n_i : IN     std_logic ;
      so_n_i      : IN     std_logic ;
      a_o         : OUT    std_logic_vector (15 DOWNTO 0);
      d_o         : OUT    std_logic_vector (7 DOWNTO 0);
      rd_o        : OUT    std_logic ;
      sync_o      : OUT    std_logic ;
      wr_n_o      : OUT    std_logic ;
      wr_o        : OUT    std_logic 
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : Core USE ENTITY R6502_TC.Core;
   -- pragma synthesis_on


BEGIN

   -- Instance port mappings.
   U_0 : Core
      PORT MAP (
         clk_clk_i   => clk_clk_i,
         d_i         => d_i,
         irq_n_i     => irq_n_i,
         nmi_n_i     => nmi_n_i,
         rdy_i       => rdy_i,
         rst_rst_n_i => rst_rst_n_i,
         so_n_i      => so_n_i,
         a_o         => a_o,
         d_o         => d_o,
         rd_o        => rd_o,
         sync_o      => sync_o,
         wr_n_o      => wr_n_o,
         wr_o        => wr_o
      );

END struct;
