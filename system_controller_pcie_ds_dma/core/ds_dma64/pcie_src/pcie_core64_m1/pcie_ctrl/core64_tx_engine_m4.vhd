-------------------------------------------------------------------------------
--
-- Title       : core64_tx_engine_m4
-- Author      : Dmitry Smekhov
-- Company     : Instrumental Systems
-- E-mail      : dsmv@insys.ru
--
-- Version     : 1.1
--
-------------------------------------------------------------------------------
--
-- Description :  ������������� �������	  
--				 ����������� 4 - Spartan-6 
--
-------------------------------------------------------------------------------
--
--  Version 1.1		19.06.2012
--					���������� ������������ cpl_byte_count 
--
--					12.04.2013
--					Fixed cpl_byte_count
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

use work.core64_type_pkg.all;

package core64_tx_engine_m4_pkg is
	
component core64_tx_engine_m4 is
	port(
	
		--- General ---
		rstp			: in std_logic;		--! 1 - ����� 
		clk				: in std_logic;		--! �������� ������� ���� - 250 MHz 
		
		trn_tx			: out  type_trn_tx;			--! �������� ������
		trn_tx_back		: in   type_trn_tx_back;	--! ���������� � �������� ������
		
		completer_id	: in std_logic_vector( 15 downto 0 ); --! ������������� ���������� 
		
		reg_access_back	: in type_reg_access_back;	--! ������ �� ������ � ��������� 
		
		rx_tx_engine	: in  type_rx_tx_engine;	--! ����� RX->TX 
		tx_rx_engine	: out type_tx_rx_engine;	--! ����� TX->RX 
		
		tx_ext_fifo		: out type_tx_ext_fifo;		--! ����� TX->EXT_FIFO 
		tx_ext_fifo_back: in  type_tx_ext_fifo_back	--! ����� TX->EXT_FIFO 
			
	);
end component;

end package;

library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.core64_type_pkg.all;  

library unisim;
use unisim.vcomponents.all;

entity core64_tx_engine_m4 is
	port(
	
		--- General ---
		rstp			: in std_logic;		--! 1 - ����� 
		clk				: in std_logic;		--! �������� ������� ���� - 250 MHz 
		
		trn_tx			: out  type_trn_tx;			--! �������� ������
		trn_tx_back		: in   type_trn_tx_back;	--! ���������� � �������� ������
		
		completer_id	: in std_logic_vector( 15 downto 0 ); --! ������������� ���������� 
		
		reg_access_back	: in type_reg_access_back;	--! ������ �� ������ � ��������� 
		
		rx_tx_engine	: in  type_rx_tx_engine;	--! ����� RX->TX 
		tx_rx_engine	: out type_tx_rx_engine;	--! ����� TX->RX 
		
		tx_ext_fifo		: out type_tx_ext_fifo;		--! ����� TX->EXT_FIFO 
		tx_ext_fifo_back: in  type_tx_ext_fifo_back	--! ����� TX->EXT_FIFO 
			
	);
end core64_tx_engine_m4;


architecture core64_tx_engine_m4 of core64_tx_engine_m4 is		 

component ctrl_fifo64x34fw is
  port (
    clk : in std_logic;
    rst : in std_logic;
    din : in std_logic_vector(33 downto 0);
    wr_en : in std_logic;
    rd_en : in std_logic;
    dout : out std_logic_vector(33 downto 0);
    full : out std_logic;
    empty : out std_logic;
    valid : out std_logic;
    prog_full : out std_logic;
    prog_empty : out std_logic
  );
end component;


function set_data( data_in  : in std_logic_vector( 31 downto 0 ) ) return std_logic_vector is

variable	ret		: std_logic_vector( 31 downto 0 );

begin		 

	for ii in 0 to 31 loop
		if(  data_in(ii)='1' ) then
			ret(ii):='1';
		else
			ret(ii):='0';
		end if;
	end loop;
	
	return ret;

end set_data;

signal	rstpz			: std_logic;

type	stp_type		is ( s0, s1, s2, s21, s3, s31, s4, sr1, sr2, sr21, sr22, sr3, sr4, sr5,
							 sw1, sw01, sw02, sw04, sw2, sw30, sw31, sw5, sw6	);
signal	stp				: stp_type;	  

signal	fifo_din		: std_logic_vector( 33 downto 0 );
signal	fifo_wr			: std_logic;
signal	fifo_rd			: std_logic;
signal	fifo_dout		: std_logic_vector( 33 downto 0 );
signal	fifo_full		: std_logic;
signal	fifo_empty		: std_logic;
signal	fifo_valid		: std_logic;
signal	fifo_paf		: std_logic;
signal	fifo_pae		: std_logic;  

signal	fifo_sof		: std_logic;
signal	fifo_eof		: std_logic;
signal	fifo_rrem		: std_logic;
signal	fifo_data		: std_logic_vector( 31 downto 0 );
signal	reg_data		: std_logic_vector( 31 downto 0 );
signal	tlp_dw0			: std_logic_vector( 31 downto 0 );
signal	tlp_dw1			: std_logic_vector( 31 downto 0 );
signal	tlp_dw2			: std_logic_vector( 31 downto 0 );
signal	tlp_dw3			: std_logic_vector( 31 downto 0 );

signal	cpl_status		: std_logic_vector( 2 downto 0 ):="000";
signal	cpl_byte_count	: std_logic_vector( 11 downto 0 ) :=x"000";

signal	tlp_read_dw0	: std_logic_vector( 31 downto 0 );
signal	tlp_read_dw1	: std_logic_vector( 31 downto 0 );
signal	tlp_read_dw2	: std_logic_vector( 31 downto 0 );
signal	tlp_read_dw3	: std_logic_vector( 31 downto 0 );

signal	max_read_size	: std_logic_vector( 7 downto 0 );
signal	read_tag		: std_logic_vector( 7 downto 0 );

signal	req_cnt			: std_logic_vector( 5 downto 0 );	--! ������� ��������
signal	req_complete	: std_logic;						--! 1 - �������� ��� ������ 

signal	wait_complete	: std_logic;

signal	complete_cnt	: std_logic_vector( 9 downto 0 );	--! ������� �������� ����
signal	timeout_cnt		: std_logic_vector( 10 downto 0 );	--! �������� ������
signal	timeout_cnt_en	: std_logic;
signal	timeout_error	: std_logic;
signal	timeout_st0		: std_logic;
signal	rstpz1			: std_logic;

signal	write_cnt_en	: std_logic;
signal	write_cnt		: std_logic_vector( 5 downto 0 );	--! ������� ���� � ������
signal	write_cnt_pkg	: std_logic_vector( 4 downto 0 );	--! ������� �������
signal	write_cnt_eq	: std_logic;
signal	write_cnt_pkg_eq: std_logic;
signal	write_state		: std_logic;			
signal	write_size		: std_logic;	--! 1 - ����� 256 ����, 0 - ����� 128 ����
signal  write_cnt_pkg_add : std_logic_vector( 1 downto 0 );

signal	tlp_write_dw0	: std_logic_vector( 31 downto 0 );
signal	tlp_write_dw1	: std_logic_vector( 31 downto 0 );
signal	tlp_write_dw2	: std_logic_vector( 31 downto 0 );
signal	tlp_write_dw3	: std_logic_vector( 31 downto 0 );

signal	tlp_write_data	: std_logic_vector( 63 downto 0 );			  
signal	tlp_write_data_z: std_logic_vector( 31 downto 0 );			  
signal	adr_cnt			: std_logic_vector( 5 downto 0 );

signal	adr64			: std_logic;			  
signal	allow_cpl		: std_logic;
signal	allow_wr		: std_logic;  
signal	tbuf_av			: std_logic_vector( 5 downto 0 );		  
signal	write_cnt_en_z	: std_logic;

begin

trn_tx.trn_td( 31 downto 0 ) <= fifo_dout( 31 downto 0 );
trn_tx.trn_tsof_n <= fifo_dout( 32 );
trn_tx.trn_teof_n <= fifo_dout( 33 );
--trn_tx.trn_trem_n( 7 downto 4 ) <= "0000";
--trn_tx.trn_trem_n( 3 downto 0 ) <= (others=>fifo_dout( 66 ) );

trn_tx.trn_tsrc_dsc_n <= '1';
trn_tx.trn_terrfwd_n <= '1';

trn_tx.trn_tsrc_rdy_n <= fifo_empty or trn_tx_back.trn_tdst_rdy_n;
fifo_rd <= not ( fifo_empty or trn_tx_back.trn_tdst_rdy_n );

fifo0_reg: ctrl_fifo64x34fw 
  port map(
    clk 		=> clk,
    rst 		=> rstpz,
    din 		=> fifo_din, 
    wr_en 		=> fifo_wr,
    rd_en 		=> fifo_rd,
    dout 		=> fifo_dout, 
    full 		=> fifo_full,
    empty 		=> fifo_empty,
    valid 		=> fifo_valid,
    prog_full 	=> fifo_paf,
    prog_empty 	=> fifo_pae
  );
  
rstpz <= rstp after 1 ns when rising_edge( clk );	

fifo_din <=  fifo_eof & fifo_sof & set_data( fifo_data );


tbuf_av <= trn_tx_back.trn_tbuf_av;

allow_cpl <= tbuf_av(4) or tbuf_av(3) or tbuf_av(2) or tbuf_av(1) or tbuf_av(0) after 1 ns when rising_edge( clk );
allow_wr  <= tbuf_av(4) or tbuf_av(3) or tbuf_av(2) after 1 ns when rising_edge( clk );


pr_state: process( clk ) begin
	if( rising_edge( clk ) ) then
		
		case( stp ) is
			when s0 =>
			
				if(  fifo_paf='0' ) then
				
				if( (rx_tx_engine.request_reg_wr='1' or rx_tx_engine.request_reg_rd='1') and allow_cpl='1' ) then
					stp <= s1 after 1 ns;
				elsif( tx_ext_fifo_back.req_rd='1' and allow_wr='1'  ) then
					stp <= sr1 after 1 ns;
				elsif( tx_ext_fifo_back.req_wr='1' and allow_wr='1' ) then
					stp <= sw1 after 1 ns;
				end if;					
				
				end if;
				fifo_wr <= '0';
				tx_rx_engine.complete_reg <= '0' after 1 ns;
				tx_ext_fifo.complete_ok <= '0' after 1 ns;
				tx_ext_fifo.complete_error <= '0' after 1 ns;  
				write_cnt_en <= '0' after 1 ns;
				
				
			when s1 =>
				if( reg_access_back.complete='1' ) then
					if( rx_tx_engine.request_reg_wr='1' ) then
						stp <= s4 after 1 ns;	-- �� ������������ ��� �������� ������ 
					else
						stp <= s2 after 1 ns;
					end if;
				end if;
				
			when s2 =>	 
				fifo_sof <= '0' after 1 ns;
				fifo_eof <= '1' after 1 ns;
				fifo_data <= tlp_dw0 after 1 ns;
				fifo_wr <= '1' after 1 ns;
				stp <= s21 after 1 ns;

			when s21 =>	 
				fifo_sof <= '1' after 1 ns;
				fifo_eof <= '1' after 1 ns;
				fifo_data <= tlp_dw1 after 1 ns;
				stp <= s3 after 1 ns;
				
			when s3 =>
				
				fifo_data <= tlp_dw2 after 1 ns;
				stp <= s31 after 1 ns;

			when s31 =>
				
				fifo_eof <= '0' after 1 ns;
				fifo_data <= tlp_dw3 after 1 ns;
				stp <= s4 after 1 ns;
				
			when s4 =>
				fifo_wr <= '0' after 1 ns;	
				tx_rx_engine.complete_reg <= '1' after 1 ns;
				if( rx_tx_engine.request_reg_wr='0' and rx_tx_engine.request_reg_rd='0' ) then
					stp <= s0 after 1 ns;
				end if;

			when sr1 => ---- ������ �� ������ ������ �� ������ ----

				if( req_cnt(5)='1' or (req_cnt(2)='1' and tx_ext_fifo_back.rd_size='0' ) ) then
					stp <= sr4 after 1 ns;
				else
					stp <= sr2 after 1 ns;
				end if;
				
			when sr2 => 				
				wait_complete <= '1' after 1 ns;
				fifo_sof <= '0' after 1 ns;
				fifo_eof <= '1' after 1 ns;
				fifo_data <= tlp_read_dw0 after 1 ns;
				fifo_wr <= '1' after 1 ns;
				stp <= sr21 after 1 ns;				

			when sr21 => 				
				fifo_sof <= '1' after 1 ns;
				fifo_data <= tlp_read_dw1 after 1 ns;
				if( adr64='1' ) then
					stp <= sr22 after 1 ns;				
				else
					stp <= sr3 after 1 ns;				
				end if;
				
			when sr22 =>
				fifo_data <= tlp_read_dw2 after 1 ns;
				stp <= sr3 after 1 ns;
				
			when sr3 =>
				fifo_eof <= '0' after 1 ns;
				fifo_data <= tlp_read_dw3 after 1 ns;
				fifo_wr <= '1' after 1 ns;
				stp <= s0 after 1 ns;				
				
--			when sr3 => ---- �������� ���������� ������� ----
--				fifo_wr <= '0' after 1 ns;		  
--				stp <= sr0 after 1 ns;
				
			when sr4 =>  --- �������� ���������� ������� ----
				if( req_complete='1'  or timeout_error='1' ) then
					stp <= sr5 after 1 ns;
				else
					stp <= s0 after 1 ns;				
				end if;

			when sr5 =>
					wait_complete <= '0' after 1 ns;
					tx_ext_fifo.complete_ok <= req_complete after 1 ns;			
					tx_ext_fifo.complete_error <= timeout_error after 1 ns;
					if( tx_ext_fifo_back.req_rd='0' ) then
						stp <= s0 after 1 ns;
					end if;
					
					
			when sw1 => --- ������ 4 �� ---

				--write_cnt_en <= not adr64 after 1 ns;
				stp <= sw01 after 1 ns;
			
			when sw01 => --- ������ 4 �� ---
			
			
				write_state <= '1' after 1 ns;
				
				
				fifo_sof <= '0' after 1 ns;
				fifo_eof <= '1' after 1 ns;
				fifo_data <= tlp_write_dw0 after 1 ns;
				fifo_wr <= '1' after 1 ns;
				
				stp <= sw02 after 1 ns;				

			when sw02 => 
			
				fifo_sof <= '1' after 1 ns;
				fifo_data <= tlp_write_dw1 after 1 ns;
				
				
				if( adr64='1' ) then
					stp <= sw04 after 1 ns;
				else
					stp <= sw2 after 1 ns;	
					write_cnt_en <= '1' after 1 ns;

				end if;
				
			when sw04 =>
				fifo_data <= tlp_write_dw2 after 1 ns;
				stp <= sw2 after 1 ns;
				write_cnt_en <= '1' after 1 ns;
				
				
			when sw2 =>						
			
				
				write_cnt_en <= '0' after 1 ns;
				fifo_data <= tlp_write_dw3  after 1 ns;
					
				stp <= sw30 after 1 ns;
				
			when sw30 =>
				fifo_data <= tlp_write_data( 63 downto 32 ) after 1 ns;				
				write_cnt_en <= '1' after 1 ns;
				if( write_cnt_eq='1' ) then
					stp <= sw5 after 1 ns;
				else
					stp <= sw31 after 1 ns;	
				end if;
				
			when sw31 =>						  
				write_cnt_en <= '0' after 1 ns;	
				fifo_wr <= '1' after 1 ns;		  
				fifo_data <= tlp_write_data( 31 downto 0 ) after 1 ns;				
				stp <= sw30 after 1 ns;
				
			when sw5 =>					  
				fifo_data <= tlp_write_data( 31 downto 0 ) after 1 ns;				   
				fifo_eof <= '0' after 1 ns;
				write_cnt_en <= '0' after 1 ns;
				if( write_cnt_pkg_eq='1' ) then
					stp <= sw6 after 1 ns;
				else
					stp <= s0 after 1 ns;
				end if;
				
			when sw6 =>		
				fifo_wr <= '0' after 1 ns;
				tx_ext_fifo.complete_ok <= '1' after 1 ns;			
				tx_ext_fifo.complete_error <= '0' after 1 ns;
				write_state <= '0' after 1 ns;
				if( tx_ext_fifo_back.req_wr='0' ) then
					stp <= s0 after 1 ns;
				end if;
				
					
				
			
				
		end case;				
			
				
				
		
		
		if( rstpz='1' ) then
			stp <= s0 after 1 ns;	
			wait_complete <= '0' after 1 ns;
			write_state <= '0' after 1 ns;
		end if;
		
	end if;
end process;


tlp_dw0 <= "0" & rx_tx_engine.request_reg_rd & "0010100" &  rx_tx_engine.request_tc & "0000" & rx_tx_engine.request_attr & "0000" & "0000000" & rx_tx_engine.request_reg_rd;
tlp_dw1 <= completer_id & cpl_status & '0' & cpl_byte_count;
tlp_dw2 <= rx_tx_engine.request_id & rx_tx_engine.request_tag & '0' & rx_tx_engine.lower_adr & "00";

--cpl_byte_count <= "0000" & "0000" & "0" & rx_tx_engine.request_reg_rd & "00";  
cpl_byte_count <= "0000" & "0000" & "0" & rx_tx_engine.byte_count;

reg_data <= reg_access_back.data after 1 ns when rising_edge( clk ) and reg_access_back.data_we='1';
tlp_dw3(  7 downto 0 )  <= reg_data( 31 downto 24 );
tlp_dw3( 15 downto 8 )  <= reg_data( 23 downto 16 );
tlp_dw3( 23 downto 16 ) <= reg_data( 15 downto 8 );
tlp_dw3( 31 downto 24 ) <= reg_data(  7 downto 0 );

max_read_size <= x"20"; -- 128 ����
read_tag <= "000" & req_cnt( 4 downto 0 );

adr64 <= tx_ext_fifo_back.pci_adr( 39 ) or
	     tx_ext_fifo_back.pci_adr( 38 ) or
	     tx_ext_fifo_back.pci_adr( 37 ) or
	     tx_ext_fifo_back.pci_adr( 36 ) or
	     tx_ext_fifo_back.pci_adr( 35 ) or
	     tx_ext_fifo_back.pci_adr( 34 ) or
	     tx_ext_fifo_back.pci_adr( 33 ) or
	     tx_ext_fifo_back.pci_adr( 32 );

tlp_read_dw0 <= "00" & adr64 & '0' & x"000" & "00000000" & max_read_size;
tlp_read_dw1 <= completer_id & read_tag & x"FF";
tlp_read_dw2 <= x"000000" & tx_ext_fifo_back.pci_adr( 39 downto 32 );
tlp_read_dw3( 6 downto 0 ) <= "0000000";
tlp_read_dw3( 8 downto 7 ) <= req_cnt( 1 downto 0 );
tlp_read_dw3( 11 downto 9 ) <= req_cnt( 4 downto 2 ) when  tx_ext_fifo_back.rd_size='1' 
					else tx_ext_fifo_back.pci_adr( 11 downto 9 );  
					
tlp_read_dw3( 31 downto 12 ) <= tx_ext_fifo_back.pci_adr( 31 downto 12 );


--tlp_read_dw0 <= x"0000" & "00000000" & max_read_size;
--tlp_read_dw1 <= completer_id & read_tag & x"FF";
--
--tlp_read_dw2( 6 downto 0 ) <= "0000000";
--tlp_read_dw2( 8 downto 7 ) <= req_cnt( 1 downto 0 );
--tlp_read_dw2( 11 downto 9 ) <= req_cnt( 4 downto 2 ) when  tx_ext_fifo_back.rd_size='1' 
--					else tx_ext_fifo_back.pci_adr( 11 downto 9 );  
--					
--tlp_read_dw2( 31 downto 12 ) <= tx_ext_fifo_back.pci_adr( 31 downto 12 );
--
--tlp_read_dw3 <= (others=>'0');



pr_req_cnt: process( clk ) begin
	if( rising_edge( clk ) ) then
		if( stp=s0 and wait_complete='0' ) then
			req_cnt <= (others=>'0') after 1 ns;	
		elsif( 	stp=sr3 ) then
			req_cnt <= req_cnt + 1 after 1 ns;
		end if;
	end if;
end process;



rstpz1 <= rstpz after 1 ns when rising_edge( clk );
timeout_st0 <= ( not rstpz ) and (rstpz1 or timeout_cnt_en ) after 1 ns when rising_edge( clk );

xtcnt: srlc32e port map( q31=>timeout_cnt_en, clk=>clk, d=>timeout_st0, a=>"11111", ce=>'1' );

pr_timeout_cnt: process( clk ) begin
	if( rising_edge( clk ) ) then
		if( wait_complete='0' ) then
			timeout_cnt <= (others=>'0') after 1 ns;
		elsif( timeout_cnt_en='1' ) then
			timeout_cnt <= timeout_cnt + 1 after 1 ns;
		end if;
	end if;
end process;	  

timeout_error <= timeout_cnt(10);

pr_complete_cnt: process( clk ) begin 
	if( rising_edge( clk ) ) then
		if( wait_complete='0' ) then
			if( tx_ext_fifo_back.rd_size='0' ) then
				complete_cnt <= "0111000000" after 1 ns; -- 513-64 -- ��������� 512 ���� 
			else
				complete_cnt <= "0000000000" after 1 ns;	-- ��������� 4096 ���� (512 ���� �� 8 ����)
			end if;
		elsif( rx_tx_engine.complete_we='1' ) then
			complete_cnt <= complete_cnt + 1 after 1 ns;
		end if;
	end if;
end process;	

req_complete <= complete_cnt(9);

write_size <= trn_tx_back.cfg_dcommand(5);

pr_write_cnt: process( clk ) begin
	if( rising_edge( clk ) ) then
		if( stp=s0 ) then
			write_cnt <= '0' & not write_size & "000" & '0' after 1 ns;
		elsif( write_cnt_en='1' ) then
			write_cnt <= write_cnt + 1 after 1 ns;
		end if;
	end if;
end process;	

write_cnt_eq <= write_cnt(5);

write_cnt_pkg_add <= write_size & not write_size;

pr_write_cnt_pkg: process( clk ) begin
	if( rising_edge( clk ) ) then
		if( stp=s0 and write_state='0' ) then
			write_cnt_pkg <= "00000" after 1 ns;
		elsif( stp=sw5  ) then
			write_cnt_pkg <= write_cnt_pkg + write_cnt_pkg_add after 1 ns;
		end if;
	end if;
end process;	

write_cnt_pkg_eq <= write_cnt_pkg(4) and write_cnt_pkg(3) and write_cnt_pkg(2) and write_cnt_pkg(1) and (write_cnt_pkg(0) or write_size);


tlp_write_dw0 <= "01" & adr64 & '0' & x"000" & "00000000" & "0" & write_size & not write_size & "00000";
tlp_write_dw1 <= tlp_read_dw1;
tlp_write_dw2 <= tlp_read_dw2;	--x"000000" & tx_ext_fifo_back.pci_adr( 39 downto 32 );
tlp_write_dw3( 6 downto 0 ) <= "0000000";
tlp_write_dw3( 11 downto 7 ) <= write_cnt_pkg( 4 downto 0 );
tlp_write_dw3( 31 downto 12 ) <= tx_ext_fifo_back.pci_adr( 31 downto 12 );					


--tlp_write_data <= 	x"00000000" & x"0000" & "0000000000" & write_cnt;
gen_repack: for ii in 0 to 7 generate
	tlp_write_data( ii*8+7 downto ii*8 ) <= tx_ext_fifo_back.data(  (7-ii)*8+7 downto  (7-ii)*8 ); 
end generate;				   

tlp_write_data_z <= tlp_write_data( 31 downto 0 ) after 1 ns when rising_edge( clk );

write_cnt_en_z <= write_cnt_en after 1 ns when rising_edge( clk );

pr_adr_cnt: process( clk ) begin
	if( rising_edge( clk ) ) then
		if( stp=s0 ) then
			adr_cnt <= (others=>'0') after 1 ns;
		elsif( write_cnt_en_z='1' ) then
			adr_cnt <= adr_cnt + 1 after 1 ns;
		end if;
	end if;
end process;

tx_ext_fifo.adr( 3 downto 0 ) <= adr_cnt( 3 downto 0 );
tx_ext_fifo.adr( 4 ) <= adr_cnt(4) or write_cnt_pkg(0);
tx_ext_fifo.adr( 8 downto 5 ) <= write_cnt_pkg( 4 downto 1 );

end core64_tx_engine_m4;
