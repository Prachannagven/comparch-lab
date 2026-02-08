module dut(
    input wire a,
    input wire b,
    input wire cin,
    output wire sum,
    output wire cout
);

    // Full adder logic using structural verilog
    wire axb;
    wire ab, bc, ac;

    xor (axb, a, b);
    xor (sum, axb, cin);

    and (ab, a, b);
    and (bc, b, cin);
    and (ac, a, cin);

    or  (cout, ab, bc, ac);

endmodule