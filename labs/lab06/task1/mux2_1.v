`timescale 1ns / 1ps
module mux2_1(
    input a,
    input b,
    input s,
    output y
);
    wire ns;
    wire y0;
    wire y1;

    not (ns, s);
    and (y0, a, ns);
    and (y1, b, s);
    or  (y, y0, y1);
endmodule