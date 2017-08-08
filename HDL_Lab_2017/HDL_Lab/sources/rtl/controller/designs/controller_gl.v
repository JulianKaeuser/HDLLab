
module controller ( clk, reset, decoder_load_in, decoder_store_in, 
        fetch_load_in, decoder_src_mem_addr_in, mem_output_valid_in, 
        mem_write_ready_in, stall_mem2fetch_out, addr_select_out, 
        read_en_sel_out, word_select_out, stall_any2decoder_out, state );
  output [1:0] addr_select_out;
  output [1:0] state;
  input clk, reset, decoder_load_in, decoder_store_in, fetch_load_in,
         decoder_src_mem_addr_in, mem_output_valid_in, mem_write_ready_in;
  output stall_mem2fetch_out, read_en_sel_out, word_select_out,
         stall_any2decoder_out;
  wire   turn, n15, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29,
         n32, n33, n34;
  wire   [1:0] nextstate;

  DFSNXD1BWP12T state_reg_1_ ( .D(nextstate[1]), .CP(clk), .SDN(n15), .Q(
        state[1]), .QN(n32) );
  DFSNXD1BWP12T state_reg_0_ ( .D(nextstate[0]), .CP(clk), .SDN(n15), .Q(
        state[0]), .QN(n33) );
  DFCNXD1BWP12T turn_reg ( .D(n18), .CP(clk), .CDN(n15), .Q(turn), .QN(n34) );
  ND2D1BWP12T U25 ( .A1(state[0]), .A2(n32), .ZN(n27) );
  NR2D1BWP12T U26 ( .A1(mem_write_ready_in), .A2(n27), .ZN(n28) );
  NR2D1BWP12T U27 ( .A1(decoder_load_in), .A2(n24), .ZN(n29) );
  ND2D1BWP12T U28 ( .A1(n32), .A2(n33), .ZN(n24) );
  INVD1BWP12T U29 ( .I(decoder_store_in), .ZN(n23) );
  NR2D0BWP12T U30 ( .A1(decoder_store_in), .A2(decoder_load_in), .ZN(n19) );
  OA22D0BWP12T U31 ( .A1(n19), .A2(n24), .B1(n34), .B2(n25), .Z(n26) );
  AOI21D0BWP12T U32 ( .A1(fetch_load_in), .A2(n23), .B(decoder_load_in), .ZN(
        n20) );
  OAI22D0BWP12T U33 ( .A1(n24), .A2(n20), .B1(n25), .B2(mem_output_valid_in), 
        .ZN(nextstate[1]) );
  AOI31D0BWP12T U34 ( .A1(n29), .A2(fetch_load_in), .A3(n23), .B(n28), .ZN(n21) );
  ND2D1BWP12T U35 ( .A1(n33), .A2(state[1]), .ZN(n25) );
  AOI32D0BWP12T U36 ( .A1(turn), .A2(n21), .A3(mem_output_valid_in), .B1(n25), 
        .B2(n21), .ZN(stall_any2decoder_out) );
  CKND2D0BWP12T U37 ( .A1(n29), .A2(n23), .ZN(n22) );
  AOI32D0BWP12T U38 ( .A1(turn), .A2(n22), .A3(n33), .B1(n32), .B2(n22), .ZN(
        read_en_sel_out) );
  CKND2D0BWP12T U39 ( .A1(n26), .A2(n27), .ZN(stall_mem2fetch_out) );
  INVD1BWP12T U40 ( .I(reset), .ZN(n15) );
  CKBD1BWP12T U41 ( .I(stall_mem2fetch_out), .Z(addr_select_out[1]) );
  CKBD1BWP12T U42 ( .I(read_en_sel_out), .Z(word_select_out) );
  OAI21D1BWP12T U43 ( .A1(n27), .A2(n34), .B(n26), .ZN(n18) );
  AO21D1BWP12T U44 ( .A1(decoder_store_in), .A2(n29), .B(n28), .Z(nextstate[0]) );
  INR2D1BWP12T U45 ( .A1(stall_mem2fetch_out), .B1(decoder_src_mem_addr_in), 
        .ZN(addr_select_out[0]) );
endmodule

