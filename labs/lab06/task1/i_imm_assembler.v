`timescale 1ns/1ps
module i_imm_assembler(
    input [31:0] instr,
    output [31:0] imm
);
    //Sign extending the MSB and concating the lower bits
    assign imm = {{20{instr[31]}}, instr[31:20]};
endmodule