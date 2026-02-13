`timescale 1ns / 1ps
module alushift (
    input           [31:0]  a,          // Value to shift
    input           [4:0]  b,          // Shift amount in b[4:0]
    input                   op,         // 0 = SLL (left), 1 = SRL (right)
    output          [31:0]  result
);

    wire [31:0] sll_result;
    wire [31:0] srl_result;

    assign #2 sll_result = a << b;  // Shift Left Logical
    assign #2 srl_result = a >> b;  // Shift Right Logical

    assign #1 result = op ? srl_result : sll_result;

endmodule
