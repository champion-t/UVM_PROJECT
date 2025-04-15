class uart_sequence_item extends uvm_sequence_item;
    `uvm_object_utils(uart_sequence_item)

    rand logic  [16:0]  baud;
    rand logic  [3:0]   length;
    rand logic  [7:0]   tx_data;
    rand logic          parity_en;
    rand logic          parity_type;
    rand logic          stop;
    logic               rstn;
    logic               tx_start;
    logic               rx_start;
    logic               tx_done;
    logic               tx_error;
    logic               rx_done;
    logic               rx_error;
    logic       [7:0]   rx_out;

    function new(string name = "uart_sequence_item");
        super.new(name);
    endfunction

    constraint baudrate_default_c {
        baud inside {115200};
    };

    constraint baudrate_c {
        baud inside {4800, 9600, 14400, 19200, 38400, 57600, 115200};
    };

    constraint length_c {
        length inside {[5:8]};
    };
endclass