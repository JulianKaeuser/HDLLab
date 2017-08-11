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
add wave -noupdate /testbench/mem_iface/fsm/state
add wave -noupdate /testbench/mem_iface/fsm/nextstate
add wave -noupdate /testbench/memory_i/en
add wave -noupdate /testbench/memory_i/rd_en
add wave -noupdate /testbench/memory_i/wr_en
add wave -noupdate /testbench/memory_i/din
add wave -noupdate /testbench/memory_i/dout
add wave -noupdate /testbench/memory_i/addr
add wave -noupdate /testbench/memory_i/clk
add wave -noupdate /testbench/memory_i/en
add wave -noupdate /testbench/memory_i/rd_en
add wave -noupdate /testbench/memory_i/wr_en
add wave -noupdate /testbench/memory_i/din
add wave -noupdate /testbench/memory_i/dout
add wave -noupdate /testbench/memory_i/addr
add wave -noupdate /testbench/memory_i/wr_halfword
add wave -noupdate /testbench/memory_i/wr_i
add wave -noupdate /testbench/file
add wave -noupdate /testbench/status
add wave -noupdate /testbench/clk
add wave -noupdate /testbench/rst
add wave -noupdate /testbench/en
add wave -noupdate /testbench/rd_en
add wave -noupdate /testbench/wr_en
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
add wave -noupdate /testbench/memory_i/addr
add wave -noupdate /testbench/memory_i/wr_en
add wave -noupdate /testbench/memory_i/rd_en
add wave -noupdate /testbench/memory_i/dout
add wave -noupdate -expand /testbench/memory_i/ram
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {26248 ps} 0} {{Cursor 2} {41402 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 271
configure wave -valuecolwidth 215
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
WaveRestoreZoom {17385 ps} {30835 ps}
