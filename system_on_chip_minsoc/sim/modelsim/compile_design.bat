@echo off
vlog -incr -work minsoc -f ../../prj/sim/minsoc_verilog.src
::vcom -work minsoc -f ../../prj/sim/minsoc_vhdl.src
echo Finished...
set /p exit=Press ENTER to close this window... 
