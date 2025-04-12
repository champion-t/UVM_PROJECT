class dff_driver extends uvm_driver #(dff_sequence_item);
    `uvm_component_utils(dff_driver)

    virtual dff_if vif;
    dff_sequence_item item;

    function new(string name = "dff_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item = dff_sequence_item::type_id::create("item");

        if(!uvm_config_db #(virtual dff_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("DRIVER", "Unable to access uvm_config_db")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        reset();
        forever begin
            seq_item_port.get_next_item(item);
            drive_dff(item);
            seq_item_port.item_done();
        end
    endtask

    task reset();
        vif.clk  <= 1'b0;
        vif.rstn <= 1'b0;
        vif.d    <= 1'b0;
        repeat(2) @(posedge vif.clk);
        vif.rstn <= 1'b1;
        `uvm_info("DRIVER", "RESET DONE", UVM_NONE)
    endtask

    task drive_dff(dff_sequence_item item);
        @(posedge vif.clk);
        vif.d <= item.d;
        `uvm_info("DRIVER", $sformatf("Trigger DUT d = %0d", item.d), UVM_NONE)
    endtask
endclass