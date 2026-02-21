`timescale 1ns/1ps
module tb;
    reg [31:0] intr;
    reg [1:0] imm_sel;
    wire [31:0] imm;

    dut dut (
        .instr(intr),
        .imm_sel(imm_sel),
        .imm(imm)
    );

    string vcd_file;
    initial begin
        if ($value$plusargs("vcd=%s", vcd_file)) $dumpfile(vcd_file);
        else $dumpfile("fa.vcd");
        $dumpvars(0, dut);
    end

    // Initializing regsiters with some test values
    initial begin
        // ADDI X1, X0, 7 -> 0x00700093 (I-Type)
        intr = 32'h00700093;
        imm_sel = 2'b00;
        #10;

        // ANDI X4, X1, 43 -> 0x02b0f213 (I-Type)
        intr = 32'h02b0f213;
        imm_sel = 2'b00;
        #10;

        // SW X4, 25(x) -> 0x00402ca3
        intr = 32'h00402ca3;
        imm_sel = 2'b01;
        #10;

        // BEQ X0, X4, 8 -> 0x00400463 (B-Type)
        intr = 32'h00400463;
        imm_sel = 2'b10;
        #10;
    end

endmodule
