`timescale 1ns/1ps
module dut (
    input wire clk,
    input wire rst,
    input wire [31:0] inst,
    output wire [31:0] rd_val
);

    fragment_r_type dut (
        .clk(clk),
        .rst(rst),
        .inst(inst),
        .rd_val(rd_val)
    );
    
endmodule