onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/clk
add wave -noupdate /testbench/rst
add wave -noupdate /testbench/data_cpu2mem
add wave -noupdate /testbench/data_mem2cpu
add wave -noupdate /testbench/addr_cpu2mem
add wave -noupdate /testbench/write_ready
add wave -noupdate /testbench/busy
add wave -noupdate /testbench/output_valid
add wave -noupdate /testbench/load
add wave -noupdate /testbench/store
add wave -noupdate /testbench/is_signed
add wave -noupdate /testbench/word_type
add wave -noupdate /testbench/addr_input
add wave -noupdate /testbench/data_input
add wave -noupdate /testbench/data_output
add wave -noupdate /testbench/memory_i/din
add wave -noupdate /testbench/memory_i/dout
add wave -noupdate /testbench/memory_i/addr
add wave -noupdate /testbench/mem_iface/address
add wave -noupdate /testbench/mem_iface/data_in
add wave -noupdate /testbench/mem_iface/data_out
add wave -noupdate /testbench/mem_iface/mem_data_in
add wave -noupdate /testbench/mem_iface/mem_data_out
add wave -noupdate /testbench/mem_iface/mem_write_enable
add wave -noupdate /testbench/mem_iface/mem_enable
add wave -noupdate /testbench/mem_iface/mem_read_enable
add wave -noupdate /testbench/mem_iface/fsm/state
add wave -noupdate /testbench/mem_iface/fsm/nextstate
add wave -noupdate /testbench/mem_iface/address
add wave -noupdate /testbench/mem_iface/data_in
add wave -noupdate /testbench/mem_iface/load
add wave -noupdate /testbench/mem_iface/store
add wave -noupdate /testbench/mem_iface/clk
add wave -noupdate /testbench/mem_iface/reset
add wave -noupdate /testbench/mem_iface/is_signed
add wave -noupdate /testbench/mem_iface/word_type
add wave -noupdate /testbench/mem_iface/from_mem_data
add wave -noupdate /testbench/mem_iface/to_mem_read_enable
add wave -noupdate /testbench/mem_iface/to_mem_write_enable
add wave -noupdate /testbench/mem_iface/to_mem_mem_enable
add wave -noupdate /testbench/mem_iface/to_mem_address
add wave -noupdate /testbench/mem_iface/to_mem_data
add wave -noupdate /testbench/mem_iface/data_out
add wave -noupdate /testbench/mem_iface/write_ready
add wave -noupdate /testbench/mem_iface/output_valid
add wave -noupdate /testbench/mem_iface/busy
add wave -noupdate /testbench/mem_iface/direct_or_delayed_din
add wave -noupdate /testbench/mem_iface/added_or_delayed_address
add wave -noupdate /testbench/mem_iface/modified_or_original_address
add wave -noupdate /testbench/mem_iface/old_or_new_byte_remainder
add wave -noupdate /testbench/mem_iface/first_two_bytes_out_select
add wave -noupdate /testbench/mem_iface/third_byte_out_select
add wave -noupdate /testbench/mem_iface/delay_addr_for_adder
add wave -noupdate /testbench/mem_iface/delay_addr_single
add wave -noupdate /testbench/mem_iface/delay_data_in32
add wave -noupdate /testbench/mem_iface/delay_first_two_bytes_out
add wave -noupdate /testbench/mem_iface/mem_addr_in
add wave -noupdate /testbench/mem_iface/mem_data_in
add wave -noupdate /testbench/mem_iface/mem_data_out
add wave -noupdate /testbench/mem_iface/mem_write_enable
add wave -noupdate /testbench/mem_iface/mem_enable
add wave -noupdate /testbench/mem_iface/mem_read_enable
add wave -noupdate /testbench/mem_iface/mem_control_reset
add wave -noupdate /testbench/mem_iface/modified_address
add wave -noupdate /testbench/mem_iface/data_bus_to_mem
add wave -noupdate /testbench/mem_iface/direct_data_in16
add wave -noupdate /testbench/mem_iface/delayed_data_in16
add wave -noupdate /testbench/mem_iface/third_byte_out
add wave -noupdate /testbench/mem_iface/first_two_bytes_out
add wave -noupdate /testbench/mem_iface/sign_extended_third_byte
add wave -noupdate /testbench/mem_iface/sign_extension_byte
add wave -noupdate /testbench/mem_iface/sign_b_extension
add wave -noupdate /testbench/mem_iface/sign_a_extension
add wave -noupdate /testbench/mem_iface/zero_halfword
add wave -noupdate /testbench/mem_iface/fsm_read_control
add wave -noupdate /testbench/mem_iface/fsm_read_out
add wave -noupdate /testbench/mem_iface/fsm_write_out
add wave -noupdate /testbench/mem_iface/fsm_write_control
add wave -noupdate /testbench/mem_iface/w
add wave -noupdate /testbench/mem_iface/r
add wave -noupdate /testbench/mem_iface/word_dep
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9685 ps} 0} {{Cursor 2} {41402 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 363
configure wave -valuecolwidth 94
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
WaveRestoreZoom {6247 ps} {12389 ps}