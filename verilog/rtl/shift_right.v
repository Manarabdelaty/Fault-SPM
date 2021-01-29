/*******************************************************************
*
* Module: shift_right.v
* Project: Serial_Parallel_Multiplier
* Author: @manarabdelatty manarabdelatty@aucegypt.edu
* Description: Shift right register. Parallel Input and serial output. 
*
* Change history: 
*
**********************************************************************/
`timescale 1ns/1ns

module shift_right(x,clk, rst,ld, out);

 input clk;
 input rst;
 input ld;
 input [63:0]x;
 output reg  out;
 reg [63:0] shiftreg;
 

  always @(posedge clk or posedge rst) begin
       if (rst) begin
           shiftreg <= 0;
           out <= 1'b0;
       end
       else if (ld) begin
              shiftreg <= x;
              out <= 1'b0;
       end
       else  begin
            out <= shiftreg[0];
            shiftreg <= {1'b0,shiftreg[63:1]};  ;
       end
 end

endmodule