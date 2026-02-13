`timescale 1ns/1ps
module dut (
    input           [31:0]  a,
    input           [4:0]  b,
    input                   op,                
    output signed   [31:0]  result
);
    alushift dut(
        .a(a),
        .b(b),
        .op(op),
        .result(result)
    );

endmodule
