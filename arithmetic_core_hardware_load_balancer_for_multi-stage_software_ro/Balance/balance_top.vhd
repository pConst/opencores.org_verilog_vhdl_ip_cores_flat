--------------------------------------------------------

	LIBRARY IEEE;
	USE IEEE.STD_LOGIC_1164.ALL;
	use IEEE.std_logic_arith.all;
-------------------------------
	ENTITY balance_top IS
	GENERIC(DATA_WIDTH :INTEGER := 64;
			CTRL_WIDTH :INTEGER := 8);
	PORT(
	SIGNAL 		in_data 			:	IN   	STD_LOGIC_VECTOR(63 DOWNTO 0)	;
	SIGNAL 		in_ctrl 			: 	IN   	STD_LOGIC_VECTOR(7 DOWNTO 0)	;
    SIGNAL 		in_wr 				:	IN 		STD_LOGIC	;
	SIGNAL 		in_rdy 				: 	OUT 	STD_LOGIC	;

	SIGNAL 		out_data 			:	OUT   	STD_LOGIC_VECTOR(63 DOWNTO 0)	;
	SIGNAL 		out_ctrl 			: 	OUT   	STD_LOGIC_VECTOR(7 DOWNTO 0)	;
	SIGNAL 		out_wr 				: 	OUT 	STD_LOGIC	;
	SIGNAL 		out_rdy 			: 	IN 		STD_LOGIC	;
	
	
	SIGNAL 		in_next_mac :IN   STD_LOGIC_VECTOR(47 DOWNTO 0);
	SIGNAL 		in_exit_port :IN   STD_LOGIC_VECTOR(7 DOWNTO 0);	
	SIGNAL 		in_next_mac_rdy : IN STD_LOGIC;
	SIGNAL 		out_rd_next_mac : OUT STD_LOGIC;
	SIGNAL 		key :OUT   STD_LOGIC_VECTOR(11 DOWNTO 0); 
			
    --- Misc
    SIGNAL     en : IN STD_LOGIC;
    SIGNAL 		reset 				:	IN 		STD_LOGIC	;
    SIGNAL 		clk   				:	IN 		STD_LOGIC
	);
	END ENTITY;
	
 ------------------------------------------------------
	ARCHITECTURE behavior OF balance_top IS 
-------COMPONENET SMALL FIFO
		COMPONENT  small_fifo IS
	GENERIC(WIDTH :INTEGER := 72;
			MAX_DEPTH_BITS :INTEGER := 3);
	PORT(
	
			   
     SIGNAL din : IN STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);--input [WIDTH-1:0] din,     // Data in
     SIGNAL wr_en : IN STD_LOGIC;--input          wr_en,   // Write enable
     
     SIGNAL rd_en : IN STD_LOGIC;--input          rd_en,   // Read the next word 
     
     SIGNAL dout :OUT STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);--output reg [WIDTH-1:0]  dout,    // Data out
     SIGNAL full : OUT STD_LOGIC;--output         full,
     SIGNAL nearly_full : OUT STD_LOGIC;--output         nearly_full,
     SIGNAL empty : OUT STD_LOGIC;--output         empty,
     
	
    SIGNAL reset :IN STD_LOGIC;
    SIGNAL clk   :IN STD_LOGIC

	);
	END COMPONENT;
-------COMPONENET SMALL FIFO
	COMPONENT  balance IS
	GENERIC(DATA_WIDTH :INTEGER := 64;
			CTRL_WIDTH :INTEGER := 8);
	PORT(
		
			SIGNAL in_data :IN   STD_LOGIC_VECTOR(63 DOWNTO 0);
			SIGNAL in_ctrl : IN   STD_LOGIC_VECTOR(7 DOWNTO 0);
			SIGNAL in_wr :IN STD_LOGIC;
			SIGNAL in_rdy : OUT STD_LOGIC;
			
			SIGNAL out_data : OUT   STD_LOGIC_VECTOR(63 DOWNTO 0);
			SIGNAL out_ctrl : OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
			SIGNAL out_wr : OUT STD_LOGIC;
			SIGNAL out_rdy : IN STD_LOGIC;
			
			SIGNAL in_next_mac :IN   STD_LOGIC_VECTOR(47 DOWNTO 0);
			SIGNAL in_exit_port :IN   STD_LOGIC_VECTOR(7 DOWNTO 0);	
			SIGNAL in_next_mac_rdy : IN STD_LOGIC;
			SIGNAL out_rd_next_mac : OUT STD_LOGIC;
			SIGNAL key :OUT   STD_LOGIC_VECTOR(11 DOWNTO 0); 
			
		   SIGNAL reset :IN STD_LOGIC;
		   SIGNAL clk   :IN STD_LOGIC

	);
	END COMPONENT;
------------ one hot encoding state definition
	
	TYPE state_type IS (IDLE, IN_MODULE_HDRS,SKIP_HDRS, IN_PACKET, DUMP_1,DUMP_2,DUMP_3);
	ATTRIBUTE enum_encoding: STRING;
	ATTRIBUTE enum_encoding of state_type : type is "onehot";

	SIGNAL state, state_NEXT : state_type; 

------------end state machine definition

----------------------FIFO	  
	  SIGNAL fifo_data : STD_LOGIC_VECTOR(63 DOWNTO 0);
	  SIGNAL fifo_ctrl : STD_LOGIC_VECTOR(7 DOWNTO 0);  
	  SIGNAL in_fifo_in : STD_LOGIC_VECTOR(71 DOWNTO 0);    
      SIGNAL in_fifo_rd_en : STD_LOGIC;
	  SIGNAL in_fifo_rd_en_p : STD_LOGIC;
	  SIGNAL in_fifo_go : STD_LOGIC;
	  SIGNAL in_fifo_go_i : STD_LOGIC;
      SIGNAL in_fifo_dout  : STD_LOGIC_VECTOR(71 DOWNTO 0);  
      SIGNAL in_fifo_full : STD_LOGIC;
      SIGNAL in_fifo_nearly_full : STD_LOGIC;
      SIGNAL in_fifo_empty : STD_LOGIC;
		 SIGNAL wr_en : STD_LOGIC;
	  SIGNAL 		out_data_i 			:	   	STD_LOGIC_VECTOR(63 DOWNTO 0)	;
	  SIGNAL 		out_ctrl_i 			: 	   	STD_LOGIC_VECTOR(7 DOWNTO 0)	;
	  SIGNAL 		out_wr_i 			: 	 	STD_LOGIC	;
	  SIGNAL 		out_rdy_int 			: 	 	STD_LOGIC	;
---------------------------------------------------
	BEGIN
	
	------PORT MAP open_header
	
		-------PORT MAP SMALL FIFO DATA
		small_fifo_Inst :  small_fifo 
	GENERIC MAP(WIDTH  => 72,
			MAX_DEPTH_BITS  => 5)
	PORT MAP(
	
			   
      din =>(in_fifo_in),    
      wr_en =>wr_en,   
     
      rd_en => in_fifo_rd_en,   
     
      dout =>in_fifo_dout,   
      full =>in_fifo_full,
      nearly_full =>in_fifo_nearly_full,
      empty => in_fifo_empty,
     
	
     reset => reset ,
     clk  => clk 

	);


-------PORT MAP SMALL FIFO
--	int2ext_inst :  int2ext 
--	GENERIC MAP(DATA_WIDTH => 64,
--			CTRL_WIDTH => 8)
--	PORT MAP(
--		 		in_data 			   => out_data_i,
--		 		in_ctrl 			   => out_ctrl_i,
--		 		in_wr 				=> out_wr_i,
--		 		in_rdy 				=> out_rdy_int,
--		
--		 		out_data 			=> out_data,
--		 		out_ctrl 			=> out_ctrl,
--		 		out_wr 				=> out_wr,
--		 		out_rdy 			   => out_rdy,
--		 		reset 				=> reset,
--		 		clk   				=> clk
--	);
--	
		balance_Inst :  balance 
	GENERIC MAP (DATA_WIDTH => 64,
			CTRL_WIDTH => 8)
	PORT MAP (
				 in_data 			   => out_data_i,
		 		 in_ctrl 			   => out_ctrl_i,
		 		 in_wr 					=> out_wr_i,
		 		 in_rdy 					=> out_rdy_int,
			
				 out_data 				=> out_data,
				 out_ctrl 				=> out_ctrl,
				 out_wr 					=> out_wr,
				 out_rdy 				=> out_rdy,
			
			   in_next_mac 			=> in_next_mac,
			   in_exit_port 			=>	in_exit_port,
			   in_next_mac_rdy 		=> in_next_mac_rdy,
			   out_rd_next_mac 		=> out_rd_next_mac,
			   key 						=> key,
			
		      reset 					=> reset,
		      clk   					=>clk

	);
-----------------------
      in_fifo_in <= 	in_data & in_ctrl ;
		wr_en <= en and in_wr;
		fifo_data 	<=	   in_fifo_dout(71 DOWNTO 8)	;
		fifo_ctrl 	<= 	in_fifo_dout(7 DOWNTO 0)	;
		in_fifo_rd_en <=  out_rdy_int and(not in_fifo_empty) ;
		
	
	
		 in_rdy 	<=	(NOT in_fifo_nearly_full);-- or (not en) 	;
		


	
		
PROCESS(clk,reset)
BEGIN
	IF (reset ='1') THEN
		state <=IDLE;	
		ELSIF clk'EVENT AND clk ='1' THEN
		state<=state_next;
		in_fifo_rd_en_p <= in_fifo_rd_en;
	END IF;
END PROCESS;
		PROCESS(clk,reset)
		BEGIN
			
			IF clk'EVENT AND clk ='1' THEN
									out_data_i				<=	fifo_data;
									out_ctrl_i				<=	fifo_ctrl;
									out_wr_i				   <=	in_fifo_rd_en_p ;
						END IF;
		END PROCESS;

---------------Register output
--		PROCESS(clk,reset)
--		BEGIN
--			
--			IF clk'EVENT AND clk ='1' THEN
--									out_data				<=	out_data_i;
--									out_ctrl				<=	out_ctrl_i;
--									out_wr				    <=	out_wr_i;	
--									
--			END IF;
--		END PROCESS;	
END behavior;
   