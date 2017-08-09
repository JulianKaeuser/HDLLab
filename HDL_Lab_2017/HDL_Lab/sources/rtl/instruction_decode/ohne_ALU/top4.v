module top4 (
clock,
reset,
instruction,

stall_from_instructionfetch, 
stall_from_memorycontroller,


load_store_width,
memorycontroller_sign_extend,

memory_load_request,
memory_store_request,

stack_push_request,
stack_pop_request,

stall_to_instructionfetch,

decoder_pc_update,

// ***********************************

MEMCTRL_IN_address,
RF_MEMCTRL_data_reg,

MEMCTRL_RF_data_in,

RF_pc_out,
RF_sp_out



);


input wire clock;
input wire reset;
input wire [15:0] instruction;




input wire stall_from_instructionfetch; 
input wire stall_from_memorycontroller;



output wire  [1:0] load_store_width;
output wire memorycontroller_sign_extend;

output wire memory_load_request;
output wire memory_store_request;

output wire stack_push_request;
output wire stack_pop_request;

output wire stall_to_instructionfetch;

output wire decoder_pc_update;

// *************************************

output wire [31:0] MEMCTRL_IN_address;
output wire [31:0] RF_MEMCTRL_data_reg;

output wire [31:0] MEMCTRL_RF_data_in;

output wire [31:0] RF_pc_out;
output wire [31:0] RF_sp_out;


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

// DECODER --> MISC_OUT

wire        DEC_MISC_OUT_memory_address_source_is_reg;




// ***************************************************************

// CPSR --> DECODER

wire        CPSR_DEC_flag_n;
wire        CPSR_DEC_flag_c;
wire        CPSR_DEC_flag_z;
wire        CPSR_DEC_flag_v;

// ***************************************************************

// REGISTERFILE --> ALU

wire [31:0] RF_ALU_operand_a;
wire [31:0] RF_ALU_operand_b;

// REGISTERFILE --> MEMORY_CONTROLLER

//wire [31:0] RF_MEMCTRL_data_reg;
wire [31:0] RF_MEMCTRL_address_reg;

// ***************************************************************

// ALU --> MISC_OUT

wire [31:0] ALU_MISC_OUT_result;

// ***************************************************************

// MEMORY_CONTROLLER --> REGISTERFILE 

//wire [31:0] MEMCTRL_RF_data_in;



// ########################################################################################################
// ############################################## module instantiations ###################################
// ########################################################################################################


irdecode  #(	
) irdecode_inst1 (

	.clock                                   (    clock                                      ),
	.reset                                   (    reset                                      ),
	.instruction                             (    instruction                                ),
                                                                                          
    .flag_n                                  (   CPSR_DEC_flag_n                             ),
    .flag_z                                  (   CPSR_DEC_flag_z                             ),
    .flag_c                                  (   CPSR_DEC_flag_c                             ),
    .flag_v                                  (   CPSR_DEC_flag_v                             ),
                                                                              
	.stall_from_instructionfetch             (   stall_from_instructionfetch                 ),
	.stall_from_memorycontroller             (   stall_from_memorycontroller                 ),
	
	
                                                                            
	.operand_a                               (  DEC_RF_operand_a                             ),
	.operand_b                               (  DEC_RF_operand_b                             ),
                                                                                           
	.offset_a                                (  DEC_RF_offset_a                              ),
	.offset_b                                (  DEC_RF_offset_b                              ),
                                                                                             
	.alu_opcode                              (  DEC_ALU_alu_opcode                           ),
                                                                                            
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
	.load_store_width                        (  load_store_width                             ),
	.memorycontroller_sign_extend            (  memorycontroller_sign_extend                 ),
                                                                                            
	.memory_load_request                     (  memory_load_request                          ),
	.memory_store_request                    (  memory_store_request                         ),
                                                                                             
	.stack_push_request                      (  stack_push_request                           ),
	.stack_pop_request                       (  stack_pop_request                            ),
                                                                                             
	.stall_to_instructionfetch               (  stall_to_instructionfetch                    ),
                                                                                            
	.decoder_pc_update                       (  decoder_pc_update                            ) // unnötig

	);
	
	
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
	
	
	
register_file # (	
) register_file_inst1 (
                                                                                                
    .readA_sel                               (  DEC_RF_operand_a                                ),
    .readB_sel                               (  DEC_RF_operand_b                                ),
    .readC_sel                               (  DEC_RF_memory_store_data_reg                    ),
    .readD_sel                               (  DEC_RF_memory_store_address_reg                 ),
    .write1_sel                              (  DEC_RF_alu_write_to_reg                         ),
    .write2_sel                              (  DEC_RF_memory_write_to_reg                      ),
    .write1_en                               (  DEC_RF_alu_write_to_reg_enable                  ),
    .write2_en                               (  DEC_RF_memory_write_to_reg_enable               ),
    .write1_in                               (  ALU_MISC_OUT_result                             ),
    .write2_in                               (  MEMCTRL_RF_data_in                              ),
    .immediate1_in                           (  DEC_RF_offset_a                                 ),
    .immediate2_in                           (  DEC_RF_offset_b                                 ),
    .next_pc_in                              (  32'h00000000                                    ),
    .next_cpsr_in                            (  {new_n, new_c, new_z, new_v}                    ),
    .next_sp_in                              (  32'h00000000                                    ),
    .next_pc_en                              (  1'b0                                            ),
    .clk                                     (  clock                                           ),
                                                                                                
    .regA_out                                (  RF_ALU_operand_a                                ),
    .regB_out                                (  RF_ALU_operand_b                                ),
    .regC_out                                (  RF_MEMCTRL_data_reg                             ),
    .regD_out                                (  RF_MEMCTRL_address_reg                          ),
    .pc_out                                  (  RF_pc_out                                       ),
    .cpsr_out                                (  {RF_OUT_n, RF_OUT_c, RF_OUT_z, RF_OUT_v}        ),
    .sp_out                                  (  RF_sp_out                                       )
    
    );
    
    wire ALU_IN_c;
    
    assign ALU_IN_c =  DEC_ALU_alu_opcode[4] ? 1'b0 : RF_OUT_c;


ALU_VARIABLE  # (
) ALU_VARIABLE_inst1 (
    
    .a          ( RF_ALU_operand_a                ),
    .b          ( RF_ALU_operand_b                ),
    .op         ( DEC_ALU_alu_opcode[3:0]         ),
    .c_in       ( ALU_IN_c                        ),
    .c_out      ( ALU_OUT_c                       ),
    .z          ( ALU_OUT_z                       ),
    .n          ( ALU_OUT_n                       ),
    .v          ( ALU_OUT_v                       ),
    .result     ( ALU_MISC_OUT_result             )
                                                 

);


    // wire [31:0] MEMCTRL_IN_address;
    
    assign MEMCTRL_IN_address = DEC_MISC_OUT_memory_address_source_is_reg ? RF_MEMCTRL_address_reg : ALU_MISC_OUT_result;
    
	
	
endmodule
	
