module dff_tb;
    import uvm_pkg::*;
    import dff_pkg::*;

    reg clk;
    dff_if tif(clk);

    initial begin
        clk = 0;
        tif.rstn = 0;
    end

    always #5 clk = ~clk;

    dff dut(
        .clk(clk),
        .rstn(tif.rstn),
        .d(tif.d),
        .q(tif.q)
    );

    initial begin
        uvm_config_db #(virtual dff_if)::set(null, "*", "vif", tif);
        run_test("dff_test");
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end
endmodule