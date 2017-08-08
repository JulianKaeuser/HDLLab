module controller (
clk,
reset,
decoder_load_in,
decoder_store_in,
fetch_load_in,
//fetch_stall2decoder_in,
//decoder_stall2fetch_in,
decoder_src_mem_addr_in,
//mem_busy_in,
mem_output_valid_in,
mem_write_ready_in,
//stall_decoder2fetch_out,
stall_mem2fetch_out,
addr_select_out,
read_en_sel_out,
word_select_out,
stall_any2decoder_out,
state
  );

input clk;
input reset;
input decoder_store_in;
input decoder_load_in;
input fetch_load_in;
//input fetch_stall2decoder_in;
//input decoder_stall2fetch_in;
input decoder_src_mem_addr_in;
//input mem_busy_in;
input mem_output_valid_in;
input mem_write_ready_in;

//output reg stall_decoder2fetch_out;
output reg stall_mem2fetch_out;
output reg [1:0] addr_select_out;
output reg read_en_sel_out;
output reg word_select_out;
output reg stall_any2decoder_out;
output reg[1:0] state;

wire requests;
wire id_request;
assign id_request = decoder_store_in || decoder_load_in;

localparam DC = 1'b1;
localparam DC2 = 2'b11;

// codes for addr_select_out
localparam IF_ADDR = 2'b00;
localparam REGFILE_D_ADDR = 2'b10;
localparam ALU_RESULT_ADDR = 2'b11;

// codes for read_en_select_out
localparam IF_READ = 1'b1;
localparam ID_READ = 1'b0;

// codes for memory turn
localparam ID_TURN = 1'b1;
localparam IF_TURN = 1'b0;


// codes for word selection
localparam HALFWORD = 1'b1;
localparam DECODER_WORD = 1'b0;

localparam STATE_BITS = 2;
// state flipflops
//reg [STATE_BITS-1:0] state;
reg [STATE_BITS-1:0] nextstate;
reg turn;
reg nextturn;

// states
localparam RESET_STATE = 2'b11;
localparam IDLE        = 2'b00;
localparam LOAD_ACCESS = 2'b10;
localparam STORE_ACCESS = 2'b01;
// filflops
always @(posedge clk or posedge reset) begin
 if (!reset) begin
     state <= nextstate;
     turn <= nextturn;
end
 else begin
     state <= RESET_STATE;
     turn <= 0;
end
end

// state transitions
always @(*) begin
  case (state)
    RESET_STATE: begin
    end // end RESET_STATE

    IDLE: begin
      if (!id_request && !fetch_load_in) begin
        nextstate = IDLE;
        nextturn = IF_TURN;
      end
      else if (decoder_load_in) begin
        nextstate = LOAD_ACCESS;
        nextturn  = ID_TURN;
      end
      else if (decoder_store_in) begin
        nextstate = STORE_ACCESS;
        nextturn  = ID_TURN;
      end
      else begin
        nextstate = LOAD_ACCESS;
        nextturn = IF_TURN;
      end
    end // end IDLE

    LOAD_ACCESS: begin
		if(!mem_output_valid_in)
			nextstate = LOAD_ACCESS;
		else
			nextstate = IDLE;
	
    end //end LOAD_ACCESS

	STORE_ACCESS: begin
		if(!mem_write_ready_in)
			nextstate = STORE_ACCESS;
		else
			nextstate = IDLE;
	end //end STORE_ACCESS

	default: begin
		nextstate = IDLE;
		nextturn = IF_TURN;
	end
  endcase
end

// output changes
always @(*) begin
   case (state)
     RESET_STATE: begin
       //stall_decoder2fetch_out=  1;
       stall_mem2fetch_out    =  0;
       addr_select_out        =  IF_ADDR;
       read_en_sel_out        =  IF_READ;
       word_select_out        =  HALFWORD;
       stall_any2decoder_out      =  0;
     end // end RESET_STATE

     IDLE: begin
       //stall_decoder2fetch_out=  id_request ? 1 : 0;
       stall_mem2fetch_out    =  id_request ? 1 : 0;
       addr_select_out        =  id_request ? (decoder_src_mem_addr_in ? REGFILE_D_ADDR : ALU_RESULT_ADDR):(IF_ADDR);
       read_en_sel_out        =  id_request ? ID_READ : IF_READ;
       word_select_out        =  id_request ? DECODER_WORD : HALFWORD;
       stall_any2decoder_out  =  id_request ? 0 : (fetch_load_in ? 1 : 0);
     end // end idle state

     LOAD_ACCESS: begin
       //stall_decoder2fetch_out=  ;
       stall_mem2fetch_out    =  (turn == ID_TURN) ? 1 : 0 /*!mem_output_valid_in*/;
       addr_select_out        =  (turn == ID_TURN) ? (decoder_src_mem_addr_in ? REGFILE_D_ADDR : ALU_RESULT_ADDR) : (IF_ADDR);
       read_en_sel_out        =  (turn == ID_TURN) ? ID_READ : IF_READ;
       word_select_out        =  (turn == ID_TURN) ? DECODER_WORD : HALFWORD;
       stall_any2decoder_out  =  (turn == ID_TURN) ? !mem_output_valid_in : 1;
     end // end LOAD_ACCESS

     STORE_ACCESS: begin
       stall_mem2fetch_out    = 1;
       addr_select_out        = decoder_src_mem_addr_in ? REGFILE_D_ADDR : ALU_RESULT_ADDR;
       read_en_sel_out        = ID_READ;
       word_select_out        = DECODER_WORD;
       stall_any2decoder_out  = !mem_write_ready_in;
     end // end STORE_ACCESS
	
	default: begin
	   //stall_decoder2fetch_out=  id_request ? 1 : 0;
       stall_mem2fetch_out    =  id_request ? 1 : 0;
       addr_select_out        =  id_request ? (decoder_src_mem_addr_in ? REGFILE_D_ADDR : ALU_RESULT_ADDR):(IF_ADDR);
       read_en_sel_out        =  id_request ? ID_READ : IF_READ;
       word_select_out        =  id_request ? DECODER_WORD : HALFWORD;
       stall_any2decoder_out  =  id_request ? 0 : (fetch_load_in ? 1 : 0);
	end
   endcase
end

endmodule
