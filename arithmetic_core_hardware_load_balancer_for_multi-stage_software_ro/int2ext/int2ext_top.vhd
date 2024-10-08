--------------------------------------------------------
	LIBRARY IEEE;
	USE IEEE.STD_LOGIC_1164.ALL;
	use ieee.numeric_std.all;
	use IEEE.STD_LOGIC_ARITH.ALL;
	use IEEE.STD_LOGIC_UNSIGNED.ALL;
	
-------------------------------
	ENTITY int2ext_top IS
	GENERIC(DATA_WIDTH :INTEGER := 64;
			CTRL_WIDTH :INTEGER := 8);
	PORT(
		SIGNAL 		in_data 			   :	IN   	STD_LOGIC_VECTOR(63 DOWNTO 0)	;
		SIGNAL 		in_ctrl 			   : 	IN   	STD_LOGIC_VECTOR(7 DOWNTO 0)	;
		SIGNAL 		in_wr 				:	IN 		STD_LOGIC	;
		SIGNAL 		in_rdy 				: 	OUT 	STD_LOGIC	;
		
		SIGNAL 		out_data 			:	OUT   	STD_LOGIC_VECTOR(63 DOWNTO 0)	;
		SIGNAL 		out_ctrl 			: 	OUT   	STD_LOGIC_VECTOR(7 DOWNTO 0)	;
		SIGNAL 		out_wr 				: 	OUT 	STD_LOGIC	;
		SIGNAL 		out_rdy 			   : 	IN 		STD_LOGIC	;
--		SIGNAL 		fifo_data_out 			:	OUT   	STD_LOGIC_VECTOR(63 DOWNTO 0)	;
--		SIGNAL 		latch_word_out 			:	OUT   	STD_LOGIC_VECTOR(63 DOWNTO 0)	;
--		SIGNAL 		fifo_ctrl_out 			: 	OUT   	STD_LOGIC_VECTOR(7 DOWNTO 0)	;
		SIGNAL      en 					: IN STD_LOGIC;
		SIGNAL 		reset 				:	IN 		STD_LOGIC	;
		SIGNAL 		clk   				:	IN 		STD_LOGIC
	);
	END ENTITY int2ext_top;
	
 ------------------------------------------------------
	ARCHITECTURE behavior OF int2ext_top IS 
-------COMPONENET SMALL FIFO
		COMPONENT  small_fifo IS
				GENERIC(WIDTH :INTEGER := 72;
						MAX_DEPTH_BITS :INTEGER := 3);
				PORT(
					 SIGNAL din : IN STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
					 SIGNAL wr_en : IN STD_LOGIC;
					 SIGNAL rd_en : IN STD_LOGIC;
					 SIGNAL dout :OUT STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
					 SIGNAL full : OUT STD_LOGIC;
					 SIGNAL nearly_full : OUT STD_LOGIC;
					 SIGNAL empty : OUT STD_LOGIC;
					 SIGNAL reset :IN STD_LOGIC;
					 SIGNAL clk   :IN STD_LOGIC
				);
		END COMPONENT;
-------COMPONENET SMALL FIFO
------COMPONENT vlan2ext
	COMPONENT vlan2ext IS
		GENERIC(DATA_WIDTH :INTEGER := 64;
				CTRL_WIDTH :INTEGER := 8);
				PORT(
					SIGNAL 		in_data 			:	IN   	STD_LOGIC_VECTOR(63 DOWNTO 0)	;
					SIGNAL 		in_ctrl 			: 	IN   	STD_LOGIC_VECTOR(7 DOWNTO 0)	;
					SIGNAL 		in_wr 				:	IN 		STD_LOGIC	;					
					SIGNAL 		exit_port			:	OUT   	STD_LOGIC_VECTOR(7 DOWNTO 0)	;
					SIGNAL 		done				:	OUT   	STD_LOGIC 	;
					 --- Misc					
					SIGNAL 		reset 				:	IN 		STD_LOGIC	;
					SIGNAL 		clk   				:	IN 		STD_LOGIC
					);
	END COMPONENT;
------COMPONENT vlan2ext
------------ one hot encoding state definition
	
	TYPE state_type IS (IDLE, START, IN_MODULE_HDRS, WORD_1, WORD_2,WORD_3, IN_PACKET,LAST);
	ATTRIBUTE enum_encoding: STRING;
	ATTRIBUTE enum_encoding of state_type : type is "onehot";

	SIGNAL state, state_NEXT : state_type; 

------------end state machine definition

----------------------FIFO	  
	  SIGNAL fifo_data : STD_LOGIC_VECTOR(63 DOWNTO 0);
	  SIGNAL fifo_ctrl : STD_LOGIC_VECTOR(7 DOWNTO 0);  
	  SIGNAL in_fifo_in : STD_LOGIC_VECTOR(71 DOWNTO 0);    
      SIGNAL in_fifo_rd_en : STD_LOGIC;
	  SIGNAL in_fifo_go : STD_LOGIC;
	  SIGNAL in_fifo_rd_en_p : STD_LOGIC;
      SIGNAL in_fifo_dout  : STD_LOGIC_VECTOR(71 DOWNTO 0);  
      SIGNAL in_fifo_full : STD_LOGIC;
      SIGNAL in_fifo_nearly_full : STD_LOGIC;
      SIGNAL in_fifo_empty : STD_LOGIC;
------------------------------
	  SIGNAL ctrl_fifo_in : STD_LOGIC_VECTOR(71 DOWNTO 0);         
      SIGNAL ctrl_fifo_rd : STD_LOGIC;       
      SIGNAL ctrl_fifo_dout : STD_LOGIC_VECTOR(7 DOWNTO 0);   
      SIGNAL ctrl_fifo_full : STD_LOGIC; 
      SIGNAL ctrl_fifo_nearly_full : STD_LOGIC; 
      SIGNAL ctrl_fifo_empty : STD_LOGIC; 
--	  SIGNAL cnt : INTEGER; 
	 
	  SIGNAL 		out_data_i 			:	   	STD_LOGIC_VECTOR(63 DOWNTO 0)	;
	  SIGNAL 		out_ctrl_i 			: 	   	STD_LOGIC_VECTOR(7 DOWNTO 0)	;
	  SIGNAL 		out_wr_i 			: 	 	STD_LOGIC	;
	  SIGNAL 		in_data_i 			:	   	STD_LOGIC_VECTOR(63 DOWNTO 0)	;
	  SIGNAL 		in_ctrl_i 			: 	   	STD_LOGIC_VECTOR(7 DOWNTO 0)	;
	  SIGNAL 		in_fifo_in_i 		:	   	STD_LOGIC_VECTOR(71 DOWNTO 0)	;
	  SIGNAL 		wr_en_i 			: 	 	STD_LOGIC	;
	  SIGNAL 		exit_port			:	   	STD_LOGIC_VECTOR(7 DOWNTO 0)	;
	  SIGNAL 		done				:	   	STD_LOGIC 	;
	  SIGNAL 		words_cnt			:	   	STD_LOGIC_VECTOR(7 DOWNTO 0)	;
	  SIGNAL 		words_cnt_ch		:	   	STD_LOGIC;
	  SIGNAL 		bytes_cnt			:	   	STD_LOGIC_VECTOR(7 DOWNTO 0)	;
	  SIGNAL 		cnt					:	   	STD_LOGIC_VECTOR(7 DOWNTO 0)	;
	  SIGNAL 		last_ctrl			:	   	STD_LOGIC_VECTOR(7 DOWNTO 0)	;
	  SIGNAL 		cnt_en 				: 	 	STD_LOGIC	; 
	  SIGNAL 		cnt_rst 			: 	 	STD_LOGIC	; 
	  SIGNAL 		header_rdy 			: 	 	STD_LOGIC	;
	  SIGNAL 		latch 				: 	 	STD_LOGIC	;
	  SIGNAL 		latch_word 			:	   	STD_LOGIC_VECTOR(63 DOWNTO 0)	;
	  SIGNAL 		latch_word_p 			:	   	STD_LOGIC_VECTOR(63 DOWNTO 0)	;
	  SIGNAL 		fifo_data_p 			:	   	STD_LOGIC_VECTOR(63 DOWNTO 0)	;
	  SIGNAL 		wr_en 				: STD_LOGIC; 
	 SIGNAL 		out_wr_t_i 				: STD_LOGIC; 
---------------------------------------------------
	BEGIN
	
	
	------PORT MAP open_header
	vlan2extr_Inst : vlan2ext 
	GENERIC MAP (DATA_WIDTH  => 64,
			CTRL_WIDTH => 8)
	PORT MAP(
	 		in_data 			   =>	in_data_i,
	 		in_ctrl 			   => in_ctrl_i ,
     		in_wr 				=>	wr_en_i,
			exit_port 			=>  exit_port,    
			done 				   =>  done, 
     		reset 				=>	reset,
     		clk   				=>	clk
	);
	
	------PORT MAP open_header
	
		-------PORT MAP SMALL FIFO DATA
		small_fifo_Inst1 :  small_fifo 
		GENERIC MAP(WIDTH  => 72,
				MAX_DEPTH_BITS  => 5)
			PORT MAP(			   
				  din =>in_fifo_in_i,    
				  wr_en =>wr_en_i,       
				  rd_en => in_fifo_rd_en,       
				  dout =>in_fifo_dout,   
				  full =>in_fifo_full,
				  nearly_full =>in_fifo_nearly_full,
				  empty => in_fifo_empty,
				  reset => reset ,
				  clk  => clk 
			);
	
	

-------PORT MAP SMALL FIFO
		-------PORT MAP SMALL FIFO DATA
		small_fifo_Inst_ctrl :  small_fifo 
	GENERIC MAP(WIDTH  => 8,
			MAX_DEPTH_BITS  => 5)
				PORT MAP(			   
				  din =>exit_port,    
				  wr_en => done,        
				  rd_en => ctrl_fifo_rd,       
				  dout =>ctrl_fifo_dout,   
				  full =>ctrl_fifo_full,
				  nearly_full =>ctrl_fifo_nearly_full,
				  empty => ctrl_fifo_empty,
				  reset => reset ,
				  clk  => clk 
				);
	
	
-----------------------
				
	
				in_fifo_in_i 	<= 		in_fifo_in;	
				wr_en_i			<=  	wr_en;
				in_data_i		<= 		in_data;
				in_ctrl_i		<=		in_ctrl;
			
        in_fifo_in 	<= 	in_data & in_ctrl ;
		fifo_data 	 <=	   in_fifo_dout(71 DOWNTO 8)	;
		fifo_ctrl 	<= 	in_fifo_dout(7 DOWNTO 0)	;
--		in_fifo_rd_en <=out_rdy AND (NOT in_fifo_empty) AND in_fifo_go;
--	     fifo_rd <= ctrl_fifo_empty OR in_fifo_go;
		 in_rdy 	<=	(NOT in_fifo_nearly_full) AND (NOT ctrl_fifo_nearly_full)	;
		wr_en  <= en  AND in_wr;
		PROCESS(clk,reset)
		BEGIN
			IF (reset ='1') THEN
				state <=IDLE;	
				ELSIF clk'EVENT AND clk ='1' THEN
				state<=state_next;
				in_fifo_rd_en_p <= in_fifo_rd_en;
			END IF;
		END PROCESS;
		
--		out_cnt <= cnt;
PROCESS(state, ctrl_fifo_empty ,fifo_data, fifo_ctrl,in_fifo_empty)
	BEGIN
							state_next 				<= 	state;
--							out_data_i				<= fifo_data	;
--							out_ctrl_i				<= fifo_ctrl;
							out_wr_i				<=		'0';
							ctrl_fifo_rd			<=		'0'	;
							in_fifo_rd_en			<=		'0'	; 
							header_rdy				<=		'0'	; 

		CASE state IS
			WHEN IDLE =>
			   IF(ctrl_fifo_empty = '0'  ) THEN
						   ctrl_fifo_rd				<=	'1'	;
						   in_fifo_rd_en   			<=	'1'	;	
						   state_next 				<=  START;				
				END IF;
			WHEN START			=>
							 
							header_rdy				<=	'1'	; 
							state_next 				<=  IN_MODULE_HDRS;
			WHEN IN_MODULE_HDRS =>
							
							IF(out_rdy = '1'  ) THEN
								IF (fifo_ctrl=X"FF")	THEN
								END IF;
							out_wr_i				<=	'1';
							in_fifo_rd_en   		<=	'1'	;						
							state_next              <=  WORD_1;				
							END IF;
													
				
			WHEN WORD_1		=>
							
						IF(out_rdy = '1'  AND   in_fifo_empty ='0') THEN
							
							out_wr_i				<=	'1';
							in_fifo_rd_en   		<=	'1'	;
							state_next              <=  WORD_2;
							END IF;
			WHEN WORD_2		=>IF(out_rdy = '1'  AND   in_fifo_empty ='0') THEN
							
--							out_wr_i				<=	'1';
							in_fifo_rd_en   		<=	'1'	;
							state_next              <=  WORD_3;
							END IF;
		
			WHEN WORD_3		=>
							IF(out_rdy = '1'  AND   in_fifo_empty ='0') THEN
							out_wr_i				<=	'1';
							in_fifo_rd_en   		<=	'1'	;
							state_next              <=  IN_PACKET;
							END IF;

						   		
			WHEN IN_PACKET	=>			
								
							
							IF ( fifo_ctrl /= X"00" ) THEN
										
								IF (   out_rdy = '1' ) THEN
										out_wr_i				<=	'1';
											IF (   words_cnt_ch = '1' ) THEN
											state_next               <= IDLE;
											ELSE
												state_next               <= LAST;
										END IF;
										END IF;
							ELSIF(out_rdy = '1'  AND   in_fifo_empty ='0') THEN
								out_wr_i					<=	'1';
								in_fifo_rd_en   		<=	'1'	;
								
								state_next              <=  IN_PACKET;
							END IF;
									
			WHEN LAST => 	IF (   out_rdy = '1' ) THEN	
								out_wr_i				<=	'1';
								state_next               <= IDLE;
								END IF;
		
			END CASE;
	END PROCESS;
	
	
	
---------------Register output


	WITH state SELECT 
		out_data_i <=
		X"00" & ctrl_fifo_dout & X"00"& words_cnt & fifo_data(31 downto 16) & X"00"& bytes_cnt WHEN  IN_MODULE_HDRS,
		fifo_data WHEN WORD_1,
		latch_word(63 downto 32) &  fifo_data(63 downto 32)WHEN WORD_3,
		latch_word(31 downto 0)  &  fifo_data(63 downto 32) WHEN  IN_PACKET | LAST,
		(OTHERS=>'0') WHEN OTHERS;
		
	
	out_ctrl_i <= X"FF" when state = IN_MODULE_HDRS else
				  last_ctrl  when state = IN_PACKET AND fifo_ctrl /= X"00" AND words_cnt_ch='1' else
				  last_ctrl  when state = LAST else
				  X"00" ;	
--	WITH state SELECT 
--		out_wr_i <=
--		out_rdy  WHEN  IN_MODULE_HDRS,
--		in_fifo_rd_en_p WHEN WORD_1,
--		in_fifo_rd_en_p WHEN WORD_3,
--		in_fifo_rd_en_p   WHEN  IN_PACKET ,
--		 out_rdy  WHEN LAST,
--		'0' WHEN OTHERS;	
--	out_wr_t_i	<=     word_cnt_up when word_cnt >= 1  AND word_cnt <= 21 else
--								 '0';			
		PROCESS(clk,reset)
		BEGIN
			
			IF clk'EVENT AND clk ='1' THEN
					IF header_rdy = '1' THEN
							bytes_cnt <= fifo_data(7 downto 0)- X"04";
					IF (fifo_data(15 downto 0)-X"0004") > (fifo_data(45 downto 32)&"000" - X"0008") THEN
									words_cnt	<=	fifo_data(39 downto 32)  ;
									words_cnt_ch <= '0';
							ELSE 
									words_cnt	<=	fifo_data(39 downto 32) - '1' ;
									words_cnt_ch <= '1';
							END IF;
					END IF;
						IF in_fifo_rd_en='1' THEN
						latch_word <= fifo_data;
						END IF;
					 
			END IF;
		END PROCESS;	
	WITH bytes_cnt(2 DOWNTO 0)SELECT
			last_ctrl <= "00000010" WHEN "111",
						 "00000100" WHEN "110",
						 "00001000" WHEN "101",
						 "00010000" WHEN "100",
						 "00100000" WHEN "011",
						 "01000000" WHEN "010",
						 "10000000" WHEN "001",
						 "00000001" WHEN others;
						
			
	
		PROCESS(clk,reset)
		BEGIN
--			
			IF clk'EVENT AND clk ='1' THEN
									out_data				<=	out_data_i;
									out_ctrl				<=	out_ctrl_i;
									out_wr					<=	out_wr_i;	
			END IF;
		END PROCESS;
--		fifo_ctrl_out <=fifo_ctrl;
--		fifo_data_out <=fifo_data;
--		latch_word_out <= latch_word;
END behavior;
   