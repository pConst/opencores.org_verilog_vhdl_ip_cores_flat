# 
# Synthesis run script generated by Vivado
# 

  set_param gui.test TreeTableDev
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7vx485tffg1157-1
set_property target_language Verilog [current_project]
set_param project.compositeFile.enableAutoGeneration 0
set_property default_lib xil_defaultlib [current_project]
read_verilog C:/Users/jeffA/Desktop/rtl/wiegand/trunk/rtl/verilog/wiegand_defines.v
set_property file_type "Verilog Header" [get_files C:/Users/jeffA/Desktop/rtl/wiegand/trunk/rtl/verilog/wiegand_defines.v]
read_verilog -library xil_defaultlib {
  C:/Users/jeffA/Desktop/rtl/wiegand/trunk/rtl/verilog/wb_interface.v
  C:/Users/jeffA/Desktop/rtl/wiegand/trunk/rtl/verilog/fifos.v
  C:/Users/jeffA/Desktop/rtl/wiegand/trunk/rtl/verilog/wiegand_tx_top.v
}
read_xdc C:/Users/jeffA/Desktop/rtl/wiegand/trunk/syn/xilinx/wiegand_tx/vivado/wiegand_tx_top/wiegand_tx_top.srcs/constrs_1/new/wiegand_tx_top.xdc
set_property used_in_implementation false [get_files C:/Users/jeffA/Desktop/rtl/wiegand/trunk/syn/xilinx/wiegand_tx/vivado/wiegand_tx_top/wiegand_tx_top.srcs/constrs_1/new/wiegand_tx_top.xdc]

set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/jeffA/Desktop/rtl/wiegand/trunk/syn/xilinx/wiegand_tx/vivado/wiegand_tx_top/wiegand_tx_top.cache/wt [current_project]
set_property parent.project_dir C:/Users/jeffA/Desktop/rtl/wiegand/trunk/syn/xilinx/wiegand_tx/vivado/wiegand_tx_top [current_project]
catch { write_hwdef -file wiegand_tx_top.hwdef }
synth_design -top wiegand_tx_top -part xc7vx485tffg1157-1
write_checkpoint wiegand_tx_top.dcp
report_utilization -file wiegand_tx_top_utilization_synth.rpt -pb wiegand_tx_top_utilization_synth.pb
