module tb ();   
    reg clk;
    reg rst_n;

    initial begin
        clk = 1'b0;
        rst_n = 1'b0; 		//复位信号为0有效
        #5
        rst_n = 1'b1;		//200ns后复位信号变1
        #1000
        $finish;
    end

    always #1 clk = ~clk;
    
    initial begin
    	$fsdbDumpfile("rtl.fsdb");
	    $fsdbDumpvars(0, tb);
        $fsdbDumpMDA();
    end

    top u_top( .* );


endmodule
