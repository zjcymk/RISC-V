module tb ();
    reg clk;
    reg rst_n;
    
    initial begin
    clk = 1'b0;
    rst_n = 1'b0; 		//复位信号为0有效
    #5
    rst_n = 1'b1;		//200ns后复位信号变1
    end

    always #1 clk = ~clk;

    top u_top(
    .clk      (clk  ),
    .rst_n    (rst_n)

);


endmodule