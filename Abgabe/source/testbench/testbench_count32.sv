// Integrated Electronic Systems Lab
// TU Darmstadt
// Author:	Dipl.-Ing. Boris Traskov
// Modified by M.Sc. Haoyuan Ying Dual 8-bit Memory Port -> Single 16-bit
// Email: 	boris.traskov@ies.tu-darmstadt.de

`timescale 1 ns / 1 ps

module testbench_count32();

// PARAMETERS
parameter MEM_DEPTH   		= 2**12;	//8192 Bytes 4096*2B
parameter ADDR_WIDTH   		= $clog2(MEM_DEPTH);
parameter string filename	= "../../stimulus/count32.bin";

// ================
// Internal Signals
// ================

integer file, status; // needed for file-io


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

logic			clock;
logic			reset;

// =======
// Outputs
// =======



// =================
// CPU Instantiation
// =================
cpu UUT (
                                                                                            
    /* input */          .clock                              ( clock                               ),
    /* input */          .reset                              ( reset                               ),
                                                                                                  
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
                                                             

end



endmodule
