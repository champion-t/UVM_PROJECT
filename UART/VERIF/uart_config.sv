class uart_config extends uvm_object;
    `uvm_object_utils(uart_config)

    uvm_active_passive_enum is_active = UVM_ACTIVE;

    function new(string name = "uart_config");
        super.new(name);
    endfunction
endclass