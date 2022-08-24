package id_pkg;
    
enum logic [6:0] { 
    INST_TYPE_I = 7'b0010011,
    INST_TYPE_R = 7'b0110011,
    INST_TYPE_L = 7'b0000011,
    INST_TYPE_S = 7'b0100011,
    INST_TYPE_B = 7'b1100011,
    INST_LUI_U  = 7'b0110111,
    INST_AUIPC_U= 7'b0010111,
    INST_JAL    = 7'b1101111,
    INST_JALR   = 7'b1100111
} opcode_a;
// I type inst
enum logic [2:0] { 
    INST_ADDI  = 3'b000,
    INST_SLTI  = 3'b010,
    INST_SLTIU = 3'b011,
    INST_XORI  = 3'b100,
    INST_ORI   = 3'b110,
    INST_ANDI  = 3'b111,
    INST_SLLI  = 3'b001,
    INST_SRLI  = 3'b101
} I_funct3;


// L type inst
enum logic [2:0] {
    INST_LB   = 3'b000,
    INST_LH   = 3'b001,
    INST_LW   = 3'b010,
    INST_LBU  = 3'b100,
    INST_LHU  = 3'b101
} L_funct3;


// S type inst
enum logic [2:0] { 
    INST_SB   = 3'b000,
    INST_SH   = 3'b001,
    INST_SW   = 3'b010
} S_funct3;


// R and M type inst
enum logic [2:0] { 
    INST_ADD_SUB = 3'b000,
    INST_SLL     = 3'b001,
    INST_SLT     = 3'b010,
    INST_SLTU    = 3'b011,
    INST_XOR     = 3'b100,
    INST_SRAL    = 3'b101,
    INST_OR      = 3'b110,
    INST_AND     = 3'b111
} R_funct3R;
enum logic [2:0] { 
    INST_MUL    = 3'b000,
    INST_MULH   = 3'b001,
    INST_MULHSU = 3'b010,
    INST_MULHU  = 3'b011,
    INST_DIV    = 3'b100,
    INST_DIVU   = 3'b101,
    INST_REM    = 3'b110,
    INST_REMU   = 3'b111
} R_funct3M;
enum logic [6:0] { 
    A_f7 = 7'b0000000,
    B_f7 = 7'b0100000,
    C_f7 = 7'b0000001
} funct7_R;


// U type inst


// B type inst
enum logic [2:0] { 
    INST_BEQ  = 3'b000,
    INST_BNE  = 3'b001,
    INST_BLT  = 3'b100,
    INST_BGE  = 3'b101,
    INST_BLTU = 3'b110,
    INST_BGEU = 3'b111
} B_funct3;
endpackage