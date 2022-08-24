`include "defines.sv"
import type_pkg::*;
import opcode_pkg::*;
module id_ex (
    input  logic        clk,
    input  logic        rst_n,    
    //to 
    input RegBus       ex_data1_i, 
    input RegBus       ex_data2_i, 
    //to ctrl
    output OpcodeWide  ctrl_opcode_o,
    output RegAddrBus  id_addr_o,
    output RegAddrBus  ex_addr_o,
    //from id
    input logic        reg_we_i,        // 写通用寄存器标志
    input RegAddrBus   reg_waddr_i,     // 写通用寄存器地址
    input word         imm1_i,
    input word         imm2_i,
    input OpcodeWide   opcode_i,
    input ExCode       ex_code_i,
    input InstAddrBus  pc_i,
    input  logic        jump_bp_i ,
    output logic        jump_bp_o ,    
    //from ctrl
    input logic         ex_hold_flag,
    input logic         ex_scour_flag,
    //from ex
    output RegBus       reg1_rdata_o,    // 通用寄存器1数据
    output RegBus       reg2_rdata_o,    // 通用寄存器2数据
    output logic        reg_we_o,        // 写通用寄存器标志
    output RegAddrBus   reg_waddr_o,     // 写通用寄存器地址
    output word         imm1_o,
    output word         imm2_o,
    output OpcodeWide   opcode_o,
    output ExCode       ex_code_o,
    output InstAddrBus  pc_o
);


    always_ff @( posedge clk ) begin 
        if ((!rst_n)||ex_scour_flag) begin
            reg1_rdata_o <= `ZeroWord;
            reg2_rdata_o <= `ZeroWord;
            reg_we_o     <= `WriteDisable;
            reg_waddr_o  <= `ZeroReg;
            imm1_o       <= `ZeroWord;
            imm2_o       <= `ZeroWord;
            opcode_o     <= 'd0;
            pc_o         <= 'd0;
            jump_bp_o    <= 1'b0;
            ex_code_o    <= NOP;
        end else if (ex_hold_flag)begin
            reg1_rdata_o <= reg1_rdata_o;
            reg2_rdata_o <= reg2_rdata_o;
            reg_we_o     <= reg_we_o    ;
            reg_waddr_o  <= reg_waddr_o ;
            imm1_o       <= imm1_o      ;
            imm2_o       <= imm2_o      ;
            opcode_o     <= opcode_o    ;
            pc_o         <= pc_o        ;
            ex_code_o    <= ex_code_o   ;
            jump_bp_o    <= jump_bp_o   ;
        end else begin
            reg1_rdata_o <= ex_data1_i;
            reg2_rdata_o <= ex_data2_i;
            reg_we_o     <= reg_we_i;
            reg_waddr_o  <= reg_waddr_i;
            imm1_o       <= imm1_i;
            imm2_o       <= imm2_i;
            opcode_o     <= opcode_i;
            ex_code_o    <= ex_code_i;
            pc_o         <= pc_i;
            jump_bp_o    <= jump_bp_i;
        end
    end
endmodule