module fc1_layer(
    input clk,
    input rst,
    input start,

    input signed [7:0] input_data [0:19],
    input signed [7:0] weights [0:319],  // 20x16 flattened
    input signed [7:0] bias [0:15],

    output reg signed [31:0] out [0:15],
    output reg done
);

reg [4:0] neuron_idx;
reg neuron_start;
wire neuron_done;
reg prev_done;
wire signed [31:0] neuron_out;

reg signed [7:0] neuron_weights [0:19];

// instantiate single neuron
fc1_neuron neuron(
    .clk(clk),
    .rst(rst),
    .start(neuron_start),
    .input_data(input_data),
    .weight_data(neuron_weights),
    .bias(bias[neuron_idx]),
    .out(neuron_out),
    .done(neuron_done)
);

integer i;

// always @(posedge clk) begin
//     if (rst) begin
//         neuron_idx <= 0;
//         done <= 0;
//         neuron_start <= 0;
//     end
//     else begin
//         if (start && neuron_idx == 0)
//             neuron_start <= 1;

//         if (neuron_start)
//             neuron_start <= 0;

//         if (neuron_done) begin
//             out[neuron_idx] <= neuron_out;
//             neuron_idx <= neuron_idx + 1;

//             if (neuron_idx == 15) begin
//                 done <= 1;
//             end
//             else begin
//                 neuron_start <= 1;
//             end
//         end
//     end
// end

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

        // detect rising edge
        if (neuron_done && !prev_done) begin
            out[neuron_idx] <= neuron_out;
            neuron_idx <= neuron_idx + 1;

            if (neuron_idx == 15) begin
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
    for (i=0;i<20;i=i+1) begin
        neuron_weights[i] = weights[neuron_idx*20 + i];
    end
end

endmodule
