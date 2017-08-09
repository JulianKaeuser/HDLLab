
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
  wire   N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15,
         N16, N17, N18, N19, N20, N21, N22, N23, N24, N25, N26, N27, N28, N29,
         N30, N31, N32, N33, N34, N35, N36, N37, N38, N39, N40, N41, N42, N43,
         N44, N45, N46, N47, N48, N49, N50, N51, N52, N53, N54, N55, N56, N57,
         N58, N59, N60, N61, N62, N63, N64, N65, N66, N67, N68, N69, N70, N71,
         N72, N73, N74, N75, N76, N77, N78, N79, N80, N81, N82, N83, N84, N85,
         N86, N87, N88, N89, N90, N91, N92, N93, N94, N95, N96, N97, N98, N99,
         N100, N101, N102, N103, N104, N105, N106, N107, N108, N109, N110,
         N111, N112, N113, N114, N115, N116, N117, N118, N119, N120, N121,
         N122, N123, N124, N125, N126, N127, N128, N129, N130, N131, N132,
         N133, N134, N135, N136, N137, N138, N139, N140, N141, N142, N143,
         N144, N145, N146, N147, N148, N149, N150, N151, N152, N153, N154,
         N155, N156, N157, N158, N159, N160, N161, N162, N163, N164, N165,
         N166, N167, next_pc_mask_bit, next_update_flag_n, next_update_flag_z,
         next_update_flag_c, next_update_flag_v,
         next_alu_stack_write_to_reg_enable, next_memory_write_to_reg_enable,
         next_memory_address_source_is_reg, next_memorycontroller_sign_extend,
         next_memory_load_request, next_memory_store_request,
         next_stall_to_instructionfetch, next_decoder_pc_update, N168, N169,
         N170, N171, N172, N173, N174, N175, N176, N177, N178, N179, N180,
         N181, N182, N183, N184, N185, N186, N187, N188, N189, N190, N191,
         N192, N193, N194, N195, N196, N197, N198, N199, N200, N201, N202,
         N203, N204, N205, N206, N207, N208, N209, N210, N211, N212, N213,
         N214, N215, N216, N217, N218, N219, N220, N221, N222, N223, N224,
         N225, N226, N227, N228, N229, N230, N231, N232, N233, N234, N235,
         N236, N237, N238, N239, N240, N241, N242, N243, N244, N245, N246,
         N247, N248, N249, N250, N251, N252, N253, N254, N255, N256, N257,
         N258, N259, N260, N261, N262, N263, N264, N265, N266, N267, N268,
         N269, N270, N271, N272, N273, N274, N275, N276, N277, N278, N279,
         N280, N281, N282, N283, N284, N285, N286, N287, N288, N289, N290,
         N291, N292, N293, N294, N295, N296, N297, N298, N299, N300, N301,
         N302, N303, N304, N305, N306, N307, N308, N309, N310, N311, N312,
         N313, N314, N315, N316, N317, N318, N319, N320, N321, N322, N323,
         N324, N325, N326, N327, N328, N329, N330, N331, N332, N333, N334,
         N335, N336, N337, N338, N339, N340, N341, N342, N343, N344, N345,
         N346, N347, N348, N349, N350, N351, N352, N353, N354, N355, N356,
         N357, N358, N359, N360, N361, N362, N363, N364, N365, N366, N367,
         N368, N369, N370, N371, N372, N373, N374, N375, N376, N377, N378,
         N379, N380, N381, N382, N383, N384, N385, N386, N387, N388, N389,
         N390, N391, N392, N393, N394, N395, N396, N397, N398, N399, N400,
         N401, N402, N403, N404, N405, N406, N407, N408, N409, N410, N411,
         N412, N413, N414, N415, N416, N417, N418, N419, N420, N421, N422,
         N423, N424, N425, N426, N427, N428, N429, N430, N431, N432, N433,
         N434, N435, N436, N437, N438, N439, N440, N441, N442, N443, N444,
         N445, N446, N447, N448, N449, N450, N451, N452, N453, N454, N455,
         N456, N457, N458, N459, N460, N461, N462, N463, N464, N465, N466,
         N467, N468, N469, N470, N471, N472, N473, N474, N475, N476, N477,
         N478, N479, N480, N481, N482, N483, N484, N485, N486, N487, N488,
         N489, N490, N491, N492, N493, N494, N495, N496, N497, N498, N499,
         N500, N501, N502, N503, N504, N505, N506, N507, N508, N509, N510,
         N511, N512, N513, N514, N515, N516, N517, N518, N519, N520, N521,
         N522, N523, N524, N525, N526, N527, N528, N529, N530, N531, N532,
         N533, N534, N535, N536, N537, N538, N539, N540, N541, N542, N543,
         N544, N545, N546, N547, N548, N549, N550, N551, N552, N553, N554,
         N555, N556, N557, N558, N559, N560, N561, N562, N563, N564, N565,
         N566, N567, N568, N569, N570, N571, N572, N573, N574, N575, N576,
         N577, N578, N579, N580, N581, N582, N583, N584, N585, N586, N587,
         N588, N589, N590, N591, N592, N593, N594, N595, N596, N597, N598,
         N599, N600, N601, N602, N603, N604, N605, N606, N607, N608, N609,
         N610, N611, N612, N613, N614, N615, N616, N617, N618, N619, N620,
         N621, N622, N623, N624, N625, N626, N627, N628, N629, N630, N631,
         N632, N633, N634, N635, N636, N637, N638, N639, N640, N641, N642,
         N643, N644, N645, N646, N647, N648, N649, N650, N651, N652, N653,
         N654, N655, N656, N657, N658, N659, N660, N661, N662, N663, N664,
         N665, N666, N667, N668, N669, N670, N671, N672, N673, N674, N675,
         N676, N677, N678, N679, N680, N681, N682, N683, N684, N685, N686,
         N687, N688, N689, N690, N691, N692, N693, N694, N695, N696, N697,
         N698, N699, N700, N701, N702, N703, N704, N705, N706, N707, N708,
         N709, N710, N711, N712, N713, N714, N715, N716, N717, N718, N719,
         N720, N721, N722, N723, N724, N725, N726, N727, N728, N729, N730,
         N731, N732, N733, N734, N735, N736, N737, N738, N739, N740, N741,
         N742, N743, N744, N745, N746, N747, N748, N749, N750, N751, N752,
         N753, N754, N755, N756, N757, N758, N759, N760, N761, N762, N763,
         N764, N765, N766, N767, N768, N769, N770, N771, N772, N773, N774,
         N775, N776, N777, N778, N779, N780, N781, N782, N783, N784, N785,
         N786, N787, N788, N789, N790, N791, N792, N793, N794, N795, N796,
         N797, N798, N799, N800, N801, N802, N803, N804, N805, N806, N807,
         N808, N809, N810, N811, N812, N813, N814, N815, N816, N817, N818,
         N819, N820, N821, N822, N823, N824, N825, N826, N827, N828, N829,
         N830, N831, N832, N833, N834, N835, N836, N837, N838, N839, N840,
         N841, N842, N843, N844, N845, N846, N847, N848, N849, N850, N851,
         N852, N853, N854, N855, N856, N857, N858, N859, N860, N861, N862,
         N863, N864, N865, N866, N867, N868, N869, N870, N871, N872, N873,
         N874, N875, N876, N877, N878, N879, N880, N881, N882, N883, N884,
         N885, N886, N887, N888, N889, N890, N891, N892, N893, N894, N895,
         N896, N897, N898, N899, N900, N901, N902, N903, N904, N905, N906,
         N907, N908, N909, N910, N911, N912, N913, N914, N915, N916, N917,
         N918, N919, N920, N921, N922, N923, N924, N925, N926, N927, N928,
         N929, N930, N931, N932, N933, N934, N935, N936, N937, N938, N939,
         N940, N941, N942, N943, N944, N945, N946, N947, N948, N949, N950,
         N951, N952, N953, N954, N955, N956, N957, N958, N959, N960, N961,
         N962, N963, N964, N965, N966, N967, N968, N969, N970, N971, N972,
         N973, N974, N975, N976, N977, N978, N979, N980, N981, N982, N983,
         N984, N985, N986, N987, N988, N989, N990, N991, N992, N993, N994,
         N995, N996, N997, N998, N999, N1000, N1001, N1002, N1003, N1004,
         N1005, N1006, N1007, N1008, N1009, N1010, N1011, N1012, N1013, N1014,
         N1015, N1016, N1017, N1018, N1019, N1020, N1021, N1022, N1023, N1024,
         N1025, N1026, N1027, N1028, N1029, N1030, N1031, N1032, N1033, N1034,
         N1035, N1036, N1037, N1038, N1039, N1040, N1041, N1042, N1043, N1044,
         N1045, N1046, N1047, N1048, N1049, N1050, N1051, N1052, N1053, N1054,
         N1055, N1056, N1057, N1058, N1059, N1060, N1061, N1062, N1063, N1064,
         N1065, N1066, N1067, N1068, N1069, N1070, N1071, N1072, N1073, N1074,
         N1075, N1076, N1077, N1078, N1079, N1080, N1081, N1082, N1083, N1084,
         N1085, N1086, N1087, N1088, N1089, N1090, N1091, N1092, N1093, N1094,
         N1095, N1096, N1097, N1098, N1099, N1100, N1101, N1102, N1103, N1104,
         N1105, N1106, N1107, N1108, N1109, N1110, N1111, N1112, N1113, N1114,
         N1115, N1116, N1117, N1118, N1119, N1120, N1121, N1122, N1123, N1124,
         N1125, N1126, N1127, N1128, N1129, N1130, N1131, N1132, N1133, N1134,
         N1135, N1136, N1137, N1138, N1139, N1140, N1141, N1142, N1143, N1144,
         N1145, N1146, N1147, N1148, N1149, N1150, N1151, N1152, N1153, N1154,
         N1155, N1156, N1157, N1158, N1159, N1160, N1161, N1162, N1163, N1164,
         N1165, N1166, N1167, N1168, N1169, N1170, N1171, N1172, N1173, N1174,
         N1175, N1176, N1177, N1178, N1179, N1180, N1181, N1182, N1183, N1184,
         N1185, N1186, N1187, N1188, N1189, N1190, N1191, N1192, N1193, N1194,
         N1195, N1196, N1197, N1198, N1199, N1200, N1201, N1202, N1203, N1204,
         N1205, N1206, N1207, N1208, N1209, N1210, N1211, N1212, N1213, N1214,
         N1215, N1216, N1217, N1218, N1219, N1220, N1221, N1222, N1223, N1224,
         N1225, N1226, N1227, N1228, N1229, N1230, N1231, N1232, N1233, N1234,
         N1235, N1236, N1237, N1238, N1239, N1240, N1241, N1242, N1243, N1244,
         N1245, N1246, N1247, N1248, N1249, N1250, N1251, N1252, N1253, N1254,
         N1255, N1256, N1257, N1258, N1259, N1260, N1261, N1262, N1263, N1264,
         N1265, N1266, N1267, N1268, N1269, N1270, N1271, N1272, N1273, N1274,
         N1275, N1276, N1277, N1278, N1279, N1280, N1281, N1282, N1283, N1284,
         N1285, N1286, N1287, N1288, N1289, N1290, N1291, N1292, N1293, N1294,
         N1295, N1296, N1297, N1298, N1299, N1300, N1301, N1302, N1303, N1304,
         N1305, N1306, N1307, N1308, N1309, N1310, N1311, N1312, N1313, N1314,
         N1315, N1316, N1317, N1318, N1319, N1320, N1321, N1322, N1323, N1324,
         N1325, N1326, N1327, N1328, N1329, N1330, N1331, N1332, N1333, N1334,
         N1335, N1336, N1337, N1338, N1339, N1340, N1341, N1342, N1343, N1344,
         N1345, N1346, N1347, N1348, N1349, N1350, N1351, N1352, N1353, N1354,
         N1355, N1356, N1357, N1358, N1359, N1360, N1361, N1362, N1363, N1364,
         N1365, N1366, N1367, N1368, N1369, N1370, N1371, N1372, N1373, N1374,
         N1375, N1376, N1377, N1378, N1379, N1380, N1381, N1382, N1383, N1384,
         N1385, N1386, N1387, N1388, N1389, N1390, N1391, N1392, N1393, N1394,
         N1395, N1396, N1397, N1398, N1399, N1400, N1401, N1402, N1403, N1404,
         N1405, N1406, N1407, N1408, N1409, N1410, N1411, N1412, N1413, N1414,
         N1415, N1416, N1417, N1418, N1419, N1420, N1421, N1422, N1423, N1424,
         N1425, N1426, N1427, N1428, N1429, N1430, N1431, N1432, N1433, N1434,
         N1435, N1436, N1437, N1438, N1439, N1440, N1441, N1442, N1443, N1444,
         N1445, N1446, N1447, N1448, N1449, N1450, N1451, N1452, N1453, N1454,
         N1455, N1456, N1457, N1458, N1459, N1460, N1461, N1462, N1463, N1464,
         N1465, N1466, N1467, N1468, N1469, N1470, N1471, N1472, N1473, N1474,
         N1475, N1476, N1477, N1478, N1479, N1480, N1481, N1482, N1483, N1484,
         N1485, N1486, N1487, N1488, N1489, N1490, N1491, N1492, N1493, N1494,
         N1495, N1496, N1497, N1498, N1499, N1500, N1501, N1502, N1503, N1504,
         N1505, N1506, N1507, N1508, N1509, N1510, N1511, N1512, N1513, N1514,
         N1515, N1516, N1517, N1518, N1519, N1520, N1521, N1522, N1523, N1524,
         N1525, N1526, N1527, N1528, N1529, N1530, N1531, N1532, N1533, N1534,
         N1535, N1536, N1537, N1538, N1539, N1540, N1541, N1542, N1543, N1544,
         N1545, N1546, N1547, N1548, N1549, N1550, N1551, N1552, N1553, N1554,
         N1555, N1556, N1557, N1558, N1559, N1560, N1561, N1562, N1563, N1564,
         N1565, N1566, N1567, N1568, N1569, N1570, N1571, N1572, N1573, N1574,
         N1575, N1576, N1577, N1578, N1579, N1580, N1581, N1582, N1583, N1584,
         N1585, N1586, N1587, N1588, N1589, N1590, N1591, N1592, N1593, N1594,
         N1595, N1596, N1597, N1598, N1599, N1600, N1601, N1602, N1603, N1604,
         N1605, N1606, N1607, N1608, N1609, N1610, N1611, N1612, N1613, N1614,
         N1615, N1616, N1617, N1618, N1619, N1620, N1621, N1622, N1623, N1624,
         N1625, N1626, N1627, N1628, N1629, N1630, N1631, N1632, N1633, N1634,
         N1635, N1636, N1637, N1638, N1639, N1640, N1641, N1642, N1643, N1644,
         N1645, N1646, N1647, N1648, N1649, N1650, N1651, N1652, N1653, N1654,
         N1655, N1656, N1657, N1658, N1659, N1660, N1661, N1662, N1663, N1664,
         N1665, N1666, N1667, N1668, N1669, N1670, N1671, N1672, N1673, N1674,
         N1675, N1676, N1677, N1678, N1679, N1680, N1681, N1682, N1683, N1684,
         N1685, N1686, N1687, N1688, N1689, N1690, N1691, N1692, N1693, N1694,
         N1695, N1696, N1697, N1698, N1699;
  wire   [4:0] next_operand_a;
  wire   [4:0] next_operand_b;
  wire   [31:0] next_offset_a;
  wire   [31:0] next_offset_b;
  wire   [4:0] next_alu_opcode;
  wire   [4:0] next_alu_stack_write_to_reg;
  wire   [4:0] next_memory_write_to_reg;
  wire   [4:0] next_memory_store_data_reg;
  wire   [4:0] next_memory_store_address_reg;
  wire   [1:0] next_load_store_width;
  wire   [7:0] itstate;
  wire   [7:0] next_itstate;

  \**SEQGEN**  operand_a_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_operand_a[4]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(operand_a[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  operand_a_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_operand_a[3]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(operand_a[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  operand_a_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_operand_a[2]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(operand_a[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  operand_a_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_operand_a[1]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(operand_a[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  operand_a_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_operand_a[0]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(operand_a[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  operand_b_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_operand_b[4]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(operand_b[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  operand_b_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_operand_b[3]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(operand_b[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  operand_b_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_operand_b[2]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(operand_b[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  operand_b_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_operand_b[1]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(operand_b[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  operand_b_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_operand_b[0]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(operand_b[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_a_reg_31_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_a[31]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_a[31]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_a_reg_30_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_a[30]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_a[30]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_a_reg_29_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_a[29]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_a[29]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_a_reg_28_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_a[28]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_a[28]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_a_reg_27_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_a[27]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_a[27]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_a_reg_26_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_a[26]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_a[26]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_a_reg_25_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_a[25]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_a[25]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_a_reg_24_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_a[24]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_a[24]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_a_reg_23_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_a[23]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_a[23]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_a_reg_22_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_a[22]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_a[22]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_a_reg_21_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_a[21]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_a[21]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_a_reg_20_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_a[20]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_a[20]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_a_reg_19_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_a[19]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_a[19]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_a_reg_18_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_a[18]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_a[18]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_a_reg_17_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_a[17]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_a[17]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_a_reg_16_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_a[16]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_a[16]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_a_reg_15_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_a[15]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_a[15]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_a_reg_14_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_a[14]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_a[14]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_a_reg_13_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_a[13]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_a[13]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_a_reg_12_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_a[12]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_a[12]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_a_reg_11_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_a[11]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_a[11]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_a_reg_10_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_a[10]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_a[10]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_a_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_a[9]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_a[9]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_a_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_a[8]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_a[8]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_a_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_a[7]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_a[7]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_a_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_a[6]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_a[6]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_a_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_a[5]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_a[5]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_a_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_a[4]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_a[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_a_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_a[3]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_a[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_a_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_a[2]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_a[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_a_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_a[1]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_a[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_a_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_a[0]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_a[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_b_reg_31_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_b[31]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_b[31]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_b_reg_30_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_b[30]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_b[30]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_b_reg_29_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_b[29]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_b[29]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_b_reg_28_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_b[28]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_b[28]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_b_reg_27_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_b[27]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_b[27]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_b_reg_26_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_b[26]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_b[26]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_b_reg_25_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_b[25]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_b[25]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_b_reg_24_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_b[24]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_b[24]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_b_reg_23_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_b[23]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_b[23]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_b_reg_22_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_b[22]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_b[22]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_b_reg_21_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_b[21]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_b[21]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_b_reg_20_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_b[20]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_b[20]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_b_reg_19_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_b[19]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_b[19]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_b_reg_18_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_b[18]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_b[18]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_b_reg_17_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_b[17]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_b[17]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_b_reg_16_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_b[16]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_b[16]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_b_reg_15_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_b[15]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_b[15]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_b_reg_14_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_b[14]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_b[14]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_b_reg_13_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_b[13]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_b[13]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_b_reg_12_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_b[12]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_b[12]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_b_reg_11_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_b[11]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_b[11]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_b_reg_10_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_b[10]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_b[10]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_b_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_b[9]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_b[9]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_b_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_b[8]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_b[8]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_b_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_b[7]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_b[7]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_b_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_b[6]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_b[6]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_b_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_b[5]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_b[5]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_b_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_b[4]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_b[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_b_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_b[3]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_b[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_b_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_b[2]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_b[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_b_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_b[1]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_b[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  offset_b_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_offset_b[0]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(offset_b[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  alu_opcode_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_alu_opcode[4]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(alu_opcode[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  alu_opcode_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_alu_opcode[3]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(alu_opcode[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  alu_opcode_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_alu_opcode[2]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(alu_opcode[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  alu_opcode_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_alu_opcode[1]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(alu_opcode[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  alu_opcode_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_alu_opcode[0]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(alu_opcode[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  pc_mask_bit_reg ( .clear(1'b0), .preset(1'b0), .next_state(
        next_pc_mask_bit), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(pc_mask_bit), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  update_flag_n_reg ( .clear(1'b0), .preset(1'b0), .next_state(
        next_update_flag_n), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(update_flag_n), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  update_flag_z_reg ( .clear(1'b0), .preset(1'b0), .next_state(
        next_update_flag_z), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(update_flag_z), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  update_flag_c_reg ( .clear(1'b0), .preset(1'b0), .next_state(
        next_update_flag_c), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(update_flag_c), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  update_flag_v_reg ( .clear(1'b0), .preset(1'b0), .next_state(
        next_update_flag_v), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(update_flag_v), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  alu_stack_write_to_reg_reg_4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(next_alu_stack_write_to_reg[4]), .clocked_on(clock), 
        .data_in(1'b0), .enable(1'b0), .Q(alu_stack_write_to_reg[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  alu_stack_write_to_reg_reg_3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(next_alu_stack_write_to_reg[3]), .clocked_on(clock), 
        .data_in(1'b0), .enable(1'b0), .Q(alu_stack_write_to_reg[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  alu_stack_write_to_reg_reg_2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(next_alu_stack_write_to_reg[2]), .clocked_on(clock), 
        .data_in(1'b0), .enable(1'b0), .Q(alu_stack_write_to_reg[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  alu_stack_write_to_reg_reg_1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(next_alu_stack_write_to_reg[1]), .clocked_on(clock), 
        .data_in(1'b0), .enable(1'b0), .Q(alu_stack_write_to_reg[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  alu_stack_write_to_reg_reg_0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(next_alu_stack_write_to_reg[0]), .clocked_on(clock), 
        .data_in(1'b0), .enable(1'b0), .Q(alu_stack_write_to_reg[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  alu_stack_write_to_reg_enable_reg ( .clear(1'b0), .preset(1'b0), 
        .next_state(next_alu_stack_write_to_reg_enable), .clocked_on(clock), 
        .data_in(1'b0), .enable(1'b0), .Q(alu_stack_write_to_reg_enable), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  memory_write_to_reg_reg_4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(next_memory_write_to_reg[4]), .clocked_on(clock), 
        .data_in(1'b0), .enable(1'b0), .Q(memory_write_to_reg[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  memory_write_to_reg_reg_3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(next_memory_write_to_reg[3]), .clocked_on(clock), 
        .data_in(1'b0), .enable(1'b0), .Q(memory_write_to_reg[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  memory_write_to_reg_reg_2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(next_memory_write_to_reg[2]), .clocked_on(clock), 
        .data_in(1'b0), .enable(1'b0), .Q(memory_write_to_reg[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  memory_write_to_reg_reg_1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(next_memory_write_to_reg[1]), .clocked_on(clock), 
        .data_in(1'b0), .enable(1'b0), .Q(memory_write_to_reg[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  memory_write_to_reg_reg_0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(next_memory_write_to_reg[0]), .clocked_on(clock), 
        .data_in(1'b0), .enable(1'b0), .Q(memory_write_to_reg[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  memory_write_to_reg_enable_reg ( .clear(1'b0), .preset(1'b0), 
        .next_state(next_memory_write_to_reg_enable), .clocked_on(clock), 
        .data_in(1'b0), .enable(1'b0), .Q(memory_write_to_reg_enable), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  memory_store_data_reg_reg_4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(next_memory_store_data_reg[4]), .clocked_on(clock), 
        .data_in(1'b0), .enable(1'b0), .Q(memory_store_data_reg[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  memory_store_data_reg_reg_3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(next_memory_store_data_reg[3]), .clocked_on(clock), 
        .data_in(1'b0), .enable(1'b0), .Q(memory_store_data_reg[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  memory_store_data_reg_reg_2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(next_memory_store_data_reg[2]), .clocked_on(clock), 
        .data_in(1'b0), .enable(1'b0), .Q(memory_store_data_reg[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  memory_store_data_reg_reg_1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(next_memory_store_data_reg[1]), .clocked_on(clock), 
        .data_in(1'b0), .enable(1'b0), .Q(memory_store_data_reg[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  memory_store_data_reg_reg_0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(next_memory_store_data_reg[0]), .clocked_on(clock), 
        .data_in(1'b0), .enable(1'b0), .Q(memory_store_data_reg[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  memory_store_address_reg_reg_4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(next_memory_store_address_reg[4]), .clocked_on(clock), 
        .data_in(1'b0), .enable(1'b0), .Q(memory_store_address_reg[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  memory_store_address_reg_reg_3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(next_memory_store_address_reg[3]), .clocked_on(clock), 
        .data_in(1'b0), .enable(1'b0), .Q(memory_store_address_reg[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  memory_store_address_reg_reg_2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(next_memory_store_address_reg[2]), .clocked_on(clock), 
        .data_in(1'b0), .enable(1'b0), .Q(memory_store_address_reg[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  memory_store_address_reg_reg_1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(next_memory_store_address_reg[1]), .clocked_on(clock), 
        .data_in(1'b0), .enable(1'b0), .Q(memory_store_address_reg[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  memory_store_address_reg_reg_0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(next_memory_store_address_reg[0]), .clocked_on(clock), 
        .data_in(1'b0), .enable(1'b0), .Q(memory_store_address_reg[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  memory_address_source_is_reg_reg ( .clear(1'b0), .preset(1'b0), 
        .next_state(next_memory_address_source_is_reg), .clocked_on(clock), 
        .data_in(1'b0), .enable(1'b0), .Q(memory_address_source_is_reg), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  load_store_width_reg_1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(next_load_store_width[1]), .clocked_on(clock), .data_in(
        1'b0), .enable(1'b0), .Q(load_store_width[1]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  load_store_width_reg_0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(next_load_store_width[0]), .clocked_on(clock), .data_in(
        1'b0), .enable(1'b0), .Q(load_store_width[0]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  memorycontroller_sign_extend_reg ( .clear(1'b0), .preset(1'b0), 
        .next_state(next_memorycontroller_sign_extend), .clocked_on(clock), 
        .data_in(1'b0), .enable(1'b0), .Q(memorycontroller_sign_extend), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  memory_load_request_reg ( .clear(1'b0), .preset(1'b0), 
        .next_state(next_memory_load_request), .clocked_on(clock), .data_in(
        1'b0), .enable(1'b0), .Q(memory_load_request), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  memory_store_request_reg ( .clear(1'b0), .preset(1'b0), 
        .next_state(next_memory_store_request), .clocked_on(clock), .data_in(
        1'b0), .enable(1'b0), .Q(memory_store_request), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  stack_push_request_reg ( .clear(1'b0), .preset(1'b0), 
        .next_state(1'b0), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(stack_push_request), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  stack_pop_request_reg ( .clear(1'b0), .preset(1'b0), 
        .next_state(1'b0), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(stack_pop_request), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  stall_to_instructionfetch_reg ( .clear(1'b0), .preset(1'b0), 
        .next_state(next_stall_to_instructionfetch), .clocked_on(clock), 
        .data_in(1'b0), .enable(1'b0), .Q(stall_to_instructionfetch), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  decoder_pc_update_reg ( .clear(1'b0), .preset(1'b0), 
        .next_state(next_decoder_pc_update), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), .Q(decoder_pc_update), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  itstate_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_itstate[7]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(itstate[7]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  itstate_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_itstate[6]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(itstate[6]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  itstate_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_itstate[5]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(itstate[5]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  itstate_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_itstate[4]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(itstate[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  itstate_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_itstate[3]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(itstate[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  itstate_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_itstate[2]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(itstate[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  itstate_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_itstate[1]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(itstate[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  itstate_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        next_itstate[0]), .clocked_on(clock), .data_in(1'b0), .enable(1'b0), 
        .Q(itstate[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  GTECH_AND2 C19 ( .A(instruction[15]), .B(N172), .Z(N173) );
  GTECH_AND2 C20 ( .A(instruction[13]), .B(instruction[12]), .Z(N174) );
  GTECH_AND2 C21 ( .A(instruction[11]), .B(instruction[10]), .Z(N175) );
  GTECH_AND2 C22 ( .A(instruction[9]), .B(instruction[8]), .Z(N176) );
  GTECH_AND2 C23 ( .A(N173), .B(N174), .Z(N177) );
  GTECH_AND2 C24 ( .A(N175), .B(N176), .Z(N178) );
  GTECH_AND2 C25 ( .A(N177), .B(N178), .Z(N179) );
  GTECH_AND2 C33 ( .A(N181), .B(N182), .Z(N185) );
  GTECH_AND2 C34 ( .A(N183), .B(N184), .Z(N186) );
  GTECH_AND2 C35 ( .A(N185), .B(N186), .Z(N187) );
  GTECH_AND2 C93 ( .A(N217), .B(N218), .Z(N221) );
  GTECH_AND2 C94 ( .A(N219), .B(N220), .Z(N222) );
  GTECH_AND2 C95 ( .A(N221), .B(N222), .Z(N223) );
  GTECH_OR2 C97 ( .A(itstate[7]), .B(itstate[6]), .Z(N224) );
  GTECH_OR2 C98 ( .A(itstate[5]), .B(N220), .Z(N225) );
  GTECH_OR2 C99 ( .A(N224), .B(N225), .Z(N226) );
  GTECH_OR2 C102 ( .A(itstate[7]), .B(itstate[6]), .Z(N228) );
  GTECH_OR2 C103 ( .A(N219), .B(itstate[4]), .Z(N229) );
  GTECH_OR2 C104 ( .A(N228), .B(N229), .Z(N230) );
  GTECH_OR2 C108 ( .A(itstate[7]), .B(itstate[6]), .Z(N232) );
  GTECH_OR2 C109 ( .A(N219), .B(N220), .Z(N233) );
  GTECH_OR2 C110 ( .A(N232), .B(N233), .Z(N234) );
  GTECH_OR2 C113 ( .A(itstate[7]), .B(N218), .Z(N236) );
  GTECH_OR2 C114 ( .A(itstate[5]), .B(itstate[4]), .Z(N237) );
  GTECH_OR2 C115 ( .A(N236), .B(N237), .Z(N238) );
  GTECH_OR2 C119 ( .A(itstate[7]), .B(N218), .Z(N240) );
  GTECH_OR2 C120 ( .A(itstate[5]), .B(N220), .Z(N241) );
  GTECH_OR2 C121 ( .A(N240), .B(N241), .Z(N242) );
  GTECH_OR2 C125 ( .A(itstate[7]), .B(N218), .Z(N244) );
  GTECH_OR2 C126 ( .A(N219), .B(itstate[4]), .Z(N245) );
  GTECH_OR2 C127 ( .A(N244), .B(N245), .Z(N246) );
  GTECH_OR2 C132 ( .A(itstate[7]), .B(N218), .Z(N248) );
  GTECH_OR2 C133 ( .A(N219), .B(N220), .Z(N249) );
  GTECH_OR2 C134 ( .A(N248), .B(N249), .Z(N250) );
  GTECH_OR2 C137 ( .A(N217), .B(itstate[6]), .Z(N252) );
  GTECH_OR2 C138 ( .A(itstate[5]), .B(itstate[4]), .Z(N253) );
  GTECH_OR2 C139 ( .A(N252), .B(N253), .Z(N254) );
  GTECH_OR2 C143 ( .A(N217), .B(itstate[6]), .Z(N256) );
  GTECH_OR2 C144 ( .A(itstate[5]), .B(N220), .Z(N257) );
  GTECH_OR2 C145 ( .A(N256), .B(N257), .Z(N258) );
  GTECH_OR2 C149 ( .A(N217), .B(itstate[6]), .Z(N260) );
  GTECH_OR2 C150 ( .A(N219), .B(itstate[4]), .Z(N261) );
  GTECH_OR2 C151 ( .A(N260), .B(N261), .Z(N262) );
  GTECH_OR2 C156 ( .A(N217), .B(itstate[6]), .Z(N264) );
  GTECH_OR2 C157 ( .A(N219), .B(N220), .Z(N265) );
  GTECH_OR2 C158 ( .A(N264), .B(N265), .Z(N266) );
  GTECH_OR2 C162 ( .A(N217), .B(N218), .Z(N268) );
  GTECH_OR2 C163 ( .A(itstate[5]), .B(itstate[4]), .Z(N269) );
  GTECH_OR2 C164 ( .A(N268), .B(N269), .Z(N270) );
  GTECH_OR2 C169 ( .A(N217), .B(N218), .Z(N272) );
  GTECH_OR2 C170 ( .A(itstate[5]), .B(N220), .Z(N273) );
  GTECH_OR2 C171 ( .A(N272), .B(N273), .Z(N274) );
  GTECH_OR2 C176 ( .A(N217), .B(N218), .Z(N276) );
  GTECH_OR2 C177 ( .A(N219), .B(itstate[4]), .Z(N277) );
  GTECH_OR2 C178 ( .A(N276), .B(N277), .Z(N278) );
  GTECH_AND2 C180 ( .A(itstate[7]), .B(itstate[6]), .Z(N280) );
  GTECH_AND2 C181 ( .A(itstate[5]), .B(itstate[4]), .Z(N281) );
  GTECH_AND2 C182 ( .A(N280), .B(N281), .Z(N282) );
  GTECH_AND2 C314 ( .A(N286), .B(N172), .Z(N288) );
  GTECH_AND2 C315 ( .A(N288), .B(N287), .Z(N289) );
  GTECH_AND2 C318 ( .A(N286), .B(N172), .Z(N290) );
  GTECH_AND2 C319 ( .A(N290), .B(instruction[13]), .Z(N291) );
  GTECH_AND2 C325 ( .A(N286), .B(instruction[14]), .Z(N292) );
  GTECH_AND2 C326 ( .A(N287), .B(N482), .Z(N293) );
  GTECH_AND2 C328 ( .A(N292), .B(N293), .Z(N294) );
  GTECH_AND2 C329 ( .A(N294), .B(N721), .Z(N295) );
  GTECH_AND2 C334 ( .A(N286), .B(instruction[14]), .Z(N296) );
  GTECH_AND2 C335 ( .A(N287), .B(N482), .Z(N297) );
  GTECH_AND2 C336 ( .A(N495), .B(instruction[10]), .Z(N298) );
  GTECH_AND2 C337 ( .A(N296), .B(N297), .Z(N299) );
  GTECH_AND2 C338 ( .A(N299), .B(N298), .Z(N300) );
  GTECH_AND2 C342 ( .A(N286), .B(instruction[14]), .Z(N301) );
  GTECH_AND2 C343 ( .A(N287), .B(N482), .Z(N302) );
  GTECH_AND2 C344 ( .A(N301), .B(N302), .Z(N303) );
  GTECH_AND2 C345 ( .A(N303), .B(instruction[11]), .Z(N304) );
  GTECH_AND2 C349 ( .A(N286), .B(instruction[14]), .Z(N305) );
  GTECH_AND2 C350 ( .A(N287), .B(instruction[12]), .Z(N306) );
  GTECH_AND2 C351 ( .A(N305), .B(N306), .Z(N307) );
  GTECH_AND2 C352 ( .A(N307), .B(N363), .Z(N308) );
  GTECH_AND2 C355 ( .A(N286), .B(instruction[14]), .Z(N309) );
  GTECH_AND2 C356 ( .A(N287), .B(instruction[12]), .Z(N310) );
  GTECH_AND2 C357 ( .A(N309), .B(N310), .Z(N311) );
  GTECH_AND2 C358 ( .A(N311), .B(instruction[9]), .Z(N312) );
  GTECH_AND2 C360 ( .A(N286), .B(instruction[14]), .Z(N313) );
  GTECH_AND2 C361 ( .A(N313), .B(instruction[13]), .Z(N314) );
  GTECH_AND2 C366 ( .A(N287), .B(N482), .Z(N315) );
  GTECH_AND2 C367 ( .A(N173), .B(N315), .Z(N316) );
  GTECH_AND2 C371 ( .A(N287), .B(instruction[12]), .Z(N317) );
  GTECH_AND2 C372 ( .A(N173), .B(N317), .Z(N318) );
  GTECH_AND2 C376 ( .A(instruction[13]), .B(N482), .Z(N319) );
  GTECH_AND2 C377 ( .A(N173), .B(N319), .Z(N320) );
  GTECH_AND2 C389 ( .A(N177), .B(N723), .Z(N321) );
  GTECH_AND2 C394 ( .A(instruction[10]), .B(N363), .Z(N322) );
  GTECH_AND2 C396 ( .A(N177), .B(N322), .Z(N323) );
  GTECH_AND2 C399 ( .A(instruction[15]), .B(instruction[14]), .Z(N324) );
  GTECH_AND2 C400 ( .A(N287), .B(N482), .Z(N325) );
  GTECH_AND2 C401 ( .A(N324), .B(N325), .Z(N326) );
  GTECH_AND2 C403 ( .A(instruction[15]), .B(instruction[14]), .Z(N327) );
  GTECH_AND2 C404 ( .A(N287), .B(instruction[12]), .Z(N328) );
  GTECH_AND2 C405 ( .A(N327), .B(N328), .Z(N329) );
  GTECH_AND2 C408 ( .A(instruction[15]), .B(instruction[14]), .Z(N330) );
  GTECH_AND2 C409 ( .A(instruction[13]), .B(N482), .Z(N331) );
  GTECH_AND2 C410 ( .A(N330), .B(N331), .Z(N332) );
  GTECH_AND2 C411 ( .A(N332), .B(N495), .Z(N333) );
  GTECH_AND2 C412 ( .A(instruction[15]), .B(instruction[14]), .Z(N334) );
  GTECH_AND2 C414 ( .A(N334), .B(N174), .Z(N335) );
  GTECH_AND2 C424 ( .A(instruction[15]), .B(instruction[14]), .Z(N336) );
  GTECH_AND2 C425 ( .A(instruction[13]), .B(N482), .Z(N337) );
  GTECH_AND2 C426 ( .A(N336), .B(N337), .Z(N338) );
  GTECH_AND2 C427 ( .A(N338), .B(instruction[11]), .Z(N339) );
  GTECH_AND2 C432 ( .A(N495), .B(instruction[9]), .Z(N340) );
  GTECH_AND2 C434 ( .A(N177), .B(N340), .Z(N341) );
  GTECH_AND2 C439 ( .A(N462), .B(instruction[9]), .Z(N342) );
  GTECH_AND2 C441 ( .A(N177), .B(N342), .Z(N343) );
  GTECH_AND2 C446 ( .A(instruction[9]), .B(N720), .Z(N344) );
  GTECH_AND2 C448 ( .A(N177), .B(N344), .Z(N345) );
  GTECH_AND2 C453 ( .A(instruction[11]), .B(N462), .Z(N346) );
  GTECH_AND2 C455 ( .A(N177), .B(N346), .Z(N347) );
  GTECH_AND2 C460 ( .A(N462), .B(instruction[8]), .Z(N348) );
  GTECH_AND2 C462 ( .A(N177), .B(N348), .Z(N349) );
  GTECH_AND2 C486 ( .A(N482), .B(N495), .Z(N351) );
  GTECH_OR2 C488 ( .A(instruction[12]), .B(N495), .Z(N352) );
  GTECH_OR2 C491 ( .A(N482), .B(instruction[11]), .Z(N354) );
  GTECH_AND2 C493 ( .A(instruction[12]), .B(instruction[11]), .Z(N356) );
  GTECH_AND2 C700 ( .A(N496), .B(N393), .Z(N394) );
  GTECH_AND2 C701 ( .A(N722), .B(N394), .Z(N395) );
  GTECH_OR2 C704 ( .A(instruction[7]), .B(N393), .Z(N396) );
  GTECH_OR2 C705 ( .A(N735), .B(N396), .Z(N397) );
  GTECH_OR2 C710 ( .A(N735), .B(N416), .Z(N399) );
  GTECH_OR2 C716 ( .A(N735), .B(N419), .Z(N401) );
  GTECH_OR2 C721 ( .A(N725), .B(N411), .Z(N403) );
  GTECH_OR2 C727 ( .A(N725), .B(N396), .Z(N405) );
  GTECH_OR2 C733 ( .A(N725), .B(N416), .Z(N407) );
  GTECH_OR2 C740 ( .A(N725), .B(N419), .Z(N409) );
  GTECH_OR2 C744 ( .A(instruction[7]), .B(instruction[6]), .Z(N411) );
  GTECH_OR2 C745 ( .A(N728), .B(N411), .Z(N412) );
  GTECH_OR2 C751 ( .A(N728), .B(N396), .Z(N414) );
  GTECH_OR2 C756 ( .A(N496), .B(instruction[6]), .Z(N416) );
  GTECH_OR2 C757 ( .A(N728), .B(N416), .Z(N417) );
  GTECH_OR2 C763 ( .A(N496), .B(N393), .Z(N419) );
  GTECH_OR2 C764 ( .A(N728), .B(N419), .Z(N420) );
  GTECH_OR2 C770 ( .A(N731), .B(N411), .Z(N422) );
  GTECH_OR2 C777 ( .A(N731), .B(N396), .Z(N424) );
  GTECH_OR2 C784 ( .A(N731), .B(N416), .Z(N426) );
  GTECH_AND2 C787 ( .A(instruction[7]), .B(instruction[6]), .Z(N428) );
  GTECH_AND2 C788 ( .A(N176), .B(N428), .Z(N429) );
  GTECH_OR2 C1199 ( .A(instruction[8]), .B(instruction[7]), .Z(N497) );
  GTECH_OR2 C1200 ( .A(instruction[6]), .B(instruction[5]), .Z(N498) );
  GTECH_OR2 C1201 ( .A(instruction[4]), .B(instruction[3]), .Z(N499) );
  GTECH_OR2 C1202 ( .A(instruction[2]), .B(instruction[1]), .Z(N500) );
  GTECH_OR2 C1203 ( .A(N497), .B(N498), .Z(N501) );
  GTECH_OR2 C1204 ( .A(N499), .B(N500), .Z(N502) );
  GTECH_OR2 C1205 ( .A(N501), .B(N502), .Z(N503) );
  GTECH_OR2 C1206 ( .A(N503), .B(N184), .Z(N504) );
  GTECH_OR2 C1209 ( .A(instruction[8]), .B(instruction[7]), .Z(N506) );
  GTECH_OR2 C1210 ( .A(instruction[6]), .B(instruction[5]), .Z(N507) );
  GTECH_OR2 C1211 ( .A(instruction[4]), .B(instruction[3]), .Z(N508) );
  GTECH_OR2 C1212 ( .A(instruction[2]), .B(N183), .Z(N509) );
  GTECH_OR2 C1213 ( .A(N506), .B(N507), .Z(N510) );
  GTECH_OR2 C1214 ( .A(N508), .B(N509), .Z(N511) );
  GTECH_OR2 C1215 ( .A(N510), .B(N511), .Z(N512) );
  GTECH_OR2 C1216 ( .A(N512), .B(instruction[0]), .Z(N513) );
  GTECH_OR2 C1219 ( .A(instruction[8]), .B(instruction[7]), .Z(N515) );
  GTECH_OR2 C1220 ( .A(instruction[6]), .B(instruction[5]), .Z(N516) );
  GTECH_OR2 C1221 ( .A(instruction[4]), .B(instruction[3]), .Z(N517) );
  GTECH_OR2 C1222 ( .A(N182), .B(instruction[1]), .Z(N518) );
  GTECH_OR2 C1223 ( .A(N515), .B(N516), .Z(N519) );
  GTECH_OR2 C1224 ( .A(N517), .B(N518), .Z(N520) );
  GTECH_OR2 C1225 ( .A(N519), .B(N520), .Z(N521) );
  GTECH_OR2 C1226 ( .A(N521), .B(instruction[0]), .Z(N522) );
  GTECH_OR2 C1229 ( .A(instruction[8]), .B(instruction[7]), .Z(N524) );
  GTECH_OR2 C1230 ( .A(instruction[6]), .B(instruction[5]), .Z(N525) );
  GTECH_OR2 C1231 ( .A(instruction[4]), .B(N181), .Z(N526) );
  GTECH_OR2 C1232 ( .A(instruction[2]), .B(instruction[1]), .Z(N527) );
  GTECH_OR2 C1233 ( .A(N524), .B(N525), .Z(N528) );
  GTECH_OR2 C1234 ( .A(N526), .B(N527), .Z(N529) );
  GTECH_OR2 C1235 ( .A(N528), .B(N529), .Z(N530) );
  GTECH_OR2 C1236 ( .A(N530), .B(instruction[0]), .Z(N531) );
  GTECH_OR2 C1239 ( .A(instruction[8]), .B(instruction[7]), .Z(N534) );
  GTECH_OR2 C1240 ( .A(instruction[6]), .B(instruction[5]), .Z(N535) );
  GTECH_OR2 C1241 ( .A(N533), .B(instruction[3]), .Z(N536) );
  GTECH_OR2 C1242 ( .A(instruction[2]), .B(instruction[1]), .Z(N537) );
  GTECH_OR2 C1243 ( .A(N534), .B(N535), .Z(N538) );
  GTECH_OR2 C1244 ( .A(N536), .B(N537), .Z(N539) );
  GTECH_OR2 C1245 ( .A(N538), .B(N539), .Z(N540) );
  GTECH_OR2 C1246 ( .A(N540), .B(instruction[0]), .Z(N541) );
  GTECH_OR2 C1249 ( .A(instruction[8]), .B(instruction[7]), .Z(N544) );
  GTECH_OR2 C1250 ( .A(instruction[6]), .B(N543), .Z(N545) );
  GTECH_OR2 C1251 ( .A(instruction[4]), .B(instruction[3]), .Z(N546) );
  GTECH_OR2 C1252 ( .A(instruction[2]), .B(instruction[1]), .Z(N547) );
  GTECH_OR2 C1253 ( .A(N544), .B(N545), .Z(N548) );
  GTECH_OR2 C1254 ( .A(N546), .B(N547), .Z(N549) );
  GTECH_OR2 C1255 ( .A(N548), .B(N549), .Z(N550) );
  GTECH_OR2 C1256 ( .A(N550), .B(instruction[0]), .Z(N551) );
  GTECH_OR2 C1259 ( .A(instruction[8]), .B(instruction[7]), .Z(N553) );
  GTECH_OR2 C1260 ( .A(N393), .B(instruction[5]), .Z(N554) );
  GTECH_OR2 C1261 ( .A(instruction[4]), .B(instruction[3]), .Z(N555) );
  GTECH_OR2 C1262 ( .A(instruction[2]), .B(instruction[1]), .Z(N556) );
  GTECH_OR2 C1263 ( .A(N553), .B(N554), .Z(N557) );
  GTECH_OR2 C1264 ( .A(N555), .B(N556), .Z(N558) );
  GTECH_OR2 C1265 ( .A(N557), .B(N558), .Z(N559) );
  GTECH_OR2 C1266 ( .A(N559), .B(instruction[0]), .Z(N560) );
  GTECH_OR2 C1269 ( .A(instruction[8]), .B(N496), .Z(N562) );
  GTECH_OR2 C1270 ( .A(instruction[6]), .B(instruction[5]), .Z(N563) );
  GTECH_OR2 C1271 ( .A(instruction[4]), .B(instruction[3]), .Z(N564) );
  GTECH_OR2 C1272 ( .A(instruction[2]), .B(instruction[1]), .Z(N565) );
  GTECH_OR2 C1273 ( .A(N562), .B(N563), .Z(N566) );
  GTECH_OR2 C1274 ( .A(N564), .B(N565), .Z(N567) );
  GTECH_OR2 C1275 ( .A(N566), .B(N567), .Z(N568) );
  GTECH_OR2 C1276 ( .A(N568), .B(instruction[0]), .Z(N569) );
  GTECH_OR2 C1279 ( .A(N720), .B(instruction[7]), .Z(N571) );
  GTECH_OR2 C1280 ( .A(instruction[6]), .B(instruction[5]), .Z(N572) );
  GTECH_OR2 C1281 ( .A(instruction[4]), .B(instruction[3]), .Z(N573) );
  GTECH_OR2 C1282 ( .A(instruction[2]), .B(instruction[1]), .Z(N574) );
  GTECH_OR2 C1283 ( .A(N571), .B(N572), .Z(N575) );
  GTECH_OR2 C1284 ( .A(N573), .B(N574), .Z(N576) );
  GTECH_OR2 C1285 ( .A(N575), .B(N576), .Z(N577) );
  GTECH_OR2 C1286 ( .A(N577), .B(instruction[0]), .Z(N578) );
  GTECH_AND2 C1289 ( .A(instruction[1]), .B(N184), .Z(N580) );
  GTECH_AND2 C1292 ( .A(instruction[2]), .B(N183), .Z(N581) );
  GTECH_AND2 C1293 ( .A(N581), .B(N184), .Z(N582) );
  GTECH_AND2 C1297 ( .A(instruction[3]), .B(N182), .Z(N583) );
  GTECH_AND2 C1299 ( .A(N583), .B(N186), .Z(N584) );
  GTECH_AND2 C1304 ( .A(instruction[4]), .B(N181), .Z(N585) );
  GTECH_AND2 C1305 ( .A(N182), .B(N183), .Z(N586) );
  GTECH_AND2 C1306 ( .A(N585), .B(N586), .Z(N587) );
  GTECH_AND2 C1307 ( .A(N587), .B(N184), .Z(N588) );
  GTECH_AND2 C1313 ( .A(instruction[5]), .B(N533), .Z(N589) );
  GTECH_AND2 C1316 ( .A(N589), .B(N185), .Z(N590) );
  GTECH_AND2 C1317 ( .A(N590), .B(N186), .Z(N591) );
  GTECH_AND2 C1324 ( .A(instruction[6]), .B(N543), .Z(N592) );
  GTECH_AND2 C1325 ( .A(N533), .B(N181), .Z(N593) );
  GTECH_AND2 C1326 ( .A(N182), .B(N183), .Z(N594) );
  GTECH_AND2 C1327 ( .A(N592), .B(N593), .Z(N595) );
  GTECH_AND2 C1328 ( .A(N594), .B(N184), .Z(N596) );
  GTECH_AND2 C1329 ( .A(N595), .B(N596), .Z(N597) );
  GTECH_AND2 C1337 ( .A(instruction[7]), .B(N393), .Z(N598) );
  GTECH_AND2 C1338 ( .A(N543), .B(N533), .Z(N599) );
  GTECH_AND2 C1341 ( .A(N598), .B(N599), .Z(N600) );
  GTECH_AND2 C1343 ( .A(N600), .B(N187), .Z(N601) );
  GTECH_AND2 C1353 ( .A(N720), .B(N496), .Z(N602) );
  GTECH_AND2 C1354 ( .A(N393), .B(N543), .Z(N603) );
  GTECH_AND2 C1355 ( .A(N533), .B(N181), .Z(N604) );
  GTECH_AND2 C1356 ( .A(N182), .B(N183), .Z(N605) );
  GTECH_AND2 C1357 ( .A(N602), .B(N603), .Z(N606) );
  GTECH_AND2 C1358 ( .A(N604), .B(N605), .Z(N607) );
  GTECH_AND2 C1359 ( .A(N606), .B(N607), .Z(N608) );
  GTECH_AND2 C1360 ( .A(N608), .B(N184), .Z(N609) );
  GTECH_OR2 C1767 ( .A(instruction[5]), .B(instruction[4]), .Z(N628) );
  GTECH_OR2 C1768 ( .A(instruction[3]), .B(instruction[2]), .Z(N629) );
  GTECH_OR2 C1769 ( .A(instruction[1]), .B(N184), .Z(N630) );
  GTECH_OR2 C1770 ( .A(N411), .B(N628), .Z(N631) );
  GTECH_OR2 C1771 ( .A(N629), .B(N630), .Z(N632) );
  GTECH_OR2 C1772 ( .A(N631), .B(N632), .Z(N633) );
  GTECH_OR2 C1776 ( .A(instruction[5]), .B(instruction[4]), .Z(N635) );
  GTECH_OR2 C1777 ( .A(instruction[3]), .B(instruction[2]), .Z(N636) );
  GTECH_OR2 C1778 ( .A(N183), .B(instruction[0]), .Z(N637) );
  GTECH_OR2 C1779 ( .A(N411), .B(N635), .Z(N638) );
  GTECH_OR2 C1780 ( .A(N636), .B(N637), .Z(N639) );
  GTECH_OR2 C1781 ( .A(N638), .B(N639), .Z(N640) );
  GTECH_OR2 C1785 ( .A(instruction[5]), .B(instruction[4]), .Z(N642) );
  GTECH_OR2 C1786 ( .A(instruction[3]), .B(N182), .Z(N643) );
  GTECH_OR2 C1787 ( .A(instruction[1]), .B(instruction[0]), .Z(N644) );
  GTECH_OR2 C1788 ( .A(N411), .B(N642), .Z(N645) );
  GTECH_OR2 C1789 ( .A(N643), .B(N644), .Z(N646) );
  GTECH_OR2 C1790 ( .A(N645), .B(N646), .Z(N647) );
  GTECH_OR2 C1794 ( .A(instruction[5]), .B(instruction[4]), .Z(N649) );
  GTECH_OR2 C1795 ( .A(N181), .B(instruction[2]), .Z(N650) );
  GTECH_OR2 C1796 ( .A(instruction[1]), .B(instruction[0]), .Z(N651) );
  GTECH_OR2 C1797 ( .A(N411), .B(N649), .Z(N652) );
  GTECH_OR2 C1798 ( .A(N650), .B(N651), .Z(N653) );
  GTECH_OR2 C1799 ( .A(N652), .B(N653), .Z(N654) );
  GTECH_OR2 C1803 ( .A(instruction[5]), .B(N533), .Z(N656) );
  GTECH_OR2 C1804 ( .A(instruction[3]), .B(instruction[2]), .Z(N657) );
  GTECH_OR2 C1805 ( .A(instruction[1]), .B(instruction[0]), .Z(N658) );
  GTECH_OR2 C1806 ( .A(N411), .B(N656), .Z(N659) );
  GTECH_OR2 C1807 ( .A(N657), .B(N658), .Z(N660) );
  GTECH_OR2 C1808 ( .A(N659), .B(N660), .Z(N661) );
  GTECH_OR2 C1812 ( .A(N543), .B(instruction[4]), .Z(N663) );
  GTECH_OR2 C1813 ( .A(instruction[3]), .B(instruction[2]), .Z(N664) );
  GTECH_OR2 C1814 ( .A(instruction[1]), .B(instruction[0]), .Z(N665) );
  GTECH_OR2 C1815 ( .A(N411), .B(N663), .Z(N666) );
  GTECH_OR2 C1816 ( .A(N664), .B(N665), .Z(N667) );
  GTECH_OR2 C1817 ( .A(N666), .B(N667), .Z(N668) );
  GTECH_OR2 C1821 ( .A(instruction[5]), .B(instruction[4]), .Z(N670) );
  GTECH_OR2 C1822 ( .A(instruction[3]), .B(instruction[2]), .Z(N671) );
  GTECH_OR2 C1823 ( .A(instruction[1]), .B(instruction[0]), .Z(N672) );
  GTECH_OR2 C1824 ( .A(N396), .B(N670), .Z(N673) );
  GTECH_OR2 C1825 ( .A(N671), .B(N672), .Z(N674) );
  GTECH_OR2 C1826 ( .A(N673), .B(N674), .Z(N675) );
  GTECH_OR2 C1830 ( .A(instruction[5]), .B(instruction[4]), .Z(N677) );
  GTECH_OR2 C1831 ( .A(instruction[3]), .B(instruction[2]), .Z(N678) );
  GTECH_OR2 C1832 ( .A(instruction[1]), .B(instruction[0]), .Z(N679) );
  GTECH_OR2 C1833 ( .A(N416), .B(N677), .Z(N680) );
  GTECH_OR2 C1834 ( .A(N678), .B(N679), .Z(N681) );
  GTECH_OR2 C1835 ( .A(N680), .B(N681), .Z(N682) );
  GTECH_AND2 C1838 ( .A(instruction[1]), .B(N184), .Z(N684) );
  GTECH_AND2 C1841 ( .A(instruction[2]), .B(N183), .Z(N685) );
  GTECH_AND2 C1842 ( .A(N685), .B(N184), .Z(N686) );
  GTECH_AND2 C1846 ( .A(instruction[3]), .B(N182), .Z(N687) );
  GTECH_AND2 C1848 ( .A(N687), .B(N186), .Z(N688) );
  GTECH_AND2 C1853 ( .A(instruction[4]), .B(N181), .Z(N689) );
  GTECH_AND2 C1854 ( .A(N182), .B(N183), .Z(N690) );
  GTECH_AND2 C1855 ( .A(N689), .B(N690), .Z(N691) );
  GTECH_AND2 C1856 ( .A(N691), .B(N184), .Z(N692) );
  GTECH_AND2 C1862 ( .A(instruction[5]), .B(N533), .Z(N693) );
  GTECH_AND2 C1865 ( .A(N693), .B(N185), .Z(N694) );
  GTECH_AND2 C1866 ( .A(N694), .B(N186), .Z(N695) );
  GTECH_AND2 C1873 ( .A(instruction[6]), .B(N543), .Z(N696) );
  GTECH_AND2 C1874 ( .A(N533), .B(N181), .Z(N697) );
  GTECH_AND2 C1875 ( .A(N182), .B(N183), .Z(N698) );
  GTECH_AND2 C1876 ( .A(N696), .B(N697), .Z(N699) );
  GTECH_AND2 C1877 ( .A(N698), .B(N184), .Z(N700) );
  GTECH_AND2 C1878 ( .A(N699), .B(N700), .Z(N701) );
  GTECH_AND2 C1888 ( .A(N543), .B(N533), .Z(N702) );
  GTECH_AND2 C1891 ( .A(N394), .B(N702), .Z(N703) );
  GTECH_AND2 C1893 ( .A(N703), .B(N187), .Z(N704) );
  GTECH_AND2 C2262 ( .A(N495), .B(N462), .Z(N721) );
  GTECH_AND2 C2263 ( .A(N363), .B(N720), .Z(N722) );
  GTECH_AND2 C2264 ( .A(N721), .B(N722), .Z(N723) );
  GTECH_OR2 C2266 ( .A(instruction[11]), .B(instruction[10]), .Z(N724) );
  GTECH_OR2 C2267 ( .A(instruction[9]), .B(N720), .Z(N725) );
  GTECH_OR2 C2268 ( .A(N724), .B(N725), .Z(N726) );
  GTECH_OR2 C2272 ( .A(N363), .B(instruction[8]), .Z(N728) );
  GTECH_OR2 C2273 ( .A(N724), .B(N728), .Z(N729) );
  GTECH_OR2 C2278 ( .A(N363), .B(N720), .Z(N731) );
  GTECH_OR2 C2279 ( .A(N724), .B(N731), .Z(N732) );
  GTECH_OR2 C2282 ( .A(instruction[11]), .B(N462), .Z(N734) );
  GTECH_OR2 C2283 ( .A(instruction[9]), .B(instruction[8]), .Z(N735) );
  GTECH_OR2 C2284 ( .A(N734), .B(N735), .Z(N736) );
  GTECH_OR2 C2290 ( .A(N734), .B(N725), .Z(N738) );
  GTECH_OR2 C2296 ( .A(N734), .B(N728), .Z(N740) );
  GTECH_OR2 C2303 ( .A(N734), .B(N731), .Z(N742) );
  GTECH_OR2 C2306 ( .A(N495), .B(instruction[10]), .Z(N744) );
  GTECH_OR2 C2308 ( .A(N744), .B(N735), .Z(N745) );
  GTECH_OR2 C2314 ( .A(N744), .B(N725), .Z(N747) );
  GTECH_OR2 C2320 ( .A(N744), .B(N728), .Z(N749) );
  GTECH_OR2 C2327 ( .A(N744), .B(N731), .Z(N751) );
  GTECH_OR2 C2331 ( .A(N495), .B(N462), .Z(N753) );
  GTECH_OR2 C2333 ( .A(N753), .B(N735), .Z(N754) );
  GTECH_OR2 C2340 ( .A(N753), .B(N725), .Z(N756) );
  GTECH_OR2 C2347 ( .A(N753), .B(N728), .Z(N758) );
  GTECH_NOT I_0 ( .A(next_alu_stack_write_to_reg[3]), .Z(N1003) );
  GTECH_NOT I_1 ( .A(next_alu_stack_write_to_reg[2]), .Z(N1004) );
  GTECH_NOT I_2 ( .A(next_alu_stack_write_to_reg[1]), .Z(N1005) );
  GTECH_NOT I_3 ( .A(next_alu_stack_write_to_reg[0]), .Z(N1006) );
  GTECH_OR2 C2914 ( .A(N1003), .B(next_alu_stack_write_to_reg[4]), .Z(N1007)
         );
  GTECH_OR2 C2915 ( .A(N1004), .B(N1007), .Z(N1008) );
  GTECH_OR2 C2916 ( .A(N1005), .B(N1008), .Z(N1009) );
  GTECH_OR2 C2917 ( .A(N1006), .B(N1009), .Z(N1010) );
  GTECH_NOT I_4 ( .A(N1010), .Z(N1011) );
  GTECH_NOT I_5 ( .A(next_memory_write_to_reg[3]), .Z(N1012) );
  GTECH_NOT I_6 ( .A(next_memory_write_to_reg[2]), .Z(N1013) );
  GTECH_NOT I_7 ( .A(next_memory_write_to_reg[1]), .Z(N1014) );
  GTECH_NOT I_8 ( .A(next_memory_write_to_reg[0]), .Z(N1015) );
  GTECH_OR2 C2923 ( .A(N1012), .B(next_memory_write_to_reg[4]), .Z(N1016) );
  GTECH_OR2 C2924 ( .A(N1013), .B(N1016), .Z(N1017) );
  GTECH_OR2 C2925 ( .A(N1014), .B(N1017), .Z(N1018) );
  GTECH_OR2 C2926 ( .A(N1015), .B(N1018), .Z(N1019) );
  GTECH_NOT I_9 ( .A(N1019), .Z(N1020) );
  GTECH_NOT I_10 ( .A(itstate[3]), .Z(N1021) );
  GTECH_OR2 C2929 ( .A(itstate[2]), .B(N1021), .Z(N1022) );
  GTECH_OR2 C2930 ( .A(itstate[1]), .B(N1022), .Z(N1023) );
  GTECH_OR2 C2931 ( .A(itstate[0]), .B(N1023), .Z(N1024) );
  GTECH_NOT I_11 ( .A(N1024), .Z(N1025) );
  GTECH_OR2 C2933 ( .A(itstate[6]), .B(itstate[7]), .Z(N1026) );
  GTECH_OR2 C2934 ( .A(itstate[5]), .B(N1026), .Z(N1027) );
  GTECH_OR2 C2935 ( .A(itstate[4]), .B(N1027), .Z(N1028) );
  GTECH_OR2 C2936 ( .A(itstate[3]), .B(N1028), .Z(N1029) );
  GTECH_OR2 C2937 ( .A(itstate[2]), .B(N1029), .Z(N1030) );
  GTECH_OR2 C2938 ( .A(itstate[1]), .B(N1030), .Z(N1031) );
  GTECH_OR2 C2939 ( .A(itstate[0]), .B(N1031), .Z(N1032) );
  GTECH_NOT I_12 ( .A(N1032), .Z(N1033) );
  GTECH_OR2 C2941 ( .A(itstate[6]), .B(itstate[7]), .Z(N1034) );
  GTECH_OR2 C2942 ( .A(itstate[5]), .B(N1034), .Z(N1035) );
  GTECH_OR2 C2943 ( .A(itstate[4]), .B(N1035), .Z(N1036) );
  GTECH_OR2 C2944 ( .A(itstate[3]), .B(N1036), .Z(N1037) );
  GTECH_OR2 C2945 ( .A(itstate[2]), .B(N1037), .Z(N1038) );
  GTECH_OR2 C2946 ( .A(itstate[1]), .B(N1038), .Z(N1039) );
  GTECH_OR2 C2947 ( .A(itstate[0]), .B(N1039), .Z(N1040) );
  GTECH_NOT I_13 ( .A(N1040), .Z(N1041) );
  GTECH_OR2 C2949 ( .A(itstate[6]), .B(itstate[7]), .Z(N1042) );
  GTECH_OR2 C2950 ( .A(itstate[5]), .B(N1042), .Z(N1043) );
  GTECH_OR2 C2951 ( .A(itstate[4]), .B(N1043), .Z(N1044) );
  GTECH_OR2 C2952 ( .A(itstate[3]), .B(N1044), .Z(N1045) );
  GTECH_OR2 C2953 ( .A(itstate[2]), .B(N1045), .Z(N1046) );
  GTECH_OR2 C2954 ( .A(itstate[1]), .B(N1046), .Z(N1047) );
  GTECH_OR2 C2955 ( .A(itstate[0]), .B(N1047), .Z(N1048) );
  GTECH_NOT I_14 ( .A(N1048), .Z(N1049) );
  GTECH_OR2 C2957 ( .A(itstate[6]), .B(itstate[7]), .Z(N1050) );
  GTECH_OR2 C2958 ( .A(itstate[5]), .B(N1050), .Z(N1051) );
  GTECH_OR2 C2959 ( .A(itstate[4]), .B(N1051), .Z(N1052) );
  GTECH_OR2 C2960 ( .A(itstate[3]), .B(N1052), .Z(N1053) );
  GTECH_OR2 C2961 ( .A(itstate[2]), .B(N1053), .Z(N1054) );
  GTECH_OR2 C2962 ( .A(itstate[1]), .B(N1054), .Z(N1055) );
  GTECH_OR2 C2963 ( .A(itstate[0]), .B(N1055), .Z(N1056) );
  GTECH_NOT I_15 ( .A(N1056), .Z(N1057) );
  GTECH_OR2 C2965 ( .A(itstate[6]), .B(itstate[7]), .Z(N1058) );
  GTECH_OR2 C2966 ( .A(itstate[5]), .B(N1058), .Z(N1059) );
  GTECH_OR2 C2967 ( .A(itstate[4]), .B(N1059), .Z(N1060) );
  GTECH_OR2 C2968 ( .A(itstate[3]), .B(N1060), .Z(N1061) );
  GTECH_OR2 C2969 ( .A(itstate[2]), .B(N1061), .Z(N1062) );
  GTECH_OR2 C2970 ( .A(itstate[1]), .B(N1062), .Z(N1063) );
  GTECH_OR2 C2971 ( .A(itstate[0]), .B(N1063), .Z(N1064) );
  GTECH_NOT I_16 ( .A(N1064), .Z(N1065) );
  GTECH_OR2 C2973 ( .A(itstate[6]), .B(itstate[7]), .Z(N1066) );
  GTECH_OR2 C2974 ( .A(itstate[5]), .B(N1066), .Z(N1067) );
  GTECH_OR2 C2975 ( .A(itstate[4]), .B(N1067), .Z(N1068) );
  GTECH_OR2 C2976 ( .A(itstate[3]), .B(N1068), .Z(N1069) );
  GTECH_OR2 C2977 ( .A(itstate[2]), .B(N1069), .Z(N1070) );
  GTECH_OR2 C2978 ( .A(itstate[1]), .B(N1070), .Z(N1071) );
  GTECH_OR2 C2979 ( .A(itstate[0]), .B(N1071), .Z(N1072) );
  GTECH_NOT I_17 ( .A(N1072), .Z(N1073) );
  GTECH_OR2 C2981 ( .A(itstate[6]), .B(itstate[7]), .Z(N1074) );
  GTECH_OR2 C2982 ( .A(itstate[5]), .B(N1074), .Z(N1075) );
  GTECH_OR2 C2983 ( .A(itstate[4]), .B(N1075), .Z(N1076) );
  GTECH_OR2 C2984 ( .A(itstate[3]), .B(N1076), .Z(N1077) );
  GTECH_OR2 C2985 ( .A(itstate[2]), .B(N1077), .Z(N1078) );
  GTECH_OR2 C2986 ( .A(itstate[1]), .B(N1078), .Z(N1079) );
  GTECH_OR2 C2987 ( .A(itstate[0]), .B(N1079), .Z(N1080) );
  GTECH_NOT I_18 ( .A(N1080), .Z(N1081) );
  GTECH_OR2 C2989 ( .A(itstate[6]), .B(itstate[7]), .Z(N1082) );
  GTECH_OR2 C2990 ( .A(itstate[5]), .B(N1082), .Z(N1083) );
  GTECH_OR2 C2991 ( .A(itstate[4]), .B(N1083), .Z(N1084) );
  GTECH_OR2 C2992 ( .A(itstate[3]), .B(N1084), .Z(N1085) );
  GTECH_OR2 C2993 ( .A(itstate[2]), .B(N1085), .Z(N1086) );
  GTECH_OR2 C2994 ( .A(itstate[1]), .B(N1086), .Z(N1087) );
  GTECH_OR2 C2995 ( .A(itstate[0]), .B(N1087), .Z(N1088) );
  GTECH_NOT I_19 ( .A(N1088), .Z(N1089) );
  GTECH_OR2 C2997 ( .A(itstate[6]), .B(itstate[7]), .Z(N1090) );
  GTECH_OR2 C2998 ( .A(itstate[5]), .B(N1090), .Z(N1091) );
  GTECH_OR2 C2999 ( .A(itstate[4]), .B(N1091), .Z(N1092) );
  GTECH_OR2 C3000 ( .A(itstate[3]), .B(N1092), .Z(N1093) );
  GTECH_OR2 C3001 ( .A(itstate[2]), .B(N1093), .Z(N1094) );
  GTECH_OR2 C3002 ( .A(itstate[1]), .B(N1094), .Z(N1095) );
  GTECH_OR2 C3003 ( .A(itstate[0]), .B(N1095), .Z(N1096) );
  GTECH_NOT I_20 ( .A(N1096), .Z(N1097) );
  GTECH_OR2 C3005 ( .A(itstate[6]), .B(itstate[7]), .Z(N1098) );
  GTECH_OR2 C3006 ( .A(itstate[5]), .B(N1098), .Z(N1099) );
  GTECH_OR2 C3007 ( .A(itstate[4]), .B(N1099), .Z(N1100) );
  GTECH_OR2 C3008 ( .A(itstate[3]), .B(N1100), .Z(N1101) );
  GTECH_OR2 C3009 ( .A(itstate[2]), .B(N1101), .Z(N1102) );
  GTECH_OR2 C3010 ( .A(itstate[1]), .B(N1102), .Z(N1103) );
  GTECH_OR2 C3011 ( .A(itstate[0]), .B(N1103), .Z(N1104) );
  GTECH_NOT I_21 ( .A(N1104), .Z(N1105) );
  GTECH_OR2 C3013 ( .A(itstate[6]), .B(itstate[7]), .Z(N1106) );
  GTECH_OR2 C3014 ( .A(itstate[5]), .B(N1106), .Z(N1107) );
  GTECH_OR2 C3015 ( .A(itstate[4]), .B(N1107), .Z(N1108) );
  GTECH_OR2 C3016 ( .A(itstate[3]), .B(N1108), .Z(N1109) );
  GTECH_OR2 C3017 ( .A(itstate[2]), .B(N1109), .Z(N1110) );
  GTECH_OR2 C3018 ( .A(itstate[1]), .B(N1110), .Z(N1111) );
  GTECH_OR2 C3019 ( .A(itstate[0]), .B(N1111), .Z(N1112) );
  GTECH_NOT I_22 ( .A(N1112), .Z(N1113) );
  GTECH_OR2 C3021 ( .A(itstate[6]), .B(itstate[7]), .Z(N1114) );
  GTECH_OR2 C3022 ( .A(itstate[5]), .B(N1114), .Z(N1115) );
  GTECH_OR2 C3023 ( .A(itstate[4]), .B(N1115), .Z(N1116) );
  GTECH_OR2 C3024 ( .A(itstate[3]), .B(N1116), .Z(N1117) );
  GTECH_OR2 C3025 ( .A(itstate[2]), .B(N1117), .Z(N1118) );
  GTECH_OR2 C3026 ( .A(itstate[1]), .B(N1118), .Z(N1119) );
  GTECH_OR2 C3027 ( .A(itstate[0]), .B(N1119), .Z(N1120) );
  GTECH_NOT I_23 ( .A(N1120), .Z(N1121) );
  GTECH_OR2 C3029 ( .A(itstate[6]), .B(itstate[7]), .Z(N1122) );
  GTECH_OR2 C3030 ( .A(itstate[5]), .B(N1122), .Z(N1123) );
  GTECH_OR2 C3031 ( .A(itstate[4]), .B(N1123), .Z(N1124) );
  GTECH_OR2 C3032 ( .A(itstate[3]), .B(N1124), .Z(N1125) );
  GTECH_OR2 C3033 ( .A(itstate[2]), .B(N1125), .Z(N1126) );
  GTECH_OR2 C3034 ( .A(itstate[1]), .B(N1126), .Z(N1127) );
  GTECH_OR2 C3035 ( .A(itstate[0]), .B(N1127), .Z(N1128) );
  GTECH_NOT I_24 ( .A(N1128), .Z(N1129) );
  GTECH_OR2 C3037 ( .A(itstate[6]), .B(itstate[7]), .Z(N1130) );
  GTECH_OR2 C3038 ( .A(itstate[5]), .B(N1130), .Z(N1131) );
  GTECH_OR2 C3039 ( .A(itstate[4]), .B(N1131), .Z(N1132) );
  GTECH_OR2 C3040 ( .A(itstate[3]), .B(N1132), .Z(N1133) );
  GTECH_OR2 C3041 ( .A(itstate[2]), .B(N1133), .Z(N1134) );
  GTECH_OR2 C3042 ( .A(itstate[1]), .B(N1134), .Z(N1135) );
  GTECH_OR2 C3043 ( .A(itstate[0]), .B(N1135), .Z(N1136) );
  GTECH_NOT I_25 ( .A(N1136), .Z(N1137) );
  GTECH_OR2 C3045 ( .A(itstate[6]), .B(itstate[7]), .Z(N1138) );
  GTECH_OR2 C3046 ( .A(itstate[5]), .B(N1138), .Z(N1139) );
  GTECH_OR2 C3047 ( .A(itstate[4]), .B(N1139), .Z(N1140) );
  GTECH_OR2 C3048 ( .A(itstate[3]), .B(N1140), .Z(N1141) );
  GTECH_OR2 C3049 ( .A(itstate[2]), .B(N1141), .Z(N1142) );
  GTECH_OR2 C3050 ( .A(itstate[1]), .B(N1142), .Z(N1143) );
  GTECH_OR2 C3051 ( .A(itstate[0]), .B(N1143), .Z(N1144) );
  GTECH_NOT I_26 ( .A(N1144), .Z(N1145) );
  GTECH_OR2 C3053 ( .A(itstate[6]), .B(itstate[7]), .Z(N1146) );
  GTECH_OR2 C3054 ( .A(itstate[5]), .B(N1146), .Z(N1147) );
  GTECH_OR2 C3055 ( .A(itstate[4]), .B(N1147), .Z(N1148) );
  GTECH_OR2 C3056 ( .A(itstate[3]), .B(N1148), .Z(N1149) );
  GTECH_OR2 C3057 ( .A(itstate[2]), .B(N1149), .Z(N1150) );
  GTECH_OR2 C3058 ( .A(itstate[1]), .B(N1150), .Z(N1151) );
  GTECH_OR2 C3059 ( .A(itstate[0]), .B(N1151), .Z(N1152) );
  GTECH_NOT I_27 ( .A(N1152), .Z(N1153) );
  GTECH_OR2 C3061 ( .A(itstate[6]), .B(itstate[7]), .Z(N1154) );
  GTECH_OR2 C3062 ( .A(itstate[5]), .B(N1154), .Z(N1155) );
  GTECH_OR2 C3063 ( .A(itstate[4]), .B(N1155), .Z(N1156) );
  GTECH_OR2 C3064 ( .A(itstate[3]), .B(N1156), .Z(N1157) );
  GTECH_OR2 C3065 ( .A(itstate[2]), .B(N1157), .Z(N1158) );
  GTECH_OR2 C3066 ( .A(itstate[1]), .B(N1158), .Z(N1159) );
  GTECH_OR2 C3067 ( .A(itstate[0]), .B(N1159), .Z(N1160) );
  GTECH_NOT I_28 ( .A(N1160), .Z(N1161) );
  GTECH_OR2 C3069 ( .A(itstate[6]), .B(itstate[7]), .Z(N1162) );
  GTECH_OR2 C3070 ( .A(itstate[5]), .B(N1162), .Z(N1163) );
  GTECH_OR2 C3071 ( .A(itstate[4]), .B(N1163), .Z(N1164) );
  GTECH_OR2 C3072 ( .A(itstate[3]), .B(N1164), .Z(N1165) );
  GTECH_OR2 C3073 ( .A(itstate[2]), .B(N1165), .Z(N1166) );
  GTECH_OR2 C3074 ( .A(itstate[1]), .B(N1166), .Z(N1167) );
  GTECH_OR2 C3075 ( .A(itstate[0]), .B(N1167), .Z(N1168) );
  GTECH_NOT I_29 ( .A(N1168), .Z(N1169) );
  GTECH_OR2 C3077 ( .A(itstate[6]), .B(itstate[7]), .Z(N1170) );
  GTECH_OR2 C3078 ( .A(itstate[5]), .B(N1170), .Z(N1171) );
  GTECH_OR2 C3079 ( .A(itstate[4]), .B(N1171), .Z(N1172) );
  GTECH_OR2 C3080 ( .A(itstate[3]), .B(N1172), .Z(N1173) );
  GTECH_OR2 C3081 ( .A(itstate[2]), .B(N1173), .Z(N1174) );
  GTECH_OR2 C3082 ( .A(itstate[1]), .B(N1174), .Z(N1175) );
  GTECH_OR2 C3083 ( .A(itstate[0]), .B(N1175), .Z(N1176) );
  GTECH_NOT I_30 ( .A(N1176), .Z(N1177) );
  GTECH_OR2 C3085 ( .A(itstate[6]), .B(itstate[7]), .Z(N1178) );
  GTECH_OR2 C3086 ( .A(itstate[5]), .B(N1178), .Z(N1179) );
  GTECH_OR2 C3087 ( .A(itstate[4]), .B(N1179), .Z(N1180) );
  GTECH_OR2 C3088 ( .A(itstate[3]), .B(N1180), .Z(N1181) );
  GTECH_OR2 C3089 ( .A(itstate[2]), .B(N1181), .Z(N1182) );
  GTECH_OR2 C3090 ( .A(itstate[1]), .B(N1182), .Z(N1183) );
  GTECH_OR2 C3091 ( .A(itstate[0]), .B(N1183), .Z(N1184) );
  GTECH_NOT I_31 ( .A(N1184), .Z(N1185) );
  GTECH_OR2 C3093 ( .A(itstate[6]), .B(itstate[7]), .Z(N1186) );
  GTECH_OR2 C3094 ( .A(itstate[5]), .B(N1186), .Z(N1187) );
  GTECH_OR2 C3095 ( .A(itstate[4]), .B(N1187), .Z(N1188) );
  GTECH_OR2 C3096 ( .A(itstate[3]), .B(N1188), .Z(N1189) );
  GTECH_OR2 C3097 ( .A(itstate[2]), .B(N1189), .Z(N1190) );
  GTECH_OR2 C3098 ( .A(itstate[1]), .B(N1190), .Z(N1191) );
  GTECH_OR2 C3099 ( .A(itstate[0]), .B(N1191), .Z(N1192) );
  GTECH_NOT I_32 ( .A(N1192), .Z(N1193) );
  GTECH_OR2 C3101 ( .A(itstate[6]), .B(itstate[7]), .Z(N1194) );
  GTECH_OR2 C3102 ( .A(itstate[5]), .B(N1194), .Z(N1195) );
  GTECH_OR2 C3103 ( .A(itstate[4]), .B(N1195), .Z(N1196) );
  GTECH_OR2 C3104 ( .A(itstate[3]), .B(N1196), .Z(N1197) );
  GTECH_OR2 C3105 ( .A(itstate[2]), .B(N1197), .Z(N1198) );
  GTECH_OR2 C3106 ( .A(itstate[1]), .B(N1198), .Z(N1199) );
  GTECH_OR2 C3107 ( .A(itstate[0]), .B(N1199), .Z(N1200) );
  GTECH_NOT I_33 ( .A(N1200), .Z(N1201) );
  GTECH_OR2 C3109 ( .A(itstate[6]), .B(itstate[7]), .Z(N1202) );
  GTECH_OR2 C3110 ( .A(itstate[5]), .B(N1202), .Z(N1203) );
  GTECH_OR2 C3111 ( .A(itstate[4]), .B(N1203), .Z(N1204) );
  GTECH_OR2 C3112 ( .A(itstate[3]), .B(N1204), .Z(N1205) );
  GTECH_OR2 C3113 ( .A(itstate[2]), .B(N1205), .Z(N1206) );
  GTECH_OR2 C3114 ( .A(itstate[1]), .B(N1206), .Z(N1207) );
  GTECH_OR2 C3115 ( .A(itstate[0]), .B(N1207), .Z(N1208) );
  GTECH_NOT I_34 ( .A(N1208), .Z(N1209) );
  GTECH_OR2 C3117 ( .A(itstate[6]), .B(itstate[7]), .Z(N1210) );
  GTECH_OR2 C3118 ( .A(itstate[5]), .B(N1210), .Z(N1211) );
  GTECH_OR2 C3119 ( .A(itstate[4]), .B(N1211), .Z(N1212) );
  GTECH_OR2 C3120 ( .A(itstate[3]), .B(N1212), .Z(N1213) );
  GTECH_OR2 C3121 ( .A(itstate[2]), .B(N1213), .Z(N1214) );
  GTECH_OR2 C3122 ( .A(itstate[1]), .B(N1214), .Z(N1215) );
  GTECH_OR2 C3123 ( .A(itstate[0]), .B(N1215), .Z(N1216) );
  GTECH_NOT I_35 ( .A(N1216), .Z(N1217) );
  GTECH_OR2 C3125 ( .A(itstate[6]), .B(itstate[7]), .Z(N1218) );
  GTECH_OR2 C3126 ( .A(itstate[5]), .B(N1218), .Z(N1219) );
  GTECH_OR2 C3127 ( .A(itstate[4]), .B(N1219), .Z(N1220) );
  GTECH_OR2 C3128 ( .A(itstate[3]), .B(N1220), .Z(N1221) );
  GTECH_OR2 C3129 ( .A(itstate[2]), .B(N1221), .Z(N1222) );
  GTECH_OR2 C3130 ( .A(itstate[1]), .B(N1222), .Z(N1223) );
  GTECH_OR2 C3131 ( .A(itstate[0]), .B(N1223), .Z(N1224) );
  GTECH_NOT I_36 ( .A(N1224), .Z(N1225) );
  GTECH_OR2 C3133 ( .A(itstate[6]), .B(itstate[7]), .Z(N1226) );
  GTECH_OR2 C3134 ( .A(itstate[5]), .B(N1226), .Z(N1227) );
  GTECH_OR2 C3135 ( .A(itstate[4]), .B(N1227), .Z(N1228) );
  GTECH_OR2 C3136 ( .A(itstate[3]), .B(N1228), .Z(N1229) );
  GTECH_OR2 C3137 ( .A(itstate[2]), .B(N1229), .Z(N1230) );
  GTECH_OR2 C3138 ( .A(itstate[1]), .B(N1230), .Z(N1231) );
  GTECH_OR2 C3139 ( .A(itstate[0]), .B(N1231), .Z(N1232) );
  GTECH_NOT I_37 ( .A(N1232), .Z(N1233) );
  GTECH_OR2 C3141 ( .A(itstate[6]), .B(itstate[7]), .Z(N1234) );
  GTECH_OR2 C3142 ( .A(itstate[5]), .B(N1234), .Z(N1235) );
  GTECH_OR2 C3143 ( .A(itstate[4]), .B(N1235), .Z(N1236) );
  GTECH_OR2 C3144 ( .A(itstate[3]), .B(N1236), .Z(N1237) );
  GTECH_OR2 C3145 ( .A(itstate[2]), .B(N1237), .Z(N1238) );
  GTECH_OR2 C3146 ( .A(itstate[1]), .B(N1238), .Z(N1239) );
  GTECH_OR2 C3147 ( .A(itstate[0]), .B(N1239), .Z(N1240) );
  GTECH_NOT I_38 ( .A(N1240), .Z(N1241) );
  GTECH_OR2 C3149 ( .A(itstate[6]), .B(itstate[7]), .Z(N1242) );
  GTECH_OR2 C3150 ( .A(itstate[5]), .B(N1242), .Z(N1243) );
  GTECH_OR2 C3151 ( .A(itstate[4]), .B(N1243), .Z(N1244) );
  GTECH_OR2 C3152 ( .A(itstate[3]), .B(N1244), .Z(N1245) );
  GTECH_OR2 C3153 ( .A(itstate[2]), .B(N1245), .Z(N1246) );
  GTECH_OR2 C3154 ( .A(itstate[1]), .B(N1246), .Z(N1247) );
  GTECH_OR2 C3155 ( .A(itstate[0]), .B(N1247), .Z(N1248) );
  GTECH_NOT I_39 ( .A(N1248), .Z(N1249) );
  GTECH_OR2 C3157 ( .A(itstate[6]), .B(itstate[7]), .Z(N1250) );
  GTECH_OR2 C3158 ( .A(itstate[5]), .B(N1250), .Z(N1251) );
  GTECH_OR2 C3159 ( .A(itstate[4]), .B(N1251), .Z(N1252) );
  GTECH_OR2 C3160 ( .A(itstate[3]), .B(N1252), .Z(N1253) );
  GTECH_OR2 C3161 ( .A(itstate[2]), .B(N1253), .Z(N1254) );
  GTECH_OR2 C3162 ( .A(itstate[1]), .B(N1254), .Z(N1255) );
  GTECH_OR2 C3163 ( .A(itstate[0]), .B(N1255), .Z(N1256) );
  GTECH_NOT I_40 ( .A(N1256), .Z(N1257) );
  GTECH_OR2 C3165 ( .A(itstate[6]), .B(itstate[7]), .Z(N1258) );
  GTECH_OR2 C3166 ( .A(itstate[5]), .B(N1258), .Z(N1259) );
  GTECH_OR2 C3167 ( .A(itstate[4]), .B(N1259), .Z(N1260) );
  GTECH_OR2 C3168 ( .A(itstate[3]), .B(N1260), .Z(N1261) );
  GTECH_OR2 C3169 ( .A(itstate[2]), .B(N1261), .Z(N1262) );
  GTECH_OR2 C3170 ( .A(itstate[1]), .B(N1262), .Z(N1263) );
  GTECH_OR2 C3171 ( .A(itstate[0]), .B(N1263), .Z(N1264) );
  GTECH_NOT I_41 ( .A(N1264), .Z(N1265) );
  GTECH_OR2 C3173 ( .A(itstate[6]), .B(itstate[7]), .Z(N1266) );
  GTECH_OR2 C3174 ( .A(itstate[5]), .B(N1266), .Z(N1267) );
  GTECH_OR2 C3175 ( .A(itstate[4]), .B(N1267), .Z(N1268) );
  GTECH_OR2 C3176 ( .A(itstate[3]), .B(N1268), .Z(N1269) );
  GTECH_OR2 C3177 ( .A(itstate[2]), .B(N1269), .Z(N1270) );
  GTECH_OR2 C3178 ( .A(itstate[1]), .B(N1270), .Z(N1271) );
  GTECH_OR2 C3179 ( .A(itstate[0]), .B(N1271), .Z(N1272) );
  GTECH_NOT I_42 ( .A(N1272), .Z(N1273) );
  GTECH_OR2 C3181 ( .A(itstate[6]), .B(itstate[7]), .Z(N1274) );
  GTECH_OR2 C3182 ( .A(itstate[5]), .B(N1274), .Z(N1275) );
  GTECH_OR2 C3183 ( .A(itstate[4]), .B(N1275), .Z(N1276) );
  GTECH_OR2 C3184 ( .A(itstate[3]), .B(N1276), .Z(N1277) );
  GTECH_OR2 C3185 ( .A(itstate[2]), .B(N1277), .Z(N1278) );
  GTECH_OR2 C3186 ( .A(itstate[1]), .B(N1278), .Z(N1279) );
  GTECH_OR2 C3187 ( .A(itstate[0]), .B(N1279), .Z(N1280) );
  GTECH_NOT I_43 ( .A(N1280), .Z(N1281) );
  GTECH_OR2 C3189 ( .A(itstate[6]), .B(itstate[7]), .Z(N1282) );
  GTECH_OR2 C3190 ( .A(itstate[5]), .B(N1282), .Z(N1283) );
  GTECH_OR2 C3191 ( .A(itstate[4]), .B(N1283), .Z(N1284) );
  GTECH_OR2 C3192 ( .A(itstate[3]), .B(N1284), .Z(N1285) );
  GTECH_OR2 C3193 ( .A(itstate[2]), .B(N1285), .Z(N1286) );
  GTECH_OR2 C3194 ( .A(itstate[1]), .B(N1286), .Z(N1287) );
  GTECH_OR2 C3195 ( .A(itstate[0]), .B(N1287), .Z(N1288) );
  GTECH_NOT I_44 ( .A(N1288), .Z(N1289) );
  GTECH_OR2 C3197 ( .A(itstate[6]), .B(itstate[7]), .Z(N1290) );
  GTECH_OR2 C3198 ( .A(itstate[5]), .B(N1290), .Z(N1291) );
  GTECH_OR2 C3199 ( .A(itstate[4]), .B(N1291), .Z(N1292) );
  GTECH_OR2 C3200 ( .A(itstate[3]), .B(N1292), .Z(N1293) );
  GTECH_OR2 C3201 ( .A(itstate[2]), .B(N1293), .Z(N1294) );
  GTECH_OR2 C3202 ( .A(itstate[1]), .B(N1294), .Z(N1295) );
  GTECH_OR2 C3203 ( .A(itstate[0]), .B(N1295), .Z(N1296) );
  GTECH_NOT I_45 ( .A(N1296), .Z(N1297) );
  GTECH_OR2 C3205 ( .A(itstate[6]), .B(itstate[7]), .Z(N1298) );
  GTECH_OR2 C3206 ( .A(itstate[5]), .B(N1298), .Z(N1299) );
  GTECH_OR2 C3207 ( .A(itstate[4]), .B(N1299), .Z(N1300) );
  GTECH_OR2 C3208 ( .A(itstate[3]), .B(N1300), .Z(N1301) );
  GTECH_OR2 C3209 ( .A(itstate[2]), .B(N1301), .Z(N1302) );
  GTECH_OR2 C3210 ( .A(itstate[1]), .B(N1302), .Z(N1303) );
  GTECH_OR2 C3211 ( .A(itstate[0]), .B(N1303), .Z(N1304) );
  GTECH_NOT I_46 ( .A(N1304), .Z(N1305) );
  GTECH_OR2 C3213 ( .A(itstate[6]), .B(itstate[7]), .Z(N1306) );
  GTECH_OR2 C3214 ( .A(itstate[5]), .B(N1306), .Z(N1307) );
  GTECH_OR2 C3215 ( .A(itstate[4]), .B(N1307), .Z(N1308) );
  GTECH_OR2 C3216 ( .A(itstate[3]), .B(N1308), .Z(N1309) );
  GTECH_OR2 C3217 ( .A(itstate[2]), .B(N1309), .Z(N1310) );
  GTECH_OR2 C3218 ( .A(itstate[1]), .B(N1310), .Z(N1311) );
  GTECH_OR2 C3219 ( .A(itstate[0]), .B(N1311), .Z(N1312) );
  GTECH_NOT I_47 ( .A(N1312), .Z(N1313) );
  GTECH_OR2 C3221 ( .A(itstate[6]), .B(itstate[7]), .Z(N1314) );
  GTECH_OR2 C3222 ( .A(itstate[5]), .B(N1314), .Z(N1315) );
  GTECH_OR2 C3223 ( .A(itstate[4]), .B(N1315), .Z(N1316) );
  GTECH_OR2 C3224 ( .A(itstate[3]), .B(N1316), .Z(N1317) );
  GTECH_OR2 C3225 ( .A(itstate[2]), .B(N1317), .Z(N1318) );
  GTECH_OR2 C3226 ( .A(itstate[1]), .B(N1318), .Z(N1319) );
  GTECH_OR2 C3227 ( .A(itstate[0]), .B(N1319), .Z(N1320) );
  GTECH_NOT I_48 ( .A(N1320), .Z(N1321) );
  GTECH_OR2 C3229 ( .A(itstate[6]), .B(itstate[7]), .Z(N1322) );
  GTECH_OR2 C3230 ( .A(itstate[5]), .B(N1322), .Z(N1323) );
  GTECH_OR2 C3231 ( .A(itstate[4]), .B(N1323), .Z(N1324) );
  GTECH_OR2 C3232 ( .A(itstate[3]), .B(N1324), .Z(N1325) );
  GTECH_OR2 C3233 ( .A(itstate[2]), .B(N1325), .Z(N1326) );
  GTECH_OR2 C3234 ( .A(itstate[1]), .B(N1326), .Z(N1327) );
  GTECH_OR2 C3235 ( .A(itstate[0]), .B(N1327), .Z(N1328) );
  GTECH_NOT I_49 ( .A(N1328), .Z(N1329) );
  GTECH_OR2 C3237 ( .A(itstate[6]), .B(itstate[7]), .Z(N1330) );
  GTECH_OR2 C3238 ( .A(itstate[5]), .B(N1330), .Z(N1331) );
  GTECH_OR2 C3239 ( .A(itstate[4]), .B(N1331), .Z(N1332) );
  GTECH_OR2 C3240 ( .A(itstate[3]), .B(N1332), .Z(N1333) );
  GTECH_OR2 C3241 ( .A(itstate[2]), .B(N1333), .Z(N1334) );
  GTECH_OR2 C3242 ( .A(itstate[1]), .B(N1334), .Z(N1335) );
  GTECH_OR2 C3243 ( .A(itstate[0]), .B(N1335), .Z(N1336) );
  GTECH_NOT I_50 ( .A(N1336), .Z(N1337) );
  GTECH_OR2 C3245 ( .A(itstate[6]), .B(itstate[7]), .Z(N1338) );
  GTECH_OR2 C3246 ( .A(itstate[5]), .B(N1338), .Z(N1339) );
  GTECH_OR2 C3247 ( .A(itstate[4]), .B(N1339), .Z(N1340) );
  GTECH_OR2 C3248 ( .A(itstate[3]), .B(N1340), .Z(N1341) );
  GTECH_OR2 C3249 ( .A(itstate[2]), .B(N1341), .Z(N1342) );
  GTECH_OR2 C3250 ( .A(itstate[1]), .B(N1342), .Z(N1343) );
  GTECH_OR2 C3251 ( .A(itstate[0]), .B(N1343), .Z(N1344) );
  GTECH_NOT I_51 ( .A(N1344), .Z(N1345) );
  GTECH_OR2 C3253 ( .A(itstate[6]), .B(itstate[7]), .Z(N1346) );
  GTECH_OR2 C3254 ( .A(itstate[5]), .B(N1346), .Z(N1347) );
  GTECH_OR2 C3255 ( .A(itstate[4]), .B(N1347), .Z(N1348) );
  GTECH_OR2 C3256 ( .A(itstate[3]), .B(N1348), .Z(N1349) );
  GTECH_OR2 C3257 ( .A(itstate[2]), .B(N1349), .Z(N1350) );
  GTECH_OR2 C3258 ( .A(itstate[1]), .B(N1350), .Z(N1351) );
  GTECH_OR2 C3259 ( .A(itstate[0]), .B(N1351), .Z(N1352) );
  GTECH_NOT I_52 ( .A(N1352), .Z(N1353) );
  GTECH_OR2 C3261 ( .A(itstate[6]), .B(itstate[7]), .Z(N1354) );
  GTECH_OR2 C3262 ( .A(itstate[5]), .B(N1354), .Z(N1355) );
  GTECH_OR2 C3263 ( .A(itstate[4]), .B(N1355), .Z(N1356) );
  GTECH_OR2 C3264 ( .A(itstate[3]), .B(N1356), .Z(N1357) );
  GTECH_OR2 C3265 ( .A(itstate[2]), .B(N1357), .Z(N1358) );
  GTECH_OR2 C3266 ( .A(itstate[1]), .B(N1358), .Z(N1359) );
  GTECH_OR2 C3267 ( .A(itstate[0]), .B(N1359), .Z(N1360) );
  GTECH_NOT I_53 ( .A(N1360), .Z(N1361) );
  GTECH_OR2 C3269 ( .A(itstate[6]), .B(itstate[7]), .Z(N1362) );
  GTECH_OR2 C3270 ( .A(itstate[5]), .B(N1362), .Z(N1363) );
  GTECH_OR2 C3271 ( .A(itstate[4]), .B(N1363), .Z(N1364) );
  GTECH_OR2 C3272 ( .A(itstate[3]), .B(N1364), .Z(N1365) );
  GTECH_OR2 C3273 ( .A(itstate[2]), .B(N1365), .Z(N1366) );
  GTECH_OR2 C3274 ( .A(itstate[1]), .B(N1366), .Z(N1367) );
  GTECH_OR2 C3275 ( .A(itstate[0]), .B(N1367), .Z(N1368) );
  GTECH_NOT I_54 ( .A(N1368), .Z(N1369) );
  GTECH_OR2 C3277 ( .A(itstate[6]), .B(itstate[7]), .Z(N1370) );
  GTECH_OR2 C3278 ( .A(itstate[5]), .B(N1370), .Z(N1371) );
  GTECH_OR2 C3279 ( .A(itstate[4]), .B(N1371), .Z(N1372) );
  GTECH_OR2 C3280 ( .A(itstate[3]), .B(N1372), .Z(N1373) );
  GTECH_OR2 C3281 ( .A(itstate[2]), .B(N1373), .Z(N1374) );
  GTECH_OR2 C3282 ( .A(itstate[1]), .B(N1374), .Z(N1375) );
  GTECH_OR2 C3283 ( .A(itstate[0]), .B(N1375), .Z(N1376) );
  GTECH_NOT I_55 ( .A(N1376), .Z(N1377) );
  GTECH_OR2 C3285 ( .A(itstate[6]), .B(itstate[7]), .Z(N1378) );
  GTECH_OR2 C3286 ( .A(itstate[5]), .B(N1378), .Z(N1379) );
  GTECH_OR2 C3287 ( .A(itstate[4]), .B(N1379), .Z(N1380) );
  GTECH_OR2 C3288 ( .A(itstate[3]), .B(N1380), .Z(N1381) );
  GTECH_OR2 C3289 ( .A(itstate[2]), .B(N1381), .Z(N1382) );
  GTECH_OR2 C3290 ( .A(itstate[1]), .B(N1382), .Z(N1383) );
  GTECH_OR2 C3291 ( .A(itstate[0]), .B(N1383), .Z(N1384) );
  GTECH_NOT I_56 ( .A(N1384), .Z(N1385) );
  GTECH_OR2 C3293 ( .A(itstate[6]), .B(itstate[7]), .Z(N1386) );
  GTECH_OR2 C3294 ( .A(itstate[5]), .B(N1386), .Z(N1387) );
  GTECH_OR2 C3295 ( .A(itstate[4]), .B(N1387), .Z(N1388) );
  GTECH_OR2 C3296 ( .A(itstate[3]), .B(N1388), .Z(N1389) );
  GTECH_OR2 C3297 ( .A(itstate[2]), .B(N1389), .Z(N1390) );
  GTECH_OR2 C3298 ( .A(itstate[1]), .B(N1390), .Z(N1391) );
  GTECH_OR2 C3299 ( .A(itstate[0]), .B(N1391), .Z(N1392) );
  GTECH_NOT I_57 ( .A(N1392), .Z(N1393) );
  GTECH_OR2 C3301 ( .A(itstate[6]), .B(itstate[7]), .Z(N1394) );
  GTECH_OR2 C3302 ( .A(itstate[5]), .B(N1394), .Z(N1395) );
  GTECH_OR2 C3303 ( .A(itstate[4]), .B(N1395), .Z(N1396) );
  GTECH_OR2 C3304 ( .A(itstate[3]), .B(N1396), .Z(N1397) );
  GTECH_OR2 C3305 ( .A(itstate[2]), .B(N1397), .Z(N1398) );
  GTECH_OR2 C3306 ( .A(itstate[1]), .B(N1398), .Z(N1399) );
  GTECH_OR2 C3307 ( .A(itstate[0]), .B(N1399), .Z(N1400) );
  GTECH_NOT I_58 ( .A(N1400), .Z(N1401) );
  GTECH_OR2 C3309 ( .A(itstate[6]), .B(itstate[7]), .Z(N1402) );
  GTECH_OR2 C3310 ( .A(itstate[5]), .B(N1402), .Z(N1403) );
  GTECH_OR2 C3311 ( .A(itstate[4]), .B(N1403), .Z(N1404) );
  GTECH_OR2 C3312 ( .A(itstate[3]), .B(N1404), .Z(N1405) );
  GTECH_OR2 C3313 ( .A(itstate[2]), .B(N1405), .Z(N1406) );
  GTECH_OR2 C3314 ( .A(itstate[1]), .B(N1406), .Z(N1407) );
  GTECH_OR2 C3315 ( .A(itstate[0]), .B(N1407), .Z(N1408) );
  GTECH_NOT I_59 ( .A(N1408), .Z(N1409) );
  GTECH_OR2 C3317 ( .A(itstate[6]), .B(itstate[7]), .Z(N1410) );
  GTECH_OR2 C3318 ( .A(itstate[5]), .B(N1410), .Z(N1411) );
  GTECH_OR2 C3319 ( .A(itstate[4]), .B(N1411), .Z(N1412) );
  GTECH_OR2 C3320 ( .A(itstate[3]), .B(N1412), .Z(N1413) );
  GTECH_OR2 C3321 ( .A(itstate[2]), .B(N1413), .Z(N1414) );
  GTECH_OR2 C3322 ( .A(itstate[1]), .B(N1414), .Z(N1415) );
  GTECH_OR2 C3323 ( .A(itstate[0]), .B(N1415), .Z(N1416) );
  GTECH_NOT I_60 ( .A(N1416), .Z(N1417) );
  GTECH_OR2 C3325 ( .A(itstate[6]), .B(itstate[7]), .Z(N1418) );
  GTECH_OR2 C3326 ( .A(itstate[5]), .B(N1418), .Z(N1419) );
  GTECH_OR2 C3327 ( .A(itstate[4]), .B(N1419), .Z(N1420) );
  GTECH_OR2 C3328 ( .A(itstate[3]), .B(N1420), .Z(N1421) );
  GTECH_OR2 C3329 ( .A(itstate[2]), .B(N1421), .Z(N1422) );
  GTECH_OR2 C3330 ( .A(itstate[1]), .B(N1422), .Z(N1423) );
  GTECH_OR2 C3331 ( .A(itstate[0]), .B(N1423), .Z(N1424) );
  GTECH_NOT I_61 ( .A(N1424), .Z(N1425) );
  GTECH_OR2 C3333 ( .A(itstate[6]), .B(itstate[7]), .Z(N1426) );
  GTECH_OR2 C3334 ( .A(itstate[5]), .B(N1426), .Z(N1427) );
  GTECH_OR2 C3335 ( .A(itstate[4]), .B(N1427), .Z(N1428) );
  GTECH_OR2 C3336 ( .A(itstate[3]), .B(N1428), .Z(N1429) );
  GTECH_OR2 C3337 ( .A(itstate[2]), .B(N1429), .Z(N1430) );
  GTECH_OR2 C3338 ( .A(itstate[1]), .B(N1430), .Z(N1431) );
  GTECH_OR2 C3339 ( .A(itstate[0]), .B(N1431), .Z(N1432) );
  GTECH_NOT I_62 ( .A(N1432), .Z(N1433) );
  GTECH_OR2 C3341 ( .A(itstate[6]), .B(itstate[7]), .Z(N1434) );
  GTECH_OR2 C3342 ( .A(itstate[5]), .B(N1434), .Z(N1435) );
  GTECH_OR2 C3343 ( .A(itstate[4]), .B(N1435), .Z(N1436) );
  GTECH_OR2 C3344 ( .A(itstate[3]), .B(N1436), .Z(N1437) );
  GTECH_OR2 C3345 ( .A(itstate[2]), .B(N1437), .Z(N1438) );
  GTECH_OR2 C3346 ( .A(itstate[1]), .B(N1438), .Z(N1439) );
  GTECH_OR2 C3347 ( .A(itstate[0]), .B(N1439), .Z(N1440) );
  GTECH_NOT I_63 ( .A(N1440), .Z(N1441) );
  GTECH_OR2 C3349 ( .A(itstate[6]), .B(itstate[7]), .Z(N1442) );
  GTECH_OR2 C3350 ( .A(itstate[5]), .B(N1442), .Z(N1443) );
  GTECH_OR2 C3351 ( .A(itstate[4]), .B(N1443), .Z(N1444) );
  GTECH_OR2 C3352 ( .A(itstate[3]), .B(N1444), .Z(N1445) );
  GTECH_OR2 C3353 ( .A(itstate[2]), .B(N1445), .Z(N1446) );
  GTECH_OR2 C3354 ( .A(itstate[1]), .B(N1446), .Z(N1447) );
  GTECH_OR2 C3355 ( .A(itstate[0]), .B(N1447), .Z(N1448) );
  GTECH_NOT I_64 ( .A(N1448), .Z(N1449) );
  GTECH_OR2 C3357 ( .A(itstate[6]), .B(itstate[7]), .Z(N1450) );
  GTECH_OR2 C3358 ( .A(itstate[5]), .B(N1450), .Z(N1451) );
  GTECH_OR2 C3359 ( .A(itstate[4]), .B(N1451), .Z(N1452) );
  GTECH_OR2 C3360 ( .A(itstate[3]), .B(N1452), .Z(N1453) );
  GTECH_OR2 C3361 ( .A(itstate[2]), .B(N1453), .Z(N1454) );
  GTECH_OR2 C3362 ( .A(itstate[1]), .B(N1454), .Z(N1455) );
  GTECH_OR2 C3363 ( .A(itstate[0]), .B(N1455), .Z(N1456) );
  GTECH_NOT I_65 ( .A(N1456), .Z(N1457) );
  GTECH_OR2 C3365 ( .A(itstate[6]), .B(itstate[7]), .Z(N1458) );
  GTECH_OR2 C3366 ( .A(itstate[5]), .B(N1458), .Z(N1459) );
  GTECH_OR2 C3367 ( .A(itstate[4]), .B(N1459), .Z(N1460) );
  GTECH_OR2 C3368 ( .A(itstate[3]), .B(N1460), .Z(N1461) );
  GTECH_OR2 C3369 ( .A(itstate[2]), .B(N1461), .Z(N1462) );
  GTECH_OR2 C3370 ( .A(itstate[1]), .B(N1462), .Z(N1463) );
  GTECH_OR2 C3371 ( .A(itstate[0]), .B(N1463), .Z(N1464) );
  GTECH_NOT I_66 ( .A(N1464), .Z(N1465) );
  GTECH_OR2 C3373 ( .A(itstate[6]), .B(itstate[7]), .Z(N1466) );
  GTECH_OR2 C3374 ( .A(itstate[5]), .B(N1466), .Z(N1467) );
  GTECH_OR2 C3375 ( .A(itstate[4]), .B(N1467), .Z(N1468) );
  GTECH_OR2 C3376 ( .A(itstate[3]), .B(N1468), .Z(N1469) );
  GTECH_OR2 C3377 ( .A(itstate[2]), .B(N1469), .Z(N1470) );
  GTECH_OR2 C3378 ( .A(itstate[1]), .B(N1470), .Z(N1471) );
  GTECH_OR2 C3379 ( .A(itstate[0]), .B(N1471), .Z(N1472) );
  GTECH_NOT I_67 ( .A(N1472), .Z(N1473) );
  GTECH_OR2 C3381 ( .A(itstate[6]), .B(itstate[7]), .Z(N1474) );
  GTECH_OR2 C3382 ( .A(itstate[5]), .B(N1474), .Z(N1475) );
  GTECH_OR2 C3383 ( .A(itstate[4]), .B(N1475), .Z(N1476) );
  GTECH_OR2 C3384 ( .A(itstate[3]), .B(N1476), .Z(N1477) );
  GTECH_OR2 C3385 ( .A(itstate[2]), .B(N1477), .Z(N1478) );
  GTECH_OR2 C3386 ( .A(itstate[1]), .B(N1478), .Z(N1479) );
  GTECH_OR2 C3387 ( .A(itstate[0]), .B(N1479), .Z(N1480) );
  GTECH_NOT I_68 ( .A(N1480), .Z(N1481) );
  GTECH_OR2 C3389 ( .A(itstate[6]), .B(itstate[7]), .Z(N1482) );
  GTECH_OR2 C3390 ( .A(itstate[5]), .B(N1482), .Z(N1483) );
  GTECH_OR2 C3391 ( .A(itstate[4]), .B(N1483), .Z(N1484) );
  GTECH_OR2 C3392 ( .A(itstate[3]), .B(N1484), .Z(N1485) );
  GTECH_OR2 C3393 ( .A(itstate[2]), .B(N1485), .Z(N1486) );
  GTECH_OR2 C3394 ( .A(itstate[1]), .B(N1486), .Z(N1487) );
  GTECH_OR2 C3395 ( .A(itstate[0]), .B(N1487), .Z(N1488) );
  GTECH_NOT I_69 ( .A(N1488), .Z(N1489) );
  GTECH_OR2 C3397 ( .A(itstate[6]), .B(itstate[7]), .Z(N1490) );
  GTECH_OR2 C3398 ( .A(itstate[5]), .B(N1490), .Z(N1491) );
  GTECH_OR2 C3399 ( .A(itstate[4]), .B(N1491), .Z(N1492) );
  GTECH_OR2 C3400 ( .A(itstate[3]), .B(N1492), .Z(N1493) );
  GTECH_OR2 C3401 ( .A(itstate[2]), .B(N1493), .Z(N1494) );
  GTECH_OR2 C3402 ( .A(itstate[1]), .B(N1494), .Z(N1495) );
  GTECH_OR2 C3403 ( .A(itstate[0]), .B(N1495), .Z(N1496) );
  GTECH_NOT I_70 ( .A(N1496), .Z(N1497) );
  GTECH_OR2 C3405 ( .A(itstate[6]), .B(itstate[7]), .Z(N1498) );
  GTECH_OR2 C3406 ( .A(itstate[5]), .B(N1498), .Z(N1499) );
  GTECH_OR2 C3407 ( .A(itstate[4]), .B(N1499), .Z(N1500) );
  GTECH_OR2 C3408 ( .A(itstate[3]), .B(N1500), .Z(N1501) );
  GTECH_OR2 C3409 ( .A(itstate[2]), .B(N1501), .Z(N1502) );
  GTECH_OR2 C3410 ( .A(itstate[1]), .B(N1502), .Z(N1503) );
  GTECH_OR2 C3411 ( .A(itstate[0]), .B(N1503), .Z(N1504) );
  GTECH_NOT I_71 ( .A(N1504), .Z(N1505) );
  GTECH_OR5 C3413 ( .A(N289), .B(N291), .C(N295), .D(N300), .E(N308), .Z(N1506) );
  GTECH_OR5 C3414 ( .A(N312), .B(N314), .C(N316), .D(N321), .E(N323), .Z(N1507) );
  GTECH_OR4 C3415 ( .A(N326), .B(N335), .C(N179), .D(N350), .Z(N1508) );
  GTECH_OR3 C3416 ( .A(N1506), .B(N1507), .C(N1508), .Z(N1509) );
  GTECH_OR3 C3417 ( .A(N304), .B(N318), .C(N320), .Z(N1510) );
  GTECH_OR5 C3419 ( .A(N289), .B(N291), .C(N295), .D(N300), .E(N304), .Z(N1511) );
  GTECH_OR5 C3420 ( .A(N308), .B(N312), .C(N314), .D(N316), .E(N318), .Z(N1512) );
  GTECH_OR5 C3421 ( .A(N320), .B(N321), .C(N323), .D(N326), .E(N335), .Z(N1513) );
  GTECH_OR2 C3422 ( .A(N179), .B(N350), .Z(N1514) );
  GTECH_OR4 C3423 ( .A(N1511), .B(N1512), .C(N1513), .D(N1514), .Z(N1515) );
  GTECH_OR5 C3433 ( .A(N320), .B(N321), .C(N323), .D(N326), .E(N333), .Z(N1516) );
  GTECH_OR4 C3435 ( .A(N1511), .B(N1512), .C(N1516), .D(N1514), .Z(N1517) );
  GTECH_OR3 C3500 ( .A(N335), .B(N179), .C(N350), .Z(N1518) );
  GTECH_OR4 C3501 ( .A(N1511), .B(N1512), .C(N1516), .D(N1518), .Z(N1519) );
  GTECH_OR5 C3552 ( .A(N318), .B(N320), .C(N321), .D(N323), .E(N326), .Z(N1520) );
  GTECH_OR5 C3553 ( .A(N329), .B(N333), .C(N335), .D(N179), .E(N350), .Z(N1521) );
  GTECH_OR3 C3554 ( .A(N1511), .B(N1520), .C(N1521), .Z(N1522) );
  GTECH_OR2 C3555 ( .A(N312), .B(N316), .Z(N1523) );
  GTECH_OR3 C3557 ( .A(N351), .B(N353), .C(N355), .Z(N1524) );
  GTECH_OR2 C3577 ( .A(N351), .B(N355), .Z(N1525) );
  GTECH_OR2 C3579 ( .A(N351), .B(N353), .Z(N385) );
  GTECH_OR2 C3582 ( .A(N355), .B(N356), .Z(N375) );
  GTECH_OR3 C3586 ( .A(N353), .B(N355), .C(N356), .Z(N1526) );
  GTECH_OR2 C3599 ( .A(N353), .B(N356), .Z(N383) );
  GTECH_OR3 C3601 ( .A(N351), .B(N355), .C(N356), .Z(N384) );
  GTECH_OR2 C3621 ( .A(N722), .B(N443), .Z(N1527) );
  GTECH_OR2 C3622 ( .A(N444), .B(N176), .Z(N449) );
  GTECH_OR3 C3636 ( .A(N443), .B(N444), .C(N176), .Z(N451) );
  GTECH_OR3 C3638 ( .A(N722), .B(N444), .C(N176), .Z(N450) );
  GTECH_OR2 C3646 ( .A(N722), .B(N444), .Z(N1528) );
  GTECH_OR2 C3647 ( .A(N443), .B(N176), .Z(N1529) );
  GTECH_OR5 C3669 ( .A(N291), .B(N304), .C(N314), .D(N316), .E(N318), .Z(N1530) );
  GTECH_OR5 C3670 ( .A(N320), .B(N321), .C(N323), .D(N326), .E(N329), .Z(N1531) );
  GTECH_OR4 C3671 ( .A(N333), .B(N335), .C(N179), .D(N350), .Z(N1532) );
  GTECH_OR3 C3672 ( .A(N1530), .B(N1531), .C(N1532), .Z(N1533) );
  GTECH_OR2 C3673 ( .A(N295), .B(N300), .Z(N1534) );
  GTECH_OR2 C3674 ( .A(N308), .B(N312), .Z(N1535) );
  GTECH_OR2 C3678 ( .A(N333), .B(N335), .Z(N1536) );
  GTECH_OR3 C3679 ( .A(N1530), .B(N1531), .C(N1536), .Z(N1537) );
  GTECH_OR3 C3695 ( .A(N295), .B(N308), .C(N312), .Z(N1538) );
  GTECH_OR4 C3701 ( .A(N295), .B(N300), .C(N308), .D(N312), .Z(N1539) );
  GTECH_OR5 C3703 ( .A(N295), .B(N300), .C(N304), .D(N308), .E(N312), .Z(N1540) );
  GTECH_OR5 C3704 ( .A(N314), .B(N316), .C(N318), .D(N320), .E(N321), .Z(N1541) );
  GTECH_OR5 C3705 ( .A(N323), .B(N326), .C(N329), .D(N333), .E(N335), .Z(N1542) );
  GTECH_OR4 C3707 ( .A(N1540), .B(N1541), .C(N1542), .D(N1514), .Z(N1543) );
  GTECH_OR5 C3710 ( .A(N314), .B(N318), .C(N320), .D(N321), .E(N179), .Z(N1544) );
  GTECH_OR3 C3711 ( .A(N1540), .B(N1544), .C(N350), .Z(N1545) );
  GTECH_OR2 C3712 ( .A(N323), .B(N326), .Z(N1546) );
  GTECH_OR2 C3713 ( .A(N329), .B(N333), .Z(N1547) );
  GTECH_OR5 C3715 ( .A(N295), .B(N300), .C(N308), .D(N312), .E(N323), .Z(N1548) );
  GTECH_OR2 C3717 ( .A(N1548), .B(N1508), .Z(N1549) );
  GTECH_OR4 C3718 ( .A(N304), .B(N318), .C(N320), .D(N321), .Z(N1550) );
  GTECH_OR5 C3733 ( .A(N289), .B(N308), .C(N312), .D(N314), .E(N316), .Z(N1551) );
  GTECH_OR5 C3734 ( .A(N304), .B(N318), .C(N320), .D(N321), .E(N323), .Z(N1552) );
  GTECH_OR2 C3736 ( .A(N1552), .B(N1521), .Z(N1553) );
  GTECH_OR4 C3739 ( .A(N304), .B(N329), .C(N333), .D(N335), .Z(N1554) );
  GTECH_OR5 C3740 ( .A(N318), .B(N321), .C(N323), .D(N179), .E(N350), .Z(N1555) );
  GTECH_OR5 C3747 ( .A(N289), .B(N295), .C(N308), .D(N312), .E(N314), .Z(N1556) );
  GTECH_OR2 C3748 ( .A(N316), .B(N326), .Z(N1557) );
  GTECH_OR2 C3749 ( .A(N1556), .B(N1557), .Z(N1558) );
  GTECH_OR5 C3754 ( .A(N289), .B(N295), .C(N304), .D(N308), .E(N312), .Z(N1559) );
  GTECH_OR3 C3757 ( .A(N1559), .B(N1541), .C(N1542), .Z(N1560) );
  GTECH_OR3 C3760 ( .A(N295), .B(N179), .C(N350), .Z(N1561) );
  GTECH_OR5 C3761 ( .A(N304), .B(N308), .C(N312), .D(N314), .E(N316), .Z(N1562) );
  GTECH_OR5 C3762 ( .A(N318), .B(N320), .C(N321), .D(N326), .E(N329), .Z(N1563) );
  GTECH_OR3 C3764 ( .A(N1562), .B(N1563), .C(N1536), .Z(N1564) );
  GTECH_OR5 C3769 ( .A(N398), .B(N402), .C(N406), .D(N410), .E(N415), .Z(N1565) );
  GTECH_OR3 C3770 ( .A(N421), .B(N425), .C(N429), .Z(N1566) );
  GTECH_OR2 C3771 ( .A(N1565), .B(N1566), .Z(N430) );
  GTECH_OR5 C3776 ( .A(N400), .B(N402), .C(N408), .D(N410), .E(N418), .Z(N1567) );
  GTECH_OR3 C3777 ( .A(N421), .B(N427), .C(N429), .Z(N1568) );
  GTECH_OR2 C3778 ( .A(N1567), .B(N1568), .Z(N431) );
  GTECH_OR5 C3783 ( .A(N404), .B(N406), .C(N408), .D(N410), .E(N423), .Z(N1569) );
  GTECH_OR3 C3784 ( .A(N425), .B(N427), .C(N429), .Z(N1570) );
  GTECH_OR2 C3785 ( .A(N1569), .B(N1570), .Z(N432) );
  GTECH_OR5 C3787 ( .A(N395), .B(N398), .C(N400), .D(N402), .E(N404), .Z(N1571) );
  GTECH_OR5 C3790 ( .A(N413), .B(N415), .C(N418), .D(N421), .E(N423), .Z(N1572) );
  GTECH_OR2 C3792 ( .A(N1572), .B(N1570), .Z(N433) );
  GTECH_OR5 C3795 ( .A(N406), .B(N408), .C(N410), .D(N415), .E(N423), .Z(N1573) );
  GTECH_OR3 C3797 ( .A(N1571), .B(N1573), .C(N1570), .Z(N438) );
  GTECH_OR3 C3798 ( .A(N413), .B(N418), .C(N421), .Z(N437) );
  GTECH_OR5 C3831 ( .A(N318), .B(N320), .C(N326), .D(N329), .E(N333), .Z(N1574) );
  GTECH_OR2 C3832 ( .A(N1562), .B(N1574), .Z(N1575) );
  GTECH_OR3 C3838 ( .A(N1562), .B(N1574), .C(N1514), .Z(N1576) );
  GTECH_OR3 C3843 ( .A(N1562), .B(N1520), .C(N1521), .Z(N1577) );
  GTECH_OR5 C3845 ( .A(N289), .B(N304), .C(N308), .D(N312), .E(N314), .Z(N1578) );
  GTECH_OR5 C3846 ( .A(N316), .B(N318), .C(N320), .D(N321), .E(N326), .Z(N1579) );
  GTECH_OR3 C3847 ( .A(N329), .B(N333), .C(N335), .Z(N1580) );
  GTECH_OR3 C3848 ( .A(N1578), .B(N1579), .C(N1580), .Z(N1581) );
  GTECH_OR5 C3852 ( .A(N318), .B(N321), .C(N323), .D(N329), .E(N333), .Z(N1582) );
  GTECH_OR3 C3854 ( .A(N1562), .B(N1582), .C(N1514), .Z(N1583) );
  GTECH_OR2 C3855 ( .A(N320), .B(N326), .Z(N1584) );
  GTECH_OR2 C3859 ( .A(N1562), .B(N1555), .Z(N1585) );
  GTECH_OR3 C3866 ( .A(N1562), .B(N1582), .C(N1518), .Z(N1586) );
  GTECH_OR3 C3869 ( .A(N289), .B(N320), .C(N326), .Z(N1587) );
  GTECH_OR5 C3875 ( .A(N289), .B(N320), .C(N321), .D(N323), .E(N326), .Z(N1588) );
  GTECH_OR2 C3877 ( .A(N1588), .B(N1547), .Z(N1589) );
  GTECH_OR3 C3879 ( .A(N318), .B(N179), .C(N350), .Z(N1590) );
  GTECH_OR2 C3880 ( .A(N1562), .B(N1590), .Z(N1591) );
  GTECH_OR2 C3882 ( .A(N759), .B(N178), .Z(N1592) );
  GTECH_OR2 C3886 ( .A(N1588), .B(N1536), .Z(N1593) );
  GTECH_OR5 C3895 ( .A(N395), .B(N413), .C(N423), .D(N425), .E(N427), .Z(N1594) );
  GTECH_OR2 C3896 ( .A(N1594), .B(N429), .Z(N1595) );
  GTECH_OR2 C3897 ( .A(N418), .B(N421), .Z(N1596) );
  GTECH_OR5 C3902 ( .A(N410), .B(N413), .C(N423), .D(N425), .E(N427), .Z(N1597) );
  GTECH_OR3 C3903 ( .A(N1571), .B(N1597), .C(N429), .Z(N1598) );
  GTECH_OR2 C3926 ( .A(itstate[6]), .B(itstate[7]), .Z(N1599) );
  GTECH_OR2 C3927 ( .A(itstate[5]), .B(N1599), .Z(N1600) );
  GTECH_OR2 C3928 ( .A(itstate[4]), .B(N1600), .Z(N1601) );
  GTECH_OR2 C3929 ( .A(itstate[3]), .B(N1601), .Z(N1602) );
  GTECH_OR2 C3930 ( .A(itstate[2]), .B(N1602), .Z(N1603) );
  GTECH_OR2 C3931 ( .A(itstate[1]), .B(N1603), .Z(N1604) );
  GTECH_OR2 C3932 ( .A(itstate[0]), .B(N1604), .Z(N1605) );
  GTECH_NOT I_72 ( .A(N1605), .Z(N1606) );
  GTECH_OR3 C3934 ( .A(N463), .B(N464), .C(N175), .Z(N471) );
  GTECH_OR3 C3956 ( .A(N721), .B(N463), .C(N175), .Z(N472) );
  GTECH_OR2 C3959 ( .A(N464), .B(N175), .Z(N473) );
  GTECH_OR5 C3961 ( .A(N505), .B(N928), .C(N930), .D(N932), .E(N934), .Z(N1607) );
  GTECH_OR5 C3962 ( .A(N936), .B(N938), .C(N940), .D(N942), .E(N944), .Z(N1608) );
  GTECH_OR5 C3963 ( .A(N947), .B(N950), .C(N953), .D(N956), .E(N959), .Z(N1609) );
  GTECH_OR2 C3964 ( .A(N962), .B(N965), .Z(N1610) );
  GTECH_OR4 C3965 ( .A(N1607), .B(N1608), .C(N1609), .D(N1610), .Z(N615) );
  GTECH_OR5 C3973 ( .A(N928), .B(N932), .C(N936), .D(N940), .E(N942), .Z(N1611) );
  GTECH_OR5 C3974 ( .A(N947), .B(N953), .C(N959), .D(N965), .E(N614), .Z(N1612) );
  GTECH_OR2 C3975 ( .A(N1611), .B(N1612), .Z(N1613) );
  GTECH_OR5 C3977 ( .A(N505), .B(N928), .C(N934), .D(N936), .E(N944), .Z(N1614) );
  GTECH_OR4 C3978 ( .A(N947), .B(N956), .C(N959), .D(N614), .Z(N1615) );
  GTECH_OR2 C3979 ( .A(N1614), .B(N1615), .Z(N1616) );
  GTECH_OR5 C3981 ( .A(N934), .B(N936), .C(N938), .D(N940), .E(N942), .Z(N1617) );
  GTECH_OR5 C3982 ( .A(N956), .B(N959), .C(N962), .D(N965), .E(N614), .Z(N1618) );
  GTECH_OR2 C3983 ( .A(N1617), .B(N1618), .Z(N1619) );
  GTECH_OR2 C3985 ( .A(N942), .B(N614), .Z(N1620) );
  GTECH_OR5 C3987 ( .A(N928), .B(N932), .C(N936), .D(N940), .E(N947), .Z(N1621) );
  GTECH_OR4 C3988 ( .A(N953), .B(N959), .C(N965), .D(N614), .Z(N1622) );
  GTECH_OR2 C3989 ( .A(N1621), .B(N1622), .Z(N1623) );
  GTECH_OR5 C4001 ( .A(N968), .B(N972), .C(N976), .D(N980), .E(N984), .Z(N1624) );
  GTECH_OR3 C4002 ( .A(N990), .B(N996), .C(N1002), .Z(N1625) );
  GTECH_OR2 C4003 ( .A(N1624), .B(N1625), .Z(N1626) );
  GTECH_OR5 C4005 ( .A(N634), .B(N968), .C(N974), .D(N976), .E(N982), .Z(N1627) );
  GTECH_OR4 C4006 ( .A(N984), .B(N993), .C(N996), .D(N1002), .Z(N1628) );
  GTECH_OR2 C4007 ( .A(N1627), .B(N1628), .Z(N1629) );
  GTECH_OR5 C4009 ( .A(N974), .B(N976), .C(N978), .D(N980), .E(N993), .Z(N1630) );
  GTECH_OR3 C4010 ( .A(N996), .B(N999), .C(N1002), .Z(N1631) );
  GTECH_OR2 C4011 ( .A(N1630), .B(N1631), .Z(N1632) );
  GTECH_OR5 C4025 ( .A(N289), .B(N291), .C(N295), .D(N300), .E(N308), .Z(N1633) );
  GTECH_OR5 C4027 ( .A(N321), .B(N323), .C(N326), .D(N329), .E(N333), .Z(N1634) );
  GTECH_OR3 C4028 ( .A(N335), .B(N179), .C(N350), .Z(N1635) );
  GTECH_OR5 C4031 ( .A(N289), .B(N291), .C(N295), .D(N300), .E(N320), .Z(N1636) );
  GTECH_OR5 C4032 ( .A(N321), .B(N329), .C(N333), .D(N335), .E(N179), .Z(N1637) );
  GTECH_OR3 C4033 ( .A(N1636), .B(N1637), .C(N350), .Z(N1638) );
  GTECH_OR5 C4055 ( .A(N289), .B(N291), .C(N295), .D(N300), .E(N304), .Z(N1639) );
  GTECH_OR5 C4056 ( .A(N320), .B(N321), .C(N329), .D(N333), .E(N335), .Z(N1640) );
  GTECH_OR2 C4057 ( .A(N179), .B(N350), .Z(N1641) );
  GTECH_OR3 C4058 ( .A(N1639), .B(N1640), .C(N1641), .Z(N1642) );
  GTECH_OR5 C4081 ( .A(N308), .B(N312), .C(N314), .D(N316), .E(N318), .Z(N1643) );
  GTECH_OR5 C4082 ( .A(N320), .B(N321), .C(N323), .D(N329), .E(N333), .Z(N1644) );
  GTECH_OR4 C4084 ( .A(N1639), .B(N1643), .C(N1644), .D(N1635), .Z(N808) );
  GTECH_OR4 C4108 ( .A(N1639), .B(N1643), .C(N1640), .D(N1641), .Z(N809) );
  GTECH_OR5 C4118 ( .A(N308), .B(N314), .C(N318), .D(N320), .E(N321), .Z(N1645) );
  GTECH_OR5 C4119 ( .A(N323), .B(N326), .C(N329), .D(N333), .E(N335), .Z(N1646) );
  GTECH_OR4 C4121 ( .A(N1639), .B(N1645), .C(N1646), .D(N1641), .Z(N1647) );
  GTECH_OR5 C4124 ( .A(N308), .B(N314), .C(N316), .D(N318), .E(N320), .Z(N1648) );
  GTECH_OR4 C4127 ( .A(N1639), .B(N1648), .C(N1634), .D(N1635), .Z(N1649) );
  GTECH_OR5 C4129 ( .A(N289), .B(N295), .C(N300), .D(N308), .E(N312), .Z(N1650) );
  GTECH_OR5 C4130 ( .A(N323), .B(N326), .C(N335), .D(N179), .E(N350), .Z(N1651) );
  GTECH_OR2 C4131 ( .A(N1650), .B(N1651), .Z(N1652) );
  GTECH_OR4 C4132 ( .A(N304), .B(N318), .C(N320), .D(N321), .Z(N1653) );
  GTECH_OR2 C4133 ( .A(N329), .B(N333), .Z(N1654) );
  GTECH_OR5 C4136 ( .A(N316), .B(N323), .C(N326), .D(N335), .E(N179), .Z(N1655) );
  GTECH_OR3 C4137 ( .A(N1650), .B(N1655), .C(N350), .Z(N1656) );
  GTECH_OR5 C4142 ( .A(N314), .B(N316), .C(N323), .D(N326), .E(N335), .Z(N1657) );
  GTECH_OR3 C4144 ( .A(N1650), .B(N1657), .C(N1641), .Z(N1658) );
  GTECH_OR5 C4149 ( .A(N312), .B(N314), .C(N316), .D(N323), .E(N326), .Z(N1659) );
  GTECH_OR3 C4151 ( .A(N1633), .B(N1659), .C(N1635), .Z(N1660) );
  GTECH_OR2 C4155 ( .A(reset), .B(N216), .Z(N1661) );
  GTECH_OR3 C4165 ( .A(N213), .B(reset), .C(N216), .Z(N1662) );
  GTECH_OR3 C4179 ( .A(N212), .B(reset), .C(N216), .Z(N1663) );
  SELECT_OP C4375 ( .DATA1(itstate), .DATA2(instruction[7:0]), .CONTROL1(N0), 
        .CONTROL2(N188), .Z({N196, N195, N194, N193, N192, N191, N190, N189})
         );
  GTECH_BUF B_0 ( .A(N187), .Z(N0) );
  SELECT_OP C4376 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), 
        .DATA2({itstate[7:5], itstate[3:0]}), .CONTROL1(N1), .CONTROL2(N2), 
        .Z({N203, N202, N201, N200, N199, N198, N197}) );
  GTECH_BUF B_1 ( .A(N1025), .Z(N1) );
  GTECH_BUF B_2 ( .A(N1024), .Z(N2) );
  SELECT_OP C4377 ( .DATA1({N196, N195, N194, N193, N192, N191, N190, N189}), 
        .DATA2({N203, N202, N201, N200, N199, N198, N197, 1'b0}), .CONTROL1(N3), .CONTROL2(N180), .Z({N211, N210, N209, N208, N207, N206, N205, N204}) );
  GTECH_BUF B_3 ( .A(N179), .Z(N3) );
  SELECT_OP C4378 ( .DATA1({N211, N210, N209, N208, N207, N206, N205, N204}), 
        .DATA2({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA3(
        itstate), .CONTROL1(N4), .CONTROL2(N5), .CONTROL3(N171), .Z(
        next_itstate) );
  GTECH_BUF B_4 ( .A(N169), .Z(N4) );
  GTECH_BUF B_5 ( .A(reset), .Z(N5) );
  SELECT_OP C4379 ( .DATA1(flag_z), .DATA2(N760), .DATA3(flag_c), .DATA4(N761), 
        .DATA5(flag_n), .DATA6(N762), .DATA7(flag_v), .DATA8(N763), .DATA9(
        N764), .DATA10(N765), .DATA11(N766), .DATA12(N767), .DATA13(N768), 
        .DATA14(N769), .DATA15(1'b1), .DATA16(1'b0), .CONTROL1(N6), .CONTROL2(
        N7), .CONTROL3(N8), .CONTROL4(N9), .CONTROL5(N10), .CONTROL6(N11), 
        .CONTROL7(N12), .CONTROL8(N13), .CONTROL9(N14), .CONTROL10(N15), 
        .CONTROL11(N16), .CONTROL12(N17), .CONTROL13(N18), .CONTROL14(N19), 
        .CONTROL15(N20), .CONTROL16(N21), .Z(N283) );
  GTECH_BUF B_6 ( .A(N223), .Z(N6) );
  GTECH_BUF B_7 ( .A(N227), .Z(N7) );
  GTECH_BUF B_8 ( .A(N231), .Z(N8) );
  GTECH_BUF B_9 ( .A(N235), .Z(N9) );
  GTECH_BUF B_10 ( .A(N239), .Z(N10) );
  GTECH_BUF B_11 ( .A(N243), .Z(N11) );
  GTECH_BUF B_12 ( .A(N247), .Z(N12) );
  GTECH_BUF B_13 ( .A(N251), .Z(N13) );
  GTECH_BUF B_14 ( .A(N255), .Z(N14) );
  GTECH_BUF B_15 ( .A(N259), .Z(N15) );
  GTECH_BUF B_16 ( .A(N263), .Z(N16) );
  GTECH_BUF B_17 ( .A(N267), .Z(N17) );
  GTECH_BUF B_18 ( .A(N271), .Z(N18) );
  GTECH_BUF B_19 ( .A(N275), .Z(N19) );
  GTECH_BUF B_20 ( .A(N279), .Z(N20) );
  GTECH_BUF B_21 ( .A(N282), .Z(N21) );
  SELECT_OP C4380 ( .DATA1(instruction[8:6]), .DATA2({1'b1, 1'b1, 1'b1}), 
        .CONTROL1(N22), .CONTROL2(N23), .Z({N359, N358, N357}) );
  GTECH_BUF B_22 ( .A(N462), .Z(N22) );
  GTECH_BUF B_23 ( .A(instruction[10]), .Z(N23) );
  SELECT_OP C4381 ( .DATA1({1'b0, 1'b0, 1'b0}), .DATA2(instruction[8:6]), 
        .CONTROL1(N22), .CONTROL2(N23), .Z({N362, N361, N360}) );
  SELECT_OP C4382 ( .DATA1({1'b1, 1'b1, 1'b1, 1'b1}), .DATA2({instruction[10], 
        N359, N358, N357}), .CONTROL1(N24), .CONTROL2(N25), .Z({N367, N366, 
        N365, N364}) );
  GTECH_BUF B_24 ( .A(N1524), .Z(N24) );
  GTECH_BUF B_25 ( .A(N356), .Z(N25) );
  SELECT_OP C4383 ( .DATA1(instruction[10:6]), .DATA2({1'b0, 1'b0, N362, N361, 
        N360}), .CONTROL1(N24), .CONTROL2(N25), .Z({N372, N371, N370, N369, 
        N368}) );
  SELECT_OP C4384 ( .DATA1(1'b0), .DATA2(1'b1), .DATA3(N363), .CONTROL1(N26), 
        .CONTROL2(N27), .CONTROL3(N25), .Z(N373) );
  GTECH_BUF B_26 ( .A(N1525), .Z(N26) );
  GTECH_BUF B_27 ( .A(N353), .Z(N27) );
  SELECT_OP C4385 ( .DATA1(1'b1), .DATA2(1'b0), .DATA3(instruction[9]), 
        .CONTROL1(N28), .CONTROL2(N29), .CONTROL3(N25), .Z(N374) );
  GTECH_BUF B_28 ( .A(N385), .Z(N28) );
  GTECH_BUF B_29 ( .A(N355), .Z(N29) );
  SELECT_OP C4386 ( .DATA1(N1033), .DATA2(N1041), .DATA3(N1049), .DATA4(N1057), 
        .CONTROL1(N30), .CONTROL2(N27), .CONTROL3(N29), .CONTROL4(N25), .Z(
        N376) );
  GTECH_BUF B_30 ( .A(N351), .Z(N30) );
  SELECT_OP C4387 ( .DATA1(N1193), .DATA2(N1201), .DATA3(N1209), .DATA4(N1217), 
        .CONTROL1(N30), .CONTROL2(N27), .CONTROL3(N29), .CONTROL4(N25), .Z(
        N377) );
  SELECT_OP C4388 ( .DATA1(N1353), .DATA2(N1361), .DATA3(N1369), .DATA4(N1377), 
        .CONTROL1(N30), .CONTROL2(N27), .CONTROL3(N29), .CONTROL4(N25), .Z(
        N378) );
  SELECT_OP C4389 ( .DATA1(1'b0), .DATA2(N1465), .CONTROL1(N24), .CONTROL2(N25), .Z(N379) );
  SELECT_OP C4390 ( .DATA1({1'b1, 1'b1, 1'b1}), .DATA2(instruction[10:8]), 
        .CONTROL1(N30), .CONTROL2(N31), .Z({N382, N381, N380}) );
  GTECH_BUF B_31 ( .A(N1526), .Z(N31) );
  SELECT_OP C4391 ( .DATA1(instruction[10:8]), .DATA2({1'b1, 1'b0, 1'b1}), 
        .CONTROL1(N32), .CONTROL2(N27), .Z({N388, N387, N386}) );
  GTECH_BUF B_32 ( .A(N384), .Z(N32) );
  SELECT_OP C4392 ( .DATA1(N1065), .DATA2(1'b1), .DATA3(N1073), .DATA4(N1081), 
        .CONTROL1(N30), .CONTROL2(N27), .CONTROL3(N29), .CONTROL4(N25), .Z(
        N389) );
  SELECT_OP C4393 ( .DATA1(N1225), .DATA2(1'b1), .DATA3(N1233), .DATA4(N1241), 
        .CONTROL1(N30), .CONTROL2(N27), .CONTROL3(N29), .CONTROL4(N25), .Z(
        N390) );
  SELECT_OP C4394 ( .DATA1(1'b0), .DATA2(1'b1), .DATA3(N1385), .DATA4(N1393), 
        .CONTROL1(N30), .CONTROL2(N27), .CONTROL3(N29), .CONTROL4(N25), .Z(
        N391) );
  SELECT_OP C4395 ( .DATA1(1'b0), .DATA2(1'b1), .DATA3(N1473), .DATA4(N1481), 
        .CONTROL1(N30), .CONTROL2(N27), .CONTROL3(N29), .CONTROL4(N25), .Z(
        N392) );
  SELECT_OP C4396 ( .DATA1(instruction[2:0]), .DATA2({1'b1, 1'b0, 1'b1}), 
        .CONTROL1(N33), .CONTROL2(N34), .Z({N436, N435, N434}) );
  GTECH_BUF B_33 ( .A(N438), .Z(N33) );
  GTECH_BUF B_34 ( .A(N437), .Z(N34) );
  SELECT_OP C4397 ( .DATA1(N1089), .DATA2(N1097), .DATA3(N1105), .DATA4(N1113), 
        .DATA5(N1121), .DATA6(N1129), .DATA7(N1137), .DATA8(N1145), .DATA9(
        1'b1), .DATA10(N1153), .DATA11(N1161), .DATA12(N1169), .DATA13(N1177), 
        .DATA14(N1185), .CONTROL1(N35), .CONTROL2(N36), .CONTROL3(N37), 
        .CONTROL4(N38), .CONTROL5(N39), .CONTROL6(N40), .CONTROL7(N41), 
        .CONTROL8(N42), .CONTROL9(N34), .CONTROL10(N43), .CONTROL11(N44), 
        .CONTROL12(N45), .CONTROL13(N46), .CONTROL14(N47), .Z(N439) );
  GTECH_BUF B_35 ( .A(N395), .Z(N35) );
  GTECH_BUF B_36 ( .A(N398), .Z(N36) );
  GTECH_BUF B_37 ( .A(N400), .Z(N37) );
  GTECH_BUF B_38 ( .A(N402), .Z(N38) );
  GTECH_BUF B_39 ( .A(N404), .Z(N39) );
  GTECH_BUF B_40 ( .A(N406), .Z(N40) );
  GTECH_BUF B_41 ( .A(N408), .Z(N41) );
  GTECH_BUF B_42 ( .A(N410), .Z(N42) );
  GTECH_BUF B_43 ( .A(N415), .Z(N43) );
  GTECH_BUF B_44 ( .A(N423), .Z(N44) );
  GTECH_BUF B_45 ( .A(N425), .Z(N45) );
  GTECH_BUF B_46 ( .A(N427), .Z(N46) );
  GTECH_BUF B_47 ( .A(N429), .Z(N47) );
  SELECT_OP C4398 ( .DATA1(N1249), .DATA2(N1257), .DATA3(N1265), .DATA4(N1273), 
        .DATA5(N1281), .DATA6(N1289), .DATA7(N1297), .DATA8(N1305), .DATA9(
        1'b1), .DATA10(N1313), .DATA11(N1321), .DATA12(N1329), .DATA13(N1337), 
        .DATA14(N1345), .CONTROL1(N35), .CONTROL2(N36), .CONTROL3(N37), 
        .CONTROL4(N38), .CONTROL5(N39), .CONTROL6(N40), .CONTROL7(N41), 
        .CONTROL8(N42), .CONTROL9(N34), .CONTROL10(N43), .CONTROL11(N44), 
        .CONTROL12(N45), .CONTROL13(N46), .CONTROL14(N47), .Z(N440) );
  SELECT_OP C4399 ( .DATA1(1'b0), .DATA2(N1401), .DATA3(N1409), .DATA4(N1417), 
        .DATA5(N1425), .DATA6(N1433), .DATA7(N1441), .DATA8(N1449), .DATA9(
        N1457), .DATA10(1'b1), .CONTROL1(N48), .CONTROL2(N36), .CONTROL3(N37), 
        .CONTROL4(N38), .CONTROL5(N39), .CONTROL6(N40), .CONTROL7(N41), 
        .CONTROL8(N42), .CONTROL9(N43), .CONTROL10(N49), .Z(N441) );
  GTECH_BUF B_48 ( .A(N1595), .Z(N48) );
  GTECH_BUF B_49 ( .A(N1596), .Z(N49) );
  SELECT_OP C4400 ( .DATA1(1'b0), .DATA2(N1489), .DATA3(N1497), .DATA4(N1505), 
        .DATA5(1'b1), .CONTROL1(N50), .CONTROL2(N40), .CONTROL3(N41), 
        .CONTROL4(N43), .CONTROL5(N49), .Z(N442) );
  GTECH_BUF B_50 ( .A(N1598), .Z(N50) );
  SELECT_OP C4401 ( .DATA1({instruction[7], instruction[2:0]}), .DATA2({1'b1, 
        1'b1, 1'b1, 1'b1}), .CONTROL1(N51), .CONTROL2(N52), .Z({N448, N447, 
        N446, N445}) );
  GTECH_BUF B_51 ( .A(N1527), .Z(N51) );
  GTECH_BUF B_52 ( .A(N449), .Z(N52) );
  SELECT_OP C4402 ( .DATA1({instruction[7], instruction[2], instruction[0]}), 
        .DATA2({1'b1, 1'b1, 1'b1}), .CONTROL1(N53), .CONTROL2(N54), .Z({N455, 
        N454, N452}) );
  GTECH_BUF B_53 ( .A(N1528), .Z(N53) );
  GTECH_BUF B_54 ( .A(N1529), .Z(N54) );
  SELECT_OP C4403 ( .DATA1(instruction[1]), .DATA2(1'b0), .DATA3(1'b1), 
        .CONTROL1(N53), .CONTROL2(N55), .CONTROL3(N56), .Z(N453) );
  GTECH_BUF B_55 ( .A(N443), .Z(N55) );
  GTECH_BUF B_56 ( .A(N176), .Z(N56) );
  SELECT_OP C4404 ( .DATA1({1'b1, 1'b0, 1'b1}), .DATA2(instruction[2:0]), 
        .CONTROL1(N57), .CONTROL2(N58), .Z({N458, N457, N456}) );
  GTECH_BUF B_57 ( .A(N495), .Z(N57) );
  GTECH_BUF B_58 ( .A(instruction[11]), .Z(N58) );
  SELECT_OP C4405 ( .DATA1(instruction[2:0]), .DATA2({1'b1, 1'b0, 1'b1}), 
        .CONTROL1(N57), .CONTROL2(N58), .Z({N461, N460, N459}) );
  SELECT_OP C4406 ( .DATA1({1'b1, 1'b0, 1'b1}), .DATA2(instruction[2:0]), 
        .CONTROL1(N59), .CONTROL2(N60), .Z({N467, N466, N465}) );
  GTECH_BUF B_59 ( .A(N721), .Z(N59) );
  GTECH_BUF B_60 ( .A(N471), .Z(N60) );
  SELECT_OP C4407 ( .DATA1(instruction[2:0]), .DATA2({1'b1, 1'b0, 1'b1}), 
        .CONTROL1(N59), .CONTROL2(N60), .Z({N470, N469, N468}) );
  SELECT_OP C4408 ( .DATA1(1'b0), .DATA2(1'b1), .DATA3(1'b1), .DATA4(1'b1), 
        .CONTROL1(N59), .CONTROL2(N61), .CONTROL3(N62), .CONTROL4(N63), .Z(
        N474) );
  GTECH_BUF B_61 ( .A(N463), .Z(N61) );
  GTECH_BUF B_62 ( .A(N464), .Z(N62) );
  GTECH_BUF B_63 ( .A(N175), .Z(N63) );
  SELECT_OP C4409 ( .DATA1(1'b1), .DATA2(1'b0), .DATA3(1'b0), .DATA4(1'b0), 
        .CONTROL1(N59), .CONTROL2(N61), .CONTROL3(N62), .CONTROL4(N63), .Z(
        N475) );
  SELECT_OP C4410 ( .DATA1({1'b1, 1'b0, 1'b1}), .DATA2(instruction[2:0]), 
        .CONTROL1(N57), .CONTROL2(N58), .Z({N478, N477, N476}) );
  SELECT_OP C4411 ( .DATA1(instruction[2:0]), .DATA2({1'b1, 1'b0, 1'b1}), 
        .CONTROL1(N57), .CONTROL2(N58), .Z({N481, N480, N479}) );
  SELECT_OP C4412 ( .DATA1({1'b1, 1'b0, 1'b1}), .DATA2(instruction[2:0]), 
        .CONTROL1(N57), .CONTROL2(N58), .Z({N485, N484, N483}) );
  SELECT_OP C4413 ( .DATA1(instruction[2:0]), .DATA2({1'b1, 1'b0, 1'b1}), 
        .CONTROL1(N57), .CONTROL2(N58), .Z({N488, N487, N486}) );
  SELECT_OP C4414 ( .DATA1({1'b1, 1'b0, 1'b1}), .DATA2(instruction[10:8]), 
        .CONTROL1(N57), .CONTROL2(N58), .Z({N491, N490, N489}) );
  SELECT_OP C4415 ( .DATA1(instruction[10:8]), .DATA2({1'b1, 1'b0, 1'b1}), 
        .CONTROL1(N57), .CONTROL2(N58), .Z({N494, N493, N492}) );
  SELECT_OP C4416 ( .DATA1(instruction[11]), .DATA2(instruction[11]), .DATA3(
        instruction[11]), .DATA4(instruction[11]), .DATA5(instruction[11]), 
        .DATA6(instruction[11]), .DATA7(instruction[11]), .DATA8(
        instruction[11]), .DATA9(instruction[11]), .DATA10(instruction[11]), 
        .DATA11(instruction[11]), .DATA12(instruction[11]), .DATA13(
        instruction[11]), .DATA14(instruction[11]), .DATA15(instruction[11]), 
        .DATA16(instruction[11]), .DATA17(instruction[11]), .DATA18(1'b0), 
        .CONTROL1(N64), .CONTROL2(N928), .CONTROL3(N930), .CONTROL4(N932), 
        .CONTROL5(N934), .CONTROL6(N936), .CONTROL7(N938), .CONTROL8(N940), 
        .CONTROL9(N942), .CONTROL10(N944), .CONTROL11(N947), .CONTROL12(N950), 
        .CONTROL13(N953), .CONTROL14(N956), .CONTROL15(N959), .CONTROL16(N962), 
        .CONTROL17(N965), .CONTROL18(N614), .Z(N610) );
  GTECH_BUF B_64 ( .A(N505), .Z(N64) );
  SELECT_OP C4417 ( .DATA1(N495), .DATA2(N495), .DATA3(N495), .DATA4(N495), 
        .DATA5(N495), .DATA6(N495), .DATA7(N495), .DATA8(N495), .DATA9(N495), 
        .DATA10(N495), .DATA11(N495), .DATA12(N495), .DATA13(N495), .DATA14(
        N495), .DATA15(N495), .DATA16(N495), .DATA17(N495), .DATA18(1'b0), 
        .CONTROL1(N64), .CONTROL2(N928), .CONTROL3(N930), .CONTROL4(N932), 
        .CONTROL5(N934), .CONTROL6(N936), .CONTROL7(N938), .CONTROL8(N940), 
        .CONTROL9(N942), .CONTROL10(N944), .CONTROL11(N947), .CONTROL12(N950), 
        .CONTROL13(N953), .CONTROL14(N956), .CONTROL15(N959), .CONTROL16(N962), 
        .CONTROL17(N965), .CONTROL18(N614), .Z(N611) );
  SELECT_OP C4418 ( .DATA1({N495, instruction[11]}), .DATA2({N495, 
        instruction[11]}), .DATA3({N495, instruction[11]}), .DATA4({N495, 
        instruction[11]}), .DATA5({N495, instruction[11]}), .DATA6({N495, 
        instruction[11]}), .DATA7({N495, instruction[11]}), .DATA8({N495, 
        instruction[11]}), .DATA9({N495, instruction[11]}), .DATA10({N495, 
        instruction[11]}), .DATA11({N495, instruction[11]}), .DATA12({N495, 
        instruction[11]}), .DATA13({N495, instruction[11]}), .DATA14({N495, 
        instruction[11]}), .DATA15({N495, instruction[11]}), .DATA16({N495, 
        instruction[11]}), .DATA17({N495, instruction[11]}), .DATA18({1'b0, 
        1'b0}), .CONTROL1(N64), .CONTROL2(N928), .CONTROL3(N930), .CONTROL4(
        N932), .CONTROL5(N934), .CONTROL6(N936), .CONTROL7(N938), .CONTROL8(
        N940), .CONTROL9(N942), .CONTROL10(N944), .CONTROL11(N947), 
        .CONTROL12(N950), .CONTROL13(N953), .CONTROL14(N956), .CONTROL15(N959), 
        .CONTROL16(N962), .CONTROL17(N965), .CONTROL18(N614), .Z({N613, N612})
         );
  SELECT_OP C4419 ( .DATA1(N495), .DATA2(N495), .DATA3(N495), .DATA4(N495), 
        .DATA5(N495), .DATA6(N495), .DATA7(N495), .DATA8(N495), .DATA9(N495), 
        .DATA10(N495), .DATA11(N495), .DATA12(N495), .DATA13(N495), .DATA14(
        N495), .DATA15(N495), .DATA16(N495), .DATA17(N495), .DATA18(1'b0), 
        .CONTROL1(N64), .CONTROL2(N928), .CONTROL3(N930), .CONTROL4(N932), 
        .CONTROL5(N934), .CONTROL6(N936), .CONTROL7(N938), .CONTROL8(N940), 
        .CONTROL9(N942), .CONTROL10(N944), .CONTROL11(N947), .CONTROL12(N950), 
        .CONTROL13(N953), .CONTROL14(N956), .CONTROL15(N959), .CONTROL16(N962), 
        .CONTROL17(N965), .CONTROL18(N614), .Z(N616) );
  SELECT_OP C4420 ( .DATA1(N495), .DATA2(1'b1), .DATA3(N495), .DATA4(N495), 
        .DATA5(N495), .DATA6(N495), .DATA7(N495), .DATA8(N495), .DATA9(N495), 
        .CONTROL1(N64), .CONTROL2(N65), .CONTROL3(N930), .CONTROL4(N934), 
        .CONTROL5(N938), .CONTROL6(N944), .CONTROL7(N950), .CONTROL8(N956), 
        .CONTROL9(N962), .Z(N617) );
  GTECH_BUF B_65 ( .A(N1613), .Z(N65) );
  SELECT_OP C4421 ( .DATA1(1'b0), .DATA2(instruction[11]), .DATA3(
        instruction[11]), .DATA4(instruction[11]), .DATA5(instruction[11]), 
        .DATA6(instruction[11]), .DATA7(instruction[11]), .DATA8(
        instruction[11]), .DATA9(instruction[11]), .DATA10(instruction[11]), 
        .CONTROL1(N66), .CONTROL2(N930), .CONTROL3(N932), .CONTROL4(N938), 
        .CONTROL5(N940), .CONTROL6(N942), .CONTROL7(N950), .CONTROL8(N953), 
        .CONTROL9(N962), .CONTROL10(N965), .Z(N618) );
  GTECH_BUF B_66 ( .A(N1616), .Z(N66) );
  SELECT_OP C4422 ( .DATA1(N495), .DATA2(N495), .DATA3(N495), .DATA4(N495), 
        .DATA5(1'b1), .DATA6(N495), .DATA7(N495), .DATA8(N495), .DATA9(N495), 
        .CONTROL1(N64), .CONTROL2(N928), .CONTROL3(N930), .CONTROL4(N932), 
        .CONTROL5(N67), .CONTROL6(N944), .CONTROL7(N947), .CONTROL8(N950), 
        .CONTROL9(N953), .Z(N619) );
  GTECH_BUF B_67 ( .A(N1619), .Z(N67) );
  SELECT_OP C4423 ( .DATA1(N495), .DATA2(N495), .DATA3(N495), .DATA4(N495), 
        .DATA5(N495), .DATA6(N495), .DATA7(N495), .DATA8(N495), .DATA9(1'b1), 
        .DATA10(N495), .DATA11(N495), .DATA12(N495), .DATA13(N495), .DATA14(
        N495), .DATA15(N495), .DATA16(N495), .DATA17(N495), .CONTROL1(N64), 
        .CONTROL2(N928), .CONTROL3(N930), .CONTROL4(N932), .CONTROL5(N934), 
        .CONTROL6(N936), .CONTROL7(N938), .CONTROL8(N940), .CONTROL9(N68), 
        .CONTROL10(N944), .CONTROL11(N947), .CONTROL12(N950), .CONTROL13(N953), 
        .CONTROL14(N956), .CONTROL15(N959), .CONTROL16(N962), .CONTROL17(N965), 
        .Z(N620) );
  GTECH_BUF B_68 ( .A(N1620), .Z(N68) );
  SELECT_OP C4424 ( .DATA1(N495), .DATA2(N495), .DATA3(N495), .DATA4(N495), 
        .DATA5(N495), .DATA6(N495), .DATA7(N495), .DATA8(N495), .DATA9(N495), 
        .DATA10(N495), .DATA11(N495), .DATA12(N495), .DATA13(N495), .DATA14(
        N495), .DATA15(N495), .DATA16(N495), .DATA17(N495), .DATA18(1'b1), 
        .CONTROL1(N64), .CONTROL2(N928), .CONTROL3(N930), .CONTROL4(N932), 
        .CONTROL5(N934), .CONTROL6(N936), .CONTROL7(N938), .CONTROL8(N940), 
        .CONTROL9(N942), .CONTROL10(N944), .CONTROL11(N947), .CONTROL12(N950), 
        .CONTROL13(N953), .CONTROL14(N956), .CONTROL15(N959), .CONTROL16(N962), 
        .CONTROL17(N965), .CONTROL18(N614), .Z(N621) );
  SELECT_OP C4425 ( .DATA1(instruction[11]), .DATA2(instruction[11]), .DATA3(
        instruction[11]), .DATA4(instruction[11]), .DATA5(instruction[11]), 
        .DATA6(instruction[11]), .DATA7(instruction[11]), .DATA8(
        instruction[11]), .DATA9(instruction[11]), .DATA10(instruction[11]), 
        .DATA11(instruction[11]), .DATA12(instruction[11]), .DATA13(
        instruction[11]), .DATA14(instruction[11]), .DATA15(instruction[11]), 
        .DATA16(instruction[11]), .DATA17(instruction[11]), .DATA18(1'b0), 
        .CONTROL1(N64), .CONTROL2(N928), .CONTROL3(N930), .CONTROL4(N932), 
        .CONTROL5(N934), .CONTROL6(N936), .CONTROL7(N938), .CONTROL8(N940), 
        .CONTROL9(N942), .CONTROL10(N944), .CONTROL11(N947), .CONTROL12(N950), 
        .CONTROL13(N953), .CONTROL14(N956), .CONTROL15(N959), .CONTROL16(N962), 
        .CONTROL17(N965), .CONTROL18(N614), .Z(N622) );
  SELECT_OP C4426 ( .DATA1(instruction[11]), .DATA2(1'b1), .DATA3(
        instruction[11]), .DATA4(instruction[11]), .DATA5(instruction[11]), 
        .DATA6(instruction[11]), .DATA7(instruction[11]), .DATA8(
        instruction[11]), .DATA9(instruction[11]), .DATA10(instruction[11]), 
        .CONTROL1(N64), .CONTROL2(N69), .CONTROL3(N930), .CONTROL4(N934), 
        .CONTROL5(N938), .CONTROL6(N942), .CONTROL7(N944), .CONTROL8(N950), 
        .CONTROL9(N956), .CONTROL10(N962), .Z(N623) );
  GTECH_BUF B_69 ( .A(N1623), .Z(N69) );
  SELECT_OP C4427 ( .DATA1(1'b0), .DATA2(N495), .DATA3(N495), .DATA4(N495), 
        .DATA5(N495), .DATA6(N495), .DATA7(N495), .DATA8(N495), .DATA9(N495), 
        .DATA10(N495), .CONTROL1(N66), .CONTROL2(N930), .CONTROL3(N932), 
        .CONTROL4(N938), .CONTROL5(N940), .CONTROL6(N942), .CONTROL7(N950), 
        .CONTROL8(N953), .CONTROL9(N962), .CONTROL10(N965), .Z(N624) );
  SELECT_OP C4428 ( .DATA1(instruction[11]), .DATA2(instruction[11]), .DATA3(
        instruction[11]), .DATA4(instruction[11]), .DATA5(1'b1), .DATA6(
        instruction[11]), .DATA7(instruction[11]), .DATA8(instruction[11]), 
        .DATA9(instruction[11]), .CONTROL1(N64), .CONTROL2(N928), .CONTROL3(
        N930), .CONTROL4(N932), .CONTROL5(N67), .CONTROL6(N944), .CONTROL7(
        N947), .CONTROL8(N950), .CONTROL9(N953), .Z(N625) );
  SELECT_OP C4429 ( .DATA1(instruction[11]), .DATA2(instruction[11]), .DATA3(
        instruction[11]), .DATA4(instruction[11]), .DATA5(instruction[11]), 
        .DATA6(instruction[11]), .DATA7(instruction[11]), .DATA8(
        instruction[11]), .DATA9(1'b1), .DATA10(instruction[11]), .DATA11(
        instruction[11]), .DATA12(instruction[11]), .DATA13(instruction[11]), 
        .DATA14(instruction[11]), .DATA15(instruction[11]), .DATA16(
        instruction[11]), .DATA17(instruction[11]), .CONTROL1(N64), .CONTROL2(
        N928), .CONTROL3(N930), .CONTROL4(N932), .CONTROL5(N934), .CONTROL6(
        N936), .CONTROL7(N938), .CONTROL8(N940), .CONTROL9(N68), .CONTROL10(
        N944), .CONTROL11(N947), .CONTROL12(N950), .CONTROL13(N953), 
        .CONTROL14(N956), .CONTROL15(N959), .CONTROL16(N962), .CONTROL17(N965), 
        .Z(N626) );
  SELECT_OP C4430 ( .DATA1(instruction[11]), .DATA2(instruction[11]), .DATA3(
        instruction[11]), .DATA4(instruction[11]), .DATA5(instruction[11]), 
        .DATA6(instruction[11]), .DATA7(instruction[11]), .DATA8(
        instruction[11]), .DATA9(instruction[11]), .DATA10(instruction[11]), 
        .DATA11(instruction[11]), .DATA12(instruction[11]), .DATA13(
        instruction[11]), .DATA14(instruction[11]), .DATA15(instruction[11]), 
        .DATA16(instruction[11]), .DATA17(instruction[11]), .DATA18(1'b1), 
        .CONTROL1(N64), .CONTROL2(N928), .CONTROL3(N930), .CONTROL4(N932), 
        .CONTROL5(N934), .CONTROL6(N936), .CONTROL7(N938), .CONTROL8(N940), 
        .CONTROL9(N942), .CONTROL10(N944), .CONTROL11(N947), .CONTROL12(N950), 
        .CONTROL13(N953), .CONTROL14(N956), .CONTROL15(N959), .CONTROL16(N962), 
        .CONTROL17(N965), .CONTROL18(N614), .Z(N627) );
  SELECT_OP C4431 ( .DATA1(instruction[11]), .DATA2(instruction[11]), .DATA3(
        instruction[11]), .DATA4(instruction[11]), .DATA5(instruction[11]), 
        .DATA6(instruction[11]), .DATA7(instruction[11]), .DATA8(
        instruction[11]), .DATA9(instruction[11]), .DATA10(instruction[11]), 
        .DATA11(instruction[11]), .DATA12(instruction[11]), .DATA13(
        instruction[11]), .DATA14(instruction[11]), .DATA15(instruction[11]), 
        .DATA16(1'b0), .CONTROL1(N70), .CONTROL2(N968), .CONTROL3(N970), 
        .CONTROL4(N972), .CONTROL5(N974), .CONTROL6(N976), .CONTROL7(N978), 
        .CONTROL8(N980), .CONTROL9(N982), .CONTROL10(N984), .CONTROL11(N987), 
        .CONTROL12(N990), .CONTROL13(N993), .CONTROL14(N996), .CONTROL15(N999), 
        .CONTROL16(N1002), .Z(N705) );
  GTECH_BUF B_70 ( .A(N634), .Z(N70) );
  SELECT_OP C4432 ( .DATA1(N495), .DATA2(N495), .DATA3(N495), .DATA4(N495), 
        .DATA5(N495), .DATA6(N495), .DATA7(1'b1), .DATA8(1'b1), .DATA9(1'b1), 
        .DATA10(1'b1), .DATA11(1'b1), .DATA12(1'b1), .DATA13(1'b1), .DATA14(
        1'b1), .DATA15(1'b1), .DATA16(1'b0), .CONTROL1(N70), .CONTROL2(N968), 
        .CONTROL3(N970), .CONTROL4(N972), .CONTROL5(N974), .CONTROL6(N976), 
        .CONTROL7(N978), .CONTROL8(N980), .CONTROL9(N982), .CONTROL10(N984), 
        .CONTROL11(N987), .CONTROL12(N990), .CONTROL13(N993), .CONTROL14(N996), 
        .CONTROL15(N999), .CONTROL16(N1002), .Z(N706) );
  SELECT_OP C4433 ( .DATA1(N495), .DATA2(1'b1), .DATA3(N495), .DATA4(N495), 
        .DATA5(N495), .DATA6(N495), .DATA7(N495), .DATA8(N495), .DATA9(N495), 
        .CONTROL1(N70), .CONTROL2(N71), .CONTROL3(N970), .CONTROL4(N974), 
        .CONTROL5(N978), .CONTROL6(N982), .CONTROL7(N987), .CONTROL8(N993), 
        .CONTROL9(N999), .Z(N707) );
  GTECH_BUF B_71 ( .A(N1626), .Z(N71) );
  SELECT_OP C4434 ( .DATA1(1'b0), .DATA2(instruction[11]), .DATA3(
        instruction[11]), .DATA4(instruction[11]), .DATA5(instruction[11]), 
        .DATA6(instruction[11]), .DATA7(instruction[11]), .DATA8(
        instruction[11]), .CONTROL1(N72), .CONTROL2(N970), .CONTROL3(N972), 
        .CONTROL4(N978), .CONTROL5(N980), .CONTROL6(N987), .CONTROL7(N990), 
        .CONTROL8(N999), .Z(N708) );
  GTECH_BUF B_72 ( .A(N1629), .Z(N72) );
  SELECT_OP C4435 ( .DATA1(N495), .DATA2(N495), .DATA3(N495), .DATA4(N495), 
        .DATA5(1'b1), .DATA6(N495), .DATA7(N495), .DATA8(N495), .DATA9(N495), 
        .CONTROL1(N70), .CONTROL2(N968), .CONTROL3(N970), .CONTROL4(N972), 
        .CONTROL5(N73), .CONTROL6(N982), .CONTROL7(N984), .CONTROL8(N987), 
        .CONTROL9(N990), .Z(N709) );
  GTECH_BUF B_73 ( .A(N1632), .Z(N73) );
  SELECT_OP C4436 ( .DATA1({N495, N495}), .DATA2({N495, N495}), .DATA3({N495, 
        N495}), .DATA4({N495, N495}), .DATA5({N495, N495}), .DATA6({N495, N495}), .DATA7({N495, N495}), .DATA8({N495, N495}), .DATA9({N495, N495}), .DATA10({
        N495, N495}), .DATA11({N495, N495}), .DATA12({N495, N495}), .DATA13({
        N495, N495}), .DATA14({N495, N495}), .DATA15({N495, N495}), .DATA16({
        1'b1, 1'b1}), .CONTROL1(N70), .CONTROL2(N968), .CONTROL3(N970), 
        .CONTROL4(N972), .CONTROL5(N974), .CONTROL6(N976), .CONTROL7(N978), 
        .CONTROL8(N980), .CONTROL9(N982), .CONTROL10(N984), .CONTROL11(N987), 
        .CONTROL12(N990), .CONTROL13(N993), .CONTROL14(N996), .CONTROL15(N999), 
        .CONTROL16(N1002), .Z({N711, N710}) );
  SELECT_OP C4437 ( .DATA1(instruction[11]), .DATA2(instruction[11]), .DATA3(
        instruction[11]), .DATA4(instruction[11]), .DATA5(instruction[11]), 
        .DATA6(instruction[11]), .DATA7(instruction[11]), .DATA8(
        instruction[11]), .DATA9(instruction[11]), .DATA10(instruction[11]), 
        .DATA11(instruction[11]), .DATA12(instruction[11]), .DATA13(
        instruction[11]), .DATA14(instruction[11]), .DATA15(instruction[11]), 
        .DATA16(1'b0), .CONTROL1(N70), .CONTROL2(N968), .CONTROL3(N970), 
        .CONTROL4(N972), .CONTROL5(N974), .CONTROL6(N976), .CONTROL7(N978), 
        .CONTROL8(N980), .CONTROL9(N982), .CONTROL10(N984), .CONTROL11(N987), 
        .CONTROL12(N990), .CONTROL13(N993), .CONTROL14(N996), .CONTROL15(N999), 
        .CONTROL16(N1002), .Z(N712) );
  SELECT_OP C4438 ( .DATA1(instruction[11]), .DATA2(1'b1), .DATA3(
        instruction[11]), .DATA4(instruction[11]), .DATA5(instruction[11]), 
        .DATA6(instruction[11]), .DATA7(instruction[11]), .DATA8(
        instruction[11]), .DATA9(instruction[11]), .CONTROL1(N70), .CONTROL2(
        N71), .CONTROL3(N970), .CONTROL4(N974), .CONTROL5(N978), .CONTROL6(
        N982), .CONTROL7(N987), .CONTROL8(N993), .CONTROL9(N999), .Z(N713) );
  SELECT_OP C4439 ( .DATA1(1'b0), .DATA2(N495), .DATA3(N495), .DATA4(N495), 
        .DATA5(N495), .DATA6(N495), .DATA7(N495), .DATA8(N495), .CONTROL1(N72), 
        .CONTROL2(N970), .CONTROL3(N972), .CONTROL4(N978), .CONTROL5(N980), 
        .CONTROL6(N987), .CONTROL7(N990), .CONTROL8(N999), .Z(N714) );
  SELECT_OP C4440 ( .DATA1(instruction[11]), .DATA2(instruction[11]), .DATA3(
        instruction[11]), .DATA4(instruction[11]), .DATA5(1'b1), .DATA6(
        instruction[11]), .DATA7(instruction[11]), .DATA8(instruction[11]), 
        .DATA9(instruction[11]), .CONTROL1(N70), .CONTROL2(N968), .CONTROL3(
        N970), .CONTROL4(N972), .CONTROL5(N73), .CONTROL6(N982), .CONTROL7(
        N984), .CONTROL8(N987), .CONTROL9(N990), .Z(N715) );
  SELECT_OP C4441 ( .DATA1({instruction[11], instruction[11]}), .DATA2({
        instruction[11], instruction[11]}), .DATA3({instruction[11], 
        instruction[11]}), .DATA4({instruction[11], instruction[11]}), .DATA5(
        {instruction[11], instruction[11]}), .DATA6({instruction[11], 
        instruction[11]}), .DATA7({instruction[11], instruction[11]}), .DATA8(
        {instruction[11], instruction[11]}), .DATA9({instruction[11], 
        instruction[11]}), .DATA10({instruction[11], instruction[11]}), 
        .DATA11({instruction[11], instruction[11]}), .DATA12({instruction[11], 
        instruction[11]}), .DATA13({instruction[11], instruction[11]}), 
        .DATA14({instruction[11], instruction[11]}), .DATA15({instruction[11], 
        instruction[11]}), .DATA16({1'b1, 1'b1}), .CONTROL1(N70), .CONTROL2(
        N968), .CONTROL3(N970), .CONTROL4(N972), .CONTROL5(N974), .CONTROL6(
        N976), .CONTROL7(N978), .CONTROL8(N980), .CONTROL9(N982), .CONTROL10(
        N984), .CONTROL11(N987), .CONTROL12(N990), .CONTROL13(N993), 
        .CONTROL14(N996), .CONTROL15(N999), .CONTROL16(N1002), .Z({N717, N716}) );
  SELECT_OP C4442 ( .DATA1(flag_z), .DATA2(N760), .DATA3(flag_c), .DATA4(N761), 
        .DATA5(flag_n), .DATA6(N762), .DATA7(flag_v), .DATA8(N763), .DATA9(
        N764), .DATA10(N765), .DATA11(N766), .DATA12(N767), .DATA13(N768), 
        .DATA14(N769), .DATA15(1'b1), .DATA16(1'b0), .CONTROL1(N74), 
        .CONTROL2(N75), .CONTROL3(N76), .CONTROL4(N77), .CONTROL5(N78), 
        .CONTROL6(N79), .CONTROL7(N80), .CONTROL8(N81), .CONTROL9(N82), 
        .CONTROL10(N83), .CONTROL11(N84), .CONTROL12(N85), .CONTROL13(N86), 
        .CONTROL14(N87), .CONTROL15(N88), .CONTROL16(N89), .Z(N770) );
  GTECH_BUF B_74 ( .A(N723), .Z(N74) );
  GTECH_BUF B_75 ( .A(N727), .Z(N75) );
  GTECH_BUF B_76 ( .A(N730), .Z(N76) );
  GTECH_BUF B_77 ( .A(N733), .Z(N77) );
  GTECH_BUF B_78 ( .A(N737), .Z(N78) );
  GTECH_BUF B_79 ( .A(N739), .Z(N79) );
  GTECH_BUF B_80 ( .A(N741), .Z(N80) );
  GTECH_BUF B_81 ( .A(N743), .Z(N81) );
  GTECH_BUF B_82 ( .A(N746), .Z(N82) );
  GTECH_BUF B_83 ( .A(N748), .Z(N83) );
  GTECH_BUF B_84 ( .A(N750), .Z(N84) );
  GTECH_BUF B_85 ( .A(N752), .Z(N85) );
  GTECH_BUF B_86 ( .A(N755), .Z(N86) );
  GTECH_BUF B_87 ( .A(N757), .Z(N87) );
  GTECH_BUF B_88 ( .A(N759), .Z(N88) );
  GTECH_BUF B_89 ( .A(N178), .Z(N89) );
  SELECT_OP C4443 ( .DATA1(1'b0), .DATA2(N770), .CONTROL1(N90), .CONTROL2(N719), .Z(N771) );
  GTECH_BUF B_90 ( .A(N1592), .Z(N90) );
  SELECT_OP C4444 ( .DATA1(instruction[10:0]), .DATA2({1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .CONTROL1(N57), .CONTROL2(
        N58), .Z({N782, N781, N780, N779, N778, N777, N776, N775, N774, N773, 
        N772}) );
  SELECT_OP C4445 ( .DATA1({instruction[5], instruction[3]}), .DATA2({N382, 
        N380}), .DATA3({instruction[2], instruction[0]}), .DATA4({N447, N445}), 
        .DATA5({1'b1, 1'b1}), .DATA6({instruction[10], instruction[8]}), 
        .CONTROL1(N91), .CONTROL2(N92), .CONTROL3(N93), .CONTROL4(N94), 
        .CONTROL5(N95), .CONTROL6(N96), .Z({N785, N783}) );
  GTECH_BUF B_91 ( .A(N1551), .Z(N91) );
  GTECH_BUF B_92 ( .A(N291), .Z(N92) );
  GTECH_BUF B_93 ( .A(N295), .Z(N93) );
  GTECH_BUF B_94 ( .A(N300), .Z(N94) );
  GTECH_BUF B_95 ( .A(N1553), .Z(N95) );
  GTECH_BUF B_96 ( .A(N326), .Z(N96) );
  SELECT_OP C4446 ( .DATA1(instruction[4]), .DATA2(N381), .DATA3(
        instruction[1]), .DATA4(N446), .DATA5(1'b1), .DATA6(1'b0), .DATA7(N495), .DATA8(instruction[9]), .CONTROL1(N91), .CONTROL2(N92), .CONTROL3(N93), 
        .CONTROL4(N94), .CONTROL5(N97), .CONTROL6(N98), .CONTROL7(N99), 
        .CONTROL8(N96), .Z(N784) );
  GTECH_BUF B_97 ( .A(N1554), .Z(N97) );
  GTECH_BUF B_98 ( .A(N1555), .Z(N98) );
  GTECH_BUF B_99 ( .A(N320), .Z(N99) );
  SELECT_OP C4447 ( .DATA1(1'b0), .DATA2(N351), .DATA3(N448), .DATA4(1'b1), 
        .CONTROL1(N100), .CONTROL2(N92), .CONTROL3(N94), .CONTROL4(N95), .Z(
        N786) );
  GTECH_BUF B_100 ( .A(N1558), .Z(N100) );
  SELECT_OP C4448 ( .DATA1(1'b0), .DATA2(N351), .DATA3(N449), .DATA4(1'b1), 
        .CONTROL1(N101), .CONTROL2(N92), .CONTROL3(N94), .CONTROL4(N102), .Z(
        N787) );
  GTECH_BUF B_101 ( .A(N1560), .Z(N101) );
  GTECH_BUF B_102 ( .A(N1514), .Z(N102) );
  SELECT_OP C4449 ( .DATA1(instruction[0]), .DATA2(N386), .DATA3(N434), 
        .DATA4(N452), .DATA5(1'b1), .DATA6(instruction[8]), .DATA7(1'b0), 
        .CONTROL1(N103), .CONTROL2(N92), .CONTROL3(N93), .CONTROL4(N94), 
        .CONTROL5(N104), .CONTROL6(N105), .CONTROL7(N106), .Z(N788) );
  GTECH_BUF B_103 ( .A(N289), .Z(N103) );
  GTECH_BUF B_104 ( .A(N1583), .Z(N104) );
  GTECH_BUF B_105 ( .A(N1584), .Z(N105) );
  GTECH_BUF B_106 ( .A(N335), .Z(N106) );
  SELECT_OP C4450 ( .DATA1(instruction[1]), .DATA2(N387), .DATA3(N435), 
        .DATA4(N453), .DATA5(1'b0), .DATA6(instruction[9]), .DATA7(1'b1), 
        .CONTROL1(N103), .CONTROL2(N92), .CONTROL3(N93), .CONTROL4(N94), 
        .CONTROL5(N107), .CONTROL6(N105), .CONTROL7(N108), .Z(N789) );
  GTECH_BUF B_107 ( .A(N1585), .Z(N107) );
  GTECH_BUF B_108 ( .A(N1580), .Z(N108) );
  SELECT_OP C4451 ( .DATA1(instruction[2]), .DATA2(N388), .DATA3(N436), 
        .DATA4(N454), .DATA5(1'b1), .DATA6(instruction[10]), .CONTROL1(N103), 
        .CONTROL2(N92), .CONTROL3(N93), .CONTROL4(N94), .CONTROL5(N109), 
        .CONTROL6(N105), .Z(N790) );
  GTECH_BUF B_109 ( .A(N1586), .Z(N109) );
  SELECT_OP C4452 ( .DATA1(1'b0), .DATA2(N353), .DATA3(N437), .DATA4(N455), 
        .DATA5(1'b1), .CONTROL1(N110), .CONTROL2(N92), .CONTROL3(N93), 
        .CONTROL4(N94), .CONTROL5(N109), .Z(N791) );
  GTECH_BUF B_110 ( .A(N1587), .Z(N110) );
  SELECT_OP C4453 ( .DATA1(1'b0), .DATA2(N353), .DATA3(N437), .DATA4(N443), 
        .DATA5(1'b1), .DATA6(instruction[11]), .CONTROL1(N111), .CONTROL2(N92), 
        .CONTROL3(N93), .CONTROL4(N94), .CONTROL5(N112), .CONTROL6(N106), .Z(
        N792) );
  GTECH_BUF B_111 ( .A(N1589), .Z(N111) );
  GTECH_BUF B_112 ( .A(N1591), .Z(N112) );
  SELECT_OP C4454 ( .DATA1(1'b1), .DATA2(N384), .DATA3(N438), .DATA4(N450), 
        .DATA5(1'b0), .DATA6(N771), .CONTROL1(N113), .CONTROL2(N92), 
        .CONTROL3(N93), .CONTROL4(N94), .CONTROL5(N112), .CONTROL6(N114), .Z(
        N793) );
  GTECH_BUF B_113 ( .A(N1593), .Z(N113) );
  GTECH_BUF B_114 ( .A(N329), .Z(N114) );
  SELECT_OP C4455 ( .DATA1({1'b1, 1'b1, 1'b1, 1'b0, 1'b1}), .DATA2({1'b0, 1'b0, 
        instruction[10:8]}), .DATA3({N495, N495, N458, N457, N456}), .DATA4({
        N721, N721, N467, N466, N465}), .DATA5({N495, N495, N478, N477, N476}), 
        .DATA6({N495, N495, N485, N484, N483}), .DATA7({N495, N495, N491, N490, 
        N489}), .DATA8({N621, N620, N619, N618, N617}), .DATA9({N711, N710, 
        N709, N708, N707}), .CONTROL1(N115), .CONTROL2(N116), .CONTROL3(N117), 
        .CONTROL4(N118), .CONTROL5(N119), .CONTROL6(N120), .CONTROL7(N121), 
        .CONTROL8(N122), .CONTROL9(N96), .Z({N798, N797, N796, N795, N794}) );
  GTECH_BUF B_115 ( .A(N1638), .Z(N115) );
  GTECH_BUF B_116 ( .A(N304), .Z(N116) );
  GTECH_BUF B_117 ( .A(N308), .Z(N117) );
  GTECH_BUF B_118 ( .A(N312), .Z(N118) );
  GTECH_BUF B_119 ( .A(N314), .Z(N119) );
  GTECH_BUF B_120 ( .A(N316), .Z(N120) );
  GTECH_BUF B_121 ( .A(N318), .Z(N121) );
  GTECH_BUF B_122 ( .A(N323), .Z(N122) );
  SELECT_OP C4456 ( .DATA1(1'b0), .DATA2(1'b1), .DATA3(instruction[11]), 
        .DATA4(N471), .DATA5(instruction[11]), .DATA6(instruction[11]), 
        .DATA7(instruction[11]), .DATA8(N622), .DATA9(N712), .CONTROL1(N115), 
        .CONTROL2(N116), .CONTROL3(N117), .CONTROL4(N118), .CONTROL5(N119), 
        .CONTROL6(N120), .CONTROL7(N121), .CONTROL8(N122), .CONTROL9(N96), .Z(
        N799) );
  SELECT_OP C4457 ( .DATA1({1'b1, 1'b1, 1'b1, 1'b0, 1'b1}), .DATA2({
        instruction[11], instruction[11], N461, N460, N459}), .DATA3({N471, 
        N471, N470, N469, N468}), .DATA4({instruction[11], instruction[11], 
        N481, N480, N479}), .DATA5({instruction[11], instruction[11], N488, 
        N487, N486}), .DATA6({instruction[11], instruction[11], N494, N493, 
        N492}), .DATA7({N627, N626, N625, N624, N623}), .DATA8({N717, N716, 
        N715, N714, N713}), .CONTROL1(N123), .CONTROL2(N117), .CONTROL3(N118), 
        .CONTROL4(N119), .CONTROL5(N120), .CONTROL6(N121), .CONTROL7(N122), 
        .CONTROL8(N96), .Z({N804, N803, N802, N801, N800}) );
  GTECH_BUF B_123 ( .A(N1642), .Z(N123) );
  SELECT_OP C4458 ( .DATA1({1'b1, 1'b0, 1'b1}), .DATA2(instruction[10:8]), 
        .CONTROL1(N124), .CONTROL2(N96), .Z({N807, N806, N805}) );
  GTECH_BUF B_124 ( .A(N808), .Z(N124) );
  SELECT_OP C4459 ( .DATA1(1'b0), .DATA2(N616), .DATA3(1'b1), .CONTROL1(N125), 
        .CONTROL2(N122), .CONTROL3(N96), .Z(N810) );
  GTECH_BUF B_125 ( .A(N809), .Z(N125) );
  SELECT_OP C4460 ( .DATA1(1'b0), .DATA2(N472), .DATA3(1'b1), .CONTROL1(N126), 
        .CONTROL2(N118), .CONTROL3(N120), .Z(N811) );
  GTECH_BUF B_126 ( .A(N1647), .Z(N126) );
  SELECT_OP C4461 ( .DATA1(1'b1), .DATA2(N462), .DATA3(1'b0), .DATA4(N482), 
        .CONTROL1(N127), .CONTROL2(N117), .CONTROL3(N128), .CONTROL4(N119), 
        .Z(N812) );
  GTECH_BUF B_127 ( .A(N1522), .Z(N127) );
  GTECH_BUF B_128 ( .A(N1523), .Z(N128) );
  SELECT_OP C4462 ( .DATA1(1'b0), .DATA2(N473), .CONTROL1(N129), .CONTROL2(
        N118), .Z(N813) );
  GTECH_BUF B_129 ( .A(N1649), .Z(N129) );
  SELECT_OP C4463 ( .DATA1(1'b0), .DATA2(1'b0), .DATA3(1'b0), .DATA4(1'b0), 
        .DATA5(1'b1), .DATA6(instruction[11]), .DATA7(N474), .DATA8(
        instruction[11]), .DATA9(instruction[11]), .DATA10(instruction[11]), 
        .DATA11(1'b0), .DATA12(1'b0), .DATA13(N610), .DATA14(N705), .DATA15(
        1'b0), .DATA16(1'b0), .DATA17(1'b0), .DATA18(1'b0), .DATA19(1'b0), 
        .CONTROL1(N103), .CONTROL2(N92), .CONTROL3(N93), .CONTROL4(N94), 
        .CONTROL5(N116), .CONTROL6(N117), .CONTROL7(N118), .CONTROL8(N119), 
        .CONTROL9(N120), .CONTROL10(N121), .CONTROL11(N99), .CONTROL12(N130), 
        .CONTROL13(N122), .CONTROL14(N96), .CONTROL15(N114), .CONTROL16(N131), 
        .CONTROL17(N106), .CONTROL18(N3), .CONTROL19(N132), .Z(N814) );
  GTECH_BUF B_130 ( .A(N321), .Z(N130) );
  GTECH_BUF B_131 ( .A(N333), .Z(N131) );
  GTECH_BUF B_132 ( .A(N350), .Z(N132) );
  SELECT_OP C4464 ( .DATA1(1'b0), .DATA2(1'b0), .DATA3(1'b0), .DATA4(1'b0), 
        .DATA5(1'b0), .DATA6(N495), .DATA7(N475), .DATA8(N495), .DATA9(N495), 
        .DATA10(N495), .DATA11(1'b0), .DATA12(1'b0), .DATA13(N611), .DATA14(
        N706), .DATA15(1'b0), .DATA16(1'b0), .DATA17(1'b0), .DATA18(1'b0), 
        .DATA19(1'b0), .CONTROL1(N103), .CONTROL2(N92), .CONTROL3(N93), 
        .CONTROL4(N94), .CONTROL5(N116), .CONTROL6(N117), .CONTROL7(N118), 
        .CONTROL8(N119), .CONTROL9(N120), .CONTROL10(N121), .CONTROL11(N99), 
        .CONTROL12(N130), .CONTROL13(N122), .CONTROL14(N96), .CONTROL15(N114), 
        .CONTROL16(N131), .CONTROL17(N106), .CONTROL18(N3), .CONTROL19(N132), 
        .Z(N815) );
  SELECT_OP C4465 ( .DATA1(1'b1), .DATA2(1'b1), .DATA3(1'b1), .DATA4(1'b1), 
        .DATA5(1'b1), .DATA6(1'b1), .DATA7(1'b1), .DATA8(1'b1), .DATA9(1'b1), 
        .DATA10(1'b1), .DATA11(1'b1), .DATA12(1'b1), .DATA13(1'b1), .DATA14(
        1'b1), .DATA15(1'b1), .DATA16(1'b1), .DATA17(instruction[11]), 
        .DATA18(1'b0), .DATA19(1'b0), .CONTROL1(N103), .CONTROL2(N92), 
        .CONTROL3(N93), .CONTROL4(N94), .CONTROL5(N116), .CONTROL6(N117), 
        .CONTROL7(N118), .CONTROL8(N119), .CONTROL9(N120), .CONTROL10(N121), 
        .CONTROL11(N99), .CONTROL12(N130), .CONTROL13(N122), .CONTROL14(N96), 
        .CONTROL15(N114), .CONTROL16(N131), .CONTROL17(N106), .CONTROL18(N3), 
        .CONTROL19(N132), .Z(N816) );
  SELECT_OP C4466 ( .DATA1(N378), .DATA2(N391), .DATA3(N441), .DATA4(N443), 
        .DATA5(1'b0), .CONTROL1(N103), .CONTROL2(N92), .CONTROL3(N93), 
        .CONTROL4(N94), .CONTROL5(N133), .Z(N817) );
  GTECH_BUF B_133 ( .A(N1577), .Z(N133) );
  SELECT_OP C4467 ( .DATA1(N379), .DATA2(N392), .DATA3(N442), .DATA4(N443), 
        .DATA5(1'b0), .CONTROL1(N103), .CONTROL2(N92), .CONTROL3(N93), 
        .CONTROL4(N94), .CONTROL5(N133), .Z(N818) );
  SELECT_OP C4468 ( .DATA1({N366, N364}), .DATA2({1'b1, 1'b1}), .DATA3({
        instruction[5], instruction[3]}), .DATA4({instruction[8], 
        instruction[6]}), .CONTROL1(N103), .CONTROL2(N134), .CONTROL3(N135), 
        .CONTROL4(N136), .Z({N821, N819}) );
  GTECH_BUF B_134 ( .A(N1533), .Z(N134) );
  GTECH_BUF B_135 ( .A(N1534), .Z(N135) );
  GTECH_BUF B_136 ( .A(N1535), .Z(N136) );
  SELECT_OP C4469 ( .DATA1(N365), .DATA2(1'b1), .DATA3(instruction[4]), 
        .DATA4(instruction[7]), .DATA5(1'b0), .CONTROL1(N103), .CONTROL2(N137), 
        .CONTROL3(N135), .CONTROL4(N136), .CONTROL5(N102), .Z(N820) );
  GTECH_BUF B_137 ( .A(N1537), .Z(N137) );
  SELECT_OP C4470 ( .DATA1(N367), .DATA2(1'b1), .DATA3(1'b0), .DATA4(
        instruction[6]), .CONTROL1(N103), .CONTROL2(N134), .CONTROL3(N138), 
        .CONTROL4(N94), .Z(N822) );
  GTECH_BUF B_138 ( .A(N1538), .Z(N138) );
  SELECT_OP C4471 ( .DATA1(N367), .DATA2(1'b1), .DATA3(1'b0), .CONTROL1(N103), 
        .CONTROL2(N134), .CONTROL3(N139), .Z(N823) );
  GTECH_BUF B_139 ( .A(N1539), .Z(N139) );
  SELECT_OP C4472 ( .DATA1(N368), .DATA2(instruction[0]), .DATA3(1'b0), 
        .CONTROL1(N103), .CONTROL2(N92), .CONTROL3(N140), .Z(N824) );
  GTECH_BUF B_140 ( .A(N1543), .Z(N140) );
  SELECT_OP C4473 ( .DATA1(N369), .DATA2(instruction[1]), .DATA3(1'b0), 
        .DATA4(instruction[6]), .DATA5(1'b1), .DATA6(instruction[0]), .DATA7(
        instruction[11]), .CONTROL1(N103), .CONTROL2(N92), .CONTROL3(N141), 
        .CONTROL4(N120), .CONTROL5(N142), .CONTROL6(N143), .CONTROL7(N106), 
        .Z(N825) );
  GTECH_BUF B_141 ( .A(N1545), .Z(N141) );
  GTECH_BUF B_142 ( .A(N1546), .Z(N142) );
  GTECH_BUF B_143 ( .A(N1547), .Z(N143) );
  SELECT_OP C4474 ( .DATA1({N372, N371, N370}), .DATA2(instruction[4:2]), 
        .DATA3({1'b0, 1'b0, 1'b0}), .DATA4(instruction[2:0]), .DATA5(
        instruction[8:6]), .DATA6(instruction[9:7]), .DATA7(instruction[3:1]), 
        .CONTROL1(N103), .CONTROL2(N92), .CONTROL3(N144), .CONTROL4(N145), 
        .CONTROL5(N119), .CONTROL6(N120), .CONTROL7(N143), .Z({N828, N827, 
        N826}) );
  GTECH_BUF B_144 ( .A(N1549), .Z(N144) );
  GTECH_BUF B_145 ( .A(N1550), .Z(N145) );
  SELECT_OP C4475 ( .DATA1(1'b0), .DATA2(instruction[5]), .DATA3(
        instruction[3]), .DATA4(instruction[9]), .DATA5(instruction[10]), 
        .DATA6(instruction[4]), .CONTROL1(N146), .CONTROL2(N92), .CONTROL3(
        N147), .CONTROL4(N119), .CONTROL5(N120), .CONTROL6(N148), .Z(N829) );
  GTECH_BUF B_146 ( .A(N1652), .Z(N146) );
  GTECH_BUF B_147 ( .A(N1653), .Z(N147) );
  GTECH_BUF B_148 ( .A(N1654), .Z(N148) );
  SELECT_OP C4476 ( .DATA1(1'b0), .DATA2(instruction[6]), .DATA3(
        instruction[4]), .DATA4(instruction[10]), .DATA5(instruction[5]), 
        .CONTROL1(N149), .CONTROL2(N92), .CONTROL3(N147), .CONTROL4(N119), 
        .CONTROL5(N148), .Z(N830) );
  GTECH_BUF B_149 ( .A(N1656), .Z(N149) );
  SELECT_OP C4477 ( .DATA1(1'b0), .DATA2(instruction[7]), .DATA3(
        instruction[5]), .DATA4(instruction[6]), .CONTROL1(N150), .CONTROL2(
        N92), .CONTROL3(N147), .CONTROL4(N148), .Z(N831) );
  GTECH_BUF B_150 ( .A(N1658), .Z(N150) );
  SELECT_OP C4478 ( .DATA1(1'b0), .DATA2(instruction[6]), .DATA3(
        instruction[7]), .CONTROL1(N151), .CONTROL2(N147), .CONTROL3(N148), 
        .Z(N832) );
  GTECH_BUF B_151 ( .A(N1660), .Z(N151) );
  SELECT_OP C4479 ( .DATA1(1'b0), .DATA2(instruction[7]), .DATA3(
        instruction[7]), .DATA4(instruction[8]), .CONTROL1(N152), .CONTROL2(
        N153), .CONTROL3(N114), .CONTROL4(N131), .Z(N833) );
  GTECH_BUF B_152 ( .A(N1509), .Z(N152) );
  GTECH_BUF B_153 ( .A(N1510), .Z(N153) );
  SELECT_OP C4480 ( .DATA1({1'b0, 1'b0}), .DATA2({instruction[7], 
        instruction[7]}), .DATA3(instruction[10:9]), .CONTROL1(N154), 
        .CONTROL2(N114), .CONTROL3(N131), .Z({N835, N834}) );
  GTECH_BUF B_154 ( .A(N1515), .Z(N154) );
  SELECT_OP C4481 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0}), .DATA2({instruction[7], instruction[7], 
        instruction[7], instruction[7], instruction[7], instruction[7], 
        instruction[7], instruction[7], instruction[7], instruction[7], 
        instruction[7]}), .DATA3({N782, N781, N780, N779, N778, N777, N776, 
        N775, N774, N773, N772}), .CONTROL1(N155), .CONTROL2(N114), .CONTROL3(
        N106), .Z({N846, N845, N844, N843, N842, N841, N840, N839, N838, N837, 
        N836}) );
  GTECH_BUF B_155 ( .A(N1517), .Z(N155) );
  SELECT_OP C4482 ( .DATA1(1'b0), .DATA2(instruction[7]), .CONTROL1(N156), 
        .CONTROL2(N114), .Z(N847) );
  GTECH_BUF B_156 ( .A(N1519), .Z(N156) );
  SELECT_OP C4483 ( .DATA1(N373), .DATA2(N355), .DATA3(N430), .DATA4(N722), 
        .DATA5(1'b1), .DATA6(N496), .DATA7(N612), .DATA8(N495), .DATA9(1'b0), 
        .CONTROL1(N103), .CONTROL2(N92), .CONTROL3(N93), .CONTROL4(N94), 
        .CONTROL5(N157), .CONTROL6(N130), .CONTROL7(N122), .CONTROL8(N106), 
        .CONTROL9(N102), .Z(N848) );
  GTECH_BUF B_157 ( .A(N1575), .Z(N157) );
  SELECT_OP C4484 ( .DATA1(N374), .DATA2(N383), .DATA3(N431), .DATA4(N443), 
        .DATA5(1'b0), .DATA6(instruction[7]), .DATA7(N613), .DATA8(
        instruction[11]), .CONTROL1(N103), .CONTROL2(N92), .CONTROL3(N93), 
        .CONTROL4(N94), .CONTROL5(N158), .CONTROL6(N130), .CONTROL7(N122), 
        .CONTROL8(N106), .Z(N849) );
  GTECH_BUF B_158 ( .A(N1576), .Z(N158) );
  SELECT_OP C4485 ( .DATA1(N375), .DATA2(N384), .DATA3(N432), .DATA4(N450), 
        .DATA5(1'b1), .CONTROL1(N103), .CONTROL2(N92), .CONTROL3(N93), 
        .CONTROL4(N94), .CONTROL5(N133), .Z(N850) );
  SELECT_OP C4486 ( .DATA1(1'b0), .DATA2(N385), .DATA3(N433), .DATA4(N451), 
        .DATA5(N614), .DATA6(1'b1), .CONTROL1(N159), .CONTROL2(N92), 
        .CONTROL3(N93), .CONTROL4(N94), .CONTROL5(N122), .CONTROL6(N102), .Z(
        N851) );
  GTECH_BUF B_159 ( .A(N1581), .Z(N159) );
  SELECT_OP C4487 ( .DATA1(N356), .DATA2(N375), .DATA3(1'b0), .DATA4(N722), 
        .DATA5(1'b1), .DATA6(N615), .CONTROL1(N103), .CONTROL2(N92), 
        .CONTROL3(N160), .CONTROL4(N94), .CONTROL5(N161), .CONTROL6(N122), .Z(
        N852) );
  GTECH_BUF B_160 ( .A(N1561), .Z(N160) );
  GTECH_BUF B_161 ( .A(N1564), .Z(N161) );
  SELECT_OP C4488 ( .DATA1(N376), .DATA2(N389), .DATA3(N439), .DATA4(N443), 
        .DATA5(1'b0), .CONTROL1(N103), .CONTROL2(N92), .CONTROL3(N93), 
        .CONTROL4(N94), .CONTROL5(N133), .Z(N853) );
  SELECT_OP C4489 ( .DATA1(N377), .DATA2(N390), .DATA3(N440), .DATA4(N443), 
        .DATA5(1'b0), .CONTROL1(N103), .CONTROL2(N92), .CONTROL3(N93), 
        .CONTROL4(N94), .CONTROL5(N133), .Z(N854) );
  SELECT_OP C4490 ( .DATA1(N854), .DATA2(1'b0), .CONTROL1(N162), .CONTROL2(
        N285), .Z(N855) );
  GTECH_BUF B_162 ( .A(N284), .Z(N162) );
  SELECT_OP C4491 ( .DATA1({N787, N786, N785, N784, N783}), .DATA2({1'b1, 1'b1, 
        1'b1, 1'b0, 1'b1}), .CONTROL1(N162), .CONTROL2(N285), .Z({N860, N859, 
        N858, N857, N856}) );
  SELECT_OP C4492 ( .DATA1(N304), .DATA2(1'b0), .CONTROL1(N162), .CONTROL2(
        N285), .Z(N861) );
  SELECT_OP C4493 ( .DATA1({N792, N791, N790, N789, N788}), .DATA2({1'b1, 1'b1, 
        1'b1, 1'b0, 1'b1}), .CONTROL1(N162), .CONTROL2(N285), .Z({N866, N865, 
        N864, N863, N862}) );
  SELECT_OP C4494 ( .DATA1(N793), .DATA2(1'b0), .CONTROL1(N162), .CONTROL2(
        N285), .Z(N867) );
  SELECT_OP C4495 ( .DATA1({N798, N797, N796, N795, N794}), .DATA2({1'b1, 1'b1, 
        1'b1, 1'b0, 1'b1}), .CONTROL1(N162), .CONTROL2(N285), .Z({N872, N871, 
        N870, N869, N868}) );
  SELECT_OP C4496 ( .DATA1(N799), .DATA2(1'b0), .CONTROL1(N162), .CONTROL2(
        N285), .Z(N873) );
  SELECT_OP C4497 ( .DATA1({N804, N803, N802, N801, N800}), .DATA2({1'b1, 1'b1, 
        1'b1, 1'b0, 1'b1}), .CONTROL1(N162), .CONTROL2(N285), .Z({N878, N877, 
        N876, N875, N874}) );
  SELECT_OP C4498 ( .DATA1({N809, N808, N807, N806, N805}), .DATA2({1'b1, 1'b1, 
        1'b1, 1'b0, 1'b1}), .CONTROL1(N162), .CONTROL2(N285), .Z({N883, N882, 
        N881, N880, N879}) );
  SELECT_OP C4499 ( .DATA1(N810), .DATA2(1'b0), .CONTROL1(N162), .CONTROL2(
        N285), .Z(N884) );
  SELECT_OP C4500 ( .DATA1({N812, N811}), .DATA2({1'b1, 1'b0}), .CONTROL1(N162), .CONTROL2(N285), .Z({N886, N885}) );
  SELECT_OP C4501 ( .DATA1(N813), .DATA2(1'b0), .CONTROL1(N162), .CONTROL2(
        N285), .Z(N887) );
  SELECT_OP C4502 ( .DATA1(N814), .DATA2(1'b0), .CONTROL1(N162), .CONTROL2(
        N285), .Z(N888) );
  SELECT_OP C4503 ( .DATA1(N815), .DATA2(1'b0), .CONTROL1(N162), .CONTROL2(
        N285), .Z(N889) );
  SELECT_OP C4504 ( .DATA1(N816), .DATA2(1'b1), .CONTROL1(N162), .CONTROL2(
        N285), .Z(N890) );
  SELECT_OP C4505 ( .DATA1(N817), .DATA2(1'b0), .CONTROL1(N162), .CONTROL2(
        N285), .Z(N891) );
  SELECT_OP C4506 ( .DATA1(N818), .DATA2(1'b0), .CONTROL1(N162), .CONTROL2(
        N285), .Z(N892) );
  SELECT_OP C4507 ( .DATA1({N823, N822, N821, N820, N819}), .DATA2({1'b1, 1'b1, 
        1'b1, 1'b0, 1'b1}), .CONTROL1(N162), .CONTROL2(N285), .Z({N897, N896, 
        N895, N894, N893}) );
  SELECT_OP C4508 ( .DATA1({N847, N846, N845, N844, N843, N842, N841, N840, 
        N839, N838, N837, N836, N835, N834, N833, N832, N831, N830, N829, N828, 
        N827, N826, N825, N824}), .DATA2({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .CONTROL1(N162), .CONTROL2(N285), 
        .Z({N921, N920, N919, N918, N917, N916, N915, N914, N913, N912, N911, 
        N910, N909, N908, N907, N906, N905, N904, N903, N902, N901, N900, N899, 
        N898}) );
  SELECT_OP C4509 ( .DATA1({N852, N851, N850, N849, N848}), .DATA2({1'b0, 1'b1, 
        1'b1, 1'b0, 1'b0}), .CONTROL1(N162), .CONTROL2(N285), .Z({N926, N925, 
        N924, N923, N922}) );
  SELECT_OP C4510 ( .DATA1(N853), .DATA2(1'b0), .CONTROL1(N162), .CONTROL2(
        N285), .Z(N927) );
  SELECT_OP C4511 ( .DATA1({N926, N925, N924, N923, N922}), .DATA2(alu_opcode), 
        .DATA3({1'b0, 1'b1, 1'b1, 1'b0, 1'b0}), .CONTROL1(N163), .CONTROL2(
        N164), .CONTROL3(N165), .Z(next_alu_opcode) );
  GTECH_BUF B_163 ( .A(N212), .Z(N163) );
  GTECH_BUF B_164 ( .A(N213), .Z(N164) );
  GTECH_BUF B_165 ( .A(N1661), .Z(N165) );
  SELECT_OP C4512 ( .DATA1(N927), .DATA2(1'b0), .CONTROL1(N163), .CONTROL2(
        N166), .Z(next_update_flag_n) );
  GTECH_BUF B_166 ( .A(N1662), .Z(N166) );
  SELECT_OP C4513 ( .DATA1(N855), .DATA2(1'b0), .CONTROL1(N163), .CONTROL2(
        N166), .Z(next_update_flag_z) );
  SELECT_OP C4514 ( .DATA1({N860, N859, N858, N857, N856}), .DATA2(operand_a), 
        .DATA3({1'b1, 1'b1, 1'b1, 1'b0, 1'b1}), .CONTROL1(N163), .CONTROL2(
        N164), .CONTROL3(N165), .Z(next_operand_a) );
  SELECT_OP C4515 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA2(offset_a), .CONTROL1(N167), .CONTROL2(N164), .Z(next_offset_a) );
  GTECH_BUF B_167 ( .A(N1663), .Z(N167) );
  SELECT_OP C4516 ( .DATA1(N861), .DATA2(pc_mask_bit), .DATA3(1'b0), 
        .CONTROL1(N163), .CONTROL2(N164), .CONTROL3(N165), .Z(next_pc_mask_bit) );
  SELECT_OP C4517 ( .DATA1({N866, N865, N864, N863, N862}), .DATA2(
        alu_stack_write_to_reg), .DATA3({1'b1, 1'b1, 1'b1, 1'b0, 1'b1}), 
        .CONTROL1(N163), .CONTROL2(N164), .CONTROL3(N165), .Z(
        next_alu_stack_write_to_reg) );
  SELECT_OP C4518 ( .DATA1(N867), .DATA2(1'b0), .CONTROL1(N163), .CONTROL2(
        N166), .Z(next_alu_stack_write_to_reg_enable) );
  SELECT_OP C4519 ( .DATA1({N872, N871, N870, N869, N868}), .DATA2(
        memory_write_to_reg), .DATA3({1'b1, 1'b1, 1'b1, 1'b0, 1'b1}), 
        .CONTROL1(N163), .CONTROL2(N164), .CONTROL3(N165), .Z(
        next_memory_write_to_reg) );
  SELECT_OP C4520 ( .DATA1(N873), .DATA2(memory_write_to_reg_enable), .DATA3(
        1'b0), .CONTROL1(N163), .CONTROL2(N164), .CONTROL3(N165), .Z(
        next_memory_write_to_reg_enable) );
  SELECT_OP C4521 ( .DATA1({N878, N877, N876, N875, N874}), .DATA2(
        memory_store_data_reg), .DATA3({1'b1, 1'b1, 1'b1, 1'b0, 1'b1}), 
        .CONTROL1(N163), .CONTROL2(N164), .CONTROL3(N165), .Z(
        next_memory_store_data_reg) );
  SELECT_OP C4522 ( .DATA1({N883, N882, N881, N880, N879}), .DATA2(
        memory_store_address_reg), .DATA3({1'b1, 1'b1, 1'b1, 1'b0, 1'b1}), 
        .CONTROL1(N163), .CONTROL2(N164), .CONTROL3(N165), .Z(
        next_memory_store_address_reg) );
  SELECT_OP C4523 ( .DATA1(N884), .DATA2(memory_address_source_is_reg), 
        .DATA3(1'b0), .CONTROL1(N163), .CONTROL2(N164), .CONTROL3(N165), .Z(
        next_memory_address_source_is_reg) );
  SELECT_OP C4524 ( .DATA1({N886, N885}), .DATA2(load_store_width), .DATA3({
        1'b1, 1'b0}), .CONTROL1(N163), .CONTROL2(N164), .CONTROL3(N165), .Z(
        next_load_store_width) );
  SELECT_OP C4525 ( .DATA1(N887), .DATA2(memorycontroller_sign_extend), 
        .DATA3(1'b0), .CONTROL1(N163), .CONTROL2(N164), .CONTROL3(N165), .Z(
        next_memorycontroller_sign_extend) );
  SELECT_OP C4526 ( .DATA1(N888), .DATA2(memory_load_request), .DATA3(1'b0), 
        .DATA4(1'b0), .CONTROL1(N163), .CONTROL2(N164), .CONTROL3(N5), 
        .CONTROL4(N216), .Z(next_memory_load_request) );
  SELECT_OP C4527 ( .DATA1(N889), .DATA2(memory_store_request), .DATA3(1'b0), 
        .DATA4(1'b0), .CONTROL1(N163), .CONTROL2(N164), .CONTROL3(N5), 
        .CONTROL4(N216), .Z(next_memory_store_request) );
  SELECT_OP C4528 ( .DATA1(N890), .DATA2(stall_to_instructionfetch), .DATA3(
        1'b0), .DATA4(1'b0), .CONTROL1(N163), .CONTROL2(N164), .CONTROL3(N5), 
        .CONTROL4(N216), .Z(next_stall_to_instructionfetch) );
  SELECT_OP C4529 ( .DATA1(N891), .DATA2(1'b0), .CONTROL1(N163), .CONTROL2(
        N166), .Z(next_update_flag_c) );
  SELECT_OP C4530 ( .DATA1(N892), .DATA2(1'b0), .CONTROL1(N163), .CONTROL2(
        N166), .Z(next_update_flag_v) );
  SELECT_OP C4531 ( .DATA1({N897, N896, N895, N894, N893}), .DATA2(operand_b), 
        .DATA3({1'b1, 1'b1, 1'b1, 1'b0, 1'b1}), .CONTROL1(N163), .CONTROL2(
        N164), .CONTROL3(N165), .Z(next_operand_b) );
  SELECT_OP C4532 ( .DATA1({N921, N921, N921, N921, N921, N921, N921, N921, 
        N921, N920, N919, N918, N917, N916, N915, N914, N913, N912, N911, N910, 
        N909, N908, N907, N906, N905, N904, N903, N902, N901, N900, N899, N898}), .DATA2(offset_b), .DATA3({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .CONTROL1(N163), .CONTROL2(N164), .CONTROL3(N165), .Z(next_offset_b) );
  GTECH_OR2 C4535 ( .A(N1666), .B(N1667), .Z(N168) );
  GTECH_OR2 C4536 ( .A(N1664), .B(N1665), .Z(N1666) );
  GTECH_AND2 C4537 ( .A(N1011), .B(next_alu_stack_write_to_reg_enable), .Z(
        N1664) );
  GTECH_AND2 C4538 ( .A(N1020), .B(next_memory_write_to_reg_enable), .Z(N1665)
         );
  GTECH_AND2 C4539 ( .A(1'b0), .B(instruction[8]), .Z(N1667) );
  GTECH_BUF B_168 ( .A(N168), .Z(next_decoder_pc_update) );
  GTECH_AND2 C4541 ( .A(N1670), .B(N1676), .Z(N169) );
  GTECH_AND2 C4542 ( .A(N1668), .B(N1669), .Z(N1670) );
  GTECH_OR2 C4543 ( .A(next_stall_to_instructionfetch), .B(instruction_valid), 
        .Z(N1668) );
  GTECH_NOT I_73 ( .A(reset), .Z(N1669) );
  GTECH_NOT I_74 ( .A(N1675), .Z(N1676) );
  GTECH_OR2 C4546 ( .A(N1672), .B(N1674), .Z(N1675) );
  GTECH_AND2 C4547 ( .A(next_memory_store_request), .B(N1671), .Z(N1672) );
  GTECH_NOT I_75 ( .A(memory_write_finished), .Z(N1671) );
  GTECH_AND2 C4549 ( .A(next_memory_load_request), .B(N1673), .Z(N1674) );
  GTECH_NOT I_76 ( .A(memory_read_finished), .Z(N1673) );
  GTECH_OR2 C4553 ( .A(reset), .B(N169), .Z(N170) );
  GTECH_NOT I_77 ( .A(N170), .Z(N171) );
  GTECH_NOT I_78 ( .A(instruction[14]), .Z(N172) );
  GTECH_NOT I_79 ( .A(N179), .Z(N180) );
  GTECH_NOT I_80 ( .A(instruction[3]), .Z(N181) );
  GTECH_NOT I_81 ( .A(instruction[2]), .Z(N182) );
  GTECH_NOT I_82 ( .A(instruction[1]), .Z(N183) );
  GTECH_NOT I_83 ( .A(instruction[0]), .Z(N184) );
  GTECH_NOT I_84 ( .A(N187), .Z(N188) );
  GTECH_AND2 C4566 ( .A(N1678), .B(N1682), .Z(N212) );
  GTECH_AND2 C4567 ( .A(N1677), .B(N1669), .Z(N1678) );
  GTECH_OR2 C4568 ( .A(next_stall_to_instructionfetch), .B(instruction_valid), 
        .Z(N1677) );
  GTECH_NOT I_85 ( .A(N1681), .Z(N1682) );
  GTECH_OR2 C4571 ( .A(N1679), .B(N1680), .Z(N1681) );
  GTECH_AND2 C4572 ( .A(next_memory_store_request), .B(N1671), .Z(N1679) );
  GTECH_AND2 C4574 ( .A(next_memory_load_request), .B(N1673), .Z(N1680) );
  GTECH_AND2 C4576 ( .A(N1685), .B(N1669), .Z(N213) );
  GTECH_OR2 C4577 ( .A(N1683), .B(N1684), .Z(N1685) );
  GTECH_AND2 C4578 ( .A(next_memory_store_request), .B(N1671), .Z(N1683) );
  GTECH_AND2 C4580 ( .A(next_memory_load_request), .B(N1673), .Z(N1684) );
  GTECH_OR2 C4585 ( .A(N213), .B(N212), .Z(N214) );
  GTECH_OR2 C4586 ( .A(reset), .B(N214), .Z(N215) );
  GTECH_NOT I_86 ( .A(N215), .Z(N216) );
  GTECH_NOT I_87 ( .A(itstate[7]), .Z(N217) );
  GTECH_NOT I_88 ( .A(itstate[6]), .Z(N218) );
  GTECH_NOT I_89 ( .A(itstate[5]), .Z(N219) );
  GTECH_NOT I_90 ( .A(itstate[4]), .Z(N220) );
  GTECH_NOT I_91 ( .A(N226), .Z(N227) );
  GTECH_NOT I_92 ( .A(N230), .Z(N231) );
  GTECH_NOT I_93 ( .A(N234), .Z(N235) );
  GTECH_NOT I_94 ( .A(N238), .Z(N239) );
  GTECH_NOT I_95 ( .A(N242), .Z(N243) );
  GTECH_NOT I_96 ( .A(N246), .Z(N247) );
  GTECH_NOT I_97 ( .A(N250), .Z(N251) );
  GTECH_NOT I_98 ( .A(N254), .Z(N255) );
  GTECH_NOT I_99 ( .A(N258), .Z(N259) );
  GTECH_NOT I_100 ( .A(N262), .Z(N263) );
  GTECH_NOT I_101 ( .A(N266), .Z(N267) );
  GTECH_NOT I_102 ( .A(N270), .Z(N271) );
  GTECH_NOT I_103 ( .A(N274), .Z(N275) );
  GTECH_NOT I_104 ( .A(N278), .Z(N279) );
  GTECH_OR2 C4650 ( .A(N1606), .B(N283), .Z(N284) );
  GTECH_NOT I_105 ( .A(N284), .Z(N285) );
  GTECH_NOT I_106 ( .A(instruction[15]), .Z(N286) );
  GTECH_NOT I_107 ( .A(instruction[13]), .Z(N287) );
  GTECH_OR2 C4671 ( .A(N339), .B(N1689), .Z(N350) );
  GTECH_OR2 C4672 ( .A(N341), .B(N1688), .Z(N1689) );
  GTECH_OR2 C4673 ( .A(N343), .B(N1687), .Z(N1688) );
  GTECH_OR2 C4674 ( .A(N345), .B(N1686), .Z(N1687) );
  GTECH_OR2 C4675 ( .A(N347), .B(N349), .Z(N1686) );
  GTECH_NOT I_108 ( .A(N352), .Z(N353) );
  GTECH_NOT I_109 ( .A(N354), .Z(N355) );
  GTECH_NOT I_110 ( .A(instruction[9]), .Z(N363) );
  GTECH_NOT I_111 ( .A(instruction[6]), .Z(N393) );
  GTECH_NOT I_112 ( .A(N397), .Z(N398) );
  GTECH_NOT I_113 ( .A(N399), .Z(N400) );
  GTECH_NOT I_114 ( .A(N401), .Z(N402) );
  GTECH_NOT I_115 ( .A(N403), .Z(N404) );
  GTECH_NOT I_116 ( .A(N405), .Z(N406) );
  GTECH_NOT I_117 ( .A(N407), .Z(N408) );
  GTECH_NOT I_118 ( .A(N409), .Z(N410) );
  GTECH_NOT I_119 ( .A(N412), .Z(N413) );
  GTECH_NOT I_120 ( .A(N414), .Z(N415) );
  GTECH_NOT I_121 ( .A(N417), .Z(N418) );
  GTECH_NOT I_122 ( .A(N420), .Z(N421) );
  GTECH_NOT I_123 ( .A(N422), .Z(N423) );
  GTECH_NOT I_124 ( .A(N424), .Z(N425) );
  GTECH_NOT I_125 ( .A(N426), .Z(N427) );
  GTECH_NOT I_126 ( .A(N725), .Z(N443) );
  GTECH_NOT I_127 ( .A(N728), .Z(N444) );
  GTECH_NOT I_128 ( .A(instruction[10]), .Z(N462) );
  GTECH_NOT I_129 ( .A(N734), .Z(N463) );
  GTECH_NOT I_130 ( .A(N744), .Z(N464) );
  GTECH_NOT I_131 ( .A(instruction[12]), .Z(N482) );
  GTECH_NOT I_132 ( .A(instruction[11]), .Z(N495) );
  GTECH_NOT I_133 ( .A(instruction[7]), .Z(N496) );
  GTECH_NOT I_134 ( .A(N504), .Z(N505) );
  GTECH_NOT I_135 ( .A(N513), .Z(N514) );
  GTECH_NOT I_136 ( .A(N522), .Z(N523) );
  GTECH_NOT I_137 ( .A(N531), .Z(N532) );
  GTECH_NOT I_138 ( .A(instruction[4]), .Z(N533) );
  GTECH_NOT I_139 ( .A(N541), .Z(N542) );
  GTECH_NOT I_140 ( .A(instruction[5]), .Z(N543) );
  GTECH_NOT I_141 ( .A(N551), .Z(N552) );
  GTECH_NOT I_142 ( .A(N560), .Z(N561) );
  GTECH_NOT I_143 ( .A(N569), .Z(N570) );
  GTECH_NOT I_144 ( .A(N578), .Z(N579) );
  GTECH_NOT I_145 ( .A(N633), .Z(N634) );
  GTECH_NOT I_146 ( .A(N640), .Z(N641) );
  GTECH_NOT I_147 ( .A(N647), .Z(N648) );
  GTECH_NOT I_148 ( .A(N654), .Z(N655) );
  GTECH_NOT I_149 ( .A(N661), .Z(N662) );
  GTECH_NOT I_150 ( .A(N668), .Z(N669) );
  GTECH_NOT I_151 ( .A(N675), .Z(N676) );
  GTECH_NOT I_152 ( .A(N682), .Z(N683) );
  GTECH_OR2 C4942 ( .A(N178), .B(N759), .Z(N718) );
  GTECH_NOT I_153 ( .A(N718), .Z(N719) );
  GTECH_NOT I_154 ( .A(instruction[8]), .Z(N720) );
  GTECH_NOT I_155 ( .A(N726), .Z(N727) );
  GTECH_NOT I_156 ( .A(N729), .Z(N730) );
  GTECH_NOT I_157 ( .A(N732), .Z(N733) );
  GTECH_NOT I_158 ( .A(N736), .Z(N737) );
  GTECH_NOT I_159 ( .A(N738), .Z(N739) );
  GTECH_NOT I_160 ( .A(N740), .Z(N741) );
  GTECH_NOT I_161 ( .A(N742), .Z(N743) );
  GTECH_NOT I_162 ( .A(N745), .Z(N746) );
  GTECH_NOT I_163 ( .A(N747), .Z(N748) );
  GTECH_NOT I_164 ( .A(N749), .Z(N750) );
  GTECH_NOT I_165 ( .A(N751), .Z(N752) );
  GTECH_NOT I_166 ( .A(N754), .Z(N755) );
  GTECH_NOT I_167 ( .A(N756), .Z(N757) );
  GTECH_NOT I_168 ( .A(N758), .Z(N759) );
  GTECH_NOT I_169 ( .A(flag_z), .Z(N760) );
  GTECH_NOT I_170 ( .A(flag_c), .Z(N761) );
  GTECH_NOT I_171 ( .A(flag_n), .Z(N762) );
  GTECH_NOT I_172 ( .A(flag_v), .Z(N763) );
  GTECH_AND2 C4987 ( .A(flag_c), .B(N760), .Z(N764) );
  GTECH_OR2 C4990 ( .A(N761), .B(flag_z), .Z(N765) );
  GTECH_OR2 C4993 ( .A(N1690), .B(N1691), .Z(N766) );
  GTECH_AND2 C4994 ( .A(flag_n), .B(flag_v), .Z(N1690) );
  GTECH_AND2 C4995 ( .A(N762), .B(N763), .Z(N1691) );
  GTECH_OR2 C4999 ( .A(N1692), .B(N1693), .Z(N767) );
  GTECH_AND2 C5000 ( .A(flag_n), .B(N763), .Z(N1692) );
  GTECH_AND2 C5002 ( .A(N762), .B(flag_v), .Z(N1693) );
  GTECH_AND2 C5005 ( .A(N760), .B(N1696), .Z(N768) );
  GTECH_OR2 C5007 ( .A(N1694), .B(N1695), .Z(N1696) );
  GTECH_AND2 C5008 ( .A(flag_n), .B(flag_v), .Z(N1694) );
  GTECH_AND2 C5009 ( .A(N762), .B(N763), .Z(N1695) );
  GTECH_OR2 C5013 ( .A(flag_z), .B(N1699), .Z(N769) );
  GTECH_OR2 C5014 ( .A(N1697), .B(N1698), .Z(N1699) );
  GTECH_AND2 C5015 ( .A(flag_n), .B(N763), .Z(N1697) );
  GTECH_AND2 C5017 ( .A(N762), .B(flag_v), .Z(N1698) );
  GTECH_AND2 C5023 ( .A(N514), .B(N504), .Z(N928) );
  GTECH_AND2 C5025 ( .A(N504), .B(N513), .Z(N929) );
  GTECH_AND2 C5026 ( .A(N523), .B(N929), .Z(N930) );
  GTECH_AND2 C5028 ( .A(N929), .B(N522), .Z(N931) );
  GTECH_AND2 C5029 ( .A(N532), .B(N931), .Z(N932) );
  GTECH_AND2 C5031 ( .A(N931), .B(N531), .Z(N933) );
  GTECH_AND2 C5032 ( .A(N542), .B(N933), .Z(N934) );
  GTECH_AND2 C5034 ( .A(N933), .B(N541), .Z(N935) );
  GTECH_AND2 C5035 ( .A(N552), .B(N935), .Z(N936) );
  GTECH_AND2 C5037 ( .A(N935), .B(N551), .Z(N937) );
  GTECH_AND2 C5038 ( .A(N561), .B(N937), .Z(N938) );
  GTECH_AND2 C5040 ( .A(N937), .B(N560), .Z(N939) );
  GTECH_AND2 C5041 ( .A(N570), .B(N939), .Z(N940) );
  GTECH_AND2 C5043 ( .A(N939), .B(N569), .Z(N941) );
  GTECH_AND2 C5044 ( .A(N579), .B(N941), .Z(N942) );
  GTECH_AND2 C5046 ( .A(N941), .B(N578), .Z(N943) );
  GTECH_AND2 C5047 ( .A(instruction[0]), .B(N943), .Z(N944) );
  GTECH_NOT I_173 ( .A(instruction[0]), .Z(N945) );
  GTECH_AND2 C5049 ( .A(N943), .B(N945), .Z(N946) );
  GTECH_AND2 C5050 ( .A(N580), .B(N946), .Z(N947) );
  GTECH_NOT I_174 ( .A(N580), .Z(N948) );
  GTECH_AND2 C5052 ( .A(N946), .B(N948), .Z(N949) );
  GTECH_AND2 C5053 ( .A(N582), .B(N949), .Z(N950) );
  GTECH_NOT I_175 ( .A(N582), .Z(N951) );
  GTECH_AND2 C5055 ( .A(N949), .B(N951), .Z(N952) );
  GTECH_AND2 C5056 ( .A(N584), .B(N952), .Z(N953) );
  GTECH_NOT I_176 ( .A(N584), .Z(N954) );
  GTECH_AND2 C5058 ( .A(N952), .B(N954), .Z(N955) );
  GTECH_AND2 C5059 ( .A(N588), .B(N955), .Z(N956) );
  GTECH_NOT I_177 ( .A(N588), .Z(N957) );
  GTECH_AND2 C5061 ( .A(N955), .B(N957), .Z(N958) );
  GTECH_AND2 C5062 ( .A(N591), .B(N958), .Z(N959) );
  GTECH_NOT I_178 ( .A(N591), .Z(N960) );
  GTECH_AND2 C5064 ( .A(N958), .B(N960), .Z(N961) );
  GTECH_AND2 C5065 ( .A(N597), .B(N961), .Z(N962) );
  GTECH_NOT I_179 ( .A(N597), .Z(N963) );
  GTECH_AND2 C5067 ( .A(N961), .B(N963), .Z(N964) );
  GTECH_AND2 C5068 ( .A(N601), .B(N964), .Z(N965) );
  GTECH_NOT I_180 ( .A(N601), .Z(N966) );
  GTECH_AND2 C5070 ( .A(N964), .B(N966), .Z(N967) );
  GTECH_AND2 C5071 ( .A(N609), .B(N967), .Z(N614) );
  GTECH_AND2 C5073 ( .A(N641), .B(N633), .Z(N968) );
  GTECH_AND2 C5075 ( .A(N633), .B(N640), .Z(N969) );
  GTECH_AND2 C5076 ( .A(N648), .B(N969), .Z(N970) );
  GTECH_AND2 C5078 ( .A(N969), .B(N647), .Z(N971) );
  GTECH_AND2 C5079 ( .A(N655), .B(N971), .Z(N972) );
  GTECH_AND2 C5081 ( .A(N971), .B(N654), .Z(N973) );
  GTECH_AND2 C5082 ( .A(N662), .B(N973), .Z(N974) );
  GTECH_AND2 C5084 ( .A(N973), .B(N661), .Z(N975) );
  GTECH_AND2 C5085 ( .A(N669), .B(N975), .Z(N976) );
  GTECH_AND2 C5087 ( .A(N975), .B(N668), .Z(N977) );
  GTECH_AND2 C5088 ( .A(N676), .B(N977), .Z(N978) );
  GTECH_AND2 C5090 ( .A(N977), .B(N675), .Z(N979) );
  GTECH_AND2 C5091 ( .A(N683), .B(N979), .Z(N980) );
  GTECH_AND2 C5093 ( .A(N979), .B(N682), .Z(N981) );
  GTECH_AND2 C5094 ( .A(instruction[0]), .B(N981), .Z(N982) );
  GTECH_AND2 C5096 ( .A(N981), .B(N945), .Z(N983) );
  GTECH_AND2 C5097 ( .A(N684), .B(N983), .Z(N984) );
  GTECH_NOT I_181 ( .A(N684), .Z(N985) );
  GTECH_AND2 C5099 ( .A(N983), .B(N985), .Z(N986) );
  GTECH_AND2 C5100 ( .A(N686), .B(N986), .Z(N987) );
  GTECH_NOT I_182 ( .A(N686), .Z(N988) );
  GTECH_AND2 C5102 ( .A(N986), .B(N988), .Z(N989) );
  GTECH_AND2 C5103 ( .A(N688), .B(N989), .Z(N990) );
  GTECH_NOT I_183 ( .A(N688), .Z(N991) );
  GTECH_AND2 C5105 ( .A(N989), .B(N991), .Z(N992) );
  GTECH_AND2 C5106 ( .A(N692), .B(N992), .Z(N993) );
  GTECH_NOT I_184 ( .A(N692), .Z(N994) );
  GTECH_AND2 C5108 ( .A(N992), .B(N994), .Z(N995) );
  GTECH_AND2 C5109 ( .A(N695), .B(N995), .Z(N996) );
  GTECH_NOT I_185 ( .A(N695), .Z(N997) );
  GTECH_AND2 C5111 ( .A(N995), .B(N997), .Z(N998) );
  GTECH_AND2 C5112 ( .A(N701), .B(N998), .Z(N999) );
  GTECH_NOT I_186 ( .A(N701), .Z(N1000) );
  GTECH_AND2 C5114 ( .A(N998), .B(N1000), .Z(N1001) );
  GTECH_AND2 C5115 ( .A(N704), .B(N1001), .Z(N1002) );
endmodule


module register_file ( readA_sel, readB_sel, readC_sel, readD_sel, write1_sel, 
        write2_sel, write1_en, write2_en, write1_in, write2_in, immediate1_in, 
        immediate2_in, next_pc_in, next_cpsr_in, next_sp_in, next_pc_en, clk, 
        reset, regA_out, regB_out, regC_out, regD_out, pc_out, cpsr_out, 
        sp_out );
  input [4:0] readA_sel;
  input [4:0] readB_sel;
  input [4:0] readC_sel;
  input [4:0] readD_sel;
  input [4:0] write1_sel;
  input [4:0] write2_sel;
  input [31:0] write1_in;
  input [31:0] write2_in;
  input [31:0] immediate1_in;
  input [31:0] immediate2_in;
  input [31:0] next_pc_in;
  input [3:0] next_cpsr_in;
  input [31:0] next_sp_in;
  output [31:0] regA_out;
  output [31:0] regB_out;
  output [31:0] regC_out;
  output [31:0] regD_out;
  output [31:0] pc_out;
  output [3:0] cpsr_out;
  output [31:0] sp_out;
  input write1_en, write2_en, next_pc_en, clk, reset;
  wire   N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15,
         N16, N17, N18, N19, N20, N21, N22, N23, N24, N25, N26, N27, N28, N29,
         N30, N31, N32, N33, N34, N35, N36, N37, N38, N39, N40, N41, N42, N43,
         N44, N45, N46, N47, N48, N49, N50, N51, N52, N53, N54, N55, N56, N57,
         N58, N59, N60, N61, N62, N63, N64, N65, N66, N67, N68, N69, N70, N71,
         N72, N73, N74, N75, N76, N77, N78, N79, N80, N81, N82, N83, N84, N85,
         N86, N87, N88, N89, N90, N91, N92, N93, N94, N95, N96, N97, N98, N99,
         N100, N101, N102, N103, N104, N105, N106, N107, N108, N109, N110,
         N111, N112, N113, N114, N115, N116, N117, N118, N119, N120, N121,
         N122, N123, N124, N125, N126, N127, N128, N129, N130, N131, N132,
         N133, N134, N135, N136, N137, N138, N139, N140, N141, N142, N143,
         N144, N145, N146, N147, N148, N149, N150, N151, N152, N153, N154,
         N155, N156, N157, N158, N159, N160, N161, N162, N163, N164, N165,
         N166, N167, N168, N169, N170, N171, N172, N173, N174, N175, N176,
         N177, N178, N179, N180, N181, N182, N183, N184, N185, N186, N187,
         N188, N189, N190, N191, N192, N193, N194, N195, N196, N197, N198,
         N199, N200, N201, N202, N203, N204, N205, N206, N207, N208, N209,
         N210, N211, N212, N213, N214, N215, N216, N217, N218, N219, N220,
         N221, N222, N223, N224, N225, N226, N227, N228, N229, N230, N231,
         N232, N233, N234, N235, N236, N237, N238, N239, N240, N241, N242,
         N243, N244, N245, N246, N247, N248, N249, N250, N251, N252, N253,
         N254, N255, N256, N257, N258, N259, N260, N261, N262, N263, N264,
         N265, N266, N267, N268, N269, N270, N271, N272, N273, N274, N275,
         N276, N277, N278, N279, N280, N281, N282, N283, N284, N285, N286,
         N287, N288, N289, N290, N291, N292, N293, N294, N295, N296, N297,
         N298, N299, N300, N301, N302, N303, N304, N305, N306, N307, N308,
         N309, N310, N311, N312, N313, N314, N315, N316, N317, N318, N319,
         N320, N321, N322, N323, N324, N325, N326, N327, N328, N329, N330,
         N331, N332, N333, N334, N335, N336, N337, N338, N339, N340, N341,
         N342, N343, N344, N345, N346, N347, N348, N349, N350, N351, N352,
         N353, N354, N355, N356, N357, N358, N359, N360, N361, N362, N363,
         N364, N365, N366, N367, N368, N369, N370, N371, N372, N373, N374,
         N375, N376, N377, N378, N379, N380, N381, N382, N383, N384, N385,
         N386, N387, N388, N389, N390, N391, N392, N393, N394, N395, N396,
         N397, N398, N399, N400, N401, N402, N403, N404, N405, N406, N407,
         N408, N409, N410, N411, N412, N413, N414, N415, N416, N417, N418,
         N419, N420, N421, N422, N423, N424, N425, N426, N427, N428, N429,
         N430, N431, N432, N433, N434, N435, N436, N437, N438, N439, N440,
         N441, N442, N443, N444, N445, N446, N447, N448, N449, N450, N451,
         N452, N453, N454, N455, N456, N457, N458, N459, N460, N461, N462,
         N463, N464, N465, N466, N467, N468, N469, N470, N471, N472, N473,
         N474, N475, N476, N477, N478, N479, N480, N481, N482, N483, N484,
         N485, N486, N487, pc_write_select, N488, N489, N490, N491, N492, N493,
         N494, N495, N496, N497, N498, N499, N500, N501, N502, N503, N504,
         N505, N506, N507, N508, N509, N510, N511, N512, N513, N514, N515,
         N516, N517, N518, N519, N520, N521, N522, N523, N524, N525, N526,
         N527, N528, N529, N530, N531, N532, N533, N534, N535, N536, N537,
         N538, N539, N540, N541, N542, N543, N544, N545, N546, N547, N548,
         N549, N550, N551, N552, N553, N554, N555, N556, N557, N558, N559,
         N560, N561, N562, N563, N564, N565, N566, N567, N568, N569, N570,
         N571, N572, N573, N574, N575, N576, N577, N578, N579, N580, N581,
         N582, N583, N584, N585, N586, N587, N588, N589, N590, N591, N592,
         N593, N594, N595, N596, N597, N598, N599, N600, N601, N602, N603,
         N604, N605, N606, N607, N608, N609, N610, N611, N612, N613, N614,
         N615, N616, N617, N618, N619, N620;
  wire   [31:0] r0;
  wire   [31:0] r1;
  wire   [31:0] r2;
  wire   [31:0] r3;
  wire   [31:0] r4;
  wire   [31:0] r5;
  wire   [31:0] r6;
  wire   [31:0] r7;
  wire   [31:0] r8;
  wire   [31:0] r9;
  wire   [31:0] r10;
  wire   [31:0] r11;
  wire   [31:0] r12;
  wire   [31:0] lr;
  wire   [31:0] tmp1;
  wire   [31:0] r0in;
  wire   [31:0] r1in;
  wire   [31:0] r2in;
  wire   [31:0] r3in;
  wire   [31:0] r4in;
  wire   [31:0] r5in;
  wire   [31:0] r6in;
  wire   [31:0] r7in;
  wire   [31:0] r8in;
  wire   [31:0] r9in;
  wire   [31:0] r10in;
  wire   [31:0] r11in;
  wire   [31:0] r12in;
  wire   [31:0] spin;
  wire   [31:0] lrin;
  wire   [31:0] pc_write_in;
  wire   [31:0] pc_write_in_plus_two;
  wire   [31:0] pcin;
  wire   [31:0] tmp1in;
  wire   [3:0] cpsrin;

  GTECH_AND2 C9 ( .A(N77), .B(N135), .Z(N79) );
  GTECH_AND2 C10 ( .A(N137), .B(N139), .Z(N80) );
  GTECH_AND2 C11 ( .A(N79), .B(N80), .Z(N81) );
  GTECH_AND2 C12 ( .A(N81), .B(N78), .Z(N82) );
  GTECH_OR2 C14 ( .A(readA_sel[4]), .B(readA_sel[3]), .Z(N83) );
  GTECH_OR2 C15 ( .A(readA_sel[2]), .B(readA_sel[1]), .Z(N84) );
  GTECH_OR2 C16 ( .A(N83), .B(N84), .Z(N85) );
  GTECH_OR2 C17 ( .A(N85), .B(N78), .Z(N86) );
  GTECH_OR2 C21 ( .A(readA_sel[2]), .B(N139), .Z(N88) );
  GTECH_OR2 C22 ( .A(N83), .B(N88), .Z(N89) );
  GTECH_OR2 C23 ( .A(N89), .B(readA_sel[0]), .Z(N90) );
  GTECH_OR2 C30 ( .A(N89), .B(N78), .Z(N92) );
  GTECH_OR2 C34 ( .A(N137), .B(readA_sel[1]), .Z(N94) );
  GTECH_OR2 C35 ( .A(N83), .B(N94), .Z(N95) );
  GTECH_OR2 C36 ( .A(N95), .B(readA_sel[0]), .Z(N96) );
  GTECH_OR2 C43 ( .A(N95), .B(N78), .Z(N98) );
  GTECH_OR2 C48 ( .A(N137), .B(N139), .Z(N100) );
  GTECH_OR2 C49 ( .A(N83), .B(N100), .Z(N101) );
  GTECH_OR2 C50 ( .A(N101), .B(readA_sel[0]), .Z(N102) );
  GTECH_OR2 C58 ( .A(N101), .B(N78), .Z(N104) );
  GTECH_OR2 C61 ( .A(readA_sel[4]), .B(N135), .Z(N106) );
  GTECH_OR2 C63 ( .A(N106), .B(N84), .Z(N107) );
  GTECH_OR2 C64 ( .A(N107), .B(readA_sel[0]), .Z(N108) );
  GTECH_OR2 C71 ( .A(N107), .B(N78), .Z(N110) );
  GTECH_OR2 C77 ( .A(N106), .B(N88), .Z(N112) );
  GTECH_OR2 C78 ( .A(N112), .B(readA_sel[0]), .Z(N113) );
  GTECH_OR2 C86 ( .A(N112), .B(N78), .Z(N115) );
  GTECH_OR2 C92 ( .A(N106), .B(N94), .Z(N117) );
  GTECH_OR2 C93 ( .A(N117), .B(readA_sel[0]), .Z(N118) );
  GTECH_OR2 C101 ( .A(N117), .B(N78), .Z(N120) );
  GTECH_OR2 C108 ( .A(N106), .B(N100), .Z(N122) );
  GTECH_OR2 C109 ( .A(N122), .B(readA_sel[0]), .Z(N123) );
  GTECH_OR2 C118 ( .A(N122), .B(N78), .Z(N125) );
  GTECH_OR2 C124 ( .A(N77), .B(N135), .Z(N127) );
  GTECH_OR2 C126 ( .A(N127), .B(N100), .Z(N128) );
  GTECH_OR2 C127 ( .A(N128), .B(readA_sel[0]), .Z(N129) );
  GTECH_AND2 C129 ( .A(readA_sel[4]), .B(readA_sel[3]), .Z(N131) );
  GTECH_AND2 C130 ( .A(readA_sel[2]), .B(readA_sel[1]), .Z(N132) );
  GTECH_AND2 C131 ( .A(N131), .B(N132), .Z(N133) );
  GTECH_AND2 C132 ( .A(N133), .B(readA_sel[0]), .Z(N134) );
  GTECH_AND2 C134 ( .A(readA_sel[4]), .B(N135), .Z(N136) );
  GTECH_AND2 C136 ( .A(readA_sel[4]), .B(N137), .Z(N138) );
  GTECH_AND2 C138 ( .A(readA_sel[4]), .B(N139), .Z(N140) );
  GTECH_AND2 C215 ( .A(N142), .B(N200), .Z(N144) );
  GTECH_AND2 C216 ( .A(N202), .B(N204), .Z(N145) );
  GTECH_AND2 C217 ( .A(N144), .B(N145), .Z(N146) );
  GTECH_AND2 C218 ( .A(N146), .B(N143), .Z(N147) );
  GTECH_OR2 C220 ( .A(readB_sel[4]), .B(readB_sel[3]), .Z(N148) );
  GTECH_OR2 C221 ( .A(readB_sel[2]), .B(readB_sel[1]), .Z(N149) );
  GTECH_OR2 C222 ( .A(N148), .B(N149), .Z(N150) );
  GTECH_OR2 C223 ( .A(N150), .B(N143), .Z(N151) );
  GTECH_OR2 C227 ( .A(readB_sel[2]), .B(N204), .Z(N153) );
  GTECH_OR2 C228 ( .A(N148), .B(N153), .Z(N154) );
  GTECH_OR2 C229 ( .A(N154), .B(readB_sel[0]), .Z(N155) );
  GTECH_OR2 C236 ( .A(N154), .B(N143), .Z(N157) );
  GTECH_OR2 C240 ( .A(N202), .B(readB_sel[1]), .Z(N159) );
  GTECH_OR2 C241 ( .A(N148), .B(N159), .Z(N160) );
  GTECH_OR2 C242 ( .A(N160), .B(readB_sel[0]), .Z(N161) );
  GTECH_OR2 C249 ( .A(N160), .B(N143), .Z(N163) );
  GTECH_OR2 C254 ( .A(N202), .B(N204), .Z(N165) );
  GTECH_OR2 C255 ( .A(N148), .B(N165), .Z(N166) );
  GTECH_OR2 C256 ( .A(N166), .B(readB_sel[0]), .Z(N167) );
  GTECH_OR2 C264 ( .A(N166), .B(N143), .Z(N169) );
  GTECH_OR2 C267 ( .A(readB_sel[4]), .B(N200), .Z(N171) );
  GTECH_OR2 C269 ( .A(N171), .B(N149), .Z(N172) );
  GTECH_OR2 C270 ( .A(N172), .B(readB_sel[0]), .Z(N173) );
  GTECH_OR2 C277 ( .A(N172), .B(N143), .Z(N175) );
  GTECH_OR2 C283 ( .A(N171), .B(N153), .Z(N177) );
  GTECH_OR2 C284 ( .A(N177), .B(readB_sel[0]), .Z(N178) );
  GTECH_OR2 C292 ( .A(N177), .B(N143), .Z(N180) );
  GTECH_OR2 C298 ( .A(N171), .B(N159), .Z(N182) );
  GTECH_OR2 C299 ( .A(N182), .B(readB_sel[0]), .Z(N183) );
  GTECH_OR2 C307 ( .A(N182), .B(N143), .Z(N185) );
  GTECH_OR2 C314 ( .A(N171), .B(N165), .Z(N187) );
  GTECH_OR2 C315 ( .A(N187), .B(readB_sel[0]), .Z(N188) );
  GTECH_OR2 C324 ( .A(N187), .B(N143), .Z(N190) );
  GTECH_OR2 C330 ( .A(N142), .B(N200), .Z(N192) );
  GTECH_OR2 C332 ( .A(N192), .B(N165), .Z(N193) );
  GTECH_OR2 C333 ( .A(N193), .B(readB_sel[0]), .Z(N194) );
  GTECH_AND2 C335 ( .A(readB_sel[4]), .B(readB_sel[3]), .Z(N196) );
  GTECH_AND2 C336 ( .A(readB_sel[2]), .B(readB_sel[1]), .Z(N197) );
  GTECH_AND2 C337 ( .A(N196), .B(N197), .Z(N198) );
  GTECH_AND2 C338 ( .A(N198), .B(readB_sel[0]), .Z(N199) );
  GTECH_AND2 C340 ( .A(readB_sel[4]), .B(N200), .Z(N201) );
  GTECH_AND2 C342 ( .A(readB_sel[4]), .B(N202), .Z(N203) );
  GTECH_AND2 C344 ( .A(readB_sel[4]), .B(N204), .Z(N205) );
  GTECH_AND2 C424 ( .A(N208), .B(N209), .Z(N212) );
  GTECH_AND2 C425 ( .A(N210), .B(N211), .Z(N213) );
  GTECH_AND2 C426 ( .A(N212), .B(N213), .Z(N214) );
  GTECH_OR2 C428 ( .A(readC_sel[3]), .B(readC_sel[2]), .Z(N215) );
  GTECH_OR2 C429 ( .A(readC_sel[1]), .B(N211), .Z(N216) );
  GTECH_OR2 C430 ( .A(N215), .B(N216), .Z(N217) );
  GTECH_OR2 C434 ( .A(N210), .B(readC_sel[0]), .Z(N219) );
  GTECH_OR2 C435 ( .A(N215), .B(N219), .Z(N220) );
  GTECH_OR2 C440 ( .A(N210), .B(N211), .Z(N222) );
  GTECH_OR2 C441 ( .A(N215), .B(N222), .Z(N223) );
  GTECH_OR2 C444 ( .A(readC_sel[3]), .B(N209), .Z(N225) );
  GTECH_OR2 C445 ( .A(readC_sel[1]), .B(readC_sel[0]), .Z(N226) );
  GTECH_OR2 C446 ( .A(N225), .B(N226), .Z(N227) );
  GTECH_OR2 C452 ( .A(N225), .B(N216), .Z(N229) );
  GTECH_OR2 C458 ( .A(N225), .B(N219), .Z(N231) );
  GTECH_OR2 C465 ( .A(N225), .B(N222), .Z(N233) );
  GTECH_OR2 C468 ( .A(N208), .B(readC_sel[2]), .Z(N235) );
  GTECH_OR2 C470 ( .A(N235), .B(N226), .Z(N236) );
  GTECH_OR2 C476 ( .A(N235), .B(N216), .Z(N238) );
  GTECH_OR2 C482 ( .A(N235), .B(N219), .Z(N240) );
  GTECH_OR2 C489 ( .A(N235), .B(N222), .Z(N242) );
  GTECH_OR2 C493 ( .A(N208), .B(N209), .Z(N244) );
  GTECH_OR2 C495 ( .A(N244), .B(N226), .Z(N245) );
  GTECH_OR2 C502 ( .A(N244), .B(N216), .Z(N247) );
  GTECH_OR2 C509 ( .A(N244), .B(N219), .Z(N249) );
  GTECH_AND2 C511 ( .A(readC_sel[3]), .B(readC_sel[2]), .Z(N251) );
  GTECH_AND2 C512 ( .A(readC_sel[1]), .B(readC_sel[0]), .Z(N252) );
  GTECH_AND2 C513 ( .A(N251), .B(N252), .Z(N253) );
  GTECH_AND2 C619 ( .A(N287), .B(N288), .Z(N291) );
  GTECH_AND2 C620 ( .A(N289), .B(N290), .Z(N292) );
  GTECH_AND2 C621 ( .A(N291), .B(N292), .Z(N293) );
  GTECH_OR2 C623 ( .A(readD_sel[3]), .B(readD_sel[2]), .Z(N294) );
  GTECH_OR2 C624 ( .A(readD_sel[1]), .B(N290), .Z(N295) );
  GTECH_OR2 C625 ( .A(N294), .B(N295), .Z(N296) );
  GTECH_OR2 C629 ( .A(N289), .B(readD_sel[0]), .Z(N298) );
  GTECH_OR2 C630 ( .A(N294), .B(N298), .Z(N299) );
  GTECH_OR2 C635 ( .A(N289), .B(N290), .Z(N301) );
  GTECH_OR2 C636 ( .A(N294), .B(N301), .Z(N302) );
  GTECH_OR2 C639 ( .A(readD_sel[3]), .B(N288), .Z(N304) );
  GTECH_OR2 C640 ( .A(readD_sel[1]), .B(readD_sel[0]), .Z(N305) );
  GTECH_OR2 C641 ( .A(N304), .B(N305), .Z(N306) );
  GTECH_OR2 C647 ( .A(N304), .B(N295), .Z(N308) );
  GTECH_OR2 C653 ( .A(N304), .B(N298), .Z(N310) );
  GTECH_OR2 C660 ( .A(N304), .B(N301), .Z(N312) );
  GTECH_OR2 C663 ( .A(N287), .B(readD_sel[2]), .Z(N314) );
  GTECH_OR2 C665 ( .A(N314), .B(N305), .Z(N315) );
  GTECH_OR2 C671 ( .A(N314), .B(N295), .Z(N317) );
  GTECH_OR2 C677 ( .A(N314), .B(N298), .Z(N319) );
  GTECH_OR2 C684 ( .A(N314), .B(N301), .Z(N321) );
  GTECH_OR2 C688 ( .A(N287), .B(N288), .Z(N323) );
  GTECH_OR2 C690 ( .A(N323), .B(N305), .Z(N324) );
  GTECH_OR2 C697 ( .A(N323), .B(N295), .Z(N326) );
  GTECH_OR2 C704 ( .A(N323), .B(N298), .Z(N328) );
  GTECH_AND2 C706 ( .A(readD_sel[3]), .B(readD_sel[2]), .Z(N330) );
  GTECH_AND2 C707 ( .A(readD_sel[1]), .B(readD_sel[0]), .Z(N331) );
  GTECH_AND2 C708 ( .A(N330), .B(N331), .Z(N332) );
  \**SEQGEN**  r0_reg_31_ ( .clear(1'b0), .preset(1'b0), .next_state(r0in[31]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r0[31]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N368) );
  \**SEQGEN**  r0_reg_30_ ( .clear(1'b0), .preset(1'b0), .next_state(r0in[30]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r0[30]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N368) );
  \**SEQGEN**  r0_reg_29_ ( .clear(1'b0), .preset(1'b0), .next_state(r0in[29]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r0[29]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N368) );
  \**SEQGEN**  r0_reg_28_ ( .clear(1'b0), .preset(1'b0), .next_state(r0in[28]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r0[28]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N368) );
  \**SEQGEN**  r0_reg_27_ ( .clear(1'b0), .preset(1'b0), .next_state(r0in[27]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r0[27]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N368) );
  \**SEQGEN**  r0_reg_26_ ( .clear(1'b0), .preset(1'b0), .next_state(r0in[26]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r0[26]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N368) );
  \**SEQGEN**  r0_reg_25_ ( .clear(1'b0), .preset(1'b0), .next_state(r0in[25]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r0[25]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N368) );
  \**SEQGEN**  r0_reg_24_ ( .clear(1'b0), .preset(1'b0), .next_state(r0in[24]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r0[24]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N368) );
  \**SEQGEN**  r0_reg_23_ ( .clear(1'b0), .preset(1'b0), .next_state(r0in[23]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r0[23]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N368) );
  \**SEQGEN**  r0_reg_22_ ( .clear(1'b0), .preset(1'b0), .next_state(r0in[22]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r0[22]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N368) );
  \**SEQGEN**  r0_reg_21_ ( .clear(1'b0), .preset(1'b0), .next_state(r0in[21]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r0[21]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N368) );
  \**SEQGEN**  r0_reg_20_ ( .clear(1'b0), .preset(1'b0), .next_state(r0in[20]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r0[20]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N368) );
  \**SEQGEN**  r0_reg_19_ ( .clear(1'b0), .preset(1'b0), .next_state(r0in[19]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r0[19]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N368) );
  \**SEQGEN**  r0_reg_18_ ( .clear(1'b0), .preset(1'b0), .next_state(r0in[18]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r0[18]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N368) );
  \**SEQGEN**  r0_reg_17_ ( .clear(1'b0), .preset(1'b0), .next_state(r0in[17]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r0[17]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N368) );
  \**SEQGEN**  r0_reg_16_ ( .clear(1'b0), .preset(1'b0), .next_state(r0in[16]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r0[16]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N368) );
  \**SEQGEN**  r0_reg_15_ ( .clear(1'b0), .preset(1'b0), .next_state(r0in[15]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r0[15]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N368) );
  \**SEQGEN**  r0_reg_14_ ( .clear(1'b0), .preset(1'b0), .next_state(r0in[14]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r0[14]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N368) );
  \**SEQGEN**  r0_reg_13_ ( .clear(1'b0), .preset(1'b0), .next_state(r0in[13]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r0[13]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N368) );
  \**SEQGEN**  r0_reg_12_ ( .clear(1'b0), .preset(1'b0), .next_state(r0in[12]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r0[12]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N368) );
  \**SEQGEN**  r0_reg_11_ ( .clear(1'b0), .preset(1'b0), .next_state(r0in[11]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r0[11]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N368) );
  \**SEQGEN**  r0_reg_10_ ( .clear(1'b0), .preset(1'b0), .next_state(r0in[10]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r0[10]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N368) );
  \**SEQGEN**  r0_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(r0in[9]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r0[9]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N368) );
  \**SEQGEN**  r0_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(r0in[8]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r0[8]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N368) );
  \**SEQGEN**  r0_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(r0in[7]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r0[7]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N368) );
  \**SEQGEN**  r0_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(r0in[6]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r0[6]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N368) );
  \**SEQGEN**  r0_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(r0in[5]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r0[5]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N368) );
  \**SEQGEN**  r0_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(r0in[4]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r0[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N368) );
  \**SEQGEN**  r0_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(r0in[3]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r0[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N368) );
  \**SEQGEN**  r0_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(r0in[2]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r0[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N368) );
  \**SEQGEN**  r0_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(r0in[1]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r0[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N368) );
  \**SEQGEN**  r0_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(r0in[0]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r0[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N368) );
  \**SEQGEN**  r1_reg_31_ ( .clear(1'b0), .preset(1'b0), .next_state(r1in[31]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r1[31]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N377) );
  \**SEQGEN**  r1_reg_30_ ( .clear(1'b0), .preset(1'b0), .next_state(r1in[30]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r1[30]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N377) );
  \**SEQGEN**  r1_reg_29_ ( .clear(1'b0), .preset(1'b0), .next_state(r1in[29]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r1[29]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N377) );
  \**SEQGEN**  r1_reg_28_ ( .clear(1'b0), .preset(1'b0), .next_state(r1in[28]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r1[28]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N377) );
  \**SEQGEN**  r1_reg_27_ ( .clear(1'b0), .preset(1'b0), .next_state(r1in[27]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r1[27]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N377) );
  \**SEQGEN**  r1_reg_26_ ( .clear(1'b0), .preset(1'b0), .next_state(r1in[26]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r1[26]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N377) );
  \**SEQGEN**  r1_reg_25_ ( .clear(1'b0), .preset(1'b0), .next_state(r1in[25]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r1[25]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N377) );
  \**SEQGEN**  r1_reg_24_ ( .clear(1'b0), .preset(1'b0), .next_state(r1in[24]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r1[24]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N377) );
  \**SEQGEN**  r1_reg_23_ ( .clear(1'b0), .preset(1'b0), .next_state(r1in[23]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r1[23]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N377) );
  \**SEQGEN**  r1_reg_22_ ( .clear(1'b0), .preset(1'b0), .next_state(r1in[22]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r1[22]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N377) );
  \**SEQGEN**  r1_reg_21_ ( .clear(1'b0), .preset(1'b0), .next_state(r1in[21]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r1[21]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N377) );
  \**SEQGEN**  r1_reg_20_ ( .clear(1'b0), .preset(1'b0), .next_state(r1in[20]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r1[20]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N377) );
  \**SEQGEN**  r1_reg_19_ ( .clear(1'b0), .preset(1'b0), .next_state(r1in[19]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r1[19]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N377) );
  \**SEQGEN**  r1_reg_18_ ( .clear(1'b0), .preset(1'b0), .next_state(r1in[18]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r1[18]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N377) );
  \**SEQGEN**  r1_reg_17_ ( .clear(1'b0), .preset(1'b0), .next_state(r1in[17]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r1[17]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N377) );
  \**SEQGEN**  r1_reg_16_ ( .clear(1'b0), .preset(1'b0), .next_state(r1in[16]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r1[16]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N377) );
  \**SEQGEN**  r1_reg_15_ ( .clear(1'b0), .preset(1'b0), .next_state(r1in[15]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r1[15]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N377) );
  \**SEQGEN**  r1_reg_14_ ( .clear(1'b0), .preset(1'b0), .next_state(r1in[14]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r1[14]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N377) );
  \**SEQGEN**  r1_reg_13_ ( .clear(1'b0), .preset(1'b0), .next_state(r1in[13]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r1[13]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N377) );
  \**SEQGEN**  r1_reg_12_ ( .clear(1'b0), .preset(1'b0), .next_state(r1in[12]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r1[12]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N377) );
  \**SEQGEN**  r1_reg_11_ ( .clear(1'b0), .preset(1'b0), .next_state(r1in[11]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r1[11]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N377) );
  \**SEQGEN**  r1_reg_10_ ( .clear(1'b0), .preset(1'b0), .next_state(r1in[10]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r1[10]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N377) );
  \**SEQGEN**  r1_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(r1in[9]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r1[9]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N377) );
  \**SEQGEN**  r1_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(r1in[8]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r1[8]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N377) );
  \**SEQGEN**  r1_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(r1in[7]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r1[7]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N377) );
  \**SEQGEN**  r1_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(r1in[6]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r1[6]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N377) );
  \**SEQGEN**  r1_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(r1in[5]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r1[5]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N377) );
  \**SEQGEN**  r1_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(r1in[4]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r1[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N377) );
  \**SEQGEN**  r1_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(r1in[3]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r1[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N377) );
  \**SEQGEN**  r1_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(r1in[2]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r1[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N377) );
  \**SEQGEN**  r1_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(r1in[1]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r1[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N377) );
  \**SEQGEN**  r1_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(r1in[0]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r1[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N377) );
  \**SEQGEN**  r2_reg_31_ ( .clear(1'b0), .preset(1'b0), .next_state(r2in[31]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r2[31]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N385) );
  \**SEQGEN**  r2_reg_30_ ( .clear(1'b0), .preset(1'b0), .next_state(r2in[30]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r2[30]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N385) );
  \**SEQGEN**  r2_reg_29_ ( .clear(1'b0), .preset(1'b0), .next_state(r2in[29]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r2[29]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N385) );
  \**SEQGEN**  r2_reg_28_ ( .clear(1'b0), .preset(1'b0), .next_state(r2in[28]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r2[28]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N385) );
  \**SEQGEN**  r2_reg_27_ ( .clear(1'b0), .preset(1'b0), .next_state(r2in[27]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r2[27]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N385) );
  \**SEQGEN**  r2_reg_26_ ( .clear(1'b0), .preset(1'b0), .next_state(r2in[26]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r2[26]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N385) );
  \**SEQGEN**  r2_reg_25_ ( .clear(1'b0), .preset(1'b0), .next_state(r2in[25]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r2[25]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N385) );
  \**SEQGEN**  r2_reg_24_ ( .clear(1'b0), .preset(1'b0), .next_state(r2in[24]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r2[24]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N385) );
  \**SEQGEN**  r2_reg_23_ ( .clear(1'b0), .preset(1'b0), .next_state(r2in[23]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r2[23]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N385) );
  \**SEQGEN**  r2_reg_22_ ( .clear(1'b0), .preset(1'b0), .next_state(r2in[22]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r2[22]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N385) );
  \**SEQGEN**  r2_reg_21_ ( .clear(1'b0), .preset(1'b0), .next_state(r2in[21]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r2[21]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N385) );
  \**SEQGEN**  r2_reg_20_ ( .clear(1'b0), .preset(1'b0), .next_state(r2in[20]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r2[20]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N385) );
  \**SEQGEN**  r2_reg_19_ ( .clear(1'b0), .preset(1'b0), .next_state(r2in[19]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r2[19]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N385) );
  \**SEQGEN**  r2_reg_18_ ( .clear(1'b0), .preset(1'b0), .next_state(r2in[18]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r2[18]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N385) );
  \**SEQGEN**  r2_reg_17_ ( .clear(1'b0), .preset(1'b0), .next_state(r2in[17]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r2[17]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N385) );
  \**SEQGEN**  r2_reg_16_ ( .clear(1'b0), .preset(1'b0), .next_state(r2in[16]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r2[16]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N385) );
  \**SEQGEN**  r2_reg_15_ ( .clear(1'b0), .preset(1'b0), .next_state(r2in[15]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r2[15]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N385) );
  \**SEQGEN**  r2_reg_14_ ( .clear(1'b0), .preset(1'b0), .next_state(r2in[14]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r2[14]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N385) );
  \**SEQGEN**  r2_reg_13_ ( .clear(1'b0), .preset(1'b0), .next_state(r2in[13]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r2[13]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N385) );
  \**SEQGEN**  r2_reg_12_ ( .clear(1'b0), .preset(1'b0), .next_state(r2in[12]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r2[12]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N385) );
  \**SEQGEN**  r2_reg_11_ ( .clear(1'b0), .preset(1'b0), .next_state(r2in[11]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r2[11]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N385) );
  \**SEQGEN**  r2_reg_10_ ( .clear(1'b0), .preset(1'b0), .next_state(r2in[10]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r2[10]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N385) );
  \**SEQGEN**  r2_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(r2in[9]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r2[9]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N385) );
  \**SEQGEN**  r2_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(r2in[8]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r2[8]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N385) );
  \**SEQGEN**  r2_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(r2in[7]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r2[7]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N385) );
  \**SEQGEN**  r2_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(r2in[6]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r2[6]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N385) );
  \**SEQGEN**  r2_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(r2in[5]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r2[5]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N385) );
  \**SEQGEN**  r2_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(r2in[4]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r2[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N385) );
  \**SEQGEN**  r2_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(r2in[3]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r2[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N385) );
  \**SEQGEN**  r2_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(r2in[2]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r2[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N385) );
  \**SEQGEN**  r2_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(r2in[1]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r2[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N385) );
  \**SEQGEN**  r2_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(r2in[0]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r2[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N385) );
  \**SEQGEN**  r3_reg_31_ ( .clear(1'b0), .preset(1'b0), .next_state(r3in[31]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r3[31]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N394) );
  \**SEQGEN**  r3_reg_30_ ( .clear(1'b0), .preset(1'b0), .next_state(r3in[30]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r3[30]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N394) );
  \**SEQGEN**  r3_reg_29_ ( .clear(1'b0), .preset(1'b0), .next_state(r3in[29]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r3[29]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N394) );
  \**SEQGEN**  r3_reg_28_ ( .clear(1'b0), .preset(1'b0), .next_state(r3in[28]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r3[28]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N394) );
  \**SEQGEN**  r3_reg_27_ ( .clear(1'b0), .preset(1'b0), .next_state(r3in[27]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r3[27]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N394) );
  \**SEQGEN**  r3_reg_26_ ( .clear(1'b0), .preset(1'b0), .next_state(r3in[26]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r3[26]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N394) );
  \**SEQGEN**  r3_reg_25_ ( .clear(1'b0), .preset(1'b0), .next_state(r3in[25]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r3[25]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N394) );
  \**SEQGEN**  r3_reg_24_ ( .clear(1'b0), .preset(1'b0), .next_state(r3in[24]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r3[24]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N394) );
  \**SEQGEN**  r3_reg_23_ ( .clear(1'b0), .preset(1'b0), .next_state(r3in[23]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r3[23]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N394) );
  \**SEQGEN**  r3_reg_22_ ( .clear(1'b0), .preset(1'b0), .next_state(r3in[22]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r3[22]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N394) );
  \**SEQGEN**  r3_reg_21_ ( .clear(1'b0), .preset(1'b0), .next_state(r3in[21]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r3[21]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N394) );
  \**SEQGEN**  r3_reg_20_ ( .clear(1'b0), .preset(1'b0), .next_state(r3in[20]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r3[20]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N394) );
  \**SEQGEN**  r3_reg_19_ ( .clear(1'b0), .preset(1'b0), .next_state(r3in[19]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r3[19]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N394) );
  \**SEQGEN**  r3_reg_18_ ( .clear(1'b0), .preset(1'b0), .next_state(r3in[18]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r3[18]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N394) );
  \**SEQGEN**  r3_reg_17_ ( .clear(1'b0), .preset(1'b0), .next_state(r3in[17]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r3[17]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N394) );
  \**SEQGEN**  r3_reg_16_ ( .clear(1'b0), .preset(1'b0), .next_state(r3in[16]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r3[16]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N394) );
  \**SEQGEN**  r3_reg_15_ ( .clear(1'b0), .preset(1'b0), .next_state(r3in[15]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r3[15]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N394) );
  \**SEQGEN**  r3_reg_14_ ( .clear(1'b0), .preset(1'b0), .next_state(r3in[14]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r3[14]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N394) );
  \**SEQGEN**  r3_reg_13_ ( .clear(1'b0), .preset(1'b0), .next_state(r3in[13]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r3[13]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N394) );
  \**SEQGEN**  r3_reg_12_ ( .clear(1'b0), .preset(1'b0), .next_state(r3in[12]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r3[12]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N394) );
  \**SEQGEN**  r3_reg_11_ ( .clear(1'b0), .preset(1'b0), .next_state(r3in[11]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r3[11]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N394) );
  \**SEQGEN**  r3_reg_10_ ( .clear(1'b0), .preset(1'b0), .next_state(r3in[10]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r3[10]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N394) );
  \**SEQGEN**  r3_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(r3in[9]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r3[9]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N394) );
  \**SEQGEN**  r3_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(r3in[8]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r3[8]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N394) );
  \**SEQGEN**  r3_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(r3in[7]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r3[7]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N394) );
  \**SEQGEN**  r3_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(r3in[6]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r3[6]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N394) );
  \**SEQGEN**  r3_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(r3in[5]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r3[5]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N394) );
  \**SEQGEN**  r3_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(r3in[4]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r3[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N394) );
  \**SEQGEN**  r3_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(r3in[3]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r3[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N394) );
  \**SEQGEN**  r3_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(r3in[2]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r3[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N394) );
  \**SEQGEN**  r3_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(r3in[1]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r3[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N394) );
  \**SEQGEN**  r3_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(r3in[0]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r3[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N394) );
  \**SEQGEN**  r4_reg_31_ ( .clear(1'b0), .preset(1'b0), .next_state(r4in[31]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r4[31]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N402) );
  \**SEQGEN**  r4_reg_30_ ( .clear(1'b0), .preset(1'b0), .next_state(r4in[30]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r4[30]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N402) );
  \**SEQGEN**  r4_reg_29_ ( .clear(1'b0), .preset(1'b0), .next_state(r4in[29]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r4[29]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N402) );
  \**SEQGEN**  r4_reg_28_ ( .clear(1'b0), .preset(1'b0), .next_state(r4in[28]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r4[28]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N402) );
  \**SEQGEN**  r4_reg_27_ ( .clear(1'b0), .preset(1'b0), .next_state(r4in[27]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r4[27]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N402) );
  \**SEQGEN**  r4_reg_26_ ( .clear(1'b0), .preset(1'b0), .next_state(r4in[26]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r4[26]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N402) );
  \**SEQGEN**  r4_reg_25_ ( .clear(1'b0), .preset(1'b0), .next_state(r4in[25]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r4[25]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N402) );
  \**SEQGEN**  r4_reg_24_ ( .clear(1'b0), .preset(1'b0), .next_state(r4in[24]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r4[24]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N402) );
  \**SEQGEN**  r4_reg_23_ ( .clear(1'b0), .preset(1'b0), .next_state(r4in[23]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r4[23]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N402) );
  \**SEQGEN**  r4_reg_22_ ( .clear(1'b0), .preset(1'b0), .next_state(r4in[22]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r4[22]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N402) );
  \**SEQGEN**  r4_reg_21_ ( .clear(1'b0), .preset(1'b0), .next_state(r4in[21]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r4[21]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N402) );
  \**SEQGEN**  r4_reg_20_ ( .clear(1'b0), .preset(1'b0), .next_state(r4in[20]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r4[20]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N402) );
  \**SEQGEN**  r4_reg_19_ ( .clear(1'b0), .preset(1'b0), .next_state(r4in[19]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r4[19]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N402) );
  \**SEQGEN**  r4_reg_18_ ( .clear(1'b0), .preset(1'b0), .next_state(r4in[18]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r4[18]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N402) );
  \**SEQGEN**  r4_reg_17_ ( .clear(1'b0), .preset(1'b0), .next_state(r4in[17]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r4[17]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N402) );
  \**SEQGEN**  r4_reg_16_ ( .clear(1'b0), .preset(1'b0), .next_state(r4in[16]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r4[16]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N402) );
  \**SEQGEN**  r4_reg_15_ ( .clear(1'b0), .preset(1'b0), .next_state(r4in[15]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r4[15]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N402) );
  \**SEQGEN**  r4_reg_14_ ( .clear(1'b0), .preset(1'b0), .next_state(r4in[14]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r4[14]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N402) );
  \**SEQGEN**  r4_reg_13_ ( .clear(1'b0), .preset(1'b0), .next_state(r4in[13]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r4[13]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N402) );
  \**SEQGEN**  r4_reg_12_ ( .clear(1'b0), .preset(1'b0), .next_state(r4in[12]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r4[12]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N402) );
  \**SEQGEN**  r4_reg_11_ ( .clear(1'b0), .preset(1'b0), .next_state(r4in[11]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r4[11]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N402) );
  \**SEQGEN**  r4_reg_10_ ( .clear(1'b0), .preset(1'b0), .next_state(r4in[10]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r4[10]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N402) );
  \**SEQGEN**  r4_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(r4in[9]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r4[9]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N402) );
  \**SEQGEN**  r4_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(r4in[8]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r4[8]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N402) );
  \**SEQGEN**  r4_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(r4in[7]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r4[7]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N402) );
  \**SEQGEN**  r4_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(r4in[6]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r4[6]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N402) );
  \**SEQGEN**  r4_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(r4in[5]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r4[5]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N402) );
  \**SEQGEN**  r4_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(r4in[4]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r4[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N402) );
  \**SEQGEN**  r4_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(r4in[3]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r4[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N402) );
  \**SEQGEN**  r4_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(r4in[2]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r4[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N402) );
  \**SEQGEN**  r4_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(r4in[1]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r4[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N402) );
  \**SEQGEN**  r4_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(r4in[0]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r4[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N402) );
  \**SEQGEN**  r5_reg_31_ ( .clear(1'b0), .preset(1'b0), .next_state(r5in[31]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r5[31]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N410) );
  \**SEQGEN**  r5_reg_30_ ( .clear(1'b0), .preset(1'b0), .next_state(r5in[30]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r5[30]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N410) );
  \**SEQGEN**  r5_reg_29_ ( .clear(1'b0), .preset(1'b0), .next_state(r5in[29]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r5[29]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N410) );
  \**SEQGEN**  r5_reg_28_ ( .clear(1'b0), .preset(1'b0), .next_state(r5in[28]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r5[28]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N410) );
  \**SEQGEN**  r5_reg_27_ ( .clear(1'b0), .preset(1'b0), .next_state(r5in[27]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r5[27]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N410) );
  \**SEQGEN**  r5_reg_26_ ( .clear(1'b0), .preset(1'b0), .next_state(r5in[26]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r5[26]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N410) );
  \**SEQGEN**  r5_reg_25_ ( .clear(1'b0), .preset(1'b0), .next_state(r5in[25]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r5[25]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N410) );
  \**SEQGEN**  r5_reg_24_ ( .clear(1'b0), .preset(1'b0), .next_state(r5in[24]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r5[24]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N410) );
  \**SEQGEN**  r5_reg_23_ ( .clear(1'b0), .preset(1'b0), .next_state(r5in[23]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r5[23]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N410) );
  \**SEQGEN**  r5_reg_22_ ( .clear(1'b0), .preset(1'b0), .next_state(r5in[22]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r5[22]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N410) );
  \**SEQGEN**  r5_reg_21_ ( .clear(1'b0), .preset(1'b0), .next_state(r5in[21]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r5[21]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N410) );
  \**SEQGEN**  r5_reg_20_ ( .clear(1'b0), .preset(1'b0), .next_state(r5in[20]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r5[20]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N410) );
  \**SEQGEN**  r5_reg_19_ ( .clear(1'b0), .preset(1'b0), .next_state(r5in[19]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r5[19]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N410) );
  \**SEQGEN**  r5_reg_18_ ( .clear(1'b0), .preset(1'b0), .next_state(r5in[18]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r5[18]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N410) );
  \**SEQGEN**  r5_reg_17_ ( .clear(1'b0), .preset(1'b0), .next_state(r5in[17]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r5[17]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N410) );
  \**SEQGEN**  r5_reg_16_ ( .clear(1'b0), .preset(1'b0), .next_state(r5in[16]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r5[16]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N410) );
  \**SEQGEN**  r5_reg_15_ ( .clear(1'b0), .preset(1'b0), .next_state(r5in[15]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r5[15]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N410) );
  \**SEQGEN**  r5_reg_14_ ( .clear(1'b0), .preset(1'b0), .next_state(r5in[14]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r5[14]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N410) );
  \**SEQGEN**  r5_reg_13_ ( .clear(1'b0), .preset(1'b0), .next_state(r5in[13]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r5[13]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N410) );
  \**SEQGEN**  r5_reg_12_ ( .clear(1'b0), .preset(1'b0), .next_state(r5in[12]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r5[12]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N410) );
  \**SEQGEN**  r5_reg_11_ ( .clear(1'b0), .preset(1'b0), .next_state(r5in[11]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r5[11]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N410) );
  \**SEQGEN**  r5_reg_10_ ( .clear(1'b0), .preset(1'b0), .next_state(r5in[10]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r5[10]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N410) );
  \**SEQGEN**  r5_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(r5in[9]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r5[9]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N410) );
  \**SEQGEN**  r5_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(r5in[8]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r5[8]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N410) );
  \**SEQGEN**  r5_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(r5in[7]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r5[7]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N410) );
  \**SEQGEN**  r5_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(r5in[6]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r5[6]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N410) );
  \**SEQGEN**  r5_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(r5in[5]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r5[5]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N410) );
  \**SEQGEN**  r5_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(r5in[4]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r5[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N410) );
  \**SEQGEN**  r5_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(r5in[3]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r5[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N410) );
  \**SEQGEN**  r5_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(r5in[2]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r5[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N410) );
  \**SEQGEN**  r5_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(r5in[1]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r5[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N410) );
  \**SEQGEN**  r5_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(r5in[0]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r5[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N410) );
  \**SEQGEN**  r6_reg_31_ ( .clear(1'b0), .preset(1'b0), .next_state(r6in[31]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r6[31]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N418) );
  \**SEQGEN**  r6_reg_30_ ( .clear(1'b0), .preset(1'b0), .next_state(r6in[30]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r6[30]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N418) );
  \**SEQGEN**  r6_reg_29_ ( .clear(1'b0), .preset(1'b0), .next_state(r6in[29]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r6[29]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N418) );
  \**SEQGEN**  r6_reg_28_ ( .clear(1'b0), .preset(1'b0), .next_state(r6in[28]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r6[28]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N418) );
  \**SEQGEN**  r6_reg_27_ ( .clear(1'b0), .preset(1'b0), .next_state(r6in[27]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r6[27]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N418) );
  \**SEQGEN**  r6_reg_26_ ( .clear(1'b0), .preset(1'b0), .next_state(r6in[26]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r6[26]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N418) );
  \**SEQGEN**  r6_reg_25_ ( .clear(1'b0), .preset(1'b0), .next_state(r6in[25]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r6[25]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N418) );
  \**SEQGEN**  r6_reg_24_ ( .clear(1'b0), .preset(1'b0), .next_state(r6in[24]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r6[24]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N418) );
  \**SEQGEN**  r6_reg_23_ ( .clear(1'b0), .preset(1'b0), .next_state(r6in[23]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r6[23]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N418) );
  \**SEQGEN**  r6_reg_22_ ( .clear(1'b0), .preset(1'b0), .next_state(r6in[22]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r6[22]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N418) );
  \**SEQGEN**  r6_reg_21_ ( .clear(1'b0), .preset(1'b0), .next_state(r6in[21]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r6[21]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N418) );
  \**SEQGEN**  r6_reg_20_ ( .clear(1'b0), .preset(1'b0), .next_state(r6in[20]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r6[20]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N418) );
  \**SEQGEN**  r6_reg_19_ ( .clear(1'b0), .preset(1'b0), .next_state(r6in[19]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r6[19]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N418) );
  \**SEQGEN**  r6_reg_18_ ( .clear(1'b0), .preset(1'b0), .next_state(r6in[18]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r6[18]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N418) );
  \**SEQGEN**  r6_reg_17_ ( .clear(1'b0), .preset(1'b0), .next_state(r6in[17]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r6[17]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N418) );
  \**SEQGEN**  r6_reg_16_ ( .clear(1'b0), .preset(1'b0), .next_state(r6in[16]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r6[16]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N418) );
  \**SEQGEN**  r6_reg_15_ ( .clear(1'b0), .preset(1'b0), .next_state(r6in[15]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r6[15]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N418) );
  \**SEQGEN**  r6_reg_14_ ( .clear(1'b0), .preset(1'b0), .next_state(r6in[14]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r6[14]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N418) );
  \**SEQGEN**  r6_reg_13_ ( .clear(1'b0), .preset(1'b0), .next_state(r6in[13]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r6[13]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N418) );
  \**SEQGEN**  r6_reg_12_ ( .clear(1'b0), .preset(1'b0), .next_state(r6in[12]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r6[12]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N418) );
  \**SEQGEN**  r6_reg_11_ ( .clear(1'b0), .preset(1'b0), .next_state(r6in[11]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r6[11]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N418) );
  \**SEQGEN**  r6_reg_10_ ( .clear(1'b0), .preset(1'b0), .next_state(r6in[10]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r6[10]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N418) );
  \**SEQGEN**  r6_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(r6in[9]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r6[9]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N418) );
  \**SEQGEN**  r6_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(r6in[8]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r6[8]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N418) );
  \**SEQGEN**  r6_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(r6in[7]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r6[7]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N418) );
  \**SEQGEN**  r6_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(r6in[6]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r6[6]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N418) );
  \**SEQGEN**  r6_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(r6in[5]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r6[5]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N418) );
  \**SEQGEN**  r6_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(r6in[4]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r6[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N418) );
  \**SEQGEN**  r6_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(r6in[3]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r6[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N418) );
  \**SEQGEN**  r6_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(r6in[2]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r6[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N418) );
  \**SEQGEN**  r6_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(r6in[1]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r6[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N418) );
  \**SEQGEN**  r6_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(r6in[0]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r6[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N418) );
  \**SEQGEN**  r7_reg_31_ ( .clear(1'b0), .preset(1'b0), .next_state(r7in[31]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r7[31]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N426) );
  \**SEQGEN**  r7_reg_30_ ( .clear(1'b0), .preset(1'b0), .next_state(r7in[30]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r7[30]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N426) );
  \**SEQGEN**  r7_reg_29_ ( .clear(1'b0), .preset(1'b0), .next_state(r7in[29]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r7[29]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N426) );
  \**SEQGEN**  r7_reg_28_ ( .clear(1'b0), .preset(1'b0), .next_state(r7in[28]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r7[28]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N426) );
  \**SEQGEN**  r7_reg_27_ ( .clear(1'b0), .preset(1'b0), .next_state(r7in[27]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r7[27]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N426) );
  \**SEQGEN**  r7_reg_26_ ( .clear(1'b0), .preset(1'b0), .next_state(r7in[26]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r7[26]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N426) );
  \**SEQGEN**  r7_reg_25_ ( .clear(1'b0), .preset(1'b0), .next_state(r7in[25]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r7[25]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N426) );
  \**SEQGEN**  r7_reg_24_ ( .clear(1'b0), .preset(1'b0), .next_state(r7in[24]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r7[24]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N426) );
  \**SEQGEN**  r7_reg_23_ ( .clear(1'b0), .preset(1'b0), .next_state(r7in[23]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r7[23]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N426) );
  \**SEQGEN**  r7_reg_22_ ( .clear(1'b0), .preset(1'b0), .next_state(r7in[22]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r7[22]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N426) );
  \**SEQGEN**  r7_reg_21_ ( .clear(1'b0), .preset(1'b0), .next_state(r7in[21]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r7[21]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N426) );
  \**SEQGEN**  r7_reg_20_ ( .clear(1'b0), .preset(1'b0), .next_state(r7in[20]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r7[20]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N426) );
  \**SEQGEN**  r7_reg_19_ ( .clear(1'b0), .preset(1'b0), .next_state(r7in[19]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r7[19]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N426) );
  \**SEQGEN**  r7_reg_18_ ( .clear(1'b0), .preset(1'b0), .next_state(r7in[18]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r7[18]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N426) );
  \**SEQGEN**  r7_reg_17_ ( .clear(1'b0), .preset(1'b0), .next_state(r7in[17]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r7[17]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N426) );
  \**SEQGEN**  r7_reg_16_ ( .clear(1'b0), .preset(1'b0), .next_state(r7in[16]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r7[16]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N426) );
  \**SEQGEN**  r7_reg_15_ ( .clear(1'b0), .preset(1'b0), .next_state(r7in[15]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r7[15]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N426) );
  \**SEQGEN**  r7_reg_14_ ( .clear(1'b0), .preset(1'b0), .next_state(r7in[14]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r7[14]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N426) );
  \**SEQGEN**  r7_reg_13_ ( .clear(1'b0), .preset(1'b0), .next_state(r7in[13]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r7[13]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N426) );
  \**SEQGEN**  r7_reg_12_ ( .clear(1'b0), .preset(1'b0), .next_state(r7in[12]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r7[12]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N426) );
  \**SEQGEN**  r7_reg_11_ ( .clear(1'b0), .preset(1'b0), .next_state(r7in[11]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r7[11]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N426) );
  \**SEQGEN**  r7_reg_10_ ( .clear(1'b0), .preset(1'b0), .next_state(r7in[10]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r7[10]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N426) );
  \**SEQGEN**  r7_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(r7in[9]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r7[9]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N426) );
  \**SEQGEN**  r7_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(r7in[8]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r7[8]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N426) );
  \**SEQGEN**  r7_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(r7in[7]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r7[7]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N426) );
  \**SEQGEN**  r7_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(r7in[6]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r7[6]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N426) );
  \**SEQGEN**  r7_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(r7in[5]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r7[5]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N426) );
  \**SEQGEN**  r7_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(r7in[4]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r7[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N426) );
  \**SEQGEN**  r7_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(r7in[3]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r7[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N426) );
  \**SEQGEN**  r7_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(r7in[2]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r7[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N426) );
  \**SEQGEN**  r7_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(r7in[1]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r7[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N426) );
  \**SEQGEN**  r7_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(r7in[0]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r7[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N426) );
  \**SEQGEN**  r8_reg_31_ ( .clear(1'b0), .preset(1'b0), .next_state(r8in[31]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r8[31]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N434) );
  \**SEQGEN**  r8_reg_30_ ( .clear(1'b0), .preset(1'b0), .next_state(r8in[30]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r8[30]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N434) );
  \**SEQGEN**  r8_reg_29_ ( .clear(1'b0), .preset(1'b0), .next_state(r8in[29]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r8[29]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N434) );
  \**SEQGEN**  r8_reg_28_ ( .clear(1'b0), .preset(1'b0), .next_state(r8in[28]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r8[28]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N434) );
  \**SEQGEN**  r8_reg_27_ ( .clear(1'b0), .preset(1'b0), .next_state(r8in[27]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r8[27]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N434) );
  \**SEQGEN**  r8_reg_26_ ( .clear(1'b0), .preset(1'b0), .next_state(r8in[26]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r8[26]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N434) );
  \**SEQGEN**  r8_reg_25_ ( .clear(1'b0), .preset(1'b0), .next_state(r8in[25]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r8[25]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N434) );
  \**SEQGEN**  r8_reg_24_ ( .clear(1'b0), .preset(1'b0), .next_state(r8in[24]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r8[24]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N434) );
  \**SEQGEN**  r8_reg_23_ ( .clear(1'b0), .preset(1'b0), .next_state(r8in[23]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r8[23]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N434) );
  \**SEQGEN**  r8_reg_22_ ( .clear(1'b0), .preset(1'b0), .next_state(r8in[22]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r8[22]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N434) );
  \**SEQGEN**  r8_reg_21_ ( .clear(1'b0), .preset(1'b0), .next_state(r8in[21]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r8[21]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N434) );
  \**SEQGEN**  r8_reg_20_ ( .clear(1'b0), .preset(1'b0), .next_state(r8in[20]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r8[20]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N434) );
  \**SEQGEN**  r8_reg_19_ ( .clear(1'b0), .preset(1'b0), .next_state(r8in[19]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r8[19]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N434) );
  \**SEQGEN**  r8_reg_18_ ( .clear(1'b0), .preset(1'b0), .next_state(r8in[18]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r8[18]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N434) );
  \**SEQGEN**  r8_reg_17_ ( .clear(1'b0), .preset(1'b0), .next_state(r8in[17]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r8[17]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N434) );
  \**SEQGEN**  r8_reg_16_ ( .clear(1'b0), .preset(1'b0), .next_state(r8in[16]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r8[16]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N434) );
  \**SEQGEN**  r8_reg_15_ ( .clear(1'b0), .preset(1'b0), .next_state(r8in[15]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r8[15]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N434) );
  \**SEQGEN**  r8_reg_14_ ( .clear(1'b0), .preset(1'b0), .next_state(r8in[14]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r8[14]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N434) );
  \**SEQGEN**  r8_reg_13_ ( .clear(1'b0), .preset(1'b0), .next_state(r8in[13]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r8[13]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N434) );
  \**SEQGEN**  r8_reg_12_ ( .clear(1'b0), .preset(1'b0), .next_state(r8in[12]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r8[12]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N434) );
  \**SEQGEN**  r8_reg_11_ ( .clear(1'b0), .preset(1'b0), .next_state(r8in[11]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r8[11]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N434) );
  \**SEQGEN**  r8_reg_10_ ( .clear(1'b0), .preset(1'b0), .next_state(r8in[10]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r8[10]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N434) );
  \**SEQGEN**  r8_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(r8in[9]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r8[9]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N434) );
  \**SEQGEN**  r8_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(r8in[8]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r8[8]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N434) );
  \**SEQGEN**  r8_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(r8in[7]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r8[7]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N434) );
  \**SEQGEN**  r8_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(r8in[6]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r8[6]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N434) );
  \**SEQGEN**  r8_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(r8in[5]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r8[5]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N434) );
  \**SEQGEN**  r8_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(r8in[4]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r8[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N434) );
  \**SEQGEN**  r8_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(r8in[3]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r8[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N434) );
  \**SEQGEN**  r8_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(r8in[2]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r8[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N434) );
  \**SEQGEN**  r8_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(r8in[1]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r8[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N434) );
  \**SEQGEN**  r8_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(r8in[0]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r8[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N434) );
  \**SEQGEN**  r9_reg_31_ ( .clear(1'b0), .preset(1'b0), .next_state(r9in[31]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r9[31]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N442) );
  \**SEQGEN**  r9_reg_30_ ( .clear(1'b0), .preset(1'b0), .next_state(r9in[30]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r9[30]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N442) );
  \**SEQGEN**  r9_reg_29_ ( .clear(1'b0), .preset(1'b0), .next_state(r9in[29]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r9[29]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N442) );
  \**SEQGEN**  r9_reg_28_ ( .clear(1'b0), .preset(1'b0), .next_state(r9in[28]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r9[28]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N442) );
  \**SEQGEN**  r9_reg_27_ ( .clear(1'b0), .preset(1'b0), .next_state(r9in[27]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r9[27]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N442) );
  \**SEQGEN**  r9_reg_26_ ( .clear(1'b0), .preset(1'b0), .next_state(r9in[26]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r9[26]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N442) );
  \**SEQGEN**  r9_reg_25_ ( .clear(1'b0), .preset(1'b0), .next_state(r9in[25]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r9[25]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N442) );
  \**SEQGEN**  r9_reg_24_ ( .clear(1'b0), .preset(1'b0), .next_state(r9in[24]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r9[24]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N442) );
  \**SEQGEN**  r9_reg_23_ ( .clear(1'b0), .preset(1'b0), .next_state(r9in[23]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r9[23]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N442) );
  \**SEQGEN**  r9_reg_22_ ( .clear(1'b0), .preset(1'b0), .next_state(r9in[22]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r9[22]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N442) );
  \**SEQGEN**  r9_reg_21_ ( .clear(1'b0), .preset(1'b0), .next_state(r9in[21]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r9[21]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N442) );
  \**SEQGEN**  r9_reg_20_ ( .clear(1'b0), .preset(1'b0), .next_state(r9in[20]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r9[20]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N442) );
  \**SEQGEN**  r9_reg_19_ ( .clear(1'b0), .preset(1'b0), .next_state(r9in[19]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r9[19]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N442) );
  \**SEQGEN**  r9_reg_18_ ( .clear(1'b0), .preset(1'b0), .next_state(r9in[18]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r9[18]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N442) );
  \**SEQGEN**  r9_reg_17_ ( .clear(1'b0), .preset(1'b0), .next_state(r9in[17]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r9[17]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N442) );
  \**SEQGEN**  r9_reg_16_ ( .clear(1'b0), .preset(1'b0), .next_state(r9in[16]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r9[16]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N442) );
  \**SEQGEN**  r9_reg_15_ ( .clear(1'b0), .preset(1'b0), .next_state(r9in[15]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r9[15]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N442) );
  \**SEQGEN**  r9_reg_14_ ( .clear(1'b0), .preset(1'b0), .next_state(r9in[14]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r9[14]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N442) );
  \**SEQGEN**  r9_reg_13_ ( .clear(1'b0), .preset(1'b0), .next_state(r9in[13]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r9[13]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N442) );
  \**SEQGEN**  r9_reg_12_ ( .clear(1'b0), .preset(1'b0), .next_state(r9in[12]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r9[12]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N442) );
  \**SEQGEN**  r9_reg_11_ ( .clear(1'b0), .preset(1'b0), .next_state(r9in[11]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r9[11]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N442) );
  \**SEQGEN**  r9_reg_10_ ( .clear(1'b0), .preset(1'b0), .next_state(r9in[10]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r9[10]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N442) );
  \**SEQGEN**  r9_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(r9in[9]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r9[9]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N442) );
  \**SEQGEN**  r9_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(r9in[8]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r9[8]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N442) );
  \**SEQGEN**  r9_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(r9in[7]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r9[7]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N442) );
  \**SEQGEN**  r9_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(r9in[6]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r9[6]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N442) );
  \**SEQGEN**  r9_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(r9in[5]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r9[5]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N442) );
  \**SEQGEN**  r9_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(r9in[4]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r9[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N442) );
  \**SEQGEN**  r9_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(r9in[3]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r9[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N442) );
  \**SEQGEN**  r9_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(r9in[2]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r9[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N442) );
  \**SEQGEN**  r9_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(r9in[1]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r9[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N442) );
  \**SEQGEN**  r9_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(r9in[0]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r9[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N442) );
  \**SEQGEN**  r10_reg_31_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r10in[31]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r10[31]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N450) );
  \**SEQGEN**  r10_reg_30_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r10in[30]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r10[30]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N450) );
  \**SEQGEN**  r10_reg_29_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r10in[29]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r10[29]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N450) );
  \**SEQGEN**  r10_reg_28_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r10in[28]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r10[28]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N450) );
  \**SEQGEN**  r10_reg_27_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r10in[27]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r10[27]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N450) );
  \**SEQGEN**  r10_reg_26_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r10in[26]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r10[26]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N450) );
  \**SEQGEN**  r10_reg_25_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r10in[25]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r10[25]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N450) );
  \**SEQGEN**  r10_reg_24_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r10in[24]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r10[24]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N450) );
  \**SEQGEN**  r10_reg_23_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r10in[23]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r10[23]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N450) );
  \**SEQGEN**  r10_reg_22_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r10in[22]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r10[22]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N450) );
  \**SEQGEN**  r10_reg_21_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r10in[21]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r10[21]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N450) );
  \**SEQGEN**  r10_reg_20_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r10in[20]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r10[20]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N450) );
  \**SEQGEN**  r10_reg_19_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r10in[19]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r10[19]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N450) );
  \**SEQGEN**  r10_reg_18_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r10in[18]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r10[18]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N450) );
  \**SEQGEN**  r10_reg_17_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r10in[17]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r10[17]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N450) );
  \**SEQGEN**  r10_reg_16_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r10in[16]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r10[16]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N450) );
  \**SEQGEN**  r10_reg_15_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r10in[15]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r10[15]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N450) );
  \**SEQGEN**  r10_reg_14_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r10in[14]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r10[14]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N450) );
  \**SEQGEN**  r10_reg_13_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r10in[13]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r10[13]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N450) );
  \**SEQGEN**  r10_reg_12_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r10in[12]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r10[12]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N450) );
  \**SEQGEN**  r10_reg_11_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r10in[11]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r10[11]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N450) );
  \**SEQGEN**  r10_reg_10_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r10in[10]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r10[10]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N450) );
  \**SEQGEN**  r10_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(r10in[9]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r10[9]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N450) );
  \**SEQGEN**  r10_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(r10in[8]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r10[8]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N450) );
  \**SEQGEN**  r10_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(r10in[7]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r10[7]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N450) );
  \**SEQGEN**  r10_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(r10in[6]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r10[6]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N450) );
  \**SEQGEN**  r10_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(r10in[5]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r10[5]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N450) );
  \**SEQGEN**  r10_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(r10in[4]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r10[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N450) );
  \**SEQGEN**  r10_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(r10in[3]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r10[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N450) );
  \**SEQGEN**  r10_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(r10in[2]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r10[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N450) );
  \**SEQGEN**  r10_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(r10in[1]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r10[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N450) );
  \**SEQGEN**  r10_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(r10in[0]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r10[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N450) );
  \**SEQGEN**  r11_reg_31_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r11in[31]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r11[31]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N458) );
  \**SEQGEN**  r11_reg_30_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r11in[30]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r11[30]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N458) );
  \**SEQGEN**  r11_reg_29_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r11in[29]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r11[29]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N458) );
  \**SEQGEN**  r11_reg_28_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r11in[28]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r11[28]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N458) );
  \**SEQGEN**  r11_reg_27_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r11in[27]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r11[27]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N458) );
  \**SEQGEN**  r11_reg_26_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r11in[26]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r11[26]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N458) );
  \**SEQGEN**  r11_reg_25_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r11in[25]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r11[25]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N458) );
  \**SEQGEN**  r11_reg_24_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r11in[24]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r11[24]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N458) );
  \**SEQGEN**  r11_reg_23_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r11in[23]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r11[23]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N458) );
  \**SEQGEN**  r11_reg_22_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r11in[22]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r11[22]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N458) );
  \**SEQGEN**  r11_reg_21_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r11in[21]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r11[21]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N458) );
  \**SEQGEN**  r11_reg_20_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r11in[20]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r11[20]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N458) );
  \**SEQGEN**  r11_reg_19_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r11in[19]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r11[19]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N458) );
  \**SEQGEN**  r11_reg_18_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r11in[18]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r11[18]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N458) );
  \**SEQGEN**  r11_reg_17_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r11in[17]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r11[17]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N458) );
  \**SEQGEN**  r11_reg_16_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r11in[16]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r11[16]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N458) );
  \**SEQGEN**  r11_reg_15_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r11in[15]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r11[15]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N458) );
  \**SEQGEN**  r11_reg_14_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r11in[14]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r11[14]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N458) );
  \**SEQGEN**  r11_reg_13_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r11in[13]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r11[13]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N458) );
  \**SEQGEN**  r11_reg_12_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r11in[12]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r11[12]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N458) );
  \**SEQGEN**  r11_reg_11_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r11in[11]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r11[11]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N458) );
  \**SEQGEN**  r11_reg_10_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r11in[10]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r11[10]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N458) );
  \**SEQGEN**  r11_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(r11in[9]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r11[9]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N458) );
  \**SEQGEN**  r11_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(r11in[8]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r11[8]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N458) );
  \**SEQGEN**  r11_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(r11in[7]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r11[7]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N458) );
  \**SEQGEN**  r11_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(r11in[6]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r11[6]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N458) );
  \**SEQGEN**  r11_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(r11in[5]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r11[5]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N458) );
  \**SEQGEN**  r11_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(r11in[4]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r11[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N458) );
  \**SEQGEN**  r11_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(r11in[3]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r11[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N458) );
  \**SEQGEN**  r11_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(r11in[2]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r11[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N458) );
  \**SEQGEN**  r11_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(r11in[1]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r11[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N458) );
  \**SEQGEN**  r11_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(r11in[0]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r11[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N458) );
  \**SEQGEN**  r12_reg_31_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r12in[31]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r12[31]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N466) );
  \**SEQGEN**  r12_reg_30_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r12in[30]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r12[30]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N466) );
  \**SEQGEN**  r12_reg_29_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r12in[29]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r12[29]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N466) );
  \**SEQGEN**  r12_reg_28_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r12in[28]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r12[28]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N466) );
  \**SEQGEN**  r12_reg_27_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r12in[27]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r12[27]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N466) );
  \**SEQGEN**  r12_reg_26_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r12in[26]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r12[26]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N466) );
  \**SEQGEN**  r12_reg_25_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r12in[25]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r12[25]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N466) );
  \**SEQGEN**  r12_reg_24_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r12in[24]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r12[24]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N466) );
  \**SEQGEN**  r12_reg_23_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r12in[23]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r12[23]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N466) );
  \**SEQGEN**  r12_reg_22_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r12in[22]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r12[22]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N466) );
  \**SEQGEN**  r12_reg_21_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r12in[21]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r12[21]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N466) );
  \**SEQGEN**  r12_reg_20_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r12in[20]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r12[20]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N466) );
  \**SEQGEN**  r12_reg_19_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r12in[19]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r12[19]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N466) );
  \**SEQGEN**  r12_reg_18_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r12in[18]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r12[18]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N466) );
  \**SEQGEN**  r12_reg_17_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r12in[17]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r12[17]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N466) );
  \**SEQGEN**  r12_reg_16_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r12in[16]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r12[16]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N466) );
  \**SEQGEN**  r12_reg_15_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r12in[15]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r12[15]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N466) );
  \**SEQGEN**  r12_reg_14_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r12in[14]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r12[14]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N466) );
  \**SEQGEN**  r12_reg_13_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r12in[13]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r12[13]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N466) );
  \**SEQGEN**  r12_reg_12_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r12in[12]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r12[12]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N466) );
  \**SEQGEN**  r12_reg_11_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r12in[11]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r12[11]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N466) );
  \**SEQGEN**  r12_reg_10_ ( .clear(1'b0), .preset(1'b0), .next_state(
        r12in[10]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        r12[10]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N466) );
  \**SEQGEN**  r12_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(r12in[9]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r12[9]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N466) );
  \**SEQGEN**  r12_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(r12in[8]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r12[8]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N466) );
  \**SEQGEN**  r12_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(r12in[7]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r12[7]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N466) );
  \**SEQGEN**  r12_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(r12in[6]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r12[6]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N466) );
  \**SEQGEN**  r12_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(r12in[5]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r12[5]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N466) );
  \**SEQGEN**  r12_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(r12in[4]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r12[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N466) );
  \**SEQGEN**  r12_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(r12in[3]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r12[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N466) );
  \**SEQGEN**  r12_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(r12in[2]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r12[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N466) );
  \**SEQGEN**  r12_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(r12in[1]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r12[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N466) );
  \**SEQGEN**  r12_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(r12in[0]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(r12[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N466) );
  \**SEQGEN**  lr_reg_31_ ( .clear(1'b0), .preset(1'b0), .next_state(lrin[31]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(lr[31]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N483) );
  \**SEQGEN**  lr_reg_30_ ( .clear(1'b0), .preset(1'b0), .next_state(lrin[30]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(lr[30]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N483) );
  \**SEQGEN**  lr_reg_29_ ( .clear(1'b0), .preset(1'b0), .next_state(lrin[29]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(lr[29]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N483) );
  \**SEQGEN**  lr_reg_28_ ( .clear(1'b0), .preset(1'b0), .next_state(lrin[28]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(lr[28]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N483) );
  \**SEQGEN**  lr_reg_27_ ( .clear(1'b0), .preset(1'b0), .next_state(lrin[27]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(lr[27]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N483) );
  \**SEQGEN**  lr_reg_26_ ( .clear(1'b0), .preset(1'b0), .next_state(lrin[26]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(lr[26]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N483) );
  \**SEQGEN**  lr_reg_25_ ( .clear(1'b0), .preset(1'b0), .next_state(lrin[25]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(lr[25]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N483) );
  \**SEQGEN**  lr_reg_24_ ( .clear(1'b0), .preset(1'b0), .next_state(lrin[24]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(lr[24]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N483) );
  \**SEQGEN**  lr_reg_23_ ( .clear(1'b0), .preset(1'b0), .next_state(lrin[23]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(lr[23]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N483) );
  \**SEQGEN**  lr_reg_22_ ( .clear(1'b0), .preset(1'b0), .next_state(lrin[22]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(lr[22]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N483) );
  \**SEQGEN**  lr_reg_21_ ( .clear(1'b0), .preset(1'b0), .next_state(lrin[21]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(lr[21]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N483) );
  \**SEQGEN**  lr_reg_20_ ( .clear(1'b0), .preset(1'b0), .next_state(lrin[20]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(lr[20]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N483) );
  \**SEQGEN**  lr_reg_19_ ( .clear(1'b0), .preset(1'b0), .next_state(lrin[19]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(lr[19]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N483) );
  \**SEQGEN**  lr_reg_18_ ( .clear(1'b0), .preset(1'b0), .next_state(lrin[18]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(lr[18]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N483) );
  \**SEQGEN**  lr_reg_17_ ( .clear(1'b0), .preset(1'b0), .next_state(lrin[17]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(lr[17]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N483) );
  \**SEQGEN**  lr_reg_16_ ( .clear(1'b0), .preset(1'b0), .next_state(lrin[16]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(lr[16]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N483) );
  \**SEQGEN**  lr_reg_15_ ( .clear(1'b0), .preset(1'b0), .next_state(lrin[15]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(lr[15]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N483) );
  \**SEQGEN**  lr_reg_14_ ( .clear(1'b0), .preset(1'b0), .next_state(lrin[14]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(lr[14]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N483) );
  \**SEQGEN**  lr_reg_13_ ( .clear(1'b0), .preset(1'b0), .next_state(lrin[13]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(lr[13]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N483) );
  \**SEQGEN**  lr_reg_12_ ( .clear(1'b0), .preset(1'b0), .next_state(lrin[12]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(lr[12]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N483) );
  \**SEQGEN**  lr_reg_11_ ( .clear(1'b0), .preset(1'b0), .next_state(lrin[11]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(lr[11]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N483) );
  \**SEQGEN**  lr_reg_10_ ( .clear(1'b0), .preset(1'b0), .next_state(lrin[10]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(lr[10]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N483) );
  \**SEQGEN**  lr_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(lrin[9]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(lr[9]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N483) );
  \**SEQGEN**  lr_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(lrin[8]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(lr[8]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N483) );
  \**SEQGEN**  lr_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(lrin[7]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(lr[7]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N483) );
  \**SEQGEN**  lr_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(lrin[6]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(lr[6]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N483) );
  \**SEQGEN**  lr_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(lrin[5]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(lr[5]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N483) );
  \**SEQGEN**  lr_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(lrin[4]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(lr[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N483) );
  \**SEQGEN**  lr_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(lrin[3]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(lr[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N483) );
  \**SEQGEN**  lr_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(lrin[2]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(lr[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N483) );
  \**SEQGEN**  lr_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(lrin[1]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(lr[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N483) );
  \**SEQGEN**  lr_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(lrin[0]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(lr[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N483) );
  \**SEQGEN**  sp_reg_31_ ( .clear(1'b0), .preset(1'b0), .next_state(spin[31]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(sp_out[31]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sp_reg_30_ ( .clear(1'b0), .preset(1'b0), .next_state(spin[30]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(sp_out[30]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sp_reg_29_ ( .clear(1'b0), .preset(1'b0), .next_state(spin[29]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(sp_out[29]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sp_reg_28_ ( .clear(1'b0), .preset(1'b0), .next_state(spin[28]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(sp_out[28]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sp_reg_27_ ( .clear(1'b0), .preset(1'b0), .next_state(spin[27]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(sp_out[27]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sp_reg_26_ ( .clear(1'b0), .preset(1'b0), .next_state(spin[26]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(sp_out[26]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sp_reg_25_ ( .clear(1'b0), .preset(1'b0), .next_state(spin[25]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(sp_out[25]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sp_reg_24_ ( .clear(1'b0), .preset(1'b0), .next_state(spin[24]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(sp_out[24]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sp_reg_23_ ( .clear(1'b0), .preset(1'b0), .next_state(spin[23]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(sp_out[23]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sp_reg_22_ ( .clear(1'b0), .preset(1'b0), .next_state(spin[22]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(sp_out[22]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sp_reg_21_ ( .clear(1'b0), .preset(1'b0), .next_state(spin[21]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(sp_out[21]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sp_reg_20_ ( .clear(1'b0), .preset(1'b0), .next_state(spin[20]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(sp_out[20]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sp_reg_19_ ( .clear(1'b0), .preset(1'b0), .next_state(spin[19]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(sp_out[19]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sp_reg_18_ ( .clear(1'b0), .preset(1'b0), .next_state(spin[18]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(sp_out[18]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sp_reg_17_ ( .clear(1'b0), .preset(1'b0), .next_state(spin[17]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(sp_out[17]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sp_reg_16_ ( .clear(1'b0), .preset(1'b0), .next_state(spin[16]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(sp_out[16]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sp_reg_15_ ( .clear(1'b0), .preset(1'b0), .next_state(spin[15]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(sp_out[15]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sp_reg_14_ ( .clear(1'b0), .preset(1'b0), .next_state(spin[14]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(sp_out[14]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sp_reg_13_ ( .clear(1'b0), .preset(1'b0), .next_state(spin[13]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(sp_out[13]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sp_reg_12_ ( .clear(1'b0), .preset(1'b0), .next_state(spin[12]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(sp_out[12]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sp_reg_11_ ( .clear(1'b0), .preset(1'b0), .next_state(spin[11]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(sp_out[11]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sp_reg_10_ ( .clear(1'b0), .preset(1'b0), .next_state(spin[10]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(sp_out[10]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sp_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(spin[9]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(sp_out[9]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sp_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(spin[8]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(sp_out[8]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sp_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(spin[7]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(sp_out[7]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sp_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(spin[6]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(sp_out[6]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sp_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(spin[5]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(sp_out[5]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sp_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(spin[4]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(sp_out[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sp_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(spin[3]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(sp_out[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sp_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(spin[2]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(sp_out[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sp_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(spin[1]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(sp_out[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sp_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(spin[0]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(sp_out[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  pc_reg_31_ ( .clear(1'b0), .preset(1'b0), .next_state(pcin[31]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(pc_out[31]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N504) );
  \**SEQGEN**  pc_reg_30_ ( .clear(1'b0), .preset(1'b0), .next_state(pcin[30]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(pc_out[30]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N504) );
  \**SEQGEN**  pc_reg_29_ ( .clear(1'b0), .preset(1'b0), .next_state(pcin[29]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(pc_out[29]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N504) );
  \**SEQGEN**  pc_reg_28_ ( .clear(1'b0), .preset(1'b0), .next_state(pcin[28]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(pc_out[28]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N504) );
  \**SEQGEN**  pc_reg_27_ ( .clear(1'b0), .preset(1'b0), .next_state(pcin[27]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(pc_out[27]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N504) );
  \**SEQGEN**  pc_reg_26_ ( .clear(1'b0), .preset(1'b0), .next_state(pcin[26]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(pc_out[26]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N504) );
  \**SEQGEN**  pc_reg_25_ ( .clear(1'b0), .preset(1'b0), .next_state(pcin[25]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(pc_out[25]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N504) );
  \**SEQGEN**  pc_reg_24_ ( .clear(1'b0), .preset(1'b0), .next_state(pcin[24]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(pc_out[24]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N504) );
  \**SEQGEN**  pc_reg_23_ ( .clear(1'b0), .preset(1'b0), .next_state(pcin[23]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(pc_out[23]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N504) );
  \**SEQGEN**  pc_reg_22_ ( .clear(1'b0), .preset(1'b0), .next_state(pcin[22]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(pc_out[22]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N504) );
  \**SEQGEN**  pc_reg_21_ ( .clear(1'b0), .preset(1'b0), .next_state(pcin[21]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(pc_out[21]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N504) );
  \**SEQGEN**  pc_reg_20_ ( .clear(1'b0), .preset(1'b0), .next_state(pcin[20]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(pc_out[20]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N504) );
  \**SEQGEN**  pc_reg_19_ ( .clear(1'b0), .preset(1'b0), .next_state(pcin[19]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(pc_out[19]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N504) );
  \**SEQGEN**  pc_reg_18_ ( .clear(1'b0), .preset(1'b0), .next_state(pcin[18]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(pc_out[18]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N504) );
  \**SEQGEN**  pc_reg_17_ ( .clear(1'b0), .preset(1'b0), .next_state(pcin[17]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(pc_out[17]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N504) );
  \**SEQGEN**  pc_reg_16_ ( .clear(1'b0), .preset(1'b0), .next_state(pcin[16]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(pc_out[16]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N504) );
  \**SEQGEN**  pc_reg_15_ ( .clear(1'b0), .preset(1'b0), .next_state(pcin[15]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(pc_out[15]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N504) );
  \**SEQGEN**  pc_reg_14_ ( .clear(1'b0), .preset(1'b0), .next_state(pcin[14]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(pc_out[14]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N504) );
  \**SEQGEN**  pc_reg_13_ ( .clear(1'b0), .preset(1'b0), .next_state(pcin[13]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(pc_out[13]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N504) );
  \**SEQGEN**  pc_reg_12_ ( .clear(1'b0), .preset(1'b0), .next_state(pcin[12]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(pc_out[12]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N504) );
  \**SEQGEN**  pc_reg_11_ ( .clear(1'b0), .preset(1'b0), .next_state(pcin[11]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(pc_out[11]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N504) );
  \**SEQGEN**  pc_reg_10_ ( .clear(1'b0), .preset(1'b0), .next_state(pcin[10]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(pc_out[10]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N504) );
  \**SEQGEN**  pc_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(pcin[9]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(pc_out[9]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N504) );
  \**SEQGEN**  pc_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(pcin[8]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(pc_out[8]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N504) );
  \**SEQGEN**  pc_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(pcin[7]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(pc_out[7]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N504) );
  \**SEQGEN**  pc_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(pcin[6]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(pc_out[6]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N504) );
  \**SEQGEN**  pc_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(pcin[5]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(pc_out[5]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N504) );
  \**SEQGEN**  pc_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(pcin[4]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(pc_out[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N504) );
  \**SEQGEN**  pc_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(pcin[3]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(pc_out[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N504) );
  \**SEQGEN**  pc_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(pcin[2]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(pc_out[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N504) );
  \**SEQGEN**  pc_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(pcin[1]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(pc_out[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N504) );
  \**SEQGEN**  pc_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(pcin[0]), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(pc_out[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N504) );
  \**SEQGEN**  cpsr_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        cpsrin[3]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        cpsr_out[3]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  cpsr_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        cpsrin[2]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        cpsr_out[2]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  cpsr_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        cpsrin[1]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        cpsr_out[1]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  cpsr_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        cpsrin[0]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        cpsr_out[0]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  tmp1_reg_31_ ( .clear(1'b0), .preset(1'b0), .next_state(
        tmp1in[31]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        tmp1[31]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(N497) );
  \**SEQGEN**  tmp1_reg_30_ ( .clear(1'b0), .preset(1'b0), .next_state(
        tmp1in[30]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        tmp1[30]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(N497) );
  \**SEQGEN**  tmp1_reg_29_ ( .clear(1'b0), .preset(1'b0), .next_state(
        tmp1in[29]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        tmp1[29]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(N497) );
  \**SEQGEN**  tmp1_reg_28_ ( .clear(1'b0), .preset(1'b0), .next_state(
        tmp1in[28]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        tmp1[28]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(N497) );
  \**SEQGEN**  tmp1_reg_27_ ( .clear(1'b0), .preset(1'b0), .next_state(
        tmp1in[27]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        tmp1[27]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(N497) );
  \**SEQGEN**  tmp1_reg_26_ ( .clear(1'b0), .preset(1'b0), .next_state(
        tmp1in[26]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        tmp1[26]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(N497) );
  \**SEQGEN**  tmp1_reg_25_ ( .clear(1'b0), .preset(1'b0), .next_state(
        tmp1in[25]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        tmp1[25]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(N497) );
  \**SEQGEN**  tmp1_reg_24_ ( .clear(1'b0), .preset(1'b0), .next_state(
        tmp1in[24]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        tmp1[24]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(N497) );
  \**SEQGEN**  tmp1_reg_23_ ( .clear(1'b0), .preset(1'b0), .next_state(
        tmp1in[23]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        tmp1[23]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(N497) );
  \**SEQGEN**  tmp1_reg_22_ ( .clear(1'b0), .preset(1'b0), .next_state(
        tmp1in[22]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        tmp1[22]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(N497) );
  \**SEQGEN**  tmp1_reg_21_ ( .clear(1'b0), .preset(1'b0), .next_state(
        tmp1in[21]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        tmp1[21]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(N497) );
  \**SEQGEN**  tmp1_reg_20_ ( .clear(1'b0), .preset(1'b0), .next_state(
        tmp1in[20]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        tmp1[20]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(N497) );
  \**SEQGEN**  tmp1_reg_19_ ( .clear(1'b0), .preset(1'b0), .next_state(
        tmp1in[19]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        tmp1[19]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(N497) );
  \**SEQGEN**  tmp1_reg_18_ ( .clear(1'b0), .preset(1'b0), .next_state(
        tmp1in[18]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        tmp1[18]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(N497) );
  \**SEQGEN**  tmp1_reg_17_ ( .clear(1'b0), .preset(1'b0), .next_state(
        tmp1in[17]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        tmp1[17]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(N497) );
  \**SEQGEN**  tmp1_reg_16_ ( .clear(1'b0), .preset(1'b0), .next_state(
        tmp1in[16]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        tmp1[16]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(N497) );
  \**SEQGEN**  tmp1_reg_15_ ( .clear(1'b0), .preset(1'b0), .next_state(
        tmp1in[15]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        tmp1[15]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(N497) );
  \**SEQGEN**  tmp1_reg_14_ ( .clear(1'b0), .preset(1'b0), .next_state(
        tmp1in[14]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        tmp1[14]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(N497) );
  \**SEQGEN**  tmp1_reg_13_ ( .clear(1'b0), .preset(1'b0), .next_state(
        tmp1in[13]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        tmp1[13]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(N497) );
  \**SEQGEN**  tmp1_reg_12_ ( .clear(1'b0), .preset(1'b0), .next_state(
        tmp1in[12]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        tmp1[12]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(N497) );
  \**SEQGEN**  tmp1_reg_11_ ( .clear(1'b0), .preset(1'b0), .next_state(
        tmp1in[11]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        tmp1[11]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(N497) );
  \**SEQGEN**  tmp1_reg_10_ ( .clear(1'b0), .preset(1'b0), .next_state(
        tmp1in[10]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        tmp1[10]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(N497) );
  \**SEQGEN**  tmp1_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(
        tmp1in[9]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        tmp1[9]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N497) );
  \**SEQGEN**  tmp1_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(
        tmp1in[8]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        tmp1[8]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N497) );
  \**SEQGEN**  tmp1_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(
        tmp1in[7]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        tmp1[7]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N497) );
  \**SEQGEN**  tmp1_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(
        tmp1in[6]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        tmp1[6]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N497) );
  \**SEQGEN**  tmp1_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(
        tmp1in[5]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        tmp1[5]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N497) );
  \**SEQGEN**  tmp1_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(
        tmp1in[4]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        tmp1[4]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N497) );
  \**SEQGEN**  tmp1_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        tmp1in[3]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        tmp1[3]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N497) );
  \**SEQGEN**  tmp1_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        tmp1in[2]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        tmp1[2]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N497) );
  \**SEQGEN**  tmp1_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        tmp1in[1]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        tmp1[1]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N497) );
  \**SEQGEN**  tmp1_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        tmp1in[0]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        tmp1[0]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N497) );
  GTECH_OR2 C2312 ( .A(write2_sel[3]), .B(write2_sel[4]), .Z(N505) );
  GTECH_OR2 C2313 ( .A(write2_sel[2]), .B(N505), .Z(N506) );
  GTECH_OR2 C2314 ( .A(write2_sel[1]), .B(N506), .Z(N507) );
  GTECH_OR2 C2315 ( .A(write2_sel[0]), .B(N507), .Z(N508) );
  GTECH_NOT I_0 ( .A(N508), .Z(N509) );
  GTECH_NOT I_1 ( .A(write2_sel[0]), .Z(N510) );
  GTECH_OR2 C2321 ( .A(N510), .B(N507), .Z(N511) );
  GTECH_NOT I_2 ( .A(N511), .Z(N512) );
  GTECH_NOT I_3 ( .A(write2_sel[1]), .Z(N513) );
  GTECH_OR2 C2326 ( .A(N513), .B(N506), .Z(N514) );
  GTECH_OR2 C2327 ( .A(write2_sel[0]), .B(N514), .Z(N515) );
  GTECH_NOT I_4 ( .A(N515), .Z(N516) );
  GTECH_OR2 C2334 ( .A(N510), .B(N514), .Z(N517) );
  GTECH_NOT I_5 ( .A(N517), .Z(N518) );
  GTECH_NOT I_6 ( .A(write2_sel[2]), .Z(N519) );
  GTECH_OR2 C2338 ( .A(N519), .B(N505), .Z(N520) );
  GTECH_OR2 C2339 ( .A(write2_sel[1]), .B(N520), .Z(N521) );
  GTECH_OR2 C2340 ( .A(write2_sel[0]), .B(N521), .Z(N522) );
  GTECH_NOT I_7 ( .A(N522), .Z(N523) );
  GTECH_OR2 C2347 ( .A(N510), .B(N521), .Z(N524) );
  GTECH_NOT I_8 ( .A(N524), .Z(N525) );
  GTECH_OR2 C2353 ( .A(N513), .B(N520), .Z(N526) );
  GTECH_OR2 C2354 ( .A(write2_sel[0]), .B(N526), .Z(N527) );
  GTECH_NOT I_9 ( .A(N527), .Z(N528) );
  GTECH_OR2 C2362 ( .A(N510), .B(N526), .Z(N529) );
  GTECH_NOT I_10 ( .A(N529), .Z(N530) );
  GTECH_NOT I_11 ( .A(write2_sel[3]), .Z(N531) );
  GTECH_OR2 C2365 ( .A(N531), .B(write2_sel[4]), .Z(N532) );
  GTECH_OR2 C2366 ( .A(write2_sel[2]), .B(N532), .Z(N533) );
  GTECH_OR2 C2367 ( .A(write2_sel[1]), .B(N533), .Z(N534) );
  GTECH_OR2 C2368 ( .A(write2_sel[0]), .B(N534), .Z(N535) );
  GTECH_NOT I_12 ( .A(N535), .Z(N536) );
  GTECH_OR2 C2375 ( .A(N510), .B(N534), .Z(N537) );
  GTECH_NOT I_13 ( .A(N537), .Z(N538) );
  GTECH_OR2 C2381 ( .A(N513), .B(N533), .Z(N539) );
  GTECH_OR2 C2382 ( .A(write2_sel[0]), .B(N539), .Z(N540) );
  GTECH_NOT I_14 ( .A(N540), .Z(N541) );
  GTECH_OR2 C2390 ( .A(N510), .B(N539), .Z(N542) );
  GTECH_NOT I_15 ( .A(N542), .Z(N543) );
  GTECH_OR2 C2395 ( .A(N519), .B(N532), .Z(N544) );
  GTECH_OR2 C2396 ( .A(write2_sel[1]), .B(N544), .Z(N545) );
  GTECH_OR2 C2397 ( .A(write2_sel[0]), .B(N545), .Z(N546) );
  GTECH_NOT I_16 ( .A(N546), .Z(N547) );
  GTECH_OR2 C2404 ( .A(N513), .B(N544), .Z(N548) );
  GTECH_OR2 C2405 ( .A(write2_sel[0]), .B(N548), .Z(N549) );
  GTECH_NOT I_17 ( .A(N549), .Z(N550) );
  GTECH_OR2 C2413 ( .A(N510), .B(N545), .Z(N551) );
  GTECH_NOT I_18 ( .A(N551), .Z(N552) );
  GTECH_NOT I_19 ( .A(write2_sel[4]), .Z(N553) );
  GTECH_OR2 C2419 ( .A(N531), .B(N553), .Z(N554) );
  GTECH_OR2 C2420 ( .A(N519), .B(N554), .Z(N555) );
  GTECH_OR2 C2421 ( .A(N513), .B(N555), .Z(N556) );
  GTECH_OR2 C2422 ( .A(write2_sel[0]), .B(N556), .Z(N557) );
  GTECH_NOT I_20 ( .A(N557), .Z(N558) );
  GTECH_OR2 C2424 ( .A(write1_sel[3]), .B(write1_sel[4]), .Z(N559) );
  GTECH_OR2 C2425 ( .A(write1_sel[2]), .B(N559), .Z(N560) );
  GTECH_OR2 C2426 ( .A(write1_sel[1]), .B(N560), .Z(N561) );
  GTECH_OR2 C2427 ( .A(write1_sel[0]), .B(N561), .Z(N562) );
  GTECH_NOT I_21 ( .A(N562), .Z(N563) );
  GTECH_NOT I_22 ( .A(write1_sel[0]), .Z(N564) );
  GTECH_OR2 C2433 ( .A(N564), .B(N561), .Z(N565) );
  GTECH_NOT I_23 ( .A(N565), .Z(N566) );
  GTECH_NOT I_24 ( .A(write1_sel[1]), .Z(N567) );
  GTECH_OR2 C2438 ( .A(N567), .B(N560), .Z(N568) );
  GTECH_OR2 C2439 ( .A(write1_sel[0]), .B(N568), .Z(N569) );
  GTECH_NOT I_25 ( .A(N569), .Z(N570) );
  GTECH_OR2 C2446 ( .A(N564), .B(N568), .Z(N571) );
  GTECH_NOT I_26 ( .A(N571), .Z(N572) );
  GTECH_NOT I_27 ( .A(write1_sel[2]), .Z(N573) );
  GTECH_OR2 C2450 ( .A(N573), .B(N559), .Z(N574) );
  GTECH_OR2 C2451 ( .A(write1_sel[1]), .B(N574), .Z(N575) );
  GTECH_OR2 C2452 ( .A(write1_sel[0]), .B(N575), .Z(N576) );
  GTECH_NOT I_28 ( .A(N576), .Z(N577) );
  GTECH_OR2 C2459 ( .A(N564), .B(N575), .Z(N578) );
  GTECH_NOT I_29 ( .A(N578), .Z(N579) );
  GTECH_OR2 C2465 ( .A(N567), .B(N574), .Z(N580) );
  GTECH_OR2 C2466 ( .A(write1_sel[0]), .B(N580), .Z(N581) );
  GTECH_NOT I_30 ( .A(N581), .Z(N582) );
  GTECH_OR2 C2474 ( .A(N564), .B(N580), .Z(N583) );
  GTECH_NOT I_31 ( .A(N583), .Z(N584) );
  GTECH_NOT I_32 ( .A(write1_sel[3]), .Z(N585) );
  GTECH_OR2 C2477 ( .A(N585), .B(write1_sel[4]), .Z(N586) );
  GTECH_OR2 C2478 ( .A(write1_sel[2]), .B(N586), .Z(N587) );
  GTECH_OR2 C2479 ( .A(write1_sel[1]), .B(N587), .Z(N588) );
  GTECH_OR2 C2480 ( .A(write1_sel[0]), .B(N588), .Z(N589) );
  GTECH_NOT I_33 ( .A(N589), .Z(N590) );
  GTECH_OR2 C2487 ( .A(N564), .B(N588), .Z(N591) );
  GTECH_NOT I_34 ( .A(N591), .Z(N592) );
  GTECH_OR2 C2493 ( .A(N567), .B(N587), .Z(N593) );
  GTECH_OR2 C2494 ( .A(write1_sel[0]), .B(N593), .Z(N594) );
  GTECH_NOT I_35 ( .A(N594), .Z(N595) );
  GTECH_OR2 C2502 ( .A(N564), .B(N593), .Z(N596) );
  GTECH_NOT I_36 ( .A(N596), .Z(N597) );
  GTECH_OR2 C2507 ( .A(N573), .B(N586), .Z(N598) );
  GTECH_OR2 C2508 ( .A(write1_sel[1]), .B(N598), .Z(N599) );
  GTECH_OR2 C2509 ( .A(write1_sel[0]), .B(N599), .Z(N600) );
  GTECH_NOT I_37 ( .A(N600), .Z(N601) );
  GTECH_OR2 C2516 ( .A(N567), .B(N598), .Z(N602) );
  GTECH_OR2 C2517 ( .A(write1_sel[0]), .B(N602), .Z(N603) );
  GTECH_NOT I_38 ( .A(N603), .Z(N604) );
  GTECH_OR2 C2525 ( .A(N564), .B(N599), .Z(N605) );
  GTECH_NOT I_39 ( .A(N605), .Z(N606) );
  GTECH_OR2 C2534 ( .A(N564), .B(N602), .Z(N607) );
  GTECH_NOT I_40 ( .A(N607), .Z(N608) );
  GTECH_OR2 C2543 ( .A(N510), .B(N548), .Z(N609) );
  GTECH_NOT I_41 ( .A(N609), .Z(N610) );
  GTECH_NOT I_42 ( .A(write1_sel[4]), .Z(N611) );
  GTECH_OR2 C2558 ( .A(N585), .B(N611), .Z(N612) );
  GTECH_OR2 C2559 ( .A(N573), .B(N612), .Z(N613) );
  GTECH_OR2 C2560 ( .A(N567), .B(N613), .Z(N614) );
  GTECH_OR2 C2561 ( .A(write1_sel[0]), .B(N614), .Z(N615) );
  GTECH_NOT I_43 ( .A(N615), .Z(N616) );
  ADD_UNS_OP add_439 ( .A(pc_write_in), .B({1'b1, 1'b0}), .Z(
        pc_write_in_plus_two) );
  SELECT_OP C3043 ( .DATA1(r0), .DATA2(r1), .DATA3(r2), .DATA4(r3), .DATA5(r4), 
        .DATA6(r5), .DATA7(r6), .DATA8(r7), .DATA9(r8), .DATA10(r9), .DATA11(
        r10), .DATA12(r11), .DATA13(r12), .DATA14(sp_out), .DATA15(lr), 
        .DATA16(pc_out), .DATA17(tmp1), .DATA18(immediate1_in), .DATA19({1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .CONTROL1(N0), .CONTROL2(
        N1), .CONTROL3(N2), .CONTROL4(N3), .CONTROL5(N4), .CONTROL6(N5), 
        .CONTROL7(N6), .CONTROL8(N7), .CONTROL9(N8), .CONTROL10(N9), 
        .CONTROL11(N10), .CONTROL12(N11), .CONTROL13(N12), .CONTROL14(N13), 
        .CONTROL15(N14), .CONTROL16(N15), .CONTROL17(N16), .CONTROL18(N17), 
        .CONTROL19(N18), .Z(regA_out) );
  GTECH_BUF B_0 ( .A(N82), .Z(N0) );
  GTECH_BUF B_1 ( .A(N87), .Z(N1) );
  GTECH_BUF B_2 ( .A(N91), .Z(N2) );
  GTECH_BUF B_3 ( .A(N93), .Z(N3) );
  GTECH_BUF B_4 ( .A(N97), .Z(N4) );
  GTECH_BUF B_5 ( .A(N99), .Z(N5) );
  GTECH_BUF B_6 ( .A(N103), .Z(N6) );
  GTECH_BUF B_7 ( .A(N105), .Z(N7) );
  GTECH_BUF B_8 ( .A(N109), .Z(N8) );
  GTECH_BUF B_9 ( .A(N111), .Z(N9) );
  GTECH_BUF B_10 ( .A(N114), .Z(N10) );
  GTECH_BUF B_11 ( .A(N116), .Z(N11) );
  GTECH_BUF B_12 ( .A(N119), .Z(N12) );
  GTECH_BUF B_13 ( .A(N121), .Z(N13) );
  GTECH_BUF B_14 ( .A(N124), .Z(N14) );
  GTECH_BUF B_15 ( .A(N126), .Z(N15) );
  GTECH_BUF B_16 ( .A(N130), .Z(N16) );
  GTECH_BUF B_17 ( .A(N134), .Z(N17) );
  GTECH_BUF B_18 ( .A(N141), .Z(N18) );
  SELECT_OP C3044 ( .DATA1(r0), .DATA2(r1), .DATA3(r2), .DATA4(r3), .DATA5(r4), 
        .DATA6(r5), .DATA7(r6), .DATA8(r7), .DATA9(r8), .DATA10(r9), .DATA11(
        r10), .DATA12(r11), .DATA13(r12), .DATA14(sp_out), .DATA15(lr), 
        .DATA16(pc_out), .DATA17(tmp1), .DATA18(immediate2_in), .DATA19({1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .CONTROL1(N19), .CONTROL2(
        N20), .CONTROL3(N21), .CONTROL4(N22), .CONTROL5(N23), .CONTROL6(N24), 
        .CONTROL7(N25), .CONTROL8(N26), .CONTROL9(N27), .CONTROL10(N28), 
        .CONTROL11(N29), .CONTROL12(N30), .CONTROL13(N31), .CONTROL14(N32), 
        .CONTROL15(N33), .CONTROL16(N34), .CONTROL17(N35), .CONTROL18(N36), 
        .CONTROL19(N37), .Z(regB_out) );
  GTECH_BUF B_19 ( .A(N147), .Z(N19) );
  GTECH_BUF B_20 ( .A(N152), .Z(N20) );
  GTECH_BUF B_21 ( .A(N156), .Z(N21) );
  GTECH_BUF B_22 ( .A(N158), .Z(N22) );
  GTECH_BUF B_23 ( .A(N162), .Z(N23) );
  GTECH_BUF B_24 ( .A(N164), .Z(N24) );
  GTECH_BUF B_25 ( .A(N168), .Z(N25) );
  GTECH_BUF B_26 ( .A(N170), .Z(N26) );
  GTECH_BUF B_27 ( .A(N174), .Z(N27) );
  GTECH_BUF B_28 ( .A(N176), .Z(N28) );
  GTECH_BUF B_29 ( .A(N179), .Z(N29) );
  GTECH_BUF B_30 ( .A(N181), .Z(N30) );
  GTECH_BUF B_31 ( .A(N184), .Z(N31) );
  GTECH_BUF B_32 ( .A(N186), .Z(N32) );
  GTECH_BUF B_33 ( .A(N189), .Z(N33) );
  GTECH_BUF B_34 ( .A(N191), .Z(N34) );
  GTECH_BUF B_35 ( .A(N195), .Z(N35) );
  GTECH_BUF B_36 ( .A(N199), .Z(N36) );
  GTECH_BUF B_37 ( .A(N206), .Z(N37) );
  SELECT_OP C3045 ( .DATA1(r0), .DATA2(r1), .DATA3(r2), .DATA4(r3), .DATA5(r4), 
        .DATA6(r5), .DATA7(r6), .DATA8(r7), .DATA9(r8), .DATA10(r9), .DATA11(
        r10), .DATA12(r11), .DATA13(r12), .DATA14(sp_out), .DATA15(lr), 
        .DATA16(pc_out), .CONTROL1(N38), .CONTROL2(N39), .CONTROL3(N40), 
        .CONTROL4(N41), .CONTROL5(N42), .CONTROL6(N43), .CONTROL7(N44), 
        .CONTROL8(N45), .CONTROL9(N46), .CONTROL10(N47), .CONTROL11(N48), 
        .CONTROL12(N49), .CONTROL13(N50), .CONTROL14(N51), .CONTROL15(N52), 
        .CONTROL16(N53), .Z({N285, N284, N283, N282, N281, N280, N279, N278, 
        N277, N276, N275, N274, N273, N272, N271, N270, N269, N268, N267, N266, 
        N265, N264, N263, N262, N261, N260, N259, N258, N257, N256, N255, N254}) );
  GTECH_BUF B_38 ( .A(N214), .Z(N38) );
  GTECH_BUF B_39 ( .A(N218), .Z(N39) );
  GTECH_BUF B_40 ( .A(N221), .Z(N40) );
  GTECH_BUF B_41 ( .A(N224), .Z(N41) );
  GTECH_BUF B_42 ( .A(N228), .Z(N42) );
  GTECH_BUF B_43 ( .A(N230), .Z(N43) );
  GTECH_BUF B_44 ( .A(N232), .Z(N44) );
  GTECH_BUF B_45 ( .A(N234), .Z(N45) );
  GTECH_BUF B_46 ( .A(N237), .Z(N46) );
  GTECH_BUF B_47 ( .A(N239), .Z(N47) );
  GTECH_BUF B_48 ( .A(N241), .Z(N48) );
  GTECH_BUF B_49 ( .A(N243), .Z(N49) );
  GTECH_BUF B_50 ( .A(N246), .Z(N50) );
  GTECH_BUF B_51 ( .A(N248), .Z(N51) );
  GTECH_BUF B_52 ( .A(N250), .Z(N52) );
  GTECH_BUF B_53 ( .A(N253), .Z(N53) );
  SELECT_OP C3046 ( .DATA1({N285, N284, N283, N282, N281, N280, N279, N278, 
        N277, N276, N275, N274, N273, N272, N271, N270, N269, N268, N267, N266, 
        N265, N264, N263, N262, N261, N260, N259, N258, N257, N256, N255, N254}), .DATA2({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .CONTROL1(N54), 
        .CONTROL2(N55), .Z(regC_out) );
  GTECH_BUF B_54 ( .A(N207), .Z(N54) );
  GTECH_BUF B_55 ( .A(readC_sel[4]), .Z(N55) );
  SELECT_OP C3047 ( .DATA1(r0), .DATA2(r1), .DATA3(r2), .DATA4(r3), .DATA5(r4), 
        .DATA6(r5), .DATA7(r6), .DATA8(r7), .DATA9(r8), .DATA10(r9), .DATA11(
        r10), .DATA12(r11), .DATA13(r12), .DATA14(sp_out), .DATA15(lr), 
        .DATA16(pc_out), .CONTROL1(N56), .CONTROL2(N57), .CONTROL3(N58), 
        .CONTROL4(N59), .CONTROL5(N60), .CONTROL6(N61), .CONTROL7(N62), 
        .CONTROL8(N63), .CONTROL9(N64), .CONTROL10(N65), .CONTROL11(N66), 
        .CONTROL12(N67), .CONTROL13(N68), .CONTROL14(N69), .CONTROL15(N70), 
        .CONTROL16(N71), .Z({N364, N363, N362, N361, N360, N359, N358, N357, 
        N356, N355, N354, N353, N352, N351, N350, N349, N348, N347, N346, N345, 
        N344, N343, N342, N341, N340, N339, N338, N337, N336, N335, N334, N333}) );
  GTECH_BUF B_56 ( .A(N293), .Z(N56) );
  GTECH_BUF B_57 ( .A(N297), .Z(N57) );
  GTECH_BUF B_58 ( .A(N300), .Z(N58) );
  GTECH_BUF B_59 ( .A(N303), .Z(N59) );
  GTECH_BUF B_60 ( .A(N307), .Z(N60) );
  GTECH_BUF B_61 ( .A(N309), .Z(N61) );
  GTECH_BUF B_62 ( .A(N311), .Z(N62) );
  GTECH_BUF B_63 ( .A(N313), .Z(N63) );
  GTECH_BUF B_64 ( .A(N316), .Z(N64) );
  GTECH_BUF B_65 ( .A(N318), .Z(N65) );
  GTECH_BUF B_66 ( .A(N320), .Z(N66) );
  GTECH_BUF B_67 ( .A(N322), .Z(N67) );
  GTECH_BUF B_68 ( .A(N325), .Z(N68) );
  GTECH_BUF B_69 ( .A(N327), .Z(N69) );
  GTECH_BUF B_70 ( .A(N329), .Z(N70) );
  GTECH_BUF B_71 ( .A(N332), .Z(N71) );
  SELECT_OP C3048 ( .DATA1({N364, N363, N362, N361, N360, N359, N358, N357, 
        N356, N355, N354, N353, N352, N351, N350, N349, N348, N347, N346, N345, 
        N344, N343, N342, N341, N340, N339, N338, N337, N336, N335, N334, N333}), .DATA2({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .CONTROL1(N72), 
        .CONTROL2(N73), .Z(regD_out) );
  GTECH_BUF B_72 ( .A(N286), .Z(N72) );
  GTECH_BUF B_73 ( .A(readD_sel[4]), .Z(N73) );
  SELECT_OP C3049 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA2(write1_in), .DATA3(write2_in), .CONTROL1(N74), .CONTROL2(N370), 
        .CONTROL3(N373), .Z(r0in) );
  GTECH_BUF B_74 ( .A(reset), .Z(N74) );
  SELECT_OP C3050 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA2(write1_in), .DATA3(write2_in), .CONTROL1(N74), .CONTROL2(N378), 
        .CONTROL3(N381), .Z(r1in) );
  SELECT_OP C3051 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA2(write1_in), .DATA3(write2_in), .CONTROL1(N74), .CONTROL2(N387), 
        .CONTROL3(N390), .Z(r2in) );
  SELECT_OP C3052 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA2(write1_in), .DATA3(write2_in), .CONTROL1(N74), .CONTROL2(N395), 
        .CONTROL3(N398), .Z(r3in) );
  SELECT_OP C3053 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA2(write1_in), .DATA3(write2_in), .CONTROL1(N74), .CONTROL2(N403), 
        .CONTROL3(N406), .Z(r4in) );
  SELECT_OP C3054 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA2(write1_in), .DATA3(write2_in), .CONTROL1(N74), .CONTROL2(N411), 
        .CONTROL3(N414), .Z(r5in) );
  SELECT_OP C3055 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA2(write1_in), .DATA3(write2_in), .CONTROL1(N74), .CONTROL2(N419), 
        .CONTROL3(N422), .Z(r6in) );
  SELECT_OP C3056 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA2(write1_in), .DATA3(write2_in), .CONTROL1(N74), .CONTROL2(N427), 
        .CONTROL3(N430), .Z(r7in) );
  SELECT_OP C3057 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA2(write1_in), .DATA3(write2_in), .CONTROL1(N74), .CONTROL2(N435), 
        .CONTROL3(N438), .Z(r8in) );
  SELECT_OP C3058 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA2(write1_in), .DATA3(write2_in), .CONTROL1(N74), .CONTROL2(N443), 
        .CONTROL3(N446), .Z(r9in) );
  SELECT_OP C3059 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA2(write1_in), .DATA3(write2_in), .CONTROL1(N74), .CONTROL2(N451), 
        .CONTROL3(N454), .Z(r10in) );
  SELECT_OP C3060 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA2(write1_in), .DATA3(write2_in), .CONTROL1(N74), .CONTROL2(N459), 
        .CONTROL3(N462), .Z(r11in) );
  SELECT_OP C3061 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA2(write1_in), .DATA3(write2_in), .CONTROL1(N74), .CONTROL2(N467), 
        .CONTROL3(N470), .Z(r12in) );
  SELECT_OP C3062 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 
        1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0}), .DATA2(write1_in), .DATA3(write2_in), .DATA4(next_sp_in), .CONTROL1(N74), 
        .CONTROL2(N476), .CONTROL3(N479), .CONTROL4(N475), .Z(spin) );
  SELECT_OP C3063 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA2(write1_in), .DATA3(write2_in), .CONTROL1(N74), .CONTROL2(N484), 
        .CONTROL3(N487), .Z(lrin) );
  SELECT_OP C3064 ( .DATA1(write1_in), .DATA2(write2_in), .CONTROL1(N75), 
        .CONTROL2(N490), .Z(pc_write_in) );
  GTECH_BUF B_75 ( .A(N489), .Z(N75) );
  SELECT_OP C3065 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0}), .DATA2(pc_write_in_plus_two), .DATA3(next_pc_in), .CONTROL1(N74), 
        .CONTROL2(N493), .CONTROL3(N492), .Z(pcin) );
  SELECT_OP C3066 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA2(write1_in), .DATA3(write2_in), .CONTROL1(N74), .CONTROL2(N498), 
        .CONTROL3(N501), .Z(tmp1in) );
  SELECT_OP C3067 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0}), .DATA2(next_cpsr_in), 
        .CONTROL1(N74), .CONTROL2(N76), .Z(cpsrin) );
  GTECH_BUF B_76 ( .A(N502), .Z(N76) );
  GTECH_NOT I_44 ( .A(readA_sel[4]), .Z(N77) );
  GTECH_NOT I_45 ( .A(readA_sel[0]), .Z(N78) );
  GTECH_NOT I_46 ( .A(N86), .Z(N87) );
  GTECH_NOT I_47 ( .A(N90), .Z(N91) );
  GTECH_NOT I_48 ( .A(N92), .Z(N93) );
  GTECH_NOT I_49 ( .A(N96), .Z(N97) );
  GTECH_NOT I_50 ( .A(N98), .Z(N99) );
  GTECH_NOT I_51 ( .A(N102), .Z(N103) );
  GTECH_NOT I_52 ( .A(N104), .Z(N105) );
  GTECH_NOT I_53 ( .A(N108), .Z(N109) );
  GTECH_NOT I_54 ( .A(N110), .Z(N111) );
  GTECH_NOT I_55 ( .A(N113), .Z(N114) );
  GTECH_NOT I_56 ( .A(N115), .Z(N116) );
  GTECH_NOT I_57 ( .A(N118), .Z(N119) );
  GTECH_NOT I_58 ( .A(N120), .Z(N121) );
  GTECH_NOT I_59 ( .A(N123), .Z(N124) );
  GTECH_NOT I_60 ( .A(N125), .Z(N126) );
  GTECH_NOT I_61 ( .A(N129), .Z(N130) );
  GTECH_NOT I_62 ( .A(readA_sel[3]), .Z(N135) );
  GTECH_NOT I_63 ( .A(readA_sel[2]), .Z(N137) );
  GTECH_NOT I_64 ( .A(readA_sel[1]), .Z(N139) );
  GTECH_OR2 C3091 ( .A(N136), .B(N617), .Z(N141) );
  GTECH_OR2 C3092 ( .A(N138), .B(N140), .Z(N617) );
  GTECH_NOT I_65 ( .A(readB_sel[4]), .Z(N142) );
  GTECH_NOT I_66 ( .A(readB_sel[0]), .Z(N143) );
  GTECH_NOT I_67 ( .A(N151), .Z(N152) );
  GTECH_NOT I_68 ( .A(N155), .Z(N156) );
  GTECH_NOT I_69 ( .A(N157), .Z(N158) );
  GTECH_NOT I_70 ( .A(N161), .Z(N162) );
  GTECH_NOT I_71 ( .A(N163), .Z(N164) );
  GTECH_NOT I_72 ( .A(N167), .Z(N168) );
  GTECH_NOT I_73 ( .A(N169), .Z(N170) );
  GTECH_NOT I_74 ( .A(N173), .Z(N174) );
  GTECH_NOT I_75 ( .A(N175), .Z(N176) );
  GTECH_NOT I_76 ( .A(N178), .Z(N179) );
  GTECH_NOT I_77 ( .A(N180), .Z(N181) );
  GTECH_NOT I_78 ( .A(N183), .Z(N184) );
  GTECH_NOT I_79 ( .A(N185), .Z(N186) );
  GTECH_NOT I_80 ( .A(N188), .Z(N189) );
  GTECH_NOT I_81 ( .A(N190), .Z(N191) );
  GTECH_NOT I_82 ( .A(N194), .Z(N195) );
  GTECH_NOT I_83 ( .A(readB_sel[3]), .Z(N200) );
  GTECH_NOT I_84 ( .A(readB_sel[2]), .Z(N202) );
  GTECH_NOT I_85 ( .A(readB_sel[1]), .Z(N204) );
  GTECH_OR2 C3133 ( .A(N201), .B(N618), .Z(N206) );
  GTECH_OR2 C3134 ( .A(N203), .B(N205), .Z(N618) );
  GTECH_NOT I_86 ( .A(readC_sel[4]), .Z(N207) );
  GTECH_NOT I_87 ( .A(readC_sel[3]), .Z(N208) );
  GTECH_NOT I_88 ( .A(readC_sel[2]), .Z(N209) );
  GTECH_NOT I_89 ( .A(readC_sel[1]), .Z(N210) );
  GTECH_NOT I_90 ( .A(readC_sel[0]), .Z(N211) );
  GTECH_NOT I_91 ( .A(N217), .Z(N218) );
  GTECH_NOT I_92 ( .A(N220), .Z(N221) );
  GTECH_NOT I_93 ( .A(N223), .Z(N224) );
  GTECH_NOT I_94 ( .A(N227), .Z(N228) );
  GTECH_NOT I_95 ( .A(N229), .Z(N230) );
  GTECH_NOT I_96 ( .A(N231), .Z(N232) );
  GTECH_NOT I_97 ( .A(N233), .Z(N234) );
  GTECH_NOT I_98 ( .A(N236), .Z(N237) );
  GTECH_NOT I_99 ( .A(N238), .Z(N239) );
  GTECH_NOT I_100 ( .A(N240), .Z(N241) );
  GTECH_NOT I_101 ( .A(N242), .Z(N243) );
  GTECH_NOT I_102 ( .A(N245), .Z(N246) );
  GTECH_NOT I_103 ( .A(N247), .Z(N248) );
  GTECH_NOT I_104 ( .A(N249), .Z(N250) );
  GTECH_NOT I_105 ( .A(readD_sel[4]), .Z(N286) );
  GTECH_NOT I_106 ( .A(readD_sel[3]), .Z(N287) );
  GTECH_NOT I_107 ( .A(readD_sel[2]), .Z(N288) );
  GTECH_NOT I_108 ( .A(readD_sel[1]), .Z(N289) );
  GTECH_NOT I_109 ( .A(readD_sel[0]), .Z(N290) );
  GTECH_NOT I_110 ( .A(N296), .Z(N297) );
  GTECH_NOT I_111 ( .A(N299), .Z(N300) );
  GTECH_NOT I_112 ( .A(N302), .Z(N303) );
  GTECH_NOT I_113 ( .A(N306), .Z(N307) );
  GTECH_NOT I_114 ( .A(N308), .Z(N309) );
  GTECH_NOT I_115 ( .A(N310), .Z(N311) );
  GTECH_NOT I_116 ( .A(N312), .Z(N313) );
  GTECH_NOT I_117 ( .A(N315), .Z(N316) );
  GTECH_NOT I_118 ( .A(N317), .Z(N318) );
  GTECH_NOT I_119 ( .A(N319), .Z(N320) );
  GTECH_NOT I_120 ( .A(N321), .Z(N322) );
  GTECH_NOT I_121 ( .A(N324), .Z(N325) );
  GTECH_NOT I_122 ( .A(N326), .Z(N327) );
  GTECH_NOT I_123 ( .A(N328), .Z(N329) );
  GTECH_AND2 C3228 ( .A(N563), .B(write1_en), .Z(N365) );
  GTECH_AND2 C3229 ( .A(N509), .B(write2_en), .Z(N366) );
  GTECH_OR2 C3232 ( .A(N365), .B(reset), .Z(N367) );
  GTECH_OR2 C3233 ( .A(N366), .B(N367), .Z(N368) );
  GTECH_NOT I_124 ( .A(reset), .Z(N369) );
  GTECH_AND2 C3236 ( .A(N365), .B(N369), .Z(N370) );
  GTECH_NOT I_125 ( .A(N365), .Z(N371) );
  GTECH_AND2 C3238 ( .A(N369), .B(N371), .Z(N372) );
  GTECH_AND2 C3239 ( .A(N366), .B(N372), .Z(N373) );
  GTECH_AND2 C3240 ( .A(N566), .B(write1_en), .Z(N374) );
  GTECH_AND2 C3241 ( .A(N512), .B(write2_en), .Z(N375) );
  GTECH_OR2 C3244 ( .A(N374), .B(reset), .Z(N376) );
  GTECH_OR2 C3245 ( .A(N375), .B(N376), .Z(N377) );
  GTECH_AND2 C3247 ( .A(N374), .B(N369), .Z(N378) );
  GTECH_NOT I_126 ( .A(N374), .Z(N379) );
  GTECH_AND2 C3249 ( .A(N369), .B(N379), .Z(N380) );
  GTECH_AND2 C3250 ( .A(N375), .B(N380), .Z(N381) );
  GTECH_AND2 C3251 ( .A(N570), .B(write1_en), .Z(N382) );
  GTECH_AND2 C3252 ( .A(N516), .B(write2_en), .Z(N383) );
  GTECH_OR2 C3256 ( .A(N382), .B(reset), .Z(N384) );
  GTECH_OR2 C3257 ( .A(N383), .B(N384), .Z(N385) );
  GTECH_NOT I_127 ( .A(reset), .Z(N386) );
  GTECH_AND2 C3260 ( .A(N382), .B(N386), .Z(N387) );
  GTECH_NOT I_128 ( .A(N382), .Z(N388) );
  GTECH_AND2 C3262 ( .A(N386), .B(N388), .Z(N389) );
  GTECH_AND2 C3263 ( .A(N383), .B(N389), .Z(N390) );
  GTECH_AND2 C3264 ( .A(N572), .B(write1_en), .Z(N391) );
  GTECH_AND2 C3265 ( .A(N518), .B(write2_en), .Z(N392) );
  GTECH_OR2 C3269 ( .A(N391), .B(reset), .Z(N393) );
  GTECH_OR2 C3270 ( .A(N392), .B(N393), .Z(N394) );
  GTECH_AND2 C3273 ( .A(N391), .B(N386), .Z(N395) );
  GTECH_NOT I_129 ( .A(N391), .Z(N396) );
  GTECH_AND2 C3275 ( .A(N386), .B(N396), .Z(N397) );
  GTECH_AND2 C3276 ( .A(N392), .B(N397), .Z(N398) );
  GTECH_AND2 C3277 ( .A(N577), .B(write1_en), .Z(N399) );
  GTECH_AND2 C3278 ( .A(N523), .B(write2_en), .Z(N400) );
  GTECH_OR2 C3282 ( .A(N399), .B(reset), .Z(N401) );
  GTECH_OR2 C3283 ( .A(N400), .B(N401), .Z(N402) );
  GTECH_AND2 C3286 ( .A(N399), .B(N386), .Z(N403) );
  GTECH_NOT I_130 ( .A(N399), .Z(N404) );
  GTECH_AND2 C3288 ( .A(N386), .B(N404), .Z(N405) );
  GTECH_AND2 C3289 ( .A(N400), .B(N405), .Z(N406) );
  GTECH_AND2 C3290 ( .A(N579), .B(write1_en), .Z(N407) );
  GTECH_AND2 C3291 ( .A(N525), .B(write2_en), .Z(N408) );
  GTECH_OR2 C3295 ( .A(N407), .B(reset), .Z(N409) );
  GTECH_OR2 C3296 ( .A(N408), .B(N409), .Z(N410) );
  GTECH_AND2 C3299 ( .A(N407), .B(N386), .Z(N411) );
  GTECH_NOT I_131 ( .A(N407), .Z(N412) );
  GTECH_AND2 C3301 ( .A(N386), .B(N412), .Z(N413) );
  GTECH_AND2 C3302 ( .A(N408), .B(N413), .Z(N414) );
  GTECH_AND2 C3303 ( .A(N582), .B(write1_en), .Z(N415) );
  GTECH_AND2 C3304 ( .A(N528), .B(write2_en), .Z(N416) );
  GTECH_OR2 C3308 ( .A(N415), .B(reset), .Z(N417) );
  GTECH_OR2 C3309 ( .A(N416), .B(N417), .Z(N418) );
  GTECH_AND2 C3312 ( .A(N415), .B(N386), .Z(N419) );
  GTECH_NOT I_132 ( .A(N415), .Z(N420) );
  GTECH_AND2 C3314 ( .A(N386), .B(N420), .Z(N421) );
  GTECH_AND2 C3315 ( .A(N416), .B(N421), .Z(N422) );
  GTECH_AND2 C3316 ( .A(N584), .B(write1_en), .Z(N423) );
  GTECH_AND2 C3317 ( .A(N530), .B(write2_en), .Z(N424) );
  GTECH_OR2 C3321 ( .A(N423), .B(reset), .Z(N425) );
  GTECH_OR2 C3322 ( .A(N424), .B(N425), .Z(N426) );
  GTECH_AND2 C3325 ( .A(N423), .B(N386), .Z(N427) );
  GTECH_NOT I_133 ( .A(N423), .Z(N428) );
  GTECH_AND2 C3327 ( .A(N386), .B(N428), .Z(N429) );
  GTECH_AND2 C3328 ( .A(N424), .B(N429), .Z(N430) );
  GTECH_AND2 C3329 ( .A(N590), .B(write1_en), .Z(N431) );
  GTECH_AND2 C3330 ( .A(N536), .B(write2_en), .Z(N432) );
  GTECH_OR2 C3334 ( .A(N431), .B(reset), .Z(N433) );
  GTECH_OR2 C3335 ( .A(N432), .B(N433), .Z(N434) );
  GTECH_AND2 C3338 ( .A(N431), .B(N386), .Z(N435) );
  GTECH_NOT I_134 ( .A(N431), .Z(N436) );
  GTECH_AND2 C3340 ( .A(N386), .B(N436), .Z(N437) );
  GTECH_AND2 C3341 ( .A(N432), .B(N437), .Z(N438) );
  GTECH_AND2 C3342 ( .A(N592), .B(write1_en), .Z(N439) );
  GTECH_AND2 C3343 ( .A(N538), .B(write2_en), .Z(N440) );
  GTECH_OR2 C3347 ( .A(N439), .B(reset), .Z(N441) );
  GTECH_OR2 C3348 ( .A(N440), .B(N441), .Z(N442) );
  GTECH_AND2 C3351 ( .A(N439), .B(N386), .Z(N443) );
  GTECH_NOT I_135 ( .A(N439), .Z(N444) );
  GTECH_AND2 C3353 ( .A(N386), .B(N444), .Z(N445) );
  GTECH_AND2 C3354 ( .A(N440), .B(N445), .Z(N446) );
  GTECH_AND2 C3355 ( .A(N595), .B(write1_en), .Z(N447) );
  GTECH_AND2 C3356 ( .A(N541), .B(write2_en), .Z(N448) );
  GTECH_OR2 C3360 ( .A(N447), .B(reset), .Z(N449) );
  GTECH_OR2 C3361 ( .A(N448), .B(N449), .Z(N450) );
  GTECH_AND2 C3364 ( .A(N447), .B(N386), .Z(N451) );
  GTECH_NOT I_136 ( .A(N447), .Z(N452) );
  GTECH_AND2 C3366 ( .A(N386), .B(N452), .Z(N453) );
  GTECH_AND2 C3367 ( .A(N448), .B(N453), .Z(N454) );
  GTECH_AND2 C3368 ( .A(N597), .B(write1_en), .Z(N455) );
  GTECH_AND2 C3369 ( .A(N543), .B(write2_en), .Z(N456) );
  GTECH_OR2 C3373 ( .A(N455), .B(reset), .Z(N457) );
  GTECH_OR2 C3374 ( .A(N456), .B(N457), .Z(N458) );
  GTECH_AND2 C3377 ( .A(N455), .B(N386), .Z(N459) );
  GTECH_NOT I_137 ( .A(N455), .Z(N460) );
  GTECH_AND2 C3379 ( .A(N386), .B(N460), .Z(N461) );
  GTECH_AND2 C3380 ( .A(N456), .B(N461), .Z(N462) );
  GTECH_AND2 C3381 ( .A(N601), .B(write1_en), .Z(N463) );
  GTECH_AND2 C3382 ( .A(N547), .B(write2_en), .Z(N464) );
  GTECH_OR2 C3386 ( .A(N463), .B(reset), .Z(N465) );
  GTECH_OR2 C3387 ( .A(N464), .B(N465), .Z(N466) );
  GTECH_AND2 C3390 ( .A(N463), .B(N386), .Z(N467) );
  GTECH_NOT I_138 ( .A(N463), .Z(N468) );
  GTECH_AND2 C3392 ( .A(N386), .B(N468), .Z(N469) );
  GTECH_AND2 C3393 ( .A(N464), .B(N469), .Z(N470) );
  GTECH_AND2 C3394 ( .A(N606), .B(write1_en), .Z(N471) );
  GTECH_AND2 C3395 ( .A(N552), .B(write2_en), .Z(N472) );
  GTECH_OR2 C3398 ( .A(N471), .B(reset), .Z(N473) );
  GTECH_OR2 C3399 ( .A(N472), .B(N473), .Z(N474) );
  GTECH_NOT I_139 ( .A(N474), .Z(N475) );
  GTECH_AND2 C3401 ( .A(N471), .B(N386), .Z(N476) );
  GTECH_NOT I_140 ( .A(N471), .Z(N477) );
  GTECH_AND2 C3403 ( .A(N386), .B(N477), .Z(N478) );
  GTECH_AND2 C3404 ( .A(N472), .B(N478), .Z(N479) );
  GTECH_AND2 C3405 ( .A(N604), .B(write1_en), .Z(N480) );
  GTECH_AND2 C3406 ( .A(N550), .B(write2_en), .Z(N481) );
  GTECH_OR2 C3410 ( .A(N480), .B(reset), .Z(N482) );
  GTECH_OR2 C3411 ( .A(N481), .B(N482), .Z(N483) );
  GTECH_AND2 C3414 ( .A(N480), .B(N386), .Z(N484) );
  GTECH_NOT I_141 ( .A(N480), .Z(N485) );
  GTECH_AND2 C3416 ( .A(N386), .B(N485), .Z(N486) );
  GTECH_AND2 C3417 ( .A(N481), .B(N486), .Z(N487) );
  GTECH_OR2 C3418 ( .A(N619), .B(N620), .Z(pc_write_select) );
  GTECH_AND2 C3419 ( .A(write1_en), .B(N608), .Z(N619) );
  GTECH_AND2 C3420 ( .A(write2_en), .B(N610), .Z(N620) );
  GTECH_NOT I_142 ( .A(next_pc_en), .Z(N488) );
  GTECH_AND2 C3423 ( .A(write1_en), .B(N608), .Z(N489) );
  GTECH_NOT I_143 ( .A(N489), .Z(N490) );
  GTECH_OR2 C3428 ( .A(pc_write_select), .B(reset), .Z(N491) );
  GTECH_NOT I_144 ( .A(N491), .Z(N492) );
  GTECH_AND2 C3431 ( .A(pc_write_select), .B(N386), .Z(N493) );
  GTECH_AND2 C3432 ( .A(N616), .B(write1_en), .Z(N494) );
  GTECH_AND2 C3433 ( .A(N558), .B(write2_en), .Z(N495) );
  GTECH_OR2 C3437 ( .A(N494), .B(reset), .Z(N496) );
  GTECH_OR2 C3438 ( .A(N495), .B(N496), .Z(N497) );
  GTECH_AND2 C3441 ( .A(N494), .B(N386), .Z(N498) );
  GTECH_NOT I_145 ( .A(N494), .Z(N499) );
  GTECH_AND2 C3443 ( .A(N386), .B(N499), .Z(N500) );
  GTECH_AND2 C3444 ( .A(N495), .B(N500), .Z(N501) );
  GTECH_NOT I_146 ( .A(reset), .Z(N502) );
  GTECH_AND2 C3462 ( .A(N488), .B(N492), .Z(N503) );
  GTECH_NOT I_147 ( .A(N503), .Z(N504) );
endmodule


module ALU_VARIABLE ( a, b, op, c_in, result, c_out, z, n, v );
  input [31:0] a;
  input [31:0] b;
  input [3:0] op;
  output [31:0] result;
  input c_in;
  output c_out, z, n, v;
  wire   N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15,
         N16, N17, N18, N19, N20, N21, N22, N23, N24, N25, N26, N27, N28, N29,
         N30, N31, N32, N33, N34, N35, N36, N37, N38, N39, N40, N41, N42, N43,
         N44, N45, N46, N47, N48, N49, N50, N51, N52, N53, N54, N55, N56, N57,
         N58, N59, N60, N61, N62, N63, N64, N65, N66, N67, N68, N69, N70, N71,
         N72, N73, N74, N75, N76, N77, N78, N79, N80, N81, N82, N83, N84, N85,
         N86, N87, N88, N89, N90, N91, N92, N93, N94, N95, N96, N97, N98, N99,
         N100, N101, N102, N103, N104, N105, N106, N107, N108, N109, N110,
         N111, N112, N113, N114, N115, N116, N117, N118, N119, N120, N121,
         N122, N123, N124, N125, N126, N127, N128, N129, N130, N131, N132,
         N133, N134, N135, N136, N137, N138, N139, N140, N141, N142, N143,
         N144, N145, N146, N147, N148, N149, N150, N151, N152, N153, N154,
         N155, N156, N157, N158, N159, N160, N161, N162, N163, N164, N165,
         N166, N167, N168, N169, N170, N171, N172, N173, N174, N175, N176,
         N177, N178, N179, N180, N181, N182, N183, N184, N185, N186, N187,
         N188, N189, N190, N191, N192, N193, N194, N195, N196, N197, N198,
         N199, N200, N201, N202, N203, N204, N205, N206, N207, N208, N209,
         N210, N211, N212, N213, N214, N215, N216, N217, N218, N219, N220,
         N221, N222, N223, N224, N225, N226, N227, N228, N229, N230, N231,
         N232, N233, N234, N235, N236, N237, N238, N239, N240, N241, N242,
         N243, N244, N245, N246, N247, N248, N249, N250, N251, N252, N253,
         N254, N255, N256, N257, N258, N259, N260, N261, N262, N263, N264,
         N265, N266, N267, N268, N269, N270, N271, N272, N273, N274, N275,
         N276, N277, N278, N279, N280, N281, N282, N283, N284, N285, N286,
         N287, N288, N289, N290, N291, N292, N293, N294, N295, N296, N297,
         N298, N299, N300, N301, N302, N303, N304, N305, N306, N307, N308,
         N309, N310, N311, N312, N313, N314, N315, N316, N317, N318, N319,
         N320, N321, N322, N323, N324, N325, N326, N327, N328, N329, N330,
         N331, N332, N333, N334, N335, N336, N337, N338, N339, N340, N341,
         N342, N343, N344, N345, N346, N347, N348, N349, N350, N351, N352,
         N353, N354, N355, N356, N357, N358, N359, N360, N361, N362, N363,
         N364, N365, N366, N367, N368, N369, N370, N371, N372, N373, N374,
         N375, N376, N377, N378, N379, N380, N381, N382, N383, N384, N385,
         N386, N387, N388, N389, N390, N391, N392, N393, N394, N395, N396,
         N397, N398, N399, N400, N401, N402, N403, N404, N405, N406, N407,
         N408, N409, N410, N411, N412, N413, N414, N415, N416, N417, N418,
         N419, N420, N421, N422, N423, N424, N425, N426, N427, N428, N429,
         N430, N431, N432, N433, N434, N435, N436, N437, N438, N439, N440,
         N441, N442, N443, N444, N445, N446, N447, N448, N449, N450, N451,
         N452, N453, N454, N455, N456, N457, N458, N459, N460, N461, N462,
         N463, N464, N465, N466, N467, N468, N469, N470, N471, N472, N473,
         N474, N475, N476, N477, N478, N479, N480, N481, N482, N483, N484,
         N485, N486, N487, N488, N489, N490, N491, N492, N493, N494, N495,
         N496, N497, N498, N499, N500, N501, N502, N503, N504, N505, N506,
         N507, N508, N509, N510, N511, N512, N513, N514, N515, N516, N517,
         N518, N519, N520, N521, N522, N523, N524, N525, N526, N527, N528,
         N529, N530, N531, N532, N533, N534, N535, N536, N537, N538, N539,
         N540, N541, N542, N543, N544, N545, N546, N547, N548, N549, N550,
         N551, N552, N553, N554, N555, N556, N557, N558, N559, N560, N561,
         N562, N563, N564, N565, N566, N567, N568, N569, N570, N571, N572,
         N573, N574, N575, N576, N577, N578, N579, N580, N581, N582, N583,
         N584, N585, N586, N587, N588, N589, N590, N591, N592, N593, N594,
         N595, N596, N597, N598, N599, N600, N601, N602, N603, N604, N605,
         N606, N607, N608, N609, N610, N611, N612, N613, N614, N615, N616,
         N617, N618, N619, N620, N621, N622, N623, N624, N625, N626, N627,
         N628, N629, N630, N631, N632, N633, N634, N635, N636, N637, N638,
         N639, N640, N641, N642, N643, N644, N645, N646, N647, N648, N649,
         N650, N651, N652, N653, N654, N655, N656, N657, N658, N659, N660,
         N661, N662, N663, N664, N665, N666, N667, N668, N669, N670, N671,
         N672, N673, N674, N675, N676, N677, N678, N679, N680, N681, N682,
         N683, N684, N685, N686, N687, N688, N689, N690, N691, N692, N693,
         N694, N695, N696, N697, N698, N699, N700, N701, N702, N703, N704,
         N705, N706, N707, N708, N709, N710, N711, N712, N713, N714, N715,
         N716, N717, N718, N719, N720, N721, N722, N723, N724, N725, N726,
         N727, N728, N729, N730, N731, N732, N733, N734, N735, N736, N737,
         N738, N739, N740, N741, N742, N743, N744, N745, N746, N747, N748,
         N749, N750, N751, N752, N753, N754, N755, N756, N757, N758, N759,
         N760, N761, N762, N763, N764, N765, N766, N767, N768, N769, N770,
         N771, N772, N773, N774, N775, N776, N777, N778, N779, N780, N781,
         N782, N783, N784, N785, N786, N787, N788, N789, N790, N791, N792,
         N793, N794, N795, N796, N797, N798, N799, N800, N801, N802, N803,
         N804, N805, N806, N807, N808, N809, N810, N811, N812, N813, N814,
         N815, N816, N817, N818, N819, N820, N821, N822, N823, N824, N825,
         N826, N827, N828, N829, N830, N831, N832, N833, N834, N835, N836,
         N837, N838, N839, N840, N841, N842, N843, N844, N845, N846, N847,
         N848, N849, N850, N851, N852, N853, N854, N855, N856, N857, N858,
         N859, N860, N861, N862, N863, N864, N865, N866, N867, N868, N869,
         N870, N871, N872, N873, N874, N875, N876, N877, N878, N879, N880,
         N881, N882, N883, N884, N885, N886, N887, N888, N889, N890, N891,
         N892, N893, N894, N895, N896, N897, N898, N899, N900, N901, N902,
         N903, N904, N905, N906, N907, N908, N909, N910, N911, N912, N913,
         N914, N915, N916, N917, N918, N919, N920, N921, N922, N923, N924,
         N925, N926, N927;

  GTECH_AND2 C8 ( .A(N8), .B(N9), .Z(N12) );
  GTECH_AND2 C9 ( .A(N10), .B(N11), .Z(N13) );
  GTECH_AND2 C10 ( .A(N12), .B(N13), .Z(N14) );
  GTECH_OR2 C12 ( .A(op[3]), .B(op[2]), .Z(N15) );
  GTECH_OR2 C13 ( .A(op[1]), .B(N11), .Z(N16) );
  GTECH_OR2 C14 ( .A(N15), .B(N16), .Z(N17) );
  GTECH_OR2 C19 ( .A(N15), .B(N48), .Z(N19) );
  GTECH_OR2 C24 ( .A(N10), .B(N11), .Z(N21) );
  GTECH_OR2 C25 ( .A(N15), .B(N21), .Z(N22) );
  GTECH_OR2 C28 ( .A(op[3]), .B(N9), .Z(N24) );
  GTECH_OR2 C30 ( .A(N24), .B(N34), .Z(N25) );
  GTECH_OR2 C36 ( .A(N24), .B(N16), .Z(N27) );
  GTECH_OR2 C42 ( .A(N24), .B(N48), .Z(N29) );
  GTECH_OR2 C49 ( .A(N24), .B(N21), .Z(N31) );
  GTECH_OR2 C52 ( .A(N8), .B(op[2]), .Z(N33) );
  GTECH_OR2 C53 ( .A(op[1]), .B(op[0]), .Z(N34) );
  GTECH_OR2 C54 ( .A(N33), .B(N34), .Z(N35) );
  GTECH_OR2 C60 ( .A(N33), .B(N16), .Z(N37) );
  GTECH_OR2 C66 ( .A(N33), .B(N48), .Z(N39) );
  GTECH_OR2 C73 ( .A(N33), .B(N21), .Z(N41) );
  GTECH_OR2 C77 ( .A(N8), .B(N9), .Z(N43) );
  GTECH_OR2 C79 ( .A(N43), .B(N34), .Z(N44) );
  GTECH_OR2 C86 ( .A(N43), .B(N16), .Z(N46) );
  GTECH_OR2 C92 ( .A(N10), .B(op[0]), .Z(N48) );
  GTECH_OR2 C93 ( .A(N43), .B(N48), .Z(N49) );
  GTECH_AND2 C95 ( .A(op[3]), .B(op[2]), .Z(N51) );
  GTECH_AND2 C96 ( .A(op[1]), .B(op[0]), .Z(N52) );
  GTECH_AND2 C97 ( .A(N51), .B(N52), .Z(N53) );
  ASH_UNS_UNS_OP sll_21 ( .A(a), .SH(b), .Z({N149, N148, N147, N146, N145, 
        N144, N143, N142, N141, N140, N139, N138, N137, N136, N135, N134, N133, 
        N132, N131, N130, N129, N128, N127, N126, N125, N124, N123, N122, N121, 
        N120, N119, N118}) );
  EQ_UNS_OP eq_22 ( .A({N149, N148, N147, N146, N145, N144, N143, N142, N141, 
        N140, N139, N138, N137, N136, N135, N134, N133, N132, N131, N130, N129, 
        N128, N127, N126, N125, N124, N123, N122, N121, N120, N119, N118}), 
        .B(1'b0), .Z(N150) );
  ASHR_UNS_UNS_OP srl_27 ( .A(a), .SH(b), .Z({N182, N181, N180, N179, N178, 
        N177, N176, N175, N174, N173, N172, N171, N170, N169, N168, N167, N166, 
        N165, N164, N163, N162, N161, N160, N159, N158, N157, N156, N155, N154, 
        N153, N152, N151}) );
  EQ_UNS_OP eq_28 ( .A({N182, N181, N180, N179, N178, N177, N176, N175, N174, 
        N173, N172, N171, N170, N169, N168, N167, N166, N165, N164, N163, N162, 
        N161, N160, N159, N158, N157, N156, N155, N154, N153, N152, N151}), 
        .B(1'b0), .Z(N183) );
  ASHR_TC_UNS_OP sra_33 ( .A(a), .SH(b), .Z({N215, N214, N213, N212, N211, 
        N210, N209, N208, N207, N206, N205, N204, N203, N202, N201, N200, N199, 
        N198, N197, N196, N195, N194, N193, N192, N191, N190, N189, N188, N187, 
        N186, N185, N184}) );
  EQ_UNS_OP eq_34 ( .A({N215, N214, N213, N212, N211, N210, N209, N208, N207, 
        N206, N205, N204, N203, N202, N201, N200, N199, N198, N197, N196, N195, 
        N194, N193, N192, N191, N190, N189, N188, N187, N186, N185, N184}), 
        .B(1'b0), .Z(N216) );
  EQ_UNS_OP eq_40 ( .A({N281, N280, N279, N278, N277, N276, N275, N274, N273, 
        N272, N271, N270, N269, N268, N267, N266, N265, N264, N263, N262, N261, 
        N260, N259, N258, N257, N256, N255, N254, N253, N252, N251, N250}), 
        .B(1'b0), .Z(N283) );
  GTECH_XOR2 C262 ( .A(a[31]), .B(b[31]), .Z(N0) );
  GTECH_NOT I_0 ( .A(N0), .Z(N284) );
  GTECH_XOR2 C263 ( .A(N282), .B(a[31]), .Z(N285) );
  EQ_UNS_OP eq_46 ( .A({N352, N351, N350, N349, N348, N347, N346, N345, N344, 
        N343, N342, N341, N340, N339, N338, N337, N336, N335, N334, N333, N332, 
        N331, N330, N329, N328, N327, N326, N325, N324, N323, N322, N321}), 
        .B(1'b0), .Z(N354) );
  GTECH_XOR2 C291 ( .A(a[31]), .B(b[31]), .Z(N355) );
  GTECH_XOR2 C292 ( .A(N353), .B(a[31]), .Z(N1) );
  GTECH_NOT I_1 ( .A(N1), .Z(N356) );
  ASHR_UNS_UNS_OP srl_51 ( .A(a), .SH(b[4:0]), .Z({N389, N388, N387, N386, 
        N385, N384, N383, N382, N381, N380, N379, N378, N377, N376, N375, N374, 
        N373, N372, N371, N370, N369, N368, N367, N366, N365, N364, N363, N362, 
        N361, N360, N359, N358}) );
  ASH_UNS_UNS_OP sll_51 ( .A(a), .SH({N396, N396, N396, N396, N396, N396, N396, 
        N396, N396, N396, N396, N396, N396, N396, N396, N396, N396, N396, N396, 
        N396, N396, N396, N396, N396, N396, N396, N395, N394, N393, N392, N391, 
        N390}), .Z({N428, N427, N426, N425, N424, N423, N422, N421, N420, N419, 
        N418, N417, N416, N415, N414, N413, N412, N411, N410, N409, N408, N407, 
        N406, N405, N404, N403, N402, N401, N400, N399, N398, N397}) );
  EQ_UNS_OP eq_64 ( .A({N492, N491, N490, N489, N488, N487, N486, N485, N484, 
        N483, N482, N481, N480, N479, N478, N477, N476, N475, N474, N473, N472, 
        N471, N470, N469, N468, N467, N466, N465, N464, N463, N462, N461}), 
        .B(1'b0), .Z(N494) );
  GTECH_XOR2 C406 ( .A(N493), .B(N492), .Z(N2) );
  GTECH_NOT I_2 ( .A(N2), .Z(N495) );
  EQ_UNS_OP eq_70 ( .A({N528, N527, N526, N525, N524, N523, N522, N521, N520, 
        N519, N518, N517, N516, N515, N514, N513, N512, N511, N510, N509, N508, 
        N507, N506, N505, N504, N503, N502, N501, N500, N499, N498, N497}), 
        .B(1'b0), .Z(N530) );
  GTECH_XOR2 C428 ( .A(N529), .B(a[31]), .Z(N3) );
  GTECH_NOT I_3 ( .A(N3), .Z(N531) );
  EQ_UNS_OP eq_76 ( .A({N564, N563, N562, N561, N560, N559, N558, N557, N556, 
        N555, N554, N553, N552, N551, N550, N549, N548, N547, N546, N545, N544, 
        N543, N542, N541, N540, N539, N538, N537, N536, N535, N534, N533}), 
        .B(1'b0), .Z(N566) );
  GTECH_XOR2 C451 ( .A(N565), .B(a[31]), .Z(N567) );
  EQ_UNS_OP eq_88 ( .A({N632, N631, N630, N629, N628, N627, N626, N625, N624, 
        N623, N622, N621, N620, N619, N618, N617, N616, N615, N614, N613, N612, 
        N611, N610, N609, N608, N607, N606, N605, N604, N603, N602, N601}), 
        .B(1'b0), .Z(N634) );
  GTECH_XOR2 C519 ( .A(N633), .B(N632), .Z(N4) );
  GTECH_NOT I_4 ( .A(N4), .Z(N635) );
  GTECH_OR2 C655 ( .A(N55), .B(N54), .Z(N701) );
  GTECH_OR2 C656 ( .A(N56), .B(N701), .Z(N702) );
  GTECH_OR2 C657 ( .A(N57), .B(N702), .Z(N703) );
  GTECH_OR2 C658 ( .A(N58), .B(N703), .Z(N704) );
  GTECH_OR2 C659 ( .A(N59), .B(N704), .Z(N705) );
  GTECH_OR2 C660 ( .A(N60), .B(N705), .Z(N706) );
  GTECH_OR2 C661 ( .A(N61), .B(N706), .Z(N707) );
  GTECH_OR2 C662 ( .A(N62), .B(N707), .Z(N708) );
  GTECH_OR2 C663 ( .A(N63), .B(N708), .Z(N709) );
  GTECH_OR2 C664 ( .A(N64), .B(N709), .Z(N710) );
  GTECH_OR2 C665 ( .A(N65), .B(N710), .Z(N711) );
  GTECH_OR2 C666 ( .A(N66), .B(N711), .Z(N712) );
  GTECH_OR2 C667 ( .A(N67), .B(N712), .Z(N713) );
  GTECH_OR2 C668 ( .A(N68), .B(N713), .Z(N714) );
  GTECH_OR2 C669 ( .A(N69), .B(N714), .Z(N715) );
  GTECH_OR2 C670 ( .A(N70), .B(N715), .Z(N716) );
  GTECH_OR2 C671 ( .A(N71), .B(N716), .Z(N717) );
  GTECH_OR2 C672 ( .A(N72), .B(N717), .Z(N718) );
  GTECH_OR2 C673 ( .A(N73), .B(N718), .Z(N719) );
  GTECH_OR2 C674 ( .A(N74), .B(N719), .Z(N720) );
  GTECH_OR2 C675 ( .A(N75), .B(N720), .Z(N721) );
  GTECH_OR2 C676 ( .A(N76), .B(N721), .Z(N722) );
  GTECH_OR2 C677 ( .A(N77), .B(N722), .Z(N723) );
  GTECH_OR2 C678 ( .A(N78), .B(N723), .Z(N724) );
  GTECH_OR2 C679 ( .A(N79), .B(N724), .Z(N725) );
  GTECH_OR2 C680 ( .A(N80), .B(N725), .Z(N726) );
  GTECH_OR2 C681 ( .A(N81), .B(N726), .Z(N727) );
  GTECH_OR2 C682 ( .A(N82), .B(N727), .Z(N728) );
  GTECH_OR2 C683 ( .A(N83), .B(N728), .Z(N729) );
  GTECH_OR2 C684 ( .A(N84), .B(N729), .Z(N730) );
  GTECH_OR2 C685 ( .A(N85), .B(N730), .Z(N731) );
  GTECH_NOT I_5 ( .A(N731), .Z(N732) );
  GTECH_OR2 C687 ( .A(N87), .B(N86), .Z(N733) );
  GTECH_OR2 C688 ( .A(N88), .B(N733), .Z(N734) );
  GTECH_OR2 C689 ( .A(N89), .B(N734), .Z(N735) );
  GTECH_OR2 C690 ( .A(N90), .B(N735), .Z(N736) );
  GTECH_OR2 C691 ( .A(N91), .B(N736), .Z(N737) );
  GTECH_OR2 C692 ( .A(N92), .B(N737), .Z(N738) );
  GTECH_OR2 C693 ( .A(N93), .B(N738), .Z(N739) );
  GTECH_OR2 C694 ( .A(N94), .B(N739), .Z(N740) );
  GTECH_OR2 C695 ( .A(N95), .B(N740), .Z(N741) );
  GTECH_OR2 C696 ( .A(N96), .B(N741), .Z(N742) );
  GTECH_OR2 C697 ( .A(N97), .B(N742), .Z(N743) );
  GTECH_OR2 C698 ( .A(N98), .B(N743), .Z(N744) );
  GTECH_OR2 C699 ( .A(N99), .B(N744), .Z(N745) );
  GTECH_OR2 C700 ( .A(N100), .B(N745), .Z(N746) );
  GTECH_OR2 C701 ( .A(N101), .B(N746), .Z(N747) );
  GTECH_OR2 C702 ( .A(N102), .B(N747), .Z(N748) );
  GTECH_OR2 C703 ( .A(N103), .B(N748), .Z(N749) );
  GTECH_OR2 C704 ( .A(N104), .B(N749), .Z(N750) );
  GTECH_OR2 C705 ( .A(N105), .B(N750), .Z(N751) );
  GTECH_OR2 C706 ( .A(N106), .B(N751), .Z(N752) );
  GTECH_OR2 C707 ( .A(N107), .B(N752), .Z(N753) );
  GTECH_OR2 C708 ( .A(N108), .B(N753), .Z(N754) );
  GTECH_OR2 C709 ( .A(N109), .B(N754), .Z(N755) );
  GTECH_OR2 C710 ( .A(N110), .B(N755), .Z(N756) );
  GTECH_OR2 C711 ( .A(N111), .B(N756), .Z(N757) );
  GTECH_OR2 C712 ( .A(N112), .B(N757), .Z(N758) );
  GTECH_OR2 C713 ( .A(N113), .B(N758), .Z(N759) );
  GTECH_OR2 C714 ( .A(N114), .B(N759), .Z(N760) );
  GTECH_OR2 C715 ( .A(N115), .B(N760), .Z(N761) );
  GTECH_OR2 C716 ( .A(N116), .B(N761), .Z(N762) );
  GTECH_OR2 C717 ( .A(N117), .B(N762), .Z(N763) );
  GTECH_NOT I_6 ( .A(N763), .Z(N764) );
  GTECH_OR2 C719 ( .A(N430), .B(N429), .Z(N765) );
  GTECH_OR2 C720 ( .A(N431), .B(N765), .Z(N766) );
  GTECH_OR2 C721 ( .A(N432), .B(N766), .Z(N767) );
  GTECH_OR2 C722 ( .A(N433), .B(N767), .Z(N768) );
  GTECH_OR2 C723 ( .A(N434), .B(N768), .Z(N769) );
  GTECH_OR2 C724 ( .A(N435), .B(N769), .Z(N770) );
  GTECH_OR2 C725 ( .A(N436), .B(N770), .Z(N771) );
  GTECH_OR2 C726 ( .A(N437), .B(N771), .Z(N772) );
  GTECH_OR2 C727 ( .A(N438), .B(N772), .Z(N773) );
  GTECH_OR2 C728 ( .A(N439), .B(N773), .Z(N774) );
  GTECH_OR2 C729 ( .A(N440), .B(N774), .Z(N775) );
  GTECH_OR2 C730 ( .A(N441), .B(N775), .Z(N776) );
  GTECH_OR2 C731 ( .A(N442), .B(N776), .Z(N777) );
  GTECH_OR2 C732 ( .A(N443), .B(N777), .Z(N778) );
  GTECH_OR2 C733 ( .A(N444), .B(N778), .Z(N779) );
  GTECH_OR2 C734 ( .A(N445), .B(N779), .Z(N780) );
  GTECH_OR2 C735 ( .A(N446), .B(N780), .Z(N781) );
  GTECH_OR2 C736 ( .A(N447), .B(N781), .Z(N782) );
  GTECH_OR2 C737 ( .A(N448), .B(N782), .Z(N783) );
  GTECH_OR2 C738 ( .A(N449), .B(N783), .Z(N784) );
  GTECH_OR2 C739 ( .A(N450), .B(N784), .Z(N785) );
  GTECH_OR2 C740 ( .A(N451), .B(N785), .Z(N786) );
  GTECH_OR2 C741 ( .A(N452), .B(N786), .Z(N787) );
  GTECH_OR2 C742 ( .A(N453), .B(N787), .Z(N788) );
  GTECH_OR2 C743 ( .A(N454), .B(N788), .Z(N789) );
  GTECH_OR2 C744 ( .A(N455), .B(N789), .Z(N790) );
  GTECH_OR2 C745 ( .A(N456), .B(N790), .Z(N791) );
  GTECH_OR2 C746 ( .A(N457), .B(N791), .Z(N792) );
  GTECH_OR2 C747 ( .A(N458), .B(N792), .Z(N793) );
  GTECH_OR2 C748 ( .A(N459), .B(N793), .Z(N794) );
  GTECH_OR2 C749 ( .A(N460), .B(N794), .Z(N795) );
  GTECH_NOT I_7 ( .A(N795), .Z(N796) );
  GTECH_OR2 C783 ( .A(N570), .B(N569), .Z(N797) );
  GTECH_OR2 C784 ( .A(N571), .B(N797), .Z(N798) );
  GTECH_OR2 C785 ( .A(N572), .B(N798), .Z(N799) );
  GTECH_OR2 C786 ( .A(N573), .B(N799), .Z(N800) );
  GTECH_OR2 C787 ( .A(N574), .B(N800), .Z(N801) );
  GTECH_OR2 C788 ( .A(N575), .B(N801), .Z(N802) );
  GTECH_OR2 C789 ( .A(N576), .B(N802), .Z(N803) );
  GTECH_OR2 C790 ( .A(N577), .B(N803), .Z(N804) );
  GTECH_OR2 C791 ( .A(N578), .B(N804), .Z(N805) );
  GTECH_OR2 C792 ( .A(N579), .B(N805), .Z(N806) );
  GTECH_OR2 C793 ( .A(N580), .B(N806), .Z(N807) );
  GTECH_OR2 C794 ( .A(N581), .B(N807), .Z(N808) );
  GTECH_OR2 C795 ( .A(N582), .B(N808), .Z(N809) );
  GTECH_OR2 C796 ( .A(N583), .B(N809), .Z(N810) );
  GTECH_OR2 C797 ( .A(N584), .B(N810), .Z(N811) );
  GTECH_OR2 C798 ( .A(N585), .B(N811), .Z(N812) );
  GTECH_OR2 C799 ( .A(N586), .B(N812), .Z(N813) );
  GTECH_OR2 C800 ( .A(N587), .B(N813), .Z(N814) );
  GTECH_OR2 C801 ( .A(N588), .B(N814), .Z(N815) );
  GTECH_OR2 C802 ( .A(N589), .B(N815), .Z(N816) );
  GTECH_OR2 C803 ( .A(N590), .B(N816), .Z(N817) );
  GTECH_OR2 C804 ( .A(N591), .B(N817), .Z(N818) );
  GTECH_OR2 C805 ( .A(N592), .B(N818), .Z(N819) );
  GTECH_OR2 C806 ( .A(N593), .B(N819), .Z(N820) );
  GTECH_OR2 C807 ( .A(N594), .B(N820), .Z(N821) );
  GTECH_OR2 C808 ( .A(N595), .B(N821), .Z(N822) );
  GTECH_OR2 C809 ( .A(N596), .B(N822), .Z(N823) );
  GTECH_OR2 C810 ( .A(N597), .B(N823), .Z(N824) );
  GTECH_OR2 C811 ( .A(N598), .B(N824), .Z(N825) );
  GTECH_OR2 C812 ( .A(N599), .B(N825), .Z(N826) );
  GTECH_OR2 C813 ( .A(N600), .B(N826), .Z(N827) );
  GTECH_NOT I_8 ( .A(N827), .Z(N828) );
  GTECH_OR2 C815 ( .A(N638), .B(N637), .Z(N829) );
  GTECH_OR2 C816 ( .A(N639), .B(N829), .Z(N830) );
  GTECH_OR2 C817 ( .A(N640), .B(N830), .Z(N831) );
  GTECH_OR2 C818 ( .A(N641), .B(N831), .Z(N832) );
  GTECH_OR2 C819 ( .A(N642), .B(N832), .Z(N833) );
  GTECH_OR2 C820 ( .A(N643), .B(N833), .Z(N834) );
  GTECH_OR2 C821 ( .A(N644), .B(N834), .Z(N835) );
  GTECH_OR2 C822 ( .A(N645), .B(N835), .Z(N836) );
  GTECH_OR2 C823 ( .A(N646), .B(N836), .Z(N837) );
  GTECH_OR2 C824 ( .A(N647), .B(N837), .Z(N838) );
  GTECH_OR2 C825 ( .A(N648), .B(N838), .Z(N839) );
  GTECH_OR2 C826 ( .A(N649), .B(N839), .Z(N840) );
  GTECH_OR2 C827 ( .A(N650), .B(N840), .Z(N841) );
  GTECH_OR2 C828 ( .A(N651), .B(N841), .Z(N842) );
  GTECH_OR2 C829 ( .A(N652), .B(N842), .Z(N843) );
  GTECH_OR2 C830 ( .A(N653), .B(N843), .Z(N844) );
  GTECH_OR2 C831 ( .A(N654), .B(N844), .Z(N845) );
  GTECH_OR2 C832 ( .A(N655), .B(N845), .Z(N846) );
  GTECH_OR2 C833 ( .A(N656), .B(N846), .Z(N847) );
  GTECH_OR2 C834 ( .A(N657), .B(N847), .Z(N848) );
  GTECH_OR2 C835 ( .A(N658), .B(N848), .Z(N849) );
  GTECH_OR2 C836 ( .A(N659), .B(N849), .Z(N850) );
  GTECH_OR2 C837 ( .A(N660), .B(N850), .Z(N851) );
  GTECH_OR2 C838 ( .A(N661), .B(N851), .Z(N852) );
  GTECH_OR2 C839 ( .A(N662), .B(N852), .Z(N853) );
  GTECH_OR2 C840 ( .A(N663), .B(N853), .Z(N854) );
  GTECH_OR2 C841 ( .A(N664), .B(N854), .Z(N855) );
  GTECH_OR2 C842 ( .A(N665), .B(N855), .Z(N856) );
  GTECH_OR2 C843 ( .A(N666), .B(N856), .Z(N857) );
  GTECH_OR2 C844 ( .A(N667), .B(N857), .Z(N858) );
  GTECH_OR2 C845 ( .A(N668), .B(N858), .Z(N859) );
  GTECH_NOT I_9 ( .A(N859), .Z(N860) );
  GTECH_OR2 C847 ( .A(N670), .B(N669), .Z(N861) );
  GTECH_OR2 C848 ( .A(N671), .B(N861), .Z(N862) );
  GTECH_OR2 C849 ( .A(N672), .B(N862), .Z(N863) );
  GTECH_OR2 C850 ( .A(N673), .B(N863), .Z(N864) );
  GTECH_OR2 C851 ( .A(N674), .B(N864), .Z(N865) );
  GTECH_OR2 C852 ( .A(N675), .B(N865), .Z(N866) );
  GTECH_OR2 C853 ( .A(N676), .B(N866), .Z(N867) );
  GTECH_OR2 C854 ( .A(N677), .B(N867), .Z(N868) );
  GTECH_OR2 C855 ( .A(N678), .B(N868), .Z(N869) );
  GTECH_OR2 C856 ( .A(N679), .B(N869), .Z(N870) );
  GTECH_OR2 C857 ( .A(N680), .B(N870), .Z(N871) );
  GTECH_OR2 C858 ( .A(N681), .B(N871), .Z(N872) );
  GTECH_OR2 C859 ( .A(N682), .B(N872), .Z(N873) );
  GTECH_OR2 C860 ( .A(N683), .B(N873), .Z(N874) );
  GTECH_OR2 C861 ( .A(N684), .B(N874), .Z(N875) );
  GTECH_OR2 C862 ( .A(N685), .B(N875), .Z(N876) );
  GTECH_OR2 C863 ( .A(N686), .B(N876), .Z(N877) );
  GTECH_OR2 C864 ( .A(N687), .B(N877), .Z(N878) );
  GTECH_OR2 C865 ( .A(N688), .B(N878), .Z(N879) );
  GTECH_OR2 C866 ( .A(N689), .B(N879), .Z(N880) );
  GTECH_OR2 C867 ( .A(N690), .B(N880), .Z(N881) );
  GTECH_OR2 C868 ( .A(N691), .B(N881), .Z(N882) );
  GTECH_OR2 C869 ( .A(N692), .B(N882), .Z(N883) );
  GTECH_OR2 C870 ( .A(N693), .B(N883), .Z(N884) );
  GTECH_OR2 C871 ( .A(N694), .B(N884), .Z(N885) );
  GTECH_OR2 C872 ( .A(N695), .B(N885), .Z(N886) );
  GTECH_OR2 C873 ( .A(N696), .B(N886), .Z(N887) );
  GTECH_OR2 C874 ( .A(N697), .B(N887), .Z(N888) );
  GTECH_OR2 C875 ( .A(N698), .B(N888), .Z(N889) );
  GTECH_OR2 C876 ( .A(N699), .B(N889), .Z(N890) );
  GTECH_OR2 C877 ( .A(N700), .B(N890), .Z(N891) );
  GTECH_NOT I_10 ( .A(N891), .Z(N892) );
  SUB_TC_OP sub_63 ( .A(1'b0), .B(a), .Z({N493, N492, N491, N490, N489, N488, 
        N487, N486, N485, N484, N483, N482, N481, N480, N479, N478, N477, N476, 
        N475, N474, N473, N472, N471, N470, N469, N468, N467, N466, N465, N464, 
        N463, N462, N461}) );
  MULT_TC_OP mult_87 ( .A(a), .B(b), .Z({N633, N632, N631, N630, N629, N628, 
        N627, N626, N625, N624, N623, N622, N621, N620, N619, N618, N617, N616, 
        N615, N614, N613, N612, N611, N610, N609, N608, N607, N606, N605, N604, 
        N603, N602, N601}) );
  SUB_TC_OP sub_69 ( .A(a), .B(b), .Z({N529, N528, N527, N526, N525, N524, 
        N523, N522, N521, N520, N519, N518, N517, N516, N515, N514, N513, N512, 
        N511, N510, N509, N508, N507, N506, N505, N504, N503, N502, N501, N500, 
        N499, N498, N497}) );
  ADD_TC_OP add_75 ( .A(a), .B(b), .Z({N565, N564, N563, N562, N561, N560, 
        N559, N558, N557, N556, N555, N554, N553, N552, N551, N550, N549, N548, 
        N547, N546, N545, N544, N543, N542, N541, N540, N539, N538, N537, N536, 
        N535, N534, N533}) );
  SUB_UNS_OP sub_51 ( .A({1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .B(b[4:0]), 
        .Z({N396, N395, N394, N393, N392, N391, N390}) );
  ADD_UNS_OP add_39 ( .A(a), .B(b), .Z({N249, N248, N247, N246, N245, N244, 
        N243, N242, N241, N240, N239, N238, N237, N236, N235, N234, N233, N232, 
        N231, N230, N229, N228, N227, N226, N225, N224, N223, N222, N221, N220, 
        N219, N218, N217}) );
  SUB_TC_OP sub_45 ( .A(a), .B(b), .Z({N320, N319, N318, N317, N316, N315, 
        N314, N313, N312, N311, N310, N309, N308, N307, N306, N305, N304, N303, 
        N302, N301, N300, N299, N298, N297, N296, N295, N294, N293, N292, N291, 
        N290, N289, N288}) );
  ADD_UNS_OP add_39_2 ( .A({N249, N248, N247, N246, N245, N244, N243, N242, 
        N241, N240, N239, N238, N237, N236, N235, N234, N233, N232, N231, N230, 
        N229, N228, N227, N226, N225, N224, N223, N222, N221, N220, N219, N218, 
        N217}), .B(c_in), .Z({N282, N281, N280, N279, N278, N277, N276, N275, 
        N274, N273, N272, N271, N270, N269, N268, N267, N266, N265, N264, N263, 
        N262, N261, N260, N259, N258, N257, N256, N255, N254, N253, N252, N251, 
        N250}) );
  SUB_TC_OP sub_45_2 ( .A({N320, N319, N318, N317, N316, N315, N314, N313, 
        N312, N311, N310, N309, N308, N307, N306, N305, N304, N303, N302, N301, 
        N300, N299, N298, N297, N296, N295, N294, N293, N292, N291, N290, N289, 
        N288}), .B({1'b0, N287}), .Z({N353, N352, N351, N350, N349, N348, N347, 
        N346, N345, N344, N343, N342, N341, N340, N339, N338, N337, N336, N335, 
        N334, N333, N332, N331, N330, N329, N328, N327, N326, N325, N324, N323, 
        N322, N321}) );
  GTECH_OR5 C879 ( .A(N14), .B(N18), .C(N20), .D(N23), .E(N26), .Z(N893) );
  GTECH_OR5 C880 ( .A(N32), .B(N36), .C(N45), .D(N50), .E(N53), .Z(N894) );
  GTECH_OR2 C881 ( .A(N893), .B(N894), .Z(N895) );
  GTECH_NOT I_11 ( .A(N495), .Z(N496) );
  GTECH_NOT I_12 ( .A(N635), .Z(N636) );
  SELECT_OP C889 ( .DATA1({N54, N55, N56, N57, N58, N59, N60, N61, N62, N63, 
        N64, N65, N66, N67, N68, N69, N70, N71, N72, N73, N74, N75, N76, N77, 
        N78, N79, N80, N81, N82, N83, N84, N85}), .DATA2({N86, N87, N88, N89, 
        N90, N91, N92, N93, N94, N95, N96, N97, N98, N99, N100, N101, N102, 
        N103, N104, N105, N106, N107, N108, N109, N110, N111, N112, N113, N114, 
        N115, N116, N117}), .DATA3({N149, N148, N147, N146, N145, N144, N143, 
        N142, N141, N140, N139, N138, N137, N136, N135, N134, N133, N132, N131, 
        N130, N129, N128, N127, N126, N125, N124, N123, N122, N121, N120, N119, 
        N118}), .DATA4({N182, N181, N180, N179, N178, N177, N176, N175, N174, 
        N173, N172, N171, N170, N169, N168, N167, N166, N165, N164, N163, N162, 
        N161, N160, N159, N158, N157, N156, N155, N154, N153, N152, N151}), 
        .DATA5({N215, N214, N213, N212, N211, N210, N209, N208, N207, N206, 
        N205, N204, N203, N202, N201, N200, N199, N198, N197, N196, N195, N194, 
        N193, N192, N191, N190, N189, N188, N187, N186, N185, N184}), .DATA6({
        N281, N280, N279, N278, N277, N276, N275, N274, N273, N272, N271, N270, 
        N269, N268, N267, N266, N265, N264, N263, N262, N261, N260, N259, N258, 
        N257, N256, N255, N254, N253, N252, N251, N250}), .DATA7({N352, N351, 
        N350, N349, N348, N347, N346, N345, N344, N343, N342, N341, N340, N339, 
        N338, N337, N336, N335, N334, N333, N332, N331, N330, N329, N328, N327, 
        N326, N325, N324, N323, N322, N321}), .DATA8({N429, N430, N431, N432, 
        N433, N434, N435, N436, N437, N438, N439, N440, N441, N442, N443, N444, 
        N445, N446, N447, N448, N449, N450, N451, N452, N453, N454, N455, N456, 
        N457, N458, N459, N460}), .DATA9({N54, N55, N56, N57, N58, N59, N60, 
        N61, N62, N63, N64, N65, N66, N67, N68, N69, N70, N71, N72, N73, N74, 
        N75, N76, N77, N78, N79, N80, N81, N82, N83, N84, N85}), .DATA10({N492, 
        N491, N490, N489, N488, N487, N486, N485, N484, N483, N482, N481, N480, 
        N479, N478, N477, N476, N475, N474, N473, N472, N471, N470, N469, N468, 
        N467, N466, N465, N464, N463, N462, N461}), .DATA11({N528, N527, N526, 
        N525, N524, N523, N522, N521, N520, N519, N518, N517, N516, N515, N514, 
        N513, N512, N511, N510, N509, N508, N507, N506, N505, N504, N503, N502, 
        N501, N500, N499, N498, N497}), .DATA12({N564, N563, N562, N561, N560, 
        N559, N558, N557, N556, N555, N554, N553, N552, N551, N550, N549, N548, 
        N547, N546, N545, N544, N543, N542, N541, N540, N539, N538, N537, N536, 
        N535, N534, N533}), .DATA13({N569, N570, N571, N572, N573, N574, N575, 
        N576, N577, N578, N579, N580, N581, N582, N583, N584, N585, N586, N587, 
        N588, N589, N590, N591, N592, N593, N594, N595, N596, N597, N598, N599, 
        N600}), .DATA14({N632, N631, N630, N629, N628, N627, N626, N625, N624, 
        N623, N622, N621, N620, N619, N618, N617, N616, N615, N614, N613, N612, 
        N611, N610, N609, N608, N607, N606, N605, N604, N603, N602, N601}), 
        .DATA15({N637, N638, N639, N640, N641, N642, N643, N644, N645, N646, 
        N647, N648, N649, N650, N651, N652, N653, N654, N655, N656, N657, N658, 
        N659, N660, N661, N662, N663, N664, N665, N666, N667, N668}), .DATA16(
        {N669, N670, N671, N672, N673, N674, N675, N676, N677, N678, N679, 
        N680, N681, N682, N683, N684, N685, N686, N687, N688, N689, N690, N691, 
        N692, N693, N694, N695, N696, N697, N698, N699, N700}), .CONTROL1(N5), 
        .CONTROL2(N18), .CONTROL3(N20), .CONTROL4(N23), .CONTROL5(N26), 
        .CONTROL6(N28), .CONTROL7(N30), .CONTROL8(N32), .CONTROL9(N36), 
        .CONTROL10(N38), .CONTROL11(N40), .CONTROL12(N42), .CONTROL13(N45), 
        .CONTROL14(N47), .CONTROL15(N50), .CONTROL16(N6), .Z(result) );
  GTECH_BUF B_0 ( .A(N14), .Z(N5) );
  GTECH_BUF B_1 ( .A(N53), .Z(N6) );
  SELECT_OP C890 ( .DATA1(1'b0), .DATA2(N282), .DATA3(N353), .DATA4(N493), 
        .DATA5(N529), .DATA6(N565), .DATA7(N633), .CONTROL1(N7), .CONTROL2(N28), .CONTROL3(N30), .CONTROL4(N38), .CONTROL5(N40), .CONTROL6(N42), .CONTROL7(
        N47), .Z(c_out) );
  GTECH_BUF B_2 ( .A(N895), .Z(N7) );
  SELECT_OP C891 ( .DATA1(N732), .DATA2(N764), .DATA3(N150), .DATA4(N183), 
        .DATA5(N216), .DATA6(N283), .DATA7(N354), .DATA8(N796), .DATA9(N732), 
        .DATA10(N494), .DATA11(N530), .DATA12(N566), .DATA13(N828), .DATA14(
        N634), .DATA15(N860), .DATA16(N892), .CONTROL1(N5), .CONTROL2(N18), 
        .CONTROL3(N20), .CONTROL4(N23), .CONTROL5(N26), .CONTROL6(N28), 
        .CONTROL7(N30), .CONTROL8(N32), .CONTROL9(N36), .CONTROL10(N38), 
        .CONTROL11(N40), .CONTROL12(N42), .CONTROL13(N45), .CONTROL14(N47), 
        .CONTROL15(N50), .CONTROL16(N6), .Z(z) );
  SELECT_OP C892 ( .DATA1(N54), .DATA2(N86), .DATA3(N149), .DATA4(N182), 
        .DATA5(N215), .DATA6(N281), .DATA7(N352), .DATA8(N429), .DATA9(N54), 
        .DATA10(N492), .DATA11(N528), .DATA12(N564), .DATA13(N569), .DATA14(
        N632), .DATA15(N637), .DATA16(N669), .CONTROL1(N5), .CONTROL2(N18), 
        .CONTROL3(N20), .CONTROL4(N23), .CONTROL5(N26), .CONTROL6(N28), 
        .CONTROL7(N30), .CONTROL8(N32), .CONTROL9(N36), .CONTROL10(N38), 
        .CONTROL11(N40), .CONTROL12(N42), .CONTROL13(N45), .CONTROL14(N47), 
        .CONTROL15(N50), .CONTROL16(N6), .Z(n) );
  SELECT_OP C893 ( .DATA1(1'b0), .DATA2(N286), .DATA3(N357), .DATA4(N496), 
        .DATA5(N532), .DATA6(N568), .DATA7(N636), .CONTROL1(N7), .CONTROL2(N28), .CONTROL3(N30), .CONTROL4(N38), .CONTROL5(N40), .CONTROL6(N42), .CONTROL7(
        N47), .Z(v) );
  GTECH_NOT I_13 ( .A(op[3]), .Z(N8) );
  GTECH_NOT I_14 ( .A(op[2]), .Z(N9) );
  GTECH_NOT I_15 ( .A(op[1]), .Z(N10) );
  GTECH_NOT I_16 ( .A(op[0]), .Z(N11) );
  GTECH_NOT I_17 ( .A(N17), .Z(N18) );
  GTECH_NOT I_18 ( .A(N19), .Z(N20) );
  GTECH_NOT I_19 ( .A(N22), .Z(N23) );
  GTECH_NOT I_20 ( .A(N25), .Z(N26) );
  GTECH_NOT I_21 ( .A(N27), .Z(N28) );
  GTECH_NOT I_22 ( .A(N29), .Z(N30) );
  GTECH_NOT I_23 ( .A(N31), .Z(N32) );
  GTECH_NOT I_24 ( .A(N35), .Z(N36) );
  GTECH_NOT I_25 ( .A(N37), .Z(N38) );
  GTECH_NOT I_26 ( .A(N39), .Z(N40) );
  GTECH_NOT I_27 ( .A(N41), .Z(N42) );
  GTECH_NOT I_28 ( .A(N44), .Z(N45) );
  GTECH_NOT I_29 ( .A(N46), .Z(N47) );
  GTECH_NOT I_30 ( .A(N49), .Z(N50) );
  GTECH_AND2 C930 ( .A(a[31]), .B(b[31]), .Z(N54) );
  GTECH_AND2 C931 ( .A(a[30]), .B(b[30]), .Z(N55) );
  GTECH_AND2 C932 ( .A(a[29]), .B(b[29]), .Z(N56) );
  GTECH_AND2 C933 ( .A(a[28]), .B(b[28]), .Z(N57) );
  GTECH_AND2 C934 ( .A(a[27]), .B(b[27]), .Z(N58) );
  GTECH_AND2 C935 ( .A(a[26]), .B(b[26]), .Z(N59) );
  GTECH_AND2 C936 ( .A(a[25]), .B(b[25]), .Z(N60) );
  GTECH_AND2 C937 ( .A(a[24]), .B(b[24]), .Z(N61) );
  GTECH_AND2 C938 ( .A(a[23]), .B(b[23]), .Z(N62) );
  GTECH_AND2 C939 ( .A(a[22]), .B(b[22]), .Z(N63) );
  GTECH_AND2 C940 ( .A(a[21]), .B(b[21]), .Z(N64) );
  GTECH_AND2 C941 ( .A(a[20]), .B(b[20]), .Z(N65) );
  GTECH_AND2 C942 ( .A(a[19]), .B(b[19]), .Z(N66) );
  GTECH_AND2 C943 ( .A(a[18]), .B(b[18]), .Z(N67) );
  GTECH_AND2 C944 ( .A(a[17]), .B(b[17]), .Z(N68) );
  GTECH_AND2 C945 ( .A(a[16]), .B(b[16]), .Z(N69) );
  GTECH_AND2 C946 ( .A(a[15]), .B(b[15]), .Z(N70) );
  GTECH_AND2 C947 ( .A(a[14]), .B(b[14]), .Z(N71) );
  GTECH_AND2 C948 ( .A(a[13]), .B(b[13]), .Z(N72) );
  GTECH_AND2 C949 ( .A(a[12]), .B(b[12]), .Z(N73) );
  GTECH_AND2 C950 ( .A(a[11]), .B(b[11]), .Z(N74) );
  GTECH_AND2 C951 ( .A(a[10]), .B(b[10]), .Z(N75) );
  GTECH_AND2 C952 ( .A(a[9]), .B(b[9]), .Z(N76) );
  GTECH_AND2 C953 ( .A(a[8]), .B(b[8]), .Z(N77) );
  GTECH_AND2 C954 ( .A(a[7]), .B(b[7]), .Z(N78) );
  GTECH_AND2 C955 ( .A(a[6]), .B(b[6]), .Z(N79) );
  GTECH_AND2 C956 ( .A(a[5]), .B(b[5]), .Z(N80) );
  GTECH_AND2 C957 ( .A(a[4]), .B(b[4]), .Z(N81) );
  GTECH_AND2 C958 ( .A(a[3]), .B(b[3]), .Z(N82) );
  GTECH_AND2 C959 ( .A(a[2]), .B(b[2]), .Z(N83) );
  GTECH_AND2 C960 ( .A(a[1]), .B(b[1]), .Z(N84) );
  GTECH_AND2 C961 ( .A(a[0]), .B(b[0]), .Z(N85) );
  GTECH_XOR2 C964 ( .A(a[31]), .B(b[31]), .Z(N86) );
  GTECH_XOR2 C965 ( .A(a[30]), .B(b[30]), .Z(N87) );
  GTECH_XOR2 C966 ( .A(a[29]), .B(b[29]), .Z(N88) );
  GTECH_XOR2 C967 ( .A(a[28]), .B(b[28]), .Z(N89) );
  GTECH_XOR2 C968 ( .A(a[27]), .B(b[27]), .Z(N90) );
  GTECH_XOR2 C969 ( .A(a[26]), .B(b[26]), .Z(N91) );
  GTECH_XOR2 C970 ( .A(a[25]), .B(b[25]), .Z(N92) );
  GTECH_XOR2 C971 ( .A(a[24]), .B(b[24]), .Z(N93) );
  GTECH_XOR2 C972 ( .A(a[23]), .B(b[23]), .Z(N94) );
  GTECH_XOR2 C973 ( .A(a[22]), .B(b[22]), .Z(N95) );
  GTECH_XOR2 C974 ( .A(a[21]), .B(b[21]), .Z(N96) );
  GTECH_XOR2 C975 ( .A(a[20]), .B(b[20]), .Z(N97) );
  GTECH_XOR2 C976 ( .A(a[19]), .B(b[19]), .Z(N98) );
  GTECH_XOR2 C977 ( .A(a[18]), .B(b[18]), .Z(N99) );
  GTECH_XOR2 C978 ( .A(a[17]), .B(b[17]), .Z(N100) );
  GTECH_XOR2 C979 ( .A(a[16]), .B(b[16]), .Z(N101) );
  GTECH_XOR2 C980 ( .A(a[15]), .B(b[15]), .Z(N102) );
  GTECH_XOR2 C981 ( .A(a[14]), .B(b[14]), .Z(N103) );
  GTECH_XOR2 C982 ( .A(a[13]), .B(b[13]), .Z(N104) );
  GTECH_XOR2 C983 ( .A(a[12]), .B(b[12]), .Z(N105) );
  GTECH_XOR2 C984 ( .A(a[11]), .B(b[11]), .Z(N106) );
  GTECH_XOR2 C985 ( .A(a[10]), .B(b[10]), .Z(N107) );
  GTECH_XOR2 C986 ( .A(a[9]), .B(b[9]), .Z(N108) );
  GTECH_XOR2 C987 ( .A(a[8]), .B(b[8]), .Z(N109) );
  GTECH_XOR2 C988 ( .A(a[7]), .B(b[7]), .Z(N110) );
  GTECH_XOR2 C989 ( .A(a[6]), .B(b[6]), .Z(N111) );
  GTECH_XOR2 C990 ( .A(a[5]), .B(b[5]), .Z(N112) );
  GTECH_XOR2 C991 ( .A(a[4]), .B(b[4]), .Z(N113) );
  GTECH_XOR2 C992 ( .A(a[3]), .B(b[3]), .Z(N114) );
  GTECH_XOR2 C993 ( .A(a[2]), .B(b[2]), .Z(N115) );
  GTECH_XOR2 C994 ( .A(a[1]), .B(b[1]), .Z(N116) );
  GTECH_XOR2 C995 ( .A(a[0]), .B(b[0]), .Z(N117) );
  GTECH_BUF B_3 ( .A(N20) );
  GTECH_BUF B_4 ( .A(N23) );
  GTECH_BUF B_5 ( .A(N26) );
  GTECH_BUF B_6 ( .A(N28) );
  GTECH_AND2 C1010 ( .A(N284), .B(N285), .Z(N286) );
  GTECH_BUF B_7 ( .A(N30) );
  GTECH_NOT I_31 ( .A(c_in), .Z(N287) );
  GTECH_AND2 C1017 ( .A(N355), .B(N356), .Z(N357) );
  GTECH_BUF B_8 ( .A(N32) );
  GTECH_OR2 C1020 ( .A(N389), .B(N428), .Z(N429) );
  GTECH_OR2 C1021 ( .A(N388), .B(N427), .Z(N430) );
  GTECH_OR2 C1022 ( .A(N387), .B(N426), .Z(N431) );
  GTECH_OR2 C1023 ( .A(N386), .B(N425), .Z(N432) );
  GTECH_OR2 C1024 ( .A(N385), .B(N424), .Z(N433) );
  GTECH_OR2 C1025 ( .A(N384), .B(N423), .Z(N434) );
  GTECH_OR2 C1026 ( .A(N383), .B(N422), .Z(N435) );
  GTECH_OR2 C1027 ( .A(N382), .B(N421), .Z(N436) );
  GTECH_OR2 C1028 ( .A(N381), .B(N420), .Z(N437) );
  GTECH_OR2 C1029 ( .A(N380), .B(N419), .Z(N438) );
  GTECH_OR2 C1030 ( .A(N379), .B(N418), .Z(N439) );
  GTECH_OR2 C1031 ( .A(N378), .B(N417), .Z(N440) );
  GTECH_OR2 C1032 ( .A(N377), .B(N416), .Z(N441) );
  GTECH_OR2 C1033 ( .A(N376), .B(N415), .Z(N442) );
  GTECH_OR2 C1034 ( .A(N375), .B(N414), .Z(N443) );
  GTECH_OR2 C1035 ( .A(N374), .B(N413), .Z(N444) );
  GTECH_OR2 C1036 ( .A(N373), .B(N412), .Z(N445) );
  GTECH_OR2 C1037 ( .A(N372), .B(N411), .Z(N446) );
  GTECH_OR2 C1038 ( .A(N371), .B(N410), .Z(N447) );
  GTECH_OR2 C1039 ( .A(N370), .B(N409), .Z(N448) );
  GTECH_OR2 C1040 ( .A(N369), .B(N408), .Z(N449) );
  GTECH_OR2 C1041 ( .A(N368), .B(N407), .Z(N450) );
  GTECH_OR2 C1042 ( .A(N367), .B(N406), .Z(N451) );
  GTECH_OR2 C1043 ( .A(N366), .B(N405), .Z(N452) );
  GTECH_OR2 C1044 ( .A(N365), .B(N404), .Z(N453) );
  GTECH_OR2 C1045 ( .A(N364), .B(N403), .Z(N454) );
  GTECH_OR2 C1046 ( .A(N363), .B(N402), .Z(N455) );
  GTECH_OR2 C1047 ( .A(N362), .B(N401), .Z(N456) );
  GTECH_OR2 C1048 ( .A(N361), .B(N400), .Z(N457) );
  GTECH_OR2 C1049 ( .A(N360), .B(N399), .Z(N458) );
  GTECH_OR2 C1050 ( .A(N359), .B(N398), .Z(N459) );
  GTECH_OR2 C1051 ( .A(N358), .B(N397), .Z(N460) );
  GTECH_BUF B_9 ( .A(N38) );
  GTECH_BUF B_10 ( .A(N40) );
  GTECH_AND2 C1061 ( .A(N355), .B(N531), .Z(N532) );
  GTECH_BUF B_11 ( .A(N42) );
  GTECH_AND2 C1066 ( .A(N284), .B(N567), .Z(N568) );
  GTECH_OR2 C1068 ( .A(a[31]), .B(b[31]), .Z(N569) );
  GTECH_OR2 C1069 ( .A(a[30]), .B(b[30]), .Z(N570) );
  GTECH_OR2 C1070 ( .A(a[29]), .B(b[29]), .Z(N571) );
  GTECH_OR2 C1071 ( .A(a[28]), .B(b[28]), .Z(N572) );
  GTECH_OR2 C1072 ( .A(a[27]), .B(b[27]), .Z(N573) );
  GTECH_OR2 C1073 ( .A(a[26]), .B(b[26]), .Z(N574) );
  GTECH_OR2 C1074 ( .A(a[25]), .B(b[25]), .Z(N575) );
  GTECH_OR2 C1075 ( .A(a[24]), .B(b[24]), .Z(N576) );
  GTECH_OR2 C1076 ( .A(a[23]), .B(b[23]), .Z(N577) );
  GTECH_OR2 C1077 ( .A(a[22]), .B(b[22]), .Z(N578) );
  GTECH_OR2 C1078 ( .A(a[21]), .B(b[21]), .Z(N579) );
  GTECH_OR2 C1079 ( .A(a[20]), .B(b[20]), .Z(N580) );
  GTECH_OR2 C1080 ( .A(a[19]), .B(b[19]), .Z(N581) );
  GTECH_OR2 C1081 ( .A(a[18]), .B(b[18]), .Z(N582) );
  GTECH_OR2 C1082 ( .A(a[17]), .B(b[17]), .Z(N583) );
  GTECH_OR2 C1083 ( .A(a[16]), .B(b[16]), .Z(N584) );
  GTECH_OR2 C1084 ( .A(a[15]), .B(b[15]), .Z(N585) );
  GTECH_OR2 C1085 ( .A(a[14]), .B(b[14]), .Z(N586) );
  GTECH_OR2 C1086 ( .A(a[13]), .B(b[13]), .Z(N587) );
  GTECH_OR2 C1087 ( .A(a[12]), .B(b[12]), .Z(N588) );
  GTECH_OR2 C1088 ( .A(a[11]), .B(b[11]), .Z(N589) );
  GTECH_OR2 C1089 ( .A(a[10]), .B(b[10]), .Z(N590) );
  GTECH_OR2 C1090 ( .A(a[9]), .B(b[9]), .Z(N591) );
  GTECH_OR2 C1091 ( .A(a[8]), .B(b[8]), .Z(N592) );
  GTECH_OR2 C1092 ( .A(a[7]), .B(b[7]), .Z(N593) );
  GTECH_OR2 C1093 ( .A(a[6]), .B(b[6]), .Z(N594) );
  GTECH_OR2 C1094 ( .A(a[5]), .B(b[5]), .Z(N595) );
  GTECH_OR2 C1095 ( .A(a[4]), .B(b[4]), .Z(N596) );
  GTECH_OR2 C1096 ( .A(a[3]), .B(b[3]), .Z(N597) );
  GTECH_OR2 C1097 ( .A(a[2]), .B(b[2]), .Z(N598) );
  GTECH_OR2 C1098 ( .A(a[1]), .B(b[1]), .Z(N599) );
  GTECH_OR2 C1099 ( .A(a[0]), .B(b[0]), .Z(N600) );
  GTECH_BUF B_12 ( .A(N47) );
  GTECH_AND2 C1106 ( .A(a[31]), .B(N896), .Z(N637) );
  GTECH_NOT I_32 ( .A(b[31]), .Z(N896) );
  GTECH_AND2 C1108 ( .A(a[30]), .B(N897), .Z(N638) );
  GTECH_NOT I_33 ( .A(b[30]), .Z(N897) );
  GTECH_AND2 C1110 ( .A(a[29]), .B(N898), .Z(N639) );
  GTECH_NOT I_34 ( .A(b[29]), .Z(N898) );
  GTECH_AND2 C1112 ( .A(a[28]), .B(N899), .Z(N640) );
  GTECH_NOT I_35 ( .A(b[28]), .Z(N899) );
  GTECH_AND2 C1114 ( .A(a[27]), .B(N900), .Z(N641) );
  GTECH_NOT I_36 ( .A(b[27]), .Z(N900) );
  GTECH_AND2 C1116 ( .A(a[26]), .B(N901), .Z(N642) );
  GTECH_NOT I_37 ( .A(b[26]), .Z(N901) );
  GTECH_AND2 C1118 ( .A(a[25]), .B(N902), .Z(N643) );
  GTECH_NOT I_38 ( .A(b[25]), .Z(N902) );
  GTECH_AND2 C1120 ( .A(a[24]), .B(N903), .Z(N644) );
  GTECH_NOT I_39 ( .A(b[24]), .Z(N903) );
  GTECH_AND2 C1122 ( .A(a[23]), .B(N904), .Z(N645) );
  GTECH_NOT I_40 ( .A(b[23]), .Z(N904) );
  GTECH_AND2 C1124 ( .A(a[22]), .B(N905), .Z(N646) );
  GTECH_NOT I_41 ( .A(b[22]), .Z(N905) );
  GTECH_AND2 C1126 ( .A(a[21]), .B(N906), .Z(N647) );
  GTECH_NOT I_42 ( .A(b[21]), .Z(N906) );
  GTECH_AND2 C1128 ( .A(a[20]), .B(N907), .Z(N648) );
  GTECH_NOT I_43 ( .A(b[20]), .Z(N907) );
  GTECH_AND2 C1130 ( .A(a[19]), .B(N908), .Z(N649) );
  GTECH_NOT I_44 ( .A(b[19]), .Z(N908) );
  GTECH_AND2 C1132 ( .A(a[18]), .B(N909), .Z(N650) );
  GTECH_NOT I_45 ( .A(b[18]), .Z(N909) );
  GTECH_AND2 C1134 ( .A(a[17]), .B(N910), .Z(N651) );
  GTECH_NOT I_46 ( .A(b[17]), .Z(N910) );
  GTECH_AND2 C1136 ( .A(a[16]), .B(N911), .Z(N652) );
  GTECH_NOT I_47 ( .A(b[16]), .Z(N911) );
  GTECH_AND2 C1138 ( .A(a[15]), .B(N912), .Z(N653) );
  GTECH_NOT I_48 ( .A(b[15]), .Z(N912) );
  GTECH_AND2 C1140 ( .A(a[14]), .B(N913), .Z(N654) );
  GTECH_NOT I_49 ( .A(b[14]), .Z(N913) );
  GTECH_AND2 C1142 ( .A(a[13]), .B(N914), .Z(N655) );
  GTECH_NOT I_50 ( .A(b[13]), .Z(N914) );
  GTECH_AND2 C1144 ( .A(a[12]), .B(N915), .Z(N656) );
  GTECH_NOT I_51 ( .A(b[12]), .Z(N915) );
  GTECH_AND2 C1146 ( .A(a[11]), .B(N916), .Z(N657) );
  GTECH_NOT I_52 ( .A(b[11]), .Z(N916) );
  GTECH_AND2 C1148 ( .A(a[10]), .B(N917), .Z(N658) );
  GTECH_NOT I_53 ( .A(b[10]), .Z(N917) );
  GTECH_AND2 C1150 ( .A(a[9]), .B(N918), .Z(N659) );
  GTECH_NOT I_54 ( .A(b[9]), .Z(N918) );
  GTECH_AND2 C1152 ( .A(a[8]), .B(N919), .Z(N660) );
  GTECH_NOT I_55 ( .A(b[8]), .Z(N919) );
  GTECH_AND2 C1154 ( .A(a[7]), .B(N920), .Z(N661) );
  GTECH_NOT I_56 ( .A(b[7]), .Z(N920) );
  GTECH_AND2 C1156 ( .A(a[6]), .B(N921), .Z(N662) );
  GTECH_NOT I_57 ( .A(b[6]), .Z(N921) );
  GTECH_AND2 C1158 ( .A(a[5]), .B(N922), .Z(N663) );
  GTECH_NOT I_58 ( .A(b[5]), .Z(N922) );
  GTECH_AND2 C1160 ( .A(a[4]), .B(N923), .Z(N664) );
  GTECH_NOT I_59 ( .A(b[4]), .Z(N923) );
  GTECH_AND2 C1162 ( .A(a[3]), .B(N924), .Z(N665) );
  GTECH_NOT I_60 ( .A(b[3]), .Z(N924) );
  GTECH_AND2 C1164 ( .A(a[2]), .B(N925), .Z(N666) );
  GTECH_NOT I_61 ( .A(b[2]), .Z(N925) );
  GTECH_AND2 C1166 ( .A(a[1]), .B(N926), .Z(N667) );
  GTECH_NOT I_62 ( .A(b[1]), .Z(N926) );
  GTECH_AND2 C1168 ( .A(a[0]), .B(N927), .Z(N668) );
  GTECH_NOT I_63 ( .A(b[0]), .Z(N927) );
  GTECH_NOT I_64 ( .A(a[31]), .Z(N669) );
  GTECH_NOT I_65 ( .A(a[30]), .Z(N670) );
  GTECH_NOT I_66 ( .A(a[29]), .Z(N671) );
  GTECH_NOT I_67 ( .A(a[28]), .Z(N672) );
  GTECH_NOT I_68 ( .A(a[27]), .Z(N673) );
  GTECH_NOT I_69 ( .A(a[26]), .Z(N674) );
  GTECH_NOT I_70 ( .A(a[25]), .Z(N675) );
  GTECH_NOT I_71 ( .A(a[24]), .Z(N676) );
  GTECH_NOT I_72 ( .A(a[23]), .Z(N677) );
  GTECH_NOT I_73 ( .A(a[22]), .Z(N678) );
  GTECH_NOT I_74 ( .A(a[21]), .Z(N679) );
  GTECH_NOT I_75 ( .A(a[20]), .Z(N680) );
  GTECH_NOT I_76 ( .A(a[19]), .Z(N681) );
  GTECH_NOT I_77 ( .A(a[18]), .Z(N682) );
  GTECH_NOT I_78 ( .A(a[17]), .Z(N683) );
  GTECH_NOT I_79 ( .A(a[16]), .Z(N684) );
  GTECH_NOT I_80 ( .A(a[15]), .Z(N685) );
  GTECH_NOT I_81 ( .A(a[14]), .Z(N686) );
  GTECH_NOT I_82 ( .A(a[13]), .Z(N687) );
  GTECH_NOT I_83 ( .A(a[12]), .Z(N688) );
  GTECH_NOT I_84 ( .A(a[11]), .Z(N689) );
  GTECH_NOT I_85 ( .A(a[10]), .Z(N690) );
  GTECH_NOT I_86 ( .A(a[9]), .Z(N691) );
  GTECH_NOT I_87 ( .A(a[8]), .Z(N692) );
  GTECH_NOT I_88 ( .A(a[7]), .Z(N693) );
  GTECH_NOT I_89 ( .A(a[6]), .Z(N694) );
  GTECH_NOT I_90 ( .A(a[5]), .Z(N695) );
  GTECH_NOT I_91 ( .A(a[4]), .Z(N696) );
  GTECH_NOT I_92 ( .A(a[3]), .Z(N697) );
  GTECH_NOT I_93 ( .A(a[2]), .Z(N698) );
  GTECH_NOT I_94 ( .A(a[1]), .Z(N699) );
  GTECH_NOT I_95 ( .A(a[0]), .Z(N700) );
endmodule


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
  wire   N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15, N16,
         N17, N18, N19, N20, N21, N22, N23, N24, N25, N26, N27, N28, N29, N30,
         N31, N32, N33, N34, N35, N36, N37, N38, N39, N40, N41, N42, N43, N44,
         N45, N46, N47, N48, N49, N50, N51, N52, N53, N54, N55, N56, N57, N58,
         N59, N60, N61, N62, N63, N64, N65, N66, N67, N68, N69, N70, N71, N72,
         N73, N74, N75, N76, N77, N78, N79, N80, N81, N82, N83, N84, N85, N86,
         N87, N88, N89, N90, N91, N92, N93, N94, N95, N96, N97, N98, N99, N100,
         N101, N102, N103, N104, N105, N106, N107, N108, N109, N110, N111,
         N112, N113, N114, N115, N116, N117, N118, N119, N120, N121, N122,
         N123, N124, N125, N126, N127, N128, N129, N130, N131, N132, N133,
         N134, N135, N136, N137, N138, N139, N140, N141, N142, N143, N144,
         N145, N146, N147, N148, N149, N150, N151, N152, N153, N154, N155,
         N156, N157, N158, N159, N160, N161, N162, N163, N164, N165, N166,
         N167, N168, N169, N170, N171, N172, N173, N174, N175, N176, N177,
         N178, N179, N180, N181, N182, N183, N184, N185, N186, N187, N188,
         N189, N190, N191, N192, N193, N194, N195, N196, N197, N198, N199;
  wire   [3:0] state;
  wire   [3:0] nextstate;

  \**SEQGEN**  state_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(N35), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(state[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  state_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(N34), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(state[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  state_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(N33), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(state[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  state_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(N32), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(state[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  GTECH_AND2 C17 ( .A(N36), .B(N37), .Z(N40) );
  GTECH_AND2 C18 ( .A(N38), .B(N39), .Z(N41) );
  GTECH_AND2 C19 ( .A(N40), .B(N41), .Z(N42) );
  GTECH_OR2 C21 ( .A(state[3]), .B(state[2]), .Z(N43) );
  GTECH_OR2 C22 ( .A(state[1]), .B(N39), .Z(N44) );
  GTECH_OR2 C23 ( .A(N43), .B(N44), .Z(N45) );
  GTECH_OR2 C26 ( .A(state[3]), .B(state[2]), .Z(N47) );
  GTECH_OR2 C27 ( .A(N38), .B(state[0]), .Z(N48) );
  GTECH_OR2 C28 ( .A(N47), .B(N48), .Z(N49) );
  GTECH_OR2 C32 ( .A(state[3]), .B(state[2]), .Z(N51) );
  GTECH_OR2 C33 ( .A(N38), .B(N39), .Z(N52) );
  GTECH_OR2 C34 ( .A(N51), .B(N52), .Z(N53) );
  GTECH_OR2 C37 ( .A(state[3]), .B(N37), .Z(N55) );
  GTECH_OR2 C38 ( .A(state[1]), .B(state[0]), .Z(N56) );
  GTECH_OR2 C39 ( .A(N55), .B(N56), .Z(N57) );
  GTECH_AND2 C41 ( .A(state[3]), .B(state[2]), .Z(N59) );
  GTECH_AND2 C42 ( .A(state[1]), .B(state[0]), .Z(N60) );
  GTECH_AND2 C43 ( .A(N59), .B(N60), .Z(N61) );
  GTECH_OR2 C47 ( .A(N36), .B(N37), .Z(N62) );
  GTECH_OR2 C48 ( .A(state[1]), .B(N39), .Z(N63) );
  GTECH_OR2 C49 ( .A(N62), .B(N63), .Z(N64) );
  GTECH_OR2 C53 ( .A(N36), .B(N37), .Z(N66) );
  GTECH_OR2 C54 ( .A(state[1]), .B(state[0]), .Z(N67) );
  GTECH_OR2 C55 ( .A(N66), .B(N67), .Z(N68) );
  GTECH_OR2 C60 ( .A(N36), .B(state[2]), .Z(N70) );
  GTECH_OR2 C61 ( .A(N38), .B(N39), .Z(N71) );
  GTECH_OR2 C62 ( .A(N70), .B(N71), .Z(N72) );
  GTECH_OR2 C66 ( .A(N36), .B(state[2]), .Z(N74) );
  GTECH_OR2 C67 ( .A(N38), .B(state[0]), .Z(N75) );
  GTECH_OR2 C68 ( .A(N74), .B(N75), .Z(N76) );
  GTECH_AND2 C71 ( .A(N36), .B(state[2]), .Z(N78) );
  GTECH_AND2 C72 ( .A(N78), .B(state[0]), .Z(N79) );
  GTECH_AND2 C74 ( .A(state[2]), .B(state[1]), .Z(N80) );
  GTECH_AND2 C75 ( .A(N80), .B(N39), .Z(N81) );
  GTECH_AND2 C78 ( .A(state[3]), .B(N37), .Z(N82) );
  GTECH_AND2 C79 ( .A(N82), .B(N38), .Z(N83) );
  GTECH_OR2 C100 ( .A(N91), .B(word_type[0]), .Z(N87) );
  GTECH_OR2 C103 ( .A(word_type[1]), .B(N92), .Z(N89) );
  GTECH_AND2 C107 ( .A(N91), .B(N92), .Z(N93) );
  GTECH_AND2 C169 ( .A(N104), .B(N105), .Z(N108) );
  GTECH_AND2 C170 ( .A(N106), .B(N107), .Z(N109) );
  GTECH_AND2 C171 ( .A(N108), .B(N109), .Z(N110) );
  GTECH_OR2 C173 ( .A(state[3]), .B(state[2]), .Z(N111) );
  GTECH_OR2 C174 ( .A(state[1]), .B(N107), .Z(N112) );
  GTECH_OR2 C175 ( .A(N111), .B(N112), .Z(N113) );
  GTECH_OR2 C178 ( .A(state[3]), .B(state[2]), .Z(N115) );
  GTECH_OR2 C179 ( .A(N106), .B(state[0]), .Z(N116) );
  GTECH_OR2 C180 ( .A(N115), .B(N116), .Z(N117) );
  GTECH_OR2 C184 ( .A(state[3]), .B(state[2]), .Z(N119) );
  GTECH_OR2 C185 ( .A(N106), .B(N107), .Z(N120) );
  GTECH_OR2 C186 ( .A(N119), .B(N120), .Z(N121) );
  GTECH_OR2 C189 ( .A(state[3]), .B(N105), .Z(N123) );
  GTECH_OR2 C190 ( .A(state[1]), .B(state[0]), .Z(N124) );
  GTECH_OR2 C191 ( .A(N123), .B(N124), .Z(N125) );
  GTECH_AND2 C193 ( .A(state[3]), .B(state[2]), .Z(N127) );
  GTECH_AND2 C194 ( .A(state[1]), .B(state[0]), .Z(N128) );
  GTECH_AND2 C195 ( .A(N127), .B(N128), .Z(N129) );
  GTECH_OR2 C199 ( .A(N104), .B(N105), .Z(N130) );
  GTECH_OR2 C200 ( .A(state[1]), .B(N107), .Z(N131) );
  GTECH_OR2 C201 ( .A(N130), .B(N131), .Z(N132) );
  GTECH_OR2 C205 ( .A(N104), .B(N105), .Z(N134) );
  GTECH_OR2 C206 ( .A(state[1]), .B(state[0]), .Z(N135) );
  GTECH_OR2 C207 ( .A(N134), .B(N135), .Z(N136) );
  GTECH_OR2 C212 ( .A(N104), .B(state[2]), .Z(N138) );
  GTECH_OR2 C213 ( .A(N106), .B(N107), .Z(N139) );
  GTECH_OR2 C214 ( .A(N138), .B(N139), .Z(N140) );
  GTECH_OR2 C218 ( .A(N104), .B(state[2]), .Z(N142) );
  GTECH_OR2 C219 ( .A(N106), .B(state[0]), .Z(N143) );
  GTECH_OR2 C220 ( .A(N142), .B(N143), .Z(N144) );
  GTECH_AND2 C223 ( .A(N104), .B(state[2]), .Z(N146) );
  GTECH_AND2 C224 ( .A(N146), .B(state[0]), .Z(N147) );
  GTECH_AND2 C226 ( .A(state[2]), .B(state[1]), .Z(N148) );
  GTECH_AND2 C227 ( .A(N148), .B(N107), .Z(N149) );
  GTECH_AND2 C230 ( .A(state[3]), .B(N105), .Z(N150) );
  GTECH_AND2 C231 ( .A(N150), .B(N106), .Z(N151) );
  GTECH_OR2 C293 ( .A(N88), .B(N90), .Z(N94) );
  GTECH_OR2 C296 ( .A(N88), .B(N93), .Z(N95) );
  GTECH_OR3 C299 ( .A(N88), .B(N90), .C(N93), .Z(N96) );
  GTECH_OR2 C302 ( .A(N90), .B(N93), .Z(N97) );
  GTECH_OR2 C309 ( .A(load), .B(N86), .Z(N154) );
  GTECH_OR5 C314 ( .A(N110), .B(N122), .C(N129), .D(N133), .E(N137), .Z(N155)
         );
  GTECH_OR2 C315 ( .A(N141), .B(N145), .Z(N156) );
  GTECH_OR2 C316 ( .A(N155), .B(N156), .Z(N157) );
  GTECH_OR3 C317 ( .A(N114), .B(N118), .C(N126), .Z(N158) );
  GTECH_OR5 C320 ( .A(N110), .B(N114), .C(N118), .D(N122), .E(N126), .Z(N159)
         );
  GTECH_OR4 C321 ( .A(N129), .B(N137), .C(N141), .D(N145), .Z(N160) );
  GTECH_OR2 C322 ( .A(N159), .B(N160), .Z(N161) );
  GTECH_OR5 C325 ( .A(N114), .B(N118), .C(N122), .D(N126), .E(N129), .Z(N162)
         );
  GTECH_OR4 C326 ( .A(N133), .B(N137), .C(N141), .D(N145), .Z(N163) );
  GTECH_OR2 C327 ( .A(N162), .B(N163), .Z(N164) );
  GTECH_OR2 C331 ( .A(N133), .B(N141), .Z(N165) );
  GTECH_OR2 C332 ( .A(N159), .B(N165), .Z(N166) );
  GTECH_OR3 C333 ( .A(N129), .B(N137), .C(N145), .Z(N167) );
  GTECH_OR4 C337 ( .A(N129), .B(N133), .C(N137), .D(N145), .Z(N168) );
  GTECH_OR2 C338 ( .A(N159), .B(N168), .Z(N169) );
  GTECH_OR5 C341 ( .A(N110), .B(N114), .C(N118), .D(N126), .E(N129), .Z(N170)
         );
  GTECH_OR2 C342 ( .A(N137), .B(N145), .Z(N171) );
  GTECH_OR2 C343 ( .A(N170), .B(N171), .Z(N172) );
  GTECH_OR3 C344 ( .A(N122), .B(N133), .C(N141), .Z(N173) );
  GTECH_OR5 C357 ( .A(N110), .B(N122), .C(N126), .D(N129), .E(N133), .Z(N174)
         );
  GTECH_OR3 C358 ( .A(N137), .B(N141), .C(N145), .Z(N175) );
  GTECH_OR2 C359 ( .A(N174), .B(N175), .Z(N176) );
  GTECH_OR2 C365 ( .A(N114), .B(N126), .Z(N177) );
  GTECH_OR5 C368 ( .A(N110), .B(N114), .C(N122), .D(N126), .E(N129), .Z(N178)
         );
  GTECH_OR2 C370 ( .A(N178), .B(N163), .Z(N179) );
  GTECH_OR5 C372 ( .A(N110), .B(N114), .C(N118), .D(N122), .E(N129), .Z(N180)
         );
  GTECH_OR5 C373 ( .A(N133), .B(N137), .C(N141), .D(N145), .E(N152), .Z(N181)
         );
  GTECH_OR2 C374 ( .A(N180), .B(N181), .Z(N182) );
  GTECH_OR5 C378 ( .A(N129), .B(N133), .C(N137), .D(N141), .E(N145), .Z(N183)
         );
  GTECH_OR3 C381 ( .A(N110), .B(N133), .C(N141), .Z(N184) );
  GTECH_OR2 C384 ( .A(N162), .B(N171), .Z(N185) );
  GTECH_BUF B_0 ( .A(1'b1), .Z(mem_enable) );
  GTECH_OR5 C402 ( .A(N46), .B(N50), .C(N54), .D(N58), .E(N61), .Z(N186) );
  GTECH_OR5 C403 ( .A(N65), .B(N69), .C(N73), .D(N77), .E(N84), .Z(N187) );
  GTECH_OR2 C404 ( .A(N186), .B(N187), .Z(N188) );
  GTECH_OR4 C407 ( .A(N65), .B(N69), .C(N77), .D(N84), .Z(N189) );
  GTECH_OR2 C408 ( .A(N186), .B(N189), .Z(N190) );
  GTECH_OR5 C410 ( .A(N46), .B(N50), .C(N58), .D(N61), .E(N69), .Z(N191) );
  GTECH_OR3 C411 ( .A(N73), .B(N77), .C(N84), .Z(N192) );
  GTECH_OR2 C412 ( .A(N191), .B(N192), .Z(N193) );
  GTECH_OR2 C413 ( .A(N54), .B(N65), .Z(N194) );
  GTECH_OR3 C416 ( .A(N69), .B(N77), .C(N84), .Z(N195) );
  GTECH_OR2 C417 ( .A(N186), .B(N195), .Z(N196) );
  GTECH_OR2 C418 ( .A(N65), .B(N73), .Z(N197) );
  SELECT_OP C420 ( .DATA1(nextstate), .DATA2({1'b0, 1'b0, 1'b0, 1'b0}), 
        .CONTROL1(N1), .CONTROL2(N2), .Z({N35, N34, N33, N32}) );
  GTECH_BUF B_1 ( .A(N31), .Z(N1) );
  GTECH_BUF B_2 ( .A(reset), .Z(N2) );
  SELECT_OP C421 ( .DATA1({N95, N94}), .DATA2({N97, N96}), .DATA3({1'b0, 1'b0}), .CONTROL1(N3), .CONTROL2(N103), .CONTROL3(N86), .Z({N99, N98}) );
  GTECH_BUF B_3 ( .A(load), .Z(N3) );
  SELECT_OP C422 ( .DATA1({1'b0, 1'b0}), .DATA2({N96, N94}), .CONTROL1(N4), 
        .CONTROL2(N103), .Z({N101, N100}) );
  GTECH_BUF B_4 ( .A(N154), .Z(N4) );
  SELECT_OP C423 ( .DATA1(N98), .DATA2(1'b0), .CONTROL1(N5), .CONTROL2(N6), 
        .Z(nextstate[0]) );
  GTECH_BUF B_5 ( .A(N42), .Z(N5) );
  GTECH_BUF B_6 ( .A(N188), .Z(N6) );
  SELECT_OP C424 ( .DATA1(N99), .DATA2(1'b0), .DATA3(1'b1), .CONTROL1(N5), 
        .CONTROL2(N7), .CONTROL3(N8), .Z(nextstate[1]) );
  GTECH_BUF B_7 ( .A(N190), .Z(N7) );
  GTECH_BUF B_8 ( .A(N73), .Z(N8) );
  SELECT_OP C425 ( .DATA1(N100), .DATA2(1'b0), .DATA3(1'b1), .CONTROL1(N5), 
        .CONTROL2(N9), .CONTROL3(N10), .Z(nextstate[2]) );
  GTECH_BUF B_9 ( .A(N193), .Z(N9) );
  GTECH_BUF B_10 ( .A(N194), .Z(N10) );
  SELECT_OP C426 ( .DATA1(N101), .DATA2(1'b0), .DATA3(1'b1), .CONTROL1(N5), 
        .CONTROL2(N11), .CONTROL3(N12), .Z(nextstate[3]) );
  GTECH_BUF B_11 ( .A(N196), .Z(N11) );
  GTECH_BUF B_12 ( .A(N197), .Z(N12) );
  SELECT_OP C427 ( .DATA1(1'b0), .DATA2(1'b1), .CONTROL1(N13), .CONTROL2(N14), 
        .Z(output_valid) );
  GTECH_BUF B_13 ( .A(N157), .Z(N13) );
  GTECH_BUF B_14 ( .A(N158), .Z(N14) );
  SELECT_OP C428 ( .DATA1(1'b1), .DATA2(1'b0), .CONTROL1(N15), .CONTROL2(N133), 
        .Z(direct_or_delayed_din[0]) );
  GTECH_BUF B_15 ( .A(N161), .Z(N15) );
  SELECT_OP C429 ( .DATA1(1'b0), .DATA2(1'b1), .CONTROL1(N16), .CONTROL2(N17), 
        .Z(direct_or_delayed_din[1]) );
  GTECH_BUF B_16 ( .A(N110), .Z(N16) );
  GTECH_BUF B_17 ( .A(N164), .Z(N17) );
  SELECT_OP C430 ( .DATA1(1'b0), .DATA2(1'b1), .CONTROL1(N18), .CONTROL2(N19), 
        .Z(write_ready) );
  GTECH_BUF B_18 ( .A(N166), .Z(N18) );
  GTECH_BUF B_19 ( .A(N167), .Z(N19) );
  SELECT_OP C431 ( .DATA1(1'b1), .DATA2(1'b0), .CONTROL1(N20), .CONTROL2(N141), 
        .Z(old_or_new_byte_remainder) );
  GTECH_BUF B_20 ( .A(N169), .Z(N20) );
  SELECT_OP C432 ( .DATA1(1'b1), .DATA2(1'b0), .CONTROL1(N21), .CONTROL2(N22), 
        .Z(modified_or_original_address) );
  GTECH_BUF B_21 ( .A(N172), .Z(N21) );
  GTECH_BUF B_22 ( .A(N173), .Z(N22) );
  SELECT_OP C433 ( .DATA1(1'b1), .DATA2(1'b0), .CONTROL1(N20), .CONTROL2(N141), 
        .Z(added_or_delayed_address) );
  SELECT_OP C434 ( .DATA1(1'b1), .DATA2(is_signed_fsm), .DATA3(is_signed_fsm), 
        .DATA4(1'b0), .CONTROL1(N13), .CONTROL2(N114), .CONTROL3(N118), 
        .CONTROL4(N126), .Z(first_two_bytes_out_select[0]) );
  SELECT_OP C435 ( .DATA1(1'b1), .DATA2(1'b0), .DATA3(is_signed_fsm), 
        .CONTROL1(N23), .CONTROL2(N114), .CONTROL3(N118), .Z(
        first_two_bytes_out_select[1]) );
  GTECH_BUF B_23 ( .A(N176), .Z(N23) );
  SELECT_OP C436 ( .DATA1(1'b1), .DATA2(1'b0), .DATA3(N153), .CONTROL1(N13), 
        .CONTROL2(N24), .CONTROL3(N118), .Z(third_byte_out_select[0]) );
  GTECH_BUF B_24 ( .A(N177), .Z(N24) );
  SELECT_OP C437 ( .DATA1(1'b1), .DATA2(1'b0), .CONTROL1(N25), .CONTROL2(N118), 
        .Z(third_byte_out_select[1]) );
  GTECH_BUF B_25 ( .A(N179), .Z(N25) );
  SELECT_OP C438 ( .DATA1(1'b0), .DATA2(1'b1), .CONTROL1(N26), .CONTROL2(N126), 
        .Z(output_shuffle) );
  GTECH_BUF B_26 ( .A(N182), .Z(N26) );
  SELECT_OP C439 ( .DATA1(1'b1), .DATA2(1'b0), .CONTROL1(N27), .CONTROL2(N28), 
        .Z(mem_read_enable) );
  GTECH_BUF B_27 ( .A(N159), .Z(N27) );
  GTECH_BUF B_28 ( .A(N183), .Z(N28) );
  SELECT_OP C440 ( .DATA1(1'b1), .DATA2(1'b0), .CONTROL1(N29), .CONTROL2(N30), 
        .Z(mem_write_enable) );
  GTECH_BUF B_29 ( .A(N184), .Z(N29) );
  GTECH_BUF B_30 ( .A(N185), .Z(N30) );
  SELECT_OP C441 ( .DATA1(1'b0), .DATA2(1'b1), .CONTROL1(N16), .CONTROL2(N17), 
        .Z(fsm_read_control) );
  SELECT_OP C442 ( .DATA1(1'b0), .DATA2(1'b1), .CONTROL1(N16), .CONTROL2(N17), 
        .Z(fsm_write_control) );
  SELECT_OP C443 ( .DATA1(1'b0), .DATA2(1'b1), .CONTROL1(N16), .CONTROL2(N17), 
        .Z(busy) );
  GTECH_NOT I_0 ( .A(reset), .Z(N31) );
  GTECH_NOT I_1 ( .A(state[3]), .Z(N36) );
  GTECH_NOT I_2 ( .A(state[2]), .Z(N37) );
  GTECH_NOT I_3 ( .A(state[1]), .Z(N38) );
  GTECH_NOT I_4 ( .A(state[0]), .Z(N39) );
  GTECH_NOT I_5 ( .A(N45), .Z(N46) );
  GTECH_NOT I_6 ( .A(N49), .Z(N50) );
  GTECH_NOT I_7 ( .A(N53), .Z(N54) );
  GTECH_NOT I_8 ( .A(N57), .Z(N58) );
  GTECH_NOT I_9 ( .A(N64), .Z(N65) );
  GTECH_NOT I_10 ( .A(N68), .Z(N69) );
  GTECH_NOT I_11 ( .A(N72), .Z(N73) );
  GTECH_NOT I_12 ( .A(N76), .Z(N77) );
  GTECH_OR2 C480 ( .A(N79), .B(N198), .Z(N84) );
  GTECH_OR2 C481 ( .A(N81), .B(N83), .Z(N198) );
  GTECH_OR2 C495 ( .A(store), .B(load), .Z(N85) );
  GTECH_NOT I_13 ( .A(N85), .Z(N86) );
  GTECH_NOT I_14 ( .A(N87), .Z(N88) );
  GTECH_NOT I_15 ( .A(N89), .Z(N90) );
  GTECH_NOT I_16 ( .A(word_type[1]), .Z(N91) );
  GTECH_NOT I_17 ( .A(word_type[0]), .Z(N92) );
  GTECH_NOT I_18 ( .A(load), .Z(N102) );
  GTECH_AND2 C505 ( .A(store), .B(N102), .Z(N103) );
  GTECH_NOT I_19 ( .A(state[3]), .Z(N104) );
  GTECH_NOT I_20 ( .A(state[2]), .Z(N105) );
  GTECH_NOT I_21 ( .A(state[1]), .Z(N106) );
  GTECH_NOT I_22 ( .A(state[0]), .Z(N107) );
  GTECH_NOT I_23 ( .A(N113), .Z(N114) );
  GTECH_NOT I_24 ( .A(N117), .Z(N118) );
  GTECH_NOT I_25 ( .A(N121), .Z(N122) );
  GTECH_NOT I_26 ( .A(N125), .Z(N126) );
  GTECH_NOT I_27 ( .A(N132), .Z(N133) );
  GTECH_NOT I_28 ( .A(N136), .Z(N137) );
  GTECH_NOT I_29 ( .A(N140), .Z(N141) );
  GTECH_NOT I_30 ( .A(N144), .Z(N145) );
  GTECH_OR2 C537 ( .A(N147), .B(N199), .Z(N152) );
  GTECH_OR2 C538 ( .A(N149), .B(N151), .Z(N199) );
  GTECH_NOT I_31 ( .A(is_signed_fsm), .Z(N153) );
endmodule


module memory_interface ( address, data_in, load, store, clk, reset, is_signed, 
        word_type, from_mem_data, to_mem_read_enable, to_mem_write_enable, 
        to_mem_mem_enable, to_mem_address, to_mem_data, data_out, write_ready, 
        output_valid, busy );
  input [11:0] address;
  input [31:0] data_in;
  input [1:0] word_type;
  input [15:0] from_mem_data;
  output [11:0] to_mem_address;
  output [15:0] to_mem_data;
  output [31:0] data_out;
  input load, store, clk, reset, is_signed;
  output to_mem_read_enable, to_mem_write_enable, to_mem_mem_enable,
         write_ready, output_valid, busy;
  wire   N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15,
         N16, N17, N18, N19, N20, N21, added_or_delayed_address, N22, N23, N24,
         N25, N26, N27, N28, N29, N30, N31, N32, N33, N34,
         modified_or_original_address, N35, N36, N37,
         old_or_new_byte_remainder, N38, output_shuffle, N39, N40, N41, N42,
         N43, N44, N45, N46, N47, N48, N49, delayed_is_signed, fsm_read_out,
         fsm_write_out, fsm_read_control, fsm_write_control, word_dep, N50, r,
         w, N51, N52;
  wire   [11:0] delay_addr_for_adder;
  wire   [11:0] modified_address;
  wire   [11:0] delay_addr_single;
  wire   [1:0] direct_or_delayed_din;
  wire   [15:0] direct_data_in16;
  wire   [15:0] delayed_data_in16;
  wire   [31:0] delay_data_in32;
  wire   [15:8] data_bus_to_mem;
  wire   [15:8] data_top_out;
  wire   [15:0] data_low_out;
  wire   [1:0] third_byte_out_select;
  wire   [7:0] sign_extended_third_byte;
  wire   [7:0] sign_extension_byte;
  wire   [1:0] first_two_bytes_out_select;
  wire   [15:0] delay_first_two_bytes_out;
  wire   [15:15] sign_b_extension;
  wire   [15:15] sign_a_extension;

  GTECH_OR2 C196 ( .A(N42), .B(first_two_bytes_out_select[0]), .Z(N43) );
  GTECH_OR2 C199 ( .A(first_two_bytes_out_select[1]), .B(N45), .Z(N46) );
  GTECH_AND2 C201 ( .A(first_two_bytes_out_select[1]), .B(
        first_two_bytes_out_select[0]), .Z(N48) );
  GTECH_AND2 C204 ( .A(N42), .B(N45), .Z(N49) );
  \**SEQGEN**  delay_first_two_bytes_out_reg_15_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(from_mem_data[7]), .clocked_on(clk), .data_in(1'b0), 
        .enable(1'b0), .Q(delay_first_two_bytes_out[15]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_first_two_bytes_out_reg_14_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(from_mem_data[6]), .clocked_on(clk), .data_in(1'b0), 
        .enable(1'b0), .Q(delay_first_two_bytes_out[14]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_first_two_bytes_out_reg_13_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(from_mem_data[5]), .clocked_on(clk), .data_in(1'b0), 
        .enable(1'b0), .Q(delay_first_two_bytes_out[13]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_first_two_bytes_out_reg_12_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(from_mem_data[4]), .clocked_on(clk), .data_in(1'b0), 
        .enable(1'b0), .Q(delay_first_two_bytes_out[12]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_first_two_bytes_out_reg_11_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(from_mem_data[3]), .clocked_on(clk), .data_in(1'b0), 
        .enable(1'b0), .Q(delay_first_two_bytes_out[11]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_first_two_bytes_out_reg_10_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(from_mem_data[2]), .clocked_on(clk), .data_in(1'b0), 
        .enable(1'b0), .Q(delay_first_two_bytes_out[10]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_first_two_bytes_out_reg_9_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(from_mem_data[1]), .clocked_on(clk), .data_in(1'b0), 
        .enable(1'b0), .Q(delay_first_two_bytes_out[9]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_first_two_bytes_out_reg_8_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(from_mem_data[0]), .clocked_on(clk), .data_in(1'b0), 
        .enable(1'b0), .Q(delay_first_two_bytes_out[8]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_first_two_bytes_out_reg_7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(from_mem_data[15]), .clocked_on(clk), .data_in(1'b0), 
        .enable(1'b0), .Q(delay_first_two_bytes_out[7]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_first_two_bytes_out_reg_6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(from_mem_data[14]), .clocked_on(clk), .data_in(1'b0), 
        .enable(1'b0), .Q(delay_first_two_bytes_out[6]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_first_two_bytes_out_reg_5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(from_mem_data[13]), .clocked_on(clk), .data_in(1'b0), 
        .enable(1'b0), .Q(delay_first_two_bytes_out[5]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_first_two_bytes_out_reg_4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(from_mem_data[12]), .clocked_on(clk), .data_in(1'b0), 
        .enable(1'b0), .Q(delay_first_two_bytes_out[4]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_first_two_bytes_out_reg_3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(from_mem_data[11]), .clocked_on(clk), .data_in(1'b0), 
        .enable(1'b0), .Q(delay_first_two_bytes_out[3]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_first_two_bytes_out_reg_2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(from_mem_data[10]), .clocked_on(clk), .data_in(1'b0), 
        .enable(1'b0), .Q(delay_first_two_bytes_out[2]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_first_two_bytes_out_reg_1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(from_mem_data[9]), .clocked_on(clk), .data_in(1'b0), 
        .enable(1'b0), .Q(delay_first_two_bytes_out[1]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_first_two_bytes_out_reg_0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(from_mem_data[8]), .clocked_on(clk), .data_in(1'b0), 
        .enable(1'b0), .Q(delay_first_two_bytes_out[0]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_data_in32_reg_31_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(data_in[31]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_data_in32[31]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_data_in32_reg_30_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(data_in[30]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_data_in32[30]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_data_in32_reg_29_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(data_in[29]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_data_in32[29]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_data_in32_reg_28_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(data_in[28]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_data_in32[28]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_data_in32_reg_27_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(data_in[27]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_data_in32[27]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_data_in32_reg_26_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(data_in[26]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_data_in32[26]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_data_in32_reg_25_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(data_in[25]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_data_in32[25]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_data_in32_reg_24_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(data_in[24]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_data_in32[24]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_data_in32_reg_23_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(data_in[23]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_data_in32[23]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_data_in32_reg_22_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(data_in[22]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_data_in32[22]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_data_in32_reg_21_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(data_in[21]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_data_in32[21]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_data_in32_reg_20_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(data_in[20]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_data_in32[20]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_data_in32_reg_19_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(data_in[19]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_data_in32[19]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_data_in32_reg_18_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(data_in[18]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_data_in32[18]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_data_in32_reg_17_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(data_in[17]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_data_in32[17]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_data_in32_reg_16_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(data_in[16]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_data_in32[16]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_data_in32_reg_15_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(data_in[15]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_data_in32[15]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_data_in32_reg_14_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(data_in[14]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_data_in32[14]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_data_in32_reg_13_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(data_in[13]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_data_in32[13]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_data_in32_reg_12_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(data_in[12]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_data_in32[12]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_data_in32_reg_11_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(data_in[11]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_data_in32[11]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_data_in32_reg_10_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(data_in[10]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_data_in32[10]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_data_in32_reg_9_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(data_in[9]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_data_in32[9]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_data_in32_reg_8_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(data_in[8]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_data_in32[8]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_data_in32_reg_7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(data_in[7]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_data_in32[7]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_data_in32_reg_6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(data_in[6]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_data_in32[6]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_data_in32_reg_5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(data_in[5]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_data_in32[5]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_data_in32_reg_4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(data_in[4]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_data_in32[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_data_in32_reg_3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(data_in[3]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_data_in32[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_data_in32_reg_2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(data_in[2]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_data_in32[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_data_in32_reg_1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(data_in[1]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_data_in32[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_data_in32_reg_0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(data_in[0]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_data_in32[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_addr_for_adder_reg_11_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(address[11]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_addr_for_adder[11]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_addr_for_adder_reg_10_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(address[10]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_addr_for_adder[10]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_addr_for_adder_reg_9_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(address[9]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_addr_for_adder[9]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_addr_for_adder_reg_8_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(address[8]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_addr_for_adder[8]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_addr_for_adder_reg_7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(address[7]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_addr_for_adder[7]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_addr_for_adder_reg_6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(address[6]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_addr_for_adder[6]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_addr_for_adder_reg_5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(address[5]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_addr_for_adder[5]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_addr_for_adder_reg_4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(address[4]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_addr_for_adder[4]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_addr_for_adder_reg_3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(address[3]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_addr_for_adder[3]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_addr_for_adder_reg_2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(address[2]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_addr_for_adder[2]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_addr_for_adder_reg_1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(address[1]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_addr_for_adder[1]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_addr_for_adder_reg_0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(address[0]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_addr_for_adder[0]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_addr_single_reg_11_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(address[11]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_addr_single[11]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_addr_single_reg_10_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(address[10]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_addr_single[10]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_addr_single_reg_9_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(address[9]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_addr_single[9]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_addr_single_reg_8_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(address[8]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_addr_single[8]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_addr_single_reg_7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(address[7]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_addr_single[7]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_addr_single_reg_6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(address[6]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_addr_single[6]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_addr_single_reg_5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(address[5]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_addr_single[5]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_addr_single_reg_4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(address[4]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_addr_single[4]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_addr_single_reg_3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(address[3]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_addr_single[3]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_addr_single_reg_2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(address[2]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_addr_single[2]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_addr_single_reg_1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(address[1]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_addr_single[1]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delay_addr_single_reg_0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(address[0]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(delay_addr_single[0]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  delayed_is_signed_reg ( .clear(1'b0), .preset(1'b0), 
        .next_state(is_signed), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(delayed_is_signed), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  memory_control_fsm fsm ( .is_signed_fsm(delayed_is_signed), .word_type(
        word_type), .load(load), .store(store), .clk(clk), .reset(reset), 
        .output_valid(output_valid), .direct_or_delayed_din(
        direct_or_delayed_din), .write_ready(write_ready), 
        .old_or_new_byte_remainder(old_or_new_byte_remainder), 
        .modified_or_original_address(modified_or_original_address), 
        .added_or_delayed_address(added_or_delayed_address), 
        .first_two_bytes_out_select(first_two_bytes_out_select), 
        .third_byte_out_select(third_byte_out_select), .output_shuffle(
        output_shuffle), .mem_read_enable(fsm_read_out), .mem_write_enable(
        fsm_write_out), .mem_enable(to_mem_mem_enable), .fsm_read_control(
        fsm_read_control), .fsm_write_control(fsm_write_control), .busy(busy)
         );
  ADD_UNS_OP add_140 ( .A(delay_addr_for_adder), .B(1'b1), .Z({N34, N33, N32, 
        N31, N30, N29, N28, N27, N26, N25, N24, N23}) );
  SELECT_OP C297 ( .DATA1({N34, N33, N32, N31, N30, N29, N28, N27, N26, N25, 
        N24, N23}), .DATA2(delay_addr_single), .CONTROL1(N0), .CONTROL2(N1), 
        .Z(modified_address) );
  GTECH_BUF B_0 ( .A(added_or_delayed_address), .Z(N0) );
  GTECH_BUF B_1 ( .A(N22), .Z(N1) );
  SELECT_OP C298 ( .DATA1(address), .DATA2(modified_address), .CONTROL1(N2), 
        .CONTROL2(N3), .Z(to_mem_address) );
  GTECH_BUF B_2 ( .A(modified_or_original_address), .Z(N2) );
  GTECH_BUF B_3 ( .A(N35), .Z(N3) );
  SELECT_OP C299 ( .DATA1(data_in[15:0]), .DATA2(data_in[31:16]), .CONTROL1(N4), .CONTROL2(N36), .Z(direct_data_in16) );
  GTECH_BUF B_4 ( .A(direct_or_delayed_din[0]), .Z(N4) );
  SELECT_OP C300 ( .DATA1(delay_data_in32[15:0]), .DATA2(
        delay_data_in32[31:16]), .CONTROL1(N4), .CONTROL2(N36), .Z(
        delayed_data_in16) );
  SELECT_OP C301 ( .DATA1(delayed_data_in16), .DATA2(direct_data_in16), 
        .CONTROL1(N5), .CONTROL2(N37), .Z({data_bus_to_mem, to_mem_data[15:8]}) );
  GTECH_BUF B_5 ( .A(direct_or_delayed_din[1]), .Z(N5) );
  SELECT_OP C302 ( .DATA1(data_bus_to_mem), .DATA2(from_mem_data[7:0]), 
        .CONTROL1(N6), .CONTROL2(N7), .Z(to_mem_data[7:0]) );
  GTECH_BUF B_6 ( .A(old_or_new_byte_remainder), .Z(N6) );
  GTECH_BUF B_7 ( .A(N38), .Z(N7) );
  SELECT_OP C303 ( .DATA1({data_top_out, from_mem_data[15:8]}), .DATA2(
        data_low_out), .CONTROL1(N8), .CONTROL2(N9), .Z(data_out[31:16]) );
  GTECH_BUF B_8 ( .A(output_shuffle), .Z(N8) );
  GTECH_BUF B_9 ( .A(N39), .Z(N9) );
  SELECT_OP C304 ( .DATA1(data_low_out), .DATA2({data_top_out, 
        from_mem_data[15:8]}), .CONTROL1(N8), .CONTROL2(N9), .Z(data_out[15:0]) );
  SELECT_OP C305 ( .DATA1(from_mem_data[7:0]), .DATA2(sign_extended_third_byte), .CONTROL1(N10), .CONTROL2(N40), .Z(data_top_out) );
  GTECH_BUF B_10 ( .A(third_byte_out_select[1]), .Z(N10) );
  SELECT_OP C306 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), 
        .DATA2(sign_extension_byte), .CONTROL1(N11), .CONTROL2(N41), .Z(
        sign_extended_third_byte) );
  GTECH_BUF B_11 ( .A(third_byte_out_select[0]), .Z(N11) );
  GTECH_NOT I_0 ( .A(sign_a_extension[15]), .Z(sign_extension_byte[0]) );
  GTECH_NOT I_1 ( .A(sign_a_extension[15]), .Z(sign_extension_byte[1]) );
  GTECH_NOT I_2 ( .A(sign_a_extension[15]), .Z(sign_extension_byte[2]) );
  GTECH_NOT I_3 ( .A(sign_a_extension[15]), .Z(sign_extension_byte[3]) );
  GTECH_NOT I_4 ( .A(sign_a_extension[15]), .Z(sign_extension_byte[4]) );
  GTECH_NOT I_5 ( .A(sign_a_extension[15]), .Z(sign_extension_byte[5]) );
  GTECH_NOT I_6 ( .A(sign_a_extension[15]), .Z(sign_extension_byte[6]) );
  GTECH_NOT I_7 ( .A(sign_a_extension[15]), .Z(sign_extension_byte[7]) );
  SELECT_OP C315 ( .DATA1(delay_first_two_bytes_out), .DATA2({
        sign_b_extension[15], sign_b_extension[15], sign_b_extension[15], 
        sign_b_extension[15], sign_b_extension[15], sign_b_extension[15], 
        sign_b_extension[15], sign_b_extension[15], sign_b_extension[15], 
        sign_b_extension[15], sign_b_extension[15], sign_b_extension[15], 
        sign_b_extension[15], sign_b_extension[15], sign_b_extension[15], 
        sign_b_extension[15]}), .DATA3({sign_a_extension[15], 
        sign_a_extension[15], sign_a_extension[15], sign_a_extension[15], 
        sign_a_extension[15], sign_a_extension[15], sign_a_extension[15], 
        sign_a_extension[15], sign_a_extension[15], sign_a_extension[15], 
        sign_a_extension[15], sign_a_extension[15], sign_a_extension[15], 
        sign_a_extension[15], sign_a_extension[15], sign_a_extension[15]}), 
        .DATA4({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .CONTROL1(N12), .CONTROL2(N13), 
        .CONTROL3(N14), .CONTROL4(N15), .Z(data_low_out) );
  GTECH_BUF B_12 ( .A(N44), .Z(N12) );
  GTECH_BUF B_13 ( .A(N47), .Z(N13) );
  GTECH_BUF B_14 ( .A(N48), .Z(N14) );
  GTECH_BUF B_15 ( .A(N49), .Z(N15) );
  SELECT_OP C316 ( .DATA1(load), .DATA2(1'b1), .CONTROL1(N16), .CONTROL2(N17), 
        .Z(r) );
  GTECH_BUF B_16 ( .A(word_dep), .Z(N16) );
  GTECH_BUF B_17 ( .A(N50), .Z(N17) );
  SELECT_OP C317 ( .DATA1(store), .DATA2(1'b0), .CONTROL1(N16), .CONTROL2(N17), 
        .Z(w) );
  SELECT_OP C318 ( .DATA1(fsm_read_out), .DATA2(r), .CONTROL1(N18), .CONTROL2(
        N19), .Z(to_mem_read_enable) );
  GTECH_BUF B_18 ( .A(fsm_read_control), .Z(N18) );
  GTECH_BUF B_19 ( .A(N51), .Z(N19) );
  SELECT_OP C319 ( .DATA1(fsm_write_out), .DATA2(w), .CONTROL1(N20), 
        .CONTROL2(N21), .Z(to_mem_write_enable) );
  GTECH_BUF B_20 ( .A(fsm_write_control), .Z(N20) );
  GTECH_BUF B_21 ( .A(N52), .Z(N21) );
  GTECH_NOT I_8 ( .A(added_or_delayed_address), .Z(N22) );
  GTECH_BUF B_22 ( .A(added_or_delayed_address) );
  GTECH_NOT I_9 ( .A(modified_or_original_address), .Z(N35) );
  GTECH_NOT I_10 ( .A(direct_or_delayed_din[0]), .Z(N36) );
  GTECH_NOT I_11 ( .A(direct_or_delayed_din[1]), .Z(N37) );
  GTECH_NOT I_12 ( .A(old_or_new_byte_remainder), .Z(N38) );
  GTECH_NOT I_13 ( .A(output_shuffle), .Z(N39) );
  GTECH_NOT I_14 ( .A(third_byte_out_select[1]), .Z(N40) );
  GTECH_NOT I_15 ( .A(third_byte_out_select[0]), .Z(N41) );
  GTECH_NOT I_16 ( .A(first_two_bytes_out_select[1]), .Z(N42) );
  GTECH_NOT I_17 ( .A(N43), .Z(N44) );
  GTECH_NOT I_18 ( .A(first_two_bytes_out_select[0]), .Z(N45) );
  GTECH_NOT I_19 ( .A(N46), .Z(N47) );
  GTECH_BUF B_23 ( .A(from_mem_data[7]), .Z(sign_b_extension[15]) );
  GTECH_BUF B_24 ( .A(from_mem_data[15]), .Z(sign_a_extension[15]) );
  GTECH_OR2 C360 ( .A(word_type[0]), .B(word_type[1]), .Z(word_dep) );
  GTECH_NOT I_20 ( .A(word_dep), .Z(N50) );
  GTECH_NOT I_21 ( .A(fsm_read_control), .Z(N51) );
  GTECH_NOT I_22 ( .A(fsm_write_control), .Z(N52) );
endmodule


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
  wire   N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15,
         N16, N17, N18, N19, N20, N21, N22, N23, N24, N25, N26, N27, N28, N29,
         N30, N31, N32, N33, N34, N35, N36, N37, N38, N39, N40, N41, N42, N43,
         N44, N45, N46, N47, N48, N49, N50, N51, N52, N53, N54, N55, N56, N57,
         N58, N59, N60, N61, N62, N63, N64, N65, N66, N67, N68, N69, N70, N71,
         N72, net3375;
  wire   [12:1] current_pc_modified;
  wire   [1:0] currentState;
  wire   [1:0] nextState;

  GTECH_AND2 C6 ( .A(N9), .B(N10), .Z(N11) );
  GTECH_OR2 C8 ( .A(currentState[1]), .B(N10), .Z(N12) );
  GTECH_OR2 C11 ( .A(N9), .B(currentState[0]), .Z(N14) );
  GTECH_AND2 C13 ( .A(currentState[1]), .B(currentState[0]), .Z(N16) );
  \**SEQGEN**  currentState_reg_1_ ( .clear(reset), .preset(1'b0), 
        .next_state(nextState[1]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(currentState[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  currentState_reg_0_ ( .clear(reset), .preset(1'b0), 
        .next_state(nextState[0]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(currentState[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  SUB_UNS_OP sub_31 ( .A(current_pc_in[12:0]), .B({1'b1, 1'b0}), .Z({
        current_pc_modified, net3375}) );
  GTECH_OR3 C192 ( .A(N11), .B(N13), .C(N16), .Z(N68) );
  GTECH_OR2 C194 ( .A(N11), .B(N16), .Z(N69) );
  GTECH_OR2 C195 ( .A(N13), .B(N15), .Z(N70) );
  GTECH_OR2 C230 ( .A(N11), .B(N13), .Z(N71) );
  GTECH_OR2 C231 ( .A(N15), .B(N16), .Z(N72) );
  ADD_UNS_OP add_60 ( .A(current_pc_in), .B({1'b1, 1'b0}), .Z({N50, N49, N48, 
        N47, N46, N45, N44, N43, N42, N41, N40, N39, N38, N37, N36, N35, N34, 
        N33, N32, N31, N30, N29, N28, N27, N26, N25, N24, N23, N22, N21, N20, 
        N19}) );
  SELECT_OP C331 ( .DATA1(instruction_in), .DATA2({1'b1, 1'b0, 1'b1, 1'b1, 
        1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .CONTROL1(N0), .CONTROL2(N1), .Z({N67, N66, N65, N64, N63, N62, N61, N60, 
        N59, N58, N57, N56, N55, N54, N53, N52}) );
  GTECH_BUF B_0 ( .A(memory_output_valid), .Z(N0) );
  GTECH_BUF B_1 ( .A(N51), .Z(N1) );
  SELECT_OP C332 ( .DATA1({N17, 1'b0}), .DATA2({N18, stall_decoder_in}), 
        .DATA3({N51, memory_output_valid}), .DATA4({N51, 1'b1}), .CONTROL1(N2), 
        .CONTROL2(N13), .CONTROL3(N15), .CONTROL4(N3), .Z(nextState) );
  GTECH_BUF B_2 ( .A(N11), .Z(N2) );
  GTECH_BUF B_3 ( .A(N16), .Z(N3) );
  SELECT_OP C333 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA2({N50, N49, N48, N47, N46, N45, N44, N43, N42, N41, N40, N39, N38, 
        N37, N36, N35, N34, N33, N32, N31, N30, N29, N28, N27, N26, N25, N24, 
        N23, N22, N21, N20, N19}), .DATA3(current_pc_in), .CONTROL1(N4), 
        .CONTROL2(N15), .CONTROL3(N3), .Z(incremented_pc_out) );
  GTECH_BUF B_4 ( .A(N71), .Z(N4) );
  SELECT_OP C334 ( .DATA1(1'b0), .DATA2(memory_output_valid), .CONTROL1(N5), 
        .CONTROL2(N15), .Z(incremented_pc_write_enable) );
  GTECH_BUF B_5 ( .A(N68), .Z(N5) );
  SELECT_OP C335 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0}), .DATA2(current_pc_modified), .CONTROL1(N6), 
        .CONTROL2(N7), .Z(memory_address) );
  GTECH_BUF B_6 ( .A(N69), .Z(N6) );
  GTECH_BUF B_7 ( .A(N70), .Z(N7) );
  SELECT_OP C336 ( .DATA1(1'b0), .DATA2(1'b1), .CONTROL1(N4), .CONTROL2(N8), 
        .Z(memory_load_request) );
  GTECH_BUF B_8 ( .A(N72), .Z(N8) );
  SELECT_OP C337 ( .DATA1({1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA2({N67, N66, 
        N65, N64, N63, N62, N61, N60, N59, N58, N57, N56, N55, N54, N53, N52}), 
        .DATA3({N67, N66, N65, N64, N63, N62, N61, N60, N59, N58, N57, N56, 
        N55, N54, N53, N52}), .CONTROL1(N4), .CONTROL2(N15), .CONTROL3(N3), 
        .Z(instruction_out) );
  SELECT_OP C338 ( .DATA1(1'b0), .DATA2(memory_output_valid), .DATA3(
        memory_output_valid), .CONTROL1(N4), .CONTROL2(N15), .CONTROL3(N3), 
        .Z(instruction_valid) );
  GTECH_NOT I_0 ( .A(currentState[1]), .Z(N9) );
  GTECH_NOT I_1 ( .A(currentState[0]), .Z(N10) );
  GTECH_NOT I_2 ( .A(N12), .Z(N13) );
  GTECH_NOT I_3 ( .A(N14), .Z(N15) );
  GTECH_NOT I_4 ( .A(reset), .Z(N17) );
  GTECH_NOT I_5 ( .A(stall_decoder_in), .Z(N18) );
  GTECH_BUF B_9 ( .A(N15) );
  GTECH_NOT I_6 ( .A(memory_output_valid), .Z(N51) );
endmodule


module top7 ( clock, reset, stall_from_instructionfetch, decoder_pc_update, 
        MEM_MEMCTRL_from_mem_data, MEMCTRL_MEM_to_mem_read_enable, 
        MEMCTRL_MEM_to_mem_write_enable, MEMCTRL_MEM_to_mem_mem_enable, 
        MEMCTRL_MEM_to_mem_address, MEMCTRL_MEM_to_mem_data );
  input [15:0] MEM_MEMCTRL_from_mem_data;
  output [11:0] MEMCTRL_MEM_to_mem_address;
  output [15:0] MEMCTRL_MEM_to_mem_data;
  input clock, reset, stall_from_instructionfetch;
  output decoder_pc_update, MEMCTRL_MEM_to_mem_read_enable,
         MEMCTRL_MEM_to_mem_write_enable, MEMCTRL_MEM_to_mem_mem_enable;
  wire   N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15,
         N16, DEC_CPSR_update_flag_n, N17, N18, new_n, ALU_OUT_n, RF_OUT_n,
         DEC_CPSR_update_flag_c, N19, N20, new_c, ALU_OUT_c, RF_OUT_c,
         DEC_CPSR_update_flag_z, N21, N22, new_z, ALU_OUT_z, RF_OUT_z,
         DEC_CPSR_update_flag_v, N23, N24, new_v, ALU_OUT_v, RF_OUT_v,
         IF_DEC_instruction_valid, MEMCTRL_write_finished,
         MEMCTRL_read_finished, DEC_MISC_OUT_pc_mask_bit,
         DEC_RF_alu_stack_write_to_reg_enable,
         DEC_RF_memory_write_to_reg_enable,
         DEC_MISC_OUT_memory_address_source_is_reg,
         DEC_MEMCTRL_memorycontroller_sign_extend,
         DEC_MEMCTRL_CTRL_memory_load_request,
         DEC_MEMCTRL_CTRL_memory_store_request, DEC_STACK_push_request,
         DEC_STACK_pop_request, DEC_IF_stall_to_instructionfetch,
         IF_RF_incremented_pc_write_enable, N25, ALU_IN_c, carry_none,
         IF_memory_load_req, N26, N27, MEMCTRL_load_in, MEMCTRL_busy, N28, N29,
         N30, N31, N32, N33;
  wire   [15:0] IF_DEC_instruction;
  wire   [4:0] DEC_RF_operand_a;
  wire   [4:0] DEC_RF_operand_b;
  wire   [31:0] DEC_RF_offset_a;
  wire   [31:0] DEC_RF_offset_b;
  wire   [4:0] DEC_ALU_alu_opcode;
  wire   [4:0] DEC_RF_alu_stack_write_to_reg;
  wire   [4:0] DEC_RF_memory_write_to_reg;
  wire   [4:0] DEC_RF_memory_store_data_reg;
  wire   [4:0] DEC_RF_memory_store_address_reg;
  wire   [1:0] DEC_MEMCTRL_load_store_width;
  wire   [31:0] ALU_MISC_OUT_result;
  wire   [31:0] MEMCTRL_RF_IF_data_in;
  wire   [31:0] IF_RF_incremented_pc_out;
  wire   [31:0] STACK_RF_next_sp;
  wire   [31:0] RF_ALU_STACK_operand_a;
  wire   [31:0] RF_ALU_operand_b;
  wire   [31:0] RF_MEMCTRL_data_reg;
  wire   [31:0] RF_MEMCTRL_address_reg;
  wire   [31:0] RF_pc_out;
  wire   [11:0] MEMCTRL_IN_address;
  wire   [11:0] IF_instruction_memory_address;
  wire   [12:2] DEC_memory_address;

  GTECH_XOR2 C4 ( .A(1'b1), .B(DEC_CPSR_update_flag_n), .Z(N0) );
  GTECH_NOT I_0 ( .A(N0), .Z(N17) );
  GTECH_XOR2 C11 ( .A(1'b1), .B(DEC_CPSR_update_flag_c), .Z(N1) );
  GTECH_NOT I_1 ( .A(N1), .Z(N19) );
  GTECH_XOR2 C18 ( .A(1'b1), .B(DEC_CPSR_update_flag_z), .Z(N2) );
  GTECH_NOT I_2 ( .A(N2), .Z(N21) );
  GTECH_XOR2 C25 ( .A(1'b1), .B(DEC_CPSR_update_flag_v), .Z(N3) );
  GTECH_NOT I_3 ( .A(N3), .Z(N23) );
  irdecode irdecode_inst1 ( .clock(clock), .reset(reset), .instruction(
        IF_DEC_instruction), .instruction_valid(IF_DEC_instruction_valid), 
        .flag_n(RF_OUT_n), .flag_z(RF_OUT_z), .flag_c(RF_OUT_c), .flag_v(
        RF_OUT_v), .memory_write_finished(MEMCTRL_write_finished), 
        .memory_read_finished(MEMCTRL_read_finished), 
        .stall_from_instructionfetch(stall_from_instructionfetch), .operand_a(
        DEC_RF_operand_a), .operand_b(DEC_RF_operand_b), .offset_a(
        DEC_RF_offset_a), .offset_b(DEC_RF_offset_b), .alu_opcode(
        DEC_ALU_alu_opcode), .pc_mask_bit(DEC_MISC_OUT_pc_mask_bit), 
        .update_flag_n(DEC_CPSR_update_flag_n), .update_flag_z(
        DEC_CPSR_update_flag_z), .update_flag_c(DEC_CPSR_update_flag_c), 
        .update_flag_v(DEC_CPSR_update_flag_v), .alu_stack_write_to_reg(
        DEC_RF_alu_stack_write_to_reg), .alu_stack_write_to_reg_enable(
        DEC_RF_alu_stack_write_to_reg_enable), .memory_write_to_reg(
        DEC_RF_memory_write_to_reg), .memory_write_to_reg_enable(
        DEC_RF_memory_write_to_reg_enable), .memory_store_data_reg(
        DEC_RF_memory_store_data_reg), .memory_store_address_reg(
        DEC_RF_memory_store_address_reg), .memory_address_source_is_reg(
        DEC_MISC_OUT_memory_address_source_is_reg), .load_store_width(
        DEC_MEMCTRL_load_store_width), .memorycontroller_sign_extend(
        DEC_MEMCTRL_memorycontroller_sign_extend), .memory_load_request(
        DEC_MEMCTRL_CTRL_memory_load_request), .memory_store_request(
        DEC_MEMCTRL_CTRL_memory_store_request), .stack_push_request(
        DEC_STACK_push_request), .stack_pop_request(DEC_STACK_pop_request), 
        .stall_to_instructionfetch(DEC_IF_stall_to_instructionfetch), 
        .decoder_pc_update(decoder_pc_update) );
  register_file register_file_inst1 ( .readA_sel(DEC_RF_operand_a), 
        .readB_sel(DEC_RF_operand_b), .readC_sel(DEC_RF_memory_store_data_reg), 
        .readD_sel(DEC_RF_memory_store_address_reg), .write1_sel(
        DEC_RF_alu_stack_write_to_reg), .write2_sel(DEC_RF_memory_write_to_reg), .write1_en(DEC_RF_alu_stack_write_to_reg_enable), .write2_en(
        DEC_RF_memory_write_to_reg_enable), .write1_in(ALU_MISC_OUT_result), 
        .write2_in(MEMCTRL_RF_IF_data_in), .immediate1_in(DEC_RF_offset_a), 
        .immediate2_in(DEC_RF_offset_b), .next_pc_in(IF_RF_incremented_pc_out), 
        .next_cpsr_in({new_n, new_c, new_z, new_v}), .next_sp_in(
        STACK_RF_next_sp), .next_pc_en(IF_RF_incremented_pc_write_enable), 
        .clk(clock), .reset(reset), .regA_out(RF_ALU_STACK_operand_a), 
        .regB_out(RF_ALU_operand_b), .regC_out(RF_MEMCTRL_data_reg), 
        .regD_out(RF_MEMCTRL_address_reg), .pc_out(RF_pc_out), .cpsr_out({
        RF_OUT_n, RF_OUT_c, RF_OUT_z, RF_OUT_v}), .sp_out(STACK_RF_next_sp) );
  ALU_VARIABLE ALU_VARIABLE_inst1 ( .a(RF_ALU_STACK_operand_a), .b(
        RF_ALU_operand_b), .op(DEC_ALU_alu_opcode[3:0]), .c_in(ALU_IN_c), 
        .result(ALU_MISC_OUT_result), .c_out(ALU_OUT_c), .z(ALU_OUT_z), .n(
        ALU_OUT_n), .v(ALU_OUT_v) );
  memory_interface memory_interface_inst1 ( .address(MEMCTRL_IN_address), 
        .data_in(RF_MEMCTRL_data_reg), .load(MEMCTRL_load_in), .store(
        DEC_MEMCTRL_CTRL_memory_store_request), .clk(clock), .reset(reset), 
        .is_signed(DEC_MEMCTRL_memorycontroller_sign_extend), .word_type(
        DEC_MEMCTRL_load_store_width), .from_mem_data(
        MEM_MEMCTRL_from_mem_data), .to_mem_read_enable(
        MEMCTRL_MEM_to_mem_read_enable), .to_mem_write_enable(
        MEMCTRL_MEM_to_mem_write_enable), .to_mem_mem_enable(
        MEMCTRL_MEM_to_mem_mem_enable), .to_mem_address(
        MEMCTRL_MEM_to_mem_address), .to_mem_data(MEMCTRL_MEM_to_mem_data), 
        .data_out(MEMCTRL_RF_IF_data_in), .write_ready(MEMCTRL_write_finished), 
        .output_valid(MEMCTRL_read_finished), .busy(MEMCTRL_busy) );
  Instruction_Fetch Instruction_Fetch_inst1 ( .clk(clock), .reset(reset), 
        .stall_decoder_in(DEC_IF_stall_to_instructionfetch), 
        .memory_output_valid(MEMCTRL_read_finished), .current_pc_in(RF_pc_out), 
        .instruction_in(MEMCTRL_RF_IF_data_in[15:0]), .memory_load_request(
        IF_memory_load_req), .incremented_pc_write_enable(
        IF_RF_incremented_pc_write_enable), .instruction_valid(
        IF_DEC_instruction_valid), .memory_address(
        IF_instruction_memory_address), .incremented_pc_out(
        IF_RF_incremented_pc_out), .instruction_out(IF_DEC_instruction) );
  GTECH_NOT I_4 ( .A(DEC_ALU_alu_opcode[2]), .Z(N28) );
  GTECH_NOT I_5 ( .A(DEC_ALU_alu_opcode[1]), .Z(N29) );
  GTECH_OR2 C119 ( .A(N28), .B(DEC_ALU_alu_opcode[3]), .Z(N30) );
  GTECH_OR2 C120 ( .A(N29), .B(N30), .Z(N31) );
  GTECH_OR2 C121 ( .A(DEC_ALU_alu_opcode[0]), .B(N31), .Z(N32) );
  GTECH_NOT I_6 ( .A(N32), .Z(N33) );
  SELECT_OP C123 ( .DATA1(ALU_OUT_n), .DATA2(RF_OUT_n), .CONTROL1(N4), 
        .CONTROL2(N5), .Z(new_n) );
  GTECH_BUF B_0 ( .A(N17), .Z(N4) );
  GTECH_BUF B_1 ( .A(N18), .Z(N5) );
  SELECT_OP C124 ( .DATA1(ALU_OUT_c), .DATA2(RF_OUT_c), .CONTROL1(N6), 
        .CONTROL2(N7), .Z(new_c) );
  GTECH_BUF B_2 ( .A(N19), .Z(N6) );
  GTECH_BUF B_3 ( .A(N20), .Z(N7) );
  SELECT_OP C125 ( .DATA1(ALU_OUT_z), .DATA2(RF_OUT_z), .CONTROL1(N8), 
        .CONTROL2(N9), .Z(new_z) );
  GTECH_BUF B_4 ( .A(N21), .Z(N8) );
  GTECH_BUF B_5 ( .A(N22), .Z(N9) );
  SELECT_OP C126 ( .DATA1(ALU_OUT_v), .DATA2(RF_OUT_v), .CONTROL1(N10), 
        .CONTROL2(N11), .Z(new_v) );
  GTECH_BUF B_6 ( .A(N23), .Z(N10) );
  GTECH_BUF B_7 ( .A(N24), .Z(N11) );
  SELECT_OP C127 ( .DATA1(carry_none), .DATA2(RF_OUT_c), .CONTROL1(N12), 
        .CONTROL2(N25), .Z(ALU_IN_c) );
  GTECH_BUF B_8 ( .A(DEC_ALU_alu_opcode[4]), .Z(N12) );
  SELECT_OP C128 ( .DATA1(IF_instruction_memory_address), .DATA2({
        DEC_memory_address, 1'b0}), .CONTROL1(N13), .CONTROL2(N14), .Z(
        MEMCTRL_IN_address) );
  GTECH_BUF B_9 ( .A(IF_memory_load_req), .Z(N13) );
  GTECH_BUF B_10 ( .A(N26), .Z(N14) );
  SELECT_OP C129 ( .DATA1(RF_MEMCTRL_address_reg[12:2]), .DATA2(
        ALU_MISC_OUT_result[12:2]), .CONTROL1(N15), .CONTROL2(N16), .Z(
        DEC_memory_address) );
  GTECH_BUF B_11 ( .A(DEC_MISC_OUT_memory_address_source_is_reg), .Z(N15) );
  GTECH_BUF B_12 ( .A(N27), .Z(N16) );
  SELECT_OP C130 ( .DATA1(IF_memory_load_req), .DATA2(
        DEC_MEMCTRL_CTRL_memory_load_request), .CONTROL1(N13), .CONTROL2(N14), 
        .Z(MEMCTRL_load_in) );
  GTECH_NOT I_7 ( .A(DEC_CPSR_update_flag_n), .Z(N18) );
  GTECH_NOT I_8 ( .A(DEC_CPSR_update_flag_c), .Z(N20) );
  GTECH_NOT I_9 ( .A(DEC_CPSR_update_flag_z), .Z(N22) );
  GTECH_NOT I_10 ( .A(DEC_CPSR_update_flag_v), .Z(N24) );
  GTECH_NOT I_11 ( .A(DEC_ALU_alu_opcode[4]), .Z(N25) );
  GTECH_BUF B_13 ( .A(N33), .Z(carry_none) );
  GTECH_NOT I_12 ( .A(IF_memory_load_req), .Z(N26) );
  GTECH_NOT I_13 ( .A(DEC_MISC_OUT_memory_address_source_is_reg), .Z(N27) );
endmodule

