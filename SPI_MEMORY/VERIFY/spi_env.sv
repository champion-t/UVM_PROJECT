class spi_env extends uvm_env;
    `uvm_component_utils(spi_env)

    spi_scoreboard scb;
    spi_agent agent;

    function new(string name = "spi_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        scb = spi_scoreboard::type_id::create("scb", this);
        agent = spi_agent::type_id::create("agent", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.mon.mon_port.connect(scb.scb_port);
    endfunction
endclass