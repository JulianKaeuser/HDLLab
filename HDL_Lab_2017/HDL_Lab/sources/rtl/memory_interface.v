//Authors: Group 06/Julian Käuser
//Tuesday 08/01/2017

`define READ 0
`define WRITE 1

`define WORD 10
`define HALFWORD 01
`define BYTE 00

`define MEM_LINE_OFFSET 1

`define SIGN_BIT_BYTE 7 // the bit of a byte which is the sign bit in K2 complement
`define SIGN_BIT_HW 15 // the bit of a halfword which is the sign in K2 complement

`define TOP_HALFWORD 00
`define SIGN_B 01
`define SIGN_A 11
`define ZEROS 00


//Eingang von ALU (12 bit)
//EIngang Regfile A(12 bit)
//Eingang von Regfile B (12 bit)


// abstracts the memory interface from the processor
module memory_interface (
  // fill with inputs, outputs
  );

localparam WIDE = 16;
localparam LARGE = 32;
localparam ADDR_WIDTH = 12;


input [ADDR_WIDTH-1:0] address;
input [LARGE-1:0] data_in;
input rw;
input en;
input clk;

input is_signed;
input [1:0] word_type;

output reg [LARGE-1:0] data_out;
output reg valid;
output reg addr_overflow;

// mux control wires
wire direct_or_delayed_din;
wire added_or_delayed_address;
wire modified_or_original_address;
wire old_or_new_byte_remainder;
wire [1:0] first_two_bytes_out_select;
wire [1:0] third_byte_out_select;

// delay registers
reg [11:0] delay_addr_for_adder;
reg [11:0] delay_addr_single;
reg [15:0] delay_data_in_upper;
reg [15:0] delay_first_two_bytes_out;

// memory connect wires
wire [11:0] mem_addr_in;
wire [15:0] mem_data_in;
wire [15:0] mem_data_out;
wire mem_write_enable;
wire mem_enable;
wire mem_read_enable;

// additional wires and regs(combinatorial!)
wire [11:0] modified_address;

wire [15:0] data_bus_to_mem;

wire [7:0] third_byte_out;
reg [15:0] first_two_bytes_out;
wire [7:0] sign_extended_third_byte;
wire [7:0] sign_extension_byte;

wire [15:0] sign_b_extension;
wire [15:0] sign_a_extension;
wire [15:0] zero_halfword;




// assigns for wires (fixed)

// address path
assign modified_address = added_or_delayed_address ? (delay_addr_for_adder+MEM_LINE_OFFSET) : delay_addr_single;
assign mem_addr_in = modified_or_original_address ? address : modified_address;

// data_in path
assign data_bus_to_mem = direct_or_delayed_din ? delay_data_in_upper : data_in[31:16];
assign mem_data_in[7:0] = data_bus_to_mem[7:0];
assign mem_data_in[15:8] = old_or_new_byte_remainder ? data_bus_to_mem[15:8] : mem_data_out[15:8];

// data_out path
// general
assign data_out[7:0] = mem_data_out[7:0]; // fourth_byte_out
assign data_out[15:8] = third_byte_out;
assign data_out[31:16] = first_two_bytes_out;

// third byte of the outoput
assign third_byte_out = third_byte_out_select[1] ? mem_data_out[15:8] : sign_extended_third_byte;
assign sign_extended_third_byte = third_byte_out_select[0] ? 8'b0 : sign_extension_byte;
assign sign_extension_byte = mem_data_out[SIGN_BIT_BYTE] ? 8'h00 : 8'hff;

// first and second byte of the output
always @(*) begin
   case (first_two_bytes_out_select)
     TOP_HALFWORD: first_two_bytes_out = delay_first_two_bytes_out;
     SIGN_B: first_two_bytes_out = sign_b_extension;
     SIGN_A: first_two_bytes_out = sign_a_extension;
     ZEROS: first_two_bytes_out = zero_halfword;
  endcase
end

assign sign_b_extension = mem_data_out[SIGN_BIT_HW] ? 16'hffff : 16'h0000;
assign sign_a_extension = mem_data_out[SIGN_BIT_BYTE] ? 16'hffff : 16'h0000;

// registers for delaying signals

// delay_first_two_bytes_out
always @(posedge clk) begin
   delay_first_two_bytes_out <= mem_data_out[15:0];
end

// delay second half of input data
always @(posedge clk) begin
   delay_data_in_upper <= data_in[15:0];
end

// delay before adder
always @(posedge clk) begin
   delay_addr_for_adder <= address;
end

// delay address single
always @(posedge clk) begin
   delay_addr_single <= address;
end

// memory instantiation

memory mem(
  .clk(clk);
  .en(mem_enable),
  .rd_en(mem_read_enable),
  .wr_en(mem_write_enable),
  .addr(mem_addr_in),
  .din(mem_data_in),
  .dout(mem_data_out)
  );

// state machine for control

memory_control_fsm fsm (

  );

endmodule
