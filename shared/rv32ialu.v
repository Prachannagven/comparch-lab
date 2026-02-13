`timescale 1ns / 1ps
module rv32ialu (
    input  signed [31:0] A,
    input  signed [31:0] B,
    input         [2:0]  alu_ctrl,
    output signed [31:0] Y,
    output               zero
);

    // =========================================================================
    // Submodule outputs (all compute in parallel)
    // =========================================================================
    
    // Add/Sub unit outputs
    wire [31:0] addsub_result;
    wire        pos_overflow, neg_overflow;
    
    // Comparator output (SLT)
    wire [31:0] slt_result;
    
    // Logic unit output (AND/OR)
    wire [31:0] logic_result;
    
    // Shift unit output (SLL/SRL)
    wire [31:0] shift_result;

    // =========================================================================
    // Submodule instantiations (parallel computation)
    // =========================================================================
    
    // Add/Subtract unit
    // sub signal: alu_ctrl[0] = 0 for SUB (000), 1 for ADD (001)
    // So we invert: sub = ~alu_ctrl[0] when alu_ctrl[2:1] == 00
    // Actually, for SUB (000): sub=1, for ADD (001): sub=0
    // So sub = ~alu_ctrl[0]
    aluaddsub u_addsub (
        .a(A),
        .b(B),
        .sub(~alu_ctrl[0]),     // 000->SUB(sub=1), 001->ADD(sub=0)
        .result(addsub_result),
        .pos_overflow(pos_overflow),
        .neg_overflow(neg_overflow)
    );
    
    // Comparator unit (SLT - Set Less Than signed)
    // Always computes a < b (signed)
    alucomp u_comp (
        .a(A),
        .b(B),
        .result(slt_result)
    );
    
    // Logic unit (AND/OR)
    // op: alu_ctrl[0] = 0 for AND (010), 1 for OR (011)
    alulogic u_logic (
        .a(A),
        .b(B),
        .op(alu_ctrl[0]),       // 010->AND(op=0), 011->OR(op=1)
        .result(logic_result)
    );
    
    // Shift unit (SLL/SRL)
    // op: alu_ctrl[0] = 0 for SLL (100), 1 for SRL (101)
    alushift u_shift (
        .a(A),
        .b(B[4:0]),
        .op(alu_ctrl[0]),       // 100->SLL(op=0), 101->SRL(op=1)
        .result(shift_result)
    );

    // =========================================================================
    // Output multiplexer based on alu_ctrl
    // =========================================================================
    // alu_ctrl encoding:
    // 000 = SUB    -> addsub_result
    // 001 = ADD    -> addsub_result
    // 010 = AND    -> logic_result
    // 011 = OR     -> logic_result
    // 100 = SLL    -> shift_result
    // 101 = SRL    -> shift_result
    // 110 = SLT    -> slt_result
    // 111 = Reserved -> 0
    
    reg [31:0] mux_out;
    
    always @(*) begin
        case (alu_ctrl)
            3'b000: mux_out = addsub_result;   // SUB
            3'b001: mux_out = addsub_result;   // ADD
            3'b010: mux_out = logic_result;    // AND
            3'b011: mux_out = logic_result;    // OR
            3'b100: mux_out = shift_result;    // SLL
            3'b101: mux_out = shift_result;    // SRL
            3'b110: mux_out = slt_result;      // SLT
            3'b111: mux_out = 32'b0;           // Reserved
            default: mux_out = 32'b0;
        endcase
    end
    
    // Output with mux delay
    assign #1 Y = mux_out;
    
    // =========================================================================
    // Zero flag - derived from final output only
    // =========================================================================
    assign #1 zero = (Y == 32'b0);

endmodule
