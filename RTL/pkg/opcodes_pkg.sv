package opcode_pkg;
import type_pkg::*;
enum ExCode { 
    NOP,
// I type inst
    ADDI,SLTI,SLTIU,XORI,ORI,ANDI,SLLI,SRLI,SRAI,
// R type inst 
    ADD ,SUB,SLL,SLT,SLTU,XOR,SRA,SRL,OR,AND,
    // mul/div
        MUL,MULH,MULHSU,MULHU,DIV,DIVU,REM,REMU,
// L type inst   
    LB, LH, LW, LBU,LHU,
// S type inst
    SB,SH,SW,
// B type inst
    BEQ,BNE,BLT,BGE,BLTU,BGEU,
// U type inst
    LUI,AUIPC,
// J type inst
    JAL,JALR
} ex_code_e;

enum aluop { 
    alu_nop     ,
    alu_add     ,
    alu_sub     ,
    alu_mul_u   ,
    alu_mul_s   ,
    alu_div_s   ,
    alu_div_u   ,
    alu_rem_s   ,
    alu_rem_u   ,
    alu_xor     ,
    alu_or      ,
    alu_and     ,
    alu_sll     ,
    alu_srl     ,
    alu_sra     ,
    alu_eq      ,
    alu_ge_u    ,
    alu_ge_s
} ALU_op;
endpackage