`include "defines.sv"
import type_pkg::*;
import opcode_pkg::*;
module id_ex (
    input  logic        clk,
    input  logic        rst_n,    
    // from forwarder
    input RegBus        reg1_rdata_i, 
    input RegBus        reg2_rdata_i,
    // from id
    input word         ALU_data1_i,
    input word         ALU_data2_i,
    input aluop        ALU_op_i, 
    input logic        reg_we_i,        // 写通用寄存器标志
    input RegAddrBus   reg_waddr_i,      // 写通用寄存器地址
    input OpcodeWide   opcode_i,
    input word         IL_imm_i ,
    input word         S_imm_i  ,
    input word         B_imm_i  ,
    input word         U_imm_i  ,
    input word         JAL_imm_i,
    input ExCode       ex_code_i , 
    input InstAddrBus  pc_i,
    //from ctrl
    input logic         ex_hold_flag,
    input logic         ex_scour_flag,
    input  logic        jump_bp_i ,
    output logic        jump_bp_o ,
    //to ex
        //to alu
    output word         ALU_data1_o,
    output word         ALU_data2_o,
    output aluop        ALU_op_o, 
        //to ex
    output RegBus       reg1_rdata_o, 
    output RegBus       reg2_rdata_o,
    output logic        reg_we_o,        // 写通用寄存器标志
    output RegAddrBus   reg_waddr_o,      // 写通用寄存器地址
    output OpcodeWide   opcode_o,
    output word         IL_imm_o ,
    output word         S_imm_o  ,
    output word         B_imm_o  ,
    output word         U_imm_o  ,
    output word         JAL_imm_o,
    output ExCode       ex_code_o,
    output InstAddrBus  pc_o
);


    always_ff @( posedge clk ) begin 
        if ((!rst_n)||ex_scour_flag) begin
            reg1_rdata_o<= `ZeroWord;
            reg2_rdata_o<= `ZeroWord;
            ALU_data1_o <= `ZeroWord;
            ALU_data2_o <= `ZeroWord;
            ALU_op_o    <= `ZeroWord;
            reg_we_o    <= `ZeroWord;
            reg_waddr_o <= `ZeroReg ;
            opcode_o    <= `ZeroWord;
            IL_imm_o    <= `ZeroWord;
            S_imm_o     <= `ZeroWord;
            B_imm_o     <= `ZeroWord;
            U_imm_o     <= `ZeroWord;
            JAL_imm_o   <= `ZeroWord;
            ex_code_o   <= `ZeroWord;
            pc_o        <= `ZeroWord;
            jump_bp_o   <= 1'b0;
            ex_code_o   <= NOP;
        end else if (ex_hold_flag)begin
            reg1_rdata_o<= reg1_rdata_o;
            reg2_rdata_o<= reg2_rdata_o;
            ALU_data1_o <= ALU_data1_o;
            ALU_data2_o <= ALU_data2_o;
            ALU_op_o    <= ALU_op_o   ;
            reg_we_o    <= reg_we_o   ;
            reg_waddr_o <= reg_waddr_o;
            opcode_o    <= opcode_o   ;
            IL_imm_o    <= IL_imm_o   ;
            S_imm_o     <= S_imm_o    ;
            B_imm_o     <= B_imm_o    ;
            U_imm_o     <= U_imm_o    ;
            JAL_imm_o   <= JAL_imm_o  ;
            ex_code_o   <= ex_code_o  ;
            pc_o        <= pc_o       ;
            jump_bp_o   <= jump_bp_o  ;
            ex_code_o   <= ex_code_o  ;
        end else begin
            reg1_rdata_o<= reg1_rdata_i;
            reg2_rdata_o<= reg2_rdata_i;
            ALU_data1_o <= ALU_data1_i;
            ALU_data2_o <= ALU_data2_i;
            ALU_op_o    <= ALU_op_i   ;
            reg_we_o    <= reg_we_i   ;
            reg_waddr_o <= reg_waddr_i;
            opcode_o    <= opcode_i   ;
            IL_imm_o    <= IL_imm_i   ;
            S_imm_o     <= S_imm_i    ;
            B_imm_o     <= B_imm_i    ;
            U_imm_o     <= U_imm_i    ;
            JAL_imm_o   <= JAL_imm_i  ;
            ex_code_o   <= ex_code_i  ;
            pc_o        <= pc_i       ;
            jump_bp_o   <= jump_bp_i  ;
            ex_code_o   <= ex_code_i  ;
        end
    end
endmodule