
`define        ADDRESS_WIDTH    16


// ALU-Opcodes                  // result = a OP b  // rd = op a, rs = op b
`define        AND        5'b00000  // rd = rd AND rs
`define        EOR        5'b00001  // rd = rd XOR rs
`define        LSL        5'b00010  // rd = rd << rs
`define        LSR        5'b00011  // rd = rd >> rs
`define        ASR        5'b00100  // rd = rd ASR rs
`define        ADC        5'b00101  // rd = rd + rs + c-bit
`define        SBC        5'b00110  // rd = rd - rs - NOT c-bit
`define        ROR        5'b00111  // rd = rd RROR rs
`define        TST        5'b01000  // set condition codes i´on rd AND rs
`define        NEG        5'b01001  // rd = ~rs
`define        CMP        5'b01010  // set condition codes on rd - rs
`define        CMN        5'b01011  // set condition codes on rd + rs
`define        ORR        5'b01100  // rd = rd OR rs
`define        MUL        5'b01101  // rd = rs * rd  // Reihenfolge vertauscht!!
`define        BIC        5'b01110  // rd = rd AND NOT rs
`define        MVN        5'b01111  // rd = NOT rs

`define        ADD        5'b10101  // rd = rd + rs
`define        SUB        5'b10110  // rd = rd - rs

// Datenbreiten
`define        BYTE       2'b00  
`define        HALFWORD   2'b01  
`define        WORD       2'b10
`define        ILLEGAL    2'b11

// Registerfile

`define       RF_R0        5'b00000
`define       RF_R1        5'b00001
`define       RF_R2        5'b00010
`define       RF_R3        5'b00011
`define       RF_R4        5'b00100
`define       RF_R5        5'b00101
`define       RF_R6        5'b00110
`define       RF_R7        5'b00111
`define       RF_R8        5'b01000
`define       RF_R9        5'b01001
`define       RF_R10       5'b01010
`define       RF_R11       5'b01011
`define       RF_R12       5'b01100
`define       RF_R13_SP    5'b01101
`define       RF_R14_LR    5'b01110
`define       RF_R15_PC    5'b01111

`define       RF_NONE      5'b11101  // für synthese auf 5'b????? ändern
`define       RF_TMP1      5'b11110
`define       RF_IMM       5'b11111

// sonstiges

`define       IMM_ZERO    32'b0000_0000_0000_0000_0000_0000_0000_0000
`define       IMM_ONES    32'b1111_1111_1111_1111_1111_1111_1111_1111

`define       DONE        1'b1
`define       NOT_DONE    1'b0


//Reihenfolge
// input wire clock;
// input wire [15:0] instruction;
// 
// input wire flag_z;
// input wire flag_c;
// input wire flag_n;
// input wire flag_v;
// 
// input wire stall_from_instructionfetch; 
// input wire stall_from_memorycontroller;
// 
// output reg  [4:0] operand_a;           // für 8-fach Registerfile Bit 3 ignorieren: {operand_a[4], operand_a[3:0]}
// output reg  [4:0] operand_b;
// 
// output reg [31:0] offset_a;
// output reg [31:0] offset_b;
// 
// output reg  [3:0] alu_opcode;
// 
// output reg update_flag_n;
// output reg update_flag_z;
// output reg update_flag_c;
// output reg update_flag_v;
// 
// output reg  [4:0] alu_write_to_reg;
// output reg alu_write_to_reg_enable; 
// output reg  [4:0] memory_write_to_reg;
// output reg memory_write_to_reg_enable;
// 
// output reg  [4:0] memory_store_data_reg;
// output reg  [4:0] memory_store_address_reg;
// output reg memory_address_source_is_reg;
// output reg  [1:0] load_store_width;
// output reg memorycontroller_sign_extend;
// 
// output reg memory_load_request;
// output reg memory_store_request;
// 
// output reg stack_push_request;
// output reg stack_pop_request;
// 
// output reg stall_to_instructionfetch;
// 
// output wire decoder_pc_update;
// 
// reg [7:0] step;                      // default all 1 !


// ARM-Thumb-Opcodes

// Format 1 und 2
`define       FORMAT_1_2          16'b000?_????_????_????  // 5.1, 5.2

`define       F1_LSL       2'b00      
`define       F1_LSR       2'b01
`define       F1_ASR       2'b10
`define       FORMAT_2     2'b11

`define       F2_ADD       1'b0      
`define       F2_SUB       1'b1

`define       F2_REG_OP    1'b0      
`define       F2_IMM_OP    1'b1

// Format 3
`define       FORMAT_3          16'b001?_????_????_????  // 5.3

`define       F3_MOV       2'b00      
`define       F3_CMP       2'b01
`define       F3_ADD       2'b10
`define       F3_SUB       2'b11

// Format 4
`define       FORMAT_4          16'b0100_00??_????_????  // 5.4

`define       F4_AND       4'b0000      
`define       F4_EOR       4'b0001
`define       F4_LSL       4'b0010
`define       F4_LSR       4'b0011
`define       F4_ASR       4'b0100      
`define       F4_ADC       4'b0101
`define       F4_SBC       4'b0110
`define       F4_ROR       4'b0111
`define       F4_TST       4'b1000      
`define       F4_NEG       4'b1001
`define       F4_CMP       4'b1010
`define       F4_CMN       4'b1011
`define       F4_ORR       4'b1100
`define       F4_MUL       4'b1101
`define       F4_BIC       4'b1110
`define       F4_MVN       4'b1111

// Format 5
`define       FORMAT_5          16'b0100_01??_????_????  // 5.5   

`define       F5_ADD       2'b00      
`define       F5_CMP       2'b01
`define       F5_MOV       2'b10
`define       F5_BX        2'b11

`define       F5_BX_RS     1'b0 
`define       F5_BX_HS     1'b1 

// Format 6
`define       FORMAT_6          16'b0100_1???_????_????  // 5.6 

// Format 7
`define       FORMAT_7          16'b0101_??0?_????_????  // 5.7 

`define       F7_STORE     1'b0
`define       F7_LOAD      1'b1      

`define       F7_WORD      1'b0      
`define       F7_BYTE      1'b1

// Format 8
`define       FORMAT_8          16'b0101_??1?_????_????  // 5.8 

`define       F8_STORE_HW      2'b00      
`define       F8_LOAD_HW       2'b01
`define       F8_LOAD_SE_B     2'b10
`define       F8_LOAD_SE_HW    2'b11

// Format 9
`define       FORMAT_9          16'b011?_????_????_????  // 5.9

`define       F9_STORE     1'b0
`define       F9_LOAD      1'b1 

`define       F9_WORD      1'b0 
`define       F9_BYTE      1'b1

//Format 10
`define       FORMAT_10         16'b1000_????_????_????  // 5.10

`define       F10_STORE     1'b0
`define       F10_LOAD      1'b1

// Format 11
`define       FORMAT_11         16'b1001_????_????_????  // 5.11

`define       F11_STORE     1'b0
`define       F11_LOAD      1'b1

// Format 12
`define       FORMAT_12         16'b1010_????_????_????  // 5.12

`define       F12_PC        1'b0
`define       F12_SP        1'b1


// Format 13
`define       FORMAT_13         16'b1011_0000_????_????  // 5.13

`define       F12_ADD        1'b0
`define       F12_SUB        1'b1

// Format 14
`define       FORMAT_14         16'b1011_?10?_????_????  // 5.14

`define       F14_PUSH     1'b0
`define       F14_POP      1'b1

// Format 15
`define       FORMAT_15         16'b1100_????_????_????  // 5.15

`define       F15_STORE     1'b0
`define       F15_LOAD      1'b1

// Format 16
`define       FORMAT_16_17      16'b1101_????_????_????  // 5.16 / 5.17

`define       F16_BEQ       4'b0000      
`define       F16_BNE       4'b0001
`define       F16_BCS       4'b0010
`define       F16_BCC       4'b0011
`define       F16_BMI       4'b0100      
`define       F16_BPL       4'b0101
`define       F16_BVS       4'b0110
`define       F16_BVC       4'b0111
`define       F16_BHI       4'b1000      
`define       F16_BLS       4'b1001
`define       F16_BGE       4'b1010
`define       F16_BLT       4'b1011
`define       F16_BGT       4'b1100
`define       F16_BLE       4'b1101
`define       F16_ILLEGAL   4'b1110  // undefined
`define       F17_SWI       4'b1111  // SW-Interrupt, not implemented

// Format 18
`define       FORMAT_18         16'b1110_0???_????_????  // 5.18

// Format 19
`define       FORMAT_19         16'b1111_????_????_????  // 5.19

`define       F19_HIGH     1'b0
`define       F19_LOW      1'b1

// Format 20 // IT-Instruction Seite 416 und NOP
`define       FORMAT_20         16'b1011_1111_????_????  

// Format 21
`define       FORMAT_21         16'b1011_?0?1_????_????

// Format 22
`define       FORMAT_22         16'b1011_1010_????_????

// Format 23
`define       FORMAT_23         16'b1011_0010_????_????




   



   



   







 
