class dff_sequence extends uvm_sequence #(dff_sequence_item);
    `uvm_object_utils(dff_sequence)

    dff_sequence_item item;

    function new(string name = "dff_sequence");
        super.new(name);
    endfunction

    virtual task body();
        repeat (20) begin
            item = dff_sequence_item::type_id::create("item");
            start_item(item);
            item.randomize();
            `uvm_info("SEQUENCE", $sformatf("Data send to [DRIVER] d = %0d", item.d), UVM_NONE)
            finish_item(item);
        end
    endtask
endclass