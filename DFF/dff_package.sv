`ifndef DFF_PACKAGE
`define DFF_PACKAGE

    package dff_pkg;
        import uvm_pkg::*;
        `include "uvm_macros.svh"
        `include "dff_sequence_item.sv"
        `include "dff_sequence.sv"
        `include "dff_sequencer.sv"
        `include "dff_driver.sv"
        `include "dff_monitor.sv"
        `include "dff_scoreboard.sv"
        `include "dff_agent.sv"
        `include "dff_env.sv"
        `include "dff_test.sv"
    endpackage
`endif 