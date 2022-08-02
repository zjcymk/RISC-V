`include "defines.sv"
module mem_wb(
    input  logic        clk,
    input  logic        rst_n,
    
    // to 
    output RegBus     wb_data_o,   // 写寄存器数据
    output RegAddrBus wb_addr_o,   // 写通用寄存器地址
  
    input RegBus     reg_wdata_i,   // 写寄存器数据
    input logic      reg_we_i,      // 是否要写通用寄存器
    input RegAddrBus reg_waddr_i,   // 写通用寄存器地址
    input OpcodeWide opcode_i,

    output OpcodeWide opcode_o,
    output RegBus     reg_wdata_o,   // 写寄存器数据
    output logic      reg_we_o,      // 是否要写通用寄存器
    output RegAddrBus reg_waddr_o   // 写通用寄存器地址

);
    assign wb_data_o = reg_wdata_o;
    assign wb_addr_o = reg_waddr_o;

    always_ff @( posedge clk ) begin 
        if (!rst_n) begin
            reg_wdata_o <= `ZeroWord;
            reg_we_o    <= `WriteDisable;
            reg_waddr_o <= `ZeroReg;
            opcode_o     <= 'd0;
        end else begin
            reg_wdata_o <= reg_wdata_i;
            reg_we_o    <= reg_we_i;
            reg_waddr_o <= reg_waddr_i;
            opcode_o     <= opcode_i;
        end
    end
endmodule