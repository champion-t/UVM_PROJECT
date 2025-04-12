`ifndef ALU_PACKAGE
`define ALU_PACKAGE

    package alu_pkg;
        import uvm_pkg::*;
        `include "uvm_macros.svh"
        `include "alu_sequence_item.sv"
        `include "alu_sequence.sv"
        `include "alu_sequencer.sv"
        `include "alu_driver.sv"
        `include "alu_monitor.sv"
        `include "alu_scoreboard.sv"
        `include "alu_agent.sv"
        `include "alu_env.sv"
        `include "alu_test.sv"
    endpackage
`endif 