`ifndef I2C_PACKAGE
`define I2C_PACKAGE

package i2c_pkg;
    typedef enum bit [2:0] {
        READ = 0,
        WRITE = 1,
        RST_DUT = 2
    } i2c_mode;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `include "i2c_sequence_item.sv"
    `include "i2c_sequence.sv"
    `include "i2c_sequencer.sv"
    `include "i2c_driver.sv"
    `include "i2c_monitor.sv"
    `include "i2c_scoreboard.sv"
    `include "i2c_agent.sv"
    `include "i2c_env.sv"
    `include "i2c_test.sv"
endpackage
`endif