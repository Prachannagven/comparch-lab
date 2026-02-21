`timescale 1ns/1ps
module bankedmem (
    input wire clk,
    input wire writeEn,
    input wire [31:0] address,
    input wire [31:0] writeData,
    output wire [31:0] readData
);
    reg [7:0] b0 [0:1023];
    reg [7:0] b1 [0:1023];
    reg [7:0] b2 [0:1023];
    reg [7:0] b3 [0:1023];

    always @(posedge clk) begin
        if (writeEn) begin
            b0[address[11:2]] <= writeData[7:0];
            b1[address[11:2]] <= writeData[15:8];
            b2[address[11:2]] <= writeData[23:16];
            b3[address[11:2]] <= writeData[31:24];
        end
    end

    assign readData = {b3[address[11:2]], b2[address[11:2]], b1[address[11:2]], b0[address[11:2]]};

    
endmodule