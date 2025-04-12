class adder_monitor extends uvm_monitor;
    `uvm_component_utils(adder_monitor)

    virtual adder_if vif;
    adder_transaction t;
    uvm_analysis_port #(adder_transaction) mon_port;

    function new(string name = "adder_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        t = adder_transaction::type_id::create("t");
        mon_port = new("mon_port", this);

        if(!uvm_config_db #(virtual adder_if)::get(this, "", "vif", vif)) begin
            `uvm_error("MONITOR", "Unable to access uvm_config_db")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        @(posedge vif.rstn);
        forever begin
            repeat(2) @(posedge vif.clk);
            t.a = vif.a;
            t.b = vif.b;
            t.y = vif.y;
            `uvm_info("MONITOR", $sformatf("Data send to [SCOREBOARD] a = %0d b = %0d y = %0d", t.a, t.b, t.y), UVM_NONE)
            mon_port.write(t);
        end
    endtask
endclass