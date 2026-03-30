module mac (
    input clk,
    input rst,
    input signed [7:0] a,   // input
    input signed [7:0] b,   // weight
    input valid,
    output reg signed [31:0] acc
);

always @(posedge clk) begin
    if (rst)
        acc <= 0;
    else if (valid)
        acc <= acc + (a * b);
end

endmodule
