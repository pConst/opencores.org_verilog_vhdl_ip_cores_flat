------------------------------------------------------------------------------
-- Author        : Timo Alho
-- e-mail        : timo.a.alho@tut.fi
-- Date          : 11.08.2004 13:28:18
-- File          : dctQidct_core_tb.vhd
-- Design        : VHDL Entity for dctQidct.dctQidct_core_tb.symbol
-- Generated by Mentor Graphics' HDL Designer 2003.1 (Build 399)
------------------------------------------------------------------------------


ENTITY dctQidct_core_tb IS
-- Declarations

END dctQidct_core_tb ;

------------------------------------------------------------------------------
-- Author        : Timo Alho
-- e-mail        : timo.a.alho@tut.fi
-- Date          : 11.08.2004 13:28:18
-- File          : dctQidct_core_tb.vhd
-- Design        : VHDL Architecture for dctQidct.dctQidct_core_tb.symbol
-- Generated by Mentor Graphics' HDL Designer 2003.1 (Build 399)
------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
LIBRARY dct;
USE dct.DCT_pkg.all;
LIBRARY idct;
USE idct.IDCT_pkg.all;
LIBRARY quantizer;
USE quantizer.Quantizer_pkg.all;
LIBRARY common_da;
LIBRARY std;
USE std.TEXTIO.all;


ARCHITECTURE struct OF dctQidct_core_tb IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL QP                    : std_logic_vector(4 DOWNTO 0);
   SIGNAL chroma                : std_logic;
   SIGNAL clk                   : std_logic;
   SIGNAL data_dct_in           : std_logic_vector(DCT_inputw_co-1 DOWNTO 0);
   SIGNAL data_idct_out         : std_logic_vector(IDCT_resultw_co-1 DOWNTO 0);
   SIGNAL data_quant_out        : std_logic_vector(QUANT_resultw_co-1 DOWNTO 0);
   SIGNAL dct_ready4column_out  : std_logic;
   SIGNAL idct_ready4column_in  : std_logic;
   SIGNAL intra                 : std_logic;
   SIGNAL loadQP                : std_logic;
   SIGNAL quant_ready4column_in : std_logic;
   SIGNAL rst_n                 : std_logic;
   SIGNAL wr_IDCT_out           : std_logic;
   SIGNAL wr_Q_out              : std_logic;
   SIGNAL wr_dct_in             : std_logic;


   -- Component Declarations
   COMPONENT dctQidct_core
   PORT (
      QP_in                 : IN     std_logic_vector (4 DOWNTO 0);
      chroma_in             : IN     std_logic ;
      clk                   : IN     std_logic ;
      -- input data bus
      data_dct_in           : IN     std_logic_vector (DCT_inputw_co-1 DOWNTO 0);
      -- idct output status (set to '1', if next block is cabaple of receiving column/row)
      idct_ready4column_in  : IN     std_logic ;
      intra_in              : IN     std_logic ;
      loadQP_in             : IN     std_logic ;
      -- quantizer output status (set to '1', if next block is cabaple of receiving column/row)
      quant_ready4column_in : IN     std_logic ;
      rst_n                 : IN     std_logic ;
      -- write signal for input data
      wr_dct_in             : IN     std_logic ;
      -- output data bus (idct)
      data_idct_out         : OUT    std_logic_vector (IDCT_resultw_co-1 DOWNTO 0);
      -- output data bus (quantizer)
      data_quant_out        : OUT    std_logic_vector (QUANT_resultw_co-1 DOWNTO 0);
      -- input status ('1' if block is capable of receiving column/row)
      dct_ready4column_out  : OUT    std_logic ;
      -- write signal for output data (idct)
      wr_idct_out           : OUT    std_logic ;
      -- write signal for output data (quantizer)
      wr_quant_out          : OUT    std_logic 
   );
   END COMPONENT;
   COMPONENT dctQidct_core_tester
   PORT (
      data_idct_out         : IN     std_logic_vector (IDCT_resultw_co-1 DOWNTO 0);
      data_quant_out        : IN     std_logic_vector (QUANT_resultw_co-1 DOWNTO 0);
      dct_ready4column_out  : IN     std_logic ;
      wr_IDCT_out           : IN     std_logic ;
      wr_Q_out              : IN     std_logic ;
      QP                    : OUT    std_logic_vector (4 DOWNTO 0);
      chroma                : OUT    std_logic ;
      clk                   : OUT    std_logic ;
      data_dct_in           : OUT    std_logic_vector (DCT_inputw_co-1 DOWNTO 0);
      idct_ready4column_in  : OUT    std_logic ;
      intra                 : OUT    std_logic ;
      loadQP                : OUT    std_logic ;
      quant_ready4column_in : OUT    std_logic ;
      rst_n                 : OUT    std_logic ;
      wr_dct_in             : OUT    std_logic 
   );
   END COMPONENT;


BEGIN

   -- Instance port mappings.
   DUT : dctQidct_core
      PORT MAP (
         QP_in                 => QP,
         chroma_in             => chroma,
         clk                   => clk,
         data_dct_in           => data_dct_in,
         idct_ready4column_in  => idct_ready4column_in,
         intra_in              => intra,
         loadQP_in             => loadQP,
         quant_ready4column_in => quant_ready4column_in,
         rst_n                 => rst_n,
         wr_dct_in             => wr_dct_in,
         data_idct_out         => data_idct_out,
         data_quant_out        => data_quant_out,
         dct_ready4column_out  => dct_ready4column_out,
         wr_idct_out           => wr_IDCT_out,
         wr_quant_out          => wr_Q_out
      );
   tester : dctQidct_core_tester
      PORT MAP (
         data_idct_out         => data_idct_out,
         data_quant_out        => data_quant_out,
         dct_ready4column_out  => dct_ready4column_out,
         wr_IDCT_out           => wr_IDCT_out,
         wr_Q_out              => wr_Q_out,
         QP                    => QP,
         chroma                => chroma,
         clk                   => clk,
         data_dct_in           => data_dct_in,
         idct_ready4column_in  => idct_ready4column_in,
         intra                 => intra,
         loadQP                => loadQP,
         quant_ready4column_in => quant_ready4column_in,
         rst_n                 => rst_n,
         wr_dct_in             => wr_dct_in
      );

END struct;
