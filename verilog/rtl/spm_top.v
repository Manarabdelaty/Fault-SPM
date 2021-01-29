/*******************************************************************
*
* Module: top.v
* Project: Serial_Parallel_Multiplier
* Author: @manarabdelatty manarabdelatty@aucegypt.edu
* Description: Top module
*
* Change history:
*
**********************************************************************/
`timescale 1ns/1ns

module spm_top(mc, mp ,clk, rst, prod, start, done);

 input clk;
 input rst;
 input [31:0] mc;
 input [31:0] mp;
 input start;
 output reg [63:0] prod; 
 output done;
 wire ybit;
 wire prodbit;
 wire proddone;
 wire ld;
 wire shift;
 reg [6:0] count;       //  count number of clk cycles
 

 
   shift_right shifter ( .x({{32 {mp[31]}},mp[31:0]}) , .clk(clk) , .rst(rst) , .ld(ld), .out(ybit));
   spm  multiplier     ( .x(mc[31:0]) ,.y(ybit) , .clk(clk) , .rst(rst) , .ld(ld) , .p(prodbit) );
   multifsm fsm        ( .clk(clk) , .rst(rst) , .proddone(proddone), .start(start), .done(done), .ld(ld), .shift(shift));
 
    always @(posedge clk or posedge rst)
             if (rst) begin
                  prod <= 0;
                  count <=0;
             end
             else begin 
                 if (shift) begin                             // Multiply state
                      prod <= {prodbit, prod[63:1]};
                      count <= count+1;
                 end
                 else if (ld) begin                          // idle state
                     count <= 0;
                     prod <= 0; 
                 end
                 else  begin                               // done state
                 count <= count;
                 prod  <= prod;
                 end
             end
  
   assign proddone = (count==66); 
 
endmodule