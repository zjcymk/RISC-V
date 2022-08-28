`include "defines.sv"
import type_pkg::*;
import id_pkg::*;
module ctrl(
    input  logic        clk,
    input  logic        rst_n,
    //from ex
    input  InstAddrBus  pc_ex_i    ,
    input  logic        jump_flag_i,
    input  logic        bp_jump_ex,
    input  OpcodeWide   ex_opcode_i,
    input  RegAddrBus   ex_waddr_i ,
    input  InstAddrBus  pc_jump_i    ,
    input  logic        ALU_busy_i,
    //from id
    input  RegAddrBus   id_raddr1_i,
    input  RegAddrBus   id_raddr2_i,
    input  InstAddrBus  pc_id_i    ,
    //to id_ex
    output logic        hold_A_flag,
    output logic        hold_B_flag,
    output logic        scour_flag,
    //to if
    output logic        jump_bp,
    //from pc_reg
    input  InstAddrBus  pc_i    ,
    input  InstBus      inst_i,
    //to pc_reg 
    output InstAddrBus  pc_o    
);
logic j_type;
logic   hold_flag1,
        hold_flag2;

assign hold_A_flag = hold_flag1 | hold_flag2 | ALU_busy_i;
assign hold_B_flag = ALU_busy_i;
assign scour_flag = jump_flag_i ^ bp_jump_ex ;

always_comb begin
    if ((ex_opcode_i == INST_TYPE_L) && (ex_waddr_i == id_raddr1_i)) begin
        hold_flag1 = 1'b1;
    end else begin
        hold_flag1 = 1'b0;
    end
end
always_comb begin
    if ((ex_opcode_i == INST_TYPE_L) && (ex_waddr_i == id_raddr2_i)) begin
        hold_flag2 = 1'b1;
    end else begin
        hold_flag2 = 1'b0;
    end
end



always_comb begin
    unique case (inst_i[6:0])
        INST_TYPE_B,INST_JAL,INST_JALR: j_type = 1'b1;
        default: j_type = 1'b0;
    endcase
end

word list   [0:31];
always_ff @( posedge clk ) begin 
    if (!rst_n) begin
        for (int i = 0 ; i<32 ; i++ ) begin
            list[i] = `ZeroWord;
        end
    end else if (scour_flag == `True) begin
        if (list[pc_ex_i[3:0]] == `ZeroWord) begin
            list[pc_ex_i[3:0]] <= pc_jump_i;
        end else begin
            list[pc_ex_i[3:0]] <= `ZeroWord;
        end
    end else begin
        list <= list;
    end
end    

always_comb begin
    if (j_type) begin
        if (list[pc_i[3:0]] != `ZeroWord) begin
            unique case ({jump_flag_i,bp_jump_ex})
                2'b00,2'b11: begin
                    pc_o    = list[pc_i[3:0]];
                    jump_bp = `JumpEnable;  
                end
                2'b01: begin
                    pc_o    = pc_i + 32'd4;
                    jump_bp = `JumpDisable;  
                end
                2'b10: begin
                    pc_o    = pc_jump_i;
                    jump_bp = `JumpDisable;  
                end
            endcase
        end else begin
            jump_bp = `JumpDisable;
            pc_o    = pc_jump_i;
        end
    end else begin
        if (scour_flag == `True) begin
            pc_o    = pc_jump_i;
            jump_bp = `JumpDisable;
        end else begin
            pc_o    = pc_i;
            jump_bp = `JumpDisable;
        end
    end
end



endmodule
