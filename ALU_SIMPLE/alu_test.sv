class alu_test extends uvm_test;
    `uvm_component_utils(alu_test)

    alu_sequence seq;
    alu_env env;

    function new(string name = "alu_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        seq = alu_sequence::type_id::create("seq", this);
        env = alu_env::type_id::create("env", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        repeat(50) begin
            seq.start(env.agent.seqr);
        end
        #20;
        phase.drop_objection(this);
    endtask
endclass