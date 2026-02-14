`timescale 1ns/1ps
module reg_file (
    input wire [4:0] rdAddr1,
    input wire [4:0] rdAddr2,
    input wire [4:0] wrAddr,
    input wire [31:0] wrData,
    input wire wrEn,
    input wire clk,
    input wire rst,
    output wire [31:0] rdData1,
    output wire [31:0] rdData2
);
    genvar i;
    wire [31:0] reg_outputs [0:31];
    wire we [0:31];

    generate for (i = 0; i < 32; i = i + 1) begin : reg_gen
        assign #2 we[i] = wrEn && (wrAddr == i) && (i != 0);                                //Disable writes to reg0; Delay of 2 because of and operation and equivalence check
        
        reg32 reg_i (
            .clk(clk),
            .rst(rst),
            .we(we[i]),
            .d(wrData),
            .q(reg_outputs[i])
        );
        assign #3 rdData1 = (rdAddr1 == i) ? ((i == 0) ? 32'b0 : reg_outputs[i]) : 32'bz;   //Delay of 1 because of mux select; reg0 is always 0
        assign #3 rdData2 = (rdAddr2 == i) ? ((i == 0) ? 32'b0 : reg_outputs[i]) : 32'bz;   //Delay of 1 because of mux select; reg0 is always 0
    end
    endgenerate


    
endmodule