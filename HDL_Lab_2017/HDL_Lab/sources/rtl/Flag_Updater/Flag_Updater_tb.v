`define BIT_SIZE 32
`timescale 1ns/100ps

module Flag_Updater_tb();
	reg z, n, v, c, update_z, update_n, update_v, update_c;
	reg [`BIT_SIZE-1:0] flags_old;
	wire [`BIT_SIZE-1:0] flags;

Flag_Updater fu_inst(
	.z(z), .n(n), .v(v), .c(c), .update_z(update_z), .update_n(update_n), .update_v(update_v),
 	.update_c(update_c), .flags_old(flags_old), .flags(flags)
);

initial begin
	$monitor("%g\t z: %b n: %b v: %b c: %b update_z: %b update_n: %b update_v: %b update_c: %b flags_old: %b | flags: %b",
	$time, z, n, v, c, update_z, update_n, update_v, update_c, flags_old, flags);

	flags_old = 32'b10010000001110101010100101011001;
	z = 1;
	n = 0;
	v = 0;
	c = 1;
	update_z = 0;
	update_n = 0;
	update_c = 0;
	update_v = 0;
	#0.5;
	update_z = 1;
	#0.5;
	update_n = 1;
	#0.5;
	update_c = 1;
	#0.5;
	update_v = 1;
	#0.5;
	z = 0;
	n = 1;
	v = 1;
	c = 0;
	#0.5;
	update_z = 0;
	update_n = 0;
	update_c = 0;
	update_v = 0;
	#0.5;
	z = 1;
	#0.5;

end


endmodule
