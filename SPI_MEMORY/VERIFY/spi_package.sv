`ifndef SPI_PACKAGE
`define SPI_PACKAGE

package spi_pkg;
    typedef enum bit [2:0] {
        RST_DUT = 0,
        WRITE = 1,
        READ = 2
    } spi_mode;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `include "spi_config.sv"
    `include "spi_sequence_item.sv"
    `include "spi_sequence.sv"
    `include "spi_sequencer.sv"
    `include "spi_driver.sv"
    `include "spi_monitor.sv"
    `include "spi_scoreboard.sv"
    `include "spi_agent.sv"
    `include "spi_env.sv"
    `include "spi_test.sv"
endpackage
`endif