interface i2c_if(input logic clk);
    logic rstn;
    logic wr;
    logic [6:0] addr;
    logic [7:0] din;
    logic [7:0] datard;
    logic done;
endinterface