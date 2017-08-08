module Instruction_Fetch(

input clk, reset, stall_decoder_in, stall_memory, 
input[31:0] pc_in, 
input[15:0] instruction_in, 

output reg read_enable, pc_en, /*stall_decoder_out,*/  
output reg[11:0] address, 
output reg [31:0] pc_out, 
output reg[15:0] instruction_out

);


localparam[1:0]
A = 2'b01,
B = 2'b00,
C = 2'b10;
//D = 2'b11;

reg[1:0] currentState, nextState;
reg [15:0] instruction;

always@(currentState or stall_decoder_in or stall_memory or pc_in or instruction_in) begin
pc_out = pc_in + 4;


case(currentState)
		
	A: begin
		nextState = (reset == 1) ? A:B;
		pc_out = 32'b00000000000000000000000000000100;
		read_enable = 1'b1;
		pc_en = 1'b1;
		address = 12'b0;
		instruction = 16'b0001110000000000;
		//stall_decoder_out = 1'b0;
	end
	B: begin
		nextState = (stall_memory == 1 || stall_decoder_in == 1) ? B:C;
		read_enable = (stall_decoder_in == 0) ? 1'b1: 1'b0;
		pc_en = 1'b0;
		//stall_decoder_out = 1'b0;
		address = pc_in - 4;
		instruction = instruction_out;
	end
	/*C: begin
		nextState = (stall_memory == 0) ? C:D;
		read_enable = (stall_memory == 1) ? 1'b0:1'b1;
		pc_en = 1'b1;
		address = pc_in - 4;
		//stall_decoder_out = 1'b1;
		instruction = instruction_out;
	end
	D: begin
		nextState = (stall_memory == 1)? D: (stall_decoder_in == 1)? B: C;
		read_enable = 1'b0;
		//stall_decoder_out = 1'b1;
		instruction= (stall_memory == 1) ? instruction_out: instruction_in ;
		pc_en = 1'b1;
		address = 12'bx;
	end*/
	C: begin
		nextState = B;
		read_enable = 1'b0;
		//stall_decoder_out = 1'b1;
		instruction=  instruction_in ;
		pc_en = 1'b1;
		address = 12'bx;
	end
	default: begin
		read_enable = 1'bx;
		instruction = 16'bx;
		address = 12'bx;
		pc_en = 1'bx;
		nextState = B;
		pc_out = 32'bx;
		//stall_decoder_out = 1'bx;
	end
endcase
end

always@(posedge clk or posedge reset) begin
	if(reset) begin
	currentState <= A;
	instruction_out <= instruction;
	end
	
	else begin
	currentState <= nextState;
	instruction_out <= instruction;
	end 
end
endmodule
