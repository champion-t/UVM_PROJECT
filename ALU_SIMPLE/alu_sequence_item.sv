class alu_sequence_item extends uvm_sequence_item;
    `uvm_object_utils(alu_sequence_item)

    rand    bit [7:0]   a;
    rand    bit [7:0]   b;
    rand    bit [3:0]   op_sel;
            bit [15:0]  alu_out;
            bit         carry_out;

    function new(string name = "alu_sequence_item");
        super.new(name);
    endfunction

    constraint input_a_b {
        a inside {[0:255]};
        b inside {[0:255]};
    };

    constraint op_code {
        op_sel inside {[0:3]};
    };
endclass