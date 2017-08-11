onerror {resume}
radix define REG_SELECTION {
    "5'b00000" "RF_R0 " -color "orange",
    "5'b00001" "RF_R1 " -color "orange",
    "5'b00010" "RF_R2 " -color "orange",
    "5'b00011" "RF_R3 " -color "orange",
    "5'b00100" "RF_R4 " -color "orange",
    "5'b00101" "RF_R5 " -color "orange",
    "5'b00110" "RF_R6 " -color "orange",
    "5'b00111" "RF_R7 " -color "orange",
    "5'b01000" "RF_R8 " -color "orange",
    "5'b01001" "RF_R9 " -color "orange",
    "5'b01010" "RF_R10" -color "orange",
    "5'b01011" "RF_R11" -color "orange",
    "5'b01100" "RF_R12" -color "orange",
    "5'b01101" "RF_R13_SP" -color "orange",
    "5'b01110" "RF_R14_LR" -color "orange",
    "5'b01111" "RF_R15_PC" -color "orange",
    "5'b10000" "RF_UNDEFINED" -color "red",
    "5'b10001" "RF_UNDEFINED" -color "red",
    "5'b10010" "RF_UNDEFINED" -color "red",
    "5'b10011" "RF_UNDEFINED" -color "red",
    "5'b10100" "RF_UNDEFINED" -color "red",
    "5'b10101" "RF_UNDEFINED" -color "red",
    "5'b10110" "RF_UNDEFINED" -color "red",
    "5'b10111" "RF_UNDEFINED" -color "red",
    "5'b11000" "RF_UNDEFINED" -color "red",
    "5'b11001" "RF_UNDEFINED" -color "red",
    "5'b11010" "RF_UNDEFINED" -color "red",
    "5'b11011" "RF_UNDEFINED" -color "red",
    "5'b11100" "RF_UNDEFINED" -color "red",
    "5'b11101" "RF_NONE" -color "blue",
    "5'b11110" "RF_TMP1" -color "orange",
    "5'b11111" "RF_IMM" -color "purple",
    -default default
}
radix define ALU_OPCODE {
    "5'b00000" "ALU_AND" -color "orange",
    "5'b00001" "ALU_EOR" -color "orange",
    "5'b00010" "ALU_LSL" -color "orange",
    "5'b00011" "ALU_LSR" -color "orange",
    "5'b00100" "ALU_ASR" -color "orange",
    "5'b00101" "ALU_ADC" -color "orange",
    "5'b00110" "ALU_SBC" -color "orange",
    "5'b00111" "ALU_ROR" -color "orange",
    "5'b01000" "ALU_TST" -color "orange",
    "5'b01001" "ALU_NEG" -color "orange",
    "5'b01010" "ALU_CMP" -color "orange",
    "5'b01011" "ALU_CMN" -color "orange",
    "5'b01100" "ALU_ORR" -color "orange",
    "5'b01101" "ALU_MUL" -color "orange",
    "5'b01110" "ALU_BIC" -color "orange",
    "5'b01111" "ALU_MVN" -color "orange",
    "5'b10000" "ALU_UNDEFINED" -color "red",
    "5'b10001" "ALU_UNDEFINED" -color "red",
    "5'b10010" "ALU_UNDEFINED" -color "red",
    "5'b10011" "ALU_UNDEFINED" -color "red",
    "5'b10100" "ALU_UNDEFINED" -color "red",
    "5'b10101" "ALU_ADD" -color "orange",
    "5'b10110" "ALU_SUB" -color "orange",
    "5'b10111" "ALU_UNDEFINED" -color "red",
    "5'b11000" "ALU_UNDEFINED" -color "red",
    "5'b11001" "ALU_UNDEFINED" -color "red",
    "5'b11010" "ALU_UNDEFINED" -color "red",
    "5'b11011" "ALU_UNDEFINED" -color "red",
    "5'b11100" "ALU_UNDEFINED" -color "red",
    "5'b11101" "ALU_UNDEFINED" -color "red",
    "5'b11110" "ALU_UNDEFINED" -color "red",
    "5'b11111" "ALU_UNDEFINED" -color "red",
    -default default
}
radix define WIDTH {
    "2'b00" "BYTE    " -color "orange",
    "2'b01" "HALFWORD" -color "orange",
    "2'b10" "WORD    " -color "orange",
    "2'b11" "ILLEGAL " -color "red",
    -default default
}
radix define IF_STATE {
    "2'b00" "RESET       " -color "blue",
    "2'b01" "WAIT_FOR_DEC" -color "orange",
    "2'b10" "FETCH       " -color "orange",
    "2'b11" "FINISHED    " -color "red",
    -default default
}
radix define IF_STATE_V3 {
    "3'b000" "RESET       " -color "blue",
    "3'b001" "WAIT_FOR_DEC" -color "orange",
    "3'b010" "FETCH1      " -color "orange",
    "3'b011" "FETCH2      " -color "orange",
    "3'b000" "ILLEGAL     " -color "red",
    "3'b001" "ILLEGAL     " -color "red",
    "3'b010" "ILLEGAL     " -color "red",
    "3'b111" "FINISHED    " -color "purple",
    -default default
}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench_count32/clock
add wave -noupdate /testbench_count32/reset
add wave -noupdate /testbench_count32/MEM_MEMCTRL_from_mem_data
add wave -noupdate /testbench_count32/MEMCTRL_MEM_to_mem_read_enable
add wave -noupdate /testbench_count32/MEMCTRL_MEM_to_mem_write_enable
add wave -noupdate /testbench_count32/MEMCTRL_MEM_to_mem_mem_enable
add wave -noupdate -radix unsigned /testbench_count32/MEMCTRL_MEM_to_mem_address
add wave -noupdate /testbench_count32/MEMCTRL_MEM_to_mem_data
add wave -noupdate /testbench_count32/clock
add wave -noupdate -expand -group Instruction_Fetch /testbench_count32/UUT/Instruction_Fetch_v2_inst1/stall_decoder_in
add wave -noupdate -expand -group Instruction_Fetch /testbench_count32/UUT/Instruction_Fetch_v2_inst1/memory_output_valid
add wave -noupdate -expand -group Instruction_Fetch /testbench_count32/UUT/Instruction_Fetch_v2_inst1/memory_output_valid
add wave -noupdate -expand -group Instruction_Fetch /testbench_count32/UUT/Instruction_Fetch_v2_inst1/current_pc_in
add wave -noupdate -expand -group Instruction_Fetch /testbench_count32/UUT/Instruction_Fetch_v2_inst1/instruction_in
add wave -noupdate -expand -group Instruction_Fetch /testbench_count32/UUT/Instruction_Fetch_v2_inst1/memory_load_request
add wave -noupdate -expand -group Instruction_Fetch /testbench_count32/UUT/Instruction_Fetch_v2_inst1/incremented_pc_write_enable
add wave -noupdate -expand -group Instruction_Fetch /testbench_count32/UUT/Instruction_Fetch_v2_inst1/instruction_valid
add wave -noupdate -expand -group Instruction_Fetch -radix decimal /testbench_count32/UUT/Instruction_Fetch_v2_inst1/memory_address
add wave -noupdate -expand -group Instruction_Fetch /testbench_count32/UUT/Instruction_Fetch_v2_inst1/incremented_pc_out
add wave -noupdate -expand -group Instruction_Fetch /testbench_count32/UUT/Instruction_Fetch_v2_inst1/instruction_out
add wave -noupdate -expand -group Instruction_Fetch -radix IF_STATE /testbench_count32/UUT/Instruction_Fetch_v2_inst1/currentState
add wave -noupdate -expand -group Instruction_Fetch -radix IF_STATE /testbench_count32/UUT/Instruction_Fetch_v2_inst1/nextState
add wave -noupdate -expand -group Instruction_Fetch /testbench_count32/UUT/Instruction_Fetch_v2_inst1/finish_out
add wave -noupdate /testbench_count32/clock
add wave -noupdate -expand -group Instruction_Decoder -radix binary /testbench_count32/UUT/irdecode_inst1/state
add wave -noupdate -expand -group Instruction_Decoder -radix binary /testbench_count32/UUT/irdecode_inst1/next_state
add wave -noupdate -expand -group Instruction_Decoder /testbench_count32/UUT/irdecode_inst1/instruction
add wave -noupdate -expand -group Instruction_Decoder /testbench_count32/UUT/irdecode_inst1/instruction_valid
add wave -noupdate -expand -group Instruction_Decoder /testbench_count32/UUT/irdecode_inst1/stall_to_instructionfetch
add wave -noupdate -expand -group Instruction_Decoder /testbench_count32/UUT/irdecode_inst1/split_instruction
add wave -noupdate -expand -group Instruction_Decoder -radix binary /testbench_count32/UUT/irdecode_inst1/itstate
add wave -noupdate -expand -group Instruction_Decoder -radix binary /testbench_count32/UUT/irdecode_inst1/step
add wave -noupdate -expand -group Instruction_Decoder /testbench_count32/UUT/irdecode_inst1/exec_cond_true
add wave -noupdate -expand -group Instruction_Decoder /testbench_count32/UUT/irdecode_inst1/flag_n
add wave -noupdate -expand -group Instruction_Decoder /testbench_count32/UUT/irdecode_inst1/flag_z
add wave -noupdate -expand -group Instruction_Decoder /testbench_count32/UUT/irdecode_inst1/flag_c
add wave -noupdate -expand -group Instruction_Decoder /testbench_count32/UUT/irdecode_inst1/flag_v
add wave -noupdate -expand -group Instruction_Decoder /testbench_count32/UUT/irdecode_inst1/memory_write_finished
add wave -noupdate -expand -group Instruction_Decoder /testbench_count32/UUT/irdecode_inst1/memory_read_finished
add wave -noupdate -expand -group Instruction_Decoder -radix REG_SELECTION /testbench_count32/UUT/irdecode_inst1/operand_a
add wave -noupdate -expand -group Instruction_Decoder -radix REG_SELECTION /testbench_count32/UUT/irdecode_inst1/operand_b
add wave -noupdate -expand -group Instruction_Decoder -radix decimal /testbench_count32/UUT/irdecode_inst1/offset_a
add wave -noupdate -expand -group Instruction_Decoder -radix decimal /testbench_count32/UUT/irdecode_inst1/offset_b
add wave -noupdate -expand -group Instruction_Decoder -radix ALU_OPCODE /testbench_count32/UUT/irdecode_inst1/alu_opcode
add wave -noupdate -expand -group Instruction_Decoder /testbench_count32/UUT/irdecode_inst1/pc_mask_bit
add wave -noupdate -expand -group Instruction_Decoder /testbench_count32/UUT/irdecode_inst1/update_flag_n
add wave -noupdate -expand -group Instruction_Decoder /testbench_count32/UUT/irdecode_inst1/update_flag_z
add wave -noupdate -expand -group Instruction_Decoder /testbench_count32/UUT/irdecode_inst1/update_flag_c
add wave -noupdate -expand -group Instruction_Decoder /testbench_count32/UUT/irdecode_inst1/update_flag_v
add wave -noupdate -expand -group Instruction_Decoder -radix REG_SELECTION /testbench_count32/UUT/irdecode_inst1/alu_write_to_reg
add wave -noupdate -expand -group Instruction_Decoder /testbench_count32/UUT/irdecode_inst1/alu_write_to_reg_enable
add wave -noupdate -expand -group Instruction_Decoder -radix REG_SELECTION /testbench_count32/UUT/irdecode_inst1/memory_write_to_reg
add wave -noupdate -expand -group Instruction_Decoder /testbench_count32/UUT/irdecode_inst1/memory_write_to_reg_enable
add wave -noupdate -expand -group Instruction_Decoder -radix REG_SELECTION /testbench_count32/UUT/irdecode_inst1/memory_store_data_reg
add wave -noupdate -expand -group Instruction_Decoder -radix REG_SELECTION /testbench_count32/UUT/irdecode_inst1/memory_store_address_reg
add wave -noupdate -expand -group Instruction_Decoder /testbench_count32/UUT/irdecode_inst1/memory_address_source_is_reg
add wave -noupdate -expand -group Instruction_Decoder -radix WIDTH /testbench_count32/UUT/irdecode_inst1/load_store_width
add wave -noupdate -expand -group Instruction_Decoder /testbench_count32/UUT/irdecode_inst1/memorycontroller_sign_extend
add wave -noupdate -expand -group Instruction_Decoder /testbench_count32/UUT/irdecode_inst1/memory_load_request
add wave -noupdate -expand -group Instruction_Decoder /testbench_count32/UUT/irdecode_inst1/memory_store_request
add wave -noupdate /testbench_count32/clock
add wave -noupdate -expand -group Registers -radix decimal /testbench_count32/UUT/register_file_v2_inst1/r0
add wave -noupdate -expand -group Registers -radix decimal /testbench_count32/UUT/register_file_v2_inst1/r1
add wave -noupdate -expand -group Registers -radix decimal /testbench_count32/UUT/register_file_v2_inst1/r2
add wave -noupdate -expand -group Registers -radix decimal /testbench_count32/UUT/register_file_v2_inst1/r3
add wave -noupdate -expand -group Registers -radix decimal /testbench_count32/UUT/register_file_v2_inst1/r4
add wave -noupdate -expand -group Registers -radix decimal /testbench_count32/UUT/register_file_v2_inst1/r5
add wave -noupdate -expand -group Registers -radix decimal /testbench_count32/UUT/register_file_v2_inst1/r6
add wave -noupdate -expand -group Registers -radix decimal /testbench_count32/UUT/register_file_v2_inst1/r7
add wave -noupdate -expand -group Registers -radix decimal /testbench_count32/UUT/register_file_v2_inst1/r8
add wave -noupdate -expand -group Registers -radix decimal /testbench_count32/UUT/register_file_v2_inst1/r9
add wave -noupdate -expand -group Registers -radix decimal /testbench_count32/UUT/register_file_v2_inst1/r10
add wave -noupdate -expand -group Registers -radix decimal /testbench_count32/UUT/register_file_v2_inst1/r11
add wave -noupdate -expand -group Registers -radix decimal /testbench_count32/UUT/register_file_v2_inst1/r12
add wave -noupdate -expand -group Registers -radix decimal /testbench_count32/UUT/register_file_v2_inst1/lr
add wave -noupdate -expand -group Registers -radix decimal /testbench_count32/UUT/register_file_v2_inst1/sp
add wave -noupdate -expand -group Registers -radix decimal /testbench_count32/UUT/register_file_v2_inst1/pc
add wave -noupdate -expand -group Registers -radix decimal /testbench_count32/UUT/register_file_v2_inst1/cpsr
add wave -noupdate -expand -group Registers -radix decimal /testbench_count32/UUT/register_file_v2_inst1/tmp1
add wave -noupdate -expand -group Memory_Interface -radix binary /testbench_count32/UUT/memory_interface_simple_inst1/state
add wave -noupdate -expand -group Memory_Interface -radix binary /testbench_count32/UUT/memory_interface_simple_inst1/next_state
add wave -noupdate -expand -group Memory_Interface /testbench_count32/UUT/memory_interface_simple_inst1/interface_cpu_sign_extend
add wave -noupdate -expand -group Memory_Interface -radix WIDTH /testbench_count32/UUT/memory_interface_simple_inst1/interface_cpu_word_type
add wave -noupdate -expand -group Memory_Interface /testbench_count32/UUT/memory_interface_simple_inst1/interface_cpu_load_request
add wave -noupdate -expand -group Memory_Interface /testbench_count32/UUT/memory_interface_simple_inst1/interface_cpu_store_request
add wave -noupdate -expand -group Memory_Interface -radix unsigned /testbench_count32/UUT/memory_interface_simple_inst1/interface_cpu_address_in
add wave -noupdate -expand -group Memory_Interface -radix decimal /testbench_count32/UUT/memory_interface_simple_inst1/interface_cpu_data_in
add wave -noupdate -expand -group Memory_Interface -radix decimal /testbench_count32/UUT/memory_interface_simple_inst1/from_mem_data_out
add wave -noupdate -expand -group Memory_Interface /testbench_count32/UUT/memory_interface_simple_inst1/interface_cpu_read_finished
add wave -noupdate -expand -group Memory_Interface /testbench_count32/UUT/memory_interface_simple_inst1/interface_cpu_write_finished
add wave -noupdate -expand -group Memory_Interface -radix decimal /testbench_count32/UUT/memory_interface_simple_inst1/interface_cpu_data_out
add wave -noupdate -expand -group Memory_Interface -radix unsigned /testbench_count32/UUT/memory_interface_simple_inst1/to_mem_address
add wave -noupdate -expand -group Memory_Interface -radix decimal /testbench_count32/UUT/memory_interface_simple_inst1/to_mem_data_in
add wave -noupdate -expand -group Memory_Interface /testbench_count32/UUT/memory_interface_simple_inst1/to_mem_read_enable
add wave -noupdate -expand -group Memory_Interface /testbench_count32/UUT/memory_interface_simple_inst1/to_mem_write_enable
add wave -noupdate -expand -group Memory_Interface /testbench_count32/UUT/memory_interface_simple_inst1/to_mem_enable
add wave -noupdate /testbench_count32/memory_i/ram
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {87596 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 448
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {21673 ps}
