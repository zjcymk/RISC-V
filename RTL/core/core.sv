import type_pkg::*;
module core (
    input  logic clk,
    input  logic rst_n,

    output InstAddrBus pc_rom  , 
    input  InstBus     inst_rom,


    input  MemBus       mem_rdata,

    output MemBus       mem_wdata,
    output MemAddrBus   mem_raddr,
    output MemAddrBus   mem_waddr,
    output logic [3:0]  mem_we       
);


InstAddrBus pc_id;
InstAddrBus pc_ex;
InstBus     inst_id;
InstAddrBus pc_ctrl;
logic       jump_flag;
logic       jump_bp_if;
logic       jump_bp_id;
logic       jump_bp_ex;
InstAddrBus jump_addr;
logic       hold_A_flag;
logic       hold_B_flag;
logic       scour_flag;
logic       we;    
RegAddrBus  waddr;
RegBus      wdata; 
RegAddrBus  raddr1;
RegAddrBus  raddr2;
RegBus      rdata1;
RegBus      rdata2; 
RegBus      ex_data ;
RegAddrBus  ex_addr ;
RegBus      mem_data;
RegAddrBus  mem_addr;
RegAddrBus  rd1     ;
RegAddrBus  rd2     ;
ExCode      ex_code_id;
ExCode      ex_code_ex;
word        IL_imm_id ;
word        S_imm_id  ;
word        B_imm_id  ;
word        U_imm_id  ;
word        JAL_imm_id;
word        IL_imm ;
word        S_imm  ;
word        B_imm  ;
word        U_imm  ;
word        JAL_imm;
RegBus      reg1_rdata_id;
RegBus      reg2_rdata_id;
RegBus      reg1_rdata_ex;
RegBus      reg2_rdata_ex;
logic       id_we_i ;   
RegAddrBus  id_waddr_i; 
OpcodeWide  opcode_id;
word        ALU_data1_id;
word        ALU_data2_id;
aluop       ALU_op_id;
word        ALU_data1;
word        ALU_data2;
aluop       ALU_op;
word        ALU_result;
logic       ALU_busy;
RegBus      ex_wdata ;
logic       ex_we    ;
RegAddrBus  ex_waddr ;
OpcodeWide  opcode_ex;
MemBus      mem_wdata_i;
logic       mem_we_i   ;
MemAddrBus  mem_waddr_i;

MemAddrBus  ram_waddr_ex;
MemBus      ram_wdata_ex;
MemAddrBus  ram_raddr_ex;

MemAddrBus  ram_waddr_mem;
MemBus      ram_wdata_mem;
MemAddrBus  ram_raddr_mem;

ExCode      ex_code_mem;
OpcodeWide  opcode_mem;



pc_reg  u_pc_reg (
    .clk         ( clk          ),
    .rst_n       ( rst_n        ),
    .pc_i        ( pc_ctrl   ) ,
    .pc_hold_flag( hold_A_flag ),
    .jump_flag_i ( scour_flag ),
    .jump_bp     ( jump_bp_if ),
    .pc_o        ( pc_rom   ) 
);

forwarder  u_forwarder (
    .clk           ( clk           ),
    .rst_n         ( rst_n         ),
    .ex_data_i     ( ex_data       ),
    .ex_addr_i     ( ex_addr       ),
    .mem_data_i    ( mem_data    ),
    .mem_addr_i    ( mem_addr    ),
    .rd1_i         ( rd1         ),
    .rd2_i         ( rd2         ),
    .reg1_rdata_i  ( rdata1  ),
    .reg2_rdata_i  ( rdata2  ),

    .ex_data1_o    ( reg1_rdata_id ),
    .ex_data2_o    ( reg2_rdata_id ),
    .reg1_raddr_o  ( raddr1  ),
    .reg2_raddr_o  ( raddr2  )
);
ctrl u_ctrl(
    .clk           ( clk            ),
    .rst_n         ( rst_n          ),
    //from ex
    .jump_flag_i   (jump_flag  ),
    .bp_jump_ex    (jump_bp_ex  ),
    .pc_ex_i       ( pc_ex   ),
    .ex_opcode_i   (opcode_ex),
    .ex_waddr_i    (ex_waddr),
    .pc_jump_i     ( jump_addr ),
    .ALU_busy_i    ( ALU_busy   ),
    //from id  
    .id_raddr1_i   (rd1),
    .id_raddr2_i   (rd2),
    .pc_id_i       (pc_id),
    //to id_ex  
    .hold_A_flag   ( hold_A_flag  ),
    .hold_B_flag   ( hold_B_flag  ),
    .scour_flag    ( scour_flag ),
    //to if
    .jump_bp       ( jump_bp_if  ),
    //from pc_reg
    .pc_i          ( pc_rom ),
    .inst_i        ( inst_rom ),
    //to pc_reg 
    .pc_o          (pc_ctrl)
);
if_id  u_if_id(
    .clk            (clk),
    .rst_n          (rst_n),
    .id_hold_flag   (hold_A_flag ),
    .id_scour_flag  (scour_flag),
    .inst_i         (inst_rom),
    .pc_i           (pc_rom),
    .jump_bp_i      (jump_bp_if   ),
    .jump_bp_o      (jump_bp_id   ),
    .inst_o         (inst_id),
    .pc_o           (pc_id)
);
id  u_id (
    .inst_i             (inst_id),
    .pc_id              (pc_id),
    // to ALU   
    .ALU_data1_o        (ALU_data1_id),
    .ALU_data2_o        (ALU_data2_id),
    .ALU_op_o           (ALU_op_id   ),
    // from forwarder
    .reg1_rdata_i       (reg1_rdata_id), 
    .reg2_rdata_i       (reg2_rdata_id), 
    // to forwarder 
    .rs1                (rd1),
    .rs2                (rd2),
    //to ex_mem
    .reg_we_o           (id_we_i), 
    .reg_waddr_o        (id_waddr_i), 
    .opcode_o           (opcode_id),
    .IL_imm             (IL_imm_id ),
    .S_imm              (S_imm_id  ),
    .B_imm              (B_imm_id  ),
    .U_imm              (U_imm_id  ),
    .JAL_imm            (JAL_imm_id),
    .ex_code_o          (ex_code_id)
);


id_ex  u_id_ex (
    .clk           ( clk            ),
    .rst_n         ( rst_n          ),
    .reg1_rdata_i  ( reg1_rdata_id  ), 
    .reg2_rdata_i  ( reg2_rdata_id  ),
    // from id
    .ALU_data1_i    ( ALU_data1_id ),
    .ALU_data2_i    ( ALU_data2_id ),
    .ALU_op_i       ( ALU_op_id    ), 
    .reg_we_i       ( id_we_i ),     
    .reg_waddr_i    ( id_waddr_i ),  
    .opcode_i       ( opcode_id ),
    .IL_imm_i       ( IL_imm_id  ),
    .S_imm_i        ( S_imm_id   ),
    .B_imm_i        ( B_imm_id   ),
    .U_imm_i        ( U_imm_id   ),
    .JAL_imm_i      ( JAL_imm_id ),
    .ex_code_i      ( ex_code_id ), 
    .pc_i           ( pc_id ),
    //from ctrl
    .ex_hold_flag   ( hold_B_flag  ),
    .ex_scour_flag  ( scour_flag ),
    .jump_bp_i      (jump_bp_id   ),
    .jump_bp_o      (jump_bp_ex   ),
    //to ex
        //to alu
    .ALU_data1_o    ( ALU_data1 ),
    .ALU_data2_o    ( ALU_data2 ),
    .ALU_op_o       ( ALU_op    ), 
        //to ex
    .reg1_rdata_o   ( reg1_rdata_ex ), 
    .reg2_rdata_o   ( reg2_rdata_ex ),
    .reg_we_o       ( ex_we ),       
    .reg_waddr_o    ( ex_waddr ),    
    .opcode_o       ( opcode_ex ),
    .IL_imm_o       ( IL_imm  ),
    .S_imm_o        ( S_imm   ),
    .B_imm_o        ( B_imm   ),
    .U_imm_o        ( U_imm   ),
    .JAL_imm_o      ( JAL_imm ),
    .ex_code_o      ( ex_code_ex ),
    .pc_o           ( pc_ex )
);
ex  u_ex(
    // from id
    .reg1_rdata_i  (reg1_rdata_ex), 
    .reg2_rdata_i  (reg2_rdata_ex),
    .IL_imm_i      (IL_imm ),
    .S_imm_i       (S_imm  ),
    .B_imm_i       (B_imm  ),
    .U_imm_i       (U_imm  ),
    .JAL_imm_i     (JAL_imm),
    .ex_code_i     ( ex_code_ex ),
    .pc_i          ( pc_ex   ),
    //from ALU
    .ALU_result_i  ( ALU_result ),
    .ALU_busy_i    ( ALU_busy   ),
    //to MEM
    .mem_wdata_o   (ram_wdata_ex) ,
    .mem_raddr_o   (ram_raddr_ex) ,
    .mem_waddr_o   (ram_waddr_ex) , 
    // to MEM --> reg
    .reg_wdata_o   (  ex_wdata ),
    // to ctrl
    .jump_flag_o   ( jump_flag ),
    .jump_addr_o   ( jump_addr )
);
alu  u_alu (
    .clk         (   clk     ),
    .rst_n       (   rst_n   ),
    .ALU_data1_i ( ALU_data1     ),
    .ALU_data2_i ( ALU_data2     ),
    .ALU_op_i    ( ALU_op     ),
    
    .ALU_result_o ( ALU_result    ),
    .ALU_busy_o   ( ALU_busy     )
);
ex_mem  u_ex_mem (
    .clk         (  clk          ),
    .rst_n       (  rst_n        ),
    .reg_wdata_i ( ex_wdata   ),
    .reg_we_i    ( ex_we      ),
    .reg_waddr_i ( ex_waddr   ),
    .ex_code_i   (  ex_code_ex     ),
    .opcode_i    (  opcode_ex      ),
    .ex_code_o   (  ex_code_mem     ),
    .opcode_o    (  opcode_mem      ),
    .mem_wdata_i (ram_wdata_ex  ) ,
    .mem_raddr_i (ram_raddr_ex  ) ,
    .mem_waddr_i (ram_waddr_ex  ) ,
    .mem_wdata_o (ram_wdata_mem ) ,
    .mem_raddr_o (ram_raddr_mem ) ,
    .mem_waddr_o (ram_waddr_mem ) , 
    .ex_data_o   ( ex_data      ),
    .ex_addr_o   ( ex_addr      ),

    .reg_wdata_o (mem_wdata_i   ),
    .reg_we_o    (mem_we_i      ),
    .reg_waddr_o (mem_waddr_i   )
);
mem  u_mem (
    .reg_wdata_i ( mem_wdata_i   ),
    .reg_we_i    ( mem_we_i      ),
    .reg_waddr_i ( mem_waddr_i   ),
    .ex_code_i   (  ex_code_mem     ),
    .opcode_i    ( opcode_mem      ),
    .mem_wdata_i (ram_wdata_mem ) ,
    .mem_raddr_i (ram_raddr_mem ) ,
    .mem_waddr_i (ram_waddr_mem ) ,
    .mem_wdata_o ( mem_wdata   ),
    .mem_raddr_o ( mem_raddr  ),
    .mem_waddr_o ( mem_waddr      ),
    .mem_we_o    ( mem_we  ), 
    .mem_rdata_i ( mem_rdata  ), 
    .mem_data_o  (mem_data      ),
    .mem_addr_o  (mem_addr      ),
    .reg_wdata_o ( wdata    ),
    .reg_we_o    ( we       ),
    .reg_waddr_o ( waddr    )
);


regs  u_regs (
    .clk               ( clk      ),
    .rst_n             ( rst_n    ),
    .we_i              ( we     ),
    .waddr_i           ( waddr  ),
    .wdata_i           ( wdata  ),
    .raddr1_i          ( raddr1 ),
    .raddr2_i          ( raddr2 ),

    .rdata1_o          ( rdata1 ),
    .rdata2_o          ( rdata2 )
);

endmodule