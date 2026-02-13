`timescale 1ns / 1ps
module alucomp (
    input           [31:0]  a,
    input           [31:0]  b,
    output          [31:0]  result      // 1 if a < b (signed), else 0
);

    // Reuse aluaddsub for subtraction (a - b)
    wire signed [31:0] diff;
    wire pos_overflow, neg_overflow;

    aluaddsub subtractor (
        .a(a),
        .b(b),
        .sub(1'b1),             // Always subtract
        .result(diff),
        .pos_overflow(pos_overflow),
        .neg_overflow(neg_overflow)
    );
    
    wire less_than;
    assign #1 less_than = diff[31] ^ (pos_overflow | neg_overflow);

    // Output 32'b1 if a < b, else 32'b0
    assign result = {31'b0, less_than};

endmodule
