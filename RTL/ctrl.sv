`include "defines.sv"
import type_pkg::*;
import id_pkg::*;
module ctrl(
    //from ex
    input  logic        jump_flag_i,
    input  OpcodeWide   ex_opcode_i,
    input  RegAddrBus   ex_waddr_i ,
    input  InstAddrBus  pc_ex_i    ,
    //from id
    input  RegAddrBus   id_raddr1_i,
    input  RegAddrBus   id_raddr2_i,
    input  InstAddrBus  pc_id_i    ,
    //to id_ex
    output logic        ex_hold_flag,
    //to pc_reg 
    output InstAddrBus  pc_id_o    ,
    output logic        pc_hold_flag
);

logic pc_ctrl1,pc_ctrl2,pc_ctrl3;
assign pc_hold_flag = pc_ctrl1 | pc_ctrl2 | pc_ctrl3;
assign ex_hold_flag = jump_flag_i;

always_comb begin
    if ((ex_opcode_i == INST_TYPE_L) && (ex_waddr_i == id_raddr1_i)) begin
        pc_ctrl1 = 1'b1;
    end else begin
        pc_ctrl1 = 1'b0;
    end
end
always_comb begin
    if ((ex_opcode_i == INST_TYPE_L) && (ex_waddr_i == id_raddr2_i)) begin
        pc_ctrl2 = 1'b1;
    end else begin
        pc_ctrl2 = 1'b0;
    end
end
always_comb begin
    if (jump_flag_i == `JumpEnable) begin
        pc_ctrl3 = 1'b1;
        pc_id_o  = pc_ex_i;
    end else begin
        pc_ctrl3 = 1'b0;
        pc_id_o  = pc_id_i;
    end
end

endmodule
