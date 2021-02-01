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

  parameter [1:0] IDLE=2'b00, MUL=2'b01 , DONE= 2'b10;
  reg [1:0] state , newstate;
 
  always @* begin
    newstate = IDLE;
    case (state)
        IDLE: if (start) newstate= MUL; else newstate= IDLE;
        MUL: if (start & proddone) newstate = DONE; else if (start) newstate = MUL; else newstate = IDLE;
        DONE: if(start) newstate= DONE ; else newstate= IDLE;
    endcase

    end
 
  always @( posedge clk or posedge rst)
         if (rst)
              state <= IDLE;
         else state <= newstate;
 
  assign done  = (state == DONE);
  assign ld    = (state == IDLE);
  assign shift = (state== MUL) && !proddone;
  
  
endmodule