
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
  wire   n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n12, n13, n14, n15, n16, n17,
         n18, n19, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55,
         n56, n57, n58, n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, n69,
         n70, n71, n72, n73, n74, n75, n77, n78, n79, n80, n81, n82, n83, n84,
         n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98,
         n99, n100, n101, n102, n103, n104, n105, n106, n107, n108, n109, n110,
         n111, n112, n113, n114, n115, n116, n117, n118, n119, n120, n121,
         n122, n123, n124, n125, n126, n127, n128, n129, n130, n131, n132,
         n133, n134, n135, n136, n137, n138, n139, n140, n141, n142, n143;
  wire   [1:0] currentState;
  wire   [1:0] nextState;
  wire   [15:0] instruction;

  DFCNQD1BWP12T currentState_reg_1_ ( .D(nextState[1]), .CP(clk), .CDN(n143), 
        .Q(currentState[1]) );
  AOI22D0BWP12T U9 ( .A1(n17), .A2(instruction_out[0]), .B1(n19), .B2(
        instruction_in[0]), .ZN(n1) );
  AOI22D0BWP12T U13 ( .A1(n17), .A2(instruction_out[1]), .B1(n19), .B2(
        instruction_in[1]), .ZN(n2) );
  AOI22D0BWP12T U17 ( .A1(n17), .A2(instruction_out[2]), .B1(n19), .B2(
        instruction_in[2]), .ZN(n3) );
  AOI22D0BWP12T U21 ( .A1(n17), .A2(instruction_out[3]), .B1(n19), .B2(
        instruction_in[3]), .ZN(n4) );
  AOI22D0BWP12T U25 ( .A1(n17), .A2(instruction_out[4]), .B1(n19), .B2(
        instruction_in[4]), .ZN(n5) );
  AOI22D0BWP12T U29 ( .A1(n17), .A2(instruction_out[5]), .B1(n19), .B2(
        instruction_in[5]), .ZN(n6) );
  AOI22D0BWP12T U33 ( .A1(n17), .A2(instruction_out[6]), .B1(n19), .B2(
        instruction_in[6]), .ZN(n7) );
  AOI22D0BWP12T U37 ( .A1(n17), .A2(instruction_out[7]), .B1(n19), .B2(
        instruction_in[7]), .ZN(n8) );
  AOI22D0BWP12T U41 ( .A1(n17), .A2(instruction_out[8]), .B1(n19), .B2(
        instruction_in[8]), .ZN(n9) );
  AOI22D0BWP12T U45 ( .A1(n17), .A2(instruction_out[9]), .B1(n19), .B2(
        instruction_in[9]), .ZN(n10) );
  AOI22D0BWP12T U49 ( .A1(n17), .A2(instruction_out[10]), .B1(n19), .B2(
        instruction_in[10]), .ZN(n12) );
  AOI22D0BWP12T U54 ( .A1(n17), .A2(instruction_out[11]), .B1(n19), .B2(
        instruction_in[11]), .ZN(n13) );
  AOI22D0BWP12T U58 ( .A1(n17), .A2(instruction_out[12]), .B1(n19), .B2(
        instruction_in[12]), .ZN(n14) );
  AOI22D0BWP12T U62 ( .A1(n17), .A2(instruction_out[13]), .B1(n19), .B2(
        instruction_in[13]), .ZN(n15) );
  AOI22D0BWP12T U66 ( .A1(n17), .A2(instruction_out[14]), .B1(n19), .B2(
        instruction_in[14]), .ZN(n16) );
  AOI22D0BWP12T U70 ( .A1(n17), .A2(instruction_out[15]), .B1(n19), .B2(
        instruction_in[15]), .ZN(n18) );
  DFCSNQD1BWP12T instruction_out_reg_12_ ( .D(instruction[12]), .CP(clk), 
        .CDN(n69), .SDN(n68), .Q(instruction_out[12]) );
  DFCSNQD1BWP12T instruction_out_reg_11_ ( .D(instruction[11]), .CP(clk), 
        .CDN(n67), .SDN(n66), .Q(instruction_out[11]) );
  DFCSNQD1BWP12T instruction_out_reg_10_ ( .D(instruction[10]), .CP(clk), 
        .CDN(n65), .SDN(n64), .Q(instruction_out[10]) );
  DFCSNQD1BWP12T instruction_out_reg_15_ ( .D(instruction[15]), .CP(clk), 
        .CDN(n75), .SDN(n74), .Q(instruction_out[15]) );
  DFCSNQD1BWP12T instruction_out_reg_14_ ( .D(instruction[14]), .CP(clk), 
        .CDN(n73), .SDN(n72), .Q(instruction_out[14]) );
  DFCSNQD1BWP12T instruction_out_reg_13_ ( .D(instruction[13]), .CP(clk), 
        .CDN(n71), .SDN(n70), .Q(instruction_out[13]) );
  DFCSNQD1BWP12T instruction_out_reg_9_ ( .D(instruction[9]), .CP(clk), .CDN(
        n63), .SDN(n62), .Q(instruction_out[9]) );
  DFCSNQD1BWP12T instruction_out_reg_8_ ( .D(instruction[8]), .CP(clk), .CDN(
        n61), .SDN(n60), .Q(instruction_out[8]) );
  DFCSNQD1BWP12T instruction_out_reg_7_ ( .D(instruction[7]), .CP(clk), .CDN(
        n59), .SDN(n58), .Q(instruction_out[7]) );
  DFCSNQD1BWP12T instruction_out_reg_6_ ( .D(instruction[6]), .CP(clk), .CDN(
        n57), .SDN(n56), .Q(instruction_out[6]) );
  DFCSNQD1BWP12T instruction_out_reg_5_ ( .D(instruction[5]), .CP(clk), .CDN(
        n55), .SDN(n54), .Q(instruction_out[5]) );
  DFCSNQD1BWP12T instruction_out_reg_4_ ( .D(instruction[4]), .CP(clk), .CDN(
        n53), .SDN(n52), .Q(instruction_out[4]) );
  DFCSNQD1BWP12T instruction_out_reg_3_ ( .D(instruction[3]), .CP(clk), .CDN(
        n51), .SDN(n50), .Q(instruction_out[3]) );
  DFCSNQD1BWP12T instruction_out_reg_2_ ( .D(instruction[2]), .CP(clk), .CDN(
        n49), .SDN(n48), .Q(instruction_out[2]) );
  DFCSNQD1BWP12T instruction_out_reg_1_ ( .D(instruction[1]), .CP(clk), .CDN(
        n47), .SDN(n46), .Q(instruction_out[1]) );
  DFCSNQD1BWP12T instruction_out_reg_0_ ( .D(instruction[0]), .CP(clk), .CDN(
        n45), .SDN(n44), .Q(instruction_out[0]) );
  DFSNXD1BWP12T currentState_reg_0_ ( .D(nextState[0]), .CP(clk), .SDN(n143), 
        .Q(currentState[0]), .QN(n142) );
  ND2D1BWP12T U144 ( .A1(n142), .A2(currentState[1]), .ZN(n127) );
  INVD1BWP12T U145 ( .I(n17), .ZN(n132) );
  INVD1BWP12T U146 ( .I(n127), .ZN(n19) );
  NR2D1BWP12T U147 ( .A1(currentState[0]), .A2(currentState[1]), .ZN(n17) );
  INVD1BWP12T U148 ( .I(reset), .ZN(n143) );
  NR3D1BWP12T U149 ( .A1(stall_decoder_in), .A2(stall_memory), .A3(n132), .ZN(
        nextState[1]) );
  ND2D1BWP12T U150 ( .A1(pc_in[2]), .A2(pc_in[3]), .ZN(n137) );
  INVD1BWP12T U151 ( .I(pc_in[4]), .ZN(n135) );
  NR2D1BWP12T U152 ( .A1(n137), .A2(n135), .ZN(n134) );
  ND2D1BWP12T U153 ( .A1(n134), .A2(pc_in[5]), .ZN(n133) );
  INVD1BWP12T U154 ( .I(pc_in[6]), .ZN(n126) );
  NR2D1BWP12T U155 ( .A1(n133), .A2(n126), .ZN(n125) );
  ND2D1BWP12T U156 ( .A1(n125), .A2(pc_in[7]), .ZN(n122) );
  INVD1BWP12T U157 ( .I(pc_in[8]), .ZN(n119) );
  NR2D1BWP12T U158 ( .A1(n122), .A2(n119), .ZN(n118) );
  ND2D1BWP12T U159 ( .A1(n118), .A2(pc_in[9]), .ZN(n117) );
  INVD1BWP12T U160 ( .I(pc_in[10]), .ZN(n112) );
  NR2D1BWP12T U161 ( .A1(n117), .A2(n112), .ZN(n111) );
  ND2D1BWP12T U162 ( .A1(n111), .A2(pc_in[11]), .ZN(n107) );
  INVD1BWP12T U163 ( .I(pc_in[12]), .ZN(n106) );
  NR2D1BWP12T U164 ( .A1(n107), .A2(n106), .ZN(n105) );
  ND2D1BWP12T U165 ( .A1(n105), .A2(pc_in[13]), .ZN(n104) );
  INVD1BWP12T U166 ( .I(pc_in[14]), .ZN(n103) );
  NR2D1BWP12T U167 ( .A1(n104), .A2(n103), .ZN(n102) );
  ND2D1BWP12T U168 ( .A1(n102), .A2(pc_in[15]), .ZN(n101) );
  INVD1BWP12T U169 ( .I(pc_in[16]), .ZN(n100) );
  NR2D1BWP12T U170 ( .A1(n101), .A2(n100), .ZN(n99) );
  ND2D1BWP12T U171 ( .A1(n99), .A2(pc_in[17]), .ZN(n98) );
  INVD1BWP12T U172 ( .I(pc_in[18]), .ZN(n97) );
  NR2D1BWP12T U173 ( .A1(n98), .A2(n97), .ZN(n96) );
  ND2D1BWP12T U174 ( .A1(n96), .A2(pc_in[19]), .ZN(n95) );
  INVD1BWP12T U175 ( .I(pc_in[20]), .ZN(n94) );
  NR2D1BWP12T U176 ( .A1(n95), .A2(n94), .ZN(n93) );
  ND2D1BWP12T U177 ( .A1(n93), .A2(pc_in[21]), .ZN(n92) );
  INVD1BWP12T U178 ( .I(pc_in[22]), .ZN(n91) );
  NR2D1BWP12T U179 ( .A1(n92), .A2(n91), .ZN(n90) );
  ND2D1BWP12T U180 ( .A1(n90), .A2(pc_in[23]), .ZN(n89) );
  INVD1BWP12T U181 ( .I(pc_in[24]), .ZN(n88) );
  NR2D1BWP12T U182 ( .A1(n89), .A2(n88), .ZN(n87) );
  ND2D1BWP12T U183 ( .A1(n87), .A2(pc_in[25]), .ZN(n86) );
  INVD1BWP12T U184 ( .I(pc_in[26]), .ZN(n85) );
  NR2D1BWP12T U185 ( .A1(n86), .A2(n85), .ZN(n84) );
  ND2D1BWP12T U186 ( .A1(n84), .A2(pc_in[27]), .ZN(n83) );
  INVD1BWP12T U187 ( .I(pc_in[28]), .ZN(n82) );
  NR2D1BWP12T U188 ( .A1(n83), .A2(n82), .ZN(n81) );
  ND2D1BWP12T U189 ( .A1(n81), .A2(pc_in[29]), .ZN(n80) );
  INVD1BWP12T U190 ( .I(pc_in[30]), .ZN(n79) );
  NR2D1BWP12T U191 ( .A1(n80), .A2(n79), .ZN(n78) );
  NR2D1BWP12T U192 ( .A1(pc_in[31]), .A2(n78), .ZN(n77) );
  AOI211D0BWP12T U193 ( .A1(pc_in[31]), .A2(n78), .B(currentState[0]), .C(n77), 
        .ZN(pc_out[31]) );
  AOI211D0BWP12T U194 ( .A1(n80), .A2(n79), .B(currentState[0]), .C(n78), .ZN(
        pc_out[30]) );
  OA211D0BWP12T U195 ( .A1(n81), .A2(pc_in[29]), .B(n142), .C(n80), .Z(
        pc_out[29]) );
  AOI211D0BWP12T U196 ( .A1(n83), .A2(n82), .B(currentState[0]), .C(n81), .ZN(
        pc_out[28]) );
  OA211D0BWP12T U197 ( .A1(n84), .A2(pc_in[27]), .B(n142), .C(n83), .Z(
        pc_out[27]) );
  AOI211D0BWP12T U198 ( .A1(n86), .A2(n85), .B(currentState[0]), .C(n84), .ZN(
        pc_out[26]) );
  OA211D0BWP12T U199 ( .A1(n87), .A2(pc_in[25]), .B(n142), .C(n86), .Z(
        pc_out[25]) );
  AOI211D0BWP12T U200 ( .A1(n89), .A2(n88), .B(currentState[0]), .C(n87), .ZN(
        pc_out[24]) );
  OA211D0BWP12T U201 ( .A1(n90), .A2(pc_in[23]), .B(n142), .C(n89), .Z(
        pc_out[23]) );
  AOI211D0BWP12T U202 ( .A1(n92), .A2(n91), .B(currentState[0]), .C(n90), .ZN(
        pc_out[22]) );
  OA211D0BWP12T U203 ( .A1(n93), .A2(pc_in[21]), .B(n142), .C(n92), .Z(
        pc_out[21]) );
  AOI211D0BWP12T U204 ( .A1(n95), .A2(n94), .B(currentState[0]), .C(n93), .ZN(
        pc_out[20]) );
  OA211D0BWP12T U205 ( .A1(n96), .A2(pc_in[19]), .B(n142), .C(n95), .Z(
        pc_out[19]) );
  AOI211D0BWP12T U206 ( .A1(n98), .A2(n97), .B(currentState[0]), .C(n96), .ZN(
        pc_out[18]) );
  OA211D0BWP12T U207 ( .A1(n99), .A2(pc_in[17]), .B(n142), .C(n98), .Z(
        pc_out[17]) );
  AOI211D0BWP12T U208 ( .A1(n101), .A2(n100), .B(currentState[0]), .C(n99), 
        .ZN(pc_out[16]) );
  OA211D0BWP12T U209 ( .A1(n102), .A2(pc_in[15]), .B(n142), .C(n101), .Z(
        pc_out[15]) );
  AOI211D0BWP12T U210 ( .A1(n104), .A2(n103), .B(currentState[0]), .C(n102), 
        .ZN(pc_out[14]) );
  OA211D0BWP12T U211 ( .A1(n105), .A2(pc_in[13]), .B(n142), .C(n104), .Z(
        pc_out[13]) );
  AOI211D0BWP12T U212 ( .A1(n107), .A2(n106), .B(currentState[0]), .C(n105), 
        .ZN(pc_out[12]) );
  OA211D0BWP12T U213 ( .A1(n111), .A2(pc_in[11]), .B(n142), .C(n107), .Z(
        pc_out[11]) );
  OR2XD1BWP12T U214 ( .A1(pc_in[2]), .A2(pc_in[3]), .Z(n136) );
  NR2D1BWP12T U215 ( .A1(pc_in[4]), .A2(n136), .ZN(n131) );
  INVD1BWP12T U216 ( .I(pc_in[5]), .ZN(n130) );
  ND2D1BWP12T U217 ( .A1(n131), .A2(n130), .ZN(n129) );
  NR2D1BWP12T U218 ( .A1(pc_in[6]), .A2(n129), .ZN(n123) );
  INVD1BWP12T U219 ( .I(pc_in[7]), .ZN(n121) );
  ND2D1BWP12T U220 ( .A1(n123), .A2(n121), .ZN(n120) );
  NR2D1BWP12T U221 ( .A1(pc_in[8]), .A2(n120), .ZN(n115) );
  INVD1BWP12T U222 ( .I(pc_in[9]), .ZN(n114) );
  ND2D1BWP12T U223 ( .A1(n115), .A2(n114), .ZN(n113) );
  NR2D1BWP12T U224 ( .A1(pc_in[10]), .A2(n113), .ZN(n110) );
  AOI21D1BWP12T U225 ( .A1(n113), .A2(pc_in[10]), .B(n110), .ZN(n108) );
  NR2D0BWP12T U226 ( .A1(n132), .A2(n108), .ZN(address[10]) );
  NR2D1BWP12T U227 ( .A1(pc_in[11]), .A2(n110), .ZN(n109) );
  AOI211D0BWP12T U228 ( .A1(pc_in[11]), .A2(n110), .B(n132), .C(n109), .ZN(
        address[11]) );
  AOI211D0BWP12T U229 ( .A1(n117), .A2(n112), .B(currentState[0]), .C(n111), 
        .ZN(pc_out[10]) );
  OAI32D0BWP12T U230 ( .A1(n132), .A2(n115), .A3(n114), .B1(n113), .B2(n132), 
        .ZN(address[9]) );
  AOI21D1BWP12T U231 ( .A1(n120), .A2(pc_in[8]), .B(n115), .ZN(n116) );
  NR2D0BWP12T U232 ( .A1(n132), .A2(n116), .ZN(address[8]) );
  OA211D0BWP12T U233 ( .A1(n118), .A2(pc_in[9]), .B(n142), .C(n117), .Z(
        pc_out[9]) );
  INVD1BWP12T U234 ( .I(n4), .ZN(instruction[3]) );
  CKND2D0BWP12T U235 ( .A1(reset), .A2(instruction[3]), .ZN(n50) );
  IND2XD1BWP12T U236 ( .A1(currentState[1]), .B1(currentState[0]), .ZN(n141)
         );
  ND2D1BWP12T U237 ( .A1(n13), .A2(n141), .ZN(instruction[11]) );
  OR2XD0BWP12T U238 ( .A1(instruction[11]), .A2(n143), .Z(n67) );
  INVD1BWP12T U239 ( .I(n5), .ZN(instruction[4]) );
  CKND2D0BWP12T U240 ( .A1(reset), .A2(instruction[4]), .ZN(n52) );
  INVD1BWP12T U241 ( .I(n6), .ZN(instruction[5]) );
  CKND2D0BWP12T U242 ( .A1(reset), .A2(instruction[5]), .ZN(n54) );
  ND2D1BWP12T U243 ( .A1(n12), .A2(n141), .ZN(instruction[10]) );
  OR2XD0BWP12T U244 ( .A1(instruction[10]), .A2(n143), .Z(n65) );
  INVD1BWP12T U245 ( .I(n1), .ZN(instruction[0]) );
  CKND2D0BWP12T U246 ( .A1(reset), .A2(instruction[0]), .ZN(n44) );
  INVD1BWP12T U247 ( .I(n3), .ZN(instruction[2]) );
  CKND2D0BWP12T U248 ( .A1(reset), .A2(instruction[2]), .ZN(n48) );
  INVD1BWP12T U249 ( .I(n2), .ZN(instruction[1]) );
  CKND2D0BWP12T U250 ( .A1(reset), .A2(instruction[1]), .ZN(n46) );
  ND2D1BWP12T U251 ( .A1(n14), .A2(n141), .ZN(instruction[12]) );
  OR2XD0BWP12T U252 ( .A1(instruction[12]), .A2(n143), .Z(n69) );
  INVD1BWP12T U253 ( .I(n9), .ZN(instruction[8]) );
  CKND2D0BWP12T U254 ( .A1(reset), .A2(instruction[8]), .ZN(n60) );
  INVD1BWP12T U255 ( .I(n7), .ZN(instruction[6]) );
  CKND2D0BWP12T U256 ( .A1(reset), .A2(instruction[6]), .ZN(n56) );
  INVD1BWP12T U257 ( .I(n8), .ZN(instruction[7]) );
  CKND2D0BWP12T U258 ( .A1(reset), .A2(instruction[7]), .ZN(n58) );
  CKND2D0BWP12T U259 ( .A1(reset), .A2(instruction[10]), .ZN(n64) );
  INVD1BWP12T U260 ( .I(n10), .ZN(instruction[9]) );
  CKND2D0BWP12T U261 ( .A1(reset), .A2(instruction[9]), .ZN(n62) );
  INVD1BWP12T U262 ( .I(n15), .ZN(instruction[13]) );
  CKND2D0BWP12T U263 ( .A1(reset), .A2(instruction[13]), .ZN(n70) );
  CKND2D0BWP12T U264 ( .A1(reset), .A2(instruction[11]), .ZN(n66) );
  CKND2D0BWP12T U265 ( .A1(reset), .A2(instruction[12]), .ZN(n68) );
  INVD1BWP12T U266 ( .I(n16), .ZN(instruction[14]) );
  CKND2D0BWP12T U267 ( .A1(reset), .A2(instruction[14]), .ZN(n72) );
  INVD1BWP12T U268 ( .I(n18), .ZN(instruction[15]) );
  CKND2D0BWP12T U269 ( .A1(reset), .A2(instruction[15]), .ZN(n74) );
  AOI211D0BWP12T U270 ( .A1(n122), .A2(n119), .B(currentState[0]), .C(n118), 
        .ZN(pc_out[8]) );
  CKND2D0BWP12T U271 ( .A1(reset), .A2(n8), .ZN(n59) );
  CKND2D0BWP12T U272 ( .A1(reset), .A2(n10), .ZN(n63) );
  CKND2D0BWP12T U273 ( .A1(reset), .A2(n7), .ZN(n57) );
  CKND2D0BWP12T U274 ( .A1(reset), .A2(n9), .ZN(n61) );
  CKND2D0BWP12T U275 ( .A1(reset), .A2(n6), .ZN(n55) );
  CKND2D0BWP12T U276 ( .A1(reset), .A2(n3), .ZN(n49) );
  CKND2D0BWP12T U277 ( .A1(reset), .A2(n5), .ZN(n53) );
  CKND2D0BWP12T U278 ( .A1(reset), .A2(n15), .ZN(n71) );
  CKND2D0BWP12T U279 ( .A1(reset), .A2(n2), .ZN(n47) );
  CKND2D0BWP12T U280 ( .A1(reset), .A2(n18), .ZN(n75) );
  CKND2D0BWP12T U281 ( .A1(reset), .A2(n16), .ZN(n73) );
  CKND2D0BWP12T U282 ( .A1(reset), .A2(n1), .ZN(n45) );
  CKND2D0BWP12T U283 ( .A1(reset), .A2(n4), .ZN(n51) );
  OAI32D0BWP12T U284 ( .A1(n132), .A2(n123), .A3(n121), .B1(n120), .B2(n132), 
        .ZN(address[7]) );
  OA211D0BWP12T U285 ( .A1(n125), .A2(pc_in[7]), .B(n142), .C(n122), .Z(
        pc_out[7]) );
  AOI21D1BWP12T U286 ( .A1(n129), .A2(pc_in[6]), .B(n123), .ZN(n124) );
  NR2D0BWP12T U287 ( .A1(n132), .A2(n124), .ZN(address[6]) );
  AOI211D0BWP12T U288 ( .A1(n133), .A2(n126), .B(currentState[0]), .C(n125), 
        .ZN(pc_out[6]) );
  AOI21D0BWP12T U289 ( .A1(n137), .A2(n136), .B(n132), .ZN(address[3]) );
  INVD1BWP12T U290 ( .I(pc_in[1]), .ZN(n139) );
  NR2D0BWP12T U291 ( .A1(n132), .A2(n139), .ZN(address[1]) );
  NR2D0BWP12T U292 ( .A1(pc_in[2]), .A2(n132), .ZN(address[2]) );
  CKND2D0BWP12T U293 ( .A1(n141), .A2(n127), .ZN(pc_en) );
  INVD1BWP12T U294 ( .I(pc_in[0]), .ZN(n140) );
  NR2D0BWP12T U295 ( .A1(n132), .A2(n140), .ZN(address[0]) );
  AOI21D1BWP12T U296 ( .A1(n136), .A2(pc_in[4]), .B(n131), .ZN(n128) );
  NR2D0BWP12T U297 ( .A1(n132), .A2(n128), .ZN(address[4]) );
  OAI32D0BWP12T U298 ( .A1(n132), .A2(n131), .A3(n130), .B1(n129), .B2(n132), 
        .ZN(address[5]) );
  OA211D0BWP12T U299 ( .A1(n134), .A2(pc_in[5]), .B(n142), .C(n133), .Z(
        pc_out[5]) );
  AOI21D0BWP12T U300 ( .A1(stall_decoder_in), .A2(n142), .B(currentState[1]), 
        .ZN(read_enable) );
  OAI21D0BWP12T U301 ( .A1(currentState[0]), .A2(pc_in[2]), .B(n141), .ZN(
        pc_out[2]) );
  AOI211D0BWP12T U302 ( .A1(n137), .A2(n135), .B(currentState[0]), .C(n134), 
        .ZN(pc_out[4]) );
  ND2D1BWP12T U303 ( .A1(n137), .A2(n136), .ZN(n138) );
  NR2D0BWP12T U304 ( .A1(currentState[0]), .A2(n138), .ZN(pc_out[3]) );
  NR2D0BWP12T U305 ( .A1(currentState[0]), .A2(n139), .ZN(pc_out[1]) );
  NR2D0BWP12T U306 ( .A1(currentState[0]), .A2(n140), .ZN(pc_out[0]) );
  NR2D1BWP12T U307 ( .A1(n143), .A2(n141), .ZN(nextState[0]) );
endmodule

