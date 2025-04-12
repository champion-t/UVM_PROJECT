class alu_monitor extends uvm_monitor;
    `uvm_component_utils(alu_monitor)

    virtual alu_if vif;
    alu_sequence_item item;
    uvm_analysis_port #(alu_sequence_item) mon_port;

    function new(string name = "alu_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item = alu_sequence_item::type_id::create("item");
        mon_port = new("mon_port", this);

        if(!uvm_config_db #(virtual alu_if)::get(this, "", "vif", vif)) begin
            `uvm_error("MONITOR", "Unable to access uvm_config_db")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        @(posedge vif.rstn);
        forever begin
            @(posedge vif.clk);
            item.a = vif.a;
            item.b = vif.b;
            item.op_sel = vif.op_sel;
            @(posedge vif.clk);
            item.alu_out = vif.alu_out;
            item.carry_out = vif.carry_out;
            `uvm_info("MONITOR", $sformatf("Data send to [SCORBOARD] a = %0d b = %0d op_sel = %4b alu_out = %0d carry_out = %b", item.a, item.b, item.op_sel, item.alu_out, item.carry_out), UVM_MEDIUM)
            mon_port.write(item);
        end
    endtask
endclass