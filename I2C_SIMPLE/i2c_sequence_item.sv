class i2c_sequence_item extends uvm_sequence_item;
    `uvm_object_utils(i2c_sequence_item)

    i2c_mode                mode;
    logic                   wr;
    randc   logic   [6:0]   addr;
    rand    logic   [7:0]   din;
    logic           [7:0]   datard;
    logic                   done;

    function new(string name = "i2c_sequence_item");
        super.new(name);
    endfunction
endclass