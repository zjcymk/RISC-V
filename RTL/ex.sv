`include "defines.sv"
import type_pkg::*;
import opcode_pkg::*;
module ex( 
    //from id
    input RegBus       reg1_rdata_i,    // 通用寄存器1数据
    input RegBus       reg2_rdata_i,    // 通用寄存器2数据
    input logic        reg_we_i,        // 写通用寄存器标志
    input RegAddrBus   reg_waddr_i,     // 写通用寄存器地址
    input word         imm1_i,
    input word         imm2_i,
    input ExCode       ex_code_i,     
    input OpcodeWide   opcode_i,
    input InstAddrBus  pc_i,
    //to ALU
    output word        ALU_data1_o,
    output word        ALU_data2_o,
    output aluop       ALU_op_o,
    //from ALU
    input word         ALU_result_i,
    input logic        ALU_busy_i,

    //to MEM
    output MemBus     mem_wdata_o,    // 写内存数据
    output MemAddrBus mem_raddr_o,    // 读内存地址
    output MemAddrBus mem_waddr_o,    // 写内存地址
    output logic      mem_we_o,       // 是否要写内存
    output MemIndex   r_index_o,
    output MemIndex   w_index_o,
    
    // to MEM --> reg
    output RegBus     reg_wdata_o,   // 写寄存器数据
    output logic      reg_we_o,      // 是否要写通用寄存器
    output RegAddrBus reg_waddr_o,   // 写通用寄存器地址

    // to ctrl
    output logic        hold_flag_o,  // 是否暂停标志
    output logic        jump_flag_o,  // 是否跳转标志
    output InstAddrBus  jump_addr_o   // 跳转目的地址

);
InstAddrBus jump_addr;
assign jump_addr = pc_i + imm1_i;
assign data_ex_o = reg_wdata_o;
assign r_index_o = (reg1_rdata_i + imm1_i) & 2'b11;
assign w_index_o = (reg1_rdata_i + imm1_i) & 2'b11;

assign reg_we_o = reg_we_i;
assign reg_waddr_o = reg_waddr_i;
always_comb begin
    case (ex_code_i)
        ADDI: begin
            ALU_data1_o = reg1_rdata_i;
            ALU_data2_o = imm1_i;
            ALU_op_o    = alu_add;
            mem_wdata_o = `ZeroWord;
            mem_raddr_o = `ZeroWord;
            mem_waddr_o = `ZeroWord;
            mem_we_o    = `WriteDisable;
            reg_wdata_o = ALU_result_i;
            jump_flag_o = `JumpDisable;
            jump_addr_o = `ZeroWord;
        end
        ADD: begin
            ALU_data1_o = reg1_rdata_i;
            ALU_data2_o = reg2_rdata_i;
            ALU_op_o    = alu_add;
            mem_wdata_o = `ZeroWord;
            mem_raddr_o = `ZeroWord;
            mem_waddr_o = `ZeroWord;
            mem_we_o    = `WriteDisable;
            reg_wdata_o = ALU_result_i;
            jump_flag_o = `JumpDisable;
            jump_addr_o = `ZeroWord;
        end
        //INST_TYPE_B
        BEQ  :begin
            ALU_data1_o = reg1_rdata_i;
            ALU_data2_o = reg2_rdata_i;
            ALU_op_o    = alu_eq;
            mem_wdata_o = `ZeroWord;
            mem_raddr_o = `ZeroWord;
            mem_waddr_o = `ZeroWord;
            mem_we_o    = `WriteDisable;
            reg_wdata_o = `ZeroWord;
            jump_flag_o = (ALU_result_i) & `JumpEnable;
            jump_addr_o = jump_addr;
        end
        BNE  :begin
            ALU_data1_o = reg1_rdata_i;
            ALU_data2_o = reg2_rdata_i;
            ALU_op_o    = alu_eq;
            mem_wdata_o = `ZeroWord;
            mem_raddr_o = `ZeroWord;
            mem_waddr_o = `ZeroWord;
            mem_we_o    = `WriteDisable;
            reg_wdata_o = `ZeroWord;
            jump_flag_o = (~ALU_result_i) & `JumpEnable;
            jump_addr_o = jump_addr; 
        end
        BLT  :begin
            ALU_data1_o = reg1_rdata_i;
            ALU_data2_o = reg2_rdata_i;
            ALU_op_o    = alu_ge_s;
            mem_wdata_o = `ZeroWord;
            mem_raddr_o = `ZeroWord;
            mem_waddr_o = `ZeroWord;
            mem_we_o    = `WriteDisable;
            reg_wdata_o = `ZeroWord;
            jump_flag_o = (~ALU_result_i) & `JumpEnable;
            jump_addr_o = jump_addr; 
        end
        BGE  :begin
            ALU_data1_o = reg1_rdata_i;
            ALU_data2_o = reg2_rdata_i;
            ALU_op_o    = alu_ge_s;
            mem_wdata_o = `ZeroWord;
            mem_raddr_o = `ZeroWord;
            mem_waddr_o = `ZeroWord;
            mem_we_o    = `WriteDisable;
            reg_wdata_o = `ZeroWord;
            jump_flag_o = (ALU_result_i) & `JumpEnable;
            jump_addr_o = jump_addr; 
        end
        BLTU :begin
            ALU_data1_o = reg1_rdata_i;
            ALU_data2_o = reg2_rdata_i;
            ALU_op_o    = alu_ge_u;
            mem_wdata_o = `ZeroWord;
            mem_raddr_o = `ZeroWord;
            mem_waddr_o = `ZeroWord;
            mem_we_o    = `WriteDisable;
            reg_wdata_o = `ZeroWord;
            jump_flag_o = (~ALU_result_i) & `JumpEnable;
            jump_addr_o = jump_addr;  
        end
        BGEU :begin
            ALU_data1_o = reg1_rdata_i;
            ALU_data2_o = reg2_rdata_i;
            ALU_op_o    = alu_ge_u;
            mem_wdata_o = `ZeroWord;
            mem_raddr_o = `ZeroWord;
            mem_waddr_o = `ZeroWord;
            mem_we_o    = `WriteDisable;
            reg_wdata_o = `ZeroWord;
            jump_flag_o = (ALU_result_i) & `JumpEnable;
            jump_addr_o = jump_addr; 
        end
        //INST_TYPE_L
        LB :begin
            ALU_data1_o = reg1_rdata_i;
            ALU_data2_o = imm1_i;
            ALU_op_o    = alu_add;
            mem_wdata_o = `ZeroWord;
            mem_raddr_o = ALU_result_i;
            mem_waddr_o = `ZeroWord;
            mem_we_o    = `WriteDisable;
            reg_wdata_o = `ZeroWord;
            jump_flag_o = `JumpDisable;
            jump_addr_o = `ZeroWord;
        end
        LH :begin
            ALU_data1_o = reg1_rdata_i;
            ALU_data2_o = imm1_i;
            ALU_op_o    = alu_add;
            mem_wdata_o = `ZeroWord;
            mem_raddr_o = ALU_result_i;
            mem_waddr_o = `ZeroWord;
            mem_we_o    = `WriteDisable;
            reg_wdata_o = `ZeroWord;
            jump_flag_o = `JumpDisable;
            jump_addr_o = `ZeroWord;
        end
        LW :begin
            ALU_data1_o = reg1_rdata_i;
            ALU_data2_o = imm1_i;
            ALU_op_o    = alu_add;
            mem_wdata_o = `ZeroWord;
            mem_raddr_o = ALU_result_i;
            mem_waddr_o = `ZeroWord;
            mem_we_o    = `WriteDisable;
            reg_wdata_o = `ZeroWord;
            jump_flag_o = `JumpDisable;
            jump_addr_o = `ZeroWord;   
        end
        LBU:begin
            ALU_data1_o = reg1_rdata_i;
            ALU_data2_o = imm1_i;
            ALU_op_o    = alu_add;
            mem_wdata_o = `ZeroWord;
            mem_raddr_o = ALU_result_i;
            mem_waddr_o = `ZeroWord;
            mem_we_o    = `WriteDisable;
            reg_wdata_o = `ZeroWord;
            jump_flag_o = `JumpDisable;
            jump_addr_o = `ZeroWord;   
        end
        LHU:begin
            ALU_data1_o = reg1_rdata_i;
            ALU_data2_o = imm1_i;
            ALU_op_o    = alu_add;
            mem_wdata_o = `ZeroWord;
            mem_raddr_o = ALU_result_i;
            mem_waddr_o = `ZeroWord;
            mem_we_o    = `WriteDisable;
            reg_wdata_o = `ZeroWord;
            jump_flag_o = `JumpDisable;
            jump_addr_o = `ZeroWord;  
        end
        // INST_TYPE_S
        SB: begin
            ALU_data1_o = reg1_rdata_i;
            ALU_data2_o = imm1_i;
            ALU_op_o    = alu_add;
            mem_wdata_o = `ZeroWord;
            mem_raddr_o = ALU_result_i;
            mem_waddr_o = ALU_result_i;
            mem_we_o    = `WriteEnable;
            reg_wdata_o = `ZeroWord;
            jump_flag_o = `JumpDisable;
            jump_addr_o = `ZeroWord;  
        end
        SH: begin
            ALU_data1_o = reg1_rdata_i;
            ALU_data2_o = imm1_i;
            ALU_op_o    = alu_add;
            mem_wdata_o = `ZeroWord;
            mem_raddr_o = ALU_result_i;
            mem_waddr_o = ALU_result_i;
            mem_we_o    = `WriteEnable;
            reg_wdata_o = `ZeroWord;
            jump_flag_o = `JumpDisable;
            jump_addr_o = `ZeroWord;  
        end
        SW: begin
            ALU_data1_o = reg1_rdata_i;
            ALU_data2_o = imm1_i;
            ALU_op_o    = alu_add;
            mem_wdata_o = `ZeroWord;
            mem_raddr_o = ALU_result_i;
            mem_waddr_o = ALU_result_i;
            mem_we_o    = `WriteEnable;
            reg_wdata_o = `ZeroWord;
            jump_flag_o = `JumpDisable;
            jump_addr_o = `ZeroWord;              
        end
        default: begin
            ALU_data1_o = `ZeroWord;
            ALU_data2_o = `ZeroWord;
            ALU_op_o    = alu_nop;
            mem_wdata_o = `ZeroWord;
            mem_raddr_o = `ZeroWord;
            mem_waddr_o = `ZeroWord;
            mem_we_o    = `WriteDisable;
            reg_wdata_o = ALU_result_i;
            jump_flag_o = `JumpDisable;
            jump_addr_o = `ZeroWord;
        end
    endcase
end
endmodule