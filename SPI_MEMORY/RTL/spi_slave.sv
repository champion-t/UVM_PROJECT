module spi_slave (
    input       clk,
    input       rstn,
    input       cs,
    input       mosi,
    output reg op_done,
    output reg ready,
    output reg miso
);

    logic [7:0] mem [31:0] = '{default:0};
    integer count = 0;
    logic [15:0] din_s;
    logic [7:0] dout_s;

    typedef enum bit [2:0] {
        IDLE = 0,
        DETECT = 1,
        STORE = 2,
        READ_ADDR = 3,
        SEND_DATA = 4
    } i2c_slave_state;
    i2c_slave_state state = IDLE;

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            count <= 0;
            // cs <= 1;
            miso <= 0;
            ready <= 0;
            op_done <= 0;
            state <= IDLE;
        end
        else begin
            case(state)
                IDLE: begin
                    count <= 0;
                    miso <= 0;
                    ready <= 0;
                    op_done <= 0;
                    din_s <= 0;

                    if(!cs) begin
                        state <= DETECT;
                    end
                    else begin
                        state <= IDLE;
                    end
                end

                DETECT: begin
                    if(mosi)
                        state <= STORE;
                    else
                        state <= READ_ADDR;
                end

                STORE: begin
                    if(count <= 15) begin
                        din_s[count] <= mosi;
                        count <= count + 1;
                        state <= STORE;
                    end
                    else begin
                        count <= 0;
                        mem[din_s[7:0]] <= din_s[15:8];
                        state <= IDLE;
                        op_done <= 1;
                    end
                end

                READ_ADDR: begin
                    if(count <= 7) begin
                        count <= count + 1;
                        din_s[count] <= mosi;
                        state <= READ_ADDR;
                    end
                    else begin
                        count <= 0;
                        state <= SEND_DATA;
                        ready <= 1;
                        dout_s <= mem[din_s];
                    end
                end

                SEND_DATA: begin
                    ready <= 0;
                    if(count < 8) begin
                        miso <= dout_s[count];
                        count <= count + 1;
                        state <= SEND_DATA;
                    end
                    else begin
                        count <= 0;
                        state <= IDLE;
                        op_done <= 1;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end
endmodule