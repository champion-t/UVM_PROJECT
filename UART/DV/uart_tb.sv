module uart_tb;
    reg clk;
    uart_if tif(clk);

    always #10 clk = ~clk;

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
        $dumpfile("dump.vcd");
        $dumpvars;
    end

    initial begin
        clk = 0;
        tif.rstn = 0;
        #868;
        tif.rstn = 1;
        tif.baud = 115200;
        tif.parity_en = 1;
        tif.length = 8;
        tif.parity_type = 1;
        tif.stop = 0;
        tif.tx_start = 0;
        #868;
        tif.tx_start = 1;
        tif.tx_data = 8'b10101010;
        tif.rx_start = 1;
        @(posedge clk);
        @(posedge tif.tx_done);
        @(posedge tif.rx_done);
        $display("RX DATA = %8b", tif.rx_out);

        #(868*2);
        tif.tx_data = 8'b11111110;
        @(posedge clk);
        @(posedge tif.tx_done);
        @(posedge tif.rx_done);
        $display("RX DATA = %8b", tif.rx_out);

        #(868*2);
        tif.length = 6;
        tif.tx_data = 8'b11101010;
        @(posedge clk);
        @(posedge tif.tx_done);
        @(posedge tif.rx_done);
        $display("RX DATA = %8b", tif.rx_out);

        #(868*2);
        tif.length = 5;
        tif.tx_data = 8'b11010110;
        @(posedge clk);
        @(posedge tif.tx_done);
        @(posedge tif.rx_done);
        $display("RX DATA = %8b", tif.rx_out);
        
        #(868*20);
        $finish();
    end
endmodule