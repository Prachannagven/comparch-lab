`timescale 1ns/1ps
module tb;
    reg clk;
    reg [31:0] oldpc;
    wire [31:0] newpc;

    dut dut (
        .oldpc(oldpc),
        .clk(clk),
        .newpc(newpc)
    );

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
        oldpc = 32'h0000_0000;
        #20;
        oldpc = 32'h0000_0004;
        #20;
        oldpc = 32'h0000_0008;
        #20;        
        $finish;
    end
endmodule
