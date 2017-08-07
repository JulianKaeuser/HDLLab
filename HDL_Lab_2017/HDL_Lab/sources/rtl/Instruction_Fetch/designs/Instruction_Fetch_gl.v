
module Instruction_Fetch ( clk, reset, stall_decoder_in, stall_memory, pc_in, 
        instruction_in, read_enable, pc_en, address, pc_out, instruction_out
 );
  input [31:0] pc_in;
  input [15:0] instruction_in;
  output [11:0] address;
  output [31:0] pc_out;
  output [15:0] instruction_out;
  input clk, reset, stall_decoder_in, stall_memory;
  output read_enable, pc_en;
  wire   N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15,
         N16, N17, N18, N19, N20, N21, N22, N23, N24, N25, N26, N27, N28, N29,
         N30, N31, N32, N33, N34, N35, N36, N37, N38, N39, N40, N41, N42, N43,
         N44, N45, N46, N47, N48, N49, N50, N51, N52, N53, N54, N55, N56, N57,
         N58, N59, N60, N61, N62, N63, N64, N65, N66, N67, N68, N69, N70, N71,
         N72, N73, N74, N75, N76;
  wire   [1:0] currentState;
  wire   [1:0] nextState;
  wire   [15:0] instruction;

  GTECH_AND2 C6 ( .A(N39), .B(N40), .Z(N41) );
  GTECH_OR2 C8 ( .A(currentState[1]), .B(N40), .Z(N42) );
  GTECH_OR2 C11 ( .A(N39), .B(currentState[0]), .Z(N44) );
  GTECH_AND2 C13 ( .A(currentState[1]), .B(currentState[0]), .Z(N46) );
  \**SEQGEN**  instruction_out_reg_15_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(instruction[15]), .clocked_on(clk), .data_in(
        instruction[15]), .enable(reset), .Q(instruction_out[15]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  instruction_out_reg_14_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(instruction[14]), .clocked_on(clk), .data_in(
        instruction[14]), .enable(reset), .Q(instruction_out[14]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  instruction_out_reg_13_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(instruction[13]), .clocked_on(clk), .data_in(
        instruction[13]), .enable(reset), .Q(instruction_out[13]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  instruction_out_reg_12_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(instruction[12]), .clocked_on(clk), .data_in(
        instruction[12]), .enable(reset), .Q(instruction_out[12]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  instruction_out_reg_11_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(instruction[11]), .clocked_on(clk), .data_in(
        instruction[11]), .enable(reset), .Q(instruction_out[11]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  instruction_out_reg_10_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(instruction[10]), .clocked_on(clk), .data_in(
        instruction[10]), .enable(reset), .Q(instruction_out[10]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  instruction_out_reg_9_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(instruction[9]), .clocked_on(clk), .data_in(instruction[9]), .enable(reset), .Q(instruction_out[9]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  instruction_out_reg_8_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(instruction[8]), .clocked_on(clk), .data_in(instruction[8]), .enable(reset), .Q(instruction_out[8]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  instruction_out_reg_7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(instruction[7]), .clocked_on(clk), .data_in(instruction[7]), .enable(reset), .Q(instruction_out[7]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  instruction_out_reg_6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(instruction[6]), .clocked_on(clk), .data_in(instruction[6]), .enable(reset), .Q(instruction_out[6]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  instruction_out_reg_5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(instruction[5]), .clocked_on(clk), .data_in(instruction[5]), .enable(reset), .Q(instruction_out[5]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  instruction_out_reg_4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(instruction[4]), .clocked_on(clk), .data_in(instruction[4]), .enable(reset), .Q(instruction_out[4]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  instruction_out_reg_3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(instruction[3]), .clocked_on(clk), .data_in(instruction[3]), .enable(reset), .Q(instruction_out[3]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  instruction_out_reg_2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(instruction[2]), .clocked_on(clk), .data_in(instruction[2]), .enable(reset), .Q(instruction_out[2]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  instruction_out_reg_1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(instruction[1]), .clocked_on(clk), .data_in(instruction[1]), .enable(reset), .Q(instruction_out[1]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  instruction_out_reg_0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(instruction[0]), .clocked_on(clk), .data_in(instruction[0]), .enable(reset), .Q(instruction_out[0]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  currentState_reg_1_ ( .clear(reset), .preset(1'b0), 
        .next_state(nextState[1]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(currentState[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  currentState_reg_0_ ( .clear(reset), .preset(1'b0), 
        .next_state(nextState[0]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(currentState[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  GTECH_NOT I_0 ( .A(stall_memory), .Z(N72) );
  GTECH_NOT I_1 ( .A(stall_decoder_in), .Z(N73) );
  ADD_UNS_OP add_14 ( .A(pc_in), .B({1'b1, 1'b0, 1'b0}), .Z({N38, N37, N36, 
        N35, N34, N33, N32, N31, N30, N29, N28, N27, N26, N25, N24, N23, N22, 
        N21, N20, N19, N18, N17, N16, N15, N14, N13, N12, N11, N10, N9, N8, N7}) );
  GTECH_OR2 C211 ( .A(stall_memory), .B(N70), .Z(N51) );
  GTECH_OR2 C213 ( .A(stall_memory), .B(N50), .Z(N52) );
  GTECH_OR3 C215 ( .A(N43), .B(N45), .C(N46), .Z(N74) );
  GTECH_OR3 C279 ( .A(N41), .B(N45), .C(N46), .Z(N75) );
  GTECH_OR2 C282 ( .A(N43), .B(N45), .Z(N76) );
  GTECH_NOT I_2 ( .A(N47), .Z(N48) );
  SELECT_OP C350 ( .DATA1(instruction_out), .DATA2(instruction_in), .CONTROL1(
        N0), .CONTROL2(N1), .Z({N68, N67, N66, N65, N64, N63, N62, N61, N60, 
        N59, N58, N57, N56, N55, N54, N53}) );
  GTECH_BUF B_0 ( .A(stall_memory), .Z(N0) );
  GTECH_BUF B_1 ( .A(N72), .Z(N1) );
  SELECT_OP C351 ( .DATA1({N71, 1'b0}), .DATA2({N48, N47}), .DATA3({1'b1, 
        stall_memory}), .DATA4({N52, N51}), .CONTROL1(N2), .CONTROL2(N43), 
        .CONTROL3(N45), .CONTROL4(N3), .Z(nextState) );
  GTECH_BUF B_2 ( .A(N41), .Z(N2) );
  GTECH_BUF B_3 ( .A(N46), .Z(N3) );
  SELECT_OP C352 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA2({N38, N37, N36, N35, N34, N33, N32, N31, N30, N29, N28, N27, N26, 
        N25, N24, N23, N22, N21, N20, N19, N18, N17, N16, N15, N14, N13, N12, 
        N11, N10, N9, N8, N7}), .CONTROL1(N2), .CONTROL2(N4), .Z(pc_out) );
  GTECH_BUF B_4 ( .A(N74), .Z(N4) );
  SELECT_OP C353 ( .DATA1(1'b1), .DATA2(N72), .DATA3(N72), .DATA4(1'b0), 
        .CONTROL1(N2), .CONTROL2(N43), .CONTROL3(N45), .CONTROL4(N3), .Z(
        read_enable) );
  SELECT_OP C354 ( .DATA1(1'b1), .DATA2(N73), .CONTROL1(N5), .CONTROL2(N43), 
        .Z(pc_en) );
  GTECH_BUF B_5 ( .A(N75), .Z(N5) );
  SELECT_OP C355 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0}), .DATA2(pc_in[11:0]), .CONTROL1(N2), 
        .CONTROL2(N6), .Z(address) );
  GTECH_BUF B_6 ( .A(N76), .Z(N6) );
  SELECT_OP C356 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA2(
        instruction_out), .DATA3({N68, N67, N66, N65, N64, N63, N62, N61, N60, 
        N59, N58, N57, N56, N55, N54, N53}), .CONTROL1(N2), .CONTROL2(N6), 
        .CONTROL3(N3), .Z(instruction) );
  GTECH_NOT I_3 ( .A(currentState[1]), .Z(N39) );
  GTECH_NOT I_4 ( .A(currentState[0]), .Z(N40) );
  GTECH_NOT I_5 ( .A(N42), .Z(N43) );
  GTECH_NOT I_6 ( .A(N44), .Z(N45) );
  GTECH_OR2 C369 ( .A(stall_memory), .B(stall_decoder_in), .Z(N47) );
  GTECH_OR2 C377 ( .A(stall_decoder_in), .B(stall_memory), .Z(N49) );
  GTECH_NOT I_7 ( .A(N49), .Z(N50) );
  GTECH_NOT I_8 ( .A(stall_memory), .Z(N69) );
  GTECH_AND2 C380 ( .A(stall_decoder_in), .B(N69), .Z(N70) );
  GTECH_NOT I_9 ( .A(reset), .Z(N71) );
endmodule

