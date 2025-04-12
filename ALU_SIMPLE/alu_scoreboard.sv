class alu_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(alu_scoreboard)

    alu_sequence_item item_cmp;
    alu_sequence_item items[$];
    uvm_analysis_imp #(alu_sequence_item, alu_scoreboard) scb_port;

    int nums_test = 0;
    int nums_pass = 0;
    int nums_fail = 0;

    function new(string name = "alu_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item_cmp = alu_sequence_item::type_id::create("item_cmp");
        scb_port = new("scb_port", this);
    endfunction

    virtual function void write(alu_sequence_item item);
        items.push_back(item);
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            wait(items.size() != 0);
            item_cmp = items.pop_front();
            `uvm_info("SCOREBOARD", $sformatf("Data received from [MONITOR] a = %0d b = %0d op_sel = %4b alu_out = %0d carry_out = %b", item_cmp.a, item_cmp.b, item_cmp.op_sel, item_cmp.alu_out, item_cmp.carry_out), UVM_MEDIUM)
            check_alu(item_cmp);
        end
    endtask

    task check_alu(alu_sequence_item item_cmp);
        logic [15:0] alu_chk;
        logic [8:0]  carry_chk;

        case(item_cmp.op_sel)
            4'b0000: alu_chk = item_cmp.a + item_cmp.b;
            4'b0001: alu_chk = item_cmp.a - item_cmp.b;
            4'b0010: alu_chk = item_cmp.a * item_cmp.b;
            4'b0011: alu_chk = item_cmp.a / item_cmp.b;
            default: alu_chk = 16'h1507;
        endcase

        carry_chk = item_cmp.a + item_cmp.b;

        if(alu_chk == item_cmp.alu_out) begin
            `uvm_info("SCOREBOARD", "TEST PASSED", UVM_MEDIUM)
            nums_test++;
            nums_pass++;
        end
        else begin
            `uvm_error("SCOREBOARD", "TEST FAILED")
            nums_test++;
            nums_fail++;
        end

        if(carry_chk[8] == item_cmp.carry_out) begin
            `uvm_info("SCOREBOARD", "TEST PASSED", UVM_MEDIUM)
            nums_test++;
            nums_pass++;
        end
        else begin
            `uvm_error("SCOREBOARD", "TEST FAILED")
            nums_test++;
            nums_fail++;
        end

        `uvm_info("SCOREBOARD", $sformatf("[ACCURACY] %0d", nums_pass*100/nums_test), UVM_MEDIUM)
    endtask
endclass