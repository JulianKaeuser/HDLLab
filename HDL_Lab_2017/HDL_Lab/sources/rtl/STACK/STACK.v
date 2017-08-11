`define BIT_SIZE 32
`define DEPTH 64


module STACK(
	clk,
	reset,
	push_enable,
	pop_enable,
	read_enable,
	data_in, sp_in,
	data_out,
	sp_out
	);

	input clk;
	input reset;
	input push_enable;
	input pop_enable;
	input read_enable;
	input [`BIT_SIZE-1:0] data_in;
	input [`BIT_SIZE-1:0] sp_in;

	output reg[`BIT_SIZE-1:0] data_out;
	output reg[`BIT_SIZE-1:0] sp_out;

reg[`BIT_SIZE-1:0] stack[0:`DEPTH-1];

always@(posedge clk) begin
	if(reset == 1'b1) begin
		sp_out <= {`BIT_SIZE{1'b0}};
		data_out <= {`BIT_SIZE{1'bx}};
	end
	else if(push_enable == 1'b1) begin
		sp_out <= sp_in + 1;
		stack[sp_in] <= data_in;
	end
	else if(pop_enable == 1'b1) begin
		sp_out <= sp_in - 1;
		data_out <= stack[sp_in - 1];
	end
	else begin
		sp_out <= sp_in;
	end
end

/*always@(sp_in) begin
	$monitor("sp: %d | stack: %p", sp_in, stack);
end*/

endmodule
