/*
ALU Arithmetic and Logic Operations
---------------------------------------
ALU_Sel     ALU Operation
0000          A + B 
0001          A - B
0010          A * B
0011          A / B
default       16'h1507          
*/

module alu (
    input               clk,
    input               rstn,
    input       [7:0]   a,
    input       [7:0]   b,
    input       [3:0]   op_sel,
    output reg  [15:0]  alu_out,
    output reg          carry_out
);
    reg [15:0] alu_temp;
    wire [8:0] carry_temp;

    assign carry_temp = a + b;

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            alu_out <= 0;
            carry_out <= 0;
        end
        else begin
            alu_out <= alu_temp;
            carry_out <= carry_temp[8];
        end
    end

    always @(*) begin
        case(op_sel)
            4'b0000: alu_temp = a + b;
            4'b0001: alu_temp = a - b;
            4'b0010: alu_temp = a * b;
            4'b0011: alu_temp = a / b;
            default: alu_temp = 16'h1507;
        endcase
    end
endmodule