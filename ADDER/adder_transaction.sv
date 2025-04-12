class adder_transaction extends uvm_sequence_item;
    rand    bit [4:0] a;
    rand    bit [4:0] b;
            bit [5:0] y;
    
    function new(string name = "adder_transaction");
        super.new(name);
    endfunction

    `uvm_object_utils_begin(adder_transaction)
        `uvm_field_int(a, UVM_DEFAULT)
        `uvm_field_int(b, UVM_DEFAULT)
        `uvm_field_int(y, UVM_DEFAULT)
    `uvm_object_utils_end
endclass