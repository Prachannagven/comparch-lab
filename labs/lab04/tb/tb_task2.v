`timescale 1ns / 1ps
module tb_alulogi;

    reg  [31:0] a, b;
    reg         op;
    wire [31:0] result;

    dut uut (.a(a), .b(b), .op(op), .result(result));

    string vcd_file;
    initial begin
        if ($value$plusargs("vcd=%s", vcd_file)) $dumpfile(vcd_file);
        else $dumpfile("fa.vcd");
        $dumpvars(0, uut);
    end
    
    initial begin
        a = 32'h0; b = 32'h0; op = 0; #10;

        // AND tests
        a = 32'h00000000; b = 32'h00000000; op = 0; #10;
        a = 32'hFFFFFFFF; b = 32'hFFFFFFFF; op = 0; #10;
        a = 32'hA5A5A5A5; b = 32'h5A5A5A5A; op = 0; #10;
        a = 32'h12345678; b = 32'h87654321; op = 0; #10;
        a = 32'hFFFFFFFF; b = 32'h00000000; op = 0; #10;

        // OR tests
        a = 32'h00000000; b = 32'h00000000; op = 1; #10;
        a = 32'hFFFFFFFF; b = 32'hFFFFFFFF; op = 1; #10;
        a = 32'hA5A5A5A5; b = 32'h5A5A5A5A; op = 1; #10;
        a = 32'h12345678; b = 32'h87654321; op = 1; #10;
        a = 32'hFFFFFFFF; b = 32'h00000000; op = 1; #10;

        $finish;
    end

endmodule
