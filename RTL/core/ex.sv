`include "defines.sv"
import type_pkg::*;
import opcode_pkg::*;
module ex( 
    // from id
    input RegBus       reg1_rdata_i, 
    input RegBus       reg2_rdata_i,
    input word         IL_imm_i ,
    input word         S_imm_i  ,
    input word         B_imm_i  ,
    input word         U_imm_i  ,
    input word         JAL_imm_i,
    input ExCode       ex_code_i , 
    input InstAddrBus  pc_i,
    //from ALU
    input DoubleRegBus ALU_result_i,
    input logic        ALU_busy_i,
    //to MEM
    output MemBus      mem_wdata_o,
    output MemAddrBus  mem_raddr_o,
    output MemAddrBus  mem_waddr_o,
    // to MEM --> reg
    output RegBus      reg_wdata_o,
    // to ctrl
    output logic       jump_flag_o,
    output InstAddrBus jump_addr_o 
);
InstAddrBus jump_addr;
assign jump_addr = pc_i + B_imm_i;
assign mem_wdata_o =    ({32{(ex_code_i == ADDI  ) || (ex_code_i == SLTI ) || (ex_code_i == SLTIU) ||
                             (ex_code_i == XORI  ) || (ex_code_i == ORI  ) || (ex_code_i == ANDI ) ||   
                             (ex_code_i == SLLI  ) || (ex_code_i == SRLI ) || (ex_code_i == SRAI ) ||
                             (ex_code_i == ADD   ) || (ex_code_i == SUB  ) || (ex_code_i == SLL  ) ||
                             (ex_code_i == SLT   ) || (ex_code_i == SLTU ) || (ex_code_i == XOR  ) ||
                             (ex_code_i == SRA   ) || (ex_code_i == SRL  ) || (ex_code_i == OR   ) ||
                             (ex_code_i == AND   ) || (ex_code_i == MUL  ) || (ex_code_i == MULH ) ||
                             (ex_code_i == MULHSU) || (ex_code_i == MULHU) || (ex_code_i == DIV  ) ||
                             (ex_code_i == DIVU  ) || (ex_code_i == REM  ) || (ex_code_i == REMU ) ||
                             (ex_code_i == LB    ) || (ex_code_i == LH   ) || (ex_code_i == LW   ) ||
                             (ex_code_i == LBU   ) || (ex_code_i == LHU  ) || (ex_code_i == BEQ  ) ||
                             (ex_code_i == BNE   ) || (ex_code_i == BLT  ) || (ex_code_i == BGE  ) ||
                             (ex_code_i == BLTU  ) || (ex_code_i == BGEU ) || (ex_code_i == LUI  ) ||
                             (ex_code_i == AUIPC ) || (ex_code_i == JAL  ) || (ex_code_i == JALR ) ||
                             (ex_code_i == NOP   ) }} & 
                        `ZeroWord) | 
                        ({32{(ex_code_i == SB    ) || (ex_code_i == SH   ) || (ex_code_i == SW   ) }} & 
                        reg2_rdata_i) ;

assign mem_waddr_o =    ({32{(ex_code_i == ADDI  ) || (ex_code_i == SLTI ) || (ex_code_i == SLTIU) ||
                             (ex_code_i == XORI  ) || (ex_code_i == ORI  ) || (ex_code_i == ANDI ) ||   
                             (ex_code_i == SLLI  ) || (ex_code_i == SRLI ) || (ex_code_i == SRAI ) ||
                             (ex_code_i == ADD   ) || (ex_code_i == SUB  ) || (ex_code_i == SLL  ) ||
                             (ex_code_i == SLT   ) || (ex_code_i == SLTU ) || (ex_code_i == XOR  ) ||
                             (ex_code_i == SRA   ) || (ex_code_i == SRL  ) || (ex_code_i == OR   ) ||
                             (ex_code_i == AND   ) || (ex_code_i == MUL  ) || (ex_code_i == MULH ) ||
                             (ex_code_i == MULHSU) || (ex_code_i == MULHU) || (ex_code_i == DIV  ) ||
                             (ex_code_i == DIVU  ) || (ex_code_i == REM  ) || (ex_code_i == REMU ) ||
                             (ex_code_i == LB    ) || (ex_code_i == LH   ) || (ex_code_i == LW   ) ||
                             (ex_code_i == LBU   ) || (ex_code_i == LHU  ) || (ex_code_i == BEQ  ) ||
                             (ex_code_i == BNE   ) || (ex_code_i == BLT  ) || (ex_code_i == BGE  ) ||
                             (ex_code_i == BLTU  ) || (ex_code_i == BGEU ) || (ex_code_i == LUI  ) ||
                             (ex_code_i == AUIPC ) || (ex_code_i == JAL  ) || (ex_code_i == JALR ) ||
                             (ex_code_i == NOP   ) }} & 
                        `ZeroWord) | 
                        ({32{(ex_code_i == SB    ) || (ex_code_i == SH   ) || (ex_code_i == SW   ) }} & 
                        ALU_result_i[31:0]) ;

assign mem_raddr_o =    ({32{(ex_code_i == ADDI  ) || (ex_code_i == SLTI ) || (ex_code_i == SLTIU) ||
                             (ex_code_i == XORI  ) || (ex_code_i == ORI  ) || (ex_code_i == ANDI ) ||
                             (ex_code_i == SLLI  ) || (ex_code_i == SRLI ) || (ex_code_i == SRAI ) ||
                             (ex_code_i == ADD   ) || (ex_code_i == SUB  ) || (ex_code_i == SLL  ) ||
                             (ex_code_i == SLT   ) || (ex_code_i == SLTU ) || (ex_code_i == XOR  ) ||
                             (ex_code_i == SRA   ) || (ex_code_i == SRL  ) || (ex_code_i == OR   ) ||
                             (ex_code_i == AND   ) || (ex_code_i == MUL  ) || (ex_code_i == MULH ) ||
                             (ex_code_i == MULHSU) || (ex_code_i == MULHU) || (ex_code_i == DIV  ) ||
                             (ex_code_i == DIVU  ) || (ex_code_i == REM  ) || (ex_code_i == REMU ) ||
                             (ex_code_i == SB    ) || (ex_code_i == SH   ) || (ex_code_i == BEQ  ) ||
                             (ex_code_i == BNE   ) || (ex_code_i == BLT  ) || (ex_code_i == BGE  ) ||
                             (ex_code_i == BLTU  ) || (ex_code_i == BGEU ) || (ex_code_i == LUI  ) ||
                             (ex_code_i == AUIPC ) || (ex_code_i == JAL  ) || (ex_code_i == JALR ) ||
                             (ex_code_i == NOP   ) || (ex_code_i == SW   )  }} & 
                        `ZeroWord) | 
                        ({32{(ex_code_i == LB    ) || (ex_code_i == LH   ) || (ex_code_i == LW   ) ||
                             (ex_code_i == LBU   ) || (ex_code_i == LHU  )  }} & 
                        ALU_result_i[31:0]) ;

assign jump_flag_o =    ({32{(ex_code_i == ADDI  ) || (ex_code_i == SLTI ) || (ex_code_i == SLTIU) ||
                             (ex_code_i == XORI  ) || (ex_code_i == ORI  ) || (ex_code_i == ANDI ) ||
                             (ex_code_i == SLLI  ) || (ex_code_i == SRLI ) || (ex_code_i == SRAI ) ||
                             (ex_code_i == ADD   ) || (ex_code_i == SUB  ) || (ex_code_i == SLL  ) ||
                             (ex_code_i == SLT   ) || (ex_code_i == SLTU ) || (ex_code_i == XOR  ) ||
                             (ex_code_i == SRA   ) || (ex_code_i == SRL  ) || (ex_code_i == OR   ) ||
                             (ex_code_i == AND   ) || (ex_code_i == MUL  ) || (ex_code_i == MULH ) ||
                             (ex_code_i == MULHSU) || (ex_code_i == MULHU) || (ex_code_i == DIV  ) ||
                             (ex_code_i == DIVU  ) || (ex_code_i == REM  ) || (ex_code_i == REMU ) ||
                             (ex_code_i == SB    ) || (ex_code_i == SH   ) || 
                             (ex_code_i == LUI   ) || (ex_code_i == AUIPC) ||(ex_code_i == NOP   ) || 
                             (ex_code_i == SW    ) || (ex_code_i == LB   ) || (ex_code_i == LH   ) || 
                             (ex_code_i == LW    ) ||(ex_code_i == LBU   ) || (ex_code_i == LHU  ) }} & 
                        `ZeroWord) | 
                        ({32{(ex_code_i == BEQ   ) || (ex_code_i == BGE  ) || (ex_code_i == BGEU ) }} & 
                        ((ALU_result_i[31:0]) & `JumpEnable)) |
                        ({32{(ex_code_i == BNE   ) || (ex_code_i == BLT  ) || (ex_code_i == BLTU  ) }} & 
                        ((~ALU_result_i[31:0]) & `JumpEnable)) |
                        ({32{ (ex_code_i == JAL  ) || (ex_code_i == JALR ) }} & 
                        `JumpEnable) ;

assign jump_addr_o =    ({32{(ex_code_i == ADDI  ) || (ex_code_i == SLTI ) || (ex_code_i == SLTIU) ||
                             (ex_code_i == XORI  ) || (ex_code_i == ORI  ) || (ex_code_i == ANDI ) ||
                             (ex_code_i == SLLI  ) || (ex_code_i == SRLI ) || (ex_code_i == SRAI ) ||
                             (ex_code_i == ADD   ) || (ex_code_i == SUB  ) || (ex_code_i == SLL  ) ||
                             (ex_code_i == SLT   ) || (ex_code_i == SLTU ) || (ex_code_i == XOR  ) ||
                             (ex_code_i == SRA   ) || (ex_code_i == SRL  ) || (ex_code_i == OR   ) ||
                             (ex_code_i == AND   ) || (ex_code_i == MUL  ) || (ex_code_i == MULH ) ||
                             (ex_code_i == MULHSU) || (ex_code_i == MULHU) || (ex_code_i == DIV  ) ||
                             (ex_code_i == DIVU  ) || (ex_code_i == REM  ) || (ex_code_i == REMU ) ||
                             (ex_code_i == SB    ) || (ex_code_i == SH   ) || (ex_code_i == LUI  ) || 
                             (ex_code_i == AUIPC ) || (ex_code_i == NOP  ) || (ex_code_i == SW   ) || 
                             (ex_code_i == LB    ) || (ex_code_i == LH   ) || (ex_code_i == LW   ) ||
                             (ex_code_i == LBU   ) || (ex_code_i == LHU  ) }} & 
                        `ZeroWord) | 
                        ({32{ (ex_code_i == BEQ  ) ||(ex_code_i == BNE   ) || (ex_code_i == BLT  ) || 
                              (ex_code_i == BGE  ) ||(ex_code_i == BLTU  ) || (ex_code_i == BGEU ) }} & 
                        jump_addr) |
                        ({32{ (ex_code_i == JAL  ) }} & 
                        (pc_i + IL_imm_i)) |
                        ({32{ (ex_code_i == JALR ) }} & 
                        (reg1_rdata_i + JAL_imm_i)) ;

assign reg_wdata_o =    ({32{(ex_code_i == ADDI  ) || 
                             (ex_code_i == XORI  ) || (ex_code_i == ORI  ) || (ex_code_i == ANDI ) ||
                             (ex_code_i == SLLI  ) || (ex_code_i == SRLI ) || (ex_code_i == SRAI ) ||
                             (ex_code_i == ADD   ) || (ex_code_i == SUB  ) || (ex_code_i == SLL  ) ||
                             (ex_code_i == XOR   ) ||
                             (ex_code_i == SRA   ) || (ex_code_i == SRL  ) || (ex_code_i == OR   ) ||
                             (ex_code_i == AND   ) || (ex_code_i == MUL  ) || (ex_code_i == MULH ) ||
                             (ex_code_i == DIV   ) || (ex_code_i == DIVU ) || (ex_code_i == REM  ) || 
                             (ex_code_i == REMU  ) || (ex_code_i == LUI  ) || (ex_code_i == AUIPC) ||
                             (ex_code_i == JAL  ) || (ex_code_i == JALR ) }} & 
                        ALU_result_i[31:0]) | 
                        ({32{(ex_code_i == SLTI  ) || (ex_code_i == SLTIU) ||(ex_code_i == SLT   ) || 
                             (ex_code_i == SLTU )}} & 
                        {32{(~ALU_result_i[31:0])}}) | 
                        ({32{(ex_code_i == MULH  ) || (ex_code_i == MULHU)}} & 
                        ALU_result_i[63:32]) | 
                        ({32{(ex_code_i == SB    ) || (ex_code_i == SH   ) || (ex_code_i == NOP  ) || 
                             (ex_code_i == SW    ) || 
                             (ex_code_i == LB    ) || (ex_code_i == LH   ) || (ex_code_i == LW   ) ||
                             (ex_code_i == LBU   ) || (ex_code_i == LHU  ) || (ex_code_i == BEQ  ) ||
                             (ex_code_i == BNE   ) || (ex_code_i == BLT  ) || (ex_code_i == BGE  ) ||
                             (ex_code_i == BLTU  ) || (ex_code_i == BGEU ) || (ex_code_i == NOP  ) }} & 
                        `ZeroWord) |
                        ({32{(ex_code_i == LUI   ) || (ex_code_i == AUIPC )}} & 
                        U_imm_i) |
                        ({32{(ex_code_i == MULHSU)}} & 
                        ((reg1_rdata_i[31] == 1'b1) ? ~ALU_result_i[63:32]+1 : ALU_result_i[63:32])) ;
endmodule