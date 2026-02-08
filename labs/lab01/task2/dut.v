module dut(
    input wire a,
    input wire b,
    input wire cin,
    output wire sum,
    output wire cout
);

    // Full adder logic using structural verilog
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);

endmodule