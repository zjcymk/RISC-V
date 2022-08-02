`include "defines.sv"
module top (
    input logic clk,
    input logic rst_n
);


InstAddrBus pc;
InstBus     inst;
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
RegBus      wb_data ;
RegAddrBus  wb_addr ;
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
RegBus      mem_wdata_i;
logic       mem_we_i   ;
RegAddrBus  mem_waddr_i;
RegBus      mem_wdata;
logic       mem_we   ;
RegAddrBus  mem_waddr;
RegBus      wb_wdata;
logic       wb_we   ;
RegAddrBus  wb_waddr;

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
    .wb_data_i     ( wb_data     ),
    .wb_addr_i     ( wb_addr     ),
    .rd1_i         ( rd1         ),
    .rd2_i         ( rd2         ),
    .reg1_rdata_i  ( rdata1  ),
    .reg2_rdata_i  ( rdata2  ),

    .ex_data1_o    ( ex_data1    ),
    .ex_data2_o    ( ex_data2    ),
    .reg1_raddr_o  ( raddr1  ),
    .reg2_raddr_o  ( raddr2  )
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

    .reg1_rdata_o  ( ex1_rdata   ),
    .reg2_rdata_o  ( ex2_rdata   ),
    .reg_we_o      ( ex_we_i       ),
    .reg_waddr_o   ( ex_waddr_i    ),
    .imm1_o        ( imm1_o         ),
    .imm2_o        ( imm2_o         ),
    .ex_code_o     ( ex_code_ex      )
);
ex  u_ex(
    .clk           ( clk          ),
    .rst_n         ( rst_n        ),
    .reg1_rdata_i  ( ex1_rdata ),
    .reg2_rdata_i  ( ex2_rdata ),
    .reg_we_i      ( ex_we_i     ),
    .reg_waddr_i   ( ex_waddr_i  ),
    .imm1_i        ( imm1_o       ),
    .imm2_i        ( imm2_o       ),
    .ex_code_i     ( ex_code_ex    ),
    .ALU_result_i  ( ALU_result ),
    .ALU_busy_i    ( ALU_busy   ),

    .ALU_data1_o   ( ALU_data1 ),
    .ALU_data2_o   ( ALU_data2 ),
    .ALU_op_o      ( ALU_op    ),
    .reg_wdata_o   (  ex_wdata ),
    .reg_we_o      (  ex_we    ),
    .reg_waddr_o   (  ex_waddr ),
    .hold_flag_o   ( hold_flag_o ),
    .jump_flag_o   ( jump_flag_o ),
    .jump_addr_o   ( jump_addr_o )
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

    .ex_data_o   ( ex_data     ),
    .ex_addr_o   ( ex_addr     ),
    .mem_data_o  (mem_data     ),
    .mem_addr_o  (mem_addr     ),
    .reg_wdata_o (mem_wdata_i     ),
    .reg_we_o    (mem_we_i        ),
    .reg_waddr_o (mem_waddr_i     )
);
mem  u_mem (
    .clk        (   clk         ),
    .rst_n      (   rst_n       ),
    .reg_wdata_i( mem_wdata_i   ),
    .reg_we_i   ( mem_we_i      ),
    .reg_waddr_i( mem_waddr_i   ),

    .reg_wdata_o( mem_wdata    ),
    .reg_we_o   ( mem_we       ),
    .reg_waddr_o( mem_waddr    )
);
mem_wb  u_mem_wb (
    .clk          (   clk         ),
    .rst_n        (   rst_n       ),
    .reg_wdata_i  ( mem_wdata   ),
    .reg_we_i     ( mem_we     ),
    .reg_waddr_i  ( mem_waddr   ),

    .wb_data_o    ( wb_data     ),
    .wb_addr_o    ( wb_addr     ),
    .reg_wdata_o  ( wb_wdata   ),
    .reg_we_o     ( wb_we      ),
    .reg_waddr_o  ( wb_waddr   )
);

wb  u_wb (
    .clk          (  clk         ),
    .rst_n        (  rst_n       ),
    .reg_wdata_i  (wb_wdata   ),
    .reg_we_i     (wb_we      ),
    .reg_waddr_i  (wb_waddr   ),

    .wb_data_o    (wb_data_o     ),
    .wb_addr_o    (wb_addr_o     ),
    .reg_wdata_o  (wdata   ),
    .reg_we_o     (we      ),
    .reg_waddr_o  (waddr   )
);
endmodule