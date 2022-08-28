`include "defines.sv"
import type_pkg::*;
import opcode_pkg::*;
module alu(
    input  logic        clk,
    input  logic        rst_n,

    input  word         ALU_data1_i,
    input  word         ALU_data2_i,
    input  aluop        ALU_op_i,

    output DoubleRegBus ALU_result_o,
    output logic        ALU_busy_o
);
logic div_busy;
word dividend;
word divisor ;
word ADD_S;
word quotient;
word remainder;
assign ALU_busy_o = div_busy;
always_comb begin
    unique case (ALU_op_i)
        alu_add     : ALU_result_o = ALU_data1_i  +  ALU_data2_i;
        alu_sub     : ALU_result_o = ALU_data1_i  -  ALU_data2_i;
        alu_xor     : ALU_result_o = ALU_data1_i  ^  ALU_data2_i;
        alu_mul_u   : ALU_result_o = $unsigned(ALU_data1_i)  *  $unsigned(ALU_data2_i);
        alu_mul_s   : ALU_result_o = $signed(ALU_data1_i)  *  $signed(ALU_data2_i);
        alu_div_s   : ALU_result_o = quotient;
        alu_div_u   : ALU_result_o = quotient;
        alu_rem_s   : ALU_result_o = remainder;
        alu_rem_u   : ALU_result_o = remainder;
        alu_or      : ALU_result_o = ALU_data1_i  |  ALU_data2_i;
        alu_and     : ALU_result_o = ALU_data1_i  &  ALU_data2_i;
        alu_sll     : ALU_result_o = ALU_data1_i  << ALU_data2_i;
        alu_srl     : ALU_result_o = ALU_data1_i  >> ALU_data2_i;
        alu_sra     : ALU_result_o = ALU_data1_i >>> ALU_data2_i;
        alu_eq      : ALU_result_o = (ALU_data1_i == ALU_data2_i);
        alu_ge_u    : ALU_result_o = (ALU_data1_i >= ALU_data2_i);
        alu_ge_s    : ALU_result_o = ($signed(ALU_data1_i) >= $signed(ALU_data2_i));
        alu_nop     : ALU_result_o = `ZeroWord;
        default     : ALU_result_o = `ZeroWord;
    endcase
end
/*********DIV/REM*********/
parameter DATAWIDTH=32;
localparam IDLE =0;
localparam SUB  =1;
localparam SHIFT=2;
localparam DONE =3;

DoubleWord dividend_e ;
DoubleWord divisor_e  ;
word       quotient_e ;
word       remainder_e;

logic [1:0] current_state,next_state;
word count;
logic en;
assign en = ((ALU_op_i == alu_div_s ||
            ALU_op_i == alu_div_u ||
            ALU_op_i == alu_rem_s ||
            ALU_op_i == alu_rem_u) && current_state == 1'b0) ? 1'b1 : 1'b0;
always_comb begin
    unique case (ALU_op_i)
        alu_div_s : begin
            dividend = (ALU_data1_i[31] == 1'b1) ? (~ALU_data1_i + 1'b1) : ALU_data1_i;
            divisor  = (ALU_data2_i[31] == 1'b1) ? (~ALU_data2_i + 1'b1) : ALU_data2_i;
        end
        alu_div_u : begin
            dividend = ALU_data1_i;
            divisor  = ALU_data2_i;
        end
        alu_rem_s : begin
            dividend = (ALU_data1_i[31] == 1'b1) ? (~ALU_data1_i + 1'b1) : ALU_data1_i;
            divisor  = (ALU_data2_i[31] == 1'b1) ? (~ALU_data2_i + 1'b1) : ALU_data2_i;
        end
        alu_rem_u : begin
            dividend = ALU_data1_i;
            divisor  = ALU_data2_i;
        end
        default: begin
            dividend = ALU_data1_i;
            divisor  = ALU_data2_i;
        end
    endcase
end
always_ff@(posedge clk) begin
    if(!rst_n) current_state <= IDLE;
    else current_state <= next_state;
end


always_comb begin
    next_state <= 2'bx;
        case(current_state)
            IDLE: if(en) next_state <= SUB;
                else next_state <= IDLE;
            SUB:  next_state <= SHIFT;
            SHIFT:if(count < DATAWIDTH) next_state <= SUB;
                else next_state <= DONE;
            DONE: next_state <= IDLE;
        endcase
end


always_ff@(posedge clk) begin
    if(!rst_n)begin
      dividend_e  <= 0;
      divisor_e   <= 0;
      quotient_e  <= 0;
      remainder_e <= 0;
      count       <= 0;
    end 
    else begin 
        unique case(current_state)
           IDLE:begin
               dividend_e <= {{DATAWIDTH{1'b0}},dividend};
               divisor_e  <= {divisor,{DATAWIDTH{1'b0}}};
           end
           SUB:begin
               if(dividend_e>=divisor_e)begin
                   dividend_e <= dividend_e-divisor_e+1'b1;
                end
               else begin
                   dividend_e <= dividend_e;
               end
           end
           SHIFT:begin
               if(count<DATAWIDTH)begin
                   dividend_e <= dividend_e<<1;
                   count      <= count+1;      
               end
               else begin
                   quotient_e  <= dividend_e[DATAWIDTH-1:0];
                   remainder_e <= dividend_e[DATAWIDTH*2-1:DATAWIDTH];
               end
           end
           DONE:begin
               count <= 0;
           end    
        endcase
    end
end

assign quotient  = quotient_e;
assign remainder = remainder_e;
assign div_busy = (current_state==SUB  ||
                   current_state==SHIFT ) | en;

endmodule