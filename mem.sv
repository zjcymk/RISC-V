`include "defines.sv"
module mem (
    input  logic        clk,
    input  logic        rst_n,         
    // from ex
    input RegBus        reg_wdata_i,   // 写寄存器数据
    input logic         reg_we_i,      // 是否要写通用寄存器
    input RegAddrBus    reg_waddr_i,   // 写通用寄存器地址    
    input MemAddrBus    mem_raddr_i,
    input MemBus        mem_wdata_i,    
    input MemAddrBus    mem_waddr_i,
    input logic         mem_we_i,  
    input MemIndex      r_index,
    input MemIndex      w_index,
    input ExCode        ex_code_i,
    input OpcodeWide    opcode_i,
    // from 
    input MemBus       ram_rdata_i,  
    // to RAM
    output MemBus      mem_wdata_o,
    output MemAddrBus  mem_raddr_o,
    output MemAddrBus  mem_waddr_o,
    output logic       mem_we_o,   
    // to WB
    output OpcodeWide opcode_o,
    output RegBus     reg_wdata_o,   // 写寄存器数据
    output logic      reg_we_o,      // 是否要写通用寄存器
    output RegAddrBus reg_waddr_o   // 写通用寄存器地址

);
MemBus       mem_rdata_i;
//assign reg_wdata_o = reg_wdata_i;
assign reg_we_o    = reg_we_i   ;
assign reg_waddr_o = reg_waddr_i;
assign opcode_o    = opcode_i;
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
                    mem_wdata_o = {mem_rdata_i[31:8],  mem_wdata_i[7:0]};
                end
                2'b01: begin
                    mem_wdata_o = {mem_rdata_i[31:16], mem_wdata_i[7:0], mem_rdata_i[7:0]};
                end
                2'b10: begin
                    mem_wdata_o = {mem_rdata_i[31:24], mem_wdata_i[7:0], mem_rdata_i[15:0]};
                end
                default: begin
                    mem_wdata_o = {mem_wdata_i[7:0],   mem_rdata_i[23:0]};
                end
            endcase 
        end
        SH: begin
            if (w_index == 2'b00) begin
                mem_wdata_o = {mem_rdata_i[31:16], mem_wdata_i[15:0]};
            end else begin
                mem_wdata_o = {mem_wdata_i[15:0], mem_rdata_i[15:0]};
            end
        end
        SW: begin
            mem_wdata_o = mem_wdata_i;
        end
        default :begin
            mem_wdata_o = `ZeroWord;
        end
    endcase
end

endmodule