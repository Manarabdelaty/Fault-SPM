/*
    Automatically generated by Fault
    Do not modify.
    Generated on: 2021-01-29 09:40:43
*/

/* Need to export PDK_ROOT */
`include "libs.ref/sky130_fd_sc_hd/verilog/primitives.v"
`include "libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v"

`include "dft/1-user_proj_top.chained.v"

module testbench;
    reg[0:0] \rst ;
    reg[31:0] \mc ;
    reg[0:0] \tck ;
    reg[0:0] \clk ;
    reg[0:0] \prod_sel ;
    reg[31:0] \mp ;
    wire[0:0] \sout ;
    wire[31:0] \prod ;
    reg[0:0] \shift ;
    reg[0:0] \sin ;
    reg[0:0] \start ;
    reg[0:0] \test ;
    wire[0:0] \done ;
    wire[169:0] \tie ;

    always #1 clk  = ~clk; 
    always #10 tck = ~tck; 

    user_proj_top uut(
        .\rst ( \rst ) , .\mc ( \mc ) , .\tck ( \tck ) , .\clk ( \clk ) , .\prod_sel ( \prod_sel ) , .\mp ( \mp ) , .\sout ( \sout ) , .\prod ( \prod ) , .\shift ( \shift ) , .\sin ( \sin ) , .\start ( \start ) , .\test ( \test ) , .\done ( \done ) , .\tie ( \tie ) 
    ); 

    wire[470:0] serializable =
        471'b011101001110100101101000000001000000010000110110101000110000011011001111000111111100100110001011001100010100000111010100110000011101110000000001100011000011001100001000110101010111100111110001011001101001101000110101011100000101111101111011111000110011101010001111110011011011110010101100100100100101010101001010100110011001010011101100010111000010101011001110000110110110011110111100010101101010111010101001111101001110110011010110110010011101000001110111110010010100111;
    reg[470:0] serial;
    integer i;
    initial begin
        // $dumpfile("chain.vcd");
        // $dumpvars(0, testbench);
        \mc = 0 ;
        \mp = 0 ;
        \clk = 0 ;
        \rst = 1 ;
        \start = 0 ;
        \prod_sel = 0 ;
        \sin = 0 ;
        \shift = 0 ;
        \tck = 0 ;
        \test = 0 ;

        #100;
        rst = ~rst;
        shift = 1;
        test = 1;
        for (i = 0; i < 471; i = i + 1) begin
            sin = serializable[i];
            #20;
        end
        for (i = 0; i < 471; i = i + 1) begin
            serial[i] = sout;
            #20;
        end
        if (serial === serializable) begin
            $display("SUCCESS_STRING");
        end
        $finish;
    end
endmodule
