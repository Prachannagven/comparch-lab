`timescale 1ns/1ps
module tb;
    reg [31:0] a, b;
    reg sub;
    wire signed [31:0] result;
    wire pos_overflow, neg_overflow;

    dut dut (.a(a), .b(b), .sub(sub), .result(result), 
             .pos_overflow(pos_overflow), .neg_overflow(neg_overflow));

    integer error_count, test_count;
    string vcd_file;

    initial begin
        if ($value$plusargs("vcd=%s", vcd_file)) $dumpfile(vcd_file);
        else $dumpfile("fa.vcd");
        $dumpvars(0, dut);
    end

    task check;
        input [31:0] exp_result;
        input exp_pos_ovf, exp_neg_ovf;
        begin
            test_count = test_count + 1;
            if (result !== exp_result || pos_overflow !== exp_pos_ovf || neg_overflow !== exp_neg_ovf) begin
                error_count = error_count + 1;
                $display("FAIL #%0d: a=%h, b=%h, sub=%b => got %h (exp %h), pos=%b, neg=%b",
                         test_count, a, b, sub, result, exp_result, pos_overflow, neg_overflow);
            end
        end
    endtask

    initial begin
        error_count = 0;
        test_count = 0;

        // Addition
        a = 32'h00000000; b = 32'h00000000; sub = 0; #10; check(32'h00000000, 0, 0);
        a = 32'h00000001; b = 32'h00000001; sub = 0; #10; check(32'h00000002, 0, 0);
        a = 32'hFFFFFFFF; b = 32'h00000001; sub = 0; #10; check(32'h00000000, 0, 0);
        a = 32'h7FFFFFFF; b = 32'h00000001; sub = 0; #10; check(32'h80000000, 1, 0); // pos overflow
        a = 32'h80000000; b = 32'hFFFFFFFF; sub = 0; #10; check(32'h7FFFFFFF, 0, 1); // neg overflow
        a = 32'h40000000; b = 32'h40000000; sub = 0; #10; check(32'h80000000, 1, 0);
        a = 32'h80000000; b = 32'h80000000; sub = 0; #10; check(32'h00000000, 0, 1);

        // Subtraction
        a = 32'h00000000; b = 32'h00000000; sub = 1; #10; check(32'h00000000, 0, 0);
        a = 32'h00000001; b = 32'h00000001; sub = 1; #10; check(32'h00000000, 0, 0);
        a = 32'hFFFFFFFF; b = 32'h00000001; sub = 1; #10; check(32'hFFFFFFFE, 0, 0);
        a = 32'h00009644; b = 32'h000185EF; sub = 1; #10; check(32'hFFFF1055, 0, 0);
        a = 32'h7FFFFFFF; b = 32'hFFFFFFFF; sub = 1; #10; check(32'h80000000, 1, 0); // pos overflow
        a = 32'h80000000; b = 32'h00000001; sub = 1; #10; check(32'h7FFFFFFF, 0, 1); // neg overflow

        if (error_count == 0) $display("All %0d tests passed", test_count);
        else $display("FAILED: %0d/%0d", error_count, test_count);
        $finish;
    end
endmodule
