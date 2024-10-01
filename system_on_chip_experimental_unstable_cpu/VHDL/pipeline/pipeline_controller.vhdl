-- Copyright 2015, J�rgen Defurne
--
-- This file is part of the Experimental Unstable CPU System.
--
-- The Experimental Unstable CPU System Is free software: you can redistribute
-- it and/or modify it under the terms of the GNU Lesser General Public License
-- as published by the Free Software Foundation, either version 3 of the
-- License, or (at your option) any later version.
--
-- The Experimental Unstable CPU System is distributed in the hope that it will
-- be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser
-- General Public License for more details.
--
-- You should have received a copy of the GNU Lesser General Public License
-- along with Experimental Unstable CPU System. If not, see
-- http://www.gnu.org/licenses/lgpl.txt.


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY pipeline_controller IS
  
  PORT (
    CLK  : IN  STD_LOGIC;
    RST  : IN  STD_LOGIC;
    SUM  : OUT STD_LOGIC;
    EN   : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    FULL : OUT STD_LOGIC;
    PULL : IN  STD_LOGIC);

END ENTITY pipeline_controller;
