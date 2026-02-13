`timescale 1ns / 1ps

// Testbench for rv32ialu
module tb_task5;

    reg signed [31:0] A, B;
    reg [2:0] alu_ctrl;
    wire signed [31:0] Y;
    wire zero;

    dut DUT (.A(A), .B(B), .alu_ctrl(alu_ctrl), .Y(Y), .zero(zero));

    string vcd_file;
    initial begin
        if ($value$plusargs("vcd=%s", vcd_file))
            $dumpfile(vcd_file);
        else
            $dumpfile("task5_tb_task5.vcd");
        $dumpvars(0, DUT);
    end

    initial begin
        A = 32'd20; B = 32'd5; alu_ctrl = 3'b000; #10;  // SUB
        A = 32'd10; B = 32'd25; alu_ctrl = 3'b001; #10; // ADD
        A = -32'd15; B = 32'd15; alu_ctrl = 3'b001; #10; // ADD zero
        A = 32'hFF00FF00; B = 32'h0F0F0F0F; alu_ctrl = 3'b010; #10; // AND
        A = 32'hFF00FF00; B = 32'h0F0F0F0F; alu_ctrl = 3'b011; #10; // OR
        A = 32'h00000001; B = 32'd4; alu_ctrl = 3'b100; #10; // SLL
        A = 32'h80000000; B = 32'd4; alu_ctrl = 3'b101; #10; // SRL
        A = -32'd10; B = 32'd5; alu_ctrl = 3'b110; #10; // SLT true
        A = 32'd10; B = 32'd5; alu_ctrl = 3'b110; #10;  // SLT false
        A = 32'd100; B = 32'd200; alu_ctrl = 3'b111; #10; // Reserved
        $finish;
    end

endmodule
