onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench_count32/status
add wave -noupdate /testbench_count32/MEM_MEMCTRL_from_mem_data
add wave -noupdate /testbench_count32/MEMCTRL_MEM_to_mem_read_enable
add wave -noupdate /testbench_count32/MEMCTRL_MEM_to_mem_write_enable
add wave -noupdate /testbench_count32/MEMCTRL_MEM_to_mem_mem_enable
add wave -noupdate /testbench_count32/MEMCTRL_MEM_to_mem_address
add wave -noupdate /testbench_count32/MEMCTRL_MEM_to_mem_data
add wave -noupdate /testbench_count32/clock
add wave -noupdate /testbench_count32/reset
add wave -noupdate /testbench_count32/memory_i/ram
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {1 ns}
