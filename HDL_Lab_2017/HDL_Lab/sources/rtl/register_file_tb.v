`define R0 4'b0000
`define R1 4'b0001
`define R2 4'b0010
`define R3 4'b0011
`define R4 4'b0100
`define R5 4'b0101
`define R6 4'b0110
`define R7 4'b0111

`define SP 4'b1000
`define PC 4'b1001
`define LR 4'b1010
`define IMM 4'b1111

`timescale 1ns/10ps
module register_file_tb ();

// needed wires
reg [31:0] write_in, immediate1_in, immediate2_in, next_pc, cpsr_in;
wire [31:0] regA, regB, regC, pc_out, cpsr_out;
reg clk, write_en, pc_en;
reg [3:0] regA_sel, regB_sel, regC_sel, write_dest;

//dut
register_file rf (
.regA_select(regA_sel),
.regB_select(regB_sel),
.regC_select(regC_sel),
.write_dest(write_dest),
.write_en(write_en),
.write_in(write_in),
.immediate1_in(immediate1_in),
.immediate2_in(immediate2_in),
.cpsr_in(cpsr_in),
.next_pc(next_pc),
.pc_en(pc_en),
.clk(clk),
.regA_out(regA),
.regB_out(regB),
.regC_out(regC),
.pc_out(pc_out),
.cpsr_out(cpsr_out)
);


initial begin
   // 1 bit signals
   clk = 1;
   pc_en = 1;
   write_en = 0;

   // 4 bit signals
   regA_sel = `R0;
   regB_sel = `R0;
   regC_sel = `R0;
   write_dest = `R1;

   // 32 bit signals
   write_in = 32'h0;
   immediate1_in = 32'h11;
   immediate2_in = 32'h22;
   cpsr_in = 32'h0;
   next_pc = 32'h0;
end

// some clock action
always begin
#5 clk = !clk;
end

initial begin
   $dumpfile("register_file.vcd");
   $dumpvars;

   //$display("\t\ttime,\tclk");
   $monitor("%d,\t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b,, \t%b, \t%b, \t%b",
   $time,
    clk,
    pc_en,
    write_en,
    regA_sel,
    regB_sel,
    regC_sel,
    write_dest,
    write_in,
    immediate1_in,
    immediate2_in,
    cpsr_in,
    next_pc,
    regA,
    regB,
    regC,
    pc_out,
    cpsr_out);
end

initial begin

   #10;
   // write deadbeef to r0
   write_en = 1;
   write_dest = `R0;
   write_in = 32'hdeadbeef;

   #10;
   // change output to R1
   regA_sel = `R1;
   write_in = 32'headabed;
   write_dest = `R2;
   next_pc = 32'h4;

   #10;
   // change something with pc, without enable
   next_pc = 32'h8;
   pc_en = 0;

   // more changes, no enable for pc
   #10;
   next_pc = 32'hc;
   pc_en = 0;

   // allow pc changes again
   #10;
   pc_en = 1;

   // apply changes to registers
   #10;
   regA_sel = `IMM;
   immediate1_in = 32'habababab;

   #10;
   regB_sel = `IMM;
   regA_sel = `R0;
   immediate1_in = 32'hdededede;

   #10;
   regB_sel = `R2;
   regA_sel = `PC;
   write_en = 0;
   write_in = 32'hdeedaaaa;

   #10;
   write_en = 1;

   #10;
   next_pc = 32'hf;

   #9;
   next_pc = 32'h10;
  write_dest = `PC;
  write_in = 32'heeeeffff;
  write_en = 1;

  #9;
  write_en = 0;
  pc_en = 0;

  #12;
  pc_en = 0;
  next_pc = 32'h32;

  #9;
  immediate2_in = 32'hbeebbaab;
  regA_sel = `IMM;
  regB_sel = `IMM;

  #10;
  regC_sel = `R4;

  #10;
  regC_sel = `R1;
   #200;
   $finish;
end
endmodule

`undef R0
`undef R1
`undef R2
`undef R3
`undef R4
`undef R5
`undef R6
`undef R7

`undef PC
`undef LR
`undef IMM
`undef SP
