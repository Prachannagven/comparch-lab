
`timescale 1ns/1ps
module tb;
  reg clk, reset;
  wire [3:0] count;
  string vcd_file;
  
  dut DUT (.clk(clk), .reset(reset), .count(count));

  initial clk=0; always #5 clk=~clk;
  initial begin
    reset=0; #12 reset=1; #33 reset=0;#25 reset=1;
    repeat(15) @(posedge clk);
    $finish;
  end
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file))
      $dumpfile(vcd_file);
    else
      $dumpfile("artefacts/default.vcd");
    $dumpvars(0,tb);
  end
endmodule
