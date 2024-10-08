-------------------------------------------------------------------------------
-- Title      :  Single port RAM
-- Project    :  Memory Cores
-------------------------------------------------------------------------------
-- File        : spmem.vhd
-- Author      : Jamil Khatib  (khatib@ieee.org)
-- Organization: OpenIPCore Project
-- Created     : 1999/5/14
-- Last update : 2000/12/19
-- Platform    : 
-- Simulators  : Modelsim 5.3XE/Windows98
-- Synthesizers: Leonardo/WindowsNT
-- Target      : 
-- Dependency  : ieee.std_logic_1164,ieee.std_logic_unsigned
-------------------------------------------------------------------------------
-- Description:  Single Port memory
-------------------------------------------------------------------------------
-- Copyright (c) 2000 Jamil Khatib
-- 
-- This VHDL design file is an open design; you can redistribute it and/or
-- modify it and/or implement it after contacting the author
-- You can check the draft license at
-- http://www.opencores.org/OIPC/license.shtml

-------------------------------------------------------------------------------
-- Revisions  :
-- Revision Number :   1
-- Version         :   0.1
-- Date            :   12 May 1999
-- Modifier        :   Jamil Khatib (khatib@ieee.org)
-- Desccription    :   Created
-- Known bugs      :   
-- To Optimze      :   
-------------------------------------------------------------------------------
-- Revisions  :
-- Revision Number :   2
-- Version         :   0.2
-- Date            :   19 Dec 2000
-- Modifier        :   Jamil Khatib (khatib@ieee.org)
-- Desccription    :   General review
--                     Two versions are now available with reset and without
--                     Default output can can be defined
-- Known bugs      :   
-- To Optimze      :   
-------------------------------------------------------------------------------
-- Revisions  :
-- Revision Number :   3
-- Version         :   0.3
-- Date            :   5 Jan 2001
-- Modifier        :   Jamil Khatib (khatib@ieee.org)
-- Desccription    :   Registered Read Address feature is added to make use of
--                     Altera's FPGAs memory bits
--                     This feature was added from Richard Herveille's
--                     contribution and his memory core
-- Known bugs      :   
-- To Optimze      :   
-------------------------------------------------------------------------------

-- (!)
-- Original file modified to reduce code and make WR and reset signals 
-- positive, make Reset sincronous, make data transfer asinc.


library ieee;

use ieee.std_logic_1164.all;

use ieee.std_logic_unsigned.all;

-------------------------------------------------------------------------------
-- Single port Memory core with reset
-- To make use of on FPGA memory bits do not use the RESET option
-- For Altera's FPGA you have to use also OPTION := 1

entity mem_8bit_reset is

  generic ( --USE_RESET   : boolean   := false;  -- use system reset

            --USE_CS      : boolean   := false;  -- use chip select signal

            DEFAULT_OUT : std_logic := '0';  -- Default output
            --OPTION      : integer   := 1;  -- 1: Registered read Address(suitable
                                        -- for Altera's FPGAs
                                        -- 0: non registered read address
            ADD_WIDTH   : integer   := 8;
            WIDTH       : integer   := 8);

  port (
    cs       : in  std_logic;           -- chip select
    clk      : in  std_logic;           -- write clock
    reset    : in  std_logic;           -- System Reset
    add      : in  std_logic_vector(add_width -1 downto 0);  --  Address
    Data_In  : in  std_logic_vector(WIDTH -1 downto 0);  -- input data
    Data_Out : out std_logic_vector(WIDTH -1 downto 0);  -- Output Data
    WR       : in  std_logic);          -- Read Write Enable
end mem_8bit_reset;



architecture spmem_beh of mem_8bit_reset is

  type data_array is array (integer range <>) of std_logic_vector(WIDTH-1 downto 0);
 -- signal s_reset: std_logic;
                                                      -- Memory Type
  signal data : data_array(0 to (2** add_width-1) );  -- Local data
  

	-- FLEX/APEX devices require address to be registered with inclock for read operations
  -- This signal is used only when OPTION = 1 
	-- signal regA : std_logic_vector( (add_width -1) downto 0);
  
  procedure init_mem(signal memory_cell : inout data_array ) is

  begin

    for i in 0 to (2** add_width-1) loop
      memory_cell(i) <= (others => '0');
    end loop;

  end init_mem;

begin  -- spmem_beh
-- -------------------------------------------------------------------------------
-- -- Non Registered Read Address
-- -------------------------------------------------------------------------------
   -- NON_REG         : if OPTION = 0 generate
-- -------------------------------------------------------------------------------
-- -- Clocked Process with Reset
-- -------------------------------------------------------------------------------
   -- Reset_ENABLED : if USE_RESET = true generate

-- -------------------------------------------------------------------------------
--      CS_ENABLED  : if USE_CS = true generate

        process (clk, reset,CS,WR, add)

        begin  -- PROCESS
          -- activities triggered by asynchronous reset (active low)

          -- activities triggered by rising edge of clock
       
          data_out <= data(conv_integer(add));
            
          
          if clk'event and clk = '1' then
          	if reset = '1' then
              init_mem (data);
          	elsif CS = '1' then
	          if WR = '1' then
	              data(conv_integer(add)) <= Data_In;
	          end if;
	        end if;
          end if;
        

        end process;
--     end generate CS_ENABLED;
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
      -- CS_DISABLED : if USE_CS = false generate

        -- process (clk, reset)


        -- begin  -- PROCESS
          -- -- activities triggered by asynchronous reset (active low)

          -- if reset = '0' then
            -- data_out <= (others => DEFAULT_OUT);
            -- init_mem ( data);

            -- -- activities triggered by rising edge of clock
          -- elsif clk'event and clk = '1' then
            -- if WR = '0' then
              -- data(conv_integer(add)) <= data_in;
              -- data_out                <= (others => DEFAULT_OUT);
            -- else
              -- data_out                <= data(conv_integer(add));
            -- end if;

          -- end if;

        -- end process;
      -- end generate CS_DISABLED;

-- -------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------
    -- end generate Reset_ENABLED;
-- -------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------
-- -- Clocked Process without Reset
-- -------------------------------------------------------------------------------
    -- Reset_DISABLED : if USE_RESET = false generate

-- -------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------    
      -- CS_ENABLED   : if USE_CS = true generate

        -- process (clk)
        -- begin  -- PROCESS

          -- -- activities triggered by rising edge of clock
          -- if clk'event and clk = '1' then
            -- if cs = '1' then
              -- if WR = '0' then
                -- data(conv_integer(add)) <= data_in;
                -- data_out                <= (others => DEFAULT_OUT);
              -- else
                -- data_out                <= data(conv_integer(add));
              -- end if;
            -- else
              -- data_out                  <= (others => DEFAULT_OUT);
            -- end if;


          -- end if;

        -- end process;
      -- end generate CS_ENABLED;
-- -------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------
      -- CS_DISABLED : if USE_CS = false generate

        -- process (clk)
        -- begin  -- PROCESS

          -- -- activities triggered by rising edge of clock
          -- if clk'event and clk = '1' then
            -- if WR = '0' then
              -- data(conv_integer(add)) <= data_in;
              -- data_out                <= (others => DEFAULT_OUT);
            -- else
              -- data_out                <= data(conv_integer(add));
            -- end if;

          -- end if;

        -- end process;
      -- end generate CS_DISABLED;
-- -------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------
    -- end generate Reset_DISABLED;
-- -------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------
  -- end generate NON_REG;
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- REG: if OPTION = 1 generate
-- -------------------------------------------------------------------------------
-- -- Clocked Process with Reset
-- -------------------------------------------------------------------------------
    -- Reset_ENABLED : if USE_RESET = true generate

-- -------------------------------------------------------------------------------
      -- CS_ENABLED  : if USE_CS = true generate

        -- process (clk, reset)

        -- begin  -- PROCESS
          -- -- activities triggered by asynchronous reset (active low)

          -- if reset = '0' then
            -- data_out <= (others => DEFAULT_OUT);
            -- init_mem ( data);

            -- -- activities triggered by rising edge of clock
          -- elsif clk'event and clk = '1' then

            -- regA <= add;
            
            -- if CS = '1' then
              -- if WR = '0' then
                -- data(conv_integer(add)) <= data_in;
                -- data_out                <= (others => DEFAULT_OUT);
              -- else
                -- data_out                <= data(conv_integer(regA));
              -- end if;
            -- else
              -- data_out                  <= (others => DEFAULT_OUT);
            -- end if;

          -- end if;

        -- end process;
      -- end generate CS_ENABLED;
-- -------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------
      -- CS_DISABLED : if USE_CS = false generate

        -- process (clk, reset)


        -- begin  -- PROCESS
          -- -- activities triggered by asynchronous reset (active low)

          -- if reset = '0' then
            -- data_out <= (others => DEFAULT_OUT);
            -- init_mem ( data);

            -- -- activities triggered by rising edge of clock
          -- elsif clk'event and clk = '1' then
            -- regA <= add;
            
            -- if WR = '0' then
              -- data(conv_integer(add)) <= data_in;
              -- data_out                <= (others => DEFAULT_OUT);
            -- else
              -- data_out                <= data(conv_integer(regA));
            -- end if;

          -- end if;

        -- end process;
      -- end generate CS_DISABLED;

-- -------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------
    -- end generate Reset_ENABLED;
-- -------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------
-- -- Clocked Process without Reset
-- -------------------------------------------------------------------------------
    -- Reset_DISABLED : if USE_RESET = false generate

-- -------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------    
      -- CS_ENABLED   : if USE_CS = true generate

        -- process (clk)
        -- begin  -- PROCESS

          -- -- activities triggered by rising edge of clock
          -- if clk'event and clk = '1' then

            -- regA <= add;
            
            -- if cs = '1' then
              -- if WR = '0' then
                -- data(conv_integer(add)) <= data_in;
                -- data_out                <= (others => DEFAULT_OUT);
              -- else
                -- data_out                <= data(conv_integer(regA));
              -- end if;
            -- else
              -- data_out                  <= (others => DEFAULT_OUT);
            -- end if;


          -- end if;

        -- end process;
      -- end generate CS_ENABLED;
-- -------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------
      -- CS_DISABLED : if USE_CS = false generate

        -- process (clk)
        -- begin  -- PROCESS

          -- -- activities triggered by rising edge of clock
          -- if clk'event and clk = '1' then
            
            -- regA <= add;
                    
            -- if WR = '0' then
              -- data(conv_integer(add)) <= data_in;
              -- data_out                <= (others => DEFAULT_OUT);
            -- else
              -- data_out                <= data(conv_integer(regA));
            -- end if;

          -- end if;

        -- end process;
      -- end generate CS_DISABLED;
-- -------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------
    -- end generate Reset_DISABLED;
-- -------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------
  
-- end generate REG;

end spmem_beh;
-------------------------------------------------------------------------------
