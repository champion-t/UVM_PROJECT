module alu_tb;
    import uvm_pkg::*;
    import alu_pkg::*;

    reg clk;
    alu_if tif(clk);

    alu dut(
        .clk(clk),
        .rstn(tif.rstn),
        .a(tif.a),
        .b(tif.b),
        .op_sel(tif.op_sel),
        .alu_out(tif.alu_out),
        .carry_out(tif.carry_out)
    );

    initial begin
        clk = 0;
        tif.rstn = 0;
    end

    always #5 clk = ~clk;

    initial begin
        uvm_config_db #(virtual alu_if)::set(null, "*", "vif", tif);
        run_test("alu_test");
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end
endmodule