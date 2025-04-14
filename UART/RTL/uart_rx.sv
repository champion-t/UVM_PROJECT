module uart_rx (
    input            rx_clk,
    input            rstn,
    input            rx,
    input            rx_start,
    input [3:0]      length,
    input            parity_en,
    input            parity_type,
    input            stop,
    output reg       rx_done,
    output reg       rx_error,
    output reg [7:0] rx_out
);

    logic parity = 0;
    logic [7:0] datard;
    int count = 0;
    int bit_count = 0;

    typedef enum bit [3:0] {
        IDLE = 0,
        START_BIT = 1,
        RECV_DATA = 2,
        CHECK_PARITY = 3,
        CHECK_FIRST_STOP = 4,
        CHECK_SECOND_STOP = 5,
        DONE = 6
    } state_uart_rx;
    state_uart_rx state = IDLE;
    state_uart_rx next_state = IDLE;

    always @(posedge rx_clk or negedge rstn) begin
        if(!rstn) begin
            state <= IDLE;
        end
        else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case(state)
            IDLE: begin
                rx_done = 0;
                rx_error = 0;
                if(rx_start && !rx) begin
                    next_state = START_BIT;
                end
                else begin
                    next_state = IDLE;
                end
            end

            START_BIT: begin
                if(count == 7 && rx) begin
                    next_state = IDLE;
                end
                else begin
                    if(count == 15) begin
                        next_state = RECV_DATA;
                    end
                    else begin
                        next_state = START_BIT;
                    end
                end
            end

            RECV_DATA: begin
                if(count == 7) begin
                    datard[7:0] = {rx, datard[7:1]}; 
                end
                else begin
                    if(count == 15 && bit_count == length - 1) begin
                        case(length)
                            5: rx_out = datard[7:3];
                            6: rx_out = datard[7:2];
                            7: rx_out = datard[7:1];
                            8: rx_out = datard[7:0];
                            default: rx_out = 8'h00;
                        endcase
                        
                        if(parity_type) begin
                            parity = ~^datard;
                        end
                        else begin
                            parity = ^datard;
                        end

                        if(parity_en) begin
                            next_state = CHECK_PARITY;
                        end
                        else begin
                            next_state = CHECK_FIRST_STOP;
                        end
                    end
                    else begin
                        next_state = RECV_DATA;
                    end
                end
            end

            CHECK_PARITY: begin
                if (count == 7) begin
                    if(rx == parity) begin
                        rx_error = 1'b0;
                    end
                    else begin
                        rx_error = 1'b1;
                    end
                end
                else begin
                    if(count == 15) begin
                        next_state = CHECK_FIRST_STOP;
                    end
                    else begin
                        next_state = CHECK_PARITY;
                    end
                end
            end

            CHECK_FIRST_STOP: begin
                if(count == 7) begin
                    if(!rx) begin
                        rx_error = 1'b1;
                    end
                    else begin
                        rx_error = 1'b0;
                    end
                end
                else begin
                    if(count == 15) begin
                        if(stop) begin
                            next_state = CHECK_SECOND_STOP;
                        end
                        else begin
                            next_state = DONE;
                        end
                    end
                end
            end

            CHECK_SECOND_STOP: begin
                if(count == 7) begin
                    if(!rx) begin
                        rx_error = 1'b1;
                    end
                    else begin
                        rx_error = 1'b0;
                    end
                end
                else begin
                    if(count == 15) begin
                        next_state = DONE;
                    end
                    else begin
                        next_state = CHECK_SECOND_STOP;
                    end
                end
            end

            DONE: begin
                rx_done = 1'b1;
                next_state = IDLE;
                rx_error = 1'b0;
            end
        endcase
    end

    always @(posedge rx_clk or negedge rstn) begin
        case(state)
            IDLE: begin
                count <= 0;
                bit_count <= 0;
            end

            START_BIT: begin
                if(count < 15)
                    count <= count + 1;
                else
                    count <= 0;
            end

            RECV_DATA: begin
                if(count < 15) begin
                    count <= count + 1;
                end
                else begin
                    count <= 0;
                    bit_count <= bit_count + 1;
                end
            end

            CHECK_PARITY: begin
                if(count < 15)
                    count <= count + 1;
                else
                    count <= 0;
            end

            CHECK_FIRST_STOP: begin
                if(count < 15)
                    count <= count + 1;
                else
                    count <= 0;
            end

            CHECK_SECOND_STOP: begin
                if(count < 15)
                    count <= count + 1;
                else
                    count <= 0;
            end

            DONE: begin
                count <= 0;
                bit_count <= 0;
            end
        endcase
    end
endmodule