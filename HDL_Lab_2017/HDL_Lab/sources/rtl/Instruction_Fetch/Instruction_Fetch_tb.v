`timescale 10ns/1ns
module Instruction_Fetch_tb();
	reg clk;
	reg reset;
	reg stall_decoder_in;
	reg stall_memory;
	reg[31:0] pc_in;
	reg[15:0] instruction_in;
	wire read_enable;
	wire pc_en;
	wire stall_decoder_out;
	wire[11:0] address;
	wire[31:0] pc_out;
	wire[15:0] instruction_out;
	wire[1:0] currentState;
	wire[1:0] nextState;
	
	parameter tClock = 2;

Instruction_Fetch inst_fetch(.clk(clk), .reset(reset), .stall_decoder_in(stall_decoder_in), .stall_memory(stall_memory), .pc_in(pc_in), .instruction_in(instruction_in),
	.read_enable(read_enable), .pc_en(pc_en), .stall_decoder_out(stall_decoder_out), .address(address), .pc_out(pc_out), .instruction_out(instruction_out)/*, .currentState(currentState), .nextState(nextState)*/);

	always
	#tClock clk = !clk;

	initial begin
	clk = 0;
	
	$monitor("%g\t reset: %b stall_decoder_in: %b stall_memory: %b pc_in: %b instruction_in: %b | read_enable: %b pc_en: %b stall_decoder_out: %b address: %b pc_out: %b instruction_out: %b currentState: %b nextState: %b",
	$time, reset, stall_decoder_in, stall_memory, pc_in, instruction_in, read_enable, pc_en, stall_decoder_out, address, pc_out, instruction_out, currentState, nextState);
	
	reset = 0;
	stall_decoder_in = 0;
	stall_memory = 1;
	pc_in = 32'b0;
	instruction_in = 16'bx;
	#20;
	stall_memory = 0;
	#20;
	stall_memory = 1;
	stall_decoder_in = 1;
	#20;
	stall_memory = 0;
	stall_decoder_in = 0;
	instruction_in = 16'b1010101010101010;
	#20;

	//stall_memory = 1;
	pc_in = 32'b00000000000000000000000000000100;
	#20;
	stall_decoder_in = 0;
	#20;
	stall_memory = 0;
	#2;
	stall_memory = 1;
	#20
	reset = 1;
	#20;
	stall_memory = 0;
	instruction_in = 16'b1010101010101010;
	#20;
	stall_memory = 1;
	pc_in = 32'b00000000000000000000000000001000;
	#20;
	reset = 0;
	
	
	

	end
endmodule