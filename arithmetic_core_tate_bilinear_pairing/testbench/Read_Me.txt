How to start the simulation

1. simulation.do
----------------
This file is a batch file for Modelsim to compile the HDL files, setup the wave file, and begin function simulation. The working directory of Modelsim must be the same directory of the batch file.

2. test_tate_pairing.v
----------------------
This file is the main test bench for the Tate Bilinear Pairing core. The test bench is self-checked. It feeds input data to the core and compare the correct result with the output of the core. If the output is wrong, the test bench will display an error message.