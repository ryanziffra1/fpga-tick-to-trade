`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: N/A
// Engineer: Ryan W. Ziffra
// 
// Create Date: 09/26/2026 02:00:27 PM
// Design Name: 
// Module Name: uart_rx
// Project Name: FPGA Tick-to-Trade
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision: 2
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_rx (
    input  wire clk,        // 100 MHz onboard clock
    input  wire rst,        // reset button
    input  wire rx,         // serial data in (from your laptop)
    output reg  [7:0] data,  // the received byte
    output reg  data_valid   // pulses high for 1 clock cycle when a new byte is ready

);

        // Baud rate timing
    parameter CLK_FREQ  = 100_000_000;
    parameter BAUD_RATE = 9600;
    parameter CYCLES_PER_BIT = CLK_FREQ / BAUD_RATE; // ~10417

    reg [13:0] clk_count = 0;  // counts clock cycles within one bit period
    
    
    // State machine states
    localparam IDLE = 3'd0;
    localparam START = 3'd1;
    localparam DATA = 3'd2;
    localparam STOP = 3'd3;
    
    reg [0:2] state = IDLE;
    reg [2:0] bit_index = 0; //tracks which of 8 bits we r on
    reg [7:0] rx_shift = 0;  //shifts bits as they r reveived
    
        always @(posedge clk) begin
        if (rst) begin
            state      <= IDLE;
            data_valid <= 0;
            clk_count  <= 0;
            bit_index  <= 0;
            
        end else begin
            data_valid <= 0;  // default: only pulses high for 1 cycle when we say so explicitly

            case (state)
                IDLE: begin
                    // TODO: watch for start bit
                    if (rx == 0) begin 
                        clk_count <= 0;
                        state <= START;
                    end
                end

                START: begin
                    // TODO: confirm start bit, then begin sampling data bits
                    
                    if (clk_count >= (CYCLES_PER_BIT / 2)) begin
                        if (rx == 0) begin 
                            clk_count <= 0;
                            state <= DATA;
                        end
                        else begin
                            state <= IDLE;
                        end
                    end
                    else begin
                        clk_count <= clk_count + 1;
                    end
  
                end

                DATA: begin
                    // TODO: sample 8 data bits one at a time
                    if (clk_count >= CYCLES_PER_BIT) begin
                        rx_shift <= {rx, rx_shift[7:1]};
                        clk_count <= 0;
                        bit_index <= bit_index + 1;
                        if (bit_index >= 7) begin
                            state <= STOP;
                        end
                     end
                     else begin
                        clk_count <= clk_count + 1;
                     end

                end

                STOP: begin
                    // TODO: confirm stop bit, finish byte
                    if (clk_count >= CYCLES_PER_BIT) begin
                        data <= rx_shift;
                        data_valid <= 1;
                        bit_index <= 0;
                        state <= IDLE;
                    end
                    else begin
                        clk_count <= clk_count + 1;
                     end
                    
                end
            endcase
        end
    end
    
    
    
    
    
    
    
    
endmodule
