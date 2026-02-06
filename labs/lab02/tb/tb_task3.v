
`timescale 1ns/1ps
module tb;
  reg clk, reset, serial_in;
  wire [3:0] q;
  string vcd_file;

  dut DUT (.clk(clk), .reset(reset), .serial_in(serial_in), .q(q));
  
  initial clk=0; always #5 clk=~clk;
  initial begin
    reset=0; serial_in=0;
    #12 reset=1;
    serial_in=1; @(negedge clk);
    serial_in=0; @(negedge clk);
    serial_in=1; @(negedge clk);
    serial_in=1; @(negedge clk);
    #10 $finish;
  end
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file))
      $dumpfile(vcd_file);
    else
      $dumpfile("artefacts/default.vcd");
    $dumpvars(0,tb);
  end
endmodule
