module adder_4bit(
input  logic [3:0]       A           ,
input  logic [3:0]       B           ,
input  logic             Cin         ,
output logic [3:0]       S           ,
output logic             Cout
);
logic c1,c2,c3;
//  超前进位算法
assign c1 = (A[0]&B[0]) |((A[0]+B[0])&Cin) ;
assign c2 = (A[1]&B[1]) |((A[1]+B[1])&c1 ) ;
assign c3 = (A[2]&B[2]) |((A[2]+B[2])&c2 ) ;
assign Cout = (A[3]&B[3])|((A[3]+B[3])&c3 ) ;
assign S = {A[3]^B[3]^c3,A[2]^B[2]^c2,A[1]^B[1]^c1,A[0]^B[0]^Cin}; 
endmodule