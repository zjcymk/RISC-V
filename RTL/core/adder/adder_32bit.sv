module adder_32bit(
input   logic [31:0]  A           ,
input   logic [31:0]  B           ,
input   logic         Cin         ,
output  logic [31:0]  S           ,
output  logic         Cout
);


logic C;

adder_16bit u_16bit_1(
.A    (A[15:0]),
.B    (B[15:0]),
.Cin  (Cin),
.S    (S[15:0]),
.Cout (C) 
);
adder_16bit u_16bit_2(
.A    (A[31:16]),
.B    (B[31:16]),
.Cin  (C),
.S    (S[31:16]),
.Cout (Cout) 
);


endmodule