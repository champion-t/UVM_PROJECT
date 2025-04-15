module uart_tb;
    import uvm_pkg::*;
    import uart_pkg::*;
    
    reg clk;
    uart_if tif(clk);

    uart_top uart_dut (
        .clk(clk),
        .rstn(tif.rstn),
        .tx_start(tif.tx_start),
        .rx_start(tif.rx_start),
        .baud(tif.baud),
        .length(tif.length),
        .tx_data(tif.tx_data),
        .parity_en(tif.parity_en),
        .parity_type(tif.parity_type),
        .stop(tif.stop),
        .tx_done(tif.tx_done),
        .tx_error(tif.tx_error),
        .rx_done(tif.rx_done),
        .rx_error(tif.rx_error),
        .rx_out(tif.rx_out)
    );

    initial begin
        clk <= 0;
    end

    always #10 clk = ~clk;

    initial begin
        uvm_config_db #(virtual uart_if)::set(null, "*", "vif", tif);
        run_test("uart_test");
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end
endmodule