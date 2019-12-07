module multiplier
  #( parameter WIDTH = 32,
     parameter LATENCY = 4 
   )
   (
     input clock,
     input reset,
     input [WIDTH-1:0] in1,
     input [WIDTH-1:0] in2,
     output reg [WIDTH-1:0] out
   );
  integer i;
  reg [WIDTH-1:0] sr[LATENCY];

  always @(posedge clock) begin
    begin
      sr[0] <= in1 * in2;
      for(i=1; i<LATENCY; i=i+1) begin
        sr[i] <= sr[i-1];
      end
    end
  end

  always @(*) begin
    out = sr[LATENCY-1];
  end

endmodule 
