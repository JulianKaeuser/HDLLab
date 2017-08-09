
module Instruction_Fetch ( clk, reset, stall_decoder_in, memory_output_valid, 
        current_pc_in, instruction_in, memory_load_request, 
        incremented_pc_write_enable, instruction_valid, memory_address, 
        incremented_pc_out, instruction_out );
  input [31:0] current_pc_in;
  input [15:0] instruction_in;
  output [11:0] memory_address;
  output [31:0] incremented_pc_out;
  output [15:0] instruction_out;
  input clk, reset, stall_decoder_in, memory_output_valid;
  output memory_load_request, incremented_pc_write_enable, instruction_valid;
  wire   n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42,
         n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56,
         n57, n58, n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, n70,
         n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84,
         n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97;
  wire   [1:0] currentState;
  wire   [1:0] nextState;

  DFCNQD1BWP12T currentState_reg_0_ ( .D(nextState[0]), .CP(clk), .CDN(n29), 
        .Q(currentState[0]) );
  DFCNXD1BWP12T currentState_reg_1_ ( .D(nextState[1]), .CP(clk), .CDN(n29), 
        .Q(currentState[1]), .QN(n97) );
  ND2D1BWP12T U99 ( .A1(memory_load_request), .A2(memory_output_valid), .ZN(
        n68) );
  OR2XD1BWP12T U100 ( .A1(currentState[0]), .A2(n97), .Z(n74) );
  INVD1BWP12T U101 ( .I(n68), .ZN(instruction_valid) );
  INVD1BWP12T U102 ( .I(n74), .ZN(memory_load_request) );
  OA22D1BWP12T U103 ( .A1(stall_decoder_in), .A2(currentState[1]), .B1(
        instruction_valid), .B2(currentState[0]), .Z(nextState[0]) );
  AOI21D0BWP12T U104 ( .A1(current_pc_in[3]), .A2(current_pc_in[2]), .B(n94), 
        .ZN(n30) );
  NR2D0BWP12T U105 ( .A1(n96), .A2(n30), .ZN(memory_address[2]) );
  CKND2D0BWP12T U106 ( .A1(n97), .A2(currentState[0]), .ZN(n31) );
  OAI222D0BWP12T U107 ( .A1(n31), .A2(stall_decoder_in), .B1(n74), .B2(
        memory_output_valid), .C1(reset), .C2(n73), .ZN(nextState[1]) );
  INVD1BWP12T U108 ( .I(current_pc_in[12]), .ZN(n61) );
  INVD1BWP12T U109 ( .I(current_pc_in[10]), .ZN(n81) );
  INVD1BWP12T U110 ( .I(current_pc_in[8]), .ZN(n85) );
  INVD1BWP12T U111 ( .I(current_pc_in[6]), .ZN(n89) );
  INVD1BWP12T U112 ( .I(current_pc_in[4]), .ZN(n93) );
  INVD1BWP12T U113 ( .I(current_pc_in[2]), .ZN(n76) );
  INVD1BWP12T U114 ( .I(current_pc_in[1]), .ZN(n95) );
  NR2D1BWP12T U115 ( .A1(n76), .A2(n95), .ZN(n75) );
  ND2D1BWP12T U116 ( .A1(current_pc_in[3]), .A2(n75), .ZN(n72) );
  NR2D1BWP12T U117 ( .A1(n93), .A2(n72), .ZN(n71) );
  ND2D1BWP12T U118 ( .A1(current_pc_in[5]), .A2(n71), .ZN(n69) );
  NR2D1BWP12T U119 ( .A1(n89), .A2(n69), .ZN(n67) );
  ND2D1BWP12T U120 ( .A1(current_pc_in[7]), .A2(n67), .ZN(n66) );
  NR2D1BWP12T U121 ( .A1(n85), .A2(n66), .ZN(n65) );
  ND2D1BWP12T U122 ( .A1(current_pc_in[9]), .A2(n65), .ZN(n64) );
  NR2D1BWP12T U123 ( .A1(n81), .A2(n64), .ZN(n63) );
  ND2D1BWP12T U124 ( .A1(current_pc_in[11]), .A2(n63), .ZN(n62) );
  NR2D1BWP12T U125 ( .A1(n61), .A2(n62), .ZN(n60) );
  ND2D1BWP12T U126 ( .A1(n60), .A2(current_pc_in[13]), .ZN(n59) );
  INVD1BWP12T U127 ( .I(current_pc_in[14]), .ZN(n58) );
  NR2D1BWP12T U128 ( .A1(n59), .A2(n58), .ZN(n57) );
  ND2D1BWP12T U129 ( .A1(n57), .A2(current_pc_in[15]), .ZN(n56) );
  INVD1BWP12T U130 ( .I(current_pc_in[16]), .ZN(n55) );
  NR2D1BWP12T U131 ( .A1(n56), .A2(n55), .ZN(n54) );
  ND2D1BWP12T U132 ( .A1(n54), .A2(current_pc_in[17]), .ZN(n53) );
  INVD1BWP12T U133 ( .I(current_pc_in[18]), .ZN(n52) );
  NR2D1BWP12T U134 ( .A1(n53), .A2(n52), .ZN(n51) );
  ND2D1BWP12T U135 ( .A1(n51), .A2(current_pc_in[19]), .ZN(n50) );
  INVD1BWP12T U136 ( .I(current_pc_in[20]), .ZN(n49) );
  NR2D1BWP12T U137 ( .A1(n50), .A2(n49), .ZN(n48) );
  ND2D1BWP12T U138 ( .A1(n48), .A2(current_pc_in[21]), .ZN(n47) );
  INVD1BWP12T U139 ( .I(current_pc_in[22]), .ZN(n46) );
  NR2D1BWP12T U140 ( .A1(n47), .A2(n46), .ZN(n45) );
  ND2D1BWP12T U141 ( .A1(n45), .A2(current_pc_in[23]), .ZN(n44) );
  INVD1BWP12T U142 ( .I(current_pc_in[24]), .ZN(n43) );
  NR2D1BWP12T U143 ( .A1(n44), .A2(n43), .ZN(n42) );
  ND2D1BWP12T U144 ( .A1(n42), .A2(current_pc_in[25]), .ZN(n41) );
  INVD1BWP12T U145 ( .I(current_pc_in[26]), .ZN(n40) );
  NR2D1BWP12T U146 ( .A1(n41), .A2(n40), .ZN(n39) );
  ND2D1BWP12T U147 ( .A1(n39), .A2(current_pc_in[27]), .ZN(n38) );
  INVD1BWP12T U148 ( .I(current_pc_in[28]), .ZN(n37) );
  NR2D1BWP12T U149 ( .A1(n38), .A2(n37), .ZN(n36) );
  ND2D1BWP12T U150 ( .A1(n36), .A2(current_pc_in[29]), .ZN(n35) );
  INVD1BWP12T U151 ( .I(current_pc_in[30]), .ZN(n34) );
  NR2D1BWP12T U152 ( .A1(n35), .A2(n34), .ZN(n33) );
  NR2D1BWP12T U153 ( .A1(current_pc_in[31]), .A2(n33), .ZN(n32) );
  AOI211D0BWP12T U154 ( .A1(current_pc_in[31]), .A2(n33), .B(n74), .C(n32), 
        .ZN(incremented_pc_out[31]) );
  AOI211D0BWP12T U155 ( .A1(n35), .A2(n34), .B(n33), .C(n74), .ZN(
        incremented_pc_out[30]) );
  OA211D0BWP12T U156 ( .A1(n36), .A2(current_pc_in[29]), .B(
        memory_load_request), .C(n35), .Z(incremented_pc_out[29]) );
  AOI211D0BWP12T U157 ( .A1(n38), .A2(n37), .B(n36), .C(n74), .ZN(
        incremented_pc_out[28]) );
  OA211D0BWP12T U158 ( .A1(n39), .A2(current_pc_in[27]), .B(
        memory_load_request), .C(n38), .Z(incremented_pc_out[27]) );
  AOI211D0BWP12T U159 ( .A1(n41), .A2(n40), .B(n39), .C(n74), .ZN(
        incremented_pc_out[26]) );
  OA211D0BWP12T U160 ( .A1(n42), .A2(current_pc_in[25]), .B(
        memory_load_request), .C(n41), .Z(incremented_pc_out[25]) );
  AOI211D0BWP12T U161 ( .A1(n44), .A2(n43), .B(n42), .C(n74), .ZN(
        incremented_pc_out[24]) );
  OA211D0BWP12T U162 ( .A1(n45), .A2(current_pc_in[23]), .B(
        memory_load_request), .C(n44), .Z(incremented_pc_out[23]) );
  AOI211D0BWP12T U163 ( .A1(n47), .A2(n46), .B(n45), .C(n74), .ZN(
        incremented_pc_out[22]) );
  OA211D0BWP12T U164 ( .A1(n48), .A2(current_pc_in[21]), .B(
        memory_load_request), .C(n47), .Z(incremented_pc_out[21]) );
  AOI211D0BWP12T U165 ( .A1(n50), .A2(n49), .B(n48), .C(n74), .ZN(
        incremented_pc_out[20]) );
  OA211D0BWP12T U166 ( .A1(n51), .A2(current_pc_in[19]), .B(
        memory_load_request), .C(n50), .Z(incremented_pc_out[19]) );
  AOI211D0BWP12T U167 ( .A1(n53), .A2(n52), .B(n51), .C(n74), .ZN(
        incremented_pc_out[18]) );
  OA211D0BWP12T U168 ( .A1(n54), .A2(current_pc_in[17]), .B(
        memory_load_request), .C(n53), .Z(incremented_pc_out[17]) );
  AOI211D0BWP12T U169 ( .A1(n56), .A2(n55), .B(n54), .C(n74), .ZN(
        incremented_pc_out[16]) );
  OA211D0BWP12T U170 ( .A1(n57), .A2(current_pc_in[15]), .B(
        memory_load_request), .C(n56), .Z(incremented_pc_out[15]) );
  AOI211D0BWP12T U171 ( .A1(n59), .A2(n58), .B(n57), .C(n74), .ZN(
        incremented_pc_out[14]) );
  OA211D0BWP12T U172 ( .A1(n60), .A2(current_pc_in[13]), .B(
        memory_load_request), .C(n59), .Z(incremented_pc_out[13]) );
  AOI211D0BWP12T U173 ( .A1(n61), .A2(n62), .B(n60), .C(n74), .ZN(
        incremented_pc_out[12]) );
  OA211D0BWP12T U174 ( .A1(current_pc_in[11]), .A2(n63), .B(
        memory_load_request), .C(n62), .Z(incremented_pc_out[11]) );
  AOI211D0BWP12T U175 ( .A1(n81), .A2(n64), .B(n63), .C(n74), .ZN(
        incremented_pc_out[10]) );
  OA211D0BWP12T U176 ( .A1(current_pc_in[9]), .A2(n65), .B(memory_load_request), .C(n64), .Z(incremented_pc_out[9]) );
  AOI211D0BWP12T U177 ( .A1(n85), .A2(n66), .B(n65), .C(n74), .ZN(
        incremented_pc_out[8]) );
  OA211D0BWP12T U178 ( .A1(current_pc_in[7]), .A2(n67), .B(memory_load_request), .C(n66), .Z(incremented_pc_out[7]) );
  AN2XD0BWP12T U179 ( .A1(instruction_in[5]), .A2(instruction_valid), .Z(
        instruction_out[5]) );
  AN2XD0BWP12T U180 ( .A1(instruction_in[0]), .A2(instruction_valid), .Z(
        instruction_out[0]) );
  AN2XD0BWP12T U181 ( .A1(instruction_in[6]), .A2(instruction_valid), .Z(
        instruction_out[6]) );
  AN2XD0BWP12T U182 ( .A1(instruction_in[7]), .A2(instruction_valid), .Z(
        instruction_out[7]) );
  AN2XD0BWP12T U183 ( .A1(instruction_in[4]), .A2(instruction_valid), .Z(
        instruction_out[4]) );
  AN2XD0BWP12T U184 ( .A1(instruction_in[3]), .A2(instruction_valid), .Z(
        instruction_out[3]) );
  AN2XD0BWP12T U185 ( .A1(instruction_in[2]), .A2(instruction_valid), .Z(
        instruction_out[2]) );
  AN2XD0BWP12T U186 ( .A1(instruction_in[1]), .A2(instruction_valid), .Z(
        instruction_out[1]) );
  AN2XD0BWP12T U187 ( .A1(instruction_in[14]), .A2(instruction_valid), .Z(
        instruction_out[14]) );
  AOI211D0BWP12T U188 ( .A1(n89), .A2(n69), .B(n67), .C(n74), .ZN(
        incremented_pc_out[6]) );
  IND2XD1BWP12T U189 ( .A1(currentState[0]), .B1(n97), .ZN(n73) );
  CKND2D0BWP12T U190 ( .A1(n73), .A2(n68), .ZN(incremented_pc_write_enable) );
  OA211D0BWP12T U191 ( .A1(current_pc_in[5]), .A2(n71), .B(memory_load_request), .C(n69), .Z(incremented_pc_out[5]) );
  TPOAI21D0BWP12T U192 ( .A1(currentState[0]), .A2(memory_output_valid), .B(
        currentState[1]), .ZN(n70) );
  AO21D0BWP12T U193 ( .A1(memory_load_request), .A2(instruction_in[11]), .B(
        n70), .Z(instruction_out[11]) );
  AO21D0BWP12T U194 ( .A1(memory_load_request), .A2(instruction_in[15]), .B(
        n70), .Z(instruction_out[15]) );
  OA211D0BWP12T U195 ( .A1(current_pc_in[3]), .A2(n75), .B(memory_load_request), .C(n72), .Z(incremented_pc_out[3]) );
  AO21D0BWP12T U196 ( .A1(memory_load_request), .A2(instruction_in[8]), .B(n70), .Z(instruction_out[8]) );
  AO21D0BWP12T U197 ( .A1(memory_load_request), .A2(instruction_in[12]), .B(
        n70), .Z(instruction_out[12]) );
  AO21D0BWP12T U198 ( .A1(memory_load_request), .A2(instruction_in[13]), .B(
        n70), .Z(instruction_out[13]) );
  AO21D0BWP12T U199 ( .A1(memory_load_request), .A2(instruction_in[10]), .B(
        n70), .Z(instruction_out[10]) );
  AO21D0BWP12T U200 ( .A1(memory_load_request), .A2(instruction_in[9]), .B(n70), .Z(instruction_out[9]) );
  AOI211D0BWP12T U201 ( .A1(n93), .A2(n72), .B(n71), .C(n74), .ZN(
        incremented_pc_out[4]) );
  AOI211D0BWP12T U202 ( .A1(n76), .A2(n95), .B(n75), .C(n74), .ZN(
        incremented_pc_out[2]) );
  AOI21D0BWP12T U203 ( .A1(currentState[1]), .A2(current_pc_in[1]), .B(
        currentState[0]), .ZN(incremented_pc_out[1]) );
  AN2D1BWP12T U204 ( .A1(current_pc_in[0]), .A2(memory_load_request), .Z(
        incremented_pc_out[0]) );
  INVD1BWP12T U205 ( .I(reset), .ZN(n29) );
  NR2D1BWP12T U206 ( .A1(current_pc_in[3]), .A2(current_pc_in[2]), .ZN(n94) );
  ND2D1BWP12T U207 ( .A1(n94), .A2(n93), .ZN(n92) );
  NR2D1BWP12T U208 ( .A1(current_pc_in[5]), .A2(n92), .ZN(n90) );
  ND2D1BWP12T U209 ( .A1(n90), .A2(n89), .ZN(n88) );
  NR2D1BWP12T U210 ( .A1(current_pc_in[7]), .A2(n88), .ZN(n86) );
  ND2D1BWP12T U211 ( .A1(n86), .A2(n85), .ZN(n84) );
  NR2D1BWP12T U212 ( .A1(current_pc_in[9]), .A2(n84), .ZN(n82) );
  ND2D1BWP12T U213 ( .A1(n82), .A2(n81), .ZN(n80) );
  NR2D1BWP12T U214 ( .A1(current_pc_in[11]), .A2(n80), .ZN(n78) );
  AOI21D1BWP12T U215 ( .A1(currentState[0]), .A2(n97), .B(memory_load_request), 
        .ZN(n96) );
  NR2D1BWP12T U216 ( .A1(current_pc_in[12]), .A2(n78), .ZN(n77) );
  AOI211D1BWP12T U217 ( .A1(current_pc_in[12]), .A2(n78), .B(n96), .C(n77), 
        .ZN(memory_address[11]) );
  AOI21D1BWP12T U218 ( .A1(current_pc_in[11]), .A2(n80), .B(n78), .ZN(n79) );
  NR2D1BWP12T U219 ( .A1(n96), .A2(n79), .ZN(memory_address[10]) );
  OAI32D1BWP12T U220 ( .A1(n96), .A2(n82), .A3(n81), .B1(n80), .B2(n96), .ZN(
        memory_address[9]) );
  AOI21D1BWP12T U221 ( .A1(current_pc_in[9]), .A2(n84), .B(n82), .ZN(n83) );
  NR2D1BWP12T U222 ( .A1(n96), .A2(n83), .ZN(memory_address[8]) );
  OAI32D1BWP12T U223 ( .A1(n96), .A2(n86), .A3(n85), .B1(n84), .B2(n96), .ZN(
        memory_address[7]) );
  AOI21D1BWP12T U224 ( .A1(current_pc_in[7]), .A2(n88), .B(n86), .ZN(n87) );
  NR2D1BWP12T U225 ( .A1(n96), .A2(n87), .ZN(memory_address[6]) );
  OAI32D1BWP12T U226 ( .A1(n96), .A2(n90), .A3(n89), .B1(n88), .B2(n96), .ZN(
        memory_address[5]) );
  AOI21D1BWP12T U227 ( .A1(current_pc_in[5]), .A2(n92), .B(n90), .ZN(n91) );
  NR2D1BWP12T U228 ( .A1(n96), .A2(n91), .ZN(memory_address[4]) );
  OAI32D1BWP12T U229 ( .A1(n96), .A2(n94), .A3(n93), .B1(n92), .B2(n96), .ZN(
        memory_address[3]) );
  NR2D1BWP12T U230 ( .A1(current_pc_in[2]), .A2(n96), .ZN(memory_address[1])
         );
  NR2D1BWP12T U231 ( .A1(n96), .A2(n95), .ZN(memory_address[0]) );
endmodule

