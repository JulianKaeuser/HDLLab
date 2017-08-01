// AUTHORS Group 06 / Julian Käuser
// Tuesday 08/01/2017

// some states
`define IDLE 4'b000
`define LOAD_INIT 4'b0001
`define LOAD_T2 4'b0010
`define LOAD_WRITEOUT 4'b0011
`define WRITE_INIT 4'b1000
`define WRITE_ 4'b0001


module memory_control_fsm(
  .is_signed,
  word_type,
  output_valid,
  write_ready,
  en,
  rw,
  direct_or_delayed_din,
  old_or_new_byte_remainder,
  modified_or_original_address,
  added_or_delayed_address,
  first_two_bytes_out_select,
  third_byte_out_select
  );

  endmodule
