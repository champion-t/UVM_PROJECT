module uart_top (
    input           clk,
    input           rstn,
    input           tx_start,
    input           rx_start,
    input [16:0]    baud,
    input [3:0]     length,
    input [7:0]     tx_data,
    input           parity_en,
    input           parity_type,
    input           stop,
    output          tx_done,
    output          tx_error,
    output          rx_done,
    output          rx_error,
    output [7:0]    rx_out
);

    wire tx_rx;
    wire tx_clk;
    wire rx_clk;

    uart_clk clk_dut(
        .clk(clk),
        .rstn(rstn),
        .baud(baud),
        .tx_clk(tx_clk),
        .rx_clk(rx_clk)
    );

    uart_tx tx_dut(
        .tx_clk(tx_clk),
        .rstn(rstn),
        .tx_start(tx_start),
        .length(length),
        .tx_data(tx_data),
        .parity_en(parity_en),
        .parity_type(parity_type),
        .stop(stop),
        .tx_done(tx_done),
        .tx_error(tx_error),
        .tx(tx_rx)
    );

    uart_rx rx_dut(
        .rx_clk(rx_clk),
        .rstn(rstn),
        .rx_start(rx_start),
        .length(length),
        .parity_en(parity_en),
        .parity_type(parity_type),
        .stop(stop),
        .rx_done(rx_done),
        .rx_error(rx_error),
        .rx_out(rx_out),
        .rx(tx_rx)
    );
endmodule