`include "defines.sv"
module wb(
    input  logic        clk,
    input  logic        rst_n,
    
    // to 
    output RegBus     wb_data_o,   // 写寄存器数据
    output RegAddrBus wb_addr_o,   // 写通用寄存器地址
  
    input RegBus     reg_wdata_i,   // 写寄存器数据
    input logic      reg_we_i,      // 是否要写通用寄存器
    input RegAddrBus reg_waddr_i,   // 写通用寄存器地址

    output RegBus     reg_wdata_o,   // 写寄存器数据
    output logic      reg_we_o,      // 是否要写通用寄存器
    output RegAddrBus reg_waddr_o   // 写通用寄存器地址

);

assign reg_wdata_o = reg_wdata_i;
assign reg_we_o    = reg_we_i   ;
assign reg_waddr_o = reg_waddr_i;

endmodule