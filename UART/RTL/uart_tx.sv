module uart_tx (
    input       tx_clk,
    input       rstn,
    input       tx_start,
    input [3:0] length,
    input [7:0] tx_data,
    input       parity_en,
    input       parity_type,
    input       stop,
    output reg  tx_done,
    output reg  tx_error,
    output reg  tx
);

    logic [7:0] tx_reg;
    logic start_bit = 0;
    logic stop_bit = 1;
    logic parity_bit = 0;
    int count = 0;

    typedef enum bit [2:0] {
        IDLE = 0,
        START_BIT = 1,
        SEND_DATA = 2,
        SEND_PARITY = 3,
        SEND_FIRST_STOP = 4,
        SEND_SECOND_STOP = 5,
        DONE = 6
    } state_uart_tx;

    state_uart_tx state = IDLE;
    state_uart_tx next_state = IDLE;

    always @(posedge tx_clk or negedge rstn) begin
        if(!rstn) begin
            state <= IDLE;
        end
        else begin
            state <= next_state;
        end
    end

    always @(posedge tx_clk or negedge rstn) begin
        if(parity_type) begin // odd parity
            case(length)
                5: parity_bit = ~^(tx_data[4:0]);
                6: parity_bit = ~^(tx_data[5:0]);
                7: parity_bit = ~^(tx_data[6:0]);
                8: parity_bit = ~^(tx_data[7:0]);
                default: parity_bit = 0;
            endcase
        end
        else begin // even parity
            case(length)
                5: parity_bit = ^(tx_data[4:0]);
                6: parity_bit = ^(tx_data[5:0]);
                7: parity_bit = ^(tx_data[6:0]);
                8: parity_bit = ^(tx_data[7:0]);
                default: parity_bit = 0;
            endcase
        end
    end

    always @(*) begin
        case(state)
            IDLE: begin
                tx_done  = 1'b0;
                tx       = 1'b1;
                tx_reg   = 8'h00;
                tx_error = 0;
                if(tx_start)
                    next_state = START_BIT;
                else
                    next_state = IDLE;
            end

            START_BIT: begin
                tx_reg = tx_data;
                tx = start_bit;
                next_state = SEND_DATA;
            end

            SEND_DATA: begin
                if(count < (length - 1)) begin
                    tx = tx_reg[count];
                    next_state = SEND_DATA;
                end
                else begin
                    if(parity_en) begin
                        tx = tx_reg[count];
                        next_state = SEND_PARITY;
                    end
                    else begin
                        tx = tx_reg[count];
                        next_state = SEND_FIRST_STOP;
                    end
                end
            end

            SEND_PARITY: begin
                tx = parity_bit;
                next_state = SEND_FIRST_STOP;
            end

            SEND_FIRST_STOP: begin
                tx = stop_bit;
                if(stop) begin // stop = 1 send 2 bit stop
                    next_state = SEND_SECOND_STOP;
                end
                else begin
                    next_state = DONE;
                end
            end

            SEND_SECOND_STOP: begin
                tx = stop_bit;
                next_state = DONE;
            end

            DONE: begin
                tx_done = 1;
                next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    always @(posedge tx_clk or negedge rstn) begin
        case(state)
            IDLE: begin
                count <= 0;
            end
            START_BIT: begin
                count <= 0;
            end
            SEND_DATA: begin
                count <= count + 1;
            end
            SEND_PARITY: begin
                count <= 0;
            end
            SEND_FIRST_STOP: begin
                count <= 0;
            end
            SEND_SECOND_STOP: begin
                count <= 0;
            end
            DONE: begin
                count <= 0;
            end
            default: begin
                count <= 0;
            end
        endcase
    end
endmodule