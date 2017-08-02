// AUTHORS Group 06 / Julian Käuser
// Tuesday 08/01/2017

// codes for word_type
`define WORD 2'b10
`define HALFWORD 2'b01
`define BYTE 2'b00

// codes for first_two_bytes_out_select
`define TOP_HALFWORD 2'b00
`define SIGN_B 2'b01
`define SIGN_A 2'11
`define ZEROS 2'b00

// codes for third_byte_out_select
`define THIRD_BYTE_ORIGINAL 2'b10
`define THIRD_BYTE_SIGN_EXTENDED 2'b00
`define THIRD_BYTE_ZERO_EXTENDED 2'b01

// codes for direct_or_delayed_din
`define DIRECT_TOP16 2'b00
`define DIRECT_LOW16 2'b01
`define DELAYED_TOP16 2'b10
`define DELAYED_LOW16 2'b11

`define TOP16 31:16
`define LOW16 15:0





module memory_control_fsm(
  is_signed,
  word_type,
  output_valid,
  write_ready,
  load,
  store,
  direct_or_delayed_din,
  old_or_new_byte_remainder,
  modified_or_original_address,
  added_or_delayed_address,
  first_two_bytes_out_select,
  third_byte_out_select,
  mem_read_enable,
  mem_write_enable,
  mem_enable,
  clk,
  reset
  );

  input is_signed;
  input [1:0] word_type;
  input load;
  input store;
  input clk;
  input reset;

  output reg output_valid;
  output reg [1:0] direct_or_delayed_din;
  output reg write_ready;
  output reg old_or_new_byte_remainder;
  output reg modified_or_original_address;
  output reg added_or_delayed_address;
  output reg [1:0] first_two_bytes_out_select;
  output reg [1:0] third_byte_out_select;

  output reg mem_read_enable;
  output reg mem_write_enable;
  output reg mem_enable;



  reg [3:0] state;
  reg [3:0] nextstate;

  // some states
  localparam IDLE          =  4'b0000;
  localparam LOAD_HW       =  4'b0001;
  localparam LOAD_BYTE     =  4'b0010;
  localparam LOAD_WORD_A   =  4'b0011;
  localparam LOAD_WORD_B   =  4'b0100;

  localparam STORE_HW      =  4'b1111;
  localparam STORE_BYTE_A  =  4'b1011;
  localparam STORE_BYTE_B  =  4'b1010;
  localparam STORE_WORD_A  =  4'b1101;
  localparam STORE_WORD_B  =  4'b1100;

// make state register flipflop
  always @(posedge clk) begin
    if (!reset) begin
      state <= nextstate;
    end
    else begin
      state <= IDLE;
    end
  end

  // state transition logic
  always @(*) begin
   case (state)
     IDLE: begin
       if (load) begin
        case(word_type)
          `WORD:     nextstate = LOAD_WORD_A;
          `HALFWORD: nextstate = LOAD_HW;
          `BYTE:     nextstate = LOAD_BYTE;
        endcase
       end //if load
       else if(store) begin
         case(word_type)
           `WORD:      nextstate = STORE_WORD_A;
           `HALFWORD:  nextstate = STORE_HW;
           `BYTE:      nextstate = STORE_BYTE_A;
         endcase
       end //else if store
       else begin
           nextstate = IDLE;
       end
     end //case idle
     LOAD_HW: begin


     end // case LOAD_HW
     LOAD_BYTE: begin

     end// case LOAD_BYTE
     LOAD_WORD_A: begin

     end // case load wordA
     LOAD_WORD_B: begin

     end // case load wordB
     STORE_HW: begin

     end // case STORE_HW
     STORE_WORD_A: begin

     end // case STORE_WORD_A
     STORE_WORD_B: begin

     end // case store word b
     STORE_BYTE_A: begin

     end //case store_byte a
     STORE_BYTE_B: begin

     end //case store_byte b

   endcase // state
  end

// output logic
  always @(*) begin
    case (state)
    IDLE: begin

    end // case idle
    LOAD_HW: begin


    end // case LOAD_HW
    LOAD_BYTE: begin

    end// case LOAD_BYTE
    LOAD_WORD_A: begin

    end // case load wordA
    LOAD_WORD_B: begin

    end // case load wordB
    STORE_HW: begin

    end // case STORE_HW
    STORE_WORD_A: begin

    end // case STORE_WORD_A
    STORE_WORD_B: begin

    end // case store word b
    STORE_BYTE_A: begin

    end //case store_byte a
    STORE_BYTE_B: begin

    end //case store_byte b


   endcase
  end


  endmodule


  // codes for word_type
  `undef WORD
  `undef HALFWORD
  `undef BYTE

  // codes for first_two_bytes_out_select
  `undef TOP_HALFWORD
  `undef SIGN_B
  `undef SIGN_A
  `undef ZEROS

  // codes for third_byte_out_select
  `undef THIRD_BYTE_ORIGINAL
  `undef THIRD_BYTE_SIGN_EXTENDED
  `undef THIRD_BYTE_ZERO_EXTENDED

  // codes for direct_or_delayed_din
  `undef DIRECT_TOP16
  `undef DIRECT_LOW16
  `undef DELAYED_TOP16
  `undef DELAYED_LOW16

  `undef TOP16
  `undef LOW16
