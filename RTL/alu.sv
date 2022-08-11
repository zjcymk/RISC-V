`include "defines.sv"
import type_pkg::*;
import opcode_pkg::*;
module alu(
    input  logic        clk,
    input  logic        rst_n,

    input word ALU_data1_i,
    input word ALU_data2_i,
    input aluop ALU_op_i,

    output word ALU_result_o,
    output logic ALU_busy_o
);
word ADD_S;
always_comb begin
    unique case (ALU_op_i)
        alu_add : ALU_result_o = ADD_S;
        alu_sub : ALU_result_o = ALU_data1_i - ALU_data2_i;
        alu_eq  : ALU_result_o = (ALU_data1_i == ALU_data2_i);
        alu_ge_u: ALU_result_o = (ALU_data1_i >= ALU_data2_i);
        alu_ge_s: ALU_result_o = ($signed(ALU_data1_i) >= $signed(ALU_data2_i));
        alu_nop : ALU_result_o = `ZeroWord;
        default : ALU_result_o = `ZeroWord;
    endcase
end
adder_32bit u_32bit(
.A    (ALU_data1_i),
.B    (ALU_data2_i),
.Cin  (1'b0),
.S    (ADD_S)
);
endmodule