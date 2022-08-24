`include "defines.sv"
import type_pkg::*;
module ram (
    input   logic        clk,
    input   logic        rst_n,

    input   RAMBus       ram_wdata_i,
    input   RAMAddrBus   ram_waddr_i,
    input   logic        ram_we_i, 

    input   RAMAddrBus   ram_raddr_i,
    output  RAMBus       ram_rdata_o
);

logic [8:0] ram [0:8];
always_ff @( posedge clk ) begin
    if(ram_we_i) begin
        ram[ram_waddr_i] <= ram_wdata_i;
    end

end
always_comb begin
    ram_rdata_o = ram[ram_raddr_i];
end
endmodule