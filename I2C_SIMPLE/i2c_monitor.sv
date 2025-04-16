class i2c_monitor extends uvm_monitor;
    `uvm_component_utils(i2c_monitor)

    virtual i2c_if vif;
    i2c_sequence_item item;
    uvm_analysis_port #(i2c_sequence_item) mon_port;

    function new(string name = "i2c_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item = i2c_sequence_item::type_id::create("item");
        mon_port = new("mon_port", this);

        if(!uvm_config_db #(virtual i2c_if)::get(this, "", "vif", vif)) begin
            `uvm_error("MONITOR", "Unable to access Interface");
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            @(posedge vif.clk);
            if(!vif.rstn) begin
                item.mode = RST_DUT;
                `uvm_info("MONITOR", "SYSTEM RESET DETECTED", UVM_NONE)
                mon_port.write(item);
            end
            else begin
                if(vif.wr) begin
                    item.mode = WRITE;
                    item.wr   = 1;
                    item.addr = vif.addr;
                    item.din  = vif.din;
                    @(posedge vif.done);
                    item.datard = vif.datard;
                    `uvm_info("MONITOR", $sformatf("DATA WRITE ADDR = %0d, DIN = %0d", item.addr, item.din), UVM_NONE)
                    mon_port.write(item);
                end
                else begin
                    item.mode = READ;
                    item.wr   = 0;
                    item.addr = vif.addr;
                    item.din  = vif.din;
                    @(posedge vif.done);
                    item.datard = vif.datard;
                    `uvm_info("MONITOR", $sformatf("DATA READ ADDR = %0d, DATA = %0d", item.addr, item.datard), UVM_NONE)
                    mon_port.write(item);
                end
            end
        end
    endtask
endclass