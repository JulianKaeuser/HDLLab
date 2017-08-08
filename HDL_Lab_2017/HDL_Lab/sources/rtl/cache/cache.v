// ATUHORS Group 6 / Julian Käuser
// Tuesday 08/08/2107

// to change the cache size, vary the local parameter NUM_CACHE_LINES (0 not supported)


// has the same interface as the common memory, so it doesnt matter which one is connected
module cache (
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

// how many lines (=Halfwords) should there be in the cache?
  localparam NUM_CACHE_LINES = 64;

// interfacing
  localparam WIDE = 16;
  localparam LARGE = 32;
  localparam ADDR_WIDTH = 12;

// inputs into cache (from CPU)
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

// outputs out of the cache (2 CPU)
  output [LARGE-1:0] data_out;
  output write_ready;
  output output_valid;
  output busy;

  memory_interface mem_iface(
    .address(cache2memiface_addr),
    .data_in(cache2memiface_data_in),
    .load(cache2memiface_load),
    .store(cache2memiface_store),
    .clk(clk),
    .reset(reset),
    .is_signed(cache2memiface_is_signed),
    .word_type(cache2memiface_word_type),
    .from_mem_data(from_mem_data),
    .to_mem_read_enable(to_mem_read_enable),
    .to_mem_write_enable(to_mem_write_enable),
    .to_mem_mem_enable(to_mem_mem_enable),
    .to_mem_address(to_mem_address),
    .to_mem_data(to_mem_data),
    .data_out(memiface2cache_data_out),
    .write_ready(memiface2cache_write_ready),
    .output_valid(memiface2cache_output_valid),
    .busy(memiface2cache_busy)
    );

// connection wires from the cache module to the memory
    wire memiface2cache_write_ready;
    wire memiface2cache_busy;
    wire memiface2cache_output_valid;
    wire [LARGE-1:0] memiface2cache_data_out;
    wire [LARGE-1:0] cache2memiface_data_in;
    wire cache2memiface_store;
    wire cache2memiface_load;
    wire [ADDR_WIDTH-1:0] cache2memiface_addr;
    wire cache2memiface_is_signed;
    wire [1:0] cache2memiface_word_type;
