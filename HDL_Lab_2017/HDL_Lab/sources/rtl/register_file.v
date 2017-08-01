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



module register_file (
regA_select,
regB_select,
regC_select,
write_dest,
write_en,
write_in,
immediate1_in,
immediate2_in,
cpsr_in,
next_pc,
pc_en,
clk,
regA_out,
regB_out,
regC_out,
pc_out,
cpsr_out
);

input [3:0] regA_select;
input [3:0] regB_select;
input [3:0] regC_select;
input [3:0] write_dest;
input [31:0] write_in;
input [31:0] next_pc;
input [31:0] immediate1_in;
input [31:0] immediate2_in;
input [31:0] cpsr_in;
input pc_en;
input write_en;
input clk;

output reg[31:0] regA_out;
output reg [31:0] regB_out;
output reg [31:0] regC_out;
output[31:0] pc_out;
output[31:0] cpsr_out;

//registers
reg [31:0] r0, r1, r2, r3, r4, r5, r6, r7, sp, pc, lr, cpsr;

wire [31:0] pc_input;
reg [31:0] r0in, r1in, r2in, r3in, r4in, r5in, r6in, r7in, spin, lrin, pcin, cpsrin;


// regA out assignment with multiplexor
always @(*) begin
    case(regA_select)
      `R0 : regA_out = r0;
      `R1 : regA_out = r1;
      `R2 : regA_out = r2;
      `R3 : regA_out = r3;
      `R4 : regA_out = r4;
      `R5 : regA_out = r5;
      `R6 : regA_out = r6;
      `R7 : regA_out = r7;
      `SP : regA_out = sp;
      `PC : regA_out = pc;
      `LR : regA_out = lr;
      `IMM : regA_out = immediate1_in;
      //default : regA_out = 32'b0;
    endcase
end

// regB out assignment with multiplexor
always @(*) begin
    case(regB_select)
      `R0 : regB_out = r0;
      `R1 : regB_out = r1;
      `R2 : regB_out = r2;
      `R3 : regB_out = r3;
      `R4 : regB_out = r4;
      `R5 : regB_out = r5;
      `R6 : regB_out = r6;
      `R7 : regB_out = r7;
      `SP : regB_out = sp;
      `PC : regB_out = pc;
      `LR : regB_out = lr;
      `IMM : regB_out = immediate2_in;
      //default : regA_out = 32'b0;
    endcase
end

// regC out assignment with multiplexor
always @(*) begin
    case(regC_select)
      `R0 : regC_out = r0;
      `R1 : regC_out = r1;
      `R2 : regC_out = r2;
      `R3 : regC_out = r3;
      `R4 : regC_out = r4;
      `R5 : regC_out = r5;
      `R6 : regC_out = r6;
      `R7 : regC_out = r7;
      `SP : regC_out = sp;
      `PC : regC_out = pc;
      `LR : regC_out = lr;
      `IMM : regC_out = immediate2_in;
      //default : regA_out = 32'b0;
    endcase
end

// pc out assignment
assign pc_out = pc;

//cpsr_out assignment
assign cpsr_out = cpsr;

// all registers are assigned a value

// r0
always @(*) begin
    if (write_dest==`R0 && write_en)
        r0in = write_in;
    else
        r0in= r0;
end

// r1
always @(*) begin
    if (write_dest==`R1 && write_en)
        r1in = write_in;
    else
        r1in= r1;
end

// r2
always @(*) begin
    if (write_dest==`R2 && write_en)
        r2in = write_in;
    else
        r2in= r2;
end

// r3
always @(*) begin
    if (write_dest==`R3 && write_en)
        r3in = write_in;
    else
        r3in= r3;
end

// r4
always @(*) begin
    if (write_dest==`R4 && write_en)
        r4in = write_in;
    else
        r4in= r4;
end

// r5
always @(*) begin
    if (write_dest==`R5 && write_en)
        r5in = write_in;
    else
        r5in= r5;
end

// r6
always @(*) begin
    if (write_dest==`R6 && write_en)
        r6in = write_in;
    else
        r6in= r6;
end

// r7
always @(*) begin
    if (write_dest==`R7 && write_en)
        r7in = write_in;
    else
        r7in= r7;
end

// sp
always @(*) begin
    if (write_dest==`SP && write_en)
        spin = write_in;
    else
        spin= sp;
end

// lr
always @(*) begin
    if (write_dest==`LR && write_en)
        lrin = write_in;
    else
        lrin= lr;
end

//PC output
always @(*) begin
if (write_dest==`PC  && write_en)
    pcin = write_in;
else
    pcin= (pc_en) ? next_pc: pc;
end

// make all registers flipflops:

always @(posedge clk) begin
    r0 <= r0in;
    r1 <= r1in;
    r2 <= r2in;
    r3 <= r3in;
    r4 <= r4in;
    r5 <= r5in;
    r6 <= r6in;
    r7 <= r7in;

    pc <= pcin;
    lr <= lrin;
    sp <= spin;
    cpsr <= cpsrin;
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
