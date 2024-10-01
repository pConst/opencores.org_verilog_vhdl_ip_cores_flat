----------------------------------------------------------------------
----                                                              ----
----  abPermut_synth.vhd                                          ----
----                                                              ----
----  This file is part of the turbo decoder IP core project      ----
----  http://www.opencores.org/projects/turbocodes/               ----
----                                                              ----
----  Author(s):                                                  ----
----      - David Brochart(dbrochart@opencores.org)               ----
----                                                              ----
----  All additional information is available in the README.txt   ----
----  file.                                                       ----
----                                                              ----
----------------------------------------------------------------------
----                                                              ----
---- Copyright (C) 2005 Authors                                   ----
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
---- from http://www.opencores.org/lgpl.shtml                     ----
----                                                              ----
----------------------------------------------------------------------



architecture synth of abPermut is
begin
    flipflop_g0 : if flip = 0 generate
        process (flipflop, a, b)
        begin
            if flipflop = '0' then
                abPerm(1) <= a;
                abPerm(0) <= b;
            else
                abPerm(1) <= b;
                abPerm(0) <= a;
            end if;
        end process;
    end generate;
    flipflop_g1 : if flip = 1 generate
        process (flipflop, a, b)
        begin
            if flipflop = '1' then
                abPerm(1) <= a;
                abPerm(0) <= b;
            else
                abPerm(1) <= b;
                abPerm(0) <= a;
            end if;
        end process;
    end generate;
end;
