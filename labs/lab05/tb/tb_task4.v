`timescale 1ns/1ps

module tb;
    reg clk, rst;
    reg [31:0] inst;
    wire [31:0] rd_val;

    dut uut (.clk(clk), .rst(rst), .inst(inst), .rd_val(rd_val));

    string vcd_file;
    initial begin
        if ($value$plusargs("vcd=%s", vcd_file)) $dumpfile(vcd_file);
        else $dumpfile("task4.vcd");
        $dumpvars(0, uut);
    end

    always #10 clk = ~clk;

    // R-type instruction builder
    function [31:0] r_inst(input [6:0] f7, input [4:0] rs2, input [4:0] rs1, input [2:0] f3, input [4:0] rd);
        r_inst = {f7, rs2, rs1, f3, rd, 7'b0110011};
    endfunction

    initial begin
        clk = 0; rst = 1; inst = 0;
        #25 rst = 0;
        #15;

        $display("Testing R-type instructions (all regs start at 0)");

        // ADD x0, x0, x0
        inst = r_inst(7'b0000000, 0, 0, 3'b000, 0);
        @(posedge clk); #5;
        $display("ADD x0,x0,x0 -> %0d (exp: 0)", rd_val);

        // SUB x1, x0, x0
        inst = r_inst(7'b0100000, 0, 0, 3'b000, 1);
        @(posedge clk); #5;
        $display("SUB x1,x0,x0 -> %0d (exp: 0)", rd_val);

        // AND x2, x0, x0
        inst = r_inst(7'b0000000, 0, 0, 3'b111, 2);
        @(posedge clk); #5;
        $display("AND x2,x0,x0 -> %0d (exp: 0)", rd_val);

        // OR x3, x0, x0
        inst = r_inst(7'b0000000, 0, 0, 3'b110, 3);
        @(posedge clk); #5;
        $display("OR  x3,x0,x0 -> %0d (exp: 0)", rd_val);

        // SLL x4, x0, x0
        inst = r_inst(7'b0000000, 0, 0, 3'b001, 4);
        @(posedge clk); #5;
        $display("SLL x4,x0,x0 -> %0d (exp: 0)", rd_val);

        // SLT x5, x0, x0
        inst = r_inst(7'b0000000, 0, 0, 3'b010, 5);
        @(posedge clk); #5;
        $display("SLT x5,x0,x0 -> %0d (exp: 0)", rd_val);

        // ADD x6, x1, x2 (field extraction test)
        inst = r_inst(7'b0000000, 2, 1, 3'b000, 6);
        @(posedge clk); #5;
        $display("ADD x6,x1,x2 -> %0d", rd_val);

        $display("Done");
        #20 $finish;
    end

endmodule