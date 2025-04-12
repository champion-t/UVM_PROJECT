class adder_env extends uvm_env;
    `uvm_component_utils(adder_env)

    adder_agent agent;
    adder_scoreboard scb;

    function new(string name = "adder_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = adder_agent::type_id::create("agent", this);
        scb = adder_scoreboard::type_id::create("scb", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.mon.mon_port.connect(scb.scb_export);
    endfunction
endclass