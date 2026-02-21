`timescale 1ns/1ps
module controlunit (
    input wire [31:0] instruction,
    output reg RegWrite,
    output reg ALUSrc,
    output reg MemWrite,
    output reg MemRead,
    output reg [2:0] ALUOp,
    output reg [1:0] ImmSel
);

    wire [6:0] opcode = instruction[6:0];
    wire [2:0] funct3 = instruction[14:12];
    wire [6:0] funct7 = instruction[31:25];

    always @(*) begin
        RegWrite = 1'b0;
        ALUSrc = 1'b0;
        MemWrite = 1'b0;
        MemRead = 1'b0;
        ALUOp = 3'b000;
        ImmSel = 2'b00;

        case (opcode)
            7'b0110011: begin
                RegWrite = 1'b1;
                ALUSrc = 1'b0;
                case ({funct7, funct3})
                    10'b0000000_000: ALUOp = 3'b001;
                    10'b0100000_000: ALUOp = 3'b000;
                    10'b0000000_111: ALUOp = 3'b010;
                    10'b0000000_110: ALUOp = 3'b011;
                    10'b0000000_001: ALUOp = 3'b100;
                    10'b0000000_101: ALUOp = 3'b101;
                    10'b0000000_010: ALUOp = 3'b110;
                    default: begin
                        RegWrite = 1'b0;
                        ALUOp = 3'b000;
                    end
                endcase
            end

            7'b0010011: begin
                RegWrite = 1'b1;
                ALUSrc = 1'b1;
                ImmSel = 2'b00;
                case (funct3)
                    3'b000: ALUOp = 3'b001;
                    3'b111: ALUOp = 3'b010;
                    3'b110: ALUOp = 3'b011;
                    3'b010: ALUOp = 3'b110;
                    3'b001: begin
                        if (funct7 == 7'b0000000) ALUOp = 3'b100;
                        else RegWrite = 1'b0;
                    end
                    3'b101: begin
                        if (funct7 == 7'b0000000) ALUOp = 3'b101;
                        else RegWrite = 1'b0;
                    end
                    default: begin
                        RegWrite = 1'b0;
                        ALUOp = 3'b000;
                    end
                endcase
            end

            7'b0000011: begin
                if (funct3 == 3'b010) begin
                    RegWrite = 1'b1;
                    ALUSrc = 1'b1;
                    MemRead = 1'b1;
                    ALUOp = 3'b001;
                    ImmSel = 2'b00;
                end
            end

            7'b0100011: begin
                if (funct3 == 3'b010) begin
                    RegWrite = 1'b0;
                    ALUSrc = 1'b1;
                    MemWrite = 1'b1;
                    ALUOp = 3'b001;
                    ImmSel = 2'b01;
                end
            end

            7'b1100011: begin
                RegWrite = 1'b0;
                ALUSrc = 1'b0;
                ImmSel = 2'b10;
                case (funct3)
                    3'b000, 3'b001: ALUOp = 3'b000;
                    3'b100, 3'b101: ALUOp = 3'b110;
                    default: ALUOp = 3'b000;
                endcase
            end

            default: begin
                RegWrite = 1'b0;
                ALUSrc = 1'b0;
                MemWrite = 1'b0;
                MemRead = 1'b0;
                ALUOp = 3'b000;
                ImmSel = 2'b00;
            end
        endcase
    end

endmodule