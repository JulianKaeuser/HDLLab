`timescale 10ns/1ns
`define BIT_SIZE 32

module STACK_tb();

reg clk;
reg reset;
reg push_enable;
reg pop_enable;
reg[`BIT_SIZE-1:0] data_in;
reg[`BIT_SIZE-1:0] sp_in;
wire[`BIT_SIZE-1:0] data_out;
wire[`BIT_SIZE-1:0] sp_out;

parameter tClock = 1;

STACK Stack_inst(.clk(clk), .reset(reset), .push_enable(push_enable), .pop_enable(pop_enable), .data_in(data_in), .sp_in(sp_in), .data_out(data_out), .sp_out(sp_out));

always
	#tClock clk = !clk;

initial begin
	clk = 0;
	//$monitor("%g\t clk: %b reset: %b push_enable: %b pop_enable: %b data_in: %b | data_out: %b", $time, clk, reset, push_enable, pop_enable, data_in, data_out);

	reset = 1'b0;
	push_enable = 1'b0;
	pop_enable = 1'b0;
	sp_in = {`BIT_SIZE{1'b0}};
	data_in = {`BIT_SIZE{1'bx}};
	#5;
	data_in = {`BIT_SIZE/2{2'b01}};
	#1;
	push_enable = 1'b1;
	#4;
	pop_enable = 1'b1;
	#4;
	push_enable = 1'b1;
	data_in = {`BIT_SIZE{1'b1}};
	#5;
	data_in = {`BIT_SIZE/2{2'b10}};
	#1;
	push_enable = 1'b1;
	#4;
	pop_enable = 1'b1;
	#4;
	push_enable = 1'b1;
	data_in = {`BIT_SIZE{1'b0}};
	#3;
	push_enable = 1'b1;
	data_in = {`BIT_SIZE/4{4'b1001}};
	#4;
	push_enable = 1'b1;
	data_in = {`BIT_SIZE{1'b1}};
	reset = 1'b1;
	#4;
	reset = 0'b0;
	#2;
	//pop_enable = 1'b1;
	#6;
	push_enable = 1'b1;
	data_in = {`BIT_SIZE/4{4'b0110}};
	#3;


end

always@(sp_out) begin
	#1 sp_in <= sp_out;
end

always@(posedge push_enable) begin
	#1 push_enable <= 1'b0;
end

always@(posedge pop_enable) begin
	#1 pop_enable <= 1'b0;
end

endmodule
