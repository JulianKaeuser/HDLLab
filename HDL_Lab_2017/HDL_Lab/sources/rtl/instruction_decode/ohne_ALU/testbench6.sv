// Integrated Electronic Systems Lab
// TU Darmstadt
// Author:	Dipl.-Ing. Boris Traskov
// Modified by M.Sc. Haoyuan Ying Dual 8-bit Memory Port -> Single 16-bit
// Email: 	boris.traskov@ies.tu-darmstadt.de

`timescale 1 ns / 1 ps

module testbench6();

// PARAMETERS
parameter MEM_DEPTH   		= 2**12;	//8192 Bytes 4096*2B
parameter ADDR_WIDTH   		= $clog2(MEM_DEPTH);
parameter string filename	= "mem_uninitialized.bin";

// ================
// Internal Signals
// ================

integer file, status; // needed for file-io

logic			clock;
logic			reset;

// ================
// Memory Interface
// ================

logic  [15:0] MEM_MEMCTRL_from_mem_data;

logic         MEMCTRL_MEM_to_mem_read_enable   ;     
logic         MEMCTRL_MEM_to_mem_write_enable  ;     
logic         MEMCTRL_MEM_to_mem_mem_enable    ;     
logic  [11:0] MEMCTRL_MEM_to_mem_address       ;     
logic  [15:0] MEMCTRL_MEM_to_mem_data          ;

// ======
// Inputs
// ======
// logic          clock;
// logic          reset;
logic          [15:0] instruction;
       
logic          stall_from_instructionfetch; 

// =======
// Outputs
// =======
      
logic          stall_to_instructionfetch;
       
logic          decoder_pc_update;
     
logic          [31:0] RF_pc_out;





// =================
// CPU Instantiation
// =================
top5 UUT (
                                                                                            
    /* input */          .clock                              ( clock                               ),
    /* input */          .reset                              ( reset                               ),
    /* input */          .instruction                        ( instruction                         ),
                                                                                                  
    /* input */          .stall_from_instructionfetch        ( stall_from_instructionfetch         ),
                                                                                                   
    /* output */         .stall_to_instructionfetch          ( stall_to_instructionfetch           ),
                                                                                                  
    /* output */         .decoder_pc_update                  ( decoder_pc_update                   ),
                                                                                                   
    /* output */         .RF_pc_out                          ( RF_pc_out                           ),
                                                                                                  
    // ***************************************************                                        
                                                                                                  
    /* input */          .MEM_MEMCTRL_from_mem_data          ( MEM_MEMCTRL_from_mem_data           ),
                                                                                                   
    /* output */         .MEMCTRL_MEM_to_mem_read_enable     ( MEMCTRL_MEM_to_mem_read_enable      ),
    /* output */         .MEMCTRL_MEM_to_mem_write_enable    ( MEMCTRL_MEM_to_mem_write_enable     ),
    /* output */         .MEMCTRL_MEM_to_mem_mem_enable      ( MEMCTRL_MEM_to_mem_mem_enable       ),
    /* output */         .MEMCTRL_MEM_to_mem_address         ( MEMCTRL_MEM_to_mem_address          ),
    /* output */         .MEMCTRL_MEM_to_mem_data            ( MEMCTRL_MEM_to_mem_data             )
                                                                                                   

);

	
	
	

//  MEMORY MODULE INSTANTIATION
memory #(
	.MEM_DEPTH (MEM_DEPTH)) 
memory_i (
   	.clk 	(clock),
    .addr	(MEMCTRL_MEM_to_mem_address),
    .en  	(MEMCTRL_MEM_to_mem_mem_enable),
    .rd_en  (MEMCTRL_MEM_to_mem_read_enable),
    .wr_en  (MEMCTRL_MEM_to_mem_write_enable),
    .din (MEMCTRL_MEM_to_mem_data),
    .dout(MEM_MEMCTRL_from_mem_data)
    );
  
// CLOCK GENERATOR
initial begin
	clock = 1'b0;
	forever #1  clock = !clock;
end

// RESET GENERATOR  
initial begin
	reset			= 1'b0;
	file		= $fopen(filename, "r");
	#3 reset		= 1'b1;     // 3   ns
	status		= $fread(memory_i.ram, file);
	#2.1 reset	= 1'b0;  //2.1 ns
//	$finish;
end

// STIMULI
initial begin
          
instruction                     = 16'h0000;
                                                             
stall_from_instructionfetch     = 1'b0;


#2;
#2;
#2;


instruction = 16'hb580;  // PUSH_R7_LR 
#2;
#2;
instruction = 16'h2300;  // MOVS_R3_0
#2;
instruction = 16'h1c18;  // ADDS_R0_R3_0
#2;
instruction = 16'hb580;  // PUSH_R7_LR 
#2;
#2;
instruction = 16'haf02;  // ADD_R7_SP_8 
#2;
instruction = 16'haf02;  // ADD_R7_SP_8 
#2;
instruction = 16'hbd80;  // POP_R7_PC
#2;
#2;
instruction = 16'haf02;  // ADD_R7_SP_8 
#2;




end



endmodule
