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
read_verilog C:/Users/jeffA/Desktop/rtl/sport/trunk/rtl/verilog/sport_defines.v
set_property file_type "Verilog Header" [get_files C:/Users/jeffA/Desktop/rtl/sport/trunk/rtl/verilog/sport_defines.v]
read_verilog -library xil_defaultlib {
  C:/Users/jeffA/Desktop/rtl/sport/trunk/rtl/verilog/wb_interface.v
  C:/Users/jeffA/Desktop/rtl/sport/trunk/rtl/verilog/fifos.v
  C:/Users/jeffA/Desktop/rtl/sport/trunk/rtl/verilog/sport_top.v
}
read_xdc C:/Users/jeffA/Desktop/rtl/sport/trunk/syn/xilinx/vivado/sport_top/sport_top.srcs/constrs_1/new/sport_top.xdc
set_property used_in_implementation false [get_files C:/Users/jeffA/Desktop/rtl/sport/trunk/syn/xilinx/vivado/sport_top/sport_top.srcs/constrs_1/new/sport_top.xdc]

set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/jeffA/Desktop/rtl/sport/trunk/syn/xilinx/vivado/sport_top/sport_top.cache/wt [current_project]
set_property parent.project_dir C:/Users/jeffA/Desktop/rtl/sport/trunk/syn/xilinx/vivado/sport_top [current_project]
catch { write_hwdef -file sport_top.hwdef }
synth_design -top sport_top -part xc7vx485tffg1157-1
write_checkpoint sport_top.dcp
report_utilization -file sport_top_utilization_synth.rpt -pb sport_top_utilization_synth.pb
