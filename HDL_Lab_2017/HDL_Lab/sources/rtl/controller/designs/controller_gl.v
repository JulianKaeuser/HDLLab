
module controller ( clk, reset, decoder_load_in, decoder_store_in, 
        fetch_load_in, decoder_src_mem_addr_in, mem_output_valid_in, 
        mem_write_ready_in, stall_mem2fetch_out, addr_select_out, 
        read_en_sel_out, word_select_out, stall_any2decoder_out );
  output [1:0] addr_select_out;
  input clk, reset, decoder_load_in, decoder_store_in, fetch_load_in,
         decoder_src_mem_addr_in, mem_output_valid_in, mem_write_ready_in;
  output stall_mem2fetch_out, read_en_sel_out, word_select_out,
         stall_any2decoder_out;
  wire   N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13,
         id_request, turn, nextturn, N14, N15, N16, N17, N18, N19, N20, N21,
         N22, N23, N24, N25, N26, N27, N28, N29, N30, N31, N32, N33, N34, N35,
         N36, N37, N38, N39, N40, N41, N42, N43, N44, N45, N46, N47, N48, N49,
         N50, N51, N52, N53;
  wire   [1:0] state;
  wire   [1:0] nextstate;

  \**SEQGEN**  turn_reg ( .clear(reset), .preset(1'b0), .next_state(nextturn), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(turn), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N49) );
  \**SEQGEN**  state_reg_1_ ( .clear(1'b0), .preset(reset), .next_state(
        nextstate[1]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        state[1]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  state_reg_0_ ( .clear(1'b0), .preset(reset), .next_state(
        nextstate[0]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        state[0]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  GTECH_AND2 C16 ( .A(state[1]), .B(state[0]), .Z(N14) );
  GTECH_AND2 C19 ( .A(N15), .B(N16), .Z(N17) );
  GTECH_OR2 C21 ( .A(N15), .B(state[0]), .Z(N18) );
  GTECH_OR2 C24 ( .A(state[1]), .B(N16), .Z(N20) );
  GTECH_AND2 C71 ( .A(state[1]), .B(state[0]), .Z(N33) );
  GTECH_AND2 C74 ( .A(N15), .B(N16), .Z(N34) );
  GTECH_OR2 C76 ( .A(N15), .B(state[0]), .Z(N35) );
  GTECH_OR2 C79 ( .A(state[1]), .B(N16), .Z(N37) );
  GTECH_OR2 C197 ( .A(N30), .B(N25), .Z(N27) );
  GTECH_OR2 C200 ( .A(N30), .B(N26), .Z(N28) );
  GTECH_OR2 C202 ( .A(N14), .B(N19), .Z(N50) );
  GTECH_OR2 C204 ( .A(N14), .B(N21), .Z(N51) );
  SELECT_OP C207 ( .DATA1(1'b0), .DATA2(N26), .DATA3(N46), .CONTROL1(N0), 
        .CONTROL2(N1), .CONTROL3(N2), .Z(nextstate[0]) );
  GTECH_BUF B_0 ( .A(N50), .Z(N0) );
  GTECH_BUF B_1 ( .A(N17), .Z(N1) );
  GTECH_BUF B_2 ( .A(N21), .Z(N2) );
  SELECT_OP C208 ( .DATA1(1'b0), .DATA2(N27), .DATA3(N43), .CONTROL1(N3), 
        .CONTROL2(N1), .CONTROL3(N4), .Z(nextstate[1]) );
  GTECH_BUF B_3 ( .A(N51), .Z(N3) );
  GTECH_BUF B_4 ( .A(N19), .Z(N4) );
  SELECT_OP C209 ( .DATA1(1'b0), .DATA2(N28), .CONTROL1(N5), .CONTROL2(N1), 
        .Z(nextturn) );
  GTECH_BUF B_5 ( .A(N14), .Z(N5) );
  SELECT_OP C210 ( .DATA1(N45), .DATA2(1'b0), .CONTROL1(N6), .CONTROL2(N7), 
        .Z(N39) );
  GTECH_BUF B_6 ( .A(id_request), .Z(N6) );
  GTECH_BUF B_7 ( .A(N52), .Z(N7) );
  SELECT_OP C211 ( .DATA1(N45), .DATA2(1'b0), .CONTROL1(N8), .CONTROL2(N9), 
        .Z(N42) );
  GTECH_BUF B_8 ( .A(turn), .Z(N8) );
  GTECH_BUF B_9 ( .A(N41), .Z(N9) );
  SELECT_OP C212 ( .DATA1(N43), .DATA2(1'b1), .CONTROL1(N8), .CONTROL2(N9), 
        .Z(N44) );
  SELECT_OP C213 ( .DATA1(1'b0), .DATA2(id_request), .DATA3(turn), .DATA4(1'b1), .CONTROL1(N10), .CONTROL2(N11), .CONTROL3(N12), .CONTROL4(N13), .Z(
        stall_mem2fetch_out) );
  GTECH_BUF B_10 ( .A(N33), .Z(N10) );
  GTECH_BUF B_11 ( .A(N34), .Z(N11) );
  GTECH_BUF B_12 ( .A(N36), .Z(N12) );
  GTECH_BUF B_13 ( .A(N38), .Z(N13) );
  SELECT_OP C214 ( .DATA1({1'b0, 1'b0}), .DATA2({id_request, N39}), .DATA3({
        turn, N42}), .DATA4({1'b1, N45}), .CONTROL1(N10), .CONTROL2(N11), 
        .CONTROL3(N12), .CONTROL4(N13), .Z(addr_select_out) );
  SELECT_OP C215 ( .DATA1(1'b1), .DATA2(N52), .DATA3(N41), .DATA4(1'b0), 
        .CONTROL1(N10), .CONTROL2(N11), .CONTROL3(N12), .CONTROL4(N13), .Z(
        read_en_sel_out) );
  SELECT_OP C216 ( .DATA1(1'b1), .DATA2(N52), .DATA3(N41), .DATA4(1'b0), 
        .CONTROL1(N10), .CONTROL2(N11), .CONTROL3(N12), .CONTROL4(N13), .Z(
        word_select_out) );
  SELECT_OP C217 ( .DATA1(1'b0), .DATA2(N40), .DATA3(N44), .DATA4(N46), 
        .CONTROL1(N10), .CONTROL2(N11), .CONTROL3(N12), .CONTROL4(N13), .Z(
        stall_any2decoder_out) );
  GTECH_OR2 C220 ( .A(decoder_store_in), .B(decoder_load_in), .Z(id_request)
         );
  GTECH_NOT I_0 ( .A(state[1]), .Z(N15) );
  GTECH_NOT I_1 ( .A(state[0]), .Z(N16) );
  GTECH_NOT I_2 ( .A(N18), .Z(N19) );
  GTECH_NOT I_3 ( .A(N20), .Z(N21) );
  GTECH_AND2 C231 ( .A(N52), .B(N53), .Z(N22) );
  GTECH_NOT I_4 ( .A(id_request), .Z(N52) );
  GTECH_NOT I_5 ( .A(fetch_load_in), .Z(N53) );
  GTECH_OR2 C237 ( .A(decoder_load_in), .B(N22), .Z(N23) );
  GTECH_OR2 C238 ( .A(decoder_store_in), .B(N23), .Z(N24) );
  GTECH_NOT I_6 ( .A(N24), .Z(N25) );
  GTECH_NOT I_7 ( .A(N22), .Z(N29) );
  GTECH_AND2 C243 ( .A(decoder_load_in), .B(N29), .Z(N30) );
  GTECH_NOT I_8 ( .A(decoder_load_in), .Z(N31) );
  GTECH_AND2 C245 ( .A(N29), .B(N31), .Z(N32) );
  GTECH_AND2 C246 ( .A(decoder_store_in), .B(N32), .Z(N26) );
  GTECH_NOT I_9 ( .A(N35), .Z(N36) );
  GTECH_NOT I_10 ( .A(N37), .Z(N38) );
  GTECH_NOT I_11 ( .A(turn), .Z(N41) );
  GTECH_NOT I_12 ( .A(mem_output_valid_in), .Z(N43) );
  GTECH_NOT I_13 ( .A(decoder_src_mem_addr_in), .Z(N45) );
  GTECH_NOT I_14 ( .A(mem_write_ready_in), .Z(N46) );
  GTECH_NOT I_15 ( .A(id_request), .Z(N47) );
  GTECH_AND2 C283 ( .A(fetch_load_in), .B(N47), .Z(N40) );
  GTECH_OR2 C284 ( .A(N19), .B(N21), .Z(N48) );
  GTECH_NOT I_16 ( .A(N48), .Z(N49) );
endmodule

