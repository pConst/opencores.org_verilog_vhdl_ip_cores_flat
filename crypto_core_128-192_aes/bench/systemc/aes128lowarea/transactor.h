//////////////////////////////////////////////////////////////////////
////                                                              ////
////  Transactor for AES ramdom verification                      ////
////                                                              ////
////  This file is part of the SystemC AES                        ////
////                                                              ////
////  Description:                                                ////
////  Transactor acording to TLM for SystemC AES project          ////
////                                                              ////
////  To Do:                                                      ////
////   - done                                                     ////
////                                                              ////
////  Author(s):                                                  ////
////      - Javier Castillo, jcastilo@opencores.org               ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2000 Authors and OPENCORES.ORG                 ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS Revision History
//
// $Log: not supported by cvs2svn $
// Revision 1.3  2004/08/30 14:47:38  jcastillo
// Code formated
//
// Revision 1.1.1.1  2004/07/05 09:46:22  jcastillo
// First import
//


#include "systemc.h"

class transactor_ports: public sc_module
{
public:

	// Ports
	sc_in<bool> clk;
	sc_out<bool> reset;

	//Ports to RT model
	sc_out<bool> rt_load_o;
	sc_out<bool> rt_decrypt_o;
	sc_out<sc_biguint<128> > rt_aes_data_o;
	sc_out<sc_biguint<128> > rt_aes_key_o;
	sc_in<bool> rt_aes_ready_i;

	//Ports to C model
	sc_fifo_out<bool> c_decrypt_o;
	sc_fifo_out<sc_biguint <128> > c_aes_key_o;
	sc_fifo_out<sc_biguint <128> > c_aes_data_o;

};


class rw_task_if: virtual public sc_interface
{

public:
	//Funciones para el transactor
	virtual void resetea(void) = 0;
	virtual void encrypt(sc_biguint<128> data, sc_biguint<128> key) = 0;
	virtual void decrypt(sc_biguint<128> data, sc_biguint<128> key) = 0;
	virtual void wait_cycles(int cycles) = 0;

};


//Transactor
class aes_transactor: public rw_task_if, public transactor_ports
{

public:

	SC_CTOR(aes_transactor)
	{

		cout.unsetf(ios::dec);
		cout.setf(ios::hex);

	}


	void resetea(void)
	{
		reset.write(0);
		wait(clk->posedge_event());
		reset.write(1);
		cout << "Reseted" << endl;
	}

	void encrypt(sc_biguint <128 >data, sc_biguint <128 >key)
	{

		wait(clk->posedge_event());

		//To RT model
		rt_load_o.write(1);
		rt_aes_data_o.write(data);
		rt_aes_key_o.write(key);
		rt_decrypt_o.write(0);

		//To C model through fifos
		c_aes_data_o.write(data);
		c_aes_key_o.write(key);
		c_decrypt_o.write(0);

		wait(clk->posedge_event());
		rt_load_o.write(0);
		wait(rt_aes_ready_i->posedge_event());
	}

	void decrypt(sc_biguint <128 >data, sc_biguint <128 >key)
	{

		wait(clk->posedge_event());

		//To RT model
		rt_load_o.write(1);
		rt_aes_data_o.write(data);
		rt_aes_key_o.write(key);
		rt_decrypt_o.write(1);

		//To C model through fifos
		c_aes_data_o.write(data);
		c_aes_key_o.write(key);
		c_decrypt_o.write(1);

		wait(clk->posedge_event());
		rt_load_o.write(0);
		wait(rt_aes_ready_i->posedge_event());

	}

	void wait_cycles(int cycles)
	{
		for (int i = 0; i < cycles; i++)
		{
			wait(clk->posedge_event());
		}
	}

};
