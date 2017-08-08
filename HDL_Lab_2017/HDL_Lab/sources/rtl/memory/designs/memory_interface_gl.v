
module controller ( clk, reset, decoder_load_in, decoder_store_in, 
        fetch_load_in, decoder_src_mem_addr_in, mem_output_valid_in, 
        mem_write_ready_in, stall_mem2fetch_out, addr_select_out, 
        read_en_sel_out, word_select_out, stall_any2decoder_out );
  output [1:0] addr_select_out;
  input clk, reset, decoder_load_in, decoder_store_in, fetch_load_in,
         decoder_src_mem_addr_in, mem_output_valid_in, mem_write_ready_in;
  output stall_mem2fetch_out, read_en_sel_out, word_select_out,
         stall_any2decoder_out;
  wire   nextstate_0_, n18, n32, n33, n34, n48, n49, n50, n51, n52, n53, n54,
         n55, n56, n57, n58, n59, n60;

  DFSNXD1BWP12T state_reg_0_ ( .D(nextstate_0_), .CP(clk), .SDN(n48), .Q(n60), 
        .QN(n33) );
  DFCNXD1BWP12T turn_reg ( .D(n18), .CP(clk), .CDN(n48), .QN(n34) );
  DFCNQD1BWP12T state_reg_1_ ( .D(n50), .CP(clk), .CDN(n48), .Q(n32) );
  INVD1BWP12T U46 ( .I(decoder_store_in), .ZN(n52) );
  ND2D1BWP12T U47 ( .A1(n32), .A2(n60), .ZN(n59) );
  OAI22D1BWP12T U48 ( .A1(mem_write_ready_in), .A2(n59), .B1(n52), .B2(n54), 
        .ZN(nextstate_0_) );
  OAI211D0BWP12T U49 ( .A1(decoder_load_in), .A2(decoder_store_in), .B(n32), 
        .C(n33), .ZN(n49) );
  OA31D0BWP12T U50 ( .A1(n60), .A2(n32), .A3(n34), .B(n49), .Z(n58) );
  AO21D1BWP12T U51 ( .A1(n51), .A2(n56), .B(n60), .Z(n50) );
  MAOI22D0BWP12T U52 ( .A1(n32), .A2(decoder_load_in), .B1(mem_output_valid_in), .B2(n32), .ZN(n51) );
  ND3D1BWP12T U53 ( .A1(n32), .A2(fetch_load_in), .A3(n52), .ZN(n56) );
  CKND2D0BWP12T U54 ( .A1(n58), .A2(n59), .ZN(stall_mem2fetch_out) );
  IND3D1BWP12T U55 ( .A1(decoder_load_in), .B1(n32), .B2(n33), .ZN(n54) );
  NR2D0BWP12T U56 ( .A1(n34), .A2(n60), .ZN(n53) );
  OAI22D0BWP12T U57 ( .A1(decoder_store_in), .A2(n54), .B1(n32), .B2(n53), 
        .ZN(read_en_sel_out) );
  INR2D0BWP12T U58 ( .A1(mem_output_valid_in), .B1(n34), .ZN(n55) );
  OAI22D0BWP12T U59 ( .A1(decoder_load_in), .A2(n56), .B1(n32), .B2(n55), .ZN(
        n57) );
  MOAI22D0BWP12T U60 ( .A1(mem_write_ready_in), .A2(n59), .B1(n33), .B2(n57), 
        .ZN(stall_any2decoder_out) );
  INVD1BWP12T U61 ( .I(reset), .ZN(n48) );
  CKBD1BWP12T U62 ( .I(stall_mem2fetch_out), .Z(addr_select_out[1]) );
  CKBD1BWP12T U63 ( .I(read_en_sel_out), .Z(word_select_out) );
  OAI21D1BWP12T U64 ( .A1(n34), .A2(n59), .B(n58), .ZN(n18) );
  INR2D1BWP12T U65 ( .A1(stall_mem2fetch_out), .B1(decoder_src_mem_addr_in), 
        .ZN(addr_select_out[0]) );
endmodule

