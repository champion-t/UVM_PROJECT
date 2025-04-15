class uart_test extends uvm_test;
    `uvm_component_utils(uart_test)

    uart_sequence seq;
    uart_env env;

    function new(string name = "uart_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        seq = uart_sequence::type_id::create("seq", this);
        env = uart_env::type_id::create("env", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        repeat(100) begin
            seq.start(env.agent.seqr);
        end
        #20;
        phase.drop_objection(this);
    endtask
endclass