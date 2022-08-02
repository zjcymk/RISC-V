`include "defines.sv"
module ex(
    input  logic        clk,
    input  logic        rst_n,
    
    //from id
    input RegBus       reg1_rdata_i,    // 通用寄存器1数据
    input RegBus       reg2_rdata_i,    // 通用寄存器2数据
    input logic        reg_we_i,        // 写通用寄存器标志
    input RegAddrBus   reg_waddr_i,     // 写通用寄存器地址
    input word         imm1_i,
    input word         imm2_i,
    input ExCode       ex_code_i,     
    input OpcodeWide   opcode_i,
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
    output logic      mem_req_o,      // 请求访问内存标志
    output MemIndex   r_index_o,
    output MemIndex   w_index_o,
    input  OpcodeWide opcode_o,
    // to MEM --> WB
    output RegBus     reg_wdata_o,   // 写寄存器数据
    output logic      reg_we_o,      // 是否要写通用寄存器
    output RegAddrBus reg_waddr_o,   // 写通用寄存器地址

    // to ctrl
    output logic        hold_flag_o,  // 是否暂停标志
    output logic        jump_flag_o,  // 是否跳转标志
    output InstAddrBus  jump_addr_o   // 跳转目的地址

);
assign data_ex_o = reg_wdata_o;
assign r_index_o = (reg1_rdata_i + imm1_i) & 2'b11;
assign w_index_o = (reg1_rdata_i + imm1_i) & 2'b11;
always_comb begin
    reg_we_o = reg_we_i;
    reg_waddr_o = reg_waddr_i;
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
            hold_flag_o = `HoldDisable;
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
            hold_flag_o = `HoldDisable;
            jump_flag_o = `JumpDisable;
            jump_addr_o = `ZeroWord;
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
            hold_flag_o = `HoldDisable;
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
            hold_flag_o = `HoldDisable;
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
            hold_flag_o = `HoldDisable;
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
            hold_flag_o = `HoldDisable;
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
            hold_flag_o = `HoldDisable;
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
            mem_we_o    = `WriteDisable;
            reg_wdata_o = `ZeroWord;
            hold_flag_o = `HoldDisable;
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
            mem_we_o    = `WriteDisable;
            reg_wdata_o = `ZeroWord;
            hold_flag_o = `HoldDisable;
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
            mem_we_o    = `WriteDisable;
            reg_wdata_o = `ZeroWord;
            hold_flag_o = `HoldDisable;
            jump_flag_o = `JumpDisable;
            jump_addr_o = `ZeroWord;              
        end
        default: begin
            ALU_data1_o = `ZeroWord;
            ALU_data2_o = `ZeroWord;
            ALU_op_o    = alu_add;
            mem_wdata_o = `ZeroWord;
            mem_raddr_o = `ZeroWord;
            mem_waddr_o = `ZeroWord;
            mem_we_o    = `WriteDisable;
            reg_wdata_o = ALU_result_i;
            hold_flag_o = `HoldDisable;
            jump_flag_o = `JumpDisable;
            jump_addr_o = `ZeroWord;
        end
    endcase
end
endmodule