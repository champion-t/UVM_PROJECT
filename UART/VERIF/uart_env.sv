class uart_env extends uvm_env;
    `uvm_component_utils(uart_env)

    uart_agent agent;
    uart_scoreboard scb;

    function new(string name = "uart_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = uart_agent::type_id::create("agent", this);
        scb = uart_scoreboard::type_id::create("scb", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.mon.mon_port.connect(scb.scb_port);
    endfunction
endclass