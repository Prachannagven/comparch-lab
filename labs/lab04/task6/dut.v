`timescale 1ns / 1ps
module dut (
    input           [31:0]  a,
    input           [31:0]  b,
    output          [31:0]  result      // 1 if a < b (unsigned), else 0
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
    
    // For unsigned comparison, we check the borrow (carry-out inverted)
    // When doing a - b as unsigned:
    // - If a >= b, no borrow needed, carry-out = 1
    // - If a < b, borrow needed, carry-out = 0
    // 
    // We can detect borrow by extending to 33 bits and checking MSB
    // But since we're reusing aluaddsub, we use a different approach:
    // 
    // For unsigned: a < b when:
    // - MSB(a) = 0, MSB(b) = 1  => a < b (a is in lower half, b in upper)
    // - MSB(a) = 1, MSB(b) = 0  => a > b (a is in upper half, b in lower)
    // - MSB(a) = MSB(b)         => compare lower 31 bits, which diff[31] tells us
    
    wire a_msb, b_msb, diff_msb;
    assign a_msb = a[31];
    assign b_msb = b[31];
    assign diff_msb = diff[31];
    
    wire less_than_unsigned;
    // If MSBs differ: a < b when a_msb = 0 and b_msb = 1
    // If MSBs same: a < b when diff is negative (diff[31] = 1)
    assign #1 less_than_unsigned = (a_msb == b_msb) ? diff_msb : b_msb;

    // Output 32'b1 if a < b (unsigned), else 32'b0
    assign result = {31'b0, less_than_unsigned};

endmodule
