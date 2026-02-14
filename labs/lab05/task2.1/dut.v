`timescale 1ns/1ps
module dut (
    input wire [4:0] rd,
    input wire reg_write_en,
    output wire [31:0] dec_out
);
    decoder5to32 dec (
        .rd(rd),
        .reg_write_en(reg_write_en),
        .dec_out(dec_out)
    );
    
endmodule