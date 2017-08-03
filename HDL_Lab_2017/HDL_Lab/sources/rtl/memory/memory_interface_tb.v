//AUTHORS: Group 06 /Julian Käuser
// THURSDAY 08/03/2017

`timescale 1ns/10ps

module memory_interface_tb();

localparam dumpfile = "memory_interface_tb.vcd";

// word types
localparam WORD     =2'b10;
localparam HALFWORD =2'b01;
localparam BYTE     =2'b00;

// inputs, outputs for dut
reg [11:0] address;
reg [31:0] d_in;
wire [31:0] d_out;

wire write_ready;
wire output_valid;
reg clk;
reg load;
reg store;
reg is_signed;
wire busy;
reg reset;
reg [1:0] word_type;


// the dut
memory_interface mem_iface (
  .address(),
  .data_in(),
  .data_out(),
  .write_ready(),
  .output_valid(),
  .clk(),
  .load(),
  .store(),
  .is_signed(),
  .word_type(),
  .busy(),
  .reset()
  );

  initial begin
      clk = 1;
  end

  always begin
    #10;
    clk = !clk;
  end

  initial begin
    $dumpfile(dumpfile);
    $dumpvars;

    $monitor("%d, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b,",
    $time,
    address,
    d_in,
    d_out,
    write_ready,
    output_valid,
    clk,
    load,
    store,
    is_signed,
    busy,
    reset,
    word_type
     );
  end

  // test cases
  initial begin


    $finish;
  end

endmodule
