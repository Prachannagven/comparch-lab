module dut (
    input wire clk,
    input wire reset,
    output wire [3:0] count
);

  wire [3:0] d;
  wire [3:0] q;
  
  assign d[0] = ~q[0];
  assign d[1] = q[1] ^ q[0];
  assign d[2] = q[2] ^ (q[1] & q[0]);
  assign d[3] = q[3] ^ (q[2] & q[1] & q[0]);

  genvar i;
  generate
    for (i = 0; i < 4; i = i + 1) begin : dff_array
      dff DFF (
        .clk(clk),
        .d(d[i]),
        .reset(reset),
        .q(q[i])
      );
    end
  endgenerate
  
  assign count = q;
    
endmodule