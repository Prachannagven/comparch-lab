`timescale 1ns/1ps
module dut (
    input wire [4:0] rdAddr1,
    input wire [4:0] rdAddr2,
    input wire [4:0] wrAddr,
    input wire [31:0] wrData,
    input wire wrEn,
    input wire clk,
    input wire rst,
    output wire [31:0] rdData1,
    output wire [31:0] rdData2
);
    reg_file rf (
        .rdAddr1(rdAddr1),
        .rdAddr2(rdAddr2),
        .wrAddr(wrAddr),
        .wrData(wrData),
        .wrEn(wrEn),
        .clk(clk),
        .rst(rst),
        .rdData1(rdData1),
        .rdData2(rdData2)
    ); 
    
     
    
endmodule