class spi_sequence_item extends uvm_sequence_item;
    `uvm_object_utils(spi_sequence_item)

    logic               rstn;
    logic               wr;
    randc logic [7:0]   addr;
    rand  logic [7:0]   din;
    logic               done;
    logic               error;
    logic       [7:0]   dout;
    rand spi_mode       mode;

    function new(string name = "spi_sequence_item");
        super.new(name);
    endfunction

    constraint addr_c {
        addr inside {[0:10]};
    };
endclass