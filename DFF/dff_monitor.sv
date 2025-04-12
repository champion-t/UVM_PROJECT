class dff_monitor extends uvm_monitor;
    `uvm_component_utils(dff_monitor)

    virtual dff_if vif;
    dff_sequence_item item;
    uvm_analysis_port #(dff_sequence_item) mon_port;

    function new(string name = "dff_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item = dff_sequence_item::type_id::create("item");
        mon_port = new("mon_port", this);

        if(!uvm_config_db #(virtual dff_if)::get(null, "", "vif", vif)) begin
            `uvm_fatal("MONITOR", "Unable to access uvm_config_db")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        @(posedge vif.rstn);
        forever begin
            @(posedge vif.clk);
            item.d = vif.d;
            @(posedge vif.clk);
            item.q = vif.q;
            `uvm_info("MONITOR", $sformatf("Data send to [SCOREBOARD] d = %0d q = %0d", item.d, item.q), UVM_NONE)
            mon_port.write(item);
        end
    endtask
endclass