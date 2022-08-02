`include "defines.sv"
module ctrl(
    
    input  OpcodeWide   opcode_i,
    input  RegAddrBus   id_addr_i,
    input  RegAddrBus   ex_addr_i,
    //from id
    input  InstAddrBus  pc_i,
    //to pc_reg
    output InstAddrBus  pc_o,
    output logic        hold,
    output logic        jump
);
always_comb begin
    if ((opcode_i == INST_TYPE_L) && (ex_addr_i == id_addr_i)) begin
        hold = 1'b1;
    end else begin
        hold = 1'b0;
    end
end
endmodule