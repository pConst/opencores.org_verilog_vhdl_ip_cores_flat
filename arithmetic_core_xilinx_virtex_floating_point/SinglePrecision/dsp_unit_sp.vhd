----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:48:23 02/08/2013 
-- Design Name: 
-- Module Name:    dsp_unit_sp - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity dsp_unit_sp is
	port (clk, rst : in std_logic;
			a : in std_logic_vector(33 downto 0);
			b : in std_logic_vector(23 downto 0);
			c:  in std_logic_vector(71 downto 0);
			comp : in std_logic;  -- 1 a*b > c; 0 a*b <= c
			sub : in std_logic;  --
			p1: out std_logic_vector (47 downto 0);
			p2: out std_logic_vector (48 downto 0);
			pattern_detect : out std_logic);
end dsp_unit_sp;

architecture Behavioral of dsp_unit_sp is

	signal one : std_logic;
	signal zero : std_logic;
	
	signal opmode : std_logic_vector (6 downto 0);
	signal alumode : std_logic_vector (3 downto 0); 
	signal carry_in : std_logic;
	
	signal a_input_dsp1, a_input_dsp2 : std_logic_vector (17 downto 0);
	signal b_input_dsp1, b_input_dsp2 : std_logic_vector (29 downto 0);
	signal c_input_dsp1, c_input_dsp2 : std_logic_vector (47 downto 0);
	signal p_output_dsp1, p_output_dsp2 : std_logic_vector (47 downto 0);
	signal pattern_detect1, pattern_detect2 : std_logic;
	signal ovf : std_logic_vector(0 downto 0);

begin
	
	one <= '1';
	zero <= '0';
	
	opmode <= 	"0110101" ;--"0000101" ;

	alumode <= 	"0000" when sub = '0' else
					"0011" when (sub = '1' and comp = '0') else
					"0001";
	
		
					
	carry_in <= '1' when (sub = '1' and comp = '1') else
					'0';

	b_input_dsp1 <= (5 downto 0 =>'0') & b;
	b_input_dsp2 <= (5 downto 0 =>'0') & b;
	
	a_input_dsp1 <= "0" & a(33 downto 17);
	a_input_dsp2 <= "0" & a(16 downto 0);
	
	--prof
	--c_input_dsp1 <= "0" & c(46 downto 0);
	--c_input_dsp2 <= c(71 downto 47) & (22 downto 0 => '0');
	
	--eu 1
	--c_input_dsp1 <= c(65 downto 46) & (27 downto 0 => '0');
	--c_input_dsp2 <= "000" & c(45 downto 1);

	--eu 2
	c_input_dsp1 <= (7 downto 0 => '0') & c(57 downto 46) & (27 downto 0 => '0'); --aliniere corecta!!!
	c_input_dsp2 <= "000" & c(45 downto 1);
	
	DSP48E_inst1 : DSP48E
			generic map (
				ACASCREG => 1,       -- Number of pipeline registers between 
											-- A/ACIN input and ACOUT output, 0, 1, or 2
				ALUMODEREG => 1,     -- Number of pipeline registers on ALUMODE input, 0 or 1
				AREG => 1,           -- Number of pipeline registers on the A input, 0, 1 or 2
				AUTORESET_PATTERN_DETECT => FALSE, -- Auto-reset upon pattern detect, TRUE or FALSE
				AUTORESET_PATTERN_DETECT_OPTINV => "MATCH", -- Reset if "MATCH" or "NOMATCH" 
				A_INPUT => "DIRECT", -- Selects A input used, "DIRECT" (A port) or "CASCADE" (ACIN port)
				BCASCREG => 1,       -- Number of pipeline registers between B/BCIN input and BCOUT output, 0, 1, or 2
				BREG => 1,           -- Number of pipeline registers on the B input, 0, 1 or 2
				B_INPUT => "DIRECT", -- Selects B input used, "DIRECT" (B port) or "CASCADE" (BCIN port)
				CARRYINREG => 1,     -- Number of pipeline registers for the CARRYIN input, 0 or 1
				CARRYINSELREG => 1,  -- Number of pipeline registers for the CARRYINSEL input, 0 or 1
				CREG => 1,           -- Number of pipeline registers on the C input, 0 or 1
				MASK => X"3FFFFFFFFFFF", -- 48-bit Mask value for pattern detect
				MREG => 1,           -- Number of multiplier pipeline registers, 0 or 1
				MULTCARRYINREG => 1, -- Number of pipeline registers for multiplier carry in bit, 0 or 1
				OPMODEREG => 1,      -- Number of pipeline registers on OPMODE input, 0 or 1
				PATTERN => X"000000000000", -- 48-bit Pattern match for pattern detect
				PREG => 1,           -- Number of pipeline registers on the P output, 0 or 1
				SIM_MODE => "SAFE", -- Simulation: "SAFE" vs "FAST", see "Synthesis and Simulation
										  -- Design Guide" for details
				SEL_MASK => "MASK",  -- Select mask value between the "MASK" value or the value on the "C" port
				SEL_PATTERN => "PATTERN", -- Select pattern value between the "PATTERN" value or the value on the "C" port
				SEL_ROUNDING_MASK => "SEL_MASK", -- "SEL_MASK", "MODE1", "MODE2" 
				USE_MULT => "MULT_S", -- Select multiplier usage, "MULT" (MREG => 0), 
											 -- "MULT_S" (MREG => 1), "NONE" (not using multiplier)
				USE_PATTERN_DETECT => "NO_PATDET", -- Enable pattern detect, "PATDET", "NO_PATDET" 
				USE_SIMD => "ONE48") -- SIMD selection, "ONE48", "TWO24", "FOUR12" 
			port map (
				ACOUT => open,  -- 30-bit A port cascade output 
				BCOUT => open,  -- 18-bit B port cascade output
				CARRYCASCOUT => open, -- 1-bit cascade carry output
				CARRYOUT => open, -- 4-bit carry output
				MULTSIGNOUT => open, -- 1-bit multiplier sign cascade output
				OVERFLOW => open, -- 1-bit overflow in add/acc output
				P => p_output_dsp1,          -- 48-bit output
				PATTERNBDETECT => open, -- 1-bit active high pattern bar detect output
				PATTERNDETECT => pattern_detect1, --  1-bit active high pattern detect output
				PCOUT => open,  -- 48-bit cascade output
				UNDERFLOW => open, -- 1-bit active high underflow in add/acc output
				A => b_input_dsp1,          -- 30-bit A data input
				ACIN => (others=>'0'),    -- 30-bit A cascade data input
				ALUMODE => alumode, -- 4-bit ALU control input
				B => a_input_dsp1,          -- 18-bit B data input
				BCIN => (others=>'0'),    -- 18-bit B cascade input
				C => c_input_dsp1,          -- 48-bit C data input
				CARRYCASCIN => '0', -- 1-bit cascade carry input
				CARRYIN => carry_in, -- 1-bit carry input signal
				CARRYINSEL => "000", -- 3-bit carry select input
				CEA1 => one,      -- 1-bit active high clock enable input for 1st stage A registers
				CEA2 => one,      -- 1-bit active high clock enable input for 2nd stage A registers
				CEALUMODE => one, -- 1-bit active high clock enable input for ALUMODE registers
				CEB1 => one,      -- 1-bit active high clock enable input for 1st stage B registers
				CEB2 => one,      -- 1-bit active high clock enable input for 2nd stage B registers
				CEC => one,      -- 1-bit active high clock enable input for C registers
				CECARRYIN => one, -- 1-bit active high clock enable input for CARRYIN register
				CECTRL => one, -- 1-bit active high clock enable input for OPMODE and carry registers
				CEM => one,       -- 1-bit active high clock enable input for multiplier registers
				CEMULTCARRYIN => one,       -- 1-bit active high clock enable for multiplier carry in register
				CEP => one,       -- 1-bit active high clock enable input for P registers
				CLK => clk,       -- Clock input
				MULTSIGNIN => zero, -- 1-bit multiplier sign input
				OPMODE => opmode, -- 7-bit operation mode input
				PCIN => (others=>'0'),     -- 48-bit P cascade input 
				RSTA => rst,     -- 1-bit reset input for A pipeline registers
				RSTALLCARRYIN => rst, -- 1-bit reset input for carry pipeline registers
				RSTALUMODE => rst, -- 1-bit reset input for ALUMODE pipeline registers
				RSTB => rst,     -- 1-bit reset input for B pipeline registers
				RSTC => rst,     -- 1-bit reset input for C pipeline registers
				RSTCTRL => rst, -- 1-bit reset input for OPMODE pipeline registers
				RSTM => rst, -- 1-bit reset input for multiplier registers
				RSTP => rst  -- 1-bit reset input for P pipeline registers
		);


	DSP48E_inst2 : DSP48E
			generic map (
				ACASCREG => 1,       -- Number of pipeline registers between 
											-- A/ACIN input and ACOUT output, 0, 1, or 2
				ALUMODEREG => 1,     -- Number of pipeline registers on ALUMODE input, 0 or 1
				AREG => 1,           -- Number of pipeline registers on the A input, 0, 1 or 2
				AUTORESET_PATTERN_DETECT => FALSE, -- Auto-reset upon pattern detect, TRUE or FALSE
				AUTORESET_PATTERN_DETECT_OPTINV => "MATCH", -- Reset if "MATCH" or "NOMATCH" 
				A_INPUT => "DIRECT", -- Selects A input used, "DIRECT" (A port) or "CASCADE" (ACIN port)
				BCASCREG => 1,       -- Number of pipeline registers between B/BCIN input and BCOUT output, 0, 1, or 2
				BREG => 1,           -- Number of pipeline registers on the B input, 0, 1 or 2
				B_INPUT => "DIRECT", -- Selects B input used, "DIRECT" (B port) or "CASCADE" (BCIN port)
				CARRYINREG => 1,     -- Number of pipeline registers for the CARRYIN input, 0 or 1
				CARRYINSELREG => 1,  -- Number of pipeline registers for the CARRYINSEL input, 0 or 1
				CREG => 1,           -- Number of pipeline registers on the C input, 0 or 1
				MASK => X"3FFFFFFFFFFF", -- 48-bit Mask value for pattern detect
				MREG => 1,           -- Number of multiplier pipeline registers, 0 or 1
				MULTCARRYINREG => 1, -- Number of pipeline registers for multiplier carry in bit, 0 or 1
				OPMODEREG => 1,      -- Number of pipeline registers on OPMODE input, 0 or 1
				PATTERN => X"000000000000", -- 48-bit Pattern match for pattern detect
				PREG => 1,           -- Number of pipeline registers on the P output, 0 or 1
				SIM_MODE => "SAFE", -- Simulation: "SAFE" vs "FAST", see "Synthesis and Simulation
										  -- Design Guide" for details
				SEL_MASK => "MASK",  -- Select mask value between the "MASK" value or the value on the "C" port
				SEL_PATTERN => "PATTERN", -- Select pattern value between the "PATTERN" value or the value on the "C" port
				SEL_ROUNDING_MASK => "SEL_MASK", -- "SEL_MASK", "MODE1", "MODE2" 
				USE_MULT => "MULT_S", -- Select multiplier usage, "MULT" (MREG => 0), 
											 -- "MULT_S" (MREG => 1), "NONE" (not using multiplier)
				USE_PATTERN_DETECT => "NO_PATDET", -- Enable pattern detect, "PATDET", "NO_PATDET" 
				USE_SIMD => "ONE48") -- SIMD selection, "ONE48", "TWO24", "FOUR12" 
			port map (
				ACOUT => open,  -- 30-bit A port cascade output 
				BCOUT => open,  -- 18-bit B port cascade output
				CARRYCASCOUT => open, -- 1-bit cascade carry output
				CARRYOUT => open, -- 4-bit carry output
				MULTSIGNOUT => open, -- 1-bit multiplier sign cascade output
				OVERFLOW => ovf(0), -- 1-bit overflow in add/acc output
				P => p_output_dsp2,          -- 48-bit output
				PATTERNBDETECT => open, -- 1-bit active high pattern bar detect output
				PATTERNDETECT => pattern_detect2, --  1-bit active high pattern detect output
				PCOUT => open,  -- 48-bit cascade output
				UNDERFLOW => open, -- 1-bit active high underflow in add/acc output
				A => b_input_dsp2,          -- 30-bit A data input
				ACIN => (others=>'0'),    -- 30-bit A cascade data input
				ALUMODE => alumode, -- 4-bit ALU control input
				B => a_input_dsp2,          -- 18-bit B data input
				BCIN => (others=>'0'),    -- 18-bit B cascade input
				C => c_input_dsp2,          -- 48-bit C data input
				CARRYCASCIN => '0', -- 1-bit cascade carry input
				CARRYIN => carry_in, -- 1-bit carry input signal
				CARRYINSEL => "000", -- 3-bit carry select input
				CEA1 => one,      -- 1-bit active high clock enable input for 1st stage A registers
				CEA2 => one,      -- 1-bit active high clock enable input for 2nd stage A registers
				CEALUMODE => one, -- 1-bit active high clock enable input for ALUMODE registers
				CEB1 => one,      -- 1-bit active high clock enable input for 1st stage B registers
				CEB2 => one,      -- 1-bit active high clock enable input for 2nd stage B registers
				CEC => one,      -- 1-bit active high clock enable input for C registers
				CECARRYIN => one, -- 1-bit active high clock enable input for CARRYIN register
				CECTRL => one, -- 1-bit active high clock enable input for OPMODE and carry registers
				CEM => one,       -- 1-bit active high clock enable input for multiplier registers
				CEMULTCARRYIN => one,       -- 1-bit active high clock enable for multiplier carry in register
				CEP => one,       -- 1-bit active high clock enable input for P registers
				CLK => clk,       -- Clock input
				MULTSIGNIN => zero, -- 1-bit multiplier sign input
				OPMODE => opmode, -- 7-bit operation mode input
				PCIN => (others=>'0'),     -- 48-bit P cascade input 
				RSTA => rst,     -- 1-bit reset input for A pipeline registers
				RSTALLCARRYIN => rst, -- 1-bit reset input for carry pipeline registers
				RSTALUMODE => rst, -- 1-bit reset input for ALUMODE pipeline registers
				RSTB => rst,     -- 1-bit reset input for B pipeline registers
				RSTC => rst,     -- 1-bit reset input for C pipeline registers
				RSTCTRL => rst, -- 1-bit reset input for OPMODE pipeline registers
				RSTM => rst, -- 1-bit reset input for multiplier registers
				RSTP => rst  -- 1-bit reset input for P pipeline registers
		);

	p1 <= p_output_dsp1;
	p2 <= ovf & p_output_dsp2;
	
	pattern_detect <= pattern_detect1 and pattern_detect2;

end Behavioral;

