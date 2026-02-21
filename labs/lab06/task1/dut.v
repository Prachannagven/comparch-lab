`timescale 1ns/1ps
module dut (
    input wire [31:0] instr,
    input wire [1:0] imm_sel,
    output wire [31:0] imm
);
    wire [31:0] i_imm;
    wire [31:0] s_imm;
    wire [31:0] b_imm;

    i_imm_assembler i_assembler (
        .instr(instr),
        .imm(i_imm)
    );
    s_imm_assembler s_assembler (
        .instr(instr),
        .imm(s_imm)
    );
    b_imm_assembler b_assembler (
        .instr(instr),
        .imm(b_imm)
    );

    mux_32_wide mux (
        .sel(imm_sel),
        .in1(i_imm),
        .in2(s_imm),
        .in3(b_imm),
        .out(imm)
    );

endmodule