class i2c_driver extends uvm_driver #(i2c_sequence_item);
    `uvm_component_utils(i2c_driver)

    virtual i2c_if vif;
    i2c_sequence_item item;

    function new(string name = "i2c_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item = i2c_sequence_item::type_id::create("item");

        if(!uvm_config_db #(virtual i2c_if)::get(this, "", "vif", vif)) begin
            `uvm_error("DRIVER", "Unable to access Interface")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            drive_i2c();
        end
    endtask

    task drive_i2c();
        seq_item_port.get_next_item(item);
        if(item.mode == RST_DUT) begin
            reset_i2c();
        end
        else if(item.mode == WRITE) begin
            write_i2c();
        end
        else if(item.mode == READ) begin
            read_i2c();
        end
        seq_item_port.item_done();
    endtask

    task reset_i2c();
        `uvm_info("DRIVER", "SYSTEM RESET", UVM_NONE)
        vif.rstn <= 0;
        vif.wr   <= 0;
        vif.addr <= 0;
        vif.din  <= 0;
        @(posedge vif.clk);
    endtask

    task write_i2c();
        `uvm_info("DRIVER", $sformatf("[MODE: WRITE] ADDR = %0d, DIN = %0d", item.addr, item.din), UVM_NONE)
        vif.rstn <= 1;
        vif.wr   <= 1;
        vif.addr <= item.addr;
        vif.din  <= item.din;
        @(posedge vif.done);
    endtask

    task read_i2c();
        `uvm_info("DRIVER", $sformatf("[MODE: READ] ADDR = %0d, DIN = %0d", item.addr, item.din), UVM_NONE)
        vif.rstn <= 1;
        vif.wr   <= 0;
        vif.addr <= item.addr;
        vif.din  <= item.din;
        @(posedge vif.done);
    endtask
endclass