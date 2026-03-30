`timescale 1ns/1ps

module tb_top_nn;

integer cycle_count = 0;

reg clk = 0;
reg rst = 1;
reg start = 0;

always #5 clk = ~clk;

always @(posedge clk)
    cycle_count = cycle_count + 1;

wire done;
wire result;

wire signed [31:0] drone_score;
wire signed [31:0] background_score;

// ---------- INPUT ----------
reg signed [7:0] input_data [0:19];

// ---------- WEIGHTS ----------
reg signed [7:0] w1 [0:319];
reg signed [7:0] w2 [0:127];
reg signed [7:0] w3 [0:15];

reg signed [7:0] b1 [0:15];
reg signed [7:0] b2 [0:7];
reg signed [7:0] b3 [0:1];

// DUT
top_nn dut(
    .clk(clk),
    .rst(rst),
    .start(start),
    .input_data(input_data),
    .w1(w1),
    .b1(b1),
    .w2(w2),
    .b2(b2),
    .w3(w3),
    .b3(b3),
    .result(result),
    .done(done),
    .drone_score(drone_score),
    .background_score(background_score)
);

integer i;

initial begin
    $dumpfile("sim/top_nn.vcd");
    $dumpvars(0,tb_top_nn);

    // example MFCC input
    // for(i=0;i<20;i=i+1)
    //     input_data[i] = i;

    // load real MFCC feature vector
    $readmemh("rtl_weights/mfcc_input.txt", input_data);

    // load weights
    $readmemh("rtl_weights/w1.txt", w1);
    $readmemh("rtl_weights/w2.txt", w2);
    //$readmemh("rtl_weights/w3.txt", w3);
    $readmemh("rtl_weights/w3_fixed.txt", w3);


    // zero bias for now
    // for(i=0;i<16;i=i+1) b1[i]=0;
    // for(i=0;i<8;i=i+1)  b2[i]=0;
    // for(i=0;i<2;i=i+1)  b3[i]=0;

    $readmemh("rtl_weights/b1.txt", b1);
    $readmemh("rtl_weights/b2.txt", b2);
    //$readmemh("rtl_weights/b3.txt", b3);
    $readmemh("rtl_weights/b3_fixed.txt", b3);

    // #20 rst = 0;

    // #10 start = 1;
    // #10 start = 0;

    // wait(done);

    // $display("Total inference cycles = %d", cycle_count);

    // $display("Drone score      = %d", drone_score);
    // $display("Background score = %d", background_score);

    // if(result)
    //     $display("DRONE DETECTED");
    // else
    //     $display("NO DRONE");

    #20 rst = 0;

    repeat (5) begin

        // wait until previous inference finishes and done resets
        //@(negedge done);

        // reset accelerator
        rst = 1;
        #20;
        rst = 0;

        @(posedge clk);
        cycle_count = 0;

        // trigger inference
        #10 start = 1;
        #10 start = 0;

        // wait until inference finishes
        wait(done);
        //wait(done == 1);

        $display("Total inference cycles = %d", cycle_count);
        $display("Latency (us) = %f", cycle_count * 10.0 / 1000.0);
        $display("Throughput = %f inferences/sec", 100000000.0 / cycle_count);
        $display("Drone score      = %d", drone_score);
        $display("Background score = %d", background_score);

        if(result)
            $display("Decision = DRONE DETECTED");
        else
            $display("Decision = NO DRONE");

        #50;
    end

    #20 $finish;
end

endmodule
