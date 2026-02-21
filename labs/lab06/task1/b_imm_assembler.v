`timescale 1ns/1ps
module b_imm_assembler(
    input wire [31:0] instr,
    output wire [31:0] imm
);
    //Sign extending the MSB and concating the lower bits
    assign imm = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
endmodule