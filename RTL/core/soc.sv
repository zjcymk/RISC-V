import type_pkg::*;
module soc (
    input logic clk,
    input logic rst_n   
);
InstAddrBus pc_rom  ;
InstBus     inst_rom;

MemBus      m_rdata;
MemBus      m_wdata;
MemAddrBus  m_raddr;
MemAddrBus  m_waddr;
logic [3:0] m_we   ; 


MemAddrBus    s0_waddr;
MemBus        s0_wdata;
logic [3:0]   s0_we   ;
MemAddrBus    s0_raddr;
MemBus        s0_rdata;

MemAddrBus    s1_waddr;
MemBus        s1_wdata;
logic [3:0]   s1_we   ;
MemAddrBus    s1_raddr;
MemBus        s1_rdata;


core u_core(
    .clk        (clk  ),
    .rst_n      (rst_n),

    .pc_rom     (pc_rom  ),
    .inst_rom   (inst_rom),

    .mem_rdata  (m_rdata),
    .mem_wdata  (m_wdata),
    .mem_raddr  (m_raddr),
    .mem_waddr  (m_waddr),
    .mem_we     (m_we   ) 
);
rom  u_rom (
    .pc_i        (pc_rom   ),
    .inst        (inst_rom ) 
);
ram_ctrl  u_ram_ctrl (
    .clk          ( clk           ),
    .rst_n        ( rst_n         ),
    .mem_wdata_i  ( s0_wdata   ),
    .mem_waddr_i  ( s0_waddr   ),
    .mem_we_i     ( s0_we      ),
    .mem_raddr_i  ( s0_raddr   ),

    .mem_rdata_o  ( s0_rdata   )
);
ram_ctrl  u_gpio (
    .clk          ( clk           ),
    .rst_n        ( rst_n         ),
    .mem_wdata_i  ( s1_wdata   ),
    .mem_waddr_i  ( s1_waddr   ),
    .mem_we_i     ( s1_we      ),
    .mem_raddr_i  ( s1_raddr   ),

    .mem_rdata_o  ( s1_rdata   )
);
bus u_bus(
    //m0
    .m_waddr    (m_waddr ),
    .m_wdata    (m_wdata ),
    .m_we       (m_we    ),
    .m_raddr    (m_raddr ),
    .m_rdata    (m_rdata ),   
    //s0
    .s0_waddr   (s0_waddr),
    .s0_wdata   (s0_wdata),
    .s0_we      (s0_we   ),
    .s0_raddr   (s0_raddr),
    .s0_rdata   (s0_rdata),
    //s1
    .s1_waddr   (s1_waddr),
    .s1_wdata   (s1_wdata),
    .s1_we      (s1_we   ),
    .s1_raddr   (s1_raddr),
    .s1_rdata   (s1_rdata)
    
);
endmodule