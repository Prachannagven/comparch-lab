module dut(
    input wire [3:0] a,
    input wire [3:0] b,
    input wire cin,
    input wire m,
    output wire [3:0] sum,
    output wire cout
);


    wire [3:0] b_mod;

    assign b_mod = m ? (~b + 1) : b;

    fourbitadd FBA(.a(a), .b(b_mod), .cin(cin), .sum(sum), .cout(cout));

endmodule