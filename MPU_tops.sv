`include "defines.sv"

module MPU_top(
    input         sys_clk,
    input         sys_res_n,

    output        io
    );

logic [12:0] PC_w;
logic [7:0]  SP_w;
logic        PC_wen;
logic [12:0] PC_r;
logic [7:0]  SP_r;

logic [31:0] code;
logic [3:0]  w_en;
logic [7:0]  R0_w;
logic [7:0]  R1_w;
logic [7:0]  R2_w;
logic [7:0]  R3_w;
logic [7:0]  R4_w;
logic [7:0]  R5_w;
logic [7:0]  R6_w;
logic [7:0]  R7_w;
logic [7:0]  R0_r;
logic [7:0]  R1_r;
logic [7:0]  R2_r;
logic [7:0]  R3_r;
logic [7:0]  R4_r;
logic [7:0]  R5_r;
logic [7:0]  R6_r;
logic [7:0]  R7_r;
logic        reg_err;



assign io = R0_w;
/*
ila_0 ila_0_u (
	.clk(sys_clk), // input wire clk


	.probe0(sys_res_n), // input wire [0:0]  probe0  
	.probe1(PC_wen), // input wire [0:0]  probe1 
	.probe2(R0_r), // input wire [7:0]  probe2 
	.probe3(code) // input wire [31:0]  probe3
);
*/
ID ID_u(
    .sys_clk        (sys_clk  ),    
    .sys_res_n      (sys_res_n),    
    .code           (code     ),
    .R0_r           (R0_r     ),
    .R1_r           (R1_r     ),
    .R2_r           (R2_r     ),
    .R3_r           (R3_r     ),
    .R4_r           (R4_r     ),
    .R5_r           (R5_r     ),
    .R6_r           (R6_r     ),
    .R7_r           (R7_r     ),

    .w_en           (w_en   ),
    .R0_w           (R0_w   ),
    .R1_w           (R1_w   ),
    .R2_w           (R2_w   ),
    .R3_w           (R3_w   ),
    .R4_w           (R4_w   ),
    .R5_w           (R5_w   ),
    .R6_w           (R6_w   ),
    .R7_w           (R7_w   ),
    .reg_err        (reg_err)
    );
SFR SFR_u(
    .sys_clk        (sys_clk   ),
    .sys_res_n      (sys_res_n ),
    .PC_w           (PC_w  ),
    .SP_w           (SP_w  ),
    .PC_wen         (PC_wen),

    .PC_r           (PC_r),
    .SP_r           (SP_r)
    
    );
reg_8 reg_8_u(
    .sys_clk        (sys_clk  ),    
    .sys_res_n      (sys_res_n),    
    .w_en           (w_en     ),
    .R0_w           (R0_w     ),
    .R1_w           (R1_w     ),
    .R2_w           (R2_w     ),
    .R3_w           (R3_w     ),
    .R4_w           (R4_w     ),
    .R5_w           (R5_w     ),
    .R6_w           (R6_w     ),
    .R7_w           (R7_w     ),

    .R0_r           (R0_r    ),
    .R1_r           (R1_r    ),
    .R2_r           (R2_r    ),
    .R3_r           (R3_r    ),
    .R4_r           (R4_r    ),
    .R5_r           (R5_r    ),
    .R6_r           (R6_r    ),
    .R7_r           (R7_r    ),
    .reg_err        (reg_err )
    );
rom_ip  rom_ip_t(
  .clka(sys_clk),    // input wire clka
  .addra(PC_r),  // input wire [12 : 0] addra
  .douta(code)  // output wire [31 : 0] douta
);
endmodule
