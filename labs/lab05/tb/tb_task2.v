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

    always begin
        clk = ~clk;
        #10;
    end

    // Initializing regsiters with some test values
    initial begin
        //Resetting
        rst = 1;
        #20;
        rst = 0;

        /* Filling the registers with some values for testing */
        //x0
        wrEn = 1; 
        wrData = 32'hABCD1234; wrAddr = 5'd0;   // Should not work, proof
        #20
        wrEn = 0;
        #10;

        //x1
        wrEn = 1; 
        wrData = 32'hABCD1234; wrAddr = 5'd1;   //x1
        #20
        wrEn = 0;
        #10;

        //x2
        wrEn = 1; 
        wrData = 32'h00000014; wrAddr = 5'd2;   //x2
        #20
        wrEn = 0;
        #10;

        //x3
        wrEn = 1; 
        wrData = 32'h00000064; wrAddr = 5'd3;   //x3
        #20
        wrEn = 0; wrData = 0; wrAddr = 0;
        #10;

        /* Now Reading the values back and testing read delay */
        rdAddr1 = 5'd0; rdAddr2 = 5'd1;
        #10;
        rdAddr1 = 5'd1; rdAddr2 = 5'd2;
        #10;
        rdAddr1 = 5'd2; rdAddr2 = 5'd3;
        #10;
        rdAddr1 = 5'd3; rdAddr2 = 5'd4;
        #10;
        $finish;
    end
endmodule
