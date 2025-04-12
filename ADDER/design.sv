module adder(
    input               clk,
    input               rstn,
    input       [4:0]   a,
    input       [4:0]   b,
    output reg  [5:0]   y
);
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            y <= 0;
        end
        else begin
            y <= a + b;
        end
    end
endmodule