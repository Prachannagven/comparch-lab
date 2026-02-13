`timescale 1ns / 1ps
module tb_task6;

    reg  [31:0] a, b;
    wire [31:0] result;

    integer pass_count, fail_count, test_num;

    dut uut (.a(a), .b(b), .result(result));

    string vcd_file;
    initial begin
        if ($value$plusargs("vcd=%s", vcd_file)) $dumpfile(vcd_file);
        else $dumpfile("sltu.vcd");
        $dumpvars(0, uut);
    end

    task check;
        input [31:0] expected;
        begin
            test_num = test_num + 1;
            if (result === expected) pass_count = pass_count + 1;
            else begin
                fail_count = fail_count + 1;
                $display("FAIL #%0d: a=%h, b=%h => %h (exp %h)", 
                         test_num, a, b, result, expected);
            end
        end
    endtask
    
    initial begin
        pass_count = 0; fail_count = 0; test_num = 0;
        a = 32'h0; b = 32'h0; #10;

        // Basic unsigned comparisons
        a = 32'd5;  b = 32'd10; #10; check(32'b1);  // 5 < 10
        a = 32'd10; b = 32'd5;  #10; check(32'b0);  // 10 > 5
        a = 32'd5;  b = 32'd5;  #10; check(32'b0);  // 5 == 5

        // Zero cases
        a = 32'd0; b = 32'd0; #10; check(32'b0);  // 0 == 0
        a = 32'd0; b = 32'd1; #10; check(32'b1);  // 0 < 1
        a = 32'd1; b = 32'd0; #10; check(32'b0);  // 1 > 0

        // Large unsigned values (these are negative in signed but large in unsigned)
        a = 32'hFFFFFFFF; b = 32'h00000001; #10; check(32'b0);  // max > 1
        a = 32'h00000001; b = 32'hFFFFFFFF; #10; check(32'b1);  // 1 < max
        a = 32'hFFFFFFFF; b = 32'hFFFFFFFF; #10; check(32'b0);  // max == max

        // 0x80000000 is 2147483648 unsigned (largest with MSB set)
        a = 32'h80000000; b = 32'h00000001; #10; check(32'b0);  // 2^31 > 1
        a = 32'h00000001; b = 32'h80000000; #10; check(32'b1);  // 1 < 2^31
        a = 32'h80000000; b = 32'h7FFFFFFF; #10; check(32'b0);  // 2^31 > 2^31-1
        a = 32'h7FFFFFFF; b = 32'h80000000; #10; check(32'b1);  // 2^31-1 < 2^31

        // Compare values in upper half (MSB = 1)
        a = 32'h80000000; b = 32'hFFFFFFFF; #10; check(32'b1);  // 2^31 < max
        a = 32'hFFFFFFFF; b = 32'h80000000; #10; check(32'b0);  // max > 2^31
        a = 32'hFFFFFFFE; b = 32'hFFFFFFFF; #10; check(32'b1);  // max-1 < max
        a = 32'h80000001; b = 32'h80000000; #10; check(32'b0);  // 2^31+1 > 2^31

        // Compare values in lower half (MSB = 0)
        a = 32'h7FFFFFFE; b = 32'h7FFFFFFF; #10; check(32'b1);  
        a = 32'h7FFFFFFF; b = 32'h7FFFFFFE; #10; check(32'b0);  
        a = 32'h00000000; b = 32'h7FFFFFFF; #10; check(32'b1);  
        a = 32'h7FFFFFFF; b = 32'h00000000; #10; check(32'b0);  

        // Edge: max values
        a = 32'hFFFFFFFE; b = 32'hFFFFFFFE; #10; check(32'b0);  // equal
        a = 32'h80000000; b = 32'h80000000; #10; check(32'b0);  // equal

        if (fail_count == 0) $display("All %0d tests passed", test_num);
        else $display("FAILED: %0d/%0d", fail_count, test_num);
        $finish;
    end

endmodule
