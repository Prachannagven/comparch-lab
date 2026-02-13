`timescale 1ns / 1ps
module aluaddsub (
    input           [31:0]  a,
    input           [31:0]  b,
    input                   sub,                  
    output signed   [31:0]  result,
    output                  pos_overflow,        
    output                  neg_overflow        
);
    wire [31:0] b_xor;
    assign #1 b_xor = b ^ {32{sub}}; 

    wire [31:0] sum;
    assign #3 sum = a + b_xor + {31'b0, sub};


    assign result = sum;
    
    wire a_sign, b_eff_sign, r_sign;
    assign a_sign     = a[31];
    assign b_eff_sign = b_xor[31];
    assign r_sign     = sum[31];

    assign #1 pos_overflow = ~a_sign & ~b_eff_sign & r_sign;
    assign #1 neg_overflow = a_sign & b_eff_sign & ~r_sign;
    
endmodule