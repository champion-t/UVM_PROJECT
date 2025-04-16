module spi_tb;
    import uvm_pkg::*;
    import spi_pkg::*;

    logic clk;
    spi_if tif(clk);

    spi_top spi_dut(
        .clk(clk),
        .rstn(tif.rstn),
        .wr(tif.wr),
        .addr(tif.addr),
        .din(tif.din),
        .dout(tif.dout),
        .done(tif.done),
        .error(tif.error)
    );

    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    initial begin
        uvm_config_db #(virtual spi_if)::set(null, "*", "vif", tif);
        run_test("spi_test");
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end
endmodule