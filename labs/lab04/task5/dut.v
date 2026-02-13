`timescale 1ns / 1ps
module dut (
    input  signed [31:0] A,
    input  signed [31:0] B,
    input         [2:0]  alu_ctrl,
    output signed [31:0] Y,
    output               zero
);

    rv32ialu alu_inst (
        .A(A),
        .B(B),
        .alu_ctrl(alu_ctrl),
        .Y(Y),
        .zero(zero)
    );

endmodule
