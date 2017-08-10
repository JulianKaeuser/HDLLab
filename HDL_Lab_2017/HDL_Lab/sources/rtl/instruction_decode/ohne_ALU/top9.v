module top9 (
clock,
reset,


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

wire  [4:0] DEC_RF_alu_write_to_reg;
wire        DEC_RF_alu_write_to_reg_enable; 
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

// DECODER --> INSTRUCTIONFETCH

wire        DEC_IF_stall_to_instructionfetch;

// DECODER --> MISC_OUT

wire        DEC_MISC_OUT_memory_address_source_is_reg;
wire        DEC_MISC_OUT_pc_mask_bit;


// ***************************************************************

// REGISTERFILE --> ALU

wire [31:0] RF_ALU_operand_a;
wire [31:0] RF_ALU_operand_b;

// REGISTERFILE --> MEMORY_CONTROLLER

wire [31:0] RF_MEMCTRL_data_reg;
wire [31:0] RF_MEMCTRL_address_reg;

// REGISTERFILE --> REGISTERFILE

wire [31:0] RF_next_sp;

// REGISTERFILE --> INSTRUCTIONFETCH

wire [31:0] RF_pc_out;

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

// INSTRUCTIONFETCH --> REGISTERFILE

wire [31:0] IF_RF_incremented_pc_out;
wire        IF_RF_incremented_pc_write_enable;

// INSTRUCTIONFETCH --> DECODER

wire [15:0] IF_DEC_instruction;
wire        IF_DEC_instruction_valid;

// **************************************************************

//  CONTROLLER --> INSTRUCTIONFETCH

wire        CTRL_IF_stall_from_mem;

//  CONTROLLER --> DECODER

wire        CTRL_DEC_stall_from_ctrl;


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

	.clock                                   (  clock                                        ),
	.reset                                   (  reset                                        ),
	.instruction                             (  IF_DEC_instruction                           ),
                                                                                             
    .flag_n                                  (  RF_OUT_n                                     ),
    .flag_z                                  (  RF_OUT_z                                     ),
    .flag_c                                  (  RF_OUT_c                                     ),
    .flag_v                                  (  RF_OUT_v                                     ),
                                                                              
	.instruction_valid                       (  IF_DEC_instruction_valid                     ),
	
	.memory_write_finished                   (  MEMCTRL_write_finished                       ),
    .memory_read_finished                    (  MEMCTRL_read_finished                        ),
                                                                            
	.operand_a                               (  DEC_RF_operand_a                             ),
	.operand_b                               (  DEC_RF_operand_b                             ),
                                                                                           
	.offset_a                                (  DEC_RF_offset_a                              ),
	.offset_b                                (  DEC_RF_offset_b                              ),
                                                                                             
	.alu_opcode                              (  DEC_ALU_alu_opcode                           ),
	.pc_mask_bit                             (  DEC_MISC_OUT_pc_mask_bit                     ),
                                                                                            
	.update_flag_n                           (  DEC_CPSR_update_flag_n                       ),
    .update_flag_z                           (  DEC_CPSR_update_flag_z                       ),
    .update_flag_c                           (  DEC_CPSR_update_flag_c                       ),
	.update_flag_v                           (  DEC_CPSR_update_flag_v                       ),
                                                                                           
	.alu_write_to_reg                        (  DEC_RF_alu_write_to_reg                      ),
	.alu_write_to_reg_enable                 (  DEC_RF_alu_write_to_reg_enable               ),
	.memory_write_to_reg                     (  DEC_RF_memory_write_to_reg                   ),
	.memory_write_to_reg_enable              (  DEC_RF_memory_write_to_reg_enable            ),
                                                                                             
	.memory_store_data_reg                   (  DEC_RF_memory_store_data_reg                 ),
	.memory_store_address_reg                (  DEC_RF_memory_store_address_reg              ),
	.memory_address_source_is_reg            (  DEC_MISC_OUT_memory_address_source_is_reg    ),
	.load_store_width                        (  DEC_MEMCTRL_load_store_width                 ),
	.memorycontroller_sign_extend            (  DEC_MEMCTRL_memorycontroller_sign_extend     ),
                                                                                            
	.memory_load_request                     (  DEC_MEMCTRL_memory_load_request              ),
	.memory_store_request                    (  DEC_MEMCTRL_memory_store_request             ),
                                                                                             
	.stall_to_instructionfetch               (  DEC_IF_stall_to_instructionfetch             )

	);
	
	
register_file_v2 # (	
) register_file_v2_inst1 (
                                                                                                
    .readA_sel                               (  DEC_RF_operand_a                                ),
    .readB_sel                               (  DEC_RF_operand_b                                ),
    .readC_sel                               (  DEC_RF_memory_store_data_reg                    ),
    .readD_sel                               (  DEC_RF_memory_store_address_reg                 ),
    .write1_sel                              (  DEC_RF_alu_write_to_reg                         ),
    .write2_sel                              (  DEC_RF_memory_write_to_reg                      ),
    .write1_en                               (  DEC_RF_alu_write_to_reg_enable                  ),
    .write2_en                               (  DEC_RF_memory_write_to_reg_enable               ),
    .write1_in                               (  ALU_MISC_OUT_result                             ),
    .write2_in                               (  MEMCTRL_RF_IF_data_in                           ),
    .immediate1_in                           (  DEC_RF_offset_a                                 ),
    .immediate2_in                           (  DEC_RF_offset_b                                 ),
    .next_pc_in                              (  IF_RF_incremented_pc_out                        ),
    .next_cpsr_in                            (  {new_n, new_c, new_z, new_v}                    ),
    .next_sp_in                              (  RF_next_sp                                      ),
    .next_pc_en                              (  IF_RF_incremented_pc_write_enable               ),
    .clk                                     (  clock                                           ),
    .reset                                   (  reset                                           ),                                                                                            
    .regA_out                                (  RF_ALU_operand_a                                ),
    .regB_out                                (  RF_ALU_operand_b                                ),
    .regC_out                                (  RF_MEMCTRL_data_reg                             ),
    .regD_out                                (  RF_MEMCTRL_address_reg                          ),
    .pc_out                                  (  RF_pc_out                                       ),
    .cpsr_out                                (  {RF_OUT_n, RF_OUT_c, RF_OUT_z, RF_OUT_v}        ),
    .sp_out                                  (  RF_next_sp                                      )
    
    );
    
    wire ALU_IN_c;
    wire carry_none;
    
    assign ALU_IN_c =  DEC_ALU_alu_opcode[4] ? carry_none : RF_OUT_c;
    assign carry_none = (DEC_ALU_alu_opcode[3:0] == 4'b0110)? 1'b1 : 1'b0;
    
    // set lowest 2 bits to zero if PC 
    
    wire [31:0] RF_ALU_operand_a_pc_modified;
    assign RF_ALU_operand_a_pc_modified = (DEC_MISC_OUT_pc_mask_bit) ? {RF_ALU_operand_a[31:2], 1'b0, RF_ALU_operand_a[0]} : RF_ALU_operand_a;


ALU_VARIABLE  # (
) ALU_VARIABLE_inst1 (
    
    .a          ( RF_ALU_operand_a_pc_modified    ),
    .b          ( RF_ALU_operand_b                ),
    .op         ( DEC_ALU_alu_opcode[3:0]         ),
    .c_in       ( ALU_IN_c                        ),
    .c_out      ( ALU_OUT_c                       ),
    .z          ( ALU_OUT_z                       ),
    .n          ( ALU_OUT_n                       ),
    .v          ( ALU_OUT_v                       ),
    .result     ( ALU_MISC_OUT_result             )
                                                 

);

    wire IF_memory_load_req;    
    wire [1:0] MEMCTRL_IN_load_store_width;
    
    assign MEMCTRL_IN_load_store_width = IF_memory_load_req ? 2'b01 : DEC_MEMCTRL_load_store_width; // set width to halfword for instruction fetch memory access
    
    

    wire [12:0] MEMCTRL_IN_address;
    wire [12:0] IF_instruction_memory_address;
    wire [12:0] DEC_memory_address;
    
    assign MEMCTRL_IN_address = IF_memory_load_req ? IF_instruction_memory_address : DEC_memory_address[12:0];
    assign DEC_memory_address = DEC_MISC_OUT_memory_address_source_is_reg ? RF_MEMCTRL_address_reg[12:0] : ALU_MISC_OUT_result[12:0];
    
    
    wire MEMCTRL_load_in;

    assign MEMCTRL_load_in = IF_memory_load_req ? IF_memory_load_req : DEC_MEMCTRL_memory_load_request;
    
    
    
memory_interface # (
) memory_interface_inst1 (

  .address                   ( {MEMCTRL_IN_address[12:1]      }                 ), // hier ändern für neues memory_if
  .data_in                   ( RF_MEMCTRL_data_reg                              ),
  .load                      ( MEMCTRL_load_in                                  ),
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


Instruction_Fetch_v2 # (
) Instruction_Fetch_v2_inst1 ( 
                                                                               
    .clk                              ( clock                                          ),
    .reset                            ( reset                                          ),
    .stall_decoder_in                 ( DEC_IF_stall_to_instructionfetch               ),
    .memory_output_valid              ( MEMCTRL_read_finished                          ),
    .current_pc_in                    ( RF_pc_out                                      ),
    .instruction_in                   ( MEMCTRL_RF_IF_data_in [15:0]                   ),
    .memory_load_request              ( IF_memory_load_req                             ),
    .incremented_pc_write_enable      ( IF_RF_incremented_pc_write_enable              ),
    .memory_address                   ( IF_instruction_memory_address                  ),
    .incremented_pc_out               ( IF_RF_incremented_pc_out                       ),
    .instruction_out                  ( IF_DEC_instruction                             ),
    .instruction_valid                ( IF_DEC_instruction_valid                       )

);
   
	
	
endmodule
	
