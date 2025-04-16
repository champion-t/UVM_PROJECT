class spi_monitor extends uvm_monitor;
    `uvm_component_utils(spi_monitor)

    virtual spi_if vif;
    spi_sequence_item item;
    uvm_analysis_port #(spi_sequence_item) mon_port;

    function new(string name = "spi_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item = spi_sequence_item::type_id::create("item");
        mon_port = new("mon_port", this);

        if(!uvm_config_db #(virtual spi_if)::get(this, "", "vif", vif)) begin
            `uvm_error("MONITOR", "Unable to access Interface")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            @(posedge vif.clk);
            if(!vif.rstn) begin
                item.mode = RST_DUT;
                `uvm_info("MONITOR", "SYDTEM RESET DETECTED", UVM_NONE)
                mon_port.write(item);
            end
            else if(vif.rstn && vif.wr) begin
                @(posedge vif.done);
                item.mode   = WRITE;
                item.addr   = vif.addr;
                item.din    = vif.din;
                item.error  = vif.error;
                `uvm_info("MONITOR", $sformatf("DATA WRITE ADDR = %0d, DIN = %0d ERROR = %0d", item.addr, item.din, item.error), UVM_NONE)
                mon_port.write(item);
            end
            else if(vif.rstn && !vif.wr) begin
                @(posedge vif.done);
                item.mode   = READ;
                item.addr   = vif.addr;
                item.dout   = vif.dout;
                item.error  = vif.error;
                `uvm_info("MONITOR", $sformatf("DATA READ ADDR = %0d, DOUT = %0d, ERROR = %0d", item.addr, item.dout, item.error), UVM_NONE)
                mon_port.write(item);
            end
        end
    endtask
endclass