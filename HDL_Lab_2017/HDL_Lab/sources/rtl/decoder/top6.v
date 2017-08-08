module top6 (
clock,
reset,
instruction,
stall_from_instructionfetch,
stall_to_instructionfetch,
decoder_pc_update,
RF_pc_out,

// ***********************************

MEM_MEMCTRL_from_mem_data        ,

MEMCTRL_MEM_to_mem_read_enable   ,
MEMCTRL_MEM_to_mem_write_enable  ,
MEMCTRL_MEM_to_mem_mem_enable    ,
MEMCTRL_MEM_to_mem_address       ,
MEMCTRL_MEM_to_mem_data



);


input wire clock;
input wire reset;
input wire [15:0] instruction;

input wire stall_from_instructionfetch;

output wire stall_to_instructionfetch;

output wire decoder_pc_update;

output wire [31:0] RF_pc_out;




// ************************************** interface to memory *********************************************
input wire  [15:0] MEM_MEMCTRL_from_mem_data;

output wire        MEMCTRL_MEM_to_mem_read_enable   ;
output wire        MEMCTRL_MEM_to_mem_write_enable  ;
output wire        MEMCTRL_MEM_to_mem_mem_enable    ;
output wire [11:0] MEMCTRL_MEM_to_mem_address       ;
output wire [15:0] MEMCTRL_MEM_to_mem_data          ;


// ########################################################################################################
// ############################################### internal ###############################################
// ########################################################################################################

// DECODER --> REGISTERFILE


wire  [4:0] DEC_RF_operand_a;
wire  [4:0] DEC_RF_operand_b;

wire [31:0] DEC_RF_offset_a;
wire [31:0] DEC_RF_offset_b;

wire  [4:0] DEC_RF_alu_stack_write_to_reg;
wire        DEC_RF_alu_stack_write_to_reg_enable;
wire  [4:0] DEC_RF_memory_write_to_reg;
wire        DEC_RF_memory_write_to_reg_enable;

wire  [4:0] DEC_RF_memory_store_data_reg;
wire  [4:0] DEC_RF_memory_store_address_reg;

// DECODER --> CPSR_REGISTER

wire        DEC_CPSR_update_flag_n;
wire        DEC_CPSR_update_flag_z;
wire        DEC_CPSR_update_flag_c;
wire        DEC_CPSR_update_flag_v;

// DECODER --> ALU

wire  [4:0] DEC_ALU_alu_opcode;

// DECODER --> MEMORY_CONTROLLER

wire        DEC_MEMCTRL_memory_load_request;
wire        DEC_MEMCTRL_memory_store_request;
wire  [1:0] DEC_MEMCTRL_load_store_width;
wire        DEC_MEMCTRL_memorycontroller_sign_extend;

// DECODER --> STACK

wire        DEC_STACK_push_request;
wire        DEC_STACK_pop_request;

// DECODER --> MISC_OUT

wire        DEC_MISC_OUT_memory_address_source_is_reg;


// ***************************************************************

// REGISTERFILE --> ALU

wire [31:0] RF_ALU_STACK_operand_a;
wire [31:0] RF_ALU_operand_b;

// REGISTERFILE --> MEMORY_CONTROLLER

wire [31:0] RF_MEMCTRL_data_reg;
wire [31:0] RF_MEMCTRL_address_reg;

// REGISTERFILE --> STACK

wire [31:0] RF_STACK_sp_out;

// ***************************************************************

// ALU --> MISC_OUT

wire [31:0] ALU_MISC_OUT_result;

// ***************************************************************

// MEMORY_CONTROLLER --> REGISTERFILE, INSTRUCTIONFETCH

wire [31:0] MEMCTRL_RF_IF_data_in;

// MEMORY_CONTROLLER --> MISC_OUT

wire        MEMCTRL_busy;
wire        MEMCTRL_write_finished;
wire        MEMCTRL_read_finished;


// **************************************************************

// STACK --> REGISTERFILE

wire [31:0] STACK_RF_next_sp;

// STACK --> MISC_OUT

wire [31:0] STACK_MISC_OUT_data_out;


// ########################################################################################################
// ############################################## module instantiations ###################################
// ########################################################################################################

	wire new_n;
	wire new_c;
	wire new_z;
	wire new_v;

	wire ALU_OUT_n;
	wire ALU_OUT_c;
	wire ALU_OUT_z;
	wire ALU_OUT_v;

    wire RF_OUT_n;
	wire RF_OUT_c;
	wire RF_OUT_z;
	wire RF_OUT_v;

    assign new_n = (DEC_CPSR_update_flag_n == 1)? ALU_OUT_n : RF_OUT_n;
	assign new_c = (DEC_CPSR_update_flag_c == 1)? ALU_OUT_c : RF_OUT_c;
	assign new_z = (DEC_CPSR_update_flag_z == 1)? ALU_OUT_z : RF_OUT_z;
	assign new_v = (DEC_CPSR_update_flag_v == 1)? ALU_OUT_v : RF_OUT_v;


irdecode  #(
) irdecode_inst1 (

	.clock                                   (    clock                                      ),
	.reset                                   (    reset                                      ),
	.instruction                             (    instruction                                ),

    .flag_n                                  (   RF_OUT_n                                    ),
    .flag_z                                  (   RF_OUT_z                                    ),
    .flag_c                                  (   RF_OUT_c                                    ),
    .flag_v                                  (   RF_OUT_v                                    ),

	.stall_from_instructionfetch             (   stall_from_instructionfetch                 ),
	.stall_from_controller                   (   1'b0                                        ),

	.memory_write_finished                   (  MEMCTRL_write_finished                       ),
    .memory_read_finished                    (  MEMCTRL_read_finished                        ),



	.operand_a                               (  DEC_RF_operand_a                             ),
	.operand_b                               (  DEC_RF_operand_b                             ),

	.offset_a                                (  DEC_RF_offset_a                              ),
	.offset_b                                (  DEC_RF_offset_b                              ),

	.alu_opcode                              (  DEC_ALU_alu_opcode                           ),

	.update_flag_n                           (  DEC_CPSR_update_flag_n                       ),
    .update_flag_z                           (  DEC_CPSR_update_flag_z                       ),
    .update_flag_c                           (  DEC_CPSR_update_flag_c                       ),
	.update_flag_v                           (  DEC_CPSR_update_flag_v                       ),

	.alu_stack_write_to_reg                  (  DEC_RF_alu_stack_write_to_reg                ),
	.alu_stack_write_to_reg_enable           (  DEC_RF_alu_stack_write_to_reg_enable         ),
	.memory_write_to_reg                     (  DEC_RF_memory_write_to_reg                   ),
	.memory_write_to_reg_enable              (  DEC_RF_memory_write_to_reg_enable            ),

	.memory_store_data_reg                   (  DEC_RF_memory_store_data_reg                 ),
	.memory_store_address_reg                (  DEC_RF_memory_store_address_reg              ),
	.memory_address_source_is_reg            (  DEC_MISC_OUT_memory_address_source_is_reg    ),
	.load_store_width                        (  DEC_MEMCTRL_load_store_width                 ),
	.memorycontroller_sign_extend            (  DEC_MEMCTRL_memorycontroller_sign_extend     ),

	.memory_load_request                     (  DEC_MEMCTRL_memory_load_request              ),
	.memory_store_request                    (  DEC_MEMCTRL_memory_store_request             ),

	.stack_push_request                      (  DEC_STACK_push_request                       ),
	.stack_pop_request                       (  DEC_STACK_pop_request                        ),

	.stall_to_instructionfetch               (  stall_to_instructionfetch                    ),

	.decoder_pc_update                       (  decoder_pc_update                            )

	);


	wire [31:0] ALU_STACK_RF_data_in;
	assign ALU_STACK_RF_data_in = DEC_STACK_pop_request ? STACK_MISC_OUT_data_out : ALU_MISC_OUT_result;


register_file # (
) register_file_inst1 (

    .readA_sel                               (  DEC_RF_operand_a                                ),
    .readB_sel                               (  DEC_RF_operand_b                                ),
    .readC_sel                               (  DEC_RF_memory_store_data_reg                    ),
    .readD_sel                               (  DEC_RF_memory_store_address_reg                 ),
    .write1_sel                              (  DEC_RF_alu_stack_write_to_reg                   ),
    .write2_sel                              (  DEC_RF_memory_write_to_reg                      ),
    .write1_en                               (  DEC_RF_alu_stack_write_to_reg_enable            ),
    .write2_en                               (  DEC_RF_memory_write_to_reg_enable               ),
    .write1_in                               (  ALU_STACK_RF_data_in                            ),
    .write2_in                               (  MEMCTRL_RF_IF_data_in                           ),
    .immediate1_in                           (  DEC_RF_offset_a                                 ),
    .immediate2_in                           (  DEC_RF_offset_b                                 ),
    .next_pc_in                              (  32'h00000000                                    ),
    .next_cpsr_in                            (  {new_n, new_c, new_z, new_v}                    ),
    .next_sp_in                              (  STACK_RF_next_sp                                ),
    .next_pc_en                              (  1'b0                                            ),
    .clk                                     (  clock                                           ),

    .regA_out                                (  RF_ALU_STACK_operand_a                          ),
    .regB_out                                (  RF_ALU_operand_b                                ),
    .regC_out                                (  RF_MEMCTRL_data_reg                             ),
    .regD_out                                (  RF_MEMCTRL_address_reg                          ),
    .pc_out                                  (  RF_pc_out                                       ),
    .cpsr_out                                (  {RF_OUT_n, RF_OUT_c, RF_OUT_z, RF_OUT_v}        ),
    .sp_out                                  (  RF_STACK_sp_out                                 )

    );

    wire ALU_IN_c;
    wire carry_none;

    assign ALU_IN_c =  DEC_ALU_alu_opcode[4] ? carry_none : RF_OUT_c;
    assign carry_none = (DEC_ALU_alu_opcode[3:0] == 4'b0110)? 1'b1 : 1'b0;


ALU_VARIABLE  # (
) ALU_VARIABLE_inst1 (

    .a          ( RF_ALU_STACK_operand_a                ),
    .b          ( RF_ALU_operand_b                ),
    .op         ( DEC_ALU_alu_opcode[3:0]         ),
    .c_in       ( ALU_IN_c                        ),
    .c_out      ( ALU_OUT_c                       ),
    .z          ( ALU_OUT_z                       ),
    .n          ( ALU_OUT_n                       ),
    .v          ( ALU_OUT_v                       ),
    .result     ( ALU_MISC_OUT_result             )


);


    wire [31:0] MEMCTRL_IN_address;

    assign MEMCTRL_IN_address = DEC_MISC_OUT_memory_address_source_is_reg ? RF_MEMCTRL_address_reg : ALU_MISC_OUT_result;


memory_interface # (
) memory_interface_inst1 (

  .address                   ( MEMCTRL_IN_address [11:0]                        ),
  .data_in                   ( RF_MEMCTRL_data_reg                              ),
  .load                      ( DEC_MEMCTRL_memory_load_request                  ),
  .store                     ( DEC_MEMCTRL_memory_store_request                 ),
  .clk                       ( clock                                            ),
  .reset                     ( reset                                            ),
  .is_signed                 ( DEC_MEMCTRL_memorycontroller_sign_extend         ),
  .word_type                 ( DEC_MEMCTRL_load_store_width                     ),

  .from_mem_data             ( MEM_MEMCTRL_from_mem_data                        ),
  .to_mem_read_enable        ( MEMCTRL_MEM_to_mem_read_enable                   ),
  .to_mem_write_enable       ( MEMCTRL_MEM_to_mem_write_enable                  ),
  .to_mem_mem_enable         ( MEMCTRL_MEM_to_mem_mem_enable                    ),
  .to_mem_address            ( MEMCTRL_MEM_to_mem_address                       ),
  .to_mem_data               ( MEMCTRL_MEM_to_mem_data                          ),

  .data_out                  ( MEMCTRL_RF_IF_data_in                            ),
  .write_ready               ( MEMCTRL_write_finished                           ),
  .output_valid              ( MEMCTRL_read_finished                            ),
  .busy                      ( MEMCTRL_busy                                     )

  );



STACK # (
) STACK_inst1 (

    .clk                     ( clock                                            ),
    .reset                   ( reset                                            ),
    .push_enable             ( DEC_STACK_push_request                           ),
    .pop_enable              ( DEC_STACK_pop_request                            ),
    .data_in                 ( RF_ALU_STACK_operand_a                           ),
    .sp_in                   ( RF_STACK_sp_out                                  ),

    .data_out                ( STACK_MISC_OUT_data_out                          ),
    .sp_out                  ( STACK_RF_next_sp                                 )


);





endmodule
