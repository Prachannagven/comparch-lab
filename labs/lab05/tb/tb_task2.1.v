`timescale 1ns/1ps
module tb;
    reg [4:0] rd;
    reg reg_write_en;
    wire [31:0] dec_out;
    
    dut dut (.rd(rd), .reg_write_en(reg_write_en), .dec_out(dec_out));

    string vcd_file;
    initial begin
        if ($value$plusargs("vcd=%s", vcd_file)) $dumpfile(vcd_file);
        else $dumpfile("fa.vcd");
        $dumpvars(0, dut);
    end

    // Initializing regsiters with some test values
    initial begin
        //Test case 1: reg_write_en = 0, rd = 5'd0
        reg_write_en = 0; rd = 5'd0;
        #20;

        //Test case 2: reg_write_en = 1, rd = 5'd0
        reg_write_en = 1; rd = 5'd0;
        #20;

        //Test case 3: reg_write_en = 1, rd = 5'd5
        reg_write_en = 1; rd = 5'd5;
        #20;

        //Test case 4: reg_write_en = 1, rd = 5'd31
        reg_write_en = 1; rd = 5'd31;
        #20;
    end
endmodule
