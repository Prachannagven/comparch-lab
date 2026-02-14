`timescale 1ns/1ps
module tb;
    reg clk, rst;
    reg [4:0] rdAddr1, rdAddr2, wrAddr;
    reg [31:0] wrData;
    reg wrEn;
    wire [31:0] rdData1, rdData2;
    
    dut dut (.clk(clk), .rst(rst), .rdAddr1(rdAddr1), .rdAddr2(rdAddr2), .wrAddr(wrAddr), .wrData(wrData), .wrEn(wrEn), .rdData1(rdData1), .rdData2(rdData2));

    string vcd_file;
    initial begin
        if ($value$plusargs("vcd=%s", vcd_file)) $dumpfile(vcd_file);
        else $dumpfile("fa.vcd");
        clk = 0;
        $dumpvars(0, dut);
    end

        // Initializing regsiters with some test values
    initial begin
        #1;
        clk = 0; rst = 1; wrEn = 0; wrData = 32'b0; wrAddr = 5'b0;
        clk = 1; rst = 0; wrEn = 1; wrData = 32'h00000014; wrAddr = 5'b00011; // x2
        #10;
        clk = 0;
    end

    always begin
        clk = ~clk;
        #10;
    end


    initial begin
        rst = 1; rdAddr1 = 5'd0; rdAddr2 = 5'd1;
        #100;
        rst = 0;
        #10;
        rdAddr1 = 5'd2; rdAddr2 = 5'd3; #10;
        $finish;
    end
endmodule
