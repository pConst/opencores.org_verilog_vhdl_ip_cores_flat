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
-- G.729a ASIP Load Unit
---------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.G729A_ASIP_PKG.all;
use work.G729A_ASIP_OP_PKG.all;

entity G729A_ASIP_LU is
  port(
    IV_i : in std_logic;
    LS_OP_i : in LS_OP_T;
    OPA_i : in LDWORD_T;
    OPB_i : in LDWORD_T;

    DRE_o : out std_logic;
    DADR_o : out unsigned(ALEN-1 downto 0)
  );
end G729A_ASIP_LU;

architecture ARC of G729A_ASIP_LU is

  function to_unsigned(S : signed) return unsigned is
    variable U : unsigned(S'high downto S'low);
  begin
    for i in S'low to S'high loop
      U(i) := S(i);
    end loop;
    return(U);
  end function;

  signal DRE,DWE : std_logic;
  signal DADR : unsigned(ALEN-1 downto 0);
  signal DDATO : std_logic_vector(SDLEN-1 downto 0);

begin

  process(OPA_i,OPB_i)
    variable OPA_LO,OPB_LO : unsigned(SDLEN-1 downto 0);
    variable TMP : unsigned(SDLEN downto 0);
  begin
    -- WARNING: address is always an unsigned value

    -- get ID_OPA_q lower half and convert it to unsigned
    OPA_LO := to_unsigned(OPA_i(SDLEN-1 downto 0));
    -- get ID_OPB_q lower half and convert it to unsigned
    OPB_LO := to_unsigned(OPB_i(SDLEN-1 downto 0));

    -- calculate effective address (extra bit prevents overflow)
    TMP := ('0' & OPA_LO) + ('0' & OPB_LO);

    DADR <= TMP(ALEN-1 downto 0);

  end process;

  DADR_o <= DADR;

  DRE <= IV_i when (LS_OP_i = LS_LD) else '0';

  -- external memory read-enable flag (debug purpose only)
  DRE_o <= DRE;

end ARC;
