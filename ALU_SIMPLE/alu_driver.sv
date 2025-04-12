class alu_driver extends uvm_driver #(alu_sequence_item);
    `uvm_component_utils(alu_driver)

    virtual alu_if vif;
    alu_sequence_item item;

    function new(string name = "alu_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item = alu_sequence_item::type_id::create("item");

        if(!uvm_config_db #(virtual alu_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("DRIVER", "Unable to access uvm_config_db")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        reset();
        forever begin
            seq_item_port.get_next_item(item);
            drive_alu(item);
            seq_item_port.item_done();
            `uvm_info("DRIVER", $sformatf("Trigger DUT a = %0d b = %0d op_sel = %4b", item.a, item.b, item.op_sel), UVM_MEDIUM)
            repeat(2) @(posedge vif.clk);
        end
    endtask

    task reset();
        vif.clk    <= 0;
        vif.rstn   <= 0;
        vif.a      <= 0;
        vif.b      <= 0;
        vif.op_sel <= 0;
        repeat(2) @(posedge vif.clk);
        vif.rstn   <= 1;
        `uvm_info("DRIVER", "RESET DONE", UVM_MEDIUM)
    endtask

    task drive_alu(alu_sequence_item item);
        vif.a       <= item.a;
        vif.b       <= item.b;
        vif.op_sel  <= item.op_sel;
    endtask
endclass