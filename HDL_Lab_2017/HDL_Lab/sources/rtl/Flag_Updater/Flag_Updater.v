`define BIT_SIZE 32

module Flag_Updater (input wire  z, n, v, c, update_z, update_n, update_v, update_c, input wire [`BIT_SIZE-1:0] flags_old, output reg [`BIT_SIZE-1:0] flags) ;

	always @(*) begin
		flags[`BIT_SIZE-5:0] = flags_old[`BIT_SIZE-5:0];
		flags[`BIT_SIZE-1] = (update_n == 1)? n : flags_old[`BIT_SIZE-1];
		flags[`BIT_SIZE-2] = (update_z == 1)? z : flags_old[`BIT_SIZE-2];
		flags[`BIT_SIZE-3] = (update_c == 1)? c : flags_old[`BIT_SIZE-3];
		flags[`BIT_SIZE-4] = (update_v == 1)? v : flags_old[`BIT_SIZE-4];
	end

endmodule
