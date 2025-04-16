class i2c_sequence_reset extends uvm_sequence #(i2c_sequence_item);
    `uvm_object_utils(i2c_sequence_reset)

    i2c_sequence_item item;

    function new(string name = "i2c_sequence_reset");
        super.new(name);
    endfunction

    virtual task body();
        item = i2c_sequence_item::type_id::create("item");
        start_item(item);
        assert(item.randomize());
        item.mode = RST_DUT;
        `uvm_info("SEQUENCE", "[MODE: RESET]", UVM_NONE)
        finish_item(item);
    endtask
endclass

class i2c_sequence_write extends uvm_sequence #(i2c_sequence_item);
    `uvm_object_utils(i2c_sequence_write)

    i2c_sequence_item item;

    function new(string name = "i2c_sequence_write");
        super.new(name);
    endfunction

    virtual task body();
        item = i2c_sequence_item::type_id::create("item");
        start_item(item);
        assert(item.randomize());
        item.mode = WRITE;
        `uvm_info("SEQUENCE", $sformatf("[MODE: WRITE] ADDR = %0d, DIN = %0d", item.addr, item.din), UVM_NONE)
        finish_item(item);
    endtask
endclass

class i2c_sequence_read extends uvm_sequence #(i2c_sequence_item);
    `uvm_object_utils(i2c_sequence_read)

    i2c_sequence_item item;

    function new(string name = "i2c_sequence_read");
        super.new(name);
    endfunction

    virtual task body();
        item = i2c_sequence_item::type_id::create("item");
        start_item(item);
        assert(item.randomize());
        item.mode = READ;
        `uvm_info("SEQUENCE", $sformatf("[MODE: READ] ADDR = %0d", item.addr), UVM_NONE)
        finish_item(item);
    endtask
endclass