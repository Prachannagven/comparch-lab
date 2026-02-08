
`timescale 1ns/1ps
module dut (
  input wire clk,
  input wire d,
  input reset,
  output reg q
);
  always @(posedge clk or negedge reset) begin
    if (!reset)
      q <= 1'b0;
    else
      q <= d;
  end
endmodule
