class adder_sequencer extends uvm_sequencer #(adder_transaction);
    `uvm_component_utils(adder_sequencer)

    function new(string name = "adder_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction
endclass