// AUTHORS: Group 06 / Julian Käuser
// Wed 08/09/2017


module memory_interface_v2 (
  address,
  data_in,
  load,
  store,
  clk,
  reset,
  is_signed,
  word_type,
  from_mem_data,
  to_mem_read_enable,
  to_mem_write_enable,
  to_mem_mem_enable,
  to_mem_address,
  to_mem_data,
  data_out,
  write_ready,
  output_valid,
  busy
);


input [12:0] address; // address has 1 bit more than the one going to memory -
// because of bit alignment in cpu addresses
input [31:0] data_in;

input load;
input store;
input clk;
input reset;
input is_signed;
input [1:0] word_type;

// inputs from memory
input [15:0] from_mem_data;

// outputs going to the memory
output to_mem_read_enable;
output to_mem_write_enable;
output to_mem_mem_enable;
output [11:0] to_mem_address;
output [15:0] to_mem_data;


// outputs 2 cpu
output [31:0] data_out;
output write_ready;
output output_valid;
output busy;

localparam BUFFER = 1'b1;    // for all buffer select signals
localparam UPDATE = 1'b0;    // for all buffer select signals

localparam WORD =  2'b10;
localparam HALFWORD =  2'b01;
localparam BYTE =  2'b00;


// ############################ address path: #########################################
// ####################################################################################

wire direct_or_modified_address_sel;
localparam DIRECT_ADDRESS = 1'b1;
localparam MODIFIED_ADDRESS = 1'b0;

wire delayed_or_added_address_sel;
localparam  DELAYED_ADDRESS = 1'b1;
localparam  ADDED_ADDRESS = 1'b0;

wire delayed_address_buffer_sel;
wire added_address_buffer_sel;

wire adder_summand_sel;
localparam SEL_ONE = 1'b1;
localparam SEL_TWO = 1'b0;

reg [11:0] delayed_address_buffer_reg;
reg [11:0] added_address_buffer_reg;


always @(posedge clk) begin    // make buffers flipflops
    // assign buffers according to muxes
    delayed_address_buffer_reg <= delayed_address_buffer_sel ? delayed_address_buffer_reg : address[12:1];
    added_address_buffer_reg <= added_address_buffer_sel ? added_address_buffer_reg : address[12:1];
end

wire [11:0] modified_address;
assign to_mem_address = direct_or_modified_address_sel ? address[12:1] : modified_address;

wire [11:0] added_address;
assign modified_address = delayed_or_added_address_sel ? delayed_address_buffer_reg : added_address;

wire [11:0] summand;
assign summand = adder_summand_sel ? 12'h001 : 12'h002;

assign added_address = summand + added_address_buffer_reg;



// ########################## output path #######################################################################
// ##############################################################################################################

wire [7:0] from_mem_data_top8;
wire [7:0] from_mem_data_low8;
assign from_mem_data_low8 = from_mem_data[7:0];
assign from_mem_data_top8 = from_mem_data[15:8];

reg [31:0] data_out_pre;

// ####################################### lowest byte
wire [1:0] data_out_pre_L8_sel;
localparam L8_DIRECT_L8   = 2'b00;
localparam L8_DIRECT_T8   = 2'b01;
localparam L8_DELAYED1_T8 = 2'b10;
localparam L8_DELAYED2_T8 = 2'b11;

// flipflops for intermediate storage/delaying outputs
reg [7:0] top8_buffer1cycle;
reg [7:0] top8_buffer2cycle;


always @(posedge clk) begin // make them flipflops
  top8_buffer1cycle <= from_mem_data_top8;
  top8_buffer2cycle <= top8_buffer1cycle;

end

// select lowest byte of output (low8 pre)
always @ (*) begin
    case (data_out_pre_L8_sel)
      L8_DIRECT_T8:   data_out_pre[7:0] = from_mem_data_top8;
      L8_DIRECT_L8:   data_out_pre[7:0] = from_mem_data_low8;
      L8_DELAYED1_T8: data_out_pre[7:0] = top8_buffer1cycle;
      L8_DELAYED2_T8: data_out_pre[7:0] = top8_buffer2cycle;
    endcase
end


// ######################################### bits 15:8 (midLow8)
wire [2:0] data_out_pre_ML8_sel;
localparam ML8_DIRECT_L8   = 3'b000;
localparam ML8_DIRECT_T8   = 3'b001;
localparam ML8_ZERO        = 3'b100;
localparam ML8_DELAYED1_L8 = 3'b011;
localparam ML8_SIGN_BYTE   = 3'b010;

// flipflop for intermedaite storage
reg [7:0] low8_buffer1cycle;


always @(posedge clk) begin
   low8_buffer1cycle <= from_mem_data_low8;
end

// sign extension
wire [7:0] sign_byte_ml8_extension;
assign sign_byte_ml8_extension = data_out_pre[7] ? 8'hff : 8'h00;

always @(*) begin
    case (data_out_pre_ML8_sel)
      ML8_ZERO:           data_out_pre[15:8] = 8'h00;
      ML8_SIGN_BYTE:      data_out_pre[15:8] = sign_byte_ml8_extension;
      ML8_DIRECT_T8:      data_out_pre[15:8] = from_mem_data_top8;
      ML8_DIRECT_L8:      data_out_pre[15:8] = from_mem_data_low8;
      ML8_DELAYED1_L8:    data_out_pre[15:8] = low8_buffer1cycle;
    endcase
end


// ############################################# bits 23:16 (midTop 8)

wire [2:0] data_out_pre_MT8_sel;
localparam MT8_ZERO        = 3'b100;
localparam MT8_SIGN_BYTE   = 3'b000;
localparam MT8_SIGN_HW     = 3'b001;
localparam MT8_DELAYED1_L8 = 3'b010;
localparam MT8_DELAYED1_T8 = 3'b011;

wire [7:0] sign_byte_mt8_extension;
assign sign_byte_mt8_extension = data_out_pre[7] ? 8'hff : 8'h00;

wire [7:0] sign_hw_mt8_extension = data_out_pre[15] ? 8'hff : 8'h00;

always @(*) begin
    case (data_out_pre_MT8_sel)
      MT8_ZERO:        data_out_pre[23:16] = 8'h00;
      MT8_SIGN_HW:     data_out_pre[23:16] = sign_hw_mt8_extension;
      MT8_DELAYED1_T8: data_out_pre[23:16] = top8_buffer1cycle;
      MT8_DELAYED1_L8: data_out_pre[23:16] = low8_buffer1cycle;
      MT8_SIGN_BYTE:   data_out_pre[23:16] = sign_byte_mt8_extension;
    endcase
end

// ################################################ bits 31:24 (top8)

wire [2:0] data_out_pre_T8_sel;
localparam T8_ZERO        = 3'b100;
localparam T8_SIGN_BYTE   = 3'b000;
localparam T8_SIGN_HW     = 3'b001;
localparam T8_DIRECT_L8   = 3'b010;
localparam T8_DELAYED1_T8 = 3'b011;

wire [7:0] sign_byte_t8_extension;
assign sign_byte_t8_extension = data_out_pre[7] ? 8'hff : 8'h00;

wire [7:0] sign_hw_t8_extension;
assign sign_hw_t8_extension = data_out_pre[15] ? 8'hff : 8'h00;

always @(*) begin
    case (data_out_pre_T8_sel)
      T8_ZERO:        data_out_pre[23:16] = 8'h00;
      T8_SIGN_HW:     data_out_pre[23:16] = sign_hw_t8_extension;
      T8_DELAYED1_T8: data_out_pre[23:16] = top8_buffer1cycle;
      T8_DIRECT_L8: data_out_pre[23:16] = low8_buffer1cycle;
      T8_SIGN_BYTE:   data_out_pre[23:16] = sign_byte_t8_extension;
    endcase
end

// ################################################## final output composition

wire output_shuffle_sel;
assign data_out[31:16] = output_shuffle_sel ? data_out_pre[15:0]  : data_out_pre[31:16];
assign data_out[15:0]  = output_shuffle_sel ? data_out_pre[31:16] : data_out_pre[15:0] ;


// ############################## input path ###################################################
// #############################################################################################


// 2nd stage: select between feedback and input
localparam FEEDBACK_LOW8 = 1'b1;
localparam FEEDBACK_TOP8 = 1'b0;
wire from_mem_feedback_sel;
wire [7:0] from_mem_feedback;
assign from_mem_feedback = from_mem_feedback_sel ? from_mem_data_low8 : from_mem_data_top8;

wire [7:0] tomem_data_in_top8;
wire [7:0] tomem_data_in_low8;

wire tomem_data_in_top8_feedback_sel;
wire tomem_data_in_low8_feedback_sel;
localparam FEEDBACK_TO_MEM = 1'b1;
localparam INPUT_TO_MEM    = 1'b0;

reg [7:0] from_cpu_low8_input;
reg [7:0] from_cpu_top8_input;

assign tomem_data_in_low8 = tomem_data_in_low8_feedback_sel ? from_mem_feedback : from_cpu_low8_input;
assign tomem_data_in_top8 = tomem_data_in_top8_feedback_sel ? from_mem_feedback : from_cpu_top8_input;

// 1st stage: select inputs

wire [2:0] from_cpu_low8_input_sel;
localparam DIRECT_T8   = 3'b001;
localparam DIRECT_MT8  = 3'b010;
localparam DIRECT_ML8  = 3'b011;
localparam DIRECT_L8   = 3'b000;
localparam DELAYED_T8  = 3'b101;
localparam DELAYED_MT8 = 3'b110;
localparam DELAYED_ML8 = 3'b111;
localparam DELAYED_L8  = 3'b100;

// #### lower 8 bits select


reg [7:0] l8_t8_buffer;
reg [7:0] l8_mt8_buffer;
reg [7:0] l8_ml8_buffer;
reg [7:0] l8_l8_buffer;

wire l8_t8_buffer_sel;
wire l8_mt8_buffer_sel;
wire l8_ml8_buffer_sel;
wire l8_l8_buffer_sel;

always @ (posedge clk) begin
  l8_t8_buffer  <=  l8_t8_buffer_sel  ?  l8_t8_buffer  : data_in[31:24];
  l8_mt8_buffer <=  l8_mt8_buffer_sel ?  l8_mt8_buffer : data_in[23:16];
  l8_ml8_buffer <=  l8_ml8_buffer_sel ?  l8_ml8_buffer : data_in[15:8] ;
  l8_l8_buffer  <=  l8_l8_buffer_sel  ?  l8_l8_buffer  : data_in[7:0]  ;
end

always @(*) begin
    case (from_cpu_low8_input_sel)
      DIRECT_T8:   from_cpu_low8_input = data_in[31:24];
      DIRECT_MT8:  from_cpu_low8_input = data_in[23:16];
      DIRECT_ML8:  from_cpu_low8_input = data_in[15:8];
      DIRECT_L8:   from_cpu_low8_input = data_in[7:0];
      DELAYED_T8:  from_cpu_low8_input = l8_t8_buffer;
      DELAYED_MT8: from_cpu_low8_input = l8_mt8_buffer;
      DELAYED_ML8: from_cpu_low8_input = l8_ml8_buffer;
      DELAYED_L8:  from_cpu_low8_input = l8_l8_buffer;
    endcase
end

// #### higher (top) 8 bits select

wire [2:0] from_cpu_top8_input_sel;

reg [7:0] t8_t8_buffer;
reg [7:0] t8_mt8_buffer;
reg [7:0] t8_ml8_buffer;
reg [7:0] t8_l8_buffer;

wire t8_t8_buffer_sel;
wire t8_mt8_buffer_sel;
wire t8_ml8_buffer_sel;
wire t8_l8_buffer_sel;

always @ (posedge clk) begin
  t8_t8_buffer  <=  t8_t8_buffer_sel  ?  t8_t8_buffer  : data_in[31:24];
  t8_mt8_buffer <=  t8_mt8_buffer_sel ?  t8_mt8_buffer : data_in[23:16];
  t8_ml8_buffer <=  t8_ml8_buffer_sel ?  t8_ml8_buffer : data_in[15:8] ;
  t8_l8_buffer  <=  t8_l8_buffer_sel  ?  t8_l8_buffer  : data_in[7:0]  ;
end

always @(*) begin
    case (from_cpu_top8_input_sel)
      DIRECT_T8:   from_cpu_top8_input = data_in[31:24];
      DIRECT_MT8:  from_cpu_top8_input = data_in[23:16];
      DIRECT_ML8:  from_cpu_top8_input = data_in[15:8];
      DIRECT_L8:   from_cpu_top8_input = data_in[7:0];
      DELAYED_T8:  from_cpu_top8_input = t8_t8_buffer;
      DELAYED_MT8: from_cpu_top8_input = t8_mt8_buffer;
      DELAYED_ML8: from_cpu_top8_input = t8_ml8_buffer;
      DELAYED_L8:  from_cpu_top8_input = t8_l8_buffer;
    endcase
end

// ################################## controlling state machine ####################
// #################################################################################
// and some related stuff



wire fsm_rd_en;
wire fsm_rd;
wire fsm_wr_en;
wire fsm_wr;
wire fsm_mem_en;

// dependency of load/store/read/write
reg w;
reg r;
wire word_dep;

always @(*) begin
  case (word_type)
    BYTE: begin
      r = 1'b1;
      w = 1'b0;
    end // endcase byte

    HALFWORD: begin
      r =  load || address[0];
      w = !(load || address[0]);
    end // end case HALFWORD

    WORD: begin
      r =  load || address[0];
      w = !(load || address[0]);
    end // end case WORD
  endcase
end

assign to_mem_read_enable  = fsm_rd_en ? fsm_rd : r;
assign to_mem_write_enable = fsm_wr_en ? fsm_wr : w;

// buffering of signals
reg is_signed_buffer;
wire is_signed_buffer_sel;

reg [1:0] word_type_buffer;
wire word_type_buffer_sel;

always @ (posedge clk) begin
  is_signed_buffer <= is_signed_buffer_sel ? is_signed_buffer : is_signed;
  word_type_buffer <= word_type_buffer_sel ? word_type_buffer : word_type;
end

wire bit0;
assign bit0 = address[0];
reg bit0_delayed1;
reg bit0_delayed2;
reg bit0_delayed3;
// delay bit0 signal
always @ (posedge clk) begin
  bit0_delayed1 <= bit0;
  bit0_delayed2 <= bit0_delayed1;
  bit0_delayed3 <= bit0_delayed2;
end

memory_control_fsm_v2 fsm (
  .clk(clk),
  .reset(reset),
  .load(load),
  .store(store),
  .word_type(word_type),
  .word_type_buffered(word_type_buffer),
  .is_signed(is_signed),
  .is_signed_buffered(is_signed_buffer),
  .bit0(address[0]),
  .bit0_delayed1(bit0_delayed1),
  .bit0_delayed2(bit0_delayed2),
  .busy(busy),
  .output_valid(output_valid),
  .write_ready(write_ready),
  .fsm_rd(fsm_rd),
  .fsm_wr(fsm_wr),
  .fsm_wr_en(fsm_wr_en),
  .fsm_rd_en(fsm_rd_en),
  .fsm_mem_en(fsm_mem_en),
  .is_signed_buffer_sel(is_signed_buffer_sel),
  .word_type_buffer_sel(word_type_buffer_sel),
  .from_mem_feedback_sel(from_mem_feedback_sel),
  .tomem_data_in_top8_feedback_sel(tomem_data_in_top8_feedback_sel),
  .tomem_data_in_low8_feedback_sel(tomem_data_in_low8_feedback_sel),
  .from_cpu_low8_input_sel(from_cpu_low8_input_sel),
  .from_cpu_top8_input_sel(from_cpu_top8_input_sel),
  .l8_t8_buffer_sel(l8_t8_buffer_sel),
  .l8_mt8_buffer_sel(l8_mt8_buffer_sel),
  .l8_ml8_buffer_sel(l8_ml8_buffer_sel),
  .l8_l8_buffer_sel(l8_l8_buffer_sel),
  .t8_t8_buffer_sel(t8_t8_buffer_sel),
  .t8_mt8_buffer_sel(t8_mt8_buffer_sel),
  .t8_ml8_buffer_sel(t8_ml8_buffer_sel),
  .t8_l8_buffer_sel(t8_l8_buffer_sel),
  .data_out_pre_L8_sel(data_out_pre_L8_sel),
  .data_out_pre_ML8_sel(data_out_pre_ML8_sel),
  .data_out_pre_MT8_sel(data_out_pre_MT8_sel),
  .data_out_pre_T8_sel(data_out_pre_T8_sel),
  .output_shuffle_sel(output_shuffle_sel),
  .adder_summand_sel(adder_summand_sel),
  .added_address_buffer_sel(added_address_buffer_sel),
  .delayed_address_buffer_sel(delayed_address_buffer_sel),
  .delayed_or_added_address_sel(delayed_or_added_address_sel),
  .direct_or_modified_address_sel(direct_or_modified_address_sel)
  );



endmodule
