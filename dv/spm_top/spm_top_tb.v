// author: @manarabdelatty
// Testbench for spm_top

`timescale 1ns/1ns

`include "multifsm.v"
`include "spm.v"
`include "shift_right.v"
`include "spm_top.v"

module spm_top_tb;

	//Inputs
	reg clk;
	reg rst;
	reg signed [31: 0] mc;
	reg signed [31: 0] mp;
	reg start;

	//Outputs
	wire signed [63: 0] prod;
	wire done;
    
    wire signed [63:0] refp;
    wire err;

	//Instantiation of Unit Under Test
	spm_top uut (
		.clk(clk),
		.rst(rst),
		.mc(mc),
		.mp(mp),
		.start(start),
		.prod(prod),
		.done(done)
	);

    assign refp = $signed(mc) * $signed(mp);          // Golden Model
    assign err  = (done)? (refp != prod) : 1'bx;      // The Checker
    
    always #1 clk=!clk;                               // Clock Generator

    always @(posedge clk) begin                      // The Checker
        //  if (done == 1'b1)
        //      $display ( "\t time = %d,\t clk = %b,\t rst = %b,\t start = %b,\t mc = %d , \t mp= %d , \t P = %d ,\tdone = %b, \tError= %b,\t refp= %d"
        //                          , $time,clk,rst,start,mc,mp, prod, done , err, refp);
         if (err) begin
             $display ("DUT Error at time %d", $time);
             $display ("Expected value %d, Got Value %d", refp, prod);
         end
    end
    
   event rst_trigger; 
   event start_trigger;
   event rst_done_trigger; 
   event start_disabled;
   event loop_trigger;
   
	initial begin
	//Inputs initialization
		clk = 0;
		rst = 1;
		mc = 0;
		mp = 0;
        start =0;
	end


    initial begin : TestCases
       #10 ->rst_trigger; 
       @(rst_done_trigger);
      
       @(negedge clk); begin                  // MC & MP must be stable before firing start
         mc =3;                              // Test Case1 : unsigned multiplier & unsigned multiplicant
         mp =4;
       end
      -> start_trigger;
     
      // Test Case2 : Odd signed multiplier & Even unsigned multiplicant
      @(start_disabled);
       @(negedge clk); begin
         mc =-15;
         mp = 10;
       end
       ->start_trigger;
    
       // Test Case3 : Even unsigned multiplier & Odd signed multiplicant
      @(start_disabled);
       @(negedge clk); begin
         mc = 200;
         mp = -50;
       end
       ->start_trigger;
       
      // Test Case4 : Even signed multiplier & Even signed multiplicant
      @(start_disabled);
       @(negedge clk); begin
         mc = -150;
         mp = -32;
       end
       ->start_trigger;
       
        // Test Case5 : Deassert Enable at the middle of multiply stage 
       @ (start_disabled);
       @(negedge clk); begin
         mc = 6;
         mp = 6;
       end
       ->start_trigger;
       repeat (50) begin
       @(negedge clk);
       end
       start = 0;
       
      // Test Case6 : Even signed multiplier & Odd unsigned multiplicant
      @(start_disabled);
       @(negedge clk); begin
         mc =-150;
         mp = 9;
       end
       ->start_trigger;
    
      // Test Case7 : Odd unsigned multiplier & Even signed multiplicant
      @(start_disabled);
       @(negedge clk); begin
         mc = 150;
         mp = -16;
       end
       ->start_trigger;

      // Test Case8 : Odd signed multiplier & Odd signed multiplicant
      @(start_disabled);
       @(negedge clk); begin
         mc = -159;
         mp = -129;
       end
       ->start_trigger;
    
     // Test Case9 : Big Numbers
      @(start_disabled);
       @(negedge clk); begin
         mc = 32'hFFFF_FFFF;
         mp = 32'hFFFF_FFFF;
       end
       ->start_trigger;

     // Test Case10 : Big Numbers
      @(start_disabled);
       @(negedge clk); begin
         mc = 32'h0F0F_F0FF;
         mp = 32'h0F0F_F0FF;
       end
       ->start_trigger;

       // TestCase: for loop to generate mc & mp 
       @(start_disabled);
       -> loop_trigger;

       $finish;
 end 
 
    initial begin   // for loop thread
 
     @(loop_trigger);
     @(negedge clk) begin
       mc= (2**32-1);
       mp= (2**32-1);
     end
     ->start_trigger;
     
     forever begin
     @(start_disabled);
     @(negedge clk) begin
     mc= mc-1;
     mp= mp-1;
     end
     ->start_trigger;
    end
 end
 
 // Enable Logic
 
 initial begin
     forever begin
     @(start_trigger);
     start= 1;

      repeat (68) begin
      @(negedge clk);
      end

      $display ( "time = %d, clk = %b, rst = %b, start = %b, mc = %d ,  mp= %d , P = %d ,done = %b, Error= %b, refp= %d"
                                 , $time,clk,rst,start,mc,mp, prod, done , err, refp);       start=0;
     ->start_disabled;
     end
 end
 
 //reset Logic
initial begin
     forever begin
     @(rst_trigger);
     @(posedge clk);
     rst = 1'b1;
     @(posedge clk);
     rst = 1'b0;
     ->rst_done_trigger;
     end
end
  
endmodule