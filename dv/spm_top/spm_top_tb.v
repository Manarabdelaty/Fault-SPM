// author: @manarabdelatty
// Testbench for spm_top

`timescale 1ns/1ns

`ifdef GL

  /* Need to export PDK_ROOT */
  `include "libs.ref/sky130_fd_sc_hd/verilog/primitives.v"
  `include "libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v"

  `include "gl/user_proj_top.v"
`else
  `include "multifsm.v"
  `include "spm.v"
  `include "shift_right.v"
  `include "spm_top.v"
  `include "user_proj_top.v"
`endif

module spm_top_tb;

	//Inputs
	reg clk;
	reg rst;
	reg signed [31: 0] mc;
	reg signed [31: 0] mp;
	reg start;
  reg prod_sel;

	//Outputs
	reg signed [63: 0] prod;
	wire [31: 0] _prod_;

	wire done;
    
    wire signed [63:0] refp;
    wire err;

	//Instantiation of Unit Under Test
	user_proj_top uut (
  `ifdef DFT
    .tms(1'b1),  // must be pulled to one
    .tck(1'b0),  // must be pulled to zero 
    .tdi(1'b0),  // must be pulled to zero
    .trst(1'b0), // must be pulled to zero
  `endif
  `ifdef USE_POWER_PINS
    .VPWR(1'b1),
    .VGND(1'b0),
  `endif
		.clk(clk),
		.rst(rst),
		.mc(mc),
		.mp(mp),
		.start(start),
    .prod_sel(prod_sel),
		.prod(_prod_),
		.done(done)
	);

    assign refp = $signed(mc) * $signed(mp);          // Golden Model
    assign err  = (done)? (refp != prod) : 1'bx;      // The Checker
    
    always #1 clk=!clk;                               // Clock Generator

    always @(posedge clk) begin                      // The Checker
        //  if (done == 1'b1)
        //      $display ( "\t time = %d,\t clk = %b,\t rst = %b,\t start = %b,\t mc = %d , \t mp= %d , \t P = %d ,\tdone = %b, \tError= %b,\t refp= %d"
        //                          , $time,clk,rst,start,mc,mp, prod, done , err, refp);
        //  if (err) begin
        //      $display ("DUT Error at time %d", $time);
        //      $display ("Expected value %d, Got Value %d", refp, prod);
        //  end
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
    prod_sel = 0;
	end

  initial begin
    $dumpfile("spm_top.vcd");
    $dumpvars(0, spm_top_tb);
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
  
 reg signed [31:0] prod_h;
 reg signed [31:0] prod_l;

 initial begin
     forever begin
     @(start_trigger);
     start= 1;

      repeat (68) begin
      @(negedge clk);
      end

      prod_l = _prod_;
      #2;
      prod_sel = 1;
      #2;
      prod_h = _prod_;
      #2;
      prod = {prod_h, prod_l};
      #2;
      prod_sel = 0;
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