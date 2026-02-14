`timescale 1ns/1ps
module dut(
    input wire clk,
    input wire rst,
    input wire we,
    input wire [31:0] d,
    output reg [31:0] q
);
    reg32 dut(
        .clk(clk),
        .rst(rst),
        .we(we),
        .d(d),
        .q(q)
    );
    
endmodule