module adder_tb;
    import uvm_pkg::*;
    import adder_pkg::*;

    adder_if tif();

    initial begin
        tif.clk = 0;
        tif.rstn = 0;
    end

    always #10 tif.clk = ~tif.clk;

    adder dut(
        .clk(tif.clk),
        .rstn(tif.rstn),
        .a(tif.a),
        .b(tif.b),
        .y(tif.y)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end

    initial begin
        uvm_config_db #(virtual adder_if)::set(null, "uvm_test_top.env.agent*", "vif", tif);
        run_test("adder_test");
    end
endmodule