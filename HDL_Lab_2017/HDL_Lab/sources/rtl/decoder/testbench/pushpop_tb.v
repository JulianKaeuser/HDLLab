// Integrated Electronic Systems Lab
// TU Darmstadt
// Author:	Dipl.-Ing. Boris Traskov
// Modified by M.Sc. Haoyuan Ying Dual 8-bit Memory Port -> Single 16-bit
// Email: 	boris.traskov@ies.tu-darmstadt.de

`timescale 1 ns / 1 ps

module pushpop_tb();

// instructions
localparam PUSH_R7_LR    = 16'hb580;      	//push	{r7, lr}
localparam ADD_R7_SP_8   = 16'haf02;      	//add	r7, sp, #8
localparam LDR_R2_PC_32  = 16'h4a08;      	//ldr	r2, [pc, #32]	; (00000028 <_loopcheck+0x12>)
localparam MOVS_R3_0     = 16'h2300;      	//movs	r3, #0
localparam STR_R3_R2_0   = 16'h6013;      	//str	r3, [r2, #0]
localparam BN_0          = 16'he7fe;      	//b.n	00000000 <loopchecP11	loopcheck
localparam LDR_R3_PC_24  = 16'h4b06;      	//ldr	r3, [pc, #24]	; (00000028 <_loopcheck+0x12>)
localparam LDR_R3_R3_0   = 16'h681b;      	//ldr	r3, [r3, #0]
localparam ADDS_R2_R3_1  = 16'h1c5a;      	//adds	r2, r3, #1
localparam LDR_R3_PC_20  = 16'h4b05;      	//ldr	r3, [pc, #20]	; (00000028 <_loopcheck+0x12>)
localparam STR_R2_R3_0   = 16'h601a;      	//str	r2, [r3, #0]
localparam LDR_R3_PC_16  = 16'h4b04;      	//ldr	r3, [pc, #16]	; (00000028 <_loopcheck+0x12>)
//localparam LDR_R3_R3_0 = 16'h681b;      	//ldr	r3, [r3, #0]
localparam CMP_R3_31     = 16'h2b1f;      	//cmp	r3, #31
localparam BLE_N_0       = 16'hddfe;      	//ble.n	00000000 <loopstart>
//localparam MOVS_R3_0   = 16'h2300;      	//movs	r3, #0
localparam ADDS_R0_R3_0  = 16'h1c18;      	//adds	r0, r3, #0
localparam MOV_SP_R7     = 16'h46bd;      	//mov	sp, r7
localparam SUB_SP_8      = 16'hb082;      	//sub	sp, #8
localparam POP_R7_PC     = 16'hbd80;      	//pop	{r7, pc}


// test case codes:
localparam INIT_R7 = 0;
localparam INIT_R3 = 1;
localparam INIT_R0 = 2;
localparam PUSH_FIRST_R7_LR = 3;
localparam CHANGE_R7 = 4;
localparam POP_SECOND_R7_LR = 5;

// PARAMETERS
//parameter MEM_DEPTH   		= 2**12;	//8192 Bytes 4096*2B
//parameter ADDR_WIDTH   		= $clog2(MEM_DEPTH);
//parameter string filename	= "mem_unititialized.bin";

// ================
// Internal Signals
// ================

integer file, status; // needed for file-io
integer i;

reg			clock;
reg			reset;

// ================
// Memory Interface
// ================

wire  [15:0] MEM_MEMCTRL_from_mem_data;

wire         MEMCTRL_MEM_to_mem_read_enable   ;
wire         MEMCTRL_MEM_to_mem_write_enable  ;
wire         MEMCTRL_MEM_to_mem_mem_enable    ;
wire  [11:0] MEMCTRL_MEM_to_mem_address       ;
wire  [15:0] MEMCTRL_MEM_to_mem_data          ;

// ======
// Inputs
// ======
// logic          clock;
// logic          reset;
reg          [15:0] instruction;

reg          stall_from_instructionfetch;

// =======
// Outputs
// =======

wire          stall_to_instructionfetch;

wire          decoder_pc_update;

wire          [31:0] RF_pc_out;

wire [5:0] display;
assign display = i;





// =================
// CPU Instantiation
// =================
top6 UUT (

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
//memory #(
//	.MEM_DEPTH (MEM_DEPTH))
//memory_i (
//   	.clk 	(clock),
//    .addr	(MEMCTRL_MEM_to_mem_address),
//    .en  	(MEMCTRL_MEM_to_mem_mem_enable),
//    .rd_en  (MEMCTRL_MEM_to_mem_read_enable),
//    .wr_en  (MEMCTRL_MEM_to_mem_write_enable),
//    .din (MEMCTRL_MEM_to_mem_data),
//    .dout(MEM_MEMCTRL_from_mem_data)
//    );

// CLOCK GENERATOR
initial begin
	clock = 1'b0;
  i=0;
end

always begin
  #1 clock = !clock;
end

// RESET GENERATOR
initial begin
$dumpfile("pushpop_tb_out.vcd");
$dumpvars;
	reset			= 1'b0;
	//file		= $fopen(filename, "r");
	#3 reset		= 1'b1;     // 3   ns
	//status		= $fread(memory_i.ram, file);
	#2.1 reset	= 1'b0;  //2.1 ns
//	$finish;
end

// STIMULI
initial begin

instruction                     = 16'h0000;

stall_from_instructionfetch     = 1'b0;


#3;
#2;
#2;

// INIT R7
#2;
instruction = ADD_R7_SP_8;

// MOVS_R3_0
#2;
i=i+1;
instruction = MOVS_R3_0;

// MOVS_R3_0
#2;
i=i+1;
instruction = ADDS_R0_R3_0;

// PUSH_R7_LR
#2;
i=i+1;
instruction = PUSH_R7_LR;
#2;
// change R7
#2;
i=i+1;
instruction = ADD_R7_SP_8;

// change R7
#2;
instruction = ADD_R7_SP_8;

// POP R7
#2;
i=i+1;
instruction = POP_R7_PC;
#2;

// change R7
#2;
i=i-1;
instruction = ADD_R7_SP_8;
#2;
#2;

$finish;


end



endmodule
