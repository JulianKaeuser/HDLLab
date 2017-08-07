// AUTHORS: Group 06 /Julian Käuser
// Friday 08/04/2017

// needed: 17 registers:
// r0-r12
// r13 = SP
// r14 = LR
// r15 = PC
// r16 = tmp1
// r17 =



module register_file (
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
regD_out,
pc_out,
cpsr_out,
sp_out
);


localparam WIDE = 32;

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

input [4:0] readA_sel;
input [4:0] readB_sel;
input [4:0] readC_sel;
input [4:0] readD_sel;
input [4:0] write1_sel;
input [4:0] write2_sel;
input write1_en;
input write2_en;
input [WIDE-1:0] write1_in;
input [WIDE-1:0] write2_in;
input [WIDE-1:0] immediate1_in;
input [WIDE-1:0] immediate2_in;
input [WIDE-1:0] next_pc_in;
input [3:0] next_cpsr_in;
input [WIDE-1:0] next_sp_in;
input next_pc_en;
input clk;


output reg [WIDE-1:0] regA_out;
output reg [WIDE-1:0] regB_out;
output reg [WIDE-1:0] regC_out;
output reg [WIDE-1:0] regD_out;
output [WIDE-1:0] pc_out;
output [3:0]      cpsr_out;
output [WIDE-1:0] sp_out;




//registers
reg [WIDE-1:0] r0;
reg [WIDE-1:0] r1;
reg [WIDE-1:0] r2;
reg [WIDE-1:0] r3;
reg [WIDE-1:0] r4;
reg [WIDE-1:0] r5;
reg [WIDE-1:0] r6;
reg [WIDE-1:0] r7;
reg [WIDE-1:0] r8;
reg [WIDE-1:0] r9;
reg [WIDE-1:0] r10;
reg [WIDE-1:0] r11;
reg [WIDE-1:0] r12;

reg [WIDE-1:0] lr;
reg [WIDE-1:0] sp;
reg [WIDE-1:0] pc;
reg [3:0]      cpsr;
reg [WIDE-1:0] tmp1;

// input wires
reg [WIDE-1:0] r0in;
reg [WIDE-1:0] r1in;
reg [WIDE-1:0] r2in;
reg [WIDE-1:0] r3in;
reg [WIDE-1:0] r4in;
reg [WIDE-1:0] r5in;
reg [WIDE-1:0] r6in;
reg [WIDE-1:0] r7in;
reg [WIDE-1:0] r8in;
reg [WIDE-1:0] r9in;
reg [WIDE-1:0] r10in;
reg [WIDE-1:0] r11in;
reg [WIDE-1:0] r12in;

reg [WIDE-1:0] lrin;
reg [WIDE-1:0] spin;
reg [WIDE-1:0] pcin;
wire [3:0]      cpsrin;
reg [WIDE-1:0] tmp1in;
//regA out assignment with multiplexor
always @(*) begin
    case(readA_sel)
       R0   : regA_out = r0;
       R1   : regA_out = r1;
       R2   : regA_out = r2;
       R3   : regA_out = r3;
       R4   : regA_out = r4;
       R5   : regA_out = r5;
       R6   : regA_out = r6;
       R7   : regA_out = r7;
       R8   : regA_out = r8;
       R9   : regA_out = r9;
       R10  : regA_out = r10;
       R11  : regA_out = r11;
       R12  : regA_out = r12;
       SP   : regA_out = sp;
       LR   : regA_out = lr;
       PC   : regA_out = pc;
       TMP1 : regA_out = tmp1;
       IMM  : regA_out = immediate1_in; // reg A can only pass immediate1 in
      //default : regA_out = BITWIDTH'b0;
    endcase
end

// regB out assignment with multiplexor
always @(*) begin
    case(readB_sel)
      R0   : regB_out = r0;
      R1   : regB_out = r1;
      R2   : regB_out = r2;
      R3   : regB_out = r3;
      R4   : regB_out = r4;
      R5   : regB_out = r5;
      R6   : regB_out = r6;
      R7   : regB_out = r7;
      R8   : regB_out = r8;
      R9   : regB_out = r9;
      R10  : regB_out = r10;
      R11  : regB_out = r11;
      R12  : regB_out = r12;
      SP   : regB_out = sp;
      LR   : regB_out = lr;
      PC   : regB_out = pc;
      TMP1 : regB_out = tmp1;
      IMM  : regB_out = immediate2_in; // regB can only pass immediate 2 in
    endcase
end

// regC out assignment with multiplexor
always @(*) begin
    case(readC_sel)
      R0   : regC_out = r0;
      R1   : regC_out = r1;
      R2   : regC_out = r2;
      R3   : regC_out = r3;
      R4   : regC_out = r4;
      R5   : regC_out = r5;
      R6   : regC_out = r6;
      R7   : regC_out = r7;
      R8   : regC_out = r8;
      R9   : regC_out = r9;
      R10  : regC_out = r10;
      R11  : regC_out = r11;
      R12  : regC_out = r12;
      SP   : regC_out = sp;
      LR   : regC_out = lr;
      PC   : regC_out = pc;
      //TMP1 :
      //IMM  :
   endcase
end

// regD out assignment with multiplexor
always @(*) begin
    case(readD_sel)
      R0   : regD_out = r0;
      R1   : regD_out = r1;
      R2   : regD_out = r2;
      R3   : regD_out = r3;
      R4   : regD_out = r4;
      R5   : regD_out = r5;
      R6   : regD_out = r6;
      R7   : regD_out = r7;
      R8   : regD_out = r8;
      R9   : regD_out = r9;
      R10  : regD_out = r10;
      R11  : regD_out = r11;
      R12  : regD_out = r12;
      SP   : regD_out = sp;
      LR   : regD_out = lr;
      PC   : regD_out = pc;
      //TMP1 :
      //IMM  :
   endcase
end

// pc out assignment
assign pc_out = pc;

//cpsr_out assignment
assign cpsr_out = cpsr;

assign sp_out = sp;

// all registers are assigned a value in every clock cycle; if not selected from write port, it is the old one

// r0
always @(*) begin
    if (write1_sel==R0 && write1_en)
        r0in = write1_in;
    else if (write2_sel==R0 && write2_en)
        r0in = write2_in;
    else
        r0in= r0;
end

// r1
always @(*) begin
    if (write1_sel==R1 && write1_en)
        r1in = write1_in;
    else if (write2_sel==R1 && write2_en)
        r1in = write2_in;
    else
        r1in= r1;
end

// r2
always @(*) begin
    if (write1_sel==R2 && write1_en)
        r2in = write1_in;
    else if (write2_sel==R2 && write2_en)
        r2in = write2_in;
    else
        r2in= r2;
end

// r3
always @(*) begin
    if (write1_sel==R3 && write1_en)
        r3in = write1_in;
    else if (write2_sel==R2 && write2_en)
        r3in = write2_in;
    else
        r3in= r3;
end

// r4
always @(*) begin
    if (write1_sel==R4 && write1_en)
        r4in = write1_in;
    else if (write2_sel==R4 && write2_en)
        r4in = write2_in;
    else
        r4in= r4;
end

// r5
always @(*) begin
    if (write1_sel==R5 && write1_en)
        r5in = write1_in;
    else if (write2_sel==R5 && write2_en)
        r5in = write2_in;
    else
        r5in= r5;
end

// r6
always @(*) begin
    if (write1_sel==R6 && write1_en)
        r6in = write1_in;
    else if (write2_sel==R6 && write2_en)
        r6in = write2_in;
    else
        r6in= r6;
end

// r7
always @(*) begin
    if (write1_sel==R7 && write1_en)
        r7in = write1_in;
    else if (write2_sel==R7 && write2_en)
        r7in = write2_in;
    else
        r7in= r7;
end

// r8
always @(*) begin
    if (write1_sel==R8 && write1_en)
        r8in = write1_in;
    else if (write2_sel==R8 && write2_en)
        r8in = write2_in;
    else
        r8in= r8;
end

// r9
always @(*) begin
    if (write1_sel==R9 && write1_en)
        r9in = write1_in;
    else if (write2_sel==R9 && write2_en)
        r9in = write2_in;
    else
        r9in= r9;
end

// r10
always @(*) begin
    if (write1_sel==R10 && write1_en)
        r10in = write1_in;
    else if (write2_sel==R10 && write2_en)
        r10in = write2_in;
    else
        r10in= r10;
end

// r11
always @(*) begin
    if (write1_sel==R11 && write1_en)
        r11in = write1_in;
    else if (write2_sel==R11 && write2_en)
        r11in = write2_in;
    else
        r11in= r11;
end

// r12
always @(*) begin
    if (write1_sel==R12 && write1_en)
        r12in = write1_in;
    else if (write2_sel==R12 && write2_en)
        r12in = write2_in;
    else
        r12in= r12;
end
// special registers
// r13 = sp
always @(*) begin
    if (write1_sel==SP && write1_en)
        spin = write1_in;
    else if (write2_sel==SP && write2_en)
        spin = write2_in;
    else
        spin= next_sp_in;
end

// r14 = LR
always @(*) begin
    if (write1_sel==LR && write1_en)
        lrin = write1_in;
    else if (write2_sel==LR && write2_en)
        lrin = write2_in;
    else
        lrin= lr;
end

//PC output = r16
wire [WIDE-1:0] pc_write_in;
wire [WIDE-1:0] pc_pc_in;
wire pc_write_select;

assign pc_write_select = (write1_en && write1_sel==PC) | (write2_en && write2_sel==PC);

assign pc_pc_in        = next_pc_en ? next_pc_in : pc;
assign pc_write_in     = (write1_en && write1_sel==PC) ? write1_in : write2_in;

always @(*) begin
  pcin = pc_write_select ? pc_write_in : pc_pc_in;
end

// r17 = tmp;
always @(*) begin
    if (write1_sel==TMP1 && write1_en)
        tmp1in = write1_in;
    else if (write2_sel==TMP1 && write2_en)
        tmp1in = write2_in;
    else
        tmp1in= tmp1;
end

// cpsr
assign cpsrin = next_cpsr_in;


// make all registers flipflops:
always @(posedge clk) begin
   r0   <= r0in;
   r1   <= r1in;
   r2   <= r2in;
   r3   <= r3in;
   r4   <= r4in;
   r5   <= r5in;
   r6   <= r6in;
   r7   <= r7in;
   r8   <= r8in;
   r9   <= r9in;
   r10  <= r10in;
   r11  <= r11in;
   r12  <= r12in;
   lr   <= lrin;
   sp   <= spin;
   pc   <= pcin;
   cpsr <= cpsrin;
   tmp1 <= tmp1in;
end


endmodule
