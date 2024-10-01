----==============================================================----
----                                                              ----
---- Filename: reg_dw.vhd                                         ----
---- Module description: DW-bit D-type register with synchronous  ----
----                     reset and load enable                    ----          
----                                                              ----
---- Author: Nikolaos Kavvadias                                   ----
----         nkavv@skiathos.physics.auth.gr                       ----
----                                                              ---- 
----                                                              ----
---- Downloaded from: http://wwww.opencores.org/cores/hwlu        ----
----                                                              ----
---- To Do:                                                       ----
----         Probably remains as current                          ---- 
----         (to promote as stable version)                       ----
----                                                              ----
---- Author: Nikolaos Kavvadias                                   ----
----         nkavv@skiathos.physics.auth.gr                       ----
----                                                              ----
----==============================================================----
----                                                              ----
---- Copyright (C) 2004 Nikolaos Kavvadias                        ----
----                    nick-kavi.8m.com                          ----
----                    nkavv@skiathos.physics.auth.gr            ----
----                    nick_ka_vi@hotmail.com                    ----
----                                                              ----
---- This source file may be used and distributed without         ----
---- restriction provided that this copyright statement is not    ----
---- removed from the file and that any derivative work contains  ----
---- the original copyright notice and the associated disclaimer. ----
----                                                              ----
---- This source file is free software; you can redistribute it   ----
---- and/or modify it under the terms of the GNU Lesser General   ----
---- Public License as published by the Free Software Foundation; ----
---- either version 2.1 of the License, or (at your option) any   ----
---- later version.                                               ----
----                                                              ----
---- This source is distributed in the hope that it will be       ----
---- useful, but WITHOUT ANY WARRANTY; without even the implied   ----
---- warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ----
---- PURPOSE. See the GNU Lesser General Public License for more  ----
---- details.                                                     ----
----                                                              ----
---- You should have received a copy of the GNU Lesser General    ----
---- Public License along with this source; if not, download it   ----
---- from <http://www.opencores.org/lgpl.shtml>                   ----
----                                                              ----
----==============================================================----
--
-- CVS Revision History
--    

library IEEE;
use IEEE.std_logic_1164.all;


entity reg_dw is	 
  generic (
    DW : integer := 8
  );
  port (			  
    clk   : in std_logic;
    reset : in std_logic;
    load  : in std_logic;
    d     : in std_logic_vector(DW-1 downto 0);
    q     : out std_logic_vector(DW-1 downto 0)
  );
end reg_dw;
       
       
architecture rtl of reg_dw is
begin                              
  process (clk, reset, load, d)
  begin					
    if (clk'event and clk = '1') then
	  -- synchronous reset	
	  if (reset = '1') then
	    q <= (others => '0');
	  elsif (load = '1') then
		q <= d;
      end if; -- reset, load
	end if; -- clk
  end process;
  --    
end rtl;	
