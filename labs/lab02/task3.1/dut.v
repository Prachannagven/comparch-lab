

module dut(
        input clk,reset,serial_in,
        output reg[3:0]q
);

always@(posedge clk or negedge reset)
    if(!reset)
        q=0;
    else
    begin
        q[0]=serial_in;
        q[1]=q[0];
        q[2]=q[1];
        q[3]=q[2];
    end
endmodule