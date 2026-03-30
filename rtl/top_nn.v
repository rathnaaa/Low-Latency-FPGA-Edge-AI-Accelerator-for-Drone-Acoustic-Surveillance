module top_nn(
    input clk,
    input rst,
    input start,

    input signed [7:0] input_data [0:19],

    input signed [7:0] w1 [0:319],
    input signed [7:0] b1 [0:15],

    input signed [7:0] w2 [0:127],
    input signed [7:0] b2 [0:7],

    input signed [7:0] w3 [0:15],
    input signed [7:0] b3 [0:1],

    output result,
    output done,

    output signed [31:0] drone_score,
    output signed [31:0] background_score
);

wire signed [31:0] fc1_out [0:15];
wire signed [31:0] relu1_out [0:15];

wire signed [31:0] fc2_out [0:7];
wire signed [31:0] relu2_out [0:7];

wire signed [31:0] fc3_out [0:1];

assign background_score = fc3_out[0];
assign drone_score = fc3_out[1];

wire fc1_done, fc2_done, fc3_done;

// FC1
fc1_layer fc1(
    .clk(clk),
    .rst(rst),
    .start(start),
    .input_data(input_data),
    .weights(w1),
    .bias(b1),
    .out(fc1_out),
    .done(fc1_done)
);

// ReLU1
relu16 r1(
    .in(fc1_out),
    .out(relu1_out)
);

// FC2
fc2_layer fc2(
    .clk(clk),
    .rst(rst),
    .start(fc1_done),
    .input_data(relu1_out),
    .weights(w2),
    .bias(b2),
    .out(fc2_out),
    .done(fc2_done)
);

// ReLU2
relu8 r2(
    .in(fc2_out),
    .out(relu2_out)
);

// FC3
fc3_layer fc3(
    .clk(clk),
    .rst(rst),
    .start(fc2_done),
    .input_data(relu2_out),
    .weights(w3),
    .bias(b3),
    .out(fc3_out),
    .done(fc3_done)
);

// Argmax
argmax2 am(
    .in0(fc3_out[0]),
    .in1(fc3_out[1]),
    .result(result)
);

assign done = fc3_done;

endmodule
