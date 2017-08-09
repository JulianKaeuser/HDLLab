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
    "5'b10000" "ALU_ADD" -color "orange",
    "5'b10001" "ALU_SUB" -color "orange",
    "5'b10010" "ALU_UNDEFINED" -color "red",
    "5'b10011" "ALU_UNDEFINED" -color "red",
    "5'b10100" "ALU_UNDEFINED" -color "red",
    "5'b10101" "ALU_UNDEFINED" -color "red",
    "5'b10110" "ALU_UNDEFINED" -color "red",
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
add wave -noupdate /testbench2/clock
add wave -noupdate /testbench2/reset
add wave -noupdate /testbench2/instruction
add wave -noupdate -radix binary /testbench2/UUT/itstate
add wave -noupdate /testbench2/UUT/exec_cond_true
add wave -noupdate -radix binary /testbench2/UUT/step
add wave -noupdate /testbench2/flag_z
add wave -noupdate /testbench2/flag_c
add wave -noupdate /testbench2/flag_n
add wave -noupdate /testbench2/flag_v
add wave -noupdate /testbench2/stall_from_instructionfetch
add wave -noupdate /testbench2/stall_from_memorycontroller
add wave -noupdate -radix REG_SELECTION /testbench2/operand_a
add wave -noupdate -radix REG_SELECTION /testbench2/operand_b
add wave -noupdate -radix decimal /testbench2/offset_a
add wave -noupdate -radix decimal /testbench2/offset_b
add wave -noupdate -radix ALU_OPCODE -childformat {{{/testbench2/alu_opcode[4]} -radix ALU_OPCODE} {{/testbench2/alu_opcode[3]} -radix ALU_OPCODE} {{/testbench2/alu_opcode[2]} -radix ALU_OPCODE} {{/testbench2/alu_opcode[1]} -radix ALU_OPCODE} {{/testbench2/alu_opcode[0]} -radix ALU_OPCODE}} -subitemconfig {{/testbench2/alu_opcode[4]} {-height 16 -radix ALU_OPCODE} {/testbench2/alu_opcode[3]} {-height 16 -radix ALU_OPCODE} {/testbench2/alu_opcode[2]} {-height 16 -radix ALU_OPCODE} {/testbench2/alu_opcode[1]} {-height 16 -radix ALU_OPCODE} {/testbench2/alu_opcode[0]} {-height 16 -radix ALU_OPCODE}} /testbench2/alu_opcode
add wave -noupdate /testbench2/update_flag_n
add wave -noupdate /testbench2/update_flag_z
add wave -noupdate /testbench2/update_flag_c
add wave -noupdate /testbench2/update_flag_v
add wave -noupdate -radix REG_SELECTION /testbench2/alu_write_to_reg
add wave -noupdate /testbench2/alu_write_to_reg_enable
add wave -noupdate -radix REG_SELECTION /testbench2/memory_write_to_reg
add wave -noupdate -radix decimal /testbench2/memory_write_to_reg_enable
add wave -noupdate -radix REG_SELECTION /testbench2/memory_store_data_reg
add wave -noupdate -radix REG_SELECTION /testbench2/memory_store_address_reg
add wave -noupdate /testbench2/memory_address_source_is_reg
add wave -noupdate -radix WIDTH /testbench2/load_store_width
add wave -noupdate /testbench2/memorycontroller_sign_extend
add wave -noupdate /testbench2/memory_load_request
add wave -noupdate /testbench2/memory_store_request
add wave -noupdate /testbench2/stack_push_request
add wave -noupdate /testbench2/stack_pop_request
add wave -noupdate /testbench2/stall_to_instructionfetch
add wave -noupdate /testbench2/decoder_pc_update
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {32844 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 293
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
WaveRestoreZoom {10590 ps} {165002 ps}
