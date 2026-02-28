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
    assign #1 b_xor = sub ? ~b : b; 

    wire [32:0] full_sum;
    assign #3 full_sum = a + b_xor + {31'b0, sub};


    assign result = full_sum[31:0];
    
    wire a_sign, b_eff_sign, r_sign;
    assign a_sign     = a[31];
    assign b_eff_sign = b_xor[31];
    assign r_sign     = full_sum[31];

    assign #2 pos_overflow = ~a_sign & ~b_eff_sign & r_sign;
    assign #2 neg_overflow = a_sign & b_eff_sign & ~r_sign;
    
endmodule