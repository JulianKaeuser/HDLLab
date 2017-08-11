// AUTHORS: GROUP 06 / Julian Käuser
// Wednesday 08/02/2017

`timescale 1ns/10ps
module memory_fsm_tb ();

integer i = 0;

localparam output_file = "memory_control_fsm_tb.vcd";

// data display helper values
localparam INIT                  = 5'b00000;
localparam LOAD_HW_TEST_SIGNED   = 5'b00001;
localparam LOAD_HW_TEST_UNSIGNED = 5'b00010;
localparam LOAD_HW_TEST3         = 5'b00011;
localparam RESET_AFTER_HW        = 5'b00100;
localparam LOAD_W_TEST           = 5'b00101;
localparam LOAD_HW_TEST_RESET    = 5'b00110;
localparam LOAD_BYTE_TEST_SIGNED = 5'b00111;
localparam LOAD_BYTE_TEST_RESET  = 5'b01000;
localparam LOAD_BYTE_TEST_UNSIGN = 5'b01001;
localparam LOAD_W_TEST_RESET     = 5'b01010;
//localparam                     = 5'b01011;
localparam STORE_HW_TEST         = 5'b01100;
localparam STORE_HW_TEST_RESET   = 5'b01101;
localparam STORE_WORD_TEST       = 5'b01110;
localparam STORE_WORD_TEST_RESET = 5'b01111;
localparam STORE_BYTE_TEST       = 5'b10000;
localparam STORE_BYTE_TEST_RESET = 5'b10001;
//localparam                     = 5'b10010;
//localparam                     = 5'b10011;
//localparam                     = 5'b10100;
//localparam                     = 5'b10101;
//localparam                     = 5'b10110;
//localparam                     = 5'b10111;
//localparam                     = 5'b11000;
//localparam                     = 5'b11001;
//localparam                     = 5'b11010;
//localparam                     = 5'b11011;
//localparam                     = 5'b11100;
//localparam                     = 5'b11101;
//localparam                     = 5'b11110;
//localparam                     = 5'b11111;

// word type
localparam WORD     = 2'b10;
localparam HW       = 2'b01;
localparam BYTE     = 2'b00;

localparam DC2      = 2'bxx;
localparam DC       = 1'bx;





// outputs of dut
wire output_valid;
wire write_ready;
wire old_or_new_byte_remainder;
wire modified_or_original_address;
wire added_or_delayed_address;
wire output_shuffle;

wire mem_read_enable;
wire mem_write_enable;
wire mem_enable;

wire fsm_read_control;
wire fsm_write_control;
wire fsm_read_out;
wire fsm_write_out;

// some assignments to make it easier
wire r;
wire s;
wire word_dep;

assign word_dep = word_type[0] | word_type[1];
assign r = word_dep ? load : 1'b1;
assign w = word_dep ? store: 1'b0;

assign mem_read_enable = fsm_read_control ? fsm_read_out : r;
assign mem_write_enable = fsm_write_control ? fsm_write_out : w;

wire [1:0] first_two_bytes_out_select;
wire [1:0] third_byte_out_select;
wire [1:0] direct_or_delayed_din;

wire busy;

// inputs for dut
reg is_signed;
reg [1:0] word_type;
reg load;
reg store;
reg clk;
reg reset;

reg is_signed_fsm;
reg is_signed_temp;
always @(posedge clk) begin
  is_signed_temp <= is_signed;
  is_signed_fsm <= is_signed_temp;
end

// reg to ease the simulation abstraction
reg [4:0] display;


memory_control_fsm_v2 dut (
 .is_signed_fsm(is_signed_fsm),
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

initial begin
$dumpfile(output_file);
$dumpvars(output_valid);

//$display("\t\ttime,\tclk");
$monitor("%d, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%d",
$time,
 output_valid,
 write_ready,
 old_or_new_byte_remainder,
 modified_or_original_address,
 added_or_delayed_address,
 output_shuffle,
 mem_read_enable,
 mem_write_enable,
 mem_enable,
 first_two_bytes_out_select,
 third_byte_out_select,
 direct_or_delayed_din,
 is_signed,
 is_signed_fsm,
 is_signed_temp,
 word_type,
 load,
 store,
 clk,
 reset,
 display,
 busy,
 i
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
// initial values,

display   = INIT;
is_signed = DC  ;
word_type = DC2 ;
load      = 0   ;
store     = 0   ;
reset     = 0   ;

// check if it goes into load HW state
// 0
#10;
display   = LOAD_HW_TEST_SIGNED;
is_signed = 1  ;
word_type = HW  ;
load      = 1   ;
store     = 0   ;
reset     = 0   ;

// check if it goes into state
// 1
#10;
i=i+1;
display   = LOAD_HW_TEST_UNSIGNED;
is_signed = 0  ;
word_type = HW  ;
load      = 1   ;
store     = 0   ;
reset     = 0   ;

// check if it goes into state
//2
#10;
i=i+1;
display   = LOAD_HW_TEST_RESET;
is_signed = DC  ;
word_type = HW  ;
load      = 1   ;
store     = 0   ;
reset     = 1   ;

// check if it goes into state
//3
#10;
i=i+1;
display   = LOAD_W_TEST;
is_signed = DC   ;
word_type = WORD ;
load      = 1   ;
store     = 0   ;
reset     = 0   ;

// check if it goes into state
//4
#10;
i=i+1;
display   = LOAD_W_TEST;
is_signed = DC   ;
word_type = WORD ;
load      = 0   ;
store     = 0   ;
reset     = 0   ;

// check if it goes into state IDLE again
//5
#10;
i=i+1;
display   = LOAD_W_TEST;
is_signed = DC   ;
word_type = WORD ;
load      = 1   ;
store     = 0   ;
reset     = 0   ;

// check if it goes into state IDLE at reset
//6
#10;
i=i+1;
display   = LOAD_W_TEST_RESET;
is_signed = DC   ;
word_type = WORD ;
load      = 1   ;
store     = 0   ;
reset     = 1   ;


// check if it goes into state
//7
#10;
i=i+1;
display   = LOAD_BYTE_TEST_SIGNED;
is_signed = 1   ;
word_type = BYTE ;
load      = 1   ;
store     = 0   ;
reset     = 0   ;

// check if it goes into state IDLE again
//8
#10;
i=i+1;
display   = LOAD_BYTE_TEST_UNSIGN;
is_signed = 0   ;
word_type = BYTE ;
load      = 1   ;
store     = 0   ;
reset     = 0   ;

// check if it goes into state
//9
#10;
i=i+1;
display   = LOAD_BYTE_TEST_SIGNED;
is_signed = 1   ;
word_type = BYTE ;
load      = 1   ;
store     = 0   ;
reset     = 0   ;

// check if it goes into state
//10
#10;
i=i+1;
display   = LOAD_BYTE_TEST_RESET;
is_signed = 1   ;
word_type = BYTE ;
load      = 1   ;
store     = 0   ;
reset     = 1   ;

// check if it goes into state
//11
#10;
i=i+1;
display   = LOAD_BYTE_TEST_UNSIGN;
is_signed = 0   ;
word_type = BYTE ;
load      = 1   ;
store     = 0   ;
reset     = 0   ;

// check if it goes into state IDLE again
//12
#10;
i=i+1;
display   = LOAD_BYTE_TEST_SIGNED;
is_signed = 1   ;
word_type = BYTE ;
load      = 1   ;
store     = 0   ;
reset     = 0   ;

// check if it goes into state IDLE again
//13
#10;
i=i+1;
display   = LOAD_BYTE_TEST_UNSIGN;
is_signed = 0   ;
word_type = BYTE ;
load      = 1   ;
store     = 0   ;
reset     = 0   ;

// check if it goes into state
//14
#10;
i=i+1;
display   = LOAD_BYTE_TEST_RESET;
is_signed = 1   ;
word_type = BYTE ;
load      = 1   ;
store     = 0   ;
reset     = 1   ;

// check if it goes into state LOAD_BYTE
//15
#10;
i=i+1;
display   = LOAD_BYTE_TEST_UNSIGN;
is_signed = 0   ;
word_type = BYTE ;
load      = 1   ;
store     = 0   ;
reset     = 0   ;

// check if it goes into state IDLE again
//16
#10;
i=i+1;
display   = LOAD_BYTE_TEST_UNSIGN;
is_signed = 0   ;
word_type = BYTE ;
load      = 1   ;
store     = 0   ;
reset     = 0   ;

// check if it goes into state LOAD_WORD_A
//17
#10;
i=i+1;
display   = LOAD_W_TEST;
is_signed = 0   ;
word_type = WORD ;
load      = 1   ;
store     = 0   ;
reset     = 0   ;

// check if it goes into state LOAD_WORD_B
//18
#10;
i=i+1;
display   = LOAD_W_TEST;
is_signed = 0   ;
word_type = WORD ;
load      = 1   ;
store     = 0   ;
reset     = 0   ;


// check if it goes into state LOAD_HW
//19
#10;
i=i+1;
display   = LOAD_HW_TEST_UNSIGNED;
is_signed = 0   ;
word_type = HW ;
load      = 1   ;
store     = 0   ;
reset     = 0   ;

// check if it goes into state LOAD_HW
//20
#10;
i=i+1;
display   = LOAD_BYTE_TEST_SIGNED;
is_signed = 1   ;
word_type = BYTE ;
load      = 1   ;
store     = 0   ;
reset     = 0   ;

// finished with load tests
// begin store testing

// check if it goes into state STORE_HW
//0
#10;
i=i+1;
display   = STORE_HW_TEST;
is_signed = 0   ;
word_type = HW ;
load      = 0   ;
store     = 1   ;
reset     = 1   ;

// check if it goes into state
//1
#10;
i=i+1;
display   = STORE_HW_TEST;
is_signed = 0   ;
word_type = HW ;
load      = 0   ;
store     = 1   ;
reset     = 0   ;

// check if it goes into state
//2
#10;
i=i+1;
display   = STORE_HW_TEST;
is_signed = 1   ;
word_type = HW ;
load      = 0   ;
store     = 1   ;
reset     = 0   ;

// check if it goes into state
//3
#10;
i=i+1;
display   = STORE_HW_TEST_RESET;
is_signed = 0   ;
word_type = HW ;
load      = 0   ;
store     = 1   ;
reset     = 1   ;

// check if it goes into state
//4
#10;
i=i+1;
display   = STORE_WORD_TEST;
is_signed = 0   ;
word_type = WORD ;
load      = 0   ;
store     = 1   ;
reset     = 0   ;

// check if it goes into state
//4
#10;
i=i+1;
display   = STORE_WORD_TEST;
is_signed = 0   ;
word_type = WORD ;
load      = 0   ;
store     = 1   ;
reset     = 0   ;

// check if it goes into state
//5
#10;
i=i+1;
display   = STORE_WORD_TEST;
is_signed = 1   ;
word_type = WORD ;
load      = 0   ;
store     = 1   ;
reset     = 0   ;

// check if it goes into state
//6
#10;
i=i+1;
display   = STORE_WORD_TEST_RESET;
is_signed = 0   ;
word_type = BYTE ;
load      = 0   ;
store     = 1   ;
reset     = 1   ;

// check if it goes into state
//7
#10;
i=i+1;
display   = STORE_BYTE_TEST;
is_signed = 0   ;
word_type = BYTE ;
load      = 0   ;
store     = 1   ;
reset     = 0   ;

// check if it goes into state
//8
#10;
i=i+1;
display   = STORE_BYTE_TEST;
is_signed = 0   ;
word_type = BYTE ;
load      = 0   ;
store     = 1   ;
reset     = 0   ;

// check if it goes into state
//9
#10;
i=i+1;
display   = STORE_BYTE_TEST;
is_signed = 0   ;
word_type = BYTE ;
load      = 0   ;
store     = 1   ;
reset     = 0   ;

// check if it goes into state
//10
#10;
i=i+1;
display   = STORE_BYTE_TEST;
is_signed = 0   ;
word_type = BYTE ;
load      = 0   ;
store     = 1   ;
reset     = 1   ;

 //#300;
 $finish;
end




endmodule
