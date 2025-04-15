class uart_sequence extends uvm_sequence #(uart_sequence_item);
    `uvm_object_utils(uart_sequence)

    uart_sequence_item item;

    function new(string name = "uart_sequence");
        super.new(name);
    endfunction

    virtual task body();
        item = uart_sequence_item::type_id::create("item");
        start_item(item);
        // item.baudrate_default_c.constraint_mode(0);
        if(!item.randomize()) begin
            `uvm_error("SEQUENCE", "Randomization Failed")
        end
        item.rstn = 1'b1;
        item.tx_start = 1'b1;
        item.rx_start = 1'b1;
        finish_item(item);
    endtask
endclass