// AUTHORS Group 06 / Lukas Boland
// Friday 08/11/2017

// codes for word_type
`define WORD     2'b10
`define HALFWORD 2'b01
`define BYTE     2'b00

// codes for alignment
`define ALIGNED   1'b0
`define UNALIGNED 1'b1


module memory_interface_simple(

clock                         ,
reset                         ,
interface_cpu_sign_extend     ,
interface_cpu_word_type       ,
interface_cpu_load_request    ,
interface_cpu_store_request   ,
interface_cpu_address_in      ,
interface_cpu_data_in         ,
from_mem_data_out             ,

interface_cpu_read_finished   ,
interface_cpu_write_finished  ,
interface_cpu_data_out ,
to_mem_address            ,
to_mem_data_in            ,
to_mem_read_enable        ,
to_mem_write_enable       ,

to_mem_enable
        
  );


input wire        clock;
input wire        reset;
input wire        interface_cpu_sign_extend;
input wire  [1:0] interface_cpu_word_type;
input wire        interface_cpu_load_request;
input wire        interface_cpu_store_request;
input wire [12:0] interface_cpu_address_in;
input wire [31:0] interface_cpu_data_in;
input wire [15:0] from_mem_data_out;

  
       reg  [5:0] state                        ;
output reg        interface_cpu_read_finished  ;
output reg        interface_cpu_write_finished ;
output reg [31:0] interface_cpu_data_out       ;

       reg [15:0] tmp_value_1            ;
       reg [15:0] tmp_value_2            ;
       reg [31:0] cpu_data_in            ;
       reg [12:0] cpu_address_in         ;
       reg        sign_extend            ;
       
output reg [11:0] to_mem_address            ;
output reg [15:0] to_mem_data_in            ;

output reg        to_mem_read_enable        ;
output reg        to_mem_write_enable       ;   

output wire       to_mem_enable             ;
assign to_mem_enable = 1;
        
        
reg  [5:0] next_state                         ;
reg        next_interface_cpu_read_finished   ;
reg        next_interface_cpu_write_finished  ;
reg [31:0] next_interface_cpu_data_out        ;

reg [15:0] next_tmp_value_1            ;
reg [15:0] next_tmp_value_2            ;
reg [31:0] next_cpu_data_in            ;
reg [12:0] next_cpu_address_in         ;
reg        next_sign_extend            ;

reg [11:0] next_to_mem_address            ;
reg [15:0] next_to_mem_data_in            ;
reg        next_to_mem_read_enable        ;
reg        next_to_mem_write_enable       ;

  
  
localparam  IDLE                         =  6'b00_0000; 
localparam  LOAD_BYTE_ALIGNED_1          =  6'b00_0001; 
localparam  LOAD_BYTE_ALIGNED_2          =  6'b00_0010; 
localparam  LOAD_BYTE_ALIGNED_3          =  6'b00_0011;
localparam  LOAD_BYTE_UNALIGNED_1        =  6'b00_0100;
localparam  LOAD_BYTE_UNALIGNED_2        =  6'b00_0101; 
localparam  LOAD_BYTE_UNALIGNED_3        =  6'b00_0110; 
localparam  STORE_BYTE_ALIGNED_1         =  6'b00_0111;
localparam  STORE_BYTE_ALIGNED_2         =  6'b00_1000;
localparam  STORE_BYTE_ALIGNED_3         =  6'b00_1001; 
localparam  STORE_BYTE_ALIGNED_4         =  6'b00_1010; 
localparam  STORE_BYTE_UNALIGNED_1       =  6'b00_1011; 
localparam  STORE_BYTE_UNALIGNED_2       =  6'b00_1100; 
localparam  STORE_BYTE_UNALIGNED_3       =  6'b00_1101; 
localparam  STORE_BYTE_UNALIGNED_4       =  6'b00_1110; 
localparam  LOAD_HALFWORD_ALIGNED_1      =  6'b00_1111;
localparam  LOAD_HALFWORD_ALIGNED_2      =  6'b01_0000;
localparam  LOAD_HALFWORD_ALIGNED_3      =  6'b01_0001; 
localparam  LOAD_HALFWORD_UNALIGNED_1    =  6'b01_0010; 
localparam  LOAD_HALFWORD_UNALIGNED_2    =  6'b01_0011;
localparam  LOAD_HALFWORD_UNALIGNED_3    =  6'b01_0100;
localparam  STORE_HALFWORD_ALIGNED_1     =  6'b01_0101;
localparam  STORE_HALFWORD_ALIGNED_2     =  6'b01_0110;
localparam  STORE_HALFWORD_UNALIGNED_1   =  6'b01_0111;
localparam  STORE_HALFWORD_UNALIGNED_2   =  6'b01_1000;
localparam  STORE_HALFWORD_UNALIGNED_3   =  6'b01_1001;
localparam  STORE_HALFWORD_UNALIGNED_4   =  6'b01_1010;
localparam  STORE_HALFWORD_UNALIGNED_5   =  6'b01_1011;
localparam  LOAD_WORD_ALIGNED_1          =  6'b01_1100;
localparam  LOAD_WORD_ALIGNED_2          =  6'b01_1101;
localparam  LOAD_WORD_ALIGNED_3          =  6'b01_1110;
localparam  LOAD_WORD_ALIGNED_4          =  6'b01_1111;
localparam  LOAD_WORD_UNALIGNED_1        =  6'b10_0000;
localparam  LOAD_WORD_UNALIGNED_2        =  6'b10_0001;
localparam  LOAD_WORD_UNALIGNED_3        =  6'b10_0010;
localparam  LOAD_WORD_UNALIGNED_4        =  6'b10_0011;
localparam  STORE_WORD_ALIGNED_1         =  6'b10_0100;
localparam  STORE_WORD_ALIGNED_2         =  6'b10_0101;
localparam  STORE_WORD_ALIGNED_3         =  6'b10_0110;
localparam  STORE_WORD_UNALIGNED_1       =  6'b10_0111;
localparam  STORE_WORD_UNALIGNED_2       =  6'b10_1000;
localparam  STORE_WORD_UNALIGNED_3       =  6'b10_1001;
localparam  STORE_WORD_UNALIGNED_4       =  6'b10_1010;
localparam  STORE_WORD_UNALIGNED_5       =  6'b10_1011;
localparam  STORE_WORD_UNALIGNED_6       =  6'b10_1100;
localparam  FINISHED                     =  6'b10_1101;
                                           
                                           
                                           
                                           
                                           
// 6'b00_0000;                                
// 6'b00_0001;                                
// 6'b00_0010;                                
// 6'b00_0011;                                
// 6'b00_0100;                                
// 6'b00_0101;                                
// 6'b00_0110;                                
// 6'b00_0111;                                
// 6'b00_1000;                                
// 6'b00_1001;                                
// 6'b00_1010;                                
// 6'b00_1011;                                
// 6'b00_1100;                                
// 6'b00_1101;                                
// 6'b00_1110;                                
// 6'b00_1111;
// 6'b01_0000;
// 6'b01_0001;                                
// 6'b01_0010;                                
// 6'b01_0011;
// 6'b01_0100;
// 6'b01_0101;
// 6'b01_0110;
// 6'b01_0111;
// 6'b01_1000;
// 6'b01_1001;
// 6'b01_1010;
// 6'b01_1011;
// 6'b01_1100;
// 6'b01_1101;
// 6'b01_1110;
// 6'b01_1111;
// 6'b10_0000;
// 6'b10_0001;
// 6'b10_0010;
// 6'b10_0011;
// 6'b10_0100;
// 6'b10_0101;
// 6'b10_0110;
// 6'b10_0111;
// 6'b10_1000;
// 6'b10_1001;
// 6'b10_1010;
// 6'b10_1011;
// 6'b10_1100;
// 6'b10_1101;
// 6'b10_1110;
// 6'b10_1111;
// 6'b11_0000;
// 6'b11_0001;
// 6'b11_0010;
// 6'b11_0011;
// 6'b11_0100;
// 6'b11_0101;
// 6'b11_0110;
// 6'b11_0111;
// 6'b11_1000;
// 6'b11_1001;
// 6'b11_1010;
// 6'b11_1011;
// 6'b11_1100;
// 6'b11_1101;
// 6'b11_1110;
// 6'b11_1111;





// output flipflops
  always @(posedge clock) begin
    if (reset) begin
        state                                 <= IDLE;
        interface_cpu_read_finished           <= 0;
        interface_cpu_write_finished          <= 0;
        interface_cpu_data_out                <= 0;
                                              
        tmp_value_1                           <= 0;
        tmp_value_2                           <= 0;
        cpu_data_in                           <= 0;
        cpu_address_in                        <= 0;
        sign_extend                           <= 0;
                                              
        to_mem_address                           <= 0;
        to_mem_data_in                           <= 0;
        to_mem_read_enable                       <= 0;
        to_mem_write_enable                      <= 0;
        
    end
    else begin
        state                                 <= next_state                  ;
        interface_cpu_read_finished           <= next_interface_cpu_read_finished          ;
        interface_cpu_write_finished          <= next_interface_cpu_write_finished         ;
        interface_cpu_data_out                <= next_interface_cpu_data_out ;
                                              
        tmp_value_1                           <= next_tmp_value_1            ;
        tmp_value_2                           <= next_tmp_value_2            ;
        cpu_data_in                           <= next_cpu_data_in            ;
        cpu_address_in                        <= next_cpu_address_in         ;
        sign_extend                           <= next_sign_extend            ;
                                              
        to_mem_address                           <= next_to_mem_address            ;
        to_mem_data_in                           <= next_to_mem_data_in            ;
        to_mem_read_enable                       <= next_to_mem_read_enable        ;
        to_mem_write_enable                      <= next_to_mem_write_enable       ;
    end
  end

  // state transition logic
  always @(*) begin
   case (state)
   
     IDLE: begin
       if (interface_cpu_load_request) begin
        case(interface_cpu_word_type)
            `WORD: begin
                case(interface_cpu_address_in[0])
                    `ALIGNED   : next_state = LOAD_WORD_ALIGNED_1;
                    `UNALIGNED : next_state = LOAD_WORD_UNALIGNED_1;
                endcase
                end
            `HALFWORD: begin
                case(interface_cpu_address_in[0])
                    `ALIGNED   : next_state = LOAD_HALFWORD_ALIGNED_1;
                    `UNALIGNED : next_state = LOAD_HALFWORD_UNALIGNED_1;
                endcase
                end
            `BYTE: begin
                case(interface_cpu_address_in[0])
                    `ALIGNED   : next_state = LOAD_BYTE_ALIGNED_1;
                    `UNALIGNED : next_state = LOAD_BYTE_UNALIGNED_1;
                endcase
                end
			default: next_state = IDLE;
        endcase
       end 
       else if(interface_cpu_store_request) begin
        case(interface_cpu_word_type)
            `WORD: begin
                case(interface_cpu_address_in[0])
                    `ALIGNED   : next_state = STORE_WORD_ALIGNED_1;
                    `UNALIGNED : next_state = STORE_WORD_UNALIGNED_1;
                endcase
                end
            `HALFWORD: begin
                case(interface_cpu_address_in[0])
                    `ALIGNED   : next_state = STORE_HALFWORD_ALIGNED_1;
                    `UNALIGNED : next_state = STORE_HALFWORD_UNALIGNED_1;
                endcase
                end
            `BYTE: begin
                case(interface_cpu_address_in[0])
                    `ALIGNED   : next_state = STORE_BYTE_ALIGNED_1;
                    `UNALIGNED : next_state = STORE_BYTE_UNALIGNED_1;
                endcase
                end
			default: next_state = IDLE;
        endcase
       end 
       else begin
           next_state = IDLE;
       end
     end 
     
     
     
     FINISHED: begin
         next_state = IDLE;
     end
     
     

 // ******************************************************************************************* 
     LOAD_BYTE_ALIGNED_1: begin
         next_state = LOAD_BYTE_ALIGNED_2;
     end
     
     LOAD_BYTE_ALIGNED_2: begin
         next_state = LOAD_BYTE_ALIGNED_3;
     end
     
     LOAD_BYTE_ALIGNED_3: begin
         next_state = FINISHED;
     end
     
 // *******************************************************************************************      
     LOAD_BYTE_UNALIGNED_1: begin
         next_state = LOAD_BYTE_UNALIGNED_2;
     end
     
     LOAD_BYTE_UNALIGNED_2: begin
         next_state = LOAD_BYTE_UNALIGNED_3;
     end
     
     LOAD_BYTE_UNALIGNED_3: begin
         next_state = FINISHED;
     end
     
// *******************************************************************************************     
     STORE_BYTE_ALIGNED_1: begin
         next_state = STORE_BYTE_ALIGNED_2;
     end
     
     STORE_BYTE_ALIGNED_2: begin
         next_state = STORE_BYTE_ALIGNED_3;
     end
     
     STORE_BYTE_ALIGNED_3: begin
         next_state = STORE_BYTE_ALIGNED_4;
     end
     
     STORE_BYTE_ALIGNED_4: begin
         next_state = FINISHED;
     end
     
// ******************************************************************************************* 
     STORE_BYTE_UNALIGNED_1: begin
         next_state = STORE_BYTE_UNALIGNED_2;
     end
     
     STORE_BYTE_UNALIGNED_2: begin
         next_state = STORE_BYTE_UNALIGNED_3;
     end
     
     STORE_BYTE_UNALIGNED_3: begin
         next_state = STORE_BYTE_UNALIGNED_4;
     end
     
     STORE_BYTE_UNALIGNED_4: begin
         next_state = FINISHED;
     end
     
 // ******************************************************************************************* 
     LOAD_HALFWORD_ALIGNED_1: begin
         next_state = LOAD_HALFWORD_ALIGNED_2;
     end
     
     LOAD_HALFWORD_ALIGNED_2: begin
         next_state = LOAD_HALFWORD_ALIGNED_3;
     end
     
     LOAD_HALFWORD_ALIGNED_3: begin
         next_state = FINISHED;
     end

 // ******************************************************************************************* 
     LOAD_HALFWORD_UNALIGNED_1: begin
         next_state = LOAD_HALFWORD_UNALIGNED_2;
     end
     
     LOAD_HALFWORD_UNALIGNED_2: begin
         next_state = LOAD_HALFWORD_UNALIGNED_3;
     end
     
     LOAD_HALFWORD_UNALIGNED_3: begin
         next_state = FINISHED;
     end
     
 // ******************************************************************************************* 
     STORE_HALFWORD_ALIGNED_1: begin
         next_state = STORE_HALFWORD_ALIGNED_2;
     end
         
     STORE_HALFWORD_ALIGNED_2: begin
         next_state = FINISHED;
     end
     
 // ******************************************************************************************* 
     STORE_HALFWORD_UNALIGNED_1: begin
         next_state = STORE_HALFWORD_UNALIGNED_2;
     end
         
     STORE_HALFWORD_UNALIGNED_2: begin
         next_state = STORE_HALFWORD_UNALIGNED_3;
     end
     
     STORE_HALFWORD_UNALIGNED_3: begin
         next_state = STORE_HALFWORD_UNALIGNED_4;
     end
         
     STORE_HALFWORD_UNALIGNED_4: begin
         next_state = STORE_HALFWORD_UNALIGNED_5;
     end
     
     STORE_HALFWORD_UNALIGNED_5: begin
         next_state = FINISHED;
     end
     
 // ******************************************************************************************* 
     LOAD_WORD_ALIGNED_1: begin
         next_state = LOAD_WORD_ALIGNED_2;
     end
     
     LOAD_WORD_ALIGNED_2: begin
         next_state = LOAD_WORD_ALIGNED_3;
     end
     
     LOAD_WORD_ALIGNED_3: begin
         next_state = LOAD_WORD_ALIGNED_4;
     end
     
     LOAD_WORD_ALIGNED_4: begin
         next_state = FINISHED;
     end
     
 // ******************************************************************************************* 
     LOAD_WORD_UNALIGNED_1: begin
         next_state = LOAD_WORD_UNALIGNED_2;
     end
     
     LOAD_WORD_UNALIGNED_2: begin
         next_state = LOAD_WORD_UNALIGNED_3;
     end
     
     LOAD_WORD_UNALIGNED_3: begin
         next_state = LOAD_WORD_UNALIGNED_4;
     end
     
     LOAD_WORD_UNALIGNED_4: begin
         next_state = FINISHED;
     end
     
 // ******************************************************************************************* 
     STORE_WORD_ALIGNED_1: begin
         next_state = STORE_WORD_ALIGNED_2;
     end
     
     STORE_WORD_ALIGNED_2: begin
         next_state = STORE_WORD_ALIGNED_3;
     end
     
     STORE_WORD_ALIGNED_3: begin
         next_state = FINISHED;
     end
     
 // ******************************************************************************************* 
     STORE_WORD_UNALIGNED_1: begin
         next_state = STORE_WORD_UNALIGNED_2;
     end
     
     STORE_WORD_UNALIGNED_2: begin
         next_state = STORE_WORD_UNALIGNED_3;
     end
     
     STORE_WORD_UNALIGNED_3: begin
         next_state = STORE_WORD_UNALIGNED_4;
     end
     
     STORE_WORD_UNALIGNED_4: begin
         next_state = STORE_WORD_UNALIGNED_5;
     end
     
     STORE_WORD_UNALIGNED_5: begin
         next_state = STORE_WORD_UNALIGNED_6;
     end
     
     STORE_WORD_UNALIGNED_6: begin
         next_state = FINISHED;
     end

 // ******************************************************************************************* 
	default: begin
		next_state = IDLE;
	end

   endcase // state
  end
  


// output logic
  always @(*) begin
    case (state)

    IDLE: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = 0;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = interface_cpu_data_in;
      next_cpu_address_in           = interface_cpu_address_in;
      next_sign_extend              = interface_cpu_sign_extend;

      next_to_mem_address              = 0;
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 0;
      next_to_mem_write_enable         = 0;

    end 
    
    
    
    FINISHED: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = 0;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = interface_cpu_data_in;
      next_cpu_address_in           = interface_cpu_address_in;
      next_sign_extend              = interface_cpu_sign_extend;

      next_to_mem_address              = 0;
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 0;
      next_to_mem_write_enable         = 0;

    end 

// *******************************************************************************************    
    LOAD_BYTE_ALIGNED_1: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = 0;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = 0;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = sign_extend;

      next_to_mem_address              = cpu_address_in[12:1];
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 1;
      next_to_mem_write_enable         = 0;

    end 
    
    LOAD_BYTE_ALIGNED_2: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = 0;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = 0;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = sign_extend;

      next_to_mem_address              = 0;
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 0;
      next_to_mem_write_enable         = 0;

    end 

    LOAD_BYTE_ALIGNED_3: begin
      next_interface_cpu_read_finished            = 1;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = (sign_extend) ? { {24 {from_mem_data_out[7]}}, from_mem_data_out[7:0]} : { 24'h000000, from_mem_data_out[7:0]};
      
      next_tmp_value_1              = 0;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = 0;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = sign_extend;

      next_to_mem_address              = 0;
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 0;
      next_to_mem_write_enable         = 0;

    end 
    
// *******************************************************************************************
    LOAD_BYTE_UNALIGNED_1: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = 0;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = 0;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = sign_extend;

      next_to_mem_address              = cpu_address_in[12:1];
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 1;
      next_to_mem_write_enable         = 0;

    end 
    
    LOAD_BYTE_UNALIGNED_2: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = 0;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = 0;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = sign_extend;

      next_to_mem_address              = 0;
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 0;
      next_to_mem_write_enable         = 0;

    end 

    LOAD_BYTE_UNALIGNED_3: begin
      next_interface_cpu_read_finished            = 1;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = (sign_extend) ? { {24 {from_mem_data_out[15]}}, from_mem_data_out[15:8]} : { 24'h000000, from_mem_data_out[15:8]};
      
      next_tmp_value_1              = 0;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = 0;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = sign_extend;

      next_to_mem_address              = 0;
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 0;
      next_to_mem_write_enable         = 0;

    end 
    
// *******************************************************************************************
    STORE_BYTE_ALIGNED_1: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = 0;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = cpu_data_in;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = 0;

      next_to_mem_address              = cpu_address_in[12:1];
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 1;
      next_to_mem_write_enable         = 0;

    end 
    
    STORE_BYTE_ALIGNED_2: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = 0;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = cpu_data_in;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = sign_extend;

      next_to_mem_address              = 0;
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 0;
      next_to_mem_write_enable         = 0;

    end 

    STORE_BYTE_ALIGNED_3: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = 0;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = cpu_data_in;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = 0;

      next_to_mem_address              = cpu_address_in[12:1];
      next_to_mem_data_in              = {from_mem_data_out[15:8], cpu_data_in[7:0]};
      next_to_mem_read_enable          = 0;
      next_to_mem_write_enable         = 1;

    end    
    
    STORE_BYTE_ALIGNED_4: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 1;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = 0;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = cpu_data_in;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = 0;

      next_to_mem_address              = 0;
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 0;
      next_to_mem_write_enable         = 0;

    end    
    
// *******************************************************************************************
    STORE_BYTE_UNALIGNED_1: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = 0;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = cpu_data_in;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = 0;

      next_to_mem_address              = cpu_address_in[12:1];
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 1;
      next_to_mem_write_enable         = 0;

    end 
    
    STORE_BYTE_UNALIGNED_2: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = 0;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = cpu_data_in;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = sign_extend;

      next_to_mem_address              = 0;
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 0;
      next_to_mem_write_enable         = 0;

    end 

    STORE_BYTE_UNALIGNED_3: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = 0;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = cpu_data_in;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = 0;

      next_to_mem_address              = cpu_address_in[12:1];
      next_to_mem_data_in              = {cpu_data_in[7:0], from_mem_data_out[7:0]};
      next_to_mem_read_enable          = 0;
      next_to_mem_write_enable         = 1;

    end    
    
    STORE_BYTE_UNALIGNED_4: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 1;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = 0;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = cpu_data_in;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = 0;

      next_to_mem_address              = 0;
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 0;
      next_to_mem_write_enable         = 0;

    end    
    
// *******************************************************************************************
    LOAD_HALFWORD_ALIGNED_1: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = 0;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = 0;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = sign_extend;

      next_to_mem_address              = cpu_address_in[12:1];
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 1;
      next_to_mem_write_enable         = 0;

    end 

    LOAD_HALFWORD_ALIGNED_2: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = 0;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = 0;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = sign_extend;

      next_to_mem_address              = 0;
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 0;
      next_to_mem_write_enable         = 0;

    end 
    
    LOAD_HALFWORD_ALIGNED_3: begin
      next_interface_cpu_read_finished            = 1;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = (sign_extend) ? { {16 {from_mem_data_out[7]}}, from_mem_data_out[7:0], from_mem_data_out[15:8]} : { 16'h0000, from_mem_data_out[7:0], from_mem_data_out[15:8]}; // little endian im speicher
      
      next_tmp_value_1              = 0;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = 0;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = sign_extend;

      next_to_mem_address              = 0;
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 0;
      next_to_mem_write_enable         = 0;

    end 
    
   
 // *******************************************************************************************   
     LOAD_HALFWORD_UNALIGNED_1: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = 0;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = 0;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = sign_extend;

      next_to_mem_address              = cpu_address_in[12:1];
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 1;
      next_to_mem_write_enable         = 0;

    end 

    LOAD_HALFWORD_UNALIGNED_2: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = from_mem_data_out;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = 0;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = sign_extend;

      next_to_mem_address              = cpu_address_in[12:1] + 1;
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 1;
      next_to_mem_write_enable         = 0;

    end 
    
    LOAD_HALFWORD_UNALIGNED_3: begin
      next_interface_cpu_read_finished            = 1;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = (sign_extend) ? { {16 {from_mem_data_out[15]}}, from_mem_data_out[15:8], tmp_value_1[7:0]} : { 16'h0000, from_mem_data_out[15:8], tmp_value_1[7:0]}; // little endian im speicher
      
      next_tmp_value_1              = tmp_value_1;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = 0;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = sign_extend;

      next_to_mem_address              = 0;
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 0;
      next_to_mem_write_enable         = 0;

    end 
   
 // *******************************************************************************************    
    STORE_HALFWORD_ALIGNED_1: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = 0;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = cpu_data_in; 
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = 0;

      next_to_mem_address              = cpu_address_in[12:1];
      next_to_mem_data_in              = {cpu_data_in[7:0], cpu_data_in[15:8]}; // little endian im speicher
      next_to_mem_read_enable          = 0;
      next_to_mem_write_enable         = 1;

    end 

    STORE_HALFWORD_ALIGNED_2: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 1;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = 0;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = cpu_data_in;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = 0;

      next_to_mem_address              = 0;
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 0;
      next_to_mem_write_enable         = 0;

    end 
   
 // *******************************************************************************************   
    STORE_HALFWORD_UNALIGNED_1: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = 0;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = cpu_data_in; 
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = 0;

      next_to_mem_address              = cpu_address_in[12:1];
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 1;
      next_to_mem_write_enable         = 0;

    end 

    STORE_HALFWORD_UNALIGNED_2: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = from_mem_data_out;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = cpu_data_in;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = 0;

      next_to_mem_address              = cpu_address_in[12:1] + 1;
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 1;
      next_to_mem_write_enable         = 0;

    end 
    
    STORE_HALFWORD_UNALIGNED_3: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = tmp_value_1;
      next_tmp_value_2              = from_mem_data_out;
      next_cpu_data_in              = cpu_data_in;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = 0;

      next_to_mem_address              = cpu_address_in[12:1];
      next_to_mem_data_in              = {tmp_value_1[15:8], cpu_data_in[7:0]};
      next_to_mem_read_enable          = 0;
      next_to_mem_write_enable         = 1;

    end 
    
    STORE_HALFWORD_UNALIGNED_4: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = tmp_value_1;
      next_tmp_value_2              = tmp_value_2;
      next_cpu_data_in              = cpu_data_in;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = 0;

      next_to_mem_address              = cpu_address_in[12:1] + 1;
      next_to_mem_data_in              = {cpu_data_in[15:8], tmp_value_2[7:0]};
      next_to_mem_read_enable          = 0;
      next_to_mem_write_enable         = 1;

    end 
    
    STORE_HALFWORD_UNALIGNED_5: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 1;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = tmp_value_1;
      next_tmp_value_2              = tmp_value_2;
      next_cpu_data_in              = cpu_data_in;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = 0;

      next_to_mem_address              = 0;
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 0;
      next_to_mem_write_enable         = 0;

    end 
   
 // *******************************************************************************************   
     LOAD_WORD_ALIGNED_1: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = 0;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = 0;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = 0;

      next_to_mem_address              = cpu_address_in[12:1];
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 1;
      next_to_mem_write_enable         = 0;

    end 

    LOAD_WORD_ALIGNED_2: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = 0;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = 0;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = 0;

      next_to_mem_address              = cpu_address_in[12:1] + 1;
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 1;
      next_to_mem_write_enable         = 0;

    end 
    
    LOAD_WORD_ALIGNED_3: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = from_mem_data_out;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = 0;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = 0;

      next_to_mem_address              = 0;
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 0;
      next_to_mem_write_enable         = 0;

    end 
    
    
    
    LOAD_WORD_ALIGNED_4: begin
      next_interface_cpu_read_finished            = 1;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = {from_mem_data_out[7:0], from_mem_data_out[15:8], tmp_value_1[7:0], tmp_value_1[15:8]}; // little endian im speicher
      
      next_tmp_value_1              = tmp_value_1;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = 0;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = 0;

      next_to_mem_address              = 0;
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 0;
      next_to_mem_write_enable         = 0;

    end 
   
 // *******************************************************************************************  
      LOAD_WORD_UNALIGNED_1: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = 0;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = 0;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = 0;

      next_to_mem_address              = cpu_address_in[12:1];
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 1;
      next_to_mem_write_enable         = 0;

    end 

    LOAD_WORD_UNALIGNED_2: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = from_mem_data_out;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = 0;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = 0;

      next_to_mem_address              = cpu_address_in[12:1] + 1;
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 1;
      next_to_mem_write_enable         = 0;

    end 
    
    LOAD_WORD_UNALIGNED_3: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = tmp_value_1;
      next_tmp_value_2              = from_mem_data_out;
      next_cpu_data_in              = 0;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = 0;

      next_to_mem_address              = cpu_address_in[12:1] + 2;
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 1;
      next_to_mem_write_enable         = 0;

    end 
    
    LOAD_WORD_UNALIGNED_4: begin
      next_interface_cpu_read_finished            = 1;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = {from_mem_data_out[15:8], tmp_value_2[7:0], tmp_value_2[15:8], tmp_value_1[7:0]}; // little endian im speicher
      
      next_tmp_value_1              = tmp_value_1;
      next_tmp_value_2              = tmp_value_2;
      next_cpu_data_in              = 0;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = 0;

      next_to_mem_address              = 0;
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 0;
      next_to_mem_write_enable         = 0;

    end 
   
 // *******************************************************************************************  
    STORE_WORD_ALIGNED_1: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = 0;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = cpu_data_in;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = 0;

      next_to_mem_address              = cpu_address_in[12:1];
      next_to_mem_data_in              = {cpu_data_in[7:0], cpu_data_in[15:8]}; // little endian im speicher;
      next_to_mem_read_enable          = 0;
      next_to_mem_write_enable         = 1;

    end 

    STORE_WORD_ALIGNED_2: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = 0;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = cpu_data_in;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = 0;

      next_to_mem_address              = cpu_address_in[12:1] + 1;
      next_to_mem_data_in              = {cpu_data_in[23:16], cpu_data_in[31:24]}; // little endian im speicher;
      next_to_mem_read_enable          = 0;
      next_to_mem_write_enable         = 1;

    end 
    
    STORE_WORD_ALIGNED_3: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 1;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = 0;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = cpu_data_in;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = 0;

      next_to_mem_address              = 0;
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 0;
      next_to_mem_write_enable         = 0;

    end 

 // *******************************************************************************************  
     STORE_WORD_UNALIGNED_1: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = 0;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = cpu_data_in;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = 0;

      next_to_mem_address              = cpu_address_in[12:1];
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 1;
      next_to_mem_write_enable         = 0;

    end 

    STORE_WORD_UNALIGNED_2: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = from_mem_data_out;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = cpu_data_in;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = 0;

      next_to_mem_address              = cpu_address_in[12:1] + 2;
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 1;
      next_to_mem_write_enable         = 0;

    end 
    
    STORE_WORD_UNALIGNED_3: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = tmp_value_1;
      next_tmp_value_2              = from_mem_data_out;
      next_cpu_data_in              = cpu_data_in;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = 0;

      next_to_mem_address              = cpu_address_in[12:1];
      next_to_mem_data_in              = {tmp_value_1[15:8], cpu_data_in[7:0]} ;
      next_to_mem_read_enable          = 0;
      next_to_mem_write_enable         = 1;

    end 
    
    STORE_WORD_UNALIGNED_4: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = tmp_value_1;
      next_tmp_value_2              = tmp_value_2;
      next_cpu_data_in              = cpu_data_in;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = 0;

      next_to_mem_address              = cpu_address_in[12:1] + 1;
      next_to_mem_data_in              = {cpu_data_in[15:8], cpu_data_in[23:16]} ;
      next_to_mem_read_enable          = 0;
      next_to_mem_write_enable         = 1;

    end 
    
        
    STORE_WORD_UNALIGNED_5: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = tmp_value_1;
      next_tmp_value_2              = tmp_value_2;
      next_cpu_data_in              = cpu_data_in;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = 0;

      next_to_mem_address              = cpu_address_in[12:1] + 2;
      next_to_mem_data_in              = {cpu_data_in[31:24], tmp_value_2[7:0]} ;
      next_to_mem_read_enable          = 0;
      next_to_mem_write_enable         = 1;

    end 
    
    STORE_WORD_UNALIGNED_6: begin
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 1;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = tmp_value_1;
      next_tmp_value_2              = tmp_value_2;
      next_cpu_data_in              = cpu_data_in;
      next_cpu_address_in           = cpu_address_in;
      next_sign_extend              = 0;

      next_to_mem_address              = 0;
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 0;
      next_to_mem_write_enable         = 0;

    end 

 // *******************************************************************************************  
	default: begin
	
      next_interface_cpu_read_finished            = 0;
      next_interface_cpu_write_finished           = 0;
      next_interface_cpu_data_out   = 0;
      
      next_tmp_value_1              = 0;
      next_tmp_value_2              = 0;
      next_cpu_data_in              = interface_cpu_data_in;
      next_cpu_address_in           = interface_cpu_address_in;
      next_sign_extend              = interface_cpu_sign_extend;

      
      next_to_mem_address              = 0;
      next_to_mem_data_in              = 0;
      next_to_mem_read_enable          = 0;
      next_to_mem_write_enable         = 0;
	end
   endcase
  end


  endmodule


// codes for word_type
`undef WORD
`undef HALFWORD
`undef BYTE
  
  // codes for alignment
`undef ALIGNED
`undef UNALIGNED

