`include "defines.sv"
import type_pkg::*;
module pc_reg (
    
    input  logic        clk,
    input  logic        rst_n,
    
    input  logic        pc_hold_flag,
    input  logic        jump_flag_i ,
    input  logic        jump_bp ,
    input  InstAddrBus  pc_i,
    output InstAddrBus  pc_o
);
    logic ctrl;

    always_ff @( posedge clk ) begin 
        if (rst_n == `RstEnable) begin
            pc_o <= `CpuResetAddr;
        end else if (pc_hold_flag) begin
            pc_o <= pc_o;
        end else if (jump_flag_i || jump_bp) begin
            pc_o <= pc_i;
        end else begin
            pc_o <= pc_o + 32'd4;
        end
    end
endmodule