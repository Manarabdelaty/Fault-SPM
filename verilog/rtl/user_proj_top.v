module user_proj_top (mc, mp ,clk, rst, prod, start, prod_sel, done, tie);

    input clk;
    input rst;
    input [31:0] mc;
    input [31:0] mp;
    input start;
    input prod_sel;
    output [31:0] prod; 
    output done;
    output [169:0] tie;

    wire [63:0] _prod_; 

    assign prod = prod_sel ? _prod_[63:32] : _prod_[31:0];

    spm_top spm_top (
        .clk(clk),
        .rst(rst),
        .mc(mc),
        .mp(mp),
        .start(start),
        .prod(_prod_),
        .done(done)
    );

    assign tie = 170'd0;

endmodule