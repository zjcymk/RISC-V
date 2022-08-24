`include "defines.sv"
import type_pkg::*;
module ram_ctrl (
    input   logic        clk,
    input   logic        rst_n,

    input   MemBus       mem_wdata_i,
    input   MemAddrBus   mem_waddr_i,
    input   logic [3:0]  mem_we_i, 

    input   MemAddrBus   mem_raddr_i,
    output  MemBus       mem_rdata_o
);

RAMAddrBus ram_waddr;
RAMAddrBus ram_raddr;
assign ram_waddr = mem_waddr_i[9:2];
assign ram_raddr = mem_raddr_i[9:2];
ram  u_ram1 (
    .clk          ( clk             ),
    .rst_n        ( rst_n           ),
    .ram_wdata_i  ( mem_wdata_i[7:0]),
    .ram_waddr_i  ( ram_waddr       ),
    .ram_we_i     ( mem_we_i[0]     ),
    .ram_raddr_i  ( ram_raddr       ),

    .ram_rdata_o  ( mem_rdata_o[7:0])
);
ram  u_ram2 (
    .clk          ( clk                 ),
    .rst_n        ( rst_n               ),
    .ram_wdata_i  ( mem_wdata_i[15:8]   ),
    .ram_waddr_i  ( ram_waddr           ),
    .ram_we_i     ( mem_we_i[1]         ),
    .ram_raddr_i  ( ram_raddr           ),

    .ram_rdata_o  ( mem_rdata_o[15:8]   )
);
ram  u_ram3 (
    .clk          ( clk                 ),
    .rst_n        ( rst_n               ),
    .ram_wdata_i  ( mem_wdata_i[23:16]  ),
    .ram_waddr_i  ( ram_waddr           ),
    .ram_we_i     ( mem_we_i[2]         ),
    .ram_raddr_i  ( ram_raddr           ),

    .ram_rdata_o  ( mem_rdata_o[23:16]  )
);
ram  u_ram4 (
    .clk          ( clk                 ),
    .rst_n        ( rst_n               ),
    .ram_wdata_i  ( mem_wdata_i[31:24]  ),
    .ram_waddr_i  ( ram_waddr           ),
    .ram_we_i     ( mem_we_i[3]         ),
    .ram_raddr_i  ( ram_raddr           ),

    .ram_rdata_o  ( mem_rdata_o[31:24]  )
);
endmodule