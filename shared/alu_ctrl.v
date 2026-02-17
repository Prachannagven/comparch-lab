/*
* I'm going to assume that the control logic is performed by a memory of some type. As dicscussed in class, this type of control logic only has the delay of the memory, so a bunch of case statements is sufficient to create a "structural" design of this control logic
*/
`timescale 1ns/1ps
module alu_ctrl (
    input wire  [2:0] funct3,
    input wire  [6:0] funct7,
    output wire [2:0] alu_ctrl 
);
    wire [3:0] net_funct;
    #1 assign net_funct = {funct7[5], funct3};

    always @(*) begin
        case (net_funct)
            4'b0000: begin//ADD
                #1 alu_ctrl <= 3'b001;
            end
            4'b1000: begin //SUB
                #1 alu_ctrl <= 3'b000;
            end
            4'b0111: begin //AND
                #1 alu_ctrl <= 3'b010;
            end
            4'b0110: begin //OR
                #1 alu_ctrl <= 3'b011;
            end
            4'b0001: begin //SLL
                #1 alu_ctrl <= 3'b100;
            end
            4'b0010: begin //SLT
                #1 alu_ctrl <= 3'b110;
            end 
            default: 
        endcase
    end
    
endmodule