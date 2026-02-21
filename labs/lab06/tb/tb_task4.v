`timescale 1ns/1ps

module tb;
	reg  [31:0] instruction;
	wire RegWrite;
	wire ALUSrc;
	wire MemWrite;
	wire MemRead;
	wire [2:0] ALUOp;
	wire [1:0] ImmSel;

	dut dut (
		.instruction(instruction),
		.RegWrite(RegWrite),
		.ALUSrc(ALUSrc),
		.MemWrite(MemWrite),
		.MemRead(MemRead),
		.ALUOp(ALUOp),
		.ImmSel(ImmSel)
	);

	string vcd_file;
	integer pass_count;
	integer fail_count;

	function [31:0] r_inst;
		input [6:0] funct7;
		input [4:0] rs2;
		input [4:0] rs1;
		input [2:0] funct3;
		input [4:0] rd;
		begin
			r_inst = {funct7, rs2, rs1, funct3, rd, 7'b0110011};
		end
	endfunction

	function [31:0] i_inst;
		input [11:0] imm;
		input [4:0] rs1;
		input [2:0] funct3;
		input [4:0] rd;
		input [6:0] opcode;
		begin
			i_inst = {imm, rs1, funct3, rd, opcode};
		end
	endfunction

	function [31:0] s_inst;
		input [11:0] imm;
		input [4:0] rs2;
		input [4:0] rs1;
		input [2:0] funct3;
		begin
			s_inst = {imm[11:5], rs2, rs1, funct3, imm[4:0], 7'b0100011};
		end
	endfunction

	function [31:0] b_inst;
		input [12:0] imm;
		input [4:0] rs2;
		input [4:0] rs1;
		input [2:0] funct3;
		begin
			b_inst = {imm[12], imm[10:5], rs2, rs1, funct3, imm[4:1], imm[11], 7'b1100011};
		end
	endfunction

	task check_ctrl;
		input [255:0] name;
		input [31:0] inst;
		input exp_RegWrite;
		input exp_ALUSrc;
		input exp_MemWrite;
		input exp_MemRead;
		input [2:0] exp_ALUOp;
		input [1:0] exp_ImmSel;
		begin
			instruction = inst;
			#1;
			if (RegWrite !== exp_RegWrite ||
				ALUSrc   !== exp_ALUSrc   ||
				MemWrite !== exp_MemWrite ||
				MemRead  !== exp_MemRead  ||
				ALUOp    !== exp_ALUOp    ||
				ImmSel   !== exp_ImmSel) begin
				fail_count = fail_count + 1;
				$display("FAIL %-12s inst=%h got={RW:%b AS:%b MW:%b MR:%b OP:%b IM:%b} exp={RW:%b AS:%b MW:%b MR:%b OP:%b IM:%b}",
					name, inst,
					RegWrite, ALUSrc, MemWrite, MemRead, ALUOp, ImmSel,
					exp_RegWrite, exp_ALUSrc, exp_MemWrite, exp_MemRead, exp_ALUOp, exp_ImmSel);
			end else begin
				pass_count = pass_count + 1;
				$display("PASS %-12s inst=%h", name, inst);
			end
		end
	endtask

	initial begin
		if ($value$plusargs("vcd=%s", vcd_file)) $dumpfile(vcd_file);
		else $dumpfile("task4.vcd");
		$dumpvars(0, dut);
	end

	initial begin
		pass_count = 0;
		fail_count = 0;
		instruction = 32'b0;

		check_ctrl("ADD",  r_inst(7'b0000000, 5'd3, 5'd2, 3'b000, 5'd1), 1'b1, 1'b0, 1'b0, 1'b0, 3'b001, 2'b00);
		check_ctrl("SUB",  r_inst(7'b0100000, 5'd3, 5'd2, 3'b000, 5'd1), 1'b1, 1'b0, 1'b0, 1'b0, 3'b000, 2'b00);
		check_ctrl("AND",  r_inst(7'b0000000, 5'd3, 5'd2, 3'b111, 5'd1), 1'b1, 1'b0, 1'b0, 1'b0, 3'b010, 2'b00);
		check_ctrl("OR",   r_inst(7'b0000000, 5'd3, 5'd2, 3'b110, 5'd1), 1'b1, 1'b0, 1'b0, 1'b0, 3'b011, 2'b00);
		check_ctrl("SLL",  r_inst(7'b0000000, 5'd3, 5'd2, 3'b001, 5'd1), 1'b1, 1'b0, 1'b0, 1'b0, 3'b100, 2'b00);
		check_ctrl("SRL",  r_inst(7'b0000000, 5'd3, 5'd2, 3'b101, 5'd1), 1'b1, 1'b0, 1'b0, 1'b0, 3'b101, 2'b00);
		check_ctrl("SLT",  r_inst(7'b0000000, 5'd3, 5'd2, 3'b010, 5'd1), 1'b1, 1'b0, 1'b0, 1'b0, 3'b110, 2'b00);

		check_ctrl("ADDI", i_inst(12'd10, 5'd0, 3'b000, 5'd1, 7'b0010011), 1'b1, 1'b1, 1'b0, 1'b0, 3'b001, 2'b00);
		check_ctrl("ANDI", i_inst(12'd15, 5'd1, 3'b111, 5'd2, 7'b0010011), 1'b1, 1'b1, 1'b0, 1'b0, 3'b010, 2'b00);
		check_ctrl("ORI",  i_inst(12'd7,  5'd1, 3'b110, 5'd2, 7'b0010011), 1'b1, 1'b1, 1'b0, 1'b0, 3'b011, 2'b00);
		check_ctrl("SLTI", i_inst(12'd3,  5'd1, 3'b010, 5'd2, 7'b0010011), 1'b1, 1'b1, 1'b0, 1'b0, 3'b110, 2'b00);
		check_ctrl("SLLI", i_inst(12'h001,5'd1, 3'b001, 5'd2, 7'b0010011), 1'b1, 1'b1, 1'b0, 1'b0, 3'b100, 2'b00);
		check_ctrl("SRLI", i_inst(12'h001,5'd1, 3'b101, 5'd2, 7'b0010011), 1'b1, 1'b1, 1'b0, 1'b0, 3'b101, 2'b00);

		check_ctrl("LW",   i_inst(12'd8,  5'd0, 3'b010, 5'd4, 7'b0000011), 1'b1, 1'b1, 1'b0, 1'b1, 3'b001, 2'b00);
		check_ctrl("SW",   s_inst(12'd12, 5'd4, 5'd0, 3'b010),             1'b0, 1'b1, 1'b1, 1'b0, 3'b001, 2'b01);

		check_ctrl("BEQ",  b_inst(13'd16, 5'd2, 5'd1, 3'b000),             1'b0, 1'b0, 1'b0, 1'b0, 3'b000, 2'b10);
		check_ctrl("BNE",  b_inst(13'd20, 5'd2, 5'd1, 3'b001),             1'b0, 1'b0, 1'b0, 1'b0, 3'b000, 2'b10);
		check_ctrl("BLT",  b_inst(13'd24, 5'd2, 5'd1, 3'b100),             1'b0, 1'b0, 1'b0, 1'b0, 3'b110, 2'b10);
		check_ctrl("BGE",  b_inst(13'd28, 5'd2, 5'd1, 3'b101),             1'b0, 1'b0, 1'b0, 1'b0, 3'b110, 2'b10);

		check_ctrl("INVALID", 32'hFFFFFFFF, 1'b0, 1'b0, 1'b0, 1'b0, 3'b000, 2'b00);

		$display("----------------------------------------");
		$display("task4 controlunit TB summary: PASS=%0d FAIL=%0d", pass_count, fail_count);
		$display("----------------------------------------");
		#5;
		$finish;
	end
endmodule

