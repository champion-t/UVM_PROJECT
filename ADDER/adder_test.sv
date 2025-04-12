class adder_test extends uvm_test;
    `uvm_component_utils(adder_test)

    adder_env env;
    adder_sequence seq;

    function new(string name = "adder_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = adder_env::type_id::create("env", this);
        seq = adder_sequence::type_id::create("seq", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        seq.start(env.agent.seqr);
        #40;
        phase.drop_objection(this);
    endtask
endclass