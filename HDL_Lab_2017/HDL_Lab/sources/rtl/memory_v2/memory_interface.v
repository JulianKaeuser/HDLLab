// AUTHORS: Group 06 / Julian Käuser
// Wed 08/09/2017


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


input [12:0] address; // address has 1 bit more than the one going to memory -
// because of bit alignment in cpu addresses
input [31:0] data_in;

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
output [11:0] to_mem_address;
output [15:0] to_mem_data;


// outputs 2 cpu
output [31:0] data_out;
output write_ready;
output output_valid;
output busy;

localparam BUFFER = 1'b1;    // for all buffer select signals
localparam UPDATE = 1'b0;    // for all buffer select signals


// ############################ address path: #########################################
// ####################################################################################

wire direct_or_modified_address_sel;
localparam DIRECT_ADDRESS = 1'b1;
localparam MODIFIED_ADDRESS = 1'b0;

wire delayed_or_added_address_sel;
localparam  DELAYED_ADDRESS = 1'b1;
localparam  ADDED_ADDRESS = 1'b0;

wire delayed_address_buffer_sel;
wire added_address_buffer_sel;

wire adder_summand_sel;
localparam SEL_ONE = 1'b1;
localparam SEL_TWO = 1'b0;

reg [11:0] delayed_address_buffer_reg;
reg [11:0] added_address_buffer_reg;


always @(posedge clk) begin    // make buffers flipflops
    // assign buffers according to muxes
    delayed_address_buffer_reg <= delayed_address_buffer_sel ? delayed_address_buffer_reg : address[12:1];
    added_address_buffer_reg <= added_address_buffer_sel ? added_address_buffer_reg : address[12:1];
end

  // create multiplexors


wire [11:0] modified_address;
assign to_mem_address = direct_or_modified_address_sel ? address[12:1] : modified_address;

wire [11:0] added_address;
assign modified_address = delayed_or_added_address_sel ? delayed_address_buffer_reg : added_address;

wire [11:0] summand;
assign summand = adder_summand_sel ? 12'h001 : 12'h002;

assign added_address = summand + added_address_buffer_reg;


// ########################## output path #######################################################################
// ##############################################################################################################















endmodule
