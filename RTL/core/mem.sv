`include "defines.sv"
import type_pkg::*;
import opcode_pkg::*;
module mem (      
    // from ex
    input RegBus        reg_wdata_i,   // 写寄存器数据
    input logic         reg_we_i,      // 是否要写通用寄存器
    input RegAddrBus    reg_waddr_i,   // 写通用寄存器地址    
    input MemAddrBus    mem_raddr_i,
    input MemBus        mem_wdata_i,    
    input MemAddrBus    mem_waddr_i,
    input ExCode        ex_code_i,
    input OpcodeWide    opcode_i,
    //from RAM
    input MemBus        mem_rdata_i,
    // to RAM
    output MemBus      mem_wdata_o,
    output MemAddrBus  mem_raddr_o,
    output MemAddrBus  mem_waddr_o,
    output logic [3:0] mem_we_o,  
    //to 
    output RegBus      mem_data_o,   // 写寄存器数据
    output RegAddrBus  mem_addr_o,   // 写通用寄存器地址
    // to regs
    output RegBus      reg_wdata_o,   // 写寄存器数据
    output logic       reg_we_o,      // 是否要写通用寄存器
    output RegAddrBus  reg_waddr_o   // 写通用寄存器地址

);
assign mem_data_o = reg_wdata_o;
assign mem_addr_o = reg_waddr_o;
//assign reg_wdata_o = reg_wdata_i;
assign reg_we_o    = reg_we_i   ;
assign reg_waddr_o = reg_waddr_i;
assign mem_raddr_o = mem_raddr_i;
assign mem_waddr_o = mem_waddr_i;
logic[1:0]  w_index = mem_raddr_i[1:0];
logic[1:0]  r_index = mem_waddr_i[1:0];

always_comb begin
    unique case (ex_code_i)
        LB :begin
            unique case (r_index)
                2'b00: begin
                    reg_wdata_o = {{24{mem_rdata_i[7]}}, mem_rdata_i[7:0]};
                end
                2'b01: begin
                    reg_wdata_o = {{24{mem_rdata_i[15]}}, mem_rdata_i[15:8]};
                end
                2'b10: begin
                    reg_wdata_o = {{24{mem_rdata_i[23]}}, mem_rdata_i[23:16]};
                end
                default: begin
                    reg_wdata_o = {{24{mem_rdata_i[31]}}, mem_rdata_i[31:24]};
                end
            endcase
        end
        LH :begin
            if (r_index == 2'b0) begin
                reg_wdata_o = {{16{mem_rdata_i[15]}}, mem_rdata_i[15:0]};
            end else begin
                reg_wdata_o = {{16{mem_rdata_i[31]}}, mem_rdata_i[31:16]};
            end
        end
        LW :begin
            reg_wdata_o = mem_rdata_i;
        end
        LBU:begin
            case (r_index)
                2'b00: begin
                    reg_wdata_o = {24'h0, mem_rdata_i[7:0]};
                end
                2'b01: begin
                    reg_wdata_o = {24'h0, mem_rdata_i[15:8]};
                end
                2'b10: begin
                    reg_wdata_o = {24'h0, mem_rdata_i[23:16]};
                end
                default: begin
                    reg_wdata_o = {24'h0, mem_rdata_i[31:24]};
                end
            endcase
        end
        LHU:begin
            if (r_index) begin
                reg_wdata_o = {16'h0, mem_rdata_i[15:0]};
            end else begin
                reg_wdata_o = {16'h0, mem_rdata_i[31:16]};
            end
        end
        default:begin
            reg_wdata_o = reg_wdata_i;
        end
    endcase
end

always_comb begin
    case (ex_code_i)
        SB: begin
           case (w_index)
                2'b00: begin
                    mem_we_o    = 4'b0001;
                    mem_wdata_o = {24'b0,   mem_wdata_i[7:0]     };
                end
                2'b01: begin
                    mem_we_o    = 4'b0010;	
                    mem_wdata_o = {16'b0,   mem_wdata_i[7:0], 8'b0};
                end
                2'b10: begin
                    mem_we_o    = 4'b0100;	
                    mem_wdata_o = {8'b0,    mem_wdata_i[7:0],16'b0};
                end
                default: begin
                    mem_we_o    = 4'b1000;	
                    mem_wdata_o = {         mem_rdata_i[7:0],24'b0};
                end
            endcase 
        end
        SH: begin
            if (w_index == 2'b00) begin
                mem_we_o    = 4'b0011;	
                mem_wdata_o = {16'b0, mem_wdata_i[15:0]};
            end else begin
                mem_we_o    = 4'b1100;	
                mem_wdata_o = {mem_rdata_i[15:0],16'b0};
            end
        end
        SW: begin
            mem_we_o    = 4'b1111;
            mem_wdata_o = mem_wdata_i;
            //mem_wdata_o = 32'd5431;
        end
        default :begin
            mem_we_o    = 4'b0000;
            mem_wdata_o = `ZeroWord;
        end
    endcase
end

endmodule