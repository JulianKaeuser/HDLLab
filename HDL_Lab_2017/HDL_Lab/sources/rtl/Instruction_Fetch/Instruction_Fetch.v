module Instruction_Fetch(

input clk, 
input reset, 

input stall_decoder_in, 
input memory_output_valid, 

input[31:0] current_pc_in, 
input[15:0] instruction_in, 

output reg memory_load_request, 
output reg incremented_pc_write_enable, 
output reg instruction_valid,  

output reg [11:0] memory_address, 
output reg [31:0] incremented_pc_out, 
output reg [15:0] instruction_out
);


localparam[1:0]
RESET = 2'b00,
WAIT_FOR_DEC = 2'b01,
FETCH = 2'b10,
FIRSTFETCH = 2'b11;

reg[1:0] currentState, nextState;

wire [32:0] current_pc_modified;
assign current_pc_modified = current_pc_in - 2;


always@(*) begin



case(currentState)
		
	RESET: begin
		nextState = (reset == 1) ? RESET : FETCH;
		incremented_pc_out = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
		incremented_pc_write_enable = 1'b0;
        memory_address = 12'b0000_0000_0000;
		memory_load_request = 1'b0;
		instruction_out = 16'b1011_1111_0000_0000;
		instruction_valid = 1'b0;
	end
	WAIT_FOR_DEC: begin
		nextState = (stall_decoder_in == 1) ? WAIT_FOR_DEC : FETCH;
		incremented_pc_out = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
		incremented_pc_write_enable = 1'b0;
		memory_address = {1'b0, current_pc_modified[31:1]};
		memory_load_request = 1'b0;
		instruction_out = 16'b1011_1111_0000_0000;
		instruction_valid = 1'b0;
	end
	FETCH: begin
		nextState = (memory_output_valid == 1) ? WAIT_FOR_DEC : FETCH;
		incremented_pc_out = current_pc_in + 2;
        incremented_pc_write_enable = (memory_output_valid == 1) ? 1'b1 : 1'b0;
		memory_load_request = 1'b1;
		instruction_out =  (memory_output_valid == 1) ? instruction_in : 16'b1011_1111_0000_0000;
		memory_address = {1'b0, current_pc_modified[31:1]};
		instruction_valid = (memory_output_valid == 1) ? 1'b1 : 1'b0;
	end
    FIRSTFETCH: begin
		nextState = (memory_output_valid == 1) ? WAIT_FOR_DEC : FIRSTFETCH;
		incremented_pc_out = current_pc_in;
        incremented_pc_write_enable = 1'b0;
		memory_load_request = 1'b1;
		instruction_out =  (memory_output_valid == 1) ? instruction_in : 16'b1011_1111_0000_0000;
		memory_address = 12'b0000_0000_0000;
		instruction_valid = (memory_output_valid == 1) ? 1'b1 : 1'b0;
	end
	default: begin
		memory_load_request = 1'bx;
		instruction_out = 16'bx;
		memory_address = 12'bx;
		incremented_pc_write_enable = 1'bx;
		nextState = WAIT_FOR_DEC;
		incremented_pc_out = 32'bx;
		instruction_valid = 0;
	end
endcase
end

always@(posedge clk or posedge reset) begin
	if(reset) begin
	currentState <= RESET;
	end
	
	else begin
	currentState <= nextState;
	end 
	
	
end
endmodule
