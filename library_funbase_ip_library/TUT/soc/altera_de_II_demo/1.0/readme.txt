#
# altera_de_II_demo
#
# Erno Salminen, March 2012
#

Purpose:
	Demonstrate how to use Kactus with Modelsim, Quartus, and 
	DE II FPGA board. Blinks one led and is controlled by one toggle 
	switch.

Directories:
	doc	Detailed instructions how to repeat the demo.

	ip_xact	IP-XACT descriptions for this system in XML

	quartus	Settings for Altera Quartus II. Settings file (.qsf) will
		updated by Kactus.

	sim	Lauch Modelsim in this directory. Use *.do files

	vhd	Top-level vhdl. This is generated by Kactus.

		Other VHDL files are in 
		ip.hwp.accelerator/port_blinker/1.0
		ip.hwp.accelerator/sig_gen/1.0




Platform: 
	  Test system is built with Kactus (v1.2 build 396). Tested
	  with Modelsim 10.0c and Quartus 11.0 in Windows XP.
