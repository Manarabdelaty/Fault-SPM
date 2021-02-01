module user_proj_top (mc, mp ,clk, rst, prod, start, done, tie);

    input clk;
    input rst;
    input [31:0] mc;
    input [31:0] mp;
    input start;
    output [63:0] prod; 
    output done;
    output [169:0] tie;

    spm_top spm_top (
        .clk(clk),
        .rst(rst),
        .mc(mc),
        .mp(mp),
        .start(start),
        .prod(prod),
        .done(done)
    );

    assign tie = 170'd0;

endmodule