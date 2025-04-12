class adder_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(adder_scoreboard)

    int nums_test = 0;
    int nums_pass = 0;
    int nums_fail = 0;

    uvm_analysis_imp #(adder_transaction, adder_scoreboard) scb_export;
    adder_transaction trans;

    function new(string name = "adder_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        trans = adder_transaction::type_id::create("trans");
        scb_export = new("scb_export", this);
    endfunction

    virtual function void write(adder_transaction t);
        trans = t;
        `uvm_info("SCOREBOARD", $sformatf("Data received from [MONITOR] a = %0d b = %0d y = %0d", t.a, t.b, t.y), UVM_NONE)

        if(trans.y == trans.a + trans.b) begin
            `uvm_info("SCOREBOARD", "TEST PASSED", UVM_NONE)
            nums_test++;
            nums_pass++;
        end
        else begin
            `uvm_info("SCOREBOARD", "TEST FAILED", UVM_NONE)
            nums_test++;
            nums_fail++;
        end

        `uvm_info("SCOREBOARD", $sformatf("[ACCURACY] = %2d%%", nums_pass*100/nums_test), UVM_NONE)
    endfunction
endclass