module i2c (
    input           clk,
    input           rstn,
    input           wr,
    input   [6:0]   addr,
    input   [7:0]   din,
    output  [7:0]   datard,
    output  reg     done
);

    // Master
    wire sda;
    logic scl;
    logic [7:0] addr_m;
    logic [7:0] temp_rd;
    logic en;
    logic sda_m;
    integer count_m = 0;

    // Slave
    logic [7:0] mem [128];
    integer count_s = 0;
    logic [7:0] addr_s;
    logic [7:0] data_rd;
    logic [7:0] data_s;
    logic sda_s;
    logic update;

    typedef enum bit [3:0] {
        IDLE = 0,
        START = 1,
        SEND_ADDR = 2,
        GET_ACK1 = 3,
        SEND_DATA = 4,
        GET_ACK2 = 5,
        READ_DATA = 6,
        COMPLETE = 7,
        GET_ADDR = 8,
        SEND_ACK1 = 9,
        GET_DATA = 10,
        SEND_ACK2 = 11
    } i2c_state;
    i2c_state state_m;
    i2c_state state_s;

    // State Master
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            addr_m  <=  0;
            temp_rd <=  0;
            en      <=  0;
            sda_m   <=  0;
            count_m <=  0;
        end
        else begin
            case(state_m)
                IDLE: begin
                    en      <=  1'b1;
                    scl     <=  1'b1;
                    sda_m   <=  1'b1;
                    state_m <=  START;
                    count_m <=  0;
                    done    <=  1'b0;
                    temp_rd <=  0;
                end

                START: begin
                    sda_m   <=  1'b0;
                    addr_m  <=  {wr,addr};
                    state_m <=  SEND_ADDR;
                end

                SEND_ADDR: begin
                    if(count_m <= 7) begin
                        sda_m   <=  addr_m[count_m];
                        count_m <=  count_m + 1;
                    end
                    else begin
                        state_m <=  GET_ACK1;
                        count_m <=  0;
                        en      <=  1'b0;
                    end
                end

                GET_ACK1: begin
                    if(sda == 1'b0) begin
                        if(wr == 1'b1) begin
                            state_m <=  SEND_DATA;
                            en      <=  1'b1;
                        end
                        else if(wr == 1'b0) begin
                            state_m <=  READ_DATA;
                            en      <=  1'b0;
                        end
                    end
                    else begin
                        state_m <= GET_ACK1;
                    end
                end

                SEND_DATA: begin
                    if(count_m <= 7) begin
                        sda_m   <=  din[count_m];
                        count_m   <=  count_m + 1;
                    end
                    else begin
                        state_m <=  GET_ACK2;
                        count_m   <=  0;
                        en      <=  1'b0;
                    end
                end

                GET_ACK2: begin
                    if(sda == 1'b0) begin
                        state_m <= COMPLETE;
                    end
                    else begin
                        state_m <= GET_ACK2;
                    end
                end

                READ_DATA: begin
                    if(count_m <= 9) begin
                        temp_rd[7:0] <= {sda,temp_rd[7:1]};
                        count_m <= count_m + 1;
                    end
                    else begin
                        state_m <= COMPLETE;
                        count_m <= 0;
                    end
                end

                COMPLETE: begin
                    if(update) begin
                        done  <= 1'b1;
                        state_m <= IDLE;
                    end
                    else begin
                        state_m <= COMPLETE;
                    end
                end

                default: state_m <= IDLE;
            endcase
        end
    end

    // State Slave
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            for(int i = 0; i < 128; i++) begin
                mem[i] <= 0;
            end
            addr_s <= 0;
            data_s <= 0;
            update <= 0;
        end
        else begin
            case(state_s)
                IDLE: begin
                    addr_s  <= 0;
                    data_s  <= 0;
                    update  <= 0;
                    data_rd <= 0;

                    if(scl && sda_m) begin
                        state_s <= START;
                    end
                    else begin
                        state_s <= IDLE;
                    end
                end

                START: begin
                    if(scl && !sda_m) begin
                        state_s <= GET_ADDR;
                    end
                    else begin
                        state_s <= START;
                    end
                end

                GET_ADDR: begin
                    if(count_s <= 7) begin
                        addr_s[count_s] <= sda_m;
                        count_s <= count_s + 1;
                    end
                    else begin
                        state_s <= SEND_ACK1;
                        count_s <= 0;
                        if(addr_s[7] == 1'b0) begin
                            data_rd <= mem[addr_s[6:0]];
                        end
                    end
                end

                SEND_ACK1: begin
                    sda_s <= 1'b0;
                    if(addr_s[7] == 1'b1 && state_m == SEND_DATA) begin
                        state_s <= GET_DATA;
                    end
                    else begin
                        if(addr_s[7] == 1'b0 && state_m == READ_DATA)
                            state_s <= SEND_DATA;
                        else
                            state_s <= SEND_ACK1;
                    end
                end

                GET_DATA: begin
                    if(count_s <= 7) begin
                        data_s[count_s] <= sda_m;
                        count_s <= count_s + 1;
                    end
                    else begin
                        state_s <= SEND_ACK2;
                        count_s <= 0;
                        mem[addr_s[6:0]] <= data_s;
                    end
                end

                SEND_ACK2: begin
                    sda_s <= 1'b0;
                    state_s <= COMPLETE;
                end

                SEND_DATA: begin
                    if(count_s <= 7) begin
                        sda_s <= data_rd[count_s];
                        count_s <= count_s + 1;
                    end
                    else begin
                        state_s <= COMPLETE;
                        count_s <= 0;
                    end
                end

                COMPLETE: begin
                    update <= 1'b1;
                    state_s <= IDLE;
                end

                default: state_s <= IDLE;
            endcase
        end
    end

    assign sda = (en == 1'b1) ? sda_m : sda_s;
    assign datard = temp_rd;
endmodule