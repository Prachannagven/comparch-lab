`timescale 1ns/1ps
module dut (
    input           [31:0]  a,
    input           [31:0]  b,
    input                   op,                
    output signed   [31:0]  result
);
    alulogic dut(
        .a(a),
        .b(b),
        .op(op),
        .result(result)
    );

endmodule
