`timescale 1ns/1ps
module controlunit (
    input wire [31:0] instruction,
    output wire RegWrite,
    output wire ALUSrc,
    output wire MemWrite,
    output wire MemRead,
    output wire [2:0] ALUOp,
    output wire [1:0] ImmSel
);

    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;

    assign opcode = instruction[6:0];
    assign funct3 = instruction[14:12];
    assign funct7 = instruction[31:25];

    wire is_rtype;
    wire is_ialu;
    wire is_iload;
    wire is_stype;
    wire is_btype;

    assign is_rtype = ~opcode[6] &  opcode[5] &  opcode[4] & ~opcode[3] & ~opcode[2] &  opcode[1] &  opcode[0];
    assign is_ialu  = ~opcode[6] & ~opcode[5] &  opcode[4] & ~opcode[3] & ~opcode[2] &  opcode[1] &  opcode[0];
    assign is_iload = ~opcode[6] & ~opcode[5] & ~opcode[4] & ~opcode[3] & ~opcode[2] &  opcode[1] &  opcode[0];
    assign is_stype = ~opcode[6] &  opcode[5] & ~opcode[4] & ~opcode[3] & ~opcode[2] &  opcode[1] &  opcode[0];
    assign is_btype =  opcode[6] &  opcode[5] & ~opcode[4] & ~opcode[3] & ~opcode[2] &  opcode[1] &  opcode[0];

    wire f3_000;
    wire f3_001;
    wire f3_010;
    wire f3_100;
    wire f3_101;
    wire f3_110;
    wire f3_111;

    assign f3_000 = ~funct3[2] & ~funct3[1] & ~funct3[0];
    assign f3_001 = ~funct3[2] & ~funct3[1] &  funct3[0];
    assign f3_010 = ~funct3[2] &  funct3[1] & ~funct3[0];
    assign f3_100 =  funct3[2] & ~funct3[1] & ~funct3[0];
    assign f3_101 =  funct3[2] & ~funct3[1] &  funct3[0];
    assign f3_110 =  funct3[2] &  funct3[1] & ~funct3[0];
    assign f3_111 =  funct3[2] &  funct3[1] &  funct3[0];

    wire f7_alt;
    assign f7_alt = ~funct7[6] &  funct7[5] & ~funct7[4] & ~funct7[3] & ~funct7[2] & ~funct7[1] & ~funct7[0];

    wire is_alu_instr;
    assign is_alu_instr = is_rtype | is_ialu;

    assign RegWrite  = is_rtype | is_ialu | is_iload;
    assign ALUSrc    = is_ialu  | is_iload | is_stype;
    assign MemWrite  = is_stype;
    assign MemRead   = is_iload;
    assign ImmSel[0] = is_stype;
    assign ImmSel[1] = is_btype;

    assign ALUOp[2] = is_alu_instr & (f3_001 | f3_010 | f3_100 | f3_101);
    assign ALUOp[1] = is_alu_instr & (f3_010 | f3_101 | f3_110 | f3_111);
    assign ALUOp[0] = ( is_alu_instr & ( (f3_000 & is_rtype & f7_alt) | f3_001 | f3_010 | f3_110 ) ) | is_btype;

endmodule