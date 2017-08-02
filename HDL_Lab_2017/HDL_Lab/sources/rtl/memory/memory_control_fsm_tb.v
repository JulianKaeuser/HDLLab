// AUTHORS: GROUP 06 / Julian Käuser
// Wednesday 08/02/2017

`timescale 1ns/10ps
module memory_fsm_tb ();

localparam output_file = "memory_control_fsm_tb.vcd";

// data display helper values
localparam INIT           = 00000;
localparam LOAD_HW_TEST   = 5'b00001;
localparam LOAD_HW_TEST2  = 5'b00010;
localparam LOAD_HW_TEST3  = 5'b00011;
localparam RESET_AFTER_HW = 5'b00100;
localparam LOAD_W_TEST    = 5'b00101;
//localparam                = 5'00110;
//localparam                = 5'00111;
//localparam                = 5'01000;
//localparam                = 5'01001;
//localparam                = 5'01010;
//localparam                = 5'01011;
//localparam                = 5'01100;
//localparam                = 5'01101;
//localparam                = 5'01110;
//localparam                = 5'01111;
//localparam                = 5'10000;
//localparam                = 5'10001;
//localparam                = 5'10010;
//localparam                = 5'10011;
//localparam                = 5'10100;
//localparam                = 5'10101;
//localparam                = 5'10110;
//localparam                = 5'10111;
//localparam                = 5'11000;
//localparam                = 5'11001;
//localparam                = 5'11010;
//localparam                = 5'11011;
//localparam                = 5'11100;
//localparam                = 5'11101;
//localparam                = 5'11110;
//localparam                = 5'11111;

// word type
localparam WORD     = 2'b10;
localparam HW       = 2'b01;
localparam BYTE     = 2'b00;


// outputs of dut
wire output_valid;
wire write_ready;
wire old_or_new_byte_remainder;
wire modified_or_original_address;
wire added_or_delayed_address;

wire mem_read_enable;
wire mem_write_enable;
wire mem_enable;

wire [1:0] first_two_bytes_out_select;
wire [1:0] third_byte_out_select;
wire [1:0] direct_or_delayed_din;

// inputs for dut
reg is_signed;
reg [1:0] word_type;
reg load;
reg store;
reg clk;
reg reset;

// reg to ease the simulation abstraction
reg [4:0] display;


memory_control_fsm dut (
  .is_signed(is_signed),
  .word_type(word_type),
  .output_valid(write_ready),
  .write_ready(write_ready),
  .load(load),
  .store(store),
  .direct_or_delayed_din(direct_or_delayed_din),
  .old_or_new_byte_remainder,
  .modified_or_original_address(modified_or_original_address),
  .added_or_delayed_address(added_or_delayed_address),
  .first_two_bytes_out_select (first_two_bytes_out_select),
  .third_byte_out_select(third_byte_out_select),
  .mem_read_enable(mem_read_enable),
  .mem_write_enable(mem_write_enable),
  .mem_enable(mem_enable),
  .clk(clk),
  .reset(reset)
  );

initial begin
$dumpfile(output_file);
$dumpvars;

//$display("\t\ttime,\tclk");
$monitor("%d, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b",
$time,
 output_valid,
 write_ready,
 old_or_new_byte_remainder,
 modified_or_original_address,
 added_or_delayed_address,
 mem_read_enable,
 mem_write_enable,
 mem_enable,
 first_two_bytes_out_select,
 third_byte_out_select,
 direct_or_delayed_din,
 is_signed,
 word_type,
 load,
 store,
 clk,
 reset,
 display
 );

end

always begin
  #5 clk = ~clk;
end

initial begin
clk = 1;

// initial values
display   = INIT;
is_signed = 0   ;
word_type = HW  ;
load      = 0   ;
store     = 0   ;
reset     = 1   ;

#10;
// initial values
display   = INIT;
is_signed = 0   ;
word_type = HW  ;
load      = 0   ;
store     = 0   ;
reset     = 0   ;

// check if it goes into load HW state
// 0
#10;
display   = LOAD_HW_TEST;
is_signed = 0   ;
word_type = HW  ;
load      = 1   ;
store     = 0   ;
reset     = 0   ;

// check if it goes into state
// 1
#10;
display   = LOAD_HW_TEST2;
is_signed = 1   ;
word_type = HW  ;
load      = 1   ;
store     = 0   ;
reset     = 0   ;

// check if it goes into state
//2
#10;
display   = LOAD_HW_TEST3;
is_signed = 1   ;
word_type = HW  ;
load      = 1   ;
store     = 0   ;
reset     = 0   ;

// check if it goes into state
//3
#10;
display   = RESET_AFTER_HW;
is_signed = 0   ;
word_type = HW  ;
load      = 0   ;
store     = 0   ;
reset     = 1   ;

// check if it goes into state
//4
#10;
display   = LOAD_W_TEST;
is_signed = 0   ;
word_type = WORD  ;
load      = 0   ;
store     = 0   ;
reset     = 0   ;



 #300 $finish;
end




endmodule
