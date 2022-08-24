`include "defines.sv"
import type_pkg::*;
module bus (
    //m0
    input    MemAddrBus    m_waddr,
    input    MemBus        m_wdata,
    input    logic [3:0]   m_we   ,
    input    MemAddrBus    m_raddr,
    output   MemBus        m_rdata,  
    //s0
    output  MemAddrBus    s0_waddr,
    output  MemBus        s0_wdata,
    output  logic [3:0]   s0_we   ,
    output  MemAddrBus    s0_raddr,
    input   MemBus        s0_rdata,
    //s1
    output  MemAddrBus    s1_waddr,
    output  MemBus        s1_wdata,
    output  logic [3:0]   s1_we,
    output  MemAddrBus    s1_raddr,
    input   MemBus        s1_rdata

);
enum logic[3:0] { 
    slave_0 = 4'b0001,
    slave_1 = 4'b0010,
    slave_2 = 4'b0011,
    slave_3 = 4'b0100,
    slave_4 = 4'b0101
 } slave_t;
always_comb begin 
    unique case (m_waddr[31:28])
        slave_0 : begin
            s0_waddr = m_waddr;
            s0_wdata = m_wdata;
            s0_we    = m_we   ;
            s1_waddr = `ZeroWord;
            s1_wdata = `ZeroWord;
            s1_we    = `ZeroWord;
        end
        slave_1 : begin
            s0_waddr = `ZeroWord;
            s0_wdata = `ZeroWord;
            s0_we    = `ZeroWord;
            s1_waddr = m_waddr;
            s1_wdata = m_wdata;
            s1_we    = m_we   ;
        end
        default: begin
            s0_waddr = `ZeroWord;
            s0_wdata = `ZeroWord;
            s0_we    = `ZeroWord;
            s1_waddr = `ZeroWord;
            s1_wdata = `ZeroWord;
            s1_we    = `ZeroWord; 
        end
    endcase
end
always_comb begin 
    unique case (m_raddr[31:28])
        slave_0 : begin
            m_rdata  = s0_rdata;
            s0_raddr = m_raddr;
            s1_raddr = `ZeroWord;
        end
        slave_1 : begin
            m_rdata  = s1_rdata;
            s0_raddr = `ZeroWord;
            s1_raddr = m_raddr;
        end
        default: begin
            m_rdata  = `ZeroWord;
            s0_raddr = `ZeroWord;
            s1_raddr = `ZeroWord;
        end
    endcase
end
endmodule