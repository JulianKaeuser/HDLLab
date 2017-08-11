module Instruction_Fetch_v3(

input wire clk, 
input wire reset, 

input wire stall_decoder_in, 
input wire memory_output_valid, 

input wire [31:0] current_pc_in, 
input wire [15:0] instruction_in, 

output reg memory_load_request, 
output reg incremented_pc_write_enable, 
output reg instruction_valid,  

output reg [12:0] memory_address, 
output reg [31:0] incremented_pc_out, 
output reg [15:0] instruction_out,

output reg  if_memory_active

//  *disabled*// synthesis translate_off
,
output reg        finish_out
//  *disabled*// synthesis translate_on
);


localparam[2:0]
RESET = 3'b000,
WAIT_FOR_DEC = 3'b001,
FETCH1 = 3'b010,
FETCH2 = 3'b011,
FINISHED = 3'b100;

reg[2:0] currentState, nextState;

reg        update_instruction_reg;
reg [15:0] fetched_instruction_reg;

wire [32:0] current_pc_modified;
assign current_pc_modified = current_pc_in - 2;


//  *disabled*// synthesis translate_off
reg        next_finish_out;
reg        first_instruction_fetched;
//  *disabled*// synthesis translate_on


always@(*) begin



case(currentState)
	RESET: begin
		nextState = (reset == 1) ? RESET : FETCH1;
		incremented_pc_out = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
		incremented_pc_write_enable = 1'b0;
        memory_address = 13'b0_0000_0000_0000;
		memory_load_request = 1'b0;
		instruction_out = 16'b1011_1111_0000_0000;
		update_instruction_reg = 1'b0;
		instruction_valid = 1'b0;
		
		if_memory_active = 1'b0;
		
		//  *disabled*// synthesis translate_off
		next_finish_out = 1'b0;
		//  *disabled*// synthesis translate_on
	end
	WAIT_FOR_DEC: begin
		nextState = (stall_decoder_in == 1) ? WAIT_FOR_DEC : FETCH1;
		incremented_pc_out = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
		incremented_pc_write_enable = 1'b0;
		memory_address = current_pc_modified[12:0];
		memory_load_request = 1'b0;
		instruction_out = fetched_instruction_reg;
		update_instruction_reg = 1'b0;
		instruction_valid = 1'b0;
		
		if_memory_active = 1'b0;
		
        //  *disabled*// synthesis translate_off
		next_finish_out = 1'b0;
		//  *disabled*// synthesis translate_on
	end
	FETCH1: begin
		nextState = FETCH2;
		incremented_pc_out = current_pc_in + 2;
        incremented_pc_write_enable = (memory_output_valid == 1) ? 1'b1 : 1'b0;
		memory_load_request = 1'b1;
		instruction_out =  (memory_output_valid == 1) ? instruction_in : 16'b1011_1111_0000_0000;
		update_instruction_reg = (memory_output_valid == 1) ? 1'b1 : 1'b0;
		memory_address = current_pc_modified[12:0];
		instruction_valid = (memory_output_valid == 1) ? 1'b1 : 1'b0;
		
		if_memory_active = 1'b1;
		
        //  *disabled*// synthesis translate_off
		next_finish_out = 1'b0;
		//  *disabled*// synthesis translate_on
	end
    FETCH2: begin
		nextState = 
                      //  *disabled*// synthesis translate_off
		              ( (({1'b0, current_pc_modified[31:1]} == 32'b0000_0000_0000_0000_0000_0000_0000_0000) & first_instruction_fetched)  ?   FINISHED  :  
		              //  *disabled*// synthesis translate_on
		              ((memory_output_valid == 1) ? WAIT_FOR_DEC : FETCH2)
		              //  *disabled*// synthesis translate_off
		              )
		              //  *disabled*// synthesis translate_on
		              ;
		incremented_pc_out = current_pc_in + 2;
        incremented_pc_write_enable = (memory_output_valid == 1) ? 1'b1 : 1'b0;
		memory_load_request = 1'b0;
		instruction_out =  (memory_output_valid == 1) ? instruction_in : 16'b1011_1111_0000_0000;
		update_instruction_reg = (memory_output_valid == 1) ? 1'b1 : 1'b0;
		memory_address = current_pc_modified[12:0];
		instruction_valid = (memory_output_valid == 1) ? 1'b1 : 1'b0;
		
		if_memory_active = 1'b1;
		
        //  *disabled*// synthesis translate_off
		next_finish_out = 1'b0;
		//  *disabled*// synthesis translate_on
	end
    FINISHED: begin
		nextState = FINISHED;
		incremented_pc_out = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
        incremented_pc_write_enable = 1'b0;
		memory_load_request = 1'b1;
		instruction_out = 16'b1011_1111_0000_0000;
		update_instruction_reg = 1'b0;
		memory_address = 13'b0_0000_0000_0000;
		instruction_valid = 1'b0;
		
		if_memory_active = 1'b0;
		
        //  *disabled*// synthesis translate_off
		next_finish_out = 1'b1;
		//  *disabled*// synthesis translate_on
	end
	default: begin
		memory_load_request = 1'bx;
		instruction_out = 16'bx;
		memory_address = 13'bx;
		incremented_pc_write_enable = 1'bx;
		nextState = WAIT_FOR_DEC;
		incremented_pc_out = 32'bx;
		instruction_valid = 0;
		
		if_memory_active = 1'b0;
		
        //  *disabled*// synthesis translate_off
		next_finish_out = 1'b0;
		//  *disabled*// synthesis translate_on
	end
endcase
end

always@(posedge clk) begin
	if(reset) begin
        currentState <= RESET;
	end
	else begin
        currentState <= nextState; 
	end 
end

always@(posedge clk) begin
	if(reset) begin
        fetched_instruction_reg <= 16'b1011_1111_0000_0000;
	end
	else if(update_instruction_reg) begin
        fetched_instruction_reg <= instruction_in;
	end
	else begin
        fetched_instruction_reg <= fetched_instruction_reg;
	end
	
end

//  *disabled*// synthesis translate_off
always@(posedge clk) begin
	if(reset) begin
        first_instruction_fetched <= 1'b0;
	end
	else if( ({1'b0, current_pc_modified[31:1]} == 32'b0000_0000_0000_0000_0000_0000_0000_0000) & memory_output_valid) begin
        first_instruction_fetched <= 1'b1;
	end
	else begin
        first_instruction_fetched <= first_instruction_fetched;
	end
end

always@(posedge clk) begin
	if(reset) begin
        finish_out <= 1'b0;
	end
	else begin
        finish_out <= next_finish_out;
	end 
end
//  *disabled*// synthesis translate_on



endmodule
