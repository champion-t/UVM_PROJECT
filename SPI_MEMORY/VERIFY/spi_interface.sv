interface spi_if(input logic clk);
    logic rstn;
    logic wr;
    logic [7:0] addr;
    logic [7:0] din;
    logic [7:0] dout;
    logic done;
    logic error;
endinterface