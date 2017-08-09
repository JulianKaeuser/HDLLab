
`define       COND_EQ              4'b0000   
`define       COND_NE              4'b0001
`define       COND_CS              4'b0010
`define       COND_CC              4'b0011
`define       COND_MI              4'b0100   
`define       COND_PL              4'b0101
`define       COND_VS              4'b0110
`define       COND_VC              4'b0111
`define       COND_HI              4'b1000   
`define       COND_LS              4'b1001
`define       COND_GE              4'b1010
`define       COND_LT              4'b1011
`define       COND_GT              4'b1100
`define       COND_LE              4'b1101
`define       COND_AL              4'b1110
`define       COND_UNDEFINED       4'b1111

function automatic f_flageval;

input [3:0] condition;
input flag_z;
input flag_c;
input flag_n;
input flag_v;

begin
    casez (condition)
        `COND_EQ            : f_flageval = flag_z ?  1'b1 :  1'b0;
        `COND_NE            : f_flageval = flag_z ?  1'b0 :  1'b1; 
        `COND_CS            : f_flageval = flag_c ?  1'b1 :  1'b0; 
        `COND_CC            : f_flageval = flag_c ?  1'b0 :  1'b1; 
        `COND_MI            : f_flageval = flag_n ?  1'b1 :  1'b0; 
        `COND_PL            : f_flageval = flag_n ?  1'b0 :  1'b1; 
        `COND_VS            : f_flageval = flag_v ?  1'b1 :  1'b0; 
        `COND_VC            : f_flageval = flag_v ?  1'b0 :  1'b1; 
        `COND_HI            : f_flageval = (flag_c & !flag_z) ?  1'b1 :  1'b0;
        `COND_LS            : f_flageval = (!flag_c | flag_z) ?  1'b1 :  1'b0; 
        `COND_GE            : f_flageval = ((flag_n & flag_v) | (!flag_n & !flag_v)) ?  1'b1 :  1'b0;
        `COND_LT            : f_flageval = ((flag_n & !flag_v) | (!flag_n & flag_v)) ?  1'b1 :  1'b0;
        `COND_GT            : f_flageval = (!flag_z & ((flag_n & flag_v) | (!flag_n & !flag_v)) ) ?  1'b1 :  1'b0;       
        `COND_LE            : f_flageval = (flag_z | ((flag_n & !flag_v) | (!flag_n & flag_v)) ) ?  1'b1 :  1'b0;   
        `COND_AL            : f_flageval = 1'b1;  // always
        `COND_UNDEFINED     : f_flageval = 1'b0;  // sollte nie passieren, nicht implementiert
    endcase
end

endfunction
