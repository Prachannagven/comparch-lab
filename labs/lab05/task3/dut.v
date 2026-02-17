`timescale 1ns/1ps
module dut (
    input wire  [2:0] funct3,
    input wire  [6:0] funct7,
    output wire [2:0] alu_ctrl 
);
    alu_ctrl dut(
        .funct3(funct3),
        .funct7(funct7),
        .alu_ctrl(alu_ctrl)
    );
    
endmodule