class uart_driver extends uvm_driver #(uart_sequence_item);
    `uvm_component_utils(uart_driver)

    virtual uart_if vif;
    uart_sequence_item item;

    function new(string name = "uart_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item = uart_sequence_item::type_id::create("item");

        if(!uvm_config_db #(virtual uart_if)::get(this, "", "vif", vif)) begin
            `uvm_error("DRIVER", "Unable to access Interface");
        end
    endfunction

    task reset_dut();
        vif.rstn        <=  1'b0;
        vif.tx_start    <=  1'b0;
        vif.rx_start    <=  1'b0;
        vif.tx_data     <=  8'h00;
        vif.baud        <=  17'h0;
        vif.length      <=  4'h0;
        vif.parity_en   <=  1'b0;
        vif.parity_type <=  1'b0;
        vif.stop        <=  1'b0;
        `uvm_info("DRIVER", "SYSTEM RESET : Start of Simulation", UVM_NONE)
        @(posedge vif.clk);
    endtask

    task drive_uart();
        reset_dut();
        forever begin
            seq_item_port.get_next_item(item);
            vif.rstn        <=  item.rstn;
            vif.baud        <=  item.baud;
            vif.length      <=  item.length;
            vif.tx_data     <=  item.tx_data;
            vif.parity_en   <=  item.parity_en;
            vif.parity_type <=  item.parity_type;
            vif.stop        <=  item.stop;
            vif.tx_start    <=  item.tx_start;
            vif.rx_start    <=  item.rx_start;
            `uvm_info("DRIVER", $sformatf("BAUD=%0d LENGTH=%0d TX_DATA=%b PARITY_EN=%0b PARITY_TYPE=%0b STOP=%0b", item.baud, item.length, item.tx_data, item.parity_en, item.parity_type, item.stop), UVM_NONE)
            @(posedge vif.clk);
            @(posedge vif.tx_done);
            @(negedge vif.rx_done);
            seq_item_port.item_done();
        end
    endtask

    virtual task run_phase(uvm_phase phase);
        drive_uart();
    endtask
endclass