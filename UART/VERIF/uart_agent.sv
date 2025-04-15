class uart_agent extends uvm_agent;
    `uvm_component_utils(uart_agent)

    uart_config cfg;
    uart_sequencer seqr;
    uart_driver drv;
    uart_monitor mon;

    function new(string name = "uart_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cfg = uart_config::type_id::create("cfg", this);
        mon = uart_monitor::type_id::create("mon", this);
        if(cfg.is_active == UVM_ACTIVE) begin
            seqr = uart_sequencer::type_id::create("seqr", this);
            drv = uart_driver::type_id::create("drv", this);
        end
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(cfg.is_active == UVM_ACTIVE) begin
            drv.seq_item_port.connect(seqr.seq_item_export);
        end
    endfunction
endclass