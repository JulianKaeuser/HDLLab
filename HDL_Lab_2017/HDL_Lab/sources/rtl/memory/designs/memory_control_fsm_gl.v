
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
  wire   N32, N33, N34, N35, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42,
         n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56,
         n57, n58, n59, n60, n61, n62, n63, n68, n69, n70;
  wire   [3:0] state;

  DFXD1BWP12T state_reg_2_ ( .D(N34), .CP(clk), .Q(state[2]), .QN(n68) );
  DFXD1BWP12T state_reg_1_ ( .D(N33), .CP(clk), .Q(state[1]) );
  DFXD1BWP12T state_reg_3_ ( .D(N35), .CP(clk), .Q(state[3]), .QN(n69) );
  DFXD1BWP12T state_reg_0_ ( .D(N32), .CP(clk), .Q(state[0]), .QN(n70) );
  TIELBWP12T U51 ( .ZN(n33) );
  INVD1BWP12T U52 ( .I(n33), .ZN(mem_enable) );
  NR4D0BWP12T U53 ( .A1(state[1]), .A2(state[2]), .A3(state[0]), .A4(state[3]), 
        .ZN(n54) );
  ND2D1BWP12T U54 ( .A1(n55), .A2(n42), .ZN(n57) );
  ND2D1BWP12T U55 ( .A1(state[1]), .A2(n68), .ZN(n53) );
  NR2D1BWP12T U56 ( .A1(n70), .A2(n69), .ZN(n55) );
  IND3D1BWP12T U57 ( .A1(load), .B1(n54), .B2(store), .ZN(n56) );
  AOI31D1BWP12T U58 ( .A1(state[0]), .A2(n37), .A3(state[3]), .B(n45), .ZN(n52) );
  MOAI22D0BWP12T U59 ( .A1(word_type[1]), .A2(word_type[0]), .B1(word_type[1]), 
        .B2(word_type[0]), .ZN(n59) );
  CKND2D0BWP12T U60 ( .A1(state[0]), .A2(n69), .ZN(n34) );
  NR2D0BWP12T U61 ( .A1(n53), .A2(n34), .ZN(n45) );
  CKND0BWP12T U62 ( .I(n55), .ZN(n35) );
  OA222D0BWP12T U63 ( .A1(n35), .A2(n53), .B1(word_type[0]), .B2(n60), .C1(n56), .C2(word_type[1]), .Z(n36) );
  NR2D0BWP12T U64 ( .A1(reset), .A2(n36), .ZN(N33) );
  NR2XD0BWP12T U65 ( .A1(n68), .A2(state[1]), .ZN(n37) );
  CKND2D0BWP12T U66 ( .A1(n70), .A2(n69), .ZN(n38) );
  NR2D0BWP12T U67 ( .A1(n53), .A2(n38), .ZN(n44) );
  NR4D0BWP12T U68 ( .A1(state[1]), .A2(state[2]), .A3(state[3]), .A4(n70), 
        .ZN(n63) );
  NR2D1BWP12T U69 ( .A1(n44), .A2(n63), .ZN(n47) );
  INVD1BWP12T U70 ( .I(n37), .ZN(n39) );
  NR2D1BWP12T U71 ( .A1(n39), .A2(n38), .ZN(output_shuffle) );
  INVD1BWP12T U72 ( .I(output_shuffle), .ZN(n61) );
  ND2D1BWP12T U73 ( .A1(n47), .A2(n61), .ZN(output_valid) );
  NR2D0BWP12T U74 ( .A1(n54), .A2(output_valid), .ZN(n50) );
  ND2D1BWP12T U75 ( .A1(n39), .A2(n53), .ZN(n42) );
  AOI32D0BWP12T U76 ( .A1(state[2]), .A2(state[0]), .A3(state[1]), .B1(n42), 
        .B2(n70), .ZN(n40) );
  NR2D0BWP12T U77 ( .A1(n69), .A2(n40), .ZN(write_ready) );
  INVD1BWP12T U78 ( .I(write_ready), .ZN(n43) );
  ND2D1BWP12T U79 ( .A1(n50), .A2(n43), .ZN(modified_or_original_address) );
  INVD1BWP12T U80 ( .I(modified_or_original_address), .ZN(n41) );
  CKND2D0BWP12T U81 ( .A1(n52), .A2(n41), .ZN(old_or_new_byte_remainder) );
  CKND2D0BWP12T U82 ( .A1(n41), .A2(n53), .ZN(direct_or_delayed_din[0]) );
  CKND0BWP12T U83 ( .I(n45), .ZN(n49) );
  IND4D0BWP12T U84 ( .A1(output_valid), .B1(n49), .B2(n43), .B3(n57), .ZN(
        fsm_write_control) );
  IND2XD0BWP12T U85 ( .A1(n54), .B1(n57), .ZN(mem_write_enable) );
  INVD1BWP12T U86 ( .I(fsm_write_control), .ZN(n51) );
  INVD1BWP12T U87 ( .I(n51), .ZN(direct_or_delayed_din[1]) );
  CKBD1BWP12T U88 ( .I(old_or_new_byte_remainder), .Z(added_or_delayed_address) );
  INVD1BWP12T U89 ( .I(n44), .ZN(n48) );
  INVD1BWP12T U90 ( .I(is_signed_fsm), .ZN(n46) );
  TPNR3D0BWP12T U91 ( .A1(n45), .A2(write_ready), .A3(mem_write_enable), .ZN(
        n62) );
  OAI211D1BWP12T U92 ( .A1(n48), .A2(n46), .B(n62), .C(n61), .ZN(
        first_two_bytes_out_select[1]) );
  OAI21D1BWP12T U93 ( .A1(n47), .A2(n46), .B(n62), .ZN(
        first_two_bytes_out_select[0]) );
  OAI21D1BWP12T U94 ( .A1(n48), .A2(is_signed_fsm), .B(n62), .ZN(
        third_byte_out_select[0]) );
  ND2D1BWP12T U95 ( .A1(n50), .A2(n49), .ZN(mem_read_enable) );
  INVD1BWP12T U96 ( .I(n51), .ZN(fsm_read_control) );
  INVD1BWP12T U97 ( .I(n51), .ZN(busy) );
  OAI32D1BWP12T U98 ( .A1(reset), .A2(n56), .A3(n59), .B1(n52), .B2(reset), 
        .ZN(N34) );
  CKND2D1BWP12T U99 ( .A1(n54), .A2(load), .ZN(n60) );
  AO21D1BWP12T U100 ( .A1(word_type[1]), .A2(word_type[0]), .B(n56), .Z(n58)
         );
  AOI21D1BWP12T U101 ( .A1(n57), .A2(n58), .B(reset), .ZN(N35) );
  OAI32D1BWP12T U102 ( .A1(reset), .A2(n60), .A3(n59), .B1(n58), .B2(reset), 
        .ZN(N32) );
  IND3D1BWP12T U103 ( .A1(n63), .B1(n62), .B2(n61), .ZN(
        third_byte_out_select[1]) );
endmodule

