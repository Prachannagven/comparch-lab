`timescale 1ns / 1ps
module alulogic (
    input           [31:0]  a,
    input           [31:0]  b,
    input                   op,         // 0 = AND, 1 = OR
    output          [31:0]  result
);

    wire [31:0] and_result;
    wire [31:0] or_result;

    assign #1 and_result = a & b;
    assign #1 or_result  = a | b;

    // Mux to select between AND and OR based on op
    assign #1 result = op ? or_result : and_result;

endmodule