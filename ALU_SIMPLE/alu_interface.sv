interface alu_if (input bit clk);
    logic           rstn;
    logic [7:0]     a;
    logic [7:0]     b;
    logic [3:0]     op_sel;
    logic [15:0]    alu_out;
    logic           carry_out;
endinterface