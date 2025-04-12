class dff_sequence_item extends uvm_sequence_item;
    `uvm_object_utils(dff_sequence_item)

    rand    bit d;
            bit q;
    
    function new(string name = "dff_sequence_item");
        super.new(name);
    endfunction
endclass