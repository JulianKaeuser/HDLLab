// Integrated Electronic Systems Lab
// TU Darmstadt
// Author:	Dipl.-Ing. Boris Traskov
// Modified by M.Sc. Haoyuan Ying Dual 8-bit Memory Port -> Single 16-bit
// Modified by Group06/Julian Käuser, Wed 08/03/2017
// Email: 	boris.traskov@ies.tu-darmstadt.de

// ATTENTION: This version is there to test the memory interface, NOT the processor. look at the right folder!


`timescale 1 ns / 1 ps

module testbench();

// PARAMETERS
parameter MEM_DEPTH   		= 2**12;	//8192 Bytes 4096*2B
parameter ADDR_WIDTH   		= $clog2(MEM_DEPTH);
parameter string filename	= "sources/software/count32.bin";

// memory access codes
localparam WORD     =2'b10;
localparam HALFWORD =2'b01;
localparam BYTE     =2'b00;

// INTERNAL SIGNALS
integer file, status; // needed for file-io
logic			clk;
logic			rst;
logic			en;
logic			rd_en;
logic  	  wr_en;
logic [15:0]	data_cpu2mem;
logic [15:0]	data_mem2cpu;
logic [ADDR_WIDTH-1:0] addr_cpu2mem;

//assign en		= 1'b1;
//assign rd_en	= 1'b1;
//assign wr_en	= 1'b0;

logic write_ready;
logic busy;
logic output_valid;
logic load;
logic store;
logic is_signed;
logic [1:0] word_type;
logic [ADDR_WIDTH-1:0] addr_input;
logic [31:0] data_input;
logic [31:0] data_output;






// MODULE INSTANTIATION
memory #(
	.MEM_DEPTH (MEM_DEPTH))
memory_i (
   	.clk 	(clk),
    .addr	(addr_cpu2mem),
    .en  	(en),
    .rd_en  (rd_en),
    .wr_en  (wr_en),
    .din (data_cpu2mem),
    .dout(data_mem2cpu));

	memory_interface mem_iface (
		.address(addr_input),
	  .data_in(data_input),
	  .load(load),
	  .store(store),
	  .clk(clk),
	  .reset(rst),
	  .is_signed(is_signed),
	  .word_type(word_type),
	  .from_mem_data(data_mem2cpu),
	  .to_mem_read_enable(rd_en),
	  .to_mem_write_enable(wr_en),
	  .to_mem_mem_enable(en),
	  .to_mem_address(addr_cpu2mem),
	  .to_mem_data(data_output),
	  .data_out(data_mem2cpu),
	  .write_ready(write_ready),
	  .output_valid(output_valid),
	  .busy(busy)
		);
//CLOCK GENERATOR
initial begin
	clk = 1'b0;
	forever #1  clk = !clk;
end

//RESET GENERATOR & TESTS
initial begin
	rst			= 1'b0;
	file		= $fopen(filename, "r");
	#3 rst		= 1'b1;     // 3   ns
	status		= $fread(memory_i.ram, file);
	#2.1 rst	= 1'b0;  //2.1 ns


// do the tests


// check something
// 0
#2;
rst 				 = 0;
data_input   = 32'h00000000;
addr_input   = 12'h000;
load 				 = 1;
store				 = 0;
is_signed    = 0;
word_type    = HALFWORD;

// check something
// 1
#2;
rst 				 = 0;
data_input   = 32'h00000000;
addr_input   = 12'h000;
load 				 = 1;
store				 = 0;
is_signed    = 1;
word_type    = HALFWORD;

// store deadbeef halfword at 12'heee
// 2
#2;
rst 				 = 0;
data_input   = 32'hdeadbeef;
addr_input   = 12'heee;
load 				 = 0;
store				 = 1;
is_signed    = 1;
word_type    = HALFWORD;

// check something
// 3
#2;
rst 				 = 0;
data_input   = 32'h00000000;
addr_input   = 12'h000;
load 				 = 0;
store				 = 1;
is_signed    = 1;
word_type    = HALFWORD;

// do nothing
// 4
#2;
rst 				 = 0;
data_input   = 32'h00000000;
addr_input   = 12'h000;
load 				 = 0;
store				 = 0;
is_signed    = 1;
word_type    = HALFWORD;

// do nothing
// 5
#2;
rst 				 = 0;
data_input   = 32'h00000000;
addr_input   = 12'h000;
load 				 = 0;
store				 = 0;
is_signed    = 1;
word_type    = HALFWORD;

// load halfword from eee, signed
// 6
#2;
rst 				 = 0;
data_input   = 32'h00000000;
addr_input   = 12'heee;
load 				 = 1;
store				 = 0;
is_signed    = 1;
word_type    = HALFWORD;

// do nothing
// 7
#2;
rst 				 = 0;
data_input   = 32'h00000000;
addr_input   = 12'h000;
load 				 = 0;
store				 = 0;
is_signed    = 1;
word_type    = HALFWORD;

// load word from 12'heed
// 8
#2;
rst 				 = 0;
data_input   = 32'h00000000;
addr_input   = 12'heed;
load 				 = 1;
store				 = 0;
is_signed    = 1;
word_type    = WORD;

// do nothing
// 9
#2;
rst 				 = 0;
data_input   = 32'h00000000;
addr_input   = 12'h000;
load 				 = 0;
store				 = 0;
is_signed    = 1;
word_type    = WORD;

// do nothing
// 10
#2;
rst 				 = 0;
data_input   = 32'h00000000;
addr_input   = 12'h000;
load 				 = 0;
store				 = 0;
is_signed    = 1;
word_type    = WORD;

// store byte
// 11
#2;
rst 				 = 0;
data_input   = 32'h000000aa;
addr_input   = 12'heee;
load 				 = 0;
store				 = 1;
is_signed    = 1;
word_type    = BYTE;

// store byte
// 12
#2;
rst 				 = 0;
data_input   = 32'h000000aa;
addr_input   = 12'heee;
load 				 = 0;
store				 = 1;
is_signed    = 1;
word_type    = BYTE;

// store byte
// 13
#2;
rst 				 = 0;
data_input   = 32'h000000aa;
addr_input   = 12'heee;
load 				 = 0;
store				 = 1;
is_signed    = 1;
word_type    = BYTE;

// load byte signed
// 14
#2;
rst 				 = 0;
data_input   = 32'h00000000;
addr_input   = 12'heee;
load 				 = 1;
store				 = 0;
is_signed    = 1;
word_type    = BYTE;

// load byte signed
// 15
#2;
rst 				 = 0;
data_input   = 32'h00000000;
addr_input   = 12'heee;
load 				 = 1;
store				 = 0;
is_signed    = 1;
word_type    = BYTE;

// load byte unsigned
// 16
#2;
rst 				 = 0;
data_input   = 32'h00000000;
addr_input   = 12'heee;
load 				 = 1;
store				 = 0;
is_signed    = 0;
word_type    = BYTE;

// load byte unsigned
// 17
#2;
rst 				 = 0;
data_input   = 32'h00000000;
addr_input   = 12'heee;
load 				 = 1;
store				 = 0;
is_signed    = 0;
word_type    = BYTE;






$stop;
end

endmodule
