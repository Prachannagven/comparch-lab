`timescale 1ns / 1ps
module mux4_1(
    input i0,
    input i1,
    input i2,
    input i3,
    input [1:0] s,
    output y
);
    wire m0;
    wire m1;

    mux2_1 u0(.a(i0), .b(i1), .s(s[0]), .y(m0));
    mux2_1 u1(.a(i2), .b(i3), .s(s[0]), .y(m1));
    mux2_1 u2(.a(m0), .b(m1), .s(s[1]), .y(y));
endmodule