class alu_sequence extends uvm_sequence #(alu_sequence_item);
    `uvm_object_utils(alu_sequence)

    alu_sequence_item item;

    function new(string name = "alu_sequence");
        super.new(name);
    endfunction

    virtual task body();
        item = alu_sequence_item::type_id::create("item");
        start_item(item);
        if(!item.randomize()) begin
            `uvm_error("SEQUENCE", "Randomize Failed")
        end
        `uvm_info("SEQUENCE", $sformatf("Data send to [DRIVER] a = %0d b = %0d op_sel = %4b", item.a, item.b, item.op_sel), UVM_MEDIUM)
        finish_item(item);
    endtask
endclass