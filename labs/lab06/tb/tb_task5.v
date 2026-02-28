`timescale 1ns/1ps

module tb;

    reg clk, rst;

    cpu_sc_part cpu (.clk(clk), .rst(rst));

    // 10ns clock
    initial clk = 0;
    always #5 clk = ~clk;

    integer pass_count = 0;
    integer fail_count = 0;

    task check_reg;
        input [4:0]   reg_num;
        input [31:0]  expected;
        input [255:0] name;
        reg   [31:0]  actual;
        begin
            case (reg_num)
                5'd1: actual = cpu.RF.reg_gen[1].reg_i.q;
                5'd2: actual = cpu.RF.reg_gen[2].reg_i.q;
                5'd3: actual = cpu.RF.reg_gen[3].reg_i.q;
                5'd4: actual = cpu.RF.reg_gen[4].reg_i.q;
                5'd5: actual = cpu.RF.reg_gen[5].reg_i.q;
                default: actual = 32'hDEADBEEF;
            endcase
            if (actual === expected) begin
                $display("PASS: %0s = %0d", name, actual);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: %0s = %0d (expected %0d)", name, actual, expected);
                fail_count = fail_count + 1;
            end
        end
    endtask
    
    string vcd_file;
    initial begin
		if ($value$plusargs("vcd=%s", vcd_file)) $dumpfile(vcd_file);
		else $dumpfile("task5.vcd");
		$dumpvars(0, tb);
	end

    initial begin

        // --- Load program into IMEM ---
        // 0x00: addi x1, x0, 10   -> 0x00A00093
        cpu.IMEM.b0[0] = 8'h93;  cpu.IMEM.b1[0] = 8'h00;
        cpu.IMEM.b2[0] = 8'hA0;  cpu.IMEM.b3[0] = 8'h00;

        // 0x04: addi x2, x0, 20   -> 0x01400113
        cpu.IMEM.b0[1] = 8'h13;  cpu.IMEM.b1[1] = 8'h01;
        cpu.IMEM.b2[1] = 8'h40;  cpu.IMEM.b3[1] = 8'h01;

        // 0x08: add  x3, x1, x2   -> 0x002081B3
        cpu.IMEM.b0[2] = 8'hB3;  cpu.IMEM.b1[2] = 8'h81;
        cpu.IMEM.b2[2] = 8'h20;  cpu.IMEM.b3[2] = 8'h00;

        // 0x0C: sw   x3, 0(x0)    -> 0x00302023
        cpu.IMEM.b0[3] = 8'h23;  cpu.IMEM.b1[3] = 8'h20;
        cpu.IMEM.b2[3] = 8'h30;  cpu.IMEM.b3[3] = 8'h00;

        // 0x10: lw   x4, 0(x0)    -> 0x00002203
        cpu.IMEM.b0[4] = 8'h03;  cpu.IMEM.b1[4] = 8'h22;
        cpu.IMEM.b2[4] = 8'h00;  cpu.IMEM.b3[4] = 8'h00;

        // 0x14: sub  x5, x4, x1   -> 0x401202B3
        cpu.IMEM.b0[5] = 8'hB3;  cpu.IMEM.b1[5] = 8'h02;
        cpu.IMEM.b2[5] = 8'h12;  cpu.IMEM.b3[5] = 8'h40;

        // Reset
        rst = 1;
        @(posedge clk); #1;
        rst = 0;

        // Run 6 cycles (one per instruction)
        repeat (6) @(posedge clk);
        #2;

        // Verify register values
        check_reg(5'd1, 32'd10, "x1");   // addi x1, x0, 10
        check_reg(5'd2, 32'd20, "x2");   // addi x2, x0, 20
        check_reg(5'd3, 32'd30, "x3");   // add  x3, x1, x2
        check_reg(5'd4, 32'd30, "x4");   // lw   x4, 0(x0)
        check_reg(5'd5, 32'd20, "x5");   // sub  x5, x4, x1

        $display("\nResults: %0d passed, %0d failed", pass_count, fail_count);
        $finish;
    end

endmodule
