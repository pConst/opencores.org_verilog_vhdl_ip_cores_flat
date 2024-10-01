-- SDHC-SC-Core
-- Secure Digital High Capacity Self Configuring Core
-- 
-- (C) Copyright 2010, Rainer Kastl
-- All rights reserved.
-- 
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
--     * Redistributions of source code must retain the above copyright
--       notice, this list of conditions and the following disclaimer.
--     * Redistributions in binary form must reproduce the above copyright
--       notice, this list of conditions and the following disclaimer in the
--       documentation and/or other materials provided with the distribution.
--     * Neither the name of the <organization> nor the
--       names of its contributors may be used to endorse or promote products
--       derived from this software without specific prior written permission.
-- 
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS  "AS IS" AND
-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
-- DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
-- ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-- (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-- 
-- File        : Global-p.vhdl
-- Owner       : Rainer Kastl
-- Description : Global constants and functions
-- Links       : 
-- 

library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

package Global is

    constant cActivated    :  std_ulogic := '1';
    constant cInactivated  :  std_ulogic := '0';
    constant cnActivated   :  std_ulogic := '0';
    constant cnInactivated :  std_ulogic := '1';

	subtype aLedBank is std_ulogic_vector(7 downto 0);

	function LogDualis(cNumber : natural) return natural;


	-- Edge detector
	constant cDetectRisingEdge  : natural := 0;
	constant cDetectFallingEdge : natural := 1;
	constant cDetectAnyEdge     : natural := 2;

end package Global;

package body Global is

	function LogDualis(cNumber : natural) return natural is
		variable vClimbUp : natural;
		variable vResult  : natural;
	begin
		vClimbUp := 1;
		vResult := 0;
		while vClimbUp < cNumber loop
			vClimbUp := vClimbUp * 2;
			vResult  := vResult+1;
		end loop;
		return vResult;
	end function LogDualis;

end package body Global;

