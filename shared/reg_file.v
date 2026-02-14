`timescale 1ns/1ps
module reg_file (
    input wire wrEn,
    input wire clk,
    input wire rst,
    input wire [4:0] rdAddr1,
    input wire [4:0] rdAddr2,
    input wire [4:0] wrAddr,
    input wire [31:0] wrData,
    output wire [31:0] rdData1,
    output wire [31:0] rdData2
);
    genvar i;
    wire [31:0] reg_outputs [0:31];
    wire we [0:31];
    wire [31:0] dec_out;

    // Decoder to generate one-hot write enable signals
    decoder5to32 dec (
        .rd(wrAddr),
        .reg_write_en(wrEn),
        .dec_out(dec_out)
    );

    generate for (i = 0; i < 32; i = i + 1) begin : reg_gen
        assign #1 we[i] = (i == 0) ? 1'b0 : dec_out[i];
        
        reg32 reg_i (
            .clk(clk),
            .rst(rst),
            .we(we[i]),
            .d(wrData),
            .q(reg_outputs[i])
        );
        assign #2 rdData1 = (rdAddr1 == i) ? reg_outputs[i] : 32'bz;   //Delay of 2 because of mux select and comparison; 
        assign #2 rdData2 = (rdAddr2 == i) ? reg_outputs[i] : 32'bz;   //Delay of 2 because of mux select and comparison; 
    end
    endgenerate


    
endmodule