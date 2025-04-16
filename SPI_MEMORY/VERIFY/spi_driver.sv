class spi_driver extends uvm_driver #(spi_sequence_item);
    `uvm_component_utils(spi_driver)

    virtual spi_if vif;
    spi_sequence_item item;

    function new(string name = "spi_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item = spi_sequence_item::type_id::create("item");

        if(!uvm_config_db #(virtual spi_if)::get(this, "", "vif", vif)) begin
            `uvm_error("DRIVER", "Unable to access Interface")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        reset_spi();
        drive_spi();
    endtask

    task reset_spi();
        vif.rstn    <= 0;
        vif.wr      <= 0;
        vif.addr    <= 0;
        vif.din     <= 0;
        `uvm_info("DRIVER", "SYSTEM RESET", UVM_NONE)
        @(posedge vif.clk);
    endtask

    task drive_spi();
        forever begin
            seq_item_port.get_next_item(item);
            if(item.mode == RST_DUT) begin
                vif.rstn <= 0;
                @(posedge vif.clk);
            end
            else if(item.mode == WRITE) begin
                vif.rstn    <= 1;
                vif.wr      <= 1;
                vif.addr    <= item.addr;
                vif.din     <= item.din;
                @(posedge vif.clk);
                `uvm_info("DRIVER", $sformatf("[MODE: WRITE]: ADDR = %0d, DIN = %0d", vif.addr, vif.din), UVM_NONE)
                @(posedge vif.done);
            end
            else if(item.mode == READ) begin
                vif.rstn    <= 1;
                vif.wr      <= 0;
                vif.addr    <= item.addr;
                vif.din     <= item.din;
                @(posedge vif.clk);
                `uvm_info("DRIVER", $sformatf("[MODE: READ] ADDR = %0d", vif.addr), UVM_NONE)
                @(posedge vif.done);
            end
            seq_item_port.item_done();
        end
    endtask
endclass