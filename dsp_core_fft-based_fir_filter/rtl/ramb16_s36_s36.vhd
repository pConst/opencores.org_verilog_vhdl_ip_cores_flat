---------------------------------------------------------------------
----                                                             ----
----  FFT Filter IP core                                         ----
----                                                             ----
----  Authors: Anatoliy Sergienko, Volodya Lepeha                ----
----  Company: Unicore Systems http://unicore.co.ua              ----
----                                                             ----
----  Downloaded from: http://www.opencores.org                  ----
----                                                             ----
---------------------------------------------------------------------
----                                                             ----
---- Copyright (C) 2006-2010 Unicore Systems LTD                 ----
---- www.unicore.co.ua                                           ----
---- o.uzenkov@unicore.co.ua                                     ----
----                                                             ----
---- This source file may be used and distributed without        ----
---- restriction provided that this copyright statement is not   ----
---- removed from the file and that any derivative work contains ----
---- the original copyright notice and the associated disclaimer.----
----                                                             ----
---- THIS SOFTWARE IS PROVIDED "AS IS"                           ----
---- AND ANY EXPRESSED OR IMPLIED WARRANTIES,                    ----
---- INCLUDING, BUT NOT LIMITED TO, THE IMPLIED                  ----
---- WARRANTIES OF MERCHANTABILITY, NONINFRINGEMENT              ----
---- AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.        ----
---- IN NO EVENT SHALL THE UNICORE SYSTEMS OR ITS                ----
---- CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,            ----
---- INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL            ----
---- DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT         ----
---- OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,               ----
---- DATA, OR PROFITS; OR BUSINESS INTERRUPTION)                 ----
---- HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,              ----
---- WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT              ----
---- (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING                 ----
---- IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,                 ----
---- EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.          ----
----                                                             ----
---------------------------------------------------------------------
--  File: RAMB4_S36_S36.vhd
--  created by Design Wizard: 08/13/05 08:52:59
--
library IEEE;
use IEEE.std_logic_1164.all;  
use IEEE.std_logic_unsigned.all;

entity   RAMB16_S36_S36 is
		port (DIA    : in STD_LOGIC_VECTOR (31 downto 0);
			DIB    : in STD_LOGIC_VECTOR (31 downto 0);
			DIPA    : in STD_LOGIC_VECTOR (3 downto 0);
			DIPB    : in STD_LOGIC_VECTOR (3 downto 0);
			ENA    : in STD_ULOGIC;
			ENB    : in STD_ULOGIC;
			WEA    : in STD_ULOGIC;
			WEB    : in STD_ULOGIC;
			SSRA   : in STD_ULOGIC;
			SSRB   : in STD_ULOGIC;
			CLKA   : in STD_ULOGIC;
			CLKB   : in STD_ULOGIC;
			ADDRA  : in STD_LOGIC_VECTOR (8 downto 0);
			ADDRB  : in STD_LOGIC_VECTOR (8 downto 0);
			DOA    : out STD_LOGIC_VECTOR (31 downto 0);
			DOB    : out STD_LOGIC_VECTOR (31 downto 0);
			DOPA    : out STD_LOGIC_VECTOR (3 downto 0);
			DOPB    : out STD_LOGIC_VECTOR (3 downto 0)
			);  
end RAMB16_S36_S36;

architecture BEH of RAMB16_S36_S36 is
	
	type mem is array (0 to 511) of std_logic_vector (35 downto 0);							  
	signal adra,adrb:std_logic_vector (8 downto 0):=(others=>'0');	   						  
	signal data_a,data_b:std_logic_vector (35 downto 0);
	signal wea_1,web_1: STD_LOGIC; 
begin  
	process(clka,ssra,clkb,ssrb,adra,adrb,wea,web,dia,dib)  
		variable ram: mem:=(others=>X"000000000") ;	
		variable ia,ib: integer;	   
		variable a,b:std_logic_vector (35 downto 0);
	begin
		
		if ssra = '1' then 
			dopa<="0000";
			doa <= X"00000000";	 
			adra <= "000000000";			
			wea_1 <= '0';   
		elsif clka = '1' and clka'event then 
			data_a <= dipa&dia;	
			adra(8 downto 0) <= addra;
			wea_1 <= wea;
		end if;	
		
		if ssrb = '1' then 
			dopb<="0000";
			dob <= X"00000000";	 	 
			adrb <= "000000000"; 			
			web_1 <= '0';
		elsif clkb = '1' and clkb'event then 
			data_b <= dipb&dib;	
			adrb(8 downto 0)  <= addrb; 			
			web_1 <= web;
		end if;
		
		ia:= conv_integer(To_X01(adra));		                 
		a:=	 ram(ia); 
		dopa<=a(35 downto 32);
		doa <= a(31 downto 0); 
		if wea_1 = '1' then
			ram(ia) :=data_a;           
		end if;	 	
		
		
		ib:= conv_integer(To_X01(adrb));  		                 
		b:=	 ram(ib); 
		dopb<=b(35 downto 32);
		dob <= b(31 downto 0);  
		if web_1 = '1' then
			ram(ib) := data_b;           
		end if;
		
	end process;
	
end BEH;
