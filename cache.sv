`include "defines.sv"
module cache(
    input  logic        clk,
    input  logic        rst_n,
    //form ex
    input RegBus        ex_data_i,   // 写寄存器数据
    input RegAddrBus    ex_addr_i,   // 写通用寄存器地址
    //from mem  
    input RegBus        mem_data_i,   // 写寄存器数据
    input RegAddrBus    mem_addr_i,   // 写通用寄存器地址
    //from wb   
    input  OpcodeWide   opcode_i,
    input RegBus        wb_data_i,   // 写寄存器数据
    input RegAddrBus    wb_addr_i,   // 写通用寄存器地址
    //from id
    input  RegAddrBus   rd1_i,
    input  RegAddrBus   rd2_i,
    // to ex
    output RegBus       ex_data1_o, 
    output RegBus       ex_data2_o, 
    // from mem
    input  RegAddrBus   mem_rdata_i,    // 通用寄存器1输入数据
    // to mem 
    output RegAddrBus   mem_raddr_o,    // 读通用寄存器1地址
    // from reg
    input  RegAddrBus   reg1_rdata_i,    // 通用寄存器1输入数据
    input  RegAddrBus   reg2_rdata_i,    // 通用寄存器2输入数据
    // to reg 
    output RegAddrBus   reg1_raddr_o,    // 读通用寄存器1地址
    output RegAddrBus   reg2_raddr_o     // 读通用寄存器2地址

    );

    

    always_comb begin
        if (rd1_i == `ZeroReg) begin
            reg1_raddr_o <= `ZeroReg;
            ex_data1_o   <= reg1_rdata_i;
        end else if ((opcode_i == INST_TYPE_L) && (rd1_i == wb_addr_i)) begin
                    reg1_raddr_o <= `ZeroReg;
                    ex_data1_o   <= wb_data_i;
        end else if ((opcode_i == INST_TYPE_L) && !(rd1_i == wb_addr_i)) begin
                    reg1_raddr_o <= `ZeroReg;
                    ex_data1_o   <= mem_rdata_i;  
        end else begin
            priority case (rd1_i)
                ex_addr_i: begin
                    reg1_raddr_o <= `ZeroReg;
                    ex_data1_o   <= ex_data_i;
               end
                mem_addr_i : begin
                    reg1_raddr_o <= `ZeroReg;
                    ex_data1_o   <= mem_data_i;
               end
                wb_addr_i : begin
                    reg1_raddr_o <= `ZeroReg;
                    ex_data1_o   <= wb_data_i;
               end
               default:begin
                    reg1_raddr_o <= rd1_i;
                    ex_data1_o   <= reg1_rdata_i;
               end
            endcase
        end
    end
    always_comb begin
        if (rd2_i == `ZeroReg) begin
            reg2_raddr_o <= `ZeroReg;
            ex_data2_o   <= reg2_rdata_i;
        end else if ((opcode_i == INST_TYPE_L) && (rd1_i == wb_addr_i)) begin
                    reg2_raddr_o <= `ZeroReg;
                    ex_data2_o   <= wb_data_i;
        end else if ((opcode_i == INST_TYPE_L) && !(rd1_i == wb_addr_i)) begin
                    reg2_raddr_o <= `ZeroReg;
                    ex_data2_o   <= mem_rdata_i;  
        end else begin
            priority case (rd2_i)
                ex_addr_i: begin
                    reg2_raddr_o <= `ZeroReg;
                    ex_data2_o   <= ex_data_i;
               end
                mem_addr_i : begin
                    reg2_raddr_o <= `ZeroReg;
                    ex_data2_o   <= mem_data_i;
               end
                wb_addr_i : begin
                    reg2_raddr_o <= `ZeroReg;
                    ex_data2_o   <= wb_data_i;
               end
               default:begin
                    reg2_raddr_o <= rd2_i;
                    ex_data2_o   <= reg2_rdata_i;
               end
            endcase
        end
    end

endmodule