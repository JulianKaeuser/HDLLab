// AUTHORS Group 06 / Julian Käuser
// Tuesday 08/01/2017

// codes for word_type
`define WORD 2'b10
`define HALFWORD 2'b01
`define BYTE 2'b00

// codes for first_two_bytes_out_select
`define TOP_HALFWORD 2'b10
`define SIGN_B 2'b01
`define SIGN_A 2'b11
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

`define DC 1'b1





module memory_control_fsm(
  is_signed_fsm,
  word_type,
  load,
  store,
  clk,
  reset,
  output_valid,
  direct_or_delayed_din,
  write_ready,
  old_or_new_byte_remainder,
  modified_or_original_address,
  added_or_delayed_address,
  first_two_bytes_out_select,
  third_byte_out_select,
  output_shuffle,
  mem_read_enable,
  mem_write_enable,
  mem_enable,
  fsm_read_control,
  fsm_write_control,
  busy
  );

  input wire is_signed_fsm;
  input wire [1:0] word_type;
  input wire load;
  input wire store;
  input wire clk;
  input wire reset;

  output reg output_valid;
  output reg [1:0] direct_or_delayed_din;
  output reg write_ready;
  output reg old_or_new_byte_remainder;
  output reg modified_or_original_address;
  output reg added_or_delayed_address;
  output reg [1:0] first_two_bytes_out_select;
  output reg [1:0] third_byte_out_select;
  output reg output_shuffle;
  output reg mem_read_enable;
  output reg mem_write_enable;
  output reg mem_enable;

  output reg fsm_read_control;
  output reg fsm_write_control;

  output reg busy;



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
			default: nextstate = IDLE;
        endcase
       end //if load
       else if(store) begin
         case(word_type)
           `WORD:      nextstate = STORE_WORD_A;
           `HALFWORD:  nextstate = STORE_HW;
           `BYTE:      nextstate = STORE_BYTE_A;
			default: nextstate = IDLE;
         endcase
       end //else if store
       else begin
           nextstate = IDLE;
       end
     end //case idle

     LOAD_HW: begin
         nextstate = IDLE;
     end // case LOAD_HW

     LOAD_BYTE: begin
         nextstate = IDLE;
     end// case LOAD_BYTE

     LOAD_WORD_A: begin
        nextstate = LOAD_WORD_B;
     end // case load wordA

     LOAD_WORD_B: begin
        nextstate = IDLE;
     end // case load wordB

     STORE_HW: begin
         nextstate = IDLE;
     end // case STORE_HW

     STORE_WORD_A: begin
        nextstate = STORE_WORD_B;
     end // case STORE_WORD_A

     STORE_WORD_B: begin
        nextstate = IDLE;
     end // case store word B

     STORE_BYTE_A: begin
        nextstate = STORE_BYTE_B;
     end //case store_byte A

     STORE_BYTE_B: begin
        nextstate = IDLE;
     end //case store_byte b

	default: begin
		nextstate = IDLE;
	end

   endcase // state
  end

// output logic
  always @(*) begin
    case (state)
    //newcase IDLE
    IDLE: begin
      output_valid                  =0                   ;
      direct_or_delayed_din         =`DIRECT_LOW16       ; // 2 signals
      write_ready                   =0                   ;
      old_or_new_byte_remainder     =1                ; // old =0, new =1 (where new is that which was not in the memory before)
      modified_or_original_address  =1                   ; // 1= original, 0 = modified
      added_or_delayed_address      =`DC                 ; // 1 = added, 0 = delayed
      first_two_bytes_out_select    ={`DC,`DC}           ; // 2 signals
      third_byte_out_select         ={`DC,`DC}           ; // 2 signals
      output_shuffle                =0                   ;

      mem_read_enable               =`DC      ;
      mem_write_enable              =`DC      ;
      mem_enable                    =1        ;
      fsm_read_control              =0        ;
      fsm_write_control             =0        ;
      busy                          =0        ;
    end // endcase idle

    // newcase: LOAD HW
    LOAD_HW: begin
      output_valid                  =1                   ;
      direct_or_delayed_din         ={`DC,`DC}           ; // 2 signals
      write_ready                   =0                   ;
      old_or_new_byte_remainder     =`DC                 ;
      modified_or_original_address  =`DC                 ; // 1= original, 0 = modified
      added_or_delayed_address      =`DC                 ; // 1 = added, 0 = delayed
      first_two_bytes_out_select    =is_signed_fsm ? `SIGN_B : `ZEROS;    // 2 signals
      third_byte_out_select         =`THIRD_BYTE_ORIGINAL ; // 2 signals
      output_shuffle                =0                   ;

      mem_read_enable               =1        ;
      mem_write_enable              =0        ;
      mem_enable                    =1        ;
      fsm_read_control              =1        ;
      fsm_write_control             =1        ;
      busy                          =1        ;

    end // endcase LOAD HW

    //newcase LOAD_BYTE
    LOAD_BYTE: begin
      output_valid                  =1                   ;
      direct_or_delayed_din         ={`DC,`DC}           ; // 2 signals
      write_ready                   =0                   ;
      old_or_new_byte_remainder     =`DC                 ;
      modified_or_original_address  =`DC                 ; // 1= original, 0 = modified
      added_or_delayed_address      =`DC                 ; // 1 = added, 0 = delayed
      first_two_bytes_out_select    =is_signed_fsm ? `SIGN_A : `ZEROS;    // 2 signals
      third_byte_out_select         =is_signed_fsm ? `THIRD_BYTE_SIGN_EXTENDED : `THIRD_BYTE_ZERO_EXTENDED; // 2 signals
      output_shuffle                =0                   ;

      mem_read_enable               =1        ;
      mem_write_enable              =0        ;
      mem_enable                    =1        ;
      fsm_read_control              =1        ;
      fsm_write_control             =1        ;
      busy                          =1        ;

    end// endcase LOAD_BYTE

    //newcase LOAD_WORD_A
    LOAD_WORD_A: begin
      output_valid                  =0                   ;
      direct_or_delayed_din         ={`DC,`DC}           ; // 2 signals
      write_ready                   =0                   ;
      old_or_new_byte_remainder     =`DC                 ;
      modified_or_original_address  =0                   ; // 1= original, 0 = modified
      added_or_delayed_address      =1                   ;   // 1 = added, 0 = delayed
      first_two_bytes_out_select    ={`DC,`DC}           ; // 2 signals
      third_byte_out_select         ={`DC,`DC}           ; // 2 signals
      output_shuffle                =0                   ;

      mem_read_enable               =1        ;
      mem_write_enable              =0        ;
      mem_enable                    =1        ;
      fsm_read_control              =1        ;
      fsm_write_control             =1        ;
      busy                          =1        ;

    end // endcase LOAD_WORD_A

    //newcase LOAD_WORD_B
    LOAD_WORD_B: begin
      output_valid                  =1                   ;
      direct_or_delayed_din         ={`DC,`DC}           ; // 2 signals
      write_ready                   =0                   ;
      old_or_new_byte_remainder     =`DC                 ;
      modified_or_original_address  =`DC                 ; // 1= original, 0 = modified
      added_or_delayed_address      =`DC                 ; // 1 = added, 0 = delayed
      first_two_bytes_out_select    =`TOP_HALFWORD       ; // 2 signals
      third_byte_out_select         =`THIRD_BYTE_ORIGINAL; // 2 signals
      output_shuffle                =1                   ;

      mem_read_enable               =1        ;
      mem_write_enable              =0        ;
      mem_enable                    =1        ;
      fsm_read_control              =1        ;
      fsm_write_control             =1        ;
      busy                          =1        ;

    end // endcase LOAD_WORD_B

    // newcase STORE_HW
    STORE_HW: begin
      output_valid                  =0                   ;
      direct_or_delayed_din         ={`DC,`DC}           ; // 2 signals
      write_ready                   =1                   ;
      old_or_new_byte_remainder     =`DC                 ; // old =0, new =1 (where new is that which was not in the memory before)
      modified_or_original_address  =`DC                 ; // 1= original, 0 = modified
      added_or_delayed_address      =`DC                 ; // 1 = added, 0 = delayed
      first_two_bytes_out_select    ={`DC,`DC}           ; // 2 signals
      third_byte_out_select         ={`DC,`DC}           ; // 2 signals

      mem_read_enable               =0        ;
      mem_write_enable              =0        ;
      mem_enable                    =1        ;
      fsm_read_control              =1        ;
      fsm_write_control             =1        ;
      busy                          =1        ;
      output_shuffle                =0                   ;

    end // endcase STORE_HW

    //newcase STORE_WORD_A
    STORE_WORD_A: begin
      output_valid                  =0                   ;
      direct_or_delayed_din         =`DELAYED_TOP16      ; // 2 signals
      write_ready                   =0                   ;
      old_or_new_byte_remainder     =1                   ; // old =0, new =1 (where new is that which was not in the memory before)
      modified_or_original_address  =0                   ; // 1= original, 0 = modified
      added_or_delayed_address      =1                   ; // 1 = added, 0 = delayed
      first_two_bytes_out_select    ={`DC,`DC}           ; // 2 signals
      third_byte_out_select         ={`DC,`DC}           ; // 2 signals

      mem_read_enable               =0        ;
      mem_write_enable              =1        ;
      mem_enable                    =1        ;
      fsm_read_control              =1        ;
      fsm_write_control             =1        ;
      busy                          =1        ;
      output_shuffle                =0                   ;

    end // endcase STORE_WORD_A

    //newcase STORE_WORD_B
    STORE_WORD_B: begin
      output_valid                  =0                   ;
      direct_or_delayed_din         ={`DC,`DC}           ; // 2 signals
      write_ready                   =1                   ;
      old_or_new_byte_remainder     =`DC                 ; // old =0, new =1 (where new is that which was not in the memory before)
      modified_or_original_address  =`DC                 ; // 1= original, 0 = modified
      added_or_delayed_address      =`DC                 ; // 1 = added, 0 = delayed
      first_two_bytes_out_select    ={`DC,`DC}           ; // 2 signals
      third_byte_out_select         ={`DC,`DC}           ; // 2 signals

      mem_read_enable               =0        ;
      mem_write_enable              =0        ;
      mem_enable                    =1        ;
      fsm_read_control              =1        ;
      fsm_write_control             =1        ;
      busy                          =1        ;
      output_shuffle                =0                   ;

    end // endcase STORE_WORD_B

    //newcase STORE_BYTE_A
    STORE_BYTE_A: begin
      output_valid                  =0                   ;
      direct_or_delayed_din         =`DELAYED_LOW16      ; // 2 signals
      write_ready                   =0                   ;
      old_or_new_byte_remainder     =0                   ; // old =0, new =1 (where new is that which was not in the memory before)
      modified_or_original_address  =0                   ; // 1= original, 0 = modified
      added_or_delayed_address      =0                   ; // 1 = added, 0 = delayed
      first_two_bytes_out_select    ={`DC,`DC}           ; // 2 signals
      third_byte_out_select         ={`DC,`DC}           ; // 2 signals

      mem_read_enable               =0        ;
      mem_write_enable              =1        ;
      mem_enable                    =1        ;
      fsm_read_control              =1        ;
      fsm_write_control             =1        ;
      busy                          =1        ;
      output_shuffle                =0                   ;

    end //endcase STORE_BYTE_A

    //newcase STORE_BYTE_B
    STORE_BYTE_B: begin
      output_valid                  =0                   ;
      direct_or_delayed_din         ={`DC,`DC}           ; // 2 signals
      write_ready                   =1                   ;
      old_or_new_byte_remainder     =`DC                 ; // old =0, new =1 (where new is that which was not in the memory before)
      modified_or_original_address  =`DC                 ; // 1= original, 0 = modified
      added_or_delayed_address      =`DC                 ; // 1 = added, 0 = delayed
      first_two_bytes_out_select    ={`DC,`DC}           ; // 2 signals
      third_byte_out_select         ={`DC,`DC}           ; // 2 signals

      mem_read_enable               =0        ;
      mem_write_enable              =0        ;
      mem_enable                    =1        ;
      fsm_read_control              =1        ;
      fsm_write_control             =1        ;
      busy                          =1        ;
      output_shuffle                =0                   ;

    end //endcase STORE_BYTE_B

	default: begin
	  output_valid                  =1'bx                ;
      direct_or_delayed_din         =2'bx          		 ;
      write_ready                   =1'bx                ;
      old_or_new_byte_remainder     =1'bx                ;
      modified_or_original_address  =1'bx                ;
      added_or_delayed_address      =1'bx                ;
      first_two_bytes_out_select    =2'bx          		 ;
      third_byte_out_select         =2'bx       	     ;

      mem_read_enable               =1'bx        ;
      mem_write_enable              =1'bx        ;
      mem_enable                    =1'bx        ;
      fsm_read_control              =1'bx        ;
      fsm_write_control             =1'bx        ;
      busy                          =1'bx        ;
      output_shuffle                =0                   ;
	end
   endcase//state
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
