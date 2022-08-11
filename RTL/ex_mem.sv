`include "defines.sv"
import type_pkg::*;
import opcode_pkg::*;
module ex_mem(
    input  logic        clk,
    input  logic        rst_n,
    
    // to 
    output RegBus      ex_data_o,   // 写寄存器数据
    output RegAddrBus  ex_addr_o,   // 写通用寄存器地址

    //from EX 
    input MemBus       mem_wdata_i,    // 写内存数据
    input MemAddrBus   mem_raddr_i,    // 读内存地址
    input MemAddrBus   mem_waddr_i,    // 写内存地址
    input logic        mem_we_i,       // 是否要写内存
    input logic        mem_req_i,      // 请求访问内存标志
    input RegBus       reg_wdata_i,   // 写寄存器数据
    input logic        reg_we_i,      // 是否要写通用寄存器
    input RegAddrBus   reg_waddr_i,    // 写通用寄存器地址
    input MemIndex     r_index_i,
    input MemIndex     w_index_i,

    input ExCode       ex_code_i,
    input OpcodeWide   opcode_i,
    output ExCode      ex_code_o,  

    output MemBus      mem_wdata_o,    // 写内存数据
    output MemAddrBus  mem_raddr_o,    // 读内存地址
    output MemAddrBus  mem_waddr_o,    // 写内存地址
    output logic       mem_we_o,       // 是否要写内存
    output logic       mem_req_o,      // 请求访问内存标志
    output MemIndex    r_index_o,
    output MemIndex    w_index_o,
    output RegBus      reg_wdata_o,   // 写寄存器数据
    output logic       reg_we_o,      // 是否要写通用寄存器
    output RegAddrBus  reg_waddr_o,    // 写通用寄存器地址
    output OpcodeWide  opcode_o

);
    assign ex_data_o = reg_wdata_i;
    assign ex_addr_o = reg_waddr_i;
    

    always_ff @( posedge clk ) begin 
        if (!rst_n) begin
            mem_wdata_o <= `ZeroWord;
            mem_raddr_o <= `ZeroWord;
            mem_waddr_o <= `ZeroWord;
            mem_we_o    <= `WriteDisable;
            mem_req_o   <= 'd0;
            r_index_o   <= 'd0;
            w_index_o   <= 'd0;
            opcode_o    <= 'd0;
            ex_code_o   <= NOP;
            reg_wdata_o <= `ZeroWord;
            reg_we_o    <= `WriteDisable;
            reg_waddr_o <= `ZeroReg;
        end else begin
            mem_wdata_o <= mem_wdata_i;
            mem_raddr_o <= mem_raddr_i;
            mem_waddr_o <= mem_waddr_i;
            mem_we_o    <= mem_we_i;
            mem_req_o   <= mem_req_i;
            r_index_o   <= r_index_i;
            w_index_o   <= w_index_i;            
            opcode_o     <= opcode_i;
            ex_code_o    <= ex_code_i;
            reg_wdata_o <= reg_wdata_i;
            reg_we_o    <= reg_we_i;
            reg_waddr_o <= reg_waddr_i;
        end
    end
endmodule