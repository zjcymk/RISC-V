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
InstAddrBus pc_mem;
InstBus     inst_id;
InstAddrBus pc_ctrl;
logic       pc_hold_flag;
logic       jump_flag;
logic       jump_bp_if;
logic       jump_bp_id;
logic       jump_bp_ex;
InstAddrBus jump_addr;
logic       hold_flag;
logic       scour_flag;
logic       we;    
RegAddrBus  waddr;
RegBus      wdata; 
RegAddrBus  raddr1;
RegAddrBus  raddr2;
RegBus      rdata1;
RegBus      rdata2; 
RegBus      ex1_rdata;
RegBus      ex2_rdata;
RegBus      ex_data ;
RegAddrBus  ex_addr ;
RegBus      mem_data;
RegAddrBus  mem_addr;
RegAddrBus  rd1     ;
RegAddrBus  rd2     ;
ExCode      ex_code_id;
ExCode      ex_code_ex;
RegBus      ex_data1;
RegBus      ex_data2;
logic       id_we_i ;   
RegAddrBus  id_waddr_i; 
word        imm1_i;
word        imm2_i;
word        imm1_o;
word        imm2_o;
OpcodeWide  opcode_id;
logic       ex_we_i   ;
RegAddrBus  ex_waddr_i;
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
logic       ram_we_ex;
MemAddrBus  ram_raddr_ex;
MemIndex    r_index_ex;
MemIndex    w_index_ex;

MemAddrBus  ram_waddr_mem;
MemBus      ram_wdata_mem;
logic       ram_we_mem;
MemAddrBus  ram_raddr_mem;
MemIndex    r_index_mem;
MemIndex    w_index_mem;

MemAddrBus  ram_waddr;
MemBus      ram_wdata;
logic [3:0] ram_we;
MemAddrBus  ram_raddr;
MemBus      ram_rdata;
ExCode      ex_code_mem;
OpcodeWide  opcode_mem;



pc_reg  u_pc_reg (
    .clk         ( clk          ),
    .rst_n       ( rst_n        ),
    .pc_i        ( pc_ctrl   ) ,
    .pc_hold_flag( hold_flag ),
    .jump_flag_i ( scour_flag ),
    .jump_bp     ( jump_bp_if ),
    .pc_o        ( pc_rom   ) 
);

cache  u_cache (
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

    .ex_data1_o    ( ex_data1    ),
    .ex_data2_o    ( ex_data2    ),
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
    .ex_waddr_i    (ex_waddr_i),
    .pc_jump_i     ( jump_addr ),
    .ALU_busy_i    ( ALU_busy   ),
    //from id  
    .id_raddr1_i   (rd1),
    .id_raddr2_i   (rd2),
    .pc_id_i       (pc_id),
    //to id_ex  
    .hold_flag     ( hold_flag  ),
    .scour_flag    ( scour_flag ),
    //to if
    .jump_bp       ( jump_bp_if  ),
    //from pc_reg
    .pc_i          ( pc_rom ),
    .inst_i        ( inst_rom ),
    //to pc_reg 
    .pc_o          (pc_ctrl),
    .pc_hold_flag  (pc_hold_flag)
);
if_id  u_if_id(
    
    .clk            (clk),
    .rst_n          (rst_n),
    .id_hold_flag   (hold_flag ),
    .id_scour_flag  (scour_flag),
    .inst_i         (inst_rom),
    .pc_i           (pc_rom),
    .jump_bp_i      (jump_bp_if   ),
    .jump_bp_o      (jump_bp_id   ),
    .inst_o         (inst_id),
    .pc_o           (pc_id)
);
id  u_id (
    .clk           ( clk            ),
    .rst_n         ( rst_n          ),
    .inst_i        ( inst_id        ),
    .pc_id         ( pc_id    ),


    .id_addr1_o    ( rd1     ),
    .id_addr2_o    ( rd2     ),
    .reg1_raddr_o  ( reg1_raddr_o   ),
    .reg2_raddr_o  ( reg2_raddr_o   ),
    .reg1_rdata_o  ( reg1_rdata_o   ),
    .reg2_rdata_o  ( reg2_rdata_o   ),
    .reg_we_o      ( id_we_i      ),
    .reg_waddr_o   ( id_waddr_i   ),
    .imm1_o        ( imm1_i         ),
    .imm2_o        ( imm2_i         ),
    .opcode_o      ( opcode_id     ),
    .ex_code_o     ( ex_code_id      )
);


id_ex  u_id_ex (
    .clk           ( clk            ),
    .rst_n         ( rst_n          ),
    .ex_data1_i    ( ex_data1     ),
    .ex_data2_i    ( ex_data2     ),
    .reg_we_i      ( id_we_i       ),
    .reg_waddr_i   ( id_waddr_i    ),
    .imm1_i        ( imm1_i         ),
    .imm2_i        ( imm2_i         ),
    .ex_code_i     ( ex_code_id      ),
    .opcode_i      ( opcode_id      ),
    .pc_i          (pc_id           ),
    //from ctrl
    .ex_hold_flag  ( hold_flag   ),
    .ex_scour_flag ( scour_flag  ),
    .jump_bp_i     ( jump_bp_id  ),
    .jump_bp_o     ( jump_bp_ex  ),
    .opcode_o      ( opcode_ex      ),
    .reg1_rdata_o  ( ex1_rdata   ),
    .reg2_rdata_o  ( ex2_rdata   ),
    .reg_we_o      ( ex_we_i       ),
    .reg_waddr_o   ( ex_waddr_i    ),
    .imm1_o        ( imm1_o         ),
    .imm2_o        ( imm2_o         ),
    .ex_code_o     ( ex_code_ex      ),
    .pc_o          (pc_ex)
);
ex  u_ex(
    .reg1_rdata_i  ( ex1_rdata ),
    .reg2_rdata_i  ( ex2_rdata ),
    .reg_we_i      ( ex_we_i     ),
    .reg_waddr_i   ( ex_waddr_i  ),
    .imm1_i        ( imm1_o       ),
    .imm2_i        ( imm2_o       ),
    .ex_code_i     ( ex_code_ex    ),
    .pc_i          ( pc_ex   ),
    .ALU_result_i  ( ALU_result ),
    .ALU_busy_i    ( ALU_busy   ),
    .opcode_i      ( opcode_ex      ),
    .ALU_data1_o   ( ALU_data1 ),
    .ALU_data2_o   ( ALU_data2 ),
    .ALU_op_o      ( ALU_op    ),
    .mem_wdata_o   (ram_wdata_ex) ,
    .mem_raddr_o   (ram_raddr_ex) ,
    .mem_waddr_o   (ram_waddr_ex) , 
    .reg_wdata_o   (  ex_wdata ),
    .reg_we_o      (  ex_we    ),
    .reg_waddr_o   (  ex_waddr ),
    .jump_flag_o   ( jump_flag ),
    .jump_addr_o   ( jump_addr )
);
alu  u_alu (
    .clk         (   clk     ),
    .rst_n       (   rst_n   ),
    .ALU_data1_i ( ALU_data1     ),
    .ALU_data2_i ( ALU_data2     ),
    .ALU_op_i    ( ALU_op      ),

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