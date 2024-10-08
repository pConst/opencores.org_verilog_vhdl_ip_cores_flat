# TCL File Generated by Component Editor 13.1
# Wed Sep 03 12:38:07 CST 2014
# DO NOT MODIFY


# 
# bustap_jtag "bustap_jtag" v1.0
#  2014.09.03.12:38:07
# 
# 

# 
# request TCL package from ACDS 13.1
# 
package require -exact qsys 13.1


# 
# module bustap_jtag
# 
set_module_property DESCRIPTION ""
set_module_property NAME bustap_jtag
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP System
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME bustap_jtag
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL AUTO
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL bustap_jtag
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file jtag_sim_define.h        OTHER   PATH ../jtag_sim_define.h
add_fileset_file vendor.h                 OTHER   PATH ../../../par/altera/vendor.h
add_fileset_file bustap_jtag.v            VERILOG PATH bustap_jtag.v TOP_LEVEL_FILE
add_fileset_file up_monitor.v             VERILOG PATH ../../up_monitor.v
add_fileset_file virtual_jtag_adda_fifo.v VERILOG PATH ../virtual_jtag_adda_fifo.v
add_fileset_file virtual_jtag_adda_trig.v VERILOG PATH ../virtual_jtag_adda_trig.v
add_fileset_file virtual_jtag_addr_mask.v VERILOG PATH ../virtual_jtag_addr_mask.v


# 
# parameters
# 
add_parameter addr_width INTEGER 32
set_parameter_property addr_width DEFAULT_VALUE 32
set_parameter_property addr_width DISPLAY_NAME addr_width
set_parameter_property addr_width TYPE INTEGER
set_parameter_property addr_width UNITS None
set_parameter_property addr_width HDL_PARAMETER true


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock gls_clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset gls_reset reset Input 1


# 
# connection point s1
# 
add_interface s1 avalon end
set_interface_property s1 addressUnits SYMBOLS
set_interface_property s1 associatedClock clock
set_interface_property s1 associatedReset reset
set_interface_property s1 bitsPerSymbol 8
set_interface_property s1 burstOnBurstBoundariesOnly false
set_interface_property s1 burstcountUnits SYMBOLS
set_interface_property s1 explicitAddressSpan 0
set_interface_property s1 holdTime 0
set_interface_property s1 linewrapBursts false
set_interface_property s1 maximumPendingReadTransactions 0
set_interface_property s1 readLatency 0
set_interface_property s1 readWaitTime 1
set_interface_property s1 setupTime 0
set_interface_property s1 timingUnits Cycles
set_interface_property s1 writeWaitTime 0
set_interface_property s1 ENABLED true
set_interface_property s1 EXPORT_OF ""
set_interface_property s1 PORT_NAME_MAP ""
set_interface_property s1 CMSIS_SVD_VARIABLES ""
set_interface_property s1 SVD_ADDRESS_GROUP ""

add_interface_port s1 avs_s1_chipselect chipselect Input 1
add_interface_port s1 avs_s1_address address Input addr_width
add_interface_port s1 avs_s1_read read Input 1
add_interface_port s1 avs_s1_readdata readdata Output 32
add_interface_port s1 avs_s1_write write Input 1
add_interface_port s1 avs_s1_writedata writedata Input 32
add_interface_port s1 avs_s1_byteenable byteenable Input 4
add_interface_port s1 avs_s1_waitrequest waitrequest Output 1
set_interface_assignment s1 embeddedsw.configuration.isFlash 0
set_interface_assignment s1 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment s1 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment s1 embeddedsw.configuration.isPrintableDevice 0


# 
# connection point m1
# 
add_interface m1 avalon start
set_interface_property m1 addressUnits SYMBOLS
set_interface_property m1 associatedClock clock
set_interface_property m1 associatedReset reset
set_interface_property m1 bitsPerSymbol 8
set_interface_property m1 burstOnBurstBoundariesOnly false
set_interface_property m1 burstcountUnits SYMBOLS
set_interface_property m1 doStreamReads false
set_interface_property m1 doStreamWrites false
set_interface_property m1 holdTime 0
set_interface_property m1 linewrapBursts false
set_interface_property m1 maximumPendingReadTransactions 0
set_interface_property m1 readLatency 0
set_interface_property m1 readWaitTime 1
set_interface_property m1 setupTime 0
set_interface_property m1 timingUnits Cycles
set_interface_property m1 writeWaitTime 0
set_interface_property m1 ENABLED true
set_interface_property m1 EXPORT_OF ""
set_interface_property m1 PORT_NAME_MAP ""
set_interface_property m1 CMSIS_SVD_VARIABLES ""
set_interface_property m1 SVD_ADDRESS_GROUP ""

add_interface_port m1 avm_m1_waitrequest waitrequest Input 1
add_interface_port m1 avm_m1_address address Output addr_width
add_interface_port m1 avm_m1_read read Output 1
add_interface_port m1 avm_m1_readdata readdata Input 32
add_interface_port m1 avm_m1_write write Output 1
add_interface_port m1 avm_m1_writedata writedata Output 32
add_interface_port m1 avm_m1_byteenable byteenable Output 4

