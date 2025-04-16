class i2c_test extends uvm_test;
    `uvm_component_utils(i2c_test)

    i2c_sequence_reset seq_reset;
    i2c_sequence_write seq_write;
    i2c_sequence_read seq_read;
    i2c_env env;

    function new(string name = "i2c_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = i2c_env::type_id::create("seqr", this);
        seq_reset = i2c_sequence_reset::type_id::create("seq_reset", this);
        seq_write = i2c_sequence_write::type_id::create("seq_write", this);
        seq_read = i2c_sequence_read::type_id::create("seq_read", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        seq_reset.start(env.agent.seqr);
        repeat(128) begin
            seq_write.start(env.agent.seqr);
        end
        repeat(128) begin
            seq_read.start(env.agent.seqr);
        end
        phase.drop_objection(this);
    endtask
endclass