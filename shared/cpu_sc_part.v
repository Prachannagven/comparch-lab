`timescale 1ns/1ps
module cpu_sc_part (
    input wire clk,
    input wire rst
);

    // --- Fetch ---

    wire [31:0] pc, next_pc, pc_plus_4;
    wire [31:0] instruction;

    reg32 PC_REG (
        .clk(clk), 
        .rst(rst), 
        .we(1'b1),
        .d(next_pc), 
        .q(pc)
    );

    assign pc_plus_4 = pc + 32'd4;

    bankedmem IMEM (
        .clk(clk), 
        .writeEn(1'b0),
        .address(pc), 
        .writeData(32'b0),
        .readData(instruction)
    );

    // --- Decode ---

    wire        RegWrite, ALUSrc, MemWrite, MemRead;
    wire [2:0]  ALUOp;
    wire [1:0]  ImmSel;

    controlunit CU (
        .instruction(instruction),
        .RegWrite(RegWrite), 
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite), 
        .MemRead(MemRead),
        .ALUOp(ALUOp), 
        .ImmSel(ImmSel)
    );

    // ImmGen: all three assemblers run in parallel, mux picks via ImmSel
    wire [31:0] i_imm, s_imm, b_imm, imm;

    i_imm_assembler I_IMM (.instr(instruction), .imm(i_imm));
    s_imm_assembler S_IMM (.instr(instruction), .imm(s_imm));
    b_imm_assembler B_IMM (.instr(instruction), .imm(b_imm));

    // ImmSel: 00=I, 01=S, 10=B
    mux_32_wide #(.WIDTH(32)) IMM_MUX (
        .in1(i_imm), .in2(s_imm), .in3(b_imm), .in4(32'b0),
        .sel(ImmSel), .out(imm)
    );

    wire [31:0] rd_data1, rd_data2, wb_data;

    reg_file RF (
        .wrEn(RegWrite), .clk(clk), .rst(rst),
        .rdAddr1(instruction[19:15]),   // rs1
        .rdAddr2(instruction[24:20]),   // rs2
        .wrAddr(instruction[11:7]),     // rd
        .wrData(wb_data),
        .rdData1(rd_data1), .rdData2(rd_data2)
    );

    // --- Execute ---

    // ALUSrc mux: 0 = rs2, 1 = immediate
    wire [31:0] alu_b;
    assign alu_b = ALUSrc ? imm : rd_data2;

    // Derive ALU control from instruction funct fields
    wire [2:0] alu_funct_ctrl;
    alu_ctrl ALU_CTRL (
        .funct3(instruction[14:12]),
        .funct7(instruction[31:25]),
        .alu_ctrl(alu_funct_ctrl)
    );

    // Override for load/store (ADD for addr calc) and branch (SUB for compare)
    wire [2:0] alu_ctrl_sig;
    assign alu_ctrl_sig = (MemRead | MemWrite) ? 3'b001 :
                          ImmSel[1]            ? 3'b000 :
                                                 alu_funct_ctrl;

    wire [31:0] alu_result;
    wire        zero;

    rv32ialu ALU (
        .A(rd_data1), 
        .B(alu_b),
        .alu_ctrl(alu_ctrl_sig),
        .Y(alu_result), 
        .zero(zero)
    );

    // Branch: taken when B-type (ImmSel[1]) and zero flag set
    wire [31:0] branch_target;
    wire        branch_taken;
    assign branch_target = pc + b_imm;
    assign branch_taken  = ImmSel[1] & zero;

    // --- Memory ---

    wire [31:0] mem_read_data;

    bankedmem DMEM (
        .clk(clk), 
        .writeEn(MemWrite),
        .address(alu_result), 
        .writeData(rd_data2),
        .readData(mem_read_data)
    );

    // --- Write Back ---

    assign wb_data = MemRead ? mem_read_data : alu_result;
    assign next_pc = branch_taken ? branch_target : pc_plus_4;

endmodule
