`timescale 1ns/1ps
module reg32 (
    input wire clk,
    input wire rst,
    input wire we,
    input wire [31:0] d,
    output reg [31:0] q
);
    
always @(posedge clk) begin
    if (rst) begin
        #1
         q <= 0;
    end else if (we) begin
        #1 q <= d;
    end
end

endmodule