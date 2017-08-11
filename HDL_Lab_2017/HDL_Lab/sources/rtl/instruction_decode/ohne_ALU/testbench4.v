module testbench4();

// ======
// Inputs
// ======
reg clock;
reg reset;
reg [15:0] instruction;


reg stall_from_instructionfetch; 
reg stall_from_memorycontroller;


// =======
// Outputs
// =======

wire  [1:0] load_store_width;
wire memorycontroller_sign_extend;

wire memory_load_request;
wire memory_store_request;

wire stack_push_request;
wire stack_pop_request;

wire stall_to_instructionfetch;

wire decoder_pc_update;

// *************************************

wire [31:0] MEMCTRL_IN_address;
wire [31:0] RF_MEMCTRL_data_reg;

wire [31:0] MEMCTRL_RF_data_in;

wire [31:0] RF_pc_out;
wire [31:0] RF_sp_out;

// ======
// Inouts
// ======

// NONE

// =============
// Instantiation
// =============
top4 UUT (
	/* input */          .clock                            (  clock                           ),
	/* input */          .reset                            (  reset                           ),
    /* input */          .instruction                      (  instruction                     ),
                                                                                              
                                                                                              
	/* input */          .stall_from_instructionfetch      (  stall_from_instructionfetch     ),
	/* input */          .stall_from_memorycontroller      (  stall_from_memorycontroller     ),



	
   
    /* output */         .load_store_width                 (   load_store_width               ),
    /* output */         .memorycontroller_sign_extend     (   memorycontroller_sign_extend   ),

    /* output */         .memory_load_request              (   memory_load_request            ),
    /* output */         .memory_store_request             (   memory_store_request           ),

    /* output */         .stack_push_request               (   stack_push_request             ),
    /* output */         .stack_pop_request                (   stack_pop_request              ),

    /* output */         .stall_to_instructionfetch        (   stall_to_instructionfetch      ),

    /* output */         .decoder_pc_update                (   decoder_pc_update              ),
    
    
    /* output */         .MEMCTRL_IN_address               (   MEMCTRL_IN_address             ),
    /* output */         .RF_MEMCTRL_data_reg              (   RF_MEMCTRL_data_reg            ),
    
    /* output */         .MEMCTRL_RF_data_in               (   MEMCTRL_RF_data_in             ),

    /* output */         .RF_pc_out                        (   RF_pc_out                      ),
    /* output */         .RF_sp_out                        (   RF_sp_out                      )
	
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
clock = 1'b0;
reset = 1'b0;
          
instruction                     = 0;
                                                             
stall_from_instructionfetch     = 0;
stall_from_memorycontroller     = 0;

#20;
reset = 1;
#20;
reset = 0;
#20;

instruction = 16'h2005; 
#20;
instruction = 16'h210a;
#20;
instruction = 16'h220f; 
#20;
instruction = 16'h2314;  
#20;
instruction = 16'h2419;  
#20;
instruction = 16'h251e; 
#20;
instruction = 16'h2623;
#20;
instruction = 16'h2728;
#20;
instruction = 16'h1840;
#20;
instruction = 16'h1b12;
#20;
instruction = 16'h4378;
#20;
instruction = 16'h089b;
#20;
instruction = 16'h3601;
#20;
instruction = 16'h46c0;
#20;








end



endmodule 
 
