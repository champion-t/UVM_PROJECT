module uart_clk (
    input           clk,
    input           rstn,
    input [16:0]    baud,
    output reg      tx_clk,
    output reg      rx_clk
);

    int tx_count = 0;
    int tx_max = 0;
    int rx_count = 0;
    int rx_max = 0;

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            tx_max <= 0;
            rx_max <= 0;
        end
        else begin
            case(baud)
                4800: begin
                    tx_max <= 10416;
                    rx_max <= 651;
                end
                9600: begin
                    tx_max <= 5208;
                    rx_max <= 325;
                end
                14400: begin
                    tx_max <= 3472;
                    rx_max <= 217;
                end
                19200: begin
                    tx_max <= 2604;
                    rx_max <= 162;
                end
                38400: begin
                    tx_max <= 1302;
                    rx_max <= 81;
                end
                57600: begin
                    tx_max <= 868;
                    rx_max <= 54;
                end
                115200: begin
                    tx_max <= 434;
                    rx_max <= 27;
                end
                default: begin
                    tx_max <= 434;
                    rx_max <= 28;
                end
            endcase
        end
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            rx_max <= 0;
            rx_count <= 0;
            rx_clk <= 0;
        end
        else begin
            if(rx_count < rx_max - 1) begin
                rx_clk <= 1'b0;
                rx_count <= rx_count + 1;
            end
            else begin
                rx_clk <= 1'b1;
                rx_count <= 0;
            end
        end
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            tx_max <= 0;
            tx_count <= 0;
            tx_clk <= 0;
        end
        else begin
            if(tx_count < tx_max - 1) begin
                tx_clk <= 1'b0;
                tx_count <= tx_count + 1;
            end
            else begin
                tx_clk <= 1'b1;
                tx_count <= 0;
            end
        end
    end
endmodule