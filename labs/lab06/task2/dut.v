module dut (
    input wire [31:0] oldpc,
    input wire clk,
    output reg [31:0] newpc
);
    pcinc pcinc (
        .oldpc(oldpc),
        .clk(clk),
        .newpc(newpc)
    );
    
endmodule