`timescale 1ns/1ps

module tb_fc1;

reg clk = 0;
reg rst = 1;
reg start = 0;

wire done;
wire signed [31:0] out;

// clock
always #5 clk = ~clk;

// -------- input + weights ----------
reg signed [7:0] input_data [0:19];
reg signed [7:0] weight_data [0:19];
reg signed [7:0] bias;

// DUT
fc1_neuron dut(
    .clk(clk),
    .rst(rst),
    .start(start),
    .input_data(input_data),
    .weight_data(weight_data),
    .bias(bias),
    .out(out),
    .done(done)
);

integer i;

initial begin
    $dumpfile("sim/fc1.vcd");
    $dumpvars(0, tb_fc1);

    // load sample MFCC input (dummy for now)
    for(i=0;i<20;i=i+1)
        input_data[i] = i;

    // load weights from file
    $readmemh("rtl_weights/w1_n0.txt", weight_data);
    $display("First weight = %h", weight_data[0]);
    $display("Second weight = %h", weight_data[1]);
    $display("Third weight = %h", weight_data[2]);
    for (i=0; i<20; i=i+1) begin
    $display("RTL weight[%0d] = %0d", i, weight_data[i]);
    end


    bias = 0;

    #20 rst = 0;
    #10 start = 1;
    #10 start = 0;
    #200;

    $display("Neuron output = %d", out);

    $finish;
end

endmodule
