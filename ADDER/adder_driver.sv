class adder_driver extends uvm_driver #(adder_transaction);
    `uvm_component_utils(adder_driver)

    virtual adder_if vif;
    adder_transaction t;

    function new(string name = "adder_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        t = adder_transaction::type_id::create("t");

        if(!uvm_config_db #(virtual adder_if)::get(this, "", "vif", vif)) begin
            `uvm_error("DRIVER", "Unable to access uvm_config_db")
        end
    endfunction

    task reset();
        vif.rstn <= 1'b0;
        vif.a    <= 1'b0;
        vif.b    <= 1'b0;
        repeat(5) @(posedge vif.clk);
        vif.rstn <= 1'b1;
        `uvm_info("DRIVER", $sformatf("Reset DONE"), UVM_NONE)
    endtask

    virtual task run_phase(uvm_phase phase);
        reset();
        forever begin
            seq_item_port.get_next_item(t);
            vif.a <= t.a;
            vif.b <= t.b;
            `uvm_info("DRIVER", $sformatf("Trigger DUT a = %0d b = %0d", t.a, t.b), UVM_NONE)
            seq_item_port.item_done();
            repeat(2) @(posedge vif.clk);
        end
    endtask
endclass