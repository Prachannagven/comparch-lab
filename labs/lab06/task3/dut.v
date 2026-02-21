`timescale 1ns/1ps
module dut (
    input wire clk,
    input wire writeEn,
    input wire [31:0] address,
    input wire [31:0] writeData,
    output wire [31:0] readData
);
    bankedmem mem (
        .clk(clk),
        .writeEn(writeEn),
        .address(address),
        .writeData(writeData),
        .readData(readData)
    );
endmodule