`timescale 1ns/1ps
module fragment_r_type (
    input wire clk,
    input wire rst,
    input wire [31:0] inst,
    output wire [31:0] rd_val
);

    wire [4:0]  rd     = inst[11:7];
    wire [4:0]  rs1    = inst[19:15];
    wire [4:0]  rs2    = inst[24:20];
    wire [2:0]  funct3 = inst[14:12];
    wire [6:0]  funct7 = inst[31:25];

    wire [31:0] rdata1, rdata2;
    wire [2:0]  alu_ctrl_sig;
    wire [31:0] alu_result;
    wire        alu_zero;

    reg_file u_reg_file (
        .wrEn(1'b1),
        .clk(clk),
        .rst(rst),
        .rdAddr1(rs1),
        .rdAddr2(rs2),
        .wrAddr(rd),
        .wrData(alu_result),
        .rdData1(rdata1),
        .rdData2(rdata2)
    );

    alu_ctrl u_alu_ctrl (
        .funct3(funct3),
        .funct7(funct7),
        .alu_ctrl(alu_ctrl_sig)
    );

    rv32ialu u_alu (
        .A(rdata1),
        .B(rdata2),
        .alu_ctrl(alu_ctrl_sig),
        .Y(alu_result),
        .zero(alu_zero)
    );

    assign rd_val = alu_result;

endmodule