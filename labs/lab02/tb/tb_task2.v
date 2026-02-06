
`timescale 1ns/1ps
module tb;
  reg clk, reset;
  reg [7:0] d;
  wire [7:0] q;
  string vcd_file;

  dut DUT (.clk(clk), .reset(reset), .d(d), .q(q));
  
  initial clk=0; always #5 clk=~clk;
  initial begin
    reset=0; d=4'b0000;
    #12 reset=1; d=4'b1010;
    #12 reset=0;
    #20 $finish;
  end
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file))
      $dumpfile(vcd_file);
    else
      $dumpfile("artefacts/default.vcd");
    $dumpvars(0,tb);
  end
endmodule
