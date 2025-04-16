class spi_test extends uvm_test;
    `uvm_component_utils(spi_test)

    spi_sequence_reset seq_reset;
    spi_sequence_write seq_write;
    spi_sequence_read seq_read;
    spi_env env;

    function new(string name = "spi_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        seq_reset = spi_sequence_reset::type_id::create("seq_reset", this);
        seq_write = spi_sequence_write::type_id::create("seq_write", this);
        seq_read = spi_sequence_read::type_id::create("seq_read", this);
        env = spi_env::type_id::create("env", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        // seq_reset.start(env.agent.seqr);
        repeat(10) begin
            seq_write.start(env.agent.seqr);
        end
        #20;
        repeat(10) begin
            seq_read.start(env.agent.seqr);
        end
        #20;
        phase.drop_objection(this);
    endtask
endclass