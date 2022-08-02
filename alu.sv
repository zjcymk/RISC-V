`include "defines.sv"
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
        alu_add: begin
            ALU_result_o = ADD_S;
        end
        alu_sub:begin
            ALU_result_o = ALU_data1_i - ALU_data2_i;
        end
        default: begin
            ALU_result_o = `ZeroWord;
        end
    endcase
end
adder_32bit u_32bit(
.A    (ALU_data1_i),
.B    (ALU_data2_i),
.Cin  (1'b0),
.S    (ADD_S)
);
endmodule