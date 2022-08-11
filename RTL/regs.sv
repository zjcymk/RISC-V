`include "defines.sv"
import type_pkg::*;
// 通用寄存器模块
module regs(

    input logic clk,
    input logic rst_n,
    // from ex                     
    input logic we_i,                       // 写寄存器标志       
    input RegAddrBus waddr_i,                // 写寄存器地址       
    input RegBus wdata_i,                    // 写寄存器数据
    // from id    
    input RegAddrBus raddr1_i,              // 读寄存器1地址
    // to id       
    output RegBus rdata1_o,                 // 读寄存器1数据
    // from id   
    input RegAddrBus raddr2_i,              // 读寄存器2地址
    // to id     
    output RegBus rdata2_o                  // 读寄存器2数据
    );
    
    word regs[0:`RegNum - 1];

    // 写寄存器
    always_ff @( posedge clk ) begin 
        if (rst_n == `RstEnable) begin
            for (int i = 0 ; i<`RegNum ; i++ ) begin
            regs [i] = 32'b0;
            end
        end else if ((we_i == `WriteEnable) && (waddr_i != `ZeroReg))begin
            regs[waddr_i] <= wdata_i;
        end else begin
            regs[`ZeroReg] <= 32'b0;
        end
    end

    // 读寄存器1
    always_comb begin
        if (waddr_i == raddr1_i)begin
            rdata1_o = wdata_i;
        end else begin
            rdata1_o = regs[raddr1_i];
        end
    end
    // 读寄存器2
    always_comb begin
        if (waddr_i == raddr1_i)begin
            rdata2_o = wdata_i;
        end else begin
            rdata2_o = regs[raddr2_i];
        end
    end


endmodule
