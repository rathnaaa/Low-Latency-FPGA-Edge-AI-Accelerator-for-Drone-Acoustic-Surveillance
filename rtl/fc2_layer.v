module fc2_layer(
    input clk,
    input rst,
    input start,

    input signed [31:0] input_data [0:15],
    input signed [7:0] weights [0:127],   // 16x8
    input signed [7:0] bias [0:7],

    output reg signed [31:0] out [0:7],
    output reg done
);

reg [3:0] neuron_idx;
reg neuron_start;
wire neuron_done;
wire signed [31:0] neuron_out;

reg signed [7:0] neuron_weights [0:15];
reg signed [7:0] input8 [0:15];

// convert 32-bit input to 8-bit
integer k;
always @(*) begin
    for (k=0;k<16;k=k+1)
        input8[k] = input_data[k][7:0];
end

fc1_neuron #(.INPUT_SIZE(16)) neuron(
    .clk(clk),
    .rst(rst),
    .start(neuron_start),
    .input_data(input8),
    .weight_data(neuron_weights),
    .bias(bias[neuron_idx]),
    .out(neuron_out),
    .done(neuron_done)
);

integer i;
reg prev_done;

always @(posedge clk) begin
    if (rst) begin
        neuron_idx <= 0;
        done <= 0;
        neuron_start <= 0;
        prev_done <= 0;
    end
    else begin
        prev_done <= neuron_done;

        if (start && neuron_idx == 0)
            neuron_start <= 1;

        if (neuron_start)
            neuron_start <= 0;

        if (neuron_done && !prev_done) begin
            out[neuron_idx] <= neuron_out;
            neuron_idx <= neuron_idx + 1;

            if (neuron_idx == 7) begin
                done <= 1;
            end
            else begin
                neuron_start <= 1;
            end
        end
    end
end

// load weights for current neuron
always @(*) begin
    for (i=0;i<16;i=i+1)
        neuron_weights[i] = weights[neuron_idx*16 + i];
end

endmodule
