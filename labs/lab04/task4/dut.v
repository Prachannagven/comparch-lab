`timescale 1ns / 1ps
module dut (
    input           [31:0]  a,
    input           [31:0]  b,
    output          [31:0]  result
);

    alucomp comparator (
        .a(a),
        .b(b),
        .result(result)
    );

endmodule
