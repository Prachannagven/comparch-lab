`timescale 1ns/1ps
module tb;
    reg clk;
    reg writeEn;
    reg [31:0] address;
    reg [31:0] writeData;
    wire [31:0] readData;

    dut dut (
        .clk(clk),
        .writeEn(writeEn),
        .address(address),
        .writeData(writeData),
        .readData(readData)
    );

    string vcd_file;
    initial begin
        if ($value$plusargs("vcd=%s", vcd_file)) $dumpfile(vcd_file);
        else $dumpfile("task3.vcd");
        clk = 0;
        writeEn = 0;
        address = 32'b0;
        writeData = 32'b0;
        $dumpvars(0, dut);
    end

    always #10 clk = ~clk;

    task check_read;
        input [31:0] addr;
        input [31:0] expected;
        begin
            address = addr;
            #1;
            if (readData !== expected) begin
                $display("FAIL: read @ %h = %h, expected %h", addr, readData, expected);
            end else begin
                $display("PASS: read @ %h = %h", addr, readData);
            end
        end
    endtask

    initial begin
        #2;

        writeEn = 1'b1;
        address = 32'h0000_0000;
        writeData = 32'hA1B2_C3D4;
        @(posedge clk);

        address = 32'h0000_0004;
        writeData = 32'h1122_3344;
        @(posedge clk);

        address = 32'h0000_0008;
        writeData = 32'hDEAD_BEEF;
        @(posedge clk);

        writeEn = 1'b0;

        check_read(32'h0000_0000, 32'hA1B2_C3D4);
        check_read(32'h0000_0004, 32'h1122_3344);
        check_read(32'h0000_0008, 32'hDEAD_BEEF);

        check_read(32'h0000_1000, 32'hA1B2_C3D4);

        #20;
        $finish;
    end
endmodule
