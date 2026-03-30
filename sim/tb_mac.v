module tb_mac;

reg clk = 0;
reg rst = 1;
reg signed [7:0] a;
reg signed [7:0] b;
reg valid;

wire signed [31:0] acc;

mac uut(
    .clk(clk),
    .rst(rst),
    .a(a),
    .b(b),
    .valid(valid),
    .acc(acc)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("sim/mac.vcd");
    $dumpvars(0, tb_mac);
    
    #10 rst = 0;

    a = 10; b = 3; valid = 1;
    #10;

    a = 5; b = 2;
    #10;

    valid = 0;
    #50;

    $finish;
end

endmodule
