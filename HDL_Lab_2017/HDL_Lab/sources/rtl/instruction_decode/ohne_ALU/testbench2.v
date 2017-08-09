`timescale 1ns / 1ps 
module testbench2();

// ======
// Inputs
// ======
reg clock;
reg reset;
reg [15:0] instruction;

reg flag_z;
reg flag_c;
reg flag_n;
reg flag_v;

reg stall_from_instructionfetch; 
reg stall_from_memorycontroller;

// =======
// Outputs
// =======
wire  [4:0] operand_a;              // für 8-fach Registerfile Bit 3 ignorieren: {operand_a[4], operand_a[3:0]}
wire  [4:0] operand_b;

wire [31:0] offset_a;
wire [31:0] offset_b;

wire  [4:0] alu_opcode;

wire update_flag_n;
wire update_flag_z;
wire update_flag_c;
wire update_flag_v;

wire  [4:0] alu_write_to_reg;
wire alu_write_to_reg_enable; 
wire  [4:0] memory_write_to_reg;
wire memory_write_to_reg_enable;

wire  [4:0] memory_store_data_reg;
wire  [4:0] memory_store_address_reg;
wire memory_address_source_is_reg;
wire  [1:0] load_store_width;
wire memorycontroller_sign_extend;

wire memory_load_request;
wire memory_store_request;

wire stack_push_request;
wire stack_pop_request;

wire stall_to_instructionfetch;

wire decoder_pc_update;

// ======
// Inouts
// ======



// =============
// Instantiation
// =============
irdecode UUT (
	/* input */          .clock                            (  clock                           ),
	/* input */          .reset                            (  reset                           ),
    /* input */          .instruction                      (  instruction                     ),
                                                                                              
	/* input */          .flag_z                           (  flag_z                          ),
	/* input */          .flag_c                           (  flag_c                          ),
	/* input */          .flag_n                           (  flag_n                          ),
	/* input */          .flag_v                           (  flag_v                          ),
                                                                                              
	/* input */          .stall_from_instructionfetch      (  stall_from_instructionfetch     ),
	/* input */          .stall_from_memorycontroller      (  stall_from_memorycontroller     ),



	
    /* output */         .operand_a                        (   operand_a                      ),
    /* output */         .operand_b                        (   operand_b                      ),

    /* output */         .offset_a                         (   offset_a                       ),
    /* output */         .offset_b                         (   offset_b                       ),

    /* output */         .alu_opcode                       (   alu_opcode                     ),

    /* output */         .update_flag_n                    (   update_flag_n                  ),
    /* output */         .update_flag_z                    (   update_flag_z                  ),
    /* output */         .update_flag_c                    (   update_flag_c                  ),
    /* output */         .update_flag_v                    (   update_flag_v                  ),

    /* output */         .alu_write_to_reg                 (   alu_write_to_reg               ),
    /* output */         .alu_write_to_reg_enable          (   alu_write_to_reg_enable        ),
    /* output */         .memory_write_to_reg              (   memory_write_to_reg            ),
    /* output */         .memory_write_to_reg_enable       (   memory_write_to_reg_enable     ),

    /* output */         .memory_store_data_reg            (   memory_store_data_reg          ),
    /* output */         .memory_store_address_reg         (   memory_store_address_reg       ),    
    /* output */         .memory_address_source_is_reg     (   memory_address_source_is_reg   ),    
    /* output */         .load_store_width                 (   load_store_width               ),
    /* output */         .memorycontroller_sign_extend     (   memorycontroller_sign_extend   ),

    /* output */         .memory_load_request              (   memory_load_request            ),
    /* output */         .memory_store_request             (   memory_store_request           ),

    /* output */         .stack_push_request               (   stack_push_request             ),
    /* output */         .stack_pop_request                (   stack_pop_request              ),

    /* output */         .stall_to_instructionfetch        (   stall_to_instructionfetch      ),

    /* output */         .decoder_pc_update                (   decoder_pc_update              )
	
	);

// ======
// Clocks
// ======
// 50.0MHz clock 

always #(10.000) clock=~clock;

// =======
// Stimuli
// =======


initial begin
clock = 0;
reset = 0;
          
instruction                     = 0;
                                
flag_z                          = 0;
flag_c                          = 0;
flag_n                          = 0;
flag_v                          = 0;
                                
stall_from_instructionfetch     = 0;
stall_from_memorycontroller     = 0;

#20;
reset = 1;
#20;
reset = 0;
#20;

instruction = 16'hb580;
#20;
instruction = 16'hb081;
#20;
instruction = 16'haf00;
#20;
instruction = 16'h1c3a;
#20;
instruction = 16'h2300; 
#20;
instruction = 16'h6013; 
#20;
instruction = 16'he00c; 
#20;
instruction = 16'h1c3b; 
#20;
instruction = 16'h6819; 
#20;
instruction = 16'h1c3b; 
#20;
instruction = 16'h681a;  
#20;
instruction = 16'h4b09;  
#20;
instruction = 16'h5c9b;  
#20;
instruction = 16'h4a09;  
#20;
instruction = 16'h5453;  
#20;
instruction = 16'h1c3a;   
#20;
instruction = 16'h1c3b;  
#20;
instruction = 16'h681b;  
#20;
instruction = 16'h3301;  
#20;
instruction = 16'h6013;  
#20;
instruction = 16'h1c3b;  
#20;
instruction = 16'h681b;  
#20;
instruction = 16'h2b2d;  
#20;
instruction = 16'hddee;   
#20;
instruction = 16'h2300;  
#20;
instruction = 16'h1c18;   
#20;
instruction = 16'h46bd; 
#20;
instruction = 16'hb001; 
#20;
instruction = 16'hbd80;  
#20;
instruction = 16'h0000; 
#20;


//0000003c <.text+0x3c> 0200  
//0000003e <.text+0x3e> 0000  
//00000040 <.text+0x40> 0230  
//00000042 <.text+0x42> 0000  


end



endmodule 
