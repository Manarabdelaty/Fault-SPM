// author: @manarabdelatty
// Testbench for spm_top

`timescale 1ns/1ns

`include "libs.ref/sky130_fd_sc_hd/verilog/primitives.v"
`include "libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v"

`include "dft/2-spm_top.tap.v"
`include "rtl/user_project_wrapper.v"

`ifndef MPRJ_IO_PADS
`define MPRJ_IO_PADS 38
`endif

module wrapper_tb;

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

  // Wrapper Inputs
  reg wbs_stb_i;
  reg wbs_cyc_i;
  reg wbs_we_i;
  reg [3:0] wbs_sel_i;
  wire [31:0] wbs_dat_i;

  wire [127:0] la_data_in;
  wire [`MPRJ_IO_PADS-1:0] io_in;

  // Wrapper Outputs
  wire wbs_ack_o;
  wire [31:0] wbs_dat_o;
  
  wire [127:0] la_data_out;
  wire [`MPRJ_IO_PADS-1:0] io_out;
  wire [`MPRJ_IO_PADS-1:0] io_oeb;

  // Wrapper to SPM-TOP
  assign prod = la_data_out[127:64];
  assign la_data_in[31:0]  = mc;
  assign la_data_in[63:32] = mp;
  assign done = la_data_out[0];
  assign la_data_in[64] = start;

  // Tie JTAG ports to put the chip in the functional mode
  assign io_in[0] = 1'b0;   // tck
  assign io_in[1] = 1'b1;   // tms
  assign io_in[2] = 1'b0;   // tdi
  assign io_in[3] = 1'b0;   // trst

 	//Instantiation of Unit Under Test
	user_project_wrapper uut (
  `ifdef USE_POWER_PINS
        .VPWR(1'b1),
        .VGND(1'b0),
   `endif
        .wb_clk_i(clk),
        .wb_rst_i(rst),
        .wbs_stb_i(wbs_stb_i),
        .wbs_cyc_i(wbs_cyc_i),
        .wbs_we_i(wbs_we_i),
        .wbs_sel_i(wbs_sel_i),
        .wbs_dat_i(wbs_dat_i),
        .wbs_adr_i(),
        .wbs_ack_o(wbs_ack_o),
        .wbs_dat_o(wbs_dat_o),
        .la_data_in(la_data_in),
        .la_data_out(la_data_out),
        .la_oen(),
        .io_in(io_in),
        .io_out(io_out),
        .io_oeb(io_oeb)
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

  initial begin
    $dumpfile("wrapper.vcd");
    $dumpvars(0, wrapper_tb);
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
     wbs_stb_i = 1;
     wbs_cyc_i = 1;
     wbs_we_i = 1;
     wbs_sel_i = 1;
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