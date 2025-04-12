class adder_sequence extends uvm_sequence #(adder_transaction);
    `uvm_object_utils(adder_sequence)

    adder_transaction t;

    function new(string name = "adder_sequence");
        super.new(name);
    endfunction

    virtual task body();
        repeat (10) begin
            t = adder_transaction::type_id::create("t");
            start_item(t);
            t.randomize();
            `uvm_info("SEQUENCE", $sformatf("Data send to [DRIVER] a = %0d b = %0d", t.a, t.b), UVM_NONE)
            finish_item(t);
        end
    endtask
endclass