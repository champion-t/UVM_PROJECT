class spi_agent extends uvm_agent;
    `uvm_component_utils(spi_agent)

    spi_sequencer seqr;
    spi_driver drv;
    spi_monitor mon;
    spi_config cfg;

    function new(string name = "spi_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cfg = spi_config::type_id::create("cfg", this);
        mon = spi_monitor::type_id::create("mon", this);

        if(cfg.is_active == UVM_ACTIVE) begin
            seqr = spi_sequencer::type_id::create("seqr", this);
            drv = spi_driver::type_id::create("drv", this);
        end
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(cfg.is_active == UVM_ACTIVE) begin
            drv.seq_item_port.connect(seqr.seq_item_export);
        end
    endfunction
endclass