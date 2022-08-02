`define CpuResetAddr 32'h0

`define RstEnable 1'b0
`define RstDisable 1'b1
`define ZeroWord 32'h0
`define ZeroReg 5'h0
`define WriteEnable 1'b1
`define WriteDisable 1'b0
`define ReadEnable 1'b1
`define ReadDisable 1'b0
`define True 1'b1
`define False 1'b0
`define ChipEnable 1'b1
`define ChipDisable 1'b0
`define JumpEnable 1'b1
`define JumpDisable 1'b0
`define DivResultNotReady 1'b0
`define DivResultReady 1'b1
`define DivStart 1'b1
`define DivStop 1'b0
`define HoldEnable 1'b1
`define HoldDisable 1'b0
`define Stop 1'b1
`define NoStop 1'b0
`define RIB_ACK 1'b1
`define RIB_NACK 1'b0
`define RIB_REQ 1'b1
`define RIB_NREQ 1'b0
`define INT_ASSERT 1'b1
`define INT_DEASSERT 1'b0

`define INT_BUS 7:0
`define INT_NONE 8'h0
`define INT_RET 8'hff
`define INT_TIMER0 8'b00000001
`define INT_TIMER0_ENTRY_ADDR 32'h4

`define Hold_Flag_Bus   2:0
`define Hold_None 3'b000
`define Hold_Pc   3'b001
`define Hold_If   3'b010
`define Hold_Id   3'b011

// J type inst
`define INST_JAL    7'b1101111
`define INST_JALR   7'b1100111

`define INST_LUI    7'b0110111
`define INST_AUIPC  7'b0010111
`define INST_NOP    32'h00000001
`define INST_NOP_OP 7'b0000001
`define INST_MRET   32'h30200073
`define INST_RET    32'h00008067

`define INST_FENCE  7'b0001111
`define INST_ECALL  32'h73
`define INST_EBREAK 32'h00100073

// CSR inst
`define INST_CSR    7'b1110011
`define INST_CSRRW  3'b001
`define INST_CSRRS  3'b010
`define INST_CSRRC  3'b011
`define INST_CSRRWI 3'b101
`define INST_CSRRSI 3'b110
`define INST_CSRRCI 3'b111

// CSR reg addr
`define CSR_CYCLE   12'hc00
`define CSR_CYCLEH  12'hc80
`define CSR_MTVEC   12'h305
`define CSR_MCAUSE  12'h342
`define CSR_MEPC    12'h341
`define CSR_MIE     12'h304
`define CSR_MSTATUS 12'h300
`define CSR_MSCRATCH 12'h340

`define RomNum 4096  // rom depth(how many words)

`define MemNum 4096  // memory depth(how many words)


//`define InstBus 31:0
//`define InstAddrBus 31:0

// common regs
//`define RegAddrBus 4:0
//`define RegBus 31:0
//`define DoubleRegBus 63:0
`define RegWidth 32
`define RegNum 32        // reg num
`define RegNumLog2 5

/*****typedef*****/ 
typedef logic [31:0] word;
// common regs
typedef word RegBus;
typedef logic [4:0]  RegAddrBus;
typedef logic [63:0] DoubleRegBus;
// Inst
typedef logic [6:0] OpcodeWide;
typedef word InstBus;
typedef word InstAddrBus;
// memory
typedef logic [31:0] MemBus;
typedef logic [31:0] MemAddrBus;
typedef logic [1:0]  MemIndex;


enum logic [6:0] { 
    INST_TYPE_I = 7'b0010011,
    INST_TYPE_R = 7'b0110011,
    INST_TYPE_L = 7'b0000011,
    INST_TYPE_S = 7'b0100011,
    INST_TYPE_B = 7'b1100011,
    INST_LUI_U  = 7'b0110111,
    INST_AUIPC_U= 7'b0010111
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
    INST_SRI   = 3'b101
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
    B_f7 = 7'b0100000
} funct7_add;


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

typedef logic [7:0] ExCode;
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

typedef logic [7:0] aluop;
enum aluop { 
    alu_add,
    alu_sub
} ALU_op;