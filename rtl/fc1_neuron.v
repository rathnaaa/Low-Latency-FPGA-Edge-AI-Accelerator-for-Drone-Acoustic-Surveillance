module fc1_neuron #(
    parameter INPUT_SIZE = 20
)(
    input clk,
    input rst,
    input start,

    input signed [7:0] input_data [0:INPUT_SIZE-1],
    input signed [7:0] weight_data [0:INPUT_SIZE-1],
    input signed [7:0] bias,

    output reg signed [31:0] out,
    output reg done
);

reg [5:0] index;
reg signed [31:0] acc;
reg running;

always @(posedge clk) begin
    if (rst) begin
        index   <= 0;
        acc     <= 0;
        done    <= 0;
        running <= 0;
        out     <= 0;
    end
    else begin

        // start pulse
        if (start && !running) begin
            index   <= 0;
            acc     <= 0;
            done    <= 0;
            running <= 1;
        end

        // accumulate
        if (running) begin
            acc <= acc + input_data[index] * weight_data[index];
            index <= index + 1;

            if (index == INPUT_SIZE-1) begin
                out <= acc + input_data[index] * weight_data[index] + bias;
                done <= 1;
                running <= 0;
            end
        end

    end
end

endmodule
