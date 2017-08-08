
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
  wire   n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16,
         n17, n18, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58,
         n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, n70, n71, n72,
         n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84, n85, n86,
         n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98, n99, n100,
         n101, n102, n103, n104, n105, n106, n107, n108, n109, n110, n111,
         n112, n113, n114, n115, n116, n117, n118, n119, n120, n121, n122,
         n123, n124, n125, n126, n127, n128, n129, n130, n131, n132, n133,
         n134, n135, n136, n137, n138, n139, n140, n141, n142, n143, n144,
         n145, n146, n147, n148, n149, n150, n151, n152, n153, n154, n155,
         n156, n157, n158, n159, n160, n161, n162, n163, n164, n165;
  wire   [1:0] currentState;
  wire   [1:0] nextState;
  wire   [15:0] instruction;

  DFCNQD1BWP12T currentState_reg_0_ ( .D(nextState[0]), .CP(clk), .CDN(n165), 
        .Q(currentState[0]) );
  DFCNQD1BWP12T currentState_reg_1_ ( .D(nextState[1]), .CP(clk), .CDN(n165), 
        .Q(currentState[1]) );
  AOI22D0BWP12T U13 ( .A1(n17), .A2(instruction_in[0]), .B1(instruction_out[0]), .B2(n16), .ZN(n1) );
  AOI22D0BWP12T U17 ( .A1(n17), .A2(instruction_in[1]), .B1(instruction_out[1]), .B2(n16), .ZN(n2) );
  AOI22D0BWP12T U21 ( .A1(n17), .A2(instruction_in[2]), .B1(instruction_out[2]), .B2(n16), .ZN(n3) );
  AOI22D0BWP12T U25 ( .A1(n17), .A2(instruction_in[3]), .B1(instruction_out[3]), .B2(n16), .ZN(n4) );
  AOI22D0BWP12T U29 ( .A1(n17), .A2(instruction_in[4]), .B1(instruction_out[4]), .B2(n16), .ZN(n5) );
  AOI22D0BWP12T U33 ( .A1(n17), .A2(instruction_in[5]), .B1(instruction_out[5]), .B2(n16), .ZN(n6) );
  AOI22D0BWP12T U37 ( .A1(n17), .A2(instruction_in[6]), .B1(instruction_out[6]), .B2(n16), .ZN(n7) );
  AOI22D0BWP12T U41 ( .A1(n17), .A2(instruction_in[7]), .B1(instruction_out[7]), .B2(n16), .ZN(n8) );
  AOI22D0BWP12T U45 ( .A1(n17), .A2(instruction_in[8]), .B1(instruction_out[8]), .B2(n16), .ZN(n9) );
  AOI22D0BWP12T U49 ( .A1(n17), .A2(instruction_in[9]), .B1(instruction_out[9]), .B2(n16), .ZN(n10) );
  AOI22D0BWP12T U53 ( .A1(n17), .A2(instruction_in[10]), .B1(
        instruction_out[10]), .B2(n16), .ZN(n11) );
  AOI22D0BWP12T U58 ( .A1(n17), .A2(instruction_in[11]), .B1(
        instruction_out[11]), .B2(n16), .ZN(n12) );
  AOI22D0BWP12T U62 ( .A1(n17), .A2(instruction_in[12]), .B1(
        instruction_out[12]), .B2(n16), .ZN(n13) );
  AOI22D0BWP12T U66 ( .A1(n17), .A2(instruction_in[13]), .B1(
        instruction_out[13]), .B2(n16), .ZN(n14) );
  AOI22D0BWP12T U70 ( .A1(n17), .A2(instruction_in[14]), .B1(
        instruction_out[14]), .B2(n16), .ZN(n15) );
  AOI22D0BWP12T U74 ( .A1(n17), .A2(instruction_in[15]), .B1(
        instruction_out[15]), .B2(n16), .ZN(n18) );
  DFCSNQD1BWP12T instruction_out_reg_12_ ( .D(instruction[12]), .CP(clk), 
        .CDN(n72), .SDN(n71), .Q(instruction_out[12]) );
  DFCSNQD1BWP12T instruction_out_reg_11_ ( .D(instruction[11]), .CP(clk), 
        .CDN(n70), .SDN(n69), .Q(instruction_out[11]) );
  DFCSNQD1BWP12T instruction_out_reg_10_ ( .D(instruction[10]), .CP(clk), 
        .CDN(n68), .SDN(n67), .Q(instruction_out[10]) );
  DFCSNQD1BWP12T instruction_out_reg_15_ ( .D(instruction[15]), .CP(clk), 
        .CDN(n78), .SDN(n77), .Q(instruction_out[15]) );
  DFCSNQD1BWP12T instruction_out_reg_14_ ( .D(instruction[14]), .CP(clk), 
        .CDN(n76), .SDN(n75), .Q(instruction_out[14]) );
  DFCSNQD1BWP12T instruction_out_reg_13_ ( .D(instruction[13]), .CP(clk), 
        .CDN(n74), .SDN(n73), .Q(instruction_out[13]) );
  DFCSNQD1BWP12T instruction_out_reg_9_ ( .D(instruction[9]), .CP(clk), .CDN(
        n66), .SDN(n65), .Q(instruction_out[9]) );
  DFCSNQD1BWP12T instruction_out_reg_8_ ( .D(instruction[8]), .CP(clk), .CDN(
        n64), .SDN(n63), .Q(instruction_out[8]) );
  DFCSNQD1BWP12T instruction_out_reg_7_ ( .D(instruction[7]), .CP(clk), .CDN(
        n62), .SDN(n61), .Q(instruction_out[7]) );
  DFCSNQD1BWP12T instruction_out_reg_6_ ( .D(instruction[6]), .CP(clk), .CDN(
        n60), .SDN(n59), .Q(instruction_out[6]) );
  DFCSNQD1BWP12T instruction_out_reg_5_ ( .D(instruction[5]), .CP(clk), .CDN(
        n58), .SDN(n57), .Q(instruction_out[5]) );
  DFCSNQD1BWP12T instruction_out_reg_4_ ( .D(instruction[4]), .CP(clk), .CDN(
        n56), .SDN(n55), .Q(instruction_out[4]) );
  DFCSNQD1BWP12T instruction_out_reg_3_ ( .D(instruction[3]), .CP(clk), .CDN(
        n54), .SDN(n53), .Q(instruction_out[3]) );
  DFCSNQD1BWP12T instruction_out_reg_2_ ( .D(instruction[2]), .CP(clk), .CDN(
        n52), .SDN(n51), .Q(instruction_out[2]) );
  DFCSNQD1BWP12T instruction_out_reg_1_ ( .D(instruction[1]), .CP(clk), .CDN(
        n50), .SDN(n49), .Q(instruction_out[1]) );
  DFCSNQD1BWP12T instruction_out_reg_0_ ( .D(instruction[0]), .CP(clk), .CDN(
        n48), .SDN(n47), .Q(instruction_out[0]) );
  ND2D1BWP12T U114 ( .A1(n160), .A2(n102), .ZN(n97) );
  ND2D1BWP12T U115 ( .A1(currentState[0]), .A2(currentState[1]), .ZN(n102) );
  IOA21D1BWP12T U116 ( .A1(n101), .A2(stall_memory), .B(n97), .ZN(n16) );
  NR2D1BWP12T U117 ( .A1(stall_memory), .A2(n102), .ZN(n17) );
  IND2D0BWP12T U118 ( .A1(currentState[1]), .B1(n98), .ZN(n160) );
  IOA21D0BWP12T U119 ( .A1(n160), .A2(stall_memory), .B(n103), .ZN(
        nextState[0]) );
  INVD1BWP12T U120 ( .I(currentState[0]), .ZN(n98) );
  INVD1BWP12T U121 ( .I(pc_in[3]), .ZN(n92) );
  INVD1BWP12T U122 ( .I(pc_in[2]), .ZN(n93) );
  ND2D1BWP12T U123 ( .A1(n92), .A2(n93), .ZN(n95) );
  NR2D1BWP12T U124 ( .A1(pc_in[4]), .A2(n95), .ZN(n94) );
  INVD1BWP12T U125 ( .I(pc_in[5]), .ZN(n91) );
  ND2D1BWP12T U126 ( .A1(n94), .A2(n91), .ZN(n90) );
  NR2D1BWP12T U127 ( .A1(pc_in[6]), .A2(n90), .ZN(n88) );
  INVD1BWP12T U128 ( .I(pc_in[7]), .ZN(n87) );
  ND2D1BWP12T U129 ( .A1(n88), .A2(n87), .ZN(n86) );
  NR2D1BWP12T U130 ( .A1(pc_in[8]), .A2(n86), .ZN(n84) );
  INVD1BWP12T U131 ( .I(pc_in[9]), .ZN(n83) );
  ND2D1BWP12T U132 ( .A1(n84), .A2(n83), .ZN(n82) );
  NR2D1BWP12T U133 ( .A1(pc_in[10]), .A2(n82), .ZN(n81) );
  AOI21D1BWP12T U134 ( .A1(n82), .A2(pc_in[10]), .B(n81), .ZN(n79) );
  NR2D0BWP12T U135 ( .A1(n97), .A2(n79), .ZN(address[10]) );
  NR2D1BWP12T U136 ( .A1(pc_in[11]), .A2(n81), .ZN(n80) );
  AOI211D0BWP12T U137 ( .A1(pc_in[11]), .A2(n81), .B(n97), .C(n80), .ZN(
        address[11]) );
  OAI32D0BWP12T U138 ( .A1(n97), .A2(n84), .A3(n83), .B1(n82), .B2(n97), .ZN(
        address[9]) );
  AOI21D1BWP12T U139 ( .A1(n86), .A2(pc_in[8]), .B(n84), .ZN(n85) );
  NR2D0BWP12T U140 ( .A1(n97), .A2(n85), .ZN(address[8]) );
  INVD1BWP12T U141 ( .I(n6), .ZN(instruction[5]) );
  CKND2D0BWP12T U142 ( .A1(reset), .A2(instruction[5]), .ZN(n57) );
  INVD1BWP12T U143 ( .I(n4), .ZN(instruction[3]) );
  CKND2D0BWP12T U144 ( .A1(reset), .A2(instruction[3]), .ZN(n53) );
  INVD1BWP12T U145 ( .I(n3), .ZN(instruction[2]) );
  CKND2D0BWP12T U146 ( .A1(reset), .A2(instruction[2]), .ZN(n51) );
  CKND2D1BWP12T U147 ( .A1(n13), .A2(n160), .ZN(instruction[12]) );
  INVD1BWP12T U148 ( .I(reset), .ZN(n165) );
  OR2XD0BWP12T U149 ( .A1(instruction[12]), .A2(n165), .Z(n72) );
  INVD1BWP12T U150 ( .I(n8), .ZN(instruction[7]) );
  CKND2D0BWP12T U151 ( .A1(reset), .A2(instruction[7]), .ZN(n61) );
  INVD1BWP12T U152 ( .I(n5), .ZN(instruction[4]) );
  CKND2D0BWP12T U153 ( .A1(reset), .A2(instruction[4]), .ZN(n55) );
  INVD1BWP12T U154 ( .I(n9), .ZN(instruction[8]) );
  CKND2D0BWP12T U155 ( .A1(reset), .A2(instruction[8]), .ZN(n63) );
  CKND2D1BWP12T U156 ( .A1(n12), .A2(n160), .ZN(instruction[11]) );
  OR2XD0BWP12T U157 ( .A1(instruction[11]), .A2(n165), .Z(n70) );
  INVD1BWP12T U158 ( .I(n1), .ZN(instruction[0]) );
  CKND2D0BWP12T U159 ( .A1(reset), .A2(instruction[0]), .ZN(n47) );
  INVD1BWP12T U160 ( .I(n2), .ZN(instruction[1]) );
  CKND2D0BWP12T U161 ( .A1(reset), .A2(instruction[1]), .ZN(n49) );
  INVD1BWP12T U162 ( .I(n7), .ZN(instruction[6]) );
  CKND2D0BWP12T U163 ( .A1(reset), .A2(instruction[6]), .ZN(n59) );
  CKND2D0BWP12T U164 ( .A1(reset), .A2(instruction[12]), .ZN(n71) );
  CKND2D1BWP12T U165 ( .A1(n11), .A2(n160), .ZN(instruction[10]) );
  CKND2D0BWP12T U166 ( .A1(reset), .A2(instruction[10]), .ZN(n67) );
  INVD1BWP12T U167 ( .I(n10), .ZN(instruction[9]) );
  CKND2D0BWP12T U168 ( .A1(reset), .A2(instruction[9]), .ZN(n65) );
  INVD1BWP12T U169 ( .I(n18), .ZN(instruction[15]) );
  CKND2D0BWP12T U170 ( .A1(reset), .A2(instruction[15]), .ZN(n77) );
  INVD1BWP12T U171 ( .I(n15), .ZN(instruction[14]) );
  CKND2D0BWP12T U172 ( .A1(reset), .A2(instruction[14]), .ZN(n75) );
  INVD1BWP12T U173 ( .I(n14), .ZN(instruction[13]) );
  CKND2D0BWP12T U174 ( .A1(reset), .A2(instruction[13]), .ZN(n73) );
  OR2XD0BWP12T U175 ( .A1(instruction[10]), .A2(n165), .Z(n68) );
  CKND2D0BWP12T U176 ( .A1(reset), .A2(instruction[11]), .ZN(n69) );
  CKND2D0BWP12T U177 ( .A1(reset), .A2(n1), .ZN(n48) );
  CKND2D0BWP12T U178 ( .A1(reset), .A2(n2), .ZN(n50) );
  CKND2D0BWP12T U179 ( .A1(reset), .A2(n7), .ZN(n60) );
  CKND2D0BWP12T U180 ( .A1(reset), .A2(n3), .ZN(n52) );
  CKND2D0BWP12T U181 ( .A1(reset), .A2(n18), .ZN(n78) );
  CKND2D0BWP12T U182 ( .A1(reset), .A2(n4), .ZN(n54) );
  CKND2D0BWP12T U183 ( .A1(reset), .A2(n14), .ZN(n74) );
  CKND2D0BWP12T U184 ( .A1(reset), .A2(n15), .ZN(n76) );
  CKND2D0BWP12T U185 ( .A1(reset), .A2(n8), .ZN(n62) );
  CKND2D0BWP12T U186 ( .A1(reset), .A2(n5), .ZN(n56) );
  CKND2D0BWP12T U187 ( .A1(reset), .A2(n9), .ZN(n64) );
  CKND2D0BWP12T U188 ( .A1(reset), .A2(n6), .ZN(n58) );
  CKND2D0BWP12T U189 ( .A1(reset), .A2(n10), .ZN(n66) );
  OAI32D0BWP12T U190 ( .A1(n97), .A2(n88), .A3(n87), .B1(n86), .B2(n97), .ZN(
        address[7]) );
  AOI21D1BWP12T U191 ( .A1(n90), .A2(pc_in[6]), .B(n88), .ZN(n89) );
  NR2D0BWP12T U192 ( .A1(n97), .A2(n89), .ZN(address[6]) );
  NR2D0BWP12T U193 ( .A1(pc_in[2]), .A2(n97), .ZN(address[2]) );
  OAI32D0BWP12T U194 ( .A1(n97), .A2(n94), .A3(n91), .B1(n90), .B2(n97), .ZN(
        address[5]) );
  INVD1BWP12T U195 ( .I(pc_in[1]), .ZN(n162) );
  NR2D0BWP12T U196 ( .A1(n97), .A2(n162), .ZN(address[1]) );
  OAI21D1BWP12T U197 ( .A1(n93), .A2(n92), .B(n95), .ZN(n161) );
  INR2D0BWP12T U198 ( .A1(n161), .B1(n97), .ZN(address[3]) );
  INVD1BWP12T U199 ( .I(pc_in[0]), .ZN(n163) );
  NR2D0BWP12T U200 ( .A1(n97), .A2(n163), .ZN(address[0]) );
  INVD0BWP12T U201 ( .I(n102), .ZN(n101) );
  CKND2D0BWP12T U202 ( .A1(currentState[0]), .A2(stall_decoder_in), .ZN(n103)
         );
  AOI21D1BWP12T U203 ( .A1(n95), .A2(pc_in[4]), .B(n94), .ZN(n96) );
  NR2D0BWP12T U204 ( .A1(n97), .A2(n96), .ZN(address[4]) );
  NR2D0BWP12T U205 ( .A1(stall_memory), .A2(n98), .ZN(n99) );
  MOAI22D0BWP12T U206 ( .A1(n99), .A2(currentState[1]), .B1(n99), .B2(
        stall_decoder_in), .ZN(n100) );
  TPOAI21D0BWP12T U207 ( .A1(reset), .A2(n160), .B(n100), .ZN(nextState[1]) );
  CKND2D0BWP12T U208 ( .A1(pc_in[2]), .A2(n160), .ZN(pc_out[2]) );
  AOI21D0BWP12T U209 ( .A1(stall_memory), .A2(n160), .B(n101), .ZN(read_enable) );
  OR2XD0BWP12T U210 ( .A1(n103), .A2(currentState[1]), .Z(pc_en) );
  CKND2D0BWP12T U211 ( .A1(pc_in[30]), .A2(n160), .ZN(n159) );
  IND2D1BWP12T U212 ( .A1(pc_out[2]), .B1(pc_in[3]), .ZN(n154) );
  INR2D1BWP12T U213 ( .A1(pc_in[4]), .B1(n154), .ZN(n152) );
  ND2D1BWP12T U214 ( .A1(pc_in[5]), .A2(n152), .ZN(n150) );
  INR2D1BWP12T U215 ( .A1(pc_in[6]), .B1(n150), .ZN(n148) );
  ND2D1BWP12T U216 ( .A1(pc_in[7]), .A2(n148), .ZN(n146) );
  INR2D1BWP12T U217 ( .A1(pc_in[8]), .B1(n146), .ZN(n144) );
  ND2D1BWP12T U218 ( .A1(pc_in[9]), .A2(n144), .ZN(n142) );
  INR2D1BWP12T U219 ( .A1(pc_in[10]), .B1(n142), .ZN(n140) );
  ND2D1BWP12T U220 ( .A1(pc_in[11]), .A2(n140), .ZN(n138) );
  INR2D1BWP12T U221 ( .A1(pc_in[12]), .B1(n138), .ZN(n136) );
  ND2D1BWP12T U222 ( .A1(n136), .A2(pc_in[13]), .ZN(n156) );
  INR2D1BWP12T U223 ( .A1(pc_in[14]), .B1(n156), .ZN(n132) );
  ND2D1BWP12T U224 ( .A1(n132), .A2(pc_in[15]), .ZN(n130) );
  INR2D1BWP12T U225 ( .A1(pc_in[16]), .B1(n130), .ZN(n128) );
  ND2D1BWP12T U226 ( .A1(n128), .A2(pc_in[17]), .ZN(n126) );
  INR2D1BWP12T U227 ( .A1(pc_in[18]), .B1(n126), .ZN(n124) );
  ND2D1BWP12T U228 ( .A1(n124), .A2(pc_in[19]), .ZN(n122) );
  INR2D1BWP12T U229 ( .A1(pc_in[20]), .B1(n122), .ZN(n120) );
  ND2D1BWP12T U230 ( .A1(n120), .A2(pc_in[21]), .ZN(n118) );
  INR2D1BWP12T U231 ( .A1(pc_in[22]), .B1(n118), .ZN(n116) );
  ND2D1BWP12T U232 ( .A1(n116), .A2(pc_in[23]), .ZN(n114) );
  INR2D1BWP12T U233 ( .A1(pc_in[24]), .B1(n114), .ZN(n112) );
  ND2D1BWP12T U234 ( .A1(n112), .A2(pc_in[25]), .ZN(n110) );
  INR2D1BWP12T U235 ( .A1(pc_in[26]), .B1(n110), .ZN(n108) );
  ND2D1BWP12T U236 ( .A1(n108), .A2(pc_in[27]), .ZN(n106) );
  INR2D1BWP12T U237 ( .A1(pc_in[28]), .B1(n106), .ZN(n134) );
  ND2D1BWP12T U238 ( .A1(n134), .A2(pc_in[29]), .ZN(n158) );
  NR2D1BWP12T U239 ( .A1(n159), .A2(n158), .ZN(n157) );
  CKND2D0BWP12T U240 ( .A1(pc_in[31]), .A2(n160), .ZN(n104) );
  MOAI22D0BWP12T U241 ( .A1(n157), .A2(n104), .B1(n157), .B2(n104), .ZN(
        pc_out[31]) );
  CKND2D0BWP12T U242 ( .A1(pc_in[28]), .A2(n160), .ZN(n105) );
  MAOI22D0BWP12T U243 ( .A1(n106), .A2(n105), .B1(n106), .B2(n105), .ZN(
        pc_out[28]) );
  CKND2D0BWP12T U244 ( .A1(pc_in[27]), .A2(n160), .ZN(n107) );
  MOAI22D0BWP12T U245 ( .A1(n108), .A2(n107), .B1(n108), .B2(n107), .ZN(
        pc_out[27]) );
  CKND2D0BWP12T U246 ( .A1(pc_in[26]), .A2(n160), .ZN(n109) );
  MAOI22D0BWP12T U247 ( .A1(n110), .A2(n109), .B1(n110), .B2(n109), .ZN(
        pc_out[26]) );
  CKND2D0BWP12T U248 ( .A1(pc_in[25]), .A2(n160), .ZN(n111) );
  MOAI22D0BWP12T U249 ( .A1(n112), .A2(n111), .B1(n112), .B2(n111), .ZN(
        pc_out[25]) );
  CKND2D0BWP12T U250 ( .A1(pc_in[24]), .A2(n160), .ZN(n113) );
  MAOI22D0BWP12T U251 ( .A1(n114), .A2(n113), .B1(n114), .B2(n113), .ZN(
        pc_out[24]) );
  CKND2D0BWP12T U252 ( .A1(pc_in[23]), .A2(n160), .ZN(n115) );
  MOAI22D0BWP12T U253 ( .A1(n116), .A2(n115), .B1(n116), .B2(n115), .ZN(
        pc_out[23]) );
  CKND2D0BWP12T U254 ( .A1(pc_in[22]), .A2(n160), .ZN(n117) );
  MAOI22D0BWP12T U255 ( .A1(n118), .A2(n117), .B1(n118), .B2(n117), .ZN(
        pc_out[22]) );
  CKND2D0BWP12T U256 ( .A1(pc_in[21]), .A2(n160), .ZN(n119) );
  MOAI22D0BWP12T U257 ( .A1(n120), .A2(n119), .B1(n120), .B2(n119), .ZN(
        pc_out[21]) );
  CKND2D0BWP12T U258 ( .A1(pc_in[20]), .A2(n160), .ZN(n121) );
  MAOI22D0BWP12T U259 ( .A1(n122), .A2(n121), .B1(n122), .B2(n121), .ZN(
        pc_out[20]) );
  CKND2D0BWP12T U260 ( .A1(pc_in[19]), .A2(n160), .ZN(n123) );
  MOAI22D0BWP12T U261 ( .A1(n124), .A2(n123), .B1(n124), .B2(n123), .ZN(
        pc_out[19]) );
  CKND2D0BWP12T U262 ( .A1(pc_in[18]), .A2(n160), .ZN(n125) );
  MAOI22D0BWP12T U263 ( .A1(n126), .A2(n125), .B1(n126), .B2(n125), .ZN(
        pc_out[18]) );
  CKND2D0BWP12T U264 ( .A1(pc_in[17]), .A2(n160), .ZN(n127) );
  MOAI22D0BWP12T U265 ( .A1(n128), .A2(n127), .B1(n128), .B2(n127), .ZN(
        pc_out[17]) );
  CKND2D0BWP12T U266 ( .A1(pc_in[16]), .A2(n160), .ZN(n129) );
  MAOI22D0BWP12T U267 ( .A1(n130), .A2(n129), .B1(n130), .B2(n129), .ZN(
        pc_out[16]) );
  CKND2D0BWP12T U268 ( .A1(pc_in[15]), .A2(n160), .ZN(n131) );
  MOAI22D0BWP12T U269 ( .A1(n132), .A2(n131), .B1(n132), .B2(n131), .ZN(
        pc_out[15]) );
  CKND2D0BWP12T U270 ( .A1(pc_in[29]), .A2(n160), .ZN(n133) );
  MOAI22D0BWP12T U271 ( .A1(n134), .A2(n133), .B1(n134), .B2(n133), .ZN(
        pc_out[29]) );
  CKND2D0BWP12T U272 ( .A1(pc_in[13]), .A2(n160), .ZN(n135) );
  MOAI22D0BWP12T U273 ( .A1(n136), .A2(n135), .B1(n136), .B2(n135), .ZN(
        pc_out[13]) );
  CKND2D0BWP12T U274 ( .A1(pc_in[12]), .A2(n160), .ZN(n137) );
  MAOI22D0BWP12T U275 ( .A1(n138), .A2(n137), .B1(n138), .B2(n137), .ZN(
        pc_out[12]) );
  CKND2D0BWP12T U276 ( .A1(pc_in[11]), .A2(n160), .ZN(n139) );
  MOAI22D0BWP12T U277 ( .A1(n140), .A2(n139), .B1(n140), .B2(n139), .ZN(
        pc_out[11]) );
  CKND2D0BWP12T U278 ( .A1(pc_in[10]), .A2(n160), .ZN(n141) );
  MAOI22D0BWP12T U279 ( .A1(n142), .A2(n141), .B1(n142), .B2(n141), .ZN(
        pc_out[10]) );
  CKND2D0BWP12T U280 ( .A1(pc_in[9]), .A2(n160), .ZN(n143) );
  MOAI22D0BWP12T U281 ( .A1(n144), .A2(n143), .B1(n144), .B2(n143), .ZN(
        pc_out[9]) );
  CKND2D0BWP12T U282 ( .A1(pc_in[8]), .A2(n160), .ZN(n145) );
  MAOI22D0BWP12T U283 ( .A1(n146), .A2(n145), .B1(n146), .B2(n145), .ZN(
        pc_out[8]) );
  CKND2D0BWP12T U284 ( .A1(pc_in[7]), .A2(n160), .ZN(n147) );
  MOAI22D0BWP12T U285 ( .A1(n148), .A2(n147), .B1(n148), .B2(n147), .ZN(
        pc_out[7]) );
  CKND2D0BWP12T U286 ( .A1(pc_in[6]), .A2(n160), .ZN(n149) );
  MAOI22D0BWP12T U287 ( .A1(n150), .A2(n149), .B1(n150), .B2(n149), .ZN(
        pc_out[6]) );
  CKND2D0BWP12T U288 ( .A1(pc_in[5]), .A2(n160), .ZN(n151) );
  MOAI22D0BWP12T U289 ( .A1(n152), .A2(n151), .B1(n152), .B2(n151), .ZN(
        pc_out[5]) );
  CKND2D0BWP12T U290 ( .A1(pc_in[4]), .A2(n160), .ZN(n153) );
  MAOI22D0BWP12T U291 ( .A1(n154), .A2(n153), .B1(n154), .B2(n153), .ZN(
        pc_out[4]) );
  CKND2D0BWP12T U292 ( .A1(pc_in[14]), .A2(n160), .ZN(n155) );
  MAOI22D0BWP12T U293 ( .A1(n156), .A2(n155), .B1(n156), .B2(n155), .ZN(
        pc_out[14]) );
  AOI21D1BWP12T U294 ( .A1(n159), .A2(n158), .B(n157), .ZN(pc_out[30]) );
  CKND0BWP12T U295 ( .I(n160), .ZN(n164) );
  NR2D1BWP12T U296 ( .A1(n164), .A2(n161), .ZN(pc_out[3]) );
  NR2D1BWP12T U297 ( .A1(n164), .A2(n162), .ZN(pc_out[1]) );
  NR2D1BWP12T U298 ( .A1(n164), .A2(n163), .ZN(pc_out[0]) );
endmodule

