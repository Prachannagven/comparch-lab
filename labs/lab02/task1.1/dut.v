
`timescale 1ns/1ps
module dut (
  input wire clk,
  input wire d,
  input reset,
  output reg q
);
  always @(posedge clk) begin
    q <= d;
  end
endmodule
