`timescale 1ns/1ps
module dff (
  input wire clk,
  input wire d,
  input reset,
  output reg q
);
  always @(posedge clk) begin
    if(!reset)
      q <= 1'b0;
    else
      q <= d;
  end
endmodule
