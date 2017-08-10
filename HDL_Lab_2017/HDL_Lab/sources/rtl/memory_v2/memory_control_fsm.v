// AUTHORS Group 06 /Julian Käuser
// Thursday, 08/10/2017

module memory_control_fsm (
  clk,
  reset,
  load,
  store,
  word_type,
  word_type_buffered,
  is_signed,
  is_signed_buffered,
  bit0,
  bit0_delayed1,
  bit0_delayed2,
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
  input [1:0] word_type_buffered;
  input is_signed_buffered;

  input bit0;
  input bit0_delayed1;
  input bit0_delayed2;
  //input bit0_delayed3;

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

// word_type
localparam WORD =  2'b10;
localparam HALFWORD =  2'b01;
localparam BYTE =  2'b00;


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

reg [4:0] state;
reg [4:0] nextstate;

always @(posedge clk | posedge reset) begin
   if (!reset) begin
     state <= nextstate;
   end
   else begin
     state <= IDLE;
   end

end

// ##################################### state codes: #########################
// ############################################################################
localparam IDLE         = 5'b00001;
localparam LOAD_BYTE    = 5'b00010;
localparam LOAD_HW_A    = 5'b00011;
localparam LOAD_HW_B    = 5'b00100;
localparam LOAD_WORD_A  = 5'b00101;
localparam LOAD_WORD_B  = 5'b00110;
localparam LOAD_WORD_C  = 5'b00111;

localparam STORE_HW_A   = 5'b10001;
localparam STORE_HW_B   = 5'b10010;
localparam STORE_HW_C   = 5'b10011;
localparam STORE_HW_D   = 5'b10100;
localparam STORE_WORD_A = 5'b10101;
localparam STORE_WORD_B = 5'b10110;
localparam STORE_WORD_C = 5'b10111;
localparam STORE_WORD_D = 5'b11001;
localparam STORE_WORD_E = 5'b11010;
localparam STORE_BYTE_A = 5'b11011;
localparam STORE_BYTE_B = 5'b11100;





// ##################################### transitions ##########################
// ############################################################################
always @(*) begin
  case (state)
    IDLE: begin
      if (load) begin
       case (word_type)
        HALFWORD: nextstate = LOAD_HW_A;
        WORD:     nextstate = LOAD_WORD_A;
        BYTE:     nextstate = LOAD_BYTE;
       endcase
      end
      else if (store) begin
       case (word_type)
        HALFWORD: nextstate = STORE_HW_A;
        WORD:     nextstate = STORE_WORD_A;
        BYTE:     nextstate = STORE_BYTE_A;
       endcase
      end
      else begin
       nextstate = IDLE;
      end
    end // end case IDLE

   LOAD_BYTE: begin
     if (load) begin
      case (word_type)
       HALFWORD: nextstate = LOAD_HW_A;
       WORD:     nextstate = LOAD_WORD_A;
       BYTE:     nextstate = LOAD_BYTE;
      endcase
     end
     else if (store) begin
      case (word_type)
       HALFWORD: nextstate = STORE_HW_A;
       WORD:     nextstate = STORE_WORD_A;
       BYTE:     nextstate = STORE_BYTE_A;
      endcase
     end
     else begin
      nextstate = IDLE;
     end
   end // end case load byte

   LOAD_HW_A: begin
     if (bit0_delayed1) begin
       nextstate = LOAD_HW_B;
     end
     else if (load) begin
      case (word_type)
       HALFWORD: nextstate = LOAD_HW_A;
       WORD:     nextstate = LOAD_WORD_A;
       BYTE:     nextstate = LOAD_BYTE;
      endcase
     end
     else if (store) begin
      case (word_type)
       HALFWORD: nextstate = STORE_HW_A;
       WORD:     nextstate = STORE_WORD_A;
       BYTE:     nextstate = STORE_BYTE_A;
      endcase
     end
     else begin
      nextstate = IDLE;
     end
   end // end case LOAD HW A

   LOAD_HW_B: begin
     if (load) begin
      case (word_type)
       HALFWORD: nextstate = LOAD_HW_A;
       WORD:     nextstate = LOAD_WORD_A;
       BYTE:     nextstate = LOAD_BYTE;
      endcase
     end
     else if (store) begin
      case (word_type)
       HALFWORD: nextstate = STORE_HW_A;
       WORD:     nextstate = STORE_WORD_A;
       BYTE:     nextstate = STORE_BYTE_A;
      endcase
     end
     else begin
      nextstate = IDLE;
     end
   end // end case load HW B

   LOAD_WORD_A: begin
     nextstate = LOAD_WORD_B;
   end // end case LOAD WORD A

   LOAD_WORD_B: begin
     if (bit0_delayed2) begin
       nextstate = LOAD_WORD_C;
     end
     else if (load) begin
      case (word_type)
       HALFWORD: nextstate = LOAD_HW_A;
       WORD:     nextstate = LOAD_WORD_A;
       BYTE:     nextstate = LOAD_BYTE;
      endcase
     end
     else if (store) begin
      case (word_type)
       HALFWORD: nextstate = STORE_HW_A;
       WORD:     nextstate = STORE_WORD_A;
       BYTE:     nextstate = STORE_BYTE_A;
      endcase
     end
     else begin
      nextstate = IDLE;
     end
   end // end case LOAD WORD B

   LOAD_WORD_C: begin
     if (load) begin
      case (word_type)
       HALFWORD: nextstate = LOAD_HW_A;
       WORD:     nextstate = LOAD_WORD_A;
       BYTE:     nextstate = LOAD_BYTE;
      endcase
     end
     else if (store) begin
      case (word_type)
       HALFWORD: nextstate = STORE_HW_A;
       WORD:     nextstate = STORE_WORD_A;
       BYTE:     nextstate = STORE_BYTE_A;
      endcase
     end
     else begin
      nextstate = IDLE;
     end
   end // end case LOAD WORD C

   STORE BYTE_A: begin
     nextstate = STORE_BYTE_B;
   end // end case STORE BYTE A

   STORE_BYTE_B: begin
     if (load) begin
      case (word_type)
       HALFWORD: nextstate = LOAD_HW_A;
       WORD:     nextstate = LOAD_WORD_A;
       BYTE:     nextstate = LOAD_BYTE;
      endcase
     end
     else if (store) begin
      case (word_type)
       HALFWORD: nextstate = STORE_HW_A;
       WORD:     nextstate = STORE_WORD_A;
       BYTE:     nextstate = STORE_BYTE_A;
      endcase
     end
     else begin
      nextstate = IDLE;
     end
   end // end case STORE BYTE B

   STORE_HW_A: begin
    if (bit0_delayed1) begin
      nextstate = STORE_HW_B;
    end
     else if (load) begin
      case (word_type)
       HALFWORD: nextstate = LOAD_HW_A;
       WORD:     nextstate = LOAD_WORD_A;
       BYTE:     nextstate = LOAD_BYTE;
      endcase
     end
     else if (store) begin
      case (word_type)
       HALFWORD: nextstate = STORE_HW_A;
       WORD:     nextstate = STORE_WORD_A;
       BYTE:     nextstate = STORE_BYTE_A;
      endcase
     end
     else begin
      nextstate = IDLE;
     end
   end // end case STORE_HW_A

   STORE_HW_B: begin
    nextstate = STORE_HW_C;
   end // end case STORE_HW_B

   STORE_HW_C: begin
     nextstate = IDLE;
   end // end case STORE_HW_C

   STORE_WORD_A: begin
    nextstate = STORE_WORD_B
   end // end case STORE_WORD_A

   STORE_WORD_B: begin
    if (bit0_delayed2) begin
      nextstate = STORE_WORD_C;
    end
     else if (load) begin
      case (word_type)
       HALFWORD: nextstate = LOAD_HW_A;
       WORD:     nextstate = LOAD_WORD_A;
       BYTE:     nextstate = LOAD_BYTE;
      endcase
     end
     else if (store) begin
      case (word_type)
       HALFWORD: nextstate = STORE_HW_A;
       WORD:     nextstate = STORE_WORD_A;
       BYTE:     nextstate = STORE_BYTE_A;
      endcase
     end
     else begin
      nextstate = IDLE;
     end
   end // end case STORE_HW_B

   STORE_WORD_C: begin
     nextstate = STORE_WORD_D;
   end // end case STORE_WORD_C

   STORE_WORD_D: begin
     nextstate = STORE_WORD_E;
   end // end case STORE_WORD_D

   STORE_WORD_E: begin
     if (load) begin
      case (word_type)
       HALFWORD: nextstate = LOAD_HW_A;
       WORD:     nextstate = LOAD_WORD_A;
       BYTE:     nextstate = LOAD_BYTE;
      endcase
     end
     else if (store) begin
      case (word_type)
       HALFWORD: nextstate = STORE_HW_A;
       WORD:     nextstate = STORE_WORD_A;
       BYTE:     nextstate = STORE_BYTE_A;
      endcase
     end
     else begin
      nextstate = IDLE;
     end
   end // end case STORE_WORD_E












  endcase
end

// #################################### outputs ###############################
// ############################################################################
// ############################################################################
always @(*) begin
    case (state)
      // ################## IDLE ####################################
      // ############################################################
      IDLE: begin
         // status signals
         busy                           = 0;
         output_valid                   = 0;
         write_ready                    = 0;

         // fsm control
         fsm_rd                         = DC;
         fsm_wr                         = DC;
         fsm_wr_en                      = 0 ;
         fsm_rd_en                      = 0 ;
         fsm_mem_en                     = 1 ;

         // status in buffering
         is_signed_buffer_sel           = UPDATE ;
         word_type_buffer_sel           = UPDATE ;

         // input selection feedback
         from_mem_feedback_sel          = DC;
         2mem_data_in_top8_feedback_sel = INPUT_TO_MEM;
         2mem_data_in_low8_feedback_sel = INPUT_TO_MEM;

         // input selection
         from_cpu_low8_input_sel    = DIRECT_L8;
         from_cpu_top8_input_sel    = DIRECT_ML8;
         l8_t8_buffer_sel           = UPDATE;
         l8_mt8_buffer_sel          = UPDATE;
         l8_ml8_buffer_sel          = UPDATE;
         l8_l8_buffer_sel           = UPDATE;
         t8_t8_buffer_sel           = UPDATE;
         t8_mt8_buffer_sel          = UPDATE;
         t8_ml8_buffer_sel          = UPDATE;
         t8_l8_buffer_sel           = UPDATE;



         // output assignment
         data_out_pre_L8_sel            = DC2; // 2 bit
         data_out_pre_ML8_sel           = DC3; // 3 bit
         data_out_pre_MT8_sel           = DC3; // 3 bit
         data_out_pre_T8_sel            = DC3; // 3 bit

         output_shuffle_sel             = 0;

         // address assignment
         adder_summand_sel              = SEL_ONE;
         added_address_buffer_sel       = UPDATE;
         delayed_address_buffer_sel     = UPDATE;
         delayed_or_added_address_sel   = DC;
         direct_or_modified_address_sel = DIRECT_ADDRESS;
      end // end case IDLE

     // ############################# LOAD_BYTE ###########################
     // ###################################################################
      LOAD_BYTE: begin
         // status signals
         busy                           = 0;
         output_valid                   = 1;
         write_ready                    = 0;

         // fsm control
         fsm_rd                         = 0;
         fsm_wr                         = 0;
         fsm_wr_en                      = 0;
         fsm_rd_en                      = 0;
         fsm_mem_en                     = 1;

         // status in buffering
         is_signed_buffer_sel           = UPDATE;
         word_type_buffer_sel           = UPDATE;

         // input selection feedback
         from_mem_feedback_sel          = DC;
         2mem_data_in_top8_feedback_sel = INPUT_TO_MEM;
         2mem_data_in_low8_feedback_sel = INPUT_TO_MEM;

         // input selection
         from_cpu_low8_input_sel    = DIRECT_L8;
         from_cpu_top8_input_sel    = DIRECT_ML8;
         l8_t8_buffer_sel           = UPDATE;
         l8_mt8_buffer_sel          = UPDATE;
         l8_ml8_buffer_sel          = UPDATE;
         l8_l8_buffer_sel           = UPDATE;
         t8_t8_buffer_sel           = UPDATE;
         t8_mt8_buffer_sel          = UPDATE;
         t8_ml8_buffer_sel          = UPDATE;
         t8_l8_buffer_sel           = UPDATE;



         // output assignment
         data_out_pre_L8_sel            = bit0_delayed1 ? L8_DIRECT_T8 : L8_DIRECT_L8; // 2 bit
         data_out_pre_ML8_sel           = is_signed_buffer ? ML8_SIGN_BYTE : ML8_ZERO; // 3 bit
         data_out_pre_MT8_sel           = is_signed_buffer ? MT8_SIGN_BYTE : MT8_ZERO; // 3 bit
         data_out_pre_T8_sel            = is_signed_buffer ? T8_SIGN_BYTE : T8_ZERO; // 3 bit

         output_shuffle_sel             = 0;

         // address assignment
         adder_summand_sel              = SEL_ONE;
         added_address_buffer_sel       = UPDATE;
         delayed_address_buffer_sel     = UPDATE;
         delayed_or_added_address_sel   = DC;
         direct_or_modified_address_sel = DIRECT_ADDRESS;
      end // end case LOAD_BYTE

      // ############################# LOAD_HW_A ##############################
      //  #####################################################################
      LOAD_HW_A: begin
         // status signals
         busy                           = bit0_delayed1;
         output_valid                   = !bit0_delayed1;
         write_ready                    = 0;

         // fsm control
         fsm_rd                         = bit0_delayed1;
         fsm_wr                         = 0;
         fsm_wr_en                      = 0;
         fsm_rd_en                      = bit0_delayed1;
         fsm_mem_en                     = 1;

         // status in buffering
         is_signed_buffer_sel           = bit0_delayed1 ? BUFFER : UPDATE;
         word_type_buffer_sel           = bit0_delayed1 ? BUFFER : UPDATE;

         // input selection feedback
         from_mem_feedback_sel          = DC;
         2mem_data_in_top8_feedback_sel = INPUT_TO_MEM;
         2mem_data_in_low8_feedback_sel = INPUT_TO_MEM;

         // input selection
         from_cpu_low8_input_sel    = DIRECT_L8;
         from_cpu_top8_input_sel    = DIRECT_ML8;
         l8_t8_buffer_sel           = UPDATE;
         l8_mt8_buffer_sel          = UPDATE;
         l8_ml8_buffer_sel          = UPDATE;
         l8_l8_buffer_sel           = UPDATE;
         t8_t8_buffer_sel           = UPDATE;
         t8_mt8_buffer_sel          = UPDATE;
         t8_ml8_buffer_sel          = UPDATE;
         t8_l8_buffer_sel           = UPDATE;



         // output assignment
         data_out_pre_L8_sel            = bit0_delayed1 ? DC2 : L8_DIRECT_L8; // 2 bit
         data_out_pre_ML8_sel           = bit0_delayed1 ? DC3 : ML8_DIRECT_T8; // 3 bit
         data_out_pre_MT8_sel           = is_signed_buffer ? MT8_SIGN_HW : MT8_ZERO; // 3 bit
         data_out_pre_T8_sel            = is_signed_buffer ? T8_SIGN_HW : T8_ZERO; // 3 bit

         output_shuffle_sel             = 0;

         // address assignment
         adder_summand_sel              = SEL_ONE;
         added_address_buffer_sel       = UPDATE;
         delayed_address_buffer_sel     = UPDATE;
         delayed_or_added_address_sel   = ADDED_ADDRESS;
         direct_or_modified_address_sel = bit0_delayed1 ? MODIFIED_ADDRESS : DIRECT_ADDRESS;
      end // end case LOAD_HW_A

      //################################## LOAD_HW_B ##########################
      // #######################################################################
      LOAD_HW_B: begin
         // status signals
         busy                           = 0;
         output_valid                   = 1;
         write_ready                    = 0;

         // fsm control
         fsm_rd                         = 0;
         fsm_wr                         = 0;
         fsm_wr_en                      = 0;
         fsm_rd_en                      = 0;
         fsm_mem_en                     = 1;

         // status in buffering
         is_signed_buffer_sel           = UPDATE;
         word_type_buffer_sel           = UPDATE;

         // input selection feedback
         from_mem_feedback_sel          = DC;
         2mem_data_in_top8_feedback_sel = INPUT_TO_MEM;
         2mem_data_in_low8_feedback_sel = INPUT_TO_MEM;

         // input selection
         from_cpu_low8_input_sel    = DIRECT_L8;
         from_cpu_top8_input_sel    = DIRECT_ML8;
         l8_t8_buffer_sel           = UPDATE;
         l8_mt8_buffer_sel          = UPDATE;
         l8_ml8_buffer_sel          = UPDATE;
         l8_l8_buffer_sel           = UPDATE;
         t8_t8_buffer_sel           = UPDATE;
         t8_mt8_buffer_sel          = UPDATE;
         t8_ml8_buffer_sel          = UPDATE;
         t8_l8_buffer_sel           = UPDATE;



         // output assignment
         data_out_pre_L8_sel            = L8_DELAYED1_T8; // 2 bit
         data_out_pre_ML8_sel           = ML8_DIRECT_L8; // 3 bit
         data_out_pre_MT8_sel           = is_signed_buffer ? MT8_SIGN_HW : MT8_ZERO; // 3 bit
         data_out_pre_T8_sel            = is_signed_buffer ? T8_SIGN_HW : T8_ZERO; // 3 bit

         output_shuffle_sel             = 0;

         // address assignment
         adder_summand_sel              = SEL_ONE;
         added_address_buffer_sel       = UPDATE;
         delayed_address_buffer_sel     = UPDATE;
         delayed_or_added_address_sel   = DC;
         direct_or_modified_address_sel = DIRECT_ADDRESS;
      end // end case LOAD_HW_B

      // ################################## LOAD_WORD_A ###########################
      //##########################################################################
      LOAD_WORD_A: begin
         // status signals
         busy                           = 1;
         output_valid                   = 0;
         write_ready                    = 0;

         // fsm control
         fsm_rd                         = 1;
         fsm_wr                         = 0;
         fsm_wr_en                      = 1;
         fsm_rd_en                      = 1;
         fsm_mem_en                     = 1;

         // status in buffering
         is_signed_buffer_sel           = BUFFER;
         word_type_buffer_sel           = BUFFER;

         // input selection feedback
         from_mem_feedback_sel          = DC;
         2mem_data_in_top8_feedback_sel = INPUT_TO_MEM;
         2mem_data_in_low8_feedback_sel = INPUT_TO_MEM;

         // input selection

         from_cpu_low8_input_sel      = DC3;
         from_cpu_top8_input_sel      = DC3;
         l8_t8_buffer_sel             = DC;
         l8_mt8_buffer_sel            = DC;
         l8_ml8_buffer_sel            = DC;
         l8_l8_buffer_sel             = DC;
         t8_t8_buffer_sel             = DC;
         t8_mt8_buffer_sel            = DC;
         t8_ml8_buffer_sel            = DC;
         t8_l8_buffer_sel             = DC;

         // output assignment
         data_out_pre_L8_sel            = DC2; // 2 bit
         data_out_pre_ML8_sel           = DC3; // 3 bit
         data_out_pre_MT8_sel           = DC3; // 3 bit
         data_out_pre_T8_sel            = DC3; // 3 bit

         output_shuffle_sel             = 0;

         // address assignment
         adder_summand_sel              = SEL_ONE;
         added_address_buffer_sel       = BUFFER;
         delayed_address_buffer_sel     = BUFFER;
         delayed_or_added_address_sel   = ADDED_ADDRESS;
         direct_or_modified_address_sel = MODIFIED_ADDRESS;
      end // end case LOAD_WORD_A

      // ############################### LOAD_WORD_B ##########################
      // ######################################################################
      LOAD_WORD_B: begin
         // status signals
         busy                           = !bit0_delayed2;
         output_valid                   = 0;
         write_ready                    = !bit0_delayed2;

         // fsm control
         fsm_rd                         = 1;
         fsm_wr                         = 0;
         fsm_wr_en                      = 0;
         fsm_rd_en                      = bit0_delayed2;
         fsm_mem_en                     = 1;

         // status in buffering
         is_signed_buffer_sel           = bit0_delayed2 ? BUFFER : UPDATE;
         word_type_buffer_sel           = bit0_delayed2 ? BUFFER : UPDATE;

         // input selection feedback
         from_mem_feedback_sel          = DC;
         2mem_data_in_top8_feedback_sel = INPUT_TO_MEM;
         2mem_data_in_low8_feedback_sel = INPUT_TO_MEM;

         // input selection
         from_cpu_low8_input_sel    = DIRECT_L8;
         from_cpu_top8_input_sel    = DIRECT_ML8;
         l8_t8_buffer_sel           = UPDATE;
         l8_mt8_buffer_sel          = UPDATE;
         l8_ml8_buffer_sel          = UPDATE;
         l8_l8_buffer_sel           = UPDATE;
         t8_t8_buffer_sel           = UPDATE;
         t8_mt8_buffer_sel          = UPDATE;
         t8_ml8_buffer_sel          = UPDATE;
         t8_l8_buffer_sel           = UPDATE;



         // output assignment
         data_out_pre_L8_sel            = DC2; // 2 bit
         data_out_pre_ML8_sel           = DC3; // 3 bit
         data_out_pre_MT8_sel           = DC3; // 3 bit
         data_out_pre_T8_sel            = DC3; // 3 bit

         output_shuffle_sel             = 1;

         // address assignment
         adder_summand_sel              = SEL_ONE;
         added_address_buffer_sel       = BUFFER;
         delayed_address_buffer_sel     = BUFFER;
         delayed_or_added_address_sel   = ADDED_ADDRESS;
         direct_or_modified_address_sel = MODIFIED_ADDRESS;
      end // end case LOAD_WORD_B

      //################################## LOAD_WORD_C##########################
      // #######################################################################
      LOAD_WORD_C: begin
         // status signals
         busy                           = 0;
         output_valid                   = 1;
         write_ready                    = 0;

         // fsm control
         fsm_rd                         = 0;
         fsm_wr                         = 0;
         fsm_wr_en                      = 0;
         fsm_rd_en                      = 0;
         fsm_mem_en                     = 1;

         // status in buffering
         is_signed_buffer_sel           = UPDATE;
         word_type_buffer_sel           = UPDATE;

         // input selection feedback
         from_mem_feedback_sel          = DC;
         2mem_data_in_top8_feedback_sel = INPUT_TO_MEM;
         2mem_data_in_low8_feedback_sel = INPUT_TO_MEM;

         // input selection
         from_cpu_low8_input_sel    = DIRECT_L8;
         from_cpu_top8_input_sel    = DIRECT_ML8;
         l8_t8_buffer_sel           = UPDATE;
         l8_mt8_buffer_sel          = UPDATE;
         l8_ml8_buffer_sel          = UPDATE;
         l8_l8_buffer_sel           = UPDATE;
         t8_t8_buffer_sel           = UPDATE;
         t8_mt8_buffer_sel          = UPDATE;
         t8_ml8_buffer_sel          = UPDATE;
         t8_l8_buffer_sel           = UPDATE;



         // output assignment
         data_out_pre_L8_sel            = L8_DELAYED2_T8; // 2 bit
         data_out_pre_ML8_sel           = ML8_DELAYED1_L8 // 3 bit
         data_out_pre_MT8_sel           = MT8_DELAYED1_T8; // 3 bit
         data_out_pre_T8_sel            = T8_DIRECT_L8; // 3 bit

         output_shuffle_sel             = 1;

         // address assignment
         adder_summand_sel              = SEL_ONE;
         added_address_buffer_sel       = UPDATE;
         delayed_address_buffer_sel     = UPDATE;
         delayed_or_added_address_sel   = DC;
         direct_or_modified_address_sel = DIRECT_ADDRESS;
      end // end case LOAD_WORD_C

      // ############################### STORE_BYTE_A #########################
      // ######################################################################
      STORE_BYTE_A: begin
         // status signals
         busy                           = 1;
         output_valid                   = 0;
         write_ready                    = 0;

         // fsm control
         fsm_rd                         = 0;
         fsm_wr                         = 0;
         fsm_wr_en                      = 0;
         fsm_rd_en                      = 0;
         fsm_mem_en                     = 1;

         // status in buffering
         is_signed_buffer_sel           = UPDATE;
         word_type_buffer_sel           = UPDATE;

         // input selection feedback
         from_mem_feedback_sel          = bit0_delayed1 ? FEEDBACK_LOW8   : FEEDBACK_TOP8;
         2mem_data_in_top8_feedback_sel = bit0_delayed1 ? INPUT_TO_MEM    : FEEDBACK_TO_MEM;
         2mem_data_in_low8_feedback_sel = bit0_delayed1 ? FEEDBACK_TO_MEM : INPUT_TO_MEM;

         // input selection
        from_cpu_low8_input_sel         = DELAYED_L8;
        from_cpu_top8_input_sel         = DELAYED_T8;
        l8_t8_buffer_sel                = BUFFER;
        l8_mt8_buffer_sel               = BUFFER;
        l8_ml8_buffer_sel               = BUFFER;
        l8_l8_buffer_sel                = BUFFER;
        t8_t8_buffer_sel                = BUFFER;
        t8_mt8_buffer_sel               = BUFFER;
        t8_ml8_buffer_sel               = BUFFER;
        t8_l8_buffer_sel                = BUFFER;



         // output assignment
         data_out_pre_L8_sel            = DC2; // 2 bit
         data_out_pre_ML8_sel           = DC3; // 3 bit
         data_out_pre_MT8_sel           = DC3; // 3 bit
         data_out_pre_T8_sel            = DC3; // 3 bit

         output_shuffle_sel             = 0;

         // address assignment
         adder_summand_sel              = SEL_ONE;
         added_address_buffer_sel       = UPDATE;
         delayed_address_buffer_sel     = UPDATE;
         delayed_or_added_address_sel   = DELAYED_ADDRESS;
         direct_or_modified_address_sel = MODIFIED_ADDRESS;
      end // end case STORE_BYTE_A


      // ############################### STORE_BYTE_B #########################
      // ######################################################################
      STORE_BYTE_B: begin
         // status signals
         busy                           = 0;
         output_valid                   = 0;
         write_ready                    = 1;

         // fsm control
         fsm_rd                         = 0;
         fsm_wr                         = 0;
         fsm_wr_en                      = 0;
         fsm_rd_en                      = 0;
         fsm_mem_en                     = 1;

         // status in buffering
         is_signed_buffer_sel           = UPDATE;
         word_type_buffer_sel           = UPDATE;

         // input selection feedback
         from_mem_feedback_sel          = DC;
         2mem_data_in_top8_feedback_sel = INPUT_TO_MEM;
         2mem_data_in_low8_feedback_sel = INPUT_TO_MEM;

         // input selection
         from_cpu_low8_input_sel    = DIRECT_L8;
         from_cpu_top8_input_sel    = DIRECT_ML8;
         l8_t8_buffer_sel           = UPDATE;
         l8_mt8_buffer_sel          = UPDATE;
         l8_ml8_buffer_sel          = UPDATE;
         l8_l8_buffer_sel           = UPDATE;
         t8_t8_buffer_sel           = UPDATE;
         t8_mt8_buffer_sel          = UPDATE;
         t8_ml8_buffer_sel          = UPDATE;
         t8_l8_buffer_sel           = UPDATE;



         // output assignment
         data_out_pre_L8_sel            = DC2; // 2 bit
         data_out_pre_ML8_sel           = DC3 // 3 bit
         data_out_pre_MT8_sel           = DC3; // 3 bit
         data_out_pre_T8_sel            = DC3; // 3 bit

         output_shuffle_sel             = 0;

         // address assignment
         adder_summand_sel              = SEL_ONE;
         added_address_buffer_sel       = UPDATE;
         delayed_address_buffer_sel     = UPDATE;
         delayed_or_added_address_sel   = DC;
         direct_or_modified_address_sel = DIRECT_ADDRESS;
      end // end case STORE_BYTE_B

      // ############################### STORE_HW_A  ##########################
      // ######################################################################
      STORE_HW_A: begin
         // status signals
         busy                           = bit0_delayed1;
         output_valid                   = 0;
         write_ready                    = !bit0_delayed1;

         // fsm control
         fsm_rd                         = bit0_delayed1;
         fsm_wr                         = bit0_delayed1;
         fsm_wr_en                      = 1;
         fsm_rd_en                      = 1;
         fsm_mem_en                     = 1;

         // status in buffering
         is_signed_buffer_sel           = bit0_delayed1 ? BUFFER : UPDATE;
         word_type_buffer_sel           = bit0_delayed1 ? BUFFER : UPDATE;

         // input selection feedback
         from_mem_feedback_sel          = FEEDBACK_LOW8;
         2mem_data_in_top8_feedback_sel = INPUT_TO_MEM;
         2mem_data_in_low8_feedback_sel = bit0_delayed1 ? FEEDBACK_TO_MEM : INPUT_TO_MEM;

         // input selection
         from_cpu_low8_input_sel    = DELAYED_L8;
         from_cpu_top8_input_sel    = bit0_delayed1 ? DELAYED_ML8 : DELAYED_L8;
         l8_t8_buffer_sel           = bit0_delayed1 ? BUFFER : UPDATE;
         l8_mt8_buffer_sel          = bit0_delayed1 ? BUFFER : UPDATE;
         l8_ml8_buffer_sel          = bit0_delayed1 ? BUFFER : UPDATE;
         l8_l8_buffer_sel           = bit0_delayed1 ? BUFFER : UPDATE;
         t8_t8_buffer_sel           = bit0_delayed1 ? BUFFER : UPDATE;
         t8_mt8_buffer_sel          = bit0_delayed1 ? BUFFER : UPDATE;
         t8_ml8_buffer_sel          = bit0_delayed1 ? BUFFER : UPDATE;
         t8_l8_buffer_sel           = bit0_delayed1 ? BUFFER : UPDATE;


         // output assignment
         data_out_pre_L8_sel            = DC2; // 2 bit
         data_out_pre_ML8_sel           = DC3; // 3 bit
         data_out_pre_MT8_sel           = DC3; // 3 bit
         data_out_pre_T8_sel            = DC3; // 3 bit

         output_shuffle_sel             = 0;

         // address assignment
         adder_summand_sel              = SEL_ONE;
         added_address_buffer_sel       = bit0_delayed1 ? BUFFER : UPDATE;
         delayed_address_buffer_sel     = bit0_delayed1 ? BUFFER : UPDATE;
         delayed_or_added_address_sel   = DELAYED_ADDRESS;
         direct_or_modified_address_sel = bit0_delayed1 ? MODIFIED_ADDRESS : DIRECT_ADDRESS;
      end // end case STORE_HW_A

      // ############################### STORE_HW_B ###########################
      // ######################################################################
      STORE_HW_B: begin
         // status signals
         busy                           = 1;
         output_valid                   = 0;
         write_ready                    = 0;

         // fsm control
         fsm_rd                         = 1;
         fsm_wr                         = 0;
         fsm_wr_en                      = 1;
         fsm_rd_en                      = 1;
         fsm_mem_en                     = 1;

         // status in buffering
         is_signed_buffer_sel           = BUFFER;
         word_type_buffer_sel           = BUFFER;

         // input selection feedback
         from_mem_feedback_sel          = DC;
         2mem_data_in_top8_feedback_sel = DC;
         2mem_data_in_low8_feedback_sel = DC;

         // input selection
         from_cpu_low8_input_sel    = DC3;
         from_cpu_top8_input_sel    = DC3;
         l8_t8_buffer_sel           = BUFFER;
         l8_mt8_buffer_sel          = BUFFER;
         l8_ml8_buffer_sel          = BUFFER;
         l8_l8_buffer_sel           = BUFFER;
         t8_t8_buffer_sel           = BUFFER;
         t8_mt8_buffer_sel          = BUFFER;
         t8_ml8_buffer_sel          = BUFFER;
         t8_l8_buffer_sel           = BUFFER;
         end

         // output assignment
         data_out_pre_L8_sel            = DC2; // 2 bit
         data_out_pre_ML8_sel           = DC3; // 3 bit
         data_out_pre_MT8_sel           = DC3; // 3 bit
         data_out_pre_T8_sel            = DC3; // 3 bit

         output_shuffle_sel             = 0;

         // address assignment
         adder_summand_sel              = SEL_ONE;
         added_address_buffer_sel       = BUFFER;
         delayed_address_buffer_sel     = BUFFER;
         delayed_or_added_address_sel   = ADDED_ADDRESS;
         direct_or_modified_address_sel = MODIFIED_ADDRESS;
      end // end case STORE_HW_B

      // ############################### STORE_HW_C  ##########################
      // ######################################################################
      STORE_HW_C: begin
         // status signals
         busy                           = 1;
         output_valid                   = 0;
         write_ready                    = 0;

         // fsm control
         fsm_rd                         = 1;
         fsm_wr                         = 0;
         fsm_wr_en                      = 1;
         fsm_rd_en                      = 1;
         fsm_mem_en                     = 1;

         // status in buffering
         is_signed_buffer_sel           = BUFFER;
         word_type_buffer_sel           = BUFFER;

         // input selection feedback
         from_mem_feedback_sel          = FEEDBACK_TOP8;
         2mem_data_in_top8_feedback_sel = FEEDBACK_TO_MEM;
         2mem_data_in_low8_feedback_sel = INPUT_TO_MEM;

         // input selection
         from_cpu_low8_input_sel    = DELAYED_ML8;
         from_cpu_top8_input_sel    = DC3;
         l8_t8_buffer_sel           = UPDATE;
         l8_mt8_buffer_sel          = UPDATE;
         l8_ml8_buffer_sel          = UPDATE;
         l8_l8_buffer_sel           = UPDATE;
         t8_t8_buffer_sel           = UPDATE;
         t8_mt8_buffer_sel          = UPDATE;
         t8_ml8_buffer_sel          = UPDATE;
         t8_l8_buffer_sel           = UPDATE;
         // output assignment
         data_out_pre_L8_sel            = DC2; // 2 bit
         data_out_pre_ML8_sel           = DC3; // 3 bit
         data_out_pre_MT8_sel           = DC3; // 3 bit
         data_out_pre_T8_sel            = DC3; // 3 bit

         output_shuffle_sel             = 0;

         // address assignment
         adder_summand_sel              = SEL_ONE;
         added_address_buffer_sel       = bit0_delayed1 ? BUFFER : UPDATE;
         delayed_address_buffer_sel     = bit0_delayed1 ? BUFFER : UPDATE;
         delayed_or_added_address_sel   = ADDED_ADDRESS;
         direct_or_modified_address_sel = bit0_delayed1 ? MODIFIED_ADDRESS : DIRECT_ADDRESS;
      end // end case STORE_HW_C

      // ############################### STORE_HW_D #########################
      // ######################################################################
      STORE_HW_D: begin
         // status signals
         busy                           = 0;
         output_valid                   = 0;
         write_ready                    = 1;

         // fsm control
         fsm_rd                         = DC;
         fsm_wr                         = DC;
         fsm_wr_en                      = 0 ;
         fsm_rd_en                      = 0 ;
         fsm_mem_en                     = 1 ;

         // status in buffering
         is_signed_buffer_sel           = UPDATE ;
         word_type_buffer_sel           = UPDATE ;

         // input selection feedback
         from_mem_feedback_sel          = DC;
         2mem_data_in_top8_feedback_sel = INPUT_TO_MEM;
         2mem_data_in_low8_feedback_sel = INPUT_TO_MEM;

         // input selection
         from_cpu_low8_input_sel    = DIRECT_L8;
         from_cpu_top8_input_sel    = DIRECT_ML8;
         l8_t8_buffer_sel           = UPDATE;
         l8_mt8_buffer_sel          = UPDATE;
         l8_ml8_buffer_sel          = UPDATE;
         l8_l8_buffer_sel           = UPDATE;
         t8_t8_buffer_sel           = UPDATE;
         t8_mt8_buffer_sel          = UPDATE;
         t8_ml8_buffer_sel          = UPDATE;
         t8_l8_buffer_sel           = UPDATE;



         // output assignment
         data_out_pre_L8_sel            = DC2; // 2 bit
         data_out_pre_ML8_sel           = DC3; // 3 bit
         data_out_pre_MT8_sel           = DC3; // 3 bit
         data_out_pre_T8_sel            = DC3; // 3 bit

         output_shuffle_sel             = 0;

         // address assignment
         adder_summand_sel              = SEL_ONE;
         added_address_buffer_sel       = UPDATE;
         delayed_address_buffer_sel     = UPDATE;
         delayed_or_added_address_sel   = DC;
         direct_or_modified_address_sel = DIRECT_ADDRESS;

      end // end case STORE_HW_D

         // ############################### STORE_WORD_A  ##########################
         // ######################################################################
         STORE_WORD_A: begin
            // status signals
            busy                           = 1;
            output_valid                   = 0;
            write_ready                    = 0;

            // fsm control
            fsm_rd                         = 0;
            fsm_wr                         = 1;
            fsm_wr_en                      = 1;
            fsm_rd_en                      = 1;
            fsm_mem_en                     = 1;

            // status in buffering
            is_signed_buffer_sel           = BUFFER;
            word_type_buffer_sel           = BUFFER;

            // input selection feedback
            from_mem_feedback_sel          = FEEDBACK_LOW8;
            2mem_data_in_top8_feedback_sel = INPUT_TO_MEM;
            2mem_data_in_low8_feedback_sel = bit0_delayed1 ? FEEDBACK_TO_MEM : INPUT_TO_MEM;

            // input selection
            from_cpu_low8_input_sel    = DELAYED_L8;
            from_cpu_top8_input_sel    = bit0_delayed1 ? DELAYED_L8: DELAYED_ML8;
            l8_t8_buffer_sel           = bit0_delayed1 ? BUFFER : UPDATE;
            l8_mt8_buffer_sel          = bit0_delayed1 ? BUFFER : UPDATE;
            l8_ml8_buffer_sel          = bit0_delayed1 ? BUFFER : UPDATE;
            l8_l8_buffer_sel           = bit0_delayed1 ? BUFFER : UPDATE;
            t8_t8_buffer_sel           = bit0_delayed1 ? BUFFER : UPDATE;
            t8_mt8_buffer_sel          = bit0_delayed1 ? BUFFER : UPDATE;
            t8_ml8_buffer_sel          = bit0_delayed1 ? BUFFER : UPDATE;
            t8_l8_buffer_sel           = bit0_delayed1 ? BUFFER : UPDATE;


            // output assignment
            data_out_pre_L8_sel            = DC2; // 2 bit
            data_out_pre_ML8_sel           = DC3; // 3 bit
            data_out_pre_MT8_sel           = DC3; // 3 bit
            data_out_pre_T8_sel            = DC3; // 3 bit

            output_shuffle_sel             = 0;

            // address assignment
            adder_summand_sel              = SEL_ONE;
            added_address_buffer_sel       = BUFFER ;
            delayed_address_buffer_sel     = BUFFER;
            delayed_or_added_address_sel   = DELAYED_ADDRESS;
            direct_or_modified_address_sel = MODIFIED_ADDRESS;
         end // end case STORE_WORD_A

      // ############################### STORE_WORD_B #########################
      // ######################################################################
      STORE_WORD_B: begin
         // status signals
         busy                           = bit0_delayed2;
         output_valid                   = 0;
         write_ready                    = !bit0_delayed2;

         // fsm control
         fsm_rd                         = 0;
         fsm_wr                         = 1;
         fsm_wr_en                      = bit0_delayed2 ;
         fsm_rd_en                      = bit0_delayed2 ;
         fsm_mem_en                     = 1;

         // status in buffering
         is_signed_buffer_sel           = bit0_delayed2 ? BUFFER : UPDATE;
         word_type_buffer_sel           = bit0_delayed2 ? BUFFER : UPDATE;

         // input selection feedback
         from_mem_feedback_sel          = FEEDBACK_LOW8;
         2mem_data_in_top8_feedback_sel = INPUT_TO_MEM;
         2mem_data_in_low8_feedback_sel = INPUT_TO_MEM;

         // input selection
         from_cpu_low8_input_sel    = bit0_delayed2 ? DELAYED_ML8: DELAYED_MT8;
         from_cpu_top8_input_sel    = bit0_delayed2 ? DELAYED_MT8: DELAYED_T8;
         l8_t8_buffer_sel           = bit0_delayed2 ? BUFFER : UPDATE;
         l8_mt8_buffer_sel          = bit0_delayed2 ? BUFFER : UPDATE;
         l8_ml8_buffer_sel          = bit0_delayed2 ? BUFFER : UPDATE;
         l8_l8_buffer_sel           = bit0_delayed2 ? BUFFER : UPDATE;
         t8_t8_buffer_sel           = bit0_delayed2 ? BUFFER : UPDATE;
         t8_mt8_buffer_sel          = bit0_delayed2 ? BUFFER : UPDATE;
         t8_ml8_buffer_sel          = bit0_delayed2 ? BUFFER : UPDATE;
         t8_l8_buffer_sel           = bit0_delayed2 ? BUFFER : UPDATE;


         // output assignment
         data_out_pre_L8_sel            = DC2; // 2 bit
         data_out_pre_ML8_sel           = DC3; // 3 bit
         data_out_pre_MT8_sel           = DC3; // 3 bit
         data_out_pre_T8_sel            = DC3; // 3 bit

         output_shuffle_sel             = 0;

         // address assignment
         adder_summand_sel              = SEL_ONE;
         added_address_buffer_sel       = bit0_delayed2 ? BUFFER : UPDATE;
         delayed_address_buffer_sel     = bit0_delayed2 ? BUFFER : UPDATE;
         delayed_or_added_address_sel   = ADDED_ADDRESS;
         direct_or_modified_address_sel = bit0_delayed2 ? MODIFIED_ADDRESS : DIRECT_ADDRESS;
      end // end case STORE_WORD_B

      // ############################## STORE_WORD_C ##########################
      // ######################################################################
      STORE_WORD_C: begin
         // status signals
         busy                           = 1;
         output_valid                   = 0;
         write_ready                    = 0;

         // fsm control
         fsm_rd                         = 1;
         fsm_wr                         = 0;
         fsm_wr_en                      = 0 ;
         fsm_rd_en                      = 1 ;
         fsm_mem_en                     = 1;

         // status in buffering
         is_signed_buffer_sel           = BUFFER;
         word_type_buffer_sel           = BUFFER;

         // input selection feedback
         from_mem_feedback_sel          = FEEDBACK_LOW8;
         2mem_data_in_top8_feedback_sel = INPUT_TO_MEM;
         2mem_data_in_low8_feedback_sel = INPUT_TO_MEM;

         // input selection
         from_cpu_low8_input_sel    =  DELAYED_ML8: DELAYED_MT8;
         from_cpu_top8_input_sel    =  DELAYED_MT8: DELAYED_T8;
         l8_t8_buffer_sel           =  BUFFER;
         l8_mt8_buffer_sel          =  BUFFER;
         l8_ml8_buffer_sel          =  BUFFER;
         l8_l8_buffer_sel           =  BUFFER;
         t8_t8_buffer_sel           =  BUFFER;
         t8_mt8_buffer_sel          =  BUFFER;
         t8_ml8_buffer_sel          =  BUFFER;
         t8_l8_buffer_sel           =  BUFFER;


         // output assignment
         data_out_pre_L8_sel            = DC2; // 2 bit
         data_out_pre_ML8_sel           = DC3; // 3 bit
         data_out_pre_MT8_sel           = DC3; // 3 bit
         data_out_pre_T8_sel            = DC3; // 3 bit

         output_shuffle_sel             = 0;

         // address assignment
         adder_summand_sel              = SEL_TWO;
         added_address_buffer_sel       =  BUFFER;
         delayed_address_buffer_sel     =  BUFFER;
         delayed_or_added_address_sel   = ADDED_ADDRESS;
         direct_or_modified_address_sel = MODIFIED_ADDRESS;
      end // end case STORE_WORD_C

      // ############################### STORE_WORD_D #########################
      // ######################################################################
      STORE_WORD_D: begin
         // status signals
         busy                           = 1;
         output_valid                   = 0;
         write_ready                    = 0;

         // fsm control
         fsm_rd                         = 0;
         fsm_wr                         = 1;
         fsm_wr_en                      = 1 ;
         fsm_rd_en                      = 1 ;
         fsm_mem_en                     = 1;

         // status in buffering
         is_signed_buffer_sel           = BUFFER;
         word_type_buffer_sel           = BUFFER;

         // input selection feedback
         from_mem_feedback_sel          = FEEDBACK_TOP8;
         2mem_data_in_top8_feedback_sel = FEEDBACK_TOP8;
         2mem_data_in_low8_feedback_sel = INPUT_TO_MEM;

         // input selection
         from_cpu_low8_input_sel    =  DELAYED_T8;
         from_cpu_top8_input_sel    =  DC3;
         l8_t8_buffer_sel           =  BUFFER;
         l8_mt8_buffer_sel          =  BUFFER;
         l8_ml8_buffer_sel          =  BUFFER;
         l8_l8_buffer_sel           =  BUFFER;
         t8_t8_buffer_sel           =  BUFFER;
         t8_mt8_buffer_sel          =  BUFFER;
         t8_ml8_buffer_sel          =  BUFFER;
         t8_l8_buffer_sel           =  BUFFER;


         // output assignment
         data_out_pre_L8_sel            = DC2; // 2 bit
         data_out_pre_ML8_sel           = DC3; // 3 bit
         data_out_pre_MT8_sel           = DC3; // 3 bit
         data_out_pre_T8_sel            = DC3; // 3 bit

         output_shuffle_sel             = 0;

         // address assignment
         adder_summand_sel              = SEL_TWO;
         added_address_buffer_sel       =  BUFFER;
         delayed_address_buffer_sel     =  BUFFER;
         delayed_or_added_address_sel   = ADDED_ADDRESS;
         direct_or_modified_address_sel = MODIFIED_ADDRESS;
      end // end case STORE_WORD_D

      // ############################### STORE_WORD_E #########################
      // ######################################################################
      STORE_WORD_E: begin
         // status signals
         busy                           = 0;
         output_valid                   = 0;
         write_ready                    = 1;

         // fsm control
         fsm_rd                         = 0;
         fsm_wr                         = 0;
         fsm_wr_en                      = 0 ;
         fsm_rd_en                      = 0 ;
         fsm_mem_en                     = 1;

         // status in buffering
         is_signed_buffer_sel           = UPDATE;
         word_type_buffer_sel           = UPDATE;

         // input selection feedback
         from_mem_feedback_sel          = FEEDBACK_TOP8;
         2mem_data_in_top8_feedback_sel = INPUT_TO_MEM;
         2mem_data_in_low8_feedback_sel = INPUT_TO_MEM;

         // input selection
         from_cpu_low8_input_sel    =  DIRECT_L8;
         from_cpu_top8_input_sel    =  DIRECT_ML8;
         l8_t8_buffer_sel           =  UPDATE;
         l8_mt8_buffer_sel          =  UPDATE;
         l8_ml8_buffer_sel          =  UPDATE;
         l8_l8_buffer_sel           =  UPDATE;
         t8_t8_buffer_sel           =  UPDATE;
         t8_mt8_buffer_sel          =  UPDATE;
         t8_ml8_buffer_sel          =  UPDATE;
         t8_l8_buffer_sel           =  UPDATE;


         // output assignment
         data_out_pre_L8_sel            = DC2; // 2 bit
         data_out_pre_ML8_sel           = DC3; // 3 bit
         data_out_pre_MT8_sel           = DC3; // 3 bit
         data_out_pre_T8_sel            = DC3; // 3 bit

         output_shuffle_sel             = 0;

         // address assignment
         adder_summand_sel              = SEL_ONE;
         added_address_buffer_sel       =  UPDATE;
         delayed_address_buffer_sel     =  UPDATE;
         delayed_or_added_address_sel   = DELAYED_ADDRESS;
         direct_or_modified_address_sel = DIRECT_ADDRESS;
      end // end case STORE_WORD_E



    endcase
end

endmodule
