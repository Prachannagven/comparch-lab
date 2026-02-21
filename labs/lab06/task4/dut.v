module dut (
    input wire [31:0] instruction,
    output reg RegWrite,
    output reg ALUSrc,
    output reg MemWrite,
    output reg MemRead,
    output reg [2:0] ALUOp,
    output reg [1:0] ImmSel
);

    controlunit cu (
        .instruction(instruction),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .ALUOp(ALUOp),
        .ImmSel(ImmSel)
    );
    
endmodule