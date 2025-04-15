class uart_monitor extends uvm_monitor;
    `uvm_component_utils(uart_monitor)

    virtual uart_if vif;
    uart_sequence_item item;
    uvm_analysis_port #(uart_sequence_item) mon_port;

    function new(string name = "uart_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item = uart_sequence_item::type_id::create("item");
        mon_port = new("mon_port", this);

        if(!uvm_config_db #(virtual uart_if)::get(this, "", "vif", vif)) begin
            `uvm_error("MONITOR", "Unable to access Interface")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            @(posedge vif.clk);
            if(!vif.rstn) begin
                item.rstn = 1'b0;
                `uvm_info("MONITOR", "SYSTEM RESET DETECTED", UVM_NONE)
                mon_port.write(item);
            end
            else begin
                @(posedge vif.tx_done);
                item.rstn           =   vif.rstn;
                item.baud           =   vif.baud;
                item.length         =   vif.length;
                item.tx_data        =   vif.tx_data;
                item.parity_en      =   vif.parity_en;
                item.parity_type    =   vif.parity_type;
                item.stop           =   vif.stop;
                item.tx_start       =   vif.tx_start;
                item.rx_start       =   vif.rx_start;
                @(negedge vif.rx_done);
                item.tx_error       =   vif.tx_error;
                item.rx_error       =   vif.rx_error;
                item.rx_out         =   vif.rx_out;
                `uvm_info("MONITOR", $sformatf("BAUD=%0d LENGTH=%0d TX_DATA=%b PARITY_EN=%0b PARITY_TYPE=%0b STOP=%0b TX_ERROR=%0b RX_ERROR=%0b", item.baud, item.length, item.tx_data, item.parity_en, item.parity_type, item.stop, item.tx_error, item.rx_error), UVM_NONE)
                mon_port.write(item);
            end
        end
    endtask
endclass