//Authors: Group 06/Julian Käuser
//Tuesday 08/01/2017

`define READ 0
`define WRITE 1

`define WORD 2'b10
`define HALFWORD 2'b01
`define BYTE 2'b00

`define MEM_LINE_OFFSET 12'b1

`define SIGN_BIT_BYTE 7 // the bit of a byte which is the sign bit in K2 complement
`define SIGN_BIT_HW 15 // the bit of a halfword which is the sign in K2 complement

// codes for multiplexor which assigns sign extensions
`define TOP_HALFWORD 2'b10
`define SIGN_B 2'b01
`define SIGN_A 2'b11
`define ZEROS 2'b00

// codes for direct_or_delayed_din
`define DIRECT_TOP16 2'b10
`define DIRECT_LOW16 2'b11
`define DELAYED_TOP16 2'b00
`define DELAYED_LOW16 2'b01


//Eingang von ALU (12 bit)
//EIngang Regfile A(12 bit)
//Eingang von Regfile B (12 bit)


// abstracts the memory interface from the processor
module memory_interface (
  address,
  data_in,
  load,
  store,
  clk,
  reset,
  is_signed,
  word_type,
  from_mem_data,
  to_mem_read_enable,
  to_mem_write_enable,
  to_mem_mem_enable,
  to_mem_address,
  to_mem_data,
  data_out,
  write_ready,
  output_valid,
  busy
  );

localparam WIDE = 16;
localparam LARGE = 32;
localparam ADDR_WIDTH = 12;


input [ADDR_WIDTH-1:0] address;
input [LARGE-1:0] data_in;
input load;
input store;
input clk;
input reset;
input is_signed;
input [1:0] word_type;

// inputs from memory
input [WIDE-1:0] from_mem_data;

// outputs going to the memory
output to_mem_read_enable;
output to_mem_write_enable;
output to_mem_mem_enable;
output [ADDR_WIDTH-1:0] to_mem_address;
output [WIDE-1:0] to_mem_data;

output [LARGE-1:0] data_out;
output write_ready;
output output_valid;
output busy;
//output reg addr_overflow;

// mux control wires
wire [1:0] direct_or_delayed_din;
wire added_or_delayed_address;
wire modified_or_original_address;
wire old_or_new_byte_remainder;
wire [1:0] first_two_bytes_out_select;
wire [1:0] third_byte_out_select;


// delay registers
reg [11:0] delay_addr_for_adder;
reg [11:0] delay_addr_single;
reg [31:0] delay_data_in32;
reg [15:0] delay_first_two_bytes_out;
reg delayed_is_signed;

// memory connect wires
wire [11:0] mem_addr_in;
wire [15:0] mem_data_in;
wire [15:0] mem_data_out;
wire mem_write_enable;
wire mem_enable;
wire mem_read_enable;
wire mem_control_reset;

// additional wires and regs(combinatorial!)
wire [11:0] modified_address;

wire [15:0] data_bus_to_mem;
wire [15:0] direct_data_in16;
wire [15:0] delayed_data_in16;

wire [7:0] third_byte_out;
reg [15:0] first_two_bytes_out;
wire [7:0] sign_extended_third_byte;
wire [7:0] sign_extension_byte;

wire [15:0] sign_b_extension;
wire [15:0] sign_a_extension;
wire [15:0] zero_halfword;

//fsm connection wires
wire fsm_read_control;
wire fsm_read_out;
wire fsm_write_out;
wire fsm_write_control;


// assigns for wires (fixed)

assign mem_control_reset = reset;


// address path
assign modified_address = added_or_delayed_address ? (delay_addr_for_adder+`MEM_LINE_OFFSET) : delay_addr_single;
assign mem_addr_in = modified_or_original_address ? address : modified_address;

// data_in path
assign direct_data_in16 = (direct_or_delayed_din[0]) ? data_in[15:0] : data_in[31:16];
assign delayed_data_in16 = (direct_or_delayed_din[0]) ? delay_data_in32[15:0] : delay_data_in32[31:16];

assign data_bus_to_mem = direct_or_delayed_din[1] ?  direct_data_in16 : delayed_data_in16;
assign mem_data_in[7:0] = data_bus_to_mem[7:0];
assign mem_data_in[15:8] = old_or_new_byte_remainder ? data_bus_to_mem[15:8] : mem_data_out[15:8];



// data_out path
// general
wire output_shuffle;
wire data_top_out [15:0];
wire data_low_out [15:0];
assign data_top_out[7:0] = mem_data_out[7:0]; // fourth_byte_out
assign data_top_out[15:8] = third_byte_out;
assign data_low_out = mem_data_out[15:0];

assign data_out[31:16] = output_shuffle ? data_top_out : data_low_out;
assign data_out[15:0]  = output_shuffle ? data_low_out : data_top_out;
// third byte of the outoput
assign third_byte_out = third_byte_out_select[1] ? mem_data_out[15:8] : sign_extended_third_byte;
assign sign_extended_third_byte = third_byte_out_select[0] ? 8'b0 : sign_extension_byte;
assign sign_extension_byte = mem_data_out[`SIGN_BIT_BYTE] ? 8'h00 : 8'hff;

// first and second byte of the output
always @(*) begin
   case (first_two_bytes_out_select)
     `TOP_HALFWORD: first_two_bytes_out = delay_first_two_bytes_out;
     `SIGN_B: first_two_bytes_out = sign_b_extension;
     `SIGN_A: first_two_bytes_out = sign_a_extension;
     `ZEROS: first_two_bytes_out = zero_halfword;
  endcase
end

assign sign_b_extension = mem_data_out[`SIGN_BIT_HW] ? 16'hffff : 16'h0000;
assign sign_a_extension = mem_data_out[`SIGN_BIT_BYTE] ? 16'hffff : 16'h0000;

// registers for delaying signals

// delay_first_two_bytes_out
always @(posedge clk) begin
   delay_first_two_bytes_out <= mem_data_out[15:0];
end

// delay second half of input data
always @(posedge clk) begin
   delay_data_in32 <= data_in;
end

// delay before adder
always @(posedge clk) begin
   delay_addr_for_adder <= address;
end

// delay address single
always @(posedge clk) begin
   delay_addr_single <= address;
end

// delay signed signal
always @(posedge clk) begin
   delayed_is_signed <= is_signed;
end

// memory instantiation/ connections
assign to_mem_address = mem_addr_in;
assign to_mem_data = mem_data_in;
assign to_mem_mem_enable = mem_enable;
assign to_mem_read_enable = mem_read_enable;
assign to_mem_write_enable = mem_write_enable;
assign mem_data_out = from_mem_data;

// state machine for control

memory_control_fsm fsm (
  .is_signed_fsm(delayed_is_signed),
  .word_type(word_type),
  .load(load),
  .store(store),
  .clk(clk),
  .reset(reset),
  .output_valid(output_valid),
  .direct_or_delayed_din(direct_or_delayed_din),
  .write_ready(write_ready),
  .old_or_new_byte_remainder(old_or_new_byte_remainder),
  .modified_or_original_address(modified_or_original_address),
  .added_or_delayed_address(added_or_delayed_address),
  .first_two_bytes_out_select(first_two_bytes_out_select),
  .third_byte_out_select(third_byte_out_select),
  .output_shuffle(output_shuffle),
  .mem_read_enable(fsm_read_out),
  .mem_write_enable(fsm_write_out),
  .mem_enable(mem_enable),
  .fsm_read_control(fsm_read_control),
  .fsm_write_control(fsm_write_control),
  .busy(busy)
  );

// final assignments regarding the control

wire w;
wire r;
wire word_dep;

assign word_dep = word_type[0] | word_type[1];

assign r = word_dep ? load : 1'b1;
assign w = word_dep ? store: 1'b0;
assign mem_read_enable = fsm_read_control ? fsm_read_out : r;
assign mem_write_enable = fsm_write_control ? fsm_write_out : w;

endmodule




`undef WRITE
`undef READ

`undef WORD
`undef HALFWORD
`undef BYTE

`undef MEM_LINE_OFFSET

`undef SIGN_BIT_BYTE  // the bit of a byte which is the sign bit in K2 complement
`undef SIGN_BIT_HW  // the bit of a halfword which is the sign in K2 complement

// codes for multiplexor which assigns sign extensions
`undef TOP_HALFWORD
`undef SIGN_B
`undef SIGN_A
`undef ZEROS

// codes for direct_or_delayed_din
`undef DIRECT_TOP16
`undef DIRECT_LOW16
`undef DELAYED_TOP16
`undef DELAYED_LOW16
