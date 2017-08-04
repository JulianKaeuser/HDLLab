// ATUHORS: Group 06/ Julian Käuser
//Friday 08/04/2017


`timescale 1ns/10ps


module register_file_tb ();
// register selects for read_sel, write_sel
localparam R0     = 5'b00000;
localparam R1     = 5'b00001;
localparam R2     = 5'b00010;
localparam R3     = 5'b00011;
localparam R4     = 5'b00100;
localparam R5     = 5'b00101;
localparam R6     = 5'b00110;
localparam R7     = 5'b00111;
localparam R8     = 5'b01000;
localparam R9     = 5'b01001;
localparam R10    = 5'b01010;
localparam R11    = 5'b01011;
localparam R12    = 5'b01100;
localparam SP     = 5'b01101;
localparam LR     = 5'b01110;
localparam PC     = 5'b01111;

localparam NONE   = 5'b11101;  // für synthese auf 5'b????? ändern
localparam TMP1   = 5'b11110;
localparam IMM    = 5'b11111; // immediate A can only be routed to out A, b only to output B

localparam DC     = 1'b1;     // for synthesis; while testing, this should be !=x
localparam DC2    = 2'b11;    // for synthesis; while testing, this should be !=x
localparam DC3    = 3'b111;    // for synthesis; while testing, this should be !=x
localparam DC4    = 4'b1111;    // for synthesis; while testing, this should be !=x
localparam DC5    = 5'b11111;    // for synthesis; while testing, this should be !=x
localparam DC32   = 32'hffffffff;    // for synthesis; while testing, this should be !=x


// display helpers
localparam CPSR_PASSTHROUGH     = 5'b00000;
localparam SP_PASSTHROUGH       = 5'b00001;
localparam PC_PASSTHROUGH       = 5'b00010;
localparam PC_NO_PASS           = 5'b00011;
localparam PC_WRITE1            = 5'b00100;
localparam PC_WRITE2            = 5'b00101;
localparam PC_WRITE3            = 5'b00110;
localparam REG_A_IMM            = 5'b00111;
localparam REG_B_IMM            = 5'b01000;
localparam REG_C_R0             = 5'b01001;
localparam REG_A_R0             = 5'b01010;
localparam WRITE_2_SIMULT       = 5'b01100;
localparam WRITE_2_SAME_REG     = 5'b01101;
//localparam        = 5'b01110;
//localparam        = 5'b01111;
//localparam        = 5'b10000;
//localparam        = 5'b10001;

localparam WIDE = 32;

integer i = 0;
wire [16:0] display_counter;
assign display_counter = i;

// needed wires
reg [4:0] readA_sel;
reg [4:0] readB_sel;
reg [4:0] readC_sel;
reg [4:0] readD_sel;
reg [4:0] write1_sel;
reg [4:0] write2_sel;
reg write1_en;
reg write2_en;
reg write1_in;
reg write2_in;
reg [WIDE-1:0] immediate1_in;
reg [WIDE-1:0] immediate2_in;
reg [WIDE-1:0] next_pc_in;
reg [3:0] next_cpsr_in;
reg [WIDE-1:0] next_sp_in;
reg [WIDE-1:0] next_pc_en;
reg clk;


wire [WIDE-1:0] regA_out;
wire [WIDE-1:0] regB_out;
wire [WIDE-1:0] regC_out;
wire [WIDE-1:0] pc_out;
wire [3:0]      cpsr_out;
wire [WIDE-1:0] sp_out;

reg [4:0] display;

//dut
register_file rf (
  .readA_sel(readA_sel),
  .readB_sel(readB_sel),
  .readC_sel(readC_sel),
  .readD_sel(readD_sel),
  .write1_sel(write1_sel),
  .write2_sel(write2_sel),
  .write1_en(write1_en),
  .write2_en(write2_en),
  .write1_in(write1_in),
  .write2_in(write2_in),
  .immediate1_in(immediate1_in),
  .immediate2_in(immediate2_in),
  .next_pc_in(next_pc_in),
  .next_cpsr_in(next_cpsr_in),
  .next_sp_in(next_sp_in),
  .next_pc_en(next_pc_en),
  .clk(clk),
  .regA_out(regA_out),
  .regB_out(regB_out),
  .regC_out(regC_out),
  .pc_out(pc_out),
  .cpsr_out(cpsr_out),
  .sp_out(sp_out)
);


initial begin
   clk = 1;
end

// some clock action
always begin
#1 clk = !clk;
end

initial begin
   $dumpfile("register_file_tb.vcd");
   $dumpvars;

   //$display("\t\ttime,\tclk");
   $monitor("%d,\t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b",
   $time,
   display_counter,
   readA_sel,
   readB_sel,
   readC_sel,
   readD_sel,
   write1_sel,
   write2_sel,
   write1_en,
   write2_en,
   write1_in,
   write2_in,
   immediate1_in,
   immediate2_in,
   next_pc_in,
   next_cpsr_in,
   next_sp_in,
   next_pc_en,
   clk,
   regA_out,
   regB_out,
   regC_out,
   pc_out,
   cpsr_out,
   sp_out
    );
end

initial begin

    // test cpsr passthrough
    // 0
    #2;
    display         = CPSR_PASSTHROUGH;
    readA_sel       = DC5; // 5 bits
    readB_sel       = DC5; // 5 bits
    readC_sel       = DC5; // 5 bits
    readD_sel       = DC5; // 5 bits
    write1_sel      = DC5; // 5 bits
    write2_sel      = DC5; // 5 bits

    write1_en       = DC; // 1 bit
    write2_en       = DC; // 1 bit
    write1_in       = DC32; // 32 bits
    write2_in       = DC32; // 32 bits
    immediate1_in   = DC32; // 32 bits
    immediate2_in   = DC32; // 32 bits
    next_pc_in      = DC32; // 32 bits
    next_cpsr_in    = 4'b1010; // 4  bits
    next_sp_in      = DC32; // 32 bits
    next_pc_en      = DC; // 1 bit

    // test cpsr passthrough
    // 1
    #2;
    i = i+1;
    display         = CPSR_PASSTHROUGH;
    readA_sel       = DC5; // 5 bits
    readB_sel       = DC5; // 5 bits
    readC_sel       = DC5; // 5 bits
    readD_sel       = DC5; // 5 bits
    write1_sel      = DC5; // 5 bits
    write2_sel      = DC5; // 5 bits

    write1_en       = DC; // 1 bit
    write2_en       = DC; // 1 bit
    write1_in       = DC32; // 32 bits
    write2_in       = DC32; // 32 bits
    immediate1_in   = DC32; // 32 bits
    immediate2_in   = DC32; // 32 bits
    next_pc_in      = DC32; // 32 bits
    next_cpsr_in    = 4'b1011; // 4  bits
    next_sp_in      = DC32; // 32 bits
    next_pc_en      = DC; // 1 bit

    // test SP_PASSTHROUGH
    // 2
    #2;
    i = i+1;
    display         = SP_PASSTHROUGH;
    readA_sel       = DC5; // 5 bits
    readB_sel       = DC5; // 5 bits
    readC_sel       = DC5; // 5 bits
    readD_sel       = DC5; // 5 bits
    write1_sel      = DC5; // 5 bits
    write2_sel      = DC5; // 5 bits

    write1_en       = 0; // 1 bit
    write2_en       = 0; // 1 bit
    write1_in       = DC32; // 32 bits
    write2_in       = DC32; // 32 bits
    immediate1_in   = DC32; // 32 bits
    immediate2_in   = DC32; // 32 bits
    next_pc_in      = DC32; // 32 bits
    next_cpsr_in    = DC4; // 4  bits
    next_sp_in      = 32'hdeadbeef; // 32 bits
    next_pc_en      = DC; // 1 bit

    // test SP_PASSTHROUGH
    // 3
    #2;
    i = i+1;
    display         = SP_PASSTHROUGH;
    readA_sel       = DC5; // 5 bits
    readB_sel       = DC5; // 5 bits
    readC_sel       = DC5; // 5 bits
    readD_sel       = DC5; // 5 bits
    write1_sel      = DC5; // 5 bits
    write2_sel      = DC5; // 5 bits

    write1_en       = 0; // 1 bit
    write2_en       = 0; // 1 bit
    write1_in       = DC32; // 32 bits
    write2_in       = DC32; // 32 bits
    immediate1_in   = DC32; // 32 bits
    immediate2_in   = DC32; // 32 bits
    next_pc_in      = DC32; // 32 bits
    next_cpsr_in    = DC4; // 4  bits
    next_sp_in      = 32'hadadadad; // 32 bits
    next_pc_en      = DC; // 1 bit

    // test PC_PASSTHROUGH
    // 4
    #2;
    i = i+1;
    display         = PC_PASSTHROUGH;
    readA_sel       = DC5; // 5 bits
    readB_sel       = DC5; // 5 bits
    readC_sel       = DC5; // 5 bits
    readD_sel       = DC5; // 5 bits
    write1_sel      = DC5; // 5 bits
    write2_sel      = DC5; // 5 bits

    write1_en       = 0; // 1 bit
    write2_en       = 0; // 1 bit
    write1_in       = DC32; // 32 bits
    write2_in       = DC32; // 32 bits
    immediate1_in   = DC32; // 32 bits
    immediate2_in   = DC32; // 32 bits
    next_pc_in      = 32'hffffabab; // 32 bits
    next_cpsr_in    = DC4; // 4  bits
    next_sp_in      = DC32; // 32 bits
    next_pc_en      = 1; // 1 bit

    // test PC_PASSTHROUGH
    // 5
    #2;
    i = i+1;
    display         = PC_PASSTHROUGH;
    readA_sel       = DC5; // 5 bits
    readB_sel       = DC5; // 5 bits
    readC_sel       = DC5; // 5 bits
    readD_sel       = DC5; // 5 bits
    write1_sel      = DC5; // 5 bits
    write2_sel      = DC5; // 5 bits

    write1_en       = 0; // 1 bit
    write2_en       = 0; // 1 bit
    write1_in       = DC32; // 32 bits
    write2_in       = DC32; // 32 bits
    immediate1_in   = DC32; // 32 bits
    immediate2_in   = DC32; // 32 bits
    next_pc_in      = 32'haafafafa; // 32 bits
    next_cpsr_in    = DC4; // 4  bits
    next_sp_in      = DC32; // 32 bits
    next_pc_en      = 0; // 1 bit

    // test PC_PASSTHROUGH
    // 6
    #2;
    i = i+1;
    display         = PC_NO_PASS;
    readA_sel       = DC5; // 5 bits
    readB_sel       = DC5; // 5 bits
    readC_sel       = DC5; // 5 bits
    readD_sel       = DC5; // 5 bits
    write1_sel      = DC5; // 5 bits
    write2_sel      = DC5; // 5 bits

    write1_en       = 0; // 1 bit
    write2_en       = 0; // 1 bit
    write1_in       = DC32; // 32 bits
    write2_in       = DC32; // 32 bits
    immediate1_in   = DC32; // 32 bits
    immediate2_in   = DC32; // 32 bits
    next_pc_in      = 32'haafafafa; // 32 bits
    next_cpsr_in    = DC4; // 4  bits
    next_sp_in      = DC32; // 32 bits
    next_pc_en      = 0; // 1 bit

    // test PC_WRITE1
    // 7
    #2;
    i = i+1;
    display         = PC_WRITE1;
    readA_sel       = DC5; // 5 bits
    readB_sel       = DC5; // 5 bits
    readC_sel       = DC5; // 5 bits
    readD_sel       = DC5; // 5 bits
    write1_sel      = PC; // 5 bits
    write2_sel      = DC5; // 5 bits

    write1_en       = 1; // 1 bit
    write2_en       = 0; // 1 bit
    write1_in       = 32'hdeadbeef; // 32 bits
    write2_in       = DC32; // 32 bits
    immediate1_in   = DC32; // 32 bits
    immediate2_in   = DC32; // 32 bits
    next_pc_in      = 32'h0000fefe; // 32 bits
    next_cpsr_in    = DC4; // 4  bits
    next_sp_in      = DC32; // 32 bits
    next_pc_en      = 0; // 1 bit

    // test PC_WRITE2
    // 8
    #2;
    i = i+1;
    display         = PC_WRITE2;
    readA_sel       = DC5; // 5 bits
    readB_sel       = DC5; // 5 bits
    readC_sel       = DC5; // 5 bits
    readD_sel       = DC5; // 5 bits
    write1_sel      = DC5; // 5 bits
    write2_sel      = PC ; // 5 bits

    write1_en       = 0; // 1 bit
    write2_en       = 1; // 1 bit
    write1_in       = 32'hbeeffeed; // 32 bits
    write2_in       = DC32; // 32 bits
    immediate1_in   = DC32; // 32 bits
    immediate2_in   = DC32; // 32 bits
    next_pc_in      = 32'h0000fefe; // 32 bits
    next_cpsr_in    = DC4; // 4  bits
    next_sp_in      = DC32; // 32 bits
    next_pc_en      = 1; // 1 bit

    // test PC_WRITE3
    // 9
    #2;
    i = i+1;
    display         = PC_WRITE3;
    readA_sel       = DC5; // 5 bits
    readB_sel       = DC5; // 5 bits
    readC_sel       = DC5; // 5 bits
    readD_sel       = DC5; // 5 bits
    write1_sel      = PC; // 5 bits
    write2_sel      = PC ; // 5 bits

    write1_en       = 1; // 1 bit
    write2_en       = 1; // 1 bit
    write1_in       = 32'hdeaddead; // 32 bits
    write2_in       = DC32; // 32 bits
    immediate1_in   = DC32; // 32 bits
    immediate2_in   = DC32; // 32 bits
    next_pc_in      = 32'h0000fefe; // 32 bits
    next_cpsr_in    = DC4; // 4  bits
    next_sp_in      = DC32; // 32 bits
    next_pc_en      = 1; // 1 bit

    // test regA_out_immediate
    // 10
    #2;
    i = i+1;
    display         = REG_A_IMM;
    readA_sel       = IMM; // 5 bits
    readB_sel       = DC5; // 5 bits
    readC_sel       = DC5; // 5 bits
    readD_sel       = DC5; // 5 bits
    write1_sel      = PC; // 5 bits
    write2_sel      = PC ; // 5 bits

    write1_en       = DC; // 1 bit
    write2_en       = DC; // 1 bit
    write1_in       = DC32; // 32 bits
    write2_in       = DC32; // 32 bits
    immediate1_in   = 32'hdeedfaad; // 32 bits
    immediate2_in   = DC32; // 32 bits
    next_pc_in      = DC32; // 32 bits
    next_cpsr_in    = DC4; // 4  bits
    next_sp_in      = DC32; // 32 bits
    next_pc_en      = DC; // 1 bit

    // test regB_out_immediate
    // 11
    #2;
    i = i+1;
    display         = REG_B_IMM;
    readA_sel       = DC5; // 5 bits
    readB_sel       = IMM; // 5 bits
    readC_sel       = DC5; // 5 bits
    readD_sel       = DC5; // 5 bits
    write1_sel      = R0; // 5 bits
    write2_sel      = PC ; // 5 bits

    write1_en       = 1; // 1 bit
    write2_en       = DC; // 1 bit
    write1_in       = 32'hedededed; // 32 bits
    write2_in       = DC32; // 32 bits
    immediate1_in   = DC32; // 32 bits
    immediate2_in   = 32'hdeedfaad; // 32 bits
    next_pc_in      = DC32; // 32 bits
    next_cpsr_in    = DC4; // 4  bits
    next_sp_in      = DC32; // 32 bits
    next_pc_en      = DC; // 1 bit

    // test regC_out_R0
    // 12
    #2;
    i = i+1;
    display         = REG_C_R0;
    readA_sel       = DC5; // 5 bits
    readB_sel       = DC5; // 5 bits
    readC_sel       = R0; // 5 bits
    readD_sel       = DC5; // 5 bits
    write1_sel      = PC; // 5 bits
    write2_sel      = PC ; // 5 bits

    write1_en       = DC; // 1 bit
    write2_en       = DC; // 1 bit
    write1_in       = DC32; // 32 bits
    write2_in       = DC32; // 32 bits
    immediate1_in   = DC32; // 32 bits
    immediate2_in   = DC32; // 32 bits
    next_pc_in      = DC32; // 32 bits
    next_cpsr_in    = DC4; // 4  bits
    next_sp_in      = DC32; // 32 bits
    next_pc_en      = DC; // 1 bit

    // test regA_out_R0
    // 13
    #2;
    i = i+1;
    display         = REG_A_R0;
    readA_sel       = R0; // 5 bits
    readB_sel       = DC5; // 5 bits
    readC_sel       = R0; // 5 bits
    readD_sel       = DC5; // 5 bits
    write1_sel      = PC; // 5 bits
    write2_sel      = PC ; // 5 bits

    write1_en       = DC; // 1 bit
    write2_en       = DC; // 1 bit
    write1_in       = DC32; // 32 bits
    write2_in       = DC32; // 32 bits
    immediate1_in   = DC32; // 32 bits
    immediate2_in   = DC32; // 32 bits
    next_pc_in      = DC32; // 32 bits
    next_cpsr_in    = DC4; // 4  bits
    next_sp_in      = DC32; // 32 bits
    next_pc_en      = DC; // 1 bit

    // test write 2 simultaneous
    // 14
    #2;
    i = i+1;
    display         = WRITE_2_SIMULT;
    readA_sel       = DC5; // 5 bits
    readB_sel       = DC5; // 5 bits
    readC_sel       = R0; // 5 bits
    readD_sel       = DC5; // 5 bits
    write1_sel      = R0; // 5 bits
    write2_sel      = R7 ; // 5 bits

    write1_en       = 1; // 1 bit
    write2_en       = 1; // 1 bit
    write1_in       = 32'h00000001; // 32 bits
    write2_in       = 32'ha0000000; // 32 bits
    immediate1_in   = DC32; // 32 bits
    immediate2_in   = DC32; // 32 bits
    next_pc_in      = DC32; // 32 bits
    next_cpsr_in    = DC4; // 4  bits
    next_sp_in      = DC32; // 32 bits
    next_pc_en      = DC; // 1 bit

    // test write 2 simultaneous on the same register
    // 15
    #2;
    i = i+1;
    display         = WRITE_2_SAME_REG;
    readA_sel       = DC5; // 5 bits
    readB_sel       = DC5; // 5 bits
    readC_sel       = R0; // 5 bits
    readD_sel       = DC5; // 5 bits
    write1_sel      = R6; // 5 bits
    write2_sel      = R6 ; // 5 bits

    write1_en       = 1; // 1 bit
    write2_en       = 1; // 1 bit
    write1_in       = 32'h00000001; // 32 bits
    write2_in       = 32'ha0000000; // 32 bits
    immediate1_in   = DC32; // 32 bits
    immediate2_in   = DC32; // 32 bits
    next_pc_in      = DC32; // 32 bits
    next_cpsr_in    = DC4; // 4  bits
    next_sp_in      = DC32; // 32 bits
    next_pc_en      = DC; // 1 bit


   $finish;
end
endmodule
