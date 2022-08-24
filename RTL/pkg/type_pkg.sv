package type_pkg;
typedef logic [31:0] word;
typedef logic [63:0] DoubleWord;
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
// RAM 
typedef logic [7:0] RAMBus;
typedef logic [7:0] RAMAddrBus;
//other
typedef logic [7:0] ExCode;
typedef logic [7:0] aluop;
endpackage