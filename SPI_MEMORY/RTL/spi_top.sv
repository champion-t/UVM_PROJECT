module spi_top (
    input           clk,
    input           rstn,
    input           wr,
    input  [7:0]    addr,
    input  [7:0]    din,
    output          done,
    output          error,
    output [7:0]    dout
);

    wire cs;
    wire mosi;
    wire miso;
    wire ready;
    wire op_done;

    spi_master master_dut(
        .clk(clk),
        .rstn(rstn),
        .wr(wr),
        .ready(ready),
        .op_done(op_done),
        .miso(miso),
        .addr(addr),
        .din(din),
        .mosi(mosi),
        .cs(cs),
        .done(done),
        .error(error),
        .dout(dout)
    );

    spi_slave slave_dut(
        .clk(clk),
        .rstn(rstn),
        .cs(cs),
        .mosi(mosi),
        .op_done(op_done),
        .ready(ready),
        .miso(miso)
    );
endmodule