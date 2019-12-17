module ctrl
  #( parameter WIDTH = 32)(
  input          clock, 
  input          reset, 
  output         index_valid, 
  input          index_ready, 
  output [31:0]  index, 
  output         payload_valid, 
  input          payload_ready, 
  output [WIDTH-1:0] payload, 
  input          numel_valid, 
  output         numel_ready, 
  input  [31:0] numel, 
  input          scalar_valid, 
  output         scalar_ready, 
  input  [WIDTH-1:0]   scalar, 
  output         numelOut_valid, 
  input          numelOut_ready, 
  output [31:0] numelOut, 
  input          enable, 
  output         done
);

  wire dontcare;
  // Input fifo wires
  wire numel_empty;
  wire scalar_empty;
  wire numel_deqEn;
  wire scala_deqEn;

  // Output fifo wires
  wire index_wen;
  wire index_empty;
  wire index_full;
  wire index_aao;
  wire index_deqEn;
  wire [31:0] index_wdata;
  wire payload_wen;
  wire payload_empty;
  wire payload_full;
  wire payload_aao;
  wire payload_deqEn;
  wire [WIDTH-1:0] payload_wdata;
  wire numelOut_wen;
  wire numelOut_empty;
  wire numelOut_full;
  wire numelOut_aao;
  wire numelOut_deqEn;
  wire [31:0] numelOut_wdata;

  // Hack, delay done signal by one and feed it back into the acknowledgement rather than grabbing it from true parent of bbox
  wire  ack; 
  RetimeShiftRegister #(.WIDTH(1), .STAGES(1)) sr ( 
    .out(ack),
    .in(done),
    .init(1'h0),
    .flow(1'h1),
    .reset(reset),
    .clock(clock)
  );

  assign numel_empty = ~numel_valid; 
  assign scalar_empty = ~scalar_valid; 
  assign numel_deqEn = numel_valid & numel_ready;
  assign scalar_deqEn = scalar_valid & scalar_ready;

  assign index_valid = ~index_empty;
  assign numelOut_valid = ~numelOut_empty;
  assign payload_valid = ~payload_empty;
  assign index_deqEn = index_valid & index_ready;
  assign payload_deqEn = payload_valid & payload_ready;
  assign numelOut_deqEn = numelOut_valid & numelOut_ready;

  bbox_x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1 wrapped_kernel(
    .clock(clock),
    .reset(reset),
    .io_in_x77_scalar_0_rPort_0_output_0(scalar),
    .io_in_x77_scalar_0_empty(scalar_empty),
    .io_in_x77_scalar_0_rPort_0_en_0(scalar_ready),
    .io_in_x76_numel_0_rPort_0_output_0(numel),
    .io_in_x76_numel_0_empty(numel_empty),
    .io_in_x76_numel_0_rPort_0_en_0(numel_ready),
    .io_in_x78_index_0_wPort_0_data_0(index_wdata),
    .io_in_x78_index_0_wPort_0_en_0(index_wen),
    .io_in_x78_index_0_full(index_full),
    .io_in_x78_index_0_accessActivesIn_0(index_aao),
    .io_in_x78_index_0_accessActivesOut_0(index_aao),
    .io_in_x79_payload_0_wPort_0_data_0(payload_wdata),
    .io_in_x79_payload_0_wPort_0_en_0(payload_wen),
    .io_in_x79_payload_0_full(payload_full),
    .io_in_x79_payload_0_accessActivesIn_0(payload_aao),
    .io_in_x79_payload_0_accessActivesOut_0(payload_aao),
    .io_in_x80_numelOut_0_wPort_0_data_0(numelOut_wdata),
    .io_in_x80_numelOut_0_wPort_0_en_0(numelOut_wen),
    .io_in_x80_numelOut_0_full(numelOut_full),
    .io_in_x80_numelOut_0_accessActivesIn_0(numelOut_aao),
    .io_in_x80_numelOut_0_accessActivesOut_0(numelOut_aao),
    .io_sigsIn_smEnableOuts_0(enable),
    .io_sigsIn_smChildAcks_0(ack),
    .io_sigsOut_smDoneIn_0(done),
    .io_rr(1'h1)
  );

  bbox_x76_numel_0 x78_index_0 ( // @[m_x78_index_0.scala 27:17:@14310.4]
    .clock(clock),
    .reset(reset),
    .io_rPort_0_en_0(index_deqEn),
    .io_rPort_0_output_0(index),
    .io_wPort_0_data_0(index_wdata),
    .io_wPort_0_en_0(index_wen),
    .io_full(index_full),
    .io_empty(index_empty),
    .io_accessActivesOut_0(dontcare),
    .io_accessActivesIn_0(index_aao)
  );
  bbox_x77_scalar_0 x79_payload_0 ( // @[m_x79_payload_0.scala 27:17:@14336.4]
    .clock(clock),
    .reset(reset),
    .io_rPort_0_en_0(payload_deqEn),
    .io_rPort_0_output_0(payload),
    .io_wPort_0_data_0(payload_wdata),
    .io_wPort_0_en_0(payload_wen),
    .io_full(payload_full),
    .io_empty(payload_empty),
    .io_accessActivesOut_0(dontcare),
    .io_accessActivesIn_0(payload_aao)
  );
  bbox_x76_numel_0 x80_numelOut_0 ( // @[m_x80_numelOut_0.scala 27:17:@14362.4]
    .clock(clock),
    .reset(reset),
    .io_rPort_0_en_0(numelOut_deqEn),
    .io_rPort_0_output_0(numelOut),
    .io_wPort_0_data_0(numelOut_wdata),
    .io_wPort_0_en_0(numelOut_wen),
    .io_full(numelOut_full),
    .io_empty(numelOut_empty),
    .io_accessActivesOut_0(dontcare),
    .io_accessActivesIn_0(numelOut_aao)
  );

endmodule


module bbox_FF( // @[:@3.2]
  input         clock, // @[:@4.4]
  input         reset, // @[:@5.4]
  output [31:0] io_rPort_0_output_0, // @[:@6.4]
  input  [31:0] io_wPort_0_data_0, // @[:@6.4]
  input         io_wPort_0_reset, // @[:@6.4]
  input         io_wPort_0_en_0 // @[:@6.4]
);
  reg [31:0] ff; // @[MemPrimitives.scala 173:19:@21.4]
  reg [31:0] _RAND_0;
  wire [31:0] _T_68; // @[MemPrimitives.scala 177:32:@23.4]
  wire [31:0] _T_69; // @[MemPrimitives.scala 177:12:@24.4]
  assign _T_68 = io_wPort_0_en_0 ? io_wPort_0_data_0 : ff; // @[MemPrimitives.scala 177:32:@23.4]
  assign _T_69 = io_wPort_0_reset ? 32'h0 : _T_68; // @[MemPrimitives.scala 177:12:@24.4]
  assign io_rPort_0_output_0 = ff; // @[MemPrimitives.scala 178:34:@26.4]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  ff = _RAND_0[31:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      ff <= 32'h0;
    end else begin
      if (io_wPort_0_reset) begin
        ff <= 32'h0;
      end else begin
        if (io_wPort_0_en_0) begin
          ff <= io_wPort_0_data_0;
        end
      end
    end
  end
endmodule
module bbox_SRFF( // @[:@28.2]
  input   clock, // @[:@29.4]
  input   reset, // @[:@30.4]
  input   io_input_set, // @[:@31.4]
  input   io_input_reset, // @[:@31.4]
  input   io_input_asyn_reset, // @[:@31.4]
  output  io_output // @[:@31.4]
);
  reg  _T_15; // @[SRFF.scala 20:21:@33.4]
  reg [31:0] _RAND_0;
  wire  _T_19; // @[SRFF.scala 21:74:@34.4]
  wire  _T_20; // @[SRFF.scala 21:48:@35.4]
  wire  _T_21; // @[SRFF.scala 21:14:@36.4]
  assign _T_19 = io_input_reset ? 1'h0 : _T_15; // @[SRFF.scala 21:74:@34.4]
  assign _T_20 = io_input_set ? 1'h1 : _T_19; // @[SRFF.scala 21:48:@35.4]
  assign _T_21 = io_input_asyn_reset ? 1'h0 : _T_20; // @[SRFF.scala 21:14:@36.4]
  assign io_output = io_input_asyn_reset ? 1'h0 : _T_15; // @[SRFF.scala 22:15:@39.4]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  _T_15 = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      _T_15 <= 1'h0;
    end else begin
      if (io_input_asyn_reset) begin
        _T_15 <= 1'h0;
      end else begin
        if (io_input_set) begin
          _T_15 <= 1'h1;
        end else begin
          if (io_input_reset) begin
            _T_15 <= 1'h0;
          end
        end
      end
    end
  end
endmodule
module bbox_SingleCounter( // @[:@41.2]
  input   clock, // @[:@42.4]
  input   reset, // @[:@43.4]
  input   io_input_reset, // @[:@44.4]
  output  io_output_done // @[:@44.4]
);
  wire  bases_0_clock; // @[Counter.scala 253:53:@57.4]
  wire  bases_0_reset; // @[Counter.scala 253:53:@57.4]
  wire [31:0] bases_0_io_rPort_0_output_0; // @[Counter.scala 253:53:@57.4]
  wire [31:0] bases_0_io_wPort_0_data_0; // @[Counter.scala 253:53:@57.4]
  wire  bases_0_io_wPort_0_reset; // @[Counter.scala 253:53:@57.4]
  wire  bases_0_io_wPort_0_en_0; // @[Counter.scala 253:53:@57.4]
  wire  SRFF_clock; // @[Counter.scala 255:22:@73.4]
  wire  SRFF_reset; // @[Counter.scala 255:22:@73.4]
  wire  SRFF_io_input_set; // @[Counter.scala 255:22:@73.4]
  wire  SRFF_io_input_reset; // @[Counter.scala 255:22:@73.4]
  wire  SRFF_io_input_asyn_reset; // @[Counter.scala 255:22:@73.4]
  wire  SRFF_io_output; // @[Counter.scala 255:22:@73.4]
  wire [31:0] _T_48; // @[Counter.scala 279:52:@101.4]
  wire [32:0] _T_50; // @[Counter.scala 283:33:@102.4]
  wire [31:0] _T_51; // @[Counter.scala 283:33:@103.4]
  wire [31:0] _T_52; // @[Counter.scala 283:33:@104.4]
  wire  _T_57; // @[Counter.scala 285:18:@106.4]
  wire [31:0] _T_68; // @[Counter.scala 291:115:@114.4]
  wire [31:0] _T_71; // @[Counter.scala 291:152:@117.4]
  wire [31:0] _T_72; // @[Counter.scala 291:74:@118.4]
  bbox_FF bases_0 ( // @[Counter.scala 253:53:@57.4]
    .clock(bases_0_clock),
    .reset(bases_0_reset),
    .io_rPort_0_output_0(bases_0_io_rPort_0_output_0),
    .io_wPort_0_data_0(bases_0_io_wPort_0_data_0),
    .io_wPort_0_reset(bases_0_io_wPort_0_reset),
    .io_wPort_0_en_0(bases_0_io_wPort_0_en_0)
  );
  bbox_SRFF SRFF ( // @[Counter.scala 255:22:@73.4]
    .clock(SRFF_clock),
    .reset(SRFF_reset),
    .io_input_set(SRFF_io_input_set),
    .io_input_reset(SRFF_io_input_reset),
    .io_input_asyn_reset(SRFF_io_input_asyn_reset),
    .io_output(SRFF_io_output)
  );
  assign _T_48 = $signed(bases_0_io_rPort_0_output_0); // @[Counter.scala 279:52:@101.4]
  assign _T_50 = $signed(_T_48) + $signed(32'sh1); // @[Counter.scala 283:33:@102.4]
  assign _T_51 = $signed(_T_48) + $signed(32'sh1); // @[Counter.scala 283:33:@103.4]
  assign _T_52 = $signed(_T_51); // @[Counter.scala 283:33:@104.4]
  assign _T_57 = $signed(_T_52) >= $signed(32'sh3); // @[Counter.scala 285:18:@106.4]
  assign _T_68 = $unsigned(_T_48); // @[Counter.scala 291:115:@114.4]
  assign _T_71 = $unsigned(_T_52); // @[Counter.scala 291:152:@117.4]
  assign _T_72 = _T_57 ? _T_68 : _T_71; // @[Counter.scala 291:74:@118.4]
  assign io_output_done = $signed(_T_52) >= $signed(32'sh3); // @[Counter.scala 325:20:@127.4]
  assign bases_0_clock = clock; // @[:@58.4]
  assign bases_0_reset = reset; // @[:@59.4]
  assign bases_0_io_wPort_0_data_0 = io_input_reset ? 32'h0 : _T_72; // @[Counter.scala 291:31:@120.4]
  assign bases_0_io_wPort_0_reset = io_input_reset; // @[Counter.scala 273:27:@99.4]
  assign bases_0_io_wPort_0_en_0 = 1'h1; // @[Counter.scala 276:29:@100.4]
  assign SRFF_clock = clock; // @[:@74.4]
  assign SRFF_reset = reset; // @[:@75.4]
  assign SRFF_io_input_set = io_input_reset == 1'h0; // @[Counter.scala 256:23:@78.4]
  assign SRFF_io_input_reset = io_input_reset | io_output_done; // @[Counter.scala 257:25:@80.4]
  assign SRFF_io_input_asyn_reset = 1'h0; // @[Counter.scala 258:30:@81.4]
endmodule
module bbox_RetimeWrapper( // @[:@144.2]
  input   clock, // @[:@145.4]
  input   reset, // @[:@146.4]
  input   io_flow, // @[:@147.4]
  input   io_in, // @[:@147.4]
  output  io_out // @[:@147.4]
);
  wire  sr_out; // @[RetimeShiftRegister.scala 15:20:@149.4]
  wire  sr_in; // @[RetimeShiftRegister.scala 15:20:@149.4]
  wire  sr_init; // @[RetimeShiftRegister.scala 15:20:@149.4]
  wire  sr_flow; // @[RetimeShiftRegister.scala 15:20:@149.4]
  wire  sr_reset; // @[RetimeShiftRegister.scala 15:20:@149.4]
  wire  sr_clock; // @[RetimeShiftRegister.scala 15:20:@149.4]
  RetimeShiftRegister #(.WIDTH(1), .STAGES(1)) sr ( // @[RetimeShiftRegister.scala 15:20:@149.4]
    .out(sr_out),
    .in(sr_in),
    .init(sr_init),
    .flow(sr_flow),
    .reset(sr_reset),
    .clock(sr_clock)
  );
  assign io_out = sr_out; // @[RetimeShiftRegister.scala 21:12:@162.4]
  assign sr_in = io_in; // @[RetimeShiftRegister.scala 20:14:@161.4]
  assign sr_init = 1'h0; // @[RetimeShiftRegister.scala 19:16:@160.4]
  assign sr_flow = io_flow; // @[RetimeShiftRegister.scala 18:16:@159.4]
  assign sr_reset = reset; // @[RetimeShiftRegister.scala 17:17:@158.4]
  assign sr_clock = clock; // @[RetimeShiftRegister.scala 16:17:@156.4]
endmodule
module bbox_RootController_sm( // @[:@312.2]
  input   clock, // @[:@313.4]
  input   reset, // @[:@314.4]
  input   io_enable, // @[:@315.4]
  output  io_done, // @[:@315.4]
  input   io_rst, // @[:@315.4]
  input   io_ctrDone, // @[:@315.4]
  output  io_ctrInc, // @[:@315.4]
  input   io_parentAck, // @[:@315.4]
  input   io_doneIn_0, // @[:@315.4]
  output  io_enableOut_0, // @[:@315.4]
  output  io_childAck_0 // @[:@315.4]
);
  wire  active_0_clock; // @[Controllers.scala 76:50:@318.4]
  wire  active_0_reset; // @[Controllers.scala 76:50:@318.4]
  wire  active_0_io_input_set; // @[Controllers.scala 76:50:@318.4]
  wire  active_0_io_input_reset; // @[Controllers.scala 76:50:@318.4]
  wire  active_0_io_input_asyn_reset; // @[Controllers.scala 76:50:@318.4]
  wire  active_0_io_output; // @[Controllers.scala 76:50:@318.4]
  wire  done_0_clock; // @[Controllers.scala 77:48:@321.4]
  wire  done_0_reset; // @[Controllers.scala 77:48:@321.4]
  wire  done_0_io_input_set; // @[Controllers.scala 77:48:@321.4]
  wire  done_0_io_input_reset; // @[Controllers.scala 77:48:@321.4]
  wire  done_0_io_input_asyn_reset; // @[Controllers.scala 77:48:@321.4]
  wire  done_0_io_output; // @[Controllers.scala 77:48:@321.4]
  wire  iterDone_0_clock; // @[Controllers.scala 90:52:@338.4]
  wire  iterDone_0_reset; // @[Controllers.scala 90:52:@338.4]
  wire  iterDone_0_io_input_set; // @[Controllers.scala 90:52:@338.4]
  wire  iterDone_0_io_input_reset; // @[Controllers.scala 90:52:@338.4]
  wire  iterDone_0_io_input_asyn_reset; // @[Controllers.scala 90:52:@338.4]
  wire  iterDone_0_io_output; // @[Controllers.scala 90:52:@338.4]
  wire  RetimeWrapper_clock; // @[package.scala 93:22:@357.4]
  wire  RetimeWrapper_reset; // @[package.scala 93:22:@357.4]
  wire  RetimeWrapper_io_flow; // @[package.scala 93:22:@357.4]
  wire  RetimeWrapper_io_in; // @[package.scala 93:22:@357.4]
  wire  RetimeWrapper_io_out; // @[package.scala 93:22:@357.4]
  wire  RetimeWrapper_1_clock; // @[package.scala 93:22:@416.4]
  wire  RetimeWrapper_1_reset; // @[package.scala 93:22:@416.4]
  wire  RetimeWrapper_1_io_flow; // @[package.scala 93:22:@416.4]
  wire  RetimeWrapper_1_io_in; // @[package.scala 93:22:@416.4]
  wire  RetimeWrapper_1_io_out; // @[package.scala 93:22:@416.4]
  wire  RetimeWrapper_2_clock; // @[package.scala 93:22:@433.4]
  wire  RetimeWrapper_2_reset; // @[package.scala 93:22:@433.4]
  wire  RetimeWrapper_2_io_flow; // @[package.scala 93:22:@433.4]
  wire  RetimeWrapper_2_io_in; // @[package.scala 93:22:@433.4]
  wire  RetimeWrapper_2_io_out; // @[package.scala 93:22:@433.4]
  wire  finished; // @[Controllers.scala 81:26:@324.4]
  wire  _T_81; // @[Controllers.scala 86:43:@328.4]
  wire  synchronize; // @[package.scala 96:25:@362.4 package.scala 96:25:@363.4]
  wire  _T_93; // @[Controllers.scala 92:52:@342.4]
  wire  _T_122; // @[Controllers.scala 128:33:@371.4]
  wire  _T_124; // @[Controllers.scala 128:54:@372.4]
  wire  _T_125; // @[Controllers.scala 128:52:@373.4]
  wire  _T_126; // @[Controllers.scala 128:66:@374.4]
  wire  _T_128; // @[Controllers.scala 128:98:@376.4]
  wire  _T_129; // @[Controllers.scala 128:96:@377.4]
  wire  _T_131; // @[Controllers.scala 128:123:@378.4]
  wire  _T_133; // @[Controllers.scala 129:48:@381.4]
  wire  _T_134; // @[Controllers.scala 129:57:@382.4]
  wire  _T_138; // @[Controllers.scala 130:52:@386.4]
  wire  _T_139; // @[Controllers.scala 130:50:@387.4]
  wire  _T_147; // @[Controllers.scala 130:129:@393.4]
  wire  _T_150; // @[Controllers.scala 131:45:@396.4]
  wire  _T_154; // @[Controllers.scala 213:68:@402.4]
  wire  _T_156; // @[Controllers.scala 213:90:@404.4]
  wire  _T_158; // @[Controllers.scala 213:132:@406.4]
  wire  _T_159; // @[Controllers.scala 213:130:@407.4]
  wire  _T_160; // @[Controllers.scala 213:156:@408.4]
  reg  _T_166; // @[package.scala 48:56:@412.4]
  reg [31:0] _RAND_0;
  wire  _T_167; // @[package.scala 100:41:@414.4]
  reg  _T_180; // @[package.scala 48:56:@430.4]
  reg [31:0] _RAND_1;
  bbox_SRFF active_0 ( // @[Controllers.scala 76:50:@318.4]
    .clock(active_0_clock),
    .reset(active_0_reset),
    .io_input_set(active_0_io_input_set),
    .io_input_reset(active_0_io_input_reset),
    .io_input_asyn_reset(active_0_io_input_asyn_reset),
    .io_output(active_0_io_output)
  );
  bbox_SRFF done_0 ( // @[Controllers.scala 77:48:@321.4]
    .clock(done_0_clock),
    .reset(done_0_reset),
    .io_input_set(done_0_io_input_set),
    .io_input_reset(done_0_io_input_reset),
    .io_input_asyn_reset(done_0_io_input_asyn_reset),
    .io_output(done_0_io_output)
  );
  bbox_SRFF iterDone_0 ( // @[Controllers.scala 90:52:@338.4]
    .clock(iterDone_0_clock),
    .reset(iterDone_0_reset),
    .io_input_set(iterDone_0_io_input_set),
    .io_input_reset(iterDone_0_io_input_reset),
    .io_input_asyn_reset(iterDone_0_io_input_asyn_reset),
    .io_output(iterDone_0_io_output)
  );
  bbox_RetimeWrapper RetimeWrapper ( // @[package.scala 93:22:@357.4]
    .clock(RetimeWrapper_clock),
    .reset(RetimeWrapper_reset),
    .io_flow(RetimeWrapper_io_flow),
    .io_in(RetimeWrapper_io_in),
    .io_out(RetimeWrapper_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_1 ( // @[package.scala 93:22:@416.4]
    .clock(RetimeWrapper_1_clock),
    .reset(RetimeWrapper_1_reset),
    .io_flow(RetimeWrapper_1_io_flow),
    .io_in(RetimeWrapper_1_io_in),
    .io_out(RetimeWrapper_1_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_2 ( // @[package.scala 93:22:@433.4]
    .clock(RetimeWrapper_2_clock),
    .reset(RetimeWrapper_2_reset),
    .io_flow(RetimeWrapper_2_io_flow),
    .io_in(RetimeWrapper_2_io_in),
    .io_out(RetimeWrapper_2_io_out)
  );
  assign finished = done_0_io_output | io_done; // @[Controllers.scala 81:26:@324.4]
  assign _T_81 = io_rst | done_0_io_output; // @[Controllers.scala 86:43:@328.4]
  assign synchronize = RetimeWrapper_io_out; // @[package.scala 96:25:@362.4 package.scala 96:25:@363.4]
  assign _T_93 = synchronize | io_rst; // @[Controllers.scala 92:52:@342.4]
  assign _T_122 = done_0_io_output == 1'h0; // @[Controllers.scala 128:33:@371.4]
  assign _T_124 = io_ctrDone == 1'h0; // @[Controllers.scala 128:54:@372.4]
  assign _T_125 = _T_122 & _T_124; // @[Controllers.scala 128:52:@373.4]
  assign _T_126 = _T_125 & io_enable; // @[Controllers.scala 128:66:@374.4]
  assign _T_128 = ~ iterDone_0_io_output; // @[Controllers.scala 128:98:@376.4]
  assign _T_129 = _T_126 & _T_128; // @[Controllers.scala 128:96:@377.4]
  assign _T_131 = io_doneIn_0 == 1'h0; // @[Controllers.scala 128:123:@378.4]
  assign _T_133 = io_doneIn_0 | io_rst; // @[Controllers.scala 129:48:@381.4]
  assign _T_134 = _T_133 | io_parentAck; // @[Controllers.scala 129:57:@382.4]
  assign _T_138 = synchronize == 1'h0; // @[Controllers.scala 130:52:@386.4]
  assign _T_139 = io_doneIn_0 & _T_138; // @[Controllers.scala 130:50:@387.4]
  assign _T_147 = finished == 1'h0; // @[Controllers.scala 130:129:@393.4]
  assign _T_150 = io_rst == 1'h0; // @[Controllers.scala 131:45:@396.4]
  assign _T_154 = io_enable & active_0_io_output; // @[Controllers.scala 213:68:@402.4]
  assign _T_156 = _T_154 & _T_128; // @[Controllers.scala 213:90:@404.4]
  assign _T_158 = ~ done_0_io_output; // @[Controllers.scala 213:132:@406.4]
  assign _T_159 = _T_156 & _T_158; // @[Controllers.scala 213:130:@407.4]
  assign _T_160 = ~ io_ctrDone; // @[Controllers.scala 213:156:@408.4]
  assign _T_167 = done_0_io_output & _T_166; // @[package.scala 100:41:@414.4]
  assign io_done = RetimeWrapper_2_io_out; // @[Controllers.scala 245:13:@440.4]
  assign io_ctrInc = io_doneIn_0; // @[Controllers.scala 122:17:@356.4]
  assign io_enableOut_0 = _T_159 & _T_160; // @[Controllers.scala 213:55:@410.4]
  assign io_childAck_0 = iterDone_0_io_output; // @[Controllers.scala 212:58:@401.4]
  assign active_0_clock = clock; // @[:@319.4]
  assign active_0_reset = reset; // @[:@320.4]
  assign active_0_io_input_set = _T_129 & _T_131; // @[Controllers.scala 128:30:@380.4]
  assign active_0_io_input_reset = _T_134 | done_0_io_output; // @[Controllers.scala 129:32:@385.4]
  assign active_0_io_input_asyn_reset = 1'h0; // @[Controllers.scala 84:40:@326.4]
  assign done_0_clock = clock; // @[:@322.4]
  assign done_0_reset = reset; // @[:@323.4]
  assign done_0_io_input_set = io_ctrDone & _T_150; // @[Controllers.scala 131:28:@399.4]
  assign done_0_io_input_reset = _T_81 | io_parentAck; // @[Controllers.scala 86:33:@336.4]
  assign done_0_io_input_asyn_reset = 1'h0; // @[Controllers.scala 85:38:@327.4]
  assign iterDone_0_clock = clock; // @[:@339.4]
  assign iterDone_0_reset = reset; // @[:@340.4]
  assign iterDone_0_io_input_set = _T_139 & _T_147; // @[Controllers.scala 130:32:@395.4]
  assign iterDone_0_io_input_reset = _T_93 | io_parentAck; // @[Controllers.scala 92:37:@350.4]
  assign iterDone_0_io_input_asyn_reset = 1'h0; // @[Controllers.scala 91:42:@341.4]
  assign RetimeWrapper_clock = clock; // @[:@358.4]
  assign RetimeWrapper_reset = reset; // @[:@359.4]
  assign RetimeWrapper_io_flow = 1'h1; // @[package.scala 95:18:@361.4]
  assign RetimeWrapper_io_in = io_doneIn_0; // @[package.scala 94:16:@360.4]
  assign RetimeWrapper_1_clock = clock; // @[:@417.4]
  assign RetimeWrapper_1_reset = reset; // @[:@418.4]
  assign RetimeWrapper_1_io_flow = 1'h1; // @[package.scala 95:18:@420.4]
  assign RetimeWrapper_1_io_in = _T_167 | io_parentAck; // @[package.scala 94:16:@419.4]
  assign RetimeWrapper_2_clock = clock; // @[:@434.4]
  assign RetimeWrapper_2_reset = reset; // @[:@435.4]
  assign RetimeWrapper_2_io_flow = io_enable; // @[package.scala 95:18:@437.4]
  assign RetimeWrapper_2_io_in = done_0_io_output & _T_180; // @[package.scala 94:16:@436.4]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  _T_166 = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  _T_180 = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      _T_166 <= 1'h0;
    end else begin
      _T_166 <= _T_122;
    end
    if (reset) begin
      _T_180 <= 1'h0;
    end else begin
      _T_180 <= _T_122;
    end
  end
endmodule
module bbox_x140_outr_UnitPipe_sm( // @[:@959.2]
  input   clock, // @[:@960.4]
  input   reset, // @[:@961.4]
  input   io_enable, // @[:@962.4]
  output  io_done, // @[:@962.4]
  input   io_parentAck, // @[:@962.4]
  input   io_doneIn_0, // @[:@962.4]
  input   io_doneIn_1, // @[:@962.4]
  input   io_doneIn_2, // @[:@962.4]
  output  io_enableOut_0, // @[:@962.4]
  output  io_enableOut_1, // @[:@962.4]
  output  io_enableOut_2, // @[:@962.4]
  output  io_childAck_0, // @[:@962.4]
  output  io_childAck_1, // @[:@962.4]
  output  io_childAck_2, // @[:@962.4]
  input   io_ctrCopyDone_0, // @[:@962.4]
  input   io_ctrCopyDone_1, // @[:@962.4]
  input   io_ctrCopyDone_2 // @[:@962.4]
);
  wire  active_0_clock; // @[Controllers.scala 76:50:@965.4]
  wire  active_0_reset; // @[Controllers.scala 76:50:@965.4]
  wire  active_0_io_input_set; // @[Controllers.scala 76:50:@965.4]
  wire  active_0_io_input_reset; // @[Controllers.scala 76:50:@965.4]
  wire  active_0_io_input_asyn_reset; // @[Controllers.scala 76:50:@965.4]
  wire  active_0_io_output; // @[Controllers.scala 76:50:@965.4]
  wire  active_1_clock; // @[Controllers.scala 76:50:@968.4]
  wire  active_1_reset; // @[Controllers.scala 76:50:@968.4]
  wire  active_1_io_input_set; // @[Controllers.scala 76:50:@968.4]
  wire  active_1_io_input_reset; // @[Controllers.scala 76:50:@968.4]
  wire  active_1_io_input_asyn_reset; // @[Controllers.scala 76:50:@968.4]
  wire  active_1_io_output; // @[Controllers.scala 76:50:@968.4]
  wire  active_2_clock; // @[Controllers.scala 76:50:@971.4]
  wire  active_2_reset; // @[Controllers.scala 76:50:@971.4]
  wire  active_2_io_input_set; // @[Controllers.scala 76:50:@971.4]
  wire  active_2_io_input_reset; // @[Controllers.scala 76:50:@971.4]
  wire  active_2_io_input_asyn_reset; // @[Controllers.scala 76:50:@971.4]
  wire  active_2_io_output; // @[Controllers.scala 76:50:@971.4]
  wire  done_0_clock; // @[Controllers.scala 77:48:@974.4]
  wire  done_0_reset; // @[Controllers.scala 77:48:@974.4]
  wire  done_0_io_input_set; // @[Controllers.scala 77:48:@974.4]
  wire  done_0_io_input_reset; // @[Controllers.scala 77:48:@974.4]
  wire  done_0_io_input_asyn_reset; // @[Controllers.scala 77:48:@974.4]
  wire  done_0_io_output; // @[Controllers.scala 77:48:@974.4]
  wire  done_1_clock; // @[Controllers.scala 77:48:@977.4]
  wire  done_1_reset; // @[Controllers.scala 77:48:@977.4]
  wire  done_1_io_input_set; // @[Controllers.scala 77:48:@977.4]
  wire  done_1_io_input_reset; // @[Controllers.scala 77:48:@977.4]
  wire  done_1_io_input_asyn_reset; // @[Controllers.scala 77:48:@977.4]
  wire  done_1_io_output; // @[Controllers.scala 77:48:@977.4]
  wire  done_2_clock; // @[Controllers.scala 77:48:@980.4]
  wire  done_2_reset; // @[Controllers.scala 77:48:@980.4]
  wire  done_2_io_input_set; // @[Controllers.scala 77:48:@980.4]
  wire  done_2_io_input_reset; // @[Controllers.scala 77:48:@980.4]
  wire  done_2_io_input_asyn_reset; // @[Controllers.scala 77:48:@980.4]
  wire  done_2_io_output; // @[Controllers.scala 77:48:@980.4]
  wire  iterDone_0_clock; // @[Controllers.scala 90:52:@1021.4]
  wire  iterDone_0_reset; // @[Controllers.scala 90:52:@1021.4]
  wire  iterDone_0_io_input_set; // @[Controllers.scala 90:52:@1021.4]
  wire  iterDone_0_io_input_reset; // @[Controllers.scala 90:52:@1021.4]
  wire  iterDone_0_io_input_asyn_reset; // @[Controllers.scala 90:52:@1021.4]
  wire  iterDone_0_io_output; // @[Controllers.scala 90:52:@1021.4]
  wire  iterDone_1_clock; // @[Controllers.scala 90:52:@1024.4]
  wire  iterDone_1_reset; // @[Controllers.scala 90:52:@1024.4]
  wire  iterDone_1_io_input_set; // @[Controllers.scala 90:52:@1024.4]
  wire  iterDone_1_io_input_reset; // @[Controllers.scala 90:52:@1024.4]
  wire  iterDone_1_io_input_asyn_reset; // @[Controllers.scala 90:52:@1024.4]
  wire  iterDone_1_io_output; // @[Controllers.scala 90:52:@1024.4]
  wire  iterDone_2_clock; // @[Controllers.scala 90:52:@1027.4]
  wire  iterDone_2_reset; // @[Controllers.scala 90:52:@1027.4]
  wire  iterDone_2_io_input_set; // @[Controllers.scala 90:52:@1027.4]
  wire  iterDone_2_io_input_reset; // @[Controllers.scala 90:52:@1027.4]
  wire  iterDone_2_io_input_asyn_reset; // @[Controllers.scala 90:52:@1027.4]
  wire  iterDone_2_io_output; // @[Controllers.scala 90:52:@1027.4]
  wire  RetimeWrapper_clock; // @[package.scala 93:22:@1078.4]
  wire  RetimeWrapper_reset; // @[package.scala 93:22:@1078.4]
  wire  RetimeWrapper_io_flow; // @[package.scala 93:22:@1078.4]
  wire  RetimeWrapper_io_in; // @[package.scala 93:22:@1078.4]
  wire  RetimeWrapper_io_out; // @[package.scala 93:22:@1078.4]
  wire  RetimeWrapper_1_clock; // @[package.scala 93:22:@1092.4]
  wire  RetimeWrapper_1_reset; // @[package.scala 93:22:@1092.4]
  wire  RetimeWrapper_1_io_flow; // @[package.scala 93:22:@1092.4]
  wire  RetimeWrapper_1_io_in; // @[package.scala 93:22:@1092.4]
  wire  RetimeWrapper_1_io_out; // @[package.scala 93:22:@1092.4]
  wire  RetimeWrapper_2_clock; // @[package.scala 93:22:@1110.4]
  wire  RetimeWrapper_2_reset; // @[package.scala 93:22:@1110.4]
  wire  RetimeWrapper_2_io_flow; // @[package.scala 93:22:@1110.4]
  wire  RetimeWrapper_2_io_in; // @[package.scala 93:22:@1110.4]
  wire  RetimeWrapper_2_io_out; // @[package.scala 93:22:@1110.4]
  wire  RetimeWrapper_3_clock; // @[package.scala 93:22:@1147.4]
  wire  RetimeWrapper_3_reset; // @[package.scala 93:22:@1147.4]
  wire  RetimeWrapper_3_io_flow; // @[package.scala 93:22:@1147.4]
  wire  RetimeWrapper_3_io_in; // @[package.scala 93:22:@1147.4]
  wire  RetimeWrapper_3_io_out; // @[package.scala 93:22:@1147.4]
  wire  RetimeWrapper_4_clock; // @[package.scala 93:22:@1161.4]
  wire  RetimeWrapper_4_reset; // @[package.scala 93:22:@1161.4]
  wire  RetimeWrapper_4_io_flow; // @[package.scala 93:22:@1161.4]
  wire  RetimeWrapper_4_io_in; // @[package.scala 93:22:@1161.4]
  wire  RetimeWrapper_4_io_out; // @[package.scala 93:22:@1161.4]
  wire  RetimeWrapper_5_clock; // @[package.scala 93:22:@1179.4]
  wire  RetimeWrapper_5_reset; // @[package.scala 93:22:@1179.4]
  wire  RetimeWrapper_5_io_flow; // @[package.scala 93:22:@1179.4]
  wire  RetimeWrapper_5_io_in; // @[package.scala 93:22:@1179.4]
  wire  RetimeWrapper_5_io_out; // @[package.scala 93:22:@1179.4]
  wire  RetimeWrapper_6_clock; // @[package.scala 93:22:@1216.4]
  wire  RetimeWrapper_6_reset; // @[package.scala 93:22:@1216.4]
  wire  RetimeWrapper_6_io_flow; // @[package.scala 93:22:@1216.4]
  wire  RetimeWrapper_6_io_in; // @[package.scala 93:22:@1216.4]
  wire  RetimeWrapper_6_io_out; // @[package.scala 93:22:@1216.4]
  wire  RetimeWrapper_7_clock; // @[package.scala 93:22:@1230.4]
  wire  RetimeWrapper_7_reset; // @[package.scala 93:22:@1230.4]
  wire  RetimeWrapper_7_io_flow; // @[package.scala 93:22:@1230.4]
  wire  RetimeWrapper_7_io_in; // @[package.scala 93:22:@1230.4]
  wire  RetimeWrapper_7_io_out; // @[package.scala 93:22:@1230.4]
  wire  RetimeWrapper_8_clock; // @[package.scala 93:22:@1248.4]
  wire  RetimeWrapper_8_reset; // @[package.scala 93:22:@1248.4]
  wire  RetimeWrapper_8_io_flow; // @[package.scala 93:22:@1248.4]
  wire  RetimeWrapper_8_io_in; // @[package.scala 93:22:@1248.4]
  wire  RetimeWrapper_8_io_out; // @[package.scala 93:22:@1248.4]
  wire  RetimeWrapper_9_clock; // @[package.scala 93:22:@1305.4]
  wire  RetimeWrapper_9_reset; // @[package.scala 93:22:@1305.4]
  wire  RetimeWrapper_9_io_flow; // @[package.scala 93:22:@1305.4]
  wire  RetimeWrapper_9_io_in; // @[package.scala 93:22:@1305.4]
  wire  RetimeWrapper_9_io_out; // @[package.scala 93:22:@1305.4]
  wire  RetimeWrapper_10_clock; // @[package.scala 93:22:@1322.4]
  wire  RetimeWrapper_10_reset; // @[package.scala 93:22:@1322.4]
  wire  RetimeWrapper_10_io_flow; // @[package.scala 93:22:@1322.4]
  wire  RetimeWrapper_10_io_in; // @[package.scala 93:22:@1322.4]
  wire  RetimeWrapper_10_io_out; // @[package.scala 93:22:@1322.4]
  wire  _T_77; // @[Controllers.scala 80:47:@983.4]
  wire  allDone; // @[Controllers.scala 80:47:@984.4]
  wire  _T_151; // @[Controllers.scala 165:35:@1062.4]
  wire  _T_153; // @[Controllers.scala 165:60:@1063.4]
  wire  _T_154; // @[Controllers.scala 165:58:@1064.4]
  wire  _T_156; // @[Controllers.scala 165:76:@1065.4]
  wire  _T_157; // @[Controllers.scala 165:74:@1066.4]
  wire  _T_161; // @[Controllers.scala 165:109:@1069.4]
  wire  _T_164; // @[Controllers.scala 165:141:@1071.4]
  wire  _T_172; // @[package.scala 96:25:@1083.4 package.scala 96:25:@1084.4]
  wire  _T_176; // @[Controllers.scala 167:54:@1086.4]
  wire  _T_177; // @[Controllers.scala 167:52:@1087.4]
  wire  _T_184; // @[package.scala 96:25:@1097.4 package.scala 96:25:@1098.4]
  wire  _T_202; // @[package.scala 96:25:@1115.4 package.scala 96:25:@1116.4]
  wire  _T_206; // @[Controllers.scala 169:67:@1118.4]
  wire  _T_207; // @[Controllers.scala 169:86:@1119.4]
  wire  _T_219; // @[Controllers.scala 165:35:@1131.4]
  wire  _T_221; // @[Controllers.scala 165:60:@1132.4]
  wire  _T_222; // @[Controllers.scala 165:58:@1133.4]
  wire  _T_224; // @[Controllers.scala 165:76:@1134.4]
  wire  _T_225; // @[Controllers.scala 165:74:@1135.4]
  wire  _T_229; // @[Controllers.scala 165:109:@1138.4]
  wire  _T_232; // @[Controllers.scala 165:141:@1140.4]
  wire  _T_240; // @[package.scala 96:25:@1152.4 package.scala 96:25:@1153.4]
  wire  _T_244; // @[Controllers.scala 167:54:@1155.4]
  wire  _T_245; // @[Controllers.scala 167:52:@1156.4]
  wire  _T_252; // @[package.scala 96:25:@1166.4 package.scala 96:25:@1167.4]
  wire  _T_270; // @[package.scala 96:25:@1184.4 package.scala 96:25:@1185.4]
  wire  _T_274; // @[Controllers.scala 169:67:@1187.4]
  wire  _T_275; // @[Controllers.scala 169:86:@1188.4]
  wire  _T_287; // @[Controllers.scala 165:35:@1200.4]
  wire  _T_289; // @[Controllers.scala 165:60:@1201.4]
  wire  _T_290; // @[Controllers.scala 165:58:@1202.4]
  wire  _T_292; // @[Controllers.scala 165:76:@1203.4]
  wire  _T_293; // @[Controllers.scala 165:74:@1204.4]
  wire  _T_297; // @[Controllers.scala 165:109:@1207.4]
  wire  _T_300; // @[Controllers.scala 165:141:@1209.4]
  wire  _T_308; // @[package.scala 96:25:@1221.4 package.scala 96:25:@1222.4]
  wire  _T_312; // @[Controllers.scala 167:54:@1224.4]
  wire  _T_313; // @[Controllers.scala 167:52:@1225.4]
  wire  _T_320; // @[package.scala 96:25:@1235.4 package.scala 96:25:@1236.4]
  wire  _T_338; // @[package.scala 96:25:@1253.4 package.scala 96:25:@1254.4]
  wire  _T_342; // @[Controllers.scala 169:67:@1256.4]
  wire  _T_343; // @[Controllers.scala 169:86:@1257.4]
  wire  _T_358; // @[Controllers.scala 213:68:@1275.4]
  wire  _T_360; // @[Controllers.scala 213:90:@1277.4]
  wire  _T_362; // @[Controllers.scala 213:132:@1279.4]
  wire  _T_366; // @[Controllers.scala 213:68:@1284.4]
  wire  _T_368; // @[Controllers.scala 213:90:@1286.4]
  wire  _T_374; // @[Controllers.scala 213:68:@1292.4]
  wire  _T_376; // @[Controllers.scala 213:90:@1294.4]
  wire  _T_383; // @[package.scala 100:49:@1300.4]
  reg  _T_386; // @[package.scala 48:56:@1301.4]
  reg [31:0] _RAND_0;
  wire  _T_387; // @[package.scala 100:41:@1303.4]
  reg  _T_400; // @[package.scala 48:56:@1319.4]
  reg [31:0] _RAND_1;
  bbox_SRFF active_0 ( // @[Controllers.scala 76:50:@965.4]
    .clock(active_0_clock),
    .reset(active_0_reset),
    .io_input_set(active_0_io_input_set),
    .io_input_reset(active_0_io_input_reset),
    .io_input_asyn_reset(active_0_io_input_asyn_reset),
    .io_output(active_0_io_output)
  );
  bbox_SRFF active_1 ( // @[Controllers.scala 76:50:@968.4]
    .clock(active_1_clock),
    .reset(active_1_reset),
    .io_input_set(active_1_io_input_set),
    .io_input_reset(active_1_io_input_reset),
    .io_input_asyn_reset(active_1_io_input_asyn_reset),
    .io_output(active_1_io_output)
  );
  bbox_SRFF active_2 ( // @[Controllers.scala 76:50:@971.4]
    .clock(active_2_clock),
    .reset(active_2_reset),
    .io_input_set(active_2_io_input_set),
    .io_input_reset(active_2_io_input_reset),
    .io_input_asyn_reset(active_2_io_input_asyn_reset),
    .io_output(active_2_io_output)
  );
  bbox_SRFF done_0 ( // @[Controllers.scala 77:48:@974.4]
    .clock(done_0_clock),
    .reset(done_0_reset),
    .io_input_set(done_0_io_input_set),
    .io_input_reset(done_0_io_input_reset),
    .io_input_asyn_reset(done_0_io_input_asyn_reset),
    .io_output(done_0_io_output)
  );
  bbox_SRFF done_1 ( // @[Controllers.scala 77:48:@977.4]
    .clock(done_1_clock),
    .reset(done_1_reset),
    .io_input_set(done_1_io_input_set),
    .io_input_reset(done_1_io_input_reset),
    .io_input_asyn_reset(done_1_io_input_asyn_reset),
    .io_output(done_1_io_output)
  );
  bbox_SRFF done_2 ( // @[Controllers.scala 77:48:@980.4]
    .clock(done_2_clock),
    .reset(done_2_reset),
    .io_input_set(done_2_io_input_set),
    .io_input_reset(done_2_io_input_reset),
    .io_input_asyn_reset(done_2_io_input_asyn_reset),
    .io_output(done_2_io_output)
  );
  bbox_SRFF iterDone_0 ( // @[Controllers.scala 90:52:@1021.4]
    .clock(iterDone_0_clock),
    .reset(iterDone_0_reset),
    .io_input_set(iterDone_0_io_input_set),
    .io_input_reset(iterDone_0_io_input_reset),
    .io_input_asyn_reset(iterDone_0_io_input_asyn_reset),
    .io_output(iterDone_0_io_output)
  );
  bbox_SRFF iterDone_1 ( // @[Controllers.scala 90:52:@1024.4]
    .clock(iterDone_1_clock),
    .reset(iterDone_1_reset),
    .io_input_set(iterDone_1_io_input_set),
    .io_input_reset(iterDone_1_io_input_reset),
    .io_input_asyn_reset(iterDone_1_io_input_asyn_reset),
    .io_output(iterDone_1_io_output)
  );
  bbox_SRFF iterDone_2 ( // @[Controllers.scala 90:52:@1027.4]
    .clock(iterDone_2_clock),
    .reset(iterDone_2_reset),
    .io_input_set(iterDone_2_io_input_set),
    .io_input_reset(iterDone_2_io_input_reset),
    .io_input_asyn_reset(iterDone_2_io_input_asyn_reset),
    .io_output(iterDone_2_io_output)
  );
  bbox_RetimeWrapper RetimeWrapper ( // @[package.scala 93:22:@1078.4]
    .clock(RetimeWrapper_clock),
    .reset(RetimeWrapper_reset),
    .io_flow(RetimeWrapper_io_flow),
    .io_in(RetimeWrapper_io_in),
    .io_out(RetimeWrapper_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_1 ( // @[package.scala 93:22:@1092.4]
    .clock(RetimeWrapper_1_clock),
    .reset(RetimeWrapper_1_reset),
    .io_flow(RetimeWrapper_1_io_flow),
    .io_in(RetimeWrapper_1_io_in),
    .io_out(RetimeWrapper_1_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_2 ( // @[package.scala 93:22:@1110.4]
    .clock(RetimeWrapper_2_clock),
    .reset(RetimeWrapper_2_reset),
    .io_flow(RetimeWrapper_2_io_flow),
    .io_in(RetimeWrapper_2_io_in),
    .io_out(RetimeWrapper_2_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_3 ( // @[package.scala 93:22:@1147.4]
    .clock(RetimeWrapper_3_clock),
    .reset(RetimeWrapper_3_reset),
    .io_flow(RetimeWrapper_3_io_flow),
    .io_in(RetimeWrapper_3_io_in),
    .io_out(RetimeWrapper_3_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_4 ( // @[package.scala 93:22:@1161.4]
    .clock(RetimeWrapper_4_clock),
    .reset(RetimeWrapper_4_reset),
    .io_flow(RetimeWrapper_4_io_flow),
    .io_in(RetimeWrapper_4_io_in),
    .io_out(RetimeWrapper_4_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_5 ( // @[package.scala 93:22:@1179.4]
    .clock(RetimeWrapper_5_clock),
    .reset(RetimeWrapper_5_reset),
    .io_flow(RetimeWrapper_5_io_flow),
    .io_in(RetimeWrapper_5_io_in),
    .io_out(RetimeWrapper_5_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_6 ( // @[package.scala 93:22:@1216.4]
    .clock(RetimeWrapper_6_clock),
    .reset(RetimeWrapper_6_reset),
    .io_flow(RetimeWrapper_6_io_flow),
    .io_in(RetimeWrapper_6_io_in),
    .io_out(RetimeWrapper_6_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_7 ( // @[package.scala 93:22:@1230.4]
    .clock(RetimeWrapper_7_clock),
    .reset(RetimeWrapper_7_reset),
    .io_flow(RetimeWrapper_7_io_flow),
    .io_in(RetimeWrapper_7_io_in),
    .io_out(RetimeWrapper_7_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_8 ( // @[package.scala 93:22:@1248.4]
    .clock(RetimeWrapper_8_clock),
    .reset(RetimeWrapper_8_reset),
    .io_flow(RetimeWrapper_8_io_flow),
    .io_in(RetimeWrapper_8_io_in),
    .io_out(RetimeWrapper_8_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_9 ( // @[package.scala 93:22:@1305.4]
    .clock(RetimeWrapper_9_clock),
    .reset(RetimeWrapper_9_reset),
    .io_flow(RetimeWrapper_9_io_flow),
    .io_in(RetimeWrapper_9_io_in),
    .io_out(RetimeWrapper_9_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_10 ( // @[package.scala 93:22:@1322.4]
    .clock(RetimeWrapper_10_clock),
    .reset(RetimeWrapper_10_reset),
    .io_flow(RetimeWrapper_10_io_flow),
    .io_in(RetimeWrapper_10_io_in),
    .io_out(RetimeWrapper_10_io_out)
  );
  assign _T_77 = done_0_io_output & done_1_io_output; // @[Controllers.scala 80:47:@983.4]
  assign allDone = _T_77 & done_2_io_output; // @[Controllers.scala 80:47:@984.4]
  assign _T_151 = ~ iterDone_0_io_output; // @[Controllers.scala 165:35:@1062.4]
  assign _T_153 = io_doneIn_0 == 1'h0; // @[Controllers.scala 165:60:@1063.4]
  assign _T_154 = _T_151 & _T_153; // @[Controllers.scala 165:58:@1064.4]
  assign _T_156 = done_0_io_output == 1'h0; // @[Controllers.scala 165:76:@1065.4]
  assign _T_157 = _T_154 & _T_156; // @[Controllers.scala 165:74:@1066.4]
  assign _T_161 = _T_157 & io_enable; // @[Controllers.scala 165:109:@1069.4]
  assign _T_164 = io_ctrCopyDone_0 == 1'h0; // @[Controllers.scala 165:141:@1071.4]
  assign _T_172 = RetimeWrapper_io_out; // @[package.scala 96:25:@1083.4 package.scala 96:25:@1084.4]
  assign _T_176 = _T_172 == 1'h0; // @[Controllers.scala 167:54:@1086.4]
  assign _T_177 = io_doneIn_0 | _T_176; // @[Controllers.scala 167:52:@1087.4]
  assign _T_184 = RetimeWrapper_1_io_out; // @[package.scala 96:25:@1097.4 package.scala 96:25:@1098.4]
  assign _T_202 = RetimeWrapper_2_io_out; // @[package.scala 96:25:@1115.4 package.scala 96:25:@1116.4]
  assign _T_206 = _T_202 == 1'h0; // @[Controllers.scala 169:67:@1118.4]
  assign _T_207 = _T_206 & io_enable; // @[Controllers.scala 169:86:@1119.4]
  assign _T_219 = ~ iterDone_1_io_output; // @[Controllers.scala 165:35:@1131.4]
  assign _T_221 = io_doneIn_1 == 1'h0; // @[Controllers.scala 165:60:@1132.4]
  assign _T_222 = _T_219 & _T_221; // @[Controllers.scala 165:58:@1133.4]
  assign _T_224 = done_1_io_output == 1'h0; // @[Controllers.scala 165:76:@1134.4]
  assign _T_225 = _T_222 & _T_224; // @[Controllers.scala 165:74:@1135.4]
  assign _T_229 = _T_225 & io_enable; // @[Controllers.scala 165:109:@1138.4]
  assign _T_232 = io_ctrCopyDone_1 == 1'h0; // @[Controllers.scala 165:141:@1140.4]
  assign _T_240 = RetimeWrapper_3_io_out; // @[package.scala 96:25:@1152.4 package.scala 96:25:@1153.4]
  assign _T_244 = _T_240 == 1'h0; // @[Controllers.scala 167:54:@1155.4]
  assign _T_245 = io_doneIn_1 | _T_244; // @[Controllers.scala 167:52:@1156.4]
  assign _T_252 = RetimeWrapper_4_io_out; // @[package.scala 96:25:@1166.4 package.scala 96:25:@1167.4]
  assign _T_270 = RetimeWrapper_5_io_out; // @[package.scala 96:25:@1184.4 package.scala 96:25:@1185.4]
  assign _T_274 = _T_270 == 1'h0; // @[Controllers.scala 169:67:@1187.4]
  assign _T_275 = _T_274 & io_enable; // @[Controllers.scala 169:86:@1188.4]
  assign _T_287 = ~ iterDone_2_io_output; // @[Controllers.scala 165:35:@1200.4]
  assign _T_289 = io_doneIn_2 == 1'h0; // @[Controllers.scala 165:60:@1201.4]
  assign _T_290 = _T_287 & _T_289; // @[Controllers.scala 165:58:@1202.4]
  assign _T_292 = done_2_io_output == 1'h0; // @[Controllers.scala 165:76:@1203.4]
  assign _T_293 = _T_290 & _T_292; // @[Controllers.scala 165:74:@1204.4]
  assign _T_297 = _T_293 & io_enable; // @[Controllers.scala 165:109:@1207.4]
  assign _T_300 = io_ctrCopyDone_2 == 1'h0; // @[Controllers.scala 165:141:@1209.4]
  assign _T_308 = RetimeWrapper_6_io_out; // @[package.scala 96:25:@1221.4 package.scala 96:25:@1222.4]
  assign _T_312 = _T_308 == 1'h0; // @[Controllers.scala 167:54:@1224.4]
  assign _T_313 = io_doneIn_2 | _T_312; // @[Controllers.scala 167:52:@1225.4]
  assign _T_320 = RetimeWrapper_7_io_out; // @[package.scala 96:25:@1235.4 package.scala 96:25:@1236.4]
  assign _T_338 = RetimeWrapper_8_io_out; // @[package.scala 96:25:@1253.4 package.scala 96:25:@1254.4]
  assign _T_342 = _T_338 == 1'h0; // @[Controllers.scala 169:67:@1256.4]
  assign _T_343 = _T_342 & io_enable; // @[Controllers.scala 169:86:@1257.4]
  assign _T_358 = io_enable & active_0_io_output; // @[Controllers.scala 213:68:@1275.4]
  assign _T_360 = _T_358 & _T_151; // @[Controllers.scala 213:90:@1277.4]
  assign _T_362 = ~ allDone; // @[Controllers.scala 213:132:@1279.4]
  assign _T_366 = io_enable & active_1_io_output; // @[Controllers.scala 213:68:@1284.4]
  assign _T_368 = _T_366 & _T_219; // @[Controllers.scala 213:90:@1286.4]
  assign _T_374 = io_enable & active_2_io_output; // @[Controllers.scala 213:68:@1292.4]
  assign _T_376 = _T_374 & _T_287; // @[Controllers.scala 213:90:@1294.4]
  assign _T_383 = allDone == 1'h0; // @[package.scala 100:49:@1300.4]
  assign _T_387 = allDone & _T_386; // @[package.scala 100:41:@1303.4]
  assign io_done = RetimeWrapper_10_io_out; // @[Controllers.scala 245:13:@1329.4]
  assign io_enableOut_0 = _T_360 & _T_362; // @[Controllers.scala 213:55:@1283.4]
  assign io_enableOut_1 = _T_368 & _T_362; // @[Controllers.scala 213:55:@1291.4]
  assign io_enableOut_2 = _T_376 & _T_362; // @[Controllers.scala 213:55:@1299.4]
  assign io_childAck_0 = iterDone_0_io_output; // @[Controllers.scala 212:58:@1270.4]
  assign io_childAck_1 = iterDone_1_io_output; // @[Controllers.scala 212:58:@1272.4]
  assign io_childAck_2 = iterDone_2_io_output; // @[Controllers.scala 212:58:@1274.4]
  assign active_0_clock = clock; // @[:@966.4]
  assign active_0_reset = reset; // @[:@967.4]
  assign active_0_io_input_set = _T_161 & _T_164; // @[Controllers.scala 165:32:@1073.4]
  assign active_0_io_input_reset = io_ctrCopyDone_0 | io_parentAck; // @[Controllers.scala 166:34:@1077.4]
  assign active_0_io_input_asyn_reset = 1'h0; // @[Controllers.scala 84:40:@987.4]
  assign active_1_clock = clock; // @[:@969.4]
  assign active_1_reset = reset; // @[:@970.4]
  assign active_1_io_input_set = _T_229 & _T_232; // @[Controllers.scala 165:32:@1142.4]
  assign active_1_io_input_reset = io_ctrCopyDone_1 | io_parentAck; // @[Controllers.scala 166:34:@1146.4]
  assign active_1_io_input_asyn_reset = 1'h0; // @[Controllers.scala 84:40:@988.4]
  assign active_2_clock = clock; // @[:@972.4]
  assign active_2_reset = reset; // @[:@973.4]
  assign active_2_io_input_set = _T_297 & _T_300; // @[Controllers.scala 165:32:@1211.4]
  assign active_2_io_input_reset = io_ctrCopyDone_2 | io_parentAck; // @[Controllers.scala 166:34:@1215.4]
  assign active_2_io_input_asyn_reset = 1'h0; // @[Controllers.scala 84:40:@989.4]
  assign done_0_clock = clock; // @[:@975.4]
  assign done_0_reset = reset; // @[:@976.4]
  assign done_0_io_input_set = io_ctrCopyDone_0 | _T_207; // @[Controllers.scala 169:30:@1123.4]
  assign done_0_io_input_reset = io_parentAck; // @[Controllers.scala 86:33:@1001.4 Controllers.scala 170:32:@1130.4]
  assign done_0_io_input_asyn_reset = 1'h0; // @[Controllers.scala 85:38:@990.4]
  assign done_1_clock = clock; // @[:@978.4]
  assign done_1_reset = reset; // @[:@979.4]
  assign done_1_io_input_set = io_ctrCopyDone_1 | _T_275; // @[Controllers.scala 169:30:@1192.4]
  assign done_1_io_input_reset = io_parentAck; // @[Controllers.scala 86:33:@1010.4 Controllers.scala 170:32:@1199.4]
  assign done_1_io_input_asyn_reset = 1'h0; // @[Controllers.scala 85:38:@991.4]
  assign done_2_clock = clock; // @[:@981.4]
  assign done_2_reset = reset; // @[:@982.4]
  assign done_2_io_input_set = io_ctrCopyDone_2 | _T_343; // @[Controllers.scala 169:30:@1261.4]
  assign done_2_io_input_reset = io_parentAck; // @[Controllers.scala 86:33:@1019.4 Controllers.scala 170:32:@1268.4]
  assign done_2_io_input_asyn_reset = 1'h0; // @[Controllers.scala 85:38:@992.4]
  assign iterDone_0_clock = clock; // @[:@1022.4]
  assign iterDone_0_reset = reset; // @[:@1023.4]
  assign iterDone_0_io_input_set = _T_177 & io_enable; // @[Controllers.scala 167:34:@1091.4]
  assign iterDone_0_io_input_reset = _T_184 | io_parentAck; // @[Controllers.scala 92:37:@1041.4 Controllers.scala 168:36:@1107.4]
  assign iterDone_0_io_input_asyn_reset = 1'h0; // @[Controllers.scala 91:42:@1030.4]
  assign iterDone_1_clock = clock; // @[:@1025.4]
  assign iterDone_1_reset = reset; // @[:@1026.4]
  assign iterDone_1_io_input_set = _T_245 & io_enable; // @[Controllers.scala 167:34:@1160.4]
  assign iterDone_1_io_input_reset = _T_252 | io_parentAck; // @[Controllers.scala 92:37:@1050.4 Controllers.scala 168:36:@1176.4]
  assign iterDone_1_io_input_asyn_reset = 1'h0; // @[Controllers.scala 91:42:@1031.4]
  assign iterDone_2_clock = clock; // @[:@1028.4]
  assign iterDone_2_reset = reset; // @[:@1029.4]
  assign iterDone_2_io_input_set = _T_313 & io_enable; // @[Controllers.scala 167:34:@1229.4]
  assign iterDone_2_io_input_reset = _T_320 | io_parentAck; // @[Controllers.scala 92:37:@1059.4 Controllers.scala 168:36:@1245.4]
  assign iterDone_2_io_input_asyn_reset = 1'h0; // @[Controllers.scala 91:42:@1032.4]
  assign RetimeWrapper_clock = clock; // @[:@1079.4]
  assign RetimeWrapper_reset = reset; // @[:@1080.4]
  assign RetimeWrapper_io_flow = 1'h1; // @[package.scala 95:18:@1082.4]
  assign RetimeWrapper_io_in = 1'h1; // @[package.scala 94:16:@1081.4]
  assign RetimeWrapper_1_clock = clock; // @[:@1093.4]
  assign RetimeWrapper_1_reset = reset; // @[:@1094.4]
  assign RetimeWrapper_1_io_flow = 1'h1; // @[package.scala 95:18:@1096.4]
  assign RetimeWrapper_1_io_in = io_doneIn_0; // @[package.scala 94:16:@1095.4]
  assign RetimeWrapper_2_clock = clock; // @[:@1111.4]
  assign RetimeWrapper_2_reset = reset; // @[:@1112.4]
  assign RetimeWrapper_2_io_flow = 1'h1; // @[package.scala 95:18:@1114.4]
  assign RetimeWrapper_2_io_in = 1'h1; // @[package.scala 94:16:@1113.4]
  assign RetimeWrapper_3_clock = clock; // @[:@1148.4]
  assign RetimeWrapper_3_reset = reset; // @[:@1149.4]
  assign RetimeWrapper_3_io_flow = 1'h1; // @[package.scala 95:18:@1151.4]
  assign RetimeWrapper_3_io_in = 1'h1; // @[package.scala 94:16:@1150.4]
  assign RetimeWrapper_4_clock = clock; // @[:@1162.4]
  assign RetimeWrapper_4_reset = reset; // @[:@1163.4]
  assign RetimeWrapper_4_io_flow = 1'h1; // @[package.scala 95:18:@1165.4]
  assign RetimeWrapper_4_io_in = io_doneIn_1; // @[package.scala 94:16:@1164.4]
  assign RetimeWrapper_5_clock = clock; // @[:@1180.4]
  assign RetimeWrapper_5_reset = reset; // @[:@1181.4]
  assign RetimeWrapper_5_io_flow = 1'h1; // @[package.scala 95:18:@1183.4]
  assign RetimeWrapper_5_io_in = 1'h1; // @[package.scala 94:16:@1182.4]
  assign RetimeWrapper_6_clock = clock; // @[:@1217.4]
  assign RetimeWrapper_6_reset = reset; // @[:@1218.4]
  assign RetimeWrapper_6_io_flow = 1'h1; // @[package.scala 95:18:@1220.4]
  assign RetimeWrapper_6_io_in = 1'h1; // @[package.scala 94:16:@1219.4]
  assign RetimeWrapper_7_clock = clock; // @[:@1231.4]
  assign RetimeWrapper_7_reset = reset; // @[:@1232.4]
  assign RetimeWrapper_7_io_flow = 1'h1; // @[package.scala 95:18:@1234.4]
  assign RetimeWrapper_7_io_in = io_doneIn_2; // @[package.scala 94:16:@1233.4]
  assign RetimeWrapper_8_clock = clock; // @[:@1249.4]
  assign RetimeWrapper_8_reset = reset; // @[:@1250.4]
  assign RetimeWrapper_8_io_flow = 1'h1; // @[package.scala 95:18:@1252.4]
  assign RetimeWrapper_8_io_in = 1'h1; // @[package.scala 94:16:@1251.4]
  assign RetimeWrapper_9_clock = clock; // @[:@1306.4]
  assign RetimeWrapper_9_reset = reset; // @[:@1307.4]
  assign RetimeWrapper_9_io_flow = 1'h1; // @[package.scala 95:18:@1309.4]
  assign RetimeWrapper_9_io_in = _T_387 | io_parentAck; // @[package.scala 94:16:@1308.4]
  assign RetimeWrapper_10_clock = clock; // @[:@1323.4]
  assign RetimeWrapper_10_reset = reset; // @[:@1324.4]
  assign RetimeWrapper_10_io_flow = io_enable; // @[package.scala 95:18:@1326.4]
  assign RetimeWrapper_10_io_in = allDone & _T_400; // @[package.scala 94:16:@1325.4]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  _T_386 = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  _T_400 = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      _T_386 <= 1'h0;
    end else begin
      _T_386 <= _T_383;
    end
    if (reset) begin
      _T_400 <= 1'h0;
    end else begin
      _T_400 <= _T_383;
    end
  end
endmodule
module bbox_FF_1( // @[:@1411.2]
  input        clock, // @[:@1412.4]
  input        reset, // @[:@1413.4]
  output [5:0] io_rPort_0_output_0, // @[:@1414.4]
  input  [5:0] io_wPort_0_data_0, // @[:@1414.4]
  input        io_wPort_0_reset, // @[:@1414.4]
  input  [5:0] io_wPort_0_init, // @[:@1414.4]
  input        io_wPort_0_en_0, // @[:@1414.4]
  input        io_reset // @[:@1414.4]
);
  reg [5:0] ff; // @[MemPrimitives.scala 173:19:@1429.4]
  reg [31:0] _RAND_0;
  wire  anyReset; // @[MemPrimitives.scala 174:65:@1430.4]
  wire [5:0] _T_68; // @[MemPrimitives.scala 177:32:@1431.4]
  wire [5:0] _T_69; // @[MemPrimitives.scala 177:12:@1432.4]
  assign anyReset = io_wPort_0_reset | io_reset; // @[MemPrimitives.scala 174:65:@1430.4]
  assign _T_68 = io_wPort_0_en_0 ? io_wPort_0_data_0 : ff; // @[MemPrimitives.scala 177:32:@1431.4]
  assign _T_69 = anyReset ? io_wPort_0_init : _T_68; // @[MemPrimitives.scala 177:12:@1432.4]
  assign io_rPort_0_output_0 = ff; // @[MemPrimitives.scala 178:34:@1434.4]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  ff = _RAND_0[5:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      ff <= io_wPort_0_init;
    end else begin
      if (anyReset) begin
        ff <= io_wPort_0_init;
      end else begin
        if (io_wPort_0_en_0) begin
          ff <= io_wPort_0_data_0;
        end
      end
    end
  end
endmodule
module bbox_CompactingCounter( // @[:@1436.2]
  input        clock, // @[:@1437.4]
  input        reset, // @[:@1438.4]
  input        io_input_dir, // @[:@1439.4]
  input        io_input_reset, // @[:@1439.4]
  input        io_input_enables_0, // @[:@1439.4]
  output [5:0] io_output_count // @[:@1439.4]
);
  wire  base_clock; // @[Counter.scala 191:20:@1441.4]
  wire  base_reset; // @[Counter.scala 191:20:@1441.4]
  wire [5:0] base_io_rPort_0_output_0; // @[Counter.scala 191:20:@1441.4]
  wire [5:0] base_io_wPort_0_data_0; // @[Counter.scala 191:20:@1441.4]
  wire  base_io_wPort_0_reset; // @[Counter.scala 191:20:@1441.4]
  wire [5:0] base_io_wPort_0_init; // @[Counter.scala 191:20:@1441.4]
  wire  base_io_wPort_0_en_0; // @[Counter.scala 191:20:@1441.4]
  wire  base_io_reset; // @[Counter.scala 191:20:@1441.4]
  wire [5:0] count; // @[Counter.scala 197:42:@1460.4]
  wire [5:0] num_enabled; // @[Counter.scala 198:56:@1461.4]
  wire [6:0] _T_23; // @[Counter.scala 199:55:@1462.4]
  wire [5:0] _T_24; // @[Counter.scala 199:55:@1463.4]
  wire [5:0] _T_25; // @[Counter.scala 199:55:@1464.4]
  wire [5:0] _T_26; // @[Counter.scala 199:27:@1465.4]
  wire [6:0] _T_27; // @[Counter.scala 199:22:@1466.4]
  wire [5:0] _T_28; // @[Counter.scala 199:22:@1467.4]
  wire [5:0] newval; // @[Counter.scala 199:22:@1468.4]
  wire  _T_30; // @[Counter.scala 200:40:@1469.4]
  wire  _T_32; // @[Counter.scala 200:59:@1470.4]
  wire  isMax; // @[Counter.scala 200:18:@1471.4]
  wire [6:0] _T_34; // @[Counter.scala 201:32:@1472.4]
  wire [5:0] _T_35; // @[Counter.scala 201:32:@1473.4]
  wire [5:0] _T_36; // @[Counter.scala 201:32:@1474.4]
  wire [5:0] next; // @[Counter.scala 201:17:@1475.4]
  wire [5:0] _T_38; // @[Counter.scala 202:68:@1476.4]
  bbox_FF_1 base ( // @[Counter.scala 191:20:@1441.4]
    .clock(base_clock),
    .reset(base_reset),
    .io_rPort_0_output_0(base_io_rPort_0_output_0),
    .io_wPort_0_data_0(base_io_wPort_0_data_0),
    .io_wPort_0_reset(base_io_wPort_0_reset),
    .io_wPort_0_init(base_io_wPort_0_init),
    .io_wPort_0_en_0(base_io_wPort_0_en_0),
    .io_reset(base_io_reset)
  );
  assign count = $signed(base_io_rPort_0_output_0); // @[Counter.scala 197:42:@1460.4]
  assign num_enabled = io_input_enables_0 ? $signed(6'sh1) : $signed(6'sh0); // @[Counter.scala 198:56:@1461.4]
  assign _T_23 = $signed(6'sh0) - $signed(num_enabled); // @[Counter.scala 199:55:@1462.4]
  assign _T_24 = $signed(6'sh0) - $signed(num_enabled); // @[Counter.scala 199:55:@1463.4]
  assign _T_25 = $signed(_T_24); // @[Counter.scala 199:55:@1464.4]
  assign _T_26 = io_input_dir ? $signed(num_enabled) : $signed(_T_25); // @[Counter.scala 199:27:@1465.4]
  assign _T_27 = $signed(count) + $signed(_T_26); // @[Counter.scala 199:22:@1466.4]
  assign _T_28 = $signed(count) + $signed(_T_26); // @[Counter.scala 199:22:@1467.4]
  assign newval = $signed(_T_28); // @[Counter.scala 199:22:@1468.4]
  assign _T_30 = $signed(newval) >= $signed(6'sh8); // @[Counter.scala 200:40:@1469.4]
  assign _T_32 = $signed(newval) <= $signed(6'sh0); // @[Counter.scala 200:59:@1470.4]
  assign isMax = io_input_dir ? _T_30 : _T_32; // @[Counter.scala 200:18:@1471.4]
  assign _T_34 = $signed(newval) - $signed(6'sh8); // @[Counter.scala 201:32:@1472.4]
  assign _T_35 = $signed(newval) - $signed(6'sh8); // @[Counter.scala 201:32:@1473.4]
  assign _T_36 = $signed(_T_35); // @[Counter.scala 201:32:@1474.4]
  assign next = isMax ? $signed(_T_36) : $signed(newval); // @[Counter.scala 201:17:@1475.4]
  assign _T_38 = $unsigned(next); // @[Counter.scala 202:68:@1476.4]
  assign io_output_count = $signed(base_io_rPort_0_output_0); // @[Counter.scala 204:19:@1480.4]
  assign base_clock = clock; // @[:@1442.4]
  assign base_reset = reset; // @[:@1443.4]
  assign base_io_wPort_0_data_0 = io_input_reset ? 6'h0 : _T_38; // @[Counter.scala 202:30:@1478.4]
  assign base_io_wPort_0_reset = io_input_reset; // @[Counter.scala 194:26:@1458.4]
  assign base_io_wPort_0_init = 6'h0; // @[Counter.scala 193:25:@1457.4]
  assign base_io_wPort_0_en_0 = io_input_enables_0; // @[Counter.scala 195:28:@1459.4]
  assign base_io_reset = 1'h0;
endmodule
module bbox_CompactingIncDincCtr( // @[:@1557.2]
  input   clock, // @[:@1558.4]
  input   reset, // @[:@1559.4]
  input   io_input_inc_en_0, // @[:@1560.4]
  input   io_input_dinc_en_0, // @[:@1560.4]
  output  io_output_empty, // @[:@1560.4]
  output  io_output_full // @[:@1560.4]
);
  reg [31:0] cnt; // @[Counter.scala 162:20:@1562.4]
  reg [31:0] _RAND_0;
  wire [5:0] numPushed; // @[Counter.scala 164:47:@1563.4]
  wire [5:0] numPopped; // @[Counter.scala 165:48:@1564.4]
  wire [31:0] _GEN_0; // @[Counter.scala 166:14:@1565.4]
  wire [32:0] _T_37; // @[Counter.scala 166:14:@1565.4]
  wire [31:0] _T_38; // @[Counter.scala 166:14:@1566.4]
  wire [31:0] _T_39; // @[Counter.scala 166:14:@1567.4]
  wire [31:0] _GEN_1; // @[Counter.scala 166:26:@1568.4]
  wire [32:0] _T_40; // @[Counter.scala 166:26:@1568.4]
  wire [31:0] _T_41; // @[Counter.scala 166:26:@1569.4]
  wire [31:0] _T_42; // @[Counter.scala 166:26:@1570.4]
  assign numPushed = io_input_inc_en_0 ? $signed(6'sh1) : $signed(6'sh0); // @[Counter.scala 164:47:@1563.4]
  assign numPopped = io_input_dinc_en_0 ? $signed(6'sh1) : $signed(6'sh0); // @[Counter.scala 165:48:@1564.4]
  assign _GEN_0 = {{26{numPushed[5]}},numPushed}; // @[Counter.scala 166:14:@1565.4]
  assign _T_37 = $signed(cnt) + $signed(_GEN_0); // @[Counter.scala 166:14:@1565.4]
  assign _T_38 = $signed(cnt) + $signed(_GEN_0); // @[Counter.scala 166:14:@1566.4]
  assign _T_39 = $signed(_T_38); // @[Counter.scala 166:14:@1567.4]
  assign _GEN_1 = {{26{numPopped[5]}},numPopped}; // @[Counter.scala 166:26:@1568.4]
  assign _T_40 = $signed(_T_39) - $signed(_GEN_1); // @[Counter.scala 166:26:@1568.4]
  assign _T_41 = $signed(_T_39) - $signed(_GEN_1); // @[Counter.scala 166:26:@1569.4]
  assign _T_42 = $signed(_T_41); // @[Counter.scala 166:26:@1570.4]
  assign io_output_empty = $signed(cnt) == $signed(32'sh0); // @[Counter.scala 170:19:@1577.4]
  assign io_output_full = $signed(cnt) > $signed(32'sh7); // @[Counter.scala 172:18:@1584.4]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  cnt = _RAND_0[31:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      cnt <= 32'sh0;
    end else begin
      cnt <= _T_42;
    end
  end
endmodule
module bbox_Mem1D( // @[:@1592.2]
  input         clock, // @[:@1593.4]
  input  [3:0]  io_r_ofs_0, // @[:@1595.4]
  input  [3:0]  io_w_ofs_0, // @[:@1595.4]
  input  [31:0] io_w_data_0, // @[:@1595.4]
  input         io_w_en_0, // @[:@1595.4]
  output [31:0] io_output // @[:@1595.4]
);
  reg [31:0] _T_127 [0:7]; // @[MemPrimitives.scala 585:18:@1599.4]
  reg [31:0] _RAND_0;
  wire [31:0] _T_127__T_132_data; // @[MemPrimitives.scala 585:18:@1599.4]
  wire [2:0] _T_127__T_132_addr; // @[MemPrimitives.scala 585:18:@1599.4]
  wire [31:0] _T_127__T_130_data; // @[MemPrimitives.scala 585:18:@1599.4]
  wire [2:0] _T_127__T_130_addr; // @[MemPrimitives.scala 585:18:@1599.4]
  wire  _T_127__T_130_mask; // @[MemPrimitives.scala 585:18:@1599.4]
  wire  _T_127__T_130_en; // @[MemPrimitives.scala 585:18:@1599.4]
  wire  wInBound; // @[MemPrimitives.scala 554:32:@1597.4]
  assign _T_127__T_132_addr = io_r_ofs_0[2:0];
  assign _T_127__T_132_data = _T_127[_T_127__T_132_addr]; // @[MemPrimitives.scala 585:18:@1599.4]
  assign _T_127__T_130_data = io_w_data_0;
  assign _T_127__T_130_addr = io_w_ofs_0[2:0];
  assign _T_127__T_130_mask = 1'h1;
  assign _T_127__T_130_en = io_w_en_0 & wInBound;
  assign wInBound = io_w_ofs_0 <= 4'h8; // @[MemPrimitives.scala 554:32:@1597.4]
  assign io_output = _T_127__T_132_data; // @[MemPrimitives.scala 587:17:@1608.4]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      #0.002 begin end
    `endif
  _RAND_0 = {1{`RANDOM}};
  `ifdef RANDOMIZE_MEM_INIT
  for (initvar = 0; initvar < 8; initvar = initvar+1)
    _T_127[initvar] = _RAND_0[31:0];
  `endif // RANDOMIZE_MEM_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if(_T_127__T_130_en & _T_127__T_130_mask) begin
      _T_127[_T_127__T_130_addr] <= _T_127__T_130_data; // @[MemPrimitives.scala 585:18:@1599.4]
    end
  end
endmodule
module bbox_Compactor( // @[:@1610.2]
  input  [31:0] io_in_0_data, // @[:@1613.4]
  output [31:0] io_out_0_data // @[:@1613.4]
);
  assign io_out_0_data = io_in_0_data; // @[MemPrimitives.scala 616:22:@1617.4]
endmodule
module bbox_CompactingEnqNetwork( // @[:@1621.2]
  input  [5:0]  io_headCnt, // @[:@1624.4]
  input  [31:0] io_in_0_data, // @[:@1624.4]
  input         io_in_0_en, // @[:@1624.4]
  output [31:0] io_out_0_data, // @[:@1624.4]
  output        io_out_0_en // @[:@1624.4]
);
  wire [31:0] compactor_io_in_0_data; // @[MemPrimitives.scala 638:25:@1627.4]
  wire [31:0] compactor_io_out_0_data; // @[MemPrimitives.scala 638:25:@1627.4]
  wire [5:0] numEnabled; // @[MemPrimitives.scala 634:38:@1626.4]
  wire [5:0] _GEN_0; // @[Math.scala 53:59:@1633.4]
  wire [5:0] current_base_bank; // @[Math.scala 53:59:@1633.4]
  wire [5:0] _T_22; // @[MemPrimitives.scala 644:46:@1634.4]
  wire [6:0] _T_23; // @[MemPrimitives.scala 644:33:@1635.4]
  wire [5:0] _T_24; // @[MemPrimitives.scala 644:33:@1636.4]
  wire [5:0] _T_25; // @[MemPrimitives.scala 644:33:@1637.4]
  wire [6:0] _T_27; // @[MemPrimitives.scala 644:53:@1638.4]
  wire [5:0] _T_28; // @[MemPrimitives.scala 644:53:@1639.4]
  wire [5:0] upper; // @[MemPrimitives.scala 644:53:@1640.4]
  wire  _T_30; // @[MemPrimitives.scala 645:34:@1641.4]
  wire [5:0] num_straddling; // @[MemPrimitives.scala 645:27:@1642.4]
  wire [6:0] _T_33; // @[MemPrimitives.scala 646:42:@1644.4]
  wire [5:0] _T_34; // @[MemPrimitives.scala 646:42:@1645.4]
  wire [5:0] num_straight; // @[MemPrimitives.scala 646:42:@1646.4]
  wire  _T_36; // @[MemPrimitives.scala 648:40:@1647.4]
  wire  _T_38; // @[MemPrimitives.scala 648:73:@1648.4]
  wire  _T_44; // @[MemPrimitives.scala 648:109:@1653.4]
  wire  _T_45; // @[MemPrimitives.scala 648:94:@1654.4]
  wire [6:0] _T_53; // @[MemPrimitives.scala 649:72:@1658.4]
  wire [5:0] _T_54; // @[MemPrimitives.scala 649:72:@1659.4]
  wire [5:0] _T_55; // @[MemPrimitives.scala 649:72:@1660.4]
  wire [6:0] _T_57; // @[MemPrimitives.scala 649:101:@1661.4]
  wire [5:0] _T_58; // @[MemPrimitives.scala 649:101:@1662.4]
  wire [5:0] _T_59; // @[MemPrimitives.scala 649:101:@1663.4]
  wire [5:0] _T_60; // @[MemPrimitives.scala 649:27:@1664.4]
  wire [5:0] _T_62; // @[MemPrimitives.scala 653:57:@1665.4]
  wire  _T_64; // @[Mux.scala 46:19:@1666.4]
  bbox_Compactor compactor ( // @[MemPrimitives.scala 638:25:@1627.4]
    .io_in_0_data(compactor_io_in_0_data),
    .io_out_0_data(compactor_io_out_0_data)
  );
  assign numEnabled = io_in_0_en ? 6'h1 : 6'h0; // @[MemPrimitives.scala 634:38:@1626.4]
  assign _GEN_0 = $signed(io_headCnt) % $signed(6'sh1); // @[Math.scala 53:59:@1633.4]
  assign current_base_bank = _GEN_0[5:0]; // @[Math.scala 53:59:@1633.4]
  assign _T_22 = $signed(numEnabled); // @[MemPrimitives.scala 644:46:@1634.4]
  assign _T_23 = $signed(current_base_bank) + $signed(_T_22); // @[MemPrimitives.scala 644:33:@1635.4]
  assign _T_24 = $signed(current_base_bank) + $signed(_T_22); // @[MemPrimitives.scala 644:33:@1636.4]
  assign _T_25 = $signed(_T_24); // @[MemPrimitives.scala 644:33:@1637.4]
  assign _T_27 = $signed(_T_25) - $signed(6'sh1); // @[MemPrimitives.scala 644:53:@1638.4]
  assign _T_28 = $signed(_T_25) - $signed(6'sh1); // @[MemPrimitives.scala 644:53:@1639.4]
  assign upper = $signed(_T_28); // @[MemPrimitives.scala 644:53:@1640.4]
  assign _T_30 = $signed(upper) < $signed(6'sh0); // @[MemPrimitives.scala 645:34:@1641.4]
  assign num_straddling = _T_30 ? $signed(6'sh0) : $signed(upper); // @[MemPrimitives.scala 645:27:@1642.4]
  assign _T_33 = $signed(_T_22) - $signed(num_straddling); // @[MemPrimitives.scala 646:42:@1644.4]
  assign _T_34 = $signed(_T_22) - $signed(num_straddling); // @[MemPrimitives.scala 646:42:@1645.4]
  assign num_straight = $signed(_T_34); // @[MemPrimitives.scala 646:42:@1646.4]
  assign _T_36 = $signed(6'sh0) < $signed(num_straddling); // @[MemPrimitives.scala 648:40:@1647.4]
  assign _T_38 = $signed(6'sh0) >= $signed(current_base_bank); // @[MemPrimitives.scala 648:73:@1648.4]
  assign _T_44 = $signed(6'sh0) < $signed(_T_25); // @[MemPrimitives.scala 648:109:@1653.4]
  assign _T_45 = _T_38 & _T_44; // @[MemPrimitives.scala 648:94:@1654.4]
  assign _T_53 = {{1{num_straight[5]}},num_straight}; // @[MemPrimitives.scala 649:72:@1658.4]
  assign _T_54 = _T_53[5:0]; // @[MemPrimitives.scala 649:72:@1659.4]
  assign _T_55 = $signed(_T_54); // @[MemPrimitives.scala 649:72:@1660.4]
  assign _T_57 = $signed(6'sh0) - $signed(current_base_bank); // @[MemPrimitives.scala 649:101:@1661.4]
  assign _T_58 = $signed(6'sh0) - $signed(current_base_bank); // @[MemPrimitives.scala 649:101:@1662.4]
  assign _T_59 = $signed(_T_58); // @[MemPrimitives.scala 649:101:@1663.4]
  assign _T_60 = _T_36 ? $signed(_T_55) : $signed(_T_59); // @[MemPrimitives.scala 649:27:@1664.4]
  assign _T_62 = $unsigned(_T_60); // @[MemPrimitives.scala 653:57:@1665.4]
  assign _T_64 = 6'h0 == _T_62; // @[Mux.scala 46:19:@1666.4]
  assign io_out_0_data = _T_64 ? compactor_io_out_0_data : 32'h0; // @[MemPrimitives.scala 658:63:@1668.4]
  assign io_out_0_en = _T_36 | _T_45; // @[MemPrimitives.scala 659:63:@1669.4]
  assign compactor_io_in_0_data = io_in_0_data; // @[MemPrimitives.scala 639:19:@1631.4]
endmodule
module bbox_CompactingDeqNetwork( // @[:@1671.2]
  input  [5:0]  io_tailCnt, // @[:@1674.4]
  input  [31:0] io_input_data_0, // @[:@1674.4]
  output [31:0] io_output_0 // @[:@1674.4]
);
  wire [5:0] _GEN_0; // @[Math.scala 53:59:@1678.4]
  wire [5:0] current_base_bank; // @[Math.scala 53:59:@1678.4]
  wire [5:0] _T_55; // @[MemPrimitives.scala 685:65:@1701.4]
  wire [6:0] _T_56; // @[MemPrimitives.scala 685:72:@1702.4]
  wire [5:0] _T_57; // @[MemPrimitives.scala 685:72:@1703.4]
  wire [5:0] _GEN_1; // @[Math.scala 55:59:@1704.4]
  wire [5:0] _T_59; // @[Math.scala 55:59:@1704.4]
  wire  _T_62; // @[Mux.scala 46:19:@1705.4]
  assign _GEN_0 = $signed(io_tailCnt) % $signed(6'sh1); // @[Math.scala 53:59:@1678.4]
  assign current_base_bank = _GEN_0[5:0]; // @[Math.scala 53:59:@1678.4]
  assign _T_55 = $unsigned(current_base_bank); // @[MemPrimitives.scala 685:65:@1701.4]
  assign _T_56 = {{1'd0}, _T_55}; // @[MemPrimitives.scala 685:72:@1702.4]
  assign _T_57 = _T_56[5:0]; // @[MemPrimitives.scala 685:72:@1703.4]
  assign _GEN_1 = _T_57 % 6'h1; // @[Math.scala 55:59:@1704.4]
  assign _T_59 = _GEN_1[5:0]; // @[Math.scala 55:59:@1704.4]
  assign _T_62 = 6'h0 == _T_59; // @[Mux.scala 46:19:@1705.4]
  assign io_output_0 = _T_62 ? io_input_data_0 : 32'h0; // @[MemPrimitives.scala 689:18:@1707.4]
endmodule
module bbox_x76_numel_0( // @[:@1709.2]
  input         clock, // @[:@1710.4]
  input         reset, // @[:@1711.4]
  input         io_rPort_0_en_0, // @[:@1712.4]
  output [31:0] io_rPort_0_output_0, // @[:@1712.4]
  input  [31:0] io_wPort_0_data_0, // @[:@1712.4]
  input         io_wPort_0_en_0, // @[:@1712.4]
  output        io_full, // @[:@1712.4]
  output        io_empty, // @[:@1712.4]
  output        io_accessActivesOut_0, // @[:@1712.4]
  input         io_accessActivesIn_0 // @[:@1712.4]
);
  wire  headCtr_clock; // @[MemPrimitives.scala 233:23:@1736.4]
  wire  headCtr_reset; // @[MemPrimitives.scala 233:23:@1736.4]
  wire  headCtr_io_input_dir; // @[MemPrimitives.scala 233:23:@1736.4]
  wire  headCtr_io_input_reset; // @[MemPrimitives.scala 233:23:@1736.4]
  wire  headCtr_io_input_enables_0; // @[MemPrimitives.scala 233:23:@1736.4]
  wire [5:0] headCtr_io_output_count; // @[MemPrimitives.scala 233:23:@1736.4]
  wire  tailCtr_clock; // @[MemPrimitives.scala 234:23:@1744.4]
  wire  tailCtr_reset; // @[MemPrimitives.scala 234:23:@1744.4]
  wire  tailCtr_io_input_dir; // @[MemPrimitives.scala 234:23:@1744.4]
  wire  tailCtr_io_input_reset; // @[MemPrimitives.scala 234:23:@1744.4]
  wire  tailCtr_io_input_enables_0; // @[MemPrimitives.scala 234:23:@1744.4]
  wire [5:0] tailCtr_io_output_count; // @[MemPrimitives.scala 234:23:@1744.4]
  wire  elements_clock; // @[MemPrimitives.scala 244:24:@1758.4]
  wire  elements_reset; // @[MemPrimitives.scala 244:24:@1758.4]
  wire  elements_io_input_inc_en_0; // @[MemPrimitives.scala 244:24:@1758.4]
  wire  elements_io_input_dinc_en_0; // @[MemPrimitives.scala 244:24:@1758.4]
  wire  elements_io_output_empty; // @[MemPrimitives.scala 244:24:@1758.4]
  wire  elements_io_output_full; // @[MemPrimitives.scala 244:24:@1758.4]
  wire  m_0_clock; // @[MemPrimitives.scala 250:56:@1772.4]
  wire [3:0] m_0_io_r_ofs_0; // @[MemPrimitives.scala 250:56:@1772.4]
  wire [3:0] m_0_io_w_ofs_0; // @[MemPrimitives.scala 250:56:@1772.4]
  wire [31:0] m_0_io_w_data_0; // @[MemPrimitives.scala 250:56:@1772.4]
  wire  m_0_io_w_en_0; // @[MemPrimitives.scala 250:56:@1772.4]
  wire [31:0] m_0_io_output; // @[MemPrimitives.scala 250:56:@1772.4]
  wire [5:0] enqCompactor_io_headCnt; // @[MemPrimitives.scala 254:28:@1788.4]
  wire [31:0] enqCompactor_io_in_0_data; // @[MemPrimitives.scala 254:28:@1788.4]
  wire  enqCompactor_io_in_0_en; // @[MemPrimitives.scala 254:28:@1788.4]
  wire [31:0] enqCompactor_io_out_0_data; // @[MemPrimitives.scala 254:28:@1788.4]
  wire  enqCompactor_io_out_0_en; // @[MemPrimitives.scala 254:28:@1788.4]
  wire [5:0] deqCompactor_io_tailCnt; // @[MemPrimitives.scala 273:28:@1810.4]
  wire [31:0] deqCompactor_io_input_data_0; // @[MemPrimitives.scala 273:28:@1810.4]
  wire [31:0] deqCompactor_io_output_0; // @[MemPrimitives.scala 273:28:@1810.4]
  wire [5:0] _GEN_0; // @[Math.scala 53:59:@1799.4]
  wire [5:0] active_w_bank; // @[Math.scala 53:59:@1799.4]
  wire [6:0] active_w_addr; // @[Math.scala 52:59:@1800.4]
  wire  _T_94; // @[MemPrimitives.scala 266:38:@1801.4]
  wire [7:0] _T_96; // @[MemPrimitives.scala 266:69:@1802.4]
  wire [6:0] _T_97; // @[MemPrimitives.scala 266:69:@1803.4]
  wire [6:0] _T_98; // @[MemPrimitives.scala 266:69:@1804.4]
  wire [6:0] _T_99; // @[MemPrimitives.scala 266:19:@1805.4]
  wire [6:0] _T_100; // @[MemPrimitives.scala 267:32:@1806.4]
  wire [5:0] _GEN_1; // @[Math.scala 53:59:@1818.4]
  wire [5:0] active_r_bank; // @[Math.scala 53:59:@1818.4]
  wire [6:0] active_r_addr; // @[Math.scala 52:59:@1819.4]
  wire  _T_104; // @[MemPrimitives.scala 279:38:@1820.4]
  wire [7:0] _T_106; // @[MemPrimitives.scala 279:69:@1821.4]
  wire [6:0] _T_107; // @[MemPrimitives.scala 279:69:@1822.4]
  wire [6:0] _T_108; // @[MemPrimitives.scala 279:69:@1823.4]
  wire [6:0] _T_109; // @[MemPrimitives.scala 279:19:@1824.4]
  wire [6:0] _T_110; // @[MemPrimitives.scala 280:32:@1825.4]
  bbox_CompactingCounter headCtr ( // @[MemPrimitives.scala 233:23:@1736.4]
    .clock(headCtr_clock),
    .reset(headCtr_reset),
    .io_input_dir(headCtr_io_input_dir),
    .io_input_reset(headCtr_io_input_reset),
    .io_input_enables_0(headCtr_io_input_enables_0),
    .io_output_count(headCtr_io_output_count)
  );
  bbox_CompactingCounter tailCtr ( // @[MemPrimitives.scala 234:23:@1744.4]
    .clock(tailCtr_clock),
    .reset(tailCtr_reset),
    .io_input_dir(tailCtr_io_input_dir),
    .io_input_reset(tailCtr_io_input_reset),
    .io_input_enables_0(tailCtr_io_input_enables_0),
    .io_output_count(tailCtr_io_output_count)
  );
  bbox_CompactingIncDincCtr elements ( // @[MemPrimitives.scala 244:24:@1758.4]
    .clock(elements_clock),
    .reset(elements_reset),
    .io_input_inc_en_0(elements_io_input_inc_en_0),
    .io_input_dinc_en_0(elements_io_input_dinc_en_0),
    .io_output_empty(elements_io_output_empty),
    .io_output_full(elements_io_output_full)
  );
  bbox_Mem1D m_0 ( // @[MemPrimitives.scala 250:56:@1772.4]
    .clock(m_0_clock),
    .io_r_ofs_0(m_0_io_r_ofs_0),
    .io_w_ofs_0(m_0_io_w_ofs_0),
    .io_w_data_0(m_0_io_w_data_0),
    .io_w_en_0(m_0_io_w_en_0),
    .io_output(m_0_io_output)
  );
  bbox_CompactingEnqNetwork enqCompactor ( // @[MemPrimitives.scala 254:28:@1788.4]
    .io_headCnt(enqCompactor_io_headCnt),
    .io_in_0_data(enqCompactor_io_in_0_data),
    .io_in_0_en(enqCompactor_io_in_0_en),
    .io_out_0_data(enqCompactor_io_out_0_data),
    .io_out_0_en(enqCompactor_io_out_0_en)
  );
  bbox_CompactingDeqNetwork deqCompactor ( // @[MemPrimitives.scala 273:28:@1810.4]
    .io_tailCnt(deqCompactor_io_tailCnt),
    .io_input_data_0(deqCompactor_io_input_data_0),
    .io_output_0(deqCompactor_io_output_0)
  );
  assign _GEN_0 = $signed(headCtr_io_output_count) % $signed(6'sh1); // @[Math.scala 53:59:@1799.4]
  assign active_w_bank = _GEN_0[5:0]; // @[Math.scala 53:59:@1799.4]
  assign active_w_addr = $signed(headCtr_io_output_count) / $signed(6'sh1); // @[Math.scala 52:59:@1800.4]
  assign _T_94 = $signed(6'sh0) < $signed(active_w_bank); // @[MemPrimitives.scala 266:38:@1801.4]
  assign _T_96 = $signed(active_w_addr) + $signed(7'sh1); // @[MemPrimitives.scala 266:69:@1802.4]
  assign _T_97 = $signed(active_w_addr) + $signed(7'sh1); // @[MemPrimitives.scala 266:69:@1803.4]
  assign _T_98 = $signed(_T_97); // @[MemPrimitives.scala 266:69:@1804.4]
  assign _T_99 = _T_94 ? $signed(_T_98) : $signed(active_w_addr); // @[MemPrimitives.scala 266:19:@1805.4]
  assign _T_100 = $unsigned(_T_99); // @[MemPrimitives.scala 267:32:@1806.4]
  assign _GEN_1 = $signed(tailCtr_io_output_count) % $signed(6'sh1); // @[Math.scala 53:59:@1818.4]
  assign active_r_bank = _GEN_1[5:0]; // @[Math.scala 53:59:@1818.4]
  assign active_r_addr = $signed(tailCtr_io_output_count) / $signed(6'sh1); // @[Math.scala 52:59:@1819.4]
  assign _T_104 = $signed(6'sh0) < $signed(active_r_bank); // @[MemPrimitives.scala 279:38:@1820.4]
  assign _T_106 = $signed(active_r_addr) + $signed(7'sh1); // @[MemPrimitives.scala 279:69:@1821.4]
  assign _T_107 = $signed(active_r_addr) + $signed(7'sh1); // @[MemPrimitives.scala 279:69:@1822.4]
  assign _T_108 = $signed(_T_107); // @[MemPrimitives.scala 279:69:@1823.4]
  assign _T_109 = _T_104 ? $signed(_T_108) : $signed(active_r_addr); // @[MemPrimitives.scala 279:19:@1824.4]
  assign _T_110 = $unsigned(_T_109); // @[MemPrimitives.scala 280:32:@1825.4]
  assign io_rPort_0_output_0 = deqCompactor_io_output_0; // @[MemPrimitives.scala 284:82:@1829.4]
  assign io_full = elements_io_output_full; // @[MemPrimitives.scala 291:39:@1833.4]
  assign io_empty = elements_io_output_empty; // @[MemPrimitives.scala 290:40:@1832.4]
  assign io_accessActivesOut_0 = io_accessActivesIn_0; // @[MemPrimitives.scala 289:127:@1830.4]
  assign headCtr_clock = clock; // @[:@1737.4]
  assign headCtr_reset = reset; // @[:@1738.4]
  assign headCtr_io_input_dir = 1'h1; // @[MemPrimitives.scala 239:24:@1756.4]
  assign headCtr_io_input_reset = reset; // @[MemPrimitives.scala 237:26:@1754.4]
  assign headCtr_io_input_enables_0 = io_wPort_0_en_0; // @[MemPrimitives.scala 235:129:@1752.4]
  assign tailCtr_clock = clock; // @[:@1745.4]
  assign tailCtr_reset = reset; // @[:@1746.4]
  assign tailCtr_io_input_dir = 1'h1; // @[MemPrimitives.scala 240:24:@1757.4]
  assign tailCtr_io_input_reset = reset; // @[MemPrimitives.scala 238:26:@1755.4]
  assign tailCtr_io_input_enables_0 = io_rPort_0_en_0; // @[MemPrimitives.scala 236:129:@1753.4]
  assign elements_clock = clock; // @[:@1759.4]
  assign elements_reset = reset; // @[:@1760.4]
  assign elements_io_input_inc_en_0 = io_wPort_0_en_0; // @[MemPrimitives.scala 246:79:@1770.4]
  assign elements_io_input_dinc_en_0 = io_rPort_0_en_0; // @[MemPrimitives.scala 247:80:@1771.4]
  assign m_0_clock = clock; // @[:@1773.4]
  assign m_0_io_r_ofs_0 = _T_110[3:0]; // @[MemPrimitives.scala 280:24:@1826.4]
  assign m_0_io_w_ofs_0 = _T_100[3:0]; // @[MemPrimitives.scala 267:24:@1807.4]
  assign m_0_io_w_data_0 = enqCompactor_io_out_0_data; // @[MemPrimitives.scala 268:25:@1808.4]
  assign m_0_io_w_en_0 = enqCompactor_io_out_0_en; // @[MemPrimitives.scala 269:25:@1809.4]
  assign enqCompactor_io_headCnt = headCtr_io_output_count; // @[MemPrimitives.scala 256:27:@1796.4]
  assign enqCompactor_io_in_0_data = io_wPort_0_data_0; // @[MemPrimitives.scala 258:90:@1797.4]
  assign enqCompactor_io_in_0_en = io_wPort_0_en_0; // @[MemPrimitives.scala 259:85:@1798.4]
  assign deqCompactor_io_tailCnt = tailCtr_io_output_count; // @[MemPrimitives.scala 275:27:@1817.4]
  assign deqCompactor_io_input_data_0 = m_0_io_output; // @[MemPrimitives.scala 281:35:@1827.4]
endmodule
module bbox_Mem1D_1( // @[:@2020.2]
  input         clock, // @[:@2021.4]
  input  [3:0]  io_r_ofs_0, // @[:@2023.4]
  input  [3:0]  io_w_ofs_0, // @[:@2023.4]
  input  [15:0] io_w_data_0, // @[:@2023.4]
  input         io_w_en_0, // @[:@2023.4]
  output [15:0] io_output // @[:@2023.4]
);
  reg [15:0] _T_127 [0:7]; // @[MemPrimitives.scala 585:18:@2027.4]
  reg [31:0] _RAND_0;
  wire [15:0] _T_127__T_132_data; // @[MemPrimitives.scala 585:18:@2027.4]
  wire [2:0] _T_127__T_132_addr; // @[MemPrimitives.scala 585:18:@2027.4]
  wire [15:0] _T_127__T_130_data; // @[MemPrimitives.scala 585:18:@2027.4]
  wire [2:0] _T_127__T_130_addr; // @[MemPrimitives.scala 585:18:@2027.4]
  wire  _T_127__T_130_mask; // @[MemPrimitives.scala 585:18:@2027.4]
  wire  _T_127__T_130_en; // @[MemPrimitives.scala 585:18:@2027.4]
  wire  wInBound; // @[MemPrimitives.scala 554:32:@2025.4]
  assign _T_127__T_132_addr = io_r_ofs_0[2:0];
  assign _T_127__T_132_data = _T_127[_T_127__T_132_addr]; // @[MemPrimitives.scala 585:18:@2027.4]
  assign _T_127__T_130_data = io_w_data_0;
  assign _T_127__T_130_addr = io_w_ofs_0[2:0];
  assign _T_127__T_130_mask = 1'h1;
  assign _T_127__T_130_en = io_w_en_0 & wInBound;
  assign wInBound = io_w_ofs_0 <= 4'h8; // @[MemPrimitives.scala 554:32:@2025.4]
  assign io_output = _T_127__T_132_data; // @[MemPrimitives.scala 587:17:@2036.4]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      #0.002 begin end
    `endif
  _RAND_0 = {1{`RANDOM}};
  `ifdef RANDOMIZE_MEM_INIT
  for (initvar = 0; initvar < 8; initvar = initvar+1)
    _T_127[initvar] = _RAND_0[15:0];
  `endif // RANDOMIZE_MEM_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if(_T_127__T_130_en & _T_127__T_130_mask) begin
      _T_127[_T_127__T_130_addr] <= _T_127__T_130_data; // @[MemPrimitives.scala 585:18:@2027.4]
    end
  end
endmodule
module bbox_Compactor_1( // @[:@2038.2]
  input  [15:0] io_in_0_data, // @[:@2041.4]
  output [15:0] io_out_0_data // @[:@2041.4]
);
  assign io_out_0_data = io_in_0_data; // @[MemPrimitives.scala 616:22:@2045.4]
endmodule
module bbox_CompactingEnqNetwork_1( // @[:@2049.2]
  input  [5:0]  io_headCnt, // @[:@2052.4]
  input  [15:0] io_in_0_data, // @[:@2052.4]
  input         io_in_0_en, // @[:@2052.4]
  output [15:0] io_out_0_data, // @[:@2052.4]
  output        io_out_0_en // @[:@2052.4]
);
  wire [15:0] compactor_io_in_0_data; // @[MemPrimitives.scala 638:25:@2055.4]
  wire [15:0] compactor_io_out_0_data; // @[MemPrimitives.scala 638:25:@2055.4]
  wire [5:0] numEnabled; // @[MemPrimitives.scala 634:38:@2054.4]
  wire [5:0] _GEN_0; // @[Math.scala 53:59:@2061.4]
  wire [5:0] current_base_bank; // @[Math.scala 53:59:@2061.4]
  wire [5:0] _T_22; // @[MemPrimitives.scala 644:46:@2062.4]
  wire [6:0] _T_23; // @[MemPrimitives.scala 644:33:@2063.4]
  wire [5:0] _T_24; // @[MemPrimitives.scala 644:33:@2064.4]
  wire [5:0] _T_25; // @[MemPrimitives.scala 644:33:@2065.4]
  wire [6:0] _T_27; // @[MemPrimitives.scala 644:53:@2066.4]
  wire [5:0] _T_28; // @[MemPrimitives.scala 644:53:@2067.4]
  wire [5:0] upper; // @[MemPrimitives.scala 644:53:@2068.4]
  wire  _T_30; // @[MemPrimitives.scala 645:34:@2069.4]
  wire [5:0] num_straddling; // @[MemPrimitives.scala 645:27:@2070.4]
  wire [6:0] _T_33; // @[MemPrimitives.scala 646:42:@2072.4]
  wire [5:0] _T_34; // @[MemPrimitives.scala 646:42:@2073.4]
  wire [5:0] num_straight; // @[MemPrimitives.scala 646:42:@2074.4]
  wire  _T_36; // @[MemPrimitives.scala 648:40:@2075.4]
  wire  _T_38; // @[MemPrimitives.scala 648:73:@2076.4]
  wire  _T_44; // @[MemPrimitives.scala 648:109:@2081.4]
  wire  _T_45; // @[MemPrimitives.scala 648:94:@2082.4]
  wire [6:0] _T_53; // @[MemPrimitives.scala 649:72:@2086.4]
  wire [5:0] _T_54; // @[MemPrimitives.scala 649:72:@2087.4]
  wire [5:0] _T_55; // @[MemPrimitives.scala 649:72:@2088.4]
  wire [6:0] _T_57; // @[MemPrimitives.scala 649:101:@2089.4]
  wire [5:0] _T_58; // @[MemPrimitives.scala 649:101:@2090.4]
  wire [5:0] _T_59; // @[MemPrimitives.scala 649:101:@2091.4]
  wire [5:0] _T_60; // @[MemPrimitives.scala 649:27:@2092.4]
  wire [5:0] _T_62; // @[MemPrimitives.scala 653:57:@2093.4]
  wire  _T_64; // @[Mux.scala 46:19:@2094.4]
  bbox_Compactor_1 compactor ( // @[MemPrimitives.scala 638:25:@2055.4]
    .io_in_0_data(compactor_io_in_0_data),
    .io_out_0_data(compactor_io_out_0_data)
  );
  assign numEnabled = io_in_0_en ? 6'h1 : 6'h0; // @[MemPrimitives.scala 634:38:@2054.4]
  assign _GEN_0 = $signed(io_headCnt) % $signed(6'sh1); // @[Math.scala 53:59:@2061.4]
  assign current_base_bank = _GEN_0[5:0]; // @[Math.scala 53:59:@2061.4]
  assign _T_22 = $signed(numEnabled); // @[MemPrimitives.scala 644:46:@2062.4]
  assign _T_23 = $signed(current_base_bank) + $signed(_T_22); // @[MemPrimitives.scala 644:33:@2063.4]
  assign _T_24 = $signed(current_base_bank) + $signed(_T_22); // @[MemPrimitives.scala 644:33:@2064.4]
  assign _T_25 = $signed(_T_24); // @[MemPrimitives.scala 644:33:@2065.4]
  assign _T_27 = $signed(_T_25) - $signed(6'sh1); // @[MemPrimitives.scala 644:53:@2066.4]
  assign _T_28 = $signed(_T_25) - $signed(6'sh1); // @[MemPrimitives.scala 644:53:@2067.4]
  assign upper = $signed(_T_28); // @[MemPrimitives.scala 644:53:@2068.4]
  assign _T_30 = $signed(upper) < $signed(6'sh0); // @[MemPrimitives.scala 645:34:@2069.4]
  assign num_straddling = _T_30 ? $signed(6'sh0) : $signed(upper); // @[MemPrimitives.scala 645:27:@2070.4]
  assign _T_33 = $signed(_T_22) - $signed(num_straddling); // @[MemPrimitives.scala 646:42:@2072.4]
  assign _T_34 = $signed(_T_22) - $signed(num_straddling); // @[MemPrimitives.scala 646:42:@2073.4]
  assign num_straight = $signed(_T_34); // @[MemPrimitives.scala 646:42:@2074.4]
  assign _T_36 = $signed(6'sh0) < $signed(num_straddling); // @[MemPrimitives.scala 648:40:@2075.4]
  assign _T_38 = $signed(6'sh0) >= $signed(current_base_bank); // @[MemPrimitives.scala 648:73:@2076.4]
  assign _T_44 = $signed(6'sh0) < $signed(_T_25); // @[MemPrimitives.scala 648:109:@2081.4]
  assign _T_45 = _T_38 & _T_44; // @[MemPrimitives.scala 648:94:@2082.4]
  assign _T_53 = {{1{num_straight[5]}},num_straight}; // @[MemPrimitives.scala 649:72:@2086.4]
  assign _T_54 = _T_53[5:0]; // @[MemPrimitives.scala 649:72:@2087.4]
  assign _T_55 = $signed(_T_54); // @[MemPrimitives.scala 649:72:@2088.4]
  assign _T_57 = $signed(6'sh0) - $signed(current_base_bank); // @[MemPrimitives.scala 649:101:@2089.4]
  assign _T_58 = $signed(6'sh0) - $signed(current_base_bank); // @[MemPrimitives.scala 649:101:@2090.4]
  assign _T_59 = $signed(_T_58); // @[MemPrimitives.scala 649:101:@2091.4]
  assign _T_60 = _T_36 ? $signed(_T_55) : $signed(_T_59); // @[MemPrimitives.scala 649:27:@2092.4]
  assign _T_62 = $unsigned(_T_60); // @[MemPrimitives.scala 653:57:@2093.4]
  assign _T_64 = 6'h0 == _T_62; // @[Mux.scala 46:19:@2094.4]
  assign io_out_0_data = _T_64 ? compactor_io_out_0_data : 16'h0; // @[MemPrimitives.scala 658:63:@2096.4]
  assign io_out_0_en = _T_36 | _T_45; // @[MemPrimitives.scala 659:63:@2097.4]
  assign compactor_io_in_0_data = io_in_0_data; // @[MemPrimitives.scala 639:19:@2059.4]
endmodule
module bbox_CompactingDeqNetwork_1( // @[:@2099.2]
  input  [5:0]  io_tailCnt, // @[:@2102.4]
  input  [15:0] io_input_data_0, // @[:@2102.4]
  output [15:0] io_output_0 // @[:@2102.4]
);
  wire [5:0] _GEN_0; // @[Math.scala 53:59:@2106.4]
  wire [5:0] current_base_bank; // @[Math.scala 53:59:@2106.4]
  wire [5:0] _T_55; // @[MemPrimitives.scala 685:65:@2129.4]
  wire [6:0] _T_56; // @[MemPrimitives.scala 685:72:@2130.4]
  wire [5:0] _T_57; // @[MemPrimitives.scala 685:72:@2131.4]
  wire [5:0] _GEN_1; // @[Math.scala 55:59:@2132.4]
  wire [5:0] _T_59; // @[Math.scala 55:59:@2132.4]
  wire  _T_62; // @[Mux.scala 46:19:@2133.4]
  assign _GEN_0 = $signed(io_tailCnt) % $signed(6'sh1); // @[Math.scala 53:59:@2106.4]
  assign current_base_bank = _GEN_0[5:0]; // @[Math.scala 53:59:@2106.4]
  assign _T_55 = $unsigned(current_base_bank); // @[MemPrimitives.scala 685:65:@2129.4]
  assign _T_56 = {{1'd0}, _T_55}; // @[MemPrimitives.scala 685:72:@2130.4]
  assign _T_57 = _T_56[5:0]; // @[MemPrimitives.scala 685:72:@2131.4]
  assign _GEN_1 = _T_57 % 6'h1; // @[Math.scala 55:59:@2132.4]
  assign _T_59 = _GEN_1[5:0]; // @[Math.scala 55:59:@2132.4]
  assign _T_62 = 6'h0 == _T_59; // @[Mux.scala 46:19:@2133.4]
  assign io_output_0 = _T_62 ? io_input_data_0 : 16'h0; // @[MemPrimitives.scala 689:18:@2135.4]
endmodule
module bbox_x77_scalar_0( // @[:@2137.2]
  input         clock, // @[:@2138.4]
  input         reset, // @[:@2139.4]
  input         io_rPort_0_en_0, // @[:@2140.4]
  output [15:0] io_rPort_0_output_0, // @[:@2140.4]
  input  [15:0] io_wPort_0_data_0, // @[:@2140.4]
  input         io_wPort_0_en_0, // @[:@2140.4]
  output        io_full, // @[:@2140.4]
  output        io_empty, // @[:@2140.4]
  output        io_accessActivesOut_0, // @[:@2140.4]
  input         io_accessActivesIn_0 // @[:@2140.4]
);
  wire  headCtr_clock; // @[MemPrimitives.scala 233:23:@2164.4]
  wire  headCtr_reset; // @[MemPrimitives.scala 233:23:@2164.4]
  wire  headCtr_io_input_dir; // @[MemPrimitives.scala 233:23:@2164.4]
  wire  headCtr_io_input_reset; // @[MemPrimitives.scala 233:23:@2164.4]
  wire  headCtr_io_input_enables_0; // @[MemPrimitives.scala 233:23:@2164.4]
  wire [5:0] headCtr_io_output_count; // @[MemPrimitives.scala 233:23:@2164.4]
  wire  tailCtr_clock; // @[MemPrimitives.scala 234:23:@2172.4]
  wire  tailCtr_reset; // @[MemPrimitives.scala 234:23:@2172.4]
  wire  tailCtr_io_input_dir; // @[MemPrimitives.scala 234:23:@2172.4]
  wire  tailCtr_io_input_reset; // @[MemPrimitives.scala 234:23:@2172.4]
  wire  tailCtr_io_input_enables_0; // @[MemPrimitives.scala 234:23:@2172.4]
  wire [5:0] tailCtr_io_output_count; // @[MemPrimitives.scala 234:23:@2172.4]
  wire  elements_clock; // @[MemPrimitives.scala 244:24:@2186.4]
  wire  elements_reset; // @[MemPrimitives.scala 244:24:@2186.4]
  wire  elements_io_input_inc_en_0; // @[MemPrimitives.scala 244:24:@2186.4]
  wire  elements_io_input_dinc_en_0; // @[MemPrimitives.scala 244:24:@2186.4]
  wire  elements_io_output_empty; // @[MemPrimitives.scala 244:24:@2186.4]
  wire  elements_io_output_full; // @[MemPrimitives.scala 244:24:@2186.4]
  wire  m_0_clock; // @[MemPrimitives.scala 250:56:@2200.4]
  wire [3:0] m_0_io_r_ofs_0; // @[MemPrimitives.scala 250:56:@2200.4]
  wire [3:0] m_0_io_w_ofs_0; // @[MemPrimitives.scala 250:56:@2200.4]
  wire [15:0] m_0_io_w_data_0; // @[MemPrimitives.scala 250:56:@2200.4]
  wire  m_0_io_w_en_0; // @[MemPrimitives.scala 250:56:@2200.4]
  wire [15:0] m_0_io_output; // @[MemPrimitives.scala 250:56:@2200.4]
  wire [5:0] enqCompactor_io_headCnt; // @[MemPrimitives.scala 254:28:@2216.4]
  wire [15:0] enqCompactor_io_in_0_data; // @[MemPrimitives.scala 254:28:@2216.4]
  wire  enqCompactor_io_in_0_en; // @[MemPrimitives.scala 254:28:@2216.4]
  wire [15:0] enqCompactor_io_out_0_data; // @[MemPrimitives.scala 254:28:@2216.4]
  wire  enqCompactor_io_out_0_en; // @[MemPrimitives.scala 254:28:@2216.4]
  wire [5:0] deqCompactor_io_tailCnt; // @[MemPrimitives.scala 273:28:@2238.4]
  wire [15:0] deqCompactor_io_input_data_0; // @[MemPrimitives.scala 273:28:@2238.4]
  wire [15:0] deqCompactor_io_output_0; // @[MemPrimitives.scala 273:28:@2238.4]
  wire [5:0] _GEN_0; // @[Math.scala 53:59:@2227.4]
  wire [5:0] active_w_bank; // @[Math.scala 53:59:@2227.4]
  wire [6:0] active_w_addr; // @[Math.scala 52:59:@2228.4]
  wire  _T_94; // @[MemPrimitives.scala 266:38:@2229.4]
  wire [7:0] _T_96; // @[MemPrimitives.scala 266:69:@2230.4]
  wire [6:0] _T_97; // @[MemPrimitives.scala 266:69:@2231.4]
  wire [6:0] _T_98; // @[MemPrimitives.scala 266:69:@2232.4]
  wire [6:0] _T_99; // @[MemPrimitives.scala 266:19:@2233.4]
  wire [6:0] _T_100; // @[MemPrimitives.scala 267:32:@2234.4]
  wire [5:0] _GEN_1; // @[Math.scala 53:59:@2246.4]
  wire [5:0] active_r_bank; // @[Math.scala 53:59:@2246.4]
  wire [6:0] active_r_addr; // @[Math.scala 52:59:@2247.4]
  wire  _T_104; // @[MemPrimitives.scala 279:38:@2248.4]
  wire [7:0] _T_106; // @[MemPrimitives.scala 279:69:@2249.4]
  wire [6:0] _T_107; // @[MemPrimitives.scala 279:69:@2250.4]
  wire [6:0] _T_108; // @[MemPrimitives.scala 279:69:@2251.4]
  wire [6:0] _T_109; // @[MemPrimitives.scala 279:19:@2252.4]
  wire [6:0] _T_110; // @[MemPrimitives.scala 280:32:@2253.4]
  bbox_CompactingCounter headCtr ( // @[MemPrimitives.scala 233:23:@2164.4]
    .clock(headCtr_clock),
    .reset(headCtr_reset),
    .io_input_dir(headCtr_io_input_dir),
    .io_input_reset(headCtr_io_input_reset),
    .io_input_enables_0(headCtr_io_input_enables_0),
    .io_output_count(headCtr_io_output_count)
  );
  bbox_CompactingCounter tailCtr ( // @[MemPrimitives.scala 234:23:@2172.4]
    .clock(tailCtr_clock),
    .reset(tailCtr_reset),
    .io_input_dir(tailCtr_io_input_dir),
    .io_input_reset(tailCtr_io_input_reset),
    .io_input_enables_0(tailCtr_io_input_enables_0),
    .io_output_count(tailCtr_io_output_count)
  );
  bbox_CompactingIncDincCtr elements ( // @[MemPrimitives.scala 244:24:@2186.4]
    .clock(elements_clock),
    .reset(elements_reset),
    .io_input_inc_en_0(elements_io_input_inc_en_0),
    .io_input_dinc_en_0(elements_io_input_dinc_en_0),
    .io_output_empty(elements_io_output_empty),
    .io_output_full(elements_io_output_full)
  );
  bbox_Mem1D_1 m_0 ( // @[MemPrimitives.scala 250:56:@2200.4]
    .clock(m_0_clock),
    .io_r_ofs_0(m_0_io_r_ofs_0),
    .io_w_ofs_0(m_0_io_w_ofs_0),
    .io_w_data_0(m_0_io_w_data_0),
    .io_w_en_0(m_0_io_w_en_0),
    .io_output(m_0_io_output)
  );
  bbox_CompactingEnqNetwork_1 enqCompactor ( // @[MemPrimitives.scala 254:28:@2216.4]
    .io_headCnt(enqCompactor_io_headCnt),
    .io_in_0_data(enqCompactor_io_in_0_data),
    .io_in_0_en(enqCompactor_io_in_0_en),
    .io_out_0_data(enqCompactor_io_out_0_data),
    .io_out_0_en(enqCompactor_io_out_0_en)
  );
  bbox_CompactingDeqNetwork_1 deqCompactor ( // @[MemPrimitives.scala 273:28:@2238.4]
    .io_tailCnt(deqCompactor_io_tailCnt),
    .io_input_data_0(deqCompactor_io_input_data_0),
    .io_output_0(deqCompactor_io_output_0)
  );
  assign _GEN_0 = $signed(headCtr_io_output_count) % $signed(6'sh1); // @[Math.scala 53:59:@2227.4]
  assign active_w_bank = _GEN_0[5:0]; // @[Math.scala 53:59:@2227.4]
  assign active_w_addr = $signed(headCtr_io_output_count) / $signed(6'sh1); // @[Math.scala 52:59:@2228.4]
  assign _T_94 = $signed(6'sh0) < $signed(active_w_bank); // @[MemPrimitives.scala 266:38:@2229.4]
  assign _T_96 = $signed(active_w_addr) + $signed(7'sh1); // @[MemPrimitives.scala 266:69:@2230.4]
  assign _T_97 = $signed(active_w_addr) + $signed(7'sh1); // @[MemPrimitives.scala 266:69:@2231.4]
  assign _T_98 = $signed(_T_97); // @[MemPrimitives.scala 266:69:@2232.4]
  assign _T_99 = _T_94 ? $signed(_T_98) : $signed(active_w_addr); // @[MemPrimitives.scala 266:19:@2233.4]
  assign _T_100 = $unsigned(_T_99); // @[MemPrimitives.scala 267:32:@2234.4]
  assign _GEN_1 = $signed(tailCtr_io_output_count) % $signed(6'sh1); // @[Math.scala 53:59:@2246.4]
  assign active_r_bank = _GEN_1[5:0]; // @[Math.scala 53:59:@2246.4]
  assign active_r_addr = $signed(tailCtr_io_output_count) / $signed(6'sh1); // @[Math.scala 52:59:@2247.4]
  assign _T_104 = $signed(6'sh0) < $signed(active_r_bank); // @[MemPrimitives.scala 279:38:@2248.4]
  assign _T_106 = $signed(active_r_addr) + $signed(7'sh1); // @[MemPrimitives.scala 279:69:@2249.4]
  assign _T_107 = $signed(active_r_addr) + $signed(7'sh1); // @[MemPrimitives.scala 279:69:@2250.4]
  assign _T_108 = $signed(_T_107); // @[MemPrimitives.scala 279:69:@2251.4]
  assign _T_109 = _T_104 ? $signed(_T_108) : $signed(active_r_addr); // @[MemPrimitives.scala 279:19:@2252.4]
  assign _T_110 = $unsigned(_T_109); // @[MemPrimitives.scala 280:32:@2253.4]
  assign io_rPort_0_output_0 = deqCompactor_io_output_0; // @[MemPrimitives.scala 284:82:@2257.4]
  assign io_full = elements_io_output_full; // @[MemPrimitives.scala 291:39:@2261.4]
  assign io_empty = elements_io_output_empty; // @[MemPrimitives.scala 290:40:@2260.4]
  assign io_accessActivesOut_0 = io_accessActivesIn_0; // @[MemPrimitives.scala 289:127:@2258.4]
  assign headCtr_clock = clock; // @[:@2165.4]
  assign headCtr_reset = reset; // @[:@2166.4]
  assign headCtr_io_input_dir = 1'h1; // @[MemPrimitives.scala 239:24:@2184.4]
  assign headCtr_io_input_reset = reset; // @[MemPrimitives.scala 237:26:@2182.4]
  assign headCtr_io_input_enables_0 = io_wPort_0_en_0; // @[MemPrimitives.scala 235:129:@2180.4]
  assign tailCtr_clock = clock; // @[:@2173.4]
  assign tailCtr_reset = reset; // @[:@2174.4]
  assign tailCtr_io_input_dir = 1'h1; // @[MemPrimitives.scala 240:24:@2185.4]
  assign tailCtr_io_input_reset = reset; // @[MemPrimitives.scala 238:26:@2183.4]
  assign tailCtr_io_input_enables_0 = io_rPort_0_en_0; // @[MemPrimitives.scala 236:129:@2181.4]
  assign elements_clock = clock; // @[:@2187.4]
  assign elements_reset = reset; // @[:@2188.4]
  assign elements_io_input_inc_en_0 = io_wPort_0_en_0; // @[MemPrimitives.scala 246:79:@2198.4]
  assign elements_io_input_dinc_en_0 = io_rPort_0_en_0; // @[MemPrimitives.scala 247:80:@2199.4]
  assign m_0_clock = clock; // @[:@2201.4]
  assign m_0_io_r_ofs_0 = _T_110[3:0]; // @[MemPrimitives.scala 280:24:@2254.4]
  assign m_0_io_w_ofs_0 = _T_100[3:0]; // @[MemPrimitives.scala 267:24:@2235.4]
  assign m_0_io_w_data_0 = enqCompactor_io_out_0_data; // @[MemPrimitives.scala 268:25:@2236.4]
  assign m_0_io_w_en_0 = enqCompactor_io_out_0_en; // @[MemPrimitives.scala 269:25:@2237.4]
  assign enqCompactor_io_headCnt = headCtr_io_output_count; // @[MemPrimitives.scala 256:27:@2224.4]
  assign enqCompactor_io_in_0_data = io_wPort_0_data_0; // @[MemPrimitives.scala 258:90:@2225.4]
  assign enqCompactor_io_in_0_en = io_wPort_0_en_0; // @[MemPrimitives.scala 259:85:@2226.4]
  assign deqCompactor_io_tailCnt = tailCtr_io_output_count; // @[MemPrimitives.scala 275:27:@2245.4]
  assign deqCompactor_io_input_data_0 = m_0_io_output; // @[MemPrimitives.scala 281:35:@2255.4]
endmodule
module bbox_x83_inr_UnitPipe_sm( // @[:@3705.2]
  input   clock, // @[:@3706.4]
  input   reset, // @[:@3707.4]
  input   io_enable, // @[:@3708.4]
  output  io_done, // @[:@3708.4]
  output  io_doneLatch, // @[:@3708.4]
  input   io_ctrDone, // @[:@3708.4]
  output  io_datapathEn, // @[:@3708.4]
  output  io_ctrInc, // @[:@3708.4]
  input   io_parentAck, // @[:@3708.4]
  input   io_backpressure, // @[:@3708.4]
  input   io_break // @[:@3708.4]
);
  wire  active_clock; // @[Controllers.scala 261:22:@3710.4]
  wire  active_reset; // @[Controllers.scala 261:22:@3710.4]
  wire  active_io_input_set; // @[Controllers.scala 261:22:@3710.4]
  wire  active_io_input_reset; // @[Controllers.scala 261:22:@3710.4]
  wire  active_io_input_asyn_reset; // @[Controllers.scala 261:22:@3710.4]
  wire  active_io_output; // @[Controllers.scala 261:22:@3710.4]
  wire  done_clock; // @[Controllers.scala 262:20:@3713.4]
  wire  done_reset; // @[Controllers.scala 262:20:@3713.4]
  wire  done_io_input_set; // @[Controllers.scala 262:20:@3713.4]
  wire  done_io_input_reset; // @[Controllers.scala 262:20:@3713.4]
  wire  done_io_input_asyn_reset; // @[Controllers.scala 262:20:@3713.4]
  wire  done_io_output; // @[Controllers.scala 262:20:@3713.4]
  wire  RetimeWrapper_clock; // @[package.scala 93:22:@3747.4]
  wire  RetimeWrapper_reset; // @[package.scala 93:22:@3747.4]
  wire  RetimeWrapper_io_flow; // @[package.scala 93:22:@3747.4]
  wire  RetimeWrapper_io_in; // @[package.scala 93:22:@3747.4]
  wire  RetimeWrapper_io_out; // @[package.scala 93:22:@3747.4]
  wire  RetimeWrapper_1_clock; // @[package.scala 93:22:@3769.4]
  wire  RetimeWrapper_1_reset; // @[package.scala 93:22:@3769.4]
  wire  RetimeWrapper_1_io_flow; // @[package.scala 93:22:@3769.4]
  wire  RetimeWrapper_1_io_in; // @[package.scala 93:22:@3769.4]
  wire  RetimeWrapper_1_io_out; // @[package.scala 93:22:@3769.4]
  wire  RetimeWrapper_2_clock; // @[package.scala 93:22:@3781.4]
  wire  RetimeWrapper_2_reset; // @[package.scala 93:22:@3781.4]
  wire  RetimeWrapper_2_io_flow; // @[package.scala 93:22:@3781.4]
  wire  RetimeWrapper_2_io_in; // @[package.scala 93:22:@3781.4]
  wire  RetimeWrapper_2_io_out; // @[package.scala 93:22:@3781.4]
  wire  RetimeWrapper_3_clock; // @[package.scala 93:22:@3789.4]
  wire  RetimeWrapper_3_reset; // @[package.scala 93:22:@3789.4]
  wire  RetimeWrapper_3_io_flow; // @[package.scala 93:22:@3789.4]
  wire  RetimeWrapper_3_io_in; // @[package.scala 93:22:@3789.4]
  wire  RetimeWrapper_3_io_out; // @[package.scala 93:22:@3789.4]
  wire  _T_80; // @[Controllers.scala 264:48:@3718.4]
  wire  _T_81; // @[Controllers.scala 264:46:@3719.4]
  wire  _T_82; // @[Controllers.scala 264:62:@3720.4]
  wire  _T_83; // @[Controllers.scala 264:60:@3721.4]
  wire  _T_100; // @[package.scala 100:49:@3738.4]
  reg  _T_103; // @[package.scala 48:56:@3739.4]
  reg [31:0] _RAND_0;
  wire  _T_118; // @[Controllers.scala 283:41:@3762.4]
  wire  _T_119; // @[Controllers.scala 283:59:@3763.4]
  wire  _T_121; // @[Controllers.scala 284:37:@3766.4]
  wire  _T_124; // @[package.scala 96:25:@3774.4 package.scala 96:25:@3775.4]
  wire  _T_126; // @[package.scala 100:49:@3776.4]
  reg  _T_129; // @[package.scala 48:56:@3777.4]
  reg [31:0] _RAND_1;
  reg  _T_146; // @[Controllers.scala 291:31:@3799.4]
  reg [31:0] _RAND_2;
  wire  _T_150; // @[package.scala 100:49:@3801.4]
  reg  _T_153; // @[package.scala 48:56:@3802.4]
  reg [31:0] _RAND_3;
  wire  _T_154; // @[package.scala 100:41:@3804.4]
  wire  _T_156; // @[Controllers.scala 292:61:@3805.4]
  wire  _T_157; // @[Controllers.scala 292:24:@3806.4]
  bbox_SRFF active ( // @[Controllers.scala 261:22:@3710.4]
    .clock(active_clock),
    .reset(active_reset),
    .io_input_set(active_io_input_set),
    .io_input_reset(active_io_input_reset),
    .io_input_asyn_reset(active_io_input_asyn_reset),
    .io_output(active_io_output)
  );
  bbox_SRFF done ( // @[Controllers.scala 262:20:@3713.4]
    .clock(done_clock),
    .reset(done_reset),
    .io_input_set(done_io_input_set),
    .io_input_reset(done_io_input_reset),
    .io_input_asyn_reset(done_io_input_asyn_reset),
    .io_output(done_io_output)
  );
  bbox_RetimeWrapper RetimeWrapper ( // @[package.scala 93:22:@3747.4]
    .clock(RetimeWrapper_clock),
    .reset(RetimeWrapper_reset),
    .io_flow(RetimeWrapper_io_flow),
    .io_in(RetimeWrapper_io_in),
    .io_out(RetimeWrapper_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_1 ( // @[package.scala 93:22:@3769.4]
    .clock(RetimeWrapper_1_clock),
    .reset(RetimeWrapper_1_reset),
    .io_flow(RetimeWrapper_1_io_flow),
    .io_in(RetimeWrapper_1_io_in),
    .io_out(RetimeWrapper_1_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_2 ( // @[package.scala 93:22:@3781.4]
    .clock(RetimeWrapper_2_clock),
    .reset(RetimeWrapper_2_reset),
    .io_flow(RetimeWrapper_2_io_flow),
    .io_in(RetimeWrapper_2_io_in),
    .io_out(RetimeWrapper_2_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_3 ( // @[package.scala 93:22:@3789.4]
    .clock(RetimeWrapper_3_clock),
    .reset(RetimeWrapper_3_reset),
    .io_flow(RetimeWrapper_3_io_flow),
    .io_in(RetimeWrapper_3_io_in),
    .io_out(RetimeWrapper_3_io_out)
  );
  assign _T_80 = ~ io_ctrDone; // @[Controllers.scala 264:48:@3718.4]
  assign _T_81 = io_enable & _T_80; // @[Controllers.scala 264:46:@3719.4]
  assign _T_82 = ~ done_io_output; // @[Controllers.scala 264:62:@3720.4]
  assign _T_83 = _T_81 & _T_82; // @[Controllers.scala 264:60:@3721.4]
  assign _T_100 = io_ctrDone == 1'h0; // @[package.scala 100:49:@3738.4]
  assign _T_118 = active_io_output & _T_82; // @[Controllers.scala 283:41:@3762.4]
  assign _T_119 = _T_118 & io_enable; // @[Controllers.scala 283:59:@3763.4]
  assign _T_121 = active_io_output & io_enable; // @[Controllers.scala 284:37:@3766.4]
  assign _T_124 = RetimeWrapper_1_io_out; // @[package.scala 96:25:@3774.4 package.scala 96:25:@3775.4]
  assign _T_126 = _T_124 == 1'h0; // @[package.scala 100:49:@3776.4]
  assign _T_150 = done_io_output == 1'h0; // @[package.scala 100:49:@3801.4]
  assign _T_154 = done_io_output & _T_153; // @[package.scala 100:41:@3804.4]
  assign _T_156 = _T_154 ? 1'h1 : _T_146; // @[Controllers.scala 292:61:@3805.4]
  assign _T_157 = io_parentAck ? 1'h0 : _T_156; // @[Controllers.scala 292:24:@3806.4]
  assign io_done = _T_124 & _T_129; // @[Controllers.scala 287:13:@3780.4]
  assign io_doneLatch = _T_146; // @[Controllers.scala 293:18:@3808.4]
  assign io_datapathEn = _T_119 & io_backpressure; // @[Controllers.scala 283:21:@3765.4]
  assign io_ctrInc = _T_121 & io_backpressure; // @[Controllers.scala 284:17:@3768.4]
  assign active_clock = clock; // @[:@3711.4]
  assign active_reset = reset; // @[:@3712.4]
  assign active_io_input_set = _T_83 & io_backpressure; // @[Controllers.scala 264:23:@3723.4]
  assign active_io_input_reset = io_ctrDone | io_parentAck; // @[Controllers.scala 265:25:@3727.4]
  assign active_io_input_asyn_reset = 1'h0; // @[Controllers.scala 266:30:@3728.4]
  assign done_clock = clock; // @[:@3714.4]
  assign done_reset = reset; // @[:@3715.4]
  assign done_io_input_set = io_ctrDone & _T_103; // @[Controllers.scala 269:104:@3743.4]
  assign done_io_input_reset = io_parentAck; // @[Controllers.scala 267:23:@3736.4]
  assign done_io_input_asyn_reset = 1'h0; // @[Controllers.scala 268:28:@3737.4]
  assign RetimeWrapper_clock = clock; // @[:@3748.4]
  assign RetimeWrapper_reset = reset; // @[:@3749.4]
  assign RetimeWrapper_io_flow = io_backpressure; // @[package.scala 95:18:@3751.4]
  assign RetimeWrapper_io_in = done_io_output; // @[package.scala 94:16:@3750.4]
  assign RetimeWrapper_1_clock = clock; // @[:@3770.4]
  assign RetimeWrapper_1_reset = reset; // @[:@3771.4]
  assign RetimeWrapper_1_io_flow = io_backpressure; // @[package.scala 95:18:@3773.4]
  assign RetimeWrapper_1_io_in = done_io_output; // @[package.scala 94:16:@3772.4]
  assign RetimeWrapper_2_clock = clock; // @[:@3782.4]
  assign RetimeWrapper_2_reset = reset; // @[:@3783.4]
  assign RetimeWrapper_2_io_flow = 1'h1; // @[package.scala 95:18:@3785.4]
  assign RetimeWrapper_2_io_in = 1'h0; // @[package.scala 94:16:@3784.4]
  assign RetimeWrapper_3_clock = clock; // @[:@3790.4]
  assign RetimeWrapper_3_reset = reset; // @[:@3791.4]
  assign RetimeWrapper_3_io_flow = 1'h1; // @[package.scala 95:18:@3793.4]
  assign RetimeWrapper_3_io_in = io_ctrDone; // @[package.scala 94:16:@3792.4]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  _T_103 = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  _T_129 = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  _T_146 = _RAND_2[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  _T_153 = _RAND_3[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      _T_103 <= 1'h0;
    end else begin
      _T_103 <= _T_100;
    end
    if (reset) begin
      _T_129 <= 1'h0;
    end else begin
      _T_129 <= _T_126;
    end
    if (reset) begin
      _T_146 <= 1'h0;
    end else begin
      if (io_parentAck) begin
        _T_146 <= 1'h0;
      end else begin
        if (_T_154) begin
          _T_146 <= 1'h1;
        end
      end
    end
    if (reset) begin
      _T_153 <= 1'h0;
    end else begin
      _T_153 <= _T_150;
    end
  end
endmodule
module bbox_x83_inr_UnitPipe_kernelx83_inr_UnitPipe_concrete1( // @[:@3882.2]
  output  io_in_x76_numel_0_wPort_0_en_0, // @[:@3885.4]
  output  io_in_x77_scalar_0_wPort_0_en_0, // @[:@3885.4]
  input   io_sigsIn_backpressure, // @[:@3885.4]
  input   io_sigsIn_datapathEn, // @[:@3885.4]
  input   io_sigsIn_break, // @[:@3885.4]
  input   io_rr // @[:@3885.4]
);
  wire  _T_461; // @[sm_x83_inr_UnitPipe.scala 64:114:@3941.4]
  wire  _T_465; // @[implicits.scala 55:10:@3944.4]
  wire  _T_466; // @[sm_x83_inr_UnitPipe.scala 64:131:@3945.4]
  wire  _T_468; // @[sm_x83_inr_UnitPipe.scala 64:218:@3947.4]
  assign _T_461 = ~ io_sigsIn_break; // @[sm_x83_inr_UnitPipe.scala 64:114:@3941.4]
  assign _T_465 = io_rr ? io_sigsIn_datapathEn : 1'h0; // @[implicits.scala 55:10:@3944.4]
  assign _T_466 = _T_461 & _T_465; // @[sm_x83_inr_UnitPipe.scala 64:131:@3945.4]
  assign _T_468 = _T_466 & _T_461; // @[sm_x83_inr_UnitPipe.scala 64:218:@3947.4]
  assign io_in_x76_numel_0_wPort_0_en_0 = _T_468 & io_sigsIn_backpressure; // @[MemInterfaceType.scala 93:57:@3952.4]
  assign io_in_x77_scalar_0_wPort_0_en_0 = _T_468 & io_sigsIn_backpressure; // @[MemInterfaceType.scala 93:57:@3967.4]
endmodule
module bbox_SingleCounter_1( // @[:@4353.2]
  input         clock, // @[:@4354.4]
  input         reset, // @[:@4355.4]
  input         io_input_reset, // @[:@4356.4]
  input         io_input_enable, // @[:@4356.4]
  output [31:0] io_output_count_0, // @[:@4356.4]
  output        io_output_oobs_0, // @[:@4356.4]
  output        io_output_done // @[:@4356.4]
);
  wire  bases_0_clock; // @[Counter.scala 253:53:@4369.4]
  wire  bases_0_reset; // @[Counter.scala 253:53:@4369.4]
  wire [31:0] bases_0_io_rPort_0_output_0; // @[Counter.scala 253:53:@4369.4]
  wire [31:0] bases_0_io_wPort_0_data_0; // @[Counter.scala 253:53:@4369.4]
  wire  bases_0_io_wPort_0_reset; // @[Counter.scala 253:53:@4369.4]
  wire  bases_0_io_wPort_0_en_0; // @[Counter.scala 253:53:@4369.4]
  wire  SRFF_clock; // @[Counter.scala 255:22:@4385.4]
  wire  SRFF_reset; // @[Counter.scala 255:22:@4385.4]
  wire  SRFF_io_input_set; // @[Counter.scala 255:22:@4385.4]
  wire  SRFF_io_input_reset; // @[Counter.scala 255:22:@4385.4]
  wire  SRFF_io_input_asyn_reset; // @[Counter.scala 255:22:@4385.4]
  wire  SRFF_io_output; // @[Counter.scala 255:22:@4385.4]
  wire  _T_36; // @[Counter.scala 256:45:@4388.4]
  wire [31:0] _T_48; // @[Counter.scala 279:52:@4413.4]
  wire [32:0] _T_50; // @[Counter.scala 283:33:@4414.4]
  wire [31:0] _T_51; // @[Counter.scala 283:33:@4415.4]
  wire [31:0] _T_52; // @[Counter.scala 283:33:@4416.4]
  wire  _T_57; // @[Counter.scala 285:18:@4418.4]
  wire [31:0] _T_68; // @[Counter.scala 291:115:@4426.4]
  wire [31:0] _T_71; // @[Counter.scala 291:152:@4429.4]
  wire [31:0] _T_72; // @[Counter.scala 291:74:@4430.4]
  wire  _T_75; // @[Counter.scala 314:102:@4434.4]
  wire  _T_77; // @[Counter.scala 314:130:@4435.4]
  bbox_FF bases_0 ( // @[Counter.scala 253:53:@4369.4]
    .clock(bases_0_clock),
    .reset(bases_0_reset),
    .io_rPort_0_output_0(bases_0_io_rPort_0_output_0),
    .io_wPort_0_data_0(bases_0_io_wPort_0_data_0),
    .io_wPort_0_reset(bases_0_io_wPort_0_reset),
    .io_wPort_0_en_0(bases_0_io_wPort_0_en_0)
  );
  bbox_SRFF SRFF ( // @[Counter.scala 255:22:@4385.4]
    .clock(SRFF_clock),
    .reset(SRFF_reset),
    .io_input_set(SRFF_io_input_set),
    .io_input_reset(SRFF_io_input_reset),
    .io_input_asyn_reset(SRFF_io_input_asyn_reset),
    .io_output(SRFF_io_output)
  );
  assign _T_36 = io_input_reset == 1'h0; // @[Counter.scala 256:45:@4388.4]
  assign _T_48 = $signed(bases_0_io_rPort_0_output_0); // @[Counter.scala 279:52:@4413.4]
  assign _T_50 = $signed(_T_48) + $signed(32'sh1); // @[Counter.scala 283:33:@4414.4]
  assign _T_51 = $signed(_T_48) + $signed(32'sh1); // @[Counter.scala 283:33:@4415.4]
  assign _T_52 = $signed(_T_51); // @[Counter.scala 283:33:@4416.4]
  assign _T_57 = $signed(_T_52) >= $signed(32'sh4); // @[Counter.scala 285:18:@4418.4]
  assign _T_68 = $unsigned(_T_48); // @[Counter.scala 291:115:@4426.4]
  assign _T_71 = $unsigned(_T_52); // @[Counter.scala 291:152:@4429.4]
  assign _T_72 = _T_57 ? _T_68 : _T_71; // @[Counter.scala 291:74:@4430.4]
  assign _T_75 = $signed(_T_48) < $signed(32'sh0); // @[Counter.scala 314:102:@4434.4]
  assign _T_77 = $signed(_T_48) >= $signed(32'sh4); // @[Counter.scala 314:130:@4435.4]
  assign io_output_count_0 = $signed(bases_0_io_rPort_0_output_0); // @[Counter.scala 296:28:@4433.4]
  assign io_output_oobs_0 = _T_75 | _T_77; // @[Counter.scala 314:60:@4437.4]
  assign io_output_done = io_input_enable & _T_57; // @[Counter.scala 325:20:@4439.4]
  assign bases_0_clock = clock; // @[:@4370.4]
  assign bases_0_reset = reset; // @[:@4371.4]
  assign bases_0_io_wPort_0_data_0 = io_input_reset ? 32'h0 : _T_72; // @[Counter.scala 291:31:@4432.4]
  assign bases_0_io_wPort_0_reset = io_input_reset; // @[Counter.scala 273:27:@4411.4]
  assign bases_0_io_wPort_0_en_0 = io_input_enable; // @[Counter.scala 276:29:@4412.4]
  assign SRFF_clock = clock; // @[:@4386.4]
  assign SRFF_reset = reset; // @[:@4387.4]
  assign SRFF_io_input_set = io_input_enable & _T_36; // @[Counter.scala 256:23:@4390.4]
  assign SRFF_io_input_reset = io_input_reset | io_output_done; // @[Counter.scala 257:25:@4392.4]
  assign SRFF_io_input_asyn_reset = 1'h0; // @[Counter.scala 258:30:@4393.4]
endmodule
module bbox_x85_ctrchain( // @[:@4444.2]
  input         clock, // @[:@4445.4]
  input         reset, // @[:@4446.4]
  input         io_input_reset, // @[:@4447.4]
  input         io_input_enable, // @[:@4447.4]
  output [31:0] io_output_counts_0, // @[:@4447.4]
  output        io_output_oobs_0, // @[:@4447.4]
  output        io_output_done // @[:@4447.4]
);
  wire  ctrs_0_clock; // @[Counter.scala 505:46:@4449.4]
  wire  ctrs_0_reset; // @[Counter.scala 505:46:@4449.4]
  wire  ctrs_0_io_input_reset; // @[Counter.scala 505:46:@4449.4]
  wire  ctrs_0_io_input_enable; // @[Counter.scala 505:46:@4449.4]
  wire [31:0] ctrs_0_io_output_count_0; // @[Counter.scala 505:46:@4449.4]
  wire  ctrs_0_io_output_oobs_0; // @[Counter.scala 505:46:@4449.4]
  wire  ctrs_0_io_output_done; // @[Counter.scala 505:46:@4449.4]
  reg  wasDone; // @[Counter.scala 534:24:@4458.4]
  reg [31:0] _RAND_0;
  wire  _T_45; // @[Counter.scala 538:69:@4464.4]
  wire  _T_47; // @[Counter.scala 538:80:@4465.4]
  reg  doneLatch; // @[Counter.scala 542:26:@4470.4]
  reg [31:0] _RAND_1;
  wire  _T_54; // @[Counter.scala 543:48:@4471.4]
  wire  _T_55; // @[Counter.scala 543:19:@4472.4]
  bbox_SingleCounter_1 ctrs_0 ( // @[Counter.scala 505:46:@4449.4]
    .clock(ctrs_0_clock),
    .reset(ctrs_0_reset),
    .io_input_reset(ctrs_0_io_input_reset),
    .io_input_enable(ctrs_0_io_input_enable),
    .io_output_count_0(ctrs_0_io_output_count_0),
    .io_output_oobs_0(ctrs_0_io_output_oobs_0),
    .io_output_done(ctrs_0_io_output_done)
  );
  assign _T_45 = io_input_enable & ctrs_0_io_output_done; // @[Counter.scala 538:69:@4464.4]
  assign _T_47 = wasDone == 1'h0; // @[Counter.scala 538:80:@4465.4]
  assign _T_54 = ctrs_0_io_output_done ? 1'h1 : doneLatch; // @[Counter.scala 543:48:@4471.4]
  assign _T_55 = io_input_reset ? 1'h0 : _T_54; // @[Counter.scala 543:19:@4472.4]
  assign io_output_counts_0 = ctrs_0_io_output_count_0; // @[Counter.scala 549:32:@4474.4]
  assign io_output_oobs_0 = ctrs_0_io_output_oobs_0 | doneLatch; // @[Counter.scala 550:30:@4476.4]
  assign io_output_done = _T_45 & _T_47; // @[Counter.scala 538:18:@4467.4]
  assign ctrs_0_clock = clock; // @[:@4450.4]
  assign ctrs_0_reset = reset; // @[:@4451.4]
  assign ctrs_0_io_input_reset = io_input_reset; // @[Counter.scala 512:24:@4455.4]
  assign ctrs_0_io_input_enable = io_input_enable; // @[Counter.scala 516:33:@4456.4]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  wasDone = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  doneLatch = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      wasDone <= 1'h0;
    end else begin
      wasDone <= ctrs_0_io_output_done;
    end
    if (reset) begin
      doneLatch <= 1'h0;
    end else begin
      if (io_input_reset) begin
        doneLatch <= 1'h0;
      end else begin
        if (ctrs_0_io_output_done) begin
          doneLatch <= 1'h1;
        end
      end
    end
  end
endmodule
module bbox_x119_outr_Foreach_sm( // @[:@4748.2]
  input   clock, // @[:@4749.4]
  input   reset, // @[:@4750.4]
  input   io_enable, // @[:@4751.4]
  output  io_done, // @[:@4751.4]
  input   io_ctrDone, // @[:@4751.4]
  output  io_ctrInc, // @[:@4751.4]
  output  io_ctrRst, // @[:@4751.4]
  input   io_parentAck, // @[:@4751.4]
  input   io_doneIn_0, // @[:@4751.4]
  input   io_doneIn_1, // @[:@4751.4]
  input   io_maskIn_0, // @[:@4751.4]
  input   io_maskIn_1, // @[:@4751.4]
  output  io_enableOut_0, // @[:@4751.4]
  output  io_enableOut_1, // @[:@4751.4]
  output  io_childAck_0, // @[:@4751.4]
  output  io_childAck_1 // @[:@4751.4]
);
  wire  active_0_clock; // @[Controllers.scala 76:50:@4754.4]
  wire  active_0_reset; // @[Controllers.scala 76:50:@4754.4]
  wire  active_0_io_input_set; // @[Controllers.scala 76:50:@4754.4]
  wire  active_0_io_input_reset; // @[Controllers.scala 76:50:@4754.4]
  wire  active_0_io_input_asyn_reset; // @[Controllers.scala 76:50:@4754.4]
  wire  active_0_io_output; // @[Controllers.scala 76:50:@4754.4]
  wire  active_1_clock; // @[Controllers.scala 76:50:@4757.4]
  wire  active_1_reset; // @[Controllers.scala 76:50:@4757.4]
  wire  active_1_io_input_set; // @[Controllers.scala 76:50:@4757.4]
  wire  active_1_io_input_reset; // @[Controllers.scala 76:50:@4757.4]
  wire  active_1_io_input_asyn_reset; // @[Controllers.scala 76:50:@4757.4]
  wire  active_1_io_output; // @[Controllers.scala 76:50:@4757.4]
  wire  done_0_clock; // @[Controllers.scala 77:48:@4760.4]
  wire  done_0_reset; // @[Controllers.scala 77:48:@4760.4]
  wire  done_0_io_input_set; // @[Controllers.scala 77:48:@4760.4]
  wire  done_0_io_input_reset; // @[Controllers.scala 77:48:@4760.4]
  wire  done_0_io_input_asyn_reset; // @[Controllers.scala 77:48:@4760.4]
  wire  done_0_io_output; // @[Controllers.scala 77:48:@4760.4]
  wire  done_1_clock; // @[Controllers.scala 77:48:@4763.4]
  wire  done_1_reset; // @[Controllers.scala 77:48:@4763.4]
  wire  done_1_io_input_set; // @[Controllers.scala 77:48:@4763.4]
  wire  done_1_io_input_reset; // @[Controllers.scala 77:48:@4763.4]
  wire  done_1_io_input_asyn_reset; // @[Controllers.scala 77:48:@4763.4]
  wire  done_1_io_output; // @[Controllers.scala 77:48:@4763.4]
  wire  iterDone_0_clock; // @[Controllers.scala 90:52:@4792.4]
  wire  iterDone_0_reset; // @[Controllers.scala 90:52:@4792.4]
  wire  iterDone_0_io_input_set; // @[Controllers.scala 90:52:@4792.4]
  wire  iterDone_0_io_input_reset; // @[Controllers.scala 90:52:@4792.4]
  wire  iterDone_0_io_input_asyn_reset; // @[Controllers.scala 90:52:@4792.4]
  wire  iterDone_0_io_output; // @[Controllers.scala 90:52:@4792.4]
  wire  iterDone_1_clock; // @[Controllers.scala 90:52:@4795.4]
  wire  iterDone_1_reset; // @[Controllers.scala 90:52:@4795.4]
  wire  iterDone_1_io_input_set; // @[Controllers.scala 90:52:@4795.4]
  wire  iterDone_1_io_input_reset; // @[Controllers.scala 90:52:@4795.4]
  wire  iterDone_1_io_input_asyn_reset; // @[Controllers.scala 90:52:@4795.4]
  wire  iterDone_1_io_output; // @[Controllers.scala 90:52:@4795.4]
  wire  RetimeWrapper_clock; // @[package.scala 93:22:@4823.4]
  wire  RetimeWrapper_reset; // @[package.scala 93:22:@4823.4]
  wire  RetimeWrapper_io_flow; // @[package.scala 93:22:@4823.4]
  wire  RetimeWrapper_io_in; // @[package.scala 93:22:@4823.4]
  wire  RetimeWrapper_io_out; // @[package.scala 93:22:@4823.4]
  wire  RetimeWrapper_1_clock; // @[package.scala 93:22:@4836.4]
  wire  RetimeWrapper_1_reset; // @[package.scala 93:22:@4836.4]
  wire  RetimeWrapper_1_io_flow; // @[package.scala 93:22:@4836.4]
  wire  RetimeWrapper_1_io_in; // @[package.scala 93:22:@4836.4]
  wire  RetimeWrapper_1_io_out; // @[package.scala 93:22:@4836.4]
  wire  RetimeWrapper_2_clock; // @[package.scala 93:22:@4862.4]
  wire  RetimeWrapper_2_reset; // @[package.scala 93:22:@4862.4]
  wire  RetimeWrapper_2_io_flow; // @[package.scala 93:22:@4862.4]
  wire  RetimeWrapper_2_io_in; // @[package.scala 93:22:@4862.4]
  wire  RetimeWrapper_2_io_out; // @[package.scala 93:22:@4862.4]
  wire  RetimeWrapper_3_clock; // @[package.scala 93:22:@4882.4]
  wire  RetimeWrapper_3_reset; // @[package.scala 93:22:@4882.4]
  wire  RetimeWrapper_3_io_flow; // @[package.scala 93:22:@4882.4]
  wire  RetimeWrapper_3_io_in; // @[package.scala 93:22:@4882.4]
  wire  RetimeWrapper_3_io_out; // @[package.scala 93:22:@4882.4]
  wire  RetimeWrapper_4_clock; // @[package.scala 93:22:@4931.4]
  wire  RetimeWrapper_4_reset; // @[package.scala 93:22:@4931.4]
  wire  RetimeWrapper_4_io_flow; // @[package.scala 93:22:@4931.4]
  wire  RetimeWrapper_4_io_in; // @[package.scala 93:22:@4931.4]
  wire  RetimeWrapper_4_io_out; // @[package.scala 93:22:@4931.4]
  wire  RetimeWrapper_5_clock; // @[package.scala 93:22:@4948.4]
  wire  RetimeWrapper_5_reset; // @[package.scala 93:22:@4948.4]
  wire  RetimeWrapper_5_io_flow; // @[package.scala 93:22:@4948.4]
  wire  RetimeWrapper_5_io_in; // @[package.scala 93:22:@4948.4]
  wire  RetimeWrapper_5_io_out; // @[package.scala 93:22:@4948.4]
  wire  allDone; // @[Controllers.scala 80:47:@4766.4]
  wire  _T_128; // @[Controllers.scala 102:95:@4822.4]
  wire  _T_127; // @[Controllers.scala 101:55:@4821.4]
  wire  _T_132; // @[package.scala 96:25:@4828.4 package.scala 96:25:@4829.4]
  wire  _T_135; // @[Controllers.scala 102:142:@4831.4]
  wire  _T_136; // @[Controllers.scala 102:138:@4832.4]
  wire  _T_137; // @[Controllers.scala 102:123:@4833.4]
  wire  _T_138; // @[Controllers.scala 102:112:@4834.4]
  wire  _T_139; // @[Controllers.scala 102:95:@4835.4]
  wire  _T_143; // @[package.scala 96:25:@4841.4 package.scala 96:25:@4842.4]
  wire  _T_146; // @[Controllers.scala 102:142:@4844.4]
  wire  _T_147; // @[Controllers.scala 102:138:@4845.4]
  wire  _T_148; // @[Controllers.scala 102:123:@4846.4]
  wire  _T_149; // @[Controllers.scala 102:112:@4847.4]
  wire  synchronize; // @[Controllers.scala 102:164:@4848.4]
  wire  _T_152; // @[Controllers.scala 105:33:@4850.4]
  wire  _T_154; // @[Controllers.scala 105:54:@4851.4]
  wire  _T_155; // @[Controllers.scala 105:52:@4852.4]
  wire  _T_161; // @[Controllers.scala 107:51:@4859.4]
  wire  _T_164; // @[Controllers.scala 107:64:@4861.4]
  wire  _T_168; // @[package.scala 96:25:@4867.4 package.scala 96:25:@4868.4]
  wire  _T_172; // @[Controllers.scala 107:89:@4870.4]
  wire  _T_173; // @[Controllers.scala 107:86:@4871.4]
  wire  _T_174; // @[Controllers.scala 107:108:@4872.4]
  wire  _T_189; // @[Controllers.scala 114:49:@4890.4]
  wire  _T_192; // @[Controllers.scala 115:57:@4894.4]
  wire  _T_203; // @[Controllers.scala 213:68:@4909.4]
  wire  _T_204; // @[Controllers.scala 213:92:@4910.4]
  wire  _T_205; // @[Controllers.scala 213:90:@4911.4]
  wire  _T_206; // @[Controllers.scala 213:115:@4912.4]
  wire  _T_207; // @[Controllers.scala 213:132:@4913.4]
  wire  _T_208; // @[Controllers.scala 213:130:@4914.4]
  wire  _T_209; // @[Controllers.scala 213:156:@4915.4]
  wire  _T_211; // @[Controllers.scala 213:68:@4918.4]
  wire  _T_212; // @[Controllers.scala 213:92:@4919.4]
  wire  _T_213; // @[Controllers.scala 213:90:@4920.4]
  wire  _T_214; // @[Controllers.scala 213:115:@4921.4]
  wire  _T_220; // @[package.scala 100:49:@4926.4]
  reg  _T_223; // @[package.scala 48:56:@4927.4]
  reg [31:0] _RAND_0;
  wire  _T_224; // @[package.scala 100:41:@4929.4]
  reg  _T_237; // @[package.scala 48:56:@4945.4]
  reg [31:0] _RAND_1;
  bbox_SRFF active_0 ( // @[Controllers.scala 76:50:@4754.4]
    .clock(active_0_clock),
    .reset(active_0_reset),
    .io_input_set(active_0_io_input_set),
    .io_input_reset(active_0_io_input_reset),
    .io_input_asyn_reset(active_0_io_input_asyn_reset),
    .io_output(active_0_io_output)
  );
  bbox_SRFF active_1 ( // @[Controllers.scala 76:50:@4757.4]
    .clock(active_1_clock),
    .reset(active_1_reset),
    .io_input_set(active_1_io_input_set),
    .io_input_reset(active_1_io_input_reset),
    .io_input_asyn_reset(active_1_io_input_asyn_reset),
    .io_output(active_1_io_output)
  );
  bbox_SRFF done_0 ( // @[Controllers.scala 77:48:@4760.4]
    .clock(done_0_clock),
    .reset(done_0_reset),
    .io_input_set(done_0_io_input_set),
    .io_input_reset(done_0_io_input_reset),
    .io_input_asyn_reset(done_0_io_input_asyn_reset),
    .io_output(done_0_io_output)
  );
  bbox_SRFF done_1 ( // @[Controllers.scala 77:48:@4763.4]
    .clock(done_1_clock),
    .reset(done_1_reset),
    .io_input_set(done_1_io_input_set),
    .io_input_reset(done_1_io_input_reset),
    .io_input_asyn_reset(done_1_io_input_asyn_reset),
    .io_output(done_1_io_output)
  );
  bbox_SRFF iterDone_0 ( // @[Controllers.scala 90:52:@4792.4]
    .clock(iterDone_0_clock),
    .reset(iterDone_0_reset),
    .io_input_set(iterDone_0_io_input_set),
    .io_input_reset(iterDone_0_io_input_reset),
    .io_input_asyn_reset(iterDone_0_io_input_asyn_reset),
    .io_output(iterDone_0_io_output)
  );
  bbox_SRFF iterDone_1 ( // @[Controllers.scala 90:52:@4795.4]
    .clock(iterDone_1_clock),
    .reset(iterDone_1_reset),
    .io_input_set(iterDone_1_io_input_set),
    .io_input_reset(iterDone_1_io_input_reset),
    .io_input_asyn_reset(iterDone_1_io_input_asyn_reset),
    .io_output(iterDone_1_io_output)
  );
  bbox_RetimeWrapper RetimeWrapper ( // @[package.scala 93:22:@4823.4]
    .clock(RetimeWrapper_clock),
    .reset(RetimeWrapper_reset),
    .io_flow(RetimeWrapper_io_flow),
    .io_in(RetimeWrapper_io_in),
    .io_out(RetimeWrapper_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_1 ( // @[package.scala 93:22:@4836.4]
    .clock(RetimeWrapper_1_clock),
    .reset(RetimeWrapper_1_reset),
    .io_flow(RetimeWrapper_1_io_flow),
    .io_in(RetimeWrapper_1_io_in),
    .io_out(RetimeWrapper_1_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_2 ( // @[package.scala 93:22:@4862.4]
    .clock(RetimeWrapper_2_clock),
    .reset(RetimeWrapper_2_reset),
    .io_flow(RetimeWrapper_2_io_flow),
    .io_in(RetimeWrapper_2_io_in),
    .io_out(RetimeWrapper_2_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_3 ( // @[package.scala 93:22:@4882.4]
    .clock(RetimeWrapper_3_clock),
    .reset(RetimeWrapper_3_reset),
    .io_flow(RetimeWrapper_3_io_flow),
    .io_in(RetimeWrapper_3_io_in),
    .io_out(RetimeWrapper_3_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_4 ( // @[package.scala 93:22:@4931.4]
    .clock(RetimeWrapper_4_clock),
    .reset(RetimeWrapper_4_reset),
    .io_flow(RetimeWrapper_4_io_flow),
    .io_in(RetimeWrapper_4_io_in),
    .io_out(RetimeWrapper_4_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_5 ( // @[package.scala 93:22:@4948.4]
    .clock(RetimeWrapper_5_clock),
    .reset(RetimeWrapper_5_reset),
    .io_flow(RetimeWrapper_5_io_flow),
    .io_in(RetimeWrapper_5_io_in),
    .io_out(RetimeWrapper_5_io_out)
  );
  assign allDone = done_0_io_output & done_1_io_output; // @[Controllers.scala 80:47:@4766.4]
  assign _T_128 = active_0_io_output == iterDone_0_io_output; // @[Controllers.scala 102:95:@4822.4]
  assign _T_127 = iterDone_0_io_output | iterDone_1_io_output; // @[Controllers.scala 101:55:@4821.4]
  assign _T_132 = RetimeWrapper_io_out; // @[package.scala 96:25:@4828.4 package.scala 96:25:@4829.4]
  assign _T_135 = ~ _T_132; // @[Controllers.scala 102:142:@4831.4]
  assign _T_136 = active_0_io_output == _T_135; // @[Controllers.scala 102:138:@4832.4]
  assign _T_137 = _T_127 & _T_136; // @[Controllers.scala 102:123:@4833.4]
  assign _T_138 = _T_128 | _T_137; // @[Controllers.scala 102:112:@4834.4]
  assign _T_139 = active_1_io_output == iterDone_1_io_output; // @[Controllers.scala 102:95:@4835.4]
  assign _T_143 = RetimeWrapper_1_io_out; // @[package.scala 96:25:@4841.4 package.scala 96:25:@4842.4]
  assign _T_146 = ~ _T_143; // @[Controllers.scala 102:142:@4844.4]
  assign _T_147 = active_1_io_output == _T_146; // @[Controllers.scala 102:138:@4845.4]
  assign _T_148 = _T_127 & _T_147; // @[Controllers.scala 102:123:@4846.4]
  assign _T_149 = _T_139 | _T_148; // @[Controllers.scala 102:112:@4847.4]
  assign synchronize = _T_138 & _T_149; // @[Controllers.scala 102:164:@4848.4]
  assign _T_152 = done_0_io_output == 1'h0; // @[Controllers.scala 105:33:@4850.4]
  assign _T_154 = io_ctrDone == 1'h0; // @[Controllers.scala 105:54:@4851.4]
  assign _T_155 = _T_152 & _T_154; // @[Controllers.scala 105:52:@4852.4]
  assign _T_161 = synchronize == 1'h0; // @[Controllers.scala 107:51:@4859.4]
  assign _T_164 = _T_161 & _T_152; // @[Controllers.scala 107:64:@4861.4]
  assign _T_168 = RetimeWrapper_2_io_out; // @[package.scala 96:25:@4867.4 package.scala 96:25:@4868.4]
  assign _T_172 = _T_168 == 1'h0; // @[Controllers.scala 107:89:@4870.4]
  assign _T_173 = _T_164 & _T_172; // @[Controllers.scala 107:86:@4871.4]
  assign _T_174 = _T_173 & io_enable; // @[Controllers.scala 107:108:@4872.4]
  assign _T_189 = synchronize & active_0_io_output; // @[Controllers.scala 114:49:@4890.4]
  assign _T_192 = done_0_io_output & synchronize; // @[Controllers.scala 115:57:@4894.4]
  assign _T_203 = io_enable & active_0_io_output; // @[Controllers.scala 213:68:@4909.4]
  assign _T_204 = ~ iterDone_0_io_output; // @[Controllers.scala 213:92:@4910.4]
  assign _T_205 = _T_203 & _T_204; // @[Controllers.scala 213:90:@4911.4]
  assign _T_206 = _T_205 & io_maskIn_0; // @[Controllers.scala 213:115:@4912.4]
  assign _T_207 = ~ allDone; // @[Controllers.scala 213:132:@4913.4]
  assign _T_208 = _T_206 & _T_207; // @[Controllers.scala 213:130:@4914.4]
  assign _T_209 = ~ io_ctrDone; // @[Controllers.scala 213:156:@4915.4]
  assign _T_211 = io_enable & active_1_io_output; // @[Controllers.scala 213:68:@4918.4]
  assign _T_212 = ~ iterDone_1_io_output; // @[Controllers.scala 213:92:@4919.4]
  assign _T_213 = _T_211 & _T_212; // @[Controllers.scala 213:90:@4920.4]
  assign _T_214 = _T_213 & io_maskIn_1; // @[Controllers.scala 213:115:@4921.4]
  assign _T_220 = allDone == 1'h0; // @[package.scala 100:49:@4926.4]
  assign _T_224 = allDone & _T_223; // @[package.scala 100:41:@4929.4]
  assign io_done = RetimeWrapper_5_io_out; // @[Controllers.scala 245:13:@4955.4]
  assign io_ctrInc = iterDone_0_io_output & synchronize; // @[Controllers.scala 98:17:@4820.4]
  assign io_ctrRst = RetimeWrapper_4_io_out; // @[Controllers.scala 215:13:@4938.4]
  assign io_enableOut_0 = _T_208 & _T_209; // @[Controllers.scala 213:55:@4917.4]
  assign io_enableOut_1 = _T_214 & _T_207; // @[Controllers.scala 213:55:@4925.4]
  assign io_childAck_0 = iterDone_0_io_output; // @[Controllers.scala 212:58:@4906.4]
  assign io_childAck_1 = iterDone_1_io_output; // @[Controllers.scala 212:58:@4908.4]
  assign active_0_clock = clock; // @[:@4755.4]
  assign active_0_reset = reset; // @[:@4756.4]
  assign active_0_io_input_set = _T_155 & io_enable; // @[Controllers.scala 105:30:@4855.4]
  assign active_0_io_input_reset = io_ctrDone | io_parentAck; // @[Controllers.scala 106:32:@4858.4]
  assign active_0_io_input_asyn_reset = 1'h0; // @[Controllers.scala 84:40:@4769.4]
  assign active_1_clock = clock; // @[:@4758.4]
  assign active_1_reset = reset; // @[:@4759.4]
  assign active_1_io_input_set = _T_189 & io_enable; // @[Controllers.scala 114:32:@4893.4]
  assign active_1_io_input_reset = _T_192 | io_parentAck; // @[Controllers.scala 115:34:@4897.4]
  assign active_1_io_input_asyn_reset = 1'h0; // @[Controllers.scala 84:40:@4770.4]
  assign done_0_clock = clock; // @[:@4761.4]
  assign done_0_reset = reset; // @[:@4762.4]
  assign done_0_io_input_set = io_ctrDone; // @[Controllers.scala 108:28:@4880.4]
  assign done_0_io_input_reset = allDone | io_parentAck; // @[Controllers.scala 86:33:@4781.4]
  assign done_0_io_input_asyn_reset = 1'h0; // @[Controllers.scala 85:38:@4771.4]
  assign done_1_clock = clock; // @[:@4764.4]
  assign done_1_reset = reset; // @[:@4765.4]
  assign done_1_io_input_set = done_0_io_output & synchronize; // @[Controllers.scala 117:30:@4904.4]
  assign done_1_io_input_reset = allDone | io_parentAck; // @[Controllers.scala 86:33:@4790.4]
  assign done_1_io_input_asyn_reset = 1'h0; // @[Controllers.scala 85:38:@4772.4]
  assign iterDone_0_clock = clock; // @[:@4793.4]
  assign iterDone_0_reset = reset; // @[:@4794.4]
  assign iterDone_0_io_input_set = io_doneIn_0 | _T_174; // @[Controllers.scala 107:32:@4876.4]
  assign iterDone_0_io_input_reset = synchronize | io_parentAck; // @[Controllers.scala 92:37:@4808.4]
  assign iterDone_0_io_input_asyn_reset = 1'h0; // @[Controllers.scala 91:42:@4798.4]
  assign iterDone_1_clock = clock; // @[:@4796.4]
  assign iterDone_1_reset = reset; // @[:@4797.4]
  assign iterDone_1_io_input_set = io_doneIn_1; // @[Controllers.scala 116:34:@4899.4]
  assign iterDone_1_io_input_reset = synchronize | io_parentAck; // @[Controllers.scala 92:37:@4817.4]
  assign iterDone_1_io_input_asyn_reset = 1'h0; // @[Controllers.scala 91:42:@4799.4]
  assign RetimeWrapper_clock = clock; // @[:@4824.4]
  assign RetimeWrapper_reset = reset; // @[:@4825.4]
  assign RetimeWrapper_io_flow = 1'h1; // @[package.scala 95:18:@4827.4]
  assign RetimeWrapper_io_in = io_maskIn_0; // @[package.scala 94:16:@4826.4]
  assign RetimeWrapper_1_clock = clock; // @[:@4837.4]
  assign RetimeWrapper_1_reset = reset; // @[:@4838.4]
  assign RetimeWrapper_1_io_flow = 1'h1; // @[package.scala 95:18:@4840.4]
  assign RetimeWrapper_1_io_in = io_maskIn_1; // @[package.scala 94:16:@4839.4]
  assign RetimeWrapper_2_clock = clock; // @[:@4863.4]
  assign RetimeWrapper_2_reset = reset; // @[:@4864.4]
  assign RetimeWrapper_2_io_flow = 1'h1; // @[package.scala 95:18:@4866.4]
  assign RetimeWrapper_2_io_in = io_maskIn_0; // @[package.scala 94:16:@4865.4]
  assign RetimeWrapper_3_clock = clock; // @[:@4883.4]
  assign RetimeWrapper_3_reset = reset; // @[:@4884.4]
  assign RetimeWrapper_3_io_flow = 1'h1; // @[package.scala 95:18:@4886.4]
  assign RetimeWrapper_3_io_in = synchronize & iterDone_0_io_output; // @[package.scala 94:16:@4885.4]
  assign RetimeWrapper_4_clock = clock; // @[:@4932.4]
  assign RetimeWrapper_4_reset = reset; // @[:@4933.4]
  assign RetimeWrapper_4_io_flow = 1'h1; // @[package.scala 95:18:@4935.4]
  assign RetimeWrapper_4_io_in = _T_224 | io_parentAck; // @[package.scala 94:16:@4934.4]
  assign RetimeWrapper_5_clock = clock; // @[:@4949.4]
  assign RetimeWrapper_5_reset = reset; // @[:@4950.4]
  assign RetimeWrapper_5_io_flow = io_enable; // @[package.scala 95:18:@4952.4]
  assign RetimeWrapper_5_io_in = allDone & _T_237; // @[package.scala 94:16:@4951.4]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  _T_223 = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  _T_237 = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      _T_223 <= 1'h0;
    end else begin
      _T_223 <= _T_220;
    end
    if (reset) begin
      _T_237 <= 1'h0;
    end else begin
      _T_237 <= _T_220;
    end
  end
endmodule
module bbox_SimBlackBoxesfix2fixBox( // @[:@5069.2]
  input  [31:0] io_a, // @[:@5072.4]
  output [31:0] io_b // @[:@5072.4]
);
  assign io_b = io_a; // @[SimBlackBoxes.scala 99:40:@5082.4]
endmodule
module bbox__( // @[:@5084.2]
  input  [31:0] io_b, // @[:@5087.4]
  output [31:0] io_result // @[:@5087.4]
);
  wire [31:0] SimBlackBoxesfix2fixBox_io_a; // @[BigIPSim.scala 239:30:@5092.4]
  wire [31:0] SimBlackBoxesfix2fixBox_io_b; // @[BigIPSim.scala 239:30:@5092.4]
  bbox_SimBlackBoxesfix2fixBox SimBlackBoxesfix2fixBox ( // @[BigIPSim.scala 239:30:@5092.4]
    .io_a(SimBlackBoxesfix2fixBox_io_a),
    .io_b(SimBlackBoxesfix2fixBox_io_b)
  );
  assign io_result = SimBlackBoxesfix2fixBox_io_b; // @[Math.scala 706:17:@5105.4]
  assign SimBlackBoxesfix2fixBox_io_a = io_b; // @[BigIPSim.scala 241:23:@5100.4]
endmodule
module bbox_RetimeWrapper_46( // @[:@5427.2]
  input         clock, // @[:@5428.4]
  input         reset, // @[:@5429.4]
  input         io_flow, // @[:@5430.4]
  input  [31:0] io_in, // @[:@5430.4]
  output [31:0] io_out // @[:@5430.4]
);
  wire [31:0] sr_out; // @[RetimeShiftRegister.scala 15:20:@5432.4]
  wire [31:0] sr_in; // @[RetimeShiftRegister.scala 15:20:@5432.4]
  wire [31:0] sr_init; // @[RetimeShiftRegister.scala 15:20:@5432.4]
  wire  sr_flow; // @[RetimeShiftRegister.scala 15:20:@5432.4]
  wire  sr_reset; // @[RetimeShiftRegister.scala 15:20:@5432.4]
  wire  sr_clock; // @[RetimeShiftRegister.scala 15:20:@5432.4]
  RetimeShiftRegister #(.WIDTH(32), .STAGES(1)) sr ( // @[RetimeShiftRegister.scala 15:20:@5432.4]
    .out(sr_out),
    .in(sr_in),
    .init(sr_init),
    .flow(sr_flow),
    .reset(sr_reset),
    .clock(sr_clock)
  );
  assign io_out = sr_out; // @[RetimeShiftRegister.scala 21:12:@5445.4]
  assign sr_in = io_in; // @[RetimeShiftRegister.scala 20:14:@5444.4]
  assign sr_init = 32'h1; // @[RetimeShiftRegister.scala 19:16:@5443.4]
  assign sr_flow = io_flow; // @[RetimeShiftRegister.scala 18:16:@5442.4]
  assign sr_reset = reset; // @[RetimeShiftRegister.scala 17:17:@5441.4]
  assign sr_clock = clock; // @[RetimeShiftRegister.scala 16:17:@5439.4]
endmodule
module bbox_NBufCtr( // @[:@5447.2]
  input         clock, // @[:@5448.4]
  input         reset, // @[:@5449.4]
  input         io_input_countUp, // @[:@5450.4]
  input         io_input_enable, // @[:@5450.4]
  output [31:0] io_output_count // @[:@5450.4]
);
  wire  RetimeWrapper_clock; // @[package.scala 93:22:@5487.4]
  wire  RetimeWrapper_reset; // @[package.scala 93:22:@5487.4]
  wire  RetimeWrapper_io_flow; // @[package.scala 93:22:@5487.4]
  wire [31:0] RetimeWrapper_io_in; // @[package.scala 93:22:@5487.4]
  wire [31:0] RetimeWrapper_io_out; // @[package.scala 93:22:@5487.4]
  wire [31:0] _T_66; // @[package.scala 96:25:@5492.4 package.scala 96:25:@5493.4]
  wire [32:0] _T_18; // @[Counter.scala 49:32:@5453.4]
  wire [31:0] _T_19; // @[Counter.scala 49:32:@5454.4]
  wire  _T_21; // @[Counter.scala 49:55:@5455.4]
  wire [31:0] _T_22; // @[Counter.scala 49:84:@5456.4]
  wire [32:0] _T_24; // @[Counter.scala 49:91:@5457.4]
  wire [31:0] _T_25; // @[Counter.scala 49:91:@5458.4]
  wire [31:0] _T_26; // @[Counter.scala 49:91:@5459.4]
  wire [31:0] _T_27; // @[Counter.scala 49:126:@5460.4]
  wire  _T_33; // @[Counter.scala 51:52:@5464.4]
  wire [32:0] _T_36; // @[Counter.scala 51:103:@5465.4]
  wire [32:0] _T_37; // @[Counter.scala 51:103:@5466.4]
  wire [31:0] _T_38; // @[Counter.scala 51:103:@5467.4]
  wire [31:0] _T_39; // @[Counter.scala 51:47:@5468.4]
  wire [31:0] _T_40; // @[Counter.scala 51:26:@5469.4]
  wire [32:0] _T_42; // @[Counter.scala 52:50:@5470.4]
  wire [31:0] _T_43; // @[Counter.scala 52:50:@5471.4]
  wire  _T_45; // @[Counter.scala 52:70:@5472.4]
  wire [32:0] _T_49; // @[Counter.scala 52:121:@5474.4]
  wire [31:0] _T_50; // @[Counter.scala 52:121:@5475.4]
  wire [31:0] _T_51; // @[Counter.scala 52:121:@5476.4]
  wire [31:0] _T_52; // @[Counter.scala 52:155:@5477.4]
  wire [32:0] _T_53; // @[Counter.scala 52:107:@5478.4]
  wire [31:0] _T_54; // @[Counter.scala 52:107:@5479.4]
  wire [31:0] _T_58; // @[Counter.scala 52:45:@5482.4]
  wire [31:0] _T_59; // @[Counter.scala 52:24:@5483.4]
  wire [31:0] _T_62; // @[Counter.scala 53:52:@5485.4]
  bbox_RetimeWrapper_46 RetimeWrapper ( // @[package.scala 93:22:@5487.4]
    .clock(RetimeWrapper_clock),
    .reset(RetimeWrapper_reset),
    .io_flow(RetimeWrapper_io_flow),
    .io_in(RetimeWrapper_io_in),
    .io_out(RetimeWrapper_io_out)
  );
  assign _T_66 = RetimeWrapper_io_out; // @[package.scala 96:25:@5492.4 package.scala 96:25:@5493.4]
  assign _T_18 = {{1'd0}, _T_66}; // @[Counter.scala 49:32:@5453.4]
  assign _T_19 = _T_18[31:0]; // @[Counter.scala 49:32:@5454.4]
  assign _T_21 = _T_19 >= 32'h2; // @[Counter.scala 49:55:@5455.4]
  assign _T_22 = $signed(_T_66); // @[Counter.scala 49:84:@5456.4]
  assign _T_24 = $signed(_T_22) + $signed(-32'sh2); // @[Counter.scala 49:91:@5457.4]
  assign _T_25 = $signed(_T_22) + $signed(-32'sh2); // @[Counter.scala 49:91:@5458.4]
  assign _T_26 = $signed(_T_25); // @[Counter.scala 49:91:@5459.4]
  assign _T_27 = $unsigned(_T_26); // @[Counter.scala 49:126:@5460.4]
  assign _T_33 = _T_66 == 32'h0; // @[Counter.scala 51:52:@5464.4]
  assign _T_36 = _T_66 - 32'h1; // @[Counter.scala 51:103:@5465.4]
  assign _T_37 = $unsigned(_T_36); // @[Counter.scala 51:103:@5466.4]
  assign _T_38 = _T_37[31:0]; // @[Counter.scala 51:103:@5467.4]
  assign _T_39 = _T_33 ? 32'h1 : _T_38; // @[Counter.scala 51:47:@5468.4]
  assign _T_40 = io_input_enable ? _T_39 : _T_66; // @[Counter.scala 51:26:@5469.4]
  assign _T_42 = _T_66 + 32'h1; // @[Counter.scala 52:50:@5470.4]
  assign _T_43 = _T_66 + 32'h1; // @[Counter.scala 52:50:@5471.4]
  assign _T_45 = _T_43 >= 32'h2; // @[Counter.scala 52:70:@5472.4]
  assign _T_49 = $signed(_T_22) + $signed(-32'sh1); // @[Counter.scala 52:121:@5474.4]
  assign _T_50 = $signed(_T_22) + $signed(-32'sh1); // @[Counter.scala 52:121:@5475.4]
  assign _T_51 = $signed(_T_50); // @[Counter.scala 52:121:@5476.4]
  assign _T_52 = $unsigned(_T_51); // @[Counter.scala 52:155:@5477.4]
  assign _T_53 = {{1'd0}, _T_52}; // @[Counter.scala 52:107:@5478.4]
  assign _T_54 = _T_53[31:0]; // @[Counter.scala 52:107:@5479.4]
  assign _T_58 = _T_45 ? _T_54 : _T_43; // @[Counter.scala 52:45:@5482.4]
  assign _T_59 = io_input_enable ? _T_58 : _T_66; // @[Counter.scala 52:24:@5483.4]
  assign _T_62 = io_input_countUp ? _T_59 : _T_40; // @[Counter.scala 53:52:@5485.4]
  assign io_output_count = _T_21 ? _T_27 : _T_19; // @[Counter.scala 55:21:@5495.4]
  assign RetimeWrapper_clock = clock; // @[:@5488.4]
  assign RetimeWrapper_reset = reset; // @[:@5489.4]
  assign RetimeWrapper_io_flow = 1'h1; // @[package.scala 95:18:@5491.4]
  assign RetimeWrapper_io_in = reset ? 32'h1 : _T_62; // @[package.scala 94:16:@5490.4]
endmodule
module bbox_NBufCtr_2( // @[:@5611.2]
  input         clock, // @[:@5612.4]
  input         reset, // @[:@5613.4]
  input         io_input_countUp, // @[:@5614.4]
  input         io_input_enable, // @[:@5614.4]
  output [31:0] io_output_count // @[:@5614.4]
);
  wire  RetimeWrapper_clock; // @[package.scala 93:22:@5651.4]
  wire  RetimeWrapper_reset; // @[package.scala 93:22:@5651.4]
  wire  RetimeWrapper_io_flow; // @[package.scala 93:22:@5651.4]
  wire [31:0] RetimeWrapper_io_in; // @[package.scala 93:22:@5651.4]
  wire [31:0] RetimeWrapper_io_out; // @[package.scala 93:22:@5651.4]
  wire [31:0] _T_66; // @[package.scala 96:25:@5656.4 package.scala 96:25:@5657.4]
  wire [32:0] _T_18; // @[Counter.scala 49:32:@5617.4]
  wire [31:0] _T_19; // @[Counter.scala 49:32:@5618.4]
  wire  _T_21; // @[Counter.scala 49:55:@5619.4]
  wire [31:0] _T_22; // @[Counter.scala 49:84:@5620.4]
  wire [32:0] _T_24; // @[Counter.scala 49:91:@5621.4]
  wire [31:0] _T_25; // @[Counter.scala 49:91:@5622.4]
  wire [31:0] _T_26; // @[Counter.scala 49:91:@5623.4]
  wire [31:0] _T_27; // @[Counter.scala 49:126:@5624.4]
  wire  _T_33; // @[Counter.scala 51:52:@5628.4]
  wire [32:0] _T_36; // @[Counter.scala 51:103:@5629.4]
  wire [32:0] _T_37; // @[Counter.scala 51:103:@5630.4]
  wire [31:0] _T_38; // @[Counter.scala 51:103:@5631.4]
  wire [31:0] _T_39; // @[Counter.scala 51:47:@5632.4]
  wire [31:0] _T_40; // @[Counter.scala 51:26:@5633.4]
  wire [32:0] _T_53; // @[Counter.scala 52:107:@5642.4]
  wire [31:0] _T_54; // @[Counter.scala 52:107:@5643.4]
  wire [31:0] _T_58; // @[Counter.scala 52:45:@5646.4]
  wire [31:0] _T_59; // @[Counter.scala 52:24:@5647.4]
  wire [31:0] _T_62; // @[Counter.scala 53:52:@5649.4]
  bbox_RetimeWrapper_46 RetimeWrapper ( // @[package.scala 93:22:@5651.4]
    .clock(RetimeWrapper_clock),
    .reset(RetimeWrapper_reset),
    .io_flow(RetimeWrapper_io_flow),
    .io_in(RetimeWrapper_io_in),
    .io_out(RetimeWrapper_io_out)
  );
  assign _T_66 = RetimeWrapper_io_out; // @[package.scala 96:25:@5656.4 package.scala 96:25:@5657.4]
  assign _T_18 = _T_66 + 32'h1; // @[Counter.scala 49:32:@5617.4]
  assign _T_19 = _T_66 + 32'h1; // @[Counter.scala 49:32:@5618.4]
  assign _T_21 = _T_19 >= 32'h2; // @[Counter.scala 49:55:@5619.4]
  assign _T_22 = $signed(_T_66); // @[Counter.scala 49:84:@5620.4]
  assign _T_24 = $signed(_T_22) + $signed(-32'sh1); // @[Counter.scala 49:91:@5621.4]
  assign _T_25 = $signed(_T_22) + $signed(-32'sh1); // @[Counter.scala 49:91:@5622.4]
  assign _T_26 = $signed(_T_25); // @[Counter.scala 49:91:@5623.4]
  assign _T_27 = $unsigned(_T_26); // @[Counter.scala 49:126:@5624.4]
  assign _T_33 = _T_66 == 32'h0; // @[Counter.scala 51:52:@5628.4]
  assign _T_36 = _T_66 - 32'h1; // @[Counter.scala 51:103:@5629.4]
  assign _T_37 = $unsigned(_T_36); // @[Counter.scala 51:103:@5630.4]
  assign _T_38 = _T_37[31:0]; // @[Counter.scala 51:103:@5631.4]
  assign _T_39 = _T_33 ? 32'h1 : _T_38; // @[Counter.scala 51:47:@5632.4]
  assign _T_40 = io_input_enable ? _T_39 : _T_66; // @[Counter.scala 51:26:@5633.4]
  assign _T_53 = {{1'd0}, _T_27}; // @[Counter.scala 52:107:@5642.4]
  assign _T_54 = _T_53[31:0]; // @[Counter.scala 52:107:@5643.4]
  assign _T_58 = _T_21 ? _T_54 : _T_19; // @[Counter.scala 52:45:@5646.4]
  assign _T_59 = io_input_enable ? _T_58 : _T_66; // @[Counter.scala 52:24:@5647.4]
  assign _T_62 = io_input_countUp ? _T_59 : _T_40; // @[Counter.scala 53:52:@5649.4]
  assign io_output_count = _T_21 ? _T_27 : _T_19; // @[Counter.scala 55:21:@5659.4]
  assign RetimeWrapper_clock = clock; // @[:@5652.4]
  assign RetimeWrapper_reset = reset; // @[:@5653.4]
  assign RetimeWrapper_io_flow = 1'h1; // @[package.scala 95:18:@5655.4]
  assign RetimeWrapper_io_in = reset ? 32'h1 : _T_62; // @[package.scala 94:16:@5654.4]
endmodule
module bbox_NBufController( // @[:@5661.2]
  input        clock, // @[:@5662.4]
  input        reset, // @[:@5663.4]
  input        io_sEn_0, // @[:@5664.4]
  input        io_sEn_1, // @[:@5664.4]
  input        io_sDone_0, // @[:@5664.4]
  input        io_sDone_1, // @[:@5664.4]
  output [2:0] io_statesInW_0, // @[:@5664.4]
  output [2:0] io_statesInR_1 // @[:@5664.4]
);
  wire  sEn_latch_0_clock; // @[NBuffers.scala 21:52:@5666.4]
  wire  sEn_latch_0_reset; // @[NBuffers.scala 21:52:@5666.4]
  wire  sEn_latch_0_io_input_set; // @[NBuffers.scala 21:52:@5666.4]
  wire  sEn_latch_0_io_input_reset; // @[NBuffers.scala 21:52:@5666.4]
  wire  sEn_latch_0_io_input_asyn_reset; // @[NBuffers.scala 21:52:@5666.4]
  wire  sEn_latch_0_io_output; // @[NBuffers.scala 21:52:@5666.4]
  wire  sEn_latch_1_clock; // @[NBuffers.scala 21:52:@5669.4]
  wire  sEn_latch_1_reset; // @[NBuffers.scala 21:52:@5669.4]
  wire  sEn_latch_1_io_input_set; // @[NBuffers.scala 21:52:@5669.4]
  wire  sEn_latch_1_io_input_reset; // @[NBuffers.scala 21:52:@5669.4]
  wire  sEn_latch_1_io_input_asyn_reset; // @[NBuffers.scala 21:52:@5669.4]
  wire  sEn_latch_1_io_output; // @[NBuffers.scala 21:52:@5669.4]
  wire  sDone_latch_0_clock; // @[NBuffers.scala 22:54:@5672.4]
  wire  sDone_latch_0_reset; // @[NBuffers.scala 22:54:@5672.4]
  wire  sDone_latch_0_io_input_set; // @[NBuffers.scala 22:54:@5672.4]
  wire  sDone_latch_0_io_input_reset; // @[NBuffers.scala 22:54:@5672.4]
  wire  sDone_latch_0_io_input_asyn_reset; // @[NBuffers.scala 22:54:@5672.4]
  wire  sDone_latch_0_io_output; // @[NBuffers.scala 22:54:@5672.4]
  wire  sDone_latch_1_clock; // @[NBuffers.scala 22:54:@5675.4]
  wire  sDone_latch_1_reset; // @[NBuffers.scala 22:54:@5675.4]
  wire  sDone_latch_1_io_input_set; // @[NBuffers.scala 22:54:@5675.4]
  wire  sDone_latch_1_io_input_reset; // @[NBuffers.scala 22:54:@5675.4]
  wire  sDone_latch_1_io_input_asyn_reset; // @[NBuffers.scala 22:54:@5675.4]
  wire  sDone_latch_1_io_output; // @[NBuffers.scala 22:54:@5675.4]
  wire  RetimeWrapper_clock; // @[package.scala 93:22:@5682.4]
  wire  RetimeWrapper_reset; // @[package.scala 93:22:@5682.4]
  wire  RetimeWrapper_io_flow; // @[package.scala 93:22:@5682.4]
  wire  RetimeWrapper_io_in; // @[package.scala 93:22:@5682.4]
  wire  RetimeWrapper_io_out; // @[package.scala 93:22:@5682.4]
  wire  RetimeWrapper_1_clock; // @[package.scala 93:22:@5690.4]
  wire  RetimeWrapper_1_reset; // @[package.scala 93:22:@5690.4]
  wire  RetimeWrapper_1_io_flow; // @[package.scala 93:22:@5690.4]
  wire  RetimeWrapper_1_io_in; // @[package.scala 93:22:@5690.4]
  wire  RetimeWrapper_1_io_out; // @[package.scala 93:22:@5690.4]
  wire  RetimeWrapper_2_clock; // @[package.scala 93:22:@5699.4]
  wire  RetimeWrapper_2_reset; // @[package.scala 93:22:@5699.4]
  wire  RetimeWrapper_2_io_flow; // @[package.scala 93:22:@5699.4]
  wire  RetimeWrapper_2_io_in; // @[package.scala 93:22:@5699.4]
  wire  RetimeWrapper_2_io_out; // @[package.scala 93:22:@5699.4]
  wire  RetimeWrapper_3_clock; // @[package.scala 93:22:@5707.4]
  wire  RetimeWrapper_3_reset; // @[package.scala 93:22:@5707.4]
  wire  RetimeWrapper_3_io_flow; // @[package.scala 93:22:@5707.4]
  wire  RetimeWrapper_3_io_in; // @[package.scala 93:22:@5707.4]
  wire  RetimeWrapper_3_io_out; // @[package.scala 93:22:@5707.4]
  wire  RetimeWrapper_4_clock; // @[package.scala 93:22:@5718.4]
  wire  RetimeWrapper_4_reset; // @[package.scala 93:22:@5718.4]
  wire  RetimeWrapper_4_io_flow; // @[package.scala 93:22:@5718.4]
  wire  RetimeWrapper_4_io_in; // @[package.scala 93:22:@5718.4]
  wire  RetimeWrapper_4_io_out; // @[package.scala 93:22:@5718.4]
  wire  RetimeWrapper_5_clock; // @[package.scala 93:22:@5726.4]
  wire  RetimeWrapper_5_reset; // @[package.scala 93:22:@5726.4]
  wire  RetimeWrapper_5_io_flow; // @[package.scala 93:22:@5726.4]
  wire  RetimeWrapper_5_io_in; // @[package.scala 93:22:@5726.4]
  wire  RetimeWrapper_5_io_out; // @[package.scala 93:22:@5726.4]
  wire  RetimeWrapper_6_clock; // @[package.scala 93:22:@5735.4]
  wire  RetimeWrapper_6_reset; // @[package.scala 93:22:@5735.4]
  wire  RetimeWrapper_6_io_flow; // @[package.scala 93:22:@5735.4]
  wire  RetimeWrapper_6_io_in; // @[package.scala 93:22:@5735.4]
  wire  RetimeWrapper_6_io_out; // @[package.scala 93:22:@5735.4]
  wire  RetimeWrapper_7_clock; // @[package.scala 93:22:@5743.4]
  wire  RetimeWrapper_7_reset; // @[package.scala 93:22:@5743.4]
  wire  RetimeWrapper_7_io_flow; // @[package.scala 93:22:@5743.4]
  wire  RetimeWrapper_7_io_in; // @[package.scala 93:22:@5743.4]
  wire  RetimeWrapper_7_io_out; // @[package.scala 93:22:@5743.4]
  wire  NBufCtr_clock; // @[NBuffers.scala 40:19:@5764.4]
  wire  NBufCtr_reset; // @[NBuffers.scala 40:19:@5764.4]
  wire  NBufCtr_io_input_countUp; // @[NBuffers.scala 40:19:@5764.4]
  wire  NBufCtr_io_input_enable; // @[NBuffers.scala 40:19:@5764.4]
  wire [31:0] NBufCtr_io_output_count; // @[NBuffers.scala 40:19:@5764.4]
  wire  statesInR_0_clock; // @[NBuffers.scala 50:19:@5775.4]
  wire  statesInR_0_reset; // @[NBuffers.scala 50:19:@5775.4]
  wire  statesInR_0_io_input_countUp; // @[NBuffers.scala 50:19:@5775.4]
  wire  statesInR_0_io_input_enable; // @[NBuffers.scala 50:19:@5775.4]
  wire [31:0] statesInR_0_io_output_count; // @[NBuffers.scala 50:19:@5775.4]
  wire  statesInR_1_clock; // @[NBuffers.scala 50:19:@5786.4]
  wire  statesInR_1_reset; // @[NBuffers.scala 50:19:@5786.4]
  wire  statesInR_1_io_input_countUp; // @[NBuffers.scala 50:19:@5786.4]
  wire  statesInR_1_io_input_enable; // @[NBuffers.scala 50:19:@5786.4]
  wire [31:0] statesInR_1_io_output_count; // @[NBuffers.scala 50:19:@5786.4]
  wire  _T_33; // @[NBuffers.scala 26:46:@5679.4]
  wire  _T_48; // @[NBuffers.scala 26:46:@5715.4]
  wire  anyEnabled; // @[NBuffers.scala 33:64:@5751.4]
  wire  _T_62; // @[NBuffers.scala 34:124:@5752.4]
  wire  _T_63; // @[NBuffers.scala 34:104:@5753.4]
  wire  _T_64; // @[NBuffers.scala 34:124:@5754.4]
  wire  _T_65; // @[NBuffers.scala 34:104:@5755.4]
  wire  _T_66; // @[NBuffers.scala 34:150:@5756.4]
  wire  _T_67; // @[NBuffers.scala 34:154:@5757.4]
  wire  _T_69; // @[package.scala 100:49:@5758.4]
  reg  _T_72; // @[package.scala 48:56:@5759.4]
  reg [31:0] _RAND_0;
  bbox_SRFF sEn_latch_0 ( // @[NBuffers.scala 21:52:@5666.4]
    .clock(sEn_latch_0_clock),
    .reset(sEn_latch_0_reset),
    .io_input_set(sEn_latch_0_io_input_set),
    .io_input_reset(sEn_latch_0_io_input_reset),
    .io_input_asyn_reset(sEn_latch_0_io_input_asyn_reset),
    .io_output(sEn_latch_0_io_output)
  );
  bbox_SRFF sEn_latch_1 ( // @[NBuffers.scala 21:52:@5669.4]
    .clock(sEn_latch_1_clock),
    .reset(sEn_latch_1_reset),
    .io_input_set(sEn_latch_1_io_input_set),
    .io_input_reset(sEn_latch_1_io_input_reset),
    .io_input_asyn_reset(sEn_latch_1_io_input_asyn_reset),
    .io_output(sEn_latch_1_io_output)
  );
  bbox_SRFF sDone_latch_0 ( // @[NBuffers.scala 22:54:@5672.4]
    .clock(sDone_latch_0_clock),
    .reset(sDone_latch_0_reset),
    .io_input_set(sDone_latch_0_io_input_set),
    .io_input_reset(sDone_latch_0_io_input_reset),
    .io_input_asyn_reset(sDone_latch_0_io_input_asyn_reset),
    .io_output(sDone_latch_0_io_output)
  );
  bbox_SRFF sDone_latch_1 ( // @[NBuffers.scala 22:54:@5675.4]
    .clock(sDone_latch_1_clock),
    .reset(sDone_latch_1_reset),
    .io_input_set(sDone_latch_1_io_input_set),
    .io_input_reset(sDone_latch_1_io_input_reset),
    .io_input_asyn_reset(sDone_latch_1_io_input_asyn_reset),
    .io_output(sDone_latch_1_io_output)
  );
  bbox_RetimeWrapper RetimeWrapper ( // @[package.scala 93:22:@5682.4]
    .clock(RetimeWrapper_clock),
    .reset(RetimeWrapper_reset),
    .io_flow(RetimeWrapper_io_flow),
    .io_in(RetimeWrapper_io_in),
    .io_out(RetimeWrapper_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_1 ( // @[package.scala 93:22:@5690.4]
    .clock(RetimeWrapper_1_clock),
    .reset(RetimeWrapper_1_reset),
    .io_flow(RetimeWrapper_1_io_flow),
    .io_in(RetimeWrapper_1_io_in),
    .io_out(RetimeWrapper_1_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_2 ( // @[package.scala 93:22:@5699.4]
    .clock(RetimeWrapper_2_clock),
    .reset(RetimeWrapper_2_reset),
    .io_flow(RetimeWrapper_2_io_flow),
    .io_in(RetimeWrapper_2_io_in),
    .io_out(RetimeWrapper_2_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_3 ( // @[package.scala 93:22:@5707.4]
    .clock(RetimeWrapper_3_clock),
    .reset(RetimeWrapper_3_reset),
    .io_flow(RetimeWrapper_3_io_flow),
    .io_in(RetimeWrapper_3_io_in),
    .io_out(RetimeWrapper_3_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_4 ( // @[package.scala 93:22:@5718.4]
    .clock(RetimeWrapper_4_clock),
    .reset(RetimeWrapper_4_reset),
    .io_flow(RetimeWrapper_4_io_flow),
    .io_in(RetimeWrapper_4_io_in),
    .io_out(RetimeWrapper_4_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_5 ( // @[package.scala 93:22:@5726.4]
    .clock(RetimeWrapper_5_clock),
    .reset(RetimeWrapper_5_reset),
    .io_flow(RetimeWrapper_5_io_flow),
    .io_in(RetimeWrapper_5_io_in),
    .io_out(RetimeWrapper_5_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_6 ( // @[package.scala 93:22:@5735.4]
    .clock(RetimeWrapper_6_clock),
    .reset(RetimeWrapper_6_reset),
    .io_flow(RetimeWrapper_6_io_flow),
    .io_in(RetimeWrapper_6_io_in),
    .io_out(RetimeWrapper_6_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_7 ( // @[package.scala 93:22:@5743.4]
    .clock(RetimeWrapper_7_clock),
    .reset(RetimeWrapper_7_reset),
    .io_flow(RetimeWrapper_7_io_flow),
    .io_in(RetimeWrapper_7_io_in),
    .io_out(RetimeWrapper_7_io_out)
  );
  bbox_NBufCtr NBufCtr ( // @[NBuffers.scala 40:19:@5764.4]
    .clock(NBufCtr_clock),
    .reset(NBufCtr_reset),
    .io_input_countUp(NBufCtr_io_input_countUp),
    .io_input_enable(NBufCtr_io_input_enable),
    .io_output_count(NBufCtr_io_output_count)
  );
  bbox_NBufCtr statesInR_0 ( // @[NBuffers.scala 50:19:@5775.4]
    .clock(statesInR_0_clock),
    .reset(statesInR_0_reset),
    .io_input_countUp(statesInR_0_io_input_countUp),
    .io_input_enable(statesInR_0_io_input_enable),
    .io_output_count(statesInR_0_io_output_count)
  );
  bbox_NBufCtr_2 statesInR_1 ( // @[NBuffers.scala 50:19:@5786.4]
    .clock(statesInR_1_clock),
    .reset(statesInR_1_reset),
    .io_input_countUp(statesInR_1_io_input_countUp),
    .io_input_enable(statesInR_1_io_input_enable),
    .io_output_count(statesInR_1_io_output_count)
  );
  assign _T_33 = io_sDone_0 == 1'h0; // @[NBuffers.scala 26:46:@5679.4]
  assign _T_48 = io_sDone_1 == 1'h0; // @[NBuffers.scala 26:46:@5715.4]
  assign anyEnabled = sEn_latch_0_io_output | sEn_latch_1_io_output; // @[NBuffers.scala 33:64:@5751.4]
  assign _T_62 = sDone_latch_0_io_output | io_sDone_0; // @[NBuffers.scala 34:124:@5752.4]
  assign _T_63 = sEn_latch_0_io_output == _T_62; // @[NBuffers.scala 34:104:@5753.4]
  assign _T_64 = sDone_latch_1_io_output | io_sDone_1; // @[NBuffers.scala 34:124:@5754.4]
  assign _T_65 = sEn_latch_1_io_output == _T_64; // @[NBuffers.scala 34:104:@5755.4]
  assign _T_66 = _T_63 & _T_65; // @[NBuffers.scala 34:150:@5756.4]
  assign _T_67 = _T_66 & anyEnabled; // @[NBuffers.scala 34:154:@5757.4]
  assign _T_69 = _T_67 == 1'h0; // @[package.scala 100:49:@5758.4]
  assign io_statesInW_0 = NBufCtr_io_output_count[2:0]; // @[NBuffers.scala 44:21:@5774.4]
  assign io_statesInR_1 = statesInR_1_io_output_count[2:0]; // @[NBuffers.scala 54:21:@5796.4]
  assign sEn_latch_0_clock = clock; // @[:@5667.4]
  assign sEn_latch_0_reset = reset; // @[:@5668.4]
  assign sEn_latch_0_io_input_set = io_sEn_0 & _T_33; // @[NBuffers.scala 26:31:@5681.4]
  assign sEn_latch_0_io_input_reset = RetimeWrapper_io_out; // @[NBuffers.scala 27:33:@5689.4]
  assign sEn_latch_0_io_input_asyn_reset = RetimeWrapper_1_io_out; // @[NBuffers.scala 28:38:@5697.4]
  assign sEn_latch_1_clock = clock; // @[:@5670.4]
  assign sEn_latch_1_reset = reset; // @[:@5671.4]
  assign sEn_latch_1_io_input_set = io_sEn_1 & _T_48; // @[NBuffers.scala 26:31:@5717.4]
  assign sEn_latch_1_io_input_reset = RetimeWrapper_4_io_out; // @[NBuffers.scala 27:33:@5725.4]
  assign sEn_latch_1_io_input_asyn_reset = RetimeWrapper_5_io_out; // @[NBuffers.scala 28:38:@5733.4]
  assign sDone_latch_0_clock = clock; // @[:@5673.4]
  assign sDone_latch_0_reset = reset; // @[:@5674.4]
  assign sDone_latch_0_io_input_set = io_sDone_0; // @[NBuffers.scala 29:33:@5698.4]
  assign sDone_latch_0_io_input_reset = RetimeWrapper_2_io_out; // @[NBuffers.scala 30:35:@5706.4]
  assign sDone_latch_0_io_input_asyn_reset = RetimeWrapper_3_io_out; // @[NBuffers.scala 31:40:@5714.4]
  assign sDone_latch_1_clock = clock; // @[:@5676.4]
  assign sDone_latch_1_reset = reset; // @[:@5677.4]
  assign sDone_latch_1_io_input_set = io_sDone_1; // @[NBuffers.scala 29:33:@5734.4]
  assign sDone_latch_1_io_input_reset = RetimeWrapper_6_io_out; // @[NBuffers.scala 30:35:@5742.4]
  assign sDone_latch_1_io_input_asyn_reset = RetimeWrapper_7_io_out; // @[NBuffers.scala 31:40:@5750.4]
  assign RetimeWrapper_clock = clock; // @[:@5683.4]
  assign RetimeWrapper_reset = reset; // @[:@5684.4]
  assign RetimeWrapper_io_flow = 1'h1; // @[package.scala 95:18:@5686.4]
  assign RetimeWrapper_io_in = _T_67 & _T_72; // @[package.scala 94:16:@5685.4]
  assign RetimeWrapper_1_clock = clock; // @[:@5691.4]
  assign RetimeWrapper_1_reset = reset; // @[:@5692.4]
  assign RetimeWrapper_1_io_flow = 1'h1; // @[package.scala 95:18:@5694.4]
  assign RetimeWrapper_1_io_in = reset; // @[package.scala 94:16:@5693.4]
  assign RetimeWrapper_2_clock = clock; // @[:@5700.4]
  assign RetimeWrapper_2_reset = reset; // @[:@5701.4]
  assign RetimeWrapper_2_io_flow = 1'h1; // @[package.scala 95:18:@5703.4]
  assign RetimeWrapper_2_io_in = _T_67 & _T_72; // @[package.scala 94:16:@5702.4]
  assign RetimeWrapper_3_clock = clock; // @[:@5708.4]
  assign RetimeWrapper_3_reset = reset; // @[:@5709.4]
  assign RetimeWrapper_3_io_flow = 1'h1; // @[package.scala 95:18:@5711.4]
  assign RetimeWrapper_3_io_in = reset; // @[package.scala 94:16:@5710.4]
  assign RetimeWrapper_4_clock = clock; // @[:@5719.4]
  assign RetimeWrapper_4_reset = reset; // @[:@5720.4]
  assign RetimeWrapper_4_io_flow = 1'h1; // @[package.scala 95:18:@5722.4]
  assign RetimeWrapper_4_io_in = _T_67 & _T_72; // @[package.scala 94:16:@5721.4]
  assign RetimeWrapper_5_clock = clock; // @[:@5727.4]
  assign RetimeWrapper_5_reset = reset; // @[:@5728.4]
  assign RetimeWrapper_5_io_flow = 1'h1; // @[package.scala 95:18:@5730.4]
  assign RetimeWrapper_5_io_in = reset; // @[package.scala 94:16:@5729.4]
  assign RetimeWrapper_6_clock = clock; // @[:@5736.4]
  assign RetimeWrapper_6_reset = reset; // @[:@5737.4]
  assign RetimeWrapper_6_io_flow = 1'h1; // @[package.scala 95:18:@5739.4]
  assign RetimeWrapper_6_io_in = _T_67 & _T_72; // @[package.scala 94:16:@5738.4]
  assign RetimeWrapper_7_clock = clock; // @[:@5744.4]
  assign RetimeWrapper_7_reset = reset; // @[:@5745.4]
  assign RetimeWrapper_7_io_flow = 1'h1; // @[package.scala 95:18:@5747.4]
  assign RetimeWrapper_7_io_in = reset; // @[package.scala 94:16:@5746.4]
  assign NBufCtr_clock = clock; // @[:@5765.4]
  assign NBufCtr_reset = reset; // @[:@5766.4]
  assign NBufCtr_io_input_countUp = 1'h0; // @[NBuffers.scala 43:24:@5773.4]
  assign NBufCtr_io_input_enable = _T_67 & _T_72; // @[NBuffers.scala 42:23:@5772.4]
  assign statesInR_0_clock = clock; // @[:@5776.4]
  assign statesInR_0_reset = reset; // @[:@5777.4]
  assign statesInR_0_io_input_countUp = 1'h0; // @[NBuffers.scala 53:24:@5784.4]
  assign statesInR_0_io_input_enable = _T_67 & _T_72; // @[NBuffers.scala 52:23:@5783.4]
  assign statesInR_1_clock = clock; // @[:@5787.4]
  assign statesInR_1_reset = reset; // @[:@5788.4]
  assign statesInR_1_io_input_countUp = 1'h0; // @[NBuffers.scala 53:24:@5795.4]
  assign statesInR_1_io_input_enable = _T_67 & _T_72; // @[NBuffers.scala 52:23:@5794.4]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  _T_72 = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      _T_72 <= 1'h0;
    end else begin
      _T_72 <= _T_69;
    end
  end
endmodule
module bbox_NBuf( // @[:@5848.2]
  input         clock, // @[:@5849.4]
  input         reset, // @[:@5850.4]
  output [31:0] io_rPort_0_output_0, // @[:@5851.4]
  input  [31:0] io_wPort_0_data_0, // @[:@5851.4]
  input         io_wPort_0_reset, // @[:@5851.4]
  input         io_wPort_0_en_0, // @[:@5851.4]
  input         io_sEn_0, // @[:@5851.4]
  input         io_sEn_1, // @[:@5851.4]
  input         io_sDone_0, // @[:@5851.4]
  input         io_sDone_1 // @[:@5851.4]
);
  wire  ctrl_clock; // @[NBuffers.scala 83:20:@5859.4]
  wire  ctrl_reset; // @[NBuffers.scala 83:20:@5859.4]
  wire  ctrl_io_sEn_0; // @[NBuffers.scala 83:20:@5859.4]
  wire  ctrl_io_sEn_1; // @[NBuffers.scala 83:20:@5859.4]
  wire  ctrl_io_sDone_0; // @[NBuffers.scala 83:20:@5859.4]
  wire  ctrl_io_sDone_1; // @[NBuffers.scala 83:20:@5859.4]
  wire [2:0] ctrl_io_statesInW_0; // @[NBuffers.scala 83:20:@5859.4]
  wire [2:0] ctrl_io_statesInR_1; // @[NBuffers.scala 83:20:@5859.4]
  wire  FF_clock; // @[NBuffers.scala 121:23:@5866.4]
  wire  FF_reset; // @[NBuffers.scala 121:23:@5866.4]
  wire [31:0] FF_io_rPort_0_output_0; // @[NBuffers.scala 121:23:@5866.4]
  wire [31:0] FF_io_wPort_0_data_0; // @[NBuffers.scala 121:23:@5866.4]
  wire  FF_io_wPort_0_reset; // @[NBuffers.scala 121:23:@5866.4]
  wire  FF_io_wPort_0_en_0; // @[NBuffers.scala 121:23:@5866.4]
  wire  FF_1_clock; // @[NBuffers.scala 121:23:@5882.4]
  wire  FF_1_reset; // @[NBuffers.scala 121:23:@5882.4]
  wire [31:0] FF_1_io_rPort_0_output_0; // @[NBuffers.scala 121:23:@5882.4]
  wire [31:0] FF_1_io_wPort_0_data_0; // @[NBuffers.scala 121:23:@5882.4]
  wire  FF_1_io_wPort_0_reset; // @[NBuffers.scala 121:23:@5882.4]
  wire  FF_1_io_wPort_0_en_0; // @[NBuffers.scala 121:23:@5882.4]
  wire  _T_102; // @[NBuffers.scala 128:105:@5900.4]
  wire  _T_106; // @[NBuffers.scala 132:92:@5910.4]
  wire  _T_109; // @[NBuffers.scala 128:105:@5916.4]
  wire  _T_113; // @[NBuffers.scala 132:92:@5926.4]
  wire [31:0] _T_121; // @[Mux.scala 19:72:@5934.4]
  wire [31:0] _T_123; // @[Mux.scala 19:72:@5935.4]
  bbox_NBufController ctrl ( // @[NBuffers.scala 83:20:@5859.4]
    .clock(ctrl_clock),
    .reset(ctrl_reset),
    .io_sEn_0(ctrl_io_sEn_0),
    .io_sEn_1(ctrl_io_sEn_1),
    .io_sDone_0(ctrl_io_sDone_0),
    .io_sDone_1(ctrl_io_sDone_1),
    .io_statesInW_0(ctrl_io_statesInW_0),
    .io_statesInR_1(ctrl_io_statesInR_1)
  );
  bbox_FF FF ( // @[NBuffers.scala 121:23:@5866.4]
    .clock(FF_clock),
    .reset(FF_reset),
    .io_rPort_0_output_0(FF_io_rPort_0_output_0),
    .io_wPort_0_data_0(FF_io_wPort_0_data_0),
    .io_wPort_0_reset(FF_io_wPort_0_reset),
    .io_wPort_0_en_0(FF_io_wPort_0_en_0)
  );
  bbox_FF FF_1 ( // @[NBuffers.scala 121:23:@5882.4]
    .clock(FF_1_clock),
    .reset(FF_1_reset),
    .io_rPort_0_output_0(FF_1_io_rPort_0_output_0),
    .io_wPort_0_data_0(FF_1_io_wPort_0_data_0),
    .io_wPort_0_reset(FF_1_io_wPort_0_reset),
    .io_wPort_0_en_0(FF_1_io_wPort_0_en_0)
  );
  assign _T_102 = ctrl_io_statesInW_0 == 3'h0; // @[NBuffers.scala 128:105:@5900.4]
  assign _T_106 = ctrl_io_statesInR_1 == 3'h0; // @[NBuffers.scala 132:92:@5910.4]
  assign _T_109 = ctrl_io_statesInW_0 == 3'h1; // @[NBuffers.scala 128:105:@5916.4]
  assign _T_113 = ctrl_io_statesInR_1 == 3'h1; // @[NBuffers.scala 132:92:@5926.4]
  assign _T_121 = _T_106 ? FF_io_rPort_0_output_0 : 32'h0; // @[Mux.scala 19:72:@5934.4]
  assign _T_123 = _T_113 ? FF_1_io_rPort_0_output_0 : 32'h0; // @[Mux.scala 19:72:@5935.4]
  assign io_rPort_0_output_0 = _T_121 | _T_123; // @[NBuffers.scala 138:66:@5939.4]
  assign ctrl_clock = clock; // @[:@5860.4]
  assign ctrl_reset = reset; // @[:@5861.4]
  assign ctrl_io_sEn_0 = io_sEn_0; // @[NBuffers.scala 85:20:@5862.4]
  assign ctrl_io_sEn_1 = io_sEn_1; // @[NBuffers.scala 85:20:@5864.4]
  assign ctrl_io_sDone_0 = io_sDone_0; // @[NBuffers.scala 86:22:@5863.4]
  assign ctrl_io_sDone_1 = io_sDone_1; // @[NBuffers.scala 86:22:@5865.4]
  assign FF_clock = clock; // @[:@5867.4]
  assign FF_reset = reset; // @[:@5868.4]
  assign FF_io_wPort_0_data_0 = io_wPort_0_data_0; // @[MemPrimitives.scala 33:29:@5903.4]
  assign FF_io_wPort_0_reset = io_wPort_0_reset; // @[MemPrimitives.scala 34:29:@5904.4]
  assign FF_io_wPort_0_en_0 = io_wPort_0_en_0 & _T_102; // @[MemPrimitives.scala 37:29:@5909.4]
  assign FF_1_clock = clock; // @[:@5883.4]
  assign FF_1_reset = reset; // @[:@5884.4]
  assign FF_1_io_wPort_0_data_0 = io_wPort_0_data_0; // @[MemPrimitives.scala 33:29:@5919.4]
  assign FF_1_io_wPort_0_reset = io_wPort_0_reset; // @[MemPrimitives.scala 34:29:@5920.4]
  assign FF_1_io_wPort_0_en_0 = io_wPort_0_en_0 & _T_109; // @[MemPrimitives.scala 37:29:@5925.4]
endmodule
module bbox_b86_chain( // @[:@5941.2]
  input         clock, // @[:@5942.4]
  input         reset, // @[:@5943.4]
  output [31:0] io_rPort_0_output_0, // @[:@5944.4]
  input  [31:0] io_wPort_0_data_0, // @[:@5944.4]
  input         io_wPort_0_reset, // @[:@5944.4]
  input         io_wPort_0_en_0, // @[:@5944.4]
  input         io_sEn_0, // @[:@5944.4]
  input         io_sEn_1, // @[:@5944.4]
  input         io_sDone_0, // @[:@5944.4]
  input         io_sDone_1 // @[:@5944.4]
);
  wire  nbufFF_clock; // @[NBuffers.scala 273:22:@5952.4]
  wire  nbufFF_reset; // @[NBuffers.scala 273:22:@5952.4]
  wire [31:0] nbufFF_io_rPort_0_output_0; // @[NBuffers.scala 273:22:@5952.4]
  wire [31:0] nbufFF_io_wPort_0_data_0; // @[NBuffers.scala 273:22:@5952.4]
  wire  nbufFF_io_wPort_0_reset; // @[NBuffers.scala 273:22:@5952.4]
  wire  nbufFF_io_wPort_0_en_0; // @[NBuffers.scala 273:22:@5952.4]
  wire  nbufFF_io_sEn_0; // @[NBuffers.scala 273:22:@5952.4]
  wire  nbufFF_io_sEn_1; // @[NBuffers.scala 273:22:@5952.4]
  wire  nbufFF_io_sDone_0; // @[NBuffers.scala 273:22:@5952.4]
  wire  nbufFF_io_sDone_1; // @[NBuffers.scala 273:22:@5952.4]
  bbox_NBuf nbufFF ( // @[NBuffers.scala 273:22:@5952.4]
    .clock(nbufFF_clock),
    .reset(nbufFF_reset),
    .io_rPort_0_output_0(nbufFF_io_rPort_0_output_0),
    .io_wPort_0_data_0(nbufFF_io_wPort_0_data_0),
    .io_wPort_0_reset(nbufFF_io_wPort_0_reset),
    .io_wPort_0_en_0(nbufFF_io_wPort_0_en_0),
    .io_sEn_0(nbufFF_io_sEn_0),
    .io_sEn_1(nbufFF_io_sEn_1),
    .io_sDone_0(nbufFF_io_sDone_0),
    .io_sDone_1(nbufFF_io_sDone_1)
  );
  assign io_rPort_0_output_0 = nbufFF_io_rPort_0_output_0; // @[NBuffers.scala 274:6:@5974.4]
  assign nbufFF_clock = clock; // @[:@5953.4]
  assign nbufFF_reset = reset; // @[:@5954.4]
  assign nbufFF_io_wPort_0_data_0 = io_wPort_0_data_0; // @[NBuffers.scala 274:6:@5971.4]
  assign nbufFF_io_wPort_0_reset = io_wPort_0_reset; // @[NBuffers.scala 274:6:@5970.4]
  assign nbufFF_io_wPort_0_en_0 = io_wPort_0_en_0; // @[NBuffers.scala 274:6:@5967.4]
  assign nbufFF_io_sEn_0 = io_sEn_0; // @[NBuffers.scala 274:6:@5957.4]
  assign nbufFF_io_sEn_1 = io_sEn_1; // @[NBuffers.scala 274:6:@5958.4]
  assign nbufFF_io_sDone_0 = io_sDone_0; // @[NBuffers.scala 274:6:@5955.4]
  assign nbufFF_io_sDone_1 = io_sDone_1; // @[NBuffers.scala 274:6:@5956.4]
endmodule
module bbox_FF_14( // @[:@6741.2]
  input   clock, // @[:@6742.4]
  input   reset, // @[:@6743.4]
  output  io_rPort_0_output_0, // @[:@6744.4]
  input   io_wPort_0_data_0, // @[:@6744.4]
  input   io_wPort_0_reset, // @[:@6744.4]
  input   io_wPort_0_en_0 // @[:@6744.4]
);
  reg  ff; // @[MemPrimitives.scala 173:19:@6759.4]
  reg [31:0] _RAND_0;
  wire  _T_68; // @[MemPrimitives.scala 177:32:@6761.4]
  wire  _T_69; // @[MemPrimitives.scala 177:12:@6762.4]
  assign _T_68 = io_wPort_0_en_0 ? io_wPort_0_data_0 : ff; // @[MemPrimitives.scala 177:32:@6761.4]
  assign _T_69 = io_wPort_0_reset ? 1'h0 : _T_68; // @[MemPrimitives.scala 177:12:@6762.4]
  assign io_rPort_0_output_0 = ff; // @[MemPrimitives.scala 178:34:@6764.4]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  ff = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      ff <= 1'h0;
    end else begin
      if (io_wPort_0_reset) begin
        ff <= 1'h0;
      end else begin
        if (io_wPort_0_en_0) begin
          ff <= io_wPort_0_data_0;
        end
      end
    end
  end
endmodule
module bbox_NBuf_1( // @[:@6791.2]
  input   clock, // @[:@6792.4]
  input   reset, // @[:@6793.4]
  output  io_rPort_0_output_0, // @[:@6794.4]
  input   io_wPort_0_data_0, // @[:@6794.4]
  input   io_wPort_0_reset, // @[:@6794.4]
  input   io_wPort_0_en_0, // @[:@6794.4]
  input   io_sEn_0, // @[:@6794.4]
  input   io_sEn_1, // @[:@6794.4]
  input   io_sDone_0, // @[:@6794.4]
  input   io_sDone_1 // @[:@6794.4]
);
  wire  ctrl_clock; // @[NBuffers.scala 83:20:@6802.4]
  wire  ctrl_reset; // @[NBuffers.scala 83:20:@6802.4]
  wire  ctrl_io_sEn_0; // @[NBuffers.scala 83:20:@6802.4]
  wire  ctrl_io_sEn_1; // @[NBuffers.scala 83:20:@6802.4]
  wire  ctrl_io_sDone_0; // @[NBuffers.scala 83:20:@6802.4]
  wire  ctrl_io_sDone_1; // @[NBuffers.scala 83:20:@6802.4]
  wire [2:0] ctrl_io_statesInW_0; // @[NBuffers.scala 83:20:@6802.4]
  wire [2:0] ctrl_io_statesInR_1; // @[NBuffers.scala 83:20:@6802.4]
  wire  FF_clock; // @[NBuffers.scala 121:23:@6809.4]
  wire  FF_reset; // @[NBuffers.scala 121:23:@6809.4]
  wire  FF_io_rPort_0_output_0; // @[NBuffers.scala 121:23:@6809.4]
  wire  FF_io_wPort_0_data_0; // @[NBuffers.scala 121:23:@6809.4]
  wire  FF_io_wPort_0_reset; // @[NBuffers.scala 121:23:@6809.4]
  wire  FF_io_wPort_0_en_0; // @[NBuffers.scala 121:23:@6809.4]
  wire  FF_1_clock; // @[NBuffers.scala 121:23:@6825.4]
  wire  FF_1_reset; // @[NBuffers.scala 121:23:@6825.4]
  wire  FF_1_io_rPort_0_output_0; // @[NBuffers.scala 121:23:@6825.4]
  wire  FF_1_io_wPort_0_data_0; // @[NBuffers.scala 121:23:@6825.4]
  wire  FF_1_io_wPort_0_reset; // @[NBuffers.scala 121:23:@6825.4]
  wire  FF_1_io_wPort_0_en_0; // @[NBuffers.scala 121:23:@6825.4]
  wire  _T_102; // @[NBuffers.scala 128:105:@6843.4]
  wire  _T_106; // @[NBuffers.scala 132:92:@6853.4]
  wire  _T_109; // @[NBuffers.scala 128:105:@6859.4]
  wire  _T_113; // @[NBuffers.scala 132:92:@6869.4]
  wire  _T_121; // @[Mux.scala 19:72:@6877.4]
  wire  _T_123; // @[Mux.scala 19:72:@6878.4]
  bbox_NBufController ctrl ( // @[NBuffers.scala 83:20:@6802.4]
    .clock(ctrl_clock),
    .reset(ctrl_reset),
    .io_sEn_0(ctrl_io_sEn_0),
    .io_sEn_1(ctrl_io_sEn_1),
    .io_sDone_0(ctrl_io_sDone_0),
    .io_sDone_1(ctrl_io_sDone_1),
    .io_statesInW_0(ctrl_io_statesInW_0),
    .io_statesInR_1(ctrl_io_statesInR_1)
  );
  bbox_FF_14 FF ( // @[NBuffers.scala 121:23:@6809.4]
    .clock(FF_clock),
    .reset(FF_reset),
    .io_rPort_0_output_0(FF_io_rPort_0_output_0),
    .io_wPort_0_data_0(FF_io_wPort_0_data_0),
    .io_wPort_0_reset(FF_io_wPort_0_reset),
    .io_wPort_0_en_0(FF_io_wPort_0_en_0)
  );
  bbox_FF_14 FF_1 ( // @[NBuffers.scala 121:23:@6825.4]
    .clock(FF_1_clock),
    .reset(FF_1_reset),
    .io_rPort_0_output_0(FF_1_io_rPort_0_output_0),
    .io_wPort_0_data_0(FF_1_io_wPort_0_data_0),
    .io_wPort_0_reset(FF_1_io_wPort_0_reset),
    .io_wPort_0_en_0(FF_1_io_wPort_0_en_0)
  );
  assign _T_102 = ctrl_io_statesInW_0 == 3'h0; // @[NBuffers.scala 128:105:@6843.4]
  assign _T_106 = ctrl_io_statesInR_1 == 3'h0; // @[NBuffers.scala 132:92:@6853.4]
  assign _T_109 = ctrl_io_statesInW_0 == 3'h1; // @[NBuffers.scala 128:105:@6859.4]
  assign _T_113 = ctrl_io_statesInR_1 == 3'h1; // @[NBuffers.scala 132:92:@6869.4]
  assign _T_121 = _T_106 ? FF_io_rPort_0_output_0 : 1'h0; // @[Mux.scala 19:72:@6877.4]
  assign _T_123 = _T_113 ? FF_1_io_rPort_0_output_0 : 1'h0; // @[Mux.scala 19:72:@6878.4]
  assign io_rPort_0_output_0 = _T_121 | _T_123; // @[NBuffers.scala 138:66:@6882.4]
  assign ctrl_clock = clock; // @[:@6803.4]
  assign ctrl_reset = reset; // @[:@6804.4]
  assign ctrl_io_sEn_0 = io_sEn_0; // @[NBuffers.scala 85:20:@6805.4]
  assign ctrl_io_sEn_1 = io_sEn_1; // @[NBuffers.scala 85:20:@6807.4]
  assign ctrl_io_sDone_0 = io_sDone_0; // @[NBuffers.scala 86:22:@6806.4]
  assign ctrl_io_sDone_1 = io_sDone_1; // @[NBuffers.scala 86:22:@6808.4]
  assign FF_clock = clock; // @[:@6810.4]
  assign FF_reset = reset; // @[:@6811.4]
  assign FF_io_wPort_0_data_0 = io_wPort_0_data_0; // @[MemPrimitives.scala 33:29:@6846.4]
  assign FF_io_wPort_0_reset = io_wPort_0_reset; // @[MemPrimitives.scala 34:29:@6847.4]
  assign FF_io_wPort_0_en_0 = io_wPort_0_en_0 & _T_102; // @[MemPrimitives.scala 37:29:@6852.4]
  assign FF_1_clock = clock; // @[:@6826.4]
  assign FF_1_reset = reset; // @[:@6827.4]
  assign FF_1_io_wPort_0_data_0 = io_wPort_0_data_0; // @[MemPrimitives.scala 33:29:@6862.4]
  assign FF_1_io_wPort_0_reset = io_wPort_0_reset; // @[MemPrimitives.scala 34:29:@6863.4]
  assign FF_1_io_wPort_0_en_0 = io_wPort_0_en_0 & _T_109; // @[MemPrimitives.scala 37:29:@6868.4]
endmodule
module bbox_b87_chain( // @[:@6884.2]
  input   clock, // @[:@6885.4]
  input   reset, // @[:@6886.4]
  output  io_rPort_0_output_0, // @[:@6887.4]
  input   io_wPort_0_data_0, // @[:@6887.4]
  input   io_wPort_0_reset, // @[:@6887.4]
  input   io_wPort_0_en_0, // @[:@6887.4]
  input   io_sEn_0, // @[:@6887.4]
  input   io_sEn_1, // @[:@6887.4]
  input   io_sDone_0, // @[:@6887.4]
  input   io_sDone_1 // @[:@6887.4]
);
  wire  nbufFF_clock; // @[NBuffers.scala 273:22:@6895.4]
  wire  nbufFF_reset; // @[NBuffers.scala 273:22:@6895.4]
  wire  nbufFF_io_rPort_0_output_0; // @[NBuffers.scala 273:22:@6895.4]
  wire  nbufFF_io_wPort_0_data_0; // @[NBuffers.scala 273:22:@6895.4]
  wire  nbufFF_io_wPort_0_reset; // @[NBuffers.scala 273:22:@6895.4]
  wire  nbufFF_io_wPort_0_en_0; // @[NBuffers.scala 273:22:@6895.4]
  wire  nbufFF_io_sEn_0; // @[NBuffers.scala 273:22:@6895.4]
  wire  nbufFF_io_sEn_1; // @[NBuffers.scala 273:22:@6895.4]
  wire  nbufFF_io_sDone_0; // @[NBuffers.scala 273:22:@6895.4]
  wire  nbufFF_io_sDone_1; // @[NBuffers.scala 273:22:@6895.4]
  bbox_NBuf_1 nbufFF ( // @[NBuffers.scala 273:22:@6895.4]
    .clock(nbufFF_clock),
    .reset(nbufFF_reset),
    .io_rPort_0_output_0(nbufFF_io_rPort_0_output_0),
    .io_wPort_0_data_0(nbufFF_io_wPort_0_data_0),
    .io_wPort_0_reset(nbufFF_io_wPort_0_reset),
    .io_wPort_0_en_0(nbufFF_io_wPort_0_en_0),
    .io_sEn_0(nbufFF_io_sEn_0),
    .io_sEn_1(nbufFF_io_sEn_1),
    .io_sDone_0(nbufFF_io_sDone_0),
    .io_sDone_1(nbufFF_io_sDone_1)
  );
  assign io_rPort_0_output_0 = nbufFF_io_rPort_0_output_0; // @[NBuffers.scala 274:6:@6917.4]
  assign nbufFF_clock = clock; // @[:@6896.4]
  assign nbufFF_reset = reset; // @[:@6897.4]
  assign nbufFF_io_wPort_0_data_0 = io_wPort_0_data_0; // @[NBuffers.scala 274:6:@6914.4]
  assign nbufFF_io_wPort_0_reset = io_wPort_0_reset; // @[NBuffers.scala 274:6:@6913.4]
  assign nbufFF_io_wPort_0_en_0 = io_wPort_0_en_0; // @[NBuffers.scala 274:6:@6910.4]
  assign nbufFF_io_sEn_0 = io_sEn_0; // @[NBuffers.scala 274:6:@6900.4]
  assign nbufFF_io_sEn_1 = io_sEn_1; // @[NBuffers.scala 274:6:@6901.4]
  assign nbufFF_io_sDone_0 = io_sDone_0; // @[NBuffers.scala 274:6:@6898.4]
  assign nbufFF_io_sDone_1 = io_sDone_1; // @[NBuffers.scala 274:6:@6899.4]
endmodule
module bbox_FF_16( // @[:@7646.2]
  input         clock, // @[:@7647.4]
  input         reset, // @[:@7648.4]
  output [31:0] io_rPort_0_output_0, // @[:@7649.4]
  input  [31:0] io_wPort_0_data_0, // @[:@7649.4]
  input         io_wPort_0_reset, // @[:@7649.4]
  input         io_wPort_0_en_0, // @[:@7649.4]
  input         io_reset // @[:@7649.4]
);
  reg [31:0] ff; // @[MemPrimitives.scala 173:19:@7665.4]
  reg [31:0] _RAND_0;
  wire  anyReset; // @[MemPrimitives.scala 174:65:@7666.4]
  wire [31:0] _T_69; // @[MemPrimitives.scala 177:32:@7667.4]
  wire [31:0] _T_70; // @[MemPrimitives.scala 177:12:@7668.4]
  assign anyReset = io_wPort_0_reset | io_reset; // @[MemPrimitives.scala 174:65:@7666.4]
  assign _T_69 = io_wPort_0_en_0 ? io_wPort_0_data_0 : ff; // @[MemPrimitives.scala 177:32:@7667.4]
  assign _T_70 = anyReset ? 32'h0 : _T_69; // @[MemPrimitives.scala 177:12:@7668.4]
  assign io_rPort_0_output_0 = ff; // @[MemPrimitives.scala 178:34:@7670.4]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  ff = _RAND_0[31:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      ff <= 32'h0;
    end else begin
      if (anyReset) begin
        ff <= 32'h0;
      end else begin
        if (io_wPort_0_en_0) begin
          ff <= io_wPort_0_data_0;
        end
      end
    end
  end
endmodule
module bbox_x88_reg( // @[:@7698.2]
  input         clock, // @[:@7699.4]
  input         reset, // @[:@7700.4]
  output [31:0] io_rPort_0_output_0, // @[:@7701.4]
  input  [31:0] io_wPort_0_data_0, // @[:@7701.4]
  input         io_wPort_0_reset, // @[:@7701.4]
  input         io_wPort_0_en_0, // @[:@7701.4]
  input         io_sEn_0, // @[:@7701.4]
  input         io_sEn_1, // @[:@7701.4]
  input         io_sDone_0, // @[:@7701.4]
  input         io_sDone_1 // @[:@7701.4]
);
  wire  ctrl_clock; // @[NBuffers.scala 83:20:@7710.4]
  wire  ctrl_reset; // @[NBuffers.scala 83:20:@7710.4]
  wire  ctrl_io_sEn_0; // @[NBuffers.scala 83:20:@7710.4]
  wire  ctrl_io_sEn_1; // @[NBuffers.scala 83:20:@7710.4]
  wire  ctrl_io_sDone_0; // @[NBuffers.scala 83:20:@7710.4]
  wire  ctrl_io_sDone_1; // @[NBuffers.scala 83:20:@7710.4]
  wire [2:0] ctrl_io_statesInW_0; // @[NBuffers.scala 83:20:@7710.4]
  wire [2:0] ctrl_io_statesInR_1; // @[NBuffers.scala 83:20:@7710.4]
  wire  FF_clock; // @[NBuffers.scala 121:23:@7717.4]
  wire  FF_reset; // @[NBuffers.scala 121:23:@7717.4]
  wire [31:0] FF_io_rPort_0_output_0; // @[NBuffers.scala 121:23:@7717.4]
  wire [31:0] FF_io_wPort_0_data_0; // @[NBuffers.scala 121:23:@7717.4]
  wire  FF_io_wPort_0_reset; // @[NBuffers.scala 121:23:@7717.4]
  wire  FF_io_wPort_0_en_0; // @[NBuffers.scala 121:23:@7717.4]
  wire  FF_io_reset; // @[NBuffers.scala 121:23:@7717.4]
  wire  FF_1_clock; // @[NBuffers.scala 121:23:@7733.4]
  wire  FF_1_reset; // @[NBuffers.scala 121:23:@7733.4]
  wire [31:0] FF_1_io_rPort_0_output_0; // @[NBuffers.scala 121:23:@7733.4]
  wire [31:0] FF_1_io_wPort_0_data_0; // @[NBuffers.scala 121:23:@7733.4]
  wire  FF_1_io_wPort_0_reset; // @[NBuffers.scala 121:23:@7733.4]
  wire  FF_1_io_wPort_0_en_0; // @[NBuffers.scala 121:23:@7733.4]
  wire  FF_1_io_reset; // @[NBuffers.scala 121:23:@7733.4]
  wire  _T_102; // @[NBuffers.scala 128:105:@7751.4]
  wire  _T_106; // @[NBuffers.scala 132:92:@7761.4]
  wire  _T_109; // @[NBuffers.scala 128:105:@7767.4]
  wire  _T_113; // @[NBuffers.scala 132:92:@7777.4]
  wire [31:0] _T_121; // @[Mux.scala 19:72:@7785.4]
  wire [31:0] _T_123; // @[Mux.scala 19:72:@7786.4]
  bbox_NBufController ctrl ( // @[NBuffers.scala 83:20:@7710.4]
    .clock(ctrl_clock),
    .reset(ctrl_reset),
    .io_sEn_0(ctrl_io_sEn_0),
    .io_sEn_1(ctrl_io_sEn_1),
    .io_sDone_0(ctrl_io_sDone_0),
    .io_sDone_1(ctrl_io_sDone_1),
    .io_statesInW_0(ctrl_io_statesInW_0),
    .io_statesInR_1(ctrl_io_statesInR_1)
  );
  bbox_FF_16 FF ( // @[NBuffers.scala 121:23:@7717.4]
    .clock(FF_clock),
    .reset(FF_reset),
    .io_rPort_0_output_0(FF_io_rPort_0_output_0),
    .io_wPort_0_data_0(FF_io_wPort_0_data_0),
    .io_wPort_0_reset(FF_io_wPort_0_reset),
    .io_wPort_0_en_0(FF_io_wPort_0_en_0),
    .io_reset(FF_io_reset)
  );
  bbox_FF_16 FF_1 ( // @[NBuffers.scala 121:23:@7733.4]
    .clock(FF_1_clock),
    .reset(FF_1_reset),
    .io_rPort_0_output_0(FF_1_io_rPort_0_output_0),
    .io_wPort_0_data_0(FF_1_io_wPort_0_data_0),
    .io_wPort_0_reset(FF_1_io_wPort_0_reset),
    .io_wPort_0_en_0(FF_1_io_wPort_0_en_0),
    .io_reset(FF_1_io_reset)
  );
  assign _T_102 = ctrl_io_statesInW_0 == 3'h0; // @[NBuffers.scala 128:105:@7751.4]
  assign _T_106 = ctrl_io_statesInR_1 == 3'h0; // @[NBuffers.scala 132:92:@7761.4]
  assign _T_109 = ctrl_io_statesInW_0 == 3'h1; // @[NBuffers.scala 128:105:@7767.4]
  assign _T_113 = ctrl_io_statesInR_1 == 3'h1; // @[NBuffers.scala 132:92:@7777.4]
  assign _T_121 = _T_106 ? FF_io_rPort_0_output_0 : 32'h0; // @[Mux.scala 19:72:@7785.4]
  assign _T_123 = _T_113 ? FF_1_io_rPort_0_output_0 : 32'h0; // @[Mux.scala 19:72:@7786.4]
  assign io_rPort_0_output_0 = _T_121 | _T_123; // @[NBuffers.scala 138:66:@7790.4]
  assign ctrl_clock = clock; // @[:@7711.4]
  assign ctrl_reset = reset; // @[:@7712.4]
  assign ctrl_io_sEn_0 = io_sEn_0; // @[NBuffers.scala 85:20:@7713.4]
  assign ctrl_io_sEn_1 = io_sEn_1; // @[NBuffers.scala 85:20:@7715.4]
  assign ctrl_io_sDone_0 = io_sDone_0; // @[NBuffers.scala 86:22:@7714.4]
  assign ctrl_io_sDone_1 = io_sDone_1; // @[NBuffers.scala 86:22:@7716.4]
  assign FF_clock = clock; // @[:@7718.4]
  assign FF_reset = reset; // @[:@7719.4]
  assign FF_io_wPort_0_data_0 = io_wPort_0_data_0; // @[MemPrimitives.scala 33:29:@7754.4]
  assign FF_io_wPort_0_reset = io_wPort_0_reset; // @[MemPrimitives.scala 34:29:@7755.4]
  assign FF_io_wPort_0_en_0 = io_wPort_0_en_0 & _T_102; // @[MemPrimitives.scala 37:29:@7760.4]
  assign FF_io_reset = 1'h0; // @[NBuffers.scala 125:30:@7749.4]
  assign FF_1_clock = clock; // @[:@7734.4]
  assign FF_1_reset = reset; // @[:@7735.4]
  assign FF_1_io_wPort_0_data_0 = io_wPort_0_data_0; // @[MemPrimitives.scala 33:29:@7770.4]
  assign FF_1_io_wPort_0_reset = io_wPort_0_reset; // @[MemPrimitives.scala 34:29:@7771.4]
  assign FF_1_io_wPort_0_en_0 = io_wPort_0_en_0 & _T_109; // @[MemPrimitives.scala 37:29:@7776.4]
  assign FF_1_io_reset = 1'h0; // @[NBuffers.scala 125:30:@7750.4]
endmodule
module bbox_FF_18( // @[:@8483.2]
  input         clock, // @[:@8484.4]
  input         reset, // @[:@8485.4]
  output [15:0] io_rPort_0_output_0, // @[:@8486.4]
  input  [15:0] io_wPort_0_data_0, // @[:@8486.4]
  input         io_wPort_0_reset, // @[:@8486.4]
  input         io_wPort_0_en_0 // @[:@8486.4]
);
  reg [15:0] ff; // @[MemPrimitives.scala 173:19:@8502.4]
  reg [31:0] _RAND_0;
  wire [15:0] _T_69; // @[MemPrimitives.scala 177:32:@8504.4]
  wire [15:0] _T_70; // @[MemPrimitives.scala 177:12:@8505.4]
  assign _T_69 = io_wPort_0_en_0 ? io_wPort_0_data_0 : ff; // @[MemPrimitives.scala 177:32:@8504.4]
  assign _T_70 = io_wPort_0_reset ? 16'h0 : _T_69; // @[MemPrimitives.scala 177:12:@8505.4]
  assign io_rPort_0_output_0 = ff; // @[MemPrimitives.scala 178:34:@8507.4]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  ff = _RAND_0[15:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      ff <= 16'h0;
    end else begin
      if (io_wPort_0_reset) begin
        ff <= 16'h0;
      end else begin
        if (io_wPort_0_en_0) begin
          ff <= io_wPort_0_data_0;
        end
      end
    end
  end
endmodule
module bbox_x89_reg( // @[:@8535.2]
  input         clock, // @[:@8536.4]
  input         reset, // @[:@8537.4]
  output [15:0] io_rPort_0_output_0, // @[:@8538.4]
  input  [15:0] io_wPort_0_data_0, // @[:@8538.4]
  input         io_wPort_0_reset, // @[:@8538.4]
  input         io_wPort_0_en_0, // @[:@8538.4]
  input         io_sEn_0, // @[:@8538.4]
  input         io_sEn_1, // @[:@8538.4]
  input         io_sDone_0, // @[:@8538.4]
  input         io_sDone_1 // @[:@8538.4]
);
  wire  ctrl_clock; // @[NBuffers.scala 83:20:@8547.4]
  wire  ctrl_reset; // @[NBuffers.scala 83:20:@8547.4]
  wire  ctrl_io_sEn_0; // @[NBuffers.scala 83:20:@8547.4]
  wire  ctrl_io_sEn_1; // @[NBuffers.scala 83:20:@8547.4]
  wire  ctrl_io_sDone_0; // @[NBuffers.scala 83:20:@8547.4]
  wire  ctrl_io_sDone_1; // @[NBuffers.scala 83:20:@8547.4]
  wire [2:0] ctrl_io_statesInW_0; // @[NBuffers.scala 83:20:@8547.4]
  wire [2:0] ctrl_io_statesInR_1; // @[NBuffers.scala 83:20:@8547.4]
  wire  FF_clock; // @[NBuffers.scala 121:23:@8554.4]
  wire  FF_reset; // @[NBuffers.scala 121:23:@8554.4]
  wire [15:0] FF_io_rPort_0_output_0; // @[NBuffers.scala 121:23:@8554.4]
  wire [15:0] FF_io_wPort_0_data_0; // @[NBuffers.scala 121:23:@8554.4]
  wire  FF_io_wPort_0_reset; // @[NBuffers.scala 121:23:@8554.4]
  wire  FF_io_wPort_0_en_0; // @[NBuffers.scala 121:23:@8554.4]
  wire  FF_1_clock; // @[NBuffers.scala 121:23:@8570.4]
  wire  FF_1_reset; // @[NBuffers.scala 121:23:@8570.4]
  wire [15:0] FF_1_io_rPort_0_output_0; // @[NBuffers.scala 121:23:@8570.4]
  wire [15:0] FF_1_io_wPort_0_data_0; // @[NBuffers.scala 121:23:@8570.4]
  wire  FF_1_io_wPort_0_reset; // @[NBuffers.scala 121:23:@8570.4]
  wire  FF_1_io_wPort_0_en_0; // @[NBuffers.scala 121:23:@8570.4]
  wire  _T_102; // @[NBuffers.scala 128:105:@8588.4]
  wire  _T_106; // @[NBuffers.scala 132:92:@8598.4]
  wire  _T_109; // @[NBuffers.scala 128:105:@8604.4]
  wire  _T_113; // @[NBuffers.scala 132:92:@8614.4]
  wire [15:0] _T_121; // @[Mux.scala 19:72:@8622.4]
  wire [15:0] _T_123; // @[Mux.scala 19:72:@8623.4]
  bbox_NBufController ctrl ( // @[NBuffers.scala 83:20:@8547.4]
    .clock(ctrl_clock),
    .reset(ctrl_reset),
    .io_sEn_0(ctrl_io_sEn_0),
    .io_sEn_1(ctrl_io_sEn_1),
    .io_sDone_0(ctrl_io_sDone_0),
    .io_sDone_1(ctrl_io_sDone_1),
    .io_statesInW_0(ctrl_io_statesInW_0),
    .io_statesInR_1(ctrl_io_statesInR_1)
  );
  bbox_FF_18 FF ( // @[NBuffers.scala 121:23:@8554.4]
    .clock(FF_clock),
    .reset(FF_reset),
    .io_rPort_0_output_0(FF_io_rPort_0_output_0),
    .io_wPort_0_data_0(FF_io_wPort_0_data_0),
    .io_wPort_0_reset(FF_io_wPort_0_reset),
    .io_wPort_0_en_0(FF_io_wPort_0_en_0)
  );
  bbox_FF_18 FF_1 ( // @[NBuffers.scala 121:23:@8570.4]
    .clock(FF_1_clock),
    .reset(FF_1_reset),
    .io_rPort_0_output_0(FF_1_io_rPort_0_output_0),
    .io_wPort_0_data_0(FF_1_io_wPort_0_data_0),
    .io_wPort_0_reset(FF_1_io_wPort_0_reset),
    .io_wPort_0_en_0(FF_1_io_wPort_0_en_0)
  );
  assign _T_102 = ctrl_io_statesInW_0 == 3'h0; // @[NBuffers.scala 128:105:@8588.4]
  assign _T_106 = ctrl_io_statesInR_1 == 3'h0; // @[NBuffers.scala 132:92:@8598.4]
  assign _T_109 = ctrl_io_statesInW_0 == 3'h1; // @[NBuffers.scala 128:105:@8604.4]
  assign _T_113 = ctrl_io_statesInR_1 == 3'h1; // @[NBuffers.scala 132:92:@8614.4]
  assign _T_121 = _T_106 ? FF_io_rPort_0_output_0 : 16'h0; // @[Mux.scala 19:72:@8622.4]
  assign _T_123 = _T_113 ? FF_1_io_rPort_0_output_0 : 16'h0; // @[Mux.scala 19:72:@8623.4]
  assign io_rPort_0_output_0 = _T_121 | _T_123; // @[NBuffers.scala 138:66:@8627.4]
  assign ctrl_clock = clock; // @[:@8548.4]
  assign ctrl_reset = reset; // @[:@8549.4]
  assign ctrl_io_sEn_0 = io_sEn_0; // @[NBuffers.scala 85:20:@8550.4]
  assign ctrl_io_sEn_1 = io_sEn_1; // @[NBuffers.scala 85:20:@8552.4]
  assign ctrl_io_sDone_0 = io_sDone_0; // @[NBuffers.scala 86:22:@8551.4]
  assign ctrl_io_sDone_1 = io_sDone_1; // @[NBuffers.scala 86:22:@8553.4]
  assign FF_clock = clock; // @[:@8555.4]
  assign FF_reset = reset; // @[:@8556.4]
  assign FF_io_wPort_0_data_0 = io_wPort_0_data_0; // @[MemPrimitives.scala 33:29:@8591.4]
  assign FF_io_wPort_0_reset = io_wPort_0_reset; // @[MemPrimitives.scala 34:29:@8592.4]
  assign FF_io_wPort_0_en_0 = io_wPort_0_en_0 & _T_102; // @[MemPrimitives.scala 37:29:@8597.4]
  assign FF_1_clock = clock; // @[:@8571.4]
  assign FF_1_reset = reset; // @[:@8572.4]
  assign FF_1_io_wPort_0_data_0 = io_wPort_0_data_0; // @[MemPrimitives.scala 33:29:@8607.4]
  assign FF_1_io_wPort_0_reset = io_wPort_0_reset; // @[MemPrimitives.scala 34:29:@8608.4]
  assign FF_1_io_wPort_0_en_0 = io_wPort_0_en_0 & _T_109; // @[MemPrimitives.scala 37:29:@8613.4]
endmodule
module bbox_RetimeWrapper_95( // @[:@9504.2]
  input   clock, // @[:@9505.4]
  input   reset, // @[:@9506.4]
  input   io_flow, // @[:@9507.4]
  input   io_in, // @[:@9507.4]
  output  io_out // @[:@9507.4]
);
  wire  sr_out; // @[RetimeShiftRegister.scala 15:20:@9509.4]
  wire  sr_in; // @[RetimeShiftRegister.scala 15:20:@9509.4]
  wire  sr_init; // @[RetimeShiftRegister.scala 15:20:@9509.4]
  wire  sr_flow; // @[RetimeShiftRegister.scala 15:20:@9509.4]
  wire  sr_reset; // @[RetimeShiftRegister.scala 15:20:@9509.4]
  wire  sr_clock; // @[RetimeShiftRegister.scala 15:20:@9509.4]
  RetimeShiftRegister #(.WIDTH(1), .STAGES(3)) sr ( // @[RetimeShiftRegister.scala 15:20:@9509.4]
    .out(sr_out),
    .in(sr_in),
    .init(sr_init),
    .flow(sr_flow),
    .reset(sr_reset),
    .clock(sr_clock)
  );
  assign io_out = sr_out; // @[RetimeShiftRegister.scala 21:12:@9522.4]
  assign sr_in = io_in; // @[RetimeShiftRegister.scala 20:14:@9521.4]
  assign sr_init = 1'h0; // @[RetimeShiftRegister.scala 19:16:@9520.4]
  assign sr_flow = io_flow; // @[RetimeShiftRegister.scala 18:16:@9519.4]
  assign sr_reset = reset; // @[RetimeShiftRegister.scala 17:17:@9518.4]
  assign sr_clock = clock; // @[RetimeShiftRegister.scala 16:17:@9516.4]
endmodule
module bbox_RetimeWrapper_99( // @[:@9632.2]
  input   clock, // @[:@9633.4]
  input   reset, // @[:@9634.4]
  input   io_in, // @[:@9635.4]
  output  io_out // @[:@9635.4]
);
  wire  sr_out; // @[RetimeShiftRegister.scala 15:20:@9637.4]
  wire  sr_in; // @[RetimeShiftRegister.scala 15:20:@9637.4]
  wire  sr_init; // @[RetimeShiftRegister.scala 15:20:@9637.4]
  wire  sr_flow; // @[RetimeShiftRegister.scala 15:20:@9637.4]
  wire  sr_reset; // @[RetimeShiftRegister.scala 15:20:@9637.4]
  wire  sr_clock; // @[RetimeShiftRegister.scala 15:20:@9637.4]
  RetimeShiftRegister #(.WIDTH(1), .STAGES(2)) sr ( // @[RetimeShiftRegister.scala 15:20:@9637.4]
    .out(sr_out),
    .in(sr_in),
    .init(sr_init),
    .flow(sr_flow),
    .reset(sr_reset),
    .clock(sr_clock)
  );
  assign io_out = sr_out; // @[RetimeShiftRegister.scala 21:12:@9650.4]
  assign sr_in = io_in; // @[RetimeShiftRegister.scala 20:14:@9649.4]
  assign sr_init = 1'h0; // @[RetimeShiftRegister.scala 19:16:@9648.4]
  assign sr_flow = 1'h1; // @[RetimeShiftRegister.scala 18:16:@9647.4]
  assign sr_reset = reset; // @[RetimeShiftRegister.scala 17:17:@9646.4]
  assign sr_clock = clock; // @[RetimeShiftRegister.scala 16:17:@9644.4]
endmodule
module bbox_x99_inr_UnitPipe_sm( // @[:@9652.2]
  input   clock, // @[:@9653.4]
  input   reset, // @[:@9654.4]
  input   io_enable, // @[:@9655.4]
  output  io_done, // @[:@9655.4]
  output  io_doneLatch, // @[:@9655.4]
  input   io_ctrDone, // @[:@9655.4]
  output  io_datapathEn, // @[:@9655.4]
  output  io_ctrInc, // @[:@9655.4]
  input   io_parentAck, // @[:@9655.4]
  input   io_backpressure, // @[:@9655.4]
  input   io_break // @[:@9655.4]
);
  wire  active_clock; // @[Controllers.scala 261:22:@9657.4]
  wire  active_reset; // @[Controllers.scala 261:22:@9657.4]
  wire  active_io_input_set; // @[Controllers.scala 261:22:@9657.4]
  wire  active_io_input_reset; // @[Controllers.scala 261:22:@9657.4]
  wire  active_io_input_asyn_reset; // @[Controllers.scala 261:22:@9657.4]
  wire  active_io_output; // @[Controllers.scala 261:22:@9657.4]
  wire  done_clock; // @[Controllers.scala 262:20:@9660.4]
  wire  done_reset; // @[Controllers.scala 262:20:@9660.4]
  wire  done_io_input_set; // @[Controllers.scala 262:20:@9660.4]
  wire  done_io_input_reset; // @[Controllers.scala 262:20:@9660.4]
  wire  done_io_input_asyn_reset; // @[Controllers.scala 262:20:@9660.4]
  wire  done_io_output; // @[Controllers.scala 262:20:@9660.4]
  wire  RetimeWrapper_clock; // @[package.scala 93:22:@9694.4]
  wire  RetimeWrapper_reset; // @[package.scala 93:22:@9694.4]
  wire  RetimeWrapper_io_flow; // @[package.scala 93:22:@9694.4]
  wire  RetimeWrapper_io_in; // @[package.scala 93:22:@9694.4]
  wire  RetimeWrapper_io_out; // @[package.scala 93:22:@9694.4]
  wire  RetimeWrapper_1_clock; // @[package.scala 93:22:@9716.4]
  wire  RetimeWrapper_1_reset; // @[package.scala 93:22:@9716.4]
  wire  RetimeWrapper_1_io_flow; // @[package.scala 93:22:@9716.4]
  wire  RetimeWrapper_1_io_in; // @[package.scala 93:22:@9716.4]
  wire  RetimeWrapper_1_io_out; // @[package.scala 93:22:@9716.4]
  wire  RetimeWrapper_2_clock; // @[package.scala 93:22:@9728.4]
  wire  RetimeWrapper_2_reset; // @[package.scala 93:22:@9728.4]
  wire  RetimeWrapper_2_io_flow; // @[package.scala 93:22:@9728.4]
  wire  RetimeWrapper_2_io_in; // @[package.scala 93:22:@9728.4]
  wire  RetimeWrapper_2_io_out; // @[package.scala 93:22:@9728.4]
  wire  RetimeWrapper_3_clock; // @[package.scala 93:22:@9736.4]
  wire  RetimeWrapper_3_reset; // @[package.scala 93:22:@9736.4]
  wire  RetimeWrapper_3_io_flow; // @[package.scala 93:22:@9736.4]
  wire  RetimeWrapper_3_io_in; // @[package.scala 93:22:@9736.4]
  wire  RetimeWrapper_3_io_out; // @[package.scala 93:22:@9736.4]
  wire  RetimeWrapper_4_clock; // @[package.scala 93:22:@9752.4]
  wire  RetimeWrapper_4_reset; // @[package.scala 93:22:@9752.4]
  wire  RetimeWrapper_4_io_in; // @[package.scala 93:22:@9752.4]
  wire  RetimeWrapper_4_io_out; // @[package.scala 93:22:@9752.4]
  wire  _T_80; // @[Controllers.scala 264:48:@9665.4]
  wire  _T_81; // @[Controllers.scala 264:46:@9666.4]
  wire  _T_82; // @[Controllers.scala 264:62:@9667.4]
  wire  _T_100; // @[package.scala 100:49:@9685.4]
  reg  _T_103; // @[package.scala 48:56:@9686.4]
  reg [31:0] _RAND_0;
  wire  _T_118; // @[Controllers.scala 283:41:@9709.4]
  wire  _T_124; // @[package.scala 96:25:@9721.4 package.scala 96:25:@9722.4]
  wire  _T_126; // @[package.scala 100:49:@9723.4]
  reg  _T_129; // @[package.scala 48:56:@9724.4]
  reg [31:0] _RAND_1;
  reg  _T_146; // @[Controllers.scala 291:31:@9746.4]
  reg [31:0] _RAND_2;
  wire  _T_150; // @[package.scala 100:49:@9748.4]
  reg  _T_153; // @[package.scala 48:56:@9749.4]
  reg [31:0] _RAND_3;
  wire  _T_156; // @[package.scala 96:25:@9757.4 package.scala 96:25:@9758.4]
  wire  _T_158; // @[Controllers.scala 292:61:@9759.4]
  wire  _T_159; // @[Controllers.scala 292:24:@9760.4]
  bbox_SRFF active ( // @[Controllers.scala 261:22:@9657.4]
    .clock(active_clock),
    .reset(active_reset),
    .io_input_set(active_io_input_set),
    .io_input_reset(active_io_input_reset),
    .io_input_asyn_reset(active_io_input_asyn_reset),
    .io_output(active_io_output)
  );
  bbox_SRFF done ( // @[Controllers.scala 262:20:@9660.4]
    .clock(done_clock),
    .reset(done_reset),
    .io_input_set(done_io_input_set),
    .io_input_reset(done_io_input_reset),
    .io_input_asyn_reset(done_io_input_asyn_reset),
    .io_output(done_io_output)
  );
  bbox_RetimeWrapper_95 RetimeWrapper ( // @[package.scala 93:22:@9694.4]
    .clock(RetimeWrapper_clock),
    .reset(RetimeWrapper_reset),
    .io_flow(RetimeWrapper_io_flow),
    .io_in(RetimeWrapper_io_in),
    .io_out(RetimeWrapper_io_out)
  );
  bbox_RetimeWrapper_95 RetimeWrapper_1 ( // @[package.scala 93:22:@9716.4]
    .clock(RetimeWrapper_1_clock),
    .reset(RetimeWrapper_1_reset),
    .io_flow(RetimeWrapper_1_io_flow),
    .io_in(RetimeWrapper_1_io_in),
    .io_out(RetimeWrapper_1_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_2 ( // @[package.scala 93:22:@9728.4]
    .clock(RetimeWrapper_2_clock),
    .reset(RetimeWrapper_2_reset),
    .io_flow(RetimeWrapper_2_io_flow),
    .io_in(RetimeWrapper_2_io_in),
    .io_out(RetimeWrapper_2_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_3 ( // @[package.scala 93:22:@9736.4]
    .clock(RetimeWrapper_3_clock),
    .reset(RetimeWrapper_3_reset),
    .io_flow(RetimeWrapper_3_io_flow),
    .io_in(RetimeWrapper_3_io_in),
    .io_out(RetimeWrapper_3_io_out)
  );
  bbox_RetimeWrapper_99 RetimeWrapper_4 ( // @[package.scala 93:22:@9752.4]
    .clock(RetimeWrapper_4_clock),
    .reset(RetimeWrapper_4_reset),
    .io_in(RetimeWrapper_4_io_in),
    .io_out(RetimeWrapper_4_io_out)
  );
  assign _T_80 = ~ io_ctrDone; // @[Controllers.scala 264:48:@9665.4]
  assign _T_81 = io_enable & _T_80; // @[Controllers.scala 264:46:@9666.4]
  assign _T_82 = ~ done_io_output; // @[Controllers.scala 264:62:@9667.4]
  assign _T_100 = io_ctrDone == 1'h0; // @[package.scala 100:49:@9685.4]
  assign _T_118 = active_io_output & _T_82; // @[Controllers.scala 283:41:@9709.4]
  assign _T_124 = RetimeWrapper_1_io_out; // @[package.scala 96:25:@9721.4 package.scala 96:25:@9722.4]
  assign _T_126 = _T_124 == 1'h0; // @[package.scala 100:49:@9723.4]
  assign _T_150 = done_io_output == 1'h0; // @[package.scala 100:49:@9748.4]
  assign _T_156 = RetimeWrapper_4_io_out; // @[package.scala 96:25:@9757.4 package.scala 96:25:@9758.4]
  assign _T_158 = _T_156 ? 1'h1 : _T_146; // @[Controllers.scala 292:61:@9759.4]
  assign _T_159 = io_parentAck ? 1'h0 : _T_158; // @[Controllers.scala 292:24:@9760.4]
  assign io_done = _T_124 & _T_129; // @[Controllers.scala 287:13:@9727.4]
  assign io_doneLatch = _T_146; // @[Controllers.scala 293:18:@9762.4]
  assign io_datapathEn = _T_118 & io_enable; // @[Controllers.scala 283:21:@9712.4]
  assign io_ctrInc = active_io_output & io_enable; // @[Controllers.scala 284:17:@9715.4]
  assign active_clock = clock; // @[:@9658.4]
  assign active_reset = reset; // @[:@9659.4]
  assign active_io_input_set = _T_81 & _T_82; // @[Controllers.scala 264:23:@9670.4]
  assign active_io_input_reset = io_ctrDone | io_parentAck; // @[Controllers.scala 265:25:@9674.4]
  assign active_io_input_asyn_reset = 1'h0; // @[Controllers.scala 266:30:@9675.4]
  assign done_clock = clock; // @[:@9661.4]
  assign done_reset = reset; // @[:@9662.4]
  assign done_io_input_set = io_ctrDone & _T_103; // @[Controllers.scala 269:104:@9690.4]
  assign done_io_input_reset = io_parentAck; // @[Controllers.scala 267:23:@9683.4]
  assign done_io_input_asyn_reset = 1'h0; // @[Controllers.scala 268:28:@9684.4]
  assign RetimeWrapper_clock = clock; // @[:@9695.4]
  assign RetimeWrapper_reset = reset; // @[:@9696.4]
  assign RetimeWrapper_io_flow = 1'h1; // @[package.scala 95:18:@9698.4]
  assign RetimeWrapper_io_in = done_io_output; // @[package.scala 94:16:@9697.4]
  assign RetimeWrapper_1_clock = clock; // @[:@9717.4]
  assign RetimeWrapper_1_reset = reset; // @[:@9718.4]
  assign RetimeWrapper_1_io_flow = 1'h1; // @[package.scala 95:18:@9720.4]
  assign RetimeWrapper_1_io_in = done_io_output; // @[package.scala 94:16:@9719.4]
  assign RetimeWrapper_2_clock = clock; // @[:@9729.4]
  assign RetimeWrapper_2_reset = reset; // @[:@9730.4]
  assign RetimeWrapper_2_io_flow = 1'h1; // @[package.scala 95:18:@9732.4]
  assign RetimeWrapper_2_io_in = 1'h0; // @[package.scala 94:16:@9731.4]
  assign RetimeWrapper_3_clock = clock; // @[:@9737.4]
  assign RetimeWrapper_3_reset = reset; // @[:@9738.4]
  assign RetimeWrapper_3_io_flow = 1'h1; // @[package.scala 95:18:@9740.4]
  assign RetimeWrapper_3_io_in = io_ctrDone; // @[package.scala 94:16:@9739.4]
  assign RetimeWrapper_4_clock = clock; // @[:@9753.4]
  assign RetimeWrapper_4_reset = reset; // @[:@9754.4]
  assign RetimeWrapper_4_io_in = done_io_output & _T_153; // @[package.scala 94:16:@9755.4]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  _T_103 = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  _T_129 = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  _T_146 = _RAND_2[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  _T_153 = _RAND_3[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      _T_103 <= 1'h0;
    end else begin
      _T_103 <= _T_100;
    end
    if (reset) begin
      _T_129 <= 1'h0;
    end else begin
      _T_129 <= _T_126;
    end
    if (reset) begin
      _T_146 <= 1'h0;
    end else begin
      if (io_parentAck) begin
        _T_146 <= 1'h0;
      end else begin
        if (_T_156) begin
          _T_146 <= 1'h1;
        end
      end
    end
    if (reset) begin
      _T_153 <= 1'h0;
    end else begin
      _T_153 <= _T_150;
    end
  end
endmodule
module bbox_RetimeWrapper_104( // @[:@9912.2]
  input         clock, // @[:@9913.4]
  input         reset, // @[:@9914.4]
  input  [31:0] io_in, // @[:@9915.4]
  output [31:0] io_out // @[:@9915.4]
);
  wire [31:0] sr_out; // @[RetimeShiftRegister.scala 15:20:@9917.4]
  wire [31:0] sr_in; // @[RetimeShiftRegister.scala 15:20:@9917.4]
  wire [31:0] sr_init; // @[RetimeShiftRegister.scala 15:20:@9917.4]
  wire  sr_flow; // @[RetimeShiftRegister.scala 15:20:@9917.4]
  wire  sr_reset; // @[RetimeShiftRegister.scala 15:20:@9917.4]
  wire  sr_clock; // @[RetimeShiftRegister.scala 15:20:@9917.4]
  RetimeShiftRegister #(.WIDTH(32), .STAGES(2)) sr ( // @[RetimeShiftRegister.scala 15:20:@9917.4]
    .out(sr_out),
    .in(sr_in),
    .init(sr_init),
    .flow(sr_flow),
    .reset(sr_reset),
    .clock(sr_clock)
  );
  assign io_out = sr_out; // @[RetimeShiftRegister.scala 21:12:@9930.4]
  assign sr_in = io_in; // @[RetimeShiftRegister.scala 20:14:@9929.4]
  assign sr_init = 32'h0; // @[RetimeShiftRegister.scala 19:16:@9928.4]
  assign sr_flow = 1'h1; // @[RetimeShiftRegister.scala 18:16:@9927.4]
  assign sr_reset = reset; // @[RetimeShiftRegister.scala 17:17:@9926.4]
  assign sr_clock = clock; // @[RetimeShiftRegister.scala 16:17:@9924.4]
endmodule
module bbox_RetimeWrapper_105( // @[:@9944.2]
  input         clock, // @[:@9945.4]
  input         reset, // @[:@9946.4]
  input  [15:0] io_in, // @[:@9947.4]
  output [15:0] io_out // @[:@9947.4]
);
  wire [15:0] sr_out; // @[RetimeShiftRegister.scala 15:20:@9949.4]
  wire [15:0] sr_in; // @[RetimeShiftRegister.scala 15:20:@9949.4]
  wire [15:0] sr_init; // @[RetimeShiftRegister.scala 15:20:@9949.4]
  wire  sr_flow; // @[RetimeShiftRegister.scala 15:20:@9949.4]
  wire  sr_reset; // @[RetimeShiftRegister.scala 15:20:@9949.4]
  wire  sr_clock; // @[RetimeShiftRegister.scala 15:20:@9949.4]
  RetimeShiftRegister #(.WIDTH(16), .STAGES(2)) sr ( // @[RetimeShiftRegister.scala 15:20:@9949.4]
    .out(sr_out),
    .in(sr_in),
    .init(sr_init),
    .flow(sr_flow),
    .reset(sr_reset),
    .clock(sr_clock)
  );
  assign io_out = sr_out; // @[RetimeShiftRegister.scala 21:12:@9962.4]
  assign sr_in = io_in; // @[RetimeShiftRegister.scala 20:14:@9961.4]
  assign sr_init = 16'h0; // @[RetimeShiftRegister.scala 19:16:@9960.4]
  assign sr_flow = 1'h1; // @[RetimeShiftRegister.scala 18:16:@9959.4]
  assign sr_reset = reset; // @[RetimeShiftRegister.scala 17:17:@9958.4]
  assign sr_clock = clock; // @[RetimeShiftRegister.scala 16:17:@9956.4]
endmodule
module bbox_x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1( // @[:@10156.2]
  input         clock, // @[:@10157.4]
  input         reset, // @[:@10158.4]
  output [31:0] io_in_x88_reg_wPort_0_data_0, // @[:@10159.4]
  output        io_in_x88_reg_wPort_0_reset, // @[:@10159.4]
  output        io_in_x88_reg_wPort_0_en_0, // @[:@10159.4]
  output        io_in_x88_reg_reset, // @[:@10159.4]
  output        io_in_x88_reg_sEn_0, // @[:@10159.4]
  output        io_in_x88_reg_sDone_0, // @[:@10159.4]
  output [15:0] io_in_x89_reg_wPort_0_data_0, // @[:@10159.4]
  output        io_in_x89_reg_wPort_0_reset, // @[:@10159.4]
  output        io_in_x89_reg_wPort_0_en_0, // @[:@10159.4]
  output        io_in_x89_reg_reset, // @[:@10159.4]
  output        io_in_x89_reg_sEn_0, // @[:@10159.4]
  output        io_in_x89_reg_sDone_0, // @[:@10159.4]
  output        io_in_x77_scalar_0_rPort_0_en_0, // @[:@10159.4]
  input  [15:0] io_in_x77_scalar_0_rPort_0_output_0, // @[:@10159.4]
  output        io_in_x76_numel_0_rPort_0_en_0, // @[:@10159.4]
  input  [31:0] io_in_x76_numel_0_rPort_0_output_0, // @[:@10159.4]
  output [31:0] io_in_x90_reg_wPort_0_data_0, // @[:@10159.4]
  output        io_in_x90_reg_wPort_0_reset, // @[:@10159.4]
  output        io_in_x90_reg_wPort_0_en_0, // @[:@10159.4]
  output        io_in_x90_reg_reset, // @[:@10159.4]
  output        io_in_x90_reg_sEn_0, // @[:@10159.4]
  output        io_in_x90_reg_sDone_0, // @[:@10159.4]
  input         io_sigsIn_done, // @[:@10159.4]
  input         io_sigsIn_datapathEn, // @[:@10159.4]
  input         io_sigsIn_baseEn, // @[:@10159.4]
  input         io_sigsIn_break, // @[:@10159.4]
  input         io_rr // @[:@10159.4]
);
  wire  RetimeWrapper_clock; // @[package.scala 93:22:@10303.4]
  wire  RetimeWrapper_reset; // @[package.scala 93:22:@10303.4]
  wire [31:0] RetimeWrapper_io_in; // @[package.scala 93:22:@10303.4]
  wire [31:0] RetimeWrapper_io_out; // @[package.scala 93:22:@10303.4]
  wire  RetimeWrapper_1_clock; // @[package.scala 93:22:@10325.4]
  wire  RetimeWrapper_1_reset; // @[package.scala 93:22:@10325.4]
  wire [15:0] RetimeWrapper_1_io_in; // @[package.scala 93:22:@10325.4]
  wire [15:0] RetimeWrapper_1_io_out; // @[package.scala 93:22:@10325.4]
  wire  RetimeWrapper_2_clock; // @[package.scala 93:22:@10343.4]
  wire  RetimeWrapper_2_reset; // @[package.scala 93:22:@10343.4]
  wire  RetimeWrapper_2_io_in; // @[package.scala 93:22:@10343.4]
  wire  RetimeWrapper_2_io_out; // @[package.scala 93:22:@10343.4]
  wire  RetimeWrapper_3_clock; // @[package.scala 93:22:@10362.4]
  wire  RetimeWrapper_3_reset; // @[package.scala 93:22:@10362.4]
  wire  RetimeWrapper_3_io_in; // @[package.scala 93:22:@10362.4]
  wire  RetimeWrapper_3_io_out; // @[package.scala 93:22:@10362.4]
  wire  RetimeWrapper_4_clock; // @[package.scala 93:22:@10381.4]
  wire  RetimeWrapper_4_reset; // @[package.scala 93:22:@10381.4]
  wire  RetimeWrapper_4_io_in; // @[package.scala 93:22:@10381.4]
  wire  RetimeWrapper_4_io_out; // @[package.scala 93:22:@10381.4]
  wire  RetimeWrapper_5_clock; // @[package.scala 93:22:@10397.4]
  wire  RetimeWrapper_5_reset; // @[package.scala 93:22:@10397.4]
  wire  RetimeWrapper_5_io_flow; // @[package.scala 93:22:@10397.4]
  wire  RetimeWrapper_5_io_in; // @[package.scala 93:22:@10397.4]
  wire  RetimeWrapper_5_io_out; // @[package.scala 93:22:@10397.4]
  wire  RetimeWrapper_6_clock; // @[package.scala 93:22:@10407.4]
  wire  RetimeWrapper_6_reset; // @[package.scala 93:22:@10407.4]
  wire  RetimeWrapper_6_io_flow; // @[package.scala 93:22:@10407.4]
  wire  RetimeWrapper_6_io_in; // @[package.scala 93:22:@10407.4]
  wire  RetimeWrapper_6_io_out; // @[package.scala 93:22:@10407.4]
  wire  RetimeWrapper_7_clock; // @[package.scala 93:22:@10417.4]
  wire  RetimeWrapper_7_reset; // @[package.scala 93:22:@10417.4]
  wire  RetimeWrapper_7_io_flow; // @[package.scala 93:22:@10417.4]
  wire  RetimeWrapper_7_io_in; // @[package.scala 93:22:@10417.4]
  wire  RetimeWrapper_7_io_out; // @[package.scala 93:22:@10417.4]
  wire  _T_1047; // @[sm_x99_inr_UnitPipe.scala 82:142:@10292.4]
  wire  _T_1051; // @[implicits.scala 55:10:@10295.4]
  wire [31:0] x142_x91_deq_x76_D2_0_number; // @[package.scala 96:25:@10308.4 package.scala 96:25:@10309.4]
  wire [32:0] _GEN_0; // @[Math.scala 450:32:@10337.4]
  wire [32:0] _T_1093; // @[Math.scala 450:32:@10337.4]
  wire  _T_1098; // @[package.scala 96:25:@10348.4 package.scala 96:25:@10349.4]
  wire  _T_1100; // @[implicits.scala 55:10:@10350.4]
  wire  _T_1101; // @[sm_x99_inr_UnitPipe.scala 104:123:@10351.4]
  wire  _T_1111; // @[package.scala 96:25:@10367.4 package.scala 96:25:@10368.4]
  wire  _T_1113; // @[implicits.scala 55:10:@10369.4]
  wire  _T_1114; // @[sm_x99_inr_UnitPipe.scala 109:123:@10370.4]
  wire  _T_1124; // @[package.scala 96:25:@10386.4 package.scala 96:25:@10387.4]
  wire  _T_1126; // @[implicits.scala 55:10:@10388.4]
  wire  _T_1127; // @[sm_x99_inr_UnitPipe.scala 114:123:@10389.4]
  wire  _T_1134; // @[package.scala 96:25:@10402.4 package.scala 96:25:@10403.4]
  wire  _T_1138; // @[package.scala 96:25:@10412.4 package.scala 96:25:@10413.4]
  wire  _T_1142; // @[package.scala 96:25:@10422.4 package.scala 96:25:@10423.4]
  bbox_RetimeWrapper_104 RetimeWrapper ( // @[package.scala 93:22:@10303.4]
    .clock(RetimeWrapper_clock),
    .reset(RetimeWrapper_reset),
    .io_in(RetimeWrapper_io_in),
    .io_out(RetimeWrapper_io_out)
  );
  bbox_RetimeWrapper_105 RetimeWrapper_1 ( // @[package.scala 93:22:@10325.4]
    .clock(RetimeWrapper_1_clock),
    .reset(RetimeWrapper_1_reset),
    .io_in(RetimeWrapper_1_io_in),
    .io_out(RetimeWrapper_1_io_out)
  );
  bbox_RetimeWrapper_99 RetimeWrapper_2 ( // @[package.scala 93:22:@10343.4]
    .clock(RetimeWrapper_2_clock),
    .reset(RetimeWrapper_2_reset),
    .io_in(RetimeWrapper_2_io_in),
    .io_out(RetimeWrapper_2_io_out)
  );
  bbox_RetimeWrapper_99 RetimeWrapper_3 ( // @[package.scala 93:22:@10362.4]
    .clock(RetimeWrapper_3_clock),
    .reset(RetimeWrapper_3_reset),
    .io_in(RetimeWrapper_3_io_in),
    .io_out(RetimeWrapper_3_io_out)
  );
  bbox_RetimeWrapper_99 RetimeWrapper_4 ( // @[package.scala 93:22:@10381.4]
    .clock(RetimeWrapper_4_clock),
    .reset(RetimeWrapper_4_reset),
    .io_in(RetimeWrapper_4_io_in),
    .io_out(RetimeWrapper_4_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_5 ( // @[package.scala 93:22:@10397.4]
    .clock(RetimeWrapper_5_clock),
    .reset(RetimeWrapper_5_reset),
    .io_flow(RetimeWrapper_5_io_flow),
    .io_in(RetimeWrapper_5_io_in),
    .io_out(RetimeWrapper_5_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_6 ( // @[package.scala 93:22:@10407.4]
    .clock(RetimeWrapper_6_clock),
    .reset(RetimeWrapper_6_reset),
    .io_flow(RetimeWrapper_6_io_flow),
    .io_in(RetimeWrapper_6_io_in),
    .io_out(RetimeWrapper_6_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_7 ( // @[package.scala 93:22:@10417.4]
    .clock(RetimeWrapper_7_clock),
    .reset(RetimeWrapper_7_reset),
    .io_flow(RetimeWrapper_7_io_flow),
    .io_in(RetimeWrapper_7_io_in),
    .io_out(RetimeWrapper_7_io_out)
  );
  assign _T_1047 = ~ io_sigsIn_break; // @[sm_x99_inr_UnitPipe.scala 82:142:@10292.4]
  assign _T_1051 = io_rr ? io_sigsIn_datapathEn : 1'h0; // @[implicits.scala 55:10:@10295.4]
  assign x142_x91_deq_x76_D2_0_number = RetimeWrapper_io_out; // @[package.scala 96:25:@10308.4 package.scala 96:25:@10309.4]
  assign _GEN_0 = {{1'd0}, x142_x91_deq_x76_D2_0_number}; // @[Math.scala 450:32:@10337.4]
  assign _T_1093 = _GEN_0 << 1; // @[Math.scala 450:32:@10337.4]
  assign _T_1098 = RetimeWrapper_2_io_out; // @[package.scala 96:25:@10348.4 package.scala 96:25:@10349.4]
  assign _T_1100 = io_rr ? _T_1098 : 1'h0; // @[implicits.scala 55:10:@10350.4]
  assign _T_1101 = _T_1047 & _T_1100; // @[sm_x99_inr_UnitPipe.scala 104:123:@10351.4]
  assign _T_1111 = RetimeWrapper_3_io_out; // @[package.scala 96:25:@10367.4 package.scala 96:25:@10368.4]
  assign _T_1113 = io_rr ? _T_1111 : 1'h0; // @[implicits.scala 55:10:@10369.4]
  assign _T_1114 = _T_1047 & _T_1113; // @[sm_x99_inr_UnitPipe.scala 109:123:@10370.4]
  assign _T_1124 = RetimeWrapper_4_io_out; // @[package.scala 96:25:@10386.4 package.scala 96:25:@10387.4]
  assign _T_1126 = io_rr ? _T_1124 : 1'h0; // @[implicits.scala 55:10:@10388.4]
  assign _T_1127 = _T_1047 & _T_1126; // @[sm_x99_inr_UnitPipe.scala 114:123:@10389.4]
  assign _T_1134 = RetimeWrapper_5_io_out; // @[package.scala 96:25:@10402.4 package.scala 96:25:@10403.4]
  assign _T_1138 = RetimeWrapper_6_io_out; // @[package.scala 96:25:@10412.4 package.scala 96:25:@10413.4]
  assign _T_1142 = RetimeWrapper_7_io_out; // @[package.scala 96:25:@10422.4 package.scala 96:25:@10423.4]
  assign io_in_x88_reg_wPort_0_data_0 = RetimeWrapper_io_out; // @[MemInterfaceType.scala 90:56:@10356.4]
  assign io_in_x88_reg_wPort_0_reset = io_in_x88_reg_reset; // @[MemInterfaceType.scala 91:23:@10357.4]
  assign io_in_x88_reg_wPort_0_en_0 = _T_1101 & _T_1047; // @[MemInterfaceType.scala 93:57:@10358.4]
  assign io_in_x88_reg_reset = 1'h0;
  assign io_in_x88_reg_sEn_0 = io_sigsIn_baseEn; // @[MemInterfaceType.scala 183:15:@10405.4]
  assign io_in_x88_reg_sDone_0 = io_rr ? _T_1134 : 1'h0; // @[MemInterfaceType.scala 184:17:@10406.4]
  assign io_in_x89_reg_wPort_0_data_0 = RetimeWrapper_1_io_out; // @[MemInterfaceType.scala 90:56:@10375.4]
  assign io_in_x89_reg_wPort_0_reset = io_in_x89_reg_reset; // @[MemInterfaceType.scala 91:23:@10376.4]
  assign io_in_x89_reg_wPort_0_en_0 = _T_1114 & _T_1047; // @[MemInterfaceType.scala 93:57:@10377.4]
  assign io_in_x89_reg_reset = 1'h0;
  assign io_in_x89_reg_sEn_0 = io_sigsIn_baseEn; // @[MemInterfaceType.scala 183:15:@10415.4]
  assign io_in_x89_reg_sDone_0 = io_rr ? _T_1138 : 1'h0; // @[MemInterfaceType.scala 184:17:@10416.4]
  assign io_in_x77_scalar_0_rPort_0_en_0 = _T_1047 & _T_1051; // @[MemInterfaceType.scala 110:79:@10321.4]
  assign io_in_x76_numel_0_rPort_0_en_0 = _T_1047 & _T_1051; // @[MemInterfaceType.scala 110:79:@10299.4]
  assign io_in_x90_reg_wPort_0_data_0 = _T_1093[31:0]; // @[MemInterfaceType.scala 90:56:@10394.4]
  assign io_in_x90_reg_wPort_0_reset = io_in_x90_reg_reset; // @[MemInterfaceType.scala 91:23:@10395.4]
  assign io_in_x90_reg_wPort_0_en_0 = _T_1127 & _T_1047; // @[MemInterfaceType.scala 93:57:@10396.4]
  assign io_in_x90_reg_reset = 1'h0;
  assign io_in_x90_reg_sEn_0 = io_sigsIn_baseEn; // @[MemInterfaceType.scala 183:15:@10425.4]
  assign io_in_x90_reg_sDone_0 = io_rr ? _T_1142 : 1'h0; // @[MemInterfaceType.scala 184:17:@10426.4]
  assign RetimeWrapper_clock = clock; // @[:@10304.4]
  assign RetimeWrapper_reset = reset; // @[:@10305.4]
  assign RetimeWrapper_io_in = io_in_x76_numel_0_rPort_0_output_0; // @[package.scala 94:16:@10306.4]
  assign RetimeWrapper_1_clock = clock; // @[:@10326.4]
  assign RetimeWrapper_1_reset = reset; // @[:@10327.4]
  assign RetimeWrapper_1_io_in = io_in_x77_scalar_0_rPort_0_output_0; // @[package.scala 94:16:@10328.4]
  assign RetimeWrapper_2_clock = clock; // @[:@10344.4]
  assign RetimeWrapper_2_reset = reset; // @[:@10345.4]
  assign RetimeWrapper_2_io_in = io_sigsIn_datapathEn; // @[package.scala 94:16:@10346.4]
  assign RetimeWrapper_3_clock = clock; // @[:@10363.4]
  assign RetimeWrapper_3_reset = reset; // @[:@10364.4]
  assign RetimeWrapper_3_io_in = io_sigsIn_datapathEn; // @[package.scala 94:16:@10365.4]
  assign RetimeWrapper_4_clock = clock; // @[:@10382.4]
  assign RetimeWrapper_4_reset = reset; // @[:@10383.4]
  assign RetimeWrapper_4_io_in = io_sigsIn_datapathEn; // @[package.scala 94:16:@10384.4]
  assign RetimeWrapper_5_clock = clock; // @[:@10398.4]
  assign RetimeWrapper_5_reset = reset; // @[:@10399.4]
  assign RetimeWrapper_5_io_flow = 1'h1; // @[package.scala 95:18:@10401.4]
  assign RetimeWrapper_5_io_in = io_sigsIn_done; // @[package.scala 94:16:@10400.4]
  assign RetimeWrapper_6_clock = clock; // @[:@10408.4]
  assign RetimeWrapper_6_reset = reset; // @[:@10409.4]
  assign RetimeWrapper_6_io_flow = 1'h1; // @[package.scala 95:18:@10411.4]
  assign RetimeWrapper_6_io_in = io_sigsIn_done; // @[package.scala 94:16:@10410.4]
  assign RetimeWrapper_7_clock = clock; // @[:@10418.4]
  assign RetimeWrapper_7_reset = reset; // @[:@10419.4]
  assign RetimeWrapper_7_io_flow = 1'h1; // @[package.scala 95:18:@10421.4]
  assign RetimeWrapper_7_io_in = io_sigsIn_done; // @[package.scala 94:16:@10420.4]
endmodule
module bbox_SingleCounter_2( // @[:@10466.2]
  input         clock, // @[:@10467.4]
  input         reset, // @[:@10468.4]
  input  [31:0] io_setup_stop, // @[:@10469.4]
  input         io_input_reset, // @[:@10469.4]
  input         io_input_enable, // @[:@10469.4]
  output [31:0] io_output_count_0, // @[:@10469.4]
  output        io_output_oobs_0, // @[:@10469.4]
  output        io_output_noop, // @[:@10469.4]
  output        io_output_done // @[:@10469.4]
);
  wire  bases_0_clock; // @[Counter.scala 253:53:@10482.4]
  wire  bases_0_reset; // @[Counter.scala 253:53:@10482.4]
  wire [31:0] bases_0_io_rPort_0_output_0; // @[Counter.scala 253:53:@10482.4]
  wire [31:0] bases_0_io_wPort_0_data_0; // @[Counter.scala 253:53:@10482.4]
  wire  bases_0_io_wPort_0_reset; // @[Counter.scala 253:53:@10482.4]
  wire  bases_0_io_wPort_0_en_0; // @[Counter.scala 253:53:@10482.4]
  wire  SRFF_clock; // @[Counter.scala 255:22:@10498.4]
  wire  SRFF_reset; // @[Counter.scala 255:22:@10498.4]
  wire  SRFF_io_input_set; // @[Counter.scala 255:22:@10498.4]
  wire  SRFF_io_input_reset; // @[Counter.scala 255:22:@10498.4]
  wire  SRFF_io_input_asyn_reset; // @[Counter.scala 255:22:@10498.4]
  wire  SRFF_io_output; // @[Counter.scala 255:22:@10498.4]
  wire  _T_36; // @[Counter.scala 256:45:@10501.4]
  wire [31:0] _T_48; // @[Counter.scala 279:52:@10526.4]
  wire [32:0] _T_50; // @[Counter.scala 283:33:@10527.4]
  wire [31:0] _T_51; // @[Counter.scala 283:33:@10528.4]
  wire [31:0] _T_52; // @[Counter.scala 283:33:@10529.4]
  wire  _T_56; // @[Counter.scala 285:18:@10531.4]
  wire [31:0] _T_66; // @[Counter.scala 291:115:@10539.4]
  wire [31:0] _T_69; // @[Counter.scala 291:152:@10542.4]
  wire [31:0] _T_70; // @[Counter.scala 291:74:@10543.4]
  wire  _T_73; // @[Counter.scala 316:102:@10547.4]
  wire  _T_74; // @[Counter.scala 316:130:@10548.4]
  bbox_FF bases_0 ( // @[Counter.scala 253:53:@10482.4]
    .clock(bases_0_clock),
    .reset(bases_0_reset),
    .io_rPort_0_output_0(bases_0_io_rPort_0_output_0),
    .io_wPort_0_data_0(bases_0_io_wPort_0_data_0),
    .io_wPort_0_reset(bases_0_io_wPort_0_reset),
    .io_wPort_0_en_0(bases_0_io_wPort_0_en_0)
  );
  bbox_SRFF SRFF ( // @[Counter.scala 255:22:@10498.4]
    .clock(SRFF_clock),
    .reset(SRFF_reset),
    .io_input_set(SRFF_io_input_set),
    .io_input_reset(SRFF_io_input_reset),
    .io_input_asyn_reset(SRFF_io_input_asyn_reset),
    .io_output(SRFF_io_output)
  );
  assign _T_36 = io_input_reset == 1'h0; // @[Counter.scala 256:45:@10501.4]
  assign _T_48 = $signed(bases_0_io_rPort_0_output_0); // @[Counter.scala 279:52:@10526.4]
  assign _T_50 = $signed(_T_48) + $signed(32'sh1); // @[Counter.scala 283:33:@10527.4]
  assign _T_51 = $signed(_T_48) + $signed(32'sh1); // @[Counter.scala 283:33:@10528.4]
  assign _T_52 = $signed(_T_51); // @[Counter.scala 283:33:@10529.4]
  assign _T_56 = $signed(_T_52) >= $signed(io_setup_stop); // @[Counter.scala 285:18:@10531.4]
  assign _T_66 = $unsigned(_T_48); // @[Counter.scala 291:115:@10539.4]
  assign _T_69 = $unsigned(_T_52); // @[Counter.scala 291:152:@10542.4]
  assign _T_70 = _T_56 ? _T_66 : _T_69; // @[Counter.scala 291:74:@10543.4]
  assign _T_73 = $signed(_T_48) < $signed(32'sh0); // @[Counter.scala 316:102:@10547.4]
  assign _T_74 = $signed(_T_48) >= $signed(io_setup_stop); // @[Counter.scala 316:130:@10548.4]
  assign io_output_count_0 = $signed(bases_0_io_rPort_0_output_0); // @[Counter.scala 296:28:@10546.4]
  assign io_output_oobs_0 = _T_73 | _T_74; // @[Counter.scala 316:60:@10550.4]
  assign io_output_noop = $signed(32'sh0) == $signed(io_setup_stop); // @[Counter.scala 328:40:@10554.4]
  assign io_output_done = io_input_enable & _T_56; // @[Counter.scala 325:20:@10552.4]
  assign bases_0_clock = clock; // @[:@10483.4]
  assign bases_0_reset = reset; // @[:@10484.4]
  assign bases_0_io_wPort_0_data_0 = io_input_reset ? 32'h0 : _T_70; // @[Counter.scala 291:31:@10545.4]
  assign bases_0_io_wPort_0_reset = io_input_reset; // @[Counter.scala 273:27:@10524.4]
  assign bases_0_io_wPort_0_en_0 = io_input_enable; // @[Counter.scala 276:29:@10525.4]
  assign SRFF_clock = clock; // @[:@10499.4]
  assign SRFF_reset = reset; // @[:@10500.4]
  assign SRFF_io_input_set = io_input_enable & _T_36; // @[Counter.scala 256:23:@10503.4]
  assign SRFF_io_input_reset = io_input_reset | io_output_done; // @[Counter.scala 257:25:@10505.4]
  assign SRFF_io_input_asyn_reset = 1'h0; // @[Counter.scala 258:30:@10506.4]
endmodule
module bbox_x102_ctrchain( // @[:@10558.2]
  input         clock, // @[:@10559.4]
  input         reset, // @[:@10560.4]
  input  [31:0] io_setup_stops_0, // @[:@10561.4]
  input         io_input_reset, // @[:@10561.4]
  input         io_input_enable, // @[:@10561.4]
  output [31:0] io_output_counts_0, // @[:@10561.4]
  output        io_output_oobs_0, // @[:@10561.4]
  output        io_output_noop, // @[:@10561.4]
  output        io_output_done // @[:@10561.4]
);
  wire  ctrs_0_clock; // @[Counter.scala 505:46:@10563.4]
  wire  ctrs_0_reset; // @[Counter.scala 505:46:@10563.4]
  wire [31:0] ctrs_0_io_setup_stop; // @[Counter.scala 505:46:@10563.4]
  wire  ctrs_0_io_input_reset; // @[Counter.scala 505:46:@10563.4]
  wire  ctrs_0_io_input_enable; // @[Counter.scala 505:46:@10563.4]
  wire [31:0] ctrs_0_io_output_count_0; // @[Counter.scala 505:46:@10563.4]
  wire  ctrs_0_io_output_oobs_0; // @[Counter.scala 505:46:@10563.4]
  wire  ctrs_0_io_output_noop; // @[Counter.scala 505:46:@10563.4]
  wire  ctrs_0_io_output_done; // @[Counter.scala 505:46:@10563.4]
  reg  wasDone; // @[Counter.scala 534:24:@10572.4]
  reg [31:0] _RAND_0;
  wire  _T_45; // @[Counter.scala 538:69:@10578.4]
  wire  _T_47; // @[Counter.scala 538:80:@10579.4]
  reg  doneLatch; // @[Counter.scala 542:26:@10584.4]
  reg [31:0] _RAND_1;
  wire  _T_54; // @[Counter.scala 543:48:@10585.4]
  wire  _T_55; // @[Counter.scala 543:19:@10586.4]
  bbox_SingleCounter_2 ctrs_0 ( // @[Counter.scala 505:46:@10563.4]
    .clock(ctrs_0_clock),
    .reset(ctrs_0_reset),
    .io_setup_stop(ctrs_0_io_setup_stop),
    .io_input_reset(ctrs_0_io_input_reset),
    .io_input_enable(ctrs_0_io_input_enable),
    .io_output_count_0(ctrs_0_io_output_count_0),
    .io_output_oobs_0(ctrs_0_io_output_oobs_0),
    .io_output_noop(ctrs_0_io_output_noop),
    .io_output_done(ctrs_0_io_output_done)
  );
  assign _T_45 = io_input_enable & ctrs_0_io_output_done; // @[Counter.scala 538:69:@10578.4]
  assign _T_47 = wasDone == 1'h0; // @[Counter.scala 538:80:@10579.4]
  assign _T_54 = ctrs_0_io_output_done ? 1'h1 : doneLatch; // @[Counter.scala 543:48:@10585.4]
  assign _T_55 = io_input_reset ? 1'h0 : _T_54; // @[Counter.scala 543:19:@10586.4]
  assign io_output_counts_0 = ctrs_0_io_output_count_0; // @[Counter.scala 549:32:@10588.4]
  assign io_output_oobs_0 = ctrs_0_io_output_oobs_0 | doneLatch; // @[Counter.scala 550:30:@10590.4]
  assign io_output_noop = ctrs_0_io_output_noop; // @[Counter.scala 537:18:@10576.4]
  assign io_output_done = _T_45 & _T_47; // @[Counter.scala 538:18:@10581.4]
  assign ctrs_0_clock = clock; // @[:@10564.4]
  assign ctrs_0_reset = reset; // @[:@10565.4]
  assign ctrs_0_io_setup_stop = io_setup_stops_0; // @[Counter.scala 510:23:@10567.4]
  assign ctrs_0_io_input_reset = io_input_reset; // @[Counter.scala 512:24:@10569.4]
  assign ctrs_0_io_input_enable = io_input_enable; // @[Counter.scala 516:33:@10570.4]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  wasDone = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  doneLatch = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      wasDone <= 1'h0;
    end else begin
      wasDone <= ctrs_0_io_output_done;
    end
    if (reset) begin
      doneLatch <= 1'h0;
    end else begin
      if (io_input_reset) begin
        doneLatch <= 1'h0;
      end else begin
        if (ctrs_0_io_output_done) begin
          doneLatch <= 1'h1;
        end
      end
    end
  end
endmodule
module bbox_RetimeWrapper_112( // @[:@10630.2]
  input   clock, // @[:@10631.4]
  input   reset, // @[:@10632.4]
  input   io_flow, // @[:@10633.4]
  input   io_in, // @[:@10633.4]
  output  io_out // @[:@10633.4]
);
  wire  sr_out; // @[RetimeShiftRegister.scala 15:20:@10635.4]
  wire  sr_in; // @[RetimeShiftRegister.scala 15:20:@10635.4]
  wire  sr_init; // @[RetimeShiftRegister.scala 15:20:@10635.4]
  wire  sr_flow; // @[RetimeShiftRegister.scala 15:20:@10635.4]
  wire  sr_reset; // @[RetimeShiftRegister.scala 15:20:@10635.4]
  wire  sr_clock; // @[RetimeShiftRegister.scala 15:20:@10635.4]
  RetimeShiftRegister #(.WIDTH(1), .STAGES(4)) sr ( // @[RetimeShiftRegister.scala 15:20:@10635.4]
    .out(sr_out),
    .in(sr_in),
    .init(sr_init),
    .flow(sr_flow),
    .reset(sr_reset),
    .clock(sr_clock)
  );
  assign io_out = sr_out; // @[RetimeShiftRegister.scala 21:12:@10648.4]
  assign sr_in = io_in; // @[RetimeShiftRegister.scala 20:14:@10647.4]
  assign sr_init = 1'h0; // @[RetimeShiftRegister.scala 19:16:@10646.4]
  assign sr_flow = io_flow; // @[RetimeShiftRegister.scala 18:16:@10645.4]
  assign sr_reset = reset; // @[RetimeShiftRegister.scala 17:17:@10644.4]
  assign sr_clock = clock; // @[RetimeShiftRegister.scala 16:17:@10642.4]
endmodule
module bbox_x118_inr_Foreach_sm( // @[:@10778.2]
  input   clock, // @[:@10779.4]
  input   reset, // @[:@10780.4]
  input   io_enable, // @[:@10781.4]
  output  io_done, // @[:@10781.4]
  output  io_doneLatch, // @[:@10781.4]
  input   io_ctrDone, // @[:@10781.4]
  output  io_datapathEn, // @[:@10781.4]
  output  io_ctrInc, // @[:@10781.4]
  output  io_ctrRst, // @[:@10781.4]
  input   io_parentAck, // @[:@10781.4]
  input   io_backpressure, // @[:@10781.4]
  input   io_break // @[:@10781.4]
);
  wire  active_clock; // @[Controllers.scala 261:22:@10783.4]
  wire  active_reset; // @[Controllers.scala 261:22:@10783.4]
  wire  active_io_input_set; // @[Controllers.scala 261:22:@10783.4]
  wire  active_io_input_reset; // @[Controllers.scala 261:22:@10783.4]
  wire  active_io_input_asyn_reset; // @[Controllers.scala 261:22:@10783.4]
  wire  active_io_output; // @[Controllers.scala 261:22:@10783.4]
  wire  done_clock; // @[Controllers.scala 262:20:@10786.4]
  wire  done_reset; // @[Controllers.scala 262:20:@10786.4]
  wire  done_io_input_set; // @[Controllers.scala 262:20:@10786.4]
  wire  done_io_input_reset; // @[Controllers.scala 262:20:@10786.4]
  wire  done_io_input_asyn_reset; // @[Controllers.scala 262:20:@10786.4]
  wire  done_io_output; // @[Controllers.scala 262:20:@10786.4]
  wire  RetimeWrapper_clock; // @[package.scala 93:22:@10820.4]
  wire  RetimeWrapper_reset; // @[package.scala 93:22:@10820.4]
  wire  RetimeWrapper_io_flow; // @[package.scala 93:22:@10820.4]
  wire  RetimeWrapper_io_in; // @[package.scala 93:22:@10820.4]
  wire  RetimeWrapper_io_out; // @[package.scala 93:22:@10820.4]
  wire  RetimeWrapper_1_clock; // @[package.scala 93:22:@10842.4]
  wire  RetimeWrapper_1_reset; // @[package.scala 93:22:@10842.4]
  wire  RetimeWrapper_1_io_flow; // @[package.scala 93:22:@10842.4]
  wire  RetimeWrapper_1_io_in; // @[package.scala 93:22:@10842.4]
  wire  RetimeWrapper_1_io_out; // @[package.scala 93:22:@10842.4]
  wire  RetimeWrapper_2_clock; // @[package.scala 93:22:@10854.4]
  wire  RetimeWrapper_2_reset; // @[package.scala 93:22:@10854.4]
  wire  RetimeWrapper_2_io_flow; // @[package.scala 93:22:@10854.4]
  wire  RetimeWrapper_2_io_in; // @[package.scala 93:22:@10854.4]
  wire  RetimeWrapper_2_io_out; // @[package.scala 93:22:@10854.4]
  wire  RetimeWrapper_3_clock; // @[package.scala 93:22:@10862.4]
  wire  RetimeWrapper_3_reset; // @[package.scala 93:22:@10862.4]
  wire  RetimeWrapper_3_io_flow; // @[package.scala 93:22:@10862.4]
  wire  RetimeWrapper_3_io_in; // @[package.scala 93:22:@10862.4]
  wire  RetimeWrapper_3_io_out; // @[package.scala 93:22:@10862.4]
  wire  RetimeWrapper_4_clock; // @[package.scala 93:22:@10878.4]
  wire  RetimeWrapper_4_reset; // @[package.scala 93:22:@10878.4]
  wire  RetimeWrapper_4_io_flow; // @[package.scala 93:22:@10878.4]
  wire  RetimeWrapper_4_io_in; // @[package.scala 93:22:@10878.4]
  wire  RetimeWrapper_4_io_out; // @[package.scala 93:22:@10878.4]
  wire  _T_80; // @[Controllers.scala 264:48:@10791.4]
  wire  _T_81; // @[Controllers.scala 264:46:@10792.4]
  wire  _T_82; // @[Controllers.scala 264:62:@10793.4]
  wire  _T_83; // @[Controllers.scala 264:60:@10794.4]
  wire  _T_100; // @[package.scala 100:49:@10811.4]
  reg  _T_103; // @[package.scala 48:56:@10812.4]
  reg [31:0] _RAND_0;
  wire  _T_108; // @[package.scala 96:25:@10825.4 package.scala 96:25:@10826.4]
  wire  _T_110; // @[package.scala 100:49:@10827.4]
  reg  _T_113; // @[package.scala 48:56:@10828.4]
  reg [31:0] _RAND_1;
  wire  _T_114; // @[package.scala 100:41:@10830.4]
  wire  _T_118; // @[Controllers.scala 283:41:@10835.4]
  wire  _T_119; // @[Controllers.scala 283:59:@10836.4]
  wire  _T_121; // @[Controllers.scala 284:37:@10839.4]
  wire  _T_124; // @[package.scala 96:25:@10847.4 package.scala 96:25:@10848.4]
  wire  _T_126; // @[package.scala 100:49:@10849.4]
  reg  _T_129; // @[package.scala 48:56:@10850.4]
  reg [31:0] _RAND_2;
  reg  _T_146; // @[Controllers.scala 291:31:@10872.4]
  reg [31:0] _RAND_3;
  wire  _T_150; // @[package.scala 100:49:@10874.4]
  reg  _T_153; // @[package.scala 48:56:@10875.4]
  reg [31:0] _RAND_4;
  wire  _T_156; // @[package.scala 96:25:@10883.4 package.scala 96:25:@10884.4]
  wire  _T_158; // @[Controllers.scala 292:61:@10885.4]
  wire  _T_159; // @[Controllers.scala 292:24:@10886.4]
  bbox_SRFF active ( // @[Controllers.scala 261:22:@10783.4]
    .clock(active_clock),
    .reset(active_reset),
    .io_input_set(active_io_input_set),
    .io_input_reset(active_io_input_reset),
    .io_input_asyn_reset(active_io_input_asyn_reset),
    .io_output(active_io_output)
  );
  bbox_SRFF done ( // @[Controllers.scala 262:20:@10786.4]
    .clock(done_clock),
    .reset(done_reset),
    .io_input_set(done_io_input_set),
    .io_input_reset(done_io_input_reset),
    .io_input_asyn_reset(done_io_input_asyn_reset),
    .io_output(done_io_output)
  );
  bbox_RetimeWrapper_112 RetimeWrapper ( // @[package.scala 93:22:@10820.4]
    .clock(RetimeWrapper_clock),
    .reset(RetimeWrapper_reset),
    .io_flow(RetimeWrapper_io_flow),
    .io_in(RetimeWrapper_io_in),
    .io_out(RetimeWrapper_io_out)
  );
  bbox_RetimeWrapper_112 RetimeWrapper_1 ( // @[package.scala 93:22:@10842.4]
    .clock(RetimeWrapper_1_clock),
    .reset(RetimeWrapper_1_reset),
    .io_flow(RetimeWrapper_1_io_flow),
    .io_in(RetimeWrapper_1_io_in),
    .io_out(RetimeWrapper_1_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_2 ( // @[package.scala 93:22:@10854.4]
    .clock(RetimeWrapper_2_clock),
    .reset(RetimeWrapper_2_reset),
    .io_flow(RetimeWrapper_2_io_flow),
    .io_in(RetimeWrapper_2_io_in),
    .io_out(RetimeWrapper_2_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_3 ( // @[package.scala 93:22:@10862.4]
    .clock(RetimeWrapper_3_clock),
    .reset(RetimeWrapper_3_reset),
    .io_flow(RetimeWrapper_3_io_flow),
    .io_in(RetimeWrapper_3_io_in),
    .io_out(RetimeWrapper_3_io_out)
  );
  bbox_RetimeWrapper_95 RetimeWrapper_4 ( // @[package.scala 93:22:@10878.4]
    .clock(RetimeWrapper_4_clock),
    .reset(RetimeWrapper_4_reset),
    .io_flow(RetimeWrapper_4_io_flow),
    .io_in(RetimeWrapper_4_io_in),
    .io_out(RetimeWrapper_4_io_out)
  );
  assign _T_80 = ~ io_ctrDone; // @[Controllers.scala 264:48:@10791.4]
  assign _T_81 = io_enable & _T_80; // @[Controllers.scala 264:46:@10792.4]
  assign _T_82 = ~ done_io_output; // @[Controllers.scala 264:62:@10793.4]
  assign _T_83 = _T_81 & _T_82; // @[Controllers.scala 264:60:@10794.4]
  assign _T_100 = io_ctrDone == 1'h0; // @[package.scala 100:49:@10811.4]
  assign _T_108 = RetimeWrapper_io_out; // @[package.scala 96:25:@10825.4 package.scala 96:25:@10826.4]
  assign _T_110 = _T_108 == 1'h0; // @[package.scala 100:49:@10827.4]
  assign _T_114 = _T_108 & _T_113; // @[package.scala 100:41:@10830.4]
  assign _T_118 = active_io_output & _T_82; // @[Controllers.scala 283:41:@10835.4]
  assign _T_119 = _T_118 & io_enable; // @[Controllers.scala 283:59:@10836.4]
  assign _T_121 = active_io_output & io_enable; // @[Controllers.scala 284:37:@10839.4]
  assign _T_124 = RetimeWrapper_1_io_out; // @[package.scala 96:25:@10847.4 package.scala 96:25:@10848.4]
  assign _T_126 = _T_124 == 1'h0; // @[package.scala 100:49:@10849.4]
  assign _T_150 = done_io_output == 1'h0; // @[package.scala 100:49:@10874.4]
  assign _T_156 = RetimeWrapper_4_io_out; // @[package.scala 96:25:@10883.4 package.scala 96:25:@10884.4]
  assign _T_158 = _T_156 ? 1'h1 : _T_146; // @[Controllers.scala 292:61:@10885.4]
  assign _T_159 = io_parentAck ? 1'h0 : _T_158; // @[Controllers.scala 292:24:@10886.4]
  assign io_done = _T_124 & _T_129; // @[Controllers.scala 287:13:@10853.4]
  assign io_doneLatch = _T_146; // @[Controllers.scala 293:18:@10888.4]
  assign io_datapathEn = _T_119 & io_backpressure; // @[Controllers.scala 283:21:@10838.4]
  assign io_ctrInc = _T_121 & io_backpressure; // @[Controllers.scala 284:17:@10841.4]
  assign io_ctrRst = _T_114 | io_parentAck; // @[Controllers.scala 274:13:@10833.4]
  assign active_clock = clock; // @[:@10784.4]
  assign active_reset = reset; // @[:@10785.4]
  assign active_io_input_set = _T_83 & io_backpressure; // @[Controllers.scala 264:23:@10796.4]
  assign active_io_input_reset = io_ctrDone | io_parentAck; // @[Controllers.scala 265:25:@10800.4]
  assign active_io_input_asyn_reset = 1'h0; // @[Controllers.scala 266:30:@10801.4]
  assign done_clock = clock; // @[:@10787.4]
  assign done_reset = reset; // @[:@10788.4]
  assign done_io_input_set = io_ctrDone & _T_103; // @[Controllers.scala 269:104:@10816.4]
  assign done_io_input_reset = io_parentAck; // @[Controllers.scala 267:23:@10809.4]
  assign done_io_input_asyn_reset = 1'h0; // @[Controllers.scala 268:28:@10810.4]
  assign RetimeWrapper_clock = clock; // @[:@10821.4]
  assign RetimeWrapper_reset = reset; // @[:@10822.4]
  assign RetimeWrapper_io_flow = io_backpressure; // @[package.scala 95:18:@10824.4]
  assign RetimeWrapper_io_in = done_io_output; // @[package.scala 94:16:@10823.4]
  assign RetimeWrapper_1_clock = clock; // @[:@10843.4]
  assign RetimeWrapper_1_reset = reset; // @[:@10844.4]
  assign RetimeWrapper_1_io_flow = io_backpressure; // @[package.scala 95:18:@10846.4]
  assign RetimeWrapper_1_io_in = done_io_output; // @[package.scala 94:16:@10845.4]
  assign RetimeWrapper_2_clock = clock; // @[:@10855.4]
  assign RetimeWrapper_2_reset = reset; // @[:@10856.4]
  assign RetimeWrapper_2_io_flow = 1'h1; // @[package.scala 95:18:@10858.4]
  assign RetimeWrapper_2_io_in = 1'h0; // @[package.scala 94:16:@10857.4]
  assign RetimeWrapper_3_clock = clock; // @[:@10863.4]
  assign RetimeWrapper_3_reset = reset; // @[:@10864.4]
  assign RetimeWrapper_3_io_flow = 1'h1; // @[package.scala 95:18:@10866.4]
  assign RetimeWrapper_3_io_in = io_ctrDone; // @[package.scala 94:16:@10865.4]
  assign RetimeWrapper_4_clock = clock; // @[:@10879.4]
  assign RetimeWrapper_4_reset = reset; // @[:@10880.4]
  assign RetimeWrapper_4_io_flow = io_backpressure; // @[package.scala 95:18:@10882.4]
  assign RetimeWrapper_4_io_in = done_io_output & _T_153; // @[package.scala 94:16:@10881.4]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  _T_103 = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  _T_113 = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  _T_129 = _RAND_2[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  _T_146 = _RAND_3[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{`RANDOM}};
  _T_153 = _RAND_4[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      _T_103 <= 1'h0;
    end else begin
      _T_103 <= _T_100;
    end
    if (reset) begin
      _T_113 <= 1'h0;
    end else begin
      _T_113 <= _T_110;
    end
    if (reset) begin
      _T_129 <= 1'h0;
    end else begin
      _T_129 <= _T_126;
    end
    if (reset) begin
      _T_146 <= 1'h0;
    end else begin
      if (io_parentAck) begin
        _T_146 <= 1'h0;
      end else begin
        if (_T_156) begin
          _T_146 <= 1'h1;
        end
      end
    end
    if (reset) begin
      _T_153 <= 1'h0;
    end else begin
      _T_153 <= _T_150;
    end
  end
endmodule
module bbox_SimBlackBoxesfix2fixBox_3( // @[:@11096.2]
  input  [31:0] io_a, // @[:@11099.4]
  output [15:0] io_b // @[:@11099.4]
);
  assign io_b = io_a[15:0]; // @[SimBlackBoxes.scala 99:40:@11109.4]
endmodule
module bbox_x106( // @[:@11111.2]
  input  [31:0] io_b, // @[:@11114.4]
  output [15:0] io_result // @[:@11114.4]
);
  wire [31:0] SimBlackBoxesfix2fixBox_io_a; // @[BigIPSim.scala 239:30:@11119.4]
  wire [15:0] SimBlackBoxesfix2fixBox_io_b; // @[BigIPSim.scala 239:30:@11119.4]
  bbox_SimBlackBoxesfix2fixBox_3 SimBlackBoxesfix2fixBox ( // @[BigIPSim.scala 239:30:@11119.4]
    .io_a(SimBlackBoxesfix2fixBox_io_a),
    .io_b(SimBlackBoxesfix2fixBox_io_b)
  );
  assign io_result = SimBlackBoxesfix2fixBox_io_b; // @[Math.scala 706:17:@11132.4]
  assign SimBlackBoxesfix2fixBox_io_a = io_b; // @[BigIPSim.scala 241:23:@11127.4]
endmodule
module bbox_RetimeWrapper_122( // @[:@11146.2]
  input         clock, // @[:@11147.4]
  input         reset, // @[:@11148.4]
  input         io_flow, // @[:@11149.4]
  input  [31:0] io_in, // @[:@11149.4]
  output [31:0] io_out // @[:@11149.4]
);
  wire [31:0] sr_out; // @[RetimeShiftRegister.scala 15:20:@11151.4]
  wire [31:0] sr_in; // @[RetimeShiftRegister.scala 15:20:@11151.4]
  wire [31:0] sr_init; // @[RetimeShiftRegister.scala 15:20:@11151.4]
  wire  sr_flow; // @[RetimeShiftRegister.scala 15:20:@11151.4]
  wire  sr_reset; // @[RetimeShiftRegister.scala 15:20:@11151.4]
  wire  sr_clock; // @[RetimeShiftRegister.scala 15:20:@11151.4]
  RetimeShiftRegister #(.WIDTH(32), .STAGES(3)) sr ( // @[RetimeShiftRegister.scala 15:20:@11151.4]
    .out(sr_out),
    .in(sr_in),
    .init(sr_init),
    .flow(sr_flow),
    .reset(sr_reset),
    .clock(sr_clock)
  );
  assign io_out = sr_out; // @[RetimeShiftRegister.scala 21:12:@11164.4]
  assign sr_in = io_in; // @[RetimeShiftRegister.scala 20:14:@11163.4]
  assign sr_init = 32'h0; // @[RetimeShiftRegister.scala 19:16:@11162.4]
  assign sr_flow = io_flow; // @[RetimeShiftRegister.scala 18:16:@11161.4]
  assign sr_reset = reset; // @[RetimeShiftRegister.scala 17:17:@11160.4]
  assign sr_clock = clock; // @[RetimeShiftRegister.scala 16:17:@11158.4]
endmodule
module bbox_fix2fixBox( // @[:@11230.2]
  input  [15:0] io_a, // @[:@11233.4]
  output [15:0] io_b // @[:@11233.4]
);
  assign io_b = io_a; // @[Converter.scala 95:38:@11243.4]
endmodule
module bbox_x108_mul( // @[:@11245.2]
  input         clock, // @[:@11246.4]
  input         reset, // @[:@11247.4]
  input  [15:0] io_a, // @[:@11248.4]
  input  [15:0] io_b, // @[:@11248.4]
  input         io_flow, // @[:@11248.4]
  output [15:0] io_result // @[:@11248.4]
);
  wire  RetimeWrapper_clock; // @[package.scala 93:22:@11256.4]
  wire  RetimeWrapper_reset; // @[package.scala 93:22:@11256.4]
  wire  RetimeWrapper_io_flow; // @[package.scala 93:22:@11256.4]
  wire [31:0] RetimeWrapper_io_in; // @[package.scala 93:22:@11256.4]
  wire [31:0] RetimeWrapper_io_out; // @[package.scala 93:22:@11256.4]
  wire  RetimeWrapper_1_clock; // @[package.scala 93:22:@11269.4]
  wire  RetimeWrapper_1_reset; // @[package.scala 93:22:@11269.4]
  wire  RetimeWrapper_1_io_flow; // @[package.scala 93:22:@11269.4]
  wire  RetimeWrapper_1_io_in; // @[package.scala 93:22:@11269.4]
  wire  RetimeWrapper_1_io_out; // @[package.scala 93:22:@11269.4]
  wire  RetimeWrapper_2_clock; // @[package.scala 93:22:@11280.4]
  wire  RetimeWrapper_2_reset; // @[package.scala 93:22:@11280.4]
  wire  RetimeWrapper_2_io_flow; // @[package.scala 93:22:@11280.4]
  wire  RetimeWrapper_2_io_in; // @[package.scala 93:22:@11280.4]
  wire  RetimeWrapper_2_io_out; // @[package.scala 93:22:@11280.4]
  wire [15:0] fix2fixBox_io_a; // @[Math.scala 253:30:@11287.4]
  wire [15:0] fix2fixBox_io_b; // @[Math.scala 253:30:@11287.4]
  wire [31:0] _T_18; // @[package.scala 96:25:@11261.4 package.scala 96:25:@11262.4]
  wire  _T_21; // @[FixedPoint.scala 50:25:@11266.4]
  wire  _T_22; // @[FixedPoint.scala 50:25:@11267.4]
  wire  _T_23; // @[Math.scala 251:56:@11268.4]
  bbox_RetimeWrapper_122 RetimeWrapper ( // @[package.scala 93:22:@11256.4]
    .clock(RetimeWrapper_clock),
    .reset(RetimeWrapper_reset),
    .io_flow(RetimeWrapper_io_flow),
    .io_in(RetimeWrapper_io_in),
    .io_out(RetimeWrapper_io_out)
  );
  bbox_RetimeWrapper_95 RetimeWrapper_1 ( // @[package.scala 93:22:@11269.4]
    .clock(RetimeWrapper_1_clock),
    .reset(RetimeWrapper_1_reset),
    .io_flow(RetimeWrapper_1_io_flow),
    .io_in(RetimeWrapper_1_io_in),
    .io_out(RetimeWrapper_1_io_out)
  );
  bbox_RetimeWrapper_95 RetimeWrapper_2 ( // @[package.scala 93:22:@11280.4]
    .clock(RetimeWrapper_2_clock),
    .reset(RetimeWrapper_2_reset),
    .io_flow(RetimeWrapper_2_io_flow),
    .io_in(RetimeWrapper_2_io_in),
    .io_out(RetimeWrapper_2_io_out)
  );
  bbox_fix2fixBox fix2fixBox ( // @[Math.scala 253:30:@11287.4]
    .io_a(fix2fixBox_io_a),
    .io_b(fix2fixBox_io_b)
  );
  assign _T_18 = RetimeWrapper_io_out; // @[package.scala 96:25:@11261.4 package.scala 96:25:@11262.4]
  assign _T_21 = io_a[15]; // @[FixedPoint.scala 50:25:@11266.4]
  assign _T_22 = io_b[15]; // @[FixedPoint.scala 50:25:@11267.4]
  assign _T_23 = _T_21 ^ _T_22; // @[Math.scala 251:56:@11268.4]
  assign io_result = fix2fixBox_io_b; // @[Math.scala 259:17:@11295.4]
  assign RetimeWrapper_clock = clock; // @[:@11257.4]
  assign RetimeWrapper_reset = reset; // @[:@11258.4]
  assign RetimeWrapper_io_flow = io_flow; // @[package.scala 95:18:@11260.4]
  assign RetimeWrapper_io_in = io_a * io_b; // @[package.scala 94:16:@11259.4]
  assign RetimeWrapper_1_clock = clock; // @[:@11270.4]
  assign RetimeWrapper_1_reset = reset; // @[:@11271.4]
  assign RetimeWrapper_1_io_flow = 1'h1; // @[package.scala 95:18:@11273.4]
  assign RetimeWrapper_1_io_in = _T_21 ^ _T_22; // @[package.scala 94:16:@11272.4]
  assign RetimeWrapper_2_clock = clock; // @[:@11281.4]
  assign RetimeWrapper_2_reset = reset; // @[:@11282.4]
  assign RetimeWrapper_2_io_flow = 1'h1; // @[package.scala 95:18:@11284.4]
  assign RetimeWrapper_2_io_in = _T_23 == 1'h0; // @[package.scala 94:16:@11283.4]
  assign fix2fixBox_io_a = _T_18[15:0]; // @[Math.scala 254:23:@11290.4]
endmodule
module bbox_x118_inr_Foreach_kernelx118_inr_Foreach_concrete1( // @[:@11489.2]
  input         clock, // @[:@11490.4]
  input         reset, // @[:@11491.4]
  input  [31:0] io_in_x88_reg_rPort_0_output_0, // @[:@11492.4]
  output        io_in_x88_reg_sEn_1, // @[:@11492.4]
  output        io_in_x88_reg_sDone_1, // @[:@11492.4]
  output [31:0] io_in_x78_index_0_wPort_0_data_0, // @[:@11492.4]
  output        io_in_x78_index_0_wPort_0_en_0, // @[:@11492.4]
  input         io_in_x78_index_0_full, // @[:@11492.4]
  input         io_in_x78_index_0_accessActivesOut_0, // @[:@11492.4]
  output        io_in_x78_index_0_accessActivesIn_0, // @[:@11492.4]
  input  [15:0] io_in_x89_reg_rPort_0_output_0, // @[:@11492.4]
  output        io_in_x89_reg_sEn_1, // @[:@11492.4]
  output        io_in_x89_reg_sDone_1, // @[:@11492.4]
  output [31:0] io_in_x80_numelOut_0_wPort_0_data_0, // @[:@11492.4]
  output        io_in_x80_numelOut_0_wPort_0_en_0, // @[:@11492.4]
  input         io_in_x80_numelOut_0_full, // @[:@11492.4]
  input         io_in_x80_numelOut_0_accessActivesOut_0, // @[:@11492.4]
  output        io_in_x80_numelOut_0_accessActivesIn_0, // @[:@11492.4]
  input         io_in_b87, // @[:@11492.4]
  output [15:0] io_in_x79_payload_0_wPort_0_data_0, // @[:@11492.4]
  output        io_in_x79_payload_0_wPort_0_en_0, // @[:@11492.4]
  input         io_in_x79_payload_0_full, // @[:@11492.4]
  input         io_in_x79_payload_0_accessActivesOut_0, // @[:@11492.4]
  output        io_in_x79_payload_0_accessActivesIn_0, // @[:@11492.4]
  output        io_in_x90_reg_sEn_1, // @[:@11492.4]
  output        io_in_x90_reg_sDone_1, // @[:@11492.4]
  input         io_sigsIn_done, // @[:@11492.4]
  input         io_sigsIn_backpressure, // @[:@11492.4]
  input         io_sigsIn_datapathEn, // @[:@11492.4]
  input         io_sigsIn_baseEn, // @[:@11492.4]
  input         io_sigsIn_break, // @[:@11492.4]
  input  [31:0] io_sigsIn_cchainOutputs_0_counts_0, // @[:@11492.4]
  input         io_sigsIn_cchainOutputs_0_oobs_0, // @[:@11492.4]
  input         io_rr // @[:@11492.4]
);
  wire [31:0] __io_b; // @[Math.scala 709:24:@11650.4]
  wire [31:0] __io_result; // @[Math.scala 709:24:@11650.4]
  wire [31:0] x106_1_io_b; // @[Math.scala 709:24:@11690.4]
  wire [15:0] x106_1_io_result; // @[Math.scala 709:24:@11690.4]
  wire  x108_mul_1_clock; // @[Math.scala 262:24:@11709.4]
  wire  x108_mul_1_reset; // @[Math.scala 262:24:@11709.4]
  wire [15:0] x108_mul_1_io_a; // @[Math.scala 262:24:@11709.4]
  wire [15:0] x108_mul_1_io_b; // @[Math.scala 262:24:@11709.4]
  wire  x108_mul_1_io_flow; // @[Math.scala 262:24:@11709.4]
  wire [15:0] x108_mul_1_io_result; // @[Math.scala 262:24:@11709.4]
  wire  RetimeWrapper_clock; // @[package.scala 93:22:@11719.4]
  wire  RetimeWrapper_reset; // @[package.scala 93:22:@11719.4]
  wire  RetimeWrapper_io_flow; // @[package.scala 93:22:@11719.4]
  wire  RetimeWrapper_io_in; // @[package.scala 93:22:@11719.4]
  wire  RetimeWrapper_io_out; // @[package.scala 93:22:@11719.4]
  wire  RetimeWrapper_1_clock; // @[package.scala 93:22:@11728.4]
  wire  RetimeWrapper_1_reset; // @[package.scala 93:22:@11728.4]
  wire  RetimeWrapper_1_io_flow; // @[package.scala 93:22:@11728.4]
  wire  RetimeWrapper_1_io_in; // @[package.scala 93:22:@11728.4]
  wire  RetimeWrapper_1_io_out; // @[package.scala 93:22:@11728.4]
  wire  RetimeWrapper_2_clock; // @[package.scala 93:22:@11739.4]
  wire  RetimeWrapper_2_reset; // @[package.scala 93:22:@11739.4]
  wire  RetimeWrapper_2_io_flow; // @[package.scala 93:22:@11739.4]
  wire  RetimeWrapper_2_io_in; // @[package.scala 93:22:@11739.4]
  wire  RetimeWrapper_2_io_out; // @[package.scala 93:22:@11739.4]
  wire  RetimeWrapper_3_clock; // @[package.scala 93:22:@11797.4]
  wire  RetimeWrapper_3_reset; // @[package.scala 93:22:@11797.4]
  wire  RetimeWrapper_3_io_flow; // @[package.scala 93:22:@11797.4]
  wire  RetimeWrapper_3_io_in; // @[package.scala 93:22:@11797.4]
  wire  RetimeWrapper_3_io_out; // @[package.scala 93:22:@11797.4]
  wire  RetimeWrapper_4_clock; // @[package.scala 93:22:@11807.4]
  wire  RetimeWrapper_4_reset; // @[package.scala 93:22:@11807.4]
  wire  RetimeWrapper_4_io_flow; // @[package.scala 93:22:@11807.4]
  wire  RetimeWrapper_4_io_in; // @[package.scala 93:22:@11807.4]
  wire  RetimeWrapper_4_io_out; // @[package.scala 93:22:@11807.4]
  wire  RetimeWrapper_5_clock; // @[package.scala 93:22:@11817.4]
  wire  RetimeWrapper_5_reset; // @[package.scala 93:22:@11817.4]
  wire  RetimeWrapper_5_io_flow; // @[package.scala 93:22:@11817.4]
  wire  RetimeWrapper_5_io_in; // @[package.scala 93:22:@11817.4]
  wire  RetimeWrapper_5_io_out; // @[package.scala 93:22:@11817.4]
  wire  b104; // @[sm_x118_inr_Foreach.scala 83:18:@11658.4]
  wire  _T_1218; // @[sm_x118_inr_Foreach.scala 88:121:@11659.4]
  wire  _T_1222; // @[implicits.scala 55:10:@11662.4]
  wire  _T_1223; // @[sm_x118_inr_Foreach.scala 88:138:@11663.4]
  wire  _T_1225; // @[sm_x118_inr_Foreach.scala 88:225:@11665.4]
  wire  _T_1226; // @[sm_x118_inr_Foreach.scala 88:244:@11666.4]
  wire  _T_1229; // @[sm_x118_inr_Foreach.scala 88:280:@11668.4]
  wire  _T_1236; // @[sm_x118_inr_Foreach.scala 92:18:@11678.4]
  wire  _T_1237; // @[sm_x118_inr_Foreach.scala 92:39:@11679.4]
  wire  _T_1238; // @[sm_x118_inr_Foreach.scala 92:37:@11680.4]
  wire  _T_1239; // @[sm_x118_inr_Foreach.scala 92:79:@11681.4]
  wire  _T_1240; // @[sm_x118_inr_Foreach.scala 92:102:@11682.4]
  wire  _T_1241; // @[sm_x118_inr_Foreach.scala 92:100:@11683.4]
  wire  _T_1242; // @[sm_x118_inr_Foreach.scala 92:76:@11684.4]
  wire  _T_1243; // @[sm_x118_inr_Foreach.scala 92:144:@11685.4]
  wire  _T_1244; // @[sm_x118_inr_Foreach.scala 92:166:@11686.4]
  wire  _T_1245; // @[sm_x118_inr_Foreach.scala 92:164:@11687.4]
  wire  _T_1271; // @[package.scala 96:25:@11744.4 package.scala 96:25:@11745.4]
  wire  _T_1273; // @[implicits.scala 55:10:@11746.4]
  wire  _T_1274; // @[sm_x118_inr_Foreach.scala 109:137:@11747.4]
  wire  _T_1276; // @[sm_x118_inr_Foreach.scala 109:224:@11749.4]
  wire  _T_1277; // @[sm_x118_inr_Foreach.scala 109:243:@11750.4]
  wire  x145_b104_D3; // @[package.scala 96:25:@11733.4 package.scala 96:25:@11734.4]
  wire  _T_1280; // @[sm_x118_inr_Foreach.scala 109:279:@11752.4]
  wire  x144_b87_D3; // @[package.scala 96:25:@11724.4 package.scala 96:25:@11725.4]
  wire [31:0] b103_number; // @[Math.scala 712:22:@11655.4 Math.scala 713:14:@11656.4]
  wire [31:0] _T_1290; // @[Math.scala 499:37:@11763.4]
  wire  x110; // @[Math.scala 499:44:@11765.4]
  wire [32:0] _GEN_0; // @[Math.scala 450:32:@11779.4]
  wire [32:0] _T_1305; // @[Math.scala 450:32:@11779.4]
  wire  _T_1321; // @[package.scala 96:25:@11802.4 package.scala 96:25:@11803.4]
  wire  _T_1325; // @[package.scala 96:25:@11812.4 package.scala 96:25:@11813.4]
  wire  _T_1329; // @[package.scala 96:25:@11822.4 package.scala 96:25:@11823.4]
  _ _ ( // @[Math.scala 709:24:@11650.4]
    .io_b(__io_b),
    .io_result(__io_result)
  );
  bbox_x106 x106_1 ( // @[Math.scala 709:24:@11690.4]
    .io_b(x106_1_io_b),
    .io_result(x106_1_io_result)
  );
  bbox_x108_mul x108_mul_1 ( // @[Math.scala 262:24:@11709.4]
    .clock(x108_mul_1_clock),
    .reset(x108_mul_1_reset),
    .io_a(x108_mul_1_io_a),
    .io_b(x108_mul_1_io_b),
    .io_flow(x108_mul_1_io_flow),
    .io_result(x108_mul_1_io_result)
  );
  bbox_RetimeWrapper_95 RetimeWrapper ( // @[package.scala 93:22:@11719.4]
    .clock(RetimeWrapper_clock),
    .reset(RetimeWrapper_reset),
    .io_flow(RetimeWrapper_io_flow),
    .io_in(RetimeWrapper_io_in),
    .io_out(RetimeWrapper_io_out)
  );
  bbox_RetimeWrapper_95 RetimeWrapper_1 ( // @[package.scala 93:22:@11728.4]
    .clock(RetimeWrapper_1_clock),
    .reset(RetimeWrapper_1_reset),
    .io_flow(RetimeWrapper_1_io_flow),
    .io_in(RetimeWrapper_1_io_in),
    .io_out(RetimeWrapper_1_io_out)
  );
  bbox_RetimeWrapper_95 RetimeWrapper_2 ( // @[package.scala 93:22:@11739.4]
    .clock(RetimeWrapper_2_clock),
    .reset(RetimeWrapper_2_reset),
    .io_flow(RetimeWrapper_2_io_flow),
    .io_in(RetimeWrapper_2_io_in),
    .io_out(RetimeWrapper_2_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_3 ( // @[package.scala 93:22:@11797.4]
    .clock(RetimeWrapper_3_clock),
    .reset(RetimeWrapper_3_reset),
    .io_flow(RetimeWrapper_3_io_flow),
    .io_in(RetimeWrapper_3_io_in),
    .io_out(RetimeWrapper_3_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_4 ( // @[package.scala 93:22:@11807.4]
    .clock(RetimeWrapper_4_clock),
    .reset(RetimeWrapper_4_reset),
    .io_flow(RetimeWrapper_4_io_flow),
    .io_in(RetimeWrapper_4_io_in),
    .io_out(RetimeWrapper_4_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_5 ( // @[package.scala 93:22:@11817.4]
    .clock(RetimeWrapper_5_clock),
    .reset(RetimeWrapper_5_reset),
    .io_flow(RetimeWrapper_5_io_flow),
    .io_in(RetimeWrapper_5_io_in),
    .io_out(RetimeWrapper_5_io_out)
  );
  assign b104 = ~ io_sigsIn_cchainOutputs_0_oobs_0; // @[sm_x118_inr_Foreach.scala 83:18:@11658.4]
  assign _T_1218 = ~ io_sigsIn_break; // @[sm_x118_inr_Foreach.scala 88:121:@11659.4]
  assign _T_1222 = io_rr ? io_sigsIn_datapathEn : 1'h0; // @[implicits.scala 55:10:@11662.4]
  assign _T_1223 = _T_1218 & _T_1222; // @[sm_x118_inr_Foreach.scala 88:138:@11663.4]
  assign _T_1225 = _T_1223 & _T_1218; // @[sm_x118_inr_Foreach.scala 88:225:@11665.4]
  assign _T_1226 = _T_1225 & io_sigsIn_backpressure; // @[sm_x118_inr_Foreach.scala 88:244:@11666.4]
  assign _T_1229 = _T_1226 & b104; // @[sm_x118_inr_Foreach.scala 88:280:@11668.4]
  assign _T_1236 = ~ io_in_x79_payload_0_full; // @[sm_x118_inr_Foreach.scala 92:18:@11678.4]
  assign _T_1237 = ~ io_in_x79_payload_0_accessActivesOut_0; // @[sm_x118_inr_Foreach.scala 92:39:@11679.4]
  assign _T_1238 = _T_1236 | _T_1237; // @[sm_x118_inr_Foreach.scala 92:37:@11680.4]
  assign _T_1239 = ~ io_in_x80_numelOut_0_full; // @[sm_x118_inr_Foreach.scala 92:79:@11681.4]
  assign _T_1240 = ~ io_in_x80_numelOut_0_accessActivesOut_0; // @[sm_x118_inr_Foreach.scala 92:102:@11682.4]
  assign _T_1241 = _T_1239 | _T_1240; // @[sm_x118_inr_Foreach.scala 92:100:@11683.4]
  assign _T_1242 = _T_1238 & _T_1241; // @[sm_x118_inr_Foreach.scala 92:76:@11684.4]
  assign _T_1243 = ~ io_in_x78_index_0_full; // @[sm_x118_inr_Foreach.scala 92:144:@11685.4]
  assign _T_1244 = ~ io_in_x78_index_0_accessActivesOut_0; // @[sm_x118_inr_Foreach.scala 92:166:@11686.4]
  assign _T_1245 = _T_1243 | _T_1244; // @[sm_x118_inr_Foreach.scala 92:164:@11687.4]
  assign _T_1271 = RetimeWrapper_2_io_out; // @[package.scala 96:25:@11744.4 package.scala 96:25:@11745.4]
  assign _T_1273 = io_rr ? _T_1271 : 1'h0; // @[implicits.scala 55:10:@11746.4]
  assign _T_1274 = _T_1218 & _T_1273; // @[sm_x118_inr_Foreach.scala 109:137:@11747.4]
  assign _T_1276 = _T_1274 & _T_1218; // @[sm_x118_inr_Foreach.scala 109:224:@11749.4]
  assign _T_1277 = _T_1276 & io_sigsIn_backpressure; // @[sm_x118_inr_Foreach.scala 109:243:@11750.4]
  assign x145_b104_D3 = RetimeWrapper_1_io_out; // @[package.scala 96:25:@11733.4 package.scala 96:25:@11734.4]
  assign _T_1280 = _T_1277 & x145_b104_D3; // @[sm_x118_inr_Foreach.scala 109:279:@11752.4]
  assign x144_b87_D3 = RetimeWrapper_io_out; // @[package.scala 96:25:@11724.4 package.scala 96:25:@11725.4]
  assign b103_number = __io_result; // @[Math.scala 712:22:@11655.4 Math.scala 713:14:@11656.4]
  assign _T_1290 = $signed(b103_number); // @[Math.scala 499:37:@11763.4]
  assign x110 = $signed(_T_1290) == $signed(32'sh0); // @[Math.scala 499:44:@11765.4]
  assign _GEN_0 = {{1'd0}, io_in_x88_reg_rPort_0_output_0}; // @[Math.scala 450:32:@11779.4]
  assign _T_1305 = _GEN_0 << 1; // @[Math.scala 450:32:@11779.4]
  assign _T_1321 = RetimeWrapper_3_io_out; // @[package.scala 96:25:@11802.4 package.scala 96:25:@11803.4]
  assign _T_1325 = RetimeWrapper_4_io_out; // @[package.scala 96:25:@11812.4 package.scala 96:25:@11813.4]
  assign _T_1329 = RetimeWrapper_5_io_out; // @[package.scala 96:25:@11822.4 package.scala 96:25:@11823.4]
  assign io_in_x88_reg_sEn_1 = io_sigsIn_baseEn; // @[MemInterfaceType.scala 183:15:@11805.4]
  assign io_in_x88_reg_sDone_1 = io_rr ? _T_1321 : 1'h0; // @[MemInterfaceType.scala 184:17:@11806.4]
  assign io_in_x78_index_0_wPort_0_data_0 = __io_result; // @[MemInterfaceType.scala 90:56:@11670.4]
  assign io_in_x78_index_0_wPort_0_en_0 = _T_1229 & io_in_b87; // @[MemInterfaceType.scala 93:57:@11672.4]
  assign io_in_x78_index_0_accessActivesIn_0 = b104 & io_in_b87; // @[MemInterfaceType.scala 148:24:@11675.4]
  assign io_in_x89_reg_sEn_1 = io_sigsIn_baseEn; // @[MemInterfaceType.scala 183:15:@11815.4]
  assign io_in_x89_reg_sDone_1 = io_rr ? _T_1325 : 1'h0; // @[MemInterfaceType.scala 184:17:@11816.4]
  assign io_in_x80_numelOut_0_wPort_0_data_0 = _T_1305[31:0]; // @[MemInterfaceType.scala 90:56:@11792.4]
  assign io_in_x80_numelOut_0_wPort_0_en_0 = _T_1226 & x110; // @[MemInterfaceType.scala 93:57:@11794.4]
  assign io_in_x80_numelOut_0_accessActivesIn_0 = $signed(_T_1290) == $signed(32'sh0); // @[MemInterfaceType.scala 148:24:@11796.4]
  assign io_in_x79_payload_0_wPort_0_data_0 = x108_mul_1_io_result; // @[MemInterfaceType.scala 90:56:@11754.4]
  assign io_in_x79_payload_0_wPort_0_en_0 = _T_1280 & x144_b87_D3; // @[MemInterfaceType.scala 93:57:@11756.4]
  assign io_in_x79_payload_0_accessActivesIn_0 = x145_b104_D3 & x144_b87_D3; // @[MemInterfaceType.scala 148:24:@11759.4]
  assign io_in_x90_reg_sEn_1 = io_sigsIn_baseEn; // @[MemInterfaceType.scala 183:15:@11825.4]
  assign io_in_x90_reg_sDone_1 = io_rr ? _T_1329 : 1'h0; // @[MemInterfaceType.scala 184:17:@11826.4]
  assign __io_b = $unsigned(io_sigsIn_cchainOutputs_0_counts_0); // @[Math.scala 710:17:@11653.4]
  assign x106_1_io_b = __io_result; // @[Math.scala 710:17:@11693.4]
  assign x108_mul_1_clock = clock; // @[:@11710.4]
  assign x108_mul_1_reset = reset; // @[:@11711.4]
  assign x108_mul_1_io_a = x106_1_io_result; // @[Math.scala 263:17:@11712.4]
  assign x108_mul_1_io_b = io_in_x89_reg_rPort_0_output_0; // @[Math.scala 264:17:@11713.4]
  assign x108_mul_1_io_flow = _T_1242 & _T_1245; // @[Math.scala 265:20:@11714.4]
  assign RetimeWrapper_clock = clock; // @[:@11720.4]
  assign RetimeWrapper_reset = reset; // @[:@11721.4]
  assign RetimeWrapper_io_flow = io_sigsIn_backpressure; // @[package.scala 95:18:@11723.4]
  assign RetimeWrapper_io_in = io_in_b87; // @[package.scala 94:16:@11722.4]
  assign RetimeWrapper_1_clock = clock; // @[:@11729.4]
  assign RetimeWrapper_1_reset = reset; // @[:@11730.4]
  assign RetimeWrapper_1_io_flow = io_sigsIn_backpressure; // @[package.scala 95:18:@11732.4]
  assign RetimeWrapper_1_io_in = ~ io_sigsIn_cchainOutputs_0_oobs_0; // @[package.scala 94:16:@11731.4]
  assign RetimeWrapper_2_clock = clock; // @[:@11740.4]
  assign RetimeWrapper_2_reset = reset; // @[:@11741.4]
  assign RetimeWrapper_2_io_flow = io_sigsIn_backpressure; // @[package.scala 95:18:@11743.4]
  assign RetimeWrapper_2_io_in = io_sigsIn_datapathEn; // @[package.scala 94:16:@11742.4]
  assign RetimeWrapper_3_clock = clock; // @[:@11798.4]
  assign RetimeWrapper_3_reset = reset; // @[:@11799.4]
  assign RetimeWrapper_3_io_flow = io_sigsIn_backpressure; // @[package.scala 95:18:@11801.4]
  assign RetimeWrapper_3_io_in = io_sigsIn_done; // @[package.scala 94:16:@11800.4]
  assign RetimeWrapper_4_clock = clock; // @[:@11808.4]
  assign RetimeWrapper_4_reset = reset; // @[:@11809.4]
  assign RetimeWrapper_4_io_flow = io_sigsIn_backpressure; // @[package.scala 95:18:@11811.4]
  assign RetimeWrapper_4_io_in = io_sigsIn_done; // @[package.scala 94:16:@11810.4]
  assign RetimeWrapper_5_clock = clock; // @[:@11818.4]
  assign RetimeWrapper_5_reset = reset; // @[:@11819.4]
  assign RetimeWrapper_5_io_flow = io_sigsIn_backpressure; // @[package.scala 95:18:@11821.4]
  assign RetimeWrapper_5_io_in = io_sigsIn_done; // @[package.scala 94:16:@11820.4]
endmodule
module bbox_x119_outr_Foreach_kernelx119_outr_Foreach_concrete1( // @[:@11828.2]
  input         clock, // @[:@11829.4]
  input         reset, // @[:@11830.4]
  output [31:0] io_in_x78_index_0_wPort_0_data_0, // @[:@11831.4]
  output        io_in_x78_index_0_wPort_0_en_0, // @[:@11831.4]
  input         io_in_x78_index_0_full, // @[:@11831.4]
  input         io_in_x78_index_0_accessActivesOut_0, // @[:@11831.4]
  output        io_in_x78_index_0_accessActivesIn_0, // @[:@11831.4]
  output        io_in_x77_scalar_0_rPort_0_en_0, // @[:@11831.4]
  input  [15:0] io_in_x77_scalar_0_rPort_0_output_0, // @[:@11831.4]
  input         io_in_x77_scalar_0_empty, // @[:@11831.4]
  output        io_in_x76_numel_0_rPort_0_en_0, // @[:@11831.4]
  input  [31:0] io_in_x76_numel_0_rPort_0_output_0, // @[:@11831.4]
  input         io_in_x76_numel_0_empty, // @[:@11831.4]
  output [31:0] io_in_x80_numelOut_0_wPort_0_data_0, // @[:@11831.4]
  output        io_in_x80_numelOut_0_wPort_0_en_0, // @[:@11831.4]
  input         io_in_x80_numelOut_0_full, // @[:@11831.4]
  input         io_in_x80_numelOut_0_accessActivesOut_0, // @[:@11831.4]
  output        io_in_x80_numelOut_0_accessActivesIn_0, // @[:@11831.4]
  output [15:0] io_in_x79_payload_0_wPort_0_data_0, // @[:@11831.4]
  output        io_in_x79_payload_0_wPort_0_en_0, // @[:@11831.4]
  input         io_in_x79_payload_0_full, // @[:@11831.4]
  input         io_in_x79_payload_0_accessActivesOut_0, // @[:@11831.4]
  output        io_in_x79_payload_0_accessActivesIn_0, // @[:@11831.4]
  input         io_sigsIn_smEnableOuts_0, // @[:@11831.4]
  input         io_sigsIn_smEnableOuts_1, // @[:@11831.4]
  input         io_sigsIn_smChildAcks_0, // @[:@11831.4]
  input         io_sigsIn_smChildAcks_1, // @[:@11831.4]
  input  [31:0] io_sigsIn_cchainOutputs_0_counts_0, // @[:@11831.4]
  input         io_sigsIn_cchainOutputs_0_oobs_0, // @[:@11831.4]
  output        io_sigsOut_smDoneIn_0, // @[:@11831.4]
  output        io_sigsOut_smDoneIn_1, // @[:@11831.4]
  output        io_sigsOut_smMaskIn_0, // @[:@11831.4]
  output        io_sigsOut_smMaskIn_1, // @[:@11831.4]
  input         io_rr // @[:@11831.4]
);
  wire [31:0] __io_b; // @[Math.scala 709:24:@11957.4]
  wire [31:0] __io_result; // @[Math.scala 709:24:@11957.4]
  wire  b86_chain_clock; // @[sm_x119_outr_Foreach.scala 73:29:@11965.4]
  wire  b86_chain_reset; // @[sm_x119_outr_Foreach.scala 73:29:@11965.4]
  wire [31:0] b86_chain_io_rPort_0_output_0; // @[sm_x119_outr_Foreach.scala 73:29:@11965.4]
  wire [31:0] b86_chain_io_wPort_0_data_0; // @[sm_x119_outr_Foreach.scala 73:29:@11965.4]
  wire  b86_chain_io_wPort_0_reset; // @[sm_x119_outr_Foreach.scala 73:29:@11965.4]
  wire  b86_chain_io_wPort_0_en_0; // @[sm_x119_outr_Foreach.scala 73:29:@11965.4]
  wire  b86_chain_io_sEn_0; // @[sm_x119_outr_Foreach.scala 73:29:@11965.4]
  wire  b86_chain_io_sEn_1; // @[sm_x119_outr_Foreach.scala 73:29:@11965.4]
  wire  b86_chain_io_sDone_0; // @[sm_x119_outr_Foreach.scala 73:29:@11965.4]
  wire  b86_chain_io_sDone_1; // @[sm_x119_outr_Foreach.scala 73:29:@11965.4]
  wire  RetimeWrapper_clock; // @[package.scala 93:22:@11994.4]
  wire  RetimeWrapper_reset; // @[package.scala 93:22:@11994.4]
  wire  RetimeWrapper_io_flow; // @[package.scala 93:22:@11994.4]
  wire  RetimeWrapper_io_in; // @[package.scala 93:22:@11994.4]
  wire  RetimeWrapper_io_out; // @[package.scala 93:22:@11994.4]
  wire [31:0] __1_io_b; // @[Math.scala 709:24:@12006.4]
  wire [31:0] __1_io_result; // @[Math.scala 709:24:@12006.4]
  wire  b87_chain_clock; // @[sm_x119_outr_Foreach.scala 77:29:@12015.4]
  wire  b87_chain_reset; // @[sm_x119_outr_Foreach.scala 77:29:@12015.4]
  wire  b87_chain_io_rPort_0_output_0; // @[sm_x119_outr_Foreach.scala 77:29:@12015.4]
  wire  b87_chain_io_wPort_0_data_0; // @[sm_x119_outr_Foreach.scala 77:29:@12015.4]
  wire  b87_chain_io_wPort_0_reset; // @[sm_x119_outr_Foreach.scala 77:29:@12015.4]
  wire  b87_chain_io_wPort_0_en_0; // @[sm_x119_outr_Foreach.scala 77:29:@12015.4]
  wire  b87_chain_io_sEn_0; // @[sm_x119_outr_Foreach.scala 77:29:@12015.4]
  wire  b87_chain_io_sEn_1; // @[sm_x119_outr_Foreach.scala 77:29:@12015.4]
  wire  b87_chain_io_sDone_0; // @[sm_x119_outr_Foreach.scala 77:29:@12015.4]
  wire  b87_chain_io_sDone_1; // @[sm_x119_outr_Foreach.scala 77:29:@12015.4]
  wire  RetimeWrapper_1_clock; // @[package.scala 93:22:@12044.4]
  wire  RetimeWrapper_1_reset; // @[package.scala 93:22:@12044.4]
  wire  RetimeWrapper_1_io_flow; // @[package.scala 93:22:@12044.4]
  wire  RetimeWrapper_1_io_in; // @[package.scala 93:22:@12044.4]
  wire  RetimeWrapper_1_io_out; // @[package.scala 93:22:@12044.4]
  wire  x88_reg_clock; // @[m_x88_reg.scala 27:17:@12054.4]
  wire  x88_reg_reset; // @[m_x88_reg.scala 27:17:@12054.4]
  wire [31:0] x88_reg_io_rPort_0_output_0; // @[m_x88_reg.scala 27:17:@12054.4]
  wire [31:0] x88_reg_io_wPort_0_data_0; // @[m_x88_reg.scala 27:17:@12054.4]
  wire  x88_reg_io_wPort_0_reset; // @[m_x88_reg.scala 27:17:@12054.4]
  wire  x88_reg_io_wPort_0_en_0; // @[m_x88_reg.scala 27:17:@12054.4]
  wire  x88_reg_io_sEn_0; // @[m_x88_reg.scala 27:17:@12054.4]
  wire  x88_reg_io_sEn_1; // @[m_x88_reg.scala 27:17:@12054.4]
  wire  x88_reg_io_sDone_0; // @[m_x88_reg.scala 27:17:@12054.4]
  wire  x88_reg_io_sDone_1; // @[m_x88_reg.scala 27:17:@12054.4]
  wire  x89_reg_clock; // @[m_x89_reg.scala 27:17:@12084.4]
  wire  x89_reg_reset; // @[m_x89_reg.scala 27:17:@12084.4]
  wire [15:0] x89_reg_io_rPort_0_output_0; // @[m_x89_reg.scala 27:17:@12084.4]
  wire [15:0] x89_reg_io_wPort_0_data_0; // @[m_x89_reg.scala 27:17:@12084.4]
  wire  x89_reg_io_wPort_0_reset; // @[m_x89_reg.scala 27:17:@12084.4]
  wire  x89_reg_io_wPort_0_en_0; // @[m_x89_reg.scala 27:17:@12084.4]
  wire  x89_reg_io_sEn_0; // @[m_x89_reg.scala 27:17:@12084.4]
  wire  x89_reg_io_sEn_1; // @[m_x89_reg.scala 27:17:@12084.4]
  wire  x89_reg_io_sDone_0; // @[m_x89_reg.scala 27:17:@12084.4]
  wire  x89_reg_io_sDone_1; // @[m_x89_reg.scala 27:17:@12084.4]
  wire  x90_reg_clock; // @[m_x90_reg.scala 27:17:@12114.4]
  wire  x90_reg_reset; // @[m_x90_reg.scala 27:17:@12114.4]
  wire [31:0] x90_reg_io_rPort_0_output_0; // @[m_x90_reg.scala 27:17:@12114.4]
  wire [31:0] x90_reg_io_wPort_0_data_0; // @[m_x90_reg.scala 27:17:@12114.4]
  wire  x90_reg_io_wPort_0_reset; // @[m_x90_reg.scala 27:17:@12114.4]
  wire  x90_reg_io_wPort_0_en_0; // @[m_x90_reg.scala 27:17:@12114.4]
  wire  x90_reg_io_sEn_0; // @[m_x90_reg.scala 27:17:@12114.4]
  wire  x90_reg_io_sEn_1; // @[m_x90_reg.scala 27:17:@12114.4]
  wire  x90_reg_io_sDone_0; // @[m_x90_reg.scala 27:17:@12114.4]
  wire  x90_reg_io_sDone_1; // @[m_x90_reg.scala 27:17:@12114.4]
  wire  x99_inr_UnitPipe_sm_clock; // @[sm_x99_inr_UnitPipe.scala 34:18:@12179.4]
  wire  x99_inr_UnitPipe_sm_reset; // @[sm_x99_inr_UnitPipe.scala 34:18:@12179.4]
  wire  x99_inr_UnitPipe_sm_io_enable; // @[sm_x99_inr_UnitPipe.scala 34:18:@12179.4]
  wire  x99_inr_UnitPipe_sm_io_done; // @[sm_x99_inr_UnitPipe.scala 34:18:@12179.4]
  wire  x99_inr_UnitPipe_sm_io_doneLatch; // @[sm_x99_inr_UnitPipe.scala 34:18:@12179.4]
  wire  x99_inr_UnitPipe_sm_io_ctrDone; // @[sm_x99_inr_UnitPipe.scala 34:18:@12179.4]
  wire  x99_inr_UnitPipe_sm_io_datapathEn; // @[sm_x99_inr_UnitPipe.scala 34:18:@12179.4]
  wire  x99_inr_UnitPipe_sm_io_ctrInc; // @[sm_x99_inr_UnitPipe.scala 34:18:@12179.4]
  wire  x99_inr_UnitPipe_sm_io_parentAck; // @[sm_x99_inr_UnitPipe.scala 34:18:@12179.4]
  wire  x99_inr_UnitPipe_sm_io_backpressure; // @[sm_x99_inr_UnitPipe.scala 34:18:@12179.4]
  wire  x99_inr_UnitPipe_sm_io_break; // @[sm_x99_inr_UnitPipe.scala 34:18:@12179.4]
  wire  RetimeWrapper_2_clock; // @[package.scala 93:22:@12212.4]
  wire  RetimeWrapper_2_reset; // @[package.scala 93:22:@12212.4]
  wire  RetimeWrapper_2_io_flow; // @[package.scala 93:22:@12212.4]
  wire  RetimeWrapper_2_io_in; // @[package.scala 93:22:@12212.4]
  wire  RetimeWrapper_2_io_out; // @[package.scala 93:22:@12212.4]
  wire  RetimeWrapper_3_clock; // @[package.scala 93:22:@12222.4]
  wire  RetimeWrapper_3_reset; // @[package.scala 93:22:@12222.4]
  wire  RetimeWrapper_3_io_flow; // @[package.scala 93:22:@12222.4]
  wire  RetimeWrapper_3_io_in; // @[package.scala 93:22:@12222.4]
  wire  RetimeWrapper_3_io_out; // @[package.scala 93:22:@12222.4]
  wire  RetimeWrapper_4_clock; // @[package.scala 93:22:@12263.4]
  wire  RetimeWrapper_4_reset; // @[package.scala 93:22:@12263.4]
  wire  RetimeWrapper_4_io_flow; // @[package.scala 93:22:@12263.4]
  wire  RetimeWrapper_4_io_in; // @[package.scala 93:22:@12263.4]
  wire  RetimeWrapper_4_io_out; // @[package.scala 93:22:@12263.4]
  wire  RetimeWrapper_5_clock; // @[package.scala 93:22:@12271.4]
  wire  RetimeWrapper_5_reset; // @[package.scala 93:22:@12271.4]
  wire  RetimeWrapper_5_io_flow; // @[package.scala 93:22:@12271.4]
  wire  RetimeWrapper_5_io_in; // @[package.scala 93:22:@12271.4]
  wire  RetimeWrapper_5_io_out; // @[package.scala 93:22:@12271.4]
  wire  x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_clock; // @[sm_x99_inr_UnitPipe.scala 119:24:@12297.4]
  wire  x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_reset; // @[sm_x99_inr_UnitPipe.scala 119:24:@12297.4]
  wire [31:0] x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x88_reg_wPort_0_data_0; // @[sm_x99_inr_UnitPipe.scala 119:24:@12297.4]
  wire  x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x88_reg_wPort_0_reset; // @[sm_x99_inr_UnitPipe.scala 119:24:@12297.4]
  wire  x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x88_reg_wPort_0_en_0; // @[sm_x99_inr_UnitPipe.scala 119:24:@12297.4]
  wire  x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x88_reg_reset; // @[sm_x99_inr_UnitPipe.scala 119:24:@12297.4]
  wire  x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x88_reg_sEn_0; // @[sm_x99_inr_UnitPipe.scala 119:24:@12297.4]
  wire  x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x88_reg_sDone_0; // @[sm_x99_inr_UnitPipe.scala 119:24:@12297.4]
  wire [15:0] x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x89_reg_wPort_0_data_0; // @[sm_x99_inr_UnitPipe.scala 119:24:@12297.4]
  wire  x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x89_reg_wPort_0_reset; // @[sm_x99_inr_UnitPipe.scala 119:24:@12297.4]
  wire  x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x89_reg_wPort_0_en_0; // @[sm_x99_inr_UnitPipe.scala 119:24:@12297.4]
  wire  x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x89_reg_reset; // @[sm_x99_inr_UnitPipe.scala 119:24:@12297.4]
  wire  x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x89_reg_sEn_0; // @[sm_x99_inr_UnitPipe.scala 119:24:@12297.4]
  wire  x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x89_reg_sDone_0; // @[sm_x99_inr_UnitPipe.scala 119:24:@12297.4]
  wire  x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x77_scalar_0_rPort_0_en_0; // @[sm_x99_inr_UnitPipe.scala 119:24:@12297.4]
  wire [15:0] x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x77_scalar_0_rPort_0_output_0; // @[sm_x99_inr_UnitPipe.scala 119:24:@12297.4]
  wire  x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x76_numel_0_rPort_0_en_0; // @[sm_x99_inr_UnitPipe.scala 119:24:@12297.4]
  wire [31:0] x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x76_numel_0_rPort_0_output_0; // @[sm_x99_inr_UnitPipe.scala 119:24:@12297.4]
  wire [31:0] x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x90_reg_wPort_0_data_0; // @[sm_x99_inr_UnitPipe.scala 119:24:@12297.4]
  wire  x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x90_reg_wPort_0_reset; // @[sm_x99_inr_UnitPipe.scala 119:24:@12297.4]
  wire  x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x90_reg_wPort_0_en_0; // @[sm_x99_inr_UnitPipe.scala 119:24:@12297.4]
  wire  x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x90_reg_reset; // @[sm_x99_inr_UnitPipe.scala 119:24:@12297.4]
  wire  x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x90_reg_sEn_0; // @[sm_x99_inr_UnitPipe.scala 119:24:@12297.4]
  wire  x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x90_reg_sDone_0; // @[sm_x99_inr_UnitPipe.scala 119:24:@12297.4]
  wire  x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_sigsIn_done; // @[sm_x99_inr_UnitPipe.scala 119:24:@12297.4]
  wire  x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_sigsIn_datapathEn; // @[sm_x99_inr_UnitPipe.scala 119:24:@12297.4]
  wire  x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_sigsIn_baseEn; // @[sm_x99_inr_UnitPipe.scala 119:24:@12297.4]
  wire  x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_sigsIn_break; // @[sm_x99_inr_UnitPipe.scala 119:24:@12297.4]
  wire  x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_rr; // @[sm_x99_inr_UnitPipe.scala 119:24:@12297.4]
  wire  x102_ctrchain_clock; // @[SpatialBlocks.scala 37:22:@12582.4]
  wire  x102_ctrchain_reset; // @[SpatialBlocks.scala 37:22:@12582.4]
  wire [31:0] x102_ctrchain_io_setup_stops_0; // @[SpatialBlocks.scala 37:22:@12582.4]
  wire  x102_ctrchain_io_input_reset; // @[SpatialBlocks.scala 37:22:@12582.4]
  wire  x102_ctrchain_io_input_enable; // @[SpatialBlocks.scala 37:22:@12582.4]
  wire [31:0] x102_ctrchain_io_output_counts_0; // @[SpatialBlocks.scala 37:22:@12582.4]
  wire  x102_ctrchain_io_output_oobs_0; // @[SpatialBlocks.scala 37:22:@12582.4]
  wire  x102_ctrchain_io_output_noop; // @[SpatialBlocks.scala 37:22:@12582.4]
  wire  x102_ctrchain_io_output_done; // @[SpatialBlocks.scala 37:22:@12582.4]
  wire  x118_inr_Foreach_sm_clock; // @[sm_x118_inr_Foreach.scala 34:18:@12636.4]
  wire  x118_inr_Foreach_sm_reset; // @[sm_x118_inr_Foreach.scala 34:18:@12636.4]
  wire  x118_inr_Foreach_sm_io_enable; // @[sm_x118_inr_Foreach.scala 34:18:@12636.4]
  wire  x118_inr_Foreach_sm_io_done; // @[sm_x118_inr_Foreach.scala 34:18:@12636.4]
  wire  x118_inr_Foreach_sm_io_doneLatch; // @[sm_x118_inr_Foreach.scala 34:18:@12636.4]
  wire  x118_inr_Foreach_sm_io_ctrDone; // @[sm_x118_inr_Foreach.scala 34:18:@12636.4]
  wire  x118_inr_Foreach_sm_io_datapathEn; // @[sm_x118_inr_Foreach.scala 34:18:@12636.4]
  wire  x118_inr_Foreach_sm_io_ctrInc; // @[sm_x118_inr_Foreach.scala 34:18:@12636.4]
  wire  x118_inr_Foreach_sm_io_ctrRst; // @[sm_x118_inr_Foreach.scala 34:18:@12636.4]
  wire  x118_inr_Foreach_sm_io_parentAck; // @[sm_x118_inr_Foreach.scala 34:18:@12636.4]
  wire  x118_inr_Foreach_sm_io_backpressure; // @[sm_x118_inr_Foreach.scala 34:18:@12636.4]
  wire  x118_inr_Foreach_sm_io_break; // @[sm_x118_inr_Foreach.scala 34:18:@12636.4]
  wire  RetimeWrapper_6_clock; // @[package.scala 93:22:@12664.4]
  wire  RetimeWrapper_6_reset; // @[package.scala 93:22:@12664.4]
  wire  RetimeWrapper_6_io_flow; // @[package.scala 93:22:@12664.4]
  wire  RetimeWrapper_6_io_in; // @[package.scala 93:22:@12664.4]
  wire  RetimeWrapper_6_io_out; // @[package.scala 93:22:@12664.4]
  wire  RetimeWrapper_7_clock; // @[package.scala 93:22:@12673.4]
  wire  RetimeWrapper_7_reset; // @[package.scala 93:22:@12673.4]
  wire  RetimeWrapper_7_io_flow; // @[package.scala 93:22:@12673.4]
  wire  RetimeWrapper_7_io_in; // @[package.scala 93:22:@12673.4]
  wire  RetimeWrapper_7_io_out; // @[package.scala 93:22:@12673.4]
  wire  RetimeWrapper_8_clock; // @[package.scala 93:22:@12683.4]
  wire  RetimeWrapper_8_reset; // @[package.scala 93:22:@12683.4]
  wire  RetimeWrapper_8_io_flow; // @[package.scala 93:22:@12683.4]
  wire  RetimeWrapper_8_io_in; // @[package.scala 93:22:@12683.4]
  wire  RetimeWrapper_8_io_out; // @[package.scala 93:22:@12683.4]
  wire  RetimeWrapper_9_clock; // @[package.scala 93:22:@12735.4]
  wire  RetimeWrapper_9_reset; // @[package.scala 93:22:@12735.4]
  wire  RetimeWrapper_9_io_flow; // @[package.scala 93:22:@12735.4]
  wire  RetimeWrapper_9_io_in; // @[package.scala 93:22:@12735.4]
  wire  RetimeWrapper_9_io_out; // @[package.scala 93:22:@12735.4]
  wire  RetimeWrapper_10_clock; // @[package.scala 93:22:@12743.4]
  wire  RetimeWrapper_10_reset; // @[package.scala 93:22:@12743.4]
  wire  RetimeWrapper_10_io_flow; // @[package.scala 93:22:@12743.4]
  wire  RetimeWrapper_10_io_in; // @[package.scala 93:22:@12743.4]
  wire  RetimeWrapper_10_io_out; // @[package.scala 93:22:@12743.4]
  wire  x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_clock; // @[sm_x118_inr_Foreach.scala 130:24:@12774.4]
  wire  x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_reset; // @[sm_x118_inr_Foreach.scala 130:24:@12774.4]
  wire [31:0] x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x88_reg_rPort_0_output_0; // @[sm_x118_inr_Foreach.scala 130:24:@12774.4]
  wire  x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x88_reg_sEn_1; // @[sm_x118_inr_Foreach.scala 130:24:@12774.4]
  wire  x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x88_reg_sDone_1; // @[sm_x118_inr_Foreach.scala 130:24:@12774.4]
  wire [31:0] x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x78_index_0_wPort_0_data_0; // @[sm_x118_inr_Foreach.scala 130:24:@12774.4]
  wire  x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x78_index_0_wPort_0_en_0; // @[sm_x118_inr_Foreach.scala 130:24:@12774.4]
  wire  x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x78_index_0_full; // @[sm_x118_inr_Foreach.scala 130:24:@12774.4]
  wire  x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x78_index_0_accessActivesOut_0; // @[sm_x118_inr_Foreach.scala 130:24:@12774.4]
  wire  x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x78_index_0_accessActivesIn_0; // @[sm_x118_inr_Foreach.scala 130:24:@12774.4]
  wire [15:0] x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x89_reg_rPort_0_output_0; // @[sm_x118_inr_Foreach.scala 130:24:@12774.4]
  wire  x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x89_reg_sEn_1; // @[sm_x118_inr_Foreach.scala 130:24:@12774.4]
  wire  x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x89_reg_sDone_1; // @[sm_x118_inr_Foreach.scala 130:24:@12774.4]
  wire [31:0] x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x80_numelOut_0_wPort_0_data_0; // @[sm_x118_inr_Foreach.scala 130:24:@12774.4]
  wire  x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x80_numelOut_0_wPort_0_en_0; // @[sm_x118_inr_Foreach.scala 130:24:@12774.4]
  wire  x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x80_numelOut_0_full; // @[sm_x118_inr_Foreach.scala 130:24:@12774.4]
  wire  x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x80_numelOut_0_accessActivesOut_0; // @[sm_x118_inr_Foreach.scala 130:24:@12774.4]
  wire  x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x80_numelOut_0_accessActivesIn_0; // @[sm_x118_inr_Foreach.scala 130:24:@12774.4]
  wire  x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_b87; // @[sm_x118_inr_Foreach.scala 130:24:@12774.4]
  wire [15:0] x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x79_payload_0_wPort_0_data_0; // @[sm_x118_inr_Foreach.scala 130:24:@12774.4]
  wire  x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x79_payload_0_wPort_0_en_0; // @[sm_x118_inr_Foreach.scala 130:24:@12774.4]
  wire  x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x79_payload_0_full; // @[sm_x118_inr_Foreach.scala 130:24:@12774.4]
  wire  x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x79_payload_0_accessActivesOut_0; // @[sm_x118_inr_Foreach.scala 130:24:@12774.4]
  wire  x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x79_payload_0_accessActivesIn_0; // @[sm_x118_inr_Foreach.scala 130:24:@12774.4]
  wire  x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x90_reg_sEn_1; // @[sm_x118_inr_Foreach.scala 130:24:@12774.4]
  wire  x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x90_reg_sDone_1; // @[sm_x118_inr_Foreach.scala 130:24:@12774.4]
  wire  x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_sigsIn_done; // @[sm_x118_inr_Foreach.scala 130:24:@12774.4]
  wire  x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_sigsIn_backpressure; // @[sm_x118_inr_Foreach.scala 130:24:@12774.4]
  wire  x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_sigsIn_datapathEn; // @[sm_x118_inr_Foreach.scala 130:24:@12774.4]
  wire  x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_sigsIn_baseEn; // @[sm_x118_inr_Foreach.scala 130:24:@12774.4]
  wire  x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_sigsIn_break; // @[sm_x118_inr_Foreach.scala 130:24:@12774.4]
  wire [31:0] x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_sigsIn_cchainOutputs_0_counts_0; // @[sm_x118_inr_Foreach.scala 130:24:@12774.4]
  wire  x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_sigsIn_cchainOutputs_0_oobs_0; // @[sm_x118_inr_Foreach.scala 130:24:@12774.4]
  wire  x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_rr; // @[sm_x118_inr_Foreach.scala 130:24:@12774.4]
  wire  b87; // @[sm_x119_outr_Foreach.scala 76:17:@12014.4]
  wire  b87_chain_read_1; // @[sm_x119_outr_Foreach.scala 79:59:@12053.4]
  wire  _T_1049; // @[package.scala 100:49:@12207.4]
  reg  _T_1052; // @[package.scala 48:56:@12208.4]
  reg [31:0] _RAND_0;
  wire  _T_1055; // @[package.scala 96:25:@12217.4 package.scala 96:25:@12218.4]
  wire  _T_1059; // @[package.scala 96:25:@12227.4 package.scala 96:25:@12228.4]
  wire  _T_1064; // @[sm_x119_outr_Foreach.scala 88:44:@12234.4]
  wire  _T_1067; // @[sm_x119_outr_Foreach.scala 88:104:@12237.4]
  wire  _T_1070; // @[sm_x119_outr_Foreach.scala 88:101:@12240.4]
  wire  x99_inr_UnitPipe_sigsIn_forwardpressure; // @[sm_x119_outr_Foreach.scala 88:163:@12241.4]
  wire  _T_1079; // @[package.scala 96:25:@12268.4 package.scala 96:25:@12269.4]
  wire  _T_1085; // @[package.scala 96:25:@12276.4 package.scala 96:25:@12277.4]
  wire  _T_1088; // @[SpatialBlocks.scala 110:93:@12279.4]
  wire  x99_inr_UnitPipe_sigsIn_baseEn; // @[SpatialBlocks.scala 110:90:@12280.4]
  wire [31:0] x141_rd_x90_number; // @[sm_x119_outr_Foreach.scala 94:29:@12572.4 sm_x119_outr_Foreach.scala 98:286:@12581.4]
  wire  _T_1166; // @[package.scala 96:25:@12669.4 package.scala 96:25:@12670.4]
  wire  _T_1170; // @[package.scala 96:25:@12678.4 package.scala 96:25:@12679.4]
  wire  _T_1174; // @[package.scala 96:25:@12688.4 package.scala 96:25:@12689.4]
  wire  _T_1177; // @[sm_x119_outr_Foreach.scala 107:41:@12693.4]
  wire  _T_1178; // @[sm_x119_outr_Foreach.scala 107:62:@12694.4]
  wire  _T_1179; // @[sm_x119_outr_Foreach.scala 107:60:@12695.4]
  wire  _T_1180; // @[sm_x119_outr_Foreach.scala 107:102:@12696.4]
  wire  _T_1181; // @[sm_x119_outr_Foreach.scala 107:125:@12697.4]
  wire  _T_1182; // @[sm_x119_outr_Foreach.scala 107:123:@12698.4]
  wire  _T_1183; // @[sm_x119_outr_Foreach.scala 107:99:@12699.4]
  wire  _T_1184; // @[sm_x119_outr_Foreach.scala 107:167:@12700.4]
  wire  _T_1185; // @[sm_x119_outr_Foreach.scala 107:189:@12701.4]
  wire  _T_1186; // @[sm_x119_outr_Foreach.scala 107:187:@12702.4]
  wire  _T_1187; // @[sm_x119_outr_Foreach.scala 107:164:@12703.4]
  wire  _T_1192; // @[sm_x119_outr_Foreach.scala 111:32:@12710.4]
  wire  x118_inr_Foreach_sigsIn_mask; // @[sm_x119_outr_Foreach.scala 111:74:@12711.4]
  wire  _T_1198; // @[package.scala 96:25:@12740.4 package.scala 96:25:@12741.4]
  wire  _T_1204; // @[package.scala 96:25:@12748.4 package.scala 96:25:@12749.4]
  wire  _T_1207; // @[SpatialBlocks.scala 110:93:@12751.4]
  wire  _T_1209; // @[SpatialBlocks.scala 128:36:@12760.4]
  wire  _T_1210; // @[SpatialBlocks.scala 128:78:@12761.4]
  _ _ ( // @[Math.scala 709:24:@11957.4]
    .io_b(__io_b),
    .io_result(__io_result)
  );
  bbox_b86_chain b86_chain ( // @[sm_x119_outr_Foreach.scala 73:29:@11965.4]
    .clock(b86_chain_clock),
    .reset(b86_chain_reset),
    .io_rPort_0_output_0(b86_chain_io_rPort_0_output_0),
    .io_wPort_0_data_0(b86_chain_io_wPort_0_data_0),
    .io_wPort_0_reset(b86_chain_io_wPort_0_reset),
    .io_wPort_0_en_0(b86_chain_io_wPort_0_en_0),
    .io_sEn_0(b86_chain_io_sEn_0),
    .io_sEn_1(b86_chain_io_sEn_1),
    .io_sDone_0(b86_chain_io_sDone_0),
    .io_sDone_1(b86_chain_io_sDone_1)
  );
  bbox_RetimeWrapper RetimeWrapper ( // @[package.scala 93:22:@11994.4]
    .clock(RetimeWrapper_clock),
    .reset(RetimeWrapper_reset),
    .io_flow(RetimeWrapper_io_flow),
    .io_in(RetimeWrapper_io_in),
    .io_out(RetimeWrapper_io_out)
  );
  _ __1 ( // @[Math.scala 709:24:@12006.4]
    .io_b(__1_io_b),
    .io_result(__1_io_result)
  );
  bbox_b87_chain b87_chain ( // @[sm_x119_outr_Foreach.scala 77:29:@12015.4]
    .clock(b87_chain_clock),
    .reset(b87_chain_reset),
    .io_rPort_0_output_0(b87_chain_io_rPort_0_output_0),
    .io_wPort_0_data_0(b87_chain_io_wPort_0_data_0),
    .io_wPort_0_reset(b87_chain_io_wPort_0_reset),
    .io_wPort_0_en_0(b87_chain_io_wPort_0_en_0),
    .io_sEn_0(b87_chain_io_sEn_0),
    .io_sEn_1(b87_chain_io_sEn_1),
    .io_sDone_0(b87_chain_io_sDone_0),
    .io_sDone_1(b87_chain_io_sDone_1)
  );
  bbox_RetimeWrapper RetimeWrapper_1 ( // @[package.scala 93:22:@12044.4]
    .clock(RetimeWrapper_1_clock),
    .reset(RetimeWrapper_1_reset),
    .io_flow(RetimeWrapper_1_io_flow),
    .io_in(RetimeWrapper_1_io_in),
    .io_out(RetimeWrapper_1_io_out)
  );
  bbox_x88_reg x88_reg ( // @[m_x88_reg.scala 27:17:@12054.4]
    .clock(x88_reg_clock),
    .reset(x88_reg_reset),
    .io_rPort_0_output_0(x88_reg_io_rPort_0_output_0),
    .io_wPort_0_data_0(x88_reg_io_wPort_0_data_0),
    .io_wPort_0_reset(x88_reg_io_wPort_0_reset),
    .io_wPort_0_en_0(x88_reg_io_wPort_0_en_0),
    .io_sEn_0(x88_reg_io_sEn_0),
    .io_sEn_1(x88_reg_io_sEn_1),
    .io_sDone_0(x88_reg_io_sDone_0),
    .io_sDone_1(x88_reg_io_sDone_1)
  );
  bbox_x89_reg x89_reg ( // @[m_x89_reg.scala 27:17:@12084.4]
    .clock(x89_reg_clock),
    .reset(x89_reg_reset),
    .io_rPort_0_output_0(x89_reg_io_rPort_0_output_0),
    .io_wPort_0_data_0(x89_reg_io_wPort_0_data_0),
    .io_wPort_0_reset(x89_reg_io_wPort_0_reset),
    .io_wPort_0_en_0(x89_reg_io_wPort_0_en_0),
    .io_sEn_0(x89_reg_io_sEn_0),
    .io_sEn_1(x89_reg_io_sEn_1),
    .io_sDone_0(x89_reg_io_sDone_0),
    .io_sDone_1(x89_reg_io_sDone_1)
  );
  bbox_x88_reg x90_reg ( // @[m_x90_reg.scala 27:17:@12114.4]
    .clock(x90_reg_clock),
    .reset(x90_reg_reset),
    .io_rPort_0_output_0(x90_reg_io_rPort_0_output_0),
    .io_wPort_0_data_0(x90_reg_io_wPort_0_data_0),
    .io_wPort_0_reset(x90_reg_io_wPort_0_reset),
    .io_wPort_0_en_0(x90_reg_io_wPort_0_en_0),
    .io_sEn_0(x90_reg_io_sEn_0),
    .io_sEn_1(x90_reg_io_sEn_1),
    .io_sDone_0(x90_reg_io_sDone_0),
    .io_sDone_1(x90_reg_io_sDone_1)
  );
  bbox_x99_inr_UnitPipe_sm x99_inr_UnitPipe_sm ( // @[sm_x99_inr_UnitPipe.scala 34:18:@12179.4]
    .clock(x99_inr_UnitPipe_sm_clock),
    .reset(x99_inr_UnitPipe_sm_reset),
    .io_enable(x99_inr_UnitPipe_sm_io_enable),
    .io_done(x99_inr_UnitPipe_sm_io_done),
    .io_doneLatch(x99_inr_UnitPipe_sm_io_doneLatch),
    .io_ctrDone(x99_inr_UnitPipe_sm_io_ctrDone),
    .io_datapathEn(x99_inr_UnitPipe_sm_io_datapathEn),
    .io_ctrInc(x99_inr_UnitPipe_sm_io_ctrInc),
    .io_parentAck(x99_inr_UnitPipe_sm_io_parentAck),
    .io_backpressure(x99_inr_UnitPipe_sm_io_backpressure),
    .io_break(x99_inr_UnitPipe_sm_io_break)
  );
  bbox_RetimeWrapper RetimeWrapper_2 ( // @[package.scala 93:22:@12212.4]
    .clock(RetimeWrapper_2_clock),
    .reset(RetimeWrapper_2_reset),
    .io_flow(RetimeWrapper_2_io_flow),
    .io_in(RetimeWrapper_2_io_in),
    .io_out(RetimeWrapper_2_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_3 ( // @[package.scala 93:22:@12222.4]
    .clock(RetimeWrapper_3_clock),
    .reset(RetimeWrapper_3_reset),
    .io_flow(RetimeWrapper_3_io_flow),
    .io_in(RetimeWrapper_3_io_in),
    .io_out(RetimeWrapper_3_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_4 ( // @[package.scala 93:22:@12263.4]
    .clock(RetimeWrapper_4_clock),
    .reset(RetimeWrapper_4_reset),
    .io_flow(RetimeWrapper_4_io_flow),
    .io_in(RetimeWrapper_4_io_in),
    .io_out(RetimeWrapper_4_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_5 ( // @[package.scala 93:22:@12271.4]
    .clock(RetimeWrapper_5_clock),
    .reset(RetimeWrapper_5_reset),
    .io_flow(RetimeWrapper_5_io_flow),
    .io_in(RetimeWrapper_5_io_in),
    .io_out(RetimeWrapper_5_io_out)
  );
  bbox_x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1 x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1 ( // @[sm_x99_inr_UnitPipe.scala 119:24:@12297.4]
    .clock(x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_clock),
    .reset(x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_reset),
    .io_in_x88_reg_wPort_0_data_0(x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x88_reg_wPort_0_data_0),
    .io_in_x88_reg_wPort_0_reset(x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x88_reg_wPort_0_reset),
    .io_in_x88_reg_wPort_0_en_0(x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x88_reg_wPort_0_en_0),
    .io_in_x88_reg_reset(x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x88_reg_reset),
    .io_in_x88_reg_sEn_0(x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x88_reg_sEn_0),
    .io_in_x88_reg_sDone_0(x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x88_reg_sDone_0),
    .io_in_x89_reg_wPort_0_data_0(x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x89_reg_wPort_0_data_0),
    .io_in_x89_reg_wPort_0_reset(x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x89_reg_wPort_0_reset),
    .io_in_x89_reg_wPort_0_en_0(x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x89_reg_wPort_0_en_0),
    .io_in_x89_reg_reset(x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x89_reg_reset),
    .io_in_x89_reg_sEn_0(x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x89_reg_sEn_0),
    .io_in_x89_reg_sDone_0(x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x89_reg_sDone_0),
    .io_in_x77_scalar_0_rPort_0_en_0(x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x77_scalar_0_rPort_0_en_0),
    .io_in_x77_scalar_0_rPort_0_output_0(x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x77_scalar_0_rPort_0_output_0),
    .io_in_x76_numel_0_rPort_0_en_0(x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x76_numel_0_rPort_0_en_0),
    .io_in_x76_numel_0_rPort_0_output_0(x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x76_numel_0_rPort_0_output_0),
    .io_in_x90_reg_wPort_0_data_0(x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x90_reg_wPort_0_data_0),
    .io_in_x90_reg_wPort_0_reset(x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x90_reg_wPort_0_reset),
    .io_in_x90_reg_wPort_0_en_0(x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x90_reg_wPort_0_en_0),
    .io_in_x90_reg_reset(x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x90_reg_reset),
    .io_in_x90_reg_sEn_0(x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x90_reg_sEn_0),
    .io_in_x90_reg_sDone_0(x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x90_reg_sDone_0),
    .io_sigsIn_done(x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_sigsIn_done),
    .io_sigsIn_datapathEn(x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_sigsIn_datapathEn),
    .io_sigsIn_baseEn(x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_sigsIn_baseEn),
    .io_sigsIn_break(x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_sigsIn_break),
    .io_rr(x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_rr)
  );
  bbox_x102_ctrchain x102_ctrchain ( // @[SpatialBlocks.scala 37:22:@12582.4]
    .clock(x102_ctrchain_clock),
    .reset(x102_ctrchain_reset),
    .io_setup_stops_0(x102_ctrchain_io_setup_stops_0),
    .io_input_reset(x102_ctrchain_io_input_reset),
    .io_input_enable(x102_ctrchain_io_input_enable),
    .io_output_counts_0(x102_ctrchain_io_output_counts_0),
    .io_output_oobs_0(x102_ctrchain_io_output_oobs_0),
    .io_output_noop(x102_ctrchain_io_output_noop),
    .io_output_done(x102_ctrchain_io_output_done)
  );
  bbox_x118_inr_Foreach_sm x118_inr_Foreach_sm ( // @[sm_x118_inr_Foreach.scala 34:18:@12636.4]
    .clock(x118_inr_Foreach_sm_clock),
    .reset(x118_inr_Foreach_sm_reset),
    .io_enable(x118_inr_Foreach_sm_io_enable),
    .io_done(x118_inr_Foreach_sm_io_done),
    .io_doneLatch(x118_inr_Foreach_sm_io_doneLatch),
    .io_ctrDone(x118_inr_Foreach_sm_io_ctrDone),
    .io_datapathEn(x118_inr_Foreach_sm_io_datapathEn),
    .io_ctrInc(x118_inr_Foreach_sm_io_ctrInc),
    .io_ctrRst(x118_inr_Foreach_sm_io_ctrRst),
    .io_parentAck(x118_inr_Foreach_sm_io_parentAck),
    .io_backpressure(x118_inr_Foreach_sm_io_backpressure),
    .io_break(x118_inr_Foreach_sm_io_break)
  );
  bbox_RetimeWrapper RetimeWrapper_6 ( // @[package.scala 93:22:@12664.4]
    .clock(RetimeWrapper_6_clock),
    .reset(RetimeWrapper_6_reset),
    .io_flow(RetimeWrapper_6_io_flow),
    .io_in(RetimeWrapper_6_io_in),
    .io_out(RetimeWrapper_6_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_7 ( // @[package.scala 93:22:@12673.4]
    .clock(RetimeWrapper_7_clock),
    .reset(RetimeWrapper_7_reset),
    .io_flow(RetimeWrapper_7_io_flow),
    .io_in(RetimeWrapper_7_io_in),
    .io_out(RetimeWrapper_7_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_8 ( // @[package.scala 93:22:@12683.4]
    .clock(RetimeWrapper_8_clock),
    .reset(RetimeWrapper_8_reset),
    .io_flow(RetimeWrapper_8_io_flow),
    .io_in(RetimeWrapper_8_io_in),
    .io_out(RetimeWrapper_8_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_9 ( // @[package.scala 93:22:@12735.4]
    .clock(RetimeWrapper_9_clock),
    .reset(RetimeWrapper_9_reset),
    .io_flow(RetimeWrapper_9_io_flow),
    .io_in(RetimeWrapper_9_io_in),
    .io_out(RetimeWrapper_9_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_10 ( // @[package.scala 93:22:@12743.4]
    .clock(RetimeWrapper_10_clock),
    .reset(RetimeWrapper_10_reset),
    .io_flow(RetimeWrapper_10_io_flow),
    .io_in(RetimeWrapper_10_io_in),
    .io_out(RetimeWrapper_10_io_out)
  );
  bbox_x118_inr_Foreach_kernelx118_inr_Foreach_concrete1 x118_inr_Foreach_kernelx118_inr_Foreach_concrete1 ( // @[sm_x118_inr_Foreach.scala 130:24:@12774.4]
    .clock(x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_clock),
    .reset(x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_reset),
    .io_in_x88_reg_rPort_0_output_0(x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x88_reg_rPort_0_output_0),
    .io_in_x88_reg_sEn_1(x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x88_reg_sEn_1),
    .io_in_x88_reg_sDone_1(x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x88_reg_sDone_1),
    .io_in_x78_index_0_wPort_0_data_0(x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x78_index_0_wPort_0_data_0),
    .io_in_x78_index_0_wPort_0_en_0(x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x78_index_0_wPort_0_en_0),
    .io_in_x78_index_0_full(x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x78_index_0_full),
    .io_in_x78_index_0_accessActivesOut_0(x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x78_index_0_accessActivesOut_0),
    .io_in_x78_index_0_accessActivesIn_0(x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x78_index_0_accessActivesIn_0),
    .io_in_x89_reg_rPort_0_output_0(x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x89_reg_rPort_0_output_0),
    .io_in_x89_reg_sEn_1(x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x89_reg_sEn_1),
    .io_in_x89_reg_sDone_1(x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x89_reg_sDone_1),
    .io_in_x80_numelOut_0_wPort_0_data_0(x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x80_numelOut_0_wPort_0_data_0),
    .io_in_x80_numelOut_0_wPort_0_en_0(x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x80_numelOut_0_wPort_0_en_0),
    .io_in_x80_numelOut_0_full(x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x80_numelOut_0_full),
    .io_in_x80_numelOut_0_accessActivesOut_0(x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x80_numelOut_0_accessActivesOut_0),
    .io_in_x80_numelOut_0_accessActivesIn_0(x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x80_numelOut_0_accessActivesIn_0),
    .io_in_b87(x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_b87),
    .io_in_x79_payload_0_wPort_0_data_0(x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x79_payload_0_wPort_0_data_0),
    .io_in_x79_payload_0_wPort_0_en_0(x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x79_payload_0_wPort_0_en_0),
    .io_in_x79_payload_0_full(x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x79_payload_0_full),
    .io_in_x79_payload_0_accessActivesOut_0(x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x79_payload_0_accessActivesOut_0),
    .io_in_x79_payload_0_accessActivesIn_0(x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x79_payload_0_accessActivesIn_0),
    .io_in_x90_reg_sEn_1(x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x90_reg_sEn_1),
    .io_in_x90_reg_sDone_1(x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x90_reg_sDone_1),
    .io_sigsIn_done(x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_sigsIn_done),
    .io_sigsIn_backpressure(x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_sigsIn_backpressure),
    .io_sigsIn_datapathEn(x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_sigsIn_datapathEn),
    .io_sigsIn_baseEn(x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_sigsIn_baseEn),
    .io_sigsIn_break(x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_sigsIn_break),
    .io_sigsIn_cchainOutputs_0_counts_0(x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_sigsIn_cchainOutputs_0_counts_0),
    .io_sigsIn_cchainOutputs_0_oobs_0(x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_sigsIn_cchainOutputs_0_oobs_0),
    .io_rr(x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_rr)
  );
  assign b87 = ~ io_sigsIn_cchainOutputs_0_oobs_0; // @[sm_x119_outr_Foreach.scala 76:17:@12014.4]
  assign b87_chain_read_1 = b87_chain_io_rPort_0_output_0; // @[sm_x119_outr_Foreach.scala 79:59:@12053.4]
  assign _T_1049 = x99_inr_UnitPipe_sm_io_ctrInc == 1'h0; // @[package.scala 100:49:@12207.4]
  assign _T_1055 = RetimeWrapper_2_io_out; // @[package.scala 96:25:@12217.4 package.scala 96:25:@12218.4]
  assign _T_1059 = RetimeWrapper_3_io_out; // @[package.scala 96:25:@12227.4 package.scala 96:25:@12228.4]
  assign _T_1064 = ~ io_in_x76_numel_0_empty; // @[sm_x119_outr_Foreach.scala 88:44:@12234.4]
  assign _T_1067 = ~ io_in_x77_scalar_0_empty; // @[sm_x119_outr_Foreach.scala 88:104:@12237.4]
  assign _T_1070 = _T_1064 & _T_1067; // @[sm_x119_outr_Foreach.scala 88:101:@12240.4]
  assign x99_inr_UnitPipe_sigsIn_forwardpressure = _T_1070 | x99_inr_UnitPipe_sm_io_doneLatch; // @[sm_x119_outr_Foreach.scala 88:163:@12241.4]
  assign _T_1079 = RetimeWrapper_4_io_out; // @[package.scala 96:25:@12268.4 package.scala 96:25:@12269.4]
  assign _T_1085 = RetimeWrapper_5_io_out; // @[package.scala 96:25:@12276.4 package.scala 96:25:@12277.4]
  assign _T_1088 = ~ _T_1085; // @[SpatialBlocks.scala 110:93:@12279.4]
  assign x99_inr_UnitPipe_sigsIn_baseEn = _T_1079 & _T_1088; // @[SpatialBlocks.scala 110:90:@12280.4]
  assign x141_rd_x90_number = x90_reg_io_rPort_0_output_0; // @[sm_x119_outr_Foreach.scala 94:29:@12572.4 sm_x119_outr_Foreach.scala 98:286:@12581.4]
  assign _T_1166 = RetimeWrapper_6_io_out; // @[package.scala 96:25:@12669.4 package.scala 96:25:@12670.4]
  assign _T_1170 = RetimeWrapper_7_io_out; // @[package.scala 96:25:@12678.4 package.scala 96:25:@12679.4]
  assign _T_1174 = RetimeWrapper_8_io_out; // @[package.scala 96:25:@12688.4 package.scala 96:25:@12689.4]
  assign _T_1177 = ~ io_in_x79_payload_0_full; // @[sm_x119_outr_Foreach.scala 107:41:@12693.4]
  assign _T_1178 = ~ io_in_x79_payload_0_accessActivesOut_0; // @[sm_x119_outr_Foreach.scala 107:62:@12694.4]
  assign _T_1179 = _T_1177 | _T_1178; // @[sm_x119_outr_Foreach.scala 107:60:@12695.4]
  assign _T_1180 = ~ io_in_x80_numelOut_0_full; // @[sm_x119_outr_Foreach.scala 107:102:@12696.4]
  assign _T_1181 = ~ io_in_x80_numelOut_0_accessActivesOut_0; // @[sm_x119_outr_Foreach.scala 107:125:@12697.4]
  assign _T_1182 = _T_1180 | _T_1181; // @[sm_x119_outr_Foreach.scala 107:123:@12698.4]
  assign _T_1183 = _T_1179 & _T_1182; // @[sm_x119_outr_Foreach.scala 107:99:@12699.4]
  assign _T_1184 = ~ io_in_x78_index_0_full; // @[sm_x119_outr_Foreach.scala 107:167:@12700.4]
  assign _T_1185 = ~ io_in_x78_index_0_accessActivesOut_0; // @[sm_x119_outr_Foreach.scala 107:189:@12701.4]
  assign _T_1186 = _T_1184 | _T_1185; // @[sm_x119_outr_Foreach.scala 107:187:@12702.4]
  assign _T_1187 = _T_1183 & _T_1186; // @[sm_x119_outr_Foreach.scala 107:164:@12703.4]
  assign _T_1192 = ~ x102_ctrchain_io_output_noop; // @[sm_x119_outr_Foreach.scala 111:32:@12710.4]
  assign x118_inr_Foreach_sigsIn_mask = _T_1192 & b87_chain_read_1; // @[sm_x119_outr_Foreach.scala 111:74:@12711.4]
  assign _T_1198 = RetimeWrapper_9_io_out; // @[package.scala 96:25:@12740.4 package.scala 96:25:@12741.4]
  assign _T_1204 = RetimeWrapper_10_io_out; // @[package.scala 96:25:@12748.4 package.scala 96:25:@12749.4]
  assign _T_1207 = ~ _T_1204; // @[SpatialBlocks.scala 110:93:@12751.4]
  assign _T_1209 = x118_inr_Foreach_sm_io_datapathEn & x118_inr_Foreach_sigsIn_mask; // @[SpatialBlocks.scala 128:36:@12760.4]
  assign _T_1210 = ~ x118_inr_Foreach_sm_io_ctrDone; // @[SpatialBlocks.scala 128:78:@12761.4]
  assign io_in_x78_index_0_wPort_0_data_0 = x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x78_index_0_wPort_0_data_0; // @[MemInterfaceType.scala 67:44:@12981.4]
  assign io_in_x78_index_0_wPort_0_en_0 = x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x78_index_0_wPort_0_en_0; // @[MemInterfaceType.scala 67:44:@12977.4]
  assign io_in_x78_index_0_accessActivesIn_0 = x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x78_index_0_accessActivesIn_0; // @[MemInterfaceType.scala 69:92:@12984.4]
  assign io_in_x77_scalar_0_rPort_0_en_0 = x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x77_scalar_0_rPort_0_en_0; // @[MemInterfaceType.scala 66:44:@12505.4]
  assign io_in_x76_numel_0_rPort_0_en_0 = x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x76_numel_0_rPort_0_en_0; // @[MemInterfaceType.scala 66:44:@12518.4]
  assign io_in_x80_numelOut_0_wPort_0_data_0 = x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x80_numelOut_0_wPort_0_data_0; // @[MemInterfaceType.scala 67:44:@13017.4]
  assign io_in_x80_numelOut_0_wPort_0_en_0 = x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x80_numelOut_0_wPort_0_en_0; // @[MemInterfaceType.scala 67:44:@13013.4]
  assign io_in_x80_numelOut_0_accessActivesIn_0 = x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x80_numelOut_0_accessActivesIn_0; // @[MemInterfaceType.scala 69:92:@13020.4]
  assign io_in_x79_payload_0_wPort_0_data_0 = x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x79_payload_0_wPort_0_data_0; // @[MemInterfaceType.scala 67:44:@13033.4]
  assign io_in_x79_payload_0_wPort_0_en_0 = x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x79_payload_0_wPort_0_en_0; // @[MemInterfaceType.scala 67:44:@13029.4]
  assign io_in_x79_payload_0_accessActivesIn_0 = x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x79_payload_0_accessActivesIn_0; // @[MemInterfaceType.scala 69:92:@13036.4]
  assign io_sigsOut_smDoneIn_0 = x99_inr_UnitPipe_sm_io_done; // @[SpatialBlocks.scala 127:53:@12286.4]
  assign io_sigsOut_smDoneIn_1 = x118_inr_Foreach_sm_io_done; // @[SpatialBlocks.scala 127:53:@12758.4]
  assign io_sigsOut_smMaskIn_0 = ~ io_sigsIn_cchainOutputs_0_oobs_0; // @[SpatialBlocks.scala 127:83:@12287.4]
  assign io_sigsOut_smMaskIn_1 = _T_1192 & b87_chain_read_1; // @[SpatialBlocks.scala 127:83:@12759.4]
  assign __io_b = $unsigned(io_sigsIn_cchainOutputs_0_counts_0); // @[Math.scala 710:17:@11960.4]
  assign b86_chain_clock = clock; // @[:@11966.4]
  assign b86_chain_reset = reset; // @[:@11967.4]
  assign b86_chain_io_wPort_0_data_0 = __io_result; // @[NBuffers.scala 284:54:@11992.4]
  assign b86_chain_io_wPort_0_reset = RetimeWrapper_io_out; // @[NBuffers.scala 287:23:@12001.4]
  assign b86_chain_io_wPort_0_en_0 = io_sigsOut_smDoneIn_0; // @[NBuffers.scala 286:25:@11993.4]
  assign b86_chain_io_sEn_0 = _T_1079 & _T_1088; // @[NBuffers.scala 277:18:@12220.4]
  assign b86_chain_io_sEn_1 = _T_1198 & _T_1207; // @[NBuffers.scala 277:18:@12681.4]
  assign b86_chain_io_sDone_0 = io_rr ? _T_1055 : 1'h0; // @[NBuffers.scala 278:20:@12221.4]
  assign b86_chain_io_sDone_1 = io_rr ? _T_1170 : 1'h0; // @[NBuffers.scala 278:20:@12682.4]
  assign RetimeWrapper_clock = clock; // @[:@11995.4]
  assign RetimeWrapper_reset = reset; // @[:@11996.4]
  assign RetimeWrapper_io_flow = 1'h1; // @[package.scala 95:18:@11998.4]
  assign RetimeWrapper_io_in = b86_chain_reset; // @[package.scala 94:16:@11997.4]
  assign __1_io_b = b86_chain_io_rPort_0_output_0; // @[Math.scala 710:17:@12009.4]
  assign b87_chain_clock = clock; // @[:@12016.4]
  assign b87_chain_reset = reset; // @[:@12017.4]
  assign b87_chain_io_wPort_0_data_0 = ~ io_sigsIn_cchainOutputs_0_oobs_0; // @[NBuffers.scala 283:54:@12042.4]
  assign b87_chain_io_wPort_0_reset = RetimeWrapper_1_io_out; // @[NBuffers.scala 287:23:@12051.4]
  assign b87_chain_io_wPort_0_en_0 = io_sigsOut_smDoneIn_0; // @[NBuffers.scala 286:25:@12043.4]
  assign b87_chain_io_sEn_0 = _T_1079 & _T_1088; // @[NBuffers.scala 277:18:@12230.4]
  assign b87_chain_io_sEn_1 = _T_1198 & _T_1207; // @[NBuffers.scala 277:18:@12691.4]
  assign b87_chain_io_sDone_0 = io_rr ? _T_1059 : 1'h0; // @[NBuffers.scala 278:20:@12231.4]
  assign b87_chain_io_sDone_1 = io_rr ? _T_1174 : 1'h0; // @[NBuffers.scala 278:20:@12692.4]
  assign RetimeWrapper_1_clock = clock; // @[:@12045.4]
  assign RetimeWrapper_1_reset = reset; // @[:@12046.4]
  assign RetimeWrapper_1_io_flow = 1'h1; // @[package.scala 95:18:@12048.4]
  assign RetimeWrapper_1_io_in = b87_chain_reset; // @[package.scala 94:16:@12047.4]
  assign x88_reg_clock = clock; // @[:@12055.4]
  assign x88_reg_reset = reset; // @[:@12056.4]
  assign x88_reg_io_wPort_0_data_0 = x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x88_reg_wPort_0_data_0; // @[MemInterfaceType.scala 67:44:@12470.4]
  assign x88_reg_io_wPort_0_reset = x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x88_reg_wPort_0_reset; // @[MemInterfaceType.scala 67:44:@12469.4]
  assign x88_reg_io_wPort_0_en_0 = x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x88_reg_wPort_0_en_0; // @[MemInterfaceType.scala 67:44:@12466.4]
  assign x88_reg_io_sEn_0 = x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x88_reg_sEn_0; // @[MemInterfaceType.scala 176:41:@12457.4]
  assign x88_reg_io_sEn_1 = x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x88_reg_sEn_1; // @[MemInterfaceType.scala 176:41:@12956.4]
  assign x88_reg_io_sDone_0 = x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x88_reg_sDone_0; // @[MemInterfaceType.scala 176:64:@12458.4]
  assign x88_reg_io_sDone_1 = x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x88_reg_sDone_1; // @[MemInterfaceType.scala 176:64:@12957.4]
  assign x89_reg_clock = clock; // @[:@12085.4]
  assign x89_reg_reset = reset; // @[:@12086.4]
  assign x89_reg_io_wPort_0_data_0 = x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x89_reg_wPort_0_data_0; // @[MemInterfaceType.scala 67:44:@12493.4]
  assign x89_reg_io_wPort_0_reset = x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x89_reg_wPort_0_reset; // @[MemInterfaceType.scala 67:44:@12492.4]
  assign x89_reg_io_wPort_0_en_0 = x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x89_reg_wPort_0_en_0; // @[MemInterfaceType.scala 67:44:@12489.4]
  assign x89_reg_io_sEn_0 = x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x89_reg_sEn_0; // @[MemInterfaceType.scala 176:41:@12480.4]
  assign x89_reg_io_sEn_1 = x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x89_reg_sEn_1; // @[MemInterfaceType.scala 176:41:@12992.4]
  assign x89_reg_io_sDone_0 = x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x89_reg_sDone_0; // @[MemInterfaceType.scala 176:64:@12481.4]
  assign x89_reg_io_sDone_1 = x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x89_reg_sDone_1; // @[MemInterfaceType.scala 176:64:@12993.4]
  assign x90_reg_clock = clock; // @[:@12115.4]
  assign x90_reg_reset = reset; // @[:@12116.4]
  assign x90_reg_io_wPort_0_data_0 = x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x90_reg_wPort_0_data_0; // @[MemInterfaceType.scala 67:44:@12543.4]
  assign x90_reg_io_wPort_0_reset = x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x90_reg_wPort_0_reset; // @[MemInterfaceType.scala 67:44:@12542.4]
  assign x90_reg_io_wPort_0_en_0 = x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x90_reg_wPort_0_en_0; // @[MemInterfaceType.scala 67:44:@12539.4]
  assign x90_reg_io_sEn_0 = x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x90_reg_sEn_0; // @[MemInterfaceType.scala 176:41:@12530.4]
  assign x90_reg_io_sEn_1 = x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x90_reg_sEn_1; // @[MemInterfaceType.scala 176:41:@13044.4]
  assign x90_reg_io_sDone_0 = x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x90_reg_sDone_0; // @[MemInterfaceType.scala 176:64:@12531.4]
  assign x90_reg_io_sDone_1 = x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x90_reg_sDone_1; // @[MemInterfaceType.scala 176:64:@13045.4]
  assign x99_inr_UnitPipe_sm_clock = clock; // @[:@12180.4]
  assign x99_inr_UnitPipe_sm_reset = reset; // @[:@12181.4]
  assign x99_inr_UnitPipe_sm_io_enable = x99_inr_UnitPipe_sigsIn_baseEn & x99_inr_UnitPipe_sigsIn_forwardpressure; // @[SpatialBlocks.scala 112:18:@12283.4]
  assign x99_inr_UnitPipe_sm_io_ctrDone = x99_inr_UnitPipe_sm_io_ctrInc & _T_1052; // @[sm_x119_outr_Foreach.scala 84:38:@12211.4]
  assign x99_inr_UnitPipe_sm_io_parentAck = io_sigsIn_smChildAcks_0; // @[SpatialBlocks.scala 114:21:@12285.4]
  assign x99_inr_UnitPipe_sm_io_backpressure = 1'h1; // @[SpatialBlocks.scala 105:24:@12257.4]
  assign x99_inr_UnitPipe_sm_io_break = 1'h0; // @[sm_x119_outr_Foreach.scala 90:36:@12244.4]
  assign RetimeWrapper_2_clock = clock; // @[:@12213.4]
  assign RetimeWrapper_2_reset = reset; // @[:@12214.4]
  assign RetimeWrapper_2_io_flow = x99_inr_UnitPipe_sm_io_backpressure; // @[package.scala 95:18:@12216.4]
  assign RetimeWrapper_2_io_in = x99_inr_UnitPipe_sm_io_done; // @[package.scala 94:16:@12215.4]
  assign RetimeWrapper_3_clock = clock; // @[:@12223.4]
  assign RetimeWrapper_3_reset = reset; // @[:@12224.4]
  assign RetimeWrapper_3_io_flow = x99_inr_UnitPipe_sm_io_backpressure; // @[package.scala 95:18:@12226.4]
  assign RetimeWrapper_3_io_in = x99_inr_UnitPipe_sm_io_done; // @[package.scala 94:16:@12225.4]
  assign RetimeWrapper_4_clock = clock; // @[:@12264.4]
  assign RetimeWrapper_4_reset = reset; // @[:@12265.4]
  assign RetimeWrapper_4_io_flow = 1'h1; // @[package.scala 95:18:@12267.4]
  assign RetimeWrapper_4_io_in = io_sigsIn_smEnableOuts_0; // @[package.scala 94:16:@12266.4]
  assign RetimeWrapper_5_clock = clock; // @[:@12272.4]
  assign RetimeWrapper_5_reset = reset; // @[:@12273.4]
  assign RetimeWrapper_5_io_flow = 1'h1; // @[package.scala 95:18:@12275.4]
  assign RetimeWrapper_5_io_in = x99_inr_UnitPipe_sm_io_done; // @[package.scala 94:16:@12274.4]
  assign x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_clock = clock; // @[:@12298.4]
  assign x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_reset = reset; // @[:@12299.4]
  assign x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x77_scalar_0_rPort_0_output_0 = io_in_x77_scalar_0_rPort_0_output_0; // @[MemInterfaceType.scala 66:44:@12503.4]
  assign x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_in_x76_numel_0_rPort_0_output_0 = io_in_x76_numel_0_rPort_0_output_0; // @[MemInterfaceType.scala 66:44:@12516.4]
  assign x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_sigsIn_done = x99_inr_UnitPipe_sm_io_done; // @[sm_x99_inr_UnitPipe.scala 124:22:@12564.4]
  assign x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_sigsIn_datapathEn = x99_inr_UnitPipe_sm_io_datapathEn & b87; // @[sm_x99_inr_UnitPipe.scala 124:22:@12558.4]
  assign x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_sigsIn_baseEn = _T_1079 & _T_1088; // @[sm_x99_inr_UnitPipe.scala 124:22:@12557.4]
  assign x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_sigsIn_break = x99_inr_UnitPipe_sm_io_break; // @[sm_x99_inr_UnitPipe.scala 124:22:@12556.4]
  assign x99_inr_UnitPipe_kernelx99_inr_UnitPipe_concrete1_io_rr = io_rr; // @[sm_x99_inr_UnitPipe.scala 123:18:@12546.4]
  assign x102_ctrchain_clock = clock; // @[:@12583.4]
  assign x102_ctrchain_reset = reset; // @[:@12584.4]
  assign x102_ctrchain_io_setup_stops_0 = $signed(x141_rd_x90_number); // @[SpatialBlocks.scala 40:87:@12598.4]
  assign x102_ctrchain_io_input_reset = x118_inr_Foreach_sm_io_ctrRst; // @[SpatialBlocks.scala 130:100:@12773.4]
  assign x102_ctrchain_io_input_enable = x118_inr_Foreach_sm_io_ctrInc; // @[SpatialBlocks.scala 104:75:@12728.4 SpatialBlocks.scala 130:42:@12772.4]
  assign x118_inr_Foreach_sm_clock = clock; // @[:@12637.4]
  assign x118_inr_Foreach_sm_reset = reset; // @[:@12638.4]
  assign x118_inr_Foreach_sm_io_enable = _T_1198 & _T_1207; // @[SpatialBlocks.scala 112:18:@12755.4]
  assign x118_inr_Foreach_sm_io_ctrDone = io_rr ? _T_1166 : 1'h0; // @[sm_x119_outr_Foreach.scala 104:38:@12672.4]
  assign x118_inr_Foreach_sm_io_parentAck = io_sigsIn_smChildAcks_1; // @[SpatialBlocks.scala 114:21:@12757.4]
  assign x118_inr_Foreach_sm_io_backpressure = _T_1187 | x118_inr_Foreach_sm_io_doneLatch; // @[SpatialBlocks.scala 105:24:@12729.4]
  assign x118_inr_Foreach_sm_io_break = 1'h0; // @[sm_x119_outr_Foreach.scala 110:36:@12709.4]
  assign RetimeWrapper_6_clock = clock; // @[:@12665.4]
  assign RetimeWrapper_6_reset = reset; // @[:@12666.4]
  assign RetimeWrapper_6_io_flow = 1'h1; // @[package.scala 95:18:@12668.4]
  assign RetimeWrapper_6_io_in = x102_ctrchain_io_output_done; // @[package.scala 94:16:@12667.4]
  assign RetimeWrapper_7_clock = clock; // @[:@12674.4]
  assign RetimeWrapper_7_reset = reset; // @[:@12675.4]
  assign RetimeWrapper_7_io_flow = x118_inr_Foreach_sm_io_backpressure; // @[package.scala 95:18:@12677.4]
  assign RetimeWrapper_7_io_in = x118_inr_Foreach_sm_io_done; // @[package.scala 94:16:@12676.4]
  assign RetimeWrapper_8_clock = clock; // @[:@12684.4]
  assign RetimeWrapper_8_reset = reset; // @[:@12685.4]
  assign RetimeWrapper_8_io_flow = x118_inr_Foreach_sm_io_backpressure; // @[package.scala 95:18:@12687.4]
  assign RetimeWrapper_8_io_in = x118_inr_Foreach_sm_io_done; // @[package.scala 94:16:@12686.4]
  assign RetimeWrapper_9_clock = clock; // @[:@12736.4]
  assign RetimeWrapper_9_reset = reset; // @[:@12737.4]
  assign RetimeWrapper_9_io_flow = 1'h1; // @[package.scala 95:18:@12739.4]
  assign RetimeWrapper_9_io_in = io_sigsIn_smEnableOuts_1; // @[package.scala 94:16:@12738.4]
  assign RetimeWrapper_10_clock = clock; // @[:@12744.4]
  assign RetimeWrapper_10_reset = reset; // @[:@12745.4]
  assign RetimeWrapper_10_io_flow = 1'h1; // @[package.scala 95:18:@12747.4]
  assign RetimeWrapper_10_io_in = x118_inr_Foreach_sm_io_done; // @[package.scala 94:16:@12746.4]
  assign x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_clock = clock; // @[:@12775.4]
  assign x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_reset = reset; // @[:@12776.4]
  assign x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x88_reg_rPort_0_output_0 = x88_reg_io_rPort_0_output_0; // @[MemInterfaceType.scala 66:44:@12965.4]
  assign x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x78_index_0_full = io_in_x78_index_0_full; // @[MemInterfaceType.scala 151:13:@12970.4]
  assign x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x78_index_0_accessActivesOut_0 = io_in_x78_index_0_accessActivesOut_0; // @[MemInterfaceType.scala 156:25:@12975.4]
  assign x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x89_reg_rPort_0_output_0 = x89_reg_io_rPort_0_output_0; // @[MemInterfaceType.scala 66:44:@13001.4]
  assign x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x80_numelOut_0_full = io_in_x80_numelOut_0_full; // @[MemInterfaceType.scala 151:13:@13006.4]
  assign x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x80_numelOut_0_accessActivesOut_0 = io_in_x80_numelOut_0_accessActivesOut_0; // @[MemInterfaceType.scala 156:25:@13011.4]
  assign x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_b87 = b87_chain_io_rPort_0_output_0; // @[sm_x118_inr_Foreach.scala 64:22:@13021.4]
  assign x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x79_payload_0_full = io_in_x79_payload_0_full; // @[MemInterfaceType.scala 151:13:@13022.4]
  assign x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_in_x79_payload_0_accessActivesOut_0 = io_in_x79_payload_0_accessActivesOut_0; // @[MemInterfaceType.scala 156:25:@13027.4]
  assign x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_sigsIn_done = x118_inr_Foreach_sm_io_done; // @[sm_x118_inr_Foreach.scala 135:22:@13071.4]
  assign x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_sigsIn_backpressure = _T_1187 | x118_inr_Foreach_sm_io_doneLatch; // @[sm_x118_inr_Foreach.scala 135:22:@13067.4]
  assign x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_sigsIn_datapathEn = _T_1209 & _T_1210; // @[sm_x118_inr_Foreach.scala 135:22:@13065.4]
  assign x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_sigsIn_baseEn = _T_1198 & _T_1207; // @[sm_x118_inr_Foreach.scala 135:22:@13064.4]
  assign x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_sigsIn_break = x118_inr_Foreach_sm_io_break; // @[sm_x118_inr_Foreach.scala 135:22:@13063.4]
  assign x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_sigsIn_cchainOutputs_0_counts_0 = x102_ctrchain_io_output_counts_0; // @[sm_x118_inr_Foreach.scala 135:22:@13058.4]
  assign x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_sigsIn_cchainOutputs_0_oobs_0 = x102_ctrchain_io_output_oobs_0; // @[sm_x118_inr_Foreach.scala 135:22:@13057.4]
  assign x118_inr_Foreach_kernelx118_inr_Foreach_concrete1_io_rr = io_rr; // @[sm_x118_inr_Foreach.scala 134:18:@13053.4]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  _T_1052 = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      _T_1052 <= 1'h0;
    end else begin
      _T_1052 <= _T_1049;
    end
  end
endmodule
module bbox_x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1( // @[:@13080.2]
  input         clock, // @[:@13081.4]
  input         reset, // @[:@13082.4]
  output [31:0] io_in_x78_index_0_wPort_0_data_0, // @[:@13083.4]
  output        io_in_x78_index_0_wPort_0_en_0, // @[:@13083.4]
  input         io_in_x78_index_0_full, // @[:@13083.4]
  input         io_in_x78_index_0_accessActivesOut_0, // @[:@13083.4]
  output        io_in_x78_index_0_accessActivesIn_0, // @[:@13083.4]
  output        io_in_x77_scalar_0_rPort_0_en_0, // @[:@13083.4]
  input  [15:0] io_in_x77_scalar_0_rPort_0_output_0, // @[:@13083.4]
  input         io_in_x77_scalar_0_empty, // @[:@13083.4]
  output        io_in_x76_numel_0_rPort_0_en_0, // @[:@13083.4]
  input  [31:0] io_in_x76_numel_0_rPort_0_output_0, // @[:@13083.4]
  input         io_in_x76_numel_0_empty, // @[:@13083.4]
  output [31:0] io_in_x80_numelOut_0_wPort_0_data_0, // @[:@13083.4]
  output        io_in_x80_numelOut_0_wPort_0_en_0, // @[:@13083.4]
  input         io_in_x80_numelOut_0_full, // @[:@13083.4]
  input         io_in_x80_numelOut_0_accessActivesOut_0, // @[:@13083.4]
  output        io_in_x80_numelOut_0_accessActivesIn_0, // @[:@13083.4]
  output [15:0] io_in_x79_payload_0_wPort_0_data_0, // @[:@13083.4]
  output        io_in_x79_payload_0_wPort_0_en_0, // @[:@13083.4]
  input         io_in_x79_payload_0_full, // @[:@13083.4]
  input         io_in_x79_payload_0_accessActivesOut_0, // @[:@13083.4]
  output        io_in_x79_payload_0_accessActivesIn_0, // @[:@13083.4]
  input         io_sigsIn_smEnableOuts_0, // @[:@13083.4]
  input         io_sigsIn_smChildAcks_0, // @[:@13083.4]
  output        io_sigsOut_smDoneIn_0, // @[:@13083.4]
  input         io_rr // @[:@13083.4]
);
  wire  x85_ctrchain_clock; // @[SpatialBlocks.scala 37:22:@13203.4]
  wire  x85_ctrchain_reset; // @[SpatialBlocks.scala 37:22:@13203.4]
  wire  x85_ctrchain_io_input_reset; // @[SpatialBlocks.scala 37:22:@13203.4]
  wire  x85_ctrchain_io_input_enable; // @[SpatialBlocks.scala 37:22:@13203.4]
  wire [31:0] x85_ctrchain_io_output_counts_0; // @[SpatialBlocks.scala 37:22:@13203.4]
  wire  x85_ctrchain_io_output_oobs_0; // @[SpatialBlocks.scala 37:22:@13203.4]
  wire  x85_ctrchain_io_output_done; // @[SpatialBlocks.scala 37:22:@13203.4]
  wire  x119_outr_Foreach_sm_clock; // @[sm_x119_outr_Foreach.scala 32:18:@13260.4]
  wire  x119_outr_Foreach_sm_reset; // @[sm_x119_outr_Foreach.scala 32:18:@13260.4]
  wire  x119_outr_Foreach_sm_io_enable; // @[sm_x119_outr_Foreach.scala 32:18:@13260.4]
  wire  x119_outr_Foreach_sm_io_done; // @[sm_x119_outr_Foreach.scala 32:18:@13260.4]
  wire  x119_outr_Foreach_sm_io_ctrDone; // @[sm_x119_outr_Foreach.scala 32:18:@13260.4]
  wire  x119_outr_Foreach_sm_io_ctrInc; // @[sm_x119_outr_Foreach.scala 32:18:@13260.4]
  wire  x119_outr_Foreach_sm_io_ctrRst; // @[sm_x119_outr_Foreach.scala 32:18:@13260.4]
  wire  x119_outr_Foreach_sm_io_parentAck; // @[sm_x119_outr_Foreach.scala 32:18:@13260.4]
  wire  x119_outr_Foreach_sm_io_doneIn_0; // @[sm_x119_outr_Foreach.scala 32:18:@13260.4]
  wire  x119_outr_Foreach_sm_io_doneIn_1; // @[sm_x119_outr_Foreach.scala 32:18:@13260.4]
  wire  x119_outr_Foreach_sm_io_maskIn_0; // @[sm_x119_outr_Foreach.scala 32:18:@13260.4]
  wire  x119_outr_Foreach_sm_io_maskIn_1; // @[sm_x119_outr_Foreach.scala 32:18:@13260.4]
  wire  x119_outr_Foreach_sm_io_enableOut_0; // @[sm_x119_outr_Foreach.scala 32:18:@13260.4]
  wire  x119_outr_Foreach_sm_io_enableOut_1; // @[sm_x119_outr_Foreach.scala 32:18:@13260.4]
  wire  x119_outr_Foreach_sm_io_childAck_0; // @[sm_x119_outr_Foreach.scala 32:18:@13260.4]
  wire  x119_outr_Foreach_sm_io_childAck_1; // @[sm_x119_outr_Foreach.scala 32:18:@13260.4]
  wire  RetimeWrapper_clock; // @[package.scala 93:22:@13293.4]
  wire  RetimeWrapper_reset; // @[package.scala 93:22:@13293.4]
  wire  RetimeWrapper_io_flow; // @[package.scala 93:22:@13293.4]
  wire  RetimeWrapper_io_in; // @[package.scala 93:22:@13293.4]
  wire  RetimeWrapper_io_out; // @[package.scala 93:22:@13293.4]
  wire  RetimeWrapper_1_clock; // @[package.scala 93:22:@13338.4]
  wire  RetimeWrapper_1_reset; // @[package.scala 93:22:@13338.4]
  wire  RetimeWrapper_1_io_flow; // @[package.scala 93:22:@13338.4]
  wire  RetimeWrapper_1_io_in; // @[package.scala 93:22:@13338.4]
  wire  RetimeWrapper_1_io_out; // @[package.scala 93:22:@13338.4]
  wire  RetimeWrapper_2_clock; // @[package.scala 93:22:@13346.4]
  wire  RetimeWrapper_2_reset; // @[package.scala 93:22:@13346.4]
  wire  RetimeWrapper_2_io_flow; // @[package.scala 93:22:@13346.4]
  wire  RetimeWrapper_2_io_in; // @[package.scala 93:22:@13346.4]
  wire  RetimeWrapper_2_io_out; // @[package.scala 93:22:@13346.4]
  wire  x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_clock; // @[sm_x119_outr_Foreach.scala 115:24:@13377.4]
  wire  x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_reset; // @[sm_x119_outr_Foreach.scala 115:24:@13377.4]
  wire [31:0] x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x78_index_0_wPort_0_data_0; // @[sm_x119_outr_Foreach.scala 115:24:@13377.4]
  wire  x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x78_index_0_wPort_0_en_0; // @[sm_x119_outr_Foreach.scala 115:24:@13377.4]
  wire  x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x78_index_0_full; // @[sm_x119_outr_Foreach.scala 115:24:@13377.4]
  wire  x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x78_index_0_accessActivesOut_0; // @[sm_x119_outr_Foreach.scala 115:24:@13377.4]
  wire  x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x78_index_0_accessActivesIn_0; // @[sm_x119_outr_Foreach.scala 115:24:@13377.4]
  wire  x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x77_scalar_0_rPort_0_en_0; // @[sm_x119_outr_Foreach.scala 115:24:@13377.4]
  wire [15:0] x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x77_scalar_0_rPort_0_output_0; // @[sm_x119_outr_Foreach.scala 115:24:@13377.4]
  wire  x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x77_scalar_0_empty; // @[sm_x119_outr_Foreach.scala 115:24:@13377.4]
  wire  x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x76_numel_0_rPort_0_en_0; // @[sm_x119_outr_Foreach.scala 115:24:@13377.4]
  wire [31:0] x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x76_numel_0_rPort_0_output_0; // @[sm_x119_outr_Foreach.scala 115:24:@13377.4]
  wire  x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x76_numel_0_empty; // @[sm_x119_outr_Foreach.scala 115:24:@13377.4]
  wire [31:0] x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x80_numelOut_0_wPort_0_data_0; // @[sm_x119_outr_Foreach.scala 115:24:@13377.4]
  wire  x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x80_numelOut_0_wPort_0_en_0; // @[sm_x119_outr_Foreach.scala 115:24:@13377.4]
  wire  x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x80_numelOut_0_full; // @[sm_x119_outr_Foreach.scala 115:24:@13377.4]
  wire  x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x80_numelOut_0_accessActivesOut_0; // @[sm_x119_outr_Foreach.scala 115:24:@13377.4]
  wire  x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x80_numelOut_0_accessActivesIn_0; // @[sm_x119_outr_Foreach.scala 115:24:@13377.4]
  wire [15:0] x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x79_payload_0_wPort_0_data_0; // @[sm_x119_outr_Foreach.scala 115:24:@13377.4]
  wire  x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x79_payload_0_wPort_0_en_0; // @[sm_x119_outr_Foreach.scala 115:24:@13377.4]
  wire  x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x79_payload_0_full; // @[sm_x119_outr_Foreach.scala 115:24:@13377.4]
  wire  x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x79_payload_0_accessActivesOut_0; // @[sm_x119_outr_Foreach.scala 115:24:@13377.4]
  wire  x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x79_payload_0_accessActivesIn_0; // @[sm_x119_outr_Foreach.scala 115:24:@13377.4]
  wire  x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_sigsIn_smEnableOuts_0; // @[sm_x119_outr_Foreach.scala 115:24:@13377.4]
  wire  x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_sigsIn_smEnableOuts_1; // @[sm_x119_outr_Foreach.scala 115:24:@13377.4]
  wire  x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_sigsIn_smChildAcks_0; // @[sm_x119_outr_Foreach.scala 115:24:@13377.4]
  wire  x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_sigsIn_smChildAcks_1; // @[sm_x119_outr_Foreach.scala 115:24:@13377.4]
  wire [31:0] x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_sigsIn_cchainOutputs_0_counts_0; // @[sm_x119_outr_Foreach.scala 115:24:@13377.4]
  wire  x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_sigsIn_cchainOutputs_0_oobs_0; // @[sm_x119_outr_Foreach.scala 115:24:@13377.4]
  wire  x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_sigsOut_smDoneIn_0; // @[sm_x119_outr_Foreach.scala 115:24:@13377.4]
  wire  x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_sigsOut_smDoneIn_1; // @[sm_x119_outr_Foreach.scala 115:24:@13377.4]
  wire  x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_sigsOut_smMaskIn_0; // @[sm_x119_outr_Foreach.scala 115:24:@13377.4]
  wire  x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_sigsOut_smMaskIn_1; // @[sm_x119_outr_Foreach.scala 115:24:@13377.4]
  wire  x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_rr; // @[sm_x119_outr_Foreach.scala 115:24:@13377.4]
  wire  _T_1027; // @[package.scala 96:25:@13298.4 package.scala 96:25:@13299.4]
  wire  _T_1042; // @[package.scala 96:25:@13343.4 package.scala 96:25:@13344.4]
  wire  _T_1048; // @[package.scala 96:25:@13351.4 package.scala 96:25:@13352.4]
  wire  _T_1051; // @[SpatialBlocks.scala 110:93:@13354.4]
  bbox_x85_ctrchain x85_ctrchain ( // @[SpatialBlocks.scala 37:22:@13203.4]
    .clock(x85_ctrchain_clock),
    .reset(x85_ctrchain_reset),
    .io_input_reset(x85_ctrchain_io_input_reset),
    .io_input_enable(x85_ctrchain_io_input_enable),
    .io_output_counts_0(x85_ctrchain_io_output_counts_0),
    .io_output_oobs_0(x85_ctrchain_io_output_oobs_0),
    .io_output_done(x85_ctrchain_io_output_done)
  );
  bbox_x119_outr_Foreach_sm x119_outr_Foreach_sm ( // @[sm_x119_outr_Foreach.scala 32:18:@13260.4]
    .clock(x119_outr_Foreach_sm_clock),
    .reset(x119_outr_Foreach_sm_reset),
    .io_enable(x119_outr_Foreach_sm_io_enable),
    .io_done(x119_outr_Foreach_sm_io_done),
    .io_ctrDone(x119_outr_Foreach_sm_io_ctrDone),
    .io_ctrInc(x119_outr_Foreach_sm_io_ctrInc),
    .io_ctrRst(x119_outr_Foreach_sm_io_ctrRst),
    .io_parentAck(x119_outr_Foreach_sm_io_parentAck),
    .io_doneIn_0(x119_outr_Foreach_sm_io_doneIn_0),
    .io_doneIn_1(x119_outr_Foreach_sm_io_doneIn_1),
    .io_maskIn_0(x119_outr_Foreach_sm_io_maskIn_0),
    .io_maskIn_1(x119_outr_Foreach_sm_io_maskIn_1),
    .io_enableOut_0(x119_outr_Foreach_sm_io_enableOut_0),
    .io_enableOut_1(x119_outr_Foreach_sm_io_enableOut_1),
    .io_childAck_0(x119_outr_Foreach_sm_io_childAck_0),
    .io_childAck_1(x119_outr_Foreach_sm_io_childAck_1)
  );
  bbox_RetimeWrapper RetimeWrapper ( // @[package.scala 93:22:@13293.4]
    .clock(RetimeWrapper_clock),
    .reset(RetimeWrapper_reset),
    .io_flow(RetimeWrapper_io_flow),
    .io_in(RetimeWrapper_io_in),
    .io_out(RetimeWrapper_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_1 ( // @[package.scala 93:22:@13338.4]
    .clock(RetimeWrapper_1_clock),
    .reset(RetimeWrapper_1_reset),
    .io_flow(RetimeWrapper_1_io_flow),
    .io_in(RetimeWrapper_1_io_in),
    .io_out(RetimeWrapper_1_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_2 ( // @[package.scala 93:22:@13346.4]
    .clock(RetimeWrapper_2_clock),
    .reset(RetimeWrapper_2_reset),
    .io_flow(RetimeWrapper_2_io_flow),
    .io_in(RetimeWrapper_2_io_in),
    .io_out(RetimeWrapper_2_io_out)
  );
  bbox_x119_outr_Foreach_kernelx119_outr_Foreach_concrete1 x119_outr_Foreach_kernelx119_outr_Foreach_concrete1 ( // @[sm_x119_outr_Foreach.scala 115:24:@13377.4]
    .clock(x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_clock),
    .reset(x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_reset),
    .io_in_x78_index_0_wPort_0_data_0(x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x78_index_0_wPort_0_data_0),
    .io_in_x78_index_0_wPort_0_en_0(x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x78_index_0_wPort_0_en_0),
    .io_in_x78_index_0_full(x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x78_index_0_full),
    .io_in_x78_index_0_accessActivesOut_0(x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x78_index_0_accessActivesOut_0),
    .io_in_x78_index_0_accessActivesIn_0(x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x78_index_0_accessActivesIn_0),
    .io_in_x77_scalar_0_rPort_0_en_0(x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x77_scalar_0_rPort_0_en_0),
    .io_in_x77_scalar_0_rPort_0_output_0(x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x77_scalar_0_rPort_0_output_0),
    .io_in_x77_scalar_0_empty(x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x77_scalar_0_empty),
    .io_in_x76_numel_0_rPort_0_en_0(x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x76_numel_0_rPort_0_en_0),
    .io_in_x76_numel_0_rPort_0_output_0(x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x76_numel_0_rPort_0_output_0),
    .io_in_x76_numel_0_empty(x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x76_numel_0_empty),
    .io_in_x80_numelOut_0_wPort_0_data_0(x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x80_numelOut_0_wPort_0_data_0),
    .io_in_x80_numelOut_0_wPort_0_en_0(x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x80_numelOut_0_wPort_0_en_0),
    .io_in_x80_numelOut_0_full(x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x80_numelOut_0_full),
    .io_in_x80_numelOut_0_accessActivesOut_0(x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x80_numelOut_0_accessActivesOut_0),
    .io_in_x80_numelOut_0_accessActivesIn_0(x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x80_numelOut_0_accessActivesIn_0),
    .io_in_x79_payload_0_wPort_0_data_0(x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x79_payload_0_wPort_0_data_0),
    .io_in_x79_payload_0_wPort_0_en_0(x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x79_payload_0_wPort_0_en_0),
    .io_in_x79_payload_0_full(x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x79_payload_0_full),
    .io_in_x79_payload_0_accessActivesOut_0(x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x79_payload_0_accessActivesOut_0),
    .io_in_x79_payload_0_accessActivesIn_0(x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x79_payload_0_accessActivesIn_0),
    .io_sigsIn_smEnableOuts_0(x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_sigsIn_smEnableOuts_0),
    .io_sigsIn_smEnableOuts_1(x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_sigsIn_smEnableOuts_1),
    .io_sigsIn_smChildAcks_0(x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_sigsIn_smChildAcks_0),
    .io_sigsIn_smChildAcks_1(x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_sigsIn_smChildAcks_1),
    .io_sigsIn_cchainOutputs_0_counts_0(x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_sigsIn_cchainOutputs_0_counts_0),
    .io_sigsIn_cchainOutputs_0_oobs_0(x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_sigsIn_cchainOutputs_0_oobs_0),
    .io_sigsOut_smDoneIn_0(x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_sigsOut_smDoneIn_0),
    .io_sigsOut_smDoneIn_1(x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_sigsOut_smDoneIn_1),
    .io_sigsOut_smMaskIn_0(x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_sigsOut_smMaskIn_0),
    .io_sigsOut_smMaskIn_1(x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_sigsOut_smMaskIn_1),
    .io_rr(x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_rr)
  );
  assign _T_1027 = RetimeWrapper_io_out; // @[package.scala 96:25:@13298.4 package.scala 96:25:@13299.4]
  assign _T_1042 = RetimeWrapper_1_io_out; // @[package.scala 96:25:@13343.4 package.scala 96:25:@13344.4]
  assign _T_1048 = RetimeWrapper_2_io_out; // @[package.scala 96:25:@13351.4 package.scala 96:25:@13352.4]
  assign _T_1051 = ~ _T_1048; // @[SpatialBlocks.scala 110:93:@13354.4]
  assign io_in_x78_index_0_wPort_0_data_0 = x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x78_index_0_wPort_0_data_0; // @[MemInterfaceType.scala 67:44:@13533.4]
  assign io_in_x78_index_0_wPort_0_en_0 = x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x78_index_0_wPort_0_en_0; // @[MemInterfaceType.scala 67:44:@13529.4]
  assign io_in_x78_index_0_accessActivesIn_0 = x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x78_index_0_accessActivesIn_0; // @[MemInterfaceType.scala 69:92:@13536.4]
  assign io_in_x77_scalar_0_rPort_0_en_0 = x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x77_scalar_0_rPort_0_en_0; // @[MemInterfaceType.scala 66:44:@13546.4]
  assign io_in_x76_numel_0_rPort_0_en_0 = x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x76_numel_0_rPort_0_en_0; // @[MemInterfaceType.scala 66:44:@13559.4]
  assign io_in_x80_numelOut_0_wPort_0_data_0 = x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x80_numelOut_0_wPort_0_data_0; // @[MemInterfaceType.scala 67:44:@13574.4]
  assign io_in_x80_numelOut_0_wPort_0_en_0 = x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x80_numelOut_0_wPort_0_en_0; // @[MemInterfaceType.scala 67:44:@13570.4]
  assign io_in_x80_numelOut_0_accessActivesIn_0 = x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x80_numelOut_0_accessActivesIn_0; // @[MemInterfaceType.scala 69:92:@13577.4]
  assign io_in_x79_payload_0_wPort_0_data_0 = x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x79_payload_0_wPort_0_data_0; // @[MemInterfaceType.scala 67:44:@13589.4]
  assign io_in_x79_payload_0_wPort_0_en_0 = x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x79_payload_0_wPort_0_en_0; // @[MemInterfaceType.scala 67:44:@13585.4]
  assign io_in_x79_payload_0_accessActivesIn_0 = x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x79_payload_0_accessActivesIn_0; // @[MemInterfaceType.scala 69:92:@13592.4]
  assign io_sigsOut_smDoneIn_0 = x119_outr_Foreach_sm_io_done; // @[SpatialBlocks.scala 127:53:@13361.4]
  assign x85_ctrchain_clock = clock; // @[:@13204.4]
  assign x85_ctrchain_reset = reset; // @[:@13205.4]
  assign x85_ctrchain_io_input_reset = x119_outr_Foreach_sm_io_ctrRst; // @[SpatialBlocks.scala 130:100:@13376.4]
  assign x85_ctrchain_io_input_enable = x119_outr_Foreach_sm_io_ctrInc; // @[SpatialBlocks.scala 104:75:@13331.4 SpatialBlocks.scala 130:42:@13375.4]
  assign x119_outr_Foreach_sm_clock = clock; // @[:@13261.4]
  assign x119_outr_Foreach_sm_reset = reset; // @[:@13262.4]
  assign x119_outr_Foreach_sm_io_enable = _T_1042 & _T_1051; // @[SpatialBlocks.scala 112:18:@13358.4]
  assign x119_outr_Foreach_sm_io_ctrDone = io_rr ? _T_1027 : 1'h0; // @[sm_x120_outr_UnitPipe_BBOX.scala 77:39:@13301.4]
  assign x119_outr_Foreach_sm_io_parentAck = io_sigsIn_smChildAcks_0; // @[SpatialBlocks.scala 114:21:@13360.4]
  assign x119_outr_Foreach_sm_io_doneIn_0 = x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_sigsOut_smDoneIn_0; // @[SpatialBlocks.scala 102:67:@13327.4]
  assign x119_outr_Foreach_sm_io_doneIn_1 = x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_sigsOut_smDoneIn_1; // @[SpatialBlocks.scala 102:67:@13328.4]
  assign x119_outr_Foreach_sm_io_maskIn_0 = x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_sigsOut_smMaskIn_0; // @[SpatialBlocks.scala 103:67:@13329.4]
  assign x119_outr_Foreach_sm_io_maskIn_1 = x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_sigsOut_smMaskIn_1; // @[SpatialBlocks.scala 103:67:@13330.4]
  assign RetimeWrapper_clock = clock; // @[:@13294.4]
  assign RetimeWrapper_reset = reset; // @[:@13295.4]
  assign RetimeWrapper_io_flow = 1'h1; // @[package.scala 95:18:@13297.4]
  assign RetimeWrapper_io_in = x85_ctrchain_io_output_done; // @[package.scala 94:16:@13296.4]
  assign RetimeWrapper_1_clock = clock; // @[:@13339.4]
  assign RetimeWrapper_1_reset = reset; // @[:@13340.4]
  assign RetimeWrapper_1_io_flow = 1'h1; // @[package.scala 95:18:@13342.4]
  assign RetimeWrapper_1_io_in = io_sigsIn_smEnableOuts_0; // @[package.scala 94:16:@13341.4]
  assign RetimeWrapper_2_clock = clock; // @[:@13347.4]
  assign RetimeWrapper_2_reset = reset; // @[:@13348.4]
  assign RetimeWrapper_2_io_flow = 1'h1; // @[package.scala 95:18:@13350.4]
  assign RetimeWrapper_2_io_in = x119_outr_Foreach_sm_io_done; // @[package.scala 94:16:@13349.4]
  assign x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_clock = clock; // @[:@13378.4]
  assign x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_reset = reset; // @[:@13379.4]
  assign x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x78_index_0_full = io_in_x78_index_0_full; // @[MemInterfaceType.scala 151:13:@13522.4]
  assign x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x78_index_0_accessActivesOut_0 = io_in_x78_index_0_accessActivesOut_0; // @[MemInterfaceType.scala 156:25:@13527.4]
  assign x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x77_scalar_0_rPort_0_output_0 = io_in_x77_scalar_0_rPort_0_output_0; // @[MemInterfaceType.scala 66:44:@13544.4]
  assign x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x77_scalar_0_empty = io_in_x77_scalar_0_empty; // @[MemInterfaceType.scala 153:14:@13539.4]
  assign x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x76_numel_0_rPort_0_output_0 = io_in_x76_numel_0_rPort_0_output_0; // @[MemInterfaceType.scala 66:44:@13557.4]
  assign x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x76_numel_0_empty = io_in_x76_numel_0_empty; // @[MemInterfaceType.scala 153:14:@13552.4]
  assign x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x80_numelOut_0_full = io_in_x80_numelOut_0_full; // @[MemInterfaceType.scala 151:13:@13563.4]
  assign x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x80_numelOut_0_accessActivesOut_0 = io_in_x80_numelOut_0_accessActivesOut_0; // @[MemInterfaceType.scala 156:25:@13568.4]
  assign x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x79_payload_0_full = io_in_x79_payload_0_full; // @[MemInterfaceType.scala 151:13:@13578.4]
  assign x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_in_x79_payload_0_accessActivesOut_0 = io_in_x79_payload_0_accessActivesOut_0; // @[MemInterfaceType.scala 156:25:@13583.4]
  assign x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_sigsIn_smEnableOuts_0 = x119_outr_Foreach_sm_io_enableOut_0; // @[sm_x119_outr_Foreach.scala 120:22:@13603.4]
  assign x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_sigsIn_smEnableOuts_1 = x119_outr_Foreach_sm_io_enableOut_1; // @[sm_x119_outr_Foreach.scala 120:22:@13604.4]
  assign x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_sigsIn_smChildAcks_0 = x119_outr_Foreach_sm_io_childAck_0; // @[sm_x119_outr_Foreach.scala 120:22:@13599.4]
  assign x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_sigsIn_smChildAcks_1 = x119_outr_Foreach_sm_io_childAck_1; // @[sm_x119_outr_Foreach.scala 120:22:@13600.4]
  assign x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_sigsIn_cchainOutputs_0_counts_0 = x85_ctrchain_io_output_counts_0; // @[sm_x119_outr_Foreach.scala 120:22:@13598.4]
  assign x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_sigsIn_cchainOutputs_0_oobs_0 = x85_ctrchain_io_output_oobs_0; // @[sm_x119_outr_Foreach.scala 120:22:@13597.4]
  assign x119_outr_Foreach_kernelx119_outr_Foreach_concrete1_io_rr = io_rr; // @[sm_x119_outr_Foreach.scala 119:18:@13593.4]
endmodule
module bbox_x139_inr_UnitPipe_sm( // @[:@13811.2]
  input   clock, // @[:@13812.4]
  input   reset, // @[:@13813.4]
  input   io_enable, // @[:@13814.4]
  output  io_done, // @[:@13814.4]
  output  io_doneLatch, // @[:@13814.4]
  input   io_ctrDone, // @[:@13814.4]
  output  io_datapathEn, // @[:@13814.4]
  output  io_ctrInc, // @[:@13814.4]
  input   io_parentAck, // @[:@13814.4]
  input   io_break // @[:@13814.4]
);
  wire  active_clock; // @[Controllers.scala 261:22:@13816.4]
  wire  active_reset; // @[Controllers.scala 261:22:@13816.4]
  wire  active_io_input_set; // @[Controllers.scala 261:22:@13816.4]
  wire  active_io_input_reset; // @[Controllers.scala 261:22:@13816.4]
  wire  active_io_input_asyn_reset; // @[Controllers.scala 261:22:@13816.4]
  wire  active_io_output; // @[Controllers.scala 261:22:@13816.4]
  wire  done_clock; // @[Controllers.scala 262:20:@13819.4]
  wire  done_reset; // @[Controllers.scala 262:20:@13819.4]
  wire  done_io_input_set; // @[Controllers.scala 262:20:@13819.4]
  wire  done_io_input_reset; // @[Controllers.scala 262:20:@13819.4]
  wire  done_io_input_asyn_reset; // @[Controllers.scala 262:20:@13819.4]
  wire  done_io_output; // @[Controllers.scala 262:20:@13819.4]
  wire  RetimeWrapper_clock; // @[package.scala 93:22:@13853.4]
  wire  RetimeWrapper_reset; // @[package.scala 93:22:@13853.4]
  wire  RetimeWrapper_io_in; // @[package.scala 93:22:@13853.4]
  wire  RetimeWrapper_io_out; // @[package.scala 93:22:@13853.4]
  wire  RetimeWrapper_1_clock; // @[package.scala 93:22:@13875.4]
  wire  RetimeWrapper_1_reset; // @[package.scala 93:22:@13875.4]
  wire  RetimeWrapper_1_io_in; // @[package.scala 93:22:@13875.4]
  wire  RetimeWrapper_1_io_out; // @[package.scala 93:22:@13875.4]
  wire  RetimeWrapper_2_clock; // @[package.scala 93:22:@13887.4]
  wire  RetimeWrapper_2_reset; // @[package.scala 93:22:@13887.4]
  wire  RetimeWrapper_2_io_flow; // @[package.scala 93:22:@13887.4]
  wire  RetimeWrapper_2_io_in; // @[package.scala 93:22:@13887.4]
  wire  RetimeWrapper_2_io_out; // @[package.scala 93:22:@13887.4]
  wire  RetimeWrapper_3_clock; // @[package.scala 93:22:@13895.4]
  wire  RetimeWrapper_3_reset; // @[package.scala 93:22:@13895.4]
  wire  RetimeWrapper_3_io_flow; // @[package.scala 93:22:@13895.4]
  wire  RetimeWrapper_3_io_in; // @[package.scala 93:22:@13895.4]
  wire  RetimeWrapper_3_io_out; // @[package.scala 93:22:@13895.4]
  wire  RetimeWrapper_4_clock; // @[package.scala 93:22:@13911.4]
  wire  RetimeWrapper_4_reset; // @[package.scala 93:22:@13911.4]
  wire  RetimeWrapper_4_io_flow; // @[package.scala 93:22:@13911.4]
  wire  RetimeWrapper_4_io_in; // @[package.scala 93:22:@13911.4]
  wire  RetimeWrapper_4_io_out; // @[package.scala 93:22:@13911.4]
  wire  _T_80; // @[Controllers.scala 264:48:@13824.4]
  wire  _T_81; // @[Controllers.scala 264:46:@13825.4]
  wire  _T_82; // @[Controllers.scala 264:62:@13826.4]
  wire  _T_100; // @[package.scala 100:49:@13844.4]
  reg  _T_103; // @[package.scala 48:56:@13845.4]
  reg [31:0] _RAND_0;
  wire  _T_118; // @[Controllers.scala 283:41:@13868.4]
  wire  _T_124; // @[package.scala 96:25:@13880.4 package.scala 96:25:@13881.4]
  wire  _T_126; // @[package.scala 100:49:@13882.4]
  reg  _T_129; // @[package.scala 48:56:@13883.4]
  reg [31:0] _RAND_1;
  reg  _T_146; // @[Controllers.scala 291:31:@13905.4]
  reg [31:0] _RAND_2;
  wire  _T_150; // @[package.scala 100:49:@13907.4]
  reg  _T_153; // @[package.scala 48:56:@13908.4]
  reg [31:0] _RAND_3;
  wire  _T_156; // @[package.scala 96:25:@13916.4 package.scala 96:25:@13917.4]
  wire  _T_158; // @[Controllers.scala 292:61:@13918.4]
  wire  _T_159; // @[Controllers.scala 292:24:@13919.4]
  bbox_SRFF active ( // @[Controllers.scala 261:22:@13816.4]
    .clock(active_clock),
    .reset(active_reset),
    .io_input_set(active_io_input_set),
    .io_input_reset(active_io_input_reset),
    .io_input_asyn_reset(active_io_input_asyn_reset),
    .io_output(active_io_output)
  );
  bbox_SRFF done ( // @[Controllers.scala 262:20:@13819.4]
    .clock(done_clock),
    .reset(done_reset),
    .io_input_set(done_io_input_set),
    .io_input_reset(done_io_input_reset),
    .io_input_asyn_reset(done_io_input_asyn_reset),
    .io_output(done_io_output)
  );
  bbox_RetimeWrapper_99 RetimeWrapper ( // @[package.scala 93:22:@13853.4]
    .clock(RetimeWrapper_clock),
    .reset(RetimeWrapper_reset),
    .io_in(RetimeWrapper_io_in),
    .io_out(RetimeWrapper_io_out)
  );
  bbox_RetimeWrapper_99 RetimeWrapper_1 ( // @[package.scala 93:22:@13875.4]
    .clock(RetimeWrapper_1_clock),
    .reset(RetimeWrapper_1_reset),
    .io_in(RetimeWrapper_1_io_in),
    .io_out(RetimeWrapper_1_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_2 ( // @[package.scala 93:22:@13887.4]
    .clock(RetimeWrapper_2_clock),
    .reset(RetimeWrapper_2_reset),
    .io_flow(RetimeWrapper_2_io_flow),
    .io_in(RetimeWrapper_2_io_in),
    .io_out(RetimeWrapper_2_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_3 ( // @[package.scala 93:22:@13895.4]
    .clock(RetimeWrapper_3_clock),
    .reset(RetimeWrapper_3_reset),
    .io_flow(RetimeWrapper_3_io_flow),
    .io_in(RetimeWrapper_3_io_in),
    .io_out(RetimeWrapper_3_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_4 ( // @[package.scala 93:22:@13911.4]
    .clock(RetimeWrapper_4_clock),
    .reset(RetimeWrapper_4_reset),
    .io_flow(RetimeWrapper_4_io_flow),
    .io_in(RetimeWrapper_4_io_in),
    .io_out(RetimeWrapper_4_io_out)
  );
  assign _T_80 = ~ io_ctrDone; // @[Controllers.scala 264:48:@13824.4]
  assign _T_81 = io_enable & _T_80; // @[Controllers.scala 264:46:@13825.4]
  assign _T_82 = ~ done_io_output; // @[Controllers.scala 264:62:@13826.4]
  assign _T_100 = io_ctrDone == 1'h0; // @[package.scala 100:49:@13844.4]
  assign _T_118 = active_io_output & _T_82; // @[Controllers.scala 283:41:@13868.4]
  assign _T_124 = RetimeWrapper_1_io_out; // @[package.scala 96:25:@13880.4 package.scala 96:25:@13881.4]
  assign _T_126 = _T_124 == 1'h0; // @[package.scala 100:49:@13882.4]
  assign _T_150 = done_io_output == 1'h0; // @[package.scala 100:49:@13907.4]
  assign _T_156 = RetimeWrapper_4_io_out; // @[package.scala 96:25:@13916.4 package.scala 96:25:@13917.4]
  assign _T_158 = _T_156 ? 1'h1 : _T_146; // @[Controllers.scala 292:61:@13918.4]
  assign _T_159 = io_parentAck ? 1'h0 : _T_158; // @[Controllers.scala 292:24:@13919.4]
  assign io_done = _T_124 & _T_129; // @[Controllers.scala 287:13:@13886.4]
  assign io_doneLatch = _T_146; // @[Controllers.scala 293:18:@13921.4]
  assign io_datapathEn = _T_118 & io_enable; // @[Controllers.scala 283:21:@13871.4]
  assign io_ctrInc = active_io_output & io_enable; // @[Controllers.scala 284:17:@13874.4]
  assign active_clock = clock; // @[:@13817.4]
  assign active_reset = reset; // @[:@13818.4]
  assign active_io_input_set = _T_81 & _T_82; // @[Controllers.scala 264:23:@13829.4]
  assign active_io_input_reset = io_ctrDone | io_parentAck; // @[Controllers.scala 265:25:@13833.4]
  assign active_io_input_asyn_reset = 1'h0; // @[Controllers.scala 266:30:@13834.4]
  assign done_clock = clock; // @[:@13820.4]
  assign done_reset = reset; // @[:@13821.4]
  assign done_io_input_set = io_ctrDone & _T_103; // @[Controllers.scala 269:104:@13849.4]
  assign done_io_input_reset = io_parentAck; // @[Controllers.scala 267:23:@13842.4]
  assign done_io_input_asyn_reset = 1'h0; // @[Controllers.scala 268:28:@13843.4]
  assign RetimeWrapper_clock = clock; // @[:@13854.4]
  assign RetimeWrapper_reset = reset; // @[:@13855.4]
  assign RetimeWrapper_io_in = done_io_output; // @[package.scala 94:16:@13856.4]
  assign RetimeWrapper_1_clock = clock; // @[:@13876.4]
  assign RetimeWrapper_1_reset = reset; // @[:@13877.4]
  assign RetimeWrapper_1_io_in = done_io_output; // @[package.scala 94:16:@13878.4]
  assign RetimeWrapper_2_clock = clock; // @[:@13888.4]
  assign RetimeWrapper_2_reset = reset; // @[:@13889.4]
  assign RetimeWrapper_2_io_flow = 1'h1; // @[package.scala 95:18:@13891.4]
  assign RetimeWrapper_2_io_in = 1'h0; // @[package.scala 94:16:@13890.4]
  assign RetimeWrapper_3_clock = clock; // @[:@13896.4]
  assign RetimeWrapper_3_reset = reset; // @[:@13897.4]
  assign RetimeWrapper_3_io_flow = 1'h1; // @[package.scala 95:18:@13899.4]
  assign RetimeWrapper_3_io_in = io_ctrDone; // @[package.scala 94:16:@13898.4]
  assign RetimeWrapper_4_clock = clock; // @[:@13912.4]
  assign RetimeWrapper_4_reset = reset; // @[:@13913.4]
  assign RetimeWrapper_4_io_flow = 1'h1; // @[package.scala 95:18:@13915.4]
  assign RetimeWrapper_4_io_in = done_io_output & _T_153; // @[package.scala 94:16:@13914.4]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  _T_103 = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  _T_129 = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  _T_146 = _RAND_2[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  _T_153 = _RAND_3[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      _T_103 <= 1'h0;
    end else begin
      _T_103 <= _T_100;
    end
    if (reset) begin
      _T_129 <= 1'h0;
    end else begin
      _T_129 <= _T_126;
    end
    if (reset) begin
      _T_146 <= 1'h0;
    end else begin
      if (io_parentAck) begin
        _T_146 <= 1'h0;
      end else begin
        if (_T_156) begin
          _T_146 <= 1'h1;
        end
      end
    end
    if (reset) begin
      _T_153 <= 1'h0;
    end else begin
      _T_153 <= _T_150;
    end
  end
endmodule
module bbox_x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1( // @[:@14091.2]
  input         clock, // @[:@14092.4]
  input         reset, // @[:@14093.4]
  output        io_in_x78_index_0_rPort_0_en_0, // @[:@14094.4]
  input  [31:0] io_in_x78_index_0_rPort_0_output_0, // @[:@14094.4]
  output        io_in_x80_numelOut_0_rPort_0_en_0, // @[:@14094.4]
  input  [31:0] io_in_x80_numelOut_0_rPort_0_output_0, // @[:@14094.4]
  output        io_in_x79_payload_0_rPort_0_en_0, // @[:@14094.4]
  input  [15:0] io_in_x79_payload_0_rPort_0_output_0, // @[:@14094.4]
  input         io_sigsIn_datapathEn, // @[:@14094.4]
  input         io_sigsIn_break, // @[:@14094.4]
  input         io_rr // @[:@14094.4]
);
  wire  RetimeWrapper_clock; // @[package.scala 93:22:@14182.4]
  wire  RetimeWrapper_reset; // @[package.scala 93:22:@14182.4]
  wire [31:0] RetimeWrapper_io_in; // @[package.scala 93:22:@14182.4]
  wire [31:0] RetimeWrapper_io_out; // @[package.scala 93:22:@14182.4]
  wire  RetimeWrapper_1_clock; // @[package.scala 93:22:@14204.4]
  wire  RetimeWrapper_1_reset; // @[package.scala 93:22:@14204.4]
  wire [15:0] RetimeWrapper_1_io_in; // @[package.scala 93:22:@14204.4]
  wire [15:0] RetimeWrapper_1_io_out; // @[package.scala 93:22:@14204.4]
  wire  RetimeWrapper_2_clock; // @[package.scala 93:22:@14226.4]
  wire  RetimeWrapper_2_reset; // @[package.scala 93:22:@14226.4]
  wire [31:0] RetimeWrapper_2_io_in; // @[package.scala 93:22:@14226.4]
  wire [31:0] RetimeWrapper_2_io_out; // @[package.scala 93:22:@14226.4]
  wire  _T_633; // @[sm_x139_inr_UnitPipe.scala 68:149:@14171.4]
  wire  _T_637; // @[implicits.scala 55:10:@14174.4]
  bbox_RetimeWrapper_104 RetimeWrapper ( // @[package.scala 93:22:@14182.4]
    .clock(RetimeWrapper_clock),
    .reset(RetimeWrapper_reset),
    .io_in(RetimeWrapper_io_in),
    .io_out(RetimeWrapper_io_out)
  );
  bbox_RetimeWrapper_105 RetimeWrapper_1 ( // @[package.scala 93:22:@14204.4]
    .clock(RetimeWrapper_1_clock),
    .reset(RetimeWrapper_1_reset),
    .io_in(RetimeWrapper_1_io_in),
    .io_out(RetimeWrapper_1_io_out)
  );
  bbox_RetimeWrapper_104 RetimeWrapper_2 ( // @[package.scala 93:22:@14226.4]
    .clock(RetimeWrapper_2_clock),
    .reset(RetimeWrapper_2_reset),
    .io_in(RetimeWrapper_2_io_in),
    .io_out(RetimeWrapper_2_io_out)
  );
  assign _T_633 = ~ io_sigsIn_break; // @[sm_x139_inr_UnitPipe.scala 68:149:@14171.4]
  assign _T_637 = io_rr ? io_sigsIn_datapathEn : 1'h0; // @[implicits.scala 55:10:@14174.4]
  assign io_in_x78_index_0_rPort_0_en_0 = _T_633 & _T_637; // @[MemInterfaceType.scala 110:79:@14178.4]
  assign io_in_x80_numelOut_0_rPort_0_en_0 = _T_633 & _T_637; // @[MemInterfaceType.scala 110:79:@14222.4]
  assign io_in_x79_payload_0_rPort_0_en_0 = _T_633 & _T_637; // @[MemInterfaceType.scala 110:79:@14200.4]
  assign RetimeWrapper_clock = clock; // @[:@14183.4]
  assign RetimeWrapper_reset = reset; // @[:@14184.4]
  assign RetimeWrapper_io_in = io_in_x78_index_0_rPort_0_output_0; // @[package.scala 94:16:@14185.4]
  assign RetimeWrapper_1_clock = clock; // @[:@14205.4]
  assign RetimeWrapper_1_reset = reset; // @[:@14206.4]
  assign RetimeWrapper_1_io_in = io_in_x79_payload_0_rPort_0_output_0; // @[package.scala 94:16:@14207.4]
  assign RetimeWrapper_2_clock = clock; // @[:@14227.4]
  assign RetimeWrapper_2_reset = reset; // @[:@14228.4]
  assign RetimeWrapper_2_io_in = io_in_x80_numelOut_0_rPort_0_output_0; // @[package.scala 94:16:@14229.4]
endmodule
module bbox_x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1( // @[:@14237.2]
  input   clock, // @[:@14238.4]
  input   reset, // @[:@14239.4]
  input   io_sigsIn_smEnableOuts_0, // @[:@14240.4]
  input   io_sigsIn_smEnableOuts_1, // @[:@14240.4]
  input   io_sigsIn_smEnableOuts_2, // @[:@14240.4]
  input   io_sigsIn_smChildAcks_0, // @[:@14240.4]
  input   io_sigsIn_smChildAcks_1, // @[:@14240.4]
  input   io_sigsIn_smChildAcks_2, // @[:@14240.4]
  output  io_sigsOut_smDoneIn_0, // @[:@14240.4]
  output  io_sigsOut_smDoneIn_1, // @[:@14240.4]
  output  io_sigsOut_smDoneIn_2, // @[:@14240.4]
  output  io_sigsOut_smCtrCopyDone_0, // @[:@14240.4]
  output  io_sigsOut_smCtrCopyDone_1, // @[:@14240.4]
  output  io_sigsOut_smCtrCopyDone_2, // @[:@14240.4]
  input   io_rr // @[:@14240.4]
);
  wire  x76_numel_0_clock; // @[m_x76_numel_0.scala 27:17:@14258.4]
  wire  x76_numel_0_reset; // @[m_x76_numel_0.scala 27:17:@14258.4]
  wire  x76_numel_0_io_rPort_0_en_0; // @[m_x76_numel_0.scala 27:17:@14258.4]
  wire [31:0] x76_numel_0_io_rPort_0_output_0; // @[m_x76_numel_0.scala 27:17:@14258.4]
  wire [31:0] x76_numel_0_io_wPort_0_data_0; // @[m_x76_numel_0.scala 27:17:@14258.4]
  wire  x76_numel_0_io_wPort_0_en_0; // @[m_x76_numel_0.scala 27:17:@14258.4]
  wire  x76_numel_0_io_full; // @[m_x76_numel_0.scala 27:17:@14258.4]
  wire  x76_numel_0_io_empty; // @[m_x76_numel_0.scala 27:17:@14258.4]
  wire  x76_numel_0_io_accessActivesOut_0; // @[m_x76_numel_0.scala 27:17:@14258.4]
  wire  x76_numel_0_io_accessActivesIn_0; // @[m_x76_numel_0.scala 27:17:@14258.4]
  wire  x77_scalar_0_clock; // @[m_x77_scalar_0.scala 27:17:@14284.4]
  wire  x77_scalar_0_reset; // @[m_x77_scalar_0.scala 27:17:@14284.4]
  wire  x77_scalar_0_io_rPort_0_en_0; // @[m_x77_scalar_0.scala 27:17:@14284.4]
  wire [15:0] x77_scalar_0_io_rPort_0_output_0; // @[m_x77_scalar_0.scala 27:17:@14284.4]
  wire [15:0] x77_scalar_0_io_wPort_0_data_0; // @[m_x77_scalar_0.scala 27:17:@14284.4]
  wire  x77_scalar_0_io_wPort_0_en_0; // @[m_x77_scalar_0.scala 27:17:@14284.4]
  wire  x77_scalar_0_io_full; // @[m_x77_scalar_0.scala 27:17:@14284.4]
  wire  x77_scalar_0_io_empty; // @[m_x77_scalar_0.scala 27:17:@14284.4]
  wire  x77_scalar_0_io_accessActivesOut_0; // @[m_x77_scalar_0.scala 27:17:@14284.4]
  wire  x77_scalar_0_io_accessActivesIn_0; // @[m_x77_scalar_0.scala 27:17:@14284.4]
  wire  x78_index_0_clock; // @[m_x78_index_0.scala 27:17:@14310.4]
  wire  x78_index_0_reset; // @[m_x78_index_0.scala 27:17:@14310.4]
  wire  x78_index_0_io_rPort_0_en_0; // @[m_x78_index_0.scala 27:17:@14310.4]
  wire [31:0] x78_index_0_io_rPort_0_output_0; // @[m_x78_index_0.scala 27:17:@14310.4]
  wire [31:0] x78_index_0_io_wPort_0_data_0; // @[m_x78_index_0.scala 27:17:@14310.4]
  wire  x78_index_0_io_wPort_0_en_0; // @[m_x78_index_0.scala 27:17:@14310.4]
  wire  x78_index_0_io_full; // @[m_x78_index_0.scala 27:17:@14310.4]
  wire  x78_index_0_io_empty; // @[m_x78_index_0.scala 27:17:@14310.4]
  wire  x78_index_0_io_accessActivesOut_0; // @[m_x78_index_0.scala 27:17:@14310.4]
  wire  x78_index_0_io_accessActivesIn_0; // @[m_x78_index_0.scala 27:17:@14310.4]
  wire  x79_payload_0_clock; // @[m_x79_payload_0.scala 27:17:@14336.4]
  wire  x79_payload_0_reset; // @[m_x79_payload_0.scala 27:17:@14336.4]
  wire  x79_payload_0_io_rPort_0_en_0; // @[m_x79_payload_0.scala 27:17:@14336.4]
  wire [15:0] x79_payload_0_io_rPort_0_output_0; // @[m_x79_payload_0.scala 27:17:@14336.4]
  wire [15:0] x79_payload_0_io_wPort_0_data_0; // @[m_x79_payload_0.scala 27:17:@14336.4]
  wire  x79_payload_0_io_wPort_0_en_0; // @[m_x79_payload_0.scala 27:17:@14336.4]
  wire  x79_payload_0_io_full; // @[m_x79_payload_0.scala 27:17:@14336.4]
  wire  x79_payload_0_io_empty; // @[m_x79_payload_0.scala 27:17:@14336.4]
  wire  x79_payload_0_io_accessActivesOut_0; // @[m_x79_payload_0.scala 27:17:@14336.4]
  wire  x79_payload_0_io_accessActivesIn_0; // @[m_x79_payload_0.scala 27:17:@14336.4]
  wire  x80_numelOut_0_clock; // @[m_x80_numelOut_0.scala 27:17:@14362.4]
  wire  x80_numelOut_0_reset; // @[m_x80_numelOut_0.scala 27:17:@14362.4]
  wire  x80_numelOut_0_io_rPort_0_en_0; // @[m_x80_numelOut_0.scala 27:17:@14362.4]
  wire [31:0] x80_numelOut_0_io_rPort_0_output_0; // @[m_x80_numelOut_0.scala 27:17:@14362.4]
  wire [31:0] x80_numelOut_0_io_wPort_0_data_0; // @[m_x80_numelOut_0.scala 27:17:@14362.4]
  wire  x80_numelOut_0_io_wPort_0_en_0; // @[m_x80_numelOut_0.scala 27:17:@14362.4]
  wire  x80_numelOut_0_io_full; // @[m_x80_numelOut_0.scala 27:17:@14362.4]
  wire  x80_numelOut_0_io_empty; // @[m_x80_numelOut_0.scala 27:17:@14362.4]
  wire  x80_numelOut_0_io_accessActivesOut_0; // @[m_x80_numelOut_0.scala 27:17:@14362.4]
  wire  x80_numelOut_0_io_accessActivesIn_0; // @[m_x80_numelOut_0.scala 27:17:@14362.4]
  wire  x83_inr_UnitPipe_sm_clock; // @[sm_x83_inr_UnitPipe.scala 32:18:@14423.4]
  wire  x83_inr_UnitPipe_sm_reset; // @[sm_x83_inr_UnitPipe.scala 32:18:@14423.4]
  wire  x83_inr_UnitPipe_sm_io_enable; // @[sm_x83_inr_UnitPipe.scala 32:18:@14423.4]
  wire  x83_inr_UnitPipe_sm_io_done; // @[sm_x83_inr_UnitPipe.scala 32:18:@14423.4]
  wire  x83_inr_UnitPipe_sm_io_doneLatch; // @[sm_x83_inr_UnitPipe.scala 32:18:@14423.4]
  wire  x83_inr_UnitPipe_sm_io_ctrDone; // @[sm_x83_inr_UnitPipe.scala 32:18:@14423.4]
  wire  x83_inr_UnitPipe_sm_io_datapathEn; // @[sm_x83_inr_UnitPipe.scala 32:18:@14423.4]
  wire  x83_inr_UnitPipe_sm_io_ctrInc; // @[sm_x83_inr_UnitPipe.scala 32:18:@14423.4]
  wire  x83_inr_UnitPipe_sm_io_parentAck; // @[sm_x83_inr_UnitPipe.scala 32:18:@14423.4]
  wire  x83_inr_UnitPipe_sm_io_backpressure; // @[sm_x83_inr_UnitPipe.scala 32:18:@14423.4]
  wire  x83_inr_UnitPipe_sm_io_break; // @[sm_x83_inr_UnitPipe.scala 32:18:@14423.4]
  wire  RetimeWrapper_clock; // @[package.scala 93:22:@14487.4]
  wire  RetimeWrapper_reset; // @[package.scala 93:22:@14487.4]
  wire  RetimeWrapper_io_flow; // @[package.scala 93:22:@14487.4]
  wire  RetimeWrapper_io_in; // @[package.scala 93:22:@14487.4]
  wire  RetimeWrapper_io_out; // @[package.scala 93:22:@14487.4]
  wire  RetimeWrapper_1_clock; // @[package.scala 93:22:@14495.4]
  wire  RetimeWrapper_1_reset; // @[package.scala 93:22:@14495.4]
  wire  RetimeWrapper_1_io_flow; // @[package.scala 93:22:@14495.4]
  wire  RetimeWrapper_1_io_in; // @[package.scala 93:22:@14495.4]
  wire  RetimeWrapper_1_io_out; // @[package.scala 93:22:@14495.4]
  wire  x83_inr_UnitPipe_kernelx83_inr_UnitPipe_concrete1_io_in_x76_numel_0_wPort_0_en_0; // @[sm_x83_inr_UnitPipe.scala 73:24:@14522.4]
  wire  x83_inr_UnitPipe_kernelx83_inr_UnitPipe_concrete1_io_in_x77_scalar_0_wPort_0_en_0; // @[sm_x83_inr_UnitPipe.scala 73:24:@14522.4]
  wire  x83_inr_UnitPipe_kernelx83_inr_UnitPipe_concrete1_io_sigsIn_backpressure; // @[sm_x83_inr_UnitPipe.scala 73:24:@14522.4]
  wire  x83_inr_UnitPipe_kernelx83_inr_UnitPipe_concrete1_io_sigsIn_datapathEn; // @[sm_x83_inr_UnitPipe.scala 73:24:@14522.4]
  wire  x83_inr_UnitPipe_kernelx83_inr_UnitPipe_concrete1_io_sigsIn_break; // @[sm_x83_inr_UnitPipe.scala 73:24:@14522.4]
  wire  x83_inr_UnitPipe_kernelx83_inr_UnitPipe_concrete1_io_rr; // @[sm_x83_inr_UnitPipe.scala 73:24:@14522.4]
  wire  x120_outr_UnitPipe_BBOX_sm_clock; // @[sm_x120_outr_UnitPipe_BBOX.scala 32:18:@14687.4]
  wire  x120_outr_UnitPipe_BBOX_sm_reset; // @[sm_x120_outr_UnitPipe_BBOX.scala 32:18:@14687.4]
  wire  x120_outr_UnitPipe_BBOX_sm_io_enable; // @[sm_x120_outr_UnitPipe_BBOX.scala 32:18:@14687.4]
  wire  x120_outr_UnitPipe_BBOX_sm_io_done; // @[sm_x120_outr_UnitPipe_BBOX.scala 32:18:@14687.4]
  wire  x120_outr_UnitPipe_BBOX_sm_io_rst; // @[sm_x120_outr_UnitPipe_BBOX.scala 32:18:@14687.4]
  wire  x120_outr_UnitPipe_BBOX_sm_io_ctrDone; // @[sm_x120_outr_UnitPipe_BBOX.scala 32:18:@14687.4]
  wire  x120_outr_UnitPipe_BBOX_sm_io_ctrInc; // @[sm_x120_outr_UnitPipe_BBOX.scala 32:18:@14687.4]
  wire  x120_outr_UnitPipe_BBOX_sm_io_parentAck; // @[sm_x120_outr_UnitPipe_BBOX.scala 32:18:@14687.4]
  wire  x120_outr_UnitPipe_BBOX_sm_io_doneIn_0; // @[sm_x120_outr_UnitPipe_BBOX.scala 32:18:@14687.4]
  wire  x120_outr_UnitPipe_BBOX_sm_io_enableOut_0; // @[sm_x120_outr_UnitPipe_BBOX.scala 32:18:@14687.4]
  wire  x120_outr_UnitPipe_BBOX_sm_io_childAck_0; // @[sm_x120_outr_UnitPipe_BBOX.scala 32:18:@14687.4]
  wire  RetimeWrapper_2_clock; // @[package.scala 93:22:@14744.4]
  wire  RetimeWrapper_2_reset; // @[package.scala 93:22:@14744.4]
  wire  RetimeWrapper_2_io_flow; // @[package.scala 93:22:@14744.4]
  wire  RetimeWrapper_2_io_in; // @[package.scala 93:22:@14744.4]
  wire  RetimeWrapper_2_io_out; // @[package.scala 93:22:@14744.4]
  wire  RetimeWrapper_3_clock; // @[package.scala 93:22:@14752.4]
  wire  RetimeWrapper_3_reset; // @[package.scala 93:22:@14752.4]
  wire  RetimeWrapper_3_io_flow; // @[package.scala 93:22:@14752.4]
  wire  RetimeWrapper_3_io_in; // @[package.scala 93:22:@14752.4]
  wire  RetimeWrapper_3_io_out; // @[package.scala 93:22:@14752.4]
  wire  x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_clock; // @[sm_x120_outr_UnitPipe_BBOX.scala 86:24:@14779.4]
  wire  x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_reset; // @[sm_x120_outr_UnitPipe_BBOX.scala 86:24:@14779.4]
  wire [31:0] x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x78_index_0_wPort_0_data_0; // @[sm_x120_outr_UnitPipe_BBOX.scala 86:24:@14779.4]
  wire  x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x78_index_0_wPort_0_en_0; // @[sm_x120_outr_UnitPipe_BBOX.scala 86:24:@14779.4]
  wire  x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x78_index_0_full; // @[sm_x120_outr_UnitPipe_BBOX.scala 86:24:@14779.4]
  wire  x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x78_index_0_accessActivesOut_0; // @[sm_x120_outr_UnitPipe_BBOX.scala 86:24:@14779.4]
  wire  x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x78_index_0_accessActivesIn_0; // @[sm_x120_outr_UnitPipe_BBOX.scala 86:24:@14779.4]
  wire  x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x77_scalar_0_rPort_0_en_0; // @[sm_x120_outr_UnitPipe_BBOX.scala 86:24:@14779.4]
  wire [15:0] x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x77_scalar_0_rPort_0_output_0; // @[sm_x120_outr_UnitPipe_BBOX.scala 86:24:@14779.4]
  wire  x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x77_scalar_0_empty; // @[sm_x120_outr_UnitPipe_BBOX.scala 86:24:@14779.4]
  wire  x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x76_numel_0_rPort_0_en_0; // @[sm_x120_outr_UnitPipe_BBOX.scala 86:24:@14779.4]
  wire [31:0] x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x76_numel_0_rPort_0_output_0; // @[sm_x120_outr_UnitPipe_BBOX.scala 86:24:@14779.4]
  wire  x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x76_numel_0_empty; // @[sm_x120_outr_UnitPipe_BBOX.scala 86:24:@14779.4]
  wire [31:0] x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x80_numelOut_0_wPort_0_data_0; // @[sm_x120_outr_UnitPipe_BBOX.scala 86:24:@14779.4]
  wire  x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x80_numelOut_0_wPort_0_en_0; // @[sm_x120_outr_UnitPipe_BBOX.scala 86:24:@14779.4]
  wire  x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x80_numelOut_0_full; // @[sm_x120_outr_UnitPipe_BBOX.scala 86:24:@14779.4]
  wire  x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x80_numelOut_0_accessActivesOut_0; // @[sm_x120_outr_UnitPipe_BBOX.scala 86:24:@14779.4]
  wire  x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x80_numelOut_0_accessActivesIn_0; // @[sm_x120_outr_UnitPipe_BBOX.scala 86:24:@14779.4]
  wire [15:0] x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x79_payload_0_wPort_0_data_0; // @[sm_x120_outr_UnitPipe_BBOX.scala 86:24:@14779.4]
  wire  x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x79_payload_0_wPort_0_en_0; // @[sm_x120_outr_UnitPipe_BBOX.scala 86:24:@14779.4]
  wire  x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x79_payload_0_full; // @[sm_x120_outr_UnitPipe_BBOX.scala 86:24:@14779.4]
  wire  x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x79_payload_0_accessActivesOut_0; // @[sm_x120_outr_UnitPipe_BBOX.scala 86:24:@14779.4]
  wire  x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x79_payload_0_accessActivesIn_0; // @[sm_x120_outr_UnitPipe_BBOX.scala 86:24:@14779.4]
  wire  x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_sigsIn_smEnableOuts_0; // @[sm_x120_outr_UnitPipe_BBOX.scala 86:24:@14779.4]
  wire  x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_sigsIn_smChildAcks_0; // @[sm_x120_outr_UnitPipe_BBOX.scala 86:24:@14779.4]
  wire  x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_sigsOut_smDoneIn_0; // @[sm_x120_outr_UnitPipe_BBOX.scala 86:24:@14779.4]
  wire  x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_rr; // @[sm_x120_outr_UnitPipe_BBOX.scala 86:24:@14779.4]
  wire  x139_inr_UnitPipe_sm_clock; // @[sm_x139_inr_UnitPipe.scala 32:18:@15051.4]
  wire  x139_inr_UnitPipe_sm_reset; // @[sm_x139_inr_UnitPipe.scala 32:18:@15051.4]
  wire  x139_inr_UnitPipe_sm_io_enable; // @[sm_x139_inr_UnitPipe.scala 32:18:@15051.4]
  wire  x139_inr_UnitPipe_sm_io_done; // @[sm_x139_inr_UnitPipe.scala 32:18:@15051.4]
  wire  x139_inr_UnitPipe_sm_io_doneLatch; // @[sm_x139_inr_UnitPipe.scala 32:18:@15051.4]
  wire  x139_inr_UnitPipe_sm_io_ctrDone; // @[sm_x139_inr_UnitPipe.scala 32:18:@15051.4]
  wire  x139_inr_UnitPipe_sm_io_datapathEn; // @[sm_x139_inr_UnitPipe.scala 32:18:@15051.4]
  wire  x139_inr_UnitPipe_sm_io_ctrInc; // @[sm_x139_inr_UnitPipe.scala 32:18:@15051.4]
  wire  x139_inr_UnitPipe_sm_io_parentAck; // @[sm_x139_inr_UnitPipe.scala 32:18:@15051.4]
  wire  x139_inr_UnitPipe_sm_io_break; // @[sm_x139_inr_UnitPipe.scala 32:18:@15051.4]
  wire  RetimeWrapper_4_clock; // @[package.scala 93:22:@15119.4]
  wire  RetimeWrapper_4_reset; // @[package.scala 93:22:@15119.4]
  wire  RetimeWrapper_4_io_flow; // @[package.scala 93:22:@15119.4]
  wire  RetimeWrapper_4_io_in; // @[package.scala 93:22:@15119.4]
  wire  RetimeWrapper_4_io_out; // @[package.scala 93:22:@15119.4]
  wire  RetimeWrapper_5_clock; // @[package.scala 93:22:@15127.4]
  wire  RetimeWrapper_5_reset; // @[package.scala 93:22:@15127.4]
  wire  RetimeWrapper_5_io_flow; // @[package.scala 93:22:@15127.4]
  wire  RetimeWrapper_5_io_in; // @[package.scala 93:22:@15127.4]
  wire  RetimeWrapper_5_io_out; // @[package.scala 93:22:@15127.4]
  wire  x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1_clock; // @[sm_x139_inr_UnitPipe.scala 107:24:@15154.4]
  wire  x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1_reset; // @[sm_x139_inr_UnitPipe.scala 107:24:@15154.4]
  wire  x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1_io_in_x78_index_0_rPort_0_en_0; // @[sm_x139_inr_UnitPipe.scala 107:24:@15154.4]
  wire [31:0] x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1_io_in_x78_index_0_rPort_0_output_0; // @[sm_x139_inr_UnitPipe.scala 107:24:@15154.4]
  wire  x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1_io_in_x80_numelOut_0_rPort_0_en_0; // @[sm_x139_inr_UnitPipe.scala 107:24:@15154.4]
  wire [31:0] x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1_io_in_x80_numelOut_0_rPort_0_output_0; // @[sm_x139_inr_UnitPipe.scala 107:24:@15154.4]
  wire  x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1_io_in_x79_payload_0_rPort_0_en_0; // @[sm_x139_inr_UnitPipe.scala 107:24:@15154.4]
  wire [15:0] x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1_io_in_x79_payload_0_rPort_0_output_0; // @[sm_x139_inr_UnitPipe.scala 107:24:@15154.4]
  wire  x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1_io_sigsIn_datapathEn; // @[sm_x139_inr_UnitPipe.scala 107:24:@15154.4]
  wire  x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1_io_sigsIn_break; // @[sm_x139_inr_UnitPipe.scala 107:24:@15154.4]
  wire  x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1_io_rr; // @[sm_x139_inr_UnitPipe.scala 107:24:@15154.4]
  wire  _T_204; // @[package.scala 100:49:@14451.4]
  reg  _T_207; // @[package.scala 48:56:@14452.4]
  reg [31:0] _RAND_0;
  wire  _T_209; // @[sm_x140_outr_UnitPipe.scala 56:41:@14456.4]
  wire  _T_210; // @[sm_x140_outr_UnitPipe.scala 56:62:@14457.4]
  wire  _T_211; // @[sm_x140_outr_UnitPipe.scala 56:60:@14458.4]
  wire  _T_212; // @[sm_x140_outr_UnitPipe.scala 56:102:@14459.4]
  wire  _T_213; // @[sm_x140_outr_UnitPipe.scala 56:122:@14460.4]
  wire  _T_214; // @[sm_x140_outr_UnitPipe.scala 56:120:@14461.4]
  wire  _T_215; // @[sm_x140_outr_UnitPipe.scala 56:99:@14462.4]
  wire  _T_227; // @[package.scala 96:25:@14492.4 package.scala 96:25:@14493.4]
  wire  _T_233; // @[package.scala 96:25:@14500.4 package.scala 96:25:@14501.4]
  wire  _T_236; // @[SpatialBlocks.scala 110:93:@14503.4]
  wire  _T_302; // @[package.scala 100:49:@14715.4]
  reg  _T_305; // @[package.scala 48:56:@14716.4]
  reg [31:0] _RAND_1;
  wire  _T_319; // @[package.scala 96:25:@14749.4 package.scala 96:25:@14750.4]
  wire  _T_325; // @[package.scala 96:25:@14757.4 package.scala 96:25:@14758.4]
  wire  _T_328; // @[SpatialBlocks.scala 110:93:@14760.4]
  wire  _T_394; // @[package.scala 100:49:@15079.4]
  reg  _T_397; // @[package.scala 48:56:@15080.4]
  reg [31:0] _RAND_2;
  wire  _T_401; // @[sm_x140_outr_UnitPipe.scala 75:45:@15086.4]
  wire  _T_404; // @[sm_x140_outr_UnitPipe.scala 75:111:@15089.4]
  wire  _T_407; // @[sm_x140_outr_UnitPipe.scala 75:108:@15092.4]
  wire  _T_408; // @[sm_x140_outr_UnitPipe.scala 75:173:@15093.4]
  wire  _T_411; // @[sm_x140_outr_UnitPipe.scala 75:170:@15096.4]
  wire  x139_inr_UnitPipe_sigsIn_forwardpressure; // @[sm_x140_outr_UnitPipe.scala 75:234:@15097.4]
  wire  _T_421; // @[package.scala 96:25:@15124.4 package.scala 96:25:@15125.4]
  wire  _T_427; // @[package.scala 96:25:@15132.4 package.scala 96:25:@15133.4]
  wire  _T_430; // @[SpatialBlocks.scala 110:93:@15135.4]
  wire  x139_inr_UnitPipe_sigsIn_baseEn; // @[SpatialBlocks.scala 110:90:@15136.4]
  bbox_x76_numel_0 x76_numel_0 ( // @[m_x76_numel_0.scala 27:17:@14258.4]
    .clock(x76_numel_0_clock),
    .reset(x76_numel_0_reset),
    .io_rPort_0_en_0(x76_numel_0_io_rPort_0_en_0),
    .io_rPort_0_output_0(x76_numel_0_io_rPort_0_output_0),
    .io_wPort_0_data_0(x76_numel_0_io_wPort_0_data_0),
    .io_wPort_0_en_0(x76_numel_0_io_wPort_0_en_0),
    .io_full(x76_numel_0_io_full),
    .io_empty(x76_numel_0_io_empty),
    .io_accessActivesOut_0(x76_numel_0_io_accessActivesOut_0),
    .io_accessActivesIn_0(x76_numel_0_io_accessActivesIn_0)
  );
  bbox_x77_scalar_0 x77_scalar_0 ( // @[m_x77_scalar_0.scala 27:17:@14284.4]
    .clock(x77_scalar_0_clock),
    .reset(x77_scalar_0_reset),
    .io_rPort_0_en_0(x77_scalar_0_io_rPort_0_en_0),
    .io_rPort_0_output_0(x77_scalar_0_io_rPort_0_output_0),
    .io_wPort_0_data_0(x77_scalar_0_io_wPort_0_data_0),
    .io_wPort_0_en_0(x77_scalar_0_io_wPort_0_en_0),
    .io_full(x77_scalar_0_io_full),
    .io_empty(x77_scalar_0_io_empty),
    .io_accessActivesOut_0(x77_scalar_0_io_accessActivesOut_0),
    .io_accessActivesIn_0(x77_scalar_0_io_accessActivesIn_0)
  );
  bbox_x76_numel_0 x78_index_0 ( // @[m_x78_index_0.scala 27:17:@14310.4]
    .clock(x78_index_0_clock),
    .reset(x78_index_0_reset),
    .io_rPort_0_en_0(x78_index_0_io_rPort_0_en_0),
    .io_rPort_0_output_0(x78_index_0_io_rPort_0_output_0),
    .io_wPort_0_data_0(x78_index_0_io_wPort_0_data_0),
    .io_wPort_0_en_0(x78_index_0_io_wPort_0_en_0),
    .io_full(x78_index_0_io_full),
    .io_empty(x78_index_0_io_empty),
    .io_accessActivesOut_0(x78_index_0_io_accessActivesOut_0),
    .io_accessActivesIn_0(x78_index_0_io_accessActivesIn_0)
  );
  bbox_x77_scalar_0 x79_payload_0 ( // @[m_x79_payload_0.scala 27:17:@14336.4]
    .clock(x79_payload_0_clock),
    .reset(x79_payload_0_reset),
    .io_rPort_0_en_0(x79_payload_0_io_rPort_0_en_0),
    .io_rPort_0_output_0(x79_payload_0_io_rPort_0_output_0),
    .io_wPort_0_data_0(x79_payload_0_io_wPort_0_data_0),
    .io_wPort_0_en_0(x79_payload_0_io_wPort_0_en_0),
    .io_full(x79_payload_0_io_full),
    .io_empty(x79_payload_0_io_empty),
    .io_accessActivesOut_0(x79_payload_0_io_accessActivesOut_0),
    .io_accessActivesIn_0(x79_payload_0_io_accessActivesIn_0)
  );
  bbox_x76_numel_0 x80_numelOut_0 ( // @[m_x80_numelOut_0.scala 27:17:@14362.4]
    .clock(x80_numelOut_0_clock),
    .reset(x80_numelOut_0_reset),
    .io_rPort_0_en_0(x80_numelOut_0_io_rPort_0_en_0),
    .io_rPort_0_output_0(x80_numelOut_0_io_rPort_0_output_0),
    .io_wPort_0_data_0(x80_numelOut_0_io_wPort_0_data_0),
    .io_wPort_0_en_0(x80_numelOut_0_io_wPort_0_en_0),
    .io_full(x80_numelOut_0_io_full),
    .io_empty(x80_numelOut_0_io_empty),
    .io_accessActivesOut_0(x80_numelOut_0_io_accessActivesOut_0),
    .io_accessActivesIn_0(x80_numelOut_0_io_accessActivesIn_0)
  );
  bbox_x83_inr_UnitPipe_sm x83_inr_UnitPipe_sm ( // @[sm_x83_inr_UnitPipe.scala 32:18:@14423.4]
    .clock(x83_inr_UnitPipe_sm_clock),
    .reset(x83_inr_UnitPipe_sm_reset),
    .io_enable(x83_inr_UnitPipe_sm_io_enable),
    .io_done(x83_inr_UnitPipe_sm_io_done),
    .io_doneLatch(x83_inr_UnitPipe_sm_io_doneLatch),
    .io_ctrDone(x83_inr_UnitPipe_sm_io_ctrDone),
    .io_datapathEn(x83_inr_UnitPipe_sm_io_datapathEn),
    .io_ctrInc(x83_inr_UnitPipe_sm_io_ctrInc),
    .io_parentAck(x83_inr_UnitPipe_sm_io_parentAck),
    .io_backpressure(x83_inr_UnitPipe_sm_io_backpressure),
    .io_break(x83_inr_UnitPipe_sm_io_break)
  );
  bbox_RetimeWrapper RetimeWrapper ( // @[package.scala 93:22:@14487.4]
    .clock(RetimeWrapper_clock),
    .reset(RetimeWrapper_reset),
    .io_flow(RetimeWrapper_io_flow),
    .io_in(RetimeWrapper_io_in),
    .io_out(RetimeWrapper_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_1 ( // @[package.scala 93:22:@14495.4]
    .clock(RetimeWrapper_1_clock),
    .reset(RetimeWrapper_1_reset),
    .io_flow(RetimeWrapper_1_io_flow),
    .io_in(RetimeWrapper_1_io_in),
    .io_out(RetimeWrapper_1_io_out)
  );
  bbox_x83_inr_UnitPipe_kernelx83_inr_UnitPipe_concrete1 x83_inr_UnitPipe_kernelx83_inr_UnitPipe_concrete1 ( // @[sm_x83_inr_UnitPipe.scala 73:24:@14522.4]
    .io_in_x76_numel_0_wPort_0_en_0(x83_inr_UnitPipe_kernelx83_inr_UnitPipe_concrete1_io_in_x76_numel_0_wPort_0_en_0),
    .io_in_x77_scalar_0_wPort_0_en_0(x83_inr_UnitPipe_kernelx83_inr_UnitPipe_concrete1_io_in_x77_scalar_0_wPort_0_en_0),
    .io_sigsIn_backpressure(x83_inr_UnitPipe_kernelx83_inr_UnitPipe_concrete1_io_sigsIn_backpressure),
    .io_sigsIn_datapathEn(x83_inr_UnitPipe_kernelx83_inr_UnitPipe_concrete1_io_sigsIn_datapathEn),
    .io_sigsIn_break(x83_inr_UnitPipe_kernelx83_inr_UnitPipe_concrete1_io_sigsIn_break),
    .io_rr(x83_inr_UnitPipe_kernelx83_inr_UnitPipe_concrete1_io_rr)
  );
  bbox_RootController_sm x120_outr_UnitPipe_BBOX_sm ( // @[sm_x120_outr_UnitPipe_BBOX.scala 32:18:@14687.4]
    .clock(x120_outr_UnitPipe_BBOX_sm_clock),
    .reset(x120_outr_UnitPipe_BBOX_sm_reset),
    .io_enable(x120_outr_UnitPipe_BBOX_sm_io_enable),
    .io_done(x120_outr_UnitPipe_BBOX_sm_io_done),
    .io_rst(x120_outr_UnitPipe_BBOX_sm_io_rst),
    .io_ctrDone(x120_outr_UnitPipe_BBOX_sm_io_ctrDone),
    .io_ctrInc(x120_outr_UnitPipe_BBOX_sm_io_ctrInc),
    .io_parentAck(x120_outr_UnitPipe_BBOX_sm_io_parentAck),
    .io_doneIn_0(x120_outr_UnitPipe_BBOX_sm_io_doneIn_0),
    .io_enableOut_0(x120_outr_UnitPipe_BBOX_sm_io_enableOut_0),
    .io_childAck_0(x120_outr_UnitPipe_BBOX_sm_io_childAck_0)
  );
  bbox_RetimeWrapper RetimeWrapper_2 ( // @[package.scala 93:22:@14744.4]
    .clock(RetimeWrapper_2_clock),
    .reset(RetimeWrapper_2_reset),
    .io_flow(RetimeWrapper_2_io_flow),
    .io_in(RetimeWrapper_2_io_in),
    .io_out(RetimeWrapper_2_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_3 ( // @[package.scala 93:22:@14752.4]
    .clock(RetimeWrapper_3_clock),
    .reset(RetimeWrapper_3_reset),
    .io_flow(RetimeWrapper_3_io_flow),
    .io_in(RetimeWrapper_3_io_in),
    .io_out(RetimeWrapper_3_io_out)
  );
  bbox_x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1 x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1 ( // @[sm_x120_outr_UnitPipe_BBOX.scala 86:24:@14779.4]
    .clock(x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_clock),
    .reset(x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_reset),
    .io_in_x78_index_0_wPort_0_data_0(x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x78_index_0_wPort_0_data_0),
    .io_in_x78_index_0_wPort_0_en_0(x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x78_index_0_wPort_0_en_0),
    .io_in_x78_index_0_full(x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x78_index_0_full),
    .io_in_x78_index_0_accessActivesOut_0(x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x78_index_0_accessActivesOut_0),
    .io_in_x78_index_0_accessActivesIn_0(x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x78_index_0_accessActivesIn_0),
    .io_in_x77_scalar_0_rPort_0_en_0(x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x77_scalar_0_rPort_0_en_0),
    .io_in_x77_scalar_0_rPort_0_output_0(x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x77_scalar_0_rPort_0_output_0),
    .io_in_x77_scalar_0_empty(x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x77_scalar_0_empty),
    .io_in_x76_numel_0_rPort_0_en_0(x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x76_numel_0_rPort_0_en_0),
    .io_in_x76_numel_0_rPort_0_output_0(x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x76_numel_0_rPort_0_output_0),
    .io_in_x76_numel_0_empty(x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x76_numel_0_empty),
    .io_in_x80_numelOut_0_wPort_0_data_0(x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x80_numelOut_0_wPort_0_data_0),
    .io_in_x80_numelOut_0_wPort_0_en_0(x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x80_numelOut_0_wPort_0_en_0),
    .io_in_x80_numelOut_0_full(x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x80_numelOut_0_full),
    .io_in_x80_numelOut_0_accessActivesOut_0(x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x80_numelOut_0_accessActivesOut_0),
    .io_in_x80_numelOut_0_accessActivesIn_0(x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x80_numelOut_0_accessActivesIn_0),
    .io_in_x79_payload_0_wPort_0_data_0(x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x79_payload_0_wPort_0_data_0),
    .io_in_x79_payload_0_wPort_0_en_0(x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x79_payload_0_wPort_0_en_0),
    .io_in_x79_payload_0_full(x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x79_payload_0_full),
    .io_in_x79_payload_0_accessActivesOut_0(x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x79_payload_0_accessActivesOut_0),
    .io_in_x79_payload_0_accessActivesIn_0(x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x79_payload_0_accessActivesIn_0),
    .io_sigsIn_smEnableOuts_0(x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_sigsIn_smEnableOuts_0),
    .io_sigsIn_smChildAcks_0(x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_sigsIn_smChildAcks_0),
    .io_sigsOut_smDoneIn_0(x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_sigsOut_smDoneIn_0),
    .io_rr(x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_rr)
  );
  bbox_x139_inr_UnitPipe_sm x139_inr_UnitPipe_sm ( // @[sm_x139_inr_UnitPipe.scala 32:18:@15051.4]
    .clock(x139_inr_UnitPipe_sm_clock),
    .reset(x139_inr_UnitPipe_sm_reset),
    .io_enable(x139_inr_UnitPipe_sm_io_enable),
    .io_done(x139_inr_UnitPipe_sm_io_done),
    .io_doneLatch(x139_inr_UnitPipe_sm_io_doneLatch),
    .io_ctrDone(x139_inr_UnitPipe_sm_io_ctrDone),
    .io_datapathEn(x139_inr_UnitPipe_sm_io_datapathEn),
    .io_ctrInc(x139_inr_UnitPipe_sm_io_ctrInc),
    .io_parentAck(x139_inr_UnitPipe_sm_io_parentAck),
    .io_break(x139_inr_UnitPipe_sm_io_break)
  );
  bbox_RetimeWrapper RetimeWrapper_4 ( // @[package.scala 93:22:@15119.4]
    .clock(RetimeWrapper_4_clock),
    .reset(RetimeWrapper_4_reset),
    .io_flow(RetimeWrapper_4_io_flow),
    .io_in(RetimeWrapper_4_io_in),
    .io_out(RetimeWrapper_4_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_5 ( // @[package.scala 93:22:@15127.4]
    .clock(RetimeWrapper_5_clock),
    .reset(RetimeWrapper_5_reset),
    .io_flow(RetimeWrapper_5_io_flow),
    .io_in(RetimeWrapper_5_io_in),
    .io_out(RetimeWrapper_5_io_out)
  );
  bbox_x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1 x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1 ( // @[sm_x139_inr_UnitPipe.scala 107:24:@15154.4]
    .clock(x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1_clock),
    .reset(x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1_reset),
    .io_in_x78_index_0_rPort_0_en_0(x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1_io_in_x78_index_0_rPort_0_en_0),
    .io_in_x78_index_0_rPort_0_output_0(x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1_io_in_x78_index_0_rPort_0_output_0),
    .io_in_x80_numelOut_0_rPort_0_en_0(x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1_io_in_x80_numelOut_0_rPort_0_en_0),
    .io_in_x80_numelOut_0_rPort_0_output_0(x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1_io_in_x80_numelOut_0_rPort_0_output_0),
    .io_in_x79_payload_0_rPort_0_en_0(x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1_io_in_x79_payload_0_rPort_0_en_0),
    .io_in_x79_payload_0_rPort_0_output_0(x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1_io_in_x79_payload_0_rPort_0_output_0),
    .io_sigsIn_datapathEn(x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1_io_sigsIn_datapathEn),
    .io_sigsIn_break(x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1_io_sigsIn_break),
    .io_rr(x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1_io_rr)
  );
  assign _T_204 = x83_inr_UnitPipe_sm_io_ctrInc == 1'h0; // @[package.scala 100:49:@14451.4]
  assign _T_209 = ~ x77_scalar_0_io_full; // @[sm_x140_outr_UnitPipe.scala 56:41:@14456.4]
  assign _T_210 = ~ x77_scalar_0_io_accessActivesOut_0; // @[sm_x140_outr_UnitPipe.scala 56:62:@14457.4]
  assign _T_211 = _T_209 | _T_210; // @[sm_x140_outr_UnitPipe.scala 56:60:@14458.4]
  assign _T_212 = ~ x76_numel_0_io_full; // @[sm_x140_outr_UnitPipe.scala 56:102:@14459.4]
  assign _T_213 = ~ x76_numel_0_io_accessActivesOut_0; // @[sm_x140_outr_UnitPipe.scala 56:122:@14460.4]
  assign _T_214 = _T_212 | _T_213; // @[sm_x140_outr_UnitPipe.scala 56:120:@14461.4]
  assign _T_215 = _T_211 & _T_214; // @[sm_x140_outr_UnitPipe.scala 56:99:@14462.4]
  assign _T_227 = RetimeWrapper_io_out; // @[package.scala 96:25:@14492.4 package.scala 96:25:@14493.4]
  assign _T_233 = RetimeWrapper_1_io_out; // @[package.scala 96:25:@14500.4 package.scala 96:25:@14501.4]
  assign _T_236 = ~ _T_233; // @[SpatialBlocks.scala 110:93:@14503.4]
  assign _T_302 = x120_outr_UnitPipe_BBOX_sm_io_ctrInc == 1'h0; // @[package.scala 100:49:@14715.4]
  assign _T_319 = RetimeWrapper_2_io_out; // @[package.scala 96:25:@14749.4 package.scala 96:25:@14750.4]
  assign _T_325 = RetimeWrapper_3_io_out; // @[package.scala 96:25:@14757.4 package.scala 96:25:@14758.4]
  assign _T_328 = ~ _T_325; // @[SpatialBlocks.scala 110:93:@14760.4]
  assign _T_394 = x139_inr_UnitPipe_sm_io_ctrInc == 1'h0; // @[package.scala 100:49:@15079.4]
  assign _T_401 = ~ x80_numelOut_0_io_empty; // @[sm_x140_outr_UnitPipe.scala 75:45:@15086.4]
  assign _T_404 = ~ x79_payload_0_io_empty; // @[sm_x140_outr_UnitPipe.scala 75:111:@15089.4]
  assign _T_407 = _T_401 & _T_404; // @[sm_x140_outr_UnitPipe.scala 75:108:@15092.4]
  assign _T_408 = ~ x78_index_0_io_empty; // @[sm_x140_outr_UnitPipe.scala 75:173:@15093.4]
  assign _T_411 = _T_407 & _T_408; // @[sm_x140_outr_UnitPipe.scala 75:170:@15096.4]
  assign x139_inr_UnitPipe_sigsIn_forwardpressure = _T_411 | x139_inr_UnitPipe_sm_io_doneLatch; // @[sm_x140_outr_UnitPipe.scala 75:234:@15097.4]
  assign _T_421 = RetimeWrapper_4_io_out; // @[package.scala 96:25:@15124.4 package.scala 96:25:@15125.4]
  assign _T_427 = RetimeWrapper_5_io_out; // @[package.scala 96:25:@15132.4 package.scala 96:25:@15133.4]
  assign _T_430 = ~ _T_427; // @[SpatialBlocks.scala 110:93:@15135.4]
  assign x139_inr_UnitPipe_sigsIn_baseEn = _T_421 & _T_430; // @[SpatialBlocks.scala 110:90:@15136.4]
  assign io_sigsOut_smDoneIn_0 = x83_inr_UnitPipe_sm_io_done; // @[SpatialBlocks.scala 127:53:@14510.4]
  assign io_sigsOut_smDoneIn_1 = x120_outr_UnitPipe_BBOX_sm_io_done; // @[SpatialBlocks.scala 127:53:@14767.4]
  assign io_sigsOut_smDoneIn_2 = x139_inr_UnitPipe_sm_io_done; // @[SpatialBlocks.scala 127:53:@15142.4]
  assign io_sigsOut_smCtrCopyDone_0 = x83_inr_UnitPipe_sm_io_done; // @[SpatialBlocks.scala 139:125:@14521.4]
  assign io_sigsOut_smCtrCopyDone_1 = x120_outr_UnitPipe_BBOX_sm_io_done; // @[SpatialBlocks.scala 139:125:@14778.4]
  assign io_sigsOut_smCtrCopyDone_2 = x139_inr_UnitPipe_sm_io_done; // @[SpatialBlocks.scala 139:125:@15153.4]
  assign x76_numel_0_clock = clock; // @[:@14259.4]
  assign x76_numel_0_reset = reset; // @[:@14260.4]
  assign x76_numel_0_io_rPort_0_en_0 = x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x76_numel_0_rPort_0_en_0; // @[MemInterfaceType.scala 66:44:@14956.4]
  assign x76_numel_0_io_wPort_0_data_0 = 32'h1; // @[MemInterfaceType.scala 67:44:@14607.4]
  assign x76_numel_0_io_wPort_0_en_0 = x83_inr_UnitPipe_kernelx83_inr_UnitPipe_concrete1_io_in_x76_numel_0_wPort_0_en_0; // @[MemInterfaceType.scala 67:44:@14603.4]
  assign x76_numel_0_io_accessActivesIn_0 = 1'h1; // @[MemInterfaceType.scala 69:92:@14610.4]
  assign x77_scalar_0_clock = clock; // @[:@14285.4]
  assign x77_scalar_0_reset = reset; // @[:@14286.4]
  assign x77_scalar_0_io_rPort_0_en_0 = x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x77_scalar_0_rPort_0_en_0; // @[MemInterfaceType.scala 66:44:@14943.4]
  assign x77_scalar_0_io_wPort_0_data_0 = 16'h1; // @[MemInterfaceType.scala 67:44:@14622.4]
  assign x77_scalar_0_io_wPort_0_en_0 = x83_inr_UnitPipe_kernelx83_inr_UnitPipe_concrete1_io_in_x77_scalar_0_wPort_0_en_0; // @[MemInterfaceType.scala 67:44:@14618.4]
  assign x77_scalar_0_io_accessActivesIn_0 = 1'h1; // @[MemInterfaceType.scala 69:92:@14625.4]
  assign x78_index_0_clock = clock; // @[:@14311.4]
  assign x78_index_0_reset = reset; // @[:@14312.4]
  assign x78_index_0_io_rPort_0_en_0 = x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1_io_in_x78_index_0_rPort_0_en_0; // @[MemInterfaceType.scala 66:44:@15259.4]
  assign x78_index_0_io_wPort_0_data_0 = x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x78_index_0_wPort_0_data_0; // @[MemInterfaceType.scala 67:44:@14930.4]
  assign x78_index_0_io_wPort_0_en_0 = x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x78_index_0_wPort_0_en_0; // @[MemInterfaceType.scala 67:44:@14926.4]
  assign x78_index_0_io_accessActivesIn_0 = x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x78_index_0_accessActivesIn_0; // @[MemInterfaceType.scala 69:92:@14933.4]
  assign x79_payload_0_clock = clock; // @[:@14337.4]
  assign x79_payload_0_reset = reset; // @[:@14338.4]
  assign x79_payload_0_io_rPort_0_en_0 = x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1_io_in_x79_payload_0_rPort_0_en_0; // @[MemInterfaceType.scala 66:44:@15285.4]
  assign x79_payload_0_io_wPort_0_data_0 = x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x79_payload_0_wPort_0_data_0; // @[MemInterfaceType.scala 67:44:@14986.4]
  assign x79_payload_0_io_wPort_0_en_0 = x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x79_payload_0_wPort_0_en_0; // @[MemInterfaceType.scala 67:44:@14982.4]
  assign x79_payload_0_io_accessActivesIn_0 = x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x79_payload_0_accessActivesIn_0; // @[MemInterfaceType.scala 69:92:@14989.4]
  assign x80_numelOut_0_clock = clock; // @[:@14363.4]
  assign x80_numelOut_0_reset = reset; // @[:@14364.4]
  assign x80_numelOut_0_io_rPort_0_en_0 = x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1_io_in_x80_numelOut_0_rPort_0_en_0; // @[MemInterfaceType.scala 66:44:@15272.4]
  assign x80_numelOut_0_io_wPort_0_data_0 = x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x80_numelOut_0_wPort_0_data_0; // @[MemInterfaceType.scala 67:44:@14971.4]
  assign x80_numelOut_0_io_wPort_0_en_0 = x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x80_numelOut_0_wPort_0_en_0; // @[MemInterfaceType.scala 67:44:@14967.4]
  assign x80_numelOut_0_io_accessActivesIn_0 = x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x80_numelOut_0_accessActivesIn_0; // @[MemInterfaceType.scala 69:92:@14974.4]
  assign x83_inr_UnitPipe_sm_clock = clock; // @[:@14424.4]
  assign x83_inr_UnitPipe_sm_reset = reset; // @[:@14425.4]
  assign x83_inr_UnitPipe_sm_io_enable = _T_227 & _T_236; // @[SpatialBlocks.scala 112:18:@14507.4]
  assign x83_inr_UnitPipe_sm_io_ctrDone = x83_inr_UnitPipe_sm_io_ctrInc & _T_207; // @[sm_x140_outr_UnitPipe.scala 55:38:@14455.4]
  assign x83_inr_UnitPipe_sm_io_parentAck = io_sigsIn_smChildAcks_0; // @[SpatialBlocks.scala 114:21:@14509.4]
  assign x83_inr_UnitPipe_sm_io_backpressure = _T_215 | x83_inr_UnitPipe_sm_io_doneLatch; // @[SpatialBlocks.scala 105:24:@14481.4]
  assign x83_inr_UnitPipe_sm_io_break = 1'h0; // @[sm_x140_outr_UnitPipe.scala 59:36:@14468.4]
  assign RetimeWrapper_clock = clock; // @[:@14488.4]
  assign RetimeWrapper_reset = reset; // @[:@14489.4]
  assign RetimeWrapper_io_flow = 1'h1; // @[package.scala 95:18:@14491.4]
  assign RetimeWrapper_io_in = io_sigsIn_smEnableOuts_0; // @[package.scala 94:16:@14490.4]
  assign RetimeWrapper_1_clock = clock; // @[:@14496.4]
  assign RetimeWrapper_1_reset = reset; // @[:@14497.4]
  assign RetimeWrapper_1_io_flow = 1'h1; // @[package.scala 95:18:@14499.4]
  assign RetimeWrapper_1_io_in = x83_inr_UnitPipe_sm_io_done; // @[package.scala 94:16:@14498.4]
  assign x83_inr_UnitPipe_kernelx83_inr_UnitPipe_concrete1_io_sigsIn_backpressure = _T_215 | x83_inr_UnitPipe_sm_io_doneLatch; // @[sm_x83_inr_UnitPipe.scala 78:22:@14640.4]
  assign x83_inr_UnitPipe_kernelx83_inr_UnitPipe_concrete1_io_sigsIn_datapathEn = x83_inr_UnitPipe_sm_io_datapathEn; // @[sm_x83_inr_UnitPipe.scala 78:22:@14638.4]
  assign x83_inr_UnitPipe_kernelx83_inr_UnitPipe_concrete1_io_sigsIn_break = x83_inr_UnitPipe_sm_io_break; // @[sm_x83_inr_UnitPipe.scala 78:22:@14636.4]
  assign x83_inr_UnitPipe_kernelx83_inr_UnitPipe_concrete1_io_rr = io_rr; // @[sm_x83_inr_UnitPipe.scala 77:18:@14626.4]
  assign x120_outr_UnitPipe_BBOX_sm_clock = clock; // @[:@14688.4]
  assign x120_outr_UnitPipe_BBOX_sm_reset = reset; // @[:@14689.4]
  assign x120_outr_UnitPipe_BBOX_sm_io_enable = _T_319 & _T_328; // @[SpatialBlocks.scala 112:18:@14764.4]
  assign x120_outr_UnitPipe_BBOX_sm_io_rst = 1'h0; // @[SpatialBlocks.scala 106:15:@14739.4]
  assign x120_outr_UnitPipe_BBOX_sm_io_ctrDone = x120_outr_UnitPipe_BBOX_sm_io_ctrInc & _T_305; // @[sm_x140_outr_UnitPipe.scala 64:45:@14719.4]
  assign x120_outr_UnitPipe_BBOX_sm_io_parentAck = io_sigsIn_smChildAcks_1; // @[SpatialBlocks.scala 114:21:@14766.4]
  assign x120_outr_UnitPipe_BBOX_sm_io_doneIn_0 = x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_sigsOut_smDoneIn_0; // @[SpatialBlocks.scala 102:67:@14736.4]
  assign RetimeWrapper_2_clock = clock; // @[:@14745.4]
  assign RetimeWrapper_2_reset = reset; // @[:@14746.4]
  assign RetimeWrapper_2_io_flow = 1'h1; // @[package.scala 95:18:@14748.4]
  assign RetimeWrapper_2_io_in = io_sigsIn_smEnableOuts_1; // @[package.scala 94:16:@14747.4]
  assign RetimeWrapper_3_clock = clock; // @[:@14753.4]
  assign RetimeWrapper_3_reset = reset; // @[:@14754.4]
  assign RetimeWrapper_3_io_flow = 1'h1; // @[package.scala 95:18:@14756.4]
  assign RetimeWrapper_3_io_in = x120_outr_UnitPipe_BBOX_sm_io_done; // @[package.scala 94:16:@14755.4]
  assign x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_clock = clock; // @[:@14780.4]
  assign x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_reset = reset; // @[:@14781.4]
  assign x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x78_index_0_full = x78_index_0_io_full; // @[MemInterfaceType.scala 151:13:@14919.4]
  assign x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x78_index_0_accessActivesOut_0 = x78_index_0_io_accessActivesOut_0; // @[MemInterfaceType.scala 156:25:@14924.4]
  assign x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x77_scalar_0_rPort_0_output_0 = x77_scalar_0_io_rPort_0_output_0; // @[MemInterfaceType.scala 66:44:@14941.4]
  assign x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x77_scalar_0_empty = x77_scalar_0_io_empty; // @[MemInterfaceType.scala 153:14:@14936.4]
  assign x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x76_numel_0_rPort_0_output_0 = x76_numel_0_io_rPort_0_output_0; // @[MemInterfaceType.scala 66:44:@14954.4]
  assign x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x76_numel_0_empty = x76_numel_0_io_empty; // @[MemInterfaceType.scala 153:14:@14949.4]
  assign x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x80_numelOut_0_full = x80_numelOut_0_io_full; // @[MemInterfaceType.scala 151:13:@14960.4]
  assign x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x80_numelOut_0_accessActivesOut_0 = x80_numelOut_0_io_accessActivesOut_0; // @[MemInterfaceType.scala 156:25:@14965.4]
  assign x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x79_payload_0_full = x79_payload_0_io_full; // @[MemInterfaceType.scala 151:13:@14975.4]
  assign x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_in_x79_payload_0_accessActivesOut_0 = x79_payload_0_io_accessActivesOut_0; // @[MemInterfaceType.scala 156:25:@14980.4]
  assign x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_sigsIn_smEnableOuts_0 = x120_outr_UnitPipe_BBOX_sm_io_enableOut_0; // @[sm_x120_outr_UnitPipe_BBOX.scala 91:22:@14998.4]
  assign x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_sigsIn_smChildAcks_0 = x120_outr_UnitPipe_BBOX_sm_io_childAck_0; // @[sm_x120_outr_UnitPipe_BBOX.scala 91:22:@14996.4]
  assign x120_outr_UnitPipe_BBOX_kernelx120_outr_UnitPipe_BBOX_concrete1_io_rr = io_rr; // @[sm_x120_outr_UnitPipe_BBOX.scala 90:18:@14990.4]
  assign x139_inr_UnitPipe_sm_clock = clock; // @[:@15052.4]
  assign x139_inr_UnitPipe_sm_reset = reset; // @[:@15053.4]
  assign x139_inr_UnitPipe_sm_io_enable = x139_inr_UnitPipe_sigsIn_baseEn & x139_inr_UnitPipe_sigsIn_forwardpressure; // @[SpatialBlocks.scala 112:18:@15139.4]
  assign x139_inr_UnitPipe_sm_io_ctrDone = x139_inr_UnitPipe_sm_io_ctrInc & _T_397; // @[sm_x140_outr_UnitPipe.scala 73:39:@15083.4]
  assign x139_inr_UnitPipe_sm_io_parentAck = io_sigsIn_smChildAcks_2; // @[SpatialBlocks.scala 114:21:@15141.4]
  assign x139_inr_UnitPipe_sm_io_break = 1'h0; // @[sm_x140_outr_UnitPipe.scala 77:37:@15100.4]
  assign RetimeWrapper_4_clock = clock; // @[:@15120.4]
  assign RetimeWrapper_4_reset = reset; // @[:@15121.4]
  assign RetimeWrapper_4_io_flow = 1'h1; // @[package.scala 95:18:@15123.4]
  assign RetimeWrapper_4_io_in = io_sigsIn_smEnableOuts_2; // @[package.scala 94:16:@15122.4]
  assign RetimeWrapper_5_clock = clock; // @[:@15128.4]
  assign RetimeWrapper_5_reset = reset; // @[:@15129.4]
  assign RetimeWrapper_5_io_flow = 1'h1; // @[package.scala 95:18:@15131.4]
  assign RetimeWrapper_5_io_in = x139_inr_UnitPipe_sm_io_done; // @[package.scala 94:16:@15130.4]
  assign x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1_clock = clock; // @[:@15155.4]
  assign x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1_reset = reset; // @[:@15156.4]
  assign x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1_io_in_x78_index_0_rPort_0_output_0 = x78_index_0_io_rPort_0_output_0; // @[MemInterfaceType.scala 66:44:@15257.4]
  assign x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1_io_in_x80_numelOut_0_rPort_0_output_0 = x80_numelOut_0_io_rPort_0_output_0; // @[MemInterfaceType.scala 66:44:@15270.4]
  assign x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1_io_in_x79_payload_0_rPort_0_output_0 = x79_payload_0_io_rPort_0_output_0; // @[MemInterfaceType.scala 66:44:@15283.4]
  assign x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1_io_sigsIn_datapathEn = x139_inr_UnitPipe_sm_io_datapathEn; // @[sm_x139_inr_UnitPipe.scala 112:22:@15301.4]
  assign x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1_io_sigsIn_break = x139_inr_UnitPipe_sm_io_break; // @[sm_x139_inr_UnitPipe.scala 112:22:@15299.4]
  assign x139_inr_UnitPipe_kernelx139_inr_UnitPipe_concrete1_io_rr = io_rr; // @[sm_x139_inr_UnitPipe.scala 111:18:@15289.4]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  _T_207 = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  _T_305 = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  _T_397 = _RAND_2[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      _T_207 <= 1'h0;
    end else begin
      _T_207 <= _T_204;
    end
    if (reset) begin
      _T_305 <= 1'h0;
    end else begin
      _T_305 <= _T_302;
    end
    if (reset) begin
      _T_397 <= 1'h0;
    end else begin
      _T_397 <= _T_394;
    end
  end
endmodule
module bbox_RootController_kernelRootController_concrete1( // @[:@15316.2]
  input   clock, // @[:@15317.4]
  input   reset, // @[:@15318.4]
  input   io_sigsIn_smEnableOuts_0, // @[:@15319.4]
  input   io_sigsIn_smChildAcks_0, // @[:@15319.4]
  output  io_sigsOut_smDoneIn_0, // @[:@15319.4]
  input   io_rr // @[:@15319.4]
);
  wire  x140_outr_UnitPipe_sm_clock; // @[sm_x140_outr_UnitPipe.scala 31:18:@15388.4]
  wire  x140_outr_UnitPipe_sm_reset; // @[sm_x140_outr_UnitPipe.scala 31:18:@15388.4]
  wire  x140_outr_UnitPipe_sm_io_enable; // @[sm_x140_outr_UnitPipe.scala 31:18:@15388.4]
  wire  x140_outr_UnitPipe_sm_io_done; // @[sm_x140_outr_UnitPipe.scala 31:18:@15388.4]
  wire  x140_outr_UnitPipe_sm_io_parentAck; // @[sm_x140_outr_UnitPipe.scala 31:18:@15388.4]
  wire  x140_outr_UnitPipe_sm_io_doneIn_0; // @[sm_x140_outr_UnitPipe.scala 31:18:@15388.4]
  wire  x140_outr_UnitPipe_sm_io_doneIn_1; // @[sm_x140_outr_UnitPipe.scala 31:18:@15388.4]
  wire  x140_outr_UnitPipe_sm_io_doneIn_2; // @[sm_x140_outr_UnitPipe.scala 31:18:@15388.4]
  wire  x140_outr_UnitPipe_sm_io_enableOut_0; // @[sm_x140_outr_UnitPipe.scala 31:18:@15388.4]
  wire  x140_outr_UnitPipe_sm_io_enableOut_1; // @[sm_x140_outr_UnitPipe.scala 31:18:@15388.4]
  wire  x140_outr_UnitPipe_sm_io_enableOut_2; // @[sm_x140_outr_UnitPipe.scala 31:18:@15388.4]
  wire  x140_outr_UnitPipe_sm_io_childAck_0; // @[sm_x140_outr_UnitPipe.scala 31:18:@15388.4]
  wire  x140_outr_UnitPipe_sm_io_childAck_1; // @[sm_x140_outr_UnitPipe.scala 31:18:@15388.4]
  wire  x140_outr_UnitPipe_sm_io_childAck_2; // @[sm_x140_outr_UnitPipe.scala 31:18:@15388.4]
  wire  x140_outr_UnitPipe_sm_io_ctrCopyDone_0; // @[sm_x140_outr_UnitPipe.scala 31:18:@15388.4]
  wire  x140_outr_UnitPipe_sm_io_ctrCopyDone_1; // @[sm_x140_outr_UnitPipe.scala 31:18:@15388.4]
  wire  x140_outr_UnitPipe_sm_io_ctrCopyDone_2; // @[sm_x140_outr_UnitPipe.scala 31:18:@15388.4]
  wire  RetimeWrapper_clock; // @[package.scala 93:22:@15460.4]
  wire  RetimeWrapper_reset; // @[package.scala 93:22:@15460.4]
  wire  RetimeWrapper_io_flow; // @[package.scala 93:22:@15460.4]
  wire  RetimeWrapper_io_in; // @[package.scala 93:22:@15460.4]
  wire  RetimeWrapper_io_out; // @[package.scala 93:22:@15460.4]
  wire  RetimeWrapper_1_clock; // @[package.scala 93:22:@15468.4]
  wire  RetimeWrapper_1_reset; // @[package.scala 93:22:@15468.4]
  wire  RetimeWrapper_1_io_flow; // @[package.scala 93:22:@15468.4]
  wire  RetimeWrapper_1_io_in; // @[package.scala 93:22:@15468.4]
  wire  RetimeWrapper_1_io_out; // @[package.scala 93:22:@15468.4]
  wire  x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_clock; // @[sm_x140_outr_UnitPipe.scala 82:24:@15497.4]
  wire  x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_reset; // @[sm_x140_outr_UnitPipe.scala 82:24:@15497.4]
  wire  x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsIn_smEnableOuts_0; // @[sm_x140_outr_UnitPipe.scala 82:24:@15497.4]
  wire  x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsIn_smEnableOuts_1; // @[sm_x140_outr_UnitPipe.scala 82:24:@15497.4]
  wire  x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsIn_smEnableOuts_2; // @[sm_x140_outr_UnitPipe.scala 82:24:@15497.4]
  wire  x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsIn_smChildAcks_0; // @[sm_x140_outr_UnitPipe.scala 82:24:@15497.4]
  wire  x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsIn_smChildAcks_1; // @[sm_x140_outr_UnitPipe.scala 82:24:@15497.4]
  wire  x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsIn_smChildAcks_2; // @[sm_x140_outr_UnitPipe.scala 82:24:@15497.4]
  wire  x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsOut_smDoneIn_0; // @[sm_x140_outr_UnitPipe.scala 82:24:@15497.4]
  wire  x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsOut_smDoneIn_1; // @[sm_x140_outr_UnitPipe.scala 82:24:@15497.4]
  wire  x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsOut_smDoneIn_2; // @[sm_x140_outr_UnitPipe.scala 82:24:@15497.4]
  wire  x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsOut_smCtrCopyDone_0; // @[sm_x140_outr_UnitPipe.scala 82:24:@15497.4]
  wire  x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsOut_smCtrCopyDone_1; // @[sm_x140_outr_UnitPipe.scala 82:24:@15497.4]
  wire  x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsOut_smCtrCopyDone_2; // @[sm_x140_outr_UnitPipe.scala 82:24:@15497.4]
  wire  x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_rr; // @[sm_x140_outr_UnitPipe.scala 82:24:@15497.4]
  wire  _T_198; // @[package.scala 96:25:@15465.4 package.scala 96:25:@15466.4]
  wire  _T_204; // @[package.scala 96:25:@15473.4 package.scala 96:25:@15474.4]
  wire  _T_207; // @[SpatialBlocks.scala 110:93:@15476.4]
  bbox_x140_outr_UnitPipe_sm x140_outr_UnitPipe_sm ( // @[sm_x140_outr_UnitPipe.scala 31:18:@15388.4]
    .clock(x140_outr_UnitPipe_sm_clock),
    .reset(x140_outr_UnitPipe_sm_reset),
    .io_enable(x140_outr_UnitPipe_sm_io_enable),
    .io_done(x140_outr_UnitPipe_sm_io_done),
    .io_parentAck(x140_outr_UnitPipe_sm_io_parentAck),
    .io_doneIn_0(x140_outr_UnitPipe_sm_io_doneIn_0),
    .io_doneIn_1(x140_outr_UnitPipe_sm_io_doneIn_1),
    .io_doneIn_2(x140_outr_UnitPipe_sm_io_doneIn_2),
    .io_enableOut_0(x140_outr_UnitPipe_sm_io_enableOut_0),
    .io_enableOut_1(x140_outr_UnitPipe_sm_io_enableOut_1),
    .io_enableOut_2(x140_outr_UnitPipe_sm_io_enableOut_2),
    .io_childAck_0(x140_outr_UnitPipe_sm_io_childAck_0),
    .io_childAck_1(x140_outr_UnitPipe_sm_io_childAck_1),
    .io_childAck_2(x140_outr_UnitPipe_sm_io_childAck_2),
    .io_ctrCopyDone_0(x140_outr_UnitPipe_sm_io_ctrCopyDone_0),
    .io_ctrCopyDone_1(x140_outr_UnitPipe_sm_io_ctrCopyDone_1),
    .io_ctrCopyDone_2(x140_outr_UnitPipe_sm_io_ctrCopyDone_2)
  );
  bbox_RetimeWrapper RetimeWrapper ( // @[package.scala 93:22:@15460.4]
    .clock(RetimeWrapper_clock),
    .reset(RetimeWrapper_reset),
    .io_flow(RetimeWrapper_io_flow),
    .io_in(RetimeWrapper_io_in),
    .io_out(RetimeWrapper_io_out)
  );
  bbox_RetimeWrapper RetimeWrapper_1 ( // @[package.scala 93:22:@15468.4]
    .clock(RetimeWrapper_1_clock),
    .reset(RetimeWrapper_1_reset),
    .io_flow(RetimeWrapper_1_io_flow),
    .io_in(RetimeWrapper_1_io_in),
    .io_out(RetimeWrapper_1_io_out)
  );
  bbox_x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1 x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1 ( // @[sm_x140_outr_UnitPipe.scala 82:24:@15497.4]
    .clock(x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_clock),
    .reset(x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_reset),
    .io_sigsIn_smEnableOuts_0(x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsIn_smEnableOuts_0),
    .io_sigsIn_smEnableOuts_1(x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsIn_smEnableOuts_1),
    .io_sigsIn_smEnableOuts_2(x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsIn_smEnableOuts_2),
    .io_sigsIn_smChildAcks_0(x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsIn_smChildAcks_0),
    .io_sigsIn_smChildAcks_1(x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsIn_smChildAcks_1),
    .io_sigsIn_smChildAcks_2(x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsIn_smChildAcks_2),
    .io_sigsOut_smDoneIn_0(x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsOut_smDoneIn_0),
    .io_sigsOut_smDoneIn_1(x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsOut_smDoneIn_1),
    .io_sigsOut_smDoneIn_2(x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsOut_smDoneIn_2),
    .io_sigsOut_smCtrCopyDone_0(x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsOut_smCtrCopyDone_0),
    .io_sigsOut_smCtrCopyDone_1(x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsOut_smCtrCopyDone_1),
    .io_sigsOut_smCtrCopyDone_2(x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsOut_smCtrCopyDone_2),
    .io_rr(x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_rr)
  );
  assign _T_198 = RetimeWrapper_io_out; // @[package.scala 96:25:@15465.4 package.scala 96:25:@15466.4]
  assign _T_204 = RetimeWrapper_1_io_out; // @[package.scala 96:25:@15473.4 package.scala 96:25:@15474.4]
  assign _T_207 = ~ _T_204; // @[SpatialBlocks.scala 110:93:@15476.4]
  assign io_sigsOut_smDoneIn_0 = x140_outr_UnitPipe_sm_io_done; // @[SpatialBlocks.scala 127:53:@15483.4]
  assign x140_outr_UnitPipe_sm_clock = clock; // @[:@15389.4]
  assign x140_outr_UnitPipe_sm_reset = reset; // @[:@15390.4]
  assign x140_outr_UnitPipe_sm_io_enable = _T_198 & _T_207; // @[SpatialBlocks.scala 112:18:@15480.4]
  assign x140_outr_UnitPipe_sm_io_parentAck = io_sigsIn_smChildAcks_0; // @[SpatialBlocks.scala 114:21:@15482.4]
  assign x140_outr_UnitPipe_sm_io_doneIn_0 = x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsOut_smDoneIn_0; // @[SpatialBlocks.scala 102:67:@15448.4]
  assign x140_outr_UnitPipe_sm_io_doneIn_1 = x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsOut_smDoneIn_1; // @[SpatialBlocks.scala 102:67:@15449.4]
  assign x140_outr_UnitPipe_sm_io_doneIn_2 = x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsOut_smDoneIn_2; // @[SpatialBlocks.scala 102:67:@15450.4]
  assign x140_outr_UnitPipe_sm_io_ctrCopyDone_0 = x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsOut_smCtrCopyDone_0; // @[SpatialBlocks.scala 132:80:@15494.4]
  assign x140_outr_UnitPipe_sm_io_ctrCopyDone_1 = x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsOut_smCtrCopyDone_1; // @[SpatialBlocks.scala 132:80:@15495.4]
  assign x140_outr_UnitPipe_sm_io_ctrCopyDone_2 = x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsOut_smCtrCopyDone_2; // @[SpatialBlocks.scala 132:80:@15496.4]
  assign RetimeWrapper_clock = clock; // @[:@15461.4]
  assign RetimeWrapper_reset = reset; // @[:@15462.4]
  assign RetimeWrapper_io_flow = 1'h1; // @[package.scala 95:18:@15464.4]
  assign RetimeWrapper_io_in = io_sigsIn_smEnableOuts_0; // @[package.scala 94:16:@15463.4]
  assign RetimeWrapper_1_clock = clock; // @[:@15469.4]
  assign RetimeWrapper_1_reset = reset; // @[:@15470.4]
  assign RetimeWrapper_1_io_flow = 1'h1; // @[package.scala 95:18:@15472.4]
  assign RetimeWrapper_1_io_in = x140_outr_UnitPipe_sm_io_done; // @[package.scala 94:16:@15471.4]
  assign x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_clock = clock; // @[:@15498.4]
  assign x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_reset = reset; // @[:@15499.4]
  assign x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsIn_smEnableOuts_0 = x140_outr_UnitPipe_sm_io_enableOut_0; // @[sm_x140_outr_UnitPipe.scala 86:22:@15573.4]
  assign x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsIn_smEnableOuts_1 = x140_outr_UnitPipe_sm_io_enableOut_1; // @[sm_x140_outr_UnitPipe.scala 86:22:@15574.4]
  assign x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsIn_smEnableOuts_2 = x140_outr_UnitPipe_sm_io_enableOut_2; // @[sm_x140_outr_UnitPipe.scala 86:22:@15575.4]
  assign x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsIn_smChildAcks_0 = x140_outr_UnitPipe_sm_io_childAck_0; // @[sm_x140_outr_UnitPipe.scala 86:22:@15567.4]
  assign x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsIn_smChildAcks_1 = x140_outr_UnitPipe_sm_io_childAck_1; // @[sm_x140_outr_UnitPipe.scala 86:22:@15568.4]
  assign x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_sigsIn_smChildAcks_2 = x140_outr_UnitPipe_sm_io_childAck_2; // @[sm_x140_outr_UnitPipe.scala 86:22:@15569.4]
  assign x140_outr_UnitPipe_kernelx140_outr_UnitPipe_concrete1_io_rr = io_rr; // @[sm_x140_outr_UnitPipe.scala 85:18:@15551.4]
endmodule
module bbox_AccelUnit( // @[:@15602.2]
  input          clock, // @[:@15603.4]
  input          reset, // @[:@15604.4]
  input          io_enable, // @[:@15605.4]
  output         io_done, // @[:@15605.4]
  input          io_reset, // @[:@15605.4]
  input          io_memStreams_loads_0_cmd_ready, // @[:@15605.4]
  output         io_memStreams_loads_0_cmd_valid, // @[:@15605.4]
  output [63:0]  io_memStreams_loads_0_cmd_bits_addr, // @[:@15605.4]
  output [31:0]  io_memStreams_loads_0_cmd_bits_size, // @[:@15605.4]
  output         io_memStreams_loads_0_data_ready, // @[:@15605.4]
  input          io_memStreams_loads_0_data_valid, // @[:@15605.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_0, // @[:@15605.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_1, // @[:@15605.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_2, // @[:@15605.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_3, // @[:@15605.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_4, // @[:@15605.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_5, // @[:@15605.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_6, // @[:@15605.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_7, // @[:@15605.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_8, // @[:@15605.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_9, // @[:@15605.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_10, // @[:@15605.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_11, // @[:@15605.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_12, // @[:@15605.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_13, // @[:@15605.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_14, // @[:@15605.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_15, // @[:@15605.4]
  input          io_memStreams_stores_0_cmd_ready, // @[:@15605.4]
  output         io_memStreams_stores_0_cmd_valid, // @[:@15605.4]
  output [63:0]  io_memStreams_stores_0_cmd_bits_addr, // @[:@15605.4]
  output [31:0]  io_memStreams_stores_0_cmd_bits_size, // @[:@15605.4]
  input          io_memStreams_stores_0_data_ready, // @[:@15605.4]
  output         io_memStreams_stores_0_data_valid, // @[:@15605.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_0, // @[:@15605.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_1, // @[:@15605.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_2, // @[:@15605.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_3, // @[:@15605.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_4, // @[:@15605.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_5, // @[:@15605.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_6, // @[:@15605.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_7, // @[:@15605.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_8, // @[:@15605.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_9, // @[:@15605.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_10, // @[:@15605.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_11, // @[:@15605.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_12, // @[:@15605.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_13, // @[:@15605.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_14, // @[:@15605.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_15, // @[:@15605.4]
  output [15:0]  io_memStreams_stores_0_data_bits_wstrb, // @[:@15605.4]
  output         io_memStreams_stores_0_wresp_ready, // @[:@15605.4]
  input          io_memStreams_stores_0_wresp_valid, // @[:@15605.4]
  input          io_memStreams_stores_0_wresp_bits, // @[:@15605.4]
  input          io_memStreams_gathers_0_cmd_ready, // @[:@15605.4]
  output         io_memStreams_gathers_0_cmd_valid, // @[:@15605.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_0, // @[:@15605.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_1, // @[:@15605.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_2, // @[:@15605.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_3, // @[:@15605.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_4, // @[:@15605.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_5, // @[:@15605.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_6, // @[:@15605.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_7, // @[:@15605.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_8, // @[:@15605.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_9, // @[:@15605.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_10, // @[:@15605.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_11, // @[:@15605.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_12, // @[:@15605.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_13, // @[:@15605.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_14, // @[:@15605.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_15, // @[:@15605.4]
  output         io_memStreams_gathers_0_data_ready, // @[:@15605.4]
  input          io_memStreams_gathers_0_data_valid, // @[:@15605.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_0, // @[:@15605.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_1, // @[:@15605.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_2, // @[:@15605.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_3, // @[:@15605.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_4, // @[:@15605.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_5, // @[:@15605.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_6, // @[:@15605.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_7, // @[:@15605.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_8, // @[:@15605.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_9, // @[:@15605.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_10, // @[:@15605.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_11, // @[:@15605.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_12, // @[:@15605.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_13, // @[:@15605.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_14, // @[:@15605.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_15, // @[:@15605.4]
  input          io_memStreams_scatters_0_cmd_ready, // @[:@15605.4]
  output         io_memStreams_scatters_0_cmd_valid, // @[:@15605.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_0, // @[:@15605.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_1, // @[:@15605.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_2, // @[:@15605.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_3, // @[:@15605.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_4, // @[:@15605.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_5, // @[:@15605.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_6, // @[:@15605.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_7, // @[:@15605.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_8, // @[:@15605.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_9, // @[:@15605.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_10, // @[:@15605.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_11, // @[:@15605.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_12, // @[:@15605.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_13, // @[:@15605.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_14, // @[:@15605.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_15, // @[:@15605.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_0, // @[:@15605.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_1, // @[:@15605.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_2, // @[:@15605.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_3, // @[:@15605.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_4, // @[:@15605.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_5, // @[:@15605.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_6, // @[:@15605.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_7, // @[:@15605.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_8, // @[:@15605.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_9, // @[:@15605.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_10, // @[:@15605.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_11, // @[:@15605.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_12, // @[:@15605.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_13, // @[:@15605.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_14, // @[:@15605.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_15, // @[:@15605.4]
  output         io_memStreams_scatters_0_wresp_ready, // @[:@15605.4]
  input          io_memStreams_scatters_0_wresp_valid, // @[:@15605.4]
  input          io_memStreams_scatters_0_wresp_bits, // @[:@15605.4]
  input          io_axiStreamsIn_0_TVALID, // @[:@15605.4]
  output         io_axiStreamsIn_0_TREADY, // @[:@15605.4]
  input  [255:0] io_axiStreamsIn_0_TDATA, // @[:@15605.4]
  input  [31:0]  io_axiStreamsIn_0_TSTRB, // @[:@15605.4]
  input  [31:0]  io_axiStreamsIn_0_TKEEP, // @[:@15605.4]
  input          io_axiStreamsIn_0_TLAST, // @[:@15605.4]
  input  [7:0]   io_axiStreamsIn_0_TID, // @[:@15605.4]
  input  [7:0]   io_axiStreamsIn_0_TDEST, // @[:@15605.4]
  input  [31:0]  io_axiStreamsIn_0_TUSER, // @[:@15605.4]
  output         io_axiStreamsOut_0_TVALID, // @[:@15605.4]
  input          io_axiStreamsOut_0_TREADY, // @[:@15605.4]
  output [255:0] io_axiStreamsOut_0_TDATA, // @[:@15605.4]
  output [31:0]  io_axiStreamsOut_0_TSTRB, // @[:@15605.4]
  output [31:0]  io_axiStreamsOut_0_TKEEP, // @[:@15605.4]
  output         io_axiStreamsOut_0_TLAST, // @[:@15605.4]
  output [7:0]   io_axiStreamsOut_0_TID, // @[:@15605.4]
  output [7:0]   io_axiStreamsOut_0_TDEST, // @[:@15605.4]
  output [31:0]  io_axiStreamsOut_0_TUSER, // @[:@15605.4]
  output         io_heap_0_req_valid, // @[:@15605.4]
  output         io_heap_0_req_bits_allocDealloc, // @[:@15605.4]
  output [63:0]  io_heap_0_req_bits_sizeAddr, // @[:@15605.4]
  input          io_heap_0_resp_valid, // @[:@15605.4]
  input          io_heap_0_resp_bits_allocDealloc, // @[:@15605.4]
  input  [63:0]  io_heap_0_resp_bits_sizeAddr, // @[:@15605.4]
  input  [63:0]  io_argIns_0, // @[:@15605.4]
  input          io_argOuts_0_port_ready, // @[:@15605.4]
  output         io_argOuts_0_port_valid, // @[:@15605.4]
  output [63:0]  io_argOuts_0_port_bits, // @[:@15605.4]
  input  [63:0]  io_argOuts_0_echo // @[:@15605.4]
);
  wire  SingleCounter_clock; // @[Main.scala 27:32:@15763.4]
  wire  SingleCounter_reset; // @[Main.scala 27:32:@15763.4]
  wire  SingleCounter_io_input_reset; // @[Main.scala 27:32:@15763.4]
  wire  SingleCounter_io_output_done; // @[Main.scala 27:32:@15763.4]
  wire  RetimeWrapper_clock; // @[package.scala 93:22:@15781.4]
  wire  RetimeWrapper_reset; // @[package.scala 93:22:@15781.4]
  wire  RetimeWrapper_io_flow; // @[package.scala 93:22:@15781.4]
  wire  RetimeWrapper_io_in; // @[package.scala 93:22:@15781.4]
  wire  RetimeWrapper_io_out; // @[package.scala 93:22:@15781.4]
  wire  SRFF_clock; // @[Main.scala 31:28:@15790.4]
  wire  SRFF_reset; // @[Main.scala 31:28:@15790.4]
  wire  SRFF_io_input_set; // @[Main.scala 31:28:@15790.4]
  wire  SRFF_io_input_reset; // @[Main.scala 31:28:@15790.4]
  wire  SRFF_io_input_asyn_reset; // @[Main.scala 31:28:@15790.4]
  wire  SRFF_io_output; // @[Main.scala 31:28:@15790.4]
  wire  RootController_sm_clock; // @[sm_RootController.scala 31:18:@15828.4]
  wire  RootController_sm_reset; // @[sm_RootController.scala 31:18:@15828.4]
  wire  RootController_sm_io_enable; // @[sm_RootController.scala 31:18:@15828.4]
  wire  RootController_sm_io_done; // @[sm_RootController.scala 31:18:@15828.4]
  wire  RootController_sm_io_rst; // @[sm_RootController.scala 31:18:@15828.4]
  wire  RootController_sm_io_ctrDone; // @[sm_RootController.scala 31:18:@15828.4]
  wire  RootController_sm_io_ctrInc; // @[sm_RootController.scala 31:18:@15828.4]
  wire  RootController_sm_io_parentAck; // @[sm_RootController.scala 31:18:@15828.4]
  wire  RootController_sm_io_doneIn_0; // @[sm_RootController.scala 31:18:@15828.4]
  wire  RootController_sm_io_enableOut_0; // @[sm_RootController.scala 31:18:@15828.4]
  wire  RootController_sm_io_childAck_0; // @[sm_RootController.scala 31:18:@15828.4]
  wire  RetimeWrapper_1_clock; // @[package.scala 93:22:@15860.4]
  wire  RetimeWrapper_1_reset; // @[package.scala 93:22:@15860.4]
  wire  RetimeWrapper_1_io_flow; // @[package.scala 93:22:@15860.4]
  wire  RetimeWrapper_1_io_in; // @[package.scala 93:22:@15860.4]
  wire  RetimeWrapper_1_io_out; // @[package.scala 93:22:@15860.4]
  wire  RootController_kernelRootController_concrete1_clock; // @[sm_RootController.scala 58:24:@15919.4]
  wire  RootController_kernelRootController_concrete1_reset; // @[sm_RootController.scala 58:24:@15919.4]
  wire  RootController_kernelRootController_concrete1_io_sigsIn_smEnableOuts_0; // @[sm_RootController.scala 58:24:@15919.4]
  wire  RootController_kernelRootController_concrete1_io_sigsIn_smChildAcks_0; // @[sm_RootController.scala 58:24:@15919.4]
  wire  RootController_kernelRootController_concrete1_io_sigsOut_smDoneIn_0; // @[sm_RootController.scala 58:24:@15919.4]
  wire  RootController_kernelRootController_concrete1_io_rr; // @[sm_RootController.scala 58:24:@15919.4]
  wire  _T_607; // @[package.scala 96:25:@15786.4 package.scala 96:25:@15787.4]
  wire  _T_672; // @[Main.scala 33:50:@15856.4]
  wire  _T_673; // @[Main.scala 33:59:@15857.4]
  wire  _T_685; // @[package.scala 100:49:@15877.4]
  reg  _T_688; // @[package.scala 48:56:@15878.4]
  reg [31:0] _RAND_0;
  bbox_SingleCounter SingleCounter ( // @[Main.scala 27:32:@15763.4]
    .clock(SingleCounter_clock),
    .reset(SingleCounter_reset),
    .io_input_reset(SingleCounter_io_input_reset),
    .io_output_done(SingleCounter_io_output_done)
  );
  bbox_RetimeWrapper RetimeWrapper ( // @[package.scala 93:22:@15781.4]
    .clock(RetimeWrapper_clock),
    .reset(RetimeWrapper_reset),
    .io_flow(RetimeWrapper_io_flow),
    .io_in(RetimeWrapper_io_in),
    .io_out(RetimeWrapper_io_out)
  );
  bbox_SRFF SRFF ( // @[Main.scala 31:28:@15790.4]
    .clock(SRFF_clock),
    .reset(SRFF_reset),
    .io_input_set(SRFF_io_input_set),
    .io_input_reset(SRFF_io_input_reset),
    .io_input_asyn_reset(SRFF_io_input_asyn_reset),
    .io_output(SRFF_io_output)
  );
  bbox_RootController_sm RootController_sm ( // @[sm_RootController.scala 31:18:@15828.4]
    .clock(RootController_sm_clock),
    .reset(RootController_sm_reset),
    .io_enable(RootController_sm_io_enable),
    .io_done(RootController_sm_io_done),
    .io_rst(RootController_sm_io_rst),
    .io_ctrDone(RootController_sm_io_ctrDone),
    .io_ctrInc(RootController_sm_io_ctrInc),
    .io_parentAck(RootController_sm_io_parentAck),
    .io_doneIn_0(RootController_sm_io_doneIn_0),
    .io_enableOut_0(RootController_sm_io_enableOut_0),
    .io_childAck_0(RootController_sm_io_childAck_0)
  );
  bbox_RetimeWrapper RetimeWrapper_1 ( // @[package.scala 93:22:@15860.4]
    .clock(RetimeWrapper_1_clock),
    .reset(RetimeWrapper_1_reset),
    .io_flow(RetimeWrapper_1_io_flow),
    .io_in(RetimeWrapper_1_io_in),
    .io_out(RetimeWrapper_1_io_out)
  );
  bbox_RootController_kernelRootController_concrete1 RootController_kernelRootController_concrete1 ( // @[sm_RootController.scala 58:24:@15919.4]
    .clock(RootController_kernelRootController_concrete1_clock),
    .reset(RootController_kernelRootController_concrete1_reset),
    .io_sigsIn_smEnableOuts_0(RootController_kernelRootController_concrete1_io_sigsIn_smEnableOuts_0),
    .io_sigsIn_smChildAcks_0(RootController_kernelRootController_concrete1_io_sigsIn_smChildAcks_0),
    .io_sigsOut_smDoneIn_0(RootController_kernelRootController_concrete1_io_sigsOut_smDoneIn_0),
    .io_rr(RootController_kernelRootController_concrete1_io_rr)
  );
  assign _T_607 = RetimeWrapper_io_out; // @[package.scala 96:25:@15786.4 package.scala 96:25:@15787.4]
  assign _T_672 = io_enable & _T_607; // @[Main.scala 33:50:@15856.4]
  assign _T_673 = ~ SRFF_io_output; // @[Main.scala 33:59:@15857.4]
  assign _T_685 = RootController_sm_io_ctrInc == 1'h0; // @[package.scala 100:49:@15877.4]
  assign io_done = SRFF_io_output; // @[Main.scala 40:23:@15876.4]
  assign io_memStreams_loads_0_cmd_valid = 1'h0;
  assign io_memStreams_loads_0_cmd_bits_addr = 64'h0;
  assign io_memStreams_loads_0_cmd_bits_size = 32'h0;
  assign io_memStreams_loads_0_data_ready = 1'h0;
  assign io_memStreams_stores_0_cmd_valid = 1'h0;
  assign io_memStreams_stores_0_cmd_bits_addr = 64'h0;
  assign io_memStreams_stores_0_cmd_bits_size = 32'h0;
  assign io_memStreams_stores_0_data_valid = 1'h0;
  assign io_memStreams_stores_0_data_bits_wdata_0 = 32'h0;
  assign io_memStreams_stores_0_data_bits_wdata_1 = 32'h0;
  assign io_memStreams_stores_0_data_bits_wdata_2 = 32'h0;
  assign io_memStreams_stores_0_data_bits_wdata_3 = 32'h0;
  assign io_memStreams_stores_0_data_bits_wdata_4 = 32'h0;
  assign io_memStreams_stores_0_data_bits_wdata_5 = 32'h0;
  assign io_memStreams_stores_0_data_bits_wdata_6 = 32'h0;
  assign io_memStreams_stores_0_data_bits_wdata_7 = 32'h0;
  assign io_memStreams_stores_0_data_bits_wdata_8 = 32'h0;
  assign io_memStreams_stores_0_data_bits_wdata_9 = 32'h0;
  assign io_memStreams_stores_0_data_bits_wdata_10 = 32'h0;
  assign io_memStreams_stores_0_data_bits_wdata_11 = 32'h0;
  assign io_memStreams_stores_0_data_bits_wdata_12 = 32'h0;
  assign io_memStreams_stores_0_data_bits_wdata_13 = 32'h0;
  assign io_memStreams_stores_0_data_bits_wdata_14 = 32'h0;
  assign io_memStreams_stores_0_data_bits_wdata_15 = 32'h0;
  assign io_memStreams_stores_0_data_bits_wstrb = 16'h0;
  assign io_memStreams_stores_0_wresp_ready = 1'h0;
  assign io_memStreams_gathers_0_cmd_valid = 1'h0;
  assign io_memStreams_gathers_0_cmd_bits_addr_0 = 64'h0;
  assign io_memStreams_gathers_0_cmd_bits_addr_1 = 64'h0;
  assign io_memStreams_gathers_0_cmd_bits_addr_2 = 64'h0;
  assign io_memStreams_gathers_0_cmd_bits_addr_3 = 64'h0;
  assign io_memStreams_gathers_0_cmd_bits_addr_4 = 64'h0;
  assign io_memStreams_gathers_0_cmd_bits_addr_5 = 64'h0;
  assign io_memStreams_gathers_0_cmd_bits_addr_6 = 64'h0;
  assign io_memStreams_gathers_0_cmd_bits_addr_7 = 64'h0;
  assign io_memStreams_gathers_0_cmd_bits_addr_8 = 64'h0;
  assign io_memStreams_gathers_0_cmd_bits_addr_9 = 64'h0;
  assign io_memStreams_gathers_0_cmd_bits_addr_10 = 64'h0;
  assign io_memStreams_gathers_0_cmd_bits_addr_11 = 64'h0;
  assign io_memStreams_gathers_0_cmd_bits_addr_12 = 64'h0;
  assign io_memStreams_gathers_0_cmd_bits_addr_13 = 64'h0;
  assign io_memStreams_gathers_0_cmd_bits_addr_14 = 64'h0;
  assign io_memStreams_gathers_0_cmd_bits_addr_15 = 64'h0;
  assign io_memStreams_gathers_0_data_ready = 1'h0;
  assign io_memStreams_scatters_0_cmd_valid = 1'h0;
  assign io_memStreams_scatters_0_cmd_bits_addr_addr_0 = 64'h0;
  assign io_memStreams_scatters_0_cmd_bits_addr_addr_1 = 64'h0;
  assign io_memStreams_scatters_0_cmd_bits_addr_addr_2 = 64'h0;
  assign io_memStreams_scatters_0_cmd_bits_addr_addr_3 = 64'h0;
  assign io_memStreams_scatters_0_cmd_bits_addr_addr_4 = 64'h0;
  assign io_memStreams_scatters_0_cmd_bits_addr_addr_5 = 64'h0;
  assign io_memStreams_scatters_0_cmd_bits_addr_addr_6 = 64'h0;
  assign io_memStreams_scatters_0_cmd_bits_addr_addr_7 = 64'h0;
  assign io_memStreams_scatters_0_cmd_bits_addr_addr_8 = 64'h0;
  assign io_memStreams_scatters_0_cmd_bits_addr_addr_9 = 64'h0;
  assign io_memStreams_scatters_0_cmd_bits_addr_addr_10 = 64'h0;
  assign io_memStreams_scatters_0_cmd_bits_addr_addr_11 = 64'h0;
  assign io_memStreams_scatters_0_cmd_bits_addr_addr_12 = 64'h0;
  assign io_memStreams_scatters_0_cmd_bits_addr_addr_13 = 64'h0;
  assign io_memStreams_scatters_0_cmd_bits_addr_addr_14 = 64'h0;
  assign io_memStreams_scatters_0_cmd_bits_addr_addr_15 = 64'h0;
  assign io_memStreams_scatters_0_cmd_bits_wdata_0 = 32'h0;
  assign io_memStreams_scatters_0_cmd_bits_wdata_1 = 32'h0;
  assign io_memStreams_scatters_0_cmd_bits_wdata_2 = 32'h0;
  assign io_memStreams_scatters_0_cmd_bits_wdata_3 = 32'h0;
  assign io_memStreams_scatters_0_cmd_bits_wdata_4 = 32'h0;
  assign io_memStreams_scatters_0_cmd_bits_wdata_5 = 32'h0;
  assign io_memStreams_scatters_0_cmd_bits_wdata_6 = 32'h0;
  assign io_memStreams_scatters_0_cmd_bits_wdata_7 = 32'h0;
  assign io_memStreams_scatters_0_cmd_bits_wdata_8 = 32'h0;
  assign io_memStreams_scatters_0_cmd_bits_wdata_9 = 32'h0;
  assign io_memStreams_scatters_0_cmd_bits_wdata_10 = 32'h0;
  assign io_memStreams_scatters_0_cmd_bits_wdata_11 = 32'h0;
  assign io_memStreams_scatters_0_cmd_bits_wdata_12 = 32'h0;
  assign io_memStreams_scatters_0_cmd_bits_wdata_13 = 32'h0;
  assign io_memStreams_scatters_0_cmd_bits_wdata_14 = 32'h0;
  assign io_memStreams_scatters_0_cmd_bits_wdata_15 = 32'h0;
  assign io_memStreams_scatters_0_wresp_ready = 1'h0;
  assign io_axiStreamsIn_0_TREADY = 1'h0;
  assign io_axiStreamsOut_0_TVALID = 1'h0;
  assign io_axiStreamsOut_0_TDATA = 256'h0;
  assign io_axiStreamsOut_0_TSTRB = 32'h0;
  assign io_axiStreamsOut_0_TKEEP = 32'h0;
  assign io_axiStreamsOut_0_TLAST = 1'h0;
  assign io_axiStreamsOut_0_TID = 8'h0;
  assign io_axiStreamsOut_0_TDEST = 8'h0;
  assign io_axiStreamsOut_0_TUSER = 32'h0;
  assign io_heap_0_req_valid = 1'h0;
  assign io_heap_0_req_bits_allocDealloc = 1'h0;
  assign io_heap_0_req_bits_sizeAddr = 64'h0;
  assign io_argOuts_0_port_valid = 1'h0;
  assign io_argOuts_0_port_bits = 64'h0;
  assign SingleCounter_clock = clock; // @[:@15764.4]
  assign SingleCounter_reset = reset; // @[:@15765.4]
  assign SingleCounter_io_input_reset = reset; // @[Main.scala 28:79:@15779.4]
  assign RetimeWrapper_clock = clock; // @[:@15782.4]
  assign RetimeWrapper_reset = reset; // @[:@15783.4]
  assign RetimeWrapper_io_flow = 1'h1; // @[package.scala 95:18:@15785.4]
  assign RetimeWrapper_io_in = SingleCounter_io_output_done; // @[package.scala 94:16:@15784.4]
  assign SRFF_clock = clock; // @[:@15791.4]
  assign SRFF_reset = reset; // @[:@15792.4]
  assign SRFF_io_input_set = RootController_sm_io_done; // @[Main.scala 49:29:@15975.4]
  assign SRFF_io_input_reset = RetimeWrapper_1_io_out; // @[Main.scala 38:31:@15874.4]
  assign SRFF_io_input_asyn_reset = RetimeWrapper_1_io_out; // @[Main.scala 39:36:@15875.4]
  assign RootController_sm_clock = clock; // @[:@15829.4]
  assign RootController_sm_reset = reset; // @[:@15830.4]
  assign RootController_sm_io_enable = _T_672 & _T_673; // @[Main.scala 37:33:@15873.4 SpatialBlocks.scala 112:18:@15907.4]
  assign RootController_sm_io_rst = RetimeWrapper_1_io_out; // @[SpatialBlocks.scala 106:15:@15901.4]
  assign RootController_sm_io_ctrDone = RootController_sm_io_ctrInc & _T_688; // @[Main.scala 41:34:@15881.4]
  assign RootController_sm_io_parentAck = 1'h0; // @[Main.scala 36:36:@15869.4 SpatialBlocks.scala 114:21:@15909.4]
  assign RootController_sm_io_doneIn_0 = RootController_kernelRootController_concrete1_io_sigsOut_smDoneIn_0; // @[SpatialBlocks.scala 102:67:@15898.4]
  assign RetimeWrapper_1_clock = clock; // @[:@15861.4]
  assign RetimeWrapper_1_reset = reset; // @[:@15862.4]
  assign RetimeWrapper_1_io_flow = 1'h1; // @[package.scala 95:18:@15864.4]
  assign RetimeWrapper_1_io_in = reset | io_reset; // @[package.scala 94:16:@15863.4]
  assign RootController_kernelRootController_concrete1_clock = clock; // @[:@15920.4]
  assign RootController_kernelRootController_concrete1_reset = reset; // @[:@15921.4]
  assign RootController_kernelRootController_concrete1_io_sigsIn_smEnableOuts_0 = RootController_sm_io_enableOut_0; // @[sm_RootController.scala 62:22:@15957.4]
  assign RootController_kernelRootController_concrete1_io_sigsIn_smChildAcks_0 = RootController_sm_io_childAck_0; // @[sm_RootController.scala 62:22:@15955.4]
  assign RootController_kernelRootController_concrete1_io_rr = RetimeWrapper_io_out; // @[sm_RootController.scala 61:18:@15949.4]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  _T_688 = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      _T_688 <= 1'h0;
    end else begin
      _T_688 <= _T_685;
    end
  end
endmodule
module bbox_SpatialIP( // @[:@15977.2]
  input         clock, // @[:@15978.4]
  input         reset, // @[:@15979.4]
  input  [31:0] io_raddr, // @[:@15980.4]
  input         io_wen, // @[:@15980.4]
  input  [31:0] io_waddr, // @[:@15980.4]
  input  [63:0] io_wdata, // @[:@15980.4]
  output [63:0] io_rdata // @[:@15980.4]
);
  wire  accel_clock; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_reset; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_io_enable; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_io_done; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_io_reset; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_io_memStreams_loads_0_cmd_ready; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_io_memStreams_loads_0_cmd_valid; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_memStreams_loads_0_cmd_bits_addr; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_loads_0_cmd_bits_size; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_io_memStreams_loads_0_data_ready; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_io_memStreams_loads_0_data_valid; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_0; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_1; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_2; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_3; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_4; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_5; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_6; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_7; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_8; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_9; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_10; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_11; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_12; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_13; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_14; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_15; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_io_memStreams_stores_0_cmd_ready; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_io_memStreams_stores_0_cmd_valid; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_memStreams_stores_0_cmd_bits_addr; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_stores_0_cmd_bits_size; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_io_memStreams_stores_0_data_ready; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_io_memStreams_stores_0_data_valid; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_0; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_1; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_2; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_3; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_4; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_5; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_6; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_7; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_8; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_9; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_10; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_11; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_12; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_13; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_14; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_15; // @[Instantiator.scala 53:44:@15982.4]
  wire [15:0] accel_io_memStreams_stores_0_data_bits_wstrb; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_io_memStreams_stores_0_wresp_ready; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_io_memStreams_stores_0_wresp_valid; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_io_memStreams_stores_0_wresp_bits; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_io_memStreams_gathers_0_cmd_ready; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_io_memStreams_gathers_0_cmd_valid; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_0; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_1; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_2; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_3; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_4; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_5; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_6; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_7; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_8; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_9; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_10; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_11; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_12; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_13; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_14; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_15; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_io_memStreams_gathers_0_data_ready; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_io_memStreams_gathers_0_data_valid; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_0; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_1; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_2; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_3; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_4; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_5; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_6; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_7; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_8; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_9; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_10; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_11; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_12; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_13; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_14; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_15; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_io_memStreams_scatters_0_cmd_ready; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_io_memStreams_scatters_0_cmd_valid; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_0; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_1; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_2; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_3; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_4; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_5; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_6; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_7; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_8; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_9; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_10; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_11; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_12; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_13; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_14; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_15; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_0; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_1; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_2; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_3; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_4; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_5; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_6; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_7; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_8; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_9; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_10; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_11; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_12; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_13; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_14; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_15; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_io_memStreams_scatters_0_wresp_ready; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_io_memStreams_scatters_0_wresp_valid; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_io_memStreams_scatters_0_wresp_bits; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_io_axiStreamsIn_0_TVALID; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_io_axiStreamsIn_0_TREADY; // @[Instantiator.scala 53:44:@15982.4]
  wire [255:0] accel_io_axiStreamsIn_0_TDATA; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_axiStreamsIn_0_TSTRB; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_axiStreamsIn_0_TKEEP; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_io_axiStreamsIn_0_TLAST; // @[Instantiator.scala 53:44:@15982.4]
  wire [7:0] accel_io_axiStreamsIn_0_TID; // @[Instantiator.scala 53:44:@15982.4]
  wire [7:0] accel_io_axiStreamsIn_0_TDEST; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_axiStreamsIn_0_TUSER; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_io_axiStreamsOut_0_TVALID; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_io_axiStreamsOut_0_TREADY; // @[Instantiator.scala 53:44:@15982.4]
  wire [255:0] accel_io_axiStreamsOut_0_TDATA; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_axiStreamsOut_0_TSTRB; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_axiStreamsOut_0_TKEEP; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_io_axiStreamsOut_0_TLAST; // @[Instantiator.scala 53:44:@15982.4]
  wire [7:0] accel_io_axiStreamsOut_0_TID; // @[Instantiator.scala 53:44:@15982.4]
  wire [7:0] accel_io_axiStreamsOut_0_TDEST; // @[Instantiator.scala 53:44:@15982.4]
  wire [31:0] accel_io_axiStreamsOut_0_TUSER; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_io_heap_0_req_valid; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_io_heap_0_req_bits_allocDealloc; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_heap_0_req_bits_sizeAddr; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_io_heap_0_resp_valid; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_io_heap_0_resp_bits_allocDealloc; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_heap_0_resp_bits_sizeAddr; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_argIns_0; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_io_argOuts_0_port_ready; // @[Instantiator.scala 53:44:@15982.4]
  wire  accel_io_argOuts_0_port_valid; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_argOuts_0_port_bits; // @[Instantiator.scala 53:44:@15982.4]
  wire [63:0] accel_io_argOuts_0_echo; // @[Instantiator.scala 53:44:@15982.4]
  bbox_AccelUnit accel ( // @[Instantiator.scala 53:44:@15982.4]
    .clock(accel_clock),
    .reset(accel_reset),
    .io_enable(accel_io_enable),
    .io_done(accel_io_done),
    .io_reset(accel_io_reset),
    .io_memStreams_loads_0_cmd_ready(accel_io_memStreams_loads_0_cmd_ready),
    .io_memStreams_loads_0_cmd_valid(accel_io_memStreams_loads_0_cmd_valid),
    .io_memStreams_loads_0_cmd_bits_addr(accel_io_memStreams_loads_0_cmd_bits_addr),
    .io_memStreams_loads_0_cmd_bits_size(accel_io_memStreams_loads_0_cmd_bits_size),
    .io_memStreams_loads_0_data_ready(accel_io_memStreams_loads_0_data_ready),
    .io_memStreams_loads_0_data_valid(accel_io_memStreams_loads_0_data_valid),
    .io_memStreams_loads_0_data_bits_rdata_0(accel_io_memStreams_loads_0_data_bits_rdata_0),
    .io_memStreams_loads_0_data_bits_rdata_1(accel_io_memStreams_loads_0_data_bits_rdata_1),
    .io_memStreams_loads_0_data_bits_rdata_2(accel_io_memStreams_loads_0_data_bits_rdata_2),
    .io_memStreams_loads_0_data_bits_rdata_3(accel_io_memStreams_loads_0_data_bits_rdata_3),
    .io_memStreams_loads_0_data_bits_rdata_4(accel_io_memStreams_loads_0_data_bits_rdata_4),
    .io_memStreams_loads_0_data_bits_rdata_5(accel_io_memStreams_loads_0_data_bits_rdata_5),
    .io_memStreams_loads_0_data_bits_rdata_6(accel_io_memStreams_loads_0_data_bits_rdata_6),
    .io_memStreams_loads_0_data_bits_rdata_7(accel_io_memStreams_loads_0_data_bits_rdata_7),
    .io_memStreams_loads_0_data_bits_rdata_8(accel_io_memStreams_loads_0_data_bits_rdata_8),
    .io_memStreams_loads_0_data_bits_rdata_9(accel_io_memStreams_loads_0_data_bits_rdata_9),
    .io_memStreams_loads_0_data_bits_rdata_10(accel_io_memStreams_loads_0_data_bits_rdata_10),
    .io_memStreams_loads_0_data_bits_rdata_11(accel_io_memStreams_loads_0_data_bits_rdata_11),
    .io_memStreams_loads_0_data_bits_rdata_12(accel_io_memStreams_loads_0_data_bits_rdata_12),
    .io_memStreams_loads_0_data_bits_rdata_13(accel_io_memStreams_loads_0_data_bits_rdata_13),
    .io_memStreams_loads_0_data_bits_rdata_14(accel_io_memStreams_loads_0_data_bits_rdata_14),
    .io_memStreams_loads_0_data_bits_rdata_15(accel_io_memStreams_loads_0_data_bits_rdata_15),
    .io_memStreams_stores_0_cmd_ready(accel_io_memStreams_stores_0_cmd_ready),
    .io_memStreams_stores_0_cmd_valid(accel_io_memStreams_stores_0_cmd_valid),
    .io_memStreams_stores_0_cmd_bits_addr(accel_io_memStreams_stores_0_cmd_bits_addr),
    .io_memStreams_stores_0_cmd_bits_size(accel_io_memStreams_stores_0_cmd_bits_size),
    .io_memStreams_stores_0_data_ready(accel_io_memStreams_stores_0_data_ready),
    .io_memStreams_stores_0_data_valid(accel_io_memStreams_stores_0_data_valid),
    .io_memStreams_stores_0_data_bits_wdata_0(accel_io_memStreams_stores_0_data_bits_wdata_0),
    .io_memStreams_stores_0_data_bits_wdata_1(accel_io_memStreams_stores_0_data_bits_wdata_1),
    .io_memStreams_stores_0_data_bits_wdata_2(accel_io_memStreams_stores_0_data_bits_wdata_2),
    .io_memStreams_stores_0_data_bits_wdata_3(accel_io_memStreams_stores_0_data_bits_wdata_3),
    .io_memStreams_stores_0_data_bits_wdata_4(accel_io_memStreams_stores_0_data_bits_wdata_4),
    .io_memStreams_stores_0_data_bits_wdata_5(accel_io_memStreams_stores_0_data_bits_wdata_5),
    .io_memStreams_stores_0_data_bits_wdata_6(accel_io_memStreams_stores_0_data_bits_wdata_6),
    .io_memStreams_stores_0_data_bits_wdata_7(accel_io_memStreams_stores_0_data_bits_wdata_7),
    .io_memStreams_stores_0_data_bits_wdata_8(accel_io_memStreams_stores_0_data_bits_wdata_8),
    .io_memStreams_stores_0_data_bits_wdata_9(accel_io_memStreams_stores_0_data_bits_wdata_9),
    .io_memStreams_stores_0_data_bits_wdata_10(accel_io_memStreams_stores_0_data_bits_wdata_10),
    .io_memStreams_stores_0_data_bits_wdata_11(accel_io_memStreams_stores_0_data_bits_wdata_11),
    .io_memStreams_stores_0_data_bits_wdata_12(accel_io_memStreams_stores_0_data_bits_wdata_12),
    .io_memStreams_stores_0_data_bits_wdata_13(accel_io_memStreams_stores_0_data_bits_wdata_13),
    .io_memStreams_stores_0_data_bits_wdata_14(accel_io_memStreams_stores_0_data_bits_wdata_14),
    .io_memStreams_stores_0_data_bits_wdata_15(accel_io_memStreams_stores_0_data_bits_wdata_15),
    .io_memStreams_stores_0_data_bits_wstrb(accel_io_memStreams_stores_0_data_bits_wstrb),
    .io_memStreams_stores_0_wresp_ready(accel_io_memStreams_stores_0_wresp_ready),
    .io_memStreams_stores_0_wresp_valid(accel_io_memStreams_stores_0_wresp_valid),
    .io_memStreams_stores_0_wresp_bits(accel_io_memStreams_stores_0_wresp_bits),
    .io_memStreams_gathers_0_cmd_ready(accel_io_memStreams_gathers_0_cmd_ready),
    .io_memStreams_gathers_0_cmd_valid(accel_io_memStreams_gathers_0_cmd_valid),
    .io_memStreams_gathers_0_cmd_bits_addr_0(accel_io_memStreams_gathers_0_cmd_bits_addr_0),
    .io_memStreams_gathers_0_cmd_bits_addr_1(accel_io_memStreams_gathers_0_cmd_bits_addr_1),
    .io_memStreams_gathers_0_cmd_bits_addr_2(accel_io_memStreams_gathers_0_cmd_bits_addr_2),
    .io_memStreams_gathers_0_cmd_bits_addr_3(accel_io_memStreams_gathers_0_cmd_bits_addr_3),
    .io_memStreams_gathers_0_cmd_bits_addr_4(accel_io_memStreams_gathers_0_cmd_bits_addr_4),
    .io_memStreams_gathers_0_cmd_bits_addr_5(accel_io_memStreams_gathers_0_cmd_bits_addr_5),
    .io_memStreams_gathers_0_cmd_bits_addr_6(accel_io_memStreams_gathers_0_cmd_bits_addr_6),
    .io_memStreams_gathers_0_cmd_bits_addr_7(accel_io_memStreams_gathers_0_cmd_bits_addr_7),
    .io_memStreams_gathers_0_cmd_bits_addr_8(accel_io_memStreams_gathers_0_cmd_bits_addr_8),
    .io_memStreams_gathers_0_cmd_bits_addr_9(accel_io_memStreams_gathers_0_cmd_bits_addr_9),
    .io_memStreams_gathers_0_cmd_bits_addr_10(accel_io_memStreams_gathers_0_cmd_bits_addr_10),
    .io_memStreams_gathers_0_cmd_bits_addr_11(accel_io_memStreams_gathers_0_cmd_bits_addr_11),
    .io_memStreams_gathers_0_cmd_bits_addr_12(accel_io_memStreams_gathers_0_cmd_bits_addr_12),
    .io_memStreams_gathers_0_cmd_bits_addr_13(accel_io_memStreams_gathers_0_cmd_bits_addr_13),
    .io_memStreams_gathers_0_cmd_bits_addr_14(accel_io_memStreams_gathers_0_cmd_bits_addr_14),
    .io_memStreams_gathers_0_cmd_bits_addr_15(accel_io_memStreams_gathers_0_cmd_bits_addr_15),
    .io_memStreams_gathers_0_data_ready(accel_io_memStreams_gathers_0_data_ready),
    .io_memStreams_gathers_0_data_valid(accel_io_memStreams_gathers_0_data_valid),
    .io_memStreams_gathers_0_data_bits_0(accel_io_memStreams_gathers_0_data_bits_0),
    .io_memStreams_gathers_0_data_bits_1(accel_io_memStreams_gathers_0_data_bits_1),
    .io_memStreams_gathers_0_data_bits_2(accel_io_memStreams_gathers_0_data_bits_2),
    .io_memStreams_gathers_0_data_bits_3(accel_io_memStreams_gathers_0_data_bits_3),
    .io_memStreams_gathers_0_data_bits_4(accel_io_memStreams_gathers_0_data_bits_4),
    .io_memStreams_gathers_0_data_bits_5(accel_io_memStreams_gathers_0_data_bits_5),
    .io_memStreams_gathers_0_data_bits_6(accel_io_memStreams_gathers_0_data_bits_6),
    .io_memStreams_gathers_0_data_bits_7(accel_io_memStreams_gathers_0_data_bits_7),
    .io_memStreams_gathers_0_data_bits_8(accel_io_memStreams_gathers_0_data_bits_8),
    .io_memStreams_gathers_0_data_bits_9(accel_io_memStreams_gathers_0_data_bits_9),
    .io_memStreams_gathers_0_data_bits_10(accel_io_memStreams_gathers_0_data_bits_10),
    .io_memStreams_gathers_0_data_bits_11(accel_io_memStreams_gathers_0_data_bits_11),
    .io_memStreams_gathers_0_data_bits_12(accel_io_memStreams_gathers_0_data_bits_12),
    .io_memStreams_gathers_0_data_bits_13(accel_io_memStreams_gathers_0_data_bits_13),
    .io_memStreams_gathers_0_data_bits_14(accel_io_memStreams_gathers_0_data_bits_14),
    .io_memStreams_gathers_0_data_bits_15(accel_io_memStreams_gathers_0_data_bits_15),
    .io_memStreams_scatters_0_cmd_ready(accel_io_memStreams_scatters_0_cmd_ready),
    .io_memStreams_scatters_0_cmd_valid(accel_io_memStreams_scatters_0_cmd_valid),
    .io_memStreams_scatters_0_cmd_bits_addr_addr_0(accel_io_memStreams_scatters_0_cmd_bits_addr_addr_0),
    .io_memStreams_scatters_0_cmd_bits_addr_addr_1(accel_io_memStreams_scatters_0_cmd_bits_addr_addr_1),
    .io_memStreams_scatters_0_cmd_bits_addr_addr_2(accel_io_memStreams_scatters_0_cmd_bits_addr_addr_2),
    .io_memStreams_scatters_0_cmd_bits_addr_addr_3(accel_io_memStreams_scatters_0_cmd_bits_addr_addr_3),
    .io_memStreams_scatters_0_cmd_bits_addr_addr_4(accel_io_memStreams_scatters_0_cmd_bits_addr_addr_4),
    .io_memStreams_scatters_0_cmd_bits_addr_addr_5(accel_io_memStreams_scatters_0_cmd_bits_addr_addr_5),
    .io_memStreams_scatters_0_cmd_bits_addr_addr_6(accel_io_memStreams_scatters_0_cmd_bits_addr_addr_6),
    .io_memStreams_scatters_0_cmd_bits_addr_addr_7(accel_io_memStreams_scatters_0_cmd_bits_addr_addr_7),
    .io_memStreams_scatters_0_cmd_bits_addr_addr_8(accel_io_memStreams_scatters_0_cmd_bits_addr_addr_8),
    .io_memStreams_scatters_0_cmd_bits_addr_addr_9(accel_io_memStreams_scatters_0_cmd_bits_addr_addr_9),
    .io_memStreams_scatters_0_cmd_bits_addr_addr_10(accel_io_memStreams_scatters_0_cmd_bits_addr_addr_10),
    .io_memStreams_scatters_0_cmd_bits_addr_addr_11(accel_io_memStreams_scatters_0_cmd_bits_addr_addr_11),
    .io_memStreams_scatters_0_cmd_bits_addr_addr_12(accel_io_memStreams_scatters_0_cmd_bits_addr_addr_12),
    .io_memStreams_scatters_0_cmd_bits_addr_addr_13(accel_io_memStreams_scatters_0_cmd_bits_addr_addr_13),
    .io_memStreams_scatters_0_cmd_bits_addr_addr_14(accel_io_memStreams_scatters_0_cmd_bits_addr_addr_14),
    .io_memStreams_scatters_0_cmd_bits_addr_addr_15(accel_io_memStreams_scatters_0_cmd_bits_addr_addr_15),
    .io_memStreams_scatters_0_cmd_bits_wdata_0(accel_io_memStreams_scatters_0_cmd_bits_wdata_0),
    .io_memStreams_scatters_0_cmd_bits_wdata_1(accel_io_memStreams_scatters_0_cmd_bits_wdata_1),
    .io_memStreams_scatters_0_cmd_bits_wdata_2(accel_io_memStreams_scatters_0_cmd_bits_wdata_2),
    .io_memStreams_scatters_0_cmd_bits_wdata_3(accel_io_memStreams_scatters_0_cmd_bits_wdata_3),
    .io_memStreams_scatters_0_cmd_bits_wdata_4(accel_io_memStreams_scatters_0_cmd_bits_wdata_4),
    .io_memStreams_scatters_0_cmd_bits_wdata_5(accel_io_memStreams_scatters_0_cmd_bits_wdata_5),
    .io_memStreams_scatters_0_cmd_bits_wdata_6(accel_io_memStreams_scatters_0_cmd_bits_wdata_6),
    .io_memStreams_scatters_0_cmd_bits_wdata_7(accel_io_memStreams_scatters_0_cmd_bits_wdata_7),
    .io_memStreams_scatters_0_cmd_bits_wdata_8(accel_io_memStreams_scatters_0_cmd_bits_wdata_8),
    .io_memStreams_scatters_0_cmd_bits_wdata_9(accel_io_memStreams_scatters_0_cmd_bits_wdata_9),
    .io_memStreams_scatters_0_cmd_bits_wdata_10(accel_io_memStreams_scatters_0_cmd_bits_wdata_10),
    .io_memStreams_scatters_0_cmd_bits_wdata_11(accel_io_memStreams_scatters_0_cmd_bits_wdata_11),
    .io_memStreams_scatters_0_cmd_bits_wdata_12(accel_io_memStreams_scatters_0_cmd_bits_wdata_12),
    .io_memStreams_scatters_0_cmd_bits_wdata_13(accel_io_memStreams_scatters_0_cmd_bits_wdata_13),
    .io_memStreams_scatters_0_cmd_bits_wdata_14(accel_io_memStreams_scatters_0_cmd_bits_wdata_14),
    .io_memStreams_scatters_0_cmd_bits_wdata_15(accel_io_memStreams_scatters_0_cmd_bits_wdata_15),
    .io_memStreams_scatters_0_wresp_ready(accel_io_memStreams_scatters_0_wresp_ready),
    .io_memStreams_scatters_0_wresp_valid(accel_io_memStreams_scatters_0_wresp_valid),
    .io_memStreams_scatters_0_wresp_bits(accel_io_memStreams_scatters_0_wresp_bits),
    .io_axiStreamsIn_0_TVALID(accel_io_axiStreamsIn_0_TVALID),
    .io_axiStreamsIn_0_TREADY(accel_io_axiStreamsIn_0_TREADY),
    .io_axiStreamsIn_0_TDATA(accel_io_axiStreamsIn_0_TDATA),
    .io_axiStreamsIn_0_TSTRB(accel_io_axiStreamsIn_0_TSTRB),
    .io_axiStreamsIn_0_TKEEP(accel_io_axiStreamsIn_0_TKEEP),
    .io_axiStreamsIn_0_TLAST(accel_io_axiStreamsIn_0_TLAST),
    .io_axiStreamsIn_0_TID(accel_io_axiStreamsIn_0_TID),
    .io_axiStreamsIn_0_TDEST(accel_io_axiStreamsIn_0_TDEST),
    .io_axiStreamsIn_0_TUSER(accel_io_axiStreamsIn_0_TUSER),
    .io_axiStreamsOut_0_TVALID(accel_io_axiStreamsOut_0_TVALID),
    .io_axiStreamsOut_0_TREADY(accel_io_axiStreamsOut_0_TREADY),
    .io_axiStreamsOut_0_TDATA(accel_io_axiStreamsOut_0_TDATA),
    .io_axiStreamsOut_0_TSTRB(accel_io_axiStreamsOut_0_TSTRB),
    .io_axiStreamsOut_0_TKEEP(accel_io_axiStreamsOut_0_TKEEP),
    .io_axiStreamsOut_0_TLAST(accel_io_axiStreamsOut_0_TLAST),
    .io_axiStreamsOut_0_TID(accel_io_axiStreamsOut_0_TID),
    .io_axiStreamsOut_0_TDEST(accel_io_axiStreamsOut_0_TDEST),
    .io_axiStreamsOut_0_TUSER(accel_io_axiStreamsOut_0_TUSER),
    .io_heap_0_req_valid(accel_io_heap_0_req_valid),
    .io_heap_0_req_bits_allocDealloc(accel_io_heap_0_req_bits_allocDealloc),
    .io_heap_0_req_bits_sizeAddr(accel_io_heap_0_req_bits_sizeAddr),
    .io_heap_0_resp_valid(accel_io_heap_0_resp_valid),
    .io_heap_0_resp_bits_allocDealloc(accel_io_heap_0_resp_bits_allocDealloc),
    .io_heap_0_resp_bits_sizeAddr(accel_io_heap_0_resp_bits_sizeAddr),
    .io_argIns_0(accel_io_argIns_0),
    .io_argOuts_0_port_ready(accel_io_argOuts_0_port_ready),
    .io_argOuts_0_port_valid(accel_io_argOuts_0_port_valid),
    .io_argOuts_0_port_bits(accel_io_argOuts_0_port_bits),
    .io_argOuts_0_echo(accel_io_argOuts_0_echo)
  );
  assign io_rdata = 64'h0;
  assign accel_clock = clock; // @[:@15983.4]
  assign accel_reset = reset; // @[:@15984.4]
  assign accel_io_enable = 1'h0;
  assign accel_io_reset = 1'h0;
  assign accel_io_memStreams_loads_0_cmd_ready = 1'h0;
  assign accel_io_memStreams_loads_0_data_valid = 1'h0;
  assign accel_io_memStreams_loads_0_data_bits_rdata_0 = 32'h0;
  assign accel_io_memStreams_loads_0_data_bits_rdata_1 = 32'h0;
  assign accel_io_memStreams_loads_0_data_bits_rdata_2 = 32'h0;
  assign accel_io_memStreams_loads_0_data_bits_rdata_3 = 32'h0;
  assign accel_io_memStreams_loads_0_data_bits_rdata_4 = 32'h0;
  assign accel_io_memStreams_loads_0_data_bits_rdata_5 = 32'h0;
  assign accel_io_memStreams_loads_0_data_bits_rdata_6 = 32'h0;
  assign accel_io_memStreams_loads_0_data_bits_rdata_7 = 32'h0;
  assign accel_io_memStreams_loads_0_data_bits_rdata_8 = 32'h0;
  assign accel_io_memStreams_loads_0_data_bits_rdata_9 = 32'h0;
  assign accel_io_memStreams_loads_0_data_bits_rdata_10 = 32'h0;
  assign accel_io_memStreams_loads_0_data_bits_rdata_11 = 32'h0;
  assign accel_io_memStreams_loads_0_data_bits_rdata_12 = 32'h0;
  assign accel_io_memStreams_loads_0_data_bits_rdata_13 = 32'h0;
  assign accel_io_memStreams_loads_0_data_bits_rdata_14 = 32'h0;
  assign accel_io_memStreams_loads_0_data_bits_rdata_15 = 32'h0;
  assign accel_io_memStreams_stores_0_cmd_ready = 1'h0;
  assign accel_io_memStreams_stores_0_data_ready = 1'h0;
  assign accel_io_memStreams_stores_0_wresp_valid = 1'h0;
  assign accel_io_memStreams_stores_0_wresp_bits = 1'h0;
  assign accel_io_memStreams_gathers_0_cmd_ready = 1'h0;
  assign accel_io_memStreams_gathers_0_data_valid = 1'h0;
  assign accel_io_memStreams_gathers_0_data_bits_0 = 32'h0;
  assign accel_io_memStreams_gathers_0_data_bits_1 = 32'h0;
  assign accel_io_memStreams_gathers_0_data_bits_2 = 32'h0;
  assign accel_io_memStreams_gathers_0_data_bits_3 = 32'h0;
  assign accel_io_memStreams_gathers_0_data_bits_4 = 32'h0;
  assign accel_io_memStreams_gathers_0_data_bits_5 = 32'h0;
  assign accel_io_memStreams_gathers_0_data_bits_6 = 32'h0;
  assign accel_io_memStreams_gathers_0_data_bits_7 = 32'h0;
  assign accel_io_memStreams_gathers_0_data_bits_8 = 32'h0;
  assign accel_io_memStreams_gathers_0_data_bits_9 = 32'h0;
  assign accel_io_memStreams_gathers_0_data_bits_10 = 32'h0;
  assign accel_io_memStreams_gathers_0_data_bits_11 = 32'h0;
  assign accel_io_memStreams_gathers_0_data_bits_12 = 32'h0;
  assign accel_io_memStreams_gathers_0_data_bits_13 = 32'h0;
  assign accel_io_memStreams_gathers_0_data_bits_14 = 32'h0;
  assign accel_io_memStreams_gathers_0_data_bits_15 = 32'h0;
  assign accel_io_memStreams_scatters_0_cmd_ready = 1'h0;
  assign accel_io_memStreams_scatters_0_wresp_valid = 1'h0;
  assign accel_io_memStreams_scatters_0_wresp_bits = 1'h0;
  assign accel_io_axiStreamsIn_0_TVALID = 1'h0;
  assign accel_io_axiStreamsIn_0_TDATA = 256'h0;
  assign accel_io_axiStreamsIn_0_TSTRB = 32'h0;
  assign accel_io_axiStreamsIn_0_TKEEP = 32'h0;
  assign accel_io_axiStreamsIn_0_TLAST = 1'h0;
  assign accel_io_axiStreamsIn_0_TID = 8'h0;
  assign accel_io_axiStreamsIn_0_TDEST = 8'h0;
  assign accel_io_axiStreamsIn_0_TUSER = 32'h0;
  assign accel_io_axiStreamsOut_0_TREADY = 1'h0;
  assign accel_io_heap_0_resp_valid = 1'h0;
  assign accel_io_heap_0_resp_bits_allocDealloc = 1'h0;
  assign accel_io_heap_0_resp_bits_sizeAddr = 64'h0;
  assign accel_io_argIns_0 = 64'h0;
  assign accel_io_argOuts_0_port_ready = 1'h0;
  assign accel_io_argOuts_0_echo = 64'h0;
endmodule
