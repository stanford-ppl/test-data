module divmodder
  #( parameter WIDTH = 32,
     parameter LATENCY = 4 
   )
   (
     input clock,
     input reset,
     input [WIDTH-1:0] in1,
     input [WIDTH-1:0] in2,
     output reg [WIDTH-1:0] div,
     output reg [WIDTH-1:0] mod
   );
  integer i;
  reg [WIDTH-1:0] sr1[LATENCY];
  reg [WIDTH-1:0] sr2[LATENCY];

  always @(posedge clock) begin
    begin
      sr1[0] <= in1 % in2;
      sr2[0] <= in1 / in2;
      for(i=1; i<LATENCY; i=i+1) begin
        sr1[i] <= sr1[i-1];
        sr2[i] <= sr2[i-1];
      end
    end
  end

  always @(*) begin
    mod = sr1[LATENCY-1];
    div = sr2[LATENCY-1];
  end

endmodule 
