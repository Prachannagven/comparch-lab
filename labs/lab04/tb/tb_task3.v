`timescale 1ns / 1ps
module tb_alushift;

    reg  [31:0] a;
    reg  [4:0]  b;
    reg         op;
    wire [31:0] result;

    integer pass_count, fail_count, test_num;

    dut uut (.a(a), .b(b), .op(op), .result(result));

    string vcd_file;
    initial begin
        if ($value$plusargs("vcd=%s", vcd_file)) $dumpfile(vcd_file);
        else $dumpfile("alushift.vcd");
        $dumpvars(0, uut);
    end

    task check;
        input [31:0] expected;
        begin
            test_num = test_num + 1;
            if (result === expected) pass_count = pass_count + 1;
            else begin
                fail_count = fail_count + 1;
                $display("FAIL #%0d: a=%h, shamt=%0d, op=%b => %h (exp %h)", 
                         test_num, a, b, op, result, expected);
            end
        end
    endtask
    
    initial begin
        pass_count = 0; fail_count = 0; test_num = 0;
        a = 32'h0; b = 5'h0; op = 0; #10;

        // Shift by 0
        a = 32'h12345678; b = 5'h00; op = 0; #10; check(32'h12345678);
        a = 32'h12345678; b = 5'h00; op = 1; #10; check(32'h12345678);

        // Shift by 1
        a = 32'h12345678; b = 5'h01; op = 0; #10; check(32'h2468ACF0);
        a = 32'h12345678; b = 5'h01; op = 1; #10; check(32'h091A2B3C);
        a = 32'h80000001; b = 5'h01; op = 0; #10; check(32'h00000002);
        a = 32'h80000000; b = 5'h01; op = 1; #10; check(32'h40000000);

        // Shift by 31 (max)
        a = 32'h00000001; b = 5'h1F; op = 0; #10; check(32'h80000000);
        a = 32'h80000000; b = 5'h1F; op = 1; #10; check(32'h00000001);
        a = 32'hAAAAAAAA; b = 5'h1F; op = 0; #10; check(32'h00000000);
        a = 32'hAAAAAAAA; b = 5'h1F; op = 1; #10; check(32'h00000001);

        // Edge cases
        a = 32'h00000000; b = 5'h10; op = 0; #10; check(32'h00000000);
        a = 32'hFFFFFFFF; b = 5'h10; op = 1; #10; check(32'h0000FFFF);
        a = 32'hFFFFFFFF; b = 5'h1F; op = 0; #10; check(32'h80000000);
        a = 32'hFFFFFFFF; b = 5'h1F; op = 1; #10; check(32'h00000001);

        if (fail_count == 0) $display("All %0d tests passed", test_num);
        else $display("FAILED: %0d/%0d", fail_count, test_num);
        $finish;
    end

endmodule
