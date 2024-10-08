
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;


entity table is
		generic (
				ADDR_WIDTH :integer := 10);
	port (
						SIGNAL	clk			: 	IN std_logic;
						SIGNAL	reset 		: 	IN STD_LOGIC;
						SIGNAL	in_mac		: 	IN std_logic_VECTOR(47 downto 0);
						SIGNAL	in_weight	: 	IN std_logic_VECTOR(7 downto 0);
						SIGNAL	in_port		: 	IN std_logic_VECTOR(7 downto 0);
						SIGNAL	in_wr		: 	IN std_logic;	
						SIGNAL	in_rd		: 	IN std_logic;
						SIGNAL	in_key : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
--						SIGNAL	add 		: 	out std_logic_vector(11 downto 0);
--						SIGNAL	entry 		: 	OUT std_logic_VECTOR( 63 downto 0); 	
--						SIGNAL	rdy 		: 	out std_logic;
--						SIGNAL	check 		: 	out std_logic;
						SIGNAL	out_mac		: 	OUT std_logic_VECTOR(47 downto 0);
						SIGNAL	out_port	: 	OUT std_logic_VECTOR(7 downto 0);
						SIGNAL	out_rd_rdy	: 	OUT std_logic	
	);
end table ;

architecture Behavioral of table is
	TYPE state_type IS(IDLE, START, LATCH_MAC_LOOKUP, CHECK_MAC_MATCH, UPDATE_ENTRY, ADD_ENTRY);
	SIGNAL state, state_next : state_type;

-------COMPONENET SMALL FIFO
	COMPONENT  small_fifo IS
		GENERIC(WIDTH 				:	INTEGER := 64;
				MAX_DEPTH_BITS 		:	INTEGER := 5);
		PORT(
					 SIGNAL din 		:	IN STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);--input 
					 SIGNAL wr_en 		:	IN STD_LOGIC;--input          
					 SIGNAL rd_en 		:	IN STD_LOGIC;--input          
					 SIGNAL dout 		:	OUT STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);--output 
					 SIGNAL full 		:	OUT STD_LOGIC;--output         
					 SIGNAL nearly_full :	OUT STD_LOGIC;--output         
					 SIGNAL empty 		:	OUT STD_LOGIC;--output         
					 SIGNAL reset 		:	IN STD_LOGIC;
					 SIGNAL clk   		:	IN STD_LOGIC

		);
	END COMPONENT;
-------COMPONENET SMALL FIFO
		COMPONENT  mac_ram_table is
		generic (
				ADDR_WIDTH :integer := ADDR_WIDTH
				);
			port (
					SIGNAL		clk: IN std_logic;
					SIGNAL		reset : IN STD_LOGIC;
					SIGNAL		in_mac_no_prt: IN std_logic_VECTOR(63 downto 0);--MAC NUMBER internal port
					SIGNAL		in_address   : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
					SIGNAL		in_wr: IN std_logic;
					SIGNAL		in_check : IN STD_LOGIC;
					SIGNAL		match_address : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
					SIGNAL		match:  OUT STD_LOGIC;
					SIGNAL		unmatch:  OUT STD_LOGIC;
					SIGNAL		in_rd : IN STD_LOGIC;
					SIGNAL		in_key : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
					SIGNAL		last_address : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
					SIGNAL		out_rd_rdy : OUT std_logic;
					SIGNAL		out_port : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
					SIGNAL		out_mac : OUT STD_LOGIC_VECTOR(47 DOWNTO 0)
			);
		end COMPONENT mac_ram_table;
------------------------------------
	
	SIGNAL 		ram_in_mac			:	std_logic_VECTOR(63 downto 0);
	SIGNAL		ram_in_address 		:	STD_LOGIC_VECTOR(ADDR_WIDTH-1 DOWNTO 0);
	SIGNAL		ram_in_wr			:	std_logic;
	SIGNAL		ram_out_mac 		:	STD_LOGIC_VECTOR(47 DOWNTO 0);	
	SIGNAL		ram_in_rd 			: 	STD_LOGIC;
	SIGNAL		ram_in_check 		: 	STD_LOGIC;
	SIGNAL		ram_out_rd_rdy 		:	STD_LOGIC;
	SIGNAL 		ram_match_address 	:  	STD_LOGIC_VECTOR(ADDR_WIDTH-1 DOWNTO 0);
	SIGNAL 		ram_match			:  	STD_LOGIC;
	SIGNAL 		ram_unmatch			:  	STD_LOGIC;
	
	SIGNAL		ram_in_wr_i 		: 	std_logic;
	SIGNAL		ram_in_address_e1_i : 	std_logic;
	SIGNAL		ram_in_address_e2_i : 	std_logic;
	SIGNAL		ram_in_check_i 		: 	std_logic;
	SIGNAL		ram_in_address_i	:  	STD_LOGIC_VECTOR(ADDR_WIDTH-1 DOWNTO 0);
	SIGNAL		ram_in_mac_i 		:  	STD_LOGIC_VECTOR(63 DOWNTO 0);
	
	SIGNAL		fifo_rd 			: 	STD_LOGIC ; 
    SIGNAL 		fifo_in 			: 	STD_LOGIC_VECTOR(63 DOWNTO 0) ;	
    SIGNAL 		fifo_out 			: 	STD_LOGIC_VECTOR(63 DOWNTO 0) ;
    SIGNAL 		fifo_full 			: 	STD_LOGIC;
    SIGNAL 		fifo_nearly_fulL 	: 	STD_LOGIC;
    SIGNAL 		fifo_empty 			: 	STD_LOGIC;
	
 
	
	SUBTYPE 	last_type IS  INTEGER RANGE 0 TO 2**ADDR_WIDTH-1;
    SIGNAL 		last 				: last_type;
	SIGNAL 		last_std 			: STD_LOGIC_VECTOR(ADDR_WIDTH-1 DOWNTO 0);
	SIGNAL 		weight_i 			: 	INTEGER RANGE 0 TO 255;
	SIGNAL 		weight_up			:	STD_LOGIC;
	SIGNAL 		weight_restart		:	STD_LOGIC;
begin
		-------PORT MAP SMALL FIFO DATA
		
		
		fifo_in <=in_mac & in_weight & in_port ;
		small_fifo_Inst :  small_fifo 
			GENERIC MAP(WIDTH  			=> 64,
						MAX_DEPTH_BITS  => 8)
			PORT MAP(
						din				=>	fifo_in,    
						wr_en 			=>	in_wr, 		
						rd_en 			=> 	fifo_rd,   
						dout 			=>	fifo_out,   
						full 			=>	fifo_full,
						nearly_full 	=>	fifo_nearly_full,
						empty 			=> 	fifo_empty,
						reset 			=> 	reset ,
						clk  			=> 	clk 
					);
--

-------COMPONENET SMALL FIFO

		ram_Inst :  mac_ram_table 
			GENERIC MAP	(ADDR_WIDTH => ADDR_WIDTH)
			port MAP (
			clk	=> clk,
			reset => reset,
			in_mac_no_prt=> ram_in_mac,
			in_address => ram_in_address,
			in_check=> ram_in_check,
			match_address =>ram_match_address,
			match=>ram_match,
			unmatch=>ram_unmatch,
			in_wr=> ram_in_wr,
			in_rd => in_rd,
			in_key=>in_key,
			last_address=>last_std,
			out_port	=> out_port,
			out_rd_rdy => out_rd_rdy,
			out_mac => out_mac	
			);
			ram_in_mac(63 DOWNTO 16)<=fifo_out(63 DOWNTO 16);
			ram_in_mac(15 DOWNTO 8)<=std_logic_vector(to_unsigned(weight_i, 8));
			ram_in_mac(7 DOWNTO 0)<=fifo_out(7 DOWNTO 0);
--			add		<=ram_in_address;
--			entry	<= ram_in_mac;
--			rdy	    <= ram_in_wr;
--			check 	<= ram_in_check;
------------------------------------
	last_std <= std_logic_vector(to_unsigned(last+1, ADDR_WIDTH));
	PROCESS(clk, reset)
		BEGIN
			IF reset= '1' THEN
					last <= 0 ;
			ELSIF clk'EVENT AND clk = '1' THEN
				IF (state =ADD_ENTRY )THEN last <= last +1   ;END IF;
			END IF;
		END PROCESS;
		
	PROCESS(clk, reset)
		BEGIN
			IF reset= '1' THEN
			state	<=	IDLE	;
			ELSIF clk'EVENT AND clk = '1' THEN
				state	<=	state_next	;
			END IF;
		END PROCESS;
	PROCESS(state)
		BEGIN		
							fifo_rd 		<= '0';	
							ram_in_wr 		<= '0';
							ram_in_check  	<= '0';
							ram_in_address	<= (OTHERS=>'0');
							weight_up 		<= '0';	
							weight_restart	<= '0';
							state_next 		<=	state;
						
						
			CASE state IS 
						
				WHEN 	IDLE =>
						IF fifo_empty = '0' THEN
							fifo_rd <= '1';
							
							state_next <= START;
						END IF;
							weight_restart	<= '1';
				WHEN	START =>
							
							IF weight_i  	 > 	fifo_out(15 DOWNTO 8)	THEN
								state_next	<=	IDLE	;								
							ELSE
								state_next  <= LATCH_MAC_LOOKUP;
							END IF;
							
				WHEN  	LATCH_MAC_LOOKUP =>
									
								ram_in_check<= '1';
								state_next 	<= CHECK_MAC_MATCH;
						
				WHEN 	CHECK_MAC_MATCH	=>
						IF ram_match = '1' THEN
							state_next <= UPDATE_ENTRY;
						ELSIF ram_unmatch = '1' THEN
							state_next <= ADD_ENTRY;
						END IF;
						
				WHEN 	UPDATE_ENTRY =>
							ram_in_wr <='1';
							ram_in_address <= ram_match_address;
							weight_up 	<=  '1';
							state_next <= START;
						
				WHEN	ADD_ENTRY =>	
							ram_in_wr <='1';
							ram_in_address <=std_logic_vector(to_unsigned(last+1, ADDR_WIDTH));			
							weight_up 	<=  '1';
							state_next <= START;
				WHEN OTHERS =>
							state_next<= IDLE;
				END CASE;
		END PROCESS;
---------------------------------------------------------------------
		
	process (clk)
		variable   cnt		   : integer range 0 to 255;
	begin
		if (rising_edge(clk)) then

			if weight_restart = '1' then
				-- Reset the counter to 0
				cnt := 0;

			elsif weight_up = '1' then
				-- Increment the counter if counting is enabled			   
				cnt := cnt + 1;

			end if;
		end if;
	weight_i	<= cnt+1;	
end process;
--------------------------------------------------------------------------------------------------------	
		
end Behavioral;

