`include "defines.sv"
import id_pkg::*;
import opcode_pkg::*;
import type_pkg::*;
module id(
    input  logic        clk,
    input  logic        rst_n,

    output RegAddrBus   id_addr1_o,    // 读通用寄存器1地址
    output RegAddrBus   id_addr2_o,    // 读通用寄存器2地址

    input  InstBus      inst_i,
    input  InstAddrBus  inst_addr_i,
    input  RegAddrBus   reg1_rdata_i,    // 通用寄存器1输入数据
    input  RegAddrBus   reg2_rdata_i,    // 通用寄存器2输入数据

    output RegAddrBus   reg1_raddr_o,    // 读通用寄存器1地址
    output RegAddrBus   reg2_raddr_o,    // 读通用寄存器2地址

    output RegBus       reg1_rdata_o,    // 通用寄存器1数据
    output RegBus       reg2_rdata_o,    // 通用寄存器2数据
    output logic        reg_we_o,        // 写通用寄存器标志
    output RegAddrBus   reg_waddr_o,      // 写通用寄存器地址
    output word         imm1_o,
    output word         imm2_o,
    output OpcodeWide   opcode_o,


    output ExCode       ex_code_o
    );

    logic[6:0] opcode;
    logic[2:0] funct3;
    logic[6:0] funct7;
    logic[4:0] rd    ;
    logic[4:0] rs1   ;
    logic[4:0] rs2   ;
    assign opcode   = inst_i[6:0];
    assign funct3   = inst_i[14:12];
    assign funct7   = inst_i[31:25];
    assign rd       = inst_i[11:7];
    assign rs1      = inst_i[19:15];
    assign rs2      = inst_i[24:20];
    assign opcode_o = inst_i[6:0];

    assign id_addr1_o = reg1_raddr_o;
    assign id_addr2_o = reg2_raddr_o;

    always_comb begin
        reg1_rdata_o = reg1_rdata_i;
        reg2_rdata_o = reg2_rdata_i;        
            case (opcode)
                INST_TYPE_I :begin
                    case (funct3)
                        INST_ADDI :begin
                            reg1_raddr_o = rs1;
                            reg2_raddr_o = `ZeroReg;
                            reg_we_o     = `WriteEnable;
                            reg_waddr_o  = rd;
                            imm1_o       = {{20{inst_i[31]}}, inst_i[31:20]};
                            imm2_o       = `ZeroWord;
                            ex_code_o    = ADDI;
                        end
                        INST_SLTI :begin
                            reg1_raddr_o = rs1;
                            reg2_raddr_o = `ZeroReg;
                            reg_we_o     = `WriteEnable;
                            reg_waddr_o  = rd;
                            imm1_o       = {{20{inst_i[31]}}, inst_i[31:20]};
                            imm2_o       = `ZeroWord;
                            ex_code_o    = SLTI;
                        end
                        INST_SLTIU:begin
                            reg1_raddr_o = rs1;
                            reg2_raddr_o = `ZeroReg;
                            reg_we_o     = `WriteEnable;
                            reg_waddr_o  = rd;
                            imm1_o       = {{20{inst_i[31]}}, inst_i[31:20]};
                            imm2_o       = `ZeroWord;
                            ex_code_o    = SLTIU;
                        end
                        INST_XORI :begin
                            reg1_raddr_o = rs1;
                            reg2_raddr_o = `ZeroReg;
                            reg_we_o     = `WriteEnable;
                            reg_waddr_o  = rd;
                            imm1_o       = {{20{inst_i[31]}}, inst_i[31:20]};
                            imm2_o       = `ZeroWord;
                            ex_code_o    = XORI;
                        end
                        INST_ORI  :begin
                            reg1_raddr_o = rs1;
                            reg2_raddr_o = `ZeroReg;
                            reg_we_o     = `WriteEnable;
                            reg_waddr_o  = rd;
                            imm1_o       = {{20{inst_i[31]}}, inst_i[31:20]};
                            imm2_o       = `ZeroWord;
                            ex_code_o    = ORI;
                        end
                        INST_ANDI :begin
                            reg1_raddr_o = rs1;
                            reg2_raddr_o = `ZeroReg;
                            reg_we_o     = `WriteEnable;
                            reg_waddr_o  = rd;
                            imm1_o       = {{20{inst_i[31]}}, inst_i[31:20]};
                            imm2_o       = `ZeroWord;
                            ex_code_o    = ANDI;
                        end
                        INST_SLLI :begin
                            reg1_raddr_o = rs1;
                            reg2_raddr_o = `ZeroReg;
                            reg_we_o     = `WriteEnable;
                            reg_waddr_o  = rd;
                            imm1_o       = {{20{inst_i[31]}}, inst_i[31:20]};
                            imm2_o       = `ZeroWord;
                            ex_code_o    = SLLI;
                        end
                        INST_SRI  :begin
                            reg1_raddr_o = rs1;
                            reg2_raddr_o = `ZeroReg;
                            reg_we_o     = `WriteEnable;
                            reg_waddr_o  = rd;
                            imm1_o       = {{20{inst_i[31]}}, inst_i[31:20]};
                            imm2_o       = `ZeroWord;
                            ex_code_o    = SRI;
                        end
                        default: begin
                            reg1_raddr_o = `ZeroReg;
                            reg2_raddr_o = `ZeroReg;
                            reg_we_o     = `WriteDisable;
                            reg_waddr_o  = `ZeroReg;
                            imm1_o       = `ZeroWord;
                            imm2_o       = `ZeroWord;
                            ex_code_o    = NOP;
                        end
                    endcase
                end
                INST_TYPE_R :begin
                    case (funct3)
                        INST_ADD_SUB: begin
                            case (funct3)
                                A_f7:begin
                                    reg1_raddr_o = rs1;
                                    reg2_raddr_o = rs2;
                                    reg_we_o     = `WriteEnable;
                                    reg_waddr_o  = rd;
                                    imm1_o       = `ZeroWord;
                                    imm2_o       = `ZeroWord;
                                    ex_code_o    = ADD;
                                end
                                B_f7:begin
                                    reg1_raddr_o = rs1;
                                    reg2_raddr_o = rs2;
                                    reg_we_o     = `WriteEnable;
                                    reg_waddr_o  = rd;
                                    imm1_o       = `ZeroWord;
                                    imm2_o       = `ZeroWord;
                                    ex_code_o    = SUB;
                                end
                                default: begin
                                    reg1_raddr_o = `ZeroReg;
                                    reg2_raddr_o = `ZeroReg;
                                    reg_we_o     = `WriteDisable;
                                    reg_waddr_o  = `ZeroReg;
                                    imm1_o       = `ZeroWord;
                                    imm2_o       = `ZeroWord;
                                    ex_code_o    = NOP;
                                end
                            endcase
                        end
                        INST_SLL:     begin
                            reg1_raddr_o = rs1;
                            reg2_raddr_o = rs2;
                            reg_we_o     = `WriteEnable;
                            reg_waddr_o  = rd;
                            imm1_o       = `ZeroWord;
                            imm2_o       = `ZeroWord;
                            ex_code_o    = SLL;
                        end
                        INST_SLT:     begin
                            reg1_raddr_o = rs1;
                            reg2_raddr_o = rs2;
                            reg_we_o     = `WriteEnable;
                            reg_waddr_o  = rd;
                            imm1_o       = `ZeroWord;
                            imm2_o       = `ZeroWord;
                            ex_code_o    = SLT;
                        end
                        INST_SLTU:    begin
                            reg1_raddr_o = rs1;
                            reg2_raddr_o = rs2;
                            reg_we_o     = `WriteEnable;
                            reg_waddr_o  = rd;
                            imm1_o       = `ZeroWord;
                            imm2_o       = `ZeroWord;
                            ex_code_o    = SLTU;
                        end
                        INST_XOR:     begin
                            reg1_raddr_o = rs1;
                            reg2_raddr_o = rs2;
                            reg_we_o     = `WriteEnable;
                            reg_waddr_o  = rd;
                            imm1_o       = `ZeroWord;
                            imm2_o       = `ZeroWord;
                            ex_code_o    = XOR;
                        end
                        INST_SRAL:    begin
                            case (funct3)
                                A_f7:begin
                                    reg1_raddr_o = `ZeroReg;
                                    reg2_raddr_o = `ZeroReg;
                                    reg_we_o     = `WriteDisable;
                                    reg_waddr_o  = `ZeroReg;
                                    imm1_o       = `ZeroWord;
                                    imm2_o       = `ZeroWord;
                                    ex_code_o    = SUB;
                                end
                                B_f7:begin
                                    reg1_raddr_o = `ZeroReg;
                                    reg2_raddr_o = `ZeroReg;
                                    reg_we_o     = `WriteDisable;
                                    reg_waddr_o  = `ZeroReg;
                                    imm1_o       = `ZeroWord;
                                    imm2_o       = `ZeroWord;
                                    ex_code_o    = SUB;
                                end
                                default: begin
                                    reg1_raddr_o = `ZeroReg;
                                    reg2_raddr_o = `ZeroReg;
                                    reg_we_o     = `WriteDisable;
                                    reg_waddr_o  = `ZeroReg;
                                    imm1_o       = `ZeroWord;
                                    imm2_o       = `ZeroWord;
                                    ex_code_o    = NOP;
                                end
                            endcase
                        end
                        INST_OR:      begin
                            reg1_raddr_o = rs1;
                            reg2_raddr_o = rs2;
                            reg_we_o     = `WriteEnable;
                            reg_waddr_o  = rd;
                            imm1_o       = `ZeroWord;
                            imm2_o       = `ZeroWord;
                            ex_code_o    = OR;
                        end
                        INST_AND:     begin
                            reg1_raddr_o = rs1;
                            reg2_raddr_o = rs2;
                            reg_we_o     = `WriteEnable;
                            reg_waddr_o  = rd;
                            imm1_o       = `ZeroWord;
                            imm2_o       = `ZeroWord;
                            ex_code_o    = AND;
                        end

                        default:      begin
                            reg1_raddr_o = `ZeroReg;
                            reg2_raddr_o = `ZeroReg;
                            reg_we_o     = `WriteDisable;
                            reg_waddr_o  = `ZeroReg;
                            imm1_o       = `ZeroWord;
                            imm2_o       = `ZeroWord;
                            ex_code_o    = NOP;
                        end
                    endcase
                end
                INST_TYPE_L :begin
                    case (funct3)
                        INST_LB :begin
                            reg1_raddr_o = rs1;
                            reg2_raddr_o = `ZeroReg;
                            reg_we_o     = `WriteEnable;
                            reg_waddr_o  = rd;
                            imm1_o       = {{20{inst_i[31]}}, inst_i[31:20]};
                            imm2_o       = `ZeroWord;
                            ex_code_o    = LB;
                        end
                        INST_LH :begin
                            reg1_raddr_o = rs1;
                            reg2_raddr_o = `ZeroReg;
                            reg_we_o     = `WriteEnable;
                            reg_waddr_o  = rd;
                            imm1_o       = {{20{inst_i[31]}}, inst_i[31:20]};
                            imm2_o       = `ZeroWord;
                            ex_code_o    = LH;
                        end
                        INST_LW :begin
                            reg1_raddr_o = rs1;
                            reg2_raddr_o = `ZeroReg;
                            reg_we_o     = `WriteEnable;
                            reg_waddr_o  = rd;
                            imm1_o       = {{20{inst_i[31]}}, inst_i[31:20]};
                            imm2_o       = `ZeroWord;
                            ex_code_o    = LW;
                        end
                        INST_LBU:begin
                            reg1_raddr_o = rs1;
                            reg2_raddr_o = `ZeroReg;
                            reg_we_o     = `WriteEnable;
                            reg_waddr_o  = rd;
                            imm1_o       = {{20{inst_i[31]}}, inst_i[31:20]};
                            imm2_o       = `ZeroWord;
                            ex_code_o    = LBU;
                        end
                        INST_LHU:begin
                            reg1_raddr_o = rs1;
                            reg2_raddr_o = `ZeroReg;
                            reg_we_o     = `WriteEnable;
                            reg_waddr_o  = rd;
                            imm1_o       = {{20{inst_i[31]}}, inst_i[31:20]};
                            imm2_o       = `ZeroWord;
                            ex_code_o    = LHU;
                        end
                        default :begin
                            reg1_raddr_o = `ZeroReg;
                            reg2_raddr_o = `ZeroReg;
                            reg_we_o     = `WriteDisable;
                            reg_waddr_o  = `ZeroReg;
                            imm1_o       = `ZeroWord;
                            imm2_o       = `ZeroWord;
                            ex_code_o    = NOP;
                        end
                    endcase        
                end
                INST_TYPE_S :begin
                    case (funct3)
                        INST_SB:begin
                            reg1_raddr_o = rs1;
                            reg2_raddr_o = rs2;
                            reg_we_o     = `WriteDisable;
                            reg_waddr_o  = `ZeroReg;
                            imm1_o       = {{20{inst_i[31]}}, inst_i[31:25], inst_i[11:7]};
                            imm2_o       = `ZeroWord;
                            ex_code_o    = SB;
                        end
                        INST_SH:begin
                            reg1_raddr_o = rs1;
                            reg2_raddr_o = rs2;
                            reg_we_o     = `WriteDisable;
                            reg_waddr_o  = `ZeroReg;
                            imm1_o       = {{20{inst_i[31]}}, inst_i[31:25], inst_i[11:7]};
                            imm2_o       = `ZeroWord;
                            ex_code_o    = SH;
                        end
                        INST_SW:begin
                            reg1_raddr_o = rs1;
                            reg2_raddr_o = rs2;
                            reg_we_o     = `WriteDisable;
                            reg_waddr_o  = `ZeroReg;
                            imm1_o       = {{20{inst_i[31]}}, inst_i[31:25], inst_i[11:7]};
                            imm2_o       = `ZeroWord;
                            ex_code_o    = SW;
                        end
                        default:begin
                            reg1_raddr_o = `ZeroReg;
                            reg2_raddr_o = `ZeroReg;
                            reg_we_o     = `WriteDisable;
                            reg_waddr_o  = `ZeroReg;
                            imm1_o       = `ZeroWord;
                            imm2_o       = `ZeroWord;
                            ex_code_o    = NOP;
                        end
                    endcase
                end
                INST_TYPE_B :begin
                    case (funct3)
                       INST_BEQ :begin
                            reg1_raddr_o = rs1;
                            reg2_raddr_o = rs2;
                            reg_we_o     = `WriteDisable;
                            reg_waddr_o  = `ZeroReg;
                            imm1_o       = {{20{inst_i[31]}}, inst_i[7], inst_i[30:25], inst_i[11:8], 1'b0};
                            imm2_o       = `ZeroWord;
                            ex_code_o    = BEQ;
                        end
                        INST_BNE :begin
                            reg1_raddr_o = rs1;
                            reg2_raddr_o = rs2;
                            reg_we_o     = `WriteDisable;
                            reg_waddr_o  = `ZeroReg;
                            imm1_o       = {{20{inst_i[31]}}, inst_i[7], inst_i[30:25], inst_i[11:8], 1'b0};
                            imm2_o       = `ZeroWord;
                            ex_code_o    = BNE;
                        end
                        INST_BLT :begin
                            reg1_raddr_o = rs1;
                            reg2_raddr_o = rs2;
                            reg_we_o     = `WriteDisable;
                            reg_waddr_o  = `ZeroReg;
                            imm1_o       = {{20{inst_i[31]}}, inst_i[7], inst_i[30:25], inst_i[11:8], 1'b0};
                            imm2_o       = `ZeroWord;
                            ex_code_o    = BLT;
                        end
                        INST_BGE :begin
                            reg1_raddr_o = rs1;
                            reg2_raddr_o = rs2;
                            reg_we_o     = `WriteDisable;
                            reg_waddr_o  = `ZeroReg;
                            imm1_o       = {{20{inst_i[31]}}, inst_i[7], inst_i[30:25], inst_i[11:8], 1'b0};
                            imm2_o       = `ZeroWord;
                            ex_code_o    = BGE;
                        end
                        INST_BLTU:begin
                            reg1_raddr_o = rs1;
                            reg2_raddr_o = rs2;
                            reg_we_o     = `WriteDisable;
                            reg_waddr_o  = `ZeroReg;
                            imm1_o       = {{20{inst_i[31]}}, inst_i[7], inst_i[30:25], inst_i[11:8], 1'b0};
                            imm2_o       = `ZeroWord;
                            ex_code_o    = BLTU;
                        end
                        INST_BGEU:begin
                            reg1_raddr_o = rs1;
                            reg2_raddr_o = rs2;
                            reg_we_o     = `WriteDisable;
                            reg_waddr_o  = `ZeroReg;
                            imm1_o       = {{20{inst_i[31]}}, inst_i[7], inst_i[30:25], inst_i[11:8], 1'b0};
                            imm2_o       = `ZeroWord;
                            ex_code_o    = BGEU;
                        end
                        default:begin
                            reg1_raddr_o = `ZeroReg;
                            reg2_raddr_o = `ZeroReg;
                            reg_we_o     = `WriteDisable;
                            reg_waddr_o  = `ZeroReg;
                            imm1_o       = `ZeroWord;
                            imm2_o       = `ZeroWord;
                            ex_code_o    = NOP;
                        end
                    endcase
                end
                INST_LUI_U  :begin
                    //temp
                    reg1_raddr_o = `ZeroReg;
                    reg2_raddr_o = `ZeroReg;
                    reg_we_o     = `WriteDisable;
                    reg_waddr_o  = `ZeroReg;
                    imm1_o       = `ZeroWord;
                    imm2_o       = `ZeroWord;
                    ex_code_o    = NOP;
                end
                INST_AUIPC_U:begin
                    //temp
                    reg1_raddr_o = `ZeroReg;
                    reg2_raddr_o = `ZeroReg;
                    reg_we_o     = `WriteDisable;
                    reg_waddr_o  = `ZeroReg;
                    imm1_o       = `ZeroWord;
                    imm2_o       = `ZeroWord;
                    ex_code_o    = NOP;
                end
                default: begin
                    reg1_raddr_o = `ZeroReg;
                    reg2_raddr_o = `ZeroReg;
                    reg_we_o     = `WriteDisable;
                    reg_waddr_o  = `ZeroReg;
                    imm1_o       = `ZeroWord;
                    imm2_o       = `ZeroWord;
                    ex_code_o    = NOP;
                end
            endcase
        end
endmodule
