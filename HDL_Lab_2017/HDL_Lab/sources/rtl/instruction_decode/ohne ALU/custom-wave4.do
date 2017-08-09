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
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench4/clock
add wave -noupdate /testbench4/reset
add wave -noupdate /testbench4/UUT/irdecode_inst1/instruction
add wave -noupdate /testbench4/UUT/irdecode_inst1/flag_n
add wave -noupdate /testbench4/UUT/irdecode_inst1/flag_z
add wave -noupdate /testbench4/UUT/irdecode_inst1/flag_c
add wave -noupdate /testbench4/UUT/irdecode_inst1/flag_v
add wave -noupdate /testbench4/UUT/irdecode_inst1/stall_from_instructionfetch
add wave -noupdate /testbench4/UUT/irdecode_inst1/stall_from_memorycontroller
add wave -noupdate -radix REG_SELECTION /testbench4/UUT/irdecode_inst1/operand_a
add wave -noupdate -radix REG_SELECTION /testbench4/UUT/irdecode_inst1/operand_b
add wave -noupdate -radix decimal /testbench4/UUT/irdecode_inst1/offset_a
add wave -noupdate -radix decimal /testbench4/UUT/irdecode_inst1/offset_b
add wave -noupdate -radix ALU_OPCODE /testbench4/UUT/irdecode_inst1/alu_opcode
add wave -noupdate /testbench4/UUT/irdecode_inst1/update_flag_n
add wave -noupdate /testbench4/UUT/irdecode_inst1/update_flag_z
add wave -noupdate /testbench4/UUT/irdecode_inst1/update_flag_c
add wave -noupdate /testbench4/UUT/irdecode_inst1/update_flag_v
add wave -noupdate -radix REG_SELECTION /testbench4/UUT/irdecode_inst1/alu_write_to_reg
add wave -noupdate /testbench4/UUT/irdecode_inst1/alu_write_to_reg_enable
add wave -noupdate -radix REG_SELECTION /testbench4/UUT/irdecode_inst1/memory_write_to_reg
add wave -noupdate /testbench4/UUT/irdecode_inst1/memory_write_to_reg_enable
add wave -noupdate -radix REG_SELECTION /testbench4/UUT/irdecode_inst1/memory_store_data_reg
add wave -noupdate -radix REG_SELECTION /testbench4/UUT/irdecode_inst1/memory_store_address_reg
add wave -noupdate /testbench4/UUT/irdecode_inst1/memory_address_source_is_reg
add wave -noupdate -radix WIDTH /testbench4/UUT/irdecode_inst1/load_store_width
add wave -noupdate /testbench4/UUT/irdecode_inst1/memorycontroller_sign_extend
add wave -noupdate /testbench4/UUT/irdecode_inst1/memory_load_request
add wave -noupdate /testbench4/UUT/irdecode_inst1/memory_store_request
add wave -noupdate /testbench4/UUT/irdecode_inst1/stack_push_request
add wave -noupdate /testbench4/UUT/irdecode_inst1/stack_pop_request
add wave -noupdate /testbench4/UUT/irdecode_inst1/stall_to_instructionfetch
add wave -noupdate /testbench4/UUT/irdecode_inst1/decoder_pc_update
add wave -noupdate -radix binary /testbench4/UUT/irdecode_inst1/step
add wave -noupdate -radix binary /testbench4/UUT/irdecode_inst1/itstate
add wave -noupdate /testbench4/UUT/irdecode_inst1/exec_cond_true
add wave -noupdate /testbench4/MEMCTRL_IN_address
add wave -noupdate -radix decimal /testbench4/RF_MEMCTRL_data_reg
add wave -noupdate -radix decimal /testbench4/MEMCTRL_RF_data_in
add wave -noupdate -radix decimal /testbench4/RF_pc_out
add wave -noupdate -radix decimal /testbench4/RF_sp_out
add wave -noupdate -radix decimal /testbench4/UUT/register_file_inst1/r0
add wave -noupdate -radix decimal /testbench4/UUT/register_file_inst1/r1
add wave -noupdate -radix decimal /testbench4/UUT/register_file_inst1/r2
add wave -noupdate -radix decimal /testbench4/UUT/register_file_inst1/r3
add wave -noupdate -radix decimal /testbench4/UUT/register_file_inst1/r4
add wave -noupdate -radix decimal /testbench4/UUT/register_file_inst1/r5
add wave -noupdate -radix decimal /testbench4/UUT/register_file_inst1/r6
add wave -noupdate -radix decimal /testbench4/UUT/register_file_inst1/r7
add wave -noupdate -radix decimal /testbench4/UUT/register_file_inst1/r8
add wave -noupdate -radix decimal /testbench4/UUT/register_file_inst1/r9
add wave -noupdate -radix decimal /testbench4/UUT/register_file_inst1/r10
add wave -noupdate -radix decimal /testbench4/UUT/register_file_inst1/r11
add wave -noupdate -radix decimal /testbench4/UUT/register_file_inst1/r12
add wave -noupdate -radix decimal /testbench4/UUT/register_file_inst1/lr
add wave -noupdate -radix decimal /testbench4/UUT/register_file_inst1/sp
add wave -noupdate -radix decimal /testbench4/UUT/register_file_inst1/pc
add wave -noupdate -radix binary /testbench4/UUT/register_file_inst1/cpsr
add wave -noupdate -radix decimal /testbench4/UUT/register_file_inst1/tmp1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {84 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 325
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ns} {183 ns}
