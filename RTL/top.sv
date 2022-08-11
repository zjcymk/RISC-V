import type_pkg::*;
module top (
    input logic clk,
    input logic rst_n   
);


InstAddrBus pc;
InstAddrBus pc_ex;
InstAddrBus pc_mem;
InstBus     inst;
InstAddrBus pc_ctrl;
logic       pc_flag;
logic       jump_flag;
InstAddrBus jump_addr;
logic       ex_hold_flag;
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
logic       ram_we;
MemAddrBus  ram_raddr;
MemBus      ram_rdata;
ExCode      ex_code_mem;
OpcodeWide  opcode_mem;


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
pc_reg  u_pc_reg (
    .clk         ( clk          ),
    .rst_n       ( rst_n        ),
    .pc_i        ( pc_ctrl   ) ,
    .ctrl        ( pc_flag   ) ,
    .pc_o        ( pc   ) 
);

rom  u_rom (
    .pc_i        (pc   ),
    .inst        (inst    ) 
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
    //from ex
    .jump_flag_i   (jump_flag  ),
    .ex_opcode_i   (opcode_ex),
    .ex_waddr_i    (ex_waddr_i),
    .pc_ex_i       ( jump_addr ),
    //from id  
    .id_raddr1_i   (rd1),
    .id_raddr2_i   (rd2),
    .pc_id_i       (pc),
    //to id_ex  
    .ex_hold_flag  ( ex_hold_flag  ),
    //to pc_reg 
    .pc_id_o       (pc_ctrl),
    .pc_hold_flag  (pc_flag)
);
id  u_id (
    .clk           ( clk            ),
    .rst_n         ( rst_n          ),
    .inst_i        ( inst          ),
    .inst_addr_i   ( inst_addr_i    ),


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
    .reg1_rdata_i  ( reg1_rdata_i   ),
    .reg2_rdata_i  ( reg2_rdata_i   ),
    .reg_we_i      ( id_we_i       ),
    .reg_waddr_i   ( id_waddr_i    ),
    .imm1_i        ( imm1_i         ),
    .imm2_i        ( imm2_i         ),
    .ex_code_i     ( ex_code_id      ),
    .opcode_i      ( opcode_id      ),
    .pc_i          (pc              ),
    .ex_hold_flag  ( ex_hold_flag   ),
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
    .mem_we_o      (ram_we_ex   ) ,   
    .r_index_o     (r_index_ex  ) ,
    .w_index_o     (w_index_ex  ) ,
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
    .mem_we_i    (ram_we_ex     ) ,   
    .r_index_i   (r_index_ex    ) ,
    .w_index_i   (w_index_ex    ) ,
    .mem_wdata_o (ram_wdata_mem ) ,
    .mem_raddr_o (ram_raddr_mem ) ,
    .mem_waddr_o (ram_waddr_mem ) ,
    .mem_we_o    (ram_we_mem    ) ,   
    .r_index_o   (r_index_mem   ) ,
    .w_index_o   (w_index_mem   ) ,    
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
    .mem_we_i    (ram_we_mem    ) ,   
    .r_index     (r_index_mem   ) ,
    .w_index     (w_index_mem   ) ,
    .mem_wdata_o ( ram_wdata   ),
    .mem_raddr_o ( ram_raddr  ),
    .mem_waddr_o ( ram_waddr      ),
    .mem_we_o    ( ram_we  ), 
    .mem_rdata_i ( ram_rdata  ), 
    .mem_data_o  (mem_data      ),
    .mem_addr_o  (mem_addr      ),
    .reg_wdata_o ( wdata    ),
    .reg_we_o    ( we       ),
    .reg_waddr_o ( waddr    )
);
ram  u_ram (
    .clk          ( clk           ),
    .rst_n        ( rst_n         ),
    .mem_wdata_i  ( ram_wdata   ),
    .mem_waddr_i  ( ram_waddr   ),
    .mem_we_i     ( ram_we      ),
    .mem_raddr_i  ( ram_raddr   ),

    .mem_rdata_o  ( ram_rdata   )
);

endmodule