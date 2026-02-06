`timescale 1ns/1ps
module tb;
  reg clk, d, reset;
  wire q;
  string vcd_file;

  dut DUT (.clk(clk), .d(d), .reset(reset), .q(q));
  
  initial clk=0; always #5 clk=~clk;
  initial begin
    reset=0; d=0;
    #7 d=1;
    #6 reset=1;
    #8 reset=0;
    #20 $finish;
  end
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file))
      $dumpfile(vcd_file);
    else
      $dumpfile("artefacts/default.vcd");
    $dumpvars(0,DUT);
  end
endmodule
