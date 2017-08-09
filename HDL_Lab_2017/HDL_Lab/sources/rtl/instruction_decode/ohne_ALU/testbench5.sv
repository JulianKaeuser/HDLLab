// Integrated Electronic Systems Lab
// TU Darmstadt
// Author:	Dipl.-Ing. Boris Traskov
// Modified by M.Sc. Haoyuan Ying Dual 8-bit Memory Port -> Single 16-bit
// Email: 	boris.traskov@ies.tu-darmstadt.de

`timescale 1 ns / 1 ps

module testbench5();

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
// test_regfile_mem_ops.s

instruction = 16'h2005; 
#2;
instruction = 16'h210a;
#2;
instruction = 16'h220f; 
#2;
instruction = 16'h2314;  
#2;
instruction = 16'h2419;  
#2;
instruction = 16'h251e; 
#2;
instruction = 16'h2623;
#2;
instruction = 16'h2728;
#2;
instruction = 16'h1840;
#2;
instruction = 16'h1b12;
#2;
instruction = 16'h4378;
#2;
instruction = 16'h089b;
#2;
instruction = 16'h3601;
#2;

instruction = 16'h6000; 
#2;
#2;
#2;
instruction = 16'h6041;
#2;
#2;
#2;
instruction = 16'h6082; 
#2;
#2;
#2;
instruction = 16'h60c3;  
#2;
#2;
#2;
instruction = 16'h6104;  
#2;
#2;
#2;
instruction = 16'h6145; 
#2;
#2;
#2;
instruction = 16'h6186;
#2;
#2;
#2;
instruction = 16'h61c7;
#2;
#2;
#2;
instruction = 16'h19bf;
#2;
instruction = 16'h1a36;
#2;
instruction = 16'h69c7;
#2;
#2;
#2;
instruction = 16'h6986;
#2;
#2;
#2;
instruction = 16'h46c0;
#2;

// test_multi_loadstore.s
instruction = 16'h2005; 
#2;
instruction = 16'h210a;
#2;
instruction = 16'h220f; 
#2;
instruction = 16'h2314;  
#2;
instruction = 16'h2419;  
#2;
instruction = 16'h251e; 
#2;
instruction = 16'h2623;
#2;
instruction = 16'h2728;
#2;
instruction = 16'hc0fe;
#2;
#2;
#2;

#2;
#2;
#2;

#2;
#2;
#2;

#2;
#2;
#2;

#2;
#2;
#2;

#2;
#2;
#2;

#2;
#2;
#2;

instruction = 16'h1840;
#2;

instruction = 16'h2005;      // movs	r0, #5
#2;
instruction = 16'h210a;      // movs	r1, #10
#2;
instruction = 16'h220f;      // movs	r2, #15
#2;
instruction = 16'h2314;      // movs	r3, #20
#2;
instruction = 16'h2419;      // movs	r4, #25
#2;
instruction = 16'h4680;      // mov	r8, r0
#2;
instruction = 16'h4689;      // mov	r9, r1
#2;
instruction = 16'h4692;      // mov	sl, r2
#2;
instruction = 16'h469b;      // mov	fp, r3
#2;
instruction = 16'h46a4;      // mov	ip, r4
#2;
instruction = 16'h2005;      // movs	r0, #5
#2;
instruction = 16'h210a;      // movs	r1, #10
#2;
instruction = 16'h220f;      // movs	r2, #15
#2;
instruction = 16'h2314;      // movs	r3, #20
#2;
instruction = 16'h2419;      // movs	r4, #25
#2;
instruction = 16'h251e;      // movs	r5, #30
#2;
instruction = 16'h2623;      // movs	r6, #35	
#2;
instruction = 16'h2728;      // movs	r7, #40	
#2;

instruction = 16'hbf8b;      // IT HI ETE
#2;

instruction = 16'h1840;      // adds	r0, r0, r1
#2;
instruction = 16'h18d2;      // adds	r2, r2, r3
#2;
instruction = 16'h1964;      // adds	r4, r4, r5
#2;
instruction = 16'h19f6;      // adds	r6, r6, r7
#2;
instruction = 16'h1840;      // adds	r0, r0, r1
#2;
instruction = 16'h18d2;      // adds	r2, r2, r3
#2;
instruction = 16'h1964;      // adds	r4, r4, r5
#2;
instruction = 16'h19f6;      // adds	r6, r6, r7
#2;


end



endmodule
