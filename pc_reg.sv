`include "defines.sv"

module pc_reg (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        hold,
    input  InstAddrBus  pc_i,
    output InstAddrBus  pc_o
);
    always_ff @( posedge clk ) begin 
        if (rst_n == `RstEnable) begin
            pc_o <= `CpuResetAddr;
        end else if (hold) begin
            pc_o <= pc_i;
        end else begin
            pc_o <= pc_o + 32'b1;
        end
    end
endmodule