
module memory_control_fsm ( is_signed_fsm, word_type, load, store, clk, reset, 
        output_valid, direct_or_delayed_din, write_ready, 
        old_or_new_byte_remainder, modified_or_original_address, 
        added_or_delayed_address, first_two_bytes_out_select, 
        third_byte_out_select, output_shuffle, mem_read_enable, 
        mem_write_enable, mem_enable, fsm_read_control, fsm_write_control, 
        busy );
  input [1:0] word_type;
  output [1:0] direct_or_delayed_din;
  output [1:0] first_two_bytes_out_select;
  output [1:0] third_byte_out_select;
  input is_signed_fsm, load, store, clk, reset;
  output output_valid, write_ready, old_or_new_byte_remainder,
         modified_or_original_address, added_or_delayed_address,
         output_shuffle, mem_read_enable, mem_write_enable, mem_enable,
         fsm_read_control, fsm_write_control, busy;
  wire   N32, N33, N34, N35, n69, n108, n109, n110, n111, n112, n113, n114,
         n115, n116, n117, n118, n119, n120, n121, n122, n123, n124, n125,
         n126, n127, n128, n129, n130, n131, n132, n133, n134, n135, n136,
         n137, n138, n139;
  wire   [2:0] state;

  DFXD1BWP12T state_reg_1_ ( .D(N33), .CP(clk), .Q(state[1]), .QN(n138) );
  DFXD1BWP12T state_reg_3_ ( .D(N35), .CP(clk), .QN(n69) );
  DFXD1BWP12T state_reg_0_ ( .D(N32), .CP(clk), .Q(state[0]), .QN(n139) );
  DFQD1BWP12T state_reg_2_ ( .D(N34), .CP(clk), .Q(state[2]) );
  TIELBWP12T U103 ( .ZN(n108) );
  INVD1BWP12T U104 ( .I(n108), .ZN(mem_enable) );
  INVD1BWP12T U105 ( .I(n127), .ZN(n121) );
  NR3D1BWP12T U106 ( .A1(n112), .A2(state[2]), .A3(state[1]), .ZN(n127) );
  ND2D1BWP12T U107 ( .A1(n69), .A2(n139), .ZN(n112) );
  INVD1BWP12T U108 ( .I(n131), .ZN(n114) );
  NR2D1BWP12T U109 ( .A1(n114), .A2(n113), .ZN(n123) );
  MOAI22D0BWP12T U110 ( .A1(word_type[1]), .A2(word_type[0]), .B1(word_type[1]), .B2(word_type[0]), .ZN(n129) );
  ND2D1BWP12T U111 ( .A1(state[0]), .A2(n115), .ZN(n122) );
  INR3D0BWP12T U112 ( .A1(store), .B1(load), .B2(n121), .ZN(n130) );
  NR2D1BWP12T U113 ( .A1(n138), .A2(state[2]), .ZN(n131) );
  NR2D1BWP12T U114 ( .A1(n69), .A2(n139), .ZN(n132) );
  IOA21D0BWP12T U115 ( .A1(word_type[0]), .A2(word_type[1]), .B(n130), .ZN(
        n128) );
  CKND0BWP12T U116 ( .I(word_type[1]), .ZN(n109) );
  AOI22D0BWP12T U117 ( .A1(n130), .A2(n109), .B1(n131), .B2(n132), .ZN(n110)
         );
  OAI32D0BWP12T U118 ( .A1(reset), .A2(word_type[0]), .A3(n133), .B1(n110), 
        .B2(reset), .ZN(N33) );
  CKND2D1BWP12T U119 ( .A1(state[2]), .A2(n132), .ZN(n126) );
  CKND2D0BWP12T U120 ( .A1(state[2]), .A2(n138), .ZN(n111) );
  AOI21D1BWP12T U121 ( .A1(n111), .A2(n114), .B(n69), .ZN(n115) );
  CKND2D0BWP12T U122 ( .A1(n115), .A2(n139), .ZN(n116) );
  OAI21D0BWP12T U123 ( .A1(n126), .A2(n138), .B(n116), .ZN(write_ready) );
  NR2D0BWP12T U124 ( .A1(n111), .A2(n112), .ZN(output_shuffle) );
  NR2D0BWP12T U125 ( .A1(n112), .A2(n114), .ZN(n135) );
  CKND2D1BWP12T U126 ( .A1(n69), .A2(state[0]), .ZN(n113) );
  NR3D0BWP12T U127 ( .A1(state[2]), .A2(state[1]), .A3(n113), .ZN(n137) );
  OR3XD1BWP12T U128 ( .A1(output_shuffle), .A2(n135), .A3(n137), .Z(
        output_valid) );
  NR3D0BWP12T U129 ( .A1(n127), .A2(write_ready), .A3(output_valid), .ZN(n118)
         );
  CKND2D0BWP12T U130 ( .A1(n118), .A2(n114), .ZN(direct_or_delayed_din[0]) );
  NR2D0BWP12T U131 ( .A1(n123), .A2(write_ready), .ZN(n117) );
  IND3D0BWP12T U132 ( .A1(output_valid), .B1(n117), .B2(n122), .ZN(
        fsm_write_control) );
  OR3XD0BWP12T U133 ( .A1(n123), .A2(n127), .A3(output_valid), .Z(
        mem_read_enable) );
  IND3D0BWP12T U134 ( .A1(mem_read_enable), .B1(n126), .B2(n116), .ZN(
        old_or_new_byte_remainder) );
  CKND2D0BWP12T U135 ( .A1(n122), .A2(n121), .ZN(mem_write_enable) );
  IND2D1BWP12T U136 ( .A1(mem_write_enable), .B1(n117), .ZN(n134) );
  OR3XD1BWP12T U137 ( .A1(output_shuffle), .A2(n137), .A3(n134), .Z(
        third_byte_out_select[1]) );
  INVD1BWP12T U138 ( .I(fsm_write_control), .ZN(n120) );
  INVD1BWP12T U139 ( .I(n120), .ZN(direct_or_delayed_din[1]) );
  INVD1BWP12T U140 ( .I(n118), .ZN(modified_or_original_address) );
  CKBD1BWP12T U141 ( .I(old_or_new_byte_remainder), .Z(
        added_or_delayed_address) );
  INVD1BWP12T U142 ( .I(is_signed_fsm), .ZN(n119) );
  AO21D1BWP12T U143 ( .A1(n135), .A2(n119), .B(n134), .Z(
        third_byte_out_select[0]) );
  INVD1BWP12T U144 ( .I(n120), .ZN(fsm_read_control) );
  INVD1BWP12T U145 ( .I(n120), .ZN(busy) );
  AOI21D1BWP12T U146 ( .A1(n122), .A2(n128), .B(reset), .ZN(N35) );
  INVD1BWP12T U147 ( .I(n129), .ZN(n124) );
  TPAOI21D0BWP12T U148 ( .A1(n130), .A2(n124), .B(n123), .ZN(n125) );
  OAI32D1BWP12T U149 ( .A1(reset), .A2(state[1]), .A3(n126), .B1(n125), .B2(
        reset), .ZN(N34) );
  CKND2D1BWP12T U150 ( .A1(n127), .A2(load), .ZN(n133) );
  OAI32D1BWP12T U151 ( .A1(reset), .A2(n133), .A3(n129), .B1(n128), .B2(reset), 
        .ZN(N32) );
  AOI21D1BWP12T U152 ( .A1(n135), .A2(is_signed_fsm), .B(n134), .ZN(n136) );
  IND2D1BWP12T U153 ( .A1(output_shuffle), .B1(n136), .ZN(
        first_two_bytes_out_select[1]) );
  IOA21D1BWP12T U154 ( .A1(is_signed_fsm), .A2(n137), .B(n136), .ZN(
        first_two_bytes_out_select[0]) );
endmodule

