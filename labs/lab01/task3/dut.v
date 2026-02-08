module dut(
    input wire a,
    input wire b,
    input wire cin,
    output reg sum,
    output reg cout
);

    always @(*) begin
       sum = a ^ b ^ cin;
       cout = (a & b) | (b & cin) | (a & cin); 
    end

endmodule