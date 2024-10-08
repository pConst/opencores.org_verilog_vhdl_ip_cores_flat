-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--                                                             --
-- Copyright (C) 2013 Stefano Tonello                          --
--                                                             --
-- This source file may be used and distributed without        --
-- restriction provided that this copyright statement is not   --
-- removed from the file and that any derivative work contains --
-- the original copyright notice and the associated disclaimer.--
--                                                             --
-- THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY         --
-- EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   --
-- TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   --
-- FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR      --
-- OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,         --
-- INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES    --
-- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE   --
-- GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR        --
-- BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  --
-- LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT  --
-- (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT  --
-- OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         --
-- POSSIBILITY OF SUCH DAMAGE.                                 --
--                                                             --
-----------------------------------------------------------------

---------------------------------------------------------------
-- G.729a Codec Self-Test Input data ROM
---------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

library work;
use work.G729A_CODEC_ST_ROM_PKG.all;

entity G729A_ASIP_STI_ROM is
  generic(
    WCOUNT : natural := 425;
    DATA_WIDTH : natural := 16;
    ADDR_WIDTH : natural := 9
  );
  port(
    CLK_i : in std_logic;
    A_i : in unsigned(ADDR_WIDTH-1 downto 0);
    Q_o : out std_logic_vector(DATA_WIDTH-1 downto 0)
  );
end G729A_ASIP_STI_ROM;

architecture ARC of G729A_ASIP_STI_ROM is

  constant ROM_MEM : ROM_DATA_T := STI_ROM_INIT_DATA;

begin

  process(CLK_i)
  begin
    if(CLK_i = '1' and CLK_i'event) then
      Q_o <= ROM_MEM(to_integer(A_i));
    end if;
  end process;

end ARC;

---------------------------------------------------------------
-- G.729a Codec Self-Test Output data ROM
---------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

library work;
use work.G729A_CODEC_ST_ROM_PKG.all;

entity G729A_ASIP_STO_ROM is
  generic(
    WCOUNT : natural := 425;
    DATA_WIDTH : natural := 16;
    ADDR_WIDTH : natural := 9
  );
  port(
    CLK_i : in std_logic;
    A_i : in unsigned(ADDR_WIDTH-1 downto 0);
    Q_o : out std_logic_vector(DATA_WIDTH-1 downto 0)
  );
end G729A_ASIP_STO_ROM;

architecture ARC of G729A_ASIP_STO_ROM is

  constant ROM_MEM : ROM_DATA_T := STO_ROM_INIT_DATA;

begin

  process(CLK_i)
  begin
    if(CLK_i = '1' and CLK_i'event) then
      Q_o <= ROM_MEM(to_integer(A_i));
    end if;
  end process;

end ARC;
