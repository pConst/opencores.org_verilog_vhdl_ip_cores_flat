--------------------------------------------------------------------------------
-- Company: 
-- Engineer: L�o Germond
--
-- Create Date:   14:28:28 11/04/2009
-- Design Name:   
-- Module Name:   C:/Users/microcon/tb_ALU_simple.vhd
-- Project Name:  microcon
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ALU
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
use work.UNITTEST.all;
use work.ALU_INT.all;
use work.MY_FUNCS.all;

ENTITY tb_ALU_simple IS
END tb_ALU_simple;
 
ARCHITECTURE behavior OF tb_ALU_simple IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU
    PORT(
         data1 : IN  std_logic_vector(15 downto 0);
         data2 : IN  std_logic_vector(15 downto 0);
         op : IN  ALU_OPCODE;
         dataA : OUT  std_logic_vector(15 downto 0);
			overflow: OUT std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal data1 : std_logic_vector(15 downto 0) := (others => '0');
   signal data2 : std_logic_vector(15 downto 0) := (others => '0');
   signal op : ALU_OPCODE;

 	--Outputs
   signal dataA : std_logic_vector(15 downto 0);
	signal overflow: std_logic;
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALU PORT MAP (
          data1 => data1,
          data2 => data2,
          dataA => dataA,
          op => op,
			 overflow => overflow
        );
 

   -- Stimulus process
   stim_proc: process
		
		procedure testAdd(A, B: in integer; argSigne: in std_logic := '-'; delay : in time := 50 ns) is
			variable signe: std_logic;
		begin
			-- Pr�paration des entr�es
			if argSigne = '-' then -- On fixe le signe si ca n'a pas d�ja �t� fait
				if(A < 0 or B < 0) then
					signe := '1';
				else
					signe := '0';
				end if;
			else
				signe := argSigne;
			end if;
			
			if signe = '1' then
				op <= SADD;
				data1 <= std_logic_vector(to_signed(A, 16));
				data2 <= std_logic_vector(to_signed(B, 16));
			else
				op <= UADD;
				data1 <= std_logic_vector(to_unsigned(A, 16));
				data2 <= std_logic_vector(to_unsigned(B, 16));
			end if;
			
			-- D�lai d'attente
			wait for delay;
			
			-- V�rification du r�sultat
			if signe = '1' then -- Op�ration sign�e
				assertOperationResult(to_integer(signed(dataA)), A+B, "signed sum", (A+B > MAX_SIGNED) or (A+B < MIN_SIGNED), overflow);
			else -- Op�ration non sign�e
				assertOperationResult(to_integer(unsigned(dataA)), A+B, "unsigned sum", A+B > MAX_UNSIGNED, overflow);
			end if;
		end procedure;
		
		procedure testSub(A, B: in integer; argSigne: in std_logic := '-'; delay : in time := 50 ns) is
			variable signe: std_logic;
		begin
			-- Pr�paration des entr�es
			-- Fixe le signe
			if argSigne = '-' then -- On fixe le signe si ca n'a pas d�ja �t� fait
				if(A < 0 or B < 0) then
					signe := '1';
				else
					signe := '0';
				end if;
			else
				signe := argSigne;
			end if;
			
			-- Fixe l'op�ration
			if signe = '1' then
				op <= SSUB;
				data1 <= std_logic_vector(to_signed(A, 16));
				data2 <= std_logic_vector(to_signed(B, 16));
			else
				op <= USUB;
				data1 <= std_logic_vector(to_unsigned(A, 16));
				data2 <= std_logic_vector(to_unsigned(B, 16));
			end if;
			
			-- D�lai d'attente pour v�rification
			wait for delay;
			
			-- V�rification du r�sultat
			if signe = '1' then -- Op�ration sign�e
				assertOperationResult(to_integer(signed(dataA)), A-B, "signed subtraction", (A-B > MAX_SIGNED) or (A-B < MIN_SIGNED), overflow);
			else -- Op�ration non sign�e
				assertOperationResult(to_integer(unsigned(dataA)), A-B, "unsigned subtraction", (A-B > MAX_UNSIGNED) or (A-B < 0), overflow);
			end if;
		end procedure;
		
		procedure testShift(A: in std_logic_vector(15 downto 0); argB: in integer; right: in std_logic := '-'; delay : in time := 50 ns) is
			variable direction: std_logic;
			variable B: natural;
		begin
			-- Pr�paration des entr�es
			if right = '-' then -- On fixe le signe si ca n'a pas d�ja �t� fait
				if(argB < 0) then
					direction := '1';
					B := -argB;
				else
					direction := '0';
				end if;
			else
				direction := right;
			end if;
			
			if direction = '1' then
				op <= LSHIFT;
			else
				op <= RSHIFT;
			end if;
			
			data1 <= A;
			data2 <= std_logic_vector(to_unsigned(B, 16));
			
			-- D�lai d'attente
			wait for delay;
			
			-- V�rification du r�sultat
			if direction = '1' then -- A gauche
				assertOperationResult(dataA, A sll B, "left shift", B > 15);
			else -- A droite
				assertOperationResult(dataA, A srl B, "right shift", B > 15);
			end if;
		end procedure;
		
		procedure testBinary(A, B: in std_logic_vector(15 downto 0); delay : in time := 50 ns) is
		begin
			op <= bOR;
			data1 <= A;
			data2 <= B;
			
			-- D�lai d'attente
			wait for delay;
			
			-- V�rification du r�sultat
			assertOperationResult(dataA, A OR B, "boolean OR");
			
			op <= bAND;
			
			-- D�lai d'attente
			wait for delay;
			
			-- V�rification du r�sultat
			assertOperationResult(dataA, A AND B, "boolean AND");
			
			op <= bXOR;
			
			-- D�lai d'attente
			wait for delay;
			
			-- V�rification du r�sultat
			assertOperationResult(dataA, A XOR B, "boolean OR");
			
			op <= bNOT;
			
			-- D�lai d'attente
			wait for delay;
			
			-- V�rification du r�sultat
			assertOperationResult(dataA, NOT A, "boolean NOT");
		end procedure;
   begin	
		
		report "TEST BEGINS";
		
		report "Testing binary ops ...";
		-- Binary ops
		testBinary(x"0000",x"0000");
		testBinary(x"f610",x"00ff");
		testBinary(x"ffff",x"aaaa");
		testBinary(x"f00f",x"aa00");
		testBinary(x"eeee",x"1111");
		
		report "Testing shiftings ...";
		-- LSHIFT
		testShift(x"fafb", 1);
		testShift(x"fafb", 2);
		testShift(x"fafb", 3);
		testShift(x"fafb", 0);
		testShift(x"fafb", 4);
		testShift(x"fafb", 15);
		testShift(x"fafb", 1);
		
		-- RSHIFT
		testShift(x"fafb", -1);
		testShift(x"fafb", -2);
		testShift(x"fafb", -3);
		testShift(x"fafb", 0, '1');
		testShift(x"fafb", -4);
		testShift(x"fafb", -15);
		testShift(x"fafb", -1);
		
		report "Testing additions ...";
		-- Additions non sign�es sans overflow
		testAdd(10,15);
		testAdd(5,0);
		testAdd(2,30);
		testAdd(MAX_UNSIGNED, 0);
		testAdd(MAX_UNSIGNED-15, 15);
		
		-- Additions sign�es sans overflow
		testAdd(0,-10);
		testAdd(10,-10);
		testAdd(11,-10);
		testAdd(MAX_SIGNED, MIN_SIGNED);
		
		-- Additions avec overflow
		testAdd(MAX_UNSIGNED,1);
		testAdd(MAX_UNSIGNED,MAX_UNSIGNED);
		
		testAdd(MAX_SIGNED,MAX_SIGNED, '1');
		testAdd(MIN_SIGNED, -1);
		testAdd(MIN_SIGNED,MIN_SIGNED);
		
		
		report "Testing subtractions ...";
		-- Substractions non sign�es sans overflow
		testSub(10,9);
		testSub(5,0);
		testSub(2,30);
		testSub(MAX_UNSIGNED, 0);
		testSub(MAX_UNSIGNED-15, 15);
		
		-- Substractions sign�es sans overflow
		testSub(0,-10);
		testSub(10,-10);
		testSub(11,-10);
		testSub(MAX_SIGNED, MIN_SIGNED);
		testSub(MIN_SIGNED, -1);
		
		-- Substractions avec overflow
		testSub(MAX_UNSIGNED,1);
		testSub(MAX_UNSIGNED,MAX_UNSIGNED);
		
		testSub(MAX_SIGNED,MAX_SIGNED, '1');
		testSub(MIN_SIGNED,MIN_SIGNED);
		
		
		report "END OF TEST";
      wait;
   end process;

END;
