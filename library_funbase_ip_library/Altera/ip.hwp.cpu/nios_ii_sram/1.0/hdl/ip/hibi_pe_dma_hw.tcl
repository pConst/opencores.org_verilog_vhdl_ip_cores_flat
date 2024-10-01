# TCL File Generated by Component Editor 11.0sp1
# Wed Feb 08 11:31:21 EET 2012
# DO NOT MODIFY


# +-----------------------------------
# | 
# | hibi_pe_dma "hibi_pe_dma" v1.0
# | null 2012.02.08.11:31:21
# | 
# | 
# | D:/user/raasakka/DACI/daci_ip/trunk/ip.hwp.communication/hibi_pe_dma/1.0/vhd/hibi_pe_dma.vhd
# | 
# |    ./hpd_tx_control.vhd syn, sim
# |    ./hpd_rx_packet.vhd syn, sim
# |    ./hpd_rx_stream.vhd syn, sim
# |    ./hpd_rx_and_conf.vhd syn, sim
# |    ./hibi_pe_dma.vhd syn, sim
# | 
# +-----------------------------------


# +-----------------------------------
# | request TCL package from ACDS 11.0
# | 
package require -exact sopc 11.0
# | 
# +-----------------------------------





# +-----------------------------------
# | module hibi_pe_dma
# | 
set_module_property NAME hibi_pe_dma
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP Other
set_module_property DISPLAY_NAME hibi_pe_dma
set_module_property TOP_LEVEL_HDL_FILE hibi_pe_dma.vhd
set_module_property TOP_LEVEL_HDL_MODULE hibi_pe_dma
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL TRUE
set_module_property STATIC_TOP_LEVEL_MODULE_NAME ""
set_module_property FIX_110_VIP_PATH false
# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
add_file hpd_tx_control.vhd {SYNTHESIS SIMULATION}
add_file hpd_rx_packet.vhd {SYNTHESIS SIMULATION}
add_file hpd_rx_stream.vhd {SYNTHESIS SIMULATION}
add_file hpd_rx_and_conf.vhd {SYNTHESIS SIMULATION}
add_file hibi_pe_dma.vhd {SYNTHESIS SIMULATION}
# | 
# +-----------------------------------

# +-----------------------------------
# | parameters
# | 
add_parameter data_width_g INTEGER 32
set_parameter_property data_width_g DEFAULT_VALUE 32
set_parameter_property data_width_g DISPLAY_NAME data_width_g
set_parameter_property data_width_g TYPE INTEGER
set_parameter_property data_width_g UNITS None
set_parameter_property data_width_g ALLOWED_RANGES -2147483648:2147483647
set_parameter_property data_width_g AFFECTS_GENERATION false
set_parameter_property data_width_g HDL_PARAMETER true
add_parameter addr_width_g INTEGER 32
set_parameter_property addr_width_g DEFAULT_VALUE 32
set_parameter_property addr_width_g DISPLAY_NAME addr_width_g
set_parameter_property addr_width_g TYPE INTEGER
set_parameter_property addr_width_g UNITS None
set_parameter_property addr_width_g ALLOWED_RANGES -2147483648:2147483647
set_parameter_property addr_width_g AFFECTS_GENERATION false
set_parameter_property addr_width_g HDL_PARAMETER true
add_parameter words_width_g INTEGER 16
set_parameter_property words_width_g DEFAULT_VALUE 16
set_parameter_property words_width_g DISPLAY_NAME words_width_g
set_parameter_property words_width_g TYPE INTEGER
set_parameter_property words_width_g UNITS None
set_parameter_property words_width_g ALLOWED_RANGES -2147483648:2147483647
set_parameter_property words_width_g AFFECTS_GENERATION false
set_parameter_property words_width_g HDL_PARAMETER true
add_parameter n_stream_chans_g INTEGER 4
set_parameter_property n_stream_chans_g DEFAULT_VALUE 4
set_parameter_property n_stream_chans_g DISPLAY_NAME n_stream_chans_g
set_parameter_property n_stream_chans_g TYPE INTEGER
set_parameter_property n_stream_chans_g UNITS None
set_parameter_property n_stream_chans_g ALLOWED_RANGES -2147483648:2147483647
set_parameter_property n_stream_chans_g AFFECTS_GENERATION false
set_parameter_property n_stream_chans_g HDL_PARAMETER true
add_parameter n_packet_chans_g INTEGER 4
set_parameter_property n_packet_chans_g DEFAULT_VALUE 4
set_parameter_property n_packet_chans_g DISPLAY_NAME n_packet_chans_g
set_parameter_property n_packet_chans_g TYPE INTEGER
set_parameter_property n_packet_chans_g UNITS None
set_parameter_property n_packet_chans_g ALLOWED_RANGES -2147483648:2147483647
set_parameter_property n_packet_chans_g AFFECTS_GENERATION false
set_parameter_property n_packet_chans_g HDL_PARAMETER true
add_parameter n_chans_bits_g INTEGER 3
set_parameter_property n_chans_bits_g DEFAULT_VALUE 3
set_parameter_property n_chans_bits_g DISPLAY_NAME n_chans_bits_g
set_parameter_property n_chans_bits_g TYPE INTEGER
set_parameter_property n_chans_bits_g UNITS None
set_parameter_property n_chans_bits_g ALLOWED_RANGES -2147483648:2147483647
set_parameter_property n_chans_bits_g AFFECTS_GENERATION false
set_parameter_property n_chans_bits_g HDL_PARAMETER true
add_parameter hibi_addr_cmp_lo_g INTEGER 8
set_parameter_property hibi_addr_cmp_lo_g DEFAULT_VALUE 8
set_parameter_property hibi_addr_cmp_lo_g DISPLAY_NAME hibi_addr_cmp_lo_g
set_parameter_property hibi_addr_cmp_lo_g TYPE INTEGER
set_parameter_property hibi_addr_cmp_lo_g UNITS None
set_parameter_property hibi_addr_cmp_lo_g ALLOWED_RANGES -2147483648:2147483647
set_parameter_property hibi_addr_cmp_lo_g AFFECTS_GENERATION false
set_parameter_property hibi_addr_cmp_lo_g HDL_PARAMETER true
add_parameter hibi_addr_cmp_hi_g INTEGER 31
set_parameter_property hibi_addr_cmp_hi_g DEFAULT_VALUE 31
set_parameter_property hibi_addr_cmp_hi_g DISPLAY_NAME hibi_addr_cmp_hi_g
set_parameter_property hibi_addr_cmp_hi_g TYPE INTEGER
set_parameter_property hibi_addr_cmp_hi_g UNITS None
set_parameter_property hibi_addr_cmp_hi_g ALLOWED_RANGES -2147483648:2147483647
set_parameter_property hibi_addr_cmp_hi_g AFFECTS_GENERATION false
set_parameter_property hibi_addr_cmp_hi_g HDL_PARAMETER true
# | 
# +-----------------------------------

# +-----------------------------------
# | display items
# | 
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point avalon_slave_0
# | 
add_interface avalon_slave_0 avalon end
set_interface_property avalon_slave_0 addressAlignment DYNAMIC
set_interface_property avalon_slave_0 addressUnits WORDS
set_interface_property avalon_slave_0 associatedClock clock
set_interface_property avalon_slave_0 associatedReset clock_sink_reset
set_interface_property avalon_slave_0 burstOnBurstBoundariesOnly false
set_interface_property avalon_slave_0 explicitAddressSpan 0
set_interface_property avalon_slave_0 holdTime 0
set_interface_property avalon_slave_0 isMemoryDevice false
set_interface_property avalon_slave_0 isNonVolatileStorage false
set_interface_property avalon_slave_0 linewrapBursts false
set_interface_property avalon_slave_0 maximumPendingReadTransactions 0
set_interface_property avalon_slave_0 printableDevice false
set_interface_property avalon_slave_0 readLatency 0
set_interface_property avalon_slave_0 readWaitTime 1
set_interface_property avalon_slave_0 setupTime 0
set_interface_property avalon_slave_0 timingUnits Cycles
set_interface_property avalon_slave_0 writeWaitTime 0

set_interface_property avalon_slave_0 ENABLED true

add_interface_port avalon_slave_0 avalon_cfg_addr_in address Input n_chans_bits_g+4
add_interface_port avalon_slave_0 avalon_cfg_we_in write Input 1
add_interface_port avalon_slave_0 avalon_cfg_re_in read Input 1
add_interface_port avalon_slave_0 avalon_cfg_cs_in chipselect Input 1
add_interface_port avalon_slave_0 avalon_cfg_waitrequest_out waitrequest Output 1
add_interface_port avalon_slave_0 avalon_cfg_writedata_in writedata Input addr_width_g
add_interface_port avalon_slave_0 avalon_cfg_readdata_out readdata Output addr_width_g
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point conduit_end
# | 
add_interface conduit_end conduit end

set_interface_property conduit_end ENABLED true

add_interface_port conduit_end hibi_data_in export Input data_width_g
add_interface_port conduit_end hibi_av_in export Input 1
add_interface_port conduit_end hibi_empty_in export Input 1
add_interface_port conduit_end hibi_comm_in export Input 5
add_interface_port conduit_end hibi_re_out export Output 1
add_interface_port conduit_end hibi_data_out export Output data_width_g
add_interface_port conduit_end hibi_av_out export Output 1
add_interface_port conduit_end hibi_full_in export Input 1
add_interface_port conduit_end hibi_comm_out export Output 5
add_interface_port conduit_end hibi_we_out export Output 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point clock_sink_reset
# | 
add_interface clock_sink_reset reset end
set_interface_property clock_sink_reset associatedClock clock
set_interface_property clock_sink_reset synchronousEdges DEASSERT

set_interface_property clock_sink_reset ENABLED true

add_interface_port clock_sink_reset rst_n reset_n Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point interrupt_sender
# | 
add_interface interrupt_sender interrupt end
set_interface_property interrupt_sender associatedAddressablePoint avalon_slave_0
set_interface_property interrupt_sender associatedClock clock
set_interface_property interrupt_sender associatedReset clock_sink_reset

set_interface_property interrupt_sender ENABLED true

add_interface_port interrupt_sender rx_irq_out irq Output 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point avalon_master
# | 
add_interface avalon_master avalon start
set_interface_property avalon_master addressUnits SYMBOLS
set_interface_property avalon_master associatedClock clock
set_interface_property avalon_master associatedReset clock_sink_reset
set_interface_property avalon_master burstOnBurstBoundariesOnly false
set_interface_property avalon_master doStreamReads false
set_interface_property avalon_master doStreamWrites false
set_interface_property avalon_master linewrapBursts false
set_interface_property avalon_master readLatency 0

set_interface_property avalon_master ENABLED true

add_interface_port avalon_master avalon_addr_out_rx address Output addr_width_g
add_interface_port avalon_master avalon_we_out_rx write Output 1
add_interface_port avalon_master avalon_be_out_rx byteenable Output data_width_g/8
add_interface_port avalon_master avalon_writedata_out_rx writedata Output data_width_g
add_interface_port avalon_master avalon_waitrequest_in_rx waitrequest Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point avalon_master_1
# | 
add_interface avalon_master_1 avalon start
set_interface_property avalon_master_1 addressUnits SYMBOLS
set_interface_property avalon_master_1 associatedClock clock
set_interface_property avalon_master_1 associatedReset clock_sink_reset
set_interface_property avalon_master_1 burstOnBurstBoundariesOnly false
set_interface_property avalon_master_1 doStreamReads false
set_interface_property avalon_master_1 doStreamWrites false
set_interface_property avalon_master_1 linewrapBursts false
set_interface_property avalon_master_1 readLatency 0

set_interface_property avalon_master_1 ENABLED true

add_interface_port avalon_master_1 avalon_readdatavalid_in_tx readdatavalid Input 1
add_interface_port avalon_master_1 avalon_waitrequest_in_tx waitrequest Input 1
add_interface_port avalon_master_1 avalon_readdata_in_tx readdata Input data_width_g
add_interface_port avalon_master_1 avalon_re_out_tx read Output 1
add_interface_port avalon_master_1 avalon_addr_out_tx address Output addr_width_g
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point clock
# | 
add_interface clock clock end
set_interface_property clock clockRate 0

set_interface_property clock ENABLED true

add_interface_port clock clk clk Input 1
# | 
# +-----------------------------------

