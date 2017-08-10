// AUTHORS Group 06 /Julian Käuser
// Thursday, 08/10/2017

module memory_control_fsm (
  clk,
  reset,
  load,
  store,
  word_type,
  is_signed,
  busy,
  output_valid,
  write_ready,
  fsm_rd,
  fsm_wr,
  fsm_wr_en,
  fsm_rd_en,
  fsm_mem_en,
  is_signed_buffer_sel,
  word_type_buffer_sel,
  from_mem_feedback_sel,
  2mem_data_in_top8_feedback_sel,
  2mem_data_in_low8_feedback_sel,
  from_cpu_low8_input_sel,
  from_cpu_top8_input_sel,
  l8_t8_buffer_sel,
  l8_mt8_buffer_sel,
  l8_ml8_buffer_sel,
  l8_l8_buffer_sel,
  t8_t8_buffer_sel,
  t8_mt8_buffer_sel,
  t8_ml8_buffer_sel,
  t8_l8_buffer_sel,
  data_out_pre_L8_sel,
  data_out_pre_ML8_sel,
  data_out_pre_MT8_sel,
  data_out_pre_T8_sel,
  output_shuffle_sel,
  adder_summand_sel,
  added_address_buffer_sel,
  delayed_address_buffer_sel,
  delayed_or_added_address_sel,
  direct_or_modified_address_sel
  );

// ##################### inputs #######################
// ####################################################

  input clk;
  input reset;
  input load;
  input store;
  input [1:0] word_type;
  input is_signed;

// ####################### outputs #######################
// #######################################################

  // signals to other modules
  output reg busy;
  output reg output_valid;
  output reg write_ready;

// signals to memory
  output reg fsm_rd;
  output reg fsm_wr;
  output reg fsm_wr_en;
  output reg fsm_rd_en;
  output reg fsm_mem_en;

// input buffers in mem interface
  output reg is_signed_buffer_sel;
  output reg word_type_buffer_sel;

// input selection in mem interface
  output reg from_mem_feedback_sel;
  output reg 2mem_data_in_top8_feedback_sel;
  output reg 2mem_data_in_low8_feedback_sel;
  output reg [3:0] from_cpu_low8_input_sel;
  output reg [3:0] from_cpu_top8_input_sel;

  output reg l8_t8_buffer_sel;
  output reg l8_mt8_buffer_sel;
  output reg l8_ml8_buffer_sel;
  output reg l8_l8_buffer_sel;
  output reg t8_t8_buffer_sel;
  output reg t8_mt8_buffer_sel;
  output reg t8_ml8_buffer_sel;
  output reg t8_l8_buffer_sel;

// output selection in mem interface
  output reg [1:0] data_out_pre_L8_sel;
  output reg [2:0] data_out_pre_ML8_sel;
  output reg [2:0] data_out_pre_MT8_sel;
  output reg [2:0] data_out_pre_T8_sel;

  output reg output_shuffle_sel;

// address manipulation in mem interface
  output reg adder_summand_sel;
  output reg added_address_buffer_sel;
  output reg delayed_address_buffer_sel;
  output reg delayed_or_added_address_sel;
  output reg direct_or_modified_address_sel;

// ####################### codes for signals ########
// ##################################################

localparam DC = 1'b0;
localparam DC2 = 2'b0;
localparam DC3 = 3'b0;
localparam DC4 = 4'b0;


localparam BUFFER = 1'b1;    // for all buffer select signals
localparam UPDATE = 1'b0;

//direct_or_modified_address_sel
localparam DIRECT_ADDRESS = 1'b1;
localparam MODIFIED_ADDRESS = 1'b0;

//delayed_or_added_address_sel
localparam  DELAYED_ADDRESS = 1'b1;
localparam  ADDED_ADDRESS = 1'b0;

    //adder_summand_sel
localparam SEL_ONE = 1'b1;
localparam SEL_TWO = 1'b0;


// data_out_pre_L8_sel
localparam L8_DIRECT_L8   = 2'b00;
localparam L8_DIRECT_T8   = 2'b01;
localparam L8_DELAYED1_T8 = 2'b10;
localparam L8_DELAYED2_T8 = 2'b11;

//data_out_pre_ML8_sel;
localparam ML8_DIRECT_L8   = 3'b000;
localparam ML8_DIRECT_T8   = 3'b001;
localparam ML8_ZERO        = 3'b100;
localparam ML8_DELAYED1_L8 = 3'b011;
localparam ML8_SIGN_BYTE   = 3'b010;

//data_out_pre_MT8_sel;
localparam MT8_ZERO        = 3'b100;
localparam MT8_SIGN_BYTE   = 3'b000;
localparam MT8_SIGN_HW     = 3'b001;
localparam MT8_DELAYED1_L8 = 3'b010;
localparam MT8_DELAYED1_T8 = 3'b011;

//data_out_pre_T8_sel;
localparam T8_ZERO        = 3'b100;
localparam T8_SIGN_BYTE   = 3'b000;
localparam T8_SIGN_HW     = 3'b001;
localparam T8_DIRECT_L8   = 3'b010;
localparam T8_DELAYED1_T8 = 3'b011;


// from_cpu_low8_input_sel && from_cpu_top8_input_sel
localparam DIRECT_T8   = 3'b001;
localparam DIRECT_MT8  = 3'b010;
localparam DIRECT_ML8  = 3'b011;
localparam DIRECT_L8   = 3'b000;
localparam DELAYED_T8  = 3'b101;
localparam DELAYED_MT8 = 3'b110;
localparam DELAYED_ML8 = 3'b111;
localparam DELAYED_L8  = 3'b100;

// from_mem_feedback_sel;
localparam FEEDBACK_LOW8 = 1'b1;
localparam FEEDBACK_TOP8 = 1'b0;

// 2mem_data_in_top8_feedback_sel;
// 2mem_data_in_low8_feedback_sel;
localparam FEEDBACK_TO_MEM = 1'b1;
localparam INPUT_TO_MEM    = 1'b0;



  // ##################### internal signals #########
  // ################################################

reg [5:0] state;
reg [5:0] nextstate;

always @(posedge clk | posedge reset) begin
   if (!reset) begin
     state <= nextstate;
   end
   else begin
     state <= RESET_STATE;
   end

end

// ##################################### state codes: #########################
// ############################################################################
localparam RESET_STATE = 6'b000000;


// ##################################### transitions ##########################
// ############################################################################
always @(*) begin
  case (state)

  endcase
end

// #################################### outputs ###############################
// ############################################################################
always @(*) begin
    case (state)

    endcase
end

endmodule
