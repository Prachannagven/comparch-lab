`timescale 1ns/1ps
module dut(
    input wire clk,
    input wire reset,
    input wire [7:0] d,
    output wire [7:0] q
);
  genvar i;
  generate
    for (i=0; i<8; i=i+1) begin : dff_array
      dff DFF (
        .clk(clk),
        .d(d[i]),
        .reset(reset),
        .q(q[i])
      );
    end
  endgenerate

endmodule