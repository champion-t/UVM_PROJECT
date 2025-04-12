class dff_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(dff_scoreboard)

    dff_sequence_item item_chk;
    uvm_analysis_imp #(dff_sequence_item, dff_scoreboard) scb_port;

    function new(string name = "dff_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item_chk = dff_sequence_item::type_id::create("item_chk");
        scb_port = new("scb_port", this);
    endfunction

    virtual function void write(dff_sequence_item item);
        item_chk = item;
        `uvm_info("SCOREBOARD", $sformatf("Data received from [MONITOR] d = %0d, q = %0d", item.d, item.q), UVM_NONE)

        if(item_chk.q == item_chk.d) begin
            `uvm_info("SCOREBOARD", "TEST PASSED", UVM_NONE)
        end
        else begin
            `uvm_error("SCOREBOARD", "TEST FAILED")
        end
    endfunction
endclass