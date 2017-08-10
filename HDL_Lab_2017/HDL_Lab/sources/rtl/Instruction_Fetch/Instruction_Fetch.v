module Instruction_Fetch(

input wire clk, 
input wire reset, 

input wire stall_decoder_in, 
input wire memory_output_valid, 

input wire [31:0] current_pc_in, 
input wire [15:0] instruction_in, 

output reg memory_load_request, 
output reg incremented_pc_write_enable, 
output reg instruction_valid,  

output reg [11:0] memory_address, 
output reg [31:0] incremented_pc_out, 
output reg [15:0] instruction_out

// synthesis translate off
,
output reg        finish_out
// synthesis translate on
);


localparam[1:0]
RESET = 2'b00,
WAIT_FOR_DEC = 2'b01,
FETCH = 2'b10,
FINISHED = 2'b11;

reg[1:0] currentState, nextState;

reg        update_instruction_reg;
reg [15:0] fetched_instruction_reg;

wire [32:0] current_pc_modified;
assign current_pc_modified = current_pc_in - 2;


// synthesis translate off
reg        next_finish_out;
reg        first_instruction_fetched;
// synthesis translate on


always@(*) begin



case(currentState)
	RESET: begin
		nextState = (reset == 1) ? RESET : FETCH;
		incremented_pc_out = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
		incremented_pc_write_enable = 1'b0;
        memory_address = 12'b0000_0000_0000;
		memory_load_request = 1'b0;
		instruction_out = 16'b1011_1111_0000_0000;
		update_instruction_reg = 1'b0;
		instruction_valid = 1'b0;
		// synthesis translate off
		next_finish_out = 1'b0;
		// synthesis translate on
	end
	WAIT_FOR_DEC: begin
		nextState = (stall_decoder_in == 1) ? WAIT_FOR_DEC : FETCH;
		incremented_pc_out = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
		incremented_pc_write_enable = 1'b0;
		memory_address = {1'b0, current_pc_modified[31:1]};
		memory_load_request = 1'b0;
		instruction_out = fetched_instruction_reg;
		update_instruction_reg = 1'b0;
		instruction_valid = 1'b0;
        // synthesis translate off
		next_finish_out = 1'b0;
		// synthesis translate on
	end
	FETCH: begin
		nextState = 
                      // synthesis translate off
		              ( (({1'b0, current_pc_modified[31:1]} == 32'b0000_0000_0000_0000_0000_0000_0000_0000) & first_instruction_fetched)  ?   FINISHED  :  
		              // synthesis translate on
		              ((memory_output_valid == 1) ? WAIT_FOR_DEC : FETCH)
		              // synthesis translate off
		              )
		              // synthesis translate on
		              ;
		incremented_pc_out = current_pc_in + 2;
        incremented_pc_write_enable = (memory_output_valid == 1) ? 1'b1 : 1'b0;
		memory_load_request = 1'b1;
		instruction_out =  (memory_output_valid == 1) ? instruction_in : 16'b1011_1111_0000_0000;
		update_instruction_reg = (memory_output_valid == 1) ? 1'b1 : 1'b0;
		memory_address = {1'b0, current_pc_modified[31:1]};
		instruction_valid = (memory_output_valid == 1) ? 1'b1 : 1'b0;
        // synthesis translate off
		next_finish_out = 1'b0;
		// synthesis translate on
	end
    FINISHED: begin
		nextState = FINISHED;
		incremented_pc_out = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
        incremented_pc_write_enable = 1'b0;
		memory_load_request = 1'b1;
		instruction_out = 16'b1011_1111_0000_0000;
		update_instruction_reg = 1'b0;
		memory_address = 12'b0000_0000_0000;
		instruction_valid = 1'b0;
        // synthesis translate off
		next_finish_out = 1'b1;
		// synthesis translate on
	end
	default: begin
		memory_load_request = 1'bx;
		instruction_out = 16'bx;
		memory_address = 12'bx;
		incremented_pc_write_enable = 1'bx;
		nextState = WAIT_FOR_DEC;
		incremented_pc_out = 32'bx;
		instruction_valid = 0;
        // synthesis translate off
		next_finish_out = 1'b0;
		// synthesis translate on
	end
endcase
end

always@(posedge clk) begin
	if(reset) begin
        currentState <= RESET;
        // synthesis translate off
        finish_out <= 1'b0;
        // synthesis translate on
	end
	else begin
        currentState <= nextState; 
        // synthesis translate off
        finish_out <= next_finish_out;
        // synthesis translate on
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

//synthesis translate off
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
//synthesis translate on



endmodule
