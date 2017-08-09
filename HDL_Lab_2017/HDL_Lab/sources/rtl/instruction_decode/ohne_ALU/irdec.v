
`default_nettype none

`include "irdefines.v"

module irdecode	(
clock,
reset,
instruction,

instruction_valid,

flag_n,
flag_z,
flag_c,
flag_v,

memory_write_finished,
memory_read_finished,

stall_from_instructionfetch, 
//stall_from_controller,



operand_a,          
operand_b,

offset_a,
offset_b,

alu_opcode,

pc_mask_bit,

update_flag_n,
update_flag_z,
update_flag_c,
update_flag_v,

alu_stack_write_to_reg,
alu_stack_write_to_reg_enable, 
memory_write_to_reg,
memory_write_to_reg_enable,

memory_store_data_reg,
memory_store_address_reg,
memory_address_source_is_reg,
load_store_width,
memorycontroller_sign_extend,

memory_load_request,
memory_store_request,

stack_push_request,
stack_pop_request,

stall_to_instructionfetch,

decoder_pc_update



);

`include "f_flageval.v"

input wire clock;
input wire reset;
input wire [15:0] instruction;

input wire instruction_valid;

input wire flag_n;
input wire flag_z;
input wire flag_c;
input wire flag_v;

input wire stall_from_instructionfetch; 
//input wire stall_from_controller;

input wire memory_write_finished;
input wire memory_read_finished;



output reg  [4:0] operand_a;           // f체r 8-fach Registerfile Bit 3 ignorieren: {operand_a[4], operand_a[3:0]}
output reg  [4:0] operand_b;

output reg [31:0] offset_a;
output reg [31:0] offset_b;

output reg  [4:0] alu_opcode;

output reg        pc_mask_bit;

output reg update_flag_n;
output reg update_flag_z;
output reg update_flag_c;
output reg update_flag_v;

output reg  [4:0] alu_stack_write_to_reg;
output reg alu_stack_write_to_reg_enable; 
output reg  [4:0] memory_write_to_reg;
output reg memory_write_to_reg_enable;

output reg  [4:0] memory_store_data_reg;
output reg  [4:0] memory_store_address_reg;
output reg memory_address_source_is_reg;
output reg  [1:0] load_store_width;
output reg memorycontroller_sign_extend;

output reg memory_load_request;
output reg memory_store_request;

output reg stack_push_request;
output reg stack_pop_request;

output reg stall_to_instructionfetch;

output reg decoder_pc_update; 

reg [7:0] itstate;

reg [8:0] step;






reg  [4:0] next_operand_a;           // f체r 8-fach Registerfile Bit 3 ignorieren: {next_operand_a[4], next_operand_a[3:0]}
reg  [4:0] next_operand_b;

reg [31:0] next_offset_a;
reg [31:0] next_offset_b;

reg  [4:0] next_alu_opcode;

reg        next_pc_mask_bit;

reg next_update_flag_n;
reg next_update_flag_z;
reg next_update_flag_c;
reg next_update_flag_v;

reg  [4:0] next_alu_stack_write_to_reg;
reg next_alu_stack_write_to_reg_enable; 
reg  [4:0] next_memory_write_to_reg;
reg next_memory_write_to_reg_enable;

reg  [4:0] next_memory_store_data_reg;
reg  [4:0] next_memory_store_address_reg;
reg next_memory_address_source_is_reg;
reg  [1:0] next_load_store_width;
reg next_memorycontroller_sign_extend;

reg next_memory_load_request;
reg next_memory_store_request;

reg next_stack_push_request;
reg next_stack_pop_request;

reg next_stall_to_instructionfetch;

reg next_decoder_pc_update;

reg [8:0] next_step;                      // default all 1 !


reg [7:0] next_itstate;

// synthesis translate off
reg exec_cond_true;
reg next_exec_cond_true;

wire instruction_format;
assign instruction_format = instruction;

// synthesis translate on
                             

always @(posedge clock) begin 

operand_a                           <=       next_operand_a;           
operand_b                           <=       next_operand_b;
                                    
offset_a                            <=       next_offset_a;
offset_b                            <=       next_offset_b;
                                   
alu_opcode                          <=       next_alu_opcode;

pc_mask_bit                         <=       next_pc_mask_bit;
                                   
update_flag_n                       <=       next_update_flag_n;
update_flag_z                       <=       next_update_flag_z;
update_flag_c                       <=       next_update_flag_c;
update_flag_v                       <=       next_update_flag_v;
                                    
alu_stack_write_to_reg              <=       next_alu_stack_write_to_reg;
alu_stack_write_to_reg_enable       <=       next_alu_stack_write_to_reg_enable; 
memory_write_to_reg                 <=       next_memory_write_to_reg;
memory_write_to_reg_enable          <=       next_memory_write_to_reg_enable;
                                    
memory_store_data_reg               <=       next_memory_store_data_reg;
memory_store_address_reg            <=       next_memory_store_address_reg;
memory_address_source_is_reg        <=       next_memory_address_source_is_reg;
load_store_width                    <=       next_load_store_width;
memorycontroller_sign_extend        <=       next_memorycontroller_sign_extend;
                                    
memory_load_request                 <=       next_memory_load_request;
memory_store_request                <=       next_memory_store_request;
                                    
stack_push_request                  <=       next_stack_push_request;
stack_pop_request                   <=       next_stack_pop_request;
                                    
stall_to_instructionfetch           <=       next_stall_to_instructionfetch;
                                    
decoder_pc_update                   <=       next_decoder_pc_update;


itstate                             <=       next_itstate;

step                                <=       next_step;

// synthesis translate off
exec_cond_true                      <=       next_exec_cond_true;
// synthesis translate on


end




always @(*) begin



next_decoder_pc_update = (   ((next_alu_stack_write_to_reg == `RF_R15_PC) & next_alu_stack_write_to_reg_enable) 
                             | ((next_memory_write_to_reg == `RF_R15_PC) & next_memory_write_to_reg_enable)
                             | (next_stack_pop_request & instruction[8])                              )
                             ? 1'b1
                             : 1'b0 ;
                             

                             
                             
if ( (next_stall_to_instructionfetch | instruction_valid)  & 
      !reset &
      !( ( next_memory_store_request & !memory_write_finished)  | (next_memory_load_request & !memory_read_finished) ) 
      //&!stall_from_controller
      ) begin
      
      casez(instruction) 
        `FORMAT_20 : begin
            casez (instruction[3:0])
                    4'b0000 : begin  // NOP
                        next_itstate = itstate;
                    end
                    default : begin
                        next_itstate = instruction[7:0];
                    end
                endcase
        
        end
        default: next_itstate = (itstate[3:0] == 4'b1000) ? 8'b0000_0000 : {itstate[7:5], (itstate[4:0] << 1)};
      endcase
end
else if (reset) begin
    next_itstate = 8'b0000_0000;
end
else begin
    next_itstate = itstate;
end
    
    
    
    
if (  (next_stall_to_instructionfetch | instruction_valid) & 
      !reset &
      !( ( next_memory_store_request & !memory_write_finished)  | (next_memory_load_request & !memory_read_finished) ) 
      //&!stall_from_controller
      ) begin // if-block no_stall or reset

	if ( (itstate == 8'b0000_0000) | f_flageval(itstate[7:4], flag_z, flag_c, flag_n, flag_v)) begin // if-block ITSTATE
	
	// synthesis translate off
        next_exec_cond_true = 1'b1;
    // synthesis translate on
	
	casez (instruction)
	
	        `FORMAT_1_2  : begin                                            
	            next_operand_a = {2'b00, instruction[5:3]};
	            
	            next_offset_a = `IMM_ZERO;
		    next_offset_b = 32'b0; // added for: no latch
	            
	            next_pc_mask_bit = 1'b0;
	                      
	            next_alu_stack_write_to_reg = {2'b00, instruction[2:0]};
	            next_alu_stack_write_to_reg_enable = 1'b1;
		    next_alu_opcode = `ORR; // added for: no latch
	            next_memory_write_to_reg = `RF_NONE;
	            next_memory_write_to_reg_enable = 1'b0;
	            
	            next_memory_store_data_reg = `RF_NONE;
	            next_memory_store_address_reg = `RF_NONE;
	            next_memory_address_source_is_reg = 1'b0;
	            next_load_store_width = `WORD;
	            next_memorycontroller_sign_extend = 1'b0;
	
	            next_memory_load_request = 1'b0;
	            next_memory_store_request = 1'b0;
	            
	            next_stack_push_request = 1'b0;
	            next_stack_pop_request = 1'b0;
	            
	            next_stall_to_instructionfetch       = 1;
	                                
	            next_step                            = 9'b1_1111_1111;
	            
	            casez (instruction[12:11])
	                `F1_LSL  : begin
	                    next_operand_b = `RF_IMM;
	                    next_offset_b = {27'b0000_0000_0000_0000_0000_0000_000, instruction[10:6]};
	                    next_alu_opcode = `LSL;
	                    
						next_update_flag_n = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    next_update_flag_z = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						next_update_flag_c = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						next_update_flag_v = 1'b0;
	                end
	                `F1_LSR  : begin
	                    next_operand_b = `RF_IMM;
	                    next_offset_b = {27'b0000_0000_0000_0000_0000_0000_000, instruction[10:6]};
	                    next_alu_opcode  = `LSR;
	                    
	                    next_update_flag_n = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    next_update_flag_z = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						next_update_flag_c = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						next_update_flag_v = 1'b0;
	                end
	                `F1_ASR  : begin
	                    next_operand_b = `RF_IMM;
	                    next_offset_b = {27'b0000_0000_0000_0000_0000_0000_000, instruction[10:6]};
	                    next_alu_opcode  = `ASR;
	                    
	                    next_update_flag_n = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    next_update_flag_z = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						next_update_flag_c = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						next_update_flag_v = 1'b0;
	                end
	                `FORMAT_2 :begin
	                
	                    casez (instruction[10]) 
	                        `F2_REG_OP : begin
	                            next_operand_b = {2'b00, instruction[8:6]};
	                            next_offset_b = `IMM_ZERO;
	                        end
	                        `F2_IMM_OP : begin
	                            next_operand_b = `RF_IMM;
	                            next_offset_b = {29'b0000_0000_0000_0000_0000_0000_0000_0, instruction[8:6]};
	                        end
	                    endcase
	                    
	                    casez (instruction[9]) 
	                        `F2_ADD : next_alu_opcode  = `ADD;
	                        `F2_SUB : next_alu_opcode  = `SUB;
	                    endcase
	                    
	                    next_update_flag_n = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    next_update_flag_z = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						next_update_flag_c = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						next_update_flag_v = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                end
	                
	            endcase
	        end
	        
	        `FORMAT_3  : begin
	            next_operand_a = �`RF_NONE; // added for: no latch
	            next_operand_b = `RF_IMM;
	            
	            next_offset_a = `IMM_ZERO;
	            next_offset_b = {24'b0000_0000_0000_0000_0000_0000, instruction[7:0]};

		    next_alu_opcode = `ORR; // added for: no latch
	            
	            next_pc_mask_bit = 1'b0;
	            
	            next_alu_stack_write_to_reg = 5'b0; // added for: no latch
	            next_memory_write_to_reg = `RF_NONE;
	            next_memory_write_to_reg_enable = 1'b0;
	            
	            next_memory_store_data_reg = `RF_NONE;
	            next_memory_store_address_reg = `RF_NONE;
	            next_memory_address_source_is_reg = 1'b0;
	            next_load_store_width = `WORD;
	            next_memorycontroller_sign_extend = 1'b0;
	
	            next_memory_load_request = 1'b0;
	            next_memory_store_request = 1'b0;
	             
	            next_stack_push_request = 1'b0;
	            next_stack_pop_request = 1'b0;
	            
	            next_stall_to_instructionfetch       = 1;
	                                
	            next_step                            = 9'b1_1111_1111;
	            
	            casez (instruction[12:11])
	                `F3_MOV  : begin
	                    next_operand_a = `RF_IMM; 
	                    next_alu_opcode  = `ORR;    // entspricht PASSB wegen next_offset_a = 0
	                    next_alu_stack_write_to_reg = {2'b00, instruction[10:8]};
	                    next_alu_stack_write_to_reg_enable = 1'b1;
	                    
	                    next_update_flag_n = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    next_update_flag_z = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						next_update_flag_c = 1'b0;
						next_update_flag_v = 1'b0;
	                end
	                `F3_CMP  : begin
	                    next_operand_a = {2'b00, instruction[10:8]};
	                    next_alu_opcode  = `CMP;
	                    next_alu_stack_write_to_reg = `RF_NONE;
	                    next_alu_stack_write_to_reg_enable = 1'b0; 
	                    
	                    next_update_flag_n = 1'b1;
	                    next_update_flag_z = 1'b1;
						next_update_flag_c = 1'b1;
						next_update_flag_v = 1'b1;
	                end
	                `F3_ADD  : begin
	                    next_operand_a = {2'b00, instruction[10:8]};
	                    next_alu_opcode  = `ADD;
	                    next_alu_stack_write_to_reg = {2'b00, instruction[10:8]};
	                    next_alu_stack_write_to_reg_enable = 1'b1;
	                    
	                    next_update_flag_n = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    next_update_flag_z = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						next_update_flag_c = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						next_update_flag_v = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                end
	                `F3_SUB  : begin
	                    next_operand_a = {2'b00, instruction[10:8]};
	                    next_alu_opcode  = `SUB;
	                    next_alu_stack_write_to_reg = {2'b00, instruction[10:8]};
	                    next_alu_stack_write_to_reg_enable = 1'b1;
	                    
	                    next_update_flag_n = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    next_update_flag_z = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						next_update_flag_c = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						next_update_flag_v = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                end
	            endcase
	        end
	        
	        `FORMAT_4  : begin
	            next_operand_a = {2'b00, instruction[2:0]};
	            next_operand_b = {2'b00, instruction[5:3]};

		    next_alu_opcode = `ORR; // added for: no latch
	            
	            next_offset_a = `IMM_ZERO;
	            next_offset_b = `IMM_ZERO;
	            
	            next_pc_mask_bit = 1'b0;
	            
	            next_alu_stack_write_to_reg = 5'b0; // added for: no latch
	            next_memory_write_to_reg = `RF_NONE;
	            next_memory_write_to_reg_enable = 1'b0;
	            
	            next_memory_store_data_reg = `RF_NONE;
	            next_memory_store_address_reg = `RF_NONE;
	            next_memory_address_source_is_reg = 1'b0;
	            next_load_store_width = `WORD;
	            next_memorycontroller_sign_extend = 1'b0;
	
	            next_memory_load_request = 1'b0;
	            next_memory_store_request = 1'b0;
	             
	            next_stack_push_request = 1'b0;
	            next_stack_pop_request = 1'b0;
	            
	            next_stall_to_instructionfetch       = 1;
	                                
	            next_step                            = 9'b1_1111_1111;
	            
	            casez (instruction[9:6])
	                `F4_AND : begin
	                    next_alu_opcode  = `AND;
	                    next_alu_stack_write_to_reg = {2'b00, instruction[2:0]};
	                    next_alu_stack_write_to_reg_enable = 1'b1;
	                    
	                    next_update_flag_n = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    next_update_flag_z = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						next_update_flag_c = 1'b0;
						next_update_flag_v = 1'b0;
	                end
	                `F4_EOR : begin
	                    next_alu_opcode  = `EOR;
	                    next_alu_stack_write_to_reg = {2'b00, instruction[2:0]};
	                    next_alu_stack_write_to_reg_enable = 1'b1;
	                    
	                    next_update_flag_n = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    next_update_flag_z = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						next_update_flag_c = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						next_update_flag_v = 1'b0;
	                end
	                `F4_LSL : begin
	                    next_alu_opcode  = `LSL;
	                    next_alu_stack_write_to_reg = {2'b00, instruction[2:0]};
	                    next_alu_stack_write_to_reg_enable = 1'b1;
	                    
	                    next_update_flag_n = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    next_update_flag_z = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						next_update_flag_c = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						next_update_flag_v = 1'b0;
	                end
	                `F4_LSR : begin
	                    next_alu_opcode  = `LSR;
	                    next_alu_stack_write_to_reg = {2'b00, instruction[2:0]};
	                    next_alu_stack_write_to_reg_enable = 1'b1;
	                    
	                    next_update_flag_n = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    next_update_flag_z = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						next_update_flag_c = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						next_update_flag_v = 1'b0;
	                end
	                `F4_ASR : begin
	                    next_alu_opcode  = `ASR;
	                    next_alu_stack_write_to_reg = {2'b00, instruction[2:0]};
	                    next_alu_stack_write_to_reg_enable = 1'b1;
	                    
	                    next_update_flag_n = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    next_update_flag_z = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    next_update_flag_c = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						next_update_flag_v = 1'b0;
	                end
	                `F4_ADC : begin
	                    next_alu_opcode  = `ADC;
	                    next_alu_stack_write_to_reg = {2'b00, instruction[2:0]};
	                    next_alu_stack_write_to_reg_enable = 1'b1;
	                    
	                    next_update_flag_n = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    next_update_flag_z = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						next_update_flag_c = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						next_update_flag_v = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                end
	                `F4_SBC : begin
	                    next_alu_opcode  = `SBC;
	                    next_alu_stack_write_to_reg = {2'b00, instruction[2:0]};
	                    next_alu_stack_write_to_reg_enable = 1'b1;
	                    
	                    next_update_flag_n = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    next_update_flag_z = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						next_update_flag_c = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						next_update_flag_v = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                end
	                `F4_ROR : begin
	                    next_alu_opcode  = `ROR;
	                    next_alu_stack_write_to_reg = {2'b00, instruction[2:0]};
	                    next_alu_stack_write_to_reg_enable = 1'b1;
	                    
	                    next_update_flag_n = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    next_update_flag_z = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						next_update_flag_c = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						next_update_flag_v = 1'b0;
	                end
	                `F4_TST : begin
	                    next_alu_opcode  = `TST;
	                    next_alu_stack_write_to_reg = `RF_NONE;
	                    next_alu_stack_write_to_reg_enable = 1'b0;
	                    
	                    next_update_flag_n = 1'b1;
	                    next_update_flag_z = 1'b1;
						next_update_flag_c = 1'b0;
						next_update_flag_v = 1'b0;
	                end
	                `F4_NEG : begin
	                    next_alu_opcode  = `NEG;
	                    next_alu_stack_write_to_reg = {2'b00, instruction[2:0]};
	                    next_alu_stack_write_to_reg_enable = 1'b1;
	                    
	                    next_update_flag_n = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    next_update_flag_z = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						next_update_flag_c = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						next_update_flag_v = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                end
	                `F4_CMP : begin
	                    next_alu_opcode  = `CMP;
	                    next_alu_stack_write_to_reg = `RF_NONE;
	                    next_alu_stack_write_to_reg_enable = 1'b0;
	                    
	                    next_update_flag_n = 1'b1;
	                    next_update_flag_z = 1'b1;
						next_update_flag_c = 1'b1;
						next_update_flag_v = 1'b1;
	                end
	                `F4_CMN : begin
	                    next_alu_opcode  = `CMN;
	                    next_alu_stack_write_to_reg = `RF_NONE;
	                    next_alu_stack_write_to_reg_enable = 1'b0;
	                    
	                    next_update_flag_n = 1'b1;
	                    next_update_flag_z = 1'b1;
						next_update_flag_c = 1'b1;
						next_update_flag_v = 1'b1;
	                end
	                `F4_ORR : begin
	                    next_alu_opcode  = `ORR;
	                    next_alu_stack_write_to_reg = {2'b00, instruction[2:0]};
	                    next_alu_stack_write_to_reg_enable = 1'b1;
	                    
	                    next_update_flag_n = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    next_update_flag_z = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						next_update_flag_c = 1'b0;
						next_update_flag_v = 1'b0;
	                end
	                `F4_MUL : begin
	                    next_alu_opcode  = `MUL; 
	                    next_alu_stack_write_to_reg = {2'b00, instruction[2:0]};
	                    next_alu_stack_write_to_reg_enable = 1'b1;
	                    
	                    next_update_flag_n = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    next_update_flag_z = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						next_update_flag_c = 1'b0;
						next_update_flag_v = 1'b0;
	                end
	                `F4_BIC : begin
	                    next_alu_opcode  = `BIC;
	                    next_alu_stack_write_to_reg = {2'b00, instruction[2:0]};
	                    next_alu_stack_write_to_reg_enable = 1'b1;
	                    
	                    next_update_flag_n = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    next_update_flag_z = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						next_update_flag_c = 1'b0;
						next_update_flag_v = 1'b0;
	                end
	                `F4_MVN : begin
	                    next_alu_opcode  = `MVN;
	                    next_alu_stack_write_to_reg = {2'b00, instruction[2:0]};
	                    next_alu_stack_write_to_reg_enable = 1'b1;
	                    
	                    next_update_flag_n = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    next_update_flag_z = (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						next_update_flag_c = 1'b0;
						next_update_flag_v = 1'b0;
	                end
	            endcase
	        end
	        
	        `FORMAT_5  : begin   
	            next_operand_a = �`RF_NONE; // added for: no latch                            
	            
	            next_offset_a = `IMM_ZERO;
	            next_offset_b = `IMM_ZERO;

		    next_alu_opcode = `ORR; // added for: no latch
	            
	            next_pc_mask_bit = 1'b0;
	            
	            next_alu_stack_write_to_reg = 5'b0; // added for: no latch
	            next_memory_write_to_reg = `RF_NONE;
	            next_memory_write_to_reg_enable = 1'b0;
	            
	            next_memory_store_data_reg = `RF_NONE;
	            next_memory_store_address_reg = `RF_NONE;
	            next_memory_address_source_is_reg = 1'b0;
	            next_load_store_width = `WORD;
	            next_memorycontroller_sign_extend = 1'b0;
	
	            next_memory_load_request = 1'b0;
	            next_memory_store_request = 1'b0;
	            
	            next_stack_push_request = 1'b0;
	            next_stack_pop_request = 1'b0;
	            
	            next_stall_to_instructionfetch       = 1;
	                                
	            next_step                            = 9'b1_1111_1111;
	            
	            casez (instruction[9:8])
	                `F5_ADD : begin
	                    next_operand_a = {1'b0, instruction[7], instruction[2:0]};
	                    next_operand_b = {1'b0, instruction[6], instruction[5:3]};
	                
	                    next_alu_opcode  = `ADD;
	                    
	                    next_alu_stack_write_to_reg = {1'b0, instruction[7], instruction[2:0]};
	                    next_alu_stack_write_to_reg_enable = 1'b1;
	                    
	                    next_update_flag_n = 1'b0;
	                    next_update_flag_z = 1'b0;
						next_update_flag_c = 1'b0;
						next_update_flag_v = 1'b0;
	                end
	                `F5_CMP : begin
	                    next_operand_a = {1'b0, instruction[7], instruction[2:0]};
	                    next_operand_b = {1'b0, instruction[6], instruction[5:3]};
	                
	                    next_alu_opcode  = `CMP;
	                    
	                    next_alu_stack_write_to_reg = `RF_NONE;
	                    next_alu_stack_write_to_reg_enable = 1'b0;
	                    
	                    next_update_flag_n = 1'b1;
	                    next_update_flag_z = 1'b1;
						next_update_flag_c = 1'b1;
						next_update_flag_v = 1'b1;
	                end
	                `F5_MOV : begin
	                    next_operand_a = `RF_IMM;
	                    next_operand_b = {1'b0, instruction[6], instruction[5:3]};
	                    
	                    next_alu_opcode  = `ORR; // entspricht PASSB wegen next_operand_a = 0
	                    
	                    next_alu_stack_write_to_reg = {1'b0, instruction[7], instruction[2:0]};
	                    next_alu_stack_write_to_reg_enable = 1'b1;
	                    
	                    next_update_flag_n = 1'b0;
	                    next_update_flag_z = 1'b0;
						next_update_flag_c = 1'b0;
						next_update_flag_v = 1'b0;
	                end
	                `F5_BX  : begin
	                    next_operand_a = `RF_IMM;
	                    next_operand_b = {1'b0, instruction[6], instruction[5:3]};
	                
	                    next_alu_opcode  = `ORR; // entspricht PASSB wegen next_operand_a = 0
	                    
	                    next_alu_stack_write_to_reg = `RF_R15_PC;
	                    next_alu_stack_write_to_reg_enable = 1'b1;
	                    
	                    next_update_flag_n = 1'b0;
	                    next_update_flag_z = 1'b0;
						next_update_flag_c = 1'b0;
						next_update_flag_v = 1'b0;
	                end
	            endcase
	        end
	        
	        `FORMAT_6  : begin                               
	            next_operand_a = `RF_R15_PC;
	            next_operand_b = `RF_IMM;
	            
	            // siehe Beispiel mit den 844 = 211 (844 / 4) im Opcode wegen 
	            // wegen immediate = word8, Linksshift von next_offset_b um 2 
	            
	            next_offset_a = `IMM_ZERO;
	            next_offset_b = {22'b0000_0000_0000_0000_0000_00, instruction[7:0], 2'b00};
	            
	            next_alu_opcode = `ADD;
	            
	            next_pc_mask_bit = 1'b1;
	            
	            next_update_flag_n = 1'b0;
	            next_update_flag_z = 1'b0;
	            next_update_flag_c = 1'b0;
	            next_update_flag_v = 1'b0;
	            
	            next_alu_stack_write_to_reg = `RF_NONE;
	            next_alu_stack_write_to_reg_enable = 1'b0;
	            
	            next_memory_write_to_reg = {2'b00, instruction[10:8]};
	            next_memory_write_to_reg_enable = 1'b1;
	
	            next_memory_store_data_reg = `RF_NONE;
	            next_memory_store_address_reg = `RF_NONE;
	            next_memory_address_source_is_reg = 1'b0;
	            next_load_store_width = `WORD;
	            next_memorycontroller_sign_extend = 1'b0;
	            
	            next_memory_load_request = 1'b1;                                       
	            next_memory_store_request = 1'b0;
	             
	            next_stack_push_request = 1'b0;
	            next_stack_pop_request = 1'b0;
	            
	            next_stall_to_instructionfetch       = 1;
	                                
	            next_step                            = 9'b1_1111_1111;
	            
	        end
	        
	        `FORMAT_7  : begin                          
	            next_operand_a = {2'b00, instruction[5:3]};
	            next_operand_b = {2'b00, instruction[8:6]};
	            
	            next_offset_a = `IMM_ZERO;
	            next_offset_b = `IMM_ZERO;
	            
	            next_alu_opcode = `ADD;
	            
	            next_pc_mask_bit = 1'b0;
	            
	            next_update_flag_n = 1'b0;
	            next_update_flag_z = 1'b0;
	            next_update_flag_c = 1'b0;
	            next_update_flag_v = 1'b0;
	            
	            next_alu_stack_write_to_reg = `RF_NONE;
	            next_alu_stack_write_to_reg_enable = 1'b0;
	            
	            next_memory_store_address_reg = `RF_NONE;
	            next_memory_address_source_is_reg = 1'b0;
	            next_memorycontroller_sign_extend = 1'b0;
	             
	            next_stack_push_request = 1'b0;
	            next_stack_pop_request = 1'b0;
	            
	            next_stall_to_instructionfetch       = 1;
	                                
	            next_step                            = 9'b1_1111_1111;
	            
	            casez (instruction[11])
	                `F7_STORE : begin
	                    next_memory_write_to_reg = `RF_NONE;
	                    next_memory_write_to_reg_enable = 1'b0;
	                    next_memory_store_data_reg = {2'b00, instruction[2:0]};
	                    
	                    next_memory_load_request = 1'b0;                                       
	                    next_memory_store_request = 1'b1;
	                end
	                `F7_LOAD : begin
	                    next_memory_write_to_reg = {2'b00, instruction[2:0]};
	                    next_memory_write_to_reg_enable = 1'b1;
	                    next_memory_store_data_reg = `RF_NONE;
	                    
	                    next_memory_load_request = 1'b1;                                       
	                    next_memory_store_request = 1'b0;
	                end
	            endcase
	            
	            casez (instruction[10])
	                `F7_WORD : next_load_store_width = `WORD;
	                `F7_BYTE : next_load_store_width = `BYTE;
	            endcase
	        end
	        
	        `FORMAT_8  : begin                          
	            next_operand_a = {2'b00, instruction[5:3]};
	            next_operand_b = {2'b00, instruction[8:6]};
	            
	            next_offset_a = `IMM_ZERO;
	            next_offset_b = `IMM_ZERO;
	            
	            next_alu_opcode = `ADD;
	            
	            next_pc_mask_bit = 1'b0;
	            
	            next_update_flag_n = 1'b0;
	            next_update_flag_z = 1'b0;
	            next_update_flag_c = 1'b0;
	            next_update_flag_v = 1'b0;
	            
	            next_alu_stack_write_to_reg = `RF_NONE;
	            next_alu_stack_write_to_reg_enable = 1'b0;
	            
	            next_memory_store_address_reg = `RF_NONE;
	            next_memory_address_source_is_reg = 1'b0;
	             
	            next_stack_push_request = 1'b0;
	            next_stack_pop_request = 1'b0;
	            
	            next_stall_to_instructionfetch       = 1;
	                                
	            next_step                            = 9'b1_1111_1111;
	            
	            casez (instruction[11:10])
	            `F8_STORE_HW   : begin
	                    next_memory_write_to_reg = `RF_NONE;
	                    next_memory_write_to_reg_enable = 1'b0;
	                    next_memory_store_data_reg = {2'b00, instruction[2:0]};
	
	                    next_load_store_width = `HALFWORD;
	                    next_memorycontroller_sign_extend = 1'b0;
	                    
	                    next_memory_load_request = 1'b0;                                       
	                    next_memory_store_request = 1'b1;
	                end
	            `F8_LOAD_HW    : begin
	                    next_memory_write_to_reg = {2'b00, instruction[2:0]};
	                    next_memory_write_to_reg_enable = 1'b1;
	                    next_memory_store_data_reg = `RF_NONE;
	                               
	                    next_load_store_width = `HALFWORD;
	                    next_memorycontroller_sign_extend = 1'b0;
	                    
	                    next_memory_load_request = 1'b1;                                       
	                    next_memory_store_request = 1'b0;
	                end
	            `F8_LOAD_SE_B  : begin
	                    next_memory_write_to_reg = {2'b00, instruction[2:0]};
	                    next_memory_write_to_reg_enable = 1'b1;
	                    next_memory_store_data_reg = `RF_NONE;
	                               
	                    next_load_store_width = `BYTE;
	                    next_memorycontroller_sign_extend = 1'b1;
	                    
	                    next_memory_load_request = 1'b1;                                       
	                    next_memory_store_request = 1'b0;
	                end
	            `F8_LOAD_SE_HW : begin
	                    next_memory_write_to_reg = {2'b00, instruction[2:0]};
	                    next_memory_write_to_reg_enable = 1'b1;
	                    next_memory_store_data_reg = `RF_NONE;
	                               
	                    next_load_store_width = `HALFWORD;
	                    next_memorycontroller_sign_extend = 1'b1;
	                    
	                    next_memory_load_request = 1'b1;                                       
	                    next_memory_store_request = 1'b0;
	                end
	            endcase
	
	        end       
	        
	        `FORMAT_9  : begin                                            
	            next_operand_a = {2'b00, instruction[5:3]};
	            next_operand_b = `RF_IMM;
	            
	            next_offset_a = `IMM_ZERO;
	            next_offset_b = {25'b0000_0000_0000_0000_0000_0000_0, instruction[10:6], 2'b00};
	            
	            next_alu_opcode = `ADD;
	            
	            next_pc_mask_bit = 1'b0;
	            
	            next_update_flag_n = 1'b0;
	            next_update_flag_z = 1'b0;
	            next_update_flag_c = 1'b0;
	            next_update_flag_v = 1'b0;
	            
	            next_alu_stack_write_to_reg = `RF_NONE;
	            next_alu_stack_write_to_reg_enable = 1'b0;
	        
	            next_memory_store_address_reg = `RF_NONE;
	            next_memory_address_source_is_reg = 1'b0;
	            next_memorycontroller_sign_extend = 1'b0;
	             
	            next_stack_push_request = 1'b0;
	            next_stack_pop_request = 1'b0;
	            
	            next_stall_to_instructionfetch       = 1;
	                                
	            next_step                            = 9'b1_1111_1111;
	            
	            casez (instruction[11])
	                `F9_STORE : begin
	                    next_memory_write_to_reg = `RF_NONE;
	                    next_memory_write_to_reg_enable = 1'b0;
	                    next_memory_store_data_reg = {2'b00, instruction[2:0]};
	                
	                    next_memory_load_request = 1'b0;                                       
	                    next_memory_store_request = 1'b1;
	                end
	                `F9_LOAD : begin
	                    next_memory_write_to_reg = {2'b00, instruction[2:0]};
	                    next_memory_write_to_reg_enable = 1'b1;
	                    next_memory_store_data_reg = `RF_NONE;
	                    
	                    next_memory_load_request = 1'b1;                                       
	                    next_memory_store_request = 1'b0;
	                end
	            endcase
	            
	            casez (instruction[12])
	                `F9_WORD : next_load_store_width = `WORD;
	                `F9_BYTE : next_load_store_width = `BYTE;
	            endcase
	            
	        end
	        
	        `FORMAT_10  : begin                                            
	            next_operand_a = {2'b00, instruction[5:3]};
	            next_operand_b = `RF_IMM;
	            
	            next_offset_a = `IMM_ZERO;
	            next_offset_b = {26'b0000_0000_0000_0000_0000_0000_00, instruction[10:6], 1'b0};
	
	            next_alu_opcode = `ADD;
	            
	            next_pc_mask_bit = 1'b0;
	            
	            next_update_flag_n = 1'b0;
	            next_update_flag_z = 1'b0;
	            next_update_flag_c = 1'b0;
	            next_update_flag_v = 1'b0;
	            
	            next_alu_stack_write_to_reg = `RF_NONE;
	            next_alu_stack_write_to_reg_enable = 1'b0;
	            
	            next_memory_store_address_reg = `RF_NONE;
	            next_memory_address_source_is_reg = 1'b0;
	            next_load_store_width = `HALFWORD;
	            next_memorycontroller_sign_extend = 1'b0;
	             
	            next_stack_push_request = 1'b0;
	            next_stack_pop_request = 1'b0;
	            
	            next_stall_to_instructionfetch       = 1;
	                                
	            next_step                            = 9'b1_1111_1111;
	            
	            casez (instruction[11])
	                `F10_STORE : begin
	                    next_memory_write_to_reg = `RF_NONE;
	                    next_memory_write_to_reg_enable = 1'b0;
	                    next_memory_store_data_reg = {2'b00, instruction[2:0]};
	                
	                    next_memory_load_request = 1'b0;                                       
	                    next_memory_store_request = 1'b1;
	                end
	                `F10_LOAD : begin
	                    next_memory_write_to_reg = {2'b00, instruction[2:0]};
	                    next_memory_write_to_reg_enable = 1'b1;
	                    next_memory_store_data_reg = `RF_NONE;
	                
	                    next_memory_load_request = 1'b1;                                       
	                    next_memory_store_request = 1'b0;
	                end
	            endcase
	                      
	        end
	        
	        `FORMAT_11  : begin
	            next_operand_a = `RF_R13_SP;
	            next_operand_b = `RF_IMM;
	            
	            next_offset_a = `IMM_ZERO;
	            next_offset_b = {22'b0000_0000_0000_0000_0000_00, instruction[7:0], 2'b00};
	            
	            next_alu_opcode = `ADD; 
	            
	            next_pc_mask_bit = 1'b0;
	            
	            next_update_flag_n = 1'b0;
	            next_update_flag_z = 1'b0;
	            next_update_flag_c = 1'b0;
	            next_update_flag_v = 1'b0;
	            
	            next_alu_stack_write_to_reg = `RF_NONE;
	            next_alu_stack_write_to_reg_enable = 1'b0;
	            
	            next_memory_store_address_reg = `RF_NONE;
	            next_memory_address_source_is_reg = 1'b0;
	            next_load_store_width = `WORD;
	            next_memorycontroller_sign_extend = 1'b0;
	            
	            next_stack_push_request = 1'b0;
	            next_stack_pop_request = 1'b0;
	            
	            next_stall_to_instructionfetch       = 1;
	                                
	            next_step                            = 9'b1_1111_1111;
	            
	            casez (instruction[11])
	                `F11_STORE : begin
	                    next_memory_write_to_reg = `RF_NONE;
	                    next_memory_write_to_reg_enable = 1'b0;
	                    next_memory_store_data_reg = {2'b00, instruction[10:8]};
	                
	                    next_memory_load_request = 1'b0;                                       
	                    next_memory_store_request = 1'b1;
	                end
	                `F11_LOAD : begin
	                    next_memory_write_to_reg = {2'b00, instruction[10:8]};
	                    next_memory_write_to_reg_enable = 1'b1;
	                    next_memory_store_data_reg = `RF_NONE;
	                
	                    next_memory_load_request = 1'b1;                                       
	                    next_memory_store_request = 1'b0;
	                end
	            endcase
	            
	        end
	        
	        `FORMAT_12  : begin
	            next_operand_a = �`RF_NONE; // added for: no latch
	            next_operand_b = `RF_IMM;
	
	            next_offset_a = `IMM_ZERO;
	            next_offset_b = {22'b0000_0000_0000_0000_0000_00, instruction[7:0], 2'b00};
	            
	            next_alu_opcode = `ADD; 
	            
	            next_pc_mask_bit = 1'b0;
	            
	            next_update_flag_n = 1'b0;
	            next_update_flag_z = 1'b0;
	            next_update_flag_c = 1'b0;
	            next_update_flag_v = 1'b0;
	            
	            next_alu_stack_write_to_reg = {2'b00, instruction[10:8]};
	            next_alu_stack_write_to_reg_enable = 1'b1;
	            next_memory_write_to_reg = `RF_NONE;
	            next_memory_write_to_reg_enable = 1'b0;
	            
	            next_memory_store_data_reg = `RF_NONE;
	            next_memory_store_address_reg = `RF_NONE;
	            next_memory_address_source_is_reg = 1'b0;
	            next_load_store_width = `WORD;
	            next_memorycontroller_sign_extend = 1'b0;
	            
	            next_memory_load_request = 1'b0;                                       
	            next_memory_store_request = 1'b0;
	            
	            next_stack_push_request = 1'b0;
	            next_stack_pop_request = 1'b0;
	            
	            next_stall_to_instructionfetch       = 1;
	                                
	            next_step                            = 9'b1_1111_1111;
	                        
	            casez (instruction[11])
	                `F12_PC : next_operand_a = `RF_R15_PC;
	                `F12_SP : next_operand_a = `RF_R13_SP;
	            endcase
	            
	        end
	        
	        `FORMAT_13  : begin
	            next_operand_a = `RF_R13_SP;
	            next_operand_b = `RF_IMM;
	            
	            next_offset_a = `IMM_ZERO;
	            next_offset_b = {23'b0000_0000_0000_0000_0000_000, instruction[6:0], 2'b00};

		    next_alu_opcode = `ORR; // added for: no latch
	            
	            next_pc_mask_bit = 1'b0;
	            
	            next_update_flag_n = 1'b0;
	            next_update_flag_z = 1'b0;
	            next_update_flag_c = 1'b0;
	            next_update_flag_v = 1'b0;
	
	            next_alu_stack_write_to_reg = `RF_R13_SP;
	            next_alu_stack_write_to_reg_enable = 1'b1;
	            next_memory_write_to_reg = `RF_NONE;
	            next_memory_write_to_reg_enable = 1'b0;
	            
	            next_memory_store_data_reg = `RF_NONE;
	            next_memory_store_address_reg = `RF_NONE;
	            next_memory_address_source_is_reg = 1'b0;
	            next_load_store_width = `WORD;
	            next_memorycontroller_sign_extend = 1'b0;
	            
	            next_memory_load_request = 1'b0;                                       
	            next_memory_store_request = 1'b0;
	            
	            next_stack_push_request = 1'b0;
	            next_stack_pop_request = 1'b0;
	            
	            next_stall_to_instructionfetch       = 1;
	                                
	            next_step                            = 9'b1_1111_1111;
	            
	            casez (instruction[7])
	                `F12_ADD : begin
	                    next_alu_opcode = `ADD;
	                end
	                `F12_SUB : begin
	                    next_alu_opcode = `SUB;
	                end
	            endcase
	            
	        end
	        
// 	        `FORMAT_14  : begin                                   
// 	            
// 	            next_operand_b = `RF_IMM;
// 	            
// 	            next_offset_a = `IMM_ZERO; 
// 	            next_offset_b = `IMM_ZERO;
// 	            
// 	            next_alu_opcode = `ORR;    // belanglos
// 	            
// 	            next_update_flag_n = 1'b0;
// 	            next_update_flag_z = 1'b0;
// 	            next_update_flag_c = 1'b0;
// 	            next_update_flag_v = 1'b0;
// 	                     
// 	            next_memory_write_to_reg = `RF_NONE;
// 	            next_memory_write_to_reg_enable = 1'b0;
// 	            
// 	            next_memory_store_data_reg = `RF_NONE;
// 	            next_memory_store_address_reg = `RF_NONE;
// 	            next_memory_address_source_is_reg = 1'b0;
// 	            next_load_store_width = `WORD;
// 	            next_memorycontroller_sign_extend = 1'b0;
// 	            
// 	            next_memory_load_request = 1'b0;                                       
// 	            next_memory_store_request = 1'b0;
// 	            
// 	            
// 	            // Instruktionssplit
// 	            casez (next_step & instruction[8:0])
// 	            
// 	                // Endf채lle 
// 	                9'b0_0000_0001 : begin
// 	                    casez (instruction[11])
// 	                        `F14_PUSH : begin
//                                 next_operand_a = `RF_R0;
//                                 next_alu_stack_write_to_reg = `RF_NONE;
//                                 next_alu_stack_write_to_reg_enable = 1'b0;
// 	                            next_stack_push_request = 1'b1; 
// 	                            next_stack_pop_request = 1'b0;
// 	                        end
// 	                        `F14_POP : begin
// 	                            next_operand_a = `RF_NONE;
//                                 next_alu_stack_write_to_reg = `RF_R0;
//                                 next_alu_stack_write_to_reg_enable = 1'b1;
// 	                            next_stack_push_request = 1'b0;
// 	                            next_stack_pop_request = 1'b1;
// 	                        end
// 	                    endcase
// 	                    
// 	                    next_stall_to_instructionfetch = 1'b1;
// 	                    next_step = 9'b1_1111_1111;
// 	                end
// 	                
// 	                9'b0_0000_0010 : begin
// 	                    casez (instruction[11])
// 	                        `F14_PUSH : begin
//                                 next_operand_a = `RF_R1;
//                                 next_alu_stack_write_to_reg = `RF_NONE;
//                                 next_alu_stack_write_to_reg_enable = 1'b0;
// 	                            next_stack_push_request = 1'b1; 
// 	                            next_stack_pop_request = 1'b0;
// 	                        end
// 	                        `F14_POP : begin
// 	                            next_operand_a = `RF_NONE;
//                                 next_alu_stack_write_to_reg = `RF_R1;
//                                 next_alu_stack_write_to_reg_enable = 1'b1;
// 	                            next_stack_push_request = 1'b0;
// 	                            next_stack_pop_request = 1'b1;
// 	                        end
// 	                    endcase
// 	                    
// 	                    next_stall_to_instructionfetch = 1'b1;
// 	                    next_step = 9'b1_1111_1111;
// 	                end
// 	                
// 	                9'b0_0000_0100 : begin
// 	                    casez (instruction[11])
// 	                        `F14_PUSH : begin
//                                 next_operand_a = `RF_R2;
//                                 next_alu_stack_write_to_reg = `RF_NONE;
//                                 next_alu_stack_write_to_reg_enable = 1'b0;
// 	                            next_stack_push_request = 1'b1; 
// 	                            next_stack_pop_request = 1'b0;
// 	                        end
// 	                        `F14_POP : begin
// 	                            next_operand_a = `RF_NONE;
//                                 next_alu_stack_write_to_reg = `RF_R2;
//                                 next_alu_stack_write_to_reg_enable = 1'b1;
// 	                            next_stack_push_request = 1'b0;
// 	                            next_stack_pop_request = 1'b1;
// 	                        end
// 	                    endcase
// 	                    
// 	                    next_stall_to_instructionfetch = 1'b1;
// 	                    next_step = 9'b1_1111_1111;
// 	                end
// 	                
// 	                9'b0_0000_1000 : begin
// 	                    casez (instruction[11])
// 	                        `F14_PUSH : begin
//                                 next_operand_a = `RF_R3;
//                                 next_alu_stack_write_to_reg = `RF_NONE;
//                                 next_alu_stack_write_to_reg_enable = 1'b0;
// 	                            next_stack_push_request = 1'b1; 
// 	                            next_stack_pop_request = 1'b0;
// 	                        end
// 	                        `F14_POP : begin
// 	                            next_operand_a = `RF_NONE;
//                                 next_alu_stack_write_to_reg = `RF_R3;
//                                 next_alu_stack_write_to_reg_enable = 1'b1;
// 	                            next_stack_push_request = 1'b0;
// 	                            next_stack_pop_request = 1'b1;
// 	                        end
// 	                    endcase
// 	                    
// 	                    next_stall_to_instructionfetch = 1'b1;
// 	                    next_step = 9'b1_1111_1111;
// 	                end
// 	                
// 	                9'b0_0001_0000 : begin
// 	                    casez (instruction[11])
// 	                        `F14_PUSH : begin
//                                 next_operand_a = `RF_R4;
//                                 next_alu_stack_write_to_reg = `RF_NONE;
//                                 next_alu_stack_write_to_reg_enable = 1'b0;
// 	                            next_stack_push_request = 1'b1; 
// 	                            next_stack_pop_request = 1'b0;
// 	                        end
// 	                        `F14_POP : begin
// 	                            next_operand_a = `RF_NONE;
//                                 next_alu_stack_write_to_reg = `RF_R4;
//                                 next_alu_stack_write_to_reg_enable = 1'b1;
// 	                            next_stack_push_request = 1'b0;
// 	                            next_stack_pop_request = 1'b1;
// 	                        end
// 	                    endcase
// 	                    
// 	                    next_stall_to_instructionfetch = 1'b1;
// 	                    next_step = 9'b1_1111_1111;
// 	                end
// 	                
// 	                9'b0_0010_0000 : begin
// 	                    casez (instruction[11])
// 	                        `F14_PUSH : begin
//                                 next_operand_a = `RF_R5;
//                                 next_alu_stack_write_to_reg = `RF_NONE;
//                                 next_alu_stack_write_to_reg_enable = 1'b0;
// 	                            next_stack_push_request = 1'b1; 
// 	                            next_stack_pop_request = 1'b0;
// 	                        end
// 	                        `F14_POP : begin
// 	                            next_operand_a = `RF_NONE;
//                                 next_alu_stack_write_to_reg = `RF_R5;
//                                 next_alu_stack_write_to_reg_enable = 1'b1;
// 	                            next_stack_push_request = 1'b0;
// 	                            next_stack_pop_request = 1'b1;
// 	                        end
// 	                    endcase
// 	                    
// 	                    next_stall_to_instructionfetch = 1'b1;
// 	                    next_step = 9'b1_1111_1111;
// 	                end
// 	                
// 	                9'b0_0100_0000 : begin
// 	                    casez (instruction[11])
// 	                        `F14_PUSH : begin
//                                 next_operand_a = `RF_R6;
//                                 next_alu_stack_write_to_reg = `RF_NONE;
//                                 next_alu_stack_write_to_reg_enable = 1'b0;
// 	                            next_stack_push_request = 1'b1; 
// 	                            next_stack_pop_request = 1'b0;
// 	                        end
// 	                        `F14_POP : begin
// 	                            next_operand_a = `RF_NONE;
//                                 next_alu_stack_write_to_reg = `RF_R6;
//                                 next_alu_stack_write_to_reg_enable = 1'b1;
// 	                            next_stack_push_request = 1'b0;
// 	                            next_stack_pop_request = 1'b1;
// 	                        end
// 	                    endcase
// 	                    
// 	                    next_stall_to_instructionfetch = 1'b1;
// 	                    next_step = 9'b1_1111_1111;
// 	                end
// 	                
// 	                9'b0_1000_0000 : begin
// 	                    casez (instruction[11])
// 	                        `F14_PUSH : begin
//                                 next_operand_a = `RF_R7;
//                                 next_alu_stack_write_to_reg = `RF_NONE;
//                                 next_alu_stack_write_to_reg_enable = 1'b0;
// 	                            next_stack_push_request = 1'b1; 
// 	                            next_stack_pop_request = 1'b0;
// 	                        end
// 	                        `F14_POP : begin
// 	                            next_operand_a = `RF_NONE;
//                                 next_alu_stack_write_to_reg = `RF_R7;
//                                 next_alu_stack_write_to_reg_enable = 1'b1;
// 	                            next_stack_push_request = 1'b0;
// 	                            next_stack_pop_request = 1'b1;
// 	                        end
// 	                    endcase
// 	                    
// 	                    next_stall_to_instructionfetch = 1'b1;
// 	                    next_step = 9'b1_1111_1111;
// 	                end
// 	                
//                     9'b1_0000_0000 : begin
// 	                    casez (instruction[11])
// 	                        `F14_PUSH : begin
//                                 next_operand_a = `RF_R14_LR;
//                                 next_alu_stack_write_to_reg = `RF_NONE;
//                                 next_alu_stack_write_to_reg_enable = 1'b0;
// 	                            next_stack_push_request = 1'b1; 
// 	                            next_stack_pop_request = 1'b0;
// 	                        end
// 	                        `F14_POP : begin
// 	                            next_operand_a = `RF_NONE;
//                                 next_alu_stack_write_to_reg = `RF_R15_PC;
//                                 next_alu_stack_write_to_reg_enable = 1'b1;
// 	                            next_stack_push_request = 1'b0;
// 	                            next_stack_pop_request = 1'b1;
// 	                        end
// 	                    endcase
// 	                    
// 	                    next_stall_to_instructionfetch = 1'b1;
// 	                    next_step = 9'b1_1111_1111;
// 	                end
// 	            
// 	            
// 	                // Zwischenschritte 
// 	                9'b?_????_???1 : begin
// 	                    casez (instruction[11])
// 	                        `F14_PUSH : begin
//                                 next_operand_a = `RF_R0;
//                                 next_alu_stack_write_to_reg = `RF_NONE;
//                                 next_alu_stack_write_to_reg_enable = 1'b0;
// 	                            next_stack_push_request = 1'b1; 
// 	                            next_stack_pop_request = 1'b0;
// 	                        end
// 	                        `F14_POP : begin
// 	                            next_operand_a = `RF_NONE;
//                                 next_alu_stack_write_to_reg = `RF_R0;
//                                 next_alu_stack_write_to_reg_enable = 1'b1;
// 	                            next_stack_push_request = 1'b0;
// 	                            next_stack_pop_request = 1'b1;
// 	                        end
// 	                    endcase
// 	                    
// 	                    next_stall_to_instructionfetch = 1'b1;
// 	                    next_step = 9'b1_1111_1110;
// 	                end
// 	                
// 	                9'b?_????_??10 : begin
// 	                    casez (instruction[11])
// 	                        `F14_PUSH : begin
//                                 next_operand_a = `RF_R1;
//                                 next_alu_stack_write_to_reg = `RF_NONE;
//                                 next_alu_stack_write_to_reg_enable = 1'b0;
// 	                            next_stack_push_request = 1'b1; 
// 	                            next_stack_pop_request = 1'b0;
// 	                        end
// 	                        `F14_POP : begin
// 	                            next_operand_a = `RF_NONE;
//                                 next_alu_stack_write_to_reg = `RF_R1;
//                                 next_alu_stack_write_to_reg_enable = 1'b1;
// 	                            next_stack_push_request = 1'b0;
// 	                            next_stack_pop_request = 1'b1;
// 	                        end
// 	                    endcase
// 	                    
// 	                    next_stall_to_instructionfetch = 1'b1;
// 	                    next_step = 9'b1_1111_1100;
// 	                end
// 	                
// 	                9'b?_????_?100 : begin
// 	                    casez (instruction[11])
// 	                        `F14_PUSH : begin
//                                 next_operand_a = `RF_R2;
//                                 next_alu_stack_write_to_reg = `RF_NONE;
//                                 next_alu_stack_write_to_reg_enable = 1'b0;
// 	                            next_stack_push_request = 1'b1; 
// 	                            next_stack_pop_request = 1'b0;
// 	                        end
// 	                        `F14_POP : begin
// 	                            next_operand_a = `RF_NONE;
//                                 next_alu_stack_write_to_reg = `RF_R2;
//                                 next_alu_stack_write_to_reg_enable = 1'b1;
// 	                            next_stack_push_request = 1'b0;
// 	                            next_stack_pop_request = 1'b1;
// 	                        end
// 	                    endcase
// 	                    
// 	                    next_stall_to_instructionfetch = 1'b1;
// 	                    next_step = 9'b1_1111_1000;
// 	                end
// 	                
// 	                9'b?_????_1000 : begin
// 	                    casez (instruction[11])
// 	                        `F14_PUSH : begin
//                                 next_operand_a = `RF_R3;
//                                 next_alu_stack_write_to_reg = `RF_NONE;
//                                 next_alu_stack_write_to_reg_enable = 1'b0;
// 	                            next_stack_push_request = 1'b1; 
// 	                            next_stack_pop_request = 1'b0;
// 	                        end
// 	                        `F14_POP : begin
// 	                            next_operand_a = `RF_NONE;
//                                 next_alu_stack_write_to_reg = `RF_R3;
//                                 next_alu_stack_write_to_reg_enable = 1'b1;
// 	                            next_stack_push_request = 1'b0;
// 	                            next_stack_pop_request = 1'b1;
// 	                        end
// 	                    endcase
// 	                    
// 	                    next_stall_to_instructionfetch = 1'b1;
// 	                    next_step = 9'b1_1111_0000;
// 	                end
// 	                
// 	                9'b?_???1_0000 : begin
// 	                    casez (instruction[11])
// 	                        `F14_PUSH : begin
//                                 next_operand_a = `RF_R4;
//                                 next_alu_stack_write_to_reg = `RF_NONE;
//                                 next_alu_stack_write_to_reg_enable = 1'b0;
// 	                            next_stack_push_request = 1'b1; 
// 	                            next_stack_pop_request = 1'b0;
// 	                        end
// 	                        `F14_POP : begin
// 	                            next_operand_a = `RF_NONE;
//                                 next_alu_stack_write_to_reg = `RF_R4;
//                                 next_alu_stack_write_to_reg_enable = 1'b1;
// 	                            next_stack_push_request = 1'b0;
// 	                            next_stack_pop_request = 1'b1;
// 	                        end
// 	                    endcase
// 	                    
// 	                    next_stall_to_instructionfetch = 1'b1;
// 	                    next_step = 9'b1_1110_0000;
// 	                end
// 	                
// 	                9'b?_??10_0000 : begin
// 	                    casez (instruction[11])
// 	                        `F14_PUSH : begin
//                                 next_operand_a = `RF_R5;
//                                 next_alu_stack_write_to_reg = `RF_NONE;
//                                 next_alu_stack_write_to_reg_enable = 1'b0;
// 	                            next_stack_push_request = 1'b1; 
// 	                            next_stack_pop_request = 1'b0;
// 	                        end
// 	                        `F14_POP : begin
// 	                            next_operand_a = `RF_NONE;
//                                 next_alu_stack_write_to_reg = `RF_R5;
//                                 next_alu_stack_write_to_reg_enable = 1'b1;
// 	                            next_stack_push_request = 1'b0;
// 	                            next_stack_pop_request = 1'b1;
// 	                        end
// 	                    endcase
// 	                    
// 	                    next_stall_to_instructionfetch = 1'b1;
// 	                    next_step = 9'b1_1100_0000;
// 	                end
// 	                
// 	                9'b?_?100_0000 : begin
// 	                    casez (instruction[11])
// 	                        `F14_PUSH : begin
//                                 next_operand_a = `RF_R6;
//                                 next_alu_stack_write_to_reg = `RF_NONE;
//                                 next_alu_stack_write_to_reg_enable = 1'b0;
// 	                            next_stack_push_request = 1'b1; 
// 	                            next_stack_pop_request = 1'b0;
// 	                        end
// 	                        `F14_POP : begin
// 	                            next_operand_a = `RF_NONE;
//                                 next_alu_stack_write_to_reg = `RF_R6;
//                                 next_alu_stack_write_to_reg_enable = 1'b1;
// 	                            next_stack_push_request = 1'b0;
// 	                            next_stack_pop_request = 1'b1;
// 	                        end
// 	                    endcase
// 	                    
// 	                    next_stall_to_instructionfetch = 1'b1;
// 	                    next_step = 9'b1_1000_0000;
// 	                end
// 	                
//                     9'b?_1000_0000 : begin
// 	                    casez (instruction[11])
// 	                        `F14_PUSH : begin
//                                 next_operand_a = `RF_R7;
//                                 next_alu_stack_write_to_reg = `RF_NONE;
//                                 next_alu_stack_write_to_reg_enable = 1'b0;
// 	                            next_stack_push_request = 1'b1; 
// 	                            next_stack_pop_request = 1'b0;
// 	                        end
// 	                        `F14_POP : begin
// 	                            next_operand_a = `RF_NONE;
//                                 next_alu_stack_write_to_reg = `RF_R7;
//                                 next_alu_stack_write_to_reg_enable = 1'b1;
// 	                            next_stack_push_request = 1'b0;
// 	                            next_stack_pop_request = 1'b1;
// 	                        end
// 	                    endcase
// 	                    
// 	                    next_stall_to_instructionfetch = 1'b1;
// 	                    next_step = 9'b1_0000_0000;
// 	                end
// 	                
// 	                // sollte nie passieren
// 	                default: begin               
//                         next_operand_a = `RF_NONE;
//                         next_alu_stack_write_to_reg = `RF_NONE;
//                         next_alu_stack_write_to_reg_enable = 1'b0;
// 	                    next_stack_push_request = 1'b0; 
// 	                    next_stack_pop_request = 1'b0;
// 	                    
// 	                    next_stall_to_instructionfetch = 1'b1;
// 	                    next_step = 9'b1_1111_1111;
// 	                end
// 	                
// 	            endcase
// 	            
// 	            
// 	            
// 	        end

	        `FORMAT_14  : begin                                   
	            next_operand_a = `RF_R13_SP;
	            next_operand_b = `RF_IMM;
	            
	            next_offset_a = `IMM_ZERO;
	            next_offset_b = 32'b0000_0000_0000_0000_0000_0000_0000_0010;

		    next_alu_opcode = `ORR; // added for: no latch
	            
	            next_pc_mask_bit = 1'b0;
	            
	            next_update_flag_n = 1'b0;
	            next_update_flag_z = 1'b0;
	            next_update_flag_c = 1'b0;
	            next_update_flag_v = 1'b0;
	            
	            next_alu_stack_write_to_reg = `RF_R13_SP;                                                   
	            next_alu_stack_write_to_reg_enable = 1'b1;
	            
	            next_memory_store_address_reg = `RF_R13_SP;
	            
	            next_load_store_width = `WORD;
	            next_memorycontroller_sign_extend = 1'b0;
	            
	            next_stack_push_request = 1'b0;
	            next_stack_pop_request = 1'b0;

	            next_stall_to_instructionfetch       = 0; // added for: no latch
	            next_step                            = 9'b1_1111_1111; // added for: no latch
	                        
	            // Instruktionssplit
	            
	            casez (next_step & {instruction[8:0]})
	            
	                // Endf채lle 
	                9'b0_0000_0001 : begin
	                    casez (instruction[11])
						    `F14_PUSH : begin
                                next_alu_opcode = `SUB;                              // subtrahiert bei jedem push 4 vom stackpointer nach dem speicherzugriff
                                next_memory_address_source_is_reg = 1'b1;
						    
						        next_memory_write_to_reg = `RF_NONE;
						        next_memory_write_to_reg_enable = 1'b0;
						        next_memory_store_data_reg = `RF_R0;
						    
						        next_memory_load_request = 1'b0;                                       
						        next_memory_store_request = 1'b1;
						    end
						    `F14_POP : begin
						        next_alu_opcode = `ADD;                              // addiert bei jedem pop 4 zum stackpointer vor dem speicherzugriff
						        next_memory_address_source_is_reg = 1'b0;
						    
						        next_memory_write_to_reg = `RF_R0;
						        next_memory_write_to_reg_enable = 1'b1;
						        next_memory_store_data_reg = `RF_NONE;
						    
						        next_memory_load_request = 1'b1;                                       
						        next_memory_store_request = 1'b0;
						    end
						endcase
	                    
	                    next_stall_to_instructionfetch = 1'b1;
	                    next_step = 9'b1_1111_1111;
	                end
	                
	                9'b0_0000_0010 : begin
	                    casez (instruction[11])
						    `F14_PUSH : begin
                                next_alu_opcode = `SUB;                              // subtrahiert bei jedem push 4 vom stackpointer nach dem speicherzugriff
                                next_memory_address_source_is_reg = 1'b1;
						    
						        next_memory_write_to_reg = `RF_NONE;
						        next_memory_write_to_reg_enable = 1'b0;
						        next_memory_store_data_reg = `RF_R1;
						    
						        next_memory_load_request = 1'b0;                                       
						        next_memory_store_request = 1'b1;
						    end
						    `F14_POP : begin
						        next_alu_opcode = `ADD;                              // addiert bei jedem pop 4 zum stackpointer vor dem speicherzugriff
						        next_memory_address_source_is_reg = 1'b0;
						    
						        next_memory_write_to_reg = `RF_R1;
						        next_memory_write_to_reg_enable = 1'b1;
						        next_memory_store_data_reg = `RF_NONE;
						    
						        next_memory_load_request = 1'b1;                                       
						        next_memory_store_request = 1'b0;
						    end
						endcase
	                    
	                    next_stall_to_instructionfetch = 1'b1;
	                    next_step = 9'b1_1111_1111;
	                end
	                
	                9'b0_0000_0100 : begin
	                    casez (instruction[11])
						    `F14_PUSH : begin
                                next_alu_opcode = `SUB;                              // subtrahiert bei jedem push 4 vom stackpointer nach dem speicherzugriff
                                next_memory_address_source_is_reg = 1'b1;
						    
						        next_memory_write_to_reg = `RF_NONE;
						        next_memory_write_to_reg_enable = 1'b0;
						        next_memory_store_data_reg = `RF_R2;
						    
						        next_memory_load_request = 1'b0;                                       
						        next_memory_store_request = 1'b1;
						    end
						    `F14_POP : begin
						        next_alu_opcode = `ADD;                              // addiert bei jedem pop 4 zum stackpointer vor dem speicherzugriff
						        next_memory_address_source_is_reg = 1'b0;
						    
						        next_memory_write_to_reg = `RF_R2;
						        next_memory_write_to_reg_enable = 1'b1;
						        next_memory_store_data_reg = `RF_NONE;
						    
						        next_memory_load_request = 1'b1;                                       
						        next_memory_store_request = 1'b0;
						    end
						endcase
	                    
	                    next_stall_to_instructionfetch = 1'b1;
	                    next_step = 9'b1_1111_1111;
	                end
	                
	                9'b0_0000_1000 : begin
	                    casez (instruction[11])
						    `F14_PUSH : begin
                                next_alu_opcode = `SUB;                              // subtrahiert bei jedem push 4 vom stackpointer nach dem speicherzugriff
                                next_memory_address_source_is_reg = 1'b1;
						    
						        next_memory_write_to_reg = `RF_NONE;
						        next_memory_write_to_reg_enable = 1'b0;
						        next_memory_store_data_reg = `RF_R3;
						    
						        next_memory_load_request = 1'b0;                                       
						        next_memory_store_request = 1'b1;
						    end
						    `F14_POP : begin
						        next_alu_opcode = `ADD;                              // addiert bei jedem pop 4 zum stackpointer vor dem speicherzugriff
						        next_memory_address_source_is_reg = 1'b0;
						    
						        next_memory_write_to_reg = `RF_R3;
						        next_memory_write_to_reg_enable = 1'b1;
						        next_memory_store_data_reg = `RF_NONE;
						    
						        next_memory_load_request = 1'b1;                                       
						        next_memory_store_request = 1'b0;
						    end
						endcase
	                    
	                    next_stall_to_instructionfetch = 1'b1;
	                    next_step = 9'b1_1111_1111;
	                end
	                
	                9'b0_0001_0000 : begin
	                    casez (instruction[11])
						    `F14_PUSH : begin
                                next_alu_opcode = `SUB;                              // subtrahiert bei jedem push 4 vom stackpointer nach dem speicherzugriff
                                next_memory_address_source_is_reg = 1'b1;
						    
						        next_memory_write_to_reg = `RF_NONE;
						        next_memory_write_to_reg_enable = 1'b0;
						        next_memory_store_data_reg = `RF_R4;
						    
						        next_memory_load_request = 1'b0;                                       
						        next_memory_store_request = 1'b1;
						    end
						    `F14_POP : begin
						        next_alu_opcode = `ADD;                              // addiert bei jedem pop 4 zum stackpointer vor dem speicherzugriff
						        next_memory_address_source_is_reg = 1'b0;
						    
						        next_memory_write_to_reg = `RF_R4;
						        next_memory_write_to_reg_enable = 1'b1;
						        next_memory_store_data_reg = `RF_NONE;
						    
						        next_memory_load_request = 1'b1;                                       
						        next_memory_store_request = 1'b0;
						    end
						endcase
	                    
	                    next_stall_to_instructionfetch = 1'b1;
	                    next_step = 9'b1_1111_1111;
	                end
	                
	                9'b0_0010_0000 : begin
	                    casez (instruction[11])
						    `F14_PUSH : begin
                                next_alu_opcode = `SUB;                              // subtrahiert bei jedem push 4 vom stackpointer nach dem speicherzugriff
                                next_memory_address_source_is_reg = 1'b1;
						    
						        next_memory_write_to_reg = `RF_NONE;
						        next_memory_write_to_reg_enable = 1'b0;
						        next_memory_store_data_reg = `RF_R5;
						    
						        next_memory_load_request = 1'b0;                                       
						        next_memory_store_request = 1'b1;
						    end
						    `F14_POP : begin
						        next_alu_opcode = `ADD;                              // addiert bei jedem pop 4 zum stackpointer vor dem speicherzugriff
						        next_memory_address_source_is_reg = 1'b0;
						    
						        next_memory_write_to_reg = `RF_R5;
						        next_memory_write_to_reg_enable = 1'b1;
						        next_memory_store_data_reg = `RF_NONE;
						    
						        next_memory_load_request = 1'b1;                                       
						        next_memory_store_request = 1'b0;
						    end
						endcase
	                    
	                    next_stall_to_instructionfetch = 1'b1;
	                    next_step = 9'b1_1111_1111;
	                end
	                
	                9'b0_0100_0000 : begin
	                    casez (instruction[11])
						    `F14_PUSH : begin
                                next_alu_opcode = `SUB;                              // subtrahiert bei jedem push 4 vom stackpointer nach dem speicherzugriff
                                next_memory_address_source_is_reg = 1'b1;
						    
						        next_memory_write_to_reg = `RF_NONE;
						        next_memory_write_to_reg_enable = 1'b0;
						        next_memory_store_data_reg = `RF_R6;
						    
						        next_memory_load_request = 1'b0;                                       
						        next_memory_store_request = 1'b1;
						    end
						    `F14_POP : begin
						        next_alu_opcode = `ADD;                              // addiert bei jedem pop 4 zum stackpointer vor dem speicherzugriff
						        next_memory_address_source_is_reg = 1'b0;
						    
						        next_memory_write_to_reg = `RF_R6;
						        next_memory_write_to_reg_enable = 1'b1;
						        next_memory_store_data_reg = `RF_NONE;
						    
						        next_memory_load_request = 1'b1;                                       
						        next_memory_store_request = 1'b0;
						    end
						endcase
	                    
	                    next_stall_to_instructionfetch = 1'b1;
	                    next_step = 9'b1_1111_1111;
	                end
	                
	                9'b0_1000_0000 : begin
	                    casez (instruction[11])
						    `F14_PUSH : begin
                                next_alu_opcode = `SUB;                              // subtrahiert bei jedem push 4 vom stackpointer nach dem speicherzugriff
                                next_memory_address_source_is_reg = 1'b1;
						    
						        next_memory_write_to_reg = `RF_NONE;
						        next_memory_write_to_reg_enable = 1'b0;
						        next_memory_store_data_reg = `RF_R7;
						    
						        next_memory_load_request = 1'b0;                                       
						        next_memory_store_request = 1'b1;
						    end
						    `F14_POP : begin
						        next_alu_opcode = `ADD;                              // addiert bei jedem pop 4 zum stackpointer vor dem speicherzugriff
						        next_memory_address_source_is_reg = 1'b0;
						    
						        next_memory_write_to_reg = `RF_R7;
						        next_memory_write_to_reg_enable = 1'b1;
						        next_memory_store_data_reg = `RF_NONE;
						    
						        next_memory_load_request = 1'b1;                                       
						        next_memory_store_request = 1'b0;
						    end
						endcase
	                    
	                    next_stall_to_instructionfetch = 1'b1;
	                    next_step = 9'b1_1111_1111;
	                end
	                
                    9'b1_0000_0000 : begin
	                    casez (instruction[11])
						    `F14_PUSH : begin
                                next_alu_opcode = `SUB;                              // subtrahiert bei jedem push 4 vom stackpointer nach dem speicherzugriff
                                next_memory_address_source_is_reg = 1'b1;
						    
						        next_memory_write_to_reg = `RF_NONE;
						        next_memory_write_to_reg_enable = 1'b0;
						        next_memory_store_data_reg = `RF_R14_LR;
						    
						        next_memory_load_request = 1'b0;                                       
						        next_memory_store_request = 1'b1;
						    end
						    `F14_POP : begin
						        next_alu_opcode = `ADD;                              // addiert bei jedem pop 4 zum stackpointer vor dem speicherzugriff
						        next_memory_address_source_is_reg = 1'b0;
						    
						        next_memory_write_to_reg = `RF_R15_PC;
						        next_memory_write_to_reg_enable = 1'b1;
						        next_memory_store_data_reg = `RF_NONE;
						    
						        next_memory_load_request = 1'b1;                                       
						        next_memory_store_request = 1'b0;
						    end
						endcase
	                    
	                    next_stall_to_instructionfetch = 1'b1;
	                    next_step = 9'b1_1111_1111;
	                end
	            
	            
	                // Zwischenschritte 
	                9'b?_????_???1 : begin
	                    casez (instruction[11])
						    `F14_PUSH : begin
                                next_alu_opcode = `SUB;                              // subtrahiert bei jedem push 4 vom stackpointer nach dem speicherzugriff
                                next_memory_address_source_is_reg = 1'b1;
						    
						        next_memory_write_to_reg = `RF_NONE;
						        next_memory_write_to_reg_enable = 1'b0;
						        next_memory_store_data_reg = `RF_R0;
						    
						        next_memory_load_request = 1'b0;                                       
						        next_memory_store_request = 1'b1;
						    end
						    `F14_POP : begin
						        next_alu_opcode = `ADD;                              // addiert bei jedem pop 4 zum stackpointer vor dem speicherzugriff
						        next_memory_address_source_is_reg = 1'b0;
						    
						        next_memory_write_to_reg = `RF_R0;
						        next_memory_write_to_reg_enable = 1'b1;
						        next_memory_store_data_reg = `RF_NONE;
						    
						        next_memory_load_request = 1'b1;                                       
						        next_memory_store_request = 1'b0;
						    end
						endcase
	                    
	                    next_stall_to_instructionfetch = 1'b1;
	                    next_step = 9'b1_1111_1110;
	                end
	                
	                9'b?_????_??10 : begin
	                    casez (instruction[11])
						    `F14_PUSH : begin
                                next_alu_opcode = `SUB;                              // subtrahiert bei jedem push 4 vom stackpointer nach dem speicherzugriff
                                next_memory_address_source_is_reg = 1'b1;
						    
						        next_memory_write_to_reg = `RF_NONE;
						        next_memory_write_to_reg_enable = 1'b0;
						        next_memory_store_data_reg = `RF_R1;
						    
						        next_memory_load_request = 1'b0;                                       
						        next_memory_store_request = 1'b1;
						    end
						    `F14_POP : begin
						        next_alu_opcode = `ADD;                              // addiert bei jedem pop 4 zum stackpointer vor dem speicherzugriff
						        next_memory_address_source_is_reg = 1'b0;
						    
						        next_memory_write_to_reg = `RF_R1;
						        next_memory_write_to_reg_enable = 1'b1;
						        next_memory_store_data_reg = `RF_NONE;
						    
						        next_memory_load_request = 1'b1;                                       
						        next_memory_store_request = 1'b0;
						    end
						endcase
	                    
	                    next_stall_to_instructionfetch = 1'b1;
	                    next_step = 9'b1_1111_1100;
	                end
	                
	                9'b?_????_?100 : begin
	                    casez (instruction[11])
						    `F14_PUSH : begin
                                next_alu_opcode = `SUB;                              // subtrahiert bei jedem push 4 vom stackpointer nach dem speicherzugriff
                                next_memory_address_source_is_reg = 1'b1;
						    
						        next_memory_write_to_reg = `RF_NONE;
						        next_memory_write_to_reg_enable = 1'b0;
						        next_memory_store_data_reg = `RF_R2;
						    
						        next_memory_load_request = 1'b0;                                       
						        next_memory_store_request = 1'b1;
						    end
						    `F14_POP : begin
						        next_alu_opcode = `ADD;                              // addiert bei jedem pop 4 zum stackpointer vor dem speicherzugriff
						        next_memory_address_source_is_reg = 1'b0;
						    
						        next_memory_write_to_reg = `RF_R2;
						        next_memory_write_to_reg_enable = 1'b1;
						        next_memory_store_data_reg = `RF_NONE;
						    
						        next_memory_load_request = 1'b1;                                       
						        next_memory_store_request = 1'b0;
						    end
						endcase
	                    
	                    next_stall_to_instructionfetch = 1'b1;
	                    next_step = 9'b1_1111_1000;
	                end
	                
	                9'b?_????_1000 : begin
	                    casez (instruction[11])
						    `F14_PUSH : begin
                                next_alu_opcode = `SUB;                              // subtrahiert bei jedem push 4 vom stackpointer nach dem speicherzugriff
                                next_memory_address_source_is_reg = 1'b1;
						    
						        next_memory_write_to_reg = `RF_NONE;
						        next_memory_write_to_reg_enable = 1'b0;
						        next_memory_store_data_reg = `RF_R3;
						    
						        next_memory_load_request = 1'b0;                                       
						        next_memory_store_request = 1'b1;
						    end
						    `F14_POP : begin
						        next_alu_opcode = `ADD;                              // addiert bei jedem pop 4 zum stackpointer vor dem speicherzugriff
						        next_memory_address_source_is_reg = 1'b0;
						    
						        next_memory_write_to_reg = `RF_R3;
						        next_memory_write_to_reg_enable = 1'b1;
						        next_memory_store_data_reg = `RF_NONE;
						    
						        next_memory_load_request = 1'b1;                                       
						        next_memory_store_request = 1'b0;
						    end
						endcase
	                    
	                    next_stall_to_instructionfetch = 1'b1;
	                    next_step = 9'b1_1111_0000;
	                end
	                
	                9'b?_???1_0000 : begin
	                    casez (instruction[11])
						    `F14_PUSH : begin
                                next_alu_opcode = `SUB;                              // subtrahiert bei jedem push 4 vom stackpointer nach dem speicherzugriff
                                next_memory_address_source_is_reg = 1'b1;
						    
						        next_memory_write_to_reg = `RF_NONE;
						        next_memory_write_to_reg_enable = 1'b0;
						        next_memory_store_data_reg = `RF_R4;
						    
						        next_memory_load_request = 1'b0;                                       
						        next_memory_store_request = 1'b1;
						    end
						    `F14_POP : begin
						        next_alu_opcode = `ADD;                              // addiert bei jedem pop 4 zum stackpointer vor dem speicherzugriff
						        next_memory_address_source_is_reg = 1'b0;
						    
						        next_memory_write_to_reg = `RF_R4;
						        next_memory_write_to_reg_enable = 1'b1;
						        next_memory_store_data_reg = `RF_NONE;
						    
						        next_memory_load_request = 1'b1;                                       
						        next_memory_store_request = 1'b0;
						    end
						endcase
	                    
	                    next_stall_to_instructionfetch = 1'b1;
	                    next_step = 9'b1_1110_0000;
	                end
	                
	                9'b?_??10_0000 : begin
	                    casez (instruction[11])
						    `F14_PUSH : begin
                                next_alu_opcode = `SUB;                              // subtrahiert bei jedem push 4 vom stackpointer nach dem speicherzugriff
                                next_memory_address_source_is_reg = 1'b1;
						    
						        next_memory_write_to_reg = `RF_NONE;
						        next_memory_write_to_reg_enable = 1'b0;
						        next_memory_store_data_reg = `RF_R5;
						    
						        next_memory_load_request = 1'b0;                                       
						        next_memory_store_request = 1'b1;
						    end
						    `F14_POP : begin
						        next_alu_opcode = `ADD;                              // addiert bei jedem pop 4 zum stackpointer vor dem speicherzugriff
						        next_memory_address_source_is_reg = 1'b0;
						    
						        next_memory_write_to_reg = `RF_R5;
						        next_memory_write_to_reg_enable = 1'b1;
						        next_memory_store_data_reg = `RF_NONE;
						    
						        next_memory_load_request = 1'b1;                                       
						        next_memory_store_request = 1'b0;
						    end
						endcase
	                    
	                    next_stall_to_instructionfetch = 1'b1;
	                    next_step = 9'b1_1100_0000;
	                end
	                
	                9'b?_?100_0000 : begin
	                    casez (instruction[11])
						    `F14_PUSH : begin
                                next_alu_opcode = `SUB;                              // subtrahiert bei jedem push 4 vom stackpointer nach dem speicherzugriff
                                next_memory_address_source_is_reg = 1'b1;
						    
						        next_memory_write_to_reg = `RF_NONE;
						        next_memory_write_to_reg_enable = 1'b0;
						        next_memory_store_data_reg = `RF_R6;
						    
						        next_memory_load_request = 1'b0;                                       
						        next_memory_store_request = 1'b1;
						    end
						    `F14_POP : begin
						        next_alu_opcode = `ADD;                              // addiert bei jedem pop 4 zum stackpointer vor dem speicherzugriff
						        next_memory_address_source_is_reg = 1'b0;
						    
						        next_memory_write_to_reg = `RF_R6;
						        next_memory_write_to_reg_enable = 1'b1;
						        next_memory_store_data_reg = `RF_NONE;
						    
						        next_memory_load_request = 1'b1;                                       
						        next_memory_store_request = 1'b0;
						    end
						endcase
	                    
	                    next_stall_to_instructionfetch = 1'b1;
	                    next_step = 9'b1_1000_0000;
	                end
	                
                    9'b?_1000_0000 : begin
	                    casez (instruction[11])
						    `F14_PUSH : begin
                                next_alu_opcode = `SUB;                              // subtrahiert bei jedem push 4 vom stackpointer nach dem speicherzugriff
                                next_memory_address_source_is_reg = 1'b1;
						    
						        next_memory_write_to_reg = `RF_NONE;
						        next_memory_write_to_reg_enable = 1'b0;
						        next_memory_store_data_reg = `RF_R7;
						    
						        next_memory_load_request = 1'b0;                                       
						        next_memory_store_request = 1'b1;
						    end
						    `F14_POP : begin
						        next_alu_opcode = `ADD;                              // addiert bei jedem pop 4 zum stackpointer vor dem speicherzugriff
						        next_memory_address_source_is_reg = 1'b0;
						    
						        next_memory_write_to_reg = `RF_R7;
						        next_memory_write_to_reg_enable = 1'b1;
						        next_memory_store_data_reg = `RF_NONE;
						    
						        next_memory_load_request = 1'b1;                                       
						        next_memory_store_request = 1'b0;
						    end
						endcase
	                    
	                    next_stall_to_instructionfetch = 1'b1;
	                    next_step = 9'b1_0000_0000;
	                end
	                
	                // sollte nie passieren
	                default: begin
	                    next_alu_opcode = `ORR;
	                    next_memory_address_source_is_reg = 1'b0;
	                
                        next_memory_write_to_reg = `RF_NONE;
						next_memory_write_to_reg_enable = 1'b0;
						next_memory_store_data_reg = `RF_NONE;
						    
						next_memory_load_request = 1'b0;                                       
						next_memory_store_request = 1'b0;
						
						next_stall_to_instructionfetch = 1'b1;
	                    next_step = 9'b1_1111_1111;
	                end
	                
	            endcase
	            
	        end
	        
	        `FORMAT_15  : begin                                   
	            next_operand_a = {2'b00, instruction[10:8]};
	            next_operand_b = `RF_IMM;
	            
	            next_offset_a = `IMM_ZERO;
	            next_offset_b = 32'b0000_0000_0000_0000_0000_0000_0000_0010;
	
	            next_alu_opcode = `ADD;                              // addiert bei jedem load/store 4 zum Base-Register   
	            
	            next_pc_mask_bit = 1'b0;
	            
	            next_update_flag_n = 1'b0;
	            next_update_flag_z = 1'b0;
	            next_update_flag_c = 1'b0;
	            next_update_flag_v = 1'b0;
	            
	            next_alu_stack_write_to_reg = {2'b00, instruction[10:8]};                                                   
	            next_alu_stack_write_to_reg_enable = 1'b1;
	            
	            next_memory_store_address_reg = {2'b00, instruction[10:8]};
	            next_memory_address_source_is_reg = 1'b1;
	            
	            next_load_store_width = `WORD;
	            next_memorycontroller_sign_extend = 1'b0;
	            
	            next_stack_push_request = 1'b0;
	            next_stack_pop_request = 1'b0;

	            next_stall_to_instructionfetch       = 0; // added for: no latch
	            next_step                            = 9'b1_1111_1111; // added for: no latch
	                        
	            // Instruktionssplit
	            
	            casez (next_step & {1'b1, instruction[7:0]})
	            
	                // Endf채lle 
	                9'b1_0000_0001 : begin
	                    casez (instruction[11])
						    `F15_STORE : begin
						        next_memory_write_to_reg = `RF_NONE;
						        next_memory_write_to_reg_enable = 1'b0;
						        next_memory_store_data_reg = `RF_R0;
						    
						        next_memory_load_request = 1'b0;                                       
						        next_memory_store_request = 1'b1;
						    end
						    `F15_LOAD : begin
						        next_memory_write_to_reg = `RF_R0;
						        next_memory_write_to_reg_enable = 1'b1;
						        next_memory_store_data_reg = `RF_NONE;
						    
						        next_memory_load_request = 1'b1;                                       
						        next_memory_store_request = 1'b0;
						    end
						endcase
	                    
	                    next_stall_to_instructionfetch = 1'b1;
	                    next_step = 9'b1_1111_1111;
	                end
	                
	                9'b1_0000_0010 : begin
	                    casez (instruction[11])
						    `F15_STORE : begin
						        next_memory_write_to_reg = `RF_NONE;
						        next_memory_write_to_reg_enable = 1'b0;
						        next_memory_store_data_reg = `RF_R1;
						    
						        next_memory_load_request = 1'b0;                                       
						        next_memory_store_request = 1'b1;
						    end
						    `F15_LOAD : begin
						        next_memory_write_to_reg = `RF_R1;
						        next_memory_write_to_reg_enable = 1'b1;
						        next_memory_store_data_reg = `RF_NONE;
						    
						        next_memory_load_request = 1'b1;                                       
						        next_memory_store_request = 1'b0;
						    end
						endcase
	                    
	                    next_stall_to_instructionfetch = 1'b1;
	                    next_step = 9'b1_1111_1111;
	                end
	                
	                9'b1_0000_0100 : begin
	                    casez (instruction[11])
						    `F15_STORE : begin
						        next_memory_write_to_reg = `RF_NONE;
						        next_memory_write_to_reg_enable = 1'b0;
						        next_memory_store_data_reg = `RF_R2;
						    
						        next_memory_load_request = 1'b0;                                       
						        next_memory_store_request = 1'b1;
						    end
						    `F15_LOAD : begin
						        next_memory_write_to_reg = `RF_R2;
						        next_memory_write_to_reg_enable = 1'b1;
						        next_memory_store_data_reg = `RF_NONE;
						    
						        next_memory_load_request = 1'b1;                                       
						        next_memory_store_request = 1'b0;
						    end
						endcase
	                    
	                    next_stall_to_instructionfetch = 1'b1;
	                    next_step = 9'b1_1111_1111;
	                end
	                
	                9'b1_0000_1000 : begin
	                    casez (instruction[11])
						    `F15_STORE : begin
						        next_memory_write_to_reg = `RF_NONE;
						        next_memory_write_to_reg_enable = 1'b0;
						        next_memory_store_data_reg = `RF_R3;
						    
						        next_memory_load_request = 1'b0;                                       
						        next_memory_store_request = 1'b1;
						    end
						    `F15_LOAD : begin
						        next_memory_write_to_reg = `RF_R3;
						        next_memory_write_to_reg_enable = 1'b1;
						        next_memory_store_data_reg = `RF_NONE;
						    
						        next_memory_load_request = 1'b1;                                       
						        next_memory_store_request = 1'b0;
						    end
						endcase
	                    
	                    next_stall_to_instructionfetch = 1'b1;
	                    next_step = 9'b1_1111_1111;
	                end
	                
	                9'b1_0001_0000 : begin
	                    casez (instruction[11])
						    `F15_STORE : begin
						        next_memory_write_to_reg = `RF_NONE;
						        next_memory_write_to_reg_enable = 1'b0;
						        next_memory_store_data_reg = `RF_R4;
						    
						        next_memory_load_request = 1'b0;                                       
						        next_memory_store_request = 1'b1;
						    end
						    `F15_LOAD : begin
						        next_memory_write_to_reg = `RF_R4;
						        next_memory_write_to_reg_enable = 1'b1;
						        next_memory_store_data_reg = `RF_NONE;
						    
						        next_memory_load_request = 1'b1;                                       
						        next_memory_store_request = 1'b0;
						    end
						endcase
	                    
	                    next_stall_to_instructionfetch = 1'b1;
	                    next_step = 9'b1_1111_1111;
	                end
	                
	                9'b1_0010_0000 : begin
	                    casez (instruction[11])
						    `F15_STORE : begin
						        next_memory_write_to_reg = `RF_NONE;
						        next_memory_write_to_reg_enable = 1'b0;
						        next_memory_store_data_reg = `RF_R5;
						    
						        next_memory_load_request = 1'b0;                                       
						        next_memory_store_request = 1'b1;
						    end
						    `F15_LOAD : begin
						        next_memory_write_to_reg = `RF_R5;
						        next_memory_write_to_reg_enable = 1'b1;
						        next_memory_store_data_reg = `RF_NONE;
						    
						        next_memory_load_request = 1'b1;                                       
						        next_memory_store_request = 1'b0;
						    end
						endcase
	                    
	                    next_stall_to_instructionfetch = 1'b1;
	                    next_step = 9'b1_1111_1111;
	                end
	                
	                9'b1_0100_0000 : begin
	                    casez (instruction[11])
						    `F15_STORE : begin
						        next_memory_write_to_reg = `RF_NONE;
						        next_memory_write_to_reg_enable = 1'b0;
						        next_memory_store_data_reg = `RF_R6;
						    
						        next_memory_load_request = 1'b0;                                       
						        next_memory_store_request = 1'b1;
						    end
						    `F15_LOAD : begin
						        next_memory_write_to_reg = `RF_R6;
						        next_memory_write_to_reg_enable = 1'b1;
						        next_memory_store_data_reg = `RF_NONE;
						    
						        next_memory_load_request = 1'b1;                                       
						        next_memory_store_request = 1'b1;
						    end
						endcase
	                    
	                    next_stall_to_instructionfetch = 1'b1;
	                    next_step = 9'b1_1111_1111;
	                end
	                
	                9'b1_1000_0000 : begin
	                    casez (instruction[11])
						    `F15_STORE : begin
						        next_memory_write_to_reg = `RF_NONE;
						        next_memory_write_to_reg_enable = 1'b0;
						        next_memory_store_data_reg = `RF_R7;
						    
						        next_memory_load_request = 1'b0;                                       
						        next_memory_store_request = 1'b1;
						    end
						    `F15_LOAD : begin
						        next_memory_write_to_reg = `RF_R7;
						        next_memory_write_to_reg_enable = 1'b1;
						        next_memory_store_data_reg = `RF_NONE;
						    
						        next_memory_load_request = 1'b1;                                       
						        next_memory_store_request = 1'b1;
						    end
						endcase
	                    
	                    next_stall_to_instructionfetch = 1'b1;
	                    next_step = 9'b1_1111_1111;
	                end
	            
	            
	                // Zwischenschritte 
	                9'b1_????_???1 : begin
	                    casez (instruction[11])
						    `F15_STORE : begin
						        next_memory_write_to_reg = `RF_NONE;
						        next_memory_write_to_reg_enable = 1'b0;
						        next_memory_store_data_reg = `RF_R0;
						    
						        next_memory_load_request = 1'b0;                                       
						        next_memory_store_request = 1'b1;
						    end
						    `F15_LOAD : begin
						        next_memory_write_to_reg = `RF_R0;
						        next_memory_write_to_reg_enable = 1'b1;
						        next_memory_store_data_reg = `RF_NONE;
						    
						        next_memory_load_request = 1'b1;                                       
						        next_memory_store_request = 1'b1;
						    end
						endcase
	                    
	                    next_stall_to_instructionfetch = 1'b1;
	                    next_step = 9'b1_1111_1110;
	                end
	                
	                9'b1_????_??10 : begin
	                    casez (instruction[11])
						    `F15_STORE : begin
						        next_memory_write_to_reg = `RF_NONE;
						        next_memory_write_to_reg_enable = 1'b0;
						        next_memory_store_data_reg = `RF_R1;
						    
						        next_memory_load_request = 1'b0;                                       
						        next_memory_store_request = 1'b1;
						    end
						    `F15_LOAD : begin
						        next_memory_write_to_reg = `RF_R1;
						        next_memory_write_to_reg_enable = 1'b1;
						        next_memory_store_data_reg = `RF_NONE;
						    
						        next_memory_load_request = 1'b1;                                       
						        next_memory_store_request = 1'b1;
						    end
						endcase
	                    
	                    next_stall_to_instructionfetch = 1'b1;
	                    next_step = 9'b1_1111_1100;
	                end
	                
	                9'b1_????_?100 : begin
	                    casez (instruction[11])
						    `F15_STORE : begin
						        next_memory_write_to_reg = `RF_NONE;
						        next_memory_write_to_reg_enable = 1'b0;
						        next_memory_store_data_reg = `RF_R2;
						    
						        next_memory_load_request = 1'b0;                                       
						        next_memory_store_request = 1'b1;
						    end
						    `F15_LOAD : begin
						        next_memory_write_to_reg = `RF_R2;
						        next_memory_write_to_reg_enable = 1'b1;
						        next_memory_store_data_reg = `RF_NONE;
						    
						        next_memory_load_request = 1'b1;                                       
						        next_memory_store_request = 1'b1;
						    end
						endcase
	                    
	                    next_stall_to_instructionfetch = 1'b1;
	                    next_step = 9'b1_1111_1000;
	                end
	                
	                9'b1_????_1000 : begin
	                    casez (instruction[11])
						    `F15_STORE : begin
						        next_memory_write_to_reg = `RF_NONE;
						        next_memory_write_to_reg_enable = 1'b0;
						        next_memory_store_data_reg = `RF_R3;
						    
						        next_memory_load_request = 1'b0;                                       
						        next_memory_store_request = 1'b1;
						    end
						    `F15_LOAD : begin
						        next_memory_write_to_reg = `RF_R3;
						        next_memory_write_to_reg_enable = 1'b1;
						        next_memory_store_data_reg = `RF_NONE;
						    
						        next_memory_load_request = 1'b1;                                       
						        next_memory_store_request = 1'b1;
						    end
						endcase
	                    
	                    next_stall_to_instructionfetch = 1'b1;
	                    next_step = 9'b1_1111_0000;
	                end
	                
	                9'b1_???1_0000 : begin
	                    casez (instruction[11])
						    `F15_STORE : begin
						        next_memory_write_to_reg = `RF_NONE;
						        next_memory_write_to_reg_enable = 1'b0;
						        next_memory_store_data_reg = `RF_R4;
						    
						        next_memory_load_request = 1'b0;                                       
						        next_memory_store_request = 1'b1;
						    end
						    `F15_LOAD : begin
						        next_memory_write_to_reg = `RF_R4;
						        next_memory_write_to_reg_enable = 1'b1;
						        next_memory_store_data_reg = `RF_NONE;
						    
						        next_memory_load_request = 1'b1;                                       
						        next_memory_store_request = 1'b1;
						    end
						endcase
	                    
	                    next_stall_to_instructionfetch = 1'b1;
	                    next_step = 9'b1_1110_0000;
	                end
	                
	                9'b1_??10_0000 : begin
	                    casez (instruction[11])
						    `F15_STORE : begin
						        next_memory_write_to_reg = `RF_NONE;
						        next_memory_write_to_reg_enable = 1'b0;
						        next_memory_store_data_reg = `RF_R5;
						    
						        next_memory_load_request = 1'b0;                                       
						        next_memory_store_request = 1'b1;
						    end
						    `F15_LOAD : begin
						        next_memory_write_to_reg = `RF_R5;
						        next_memory_write_to_reg_enable = 1'b1;
						        next_memory_store_data_reg = `RF_NONE;
						    
						        next_memory_load_request = 1'b1;                                       
						        next_memory_store_request = 1'b1;
						    end
						endcase
	                    
	                    next_stall_to_instructionfetch = 1'b1;
	                    next_step = 9'b1_1100_0000;
	                end
	                
	                9'b1_?100_0000 : begin
	                    casez (instruction[11])
						    `F15_STORE : begin
						        next_memory_write_to_reg = `RF_NONE;
						        next_memory_write_to_reg_enable = 1'b0;
						        next_memory_store_data_reg = `RF_R6;
						    
						        next_memory_load_request = 1'b0;                                       
						        next_memory_store_request = 1'b1;
						    end
						    `F15_LOAD : begin
						        next_memory_write_to_reg = `RF_R6;
						        next_memory_write_to_reg_enable = 1'b1;
						        next_memory_store_data_reg = `RF_NONE;
						    
						        next_memory_load_request = 1'b1;                                       
						        next_memory_store_request = 1'b1;
						    end
						endcase
	                    
	                    next_stall_to_instructionfetch = 1'b1;
	                    next_step = 9'b1_1000_0000;
	                end
	                
	                // sollte nie passieren
	                default: begin                
                        next_memory_write_to_reg = `RF_NONE;
						next_memory_write_to_reg_enable = 1'b0;
						next_memory_store_data_reg = `RF_NONE;
						    
						next_memory_load_request = 1'b0;                                       
						next_memory_store_request = 1'b0;
						
						next_stall_to_instructionfetch = 1'b1;
	                    next_step = 9'b1_1111_1111;
	                end
	                
	            endcase
	            
	        end
	        
	        `FORMAT_16_17  : begin                                
	            next_operand_a = `RF_R15_PC;
	            next_operand_b = `RF_IMM;
	            
	            next_offset_a = `IMM_ZERO;
	            
	            // immediate is signed for format 16 and 17
	            next_offset_b = instruction[7] ?  {23'b1111_1111_1111_1111_1111_111, instruction[7:0], 1'b0} : {23'b0000_0000_0000_0000_0000_0, instruction[7:0], 1'b0};
	            
	            next_alu_opcode  = `ADD;
	            
	            next_pc_mask_bit = 1'b0;
	            
	            next_update_flag_n = 1'b0;
	            next_update_flag_z = 1'b0;
	            next_update_flag_c = 1'b0;
	            next_update_flag_v = 1'b0;
	            
	            next_alu_stack_write_to_reg = `RF_R15_PC;
	            next_memory_write_to_reg = `RF_NONE;
	            next_memory_write_to_reg_enable = 1'b0;
	            
	            next_memory_store_data_reg = `RF_NONE;
	            next_memory_store_address_reg = `RF_NONE;
	            next_memory_address_source_is_reg = 1'b0;
	            next_load_store_width = `WORD;
	            next_memorycontroller_sign_extend = 1'b0;
	
	            next_memory_load_request = 1'b0;
	            next_memory_store_request = 1'b0;
	            
	            next_stack_push_request = 1'b0;
	            next_stack_pop_request = 1'b0;
	            
	            next_stall_to_instructionfetch       = 1;
	            next_step                            = 9'b1_1111_1111;
	            
	            casez (instruction[11:8])
	//                 `F16_BEQ     : next_alu_stack_write_to_reg_enable = flag_z ?  1'b1 :  1'b0;
	//                 `F16_BNE     : next_alu_stack_write_to_reg_enable = flag_z ?  1'b0 :  1'b1; 
	//                 `F16_BCS     : next_alu_stack_write_to_reg_enable = flag_c ?  1'b1 :  1'b0; 
	//                 `F16_BCC     : next_alu_stack_write_to_reg_enable = flag_c ?  1'b0 :  1'b1; 
	//                 `F16_BMI     : next_alu_stack_write_to_reg_enable = flag_n ?  1'b1 :  1'b0; 
	//                 `F16_BPL     : next_alu_stack_write_to_reg_enable = flag_n ?  1'b0 :  1'b1; 
	//                 `F16_BVS     : next_alu_stack_write_to_reg_enable = flag_v ?  1'b1 :  1'b0; 
	//                 `F16_BVC     : next_alu_stack_write_to_reg_enable = flag_v ?  1'b0 :  1'b1; 
	//                 `F16_BHI     : next_alu_stack_write_to_reg_enable = (flag_c & !flag_z) ?  1'b1 :  1'b0;
	//                 `F16_BLS     : next_alu_stack_write_to_reg_enable = (!flag_c | flag_z) ?  1'b1 :  1'b0; 
	//                 `F16_BGE     : next_alu_stack_write_to_reg_enable = ((flag_n & flag_v) | (!flag_n & !flag_v)) ?  1'b1 :  1'b0;
	//                 `F16_BLT     : next_alu_stack_write_to_reg_enable = ((flag_n & !flag_v) | (!flag_n & flag_v)) ?  1'b1 :  1'b0;
	//                 `F16_BGT     : next_alu_stack_write_to_reg_enable = (!flag_z & ((flag_n & flag_v) | (!flag_n & !flag_v)) ) ?  1'b1 :  1'b0;       
	//                 `F16_BLE     : next_alu_stack_write_to_reg_enable = (flag_z | ((flag_n & !flag_v) | (!flag_n & flag_v)) ) ?  1'b1 :  1'b0;   
	//                 `F16_ILLEGAL : next_alu_stack_write_to_reg_enable = 1'b0;  // sollte nie passieren
	//                 `F17_SWI     : next_alu_stack_write_to_reg_enable = 1'b0;  // sollte nie passieren, nicht implementiert
	
	                `F16_ILLEGAL : next_alu_stack_write_to_reg_enable = 1'b0;  // sollte nie passieren
	                `F17_SWI     : next_alu_stack_write_to_reg_enable = 1'b0;  // sollte nie passieren, nicht implementiert
	                
	                default : next_alu_stack_write_to_reg_enable = f_flageval(instruction[11:8], flag_z, flag_c, flag_n, flag_v);
	                
	            endcase
	            
	
	
	        end
	        
	        `FORMAT_18  : begin                                
	            next_operand_a = `RF_R15_PC;
	            next_operand_b = `RF_IMM;
	            
	            next_offset_a = `IMM_ZERO;
	            next_offset_b = {20'b0000_0000_0000_0000_0000, instruction[10:0], 1'b0};
	            
	            next_alu_opcode  = `ADD;
	            
	            next_pc_mask_bit = 1'b0;
	            
	            next_update_flag_n = 1'b0;
	            next_update_flag_z = 1'b0;
	            next_update_flag_c = 1'b0;
	            next_update_flag_v = 1'b0;
	            
	            next_alu_stack_write_to_reg = `RF_R15_PC;
	            next_alu_stack_write_to_reg_enable = 1'b1;
	            next_memory_write_to_reg = `RF_NONE;
	            next_memory_write_to_reg_enable = 1'b0;
	            
	            next_memory_store_data_reg = `RF_NONE;
	            next_memory_store_address_reg = `RF_NONE;
	            next_memory_address_source_is_reg = 1'b0;
	            next_load_store_width = `WORD;
	            next_memorycontroller_sign_extend = 1'b0;
	            
	            next_stack_push_request = 1'b0;
	            next_stack_pop_request = 1'b0;
	
	            next_memory_load_request = 1'b0;
	            next_memory_store_request = 1'b0;
	            
	            next_stall_to_instructionfetch       = 1;
	            next_step                            = 9'b1_1111_1111;
	        
	        end
	        
	        `FORMAT_19  : begin   
	            next_operand_a = �`RF_NONE; // added for: no latch                      
	            next_operand_b = `RF_IMM;
	            
	            next_offset_a = `IMM_ZERO;
		    next_offset_b = 32'b0; // added for: no latch

		    next_alu_opcode = `ORR; // added for: no latch
	            
	            next_pc_mask_bit = 1'b0;
	            
	            next_update_flag_n = 1'b0;
	            next_update_flag_z = 1'b0;
	            next_update_flag_c = 1'b0;
	            next_update_flag_v = 1'b0;
	            
	            next_alu_stack_write_to_reg = 5'b0; // added for: no latch
	            next_alu_stack_write_to_reg_enable = 1'b1;
	            next_memory_write_to_reg = `RF_NONE;
	            next_memory_write_to_reg_enable = 1'b0;
	            
	            next_memory_store_data_reg = `RF_NONE;
	            next_memory_store_address_reg = `RF_NONE;
	            next_memory_address_source_is_reg = 1'b0;
	            next_load_store_width = `WORD;
	            next_memorycontroller_sign_extend = 1'b0;
	            
	            next_memory_load_request = 1'b0;                                       
	            next_memory_store_request = 1'b0;
	            
	            next_stack_push_request = 1'b0;
	            next_stack_pop_request = 1'b0;

	            next_stall_to_instructionfetch       = 0; // added for: no latch
	            next_step                            = 9'b1_1111_1111; // added for: no latch
	            
	            casez (instruction[11])
	                `F19_HIGH : begin
	                    next_operand_a = `RF_R15_PC;
	                    
	                    next_offset_b = {9'b0000_0000_0, instruction[10:0], 12'b0000_0000_0000};
	                    
	                    next_alu_opcode = `ADD;
	                    
	                    next_alu_stack_write_to_reg = `RF_R14_LR;
	                    
	                    next_stall_to_instructionfetch = 0;
	                    
	                    next_step = 9'b1_1111_1111;
	                end
	                `F19_LOW : begin
	                
	                    casez (next_step)
	                    
	                        9'b?_????_???1 : begin
	                            next_operand_a = `RF_R15_PC;
	                            
	                            next_offset_b = {32'b0000_0000_0000_0000_0000_0000_0000_0010};
	                            
	                            next_alu_opcode = `SUB;
	                            
	                            next_alu_stack_write_to_reg = `RF_TMP1;
	                            
	                            next_stall_to_instructionfetch = 1'b1;
	                            
	                            next_step = 9'b1_1111_1110;
	                        end
	                        
	                        9'b?_????_??10 : begin
	                            next_operand_a = `RF_R14_LR;
	                            
	                            next_offset_b = {20'b0000_0000_0000_0000_0000, instruction[10:0], 1'b0};
	                            
	                            next_alu_opcode = `ADD;
	                            
	                            next_alu_stack_write_to_reg = `RF_R15_PC;
	                            
	                            next_stall_to_instructionfetch = 1'b1;
	                            
	                            next_step = 9'b1_1111_1100;
	                        end
	                        
	                        9'b?_????_?100 : begin
	                            next_operand_a = `RF_TMP1;
	                            
	                            next_offset_b = {32'b0000_0000_0000_0000_0000_0000_0000_0001};
	
	                            next_alu_opcode = `ORR;
	                            
	                            next_alu_stack_write_to_reg = `RF_R14_LR;
	                            
	                            next_stall_to_instructionfetch = 1'b1;
	                            
	                            next_step = 9'b1_1111_1111;
	                        end
	                    endcase
	                    
	                end
	            endcase
	            
	        end
	        
	        `FORMAT_20  : begin                               
                // IT-Instruction oder NOP
                //
                // Wert체bernahme in Extrablock, also nichts machen
                //
                //
	            next_operand_a = `RF_NONE;
	            next_operand_b = `RF_NONE;
	            
	            // siehe Beispiel mit den 844 = 211 (844 / 4) im Opcode wegen 
	            // wegen immediate = word8, Linksshift von next_offset_b um 2 
	            
	            next_offset_a = `IMM_ZERO;
	            next_offset_b = `IMM_ZERO;
	            
	            next_alu_opcode = `ORR;
	            
	            next_pc_mask_bit = 1'b0;
	            
	            next_update_flag_n = 1'b0;
	            next_update_flag_z = 1'b0;
	            next_update_flag_c = 1'b0;
	            next_update_flag_v = 1'b0;
	            
	            next_alu_stack_write_to_reg = `RF_NONE;
	            next_alu_stack_write_to_reg_enable = 1'b0;
	            
	            next_memory_write_to_reg = `RF_NONE;
	            next_memory_write_to_reg_enable = 1'b0;
	
	            next_memory_store_data_reg = `RF_NONE;
	            next_memory_store_address_reg = `RF_NONE;
	            next_memory_address_source_is_reg = 1'b0;
	            next_load_store_width = `WORD;
	            next_memorycontroller_sign_extend = 1'b0;
	            
	            next_memory_load_request = 1'b0;                                       
	            next_memory_store_request = 1'b0;
	             
	            next_stack_push_request = 1'b0;
	            next_stack_pop_request = 1'b0;
	            
	            next_stall_to_instructionfetch       = 0;
	
	            next_step                            = 9'b1_1111_1111;	            
	        end
	        
	        
	     
	        default : begin                          // auf neue instruktion warten, stall beenden
	                                
				next_operand_a                       = `RF_NONE;
				next_operand_b                       = `RF_NONE;
				                                
				next_offset_a                        = `IMM_ZERO;
				next_offset_b                        = `IMM_ZERO;
				                                
				next_alu_opcode                      = `ORR;
				
				next_pc_mask_bit                     = 1'b0;
				                                
				next_update_flag_n                   = 0;
				next_update_flag_z                   = 0;
				next_update_flag_c                   = 0;
				next_update_flag_v                   = 0;
				                                
				next_alu_stack_write_to_reg                = `RF_NONE;
				next_alu_stack_write_to_reg_enable         = 0;
				next_memory_write_to_reg             = `RF_NONE;
				next_memory_write_to_reg_enable      = 0;
				                                
				next_memory_store_data_reg                = `RF_NONE;
				next_memory_store_address_reg = `RF_NONE;
	            next_memory_address_source_is_reg = 1'b0;
				next_load_store_width                = `WORD;
				next_memorycontroller_sign_extend    = 0;
				                                
				next_memory_load_request                    = 0;
				next_memory_store_request                   = 0;
				
	            next_stack_push_request = 1'b0;
	            next_stack_pop_request = 1'b0;
				                                
				next_stall_to_instructionfetch       = 0;
	
				next_step                            = 9'b1_1111_1111;
	        
	        end
		endcase
	
	
	end // if-block ITSTATE
	
	else begin // else-block ITSTATE (Instruktion nicht ausf체hren)
	
    // synthesis translate off
        next_exec_cond_true = 1'b0;
    // synthesis translate on
	
	// nichts machen
	                                
				next_operand_a                       = `RF_NONE;
				next_operand_b                       = `RF_NONE;
				                                
				next_offset_a                        = `IMM_ZERO;
				next_offset_b                        = `IMM_ZERO;
				                                
				next_alu_opcode                      = `ORR;
				
				next_pc_mask_bit                     = 1'b0;
				                                
				next_update_flag_n                   = 0;
				next_update_flag_z                   = 0;
				next_update_flag_c                   = 0;
				next_update_flag_v                   = 0;
				                                
				next_alu_stack_write_to_reg                = `RF_NONE;
				next_alu_stack_write_to_reg_enable         = 0;
				next_memory_write_to_reg             = `RF_NONE;
				next_memory_write_to_reg_enable      = 0;
				                                
				next_memory_store_data_reg                = `RF_NONE;
				next_memory_store_address_reg = `RF_NONE;
	            next_memory_address_source_is_reg = 1'b0;
				next_load_store_width                = `WORD;
				next_memorycontroller_sign_extend    = 0;
				                                
				next_memory_load_request                    = 0;
				next_memory_store_request                   = 0;
				
	            next_stack_push_request = 1'b0;
	            next_stack_pop_request = 1'b0;
				                                
				next_stall_to_instructionfetch       = 1;
	
				next_step                            = 9'b1_1111_1111;
	        
	
	end // else-block ITSTATE (Instruktion nicht ausf체hren)

end //if-block no_stall or reset

else if ( // else-if-block memstall
        (
        //!stall_from_controller | 
         (next_memory_store_request & !memory_write_finished)  | 
         (next_memory_load_request & !memory_read_finished) )  & 
         !reset) begin 

    // Memory-Operation aktiv, aber noch nicht abgeschlossen
    // alu_write_enables & stack_requests auf 0 setzen

	next_operand_a                       = operand_a;
	next_operand_b                       = operand_b;
	                                
	next_offset_a                        = offset_a;
	next_offset_b                        = offset_b;
	                                
	next_alu_opcode                      = alu_opcode;
	
	next_pc_mask_bit                     = pc_mask_bit;
	                                
	next_update_flag_n                   = 1'b0;
	next_update_flag_z                   = 1'b0;
	next_update_flag_c                   = 1'b0;
	next_update_flag_v                   = 1'b0;
	                                
	next_alu_stack_write_to_reg          = alu_stack_write_to_reg;
	next_alu_stack_write_to_reg_enable   = 1'b0;
	next_memory_write_to_reg             = memory_write_to_reg;
	next_memory_write_to_reg_enable      = memory_write_to_reg_enable;
	                                
	next_memory_store_data_reg           = memory_store_data_reg;
	next_memory_store_address_reg        = memory_store_address_reg;
	next_memory_address_source_is_reg    = memory_address_source_is_reg;
	next_load_store_width                = load_store_width;
	next_memorycontroller_sign_extend    = memorycontroller_sign_extend;
	                                
	next_memory_load_request             = memory_load_request;
	next_memory_store_request            = memory_store_request;
	
	next_stack_push_request              = 1'b0;
	next_stack_pop_request               = 1'b0;
	                                
	next_stall_to_instructionfetch       = stall_to_instructionfetch;
	
	next_step                            = step;
	
	// synthesis translate off
        exec_cond_true = exec_cond_true;
    // synthesis translate on

end // else-if-block memstall

// else if ( // else-if-block memstall Ende
//         (
//          (memory_write_finished)  | 
//          (memory_read_finished) )  & 
//          !reset) begin 
// 
//     // Memory-Operation aktiv, aber noch nicht abgeschlossen
//     // alu_write_enables & stack_requests auf 0 setzen
// 
// 	next_operand_a                       = operand_a;
// 	next_operand_b                       = operand_b;
// 	                                
// 	next_offset_a                        = offset_a;
// 	next_offset_b                        = offset_b;
// 	                                
// 	next_alu_opcode                      = alu_opcode;
// 	                                
// 	next_update_flag_n                   = 1'b0;
// 	next_update_flag_z                   = 1'b0;
// 	next_update_flag_c                   = 1'b0;
// 	next_update_flag_v                   = 1'b0;
// 	                                
// 	next_alu_stack_write_to_reg          = alu_stack_write_to_reg;
// 	next_alu_stack_write_to_reg_enable   = 1'b0;
// 	next_memory_write_to_reg             = memory_write_to_reg;
// 	next_memory_write_to_reg_enable      = memory_write_to_reg_enable;
// 	                                
// 	next_memory_store_data_reg           = memory_store_data_reg;
// 	next_memory_store_address_reg        = memory_store_address_reg;
// 	next_memory_address_source_is_reg    = memory_address_source_is_reg;
// 	next_load_store_width                = load_store_width;
// 	next_memorycontroller_sign_extend    = memorycontroller_sign_extend;
// 	                                
// 	next_memory_load_request             = memory_load_request;
// 	next_memory_store_request            = memory_store_request;
// 	
// 	next_stack_push_request              = 1'b0;
// 	next_stack_pop_request               = 1'b0;
// 	                                
// 	next_stall_to_instructionfetch       = stall_to_instructionfetch;
// 	
// 	next_step                            = step;
// 	
// 	// synthesis translate off
//         exec_cond_true = exec_cond_true;
//     // synthesis translate on
// 
// end // else-if-block memstall ENDE

else if (reset) begin  // else if-Block reset

			next_operand_a                       = `RF_NONE;
			next_operand_b                       = `RF_NONE;
			                                
			next_offset_a                        = `IMM_ZERO;
			next_offset_b                        = `IMM_ZERO;
			                                
			next_alu_opcode                      = `ORR;
			
			next_pc_mask_bit                     = 1'b0;
			                                
			next_update_flag_n                   = 0;
			next_update_flag_z                   = 0;
			next_update_flag_c                   = 0;
			next_update_flag_v                   = 0;
			                                
			next_alu_stack_write_to_reg                = `RF_NONE;
			next_alu_stack_write_to_reg_enable         = 0;
			next_memory_write_to_reg             = `RF_NONE;
			next_memory_write_to_reg_enable      = 0;
			                                
			next_memory_store_data_reg                = `RF_NONE;
			next_memory_store_address_reg = `RF_NONE;
            next_memory_address_source_is_reg = 1'b0;
			next_load_store_width                = `WORD;
			next_memorycontroller_sign_extend    = 0;
			                                
			next_memory_load_request                    = 0;
			next_memory_store_request                   = 0;
			
            next_stack_push_request = 1'b0;
            next_stack_pop_request = 1'b0;
			                                
			next_stall_to_instructionfetch       = 0;
			                                
			next_step                            = 9'b1_1111_1111;
			
        // synthesis translate off
            exec_cond_true = 1'b0;
        // synthesis translate on

end // else if-Block reset

else begin // else-block auf neue Instruktion warten
         
         // nichts tun

			next_operand_a                       = `RF_NONE;
			next_operand_b                       = `RF_NONE;
			                                
			next_offset_a                        = `IMM_ZERO;
			next_offset_b                        = `IMM_ZERO;
			                                
			next_alu_opcode                      = `ORR;
			
			next_pc_mask_bit                     = 1'b0;
			                                
			next_update_flag_n                   = 0;
			next_update_flag_z                   = 0;
			next_update_flag_c                   = 0;
			next_update_flag_v                   = 0;
			                                
			next_alu_stack_write_to_reg                = `RF_NONE;
			next_alu_stack_write_to_reg_enable         = 0;
			next_memory_write_to_reg             = `RF_NONE;
			next_memory_write_to_reg_enable      = 0;
			                                
			next_memory_store_data_reg                = `RF_NONE;
			next_memory_store_address_reg = `RF_NONE;
            next_memory_address_source_is_reg = 1'b0;
			next_load_store_width                = `WORD;
			next_memorycontroller_sign_extend    = 0;
			                                
			next_memory_load_request                    = 0;
			next_memory_store_request                   = 0;
			
            next_stack_push_request = 1'b0;
            next_stack_pop_request = 1'b0;
			                                
			next_stall_to_instructionfetch       = 0;
			                                
			next_step                            = 9'b1_1111_1111;
			
        // synthesis translate off
            exec_cond_true = 1'b0;
        // synthesis translate on

end // else-block auf neue Instruktion warten


end // always-Block

/*

// Hier wird zum Debuggen ein String erzeugt in dem
// der aktuelle Befehl mit seiner Adresse und seinen
// Operanden steht
// synopsys translate_off
always @(*)
	if (trap)
		$sformat(instruction, "0x%05H  Trap      !!!", pc);
	else
	if (intr)
		$sformat(instruction, "0x%05H  Interrupt !!!", pc);
	else
	if (exc_trap_exec)
		$sformat(instruction, "0x%05H  Trap Exception !!!", pc);
	else
	casex ({ir[17:16], ir[15:13], ir[4:3], ir[2:0]})
		`J	: $sformat(instruction, "0x%05H  J       %5h       ", 	pc, pc+next_offset_a);
		`JALS	: $sformat(instruction, "0x%05H  JALS    %5h       ", 	pc, pc+next_offset_a);
		`JR	: $sformat(instruction, "0x%05H  JR      r%2d         ", 	pc, r_no_b);
		`JALR	: $sformat(instruction, "0x%05H  JALR    r%2d         ", 	pc, r_no_b);
		`JRS	: $sformat(instruction, "0x%05H  JRS     r%2d         ", 	pc, r_no_b);
		`RFE	: $sformat(instruction, "0x%05H  RFE     r%2d         ", 	pc, r_no_b);
		`JALRS	: $sformat(instruction, "0x%05H  JALRS   r%2d         ", 	pc, r_no_b);

		`BEQZ	: $sformat(instruction, "0x%05H  BEQZ    r%2d, %h  ", 	pc, r_no_a, pc+imm);
		`BNEZ	: $sformat(instruction, "0x%05H  BNEZ    r%2d, %h  ", 	pc, r_no_a, pc+imm);
		`BEQZC	: $sformat(instruction, "0x%05H  BEQZC   %5h       ",	pc, pc+next_offset_a);
		`BNEZC	: $sformat(instruction, "0x%05H  BNEZC   %5h       ", 	pc, pc+next_offset_a);

		`ADD	: $sformat(instruction, "0x%05H  ADD     r%2d, r%2d    ", 	pc, r_no_a, r_no_b);
		`ADDU	: $sformat(instruction, "0x%05H  ADDU    r%2d, r%2d    ", 	pc, r_no_a, r_no_b);
		`SUB	: $sformat(instruction, "0x%05H  SUB     r%2d, r%2d    ", 	pc, r_no_a, r_no_b);
		`SUBU	: $sformat(instruction, "0x%05H  SUBU    r%2d, r%2d    ", 	pc, r_no_a, r_no_b);
		`AND	: $sformat(instruction, "0x%05H  AND     r%2d, r%2d    ", 	pc, r_no_a, r_no_b);
		`OR	: $sformat(instruction, "0x%05H  OR      r%2d, r%2d    ", 	pc, r_no_a, r_no_b);
		`XOR	: $sformat(instruction, "0x%05H  XOR     r%2d, r%2d    ", 	pc, r_no_a, r_no_b);
		`NOT	: $sformat(instruction, "0x%05H  NOT     r%2d, r%2d    ", 	pc, r_no_a, r_no_b);
		`MUL	: $sformat(instruction, "0x%05H  MUL     r%2d, r%2d    ", 	pc, r_no_a, r_no_b);
		`SEQ	: $sformat(instruction, "0x%05H  SEQ     r%2d, r%2d    ", 	pc, r_no_a, r_no_b);
		`SNE	: $sformat(instruction, "0x%05H  SNE     r%2d, r%2d    ", 	pc, r_no_a, r_no_b);
		`SLT	: $sformat(instruction, "0x%05H  SLT     r%2d, r%2d    ", 	pc, r_no_a, r_no_b);
		`SGT	: $sformat(instruction, "0x%05H  SGT     r%2d, r%2d    ", 	pc, r_no_a, r_no_b);
		`SLE	: $sformat(instruction, "0x%05H  SLE     r%2d, r%2d    ", 	pc, r_no_a, r_no_b);
		`SGE	: $sformat(instruction, "0x%05H  SGE     r%2d, r%2d    ", 	pc, r_no_a, r_no_b);
		`MOVI2S	: $sformat(instruction, "0x%05H  MOVI2S  r%2d, s%2d    ", 	pc, r_no_a, r_no_b);
		`MOVS2I	: $sformat(instruction, "0x%05H  MOVS2I  r%2d, s%2d    ", 	pc, r_no_a, r_no_b);

		`SLL	: $sformat(instruction, "0x%05H  SLL     r%2d, r%2d    ", 	pc, r_no_a, r_no_b);
		`SRL	: $sformat(instruction, "0x%05H  SRL     r%2d, r%2d    ", 	pc, r_no_a, r_no_b);
		`SRA	: $sformat(instruction, "0x%05H  SRA     r%2d, r%2d    ", 	pc, r_no_a, r_no_b);
		`MOV	: $sformat(instruction, "0x%05H  MOV     r%2d, r%2d    ", 	pc, r_no_a, r_no_b);
		`SEQU	: $sformat(instruction, "0x%05H  SEQU    r%2d, r%2d    ", 	pc, r_no_a, r_no_b);
		`SNEU	: $sformat(instruction, "0x%05H  SNEU    r%2d, r%2d    ", 	pc, r_no_a, r_no_b);
		`SLTU	: $sformat(instruction, "0x%05H  SLTU    r%2d, r%2d    ", 	pc, r_no_a, r_no_b);
		`SGTU	: $sformat(instruction, "0x%05H  SGTU    r%2d, r%2d    ", 	pc, r_no_a, r_no_b);
		`SLEU	: $sformat(instruction, "0x%05H  SLEU    r%2d, r%2d    ", 	pc, r_no_a, r_no_b);
		`SGEU	: $sformat(instruction, "0x%05H  SGEU    r%2d, r%2d    ", 	pc, r_no_a, r_no_b);

		`ADDI	: $sformat(instruction, "0x%05H  ADDI    r%2d, %h  ", 	pc, r_no_a, imm);
		`ANDI	: $sformat(instruction, "0x%05H  ANDI    r%2d, %h  ", 	pc, r_no_a, imm);
		`ORI	: $sformat(instruction, "0x%05H  ORI     r%2d, %h  ", 	pc, r_no_a, imm);
		`XORI	: $sformat(instruction, "0x%05H  XORI    r%2d, %h  ", 	pc, r_no_a, imm);
		`MULI	: $sformat(instruction, "0x%05H  MULI    r%2d, %h  ", 	pc, r_no_a, imm);
		`SLLI	: $sformat(instruction, "0x%05H  SLLI    r%2d, %h  ", 	pc, r_no_a, imm);
		`SRLI	: $sformat(instruction, "0x%05H  SRLI    r%2d, %h  ", 	pc, r_no_a, imm);
		`SRAI	: $sformat(instruction, "0x%05H  SRAI    r%2d, %h  ", 	pc, r_no_a, imm);

		`SEQI	: $sformat(instruction, "0x%05H  SEQI    r%2d, %h  ", 	pc, r_no_a, imm);
		`SNEI	: $sformat(instruction, "0x%05H  SNEI    r%2d, %h  ", 	pc, r_no_a, imm);
		`SLTI	: $sformat(instruction, "0x%05H  SLTI    r%2d, %h  ", 	pc, r_no_a, imm);
		`SGTI	: $sformat(instruction, "0x%05H  SGTI    r%2d, %h  ", 	pc, r_no_a, imm);
		`SLEI	: $sformat(instruction, "0x%05H  SLEI    r%2d, %h  ", 	pc, r_no_a, imm);
		`SGEI	: $sformat(instruction, "0x%05H  SGEI    r%2d, %h  ", 	pc, r_no_a, imm);

		`SIGEX	: $sformat(instruction, "0x%05H  SIGEX   r%2d, %h  ", 	pc, r_no_a, imm);
		`MOVI	: $sformat(instruction, "0x%05H  MOVI    r%2d, %h  ", 	pc, r_no_a, imm);

		`LHI	: $sformat(instruction, "0x%05H  LHI     r%2d, %h  ", 	pc, r_no_a, imm);
		`S18	: $sformat(instruction, "0x%05H  S18     %2d(r%2d), r%2d", 	pc, disp, r_no_b, r_no_a);
		`S9	: $sformat(instruction, "0x%05H  S9      %2d(r%2d), r%2d", 	pc, disp, r_no_b, r_no_a);
		`L18	: $sformat(instruction, "0x%05H  L18     r%2d, %2d(r%2d)", 	pc, r_no_a, disp, r_no_b);
	 	`L9	: $sformat(instruction, "0x%05H  L9      r%2d, %2d(r%2d)", 	pc, r_no_a, disp, r_no_b);
		`SWAP	: $sformat(instruction, "0x%05H  SWAP    r%2d, %2d(r%2d)", 	pc, r_no_a, disp, r_no_b);

		`SBITS	: $sformat(instruction, "0x%05H  SBITS   s%2d         ", 	pc, r_no_b);
		`CBITS	: $sformat(instruction, "0x%05H  CBITS   s%2d         ", 	pc, r_no_b);

		`IFADDUI: $sformat(instruction, "0x%05H  IFADDUI r%2d, %h   ", 	pc, r_no_a, imm);
		`IFSUBUI: $sformat(instruction, "0x%05H  IFSUBUI r%2d, %h   ", 	pc, r_no_a, imm);

		`TRAP	: $sformat(instruction, "0x%05H  TRAP    0x%1h%1h    ", 	pc, r_no_a, r_no_b);
		default : $sformat(instruction, "0x%05H  INVALID             ", 	pc, r_no_a, r_no_b);
	endcase

// synopsys translate_on*/


endmodule
