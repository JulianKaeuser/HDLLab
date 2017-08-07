
module Instruction_Fetch ( clk, reset, stall_decoder_in, stall_memory, pc_in, 
        instruction_in, read_enable, pc_en, stall_decoder_out, address, pc_out, 
        instruction_out );
  input [31:0] pc_in;
  input [15:0] instruction_in;
  output [11:0] address;
  output [31:0] pc_out;
  output [15:0] instruction_out;
  input clk, reset, stall_decoder_in, stall_memory;
  output read_enable, pc_en, stall_decoder_out;
  wire   currentState_0_, nextState_0_, n8, n10, n11, n12, n13, n14, n15, n16,
         n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30,
         n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44,
         n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56, n69, n70,
         n71;

  DFQD1BWP12T instruction_out_reg_15_ ( .D(instruction_in[15]), .CP(clk), .Q(
        instruction_out[15]) );
  DFQD1BWP12T instruction_out_reg_14_ ( .D(instruction_in[14]), .CP(clk), .Q(
        instruction_out[14]) );
  DFQD1BWP12T instruction_out_reg_13_ ( .D(instruction_in[13]), .CP(clk), .Q(
        instruction_out[13]) );
  DFQD1BWP12T instruction_out_reg_12_ ( .D(instruction_in[12]), .CP(clk), .Q(
        instruction_out[12]) );
  DFQD1BWP12T instruction_out_reg_11_ ( .D(instruction_in[11]), .CP(clk), .Q(
        instruction_out[11]) );
  DFQD1BWP12T instruction_out_reg_10_ ( .D(instruction_in[10]), .CP(clk), .Q(
        instruction_out[10]) );
  DFQD1BWP12T instruction_out_reg_9_ ( .D(instruction_in[9]), .CP(clk), .Q(
        instruction_out[9]) );
  DFQD1BWP12T instruction_out_reg_8_ ( .D(instruction_in[8]), .CP(clk), .Q(
        instruction_out[8]) );
  DFQD1BWP12T instruction_out_reg_7_ ( .D(instruction_in[7]), .CP(clk), .Q(
        instruction_out[7]) );
  DFQD1BWP12T instruction_out_reg_6_ ( .D(instruction_in[6]), .CP(clk), .Q(
        instruction_out[6]) );
  DFQD1BWP12T instruction_out_reg_5_ ( .D(instruction_in[5]), .CP(clk), .Q(
        instruction_out[5]) );
  DFQD1BWP12T instruction_out_reg_4_ ( .D(instruction_in[4]), .CP(clk), .Q(
        instruction_out[4]) );
  DFQD1BWP12T instruction_out_reg_3_ ( .D(instruction_in[3]), .CP(clk), .Q(
        instruction_out[3]) );
  DFQD1BWP12T instruction_out_reg_2_ ( .D(instruction_in[2]), .CP(clk), .Q(
        instruction_out[2]) );
  DFQD1BWP12T instruction_out_reg_1_ ( .D(instruction_in[1]), .CP(clk), .Q(
        instruction_out[1]) );
  DFQD1BWP12T instruction_out_reg_0_ ( .D(instruction_in[0]), .CP(clk), .Q(
        instruction_out[0]) );
  DFCNQD1BWP12T currentState_reg_0_ ( .D(nextState_0_), .CP(clk), .CDN(n8), 
        .Q(currentState_0_) );
  EDFCNXD1BWP12T currentState_reg_1_ ( .D(n69), .E(n71), .CP(clk), .CDN(n8), 
        .Q(stall_decoder_out), .QN(n70) );
  ND2D1BWP12T U49 ( .A1(n70), .A2(n56), .ZN(n54) );
  INVD1BWP12T U50 ( .I(n54), .ZN(n55) );
  INVD1BWP12T U51 ( .I(currentState_0_), .ZN(n56) );
  NR2D1BWP12T U52 ( .A1(stall_memory), .A2(n56), .ZN(n71) );
  NR2D1BWP12T U53 ( .A1(stall_decoder_out), .A2(stall_decoder_in), .ZN(n69) );
  INVD1BWP12T U54 ( .I(reset), .ZN(n8) );
  AOI22D0BWP12T U55 ( .A1(n54), .A2(stall_memory), .B1(n8), .B2(n55), .ZN(n10)
         );
  OAI21D0BWP12T U56 ( .A1(n56), .A2(n69), .B(n10), .ZN(nextState_0_) );
  ND2D1BWP12T U57 ( .A1(pc_in[2]), .A2(pc_in[3]), .ZN(n51) );
  INVD1BWP12T U58 ( .I(pc_in[4]), .ZN(n48) );
  NR2D1BWP12T U59 ( .A1(n51), .A2(n48), .ZN(n53) );
  ND2D1BWP12T U60 ( .A1(n53), .A2(pc_in[5]), .ZN(n52) );
  INVD1BWP12T U61 ( .I(pc_in[6]), .ZN(n50) );
  NR2D1BWP12T U62 ( .A1(n52), .A2(n50), .ZN(n49) );
  ND2D1BWP12T U63 ( .A1(n49), .A2(pc_in[7]), .ZN(n47) );
  INVD1BWP12T U64 ( .I(pc_in[8]), .ZN(n46) );
  NR2D1BWP12T U65 ( .A1(n47), .A2(n46), .ZN(n45) );
  ND2D1BWP12T U66 ( .A1(n45), .A2(pc_in[9]), .ZN(n44) );
  INVD1BWP12T U67 ( .I(pc_in[10]), .ZN(n43) );
  NR2D1BWP12T U68 ( .A1(n44), .A2(n43), .ZN(n42) );
  ND2D1BWP12T U69 ( .A1(n42), .A2(pc_in[11]), .ZN(n41) );
  INVD1BWP12T U70 ( .I(pc_in[12]), .ZN(n40) );
  NR2D1BWP12T U71 ( .A1(n41), .A2(n40), .ZN(n39) );
  ND2D1BWP12T U72 ( .A1(n39), .A2(pc_in[13]), .ZN(n38) );
  INVD1BWP12T U73 ( .I(pc_in[14]), .ZN(n37) );
  NR2D1BWP12T U74 ( .A1(n38), .A2(n37), .ZN(n36) );
  ND2D1BWP12T U75 ( .A1(n36), .A2(pc_in[15]), .ZN(n35) );
  INVD1BWP12T U76 ( .I(pc_in[16]), .ZN(n34) );
  NR2D1BWP12T U77 ( .A1(n35), .A2(n34), .ZN(n33) );
  ND2D1BWP12T U78 ( .A1(n33), .A2(pc_in[17]), .ZN(n32) );
  INVD1BWP12T U79 ( .I(pc_in[18]), .ZN(n31) );
  NR2D1BWP12T U80 ( .A1(n32), .A2(n31), .ZN(n30) );
  ND2D1BWP12T U81 ( .A1(n30), .A2(pc_in[19]), .ZN(n29) );
  INVD1BWP12T U82 ( .I(pc_in[20]), .ZN(n28) );
  NR2D1BWP12T U83 ( .A1(n29), .A2(n28), .ZN(n27) );
  ND2D1BWP12T U84 ( .A1(n27), .A2(pc_in[21]), .ZN(n26) );
  INVD1BWP12T U85 ( .I(pc_in[22]), .ZN(n25) );
  NR2D1BWP12T U86 ( .A1(n26), .A2(n25), .ZN(n24) );
  ND2D1BWP12T U87 ( .A1(n24), .A2(pc_in[23]), .ZN(n23) );
  INVD1BWP12T U88 ( .I(pc_in[24]), .ZN(n22) );
  NR2D1BWP12T U89 ( .A1(n23), .A2(n22), .ZN(n21) );
  ND2D1BWP12T U90 ( .A1(n21), .A2(pc_in[25]), .ZN(n20) );
  INVD1BWP12T U91 ( .I(pc_in[26]), .ZN(n19) );
  NR2D1BWP12T U92 ( .A1(n20), .A2(n19), .ZN(n18) );
  ND2D1BWP12T U93 ( .A1(n18), .A2(pc_in[27]), .ZN(n17) );
  INVD1BWP12T U94 ( .I(pc_in[28]), .ZN(n16) );
  NR2D1BWP12T U95 ( .A1(n17), .A2(n16), .ZN(n15) );
  ND2D1BWP12T U96 ( .A1(n15), .A2(pc_in[29]), .ZN(n14) );
  INVD1BWP12T U97 ( .I(pc_in[30]), .ZN(n13) );
  NR2D1BWP12T U98 ( .A1(n14), .A2(n13), .ZN(n12) );
  NR2D1BWP12T U99 ( .A1(pc_in[31]), .A2(n12), .ZN(n11) );
  AOI211D0BWP12T U100 ( .A1(pc_in[31]), .A2(n12), .B(n55), .C(n11), .ZN(
        pc_out[31]) );
  AOI211D0BWP12T U101 ( .A1(n14), .A2(n13), .B(n55), .C(n12), .ZN(pc_out[30])
         );
  OA211D0BWP12T U102 ( .A1(n15), .A2(pc_in[29]), .B(n54), .C(n14), .Z(
        pc_out[29]) );
  AOI211D0BWP12T U103 ( .A1(n17), .A2(n16), .B(n55), .C(n15), .ZN(pc_out[28])
         );
  OA211D0BWP12T U104 ( .A1(n18), .A2(pc_in[27]), .B(n54), .C(n17), .Z(
        pc_out[27]) );
  AOI211D0BWP12T U105 ( .A1(n20), .A2(n19), .B(n55), .C(n18), .ZN(pc_out[26])
         );
  OA211D0BWP12T U106 ( .A1(n21), .A2(pc_in[25]), .B(n54), .C(n20), .Z(
        pc_out[25]) );
  AOI211D0BWP12T U107 ( .A1(n23), .A2(n22), .B(n55), .C(n21), .ZN(pc_out[24])
         );
  OA211D0BWP12T U108 ( .A1(n24), .A2(pc_in[23]), .B(n54), .C(n23), .Z(
        pc_out[23]) );
  AOI211D0BWP12T U109 ( .A1(n26), .A2(n25), .B(n55), .C(n24), .ZN(pc_out[22])
         );
  OA211D0BWP12T U110 ( .A1(n27), .A2(pc_in[21]), .B(n54), .C(n26), .Z(
        pc_out[21]) );
  AOI211D0BWP12T U111 ( .A1(n29), .A2(n28), .B(n55), .C(n27), .ZN(pc_out[20])
         );
  OA211D0BWP12T U112 ( .A1(n30), .A2(pc_in[19]), .B(n54), .C(n29), .Z(
        pc_out[19]) );
  AOI211D0BWP12T U113 ( .A1(n32), .A2(n31), .B(n55), .C(n30), .ZN(pc_out[18])
         );
  OA211D0BWP12T U114 ( .A1(n33), .A2(pc_in[17]), .B(n54), .C(n32), .Z(
        pc_out[17]) );
  AOI211D0BWP12T U115 ( .A1(n35), .A2(n34), .B(n55), .C(n33), .ZN(pc_out[16])
         );
  OA211D0BWP12T U116 ( .A1(n36), .A2(pc_in[15]), .B(n54), .C(n35), .Z(
        pc_out[15]) );
  AOI211D0BWP12T U117 ( .A1(n38), .A2(n37), .B(n55), .C(n36), .ZN(pc_out[14])
         );
  OA211D0BWP12T U118 ( .A1(n39), .A2(pc_in[13]), .B(n54), .C(n38), .Z(
        pc_out[13]) );
  AOI211D0BWP12T U119 ( .A1(n41), .A2(n40), .B(n55), .C(n39), .ZN(pc_out[12])
         );
  OA211D0BWP12T U120 ( .A1(n42), .A2(pc_in[11]), .B(n54), .C(n41), .Z(
        pc_out[11]) );
  AOI211D0BWP12T U121 ( .A1(n44), .A2(n43), .B(n55), .C(n42), .ZN(pc_out[10])
         );
  OA211D0BWP12T U122 ( .A1(n45), .A2(pc_in[9]), .B(n54), .C(n44), .Z(pc_out[9]) );
  AOI211D0BWP12T U123 ( .A1(n47), .A2(n46), .B(n55), .C(n45), .ZN(pc_out[8])
         );
  OA211D0BWP12T U124 ( .A1(n49), .A2(pc_in[7]), .B(n54), .C(n47), .Z(pc_out[7]) );
  AOI211D0BWP12T U125 ( .A1(n51), .A2(n48), .B(n55), .C(n53), .ZN(pc_out[4])
         );
  NR2D0BWP12T U126 ( .A1(n55), .A2(pc_in[2]), .ZN(pc_out[2]) );
  AOI211D0BWP12T U127 ( .A1(n52), .A2(n50), .B(n55), .C(n49), .ZN(pc_out[6])
         );
  OA211D0BWP12T U128 ( .A1(pc_in[2]), .A2(pc_in[3]), .B(n54), .C(n51), .Z(
        pc_out[3]) );
  AN2XD0BWP12T U129 ( .A1(pc_in[1]), .A2(n54), .Z(pc_out[1]) );
  AN2XD0BWP12T U130 ( .A1(pc_in[0]), .A2(n54), .Z(pc_out[0]) );
  OA211D0BWP12T U131 ( .A1(n53), .A2(pc_in[5]), .B(n54), .C(n52), .Z(pc_out[5]) );
  ND3D0BWP12T U132 ( .A1(currentState_0_), .A2(stall_decoder_in), .A3(n70), 
        .ZN(pc_en) );
  AOI221D0BWP12T U133 ( .A1(currentState_0_), .A2(stall_decoder_out), .B1(n56), 
        .B2(n70), .C(stall_memory), .ZN(read_enable) );
  CKBD1BWP12T U134 ( .I(pc_in[11]), .Z(address[11]) );
  CKBD1BWP12T U135 ( .I(pc_in[10]), .Z(address[10]) );
  CKBD1BWP12T U136 ( .I(pc_in[9]), .Z(address[9]) );
  CKBD1BWP12T U137 ( .I(pc_in[8]), .Z(address[8]) );
  CKBD1BWP12T U138 ( .I(pc_in[7]), .Z(address[7]) );
  CKBD1BWP12T U139 ( .I(pc_in[6]), .Z(address[6]) );
  CKBD1BWP12T U140 ( .I(pc_in[5]), .Z(address[5]) );
  CKBD1BWP12T U141 ( .I(pc_in[4]), .Z(address[4]) );
  CKBD1BWP12T U142 ( .I(pc_in[3]), .Z(address[3]) );
  CKBD1BWP12T U143 ( .I(pc_in[2]), .Z(address[2]) );
  CKBD1BWP12T U144 ( .I(pc_in[1]), .Z(address[1]) );
  CKBD1BWP12T U145 ( .I(pc_in[0]), .Z(address[0]) );
endmodule

