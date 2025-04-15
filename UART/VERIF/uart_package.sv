`ifndef UART_PACKAGE
`define UART_PACKAGE

    package uart_pkg;
        import uvm_pkg::*;
        `include "uvm_macros.svh"
        `include "uart_config.sv"
        `include "uart_sequence_item.sv"
        `include "uart_sequence.sv"
        `include "uart_sequencer.sv"
        `include "uart_driver.sv"
        `include "uart_monitor.sv"
        `include "uart_scoreboard.sv"
        `include "uart_agent.sv"
        `include "uart_env.sv"
        `include "uart_test.sv"
    endpackage
`endif 