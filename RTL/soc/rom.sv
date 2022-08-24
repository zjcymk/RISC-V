`include "defines.sv" 
import type_pkg::*;
module rom(
    input InstAddrBus pc_i,

    output InstBus    inst
);
logic [7:0] ROM [0:64];
word temp;
localparam FILE_TXT = "/home/ICer/mcu/binfile";
integer fd;
integer f_Temp;
initial begin
    fd = $fopen(FILE_TXT, "rb");
    f_Temp = $fread(ROM,fd);
end
//assign temp = ROM[pc_i];
assign inst = {ROM [pc_i+3],ROM [pc_i+2],ROM [pc_i+1],ROM [pc_i]};
/*
always_comb begin
    unique case (pc_i)
        8'd0     : inst <= 32'b000000000000_00000_000_0000_0010011;
        8'd1     : inst <= 32'b000000001111_00001_000_00001_0010011;
        8'd2     : inst <= 32'b000000001111_00001_000_00010_0010011;
        8'd3     : inst <= 32'b0000000_00010_00001_000_00001_0110011;// add r1,r1,r2
        8'd4     : inst <= 32'b0000000_00010_00001_000_00001_0110011;
        8'd5     : inst <= 32'b0000000_00010_00001_000_00001_0110011;
        8'd6     : inst <= 32'b0000000_00010_00001_000_00001_0110011;
        8'd7     : inst <= 32'b0000000_00010_00001_000_00001_0110011;
        8'd8     : inst <= 32'b0000000_00010_00000_010_00100_0100011; //sw #0x4,r2
        8'd9     : inst <= 32'b000000000100_00000_010_00011_0000011;  //lw r3,#0x4
        8'd10    : inst <= 32'b0000000_00010_00011_000_00100_0110011; //add r4,r3,r2  
        8'd11    : inst <= 32'b1111111_00000_00000_000_11101_1100011; //beq pc-4 
        8'd12    : inst <= 32'b000000001111_00001_000_00001_0010011;
        default : inst <= 32'b000000000000_00000_000_0000_0010011;
    endcase
end
*/
endmodule
