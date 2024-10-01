onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider TX
add wave -noupdate /tb_basic_test_hibiv3_wra/basic_tester_tx_1/rst_n
add wave -noupdate /tb_basic_test_hibiv3_wra/basic_tester_tx_1/clk
add wave -noupdate /tb_basic_test_hibiv3_wra/basic_tester_tx_1/agent_av_out
add wave -noupdate -radix hexadecimal /tb_basic_test_hibiv3_wra/basic_tester_tx_1/agent_data_out
add wave -noupdate -radix hexadecimal /tb_basic_test_hibiv3_wra/basic_tester_tx_1/agent_comm_out
add wave -noupdate /tb_basic_test_hibiv3_wra/basic_tester_tx_1/agent_we_out
add wave -noupdate /tb_basic_test_hibiv3_wra/basic_tester_tx_1/agent_full_in
add wave -noupdate -divider {Bus signals}
add wave -noupdate /tb_basic_test_hibiv3_wra/av_bus_wra
add wave -noupdate -radix hexadecimal /tb_basic_test_hibiv3_wra/data_bus_wra
add wave -noupdate -radix hexadecimal /tb_basic_test_hibiv3_wra/comm_bus_wra
add wave -noupdate /tb_basic_test_hibiv3_wra/lock_bus_wra
add wave -noupdate /tb_basic_test_hibiv3_wra/full_bus_wra
add wave -noupdate -divider RX
add wave -noupdate /tb_basic_test_hibiv3_wra/basic_tester_rx_1/rst_n
add wave -noupdate /tb_basic_test_hibiv3_wra/basic_tester_rx_1/clk
add wave -noupdate /tb_basic_test_hibiv3_wra/basic_tester_rx_1/agent_av_in
add wave -noupdate -radix hexadecimal /tb_basic_test_hibiv3_wra/basic_tester_rx_1/agent_data_in
add wave -noupdate -radix hexadecimal /tb_basic_test_hibiv3_wra/basic_tester_rx_1/agent_comm_in
add wave -noupdate /tb_basic_test_hibiv3_wra/basic_tester_rx_1/agent_re_out
add wave -noupdate /tb_basic_test_hibiv3_wra/basic_tester_rx_1/agent_empty_in
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {256 ns} 0}
configure wave -namecolwidth 147
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ms
update
WaveRestoreZoom {0 ns} {347 ns}
