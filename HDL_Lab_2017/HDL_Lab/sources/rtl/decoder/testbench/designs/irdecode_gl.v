
module irdecode ( clock, reset, instruction, flag_n, flag_z, flag_c, flag_v, 
        memory_write_finished, memory_read_finished, 
        stall_from_instructionfetch, stall_from_controller, operand_a, 
        operand_b, offset_a, offset_b, alu_opcode, update_flag_n, 
        update_flag_z, update_flag_c, update_flag_v, alu_stack_write_to_reg, 
        alu_stack_write_to_reg_enable, memory_write_to_reg, 
        memory_write_to_reg_enable, memory_store_data_reg, 
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
  input clock, reset, flag_n, flag_z, flag_c, flag_v, memory_write_finished,
         memory_read_finished, stall_from_instructionfetch,
         stall_from_controller;
  output update_flag_n, update_flag_z, update_flag_c, update_flag_v,
         alu_stack_write_to_reg_enable, memory_write_to_reg_enable,
         memory_address_source_is_reg, memorycontroller_sign_extend,
         memory_load_request, memory_store_request, stack_push_request,
         stack_pop_request, stall_to_instructionfetch, decoder_pc_update;
  wire   N170, n566, n567, n568, n569, n570, n571, n572, n573, n574, n575,
         n576, n577, n578, n579, n580, n581, n582, n583, n584, n585, n586,
         n587, n588, n589, n590, n591, n592, n593, n594, n595, n596, n597,
         n598, n599, n600, n601, n602, n603, n604, n605, n606, n607, n608,
         n609, n610, n611, n612, n613, n614, n615, n616, n617, n618, n619,
         n620, n621, n622, n623, n624, n625, n626, n627, n628, n629, n630,
         n631, n632, n633, n634, n635, n636, n637, n638, n639, n640, n641,
         n642, n643, n644, n645, n646, n647, n648, n649, n650, n655, n656,
         n657, n658, n659, n661, n693, n694, n695, n696, n697, n698, n699,
         n700, n701, n702, n703, n704, n705, n706, n707, n708, n709, n710,
         n711, n712, n713, n714, n715, n716, n717, n718, n719, n720, n721,
         n722, n723, n724, n725, n726, n727, n728, n729, n730, n731, n732,
         n733, n734, n735, n736, n737, n738, n739, n740, n741, n742, n743,
         n744, n745, n746, n747, n748, n749, n750, n751, n752, n753, n754,
         n755, n756, n757, n758, n759, n760, n761, n762, n763, n764, n765,
         n766, n767, n768, n769, n770, n771, n772, n773, n774, n775, n776,
         n777, n778, n779, n780, n781, n782, n783, n784, n785, n786, n787,
         n788, n789, n790, n791, n792, n793, n794, n795, n796, n797, n798,
         n799, n800, n801, n802, n803, n804, n805, n806, n807, n808, n809,
         n810, n811, n812, n813, n814, n815, n816, n817, n818, n819, n820,
         n821, n822, n823, n824, n825, n826, n827, n828, n829, n830, n831,
         n832, n833, n834, n835, n836, n837, n838, n839, n840, n841, n842,
         n843, n844, n845, n846, n847, n848, n849, n850, n851, n852, n853,
         n854, n855, n856, n857, n858, n859, n860, n861, n862, n863, n864,
         n865, n866, n867, n868, n869, n870, n871, n872, n873, n874, n875,
         n876, n877, n878, n879, n880, n881, n882, n883, n884, n885, n886,
         n887, n888, n889, n890, n891, n892, n893, n894, n895, n896, n897,
         n898, n899, n900, n901, n902, n903, n904, n905, n906, n907, n908,
         n909, n910, n911, n912, n913, n914, n915, n916, n917, n918, n919,
         n920, n921, n922, n923, n924, n925, n926, n927, n928, n929, n930,
         n931, n932, n933, n934, n935, n936, n937, n938, n939, n940, n941,
         n942, n943, n944, n945, n946, n947, n948, n949, n950, n951, n952,
         n953, n954, n955, n956, n957, n958, n959, n960, n961, n962, n963,
         n964, n965, n966, n967, n968, n969, n970, n971, n972, n973, n974,
         n975, n976, n977, n978, n979, n980, n981, n982, n983, n984, n985,
         n986, n987, n988, n989, n990, n991, n992, n993, n994, n995, n996,
         n997, n998, n999, n1000, n1001, n1002, n1003, n1004, n1005, n1006,
         n1007, n1008, n1009, n1010, n1011, n1012, n1013, n1014, n1015, n1016,
         n1017, n1018, n1019, n1020, n1021, n1022, n1023, n1024, n1025, n1026,
         n1027, n1028, n1029, n1030, n1031, n1032, n1033, n1034, n1035, n1036,
         n1037, n1038, n1039, n1040, n1041, n1042, n1043, n1044, n1045, n1046,
         n1047, n1048, n1049, n1050, n1051, n1052, n1053, n1054, n1055, n1056,
         n1057, n1058, n1059, n1060, n1061, n1062, n1063, n1064, n1065, n1066,
         n1067, n1068, n1069, n1070, n1071, n1072, n1073, n1074, n1075, n1076,
         n1077, n1078, n1079, n1080, n1081, n1082, n1083, n1084, n1085, n1086,
         n1087, n1088, n1089, n1090, n1091, n1092, n1093, n1094, n1095, n1096,
         n1097, n1098, n1099, n1100, n1101, n1102, n1103, n1104, n1105, n1106,
         n1107, n1108, n1109, n1110, n1111;
  wire   [7:0] step;

  DFQD1BWP12T step_reg_0_ ( .D(n659), .CP(clock), .Q(step[0]) );
  DFQD1BWP12T stall_to_instructionfetch_reg ( .D(n655), .CP(clock), .Q(
        stall_to_instructionfetch) );
  DFQD1BWP12T step_reg_6_ ( .D(n634), .CP(clock), .Q(step[6]) );
  DFQD1BWP12T step_reg_7_ ( .D(n658), .CP(clock), .Q(step[7]) );
  DFQD1BWP12T step_reg_2_ ( .D(n638), .CP(clock), .Q(step[2]) );
  DFQD1BWP12T step_reg_3_ ( .D(n637), .CP(clock), .Q(step[3]) );
  DFQD1BWP12T step_reg_4_ ( .D(n636), .CP(clock), .Q(step[4]) );
  DFQD1BWP12T step_reg_5_ ( .D(n635), .CP(clock), .Q(step[5]) );
  DFQD1BWP12T step_reg_1_ ( .D(n639), .CP(clock), .Q(step[1]) );
  DFQD1BWP12T operand_a_reg_4_ ( .D(n615), .CP(clock), .Q(operand_a[4]) );
  DFQD1BWP12T operand_a_reg_0_ ( .D(n619), .CP(clock), .Q(operand_a[0]) );
  DFQD1BWP12T operand_a_reg_2_ ( .D(n617), .CP(clock), .Q(operand_a[2]) );
  DFQD1BWP12T operand_a_reg_3_ ( .D(n616), .CP(clock), .Q(operand_a[3]) );
  DFQD1BWP12T alu_stack_write_to_reg_reg_0_ ( .D(n614), .CP(clock), .Q(
        alu_stack_write_to_reg[0]) );
  DFQD1BWP12T alu_stack_write_to_reg_reg_2_ ( .D(n612), .CP(clock), .Q(
        alu_stack_write_to_reg[2]) );
  DFQD1BWP12T alu_stack_write_to_reg_reg_3_ ( .D(n611), .CP(clock), .Q(
        alu_stack_write_to_reg[3]) );
  DFQD1BWP12T alu_stack_write_to_reg_reg_4_ ( .D(n610), .CP(clock), .Q(
        alu_stack_write_to_reg[4]) );
  DFQD1BWP12T alu_opcode_reg_2_ ( .D(n607), .CP(clock), .Q(alu_opcode[2]) );
  DFQD1BWP12T alu_opcode_reg_3_ ( .D(n606), .CP(clock), .Q(alu_opcode[3]) );
  DFQD1BWP12T memory_store_request_reg ( .D(n656), .CP(clock), .Q(
        memory_store_request) );
  DFQD1BWP12T update_flag_n_reg ( .D(n650), .CP(clock), .Q(update_flag_n) );
  DFQD1BWP12T update_flag_z_reg ( .D(n640), .CP(clock), .Q(update_flag_z) );
  DFQD1BWP12T stack_pop_request_reg ( .D(n633), .CP(clock), .Q(
        stack_pop_request) );
  DFQD1BWP12T alu_stack_write_to_reg_enable_reg ( .D(n632), .CP(clock), .Q(
        alu_stack_write_to_reg_enable) );
  DFQD1BWP12T stack_push_request_reg ( .D(n631), .CP(clock), .Q(
        stack_push_request) );
  DFQD1BWP12T memory_load_request_reg ( .D(n657), .CP(clock), .Q(
        memory_load_request) );
  DFQD1BWP12T memory_write_to_reg_enable_reg ( .D(n620), .CP(clock), .Q(
        memory_write_to_reg_enable) );
  DFQD1BWP12T load_store_width_reg_1_ ( .D(n647), .CP(clock), .Q(
        load_store_width[1]) );
  DFQD1BWP12T memory_store_data_reg_reg_0_ ( .D(n630), .CP(clock), .Q(
        memory_store_data_reg[0]) );
  DFQD1BWP12T memory_store_data_reg_reg_2_ ( .D(n628), .CP(clock), .Q(
        memory_store_data_reg[2]) );
  DFQD1BWP12T memory_store_data_reg_reg_3_ ( .D(n627), .CP(clock), .Q(
        memory_store_data_reg[3]) );
  DFQD1BWP12T memory_store_data_reg_reg_4_ ( .D(n626), .CP(clock), .Q(
        memory_store_data_reg[4]) );
  DFQD1BWP12T memory_write_to_reg_reg_0_ ( .D(n625), .CP(clock), .Q(
        memory_write_to_reg[0]) );
  DFQD1BWP12T memory_write_to_reg_reg_2_ ( .D(n623), .CP(clock), .Q(
        memory_write_to_reg[2]) );
  DFQD1BWP12T memory_write_to_reg_reg_3_ ( .D(n622), .CP(clock), .Q(
        memory_write_to_reg[3]) );
  DFQD1BWP12T memory_write_to_reg_reg_4_ ( .D(n621), .CP(clock), .Q(
        memory_write_to_reg[4]) );
  DFQD1BWP12T memorycontroller_sign_extend_reg ( .D(n649), .CP(clock), .Q(
        memorycontroller_sign_extend) );
  DFQD1BWP12T load_store_width_reg_0_ ( .D(n648), .CP(clock), .Q(
        load_store_width[0]) );
  DFQD1BWP12T memory_address_source_is_reg_reg ( .D(n646), .CP(clock), .Q(
        memory_address_source_is_reg) );
  DFQD1BWP12T memory_store_address_reg_reg_1_ ( .D(n644), .CP(clock), .Q(
        memory_store_address_reg[1]) );
  DFQD1BWP12T memory_store_data_reg_reg_1_ ( .D(n629), .CP(clock), .Q(
        memory_store_data_reg[1]) );
  DFQD1BWP12T memory_write_to_reg_reg_1_ ( .D(n624), .CP(clock), .Q(
        memory_write_to_reg[1]) );
  DFQD1BWP12T memory_store_address_reg_reg_0_ ( .D(n645), .CP(clock), .Q(
        memory_store_address_reg[0]) );
  DFQD1BWP12T memory_store_address_reg_reg_2_ ( .D(n643), .CP(clock), .Q(
        memory_store_address_reg[2]) );
  DFQD1BWP12T memory_store_address_reg_reg_3_ ( .D(n642), .CP(clock), .Q(
        memory_store_address_reg[3]) );
  DFQD1BWP12T memory_store_address_reg_reg_4_ ( .D(n641), .CP(clock), .Q(
        memory_store_address_reg[4]) );
  DFQD1BWP12T operand_a_reg_1_ ( .D(n618), .CP(clock), .Q(operand_a[1]) );
  DFQD1BWP12T alu_stack_write_to_reg_reg_1_ ( .D(n613), .CP(clock), .Q(
        alu_stack_write_to_reg[1]) );
  DFQD1BWP12T decoder_pc_update_reg ( .D(N170), .CP(clock), .Q(
        decoder_pc_update) );
  DFQD1BWP12T alu_opcode_reg_0_ ( .D(n609), .CP(clock), .Q(alu_opcode[0]) );
  DFQD1BWP12T alu_opcode_reg_1_ ( .D(n608), .CP(clock), .Q(alu_opcode[1]) );
  DFQD1BWP12T alu_opcode_reg_4_ ( .D(n605), .CP(clock), .Q(alu_opcode[4]) );
  DFQD1BWP12T offset_b_reg_0_ ( .D(n604), .CP(clock), .Q(offset_b[0]) );
  DFQD1BWP12T offset_b_reg_1_ ( .D(n603), .CP(clock), .Q(offset_b[1]) );
  DFQD1BWP12T offset_b_reg_2_ ( .D(n602), .CP(clock), .Q(offset_b[2]) );
  DFQD1BWP12T offset_b_reg_3_ ( .D(n601), .CP(clock), .Q(offset_b[3]) );
  DFQD1BWP12T offset_b_reg_4_ ( .D(n600), .CP(clock), .Q(offset_b[4]) );
  DFQD1BWP12T offset_b_reg_5_ ( .D(n599), .CP(clock), .Q(offset_b[5]) );
  DFQD1BWP12T offset_b_reg_6_ ( .D(n598), .CP(clock), .Q(offset_b[6]) );
  DFQD1BWP12T offset_b_reg_7_ ( .D(n597), .CP(clock), .Q(offset_b[7]) );
  DFQD1BWP12T offset_b_reg_8_ ( .D(n596), .CP(clock), .Q(offset_b[8]) );
  DFQD1BWP12T offset_b_reg_9_ ( .D(n595), .CP(clock), .Q(offset_b[9]) );
  DFQD1BWP12T offset_b_reg_10_ ( .D(n594), .CP(clock), .Q(offset_b[10]) );
  DFQD1BWP12T offset_b_reg_11_ ( .D(n593), .CP(clock), .Q(offset_b[11]) );
  DFQD1BWP12T offset_b_reg_12_ ( .D(n592), .CP(clock), .Q(offset_b[12]) );
  DFQD1BWP12T offset_b_reg_13_ ( .D(n591), .CP(clock), .Q(offset_b[13]) );
  DFQD1BWP12T offset_b_reg_14_ ( .D(n590), .CP(clock), .Q(offset_b[14]) );
  DFQD1BWP12T offset_b_reg_15_ ( .D(n589), .CP(clock), .Q(offset_b[15]) );
  DFQD1BWP12T offset_b_reg_16_ ( .D(n588), .CP(clock), .Q(offset_b[16]) );
  DFQD1BWP12T offset_b_reg_17_ ( .D(n587), .CP(clock), .Q(offset_b[17]) );
  DFQD1BWP12T offset_b_reg_18_ ( .D(n586), .CP(clock), .Q(offset_b[18]) );
  DFQD1BWP12T offset_b_reg_19_ ( .D(n585), .CP(clock), .Q(offset_b[19]) );
  DFQD1BWP12T offset_b_reg_20_ ( .D(n584), .CP(clock), .Q(offset_b[20]) );
  DFQD1BWP12T offset_b_reg_21_ ( .D(n583), .CP(clock), .Q(offset_b[21]) );
  DFQD1BWP12T offset_b_reg_22_ ( .D(n582), .CP(clock), .Q(offset_b[22]) );
  DFQD1BWP12T offset_b_reg_23_ ( .D(n581), .CP(clock), .Q(offset_b[23]) );
  DFQD1BWP12T offset_b_reg_24_ ( .D(n580), .CP(clock), .Q(offset_b[24]) );
  DFQD1BWP12T offset_b_reg_25_ ( .D(n579), .CP(clock), .Q(offset_b[25]) );
  DFQD1BWP12T offset_b_reg_26_ ( .D(n578), .CP(clock), .Q(offset_b[26]) );
  DFQD1BWP12T offset_b_reg_27_ ( .D(n577), .CP(clock), .Q(offset_b[27]) );
  DFQD1BWP12T offset_b_reg_28_ ( .D(n576), .CP(clock), .Q(offset_b[28]) );
  DFQD1BWP12T offset_b_reg_29_ ( .D(n575), .CP(clock), .Q(offset_b[29]) );
  DFQD1BWP12T offset_b_reg_30_ ( .D(n574), .CP(clock), .Q(offset_b[30]) );
  DFQD1BWP12T offset_b_reg_31_ ( .D(n573), .CP(clock), .Q(offset_b[31]) );
  DFQD1BWP12T update_flag_c_reg ( .D(n572), .CP(clock), .Q(update_flag_c) );
  DFQD1BWP12T update_flag_v_reg ( .D(n571), .CP(clock), .Q(update_flag_v) );
  DFQD1BWP12T operand_b_reg_4_ ( .D(n570), .CP(clock), .Q(operand_b[4]) );
  DFQD1BWP12T operand_b_reg_3_ ( .D(n569), .CP(clock), .Q(operand_b[3]) );
  DFQD1BWP12T operand_b_reg_2_ ( .D(n568), .CP(clock), .Q(operand_b[2]) );
  DFQD1BWP12T operand_b_reg_1_ ( .D(n567), .CP(clock), .Q(operand_b[1]) );
  DFQD1BWP12T operand_b_reg_0_ ( .D(n566), .CP(clock), .Q(operand_b[0]) );
  TIEHBWP12T U663 ( .Z(n661) );
  INVD1BWP12T U664 ( .I(n661), .ZN(offset_a[0]) );
  INVD1BWP12T U665 ( .I(n661), .ZN(offset_a[1]) );
  INVD1BWP12T U666 ( .I(n661), .ZN(offset_a[2]) );
  INVD1BWP12T U667 ( .I(n661), .ZN(offset_a[3]) );
  INVD1BWP12T U668 ( .I(n661), .ZN(offset_a[4]) );
  INVD1BWP12T U669 ( .I(n661), .ZN(offset_a[5]) );
  INVD1BWP12T U670 ( .I(n661), .ZN(offset_a[6]) );
  INVD1BWP12T U671 ( .I(n661), .ZN(offset_a[7]) );
  INVD1BWP12T U672 ( .I(n661), .ZN(offset_a[8]) );
  INVD1BWP12T U673 ( .I(n661), .ZN(offset_a[9]) );
  INVD1BWP12T U674 ( .I(n661), .ZN(offset_a[10]) );
  INVD1BWP12T U675 ( .I(n661), .ZN(offset_a[11]) );
  INVD1BWP12T U676 ( .I(n661), .ZN(offset_a[12]) );
  INVD1BWP12T U677 ( .I(n661), .ZN(offset_a[13]) );
  INVD1BWP12T U678 ( .I(n661), .ZN(offset_a[14]) );
  INVD1BWP12T U679 ( .I(n661), .ZN(offset_a[15]) );
  INVD1BWP12T U680 ( .I(n661), .ZN(offset_a[16]) );
  INVD1BWP12T U681 ( .I(n661), .ZN(offset_a[17]) );
  INVD1BWP12T U682 ( .I(n661), .ZN(offset_a[18]) );
  INVD1BWP12T U683 ( .I(n661), .ZN(offset_a[19]) );
  INVD1BWP12T U684 ( .I(n661), .ZN(offset_a[20]) );
  INVD1BWP12T U685 ( .I(n661), .ZN(offset_a[21]) );
  INVD1BWP12T U686 ( .I(n661), .ZN(offset_a[22]) );
  INVD1BWP12T U687 ( .I(n661), .ZN(offset_a[23]) );
  INVD1BWP12T U688 ( .I(n661), .ZN(offset_a[24]) );
  INVD1BWP12T U689 ( .I(n661), .ZN(offset_a[25]) );
  INVD1BWP12T U690 ( .I(n661), .ZN(offset_a[26]) );
  INVD1BWP12T U691 ( .I(n661), .ZN(offset_a[27]) );
  INVD1BWP12T U692 ( .I(n661), .ZN(offset_a[28]) );
  INVD1BWP12T U693 ( .I(n661), .ZN(offset_a[29]) );
  INVD1BWP12T U694 ( .I(n661), .ZN(offset_a[30]) );
  INVD1BWP12T U695 ( .I(n661), .ZN(offset_a[31]) );
  INVD1BWP12T U696 ( .I(n990), .ZN(n1109) );
  AO211D0BWP12T U697 ( .A1(stall_from_instructionfetch), .A2(n881), .B(
        stall_from_controller), .C(n770), .Z(n693) );
  NR2D0BWP12T U698 ( .A1(reset), .A2(n693), .ZN(n1010) );
  NR4D0BWP12T U699 ( .A1(n752), .A2(n1078), .A3(n739), .A4(n931), .ZN(n694) );
  AOI31D0BWP12T U700 ( .A1(n844), .A2(n738), .A3(n694), .B(n1039), .ZN(n695)
         );
  OR2D0BWP12T U701 ( .A1(reset), .A2(n695), .Z(n990) );
  ND3D0BWP12T U702 ( .A1(instruction[12]), .A2(n765), .A3(instruction[15]), 
        .ZN(n758) );
  IOA21D0BWP12T U703 ( .A1(instruction[6]), .A2(n1070), .B(n1016), .ZN(n909)
         );
  OAI21D0BWP12T U704 ( .A1(n778), .A2(n1087), .B(n1000), .ZN(n696) );
  AOI21D0BWP12T U705 ( .A1(n953), .A2(n1043), .B(n696), .ZN(n981) );
  AOI32D0BWP12T U706 ( .A1(n1079), .A2(n1010), .A3(n933), .B1(n932), .B2(n1010), .ZN(n697) );
  AOI21D0BWP12T U707 ( .A1(n1026), .A2(update_flag_v), .B(n908), .ZN(n698) );
  CKND2D0BWP12T U708 ( .A1(n698), .A2(n697), .ZN(n571) );
  ND3D0BWP12T U709 ( .A1(n987), .A2(n982), .A3(n952), .ZN(n699) );
  OA21D0BWP12T U710 ( .A1(n953), .A2(n699), .B(n954), .Z(n700) );
  AOI211D0BWP12T U711 ( .A1(n990), .A2(n984), .B(reset), .C(n700), .ZN(n958)
         );
  CKND0BWP12T U712 ( .I(load_store_width[1]), .ZN(n701) );
  AOI21D0BWP12T U713 ( .A1(n1099), .A2(n934), .B(n817), .ZN(n702) );
  OAI21D0BWP12T U714 ( .A1(instruction[10]), .A2(n818), .B(n702), .ZN(n703) );
  OAI31D0BWP12T U715 ( .A1(n1029), .A2(n1008), .A3(n703), .B(n1010), .ZN(n704)
         );
  OAI211D0BWP12T U716 ( .A1(n884), .A2(n701), .B(n993), .C(n704), .ZN(n647) );
  CKND0BWP12T U717 ( .I(flag_v), .ZN(n705) );
  CKND0BWP12T U718 ( .I(flag_n), .ZN(n706) );
  AOI221D0BWP12T U719 ( .A1(flag_n), .A2(n705), .B1(n706), .B2(flag_v), .C(
        flag_z), .ZN(n707) );
  MOAI22D0BWP12T U720 ( .A1(n707), .A2(n1014), .B1(n707), .B2(n1020), .ZN(n708) );
  AOI32D0BWP12T U721 ( .A1(instruction[8]), .A2(n705), .A3(instruction[9]), 
        .B1(n1016), .B2(flag_v), .ZN(n709) );
  AOI22D0BWP12T U722 ( .A1(instruction[10]), .A2(n1065), .B1(flag_n), .B2(
        n1017), .ZN(n710) );
  AOI22D0BWP12T U723 ( .A1(instruction[9]), .A2(flag_c), .B1(n1064), .B2(
        flag_z), .ZN(n711) );
  MAOI22D0BWP12T U724 ( .A1(n711), .A2(n1015), .B1(n711), .B2(n1015), .ZN(n712) );
  AOI32D0BWP12T U725 ( .A1(instruction[8]), .A2(flag_v), .A3(instruction[9]), 
        .B1(n1016), .B2(n705), .ZN(n713) );
  IND2D0BWP12T U726 ( .A1(flag_z), .B1(flag_c), .ZN(n714) );
  MUX2ND0BWP12T U727 ( .I0(n1020), .I1(n1021), .S(n714), .ZN(n715) );
  OAI21D0BWP12T U728 ( .A1(flag_n), .A2(n713), .B(n715), .ZN(n716) );
  AOI22D0BWP12T U729 ( .A1(n1018), .A2(n712), .B1(n1017), .B2(n716), .ZN(n717)
         );
  OAI221D0BWP12T U730 ( .A1(flag_n), .A2(n1021), .B1(n706), .B2(n1020), .C(
        n1019), .ZN(n718) );
  OAI211D0BWP12T U731 ( .A1(n709), .A2(n710), .B(n717), .C(n718), .ZN(n719) );
  AOI31D0BWP12T U732 ( .A1(instruction[11]), .A2(instruction[10]), .A3(n708), 
        .B(n719), .ZN(n720) );
  OAI21D0BWP12T U733 ( .A1(n1024), .A2(n720), .B(n1022), .ZN(n721) );
  ND4D0BWP12T U734 ( .A1(n1023), .A2(n1013), .A3(n1075), .A4(n1012), .ZN(n722)
         );
  AOI211D0BWP12T U735 ( .A1(n1043), .A2(n1025), .B(n721), .C(n722), .ZN(n723)
         );
  MOAI22D0BWP12T U736 ( .A1(n1039), .A2(n723), .B1(
        alu_stack_write_to_reg_enable), .B2(n1026), .ZN(n632) );
  OA21D1BWP12T U737 ( .A1(n948), .A2(n909), .B(n1069), .Z(n724) );
  INVD1BWP12T U738 ( .I(instruction[10]), .ZN(n841) );
  INVD1BWP12T U739 ( .I(instruction[13]), .ZN(n766) );
  INVD1BWP12T U740 ( .I(instruction[14]), .ZN(n765) );
  NR2D1BWP12T U741 ( .A1(n766), .A2(n758), .ZN(n728) );
  INVD1BWP12T U742 ( .I(n728), .ZN(n726) );
  NR3D1BWP12T U743 ( .A1(instruction[9]), .A2(n841), .A3(n726), .ZN(n1043) );
  NR2D1BWP12T U744 ( .A1(instruction[11]), .A2(instruction[10]), .ZN(n1018) );
  NR2D1BWP12T U745 ( .A1(instruction[9]), .A2(instruction[8]), .ZN(n1020) );
  ND3D1BWP12T U746 ( .A1(n1018), .A2(n728), .A3(n1020), .ZN(n1075) );
  INVD1BWP12T U747 ( .I(n1075), .ZN(n1068) );
  NR2D1BWP12T U748 ( .A1(n1043), .A2(n1068), .ZN(n844) );
  INVD1BWP12T U749 ( .I(instruction[11]), .ZN(n1065) );
  INVD1BWP12T U750 ( .I(instruction[9]), .ZN(n1064) );
  NR2XD0BWP12T U751 ( .A1(instruction[8]), .A2(n1064), .ZN(n1016) );
  INVD1BWP12T U752 ( .I(instruction[8]), .ZN(n1015) );
  AOI21D0BWP12T U753 ( .A1(n1065), .A2(n1015), .B(instruction[10]), .ZN(n725)
         );
  AOI211D0BWP12T U754 ( .A1(instruction[9]), .A2(n1065), .B(n1016), .C(n725), 
        .ZN(n727) );
  INVD1BWP12T U755 ( .I(instruction[15]), .ZN(n767) );
  NR3D1BWP12T U756 ( .A1(n767), .A2(n766), .A3(n765), .ZN(n729) );
  TPNR2D0BWP12T U757 ( .A1(n1065), .A2(instruction[12]), .ZN(n893) );
  MOAI22D0BWP12T U758 ( .A1(n727), .A2(n726), .B1(n729), .B2(n893), .ZN(n880)
         );
  AOI21D1BWP12T U759 ( .A1(instruction[9]), .A2(n728), .B(n880), .ZN(n738) );
  INVD1BWP12T U760 ( .I(step[2]), .ZN(n986) );
  NR2D1BWP12T U761 ( .A1(step[0]), .A2(n986), .ZN(n752) );
  INVD1BWP12T U762 ( .I(step[0]), .ZN(n821) );
  ND2D1BWP12T U763 ( .A1(instruction[12]), .A2(n729), .ZN(n1013) );
  NR2D1BWP12T U764 ( .A1(n821), .A2(n1013), .ZN(n1078) );
  OAI21D1BWP12T U765 ( .A1(instruction[13]), .A2(instruction[14]), .B(
        instruction[15]), .ZN(n739) );
  INVD1BWP12T U766 ( .I(n1013), .ZN(n822) );
  NR2D1BWP12T U767 ( .A1(instruction[13]), .A2(n765), .ZN(n759) );
  ND3D0BWP12T U768 ( .A1(instruction[15]), .A2(instruction[12]), .A3(n759), 
        .ZN(n1024) );
  NR2D1BWP12T U769 ( .A1(instruction[11]), .A2(instruction[12]), .ZN(n834) );
  CKND2D1BWP12T U770 ( .A1(n729), .A2(n834), .ZN(n1012) );
  ND2D1BWP12T U771 ( .A1(n1024), .A2(n1012), .ZN(n861) );
  AOI31D1BWP12T U772 ( .A1(step[1]), .A2(n822), .A3(n821), .B(n861), .ZN(n731)
         );
  NR2D1BWP12T U773 ( .A1(instruction[12]), .A2(n767), .ZN(n730) );
  ND2D1BWP12T U774 ( .A1(n730), .A2(n759), .ZN(n1087) );
  INVD1BWP12T U775 ( .I(instruction[12]), .ZN(n934) );
  ND4D1BWP12T U776 ( .A1(instruction[15]), .A2(instruction[13]), .A3(n934), 
        .A4(n765), .ZN(n1044) );
  ND2D1BWP12T U777 ( .A1(n822), .A2(n1065), .ZN(n819) );
  ND4D1BWP12T U778 ( .A1(n731), .A2(n1087), .A3(n1044), .A4(n819), .ZN(n931)
         );
  INVD1BWP12T U779 ( .I(stall_to_instructionfetch), .ZN(n881) );
  INVD1BWP12T U780 ( .I(memory_load_request), .ZN(n781) );
  INVD1BWP12T U781 ( .I(memory_store_request), .ZN(n800) );
  OAI22D1BWP12T U782 ( .A1(memory_read_finished), .A2(n781), .B1(
        memory_write_finished), .B2(n800), .ZN(n770) );
  INVD1BWP12T U783 ( .I(n1010), .ZN(n1039) );
  ND2D1BWP12T U784 ( .A1(n1043), .A2(n990), .ZN(n996) );
  INVD1BWP12T U785 ( .I(n996), .ZN(n954) );
  ND2D1BWP12T U786 ( .A1(instruction[6]), .A2(step[6]), .ZN(n734) );
  ND2D1BWP12T U787 ( .A1(step[0]), .A2(instruction[0]), .ZN(n802) );
  ND2D1BWP12T U788 ( .A1(step[1]), .A2(instruction[1]), .ZN(n801) );
  ND2D1BWP12T U789 ( .A1(n802), .A2(n801), .ZN(n970) );
  ND2D1BWP12T U790 ( .A1(step[2]), .A2(instruction[2]), .ZN(n740) );
  ND2D1BWP12T U791 ( .A1(instruction[3]), .A2(step[3]), .ZN(n741) );
  ND2D1BWP12T U792 ( .A1(n740), .A2(n741), .ZN(n742) );
  NR2D1BWP12T U793 ( .A1(n970), .A2(n742), .ZN(n744) );
  ND2D1BWP12T U794 ( .A1(instruction[4]), .A2(step[4]), .ZN(n746) );
  ND2D1BWP12T U795 ( .A1(n744), .A2(n746), .ZN(n737) );
  AOI211D1BWP12T U796 ( .A1(instruction[5]), .A2(step[5]), .B(n734), .C(n737), 
        .ZN(n955) );
  INVD1BWP12T U797 ( .I(n955), .ZN(n967) );
  ND2D1BWP12T U798 ( .A1(instruction[7]), .A2(step[7]), .ZN(n733) );
  INVD1BWP12T U799 ( .I(n733), .ZN(n736) );
  ND2D1BWP12T U800 ( .A1(instruction[5]), .A2(step[5]), .ZN(n732) );
  ND2D1BWP12T U801 ( .A1(n734), .A2(n732), .ZN(n735) );
  NR3D1BWP12T U802 ( .A1(n737), .A2(n735), .A3(n733), .ZN(n964) );
  INVD1BWP12T U803 ( .I(n964), .ZN(n832) );
  NR2D1BWP12T U804 ( .A1(n737), .A2(n732), .ZN(n859) );
  ND3D1BWP12T U805 ( .A1(n859), .A2(n734), .A3(n733), .ZN(n747) );
  OAI211D1BWP12T U806 ( .A1(n967), .A2(n736), .B(n832), .C(n747), .ZN(n763) );
  INVD1BWP12T U807 ( .I(n763), .ZN(n776) );
  NR2D1BWP12T U808 ( .A1(n736), .A2(n735), .ZN(n751) );
  IND3D1BWP12T U809 ( .A1(n737), .B1(n751), .B2(instruction[8]), .ZN(n966) );
  OAI21D1BWP12T U810 ( .A1(n776), .A2(instruction[8]), .B(n966), .ZN(n951) );
  CKND0BWP12T U811 ( .I(n738), .ZN(n946) );
  CKND2D0BWP12T U812 ( .A1(n1075), .A2(n1044), .ZN(n760) );
  NR4D0BWP12T U813 ( .A1(n861), .A2(n946), .A3(n760), .A4(n739), .ZN(n883) );
  MOAI22D0BWP12T U814 ( .A1(n802), .A2(n801), .B1(n802), .B2(n801), .ZN(n743)
         );
  NR2D1BWP12T U815 ( .A1(n970), .A2(n740), .ZN(n749) );
  AOI211D1BWP12T U816 ( .A1(instruction[2]), .A2(step[2]), .B(n970), .C(n741), 
        .ZN(n965) );
  AOI21D0BWP12T U817 ( .A1(n749), .A2(n741), .B(n965), .ZN(n1033) );
  OAI21D0BWP12T U818 ( .A1(n743), .A2(n742), .B(n1033), .ZN(n745) );
  IND2D1BWP12T U819 ( .A1(n746), .B1(n744), .ZN(n994) );
  INVD1BWP12T U820 ( .I(n994), .ZN(n774) );
  AOI32D1BWP12T U821 ( .A1(n746), .A2(n751), .A3(n745), .B1(n774), .B2(n751), 
        .ZN(n778) );
  INVD1BWP12T U822 ( .I(n1087), .ZN(n1008) );
  CKND2D1BWP12T U823 ( .A1(n751), .A2(n746), .ZN(n748) );
  INVD1BWP12T U824 ( .I(n970), .ZN(n777) );
  ND2D1BWP12T U825 ( .A1(n778), .A2(n747), .ZN(n794) );
  INVD1BWP12T U826 ( .I(n794), .ZN(n795) );
  INVD1BWP12T U827 ( .I(n749), .ZN(n988) );
  ND3D1BWP12T U828 ( .A1(n777), .A2(n795), .A3(n988), .ZN(n775) );
  NR2D1BWP12T U829 ( .A1(n748), .A2(n775), .ZN(n762) );
  ND2D1BWP12T U830 ( .A1(n1008), .A2(n762), .ZN(n1000) );
  NR2D1BWP12T U831 ( .A1(n965), .A2(n749), .ZN(n987) );
  NR2D0BWP12T U832 ( .A1(instruction[8]), .A2(n970), .ZN(n750) );
  ND4D1BWP12T U833 ( .A1(n751), .A2(n987), .A3(n750), .A4(n994), .ZN(n976) );
  TPOAI21D0BWP12T U834 ( .A1(n778), .A2(instruction[8]), .B(n976), .ZN(n953)
         );
  CKND0BWP12T U835 ( .I(n819), .ZN(n862) );
  IND2XD0BWP12T U836 ( .A1(step[1]), .B1(n752), .ZN(n944) );
  NR2D0BWP12T U837 ( .A1(n1013), .A2(n944), .ZN(n753) );
  AOI211D0BWP12T U838 ( .A1(n1008), .A2(n763), .B(n862), .C(n753), .ZN(n754)
         );
  AOI31D1BWP12T U839 ( .A1(n883), .A2(n981), .A3(n754), .B(n1109), .ZN(n755)
         );
  AOI211D1BWP12T U840 ( .A1(n954), .A2(n951), .B(reset), .C(n755), .ZN(n783)
         );
  INVD1BWP12T U841 ( .I(n783), .ZN(n756) );
  AOI221D1BWP12T U842 ( .A1(step[1]), .A2(n1109), .B1(n1078), .B2(n990), .C(
        n756), .ZN(n757) );
  CKND2D0BWP12T U843 ( .A1(n1008), .A2(n990), .ZN(n995) );
  AOI32D0BWP12T U844 ( .A1(n996), .A2(n757), .A3(n995), .B1(n802), .B2(n757), 
        .ZN(n639) );
  NR2D1BWP12T U845 ( .A1(instruction[13]), .A2(n758), .ZN(n1029) );
  INVD1BWP12T U846 ( .I(instruction[2]), .ZN(n1095) );
  INVD1BWP12T U847 ( .I(n1018), .ZN(n870) );
  CKND2D0BWP12T U848 ( .A1(n759), .A2(n767), .ZN(n761) );
  NR2D1BWP12T U849 ( .A1(n934), .A2(n761), .ZN(n928) );
  ND2D1BWP12T U850 ( .A1(instruction[9]), .A2(n928), .ZN(n1006) );
  NR2D1BWP12T U851 ( .A1(n870), .A2(n1006), .ZN(n1034) );
  INVD0BWP12T U852 ( .I(n1034), .ZN(n807) );
  NR2D1BWP12T U853 ( .A1(n1018), .A2(n1006), .ZN(n1036) );
  TPNR2D0BWP12T U854 ( .A1(n822), .A2(n861), .ZN(n1058) );
  INVD1BWP12T U855 ( .I(n1058), .ZN(n1045) );
  NR2XD0BWP12T U856 ( .A1(n1045), .A2(n946), .ZN(n835) );
  INR3XD0BWP12T U857 ( .A1(n835), .B1(n1043), .B2(n760), .ZN(n784) );
  OR2D1BWP12T U858 ( .A1(n761), .A2(instruction[12]), .Z(n869) );
  ND2D1BWP12T U859 ( .A1(n767), .A2(n765), .ZN(n906) );
  ND3D1BWP12T U860 ( .A1(n784), .A2(n869), .A3(n906), .ZN(n817) );
  NR2D1BWP12T U861 ( .A1(n1036), .A2(n817), .ZN(n1002) );
  NR2XD0BWP12T U862 ( .A1(n859), .A2(n762), .ZN(n804) );
  NR3D0BWP12T U863 ( .A1(n763), .A2(n774), .A3(n955), .ZN(n764) );
  CKND2D0BWP12T U864 ( .A1(n804), .A2(n764), .ZN(n768) );
  NR3D1BWP12T U865 ( .A1(instruction[15]), .A2(n766), .A3(n765), .ZN(n1099) );
  NR4D0BWP12T U866 ( .A1(instruction[13]), .A2(instruction[12]), .A3(
        instruction[14]), .A4(n767), .ZN(n1098) );
  NR2D1BWP12T U867 ( .A1(n1099), .A2(n1098), .ZN(n840) );
  CKND2D0BWP12T U868 ( .A1(n928), .A2(n1064), .ZN(n818) );
  ND2D1BWP12T U869 ( .A1(n840), .A2(n818), .ZN(n1030) );
  AOI22D1BWP12T U870 ( .A1(n1008), .A2(n768), .B1(instruction[2]), .B2(n1030), 
        .ZN(n788) );
  OAI211D1BWP12T U871 ( .A1(n1095), .A2(n807), .B(n1002), .C(n788), .ZN(n769)
         );
  AOI211D1BWP12T U872 ( .A1(n1029), .A2(instruction[10]), .B(instruction[11]), 
        .C(n769), .ZN(n773) );
  INVD1BWP12T U873 ( .I(reset), .ZN(n993) );
  OAI21D0BWP12T U874 ( .A1(stall_from_controller), .A2(n770), .B(n993), .ZN(
        n771) );
  ND3D1BWP12T U875 ( .A1(n993), .A2(n1039), .A3(n771), .ZN(n890) );
  AN2XD1BWP12T U876 ( .A1(n771), .A2(n890), .Z(n884) );
  INVD1BWP12T U877 ( .I(n884), .ZN(n1038) );
  CKND2D0BWP12T U878 ( .A1(memory_store_data_reg[2]), .A2(n1038), .ZN(n772) );
  OAI211D0BWP12T U879 ( .A1(n773), .A2(n1039), .B(n993), .C(n772), .ZN(n628)
         );
  NR2D1BWP12T U880 ( .A1(n987), .A2(n794), .ZN(n792) );
  NR2D1BWP12T U881 ( .A1(n774), .A2(n859), .ZN(n952) );
  NR2D0BWP12T U882 ( .A1(n952), .A2(n775), .ZN(n793) );
  ND2D1BWP12T U883 ( .A1(n777), .A2(n776), .ZN(n985) );
  INR4D0BWP12T U884 ( .A1(n778), .B1(n792), .B2(n793), .B3(n985), .ZN(n959) );
  NR2D1BWP12T U885 ( .A1(n1029), .A2(n1030), .ZN(n790) );
  AOI32D1BWP12T U886 ( .A1(n959), .A2(n790), .A3(n967), .B1(n1087), .B2(n790), 
        .ZN(n779) );
  ND2D1BWP12T U887 ( .A1(instruction[11]), .A2(n779), .ZN(n1001) );
  INVD1BWP12T U888 ( .I(n1001), .ZN(n780) );
  NR2D1BWP12T U889 ( .A1(n1065), .A2(n869), .ZN(n1052) );
  OAI31D0BWP12T U890 ( .A1(n780), .A2(n1036), .A3(n1052), .B(n1010), .ZN(n782)
         );
  OAI21D0BWP12T U891 ( .A1(n884), .A2(n781), .B(n782), .ZN(n657) );
  INVD1BWP12T U892 ( .I(memory_write_to_reg_enable), .ZN(n905) );
  OAI21D0BWP12T U893 ( .A1(n905), .A2(n884), .B(n782), .ZN(n620) );
  OAI21D0BWP12T U894 ( .A1(n821), .A2(n990), .B(n783), .ZN(n659) );
  NR2D1BWP12T U895 ( .A1(instruction[11]), .A2(n869), .ZN(n1053) );
  TPND3D0BWP12T U896 ( .A1(n906), .A2(n807), .A3(n784), .ZN(n785) );
  NR2D1BWP12T U897 ( .A1(n1053), .A2(n785), .ZN(n812) );
  NR2XD0BWP12T U898 ( .A1(instruction[10]), .A2(n1065), .ZN(n1017) );
  NR2D0BWP12T U899 ( .A1(n1029), .A2(n1052), .ZN(n839) );
  MOAI22D0BWP12T U900 ( .A1(n1017), .A2(n839), .B1(instruction[2]), .B2(n1036), 
        .ZN(n786) );
  OAI32D0BWP12T U901 ( .A1(n786), .A2(n1008), .A3(n1030), .B1(n1065), .B2(n786), .ZN(n787) );
  AOI31D0BWP12T U902 ( .A1(n812), .A2(n788), .A3(n787), .B(n1039), .ZN(n789)
         );
  AO211D0BWP12T U903 ( .A1(memory_write_to_reg[2]), .A2(n1038), .B(reset), .C(
        n789), .Z(n623) );
  CKND0BWP12T U904 ( .I(n790), .ZN(n798) );
  TPNR2D0BWP12T U905 ( .A1(n1008), .A2(n798), .ZN(n813) );
  AOI32D1BWP12T U906 ( .A1(instruction[11]), .A2(n812), .A3(n1000), .B1(n813), 
        .B2(n812), .ZN(n791) );
  AOI21D0BWP12T U907 ( .A1(n1010), .A2(n791), .B(reset), .ZN(n810) );
  IOA21D0BWP12T U908 ( .A1(memory_write_to_reg[3]), .A2(n1038), .B(n810), .ZN(
        n622) );
  NR3XD0BWP12T U909 ( .A1(n955), .A2(n964), .A3(n792), .ZN(n1031) );
  AOI221D0BWP12T U910 ( .A1(n795), .A2(n970), .B1(n794), .B2(n1065), .C(n793), 
        .ZN(n796) );
  TPAOI21D0BWP12T U911 ( .A1(n1031), .A2(n796), .B(n1087), .ZN(n797) );
  AOI211XD0BWP12T U912 ( .A1(n1065), .A2(n798), .B(n797), .C(n1034), .ZN(n799)
         );
  OAI22D0BWP12T U913 ( .A1(n884), .A2(n800), .B1(n799), .B2(n1039), .ZN(n656)
         );
  CKND0BWP12T U914 ( .I(n801), .ZN(n803) );
  RCAOI211D0BWP12T U915 ( .A1(n803), .A2(n802), .B(n964), .C(n965), .ZN(n860)
         );
  AOI22D1BWP12T U916 ( .A1(instruction[0]), .A2(n1030), .B1(n1029), .B2(
        instruction[8]), .ZN(n805) );
  AOI32D1BWP12T U917 ( .A1(n860), .A2(n805), .A3(n804), .B1(n1087), .B2(n805), 
        .ZN(n806) );
  AOI21D0BWP12T U918 ( .A1(n1010), .A2(n806), .B(reset), .ZN(n816) );
  INVD1BWP12T U919 ( .I(instruction[0]), .ZN(n1082) );
  OAI211D0BWP12T U920 ( .A1(n1082), .A2(n807), .B(n1002), .C(n1065), .ZN(n808)
         );
  AOI22D0BWP12T U921 ( .A1(n1010), .A2(n808), .B1(memory_store_data_reg[0]), 
        .B2(n1038), .ZN(n809) );
  TPND2D0BWP12T U922 ( .A1(n816), .A2(n809), .ZN(n630) );
  IOA21D0BWP12T U923 ( .A1(memory_write_to_reg[4]), .A2(n1038), .B(n810), .ZN(
        n621) );
  AOI22D0BWP12T U924 ( .A1(instruction[0]), .A2(n1036), .B1(instruction[8]), 
        .B2(n1052), .ZN(n811) );
  OAI211D0BWP12T U925 ( .A1(instruction[11]), .A2(n813), .B(n812), .C(n811), 
        .ZN(n814) );
  AOI22D0BWP12T U926 ( .A1(n1010), .A2(n814), .B1(memory_write_to_reg[0]), 
        .B2(n1038), .ZN(n815) );
  TPND2D0BWP12T U927 ( .A1(n816), .A2(n815), .ZN(n625) );
  ND2D1BWP12T U928 ( .A1(n1010), .A2(n990), .ZN(n1110) );
  NR2D1BWP12T U929 ( .A1(n819), .A2(n1110), .ZN(n852) );
  AOI22D1BWP12T U930 ( .A1(instruction[9]), .A2(n852), .B1(n1109), .B2(
        offset_b[21]), .ZN(n820) );
  INVD1BWP12T U931 ( .I(instruction[7]), .ZN(n1070) );
  NR2D1BWP12T U932 ( .A1(n1070), .A2(n1110), .ZN(n849) );
  IND2D1BWP12T U933 ( .A1(n1024), .B1(n849), .ZN(n1005) );
  CKND2D0BWP12T U934 ( .A1(n820), .A2(n1005), .ZN(n583) );
  ND4D1BWP12T U935 ( .A1(instruction[11]), .A2(step[1]), .A3(n822), .A4(n821), 
        .ZN(n854) );
  AO21D0BWP12T U936 ( .A1(n1012), .A2(n854), .B(n1110), .Z(n851) );
  ND2D1BWP12T U937 ( .A1(n1109), .A2(offset_b[10]), .ZN(n823) );
  OAI211D0BWP12T U938 ( .A1(n1064), .A2(n851), .B(n1005), .C(n823), .ZN(n594)
         );
  ND2D1BWP12T U939 ( .A1(n1109), .A2(offset_b[11]), .ZN(n824) );
  OAI211D0BWP12T U940 ( .A1(n841), .A2(n851), .B(n1005), .C(n824), .ZN(n593)
         );
  AOI22D1BWP12T U941 ( .A1(instruction[4]), .A2(n852), .B1(n1109), .B2(
        offset_b[16]), .ZN(n825) );
  CKND2D0BWP12T U942 ( .A1(n825), .A2(n1005), .ZN(n588) );
  AOI22D1BWP12T U943 ( .A1(instruction[10]), .A2(n852), .B1(n1109), .B2(
        offset_b[22]), .ZN(n826) );
  CKND2D0BWP12T U944 ( .A1(n826), .A2(n1005), .ZN(n582) );
  AOI22D1BWP12T U945 ( .A1(instruction[5]), .A2(n852), .B1(n1109), .B2(
        offset_b[17]), .ZN(n827) );
  CKND2D0BWP12T U946 ( .A1(n827), .A2(n1005), .ZN(n587) );
  AOI22D1BWP12T U947 ( .A1(instruction[0]), .A2(n852), .B1(n1109), .B2(
        offset_b[12]), .ZN(n828) );
  CKND2D0BWP12T U948 ( .A1(n828), .A2(n1005), .ZN(n592) );
  AOI22D1BWP12T U949 ( .A1(instruction[7]), .A2(n852), .B1(n1109), .B2(
        offset_b[19]), .ZN(n829) );
  CKND2D0BWP12T U950 ( .A1(n829), .A2(n1005), .ZN(n585) );
  AOI22D1BWP12T U951 ( .A1(instruction[2]), .A2(n852), .B1(n1109), .B2(
        offset_b[14]), .ZN(n830) );
  CKND2D0BWP12T U952 ( .A1(n830), .A2(n1005), .ZN(n590) );
  AOI22D1BWP12T U953 ( .A1(instruction[1]), .A2(n852), .B1(n1109), .B2(
        offset_b[13]), .ZN(n831) );
  CKND2D0BWP12T U954 ( .A1(n831), .A2(n1005), .ZN(n591) );
  CKND1BWP12T U955 ( .I(n976), .ZN(n858) );
  INVD1BWP12T U956 ( .I(n952), .ZN(n969) );
  CKND2D0BWP12T U957 ( .A1(n967), .A2(n832), .ZN(n833) );
  NR4D0BWP12T U958 ( .A1(n858), .A2(n951), .A3(n969), .A4(n833), .ZN(n940) );
  NR2D1BWP12T U959 ( .A1(instruction[13]), .A2(n906), .ZN(n933) );
  TPNR2D0BWP12T U960 ( .A1(n928), .A2(n933), .ZN(n897) );
  ND2D1BWP12T U961 ( .A1(n840), .A2(n897), .ZN(n1041) );
  INVD1BWP12T U962 ( .I(n906), .ZN(n1080) );
  ND2D1BWP12T U963 ( .A1(instruction[13]), .A2(n1080), .ZN(n1094) );
  CKND2D0BWP12T U964 ( .A1(n1087), .A2(n1094), .ZN(n1047) );
  AO222D1BWP12T U965 ( .A1(n1041), .A2(instruction[5]), .B1(n1047), .B2(
        instruction[10]), .C1(n1053), .C2(instruction[2]), .Z(n836) );
  CKND2D0BWP12T U966 ( .A1(n839), .A2(n1044), .ZN(n848) );
  OR2XD1BWP12T U967 ( .A1(n848), .A2(n1068), .Z(n1108) );
  NR2D0BWP12T U968 ( .A1(instruction[11]), .A2(n841), .ZN(n1019) );
  INR2D1BWP12T U969 ( .A1(n1019), .B1(n869), .ZN(n929) );
  INVD1BWP12T U970 ( .I(n1094), .ZN(n1105) );
  AOI22D1BWP12T U971 ( .A1(instruction[9]), .A2(n929), .B1(n834), .B2(n1105), 
        .ZN(n1049) );
  CKND0BWP12T U972 ( .I(n1049), .ZN(n947) );
  NR2D1BWP12T U973 ( .A1(n1108), .A2(n947), .ZN(n865) );
  AOI31D1BWP12T U974 ( .A1(n835), .A2(n865), .A3(n993), .B(n1109), .ZN(n977)
         );
  AOI221D1BWP12T U975 ( .A1(operand_a[2]), .A2(n1109), .B1(n836), .B2(n990), 
        .C(n977), .ZN(n837) );
  AOI32D0BWP12T U976 ( .A1(n940), .A2(n837), .A3(n1065), .B1(n996), .B2(n837), 
        .ZN(n617) );
  AOI22D1BWP12T U977 ( .A1(instruction[8]), .A2(n852), .B1(n1109), .B2(
        offset_b[20]), .ZN(n838) );
  CKND2D0BWP12T U978 ( .A1(n838), .A2(n1005), .ZN(n584) );
  INVD1BWP12T U979 ( .I(instruction[6]), .ZN(n888) );
  INVD1BWP12T U980 ( .I(n929), .ZN(n960) );
  CKND2D0BWP12T U981 ( .A1(n1087), .A2(n1044), .ZN(n842) );
  ND2D1BWP12T U982 ( .A1(n840), .A2(n839), .ZN(n927) );
  TPNR2D0BWP12T U983 ( .A1(n1065), .A2(n934), .ZN(n1079) );
  INVD1BWP12T U984 ( .I(n933), .ZN(n1066) );
  AOI21D1BWP12T U985 ( .A1(n1079), .A2(n841), .B(n1066), .ZN(n1091) );
  NR4D0BWP12T U986 ( .A1(n1105), .A2(n842), .A3(n927), .A4(n1091), .ZN(n843)
         );
  ND3D0BWP12T U987 ( .A1(n1058), .A2(n844), .A3(n843), .ZN(n898) );
  OAI32D0BWP12T U988 ( .A1(reset), .A2(n946), .A3(n898), .B1(n1010), .B2(reset), .ZN(n879) );
  CKND0BWP12T U989 ( .I(n879), .ZN(n845) );
  TPAOI21D0BWP12T U990 ( .A1(operand_b[3]), .A2(n1038), .B(n845), .ZN(n846) );
  OAI31D0BWP12T U991 ( .A1(n1039), .A2(n888), .A3(n960), .B(n846), .ZN(n569)
         );
  AOI22D1BWP12T U992 ( .A1(instruction[6]), .A2(n852), .B1(n1109), .B2(
        offset_b[18]), .ZN(n847) );
  CKND2D0BWP12T U993 ( .A1(n847), .A2(n1005), .ZN(n586) );
  AOI22D1BWP12T U994 ( .A1(n1109), .A2(offset_b[9]), .B1(n849), .B2(n848), 
        .ZN(n850) );
  OAI211D0BWP12T U995 ( .A1(n1015), .A2(n851), .B(n850), .C(n1005), .ZN(n595)
         );
  AOI22D1BWP12T U996 ( .A1(instruction[3]), .A2(n852), .B1(n1109), .B2(
        offset_b[15]), .ZN(n853) );
  CKND2D0BWP12T U997 ( .A1(n853), .A2(n1005), .ZN(n589) );
  INR2D1BWP12T U998 ( .A1(n854), .B1(n861), .ZN(n1103) );
  INVD1BWP12T U999 ( .I(n1103), .ZN(n1107) );
  AOI22D0BWP12T U1000 ( .A1(instruction[4]), .A2(n1108), .B1(instruction[5]), 
        .B2(n1107), .ZN(n857) );
  ND2D1BWP12T U1001 ( .A1(n1109), .A2(offset_b[6]), .ZN(n856) );
  AOI22D1BWP12T U1002 ( .A1(instruction[6]), .A2(n1105), .B1(n1099), .B2(
        instruction[10]), .ZN(n855) );
  AOI32D0BWP12T U1003 ( .A1(n857), .A2(n856), .A3(n855), .B1(n1110), .B2(n856), 
        .ZN(n598) );
  INR3D0BWP12T U1004 ( .A1(n860), .B1(n859), .B2(n858), .ZN(n911) );
  NR2D0BWP12T U1005 ( .A1(n861), .A2(n946), .ZN(n866) );
  AOI22D0BWP12T U1006 ( .A1(instruction[0]), .A2(n1053), .B1(instruction[8]), 
        .B2(n1047), .ZN(n864) );
  AOI211D0BWP12T U1007 ( .A1(instruction[3]), .A2(n1041), .B(n1078), .C(n862), 
        .ZN(n863) );
  ND4D1BWP12T U1008 ( .A1(n866), .A2(n865), .A3(n864), .A4(n863), .ZN(n867) );
  AOI221D1BWP12T U1009 ( .A1(operand_a[0]), .A2(n1109), .B1(n867), .B2(n990), 
        .C(reset), .ZN(n868) );
  AOI32D0BWP12T U1010 ( .A1(n911), .A2(n868), .A3(n1065), .B1(n996), .B2(n868), 
        .ZN(n619) );
  NR3D1BWP12T U1011 ( .A1(n928), .A2(n946), .A3(n927), .ZN(n972) );
  ND3D1BWP12T U1012 ( .A1(n1058), .A2(n972), .A3(n1075), .ZN(n938) );
  CKND2D0BWP12T U1013 ( .A1(instruction[8]), .A2(n1064), .ZN(n1014) );
  OAI211D1BWP12T U1014 ( .A1(n893), .A2(n1094), .B(n1087), .C(n1044), .ZN(
        n1056) );
  TPAOI21D0BWP12T U1015 ( .A1(n929), .A2(n1014), .B(n1056), .ZN(n1023) );
  NR2D1BWP12T U1016 ( .A1(n870), .A2(n869), .ZN(n1067) );
  TPOAI22D0BWP12T U1017 ( .A1(instruction[8]), .A2(instruction[12]), .B1(n1067), .B2(instruction[12]), .ZN(n871) );
  ND2D1BWP12T U1018 ( .A1(n1023), .A2(n871), .ZN(n872) );
  OAI32D1BWP12T U1019 ( .A1(n1109), .A2(n938), .A3(n872), .B1(alu_opcode[2]), 
        .B2(n990), .ZN(n873) );
  CKND2D1BWP12T U1020 ( .A1(n873), .A2(n993), .ZN(n607) );
  INVD1BWP12T U1021 ( .I(operand_b[0]), .ZN(n875) );
  CKND1BWP12T U1022 ( .I(n897), .ZN(n876) );
  AOI22D1BWP12T U1023 ( .A1(instruction[3]), .A2(n1053), .B1(instruction[6]), 
        .B2(n876), .ZN(n874) );
  OAI221D0BWP12T U1024 ( .A1(n884), .A2(n875), .B1(n1038), .B2(n874), .C(n879), 
        .ZN(n566) );
  INVD1BWP12T U1025 ( .I(operand_b[2]), .ZN(n878) );
  AOI22D1BWP12T U1026 ( .A1(instruction[5]), .A2(n1053), .B1(instruction[8]), 
        .B2(n876), .ZN(n877) );
  OAI221D0BWP12T U1027 ( .A1(n884), .A2(n878), .B1(n1038), .B2(n877), .C(n879), 
        .ZN(n568) );
  IOA21D0BWP12T U1028 ( .A1(operand_b[4]), .A2(n1038), .B(n879), .ZN(n570) );
  NR2D0BWP12T U1029 ( .A1(n1065), .A2(n1013), .ZN(n945) );
  NR4D0BWP12T U1030 ( .A1(n1008), .A2(n1043), .A3(n945), .A4(n880), .ZN(n882)
         );
  OAI22D0BWP12T U1031 ( .A1(n882), .A2(n1110), .B1(n881), .B2(n990), .ZN(n655)
         );
  ND2D1BWP12T U1032 ( .A1(n883), .A2(n1013), .ZN(n984) );
  OAI31D1BWP12T U1033 ( .A1(n984), .A2(reset), .A3(n1043), .B(n884), .ZN(n999)
         );
  AOI22D0BWP12T U1034 ( .A1(n1010), .A2(instruction[10]), .B1(
        memory_store_address_reg[2]), .B2(n1038), .ZN(n885) );
  TPND2D0BWP12T U1035 ( .A1(n999), .A2(n885), .ZN(n643) );
  AOI22D0BWP12T U1036 ( .A1(n1010), .A2(instruction[8]), .B1(
        memory_store_address_reg[0]), .B2(n1038), .ZN(n886) );
  TPND2D0BWP12T U1037 ( .A1(n999), .A2(n886), .ZN(n645) );
  CKND2D1BWP12T U1038 ( .A1(memorycontroller_sign_extend), .A2(n1038), .ZN(
        n887) );
  OAI31D0BWP12T U1039 ( .A1(n1006), .A2(n1065), .A3(n1039), .B(n887), .ZN(n649) );
  AOI31D0BWP12T U1040 ( .A1(n888), .A2(n1070), .A3(n1015), .B(instruction[9]), 
        .ZN(n889) );
  NR2D1BWP12T U1041 ( .A1(n934), .A2(n1094), .ZN(n932) );
  AOI211D1BWP12T U1042 ( .A1(n1067), .A2(n889), .B(n933), .C(n932), .ZN(n896)
         );
  INVD1BWP12T U1043 ( .I(n890), .ZN(n1026) );
  INVD1BWP12T U1044 ( .I(n1014), .ZN(n1021) );
  OAI211D0BWP12T U1045 ( .A1(n1021), .A2(n1016), .B(instruction[6]), .C(n1070), 
        .ZN(n891) );
  OAI31D0BWP12T U1046 ( .A1(instruction[6]), .A2(n1070), .A3(n1014), .B(n891), 
        .ZN(n892) );
  AOI21D1BWP12T U1047 ( .A1(instruction[7]), .A2(n1016), .B(n892), .ZN(n894)
         );
  INVD1BWP12T U1048 ( .I(n1067), .ZN(n948) );
  AOI22D1BWP12T U1049 ( .A1(n893), .A2(n1105), .B1(n1021), .B2(n929), .ZN(
        n1069) );
  OAI32D0BWP12T U1050 ( .A1(n1039), .A2(n894), .A3(n948), .B1(n1069), .B2(
        n1039), .ZN(n908) );
  AOI21D0BWP12T U1051 ( .A1(n1026), .A2(update_flag_c), .B(n908), .ZN(n895) );
  OAI21D0BWP12T U1052 ( .A1(n896), .A2(n1039), .B(n895), .ZN(n572) );
  NR2D0BWP12T U1053 ( .A1(n897), .A2(n1070), .ZN(n899) );
  RCAOI211D0BWP12T U1054 ( .A1(n1053), .A2(instruction[4]), .B(n899), .C(n898), 
        .ZN(n900) );
  MOAI22D0BWP12T U1055 ( .A1(n900), .A2(n1039), .B1(operand_b[1]), .B2(n1038), 
        .ZN(n567) );
  ND4D0BWP12T U1056 ( .A1(memory_write_to_reg[0]), .A2(memory_write_to_reg[1]), 
        .A3(memory_write_to_reg[2]), .A4(memory_write_to_reg[3]), .ZN(n904) );
  INVD1BWP12T U1057 ( .I(alu_stack_write_to_reg[0]), .ZN(n916) );
  IND4D1BWP12T U1058 ( .A1(alu_stack_write_to_reg[4]), .B1(
        alu_stack_write_to_reg[3]), .B2(alu_stack_write_to_reg[2]), .B3(
        alu_stack_write_to_reg[1]), .ZN(n901) );
  NR2D1BWP12T U1059 ( .A1(n916), .A2(n901), .ZN(n902) );
  AOI22D1BWP12T U1060 ( .A1(instruction[8]), .A2(stack_pop_request), .B1(
        alu_stack_write_to_reg_enable), .B2(n902), .ZN(n903) );
  OAI31D1BWP12T U1061 ( .A1(memory_write_to_reg[4]), .A2(n905), .A3(n904), .B(
        n903), .ZN(N170) );
  AOI31D0BWP12T U1062 ( .A1(n906), .A2(n948), .A3(n724), .B(n1039), .ZN(n907)
         );
  AO21D1BWP12T U1063 ( .A1(n1026), .A2(update_flag_z), .B(n907), .Z(n640) );
  AO21D1BWP12T U1064 ( .A1(n1026), .A2(update_flag_n), .B(n907), .Z(n650) );
  TPAOI21D0BWP12T U1065 ( .A1(n1067), .A2(n909), .B(n933), .ZN(n1022) );
  OAI21D1BWP12T U1066 ( .A1(instruction[8]), .A2(n960), .B(n1022), .ZN(n1062)
         );
  CKND0BWP12T U1067 ( .I(n1043), .ZN(n910) );
  TPAOI31D0BWP12T U1068 ( .A1(instruction[11]), .A2(n911), .A3(n966), .B(n910), 
        .ZN(n915) );
  NR2D0BWP12T U1069 ( .A1(n1064), .A2(n1015), .ZN(n912) );
  ND2XD0BWP12T U1070 ( .A1(n912), .A2(n929), .ZN(n1057) );
  ND2D1BWP12T U1071 ( .A1(n724), .A2(n1057), .ZN(n939) );
  AOI211D0BWP12T U1072 ( .A1(instruction[8]), .A2(n1056), .B(n1068), .C(n1107), 
        .ZN(n913) );
  IND3D1BWP12T U1073 ( .A1(n939), .B1(n972), .B2(n913), .ZN(n914) );
  AOI211D1BWP12T U1074 ( .A1(instruction[0]), .A2(n1062), .B(n915), .C(n914), 
        .ZN(n917) );
  OAI221D1BWP12T U1075 ( .A1(n1109), .A2(n917), .B1(n990), .B2(n916), .C(n993), 
        .ZN(n614) );
  NR2D0BWP12T U1076 ( .A1(n1079), .A2(n1066), .ZN(n922) );
  AOI22D1BWP12T U1077 ( .A1(instruction[7]), .A2(n1099), .B1(instruction[9]), 
        .B2(n922), .ZN(n920) );
  AOI22D1BWP12T U1078 ( .A1(instruction[3]), .A2(n1105), .B1(n1098), .B2(
        instruction[8]), .ZN(n919) );
  AOI22D0BWP12T U1079 ( .A1(instruction[1]), .A2(n1108), .B1(instruction[2]), 
        .B2(n1107), .ZN(n918) );
  AOI31D0BWP12T U1080 ( .A1(n920), .A2(n919), .A3(n918), .B(n1110), .ZN(n921)
         );
  AO21D1BWP12T U1081 ( .A1(n1109), .A2(offset_b[3]), .B(n921), .Z(n601) );
  AOI22D1BWP12T U1082 ( .A1(n1099), .A2(instruction[8]), .B1(instruction[10]), 
        .B2(n922), .ZN(n925) );
  AOI22D1BWP12T U1083 ( .A1(instruction[4]), .A2(n1105), .B1(n1098), .B2(
        instruction[9]), .ZN(n924) );
  AOI22D0BWP12T U1084 ( .A1(instruction[2]), .A2(n1108), .B1(instruction[3]), 
        .B2(n1107), .ZN(n923) );
  AOI31D0BWP12T U1085 ( .A1(n925), .A2(n924), .A3(n923), .B(n1110), .ZN(n926)
         );
  AO21D1BWP12T U1086 ( .A1(n1109), .A2(offset_b[4]), .B(n926), .Z(n600) );
  AOI22D0BWP12T U1087 ( .A1(instruction[6]), .A2(n1067), .B1(n1068), .B2(n1070), .ZN(n936) );
  AO211D0BWP12T U1088 ( .A1(n1020), .A2(n929), .B(n928), .C(n927), .Z(n930) );
  AOI211D0BWP12T U1089 ( .A1(n932), .A2(n1065), .B(n931), .C(n930), .ZN(n1076)
         );
  OAI211D0BWP12T U1090 ( .A1(n1064), .A2(n934), .B(instruction[11]), .C(n933), 
        .ZN(n935) );
  AOI31D0BWP12T U1091 ( .A1(n936), .A2(n1076), .A3(n935), .B(n1110), .ZN(n937)
         );
  AO21D1BWP12T U1092 ( .A1(n1109), .A2(alu_opcode[0]), .B(n937), .Z(n609) );
  AOI22D1BWP12T U1093 ( .A1(instruction[2]), .A2(n1062), .B1(instruction[10]), 
        .B2(n1056), .ZN(n943) );
  OAI31D0BWP12T U1094 ( .A1(n939), .A2(reset), .A3(n938), .B(n990), .ZN(n961)
         );
  CKND2D1BWP12T U1095 ( .A1(instruction[11]), .A2(n940), .ZN(n941) );
  AOI22D1BWP12T U1096 ( .A1(n1109), .A2(alu_stack_write_to_reg[2]), .B1(n954), 
        .B2(n941), .ZN(n942) );
  OAI211D1BWP12T U1097 ( .A1(n1109), .A2(n943), .B(n961), .C(n942), .ZN(n612)
         );
  INR2D1BWP12T U1098 ( .A1(n945), .B1(n944), .ZN(n1084) );
  OR3D1BWP12T U1099 ( .A1(n1084), .A2(n947), .A3(n946), .Z(n963) );
  OAI21D0BWP12T U1100 ( .A1(n1064), .A2(n948), .B(n1069), .ZN(n949) );
  OAI32D1BWP12T U1101 ( .A1(n1109), .A2(n963), .A3(n949), .B1(alu_opcode[3]), 
        .B2(n990), .ZN(n950) );
  ND3D1BWP12T U1102 ( .A1(n950), .A2(n993), .A3(n996), .ZN(n606) );
  TPNR2D0BWP12T U1103 ( .A1(n970), .A2(n951), .ZN(n982) );
  AOI22D1BWP12T U1104 ( .A1(n955), .A2(n954), .B1(step[7]), .B2(n1109), .ZN(
        n956) );
  ND3D1BWP12T U1105 ( .A1(n958), .A2(n956), .A3(n995), .ZN(n658) );
  MAOI22D0BWP12T U1106 ( .A1(n1109), .A2(step[6]), .B1(n1000), .B2(n1109), 
        .ZN(n957) );
  OAI211D1BWP12T U1107 ( .A1(n959), .A2(n995), .B(n958), .C(n957), .ZN(n634)
         );
  NR3D1BWP12T U1108 ( .A1(n1109), .A2(n1070), .A3(n960), .ZN(n978) );
  CKAN2D1BWP12T U1109 ( .A1(n966), .A2(n976), .Z(n980) );
  AOI32D0BWP12T U1110 ( .A1(instruction[11]), .A2(n961), .A3(n980), .B1(n996), 
        .B2(n961), .ZN(n962) );
  AO211D1BWP12T U1111 ( .A1(n1109), .A2(alu_stack_write_to_reg[3]), .B(n978), 
        .C(n962), .Z(n611) );
  AOI221D1BWP12T U1112 ( .A1(operand_a[4]), .A2(n1109), .B1(n963), .B2(n990), 
        .C(reset), .ZN(n971) );
  NR2D0BWP12T U1113 ( .A1(n965), .A2(n964), .ZN(n968) );
  ND4D1BWP12T U1114 ( .A1(n968), .A2(n967), .A3(n988), .A4(n966), .ZN(n1042)
         );
  TPNR3D0BWP12T U1115 ( .A1(n970), .A2(n969), .A3(n1042), .ZN(n974) );
  NR2D1BWP12T U1116 ( .A1(n974), .A2(n1065), .ZN(n1025) );
  INVD1BWP12T U1117 ( .I(n1025), .ZN(n1011) );
  AOI32D1BWP12T U1118 ( .A1(n976), .A2(n971), .A3(n1011), .B1(n996), .B2(n971), 
        .ZN(n615) );
  CKND2D1BWP12T U1119 ( .A1(instruction[11]), .A2(n1078), .ZN(n1086) );
  AOI31D1BWP12T U1120 ( .A1(n972), .A2(n724), .A3(n1086), .B(n1109), .ZN(n973)
         );
  AOI211D1BWP12T U1121 ( .A1(n1109), .A2(alu_stack_write_to_reg[4]), .B(reset), 
        .C(n973), .ZN(n975) );
  OR2XD1BWP12T U1122 ( .A1(n974), .A2(instruction[11]), .Z(n1028) );
  AOI32D1BWP12T U1123 ( .A1(n976), .A2(n975), .A3(n1028), .B1(n996), .B2(n975), 
        .ZN(n610) );
  AOI211D1BWP12T U1124 ( .A1(n1109), .A2(operand_a[3]), .B(n978), .C(n977), 
        .ZN(n979) );
  AOI32D1BWP12T U1125 ( .A1(n980), .A2(n979), .A3(n1065), .B1(n996), .B2(n979), 
        .ZN(n616) );
  ND2D1BWP12T U1126 ( .A1(n982), .A2(n981), .ZN(n983) );
  AOI211D1BWP12T U1127 ( .A1(n1008), .A2(n985), .B(n984), .C(n983), .ZN(n989)
         );
  OAI221D1BWP12T U1128 ( .A1(n1109), .A2(n989), .B1(n990), .B2(n986), .C(n993), 
        .ZN(n638) );
  AOI31D1BWP12T U1129 ( .A1(n987), .A2(n989), .A3(n993), .B(n1109), .ZN(n998)
         );
  AO21D1BWP12T U1130 ( .A1(step[4]), .A2(n1109), .B(n998), .Z(n636) );
  TPND2D0BWP12T U1131 ( .A1(n989), .A2(n988), .ZN(n991) );
  AOI22D1BWP12T U1132 ( .A1(n1109), .A2(step[3]), .B1(n991), .B2(n990), .ZN(
        n992) );
  CKND2D0BWP12T U1133 ( .A1(n993), .A2(n992), .ZN(n637) );
  AOI21D0BWP12T U1134 ( .A1(n996), .A2(n995), .B(n994), .ZN(n997) );
  AO211D1BWP12T U1135 ( .A1(step[5]), .A2(n1109), .B(n998), .C(n997), .Z(n635)
         );
  IOA21D1BWP12T U1136 ( .A1(memory_store_address_reg[3]), .A2(n1038), .B(n999), 
        .ZN(n642) );
  IOA21D1BWP12T U1137 ( .A1(memory_store_address_reg[4]), .A2(n1038), .B(n999), 
        .ZN(n641) );
  AOI31D0BWP12T U1138 ( .A1(n1002), .A2(n1001), .A3(n1000), .B(n1039), .ZN(
        n1003) );
  NR2D1BWP12T U1139 ( .A1(reset), .A2(n1003), .ZN(n1004) );
  IOA21D1BWP12T U1140 ( .A1(memory_store_data_reg[4]), .A2(n1038), .B(n1004), 
        .ZN(n626) );
  IOA21D1BWP12T U1141 ( .A1(memory_store_data_reg[3]), .A2(n1038), .B(n1004), 
        .ZN(n627) );
  IOA21D1BWP12T U1142 ( .A1(n1109), .A2(offset_b[23]), .B(n1005), .ZN(n581) );
  IOA21D1BWP12T U1143 ( .A1(n1109), .A2(offset_b[24]), .B(n1005), .ZN(n580) );
  IOA21D1BWP12T U1144 ( .A1(n1109), .A2(offset_b[28]), .B(n1005), .ZN(n576) );
  IOA21D1BWP12T U1145 ( .A1(n1109), .A2(offset_b[27]), .B(n1005), .ZN(n577) );
  IOA21D1BWP12T U1146 ( .A1(n1109), .A2(offset_b[26]), .B(n1005), .ZN(n578) );
  IOA21D1BWP12T U1147 ( .A1(n1109), .A2(offset_b[30]), .B(n1005), .ZN(n574) );
  IOA21D1BWP12T U1148 ( .A1(n1109), .A2(offset_b[29]), .B(n1005), .ZN(n575) );
  IOA21D1BWP12T U1149 ( .A1(n1109), .A2(offset_b[25]), .B(n1005), .ZN(n579) );
  IOA21D1BWP12T U1150 ( .A1(n1109), .A2(offset_b[31]), .B(n1005), .ZN(n573) );
  IAO21D1BWP12T U1151 ( .A1(n1006), .A2(n1017), .B(n1098), .ZN(n1007) );
  MOAI22D0BWP12T U1152 ( .A1(n1007), .A2(n1039), .B1(load_store_width[0]), 
        .B2(n1038), .ZN(n648) );
  MOAI22D0BWP12T U1153 ( .A1(n1087), .A2(n1039), .B1(
        memory_address_source_is_reg), .B2(n1038), .ZN(n646) );
  CKND2D0BWP12T U1154 ( .A1(n1008), .A2(n1010), .ZN(n1009) );
  MOAI22D0BWP12T U1155 ( .A1(n1064), .A2(n1009), .B1(
        memory_store_address_reg[1]), .B2(n1038), .ZN(n644) );
  CKND2D0BWP12T U1156 ( .A1(n1043), .A2(n1010), .ZN(n1027) );
  MOAI22D0BWP12T U1157 ( .A1(n1011), .A2(n1027), .B1(n1026), .B2(
        stack_pop_request), .ZN(n633) );
  MOAI22D0BWP12T U1158 ( .A1(n1028), .A2(n1027), .B1(n1026), .B2(
        stack_push_request), .ZN(n631) );
  AOI22D1BWP12T U1159 ( .A1(instruction[1]), .A2(n1030), .B1(n1029), .B2(
        instruction[9]), .ZN(n1032) );
  AOI32D1BWP12T U1160 ( .A1(n1033), .A2(n1032), .A3(n1031), .B1(n1087), .B2(
        n1032), .ZN(n1037) );
  AOI22D1BWP12T U1161 ( .A1(n1034), .A2(instruction[1]), .B1(n1065), .B2(n1037), .ZN(n1035) );
  MOAI22D0BWP12T U1162 ( .A1(n1035), .A2(n1039), .B1(memory_store_data_reg[1]), 
        .B2(n1038), .ZN(n629) );
  AOI222D1BWP12T U1163 ( .A1(n1037), .A2(instruction[11]), .B1(instruction[9]), 
        .B2(n1052), .C1(instruction[1]), .C2(n1036), .ZN(n1040) );
  MOAI22D0BWP12T U1164 ( .A1(n1040), .A2(n1039), .B1(memory_write_to_reg[1]), 
        .B2(n1038), .ZN(n624) );
  INVD1BWP12T U1165 ( .I(n1041), .ZN(n1050) );
  INVD1BWP12T U1166 ( .I(instruction[4]), .ZN(n1102) );
  CKND2D1BWP12T U1167 ( .A1(n1043), .A2(n1042), .ZN(n1055) );
  AOI21D1BWP12T U1168 ( .A1(n1044), .A2(n1055), .B(instruction[11]), .ZN(n1046) );
  AOI211D1BWP12T U1169 ( .A1(instruction[9]), .A2(n1047), .B(n1046), .C(n1045), 
        .ZN(n1048) );
  OAI211D1BWP12T U1170 ( .A1(n1050), .A2(n1102), .B(n1049), .C(n1048), .ZN(
        n1051) );
  AOI211D1BWP12T U1171 ( .A1(instruction[1]), .A2(n1053), .B(n1052), .C(n1051), 
        .ZN(n1054) );
  MOAI22D0BWP12T U1172 ( .A1(n1054), .A2(n1110), .B1(n1109), .B2(operand_a[1]), 
        .ZN(n618) );
  NR2D1BWP12T U1173 ( .A1(n1065), .A2(n1055), .ZN(n1061) );
  CKND0BWP12T U1174 ( .I(n1056), .ZN(n1059) );
  OAI211D1BWP12T U1175 ( .A1(n1059), .A2(n1064), .B(n1058), .C(n1057), .ZN(
        n1060) );
  AOI211D1BWP12T U1176 ( .A1(instruction[1]), .A2(n1062), .B(n1061), .C(n1060), 
        .ZN(n1063) );
  MOAI22D0BWP12T U1177 ( .A1(n1063), .A2(n1110), .B1(n1109), .B2(
        alu_stack_write_to_reg[1]), .ZN(n613) );
  OAI32D0BWP12T U1178 ( .A1(n1066), .A2(n1065), .A3(n1064), .B1(
        instruction[12]), .B2(n1066), .ZN(n1073) );
  TPNR2D0BWP12T U1179 ( .A1(n1068), .A2(n1067), .ZN(n1071) );
  OAI211D1BWP12T U1180 ( .A1(n1071), .A2(n1070), .B(n1069), .C(n1086), .ZN(
        n1072) );
  AOI211D1BWP12T U1181 ( .A1(n1079), .A2(n1105), .B(n1073), .C(n1072), .ZN(
        n1074) );
  MOAI22D0BWP12T U1182 ( .A1(n1074), .A2(n1110), .B1(n1109), .B2(alu_opcode[1]), .ZN(n608) );
  CKND2D1BWP12T U1183 ( .A1(n1076), .A2(n1075), .ZN(n1077) );
  AOI211D0BWP12T U1184 ( .A1(n1080), .A2(n1079), .B(n1078), .C(n1077), .ZN(
        n1081) );
  MOAI22D0BWP12T U1185 ( .A1(n1081), .A2(n1110), .B1(n1109), .B2(alu_opcode[4]), .ZN(n605) );
  NR2XD0BWP12T U1186 ( .A1(n1082), .A2(n1094), .ZN(n1083) );
  AOI211XD0BWP12T U1187 ( .A1(instruction[6]), .A2(n1091), .B(n1084), .C(n1083), .ZN(n1085) );
  MOAI22D0BWP12T U1188 ( .A1(n1085), .A2(n1110), .B1(n1109), .B2(offset_b[0]), 
        .ZN(n604) );
  AOI22D0BWP12T U1189 ( .A1(instruction[1]), .A2(n1105), .B1(instruction[6]), 
        .B2(n1098), .ZN(n1089) );
  AOI22D0BWP12T U1190 ( .A1(instruction[0]), .A2(n1107), .B1(instruction[7]), 
        .B2(n1091), .ZN(n1088) );
  AN4XD1BWP12T U1191 ( .A1(n1089), .A2(n1088), .A3(n1087), .A4(n1086), .Z(
        n1090) );
  MOAI22D0BWP12T U1192 ( .A1(n1090), .A2(n1110), .B1(n1109), .B2(offset_b[1]), 
        .ZN(n603) );
  TPAOI22D0BWP12T U1193 ( .A1(instruction[6]), .A2(n1099), .B1(instruction[7]), 
        .B2(n1098), .ZN(n1093) );
  AOI22D0BWP12T U1194 ( .A1(instruction[0]), .A2(n1108), .B1(instruction[8]), 
        .B2(n1091), .ZN(n1092) );
  OAI211D1BWP12T U1195 ( .A1(n1095), .A2(n1094), .B(n1093), .C(n1092), .ZN(
        n1096) );
  TPAOI21D0BWP12T U1196 ( .A1(instruction[1]), .A2(n1107), .B(n1096), .ZN(
        n1097) );
  MOAI22D0BWP12T U1197 ( .A1(n1097), .A2(n1110), .B1(n1109), .B2(offset_b[2]), 
        .ZN(n602) );
  AOI22D1BWP12T U1198 ( .A1(n1099), .A2(instruction[9]), .B1(n1098), .B2(
        instruction[10]), .ZN(n1101) );
  AOI22D0BWP12T U1199 ( .A1(instruction[3]), .A2(n1108), .B1(instruction[5]), 
        .B2(n1105), .ZN(n1100) );
  OA211D0BWP12T U1200 ( .A1(n1103), .A2(n1102), .B(n1101), .C(n1100), .Z(n1104) );
  MOAI22D0BWP12T U1201 ( .A1(n1104), .A2(n1110), .B1(n1109), .B2(offset_b[5]), 
        .ZN(n599) );
  AOI222D1BWP12T U1202 ( .A1(n1107), .A2(instruction[6]), .B1(instruction[7]), 
        .B2(n1105), .C1(n1108), .C2(instruction[5]), .ZN(n1106) );
  MOAI22D0BWP12T U1203 ( .A1(n1106), .A2(n1110), .B1(n1109), .B2(offset_b[7]), 
        .ZN(n597) );
  AOI22D1BWP12T U1204 ( .A1(instruction[6]), .A2(n1108), .B1(instruction[7]), 
        .B2(n1107), .ZN(n1111) );
  MOAI22D0BWP12T U1205 ( .A1(n1111), .A2(n1110), .B1(n1109), .B2(offset_b[8]), 
        .ZN(n596) );
endmodule

