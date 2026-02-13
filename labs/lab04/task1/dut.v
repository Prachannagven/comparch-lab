`timescale 1ns/1ps
module dut (
    input           [31:0]  a,
    input           [31:0]  b,
    input                   sub,                  
    output signed   [31:0]  result,
    output                  pos_overflow,        
    output                  neg_overflow        
);
  aluaddsub dut (
    .a(a),
    .b(b),
    .sub(sub),
    .result(result),
    .pos_overflow(pos_overflow),
    .neg_overflow(neg_overflow)
  );
endmodule
