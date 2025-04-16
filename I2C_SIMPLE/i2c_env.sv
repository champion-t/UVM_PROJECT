class i2c_env extends uvm_env;
    `uvm_component_utils(i2c_env)

    i2c_scoreboard scb;
    i2c_agent agent;

    function new(string name = "i2c_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        scb = i2c_scoreboard::type_id::create("scb", this);
        agent = i2c_agent::type_id::create("agent", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.mon.mon_port.connect(scb.scb_port);
    endfunction
endclass