`timescale 1ns/1ps
module tb;
    reg clk, rst, we;
    reg [31:0] d;
    wire [31:0] q;
    
    dut dut (.clk(clk), .rst(rst), .we(we), .d(d), .q(q));

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


    initial begin
        rst = 1; we = 0; 
        #10;
        rst = 0;
        #10;
        d = 32'hDEADBEEF; we = 1; #10;
        we=0; #10;
        $finish;
    end
endmodule
