`include "spm.v"

module spm_tb;

	//Inputs
	reg clk;
	reg rst;
	reg signed [7: 0] x;

    reg signed [7:0] Y;
    reg signed [15:0] P;

	//Outputs
	wire p;

    reg[3:0] cnt;
    wire done; 
    reg start;

	//Instantiation of Unit Under Test
	spm #(8) uut (
		.clk(clk),
		.rst(rst),
		.y(Y[0]),
		.x(x),
		.p(p)
	);

    always #5 clk = ~clk;

    always @ (posedge clk)
        if(rst) Y = 0;
        else if(start) Y <= {1'b0,Y[7:1]};

    always @ (posedge clk)
        if(rst) P = 0;
        else if(start) P <= {p, P[15:1]};

	always @ (posedge clk)
        if(rst) cnt = 0;
        else if(start) cnt <= cnt + 1;

    assign done = (cnt == 15);

	initial begin
        $dumpfile("spm.vcd");
        $dumpvars(0, spm_tb);
        
	//Inputs initialization
		clk = 0;
		rst = 0;
        #20; 
        rst = 1;
        #20;
        rst = 0;

        // Even x Even
		x = 50;
        Y = 50;
        #10 start = 1'b1;
        wait(done == 1'b1);
        wait(done == 1'b0);
        #20;
        if (P == 2500) $display("[PASS] %d x %d = %d", x, 50, P); else $display("[FAIL]  %d x %d != %d", x, 50, P);
        start = 1'b0;
        #20;

        rst = 1;
        #20;
        rst = 0;
       
        // Odd x Odd
        x = 25;
        Y = 65;
        #10 start = 1'b1;
        wait(done == 1'b1);
        wait(done == 1'b0);
        #20;
        if (P == 1625) $display("[PASS] %d x %d = %d", x, 65, P); else $display("[FAIL]  %d x %d != %d", x, 65, P);
        start = 1'b0;
        #20;

        rst = 1;
        #20;
        rst = 0;

        // Even x Odd
        x = 80;
        Y = 9;
        #10 start = 1'b1;
        wait(done == 1'b1);
        wait(done == 1'b0);
        #20;
        if (P == (x * 9)) $display("[PASS] %d x %d = %d", x, 9, P); else $display("[FAIL]  %d x %d != %d", x, 9, P);
        start = 1'b0;
        #20;

        rst = 1;
        #20;
        rst = 0;

        // Odd x Even
        x = 9;
        Y = 80;
        #10 start = 1'b1;
        wait(done == 1'b1);
        wait(done == 1'b0);
        #20;
        if (P == (x * 80)) $display("[PASS] %d x %d = %d", x, 80, P); else $display("[FAIL]  %d x %d != %d", x, 80, P);
        start = 1'b0;
        #20;

        rst = 1;
        #20;
        rst = 0;

        // Odd Signed x Even
        x = -9;
        Y = 80;
        #10 start = 1'b1;
        wait(done == 1'b1);
        wait(done == 1'b0);
        #20;
        if (P == (x * 80)) $display("[PASS] %d x %d = %d", x, 80, P); else $display("[FAIL]  %d x %d != %d", x, 80, P);
        start = 1'b0;

        rst = 1;
        #20;
        rst = 0;

        // Even Signed x Even
        x = -8;
        Y = 80;
        #10 start = 1'b1;
        wait(done == 1'b1);
        wait(done == 1'b0);
        #20;
        if (P == (x * 80)) $display("[PASS] %d x %d = %d", x, 80, P); else $display("[FAIL]  %d x %d != %d", x, 80, P);
        start = 1'b0;

        rst = 1;
        #20;
        rst = 0;

        // Odd Signed x Even Signed
        x = -9;
        Y = -80;
        #10 start = 1'b1;
        wait(done == 1'b1);
        wait(done == 1'b0);
        #20;
        if (P == (x * 80)) $display("[PASS] %d x %d = %d", x, 80, P); else $display("[FAIL]  %d x %d != %d", x, 80, P);
        start = 1'b0;


        #1000;
        $finish;
	end

endmodule