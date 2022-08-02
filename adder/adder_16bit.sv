module adder_16bit(
input  logic [15:0]  A           ,
input  logic [15:0]  B           ,
input  logic         Cin         ,
output logic [15:0]  S           ,
output logic         Cout
);


logic C1,C2,C3;

adder_4bit u_4bit_1(
.A    (A[3:0]),
.B    (B[3:0]),
.Cin  (Cin),
.S    (S[3:0]),
.Cout (C1) 
);
adder_4bit u_4bit_2(
.A    (A[7:4]),
.B    (B[7:4]),
.Cin  (C1),
.S    (S[7:4]),
.Cout (C2) 
);
adder_4bit u_4bit_3(
.A    (A[11:8]),
.B    (B[11:8]),
.Cin  (C2),
.S    (S[11:8]),
.Cout (C3) 
);
adder_4bit u_4bit_4(
.A    (A[15:12]),
.B    (B[15:12]),
.Cin  (C3),
.S    (S[15:12]),
.Cout (Cout) 
);
endmodule