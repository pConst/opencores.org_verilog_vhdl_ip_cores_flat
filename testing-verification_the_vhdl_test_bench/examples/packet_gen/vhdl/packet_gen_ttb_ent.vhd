-------------------------------------------------------------------------------
--             Copyright -----------------------------------
--                        All Rights Reserved
-------------------------------------------------------------------------------
-- $Author:  $
--
-- $date:  $
--
-- $Id:  $
--
-- $Source:  $
--
-- Description :
--          This file was generated by TTB Gen Plus Beta 2.0
--            on 01 May 2011 21:23:14
------------------------------------------------------------------------------
-- This software contains concepts confidential to ----------------
-- ---------. and is only made available within the terms of a written
-- agreement.
-------------------------------------------------------------------------------
-- Revision History:
-- $Log:  $
--
-------------------------------------------------------------------------------

library IEEE;
--library dut_lib;
use IEEE.STD_LOGIC_1164.all;
use work.tb_pkg.all;
use work.pgen.all;
--use dut_lib.all;

entity packet_gen_ttb is
  generic (
           stimulus_file: string := "stm/stimulus_file.stm"
          );
end packet_gen_ttb;
