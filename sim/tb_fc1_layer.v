`timescale 1ns/1ps

module tb_fc1_layer;

reg clk = 0;
reg rst = 1;
reg start = 0;

always #5 clk = ~clk;

wire done;

reg signed [7:0] input_data [0:19];
reg signed [7:0] weights [0:319];
reg signed [7:0] bias [0:15];

wire signed [31:0] out [0:15];

fc1_layer dut(
    .clk(clk),
    .rst(rst),
    .start(start),
    .input_data(input_data),
    .weights(weights),
    .bias(bias),
    .out(out),
    .done(done)
);

integer i;

initial begin
    $dumpfile("sim/fc1_layer.vcd");
    $dumpvars(0, tb_fc1_layer);

    // simple input (same as before)
    for(i=0;i<20;i=i+1)
        input_data[i] = i;

    // load weights
    $readmemh("rtl_weights/w1.txt", weights);

    // zero bias for now
    for(i=0;i<16;i=i+1)
        bias[i] = 0;

    #20 rst = 0;

    #10 start = 1;
    #10 start = 0;

    wait(done);

    $display("FC1 outputs:");
    for(i=0;i<16;i=i+1)
        $display("out[%0d] = %d", i, out[i]);

    #20 $finish;
end

endmodule
