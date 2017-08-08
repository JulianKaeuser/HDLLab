
module Flag_Updater ( z, n, v, c, update_z, update_n, update_v, update_c, 
        flags_old, flags );
  input [31:0] flags_old;
  output [31:0] flags;
  input z, n, v, c, update_z, update_n, update_v, update_c;


  CKBD1BWP12T U5 ( .I(flags_old[0]), .Z(flags[0]) );
  MUX2D1BWP12T U6 ( .I0(flags_old[30]), .I1(z), .S(update_z), .Z(flags[30]) );
  MUX2D1BWP12T U7 ( .I0(flags_old[29]), .I1(c), .S(update_c), .Z(flags[29]) );
  MUX2D1BWP12T U8 ( .I0(flags_old[28]), .I1(v), .S(update_v), .Z(flags[28]) );
  CKBD1BWP12T U9 ( .I(flags_old[27]), .Z(flags[27]) );
  CKBD1BWP12T U10 ( .I(flags_old[26]), .Z(flags[26]) );
  CKBD1BWP12T U11 ( .I(flags_old[25]), .Z(flags[25]) );
  CKBD1BWP12T U12 ( .I(flags_old[24]), .Z(flags[24]) );
  CKBD1BWP12T U13 ( .I(flags_old[23]), .Z(flags[23]) );
  CKBD1BWP12T U14 ( .I(flags_old[22]), .Z(flags[22]) );
  CKBD1BWP12T U15 ( .I(flags_old[21]), .Z(flags[21]) );
  CKBD1BWP12T U16 ( .I(flags_old[20]), .Z(flags[20]) );
  CKBD1BWP12T U17 ( .I(flags_old[19]), .Z(flags[19]) );
  CKBD1BWP12T U18 ( .I(flags_old[18]), .Z(flags[18]) );
  CKBD1BWP12T U19 ( .I(flags_old[17]), .Z(flags[17]) );
  CKBD1BWP12T U20 ( .I(flags_old[16]), .Z(flags[16]) );
  MUX2D1BWP12T U21 ( .I0(flags_old[31]), .I1(n), .S(update_n), .Z(flags[31])
         );
  CKBD1BWP12T U22 ( .I(flags_old[15]), .Z(flags[15]) );
  CKBD1BWP12T U23 ( .I(flags_old[14]), .Z(flags[14]) );
  CKBD1BWP12T U24 ( .I(flags_old[13]), .Z(flags[13]) );
  CKBD1BWP12T U25 ( .I(flags_old[12]), .Z(flags[12]) );
  CKBD1BWP12T U26 ( .I(flags_old[11]), .Z(flags[11]) );
  CKBD1BWP12T U27 ( .I(flags_old[10]), .Z(flags[10]) );
  CKBD1BWP12T U28 ( .I(flags_old[9]), .Z(flags[9]) );
  CKBD1BWP12T U29 ( .I(flags_old[8]), .Z(flags[8]) );
  CKBD1BWP12T U30 ( .I(flags_old[7]), .Z(flags[7]) );
  CKBD1BWP12T U31 ( .I(flags_old[6]), .Z(flags[6]) );
  CKBD1BWP12T U32 ( .I(flags_old[5]), .Z(flags[5]) );
  CKBD1BWP12T U33 ( .I(flags_old[4]), .Z(flags[4]) );
  CKBD1BWP12T U34 ( .I(flags_old[3]), .Z(flags[3]) );
  CKBD1BWP12T U35 ( .I(flags_old[2]), .Z(flags[2]) );
  CKBD1BWP12T U36 ( .I(flags_old[1]), .Z(flags[1]) );
endmodule

