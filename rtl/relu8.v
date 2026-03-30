module relu8(
    input  signed [31:0] in [0:7],
    output signed [31:0] out [0:7]
);

genvar i;
generate
    for (i=0; i<8; i=i+1) begin
        assign out[i] = (in[i] < 0) ? 0 : in[i];
    end
endgenerate

endmodule
