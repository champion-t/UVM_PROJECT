class i2c_agent extends uvm_agent;
    `uvm_component_utils(i2c_agent)

    i2c_sequencer seqr;
    i2c_driver drv;
    i2c_monitor mon;

    function new(string name = "i2c_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        seqr = i2c_sequencer::type_id::create("seqr", this);
        drv = i2c_driver::type_id::create("drv", this);
        mon = i2c_monitor::type_id::create("mon", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction
endclass