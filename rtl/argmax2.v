module argmax2(
    input  signed [31:0] in0,
    input  signed [31:0] in1,
    output reg result
);

always @(*) begin
    if (in1 > in0)
        result = 1;   // drone
    else
        result = 0;   // non-drone
end

endmodule
