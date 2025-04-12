`ifndef ADDER_PKG
`define ADDER_PKG

package adder_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `include "adder_transaction.sv"
    `include "adder_sequence.sv"
    `include "adder_sequencer.sv"
    `include "adder_driver.sv"
    `include "adder_monitor.sv"
    `include "adder_agent.sv"
    `include "adder_scoreboard.sv"
    `include "adder_env.sv"
    `include "adder_test.sv"
endpackage
`endif