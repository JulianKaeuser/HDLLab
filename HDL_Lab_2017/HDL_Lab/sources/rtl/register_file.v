module register_file (
regA_select, 
regB_select, 
write_dest, 
write_en,
write_in, 
next_pc,
pc_en,
clk, 
regA_out,
regB_out
)

input [3:0] regA_select, regB_select, write_dest;
input [31:0] write_in; 
input [31:0] next_pc;
input pc_en;
input write_en;
input clk;

output[31:0] regA_out, regB_out;

//registers
reg [31:0] r0, r1, r2, r3, r4, r5, r6, r7, sp, pc, lr;

// selection codes:
//4'h0 = r0


//make pc flipflop flipflops
always @(posedge clk) begin
    if (pc_en) 
	pc <= next_pc;
    else
        pc<=pc;
end

always @(posedge clk) begin
end





endmodule
