`define BIT_SIZE 32

module ALU_VARIABLE (input wire signed [`BIT_SIZE-1:0] a, b, input wire [3:0] op, input wire c_in, output reg signed [`BIT_SIZE-1:0] result, output reg c_out, z, n, v);


	always @(a, b, c_in, op) begin
		case (op)
			4'b0000: begin // AND
				{c_out, result} = {1'b0,  a & b};
				z = (result == {`BIT_SIZE{1'b0}}) ? 1'b1 : 1'b0;
				n = (result[`BIT_SIZE-1] == 1'b1) ? 1'b1 : 1'b0;
				v = 1'b0;
				end
			4'b0001: begin // EOR
				{c_out, result} = {1'b0,  a ^ b};
				z = (result == {`BIT_SIZE{1'b0}}) ? 1'b1 : 1'b0;
				n = (result[`BIT_SIZE-1] == 1'b1) ? 1'b1 : 1'b0;
				v = 1'b0;
				end
			4'b0010: begin // LSL
				{c_out, result} = {1'b0,  a << b};
				z = (result == {`BIT_SIZE{1'b0}}) ? 1'b1 : 1'b0;
				n = (result[`BIT_SIZE-1] == 1'b1) ? 1'b1 : 1'b0;
				v = 1'b0;
				end
			4'b0011: begin // LSR
				{c_out, result} = {1'b0,  a >> b};
				z = (result == {`BIT_SIZE{1'b0}}) ? 1'b1 : 1'b0;
				n = (result[`BIT_SIZE-1] == 1'b1) ? 1'b1 : 1'b0;
				v = 1'b0; 
				end
			4'b0100: begin // ASR
				{c_out, result} = {1'b0,  a >>> b};
				z = (result == {`BIT_SIZE{1'b0}}) ? 1'b1 : 1'b0;
				n = (result[`BIT_SIZE-1] == 1'b1) ? 1'b1 : 1'b0;
				v = 1'b0;
				end
			4'b0101: begin// ADC
				{c_out, result} = a + b + c_in;
				z = (result == {`BIT_SIZE{1'b0}}) ? 1'b1 : 1'b0;
				n = (result[`BIT_SIZE-1] == 1'b1) ? 1'b1 : 1'b0;
				v = ((a[`BIT_SIZE-1] == b[`BIT_SIZE-1]) && (c_out != a[`BIT_SIZE-1])) ? 1'b1 : 1'b0;
				end
			4'b0110: begin // SBC
				{c_out, result} = a - b - (c_in ?  0 : 1);
				z = (result == {`BIT_SIZE{1'b0}}) ? 1'b1 : 1'b0;
				n = (result[`BIT_SIZE-1] == 1'b1) ? 1'b1 : 1'b0;
				v = (a[`BIT_SIZE-1]!=b[`BIT_SIZE-1] && c_out == a[`BIT_SIZE-1]) ? 1'b1 : 1'b0;
				end
			4'b0111: begin // ROR
				{c_out, result} = {1'b0, (a >> (b[`BIT_SIZE-2:0]%`BIT_SIZE))|(a << (`BIT_SIZE-b[`BIT_SIZE-2:0]%`BIT_SIZE))};
				z = (result == {`BIT_SIZE{1'b0}}) ? 1'b1 : 1'b0;
				n = (result[`BIT_SIZE-1] == 1'b1) ? 1'b1 : 1'b0;
				v = 1'b0;
				end 
			4'b1000: begin // TST
				{c_out, result} = {1'b0, a & b};
				z = (result == {`BIT_SIZE{1'b0}}) ? 1'b1 : 1'b0;
				n = (result[`BIT_SIZE-1] == 1'b1) ? 1'b1 : 1'b0;
				v = 1'b0;
				end
			4'b1001: begin // NEG
				{c_out, result} = 0 - a;
				z = (result == {`BIT_SIZE{1'b0}}) ? 1'b1 : 1'b0;
				n = (result[`BIT_SIZE-1] == 1'b1) ? 1'b1 : 1'b0;
				v = (c_out == result[`BIT_SIZE-1]) ? 1'b0 : 1'b1;
				end
			4'b1010: begin // CMP
				{c_out, result} =  a - b;
				z = (result == {`BIT_SIZE{1'b0}}) ? 1'b1 : 1'b0;
				n = (result[`BIT_SIZE-1] == 1'b1) ? 1'b1 : 1'b0;
				v = (a[`BIT_SIZE-1]!=b[`BIT_SIZE-1] && c_out == a[`BIT_SIZE-1]) ? 1'b1 : 1'b0;
				end
			4'b1011: begin // CMN
				{c_out, result} =  a + b;
				z = (result == {`BIT_SIZE{1'b0}}) ? 1'b1 : 1'b0;
				n = (result[`BIT_SIZE-1] == 1'b1) ? 1'b1 : 1'b0;
				v = ((a[`BIT_SIZE-1] == b[`BIT_SIZE-1]) && (c_out != a[`BIT_SIZE-1])) ? 1'b1 : 1'b0;
				end
			4'b1100: begin // ORR
				{c_out, result} = {1'b0,  a | b};
				z = (result == {`BIT_SIZE{1'b0}}) ? 1'b1 : 1'b0; 
				n = (result[`BIT_SIZE-1] == 1'b1) ? 1'b1 : 1'b0;
				v = 1'b0;
				end
			4'b1101: begin // MUL
				{c_out, result} =  a * b;
				z = (result == {`BIT_SIZE{1'b0}}) ? 1'b1 : 1'b0;
				n = (result[`BIT_SIZE-1] == 1'b1) ? 1'b1 : 1'b0;
				v = (c_out == result[`BIT_SIZE-1]) ? 1'b0 : 1'b1;
				end
			4'b1110: begin // BIC
				{c_out, result} = {1'b0,  a & (~b)};
				z = (result == {`BIT_SIZE{1'b0}}) ? 1'b1 : 1'b0;
				n = (result[`BIT_SIZE-1] == 1'b1) ? 1'b1 : 1'b0;
				v = 1'b0;
				end
			4'b1111: begin // MVN
				{c_out, result} = {1'b0, ~a};
				z = (result == {`BIT_SIZE{1'b0}}) ? 1'b1 : 1'b0;
				n = (result[`BIT_SIZE-1] == 1'b1) ? 1'b1 : 1'b0;
				v = 1'b0;
				end
			default: {c_out, result, z, n, v} = {1'bx, {`BIT_SIZE{1'bx}}, 1'bx, 1'bx, 1'bx}; // default: undefined result
		endcase
		
	end
endmodule
