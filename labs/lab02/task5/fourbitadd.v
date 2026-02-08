module fourbitadd(
    input [3:0]a,
    input [3:0]b,
    input cin,
    output [3:0]sum,
    output cout
);

wire[3:1]cint;

fa FA0(.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(cint[1]));
fa FA1(.a(a[1]), .b(b[1]), .cin(cint[1]), .sum(sum[1]), .cout(cint[2])); 
fa FA2(.a(a[2]), .b(b[2]), .cin(cint[2]), .sum(sum[2]), .cout(cint[3])); 
fa FA3(.a(a[3]), .b(b[3]), .cin(cint[3]), .sum(sum[3]), .cout(cout));     

endmodule