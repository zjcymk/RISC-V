`include "defines.sv"
module ram (
    input   logic        clk,
    input   logic        rst_n,

    input   MemBus       mem_wdata_i,
    input   MemAddrBus   mem_waddr_i,
    input   logic        mem_we_i, 

    input   MemAddrBus   mem_raddr_i,
    output  MemBus       mem_rdata_o
);

logic [31:0] ram [0:127];
always_ff @( posedge clk ) begin
    if(mem_we_i) begin
        ram[mem_waddr_i] <= mem_wdata_i;
    end

end
always_comb begin
    mem_rdata_o = ram[mem_raddr_i];
end
endmodule