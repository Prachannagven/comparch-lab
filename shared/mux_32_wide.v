`timescale 1ns / 1ps
module mux_32_wide #(parameter WIDTH = 32)(
    input [WIDTH-1:0] in1,
    input [WIDTH-1:0] in2,
    input [WIDTH-1:0] in3,
    input [WIDTH-1:0] in4,
    input [1:0] sel,
    output [WIDTH-1:0] out
);
    genvar bit_idx;
    generate
        for (bit_idx = 0; bit_idx < WIDTH; bit_idx = bit_idx + 1) begin : g_mux
            mux4_1 u_mux(
                .i0(in1[bit_idx]),
                .i1(in2[bit_idx]),
                .i2(in3[bit_idx]),
                .i3(in4[bit_idx]),
                .s(sel),
                .y(out[bit_idx])
            );
        end
    endgenerate
endmodule