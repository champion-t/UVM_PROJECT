module spi_master (
    input           clk,
    input           rstn,
    input           wr,
    input           ready,
    input           op_done,
    input           miso,
    input [7:0]     addr,
    input [7:0]     din,
    output reg      mosi,
    output reg      cs,
    output reg      done,
    output reg      error,
    output [7:0]    dout
);
    logic [16:0] din_m;
    logic [7:0] dout_m;
    integer count = 0;

    typedef enum bit [2:0] {
        IDLE = 0,
        LOAD = 1,
        CHECK_MODE = 2,
        SEND_DATA = 3,
        SEND_ADDR = 4,
        READ_DATA = 5,
        ERROR = 6,
        CHECK_READY = 7
    } spi_master_state;
    spi_master_state state = IDLE;

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            state <= IDLE;
            count <= 0;
            cs <= 1;
            mosi <= 0;
            done <= 0;
            error <= 0;
        end
        else begin
            case(state)
                IDLE: begin
                    cs <= 1;
                    mosi <= 0;
                    state <= LOAD;
                    error <= 0;
                    done <= 0;
                end

                LOAD: begin
                    din_m <= {din, addr, wr};
                    state <= CHECK_MODE;
                end

                CHECK_MODE: begin
                    if(wr == 1'b1 && addr < 32) begin
                        cs <= 0;
                        state <= SEND_DATA;
                    end
                    else begin
                        if(wr == 1'b0 && addr < 32) begin
                            cs <= 0;
                            state <= SEND_ADDR;
                        end
                        else begin
                            state <= ERROR;
                            cs <= 1;
                        end
                    end
                end

                SEND_DATA: begin
                    if(count <= 16) begin
                        count <= count + 1;
                        mosi <= din_m[count];
                        state <= SEND_DATA;
                    end
                    else begin
                        cs <= 1;
                        mosi <= 0;
                        if(op_done) begin
                            count <= 0;
                            done <= 1;
                            state <= IDLE;
                        end
                        else begin
                            state <= SEND_DATA;
                        end
                    end
                end

                SEND_ADDR: begin
                    if(count <= 7) begin
                        count <= count + 1;
                        mosi <= din_m[count];
                        state <= SEND_ADDR;
                    end
                    else begin
                        count <= 0;
                        cs <= 1;
                        state <= CHECK_READY;
                    end
                end

                CHECK_READY: begin
                    if(ready)
                        state <= READ_DATA;
                    else
                        state <= CHECK_READY;
                end

                READ_DATA: begin
                    if(count <= 7) begin
                        count <= count + 1;
                        dout_m[count] <= miso;
                        state <= READ_DATA;
                    end
                    else begin
                        count <= 0;
                        done <= 1;
                        state <= IDLE;
                    end
                end

                ERROR: begin
                    state <= IDLE;
                    error <= 1;
                    done <= 1;
                    dout_m <= 0;
                end

                default: begin
                    state <= IDLE;
                    count <= 0;
                end
            endcase
        end
    end

    assign dout = dout_m;
endmodule