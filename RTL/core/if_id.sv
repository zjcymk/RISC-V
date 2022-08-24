`include "defines.sv"
import type_pkg::*;
module if_id (
    
    input  logic        clk,
    input  logic        rst_n,
    
    input  logic        id_hold_flag,
    input  logic        id_scour_flag,

    input  InstBus      inst_i,
    input  InstAddrBus  pc_i,
    input  logic        jump_bp_i ,
    output logic        jump_bp_o ,
    output InstBus      inst_o,
    output InstAddrBus  pc_o
);
    always_ff @( posedge clk ) begin 
        if ((!rst_n)||id_scour_flag) begin
            pc_o        <= `ZeroWord;
            inst_o      <= `ZeroWord;
            jump_bp_o   <= 1'b0;
        end else if (id_hold_flag) begin
            pc_o        <= pc_o;
            inst_o      <= inst_o;
            jump_bp_o   <= jump_bp_o;
        end else begin
            pc_o        <= pc_i;
            inst_o      <= inst_i;
            jump_bp_o   <= jump_bp_i;
        end
    end
endmodule