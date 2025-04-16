class spi_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(spi_scoreboard)

    spi_sequence_item item_q[$];
    spi_sequence_item item;
    uvm_analysis_imp #(spi_sequence_item, spi_scoreboard) scb_port;

    logic [7:0] arr[32] = '{default:0};
    logic [7:0] data_rd = 0;

    function new(string name = "spi_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item = spi_sequence_item::type_id::create("item");
        scb_port = new("scb_port", this);
    endfunction

    virtual function void write(spi_sequence_item item);
        item_q.push_back(item);
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            wait(item_q.size());
            item = item_q.pop_front();
            check_spi(item);
        end
    endtask

    task check_spi(spi_sequence_item item);
        if(item.mode == RST_DUT) begin
            `uvm_info("SCOREBOARD", "SYSTEM RESET DETECTED", UVM_NONE)
        end
        else if(item.mode == WRITE) begin
            if(item.error) begin
                `uvm_info("SCOREBOARD", "SLAVE ERROR DURING WRITE OP", UVM_NONE)
            end
            else begin
                arr[item.addr] = item.din;
                `uvm_info("SCOREBOARD", $sformatf("DATA WRITE ADDR = %0d, DIN = %0d, ARR_WRITE = %0d", item.addr, item.din, arr[item.addr]), UVM_NONE)
            end
        end
        else if(item.mode == READ) begin
            if(item.error) begin
                `uvm_info("SCOREBOARD", "SLAVE ERROR DURING WRITE OP", UVM_NONE)
            end
            else begin
                data_rd = arr[item.addr];
                if(data_rd == item.dout) begin
                    `uvm_info("SCOREBOARD", $sformatf("TEST PASSED: ADDR = %0d, DOUT = %0d", item.addr, item.dout), UVM_NONE)
                end
                else begin
                    `uvm_error("SCOREBOARD", $sformatf("TEST FAILED: ADDR = %0d, DOUT = %0d DATA_READ_ARR = %0d", item.addr, item.dout, data_rd))
                end
            end
        end
        $display("-------------------------------------------------------------------------------------------------------------------------------------------");
    endtask
endclass