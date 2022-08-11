package opcode_pkg;
import type_pkg::*;
enum ExCode { 
    NOP,
// I type inst
    ADDI,SLTI,SLTIU,XORI,ORI,ANDI,SLLI,SRI,
// R type inst 
    ADD ,SUB,SLL,SLT,SLTU,XOR,SRA,SRL,OR,AND,
// L type inst   
    LB, LH, LW, LBU,LHU,
// S type inst
    SB,SH,SW,
// B type inst
    BEQ,BNE,BLT,BGE,BLTU,BGEU
} ex_code_e;

enum aluop { 
    alu_nop,
    alu_add,
    alu_sub,
    alu_eq,
    alu_ge_u,
    alu_ge_s
} ALU_op;
endpackage