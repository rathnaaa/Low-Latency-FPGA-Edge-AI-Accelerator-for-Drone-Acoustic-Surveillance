module relu16(
    input signed [31:0] in [0:15],
    output signed [31:0] out [0:15]
);

genvar i;
generate
    for (i=0; i<16; i=i+1) begin
        assign out[i] = (in[i] < 0) ? 0 : in[i];
    end
endgenerate

endmodule
