module i2c_tb;
    import uvm_pkg::*;
    import i2c_pkg::*;

    logic clk;
    i2c_if tif(clk);

    i2c i2c_dut(
        .clk(clk),
        .rstn(tif.rstn),
        .wr(tif.wr),
        .addr(tif.addr),
        .din(tif.din),
        .datard(tif.datard),
        .done(tif.done)
    );

    initial begin
        clk = 0;
    end

    always #10 clk = ~clk;

    initial begin
        uvm_config_db #(virtual i2c_if)::set(null, "*", "vif", tif);
        run_test("i2c_test");
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end
endmodule