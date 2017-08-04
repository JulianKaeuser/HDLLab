
`default_nettype none

`include "irdefines.v"

module irdecode	(
clock,
reset,
instruction,

flag_z,
flag_c,
flag_n,
flag_v,

stall_from_instructionfetch, 
stall_from_memorycontroller,



operand_a,          
operand_b,

offset_a,
offset_b,

alu_opcode,

update_flag_n,
update_flag_z,
update_flag_c,
update_flag_v,

alu_write_to_reg,
alu_write_to_reg_enable, 
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

input wire flag_z;
input wire flag_c;
input wire flag_n;
input wire flag_v;

input wire stall_from_instructionfetch; 
input wire stall_from_memorycontroller;




output reg  [4:0] operand_a;           // für 8-fach Registerfile Bit 3 ignorieren: {operand_a[4], operand_a[3:0]}
output reg  [4:0] operand_b;

output reg [31:0] offset_a;
output reg [31:0] offset_b;

output reg  [4:0] alu_opcode;

output reg update_flag_n;
output reg update_flag_z;
output reg update_flag_c;
output reg update_flag_v;

output reg  [4:0] alu_write_to_reg;
output reg alu_write_to_reg_enable; 
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

reg [7:0] step;                      // default all 1 !


reg [7:0] itstate;

// synthesis translate off
reg exec_cond_true;
// synthesis translate on
                             

always @(posedge clock) begin 



decoder_pc_update <= (   ((alu_write_to_reg == `RF_R15_PC) & alu_write_to_reg_enable) 
                             | ((memory_write_to_reg == `RF_R15_PC) & memory_write_to_reg_enable)
                             | (stack_pop_request & instruction[8])                              )
                             ? 1'b1
                             : 1'b0 ;
                             

if ( !stall_from_instructionfetch & !stall_to_instructionfetch & !reset & !stall_from_memorycontroller) begin
    itstate <= (itstate[3:0] == 4'b1000) ? 8'b0000_0000 : {itstate[7:5], (itstate[4:0] << 1)};
end
else if (reset) begin
    itstate <= 8'b0000_0000;
end
else if (instruction == `FORMAT_20) begin
    itstate <= instruction[7:0];
end
else
    itstate <= itstate;




if ( (!stall_from_instructionfetch | stall_to_instructionfetch) & !reset & !stall_from_memorycontroller) begin // if-block no_stall or reset

	if ( (itstate == 8'b0000_0000) | f_flageval(itstate[7:4], flag_z, flag_c, flag_n, flag_v)) begin // if-block ITSTATE
	
	// synthesis translate off
        exec_cond_true <= 1'b1;
    // synthesis translate on
	
	casez (instruction)
	
	        `FORMAT_1_2  : begin                                            
	            operand_a <= {2'b00, instruction[5:3]};
	            
	            offset_a <= `IMM_ZERO;
	                      
	            alu_write_to_reg <= {2'b00, instruction[2:0]};
	            alu_write_to_reg_enable <= 1'b1;
	            memory_write_to_reg <= `RF_NONE;
	            memory_write_to_reg_enable <= 1'b0;
	            
	            memory_store_data_reg <= `RF_NONE;
	            memory_store_address_reg <= `RF_NONE;
	            memory_address_source_is_reg <= 1'b0;
	            load_store_width <= `WORD;
	            memorycontroller_sign_extend <= 1'b0;
	
	            memory_load_request <= 1'b0;
	            memory_store_request <= 1'b0;
	            
	            stack_push_request <= 1'b0;
	            stack_pop_request <= 1'b0;
	            
	            stall_to_instructionfetch       <= 0;
	                                
	            step                            <= 8'b1111_1111;
	            
	            casez (instruction[12:11])
	                `F1_LSL  : begin
	                    operand_b <= `RF_IMM;
	                    offset_b <= {27'b0000_0000_0000_0000_0000_0000_000, instruction[10:6]};
	                    alu_opcode <= `LSL;
	                    
						update_flag_n <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    update_flag_z <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						update_flag_c <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						update_flag_v <= 1'b0;
	                end
	                `F1_LSR  : begin
	                    operand_b <= `RF_IMM;
	                    offset_b <= {27'b0000_0000_0000_0000_0000_0000_000, instruction[10:6]};
	                    alu_opcode  <= `LSR;
	                    
	                    update_flag_n <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    update_flag_z <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						update_flag_c <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						update_flag_v <= 1'b0;
	                end
	                `F1_ASR  : begin
	                    operand_b <= `RF_IMM;
	                    offset_b <= {27'b0000_0000_0000_0000_0000_0000_000, instruction[10:6]};
	                    alu_opcode  <= `ASR;
	                    
	                    update_flag_n <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    update_flag_z <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						update_flag_c <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						update_flag_v <= 1'b0;
	                end
	                `FORMAT_2 :begin
	                
	                    casez (instruction[10]) 
	                        `F2_REG_OP : begin
	                            operand_b <= {2'b00, instruction[8:6]};
	                            offset_b <= `IMM_ZERO;
	                        end
	                        `F2_IMM_OP : begin
	                            operand_b <= `RF_IMM;
	                            offset_b <= {29'b0000_0000_0000_0000_0000_0000_0000_0, instruction[8:6]};
	                        end
	                    endcase
	                    
	                    casez (instruction[9]) 
	                        `F2_ADD : alu_opcode  <= `ADD;
	                        `F2_SUB : alu_opcode  <= `SUB;
	                    endcase
	                    
	                    update_flag_n <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    update_flag_z <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						update_flag_c <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						update_flag_v <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                end
	                
	            endcase
	        end
	        
	        `FORMAT_3  : begin
	            operand_b <= `RF_IMM;
	            
	            offset_a <= `IMM_ZERO;
	            offset_b <= {24'b0000_0000_0000_0000_0000_0000, instruction[7:0]};
	            
	            
	            memory_write_to_reg <= `RF_NONE;
	            memory_write_to_reg_enable <= 1'b0;
	            
	            memory_store_data_reg <= `RF_NONE;
	            memory_store_address_reg <= `RF_NONE;
	            memory_address_source_is_reg <= 1'b0;
	            load_store_width <= `WORD;
	            memorycontroller_sign_extend <= 1'b0;
	
	            memory_load_request <= 1'b0;
	            memory_store_request <= 1'b0;
	             
	            stack_push_request <= 1'b0;
	            stack_pop_request <= 1'b0;
	            
	            stall_to_instructionfetch       <= 0;
	                                
	            step                            <= 8'b1111_1111;
	            
	            casez (instruction[12:11])
	                `F3_MOV  : begin
	                    operand_a <= `RF_IMM; 
	                    alu_opcode  <= `ORR;    // entspricht PASSB wegen offset_a = 0
	                    alu_write_to_reg <= {2'b00, instruction[10:8]};
	                    alu_write_to_reg_enable <= 1'b1;
	                    
	                    update_flag_n <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    update_flag_z <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						update_flag_c <= 1'b0;
						update_flag_v <= 1'b0;
	                end
	                `F3_CMP  : begin
	                    operand_a <= {2'b00, instruction[10:8]};
	                    alu_opcode  <= `CMP;
	                    alu_write_to_reg <= `RF_NONE;
	                    alu_write_to_reg_enable <= 1'b0; 
	                    
	                    update_flag_n <= 1'b1;
	                    update_flag_z <= 1'b1;
						update_flag_c <= 1'b1;
						update_flag_v <= 1'b1;
	                end
	                `F3_ADD  : begin
	                    operand_a <= {2'b00, instruction[10:8]};
	                    alu_opcode  <= `ADD;
	                    alu_write_to_reg <= {2'b00, instruction[10:8]};
	                    alu_write_to_reg_enable <= 1'b1;
	                    
	                    update_flag_n <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    update_flag_z <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						update_flag_c <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						update_flag_v <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                end
	                `F3_SUB  : begin
	                    operand_a <= {2'b00, instruction[10:8]};
	                    alu_opcode  <= `SUB;
	                    alu_write_to_reg <= {2'b00, instruction[10:8]};
	                    alu_write_to_reg_enable <= 1'b1;
	                    
	                    update_flag_n <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    update_flag_z <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						update_flag_c <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						update_flag_v <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                end
	            endcase
	        end
	        
	        `FORMAT_4  : begin
	            operand_a <= {2'b00, instruction[2:0]};
	            operand_b <= {2'b00, instruction[5:3]};
	            
	            offset_a <= `IMM_ZERO;
	            offset_b <= `IMM_ZERO;
	            
	            memory_write_to_reg <= `RF_NONE;
	            memory_write_to_reg_enable <= 1'b0;
	            
	            memory_store_data_reg <= `RF_NONE;
	            memory_store_address_reg <= `RF_NONE;
	            memory_address_source_is_reg <= 1'b0;
	            load_store_width <= `WORD;
	            memorycontroller_sign_extend <= 1'b0;
	
	            memory_load_request <= 1'b0;
	            memory_store_request <= 1'b0;
	             
	            stack_push_request <= 1'b0;
	            stack_pop_request <= 1'b0;
	            
	            stall_to_instructionfetch       <= 0;
	                                
	            step                            <= 8'b1111_1111;
	            
	            casez (instruction[9:6])
	                `F4_AND : begin
	                    alu_opcode  <= `AND;
	                    alu_write_to_reg <= {2'b00, instruction[2:0]};
	                    alu_write_to_reg_enable <= 1'b1;
	                    
	                    update_flag_n <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    update_flag_z <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						update_flag_c <= 1'b0;
						update_flag_v <= 1'b0;
	                end
	                `F4_EOR : begin
	                    alu_opcode  <= `EOR;
	                    alu_write_to_reg <= {2'b00, instruction[2:0]};
	                    alu_write_to_reg_enable <= 1'b1;
	                    
	                    update_flag_n <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    update_flag_z <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						update_flag_c <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						update_flag_v <= 1'b0;
	                end
	                `F4_LSL : begin
	                    alu_opcode  <= `LSL;
	                    alu_write_to_reg <= {2'b00, instruction[2:0]};
	                    alu_write_to_reg_enable <= 1'b1;
	                    
	                    update_flag_n <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    update_flag_z <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						update_flag_c <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						update_flag_v <= 1'b0;
	                end
	                `F4_LSR : begin
	                    alu_opcode  <= `LSR;
	                    alu_write_to_reg <= {2'b00, instruction[2:0]};
	                    alu_write_to_reg_enable <= 1'b1;
	                    
	                    update_flag_n <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    update_flag_z <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						update_flag_c <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						update_flag_v <= 1'b0;
	                end
	                `F4_ASR : begin
	                    alu_opcode  <= `ASR;
	                    alu_write_to_reg <= {2'b00, instruction[2:0]};
	                    alu_write_to_reg_enable <= 1'b1;
	                    
	                    update_flag_n <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    update_flag_z <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    update_flag_c <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						update_flag_v <= 1'b0;
	                end
	                `F4_ADC : begin
	                    alu_opcode  <= `ADC;
	                    alu_write_to_reg <= {2'b00, instruction[2:0]};
	                    alu_write_to_reg_enable <= 1'b1;
	                    
	                    update_flag_n <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    update_flag_z <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						update_flag_c <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						update_flag_v <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                end
	                `F4_SBC : begin
	                    alu_opcode  <= `SBC;
	                    alu_write_to_reg <= {2'b00, instruction[2:0]};
	                    alu_write_to_reg_enable <= 1'b1;
	                    
	                    update_flag_n <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    update_flag_z <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						update_flag_c <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						update_flag_v <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                end
	                `F4_ROR : begin
	                    alu_opcode  <= `ROR;
	                    alu_write_to_reg <= {2'b00, instruction[2:0]};
	                    alu_write_to_reg_enable <= 1'b1;
	                    
	                    update_flag_n <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    update_flag_z <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						update_flag_c <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						update_flag_v <= 1'b0;
	                end
	                `F4_TST : begin
	                    alu_opcode  <= `TST;
	                    alu_write_to_reg <= `RF_NONE;
	                    alu_write_to_reg_enable <= 1'b0;
	                    
	                    update_flag_n <= 1'b1;
	                    update_flag_z <= 1'b1;
						update_flag_c <= 1'b0;
						update_flag_v <= 1'b0;
	                end
	                `F4_NEG : begin
	                    alu_opcode  <= `NEG;
	                    alu_write_to_reg <= {2'b00, instruction[2:0]};
	                    alu_write_to_reg_enable <= 1'b1;
	                    
	                    update_flag_n <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    update_flag_z <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						update_flag_c <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						update_flag_v <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                end
	                `F4_CMP : begin
	                    alu_opcode  <= `CMP;
	                    alu_write_to_reg <= `RF_NONE;
	                    alu_write_to_reg_enable <= 1'b0;
	                    
	                    update_flag_n <= 1'b1;
	                    update_flag_z <= 1'b1;
						update_flag_c <= 1'b1;
						update_flag_v <= 1'b1;
	                end
	                `F4_CMN : begin
	                    alu_opcode  <= `CMN;
	                    alu_write_to_reg <= `RF_NONE;
	                    alu_write_to_reg_enable <= 1'b0;
	                    
	                    update_flag_n <= 1'b1;
	                    update_flag_z <= 1'b1;
						update_flag_c <= 1'b1;
						update_flag_v <= 1'b1;
	                end
	                `F4_ORR : begin
	                    alu_opcode  <= `ORR;
	                    alu_write_to_reg <= {2'b00, instruction[2:0]};
	                    alu_write_to_reg_enable <= 1'b1;
	                    
	                    update_flag_n <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    update_flag_z <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						update_flag_c <= 1'b0;
						update_flag_v <= 1'b0;
	                end
	                `F4_MUL : begin
	                    alu_opcode  <= `MUL; 
	                    alu_write_to_reg <= {2'b00, instruction[2:0]};
	                    alu_write_to_reg_enable <= 1'b1;
	                    
	                    update_flag_n <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    update_flag_z <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						update_flag_c <= 1'b0;
						update_flag_v <= 1'b0;
	                end
	                `F4_BIC : begin
	                    alu_opcode  <= `BIC;
	                    alu_write_to_reg <= {2'b00, instruction[2:0]};
	                    alu_write_to_reg_enable <= 1'b1;
	                    
	                    update_flag_n <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    update_flag_z <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						update_flag_c <= 1'b0;
						update_flag_v <= 1'b0;
	                end
	                `F4_MVN : begin
	                    alu_opcode  <= `MVN;
	                    alu_write_to_reg <= {2'b00, instruction[2:0]};
	                    alu_write_to_reg_enable <= 1'b1;
	                    
	                    update_flag_n <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
	                    update_flag_z <= (itstate == 8'b0000_0000) ? 1'b1 : 1'b0;
						update_flag_c <= 1'b0;
						update_flag_v <= 1'b0;
	                end
	            endcase
	        end
	        
	        `FORMAT_5  : begin                               
	            
	            offset_a <= `IMM_ZERO;
	            offset_b <= `IMM_ZERO;
	            
	            memory_write_to_reg <= `RF_NONE;
	            memory_write_to_reg_enable <= 1'b0;
	            
	            memory_store_data_reg <= `RF_NONE;
	            memory_store_address_reg <= `RF_NONE;
	            memory_address_source_is_reg <= 1'b0;
	            load_store_width <= `WORD;
	            memorycontroller_sign_extend <= 1'b0;
	
	            memory_load_request <= 1'b0;
	            memory_store_request <= 1'b0;
	            
	            stack_push_request <= 1'b0;
	            stack_pop_request <= 1'b0;
	            
	            stall_to_instructionfetch       <= 0;
	                                
	            step                            <= 8'b1111_1111;
	            
	            casez (instruction[9:8])
	                `F5_ADD : begin
	                    operand_a <= {1'b0, instruction[7], instruction[2:0]};
	                    operand_b <= {1'b0, instruction[6], instruction[5:3]};
	                
	                    alu_opcode  <= `ADD;
	                    
	                    alu_write_to_reg <= {1'b0, instruction[7], instruction[2:0]};
	                    alu_write_to_reg_enable <= 1'b1;
	                    
	                    update_flag_n <= 1'b0;
	                    update_flag_z <= 1'b0;
						update_flag_c <= 1'b0;
						update_flag_v <= 1'b0;
	                end
	                `F5_CMP : begin
	                    operand_a <= {1'b0, instruction[7], instruction[2:0]};
	                    operand_b <= {1'b0, instruction[6], instruction[5:3]};
	                
	                    alu_opcode  <= `CMP;
	                    
	                    alu_write_to_reg <= `RF_NONE;
	                    alu_write_to_reg_enable <= 1'b0;
	                    
	                    update_flag_n <= 1'b1;
	                    update_flag_z <= 1'b1;
						update_flag_c <= 1'b1;
						update_flag_v <= 1'b1;
	                end
	                `F5_MOV : begin
	                    operand_a <= `RF_IMM;
	                    operand_b <= {1'b0, instruction[6], instruction[5:3]};
	                    
	                    alu_opcode  <= `ORR; // entspricht PASSB wegen operand_a = 0
	                    
	                    alu_write_to_reg <= {1'b0, instruction[7], instruction[2:0]};
	                    alu_write_to_reg_enable <= 1'b1;
	                    
	                    update_flag_n <= 1'b0;
	                    update_flag_z <= 1'b0;
						update_flag_c <= 1'b0;
						update_flag_v <= 1'b0;
	                end
	                `F5_BX  : begin
	                    operand_a <= `RF_IMM;
	                    operand_b <= {1'b0, instruction[6], instruction[5:3]};
	                
	                    alu_opcode  <= `ORR; // entspricht PASSB wegen operand_a = 0
	                    
	                    alu_write_to_reg <= `RF_R15_PC;
	                    alu_write_to_reg_enable <= 1'b1;
	                    
	                    update_flag_n <= 1'b0;
	                    update_flag_z <= 1'b0;
						update_flag_c <= 1'b0;
						update_flag_v <= 1'b0;
	                end
	            endcase
	        end
	        
	        `FORMAT_6  : begin                               
	            operand_a <= `RF_R15_PC;
	            operand_b <= `RF_IMM;
	            
	            // siehe Beispiel mit den 844 = 211 (844 / 4) im Opcode wegen 
	            // wegen immediate = word8, Linksshift von offset_b um 2 
	            
	            offset_a <= `IMM_ZERO;
	            offset_b <= {22'b0000_0000_0000_0000_0000_00, instruction[7:0], 2'b00};
	            
	            alu_opcode <= `ADD;
	            
	            update_flag_n <= 1'b0;
	            update_flag_z <= 1'b0;
	            update_flag_c <= 1'b0;
	            update_flag_v <= 1'b0;
	            
	            alu_write_to_reg <= `RF_NONE;
	            alu_write_to_reg_enable <= 1'b0;
	            
	            memory_write_to_reg <= {2'b00, instruction[10:8]};
	            memory_write_to_reg_enable <= 1'b1;
	
	            memory_store_data_reg <= `RF_NONE;
	            memory_store_address_reg <= `RF_NONE;
	            memory_address_source_is_reg <= 1'b0;
	            load_store_width <= `WORD;
	            memorycontroller_sign_extend <= 1'b0;
	            
	            memory_load_request <= 1'b1;                                       
	            memory_store_request <= 1'b0;
	             
	            stack_push_request <= 1'b0;
	            stack_pop_request <= 1'b0;
	            
	            stall_to_instructionfetch       <= 0;
	                                
	            step                            <= 8'b1111_1111;
	            
	        end
	        
	        `FORMAT_7  : begin                          
	            operand_a <= {2'b00, instruction[5:3]};
	            operand_b <= {2'b00, instruction[8:6]};
	            
	            offset_a <= `IMM_ZERO;
	            offset_b <= `IMM_ZERO;
	            
	            alu_opcode <= `ADD;
	            
	            update_flag_n <= 1'b0;
	            update_flag_z <= 1'b0;
	            update_flag_c <= 1'b0;
	            update_flag_v <= 1'b0;
	            
	            alu_write_to_reg <= `RF_NONE;
	            alu_write_to_reg_enable <= 1'b0;
	            
	            memory_store_address_reg <= `RF_NONE;
	            memory_address_source_is_reg <= 1'b0;
	            memorycontroller_sign_extend <= 1'b0;
	             
	            stack_push_request <= 1'b0;
	            stack_pop_request <= 1'b0;
	            
	            stall_to_instructionfetch       <= 0;
	                                
	            step                            <= 8'b1111_1111;
	            
	            casez (instruction[11])
	                `F7_STORE : begin
	                    memory_write_to_reg <= `RF_NONE;
	                    memory_write_to_reg_enable <= 1'b0;
	                    memory_store_data_reg <= {2'b00, instruction[2:0]};
	                    
	                    memory_load_request <= 1'b0;                                       
	                    memory_store_request <= 1'b1;
	                end
	                `F7_LOAD : begin
	                    memory_write_to_reg <= {2'b00, instruction[2:0]};
	                    memory_write_to_reg_enable <= 1'b1;
	                    memory_store_data_reg <= `RF_NONE;
	                    
	                    memory_load_request <= 1'b1;                                       
	                    memory_store_request <= 1'b0;
	                end
	            endcase
	            
	            casez (instruction[10])
	                `F7_WORD : load_store_width <= `WORD;
	                `F7_BYTE : load_store_width <= `BYTE;
	            endcase
	        end
	        
	        `FORMAT_8  : begin                          
	            operand_a <= {2'b00, instruction[5:3]};
	            operand_b <= {2'b00, instruction[8:6]};
	            
	            offset_a <= `IMM_ZERO;
	            offset_b <= `IMM_ZERO;
	            
	            alu_opcode <= `ADD;
	            
	            update_flag_n <= 1'b0;
	            update_flag_z <= 1'b0;
	            update_flag_c <= 1'b0;
	            update_flag_v <= 1'b0;
	            
	            alu_write_to_reg <= `RF_NONE;
	            alu_write_to_reg_enable <= 1'b0;
	            
	            memory_store_address_reg <= `RF_NONE;
	            memory_address_source_is_reg <= 1'b0;
	             
	            stack_push_request <= 1'b0;
	            stack_pop_request <= 1'b0;
	            
	            stall_to_instructionfetch       <= 0;
	                                
	            step                            <= 8'b1111_1111;
	            
	            casez (instruction[11:10])
	            `F8_STORE_HW   : begin
	                    memory_write_to_reg <= `RF_NONE;
	                    memory_write_to_reg_enable <= 1'b0;
	                    memory_store_data_reg <= {2'b00, instruction[2:0]};
	
	                    load_store_width <= `HALFWORD;
	                    memorycontroller_sign_extend <= 1'b0;
	                    
	                    memory_load_request <= 1'b0;                                       
	                    memory_store_request <= 1'b1;
	                end
	            `F8_LOAD_HW    : begin
	                    memory_write_to_reg <= {2'b00, instruction[2:0]};
	                    memory_write_to_reg_enable <= 1'b1;
	                    memory_store_data_reg <= `RF_NONE;
	                               
	                    load_store_width <= `HALFWORD;
	                    memorycontroller_sign_extend <= 1'b0;
	                    
	                    memory_load_request <= 1'b1;                                       
	                    memory_store_request <= 1'b0;
	                end
	            `F8_LOAD_SE_B  : begin
	                    memory_write_to_reg <= {2'b00, instruction[2:0]};
	                    memory_write_to_reg_enable <= 1'b1;
	                    memory_store_data_reg <= `RF_NONE;
	                               
	                    load_store_width <= `BYTE;
	                    memorycontroller_sign_extend <= 1'b1;
	                    
	                    memory_load_request <= 1'b1;                                       
	                    memory_store_request <= 1'b0;
	                end
	            `F8_LOAD_SE_HW : begin
	                    memory_write_to_reg <= {2'b00, instruction[2:0]};
	                    memory_write_to_reg_enable <= 1'b1;
	                    memory_store_data_reg <= `RF_NONE;
	                               
	                    load_store_width <= `HALFWORD;
	                    memorycontroller_sign_extend <= 1'b1;
	                    
	                    memory_load_request <= 1'b1;                                       
	                    memory_store_request <= 1'b0;
	                end
	            endcase
	
	        end       
	        
	        `FORMAT_9  : begin                                            
	            operand_a <= {2'b00, instruction[5:3]};
	            operand_b <= `RF_IMM;
	            
	            offset_a <= `IMM_ZERO;
	            offset_b <= {25'b0000_0000_0000_0000_0000_0000_0, instruction[10:6], 2'b00};
	            
	            alu_opcode <= `ADD;
	            
	            update_flag_n <= 1'b0;
	            update_flag_z <= 1'b0;
	            update_flag_c <= 1'b0;
	            update_flag_v <= 1'b0;
	            
	            alu_write_to_reg <= `RF_NONE;
	            alu_write_to_reg_enable <= 1'b0;
	        
	            memory_store_address_reg <= `RF_NONE;
	            memory_address_source_is_reg <= 1'b0;
	            memorycontroller_sign_extend <= 1'b0;
	             
	            stack_push_request <= 1'b0;
	            stack_pop_request <= 1'b0;
	            
	            stall_to_instructionfetch       <= 0;
	                                
	            step                            <= 8'b1111_1111;
	            
	            casez (instruction[11])
	                `F9_STORE : begin
	                    memory_write_to_reg <= `RF_NONE;
	                    memory_write_to_reg_enable <= 1'b0;
	                    memory_store_data_reg <= {2'b00, instruction[2:0]};
	                
	                    memory_load_request <= 1'b0;                                       
	                    memory_store_request <= 1'b1;
	                end
	                `F9_LOAD : begin
	                    memory_write_to_reg <= {2'b00, instruction[2:0]};
	                    memory_write_to_reg_enable <= 1'b1;
	                    memory_store_data_reg <= `RF_NONE;
	                    
	                    memory_load_request <= 1'b1;                                       
	                    memory_store_request <= 1'b0;
	                end
	            endcase
	            
	            casez (instruction[12])
	                `F9_WORD : load_store_width <= `WORD;
	                `F9_BYTE : load_store_width <= `BYTE;
	            endcase
	            
	        end
	        
	        `FORMAT_10  : begin                                            
	            operand_a <= {2'b00, instruction[5:3]};
	            operand_b <= `RF_IMM;
	            
	            offset_a <= `IMM_ZERO;
	            offset_b <= {26'b0000_0000_0000_0000_0000_0000_00, instruction[10:6], 1'b0};
	
	            alu_opcode <= `ADD;
	            
	            update_flag_n <= 1'b0;
	            update_flag_z <= 1'b0;
	            update_flag_c <= 1'b0;
	            update_flag_v <= 1'b0;
	            
	            alu_write_to_reg <= `RF_NONE;
	            alu_write_to_reg_enable <= 1'b0;
	            
	            memory_store_address_reg <= `RF_NONE;
	            memory_address_source_is_reg <= 1'b0;
	            load_store_width <= `HALFWORD;
	            memorycontroller_sign_extend <= 1'b0;
	             
	            stack_push_request <= 1'b0;
	            stack_pop_request <= 1'b0;
	            
	            stall_to_instructionfetch       <= 0;
	                                
	            step                            <= 8'b1111_1111;
	            
	            casez (instruction[11])
	                `F10_STORE : begin
	                    memory_write_to_reg <= `RF_NONE;
	                    memory_write_to_reg_enable <= 1'b0;
	                    memory_store_data_reg <= {2'b00, instruction[2:0]};
	                
	                    memory_load_request <= 1'b0;                                       
	                    memory_store_request <= 1'b1;
	                end
	                `F10_LOAD : begin
	                    memory_write_to_reg <= {2'b00, instruction[2:0]};
	                    memory_write_to_reg_enable <= 1'b1;
	                    memory_store_data_reg <= `RF_NONE;
	                
	                    memory_load_request <= 1'b1;                                       
	                    memory_store_request <= 1'b0;
	                end
	            endcase
	                      
	        end
	        
	        `FORMAT_11  : begin
	            operand_a <= `RF_R13_SP;
	            operand_b <= `RF_IMM;
	            
	            offset_a <= `IMM_ZERO;
	            offset_b <= {22'b0000_0000_0000_0000_0000_00, instruction[7:0], 2'b00};
	            
	            alu_opcode <= `ADD;  
	            
	            update_flag_n <= 1'b0;
	            update_flag_z <= 1'b0;
	            update_flag_c <= 1'b0;
	            update_flag_v <= 1'b0;
	            
	            alu_write_to_reg <= `RF_NONE;
	            alu_write_to_reg_enable <= 1'b0;
	            
	            memory_store_address_reg <= `RF_NONE;
	            memory_address_source_is_reg <= 1'b0;
	            load_store_width <= `WORD;
	            memorycontroller_sign_extend <= 1'b0;
	            
	            stack_push_request <= 1'b0;
	            stack_pop_request <= 1'b0;
	            
	            stall_to_instructionfetch       <= 0;
	                                
	            step                            <= 8'b1111_1111;
	            
	            casez (instruction[11])
	                `F11_STORE : begin
	                    memory_write_to_reg <= `RF_NONE;
	                    memory_write_to_reg_enable <= 1'b0;
	                    memory_store_data_reg <= {2'b00, instruction[10:8]};
	                
	                    memory_load_request <= 1'b0;                                       
	                    memory_store_request <= 1'b1;
	                end
	                `F11_LOAD : begin
	                    memory_write_to_reg <= {2'b00, instruction[10:8]};
	                    memory_write_to_reg_enable <= 1'b1;
	                    memory_store_data_reg <= `RF_NONE;
	                
	                    memory_load_request <= 1'b1;                                       
	                    memory_store_request <= 1'b0;
	                end
	            endcase
	            
	        end
	        
	        `FORMAT_12  : begin
	            operand_b <= `RF_IMM;
	
	            offset_a <= `IMM_ZERO;
	            offset_b <= {22'b0000_0000_0000_0000_0000_00, instruction[7:0], 2'b00};
	            
	            alu_opcode <= `ADD; 
	            
	            update_flag_n <= 1'b0;
	            update_flag_z <= 1'b0;
	            update_flag_c <= 1'b0;
	            update_flag_v <= 1'b0;
	            
	            alu_write_to_reg <= {2'b00, instruction[10:8]};
	            alu_write_to_reg_enable <= 1'b1;
	            memory_write_to_reg <= `RF_NONE;
	            memory_write_to_reg_enable <= 1'b0;
	            
	            memory_store_data_reg <= `RF_NONE;
	            memory_store_address_reg <= `RF_NONE;
	            memory_address_source_is_reg <= 1'b0;
	            load_store_width <= `WORD;
	            memorycontroller_sign_extend <= 1'b0;
	            
	            memory_load_request <= 1'b0;                                       
	            memory_store_request <= 1'b0;
	            
	            stack_push_request <= 1'b0;
	            stack_pop_request <= 1'b0;
	            
	            stall_to_instructionfetch       <= 0;
	                                
	            step                            <= 8'b1111_1111;
	                        
	            casez (instruction[11])
	                `F12_PC : operand_a <= `RF_R15_PC;
	                `F12_SP : operand_a <= `RF_R13_SP;
	            endcase
	            
	        end
	        
	        `FORMAT_13  : begin
	            operand_a <= `RF_R13_SP;
	            operand_b <= `RF_IMM;
	            
	            offset_a <= `IMM_ZERO;
	            offset_b <= {23'b0000_0000_0000_0000_0000_000, instruction[6:0], 2'b00};
	            
	            update_flag_n <= 1'b0;
	            update_flag_z <= 1'b0;
	            update_flag_c <= 1'b0;
	            update_flag_v <= 1'b0;
	
	            alu_write_to_reg <= `RF_R13_SP;
	            alu_write_to_reg_enable <= 1'b1;
	            memory_write_to_reg <= `RF_NONE;
	            memory_write_to_reg_enable <= 1'b0;
	            
	            memory_store_data_reg <= `RF_NONE;
	            memory_store_address_reg <= `RF_NONE;
	            memory_address_source_is_reg <= 1'b0;
	            load_store_width <= `WORD;
	            memorycontroller_sign_extend <= 1'b0;
	            
	            memory_load_request <= 1'b0;                                       
	            memory_store_request <= 1'b0;
	            
	            stack_push_request <= 1'b0;
	            stack_pop_request <= 1'b0;
	            
	            stall_to_instructionfetch       <= 0;
	                                
	            step                            <= 8'b1111_1111;
	            
	            casez (instruction[7])
	                `F12_ADD : begin
	                    alu_opcode <= `ADD;
	                end
	                `F12_SUB : begin
	                    alu_opcode <= `SUB;
	                end
	            endcase
	            
	        end
	        
	        `FORMAT_14  : begin                                   
	            operand_a <= `RF_IMM;
	            operand_b <= `RF_IMM;
	            
	            offset_a <= {23'b0000_0000_0000_0000_0000_000, instruction[8:0]}; // muss zu Stack verdrahtet werden
	            offset_b <= `IMM_ZERO;
	            
	            alu_opcode <= `ORR;    // belanglos
	            
	            update_flag_n <= 1'b0;
	            update_flag_z <= 1'b0;
	            update_flag_c <= 1'b0;
	            update_flag_v <= 1'b0;
	            
	            alu_write_to_reg <= `RF_NONE;
	            alu_write_to_reg_enable <= 1'b0;            
	            memory_write_to_reg <= `RF_NONE;
	            memory_write_to_reg_enable <= 1'b0;
	            
	            memory_store_data_reg <= `RF_NONE;
	            memory_store_address_reg <= `RF_NONE;
	            memory_address_source_is_reg <= 1'b0;
	            load_store_width <= `WORD;
	            memorycontroller_sign_extend <= 1'b0;
	            
	            memory_load_request <= 1'b0;                                       
	            memory_store_request <= 1'b0;
	            
	            stall_to_instructionfetch       <= 0;
	
	            step                            <= 8'b1111_1111;
	            
	            casez (instruction[11])
	                `F14_PUSH : begin
	                    stack_push_request <= 1'b1;  //diese Signale auch zum RF legen
	                    stack_pop_request <= 1'b0;
	                end
	                `F14_POP : begin
	                    stack_push_request <= 1'b0;
	                    stack_pop_request <= 1'b1;
	                end
	            endcase
	            
	        end
	        
	        `FORMAT_15  : begin                                   
	            operand_a <= {2'b00, instruction[10:8]};
	            operand_b <= `RF_IMM;
	            
	            offset_a <= `IMM_ZERO;
	            offset_b <= 32'b0000_0000_0000_0000_0000_0000_0000_0010;
	
	            alu_opcode <= `ADD;                              // addiert bei jedem load/store 4 zum Base-Register   
	            
	            update_flag_n <= 1'b0;
	            update_flag_z <= 1'b0;
	            update_flag_c <= 1'b0;
	            update_flag_v <= 1'b0;
	            
	            alu_write_to_reg <= {2'b00, instruction[10:8]};                                                   
	            alu_write_to_reg_enable <= 1'b1;
	            
	            memory_store_address_reg <= {2'b00, instruction[10:8]};
	            memory_address_source_is_reg <= 1'b1;
	            
	            load_store_width <= `WORD;
	            memorycontroller_sign_extend <= 1'b0;
	            
	            stack_push_request <= 1'b0;
	            stack_pop_request <= 1'b0;
	                        
	            // Instruktionssplit
	            
	            casez (step & instruction[7:0])
	            
	                // Endfälle (stall_to_instructionfetch <= 1'b0);
	                8'b00000001 : begin
	                    casez (instruction[11])
						    `F15_STORE : begin
						        memory_write_to_reg <= `RF_NONE;
						        memory_write_to_reg_enable <= 1'b0;
						        memory_store_data_reg <= `RF_R0;
						    
						        memory_load_request <= 1'b0;                                       
						        memory_store_request <= 1'b1;
						    end
						    `F15_LOAD : begin
						        memory_write_to_reg <= `RF_R0;
						        memory_write_to_reg_enable <= 1'b1;
						        memory_store_data_reg <= `RF_NONE;
						    
						        memory_load_request <= 1'b1;                                       
						        memory_store_request <= 1'b0;
						    end
						endcase
	                    
	                    stall_to_instructionfetch <= 1'b0;
	                    step <= 8'b1111_1110;
	                end
	                
	                8'b00000010 : begin
	                    casez (instruction[11])
						    `F15_STORE : begin
						        memory_write_to_reg <= `RF_NONE;
						        memory_write_to_reg_enable <= 1'b0;
						        memory_store_data_reg <= `RF_R1;
						    
						        memory_load_request <= 1'b0;                                       
						        memory_store_request <= 1'b1;
						    end
						    `F15_LOAD : begin
						        memory_write_to_reg <= `RF_R1;
						        memory_write_to_reg_enable <= 1'b1;
						        memory_store_data_reg <= `RF_NONE;
						    
						        memory_load_request <= 1'b1;                                       
						        memory_store_request <= 1'b0;
						    end
						endcase
	                    
	                    stall_to_instructionfetch <= 1'b0;
	                    step <= 8'b1111_1100;
	                end
	                
	                8'b00000100 : begin
	                    casez (instruction[11])
						    `F15_STORE : begin
						        memory_write_to_reg <= `RF_NONE;
						        memory_write_to_reg_enable <= 1'b0;
						        memory_store_data_reg <= `RF_R2;
						    
						        memory_load_request <= 1'b0;                                       
						        memory_store_request <= 1'b1;
						    end
						    `F15_LOAD : begin
						        memory_write_to_reg <= `RF_R2;
						        memory_write_to_reg_enable <= 1'b1;
						        memory_store_data_reg <= `RF_NONE;
						    
						        memory_load_request <= 1'b1;                                       
						        memory_store_request <= 1'b0;
						    end
						endcase
	                    
	                    stall_to_instructionfetch <= 1'b0;
	                    step <= 8'b1111_1000;
	                end
	                
	                8'b00001000 : begin
	                    casez (instruction[11])
						    `F15_STORE : begin
						        memory_write_to_reg <= `RF_NONE;
						        memory_write_to_reg_enable <= 1'b0;
						        memory_store_data_reg <= `RF_R3;
						    
						        memory_load_request <= 1'b0;                                       
						        memory_store_request <= 1'b1;
						    end
						    `F15_LOAD : begin
						        memory_write_to_reg <= `RF_R3;
						        memory_write_to_reg_enable <= 1'b1;
						        memory_store_data_reg <= `RF_NONE;
						    
						        memory_load_request <= 1'b1;                                       
						        memory_store_request <= 1'b0;
						    end
						endcase
	                    
	                    stall_to_instructionfetch <= 1'b0;
	                    step <= 8'b1111_0000;
	                end
	                
	                8'b00010000 : begin
	                    casez (instruction[11])
						    `F15_STORE : begin
						        memory_write_to_reg <= `RF_NONE;
						        memory_write_to_reg_enable <= 1'b0;
						        memory_store_data_reg <= `RF_R4;
						    
						        memory_load_request <= 1'b0;                                       
						        memory_store_request <= 1'b1;
						    end
						    `F15_LOAD : begin
						        memory_write_to_reg <= `RF_R4;
						        memory_write_to_reg_enable <= 1'b1;
						        memory_store_data_reg <= `RF_NONE;
						    
						        memory_load_request <= 1'b1;                                       
						        memory_store_request <= 1'b0;
						    end
						endcase
	                    
	                    stall_to_instructionfetch <= 1'b0;
	                    step <= 8'b1110_0000;
	                end
	                
	                8'b00100000 : begin
	                    casez (instruction[11])
						    `F15_STORE : begin
						        memory_write_to_reg <= `RF_NONE;
						        memory_write_to_reg_enable <= 1'b0;
						        memory_store_data_reg <= `RF_R5;
						    
						        memory_load_request <= 1'b0;                                       
						        memory_store_request <= 1'b1;
						    end
						    `F15_LOAD : begin
						        memory_write_to_reg <= `RF_R5;
						        memory_write_to_reg_enable <= 1'b1;
						        memory_store_data_reg <= `RF_NONE;
						    
						        memory_load_request <= 1'b1;                                       
						        memory_store_request <= 1'b0;
						    end
						endcase
	                    
	                    stall_to_instructionfetch <= 1'b0;
	                    step <= 8'b1100_0000;
	                end
	                
	                8'b01000000 : begin
	                    casez (instruction[11])
						    `F15_STORE : begin
						        memory_write_to_reg <= `RF_NONE;
						        memory_write_to_reg_enable <= 1'b0;
						        memory_store_data_reg <= `RF_R6;
						    
						        memory_load_request <= 1'b0;                                       
						        memory_store_request <= 1'b1;
						    end
						    `F15_LOAD : begin
						        memory_write_to_reg <= `RF_R6;
						        memory_write_to_reg_enable <= 1'b1;
						        memory_store_data_reg <= `RF_NONE;
						    
						        memory_load_request <= 1'b1;                                       
						        memory_store_request <= 1'b0;
						    end
						endcase
	                    
	                    stall_to_instructionfetch <= 1'b0;
	                    step <= 8'b1000_0000;
	                end
	                
	                8'b10000000 : begin
	                    casez (instruction[11])
						    `F15_STORE : begin
						        memory_write_to_reg <= `RF_NONE;
						        memory_write_to_reg_enable <= 1'b0;
						        memory_store_data_reg <= `RF_R7;
						    
						        memory_load_request <= 1'b0;                                       
						        memory_store_request <= 1'b1;
						    end
						    `F15_LOAD : begin
						        memory_write_to_reg <= `RF_R7;
						        memory_write_to_reg_enable <= 1'b1;
						        memory_store_data_reg <= `RF_NONE;
						    
						        memory_load_request <= 1'b1;                                       
						        memory_store_request <= 1'b0;
						    end
						endcase
	                    
	                    stall_to_instructionfetch <= 1'b0;
	                    step <= 8'b1111_1111;
	                end
	            
	            
	                // Zwischenschritte (stall_to_instructionfetch <= 1'b1);
	                8'b???????1 : begin
	                    casez (instruction[11])
						    `F15_STORE : begin
						        memory_write_to_reg <= `RF_NONE;
						        memory_write_to_reg_enable <= 1'b0;
						        memory_store_data_reg <= `RF_R0;
						    
						        memory_load_request <= 1'b0;                                       
						        memory_store_request <= 1'b1;
						    end
						    `F15_LOAD : begin
						        memory_write_to_reg <= `RF_R0;
						        memory_write_to_reg_enable <= 1'b1;
						        memory_store_data_reg <= `RF_NONE;
						    
						        memory_load_request <= 1'b1;                                       
						        memory_store_request <= 1'b0;
						    end
						endcase
	                    
	                    stall_to_instructionfetch <= 1'b1;
	                    step <= 8'b1111_1110;
	                end
	                
	                8'b??????10 : begin
	                    casez (instruction[11])
						    `F15_STORE : begin
						        memory_write_to_reg <= `RF_NONE;
						        memory_write_to_reg_enable <= 1'b0;
						        memory_store_data_reg <= `RF_R1;
						    
						        memory_load_request <= 1'b0;                                       
						        memory_store_request <= 1'b1;
						    end
						    `F15_LOAD : begin
						        memory_write_to_reg <= `RF_R1;
						        memory_write_to_reg_enable <= 1'b1;
						        memory_store_data_reg <= `RF_NONE;
						    
						        memory_load_request <= 1'b1;                                       
						        memory_store_request <= 1'b0;
						    end
						endcase
	                    
	                    stall_to_instructionfetch <= 1'b1;
	                    step <= 8'b1111_1100;
	                end
	                
	                8'b?????100 : begin
	                    casez (instruction[11])
						    `F15_STORE : begin
						        memory_write_to_reg <= `RF_NONE;
						        memory_write_to_reg_enable <= 1'b0;
						        memory_store_data_reg <= `RF_R2;
						    
						        memory_load_request <= 1'b0;                                       
						        memory_store_request <= 1'b1;
						    end
						    `F15_LOAD : begin
						        memory_write_to_reg <= `RF_R2;
						        memory_write_to_reg_enable <= 1'b1;
						        memory_store_data_reg <= `RF_NONE;
						    
						        memory_load_request <= 1'b1;                                       
						        memory_store_request <= 1'b0;
						    end
						endcase
	                    
	                    stall_to_instructionfetch <= 1'b1;
	                    step <= 8'b1111_1000;
	                end
	                
	                8'b????1000 : begin
	                    casez (instruction[11])
						    `F15_STORE : begin
						        memory_write_to_reg <= `RF_NONE;
						        memory_write_to_reg_enable <= 1'b0;
						        memory_store_data_reg <= `RF_R3;
						    
						        memory_load_request <= 1'b0;                                       
						        memory_store_request <= 1'b1;
						    end
						    `F15_LOAD : begin
						        memory_write_to_reg <= `RF_R3;
						        memory_write_to_reg_enable <= 1'b1;
						        memory_store_data_reg <= `RF_NONE;
						    
						        memory_load_request <= 1'b1;                                       
						        memory_store_request <= 1'b0;
						    end
						endcase
	                    
	                    stall_to_instructionfetch <= 1'b1;
	                    step <= 8'b1111_0000;
	                end
	                
	                8'b???10000 : begin
	                    casez (instruction[11])
						    `F15_STORE : begin
						        memory_write_to_reg <= `RF_NONE;
						        memory_write_to_reg_enable <= 1'b0;
						        memory_store_data_reg <= `RF_R4;
						    
						        memory_load_request <= 1'b0;                                       
						        memory_store_request <= 1'b1;
						    end
						    `F15_LOAD : begin
						        memory_write_to_reg <= `RF_R4;
						        memory_write_to_reg_enable <= 1'b1;
						        memory_store_data_reg <= `RF_NONE;
						    
						        memory_load_request <= 1'b1;                                       
						        memory_store_request <= 1'b0;
						    end
						endcase
	                    
	                    stall_to_instructionfetch <= 1'b1;
	                    step <= 8'b1110_0000;
	                end
	                
	                8'b??100000 : begin
	                    casez (instruction[11])
						    `F15_STORE : begin
						        memory_write_to_reg <= `RF_NONE;
						        memory_write_to_reg_enable <= 1'b0;
						        memory_store_data_reg <= `RF_R5;
						    
						        memory_load_request <= 1'b0;                                       
						        memory_store_request <= 1'b1;
						    end
						    `F15_LOAD : begin
						        memory_write_to_reg <= `RF_R5;
						        memory_write_to_reg_enable <= 1'b1;
						        memory_store_data_reg <= `RF_NONE;
						    
						        memory_load_request <= 1'b1;                                       
						        memory_store_request <= 1'b0;
						    end
						endcase
	                    
	                    stall_to_instructionfetch <= 1'b1;
	                    step <= 8'b1100_0000;
	                end
	                
	                8'b?1000000 : begin
	                    casez (instruction[11])
						    `F15_STORE : begin
						        memory_write_to_reg <= `RF_NONE;
						        memory_write_to_reg_enable <= 1'b0;
						        memory_store_data_reg <= `RF_R6;
						    
						        memory_load_request <= 1'b0;                                       
						        memory_store_request <= 1'b1;
						    end
						    `F15_LOAD : begin
						        memory_write_to_reg <= `RF_R6;
						        memory_write_to_reg_enable <= 1'b1;
						        memory_store_data_reg <= `RF_NONE;
						    
						        memory_load_request <= 1'b1;                                       
						        memory_store_request <= 1'b0;
						    end
						endcase
	                    
	                    stall_to_instructionfetch <= 1'b1;
	                    step <= 8'b1000_0000;
	                end
	                
	                // sollte nie passieren
	                default: begin                     
	                    casez (instruction[11])
						    `F15_STORE : begin
						        memory_write_to_reg <= `RF_NONE;
						        memory_write_to_reg_enable <= 1'b0;
						        memory_store_data_reg <= `RF_R0;
						    
						        memory_load_request <= 1'b0;                                       
						        memory_store_request <= 1'b1;
						    end
						    `F15_LOAD : begin
						        memory_write_to_reg <= `RF_R0;
						        memory_write_to_reg_enable <= 1'b1;
						        memory_store_data_reg <= `RF_NONE;
						    
						        memory_load_request <= 1'b1;                                       
						        memory_store_request <= 1'b0;
						    end
						endcase
						
						stall_to_instructionfetch <= 1'b1;
	                    step <= 8'b1111_1111;
	                end
	                
	            endcase
	            
	        end
	        
	        `FORMAT_16_17  : begin                                
	            operand_a <= `RF_R15_PC;
	            operand_b <= `RF_IMM;
	            
	            offset_a <= `IMM_ZERO;
	            
	            // immediate is signed for format 16 and 17
	            offset_b <= instruction[7] ?  {23'b1111_1111_1111_1111_1111_111, instruction[7:0], 1'b0} : {23'b0000_0000_0000_0000_0000_0, instruction[7:0], 1'b0};
	            
	            alu_opcode  <= `ADD;
	            
	            update_flag_n <= 1'b0;
	            update_flag_z <= 1'b0;
	            update_flag_c <= 1'b0;
	            update_flag_v <= 1'b0;
	            
	            alu_write_to_reg <= `RF_R15_PC;
	            memory_write_to_reg <= `RF_NONE;
	            memory_write_to_reg_enable <= 1'b0;
	            
	            memory_store_data_reg <= `RF_NONE;
	            memory_store_address_reg <= `RF_NONE;
	            memory_address_source_is_reg <= 1'b0;
	            load_store_width <= `WORD;
	            memorycontroller_sign_extend <= 1'b0;
	
	            memory_load_request <= 1'b0;
	            memory_store_request <= 1'b0;
	            
	            stack_push_request <= 1'b0;
	            stack_pop_request <= 1'b0;
	            
	            stall_to_instructionfetch       <= 0;
	            step                            <= 8'b1111_1111;
	            
	            casez (instruction[11:8])
	//                 `F16_BEQ     : alu_write_to_reg_enable <= flag_z ?  1'b1 :  1'b0;
	//                 `F16_BNE     : alu_write_to_reg_enable <= flag_z ?  1'b0 :  1'b1; 
	//                 `F16_BCS     : alu_write_to_reg_enable <= flag_c ?  1'b1 :  1'b0; 
	//                 `F16_BCC     : alu_write_to_reg_enable <= flag_c ?  1'b0 :  1'b1; 
	//                 `F16_BMI     : alu_write_to_reg_enable <= flag_n ?  1'b1 :  1'b0; 
	//                 `F16_BPL     : alu_write_to_reg_enable <= flag_n ?  1'b0 :  1'b1; 
	//                 `F16_BVS     : alu_write_to_reg_enable <= flag_v ?  1'b1 :  1'b0; 
	//                 `F16_BVC     : alu_write_to_reg_enable <= flag_v ?  1'b0 :  1'b1; 
	//                 `F16_BHI     : alu_write_to_reg_enable <= (flag_c & !flag_z) ?  1'b1 :  1'b0;
	//                 `F16_BLS     : alu_write_to_reg_enable <= (!flag_c | flag_z) ?  1'b1 :  1'b0; 
	//                 `F16_BGE     : alu_write_to_reg_enable <= ((flag_n & flag_v) | (!flag_n & !flag_v)) ?  1'b1 :  1'b0;
	//                 `F16_BLT     : alu_write_to_reg_enable <= ((flag_n & !flag_v) | (!flag_n & flag_v)) ?  1'b1 :  1'b0;
	//                 `F16_BGT     : alu_write_to_reg_enable <= (!flag_z & ((flag_n & flag_v) | (!flag_n & !flag_v)) ) ?  1'b1 :  1'b0;       
	//                 `F16_BLE     : alu_write_to_reg_enable <= (flag_z | ((flag_n & !flag_v) | (!flag_n & flag_v)) ) ?  1'b1 :  1'b0;   
	//                 `F16_ILLEGAL : alu_write_to_reg_enable <= 1'b0;  // sollte nie passieren
	//                 `F17_SWI     : alu_write_to_reg_enable <= 1'b0;  // sollte nie passieren, nicht implementiert
	
	                `F16_ILLEGAL : alu_write_to_reg_enable <= 1'b0;  // sollte nie passieren
	                `F17_SWI     : alu_write_to_reg_enable <= 1'b0;  // sollte nie passieren, nicht implementiert
	                
	                default : alu_write_to_reg_enable <= f_flageval(instruction[11:8], flag_z, flag_c, flag_n, flag_v);
	                
	            endcase
	            
	
	
	        end
	        
	        `FORMAT_18  : begin                                
	            operand_a <= `RF_R15_PC;
	            operand_b <= `RF_IMM;
	            
	            offset_a <= `IMM_ZERO;
	            offset_b <= {20'b0000_0000_0000_0000_0000, instruction[10:0], 1'b0};
	            
	            alu_opcode  <= `ADD;
	            
	            update_flag_n <= 1'b0;
	            update_flag_z <= 1'b0;
	            update_flag_c <= 1'b0;
	            update_flag_v <= 1'b0;
	            
	            alu_write_to_reg <= `RF_R15_PC;
	            alu_write_to_reg_enable <= 1'b1;
	            memory_write_to_reg <= `RF_NONE;
	            memory_write_to_reg_enable <= 1'b0;
	            
	            memory_store_data_reg <= `RF_NONE;
	            memory_store_address_reg <= `RF_NONE;
	            memory_address_source_is_reg <= 1'b0;
	            load_store_width <= `WORD;
	            memorycontroller_sign_extend <= 1'b0;
	            
	            stack_push_request <= 1'b0;
	            stack_pop_request <= 1'b0;
	
	            memory_load_request <= 1'b0;
	            memory_store_request <= 1'b0;
	            
	            stall_to_instructionfetch       <= 0;
	            step                            <= 8'b1111_1111;
	        
	        end
	        
	        `FORMAT_19  : begin                         
	            operand_b <= `RF_IMM;
	            
	            offset_a <= `IMM_ZERO;
	            
	            update_flag_n <= 1'b0;
	            update_flag_z <= 1'b0;
	            update_flag_c <= 1'b0;
	            update_flag_v <= 1'b0;
	            
	            alu_write_to_reg_enable <= 1'b1;
	            memory_write_to_reg <= `RF_NONE;
	            memory_write_to_reg_enable <= 1'b0;
	            
	            memory_store_data_reg <= `RF_NONE;
	            memory_store_address_reg <= `RF_NONE;
	            memory_address_source_is_reg <= 1'b0;
	            load_store_width <= `WORD;
	            memorycontroller_sign_extend <= 1'b0;
	            
	            memory_load_request <= 1'b0;                                       
	            memory_store_request <= 1'b0;
	            
	            stack_push_request <= 1'b0;
	            stack_pop_request <= 1'b0;
	            
	            casez (instruction[11])
	                `F19_HIGH : begin
	                    operand_a <= `RF_R15_PC;
	                    
	                    offset_b <= {9'b0000_0000_0, instruction[10:0], 12'b0000_0000_0000};
	                    
	                    alu_opcode <= `ADD;
	                    
	                    alu_write_to_reg <= `RF_R14_LR;
	                    
	                    stall_to_instructionfetch <= 0;
	                    
	                    step <= 8'b1111_1111;
	                end
	                `F19_LOW : begin
	                
	                    casez (step)
	                    
	                        8'b????_???1 : begin
	                            operand_a <= `RF_R15_PC;
	                            
	                            offset_b <= {32'b0000_0000_0000_0000_0000_0000_0000_0010};
	                            
	                            alu_opcode <= `SUB;
	                            
	                            alu_write_to_reg <= `RF_TMP1;
	                            
	                            stall_to_instructionfetch <= 1'b1;
	                            
	                            step <= 8'b1111_1110;
	                        end
	                        
	                        8'b????_??10 : begin
	                            operand_a <= `RF_R14_LR;
	                            
	                            offset_b <= {20'b0000_0000_0000_0000_0000, instruction[10:0], 1'b0};
	                            
	                            alu_opcode <= `ADD;
	                            
	                            alu_write_to_reg <= `RF_R15_PC;
	                            
	                            stall_to_instructionfetch <= 1'b1;
	                            
	                            step <= 8'b1111_1100;
	                        end
	                        
	                        8'b????_?100 : begin
	                            operand_a <= `RF_TMP1;
	                            
	                            offset_b <= {32'b0000_0000_0000_0000_0000_0000_0000_0001};
	
	                            alu_opcode <= `ORR;
	                            
	                            alu_write_to_reg <= `RF_R14_LR;
	                            
	                            stall_to_instructionfetch <= 1'b0;
	                            
	                            step <= 8'b1111_1111;
	                        end
	                    endcase
	                    
	                end
	            endcase
	            
	        end
	        
	        `FORMAT_20  : begin                               
                // IT-Instruction
                //
                // Wertübernahme in Extrablock, also nichts machen
                //
                //
	            operand_a <= `RF_NONE;
	            operand_b <= `RF_NONE;
	            
	            // siehe Beispiel mit den 844 = 211 (844 / 4) im Opcode wegen 
	            // wegen immediate = word8, Linksshift von offset_b um 2 
	            
	            offset_a <= `IMM_ZERO;
	            offset_b <= `IMM_ZERO;
	            
	            alu_opcode <= `ORR;
	            
	            update_flag_n <= 1'b0;
	            update_flag_z <= 1'b0;
	            update_flag_c <= 1'b0;
	            update_flag_v <= 1'b0;
	            
	            alu_write_to_reg <= `RF_NONE;
	            alu_write_to_reg_enable <= 1'b0;
	            
	            memory_write_to_reg <= `RF_NONE;
	            memory_write_to_reg_enable <= 1'b0;
	
	            memory_store_data_reg <= `RF_NONE;
	            memory_store_address_reg <= `RF_NONE;
	            memory_address_source_is_reg <= 1'b0;
	            load_store_width <= `WORD;
	            memorycontroller_sign_extend <= 1'b0;
	            
	            memory_load_request <= 1'b0;                                       
	            memory_store_request <= 1'b0;
	             
	            stack_push_request <= 1'b0;
	            stack_pop_request <= 1'b0;
	            
	            stall_to_instructionfetch       <= 0;
	
	            step                            <= 8'b1111_1111;
	            
	        end
	        
	        
	     
	        default : begin                          // sollte nie passieren
	                                
				operand_a                       <= `RF_NONE;
				operand_b                       <= `RF_NONE;
				                                
				offset_a                        <= `IMM_ZERO;
				offset_b                        <= `IMM_ZERO;
				                                
				alu_opcode                      <= `ORR;
				                                
				update_flag_n                   <= 0;
				update_flag_z                   <= 0;
				update_flag_c                   <= 0;
				update_flag_v                   <= 0;
				                                
				alu_write_to_reg                <= `RF_NONE;
				alu_write_to_reg_enable         <= 0;
				memory_write_to_reg             <= `RF_NONE;
				memory_write_to_reg_enable      <= 0;
				                                
				memory_store_data_reg                <= `RF_NONE;
				memory_store_address_reg <= `RF_NONE;
	            memory_address_source_is_reg <= 1'b0;
				load_store_width                <= `WORD;
				memorycontroller_sign_extend    <= 0;
				                                
				memory_load_request                    <= 0;
				memory_store_request                   <= 0;
				
	            stack_push_request <= 1'b0;
	            stack_pop_request <= 1'b0;
				                                
				stall_to_instructionfetch       <= 1;
	
				step                            <= 8'b1111_1111;
	        
	        end
		endcase
	
	
	end // if-block ITSTATE
	
	else begin // else-block ITSTATE
	
    // synthesis translate off
        exec_cond_true <= 1'b0;
    // synthesis translate on
	
	// nichts machen
	                                
				operand_a                       <= `RF_NONE;
				operand_b                       <= `RF_NONE;
				                                
				offset_a                        <= `IMM_ZERO;
				offset_b                        <= `IMM_ZERO;
				                                
				alu_opcode                      <= `ORR;
				                                
				update_flag_n                   <= 0;
				update_flag_z                   <= 0;
				update_flag_c                   <= 0;
				update_flag_v                   <= 0;
				                                
				alu_write_to_reg                <= `RF_NONE;
				alu_write_to_reg_enable         <= 0;
				memory_write_to_reg             <= `RF_NONE;
				memory_write_to_reg_enable      <= 0;
				                                
				memory_store_data_reg                <= `RF_NONE;
				memory_store_address_reg <= `RF_NONE;
	            memory_address_source_is_reg <= 1'b0;
				load_store_width                <= `WORD;
				memorycontroller_sign_extend    <= 0;
				                                
				memory_load_request                    <= 0;
				memory_store_request                   <= 0;
				
	            stack_push_request <= 1'b0;
	            stack_pop_request <= 1'b0;
				                                
				stall_to_instructionfetch       <= 0;
	
				step                            <= 8'b1111_1111;
	        
	
	end // else-block ITSTATE

end //if-block no_stall or reset

else if (stall_from_memorycontroller & !reset) begin // else-if-block memstall 

    // alu_write_enables & stack_requests auf 0 setzen

	operand_a                       <= operand_a;
	operand_b                       <= operand_b;
	                                
	offset_a                        <= offset_a;
	offset_b                        <= offset_b;
	                                
	alu_opcode                      <= alu_opcode;
	                                
	update_flag_n                   <= 1'b0;
	update_flag_z                   <= 1'b0;
	update_flag_c                   <= 1'b0;
	update_flag_v                   <= 1'b0;
	                                
	alu_write_to_reg                <= alu_write_to_reg;
	alu_write_to_reg_enable         <= 1'b0;
	memory_write_to_reg             <= memory_write_to_reg;
	memory_write_to_reg_enable      <= memory_write_to_reg_enable;
	                                
	memory_store_data_reg           <= memory_store_data_reg;
	memory_store_address_reg        <= memory_store_address_reg;
	memory_address_source_is_reg    <= memory_address_source_is_reg;
	load_store_width                <= load_store_width;
	memorycontroller_sign_extend    <= memorycontroller_sign_extend;
	                                
	memory_load_request             <= memory_load_request;
	memory_store_request            <= memory_store_request;
	
	stack_push_request              <= 1'b0;
	stack_pop_request               <= 1'b0;
	                                
	stall_to_instructionfetch       <= stall_to_instructionfetch;
	
	step                            <= step;
	
	// synthesis translate off
        exec_cond_true <= exec_cond_true;
    // synthesis translate on

end // else-if-block memstall

else if (reset) begin  // 

stall_to_instructionfetch <= 1'b0;

			operand_a                       <= `RF_NONE;
			operand_b                       <= `RF_NONE;
			                                
			offset_a                        <= `IMM_ZERO;
			offset_b                        <= `IMM_ZERO;
			                                
			alu_opcode                      <= `ORR;
			                                
			update_flag_n                   <= 0;
			update_flag_z                   <= 0;
			update_flag_c                   <= 0;
			update_flag_v                   <= 0;
			                                
			alu_write_to_reg                <= `RF_NONE;
			alu_write_to_reg_enable         <= 0;
			memory_write_to_reg             <= `RF_NONE;
			memory_write_to_reg_enable      <= 0;
			                                
			memory_store_data_reg                <= `RF_NONE;
			memory_store_address_reg <= `RF_NONE;
            memory_address_source_is_reg <= 1'b0;
			load_store_width                <= `WORD;
			memorycontroller_sign_extend    <= 0;
			                                
			memory_load_request                    <= 0;
			memory_store_request                   <= 0;
			
            stack_push_request <= 1'b0;
            stack_pop_request <= 1'b0;
			                                
			stall_to_instructionfetch       <= 0;
			                                
			step                            <= 8'b1111_1111;
			
        // synthesis translate off
            exec_cond_true <= 1'b0;
        // synthesis translate on

end // else if-Block


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
		`J	: $sformat(instruction, "0x%05H  J       %5h       ", 	pc, pc+offset_a);
		`JALS	: $sformat(instruction, "0x%05H  JALS    %5h       ", 	pc, pc+offset_a);
		`JR	: $sformat(instruction, "0x%05H  JR      r%2d         ", 	pc, r_no_b);
		`JALR	: $sformat(instruction, "0x%05H  JALR    r%2d         ", 	pc, r_no_b);
		`JRS	: $sformat(instruction, "0x%05H  JRS     r%2d         ", 	pc, r_no_b);
		`RFE	: $sformat(instruction, "0x%05H  RFE     r%2d         ", 	pc, r_no_b);
		`JALRS	: $sformat(instruction, "0x%05H  JALRS   r%2d         ", 	pc, r_no_b);

		`BEQZ	: $sformat(instruction, "0x%05H  BEQZ    r%2d, %h  ", 	pc, r_no_a, pc+imm);
		`BNEZ	: $sformat(instruction, "0x%05H  BNEZ    r%2d, %h  ", 	pc, r_no_a, pc+imm);
		`BEQZC	: $sformat(instruction, "0x%05H  BEQZC   %5h       ",	pc, pc+offset_a);
		`BNEZC	: $sformat(instruction, "0x%05H  BNEZC   %5h       ", 	pc, pc+offset_a);

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
