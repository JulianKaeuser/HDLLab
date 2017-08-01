//Authors: Group 06/Julian Käuser
//Tuesday 08/01/2017

`define READ 0
`define WRITE 1
`define OVERFLOW 1

// abstracts the memory interface from the processor
module memory_interface (
  address,
  input_bus,
  output_bus,
  valid,
  rw,
  addr_overflow,
  clk
  );

localparam WIDE = 16;


input [WIDE-1:0] address;
input [WIDE-1:0] input_bus;
input rw;
input clk;

output reg [WIDE-1:0] output_bus;
output reg valid;
output reg addr_overflow;

wire en, wr_en, rd_en;
wire[WIDE-1:0] addr;
wire[WIDE-1:0] data_in, data_out;

memory mem(
	.clk(clk),
	.en(en),
	.rd_en(rd_en),
	.wr_en(wr_en),
	.addr(addr),
	.din(data_in),
	.dout(data_out)
);


// use only lower bits of address
assign addr = address[11:0];

// catch address overflows
always @(*) begin
   if (address[15:12]!=4'b0000) begin
      addr_overflow = 1;
   end
   else begin
      addr_overflow = 0;
   end
end




endmodule
