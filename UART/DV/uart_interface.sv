interface uart_if (input bit clk);
    logic rstn;
    logic tx_start;
    logic rx_start;
    logic [16:0] baud;
    logic [3:0] length;
    logic [7:0] tx_data;
    logic parity_en;
    logic parity_type;
    logic stop;
    logic tx_done;
    logic tx_error;
    logic rx_done;
    logic rx_error;
    logic [7:0] rx_out;
endinterface