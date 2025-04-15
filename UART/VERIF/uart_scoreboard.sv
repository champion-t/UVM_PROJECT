class uart_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(uart_scoreboard)

    uart_sequence_item items_q[$];
    uart_sequence_item item;
    uvm_analysis_imp #(uart_sequence_item, uart_scoreboard) scb_port;

    logic [7:0] rx_data_chk;
    int nums_test = 0;
    int nums_pass = 0;
    int nums_fail = 0;

    function new(string name = "uart_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item = uart_sequence_item::type_id::create("item");
        scb_port = new("scb_port", this);
    endfunction

    virtual function void write(uart_sequence_item item);
        items_q.push_back(item);
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            wait(items_q.size());
            item = items_q.pop_front();
            check_uart(item);
        end
    endtask

    task check_uart(uart_sequence_item item);
        case(item.length)
            5: rx_data_chk = {3'b000, item.tx_data[4:0]};
            6: rx_data_chk = {2'b00, item.tx_data[5:0]};
            7: rx_data_chk = {1'b0, item.tx_data[6:0]};
            8: rx_data_chk = item.tx_data;
            default: rx_data_chk = item.tx_data;
        endcase

        `uvm_info("SCOREBOARD", $sformatf("BAUD=%0d LENGTH=%0d PARITY_EN=%0b PARITY_TYPE=%0b STOP=%0b TX_DATA=%b RX_DATA=%b", item.baud, item.length, item.parity_en, item.parity_type, item.stop, item.tx_data, item.rx_out), UVM_NONE)
        if(!item.rstn) begin
            `uvm_info("SCOREBOARD", "SYSTEM RESET", UVM_NONE)
        end
        else begin
            if(item.rx_out == rx_data_chk) begin
                `uvm_info("SCOREBOARD", "TEST PASSED", UVM_NONE)
                nums_test++;
                nums_pass++;
            end
            else begin
                `uvm_error("SCOREBOARD", "TEST FAILED")
                nums_test++;
                nums_fail++;
            end
        end
        `uvm_info("SCOREBOARD", $sformatf("[ACCURACY]: %0d%%", nums_pass*100/nums_test), UVM_NONE)
        $display("-------------------------------------------------------------------------------------------------------------------------------");
    endtask
endclass