`timescale 1ns / 1ps
module tb_alucomp;

    reg  [31:0] a, b;
    wire [31:0] result;

    integer pass_count, fail_count, test_num;

    dut uut (.a(a), .b(b), .result(result));

    string vcd_file;
    initial begin
        if ($value$plusargs("vcd=%s", vcd_file)) $dumpfile(vcd_file);
        else $dumpfile("alucomp.vcd");
        $dumpvars(0, uut);
    end

    task check;
        input [31:0] expected;
        begin
            test_num = test_num + 1;
            if (result === expected) pass_count = pass_count + 1;
            else begin
                fail_count = fail_count + 1;
                $display("FAIL #%0d: a=%h (%0d), b=%h (%0d) => %h (exp %h)", 
                         test_num, a, $signed(a), b, $signed(b), result, expected);
            end
        end
    endtask
    
    initial begin
        pass_count = 0; fail_count = 0; test_num = 0;
        a = 32'h0; b = 32'h0; #10;

        // Basic positive
        a = 32'd5;  b = 32'd10; #10; check(32'b1);
        a = 32'd10; b = 32'd5;  #10; check(32'b0);
        a = 32'd5;  b = 32'd5;  #10; check(32'b0);

        // Basic negative
        a = -32'd5; b = -32'd3; #10; check(32'b1);
        a = -32'd3; b = -32'd5; #10; check(32'b0);
        a = -32'd5; b = -32'd5; #10; check(32'b0);

        // Mixed sign
        a = -32'd1;   b = 32'd1;    #10; check(32'b1);
        a = 32'd1;    b = -32'd1;   #10; check(32'b0);
        a = -32'd100; b = 32'd100;  #10; check(32'b1);
        a = 32'd100;  b = -32'd100; #10; check(32'b0);

        // Zero cases
        a = 32'd0;  b = 32'd0;  #10; check(32'b0);
        a = -32'd1; b = 32'd0;  #10; check(32'b1);
        a = 32'd0;  b = -32'd1; #10; check(32'b0);
        a = 32'd0;  b = 32'd1;  #10; check(32'b1);

        // Overflow cases
        a = 32'h7FFFFFFF; b = 32'h80000000; #10; check(32'b0);
        a = 32'h80000000; b = 32'h7FFFFFFF; #10; check(32'b1);
        a = 32'h7FFFFFF0; b = 32'h80000010; #10; check(32'b0);
        a = 32'h80000010; b = 32'h7FFFFFF0; #10; check(32'b1);

        // Edge cases
        a = 32'h80000000; b = 32'h80000000; #10; check(32'b0);
        a = 32'h7FFFFFFF; b = 32'h7FFFFFFF; #10; check(32'b0);
        a = 32'h80000000; b = 32'h80000001; #10; check(32'b1);
        a = 32'h7FFFFFFE; b = 32'h7FFFFFFF; #10; check(32'b1);
        a = 32'hFFFFFFFF; b = 32'h7FFFFFFF; #10; check(32'b1);
        a = 32'h80000000; b = 32'hFFFFFFFF; #10; check(32'b1);

        if (fail_count == 0) $display("All %0d tests passed", test_num);
        else $display("FAILED: %0d/%0d", fail_count, test_num);
        $finish;
    end

endmodule
