-------------------------------------------------------------------------------
-- Funbase IP library Copyright (C) 2011 TUT Department of Computer Systems
--
-- This source file may be used and distributed without
-- restriction provided that this copyright statement is not
-- removed from the file and that any derivative work contains
-- the original copyright notice and the associated disclaimer.
--
-- This source file is free software; you can redistribute it
-- and/or modify it under the terms of the GNU Lesser General
-- Public License as published by the Free Software Foundation;
-- either version 2.1 of the License, or (at your option) any
-- later version.
--
-- This source is distributed in the hope that it will be
-- useful, but WITHOUT ANY WARRANTY; without even the implied
-- warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
-- PURPOSE.  See the GNU Lesser General Public License for more
-- details.
--
-- You should have received a copy of the GNU Lesser General
-- Public License along with this source; if not, download it
-- from http://www.opencores.org/lgpl.shtml
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- File        : addr_data_muxes.vhdl
-- Design
-- Description : Converts separated addr+data signalling into multiplexed addr/data.
--               Two components : one for writing and one for reading fifo.
--               Input : separate addr + data ports
--               Out   : addr + data muxed into one port
--               Write_Mux checks the incoming addr+comm. Same addr+comm is not
--               written to fifo more than once!
--               
-- Author      : Erno Salminen
-- e-mail       : erno.salminen@tut.fi
-- Design      : Do not use term design when you mean system
-- Project      huuhaa
-- Date        : 15.01.2003
-- Modified    : 
--               
-- 20.01        ES Comm_In/Out added
-- 05.02.2003   Name changed from fifo_mux_X to addr_data_mux_X
-- 26.03.03     Last_Comm_Reg added
-- 18.09.03     ES one_place / one_dat could be removed ??
-- 10.11.03     ES  write:elsif Full_In = '1' and Tmp_Data_Valid_Reg = '0' added 10.11.2003 es
--
-- 15.12.04     ES names changed
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;





entity addr_data_mux_write is

  generic (
    data_width_g         :     integer := 0;
    addr_width_g         :     integer := 0;
    comm_width_g         :     integer := 0
    );
  port (
    clk                : in  std_logic;
    rst_n              : in  std_logic;

    data_in   : in  std_logic_vector ( data_width_g-1 downto 0);
    addr_in   : in  std_logic_vector ( addr_width_g-1 downto 0);
    comm_in   : in  std_logic_vector ( comm_width_g-1 downto 0);
    we_in     : in  std_logic;
    full_out  : out std_logic;
    one_p_out : out std_logic;          -- unused ??

    data_out : out std_logic_vector ( data_width_g-1 downto 0);
    comm_out : out std_logic_vector ( comm_width_g-1 downto 0);
    av_out   : out std_logic;
    we_out   : out std_logic;
    one_p_in : in  std_logic;           -- ununsed ??
    full_in  : in  std_logic
    );

end addr_data_mux_write;



architecture rtl of addr_data_mux_write is

  -- rekisterit
  signal   state_r    : integer range 0 to 4;
  signal   next_state : integer range 0 to 4;
  -- Tilakoodaus
  -- 0 idle
  -- 1 write addr, keep output, write d_r when leaving
  -- 2 write data
  -- 3 write data full, keep output, write d_r when leaving
  -- 4 write data full 2, keep output, write a_r when leaving
  constant idle_c     : integer := 0;
  constant wr_a_c     : integer := 1;
  constant wr_d_c     : integer := 2;
  constant wr_d_f1_c  : integer := 3;
  constant wr_d_f2_c  : integer := 4;


  signal addr_r     : std_logic_vector ( addr_width_g-1 downto 0);
  signal comm_r     : std_logic_vector ( comm_width_g-1 downto 0);
  signal comm_out_r : std_logic_vector ( comm_width_g-1 downto 0);
  signal data_r     : std_logic_vector ( data_width_g-1 downto 0);
  signal data_out_r : std_logic_vector ( data_width_g-1 downto 0);
  signal full_out_r : std_logic;
  signal av_out_r   : std_logic;
  signal we_out_r   : std_logic;

  
begin  -- rtl

  -- Concurrent assignments
  av_out   <= av_out_r;
  full_out <= full_out_r;
  comm_out <= comm_out_r;
  data_out <= data_out_r;
  we_out   <= we_out_r;

  -- Unused?? 08.02.05 
  one_p_out <= one_p_in;                -- ???

  
  -- COMB PROC
  -- Define next state
  Define_next_state : process ( addr_in,
                                --data_in,comm_in,
                                we_in, full_in,
                               addr_r, state_r)
  begin  -- process Define_next_state
    case state_r is

      when idle_c =>
        if we_in = '0' then
          next_state <= idle_c;
        else
          if addr_in = addr_r then
            next_state <= wr_d_c;
          else
            next_state <= wr_a_c;
          end if;
        end if;

      when wr_a_c =>
        if full_in = '0' then
          next_state <= wr_d_c;
        else
          next_state <= wr_a_c;
        end if;

      when wr_d_c =>
        if full_in = '0' then
          if we_in = '0' then
            next_state <= idle_c;
          else
            if addr_in = addr_r then
              next_state <= wr_d_c;
            else
              next_state <= wr_a_c;
            end if;
          end if;
        else
          if we_in = '0' then
            next_state <= wr_d_c;
          else
            if addr_in = addr_r then
              next_state <= wr_d_f1_c;
            else
              next_state <= wr_d_f2_c;
            end if;
          end if;
        end if;


      when wr_d_f1_c =>
        if full_in = '0' then
          next_state <= wr_d_c;
        else
          next_state <= wr_d_f1_c;
        end if;

      when wr_d_f2_c =>
        if full_in = '0' then
          next_state <= wr_a_c;
        else
          next_state <= wr_d_f2_c;
        end if;

        
      when others =>
        next_state <= idle_c;
        assert false report "Illegal state in addr_data_mux_write" severity WARNING;

    end case;                           -- state_r
    
  end process Define_next_state;

  
  -- SEQ PROC
  -- Change state
  change_state: process (clk, rst_n)
  begin  -- process change_state
    if rst_n = '0' then                 -- asynchronous reset (active low)
      state_r <= 0;
    elsif clk'event and clk = '1' then  -- rising clock edge
      state_r <= next_state;
    end if;
  end process change_state;



  -- SEQ PROC
  -- Define output
  Define_output : process (clk, rst_n)
  begin  -- process Define_output
    if rst_n = '0' then                 -- asynchronous reset (active low)
      full_out_r <= '0';
      av_out_r   <= '0';
      data_out_r <= (others => '0');    -- 'Z');
      comm_out_r <= "000";
      we_out_r   <= '0';

      addr_r <= (others => '1'); -- 'Z');
      comm_r <= (others => '0');
      data_r <= (others => '0'); -- 'Z');

    elsif clk'event and clk = '1' then  -- rising clock edge

      -- Registers keep their values by default
      full_out_r <= full_out_r;
      av_out_r   <= av_out_r;
      data_out_r <= data_out_r;
      comm_out_r <= comm_out_r;
      we_out_r   <= we_out_r;

      addr_r <= addr_r;
      comm_r <= comm_r;
      data_r <= DAta_r;


      -- Always write when not in IDLE state
      if next_state = idle_c then
        we_out_r <= '0';
      else
        we_out_r <= '1';
      end if;

      -- adrresses are awriten only in state wr_a_c
      if next_state = wr_a_c then
        av_out_r <= '1';
      else
        av_out_r <= '0';
      end if;
 
      
      -- Define register values
      case state_r is
        when idle_c                 =>
          if next_state = idle_c then
            full_out_r <= '0';
            data_out_r <= (others => '0'); -- 'Z');
            comm_out_r <= (others => '0');
          elsif next_state = wr_d_c then
            full_out_r <= '0';
            data_out_r <= data_in;
            comm_out_r <= comm_in;
          else
            --next_state <= wr_a_c;
            full_out_r <= '1';
            data_out_r <= addr_in;
            comm_out_r <= comm_in;
            addr_r     <= addr_in;
            data_r     <= data_in;
            comm_r     <= comm_in;
          end if;

        when wr_a_c                   =>
          if next_state = wr_d_c then
            full_out_r <= '0';
            data_out_r <= data_r;
            comm_out_r <= comm_r;
            data_r     <= (others => '0'); -- 'Z');
          else
            -- next_state <= wr_a_c;
            full_out_r <= '1';
            data_out_r <= data_out_r;
            comm_out_r <= comm_out_r;
          end if;

        when wr_d_c                     =>
          if next_state = wr_d_c then
            if we_in = '0' then
              full_out_r <= '0';
              data_out_r <= data_out_r;
              comm_out_r <= comm_out_r;
            else
              full_out_r <= '0';
              data_out_r <= data_in;
              comm_out_r <= comm_in;
            end if;
            data_r       <= (others => '0'); -- 'Z');
          elsif next_state = wr_a_c then
            full_out_r   <= '1';
            data_out_r   <= addr_in;
            comm_out_r   <= comm_in;
            addr_r       <= addr_in;
            data_r       <= data_in;
            comm_r       <= comm_in;
          elsif next_state = wr_d_f1_c then
            full_out_r   <= '1';
            data_out_r   <= data_out_r;
            comm_out_r   <= comm_out_r;
            data_r       <= data_in;
            comm_r       <= comm_in;    -- 2011-01-19
          elsif next_state = wr_d_f2_c then
            full_out_r   <= '1';
            data_out_r   <= data_out_r;
            comm_out_r   <= comm_out_r;
            addr_r       <= addr_in;
            data_r       <= data_in;
            comm_r       <= comm_in;
          else
            -- next_state = idle_c
            full_out_r   <= '0';
            data_out_r   <= (others => '0'); -- 'Z');
            comm_out_r   <= (others => '0');
            data_r       <= (others => '0'); -- 'Z');

          end if;

          
        when wr_d_f1_c =>
          if next_state = wr_d_c then
            full_out_r <= '0';
            data_out_r <= data_r;
            comm_out_r <= comm_r;
            data_r <=  (others => '0'); -- 'Z');
          else
            -- next_state <= wr_d_f1_c;
            full_out_r <= '1';
            data_out_r <= data_out_r;
            comm_out_r <= comm_out_r;
          end if;

        when wr_d_f2_c =>
          if next_state = wr_a_c then
            full_out_r <= '1';
            data_out_r <= addr_r;
            comm_out_r <= comm_r;
          else
            --next_state <= wr_d_f2_c;
            full_out_r <= '1';
            data_out_r <= data_out_r;
            comm_out_r <= comm_out_r;
         end if;
      end case;
    end if;  -- rst_n/clk
  end process Define_output;

  
end rtl;






-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- File        : addr_data_muxes.vhdl
-- Design
-- Description : Converts separated addr+data signalling into multiplexed addr/data.
--               Two components : one for writing and one for reading fifo.
--               Input : separate addr + data ports
--               Out   : addr + data muxed into one port
--               Write_Mux checks the incoming addr+comm. Same addr+comm is not
--               written to fifo more than once!
--               
-- Author      : Erno Salminen
-- e-mail      : erno.salminen@tut.fi
-- Design      : Do not use term design (noun) when you mean system
-- Project     : huuhaa
-- Date        : 15.01.2003
-- Modified    : 
--entity� addr_data_mux_read kaytetaan lukemaan fifosta osoite ja data rinnakkain ja
-- siirretaan ne perakkain IP:lle
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;





entity addr_data_mux_read is

  generic (
    data_width_g         :     integer := 0;
    addr_width_g         :     integer := 0;
    comm_width_g         :     integer := 0
    );
  port (
    clk              : in  std_logic;
    rst_n            : in  std_logic;

    addr_in  : in  std_logic_vector ( addr_width_g-1 downto 0);
    data_in  : in  std_logic_vector ( data_width_g-1 downto 0);
    comm_in  : in  std_logic_vector ( comm_width_g-1 downto 0);
    one_d_in : in  std_logic;           -- unused ??
    empty_in : in  std_logic;
    re_out   : out std_logic;

    re_in          : in  std_logic;
    data_out       : out std_logic_vector ( data_width_g-1 downto 0);
    comm_out       : out std_logic_vector ( comm_width_g-1 downto 0);
    av_out : out std_logic;
    one_d_out      : out std_logic;     -- unused??
    empty_out      : out std_logic
    );

end addr_data_mux_read;


architecture rtl of addr_data_mux_read is
  signal last_addr_r   : std_logic_vector ( addr_width_g -1 downto 0);
  signal last_comm_r   : std_logic_vector ( comm_width_g -1 downto 0);  --26.03.03

  signal Transferred_r : std_logic_vector ( 1 downto 0);
  -- Transferred_r - siirron tila
  -- 00) Ei ole siirretty viela mitaan
  -- 01) Uusi osoite siirretty
  -- 10) Osoite ja ainakin yksi data siirretty
  -- 11) ?? Laiton tila
  
begin  -- rtl






  --PROC
  -- Herkkyyslista muutettu 26.03.03
  --Assign_outputs : process (re_in, empty_in, last_addr_r, addr_in,
  --                     data_in, Transferred_r, comm_in)
  Assign_outputs : process (re_in, empty_in, last_addr_r, last_comm_r,
                            addr_in, data_in, Transferred_r, comm_in)

  begin  -- process Assign_outputs
    
    if Transferred_r = "00" then
      -- Ei ole viela sirretty mitaan/uutta osoitetta

      re_out <= '0';
      empty_out       <= empty_in;

      if empty_in = '1' then
        -- Ei ole mitaan siirrettavaa        
        data_out       <= (others => '0'); -- X');
        comm_out       <= (others => '0'); -- 'X'); 
        av_out <= '0';

      else
        -- Fifo ei ole tyhja        
        --muutos 26.03.03: if addr_in /= last_addr_r then
        if addr_in /= last_addr_r
          or comm_in /= last_comm_r then
          -- Uusi osoite tai komento fifossa, ohjataan se IP:lle
          data_out       <= addr_in;
          comm_out       <= comm_in;
          av_out <= '1';
        else
          -- Sama osoite kuin viimeksi, siirretaan data suoraan IP:lle
          data_out       <= data_in;
          comm_out       <= comm_in;
          av_out <= '0';
        end if;  --addr_in
      end if;  --empty_in





    elsif Transferred_r = "01" then
      -- Osoite sirretty, luetaan data fifosta sitten kun IP haluaa
      if empty_in = '1' then
        data_out      <= (others => '0');
        comm_out      <= (others => '0');
      else
        data_out      <= data_in;
        comm_out      <= comm_in;
      end if;
      av_out  <= '0';
      re_out <= re_in;
      empty_out       <= empty_in;



      
    elsif Transferred_r = "10" then
      -- Osoite ja ainakin yksi data siirretty

      --muutos 26.03.03: if addr_in /= last_addr_r then
      if addr_in /= last_addr_r
        or comm_in /= last_comm_r then
        -- Uusi osoite tai komento 

        re_out  <= '0';
        empty_out        <= empty_in;   --'1';
        if empty_in = '1' then
          -- Ei ole mitaan siirrettavaakaan
          data_out       <= (others => '0'); --'X');
          comm_out       <= (others => '0'); --'X');
          av_out <= '0';
        else
          data_out       <= addr_in;  
          comm_out       <= comm_in;
          av_out <= '1';        --'0';          
        end if;  --empty

      else
        -- Sama osoite kuin viimeksikin
        re_out  <= re_in;
        empty_out        <= empty_in;
        if empty_in = '1' then
          -- Ei ole mitaan siirrettavaakaan
          data_out       <= (others => '0');  -- 'Z');
          comm_out       <= (others => '0');  -- 'Z');
          av_out <= '0';
        else
          -- Sama osoite kuin viimeksi
          data_out       <= data_in;
          comm_out       <= comm_in;
          av_out <= '0';
        end if;  --empty
      end if;  --addr_in        



    else
      -- ??      
      re_out    <= '0';
      empty_out <= empty_in;
      data_out  <= (others => '0');     -- 'Z'); 
      comm_out  <= (others => '0');     -- 'Z');      
      av_out    <= '0';
    end if;  --Transferred_r

  end process Assign_outputs;



  
  -- PROC
  Store_addr : process (clk, rst_n)
  begin  -- process Store_addr
    if rst_n = '0' then                 -- asynchronous reset (active low)
      last_addr_r          <= (others => '0'); -- 'Z');
      last_comm_r          <= (others => '0'); -- 'Z');  --26.03.03
      Transferred_r <= "00";
      
    elsif clk'event and clk = '1' then  -- rising clock edge

      if Transferred_r = "00" then
        -- Ei ole viela sirretty mitaan

        if empty_in = '0' and re_in = '1' then
          -- Saatiin osoite IP:lle
          Transferred_r <= "01";
          last_addr_r   <= addr_in;
          last_comm_r   <= comm_in;      --26.03.03
        else
          -- Ei ole dataa tai IP ei lue
          Transferred_r <= "00";
          last_addr_r   <= last_addr_r;
          last_comm_r   <= last_comm_r;  --26.03.03
        end if;

        
      elsif Transferred_r = "01" then
        -- Osoite sirretty
        if re_in = '1' then
          -- Saatiin data IP:lle
          Transferred_r <= "10";
        else
          -- IP ei lue
          Transferred_r <= "01";
        end if;
        last_addr_r   <= last_addr_r;
        last_comm_r   <= last_comm_r;  --26.03.03

        
      elsif Transferred_r = "10" then

        -- Osoite ja ainakin yksi data siirretty
        if empty_in = '1' then
          -- ei ole uutta dataa
          Transferred_r <= "10";
          last_addr_r   <= last_addr_r;          
        else
          -- if addr_in /= last_addr_r then
          if addr_in /= last_addr_r or comm_in /= last_comm_r then  --26.03.03

            -- Uusi osoite tai komento
            if re_in = '1' then
              -- Saatiin osoite IP:lle
              Transferred_r <= "10";
              last_addr_r   <= addr_in;
              last_comm_r   <= comm_in;      --26.03.03
            else
              -- IP ei lue viela
              Transferred_r <= "00";
              last_addr_r   <= last_addr_r;
              last_comm_r   <= last_comm_r;  --26.03.03
            end if;
            -- oli
            --Transferred_r <= "00";
            --last_addr_r   <= last_addr_r;  
          else
            -- Sama osoite kuin viimeksi
            Transferred_r   <= "01";
            last_addr_r     <= last_addr_r;
            last_comm_r     <= last_comm_r;  --26.03.03
          end if;  --addr_in
        end if;  --empty_in

      else
        -- ??
        last_addr_r   <= last_addr_r;
      end if;                             --Transferred_r

      
    end if;                             --rst_n
    
  end process Store_addr;
end rtl;
