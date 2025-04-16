class i2c_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(i2c_scoreboard)

    i2c_sequence_item item_q[$];
    i2c_sequence_item item;
    uvm_analysis_imp #(i2c_sequence_item, i2c_scoreboard) scb_port;

    logic [7:0] mem_data[128] = '{default:0};
    logic [7:0] data_rd = 0;

    function new(string name = "i2c_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item = i2c_sequence_item::type_id::create("item");
        scb_port = new("scb_port", this);
    endfunction

    virtual function void write(i2c_sequence_item item);
        item_q.push_back(item);
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            wait(item_q.size());
            item = item_q.pop_front();
            check_i2c(item);
        end
    endtask

    task check_i2c(i2c_sequence_item item);
        if(item.mode == RST_DUT) begin
            `uvm_info("SCOREBOARD", "SYSTEM RESET", UVM_NONE)
        end
        else begin
            if(item.mode == WRITE) begin
                mem_data[item.addr] = item.din;
                `uvm_info("SCOREBOARD", $sformatf("DATA WRITE ADDR = %0d, DIN = %0d, MEM_DATA_WR = %0d", item.addr, item.din, mem_data[item.addr]), UVM_NONE)
            end
            else if(item.mode == READ) begin
                data_rd = mem_data[item.addr];
                if(item.datard == data_rd) begin
                    `uvm_info("SCOREBOARD", $sformatf("TEST PASSED: ADDR = %0d, DATA_READ = %0d, DATA_MEM = %0d", item.addr, item.datard, data_rd), UVM_NONE)
                end
                else begin
                    `uvm_error("SCOREBOARD", $sformatf("TEST FAILED: ADDR = %0d, DATA_READ = %0d, DATA_MEM = %0d", item.addr, item.datard, data_rd))
                end
            end
        end
        $display("----------------------------------------------------------------------------------------------------------------------------------------------");
    endtask
endclass