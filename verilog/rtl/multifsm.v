/*******************************************************************
*
* Module: multifsm.v
* Project: Serial_Parallel_Multiplier
* Author: @manarabdelatty manarabdelatty@aucegypt.edu
* Description: Finite state machine to managae the stages of the multiplier and generate control signals.
*
* Change history:
**********************************************************************/

`timescale 1ns/1ns

module multifsm(clk, rst, proddone, start, done, ld, shift);

 input clk;
 input rst; 
 input start;
 input proddone;
 output  done;
 output   ld;
 output shift;
 
 parameter [1:0] idle=2'b00, multiply=2'b01 , stdone= 2'b10;
 reg [1:0] state , newstate;
 
  always @* begin
 
    case (state)
       idle: if (start) newstate= multiply;
             else       newstate= idle;
       multiply: if (start)
                  if (proddone) newstate= stdone;
                  else          newstate= multiply;
                 else newstate = idle;
       stdone: if(start) newstate= stdone ;
               else      newstate= idle;
     default: newstate= 2'b00;
    endcase
  
   end
 
  always @( posedge clk or posedge rst)
         if (rst)
              state <= idle;
         else state <= newstate;
 

  assign done  = (state == stdone);
  assign ld    = (state == idle);
  assign shift = (state== multiply) && !proddone;
  
  
endmodule