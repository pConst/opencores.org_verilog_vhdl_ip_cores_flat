// --------------------------------------------------------------------
//
// --------------------------------------------------------------------

`timescale 1ns/10ps


module the_test(
                input tb_clk,
                input tb_rst
              );  

  task run_the_test;
    begin

// --------------------------------------------------------------------
// insert test below
// --------------------------------------------------------------------

  $display("^^^---------------------------------");
  $display("^^^ %16.t | Testbench begun.\n", $time);
  $display("^^^---------------------------------");
  
  
  repeat(200) @(posedge tb_clk);	  


// --------------------------------------------------------------------
// insert test above
// --------------------------------------------------------------------

   end
  endtask


endmodule


