module pcinc (
    input wire [31:0] oldpc,
    input wire clk,
    output reg [31:0]newpc
);
    always @(posedge clk) begin
        newpc <= oldpc + 4;
    end
endmodule