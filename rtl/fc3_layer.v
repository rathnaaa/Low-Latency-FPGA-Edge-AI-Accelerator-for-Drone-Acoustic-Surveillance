module fc3_layer(
    input clk,
    input rst,
    input start,

    input signed [31:0] input_data [0:7],
    input signed [7:0] weights [0:15],   // 8x2
    input signed [7:0] bias [0:1],

    output reg signed [31:0] out [0:1],
    output reg done
);

reg [1:0] neuron_idx;
reg neuron_start;
wire neuron_done;
wire signed [31:0] neuron_out;

reg signed [7:0] neuron_weights [0:7];
reg signed [7:0] input8 [0:7];

integer k;
always @(*) begin
    for (k=0;k<8;k=k+1)
        input8[k] = input_data[k][7:0];
end

fc1_neuron #(.INPUT_SIZE(8)) neuron(
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

            if (neuron_idx == 1) begin
                done <= 1;
            end
            else begin
                neuron_start <= 1;
            end
        end
    end
end

always @(*) begin
    for (i=0;i<8;i=i+1)
        neuron_weights[i] = weights[neuron_idx*8 + i];
end

endmodule
