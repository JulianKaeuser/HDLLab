
module irdecode ( clock, reset, instruction, instruction_valid, flag_n, flag_z, 
        flag_c, flag_v, memory_write_finished, memory_read_finished, 
        stall_from_instructionfetch, operand_a, operand_b, offset_a, offset_b, 
        alu_opcode, pc_mask_bit, update_flag_n, update_flag_z, update_flag_c, 
        update_flag_v, alu_stack_write_to_reg, alu_stack_write_to_reg_enable, 
        memory_write_to_reg, memory_write_to_reg_enable, memory_store_data_reg, 
        memory_store_address_reg, memory_address_source_is_reg, 
        load_store_width, memorycontroller_sign_extend, memory_load_request, 
        memory_store_request, stack_push_request, stack_pop_request, 
        stall_to_instructionfetch, decoder_pc_update );
  input [15:0] instruction;
  output [4:0] operand_a;
  output [4:0] operand_b;
  output [31:0] offset_a;
  output [31:0] offset_b;
  output [4:0] alu_opcode;
  output [4:0] alu_stack_write_to_reg;
  output [4:0] memory_write_to_reg;
  output [4:0] memory_store_data_reg;
  output [4:0] memory_store_address_reg;
  output [1:0] load_store_width;
  input clock, reset, instruction_valid, flag_n, flag_z, flag_c, flag_v,
         memory_write_finished, memory_read_finished,
         stall_from_instructionfetch;
  output pc_mask_bit, update_flag_n, update_flag_z, update_flag_c,
         update_flag_v, alu_stack_write_to_reg_enable,
         memory_write_to_reg_enable, memory_address_source_is_reg,
         memorycontroller_sign_extend, memory_load_request,
         memory_store_request, stack_push_request, stack_pop_request,
         stall_to_instructionfetch, decoder_pc_update;
  wire   next_pc_mask_bit, next_update_flag_n, next_update_flag_c,
         next_update_flag_v, next_alu_stack_write_to_reg_enable,
         next_memory_write_to_reg_enable, next_memory_address_source_is_reg,
         next_memorycontroller_sign_extend, next_memory_load_request,
         next_memory_store_request, next_stall_to_instructionfetch,
         next_decoder_pc_update, N1677, N1679, N1680, N1683, N1684, n495, n496,
         n498, n532, n533, n534, n535, n536, n537, n538, n539, n540, n541,
         n542, n543, n544, n545, n546, n547, n548, n549, n550, n551, n552,
         n553, n554, n555, n556, n557, n558, n559, n560, n561, n562, n563,
         n564, n565, n566, n567, n568, n569, n570, n571, n572, n573, n574,
         n575, n576, n577, n578, n579, n580, n581, n582, n583, n584, n585,
         n586, n587, n588, n589, n590, n591, n592, n593, n594, n595, n596,
         n597, n598, n599, n600, n601, n602, n603, n604, n605, n606, n607,
         n608, n609, n610, n611, n612, n613, n614, n615, n616, n617, n618,
         n619, n620, n621, n622, n623, n624, n625, n626, n627, n628, n629,
         n630, n631, n632, n633, n634, n635, n636, n637, n638, n639, n640,
         n641, n642, n643, n644, n645, n646, n647, n648, n649, n650, n651,
         n652, n653, n654, n655, n656, n657, n658, n659, n660, n661, n662,
         n663, n664, n665, n666, n667, n668, n669, n670, n671, n672, n673,
         n674, n675, n676, n677, n678, n679, n680, n681, n682, n683, n684,
         n685, n686, n687, n688, n689, n690, n691, n692, n693, n694, n695,
         n696, n697, n698, n699, n700, n701, n702, n703, n704, n705, n706,
         n707, n708, n709, n710, n711, n712, n713, n714, n715, n716, n717,
         n718, n719, n720, n721, n722, n723, n724, n725, n726, n727, n728,
         n729, n730, n731, n732, n733, n734, n735, n736, n737, n738, n739,
         n740, n741, n742, n743, n744, n745, n746, n747, n748, n749, n750,
         n751, n752, n753, n754, n755, n756, n757, n758, n759, n760, n761,
         n762, n763, n764, n765, n766, n767, n768, n769, n770, n771, n772,
         n773, n774, n775, n776, n777, n778, n779, n780, n781, n782, n783,
         n784, n785, n786, n787, n788, n789, n790, n791, n792, n793, n794,
         n795, n796, n797, n798, n799, n800, n801, n802, n803, n804, n805,
         n806, n807, n808, n809, n810, n811, n812, n813, n814, n815, n816,
         n817, n818, n819, n820, n821, n822, n823, n824, n825, n826, n827,
         n828, n829, n830, n831, n832, n833, n834, n835, n836, n837, n838,
         n839, n840, n841, n842, n843, n844, n845, n846, n847, n848, n849,
         n850, n851, n852, n853, n854, n855, n856, n857, n858, n859, n860,
         n861, n862, n863, n864, n865, n866, n867, n868, n869, n870, n871,
         n872, n873, n874, n875, n876, n877, n878, n879, n880, n881, n882,
         n883, n884, n885, n886, n887, n888, n889, n890, n891, n892, n893,
         n894, n895, n896, n897, n898, n899, n900, n901, n902, n903, n904,
         n905, n906, n907, n908, n909, n910, n911, n912, n913, n914, n915,
         n916, n917, n918, n919, n920, n921, n922, n923, n924;
  wire   [4:0] next_operand_a;
  wire   [4:0] next_operand_b;
  wire   [31:0] next_offset_b;
  wire   [4:0] next_alu_opcode;
  wire   [4:0] next_alu_stack_write_to_reg;
  wire   [4:0] next_memory_write_to_reg;
  wire   [4:0] next_memory_store_data_reg;
  wire   [4:0] next_memory_store_address_reg;
  wire   [1:0] next_load_store_width;
  wire   [7:0] itstate;
  wire   [7:0] next_itstate;

  CKAN2D2BWP12T C4580 ( .A1(next_memory_load_request), .A2(n496), .Z(N1684) );
  CKAN2D2BWP12T C4578 ( .A1(next_memory_store_request), .A2(n495), .Z(N1683)
         );
  CKAN2D2BWP12T C4574 ( .A1(next_memory_load_request), .A2(n496), .Z(N1680) );
  CKAN2D2BWP12T C4572 ( .A1(next_memory_store_request), .A2(n495), .Z(N1679)
         );
  OR2XD4BWP12T C4568 ( .A1(next_stall_to_instructionfetch), .A2(
        instruction_valid), .Z(N1677) );
  DFQD1BWP12T itstate_reg_0_ ( .D(next_itstate[0]), .CP(clock), .Q(itstate[0])
         );
  DFQD1BWP12T itstate_reg_7_ ( .D(next_itstate[7]), .CP(clock), .Q(itstate[7])
         );
  DFQD1BWP12T stall_to_instructionfetch_reg ( .D(
        next_stall_to_instructionfetch), .CP(clock), .Q(
        stall_to_instructionfetch) );
  DFQD1BWP12T alu_stack_write_to_reg_enable_reg ( .D(
        next_alu_stack_write_to_reg_enable), .CP(clock), .Q(
        alu_stack_write_to_reg_enable) );
  DFQD1BWP12T memory_load_request_reg ( .D(next_memory_load_request), .CP(
        clock), .Q(memory_load_request) );
  DFQD1BWP12T offset_b_reg_0_ ( .D(next_offset_b[0]), .CP(clock), .Q(
        offset_b[0]) );
  DFQD1BWP12T offset_b_reg_1_ ( .D(next_offset_b[1]), .CP(clock), .Q(
        offset_b[1]) );
  DFQD1BWP12T offset_b_reg_2_ ( .D(next_offset_b[2]), .CP(clock), .Q(
        offset_b[2]) );
  DFQD1BWP12T offset_b_reg_3_ ( .D(next_offset_b[3]), .CP(clock), .Q(
        offset_b[3]) );
  DFQD1BWP12T offset_b_reg_4_ ( .D(next_offset_b[4]), .CP(clock), .Q(
        offset_b[4]) );
  DFQD1BWP12T offset_b_reg_5_ ( .D(next_offset_b[5]), .CP(clock), .Q(
        offset_b[5]) );
  DFQD1BWP12T offset_b_reg_6_ ( .D(next_offset_b[6]), .CP(clock), .Q(
        offset_b[6]) );
  DFQD1BWP12T offset_b_reg_7_ ( .D(next_offset_b[7]), .CP(clock), .Q(
        offset_b[7]) );
  DFQD1BWP12T offset_b_reg_8_ ( .D(next_offset_b[8]), .CP(clock), .Q(
        offset_b[8]) );
  DFQD1BWP12T offset_b_reg_9_ ( .D(next_offset_b[9]), .CP(clock), .Q(
        offset_b[9]) );
  DFQD1BWP12T offset_b_reg_10_ ( .D(next_offset_b[10]), .CP(clock), .Q(
        offset_b[10]) );
  DFQD1BWP12T offset_b_reg_11_ ( .D(next_offset_b[11]), .CP(clock), .Q(
        offset_b[11]) );
  DFQD1BWP12T offset_b_reg_12_ ( .D(next_offset_b[12]), .CP(clock), .Q(
        offset_b[12]) );
  DFQD1BWP12T offset_b_reg_13_ ( .D(next_offset_b[13]), .CP(clock), .Q(
        offset_b[13]) );
  DFQD1BWP12T offset_b_reg_14_ ( .D(next_offset_b[14]), .CP(clock), .Q(
        offset_b[14]) );
  DFQD1BWP12T offset_b_reg_15_ ( .D(next_offset_b[15]), .CP(clock), .Q(
        offset_b[15]) );
  DFQD1BWP12T offset_b_reg_16_ ( .D(next_offset_b[16]), .CP(clock), .Q(
        offset_b[16]) );
  DFQD1BWP12T offset_b_reg_17_ ( .D(next_offset_b[17]), .CP(clock), .Q(
        offset_b[17]) );
  DFQD1BWP12T offset_b_reg_18_ ( .D(next_offset_b[18]), .CP(clock), .Q(
        offset_b[18]) );
  DFQD1BWP12T offset_b_reg_19_ ( .D(next_offset_b[19]), .CP(clock), .Q(
        offset_b[19]) );
  DFQD1BWP12T offset_b_reg_20_ ( .D(next_offset_b[20]), .CP(clock), .Q(
        offset_b[20]) );
  DFQD1BWP12T offset_b_reg_21_ ( .D(next_offset_b[21]), .CP(clock), .Q(
        offset_b[21]) );
  DFQD1BWP12T offset_b_reg_22_ ( .D(next_offset_b[22]), .CP(clock), .Q(
        offset_b[22]) );
  DFQD1BWP12T offset_b_reg_23_ ( .D(next_offset_b[23]), .CP(clock), .Q(
        offset_b[23]) );
  DFQD1BWP12T offset_b_reg_24_ ( .D(next_offset_b[24]), .CP(clock), .Q(
        offset_b[24]) );
  DFQD1BWP12T offset_b_reg_25_ ( .D(next_offset_b[25]), .CP(clock), .Q(
        offset_b[25]) );
  DFQD1BWP12T offset_b_reg_26_ ( .D(next_offset_b[26]), .CP(clock), .Q(
        offset_b[26]) );
  DFQD1BWP12T offset_b_reg_27_ ( .D(next_offset_b[27]), .CP(clock), .Q(
        offset_b[27]) );
  DFQD1BWP12T offset_b_reg_28_ ( .D(next_offset_b[28]), .CP(clock), .Q(
        offset_b[28]) );
  DFQD1BWP12T offset_b_reg_29_ ( .D(next_offset_b[29]), .CP(clock), .Q(
        offset_b[29]) );
  DFQD1BWP12T offset_b_reg_30_ ( .D(next_offset_b[30]), .CP(clock), .Q(
        offset_b[30]) );
  DFQD1BWP12T offset_b_reg_31_ ( .D(next_offset_b[31]), .CP(clock), .Q(
        offset_b[31]) );
  DFQD1BWP12T operand_b_reg_0_ ( .D(next_operand_b[0]), .CP(clock), .Q(
        operand_b[0]) );
  DFQD1BWP12T operand_b_reg_1_ ( .D(next_operand_b[1]), .CP(clock), .Q(
        operand_b[1]) );
  DFQD1BWP12T operand_b_reg_2_ ( .D(next_operand_b[2]), .CP(clock), .Q(
        operand_b[2]) );
  DFQD1BWP12T operand_b_reg_3_ ( .D(next_operand_b[3]), .CP(clock), .Q(
        operand_b[3]) );
  DFQD1BWP12T operand_b_reg_4_ ( .D(next_operand_b[4]), .CP(clock), .Q(
        operand_b[4]) );
  DFQD1BWP12T memorycontroller_sign_extend_reg ( .D(
        next_memorycontroller_sign_extend), .CP(clock), .Q(
        memorycontroller_sign_extend) );
  DFQD1BWP12T load_store_width_reg_0_ ( .D(next_load_store_width[0]), .CP(
        clock), .Q(load_store_width[0]) );
  DFQD1BWP12T load_store_width_reg_1_ ( .D(next_load_store_width[1]), .CP(
        clock), .Q(load_store_width[1]) );
  DFQD1BWP12T memory_address_source_is_reg_reg ( .D(
        next_memory_address_source_is_reg), .CP(clock), .Q(
        memory_address_source_is_reg) );
  DFQD1BWP12T memory_store_address_reg_reg_0_ ( .D(
        next_memory_store_address_reg[0]), .CP(clock), .Q(
        memory_store_address_reg[0]) );
  DFQD1BWP12T memory_store_address_reg_reg_1_ ( .D(
        next_memory_store_address_reg[1]), .CP(clock), .Q(
        memory_store_address_reg[1]) );
  DFQD1BWP12T memory_store_address_reg_reg_2_ ( .D(
        next_memory_store_address_reg[2]), .CP(clock), .Q(
        memory_store_address_reg[2]) );
  DFQD1BWP12T memory_store_address_reg_reg_3_ ( .D(
        next_memory_store_address_reg[3]), .CP(clock), .Q(
        memory_store_address_reg[3]) );
  DFQD1BWP12T memory_store_address_reg_reg_4_ ( .D(
        next_memory_store_address_reg[4]), .CP(clock), .Q(
        memory_store_address_reg[4]) );
  DFQD1BWP12T memory_store_data_reg_reg_0_ ( .D(next_memory_store_data_reg[0]), 
        .CP(clock), .Q(memory_store_data_reg[0]) );
  DFQD1BWP12T memory_store_data_reg_reg_1_ ( .D(next_memory_store_data_reg[1]), 
        .CP(clock), .Q(memory_store_data_reg[1]) );
  DFQD1BWP12T memory_store_data_reg_reg_2_ ( .D(next_memory_store_data_reg[2]), 
        .CP(clock), .Q(memory_store_data_reg[2]) );
  DFQD1BWP12T memory_store_data_reg_reg_3_ ( .D(next_memory_store_data_reg[3]), 
        .CP(clock), .Q(memory_store_data_reg[3]) );
  DFQD1BWP12T memory_store_data_reg_reg_4_ ( .D(next_memory_store_data_reg[4]), 
        .CP(clock), .Q(memory_store_data_reg[4]) );
  DFQD1BWP12T memory_write_to_reg_enable_reg ( .D(
        next_memory_write_to_reg_enable), .CP(clock), .Q(
        memory_write_to_reg_enable) );
  DFQD1BWP12T memory_write_to_reg_reg_0_ ( .D(next_memory_write_to_reg[0]), 
        .CP(clock), .Q(memory_write_to_reg[0]) );
  DFQD1BWP12T memory_write_to_reg_reg_1_ ( .D(next_memory_write_to_reg[1]), 
        .CP(clock), .Q(memory_write_to_reg[1]) );
  DFQD1BWP12T memory_write_to_reg_reg_2_ ( .D(next_memory_write_to_reg[2]), 
        .CP(clock), .Q(memory_write_to_reg[2]) );
  DFQD1BWP12T memory_write_to_reg_reg_3_ ( .D(next_memory_write_to_reg[3]), 
        .CP(clock), .Q(memory_write_to_reg[3]) );
  DFQD1BWP12T memory_write_to_reg_reg_4_ ( .D(next_memory_write_to_reg[4]), 
        .CP(clock), .Q(memory_write_to_reg[4]) );
  DFQD1BWP12T alu_stack_write_to_reg_reg_0_ ( .D(
        next_alu_stack_write_to_reg[0]), .CP(clock), .Q(
        alu_stack_write_to_reg[0]) );
  DFQD1BWP12T alu_stack_write_to_reg_reg_1_ ( .D(
        next_alu_stack_write_to_reg[1]), .CP(clock), .Q(
        alu_stack_write_to_reg[1]) );
  DFQD1BWP12T alu_stack_write_to_reg_reg_2_ ( .D(
        next_alu_stack_write_to_reg[2]), .CP(clock), .Q(
        alu_stack_write_to_reg[2]) );
  DFQD1BWP12T alu_stack_write_to_reg_reg_3_ ( .D(
        next_alu_stack_write_to_reg[3]), .CP(clock), .Q(
        alu_stack_write_to_reg[3]) );
  DFQD1BWP12T alu_stack_write_to_reg_reg_4_ ( .D(
        next_alu_stack_write_to_reg[4]), .CP(clock), .Q(
        alu_stack_write_to_reg[4]) );
  DFQD1BWP12T decoder_pc_update_reg ( .D(next_decoder_pc_update), .CP(clock), 
        .Q(decoder_pc_update) );
  DFQD1BWP12T pc_mask_bit_reg ( .D(next_pc_mask_bit), .CP(clock), .Q(
        pc_mask_bit) );
  DFQD1BWP12T operand_a_reg_0_ ( .D(next_operand_a[0]), .CP(clock), .Q(
        operand_a[0]) );
  DFQD1BWP12T operand_a_reg_1_ ( .D(next_operand_a[1]), .CP(clock), .Q(
        operand_a[1]) );
  DFQD1BWP12T operand_a_reg_2_ ( .D(next_operand_a[2]), .CP(clock), .Q(
        operand_a[2]) );
  DFQD1BWP12T operand_a_reg_3_ ( .D(next_operand_a[3]), .CP(clock), .Q(
        operand_a[3]) );
  DFQD1BWP12T operand_a_reg_4_ ( .D(next_operand_a[4]), .CP(clock), .Q(
        operand_a[4]) );
  DFQD1BWP12T alu_opcode_reg_0_ ( .D(next_alu_opcode[0]), .CP(clock), .Q(
        alu_opcode[0]) );
  DFQD1BWP12T alu_opcode_reg_1_ ( .D(next_alu_opcode[1]), .CP(clock), .Q(
        alu_opcode[1]) );
  DFQD1BWP12T alu_opcode_reg_2_ ( .D(next_alu_opcode[2]), .CP(clock), .Q(
        alu_opcode[2]) );
  DFQD1BWP12T alu_opcode_reg_3_ ( .D(next_alu_opcode[3]), .CP(clock), .Q(
        alu_opcode[3]) );
  DFQD1BWP12T alu_opcode_reg_4_ ( .D(next_alu_opcode[4]), .CP(clock), .Q(
        alu_opcode[4]) );
  DFQD1BWP12T memory_store_request_reg ( .D(next_memory_store_request), .CP(
        clock), .Q(memory_store_request) );
  DFQD1BWP12T itstate_reg_5_ ( .D(next_itstate[5]), .CP(clock), .Q(itstate[5])
         );
  DFQD1BWP12T itstate_reg_6_ ( .D(next_itstate[6]), .CP(clock), .Q(itstate[6])
         );
  DFQD1BWP12T itstate_reg_1_ ( .D(next_itstate[1]), .CP(clock), .Q(itstate[1])
         );
  DFQD1BWP12T itstate_reg_2_ ( .D(next_itstate[2]), .CP(clock), .Q(itstate[2])
         );
  DFQD1BWP12T itstate_reg_3_ ( .D(next_itstate[3]), .CP(clock), .Q(itstate[3])
         );
  DFQD1BWP12T itstate_reg_4_ ( .D(next_itstate[4]), .CP(clock), .Q(itstate[4])
         );
  DFQD1BWP12T update_flag_v_reg ( .D(next_update_flag_v), .CP(clock), .Q(
        update_flag_v) );
  DFQD1BWP12T update_flag_c_reg ( .D(next_update_flag_c), .CP(clock), .Q(
        update_flag_c) );
  DFQD1BWP12T update_flag_z_reg ( .D(next_update_flag_n), .CP(clock), .Q(
        update_flag_z) );
  TIEHBWP12T U620 ( .Z(n498) );
  INVD1BWP12T U621 ( .I(n498), .ZN(stack_pop_request) );
  INVD1BWP12T U622 ( .I(n498), .ZN(stack_push_request) );
  INVD1BWP12T U623 ( .I(n498), .ZN(offset_a[0]) );
  INVD1BWP12T U624 ( .I(n498), .ZN(offset_a[1]) );
  INVD1BWP12T U625 ( .I(n498), .ZN(offset_a[2]) );
  INVD1BWP12T U626 ( .I(n498), .ZN(offset_a[3]) );
  INVD1BWP12T U627 ( .I(n498), .ZN(offset_a[4]) );
  INVD1BWP12T U628 ( .I(n498), .ZN(offset_a[5]) );
  INVD1BWP12T U629 ( .I(n498), .ZN(offset_a[6]) );
  INVD1BWP12T U630 ( .I(n498), .ZN(offset_a[7]) );
  INVD1BWP12T U631 ( .I(n498), .ZN(offset_a[8]) );
  INVD1BWP12T U632 ( .I(n498), .ZN(offset_a[9]) );
  INVD1BWP12T U633 ( .I(n498), .ZN(offset_a[10]) );
  INVD1BWP12T U634 ( .I(n498), .ZN(offset_a[11]) );
  INVD1BWP12T U635 ( .I(n498), .ZN(offset_a[12]) );
  INVD1BWP12T U636 ( .I(n498), .ZN(offset_a[13]) );
  INVD1BWP12T U637 ( .I(n498), .ZN(offset_a[14]) );
  INVD1BWP12T U638 ( .I(n498), .ZN(offset_a[15]) );
  INVD1BWP12T U639 ( .I(n498), .ZN(offset_a[16]) );
  INVD1BWP12T U640 ( .I(n498), .ZN(offset_a[17]) );
  INVD1BWP12T U641 ( .I(n498), .ZN(offset_a[18]) );
  INVD1BWP12T U642 ( .I(n498), .ZN(offset_a[19]) );
  INVD1BWP12T U643 ( .I(n498), .ZN(offset_a[20]) );
  INVD1BWP12T U644 ( .I(n498), .ZN(offset_a[21]) );
  INVD1BWP12T U645 ( .I(n498), .ZN(offset_a[22]) );
  INVD1BWP12T U646 ( .I(n498), .ZN(offset_a[23]) );
  INVD1BWP12T U647 ( .I(n498), .ZN(offset_a[24]) );
  INVD1BWP12T U648 ( .I(n498), .ZN(offset_a[25]) );
  INVD1BWP12T U649 ( .I(n498), .ZN(offset_a[26]) );
  INVD1BWP12T U650 ( .I(n498), .ZN(offset_a[27]) );
  INVD1BWP12T U651 ( .I(n498), .ZN(offset_a[28]) );
  INVD1BWP12T U652 ( .I(n498), .ZN(offset_a[29]) );
  INVD1BWP12T U653 ( .I(n498), .ZN(offset_a[30]) );
  INVD1BWP12T U654 ( .I(n498), .ZN(offset_a[31]) );
  NR2D1BWP12T U655 ( .A1(n580), .A2(n577), .ZN(n578) );
  AOI21D1BWP12T U656 ( .A1(n570), .A2(n569), .B(n903), .ZN(n580) );
  AO21D1BWP12T U657 ( .A1(n862), .A2(n879), .B(n688), .Z(n735) );
  OAI21D1BWP12T U658 ( .A1(n889), .A2(n824), .B(n883), .ZN(n842) );
  IOA21D1BWP12T U659 ( .A1(n862), .A2(n872), .B(n812), .ZN(n657) );
  NR2D1BWP12T U660 ( .A1(n819), .A2(n889), .ZN(n917) );
  INVD1BWP12T U661 ( .I(n917), .ZN(n809) );
  NR2D1BWP12T U662 ( .A1(instruction[1]), .A2(instruction[0]), .ZN(n590) );
  NR2D1BWP12T U663 ( .A1(instruction[3]), .A2(instruction[2]), .ZN(n589) );
  NR2D1BWP12T U664 ( .A1(itstate[6]), .A2(itstate[7]), .ZN(n573) );
  INVD1BWP12T U665 ( .I(n591), .ZN(n602) );
  NR3D1BWP12T U666 ( .A1(itstate[0]), .A2(itstate[2]), .A3(itstate[1]), .ZN(
        n618) );
  NR2D1BWP12T U667 ( .A1(n814), .A2(n583), .ZN(n630) );
  NR2D1BWP12T U668 ( .A1(instruction[11]), .A2(instruction[12]), .ZN(n666) );
  ND2D1BWP12T U669 ( .A1(n678), .A2(n677), .ZN(n789) );
  INVD1BWP12T U670 ( .I(n662), .ZN(n810) );
  ND2D1BWP12T U671 ( .A1(n678), .A2(n855), .ZN(n645) );
  NR2D1BWP12T U672 ( .A1(n633), .A2(n731), .ZN(n649) );
  NR4D0BWP12T U673 ( .A1(n850), .A2(n769), .A3(n857), .A4(n664), .ZN(n662) );
  INVD1BWP12T U674 ( .I(instruction[14]), .ZN(n587) );
  INVD1BWP12T U675 ( .I(n842), .ZN(n665) );
  NR2D1BWP12T U676 ( .A1(n906), .A2(n830), .ZN(n686) );
  NR2D1BWP12T U677 ( .A1(n802), .A2(n781), .ZN(n678) );
  ND2D1BWP12T U678 ( .A1(instruction[12]), .A2(n585), .ZN(n677) );
  INVD1BWP12T U679 ( .I(reset), .ZN(n614) );
  ND2D1BWP12T U680 ( .A1(instruction[13]), .A2(instruction[14]), .ZN(n584) );
  INVD1BWP12T U681 ( .I(instruction[15]), .ZN(n586) );
  NR2D1BWP12T U682 ( .A1(instruction[13]), .A2(n670), .ZN(n790) );
  ND3D1BWP12T U683 ( .A1(n910), .A2(instruction[10]), .A3(n630), .ZN(n691) );
  INVD1BWP12T U684 ( .I(n686), .ZN(n765) );
  INR3D0BWP12T U685 ( .A1(n630), .B1(n912), .B2(n699), .ZN(n617) );
  ND2D1BWP12T U686 ( .A1(n590), .A2(n589), .ZN(n637) );
  INVD1BWP12T U687 ( .I(n616), .ZN(n615) );
  ND2D1BWP12T U688 ( .A1(n587), .A2(n586), .ZN(n670) );
  ND3D1BWP12T U689 ( .A1(n587), .A2(instruction[13]), .A3(instruction[15]), 
        .ZN(n583) );
  ND2D1BWP12T U690 ( .A1(instruction[0]), .A2(n604), .ZN(n609) );
  AOI21D1BWP12T U691 ( .A1(n717), .A2(n711), .B(n723), .ZN(n799) );
  INVD1BWP12T U692 ( .I(n670), .ZN(n796) );
  NR2D1BWP12T U693 ( .A1(n696), .A2(n816), .ZN(n717) );
  INVD1BWP12T U694 ( .I(n621), .ZN(n620) );
  ND2D1BWP12T U695 ( .A1(n713), .A2(n770), .ZN(n767) );
  NR2D1BWP12T U696 ( .A1(n586), .A2(n584), .ZN(n813) );
  INVD1BWP12T U697 ( .I(instruction[12]), .ZN(n814) );
  ND2D1BWP12T U698 ( .A1(n868), .A2(n906), .ZN(n816) );
  OAI22D1BWP12T U699 ( .A1(n687), .A2(n907), .B1(n765), .B2(n710), .ZN(n723)
         );
  ND2D1BWP12T U700 ( .A1(instruction[12]), .A2(n813), .ZN(n771) );
  OAI31D1BWP12T U701 ( .A1(n623), .A2(n644), .A3(n603), .B(n882), .ZN(n779) );
  INVD1BWP12T U702 ( .I(n816), .ZN(n795) );
  AOI22D1BWP12T U703 ( .A1(n630), .A2(n629), .B1(n690), .B2(n813), .ZN(n845)
         );
  AOI22D1BWP12T U704 ( .A1(instruction[9]), .A2(n686), .B1(n666), .B2(n754), 
        .ZN(n825) );
  ND2D1BWP12T U705 ( .A1(n585), .A2(n666), .ZN(n830) );
  NR2D1BWP12T U706 ( .A1(n789), .A2(n849), .ZN(n763) );
  ND2D1BWP12T U707 ( .A1(n585), .A2(n690), .ZN(n808) );
  ND2D1BWP12T U708 ( .A1(n737), .A2(n649), .ZN(n812) );
  AOI22D1BWP12T U709 ( .A1(instruction[11]), .A2(n645), .B1(n804), .B2(n613), 
        .ZN(n660) );
  AOI211D1BWP12T U710 ( .A1(instruction[2]), .A2(n645), .B(n810), .C(n639), 
        .ZN(n659) );
  INVD1BWP12T U711 ( .I(n652), .ZN(n658) );
  ND2D1BWP12T U712 ( .A1(n785), .A2(n889), .ZN(n883) );
  MOAI22D0BWP12T U713 ( .A1(n801), .A2(n613), .B1(n874), .B2(n645), .ZN(n749)
         );
  ND2D1BWP12T U714 ( .A1(n917), .A2(n874), .ZN(n746) );
  INVD1BWP12T U715 ( .I(n640), .ZN(n667) );
  NR2D1BWP12T U716 ( .A1(n737), .A2(n871), .ZN(n923) );
  NR2D1BWP12T U717 ( .A1(n809), .A2(n787), .ZN(n847) );
  NR4D0BWP12T U718 ( .A1(n587), .A2(n586), .A3(instruction[12]), .A4(
        instruction[13]), .ZN(n858) );
  OAI21D1BWP12T U719 ( .A1(n826), .A2(n889), .B(n665), .ZN(n860) );
  NR2D1BWP12T U720 ( .A1(n910), .A2(n677), .ZN(n804) );
  INVD1BWP12T U721 ( .I(n804), .ZN(n801) );
  NR2D1BWP12T U722 ( .A1(n692), .A2(n782), .ZN(n788) );
  INVD1BWP12T U723 ( .I(n691), .ZN(n882) );
  INVD1BWP12T U724 ( .I(n830), .ZN(n868) );
  ND2D1BWP12T U725 ( .A1(n677), .A2(n713), .ZN(n867) );
  AOI21D1BWP12T U726 ( .A1(n862), .A2(n861), .B(n860), .ZN(n922) );
  NR2D1BWP12T U727 ( .A1(n771), .A2(n746), .ZN(n741) );
  ND2D1BWP12T U728 ( .A1(n851), .A2(n848), .ZN(n742) );
  ND2D1BWP12T U729 ( .A1(n808), .A2(n652), .ZN(n849) );
  OAI21D1BWP12T U730 ( .A1(N1683), .A2(N1684), .B(n614), .ZN(n785) );
  ND2D1BWP12T U731 ( .A1(n917), .A2(instruction[7]), .ZN(n783) );
  INVD1BWP12T U732 ( .I(instruction[5]), .ZN(n902) );
  NR3D1BWP12T U733 ( .A1(n769), .A2(n850), .A3(n849), .ZN(n914) );
  INVD1BWP12T U734 ( .I(instruction[2]), .ZN(n913) );
  INVD1BWP12T U735 ( .I(instruction[3]), .ZN(n915) );
  INVD1BWP12T U736 ( .I(instruction[4]), .ZN(n908) );
  NR4D0BWP12T U737 ( .A1(instruction[12]), .A2(instruction[13]), .A3(
        instruction[14]), .A4(n586), .ZN(n802) );
  NR2D1BWP12T U738 ( .A1(instruction[15]), .A2(n584), .ZN(n781) );
  NR2D1BWP12T U739 ( .A1(n851), .A2(n719), .ZN(n916) );
  INVD1BWP12T U740 ( .I(instruction[1]), .ZN(n759) );
  INVD1BWP12T U741 ( .I(instruction[6]), .ZN(n899) );
  INVD1BWP12T U742 ( .I(n783), .ZN(n848) );
  NR2D1BWP12T U743 ( .A1(n882), .A2(n858), .ZN(n674) );
  ND2D1BWP12T U744 ( .A1(instruction[13]), .A2(n796), .ZN(n907) );
  ND2D1BWP12T U745 ( .A1(flag_c), .A2(n698), .ZN(n694) );
  MOAI22D0BWP12T U746 ( .A1(flag_n), .A2(flag_v), .B1(flag_n), .B2(flag_v), 
        .ZN(n695) );
  ND2D1BWP12T U747 ( .A1(n695), .A2(n698), .ZN(n693) );
  NR4D0BWP12T U748 ( .A1(instruction[11]), .A2(instruction[12]), .A3(n586), 
        .A4(n584), .ZN(n719) );
  AN3XD1BWP12T U749 ( .A1(n568), .A2(instruction[12]), .A3(instruction[15]), 
        .Z(n851) );
  INVD1BWP12T U750 ( .I(flag_z), .ZN(n698) );
  ND3D1BWP12T U751 ( .A1(instruction[11]), .A2(instruction[10]), .A3(
        instruction[9]), .ZN(n699) );
  OAI32D1BWP12T U752 ( .A1(n790), .A2(n715), .A3(n696), .B1(n795), .B2(n790), 
        .ZN(n700) );
  INVD1BWP12T U753 ( .I(instruction[10]), .ZN(n906) );
  INVD1BWP12T U754 ( .I(instruction[9]), .ZN(n910) );
  INVD1BWP12T U755 ( .I(instruction[8]), .ZN(n912) );
  ND2D1BWP12T U756 ( .A1(n620), .A2(n637), .ZN(n901) );
  NR2D1BWP12T U757 ( .A1(n896), .A2(n895), .ZN(n904) );
  INVD1BWP12T U758 ( .I(instruction[7]), .ZN(n897) );
  ND2D1BWP12T U759 ( .A1(n615), .A2(n617), .ZN(n621) );
  OAI22D1BWP12T U760 ( .A1(reset), .A2(n615), .B1(n637), .B2(n621), .ZN(n895)
         );
  INVD1BWP12T U761 ( .I(instruction[0]), .ZN(n831) );
  NR2D1BWP12T U762 ( .A1(n716), .A2(n582), .ZN(n819) );
  ND2D1BWP12T U763 ( .A1(n830), .A2(n670), .ZN(n857) );
  NR2D1BWP12T U764 ( .A1(instruction[12]), .A2(n583), .ZN(n850) );
  INVD1BWP12T U765 ( .I(n862), .ZN(n889) );
  AOI21D1BWP12T U766 ( .A1(n658), .A2(n874), .B(n749), .ZN(n632) );
  INVD1BWP12T U767 ( .I(n858), .ZN(n787) );
  NR2D1BWP12T U768 ( .A1(n779), .A2(n746), .ZN(n846) );
  INVD1BWP12T U769 ( .I(instruction[11]), .ZN(n874) );
  INVD2BWP12T U770 ( .I(n785), .ZN(n924) );
  NR2D1BWP12T U771 ( .A1(n796), .A2(n795), .ZN(n798) );
  AO31D1BWP12T U772 ( .A1(n772), .A2(n770), .A3(n732), .B(n797), .Z(n733) );
  AOI211D1BWP12T U773 ( .A1(n717), .A2(n715), .B(n714), .C(n767), .ZN(n718) );
  MOAI22D0BWP12T U774 ( .A1(n768), .A2(n809), .B1(n924), .B2(alu_opcode[4]), 
        .ZN(next_alu_opcode[4]) );
  ND3D1BWP12T U775 ( .A1(n739), .A2(n876), .A3(n843), .ZN(next_alu_opcode[3])
         );
  AOI211D1BWP12T U776 ( .A1(n924), .A2(alu_opcode[3]), .B(n736), .C(n735), 
        .ZN(n739) );
  MOAI22D0BWP12T U777 ( .A1(n780), .A2(n809), .B1(n924), .B2(alu_opcode[0]), 
        .ZN(next_alu_opcode[0]) );
  MOAI22D0BWP12T U778 ( .A1(n794), .A2(n809), .B1(n924), .B2(operand_a[1]), 
        .ZN(next_operand_a[1]) );
  AOI211D1BWP12T U779 ( .A1(instruction[9]), .A2(n835), .B(n793), .C(n792), 
        .ZN(n794) );
  MOAI22D0BWP12T U780 ( .A1(n809), .A2(n808), .B1(n924), .B2(pc_mask_bit), 
        .ZN(next_pc_mask_bit) );
  AOI22D1BWP12T U781 ( .A1(instruction[2]), .A2(n886), .B1(instruction[10]), 
        .B2(n885), .ZN(n890) );
  MOAI22D0BWP12T U782 ( .A1(n704), .A2(n809), .B1(n924), .B2(
        alu_stack_write_to_reg[1]), .ZN(next_alu_stack_write_to_reg[1]) );
  AOI21D1BWP12T U783 ( .A1(n924), .A2(memory_write_to_reg[4]), .B(n875), .ZN(
        n877) );
  AOI211D1BWP12T U784 ( .A1(n924), .A2(memory_write_to_reg[3]), .B(n875), .C(
        n657), .ZN(n634) );
  AOI32D1BWP12T U785 ( .A1(n659), .A2(n643), .A3(n642), .B1(n889), .B2(n643), 
        .ZN(next_memory_write_to_reg[2]) );
  MOAI22D0BWP12T U786 ( .A1(n628), .A2(n809), .B1(n924), .B2(
        memory_write_to_reg[1]), .ZN(next_memory_write_to_reg[1]) );
  IND3D1BWP12T U787 ( .A1(n657), .B1(n840), .B2(n656), .ZN(
        next_memory_write_to_reg[0]) );
  AOI211D1BWP12T U788 ( .A1(n924), .A2(memory_write_to_reg[0]), .B(n655), .C(
        n654), .ZN(n656) );
  AO22D1BWP12T U789 ( .A1(n924), .A2(memory_store_address_reg[1]), .B1(
        instruction[9]), .B2(n847), .Z(next_memory_store_address_reg[1]) );
  MOAI22D0BWP12T U790 ( .A1(n807), .A2(n809), .B1(n924), .B2(offset_b[6]), 
        .ZN(next_offset_b[6]) );
  NR2D1BWP12T U791 ( .A1(n806), .A2(n805), .ZN(n807) );
  MOAI22D0BWP12T U792 ( .A1(n831), .A2(n621), .B1(itstate[0]), .B2(n895), .ZN(
        next_itstate[0]) );
  INVD1BWP12T U793 ( .I(memory_write_finished), .ZN(n495) );
  INVD1BWP12T U794 ( .I(memory_read_finished), .ZN(n496) );
  IOA21D1BWP12T U795 ( .A1(n924), .A2(memory_load_request), .B(n661), .ZN(
        next_memory_load_request) );
  CKND2D0BWP12T U796 ( .A1(n573), .A2(n618), .ZN(n532) );
  NR4D0BWP12T U797 ( .A1(itstate[5]), .A2(itstate[4]), .A3(itstate[3]), .A4(
        n532), .ZN(n716) );
  NR2D0BWP12T U798 ( .A1(n623), .A2(n622), .ZN(n533) );
  ND4D0BWP12T U799 ( .A1(n626), .A2(n624), .A3(n625), .A4(n533), .ZN(n534) );
  AOI222D0BWP12T U800 ( .A1(n534), .A2(n882), .B1(n858), .B2(n627), .C1(
        instruction[9]), .C2(n658), .ZN(n747) );
  OAI211D0BWP12T U801 ( .A1(n841), .A2(n874), .B(n838), .C(n840), .ZN(n535) );
  AO211D0BWP12T U802 ( .A1(memory_store_data_reg[0]), .A2(n924), .B(n839), .C(
        n535), .Z(next_memory_store_data_reg[0]) );
  OAI22D0BWP12T U803 ( .A1(n910), .A2(n911), .B1(n902), .B2(n907), .ZN(n536)
         );
  OAI22D0BWP12T U804 ( .A1(n906), .A2(n909), .B1(n914), .B2(n915), .ZN(n537)
         );
  AOI211D0BWP12T U805 ( .A1(instruction[4]), .A2(n782), .B(n536), .C(n537), 
        .ZN(n538) );
  MOAI22D0BWP12T U806 ( .A1(n809), .A2(n538), .B1(offset_b[5]), .B2(n924), 
        .ZN(next_offset_b[5]) );
  AOI22D0BWP12T U807 ( .A1(n495), .A2(next_memory_store_request), .B1(n496), 
        .B2(next_memory_load_request), .ZN(n539) );
  OAI211D0BWP12T U808 ( .A1(instruction_valid), .A2(
        next_stall_to_instructionfetch), .B(n614), .C(n539), .ZN(n616) );
  NR2D0BWP12T U809 ( .A1(n913), .A2(n801), .ZN(n540) );
  AOI211D0BWP12T U810 ( .A1(n658), .A2(instruction[10]), .B(instruction[11]), 
        .C(n540), .ZN(n541) );
  ND4D0BWP12T U811 ( .A1(n824), .A2(n659), .A3(n541), .A4(n660), .ZN(n542) );
  AOI22D0BWP12T U812 ( .A1(n924), .A2(memory_store_data_reg[2]), .B1(n862), 
        .B2(n542), .ZN(n543) );
  CKND2D0BWP12T U813 ( .A1(n883), .A2(n543), .ZN(next_memory_store_data_reg[2]) );
  MAOI22D0BWP12T U814 ( .A1(n924), .A2(offset_b[0]), .B1(n761), .B2(n784), 
        .ZN(n544) );
  OAI31D0BWP12T U815 ( .A1(n907), .A2(n831), .A3(n809), .B(n544), .ZN(
        next_offset_b[0]) );
  NR4D0BWP12T U816 ( .A1(instruction[4]), .A2(n627), .A3(n598), .A4(n647), 
        .ZN(n545) );
  AOI32D0BWP12T U817 ( .A1(n609), .A2(n779), .A3(n545), .B1(n787), .B2(n779), 
        .ZN(n873) );
  INR4D0BWP12T U818 ( .A1(N1677), .B1(reset), .B2(N1679), .B3(N1680), .ZN(n862) );
  NR4D0BWP12T U819 ( .A1(n719), .A2(n769), .A3(n692), .A4(n818), .ZN(n546) );
  MOAI22D0BWP12T U820 ( .A1(n693), .A2(n912), .B1(n693), .B2(n710), .ZN(n547)
         );
  AOI22D0BWP12T U821 ( .A1(instruction[9]), .A2(flag_v), .B1(flag_n), .B2(n910), .ZN(n548) );
  OAI21D0BWP12T U822 ( .A1(instruction[8]), .A2(n548), .B(n874), .ZN(n549) );
  AOI21D0BWP12T U823 ( .A1(instruction[8]), .A2(n548), .B(n549), .ZN(n550) );
  AOI211D0BWP12T U824 ( .A1(instruction[11]), .A2(n547), .B(n906), .C(n550), 
        .ZN(n551) );
  MAOI22D0BWP12T U825 ( .A1(instruction[9]), .A2(n695), .B1(instruction[9]), 
        .B2(n694), .ZN(n552) );
  MAOI22D0BWP12T U826 ( .A1(instruction[8]), .A2(n552), .B1(instruction[8]), 
        .B2(n552), .ZN(n553) );
  OAI22D0BWP12T U827 ( .A1(n698), .A2(n710), .B1(flag_z), .B2(n766), .ZN(n554)
         );
  CKND0BWP12T U828 ( .I(flag_c), .ZN(n555) );
  OAI221D0BWP12T U829 ( .A1(flag_c), .A2(n696), .B1(n555), .B2(n701), .C(n697), 
        .ZN(n556) );
  OAI22D0BWP12T U830 ( .A1(n803), .A2(n553), .B1(n554), .B2(n556), .ZN(n557)
         );
  OAI211D0BWP12T U831 ( .A1(n551), .A2(n557), .B(n851), .C(n699), .ZN(n558) );
  AOI31D0BWP12T U832 ( .A1(n700), .A2(n546), .A3(n558), .B(n809), .ZN(
        next_alu_stack_write_to_reg_enable) );
  IIND4D0BWP12T U833 ( .A1(instruction[14]), .A2(instruction[13]), .B1(
        instruction[12]), .B2(instruction[15]), .ZN(n652) );
  NR3D0BWP12T U834 ( .A1(n598), .A2(n595), .A3(n594), .ZN(n559) );
  ND3D0BWP12T U835 ( .A1(n597), .A2(n559), .A3(n636), .ZN(n612) );
  AOI21D0BWP12T U836 ( .A1(n804), .A2(n803), .B(n802), .ZN(n560) );
  MOAI22D0BWP12T U837 ( .A1(n809), .A2(n560), .B1(load_store_width[0]), .B2(
        n924), .ZN(next_load_store_width[0]) );
  NR4D0BWP12T U838 ( .A1(n819), .A2(n850), .A3(n685), .A4(n857), .ZN(n561) );
  AOI31D0BWP12T U839 ( .A1(n706), .A2(n787), .A3(n561), .B(n889), .ZN(n562) );
  AO21D0BWP12T U840 ( .A1(n924), .A2(stall_to_instructionfetch), .B(n562), .Z(
        next_stall_to_instructionfetch) );
  NR4D0BWP12T U841 ( .A1(n879), .A2(n882), .A3(n881), .A4(n880), .ZN(n563) );
  OAI21D0BWP12T U842 ( .A1(n889), .A2(n563), .B(n883), .ZN(n887) );
  AOI211D0BWP12T U843 ( .A1(operand_a[3]), .A2(n924), .B(n884), .C(n860), .ZN(
        n564) );
  CKND2D0BWP12T U844 ( .A1(n843), .A2(n564), .ZN(next_operand_a[3]) );
  AOI21D0BWP12T U845 ( .A1(n924), .A2(memory_store_data_reg[3]), .B(n823), 
        .ZN(n565) );
  ND3D0BWP12T U846 ( .A1(n822), .A2(n812), .A3(n565), .ZN(
        next_memory_store_data_reg[3]) );
  AOI211D0BWP12T U847 ( .A1(n874), .A2(n612), .B(n611), .C(n635), .ZN(n566) );
  OAI32D0BWP12T U848 ( .A1(n809), .A2(n787), .A3(n566), .B1(n632), .B2(n809), 
        .ZN(n567) );
  AO211D0BWP12T U849 ( .A1(memory_store_request), .A2(n924), .B(n846), .C(n567), .Z(next_memory_store_request) );
  CKND2D0BWP12T U850 ( .A1(n874), .A2(n906), .ZN(n613) );
  CKND0BWP12T U851 ( .I(n613), .ZN(n697) );
  ND4D1BWP12T U852 ( .A1(n912), .A2(n910), .A3(n630), .A4(n697), .ZN(n762) );
  CKND1BWP12T U853 ( .I(n762), .ZN(n769) );
  NR2XD0BWP12T U854 ( .A1(instruction[13]), .A2(n587), .ZN(n568) );
  AN2XD1BWP12T U855 ( .A1(n568), .A2(n586), .Z(n585) );
  NR2XD0BWP12T U856 ( .A1(instruction[12]), .A2(n874), .ZN(n690) );
  CKND2D0BWP12T U857 ( .A1(n916), .A2(n763), .ZN(n774) );
  NR3XD0BWP12T U858 ( .A1(n882), .A2(n769), .A3(n774), .ZN(n706) );
  INVD0BWP12T U859 ( .I(itstate[4]), .ZN(n581) );
  AOI22D1BWP12T U860 ( .A1(itstate[6]), .A2(flag_v), .B1(flag_c), .B2(n573), 
        .ZN(n570) );
  TPOAI21D0BWP12T U861 ( .A1(itstate[6]), .A2(n695), .B(itstate[7]), .ZN(n569)
         );
  INVD1BWP12T U862 ( .I(itstate[5]), .ZN(n903) );
  INVD0BWP12T U863 ( .I(itstate[6]), .ZN(n900) );
  OAI221D1BWP12T U864 ( .A1(itstate[6]), .A2(n694), .B1(n900), .B2(n693), .C(
        itstate[7]), .ZN(n571) );
  TPOAI31D0BWP12T U865 ( .A1(itstate[7]), .A2(flag_n), .A3(n900), .B(n571), 
        .ZN(n572) );
  AOI211XD0BWP12T U866 ( .A1(n573), .A2(n698), .B(itstate[5]), .C(n572), .ZN(
        n579) );
  INVD0BWP12T U867 ( .I(itstate[7]), .ZN(n898) );
  AOI221D1BWP12T U868 ( .A1(itstate[7]), .A2(n694), .B1(n898), .B2(n698), .C(
        itstate[6]), .ZN(n574) );
  AOI31D1BWP12T U869 ( .A1(itstate[6]), .A2(flag_n), .A3(n898), .B(n574), .ZN(
        n576) );
  ND2D0BWP12T U870 ( .A1(itstate[6]), .A2(itstate[7]), .ZN(n575) );
  OAI22D1BWP12T U871 ( .A1(itstate[5]), .A2(n576), .B1(n575), .B2(n693), .ZN(
        n577) );
  OAI32D1BWP12T U872 ( .A1(n581), .A2(n580), .A3(n579), .B1(n578), .B2(
        itstate[4]), .ZN(n582) );
  NR2XD0BWP12T U873 ( .A1(n874), .A2(n771), .ZN(n685) );
  CKND2D0BWP12T U874 ( .A1(n902), .A2(n908), .ZN(n605) );
  ND2D0BWP12T U875 ( .A1(n899), .A2(n897), .ZN(n731) );
  NR2D0BWP12T U876 ( .A1(n605), .A2(n731), .ZN(n591) );
  CKND2D0BWP12T U877 ( .A1(n589), .A2(n591), .ZN(n588) );
  NR3D0BWP12T U878 ( .A1(instruction[1]), .A2(n831), .A3(n588), .ZN(n598) );
  CKND2D0BWP12T U879 ( .A1(instruction[1]), .A2(n831), .ZN(n599) );
  NR2D0BWP12T U880 ( .A1(n599), .A2(n588), .ZN(n594) );
  NR2D0BWP12T U881 ( .A1(n637), .A2(n731), .ZN(n592) );
  OAI221D0BWP12T U882 ( .A1(instruction[4]), .A2(instruction[5]), .B1(n908), 
        .B2(n902), .C(n592), .ZN(n636) );
  CKND2D0BWP12T U883 ( .A1(n590), .A2(instruction[2]), .ZN(n624) );
  CKND0BWP12T U884 ( .I(n624), .ZN(n596) );
  ND3XD0BWP12T U885 ( .A1(n915), .A2(n591), .A3(n596), .ZN(n597) );
  TPND3D0BWP12T U886 ( .A1(instruction[3]), .A2(n590), .A3(n913), .ZN(n626) );
  NR2D0BWP12T U887 ( .A1(n626), .A2(n602), .ZN(n595) );
  NR2D0BWP12T U888 ( .A1(n637), .A2(n612), .ZN(n606) );
  OAI211D0BWP12T U889 ( .A1(n592), .A2(n606), .B(instruction[5]), .C(n908), 
        .ZN(n593) );
  CKND1BWP12T U890 ( .I(n612), .ZN(n604) );
  IND2XD1BWP12T U891 ( .A1(n599), .B1(n604), .ZN(n608) );
  IND3D1BWP12T U892 ( .A1(n594), .B1(n593), .B2(n608), .ZN(n647) );
  OR2XD0BWP12T U893 ( .A1(n637), .A2(n605), .Z(n633) );
  NR2XD0BWP12T U894 ( .A1(n899), .A2(n633), .ZN(n623) );
  CKND2D0BWP12T U895 ( .A1(instruction[7]), .A2(n899), .ZN(n712) );
  TPNR2D0BWP12T U896 ( .A1(n633), .A2(n712), .ZN(n622) );
  NR2D0BWP12T U897 ( .A1(n626), .A2(n612), .ZN(n610) );
  TPNR3D0BWP12T U898 ( .A1(n622), .A2(n595), .A3(n610), .ZN(n646) );
  ND2D1BWP12T U899 ( .A1(n596), .A2(n604), .ZN(n607) );
  IND4D1BWP12T U900 ( .A1(n623), .B1(n646), .B2(n597), .B3(n607), .ZN(n627) );
  CKND2D0BWP12T U901 ( .A1(instruction[5]), .A2(n908), .ZN(n601) );
  INR2D1BWP12T U902 ( .A1(n626), .B1(n622), .ZN(n600) );
  OAI211D0BWP12T U903 ( .A1(n637), .A2(n601), .B(n600), .C(n599), .ZN(n644) );
  TPNR2D0BWP12T U904 ( .A1(n637), .A2(n602), .ZN(n738) );
  CKND2D0BWP12T U905 ( .A1(instruction[8]), .A2(n738), .ZN(n625) );
  ND4D0BWP12T U906 ( .A1(n831), .A2(n908), .A3(n625), .A4(n624), .ZN(n603) );
  OR2XD0BWP12T U907 ( .A1(n677), .A2(instruction[9]), .Z(n855) );
  OAI211D1BWP12T U908 ( .A1(n874), .A2(n652), .B(n660), .C(n808), .ZN(n811) );
  AOI32D1BWP12T U909 ( .A1(instruction[11]), .A2(n917), .A3(n873), .B1(n811), 
        .B2(n917), .ZN(n661) );
  AO211D1BWP12T U910 ( .A1(n606), .A2(n605), .B(n622), .C(n623), .Z(n635) );
  IND4D1BWP12T U911 ( .A1(n610), .B1(n609), .B2(n608), .B3(n607), .ZN(n611) );
  INVD1BWP12T U912 ( .I(n901), .ZN(n619) );
  AOI211D1BWP12T U913 ( .A1(itstate[3]), .A2(n618), .B(n617), .C(n616), .ZN(
        n896) );
  AO222D0BWP12T U914 ( .A1(n895), .A2(itstate[4]), .B1(instruction[4]), .B2(
        n619), .C1(itstate[3]), .C2(n896), .Z(next_itstate[4]) );
  AO222D0BWP12T U915 ( .A1(n895), .A2(itstate[2]), .B1(itstate[1]), .B2(n896), 
        .C1(instruction[2]), .C2(n620), .Z(next_itstate[2]) );
  AO222D0BWP12T U916 ( .A1(n895), .A2(itstate[3]), .B1(itstate[2]), .B2(n896), 
        .C1(instruction[3]), .C2(n620), .Z(next_itstate[3]) );
  AO222D0BWP12T U917 ( .A1(n895), .A2(itstate[1]), .B1(itstate[0]), .B2(n896), 
        .C1(instruction[1]), .C2(n620), .Z(next_itstate[1]) );
  OA222D0BWP12T U918 ( .A1(n910), .A2(n808), .B1(n874), .B2(n747), .C1(n759), 
        .C2(n660), .Z(n628) );
  CKND2D0BWP12T U919 ( .A1(n862), .A2(n858), .ZN(n640) );
  TPOAI31D0BWP12T U920 ( .A1(n731), .A2(n633), .A3(n640), .B(n883), .ZN(n875)
         );
  CKND0BWP12T U921 ( .I(n771), .ZN(n692) );
  CKND0BWP12T U922 ( .I(n916), .ZN(n782) );
  AOI32D0BWP12T U923 ( .A1(n874), .A2(n910), .A3(n912), .B1(instruction[10]), 
        .B2(n910), .ZN(n629) );
  CKND2D0BWP12T U924 ( .A1(n788), .A2(n845), .ZN(n664) );
  TPNR2D0BWP12T U925 ( .A1(n819), .A2(n810), .ZN(n631) );
  ND2D1BWP12T U926 ( .A1(n632), .A2(n631), .ZN(n872) );
  NR2XD0BWP12T U927 ( .A1(n889), .A2(n691), .ZN(n737) );
  OAI31D1BWP12T U928 ( .A1(instruction[11]), .A2(n674), .A3(n889), .B(n634), 
        .ZN(next_memory_write_to_reg[3]) );
  INR3XD0BWP12T U929 ( .A1(n636), .B1(n649), .B2(n635), .ZN(n638) );
  OAI22D0BWP12T U930 ( .A1(n638), .A2(n787), .B1(n637), .B2(n691), .ZN(n639)
         );
  NR2D0BWP12T U931 ( .A1(n667), .A2(n737), .ZN(n841) );
  NR2XD0BWP12T U932 ( .A1(instruction[11]), .A2(n841), .ZN(n655) );
  INVD1BWP12T U933 ( .I(n819), .ZN(n824) );
  AOI211XD0BWP12T U934 ( .A1(n924), .A2(memory_write_to_reg[2]), .B(n655), .C(
        n842), .ZN(n643) );
  TPND2D0BWP12T U935 ( .A1(n906), .A2(instruction[11]), .ZN(n803) );
  MOAI22D0BWP12T U936 ( .A1(n906), .A2(n808), .B1(n803), .B2(n658), .ZN(n641)
         );
  RCAOI211D0BWP12T U937 ( .A1(instruction[2]), .A2(n804), .B(n749), .C(n641), 
        .ZN(n642) );
  AOI22D0BWP12T U938 ( .A1(instruction[0]), .A2(n645), .B1(n882), .B2(n644), 
        .ZN(n651) );
  CKND0BWP12T U939 ( .I(n646), .ZN(n648) );
  OAI31D0BWP12T U940 ( .A1(n649), .A2(n648), .A3(n647), .B(n858), .ZN(n650) );
  OAI211D0BWP12T U941 ( .A1(n652), .A2(n912), .B(n651), .C(n650), .ZN(n653) );
  CKND0BWP12T U942 ( .I(n883), .ZN(n688) );
  TPAOI21D0BWP12T U943 ( .A1(n862), .A2(n653), .B(n688), .ZN(n840) );
  ND3XD0BWP12T U944 ( .A1(instruction[0]), .A2(n862), .A3(n804), .ZN(n838) );
  OAI31D0BWP12T U945 ( .A1(n912), .A2(n889), .A3(n808), .B(n838), .ZN(n654) );
  IOA21D0BWP12T U946 ( .A1(n924), .A2(memory_write_to_reg_enable), .B(n661), 
        .ZN(next_memory_write_to_reg_enable) );
  AOI32D1BWP12T U947 ( .A1(n763), .A2(n665), .A3(n662), .B1(n889), .B2(n665), 
        .ZN(n871) );
  AOI22D1BWP12T U948 ( .A1(n924), .A2(memory_store_address_reg[0]), .B1(
        instruction[8]), .B2(n667), .ZN(n663) );
  CKND2D1BWP12T U949 ( .A1(n923), .A2(n663), .ZN(
        next_memory_store_address_reg[0]) );
  CKND2D0BWP12T U950 ( .A1(n862), .A2(n686), .ZN(n864) );
  NR2XD0BWP12T U951 ( .A1(n897), .A2(n864), .ZN(n884) );
  CKND1BWP12T U952 ( .I(n914), .ZN(n756) );
  NR3XD0BWP12T U953 ( .A1(n882), .A2(n664), .A3(n756), .ZN(n826) );
  CKND0BWP12T U954 ( .I(n907), .ZN(n754) );
  OR2XD0BWP12T U955 ( .A1(n825), .A2(n889), .Z(n843) );
  AOI22D1BWP12T U956 ( .A1(n924), .A2(memory_store_address_reg[2]), .B1(
        instruction[10]), .B2(n667), .ZN(n668) );
  CKND2D1BWP12T U957 ( .A1(n923), .A2(n668), .ZN(
        next_memory_store_address_reg[2]) );
  AOI22D1BWP12T U958 ( .A1(n924), .A2(offset_b[22]), .B1(instruction[10]), 
        .B2(n741), .ZN(n669) );
  CKND2D0BWP12T U959 ( .A1(n669), .A2(n742), .ZN(next_offset_b[22]) );
  IOA21D0BWP12T U960 ( .A1(n924), .A2(offset_b[23]), .B(n742), .ZN(
        next_offset_b[23]) );
  IOA21D0BWP12T U961 ( .A1(n924), .A2(offset_b[25]), .B(n742), .ZN(
        next_offset_b[25]) );
  IOA21D0BWP12T U962 ( .A1(n924), .A2(offset_b[30]), .B(n742), .ZN(
        next_offset_b[30]) );
  TPOAI31D0BWP12T U963 ( .A1(instruction[10]), .A2(n874), .A3(n814), .B(n790), 
        .ZN(n761) );
  INVD1BWP12T U964 ( .I(n761), .ZN(n755) );
  TPAOI22D0BWP12T U965 ( .A1(n924), .A2(offset_b[1]), .B1(n848), .B2(n755), 
        .ZN(n673) );
  CKND0BWP12T U966 ( .I(n802), .ZN(n909) );
  OAI22D0BWP12T U967 ( .A1(n759), .A2(n907), .B1(n899), .B2(n909), .ZN(n671)
         );
  AOI211D0BWP12T U968 ( .A1(instruction[0]), .A2(n782), .B(n685), .C(n671), 
        .ZN(n672) );
  AOI32D0BWP12T U969 ( .A1(n674), .A2(n673), .A3(n672), .B1(n809), .B2(n673), 
        .ZN(next_offset_b[1]) );
  IOA21D0BWP12T U970 ( .A1(n924), .A2(offset_b[29]), .B(n742), .ZN(
        next_offset_b[29]) );
  AOI22D1BWP12T U971 ( .A1(n924), .A2(offset_b[21]), .B1(instruction[9]), .B2(
        n741), .ZN(n675) );
  CKND2D0BWP12T U972 ( .A1(n675), .A2(n742), .ZN(next_offset_b[21]) );
  IOA21D0BWP12T U973 ( .A1(n924), .A2(offset_b[27]), .B(n742), .ZN(
        next_offset_b[27]) );
  IOA21D0BWP12T U974 ( .A1(n924), .A2(offset_b[24]), .B(n742), .ZN(
        next_offset_b[24]) );
  AOI22D1BWP12T U975 ( .A1(n924), .A2(offset_b[20]), .B1(instruction[8]), .B2(
        n741), .ZN(n676) );
  CKND2D0BWP12T U976 ( .A1(n676), .A2(n742), .ZN(next_offset_b[20]) );
  AN2XD1BWP12T U977 ( .A1(n788), .A2(n914), .Z(n681) );
  TPNR2D0BWP12T U978 ( .A1(n874), .A2(n814), .ZN(n750) );
  CKND2D1BWP12T U979 ( .A1(n790), .A2(n750), .ZN(n713) );
  TPAOI22D0BWP12T U980 ( .A1(n924), .A2(operand_b[1]), .B1(n848), .B2(n867), 
        .ZN(n680) );
  ND4D1BWP12T U981 ( .A1(n678), .A2(n761), .A3(n787), .A4(n907), .ZN(n861) );
  AOI211D0BWP12T U982 ( .A1(instruction[4]), .A2(n868), .B(n882), .C(n861), 
        .ZN(n679) );
  AOI32D0BWP12T U983 ( .A1(n681), .A2(n680), .A3(n679), .B1(n809), .B2(n680), 
        .ZN(next_operand_b[1]) );
  IOA21D0BWP12T U984 ( .A1(n924), .A2(offset_b[26]), .B(n742), .ZN(
        next_offset_b[26]) );
  AOI22D1BWP12T U985 ( .A1(n924), .A2(offset_b[19]), .B1(instruction[7]), .B2(
        n741), .ZN(n682) );
  CKND2D0BWP12T U986 ( .A1(n682), .A2(n742), .ZN(next_offset_b[19]) );
  IOA21D0BWP12T U987 ( .A1(n924), .A2(offset_b[28]), .B(n742), .ZN(
        next_offset_b[28]) );
  IOA21D0BWP12T U988 ( .A1(n924), .A2(offset_b[31]), .B(n742), .ZN(
        next_offset_b[31]) );
  AOI22D1BWP12T U989 ( .A1(n924), .A2(offset_b[18]), .B1(instruction[6]), .B2(
        n741), .ZN(n683) );
  CKND2D0BWP12T U990 ( .A1(n683), .A2(n742), .ZN(next_offset_b[18]) );
  AOI22D1BWP12T U991 ( .A1(instruction[1]), .A2(n741), .B1(n924), .B2(
        offset_b[13]), .ZN(n684) );
  CKND2D0BWP12T U992 ( .A1(n684), .A2(n742), .ZN(next_offset_b[13]) );
  CKND0BWP12T U993 ( .I(n685), .ZN(n726) );
  AOI21D0BWP12T U994 ( .A1(n763), .A2(n726), .B(n889), .ZN(n689) );
  CKND2D1BWP12T U995 ( .A1(instruction[9]), .A2(n912), .ZN(n696) );
  ND2D1BWP12T U996 ( .A1(instruction[6]), .A2(n897), .ZN(n711) );
  CKND0BWP12T U997 ( .I(n690), .ZN(n687) );
  CKND2D1BWP12T U998 ( .A1(instruction[8]), .A2(n910), .ZN(n710) );
  ND3D1BWP12T U999 ( .A1(n845), .A2(n799), .A3(n824), .ZN(n879) );
  AO211D1BWP12T U1000 ( .A1(n924), .A2(alu_stack_write_to_reg[4]), .B(n689), 
        .C(n735), .Z(next_alu_stack_write_to_reg[4]) );
  CKND0BWP12T U1001 ( .I(n710), .ZN(n730) );
  CKND0BWP12T U1002 ( .I(n850), .ZN(n764) );
  OAI211D0BWP12T U1003 ( .A1(n690), .A2(n907), .B(n787), .C(n764), .ZN(n885)
         );
  INVD0BWP12T U1004 ( .I(n885), .ZN(n702) );
  OAI211D1BWP12T U1005 ( .A1(n730), .A2(n765), .B(n702), .C(n691), .ZN(n818)
         );
  CKND0BWP12T U1006 ( .I(n711), .ZN(n715) );
  CKND2D1BWP12T U1007 ( .A1(instruction[8]), .A2(instruction[9]), .ZN(n701) );
  CKND2D0BWP12T U1008 ( .A1(n912), .A2(n910), .ZN(n766) );
  OAI21D1BWP12T U1009 ( .A1(instruction[8]), .A2(n765), .B(n700), .ZN(n886) );
  NR2XD0BWP12T U1010 ( .A1(n765), .A2(n701), .ZN(n881) );
  OAI21D0BWP12T U1011 ( .A1(n702), .A2(n910), .B(n788), .ZN(n703) );
  AOI211XD0BWP12T U1012 ( .A1(instruction[1]), .A2(n886), .B(n881), .C(n703), 
        .ZN(n704) );
  AOI22D0BWP12T U1013 ( .A1(instruction[0]), .A2(n886), .B1(instruction[8]), 
        .B2(n885), .ZN(n707) );
  CKND0BWP12T U1014 ( .I(n881), .ZN(n705) );
  AOI31D0BWP12T U1015 ( .A1(n707), .A2(n706), .A3(n705), .B(n889), .ZN(n708)
         );
  AO211D1BWP12T U1016 ( .A1(n924), .A2(alu_stack_write_to_reg[0]), .B(n708), 
        .C(n735), .Z(next_alu_stack_write_to_reg[0]) );
  AOI22D1BWP12T U1017 ( .A1(instruction[5]), .A2(n741), .B1(n924), .B2(
        offset_b[17]), .ZN(n709) );
  CKND2D0BWP12T U1018 ( .A1(n709), .A2(n742), .ZN(next_offset_b[17]) );
  RCAOI211D0BWP12T U1019 ( .A1(n712), .A2(n711), .B(n816), .C(n710), .ZN(n714)
         );
  CKND2D1BWP12T U1020 ( .A1(instruction[12]), .A2(n754), .ZN(n770) );
  CKND2D0BWP12T U1021 ( .A1(n716), .A2(n862), .ZN(n797) );
  AOI22D0BWP12T U1022 ( .A1(n917), .A2(n723), .B1(n717), .B2(n848), .ZN(n734)
         );
  OAI21D0BWP12T U1023 ( .A1(n718), .A2(n797), .B(n734), .ZN(next_update_flag_v) );
  CKND2D0BWP12T U1024 ( .A1(n917), .A2(n719), .ZN(n854) );
  ND2D1BWP12T U1025 ( .A1(n924), .A2(offset_b[11]), .ZN(n720) );
  OAI211D0BWP12T U1026 ( .A1(n906), .A2(n854), .B(n742), .C(n720), .ZN(
        next_offset_b[11]) );
  AOI22D1BWP12T U1027 ( .A1(n924), .A2(offset_b[16]), .B1(instruction[4]), 
        .B2(n741), .ZN(n721) );
  CKND2D0BWP12T U1028 ( .A1(n721), .A2(n742), .ZN(next_offset_b[16]) );
  AOI22D1BWP12T U1029 ( .A1(instruction[3]), .A2(n741), .B1(n924), .B2(
        offset_b[15]), .ZN(n722) );
  ND2D0BWP12T U1030 ( .A1(n722), .A2(n742), .ZN(next_offset_b[15]) );
  INVD1BWP12T U1031 ( .I(n790), .ZN(n772) );
  OAI32D0BWP12T U1032 ( .A1(n772), .A2(n910), .A3(n874), .B1(instruction[12]), 
        .B2(n772), .ZN(n724) );
  RCAOI211D0BWP12T U1033 ( .A1(n754), .A2(n750), .B(n724), .C(n723), .ZN(n728)
         );
  AOI21D0BWP12T U1034 ( .A1(n762), .A2(n816), .B(n783), .ZN(n725) );
  AOI211D1BWP12T U1035 ( .A1(n924), .A2(alu_opcode[1]), .B(n846), .C(n725), 
        .ZN(n727) );
  AOI32D0BWP12T U1036 ( .A1(n728), .A2(n727), .A3(n726), .B1(n809), .B2(n727), 
        .ZN(next_alu_opcode[1]) );
  AOI22D1BWP12T U1037 ( .A1(instruction[2]), .A2(n741), .B1(n924), .B2(
        offset_b[14]), .ZN(n729) );
  ND2D0BWP12T U1038 ( .A1(n729), .A2(n742), .ZN(next_offset_b[14]) );
  AOI32D0BWP12T U1039 ( .A1(n731), .A2(n795), .A3(n912), .B1(n730), .B2(n795), 
        .ZN(n732) );
  TPND2D0BWP12T U1040 ( .A1(n734), .A2(n733), .ZN(next_update_flag_c) );
  NR3D0BWP12T U1041 ( .A1(n889), .A2(n910), .A3(n816), .ZN(n736) );
  ND3D1BWP12T U1042 ( .A1(n738), .A2(n737), .A3(n912), .ZN(n876) );
  ND2D1BWP12T U1043 ( .A1(n924), .A2(offset_b[10]), .ZN(n740) );
  OAI211D0BWP12T U1044 ( .A1(n910), .A2(n854), .B(n742), .C(n740), .ZN(
        next_offset_b[10]) );
  AOI22D1BWP12T U1045 ( .A1(instruction[0]), .A2(n741), .B1(n924), .B2(
        offset_b[12]), .ZN(n743) );
  ND2D0BWP12T U1046 ( .A1(n743), .A2(n742), .ZN(next_offset_b[12]) );
  TPND2D0BWP12T U1047 ( .A1(n917), .A2(instruction[6]), .ZN(n784) );
  OAI22D0BWP12T U1048 ( .A1(n916), .A2(n784), .B1(n783), .B2(n907), .ZN(n744)
         );
  AOI21D1BWP12T U1049 ( .A1(n924), .A2(offset_b[7]), .B(n744), .ZN(n745) );
  TPOAI31D0BWP12T U1050 ( .A1(n914), .A2(n902), .A3(n809), .B(n745), .ZN(
        next_offset_b[7]) );
  MOAI22D0BWP12T U1051 ( .A1(n747), .A2(n746), .B1(n924), .B2(
        memory_store_data_reg[1]), .ZN(n748) );
  AO31XD0BWP12T U1052 ( .A1(instruction[1]), .A2(n917), .A3(n749), .B(n748), 
        .Z(next_memory_store_data_reg[1]) );
  IND2XD0BWP12T U1053 ( .A1(n750), .B1(n790), .ZN(n905) );
  AOI22D0BWP12T U1054 ( .A1(instruction[3]), .A2(n754), .B1(instruction[8]), 
        .B2(n802), .ZN(n752) );
  AOI22D0BWP12T U1055 ( .A1(instruction[1]), .A2(n756), .B1(instruction[2]), 
        .B2(n782), .ZN(n751) );
  OAI211D1BWP12T U1056 ( .A1(n910), .A2(n905), .B(n752), .C(n751), .ZN(n753)
         );
  AO222D0BWP12T U1057 ( .A1(n753), .A2(n917), .B1(n781), .B2(n848), .C1(n924), 
        .C2(offset_b[3]), .Z(next_offset_b[3]) );
  AOI22D0BWP12T U1058 ( .A1(instruction[2]), .A2(n754), .B1(instruction[6]), 
        .B2(n781), .ZN(n758) );
  AOI22D0BWP12T U1059 ( .A1(instruction[0]), .A2(n756), .B1(instruction[8]), 
        .B2(n755), .ZN(n757) );
  OAI211D0BWP12T U1060 ( .A1(n916), .A2(n759), .B(n758), .C(n757), .ZN(n760)
         );
  AO222D0BWP12T U1061 ( .A1(n760), .A2(n917), .B1(n802), .B2(n848), .C1(n924), 
        .C2(offset_b[2]), .Z(next_offset_b[2]) );
  ND3D1BWP12T U1062 ( .A1(n763), .A2(n788), .A3(n762), .ZN(n880) );
  OAI211D0BWP12T U1063 ( .A1(n766), .A2(n765), .B(n787), .C(n764), .ZN(n775)
         );
  INR4D0BWP12T U1064 ( .A1(n779), .B1(n880), .B2(n767), .B3(n775), .ZN(n768)
         );
  AOI22D0BWP12T U1065 ( .A1(instruction[6]), .A2(n795), .B1(n769), .B2(n897), 
        .ZN(n778) );
  AOI21D0BWP12T U1066 ( .A1(n771), .A2(n770), .B(instruction[11]), .ZN(n776)
         );
  AOI211D0BWP12T U1067 ( .A1(instruction[9]), .A2(instruction[12]), .B(n874), 
        .C(n772), .ZN(n773) );
  NR4D0BWP12T U1068 ( .A1(n776), .A2(n775), .A3(n774), .A4(n773), .ZN(n777) );
  OA211D0BWP12T U1069 ( .A1(n874), .A2(n779), .B(n778), .C(n777), .Z(n780) );
  INVD0BWP12T U1070 ( .I(n781), .ZN(n911) );
  INVD1BWP12T U1071 ( .I(offset_b[8]), .ZN(n786) );
  OAI222D0BWP12T U1072 ( .A1(n786), .A2(n785), .B1(n784), .B2(n914), .C1(n783), 
        .C2(n916), .ZN(next_offset_b[8]) );
  ND2D0BWP12T U1073 ( .A1(n787), .A2(n907), .ZN(n835) );
  CKND2D0BWP12T U1074 ( .A1(n788), .A2(n808), .ZN(n793) );
  NR2D1BWP12T U1075 ( .A1(n790), .A2(n789), .ZN(n832) );
  AOI22D0BWP12T U1076 ( .A1(instruction[1]), .A2(n868), .B1(n850), .B2(n874), 
        .ZN(n791) );
  OAI211D0BWP12T U1077 ( .A1(n832), .A2(n908), .B(n825), .C(n791), .ZN(n792)
         );
  OAI22D0BWP12T U1078 ( .A1(n799), .A2(n809), .B1(n798), .B2(n797), .ZN(
        next_update_flag_n) );
  ND2D1BWP12T U1079 ( .A1(n924), .A2(memorycontroller_sign_extend), .ZN(n800)
         );
  TPOAI31D0BWP12T U1080 ( .A1(n874), .A2(n809), .A3(n801), .B(n800), .ZN(
        next_memorycontroller_sign_extend) );
  OAI22D0BWP12T U1081 ( .A1(n916), .A2(n902), .B1(n914), .B2(n908), .ZN(n806)
         );
  OAI22D0BWP12T U1082 ( .A1(n899), .A2(n907), .B1(n906), .B2(n911), .ZN(n805)
         );
  AO21D0BWP12T U1083 ( .A1(n862), .A2(instruction[11]), .B(n875), .Z(n823) );
  OAI31D0BWP12T U1084 ( .A1(n819), .A2(n811), .A3(n810), .B(n862), .ZN(n822)
         );
  CKBD1BWP12T U1085 ( .I(update_flag_z), .Z(update_flag_n) );
  CKND0BWP12T U1086 ( .I(n813), .ZN(n815) );
  OAI211D0BWP12T U1087 ( .A1(n912), .A2(n816), .B(n815), .C(n814), .ZN(n817)
         );
  NR4D0BWP12T U1088 ( .A1(n819), .A2(n880), .A3(n818), .A4(n817), .ZN(n821) );
  ND2D1BWP12T U1089 ( .A1(n924), .A2(alu_opcode[2]), .ZN(n820) );
  OAI211D1BWP12T U1090 ( .A1(n821), .A2(n889), .B(n883), .C(n820), .ZN(
        next_alu_opcode[2]) );
  CKND2D1BWP12T U1091 ( .A1(n876), .A2(n822), .ZN(n839) );
  AO211D1BWP12T U1092 ( .A1(n924), .A2(memory_store_data_reg[4]), .B(n839), 
        .C(n823), .Z(next_memory_store_data_reg[4]) );
  ND3D0BWP12T U1093 ( .A1(n826), .A2(n825), .A3(n824), .ZN(n834) );
  RCOAI22D0BWP12T U1094 ( .A1(n832), .A2(n902), .B1(n913), .B2(n830), .ZN(n827) );
  AOI211XD0BWP12T U1095 ( .A1(instruction[10]), .A2(n835), .B(n834), .C(n827), 
        .ZN(n829) );
  ND2D1BWP12T U1096 ( .A1(n924), .A2(operand_a[2]), .ZN(n828) );
  OAI211D1BWP12T U1097 ( .A1(n829), .A2(n889), .B(n883), .C(n828), .ZN(
        next_operand_a[2]) );
  RCOAI22D0BWP12T U1098 ( .A1(n832), .A2(n915), .B1(n831), .B2(n830), .ZN(n833) );
  AOI211XD0BWP12T U1099 ( .A1(instruction[8]), .A2(n835), .B(n834), .C(n833), 
        .ZN(n837) );
  ND2D1BWP12T U1100 ( .A1(n924), .A2(operand_a[0]), .ZN(n836) );
  OAI211D1BWP12T U1101 ( .A1(n837), .A2(n889), .B(n883), .C(n836), .ZN(
        next_operand_a[0]) );
  AOI21D0BWP12T U1102 ( .A1(n924), .A2(operand_a[4]), .B(n842), .ZN(n844) );
  OAI211D1BWP12T U1103 ( .A1(n845), .A2(n889), .B(n844), .C(n843), .ZN(
        next_operand_a[4]) );
  AO211D1BWP12T U1104 ( .A1(n924), .A2(memory_address_source_is_reg), .B(n847), 
        .C(n846), .Z(next_memory_address_source_is_reg) );
  OAI31D0BWP12T U1105 ( .A1(n851), .A2(n850), .A3(n849), .B(n848), .ZN(n853)
         );
  ND2D1BWP12T U1106 ( .A1(n924), .A2(offset_b[9]), .ZN(n852) );
  OAI211D1BWP12T U1107 ( .A1(n854), .A2(n912), .B(n853), .C(n852), .ZN(
        next_offset_b[9]) );
  OAI22D0BWP12T U1108 ( .A1(instruction[12]), .A2(n911), .B1(instruction[10]), 
        .B2(n855), .ZN(n856) );
  OA31D0BWP12T U1109 ( .A1(n858), .A2(n857), .A3(n856), .B(n862), .Z(n859) );
  AO211D1BWP12T U1110 ( .A1(n924), .A2(load_store_width[1]), .B(n860), .C(n859), .Z(next_load_store_width[1]) );
  ND2D1BWP12T U1111 ( .A1(n924), .A2(operand_b[3]), .ZN(n863) );
  OAI211D1BWP12T U1112 ( .A1(n864), .A2(n899), .B(n922), .C(n863), .ZN(
        next_operand_b[3]) );
  AOI22D1BWP12T U1113 ( .A1(instruction[3]), .A2(n868), .B1(instruction[6]), 
        .B2(n867), .ZN(n866) );
  ND2D1BWP12T U1114 ( .A1(n924), .A2(operand_b[0]), .ZN(n865) );
  OAI211D1BWP12T U1115 ( .A1(n866), .A2(n889), .B(n922), .C(n865), .ZN(
        next_operand_b[0]) );
  AOI22D1BWP12T U1116 ( .A1(instruction[5]), .A2(n868), .B1(instruction[8]), 
        .B2(n867), .ZN(n870) );
  ND2D1BWP12T U1117 ( .A1(n924), .A2(operand_b[2]), .ZN(n869) );
  OAI211D1BWP12T U1118 ( .A1(n870), .A2(n889), .B(n922), .C(n869), .ZN(
        next_operand_b[2]) );
  AO21D1BWP12T U1119 ( .A1(n924), .A2(memory_store_address_reg[4]), .B(n871), 
        .Z(next_memory_store_address_reg[4]) );
  AOI21D0BWP12T U1120 ( .A1(n874), .A2(n873), .B(n872), .ZN(n878) );
  OAI211D1BWP12T U1121 ( .A1(n878), .A2(n889), .B(n877), .C(n876), .ZN(
        next_memory_write_to_reg[4]) );
  CKND0BWP12T U1122 ( .I(next_memory_write_to_reg_enable), .ZN(n894) );
  ND4D0BWP12T U1123 ( .A1(next_memory_write_to_reg[1]), .A2(
        next_memory_write_to_reg[3]), .A3(next_memory_write_to_reg[2]), .A4(
        next_memory_write_to_reg[0]), .ZN(n893) );
  IND4D0BWP12T U1124 ( .A1(next_alu_stack_write_to_reg[4]), .B1(
        next_alu_stack_write_to_reg_enable), .B2(
        next_alu_stack_write_to_reg[1]), .B3(next_alu_stack_write_to_reg[0]), 
        .ZN(n891) );
  AO211D1BWP12T U1125 ( .A1(n924), .A2(alu_stack_write_to_reg[3]), .B(n884), 
        .C(n887), .Z(next_alu_stack_write_to_reg[3]) );
  AOI21D1BWP12T U1126 ( .A1(n924), .A2(alu_stack_write_to_reg[2]), .B(n887), 
        .ZN(n888) );
  OAI21D1BWP12T U1127 ( .A1(n890), .A2(n889), .B(n888), .ZN(
        next_alu_stack_write_to_reg[2]) );
  IND3D1BWP12T U1128 ( .A1(n891), .B1(next_alu_stack_write_to_reg[3]), .B2(
        next_alu_stack_write_to_reg[2]), .ZN(n892) );
  OAI31D1BWP12T U1129 ( .A1(n894), .A2(next_memory_write_to_reg[4]), .A3(n893), 
        .B(n892), .ZN(next_decoder_pc_update) );
  OAI22D1BWP12T U1130 ( .A1(n904), .A2(n898), .B1(n897), .B2(n901), .ZN(
        next_itstate[7]) );
  OAI22D1BWP12T U1131 ( .A1(n904), .A2(n900), .B1(n899), .B2(n901), .ZN(
        next_itstate[6]) );
  OAI22D1BWP12T U1132 ( .A1(n904), .A2(n903), .B1(n902), .B2(n901), .ZN(
        next_itstate[5]) );
  RCOAI22D0BWP12T U1133 ( .A1(n908), .A2(n907), .B1(n906), .B2(n905), .ZN(n920) );
  TPOAI22D0BWP12T U1134 ( .A1(n912), .A2(n911), .B1(n910), .B2(n909), .ZN(n919) );
  TPOAI22D0BWP12T U1135 ( .A1(n916), .A2(n915), .B1(n914), .B2(n913), .ZN(n918) );
  OAI31D0BWP12T U1136 ( .A1(n920), .A2(n919), .A3(n918), .B(n917), .ZN(n921)
         );
  IOA21D1BWP12T U1137 ( .A1(n924), .A2(offset_b[4]), .B(n921), .ZN(
        next_offset_b[4]) );
  IOA21D1BWP12T U1138 ( .A1(n924), .A2(operand_b[4]), .B(n922), .ZN(
        next_operand_b[4]) );
  IOA21D1BWP12T U1139 ( .A1(n924), .A2(memory_store_address_reg[3]), .B(n923), 
        .ZN(next_memory_store_address_reg[3]) );
endmodule

