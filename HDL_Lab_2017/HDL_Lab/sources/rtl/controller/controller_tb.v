`timescale 10ns/1ns

module controller_tb();

reg clk;
reg reset;
reg decoder_load_in;
reg decoder_store_in;
reg fetch_load_in;
//reg fetch_stall2decoder_in;
reg decoder_src_mem_addr_in;
reg mem_output_valid_in;
reg mem_write_ready_in;
wire stall_mem2fetch_out;
wire[1:0] addr_select_out;
wire read_en_sel_out;
wire word_select_out;
wire stall_any2decoder_out;
//wire[1:0] state;

parameter tClock = 2;

controller inst_controller(
.clk(clk),
.reset(reset),
.decoder_load_in(decoder_load_in),
.decoder_store_in(decoder_store_in),
.fetch_load_in(fetch_load_in),
//.fetch_stall2decoder_in(fetch_stall2decoder_in),
.decoder_src_mem_addr_in(decoder_src_mem_addr_in),
.mem_output_valid_in(mem_output_valid_in),
.mem_write_ready_in(mem_write_ready_in),
.stall_mem2fetch_out(stall_mem2fetch_out),
.addr_select_out(addr_select_out),
.read_en_sel_out(read_en_sel_out),
.word_select_out(word_select_out),
.stall_any2decoder_out(stall_any2decoder_out)
//.state(state)
);

always
	#tClock clk = !clk;

initial begin
	//$monitor("state: %b addr_sel_out: %b read_en_select_out: %b word_select_out: %b stall_any2decoder_out: %b", state, addr_select_out, read_en_sel_out, word_select_out, stall_any2decoder_out);
	clk = 0;

	reset = 0;
	
	#2; //Fetch cycle
	decoder_load_in = 0;
	decoder_store_in = 0;
	fetch_load_in = 1;
	decoder_src_mem_addr_in = 0;
	mem_output_valid_in = 0;
	mem_write_ready_in = 0;
	#4;
	mem_output_valid_in = 1;
	#4;
	mem_output_valid_in = 0;
	fetch_load_in = 0;
	#4; // end fetch cycle

	#4; // load decoder cycle
	decoder_load_in = 1;
	decoder_store_in = 0;
	fetch_load_in = 0;
	decoder_src_mem_addr_in = 0;
	mem_output_valid_in = 0;
	mem_write_ready_in = 0;
	#4;
	mem_output_valid_in = 1;
	#4;
	mem_output_valid_in = 0;
	decoder_load_in = 0;
	#4; //end load decoder cycle

	#4; // store decoder cycle
	decoder_load_in = 0;
	decoder_store_in = 1;
	fetch_load_in = 0;
	decoder_src_mem_addr_in = 1;
	mem_output_valid_in = 0;
	mem_write_ready_in = 0;
	#4;
	mem_write_ready_in = 1;
	#4;
	mem_write_ready_in = 0;
	decoder_store_in = 0;
	#4; //store load decoder cycle

	#4; // store decoder cycle + reset
	decoder_load_in = 0;
	decoder_store_in = 1;
	fetch_load_in = 0;
	decoder_src_mem_addr_in = 0;
	mem_output_valid_in = 0;
	mem_write_ready_in = 0;
	#4;
	mem_write_ready_in = 1;
	reset = 1;
	decoder_store_in = 0;
	mem_write_ready_in = 0;
	#8;
	reset = 0;
	#4; //store load decoder cycle + reset

	#4; // store decoder cycle + (fetch cycle)
	decoder_load_in = 0;
	decoder_store_in = 1;
	fetch_load_in = 1;
	decoder_src_mem_addr_in = 1;
	mem_output_valid_in = 0;
	mem_write_ready_in = 0;
	#12;
	mem_write_ready_in = 1;
	#4;
	mem_write_ready_in = 0;
	decoder_store_in = 0;
	#4; //store load decoder cycle + (fetch cycle)
	

end

endmodule