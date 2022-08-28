`include "defines.sv"
import id_pkg::*;
import opcode_pkg::*;
import type_pkg::*;
module id(
    input  InstBus      inst_i,
    input  InstAddrBus  pc_id,
    // to ALU
    output word         ALU_data1_o,
    output word         ALU_data2_o,
    output aluop        ALU_op_o,
    // from forwarder
    input RegBus        reg1_rdata_i, 
    input RegBus        reg2_rdata_i, 
    // to forwarder
    output RegAddrBus   rs1,
    output RegAddrBus   rs2,

    output logic        reg_we_o,    
    output RegAddrBus   reg_waddr_o, 
    output OpcodeWide   opcode_o,
    output word         IL_imm ,
    output word         S_imm  ,
    output word         B_imm  ,
    output word         U_imm  ,
    output word         JAL_imm,
    output ExCode       ex_code_o
    );

    logic[6:0] opcode;
    logic[2:0] funct3;
    logic[6:0] funct7;
    logic[4:0] rd    ;
    logic[4:0] shamt ;
    assign opcode   = inst_i[6:0];
    assign funct3   = inst_i[14:12];
    assign funct7   = inst_i[31:25];
    assign rd       = inst_i[11:7];
    assign rs1      = inst_i[19:15];
    assign rs2      = inst_i[24:20];
    assign shamt    = inst_i[24:20];
    assign opcode_o = inst_i[6:0];
    assign IL_imm   = {{20{inst_i[31]}}, inst_i[31:20]};
    assign S_imm    = {{20{inst_i[31]}}, inst_i[31:25], inst_i[11:7]};
    assign B_imm    = {{20{inst_i[31]}}, inst_i[7], inst_i[30:25], inst_i[11:8], 1'b0};
    assign JAL_imm  = {{12{inst_i[31]}}, inst_i[19:12], inst_i[20], inst_i[30:21], 1'b0};
    assign U_imm    = {inst_i[31:12], 12'b0};
    always_comb begin   
            unique case (opcode)
                INST_TYPE_I :begin
                    unique case (funct3)
                        INST_ADDI :begin
                            ALU_data1_o  = reg1_rdata_i;
                            ALU_data2_o  = IL_imm;
                            ALU_op_o     = alu_add;
                            reg_we_o     = `WriteEnable;
                            reg_waddr_o  = rd;
                            ex_code_o    = ADDI;
                        end
                        INST_SLTI :begin
                            ALU_data1_o  = reg1_rdata_i;
                            ALU_data2_o  = IL_imm;
                            ALU_op_o     = alu_ge_s;
                            reg_we_o     = `WriteEnable;
                            reg_waddr_o  = rd;
                            ex_code_o    = SLTI;
                        end
                        INST_SLTIU:begin
                            ALU_data1_o  = reg1_rdata_i;
                            ALU_data2_o  = IL_imm;
                            ALU_op_o     = alu_ge_u;
                            reg_we_o     = `WriteEnable;
                            reg_waddr_o  = rd;
                            ex_code_o    = SLTIU;
                        end
                        INST_XORI :begin
                            ALU_data1_o  = reg1_rdata_i;
                            ALU_data2_o  = IL_imm;
                            ALU_op_o     = alu_xor;
                            reg_we_o     = `WriteEnable;
                            reg_waddr_o  = rd;
                            ex_code_o    = XORI;
                        end
                        INST_ORI  :begin
                            ALU_data1_o  = reg1_rdata_i;
                            ALU_data2_o  = IL_imm;
                            ALU_op_o     = alu_or;
                            reg_we_o     = `WriteEnable;
                            reg_waddr_o  = rd;
                            ex_code_o    = ORI;
                        end
                        INST_ANDI :begin
                            ALU_data1_o  = reg1_rdata_i;
                            ALU_data2_o  = IL_imm;
                            ALU_op_o     = alu_and;
                            reg_we_o     = `WriteEnable;
                            reg_waddr_o  = rd;
                            ex_code_o    = ANDI;
                        end
                        INST_SLLI :begin
                            ALU_data1_o  = reg1_rdata_i;
                            ALU_data2_o  = IL_imm;
                            ALU_op_o     = alu_sll;
                            reg_we_o     = `WriteEnable;
                            reg_waddr_o  = rd;
                            ex_code_o    = SLLI;
                        end
                        INST_SRLI :begin
                            unique case (funct3)
                                A_f7:begin
                                    ALU_data1_o  = reg1_rdata_i;
                                    ALU_data2_o  = shamt;
                                    ALU_op_o     = alu_srl;
                                    reg_we_o     = `WriteEnable;
                                    reg_waddr_o  = rd;
                                    ex_code_o    = SRLI;
                                end
                                B_f7:begin
                                    ALU_data1_o  = reg1_rdata_i;
                                    ALU_data2_o  = shamt;
                                    ALU_op_o     = alu_sra;
                                    reg_we_o     = `WriteEnable;
                                    reg_waddr_o  = rd;
                                    ex_code_o    = SRAI;
                                end
                                default: begin
                                    ALU_data1_o  = `ZeroWord;
                                    ALU_data2_o  = `ZeroWord;
                                    ALU_op_o     = alu_nop;
                                    reg_we_o     = `WriteEnable;
                                    reg_waddr_o  = `ZeroWord;
                                    ex_code_o    = NOP;
                                end
                            endcase 
                        end
                        default: begin
                            ALU_data1_o  = `ZeroWord;
                            ALU_data2_o  = `ZeroWord;
                            ALU_op_o     = alu_nop;
                            reg_we_o     = `WriteDisable;
                            reg_waddr_o  = `ZeroWord;
                            ex_code_o    = NOP;
                        end
                    endcase
                end
                INST_TYPE_R :begin
                    if (funct7 == C_f7) begin
                        unique case (funct3)
                            INST_MUL   :begin
                                ALU_data1_o  = reg1_rdata_i;
                                ALU_data2_o  = reg2_rdata_i;
                                ALU_op_o     = alu_mul_u;
                                reg_we_o     = `WriteEnable;
                                reg_waddr_o  = rd;
                                ex_code_o    = MUL;
                            end
                            INST_MULH  :begin
                                ALU_data1_o  = reg1_rdata_i;
                                ALU_data2_o  = reg2_rdata_i;
                                ALU_op_o     = alu_mul_s;
                                reg_we_o     = `WriteEnable;
                                reg_waddr_o  = rd;
                                ex_code_o    = MULH;
                            end
                            INST_MULHSU:begin
                                ALU_data1_o  = reg1_rdata_i;
                                ALU_data2_o  = reg2_rdata_i;
                                ALU_op_o     = alu_mul_u;
                                reg_we_o     = `WriteEnable;
                                reg_waddr_o  = rd;
                                ex_code_o    = MULHSU;
                            end
                            INST_MULHU :begin
                                ALU_data1_o  = reg1_rdata_i;
                                ALU_data2_o  = reg2_rdata_i;
                                ALU_op_o     = alu_mul_u;
                                reg_we_o     = `WriteEnable;
                                reg_waddr_o  = rd;
                                ex_code_o    = MULHU;
                            end
                            INST_DIV   :begin
                                ALU_data1_o  = reg1_rdata_i;
                                ALU_data2_o  = reg2_rdata_i;
                                ALU_op_o     = alu_div_s;
                                reg_we_o     = `WriteEnable;
                                reg_waddr_o  = rd;
                                ex_code_o    = DIV;
                            end
                            INST_DIVU  :begin
                                ALU_data1_o  = reg1_rdata_i;
                                ALU_data2_o  = reg2_rdata_i;
                                ALU_op_o     = alu_div_u;
                                reg_we_o     = `WriteEnable;
                                reg_waddr_o  = rd;
                                ex_code_o    = DIVU;
                            end
                            INST_REM   :begin
                                ALU_data1_o  = reg1_rdata_i;
                                ALU_data2_o  = reg2_rdata_i;
                                ALU_op_o     = alu_rem_s;
                                reg_we_o     = `WriteEnable;
                                reg_waddr_o  = rd;
                                ex_code_o    = REM;
                            end
                            INST_REMU  :begin
                                ALU_data1_o  = reg1_rdata_i;
                                ALU_data2_o  = reg2_rdata_i;
                                ALU_op_o     = alu_rem_u;
                                reg_we_o     = `WriteEnable;
                                reg_waddr_o  = rd;
                                ex_code_o    = REMU;
                            end
                            default:begin
                                ALU_data1_o  = `ZeroWord;
                                ALU_data2_o  = `ZeroWord;
                                ALU_op_o     = alu_nop;
                                reg_we_o     = `WriteDisable;
                                reg_waddr_o  = `ZeroWord;
                                ex_code_o    = NOP;
                            end
                        endcase
                    end else begin
                        unique case (funct3)
                            INST_ADD_SUB: begin
                                case (funct7)
                                    A_f7:begin
                                        ALU_data1_o  = reg1_rdata_i;
                                        ALU_data2_o  = reg2_rdata_i;
                                        ALU_op_o     = alu_add;
                                        reg_we_o     = `WriteEnable;
                                        reg_waddr_o  = rd;
                                        ex_code_o    = ADD;
                                    end
                                    B_f7:begin
                                        ALU_data1_o  = reg1_rdata_i;
                                        ALU_data2_o  = reg2_rdata_i;
                                        ALU_op_o     = alu_sub;
                                        reg_we_o     = `WriteEnable;
                                        reg_waddr_o  = rd;
                                        ex_code_o    = SUB;
                                    end
                                    default: begin
                                        ALU_data1_o  = `ZeroWord;
                                        ALU_data2_o  = `ZeroWord;
                                        ALU_op_o     = alu_nop;
                                        reg_we_o     = `WriteDisable;
                                        reg_waddr_o  = `ZeroWord;
                                        ex_code_o    = NOP;
                                    end
                                endcase
                            end
                            INST_SLL:     begin
                                ALU_data1_o  = reg1_rdata_i;
                                ALU_data2_o  = reg2_rdata_i;
                                ALU_op_o     = alu_sll;
                                reg_we_o     = `WriteEnable;
                                reg_waddr_o  = rd;
                                ex_code_o    = SLL;
                            end
                            INST_SLT:     begin
                                ALU_data1_o  = reg1_rdata_i;
                                ALU_data2_o  = reg2_rdata_i;
                                ALU_op_o     = alu_ge_s;
                                reg_we_o     = `WriteEnable;
                                reg_waddr_o  = rd;
                                ex_code_o    = SLT;
                            end
                            INST_SLTU:    begin
                                ALU_data1_o  = reg1_rdata_i;
                                ALU_data2_o  = reg2_rdata_i;
                                ALU_op_o     = alu_ge_u;
                                reg_we_o     = `WriteEnable;
                                reg_waddr_o  = rd;
                                ex_code_o    = SLTU;
                            end
                            INST_XOR:     begin
                                ALU_data1_o  = reg1_rdata_i;
                                ALU_data2_o  = reg2_rdata_i;
                                ALU_op_o     = alu_xor;
                                reg_we_o     = `WriteEnable;
                                reg_waddr_o  = rd;
                                ex_code_o    = XOR;
                            end
                            INST_SRAL:    begin
                                unique case (funct3)
                                    A_f7:begin
                                        ALU_data1_o  = reg1_rdata_i;
                                        ALU_data2_o  = reg2_rdata_i;
                                        ALU_op_o     = alu_srl;
                                        reg_we_o     = `WriteEnable;
                                        reg_waddr_o  = rd;
                                        ex_code_o    = SRL;
                                    end
                                    B_f7:begin
                                        ALU_data1_o  = reg1_rdata_i;
                                        ALU_data2_o  = reg2_rdata_i;
                                        ALU_op_o     = alu_sra;
                                        reg_we_o     = `WriteEnable;
                                        reg_waddr_o  = rd;
                                        ex_code_o    = SRA;
                                    end
                                    default: begin
                                        ALU_data1_o  = `ZeroWord;
                                        ALU_data2_o  = `ZeroWord;
                                        ALU_op_o     = alu_nop;
                                        reg_we_o     = `WriteDisable;
                                        reg_waddr_o  = `ZeroWord;
                                        ex_code_o    = NOP;
                                    end
                                endcase
                            end
                            INST_OR:      begin
                                ALU_data1_o  = reg1_rdata_i;
                                ALU_data2_o  = reg2_rdata_i;
                                ALU_op_o     = alu_or;
                                reg_we_o     = `WriteEnable;
                                reg_waddr_o  = rd;
                                ex_code_o    = OR;
                            end
                            INST_AND:     begin
                                ALU_data1_o  = reg1_rdata_i;
                                ALU_data2_o  = reg2_rdata_i;
                                ALU_op_o     = alu_and;
                                reg_we_o     = `WriteEnable;
                                reg_waddr_o  = rd;
                                ex_code_o    = AND;
                            end
                            default:      begin
                                ALU_data1_o  = `ZeroWord;
                                ALU_data2_o  = `ZeroWord;
                                ALU_op_o     = alu_nop;
                                reg_we_o     = `WriteDisable;
                                reg_waddr_o  = `ZeroWord;
                                ex_code_o    = NOP;
                            end
                        endcase
                    end
                end
                INST_TYPE_L :begin
                    unique case (funct3)
                        INST_LB :begin
                            ALU_data1_o  = reg1_rdata_i;
                            ALU_data2_o  = IL_imm;
                            ALU_op_o     = alu_add;
                            reg_we_o     = `WriteEnable;
                            reg_waddr_o  = rd;
                            ex_code_o    = LB;
                        end
                        INST_LH :begin
                            ALU_data1_o  = reg1_rdata_i;
                            ALU_data2_o  = IL_imm;
                            ALU_op_o     = alu_add;
                            reg_we_o     = `WriteEnable;
                            reg_waddr_o  = rd;
                            ex_code_o    = LH;
                        end
                        INST_LW :begin
                            ALU_data1_o  = reg1_rdata_i;
                            ALU_data2_o  = IL_imm;
                            ALU_op_o     = alu_add;
                            reg_we_o     = `WriteEnable;
                            reg_waddr_o  = rd;
                            ex_code_o    = LW;
                        end
                        INST_LBU:begin
                            ALU_data1_o  = reg1_rdata_i;
                            ALU_data2_o  = IL_imm;
                            ALU_op_o     = alu_add;
                            reg_we_o     = `WriteEnable;
                            reg_waddr_o  = rd;
                            ex_code_o    = LBU;
                        end
                        INST_LHU:begin
                            ALU_data1_o  = reg1_rdata_i;
                            ALU_data2_o  = IL_imm;
                            ALU_op_o     = alu_add;
                            reg_we_o     = `WriteEnable;
                            reg_waddr_o  = rd;
                            ex_code_o    = LHU;
                        end
                        default :begin
                            ALU_data1_o  = `ZeroWord;
                            ALU_data2_o  = `ZeroWord;
                            ALU_op_o     = alu_nop;
                            reg_we_o     = `WriteDisable;
                            reg_waddr_o  = `ZeroWord;
                            ex_code_o    = NOP;
                        end
                    endcase        
                end
                INST_TYPE_S :begin
                    unique case (funct3)
                        INST_SB:begin
                            ALU_data1_o  = reg1_rdata_i;
                            ALU_data2_o  = S_imm;
                            ALU_op_o     = alu_add;
                            reg_we_o     = `WriteDisable;
                            reg_waddr_o  = `ZeroReg;
                            ex_code_o    = SB;
                        end
                        INST_SH:begin
                            ALU_data1_o  = reg1_rdata_i;
                            ALU_data2_o  = S_imm;
                            ALU_op_o     = alu_add;
                            reg_we_o     = `WriteDisable;
                            reg_waddr_o  = `ZeroReg;
                            ex_code_o    = SH;
                        end
                        INST_SW:begin
                            ALU_data1_o  = reg1_rdata_i;
                            ALU_data2_o  = S_imm;
                            ALU_op_o     = alu_add;
                            reg_we_o     = `WriteDisable;
                            reg_waddr_o  = `ZeroReg;
                            ex_code_o    = SW;
                        end
                        default:begin
                            ALU_data1_o  = `ZeroWord;
                            ALU_data2_o  = `ZeroWord;
                            ALU_op_o     = alu_nop;
                            reg_we_o     = `WriteDisable;
                            reg_waddr_o  = `ZeroWord;
                            ex_code_o    = NOP;
                        end
                    endcase
                end
                INST_TYPE_B :begin
                    unique case (funct3)
                       INST_BEQ :begin
                            ALU_data1_o  = reg1_rdata_i;
                            ALU_data2_o  = reg2_rdata_i;
                            ALU_op_o     = alu_eq;
                            reg_we_o     = `WriteDisable;
                            reg_waddr_o  = `ZeroReg;
                            ex_code_o    = BEQ;
                        end
                        INST_BNE :begin
                            ALU_data1_o  = reg1_rdata_i;
                            ALU_data2_o  = reg2_rdata_i;
                            ALU_op_o     = alu_eq;
                            reg_we_o     = `WriteDisable;
                            reg_waddr_o  = `ZeroReg;
                            ex_code_o    = BNE;
                        end
                        INST_BLT :begin
                            ALU_data1_o  = reg1_rdata_i;
                            ALU_data2_o  = reg2_rdata_i;
                            ALU_op_o     = alu_ge_s;
                            reg_we_o     = `WriteDisable;
                            reg_waddr_o  = `ZeroReg;
                            ex_code_o    = BLT;
                        end
                        INST_BGE :begin
                            ALU_data1_o  = reg1_rdata_i;
                            ALU_data2_o  = reg2_rdata_i;
                            ALU_op_o     = alu_ge_s;
                            reg_we_o     = `WriteDisable;
                            reg_waddr_o  = `ZeroReg;
                            ex_code_o    = BGE;
                        end
                        INST_BLTU:begin
                            ALU_data1_o  = reg1_rdata_i;
                            ALU_data2_o  = reg2_rdata_i;
                            ALU_op_o     = alu_ge_u;
                            reg_we_o     = `WriteDisable;
                            reg_waddr_o  = `ZeroReg;
                            ex_code_o    = BLTU;
                        end
                        INST_BGEU:begin
                            ALU_data1_o  = reg1_rdata_i;
                            ALU_data2_o  = reg2_rdata_i;
                            ALU_op_o     = alu_ge_u;
                            reg_we_o     = `WriteDisable;
                            reg_waddr_o  = `ZeroReg;
                            ex_code_o    = BGEU;
                        end
                        default:begin
                            ALU_data1_o  = `ZeroWord;
                            ALU_data2_o  = `ZeroWord;
                            ALU_op_o     = alu_nop;
                            reg_we_o     = `WriteDisable;
                            reg_waddr_o  = `ZeroWord;
                            ex_code_o    = NOP;
                        end
                    endcase
                end
                INST_JAL    :begin
                    ALU_data1_o  = 32'h4;
                    ALU_data2_o  = pc_id;
                    ALU_op_o     = alu_add;
                    reg_we_o     = `WriteEnable;
                    reg_waddr_o  = rd;
                    ex_code_o    = JAL;
                end
                INST_JALR   :begin
                    ALU_data1_o  = 32'h4;
                    ALU_data2_o  = pc_id;
                    ALU_op_o     = alu_add;
                    reg_we_o     = `WriteEnable;
                    reg_waddr_o  = rd;
                    ex_code_o    = JALR;
                end
                INST_LUI_U  :begin
                    ALU_data1_o  = U_imm;
                    ALU_data2_o  = `ZeroWord;
                    ALU_op_o     = alu_add;
                    reg_we_o     = `WriteEnable;
                    reg_waddr_o  = rd;
                    ex_code_o    = LUI;
                end
                INST_AUIPC_U:begin
                    ALU_data1_o  = U_imm;
                    ALU_data2_o  = pc_id;
                    ALU_op_o     = alu_add;
                    reg_we_o     = `WriteEnable;
                    reg_waddr_o  = rd;
                    ex_code_o    = AUIPC;
                end
                default: begin
                    ALU_data1_o  = `ZeroWord;
                    ALU_data2_o  = `ZeroWord;
                    ALU_op_o     = alu_nop;
                    reg_we_o     = `WriteDisable;
                    reg_waddr_o  = `ZeroWord;
                    ex_code_o    = NOP;
                end
            endcase
        end
endmodule
