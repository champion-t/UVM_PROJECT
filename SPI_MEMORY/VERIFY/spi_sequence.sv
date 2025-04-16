class spi_sequence_reset extends uvm_sequence #(spi_sequence_item);
    `uvm_object_utils(spi_sequence_reset)

    spi_sequence_item item;

    function new(string name = "spi_sequence_reset");
        super.new(name);
    endfunction

    virtual task body();
        item = spi_sequence_item::type_id::create("item");
        start_item(item);
        assert(item.randomize());
        item.mode = RST_DUT;
        finish_item(item);
    endtask
endclass

class spi_sequence_write extends uvm_sequence #(spi_sequence_item);
    `uvm_object_utils(spi_sequence_write)

    spi_sequence_item item;

    function new(string name = "spi_sequence_write");
        super.new(name);
    endfunction

    virtual task body();
        item = spi_sequence_item::type_id::create("item");
        start_item(item);
        assert(item.randomize());
        item.mode = WRITE;
        finish_item(item);
    endtask
endclass

class spi_sequence_read extends uvm_sequence #(spi_sequence_item);
    `uvm_object_utils(spi_sequence_read)

    spi_sequence_item item;

    function new(string name = "spi_sequence_read");
        super.new(name);
    endfunction

    virtual task body();
        item = spi_sequence_item::type_id::create("item");
        start_item(item);
        assert(item.randomize());
        item.mode = READ;
        finish_item(item);
    endtask
endclass