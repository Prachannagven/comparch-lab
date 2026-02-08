module dut(
    input wire clk,
    input wire reset,
    input wire dest,
    input wire [1:0] op,
    output reg [7:0] R0,
    output reg [7:0] R1
);

    localparam RUN_WAIT = 2'b00;
    localparam RUN_RESULT_READY = 2'b01;
    localparam HALTED = 2'b10;
    reg [1:0] state = 2'b00;

    always @(posedge clk or negedge reset) begin
        if(reset) begin
            R0 <= 8'b00000000;
            R1 <= 8'b00000000;
            state <= RUN_WAIT;
        end
        else begin
            case (state)
                RUN_WAIT: begin
                    if(!(op[0] ^ op[1])) begin
                        state <= op[1] ? HALTED : RUN_WAIT;
                    end
                    else
                        state <= RUN_RESULT_READY;
                end 
                RUN_RESULT_READY: begin
                    if(dest) begin
                        R1 <= op[0] ? (R1 + 8'b00000001) : (R1 - 8'b00000001);
                    end
                    else begin
                        R0 <= op[0] ? (R0 + 8'b00000001) : (R0 - 8'b00000001);
                    end
                    state <= RUN_WAIT;
                end
                HALTED: begin
                    if(op == 2'b11) begin
                        state <= RUN_WAIT;
                    end
                    else state <= HALTED;
                end
                default: state <= RUN_WAIT;
            endcase
        end
    end
    


endmodule